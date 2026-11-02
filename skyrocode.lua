local loadTimer = {c = (tick or(os and os.clock) or function()
  return 0
end)};
loadTimer.t = loadTimer.c();
loadTimer.line = function(p)
  if game then
    pcall(function()
      print("[skyr0] loading " .. string.rep(".", 1 + math.floor(p / 20)) .. " " .. p .. "%")
    end)
  end
end;
loadTimer.line(0);
pcall(function()
  local sp = (task and task.spawn) or spawn
  local wt = (task and task.wait) or wait
  if sp and wt then
    sp(function()
      local p = 0
      while not loadTimer.done
      do
        if p < 90 then
          p = p + 10 loadTimer.line(p)
        end
        wt(0.08)
      end
    end)
  end
end);
if game and not game:IsLoaded() then
  game.Loaded:Wait()
end
do
  local gf, sf = getfenv, setfenv
  if type(gf) == "function" and type(sf) == "function" then
    local real = gf(1)
    if type(real) == "table" then
      local ok, p = pcall(setmetatable, {}, {__index = real, __newindex = function(_, k, v)
        real[k] = v
      end, __metatable = "", __tostring = function()
        return "function: builtin"
      end})
      if ok and type(p) == "table" then
        sf(1, p)
      end
    end
  end
end
if workspace and Instance then
  if(workspace):FindFirstChild("s8df9c41e0b77b5") then
    return
  end;
  pcall(function()
    local _ae3289_c5d5da0 = Instance["new"]("Part", workspace);
    _ae3289_c5d5da0["Name"] = "s8df9c41e0b77b5";
    _ae3289_c5d5da0["Transparency"] = 1;
    _ae3289_c5d5da0["Anchored"] = true;
    _ae3289_c5d5da0["CanCollide"] = false;
    _ae3289_c5d5da0["CanTouch"] = false;
    _ae3289_c5d5da0["CanQuery"] = false
  end)
end;
local _ae3289_c5d5da1 = "";
local _ae3289_c5d5da2 = "";
local _ae3289_c5d5da3 = {"bce8e812988b463aa3b3c8f9975d80c9.lY_QIoWp_yxa7F5PhaKnPNIK",};
local genv = (typeof(getgenv) == "function" and getgenv()) or _G;
local _ae3289_c5d5da5;
for _ae3289_c5d5da6, _ae3289_c5d5da7 in ipairs({rawget(genv, "request") or request, rawget(genv, "http_request") or http_request, syn and syn["request"], http and http["request"], fluxus and fluxus["request"],
  })
do
  if type(_ae3289_c5d5da7) == "function" then
    _ae3289_c5d5da5 = _ae3289_c5d5da7;
    break
  end
end;
local _ae3289_c5d5da9 = cloneref or function(_ae3289_c5d5da8)
  return _ae3289_c5d5da8
end;
local function getService(_ae3289_c5d5dab)
  local _ae3289_c5d5dac, _ae3289_c5d5dad = pcall(function()
    return(game):GetService(_ae3289_c5d5dab)
  end);
  if not _ae3289_c5d5dac or not _ae3289_c5d5dad then
    return nil
  end;
  local _ae3289_c5d5dae, _ae3289_c5d5daf = pcall(_ae3289_c5d5da9, _ae3289_c5d5dad);
  if _ae3289_c5d5dae and _ae3289_c5d5daf then
    return _ae3289_c5d5daf
  end;
  return _ae3289_c5d5dad
end;
-- ===== Roblox services =====
local Players = getService("Players");
local ReplicatedStorage = getService("ReplicatedStorage");
local RunService = getService("RunService");
local UserInputService = getService("UserInputService");
local HttpService = getService("HttpService");
local TweenService = getService("TweenService");
local CoreGui = getService("CoreGui");
local TextChatService = getService("TextChatService");
local Lighting = getService("Lighting");
local LocalPlayer = Players["LocalPlayer"];
if not LocalPlayer then
  ((Players):GetPropertyChangedSignal("LocalPlayer")):Wait();
  LocalPlayer = Players["LocalPlayer"]
end;
local PlayerGui = (LocalPlayer):WaitForChild("PlayerGui");
local _ae3289_c5d5dar = genv;
if _ae3289_c5d5dar["Skyr0Stop"] then
  pcall(_ae3289_c5d5dar["Skyr0Stop"])
end;
if _ae3289_c5d5dar["StopAura"] then
  pcall(_ae3289_c5d5dar["StopAura"])
end;
local _ae3289_c5d5das = (debug and debug["getupvalues"]) or getupvalues;
local _ae3289_c5d5dat = getconnections or(debug and debug["getconnections"]);
local _ae3289_c5d5dau = (debug and debug["setupvalue"]) or setupvalue;
-- ===== Persistent settings and AI configuration =====
local configFile = "skyr0wtf_code_redeemer.json";
local learnedFile = "skyr0wtf_learned.json";
local contextFile = "skyr0wtf_context.json";
local settings = {["sniper"] = true, ["autoSubmit"] = true, ["submitAfter"] = 3, ["retypeInvalid"] = false, ["answerMode"] = "both", ["riddler"] = true, ["autoSwitch"] = true, ["engineV"] = 2,
  ["tryVariants"] = true, ["activeEvent"] = "", ["directRemote"] = true, ["aiRace"] = 2,};
local aiConfig = {["cloudUrl"] = "https://ollama.com/api/chat", ["tagsUrl"] = "https://ollama.com/api/tags", ["meUrl"] = "https://ollama.com/api/me", ["model"] = "gpt-oss:120b", ["models"] = {"gpt-oss:120b",
  "gemma4:31b"}, ["hedgeAfter"] = 1.5, ["timeout"] = 14, ["devNames"] = {"spydersammy", "do_small", "sammy"},};
pcall(function()
  if type(isfile) == "function" and type(readfile) == "function" and isfile(configFile) then
    local _ae3289_c5d5da10 = (HttpService):JSONDecode(readfile(configFile));
    if type(_ae3289_c5d5da10) == "table" then
      if _ae3289_c5d5da10["engineV"] ~= 2 then
        _ae3289_c5d5da10["answerMode"], _ae3289_c5d5da10["engineV"] = "both", 2
      end;
      for _ae3289_c5d5da11, _ae3289_c5d5da12 in pairs(settings)
      do
        local _ae3289_c5d5da13 = _ae3289_c5d5da10[_ae3289_c5d5da11];
        if type(_ae3289_c5d5da13) == type(_ae3289_c5d5da12) then
          settings[_ae3289_c5d5da11] = _ae3289_c5d5da13
        end
      end;
      settings["submitAfter"] = math["clamp"](math["floor"](tonumber(settings["submitAfter"]) or 3), 1, 10);
      settings["aiRace"] = math["clamp"](math["floor"](tonumber(settings["aiRace"]) or 2), 1, 3)
    end
  end
end);
settings["sniper"], settings["riddler"] = false, false;
local function saveSettings()
  if type(writefile) ~= "function" then
    return
  end;
  pcall(function()
    writefile(configFile, (HttpService):JSONEncode(settings))
  end)
end;
local UI_NAME = "skyr0wtf_CodeRedeemer";
local state = {["seen"] = {}, ["capturedParts"] = {}, ["lastBox"] = nil, ["focused"] = nil, ["round"] = nil, ["lastWatchedBox"] = nil, ["lastNonBlankText"] = "", ["boxTextConn"] = nil,
  ["boxAncestryConn"] = nil, ["pendingText"] = nil, ["pendingBox"] = nil, ["pendingUntil"] = 0, ["pendingToken"] = 0, ["solvedCount"] = 0, ["askedCount"] = 0, ["riddleQueue"] = {}, ["riddleBusy"] = false,
  ["connections"] = {}, ["alive"] = true,};
local ownGui;
local _ae3289_c5d5da18, _ae3289_c5d5da19;
local _ae3289_c5d5da1a;
local _ae3289_c5d5da1b, _ae3289_c5d5da1c, _ae3289_c5d5da1d;
local _ae3289_c5d5da1e, _ae3289_c5d5da1f;
local _ae3289_c5d5da1g, _ae3289_c5d5da1h, _ae3289_c5d5da1i;
local _ae3289_c5d5da1j, _ae3289_c5d5da1k;
local colors;
local apiKeys;
local _ae3289_c5d5da1n, _ae3289_c5d5da1o, _ae3289_c5d5da1p, _ae3289_c5d5da1q;
local _ae3289_c5d5da1r, _ae3289_c5d5da1s, _ae3289_c5d5da1t, _ae3289_c5d5da1u, _ae3289_c5d5da1v, _ae3289_c5d5da1w;
local _ae3289_c5d5da1x, _ae3289_c5d5da1y, _ae3289_c5d5da1z;
local _ae3289_c5d5da20;
local _ae3289_c5d5da21, _ae3289_c5d5da22, _ae3289_c5d5da23;
local function _ae3289_c5d5da24(_ae3289_c5d5da25)
  state["connections"][#state["connections"] + 1] = _ae3289_c5d5da25;
  return _ae3289_c5d5da25
end;
local function _ae3289_c5d5da26(_ae3289_c5d5da27)
  return(((tostring(_ae3289_c5d5da27 or "")):gsub("^%s+", "")):gsub("%s+$", ""))
end;
local function _ae3289_c5d5da28(_ae3289_c5d5da29)
  if type(_ae3289_c5d5da29) ~= "string" then
    return tostring(_ae3289_c5d5da29)
  end;
  return((_ae3289_c5d5da29):gsub("<[^>]->", ""))
end;
local function _ae3289_c5d5da2a(_ae3289_c5d5da2b)
  return((((tostring(_ae3289_c5d5da2b or "")):upper()):gsub("%s+", "")):gsub("[%?%.%,!\"'`\n\r]", ""))
end;
local function _ae3289_c5d5da2c(_ae3289_c5d5da2d)
  return(((tostring(_ae3289_c5d5da2d or "")):upper()):gsub("[^A-Z0-9]", ""))
end;
local function _ae3289_c5d5da2e(_ae3289_c5d5da2f)
  return((((tostring(_ae3289_c5d5da2f or "")):gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))
end;
local function _ae3289_c5d5da2g(_ae3289_c5d5da2h, _ae3289_c5d5da2i, _ae3289_c5d5da2j)
  local _ae3289_c5d5da2k, _ae3289_c5d5da2l = (_ae3289_c5d5da2h):find(_ae3289_c5d5da2i, 1, true);
  if not _ae3289_c5d5da2k then
    return _ae3289_c5d5da2h
  end;
  return(_ae3289_c5d5da2h):sub(1, _ae3289_c5d5da2k - 1) .. _ae3289_c5d5da2j .. (_ae3289_c5d5da2h):sub(_ae3289_c5d5da2l + 1)
end;
local _ae3289_c5d5da2m = {["\""] = "\\\"", ["\\"] = "\\\\", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t"};
-- ===== JSON / text helpers =====
local function _ae3289_c5d5da2n(_ae3289_c5d5da2o)
  local _ae3289_c5d5da2p = type(_ae3289_c5d5da2o);
  if _ae3289_c5d5da2p == "string" then
    return "\"" .. ((_ae3289_c5d5da2o):gsub("[%c\"\\]", function(_ae3289_c5d5da2q)
      return _ae3289_c5d5da2m[_ae3289_c5d5da2q] or string["format"]("\\u%04x", (_ae3289_c5d5da2q):byte())
    end)) .. "\""
  elseif _ae3289_c5d5da2p == "number" then
    if _ae3289_c5d5da2o ~= _ae3289_c5d5da2o or _ae3289_c5d5da2o == math["huge"] or _ae3289_c5d5da2o == -math["huge"] then
      return "0"
    end;
    if _ae3289_c5d5da2o == math["floor"](_ae3289_c5d5da2o) then
      return string["format"]("%d", _ae3289_c5d5da2o)
    end;
    return tostring(_ae3289_c5d5da2o)
  elseif _ae3289_c5d5da2p == "boolean" then
    return _ae3289_c5d5da2o and "true" or "false"
  elseif _ae3289_c5d5da2p == "table" then
    if #_ae3289_c5d5da2o > 0 or next(_ae3289_c5d5da2o) == nil then
      local _ae3289_c5d5da2r = {};
      for _ae3289_c5d5da2s = 1, #_ae3289_c5d5da2o
      do
        _ae3289_c5d5da2r[_ae3289_c5d5da2s] = _ae3289_c5d5da2n(_ae3289_c5d5da2o[_ae3289_c5d5da2s])
      end;
      return "[" .. table["concat"](_ae3289_c5d5da2r, ",") .. "]"
    end;
    local _ae3289_c5d5da2t = {};
    for _ae3289_c5d5da2u, _ae3289_c5d5da2v in pairs(_ae3289_c5d5da2o)
    do
      _ae3289_c5d5da2t[#_ae3289_c5d5da2t + 1] = _ae3289_c5d5da2n(tostring(_ae3289_c5d5da2u)) .. ":" .. _ae3289_c5d5da2n(_ae3289_c5d5da2v)
    end;
    return "{" .. table["concat"](_ae3289_c5d5da2t, ",") .. "}"
  end;
  return "null"
end;
local function _ae3289_c5d5da2w(_ae3289_c5d5da2x)
  local _ae3289_c5d5da2y, _ae3289_c5d5da2z = pcall(function()
    return(HttpService):JSONDecode(_ae3289_c5d5da2x)
  end);
  if _ae3289_c5d5da2y then
    return _ae3289_c5d5da2z
  end;
  return nil
end;
local _ae3289_c5d5da30;
do
  local _ae3289_c5d5da31 = {"JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"};
  local _ae3289_c5d5da32 = {"SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"};
  local function _ae3289_c5d5da33(_ae3289_c5d5da34, _ae3289_c5d5da35, _ae3289_c5d5da36)
    local _ae3289_c5d5da37 = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if _ae3289_c5d5da35 < 3 then
      _ae3289_c5d5da34 = _ae3289_c5d5da34 - 1
    end;
    return(_ae3289_c5d5da34 + math["floor"](_ae3289_c5d5da34 / 4) - math["floor"](_ae3289_c5d5da34 / 100) + math["floor"](_ae3289_c5d5da34 / 400) + _ae3289_c5d5da37[_ae3289_c5d5da35] + _ae3289_c5d5da36) % 7
  end;
  local function _ae3289_c5d5da38(_ae3289_c5d5da39, _ae3289_c5d5da3a, _ae3289_c5d5da3b)
    local _ae3289_c5d5da3c = _ae3289_c5d5da33(_ae3289_c5d5da39, _ae3289_c5d5da3a, 1);
    return 1 + ((7 - _ae3289_c5d5da3c) % 7) + (_ae3289_c5d5da3b - 1) * 7
  end;
  function _ae3289_c5d5da30()
    local _ae3289_c5d5da3d = os["time"]();
    local _ae3289_c5d5da3e = os["date"]("!*t", _ae3289_c5d5da3d);
    local _ae3289_c5d5da3f = _ae3289_c5d5da38(_ae3289_c5d5da3e["year"], 3, 2);
    local _ae3289_c5d5da3g = _ae3289_c5d5da38(_ae3289_c5d5da3e["year"], 11, 1);
    local _ae3289_c5d5da3h = (_ae3289_c5d5da3e["month"] > 3 and _ae3289_c5d5da3e["month"] < 11) or(_ae3289_c5d5da3e["month"] == 3 and(_ae3289_c5d5da3e["day"] > _ae3289_c5d5da3f or(_ae3289_c5d5da3e["day"] == _ae3289_c5d5da3f and _ae3289_c5d5da3e["hour"] >= 7))) or(_ae3289_c5d5da3e["month"] == 11 and(_ae3289_c5d5da3e["day"] < _ae3289_c5d5da3g or(_ae3289_c5d5da3e["day"] == _ae3289_c5d5da3g and _ae3289_c5d5da3e["hour"] < 6)));
    local _ae3289_c5d5da3i = _ae3289_c5d5da3h and -4 or -5;
    local _ae3289_c5d5da3j = os["date"]("!*t", _ae3289_c5d5da3d + _ae3289_c5d5da3i * 3600);
    _ae3289_c5d5da3j["zone"] = _ae3289_c5d5da3h and "EDT" or "EST";
    _ae3289_c5d5da3j["monthName"] = _ae3289_c5d5da31[_ae3289_c5d5da3j["month"]];
    _ae3289_c5d5da3j["weekdayName"] = _ae3289_c5d5da32[_ae3289_c5d5da3j["wday"]];
    local _ae3289_c5d5da3k = _ae3289_c5d5da3j["hour"] % 12;
    if _ae3289_c5d5da3k == 0 then
      _ae3289_c5d5da3k = 12
    end;
    _ae3289_c5d5da3j["clock"] = string["format"]("%d:%02d %s %s", _ae3289_c5d5da3k, _ae3289_c5d5da3j["min"], _ae3289_c5d5da3j["hour"] < 12 and "AM" or "PM", _ae3289_c5d5da3j["zone"]);
    return _ae3289_c5d5da3j
  end
end;
-- ===== Local answer database and AI prompt =====
local SYSTEM_PROMPT = "You answer whatever the developer of the Roblox game \"Steal a Brainrot\" asks.\nThere are TWO kinds of question, and you must decide which one you are facing.\nEach message is ONE complete riddle. The dev types fast and casually, with typos\n(\"brainrto\", \"yusername\", \"orginal\"): read through them to what he means.\n\n=== OUTPUT FORMAT IS ABSOLUTE - ONLY THE FIRST LINE IS READ ===\nThe VERY FIRST characters of your reply must be the tag. Nothing may come before\nit: no greeting, no \"Sure\", no reasoning, no thinking out loud, no blank line, no\nmarkdown, no code fences, no quotes. Do ALL of your thinking silently and output\nonly the finished line. If your first line is anything but a tag, the drop is lost.\nReply with exactly ONE line, starting with one of:\n  CODE:   ANSWER:   SEARCHCODE:   SEARCHANSWER:\nEverything after that first line is ignored, so put the whole answer on line one.\n\n=== VAGUE QUESTIONS MUST CARRY AN ALT ===\nYour first answer is always your most confident one - that is the one that gets\nused. But when the question is VAGUE or UNDER-SPECIFIED, you must also append\n\"|| ALT: <the next most likely answer>\" on the same line. Exactly one ALT.\n  example:  CODE: BLOODROT || ALT: GOLD\n  example:  CODE: CRYSTAL || ALT: RAINBOW\n\nAdd an ALT whenever ANY of these is true:\n  - the question uses a subjective word: best, worst, favorite, strongest,\n    hardest, coolest, top, most op\n  - \"first\" or \"last\" could mean either chronological order or list order\n  - the question names no specific thing and more than one candidate fits\n  - two different facts in your data could both answer it\n\nDo NOT add an ALT when the answer is a plain lookup with one right value\n(a date, a price, a count, a name that appears verbatim in the data), and never\nuse ALT for a plural or a suffix variant of your first answer - those are handled\nautomatically. When in doubt on a vague question, INCLUDE the ALT: a spare guess\ncosts nothing, a missed code costs the drop.\n\nMODE 1 - \"CODE:\"  ->  a redeem-code riddle. THIS IS THE DEFAULT.\nUse this whenever ANY of these is true:\n  - the question joins two or more parts (\"X plus Y\", \"X and Y\", \"X + Y\"), OR\n  - any part of it refers to Steal a Brainrot content, OR\n  - any part of it refers to the developer (\"my name\", \"my favorite ...\", \"my birthday\").\nA ONE-PART question is still MODE 1 if that one part is about the game or the dev.\n\"the rarest og\", \"the best og\", \"when did i add lucky blocks\", \"the worst game\" -\nall single-part, all still CODE. Part count does NOT decide the mode; subject does.\nA question can MIX general knowledge with game/dev facts, and that is STILL a code.\nResolve each part separately, then join them all.\n  example:  \"who won the 2026 world cup plus my favorite color and my name\"\n            -> world cup winner + BLUE + SAMMY  ->  CODE: SPAINBLUESAMMY\nNever answer only one part of a multi-part question.\n  example:  CODE: BLUE67MEOWL\n\nMODE 2 - \"ANSWER:\"  ->  an ordinary real-world question that has NOTHING to do with\nSteal a Brainrot or its developer, answerable from settled knowledge: history,\ngeography, science, maths, capital cities, past events that are long decided.\nBeing a single short question does NOT put it here. If ANY part of it touches the\ngame - brainrots, OGs, mutations, traits, events, rarities, items, updates, base\nskins, machines - or touches the dev, it is MODE 1, no matter how short it is.\nOnly use this mode when the subject is genuinely outside the game.\nGive the plain answer in normal writing, as SHORT as possible - a name, a number,\na few words. No code formatting, no caps-lock, no concatenation.\n  example:  ANSWER: Tokyo\n  example:  ANSWER: 1969\n\nMODE 3 - the two SEARCH tags  ->  you need current information to answer correctly.\nUse these ONLY when some part of the answer depends on something that may have\nchanged after your training data ended: this year's or last year's sports results,\nwho currently holds a title or office, live prices, recent releases, \"latest\",\n\"current\", \"who is now\".\n\n  \"SEARCHCODE:\"    the final answer is still a redeem code (mode 1 applies).\n  \"SEARCHANSWER:\"  the final answer is plain prose (mode 2 applies).\n\nFormat for both:  <tag>: <short search query> | <your best guess at the FULL final answer>\nThe guess is shown instantly while the search runs, so it must NEVER be blank, and\nit must already be in the final format - the whole joined code for SEARCHCODE.\n  example:  SEARCHANSWER: 2026 FIFA World Cup winner | Argentina\n  example:  SEARCHCODE:   2026 FIFA World Cup winner | ARGENTINABLUESAMMY\n\nNEVER use SEARCH for anything about Steal a Brainrot or about the developer -\nall of that is already given to you below, and searching would only be slower.\n\nIf a question could be either CODE or ANSWER, prefer CODE - the dev is usually\nasking about his own game. Never reply with an apology or a refusal.\n\nHOW THE CODE RIDDLES WORK:\nThe dev joins several facts together with words like \"plus\", \"and\", \"+\".\nEach part resolves to a word or number, and you CONCATENATE them with no spaces.\nExample: \"my favorite color plus 67 plus my favorite brainrot\"\n         -> if favorite color is green and favorite brainrot is Tralalero\n         -> answer: GREEN67TRALALERO\n\nCODE RULES (these apply to \"CODE:\" replies only):\n- Output ONLY the final code after the tag. No explanation, no quotes.\n- COUNT THE PARTS FIRST. If the question asks for N things, the code is exactly N\n  pieces joined in the order asked. Each part contributes EXACTLY ONE piece.\n  Never add a piece that was not asked for, and never repeat one - UNLESS the\n  question says to (\"my cats name 3 times\" -> NOVANOVANOVA).\n- PLAIN NUMBERS AND WORDS ARE COPIED AS-IS. \"67\" -> 67, \"55\" -> 55, \"yen\" -> YEN.\n  A number in the question is NEVER turned into a mutation, update, event or\n  anything else.\n- YES / NO QUESTIONS answer YES or NO (\"is mwp cool and 67\" -> YES67). The dev asking\n  if something is cool, good or the best means YES unless he clearly wants NO.\n- ALWAYS ALL UPPERCASE. Every confirmed past code is uppercase.\n- No spaces, hyphens or slashes between the joined parts.\n- Strip spaces from multi-word names (\"La Vacca Saturno\" -> LAVACCASATURNO).\n- WORDS INSIDE A REAL NAME STAY IN IT: Garama and Madundung -> GARAMAANDMADUNDUNG, Pizza and Ranch -> PIZZAANDRANCH,\n  Cash or Card -> CASHORCARD. Only the \"and\" / \"plus\" that JOINS separate parts is dropped.\n- Never output a date with slashes. A month part becomes the month NAME (JULY).\n- NEVER use a comma anywhere in any answer, in either mode.\n- NEVER answer with the \"U<number>\" shorthand used in the update log below - that\n  is internal notation, Sammy never writes it. Write UPDATE59, not U59. Better\n  still, if the update has a name or a headline feature, answer with that instead.\n- DROP THE WORD \"EVENT\", KEEP EVERYTHING ELSE. \"Event\" is a generic noun, so the\n  event itself is just called Halloween. But Fuse, Craft, Machine and Ritual are\n  part of a MACHINE'S PROPER NAME and must be kept - they ARE the answer.\n    \"Halloween Event\"  -> HALLOWEEN        (drop Event)\n    \"Backrooms Event\"  -> BACKROOMS        (drop Event)\n    \"Spain Event\"      -> SPAIN            (drop Event)\n    \"Divine Fuse\"      -> DIVINEFUSE       (KEEP Fuse - it is the machine's name)\n    \"Cyber Craft\"      -> CYBERCRAFT       (KEEP Craft)\n    \"Santa's Fuse\"     -> SANTASFUSE       (KEEP Fuse, drop the apostrophe)\n    \"Cupid's Machine\"  -> CUPIDSMACHINE    (KEEP Machine)\n    \"Witch's Fuse\"     -> WITCHSFUSE\n  Griffin comes from the Divine Fuse, so \"where did griffin come from\" is\n  DIVINEFUSE - never just DIVINE, which is a mutation and a different thing.\n  Always strip apostrophes. \"The Red Carpet\" stays REDCARPET.\n- FUSE MACHINES AND CRAFT MACHINES ARE DIFFERENT THINGS. Both exist, with similar\n  names, and they are NOT interchangeable. The real sources are:\n    First Fuse Machine, First Craft Machine, Divine Fuse, OG Fuse, Summer Fuse,\n    Santa's Fuse, Witch's Fuse, Cyber Craft, Limited Quantity Craft.\n  Read the brainrot's source from the GAME DATA and answer with that EXACT name.\n  Do NOT let the wording of the question steer you - if someone asks \"what craft\n  did X come from\" but the data says X came from a Fuse, the answer is the Fuse.\n  La Supreme Combinasion comes from the FIRST FUSE MACHINE, so it is\n  FIRSTFUSEMACHINE even when the question says \"craft\".\n- \"the one we are in right now\" almost always means the currently active EVENT,\n  or the current month - never an internal update id.\n- \"WHEN\" QUESTIONS ANSWER WITH THE MONTH NAME, AS A CODE. Anything asking when\n  something was added to the game is MODE 1, so it is tagged CODE and written in\n  CAPITALS. Reply with the MONTH (\"JULY\") - never an update number (\"U7\"), never a\n  full date (\"July 12, 2025\"), never a day on its own. Add the year only if the\n  question explicitly asks for one.\n    \"when did i add lucky blocks\"  ->  CODE: JULY\n    \"when did i add the divine mutation plus my name\"  ->  CODE: FEBRUARYSAMMY\n- DISTINGUISH PRESENT-TENSE FROM PERSONAL FACTS. Only phrases about NOW\n  (\"right now\", \"this month\", \"currently\", \"today\") use the LIVE STATE section.\n  Anything possessive about the dev (\"MY birthday month\", \"MY favorite...\",\n  \"when I was born\") comes from the DEVELOPER section, never from LIVE STATE.\n  His birthday month is FEBRUARY regardless of what month it is today.\n- DEV FACTS THAT LOOK ALIKE BUT ARE DIFFERENT - do not mix these up:\n    \"my favorite brainrot\"  -> MEOWL          (NOT the best brainrot)\n    \"the best brainrot\"     -> HEADLESSHORSEMAN (NOT his favorite)\n    \"the best egg\" / \"best egg brainrot\" -> DRACULINO (NOT the best brainrot)\n    \"my favorite color\"     -> BLUE           (NOT his avatar colour)\n    \"my avatar's color\" / \"the color of my avatar\" -> RED   (NOT his favorite)\n  Read exactly which one the riddle asks for and answer only that one.\n- USE THE EXACT WORD THE QUESTION GIVES YOU. If a part of the riddle is already a\n  plain word, that word IS the answer for that part - never swap it for a formal\n  name, a translation, an expansion or a synonym.\n    \"america\"      -> AMERICA        (never UNITEDSTATES or USA)\n    \"britain\"      -> BRITAIN        (never UNITEDKINGDOM)\n    \"the states\"   -> THESTATES\n  Only look something up when the question DESCRIBES a thing instead of naming it\n  (\"my favorite colour\", \"the rarest og\"). If it names it outright, copy it.\n- ORDER COUNTS. Mutations the dev ADDED, in order: 1st BLOODROT, 2nd CANDY, 3rd LAVA,\n  4th GALAXY, 5th YINYANG, 6th RADIOACTIVE, 7th CURSED, 8th DIVINE, 9th CYBER,\n  10th PHANTOM, 11th and newest CRYSTAL. Gold, Diamond and Rainbow never count.\n  OGs in order: 1st STRAWBERRYELEPHANT, 2nd MEOWL, 3rd SKIBIDITOILET, 4th and newest\n  JOHNPORK.\n- MACHINE NAME ALIASES: \"the fuse machine\", \"the fuse\", \"the original fuse\" and\n  \"the first fuse\" ALL mean FIRSTFUSEMACHINE. \"the craft machine\", \"the craft\",\n  \"the original craft\" and \"the first craft\" ALL mean FIRSTCRAFTMACHINE. Every\n  other fuse or craft is always named outright (\"divine fuse\", \"santas fuse\",\n  \"cyber craft\", \"og fuse\", \"summer fuse\") - answer with that exact machine name.\n- \"X TIMES\" / \"TWICE\": repeat that one piece that many times. \"my cats name twice\"\n  -> NOVANOVA, \"the second mutation 3 times\" -> CANDYCANDYCANDY.\n- \"BEST BRAINROT\" - READ THE WHOLE PHRASE FIRST:\n    * \"the best brainrot\" / \"best brainrot in the game\" (nothing narrowing it) ->\n      HEADLESSHORSEMAN. This overrides income and price rankings.\n    * \"the best brainrot FROM / OUT OF / IN / OF <a machine, event or rarity>\" is a\n      different question: use the BEST BRAINROT FROM EACH SOURCE table (or the BEST\n      OF EACH RARITY table) in the GAME DATA.\n        \"best brainrot from the divine fuse\" -> GRIFFIN\n        \"best brainrot out of the fuse machine\" -> LASUPREMECOMBINASION\n        \"best halloween fuse brainrot\" / \"best haunted fuse brainrot\" -> PHOENIX\n        \"best spooky lucky block brainrot\" / \"best skull lucky block brainrot\" -> DRAGONSKELETONINI\n          (a \"halloween fuse\" is NOT the first fuse machine - never LASUPREMECOMBINASION)\n        \"best halloween fuse brainrot OF ALL TIME\" / \"ever\" -> HEADLESSHORSEMAN\n          (all time = every Halloween fuse incl. Witch's Fuse, so the overall best wins)\n        \"best brainrot in the craft machine\" -> SIGNORECARAPACE\n        \"best secret brainrot\" -> GRIFFIN\n        \"best egg brainrot\" / \"best brainrot from an egg\" / \"the best egg\" -> DRACULINO\n- NEVER INVENT A BRAINROT NAME. Every brainrot you name must appear verbatim in the\n  BRAINROTS list in the GAME DATA below. Do not answer with a meme name, a name you\n  remember from elsewhere, or a plausible-sounding name that is not in that list.\n  If you cannot find a brainrot in the list that fits, pick the closest one that IS\n  in the list rather than inventing one.\n- SPELLING IS CRITICAL. Long names too: Sammyni Fattini -> SAMMYNIFATTINI (never\n  SAMMYNFATTINI). Check every brainrot in your answer against the GAME DATA.\n  Any brainrot, mutation, trait or event name MUST be copied\n  letter-for-letter from the GAME DATA section. Never abbreviate, never drop a\n  letter, never spell from memory. One wrong letter and the code fails.\n- If you genuinely cannot determine a part, output your single best guess anyway.\n\nEXAMPLES (real riddles):\n  \"my name the best brainrot and 67\"                   -> CODE: SAMMYHEADLESSHORSEMAN67\n  \"whats my cats name 67\"                              -> CODE: NOVA67\n  \"my cats name 3 times and how old am i\"              -> CODE: NOVANOVANOVA24\n  \"what month was steal a brainrot made and the second mutation\" -> CODE: MAYCANDY\n  \"best brainrot out of the orginal fuse and 55\"       -> CODE: LASUPREMECOMBINASION55\n  \"what color is my avatar\"                            -> CODE: RED\n  \"is mwp cool and usking567\"                          -> CODE: YESUSKING567\nINTERPRETING THE RIDDLE (how the dev phrases things):\n- NEVER write NONE, N/A, UNKNOWN, UNREADABLE or NOTACTIVE as part of a code. If you\n  are unsure of a part, give your single best guess and offer an ALT instead.\n- \"the prize\" / \"it\" / \"that one\" / \"the brainrot\" (with no name) means the brainrot\n  the dev most recently spawned or announced this event. If the riddle points back to\n  something he already said (a number, a name, \"it\"), use that exact thing.\n  The RECENT ANNOUNCEMENTS section at the very end is a live feed of what the dev\n  just said and spawned in this server - read it for these references.\n- \"the color of the brainrot\" is just the colour WORD; only include the brainrot's\n  own name where the riddle actually asks for its name.\n- \"which brainrot from <a source/event/machine>\" - the answer is always a real name\n  that comes from that source. Names are usually literal: a clock frog is Tic Tic\n  Ribbit, a duck brainrot's name contains a duck word, pesce/peschito = fish, magi =\n  wizard. Match the description to the NAME.\n- A described brainrot must match EVERY part of the description. A \"vampire duck\" must\n  be BOTH a vampire AND a duck; a vampire that is not a duck is wrong.\n- \"my base\" means the DEVELOPER's base (Sammy's Base), never an ordinary player's base.\n- \"the new brainrot\" / \"just added\" / \"newest\" refers to the current update's additions.\n  Copy any income figure digit for digit; never round it and never invent a number.\n- \"the date\" / \"today's date\" / \"date of the month\" = today's day number, no leading zero.\n- \"the mutation/trait/event/luck running right now\" comes from the LIVE STATE section.\n- THE CURRENT LUCK is the \"Current server luck\" line of LIVE STATE (read live from the\n  game). \"what luck is it\" / \"the current luck\" -> just the multiplier: 8X.\n  \"the current luck event\" -> 8XLUCK || ALT: 8X. Never use a luck that is not on that line.\n  If none is listed but the riddle insists one is running, write the plain word\n  (LUCK, FUSELUCK) as a best guess - never NONE or NO.\n- COUNT / \"how many\" questions answer with digits only.\n\n\n=== DEVELOPER (Sammy) - use ONLY when a part asks about Sammy himself ===\nName: SAMMY\nRoblox username: SPYDERSAMMY\nReal name: Sam Brakta\nAge: 24\nBirthday: 25 FEBRUARY 2002 (birthday month FEBRUARY, day 25, year 2002)\nFavorite color: BLUE (it used to be red, but a real code answer for \"my favorite color\" was BLUE)\nAvatar color (his signature look): RED  - \"my favorite color\" is BLUE, \"my avatar's color\" is RED\nFavorite brainrot: MEOWL (\"my favorite brainrot\" -> MEOWL)\nBest brainrot: HEADLESS HORSEMAN (\"the best brainrot\" -> HEADLESSHORSEMAN; this is NOT his favorite)\nBest egg brainrot: DRACULINO (\"the best egg\" / \"best egg brainrot\" / \"best brainrot from an egg\" -> DRACULINO)\nCat's name: NOVA\nRival: JANDEL (owner of Grow a Garden; they had the \"Admin Abuse War\"; Jandel called him \"Scammy Sammy\")\nLives in the United States (used to live in Algeria)\nLoves tacos: Taco Tuesday is every TUESDAY at 6PM EST; he eats tacos during it\nCatchphrases: \":3\", \"I spoil y'all way too much\", \"someone said La Vacca?\", \"one more snap?\", \"raining lucky blocks?\"\nCompany: Do Big Studios (Chief Product Officer). Group: BRAZILIAN SPYDER (created 1 April 2025, co-founded with Luke Luke Noom)\nMade Steal a Brainrot with: do_small (co-owner, owner of Do Big Studios)\nHis first original game: CRAB GAME (2022). Other games: Mining Clicker Simulator, Pixel Tower Defense (2024), Line to Riches (2025); lead developer on Blade Ball (late 2023); also helped Race Clicker, Schedule, Fisch\nX / Twitter: @SpyderSammy\nBrainrots named after him: Sammyni Spyderini, Los Spyderinis, Sammyni Fattini, Nacho Spyder (also Sammyni Cakini, Giftini Spyderini, Pumpkini Spyderini)\nGame management: SpyderSammy, do_small, Atavi (QA lead), Guga (game producer)\nContributors: mygame43, Jordan, hgdev, ABU, TyrxNOff, Alsalihin, jandel\nOther admin abuse hosts: Steak, Caylus\n\n=== STEAL A BRAINROT WIKI FACTS ===\nReleased: 15 MAY 2025 (month MAY). Made on Roblox by SpyderSammy and do_small under BRAZILIAN SPYDER. Idea taken (with permission) from \"Steal a Character\". 60B+ visits.\nWeekly update: every SATURDAY, usually 3PM EST, followed by an Admin Abuse (30-60 minutes). Early-bird gift about an hour before (usually a Secret Lucky Block).\nTaco Tuesday: every TUESDAY at 6PM EST, another admin abuse.\nCodes feature added 13 December 2025; first code was for Festive 67.\nReal past codes: BESTBRAINROTEVER (La Vacca Saturno Saturnita), ILOVEFOOD123 (Kraken), SUMMERUPD3, NEEDTHIS4CRAFT333, OCTOBLOCK555, FREE500DRAGS (Dragon Cannelloni), JOHNPORKDAPIGGY (John Pork), CODESAREREAL321, L2EXPLOITERS, IMANEGG (Strawberry Elephant), PIZZAISYUM (Pizza and Ranch).\nREAL PAST RIDDLE ANSWERS (this is exactly the style you must produce - facts joined, uppercase): MAYMEOWLJANDEL, CANDY24SAMMY, DIVINECURSED.\nSammy's Base (spawned in admin abuse): a floating base with a taco table; common brainrots there are Ballerino Lololo and Tartaruga Cisterna; rarest is Garama and Madundung.\nSammy's Snap: Sammy runs down the red carpet with a red aura and snaps, starting almost every event at once. There is also a Coffin Snap.\nBrainrots Sammy spawns most in admin abuse: Matteo, La Vacca Saturno Saturnita, Karkerkar Kurkur, Dul Dul Dul, Los Tralaleritos, Las Tralaleritas, Job Job Job Sahur, Graipuss Medussi.\nLucky blocks he always spawns in admin abuse: Mythic, Brainrot God, Taco, Los Taco Blocks (most common), Admin, Los Lucky Blocks, Secret.\nFuse Machine: added 1 AUGUST 2025 (Friday), 4 brainrots in; removed 6 September 2025 and replaced by the Craft Machine; brought back 24 JANUARY 2026.\nCraft Machine: added in the Crafting Update (6 September 2025), replaced the Fuse Machine; removed 11 October 2025, replaced by the Witch Fuse. A brainrot is named after it: La Craft Machine.\nBase: up to 3 floors; base lock is 60 seconds, +10 seconds per rebirth (+10 with VIP). 26 base skins. Each rebirth gives +1 cash multiplier, rebirth cash, +10s lock, +1 slot, new gears.\nRarity order (lowest to highest): Common, Rare, Epic, Legendary, Mythic, Brainrot God, Secret, OG (plus Admin and seasonal rarities: Taco, Spooky, Festive, Valentines, St Patricks, Easter, Summer).\nLuck multipliers: 2x, 4x, 6x, 8x, 10x, 12x, 15x, 20x, 25x, 30x (1 Year celebration), 35x (Summer 2026).\nMost expensive gear in the gear shop: Flash Teleport.\nThe Steal a Brainrot Discord: discord.gg/brainrots.\n\n\n=== LIVE STATE ===\n{{LIVE_STATE}}\n\n=== GAME DATA ===\nGAME: Steal a Brainrot (creator group: BRAZILIAN SPYDER)\nBASE MUTATIONS (permanent, obtainable normally, present from the start): Default (1x), Gold (1.25x, added 31 May 2025), Diamond (1.5x, added 31 May 2025), Rainbow (10x, added 21 June 2025)\nADDED / LIMITED MUTATIONS - the ones the developer ADDS to the game over time, each tied to an event, in release order:\n  1. Bloodrot (2x, added Update 2)\n  2. Candy (4x, added 5 July 2025)\n  3. Lava (6x, added 25 July 2025)\n  4. Galaxy (7x, added 23 August 2025)\n  5. Yin Yang (7.5x, added 27 September 2025)\n  6. Radioactive (8.5x, added 15 November 2025)\n  7. Cursed (9x, added 3 January 2026)\n  8. Divine (10x, added 21 February 2026)\n  9. Cyber (11x, added 18 April 2026)\n  10. Phantom (12x, added 13 June 2026 (Update 53))\n  11. Crystal (13x, added 25 July 2026 (Update 59) - NEWEST)\nIMPORTANT: when a riddle says \"the first mutation\", it means the first mutation the developer ADDED, which is BLOODROT - it does NOT mean Gold. \"The newest / latest / last mutation\" means CRYSTAL. Gold, Diamond and Rainbow are base mutations, not ones he added.\nRARITIES: Admin, Brainrot God, Common, Easter, Epic, Festive, Legendary, Mythic, OG, Rare, Secret, Spooky, St Patrick's, Summer, Taco, Valentines\nTRAITS: 1 Year(x5.5), 10B(x3), 26(x5), :3(x4.5), Algeria(x4.5), Argentina(x4.5), Aura Shades(x4.5), Australia(x4.5), Austria(x4.5), Ball(x5), Belgium(x4.5), Blue Balloon(x4), Blue Egg(x5), Bosnia and Herzegovina(x4.5), Brazil(x5), Bubblegum(x3), Bull(x5), Bunny Ears(x4.5), Burger(x4.5), Canada(x4.5), Cape Verde(x4.5), Chocolate(x4.5), Claws(x4), Colombia(x4.5), Cometstruck(x2.5), Croatia(x4.5), Curacao(x4.5), Czechia(x4.5), DR Congo(x4.5), Disco(x4), Ecuador(x4.5), Egypt(x4.5), England(x4.5), Explosive(x3), Fire(x5), Fireworks(x5), France(x4.5), Galactic(x3), Germany(x4.5), Ghana(x4.5), Glitched(x4), Granny(x5.5), Green Balloon(x3.5), Green Egg(x4), Haiti(x4.5), Halo(x5), Indonesia(x4), Iran(x4.5), Iraq(x4.5), Ivory Coast(x4.5), Jackolantern Pet(x4.5), Japan(x4.5), Job Application(x4), John Pork(x7), Jordan(x4.5), Lightning(x5), Lucky(x5), Matteo Hat(x3.5), Meowl(x8), Mexico(x4.5), Morocco(x4.5), Netherlands(x4.5), New Zealand(x4.5), Norway(x4.5), Nyan(x5), Orange Balloon(x3), Orange Egg(x3), Paint(x5), Panama(x4.5), Paraguay(x4.5), Pink Balloon(x5.5), Pink Egg(x6.5), Portugal(x4.5), Qatar(x4.5), RIP Gravestone(x3.5), Rainbow Balloon(x6.5), Red Balloon(x5), Reindeer Pet(x5), Rose(x5), Santa Hat(x4), Saudi Arabia(x4.5), Scotland(x4.5), Senegal(x4.5), Shark Fin(x3), Skeleton(x3), Skibidi(x6.5), Sleepy(x0), Snowy(x2), Sombrero(x4), South Africa(x4.5), South Korea(x4.5), Spain(x4.5), Spider(x3.5), Strawberry(x9), Sun(x5), Sweden(x4.5), Switzerland(x4.5), Taco(x2.5), Tie(x3.75), Tunisia(x4.5), Turkey(x4.5), UFO(x2), United States(x4.5), Uruguay(x4.5), Uzbekistan(x4.5), Wet(x1.5), Witch Hat(x3), Zombie(x4)\nBRAINROTS (527 total), grouped by rarity. \"name <- source\" means that brainrot came from that event/machine:\n  [Admin] Los Lucky Blocks($250000000, 0/s), Lucky Block($100000000, 0/s)\n  [Brainrot God] Alessio($17500000, 85000/s), Anpali Babel($48000000, 280000/s) <- This was obtained from the Craft Machine, Appelini($69000000, 300000/s) <- The Red Carpet, Aquanaut($45500000, 245000/s) <- The Red Carpet, Astrolero Cervalero($48000000, 280000/s) <- Divine Fuse, Ballerina Peppermintina($37500000, 215000/s) <- Advent/Winter Hour, Ballerino Lololo($35000000, 200000/s) <- The Red Carpet, Bambu Bambu Sahur($47500000, 275000/s) <- Indonesia Event, Belula Beluga($60000000, 290000/s) <- Brainrot Trader, Boba Panda($47000000, 270000/s) <- OG Fuse, Bombardini Tortinii($50000000, 225000/s) <- Taco Event, Brasilini Berimbini($55000000, 285000/s) <- Admin Abuse, Brr es Teh Patipum($40000000, 225000/s) <- First Fuse Machine, Buho de Noelo($46750000, 267500/s) <- Santa's Fuse, Bulbito Bandito Traktorito($35000000, 205000/s), Bunny Tralala($47000000, 270000/s), Cacasito Satalito($45000000, 240000/s) <- The Red Carpet, Capi Taco($31000000, 155000/s) <- Taco Event, Cappuccino Clownino($48500000, 285000/s), Chihuanini Taconini($8500000, 45000/s), Chrismasmamat($47750000, 277500/s), Clovkur Kurkur($70000000, 305000/s), Cocoa Assassino($61000000, 291000/s) <- Christmas Event, Cocofanto Elefanto($6500000, 19000/s) <- The Red Carpet, Cola Cat($47500000, 275000/s) <- DLC Code, Corn Corn Corn Sahur($45000000, 250000/s) <- The Pinata, Crabbo Limonetta($46000000, 235000/s), Divino Platypio($32000000, 160000/s) <- Divine Fuse, Dolphini Jetskini($64500000, 294500/s) <- OG Fuse, Dumborino Miracello($75000000, 315000/s) <- Divine Fuse, Eggdin Egg Egg Dun($72500000, 310000/s), Espresso Signora($25000000, 70000/s) <- Admin Abuse, Extinct Ballerina($23500000, 125000/s) <- Extinct Event, Flippo Marino($75500000, 316000/s) <- Summer Fuse, Frio Ninja($46500000, 265000/s) <- Witch's Fuse, Gattatino Nyanino($7500000, 35000/s) <- Admin Abuse, Gattito Tacoto($32500000, 165000/s), Ginger Cisterna($63500000, 293500/s) <- Santa's Fuse, Ginger Globo($45750000, 257500/s) <- Santa's Fuse, Girafa Celestre($7500000, 20000/s) <- The Red Carpet, Granchiello Spiritell($46000000, 260000/s) <- Fishing Event, Jacko Jack Jack($30000000, 150000/s) <- Witch's Fuse, Karkerheart Luvkur($67500000, 297500/s), Krupuk Pagi Pagi($60000000, 290000/s) <- Indonesia Event, Las Capuchinas($32500000, 185000/s) <- First Craft Machine, Lazy Ducky($45500000, 255000/s) <- DLC Code, Lemonita Splashita($48000000, 280000/s) <- Summer Fuse, Los Bombinitos($42500000, 220000/s), Los Chihuaninis($32000000, 160000/s), Los Crocodillitos($12500000, 55000/s) <- Bombardiro Event, Los Gattitos($47500000, 275000/s), Los Orcalitos($45000000, 235000/s) <- First Fuse Machine, Los Tipi Tacos($46000000, 260000/s), Los Tungtungtungcitos($37500000, 210000/s) <- First Fuse Machine, Lucky Block($25000000, 0/s), Lumaca Malefica($46500000, 265000/s) <- Backrooms Event, Luv Luv Luv($48250000, 282500/s), Mastodontico Telepiedone($47500000, 275000/s), Matteo($10000000, 50000/s) <- Admin Abuse, Money Money Man($17500000, 65000/s) <- Brainrot Trader, Mummy Ambalabu($45000000, 250000/s), Noo La Polizia($67000000, 280000/s) <- Brainrot Trader, Odin Din Din Dun($15000000, 75000/s), Orcalero Orcala($25000000, 100000/s), Orcalita Orcala($45000000, 240000/s) <- Cyber Craft, Pakrahmatmamat($37500000, 215000/s) <- The Red Carpet, Pakrahmatmatina($40500000, 225000/s) <- Pole Game, Pandanini Frostini($64000000, 294000/s), Patteo($57500000, 287500/s), Piccione Macchina($40000000, 225000/s) <- The Red Carpet, Piccionetta Macchina($47000000, 270000/s) <- First Craft Machine, Pineaplino($35000000, 200000/s) <- DLC Code, Pop Pop Sahur($65000000, 295000/s), Pretzo Robo($77000000, 320000/s) <- Cyber Craft, Robo Grafito($76000000, 317500/s) <- Backrooms Event, Skull Skull Skull($60000000, 290000/s) <- Halloween Event, Snailenzo($45000000, 250000/s) <- Witch's Fuse, Squalanana($45000000, 250000/s) <- Cyber Craft, Sundrilla Sundae($31000000, 180000/s) <- Summer Fuse, Tartaruga Cisterna($45000000, 250000/s) <- This is obtained from Sammy's Base, Tenini Ballini($77000000, 320000/s) <- DLC Code, Tentacolo Tecnico($62500000, 292500/s) <- Witch's Fuse, Tigroligre Frutonni($14000000, 60000/s), Tipi Topi Taco($20000000, 75000/s) <- Taco Event, Tootini Shrimpini($46000000, 260000/s) <- New Year's Event, Tortuginni Sandcastlini($76000000, 317500/s), Tractoro Dinosauro($42500000, 230000/s) <- The Red Carpet, Tralalero Tralala($10000000, 50000/s) <- The Red Carpet, Tralalita Tralala($20000000, 100000/s) <- The Red Carpet, Trenostruzzo Turbo 3000($25000000, 150000/s) <- The Red Carpet, Trenotubo Axolotrico 9000($45500000, 255000/s) <- Cyber Craft, Trippi Troppi Troppa Trippa($30000000, 175000/s) <- The Red Carpet, Tukanno Bananno($22500000, 100000/s) <- First Fuse Machine, Unclito Samito($20000000, 75000/s) <- Admin Abuse, Urubini Flamenguini($30000000, 150000/s) <- Admin Abuse, Vampira Cappucina($24500000, 125000/s) <- Halloween Event, Yeti Claus($45750000, 257500/s) <- Santa's Fuse\n  [Common] Fluriflura <- The Red Carpet, Holy Arepa <- Divine Fuse, Liril Laril <- The Red Carpet, Noobini Pizzanini <- The Red Carpet, Noobini Santanini <- Santa's Fuse, Pipi Corni <- Summer Fuse, Pipi Kiwi <- The Red Carpet, Raccooni Jandelini <- Admin Abuse War, Svinina Bombardino <- The Red Carpet, Talpa Di Fero <- The Red Carpet, Tartaragno <- Witch's Fuse, Tim Cheese <- The Red Carpet\n  [Easter] Baskito Egg, Bunny Bunny Bunny Sahur Egg, Bunny Tralala Egg, Buntteo Egg, Churrito Bunnito Egg, Easter Easter Easter Sahur Egg, Egg Lucky Block, Eggdin Egg Egg Dun Egg, Hopilikalika Hopilikalako Egg, Hydra Bunny Egg, Los Bunitos Egg, Noo my Eggs Egg, Premium Egg Lucky Block, Quackini Snackini Egg\n  [Epic] Avocadini Antilopini <- The Red Carpet, Avocadini Guffo <- The Red Carpet, Bambini Crostini <- The Red Carpet, Bananita Dolphinita <- The Red Carpet, Brr Brr Patapim <- The Red Carpet, Brri Brri Bicus Dicus Bombicus <- The Red Carpet, Cappuccino Assassino <- The Red Carpet, Doi Doi Do <- Brainrot Trader, Frogato Pirato <- Witch's Fuse, Gato Celesto <- Divine Fuse, Malame Amarele <- First Craft Machine, Mangolini Parrocini <- Brainrot Trader, Mummio Rappitto <- Witch's Fuse, Penguin Tree <- Santa's Fuse, Penguino Cocosino <- Summer Fuse, Perochello Lemonchello <- The Red Carpet, Salamino Penguino <- The Red Carpet, Ti Ti Ti Sahur <- Summer Fuse, Trulimero Trulicina <- The Red Carpet, Wombo Rollo <- The Red Carpet\n  [Festive] Festive Lucky Block, Premium Festive Lucky Block\n  [Legendary] Ballerina Cappuccina <- The Red Carpet, Bandito Axolito <- Cyber Craft, Blueberrinni Octopusini <- The Red Carpet, Buho de Fuego <- Witch's Fuse, Buho del Cielo <- Divine Fuse, Burbaloni Loliloli <- The Red Carpet, Caramello Filtrello <- First Craft Machine, Chef Crabracadabra <- The Red Carpet, Chimpanzini Bananini <- The Red Carpet, Chocco Bunny <- Santa's Fuse, Clickerino Crabo <- Brainrot Trader, Cocosini Mama <- First Fuse Machine, Electro Quacko <- Cyber Craft, Glorbo Fruttodrillo <- The Red Carpet, Lionel Cactuseli <- The Red Carpet, Pandaccini Bananini <- The Red Carpet, Pi Pi Watermelon <- Summer Fuse, Pipi Potato <- The Red Carpet, Puffaball <- Fishing Event, Quackula <- Witch's Fuse, Quivioli Ameleonni <- The Red Carpet, Sealo Regalo <- Santa's Fuse, Seraphino Gruyero <- Divine Fuse, Sigma Boy <- The Red Carpet, Sigma Girl <- First Craft Machine, Strawberrelli Flamingelli <- The Red Carpet\n  [Mythic] Avocadorilla <- First Fuse Machine, Bananito Bandito, Bee Loco <- Cyber Craft, Berenjello Angello <- Divine Fuse, Bombardiro Crocodilo <- The Red Carpet, Bombombini Gusini <- The Red Carpet, Brutto Gialutto <- First Craft Machine, Bucketoro <- Summer Fuse, Cachorrito Melonito <- The Red Carpet, Carloo, Carrotini Brainini, Cavallo Virtuoso <- The Red Carpet, Centrucci Nuclucci <- Brainrot Trader, Cocoteddy <- Summer Fuse, Fizzy Soda <- OG Fuse, Frigo Camelo <- The Red Carpet, Ganganzelli Trulala <- First Fuse Machine, Gorillo Subwoofero <- First Craft Machine, Gorillo Watermelondrillo <- The Red Carpet, Harpuccino <- Divine Fuse, Jacko Spaventosa <- Witch's Fuse, Jingle Jingle Sahur <- Santa's Fuse, Lerulerulerule <- The Red Carpet, Los Noobinis <- Cyber Craft, Lucky Block, Magi Ribbitini <- Witch's Fuse, Orangutini Ananassini <- The Red Carpet, Orbi Mochi <- Cyber Craft, Rhino Helicopterino <- First Craft Machine, Rhino Toasterino, Spioniro Golubiro, Spongini Quackini <- OG Fuse, Stoppo Luminino <- Brainrot Trader, Te Te Te Sahur <- The Red Carpet, Tigrilini Watermelini, Tob Tobi Tobi <- First Fuse Machine, Toiletto Focaccino <- The Red Carpet, Tracoducotulu Delapeladustuz <- The Red Carpet, Tree Tree Tree Sahur <- Santa's Fuse, Zibra Zubra Zibralini\n  [OG] Headless Horseman($600000000000, 600000000/s) <- Witch's Fuse, John Pork($500000000000, 500000000/s) <- The Red Carpet, Meowl($650000000000, 600000000/s) <- The Red Carpet, Skibidi Toilet($450000000000, 450000000/s) <- The Red Carpet, Spyder Elephant($1000000000000, 1000000000/s), Strawberry Elephant($750000000000, 750000000/s) <- The Red Carpet\n  [Rare] Bandito Bobritto <- The Red Carpet, Boneca Ambalabu <- The Red Carpet, Cacto Hipopotamo <- The Red Carpet, Cupcake Koala <- Brainrot Trader, Frogo Elfo <- Santa's Fuse, Gangster Footera <- The Red Carpet, Pengolino Nuvoletto <- Divine Fuse, Pinealotto Fruttarino <- Witch's Fuse, Pipi Avocado <- Summer Fuse, Ta Ta Ta Ta Sahur, Tric Trac Baraboom <- The Red Carpet, Trippi Troppi <- The Red Carpet\n  [Secret] 1x1x1x1($255555555, 1111111/s) <- Cave Ritual, 25($600000000, 2500000/s) <- Advent Calendar, 4th Bros($800000000, 3750000/s) <- Admin Abuse, 67($1250000000, 7500000/s), Abyssaloco($4333333333, 33333333/s) <- Backrooms Event, Agarrini la Palini($80000000, 425000/s) <- First Fuse Machine, Antonio($50000000000, 125000000/s) <- First Craft Machine, Aquarino($865000000, 4250000/s) <- Summer Hour, Arcadopus($900000000, 5000000/s) <- Tsunami LTM, Arcadragon($215000000000, 215000000/s) <- DLC Code, Bacuru and Egguru($3850000000, 24000000/s) <- OG Fuse, Bananito($2000000000, 15000000/s) <- The Red Carpet, Baskito($2100000000, 16000000/s), Bearito Cabinito($21000000000, 72500000/s), Berryno($500000000, 1500000/s) <- The Red Carpet, Bisonte Giuppitere($80000000, 325000/s) <- This is obtained from Sammy's Base, Blackhole Goat($75000000, 400000/s), Boatito Auratito($115000000, 525000/s) <- Admin Abuse, Bombardiro Vaccariro($250000000, 1000000/s) <- Summer Fuse, Boppin Bunny($25000000000, 80000000/s) <- DLC Code, Brunito Marsito($750000000, 3500000/s) <- This was spawned during Bruno's Concert Event, Bufalino Boomberino($4000000000, 32000000/s) <- Limited Quantity Craft, Buho de Volto($650000000, 2750000/s) <- Cyber Craft, Bunito Bunito Spinito($900000000, 3000000/s) <- New Year's Event, Bunny Bunny Bunny Sahur($575000000, 2250000/s) <- Easter Event, Bunny and Eggy($135000000000, 170000000/s) <- Divine Fuse, Bunnyman($500000000, 1500000/s) <- Advent Calendar, Buntteo($225000000, 850000/s) <- Easter Event, Burguro And Fryuro($75000000000, 150000000/s), Burrito Bandito($850000000, 4000000/s), Camera Ramena($2300000000, 17000000/s) <- Cyber Craft, Cangurato Gelato($23500000000, 77500000/s) <- The Red Carpet, Capitano Americano($21000000000, 72500000/s) <- Limited Quantity Craft, Capitano Gullini($2700000000, 22000000/s) <- Summer Fuse, Capitano Moby($125000000000, 160000000/s) <- The Red Carpet, Cash or Card($40000000000, 100000000/s) <- The Red Carpet, Caylusaurus($12500000000, 55000000/s) <- Limited Quantity Craft, Celestial Pegasus($150000000000, 175000000/s), Celularcini Viciosini($2750000000, 22500000/s) <- First Craft Machine, Cerberus($150000000000, 175000000/s) <- The Red Carpet, Chachechi($85000000, 400000/s) <- Admin Abuse, Chicleteira Bicicleteira($750000000, 3500000/s) <- The Red Carpet, Chicleteira Champeona($2850000000, 19000000/s) <- Spain Event, Chicleteira Cupideira($2500000000, 17500000/s), Chicleteira Noelteira($2000000000, 15000000/s) <- Santa's Fuse, Chicleteira Surfeiteira($2100000000, 16000000/s) <- Summer Hour, Chicleteirina Bicicleteirina($850000000, 4000000/s) <- The Red Carpet, Chill Puppy($850000000, 4000000/s) <- OG Fuse, Chillin Chili($2500000000, 25000000/s) <- Limited Quantity Craft, Chimnino($1900000000, 14000000/s), Chipso and Queso($2500000000, 25000000/s) <- Limited Quantity Craft, Churrito Bunnito($2600000000, 21000000/s), Cigno Fulgoro($3000000000, 20000000/s) <- Divine Fuse, Cloverat Clapat($15000000000, 60000000/s) <- St Patricks Event, Coco and Mango($4500000000, 33500000/s) <- Summer Fuse, Cooki and Milki($100000000000, 155000000/s) <- Santa's Fuse, Craburger($350000000, 1300000/s), Cuadramat and Pakrahmatmamat($400000000, 1400000/s) <- Brainrot Trader, Cupid Cupid Sahur($715000000, 3100000/s) <- Cupid's Machine, Cupid Hotspot($750000000, 3500000/s), DJ Panda($2500000000, 17500000/s) <- The Red Carpet, Digi Narwhal($200000000000, 200000000/s) <- Cyber Craft, Donkeyturbo Express($1250000000, 7500000/s) <- Christmas Event, Dragon Aquanini($375000000000, 375000000/s) <- Summer Fuse, Dragon Cannelloni($250000000000, 250000000/s) <- The Red Carpet, Dragon Gingerini($350000000000, 350000000/s) <- Santa's Fuse, Dug dug dug($5000000000, 35000000/s) <- First Craft Machine, Duggy Bros($30000000000, 90000000/s) <- Cyber Craft, Dul Dul Dul($150000000, 375000/s) <- Admin Abuse, Easter Easter Easter Sahur($300000000, 1250000/s), Eid Eid Eid Sahur($750000000, 3500000/s) <- Eid Event, Elefanto Frigo($175000000000, 185000000/s) <- First Craft Machine, Esok Goala($4250000000, 32500000/s) <- Soccer Board, Esok Sekolah($3500000000, 30000000/s), Eviledon($3850000000, 31500000/s) <- Witch's Fuse, Examen Bros($20000000000, 70000000/s) <- Los Traders, Extinct Matteo($162500000, 625000/s) <- Extinct Event, Extinct Tralalero($125000000, 450000/s) <- Extinct Event, Festive 67($16000000000, 67000000/s) <- DLC Code, Fishboard($215000000, 825000/s) <- The Red Carpet, Fishino Clownino($48500000000, 120000000/s) <- Fishing Event, Flancito($800000000, 3750000/s) <- SAB's Anniversary Event, Flipa Sandala($1100000000, 6000000/s) <- Backrooms Event, Fortunu and Cashuru($55000000000, 130000000/s), Foxini Lanternini($47500000000, 115000000/s) <- Eid Event, Fragola La La La($4250000000, 32500000/s) <- First Craft Machine, Fragrama and Chocrama($40000000000, 100000000/s) <- Brainrot Trader, Frankentteo($175000000, 700000/s) <- Halloween Event, Frullato Framingo($3000000000, 20000000/s) <- Sammy's Code, Futbolini Skatini($875000000, 4500000/s) <- Cyber Craft, GOAT($237500000, 950000/s) <- Admin Abuse, Garama and Madundung($10000000000, 50000000/s) <- The Red Carpet, Gelato Lumacho($400000000, 1400000/s) <- Summer Hour, Giftini Spyderini($240000000, 999999/s) <- This was obtained from the North Pole, Ginger Gerat($22500000000, 75000000/s) <- Santa's Market, Girafini Raftini($2600000000, 18000000/s), Glaciator($580000000, 2300000/s) <- Backrooms Event, Globa Steppa($3000000000, 27500000/s) <- DLC Code, Gobblino Uniciclino($2850000000, 27500000/s) <- Thanksgiving Event, Gold Egg($0, 0/s), Gold Elf($0, 0/s), Gold Gold Gold($8000000000, 45000000/s), Grabatron($15000000000, 62500000/s) <- DLC Codes, Graipuss Medussi($250000000, 1000000/s) <- The Red Carpet, Granny($0, 0/s), Granny($850000000, 4000000/s) <- Granny's Funeral Event, Griffin($400000000000, 400000000/s) <- Divine Fuse, Guerriro Digitale($120000000, 550000/s), Guest 666($15666666666, 66666666/s) <- Cave Ritual, Gym Bros($7500000000, 42500000/s) <- Cyber Craft, Hippo Golazo($300000000, 1250000/s) <- Soccer Board, Ho Ho Ho Sahur($725000000, 3250000/s) <- Santa's Fuse, Hopilikalika Hopilikalako($12500000000, 55000000/s), Horegini Boom($650000000, 2750000/s) <- Aura Boat, Hydra Bunny($175000000000, 185000000/s), Hydra Dragon Cannelloni($300000000000, 300000000/s) <- OG Fuse, Jackorilla($80000000, 315000/s), Jelly Moby($150000000000, 175000000/s) <- SAB's Anniversary Event, Job Job Job Sahur($175000000, 700000/s) <- The Red Carpet, John Doe($1250000000, 7500000/s) <- Cave Ritual, Jolly Jolly Sahur($8000000000, 45000000/s) <- Santa's Market, Kalika Bros($47500000000, 115000000/s) <- Cyber Craft, Karker Sahur($185000000, 725000/s) <- First Craft Machine, Karkerkar Kurkur($80000000, 325000/s) <- Admin Abuse, Ketchuru and Musturu($7500000000, 42500000/s) <- The Red Carpet, Ketupat Bros($65000000000, 145000000/s) <- OG Fuse, Ketupat Kepat($5000000000, 35000000/s) <- The Red Carpet, Kraken($200000000000, 200000000/s), La Anniversary Grande($10000000000, 50000000/s) <- Limited Quantity Craft, La Casa Boo($40000000000, 100000000/s), La Cucaracha($110000000, 475000/s) <- Admin Abuse, La Easter Grande($12500000000, 55000000/s) <- Limited Quantity Craft, La Extinct Grande($3250000000, 23500000/s) <- Extinct Event, La Food Combinasion($30000000000, 90000000/s), La Ginger Sekolah($23000000000, 75000000/s), La Grande Combinasion($1000000000, 10000000/s) <- The Red Carpet, La Jolly Grande($3500000000, 30000000/s) <- Christmas Wheel Spin, La Karkerkar Combinasion($160000000, 600000/s) <- First Craft Machine, La Lucky Grande($7000000000, 40000000/s) <- Limited Quantity Craft, La Romantic Grande($7000000000, 40000000/s) <- Limited Quantity Craft, La Sahur Combinasion($550000000, 2000000/s) <- First Craft Machine, La Secret Combinasion($50000000000, 125000000/s), La Spooky Grande($2900000000, 24500000/s) <- Limited Quantity Craft, La Summer Grande($15000000000, 60000000/s) <- Limited Quantity Craft, La Supreme Combinasion($200000000000, 200000000/s) <- First Fuse Machine, La Taco Combinasion($5000000000, 35000000/s) <- Limited Quantity Craft, La Vacca Jacko Linterino($225000000, 850000/s) <- Halloween Event, La Vacca Lepre Lepreino($255000000, 1100000/s), La Vacca Prese Presente($160000000, 600000/s) <- Santa's Fuse, La Vacca Saturno Saturnita($80000000, 325000/s) <- The Red Carpet, Las Sis($2500000000, 17500000/s) <- First Craft Machine, Las Tralaleritas($150000000, 650000/s) <- The Red Carpet, Las Vaquitas Saturnitas($200000000, 750000/s) <- La Vacca Ritual, Lavadorito Spinito($8000000000, 45000000/s) <- The Red Carpet, List List List Sahur($550000000, 2000000/s) <- Christmas Event, Los 25($1500000000, 10000000/s), Los 67($2750000000, 22500000/s), Los Admins($35000000000, 95000000/s) <- Los Traders, Los Amigos($55000000000, 130000000/s), Los Bros($2600000000, 24000000/s) <- First Craft Machine, Los Bunitos($865000000, 4250000/s), Los Burritos($1400000000, 8500000/s), Los Candies($3000000000, 23000000/s) <- Santa's Fuse, Los Chicleteiras($1200000000, 7000000/s) <- Chicleteira Ritual, Los Chillis($22500000000, 75000000/s) <- Cyber Craft, Los Combinasionas($2000000000, 15000000/s) <- First Fuse Machine, Los Cornis($715000000, 3100000/s) <- Los Traders, Los Cucarachas($300000000, 1250000/s), Los Cupids($3500000000, 30000000/s) <- Divine Fuse, Los Fruits($3000000000, 23000000/s) <- Summer Fuse, Los Hackers($22500000000, 75000000/s) <- Cyber Craft, Los Hotspotsitos($3000000000, 20000000/s) <- First Fuse Machine, Los Jobcitos($500000000, 1500000/s), Los Jolly Combinasionas($3000000000, 20000000/s) <- Santa's Market, Los Karkeritos($200000000, 750000/s) <- Karker Ritual, Los Mariachis($3000000000, 30000000/s) <- The Pinata, Los Matteos($80000000, 325000/s) <- Matteo Ritual, Los Mi Gatitos($1250000000, 6500000/s) <- Mi Gatito Ritual, Los Mobilis($2700000000, 22000000/s) <- Witch's Fuse, Los Nooo My Hotspotsitos($1000000000, 5500000/s), Los Planitos($2750000000, 18500000/s) <- Brainrot Trader, Los Primos($3750000000, 31000000/s) <- First Craft Machine, Los Puggies($3000000000, 30000000/s) <- Brainrot Trader, Los Quesadillas($875000000, 4500000/s), Los Secret Combinasionas($75000000000, 150000000/s) <- Los Traders, Los Sekolahs($45000000000, 110000000/s), Los Sigmas($580000000, 2300000/s) <- Los Traders, Los Spaghettis($20000000000, 70000000/s) <- Brainrot Trader, Los Spooky Combinasionas($3000000000, 20000000/s), Los Spyderinis($125000000, 425000/s) <- Spyderini Ritual, Los Sweethearts($2250000000, 16500000/s) <- First Fuse Machine, Los Tacoritas($4000000000, 32000000/s) <- First Craft Machine, Los Tangcitos($7500000000, 42500000/s) <- Los Traders, Los Tictacs($15000000000, 60000000/s) <- Los Traders, Los Tortus($100000000, 500000/s), Los Tralaleritos($100000000, 500000/s) <- The Red Carpet, Los Trios($175000000, 700000/s) <- OG Fuse, Love Love Bear($225000000000, 225000000/s) <- Cupid's Machine, Love Love Love Sahur($250000000, 1000000/s), Lovin Rose($4250000000, 32500000/s) <- Cupid's Machine, Luck Luck Luck Sahur($800000000, 3750000/s), Lucky Block($750000000, 0/s), Mariachi Corazoni($1750000000, 12500000/s) <- The Pinata, Mi Gatito($725000000, 3250000/s) <- Admin Abuse, Mieteteira Bicicleteira($2750000000, 26000000/s) <- Witch's Fuse, Moby Bros($225000000000, 225000000/s) <- Los Traders, Money Money Bros($9000000000, 47000000/s) <- Cyber Craft, Money Money Puggy($2600000000, 21000000/s) <- The Red Carpet, Money Money Reindeer($2500000000, 25000000/s) <- Santa's Market, Nacho Spyder($10000000000, 50000000/s) <- Limited Quantity Craft, Naughty Naughty($700000000, 3000000/s) <- Christmas Event, Noo my Candy($900000000, 5000000/s) <- Trick Or Treat, Noo my Eggs($1200000000, 7000000/s) <- Easter Event, Noo my Examen($4250000000, 32500000/s) <- Dul Dul Ritual, Noo my Gold($1850000000, 13500000/s), Noo my Heart($1800000000, 13000000/s), Noo my Present($1100000000, 6000000/s) <- Christmas Event, Noo my Resume($4250000000, 32500000/s) <- Job Ritual, Noodle Noodle Poodle($3000000000, 27500000/s) <- The Red Carpet, Nooo My Hotspot($500000000, 1500000/s) <- Taco Event, Nuclearo Dinossauro($2500000000, 15000000/s) <- The Red Carpet, Octoball($725000000, 3250000/s), Ombrello Topolino($1250000000, 6500000/s) <- Summer Fuse, Orcaledon($7000000000, 40000000/s) <- Brainrot Trader, Pancake and Syrup($50000000000, 125000000/s) <- DLC Code, Paradiso Axolottino($235000000, 900000/s) <- Divine Fuse, Perrito Burrito($250000000, 1000000/s) <- Limited Quantity Craft, Pirulitoita Bicicleteira($600000000, 2500000/s) <- Brainrot Trader, Pizza and Ranch($55000000000, 130000000/s), Please my Present($350000000, 1300000/s) <- Advent Calendar, Popcuru and Fizzuru($135000000000, 170000000/s) <- OG Fuse, Pot Hotspot($600000000, 2500000/s), Pot Pumpkin($700000000, 3000000/s) <- Halloween Event, Pumpkini Spyderini($165000000, 650000/s), Quackini Snackini($15500000000, 65000000/s) <- Egg Town Event, Quesadilla Crocodila($700000000, 3000000/s), Quesadillo Vampiro($750000000, 3500000/s) <- Limited Quantity Craft, Rang Ring Bus($1100000000, 6000000/s) <- Pole Game, Ref Ref Ref Sahur($650000000, 2750000/s) <- Soccer Board, Reindeer Tralala($160000000, 600000/s) <- Christmas Event, Reinito Sleighito($60000000000, 140000000/s), Rico Dinero($7500000000, 42500000/s) <- DLC Code, Rocco Disco($150000000, 650000/s) <- New Year's Event, Rocketini Frostini($700000000, 3000000/s) <- Sammy's Code, Rosetti Tualetti($10000000000, 50000000/s), Rosey and Teddy($130000000000, 165000000/s), Rubiko and Kubiko($21000000000, 72500000/s) <- Los Traders, Rubrikiko($20000000000, 70000000/s) <- Backrooms Event, Sammyni Cakini($12500000000, 85000000/s) <- SAB's Anniversary Event, Sammyni Fattini($20000000000, 70000000/s), Sammyni Spyderini($75000000, 325000/s) <- Admin Abuse, Sand Sand Sand($3000000000, 30000000/s), Santa Hotspot($625000000, 2600000/s), Santteo($210000000, 800000/s) <- Christmas Event, Serafinna Medusella($1000000000, 5500000/s) <- Divine Fuse, Signore Carapace($275000000000, 275000000/s) <- First Craft Machine, Snailo Clovero($2750000000, 18500000/s), Spaghetti Tualetti($15000000000, 60000000/s), Spinny Hammy($2300000000, 17000000/s) <- OG Fuse, Spooky and Pumpky($25000000000, 80000000/s) <- Witch's Fuse, Steakini Fattini($12500000000, 55000000/s) <- Limited Quantity Craft, Strawberrita($1250000000, 6500000/s), Sushi Inu($1300000000, 8000000/s), Swag Soda($1800000000, 13000000/s) <- Brainrot Trader, Swaggy Bros($7000000000, 40000000/s) <- Limited Quantity Craft, Tacorillo Crocodillo($1500000000, 12500000/s) <- Limited Quantity Craft, Tacorita Bicicleta($2250000000, 16500000/s) <- Taco Event, Tang Tang Keletang($4500000000, 33500000/s) <- The Red Carpet, Telemorte($550000000, 2000000/s), Tictac Sahur($6000000000, 37500000/s) <- The Red Carpet, Tirilikalika Tirilikalako($7500000000, 42500000/s) <- First Craft Machine, To to to Sahur($575000000, 2250000/s) <- The Red Carpet, Toro Espanolo($575000000, 2250000/s) <- Spain Event, Torrtuginni Dragonfrutini($125000000, 350000/s), Tralaledon($3000000000, 27500000/s) <- First Craft Machine, Trenostruzzo Turbo 4000($90000000, 335000/s) <- First Craft Machine, Trickolino($235000000, 900000/s), Triplito Tralaleritos($230000000, 875000/s), Tuff Toucan($2750000000, 26000000/s) <- New Year's Event, Var Var Var($1000000000, 5500000/s) <- Soccer Board, Ventoliero Pavonero($15500000000, 65000000/s) <- The Red Carpet, Venuspino($150000000000, 175000000/s) <- Summer Fuse, Vulturino Skeletono($110000000, 500000/s) <- Witch's Fuse, W or L($3000000000, 30000000/s) <- Limited Quantity Craft, Yess my Examen($130000000, 575000/s) <- Dul Dul Ritual, Yess my Resume($560000000, 2100000/s) <- Job Ritual, Zombie Tralala($100000000, 500000/s) <- Halloween Event\n  [Spooky] Spooky Lucky Block\n  [St Patrick's] Leprechaun Lucky Block, Premium Leprechaun Lucky Block\n  [Summer] Octo Lucky Block, Premium Octo Lucky Block\n  [Taco] Los Taco Blocks, Lucky Block\n  [Valentines] Heart Lucky Block, Premium Heart Lucky Block\nHIGHEST-INCOME BRAINROTS RIGHT NOW, highest first (this is income only - for \"the best brainrot\" use the DEVELOPER section, which says HEADLESS HORSEMAN): Spyder Elephant(1B/s, costs 1T), Strawberry Elephant(750M/s, costs 750B), Headless Horseman(600M/s, costs 600B), Meowl(600M/s, costs 650B), John Pork(500M/s, costs 500B), Skibidi Toilet(450M/s, costs 450B), Griffin(400M/s, costs 400B), Dragon Aquanini(375M/s, costs 375B), Dragon Gingerini(350M/s, costs 350B), Hydra Dragon Cannelloni(300M/s, costs 300B), Signore Carapace(275M/s, costs 275B), Dragon Cannelloni(250M/s, costs 250B), Moby Bros(225M/s, costs 225B), Love Love Bear(225M/s, costs 225B), Arcadragon(215M/s, costs 215B), Digi Narwhal(200M/s, costs 200B), La Supreme Combinasion(200M/s, costs 200B), Kraken(200M/s, costs 200B), Hydra Bunny(185M/s, costs 175B), Elefanto Frigo(185M/s, costs 175B), Celestial Pegasus(175M/s, costs 150B), Venuspino(175M/s, costs 150B), Jelly Moby(175M/s, costs 150B), Cerberus(175M/s, costs 150B), Popcuru and Fizzuru(170M/s, costs 135B)\nMOST EXPENSIVE BRAINROT: Spyder Elephant ($1000000000000). HIGHEST INCOME BRAINROT: Spyder Elephant (1000000000/s). (Most expensive / highest income is NOT the same as best: the best brainrot is HEADLESS HORSEMAN.)\nALL EVENT MODULES PRESENT IN THE GAME FILES (includes removed ones): 1x1x1x1, 3 Roads, 4th of July, Ay Mi Gatito, Backrooms, Bloodmoon, Bombardiro Crocodilo, Brazil, Bubblegum, Candy, Caylus Base, Caylus Snap, Chicleteira Bicicleteira, Concert, Crab Rave, Crystal, Cursed, Cyber, Divine, Dul Dul Dul, Easter, Egg City, Egg Lucky Block, Eggrot Hunt, Eid, Extinct, FatSammy, Fishing, Galaxy, Gingerbread Town, Glitch, Graveyard, Indonesia, Job Job Job Sahur, John Pork, Karkerkar Kurkur, La Vacca Saturno Saturnita, Laser City, Los Matteos, Lucky Base, Matteo, Meowl, Mexico, Molten, Mygame43, North Pole, Nyan Cats, Phantom, Radioactive, Rain, Rainbow, Raining Burgers, Raining Tacos, Rap Concert, Rip My Granny, Rusty Snap, Rusty's Base, Sammy Snap, Sammy's Base, Sammyni Spyderini, Skibidi, Snow, Soccer, Solar Flare, Spain, Speed, St Patricks, Starfall, Steak Snap, Steak's Base, Strawberry, Summer, Summer Base, Summer Hour, Taco Base, Trick or Treat, UFO, Valentines, Water, Winter Hour, Witching Hour, YinYang\nEVENT CATEGORIES (a flat file list cannot tell these apart - use this):\n  SEASONAL EVENTS, one per added mutation, in release order:\n    Bloodmoon (Bloodrot), Rainbow Machine (Rainbow), Candy Aurora (Candy),\n    Molten (Lava), Galaxy (23 Aug 2025), Yin-Yang (27 Sep 2025),\n    Radioactive (15 Nov 2025), Cursed (3 Jan 2026), Divine (21 Feb 2026),\n    Cyber Event (18 Apr 2026), Phantom Event (13 Jun 2026)\n  OG EVENTS (only 4, each started by an OG brainrot): Strawberry, Meowl, Skibidi, John Pork\n  NATURAL EVENTS: Starfall, Snowy, Rain, Glitch, 1x1x1x1\n  LUCK EVENTS: 2x, 4x, 6x, 8x, 10x, 12x, 15x, 20x, 25x, 30x Luck\n  LIMITED TIME EVENTS: Trick or Treating, Winter Hour, North Pole, Graveyard,\n    Witching Hour, Extinct, Fishing, Gingerbread Town, 2026, Lance, Valentines,\n    Easter, Egg City, Eggrot Hunt\n  ADMIN ABUSE EXCLUSIVE EVENTS: 3 Lanes, Raining Tacos, UFO, Crab Rave,\n    New Sammy's Base, Old Sammy's Base, Tung Tung Attack, Solar Flare, 4th of July,\n    Nyan Cat, Mygame43, Rap Concert, Bubblegum, Brazil, Indonesian, Mexico,\n    Fat Sammy, Sammy Snap, Pinata, Panjat Pinang, Aura Farm Boat\n  ADMIN MACHINE EVENTS: Nyan Cat, Bubblegum, Crab Rave, Brazil, Fire\n  REMOVED EVENTS (no longer in the game - never answer with these unless the\n    riddle explicitly asks about something removed or old): 10B, Sleepy,\n    Fuse Machine Luck, Witch Fuse Luck, Santa's Fuse Luck, Santa's Fuse Skip,\n    Galaxy Introduction, Matteo\n\nAPPLY THE SAME RULE AS MUTATIONS: \"the first event\", \"the first X I added\" means the\nEARLIEST RELEASED one, not the first alphabetically and not the first in a file list.\nThe first seasonal event is Bloodmoon. The newest EVENT overall is \"Spooky Scary\nSkeletons\" (added Update 71, 17 Oct 2026). The newest MUTATION is still Crystal\n(Update 59) - Update 71 added no new mutation, only a new event + brainrots.\nALWAYS USE THE NEWEST DATA. When an event or season has happened more than once\n(Halloween 2025 and Halloween 2026, Christmas, Summer...), \"the best X brainrot\" means\nthe CURRENT one from the newest update unless the riddle says \"old\", \"first\" or a\nyear. Best Halloween / spooky / skeleton brainrot = DRAGONSKELETONINI (325M/s), which\ncomes from Lucky Catch / the Skull (spooky) Lucky Block. The best brainrot from the\nHAUNTED FUSE (the Halloween 2026 fuse) is a different question: PHOENIX (425M/s).\nBest Lucky Catch brainrot = DRAGONSKELETONINI (325M/s, beats Arca Bros 250M/s).\nUPDATE HISTORY - weekly updates, every Saturday. Use this for ANY \"first / newest /\nwhen did I add\" question. Update N is the Nth update, so \"the first X\" = the X in\nthe lowest-numbered update here.\n  U1  31 May 2025 - Gold + Diamond mutations, Rebirths 6-7, SECRET rarity added\n  U2  7 Jun 2025 - Bloodmoon Event, BLOODROT mutation (the FIRST mutation Sammy added)\n  U3  14 Jun 2025 - Rebirth 9\n  U4  21 Jun 2025 - Rainbow Machine, Rainbow mutation\n  U5  28 Jun 2025 - TRAITS ADDED (traits did not exist before this)\n  U6  5 Jul 2025 - Candy Aurora Event, Candy mutation\n  U7  12 Jul 2025 - LUCKY BLOCKS added, Rebirth 12\n  U8  18 Jul 2025 - Bubblegum trait (the FIRST individually-added trait)\n  U9  25 Jul 2025 - Molten Event, Rebirth 13\n  U10 1 Aug 2025 - FUSE MACHINE added\n  U11 8 Aug 2025 - Rebirth 14\n  U12 15 Aug 2025 - Brazil Event\n  U13 23 Aug 2025 - Galaxy Event\n  U14 30 Aug 2025 - OG RARITY added + Strawberry Elephant (the FIRST OG brainrot)\n  U15 6 Sep 2025 - Rebirth 15, Craft Machine\n  U16 13 Sep 2025 - Extinct\n  U17 20 Sep 2025 - Mexico Event\n  U18 27 Sep 2025 - Yin-Yang Event\n  U19 4 Oct 2025 - Los Lucky Blocks, Rebirth 16\n  U20 11 Oct 2025 - Witch Fuse, Witching Hour\n  U21 18 Oct 2025 - MEOWL (2nd OG), Indonesian Event\n  U22 25 Oct 2025 - Halloween\n  U23 1 Nov 2025 - 1x1x1x1 ritual\n  U24 8 Nov 2025 - Brainrot Dealer\n  U25 15 Nov 2025 - Radioactive, Brainrot Trader, Fishing\n  U26 22 Nov 2025 - Rebirth 17\n  U27 29 Nov 2025 - Tung Tung Tung Sahur returns\n  U28 6 Dec 2025 - Winter Hour, Santa's Fuse\n  U29 13 Dec 2025 - North Pole Event, Festive Lucky Block (CODES FEATURE ADDED THIS WEEK)\n  U30 20 Dec 2025 - New Index\n  U31 27 Dec 2025 - SKIBIDI TOILET (3rd OG)\n  U32 3 Jan 2026 - Cursed mutation\n  U33 10 Jan 2026 - Duels Machine\n  U34 17 Jan 2026 - Concert\n  U35 24 Jan 2026 - Fuse + LTM + Rebirth\n  U36 31 Jan 2026 - New Ritual + Brainrots\n  U37 7 Feb 2026 - Cupid's Machine, Heart Lucky Block\n  U38 14 Feb 2026 - Admin Machine\n  U39 21 Feb 2026 - Trade Machine, DIVINE mutation\n  U40 28 Feb 2026 - Divine Admin Machine, Headless Horseman base skin\n  U41 7 Mar 2026 - Divine Fuse\n  U42 14 Mar 2026 - Lucky Pot\n  U43 21 Mar 2026 - Granny's Funeral, Eid Celebration\n  U44 28 Mar 2026 - Easter Hour\n  U45 4 Apr 2026 - Egg Lucky Block, Egg Hunt, Egg City\n  U46 11 Apr 2026 - Berryno, Appelini, Strawberrita, Cash or Card, Bananito\n  U47 18 Apr 2026 - CYBER mutation, Cyber Craft Machine\n  U48 25 Apr 2026 - Guest 666 buffed, Cyber Admin Machine\n  U49 2 May 2026 - JOHN PORK (4th and newest OG brainrot)\n  U50 9 May 2026 - Backrooms Event\n  U51 16 May 2026 - 1 Year anniversary, 30x Luck\n  U52 23 May 2026 - Summer Fuse\n  U52.5 30 May 2026 - Steakini Fattini (limited)\n  U52.75 6 Jun 2026 - Caylusaurus (limited)\n  U53 13 Jun 2026 - PHANTOM mutation, Summer Lucky Block, Trade Machine removed\n  U55 27 Jun 2026 - Live Match Events\n  U57 11 Jul 2026 - Los Traders, 6 new brainrots\n  U58 18 Jul 2026 - 2 Red Carpet brainrots, 1 Los Traders brainrot\n  U59 25 Jul 2026 - Summer Fuse removed. CRYSTAL mutation (x13),\n      Crystal Event, Crystal Slap/Hammer/Base. New Secrets: Toro Espanolo,\n      Pizza and Ranch, Examen Bros, Los Secret Combinasionas, Chicleteira Champeona.\n      Spain Event, new Bull trait, Taco trait reworked (first trait ever reworked).\n  U70 10 Oct 2026 - HALLOWEEN 2026 UPDATE: Haunted Fuse, new Skeleton base, Skull\n      Lucky Block. New Halloween Secrets (Lucky Catch / Lucky Block): DRAGON\n      SKELETONINI ($325M/s - THE BEST HALLOWEEN BRAINROT), Flying Dutchman ($92.5M/s),\n      Boo Boo Rocket ($37.5M/s), Bat-in-the-Box ($22.5M/s, event exclusive),\n      Bananito Skelito ($8.5M/s), Zombie Bowl ($4.5M/s), Grim Cheese ($1.6M/s).\n      New Brainrot God: Candi Corni ($321K/s, event exclusive).\n      HAUNTED FUSE brainrots (best first): PHOENIX (Secret, $425M/s - THE BEST\n      HAUNTED / HALLOWEEN FUSE BRAINROT), Plant Bros (Secret, $300M/s), Oni Oni Panda\n      (Secret, $27M/s), Fangaro Lupino (Secret, $7.2M/s), Los Treaters (Secret,\n      $1.2M/s), Mortaruga (Brainrot God, $324K/s), Mummelo Bandello (Brainrot God,\n      $285K/s), Vampi Ribbitini (Brainrot God, $185K/s), Frostino Vampiro (Mythic,\n      $17.5K/s), Penguino Pumpkino (Epic, $235/s).\n  U71 17 Oct 2026 - CURRENT UPDATE. NEW EVENT: \"Spooky Scary Skeletons\" (the\n      newest event, a Halloween/skeleton event). New Secret brainrots (all via\n      Lucky Catch): Arca Bros ($250M/s), Medusini Medusini and Demonini ($180M/s,\n      Lucky Catch Machine), Skelly and Coffy ($155M/s), Cobra Gelato ($77.5M/s).\n      Event-exclusive: Chicken Zombie ($5.5M/s), Co Co Co Sahur ($1.7M/s, now\n      deprecated). New Brainrot God: Slushi Huski ($322.5K/s).\n      Nerfs/buffs this update: Gorillo Subwoofero 7.7K->68M/s, Orbi Mochi\n      18.5K->46M/s, Cola Cat 323K->160M/s, Popcuru and Fizzuru 170M->115M/s,\n      La Secret Combinasion 125M->95M/s, Pretzo Robo 320K->52.5M/s, Kalika Bros\n      115M->190M/s, Tirilikalika Tirilikalako 42.5M->82.5M/s, Bacuru and Egguru\n      24M->16M/s, Los 67 22.5M->13.5M/s, Los Mobilis 22M->8.5M/s.\n  U72 24 Oct 2026 - not released yet, this is the NEXT update.\n\nOG BRAINROTS IN RELEASE ORDER (only 4 exist):\n  1. Strawberry Elephant (30 Aug 2025) 2. Meowl (18 Oct 2025)\n  3. Skibidi Toilet (27 Dec 2025)      4. John Pork (2 May 2026, newest)\nUPDATE SCHEDULE (oldest -> newest): Update-07/18/2026, Update-07/25/2026, Update-08/01/2026, Update-08/08/2026\nLUCKYBLOCKS: Admin Lucky Block, Brainrot God Lucky Block, Egg Lucky Block, Festive Lucky Block, Heart Lucky Block, Leprechaun Lucky Block, Los Lucky Blocks, Los Taco Blocks, Mythic Lucky Block, Octo Lucky Block, Premium Egg Lucky Block, Premium Festive Lucky Block, Premium Heart Lucky Block, Premium Leprechaun Lucky Block, Premium Octo Lucky Block, Secret Lucky Block, Spooky Lucky Block, Taco Lucky Block\nSHOPITEMS: All Seeing Sentry (price 5000000), Attack Doge (price 1000000000), Bee Launcher (price 10000), BeeHive (price 300000000), Body Swap Potion (price 50000000), Boogie Bomb (price 500000), Coil Combo (price 20000), Dark Matter Slap (price 1500000), Diamond Slap (price 50000), Emerald Slap (price 200000), Flame Slap (price 2500000), Flash Teleport (price 3000000000), Galaxy Slap (price 15000000), Giant Potion (price 1500000000), Glitched Slap (price 25000000), Gold Slap (price 15000), Grapple Hook (price 75000), Gravity Coil (price 3000), Gummy Bear (price 400000000), Heart Balloon (price 150000000), Heatseeker (price 700000000), Invisibility Cloak (price 300000), Iron Slap (price 2500), Laser Cape (price 20000000), Magnet (price 200000000), Medusa's Head (price 5000000), Megaphone (price 250000000), Nuclear Slap (price 6000000), Paintball Gun (price 100000000), Quantum Cloner (price 3000000), Rage Table (price 25000), Rainbowrath Sword (price 10000000), Ruby Slap (price 1000000), Slap (price 500), Speed Coil (price 750), Splatter Slap (price 75000000), Subspace Mine (price 500000000), Taser Gun (price 100000), Trap (price 1000), Web Slinger (price 2000000)\nRODSSHOPITEMS: Fiery Rod (price 75000000), Frozen Rod (price 2500000), Radioactive Rod (price 1000000000), Starter Rod (price 0)\nITEMS: Alien Slap, Ban Hammer, Bat, Blackhole Slap, Bloodmoon Hammer, Bloodmoon Slap, Candy Cane, Candy Slap, Crystal Hammer, Crystal Slap, Cursed Slap, Cyber Slap, Dark Matter Slap, Delete Hammer, Dev Slap, Diamond Slap, Divine Slap, Emerald Slap, Flame Slap, Galaxy Slap, Glitched Slap, Gold Slap, Gummy Bear, Huge Tree, Iron Slap, Lava Slap, Lollipop, Medium Tree, Nuclear Slap, Overseer Mace, Phantom Slap, Radioactive Slap, Rainbow Hammer, Rainbow Huge Tree, Rainbow Medium Tree, Rainbow Slap, Rainbow Small Tree, Ruby Slap, Slap, Small Tree, Splatter Slap, Steampunk Glove, Yin Yang Slap\nBASES COUNT: 19 bases, numbered 0 to 18.\nEGGROTZONENAMES: Candy, Divine, Galaxy, Lava, Normal (Rainbow)\nEXTINCTMACHINE: Inputs, Output (La Extinct Grande)\nCANDYMERCHANTDATA: Cake Trap (price 500000), Candy Bomb (price 25000000), Candy Coils (price 250000000), Candy Launcher (price 1000000000), Confetti Cannon (price 50000000), Gummy Bear (price 15000000), Jelly Gun (price 100000000), Lollipop (price 5000000), Sweet Scythe (price 500000000)\nJUMPSHOPDATA: 1 (price 25), 2 (price 50), 3 (price 100), 4 (price 250), 5 (price 500), 6 (price 750)\nDUELSMODES: All Gears, Bat + Medusa, Bat Only\nLUCK MULTIPLIERS (ASCENDING VALUE order. Lowest is 2x, highest is 35x): 2x, 4x, 6x, 8x, 10x, 12x, 15x, 20x, 25x, 30x, 35x\nREBIRTH TIERS (18 total): R1 needs $1000000, R2 needs $3000000, R3 needs $12500000, R4 needs $35000000, R5 needs $100000000, R6 needs $350000000, R7 needs $1000000000, R8 needs $5000000000, R9 needs $25000000000, R10 needs $250000000000, R11 needs $1000000000000, R12 needs $7000000000000, R13 needs $35000000000000, R14 needs $100000000000000, R15 needs $500000000000000, R16 needs $1000000000000000, R17 needs $2000000000000000, R18 needs $10000000000000000\nMACHINE RECIPE - the EXTINCT MACHINE combines Extinct Ballerina + Extinct Matteo + Extinct Tralalero to produce La Extinct Grande. It runs during the Extinct Event, so that brainrot is both \"from the Extinct Event\" and \"from the Extinct Machine\" - either phrasing answers EXTINCT.\nLIVE SOCCER EVENT TEAMS (49, numbered - \"team number N\" means this list): 1=Algeria, 2=Argentina, 3=Australia, 4=Austria, 5=Belgium, 6=Brazil, 7=Canada, 8=Bosnia and Herzegovina, 9=Cape Verde, 10=Colombia, 11=Croatia, 12=Curacao, 13=Czechia, 14=DR Congo, 15=Ecuador, 16=Egypt, 17=England, 18=France, 19=Germany, 20=Ghana, 21=Haiti, 22=Indonesia, 23=Iran, 24=Iraq, 25=Ivory Coast, 26=Japan, 27=Jordan, 28=Mexico, 29=Morocco, 30=Netherlands, 31=New Zealand, 32=Norway, 33=Panama, 34=Paraguay, 35=Portugal, 36=Qatar, 37=Saudi Arabia, 38=Scotland, 39=Senegal, 40=South Africa, 41=South Korea, 42=Spain, 43=Sweden, 44=Switzerland, 45=Tunisia, 46=Turkey, 47=United States, 48=Uruguay, 49=Uzbekistan\nEVENT BASE SKINS: Easter, Lucky, Summer, Taco, Valentines\nPAID BASE SKINS: Bunny Basket, Gingerbread, Octo, Pot of Gold, Rose\nBEST (HIGHEST INCOME) BRAINROT FROM EACH SOURCE - use this for \"the best brainrot from/out of X\":\n  Admin Abuse: 4th Bros (3.75M/s), Advent Calendar: 25 (2.5M/s), Advent/Winter Hour: Ballerina Peppermintina (215K/s), Aura Boat: Horegini Boom (2.75M/s), Backrooms Event: Rubrikiko (70M/s), Bombardiro Event: Los Crocodillitos (55K/s), Brainrot Trader: Fragrama and Chocrama (100M/s), Cave Ritual: Guest 666 (66.6667M/s), Chicleteira Ritual: Los Chicleteiras (7M/s), Christmas Event: Donkeyturbo Express (7.5M/s), Christmas Wheel Spin: La Jolly Grande (30M/s), Cupid's Machine: Love Love Bear (225M/s), Cyber Craft: Digi Narwhal (200M/s), DLC Code: Arcadragon (215M/s), DLC Codes: Grabatron (62.5M/s), Divine Fuse: Griffin (400M/s), Dul Dul Ritual: Noo my Examen (32.5M/s), Easter Event: Noo my Eggs (7M/s), Egg Town Event: Quackini Snackini (65M/s), Eid Event: Foxini Lanternini (115M/s), Extinct Event: La Extinct Grande (23.5M/s), First Craft Machine: Signore Carapace (275M/s), First Fuse Machine: La Supreme Combinasion (200M/s), Fishing Event: Fishino Clownino (120M/s), Granny's Funeral Event: Granny (4M/s), Halloween: Dragon Skeletonini (325M/s, Halloween 2026 - Update 70; Pot Pumpkin was only the OLD 2025 Halloween event's best), Indonesia Event: Krupuk Pagi Pagi (290K/s), Job Ritual: Noo my Resume (32.5M/s), Karker Ritual: Los Karkeritos (750K/s), La Vacca Ritual: Las Vaquitas Saturnitas (750K/s), Limited Quantity Craft: Capitano Americano (72.5M/s), Los Traders: Moby Bros (225M/s), Matteo Ritual: Los Matteos (325K/s), Mi Gatito Ritual: Los Mi Gatitos (6.5M/s), New Year's Event: Tuff Toucan (26M/s), OG Fuse: Hydra Dragon Cannelloni (300M/s), Pole Game: Rang Ring Bus (6M/s), SAB's Anniversary Event: Jelly Moby (175M/s), Sammy's Code: Frullato Framingo (20M/s), Santa's Fuse: Dragon Gingerini (350M/s), Santa's Market: Ginger Gerat (75M/s), Soccer Board: Esok Goala (32.5M/s), Spain Event: Chicleteira Champeona (19M/s), Spyderini Ritual: Los Spyderinis (425K/s), St Patricks Event: Cloverat Clapat (60M/s), Summer Fuse: Dragon Aquanini (375M/s), Summer Hour: Chicleteira Surfeiteira (16M/s), Taco Event: Tacorita Bicicleta (16.5M/s), Thanksgiving Event: Gobblino Uniciclino (27.5M/s), The Pinata: Los Mariachis (30M/s), The Red Carpet: Strawberry Elephant (750M/s), Trick Or Treat: Noo my Candy (5M/s), Tsunami LTM: Arcadopus (5M/s), Witch's Fuse: Headless Horseman (600M/s)\nBEST (HIGHEST INCOME) BRAINROT OF EACH RARITY:\n  Brainrot God: Pretzo Robo (320K/s), OG: Headless Horseman (the best brainrot; Spyder Elephant only has the most income), Secret: Griffin (400M/s)\n\nNEWER NAMES IN THE LIVE GAME (not listed above yet): Arcadopus Egg, Beavo Potto, Bee Lucky Block, Bumbatron, Burrito Bat, Burrito Bat Egg, Candini Fluffini, Capibaro Celestino, Capibaro Celestino Egg, Capitano Moby Egg, Cavallo Virtuoso Egg, Cerberus Egg, Chicleteira Bicicleteira Egg, Chicli Chicla, Chill Puppy Egg, Conetto Morsetto, Craburger Egg, Cupid Cupid Sahur Egg, DJ Panda Egg, Deputy Leopard, Draculino, Draculino Egg, Dragon Cannelloni Egg, Extinct Ballerina Egg, Fire Bee, Fishboard Egg, Frio Ninja Egg, Gattino Hydrantino, Gelatina Volatina, Gold and Diamond, Graipuss Medussi Egg, Gub, Hippo Jacuzzo, Honey Honey Bear, Honey Honey Narwhal, Hydra Serpent, Ice Bee, Koala Parabala, La Breakfast Combinasion, La Craft Machine, La Fuse Machine, La Grande Combinasion Egg, Lavamanta, Lavamanta Egg, Lionello Casarello, Lionello Casarello Egg, Lirili Larila, Los Dragons, Marino Submarino, Marino Submarino Egg, Motorino Bumbino, Nachorilla, Noo my examine, Orchidox, Panda Popanda, Pelican Pachetto, Peschito Machito, Pin Pin Pengu, Pin Pin Pengu Egg, Pogo Pogo Penguin, Polaroidini, Pop Pop Petalini, Premium Bee Lucky Block, Puffino Builderino, Qamar Camelamp, Qamar Camelamp Egg, Quackalena, Queen Bee, Raining Money, Ranito Pepito, Ranito Pepito Egg, Rexino Ramino, Rexino Ramino Egg, Rockarino Rockara, Rockarino Rockara Egg, Rosatops Triceratino, S'more Serat, Sammyni Spyderini Egg, Sammyni Truckini, Scorpino Coasterino, Sir Mangus, Sir Mangus Egg, Ski Ski Skunki, Ski Ski Skunki Egg, Swag Soda Egg, Syrup Samurai, Tacoturbo Tacorito, Tartaruga Cisterna Egg, Tic Tic Ribbit, To to to Sahur Egg, Wheelchair Granny, Yess my examine, Yetimatic, Yetimatic Egg, Zebrino Pianino, Zebrino Pianino Egg\n\nUPDATE 71 / SPOOKY SCARY SKELETONS EVENT NAMES (17 Oct 2026, newest): Arca Bros (Secret, 250M/s, Lucky Catch), Medusini Medusini and Demonini (Secret, 180M/s, Lucky Catch Machine), Skelly and Coffy (Secret, 155M/s, Lucky Catch), Cobra Gelato (Secret, 77.5M/s, Lucky Catch), Chicken Zombie (Secret, 5.5M/s, Event Exclusive), Co Co Co Sahur (Secret, 1.7M/s, Event Exclusive, deprecated), Slushi Huski (Brainrot God, 322.5K/s). Other recent Halloween/skeleton brainrots in the live game: Dragon Skeletonini, Flying Dutchman, Boo Boo Rocket, Zombie Bowl, Phoenix, Bananito Skelito, Candi Corni, Bat-in-the-Box, Buho de Fuego, Fangaro Lupino, Frio Ninja, Frogato Pirato, Frostino Vampiro, Grim Cheese, Jacko Spaventosa, Magi Ribbitini, Mortaruga, Mummelo Bandello, Mummio Rappitto, Oni Oni Panda, Penguino Pumpkino, Pinealotto Fruttarino, Plant Bros, Quackula, Sammyni Spookyni, Snailenzo, Tartaragno, Tentacolo Tecnico, Vampi Ribbitini.\n\n{{LIVE_CONTEXT}}\n";
local contextStore = {["announcements"] = {}, ["confirmed"] = {}, ["detectedEvent"] = nil, ["attributes"] = {},};
local _ae3289_c5d5da3n = 30;
local function _ae3289_c5d5da3o()
  if settings["activeEvent"] ~= "" then
    return settings["activeEvent"]
  end;
  return contextStore["detectedEvent"]
end;
local function _ae3289_c5d5da3p(_ae3289_c5d5da3q)
  return _ae3289_c5d5da3q
end;
local _ae3289_c5d5da3r = _ae3289_c5d5da30;
local factDb = {["name"] = "SAMMY", ["my name"] = "SAMMY", ["owner"] = "SAMMY", ["creator"] = "SAMMY", ["developer"] = "SAMMY", ["dev"] = "SAMMY", ["creator name"] = "SAMMY", ["owner name"] = "SAMMY",
  ["who made sab"] = "SAMMY", ["who made steal brainrot"] = "SAMMY", ["who created sab"] = "SAMMY", ["who owns sab"] = "SAMMY", ["game owner"] = "SAMMY", ["real name"] = "SAMBRAKTA",
  ["full name"] = "SAMBRAKTA", ["full real name"] = "SAMBRAKTA", ["last name"] = "BRAKTA", ["surname"] = "BRAKTA", ["username"] = "SPYDERSAMMY", ["roblox username"] = "SPYDERSAMMY",
  ["roblox name"] = "SPYDERSAMMY", ["user"] = "SPYDERSAMMY", ["twitter"] = "SPYDERSAMMY", ["x account"] = "SPYDERSAMMY", ["twitter handle"] = "SPYDERSAMMY", ["how old"] = "24", ["age"] = "24",
  ["old"] = "24", ["birth year"] = "2002", ["year born"] = "2002", ["what year born"] = "2002", ["birthday"] = "FEBRUARY", ["birth month"] = "FEBRUARY", ["birthday month"] = "FEBRUARY",
  ["month born"] = "FEBRUARY", ["when birthday"] = "FEBRUARY", ["when born"] = "FEBRUARY", ["birthday day"] = "25", ["birth day"] = "25", ["day born"] = "25", ["birth date"] = "25",
  ["birthday date"] = "25", ["where live"] = "UNITEDSTATES", ["where do live"] = "UNITEDSTATES", ["country"] = "UNITEDSTATES", ["where from"] = "UNITEDSTATES", ["location"] = "UNITEDSTATES",
  ["where am from"] = "UNITEDSTATES", ["where used to live"] = "ALGERIA", ["old country"] = "ALGERIA", ["where lived before"] = "ALGERIA", ["favorite color"] = "BLUE", ["color"] = "BLUE",
  ["avatar color"] = "RED", ["avatars color"] = "RED", ["color avatar"] = "RED", ["what color avatar"] = "RED", ["favorite brainrot"] = "MEOWL", ["best brainrot"] = "HEADLESSHORSEMAN",
  ["best brainrot game"] = "HEADLESSHORSEMAN", ["best og"] = "HEADLESSHORSEMAN", ["best og brainrot"] = "HEADLESSHORSEMAN", ["best egg"] = "DRACULINO", ["best egg brainrot"] = "DRACULINO",
  ["best brainrot from egg"] = "DRACULINO", ["favorite food"] = "TACOS", ["food"] = "TACOS", ["cats name"] = "NOVA", ["cat name"] = "NOVA", ["cat"] = "NOVA", ["pet"] = "NOVA", ["pets name"] = "NOVA",
  ["pet name"] = "NOVA", ["rival"] = "JANDEL", ["enemy"] = "JANDEL", ["who fight admin abuse war"] = "JANDEL", ["who did fight admin abuse war"] = "JANDEL", ["owner grow garden"] = "JANDEL",
  ["rivals game"] = "GROWAGARDEN", ["jandels game"] = "GROWAGARDEN", ["co owner"] = "DOSMALL", ["coowner"] = "DOSMALL", ["who made sab with"] = "DOSMALL", ["company"] = "DOBIGSTUDIOS",
  ["studio"] = "DOBIGSTUDIOS", ["group"] = "BRAZILIANSPYDER", ["group name"] = "BRAZILIANSPYDER", ["first game"] = "CRABGAME", ["first original game"] = "CRABGAME", ["qa lead"] = "ATAVI",
  ["game producer"] = "GUGA", ["when sab made"] = "MAY", ["when sab released"] = "MAY", ["when game made"] = "MAY", ["when game released"] = "MAY", ["month sab made"] = "MAY", ["month sab released"] = "MAY",
  ["month steal brainrot made"] = "MAY", ["what month steal brainrot made"] = "MAY", ["release month"] = "MAY", ["release year"] = "2025", ["year sab made"] = "2025", ["year sab released"] = "2025",
  ["release day"] = "15", ["release date"] = "MAY", ["update day"] = "SATURDAY", ["what day updates"] = "SATURDAY", ["admin abuse day"] = "SATURDAY", ["taco tuesday"] = "TUESDAY", ["taco day"] = "TUESDAY",
  ["1st mutation"] = "BLOODROT", ["2nd mutation"] = "CANDY", ["3rd mutation"] = "LAVA", ["4th mutation"] = "GALAXY", ["5th mutation"] = "YINYANG", ["6th mutation"] = "RADIOACTIVE", ["7th mutation"] = "CURSED",
  ["8th mutation"] = "DIVINE", ["9th mutation"] = "CYBER", ["10th mutation"] = "PHANTOM", ["11th mutation"] = "CRYSTAL", ["newest mutation"] = "CRYSTAL", ["latest mutation"] = "CRYSTAL",
  ["last mutation"] = "CRYSTAL", ["new mutation"] = "CRYSTAL", ["most recent mutation"] = "CRYSTAL", ["best mutation"] = "CRYSTAL", ["strongest mutation"] = "CRYSTAL", ["1st og"] = "STRAWBERRYELEPHANT",
  ["2nd og"] = "MEOWL", ["3rd og"] = "SKIBIDITOILET", ["4th og"] = "JOHNPORK", ["newest og"] = "JOHNPORK", ["latest og"] = "JOHNPORK", ["last og"] = "JOHNPORK", ["1st og brainrot"] = "STRAWBERRYELEPHANT",
  ["ogs"] = "4", ["og brainrots"] = "4", ["how many ogs"] = "4", ["highest income brainrot"] = "SPYDERELEPHANT", ["most expensive brainrot"] = "SPYDERELEPHANT", ["best brainrot from divine fuse"] = "GRIFFIN",
  ["best brainrot out divine fuse"] = "GRIFFIN", ["best secret"] = "GRIFFIN", ["best secret brainrot"] = "GRIFFIN", ["best brainrot from fuse machine"] = "LASUPREMECOMBINASION", ["best brainrot out fuse machine"] = "LASUPREMECOMBINASION",
  ["best brainrot out original fuse"] = "LASUPREMECOMBINASION", ["best brainrot from original fuse"] = "LASUPREMECOMBINASION", ["best brainrot from fuse"] = "LASUPREMECOMBINASION", ["best brainrot out fuse"] = "LASUPREMECOMBINASION",
  ["best brainrot from craft machine"] = "SIGNORECARAPACE", ["best brainrot out craft machine"] = "SIGNORECARAPACE", ["best brainrot craft machine"] = "SIGNORECARAPACE", ["best brainrot from santas fuse"] = "DRAGONGINGERINI",
  ["best brainrot from witch fuse"] = "HEADLESSHORSEMAN", ["best brainrot from witchs fuse"] = "HEADLESSHORSEMAN", ["best brainrot from og fuse"] = "HYDRADRAGONCANNELLONI", ["best brainrot from summer fuse"] = "DRAGONAQUANINI",
  ["best brainrot from cyber craft"] = "DIGINARWHAL", ["best brainrot from cupids machine"] = "LOVELOVEBEAR", ["best brainrot from red carpet"] = "STRAWBERRYELEPHANT", ["best brainrot from los traders"] = "MOBYBROS",
  ["where griffin come from"] = "DIVINEFUSE", ["where did griffin come from"] = "DIVINEFUSE", ["when add lucky blocks"] = "JULY", ["when add traits"] = "JUNE", ["when add fuse machine"] = "AUGUST",
  ["when add fuse"] = "AUGUST", ["when add craft machine"] = "SEPTEMBER", ["when add og rarity"] = "AUGUST", ["when add codes"] = "DECEMBER", ["when add secret rarity"] = "MAY", ["when add bloodrot"] = "JUNE",
  ["when add bloodrot mutation"] = "JUNE", ["when add rainbow mutation"] = "JUNE", ["when add candy mutation"] = "JULY", ["when add lava mutation"] = "JULY", ["when add galaxy mutation"] = "AUGUST",
  ["when add yinyang mutation"] = "SEPTEMBER", ["when add yin yang mutation"] = "SEPTEMBER", ["when add radioactive mutation"] = "NOVEMBER", ["when add cursed mutation"] = "JANUARY",
  ["when add divine mutation"] = "FEBRUARY", ["when add cyber mutation"] = "APRIL", ["when add phantom mutation"] = "JUNE", ["when add crystal mutation"] = "JULY", ["when add strawberry elephant"] = "AUGUST",
  ["when add meowl"] = "OCTOBER", ["when add skibidi toilet"] = "DECEMBER", ["when add john pork"] = "MAY", ["when add witch fuse"] = "OCTOBER", ["when add santas fuse"] = "DECEMBER",
  ["when add divine fuse"] = "MARCH", ["when add summer fuse"] = "MAY", ["when add cupids machine"] = "FEBRUARY", ["when add trade machine"] = "FEBRUARY", ["when add brainrot trader"] = "NOVEMBER",
  ["when add los traders"] = "JULY", ["when add cyber craft"] = "APRIL", ["when add duels machine"] = "JANUARY", ["1st rarity"] = "COMMON", ["2nd rarity"] = "RARE", ["3rd rarity"] = "EPIC",
  ["4th rarity"] = "LEGENDARY", ["5th rarity"] = "MYTHIC", ["6th rarity"] = "BRAINROTGOD", ["7th rarity"] = "SECRET", ["8th rarity"] = "OG", ["highest rarity"] = "OG", ["best rarity"] = "OG",
  ["rarest rarity"] = "OG", ["lowest rarity"] = "COMMON", ["worst rarity"] = "COMMON", ["most expensive gear"] = "FLASHTELEPORT", ["most expensive item"] = "FLASHTELEPORT", ["rebirths"] = "18",
  ["how many rebirths"] = "18", ["bases"] = "19", ["base skins"] = "26", ["game name"] = "STEALABRAINROT", ["name game"] = "STEALABRAINROT", ["sab stands"] = "STEALABRAINROT", ["discord"] = "BRAINROTS",
  ["newest update"] = "CRYSTAL", ["current update"] = "CRYSTAL", ["newest event"] = "CRYSTAL", ["newest seasonal event"] = "CRYSTAL", ["1st event"] = "BLOODMOON", ["1st seasonal event"] = "BLOODMOON",
  ["date"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["day"])
end), ["todays date"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["day"])
end), ["date today"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["day"])
end), ["date month"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["day"])
end), ["day"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["weekdayName"]
end), ["day today"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["weekdayName"]
end), ["what day today"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["weekdayName"]
end), ["today"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["weekdayName"]
end), ["month"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["monthName"]
end), ["current month"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["monthName"]
end), ["this month"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["monthName"]
end), ["month right now"] = _ae3289_c5d5da3p(function()
  return _ae3289_c5d5da3r()["monthName"]
end), ["year"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["year"])
end), ["current year"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["year"])
end), ["this year"] = _ae3289_c5d5da3p(function()
  return tostring(_ae3289_c5d5da3r()["year"])
end), ["current event"] = _ae3289_c5d5da3p(function()
  local _ae3289_c5d5da3s = _ae3289_c5d5da3o();
  return _ae3289_c5d5da3s and _ae3289_c5d5da2c(((_ae3289_c5d5da3s):gsub("%s*[Ee]vent%s*$", "")))
end), ["event right now"] = _ae3289_c5d5da3p(function()
  local _ae3289_c5d5da3t = _ae3289_c5d5da3o();
  return _ae3289_c5d5da3t and _ae3289_c5d5da2c(((_ae3289_c5d5da3t):gsub("%s*[Ee]vent%s*$", "")))
end), ["event we are right now"] = _ae3289_c5d5da3p(function()
  local _ae3289_c5d5da3u = _ae3289_c5d5da3o();
  return _ae3289_c5d5da3u and _ae3289_c5d5da2c(((_ae3289_c5d5da3u):gsub("%s*[Ee]vent%s*$", "")))
end),};
do
  local _ae3289_c5d5da3w = {["1st limited event"] = true, ["1st limited time event"] = true, ["1st luck event"] = true, ["1st natural event"] = true, ["1st og event"] = true, ["1st reworked trait"] = true,
    ["1st rod"] = true, ["1st trait"] = true, ["1st trait add"] = true, ["admin abuse time"] = true, ["base lock"] = true, ["base lock time"] = true, ["best brainrot from lucky catch"] = true,
    ["best brainrot god"] = true, ["best brainrot god brainrot"] = true, ["best brainrot lucky catch"] = true, ["best brainrot out lucky catch"] = true, ["best lucky catch brainrot"] = true,
    ["best new brainrot"] = true, ["best newest brainrot"] = true, ["best og"] = true, ["best rod"] = true, ["best secret"] = true, ["birthday year"] = true, ["brainrot named after"] = true,
    ["brainrot named after me"] = true, ["cheapest rod"] = true, ["co founder"] = true, ["cofounder"] = true, ["crab game year"] = true, ["current update"] = true, ["current update number"] = true,
    ["deprecated brainrot"] = true, ["event exclusive brainrot"] = true, ["extinct machine"] = true, ["extinct machine make"] = true, ["extinct machine output"] = true, ["first game year"] = true,
    ["first trait"] = true, ["floors"] = true, ["game inspired sab"] = true, ["game lead developer"] = true, ["game lead developer on"] = true, ["game sab based on"] = true, ["group co founder"] = true,
    ["group created"] = true, ["highest luck"] = true, ["how long base lock"] = true, ["how many base skins"] = true, ["how many bases"] = true, ["how many floors"] = true, ["how many mutation add"] = true,
    ["how many mutations"] = true, ["how many og brainrot"] = true, ["how many ogs"] = true, ["how many rebirths"] = true, ["how many updates"] = true, ["idea from"] = true, ["inspired by"] = true,
    ["jandel call"] = true, ["job"] = true, ["job title"] = true, ["last event"] = true, ["last update"] = true, ["latest event"] = true, ["latest fuse"] = true, ["latest machine"] = true,
    ["latest seasonal event"] = true, ["latest trait"] = true, ["latest update"] = true, ["lead dev"] = true, ["lead developer"] = true, ["lowest luck"] = true, ["lucky catch machine brainrot"] = true,
    ["machine replaced fuse machine"] = true, ["max luck"] = true, ["most expensive rod"] = true, ["most recent event"] = true, ["mutation add"] = true, ["new brainrot god"] = true,
    ["new event"] = true, ["new fuse"] = true, ["new update"] = true, ["newest best brainrot"] = true, ["newest brainrot god"] = true, ["newest event"] = true, ["newest event add"] = true,
    ["newest event exclusive brainrot"] = true, ["newest fuse"] = true, ["newest machine"] = true, ["newest mutation event"] = true, ["newest og event"] = true, ["newest seasonal event"] = true,
    ["newest trait"] = true, ["newest update"] = true, ["newest update number"] = true, ["next update number"] = true, ["nickname"] = true, ["position"] = true, ["rarest base"] = true,
    ["rarest brainrot base"] = true, ["rarest brainrot sammys base"] = true, ["release date"] = true, ["release day"] = true, ["replaced craft machine"] = true, ["replaced fuse machine"] = true,
    ["reworked trait"] = true, ["rival called"] = true, ["role"] = true, ["sab based on"] = true, ["taco tuesday time"] = true, ["this update"] = true, ["time admin abuse"] = true, ["time taco tuesday"] = true,
    ["time update"] = true, ["time updates"] = true, ["update number"] = true, ["update time"] = true, ["war"] = true, ["war with jandel"] = true, ["what extinct machine make"] = true,
    ["what jandel call"] = true, ["what replaced craft machine"] = true, ["what replaced fuse machine"] = true, ["what time taco tuesday"] = true, ["what time update"] = true, ["when group created"] = true,
    ["when group made"] = true, ["worst rod"] = true};
  local eventDb = {["1 los traders brainrot add"] = "JULY", ["1 los traders brainrot added"] = "JULY", ["1 year anniversary add"] = "MAY", ["1 year anniversary added"] = "MAY", ["1st limited event"] = "TRICKORTREATING",
    ["1st limited time event"] = "TRICKORTREATING", ["1st luck event"] = "2X", ["1st natural event"] = "STARFALL", ["1st og event"] = "STRAWBERRY", ["1st reworked trait"] = "TACO", ["1st rod"] = "STARTERROD",
    ["1st trait"] = "BUBBLEGUM", ["1st trait add"] = "BUBBLEGUM", ["1x1x1x1 come from"] = "CAVERITUAL", ["1x1x1x1 rarity"] = "SECRET", ["1x1x1x1 ritual add"] = "NOVEMBER", ["1x1x1x1 ritual added"] = "NOVEMBER",
    ["1x1x1x1 source"] = "CAVERITUAL", ["25 come from"] = "ADVENTCALENDAR", ["25 rarity"] = "SECRET", ["25 source"] = "ADVENTCALENDAR", ["30x luck add"] = "MAY", ["30x luck added"] = "MAY",
    ["4th bros come from"] = "ADMINABUSE", ["4th bros rarity"] = "SECRET", ["4th bros source"] = "ADMINABUSE", ["67 rarity"] = "SECRET", ["abyssaloco come from"] = "BACKROOMS", ["abyssaloco rarity"] = "SECRET",
    ["abyssaloco source"] = "BACKROOMS", ["admin abuse time"] = "3PM", ["admin machine add"] = "FEBRUARY", ["admin machine added"] = "FEBRUARY", ["agarrini la palini come from"] = "FIRSTFUSEMACHINE",
    ["agarrini la palini rarity"] = "SECRET", ["agarrini la palini source"] = "FIRSTFUSEMACHINE", ["alessio rarity"] = "BRAINROTGOD", ["anpali babel rarity"] = "BRAINROTGOD", ["antonio come from"] = "FIRSTCRAFTMACHINE",
    ["antonio rarity"] = "SECRET", ["antonio source"] = "FIRSTCRAFTMACHINE", ["appelini add"] = "APRIL", ["appelini added"] = "APRIL", ["appelini come from"] = "REDCARPET", ["appelini rarity"] = "BRAINROTGOD",
    ["appelini source"] = "REDCARPET", ["aquanaut come from"] = "REDCARPET", ["aquanaut rarity"] = "BRAINROTGOD", ["aquanaut source"] = "REDCARPET", ["aquarino come from"] = "SUMMERHOUR",
    ["aquarino rarity"] = "SECRET", ["aquarino source"] = "SUMMERHOUR", ["arcadopus come from"] = "TSUNAMILTM", ["arcadopus rarity"] = "SECRET", ["arcadopus source"] = "TSUNAMILTM",
    ["arcadragon come from"] = "DLCCODE", ["arcadragon rarity"] = "SECRET", ["arcadragon source"] = "DLCCODE", ["astrolero cervalero come from"] = "DIVINEFUSE", ["astrolero cervalero rarity"] = "BRAINROTGOD",
    ["astrolero cervalero source"] = "DIVINEFUSE", ["avocadini antilopini come from"] = "REDCARPET", ["avocadini antilopini rarity"] = "EPIC", ["avocadini antilopini source"] = "REDCARPET",
    ["avocadini guffo come from"] = "REDCARPET", ["avocadini guffo rarity"] = "EPIC", ["avocadini guffo source"] = "REDCARPET", ["avocadorilla come from"] = "FIRSTFUSEMACHINE", ["avocadorilla rarity"] = "MYTHIC",
    ["avocadorilla source"] = "FIRSTFUSEMACHINE", ["backrooms add"] = "MAY", ["backrooms added"] = "MAY", ["backrooms event add"] = "MAY", ["backrooms event added"] = "MAY", ["bacuru and egguru come from"] = "OGFUSE",
    ["bacuru and egguru rarity"] = "SECRET", ["bacuru and egguru source"] = "OGFUSE", ["ballerina cappuccina come from"] = "REDCARPET", ["ballerina cappuccina rarity"] = "LEGENDARY",
    ["ballerina cappuccina source"] = "REDCARPET", ["ballerina peppermintina rarity"] = "BRAINROTGOD", ["ballerino lololo come from"] = "REDCARPET", ["ballerino lololo rarity"] = "BRAINROTGOD",
    ["ballerino lololo source"] = "REDCARPET", ["bambini crostini come from"] = "REDCARPET", ["bambini crostini rarity"] = "EPIC", ["bambini crostini source"] = "REDCARPET", ["bambu bambu sahur come from"] = "INDONESIA",
    ["bambu bambu sahur rarity"] = "BRAINROTGOD", ["bambu bambu sahur source"] = "INDONESIA", ["bananita dolphinita come from"] = "REDCARPET", ["bananita dolphinita rarity"] = "EPIC",
    ["bananita dolphinita source"] = "REDCARPET", ["bananito add"] = "APRIL", ["bananito added"] = "APRIL", ["bananito bandito rarity"] = "MYTHIC", ["bananito come from"] = "REDCARPET",
    ["bananito rarity"] = "SECRET", ["bananito source"] = "REDCARPET", ["bandito axolito come from"] = "CYBERCRAFT", ["bandito axolito rarity"] = "LEGENDARY", ["bandito axolito source"] = "CYBERCRAFT",
    ["bandito bobritto come from"] = "REDCARPET", ["bandito bobritto rarity"] = "RARE", ["bandito bobritto source"] = "REDCARPET", ["base lock"] = "60", ["base lock time"] = "60", ["baskito rarity"] = "SECRET",
    ["bearito cabinito rarity"] = "SECRET", ["bee loco come from"] = "CYBERCRAFT", ["bee loco rarity"] = "MYTHIC", ["bee loco source"] = "CYBERCRAFT", ["belula beluga come from"] = "BRAINROTTRADER",
    ["belula beluga rarity"] = "BRAINROTGOD", ["belula beluga source"] = "BRAINROTTRADER", ["berenjello angello come from"] = "DIVINEFUSE", ["berenjello angello rarity"] = "MYTHIC",
    ["berenjello angello source"] = "DIVINEFUSE", ["berryno add"] = "APRIL", ["berryno added"] = "APRIL", ["berryno come from"] = "REDCARPET", ["berryno rarity"] = "SECRET", ["berryno source"] = "REDCARPET",
    ["best admin abuse brainrot"] = "4THBROS", ["best advent calendar brainrot"] = "25", ["best aura boat brainrot"] = "HOREGINIBOOM", ["best backrooms brainrot"] = "RUBRIKIKO", ["best backrooms event brainrot"] = "RUBRIKIKO",
    ["best bombardiro brainrot"] = "LOSCROCODILLITOS", ["best bombardiro event brainrot"] = "LOSCROCODILLITOS", ["best brainrot admin abuse"] = "4THBROS", ["best brainrot advent calendar"] = "25",
    ["best brainrot aura boat"] = "HOREGINIBOOM", ["best brainrot backrooms"] = "RUBRIKIKO", ["best brainrot backrooms event"] = "RUBRIKIKO", ["best brainrot bombardiro"] = "LOSCROCODILLITOS",
    ["best brainrot bombardiro event"] = "LOSCROCODILLITOS", ["best brainrot brainrot trader"] = "FRAGRAMAANDCHOCRAMA", ["best brainrot cave ritual"] = "GUEST666", ["best brainrot chicleteira ritual"] = "LOSCHICLETEIRAS",
    ["best brainrot christmas"] = "DONKEYTURBOEXPRESS", ["best brainrot christmas event"] = "DONKEYTURBOEXPRESS", ["best brainrot christmas wheel spin"] = "LAJOLLYGRANDE", ["best brainrot cupids machine"] = "LOVELOVEBEAR",
    ["best brainrot cyber craft"] = "DIGINARWHAL", ["best brainrot divine fuse"] = "GRIFFIN", ["best brainrot dlc code"] = "ARCADRAGON", ["best brainrot dlc codes"] = "GRABATRON", ["best brainrot dul dul ritual"] = "NOOMYEXAMEN",
    ["best brainrot easter"] = "NOOMYEGGS", ["best brainrot easter event"] = "NOOMYEGGS", ["best brainrot egg town"] = "QUACKINISNACKINI", ["best brainrot egg town event"] = "QUACKINISNACKINI",
    ["best brainrot eid"] = "FOXINILANTERNINI", ["best brainrot eid event"] = "FOXINILANTERNINI", ["best brainrot extinct"] = "LAEXTINCTGRANDE", ["best brainrot extinct event"] = "LAEXTINCTGRANDE",
    ["best brainrot first craft machine"] = "SIGNORECARAPACE", ["best brainrot first fuse machine"] = "LASUPREMECOMBINASION", ["best brainrot fishing"] = "FISHINOCLOWNINO", ["best brainrot fishing event"] = "FISHINOCLOWNINO",
    ["best brainrot from admin abuse"] = "4THBROS", ["best brainrot from advent calendar"] = "25", ["best brainrot from aura boat"] = "HOREGINIBOOM", ["best brainrot from backrooms"] = "RUBRIKIKO",
    ["best brainrot from backrooms event"] = "RUBRIKIKO", ["best brainrot from bombardiro"] = "LOSCROCODILLITOS", ["best brainrot from bombardiro event"] = "LOSCROCODILLITOS", ["best brainrot from brainrot trader"] = "FRAGRAMAANDCHOCRAMA",
    ["best brainrot from cave ritual"] = "GUEST666", ["best brainrot from chicleteira ritual"] = "LOSCHICLETEIRAS", ["best brainrot from christmas"] = "DONKEYTURBOEXPRESS", ["best brainrot from christmas event"] = "DONKEYTURBOEXPRESS",
    ["best brainrot from christmas wheel spin"] = "LAJOLLYGRANDE", ["best brainrot from cupids machine"] = "LOVELOVEBEAR", ["best brainrot from cyber craft"] = "DIGINARWHAL", ["best brainrot from divine fuse"] = "GRIFFIN",
    ["best brainrot from dlc code"] = "ARCADRAGON", ["best brainrot from dlc codes"] = "GRABATRON", ["best brainrot from dul dul ritual"] = "NOOMYEXAMEN", ["best brainrot from easter"] = "NOOMYEGGS",
    ["best brainrot from easter event"] = "NOOMYEGGS", ["best brainrot from egg town"] = "QUACKINISNACKINI", ["best brainrot from egg town event"] = "QUACKINISNACKINI", ["best brainrot from eid"] = "FOXINILANTERNINI",
    ["best brainrot from eid event"] = "FOXINILANTERNINI", ["best brainrot from extinct"] = "LAEXTINCTGRANDE", ["best brainrot from extinct event"] = "LAEXTINCTGRANDE", ["best brainrot from first craft machine"] = "SIGNORECARAPACE",
    ["best brainrot from first fuse machine"] = "LASUPREMECOMBINASION", ["best brainrot from fishing"] = "FISHINOCLOWNINO", ["best brainrot from fishing event"] = "FISHINOCLOWNINO",
    ["best brainrot from grannys funeral"] = "GRANNY", ["best brainrot from grannys funeral event"] = "GRANNY", ["best brainrot from halloween"] = "DRAGONSKELETONINI", ["best brainrot from halloween event"] = "DRAGONSKELETONINI",
    ["best brainrot from indonesia"] = "KRUPUKPAGIPAGI", ["best brainrot from indonesia event"] = "KRUPUKPAGIPAGI", ["best brainrot from job ritual"] = "NOOMYRESUME", ["best brainrot from karker ritual"] = "LOSKARKERITOS",
    ["best brainrot from la vacca ritual"] = "LASVAQUITASSATURNITAS", ["best brainrot from limited quantity craft"] = "CAPITANOAMERICANO", ["best brainrot from los traders"] = "MOBYBROS",
    ["best brainrot from lucky catch"] = "DRAGONSKELETONINI", ["best brainrot from matteo ritual"] = "LOSMATTEOS", ["best brainrot from mi gatito ritual"] = "LOSMIGATITOS", ["best brainrot from new years"] = "TUFFTOUCAN",
    ["best brainrot from new years event"] = "TUFFTOUCAN", ["best brainrot from og fuse"] = "HYDRADRAGONCANNELLONI", ["best brainrot from pinata"] = "LOSMARIACHIS", ["best brainrot from pole game"] = "RANGRINGBUS",
    ["best brainrot from red carpet"] = "STRAWBERRYELEPHANT", ["best brainrot from sabs anniversary"] = "JELLYMOBY", ["best brainrot from sabs anniversary event"] = "JELLYMOBY", ["best brainrot from sammys code"] = "FRULLATOFRAMINGO",
    ["best brainrot from santas fuse"] = "DRAGONGINGERINI", ["best brainrot from santas market"] = "GINGERGERAT", ["best brainrot from soccer board"] = "ESOKGOALA", ["best brainrot from spain"] = "CHICLETEIRACHAMPEONA",
    ["best brainrot from spain event"] = "CHICLETEIRACHAMPEONA", ["best brainrot from spyderini ritual"] = "LOSSPYDERINIS", ["best brainrot from st patricks"] = "CLOVERATCLAPAT", ["best brainrot from st patricks event"] = "CLOVERATCLAPAT",
    ["best brainrot from summer fuse"] = "DRAGONAQUANINI", ["best brainrot from summer hour"] = "CHICLETEIRASURFEITEIRA", ["best brainrot from taco"] = "TACORITABICICLETA", ["best brainrot from taco event"] = "TACORITABICICLETA",
    ["best brainrot from thanksgiving"] = "GOBBLINOUNICICLINO", ["best brainrot from thanksgiving event"] = "GOBBLINOUNICICLINO", ["best brainrot from trick or treat"] = "NOOMYCANDY",
    ["best brainrot from tsunami ltm"] = "ARCADOPUS", ["best brainrot from witchs fuse"] = "HEADLESSHORSEMAN", ["best brainrot god"] = "PRETZOROBO", ["best brainrot god brainrot"] = "PRETZOROBO",
    ["best brainrot grannys funeral"] = "GRANNY", ["best brainrot grannys funeral event"] = "GRANNY", ["best brainrot halloween"] = "DRAGONSKELETONINI", ["best brainrot halloween event"] = "DRAGONSKELETONINI",
    ["best brainrot indonesia"] = "KRUPUKPAGIPAGI", ["best brainrot indonesia event"] = "KRUPUKPAGIPAGI", ["best brainrot job ritual"] = "NOOMYRESUME", ["best brainrot karker ritual"] = "LOSKARKERITOS",
    ["best brainrot la vacca ritual"] = "LASVAQUITASSATURNITAS", ["best brainrot limited quantity craft"] = "CAPITANOAMERICANO", ["best brainrot los traders"] = "MOBYBROS", ["best brainrot lucky catch"] = "DRAGONSKELETONINI",
    ["best brainrot matteo ritual"] = "LOSMATTEOS", ["best brainrot mi gatito ritual"] = "LOSMIGATITOS", ["best brainrot new years"] = "TUFFTOUCAN", ["best brainrot new years event"] = "TUFFTOUCAN",
    ["best brainrot og fuse"] = "HYDRADRAGONCANNELLONI", ["best brainrot out admin abuse"] = "4THBROS", ["best brainrot out advent calendar"] = "25", ["best brainrot out aura boat"] = "HOREGINIBOOM",
    ["best brainrot out backrooms"] = "RUBRIKIKO", ["best brainrot out backrooms event"] = "RUBRIKIKO", ["best brainrot out bombardiro"] = "LOSCROCODILLITOS", ["best brainrot out bombardiro event"] = "LOSCROCODILLITOS",
    ["best brainrot out brainrot trader"] = "FRAGRAMAANDCHOCRAMA", ["best brainrot out cave ritual"] = "GUEST666", ["best brainrot out chicleteira ritual"] = "LOSCHICLETEIRAS", ["best brainrot out christmas"] = "DONKEYTURBOEXPRESS",
    ["best brainrot out christmas event"] = "DONKEYTURBOEXPRESS", ["best brainrot out christmas wheel spin"] = "LAJOLLYGRANDE", ["best brainrot out cupids machine"] = "LOVELOVEBEAR",
    ["best brainrot out cyber craft"] = "DIGINARWHAL", ["best brainrot out divine fuse"] = "GRIFFIN", ["best brainrot out dlc code"] = "ARCADRAGON", ["best brainrot out dlc codes"] = "GRABATRON",
    ["best brainrot out dul dul ritual"] = "NOOMYEXAMEN", ["best brainrot out easter"] = "NOOMYEGGS", ["best brainrot out easter event"] = "NOOMYEGGS", ["best brainrot out egg town"] = "QUACKINISNACKINI",
    ["best brainrot out egg town event"] = "QUACKINISNACKINI", ["best brainrot out eid"] = "FOXINILANTERNINI", ["best brainrot out eid event"] = "FOXINILANTERNINI", ["best brainrot out extinct"] = "LAEXTINCTGRANDE",
    ["best brainrot out extinct event"] = "LAEXTINCTGRANDE", ["best brainrot out first craft machine"] = "SIGNORECARAPACE", ["best brainrot out first fuse machine"] = "LASUPREMECOMBINASION",
    ["best brainrot out fishing"] = "FISHINOCLOWNINO", ["best brainrot out fishing event"] = "FISHINOCLOWNINO", ["best brainrot out grannys funeral"] = "GRANNY", ["best brainrot out grannys funeral event"] = "GRANNY",
    ["best brainrot out halloween"] = "DRAGONSKELETONINI", ["best brainrot out halloween event"] = "DRAGONSKELETONINI", ["best brainrot out indonesia"] = "KRUPUKPAGIPAGI", ["best brainrot out indonesia event"] = "KRUPUKPAGIPAGI",
    ["best brainrot out job ritual"] = "NOOMYRESUME", ["best brainrot out karker ritual"] = "LOSKARKERITOS", ["best brainrot out la vacca ritual"] = "LASVAQUITASSATURNITAS", ["best brainrot out limited quantity craft"] = "CAPITANOAMERICANO",
    ["best brainrot out los traders"] = "MOBYBROS", ["best brainrot out lucky catch"] = "DRAGONSKELETONINI", ["best brainrot out matteo ritual"] = "LOSMATTEOS", ["best brainrot out mi gatito ritual"] = "LOSMIGATITOS",
    ["best brainrot out new years"] = "TUFFTOUCAN", ["best brainrot out new years event"] = "TUFFTOUCAN", ["best brainrot out og fuse"] = "HYDRADRAGONCANNELLONI", ["best brainrot out pinata"] = "LOSMARIACHIS",
    ["best brainrot out pole game"] = "RANGRINGBUS", ["best brainrot out red carpet"] = "STRAWBERRYELEPHANT", ["best brainrot out sabs anniversary"] = "JELLYMOBY", ["best brainrot out sabs anniversary event"] = "JELLYMOBY",
    ["best brainrot out sammys code"] = "FRULLATOFRAMINGO", ["best brainrot out santas fuse"] = "DRAGONGINGERINI", ["best brainrot out santas market"] = "GINGERGERAT", ["best brainrot out soccer board"] = "ESOKGOALA",
    ["best brainrot out spain"] = "CHICLETEIRACHAMPEONA", ["best brainrot out spain event"] = "CHICLETEIRACHAMPEONA", ["best brainrot out spyderini ritual"] = "LOSSPYDERINIS", ["best brainrot out st patricks"] = "CLOVERATCLAPAT",
    ["best brainrot out st patricks event"] = "CLOVERATCLAPAT", ["best brainrot out summer fuse"] = "DRAGONAQUANINI", ["best brainrot out summer hour"] = "CHICLETEIRASURFEITEIRA", ["best brainrot out taco"] = "TACORITABICICLETA",
    ["best brainrot out taco event"] = "TACORITABICICLETA", ["best brainrot out thanksgiving"] = "GOBBLINOUNICICLINO", ["best brainrot out thanksgiving event"] = "GOBBLINOUNICICLINO",
    ["best brainrot out trick or treat"] = "NOOMYCANDY", ["best brainrot out tsunami ltm"] = "ARCADOPUS", ["best brainrot out witchs fuse"] = "HEADLESSHORSEMAN", ["best brainrot pinata"] = "LOSMARIACHIS",
    ["best brainrot pole game"] = "RANGRINGBUS", ["best brainrot red carpet"] = "STRAWBERRYELEPHANT", ["best brainrot sabs anniversary"] = "JELLYMOBY", ["best brainrot sabs anniversary event"] = "JELLYMOBY",
    ["best brainrot sammys code"] = "FRULLATOFRAMINGO", ["best brainrot santas fuse"] = "DRAGONGINGERINI", ["best brainrot santas market"] = "GINGERGERAT", ["best brainrot soccer board"] = "ESOKGOALA",
    ["best brainrot spain"] = "CHICLETEIRACHAMPEONA", ["best brainrot spain event"] = "CHICLETEIRACHAMPEONA", ["best brainrot spyderini ritual"] = "LOSSPYDERINIS", ["best brainrot st patricks"] = "CLOVERATCLAPAT",
    ["best brainrot st patricks event"] = "CLOVERATCLAPAT", ["best brainrot summer fuse"] = "DRAGONAQUANINI", ["best brainrot summer hour"] = "CHICLETEIRASURFEITEIRA", ["best brainrot taco"] = "TACORITABICICLETA",
    ["best brainrot taco event"] = "TACORITABICICLETA", ["best brainrot thanksgiving"] = "GOBBLINOUNICICLINO", ["best brainrot thanksgiving event"] = "GOBBLINOUNICICLINO", ["best brainrot trader brainrot"] = "FRAGRAMAANDCHOCRAMA",
    ["best brainrot trick or treat"] = "NOOMYCANDY", ["best brainrot tsunami ltm"] = "ARCADOPUS", ["best brainrot witchs fuse"] = "HEADLESSHORSEMAN", ["best cave ritual brainrot"] = "GUEST666",
    ["best chicleteira ritual brainrot"] = "LOSCHICLETEIRAS", ["best christmas brainrot"] = "DONKEYTURBOEXPRESS", ["best christmas event brainrot"] = "DONKEYTURBOEXPRESS", ["best christmas wheel spin brainrot"] = "LAJOLLYGRANDE",
    ["best cupids machine brainrot"] = "LOVELOVEBEAR", ["best cyber craft brainrot"] = "DIGINARWHAL", ["best divine fuse brainrot"] = "GRIFFIN", ["best dlc code brainrot"] = "ARCADRAGON",
    ["best dlc codes brainrot"] = "GRABATRON", ["best dul dul ritual brainrot"] = "NOOMYEXAMEN", ["best easter brainrot"] = "NOOMYEGGS", ["best easter event brainrot"] = "NOOMYEGGS",
    ["best egg town brainrot"] = "QUACKINISNACKINI", ["best egg town event brainrot"] = "QUACKINISNACKINI", ["best eid brainrot"] = "FOXINILANTERNINI", ["best eid event brainrot"] = "FOXINILANTERNINI",
    ["best extinct brainrot"] = "LAEXTINCTGRANDE", ["best extinct event brainrot"] = "LAEXTINCTGRANDE", ["best first craft machine brainrot"] = "SIGNORECARAPACE", ["best first fuse machine brainrot"] = "LASUPREMECOMBINASION",
    ["best fishing brainrot"] = "FISHINOCLOWNINO", ["best fishing event brainrot"] = "FISHINOCLOWNINO", ["best from admin abuse"] = "4THBROS", ["best from advent calendar"] = "25", ["best from aura boat"] = "HOREGINIBOOM",
    ["best from backrooms"] = "RUBRIKIKO", ["best from backrooms event"] = "RUBRIKIKO", ["best from bombardiro"] = "LOSCROCODILLITOS", ["best from bombardiro event"] = "LOSCROCODILLITOS",
    ["best from brainrot trader"] = "FRAGRAMAANDCHOCRAMA", ["best from cave ritual"] = "GUEST666", ["best from chicleteira ritual"] = "LOSCHICLETEIRAS", ["best from christmas"] = "DONKEYTURBOEXPRESS",
    ["best from christmas event"] = "DONKEYTURBOEXPRESS", ["best from christmas wheel spin"] = "LAJOLLYGRANDE", ["best from cupids machine"] = "LOVELOVEBEAR", ["best from cyber craft"] = "DIGINARWHAL",
    ["best from divine fuse"] = "GRIFFIN", ["best from dlc code"] = "ARCADRAGON", ["best from dlc codes"] = "GRABATRON", ["best from dul dul ritual"] = "NOOMYEXAMEN", ["best from easter"] = "NOOMYEGGS",
    ["best from easter event"] = "NOOMYEGGS", ["best from egg town"] = "QUACKINISNACKINI", ["best from egg town event"] = "QUACKINISNACKINI", ["best from eid"] = "FOXINILANTERNINI",
    ["best from eid event"] = "FOXINILANTERNINI", ["best from extinct"] = "LAEXTINCTGRANDE", ["best from extinct event"] = "LAEXTINCTGRANDE", ["best from first craft machine"] = "SIGNORECARAPACE",
    ["best from first fuse machine"] = "LASUPREMECOMBINASION", ["best from fishing"] = "FISHINOCLOWNINO", ["best from fishing event"] = "FISHINOCLOWNINO", ["best from grannys funeral"] = "GRANNY",
    ["best from grannys funeral event"] = "GRANNY", ["best from halloween"] = "DRAGONSKELETONINI", ["best from halloween event"] = "DRAGONSKELETONINI", ["best from indonesia"] = "KRUPUKPAGIPAGI",
    ["best from indonesia event"] = "KRUPUKPAGIPAGI", ["best from job ritual"] = "NOOMYRESUME", ["best from karker ritual"] = "LOSKARKERITOS", ["best from la vacca ritual"] = "LASVAQUITASSATURNITAS",
    ["best from limited quantity craft"] = "CAPITANOAMERICANO", ["best from los traders"] = "MOBYBROS", ["best from matteo ritual"] = "LOSMATTEOS", ["best from mi gatito ritual"] = "LOSMIGATITOS",
    ["best from new years"] = "TUFFTOUCAN", ["best from new years event"] = "TUFFTOUCAN", ["best from og fuse"] = "HYDRADRAGONCANNELLONI", ["best from pinata"] = "LOSMARIACHIS", ["best from pole game"] = "RANGRINGBUS",
    ["best from red carpet"] = "STRAWBERRYELEPHANT", ["best from sabs anniversary"] = "JELLYMOBY", ["best from sabs anniversary event"] = "JELLYMOBY", ["best from sammys code"] = "FRULLATOFRAMINGO",
    ["best from santas fuse"] = "DRAGONGINGERINI", ["best from santas market"] = "GINGERGERAT", ["best from soccer board"] = "ESOKGOALA", ["best from spain"] = "CHICLETEIRACHAMPEONA",
    ["best from spain event"] = "CHICLETEIRACHAMPEONA", ["best from spyderini ritual"] = "LOSSPYDERINIS", ["best from st patricks"] = "CLOVERATCLAPAT", ["best from st patricks event"] = "CLOVERATCLAPAT",
    ["best from summer fuse"] = "DRAGONAQUANINI", ["best from summer hour"] = "CHICLETEIRASURFEITEIRA", ["best from taco"] = "TACORITABICICLETA", ["best from taco event"] = "TACORITABICICLETA",
    ["best from thanksgiving"] = "GOBBLINOUNICICLINO", ["best from thanksgiving event"] = "GOBBLINOUNICICLINO", ["best from trick or treat"] = "NOOMYCANDY", ["best from tsunami ltm"] = "ARCADOPUS",
    ["best from witchs fuse"] = "HEADLESSHORSEMAN", ["best grannys funeral brainrot"] = "GRANNY", ["best grannys funeral event brainrot"] = "GRANNY", ["best halloween brainrot"] = "DRAGONSKELETONINI",
    ["best halloween event brainrot"] = "DRAGONSKELETONINI", ["best indonesia brainrot"] = "KRUPUKPAGIPAGI", ["best indonesia event brainrot"] = "KRUPUKPAGIPAGI", ["best job ritual brainrot"] = "NOOMYRESUME",
    ["best karker ritual brainrot"] = "LOSKARKERITOS", ["best la vacca ritual brainrot"] = "LASVAQUITASSATURNITAS", ["best limited quantity craft brainrot"] = "CAPITANOAMERICANO", ["best los traders brainrot"] = "MOBYBROS",
    ["best lucky catch brainrot"] = "DRAGONSKELETONINI", ["best matteo ritual brainrot"] = "LOSMATTEOS", ["best mi gatito ritual brainrot"] = "LOSMIGATITOS", ["best new brainrot"] = "ARCABROS",
    ["best new years brainrot"] = "TUFFTOUCAN", ["best new years event brainrot"] = "TUFFTOUCAN", ["best newest brainrot"] = "ARCABROS", ["best og"] = "HEADLESSHORSEMAN", ["best og fuse brainrot"] = "HYDRADRAGONCANNELLONI",
    ["best out admin abuse"] = "4THBROS", ["best out advent calendar"] = "25", ["best out aura boat"] = "HOREGINIBOOM", ["best out backrooms"] = "RUBRIKIKO", ["best out backrooms event"] = "RUBRIKIKO",
    ["best out bombardiro"] = "LOSCROCODILLITOS", ["best out bombardiro event"] = "LOSCROCODILLITOS", ["best out brainrot trader"] = "FRAGRAMAANDCHOCRAMA", ["best out cave ritual"] = "GUEST666",
    ["best out chicleteira ritual"] = "LOSCHICLETEIRAS", ["best out christmas"] = "DONKEYTURBOEXPRESS", ["best out christmas event"] = "DONKEYTURBOEXPRESS", ["best out christmas wheel spin"] = "LAJOLLYGRANDE",
    ["best out cupids machine"] = "LOVELOVEBEAR", ["best out cyber craft"] = "DIGINARWHAL", ["best out divine fuse"] = "GRIFFIN", ["best out dlc code"] = "ARCADRAGON", ["best out dlc codes"] = "GRABATRON",
    ["best out dul dul ritual"] = "NOOMYEXAMEN", ["best out easter"] = "NOOMYEGGS", ["best out easter event"] = "NOOMYEGGS", ["best out egg town"] = "QUACKINISNACKINI", ["best out egg town event"] = "QUACKINISNACKINI",
    ["best out eid"] = "FOXINILANTERNINI", ["best out eid event"] = "FOXINILANTERNINI", ["best out extinct"] = "LAEXTINCTGRANDE", ["best out extinct event"] = "LAEXTINCTGRANDE", ["best out first craft machine"] = "SIGNORECARAPACE",
    ["best out first fuse machine"] = "LASUPREMECOMBINASION", ["best out fishing"] = "FISHINOCLOWNINO", ["best out fishing event"] = "FISHINOCLOWNINO", ["best out grannys funeral"] = "GRANNY",
    ["best out grannys funeral event"] = "GRANNY", ["best out halloween"] = "DRAGONSKELETONINI", ["best out halloween event"] = "DRAGONSKELETONINI", ["best out indonesia"] = "KRUPUKPAGIPAGI",
    ["best out indonesia event"] = "KRUPUKPAGIPAGI", ["best out job ritual"] = "NOOMYRESUME", ["best out karker ritual"] = "LOSKARKERITOS", ["best out la vacca ritual"] = "LASVAQUITASSATURNITAS",
    ["best out limited quantity craft"] = "CAPITANOAMERICANO", ["best out los traders"] = "MOBYBROS", ["best out matteo ritual"] = "LOSMATTEOS", ["best out mi gatito ritual"] = "LOSMIGATITOS",
    ["best out new years"] = "TUFFTOUCAN", ["best out new years event"] = "TUFFTOUCAN", ["best out og fuse"] = "HYDRADRAGONCANNELLONI", ["best out pinata"] = "LOSMARIACHIS", ["best out pole game"] = "RANGRINGBUS",
    ["best out red carpet"] = "STRAWBERRYELEPHANT", ["best out sabs anniversary"] = "JELLYMOBY", ["best out sabs anniversary event"] = "JELLYMOBY", ["best out sammys code"] = "FRULLATOFRAMINGO",
    ["best out santas fuse"] = "DRAGONGINGERINI", ["best out santas market"] = "GINGERGERAT", ["best out soccer board"] = "ESOKGOALA", ["best out spain"] = "CHICLETEIRACHAMPEONA", ["best out spain event"] = "CHICLETEIRACHAMPEONA",
    ["best out spyderini ritual"] = "LOSSPYDERINIS", ["best out st patricks"] = "CLOVERATCLAPAT", ["best out st patricks event"] = "CLOVERATCLAPAT", ["best out summer fuse"] = "DRAGONAQUANINI",
    ["best out summer hour"] = "CHICLETEIRASURFEITEIRA", ["best out taco"] = "TACORITABICICLETA", ["best out taco event"] = "TACORITABICICLETA", ["best out thanksgiving"] = "GOBBLINOUNICICLINO",
    ["best out thanksgiving event"] = "GOBBLINOUNICICLINO", ["best out trick or treat"] = "NOOMYCANDY", ["best out tsunami ltm"] = "ARCADOPUS", ["best out witchs fuse"] = "HEADLESSHORSEMAN",
    ["best pinata brainrot"] = "LOSMARIACHIS", ["best pole game brainrot"] = "RANGRINGBUS", ["best red carpet brainrot"] = "STRAWBERRYELEPHANT", ["best rod"] = "RADIOACTIVEROD", ["best sabs anniversary brainrot"] = "JELLYMOBY",
    ["best sabs anniversary event brainrot"] = "JELLYMOBY", ["best sammys code brainrot"] = "FRULLATOFRAMINGO", ["best santas fuse brainrot"] = "DRAGONGINGERINI", ["best santas market brainrot"] = "GINGERGERAT",
    ["best secret"] = "GRIFFIN", ["best soccer board brainrot"] = "ESOKGOALA", ["best spain brainrot"] = "CHICLETEIRACHAMPEONA", ["best spain event brainrot"] = "CHICLETEIRACHAMPEONA",
    ["best spyderini ritual brainrot"] = "LOSSPYDERINIS", ["best st patricks brainrot"] = "CLOVERATCLAPAT", ["best st patricks event brainrot"] = "CLOVERATCLAPAT", ["best summer fuse brainrot"] = "DRAGONAQUANINI",
    ["best summer hour brainrot"] = "CHICLETEIRASURFEITEIRA", ["best taco brainrot"] = "TACORITABICICLETA", ["best taco event brainrot"] = "TACORITABICICLETA", ["best thanksgiving brainrot"] = "GOBBLINOUNICICLINO",
    ["best thanksgiving event brainrot"] = "GOBBLINOUNICICLINO", ["best trick or treat brainrot"] = "NOOMYCANDY", ["best tsunami ltm brainrot"] = "ARCADOPUS", ["best witchs fuse brainrot"] = "HEADLESSHORSEMAN",
    ["birthday year"] = "2002", ["bisonte giuppitere come from"] = "THISISOBTAINEDFROMSAMMYSBASE", ["bisonte giuppitere rarity"] = "SECRET", ["bisonte giuppitere source"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["blackhole goat rarity"] = "SECRET", ["bloodmoon add"] = "JUNE", ["bloodmoon added"] = "JUNE", ["bloodmoon event add"] = "JUNE", ["bloodmoon event added"] = "JUNE", ["bloodrot add"] = "JUNE",
    ["bloodrot added"] = "JUNE", ["blueberrinni octopusini come from"] = "REDCARPET", ["blueberrinni octopusini rarity"] = "LEGENDARY", ["blueberrinni octopusini source"] = "REDCARPET",
    ["boatito auratito come from"] = "ADMINABUSE", ["boatito auratito rarity"] = "SECRET", ["boatito auratito source"] = "ADMINABUSE", ["boba panda come from"] = "OGFUSE", ["boba panda rarity"] = "BRAINROTGOD",
    ["boba panda source"] = "OGFUSE", ["bombardini tortinii come from"] = "TACO", ["bombardini tortinii rarity"] = "BRAINROTGOD", ["bombardini tortinii source"] = "TACO", ["bombardiro crocodilo come from"] = "REDCARPET",
    ["bombardiro crocodilo rarity"] = "MYTHIC", ["bombardiro crocodilo source"] = "REDCARPET", ["bombardiro vaccariro come from"] = "SUMMERFUSE", ["bombardiro vaccariro rarity"] = "SECRET",
    ["bombardiro vaccariro source"] = "SUMMERFUSE", ["bombombini gusini come from"] = "REDCARPET", ["bombombini gusini rarity"] = "MYTHIC", ["bombombini gusini source"] = "REDCARPET",
    ["boneca ambalabu come from"] = "REDCARPET", ["boneca ambalabu rarity"] = "RARE", ["boneca ambalabu source"] = "REDCARPET", ["boppin bunny come from"] = "DLCCODE", ["boppin bunny rarity"] = "SECRET",
    ["boppin bunny source"] = "DLCCODE", ["brainrot dealer add"] = "NOVEMBER", ["brainrot dealer added"] = "NOVEMBER", ["brainrot named after"] = "SAMMYNISPYDERINI", ["brainrot named after me"] = "SAMMYNISPYDERINI",
    ["brainrot trader add"] = "NOVEMBER", ["brainrot trader added"] = "NOVEMBER", ["brasilini berimbini come from"] = "ADMINABUSE", ["brasilini berimbini rarity"] = "BRAINROTGOD", ["brasilini berimbini source"] = "ADMINABUSE",
    ["brazil add"] = "AUGUST", ["brazil added"] = "AUGUST", ["brazil event add"] = "AUGUST", ["brazil event added"] = "AUGUST", ["brr brr patapim come from"] = "REDCARPET", ["brr brr patapim rarity"] = "EPIC",
    ["brr brr patapim source"] = "REDCARPET", ["brr es teh patipum come from"] = "FIRSTFUSEMACHINE", ["brr es teh patipum rarity"] = "BRAINROTGOD", ["brr es teh patipum source"] = "FIRSTFUSEMACHINE",
    ["brri brri bicus dicus bombicus come from"] = "REDCARPET", ["brri brri bicus dicus bombicus rarity"] = "EPIC", ["brri brri bicus dicus bombicus source"] = "REDCARPET", ["brunito marsito rarity"] = "SECRET",
    ["brutto gialutto come from"] = "FIRSTCRAFTMACHINE", ["brutto gialutto rarity"] = "MYTHIC", ["brutto gialutto source"] = "FIRSTCRAFTMACHINE", ["bubblegum trait add"] = "JULY", ["bubblegum trait added"] = "JULY",
    ["bucketoro come from"] = "SUMMERFUSE", ["bucketoro rarity"] = "MYTHIC", ["bucketoro source"] = "SUMMERFUSE", ["bufalino boomberino come from"] = "LIMITEDQUANTITYCRAFT", ["bufalino boomberino rarity"] = "SECRET",
    ["bufalino boomberino source"] = "LIMITEDQUANTITYCRAFT", ["buho de fuego come from"] = "WITCHSFUSE", ["buho de fuego rarity"] = "LEGENDARY", ["buho de fuego source"] = "WITCHSFUSE",
    ["buho de noelo come from"] = "SANTASFUSE", ["buho de noelo rarity"] = "BRAINROTGOD", ["buho de noelo source"] = "SANTASFUSE", ["buho de volto come from"] = "CYBERCRAFT", ["buho de volto rarity"] = "SECRET",
    ["buho de volto source"] = "CYBERCRAFT", ["buho del cielo come from"] = "DIVINEFUSE", ["buho del cielo rarity"] = "LEGENDARY", ["buho del cielo source"] = "DIVINEFUSE", ["bulbito bandito traktorito rarity"] = "BRAINROTGOD",
    ["bull trait add"] = "JULY", ["bull trait added"] = "JULY", ["bunito bunito spinito come from"] = "NEWYEARS", ["bunito bunito spinito rarity"] = "SECRET", ["bunito bunito spinito source"] = "NEWYEARS",
    ["bunny and eggy come from"] = "DIVINEFUSE", ["bunny and eggy rarity"] = "SECRET", ["bunny and eggy source"] = "DIVINEFUSE", ["bunny bunny bunny sahur come from"] = "EASTER", ["bunny bunny bunny sahur rarity"] = "SECRET",
    ["bunny bunny bunny sahur source"] = "EASTER", ["bunny tralala rarity"] = "BRAINROTGOD", ["bunnyman come from"] = "ADVENTCALENDAR", ["bunnyman rarity"] = "SECRET", ["bunnyman source"] = "ADVENTCALENDAR",
    ["buntteo come from"] = "EASTER", ["buntteo rarity"] = "SECRET", ["buntteo source"] = "EASTER", ["burbaloni loliloli come from"] = "REDCARPET", ["burbaloni loliloli rarity"] = "LEGENDARY",
    ["burbaloni loliloli source"] = "REDCARPET", ["burguro and fryuro rarity"] = "SECRET", ["burrito bandito rarity"] = "SECRET", ["cacasito satalito come from"] = "REDCARPET", ["cacasito satalito rarity"] = "BRAINROTGOD",
    ["cacasito satalito source"] = "REDCARPET", ["cachorrito melonito come from"] = "REDCARPET", ["cachorrito melonito rarity"] = "MYTHIC", ["cachorrito melonito source"] = "REDCARPET",
    ["cacto hipopotamo come from"] = "REDCARPET", ["cacto hipopotamo rarity"] = "RARE", ["cacto hipopotamo source"] = "REDCARPET", ["camera ramena come from"] = "CYBERCRAFT", ["camera ramena rarity"] = "SECRET",
    ["camera ramena source"] = "CYBERCRAFT", ["candy add"] = "JULY", ["candy added"] = "JULY", ["candy aurora add"] = "JULY", ["candy aurora added"] = "JULY", ["candy aurora event add"] = "JULY",
    ["candy aurora event added"] = "JULY", ["cangurato gelato come from"] = "REDCARPET", ["cangurato gelato rarity"] = "SECRET", ["cangurato gelato source"] = "REDCARPET", ["capi taco come from"] = "TACO",
    ["capi taco rarity"] = "BRAINROTGOD", ["capi taco source"] = "TACO", ["capitano americano come from"] = "LIMITEDQUANTITYCRAFT", ["capitano americano rarity"] = "SECRET", ["capitano americano source"] = "LIMITEDQUANTITYCRAFT",
    ["capitano gullini come from"] = "SUMMERFUSE", ["capitano gullini rarity"] = "SECRET", ["capitano gullini source"] = "SUMMERFUSE", ["capitano moby come from"] = "REDCARPET", ["capitano moby rarity"] = "SECRET",
    ["capitano moby source"] = "REDCARPET", ["cappuccino assassino come from"] = "REDCARPET", ["cappuccino assassino rarity"] = "EPIC", ["cappuccino assassino source"] = "REDCARPET",
    ["cappuccino clownino rarity"] = "BRAINROTGOD", ["caramello filtrello come from"] = "FIRSTCRAFTMACHINE", ["caramello filtrello rarity"] = "LEGENDARY", ["caramello filtrello source"] = "FIRSTCRAFTMACHINE",
    ["carloo rarity"] = "MYTHIC", ["carrotini brainini rarity"] = "MYTHIC", ["cash or card add"] = "APRIL", ["cash or card added"] = "APRIL", ["cash or card come from"] = "REDCARPET",
    ["cash or card rarity"] = "SECRET", ["cash or card source"] = "REDCARPET", ["cavallo virtuoso come from"] = "REDCARPET", ["cavallo virtuoso rarity"] = "MYTHIC", ["cavallo virtuoso source"] = "REDCARPET",
    ["caylusaurus add"] = "JUNE", ["caylusaurus added"] = "JUNE", ["caylusaurus come from"] = "LIMITEDQUANTITYCRAFT", ["caylusaurus rarity"] = "SECRET", ["caylusaurus source"] = "LIMITEDQUANTITYCRAFT",
    ["celestial pegasus rarity"] = "SECRET", ["celularcini viciosini come from"] = "FIRSTCRAFTMACHINE", ["celularcini viciosini rarity"] = "SECRET", ["celularcini viciosini source"] = "FIRSTCRAFTMACHINE",
    ["centrucci nuclucci come from"] = "BRAINROTTRADER", ["centrucci nuclucci rarity"] = "MYTHIC", ["centrucci nuclucci source"] = "BRAINROTTRADER", ["cerberus come from"] = "REDCARPET",
    ["cerberus rarity"] = "SECRET", ["cerberus source"] = "REDCARPET", ["chachechi come from"] = "ADMINABUSE", ["chachechi rarity"] = "SECRET", ["chachechi source"] = "ADMINABUSE", ["cheapest rod"] = "STARTERROD",
    ["chef crabracadabra come from"] = "REDCARPET", ["chef crabracadabra rarity"] = "LEGENDARY", ["chef crabracadabra source"] = "REDCARPET", ["chicleteira bicicleteira come from"] = "REDCARPET",
    ["chicleteira bicicleteira rarity"] = "SECRET", ["chicleteira bicicleteira source"] = "REDCARPET", ["chicleteira champeona add"] = "JULY", ["chicleteira champeona added"] = "JULY",
    ["chicleteira champeona come from"] = "SPAIN", ["chicleteira champeona rarity"] = "SECRET", ["chicleteira champeona source"] = "SPAIN", ["chicleteira cupideira rarity"] = "SECRET",
    ["chicleteira noelteira come from"] = "SANTASFUSE", ["chicleteira noelteira rarity"] = "SECRET", ["chicleteira noelteira source"] = "SANTASFUSE", ["chicleteira surfeiteira come from"] = "SUMMERHOUR",
    ["chicleteira surfeiteira rarity"] = "SECRET", ["chicleteira surfeiteira source"] = "SUMMERHOUR", ["chicleteirina bicicleteirina come from"] = "REDCARPET", ["chicleteirina bicicleteirina rarity"] = "SECRET",
    ["chicleteirina bicicleteirina source"] = "REDCARPET", ["chihuanini taconini rarity"] = "BRAINROTGOD", ["chill puppy come from"] = "OGFUSE", ["chill puppy rarity"] = "SECRET", ["chill puppy source"] = "OGFUSE",
    ["chillin chili come from"] = "LIMITEDQUANTITYCRAFT", ["chillin chili rarity"] = "SECRET", ["chillin chili source"] = "LIMITEDQUANTITYCRAFT", ["chimnino rarity"] = "SECRET", ["chimpanzini bananini come from"] = "REDCARPET",
    ["chimpanzini bananini rarity"] = "LEGENDARY", ["chimpanzini bananini source"] = "REDCARPET", ["chipso and queso come from"] = "LIMITEDQUANTITYCRAFT", ["chipso and queso rarity"] = "SECRET",
    ["chipso and queso source"] = "LIMITEDQUANTITYCRAFT", ["chocco bunny come from"] = "SANTASFUSE", ["chocco bunny rarity"] = "LEGENDARY", ["chocco bunny source"] = "SANTASFUSE", ["chrismasmamat rarity"] = "BRAINROTGOD",
    ["churrito bunnito rarity"] = "SECRET", ["cigno fulgoro come from"] = "DIVINEFUSE", ["cigno fulgoro rarity"] = "SECRET", ["cigno fulgoro source"] = "DIVINEFUSE", ["clickerino crabo come from"] = "BRAINROTTRADER",
    ["clickerino crabo rarity"] = "LEGENDARY", ["clickerino crabo source"] = "BRAINROTTRADER", ["cloverat clapat come from"] = "STPATRICKS", ["cloverat clapat rarity"] = "SECRET", ["cloverat clapat source"] = "STPATRICKS",
    ["clovkur kurkur rarity"] = "BRAINROTGOD", ["co founder"] = "LUKELUKENOOM", ["coco and mango come from"] = "SUMMERFUSE", ["coco and mango rarity"] = "SECRET", ["coco and mango source"] = "SUMMERFUSE",
    ["cocoa assassino come from"] = "CHRISTMAS", ["cocoa assassino rarity"] = "BRAINROTGOD", ["cocoa assassino source"] = "CHRISTMAS", ["cocofanto elefanto come from"] = "REDCARPET",
    ["cocofanto elefanto rarity"] = "BRAINROTGOD", ["cocofanto elefanto source"] = "REDCARPET", ["cocosini mama come from"] = "FIRSTFUSEMACHINE", ["cocosini mama rarity"] = "LEGENDARY",
    ["cocosini mama source"] = "FIRSTFUSEMACHINE", ["cocoteddy come from"] = "SUMMERFUSE", ["cocoteddy rarity"] = "MYTHIC", ["cocoteddy source"] = "SUMMERFUSE", ["cofounder"] = "LUKELUKENOOM",
    ["cola cat come from"] = "DLCCODE", ["cola cat rarity"] = "BRAINROTGOD", ["cola cat source"] = "DLCCODE", ["concert add"] = "JANUARY", ["concert added"] = "JANUARY", ["cooki and milki come from"] = "SANTASFUSE",
    ["cooki and milki rarity"] = "SECRET", ["cooki and milki source"] = "SANTASFUSE", ["corn corn corn sahur come from"] = "PINATA", ["corn corn corn sahur rarity"] = "BRAINROTGOD",
    ["corn corn corn sahur source"] = "PINATA", ["crab game year"] = "2022", ["crabbo limonetta rarity"] = "BRAINROTGOD", ["craburger rarity"] = "SECRET", ["craft machine add"] = "SEPTEMBER",
    ["craft machine added"] = "SEPTEMBER", ["crystal add"] = "JULY", ["crystal added"] = "JULY", ["crystal event add"] = "JULY", ["crystal event added"] = "JULY", ["crystal slap hammer base add"] = "JULY",
    ["crystal slap hammer base added"] = "JULY", ["cuadramat and pakrahmatmamat come from"] = "BRAINROTTRADER", ["cuadramat and pakrahmatmamat rarity"] = "SECRET", ["cuadramat and pakrahmatmamat source"] = "BRAINROTTRADER",
    ["cupcake koala come from"] = "BRAINROTTRADER", ["cupcake koala rarity"] = "RARE", ["cupcake koala source"] = "BRAINROTTRADER", ["cupid cupid sahur come from"] = "CUPIDSMACHINE",
    ["cupid cupid sahur rarity"] = "SECRET", ["cupid cupid sahur source"] = "CUPIDSMACHINE", ["cupid hotspot rarity"] = "SECRET", ["cupids machine add"] = "FEBRUARY", ["cupids machine added"] = "FEBRUARY",
    ["current update"] = "SPOOKYSCARYSKELETONS", ["current update number"] = "71", ["cursed add"] = "JANUARY", ["cursed added"] = "JANUARY", ["cyber add"] = "APRIL", ["cyber added"] = "APRIL",
    ["cyber admin machine add"] = "APRIL", ["cyber admin machine added"] = "APRIL", ["cyber craft machine add"] = "APRIL", ["cyber craft machine added"] = "APRIL", ["deprecated brainrot"] = "COCOCOSAHUR",
    ["diamond mutations add"] = "MAY", ["diamond mutations added"] = "MAY", ["digi narwhal come from"] = "CYBERCRAFT", ["digi narwhal rarity"] = "SECRET", ["digi narwhal source"] = "CYBERCRAFT",
    ["divine add"] = "FEBRUARY", ["divine added"] = "FEBRUARY", ["divine admin machine add"] = "FEBRUARY", ["divine admin machine added"] = "FEBRUARY", ["divine fuse add"] = "MARCH",
    ["divine fuse added"] = "MARCH", ["divino platypio come from"] = "DIVINEFUSE", ["divino platypio rarity"] = "BRAINROTGOD", ["divino platypio source"] = "DIVINEFUSE", ["dj panda come from"] = "REDCARPET",
    ["dj panda rarity"] = "SECRET", ["dj panda source"] = "REDCARPET", ["doi doi do come from"] = "BRAINROTTRADER", ["doi doi do rarity"] = "EPIC", ["doi doi do source"] = "BRAINROTTRADER",
    ["dolphini jetskini come from"] = "OGFUSE", ["dolphini jetskini rarity"] = "BRAINROTGOD", ["dolphini jetskini source"] = "OGFUSE", ["donkeyturbo express come from"] = "CHRISTMAS",
    ["donkeyturbo express rarity"] = "SECRET", ["donkeyturbo express source"] = "CHRISTMAS", ["dragon aquanini come from"] = "SUMMERFUSE", ["dragon aquanini rarity"] = "SECRET", ["dragon aquanini source"] = "SUMMERFUSE",
    ["dragon cannelloni come from"] = "REDCARPET", ["dragon cannelloni rarity"] = "SECRET", ["dragon cannelloni source"] = "REDCARPET", ["dragon gingerini come from"] = "SANTASFUSE",
    ["dragon gingerini rarity"] = "SECRET", ["dragon gingerini source"] = "SANTASFUSE", ["duels machine add"] = "JANUARY", ["duels machine added"] = "JANUARY", ["dug dug dug come from"] = "FIRSTCRAFTMACHINE",
    ["dug dug dug rarity"] = "SECRET", ["dug dug dug source"] = "FIRSTCRAFTMACHINE", ["duggy bros come from"] = "CYBERCRAFT", ["duggy bros rarity"] = "SECRET", ["duggy bros source"] = "CYBERCRAFT",
    ["dul dul dul come from"] = "ADMINABUSE", ["dul dul dul rarity"] = "SECRET", ["dul dul dul source"] = "ADMINABUSE", ["dumborino miracello come from"] = "DIVINEFUSE", ["dumborino miracello rarity"] = "BRAINROTGOD",
    ["dumborino miracello source"] = "DIVINEFUSE", ["easter easter easter sahur rarity"] = "SECRET", ["easter hour add"] = "MARCH", ["easter hour added"] = "MARCH", ["egg city add"] = "APRIL",
    ["egg city added"] = "APRIL", ["egg hunt add"] = "APRIL", ["egg hunt added"] = "APRIL", ["egg lucky block add"] = "APRIL", ["egg lucky block added"] = "APRIL", ["eggdin egg egg dun rarity"] = "BRAINROTGOD",
    ["eid celebration add"] = "MARCH", ["eid celebration added"] = "MARCH", ["eid eid eid sahur come from"] = "EID", ["eid eid eid sahur rarity"] = "SECRET", ["eid eid eid sahur source"] = "EID",
    ["electro quacko come from"] = "CYBERCRAFT", ["electro quacko rarity"] = "LEGENDARY", ["electro quacko source"] = "CYBERCRAFT", ["elefanto frigo come from"] = "FIRSTCRAFTMACHINE",
    ["elefanto frigo rarity"] = "SECRET", ["elefanto frigo source"] = "FIRSTCRAFTMACHINE", ["esok goala come from"] = "SOCCERBOARD", ["esok goala rarity"] = "SECRET", ["esok goala source"] = "SOCCERBOARD",
    ["esok sekolah rarity"] = "SECRET", ["espresso signora come from"] = "ADMINABUSE", ["espresso signora rarity"] = "BRAINROTGOD", ["espresso signora source"] = "ADMINABUSE", ["event exclusive brainrot"] = "CHICKENZOMBIE",
    ["eviledon come from"] = "WITCHSFUSE", ["eviledon rarity"] = "SECRET", ["eviledon source"] = "WITCHSFUSE", ["examen bros add"] = "JULY", ["examen bros added"] = "JULY", ["examen bros come from"] = "LOSTRADERS",
    ["examen bros rarity"] = "SECRET", ["examen bros source"] = "LOSTRADERS", ["extinct add"] = "SEPTEMBER", ["extinct added"] = "SEPTEMBER", ["extinct ballerina come from"] = "EXTINCT",
    ["extinct ballerina rarity"] = "BRAINROTGOD", ["extinct ballerina source"] = "EXTINCT", ["extinct machine"] = "LAEXTINCTGRANDE", ["extinct machine make"] = "LAEXTINCTGRANDE", ["extinct machine output"] = "LAEXTINCTGRANDE",
    ["extinct matteo come from"] = "EXTINCT", ["extinct matteo rarity"] = "SECRET", ["extinct matteo source"] = "EXTINCT", ["extinct tralalero come from"] = "EXTINCT", ["extinct tralalero rarity"] = "SECRET",
    ["extinct tralalero source"] = "EXTINCT", ["festive 67 come from"] = "DLCCODE", ["festive 67 rarity"] = "SECRET", ["festive 67 source"] = "DLCCODE", ["festive lucky block add"] = "DECEMBER",
    ["festive lucky block added"] = "DECEMBER", ["first game year"] = "2022", ["first trait"] = "BUBBLEGUM", ["fishboard come from"] = "REDCARPET", ["fishboard rarity"] = "SECRET", ["fishboard source"] = "REDCARPET",
    ["fishing add"] = "NOVEMBER", ["fishing added"] = "NOVEMBER", ["fishino clownino come from"] = "FISHING", ["fishino clownino rarity"] = "SECRET", ["fishino clownino source"] = "FISHING",
    ["fizzy soda come from"] = "OGFUSE", ["fizzy soda rarity"] = "MYTHIC", ["fizzy soda source"] = "OGFUSE", ["flancito come from"] = "SABSANNIVERSARY", ["flancito rarity"] = "SECRET",
    ["flancito source"] = "SABSANNIVERSARY", ["flipa sandala come from"] = "BACKROOMS", ["flipa sandala rarity"] = "SECRET", ["flipa sandala source"] = "BACKROOMS", ["flippo marino come from"] = "SUMMERFUSE",
    ["flippo marino rarity"] = "BRAINROTGOD", ["flippo marino source"] = "SUMMERFUSE", ["floors"] = "3", ["fluriflura come from"] = "REDCARPET", ["fluriflura rarity"] = "COMMON", ["fluriflura source"] = "REDCARPET",
    ["fortunu and cashuru rarity"] = "SECRET", ["foxini lanternini come from"] = "EID", ["foxini lanternini rarity"] = "SECRET", ["foxini lanternini source"] = "EID", ["fragola la la la come from"] = "FIRSTCRAFTMACHINE",
    ["fragola la la la rarity"] = "SECRET", ["fragola la la la source"] = "FIRSTCRAFTMACHINE", ["fragrama and chocrama come from"] = "BRAINROTTRADER", ["fragrama and chocrama rarity"] = "SECRET",
    ["fragrama and chocrama source"] = "BRAINROTTRADER", ["frankentteo come from"] = "HALLOWEEN", ["frankentteo rarity"] = "SECRET", ["frankentteo source"] = "HALLOWEEN", ["frigo camelo come from"] = "REDCARPET",
    ["frigo camelo rarity"] = "MYTHIC", ["frigo camelo source"] = "REDCARPET", ["frio ninja come from"] = "WITCHSFUSE", ["frio ninja rarity"] = "BRAINROTGOD", ["frio ninja source"] = "WITCHSFUSE",
    ["frogato pirato come from"] = "WITCHSFUSE", ["frogato pirato rarity"] = "EPIC", ["frogato pirato source"] = "WITCHSFUSE", ["frogo elfo come from"] = "SANTASFUSE", ["frogo elfo rarity"] = "RARE",
    ["frogo elfo source"] = "SANTASFUSE", ["frullato framingo come from"] = "SAMMYSCODE", ["frullato framingo rarity"] = "SECRET", ["frullato framingo source"] = "SAMMYSCODE", ["fuse add"] = "JANUARY",
    ["fuse added"] = "JANUARY", ["fuse machine add"] = "AUGUST", ["fuse machine added"] = "AUGUST", ["futbolini skatini come from"] = "CYBERCRAFT", ["futbolini skatini rarity"] = "SECRET",
    ["futbolini skatini source"] = "CYBERCRAFT", ["galaxy add"] = "AUGUST", ["galaxy added"] = "AUGUST", ["galaxy event add"] = "AUGUST", ["galaxy event added"] = "AUGUST", ["game inspired sab"] = "STEALACHARACTER",
    ["game lead developer"] = "BLADEBALL", ["game lead developer on"] = "BLADEBALL", ["game sab based on"] = "STEALACHARACTER", ["ganganzelli trulala come from"] = "FIRSTFUSEMACHINE",
    ["ganganzelli trulala rarity"] = "MYTHIC", ["ganganzelli trulala source"] = "FIRSTFUSEMACHINE", ["gangster footera come from"] = "REDCARPET", ["gangster footera rarity"] = "RARE",
    ["gangster footera source"] = "REDCARPET", ["garama and madundung come from"] = "REDCARPET", ["garama and madundung rarity"] = "SECRET", ["garama and madundung source"] = "REDCARPET",
    ["gato celesto come from"] = "DIVINEFUSE", ["gato celesto rarity"] = "EPIC", ["gato celesto source"] = "DIVINEFUSE", ["gattatino nyanino come from"] = "ADMINABUSE", ["gattatino nyanino rarity"] = "BRAINROTGOD",
    ["gattatino nyanino source"] = "ADMINABUSE", ["gattito tacoto rarity"] = "BRAINROTGOD", ["gelato lumacho come from"] = "SUMMERHOUR", ["gelato lumacho rarity"] = "SECRET", ["gelato lumacho source"] = "SUMMERHOUR",
    ["giftini spyderini rarity"] = "SECRET", ["ginger cisterna come from"] = "SANTASFUSE", ["ginger cisterna rarity"] = "BRAINROTGOD", ["ginger cisterna source"] = "SANTASFUSE", ["ginger gerat come from"] = "SANTASMARKET",
    ["ginger gerat rarity"] = "SECRET", ["ginger gerat source"] = "SANTASMARKET", ["ginger globo come from"] = "SANTASFUSE", ["ginger globo rarity"] = "BRAINROTGOD", ["ginger globo source"] = "SANTASFUSE",
    ["girafa celestre come from"] = "REDCARPET", ["girafa celestre rarity"] = "BRAINROTGOD", ["girafa celestre source"] = "REDCARPET", ["girafini raftini rarity"] = "SECRET", ["glaciator come from"] = "BACKROOMS",
    ["glaciator rarity"] = "SECRET", ["glaciator source"] = "BACKROOMS", ["globa steppa come from"] = "DLCCODE", ["globa steppa rarity"] = "SECRET", ["globa steppa source"] = "DLCCODE",
    ["glorbo fruttodrillo come from"] = "REDCARPET", ["glorbo fruttodrillo rarity"] = "LEGENDARY", ["glorbo fruttodrillo source"] = "REDCARPET", ["goat come from"] = "ADMINABUSE", ["goat rarity"] = "SECRET",
    ["goat source"] = "ADMINABUSE", ["gobblino uniciclino come from"] = "THANKSGIVING", ["gobblino uniciclino rarity"] = "SECRET", ["gobblino uniciclino source"] = "THANKSGIVING", ["gold add"] = "MAY",
    ["gold added"] = "MAY", ["gold elf rarity"] = "SECRET", ["gold gold gold rarity"] = "SECRET", ["gorillo subwoofero come from"] = "FIRSTCRAFTMACHINE", ["gorillo subwoofero rarity"] = "MYTHIC",
    ["gorillo subwoofero source"] = "FIRSTCRAFTMACHINE", ["gorillo watermelondrillo come from"] = "REDCARPET", ["gorillo watermelondrillo rarity"] = "MYTHIC", ["gorillo watermelondrillo source"] = "REDCARPET",
    ["grabatron come from"] = "DLCCODES", ["grabatron rarity"] = "SECRET", ["grabatron source"] = "DLCCODES", ["graipuss medussi come from"] = "REDCARPET", ["graipuss medussi rarity"] = "SECRET",
    ["graipuss medussi source"] = "REDCARPET", ["granchiello spiritell come from"] = "FISHING", ["granchiello spiritell rarity"] = "BRAINROTGOD", ["granchiello spiritell source"] = "FISHING",
    ["granny come from"] = "GRANNYSFUNERAL", ["granny rarity"] = "SECRET", ["granny source"] = "GRANNYSFUNERAL", ["grannys funeral add"] = "MARCH", ["grannys funeral added"] = "MARCH",
    ["griffin come from"] = "DIVINEFUSE", ["griffin rarity"] = "SECRET", ["griffin source"] = "DIVINEFUSE", ["group co founder"] = "LUKELUKENOOM", ["group created"] = "APRIL", ["guerriro digitale rarity"] = "SECRET",
    ["guest 666 add"] = "APRIL", ["guest 666 added"] = "APRIL", ["guest 666 come from"] = "CAVERITUAL", ["guest 666 rarity"] = "SECRET", ["guest 666 source"] = "CAVERITUAL", ["gym bros come from"] = "CYBERCRAFT",
    ["gym bros rarity"] = "SECRET", ["gym bros source"] = "CYBERCRAFT", ["halloween add"] = "OCTOBER", ["halloween added"] = "OCTOBER", ["harpuccino come from"] = "DIVINEFUSE", ["harpuccino rarity"] = "MYTHIC",
    ["harpuccino source"] = "DIVINEFUSE", ["haunted fuse add"] = "OCTOBER", ["haunted fuse added"] = "OCTOBER", ["headless horseman base skin add"] = "FEBRUARY", ["headless horseman base skin added"] = "FEBRUARY",
    ["headless horseman come from"] = "WITCHSFUSE", ["headless horseman rarity"] = "OG", ["headless horseman source"] = "WITCHSFUSE", ["heart lucky block add"] = "FEBRUARY", ["heart lucky block added"] = "FEBRUARY",
    ["highest luck"] = "35X", ["hippo golazo come from"] = "SOCCERBOARD", ["hippo golazo rarity"] = "SECRET", ["hippo golazo source"] = "SOCCERBOARD", ["ho ho ho sahur come from"] = "SANTASFUSE",
    ["ho ho ho sahur rarity"] = "SECRET", ["ho ho ho sahur source"] = "SANTASFUSE", ["holy arepa come from"] = "DIVINEFUSE", ["holy arepa rarity"] = "COMMON", ["holy arepa source"] = "DIVINEFUSE",
    ["hopilikalika hopilikalako rarity"] = "SECRET", ["horegini boom come from"] = "AURABOAT", ["horegini boom rarity"] = "SECRET", ["horegini boom source"] = "AURABOAT", ["how long base lock"] = "60",
    ["how many base skins"] = "26", ["how many bases"] = "19", ["how many floors"] = "3", ["how many mutation add"] = "11", ["how many mutations"] = "11", ["how many og brainrot"] = "4",
    ["how many ogs"] = "4", ["how many rebirths"] = "18", ["how many updates"] = "71", ["hydra bunny rarity"] = "SECRET", ["hydra dragon cannelloni come from"] = "OGFUSE", ["hydra dragon cannelloni rarity"] = "SECRET",
    ["hydra dragon cannelloni source"] = "OGFUSE", ["idea from"] = "STEALACHARACTER", ["index add"] = "DECEMBER", ["index added"] = "DECEMBER", ["indonesian add"] = "OCTOBER", ["indonesian added"] = "OCTOBER",
    ["indonesian event add"] = "OCTOBER", ["indonesian event added"] = "OCTOBER", ["inspired by"] = "STEALACHARACTER", ["jacko jack jack come from"] = "WITCHSFUSE", ["jacko jack jack rarity"] = "BRAINROTGOD",
    ["jacko jack jack source"] = "WITCHSFUSE", ["jacko spaventosa come from"] = "WITCHSFUSE", ["jacko spaventosa rarity"] = "MYTHIC", ["jacko spaventosa source"] = "WITCHSFUSE", ["jackorilla rarity"] = "SECRET",
    ["jandel call"] = "SCAMMYSAMMY", ["jelly moby come from"] = "SABSANNIVERSARY", ["jelly moby rarity"] = "SECRET", ["jelly moby source"] = "SABSANNIVERSARY", ["jingle jingle sahur come from"] = "SANTASFUSE",
    ["jingle jingle sahur rarity"] = "MYTHIC", ["jingle jingle sahur source"] = "SANTASFUSE", ["job"] = "CHIEFPRODUCTOFFICER", ["job job job sahur come from"] = "REDCARPET", ["job job job sahur rarity"] = "SECRET",
    ["job job job sahur source"] = "REDCARPET", ["job title"] = "CHIEFPRODUCTOFFICER", ["john doe come from"] = "CAVERITUAL", ["john doe rarity"] = "SECRET", ["john doe source"] = "CAVERITUAL",
    ["john pork add"] = "MAY", ["john pork added"] = "MAY", ["john pork come from"] = "REDCARPET", ["john pork rarity"] = "OG", ["john pork source"] = "REDCARPET", ["jolly jolly sahur come from"] = "SANTASMARKET",
    ["jolly jolly sahur rarity"] = "SECRET", ["jolly jolly sahur source"] = "SANTASMARKET", ["kalika bros come from"] = "CYBERCRAFT", ["kalika bros rarity"] = "SECRET", ["kalika bros source"] = "CYBERCRAFT",
    ["karker sahur come from"] = "FIRSTCRAFTMACHINE", ["karker sahur rarity"] = "SECRET", ["karker sahur source"] = "FIRSTCRAFTMACHINE", ["karkerheart luvkur rarity"] = "BRAINROTGOD",
    ["karkerkar kurkur come from"] = "ADMINABUSE", ["karkerkar kurkur rarity"] = "SECRET", ["karkerkar kurkur source"] = "ADMINABUSE", ["ketchuru and musturu come from"] = "REDCARPET",
    ["ketchuru and musturu rarity"] = "SECRET", ["ketchuru and musturu source"] = "REDCARPET", ["ketupat bros come from"] = "OGFUSE", ["ketupat bros rarity"] = "SECRET", ["ketupat bros source"] = "OGFUSE",
    ["ketupat kepat come from"] = "REDCARPET", ["ketupat kepat rarity"] = "SECRET", ["ketupat kepat source"] = "REDCARPET", ["kraken rarity"] = "SECRET", ["krupuk pagi pagi come from"] = "INDONESIA",
    ["krupuk pagi pagi rarity"] = "BRAINROTGOD", ["krupuk pagi pagi source"] = "INDONESIA", ["la anniversary grande come from"] = "LIMITEDQUANTITYCRAFT", ["la anniversary grande rarity"] = "SECRET",
    ["la anniversary grande source"] = "LIMITEDQUANTITYCRAFT", ["la casa boo rarity"] = "SECRET", ["la cucaracha come from"] = "ADMINABUSE", ["la cucaracha rarity"] = "SECRET", ["la cucaracha source"] = "ADMINABUSE",
    ["la easter grande come from"] = "LIMITEDQUANTITYCRAFT", ["la easter grande rarity"] = "SECRET", ["la easter grande source"] = "LIMITEDQUANTITYCRAFT", ["la extinct grande come from"] = "EXTINCT",
    ["la extinct grande rarity"] = "SECRET", ["la extinct grande source"] = "EXTINCT", ["la food combinasion rarity"] = "SECRET", ["la ginger sekolah rarity"] = "SECRET", ["la grande combinasion come from"] = "REDCARPET",
    ["la grande combinasion rarity"] = "SECRET", ["la grande combinasion source"] = "REDCARPET", ["la jolly grande come from"] = "CHRISTMASWHEELSPIN", ["la jolly grande rarity"] = "SECRET",
    ["la jolly grande source"] = "CHRISTMASWHEELSPIN", ["la karkerkar combinasion come from"] = "FIRSTCRAFTMACHINE", ["la karkerkar combinasion rarity"] = "SECRET", ["la karkerkar combinasion source"] = "FIRSTCRAFTMACHINE",
    ["la lucky grande come from"] = "LIMITEDQUANTITYCRAFT", ["la lucky grande rarity"] = "SECRET", ["la lucky grande source"] = "LIMITEDQUANTITYCRAFT", ["la romantic grande come from"] = "LIMITEDQUANTITYCRAFT",
    ["la romantic grande rarity"] = "SECRET", ["la romantic grande source"] = "LIMITEDQUANTITYCRAFT", ["la sahur combinasion come from"] = "FIRSTCRAFTMACHINE", ["la sahur combinasion rarity"] = "SECRET",
    ["la sahur combinasion source"] = "FIRSTCRAFTMACHINE", ["la secret combinasion rarity"] = "SECRET", ["la spooky grande come from"] = "LIMITEDQUANTITYCRAFT", ["la spooky grande rarity"] = "SECRET",
    ["la spooky grande source"] = "LIMITEDQUANTITYCRAFT", ["la summer grande come from"] = "LIMITEDQUANTITYCRAFT", ["la summer grande rarity"] = "SECRET", ["la summer grande source"] = "LIMITEDQUANTITYCRAFT",
    ["la supreme combinasion come from"] = "FIRSTFUSEMACHINE", ["la supreme combinasion rarity"] = "SECRET", ["la supreme combinasion source"] = "FIRSTFUSEMACHINE", ["la taco combinasion come from"] = "LIMITEDQUANTITYCRAFT",
    ["la taco combinasion rarity"] = "SECRET", ["la taco combinasion source"] = "LIMITEDQUANTITYCRAFT", ["la vacca jacko linterino come from"] = "HALLOWEEN", ["la vacca jacko linterino rarity"] = "SECRET",
    ["la vacca jacko linterino source"] = "HALLOWEEN", ["la vacca lepre lepreino rarity"] = "SECRET", ["la vacca prese presente come from"] = "SANTASFUSE", ["la vacca prese presente rarity"] = "SECRET",
    ["la vacca prese presente source"] = "SANTASFUSE", ["la vacca saturno saturnita come from"] = "REDCARPET", ["la vacca saturno saturnita rarity"] = "SECRET", ["la vacca saturno saturnita source"] = "REDCARPET",
    ["las capuchinas come from"] = "FIRSTCRAFTMACHINE", ["las capuchinas rarity"] = "BRAINROTGOD", ["las capuchinas source"] = "FIRSTCRAFTMACHINE", ["las sis come from"] = "FIRSTCRAFTMACHINE",
    ["las sis rarity"] = "SECRET", ["las sis source"] = "FIRSTCRAFTMACHINE", ["las tralaleritas come from"] = "REDCARPET", ["las tralaleritas rarity"] = "SECRET", ["las tralaleritas source"] = "REDCARPET",
    ["las vaquitas saturnitas come from"] = "LAVACCARITUAL", ["las vaquitas saturnitas rarity"] = "SECRET", ["las vaquitas saturnitas source"] = "LAVACCARITUAL", ["last event"] = "SPOOKYSCARYSKELETONS",
    ["last update"] = "SPOOKYSCARYSKELETONS", ["latest event"] = "SPOOKYSCARYSKELETONS", ["latest fuse"] = "HAUNTEDFUSE", ["latest machine"] = "HAUNTEDFUSE", ["latest seasonal event"] = "PHANTOM",
    ["latest trait"] = "BULL", ["latest update"] = "SPOOKYSCARYSKELETONS", ["lavadorito spinito come from"] = "REDCARPET", ["lavadorito spinito rarity"] = "SECRET", ["lavadorito spinito source"] = "REDCARPET",
    ["lazy ducky come from"] = "DLCCODE", ["lazy ducky rarity"] = "BRAINROTGOD", ["lazy ducky source"] = "DLCCODE", ["lead dev"] = "BLADEBALL", ["lead developer"] = "BLADEBALL", ["lemonita splashita come from"] = "SUMMERFUSE",
    ["lemonita splashita rarity"] = "BRAINROTGOD", ["lemonita splashita source"] = "SUMMERFUSE", ["lerulerulerule come from"] = "REDCARPET", ["lerulerulerule rarity"] = "MYTHIC", ["lerulerulerule source"] = "REDCARPET",
    ["lionel cactuseli come from"] = "REDCARPET", ["lionel cactuseli rarity"] = "LEGENDARY", ["lionel cactuseli source"] = "REDCARPET", ["liril laril come from"] = "REDCARPET", ["liril laril rarity"] = "COMMON",
    ["liril laril source"] = "REDCARPET", ["list list list sahur come from"] = "CHRISTMAS", ["list list list sahur rarity"] = "SECRET", ["list list list sahur source"] = "CHRISTMAS",
    ["live match events add"] = "JUNE", ["live match events added"] = "JUNE", ["los 25 rarity"] = "SECRET", ["los 67 rarity"] = "SECRET", ["los admins come from"] = "LOSTRADERS", ["los admins rarity"] = "SECRET",
    ["los admins source"] = "LOSTRADERS", ["los amigos rarity"] = "SECRET", ["los bombinitos rarity"] = "BRAINROTGOD", ["los bros come from"] = "FIRSTCRAFTMACHINE", ["los bros rarity"] = "SECRET",
    ["los bros source"] = "FIRSTCRAFTMACHINE", ["los bunitos rarity"] = "SECRET", ["los burritos rarity"] = "SECRET", ["los candies come from"] = "SANTASFUSE", ["los candies rarity"] = "SECRET",
    ["los candies source"] = "SANTASFUSE", ["los chicleteiras come from"] = "CHICLETEIRARITUAL", ["los chicleteiras rarity"] = "SECRET", ["los chicleteiras source"] = "CHICLETEIRARITUAL",
    ["los chihuaninis rarity"] = "BRAINROTGOD", ["los chillis come from"] = "CYBERCRAFT", ["los chillis rarity"] = "SECRET", ["los chillis source"] = "CYBERCRAFT", ["los combinasionas come from"] = "FIRSTFUSEMACHINE",
    ["los combinasionas rarity"] = "SECRET", ["los combinasionas source"] = "FIRSTFUSEMACHINE", ["los cornis come from"] = "LOSTRADERS", ["los cornis rarity"] = "SECRET", ["los cornis source"] = "LOSTRADERS",
    ["los crocodillitos come from"] = "BOMBARDIRO", ["los crocodillitos rarity"] = "BRAINROTGOD", ["los crocodillitos source"] = "BOMBARDIRO", ["los cucarachas rarity"] = "SECRET", ["los cupids come from"] = "DIVINEFUSE",
    ["los cupids rarity"] = "SECRET", ["los cupids source"] = "DIVINEFUSE", ["los fruits come from"] = "SUMMERFUSE", ["los fruits rarity"] = "SECRET", ["los fruits source"] = "SUMMERFUSE",
    ["los gattitos rarity"] = "BRAINROTGOD", ["los hackers come from"] = "CYBERCRAFT", ["los hackers rarity"] = "SECRET", ["los hackers source"] = "CYBERCRAFT", ["los hotspotsitos come from"] = "FIRSTFUSEMACHINE",
    ["los hotspotsitos rarity"] = "SECRET", ["los hotspotsitos source"] = "FIRSTFUSEMACHINE", ["los jobcitos rarity"] = "SECRET", ["los jolly combinasionas come from"] = "SANTASMARKET",
    ["los jolly combinasionas rarity"] = "SECRET", ["los jolly combinasionas source"] = "SANTASMARKET", ["los karkeritos come from"] = "KARKERRITUAL", ["los karkeritos rarity"] = "SECRET",
    ["los karkeritos source"] = "KARKERRITUAL", ["los lucky blocks add"] = "OCTOBER", ["los lucky blocks added"] = "OCTOBER", ["los mariachis come from"] = "PINATA", ["los mariachis rarity"] = "SECRET",
    ["los mariachis source"] = "PINATA", ["los matteos come from"] = "MATTEORITUAL", ["los matteos rarity"] = "SECRET", ["los matteos source"] = "MATTEORITUAL", ["los mi gatitos come from"] = "MIGATITORITUAL",
    ["los mi gatitos rarity"] = "SECRET", ["los mi gatitos source"] = "MIGATITORITUAL", ["los mobilis come from"] = "WITCHSFUSE", ["los mobilis rarity"] = "SECRET", ["los mobilis source"] = "WITCHSFUSE",
    ["los noobinis come from"] = "CYBERCRAFT", ["los noobinis rarity"] = "MYTHIC", ["los noobinis source"] = "CYBERCRAFT", ["los nooo hotspotsitos rarity"] = "SECRET", ["los orcalitos come from"] = "FIRSTFUSEMACHINE",
    ["los orcalitos rarity"] = "BRAINROTGOD", ["los orcalitos source"] = "FIRSTFUSEMACHINE", ["los planitos come from"] = "BRAINROTTRADER", ["los planitos rarity"] = "SECRET", ["los planitos source"] = "BRAINROTTRADER",
    ["los primos come from"] = "FIRSTCRAFTMACHINE", ["los primos rarity"] = "SECRET", ["los primos source"] = "FIRSTCRAFTMACHINE", ["los puggies come from"] = "BRAINROTTRADER", ["los puggies rarity"] = "SECRET",
    ["los puggies source"] = "BRAINROTTRADER", ["los quesadillas rarity"] = "SECRET", ["los secret combinasionas add"] = "JULY", ["los secret combinasionas added"] = "JULY", ["los secret combinasionas come from"] = "LOSTRADERS",
    ["los secret combinasionas rarity"] = "SECRET", ["los secret combinasionas source"] = "LOSTRADERS", ["los sekolahs rarity"] = "SECRET", ["los sigmas come from"] = "LOSTRADERS", ["los sigmas rarity"] = "SECRET",
    ["los sigmas source"] = "LOSTRADERS", ["los spaghettis come from"] = "BRAINROTTRADER", ["los spaghettis rarity"] = "SECRET", ["los spaghettis source"] = "BRAINROTTRADER", ["los spooky combinasionas rarity"] = "SECRET",
    ["los spyderinis come from"] = "SPYDERINIRITUAL", ["los spyderinis rarity"] = "SECRET", ["los spyderinis source"] = "SPYDERINIRITUAL", ["los sweethearts come from"] = "FIRSTFUSEMACHINE",
    ["los sweethearts rarity"] = "SECRET", ["los sweethearts source"] = "FIRSTFUSEMACHINE", ["los taco blocks rarity"] = "TACO", ["los tacoritas come from"] = "FIRSTCRAFTMACHINE", ["los tacoritas rarity"] = "SECRET",
    ["los tacoritas source"] = "FIRSTCRAFTMACHINE", ["los tangcitos come from"] = "LOSTRADERS", ["los tangcitos rarity"] = "SECRET", ["los tangcitos source"] = "LOSTRADERS", ["los tictacs come from"] = "LOSTRADERS",
    ["los tictacs rarity"] = "SECRET", ["los tictacs source"] = "LOSTRADERS", ["los tipi tacos rarity"] = "BRAINROTGOD", ["los tortus rarity"] = "SECRET", ["los traders add"] = "JULY",
    ["los traders added"] = "JULY", ["los tralaleritos come from"] = "REDCARPET", ["los tralaleritos rarity"] = "SECRET", ["los tralaleritos source"] = "REDCARPET", ["los trios come from"] = "OGFUSE",
    ["los trios rarity"] = "SECRET", ["los trios source"] = "OGFUSE", ["los tungtungtungcitos come from"] = "FIRSTFUSEMACHINE", ["los tungtungtungcitos rarity"] = "BRAINROTGOD", ["los tungtungtungcitos source"] = "FIRSTFUSEMACHINE",
    ["love love bear come from"] = "CUPIDSMACHINE", ["love love bear rarity"] = "SECRET", ["love love bear source"] = "CUPIDSMACHINE", ["love love love sahur rarity"] = "SECRET", ["lovin rose come from"] = "CUPIDSMACHINE",
    ["lovin rose rarity"] = "SECRET", ["lovin rose source"] = "CUPIDSMACHINE", ["lowest luck"] = "2X", ["ltm add"] = "JANUARY", ["ltm added"] = "JANUARY", ["luck luck luck sahur rarity"] = "SECRET",
    ["lucky blocks add"] = "JULY", ["lucky blocks added"] = "JULY", ["lucky catch machine brainrot"] = "MEDUSINIMEDUSINIANDDEMONINI", ["lucky pot add"] = "MARCH", ["lucky pot added"] = "MARCH",
    ["lumaca malefica come from"] = "BACKROOMS", ["lumaca malefica rarity"] = "BRAINROTGOD", ["lumaca malefica source"] = "BACKROOMS", ["luv luv luv rarity"] = "BRAINROTGOD", ["machine replaced fuse machine"] = "FIRSTCRAFTMACHINE",
    ["magi ribbitini come from"] = "WITCHSFUSE", ["magi ribbitini rarity"] = "MYTHIC", ["magi ribbitini source"] = "WITCHSFUSE", ["malame amarele come from"] = "FIRSTCRAFTMACHINE", ["malame amarele rarity"] = "EPIC",
    ["malame amarele source"] = "FIRSTCRAFTMACHINE", ["mangolini parrocini come from"] = "BRAINROTTRADER", ["mangolini parrocini rarity"] = "EPIC", ["mangolini parrocini source"] = "BRAINROTTRADER",
    ["mariachi corazoni come from"] = "PINATA", ["mariachi corazoni rarity"] = "SECRET", ["mariachi corazoni source"] = "PINATA", ["mastodontico telepiedone rarity"] = "BRAINROTGOD",
    ["matteo come from"] = "ADMINABUSE", ["matteo rarity"] = "BRAINROTGOD", ["matteo source"] = "ADMINABUSE", ["max luck"] = "35X", ["meowl add"] = "OCTOBER", ["meowl added"] = "OCTOBER",
    ["meowl come from"] = "REDCARPET", ["meowl rarity"] = "OG", ["meowl source"] = "REDCARPET", ["mexico add"] = "SEPTEMBER", ["mexico added"] = "SEPTEMBER", ["mexico event add"] = "SEPTEMBER",
    ["mexico event added"] = "SEPTEMBER", ["mi gatito come from"] = "ADMINABUSE", ["mi gatito rarity"] = "SECRET", ["mi gatito source"] = "ADMINABUSE", ["mieteteira bicicleteira come from"] = "WITCHSFUSE",
    ["mieteteira bicicleteira rarity"] = "SECRET", ["mieteteira bicicleteira source"] = "WITCHSFUSE", ["moby bros come from"] = "LOSTRADERS", ["moby bros rarity"] = "SECRET", ["moby bros source"] = "LOSTRADERS",
    ["molten add"] = "JULY", ["molten added"] = "JULY", ["molten event add"] = "JULY", ["molten event added"] = "JULY", ["money money bros come from"] = "CYBERCRAFT", ["money money bros rarity"] = "SECRET",
    ["money money bros source"] = "CYBERCRAFT", ["money money man come from"] = "BRAINROTTRADER", ["money money man rarity"] = "BRAINROTGOD", ["money money man source"] = "BRAINROTTRADER",
    ["money money puggy come from"] = "REDCARPET", ["money money puggy rarity"] = "SECRET", ["money money puggy source"] = "REDCARPET", ["money money reindeer come from"] = "SANTASMARKET",
    ["money money reindeer rarity"] = "SECRET", ["money money reindeer source"] = "SANTASMARKET", ["month add 1 los traders brainrot"] = "JULY", ["month add 1 year anniversary"] = "MAY",
    ["month add 1x1x1x1 ritual"] = "NOVEMBER", ["month add 30x luck"] = "MAY", ["month add admin machine"] = "FEBRUARY", ["month add appelini"] = "APRIL", ["month add backrooms"] = "MAY",
    ["month add backrooms event"] = "MAY", ["month add bananito"] = "APRIL", ["month add berryno"] = "APRIL", ["month add bloodmoon"] = "JUNE", ["month add bloodmoon event"] = "JUNE",
    ["month add bloodrot"] = "JUNE", ["month add brainrot dealer"] = "NOVEMBER", ["month add brainrot trader"] = "NOVEMBER", ["month add brazil"] = "AUGUST", ["month add brazil event"] = "AUGUST",
    ["month add bubblegum trait"] = "JULY", ["month add bull trait"] = "JULY", ["month add candy"] = "JULY", ["month add candy aurora"] = "JULY", ["month add candy aurora event"] = "JULY",
    ["month add cash or card"] = "APRIL", ["month add caylusaurus"] = "JUNE", ["month add chicleteira champeona"] = "JULY", ["month add concert"] = "JANUARY", ["month add craft machine"] = "SEPTEMBER",
    ["month add crystal"] = "JULY", ["month add crystal event"] = "JULY", ["month add crystal slap hammer base"] = "JULY", ["month add cupids machine"] = "FEBRUARY", ["month add cursed"] = "JANUARY",
    ["month add cyber"] = "APRIL", ["month add cyber admin machine"] = "APRIL", ["month add cyber craft machine"] = "APRIL", ["month add diamond mutations"] = "MAY", ["month add divine"] = "FEBRUARY",
    ["month add divine admin machine"] = "FEBRUARY", ["month add divine fuse"] = "MARCH", ["month add duels machine"] = "JANUARY", ["month add easter hour"] = "MARCH", ["month add egg city"] = "APRIL",
    ["month add egg hunt"] = "APRIL", ["month add egg lucky block"] = "APRIL", ["month add eid celebration"] = "MARCH", ["month add examen bros"] = "JULY", ["month add extinct"] = "SEPTEMBER",
    ["month add festive lucky block"] = "DECEMBER", ["month add fishing"] = "NOVEMBER", ["month add fuse"] = "JANUARY", ["month add fuse machine"] = "AUGUST", ["month add galaxy"] = "AUGUST",
    ["month add galaxy event"] = "AUGUST", ["month add gold"] = "MAY", ["month add grannys funeral"] = "MARCH", ["month add guest 666"] = "APRIL", ["month add halloween"] = "OCTOBER",
    ["month add haunted fuse"] = "OCTOBER", ["month add headless horseman base skin"] = "FEBRUARY", ["month add heart lucky block"] = "FEBRUARY", ["month add index"] = "DECEMBER", ["month add indonesian"] = "OCTOBER",
    ["month add indonesian event"] = "OCTOBER", ["month add john pork"] = "MAY", ["month add live match events"] = "JUNE", ["month add los lucky blocks"] = "OCTOBER", ["month add los secret combinasionas"] = "JULY",
    ["month add los traders"] = "JULY", ["month add ltm"] = "JANUARY", ["month add lucky blocks"] = "JULY", ["month add lucky pot"] = "MARCH", ["month add meowl"] = "OCTOBER", ["month add mexico"] = "SEPTEMBER",
    ["month add mexico event"] = "SEPTEMBER", ["month add molten"] = "JULY", ["month add molten event"] = "JULY", ["month add north pole"] = "DECEMBER", ["month add north pole event"] = "DECEMBER",
    ["month add not released yet"] = "OCTOBER", ["month add og"] = "AUGUST", ["month add phantom"] = "JUNE", ["month add pizza"] = "JULY", ["month add radioactive"] = "NOVEMBER", ["month add rainbow"] = "JUNE",
    ["month add rainbow machine"] = "JUNE", ["month add ranch"] = "JULY", ["month add ritual"] = "JANUARY", ["month add santas fuse"] = "DECEMBER", ["month add secret"] = "MAY", ["month add secrets toro espanolo"] = "JULY",
    ["month add skibidi toilet"] = "DECEMBER", ["month add spain"] = "JULY", ["month add spain event"] = "JULY", ["month add steakini fattini"] = "MAY", ["month add strawberrita"] = "APRIL",
    ["month add strawberry elephant"] = "AUGUST", ["month add summer fuse"] = "MAY", ["month add summer lucky block"] = "JUNE", ["month add taco trait reworked"] = "JULY", ["month add this next update"] = "OCTOBER",
    ["month add trade machine"] = "FEBRUARY", ["month add traits"] = "JUNE", ["month add tung tung tung sahur"] = "NOVEMBER", ["month add winter hour"] = "DECEMBER", ["month add witch fuse"] = "OCTOBER",
    ["month add witching hour"] = "OCTOBER", ["month add yin yang"] = "SEPTEMBER", ["month add yin yang event"] = "SEPTEMBER", ["most expensive rod"] = "RADIOACTIVEROD", ["most recent event"] = "SPOOKYSCARYSKELETONS",
    ["mummio rappitto come from"] = "WITCHSFUSE", ["mummio rappitto rarity"] = "EPIC", ["mummio rappitto source"] = "WITCHSFUSE", ["mummy ambalabu rarity"] = "BRAINROTGOD", ["mutation add"] = "11",
    ["nacho spyder come from"] = "LIMITEDQUANTITYCRAFT", ["nacho spyder rarity"] = "SECRET", ["nacho spyder source"] = "LIMITEDQUANTITYCRAFT", ["naughty naughty come from"] = "CHRISTMAS",
    ["naughty naughty rarity"] = "SECRET", ["naughty naughty source"] = "CHRISTMAS", ["new brainrot god"] = "SLUSHIHUSKI", ["new event"] = "SPOOKYSCARYSKELETONS", ["new fuse"] = "HAUNTEDFUSE",
    ["new update"] = "SPOOKYSCARYSKELETONS", ["newest best brainrot"] = "ARCABROS", ["newest brainrot god"] = "SLUSHIHUSKI", ["newest event"] = "SPOOKYSCARYSKELETONS", ["newest event add"] = "SPOOKYSCARYSKELETONS",
    ["newest event exclusive brainrot"] = "CHICKENZOMBIE", ["newest fuse"] = "HAUNTEDFUSE", ["newest machine"] = "HAUNTEDFUSE", ["newest mutation event"] = "CRYSTAL", ["newest og event"] = "JOHNPORK",
    ["newest seasonal event"] = "PHANTOM", ["newest trait"] = "BULL", ["newest update"] = "SPOOKYSCARYSKELETONS", ["newest update number"] = "71", ["next update number"] = "72", ["nickname"] = "SCAMMYSAMMY",
    ["noo candy come from"] = "TRICKORTREAT", ["noo candy rarity"] = "SECRET", ["noo candy source"] = "TRICKORTREAT", ["noo eggs come from"] = "EASTER", ["noo eggs rarity"] = "SECRET",
    ["noo eggs source"] = "EASTER", ["noo examen come from"] = "DULDULRITUAL", ["noo examen rarity"] = "SECRET", ["noo examen source"] = "DULDULRITUAL", ["noo gold rarity"] = "SECRET",
    ["noo heart rarity"] = "SECRET", ["noo la polizia come from"] = "BRAINROTTRADER", ["noo la polizia rarity"] = "BRAINROTGOD", ["noo la polizia source"] = "BRAINROTTRADER", ["noo present come from"] = "CHRISTMAS",
    ["noo present rarity"] = "SECRET", ["noo present source"] = "CHRISTMAS", ["noo resume come from"] = "JOBRITUAL", ["noo resume rarity"] = "SECRET", ["noo resume source"] = "JOBRITUAL",
    ["noobini pizzanini come from"] = "REDCARPET", ["noobini pizzanini rarity"] = "COMMON", ["noobini pizzanini source"] = "REDCARPET", ["noobini santanini come from"] = "SANTASFUSE",
    ["noobini santanini rarity"] = "COMMON", ["noobini santanini source"] = "SANTASFUSE", ["noodle noodle poodle come from"] = "REDCARPET", ["noodle noodle poodle rarity"] = "SECRET",
    ["noodle noodle poodle source"] = "REDCARPET", ["nooo hotspot come from"] = "TACO", ["nooo hotspot rarity"] = "SECRET", ["nooo hotspot source"] = "TACO", ["north pole add"] = "DECEMBER",
    ["north pole added"] = "DECEMBER", ["north pole event add"] = "DECEMBER", ["north pole event added"] = "DECEMBER", ["not released yet add"] = "OCTOBER", ["not released yet added"] = "OCTOBER",
    ["nuclearo dinossauro come from"] = "REDCARPET", ["nuclearo dinossauro rarity"] = "SECRET", ["nuclearo dinossauro source"] = "REDCARPET", ["octoball rarity"] = "SECRET", ["odin din din dun rarity"] = "BRAINROTGOD",
    ["og add"] = "AUGUST", ["og added"] = "AUGUST", ["ombrello topolino come from"] = "SUMMERFUSE", ["ombrello topolino rarity"] = "SECRET", ["ombrello topolino source"] = "SUMMERFUSE",
    ["orangutini ananassini come from"] = "REDCARPET", ["orangutini ananassini rarity"] = "MYTHIC", ["orangutini ananassini source"] = "REDCARPET", ["orbi mochi come from"] = "CYBERCRAFT",
    ["orbi mochi rarity"] = "MYTHIC", ["orbi mochi source"] = "CYBERCRAFT", ["orcaledon come from"] = "BRAINROTTRADER", ["orcaledon rarity"] = "SECRET", ["orcaledon source"] = "BRAINROTTRADER",
    ["orcalero orcala rarity"] = "BRAINROTGOD", ["orcalita orcala come from"] = "CYBERCRAFT", ["orcalita orcala rarity"] = "BRAINROTGOD", ["orcalita orcala source"] = "CYBERCRAFT", ["pakrahmatmamat come from"] = "REDCARPET",
    ["pakrahmatmamat rarity"] = "BRAINROTGOD", ["pakrahmatmamat source"] = "REDCARPET", ["pakrahmatmatina come from"] = "POLEGAME", ["pakrahmatmatina rarity"] = "BRAINROTGOD", ["pakrahmatmatina source"] = "POLEGAME",
    ["pancake and syrup come from"] = "DLCCODE", ["pancake and syrup rarity"] = "SECRET", ["pancake and syrup source"] = "DLCCODE", ["pandaccini bananini come from"] = "REDCARPET", ["pandaccini bananini rarity"] = "LEGENDARY",
    ["pandaccini bananini source"] = "REDCARPET", ["pandanini frostini rarity"] = "BRAINROTGOD", ["paradiso axolottino come from"] = "DIVINEFUSE", ["paradiso axolottino rarity"] = "SECRET",
    ["paradiso axolottino source"] = "DIVINEFUSE", ["patteo rarity"] = "BRAINROTGOD", ["pengolino nuvoletto come from"] = "DIVINEFUSE", ["pengolino nuvoletto rarity"] = "RARE", ["pengolino nuvoletto source"] = "DIVINEFUSE",
    ["penguin tree come from"] = "SANTASFUSE", ["penguin tree rarity"] = "EPIC", ["penguin tree source"] = "SANTASFUSE", ["penguino cocosino come from"] = "SUMMERFUSE", ["penguino cocosino rarity"] = "EPIC",
    ["penguino cocosino source"] = "SUMMERFUSE", ["perochello lemonchello come from"] = "REDCARPET", ["perochello lemonchello rarity"] = "EPIC", ["perochello lemonchello source"] = "REDCARPET",
    ["perrito burrito come from"] = "LIMITEDQUANTITYCRAFT", ["perrito burrito rarity"] = "SECRET", ["perrito burrito source"] = "LIMITEDQUANTITYCRAFT", ["phantom add"] = "JUNE", ["phantom added"] = "JUNE",
    ["pi pi watermelon come from"] = "SUMMERFUSE", ["pi pi watermelon rarity"] = "LEGENDARY", ["pi pi watermelon source"] = "SUMMERFUSE", ["piccione macchina come from"] = "REDCARPET",
    ["piccione macchina rarity"] = "BRAINROTGOD", ["piccione macchina source"] = "REDCARPET", ["piccionetta macchina come from"] = "FIRSTCRAFTMACHINE", ["piccionetta macchina rarity"] = "BRAINROTGOD",
    ["piccionetta macchina source"] = "FIRSTCRAFTMACHINE", ["pinealotto fruttarino come from"] = "WITCHSFUSE", ["pinealotto fruttarino rarity"] = "RARE", ["pinealotto fruttarino source"] = "WITCHSFUSE",
    ["pineaplino come from"] = "DLCCODE", ["pineaplino rarity"] = "BRAINROTGOD", ["pineaplino source"] = "DLCCODE", ["pipi avocado come from"] = "SUMMERFUSE", ["pipi avocado rarity"] = "RARE",
    ["pipi avocado source"] = "SUMMERFUSE", ["pipi corni come from"] = "SUMMERFUSE", ["pipi corni rarity"] = "COMMON", ["pipi corni source"] = "SUMMERFUSE", ["pipi kiwi come from"] = "REDCARPET",
    ["pipi kiwi rarity"] = "COMMON", ["pipi kiwi source"] = "REDCARPET", ["pipi potato come from"] = "REDCARPET", ["pipi potato rarity"] = "LEGENDARY", ["pipi potato source"] = "REDCARPET",
    ["pirulitoita bicicleteira come from"] = "BRAINROTTRADER", ["pirulitoita bicicleteira rarity"] = "SECRET", ["pirulitoita bicicleteira source"] = "BRAINROTTRADER", ["pizza add"] = "JULY",
    ["pizza added"] = "JULY", ["pizza and ranch rarity"] = "SECRET", ["please present come from"] = "ADVENTCALENDAR", ["please present rarity"] = "SECRET", ["please present source"] = "ADVENTCALENDAR",
    ["pop pop sahur rarity"] = "BRAINROTGOD", ["popcuru and fizzuru come from"] = "OGFUSE", ["popcuru and fizzuru rarity"] = "SECRET", ["popcuru and fizzuru source"] = "OGFUSE", ["position"] = "CHIEFPRODUCTOFFICER",
    ["pot hotspot rarity"] = "SECRET", ["pot pumpkin come from"] = "HALLOWEEN", ["pot pumpkin rarity"] = "SECRET", ["pot pumpkin source"] = "HALLOWEEN", ["pretzo robo come from"] = "CYBERCRAFT",
    ["pretzo robo rarity"] = "BRAINROTGOD", ["pretzo robo source"] = "CYBERCRAFT", ["puffaball come from"] = "FISHING", ["puffaball rarity"] = "LEGENDARY", ["puffaball source"] = "FISHING",
    ["pumpkini spyderini rarity"] = "SECRET", ["quackini snackini come from"] = "EGGTOWN", ["quackini snackini rarity"] = "SECRET", ["quackini snackini source"] = "EGGTOWN", ["quackula come from"] = "WITCHSFUSE",
    ["quackula rarity"] = "LEGENDARY", ["quackula source"] = "WITCHSFUSE", ["quesadilla crocodila rarity"] = "SECRET", ["quesadillo vampiro come from"] = "LIMITEDQUANTITYCRAFT", ["quesadillo vampiro rarity"] = "SECRET",
    ["quesadillo vampiro source"] = "LIMITEDQUANTITYCRAFT", ["quivioli ameleonni come from"] = "REDCARPET", ["quivioli ameleonni rarity"] = "LEGENDARY", ["quivioli ameleonni source"] = "REDCARPET",
    ["raccooni jandelini come from"] = "ADMINABUSEWAR", ["raccooni jandelini rarity"] = "COMMON", ["raccooni jandelini source"] = "ADMINABUSEWAR", ["radioactive add"] = "NOVEMBER", ["radioactive added"] = "NOVEMBER",
    ["rainbow add"] = "JUNE", ["rainbow added"] = "JUNE", ["rainbow machine add"] = "JUNE", ["rainbow machine added"] = "JUNE", ["ranch add"] = "JULY", ["ranch added"] = "JULY", ["rang ring bus come from"] = "POLEGAME",
    ["rang ring bus rarity"] = "SECRET", ["rang ring bus source"] = "POLEGAME", ["rarest base"] = "GARAMAANDMADUNDUNG", ["rarest brainrot base"] = "GARAMAANDMADUNDUNG", ["rarest brainrot sammys base"] = "GARAMAANDMADUNDUNG",
    ["rarity 1x1x1x1"] = "SECRET", ["rarity 25"] = "SECRET", ["rarity 4th bros"] = "SECRET", ["rarity 67"] = "SECRET", ["rarity abyssaloco"] = "SECRET", ["rarity agarrini la palini"] = "SECRET",
    ["rarity alessio"] = "BRAINROTGOD", ["rarity anpali babel"] = "BRAINROTGOD", ["rarity antonio"] = "SECRET", ["rarity appelini"] = "BRAINROTGOD", ["rarity aquanaut"] = "BRAINROTGOD",
    ["rarity aquarino"] = "SECRET", ["rarity arcadopus"] = "SECRET", ["rarity arcadragon"] = "SECRET", ["rarity astrolero cervalero"] = "BRAINROTGOD", ["rarity avocadini antilopini"] = "EPIC",
    ["rarity avocadini guffo"] = "EPIC", ["rarity avocadorilla"] = "MYTHIC", ["rarity bacuru and egguru"] = "SECRET", ["rarity ballerina cappuccina"] = "LEGENDARY", ["rarity ballerina peppermintina"] = "BRAINROTGOD",
    ["rarity ballerino lololo"] = "BRAINROTGOD", ["rarity bambini crostini"] = "EPIC", ["rarity bambu bambu sahur"] = "BRAINROTGOD", ["rarity bananita dolphinita"] = "EPIC", ["rarity bananito"] = "SECRET",
    ["rarity bananito bandito"] = "MYTHIC", ["rarity bandito axolito"] = "LEGENDARY", ["rarity bandito bobritto"] = "RARE", ["rarity baskito"] = "SECRET", ["rarity bearito cabinito"] = "SECRET",
    ["rarity bee loco"] = "MYTHIC", ["rarity belula beluga"] = "BRAINROTGOD", ["rarity berenjello angello"] = "MYTHIC", ["rarity berryno"] = "SECRET", ["rarity bisonte giuppitere"] = "SECRET",
    ["rarity blackhole goat"] = "SECRET", ["rarity blueberrinni octopusini"] = "LEGENDARY", ["rarity boatito auratito"] = "SECRET", ["rarity boba panda"] = "BRAINROTGOD", ["rarity bombardini tortinii"] = "BRAINROTGOD",
    ["rarity bombardiro crocodilo"] = "MYTHIC", ["rarity bombardiro vaccariro"] = "SECRET", ["rarity bombombini gusini"] = "MYTHIC", ["rarity boneca ambalabu"] = "RARE", ["rarity boppin bunny"] = "SECRET",
    ["rarity brasilini berimbini"] = "BRAINROTGOD", ["rarity brr brr patapim"] = "EPIC", ["rarity brr es teh patipum"] = "BRAINROTGOD", ["rarity brri brri bicus dicus bombicus"] = "EPIC",
    ["rarity brunito marsito"] = "SECRET", ["rarity brutto gialutto"] = "MYTHIC", ["rarity bucketoro"] = "MYTHIC", ["rarity bufalino boomberino"] = "SECRET", ["rarity buho de fuego"] = "LEGENDARY",
    ["rarity buho de noelo"] = "BRAINROTGOD", ["rarity buho de volto"] = "SECRET", ["rarity buho del cielo"] = "LEGENDARY", ["rarity bulbito bandito traktorito"] = "BRAINROTGOD", ["rarity bunito bunito spinito"] = "SECRET",
    ["rarity bunny and eggy"] = "SECRET", ["rarity bunny bunny bunny sahur"] = "SECRET", ["rarity bunny tralala"] = "BRAINROTGOD", ["rarity bunnyman"] = "SECRET", ["rarity buntteo"] = "SECRET",
    ["rarity burbaloni loliloli"] = "LEGENDARY", ["rarity burguro and fryuro"] = "SECRET", ["rarity burrito bandito"] = "SECRET", ["rarity cacasito satalito"] = "BRAINROTGOD", ["rarity cachorrito melonito"] = "MYTHIC",
    ["rarity cacto hipopotamo"] = "RARE", ["rarity camera ramena"] = "SECRET", ["rarity cangurato gelato"] = "SECRET", ["rarity capi taco"] = "BRAINROTGOD", ["rarity capitano americano"] = "SECRET",
    ["rarity capitano gullini"] = "SECRET", ["rarity capitano moby"] = "SECRET", ["rarity cappuccino assassino"] = "EPIC", ["rarity cappuccino clownino"] = "BRAINROTGOD", ["rarity caramello filtrello"] = "LEGENDARY",
    ["rarity carloo"] = "MYTHIC", ["rarity carrotini brainini"] = "MYTHIC", ["rarity cash or card"] = "SECRET", ["rarity cavallo virtuoso"] = "MYTHIC", ["rarity caylusaurus"] = "SECRET",
    ["rarity celestial pegasus"] = "SECRET", ["rarity celularcini viciosini"] = "SECRET", ["rarity centrucci nuclucci"] = "MYTHIC", ["rarity cerberus"] = "SECRET", ["rarity chachechi"] = "SECRET",
    ["rarity chef crabracadabra"] = "LEGENDARY", ["rarity chicleteira bicicleteira"] = "SECRET", ["rarity chicleteira champeona"] = "SECRET", ["rarity chicleteira cupideira"] = "SECRET",
    ["rarity chicleteira noelteira"] = "SECRET", ["rarity chicleteira surfeiteira"] = "SECRET", ["rarity chicleteirina bicicleteirina"] = "SECRET", ["rarity chihuanini taconini"] = "BRAINROTGOD",
    ["rarity chill puppy"] = "SECRET", ["rarity chillin chili"] = "SECRET", ["rarity chimnino"] = "SECRET", ["rarity chimpanzini bananini"] = "LEGENDARY", ["rarity chipso and queso"] = "SECRET",
    ["rarity chocco bunny"] = "LEGENDARY", ["rarity chrismasmamat"] = "BRAINROTGOD", ["rarity churrito bunnito"] = "SECRET", ["rarity cigno fulgoro"] = "SECRET", ["rarity clickerino crabo"] = "LEGENDARY",
    ["rarity cloverat clapat"] = "SECRET", ["rarity clovkur kurkur"] = "BRAINROTGOD", ["rarity coco and mango"] = "SECRET", ["rarity cocoa assassino"] = "BRAINROTGOD", ["rarity cocofanto elefanto"] = "BRAINROTGOD",
    ["rarity cocosini mama"] = "LEGENDARY", ["rarity cocoteddy"] = "MYTHIC", ["rarity cola cat"] = "BRAINROTGOD", ["rarity cooki and milki"] = "SECRET", ["rarity corn corn corn sahur"] = "BRAINROTGOD",
    ["rarity crabbo limonetta"] = "BRAINROTGOD", ["rarity craburger"] = "SECRET", ["rarity cuadramat and pakrahmatmamat"] = "SECRET", ["rarity cupcake koala"] = "RARE", ["rarity cupid cupid sahur"] = "SECRET",
    ["rarity cupid hotspot"] = "SECRET", ["rarity digi narwhal"] = "SECRET", ["rarity divino platypio"] = "BRAINROTGOD", ["rarity dj panda"] = "SECRET", ["rarity doi doi do"] = "EPIC",
    ["rarity dolphini jetskini"] = "BRAINROTGOD", ["rarity donkeyturbo express"] = "SECRET", ["rarity dragon aquanini"] = "SECRET", ["rarity dragon cannelloni"] = "SECRET", ["rarity dragon gingerini"] = "SECRET",
    ["rarity dug dug dug"] = "SECRET", ["rarity duggy bros"] = "SECRET", ["rarity dul dul dul"] = "SECRET", ["rarity dumborino miracello"] = "BRAINROTGOD", ["rarity easter easter easter sahur"] = "SECRET",
    ["rarity eggdin egg egg dun"] = "BRAINROTGOD", ["rarity eid eid eid sahur"] = "SECRET", ["rarity electro quacko"] = "LEGENDARY", ["rarity elefanto frigo"] = "SECRET", ["rarity esok goala"] = "SECRET",
    ["rarity esok sekolah"] = "SECRET", ["rarity espresso signora"] = "BRAINROTGOD", ["rarity eviledon"] = "SECRET", ["rarity examen bros"] = "SECRET", ["rarity extinct ballerina"] = "BRAINROTGOD",
    ["rarity extinct matteo"] = "SECRET", ["rarity extinct tralalero"] = "SECRET", ["rarity festive 67"] = "SECRET", ["rarity fishboard"] = "SECRET", ["rarity fishino clownino"] = "SECRET",
    ["rarity fizzy soda"] = "MYTHIC", ["rarity flancito"] = "SECRET", ["rarity flipa sandala"] = "SECRET", ["rarity flippo marino"] = "BRAINROTGOD", ["rarity fluriflura"] = "COMMON",
    ["rarity fortunu and cashuru"] = "SECRET", ["rarity foxini lanternini"] = "SECRET", ["rarity fragola la la la"] = "SECRET", ["rarity fragrama and chocrama"] = "SECRET", ["rarity frankentteo"] = "SECRET",
    ["rarity frigo camelo"] = "MYTHIC", ["rarity frio ninja"] = "BRAINROTGOD", ["rarity frogato pirato"] = "EPIC", ["rarity frogo elfo"] = "RARE", ["rarity frullato framingo"] = "SECRET",
    ["rarity futbolini skatini"] = "SECRET", ["rarity ganganzelli trulala"] = "MYTHIC", ["rarity gangster footera"] = "RARE", ["rarity garama and madundung"] = "SECRET", ["rarity gato celesto"] = "EPIC",
    ["rarity gattatino nyanino"] = "BRAINROTGOD", ["rarity gattito tacoto"] = "BRAINROTGOD", ["rarity gelato lumacho"] = "SECRET", ["rarity giftini spyderini"] = "SECRET", ["rarity ginger cisterna"] = "BRAINROTGOD",
    ["rarity ginger gerat"] = "SECRET", ["rarity ginger globo"] = "BRAINROTGOD", ["rarity girafa celestre"] = "BRAINROTGOD", ["rarity girafini raftini"] = "SECRET", ["rarity glaciator"] = "SECRET",
    ["rarity globa steppa"] = "SECRET", ["rarity glorbo fruttodrillo"] = "LEGENDARY", ["rarity goat"] = "SECRET", ["rarity gobblino uniciclino"] = "SECRET", ["rarity gold elf"] = "SECRET",
    ["rarity gold gold gold"] = "SECRET", ["rarity gorillo subwoofero"] = "MYTHIC", ["rarity gorillo watermelondrillo"] = "MYTHIC", ["rarity grabatron"] = "SECRET", ["rarity graipuss medussi"] = "SECRET",
    ["rarity granchiello spiritell"] = "BRAINROTGOD", ["rarity granny"] = "SECRET", ["rarity griffin"] = "SECRET", ["rarity guerriro digitale"] = "SECRET", ["rarity guest 666"] = "SECRET",
    ["rarity gym bros"] = "SECRET", ["rarity harpuccino"] = "MYTHIC", ["rarity headless horseman"] = "OG", ["rarity hippo golazo"] = "SECRET", ["rarity ho ho ho sahur"] = "SECRET", ["rarity holy arepa"] = "COMMON",
    ["rarity hopilikalika hopilikalako"] = "SECRET", ["rarity horegini boom"] = "SECRET", ["rarity hydra bunny"] = "SECRET", ["rarity hydra dragon cannelloni"] = "SECRET", ["rarity jacko jack jack"] = "BRAINROTGOD",
    ["rarity jacko spaventosa"] = "MYTHIC", ["rarity jackorilla"] = "SECRET", ["rarity jelly moby"] = "SECRET", ["rarity jingle jingle sahur"] = "MYTHIC", ["rarity job job job sahur"] = "SECRET",
    ["rarity john doe"] = "SECRET", ["rarity john pork"] = "OG", ["rarity jolly jolly sahur"] = "SECRET", ["rarity kalika bros"] = "SECRET", ["rarity karker sahur"] = "SECRET", ["rarity karkerheart luvkur"] = "BRAINROTGOD",
    ["rarity karkerkar kurkur"] = "SECRET", ["rarity ketchuru and musturu"] = "SECRET", ["rarity ketupat bros"] = "SECRET", ["rarity ketupat kepat"] = "SECRET", ["rarity kraken"] = "SECRET",
    ["rarity krupuk pagi pagi"] = "BRAINROTGOD", ["rarity la anniversary grande"] = "SECRET", ["rarity la casa boo"] = "SECRET", ["rarity la cucaracha"] = "SECRET", ["rarity la easter grande"] = "SECRET",
    ["rarity la extinct grande"] = "SECRET", ["rarity la food combinasion"] = "SECRET", ["rarity la ginger sekolah"] = "SECRET", ["rarity la grande combinasion"] = "SECRET", ["rarity la jolly grande"] = "SECRET",
    ["rarity la karkerkar combinasion"] = "SECRET", ["rarity la lucky grande"] = "SECRET", ["rarity la romantic grande"] = "SECRET", ["rarity la sahur combinasion"] = "SECRET", ["rarity la secret combinasion"] = "SECRET",
    ["rarity la spooky grande"] = "SECRET", ["rarity la summer grande"] = "SECRET", ["rarity la supreme combinasion"] = "SECRET", ["rarity la taco combinasion"] = "SECRET", ["rarity la vacca jacko linterino"] = "SECRET",
    ["rarity la vacca lepre lepreino"] = "SECRET", ["rarity la vacca prese presente"] = "SECRET", ["rarity la vacca saturno saturnita"] = "SECRET", ["rarity las capuchinas"] = "BRAINROTGOD",
    ["rarity las sis"] = "SECRET", ["rarity las tralaleritas"] = "SECRET", ["rarity las vaquitas saturnitas"] = "SECRET", ["rarity lavadorito spinito"] = "SECRET", ["rarity lazy ducky"] = "BRAINROTGOD",
    ["rarity lemonita splashita"] = "BRAINROTGOD", ["rarity lerulerulerule"] = "MYTHIC", ["rarity lionel cactuseli"] = "LEGENDARY", ["rarity liril laril"] = "COMMON", ["rarity list list list sahur"] = "SECRET",
    ["rarity los 25"] = "SECRET", ["rarity los 67"] = "SECRET", ["rarity los admins"] = "SECRET", ["rarity los amigos"] = "SECRET", ["rarity los bombinitos"] = "BRAINROTGOD", ["rarity los bros"] = "SECRET",
    ["rarity los bunitos"] = "SECRET", ["rarity los burritos"] = "SECRET", ["rarity los candies"] = "SECRET", ["rarity los chicleteiras"] = "SECRET", ["rarity los chihuaninis"] = "BRAINROTGOD",
    ["rarity los chillis"] = "SECRET", ["rarity los combinasionas"] = "SECRET", ["rarity los cornis"] = "SECRET", ["rarity los crocodillitos"] = "BRAINROTGOD", ["rarity los cucarachas"] = "SECRET",
    ["rarity los cupids"] = "SECRET", ["rarity los fruits"] = "SECRET", ["rarity los gattitos"] = "BRAINROTGOD", ["rarity los hackers"] = "SECRET", ["rarity los hotspotsitos"] = "SECRET",
    ["rarity los jobcitos"] = "SECRET", ["rarity los jolly combinasionas"] = "SECRET", ["rarity los karkeritos"] = "SECRET", ["rarity los mariachis"] = "SECRET", ["rarity los matteos"] = "SECRET",
    ["rarity los mi gatitos"] = "SECRET", ["rarity los mobilis"] = "SECRET", ["rarity los noobinis"] = "MYTHIC", ["rarity los nooo hotspotsitos"] = "SECRET", ["rarity los orcalitos"] = "BRAINROTGOD",
    ["rarity los planitos"] = "SECRET", ["rarity los primos"] = "SECRET", ["rarity los puggies"] = "SECRET", ["rarity los quesadillas"] = "SECRET", ["rarity los secret combinasionas"] = "SECRET",
    ["rarity los sekolahs"] = "SECRET", ["rarity los sigmas"] = "SECRET", ["rarity los spaghettis"] = "SECRET", ["rarity los spooky combinasionas"] = "SECRET", ["rarity los spyderinis"] = "SECRET",
    ["rarity los sweethearts"] = "SECRET", ["rarity los taco blocks"] = "TACO", ["rarity los tacoritas"] = "SECRET", ["rarity los tangcitos"] = "SECRET", ["rarity los tictacs"] = "SECRET",
    ["rarity los tipi tacos"] = "BRAINROTGOD", ["rarity los tortus"] = "SECRET", ["rarity los tralaleritos"] = "SECRET", ["rarity los trios"] = "SECRET", ["rarity los tungtungtungcitos"] = "BRAINROTGOD",
    ["rarity love love bear"] = "SECRET", ["rarity love love love sahur"] = "SECRET", ["rarity lovin rose"] = "SECRET", ["rarity luck luck luck sahur"] = "SECRET", ["rarity lumaca malefica"] = "BRAINROTGOD",
    ["rarity luv luv luv"] = "BRAINROTGOD", ["rarity magi ribbitini"] = "MYTHIC", ["rarity malame amarele"] = "EPIC", ["rarity mangolini parrocini"] = "EPIC", ["rarity mariachi corazoni"] = "SECRET",
    ["rarity mastodontico telepiedone"] = "BRAINROTGOD", ["rarity matteo"] = "BRAINROTGOD", ["rarity meowl"] = "OG", ["rarity mi gatito"] = "SECRET", ["rarity mieteteira bicicleteira"] = "SECRET",
    ["rarity moby bros"] = "SECRET", ["rarity money money bros"] = "SECRET", ["rarity money money man"] = "BRAINROTGOD", ["rarity money money puggy"] = "SECRET", ["rarity money money reindeer"] = "SECRET",
    ["rarity mummio rappitto"] = "EPIC", ["rarity mummy ambalabu"] = "BRAINROTGOD", ["rarity nacho spyder"] = "SECRET", ["rarity naughty naughty"] = "SECRET", ["rarity noo candy"] = "SECRET",
    ["rarity noo eggs"] = "SECRET", ["rarity noo examen"] = "SECRET", ["rarity noo gold"] = "SECRET", ["rarity noo heart"] = "SECRET", ["rarity noo la polizia"] = "BRAINROTGOD", ["rarity noo present"] = "SECRET",
    ["rarity noo resume"] = "SECRET", ["rarity noobini pizzanini"] = "COMMON", ["rarity noobini santanini"] = "COMMON", ["rarity noodle noodle poodle"] = "SECRET", ["rarity nooo hotspot"] = "SECRET",
    ["rarity nuclearo dinossauro"] = "SECRET", ["rarity octoball"] = "SECRET", ["rarity odin din din dun"] = "BRAINROTGOD", ["rarity ombrello topolino"] = "SECRET", ["rarity orangutini ananassini"] = "MYTHIC",
    ["rarity orbi mochi"] = "MYTHIC", ["rarity orcaledon"] = "SECRET", ["rarity orcalero orcala"] = "BRAINROTGOD", ["rarity orcalita orcala"] = "BRAINROTGOD", ["rarity pakrahmatmamat"] = "BRAINROTGOD",
    ["rarity pakrahmatmatina"] = "BRAINROTGOD", ["rarity pancake and syrup"] = "SECRET", ["rarity pandaccini bananini"] = "LEGENDARY", ["rarity pandanini frostini"] = "BRAINROTGOD",
    ["rarity paradiso axolottino"] = "SECRET", ["rarity patteo"] = "BRAINROTGOD", ["rarity pengolino nuvoletto"] = "RARE", ["rarity penguin tree"] = "EPIC", ["rarity penguino cocosino"] = "EPIC",
    ["rarity perochello lemonchello"] = "EPIC", ["rarity perrito burrito"] = "SECRET", ["rarity pi pi watermelon"] = "LEGENDARY", ["rarity piccione macchina"] = "BRAINROTGOD", ["rarity piccionetta macchina"] = "BRAINROTGOD",
    ["rarity pinealotto fruttarino"] = "RARE", ["rarity pineaplino"] = "BRAINROTGOD", ["rarity pipi avocado"] = "RARE", ["rarity pipi corni"] = "COMMON", ["rarity pipi kiwi"] = "COMMON",
    ["rarity pipi potato"] = "LEGENDARY", ["rarity pirulitoita bicicleteira"] = "SECRET", ["rarity pizza and ranch"] = "SECRET", ["rarity please present"] = "SECRET", ["rarity pop pop sahur"] = "BRAINROTGOD",
    ["rarity popcuru and fizzuru"] = "SECRET", ["rarity pot hotspot"] = "SECRET", ["rarity pot pumpkin"] = "SECRET", ["rarity pretzo robo"] = "BRAINROTGOD", ["rarity puffaball"] = "LEGENDARY",
    ["rarity pumpkini spyderini"] = "SECRET", ["rarity quackini snackini"] = "SECRET", ["rarity quackula"] = "LEGENDARY", ["rarity quesadilla crocodila"] = "SECRET", ["rarity quesadillo vampiro"] = "SECRET",
    ["rarity quivioli ameleonni"] = "LEGENDARY", ["rarity raccooni jandelini"] = "COMMON", ["rarity rang ring bus"] = "SECRET", ["rarity ref ref ref sahur"] = "SECRET", ["rarity reindeer tralala"] = "SECRET",
    ["rarity reinito sleighito"] = "SECRET", ["rarity rhino helicopterino"] = "MYTHIC", ["rarity rhino toasterino"] = "MYTHIC", ["rarity rico dinero"] = "SECRET", ["rarity robo grafito"] = "BRAINROTGOD",
    ["rarity rocco disco"] = "SECRET", ["rarity rocketini frostini"] = "SECRET", ["rarity rosetti tualetti"] = "SECRET", ["rarity rosey and teddy"] = "SECRET", ["rarity rubiko and kubiko"] = "SECRET",
    ["rarity rubrikiko"] = "SECRET", ["rarity salamino penguino"] = "EPIC", ["rarity sammyni cakini"] = "SECRET", ["rarity sammyni fattini"] = "SECRET", ["rarity sammyni spyderini"] = "SECRET",
    ["rarity sand sand sand"] = "SECRET", ["rarity santa hotspot"] = "SECRET", ["rarity santteo"] = "SECRET", ["rarity sealo regalo"] = "LEGENDARY", ["rarity serafinna medusella"] = "SECRET",
    ["rarity seraphino gruyero"] = "LEGENDARY", ["rarity sigma boy"] = "LEGENDARY", ["rarity sigma girl"] = "LEGENDARY", ["rarity signore carapace"] = "SECRET", ["rarity skibidi toilet"] = "OG",
    ["rarity skull skull skull"] = "BRAINROTGOD", ["rarity snailenzo"] = "BRAINROTGOD", ["rarity snailo clovero"] = "SECRET", ["rarity spaghetti tualetti"] = "SECRET", ["rarity spinny hammy"] = "SECRET",
    ["rarity spioniro golubiro"] = "MYTHIC", ["rarity spongini quackini"] = "MYTHIC", ["rarity spooky and pumpky"] = "SECRET", ["rarity spyder elephant"] = "OG", ["rarity squalanana"] = "BRAINROTGOD",
    ["rarity steakini fattini"] = "SECRET", ["rarity stoppo luminino"] = "MYTHIC", ["rarity strawberrelli flamingelli"] = "LEGENDARY", ["rarity strawberrita"] = "SECRET", ["rarity strawberry elephant"] = "OG",
    ["rarity sundrilla sundae"] = "BRAINROTGOD", ["rarity sushi inu"] = "SECRET", ["rarity svinina bombardino"] = "COMMON", ["rarity swag soda"] = "SECRET", ["rarity swaggy bros"] = "SECRET",
    ["rarity ta ta ta ta sahur"] = "RARE", ["rarity tacorillo crocodillo"] = "SECRET", ["rarity tacorita bicicleta"] = "SECRET", ["rarity talpa di fero"] = "COMMON", ["rarity tang tang keletang"] = "SECRET",
    ["rarity tartaragno"] = "COMMON", ["rarity tartaruga cisterna"] = "BRAINROTGOD", ["rarity te te te sahur"] = "MYTHIC", ["rarity telemorte"] = "SECRET", ["rarity tenini ballini"] = "BRAINROTGOD",
    ["rarity tentacolo tecnico"] = "BRAINROTGOD", ["rarity ti ti ti sahur"] = "EPIC", ["rarity tictac sahur"] = "SECRET", ["rarity tigrilini watermelini"] = "MYTHIC", ["rarity tigroligre frutonni"] = "BRAINROTGOD",
    ["rarity tim cheese"] = "COMMON", ["rarity tipi topi taco"] = "BRAINROTGOD", ["rarity tirilikalika tirilikalako"] = "SECRET", ["rarity to to to sahur"] = "SECRET", ["rarity tob tobi tobi"] = "MYTHIC",
    ["rarity toiletto focaccino"] = "MYTHIC", ["rarity tootini shrimpini"] = "BRAINROTGOD", ["rarity toro espanolo"] = "SECRET", ["rarity torrtuginni dragonfrutini"] = "SECRET", ["rarity tortuginni sandcastlini"] = "BRAINROTGOD",
    ["rarity tracoducotulu delapeladustuz"] = "MYTHIC", ["rarity tractoro dinosauro"] = "BRAINROTGOD", ["rarity tralaledon"] = "SECRET", ["rarity tralalero tralala"] = "BRAINROTGOD",
    ["rarity tralalita tralala"] = "BRAINROTGOD", ["rarity tree tree tree sahur"] = "MYTHIC", ["rarity trenostruzzo turbo 3000"] = "BRAINROTGOD", ["rarity trenostruzzo turbo 4000"] = "SECRET",
    ["rarity trenotubo axolotrico 9000"] = "BRAINROTGOD", ["rarity tric trac baraboom"] = "RARE", ["rarity trickolino"] = "SECRET", ["rarity triplito tralaleritos"] = "SECRET", ["rarity trippi troppi"] = "RARE",
    ["rarity trippi troppi troppa trippa"] = "BRAINROTGOD", ["rarity trulimero trulicina"] = "EPIC", ["rarity tuff toucan"] = "SECRET", ["rarity tukanno bananno"] = "BRAINROTGOD", ["rarity unclito samito"] = "BRAINROTGOD",
    ["rarity urubini flamenguini"] = "BRAINROTGOD", ["rarity vampira cappucina"] = "BRAINROTGOD", ["rarity var var var"] = "SECRET", ["rarity ventoliero pavonero"] = "SECRET", ["rarity venuspino"] = "SECRET",
    ["rarity vulturino skeletono"] = "SECRET", ["rarity w or l"] = "SECRET", ["rarity wombo rollo"] = "EPIC", ["rarity yess examen"] = "SECRET", ["rarity yess resume"] = "SECRET", ["rarity yeti claus"] = "BRAINROTGOD",
    ["rarity zibra zubra zibralini"] = "MYTHIC", ["rarity zombie tralala"] = "SECRET", ["ref ref ref sahur come from"] = "SOCCERBOARD", ["ref ref ref sahur rarity"] = "SECRET", ["ref ref ref sahur source"] = "SOCCERBOARD",
    ["reindeer tralala come from"] = "CHRISTMAS", ["reindeer tralala rarity"] = "SECRET", ["reindeer tralala source"] = "CHRISTMAS", ["reinito sleighito rarity"] = "SECRET", ["release date"] = "MAY",
    ["release day"] = "15", ["replaced craft machine"] = "WITCHSFUSE", ["replaced fuse machine"] = "FIRSTCRAFTMACHINE", ["reworked trait"] = "TACO", ["rhino helicopterino come from"] = "FIRSTCRAFTMACHINE",
    ["rhino helicopterino rarity"] = "MYTHIC", ["rhino helicopterino source"] = "FIRSTCRAFTMACHINE", ["rhino toasterino rarity"] = "MYTHIC", ["rico dinero come from"] = "DLCCODE", ["rico dinero rarity"] = "SECRET",
    ["rico dinero source"] = "DLCCODE", ["ritual add"] = "JANUARY", ["ritual added"] = "JANUARY", ["rival called"] = "SCAMMYSAMMY", ["robo grafito come from"] = "BACKROOMS", ["robo grafito rarity"] = "BRAINROTGOD",
    ["robo grafito source"] = "BACKROOMS", ["rocco disco come from"] = "NEWYEARS", ["rocco disco rarity"] = "SECRET", ["rocco disco source"] = "NEWYEARS", ["rocketini frostini come from"] = "SAMMYSCODE",
    ["rocketini frostini rarity"] = "SECRET", ["rocketini frostini source"] = "SAMMYSCODE", ["role"] = "CHIEFPRODUCTOFFICER", ["rosetti tualetti rarity"] = "SECRET", ["rosey and teddy rarity"] = "SECRET",
    ["rubiko and kubiko come from"] = "LOSTRADERS", ["rubiko and kubiko rarity"] = "SECRET", ["rubiko and kubiko source"] = "LOSTRADERS", ["rubrikiko come from"] = "BACKROOMS", ["rubrikiko rarity"] = "SECRET",
    ["rubrikiko source"] = "BACKROOMS", ["sab based on"] = "STEALACHARACTER", ["salamino penguino come from"] = "REDCARPET", ["salamino penguino rarity"] = "EPIC", ["salamino penguino source"] = "REDCARPET",
    ["sammyni cakini come from"] = "SABSANNIVERSARY", ["sammyni cakini rarity"] = "SECRET", ["sammyni cakini source"] = "SABSANNIVERSARY", ["sammyni fattini rarity"] = "SECRET", ["sammyni spyderini come from"] = "ADMINABUSE",
    ["sammyni spyderini rarity"] = "SECRET", ["sammyni spyderini source"] = "ADMINABUSE", ["sand sand sand rarity"] = "SECRET", ["santa hotspot rarity"] = "SECRET", ["santas fuse add"] = "DECEMBER",
    ["santas fuse added"] = "DECEMBER", ["santteo come from"] = "CHRISTMAS", ["santteo rarity"] = "SECRET", ["santteo source"] = "CHRISTMAS", ["sealo regalo come from"] = "SANTASFUSE",
    ["sealo regalo rarity"] = "LEGENDARY", ["sealo regalo source"] = "SANTASFUSE", ["secret add"] = "MAY", ["secret added"] = "MAY", ["secrets toro espanolo add"] = "JULY", ["secrets toro espanolo added"] = "JULY",
    ["serafinna medusella come from"] = "DIVINEFUSE", ["serafinna medusella rarity"] = "SECRET", ["serafinna medusella source"] = "DIVINEFUSE", ["seraphino gruyero come from"] = "DIVINEFUSE",
    ["seraphino gruyero rarity"] = "LEGENDARY", ["seraphino gruyero source"] = "DIVINEFUSE", ["sigma boy come from"] = "REDCARPET", ["sigma boy rarity"] = "LEGENDARY", ["sigma boy source"] = "REDCARPET",
    ["sigma girl come from"] = "FIRSTCRAFTMACHINE", ["sigma girl rarity"] = "LEGENDARY", ["sigma girl source"] = "FIRSTCRAFTMACHINE", ["signore carapace come from"] = "FIRSTCRAFTMACHINE",
    ["signore carapace rarity"] = "SECRET", ["signore carapace source"] = "FIRSTCRAFTMACHINE", ["skibidi toilet add"] = "DECEMBER", ["skibidi toilet added"] = "DECEMBER", ["skibidi toilet come from"] = "REDCARPET",
    ["skibidi toilet rarity"] = "OG", ["skibidi toilet source"] = "REDCARPET", ["skull skull skull come from"] = "HALLOWEEN", ["skull skull skull rarity"] = "BRAINROTGOD", ["skull skull skull source"] = "HALLOWEEN",
    ["snailenzo come from"] = "WITCHSFUSE", ["snailenzo rarity"] = "BRAINROTGOD", ["snailenzo source"] = "WITCHSFUSE", ["snailo clovero rarity"] = "SECRET", ["source 1x1x1x1"] = "CAVERITUAL",
    ["source 25"] = "ADVENTCALENDAR", ["source 4th bros"] = "ADMINABUSE", ["source abyssaloco"] = "BACKROOMS", ["source agarrini la palini"] = "FIRSTFUSEMACHINE", ["source antonio"] = "FIRSTCRAFTMACHINE",
    ["source appelini"] = "REDCARPET", ["source aquanaut"] = "REDCARPET", ["source aquarino"] = "SUMMERHOUR", ["source arcadopus"] = "TSUNAMILTM", ["source arcadragon"] = "DLCCODE",
    ["source astrolero cervalero"] = "DIVINEFUSE", ["source avocadini antilopini"] = "REDCARPET", ["source avocadini guffo"] = "REDCARPET", ["source avocadorilla"] = "FIRSTFUSEMACHINE",
    ["source bacuru and egguru"] = "OGFUSE", ["source ballerina cappuccina"] = "REDCARPET", ["source ballerino lololo"] = "REDCARPET", ["source bambini crostini"] = "REDCARPET", ["source bambu bambu sahur"] = "INDONESIA",
    ["source bananita dolphinita"] = "REDCARPET", ["source bananito"] = "REDCARPET", ["source bandito axolito"] = "CYBERCRAFT", ["source bandito bobritto"] = "REDCARPET", ["source bee loco"] = "CYBERCRAFT",
    ["source belula beluga"] = "BRAINROTTRADER", ["source berenjello angello"] = "DIVINEFUSE", ["source berryno"] = "REDCARPET", ["source bisonte giuppitere"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["source blueberrinni octopusini"] = "REDCARPET", ["source boatito auratito"] = "ADMINABUSE", ["source boba panda"] = "OGFUSE", ["source bombardini tortinii"] = "TACO", ["source bombardiro crocodilo"] = "REDCARPET",
    ["source bombardiro vaccariro"] = "SUMMERFUSE", ["source bombombini gusini"] = "REDCARPET", ["source boneca ambalabu"] = "REDCARPET", ["source boppin bunny"] = "DLCCODE", ["source brasilini berimbini"] = "ADMINABUSE",
    ["source brr brr patapim"] = "REDCARPET", ["source brr es teh patipum"] = "FIRSTFUSEMACHINE", ["source brri brri bicus dicus bombicus"] = "REDCARPET", ["source brutto gialutto"] = "FIRSTCRAFTMACHINE",
    ["source bucketoro"] = "SUMMERFUSE", ["source bufalino boomberino"] = "LIMITEDQUANTITYCRAFT", ["source buho de fuego"] = "WITCHSFUSE", ["source buho de noelo"] = "SANTASFUSE", ["source buho de volto"] = "CYBERCRAFT",
    ["source buho del cielo"] = "DIVINEFUSE", ["source bunito bunito spinito"] = "NEWYEARS", ["source bunny and eggy"] = "DIVINEFUSE", ["source bunny bunny bunny sahur"] = "EASTER",
    ["source bunnyman"] = "ADVENTCALENDAR", ["source buntteo"] = "EASTER", ["source burbaloni loliloli"] = "REDCARPET", ["source cacasito satalito"] = "REDCARPET", ["source cachorrito melonito"] = "REDCARPET",
    ["source cacto hipopotamo"] = "REDCARPET", ["source camera ramena"] = "CYBERCRAFT", ["source cangurato gelato"] = "REDCARPET", ["source capi taco"] = "TACO", ["source capitano americano"] = "LIMITEDQUANTITYCRAFT",
    ["source capitano gullini"] = "SUMMERFUSE", ["source capitano moby"] = "REDCARPET", ["source cappuccino assassino"] = "REDCARPET", ["source caramello filtrello"] = "FIRSTCRAFTMACHINE",
    ["source cash or card"] = "REDCARPET", ["source cavallo virtuoso"] = "REDCARPET", ["source caylusaurus"] = "LIMITEDQUANTITYCRAFT", ["source celularcini viciosini"] = "FIRSTCRAFTMACHINE",
    ["source centrucci nuclucci"] = "BRAINROTTRADER", ["source cerberus"] = "REDCARPET", ["source chachechi"] = "ADMINABUSE", ["source chef crabracadabra"] = "REDCARPET", ["source chicleteira bicicleteira"] = "REDCARPET",
    ["source chicleteira champeona"] = "SPAIN", ["source chicleteira noelteira"] = "SANTASFUSE", ["source chicleteira surfeiteira"] = "SUMMERHOUR", ["source chicleteirina bicicleteirina"] = "REDCARPET",
    ["source chill puppy"] = "OGFUSE", ["source chillin chili"] = "LIMITEDQUANTITYCRAFT", ["source chimpanzini bananini"] = "REDCARPET", ["source chipso and queso"] = "LIMITEDQUANTITYCRAFT",
    ["source chocco bunny"] = "SANTASFUSE", ["source cigno fulgoro"] = "DIVINEFUSE", ["source clickerino crabo"] = "BRAINROTTRADER", ["source cloverat clapat"] = "STPATRICKS", ["source coco and mango"] = "SUMMERFUSE",
    ["source cocoa assassino"] = "CHRISTMAS", ["source cocofanto elefanto"] = "REDCARPET", ["source cocosini mama"] = "FIRSTFUSEMACHINE", ["source cocoteddy"] = "SUMMERFUSE", ["source cola cat"] = "DLCCODE",
    ["source cooki and milki"] = "SANTASFUSE", ["source corn corn corn sahur"] = "PINATA", ["source cuadramat and pakrahmatmamat"] = "BRAINROTTRADER", ["source cupcake koala"] = "BRAINROTTRADER",
    ["source cupid cupid sahur"] = "CUPIDSMACHINE", ["source digi narwhal"] = "CYBERCRAFT", ["source divino platypio"] = "DIVINEFUSE", ["source dj panda"] = "REDCARPET", ["source doi doi do"] = "BRAINROTTRADER",
    ["source dolphini jetskini"] = "OGFUSE", ["source donkeyturbo express"] = "CHRISTMAS", ["source dragon aquanini"] = "SUMMERFUSE", ["source dragon cannelloni"] = "REDCARPET", ["source dragon gingerini"] = "SANTASFUSE",
    ["source dug dug dug"] = "FIRSTCRAFTMACHINE", ["source duggy bros"] = "CYBERCRAFT", ["source dul dul dul"] = "ADMINABUSE", ["source dumborino miracello"] = "DIVINEFUSE", ["source eid eid eid sahur"] = "EID",
    ["source electro quacko"] = "CYBERCRAFT", ["source elefanto frigo"] = "FIRSTCRAFTMACHINE", ["source esok goala"] = "SOCCERBOARD", ["source espresso signora"] = "ADMINABUSE", ["source eviledon"] = "WITCHSFUSE",
    ["source examen bros"] = "LOSTRADERS", ["source extinct ballerina"] = "EXTINCT", ["source extinct matteo"] = "EXTINCT", ["source extinct tralalero"] = "EXTINCT", ["source festive 67"] = "DLCCODE",
    ["source fishboard"] = "REDCARPET", ["source fishino clownino"] = "FISHING", ["source fizzy soda"] = "OGFUSE", ["source flancito"] = "SABSANNIVERSARY", ["source flipa sandala"] = "BACKROOMS",
    ["source flippo marino"] = "SUMMERFUSE", ["source fluriflura"] = "REDCARPET", ["source foxini lanternini"] = "EID", ["source fragola la la la"] = "FIRSTCRAFTMACHINE", ["source fragrama and chocrama"] = "BRAINROTTRADER",
    ["source frankentteo"] = "HALLOWEEN", ["source frigo camelo"] = "REDCARPET", ["source frio ninja"] = "WITCHSFUSE", ["source frogato pirato"] = "WITCHSFUSE", ["source frogo elfo"] = "SANTASFUSE",
    ["source frullato framingo"] = "SAMMYSCODE", ["source futbolini skatini"] = "CYBERCRAFT", ["source ganganzelli trulala"] = "FIRSTFUSEMACHINE", ["source gangster footera"] = "REDCARPET",
    ["source garama and madundung"] = "REDCARPET", ["source gato celesto"] = "DIVINEFUSE", ["source gattatino nyanino"] = "ADMINABUSE", ["source gelato lumacho"] = "SUMMERHOUR", ["source ginger cisterna"] = "SANTASFUSE",
    ["source ginger gerat"] = "SANTASMARKET", ["source ginger globo"] = "SANTASFUSE", ["source girafa celestre"] = "REDCARPET", ["source glaciator"] = "BACKROOMS", ["source globa steppa"] = "DLCCODE",
    ["source glorbo fruttodrillo"] = "REDCARPET", ["source goat"] = "ADMINABUSE", ["source gobblino uniciclino"] = "THANKSGIVING", ["source gorillo subwoofero"] = "FIRSTCRAFTMACHINE",
    ["source gorillo watermelondrillo"] = "REDCARPET", ["source grabatron"] = "DLCCODES", ["source graipuss medussi"] = "REDCARPET", ["source granchiello spiritell"] = "FISHING", ["source granny"] = "GRANNYSFUNERAL",
    ["source griffin"] = "DIVINEFUSE", ["source guest 666"] = "CAVERITUAL", ["source gym bros"] = "CYBERCRAFT", ["source harpuccino"] = "DIVINEFUSE", ["source headless horseman"] = "WITCHSFUSE",
    ["source hippo golazo"] = "SOCCERBOARD", ["source ho ho ho sahur"] = "SANTASFUSE", ["source holy arepa"] = "DIVINEFUSE", ["source horegini boom"] = "AURABOAT", ["source hydra dragon cannelloni"] = "OGFUSE",
    ["source jacko jack jack"] = "WITCHSFUSE", ["source jacko spaventosa"] = "WITCHSFUSE", ["source jelly moby"] = "SABSANNIVERSARY", ["source jingle jingle sahur"] = "SANTASFUSE", ["source job job job sahur"] = "REDCARPET",
    ["source john doe"] = "CAVERITUAL", ["source john pork"] = "REDCARPET", ["source jolly jolly sahur"] = "SANTASMARKET", ["source kalika bros"] = "CYBERCRAFT", ["source karker sahur"] = "FIRSTCRAFTMACHINE",
    ["source karkerkar kurkur"] = "ADMINABUSE", ["source ketchuru and musturu"] = "REDCARPET", ["source ketupat bros"] = "OGFUSE", ["source ketupat kepat"] = "REDCARPET", ["source krupuk pagi pagi"] = "INDONESIA",
    ["source la anniversary grande"] = "LIMITEDQUANTITYCRAFT", ["source la cucaracha"] = "ADMINABUSE", ["source la easter grande"] = "LIMITEDQUANTITYCRAFT", ["source la extinct grande"] = "EXTINCT",
    ["source la grande combinasion"] = "REDCARPET", ["source la jolly grande"] = "CHRISTMASWHEELSPIN", ["source la karkerkar combinasion"] = "FIRSTCRAFTMACHINE", ["source la lucky grande"] = "LIMITEDQUANTITYCRAFT",
    ["source la romantic grande"] = "LIMITEDQUANTITYCRAFT", ["source la sahur combinasion"] = "FIRSTCRAFTMACHINE", ["source la spooky grande"] = "LIMITEDQUANTITYCRAFT", ["source la summer grande"] = "LIMITEDQUANTITYCRAFT",
    ["source la supreme combinasion"] = "FIRSTFUSEMACHINE", ["source la taco combinasion"] = "LIMITEDQUANTITYCRAFT", ["source la vacca jacko linterino"] = "HALLOWEEN", ["source la vacca prese presente"] = "SANTASFUSE",
    ["source la vacca saturno saturnita"] = "REDCARPET", ["source las capuchinas"] = "FIRSTCRAFTMACHINE", ["source las sis"] = "FIRSTCRAFTMACHINE", ["source las tralaleritas"] = "REDCARPET",
    ["source las vaquitas saturnitas"] = "LAVACCARITUAL", ["source lavadorito spinito"] = "REDCARPET", ["source lazy ducky"] = "DLCCODE", ["source lemonita splashita"] = "SUMMERFUSE",
    ["source lerulerulerule"] = "REDCARPET", ["source lionel cactuseli"] = "REDCARPET", ["source liril laril"] = "REDCARPET", ["source list list list sahur"] = "CHRISTMAS", ["source los admins"] = "LOSTRADERS",
    ["source los bros"] = "FIRSTCRAFTMACHINE", ["source los candies"] = "SANTASFUSE", ["source los chicleteiras"] = "CHICLETEIRARITUAL", ["source los chillis"] = "CYBERCRAFT", ["source los combinasionas"] = "FIRSTFUSEMACHINE",
    ["source los cornis"] = "LOSTRADERS", ["source los crocodillitos"] = "BOMBARDIRO", ["source los cupids"] = "DIVINEFUSE", ["source los fruits"] = "SUMMERFUSE", ["source los hackers"] = "CYBERCRAFT",
    ["source los hotspotsitos"] = "FIRSTFUSEMACHINE", ["source los jolly combinasionas"] = "SANTASMARKET", ["source los karkeritos"] = "KARKERRITUAL", ["source los mariachis"] = "PINATA",
    ["source los matteos"] = "MATTEORITUAL", ["source los mi gatitos"] = "MIGATITORITUAL", ["source los mobilis"] = "WITCHSFUSE", ["source los noobinis"] = "CYBERCRAFT", ["source los orcalitos"] = "FIRSTFUSEMACHINE",
    ["source los planitos"] = "BRAINROTTRADER", ["source los primos"] = "FIRSTCRAFTMACHINE", ["source los puggies"] = "BRAINROTTRADER", ["source los secret combinasionas"] = "LOSTRADERS",
    ["source los sigmas"] = "LOSTRADERS", ["source los spaghettis"] = "BRAINROTTRADER", ["source los spyderinis"] = "SPYDERINIRITUAL", ["source los sweethearts"] = "FIRSTFUSEMACHINE",
    ["source los tacoritas"] = "FIRSTCRAFTMACHINE", ["source los tangcitos"] = "LOSTRADERS", ["source los tictacs"] = "LOSTRADERS", ["source los tralaleritos"] = "REDCARPET", ["source los trios"] = "OGFUSE",
    ["source los tungtungtungcitos"] = "FIRSTFUSEMACHINE", ["source love love bear"] = "CUPIDSMACHINE", ["source lovin rose"] = "CUPIDSMACHINE", ["source lumaca malefica"] = "BACKROOMS",
    ["source magi ribbitini"] = "WITCHSFUSE", ["source malame amarele"] = "FIRSTCRAFTMACHINE", ["source mangolini parrocini"] = "BRAINROTTRADER", ["source mariachi corazoni"] = "PINATA",
    ["source matteo"] = "ADMINABUSE", ["source meowl"] = "REDCARPET", ["source mi gatito"] = "ADMINABUSE", ["source mieteteira bicicleteira"] = "WITCHSFUSE", ["source moby bros"] = "LOSTRADERS",
    ["source money money bros"] = "CYBERCRAFT", ["source money money man"] = "BRAINROTTRADER", ["source money money puggy"] = "REDCARPET", ["source money money reindeer"] = "SANTASMARKET",
    ["source mummio rappitto"] = "WITCHSFUSE", ["source nacho spyder"] = "LIMITEDQUANTITYCRAFT", ["source naughty naughty"] = "CHRISTMAS", ["source noo candy"] = "TRICKORTREAT", ["source noo eggs"] = "EASTER",
    ["source noo examen"] = "DULDULRITUAL", ["source noo la polizia"] = "BRAINROTTRADER", ["source noo present"] = "CHRISTMAS", ["source noo resume"] = "JOBRITUAL", ["source noobini pizzanini"] = "REDCARPET",
    ["source noobini santanini"] = "SANTASFUSE", ["source noodle noodle poodle"] = "REDCARPET", ["source nooo hotspot"] = "TACO", ["source nuclearo dinossauro"] = "REDCARPET", ["source ombrello topolino"] = "SUMMERFUSE",
    ["source orangutini ananassini"] = "REDCARPET", ["source orbi mochi"] = "CYBERCRAFT", ["source orcaledon"] = "BRAINROTTRADER", ["source orcalita orcala"] = "CYBERCRAFT", ["source pakrahmatmamat"] = "REDCARPET",
    ["source pakrahmatmatina"] = "POLEGAME", ["source pancake and syrup"] = "DLCCODE", ["source pandaccini bananini"] = "REDCARPET", ["source paradiso axolottino"] = "DIVINEFUSE", ["source pengolino nuvoletto"] = "DIVINEFUSE",
    ["source penguin tree"] = "SANTASFUSE", ["source penguino cocosino"] = "SUMMERFUSE", ["source perochello lemonchello"] = "REDCARPET", ["source perrito burrito"] = "LIMITEDQUANTITYCRAFT",
    ["source pi pi watermelon"] = "SUMMERFUSE", ["source piccione macchina"] = "REDCARPET", ["source piccionetta macchina"] = "FIRSTCRAFTMACHINE", ["source pinealotto fruttarino"] = "WITCHSFUSE",
    ["source pineaplino"] = "DLCCODE", ["source pipi avocado"] = "SUMMERFUSE", ["source pipi corni"] = "SUMMERFUSE", ["source pipi kiwi"] = "REDCARPET", ["source pipi potato"] = "REDCARPET",
    ["source pirulitoita bicicleteira"] = "BRAINROTTRADER", ["source please present"] = "ADVENTCALENDAR", ["source popcuru and fizzuru"] = "OGFUSE", ["source pot pumpkin"] = "HALLOWEEN",
    ["source pretzo robo"] = "CYBERCRAFT", ["source puffaball"] = "FISHING", ["source quackini snackini"] = "EGGTOWN", ["source quackula"] = "WITCHSFUSE", ["source quesadillo vampiro"] = "LIMITEDQUANTITYCRAFT",
    ["source quivioli ameleonni"] = "REDCARPET", ["source raccooni jandelini"] = "ADMINABUSEWAR", ["source rang ring bus"] = "POLEGAME", ["source ref ref ref sahur"] = "SOCCERBOARD",
    ["source reindeer tralala"] = "CHRISTMAS", ["source rhino helicopterino"] = "FIRSTCRAFTMACHINE", ["source rico dinero"] = "DLCCODE", ["source robo grafito"] = "BACKROOMS", ["source rocco disco"] = "NEWYEARS",
    ["source rocketini frostini"] = "SAMMYSCODE", ["source rubiko and kubiko"] = "LOSTRADERS", ["source rubrikiko"] = "BACKROOMS", ["source salamino penguino"] = "REDCARPET", ["source sammyni cakini"] = "SABSANNIVERSARY",
    ["source sammyni spyderini"] = "ADMINABUSE", ["source santteo"] = "CHRISTMAS", ["source sealo regalo"] = "SANTASFUSE", ["source serafinna medusella"] = "DIVINEFUSE", ["source seraphino gruyero"] = "DIVINEFUSE",
    ["source sigma boy"] = "REDCARPET", ["source sigma girl"] = "FIRSTCRAFTMACHINE", ["source signore carapace"] = "FIRSTCRAFTMACHINE", ["source skibidi toilet"] = "REDCARPET", ["source skull skull skull"] = "HALLOWEEN",
    ["source snailenzo"] = "WITCHSFUSE", ["source spinny hammy"] = "OGFUSE", ["source spongini quackini"] = "OGFUSE", ["source spooky and pumpky"] = "WITCHSFUSE", ["source squalanana"] = "CYBERCRAFT",
    ["source steakini fattini"] = "LIMITEDQUANTITYCRAFT", ["source stoppo luminino"] = "BRAINROTTRADER", ["source strawberrelli flamingelli"] = "REDCARPET", ["source strawberry elephant"] = "REDCARPET",
    ["source sundrilla sundae"] = "SUMMERFUSE", ["source svinina bombardino"] = "REDCARPET", ["source swag soda"] = "BRAINROTTRADER", ["source swaggy bros"] = "LIMITEDQUANTITYCRAFT",
    ["source tacorillo crocodillo"] = "LIMITEDQUANTITYCRAFT", ["source tacorita bicicleta"] = "TACO", ["source talpa di fero"] = "REDCARPET", ["source tang tang keletang"] = "REDCARPET",
    ["source tartaragno"] = "WITCHSFUSE", ["source tartaruga cisterna"] = "THISISOBTAINEDFROMSAMMYSBASE", ["source te te te sahur"] = "REDCARPET", ["source tenini ballini"] = "DLCCODE",
    ["source tentacolo tecnico"] = "WITCHSFUSE", ["source ti ti ti sahur"] = "SUMMERFUSE", ["source tictac sahur"] = "REDCARPET", ["source tim cheese"] = "REDCARPET", ["source tipi topi taco"] = "TACO",
    ["source tirilikalika tirilikalako"] = "FIRSTCRAFTMACHINE", ["source to to to sahur"] = "REDCARPET", ["source tob tobi tobi"] = "FIRSTFUSEMACHINE", ["source toiletto focaccino"] = "REDCARPET",
    ["source tootini shrimpini"] = "NEWYEARS", ["source toro espanolo"] = "SPAIN", ["source tracoducotulu delapeladustuz"] = "REDCARPET", ["source tractoro dinosauro"] = "REDCARPET",
    ["source tralaledon"] = "FIRSTCRAFTMACHINE", ["source tralalero tralala"] = "REDCARPET", ["source tralalita tralala"] = "REDCARPET", ["source tree tree tree sahur"] = "SANTASFUSE",
    ["source trenostruzzo turbo 3000"] = "REDCARPET", ["source trenostruzzo turbo 4000"] = "FIRSTCRAFTMACHINE", ["source trenotubo axolotrico 9000"] = "CYBERCRAFT", ["source tric trac baraboom"] = "REDCARPET",
    ["source trippi troppi"] = "REDCARPET", ["source trippi troppi troppa trippa"] = "REDCARPET", ["source trulimero trulicina"] = "REDCARPET", ["source tuff toucan"] = "NEWYEARS", ["source tukanno bananno"] = "FIRSTFUSEMACHINE",
    ["source unclito samito"] = "ADMINABUSE", ["source urubini flamenguini"] = "ADMINABUSE", ["source vampira cappucina"] = "HALLOWEEN", ["source var var var"] = "SOCCERBOARD", ["source ventoliero pavonero"] = "REDCARPET",
    ["source venuspino"] = "SUMMERFUSE", ["source vulturino skeletono"] = "WITCHSFUSE", ["source w or l"] = "LIMITEDQUANTITYCRAFT", ["source wombo rollo"] = "REDCARPET", ["source yess examen"] = "DULDULRITUAL",
    ["source yess resume"] = "JOBRITUAL", ["source yeti claus"] = "SANTASFUSE", ["source zombie tralala"] = "HALLOWEEN", ["spaghetti tualetti rarity"] = "SECRET", ["spain add"] = "JULY",
    ["spain added"] = "JULY", ["spain event add"] = "JULY", ["spain event added"] = "JULY", ["spinny hammy come from"] = "OGFUSE", ["spinny hammy rarity"] = "SECRET", ["spinny hammy source"] = "OGFUSE",
    ["spioniro golubiro rarity"] = "MYTHIC", ["spongini quackini come from"] = "OGFUSE", ["spongini quackini rarity"] = "MYTHIC", ["spongini quackini source"] = "OGFUSE", ["spooky and pumpky come from"] = "WITCHSFUSE",
    ["spooky and pumpky rarity"] = "SECRET", ["spooky and pumpky source"] = "WITCHSFUSE", ["spyder elephant rarity"] = "OG", ["squalanana come from"] = "CYBERCRAFT", ["squalanana rarity"] = "BRAINROTGOD",
    ["squalanana source"] = "CYBERCRAFT", ["steakini fattini add"] = "MAY", ["steakini fattini added"] = "MAY", ["steakini fattini come from"] = "LIMITEDQUANTITYCRAFT", ["steakini fattini rarity"] = "SECRET",
    ["steakini fattini source"] = "LIMITEDQUANTITYCRAFT", ["stoppo luminino come from"] = "BRAINROTTRADER", ["stoppo luminino rarity"] = "MYTHIC", ["stoppo luminino source"] = "BRAINROTTRADER",
    ["strawberrelli flamingelli come from"] = "REDCARPET", ["strawberrelli flamingelli rarity"] = "LEGENDARY", ["strawberrelli flamingelli source"] = "REDCARPET", ["strawberrita add"] = "APRIL",
    ["strawberrita added"] = "APRIL", ["strawberrita rarity"] = "SECRET", ["strawberry elephant add"] = "AUGUST", ["strawberry elephant added"] = "AUGUST", ["strawberry elephant come from"] = "REDCARPET",
    ["strawberry elephant rarity"] = "OG", ["strawberry elephant source"] = "REDCARPET", ["summer fuse add"] = "MAY", ["summer fuse added"] = "MAY", ["summer lucky block add"] = "JUNE",
    ["summer lucky block added"] = "JUNE", ["sundrilla sundae come from"] = "SUMMERFUSE", ["sundrilla sundae rarity"] = "BRAINROTGOD", ["sundrilla sundae source"] = "SUMMERFUSE", ["sushi inu rarity"] = "SECRET",
    ["svinina bombardino come from"] = "REDCARPET", ["svinina bombardino rarity"] = "COMMON", ["svinina bombardino source"] = "REDCARPET", ["swag soda come from"] = "BRAINROTTRADER",
    ["swag soda rarity"] = "SECRET", ["swag soda source"] = "BRAINROTTRADER", ["swaggy bros come from"] = "LIMITEDQUANTITYCRAFT", ["swaggy bros rarity"] = "SECRET", ["swaggy bros source"] = "LIMITEDQUANTITYCRAFT",
    ["ta ta ta ta sahur rarity"] = "RARE", ["taco trait reworked add"] = "JULY", ["taco trait reworked added"] = "JULY", ["taco tuesday time"] = "6PM", ["tacorillo crocodillo come from"] = "LIMITEDQUANTITYCRAFT",
    ["tacorillo crocodillo rarity"] = "SECRET", ["tacorillo crocodillo source"] = "LIMITEDQUANTITYCRAFT", ["tacorita bicicleta come from"] = "TACO", ["tacorita bicicleta rarity"] = "SECRET",
    ["tacorita bicicleta source"] = "TACO", ["talpa di fero come from"] = "REDCARPET", ["talpa di fero rarity"] = "COMMON", ["talpa di fero source"] = "REDCARPET", ["tang tang keletang come from"] = "REDCARPET",
    ["tang tang keletang rarity"] = "SECRET", ["tang tang keletang source"] = "REDCARPET", ["tartaragno come from"] = "WITCHSFUSE", ["tartaragno rarity"] = "COMMON", ["tartaragno source"] = "WITCHSFUSE",
    ["tartaruga cisterna come from"] = "THISISOBTAINEDFROMSAMMYSBASE", ["tartaruga cisterna rarity"] = "BRAINROTGOD", ["tartaruga cisterna source"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["te te te sahur come from"] = "REDCARPET", ["te te te sahur rarity"] = "MYTHIC", ["te te te sahur source"] = "REDCARPET", ["telemorte rarity"] = "SECRET", ["tenini ballini come from"] = "DLCCODE",
    ["tenini ballini rarity"] = "BRAINROTGOD", ["tenini ballini source"] = "DLCCODE", ["tentacolo tecnico come from"] = "WITCHSFUSE", ["tentacolo tecnico rarity"] = "BRAINROTGOD", ["tentacolo tecnico source"] = "WITCHSFUSE",
    ["this next update add"] = "OCTOBER", ["this next update added"] = "OCTOBER", ["this update"] = "SPOOKYSCARYSKELETONS", ["ti ti ti sahur come from"] = "SUMMERFUSE", ["ti ti ti sahur rarity"] = "EPIC",
    ["ti ti ti sahur source"] = "SUMMERFUSE", ["tictac sahur come from"] = "REDCARPET", ["tictac sahur rarity"] = "SECRET", ["tictac sahur source"] = "REDCARPET", ["tigrilini watermelini rarity"] = "MYTHIC",
    ["tigroligre frutonni rarity"] = "BRAINROTGOD", ["tim cheese come from"] = "REDCARPET", ["tim cheese rarity"] = "COMMON", ["tim cheese source"] = "REDCARPET", ["time admin abuse"] = "3PM",
    ["time taco tuesday"] = "6PM", ["time update"] = "3PM", ["time updates"] = "3PM", ["tipi topi taco come from"] = "TACO", ["tipi topi taco rarity"] = "BRAINROTGOD", ["tipi topi taco source"] = "TACO",
    ["tirilikalika tirilikalako come from"] = "FIRSTCRAFTMACHINE", ["tirilikalika tirilikalako rarity"] = "SECRET", ["tirilikalika tirilikalako source"] = "FIRSTCRAFTMACHINE", ["to to to sahur come from"] = "REDCARPET",
    ["to to to sahur rarity"] = "SECRET", ["to to to sahur source"] = "REDCARPET", ["tob tobi tobi come from"] = "FIRSTFUSEMACHINE", ["tob tobi tobi rarity"] = "MYTHIC", ["tob tobi tobi source"] = "FIRSTFUSEMACHINE",
    ["toiletto focaccino come from"] = "REDCARPET", ["toiletto focaccino rarity"] = "MYTHIC", ["toiletto focaccino source"] = "REDCARPET", ["tootini shrimpini come from"] = "NEWYEARS",
    ["tootini shrimpini rarity"] = "BRAINROTGOD", ["tootini shrimpini source"] = "NEWYEARS", ["toro espanolo come from"] = "SPAIN", ["toro espanolo rarity"] = "SECRET", ["toro espanolo source"] = "SPAIN",
    ["torrtuginni dragonfrutini rarity"] = "SECRET", ["tortuginni sandcastlini rarity"] = "BRAINROTGOD", ["tracoducotulu delapeladustuz come from"] = "REDCARPET", ["tracoducotulu delapeladustuz rarity"] = "MYTHIC",
    ["tracoducotulu delapeladustuz source"] = "REDCARPET", ["tractoro dinosauro come from"] = "REDCARPET", ["tractoro dinosauro rarity"] = "BRAINROTGOD", ["tractoro dinosauro source"] = "REDCARPET",
    ["trade machine add"] = "FEBRUARY", ["trade machine added"] = "FEBRUARY", ["traits add"] = "JUNE", ["traits added"] = "JUNE", ["tralaledon come from"] = "FIRSTCRAFTMACHINE", ["tralaledon rarity"] = "SECRET",
    ["tralaledon source"] = "FIRSTCRAFTMACHINE", ["tralalero tralala come from"] = "REDCARPET", ["tralalero tralala rarity"] = "BRAINROTGOD", ["tralalero tralala source"] = "REDCARPET",
    ["tralalita tralala come from"] = "REDCARPET", ["tralalita tralala rarity"] = "BRAINROTGOD", ["tralalita tralala source"] = "REDCARPET", ["tree tree tree sahur come from"] = "SANTASFUSE",
    ["tree tree tree sahur rarity"] = "MYTHIC", ["tree tree tree sahur source"] = "SANTASFUSE", ["trenostruzzo turbo 3000 come from"] = "REDCARPET", ["trenostruzzo turbo 3000 rarity"] = "BRAINROTGOD",
    ["trenostruzzo turbo 3000 source"] = "REDCARPET", ["trenostruzzo turbo 4000 come from"] = "FIRSTCRAFTMACHINE", ["trenostruzzo turbo 4000 rarity"] = "SECRET", ["trenostruzzo turbo 4000 source"] = "FIRSTCRAFTMACHINE",
    ["trenotubo axolotrico 9000 come from"] = "CYBERCRAFT", ["trenotubo axolotrico 9000 rarity"] = "BRAINROTGOD", ["trenotubo axolotrico 9000 source"] = "CYBERCRAFT", ["tric trac baraboom come from"] = "REDCARPET",
    ["tric trac baraboom rarity"] = "RARE", ["tric trac baraboom source"] = "REDCARPET", ["trickolino rarity"] = "SECRET", ["triplito tralaleritos rarity"] = "SECRET", ["trippi troppi come from"] = "REDCARPET",
    ["trippi troppi rarity"] = "RARE", ["trippi troppi source"] = "REDCARPET", ["trippi troppi troppa trippa come from"] = "REDCARPET", ["trippi troppi troppa trippa rarity"] = "BRAINROTGOD",
    ["trippi troppi troppa trippa source"] = "REDCARPET", ["trulimero trulicina come from"] = "REDCARPET", ["trulimero trulicina rarity"] = "EPIC", ["trulimero trulicina source"] = "REDCARPET",
    ["tuff toucan come from"] = "NEWYEARS", ["tuff toucan rarity"] = "SECRET", ["tuff toucan source"] = "NEWYEARS", ["tukanno bananno come from"] = "FIRSTFUSEMACHINE", ["tukanno bananno rarity"] = "BRAINROTGOD",
    ["tukanno bananno source"] = "FIRSTFUSEMACHINE", ["tung tung tung sahur add"] = "NOVEMBER", ["tung tung tung sahur added"] = "NOVEMBER", ["unclito samito come from"] = "ADMINABUSE",
    ["unclito samito rarity"] = "BRAINROTGOD", ["unclito samito source"] = "ADMINABUSE", ["update number"] = "71", ["update time"] = "3PM", ["urubini flamenguini come from"] = "ADMINABUSE",
    ["urubini flamenguini rarity"] = "BRAINROTGOD", ["urubini flamenguini source"] = "ADMINABUSE", ["vampira cappucina come from"] = "HALLOWEEN", ["vampira cappucina rarity"] = "BRAINROTGOD",
    ["vampira cappucina source"] = "HALLOWEEN", ["var var var come from"] = "SOCCERBOARD", ["var var var rarity"] = "SECRET", ["var var var source"] = "SOCCERBOARD", ["ventoliero pavonero come from"] = "REDCARPET",
    ["ventoliero pavonero rarity"] = "SECRET", ["ventoliero pavonero source"] = "REDCARPET", ["venuspino come from"] = "SUMMERFUSE", ["venuspino rarity"] = "SECRET", ["venuspino source"] = "SUMMERFUSE",
    ["vulturino skeletono come from"] = "WITCHSFUSE", ["vulturino skeletono rarity"] = "SECRET", ["vulturino skeletono source"] = "WITCHSFUSE", ["w or l come from"] = "LIMITEDQUANTITYCRAFT",
    ["w or l rarity"] = "SECRET", ["w or l source"] = "LIMITEDQUANTITYCRAFT", ["war"] = "ADMINABUSEWAR", ["war with jandel"] = "ADMINABUSEWAR", ["what 1x1x1x1 come from"] = "CAVERITUAL",
    ["what 25 come from"] = "ADVENTCALENDAR", ["what 4th bros come from"] = "ADMINABUSE", ["what abyssaloco come from"] = "BACKROOMS", ["what agarrini la palini come from"] = "FIRSTFUSEMACHINE",
    ["what antonio come from"] = "FIRSTCRAFTMACHINE", ["what appelini come from"] = "REDCARPET", ["what aquanaut come from"] = "REDCARPET", ["what aquarino come from"] = "SUMMERHOUR",
    ["what arcadopus come from"] = "TSUNAMILTM", ["what arcadragon come from"] = "DLCCODE", ["what astrolero cervalero come from"] = "DIVINEFUSE", ["what avocadini antilopini come from"] = "REDCARPET",
    ["what avocadini guffo come from"] = "REDCARPET", ["what avocadorilla come from"] = "FIRSTFUSEMACHINE", ["what bacuru and egguru come from"] = "OGFUSE", ["what ballerina cappuccina come from"] = "REDCARPET",
    ["what ballerino lololo come from"] = "REDCARPET", ["what bambini crostini come from"] = "REDCARPET", ["what bambu bambu sahur come from"] = "INDONESIA", ["what bananita dolphinita come from"] = "REDCARPET",
    ["what bananito come from"] = "REDCARPET", ["what bandito axolito come from"] = "CYBERCRAFT", ["what bandito bobritto come from"] = "REDCARPET", ["what bee loco come from"] = "CYBERCRAFT",
    ["what belula beluga come from"] = "BRAINROTTRADER", ["what berenjello angello come from"] = "DIVINEFUSE", ["what berryno come from"] = "REDCARPET", ["what bisonte giuppitere come from"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["what blueberrinni octopusini come from"] = "REDCARPET", ["what boatito auratito come from"] = "ADMINABUSE", ["what boba panda come from"] = "OGFUSE", ["what bombardini tortinii come from"] = "TACO",
    ["what bombardiro crocodilo come from"] = "REDCARPET", ["what bombardiro vaccariro come from"] = "SUMMERFUSE", ["what bombombini gusini come from"] = "REDCARPET", ["what boneca ambalabu come from"] = "REDCARPET",
    ["what boppin bunny come from"] = "DLCCODE", ["what brasilini berimbini come from"] = "ADMINABUSE", ["what brr brr patapim come from"] = "REDCARPET", ["what brr es teh patipum come from"] = "FIRSTFUSEMACHINE",
    ["what brri brri bicus dicus bombicus come from"] = "REDCARPET", ["what brutto gialutto come from"] = "FIRSTCRAFTMACHINE", ["what bucketoro come from"] = "SUMMERFUSE", ["what bufalino boomberino come from"] = "LIMITEDQUANTITYCRAFT",
    ["what buho de fuego come from"] = "WITCHSFUSE", ["what buho de noelo come from"] = "SANTASFUSE", ["what buho de volto come from"] = "CYBERCRAFT", ["what buho del cielo come from"] = "DIVINEFUSE",
    ["what bunito bunito spinito come from"] = "NEWYEARS", ["what bunny and eggy come from"] = "DIVINEFUSE", ["what bunny bunny bunny sahur come from"] = "EASTER", ["what bunnyman come from"] = "ADVENTCALENDAR",
    ["what buntteo come from"] = "EASTER", ["what burbaloni loliloli come from"] = "REDCARPET", ["what cacasito satalito come from"] = "REDCARPET", ["what cachorrito melonito come from"] = "REDCARPET",
    ["what cacto hipopotamo come from"] = "REDCARPET", ["what camera ramena come from"] = "CYBERCRAFT", ["what cangurato gelato come from"] = "REDCARPET", ["what capi taco come from"] = "TACO",
    ["what capitano americano come from"] = "LIMITEDQUANTITYCRAFT", ["what capitano gullini come from"] = "SUMMERFUSE", ["what capitano moby come from"] = "REDCARPET", ["what cappuccino assassino come from"] = "REDCARPET",
    ["what caramello filtrello come from"] = "FIRSTCRAFTMACHINE", ["what cash or card come from"] = "REDCARPET", ["what cavallo virtuoso come from"] = "REDCARPET", ["what caylusaurus come from"] = "LIMITEDQUANTITYCRAFT",
    ["what celularcini viciosini come from"] = "FIRSTCRAFTMACHINE", ["what centrucci nuclucci come from"] = "BRAINROTTRADER", ["what cerberus come from"] = "REDCARPET", ["what chachechi come from"] = "ADMINABUSE",
    ["what chef crabracadabra come from"] = "REDCARPET", ["what chicleteira bicicleteira come from"] = "REDCARPET", ["what chicleteira champeona come from"] = "SPAIN", ["what chicleteira noelteira come from"] = "SANTASFUSE",
    ["what chicleteira surfeiteira come from"] = "SUMMERHOUR", ["what chicleteirina bicicleteirina come from"] = "REDCARPET", ["what chill puppy come from"] = "OGFUSE", ["what chillin chili come from"] = "LIMITEDQUANTITYCRAFT",
    ["what chimpanzini bananini come from"] = "REDCARPET", ["what chipso and queso come from"] = "LIMITEDQUANTITYCRAFT", ["what chocco bunny come from"] = "SANTASFUSE", ["what cigno fulgoro come from"] = "DIVINEFUSE",
    ["what clickerino crabo come from"] = "BRAINROTTRADER", ["what cloverat clapat come from"] = "STPATRICKS", ["what coco and mango come from"] = "SUMMERFUSE", ["what cocoa assassino come from"] = "CHRISTMAS",
    ["what cocofanto elefanto come from"] = "REDCARPET", ["what cocosini mama come from"] = "FIRSTFUSEMACHINE", ["what cocoteddy come from"] = "SUMMERFUSE", ["what cola cat come from"] = "DLCCODE",
    ["what cooki and milki come from"] = "SANTASFUSE", ["what corn corn corn sahur come from"] = "PINATA", ["what cuadramat and pakrahmatmamat come from"] = "BRAINROTTRADER", ["what cupcake koala come from"] = "BRAINROTTRADER",
    ["what cupid cupid sahur come from"] = "CUPIDSMACHINE", ["what digi narwhal come from"] = "CYBERCRAFT", ["what divino platypio come from"] = "DIVINEFUSE", ["what dj panda come from"] = "REDCARPET",
    ["what doi doi do come from"] = "BRAINROTTRADER", ["what dolphini jetskini come from"] = "OGFUSE", ["what donkeyturbo express come from"] = "CHRISTMAS", ["what dragon aquanini come from"] = "SUMMERFUSE",
    ["what dragon cannelloni come from"] = "REDCARPET", ["what dragon gingerini come from"] = "SANTASFUSE", ["what dug dug dug come from"] = "FIRSTCRAFTMACHINE", ["what duggy bros come from"] = "CYBERCRAFT",
    ["what dul dul dul come from"] = "ADMINABUSE", ["what dumborino miracello come from"] = "DIVINEFUSE", ["what eid eid eid sahur come from"] = "EID", ["what electro quacko come from"] = "CYBERCRAFT",
    ["what elefanto frigo come from"] = "FIRSTCRAFTMACHINE", ["what esok goala come from"] = "SOCCERBOARD", ["what espresso signora come from"] = "ADMINABUSE", ["what eviledon come from"] = "WITCHSFUSE",
    ["what examen bros come from"] = "LOSTRADERS", ["what extinct ballerina come from"] = "EXTINCT", ["what extinct machine make"] = "LAEXTINCTGRANDE", ["what extinct matteo come from"] = "EXTINCT",
    ["what extinct tralalero come from"] = "EXTINCT", ["what festive 67 come from"] = "DLCCODE", ["what fishboard come from"] = "REDCARPET", ["what fishino clownino come from"] = "FISHING",
    ["what fizzy soda come from"] = "OGFUSE", ["what flancito come from"] = "SABSANNIVERSARY", ["what flipa sandala come from"] = "BACKROOMS", ["what flippo marino come from"] = "SUMMERFUSE",
    ["what fluriflura come from"] = "REDCARPET", ["what foxini lanternini come from"] = "EID", ["what fragola la la la come from"] = "FIRSTCRAFTMACHINE", ["what fragrama and chocrama come from"] = "BRAINROTTRADER",
    ["what frankentteo come from"] = "HALLOWEEN", ["what frigo camelo come from"] = "REDCARPET", ["what frio ninja come from"] = "WITCHSFUSE", ["what frogato pirato come from"] = "WITCHSFUSE",
    ["what frogo elfo come from"] = "SANTASFUSE", ["what frullato framingo come from"] = "SAMMYSCODE", ["what futbolini skatini come from"] = "CYBERCRAFT", ["what ganganzelli trulala come from"] = "FIRSTFUSEMACHINE",
    ["what gangster footera come from"] = "REDCARPET", ["what garama and madundung come from"] = "REDCARPET", ["what gato celesto come from"] = "DIVINEFUSE", ["what gattatino nyanino come from"] = "ADMINABUSE",
    ["what gelato lumacho come from"] = "SUMMERHOUR", ["what ginger cisterna come from"] = "SANTASFUSE", ["what ginger gerat come from"] = "SANTASMARKET", ["what ginger globo come from"] = "SANTASFUSE",
    ["what girafa celestre come from"] = "REDCARPET", ["what glaciator come from"] = "BACKROOMS", ["what globa steppa come from"] = "DLCCODE", ["what glorbo fruttodrillo come from"] = "REDCARPET",
    ["what goat come from"] = "ADMINABUSE", ["what gobblino uniciclino come from"] = "THANKSGIVING", ["what gorillo subwoofero come from"] = "FIRSTCRAFTMACHINE", ["what gorillo watermelondrillo come from"] = "REDCARPET",
    ["what grabatron come from"] = "DLCCODES", ["what graipuss medussi come from"] = "REDCARPET", ["what granchiello spiritell come from"] = "FISHING", ["what granny come from"] = "GRANNYSFUNERAL",
    ["what griffin come from"] = "DIVINEFUSE", ["what guest 666 come from"] = "CAVERITUAL", ["what gym bros come from"] = "CYBERCRAFT", ["what harpuccino come from"] = "DIVINEFUSE",
    ["what headless horseman come from"] = "WITCHSFUSE", ["what hippo golazo come from"] = "SOCCERBOARD", ["what ho ho ho sahur come from"] = "SANTASFUSE", ["what holy arepa come from"] = "DIVINEFUSE",
    ["what horegini boom come from"] = "AURABOAT", ["what hydra dragon cannelloni come from"] = "OGFUSE", ["what jacko jack jack come from"] = "WITCHSFUSE", ["what jacko spaventosa come from"] = "WITCHSFUSE",
    ["what jandel call"] = "SCAMMYSAMMY", ["what jelly moby come from"] = "SABSANNIVERSARY", ["what jingle jingle sahur come from"] = "SANTASFUSE", ["what job job job sahur come from"] = "REDCARPET",
    ["what john doe come from"] = "CAVERITUAL", ["what john pork come from"] = "REDCARPET", ["what jolly jolly sahur come from"] = "SANTASMARKET", ["what kalika bros come from"] = "CYBERCRAFT",
    ["what karker sahur come from"] = "FIRSTCRAFTMACHINE", ["what karkerkar kurkur come from"] = "ADMINABUSE", ["what ketchuru and musturu come from"] = "REDCARPET", ["what ketupat bros come from"] = "OGFUSE",
    ["what ketupat kepat come from"] = "REDCARPET", ["what krupuk pagi pagi come from"] = "INDONESIA", ["what la anniversary grande come from"] = "LIMITEDQUANTITYCRAFT", ["what la cucaracha come from"] = "ADMINABUSE",
    ["what la easter grande come from"] = "LIMITEDQUANTITYCRAFT", ["what la extinct grande come from"] = "EXTINCT", ["what la grande combinasion come from"] = "REDCARPET", ["what la jolly grande come from"] = "CHRISTMASWHEELSPIN",
    ["what la karkerkar combinasion come from"] = "FIRSTCRAFTMACHINE", ["what la lucky grande come from"] = "LIMITEDQUANTITYCRAFT", ["what la romantic grande come from"] = "LIMITEDQUANTITYCRAFT",
    ["what la sahur combinasion come from"] = "FIRSTCRAFTMACHINE", ["what la spooky grande come from"] = "LIMITEDQUANTITYCRAFT", ["what la summer grande come from"] = "LIMITEDQUANTITYCRAFT",
    ["what la supreme combinasion come from"] = "FIRSTFUSEMACHINE", ["what la taco combinasion come from"] = "LIMITEDQUANTITYCRAFT", ["what la vacca jacko linterino come from"] = "HALLOWEEN",
    ["what la vacca prese presente come from"] = "SANTASFUSE", ["what la vacca saturno saturnita come from"] = "REDCARPET", ["what las capuchinas come from"] = "FIRSTCRAFTMACHINE", ["what las sis come from"] = "FIRSTCRAFTMACHINE",
    ["what las tralaleritas come from"] = "REDCARPET", ["what las vaquitas saturnitas come from"] = "LAVACCARITUAL", ["what lavadorito spinito come from"] = "REDCARPET", ["what lazy ducky come from"] = "DLCCODE",
    ["what lemonita splashita come from"] = "SUMMERFUSE", ["what lerulerulerule come from"] = "REDCARPET", ["what lionel cactuseli come from"] = "REDCARPET", ["what liril laril come from"] = "REDCARPET",
    ["what list list list sahur come from"] = "CHRISTMAS", ["what los admins come from"] = "LOSTRADERS", ["what los bros come from"] = "FIRSTCRAFTMACHINE", ["what los candies come from"] = "SANTASFUSE",
    ["what los chicleteiras come from"] = "CHICLETEIRARITUAL", ["what los chillis come from"] = "CYBERCRAFT", ["what los combinasionas come from"] = "FIRSTFUSEMACHINE", ["what los cornis come from"] = "LOSTRADERS",
    ["what los crocodillitos come from"] = "BOMBARDIRO", ["what los cupids come from"] = "DIVINEFUSE", ["what los fruits come from"] = "SUMMERFUSE", ["what los hackers come from"] = "CYBERCRAFT",
    ["what los hotspotsitos come from"] = "FIRSTFUSEMACHINE", ["what los jolly combinasionas come from"] = "SANTASMARKET", ["what los karkeritos come from"] = "KARKERRITUAL", ["what los mariachis come from"] = "PINATA",
    ["what los matteos come from"] = "MATTEORITUAL", ["what los mi gatitos come from"] = "MIGATITORITUAL", ["what los mobilis come from"] = "WITCHSFUSE", ["what los noobinis come from"] = "CYBERCRAFT",
    ["what los orcalitos come from"] = "FIRSTFUSEMACHINE", ["what los planitos come from"] = "BRAINROTTRADER", ["what los primos come from"] = "FIRSTCRAFTMACHINE", ["what los puggies come from"] = "BRAINROTTRADER",
    ["what los secret combinasionas come from"] = "LOSTRADERS", ["what los sigmas come from"] = "LOSTRADERS", ["what los spaghettis come from"] = "BRAINROTTRADER", ["what los spyderinis come from"] = "SPYDERINIRITUAL",
    ["what los sweethearts come from"] = "FIRSTFUSEMACHINE", ["what los tacoritas come from"] = "FIRSTCRAFTMACHINE", ["what los tangcitos come from"] = "LOSTRADERS", ["what los tictacs come from"] = "LOSTRADERS",
    ["what los tralaleritos come from"] = "REDCARPET", ["what los trios come from"] = "OGFUSE", ["what los tungtungtungcitos come from"] = "FIRSTFUSEMACHINE", ["what love love bear come from"] = "CUPIDSMACHINE",
    ["what lovin rose come from"] = "CUPIDSMACHINE", ["what lumaca malefica come from"] = "BACKROOMS", ["what magi ribbitini come from"] = "WITCHSFUSE", ["what malame amarele come from"] = "FIRSTCRAFTMACHINE",
    ["what mangolini parrocini come from"] = "BRAINROTTRADER", ["what mariachi corazoni come from"] = "PINATA", ["what matteo come from"] = "ADMINABUSE", ["what meowl come from"] = "REDCARPET",
    ["what mi gatito come from"] = "ADMINABUSE", ["what mieteteira bicicleteira come from"] = "WITCHSFUSE", ["what moby bros come from"] = "LOSTRADERS", ["what money money bros come from"] = "CYBERCRAFT",
    ["what money money man come from"] = "BRAINROTTRADER", ["what money money puggy come from"] = "REDCARPET", ["what money money reindeer come from"] = "SANTASMARKET", ["what month add 1 los traders brainrot"] = "JULY",
    ["what month add 1 year anniversary"] = "MAY", ["what month add 1x1x1x1 ritual"] = "NOVEMBER", ["what month add 30x luck"] = "MAY", ["what month add admin machine"] = "FEBRUARY",
    ["what month add appelini"] = "APRIL", ["what month add backrooms"] = "MAY", ["what month add backrooms event"] = "MAY", ["what month add bananito"] = "APRIL", ["what month add berryno"] = "APRIL",
    ["what month add bloodmoon"] = "JUNE", ["what month add bloodmoon event"] = "JUNE", ["what month add bloodrot"] = "JUNE", ["what month add brainrot dealer"] = "NOVEMBER", ["what month add brainrot trader"] = "NOVEMBER",
    ["what month add brazil"] = "AUGUST", ["what month add brazil event"] = "AUGUST", ["what month add bubblegum trait"] = "JULY", ["what month add bull trait"] = "JULY", ["what month add candy"] = "JULY",
    ["what month add candy aurora"] = "JULY", ["what month add candy aurora event"] = "JULY", ["what month add cash or card"] = "APRIL", ["what month add caylusaurus"] = "JUNE", ["what month add chicleteira champeona"] = "JULY",
    ["what month add concert"] = "JANUARY", ["what month add craft machine"] = "SEPTEMBER", ["what month add crystal"] = "JULY", ["what month add crystal event"] = "JULY", ["what month add crystal slap hammer base"] = "JULY",
    ["what month add cupids machine"] = "FEBRUARY", ["what month add cursed"] = "JANUARY", ["what month add cyber"] = "APRIL", ["what month add cyber admin machine"] = "APRIL", ["what month add cyber craft machine"] = "APRIL",
    ["what month add diamond mutations"] = "MAY", ["what month add divine"] = "FEBRUARY", ["what month add divine admin machine"] = "FEBRUARY", ["what month add divine fuse"] = "MARCH",
    ["what month add duels machine"] = "JANUARY", ["what month add easter hour"] = "MARCH", ["what month add egg city"] = "APRIL", ["what month add egg hunt"] = "APRIL", ["what month add egg lucky block"] = "APRIL",
    ["what month add eid celebration"] = "MARCH", ["what month add examen bros"] = "JULY", ["what month add extinct"] = "SEPTEMBER", ["what month add festive lucky block"] = "DECEMBER",
    ["what month add fishing"] = "NOVEMBER", ["what month add fuse"] = "JANUARY", ["what month add fuse machine"] = "AUGUST", ["what month add galaxy"] = "AUGUST", ["what month add galaxy event"] = "AUGUST",
    ["what month add gold"] = "MAY", ["what month add grannys funeral"] = "MARCH", ["what month add guest 666"] = "APRIL", ["what month add halloween"] = "OCTOBER", ["what month add haunted fuse"] = "OCTOBER",
    ["what month add headless horseman base skin"] = "FEBRUARY", ["what month add heart lucky block"] = "FEBRUARY", ["what month add index"] = "DECEMBER", ["what month add indonesian"] = "OCTOBER",
    ["what month add indonesian event"] = "OCTOBER", ["what month add john pork"] = "MAY", ["what month add live match events"] = "JUNE", ["what month add los lucky blocks"] = "OCTOBER",
    ["what month add los secret combinasionas"] = "JULY", ["what month add los traders"] = "JULY", ["what month add ltm"] = "JANUARY", ["what month add lucky blocks"] = "JULY", ["what month add lucky pot"] = "MARCH",
    ["what month add meowl"] = "OCTOBER", ["what month add mexico"] = "SEPTEMBER", ["what month add mexico event"] = "SEPTEMBER", ["what month add molten"] = "JULY", ["what month add molten event"] = "JULY",
    ["what month add north pole"] = "DECEMBER", ["what month add north pole event"] = "DECEMBER", ["what month add not released yet"] = "OCTOBER", ["what month add og"] = "AUGUST", ["what month add phantom"] = "JUNE",
    ["what month add pizza"] = "JULY", ["what month add radioactive"] = "NOVEMBER", ["what month add rainbow"] = "JUNE", ["what month add rainbow machine"] = "JUNE", ["what month add ranch"] = "JULY",
    ["what month add ritual"] = "JANUARY", ["what month add santas fuse"] = "DECEMBER", ["what month add secret"] = "MAY", ["what month add secrets toro espanolo"] = "JULY", ["what month add skibidi toilet"] = "DECEMBER",
    ["what month add spain"] = "JULY", ["what month add spain event"] = "JULY", ["what month add steakini fattini"] = "MAY", ["what month add strawberrita"] = "APRIL", ["what month add strawberry elephant"] = "AUGUST",
    ["what month add summer fuse"] = "MAY", ["what month add summer lucky block"] = "JUNE", ["what month add taco trait reworked"] = "JULY", ["what month add this next update"] = "OCTOBER",
    ["what month add trade machine"] = "FEBRUARY", ["what month add traits"] = "JUNE", ["what month add tung tung tung sahur"] = "NOVEMBER", ["what month add winter hour"] = "DECEMBER",
    ["what month add witch fuse"] = "OCTOBER", ["what month add witching hour"] = "OCTOBER", ["what month add yin yang"] = "SEPTEMBER", ["what month add yin yang event"] = "SEPTEMBER",
    ["what mummio rappitto come from"] = "WITCHSFUSE", ["what nacho spyder come from"] = "LIMITEDQUANTITYCRAFT", ["what naughty naughty come from"] = "CHRISTMAS", ["what noo candy come from"] = "TRICKORTREAT",
    ["what noo eggs come from"] = "EASTER", ["what noo examen come from"] = "DULDULRITUAL", ["what noo la polizia come from"] = "BRAINROTTRADER", ["what noo present come from"] = "CHRISTMAS",
    ["what noo resume come from"] = "JOBRITUAL", ["what noobini pizzanini come from"] = "REDCARPET", ["what noobini santanini come from"] = "SANTASFUSE", ["what noodle noodle poodle come from"] = "REDCARPET",
    ["what nooo hotspot come from"] = "TACO", ["what nuclearo dinossauro come from"] = "REDCARPET", ["what ombrello topolino come from"] = "SUMMERFUSE", ["what orangutini ananassini come from"] = "REDCARPET",
    ["what orbi mochi come from"] = "CYBERCRAFT", ["what orcaledon come from"] = "BRAINROTTRADER", ["what orcalita orcala come from"] = "CYBERCRAFT", ["what pakrahmatmamat come from"] = "REDCARPET",
    ["what pakrahmatmatina come from"] = "POLEGAME", ["what pancake and syrup come from"] = "DLCCODE", ["what pandaccini bananini come from"] = "REDCARPET", ["what paradiso axolottino come from"] = "DIVINEFUSE",
    ["what pengolino nuvoletto come from"] = "DIVINEFUSE", ["what penguin tree come from"] = "SANTASFUSE", ["what penguino cocosino come from"] = "SUMMERFUSE", ["what perochello lemonchello come from"] = "REDCARPET",
    ["what perrito burrito come from"] = "LIMITEDQUANTITYCRAFT", ["what pi pi watermelon come from"] = "SUMMERFUSE", ["what piccione macchina come from"] = "REDCARPET", ["what piccionetta macchina come from"] = "FIRSTCRAFTMACHINE",
    ["what pinealotto fruttarino come from"] = "WITCHSFUSE", ["what pineaplino come from"] = "DLCCODE", ["what pipi avocado come from"] = "SUMMERFUSE", ["what pipi corni come from"] = "SUMMERFUSE",
    ["what pipi kiwi come from"] = "REDCARPET", ["what pipi potato come from"] = "REDCARPET", ["what pirulitoita bicicleteira come from"] = "BRAINROTTRADER", ["what please present come from"] = "ADVENTCALENDAR",
    ["what popcuru and fizzuru come from"] = "OGFUSE", ["what pot pumpkin come from"] = "HALLOWEEN", ["what pretzo robo come from"] = "CYBERCRAFT", ["what puffaball come from"] = "FISHING",
    ["what quackini snackini come from"] = "EGGTOWN", ["what quackula come from"] = "WITCHSFUSE", ["what quesadillo vampiro come from"] = "LIMITEDQUANTITYCRAFT", ["what quivioli ameleonni come from"] = "REDCARPET",
    ["what raccooni jandelini come from"] = "ADMINABUSEWAR", ["what rang ring bus come from"] = "POLEGAME", ["what ref ref ref sahur come from"] = "SOCCERBOARD", ["what reindeer tralala come from"] = "CHRISTMAS",
    ["what replaced craft machine"] = "WITCHSFUSE", ["what replaced fuse machine"] = "FIRSTCRAFTMACHINE", ["what rhino helicopterino come from"] = "FIRSTCRAFTMACHINE", ["what rico dinero come from"] = "DLCCODE",
    ["what robo grafito come from"] = "BACKROOMS", ["what rocco disco come from"] = "NEWYEARS", ["what rocketini frostini come from"] = "SAMMYSCODE", ["what rubiko and kubiko come from"] = "LOSTRADERS",
    ["what rubrikiko come from"] = "BACKROOMS", ["what salamino penguino come from"] = "REDCARPET", ["what sammyni cakini come from"] = "SABSANNIVERSARY", ["what sammyni spyderini come from"] = "ADMINABUSE",
    ["what santteo come from"] = "CHRISTMAS", ["what sealo regalo come from"] = "SANTASFUSE", ["what serafinna medusella come from"] = "DIVINEFUSE", ["what seraphino gruyero come from"] = "DIVINEFUSE",
    ["what sigma boy come from"] = "REDCARPET", ["what sigma girl come from"] = "FIRSTCRAFTMACHINE", ["what signore carapace come from"] = "FIRSTCRAFTMACHINE", ["what skibidi toilet come from"] = "REDCARPET",
    ["what skull skull skull come from"] = "HALLOWEEN", ["what snailenzo come from"] = "WITCHSFUSE", ["what spinny hammy come from"] = "OGFUSE", ["what spongini quackini come from"] = "OGFUSE",
    ["what spooky and pumpky come from"] = "WITCHSFUSE", ["what squalanana come from"] = "CYBERCRAFT", ["what steakini fattini come from"] = "LIMITEDQUANTITYCRAFT", ["what stoppo luminino come from"] = "BRAINROTTRADER",
    ["what strawberrelli flamingelli come from"] = "REDCARPET", ["what strawberry elephant come from"] = "REDCARPET", ["what sundrilla sundae come from"] = "SUMMERFUSE", ["what svinina bombardino come from"] = "REDCARPET",
    ["what swag soda come from"] = "BRAINROTTRADER", ["what swaggy bros come from"] = "LIMITEDQUANTITYCRAFT", ["what tacorillo crocodillo come from"] = "LIMITEDQUANTITYCRAFT", ["what tacorita bicicleta come from"] = "TACO",
    ["what talpa di fero come from"] = "REDCARPET", ["what tang tang keletang come from"] = "REDCARPET", ["what tartaragno come from"] = "WITCHSFUSE", ["what tartaruga cisterna come from"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["what te te te sahur come from"] = "REDCARPET", ["what tenini ballini come from"] = "DLCCODE", ["what tentacolo tecnico come from"] = "WITCHSFUSE", ["what ti ti ti sahur come from"] = "SUMMERFUSE",
    ["what tictac sahur come from"] = "REDCARPET", ["what tim cheese come from"] = "REDCARPET", ["what time taco tuesday"] = "6PM", ["what time update"] = "3PM", ["what tipi topi taco come from"] = "TACO",
    ["what tirilikalika tirilikalako come from"] = "FIRSTCRAFTMACHINE", ["what to to to sahur come from"] = "REDCARPET", ["what tob tobi tobi come from"] = "FIRSTFUSEMACHINE", ["what toiletto focaccino come from"] = "REDCARPET",
    ["what tootini shrimpini come from"] = "NEWYEARS", ["what toro espanolo come from"] = "SPAIN", ["what tracoducotulu delapeladustuz come from"] = "REDCARPET", ["what tractoro dinosauro come from"] = "REDCARPET",
    ["what tralaledon come from"] = "FIRSTCRAFTMACHINE", ["what tralalero tralala come from"] = "REDCARPET", ["what tralalita tralala come from"] = "REDCARPET", ["what tree tree tree sahur come from"] = "SANTASFUSE",
    ["what trenostruzzo turbo 3000 come from"] = "REDCARPET", ["what trenostruzzo turbo 4000 come from"] = "FIRSTCRAFTMACHINE", ["what trenotubo axolotrico 9000 come from"] = "CYBERCRAFT",
    ["what tric trac baraboom come from"] = "REDCARPET", ["what trippi troppi come from"] = "REDCARPET", ["what trippi troppi troppa trippa come from"] = "REDCARPET", ["what trulimero trulicina come from"] = "REDCARPET",
    ["what tuff toucan come from"] = "NEWYEARS", ["what tukanno bananno come from"] = "FIRSTFUSEMACHINE", ["what unclito samito come from"] = "ADMINABUSE", ["what urubini flamenguini come from"] = "ADMINABUSE",
    ["what vampira cappucina come from"] = "HALLOWEEN", ["what var var var come from"] = "SOCCERBOARD", ["what ventoliero pavonero come from"] = "REDCARPET", ["what venuspino come from"] = "SUMMERFUSE",
    ["what vulturino skeletono come from"] = "WITCHSFUSE", ["what w or l come from"] = "LIMITEDQUANTITYCRAFT", ["what wombo rollo come from"] = "REDCARPET", ["what yess examen come from"] = "DULDULRITUAL",
    ["what yess resume come from"] = "JOBRITUAL", ["what yeti claus come from"] = "SANTASFUSE", ["what zombie tralala come from"] = "HALLOWEEN", ["when 1 los traders brainrot add"] = "JULY",
    ["when 1 los traders brainrot added"] = "JULY", ["when 1 year anniversary add"] = "MAY", ["when 1 year anniversary added"] = "MAY", ["when 1x1x1x1 ritual add"] = "NOVEMBER", ["when 1x1x1x1 ritual added"] = "NOVEMBER",
    ["when 30x luck add"] = "MAY", ["when 30x luck added"] = "MAY", ["when add 1 los traders brainrot"] = "JULY", ["when add 1 los traders brainrot event"] = "JULY", ["when add 1 los traders brainrot mutation"] = "JULY",
    ["when add 1 year anniversary"] = "MAY", ["when add 1 year anniversary event"] = "MAY", ["when add 1 year anniversary mutation"] = "MAY", ["when add 1x1x1x1 ritual"] = "NOVEMBER",
    ["when add 1x1x1x1 ritual event"] = "NOVEMBER", ["when add 1x1x1x1 ritual mutation"] = "NOVEMBER", ["when add 30x luck"] = "MAY", ["when add 30x luck event"] = "MAY", ["when add 30x luck mutation"] = "MAY",
    ["when add admin machine"] = "FEBRUARY", ["when add admin machine event"] = "FEBRUARY", ["when add admin machine mutation"] = "FEBRUARY", ["when add appelini"] = "APRIL", ["when add appelini event"] = "APRIL",
    ["when add appelini mutation"] = "APRIL", ["when add backrooms"] = "MAY", ["when add backrooms event"] = "MAY", ["when add backrooms event event"] = "MAY", ["when add backrooms event mutation"] = "MAY",
    ["when add backrooms mutation"] = "MAY", ["when add bananito"] = "APRIL", ["when add bananito event"] = "APRIL", ["when add bananito mutation"] = "APRIL", ["when add berryno"] = "APRIL",
    ["when add berryno event"] = "APRIL", ["when add berryno mutation"] = "APRIL", ["when add bloodmoon"] = "JUNE", ["when add bloodmoon event"] = "JUNE", ["when add bloodmoon event event"] = "JUNE",
    ["when add bloodmoon event mutation"] = "JUNE", ["when add bloodmoon mutation"] = "JUNE", ["when add bloodrot"] = "JUNE", ["when add bloodrot event"] = "JUNE", ["when add bloodrot mutation"] = "JUNE",
    ["when add brainrot dealer"] = "NOVEMBER", ["when add brainrot dealer event"] = "NOVEMBER", ["when add brainrot dealer mutation"] = "NOVEMBER", ["when add brainrot trader"] = "NOVEMBER",
    ["when add brainrot trader event"] = "NOVEMBER", ["when add brainrot trader mutation"] = "NOVEMBER", ["when add brazil"] = "AUGUST", ["when add brazil event"] = "AUGUST", ["when add brazil event event"] = "AUGUST",
    ["when add brazil event mutation"] = "AUGUST", ["when add brazil mutation"] = "AUGUST", ["when add bubblegum trait"] = "JULY", ["when add bubblegum trait event"] = "JULY", ["when add bubblegum trait mutation"] = "JULY",
    ["when add bull trait"] = "JULY", ["when add bull trait event"] = "JULY", ["when add bull trait mutation"] = "JULY", ["when add candy"] = "JULY", ["when add candy aurora"] = "JULY",
    ["when add candy aurora event"] = "JULY", ["when add candy aurora event event"] = "JULY", ["when add candy aurora event mutation"] = "JULY", ["when add candy aurora mutation"] = "JULY",
    ["when add candy event"] = "JULY", ["when add candy mutation"] = "JULY", ["when add cash or card"] = "APRIL", ["when add cash or card event"] = "APRIL", ["when add cash or card mutation"] = "APRIL",
    ["when add caylusaurus"] = "JUNE", ["when add caylusaurus event"] = "JUNE", ["when add caylusaurus mutation"] = "JUNE", ["when add chicleteira champeona"] = "JULY", ["when add chicleteira champeona event"] = "JULY",
    ["when add chicleteira champeona mutation"] = "JULY", ["when add concert"] = "JANUARY", ["when add concert event"] = "JANUARY", ["when add concert mutation"] = "JANUARY", ["when add craft machine"] = "SEPTEMBER",
    ["when add craft machine event"] = "SEPTEMBER", ["when add craft machine mutation"] = "SEPTEMBER", ["when add crystal"] = "JULY", ["when add crystal event"] = "JULY", ["when add crystal event event"] = "JULY",
    ["when add crystal event mutation"] = "JULY", ["when add crystal mutation"] = "JULY", ["when add crystal slap hammer base"] = "JULY", ["when add crystal slap hammer base event"] = "JULY",
    ["when add crystal slap hammer base mutation"] = "JULY", ["when add cupids machine"] = "FEBRUARY", ["when add cupids machine event"] = "FEBRUARY", ["when add cupids machine mutation"] = "FEBRUARY",
    ["when add cursed"] = "JANUARY", ["when add cursed event"] = "JANUARY", ["when add cursed mutation"] = "JANUARY", ["when add cyber"] = "APRIL", ["when add cyber admin machine"] = "APRIL",
    ["when add cyber admin machine event"] = "APRIL", ["when add cyber admin machine mutation"] = "APRIL", ["when add cyber craft machine"] = "APRIL", ["when add cyber craft machine event"] = "APRIL",
    ["when add cyber craft machine mutation"] = "APRIL", ["when add cyber event"] = "APRIL", ["when add cyber mutation"] = "APRIL", ["when add diamond mutations"] = "MAY", ["when add diamond mutations event"] = "MAY",
    ["when add diamond mutations mutation"] = "MAY", ["when add divine"] = "FEBRUARY", ["when add divine admin machine"] = "FEBRUARY", ["when add divine admin machine event"] = "FEBRUARY",
    ["when add divine admin machine mutation"] = "FEBRUARY", ["when add divine event"] = "FEBRUARY", ["when add divine fuse"] = "MARCH", ["when add divine fuse event"] = "MARCH", ["when add divine fuse mutation"] = "MARCH",
    ["when add divine mutation"] = "FEBRUARY", ["when add duels machine"] = "JANUARY", ["when add duels machine event"] = "JANUARY", ["when add duels machine mutation"] = "JANUARY",
    ["when add easter hour"] = "MARCH", ["when add easter hour event"] = "MARCH", ["when add easter hour mutation"] = "MARCH", ["when add egg city"] = "APRIL", ["when add egg city event"] = "APRIL",
    ["when add egg city mutation"] = "APRIL", ["when add egg hunt"] = "APRIL", ["when add egg hunt event"] = "APRIL", ["when add egg hunt mutation"] = "APRIL", ["when add egg lucky block"] = "APRIL",
    ["when add egg lucky block event"] = "APRIL", ["when add egg lucky block mutation"] = "APRIL", ["when add eid celebration"] = "MARCH", ["when add eid celebration event"] = "MARCH",
    ["when add eid celebration mutation"] = "MARCH", ["when add examen bros"] = "JULY", ["when add examen bros event"] = "JULY", ["when add examen bros mutation"] = "JULY", ["when add extinct"] = "SEPTEMBER",
    ["when add extinct event"] = "SEPTEMBER", ["when add extinct mutation"] = "SEPTEMBER", ["when add festive lucky block"] = "DECEMBER", ["when add festive lucky block event"] = "DECEMBER",
    ["when add festive lucky block mutation"] = "DECEMBER", ["when add fishing"] = "NOVEMBER", ["when add fishing event"] = "NOVEMBER", ["when add fishing mutation"] = "NOVEMBER", ["when add fuse"] = "JANUARY",
    ["when add fuse event"] = "JANUARY", ["when add fuse machine"] = "AUGUST", ["when add fuse machine event"] = "AUGUST", ["when add fuse machine mutation"] = "AUGUST", ["when add fuse mutation"] = "JANUARY",
    ["when add galaxy"] = "AUGUST", ["when add galaxy event"] = "AUGUST", ["when add galaxy event event"] = "AUGUST", ["when add galaxy event mutation"] = "AUGUST", ["when add galaxy mutation"] = "AUGUST",
    ["when add gold"] = "MAY", ["when add gold event"] = "MAY", ["when add gold mutation"] = "MAY", ["when add grannys funeral"] = "MARCH", ["when add grannys funeral event"] = "MARCH",
    ["when add grannys funeral mutation"] = "MARCH", ["when add guest 666"] = "APRIL", ["when add guest 666 event"] = "APRIL", ["when add guest 666 mutation"] = "APRIL", ["when add halloween"] = "OCTOBER",
    ["when add halloween event"] = "OCTOBER", ["when add halloween mutation"] = "OCTOBER", ["when add haunted fuse"] = "OCTOBER", ["when add haunted fuse event"] = "OCTOBER", ["when add haunted fuse mutation"] = "OCTOBER",
    ["when add headless horseman base skin"] = "FEBRUARY", ["when add headless horseman base skin event"] = "FEBRUARY", ["when add headless horseman base skin mutation"] = "FEBRUARY",
    ["when add heart lucky block"] = "FEBRUARY", ["when add heart lucky block event"] = "FEBRUARY", ["when add heart lucky block mutation"] = "FEBRUARY", ["when add index"] = "DECEMBER",
    ["when add index event"] = "DECEMBER", ["when add index mutation"] = "DECEMBER", ["when add indonesian"] = "OCTOBER", ["when add indonesian event"] = "OCTOBER", ["when add indonesian event event"] = "OCTOBER",
    ["when add indonesian event mutation"] = "OCTOBER", ["when add indonesian mutation"] = "OCTOBER", ["when add john pork"] = "MAY", ["when add john pork event"] = "MAY", ["when add john pork mutation"] = "MAY",
    ["when add live match events"] = "JUNE", ["when add live match events event"] = "JUNE", ["when add live match events mutation"] = "JUNE", ["when add los lucky blocks"] = "OCTOBER",
    ["when add los lucky blocks event"] = "OCTOBER", ["when add los lucky blocks mutation"] = "OCTOBER", ["when add los secret combinasionas"] = "JULY", ["when add los secret combinasionas event"] = "JULY",
    ["when add los secret combinasionas mutation"] = "JULY", ["when add los traders"] = "JULY", ["when add los traders event"] = "JULY", ["when add los traders mutation"] = "JULY", ["when add ltm"] = "JANUARY",
    ["when add ltm event"] = "JANUARY", ["when add ltm mutation"] = "JANUARY", ["when add lucky blocks"] = "JULY", ["when add lucky blocks event"] = "JULY", ["when add lucky blocks mutation"] = "JULY",
    ["when add lucky pot"] = "MARCH", ["when add lucky pot event"] = "MARCH", ["when add lucky pot mutation"] = "MARCH", ["when add meowl"] = "OCTOBER", ["when add meowl event"] = "OCTOBER",
    ["when add meowl mutation"] = "OCTOBER", ["when add mexico"] = "SEPTEMBER", ["when add mexico event"] = "SEPTEMBER", ["when add mexico event event"] = "SEPTEMBER", ["when add mexico event mutation"] = "SEPTEMBER",
    ["when add mexico mutation"] = "SEPTEMBER", ["when add molten"] = "JULY", ["when add molten event"] = "JULY", ["when add molten event event"] = "JULY", ["when add molten event mutation"] = "JULY",
    ["when add molten mutation"] = "JULY", ["when add north pole"] = "DECEMBER", ["when add north pole event"] = "DECEMBER", ["when add north pole event event"] = "DECEMBER", ["when add north pole event mutation"] = "DECEMBER",
    ["when add north pole mutation"] = "DECEMBER", ["when add not released yet"] = "OCTOBER", ["when add not released yet event"] = "OCTOBER", ["when add not released yet mutation"] = "OCTOBER",
    ["when add og"] = "AUGUST", ["when add og event"] = "AUGUST", ["when add og mutation"] = "AUGUST", ["when add phantom"] = "JUNE", ["when add phantom event"] = "JUNE", ["when add phantom mutation"] = "JUNE",
    ["when add pizza"] = "JULY", ["when add pizza event"] = "JULY", ["when add pizza mutation"] = "JULY", ["when add radioactive"] = "NOVEMBER", ["when add radioactive event"] = "NOVEMBER",
    ["when add radioactive mutation"] = "NOVEMBER", ["when add rainbow"] = "JUNE", ["when add rainbow event"] = "JUNE", ["when add rainbow machine"] = "JUNE", ["when add rainbow machine event"] = "JUNE",
    ["when add rainbow machine mutation"] = "JUNE", ["when add rainbow mutation"] = "JUNE", ["when add ranch"] = "JULY", ["when add ranch event"] = "JULY", ["when add ranch mutation"] = "JULY",
    ["when add ritual"] = "JANUARY", ["when add ritual event"] = "JANUARY", ["when add ritual mutation"] = "JANUARY", ["when add santas fuse"] = "DECEMBER", ["when add santas fuse event"] = "DECEMBER",
    ["when add santas fuse mutation"] = "DECEMBER", ["when add secret"] = "MAY", ["when add secret event"] = "MAY", ["when add secret mutation"] = "MAY", ["when add secrets toro espanolo"] = "JULY",
    ["when add secrets toro espanolo event"] = "JULY", ["when add secrets toro espanolo mutation"] = "JULY", ["when add skibidi toilet"] = "DECEMBER", ["when add skibidi toilet event"] = "DECEMBER",
    ["when add skibidi toilet mutation"] = "DECEMBER", ["when add spain"] = "JULY", ["when add spain event"] = "JULY", ["when add spain event event"] = "JULY", ["when add spain event mutation"] = "JULY",
    ["when add spain mutation"] = "JULY", ["when add steakini fattini"] = "MAY", ["when add steakini fattini event"] = "MAY", ["when add steakini fattini mutation"] = "MAY", ["when add strawberrita"] = "APRIL",
    ["when add strawberrita event"] = "APRIL", ["when add strawberrita mutation"] = "APRIL", ["when add strawberry elephant"] = "AUGUST", ["when add strawberry elephant event"] = "AUGUST",
    ["when add strawberry elephant mutation"] = "AUGUST", ["when add summer fuse"] = "MAY", ["when add summer fuse event"] = "MAY", ["when add summer fuse mutation"] = "MAY", ["when add summer lucky block"] = "JUNE",
    ["when add summer lucky block event"] = "JUNE", ["when add summer lucky block mutation"] = "JUNE", ["when add taco trait reworked"] = "JULY", ["when add taco trait reworked event"] = "JULY",
    ["when add taco trait reworked mutation"] = "JULY", ["when add this next update"] = "OCTOBER", ["when add this next update event"] = "OCTOBER", ["when add this next update mutation"] = "OCTOBER",
    ["when add trade machine"] = "FEBRUARY", ["when add trade machine event"] = "FEBRUARY", ["when add trade machine mutation"] = "FEBRUARY", ["when add traits"] = "JUNE", ["when add traits event"] = "JUNE",
    ["when add traits mutation"] = "JUNE", ["when add tung tung tung sahur"] = "NOVEMBER", ["when add tung tung tung sahur event"] = "NOVEMBER", ["when add tung tung tung sahur mutation"] = "NOVEMBER",
    ["when add winter hour"] = "DECEMBER", ["when add winter hour event"] = "DECEMBER", ["when add winter hour mutation"] = "DECEMBER", ["when add witch fuse"] = "OCTOBER", ["when add witch fuse event"] = "OCTOBER",
    ["when add witch fuse mutation"] = "OCTOBER", ["when add witching hour"] = "OCTOBER", ["when add witching hour event"] = "OCTOBER", ["when add witching hour mutation"] = "OCTOBER",
    ["when add yin yang"] = "SEPTEMBER", ["when add yin yang event"] = "SEPTEMBER", ["when add yin yang event event"] = "SEPTEMBER", ["when add yin yang event mutation"] = "SEPTEMBER",
    ["when add yin yang mutation"] = "SEPTEMBER", ["when admin machine add"] = "FEBRUARY", ["when admin machine added"] = "FEBRUARY", ["when appelini add"] = "APRIL", ["when appelini added"] = "APRIL",
    ["when backrooms add"] = "MAY", ["when backrooms added"] = "MAY", ["when backrooms event add"] = "MAY", ["when backrooms event added"] = "MAY", ["when bananito add"] = "APRIL", ["when bananito added"] = "APRIL",
    ["when berryno add"] = "APRIL", ["when berryno added"] = "APRIL", ["when bloodmoon add"] = "JUNE", ["when bloodmoon added"] = "JUNE", ["when bloodmoon event add"] = "JUNE", ["when bloodmoon event added"] = "JUNE",
    ["when bloodrot add"] = "JUNE", ["when bloodrot added"] = "JUNE", ["when brainrot dealer add"] = "NOVEMBER", ["when brainrot dealer added"] = "NOVEMBER", ["when brainrot trader add"] = "NOVEMBER",
    ["when brainrot trader added"] = "NOVEMBER", ["when brazil add"] = "AUGUST", ["when brazil added"] = "AUGUST", ["when brazil event add"] = "AUGUST", ["when brazil event added"] = "AUGUST",
    ["when bubblegum trait add"] = "JULY", ["when bubblegum trait added"] = "JULY", ["when bull trait add"] = "JULY", ["when bull trait added"] = "JULY", ["when candy add"] = "JULY",
    ["when candy added"] = "JULY", ["when candy aurora add"] = "JULY", ["when candy aurora added"] = "JULY", ["when candy aurora event add"] = "JULY", ["when candy aurora event added"] = "JULY",
    ["when cash or card add"] = "APRIL", ["when cash or card added"] = "APRIL", ["when caylusaurus add"] = "JUNE", ["when caylusaurus added"] = "JUNE", ["when chicleteira champeona add"] = "JULY",
    ["when chicleteira champeona added"] = "JULY", ["when concert add"] = "JANUARY", ["when concert added"] = "JANUARY", ["when craft machine add"] = "SEPTEMBER", ["when craft machine added"] = "SEPTEMBER",
    ["when crystal add"] = "JULY", ["when crystal added"] = "JULY", ["when crystal event add"] = "JULY", ["when crystal event added"] = "JULY", ["when crystal slap hammer base add"] = "JULY",
    ["when crystal slap hammer base added"] = "JULY", ["when cupids machine add"] = "FEBRUARY", ["when cupids machine added"] = "FEBRUARY", ["when cursed add"] = "JANUARY", ["when cursed added"] = "JANUARY",
    ["when cyber add"] = "APRIL", ["when cyber added"] = "APRIL", ["when cyber admin machine add"] = "APRIL", ["when cyber admin machine added"] = "APRIL", ["when cyber craft machine add"] = "APRIL",
    ["when cyber craft machine added"] = "APRIL", ["when diamond mutations add"] = "MAY", ["when diamond mutations added"] = "MAY", ["when divine add"] = "FEBRUARY", ["when divine added"] = "FEBRUARY",
    ["when divine admin machine add"] = "FEBRUARY", ["when divine admin machine added"] = "FEBRUARY", ["when divine fuse add"] = "MARCH", ["when divine fuse added"] = "MARCH", ["when duels machine add"] = "JANUARY",
    ["when duels machine added"] = "JANUARY", ["when easter hour add"] = "MARCH", ["when easter hour added"] = "MARCH", ["when egg city add"] = "APRIL", ["when egg city added"] = "APRIL",
    ["when egg hunt add"] = "APRIL", ["when egg hunt added"] = "APRIL", ["when egg lucky block add"] = "APRIL", ["when egg lucky block added"] = "APRIL", ["when eid celebration add"] = "MARCH",
    ["when eid celebration added"] = "MARCH", ["when examen bros add"] = "JULY", ["when examen bros added"] = "JULY", ["when extinct add"] = "SEPTEMBER", ["when extinct added"] = "SEPTEMBER",
    ["when festive lucky block add"] = "DECEMBER", ["when festive lucky block added"] = "DECEMBER", ["when fishing add"] = "NOVEMBER", ["when fishing added"] = "NOVEMBER", ["when fuse add"] = "JANUARY",
    ["when fuse added"] = "JANUARY", ["when fuse machine add"] = "AUGUST", ["when fuse machine added"] = "AUGUST", ["when galaxy add"] = "AUGUST", ["when galaxy added"] = "AUGUST", ["when galaxy event add"] = "AUGUST",
    ["when galaxy event added"] = "AUGUST", ["when gold add"] = "MAY", ["when gold added"] = "MAY", ["when grannys funeral add"] = "MARCH", ["when grannys funeral added"] = "MARCH",
    ["when group created"] = "APRIL", ["when group made"] = "APRIL", ["when guest 666 add"] = "APRIL", ["when guest 666 added"] = "APRIL", ["when halloween add"] = "OCTOBER", ["when halloween added"] = "OCTOBER",
    ["when haunted fuse add"] = "OCTOBER", ["when haunted fuse added"] = "OCTOBER", ["when headless horseman base skin add"] = "FEBRUARY", ["when headless horseman base skin added"] = "FEBRUARY",
    ["when heart lucky block add"] = "FEBRUARY", ["when heart lucky block added"] = "FEBRUARY", ["when index add"] = "DECEMBER", ["when index added"] = "DECEMBER", ["when indonesian add"] = "OCTOBER",
    ["when indonesian added"] = "OCTOBER", ["when indonesian event add"] = "OCTOBER", ["when indonesian event added"] = "OCTOBER", ["when john pork add"] = "MAY", ["when john pork added"] = "MAY",
    ["when live match events add"] = "JUNE", ["when live match events added"] = "JUNE", ["when los lucky blocks add"] = "OCTOBER", ["when los lucky blocks added"] = "OCTOBER", ["when los secret combinasionas add"] = "JULY",
    ["when los secret combinasionas added"] = "JULY", ["when los traders add"] = "JULY", ["when los traders added"] = "JULY", ["when ltm add"] = "JANUARY", ["when ltm added"] = "JANUARY",
    ["when lucky blocks add"] = "JULY", ["when lucky blocks added"] = "JULY", ["when lucky pot add"] = "MARCH", ["when lucky pot added"] = "MARCH", ["when meowl add"] = "OCTOBER", ["when meowl added"] = "OCTOBER",
    ["when mexico add"] = "SEPTEMBER", ["when mexico added"] = "SEPTEMBER", ["when mexico event add"] = "SEPTEMBER", ["when mexico event added"] = "SEPTEMBER", ["when molten add"] = "JULY",
    ["when molten added"] = "JULY", ["when molten event add"] = "JULY", ["when molten event added"] = "JULY", ["when north pole add"] = "DECEMBER", ["when north pole added"] = "DECEMBER",
    ["when north pole event add"] = "DECEMBER", ["when north pole event added"] = "DECEMBER", ["when not released yet add"] = "OCTOBER", ["when not released yet added"] = "OCTOBER",
    ["when og add"] = "AUGUST", ["when og added"] = "AUGUST", ["when phantom add"] = "JUNE", ["when phantom added"] = "JUNE", ["when pizza add"] = "JULY", ["when pizza added"] = "JULY",
    ["when radioactive add"] = "NOVEMBER", ["when radioactive added"] = "NOVEMBER", ["when rainbow add"] = "JUNE", ["when rainbow added"] = "JUNE", ["when rainbow machine add"] = "JUNE",
    ["when rainbow machine added"] = "JUNE", ["when ranch add"] = "JULY", ["when ranch added"] = "JULY", ["when ritual add"] = "JANUARY", ["when ritual added"] = "JANUARY", ["when santas fuse add"] = "DECEMBER",
    ["when santas fuse added"] = "DECEMBER", ["when secret add"] = "MAY", ["when secret added"] = "MAY", ["when secrets toro espanolo add"] = "JULY", ["when secrets toro espanolo added"] = "JULY",
    ["when skibidi toilet add"] = "DECEMBER", ["when skibidi toilet added"] = "DECEMBER", ["when spain add"] = "JULY", ["when spain added"] = "JULY", ["when spain event add"] = "JULY",
    ["when spain event added"] = "JULY", ["when steakini fattini add"] = "MAY", ["when steakini fattini added"] = "MAY", ["when strawberrita add"] = "APRIL", ["when strawberrita added"] = "APRIL",
    ["when strawberry elephant add"] = "AUGUST", ["when strawberry elephant added"] = "AUGUST", ["when summer fuse add"] = "MAY", ["when summer fuse added"] = "MAY", ["when summer lucky block add"] = "JUNE",
    ["when summer lucky block added"] = "JUNE", ["when taco trait reworked add"] = "JULY", ["when taco trait reworked added"] = "JULY", ["when this next update add"] = "OCTOBER", ["when this next update added"] = "OCTOBER",
    ["when trade machine add"] = "FEBRUARY", ["when trade machine added"] = "FEBRUARY", ["when traits add"] = "JUNE", ["when traits added"] = "JUNE", ["when tung tung tung sahur add"] = "NOVEMBER",
    ["when tung tung tung sahur added"] = "NOVEMBER", ["when winter hour add"] = "DECEMBER", ["when winter hour added"] = "DECEMBER", ["when witch fuse add"] = "OCTOBER", ["when witch fuse added"] = "OCTOBER",
    ["when witching hour add"] = "OCTOBER", ["when witching hour added"] = "OCTOBER", ["when yin yang add"] = "SEPTEMBER", ["when yin yang added"] = "SEPTEMBER", ["when yin yang event add"] = "SEPTEMBER",
    ["when yin yang event added"] = "SEPTEMBER", ["where 1x1x1x1 come from"] = "CAVERITUAL", ["where 1x1x1x1 from"] = "CAVERITUAL", ["where 25 come from"] = "ADVENTCALENDAR", ["where 25 from"] = "ADVENTCALENDAR",
    ["where 4th bros come from"] = "ADMINABUSE", ["where 4th bros from"] = "ADMINABUSE", ["where abyssaloco come from"] = "BACKROOMS", ["where abyssaloco from"] = "BACKROOMS", ["where agarrini la palini come from"] = "FIRSTFUSEMACHINE",
    ["where agarrini la palini from"] = "FIRSTFUSEMACHINE", ["where antonio come from"] = "FIRSTCRAFTMACHINE", ["where antonio from"] = "FIRSTCRAFTMACHINE", ["where appelini come from"] = "REDCARPET",
    ["where appelini from"] = "REDCARPET", ["where aquanaut come from"] = "REDCARPET", ["where aquanaut from"] = "REDCARPET", ["where aquarino come from"] = "SUMMERHOUR", ["where aquarino from"] = "SUMMERHOUR",
    ["where arcadopus come from"] = "TSUNAMILTM", ["where arcadopus from"] = "TSUNAMILTM", ["where arcadragon come from"] = "DLCCODE", ["where arcadragon from"] = "DLCCODE", ["where astrolero cervalero come from"] = "DIVINEFUSE",
    ["where astrolero cervalero from"] = "DIVINEFUSE", ["where avocadini antilopini come from"] = "REDCARPET", ["where avocadini antilopini from"] = "REDCARPET", ["where avocadini guffo come from"] = "REDCARPET",
    ["where avocadini guffo from"] = "REDCARPET", ["where avocadorilla come from"] = "FIRSTFUSEMACHINE", ["where avocadorilla from"] = "FIRSTFUSEMACHINE", ["where bacuru and egguru come from"] = "OGFUSE",
    ["where bacuru and egguru from"] = "OGFUSE", ["where ballerina cappuccina come from"] = "REDCARPET", ["where ballerina cappuccina from"] = "REDCARPET", ["where ballerino lololo come from"] = "REDCARPET",
    ["where ballerino lololo from"] = "REDCARPET", ["where bambini crostini come from"] = "REDCARPET", ["where bambini crostini from"] = "REDCARPET", ["where bambu bambu sahur come from"] = "INDONESIA",
    ["where bambu bambu sahur from"] = "INDONESIA", ["where bananita dolphinita come from"] = "REDCARPET", ["where bananita dolphinita from"] = "REDCARPET", ["where bananito come from"] = "REDCARPET",
    ["where bananito from"] = "REDCARPET", ["where bandito axolito come from"] = "CYBERCRAFT", ["where bandito axolito from"] = "CYBERCRAFT", ["where bandito bobritto come from"] = "REDCARPET",
    ["where bandito bobritto from"] = "REDCARPET", ["where bee loco come from"] = "CYBERCRAFT", ["where bee loco from"] = "CYBERCRAFT", ["where belula beluga come from"] = "BRAINROTTRADER",
    ["where belula beluga from"] = "BRAINROTTRADER", ["where berenjello angello come from"] = "DIVINEFUSE", ["where berenjello angello from"] = "DIVINEFUSE", ["where berryno come from"] = "REDCARPET",
    ["where berryno from"] = "REDCARPET", ["where bisonte giuppitere come from"] = "THISISOBTAINEDFROMSAMMYSBASE", ["where bisonte giuppitere from"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["where blueberrinni octopusini come from"] = "REDCARPET", ["where blueberrinni octopusini from"] = "REDCARPET", ["where boatito auratito come from"] = "ADMINABUSE", ["where boatito auratito from"] = "ADMINABUSE",
    ["where boba panda come from"] = "OGFUSE", ["where boba panda from"] = "OGFUSE", ["where bombardini tortinii come from"] = "TACO", ["where bombardini tortinii from"] = "TACO", ["where bombardiro crocodilo come from"] = "REDCARPET",
    ["where bombardiro crocodilo from"] = "REDCARPET", ["where bombardiro vaccariro come from"] = "SUMMERFUSE", ["where bombardiro vaccariro from"] = "SUMMERFUSE", ["where bombombini gusini come from"] = "REDCARPET",
    ["where bombombini gusini from"] = "REDCARPET", ["where boneca ambalabu come from"] = "REDCARPET", ["where boneca ambalabu from"] = "REDCARPET", ["where boppin bunny come from"] = "DLCCODE",
    ["where boppin bunny from"] = "DLCCODE", ["where brasilini berimbini come from"] = "ADMINABUSE", ["where brasilini berimbini from"] = "ADMINABUSE", ["where brr brr patapim come from"] = "REDCARPET",
    ["where brr brr patapim from"] = "REDCARPET", ["where brr es teh patipum come from"] = "FIRSTFUSEMACHINE", ["where brr es teh patipum from"] = "FIRSTFUSEMACHINE", ["where brri brri bicus dicus bombicus come from"] = "REDCARPET",
    ["where brri brri bicus dicus bombicus from"] = "REDCARPET", ["where brutto gialutto come from"] = "FIRSTCRAFTMACHINE", ["where brutto gialutto from"] = "FIRSTCRAFTMACHINE", ["where bucketoro come from"] = "SUMMERFUSE",
    ["where bucketoro from"] = "SUMMERFUSE", ["where bufalino boomberino come from"] = "LIMITEDQUANTITYCRAFT", ["where bufalino boomberino from"] = "LIMITEDQUANTITYCRAFT", ["where buho de fuego come from"] = "WITCHSFUSE",
    ["where buho de fuego from"] = "WITCHSFUSE", ["where buho de noelo come from"] = "SANTASFUSE", ["where buho de noelo from"] = "SANTASFUSE", ["where buho de volto come from"] = "CYBERCRAFT",
    ["where buho de volto from"] = "CYBERCRAFT", ["where buho del cielo come from"] = "DIVINEFUSE", ["where buho del cielo from"] = "DIVINEFUSE", ["where bunito bunito spinito come from"] = "NEWYEARS",
    ["where bunito bunito spinito from"] = "NEWYEARS", ["where bunny and eggy come from"] = "DIVINEFUSE", ["where bunny and eggy from"] = "DIVINEFUSE", ["where bunny bunny bunny sahur come from"] = "EASTER",
    ["where bunny bunny bunny sahur from"] = "EASTER", ["where bunnyman come from"] = "ADVENTCALENDAR", ["where bunnyman from"] = "ADVENTCALENDAR", ["where buntteo come from"] = "EASTER",
    ["where buntteo from"] = "EASTER", ["where burbaloni loliloli come from"] = "REDCARPET", ["where burbaloni loliloli from"] = "REDCARPET", ["where cacasito satalito come from"] = "REDCARPET",
    ["where cacasito satalito from"] = "REDCARPET", ["where cachorrito melonito come from"] = "REDCARPET", ["where cachorrito melonito from"] = "REDCARPET", ["where cacto hipopotamo come from"] = "REDCARPET",
    ["where cacto hipopotamo from"] = "REDCARPET", ["where camera ramena come from"] = "CYBERCRAFT", ["where camera ramena from"] = "CYBERCRAFT", ["where cangurato gelato come from"] = "REDCARPET",
    ["where cangurato gelato from"] = "REDCARPET", ["where capi taco come from"] = "TACO", ["where capi taco from"] = "TACO", ["where capitano americano come from"] = "LIMITEDQUANTITYCRAFT",
    ["where capitano americano from"] = "LIMITEDQUANTITYCRAFT", ["where capitano gullini come from"] = "SUMMERFUSE", ["where capitano gullini from"] = "SUMMERFUSE", ["where capitano moby come from"] = "REDCARPET",
    ["where capitano moby from"] = "REDCARPET", ["where cappuccino assassino come from"] = "REDCARPET", ["where cappuccino assassino from"] = "REDCARPET", ["where caramello filtrello come from"] = "FIRSTCRAFTMACHINE",
    ["where caramello filtrello from"] = "FIRSTCRAFTMACHINE", ["where cash or card come from"] = "REDCARPET", ["where cash or card from"] = "REDCARPET", ["where cavallo virtuoso come from"] = "REDCARPET",
    ["where cavallo virtuoso from"] = "REDCARPET", ["where caylusaurus come from"] = "LIMITEDQUANTITYCRAFT", ["where caylusaurus from"] = "LIMITEDQUANTITYCRAFT", ["where celularcini viciosini come from"] = "FIRSTCRAFTMACHINE",
    ["where celularcini viciosini from"] = "FIRSTCRAFTMACHINE", ["where centrucci nuclucci come from"] = "BRAINROTTRADER", ["where centrucci nuclucci from"] = "BRAINROTTRADER", ["where cerberus come from"] = "REDCARPET",
    ["where cerberus from"] = "REDCARPET", ["where chachechi come from"] = "ADMINABUSE", ["where chachechi from"] = "ADMINABUSE", ["where chef crabracadabra come from"] = "REDCARPET",
    ["where chef crabracadabra from"] = "REDCARPET", ["where chicleteira bicicleteira come from"] = "REDCARPET", ["where chicleteira bicicleteira from"] = "REDCARPET", ["where chicleteira champeona come from"] = "SPAIN",
    ["where chicleteira champeona from"] = "SPAIN", ["where chicleteira noelteira come from"] = "SANTASFUSE", ["where chicleteira noelteira from"] = "SANTASFUSE", ["where chicleteira surfeiteira come from"] = "SUMMERHOUR",
    ["where chicleteira surfeiteira from"] = "SUMMERHOUR", ["where chicleteirina bicicleteirina come from"] = "REDCARPET", ["where chicleteirina bicicleteirina from"] = "REDCARPET",
    ["where chill puppy come from"] = "OGFUSE", ["where chill puppy from"] = "OGFUSE", ["where chillin chili come from"] = "LIMITEDQUANTITYCRAFT", ["where chillin chili from"] = "LIMITEDQUANTITYCRAFT",
    ["where chimpanzini bananini come from"] = "REDCARPET", ["where chimpanzini bananini from"] = "REDCARPET", ["where chipso and queso come from"] = "LIMITEDQUANTITYCRAFT", ["where chipso and queso from"] = "LIMITEDQUANTITYCRAFT",
    ["where chocco bunny come from"] = "SANTASFUSE", ["where chocco bunny from"] = "SANTASFUSE", ["where cigno fulgoro come from"] = "DIVINEFUSE", ["where cigno fulgoro from"] = "DIVINEFUSE",
    ["where clickerino crabo come from"] = "BRAINROTTRADER", ["where clickerino crabo from"] = "BRAINROTTRADER", ["where cloverat clapat come from"] = "STPATRICKS", ["where cloverat clapat from"] = "STPATRICKS",
    ["where coco and mango come from"] = "SUMMERFUSE", ["where coco and mango from"] = "SUMMERFUSE", ["where cocoa assassino come from"] = "CHRISTMAS", ["where cocoa assassino from"] = "CHRISTMAS",
    ["where cocofanto elefanto come from"] = "REDCARPET", ["where cocofanto elefanto from"] = "REDCARPET", ["where cocosini mama come from"] = "FIRSTFUSEMACHINE", ["where cocosini mama from"] = "FIRSTFUSEMACHINE",
    ["where cocoteddy come from"] = "SUMMERFUSE", ["where cocoteddy from"] = "SUMMERFUSE", ["where cola cat come from"] = "DLCCODE", ["where cola cat from"] = "DLCCODE", ["where cooki and milki come from"] = "SANTASFUSE",
    ["where cooki and milki from"] = "SANTASFUSE", ["where corn corn corn sahur come from"] = "PINATA", ["where corn corn corn sahur from"] = "PINATA", ["where cuadramat and pakrahmatmamat come from"] = "BRAINROTTRADER",
    ["where cuadramat and pakrahmatmamat from"] = "BRAINROTTRADER", ["where cupcake koala come from"] = "BRAINROTTRADER", ["where cupcake koala from"] = "BRAINROTTRADER", ["where cupid cupid sahur come from"] = "CUPIDSMACHINE",
    ["where cupid cupid sahur from"] = "CUPIDSMACHINE", ["where digi narwhal come from"] = "CYBERCRAFT", ["where digi narwhal from"] = "CYBERCRAFT", ["where divino platypio come from"] = "DIVINEFUSE",
    ["where divino platypio from"] = "DIVINEFUSE", ["where dj panda come from"] = "REDCARPET", ["where dj panda from"] = "REDCARPET", ["where doi doi do come from"] = "BRAINROTTRADER",
    ["where doi doi do from"] = "BRAINROTTRADER", ["where dolphini jetskini come from"] = "OGFUSE", ["where dolphini jetskini from"] = "OGFUSE", ["where donkeyturbo express come from"] = "CHRISTMAS",
    ["where donkeyturbo express from"] = "CHRISTMAS", ["where dragon aquanini come from"] = "SUMMERFUSE", ["where dragon aquanini from"] = "SUMMERFUSE", ["where dragon cannelloni come from"] = "REDCARPET",
    ["where dragon cannelloni from"] = "REDCARPET", ["where dragon gingerini come from"] = "SANTASFUSE", ["where dragon gingerini from"] = "SANTASFUSE", ["where dug dug dug come from"] = "FIRSTCRAFTMACHINE",
    ["where dug dug dug from"] = "FIRSTCRAFTMACHINE", ["where duggy bros come from"] = "CYBERCRAFT", ["where duggy bros from"] = "CYBERCRAFT", ["where dul dul dul come from"] = "ADMINABUSE",
    ["where dul dul dul from"] = "ADMINABUSE", ["where dumborino miracello come from"] = "DIVINEFUSE", ["where dumborino miracello from"] = "DIVINEFUSE", ["where eid eid eid sahur come from"] = "EID",
    ["where eid eid eid sahur from"] = "EID", ["where electro quacko come from"] = "CYBERCRAFT", ["where electro quacko from"] = "CYBERCRAFT", ["where elefanto frigo come from"] = "FIRSTCRAFTMACHINE",
    ["where elefanto frigo from"] = "FIRSTCRAFTMACHINE", ["where esok goala come from"] = "SOCCERBOARD", ["where esok goala from"] = "SOCCERBOARD", ["where espresso signora come from"] = "ADMINABUSE",
    ["where espresso signora from"] = "ADMINABUSE", ["where eviledon come from"] = "WITCHSFUSE", ["where eviledon from"] = "WITCHSFUSE", ["where examen bros come from"] = "LOSTRADERS",
    ["where examen bros from"] = "LOSTRADERS", ["where extinct ballerina come from"] = "EXTINCT", ["where extinct ballerina from"] = "EXTINCT", ["where extinct matteo come from"] = "EXTINCT",
    ["where extinct matteo from"] = "EXTINCT", ["where extinct tralalero come from"] = "EXTINCT", ["where extinct tralalero from"] = "EXTINCT", ["where festive 67 come from"] = "DLCCODE",
    ["where festive 67 from"] = "DLCCODE", ["where fishboard come from"] = "REDCARPET", ["where fishboard from"] = "REDCARPET", ["where fishino clownino come from"] = "FISHING", ["where fishino clownino from"] = "FISHING",
    ["where fizzy soda come from"] = "OGFUSE", ["where fizzy soda from"] = "OGFUSE", ["where flancito come from"] = "SABSANNIVERSARY", ["where flancito from"] = "SABSANNIVERSARY", ["where flipa sandala come from"] = "BACKROOMS",
    ["where flipa sandala from"] = "BACKROOMS", ["where flippo marino come from"] = "SUMMERFUSE", ["where flippo marino from"] = "SUMMERFUSE", ["where fluriflura come from"] = "REDCARPET",
    ["where fluriflura from"] = "REDCARPET", ["where foxini lanternini come from"] = "EID", ["where foxini lanternini from"] = "EID", ["where fragola la la la come from"] = "FIRSTCRAFTMACHINE",
    ["where fragola la la la from"] = "FIRSTCRAFTMACHINE", ["where fragrama and chocrama come from"] = "BRAINROTTRADER", ["where fragrama and chocrama from"] = "BRAINROTTRADER", ["where frankentteo come from"] = "HALLOWEEN",
    ["where frankentteo from"] = "HALLOWEEN", ["where frigo camelo come from"] = "REDCARPET", ["where frigo camelo from"] = "REDCARPET", ["where frio ninja come from"] = "WITCHSFUSE",
    ["where frio ninja from"] = "WITCHSFUSE", ["where frogato pirato come from"] = "WITCHSFUSE", ["where frogato pirato from"] = "WITCHSFUSE", ["where frogo elfo come from"] = "SANTASFUSE",
    ["where frogo elfo from"] = "SANTASFUSE", ["where frullato framingo come from"] = "SAMMYSCODE", ["where frullato framingo from"] = "SAMMYSCODE", ["where futbolini skatini come from"] = "CYBERCRAFT",
    ["where futbolini skatini from"] = "CYBERCRAFT", ["where ganganzelli trulala come from"] = "FIRSTFUSEMACHINE", ["where ganganzelli trulala from"] = "FIRSTFUSEMACHINE", ["where gangster footera come from"] = "REDCARPET",
    ["where gangster footera from"] = "REDCARPET", ["where garama and madundung come from"] = "REDCARPET", ["where garama and madundung from"] = "REDCARPET", ["where gato celesto come from"] = "DIVINEFUSE",
    ["where gato celesto from"] = "DIVINEFUSE", ["where gattatino nyanino come from"] = "ADMINABUSE", ["where gattatino nyanino from"] = "ADMINABUSE", ["where gelato lumacho come from"] = "SUMMERHOUR",
    ["where gelato lumacho from"] = "SUMMERHOUR", ["where get 1x1x1x1"] = "CAVERITUAL", ["where get 25"] = "ADVENTCALENDAR", ["where get 4th bros"] = "ADMINABUSE", ["where get abyssaloco"] = "BACKROOMS",
    ["where get agarrini la palini"] = "FIRSTFUSEMACHINE", ["where get antonio"] = "FIRSTCRAFTMACHINE", ["where get appelini"] = "REDCARPET", ["where get aquanaut"] = "REDCARPET", ["where get aquarino"] = "SUMMERHOUR",
    ["where get arcadopus"] = "TSUNAMILTM", ["where get arcadragon"] = "DLCCODE", ["where get astrolero cervalero"] = "DIVINEFUSE", ["where get avocadini antilopini"] = "REDCARPET",
    ["where get avocadini guffo"] = "REDCARPET", ["where get avocadorilla"] = "FIRSTFUSEMACHINE", ["where get bacuru and egguru"] = "OGFUSE", ["where get ballerina cappuccina"] = "REDCARPET",
    ["where get ballerino lololo"] = "REDCARPET", ["where get bambini crostini"] = "REDCARPET", ["where get bambu bambu sahur"] = "INDONESIA", ["where get bananita dolphinita"] = "REDCARPET",
    ["where get bananito"] = "REDCARPET", ["where get bandito axolito"] = "CYBERCRAFT", ["where get bandito bobritto"] = "REDCARPET", ["where get bee loco"] = "CYBERCRAFT", ["where get belula beluga"] = "BRAINROTTRADER",
    ["where get berenjello angello"] = "DIVINEFUSE", ["where get berryno"] = "REDCARPET", ["where get bisonte giuppitere"] = "THISISOBTAINEDFROMSAMMYSBASE", ["where get blueberrinni octopusini"] = "REDCARPET",
    ["where get boatito auratito"] = "ADMINABUSE", ["where get boba panda"] = "OGFUSE", ["where get bombardini tortinii"] = "TACO", ["where get bombardiro crocodilo"] = "REDCARPET",
    ["where get bombardiro vaccariro"] = "SUMMERFUSE", ["where get bombombini gusini"] = "REDCARPET", ["where get boneca ambalabu"] = "REDCARPET", ["where get boppin bunny"] = "DLCCODE",
    ["where get brasilini berimbini"] = "ADMINABUSE", ["where get brr brr patapim"] = "REDCARPET", ["where get brr es teh patipum"] = "FIRSTFUSEMACHINE", ["where get brri brri bicus dicus bombicus"] = "REDCARPET",
    ["where get brutto gialutto"] = "FIRSTCRAFTMACHINE", ["where get bucketoro"] = "SUMMERFUSE", ["where get bufalino boomberino"] = "LIMITEDQUANTITYCRAFT", ["where get buho de fuego"] = "WITCHSFUSE",
    ["where get buho de noelo"] = "SANTASFUSE", ["where get buho de volto"] = "CYBERCRAFT", ["where get buho del cielo"] = "DIVINEFUSE", ["where get bunito bunito spinito"] = "NEWYEARS",
    ["where get bunny and eggy"] = "DIVINEFUSE", ["where get bunny bunny bunny sahur"] = "EASTER", ["where get bunnyman"] = "ADVENTCALENDAR", ["where get buntteo"] = "EASTER", ["where get burbaloni loliloli"] = "REDCARPET",
    ["where get cacasito satalito"] = "REDCARPET", ["where get cachorrito melonito"] = "REDCARPET", ["where get cacto hipopotamo"] = "REDCARPET", ["where get camera ramena"] = "CYBERCRAFT",
    ["where get cangurato gelato"] = "REDCARPET", ["where get capi taco"] = "TACO", ["where get capitano americano"] = "LIMITEDQUANTITYCRAFT", ["where get capitano gullini"] = "SUMMERFUSE",
    ["where get capitano moby"] = "REDCARPET", ["where get cappuccino assassino"] = "REDCARPET", ["where get caramello filtrello"] = "FIRSTCRAFTMACHINE", ["where get cash or card"] = "REDCARPET",
    ["where get cavallo virtuoso"] = "REDCARPET", ["where get caylusaurus"] = "LIMITEDQUANTITYCRAFT", ["where get celularcini viciosini"] = "FIRSTCRAFTMACHINE", ["where get centrucci nuclucci"] = "BRAINROTTRADER",
    ["where get cerberus"] = "REDCARPET", ["where get chachechi"] = "ADMINABUSE", ["where get chef crabracadabra"] = "REDCARPET", ["where get chicleteira bicicleteira"] = "REDCARPET",
    ["where get chicleteira champeona"] = "SPAIN", ["where get chicleteira noelteira"] = "SANTASFUSE", ["where get chicleteira surfeiteira"] = "SUMMERHOUR", ["where get chicleteirina bicicleteirina"] = "REDCARPET",
    ["where get chill puppy"] = "OGFUSE", ["where get chillin chili"] = "LIMITEDQUANTITYCRAFT", ["where get chimpanzini bananini"] = "REDCARPET", ["where get chipso and queso"] = "LIMITEDQUANTITYCRAFT",
    ["where get chocco bunny"] = "SANTASFUSE", ["where get cigno fulgoro"] = "DIVINEFUSE", ["where get clickerino crabo"] = "BRAINROTTRADER", ["where get cloverat clapat"] = "STPATRICKS",
    ["where get coco and mango"] = "SUMMERFUSE", ["where get cocoa assassino"] = "CHRISTMAS", ["where get cocofanto elefanto"] = "REDCARPET", ["where get cocosini mama"] = "FIRSTFUSEMACHINE",
    ["where get cocoteddy"] = "SUMMERFUSE", ["where get cola cat"] = "DLCCODE", ["where get cooki and milki"] = "SANTASFUSE", ["where get corn corn corn sahur"] = "PINATA", ["where get cuadramat and pakrahmatmamat"] = "BRAINROTTRADER",
    ["where get cupcake koala"] = "BRAINROTTRADER", ["where get cupid cupid sahur"] = "CUPIDSMACHINE", ["where get digi narwhal"] = "CYBERCRAFT", ["where get divino platypio"] = "DIVINEFUSE",
    ["where get dj panda"] = "REDCARPET", ["where get doi doi do"] = "BRAINROTTRADER", ["where get dolphini jetskini"] = "OGFUSE", ["where get donkeyturbo express"] = "CHRISTMAS", ["where get dragon aquanini"] = "SUMMERFUSE",
    ["where get dragon cannelloni"] = "REDCARPET", ["where get dragon gingerini"] = "SANTASFUSE", ["where get dug dug dug"] = "FIRSTCRAFTMACHINE", ["where get duggy bros"] = "CYBERCRAFT",
    ["where get dul dul dul"] = "ADMINABUSE", ["where get dumborino miracello"] = "DIVINEFUSE", ["where get eid eid eid sahur"] = "EID", ["where get electro quacko"] = "CYBERCRAFT",
    ["where get elefanto frigo"] = "FIRSTCRAFTMACHINE", ["where get esok goala"] = "SOCCERBOARD", ["where get espresso signora"] = "ADMINABUSE", ["where get eviledon"] = "WITCHSFUSE",
    ["where get examen bros"] = "LOSTRADERS", ["where get extinct ballerina"] = "EXTINCT", ["where get extinct matteo"] = "EXTINCT", ["where get extinct tralalero"] = "EXTINCT", ["where get festive 67"] = "DLCCODE",
    ["where get fishboard"] = "REDCARPET", ["where get fishino clownino"] = "FISHING", ["where get fizzy soda"] = "OGFUSE", ["where get flancito"] = "SABSANNIVERSARY", ["where get flipa sandala"] = "BACKROOMS",
    ["where get flippo marino"] = "SUMMERFUSE", ["where get fluriflura"] = "REDCARPET", ["where get foxini lanternini"] = "EID", ["where get fragola la la la"] = "FIRSTCRAFTMACHINE",
    ["where get fragrama and chocrama"] = "BRAINROTTRADER", ["where get frankentteo"] = "HALLOWEEN", ["where get frigo camelo"] = "REDCARPET", ["where get frio ninja"] = "WITCHSFUSE",
    ["where get frogato pirato"] = "WITCHSFUSE", ["where get frogo elfo"] = "SANTASFUSE", ["where get frullato framingo"] = "SAMMYSCODE", ["where get futbolini skatini"] = "CYBERCRAFT",
    ["where get ganganzelli trulala"] = "FIRSTFUSEMACHINE", ["where get gangster footera"] = "REDCARPET", ["where get garama and madundung"] = "REDCARPET", ["where get gato celesto"] = "DIVINEFUSE",
    ["where get gattatino nyanino"] = "ADMINABUSE", ["where get gelato lumacho"] = "SUMMERHOUR", ["where get ginger cisterna"] = "SANTASFUSE", ["where get ginger gerat"] = "SANTASMARKET",
    ["where get ginger globo"] = "SANTASFUSE", ["where get girafa celestre"] = "REDCARPET", ["where get glaciator"] = "BACKROOMS", ["where get globa steppa"] = "DLCCODE", ["where get glorbo fruttodrillo"] = "REDCARPET",
    ["where get goat"] = "ADMINABUSE", ["where get gobblino uniciclino"] = "THANKSGIVING", ["where get gorillo subwoofero"] = "FIRSTCRAFTMACHINE", ["where get gorillo watermelondrillo"] = "REDCARPET",
    ["where get grabatron"] = "DLCCODES", ["where get graipuss medussi"] = "REDCARPET", ["where get granchiello spiritell"] = "FISHING", ["where get granny"] = "GRANNYSFUNERAL", ["where get griffin"] = "DIVINEFUSE",
    ["where get guest 666"] = "CAVERITUAL", ["where get gym bros"] = "CYBERCRAFT", ["where get harpuccino"] = "DIVINEFUSE", ["where get headless horseman"] = "WITCHSFUSE", ["where get hippo golazo"] = "SOCCERBOARD",
    ["where get ho ho ho sahur"] = "SANTASFUSE", ["where get holy arepa"] = "DIVINEFUSE", ["where get horegini boom"] = "AURABOAT", ["where get hydra dragon cannelloni"] = "OGFUSE",
    ["where get jacko jack jack"] = "WITCHSFUSE", ["where get jacko spaventosa"] = "WITCHSFUSE", ["where get jelly moby"] = "SABSANNIVERSARY", ["where get jingle jingle sahur"] = "SANTASFUSE",
    ["where get job job job sahur"] = "REDCARPET", ["where get john doe"] = "CAVERITUAL", ["where get john pork"] = "REDCARPET", ["where get jolly jolly sahur"] = "SANTASMARKET", ["where get kalika bros"] = "CYBERCRAFT",
    ["where get karker sahur"] = "FIRSTCRAFTMACHINE", ["where get karkerkar kurkur"] = "ADMINABUSE", ["where get ketchuru and musturu"] = "REDCARPET", ["where get ketupat bros"] = "OGFUSE",
    ["where get ketupat kepat"] = "REDCARPET", ["where get krupuk pagi pagi"] = "INDONESIA", ["where get la anniversary grande"] = "LIMITEDQUANTITYCRAFT", ["where get la cucaracha"] = "ADMINABUSE",
    ["where get la easter grande"] = "LIMITEDQUANTITYCRAFT", ["where get la extinct grande"] = "EXTINCT", ["where get la grande combinasion"] = "REDCARPET", ["where get la jolly grande"] = "CHRISTMASWHEELSPIN",
    ["where get la karkerkar combinasion"] = "FIRSTCRAFTMACHINE", ["where get la lucky grande"] = "LIMITEDQUANTITYCRAFT", ["where get la romantic grande"] = "LIMITEDQUANTITYCRAFT", ["where get la sahur combinasion"] = "FIRSTCRAFTMACHINE",
    ["where get la spooky grande"] = "LIMITEDQUANTITYCRAFT", ["where get la summer grande"] = "LIMITEDQUANTITYCRAFT", ["where get la supreme combinasion"] = "FIRSTFUSEMACHINE", ["where get la taco combinasion"] = "LIMITEDQUANTITYCRAFT",
    ["where get la vacca jacko linterino"] = "HALLOWEEN", ["where get la vacca prese presente"] = "SANTASFUSE", ["where get la vacca saturno saturnita"] = "REDCARPET", ["where get las capuchinas"] = "FIRSTCRAFTMACHINE",
    ["where get las sis"] = "FIRSTCRAFTMACHINE", ["where get las tralaleritas"] = "REDCARPET", ["where get las vaquitas saturnitas"] = "LAVACCARITUAL", ["where get lavadorito spinito"] = "REDCARPET",
    ["where get lazy ducky"] = "DLCCODE", ["where get lemonita splashita"] = "SUMMERFUSE", ["where get lerulerulerule"] = "REDCARPET", ["where get lionel cactuseli"] = "REDCARPET", ["where get liril laril"] = "REDCARPET",
    ["where get list list list sahur"] = "CHRISTMAS", ["where get los admins"] = "LOSTRADERS", ["where get los bros"] = "FIRSTCRAFTMACHINE", ["where get los candies"] = "SANTASFUSE",
    ["where get los chicleteiras"] = "CHICLETEIRARITUAL", ["where get los chillis"] = "CYBERCRAFT", ["where get los combinasionas"] = "FIRSTFUSEMACHINE", ["where get los cornis"] = "LOSTRADERS",
    ["where get los crocodillitos"] = "BOMBARDIRO", ["where get los cupids"] = "DIVINEFUSE", ["where get los fruits"] = "SUMMERFUSE", ["where get los hackers"] = "CYBERCRAFT", ["where get los hotspotsitos"] = "FIRSTFUSEMACHINE",
    ["where get los jolly combinasionas"] = "SANTASMARKET", ["where get los karkeritos"] = "KARKERRITUAL", ["where get los mariachis"] = "PINATA", ["where get los matteos"] = "MATTEORITUAL",
    ["where get los mi gatitos"] = "MIGATITORITUAL", ["where get los mobilis"] = "WITCHSFUSE", ["where get los noobinis"] = "CYBERCRAFT", ["where get los orcalitos"] = "FIRSTFUSEMACHINE",
    ["where get los planitos"] = "BRAINROTTRADER", ["where get los primos"] = "FIRSTCRAFTMACHINE", ["where get los puggies"] = "BRAINROTTRADER", ["where get los secret combinasionas"] = "LOSTRADERS",
    ["where get los sigmas"] = "LOSTRADERS", ["where get los spaghettis"] = "BRAINROTTRADER", ["where get los spyderinis"] = "SPYDERINIRITUAL", ["where get los sweethearts"] = "FIRSTFUSEMACHINE",
    ["where get los tacoritas"] = "FIRSTCRAFTMACHINE", ["where get los tangcitos"] = "LOSTRADERS", ["where get los tictacs"] = "LOSTRADERS", ["where get los tralaleritos"] = "REDCARPET",
    ["where get los trios"] = "OGFUSE", ["where get los tungtungtungcitos"] = "FIRSTFUSEMACHINE", ["where get love love bear"] = "CUPIDSMACHINE", ["where get lovin rose"] = "CUPIDSMACHINE",
    ["where get lumaca malefica"] = "BACKROOMS", ["where get magi ribbitini"] = "WITCHSFUSE", ["where get malame amarele"] = "FIRSTCRAFTMACHINE", ["where get mangolini parrocini"] = "BRAINROTTRADER",
    ["where get mariachi corazoni"] = "PINATA", ["where get matteo"] = "ADMINABUSE", ["where get meowl"] = "REDCARPET", ["where get mi gatito"] = "ADMINABUSE", ["where get mieteteira bicicleteira"] = "WITCHSFUSE",
    ["where get moby bros"] = "LOSTRADERS", ["where get money money bros"] = "CYBERCRAFT", ["where get money money man"] = "BRAINROTTRADER", ["where get money money puggy"] = "REDCARPET",
    ["where get money money reindeer"] = "SANTASMARKET", ["where get mummio rappitto"] = "WITCHSFUSE", ["where get nacho spyder"] = "LIMITEDQUANTITYCRAFT", ["where get naughty naughty"] = "CHRISTMAS",
    ["where get noo candy"] = "TRICKORTREAT", ["where get noo eggs"] = "EASTER", ["where get noo examen"] = "DULDULRITUAL", ["where get noo la polizia"] = "BRAINROTTRADER", ["where get noo present"] = "CHRISTMAS",
    ["where get noo resume"] = "JOBRITUAL", ["where get noobini pizzanini"] = "REDCARPET", ["where get noobini santanini"] = "SANTASFUSE", ["where get noodle noodle poodle"] = "REDCARPET",
    ["where get nooo hotspot"] = "TACO", ["where get nuclearo dinossauro"] = "REDCARPET", ["where get ombrello topolino"] = "SUMMERFUSE", ["where get orangutini ananassini"] = "REDCARPET",
    ["where get orbi mochi"] = "CYBERCRAFT", ["where get orcaledon"] = "BRAINROTTRADER", ["where get orcalita orcala"] = "CYBERCRAFT", ["where get pakrahmatmamat"] = "REDCARPET", ["where get pakrahmatmatina"] = "POLEGAME",
    ["where get pancake and syrup"] = "DLCCODE", ["where get pandaccini bananini"] = "REDCARPET", ["where get paradiso axolottino"] = "DIVINEFUSE", ["where get pengolino nuvoletto"] = "DIVINEFUSE",
    ["where get penguin tree"] = "SANTASFUSE", ["where get penguino cocosino"] = "SUMMERFUSE", ["where get perochello lemonchello"] = "REDCARPET", ["where get perrito burrito"] = "LIMITEDQUANTITYCRAFT",
    ["where get pi pi watermelon"] = "SUMMERFUSE", ["where get piccione macchina"] = "REDCARPET", ["where get piccionetta macchina"] = "FIRSTCRAFTMACHINE", ["where get pinealotto fruttarino"] = "WITCHSFUSE",
    ["where get pineaplino"] = "DLCCODE", ["where get pipi avocado"] = "SUMMERFUSE", ["where get pipi corni"] = "SUMMERFUSE", ["where get pipi kiwi"] = "REDCARPET", ["where get pipi potato"] = "REDCARPET",
    ["where get pirulitoita bicicleteira"] = "BRAINROTTRADER", ["where get please present"] = "ADVENTCALENDAR", ["where get popcuru and fizzuru"] = "OGFUSE", ["where get pot pumpkin"] = "HALLOWEEN",
    ["where get pretzo robo"] = "CYBERCRAFT", ["where get puffaball"] = "FISHING", ["where get quackini snackini"] = "EGGTOWN", ["where get quackula"] = "WITCHSFUSE", ["where get quesadillo vampiro"] = "LIMITEDQUANTITYCRAFT",
    ["where get quivioli ameleonni"] = "REDCARPET", ["where get raccooni jandelini"] = "ADMINABUSEWAR", ["where get rang ring bus"] = "POLEGAME", ["where get ref ref ref sahur"] = "SOCCERBOARD",
    ["where get reindeer tralala"] = "CHRISTMAS", ["where get rhino helicopterino"] = "FIRSTCRAFTMACHINE", ["where get rico dinero"] = "DLCCODE", ["where get robo grafito"] = "BACKROOMS",
    ["where get rocco disco"] = "NEWYEARS", ["where get rocketini frostini"] = "SAMMYSCODE", ["where get rubiko and kubiko"] = "LOSTRADERS", ["where get rubrikiko"] = "BACKROOMS", ["where get salamino penguino"] = "REDCARPET",
    ["where get sammyni cakini"] = "SABSANNIVERSARY", ["where get sammyni spyderini"] = "ADMINABUSE", ["where get santteo"] = "CHRISTMAS", ["where get sealo regalo"] = "SANTASFUSE",
    ["where get serafinna medusella"] = "DIVINEFUSE", ["where get seraphino gruyero"] = "DIVINEFUSE", ["where get sigma boy"] = "REDCARPET", ["where get sigma girl"] = "FIRSTCRAFTMACHINE",
    ["where get signore carapace"] = "FIRSTCRAFTMACHINE", ["where get skibidi toilet"] = "REDCARPET", ["where get skull skull skull"] = "HALLOWEEN", ["where get snailenzo"] = "WITCHSFUSE",
    ["where get spinny hammy"] = "OGFUSE", ["where get spongini quackini"] = "OGFUSE", ["where get spooky and pumpky"] = "WITCHSFUSE", ["where get squalanana"] = "CYBERCRAFT", ["where get steakini fattini"] = "LIMITEDQUANTITYCRAFT",
    ["where get stoppo luminino"] = "BRAINROTTRADER", ["where get strawberrelli flamingelli"] = "REDCARPET", ["where get strawberry elephant"] = "REDCARPET", ["where get sundrilla sundae"] = "SUMMERFUSE",
    ["where get svinina bombardino"] = "REDCARPET", ["where get swag soda"] = "BRAINROTTRADER", ["where get swaggy bros"] = "LIMITEDQUANTITYCRAFT", ["where get tacorillo crocodillo"] = "LIMITEDQUANTITYCRAFT",
    ["where get tacorita bicicleta"] = "TACO", ["where get talpa di fero"] = "REDCARPET", ["where get tang tang keletang"] = "REDCARPET", ["where get tartaragno"] = "WITCHSFUSE", ["where get tartaruga cisterna"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["where get te te te sahur"] = "REDCARPET", ["where get tenini ballini"] = "DLCCODE", ["where get tentacolo tecnico"] = "WITCHSFUSE", ["where get ti ti ti sahur"] = "SUMMERFUSE",
    ["where get tictac sahur"] = "REDCARPET", ["where get tim cheese"] = "REDCARPET", ["where get tipi topi taco"] = "TACO", ["where get tirilikalika tirilikalako"] = "FIRSTCRAFTMACHINE",
    ["where get to to to sahur"] = "REDCARPET", ["where get tob tobi tobi"] = "FIRSTFUSEMACHINE", ["where get toiletto focaccino"] = "REDCARPET", ["where get tootini shrimpini"] = "NEWYEARS",
    ["where get toro espanolo"] = "SPAIN", ["where get tracoducotulu delapeladustuz"] = "REDCARPET", ["where get tractoro dinosauro"] = "REDCARPET", ["where get tralaledon"] = "FIRSTCRAFTMACHINE",
    ["where get tralalero tralala"] = "REDCARPET", ["where get tralalita tralala"] = "REDCARPET", ["where get tree tree tree sahur"] = "SANTASFUSE", ["where get trenostruzzo turbo 3000"] = "REDCARPET",
    ["where get trenostruzzo turbo 4000"] = "FIRSTCRAFTMACHINE", ["where get trenotubo axolotrico 9000"] = "CYBERCRAFT", ["where get tric trac baraboom"] = "REDCARPET", ["where get trippi troppi"] = "REDCARPET",
    ["where get trippi troppi troppa trippa"] = "REDCARPET", ["where get trulimero trulicina"] = "REDCARPET", ["where get tuff toucan"] = "NEWYEARS", ["where get tukanno bananno"] = "FIRSTFUSEMACHINE",
    ["where get unclito samito"] = "ADMINABUSE", ["where get urubini flamenguini"] = "ADMINABUSE", ["where get vampira cappucina"] = "HALLOWEEN", ["where get var var var"] = "SOCCERBOARD",
    ["where get ventoliero pavonero"] = "REDCARPET", ["where get venuspino"] = "SUMMERFUSE", ["where get vulturino skeletono"] = "WITCHSFUSE", ["where get w or l"] = "LIMITEDQUANTITYCRAFT",
    ["where get wombo rollo"] = "REDCARPET", ["where get yess examen"] = "DULDULRITUAL", ["where get yess resume"] = "JOBRITUAL", ["where get yeti claus"] = "SANTASFUSE", ["where get zombie tralala"] = "HALLOWEEN",
    ["where ginger cisterna come from"] = "SANTASFUSE", ["where ginger cisterna from"] = "SANTASFUSE", ["where ginger gerat come from"] = "SANTASMARKET", ["where ginger gerat from"] = "SANTASMARKET",
    ["where ginger globo come from"] = "SANTASFUSE", ["where ginger globo from"] = "SANTASFUSE", ["where girafa celestre come from"] = "REDCARPET", ["where girafa celestre from"] = "REDCARPET",
    ["where glaciator come from"] = "BACKROOMS", ["where glaciator from"] = "BACKROOMS", ["where globa steppa come from"] = "DLCCODE", ["where globa steppa from"] = "DLCCODE", ["where glorbo fruttodrillo come from"] = "REDCARPET",
    ["where glorbo fruttodrillo from"] = "REDCARPET", ["where goat come from"] = "ADMINABUSE", ["where goat from"] = "ADMINABUSE", ["where gobblino uniciclino come from"] = "THANKSGIVING",
    ["where gobblino uniciclino from"] = "THANKSGIVING", ["where gorillo subwoofero come from"] = "FIRSTCRAFTMACHINE", ["where gorillo subwoofero from"] = "FIRSTCRAFTMACHINE", ["where gorillo watermelondrillo come from"] = "REDCARPET",
    ["where gorillo watermelondrillo from"] = "REDCARPET", ["where grabatron come from"] = "DLCCODES", ["where grabatron from"] = "DLCCODES", ["where graipuss medussi come from"] = "REDCARPET",
    ["where graipuss medussi from"] = "REDCARPET", ["where granchiello spiritell come from"] = "FISHING", ["where granchiello spiritell from"] = "FISHING", ["where granny come from"] = "GRANNYSFUNERAL",
    ["where granny from"] = "GRANNYSFUNERAL", ["where griffin come from"] = "DIVINEFUSE", ["where griffin from"] = "DIVINEFUSE", ["where guest 666 come from"] = "CAVERITUAL", ["where guest 666 from"] = "CAVERITUAL",
    ["where gym bros come from"] = "CYBERCRAFT", ["where gym bros from"] = "CYBERCRAFT", ["where harpuccino come from"] = "DIVINEFUSE", ["where harpuccino from"] = "DIVINEFUSE", ["where headless horseman come from"] = "WITCHSFUSE",
    ["where headless horseman from"] = "WITCHSFUSE", ["where hippo golazo come from"] = "SOCCERBOARD", ["where hippo golazo from"] = "SOCCERBOARD", ["where ho ho ho sahur come from"] = "SANTASFUSE",
    ["where ho ho ho sahur from"] = "SANTASFUSE", ["where holy arepa come from"] = "DIVINEFUSE", ["where holy arepa from"] = "DIVINEFUSE", ["where horegini boom come from"] = "AURABOAT",
    ["where horegini boom from"] = "AURABOAT", ["where hydra dragon cannelloni come from"] = "OGFUSE", ["where hydra dragon cannelloni from"] = "OGFUSE", ["where jacko jack jack come from"] = "WITCHSFUSE",
    ["where jacko jack jack from"] = "WITCHSFUSE", ["where jacko spaventosa come from"] = "WITCHSFUSE", ["where jacko spaventosa from"] = "WITCHSFUSE", ["where jelly moby come from"] = "SABSANNIVERSARY",
    ["where jelly moby from"] = "SABSANNIVERSARY", ["where jingle jingle sahur come from"] = "SANTASFUSE", ["where jingle jingle sahur from"] = "SANTASFUSE", ["where job job job sahur come from"] = "REDCARPET",
    ["where job job job sahur from"] = "REDCARPET", ["where john doe come from"] = "CAVERITUAL", ["where john doe from"] = "CAVERITUAL", ["where john pork come from"] = "REDCARPET",
    ["where john pork from"] = "REDCARPET", ["where jolly jolly sahur come from"] = "SANTASMARKET", ["where jolly jolly sahur from"] = "SANTASMARKET", ["where kalika bros come from"] = "CYBERCRAFT",
    ["where kalika bros from"] = "CYBERCRAFT", ["where karker sahur come from"] = "FIRSTCRAFTMACHINE", ["where karker sahur from"] = "FIRSTCRAFTMACHINE", ["where karkerkar kurkur come from"] = "ADMINABUSE",
    ["where karkerkar kurkur from"] = "ADMINABUSE", ["where ketchuru and musturu come from"] = "REDCARPET", ["where ketchuru and musturu from"] = "REDCARPET", ["where ketupat bros come from"] = "OGFUSE",
    ["where ketupat bros from"] = "OGFUSE", ["where ketupat kepat come from"] = "REDCARPET", ["where ketupat kepat from"] = "REDCARPET", ["where krupuk pagi pagi come from"] = "INDONESIA",
    ["where krupuk pagi pagi from"] = "INDONESIA", ["where la anniversary grande come from"] = "LIMITEDQUANTITYCRAFT", ["where la anniversary grande from"] = "LIMITEDQUANTITYCRAFT",
    ["where la cucaracha come from"] = "ADMINABUSE", ["where la cucaracha from"] = "ADMINABUSE", ["where la easter grande come from"] = "LIMITEDQUANTITYCRAFT", ["where la easter grande from"] = "LIMITEDQUANTITYCRAFT",
    ["where la extinct grande come from"] = "EXTINCT", ["where la extinct grande from"] = "EXTINCT", ["where la grande combinasion come from"] = "REDCARPET", ["where la grande combinasion from"] = "REDCARPET",
    ["where la jolly grande come from"] = "CHRISTMASWHEELSPIN", ["where la jolly grande from"] = "CHRISTMASWHEELSPIN", ["where la karkerkar combinasion come from"] = "FIRSTCRAFTMACHINE",
    ["where la karkerkar combinasion from"] = "FIRSTCRAFTMACHINE", ["where la lucky grande come from"] = "LIMITEDQUANTITYCRAFT", ["where la lucky grande from"] = "LIMITEDQUANTITYCRAFT",
    ["where la romantic grande come from"] = "LIMITEDQUANTITYCRAFT", ["where la romantic grande from"] = "LIMITEDQUANTITYCRAFT", ["where la sahur combinasion come from"] = "FIRSTCRAFTMACHINE",
    ["where la sahur combinasion from"] = "FIRSTCRAFTMACHINE", ["where la spooky grande come from"] = "LIMITEDQUANTITYCRAFT", ["where la spooky grande from"] = "LIMITEDQUANTITYCRAFT",
    ["where la summer grande come from"] = "LIMITEDQUANTITYCRAFT", ["where la summer grande from"] = "LIMITEDQUANTITYCRAFT", ["where la supreme combinasion come from"] = "FIRSTFUSEMACHINE",
    ["where la supreme combinasion from"] = "FIRSTFUSEMACHINE", ["where la taco combinasion come from"] = "LIMITEDQUANTITYCRAFT", ["where la taco combinasion from"] = "LIMITEDQUANTITYCRAFT",
    ["where la vacca jacko linterino come from"] = "HALLOWEEN", ["where la vacca jacko linterino from"] = "HALLOWEEN", ["where la vacca prese presente come from"] = "SANTASFUSE", ["where la vacca prese presente from"] = "SANTASFUSE",
    ["where la vacca saturno saturnita come from"] = "REDCARPET", ["where la vacca saturno saturnita from"] = "REDCARPET", ["where las capuchinas come from"] = "FIRSTCRAFTMACHINE", ["where las capuchinas from"] = "FIRSTCRAFTMACHINE",
    ["where las sis come from"] = "FIRSTCRAFTMACHINE", ["where las sis from"] = "FIRSTCRAFTMACHINE", ["where las tralaleritas come from"] = "REDCARPET", ["where las tralaleritas from"] = "REDCARPET",
    ["where las vaquitas saturnitas come from"] = "LAVACCARITUAL", ["where las vaquitas saturnitas from"] = "LAVACCARITUAL", ["where lavadorito spinito come from"] = "REDCARPET", ["where lavadorito spinito from"] = "REDCARPET",
    ["where lazy ducky come from"] = "DLCCODE", ["where lazy ducky from"] = "DLCCODE", ["where lemonita splashita come from"] = "SUMMERFUSE", ["where lemonita splashita from"] = "SUMMERFUSE",
    ["where lerulerulerule come from"] = "REDCARPET", ["where lerulerulerule from"] = "REDCARPET", ["where lionel cactuseli come from"] = "REDCARPET", ["where lionel cactuseli from"] = "REDCARPET",
    ["where liril laril come from"] = "REDCARPET", ["where liril laril from"] = "REDCARPET", ["where list list list sahur come from"] = "CHRISTMAS", ["where list list list sahur from"] = "CHRISTMAS",
    ["where los admins come from"] = "LOSTRADERS", ["where los admins from"] = "LOSTRADERS", ["where los bros come from"] = "FIRSTCRAFTMACHINE", ["where los bros from"] = "FIRSTCRAFTMACHINE",
    ["where los candies come from"] = "SANTASFUSE", ["where los candies from"] = "SANTASFUSE", ["where los chicleteiras come from"] = "CHICLETEIRARITUAL", ["where los chicleteiras from"] = "CHICLETEIRARITUAL",
    ["where los chillis come from"] = "CYBERCRAFT", ["where los chillis from"] = "CYBERCRAFT", ["where los combinasionas come from"] = "FIRSTFUSEMACHINE", ["where los combinasionas from"] = "FIRSTFUSEMACHINE",
    ["where los cornis come from"] = "LOSTRADERS", ["where los cornis from"] = "LOSTRADERS", ["where los crocodillitos come from"] = "BOMBARDIRO", ["where los crocodillitos from"] = "BOMBARDIRO",
    ["where los cupids come from"] = "DIVINEFUSE", ["where los cupids from"] = "DIVINEFUSE", ["where los fruits come from"] = "SUMMERFUSE", ["where los fruits from"] = "SUMMERFUSE",
    ["where los hackers come from"] = "CYBERCRAFT", ["where los hackers from"] = "CYBERCRAFT", ["where los hotspotsitos come from"] = "FIRSTFUSEMACHINE", ["where los hotspotsitos from"] = "FIRSTFUSEMACHINE",
    ["where los jolly combinasionas come from"] = "SANTASMARKET", ["where los jolly combinasionas from"] = "SANTASMARKET", ["where los karkeritos come from"] = "KARKERRITUAL", ["where los karkeritos from"] = "KARKERRITUAL",
    ["where los mariachis come from"] = "PINATA", ["where los mariachis from"] = "PINATA", ["where los matteos come from"] = "MATTEORITUAL", ["where los matteos from"] = "MATTEORITUAL",
    ["where los mi gatitos come from"] = "MIGATITORITUAL", ["where los mi gatitos from"] = "MIGATITORITUAL", ["where los mobilis come from"] = "WITCHSFUSE", ["where los mobilis from"] = "WITCHSFUSE",
    ["where los noobinis come from"] = "CYBERCRAFT", ["where los noobinis from"] = "CYBERCRAFT", ["where los orcalitos come from"] = "FIRSTFUSEMACHINE", ["where los orcalitos from"] = "FIRSTFUSEMACHINE",
    ["where los planitos come from"] = "BRAINROTTRADER", ["where los planitos from"] = "BRAINROTTRADER", ["where los primos come from"] = "FIRSTCRAFTMACHINE", ["where los primos from"] = "FIRSTCRAFTMACHINE",
    ["where los puggies come from"] = "BRAINROTTRADER", ["where los puggies from"] = "BRAINROTTRADER", ["where los secret combinasionas come from"] = "LOSTRADERS", ["where los secret combinasionas from"] = "LOSTRADERS",
    ["where los sigmas come from"] = "LOSTRADERS", ["where los sigmas from"] = "LOSTRADERS", ["where los spaghettis come from"] = "BRAINROTTRADER", ["where los spaghettis from"] = "BRAINROTTRADER",
    ["where los spyderinis come from"] = "SPYDERINIRITUAL", ["where los spyderinis from"] = "SPYDERINIRITUAL", ["where los sweethearts come from"] = "FIRSTFUSEMACHINE", ["where los sweethearts from"] = "FIRSTFUSEMACHINE",
    ["where los tacoritas come from"] = "FIRSTCRAFTMACHINE", ["where los tacoritas from"] = "FIRSTCRAFTMACHINE", ["where los tangcitos come from"] = "LOSTRADERS", ["where los tangcitos from"] = "LOSTRADERS",
    ["where los tictacs come from"] = "LOSTRADERS", ["where los tictacs from"] = "LOSTRADERS", ["where los tralaleritos come from"] = "REDCARPET", ["where los tralaleritos from"] = "REDCARPET",
    ["where los trios come from"] = "OGFUSE", ["where los trios from"] = "OGFUSE", ["where los tungtungtungcitos come from"] = "FIRSTFUSEMACHINE", ["where los tungtungtungcitos from"] = "FIRSTFUSEMACHINE",
    ["where love love bear come from"] = "CUPIDSMACHINE", ["where love love bear from"] = "CUPIDSMACHINE", ["where lovin rose come from"] = "CUPIDSMACHINE", ["where lovin rose from"] = "CUPIDSMACHINE",
    ["where lumaca malefica come from"] = "BACKROOMS", ["where lumaca malefica from"] = "BACKROOMS", ["where magi ribbitini come from"] = "WITCHSFUSE", ["where magi ribbitini from"] = "WITCHSFUSE",
    ["where malame amarele come from"] = "FIRSTCRAFTMACHINE", ["where malame amarele from"] = "FIRSTCRAFTMACHINE", ["where mangolini parrocini come from"] = "BRAINROTTRADER", ["where mangolini parrocini from"] = "BRAINROTTRADER",
    ["where mariachi corazoni come from"] = "PINATA", ["where mariachi corazoni from"] = "PINATA", ["where matteo come from"] = "ADMINABUSE", ["where matteo from"] = "ADMINABUSE", ["where meowl come from"] = "REDCARPET",
    ["where meowl from"] = "REDCARPET", ["where mi gatito come from"] = "ADMINABUSE", ["where mi gatito from"] = "ADMINABUSE", ["where mieteteira bicicleteira come from"] = "WITCHSFUSE",
    ["where mieteteira bicicleteira from"] = "WITCHSFUSE", ["where moby bros come from"] = "LOSTRADERS", ["where moby bros from"] = "LOSTRADERS", ["where money money bros come from"] = "CYBERCRAFT",
    ["where money money bros from"] = "CYBERCRAFT", ["where money money man come from"] = "BRAINROTTRADER", ["where money money man from"] = "BRAINROTTRADER", ["where money money puggy come from"] = "REDCARPET",
    ["where money money puggy from"] = "REDCARPET", ["where money money reindeer come from"] = "SANTASMARKET", ["where money money reindeer from"] = "SANTASMARKET", ["where mummio rappitto come from"] = "WITCHSFUSE",
    ["where mummio rappitto from"] = "WITCHSFUSE", ["where nacho spyder come from"] = "LIMITEDQUANTITYCRAFT", ["where nacho spyder from"] = "LIMITEDQUANTITYCRAFT", ["where naughty naughty come from"] = "CHRISTMAS",
    ["where naughty naughty from"] = "CHRISTMAS", ["where noo candy come from"] = "TRICKORTREAT", ["where noo candy from"] = "TRICKORTREAT", ["where noo eggs come from"] = "EASTER",
    ["where noo eggs from"] = "EASTER", ["where noo examen come from"] = "DULDULRITUAL", ["where noo examen from"] = "DULDULRITUAL", ["where noo la polizia come from"] = "BRAINROTTRADER",
    ["where noo la polizia from"] = "BRAINROTTRADER", ["where noo present come from"] = "CHRISTMAS", ["where noo present from"] = "CHRISTMAS", ["where noo resume come from"] = "JOBRITUAL",
    ["where noo resume from"] = "JOBRITUAL", ["where noobini pizzanini come from"] = "REDCARPET", ["where noobini pizzanini from"] = "REDCARPET", ["where noobini santanini come from"] = "SANTASFUSE",
    ["where noobini santanini from"] = "SANTASFUSE", ["where noodle noodle poodle come from"] = "REDCARPET", ["where noodle noodle poodle from"] = "REDCARPET", ["where nooo hotspot come from"] = "TACO",
    ["where nooo hotspot from"] = "TACO", ["where nuclearo dinossauro come from"] = "REDCARPET", ["where nuclearo dinossauro from"] = "REDCARPET", ["where ombrello topolino come from"] = "SUMMERFUSE",
    ["where ombrello topolino from"] = "SUMMERFUSE", ["where orangutini ananassini come from"] = "REDCARPET", ["where orangutini ananassini from"] = "REDCARPET", ["where orbi mochi come from"] = "CYBERCRAFT",
    ["where orbi mochi from"] = "CYBERCRAFT", ["where orcaledon come from"] = "BRAINROTTRADER", ["where orcaledon from"] = "BRAINROTTRADER", ["where orcalita orcala come from"] = "CYBERCRAFT",
    ["where orcalita orcala from"] = "CYBERCRAFT", ["where pakrahmatmamat come from"] = "REDCARPET", ["where pakrahmatmamat from"] = "REDCARPET", ["where pakrahmatmatina come from"] = "POLEGAME",
    ["where pakrahmatmatina from"] = "POLEGAME", ["where pancake and syrup come from"] = "DLCCODE", ["where pancake and syrup from"] = "DLCCODE", ["where pandaccini bananini come from"] = "REDCARPET",
    ["where pandaccini bananini from"] = "REDCARPET", ["where paradiso axolottino come from"] = "DIVINEFUSE", ["where paradiso axolottino from"] = "DIVINEFUSE", ["where pengolino nuvoletto come from"] = "DIVINEFUSE",
    ["where pengolino nuvoletto from"] = "DIVINEFUSE", ["where penguin tree come from"] = "SANTASFUSE", ["where penguin tree from"] = "SANTASFUSE", ["where penguino cocosino come from"] = "SUMMERFUSE",
    ["where penguino cocosino from"] = "SUMMERFUSE", ["where perochello lemonchello come from"] = "REDCARPET", ["where perochello lemonchello from"] = "REDCARPET", ["where perrito burrito come from"] = "LIMITEDQUANTITYCRAFT",
    ["where perrito burrito from"] = "LIMITEDQUANTITYCRAFT", ["where pi pi watermelon come from"] = "SUMMERFUSE", ["where pi pi watermelon from"] = "SUMMERFUSE", ["where piccione macchina come from"] = "REDCARPET",
    ["where piccione macchina from"] = "REDCARPET", ["where piccionetta macchina come from"] = "FIRSTCRAFTMACHINE", ["where piccionetta macchina from"] = "FIRSTCRAFTMACHINE", ["where pinealotto fruttarino come from"] = "WITCHSFUSE",
    ["where pinealotto fruttarino from"] = "WITCHSFUSE", ["where pineaplino come from"] = "DLCCODE", ["where pineaplino from"] = "DLCCODE", ["where pipi avocado come from"] = "SUMMERFUSE",
    ["where pipi avocado from"] = "SUMMERFUSE", ["where pipi corni come from"] = "SUMMERFUSE", ["where pipi corni from"] = "SUMMERFUSE", ["where pipi kiwi come from"] = "REDCARPET",
    ["where pipi kiwi from"] = "REDCARPET", ["where pipi potato come from"] = "REDCARPET", ["where pipi potato from"] = "REDCARPET", ["where pirulitoita bicicleteira come from"] = "BRAINROTTRADER",
    ["where pirulitoita bicicleteira from"] = "BRAINROTTRADER", ["where please present come from"] = "ADVENTCALENDAR", ["where please present from"] = "ADVENTCALENDAR", ["where popcuru and fizzuru come from"] = "OGFUSE",
    ["where popcuru and fizzuru from"] = "OGFUSE", ["where pot pumpkin come from"] = "HALLOWEEN", ["where pot pumpkin from"] = "HALLOWEEN", ["where pretzo robo come from"] = "CYBERCRAFT",
    ["where pretzo robo from"] = "CYBERCRAFT", ["where puffaball come from"] = "FISHING", ["where puffaball from"] = "FISHING", ["where quackini snackini come from"] = "EGGTOWN", ["where quackini snackini from"] = "EGGTOWN",
    ["where quackula come from"] = "WITCHSFUSE", ["where quackula from"] = "WITCHSFUSE", ["where quesadillo vampiro come from"] = "LIMITEDQUANTITYCRAFT", ["where quesadillo vampiro from"] = "LIMITEDQUANTITYCRAFT",
    ["where quivioli ameleonni come from"] = "REDCARPET", ["where quivioli ameleonni from"] = "REDCARPET", ["where raccooni jandelini come from"] = "ADMINABUSEWAR", ["where raccooni jandelini from"] = "ADMINABUSEWAR",
    ["where rang ring bus come from"] = "POLEGAME", ["where rang ring bus from"] = "POLEGAME", ["where ref ref ref sahur come from"] = "SOCCERBOARD", ["where ref ref ref sahur from"] = "SOCCERBOARD",
    ["where reindeer tralala come from"] = "CHRISTMAS", ["where reindeer tralala from"] = "CHRISTMAS", ["where rhino helicopterino come from"] = "FIRSTCRAFTMACHINE", ["where rhino helicopterino from"] = "FIRSTCRAFTMACHINE",
    ["where rico dinero come from"] = "DLCCODE", ["where rico dinero from"] = "DLCCODE", ["where robo grafito come from"] = "BACKROOMS", ["where robo grafito from"] = "BACKROOMS", ["where rocco disco come from"] = "NEWYEARS",
    ["where rocco disco from"] = "NEWYEARS", ["where rocketini frostini come from"] = "SAMMYSCODE", ["where rocketini frostini from"] = "SAMMYSCODE", ["where rubiko and kubiko come from"] = "LOSTRADERS",
    ["where rubiko and kubiko from"] = "LOSTRADERS", ["where rubrikiko come from"] = "BACKROOMS", ["where rubrikiko from"] = "BACKROOMS", ["where salamino penguino come from"] = "REDCARPET",
    ["where salamino penguino from"] = "REDCARPET", ["where sammyni cakini come from"] = "SABSANNIVERSARY", ["where sammyni cakini from"] = "SABSANNIVERSARY", ["where sammyni spyderini come from"] = "ADMINABUSE",
    ["where sammyni spyderini from"] = "ADMINABUSE", ["where santteo come from"] = "CHRISTMAS", ["where santteo from"] = "CHRISTMAS", ["where sealo regalo come from"] = "SANTASFUSE",
    ["where sealo regalo from"] = "SANTASFUSE", ["where serafinna medusella come from"] = "DIVINEFUSE", ["where serafinna medusella from"] = "DIVINEFUSE", ["where seraphino gruyero come from"] = "DIVINEFUSE",
    ["where seraphino gruyero from"] = "DIVINEFUSE", ["where sigma boy come from"] = "REDCARPET", ["where sigma boy from"] = "REDCARPET", ["where sigma girl come from"] = "FIRSTCRAFTMACHINE",
    ["where sigma girl from"] = "FIRSTCRAFTMACHINE", ["where signore carapace come from"] = "FIRSTCRAFTMACHINE", ["where signore carapace from"] = "FIRSTCRAFTMACHINE", ["where skibidi toilet come from"] = "REDCARPET",
    ["where skibidi toilet from"] = "REDCARPET", ["where skull skull skull come from"] = "HALLOWEEN", ["where skull skull skull from"] = "HALLOWEEN", ["where snailenzo come from"] = "WITCHSFUSE",
    ["where snailenzo from"] = "WITCHSFUSE", ["where spinny hammy come from"] = "OGFUSE", ["where spinny hammy from"] = "OGFUSE", ["where spongini quackini come from"] = "OGFUSE", ["where spongini quackini from"] = "OGFUSE",
    ["where spooky and pumpky come from"] = "WITCHSFUSE", ["where spooky and pumpky from"] = "WITCHSFUSE", ["where squalanana come from"] = "CYBERCRAFT", ["where squalanana from"] = "CYBERCRAFT",
    ["where steakini fattini come from"] = "LIMITEDQUANTITYCRAFT", ["where steakini fattini from"] = "LIMITEDQUANTITYCRAFT", ["where stoppo luminino come from"] = "BRAINROTTRADER", ["where stoppo luminino from"] = "BRAINROTTRADER",
    ["where strawberrelli flamingelli come from"] = "REDCARPET", ["where strawberrelli flamingelli from"] = "REDCARPET", ["where strawberry elephant come from"] = "REDCARPET", ["where strawberry elephant from"] = "REDCARPET",
    ["where sundrilla sundae come from"] = "SUMMERFUSE", ["where sundrilla sundae from"] = "SUMMERFUSE", ["where svinina bombardino come from"] = "REDCARPET", ["where svinina bombardino from"] = "REDCARPET",
    ["where swag soda come from"] = "BRAINROTTRADER", ["where swag soda from"] = "BRAINROTTRADER", ["where swaggy bros come from"] = "LIMITEDQUANTITYCRAFT", ["where swaggy bros from"] = "LIMITEDQUANTITYCRAFT",
    ["where tacorillo crocodillo come from"] = "LIMITEDQUANTITYCRAFT", ["where tacorillo crocodillo from"] = "LIMITEDQUANTITYCRAFT", ["where tacorita bicicleta come from"] = "TACO",
    ["where tacorita bicicleta from"] = "TACO", ["where talpa di fero come from"] = "REDCARPET", ["where talpa di fero from"] = "REDCARPET", ["where tang tang keletang come from"] = "REDCARPET",
    ["where tang tang keletang from"] = "REDCARPET", ["where tartaragno come from"] = "WITCHSFUSE", ["where tartaragno from"] = "WITCHSFUSE", ["where tartaruga cisterna come from"] = "THISISOBTAINEDFROMSAMMYSBASE",
    ["where tartaruga cisterna from"] = "THISISOBTAINEDFROMSAMMYSBASE", ["where te te te sahur come from"] = "REDCARPET", ["where te te te sahur from"] = "REDCARPET", ["where tenini ballini come from"] = "DLCCODE",
    ["where tenini ballini from"] = "DLCCODE", ["where tentacolo tecnico come from"] = "WITCHSFUSE", ["where tentacolo tecnico from"] = "WITCHSFUSE", ["where ti ti ti sahur come from"] = "SUMMERFUSE",
    ["where ti ti ti sahur from"] = "SUMMERFUSE", ["where tictac sahur come from"] = "REDCARPET", ["where tictac sahur from"] = "REDCARPET", ["where tim cheese come from"] = "REDCARPET",
    ["where tim cheese from"] = "REDCARPET", ["where tipi topi taco come from"] = "TACO", ["where tipi topi taco from"] = "TACO", ["where tirilikalika tirilikalako come from"] = "FIRSTCRAFTMACHINE",
    ["where tirilikalika tirilikalako from"] = "FIRSTCRAFTMACHINE", ["where to to to sahur come from"] = "REDCARPET", ["where to to to sahur from"] = "REDCARPET", ["where tob tobi tobi come from"] = "FIRSTFUSEMACHINE",
    ["where tob tobi tobi from"] = "FIRSTFUSEMACHINE", ["where toiletto focaccino come from"] = "REDCARPET", ["where toiletto focaccino from"] = "REDCARPET", ["where tootini shrimpini come from"] = "NEWYEARS",
    ["where tootini shrimpini from"] = "NEWYEARS", ["where toro espanolo come from"] = "SPAIN", ["where toro espanolo from"] = "SPAIN", ["where tracoducotulu delapeladustuz come from"] = "REDCARPET",
    ["where tracoducotulu delapeladustuz from"] = "REDCARPET", ["where tractoro dinosauro come from"] = "REDCARPET", ["where tractoro dinosauro from"] = "REDCARPET", ["where tralaledon come from"] = "FIRSTCRAFTMACHINE",
    ["where tralaledon from"] = "FIRSTCRAFTMACHINE", ["where tralalero tralala come from"] = "REDCARPET", ["where tralalero tralala from"] = "REDCARPET", ["where tralalita tralala come from"] = "REDCARPET",
    ["where tralalita tralala from"] = "REDCARPET", ["where tree tree tree sahur come from"] = "SANTASFUSE", ["where tree tree tree sahur from"] = "SANTASFUSE", ["where trenostruzzo turbo 3000 come from"] = "REDCARPET",
    ["where trenostruzzo turbo 3000 from"] = "REDCARPET", ["where trenostruzzo turbo 4000 come from"] = "FIRSTCRAFTMACHINE", ["where trenostruzzo turbo 4000 from"] = "FIRSTCRAFTMACHINE",
    ["where trenotubo axolotrico 9000 come from"] = "CYBERCRAFT", ["where trenotubo axolotrico 9000 from"] = "CYBERCRAFT", ["where tric trac baraboom come from"] = "REDCARPET", ["where tric trac baraboom from"] = "REDCARPET",
    ["where trippi troppi come from"] = "REDCARPET", ["where trippi troppi from"] = "REDCARPET", ["where trippi troppi troppa trippa come from"] = "REDCARPET", ["where trippi troppi troppa trippa from"] = "REDCARPET",
    ["where trulimero trulicina come from"] = "REDCARPET", ["where trulimero trulicina from"] = "REDCARPET", ["where tuff toucan come from"] = "NEWYEARS", ["where tuff toucan from"] = "NEWYEARS",
    ["where tukanno bananno come from"] = "FIRSTFUSEMACHINE", ["where tukanno bananno from"] = "FIRSTFUSEMACHINE", ["where unclito samito come from"] = "ADMINABUSE", ["where unclito samito from"] = "ADMINABUSE",
    ["where urubini flamenguini come from"] = "ADMINABUSE", ["where urubini flamenguini from"] = "ADMINABUSE", ["where vampira cappucina come from"] = "HALLOWEEN", ["where vampira cappucina from"] = "HALLOWEEN",
    ["where var var var come from"] = "SOCCERBOARD", ["where var var var from"] = "SOCCERBOARD", ["where ventoliero pavonero come from"] = "REDCARPET", ["where ventoliero pavonero from"] = "REDCARPET",
    ["where venuspino come from"] = "SUMMERFUSE", ["where venuspino from"] = "SUMMERFUSE", ["where vulturino skeletono come from"] = "WITCHSFUSE", ["where vulturino skeletono from"] = "WITCHSFUSE",
    ["where w or l come from"] = "LIMITEDQUANTITYCRAFT", ["where w or l from"] = "LIMITEDQUANTITYCRAFT", ["where wombo rollo come from"] = "REDCARPET", ["where wombo rollo from"] = "REDCARPET",
    ["where yess examen come from"] = "DULDULRITUAL", ["where yess examen from"] = "DULDULRITUAL", ["where yess resume come from"] = "JOBRITUAL", ["where yess resume from"] = "JOBRITUAL",
    ["where yeti claus come from"] = "SANTASFUSE", ["where yeti claus from"] = "SANTASFUSE", ["where zombie tralala come from"] = "HALLOWEEN", ["where zombie tralala from"] = "HALLOWEEN",
    ["winter hour add"] = "DECEMBER", ["winter hour added"] = "DECEMBER", ["witch fuse add"] = "OCTOBER", ["witch fuse added"] = "OCTOBER", ["witching hour add"] = "OCTOBER", ["witching hour added"] = "OCTOBER",
    ["wombo rollo come from"] = "REDCARPET", ["wombo rollo rarity"] = "EPIC", ["wombo rollo source"] = "REDCARPET", ["worst rod"] = "STARTERROD", ["yess examen come from"] = "DULDULRITUAL",
    ["yess examen rarity"] = "SECRET", ["yess examen source"] = "DULDULRITUAL", ["yess resume come from"] = "JOBRITUAL", ["yess resume rarity"] = "SECRET", ["yess resume source"] = "JOBRITUAL",
    ["yeti claus come from"] = "SANTASFUSE", ["yeti claus rarity"] = "BRAINROTGOD", ["yeti claus source"] = "SANTASFUSE", ["yin yang add"] = "SEPTEMBER", ["yin yang added"] = "SEPTEMBER",
    ["yin yang event add"] = "SEPTEMBER", ["yin yang event added"] = "SEPTEMBER", ["zibra zubra zibralini rarity"] = "MYTHIC", ["zombie tralala come from"] = "HALLOWEEN", ["zombie tralala rarity"] = "SECRET",
    ["zombie tralala source"] = "HALLOWEEN",};
  for _ae3289_c5d5da3y, _ae3289_c5d5da3z in pairs(eventDb)
  do
    if factDb[_ae3289_c5d5da3y] == nil or _ae3289_c5d5da3w[_ae3289_c5d5da3y] then
      factDb[_ae3289_c5d5da3y] = _ae3289_c5d5da3z
    end
  end;
  factDb["when add spooky scary skeletons"] = "OCTOBER";
  for _ae3289_c5d5da40, _ae3289_c5d5da41 in ipairs({"best halloween brainrot", "best brainrot halloween", "best brainrot from halloween", "best halloween", "best spooky brainrot", "best brainrot spooky",
    "best brainrot from spooky", "best skeleton brainrot", "best brainrot skeleton", "best brainrot from skeleton event", "best brainrot from spooky scary skeletons", "best spooky scary skeletons brainrot",
    "best brainrot from skull lucky block", "best brainrot skull lucky block", "best lucky catch brainrot", "best brainrot from lucky catch", "best brainrot lucky catch", "best halloween 2026 brainrot",
    "best new halloween brainrot", "best newest halloween brainrot", "best brainrot out lucky catch", "best brainrot out halloween", "best spooky lucky block brainrot", "best brainrot from spooky lucky block",
    "best brainrot spooky lucky block", "best brainrot out spooky lucky block", "best skull lucky block brainrot", "best brainrot out skull lucky block", "best halloween lucky block brainrot",
    "best brainrot from halloween lucky block"})
  do
    factDb[_ae3289_c5d5da41] = "DRAGONSKELETONINI"
  end;
  for _ae3289_c5d5da42, _ae3289_c5d5da43 in ipairs({"best old halloween brainrot", "best brainrot from old halloween", "best halloween 2025 brainrot", "best brainrot from halloween 2025",
    "best 1st halloween brainrot", "best brainrot from 1st halloween"})
  do
    factDb[_ae3289_c5d5da43] = "POTPUMPKIN"
  end;
  for _ae3289_c5d5da44, _ae3289_c5d5da45 in ipairs({"halloween fuse", "spooky fuse", "haunted fuse", "halloween fuse machine", "haunted fuse machine"})
  do
    for _ae3289_c5d5da46, _ae3289_c5d5da47 in ipairs({"best %s brainrot", "best brainrot from %s", "best brainrot out %s", "best brainrot %s", "best from %s", "best out %s", "best %s"})
    do
      local _ae3289_c5d5da48 = (_ae3289_c5d5da47):format(_ae3289_c5d5da45);
      factDb[_ae3289_c5d5da48] = "PHOENIX";
      factDb[_ae3289_c5d5da48 .. " right now"], factDb["newest " .. _ae3289_c5d5da48] = "PHOENIX", "PHOENIX";
      if _ae3289_c5d5da45 ~= "haunted fuse" and _ae3289_c5d5da45 ~= "haunted fuse machine" then
        for _ae3289_c5d5da49, _ae3289_c5d5da4a in ipairs({"all time", "ever", "in history", "every year", "all halloweens"})
        do
          factDb[_ae3289_c5d5da48 .. " " .. _ae3289_c5d5da4a] = "HEADLESSHORSEMAN"
        end;
        factDb["all time " .. _ae3289_c5d5da48] = "HEADLESSHORSEMAN"
      end
    end
  end;
  for _ae3289_c5d5da4b, _ae3289_c5d5da4c in ipairs({"all time", "ever", "in history"})
  do
    for _ae3289_c5d5da4d, _ae3289_c5d5da4e in ipairs({"best halloween brainrot %s", "best brainrot from halloween %s", "best brainrot halloween %s"})
    do
      factDb[(_ae3289_c5d5da4e):format(_ae3289_c5d5da4c)] = "HEADLESSHORSEMAN"
    end
  end;
  for _ae3289_c5d5da4f, _ae3289_c5d5da4g in pairs({["dragon skeletonini"] = "LUCKYCATCH", ["flying dutchman"] = "LUCKYCATCH", ["boo boo rocket"] = "LUCKYCATCH", ["bat in box"] = "HALLOWEEN",
    ["bananito skelito"] = "LUCKYBLOCK", ["grim cheese"] = "LUCKYBLOCK", ["candi corni"] = "HALLOWEEN", ["zombie bowl"] = "HALLOWEEN", ["arca bros"] = "LUCKYCATCH", ["skelly and coffy"] = "LUCKYCATCH",
    ["cobra gelato"] = "LUCKYCATCH", ["medusini medusini and demonini"] = "LUCKYCATCHMACHINE", ["chicken zombie"] = "SPOOKYSCARYSKELETONS", ["phoenix"] = "HAUNTEDFUSE", ["plant bros"] = "HAUNTEDFUSE",
    ["oni oni panda"] = "HAUNTEDFUSE"})
  do
    local _ae3289_c5d5da4h = (_ae3289_c5d5da4f == "candi corni") and "BRAINROTGOD" or "SECRET";
    factDb[_ae3289_c5d5da4f .. " rarity"], factDb["rarity " .. _ae3289_c5d5da4f] = _ae3289_c5d5da4h, _ae3289_c5d5da4h;
    factDb["where " .. _ae3289_c5d5da4f .. " come from"], factDb[_ae3289_c5d5da4f .. " come from"], factDb[_ae3289_c5d5da4f .. " source"] = _ae3289_c5d5da4g, _ae3289_c5d5da4g, _ae3289_c5d5da4g
  end;
  factDb["when add dragon skeletonini"], factDb["when add skull lucky block"] = "OCTOBER", "OCTOBER";
  factDb["when add skeleton base"], factDb["when add haunted fuse"] = "OCTOBER", "OCTOBER";
  local function _ae3289_c5d5da4i(_ae3289_c5d5da4j)
    local _ae3289_c5d5da4k = contextStore["luckN"];
    return _ae3289_c5d5da4k and(_ae3289_c5d5da4k .. "X" .. (_ae3289_c5d5da4j and "LUCK" or "")) or nil
  end;
  for _ae3289_c5d5da4l, _ae3289_c5d5da4m in ipairs({"current luck", "luck right now", "luck now", "server luck", "current server luck", "luck multiplier", "current luck multiplier",
    "luck multiplier right now", "what luck", "luck we are on", "luck on", "luck today", "luck it", "what luck it", "luck currently", "luck active", "active luck"})
  do
    factDb[_ae3289_c5d5da4m] = function()
      return _ae3289_c5d5da4i(false)
    end
  end;
  for _ae3289_c5d5da4n, _ae3289_c5d5da4o in ipairs({"current luck event", "luck event", "luck event right now", "luck event now", "what luck event", "luck event on", "active luck event",
    "luck event active", "luck event currently"})
  do
    factDb[_ae3289_c5d5da4o] = function()
      return _ae3289_c5d5da4i(true)
    end
  end;
  factDb["spooky scary skeletons add"] = "OCTOBER";
  factDb["when add spooky scary skeletons event"] = "OCTOBER"
end;
local _ae3289_c5d5da4p = {};
pcall(function()
  if type(isfile) == "function" and isfile(learnedFile) then
    local _ae3289_c5d5da4q = (HttpService):JSONDecode(readfile(learnedFile));
    if type(_ae3289_c5d5da4q) == "table" then
      _ae3289_c5d5da4p = _ae3289_c5d5da4q
    end
  end
end);
local function _ae3289_c5d5da4r()
  if type(writefile) ~= "function" then
    return
  end;
  pcall(function()
    writefile(learnedFile, (HttpService):JSONEncode(_ae3289_c5d5da4p))
  end)
end;
do
  local _ae3289_c5d5da4s = {["favourite"] = "favorite", ["fav"] = "favorite", ["favorites"] = "favorite", ["favrite"] = "favorite", ["colour"] = "color", ["colours"] = "color", ["colors"] = "color",
    ["whats"] = "what is", ["what's"] = "what is", ["wat"] = "what", ["wut"] = "what", ["whos"] = "who is", ["who's"] = "who is", ["wheres"] = "where is", ["whens"] = "when is", ["u"] = "you",
    ["ur"] = "your", ["pls"] = "", ["please"] = "", ["sammy's"] = "sammys", ["i'm"] = "i am", ["brainrto"] = "brainrot", ["brianrot"] = "brainrot", ["brainrots"] = "brainrot", ["yusername"] = "username",
    ["usernmae"] = "username", ["orginal"] = "original", ["mutaion"] = "mutation", ["mutations"] = "mutation", ["muation"] = "mutation", ["ogs"] = "og", ["steal"] = "steal",};
  local _ae3289_c5d5da4t = {"what is", "what are", "what was", "what were", "what do", "what does", "who is", "who was", "who are", "when is", "when was", "where is", "where are", "how many",
    "how much", "do you know", "can you tell me", "can you tell", "tell me", "i need", "give me", "answer me", "say", "type", "write", "the answer to", "question", "am i", "do i", "is my",
    "is the", "is a",};
  local _ae3289_c5d5da4u = {["first"] = 1, ["second"] = 2, ["third"] = 3, ["fourth"] = 4, ["fifth"] = 5, ["sixth"] = 6, ["seventh"] = 7, ["eighth"] = 8, ["ninth"] = 9, ["tenth"] = 10,
    ["eleventh"] = 11, ["twelfth"] = 12, ["thirteenth"] = 13, ["fourteenth"] = 14, ["fifteenth"] = 15, ["sixteenth"] = 16, ["seventeenth"] = 17, ["eighteenth"] = 18,};
  local _ae3289_c5d5da4v = {["one"] = 1, ["two"] = 2, ["three"] = 3, ["four"] = 4, ["five"] = 5, ["six"] = 6, ["seven"] = 7, ["eight"] = 8, ["nine"] = 9, ["ten"] = 10, ["eleven"] = 11,
    ["twelve"] = 12, ["thirteen"] = 13, ["fourteen"] = 14, ["fifteen"] = 15, ["sixteen"] = 16, ["seventeen"] = 17, ["eighteen"] = 18,};
  local _ae3289_c5d5da4w = {[1] = "1st", [2] = "2nd", [3] = "3rd"};
  local function _ae3289_c5d5da4x(_ae3289_c5d5da4y)
    return _ae3289_c5d5da4w[_ae3289_c5d5da4y] or(tostring(_ae3289_c5d5da4y) .. "th")
  end;
  local function _ae3289_c5d5da4z(_ae3289_c5d5da50)
    local _ae3289_c5d5da51 = {};
    for _ae3289_c5d5da52 in(_ae3289_c5d5da50):gmatch("%S+")
    do
      local _ae3289_c5d5da53 = _ae3289_c5d5da4s[_ae3289_c5d5da52];
      if _ae3289_c5d5da53 ~= nil then
        if _ae3289_c5d5da53 ~= "" then
          _ae3289_c5d5da51[#_ae3289_c5d5da51 + 1] = _ae3289_c5d5da53
        end
      else
        _ae3289_c5d5da51[#_ae3289_c5d5da51 + 1] = _ae3289_c5d5da52
      end
    end;
    return table["concat"](_ae3289_c5d5da51, " ")
  end;
  function _ae3289_c5d5da1n(_ae3289_c5d5da54)
    _ae3289_c5d5da54 = (tostring(_ae3289_c5d5da54 or "")):lower();
    _ae3289_c5d5da54 = ((_ae3289_c5d5da54):gsub("\226\128\153", "")):gsub("'", "");
    _ae3289_c5d5da54 = (_ae3289_c5d5da54):gsub("[%?%!%.%,%;%:\"`]", " ");
    _ae3289_c5d5da54 = (_ae3289_c5d5da54):gsub("%s+", " ");
    return _ae3289_c5d5da26(_ae3289_c5d5da54)
  end;
  local function _ae3289_c5d5da55(_ae3289_c5d5da56)
    local _ae3289_c5d5da57 = " " .. _ae3289_c5d5da56 .. " ";
    for _ae3289_c5d5da58, _ae3289_c5d5da59 in ipairs(_ae3289_c5d5da4t)
    do
      _ae3289_c5d5da57 = (_ae3289_c5d5da57):gsub("%s" .. (_ae3289_c5d5da59):gsub("%%", "%%%%") .. "%s", " ")
    end;
    _ae3289_c5d5da57 = ((_ae3289_c5d5da57):gsub("%s+my%s+", " ")):gsub("^%s*my%s+", " ");
    _ae3289_c5d5da57 = ((_ae3289_c5d5da57):gsub("%s+sammys?%s+", " ")):gsub("^%s*sammys?%s+", " ");
    _ae3289_c5d5da57 = (((_ae3289_c5d5da57):gsub("%s+the%s+", " ")):gsub("%s+of%s+", " ")):gsub("%s+for%s+", " ");
    _ae3289_c5d5da57 = (((_ae3289_c5d5da57):gsub("%s+a%s+", " ")):gsub("%s+an%s+", " ")):gsub("%s+in%s+", " ");
    _ae3289_c5d5da57 = (((_ae3289_c5d5da57):gsub("%s+i%s+", " ")):gsub("%s+is%s+", " ")):gsub("%s+was%s+", " ");
    _ae3289_c5d5da57 = ((_ae3289_c5d5da57):gsub("%s+did%s+", " ")):gsub("%s+does%s+", " ");
    _ae3289_c5d5da57 = (_ae3289_c5d5da57):gsub("%s+", " ");
    return _ae3289_c5d5da26(_ae3289_c5d5da57)
  end;
  local function _ae3289_c5d5da5a(_ae3289_c5d5da5b)
    local _ae3289_c5d5da5c = _ae3289_c5d5da5b;
    for _ae3289_c5d5da5d, _ae3289_c5d5da5e in pairs(_ae3289_c5d5da4u)
    do
      _ae3289_c5d5da5c = (_ae3289_c5d5da5c):gsub("%f[%a]" .. _ae3289_c5d5da5d .. "%f[%A]", _ae3289_c5d5da4x(_ae3289_c5d5da5e))
    end;
    for _ae3289_c5d5da5f, _ae3289_c5d5da5g in pairs(_ae3289_c5d5da4v)
    do
      _ae3289_c5d5da5c = (_ae3289_c5d5da5c):gsub("%f[%a]" .. _ae3289_c5d5da5f .. "%f[%A]", tostring(_ae3289_c5d5da5g))
    end;
    return _ae3289_c5d5da5c
  end;
  local _ae3289_c5d5da5h = {["who"] = true, ["what"] = true, ["which"] = true, ["when"] = true, ["where"] = true, ["how"] = true, ["why"] = true, ["name"] = true, ["tell"] = true, ["say"] = true,
    ["type"] = true, ["guess"] = true, ["answer"] = true, ["spell"] = true, ["write"] = true,};
  local _ae3289_c5d5da5i = {["mutation"] = true, ["machine"] = true, ["trait"] = true, ["brainrot"] = true, ["rarity"] = true, ["color"] = true, ["number"] = true, ["thing"] = true,
    ["one"] = true, ["word"] = true, ["day"] = true, ["year"] = true, ["month"] = true, ["update"] = true,};
  local _ae3289_c5d5da5j = {["you"] = true, ["your"] = true, ["yours"] = true, ["me"] = true, ["we"] = true, ["us"] = true, ["it"] = true, ["its"] = true, ["be"] = true, ["been"] = true,
    ["this"] = true, ["that"] = true, ["do"] = true, ["does"] = true, ["did"] = true, ["then"] = true, ["is"] = true, ["are"] = true,};
  local function _ae3289_c5d5da5k(_ae3289_c5d5da5l)
    local _ae3289_c5d5da5m = {};
    for _ae3289_c5d5da5n in(_ae3289_c5d5da5l):gmatch("%S+")
    do
      _ae3289_c5d5da5m[#_ae3289_c5d5da5m + 1] = _ae3289_c5d5da5n
    end;
    return _ae3289_c5d5da5m
  end;
  local function _ae3289_c5d5da5o(_ae3289_c5d5da5p, _ae3289_c5d5da5q)
    local _ae3289_c5d5da5r = _ae3289_c5d5da5k(_ae3289_c5d5da5p);
    if #_ae3289_c5d5da5r < 2 or not _ae3289_c5d5da5h[_ae3289_c5d5da5r[1]] then
      return nil
    end;
    if _ae3289_c5d5da5r[1] == "name" and _ae3289_c5d5da5q and(_ae3289_c5d5da5q):find("%f[%a]my%s+name") then
      return nil
    end;
    table["remove"](_ae3289_c5d5da5r, 1);
    if #_ae3289_c5d5da5r > 1 and _ae3289_c5d5da5i[_ae3289_c5d5da5r[1]] then
      table["remove"](_ae3289_c5d5da5r, 1)
    end;
    return table["concat"](_ae3289_c5d5da5r, " ")
  end;
  local function _ae3289_c5d5da5s(_ae3289_c5d5da5t)
    local _ae3289_c5d5da5u = {};
    for _ae3289_c5d5da5v, _ae3289_c5d5da5w in ipairs(_ae3289_c5d5da5k(_ae3289_c5d5da5t))
    do
      if not _ae3289_c5d5da5j[_ae3289_c5d5da5w] then
        _ae3289_c5d5da5u[#_ae3289_c5d5da5u + 1] = _ae3289_c5d5da5w
      end
    end;
    return table["concat"](_ae3289_c5d5da5u, " ")
  end;
  local function _ae3289_c5d5da5x(_ae3289_c5d5da5y)
    local _ae3289_c5d5da5z = factDb[_ae3289_c5d5da5y];
    if type(_ae3289_c5d5da5z) == "function" then
      local _ae3289_c5d5da60, _ae3289_c5d5da61 = pcall(_ae3289_c5d5da5z);
      _ae3289_c5d5da5z = _ae3289_c5d5da60 and _ae3289_c5d5da61 or nil
    end;
    if _ae3289_c5d5da5z == nil or _ae3289_c5d5da5z == "" then
      return nil
    end;
    return tostring(_ae3289_c5d5da5z)
  end;
  local function _ae3289_c5d5da62(_ae3289_c5d5da63)
    if not _ae3289_c5d5da63 or _ae3289_c5d5da63 == "" then
      return nil
    end;
    local _ae3289_c5d5da64 = _ae3289_c5d5da1n(_ae3289_c5d5da63);
    local _ae3289_c5d5da65 = _ae3289_c5d5da4z(_ae3289_c5d5da64);
    local _ae3289_c5d5da66 = _ae3289_c5d5da55(_ae3289_c5d5da65);
    local _ae3289_c5d5da67 = _ae3289_c5d5da5s(_ae3289_c5d5da66);
    local _ae3289_c5d5da68 = {_ae3289_c5d5da64, _ae3289_c5d5da65, _ae3289_c5d5da66, _ae3289_c5d5da67};
    local _ae3289_c5d5da69 = _ae3289_c5d5da5o(_ae3289_c5d5da66, _ae3289_c5d5da64);
    if _ae3289_c5d5da69 then
      _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da69
    end;
    local _ae3289_c5d5da6a = _ae3289_c5d5da5o(_ae3289_c5d5da67, _ae3289_c5d5da64);
    if _ae3289_c5d5da6a then
      _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da6a
    end;
    local _ae3289_c5d5da6b = #_ae3289_c5d5da68;
    for _ae3289_c5d5da6c = 1, _ae3289_c5d5da6b
    do
      local _ae3289_c5d5da6d = _ae3289_c5d5da5a(_ae3289_c5d5da68[_ae3289_c5d5da6c]);
      if _ae3289_c5d5da6d ~= _ae3289_c5d5da68[_ae3289_c5d5da6c] then
        _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da6d
      end
    end;
    local _ae3289_c5d5da6e = _ae3289_c5d5da5a(_ae3289_c5d5da67);
    local _ae3289_c5d5da6f, _ae3289_c5d5da6g = (_ae3289_c5d5da6e):match("^(.-)%s+(%d+)$");
    if _ae3289_c5d5da6f and _ae3289_c5d5da6g and tonumber(_ae3289_c5d5da6g) <= 20 then
      _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da4x(tonumber(_ae3289_c5d5da6g)) .. " " .. _ae3289_c5d5da26(_ae3289_c5d5da6f)
    end;
    local _ae3289_c5d5da6h, _ae3289_c5d5da6i = (_ae3289_c5d5da6e):match("^(%d+)%s+(.-)$");
    if _ae3289_c5d5da6h and _ae3289_c5d5da6i and tonumber(_ae3289_c5d5da6h) <= 20 then
      _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da4x(tonumber(_ae3289_c5d5da6h)) .. " " .. _ae3289_c5d5da26(_ae3289_c5d5da6i)
    end;
    local _ae3289_c5d5da6j = #_ae3289_c5d5da68;
    for _ae3289_c5d5da6k = 1, _ae3289_c5d5da6j
    do
      local _ae3289_c5d5da6l = _ae3289_c5d5da68[_ae3289_c5d5da6k];
      local _ae3289_c5d5da6m = (_ae3289_c5d5da6l):gsub("%f[%a]added%f[%A]", "add");
      if _ae3289_c5d5da6m ~= _ae3289_c5d5da6l then
        _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da6m
      end;
      local _ae3289_c5d5da6n = (_ae3289_c5d5da6l):gsub("%s+mutation$", "");
      if _ae3289_c5d5da6n ~= _ae3289_c5d5da6l then
        _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da6n
      end;
      local _ae3289_c5d5da6o = _ae3289_c5d5da26(((_ae3289_c5d5da6m):gsub("%s*%f[%a]mutation%f[%A]", "")));
      if _ae3289_c5d5da6o ~= _ae3289_c5d5da6l and _ae3289_c5d5da6o ~= _ae3289_c5d5da6n then
        _ae3289_c5d5da68[#_ae3289_c5d5da68 + 1] = _ae3289_c5d5da6o
      end
    end;
    for _ae3289_c5d5da6p, _ae3289_c5d5da6q in ipairs(_ae3289_c5d5da68)
    do
      _ae3289_c5d5da6q = _ae3289_c5d5da26(_ae3289_c5d5da6q);
      if _ae3289_c5d5da6q ~= "" then
        local _ae3289_c5d5da6r = _ae3289_c5d5da5x(_ae3289_c5d5da6q);
        if _ae3289_c5d5da6r then
          return _ae3289_c5d5da6r
        end
      end
    end;
    return nil
  end;
  local _ae3289_c5d5da6s = {["black and white"] = "\001blackwhite\001", ["yin and yang"] = "\001yinyang\001", ["salt and pepper"] = "\001saltpepper\001", ["rock and roll"] = "\001rockroll\001",
    ["cat and dog"] = "\001catdog\001", ["garama and madundung"] = "\001garama\001", ["pizza and ranch"] = "\001pizzaranch\001", ["gold and diamond"] = "\001golddiamond\001",};
  local _ae3289_c5d5da6t = {};
  for _ae3289_c5d5da6u, _ae3289_c5d5da6v in pairs(_ae3289_c5d5da6s)
  do
    _ae3289_c5d5da6t[_ae3289_c5d5da6v] = _ae3289_c5d5da6u
  end;
  local function _ae3289_c5d5da6w(_ae3289_c5d5da6x)
    local _ae3289_c5d5da6y = " " .. (tostring(_ae3289_c5d5da6x or "")):lower() .. " ";
    for _ae3289_c5d5da6z, _ae3289_c5d5da70 in pairs(_ae3289_c5d5da6s)
    do
      _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub(_ae3289_c5d5da6z, _ae3289_c5d5da70)
    end;
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s*[%?%;%,]%s*", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s*&%s*", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s*%+%s*", " and ");
    _ae3289_c5d5da6y = " " .. _ae3289_c5d5da1n(_ae3289_c5d5da6y) .. " ";
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("(my name)%s+the%s+", "%1 and the ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s+plus%s+", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s+then%s+", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s+followed%s+by%s+", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s+also%s+", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s+with%s+", " and ");
    _ae3289_c5d5da6y = (_ae3289_c5d5da6y):gsub("%s+", " ");
    local _ae3289_c5d5da71 = {};
    for _ae3289_c5d5da72 in((_ae3289_c5d5da6y .. " and ")):gmatch("(.-)%s+and%s+")
    do
      _ae3289_c5d5da72 = _ae3289_c5d5da26(_ae3289_c5d5da72);
      if _ae3289_c5d5da72 ~= "" then
        for _ae3289_c5d5da73, _ae3289_c5d5da74 in pairs(_ae3289_c5d5da6t)
        do
          _ae3289_c5d5da72 = (_ae3289_c5d5da72):gsub(_ae3289_c5d5da73, _ae3289_c5d5da74)
        end;
        _ae3289_c5d5da71[#_ae3289_c5d5da71 + 1] = _ae3289_c5d5da72
      end
    end;
    if #_ae3289_c5d5da71 == 0 then
      _ae3289_c5d5da71[1] = _ae3289_c5d5da26(_ae3289_c5d5da1n(_ae3289_c5d5da6x))
    end;
    return _ae3289_c5d5da71
  end;
  local function _ae3289_c5d5da75(_ae3289_c5d5da76)
    local _ae3289_c5d5da77 = (_ae3289_c5d5da76):lower();
    if(_ae3289_c5d5da77):find("twice") then
      return 2
    end;
    if(_ae3289_c5d5da77):find("thrice") then
      return 3
    end;
    local _ae3289_c5d5da78 = tonumber((_ae3289_c5d5da77):match("(%d+)%s*times"));
    if _ae3289_c5d5da78 and _ae3289_c5d5da78 >= 2 and _ae3289_c5d5da78 <= 10 then
      return _ae3289_c5d5da78
    end;
    for _ae3289_c5d5da79, _ae3289_c5d5da7a in pairs(_ae3289_c5d5da4v)
    do
      if _ae3289_c5d5da7a >= 2 and _ae3289_c5d5da7a <= 10 and(_ae3289_c5d5da77):find("%f[%a]" .. _ae3289_c5d5da79 .. "%s+times") then
        return _ae3289_c5d5da7a
      end
    end;
    return nil
  end;
  local function _ae3289_c5d5da7b(_ae3289_c5d5da7c)
    local _ae3289_c5d5da7d = _ae3289_c5d5da7c;
    _ae3289_c5d5da7d = (_ae3289_c5d5da7d):gsub("%s*%d+%s*times%s*", " ");
    _ae3289_c5d5da7d = (_ae3289_c5d5da7d):gsub("%s*twice%s*", " ");
    _ae3289_c5d5da7d = (_ae3289_c5d5da7d):gsub("%s*thrice%s*", " ");
    for _ae3289_c5d5da7e, _ae3289_c5d5da7f in pairs(_ae3289_c5d5da4v)
    do
      if _ae3289_c5d5da7f >= 2 and _ae3289_c5d5da7f <= 10 then
        _ae3289_c5d5da7d = (_ae3289_c5d5da7d):gsub("%s*" .. _ae3289_c5d5da7e .. "%s+times%s*", " ")
      end
    end;
    _ae3289_c5d5da7d = _ae3289_c5d5da26(_ae3289_c5d5da7d);
    return _ae3289_c5d5da7d ~= "" and _ae3289_c5d5da7d or _ae3289_c5d5da7c
  end;
  local function _ae3289_c5d5da7g(_ae3289_c5d5da7h)
    local _ae3289_c5d5da7i, _ae3289_c5d5da7j = {}, nil;
    for _ae3289_c5d5da7k in(_ae3289_c5d5da1n(_ae3289_c5d5da7h)):gmatch("%S+")
    do
      _ae3289_c5d5da7i[#_ae3289_c5d5da7i + 1] = _ae3289_c5d5da7k
    end;
    local _ae3289_c5d5da7l = {["mutation"] = true, ["machine"] = true, ["og"] = true, ["number"] = true, ["update"] = true, ["brainrot"] = true, ["trait"] = true, ["rarity"] = true,
      ["times"] = true};
    for _ae3289_c5d5da7m, _ae3289_c5d5da7n in ipairs(_ae3289_c5d5da7i)
    do
      if(_ae3289_c5d5da7n):match("^%d+$") and tonumber(_ae3289_c5d5da7n) > 13 and _ae3289_c5d5da7m > 1 then
        local _ae3289_c5d5da7o = _ae3289_c5d5da7i[_ae3289_c5d5da7m - 1] or "";
        local _ae3289_c5d5da7p = _ae3289_c5d5da7i[_ae3289_c5d5da7m + 1] or "";
        if not _ae3289_c5d5da7l[_ae3289_c5d5da7o] and not _ae3289_c5d5da7l[_ae3289_c5d5da7p] then
          _ae3289_c5d5da7j = _ae3289_c5d5da7n
        end
      end
    end;
    return _ae3289_c5d5da7j
  end;
  local function _ae3289_c5d5da7q(_ae3289_c5d5da7r)
    return _ae3289_c5d5da26((tostring(_ae3289_c5d5da7r)):gsub("%s+%d+%s*$", ""))
  end;
  local function _ae3289_c5d5da7s(_ae3289_c5d5da7t)
    local _ae3289_c5d5da7u;
    if(_ae3289_c5d5da7t):find("at the end") then
      _ae3289_c5d5da7u = "end"
    end;
    if(_ae3289_c5d5da7t):find("at the start") or(_ae3289_c5d5da7t):find("at the beginning") then
      _ae3289_c5d5da7u = "start"
    end;
    local _ae3289_c5d5da7v = (((_ae3289_c5d5da7t):gsub("%s*at the end%s*", " ")):gsub("%s*at the start%s*", " ")):gsub("%s*at the beginning%s*", " ");
    return _ae3289_c5d5da26(_ae3289_c5d5da7v), _ae3289_c5d5da7u
  end;
  local function _ae3289_c5d5da7w(_ae3289_c5d5da7x)
    local _ae3289_c5d5da7y = _ae3289_c5d5da75(_ae3289_c5d5da7x);
    local _ae3289_c5d5da7z = _ae3289_c5d5da7b(_ae3289_c5d5da7x);
    local _ae3289_c5d5da80 = _ae3289_c5d5da7g(_ae3289_c5d5da7z);
    if _ae3289_c5d5da80 then
      _ae3289_c5d5da7z = _ae3289_c5d5da7q(_ae3289_c5d5da7z)
    end;
    _ae3289_c5d5da7z = _ae3289_c5d5da26(_ae3289_c5d5da7z);
    if _ae3289_c5d5da7z == "" then
      return nil
    end;
    local _ae3289_c5d5da81 = (_ae3289_c5d5da7z):match("^%d+$");
    if _ae3289_c5d5da81 then
      return _ae3289_c5d5da7y and string["rep"](_ae3289_c5d5da81, _ae3289_c5d5da7y) or _ae3289_c5d5da81
    end;
    local _ae3289_c5d5da82 = _ae3289_c5d5da62(_ae3289_c5d5da7z);
    if not _ae3289_c5d5da82 then
      return nil
    end;
    local _ae3289_c5d5da83 = _ae3289_c5d5da2c(_ae3289_c5d5da82);
    if _ae3289_c5d5da83 == "" or _ae3289_c5d5da83 == "AND" then
      return nil
    end;
    _ae3289_c5d5da83 = _ae3289_c5d5da7y and string["rep"](_ae3289_c5d5da83, _ae3289_c5d5da7y) or _ae3289_c5d5da83;
    if _ae3289_c5d5da80 then
      _ae3289_c5d5da83 = _ae3289_c5d5da83 .. _ae3289_c5d5da80
    end;
    return _ae3289_c5d5da83
  end;
  function _ae3289_c5d5da1o(_ae3289_c5d5da84)
    local _ae3289_c5d5da85 = _ae3289_c5d5da6w(_ae3289_c5d5da84);
    local _ae3289_c5d5da86 = {};
    local _ae3289_c5d5da87, _ae3289_c5d5da88, _ae3289_c5d5da89 = {}, {}, {};
    local _ae3289_c5d5da8a = 0;
    for _ae3289_c5d5da8b, _ae3289_c5d5da8c in ipairs(_ae3289_c5d5da85)
    do
      local _ae3289_c5d5da8d, _ae3289_c5d5da8e = _ae3289_c5d5da7s(_ae3289_c5d5da8c);
      local _ae3289_c5d5da8f, _ae3289_c5d5da8g = pcall(_ae3289_c5d5da7w, _ae3289_c5d5da8d);
      if _ae3289_c5d5da8f and _ae3289_c5d5da8g and _ae3289_c5d5da8g ~= "" then
        local _ae3289_c5d5da8h = (_ae3289_c5d5da8e == "start" and _ae3289_c5d5da87) or(_ae3289_c5d5da8e == "end" and _ae3289_c5d5da89) or _ae3289_c5d5da88;
        _ae3289_c5d5da8h[#_ae3289_c5d5da8h + 1] = _ae3289_c5d5da8g;
        _ae3289_c5d5da86[#_ae3289_c5d5da86 + 1] = (_ae3289_c5d5da8d):sub(1, 34) .. " = " .. _ae3289_c5d5da8g
      else
        _ae3289_c5d5da8a = _ae3289_c5d5da8a + 1;
        _ae3289_c5d5da86[#_ae3289_c5d5da86 + 1] = (_ae3289_c5d5da8d):sub(1, 34) .. " = ?"
      end
    end;
    local _ae3289_c5d5da8i = {};
    for _ae3289_c5d5da8j, _ae3289_c5d5da8k in ipairs({_ae3289_c5d5da87, _ae3289_c5d5da88, _ae3289_c5d5da89})
    do
      for _ae3289_c5d5da8l, _ae3289_c5d5da8m in ipairs(_ae3289_c5d5da8k)
      do
        _ae3289_c5d5da8i[#_ae3289_c5d5da8i + 1] = _ae3289_c5d5da8m
      end
    end;
    if #_ae3289_c5d5da8i == 0 then
      return nil, _ae3289_c5d5da86, _ae3289_c5d5da8a
    end;
    return table["concat"](_ae3289_c5d5da8i, ""), _ae3289_c5d5da86, _ae3289_c5d5da8a
  end;
  function _ae3289_c5d5da1q(_ae3289_c5d5da8n)
    local _ae3289_c5d5da8o = _ae3289_c5d5da4p[_ae3289_c5d5da1n(_ae3289_c5d5da8n)];
    if type(_ae3289_c5d5da8o) == "string" and _ae3289_c5d5da8o ~= "" then
      return _ae3289_c5d5da8o
    end;
    return nil
  end;
  local _ae3289_c5d5da8p = {"what", "whats", "wat", "who", "whos", "when", "where", "which", "how", "name", "tell", "type", "say", "guess", "answer", "riddle", "spell", "is",};
  function _ae3289_c5d5da1p(_ae3289_c5d5da8q)
    local _ae3289_c5d5da8r = _ae3289_c5d5da1n(_ae3289_c5d5da8q);
    if _ae3289_c5d5da8r == "" or not(_ae3289_c5d5da8r):find(" ") then
      return false
    end;
    if(tostring(_ae3289_c5d5da8q)):find("?", 1, true) then
      return true
    end;
    local _ae3289_c5d5da8s = (_ae3289_c5d5da8r):match("^(%S+)");
    for _ae3289_c5d5da8t, _ae3289_c5d5da8u in ipairs(_ae3289_c5d5da8p)
    do
      if _ae3289_c5d5da8s == _ae3289_c5d5da8u then
        return true
      end
    end;
    if(_ae3289_c5d5da8r):find("%f[%a]my%f[%A]") then
      return true
    end;
    if(_ae3289_c5d5da8r):find("%f[%a]plus%f[%A]") or(_ae3289_c5d5da8r):find("+", 1, true) then
      return true
    end;
    if(_ae3289_c5d5da8r):find("favorite") or(_ae3289_c5d5da8r):find("favourite") then
      return true
    end;
    if(_ae3289_c5d5da8r):find("%f[%a]riddle%f[%A]") or(_ae3289_c5d5da8r):find("%f[%a]code%f[%A]") and(_ae3289_c5d5da8r):find("%f[%a]is%f[%A]") then
      return true
    end;
    return false
  end
end;
do
  function _ae3289_c5d5da21(_ae3289_c5d5da8v)
    local _ae3289_c5d5da8w = _ae3289_c5d5da8v;
    for _ae3289_c5d5da8x = 1, 12
    do
      if not _ae3289_c5d5da8w then
        break
      end;
      if _ae3289_c5d5da8w["Name"] == UI_NAME then
        return true
      end;
      _ae3289_c5d5da8w = _ae3289_c5d5da8w["Parent"]
    end;
    return false
  end;
  function _ae3289_c5d5da22(_ae3289_c5d5da8y)
    local _ae3289_c5d5da8z = _ae3289_c5d5da8y;
    while _ae3289_c5d5da8z
    do
      if(_ae3289_c5d5da8z):IsA("GuiObject") and not _ae3289_c5d5da8z["Visible"] then
        return false
      end;
      if(_ae3289_c5d5da8z):IsA("ScreenGui") then
        return _ae3289_c5d5da8z["Enabled"]
      end;
      _ae3289_c5d5da8z = _ae3289_c5d5da8z["Parent"]
    end;
    return true
  end;
  local function _ae3289_c5d5da90(_ae3289_c5d5da91)
    local _ae3289_c5d5da92 = {};
    for _ae3289_c5d5da93, _ae3289_c5d5da94 in ipairs((_ae3289_c5d5da91):GetChildren())
    do
      if(_ae3289_c5d5da94):IsA("ScreenGui") and _ae3289_c5d5da94["Enabled"] and not _ae3289_c5d5da21(_ae3289_c5d5da94) then
        for _ae3289_c5d5da95, _ae3289_c5d5da96 in ipairs((_ae3289_c5d5da94):GetDescendants())
        do
          if(_ae3289_c5d5da96):IsA("TextBox") and not _ae3289_c5d5da21(_ae3289_c5d5da96) then
            _ae3289_c5d5da92[#_ae3289_c5d5da92 + 1] = _ae3289_c5d5da96
          end
        end
      end
    end;
    return _ae3289_c5d5da92
  end;
  local function _ae3289_c5d5da97(_ae3289_c5d5da98)
    local _ae3289_c5d5da99 = {};
    for _ae3289_c5d5da9a, _ae3289_c5d5da9b in ipairs((_ae3289_c5d5da98):GetChildren())
    do
      if(_ae3289_c5d5da9b):IsA("ScreenGui") and _ae3289_c5d5da9b["Enabled"] and not _ae3289_c5d5da21(_ae3289_c5d5da9b) then
        for _ae3289_c5d5da9c, _ae3289_c5d5da9d in ipairs((_ae3289_c5d5da9b):GetDescendants())
        do
          if((_ae3289_c5d5da9d):IsA("TextButton") or(_ae3289_c5d5da9d):IsA("ImageButton")) and not _ae3289_c5d5da21(_ae3289_c5d5da9d) then
            local _ae3289_c5d5da9e = (_ae3289_c5d5da9d["Name"]):lower();
            local _ae3289_c5d5da9f = ((_ae3289_c5d5da9d["Parent"] and _ae3289_c5d5da9d["Parent"]["Name"] or "")):lower();
            if((_ae3289_c5d5da9e):find("code") or(_ae3289_c5d5da9e):find("redeem") or(_ae3289_c5d5da9f):find("code") or(_ae3289_c5d5da9f):find("redeem")) and _ae3289_c5d5da22(_ae3289_c5d5da9d) then
              _ae3289_c5d5da99[#_ae3289_c5d5da99 + 1] = _ae3289_c5d5da9d
            end
          end
        end
      end
    end;
    return _ae3289_c5d5da99
  end;
  local function _ae3289_c5d5da9g(_ae3289_c5d5da9h, ...)
    if typeof(_ae3289_c5d5dat) ~= "function" then
      return false
    end;
    local _ae3289_c5d5da9i, _ae3289_c5d5da9j = pcall(_ae3289_c5d5dat, _ae3289_c5d5da9h);
    if not _ae3289_c5d5da9i or type(_ae3289_c5d5da9j) ~= "table" then
      return false
    end;
    local _ae3289_c5d5da9k = table["pack"](...);
    local _ae3289_c5d5da9l = false;
    for _ae3289_c5d5da9m, _ae3289_c5d5da9n in ipairs(_ae3289_c5d5da9j)
    do
      local _ae3289_c5d5da9o = pcall(function()
        if _ae3289_c5d5da9n["Enabled"] ~= false then
          if _ae3289_c5d5da9k["n"] > 0 then
            (_ae3289_c5d5da9n):Fire(table["unpack"](_ae3289_c5d5da9k, 1, _ae3289_c5d5da9k["n"]))
          else
            (_ae3289_c5d5da9n):Fire()
          end
        end
      end);
      _ae3289_c5d5da9l = _ae3289_c5d5da9l or _ae3289_c5d5da9o
    end;
    return _ae3289_c5d5da9l
  end;
  local function _ae3289_c5d5da9p(_ae3289_c5d5da9q)
    if not _ae3289_c5d5da9q then
      return false
    end;
    local _ae3289_c5d5da9r = _ae3289_c5d5da9g(_ae3289_c5d5da9q["Activated"]);
    local _ae3289_c5d5da9s = _ae3289_c5d5da9g(_ae3289_c5d5da9q["MouseButton1Click"]);
    if _ae3289_c5d5da9r or _ae3289_c5d5da9s then
      return true
    end;
    if typeof(firesignal) == "function" then
      local _ae3289_c5d5da9t = pcall(firesignal, _ae3289_c5d5da9q["Activated"]);
      local _ae3289_c5d5da9u = pcall(firesignal, _ae3289_c5d5da9q["MouseButton1Click"]);
      if _ae3289_c5d5da9t or _ae3289_c5d5da9u then
        return true
      end
    end;
    if typeof(fireclick) == "function" and pcall(fireclick, _ae3289_c5d5da9q) then
      return true
    end;
    return false
  end;
  local function _ae3289_c5d5da9v(_ae3289_c5d5da9w)
    if not _ae3289_c5d5da9w then
      return false
    end;
    local _ae3289_c5d5da9x = false;
    if typeof(firesignal) == "function" then
      _ae3289_c5d5da9x = pcall(firesignal, _ae3289_c5d5da9w["FocusLost"], true) or _ae3289_c5d5da9x
    end;
    if typeof(_ae3289_c5d5dat) == "function" then
      local _ae3289_c5d5da9y, _ae3289_c5d5da9z = pcall(_ae3289_c5d5dat, _ae3289_c5d5da9w["FocusLost"]);
      if _ae3289_c5d5da9y and type(_ae3289_c5d5da9z) == "table" then
        for _ae3289_c5d5daa0, _ae3289_c5d5daa1 in ipairs(_ae3289_c5d5da9z)
        do
          local _ae3289_c5d5daa2;
          pcall(function()
            _ae3289_c5d5daa2 = _ae3289_c5d5daa1["Function"]
          end);
          if _ae3289_c5d5daa2 and typeof(_ae3289_c5d5das) == "function" and typeof(_ae3289_c5d5dau) == "function" then
            local _ae3289_c5d5daa3, _ae3289_c5d5daa4 = pcall(_ae3289_c5d5das, _ae3289_c5d5daa2);
            if _ae3289_c5d5daa3 and type(_ae3289_c5d5daa4) == "table" then
              for _ae3289_c5d5daa5, _ae3289_c5d5daa6 in pairs(_ae3289_c5d5daa4)
              do
                if type(_ae3289_c5d5daa6) == "boolean" and _ae3289_c5d5daa6 == true then
                  pcall(_ae3289_c5d5dau, _ae3289_c5d5daa2, _ae3289_c5d5daa5, false)
                end
              end
            end
          end;
          _ae3289_c5d5da9x = pcall(function()
            if _ae3289_c5d5daa1["Enabled"] ~= false then
              (_ae3289_c5d5daa1):Fire(true)
            end
          end) or _ae3289_c5d5da9x
        end
      end
    end;
    return _ae3289_c5d5da9x
  end;
  local function _ae3289_c5d5daa7(_ae3289_c5d5daa8)
    pcall(function()
      (_ae3289_c5d5daa8):ReleaseFocus(false)
    end)
  end;
  local function _ae3289_c5d5daa9()
    local _ae3289_c5d5daaa = PlayerGui or(LocalPlayer):FindFirstChildOfClass("PlayerGui");
    if not _ae3289_c5d5daaa then
      return nil, nil
    end;
    local _ae3289_c5d5daab = (_ae3289_c5d5daaa):FindFirstChild("Codes");
    if not _ae3289_c5d5daab then
      return nil, nil
    end;
    return((_ae3289_c5d5daab):FindFirstChild("Codes") or _ae3289_c5d5daab), _ae3289_c5d5daab
  end;
  function _ae3289_c5d5da23()
    local _ae3289_c5d5daac, _ae3289_c5d5daad = _ae3289_c5d5daa9();
    if _ae3289_c5d5daac then
      local _ae3289_c5d5daae = (_ae3289_c5d5daac):FindFirstChild("CodeRedeem", true);
      if _ae3289_c5d5daae then
        if(_ae3289_c5d5daae):IsA("TextBox") then
          return _ae3289_c5d5daae
        end;
        local _ae3289_c5d5daaf = (_ae3289_c5d5daae):FindFirstChildWhichIsA("TextBox", true);
        if _ae3289_c5d5daaf then
          return _ae3289_c5d5daaf
        end
      end;
      local _ae3289_c5d5daag = (_ae3289_c5d5daad):FindFirstChildWhichIsA("TextBox", true);
      if _ae3289_c5d5daag then
        return _ae3289_c5d5daag
      end
    end;
    local _ae3289_c5d5daah = PlayerGui or(LocalPlayer):FindFirstChildOfClass("PlayerGui");
    if _ae3289_c5d5daah then
      for _ae3289_c5d5daai, _ae3289_c5d5daaj in ipairs(_ae3289_c5d5da90(_ae3289_c5d5daah))
      do
        if _ae3289_c5d5da22(_ae3289_c5d5daaj) then
          return _ae3289_c5d5daaj
        end
      end
    end;
    return nil
  end;
  local function _ae3289_c5d5daak(_ae3289_c5d5daal)
    local _ae3289_c5d5daam = _ae3289_c5d5daa9();
    if _ae3289_c5d5daam then
      local _ae3289_c5d5daan = (_ae3289_c5d5daam):FindFirstChild("Confirm", true);
      if _ae3289_c5d5daan then
        if(_ae3289_c5d5daan):IsA("TextButton") or(_ae3289_c5d5daan):IsA("ImageButton") then
          return _ae3289_c5d5daan, true
        end;
        local _ae3289_c5d5daao = (_ae3289_c5d5daan):FindFirstChildWhichIsA("TextButton", true) or(_ae3289_c5d5daan):FindFirstChildWhichIsA("ImageButton", true);
        if _ae3289_c5d5daao then
          return _ae3289_c5d5daao, true
        end;
        if(_ae3289_c5d5daan):IsA("GuiObject") then
          return _ae3289_c5d5daan, true
        end
      end
    end;
    local _ae3289_c5d5daap = {"submit", "redeem", "claim", "confirm", "enter", "send", "apply", "ok", "use", "go", "check"};
    local _ae3289_c5d5daaq = _ae3289_c5d5daal and _ae3289_c5d5daal["Parent"];
    for _ae3289_c5d5daar = 1, 8
    do
      if not _ae3289_c5d5daaq then
        break
      end;
      for _ae3289_c5d5daas, _ae3289_c5d5daat in ipairs((_ae3289_c5d5daaq):GetDescendants())
      do
        if((_ae3289_c5d5daat):IsA("TextButton") or(_ae3289_c5d5daat):IsA("ImageButton")) and not _ae3289_c5d5da21(_ae3289_c5d5daat) and _ae3289_c5d5daat ~= _ae3289_c5d5daal then
          local _ae3289_c5d5daau = (_ae3289_c5d5daat["Name"]):lower();
          local _ae3289_c5d5daav = "";
          pcall(function()
            _ae3289_c5d5daav = (tostring(_ae3289_c5d5daat["Text"])):lower()
          end);
          for _ae3289_c5d5daaw, _ae3289_c5d5daax in ipairs(_ae3289_c5d5daap)
          do
            if((_ae3289_c5d5daau):find(_ae3289_c5d5daax) or(_ae3289_c5d5daav):find(_ae3289_c5d5daax)) and _ae3289_c5d5da22(_ae3289_c5d5daat) then
              return _ae3289_c5d5daat
            end
          end
        end
      end;
      _ae3289_c5d5daaq = _ae3289_c5d5daaq["Parent"]
    end;
    return nil
  end;
  _ae3289_c5d5da1e = {["ready"] = false, ["supported"] = false};
  _ae3289_c5d5da1f = function()
  end;
  _ae3289_c5d5da1b = function(_ae3289_c5d5daay, _ae3289_c5d5daaz)
    _ae3289_c5d5daay = tostring(_ae3289_c5d5daay or "");
    if _ae3289_c5d5daay == "" then
      return false, "empty code"
    end;
    local _ae3289_c5d5dab0 = PlayerGui or(LocalPlayer):FindFirstChildOfClass("PlayerGui");
    if not _ae3289_c5d5dab0 then
      return false, "no PlayerGui"
    end;
    local _ae3289_c5d5dab1 = (_ae3289_c5d5dab0):FindFirstChild("Codes");
    if _ae3289_c5d5dab1 then
      pcall(function()
        if(_ae3289_c5d5dab1):IsA("ScreenGui") then
          _ae3289_c5d5dab1["Enabled"] = true
        end;
        local _ae3289_c5d5dab2 = (_ae3289_c5d5dab1):FindFirstChild("Codes") or _ae3289_c5d5dab1;
        while _ae3289_c5d5dab2 and _ae3289_c5d5dab2 ~= _ae3289_c5d5dab1
        do
          if(_ae3289_c5d5dab2):IsA("GuiObject") then
            _ae3289_c5d5dab2["Visible"] = true
          end;
          _ae3289_c5d5dab2 = _ae3289_c5d5dab2["Parent"]
        end
      end)
    else
      for _ae3289_c5d5dab3, _ae3289_c5d5dab4 in ipairs(_ae3289_c5d5da97(_ae3289_c5d5dab0))
      do
        _ae3289_c5d5da9p(_ae3289_c5d5dab4)
      end;
      task["wait"]()
    end;
    local _ae3289_c5d5dab5 = _ae3289_c5d5da1e["box"];
    if _ae3289_c5d5dab5 and not(_ae3289_c5d5dab5["Parent"] and(_ae3289_c5d5dab5):IsDescendantOf(_ae3289_c5d5dab0)) then
      _ae3289_c5d5dab5, _ae3289_c5d5da1e["box"], _ae3289_c5d5da1e["btn"] = nil, nil, nil
    end;
    local _ae3289_c5d5dab6 = tick() + 1.0;
    if not _ae3289_c5d5dab5 then
      repeat
        _ae3289_c5d5dab5 = _ae3289_c5d5da23();
        if _ae3289_c5d5dab5 then
          break
        end;
        task["wait"]()
      until tick() > _ae3289_c5d5dab6
    end;
    if not _ae3289_c5d5dab5 then
      return false, "code box not found"
    end;
    if _ae3289_c5d5dab1 and(_ae3289_c5d5dab5):IsDescendantOf(_ae3289_c5d5dab1) then
      _ae3289_c5d5da1e["box"] = _ae3289_c5d5dab5
    end;
    if _ae3289_c5d5daaz then
      pcall(function()
        (_ae3289_c5d5dab5):CaptureFocus()
      end)
    end;
    if not pcall(function()
      _ae3289_c5d5dab5["Text"] = _ae3289_c5d5daay
    end) then
      return false, "text set failed"
    end;
    local _ae3289_c5d5dab7 = false;
    local _ae3289_c5d5dab8, _ae3289_c5d5dab9 = _ae3289_c5d5da1e["btn"], _ae3289_c5d5da1e["real"];
    if not(_ae3289_c5d5dab8 and _ae3289_c5d5dab8["Parent"]) then
      _ae3289_c5d5dab8, _ae3289_c5d5dab9 = _ae3289_c5d5daak(_ae3289_c5d5dab5);
      _ae3289_c5d5da1e["btn"], _ae3289_c5d5da1e["real"] = _ae3289_c5d5dab8, _ae3289_c5d5dab9
    end;
    if _ae3289_c5d5dab8 then
      _ae3289_c5d5dab7 = _ae3289_c5d5da9p(_ae3289_c5d5dab8)
    end;
    if not(_ae3289_c5d5dab7 and _ae3289_c5d5dab9) then
      _ae3289_c5d5dab7 = _ae3289_c5d5da9v(_ae3289_c5d5dab5) or _ae3289_c5d5dab7
    end;
    if _ae3289_c5d5daaz then
      _ae3289_c5d5daa7(_ae3289_c5d5dab5)
    end;
    return true, _ae3289_c5d5dab7 and "submitted" or "typed"
  end
end;
do
  local _ae3289_c5d5daba = "skyr0.wtf";
  local _ae3289_c5d5dabb = {["Bg"] = Color3["fromRGB"](17, 15, 26), ["Surface"] = Color3["fromRGB"](24, 21, 37), ["Card"] = Color3["fromRGB"](31, 27, 47), ["Row"] = Color3["fromRGB"](43,
    38, 64), ["RowHi"] = Color3["fromRGB"](56, 50, 82), ["Input"] = Color3["fromRGB"](20, 18, 32), ["Stroke"] = Color3["fromRGB"](60, 53, 88), ["Accent"] = Color3["fromRGB"](182, 128,
    255), ["Accent2"] = Color3["fromRGB"](124, 92, 255), ["Pink"] = Color3["fromRGB"](255, 140, 214), ["Text"] = Color3["fromRGB"](248, 246, 255), ["Dim"] = Color3["fromRGB"](164, 157,
    194), ["Faint"] = Color3["fromRGB"](110, 103, 140), ["Ok"] = Color3["fromRGB"](112, 236, 170), ["Err"] = Color3["fromRGB"](255, 102, 122), ["Warn"] = Color3["fromRGB"](255, 208,
    102), ["Off"] = Color3["fromRGB"](64, 58, 90), ["Dark"] = Color3["fromRGB"](24, 16, 38),};
  local _ae3289_c5d5dabc = Enum["Font"]["FredokaOne"];
  local _ae3289_c5d5dabd = Enum["Font"]["GothamMedium"];
  _ae3289_c5d5da1r = {["bg"] = _ae3289_c5d5dabb["Bg"], ["bgDeep"] = _ae3289_c5d5dabb["Input"], ["panel"] = _ae3289_c5d5dabb["Card"], ["panel2"] = _ae3289_c5d5dabb["Row"], ["line"] = _ae3289_c5d5dabb["Stroke"],
    ["accent"] = _ae3289_c5d5dabb["Accent"], ["accent2"] = _ae3289_c5d5dabb["Accent2"], ["accentHi"] = _ae3289_c5d5dabb["Accent"], ["text"] = _ae3289_c5d5dabb["Text"], ["sub"] = _ae3289_c5d5dabb["Dim"],
    ["ok"] = _ae3289_c5d5dabb["Ok"], ["err"] = _ae3289_c5d5dabb["Err"], ["warn"] = _ae3289_c5d5dabb["Warn"],};
  colors = {["dim"] = "rgb(164,157,194)", ["white"] = "rgb(248,246,255)", ["ok"] = "rgb(112,236,170)", ["err"] = "rgb(255,102,122)", ["warn"] = "rgb(255,208,102)", ["acc"] = "rgb(182,128,255)",
    ["cyan"] = "rgb(122,190,255)",};
  local function _ae3289_c5d5dabe(_ae3289_c5d5dabf, _ae3289_c5d5dabg, _ae3289_c5d5dabh)
    local _ae3289_c5d5dabi = Instance["new"](_ae3289_c5d5dabf);
    for _ae3289_c5d5dabj, _ae3289_c5d5dabk in pairs(_ae3289_c5d5dabg or {})
    do
      _ae3289_c5d5dabi[_ae3289_c5d5dabj] = _ae3289_c5d5dabk
    end;
    if _ae3289_c5d5dabh then
      _ae3289_c5d5dabi["Parent"] = _ae3289_c5d5dabh
    end;
    return _ae3289_c5d5dabi
  end;
  local function _ae3289_c5d5dabl(_ae3289_c5d5dabm, _ae3289_c5d5dabn)
    return _ae3289_c5d5dabe("UIGradient", {["Rotation"] = _ae3289_c5d5dabn or 0, ["Color"] = ColorSequence["new"](_ae3289_c5d5dabb["Accent"], _ae3289_c5d5dabb["Pink"])}, _ae3289_c5d5dabm)
  end;
  local _ae3289_c5d5dabo = false;
  pcall(function()
    _ae3289_c5d5dabo = UserInputService["TouchEnabled"] and not UserInputService["MouseEnabled"]
  end);
  local _ae3289_c5d5dabp = _ae3289_c5d5dabo and 40 or 0;
  local function _ae3289_c5d5dabq(_ae3289_c5d5dabr)
    return math["max"](_ae3289_c5d5dabr, _ae3289_c5d5dabp)
  end;
  local function _ae3289_c5d5dabs()
    local _ae3289_c5d5dabt = workspace["CurrentCamera"];
    return(_ae3289_c5d5dabt and _ae3289_c5d5dabt["ViewportSize"]) or Vector2["new"](1280, 720)
  end;
  local function _ae3289_c5d5dabu(_ae3289_c5d5dabv, _ae3289_c5d5dabw)
    return _ae3289_c5d5dabe("UICorner", {["CornerRadius"] = UDim["new"](0, _ae3289_c5d5dabw)}, _ae3289_c5d5dabv)
  end;
  local function _ae3289_c5d5dabx(_ae3289_c5d5daby, _ae3289_c5d5dabz, _ae3289_c5d5dac0, _ae3289_c5d5dac1)
    return _ae3289_c5d5dabe("UIStroke", {["Color"] = _ae3289_c5d5dabz or _ae3289_c5d5dabb["Stroke"], ["Thickness"] = _ae3289_c5d5dac0 or 1, ["Transparency"] = _ae3289_c5d5dac1 or 0,
      ["ApplyStrokeMode"] = Enum["ApplyStrokeMode"]["Border"]}, _ae3289_c5d5daby)
  end;
  local function _ae3289_c5d5dac2(_ae3289_c5d5dac3, _ae3289_c5d5dac4, _ae3289_c5d5dac5, _ae3289_c5d5dac6, _ae3289_c5d5dac7)
    return _ae3289_c5d5dabe("UIPadding", {["PaddingTop"] = UDim["new"](0, _ae3289_c5d5dac4), ["PaddingRight"] = UDim["new"](0, _ae3289_c5d5dac5 or _ae3289_c5d5dac4), ["PaddingBottom"] = UDim["new"](0,
      _ae3289_c5d5dac6 or _ae3289_c5d5dac4), ["PaddingLeft"] = UDim["new"](0, _ae3289_c5d5dac7 or _ae3289_c5d5dac5 or _ae3289_c5d5dac4)}, _ae3289_c5d5dac3)
  end;
  local function _ae3289_c5d5dac8(_ae3289_c5d5dac9, _ae3289_c5d5daca, _ae3289_c5d5dacb)
    return _ae3289_c5d5dabe("UIListLayout", {["SortOrder"] = Enum["SortOrder"]["LayoutOrder"], ["Padding"] = UDim["new"](0, _ae3289_c5d5daca or 6), ["FillDirection"] = _ae3289_c5d5dacb and Enum["FillDirection"]["Horizontal"] or Enum["FillDirection"]["Vertical"]},
      _ae3289_c5d5dac9)
  end;
  local function _ae3289_c5d5dacc(_ae3289_c5d5dacd, _ae3289_c5d5dace, _ae3289_c5d5dacf)
    pcall(function()
      ((TweenService):Create(_ae3289_c5d5dacd, TweenInfo["new"](_ae3289_c5d5dacf or 0.14, Enum["EasingStyle"]["Quint"], Enum["EasingDirection"]["Out"]), _ae3289_c5d5dace)):Play()
    end)
  end;
  local function _ae3289_c5d5dacg(_ae3289_c5d5dach, _ae3289_c5d5daci, _ae3289_c5d5dacj)
    pcall(function()
      ((TweenService):Create(_ae3289_c5d5dach, TweenInfo["new"](_ae3289_c5d5dacj or 0.28, Enum["EasingStyle"]["Back"], Enum["EasingDirection"]["Out"]), _ae3289_c5d5daci)):Play()
    end)
  end;
  local function _ae3289_c5d5dack(_ae3289_c5d5dacl, _ae3289_c5d5dacm, _ae3289_c5d5dacn, _ae3289_c5d5daco, _ae3289_c5d5dacp, _ae3289_c5d5dacq)
    return _ae3289_c5d5dabe("TextLabel", {["BackgroundTransparency"] = 1, ["Text"] = _ae3289_c5d5dacm, ["TextSize"] = _ae3289_c5d5dacn or 12, ["TextColor3"] = _ae3289_c5d5daco or _ae3289_c5d5dabb["Text"],
      ["Font"] = _ae3289_c5d5dacp or Enum["Font"]["GothamMedium"], ["TextXAlignment"] = _ae3289_c5d5dacq or Enum["TextXAlignment"]["Left"], ["TextYAlignment"] = Enum["TextYAlignment"]["Center"],
      }, _ae3289_c5d5dacl)
  end;
  local function _ae3289_c5d5dacr(_ae3289_c5d5dacs, _ae3289_c5d5dact, _ae3289_c5d5dacu)
    (_ae3289_c5d5dacs["MouseEnter"]):Connect(function()
      _ae3289_c5d5dacc(_ae3289_c5d5dacs, {["BackgroundColor3"] = _ae3289_c5d5dacu}, 0.12)
    end);
    (_ae3289_c5d5dacs["MouseLeave"]):Connect(function()
      _ae3289_c5d5dacc(_ae3289_c5d5dacs, {["BackgroundColor3"] = _ae3289_c5d5dact}, 0.12)
    end)
  end;
  local function _ae3289_c5d5dacv(_ae3289_c5d5dacw, _ae3289_c5d5dacx, _ae3289_c5d5dacy, _ae3289_c5d5dacz, _ae3289_c5d5dad0, _ae3289_c5d5dad1)
    local _ae3289_c5d5dad2 = _ae3289_c5d5dabe("TextButton", {["Size"] = UDim2["fromOffset"](_ae3289_c5d5dacy, _ae3289_c5d5dacz), ["BackgroundColor3"] = _ae3289_c5d5dad0 or _ae3289_c5d5dabb["Row"],
      ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Active"] = true, ["Text"] = _ae3289_c5d5dacx, ["TextSize"] = 11, ["TextColor3"] = _ae3289_c5d5dad1 or _ae3289_c5d5dabb["Text"],
      ["Font"] = _ae3289_c5d5dabc,}, _ae3289_c5d5dacw);
    _ae3289_c5d5dabu(_ae3289_c5d5dad2, math["floor"](_ae3289_c5d5dacz / 2));
    return _ae3289_c5d5dad2
  end;
  function _ae3289_c5d5da1w(_ae3289_c5d5dad3, _ae3289_c5d5dad4)
    local _ae3289_c5d5dad5 = (_ae3289_c5d5dad3):FindFirstChild("PressScale") or _ae3289_c5d5dabe("UIScale", {["Name"] = "PressScale"}, _ae3289_c5d5dad3);
    local _ae3289_c5d5dad6 = false;
    (_ae3289_c5d5dad3["InputBegan"]):Connect(function(_ae3289_c5d5dad7)
      local _ae3289_c5d5dad8 = _ae3289_c5d5dad7["UserInputType"];
      if _ae3289_c5d5dad8 == Enum["UserInputType"]["MouseButton1"] or _ae3289_c5d5dad8 == Enum["UserInputType"]["Touch"] then
        _ae3289_c5d5dad6 = true;
        _ae3289_c5d5dacc(_ae3289_c5d5dad5, {["Scale"] = 0.9}, 0.08)
      end
    end);
    (_ae3289_c5d5dad3["InputEnded"]):Connect(function(_ae3289_c5d5dad9)
      local _ae3289_c5d5dada = _ae3289_c5d5dad9["UserInputType"];
      if _ae3289_c5d5dada == Enum["UserInputType"]["MouseButton1"] or _ae3289_c5d5dada == Enum["UserInputType"]["Touch"] then
        local _ae3289_c5d5dadb = _ae3289_c5d5dad6;
        _ae3289_c5d5dad6 = false;
        _ae3289_c5d5dacg(_ae3289_c5d5dad5, {["Scale"] = 1}, 0.32);
        if _ae3289_c5d5dadb then
          task["spawn"](function()
            local _ae3289_c5d5dadc, _ae3289_c5d5dadd = pcall(_ae3289_c5d5dad4);
            if not _ae3289_c5d5dadc then
              warn("[skyr0.wtf] ui: " .. tostring(_ae3289_c5d5dadd))
            end
          end)
        end
      end
    end)
  end;
  pcall(function()
    for _ae3289_c5d5dade, _ae3289_c5d5dadf in ipairs({UI_NAME, "Skyr0WtfUI", "ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste", "GuiznxRiddle"})
    do
      local _ae3289_c5d5dadg = (PlayerGui):FindFirstChild(_ae3289_c5d5dadf);
      if _ae3289_c5d5dadg then
        (_ae3289_c5d5dadg):Destroy()
      end;
      local _ae3289_c5d5dadh = CoreGui and(CoreGui):FindFirstChild(_ae3289_c5d5dadf);
      if _ae3289_c5d5dadh then
        (_ae3289_c5d5dadh):Destroy()
      end
    end
  end);
  ownGui = _ae3289_c5d5dabe("ScreenGui", {["Name"] = UI_NAME, ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true, ["DisplayOrder"] = 9999999, ["ZIndexBehavior"] = Enum["ZIndexBehavior"]["Sibling"],
    }, PlayerGui);
  local _ae3289_c5d5dadi = _ae3289_c5d5dabe("Frame", {["Name"] = "Skyr0_MasterFrame", ["BackgroundTransparency"] = 1, ["BorderSizePixel"] = 0, ["Size"] = UDim2["new"](1, 0, 1, 0)}, ownGui);
  local _ae3289_c5d5dadj = _ae3289_c5d5dabe("UIScale", {["Name"] = "Skyr0_GlobalScale", ["Scale"] = 1}, _ae3289_c5d5dadi);
  local function _ae3289_c5d5dadk()
    local _ae3289_c5d5dadl = workspace["CurrentCamera"];
    if not _ae3289_c5d5dadl then
      return
    end;
    local _ae3289_c5d5dadm = _ae3289_c5d5dadl["ViewportSize"]["Y"];
    local _ae3289_c5d5dadn = UserInputService["TouchEnabled"] and math["clamp"](_ae3289_c5d5dadm / 1000, 0.52, 0.78) or math["clamp"](_ae3289_c5d5dadm / 800, 0.72, 1.0);
    _ae3289_c5d5dadj["Scale"] = _ae3289_c5d5dadn;
    _ae3289_c5d5dadi["Size"] = UDim2["new"](1 / _ae3289_c5d5dadn, 0, 1 / _ae3289_c5d5dadn, 0)
  end;
  local function _ae3289_c5d5dado()
    if _ae3289_c5d5da1v then
      pcall(function()
        (_ae3289_c5d5da1v):Disconnect()
      end)
    end;
    local _ae3289_c5d5dadp = workspace["CurrentCamera"];
    if _ae3289_c5d5dadp then
      _ae3289_c5d5da1v = ((_ae3289_c5d5dadp):GetPropertyChangedSignal("ViewportSize")):Connect(_ae3289_c5d5dadk)
    end;
    _ae3289_c5d5dadk()
  end;
  _ae3289_c5d5da24(((workspace):GetPropertyChangedSignal("CurrentCamera")):Connect(_ae3289_c5d5dado));
  task["spawn"](_ae3289_c5d5dado);
  local _ae3289_c5d5dadq, _ae3289_c5d5dadr = 460, 520;
  if _ae3289_c5d5dabo then
    local _ae3289_c5d5dads = _ae3289_c5d5dabs();
    _ae3289_c5d5dadq = math["floor"](math["clamp"](_ae3289_c5d5dads["X"] * 0.92, 340, 470));
    _ae3289_c5d5dadr = math["floor"](math["clamp"](_ae3289_c5d5dads["Y"] * 0.84, 380, 600))
  end;
  local _ae3289_c5d5dadt = 60;
  local _ae3289_c5d5dadu = _ae3289_c5d5dabe("Frame", {["Name"] = "CodeRedeemer", ["Size"] = UDim2["fromOffset"](_ae3289_c5d5dadq, _ae3289_c5d5dadr), ["Position"] = UDim2["new"](1, -(_ae3289_c5d5dadq + 24),
    0, 44), ["BackgroundTransparency"] = 1, ["Active"] = true,}, _ae3289_c5d5dadi);
  _ae3289_c5d5dabe("ImageLabel", {["Name"] = "Shadow", ["AnchorPoint"] = Vector2["new"](0.5, 0.5), ["Position"] = UDim2["fromScale"](0.5, 0.5), ["Size"] = UDim2["new"](1, 60, 1, 60),
    ["BackgroundTransparency"] = 1, ["Image"] = "rbxassetid://6015897843", ["ImageColor3"] = Color3["new"](0, 0, 0), ["ImageTransparency"] = 0.4, ["ScaleType"] = Enum["ScaleType"]["Slice"],
    ["SliceCenter"] = Rect["new"](49, 49, 450, 450), ["ZIndex"] = 0,}, _ae3289_c5d5dadu);
  local _ae3289_c5d5dadv = _ae3289_c5d5dabe("Frame", {["Name"] = "Window", ["Size"] = UDim2["fromScale"](1, 1), ["BackgroundColor3"] = _ae3289_c5d5dabb["Bg"], ["BorderSizePixel"] = 0,
    ["ClipsDescendants"] = true, ["Active"] = true,}, _ae3289_c5d5dadu);
  _ae3289_c5d5dabu(_ae3289_c5d5dadv, 22);
  local _ae3289_c5d5dadw = _ae3289_c5d5dabx(_ae3289_c5d5dadv, _ae3289_c5d5dabb["Stroke"], 1.5, 0);
  local _ae3289_c5d5dadx = _ae3289_c5d5dabe("Frame", {["Name"] = "Header", ["Size"] = UDim2["new"](1, 0, 0, _ae3289_c5d5dadt), ["BackgroundColor3"] = _ae3289_c5d5dabb["Surface"], ["BorderSizePixel"] = 0,
    ["Active"] = true}, _ae3289_c5d5dadv);
  _ae3289_c5d5dabe("UIGradient", {["Rotation"] = 90, ["Transparency"] = NumberSequence["new"](0, 0.35)}, _ae3289_c5d5dadx);
  local _ae3289_c5d5dady = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](36, 36), ["Position"] = UDim2["fromOffset"](16, 12), ["BackgroundColor3"] = Color3["new"](1, 1, 1),
    ["BorderSizePixel"] = 0}, _ae3289_c5d5dadx);
  _ae3289_c5d5dabu(_ae3289_c5d5dady, 18);
  _ae3289_c5d5dabl(_ae3289_c5d5dady, 45);
  local _ae3289_c5d5dadz = _ae3289_c5d5dack(_ae3289_c5d5dady, "s0", 14, _ae3289_c5d5dabb["Dark"], _ae3289_c5d5dabc, Enum["TextXAlignment"]["Center"]);
  _ae3289_c5d5dadz["Size"] = UDim2["fromScale"](1, 1);
  _ae3289_c5d5da1u = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](10, 10), ["Position"] = UDim2["new"](1, -7, 1, -7), ["BackgroundColor3"] = _ae3289_c5d5dabb["Off"], ["BorderSizePixel"] = 0,
    ["ZIndex"] = 3}, _ae3289_c5d5dady);
  _ae3289_c5d5dabu(_ae3289_c5d5da1u, 5);
  _ae3289_c5d5dabx(_ae3289_c5d5da1u, _ae3289_c5d5dabb["Surface"], 2, 0);
  local _ae3289_c5d5dae0 = _ae3289_c5d5dack(_ae3289_c5d5dadx, "", 15, _ae3289_c5d5dabb["Text"], _ae3289_c5d5dabc);
  _ae3289_c5d5dae0["RichText"] = true;
  _ae3289_c5d5dae0["Text"] = "skyr0<font color=\"" .. colors["acc"] .. "\">.wtf</font>";
  _ae3289_c5d5dae0["Size"] = UDim2["new"](1, -200, 0, 20);
  _ae3289_c5d5dae0["Position"] = UDim2["fromOffset"](62, 11);
  _ae3289_c5d5dae0["TextSize"] = 18;
  local _ae3289_c5d5dae1 = _ae3289_c5d5dack(_ae3289_c5d5dadx, "code redeemer", 11, _ae3289_c5d5dabb["Dim"], Enum["Font"]["GothamMedium"]);
  _ae3289_c5d5dae1["Size"] = UDim2["new"](1, -200, 0, 14);
  _ae3289_c5d5dae1["Position"] = UDim2["fromOffset"](62, 33);
  _ae3289_c5d5dae1["RichText"] = true;
  local function _ae3289_c5d5dae2(_ae3289_c5d5dae3, _ae3289_c5d5dae4)
    local _ae3289_c5d5dae5 = _ae3289_c5d5dabo and 34 or 28;
    local _ae3289_c5d5dae6 = _ae3289_c5d5dacv(_ae3289_c5d5dadx, _ae3289_c5d5dae3, _ae3289_c5d5dae5, _ae3289_c5d5dae5, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Dim"]);
    _ae3289_c5d5dae6["Position"] = UDim2["new"](1, _ae3289_c5d5dae4 - _ae3289_c5d5dae5, 0.5, -_ae3289_c5d5dae5 / 2);
    _ae3289_c5d5dae6["TextSize"] = 14;
    _ae3289_c5d5dacr(_ae3289_c5d5dae6, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["RowHi"]);
    return _ae3289_c5d5dae6
  end;
  local _ae3289_c5d5dae7 = _ae3289_c5d5dae2("\195\151", -14);
  local _ae3289_c5d5dae8 = _ae3289_c5d5dae2("\226\128\147", _ae3289_c5d5dabo and -54 or -48);
  local _ae3289_c5d5dae9 = _ae3289_c5d5dabe("TextButton", {["Name"] = "Power", ["Size"] = UDim2["fromOffset"](52, 28), ["Position"] = UDim2["new"](1, _ae3289_c5d5dabo and -148 or -136,
    0.5, -14), ["BackgroundColor3"] = _ae3289_c5d5dabb["Off"], ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Active"] = true, ["Text"] = "",}, _ae3289_c5d5dadx);
  _ae3289_c5d5dabu(_ae3289_c5d5dae9, 14);
  local _ae3289_c5d5daea = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](22, 22), ["Position"] = UDim2["new"](0, 3, 0.5, -11), ["BackgroundColor3"] = _ae3289_c5d5dabb["Text"],
    ["BorderSizePixel"] = 0}, _ae3289_c5d5dae9);
  _ae3289_c5d5dabu(_ae3289_c5d5daea, 11);
  local _ae3289_c5d5daeb = {"Sniper", "Riddle", "Test", "Console"};
  local _ae3289_c5d5daec = _ae3289_c5d5dabq(36);
  local _ae3289_c5d5daed = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, -28, 0, _ae3289_c5d5daec), ["Position"] = UDim2["fromOffset"](14, _ae3289_c5d5dadt + 2), ["BackgroundColor3"] = _ae3289_c5d5dabb["Surface"],
    ["BorderSizePixel"] = 0}, _ae3289_c5d5dadv);
  _ae3289_c5d5dabu(_ae3289_c5d5daed, _ae3289_c5d5daec / 2);
  _ae3289_c5d5dabx(_ae3289_c5d5daed, _ae3289_c5d5dabb["Stroke"], 1.5, 0.2);
  local _ae3289_c5d5daee = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1 / #_ae3289_c5d5daeb, -8, 1, -8), ["Position"] = UDim2["new"](0, 4, 0, 4), ["BackgroundColor3"] = Color3["new"](1,
    1, 1), ["BorderSizePixel"] = 0}, _ae3289_c5d5daed);
  _ae3289_c5d5dabu(_ae3289_c5d5daee, (_ae3289_c5d5daec - 8) / 2);
  _ae3289_c5d5dabl(_ae3289_c5d5daee, 0);
  local _ae3289_c5d5daef = 32;
  local _ae3289_c5d5daeg = _ae3289_c5d5dadt + 2 + _ae3289_c5d5daec + 12;
  local _ae3289_c5d5daeh = _ae3289_c5d5dabe("Frame", {["Name"] = "Pages", ["Size"] = UDim2["new"](1, -28, 1, -(_ae3289_c5d5daeg + _ae3289_c5d5daef + 20)), ["Position"] = UDim2["fromOffset"](14,
    _ae3289_c5d5daeg), ["BackgroundTransparency"] = 1}, _ae3289_c5d5dadv);
  local _ae3289_c5d5daei, _ae3289_c5d5daej = {}, {};
  local function _ae3289_c5d5daek(_ae3289_c5d5dael, _ae3289_c5d5daem)
    local _ae3289_c5d5daen;
    if _ae3289_c5d5daem then
      _ae3289_c5d5daen = _ae3289_c5d5dabe("ScrollingFrame", {["Name"] = _ae3289_c5d5dael, ["Size"] = UDim2["fromScale"](1, 1), ["BackgroundTransparency"] = 1, ["BorderSizePixel"] = 0,
        ["ScrollBarThickness"] = 3, ["ScrollBarImageColor3"] = _ae3289_c5d5dabb["Accent"], ["ScrollingDirection"] = Enum["ScrollingDirection"]["Y"], ["CanvasSize"] = UDim2["new"](),
        ["AutomaticCanvasSize"] = Enum["AutomaticSize"]["Y"], ["Visible"] = false,}, _ae3289_c5d5daeh);
      _ae3289_c5d5dac8(_ae3289_c5d5daen, 10);
      _ae3289_c5d5dac2(_ae3289_c5d5daen, 0, 4, 8, 0)
    else
      _ae3289_c5d5daen = _ae3289_c5d5dabe("Frame", {["Name"] = _ae3289_c5d5dael, ["Size"] = UDim2["fromScale"](1, 1), ["BackgroundTransparency"] = 1, ["Visible"] = false}, _ae3289_c5d5daeh)
    end;
    _ae3289_c5d5daei[_ae3289_c5d5dael] = _ae3289_c5d5daen;
    return _ae3289_c5d5daen
  end;
  local function _ae3289_c5d5daeo(_ae3289_c5d5daep)
    for _ae3289_c5d5daeq, _ae3289_c5d5daer in pairs(_ae3289_c5d5daei)
    do
      _ae3289_c5d5daer["Visible"] = (_ae3289_c5d5daeq == _ae3289_c5d5daep)
    end;
    for _ae3289_c5d5daes, _ae3289_c5d5daet in ipairs(_ae3289_c5d5daeb)
    do
      local _ae3289_c5d5daeu = _ae3289_c5d5daej[_ae3289_c5d5daet];
      if _ae3289_c5d5daeu then
        _ae3289_c5d5dacc(_ae3289_c5d5daeu, {["TextColor3"] = (_ae3289_c5d5daet == _ae3289_c5d5daep) and _ae3289_c5d5dabb["Dark"] or _ae3289_c5d5dabb["Dim"]}, 0.16)
      end;
      if _ae3289_c5d5daet == _ae3289_c5d5daep then
        _ae3289_c5d5dacg(_ae3289_c5d5daee, {["Position"] = UDim2["new"]((_ae3289_c5d5daes - 1) / #_ae3289_c5d5daeb, 4, 0, 4)}, 0.35)
      end
    end
  end;
  for _ae3289_c5d5daev, _ae3289_c5d5daew in ipairs(_ae3289_c5d5daeb)
  do
    local _ae3289_c5d5daex = _ae3289_c5d5dabe("TextButton", {["Size"] = UDim2["new"](1 / #_ae3289_c5d5daeb, 0, 1, 0), ["Position"] = UDim2["new"]((_ae3289_c5d5daev - 1) / #_ae3289_c5d5daeb,
      0, 0, 0), ["BackgroundTransparency"] = 1, ["Text"] = _ae3289_c5d5daew, ["TextColor3"] = _ae3289_c5d5dabb["Dim"], ["Font"] = _ae3289_c5d5dabc, ["TextSize"] = 14, ["AutoButtonColor"] = false,
      ["ZIndex"] = 2,}, _ae3289_c5d5daed);
    _ae3289_c5d5daej[_ae3289_c5d5daew] = _ae3289_c5d5daex;
    _ae3289_c5d5da1w(_ae3289_c5d5daex, function()
      _ae3289_c5d5daeo(_ae3289_c5d5daew)
    end)
  end;
  local function _ae3289_c5d5daey(_ae3289_c5d5daez, _ae3289_c5d5daf0, _ae3289_c5d5daf1)
    local _ae3289_c5d5daf2 = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 0), ["AutomaticSize"] = Enum["AutomaticSize"]["Y"], ["BackgroundColor3"] = _ae3289_c5d5dabb["Card"],
      ["BorderSizePixel"] = 0, ["LayoutOrder"] = _ae3289_c5d5daf0}, _ae3289_c5d5daez);
    _ae3289_c5d5dabu(_ae3289_c5d5daf2, 20);
    _ae3289_c5d5dabx(_ae3289_c5d5daf2, _ae3289_c5d5dabb["Stroke"], 1.5, 0.35);
    _ae3289_c5d5dabe("UIGradient", {["Rotation"] = 90, ["Color"] = ColorSequence["new"](Color3["new"](1, 1, 1), Color3["fromRGB"](205, 200, 225))}, _ae3289_c5d5daf2);
    _ae3289_c5d5dac2(_ae3289_c5d5daf2, 14, 16);
    _ae3289_c5d5dac8(_ae3289_c5d5daf2, 10);
    if _ae3289_c5d5daf1 then
      local _ae3289_c5d5daf3 = _ae3289_c5d5dack(_ae3289_c5d5daf2, _ae3289_c5d5daf1, 13, _ae3289_c5d5dabb["Accent"], _ae3289_c5d5dabc);
      _ae3289_c5d5daf3["Size"] = UDim2["new"](1, 0, 0, 16);
      _ae3289_c5d5daf3["LayoutOrder"] = -100
    end;
    return _ae3289_c5d5daf2
  end;
  local function _ae3289_c5d5daf4(_ae3289_c5d5daf5, _ae3289_c5d5daf6, _ae3289_c5d5daf7, _ae3289_c5d5daf8)
    local _ae3289_c5d5daf9 = _ae3289_c5d5dack(_ae3289_c5d5daf5, _ae3289_c5d5daf6, 14, _ae3289_c5d5dabb["Text"], _ae3289_c5d5dabc);
    _ae3289_c5d5daf9["TextTruncate"] = Enum["TextTruncate"]["AtEnd"];
    if _ae3289_c5d5daf7 then
      _ae3289_c5d5daf9["Size"] = UDim2["new"](1, -_ae3289_c5d5daf8, 0, 16);
      _ae3289_c5d5daf9["Position"] = UDim2["fromOffset"](0, 2);
      local _ae3289_c5d5dafa = _ae3289_c5d5dack(_ae3289_c5d5daf5, _ae3289_c5d5daf7, 11, _ae3289_c5d5dabb["Dim"], _ae3289_c5d5dabd);
      _ae3289_c5d5dafa["Size"] = UDim2["new"](1, -_ae3289_c5d5daf8, 0, 14);
      _ae3289_c5d5dafa["Position"] = UDim2["fromOffset"](0, 19);
      _ae3289_c5d5dafa["TextTruncate"] = Enum["TextTruncate"]["AtEnd"]
    else
      _ae3289_c5d5daf9["Size"] = UDim2["new"](1, -_ae3289_c5d5daf8, 1, 0)
    end
  end;
  local function _ae3289_c5d5dafb(_ae3289_c5d5dafc, _ae3289_c5d5dafd, _ae3289_c5d5dafe, _ae3289_c5d5daff, _ae3289_c5d5dafg, _ae3289_c5d5dafh)
    local _ae3289_c5d5dafi = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, _ae3289_c5d5dabq(_ae3289_c5d5daff and 38 or 28)), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = _ae3289_c5d5dafd},
      _ae3289_c5d5dafc);
    _ae3289_c5d5daf4(_ae3289_c5d5dafi, _ae3289_c5d5dafe, _ae3289_c5d5daff, 66);
    local _ae3289_c5d5dafj = _ae3289_c5d5dabe("TextButton", {["Size"] = UDim2["fromOffset"](50, 28), ["Position"] = UDim2["new"](1, -50, 0.5, -14), ["BackgroundColor3"] = _ae3289_c5d5dabb["Off"],
      ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Active"] = true, ["Text"] = ""}, _ae3289_c5d5dafi);
    _ae3289_c5d5dabu(_ae3289_c5d5dafj, 14);
    local _ae3289_c5d5dafk = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](22, 22), ["BackgroundColor3"] = _ae3289_c5d5dabb["Text"], ["BorderSizePixel"] = 0}, _ae3289_c5d5dafj);
    _ae3289_c5d5dabu(_ae3289_c5d5dafk, 11);
    local _ae3289_c5d5dafl = _ae3289_c5d5dafg and true or false;
    local function _ae3289_c5d5dafm(_ae3289_c5d5dafn)
      local _ae3289_c5d5dafo = _ae3289_c5d5dafl and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Off"];
      local _ae3289_c5d5dafp = _ae3289_c5d5dafl and UDim2["new"](1, -25, 0.5, -11) or UDim2["new"](0, 3, 0.5, -11);
      if _ae3289_c5d5dafn then
        _ae3289_c5d5dacc(_ae3289_c5d5dafj, {["BackgroundColor3"] = _ae3289_c5d5dafo}, 0.16);
        _ae3289_c5d5dacg(_ae3289_c5d5dafk, {["Position"] = _ae3289_c5d5dafp}, 0.32)
      else
        _ae3289_c5d5dafj["BackgroundColor3"] = _ae3289_c5d5dafo;
        _ae3289_c5d5dafk["Position"] = _ae3289_c5d5dafp
      end
    end;
    _ae3289_c5d5dafm(false);
    _ae3289_c5d5da1w(_ae3289_c5d5dafj, function()
      _ae3289_c5d5dafl = not _ae3289_c5d5dafl;
      _ae3289_c5d5dafm(true);
      _ae3289_c5d5dafh(_ae3289_c5d5dafl)
    end);
    return function(_ae3289_c5d5dafq)
      _ae3289_c5d5dafl = _ae3289_c5d5dafq and true or false;
      _ae3289_c5d5dafm(true)
    end
  end;
  local function _ae3289_c5d5dafr(_ae3289_c5d5dafs, _ae3289_c5d5daft)
    _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">" .. _ae3289_c5d5dafs .. " </font><font color=\"" .. (_ae3289_c5d5daft and colors["ok"] or colors["err"]) .. "\">" .. (_ae3289_c5d5daft and "on" or "off") .. "</font>")
  end;
  local function _ae3289_c5d5dafu(_ae3289_c5d5dafv, _ae3289_c5d5dafw, _ae3289_c5d5dafx, _ae3289_c5d5dafy, _ae3289_c5d5dafz, _ae3289_c5d5dag0)
    return _ae3289_c5d5dafb(_ae3289_c5d5dafv, _ae3289_c5d5dafw, _ae3289_c5d5dafx, _ae3289_c5d5dafy, settings[_ae3289_c5d5dafz], function(_ae3289_c5d5dag1)
      settings[_ae3289_c5d5dafz] = _ae3289_c5d5dag1;
      saveSettings();
      _ae3289_c5d5dafr((_ae3289_c5d5dafx):lower(), _ae3289_c5d5dag1);
      if _ae3289_c5d5dag0 then
        _ae3289_c5d5dag0(_ae3289_c5d5dag1)
      end
    end)
  end;
  local function _ae3289_c5d5dag2(_ae3289_c5d5dag3, _ae3289_c5d5dag4, _ae3289_c5d5dag5, _ae3289_c5d5dag6, _ae3289_c5d5dag7, _ae3289_c5d5dag8, _ae3289_c5d5dag9, _ae3289_c5d5daga)
    local _ae3289_c5d5dagb = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, _ae3289_c5d5dabq(38)), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = _ae3289_c5d5dag4}, _ae3289_c5d5dag3);
    _ae3289_c5d5daf4(_ae3289_c5d5dagb, _ae3289_c5d5dag5, _ae3289_c5d5dag6, 120);
    local _ae3289_c5d5dagc = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](112, 32), ["Position"] = UDim2["new"](1, -112, 0.5, -16), ["BackgroundColor3"] = _ae3289_c5d5dabb["Input"],
      ["BorderSizePixel"] = 0}, _ae3289_c5d5dagb);
    _ae3289_c5d5dabu(_ae3289_c5d5dagc, 16);
    _ae3289_c5d5dabx(_ae3289_c5d5dagc, _ae3289_c5d5dabb["Stroke"], 1.5, 0.2);
    local _ae3289_c5d5dagd = _ae3289_c5d5dacv(_ae3289_c5d5dagc, "\226\128\147", 26, 26, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Text"]);
    local _ae3289_c5d5dage = _ae3289_c5d5dacv(_ae3289_c5d5dagc, "+", 26, 26, Color3["new"](1, 1, 1), _ae3289_c5d5dabb["Dark"]);
    _ae3289_c5d5dabl(_ae3289_c5d5dage, 45);
    _ae3289_c5d5dagd["Position"] = UDim2["fromOffset"](3, 3);
    _ae3289_c5d5dage["Position"] = UDim2["new"](1, -29, 0, 3);
    _ae3289_c5d5dagd["TextSize"], _ae3289_c5d5dage["TextSize"] = 16, 16;
    _ae3289_c5d5dacr(_ae3289_c5d5dagd, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["RowHi"]);
    local _ae3289_c5d5dagf = _ae3289_c5d5dack(_ae3289_c5d5dagc, tostring(_ae3289_c5d5dag9()), 16, _ae3289_c5d5dabb["Text"], _ae3289_c5d5dabc, Enum["TextXAlignment"]["Center"]);
    _ae3289_c5d5dagf["Size"] = UDim2["new"](1, -60, 1, 0);
    _ae3289_c5d5dagf["Position"] = UDim2["fromOffset"](30, 0);
    local _ae3289_c5d5dagg = _ae3289_c5d5dabe("UIScale", {}, _ae3289_c5d5dagf);
    local function _ae3289_c5d5dagh(_ae3289_c5d5dagi)
      local _ae3289_c5d5dagj = math["clamp"](_ae3289_c5d5dag9() + _ae3289_c5d5dagi, _ae3289_c5d5dag7, _ae3289_c5d5dag8);
      if _ae3289_c5d5dagj == _ae3289_c5d5dag9() then
        return
      end;
      _ae3289_c5d5daga(_ae3289_c5d5dagj);
      _ae3289_c5d5dagf["Text"] = tostring(_ae3289_c5d5dagj);
      _ae3289_c5d5dagg["Scale"] = 1.35;
      _ae3289_c5d5dacg(_ae3289_c5d5dagg, {["Scale"] = 1}, 0.3)
    end;
    _ae3289_c5d5da1w(_ae3289_c5d5dagd, function()
      _ae3289_c5d5dagh(-1)
    end);
    _ae3289_c5d5da1w(_ae3289_c5d5dage, function()
      _ae3289_c5d5dagh(1)
    end);
    return function()
      _ae3289_c5d5dagf["Text"] = tostring(_ae3289_c5d5dag9())
    end
  end;
  local function _ae3289_c5d5dagk(_ae3289_c5d5dagl, _ae3289_c5d5dagm, _ae3289_c5d5dagn, _ae3289_c5d5dago, _ae3289_c5d5dagp, _ae3289_c5d5dagq, _ae3289_c5d5dagr)
    _ae3289_c5d5dagr = _ae3289_c5d5dagr or 190;
    local _ae3289_c5d5dags = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, _ae3289_c5d5dabq(34)), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = _ae3289_c5d5dagm}, _ae3289_c5d5dagl);
    _ae3289_c5d5daf4(_ae3289_c5d5dags, _ae3289_c5d5dagn, nil, _ae3289_c5d5dagr + 6);
    local _ae3289_c5d5dagt = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](_ae3289_c5d5dagr, _ae3289_c5d5dabq(32)), ["Position"] = UDim2["new"](1, -_ae3289_c5d5dagr, 0.5,
      -_ae3289_c5d5dabq(32) / 2), ["BackgroundColor3"] = _ae3289_c5d5dabb["Input"], ["BorderSizePixel"] = 0}, _ae3289_c5d5dags);
    _ae3289_c5d5dabu(_ae3289_c5d5dagt, _ae3289_c5d5dabq(32) / 2);
    _ae3289_c5d5dabx(_ae3289_c5d5dagt, _ae3289_c5d5dabb["Stroke"], 1.5, 0.2);
    local _ae3289_c5d5dagu = {};
    local function _ae3289_c5d5dagv(_ae3289_c5d5dagw)
      for _ae3289_c5d5dagx, _ae3289_c5d5dagy in pairs(_ae3289_c5d5dagu)
      do
        local _ae3289_c5d5dagz = (_ae3289_c5d5dagx == _ae3289_c5d5dagw);
        _ae3289_c5d5dacc(_ae3289_c5d5dagy, {["BackgroundTransparency"] = _ae3289_c5d5dagz and 0 or 1, ["TextColor3"] = _ae3289_c5d5dagz and _ae3289_c5d5dabb["Dark"] or _ae3289_c5d5dabb["Dim"]},
          0.14)
      end
    end;
    for _ae3289_c5d5dah0, _ae3289_c5d5dah1 in ipairs(_ae3289_c5d5dago)
    do
      local _ae3289_c5d5dah2 = _ae3289_c5d5dabe("TextButton", {["Size"] = UDim2["new"](1 / #_ae3289_c5d5dago, -4, 1, -4), ["Position"] = UDim2["new"]((_ae3289_c5d5dah0 - 1) / #_ae3289_c5d5dago,
        2, 0, 2), ["BackgroundColor3"] = Color3["new"](1, 1, 1), ["BackgroundTransparency"] = 1, ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Text"] = _ae3289_c5d5dah1["label"],
        ["TextSize"] = 13, ["Font"] = _ae3289_c5d5dabc, ["TextColor3"] = _ae3289_c5d5dabb["Dim"],}, _ae3289_c5d5dagt);
      _ae3289_c5d5dabu(_ae3289_c5d5dah2, (_ae3289_c5d5dabq(32) - 4) / 2);
      _ae3289_c5d5dabl(_ae3289_c5d5dah2, 0);
      _ae3289_c5d5dagu[_ae3289_c5d5dah1["value"]] = _ae3289_c5d5dah2;
      _ae3289_c5d5da1w(_ae3289_c5d5dah2, function()
        _ae3289_c5d5dagq(_ae3289_c5d5dah1["value"]);
        _ae3289_c5d5dagv(_ae3289_c5d5dah1["value"])
      end)
    end;
    _ae3289_c5d5dagv(_ae3289_c5d5dagp);
    return _ae3289_c5d5dagv
  end;
  local function _ae3289_c5d5dah3(_ae3289_c5d5dah4, _ae3289_c5d5dah5, _ae3289_c5d5dah6)
    local _ae3289_c5d5dah7 = _ae3289_c5d5dabe("TextBox", {["BackgroundColor3"] = _ae3289_c5d5dabb["Input"], ["BorderSizePixel"] = 0, ["ClearTextOnFocus"] = false, ["Text"] = _ae3289_c5d5dah6 or "",
      ["PlaceholderText"] = _ae3289_c5d5dah5, ["PlaceholderColor3"] = _ae3289_c5d5dabb["Faint"], ["TextSize"] = 13, ["Font"] = _ae3289_c5d5dabd, ["TextColor3"] = _ae3289_c5d5dabb["Text"],
      ["TextXAlignment"] = Enum["TextXAlignment"]["Left"], ["TextTruncate"] = Enum["TextTruncate"]["AtEnd"],}, _ae3289_c5d5dah4);
    _ae3289_c5d5dabu(_ae3289_c5d5dah7, 17);
    local _ae3289_c5d5dah8 = _ae3289_c5d5dabx(_ae3289_c5d5dah7, _ae3289_c5d5dabb["Stroke"], 1.5, 0.1);
    _ae3289_c5d5dac2(_ae3289_c5d5dah7, 0, 12, 0, 14);
    (_ae3289_c5d5dah7["Focused"]):Connect(function()
      _ae3289_c5d5dacc(_ae3289_c5d5dah8, {["Color"] = _ae3289_c5d5dabb["Accent"]}, 0.12)
    end);
    (_ae3289_c5d5dah7["FocusLost"]):Connect(function()
      _ae3289_c5d5dacc(_ae3289_c5d5dah8, {["Color"] = _ae3289_c5d5dabb["Stroke"]}, 0.12)
    end);
    return _ae3289_c5d5dah7
  end;
  local function _ae3289_c5d5dah9(_ae3289_c5d5daha, _ae3289_c5d5dahb, _ae3289_c5d5dahc, _ae3289_c5d5dahd)
    local _ae3289_c5d5dahe = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, _ae3289_c5d5dabq(36)), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = _ae3289_c5d5dahb}, _ae3289_c5d5daha);
    local _ae3289_c5d5dahf = _ae3289_c5d5dah3(_ae3289_c5d5dahe, _ae3289_c5d5dahc);
    _ae3289_c5d5dahf["Size"] = UDim2["new"](1, -86, 1, 0);
    local _ae3289_c5d5dahg = _ae3289_c5d5dacv(_ae3289_c5d5dahe, _ae3289_c5d5dahd, 80, _ae3289_c5d5dabq(36), Color3["new"](1, 1, 1), _ae3289_c5d5dabb["Dark"]);
    _ae3289_c5d5dahg["Position"] = UDim2["new"](1, -80, 0, 0);
    _ae3289_c5d5dahg["TextSize"] = 14;
    _ae3289_c5d5dabl(_ae3289_c5d5dahg, 45);
    return _ae3289_c5d5dahf, _ae3289_c5d5dahg
  end;
  local function _ae3289_c5d5dahh(_ae3289_c5d5dahi, _ae3289_c5d5dahj, _ae3289_c5d5dahk)
    local _ae3289_c5d5dahl = _ae3289_c5d5dack(_ae3289_c5d5dahi, _ae3289_c5d5dahk, 11, _ae3289_c5d5dabb["Dim"], _ae3289_c5d5dabd);
    _ae3289_c5d5dahl["Size"] = UDim2["new"](1, 0, 0, 0);
    _ae3289_c5d5dahl["AutomaticSize"] = Enum["AutomaticSize"]["Y"];
    _ae3289_c5d5dahl["TextWrapped"] = true;
    _ae3289_c5d5dahl["LayoutOrder"] = _ae3289_c5d5dahj;
    return _ae3289_c5d5dahl
  end;
  local _ae3289_c5d5dahm = {};
  do
    local _ae3289_c5d5dahn = _ae3289_c5d5daek("Sniper", true);
    local _ae3289_c5d5daho = _ae3289_c5d5daey(_ae3289_c5d5dahn, 1);
    local _ae3289_c5d5dahp = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 22), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = 1}, _ae3289_c5d5daho);
    local _ae3289_c5d5dahq = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, -108, 1, 0), ["BackgroundTransparency"] = 1}, _ae3289_c5d5dahp);
    local _ae3289_c5d5dahr = _ae3289_c5d5dac8(_ae3289_c5d5dahq, 6, true);
    _ae3289_c5d5dahr["VerticalAlignment"] = Enum["VerticalAlignment"]["Center"];
    _ae3289_c5d5dahm["state"] = _ae3289_c5d5dack(_ae3289_c5d5dahq, "LISTENING", 15, _ae3289_c5d5dabb["Accent"], _ae3289_c5d5dabc);
    _ae3289_c5d5dahm["state"]["Size"] = UDim2["new"](0, 0, 1, 0);
    _ae3289_c5d5dahm["state"]["AutomaticSize"] = Enum["AutomaticSize"]["X"];
    _ae3289_c5d5dahm["round"] = _ae3289_c5d5dabe("TextLabel", {["Size"] = UDim2["fromOffset"](0, 22), ["AutomaticSize"] = Enum["AutomaticSize"]["X"], ["BackgroundColor3"] = _ae3289_c5d5dabb["Row"],
      ["Text"] = "", ["TextSize"] = 11, ["Font"] = _ae3289_c5d5dabc, ["TextColor3"] = _ae3289_c5d5dabb["Dim"], ["BorderSizePixel"] = 0, ["LayoutOrder"] = 2}, _ae3289_c5d5dahq);
    _ae3289_c5d5dabu(_ae3289_c5d5dahm["round"], 11);
    _ae3289_c5d5dac2(_ae3289_c5d5dahm["round"], 0, 10, 0, 10);
    _ae3289_c5d5dahm["badge"] = _ae3289_c5d5dabe("TextLabel", {["Size"] = UDim2["fromOffset"](100, 22), ["Position"] = UDim2["new"](1, -100, 0, 0), ["BackgroundColor3"] = _ae3289_c5d5dabb["Row"],
      ["Text"] = "IDLE", ["TextSize"] = 11, ["Font"] = _ae3289_c5d5dabc, ["TextColor3"] = _ae3289_c5d5dabb["Dim"], ["BorderSizePixel"] = 0}, _ae3289_c5d5dahp);
    _ae3289_c5d5dabu(_ae3289_c5d5dahm["badge"], 11);
    local _ae3289_c5d5dahs = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 52), ["BackgroundColor3"] = _ae3289_c5d5dabb["Input"], ["BorderSizePixel"] = 0, ["LayoutOrder"] = 2},
      _ae3289_c5d5daho);
    _ae3289_c5d5dabu(_ae3289_c5d5dahs, 16);
    _ae3289_c5d5dahm["codeStroke"] = _ae3289_c5d5dabx(_ae3289_c5d5dahs, _ae3289_c5d5dabb["Stroke"], 1.5, 0);
    _ae3289_c5d5dahm["code"] = _ae3289_c5d5dack(_ae3289_c5d5dahs, "waiting for code...", 20, _ae3289_c5d5dabb["Faint"], _ae3289_c5d5dabc, Enum["TextXAlignment"]["Center"]);
    _ae3289_c5d5dahm["code"]["Size"] = UDim2["new"](1, -20, 1, 0);
    _ae3289_c5d5dahm["code"]["Position"] = UDim2["fromOffset"](10, 0);
    _ae3289_c5d5dahm["code"]["TextTruncate"] = Enum["TextTruncate"]["AtEnd"];
    local _ae3289_c5d5daht = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 16), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = 3}, _ae3289_c5d5daho);
    _ae3289_c5d5dahm["parts"] = _ae3289_c5d5dack(_ae3289_c5d5daht, "0 parts", 12, _ae3289_c5d5dabb["Dim"], _ae3289_c5d5dabd);
    _ae3289_c5d5dahm["parts"]["Size"] = UDim2["new"](0.62, 0, 1, 0);
    _ae3289_c5d5dahm["parts"]["RichText"] = true;
    _ae3289_c5d5dahm["stats"] = _ae3289_c5d5dack(_ae3289_c5d5daht, "0 solved / 0 asked", 12, _ae3289_c5d5dabb["Dim"], _ae3289_c5d5dabd, Enum["TextXAlignment"]["Right"]);
    _ae3289_c5d5dahm["stats"]["Size"] = UDim2["new"](0.38, 0, 1, 0);
    _ae3289_c5d5dahm["stats"]["Position"] = UDim2["fromScale"](0.62, 0);
    _ae3289_c5d5dahm["pips"] = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 8), ["BackgroundTransparency"] = 1, ["LayoutOrder"] = 4}, _ae3289_c5d5daho);
    local _ae3289_c5d5dahu = _ae3289_c5d5dac8(_ae3289_c5d5dahm["pips"], 5, true);
    _ae3289_c5d5dahu["HorizontalAlignment"] = Enum["HorizontalAlignment"]["Left"];
    local _ae3289_c5d5dahv = _ae3289_c5d5daey(_ae3289_c5d5dahn, 2, "code sniper");
    _ae3289_c5d5dahm["codeSw"] = _ae3289_c5d5dafb(_ae3289_c5d5dahv, 1, "Code Sniper", "types the code parts sammy announces", settings["sniper"], function(_ae3289_c5d5dahw)
      settings["sniper"] = _ae3289_c5d5dahw;
      saveSettings();
      _ae3289_c5d5da1k();
      _ae3289_c5d5da1d();
      _ae3289_c5d5dafr("code sniper", _ae3289_c5d5dahw)
    end);
    _ae3289_c5d5dag2(_ae3289_c5d5dahv, 2, "Submit After", "parts before the first try (1 = every part)", 1, 10, function()
      return settings["submitAfter"]
    end, function(_ae3289_c5d5dahx)
      settings["submitAfter"] = _ae3289_c5d5dahx;
      saveSettings();
      _ae3289_c5d5da1d();
      _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">submit after </font><font color=\"" .. colors["white"] .. "\">" .. _ae3289_c5d5dahx .. (_ae3289_c5d5dahx == 1 and " part" or " parts") .. "</font>")
    end);
    _ae3289_c5d5dahh(_ae3289_c5d5dahv, 3, "invalid at N parts -> waits for part N+1 and tries once more. invalid again -> stops (a new code starts after 10s of quiet)");
    _ae3289_c5d5dafu(_ae3289_c5d5dahv, 4, "Auto Submit", "redeem as soon as the code is ready", "autoSubmit");
    _ae3289_c5d5dafu(_ae3289_c5d5dahv, 5, "Retype Invalid", "put a rejected code back in the box", "retypeInvalid");
    local _ae3289_c5d5dahy = _ae3289_c5d5daey(_ae3289_c5d5dahn, 3, "auto switch");
    _ae3289_c5d5dafu(_ae3289_c5d5dahy, 1, "Auto Switch", "sammy's keywords turn the right mode on", "autoSwitch");
    _ae3289_c5d5dahh(_ae3289_c5d5dahy, 2, "USE CODE / code is / type code ... -> Code Sniper on, Riddle Solver off\nUSE RIDDLE / riddle is / solve this ... -> Riddle Solver on, Code Sniper off")
  end;
  do
    local _ae3289_c5d5dahz = _ae3289_c5d5daek("Riddle", true);
    local _ae3289_c5d5dai0 = _ae3289_c5d5daey(_ae3289_c5d5dahz, 1, "riddle solver");
    _ae3289_c5d5dahm["riddleSw"] = _ae3289_c5d5dafb(_ae3289_c5d5dai0, 1, "Riddle Solver", "answers sammy's riddles - the answer is one full code", settings["riddler"], function(_ae3289_c5d5dai1)
      settings["riddler"] = _ae3289_c5d5dai1;
      saveSettings();
      _ae3289_c5d5da1k();
      _ae3289_c5d5dafr("riddle solver", _ae3289_c5d5dai1)
    end);
    _ae3289_c5d5dahm["lastRiddle"] = _ae3289_c5d5dahh(_ae3289_c5d5dai0, 2, "no riddle yet");
    _ae3289_c5d5dahm["lastRiddle"]["RichText"] = true;
    _ae3289_c5d5dahm["liveInfo"] = _ae3289_c5d5dahh(_ae3289_c5d5dai0, 3, "live: reading the game...");
    _ae3289_c5d5dahm["liveInfo"]["RichText"] = true;
    local _ae3289_c5d5dai2 = _ae3289_c5d5daey(_ae3289_c5d5dahz, 2, "answer engine");
    _ae3289_c5d5dagk(_ae3289_c5d5dai2, 1, "Answer with", {{["label"] = "Both", ["value"] = "both"}, {["label"] = "Local", ["value"] = "db"}, {["label"] = "AI", ["value"] = "ai"}}, settings["answerMode"],
      function(_ae3289_c5d5dai3)
      settings["answerMode"] = _ae3289_c5d5dai3;
      saveSettings();
      _ae3289_c5d5dafr("answer engine -> " .. _ae3289_c5d5dai3, true)
    end);
    _ae3289_c5d5dahh(_ae3289_c5d5dai2, 2, "both: the local DB answers instantly and goes first, the AI runs at the same time and covers what local missed");
    _ae3289_c5d5dafu(_ae3289_c5d5dai2, 3, "Try ALT + Variants", "plural / suffix variants when a code fails", "tryVariants");
    local _ae3289_c5d5dai4 = _ae3289_c5d5daey(_ae3289_c5d5dahz, 3, "ai");
    _ae3289_c5d5dahm["aiInfo"] = _ae3289_c5d5dahh(_ae3289_c5d5dai4, 1, "model " .. tostring(aiConfig["model"]) .. "  |  no request yet");
    _ae3289_c5d5dahm["aiInfo"]["RichText"] = true;
    _ae3289_c5d5dag2(_ae3289_c5d5dai4, 2, "Backup Requests", "extra model tried if no answer in 2.5s", 1, 3, function()
      return settings["aiRace"]
    end, function(_ae3289_c5d5dai5)
      settings["aiRace"] = _ae3289_c5d5dai5;
      saveSettings()
    end);
    local _ae3289_c5d5dai6 = _ae3289_c5d5daey(_ae3289_c5d5dahz, 4, "api keys");
    _ae3289_c5d5dahh(_ae3289_c5d5dai6, 1, "keys come from API_KEYS at the top of the script. tested on startup, a bad or rate limited key is skipped");
    _ae3289_c5d5dahm["keyList"] = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 0), ["AutomaticSize"] = Enum["AutomaticSize"]["Y"], ["BackgroundTransparency"] = 1, ["LayoutOrder"] = 2},
      _ae3289_c5d5dai6);
    _ae3289_c5d5dac8(_ae3289_c5d5dahm["keyList"], 6);
    local _ae3289_c5d5dai7 = _ae3289_c5d5dacv(_ae3289_c5d5dai6, "TEST ALL KEYS", 140, _ae3289_c5d5dabq(30), _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Text"]);
    _ae3289_c5d5dai7["LayoutOrder"] = 4;
    _ae3289_c5d5dacr(_ae3289_c5d5dai7, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["RowHi"]);
    _ae3289_c5d5da1w(_ae3289_c5d5dai7, function()
      _ae3289_c5d5da20["toast"]("testing api keys...", _ae3289_c5d5dabb["Accent"]);
      apiKeys["testAll"]()
    end);
    local _ae3289_c5d5dai8 = _ae3289_c5d5daey(_ae3289_c5d5dahz, 5, "event override");
    local _ae3289_c5d5dai9 = _ae3289_c5d5dah3(_ae3289_c5d5dai8, "blank = auto detect", settings["activeEvent"]);
    _ae3289_c5d5dai9["Size"] = UDim2["new"](1, 0, 0, _ae3289_c5d5dabq(34));
    _ae3289_c5d5dai9["LayoutOrder"] = 1;
    (_ae3289_c5d5dai9["FocusLost"]):Connect(function()
      local _ae3289_c5d5daia = _ae3289_c5d5da26(_ae3289_c5d5dai9["Text"]);
      if _ae3289_c5d5daia == settings["activeEvent"] then
        return
      end;
      settings["activeEvent"] = _ae3289_c5d5daia;
      saveSettings();
      _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">event override: </font><font color=\"" .. colors["white"] .. "\">" .. (_ae3289_c5d5daia ~= "" and _ae3289_c5d5da2e(_ae3289_c5d5daia) or "auto") .. "</font>")
    end);
    local _ae3289_c5d5daib = _ae3289_c5d5daey(_ae3289_c5d5dahz, 6, "riddle tester");
    _ae3289_c5d5dahh(_ae3289_c5d5daib, 1, "runs the local DB AND the AI, and submits both answers so you can see each one work");
    _ae3289_c5d5da1s, _ae3289_c5d5da1t = _ae3289_c5d5dah9(_ae3289_c5d5daib, 2, "test a riddle...", "SOLVE")
  end;
  do
    local _ae3289_c5d5daic = _ae3289_c5d5daek("Test", true);
    local _ae3289_c5d5daid = _ae3289_c5d5daey(_ae3289_c5d5daic, 1, "fake announcement");
    _ae3289_c5d5dahh(_ae3289_c5d5daid, 1, "auto = exactly like a real announcement (try USE CODE, code is SKY, riddle is ...). the sniper types and redeems whatever comes out");
    state["testAs"] = "auto";
    _ae3289_c5d5dagk(_ae3289_c5d5daid, 2, "Send as", {{["label"] = "Auto", ["value"] = "auto"}, {["label"] = "Part", ["value"] = "part"}, {["label"] = "Full", ["value"] = "full"}, {["label"] = "Riddle",
      ["value"] = "riddle"}}, "auto", function(_ae3289_c5d5daie)
      state["testAs"] = _ae3289_c5d5daie
    end, 236);
    _ae3289_c5d5da1x, _ae3289_c5d5da1y = _ae3289_c5d5dah9(_ae3289_c5d5daid, 3, "announcement text...", "SEND")
  end;
  local _ae3289_c5d5daif;
  do
    local _ae3289_c5d5daig = _ae3289_c5d5daek("Console", false);
    local _ae3289_c5d5daih = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 26), ["BackgroundTransparency"] = 1}, _ae3289_c5d5daig);
    local _ae3289_c5d5daii = _ae3289_c5d5dack(_ae3289_c5d5daih, "CONSOLE", 10, _ae3289_c5d5dabb["Faint"], _ae3289_c5d5dabc);
    _ae3289_c5d5daii["Size"] = UDim2["new"](0.5, 0, 1, 0);
    local _ae3289_c5d5daij = _ae3289_c5d5dacv(_ae3289_c5d5daih, "CLEAR", 64, 26, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Text"]);
    _ae3289_c5d5daij["Position"] = UDim2["new"](1, -64, 0, 0);
    _ae3289_c5d5dacr(_ae3289_c5d5daij, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["RowHi"]);
    local _ae3289_c5d5daik = _ae3289_c5d5dacv(_ae3289_c5d5daih, "COPY", 64, 26, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Text"]);
    _ae3289_c5d5daik["Position"] = UDim2["new"](1, -134, 0, 0);
    _ae3289_c5d5dacr(_ae3289_c5d5daik, _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["RowHi"]);
    _ae3289_c5d5dahm["clearBtn"], _ae3289_c5d5dahm["copyBtn"] = _ae3289_c5d5daij, _ae3289_c5d5daik;
    _ae3289_c5d5daif = _ae3289_c5d5dabe("ScrollingFrame", {["Size"] = UDim2["new"](1, 0, 1, -32), ["Position"] = UDim2["fromOffset"](0, 32), ["BackgroundColor3"] = _ae3289_c5d5dabb["Input"],
      ["BorderSizePixel"] = 0, ["ScrollBarThickness"] = 3, ["ScrollBarImageColor3"] = _ae3289_c5d5dabb["Accent"], ["ScrollingDirection"] = Enum["ScrollingDirection"]["Y"], ["CanvasSize"] = UDim2["new"](),
      ["AutomaticCanvasSize"] = Enum["AutomaticSize"]["Y"], ["ElasticBehavior"] = Enum["ElasticBehavior"]["WhenScrollable"],}, _ae3289_c5d5daig);
    _ae3289_c5d5dabu(_ae3289_c5d5daif, 18);
    _ae3289_c5d5dabx(_ae3289_c5d5daif, _ae3289_c5d5dabb["Stroke"], 1, 0.2);
    _ae3289_c5d5dac8(_ae3289_c5d5daif, 2);
    _ae3289_c5d5dac2(_ae3289_c5d5daif, 10, 12, 10, 12)
  end;
  local _ae3289_c5d5dail = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, -28, 0, _ae3289_c5d5daef), ["Position"] = UDim2["new"](0, 14, 1, -(_ae3289_c5d5daef + 12)), ["BackgroundColor3"] = _ae3289_c5d5dabb["Surface"],
    ["BorderSizePixel"] = 0}, _ae3289_c5d5dadv);
  _ae3289_c5d5dabu(_ae3289_c5d5dail, _ae3289_c5d5daef / 2);
  _ae3289_c5d5dabx(_ae3289_c5d5dail, _ae3289_c5d5dabb["Stroke"], 1, 0.25);
  local _ae3289_c5d5daim = _ae3289_c5d5dack(_ae3289_c5d5dail, "", 11, _ae3289_c5d5dabb["Dim"], Enum["Font"]["Code"]);
  _ae3289_c5d5daim["Size"] = UDim2["new"](1, -100, 1, 0);
  _ae3289_c5d5daim["Position"] = UDim2["fromOffset"](14, 0);
  _ae3289_c5d5daim["RichText"] = true;
  _ae3289_c5d5daim["TextTruncate"] = Enum["TextTruncate"]["AtEnd"];
  local _ae3289_c5d5dain = _ae3289_c5d5dack(_ae3289_c5d5dail, _ae3289_c5d5daba, 11, _ae3289_c5d5dabb["Accent"], _ae3289_c5d5dabc, Enum["TextXAlignment"]["Right"]);
  _ae3289_c5d5dain["Size"] = UDim2["new"](0, 80, 1, 0);
  _ae3289_c5d5dain["Position"] = UDim2["new"](1, -94, 0, 0);
  _ae3289_c5d5dain["TextSize"] = 13;
  do
    local _ae3289_c5d5daio = getService("Stats");
    local function _ae3289_c5d5daip()
      local _ae3289_c5d5daiq, _ae3289_c5d5dair = pcall(function()
        return(_ae3289_c5d5daio["Network"]["ServerStatsItem"]["Data Ping"]):GetValue()
      end);
      if _ae3289_c5d5daiq and type(_ae3289_c5d5dair) == "number" then
        return math["floor"](_ae3289_c5d5dair + 0.5)
      end;
      return nil
    end;
    local _ae3289_c5d5dais, _ae3289_c5d5dait = 0, 0;
    _ae3289_c5d5da24((RunService["RenderStepped"]):Connect(function(_ae3289_c5d5daiu)
      _ae3289_c5d5dais = _ae3289_c5d5dais + 1;
      _ae3289_c5d5dait = _ae3289_c5d5dait + (_ae3289_c5d5daiu);
      if _ae3289_c5d5dait < 0.5 then
        return
      end;
      local _ae3289_c5d5daiv = math["floor"](_ae3289_c5d5dais / _ae3289_c5d5dait + 0.5);
      _ae3289_c5d5dais, _ae3289_c5d5dait = 0, 0;
      if not _ae3289_c5d5daim["Parent"] or not _ae3289_c5d5dadu["Visible"] then
        return
      end;
      local _ae3289_c5d5daiw = _ae3289_c5d5daip();
      local _ae3289_c5d5daix = _ae3289_c5d5daiv >= 50 and colors["ok"] or(_ae3289_c5d5daiv >= 30 and colors["warn"] or colors["err"]);
      local _ae3289_c5d5daiy = settings["directRemote"] and _ae3289_c5d5da1e and _ae3289_c5d5da1e["ready"] and _ae3289_c5d5da1e["jobId"] == game["JobId"];
      local _ae3289_c5d5daiz = _ae3289_c5d5daiy and "linked" or(settings["directRemote"] and((_ae3289_c5d5da1e and _ae3289_c5d5da1e["supported"]) and "learning" or "ui") or "ui");
      local _ae3289_c5d5daj0 = _ae3289_c5d5dahm["aiMs"];
      _ae3289_c5d5daim["Text"] = "<font color=\"" .. _ae3289_c5d5daix .. "\">" .. _ae3289_c5d5daiv .. "fps</font>" .. "<font color=\"" .. colors["dim"] .. "\">  " .. (_ae3289_c5d5daiw and(_ae3289_c5d5daiw .. "ms") or "--") .. "</font>" .. "<font color=\"" .. colors["dim"] .. "\">  remote </font><font color=\"" .. (_ae3289_c5d5daiy and colors["ok"] or colors["dim"]) .. "\">" .. _ae3289_c5d5daiz .. "</font>" .. "<font color=\"" .. colors["dim"] .. "\">  ai </font><font color=\"" .. (_ae3289_c5d5daj0 and(_ae3289_c5d5daj0 < 3000 and colors["ok"] or colors["warn"]) or colors["dim"]) .. "\">" .. (_ae3289_c5d5daj0 and(_ae3289_c5d5daj0 .. "ms") or "--") .. "</font>"
    end))
  end;
  local _ae3289_c5d5daj1 = _ae3289_c5d5dabe("Frame", {["Name"] = "Skyr0_Toasts", ["AnchorPoint"] = Vector2["new"](1, 1), ["Position"] = UDim2["new"](1, -18, 1, -18), ["Size"] = UDim2["fromOffset"](330,
    320), ["BackgroundTransparency"] = 1}, _ae3289_c5d5dadi);
  do
    local _ae3289_c5d5daj2 = _ae3289_c5d5dac8(_ae3289_c5d5daj1, 6);
    _ae3289_c5d5daj2["VerticalAlignment"] = Enum["VerticalAlignment"]["Bottom"];
    _ae3289_c5d5daj2["HorizontalAlignment"] = Enum["HorizontalAlignment"]["Right"]
  end;
  local _ae3289_c5d5daj3 = 0;
  local function _ae3289_c5d5daj4(_ae3289_c5d5daj5, _ae3289_c5d5daj6)
    _ae3289_c5d5daj3 = _ae3289_c5d5daj3 + 1;
    local _ae3289_c5d5daj7 = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](330, 40), ["BackgroundColor3"] = _ae3289_c5d5dabb["Surface"], ["BackgroundTransparency"] = 1, ["BorderSizePixel"] = 0,
      ["LayoutOrder"] = _ae3289_c5d5daj3}, _ae3289_c5d5daj1);
    _ae3289_c5d5dabu(_ae3289_c5d5daj7, 20);
    local _ae3289_c5d5daj8 = _ae3289_c5d5dabe("UIScale", {["Scale"] = 0.6}, _ae3289_c5d5daj7);
    _ae3289_c5d5dacg(_ae3289_c5d5daj8, {["Scale"] = 1}, 0.35);
    local _ae3289_c5d5daj9 = _ae3289_c5d5dabx(_ae3289_c5d5daj7, _ae3289_c5d5daj6 or _ae3289_c5d5dabb["Accent"], 1, 1);
    local _ae3289_c5d5daja = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](0, 8, 0, 8), ["Position"] = UDim2["new"](0, 14, 0.5, -4), ["BackgroundColor3"] = _ae3289_c5d5daj6 or _ae3289_c5d5dabb["Accent"],
      ["BackgroundTransparency"] = 1, ["BorderSizePixel"] = 0}, _ae3289_c5d5daj7);
    _ae3289_c5d5dabu(_ae3289_c5d5daja, 4);
    local _ae3289_c5d5dajb = _ae3289_c5d5dack(_ae3289_c5d5daj7, _ae3289_c5d5daj5, 13, _ae3289_c5d5dabb["Text"], _ae3289_c5d5dabc);
    _ae3289_c5d5dajb["Size"] = UDim2["new"](1, -40, 1, 0);
    _ae3289_c5d5dajb["Position"] = UDim2["fromOffset"](30, 0);
    _ae3289_c5d5dajb["TextTruncate"] = Enum["TextTruncate"]["AtEnd"];
    _ae3289_c5d5dajb["RichText"] = true;
    _ae3289_c5d5dajb["TextTransparency"] = 1;
    _ae3289_c5d5dacc(_ae3289_c5d5daj7, {["BackgroundTransparency"] = 0.05}, 0.2);
    _ae3289_c5d5dacc(_ae3289_c5d5daj9, {["Transparency"] = 0.3}, 0.2);
    _ae3289_c5d5dacc(_ae3289_c5d5daja, {["BackgroundTransparency"] = 0}, 0.2);
    _ae3289_c5d5dacc(_ae3289_c5d5dajb, {["TextTransparency"] = 0}, 0.2);
    local _ae3289_c5d5dajc = {};
    for _ae3289_c5d5dajd, _ae3289_c5d5daje in ipairs((_ae3289_c5d5daj1):GetChildren())
    do
      if(_ae3289_c5d5daje):IsA("Frame") then
        _ae3289_c5d5dajc[#_ae3289_c5d5dajc + 1] = _ae3289_c5d5daje
      end
    end;
    if #_ae3289_c5d5dajc > 4 then
      table["sort"](_ae3289_c5d5dajc, function(_ae3289_c5d5dajf, _ae3289_c5d5dajg)
        return _ae3289_c5d5dajf["LayoutOrder"] < _ae3289_c5d5dajg["LayoutOrder"]
      end);
      (_ae3289_c5d5dajc[1]):Destroy()
    end;
    task["delay"](3.2, function()
      if not _ae3289_c5d5daj7["Parent"] then
        return
      end;
      _ae3289_c5d5dacc(_ae3289_c5d5daj7, {["BackgroundTransparency"] = 1}, 0.25);
      _ae3289_c5d5dacc(_ae3289_c5d5daj9, {["Transparency"] = 1}, 0.25);
      _ae3289_c5d5dacc(_ae3289_c5d5daja, {["BackgroundTransparency"] = 1}, 0.25);
      _ae3289_c5d5dacc(_ae3289_c5d5dajb, {["TextTransparency"] = 1}, 0.25);
      task["delay"](0.3, function()
        if _ae3289_c5d5daj7["Parent"] then
          (_ae3289_c5d5daj7):Destroy()
        end
      end)
    end)
  end;
  local _ae3289_c5d5dajh = {["idle"] = {"IDLE", _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Dim"]}, ["wait"] = {"WAITING", _ae3289_c5d5dabb["Row"], _ae3289_c5d5dabb["Warn"]}, ["sent"] = {"SENDING",
    _ae3289_c5d5dabb["Accent"], _ae3289_c5d5dabb["Dark"]}, ["ok"] = {"REDEEMED", _ae3289_c5d5dabb["Ok"], _ae3289_c5d5dabb["Dark"]}, ["used"] = {"VALID (USED)", _ae3289_c5d5dabb["Ok"],
    _ae3289_c5d5dabb["Dark"]}, ["bad"] = {"INVALID", _ae3289_c5d5dabb["Err"], _ae3289_c5d5dabb["Dark"]}, ["think"] = {"AI THINKING", _ae3289_c5d5dabb["Accent2"], _ae3289_c5d5dabb["Text"]},
    ["fail"] = {"FAILED", _ae3289_c5d5dabb["Err"], _ae3289_c5d5dabb["Dark"]},};
  _ae3289_c5d5da20 = {};
  _ae3289_c5d5da20["toast"] = _ae3289_c5d5daj4;
  _ae3289_c5d5da20["verdict"] = function(_ae3289_c5d5daji)
    local _ae3289_c5d5dajj = _ae3289_c5d5dajh[_ae3289_c5d5daji] or _ae3289_c5d5dajh["idle"];
    _ae3289_c5d5dahm["badge"]["Text"] = _ae3289_c5d5dajj[1];
    _ae3289_c5d5dacc(_ae3289_c5d5dahm["badge"], {["BackgroundColor3"] = _ae3289_c5d5dajj[2], ["TextColor3"] = _ae3289_c5d5dajj[3]}, 0.15);
    local _ae3289_c5d5dajk = (_ae3289_c5d5daji == "ok" or _ae3289_c5d5daji == "used") and _ae3289_c5d5dabb["Ok"] or(_ae3289_c5d5daji == "bad" or _ae3289_c5d5daji == "fail") and _ae3289_c5d5dabb["Err"] or(_ae3289_c5d5daji == "sent" or _ae3289_c5d5daji == "think") and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Stroke"];
    _ae3289_c5d5dacc(_ae3289_c5d5dahm["codeStroke"], {["Color"] = _ae3289_c5d5dajk}, 0.15)
  end;
  _ae3289_c5d5da20["capture"] = function(_ae3289_c5d5dajl, _ae3289_c5d5dajm)
    local _ae3289_c5d5dajn = table["concat"](_ae3289_c5d5dajl or {});
    local _ae3289_c5d5dajo = #(_ae3289_c5d5dajl or {});
    _ae3289_c5d5dahm["code"]["Text"] = _ae3289_c5d5dajn ~= "" and _ae3289_c5d5dajn or "waiting for code...";
    _ae3289_c5d5dahm["code"]["TextColor3"] = _ae3289_c5d5dajn ~= "" and _ae3289_c5d5dabb["Text"] or _ae3289_c5d5dabb["Faint"];
    local _ae3289_c5d5dajp = math["max"](_ae3289_c5d5dajm or settings["submitAfter"], 1);
    _ae3289_c5d5dahm["parts"]["Text"] = _ae3289_c5d5dajo .. (_ae3289_c5d5dajo == 1 and " part" or " parts") .. "<font color=\"" .. colors["dim"] .. "\">  \194\183  " .. (_ae3289_c5d5dajp == 1 and "submits every part" or("submits at " .. _ae3289_c5d5dajp)) .. "</font>";
    for _ae3289_c5d5dajq, _ae3289_c5d5dajr in ipairs((_ae3289_c5d5dahm["pips"]):GetChildren())
    do
      if(_ae3289_c5d5dajr):IsA("Frame") then
        (_ae3289_c5d5dajr):Destroy()
      end
    end;
    local _ae3289_c5d5dajs = math["clamp"](math["max"](_ae3289_c5d5dajp, _ae3289_c5d5dajo), 1, 12);
    for _ae3289_c5d5dajt = 1, _ae3289_c5d5dajs
    do
      local _ae3289_c5d5daju = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1 / _ae3289_c5d5dajs, -5, 1, 0), ["BorderSizePixel"] = 0, ["LayoutOrder"] = _ae3289_c5d5dajt, ["BackgroundColor3"] = _ae3289_c5d5dajt <= _ae3289_c5d5dajo and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Row"]},
        _ae3289_c5d5dahm["pips"]);
      _ae3289_c5d5dabu(_ae3289_c5d5daju, 4);
      if _ae3289_c5d5dajt == _ae3289_c5d5dajo then
        local _ae3289_c5d5dajv = _ae3289_c5d5dabe("UIScale", {["Scale"] = 0.4}, _ae3289_c5d5daju);
        _ae3289_c5d5dacg(_ae3289_c5d5dajv, {["Scale"] = 1}, 0.35)
      end
    end
  end;
  _ae3289_c5d5da20["ai"] = function(_ae3289_c5d5dajw, _ae3289_c5d5dajx, _ae3289_c5d5dajy)
    _ae3289_c5d5dahm["aiMs"] = _ae3289_c5d5dajw;
    _ae3289_c5d5dahm["aiInfo"]["Text"] = "model " .. tostring(_ae3289_c5d5dajx) .. "  |  last answer <font color=\"" .. (_ae3289_c5d5dajw < 3000 and colors["ok"] or colors["warn"]) .. "\">" .. _ae3289_c5d5dajw .. "ms</font>" .. (_ae3289_c5d5dajy and("  |  lane " .. _ae3289_c5d5dajy) or "")
  end;
  _ae3289_c5d5da20["aiNote"] = function(_ae3289_c5d5dajz)
    _ae3289_c5d5dahm["aiInfo"]["Text"] = _ae3289_c5d5dajz
  end;
  _ae3289_c5d5da20["live"] = function()
    if not _ae3289_c5d5dahm["liveInfo"] then
      return
    end;
    local _ae3289_c5d5dak0 = _ae3289_c5d5da3o();
    _ae3289_c5d5dahm["liveInfo"]["Text"] = "live luck: <font color=\"" .. (contextStore["luckN"] and colors["ok"] or colors["dim"]) .. "\">" .. (contextStore["luckN"] and(contextStore["luckN"] .. "x (" .. _ae3289_c5d5da2e(tostring(contextStore["luckSrc"])) .. ")") or "none") .. "</font>" .. (_ae3289_c5d5dak0 and("  \194\183  event: <font color=\"" .. colors["white"] .. "\">" .. _ae3289_c5d5da2e(_ae3289_c5d5dak0) .. "</font>") or "")
  end;
  _ae3289_c5d5da20["keys"] = function()
    if not _ae3289_c5d5dahm["keyList"] or not apiKeys then
      return
    end;
    for _ae3289_c5d5dak1, _ae3289_c5d5dak2 in ipairs((_ae3289_c5d5dahm["keyList"]):GetChildren())
    do
      if(_ae3289_c5d5dak2):IsA("Frame") then
        (_ae3289_c5d5dak2):Destroy()
      end
    end;
    local _ae3289_c5d5dak3 = {["ok"] = {"VALID", _ae3289_c5d5dabb["Ok"]}, ["bad"] = {"INVALID", _ae3289_c5d5dabb["Err"]}, ["limited"] = {"LIMITED", _ae3289_c5d5dabb["Warn"]}, ["unknown"] = {"NO REPLY",
      _ae3289_c5d5dabb["Warn"]}};
    for _ae3289_c5d5dak4, _ae3289_c5d5dak5 in ipairs(apiKeys["list"])
    do
      local _ae3289_c5d5dak6 = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["new"](1, 0, 0, 30), ["BackgroundColor3"] = _ae3289_c5d5dabb["Input"], ["BorderSizePixel"] = 0, ["LayoutOrder"] = _ae3289_c5d5dak4},
        _ae3289_c5d5dahm["keyList"]);
      _ae3289_c5d5dabu(_ae3289_c5d5dak6, 15);
      local _ae3289_c5d5dak7 = apiKeys["i"] == _ae3289_c5d5dak4 and apiKeys["usable"](_ae3289_c5d5dak5);
      _ae3289_c5d5dabx(_ae3289_c5d5dak6, _ae3289_c5d5dak7 and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Stroke"], 1.5, _ae3289_c5d5dak7 and 0 or 0.3);
      local _ae3289_c5d5dak8 = _ae3289_c5d5dack(_ae3289_c5d5dak6, "#" .. _ae3289_c5d5dak4 .. "  " .. (#_ae3289_c5d5dak5 > 12 and((_ae3289_c5d5dak5):sub(1, 6) .. "..." .. (_ae3289_c5d5dak5):sub(-4)) or "***") .. (_ae3289_c5d5dak7 and "  (in use)" or ""),
        12, _ae3289_c5d5dak7 and _ae3289_c5d5dabb["Text"] or _ae3289_c5d5dabb["Dim"], _ae3289_c5d5dabd);
      _ae3289_c5d5dak8["Size"] = UDim2["new"](1, -100, 1, 0);
      _ae3289_c5d5dak8["Position"] = UDim2["fromOffset"](12, 0);
      local _ae3289_c5d5dak9 = _ae3289_c5d5dak3[apiKeys["state"][_ae3289_c5d5dak5]] or {"UNTESTED", _ae3289_c5d5dabb["Faint"]};
      local _ae3289_c5d5daka = _ae3289_c5d5dabe("TextLabel", {["Size"] = UDim2["fromOffset"](74, 20), ["Position"] = UDim2["new"](1, -82, 0.5, -10), ["BackgroundColor3"] = _ae3289_c5d5dak9[2],
        ["Text"] = _ae3289_c5d5dak9[1], ["TextSize"] = 10, ["Font"] = _ae3289_c5d5dabc, ["TextColor3"] = _ae3289_c5d5dabb["Dark"], ["BorderSizePixel"] = 0}, _ae3289_c5d5dak6);
      _ae3289_c5d5dabu(_ae3289_c5d5daka, 10)
    end
  end;
  _ae3289_c5d5da20["riddle"] = function(_ae3289_c5d5dakb, _ae3289_c5d5dakc, _ae3289_c5d5dakd)
    if not _ae3289_c5d5dahm["lastRiddle"] then
      return
    end;
    _ae3289_c5d5dahm["lastRiddle"]["Text"] = "<font color=\"" .. colors["white"] .. "\">" .. _ae3289_c5d5da2e((tostring(_ae3289_c5d5dakb)):sub(1, 90)) .. "</font>\n<font color=\"" .. (_ae3289_c5d5dakd or colors["dim"]) .. "\">" .. tostring(_ae3289_c5d5dakc) .. "</font>"
  end;
  _ae3289_c5d5da20["modes"] = function()
    if _ae3289_c5d5dahm["codeSw"] then
      _ae3289_c5d5dahm["codeSw"](settings["sniper"])
    end;
    if _ae3289_c5d5dahm["riddleSw"] then
      _ae3289_c5d5dahm["riddleSw"](settings["riddler"])
    end;
    _ae3289_c5d5da1k()
  end;
  _ae3289_c5d5da20["round"] = function()
    local _ae3289_c5d5dake, _ae3289_c5d5dakf = settings["sniper"], settings["riddler"];
    _ae3289_c5d5dahm["round"]["Text"] = (_ae3289_c5d5dake and _ae3289_c5d5dakf) and "CODE + RIDDLE" or(_ae3289_c5d5dake and "CODE SNIPER") or(_ae3289_c5d5dakf and "RIDDLE SOLVER") or "OFF";
    _ae3289_c5d5dacc(_ae3289_c5d5dahm["round"], {["BackgroundColor3"] = (_ae3289_c5d5dakf and not _ae3289_c5d5dake) and _ae3289_c5d5dabb["Accent2"] or((_ae3289_c5d5dake or _ae3289_c5d5dakf) and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Row"]),
      ["TextColor3"] = (_ae3289_c5d5dake or _ae3289_c5d5dakf) and _ae3289_c5d5dabb["Dark"] or _ae3289_c5d5dabb["Dim"]}, 0.15);
    if _ae3289_c5d5dakf and not _ae3289_c5d5dake then
      _ae3289_c5d5dahm["parts"]["Text"] = "riddle solver<font color=\"" .. colors["dim"] .. "\">  \194\183  answer = one full code</font>"
    end
  end;
  do
    local _ae3289_c5d5dakg = _ae3289_c5d5dabe("Frame", {["Name"] = "Skyr0_Announce", ["AnchorPoint"] = Vector2["new"](0.5, 0), ["Position"] = UDim2["new"](0.5, 0, 0, -90), ["Size"] = UDim2["new"](0,
      460, 0, 56), ["BackgroundColor3"] = _ae3289_c5d5dabb["Surface"], ["BackgroundTransparency"] = 1, ["BorderSizePixel"] = 0, ["Visible"] = false, ["ZIndex"] = 200,}, _ae3289_c5d5dadi);
    _ae3289_c5d5dabu(_ae3289_c5d5dakg, 12);
    _ae3289_c5d5dabx(_ae3289_c5d5dakg, _ae3289_c5d5dabb["Accent"], 1.4, 0.1);
    local _ae3289_c5d5dakh = _ae3289_c5d5dabe("Frame", {["Size"] = UDim2["fromOffset"](74, 22), ["Position"] = UDim2["new"](0, 12, 0, 9), ["BackgroundColor3"] = _ae3289_c5d5dabb["Accent"],
      ["BorderSizePixel"] = 0, ["ZIndex"] = 201}, _ae3289_c5d5dakg);
    _ae3289_c5d5dabu(_ae3289_c5d5dakh, 6);
    local _ae3289_c5d5daki = _ae3289_c5d5dack(_ae3289_c5d5dakh, "sammy", 11, _ae3289_c5d5dabb["Dark"], _ae3289_c5d5dabc, Enum["TextXAlignment"]["Center"]);
    _ae3289_c5d5daki["Size"] = UDim2["new"](1, 0, 1, 0);
    _ae3289_c5d5daki["ZIndex"] = 202;
    local _ae3289_c5d5dakj = _ae3289_c5d5dack(_ae3289_c5d5dakg, "SERVER ANNOUNCEMENT", 9, _ae3289_c5d5dabb["Dim"], _ae3289_c5d5dabc);
    _ae3289_c5d5dakj["Size"] = UDim2["new"](1, -96, 0, 12);
    _ae3289_c5d5dakj["Position"] = UDim2["new"](0, 94, 0, 8);
    _ae3289_c5d5dakj["ZIndex"] = 201;
    local _ae3289_c5d5dakk = _ae3289_c5d5dack(_ae3289_c5d5dakg, "", 13, _ae3289_c5d5dabb["Text"], _ae3289_c5d5dabc);
    _ae3289_c5d5dakk["Size"] = UDim2["new"](1, -104, 0, 24);
    _ae3289_c5d5dakk["Position"] = UDim2["new"](0, 94, 0, 23);
    _ae3289_c5d5dakk["ZIndex"] = 201;
    _ae3289_c5d5dakk["TextTruncate"] = Enum["TextTruncate"]["AtEnd"];
    local _ae3289_c5d5dakl = 0;
    _ae3289_c5d5da1z = function(_ae3289_c5d5dakm, _ae3289_c5d5dakn)
      _ae3289_c5d5dakl = _ae3289_c5d5dakl + 1;
      local _ae3289_c5d5dako = _ae3289_c5d5dakl;
      _ae3289_c5d5daki["Text"] = tostring(_ae3289_c5d5dakm or "sammy");
      _ae3289_c5d5dakk["Text"] = tostring(_ae3289_c5d5dakn or "");
      local _ae3289_c5d5dakp = _ae3289_c5d5dabs();
      _ae3289_c5d5dakg["Size"] = UDim2["new"](0, math["floor"](math["clamp"](_ae3289_c5d5dakp["X"] * 0.5, 320, 520)), 0, 56);
      _ae3289_c5d5dakg["Visible"] = true;
      _ae3289_c5d5dakg["Position"] = UDim2["new"](0.5, 0, 0, -90);
      _ae3289_c5d5dakg["BackgroundTransparency"] = 1;
      _ae3289_c5d5dacc(_ae3289_c5d5dakg, {["Position"] = UDim2["new"](0.5, 0, 0, 16), ["BackgroundTransparency"] = 0.05}, 0.28);
      task["delay"](4.5, function()
        if _ae3289_c5d5dako ~= _ae3289_c5d5dakl then
          return
        end;
        _ae3289_c5d5dacc(_ae3289_c5d5dakg, {["Position"] = UDim2["new"](0.5, 0, 0, -90), ["BackgroundTransparency"] = 1}, 0.28);
        task["delay"](0.3, function()
          if _ae3289_c5d5dako == _ae3289_c5d5dakl then
            _ae3289_c5d5dakg["Visible"] = false
          end
        end)
      end)
    end
  end;
  local _ae3289_c5d5dakq = 150;
  local _ae3289_c5d5dakr, _ae3289_c5d5daks = 0, {};
  local function _ae3289_c5d5dakt()
    return _ae3289_c5d5daif["CanvasPosition"]["Y"] >= _ae3289_c5d5daif["AbsoluteCanvasSize"]["Y"] - _ae3289_c5d5daif["AbsoluteWindowSize"]["Y"] - 30
  end;
  _ae3289_c5d5da18 = function(_ae3289_c5d5daku)
    _ae3289_c5d5daku = tostring(_ae3289_c5d5daku);
    local _ae3289_c5d5dakv = _ae3289_c5d5dakt();
    _ae3289_c5d5dakr = _ae3289_c5d5dakr + 1;
    local _ae3289_c5d5dakw = os["date"]("%H:%M:%S");
    local _ae3289_c5d5dakx = _ae3289_c5d5dabe("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = UDim2["new"](1, 0, 0, 0), ["AutomaticSize"] = Enum["AutomaticSize"]["Y"], ["RichText"] = true,
      ["TextWrapped"] = true, ["TextSize"] = 12, ["Font"] = Enum["Font"]["Code"], ["TextColor3"] = _ae3289_c5d5dabb["Text"], ["TextXAlignment"] = Enum["TextXAlignment"]["Left"], ["TextYAlignment"] = Enum["TextYAlignment"]["Top"],
      ["LayoutOrder"] = _ae3289_c5d5dakr, ["Text"] = "<font color=\"rgb(88,88,104)\">" .. _ae3289_c5d5dakw .. "</font>  " .. _ae3289_c5d5daku,}, _ae3289_c5d5daif);
    _ae3289_c5d5daks[#_ae3289_c5d5daks + 1] = {["l"] = _ae3289_c5d5dakx, ["s"] = _ae3289_c5d5dakw .. "  " .. _ae3289_c5d5da28(_ae3289_c5d5daku)};
    while #_ae3289_c5d5daks > _ae3289_c5d5dakq
    do
      local _ae3289_c5d5daky = table["remove"](_ae3289_c5d5daks, 1);
      pcall(function()
        (_ae3289_c5d5daky["l"]):Destroy()
      end)
    end;
    if _ae3289_c5d5dakv or not _ae3289_c5d5daei["Console"]["Visible"] then
      task["defer"](function()
        pcall(function()
          _ae3289_c5d5daif["CanvasPosition"] = Vector2["new"](0, math["max"](0, _ae3289_c5d5daif["AbsoluteCanvasSize"]["Y"] - _ae3289_c5d5daif["AbsoluteWindowSize"]["Y"]))
        end)
      end)
    end
  end;
  _ae3289_c5d5da19 = function()
    for _ae3289_c5d5dakz, _ae3289_c5d5dal0 in ipairs(_ae3289_c5d5daks)
    do
      pcall(function()
        (_ae3289_c5d5dal0["l"]):Destroy()
      end)
    end;
    _ae3289_c5d5daks = {};
    _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">cleared</font>")
  end;
  _ae3289_c5d5da1a = function(_ae3289_c5d5dal1, _ae3289_c5d5dal2)
    _ae3289_c5d5da18("<font color=\"" .. (_ae3289_c5d5dal2 or colors["dim"]) .. "\">" .. tostring(_ae3289_c5d5dal1) .. "</font>")
  end;
  _ae3289_c5d5da1j = function()
    _ae3289_c5d5dahm["stats"]["Text"] = state["solvedCount"] .. " solved / " .. state["askedCount"] .. " asked"
  end;
  _ae3289_c5d5da1w(_ae3289_c5d5dahm["clearBtn"], function()
    _ae3289_c5d5da19();
    state["solvedCount"], state["askedCount"] = 0, 0;
    _ae3289_c5d5da1j()
  end);
  _ae3289_c5d5da1w(_ae3289_c5d5dahm["copyBtn"], function()
    local _ae3289_c5d5dal3 = {};
    for _ae3289_c5d5dal4, _ae3289_c5d5dal5 in ipairs(_ae3289_c5d5daks)
    do
      _ae3289_c5d5dal3[#_ae3289_c5d5dal3 + 1] = _ae3289_c5d5dal5["s"]
    end;
    local _ae3289_c5d5dal6 = pcall(function()
      setclipboard(table["concat"](_ae3289_c5d5dal3, "\n"))
    end);
    _ae3289_c5d5daj4(_ae3289_c5d5dal6 and "console copied" or "no clipboard on this executor", _ae3289_c5d5dal6 and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Err"])
  end);
  _ae3289_c5d5da1k = function()
    local _ae3289_c5d5dal7 = settings["sniper"] or settings["riddler"];
    _ae3289_c5d5dacc(_ae3289_c5d5dae9, {["BackgroundColor3"] = _ae3289_c5d5dal7 and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Off"]}, 0.14);
    _ae3289_c5d5dacg(_ae3289_c5d5daea, {["Position"] = _ae3289_c5d5dal7 and UDim2["new"](1, -25, 0.5, -11) or UDim2["new"](0, 3, 0.5, -11)}, 0.3);
    _ae3289_c5d5dacc(_ae3289_c5d5da1u, {["BackgroundColor3"] = _ae3289_c5d5dal7 and _ae3289_c5d5dabb["Ok"] or _ae3289_c5d5dabb["Off"]}, 0.14);
    _ae3289_c5d5dae1["Text"] = _ae3289_c5d5dal7 and("<font color=\"" .. colors["ok"] .. "\">listening</font>  \194\183  code redeemer") or("<font color=\"" .. colors["dim"] .. "\">paused</font>  \194\183  code redeemer");
    _ae3289_c5d5dahm["state"]["Text"] = _ae3289_c5d5dal7 and "LISTENING" or "PAUSED";
    _ae3289_c5d5dahm["state"]["TextColor3"] = _ae3289_c5d5dal7 and _ae3289_c5d5dabb["Accent"] or _ae3289_c5d5dabb["Dim"];
    _ae3289_c5d5dacc(_ae3289_c5d5dadw, {["Color"] = _ae3289_c5d5dal7 and _ae3289_c5d5dabb["Accent2"] or _ae3289_c5d5dabb["Stroke"], ["Transparency"] = _ae3289_c5d5dal7 and 0.35 or 0},
      0.2);
    if _ae3289_c5d5da20 and _ae3289_c5d5da20["round"] then
      _ae3289_c5d5da20["round"]()
    end
  end;
  task["spawn"](function()
    while state["alive"] and ownGui and ownGui["Parent"]
    do
      if settings["sniper"] or settings["riddler"] then
        _ae3289_c5d5dacc(_ae3289_c5d5da1u, {["BackgroundTransparency"] = 0.55}, 0.6);
        task["wait"](0.65);
        _ae3289_c5d5dacc(_ae3289_c5d5da1u, {["BackgroundTransparency"] = 0}, 0.6)
      else
        _ae3289_c5d5da1u["BackgroundTransparency"] = 0
      end;
      task["wait"](0.65)
    end
  end);
  _ae3289_c5d5da1w(_ae3289_c5d5dae9, function()
    local _ae3289_c5d5dal8 = not(settings["sniper"] or settings["riddler"]);
    settings["sniper"], settings["riddler"] = _ae3289_c5d5dal8, _ae3289_c5d5dal8;
    saveSettings();
    _ae3289_c5d5da1d();
    _ae3289_c5d5da20["modes"]();
    _ae3289_c5d5da18("<font color=\"" .. (_ae3289_c5d5dal8 and colors["ok"] or colors["err"]) .. "\">code sniper + riddle solver " .. (_ae3289_c5d5dal8 and "on" or "off") .. "</font>");
    _ae3289_c5d5daj4(_ae3289_c5d5dal8 and "listening" or "paused", _ae3289_c5d5dal8 and _ae3289_c5d5dabb["Ok"] or _ae3289_c5d5dabb["Dim"])
  end);
  local _ae3289_c5d5dal9 = false;
  _ae3289_c5d5da1w(_ae3289_c5d5dae8, function()
    _ae3289_c5d5dal9 = not _ae3289_c5d5dal9;
    _ae3289_c5d5dae8["Text"] = _ae3289_c5d5dal9 and "+" or "\226\128\147";
    _ae3289_c5d5dacc(_ae3289_c5d5dadu, {["Size"] = UDim2["fromOffset"](_ae3289_c5d5dadq, _ae3289_c5d5dal9 and _ae3289_c5d5dadt or _ae3289_c5d5dadr)}, 0.2)
  end);
  _ae3289_c5d5da1w(_ae3289_c5d5dae7, function()
    if _ae3289_c5d5dar["Skyr0Stop"] then
      _ae3289_c5d5dar["Skyr0Stop"]()
    else
      (ownGui):Destroy()
    end
  end);
  if _ae3289_c5d5dabo then
    local _ae3289_c5d5dala = _ae3289_c5d5dabe("TextButton", {["Name"] = "Skyr0_Launcher", ["Size"] = UDim2["fromOffset"](52, 52), ["Position"] = UDim2["new"](0, 14, 0.5, -26), ["BackgroundColor3"] = _ae3289_c5d5dabb["Accent"],
      ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Active"] = true, ["Text"] = "s0", ["TextSize"] = 16, ["TextColor3"] = _ae3289_c5d5dabb["Dark"], ["Font"] = _ae3289_c5d5dabc,
      ["ZIndex"] = 50,}, _ae3289_c5d5dadi);
    _ae3289_c5d5dabu(_ae3289_c5d5dala, 26);
    _ae3289_c5d5dabx(_ae3289_c5d5dala, _ae3289_c5d5dabb["Text"], 1.5, 0.6);
    _ae3289_c5d5dabe("UIGradient", {["Rotation"] = 45, ["Color"] = ColorSequence["new"](_ae3289_c5d5dabb["Accent"], _ae3289_c5d5dabb["Accent2"])}, _ae3289_c5d5dala);
    local _ae3289_c5d5dalb, _ae3289_c5d5dalc, _ae3289_c5d5dald, _ae3289_c5d5dale = false, false, nil, nil;
    (_ae3289_c5d5dala["InputBegan"]):Connect(function(_ae3289_c5d5dalf)
      if _ae3289_c5d5dalf["UserInputType"] == Enum["UserInputType"]["Touch"] or _ae3289_c5d5dalf["UserInputType"] == Enum["UserInputType"]["MouseButton1"] then
        _ae3289_c5d5dalb, _ae3289_c5d5dalc = true, false;
        _ae3289_c5d5dald, _ae3289_c5d5dale = _ae3289_c5d5dalf["Position"], _ae3289_c5d5dala["Position"]
      end
    end);
    (_ae3289_c5d5dala["InputEnded"]):Connect(function(_ae3289_c5d5dalg)
      if _ae3289_c5d5dalg["UserInputType"] == Enum["UserInputType"]["Touch"] or _ae3289_c5d5dalg["UserInputType"] == Enum["UserInputType"]["MouseButton1"] then
        _ae3289_c5d5dalb = false;
        if not _ae3289_c5d5dalc then
          _ae3289_c5d5dadu["Visible"] = not _ae3289_c5d5dadu["Visible"]
        end
      end
    end);
    _ae3289_c5d5da24((UserInputService["InputChanged"]):Connect(function(_ae3289_c5d5dalh)
      if not _ae3289_c5d5dalb then
        return
      end;
      if _ae3289_c5d5dalh["UserInputType"] ~= Enum["UserInputType"]["Touch"] and _ae3289_c5d5dalh["UserInputType"] ~= Enum["UserInputType"]["MouseMovement"] then
        return
      end;
      local _ae3289_c5d5dali = _ae3289_c5d5dalh["Position"] - _ae3289_c5d5dald;
      if math["abs"](_ae3289_c5d5dali["X"]) > 6 or math["abs"](_ae3289_c5d5dali["Y"]) > 6 then
        _ae3289_c5d5dalc = true
      end;
      local _ae3289_c5d5dalj = _ae3289_c5d5dabs();
      local _ae3289_c5d5dalk = _ae3289_c5d5dadj["Scale"] > 0 and _ae3289_c5d5dadj["Scale"] or 1;
      _ae3289_c5d5dala["Position"] = UDim2["new"](0, math["clamp"](_ae3289_c5d5dale["X"]["Offset"] + _ae3289_c5d5dali["X"] / _ae3289_c5d5dalk, 0, _ae3289_c5d5dalj["X"] / _ae3289_c5d5dalk - 52),
        0, math["clamp"](_ae3289_c5d5dale["Y"]["Offset"] + _ae3289_c5d5dali["Y"] / _ae3289_c5d5dalk, 0, _ae3289_c5d5dalj["Y"] / _ae3289_c5d5dalk - 52))
    end))
  end;
  do
    local _ae3289_c5d5dall, _ae3289_c5d5dalm, _ae3289_c5d5daln, _ae3289_c5d5dalo, _ae3289_c5d5dalp = false, nil, nil, nil, false;
    local _ae3289_c5d5dalq = UserInputService["TouchEnabled"] and 8 or 2;
    local function _ae3289_c5d5dalr(_ae3289_c5d5dals)
      for _ae3289_c5d5dalt, _ae3289_c5d5dalu in ipairs({_ae3289_c5d5dae9, _ae3289_c5d5dae8, _ae3289_c5d5dae7})
      do
        local _ae3289_c5d5dalv, _ae3289_c5d5dalw = _ae3289_c5d5dalu["AbsolutePosition"], _ae3289_c5d5dalu["AbsoluteSize"];
        if _ae3289_c5d5dals["X"] >= _ae3289_c5d5dalv["X"] - 6 and _ae3289_c5d5dals["X"] <= _ae3289_c5d5dalv["X"] + _ae3289_c5d5dalw["X"] + 6 and _ae3289_c5d5dals["Y"] >= _ae3289_c5d5dalv["Y"] - 6 and _ae3289_c5d5dals["Y"] <= _ae3289_c5d5dalv["Y"] + _ae3289_c5d5dalw["Y"] + 6 then
          return true
        end
      end;
      return false
    end;
    (_ae3289_c5d5dadx["InputBegan"]):Connect(function(_ae3289_c5d5dalx)
      if _ae3289_c5d5dalx["UserInputType"] ~= Enum["UserInputType"]["MouseButton1"] and _ae3289_c5d5dalx["UserInputType"] ~= Enum["UserInputType"]["Touch"] then
        return
      end;
      if _ae3289_c5d5dall or _ae3289_c5d5dalr(_ae3289_c5d5dalx["Position"]) then
        return
      end;
      _ae3289_c5d5dall, _ae3289_c5d5dalm, _ae3289_c5d5dalp = true, _ae3289_c5d5dalx, false;
      _ae3289_c5d5daln = Vector2["new"](_ae3289_c5d5dalx["Position"]["X"], _ae3289_c5d5dalx["Position"]["Y"]);
      _ae3289_c5d5dalo = _ae3289_c5d5dadu["Position"];
      (_ae3289_c5d5dalx["Changed"]):Connect(function()
        if _ae3289_c5d5dalx["UserInputState"] == Enum["UserInputState"]["End"] or _ae3289_c5d5dalx["UserInputState"] == Enum["UserInputState"]["Cancel"] then
          if _ae3289_c5d5dalx == _ae3289_c5d5dalm then
            _ae3289_c5d5dall, _ae3289_c5d5dalm = false, nil
          end
        end
      end)
    end);
    _ae3289_c5d5da24((UserInputService["InputChanged"]):Connect(function(_ae3289_c5d5daly)
      if not _ae3289_c5d5dall or not _ae3289_c5d5dalm then
        return
      end;
      local _ae3289_c5d5dalz = _ae3289_c5d5dalm["UserInputType"] == Enum["UserInputType"]["Touch"] and _ae3289_c5d5daly == _ae3289_c5d5dalm;
      local _ae3289_c5d5dam0 = _ae3289_c5d5dalm["UserInputType"] == Enum["UserInputType"]["MouseButton1"] and _ae3289_c5d5daly["UserInputType"] == Enum["UserInputType"]["MouseMovement"];
      if not _ae3289_c5d5dalz and not _ae3289_c5d5dam0 then
        return
      end;
      local _ae3289_c5d5dam1 = Vector2["new"](_ae3289_c5d5daly["Position"]["X"], _ae3289_c5d5daly["Position"]["Y"]) - _ae3289_c5d5daln;
      if not _ae3289_c5d5dalp then
        if _ae3289_c5d5dam1["Magnitude"] < _ae3289_c5d5dalq then
          return
        end;
        _ae3289_c5d5dalp = true
      end;
      local _ae3289_c5d5dam2 = _ae3289_c5d5dadj["Scale"] > 0 and _ae3289_c5d5dadj["Scale"] or 1;
      _ae3289_c5d5dadu["Position"] = UDim2["new"](_ae3289_c5d5dalo["X"]["Scale"], _ae3289_c5d5dalo["X"]["Offset"] + _ae3289_c5d5dam1["X"] / _ae3289_c5d5dam2, _ae3289_c5d5dalo["Y"]["Scale"],
        _ae3289_c5d5dalo["Y"]["Offset"] + _ae3289_c5d5dam1["Y"] / _ae3289_c5d5dam2)
    end))
  end;
  _ae3289_c5d5da24((UserInputService["InputBegan"]):Connect(function(_ae3289_c5d5dam3, _ae3289_c5d5dam4)
    if _ae3289_c5d5dam4 then
      return
    end;
    if _ae3289_c5d5dam3["KeyCode"] == Enum["KeyCode"]["RightControl"] then
      ownGui["Enabled"] = not ownGui["Enabled"]
    end
  end));
  do
    local _ae3289_c5d5dam5 = _ae3289_c5d5dadu["Position"];
    local _ae3289_c5d5dam6 = _ae3289_c5d5dabe("UIScale", {["Name"] = "OpenScale", ["Scale"] = 0.85}, _ae3289_c5d5dadu);
    _ae3289_c5d5dadu["Position"] = UDim2["new"](_ae3289_c5d5dam5["X"]["Scale"], _ae3289_c5d5dam5["X"]["Offset"], _ae3289_c5d5dam5["Y"]["Scale"], _ae3289_c5d5dam5["Y"]["Offset"] + 20);
    _ae3289_c5d5dacg(_ae3289_c5d5dam6, {["Scale"] = 1}, 0.45);
    _ae3289_c5d5dacc(_ae3289_c5d5dadu, {["Position"] = _ae3289_c5d5dam5}, 0.3)
  end;
  _ae3289_c5d5daeo("Sniper");
  _ae3289_c5d5da1k();
  _ae3289_c5d5da1j();
  _ae3289_c5d5da20["capture"]({}, settings["submitAfter"]);
  _ae3289_c5d5da20["verdict"]("idle");
  _ae3289_c5d5da20["round"]();
  _ae3289_c5d5da18("<font color=\"" .. colors["acc"] .. "\">skyr0.wtf loaded</font>");
  _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">example: my cats name 3 times and how old am i</font>")
end;
local function _ae3289_c5d5dam7()
  if type(writefile) ~= "function" then
    return
  end;
  pcall(function()
    writefile(contextFile, (HttpService):JSONEncode({["at"] = os["time"](), ["announcements"] = contextStore["announcements"], ["confirmed"] = contextStore["confirmed"], ["detectedEvent"] = contextStore["detectedEvent"],
      }))
  end)
end;
pcall(function()
  if type(isfile) == "function" and isfile(contextFile) then
    local _ae3289_c5d5dam8 = _ae3289_c5d5da2w(readfile(contextFile));
    if type(_ae3289_c5d5dam8) == "table" and tonumber(_ae3289_c5d5dam8["at"]) and os["time"]() - _ae3289_c5d5dam8["at"] < 7200 then
      contextStore["announcements"] = type(_ae3289_c5d5dam8["announcements"]) == "table" and _ae3289_c5d5dam8["announcements"] or {};
      contextStore["confirmed"] = type(_ae3289_c5d5dam8["confirmed"]) == "table" and _ae3289_c5d5dam8["confirmed"] or {};
      contextStore["detectedEvent"] = _ae3289_c5d5dam8["detectedEvent"]
    end
  end
end);
local _ae3289_c5d5dam9 = false;
local function _ae3289_c5d5dama()
  if _ae3289_c5d5dam9 then
    return
  end;
  _ae3289_c5d5dam9 = true;
  task["delay"](3, function()
    _ae3289_c5d5dam9 = false;
    _ae3289_c5d5dam7()
  end)
end;
local function _ae3289_c5d5damb(_ae3289_c5d5damc)
  local _ae3289_c5d5damd = (_ae3289_c5d5damc):lower();
  if not((_ae3289_c5d5damd):find("event") or(_ae3289_c5d5damd):find("snap") or(_ae3289_c5d5damd):find("started") or(_ae3289_c5d5damd):find("begun") or(_ae3289_c5d5damd):find("luck")) then
    return
  end;
  local _ae3289_c5d5dame = (_ae3289_c5d5damc):match("([%w%-' ]+)%s+[Ee]vent");
  if _ae3289_c5d5dame then
    _ae3289_c5d5dame = _ae3289_c5d5da26(((_ae3289_c5d5dame):gsub("^.*%f[%w]the%s+", "")):gsub("^[Aa]n?%s+", ""));
    if _ae3289_c5d5dame ~= "" and #_ae3289_c5d5dame < 30 then
      contextStore["detectedEvent"] = _ae3289_c5d5dame .. " Event"
    end
  end;
  local _ae3289_c5d5damf = (_ae3289_c5d5damd):match("(%d+x)%s*luck");
  if _ae3289_c5d5damf then
    contextStore["detectedEvent"] = (_ae3289_c5d5damf):upper() .. " Luck";
    contextStore["announcedLuck"] = {["n"] = tonumber((_ae3289_c5d5damf):match("%d+")), ["at"] = os["clock"]()}
  end
end;
local function _ae3289_c5d5damg(_ae3289_c5d5damh, _ae3289_c5d5dami)
  _ae3289_c5d5damh = _ae3289_c5d5da26(_ae3289_c5d5da28(tostring(_ae3289_c5d5damh or "")));
  if _ae3289_c5d5damh == "" or #_ae3289_c5d5damh > 300 then
    return
  end;
  local _ae3289_c5d5damj = contextStore["announcements"][#contextStore["announcements"]];
  if _ae3289_c5d5damj and _ae3289_c5d5damj["text"] == _ae3289_c5d5damh then
    return
  end;
  contextStore["announcements"][#contextStore["announcements"] + 1] = {["t"] = _ae3289_c5d5da30()["clock"], ["text"] = _ae3289_c5d5damh, ["src"] = _ae3289_c5d5dami};
  while #contextStore["announcements"] > _ae3289_c5d5da3n
  do
    table["remove"](contextStore["announcements"], 1)
  end;
  _ae3289_c5d5damb(_ae3289_c5d5damh);
  _ae3289_c5d5dama()
end;
local _ae3289_c5d5damk = {"event", "luck", "mutation", "weather", "abuse", "admin", "season", "update"};
local function _ae3289_c5d5daml()
  local _ae3289_c5d5damm = {};
  for _ae3289_c5d5damn, _ae3289_c5d5damo in ipairs({workspace, Lighting, ReplicatedStorage})
  do
    pcall(function()
      for _ae3289_c5d5damp, _ae3289_c5d5damq in pairs((_ae3289_c5d5damo):GetAttributes())
      do
        local _ae3289_c5d5damr = (_ae3289_c5d5damp):lower();
        for _ae3289_c5d5dams, _ae3289_c5d5damt in ipairs(_ae3289_c5d5damk)
        do
          if(_ae3289_c5d5damr):find(_ae3289_c5d5damt, 1, true) and(type(_ae3289_c5d5damq) == "string" or type(_ae3289_c5d5damq) == "number" or type(_ae3289_c5d5damq) == "boolean") then
            _ae3289_c5d5damm[_ae3289_c5d5damo["Name"] .. "." .. _ae3289_c5d5damp] = tostring(_ae3289_c5d5damq);
            break
          end
        end
      end
    end)
  end;
  contextStore["attributes"] = _ae3289_c5d5damm
end;
for _ae3289_c5d5damu, _ae3289_c5d5damv in ipairs({workspace, Lighting, ReplicatedStorage})
do
  pcall(function()
    _ae3289_c5d5da24((_ae3289_c5d5damv["AttributeChanged"]):Connect(function()
      pcall(_ae3289_c5d5daml)
    end))
  end)
end;
pcall(_ae3289_c5d5daml);
local _ae3289_c5d5damw = {["labels"] = setmetatable({}, {["__mode"] = "k"}), ["holders"] = setmetatable({}, {["__mode"] = "k"})};
local function _ae3289_c5d5damx(_ae3289_c5d5damy)
  local _ae3289_c5d5damz = (_ae3289_c5d5da28(tostring(_ae3289_c5d5damy or ""))):lower();
  if #_ae3289_c5d5damz > 48 or not(_ae3289_c5d5damz):find("luck") or(_ae3289_c5d5damz):find("lucky") then
    return nil
  end;
  local _ae3289_c5d5dan0 = (_ae3289_c5d5damz):match("(%d+)%s*x%s*luck") or(_ae3289_c5d5damz):match("luck%s*x%s*(%d+)") or(_ae3289_c5d5damz):match("x%s*(%d+)%s*luck") or(_ae3289_c5d5damz):match("luck%s*:?%s*(%d+)%s*x") or(_ae3289_c5d5damz):match("(%d+)x");
  _ae3289_c5d5dan0 = tonumber(_ae3289_c5d5dan0);
  if _ae3289_c5d5dan0 and _ae3289_c5d5dan0 >= 2 and _ae3289_c5d5dan0 <= 100 then
    return _ae3289_c5d5dan0
  end;
  return nil
end;
local function _ae3289_c5d5dan1(_ae3289_c5d5dan2)
  local _ae3289_c5d5dan3 = (tostring(_ae3289_c5d5dan2)):lower();
  return(_ae3289_c5d5dan3):find("luck", 1, true) ~= nil and not(_ae3289_c5d5dan3):find("lucky", 1, true)
end;
function _ae3289_c5d5damw.noteLabel(_ae3289_c5d5dan4)
  if _ae3289_c5d5damx(_ae3289_c5d5dan4["Text"]) then
    _ae3289_c5d5damw["labels"][_ae3289_c5d5dan4] = true
  end
end;
function _ae3289_c5d5damw.noteHolder(_ae3289_c5d5dan5)
  local _ae3289_c5d5dan6 = false;
  pcall(function()
    if(_ae3289_c5d5dan5):IsA("ValueBase") and _ae3289_c5d5dan1(_ae3289_c5d5dan5["Name"]) then
      _ae3289_c5d5dan6 = true;
      return
    end;
    for _ae3289_c5d5dan7 in pairs((_ae3289_c5d5dan5):GetAttributes())
    do
      if _ae3289_c5d5dan1(_ae3289_c5d5dan7) then
        _ae3289_c5d5dan6 = true;
        return
      end
    end
  end);
  if _ae3289_c5d5dan6 then
    _ae3289_c5d5damw["holders"][_ae3289_c5d5dan5] = true
  end
end;
local function _ae3289_c5d5dan8(_ae3289_c5d5dan9)
  local _ae3289_c5d5dana;
  local function _ae3289_c5d5danb(_ae3289_c5d5danc, _ae3289_c5d5dand)
    if type(_ae3289_c5d5danc) == "number" and _ae3289_c5d5danc >= 2 and _ae3289_c5d5danc <= 100 then
      _ae3289_c5d5dana = math["max"](_ae3289_c5d5dana or 0, math["floor"](_ae3289_c5d5danc))
    elseif type(_ae3289_c5d5danc) == "string" then
      local _ae3289_c5d5dane = _ae3289_c5d5damx(((_ae3289_c5d5danc):lower()):find("luck") and _ae3289_c5d5danc or(_ae3289_c5d5danc .. " luck"));
      if _ae3289_c5d5dane then
        _ae3289_c5d5dana = math["max"](_ae3289_c5d5dana or 0, _ae3289_c5d5dane)
      end
    end
  end;
  pcall(function()
    if(_ae3289_c5d5dan9):IsA("ValueBase") and _ae3289_c5d5dan1(_ae3289_c5d5dan9["Name"]) then
      _ae3289_c5d5danb(_ae3289_c5d5dan9["Value"])
    end;
    for _ae3289_c5d5danf, _ae3289_c5d5dang in pairs((_ae3289_c5d5dan9):GetAttributes())
    do
      if _ae3289_c5d5dan1(_ae3289_c5d5danf) then
        _ae3289_c5d5danb(_ae3289_c5d5dang, _ae3289_c5d5danf)
      end
    end
  end);
  return _ae3289_c5d5dana
end;
function _ae3289_c5d5damw.refresh()
  local _ae3289_c5d5danh, _ae3289_c5d5dani;
  for _ae3289_c5d5danj in pairs(_ae3289_c5d5damw["labels"])
  do
    if not _ae3289_c5d5danj["Parent"] then
      _ae3289_c5d5damw["labels"][_ae3289_c5d5danj] = nil
    elseif _ae3289_c5d5da22(_ae3289_c5d5danj) then
      local _ae3289_c5d5dank = _ae3289_c5d5damx(_ae3289_c5d5danj["Text"]);
      if _ae3289_c5d5dank and(not _ae3289_c5d5danh or _ae3289_c5d5dank > _ae3289_c5d5danh) then
        _ae3289_c5d5danh, _ae3289_c5d5dani = _ae3289_c5d5dank, "game ui"
      end
    end
  end;
  if not _ae3289_c5d5danh then
    for _ae3289_c5d5danl in pairs(_ae3289_c5d5damw["holders"])
    do
      local _ae3289_c5d5danm = _ae3289_c5d5danl["Parent"] and _ae3289_c5d5dan8(_ae3289_c5d5danl);
      if _ae3289_c5d5danm and(not _ae3289_c5d5danh or _ae3289_c5d5danm > _ae3289_c5d5danh) then
        _ae3289_c5d5danh, _ae3289_c5d5dani = _ae3289_c5d5danm, "game value " .. _ae3289_c5d5danl["Name"]
      end
    end
  end;
  local _ae3289_c5d5dann = contextStore["announcedLuck"];
  if not _ae3289_c5d5danh and _ae3289_c5d5dann and os["clock"]() - _ae3289_c5d5dann["at"] < 600 then
    _ae3289_c5d5danh, _ae3289_c5d5dani = _ae3289_c5d5dann["n"], "announcement"
  end;
  local _ae3289_c5d5dano = contextStore["luckN"] ~= _ae3289_c5d5danh;
  contextStore["luckN"], contextStore["luckSrc"] = _ae3289_c5d5danh, _ae3289_c5d5dani;
  if _ae3289_c5d5dano and _ae3289_c5d5da18 then
    _ae3289_c5d5da18("<font color=\"" .. colors["acc"] .. "\">luck: " .. (_ae3289_c5d5danh and(_ae3289_c5d5danh .. "x (" .. _ae3289_c5d5dani .. ")") or "none") .. "</font>")
  end;
  if _ae3289_c5d5da20 and _ae3289_c5d5da20["live"] then
    pcall(_ae3289_c5d5da20["live"])
  end
end;
task["spawn"](function()
  for _ae3289_c5d5danp, _ae3289_c5d5danq in ipairs({workspace, Lighting, ReplicatedStorage, LocalPlayer})
  do
    _ae3289_c5d5damw["noteHolder"](_ae3289_c5d5danq);
    for _ae3289_c5d5danr, _ae3289_c5d5dans in ipairs(_ae3289_c5d5danq == workspace and(_ae3289_c5d5danq):GetChildren() or(_ae3289_c5d5danq):GetDescendants())
    do
      _ae3289_c5d5damw["noteHolder"](_ae3289_c5d5dans);
      if _ae3289_c5d5danr % 400 == 0 then
        task["wait"]()
      end
    end
  end;
  local _ae3289_c5d5dant = (workspace):FindFirstChild("Events");
  if _ae3289_c5d5dant then
    for _ae3289_c5d5danu, _ae3289_c5d5danv in ipairs((_ae3289_c5d5dant):GetDescendants())
    do
      _ae3289_c5d5damw["noteHolder"](_ae3289_c5d5danv)
    end
  end;
  for _ae3289_c5d5danw, _ae3289_c5d5danx in ipairs({ReplicatedStorage, Lighting})
  do
    _ae3289_c5d5da24((_ae3289_c5d5danx["DescendantAdded"]):Connect(function(_ae3289_c5d5dany)
      _ae3289_c5d5damw["noteHolder"](_ae3289_c5d5dany)
    end))
  end;
  while state["alive"]
  do
    pcall(_ae3289_c5d5damw["refresh"]);
    task["wait"](1)
  end
end);
local function _ae3289_c5d5danz()
  local _ae3289_c5d5dao0 = _ae3289_c5d5da30();
  local _ae3289_c5d5dao1 = {"Current date: " .. _ae3289_c5d5dao0["day"] .. " " .. _ae3289_c5d5dao0["monthName"] .. " " .. _ae3289_c5d5dao0["year"] .. " (US Eastern)", "Today is: " .. _ae3289_c5d5dao0["weekdayName"] .. ", " .. _ae3289_c5d5dao0["clock"],
    "Current month: " .. _ae3289_c5d5dao0["monthName"], "Current year: " .. _ae3289_c5d5dao0["year"], "Day of the month: " .. _ae3289_c5d5dao0["day"], "Currently active event: " .. (_ae3289_c5d5da3o() or "Spooky Scary Skeletons Event (newest event, Update 71 / 17 Oct 2026; check RECENT ANNOUNCEMENTS)"),
    };
  _ae3289_c5d5dao1[#_ae3289_c5d5dao1 + 1] = "Current server luck: " .. (contextStore["luckN"] and(contextStore["luckN"] .. "x Luck is ACTIVE right now (read live from the " .. tostring(contextStore["luckSrc"]) .. ")") or "no luck boost is showing in the game right now (normal luck)");
  local _ae3289_c5d5dao2 = {};
  for _ae3289_c5d5dao3, _ae3289_c5d5dao4 in pairs(contextStore["attributes"])
  do
    _ae3289_c5d5dao2[#_ae3289_c5d5dao2 + 1] = _ae3289_c5d5dao3 .. "=" .. _ae3289_c5d5dao4
  end;
  if #_ae3289_c5d5dao2 > 0 then
    table["sort"](_ae3289_c5d5dao2);
    _ae3289_c5d5dao1[#_ae3289_c5d5dao1 + 1] = "Live game attributes: " .. table["concat"](_ae3289_c5d5dao2, ", ")
  end;
  return table["concat"](_ae3289_c5d5dao1, "\n")
end;
local function _ae3289_c5d5dao5()
  local _ae3289_c5d5dao6 = {};
  if #contextStore["announcements"] > 0 then
    _ae3289_c5d5dao6[#_ae3289_c5d5dao6 + 1] = "=== RECENT ANNOUNCEMENTS (live from this server, oldest first - the newest is the last line) ===";
    for _ae3289_c5d5dao7, _ae3289_c5d5dao8 in ipairs(contextStore["announcements"])
    do
      _ae3289_c5d5dao6[#_ae3289_c5d5dao6 + 1] = "[" .. tostring(_ae3289_c5d5dao8["t"]) .. "] " .. tostring(_ae3289_c5d5dao8["text"])
    end
  end;
  if #contextStore["confirmed"] > 0 then
    _ae3289_c5d5dao6[#_ae3289_c5d5dao6 + 1] = "=== CODES CONFIRMED VALID THIS SESSION (riddle -> code) ===";
    for _ae3289_c5d5dao9, _ae3289_c5d5daoa in ipairs(contextStore["confirmed"])
    do
      _ae3289_c5d5dao6[#_ae3289_c5d5dao6 + 1] = tostring(_ae3289_c5d5daoa["q"]) .. " -> " .. tostring(_ae3289_c5d5daoa["code"])
    end
  end;
  return table["concat"](_ae3289_c5d5dao6, "\n")
end;
local _ae3289_c5d5daob = _ae3289_c5d5da2g(_ae3289_c5d5da2g(SYSTEM_PROMPT, "{{LIVE_STATE}}", "(given at the top of each user message, under LIVE STATE)"), "{{LIVE_CONTEXT}}", "(recent announcements and confirmed codes, when any, are given in each user message)");
local function _ae3289_c5d5daoc(_ae3289_c5d5daod)
  local _ae3289_c5d5daoe = _ae3289_c5d5dao5();
  return "=== LIVE STATE ===\n" .. _ae3289_c5d5danz() .. (_ae3289_c5d5daoe ~= "" and("\n\n" .. _ae3289_c5d5daoe) or "") .. "\n\n=== THE DEV'S MESSAGE (answer this one) ===\n" .. _ae3289_c5d5daod
end;
local _ae3289_c5d5daof = {};
local function _ae3289_c5d5daog(_ae3289_c5d5daoh, _ae3289_c5d5daoi)
  local _ae3289_c5d5daoj = {["done"] = false};
  task["spawn"](function()
    _ae3289_c5d5daoj["ok"], _ae3289_c5d5daoj["res"] = pcall(_ae3289_c5d5da5, _ae3289_c5d5daoh);
    _ae3289_c5d5daoj["done"] = true
  end);
  local _ae3289_c5d5daok = os["clock"]() + (_ae3289_c5d5daoi or aiConfig["timeout"]);
  while not _ae3289_c5d5daoj["done"] and os["clock"]() < _ae3289_c5d5daok
  do
    task["wait"](0.02)
  end;
  if not _ae3289_c5d5daoj["done"] then
    return nil, "timeout " .. (_ae3289_c5d5daoi or aiConfig["timeout"]) .. "s"
  end;
  if not _ae3289_c5d5daoj["ok"] or type(_ae3289_c5d5daoj["res"]) ~= "table" then
    return nil, "request failed"
  end;
  return _ae3289_c5d5daoj["res"]
end;
apiKeys = {["list"] = {}, ["i"] = 1, ["state"] = {}, ["coolUntil"] = {}};
local function _ae3289_c5d5daol(_ae3289_c5d5daom)
  return #_ae3289_c5d5daom > 12 and((_ae3289_c5d5daom):sub(1, 6) .. "..." .. (_ae3289_c5d5daom):sub(-4)) or "***"
end;
function apiKeys.has(_ae3289_c5d5daon)
  for _ae3289_c5d5daoo, _ae3289_c5d5daop in ipairs(apiKeys["list"])
  do
    if _ae3289_c5d5daop == _ae3289_c5d5daon then
      return true
    end
  end;
  return false
end;
function apiKeys.refresh()
  if _ae3289_c5d5da20 and _ae3289_c5d5da20["keys"] then
    pcall(_ae3289_c5d5da20["keys"])
  end
end;
function apiKeys.add(_ae3289_c5d5daoq)
  _ae3289_c5d5daoq = _ae3289_c5d5da26(_ae3289_c5d5daoq);
  if _ae3289_c5d5daoq == "" or apiKeys["has"](_ae3289_c5d5daoq) then
    return false
  end;
  apiKeys["list"][#apiKeys["list"] + 1] = _ae3289_c5d5daoq;
  apiKeys["refresh"]();
  return true
end;
function apiKeys.usable(_ae3289_c5d5daor)
  local _ae3289_c5d5daos = apiKeys["state"][_ae3289_c5d5daor];
  return _ae3289_c5d5daos ~= "bad" and(apiKeys["coolUntil"][_ae3289_c5d5daor] or 0) <= os["clock"]()
end;
function apiKeys.current()
  local _ae3289_c5d5daot = #apiKeys["list"];
  for _ae3289_c5d5daou = 0, _ae3289_c5d5daot - 1
  do
    local _ae3289_c5d5daov = (apiKeys["i"] - 1 + _ae3289_c5d5daou) % _ae3289_c5d5daot + 1;
    if apiKeys["usable"](apiKeys["list"][_ae3289_c5d5daov]) then
      if _ae3289_c5d5daov ~= apiKeys["i"] then
        apiKeys["i"] = _ae3289_c5d5daov;
        apiKeys["refresh"]()
      end;
      return apiKeys["list"][_ae3289_c5d5daov], _ae3289_c5d5daov
    end
  end;
  return nil
end;
function apiKeys.fail(_ae3289_c5d5daow, _ae3289_c5d5daox)
  if _ae3289_c5d5daox == 429 then
    apiKeys["state"][_ae3289_c5d5daow] = "limited";
    apiKeys["coolUntil"][_ae3289_c5d5daow] = os["clock"]() + 60
  else
    apiKeys["state"][_ae3289_c5d5daow] = "bad"
  end;
  local _ae3289_c5d5daoy, _ae3289_c5d5daoz = apiKeys["current"]();
  if _ae3289_c5d5da18 then
    _ae3289_c5d5da18("<font color=\"" .. colors["warn"] .. "\">api key " .. _ae3289_c5d5daol(_ae3289_c5d5daow) .. " " .. (_ae3289_c5d5daox == 429 and "rate limited" or "rejected") .. " (HTTP " .. tostring(_ae3289_c5d5daox) .. ")" .. (_ae3289_c5d5daoy and(" -> switched to key #" .. _ae3289_c5d5daoz) or " -> no working key left") .. "</font>")
  end;
  apiKeys["refresh"]()
end;
function apiKeys.test(_ae3289_c5d5dap0)
  if not _ae3289_c5d5da5 then
    return nil
  end;
  local _ae3289_c5d5dap1, _ae3289_c5d5dap2 = false, nil;
  task["spawn"](function()
    local _ae3289_c5d5dap3, _ae3289_c5d5dap4 = pcall(_ae3289_c5d5da5, {["Url"] = aiConfig["meUrl"], ["Method"] = "POST", ["Body"] = "{}", ["Headers"] = {["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer " .. _ae3289_c5d5dap0}});
    _ae3289_c5d5dap2 = _ae3289_c5d5dap3 and _ae3289_c5d5dap4 or nil;
    _ae3289_c5d5dap1 = true
  end);
  local _ae3289_c5d5dap5 = os["clock"]() + 8;
  while not _ae3289_c5d5dap1 and os["clock"]() < _ae3289_c5d5dap5
  do
    task["wait"](0.05)
  end;
  local _ae3289_c5d5dap6 = _ae3289_c5d5dap2 and tonumber(_ae3289_c5d5dap2["StatusCode"]) or 0;
  if _ae3289_c5d5dap6 >= 200 and _ae3289_c5d5dap6 < 300 then
    apiKeys["state"][_ae3289_c5d5dap0] = "ok"
  elseif _ae3289_c5d5dap6 == 401 or _ae3289_c5d5dap6 == 402 or _ae3289_c5d5dap6 == 403 then
    apiKeys["state"][_ae3289_c5d5dap0] = "bad"
  elseif _ae3289_c5d5dap6 == 429 then
    apiKeys["state"][_ae3289_c5d5dap0] = "limited";
    apiKeys["coolUntil"][_ae3289_c5d5dap0] = os["clock"]() + 60
  else
    apiKeys["state"][_ae3289_c5d5dap0] = "unknown"
  end;
  apiKeys["refresh"]();
  return _ae3289_c5d5dap6
end;
function apiKeys.testAll()
  if #apiKeys["list"] == 0 then
    if _ae3289_c5d5da18 then
      _ae3289_c5d5da18("<font color=\"" .. colors["err"] .. "\">no api keys: add one to API_KEYS at the top of the script</font>")
    end;
    return
  end;
  local _ae3289_c5d5dap7 = 0;
  for _ae3289_c5d5dap8, _ae3289_c5d5dap9 in ipairs(apiKeys["list"])
  do
    local _ae3289_c5d5dapa = apiKeys["test"](_ae3289_c5d5dap9);
    if apiKeys["state"][_ae3289_c5d5dap9] == "ok" then
      _ae3289_c5d5dap7 = _ae3289_c5d5dap7 + 1
    end;
    if _ae3289_c5d5da18 then
      local _ae3289_c5d5dapb = apiKeys["state"][_ae3289_c5d5dap9];
      _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">api key #" .. _ae3289_c5d5dap8 .. " " .. _ae3289_c5d5daol(_ae3289_c5d5dap9) .. ": </font><font color=\"" .. (_ae3289_c5d5dapb == "ok" and colors["ok"] or(_ae3289_c5d5dapb == "bad" and colors["err"] or colors["warn"])) .. "\">" .. (_ae3289_c5d5dapb == "ok" and "valid" or(_ae3289_c5d5dapb == "bad" and "invalid" or _ae3289_c5d5dapb)) .. " (" .. tostring(_ae3289_c5d5dapa) .. ")</font>")
    end
  end;
  apiKeys["i"] = 1;
  local _ae3289_c5d5dapc, _ae3289_c5d5dapd = apiKeys["current"]();
  if _ae3289_c5d5da18 then
    _ae3289_c5d5da18("<font color=\"" .. (_ae3289_c5d5dapd and colors["ok"] or colors["err"]) .. "\">" .. _ae3289_c5d5dap7 .. "/" .. #apiKeys["list"] .. " api keys valid" .. (_ae3289_c5d5dapd and(" - using key #" .. _ae3289_c5d5dapd) or " - AI is off: no working key in API_KEYS") .. "</font>")
  end;
  apiKeys["refresh"]()
end;
for _ae3289_c5d5dape, _ae3289_c5d5dapf in ipairs(_ae3289_c5d5da3)
do
  apiKeys["add"](_ae3289_c5d5dapf)
end;
local function _ae3289_c5d5dapg(_ae3289_c5d5daph, _ae3289_c5d5dapi)
  if not _ae3289_c5d5da5 then
    return nil, "executor has no request()"
  end;
  _ae3289_c5d5dapi = _ae3289_c5d5dapi or aiConfig["model"];
  local _ae3289_c5d5dapj = _ae3289_c5d5da2n({["model"] = _ae3289_c5d5dapi, ["stream"] = false, ["think"] = (_ae3289_c5d5dapi):find("^gpt%-oss") and "low" or false, ["options"] = {["temperature"] = 0},
    ["keep_alive"] = "30m", ["messages"] = {{["role"] = "system", ["content"] = _ae3289_c5d5daob}, {["role"] = "user", ["content"] = _ae3289_c5d5daoc(_ae3289_c5d5daph)},},});
  local _ae3289_c5d5dapk = "no working api key";
  for _ae3289_c5d5dapl = 1, math["max"](#apiKeys["list"], 1)
  do
    local _ae3289_c5d5dapm = apiKeys["current"]();
    if not _ae3289_c5d5dapm then
      return nil, _ae3289_c5d5dapk
    end;
    local _ae3289_c5d5dapn, _ae3289_c5d5dapo = _ae3289_c5d5daog({["Url"] = aiConfig["cloudUrl"], ["Method"] = "POST", ["Body"] = _ae3289_c5d5dapj, ["Headers"] = {["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer " .. _ae3289_c5d5dapm}});
    if not _ae3289_c5d5dapn then
      return nil, _ae3289_c5d5dapo
    end;
    local _ae3289_c5d5dapp = tonumber(_ae3289_c5d5dapn["StatusCode"]) or 0;
    if _ae3289_c5d5dapp == 401 or _ae3289_c5d5dapp == 402 or _ae3289_c5d5dapp == 403 or _ae3289_c5d5dapp == 429 then
      apiKeys["fail"](_ae3289_c5d5dapm, _ae3289_c5d5dapp);
      _ae3289_c5d5dapk = "HTTP " .. _ae3289_c5d5dapp
    elseif _ae3289_c5d5dapp < 200 or _ae3289_c5d5dapp >= 300 then
      return nil, "HTTP " .. _ae3289_c5d5dapp .. " " .. (tostring(_ae3289_c5d5dapn["Body"] or "")):sub(1, 100)
    else
      if apiKeys["state"][_ae3289_c5d5dapm] ~= "ok" then
        apiKeys["state"][_ae3289_c5d5dapm] = "ok";
        apiKeys["refresh"]()
      end;
      local _ae3289_c5d5dapq = _ae3289_c5d5da2w(_ae3289_c5d5dapn["Body"]);
      local _ae3289_c5d5dapr = _ae3289_c5d5dapq and _ae3289_c5d5dapq["message"] and _ae3289_c5d5dapq["message"]["content"];
      if type(_ae3289_c5d5dapr) ~= "string" or _ae3289_c5d5dapr == "" then
        return nil, "empty reply"
      end;
      return _ae3289_c5d5dapr
    end
  end;
  return nil, _ae3289_c5d5dapk
end;
function _ae3289_c5d5daof.parse(_ae3289_c5d5daps)
  for _ae3289_c5d5dapt in(tostring(_ae3289_c5d5daps)):gmatch("[^\r\n]+")
  do
    _ae3289_c5d5dapt = (_ae3289_c5d5da26(_ae3289_c5d5dapt)):gsub("^[%*`\"'>#%s]+", "");
    local _ae3289_c5d5dapu = (_ae3289_c5d5dapt):upper();
    for _ae3289_c5d5dapv, _ae3289_c5d5dapw in ipairs({"CODE", "ANSWER"})
    do
      if(_ae3289_c5d5dapu):sub(1, #_ae3289_c5d5dapw + 1) == _ae3289_c5d5dapw .. ":" then
        local _ae3289_c5d5dapx = _ae3289_c5d5da26((_ae3289_c5d5dapt):sub(#_ae3289_c5d5dapw + 2));
        local _ae3289_c5d5dapy = {["mode"] = _ae3289_c5d5dapw};
        local _ae3289_c5d5dapz, _ae3289_c5d5daq0 = (_ae3289_c5d5dapx):match("^(.-)%s*||%s*[Aa][Ll][Tt]%s*:%s*(.+)$");
        _ae3289_c5d5dapz = _ae3289_c5d5da26(((_ae3289_c5d5dapz or _ae3289_c5d5dapx)):gsub("||.*$", ""));
        if _ae3289_c5d5dapw == "CODE" then
          _ae3289_c5d5dapy["main"] = _ae3289_c5d5da2c(_ae3289_c5d5dapz);
          _ae3289_c5d5dapy["alt"] = _ae3289_c5d5daq0 and _ae3289_c5d5da2c(_ae3289_c5d5daq0) or nil;
          if _ae3289_c5d5dapy["alt"] == "" or _ae3289_c5d5dapy["alt"] == _ae3289_c5d5dapy["main"] then
            _ae3289_c5d5dapy["alt"] = nil
          end
        else
          _ae3289_c5d5dapy["main"] = _ae3289_c5d5da26(_ae3289_c5d5dapz);
          _ae3289_c5d5dapy["alt"] = _ae3289_c5d5daq0 and _ae3289_c5d5da26(_ae3289_c5d5daq0) or nil
        end;
        if _ae3289_c5d5dapy["main"] ~= "" then
          return _ae3289_c5d5dapy
        end
      end
    end
  end;
  return nil
end;
function _ae3289_c5d5daof.ask(_ae3289_c5d5daq1)
  local _ae3289_c5d5daq2 = os["clock"]();
  local _ae3289_c5d5daq3 = math["clamp"](math["floor"](tonumber(settings["aiRace"]) or 1), 1, 3);
  local _ae3289_c5d5daq4 = {["result"] = nil, ["err"] = nil, ["pending"] = 0};
  local function _ae3289_c5d5daq5(_ae3289_c5d5daq6)
    _ae3289_c5d5daq4["pending"] = _ae3289_c5d5daq4["pending"] + 1;
    local _ae3289_c5d5daq7 = aiConfig["models"][(_ae3289_c5d5daq6 - 1) % #aiConfig["models"] + 1];
    task["spawn"](function()
      local _ae3289_c5d5daq8, _ae3289_c5d5daq9, _ae3289_c5d5daqa = pcall(_ae3289_c5d5dapg, _ae3289_c5d5daq1, _ae3289_c5d5daq7);
      if not _ae3289_c5d5daq8 then
        _ae3289_c5d5daq9, _ae3289_c5d5daqa = nil, tostring(_ae3289_c5d5daq9)
      end;
      local _ae3289_c5d5daqb = _ae3289_c5d5daq9 and _ae3289_c5d5daof["parse"](_ae3289_c5d5daq9);
      if _ae3289_c5d5daqb then
        if not _ae3289_c5d5daq4["result"] then
          _ae3289_c5d5daqb["model"] = _ae3289_c5d5daq7;
          _ae3289_c5d5daqb["ms"] = math["floor"]((os["clock"]() - _ae3289_c5d5daq2) * 1000);
          _ae3289_c5d5daqb["lane"] = _ae3289_c5d5daq6;
          _ae3289_c5d5daq4["result"] = _ae3289_c5d5daqb
        end
      else
        _ae3289_c5d5daq4["err"] = _ae3289_c5d5daqa or("unparseable: " .. (tostring(_ae3289_c5d5daq9)):sub(1, 60))
      end;
      _ae3289_c5d5daq4["pending"] = _ae3289_c5d5daq4["pending"] - 1
    end)
  end;
  _ae3289_c5d5daq5(1);
  local _ae3289_c5d5daqc = 1;
  local _ae3289_c5d5daqd = _ae3289_c5d5daq2 + aiConfig["timeout"] + 1;
  local _ae3289_c5d5daqe = false;
  while not _ae3289_c5d5daq4["result"] and os["clock"]() < _ae3289_c5d5daqd and state["alive"]
  do
    if _ae3289_c5d5daqc < _ae3289_c5d5daq3 and(_ae3289_c5d5daq4["pending"] == 0 or os["clock"]() - _ae3289_c5d5daq2 >= aiConfig["hedgeAfter"] * _ae3289_c5d5daqc) then
      _ae3289_c5d5daqc = _ae3289_c5d5daqc + 1;
      _ae3289_c5d5daq5(_ae3289_c5d5daqc)
    elseif _ae3289_c5d5daq4["pending"] == 0 then
      if _ae3289_c5d5daqe or _ae3289_c5d5daqd - os["clock"]() < 4 then
        break
      end;
      _ae3289_c5d5daqe = true;
      _ae3289_c5d5daqc = _ae3289_c5d5daqc + 1;
      _ae3289_c5d5daq5(_ae3289_c5d5daqc)
    end;
    task["wait"](0.02)
  end;
  if _ae3289_c5d5daq4["result"] then
    return _ae3289_c5d5daq4["result"]
  end;
  return nil, _ae3289_c5d5daq4["err"] or "timeout"
end;
task["spawn"](function()
  if not _ae3289_c5d5da5 then
    return
  end;
  apiKeys["testAll"]();
  while state["alive"]
  do
    local _ae3289_c5d5daqf = os["clock"]();
    local _ae3289_c5d5daqg = _ae3289_c5d5daog({["Url"] = aiConfig["tagsUrl"], ["Method"] = "GET"}, 8);
    if _ae3289_c5d5da20 and _ae3289_c5d5da20["aiNote"] and _ae3289_c5d5daqg and not _ae3289_c5d5da20["_warmed"] then
      _ae3289_c5d5da20["_warmed"] = true;
      _ae3289_c5d5da20["aiNote"]("model " .. aiConfig["model"] .. "  |  link warm (" .. math["floor"]((os["clock"]() - _ae3289_c5d5daqf) * 1000) .. "ms)")
    end;
    task["wait"](120)
  end
end);
local _ae3289_c5d5daqh = {["waiting"] = false, ["result"] = nil, ["text"] = nil};
local _ae3289_c5d5daqi = {"invalid", "doesn't exist", "does not exist", "doesnt exist", "not exist", "not found", "incorrect", "wrong code", "not a valid", "unknown code", "not valid",
  "isn't valid", "isnt valid", "try again", "wrong", "failed", "no such code"};
local _ae3289_c5d5daqj = {"already redeemed", "already used", "already claimed", "expired", "max uses", "no uses left", "limit reached", " fully redeemed"};
local _ae3289_c5d5daqk = {"slow down", "too fast", "too many", "cooldown", "cool down", "please wait", "wait before", "wait a ", "spam"};
local _ae3289_c5d5daql = {"redeemed", "success", "claimed", "you got", "you received", "rewarded", "code accepted"};
local _ae3289_c5d5daqm = {"code", "redeem", "doesn't exist", "does not exist", "doesnt exist", "expired"};
local function _ae3289_c5d5daqn(_ae3289_c5d5daqo)
  local _ae3289_c5d5daqp = (tostring(_ae3289_c5d5daqo or "")):lower();
  if _ae3289_c5d5daqp == "" or #_ae3289_c5d5daqp > 160 then
    return nil
  end;
  local _ae3289_c5d5daqq = false;
  for _ae3289_c5d5daqr, _ae3289_c5d5daqs in ipairs(_ae3289_c5d5daqm)
  do
    if(_ae3289_c5d5daqp):find(_ae3289_c5d5daqs, 1, true) then
      _ae3289_c5d5daqq = true;
      break
    end
  end;
  if not _ae3289_c5d5daqq then
    return nil
  end;
  for _ae3289_c5d5daqt, _ae3289_c5d5daqu in ipairs(_ae3289_c5d5daqk)
  do
    if(_ae3289_c5d5daqp):find(_ae3289_c5d5daqu, 1, true) then
      return "cool"
    end
  end;
  for _ae3289_c5d5daqv, _ae3289_c5d5daqw in ipairs(_ae3289_c5d5daqi)
  do
    if(_ae3289_c5d5daqp):find(_ae3289_c5d5daqw, 1, true) then
      return "bad"
    end
  end;
  for _ae3289_c5d5daqx, _ae3289_c5d5daqy in ipairs(_ae3289_c5d5daqj)
  do
    if(_ae3289_c5d5daqp):find(_ae3289_c5d5daqy, 1, true) then
      return "used"
    end
  end;
  for _ae3289_c5d5daqz, _ae3289_c5d5dar0 in ipairs(_ae3289_c5d5daql)
  do
    if(_ae3289_c5d5daqp):find(_ae3289_c5d5dar0, 1, true) then
      return "ok"
    end
  end;
  return nil
end;
local _ae3289_c5d5dar1;
do
  local _ae3289_c5d5dar2, _ae3289_c5d5dar3, _ae3289_c5d5dar4, _ae3289_c5d5dar5, _ae3289_c5d5dar6, _ae3289_c5d5dar7 = bit32["band"], bit32["bor"], bit32["bxor"], bit32["bnot"], bit32["rrotate"],
    bit32["rshift"];
  local _ae3289_c5d5dar8 = {1116352408, 1899447441, 0xb5c0fbcf, 0xe9b5dba5, 961987163, 1508970993, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 310598401, 0x243185be, 1426881987, 0x72be5d74,
    0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 264347078, 604807628, 0x2de92c6f, 1249150122, 1555081692, 1996064986, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 113926993, 338241895, 666307205, 0x2e1b2138, 1294757372, 1396182291, 1695183700, 1986661051, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 275423344, 430227734, 0x1e376c08, 659060556, 883997877, 958139571, 0x4ed8aa4a, 1537002063, 0x682e6ff3, 0x748f82ee, 2024104815, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,};
  local function _ae3289_c5d5dar9(_ae3289_c5d5dara)
    local _ae3289_c5d5darb = #_ae3289_c5d5dara;
    _ae3289_c5d5dara = _ae3289_c5d5dara .. "\128" .. string["rep"]("\000", (55 - _ae3289_c5d5darb) % 64) .. string["pack"](">I8", _ae3289_c5d5darb * 8);
    local _ae3289_c5d5darc, _ae3289_c5d5dard, _ae3289_c5d5dare, _ae3289_c5d5darf = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a;
    local _ae3289_c5d5darg, _ae3289_c5d5darh, _ae3289_c5d5dari, _ae3289_c5d5darj = 0x510e527f, 0x9b05688c, 528734635, 0x5be0cd19;
    local _ae3289_c5d5dark = {};
    for _ae3289_c5d5darl = 1, #_ae3289_c5d5dara, 64
    do
      for _ae3289_c5d5darm = 0, 15
      do
        _ae3289_c5d5dark[_ae3289_c5d5darm] = string["unpack"](">I4", _ae3289_c5d5dara, _ae3289_c5d5darl + _ae3289_c5d5darm * 4)
      end;
      for _ae3289_c5d5darn = 16, 63
      do
        local _ae3289_c5d5daro, _ae3289_c5d5darp = _ae3289_c5d5dark[_ae3289_c5d5darn - 15], _ae3289_c5d5dark[_ae3289_c5d5darn - 2];
        local _ae3289_c5d5darq = _ae3289_c5d5dar4(_ae3289_c5d5dar6(_ae3289_c5d5daro, 7), _ae3289_c5d5dar6(_ae3289_c5d5daro, 18), _ae3289_c5d5dar7(_ae3289_c5d5daro, 3));
        local _ae3289_c5d5darr = _ae3289_c5d5dar4(_ae3289_c5d5dar6(_ae3289_c5d5darp, 17), _ae3289_c5d5dar6(_ae3289_c5d5darp, 19), _ae3289_c5d5dar7(_ae3289_c5d5darp, 10));
        _ae3289_c5d5dark[_ae3289_c5d5darn] = _ae3289_c5d5dar2(_ae3289_c5d5dark[_ae3289_c5d5darn - 16] + _ae3289_c5d5darq + _ae3289_c5d5dark[_ae3289_c5d5darn - 7] + _ae3289_c5d5darr,
          0xffffffff)
      end;
      local _ae3289_c5d5dars, _ae3289_c5d5dart, _ae3289_c5d5daru, _ae3289_c5d5darv, _ae3289_c5d5darw, _ae3289_c5d5darx, _ae3289_c5d5dary, _ae3289_c5d5darz = _ae3289_c5d5darc, _ae3289_c5d5dard,
        _ae3289_c5d5dare, _ae3289_c5d5darf, _ae3289_c5d5darg, _ae3289_c5d5darh, _ae3289_c5d5dari, _ae3289_c5d5darj;
      for _ae3289_c5d5das0 = 0, 63
      do
        local _ae3289_c5d5das1 = _ae3289_c5d5dar4(_ae3289_c5d5dar6(_ae3289_c5d5darw, 6), _ae3289_c5d5dar6(_ae3289_c5d5darw, 11), _ae3289_c5d5dar6(_ae3289_c5d5darw, 25));
        local _ae3289_c5d5das2 = _ae3289_c5d5dar4(_ae3289_c5d5dar2(_ae3289_c5d5darw, _ae3289_c5d5darx), _ae3289_c5d5dar2(_ae3289_c5d5dar5(_ae3289_c5d5darw), _ae3289_c5d5dary));
        local _ae3289_c5d5das3 = _ae3289_c5d5darz + _ae3289_c5d5das1 + _ae3289_c5d5das2 + _ae3289_c5d5dar8[_ae3289_c5d5das0 + 1] + _ae3289_c5d5dark[_ae3289_c5d5das0];
        local _ae3289_c5d5das4 = _ae3289_c5d5dar4(_ae3289_c5d5dar6(_ae3289_c5d5dars, 2), _ae3289_c5d5dar6(_ae3289_c5d5dars, 13), _ae3289_c5d5dar6(_ae3289_c5d5dars, 22));
        local _ae3289_c5d5das5 = _ae3289_c5d5dar4(_ae3289_c5d5dar2(_ae3289_c5d5dars, _ae3289_c5d5dart), _ae3289_c5d5dar2(_ae3289_c5d5dars, _ae3289_c5d5daru), _ae3289_c5d5dar2(_ae3289_c5d5dart,
          _ae3289_c5d5daru));
        _ae3289_c5d5darz, _ae3289_c5d5dary, _ae3289_c5d5darx, _ae3289_c5d5darw, _ae3289_c5d5darv, _ae3289_c5d5daru, _ae3289_c5d5dart, _ae3289_c5d5dars = _ae3289_c5d5dary, _ae3289_c5d5darx,
          _ae3289_c5d5darw, _ae3289_c5d5dar2(_ae3289_c5d5darv + _ae3289_c5d5das3, 0xffffffff), _ae3289_c5d5daru, _ae3289_c5d5dart, _ae3289_c5d5dars, _ae3289_c5d5dar2(_ae3289_c5d5das3 + _ae3289_c5d5das4 + _ae3289_c5d5das5,
          0xffffffff)
      end;
      _ae3289_c5d5darc, _ae3289_c5d5dard, _ae3289_c5d5dare, _ae3289_c5d5darf = _ae3289_c5d5dar2(_ae3289_c5d5darc + _ae3289_c5d5dars, 0xffffffff), _ae3289_c5d5dar2(_ae3289_c5d5dard + _ae3289_c5d5dart,
        0xffffffff), _ae3289_c5d5dar2(_ae3289_c5d5dare + _ae3289_c5d5daru, 0xffffffff), _ae3289_c5d5dar2(_ae3289_c5d5darf + _ae3289_c5d5darv, 0xffffffff);
      _ae3289_c5d5darg, _ae3289_c5d5darh, _ae3289_c5d5dari, _ae3289_c5d5darj = _ae3289_c5d5dar2(_ae3289_c5d5darg + _ae3289_c5d5darw, 0xffffffff), _ae3289_c5d5dar2(_ae3289_c5d5darh + _ae3289_c5d5darx,
        0xffffffff), _ae3289_c5d5dar2(_ae3289_c5d5dari + _ae3289_c5d5dary, 0xffffffff), _ae3289_c5d5dar2(_ae3289_c5d5darj + _ae3289_c5d5darz, 0xffffffff)
    end;
    return string["pack"](">I4I4I4I4I4I4I4I4", _ae3289_c5d5darc, _ae3289_c5d5dard, _ae3289_c5d5dare, _ae3289_c5d5darf, _ae3289_c5d5darg, _ae3289_c5d5darh, _ae3289_c5d5dari, _ae3289_c5d5darj)
  end;
  local function _ae3289_c5d5das6(_ae3289_c5d5das7)
    return((_ae3289_c5d5das7):gsub(".", function(_ae3289_c5d5das8)
      return string["format"]("%02x", (_ae3289_c5d5das8):byte())
    end))
  end;
  _ae3289_c5d5dar1 = {["hmac"] = function(_ae3289_c5d5das9, _ae3289_c5d5dasa)
    if #_ae3289_c5d5das9 > 64 then
      _ae3289_c5d5das9 = _ae3289_c5d5dar9(_ae3289_c5d5das9)
    end;
    _ae3289_c5d5das9 = _ae3289_c5d5das9 .. string["rep"]("\000", 64 - #_ae3289_c5d5das9);
    local _ae3289_c5d5dasc = (_ae3289_c5d5das9):gsub(".", function(_ae3289_c5d5dasb)
      return string["char"](_ae3289_c5d5dar4((_ae3289_c5d5dasb):byte(), 54))
    end);
    local _ae3289_c5d5dase = (_ae3289_c5d5das9):gsub(".", function(_ae3289_c5d5dasd)
      return string["char"](_ae3289_c5d5dar4((_ae3289_c5d5dasd):byte(), 92))
    end);
    return _ae3289_c5d5das6(_ae3289_c5d5dar9(_ae3289_c5d5dase .. _ae3289_c5d5dar9(_ae3289_c5d5dasc .. _ae3289_c5d5dasa)))
  end, ["sha256"] = function(_ae3289_c5d5dasf)
    return _ae3289_c5d5das6(_ae3289_c5d5dar9(_ae3289_c5d5dasf))
  end,}
end;
local function _ae3289_c5d5dasg(_ae3289_c5d5dash, _ae3289_c5d5dasi, _ae3289_c5d5dasj)
  if not _ae3289_c5d5da5 or not _ae3289_c5d5dasi or _ae3289_c5d5da1 == "" or(_ae3289_c5d5da1):find("YOUR_SERVER", 1, true) then
    return
  end;
  local _ae3289_c5d5dask = state["redeemCtx"] or {["kind"] = "code"};
  task["spawn"](function()
    local _ae3289_c5d5dasl;
    pcall(function()
      local _ae3289_c5d5dasm = rawget(genv, "skyr0") or skyr0;
      if type(_ae3289_c5d5dasm) == "table" and type(_ae3289_c5d5dasm["getUser"]) == "function" then
        _ae3289_c5d5dasl = _ae3289_c5d5dasm["getUser"]()
      end
    end);
    local _ae3289_c5d5dasn = _ae3289_c5d5da2n({["player"] = LocalPlayer["Name"], ["userId"] = LocalPlayer["UserId"], ["discordId"] = _ae3289_c5d5dasl and _ae3289_c5d5dasl["id"] and tostring(_ae3289_c5d5dasl["id"]) or nil,
      ["discordTag"] = _ae3289_c5d5dasl and _ae3289_c5d5dasl["tag"] and tostring(_ae3289_c5d5dasl["tag"]) or nil, ["brainrot"] = _ae3289_c5d5dasi, ["code"] = _ae3289_c5d5da2c(_ae3289_c5d5dash),
      ["kind"] = _ae3289_c5d5dask["kind"], ["riddle"] = _ae3289_c5d5dask["kind"] == "riddle" and _ae3289_c5d5dask["riddle"] or nil, ["seconds"] = _ae3289_c5d5dasj and _ae3289_c5d5dasj / 1000 or nil,
      ["placeId"] = game["PlaceId"], ["jobId"] = game["JobId"],});
    local _ae3289_c5d5daso, _ae3289_c5d5dasp = pcall(function()
      return(workspace):GetServerTimeNow()
    end);
    local _ae3289_c5d5dasq = tostring(math["floor"](_ae3289_c5d5daso and _ae3289_c5d5dasp or os["time"]()));
    local _ae3289_c5d5dasr, _ae3289_c5d5dass = pcall(_ae3289_c5d5da5, {["Url"] = _ae3289_c5d5da1, ["Method"] = "POST", ["Body"] = _ae3289_c5d5dasn, ["Headers"] = {["Content-Type"] = "application/json",
      ["X-Skyr0-Ts"] = _ae3289_c5d5dasq, ["X-Skyr0-Sig"] = _ae3289_c5d5dar1["hmac"](_ae3289_c5d5da2, _ae3289_c5d5dasq .. "." .. _ae3289_c5d5dasn),}});
    local _ae3289_c5d5dast = _ae3289_c5d5dasr and type(_ae3289_c5d5dass) == "table" and tonumber(_ae3289_c5d5dass["StatusCode"]) or 0;
    if _ae3289_c5d5da18 then
      local _ae3289_c5d5dasu = _ae3289_c5d5dast >= 200 and _ae3289_c5d5dast < 300;
      local _ae3289_c5d5dasv = not _ae3289_c5d5dasr and tostring(_ae3289_c5d5dass) or(type(_ae3289_c5d5dass) == "table" and tostring(_ae3289_c5d5dass["Body"] or "")) or "";
      _ae3289_c5d5da18("<font color=\"" .. (_ae3289_c5d5dasu and colors["ok"] or colors["err"]) .. "\">feed: " .. (_ae3289_c5d5dasu and("sent " .. _ae3289_c5d5da2e(_ae3289_c5d5dasi)) or("failed (" .. _ae3289_c5d5dast .. ") " .. _ae3289_c5d5da2e((_ae3289_c5d5dasv):sub(1,
        100)))) .. "</font>")
    end
  end)
end;
local function _ae3289_c5d5dasw(_ae3289_c5d5dasx)
  if #_ae3289_c5d5dasx > 90 then
    return nil
  end;
  local _ae3289_c5d5dasy = ((_ae3289_c5d5dasx):lower()):find("%s+spawned");
  if not _ae3289_c5d5dasy then
    return nil
  end;
  local _ae3289_c5d5dasz = (((_ae3289_c5d5da26((_ae3289_c5d5dasx):sub(1, _ae3289_c5d5dasy - 1))):gsub("%s+[Hh][Aa][Ss]$", "")):gsub("^[Yy]our%s+", "")):gsub("^[Aa]n?%s+", "");
  _ae3289_c5d5dasz = _ae3289_c5d5da26(_ae3289_c5d5dasz);
  return _ae3289_c5d5dasz ~= "" and _ae3289_c5d5dasz or nil
end;
local function _ae3289_c5d5dat0(_ae3289_c5d5dat1)
  if _ae3289_c5d5da20 and _ae3289_c5d5da20["toast"] then
    _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["acc"] .. "\">" .. _ae3289_c5d5da2e(_ae3289_c5d5dat1) .. "</font>  spawned!", _ae3289_c5d5da1r["accent"])
  end
end;
local function _ae3289_c5d5dat2(_ae3289_c5d5dat3)
  local _ae3289_c5d5dat4 = _ae3289_c5d5da28(tostring(_ae3289_c5d5dat3 or ""));
  local _ae3289_c5d5dat5 = _ae3289_c5d5dasw(_ae3289_c5d5dat4);
  if _ae3289_c5d5dat5 and(_ae3289_c5d5daqh["waiting"] or os["clock"]() < (_ae3289_c5d5daqh["rewardUntil"] or 0)) then
    _ae3289_c5d5daqh["reward"] = _ae3289_c5d5dat5;
    if _ae3289_c5d5daqh["waiting"] and _ae3289_c5d5daqh["result"] == nil then
      _ae3289_c5d5daqh["result"], _ae3289_c5d5daqh["text"], _ae3289_c5d5daqh["at"] = "ok", _ae3289_c5d5dat3, os["clock"]()
    elseif not _ae3289_c5d5daqh["waiting"] and not _ae3289_c5d5daqh["rewardShown"] then
      _ae3289_c5d5daqh["rewardShown"] = true;
      pcall(_ae3289_c5d5dat0, _ae3289_c5d5dat5);
      pcall(_ae3289_c5d5dasg, _ae3289_c5d5daqh["code"], _ae3289_c5d5dat5, _ae3289_c5d5daqh["lastMs"]);
      if _ae3289_c5d5da18 then
        _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">  got: </font><font color=\"" .. colors["acc"] .. "\">" .. _ae3289_c5d5da2e(_ae3289_c5d5dat5) .. " spawned!</font>")
      end
    end;
    return true
  end;
  local _ae3289_c5d5dat6 = _ae3289_c5d5daqn(_ae3289_c5d5dat4);
  if not _ae3289_c5d5dat6 then
    return false
  end;
  if _ae3289_c5d5daqh["waiting"] and _ae3289_c5d5daqh["result"] == nil then
    local _ae3289_c5d5dat7 = (_ae3289_c5d5da28(tostring(_ae3289_c5d5dat3))):upper();
    local _ae3289_c5d5dat8, _ae3289_c5d5dat9 = _ae3289_c5d5daqh["prev"], _ae3289_c5d5daqh["code"];
    local _ae3289_c5d5data = _ae3289_c5d5dat8 and _ae3289_c5d5dat8 ~= _ae3289_c5d5dat9 and #_ae3289_c5d5dat8 >= 3 and(_ae3289_c5d5dat7):find(_ae3289_c5d5dat8, 1, true) ~= nil and not(_ae3289_c5d5dat9 and(_ae3289_c5d5dat7):find(_ae3289_c5d5dat9,
      1, true));
    if not _ae3289_c5d5data then
      _ae3289_c5d5daqh["result"], _ae3289_c5d5daqh["text"], _ae3289_c5d5daqh["at"] = _ae3289_c5d5dat6, _ae3289_c5d5dat3, os["clock"]()
    end
  end;
  return true
end;
local _ae3289_c5d5datb = false;
local function _ae3289_c5d5datc(_ae3289_c5d5datd, _ae3289_c5d5date, _ae3289_c5d5datf, _ae3289_c5d5datg, _ae3289_c5d5dath, _ae3289_c5d5dati)
  if not(_ae3289_c5d5da20 and _ae3289_c5d5da20["toast"]) then
    return
  end;
  local _ae3289_c5d5datj = (_ae3289_c5d5dati and("<font color=\"" .. colors["white"] .. "\">  " .. string["format"]("%.2fs", _ae3289_c5d5dati / 1000) .. "</font>") or "") .. (_ae3289_c5d5dath and("<font color=\"" .. colors["dim"] .. "\">  " .. _ae3289_c5d5da2e(_ae3289_c5d5dath) .. "</font>") or "");
  if _ae3289_c5d5date == "ok" then
    _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["ok"] .. "\">REDEEMED</font>  " .. _ae3289_c5d5da2e(_ae3289_c5d5datd) .. _ae3289_c5d5datj, _ae3289_c5d5da1r["ok"])
  elseif _ae3289_c5d5date == "used" then
    _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["ok"] .. "\">VALID (USED)</font>  " .. _ae3289_c5d5da2e(_ae3289_c5d5datd) .. _ae3289_c5d5datj, _ae3289_c5d5da1r["ok"])
  elseif _ae3289_c5d5date == "bad" then
    _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["err"] .. "\">INVALID</font>  " .. _ae3289_c5d5da2e(_ae3289_c5d5datd) .. _ae3289_c5d5datj, _ae3289_c5d5da1r["err"])
  elseif _ae3289_c5d5datf then
    _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["warn"] .. "\">SENT</font>  " .. _ae3289_c5d5da2e(_ae3289_c5d5datd) .. _ae3289_c5d5datj .. "<font color=\"" .. colors["dim"] .. "\">  no reply</font>",
      _ae3289_c5d5da1r["warn"])
  else
    _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["err"] .. "\">FAILED</font>  " .. _ae3289_c5d5da2e(_ae3289_c5d5datd) .. "<font color=\"" .. colors["dim"] .. "\">  " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5datg or "")) .. "</font>",
      _ae3289_c5d5da1r["err"])
  end
end;
-- ===== AI request path =====
local function _ae3289_c5d5datk(_ae3289_c5d5datl, _ae3289_c5d5datm, _ae3289_c5d5datn, _ae3289_c5d5dato, _ae3289_c5d5datp)
  local _ae3289_c5d5datq = os["clock"]() + 6;
  while _ae3289_c5d5datb and os["clock"]() < _ae3289_c5d5datq
  do
    task["wait"]()
  end;
  _ae3289_c5d5datb = true;
  if _ae3289_c5d5daqh["lastNoReply"] and os["clock"]() - _ae3289_c5d5daqh["lastNoReply"] < 0.35 then
    local _ae3289_c5d5datr = _ae3289_c5d5daqh["lastNoReply"] + 0.35;
    while os["clock"]() < _ae3289_c5d5datr
    do
      task["wait"](0.02)
    end
  end;
  _ae3289_c5d5daqh["code"] = _ae3289_c5d5da2c(_ae3289_c5d5datl);
  _ae3289_c5d5daqh["reward"], _ae3289_c5d5daqh["rewardShown"], _ae3289_c5d5daqh["rewardUntil"] = nil, false, 0;
  local _ae3289_c5d5dats, _ae3289_c5d5datt, _ae3289_c5d5datu, _ae3289_c5d5datv;
  for _ae3289_c5d5datw = 1, 2
  do
    _ae3289_c5d5daqh["result"], _ae3289_c5d5daqh["text"], _ae3289_c5d5daqh["waiting"], _ae3289_c5d5daqh["at"] = nil, nil, true, nil;
    _ae3289_c5d5datv = os["clock"]();
    _ae3289_c5d5dats, _ae3289_c5d5datt, _ae3289_c5d5datu = pcall(_ae3289_c5d5da1b, _ae3289_c5d5datl, _ae3289_c5d5datm);
    if not _ae3289_c5d5dats then
      _ae3289_c5d5datt, _ae3289_c5d5datu = false, tostring(_ae3289_c5d5datt)
    end;
    local _ae3289_c5d5datx = os["clock"]() + (_ae3289_c5d5datn or 1.2);
    while _ae3289_c5d5datt and _ae3289_c5d5daqh["result"] == nil and os["clock"]() < _ae3289_c5d5datx
    do
      task["wait"]()
    end;
    if _ae3289_c5d5daqh["result"] ~= "cool" or _ae3289_c5d5datw == 2 then
      break
    end;
    local _ae3289_c5d5daty = os["clock"]() + 0.6;
    while os["clock"]() < _ae3289_c5d5daty
    do
      task["wait"]()
    end
  end;
  if _ae3289_c5d5daqh["result"] == "cool" then
    _ae3289_c5d5daqh["result"] = nil
  end;
  if _ae3289_c5d5daqh["result"] == "ok" and not _ae3289_c5d5daqh["reward"] then
    local _ae3289_c5d5datz = os["clock"]() + 0.8;
    while not _ae3289_c5d5daqh["reward"] and os["clock"]() < _ae3289_c5d5datz
    do
      task["wait"]()
    end
  end;
  local _ae3289_c5d5dau0 = _ae3289_c5d5daqh["result"] and _ae3289_c5d5daqh["at"] and math["floor"]((_ae3289_c5d5daqh["at"] - (_ae3289_c5d5datp or _ae3289_c5d5datv)) * 1000 + 0.5) or nil;
  _ae3289_c5d5daqh["waiting"] = false;
  _ae3289_c5d5daqh["rewardUntil"] = _ae3289_c5d5daqh["result"] == "ok" and os["clock"]() + 3 or 0;
  _ae3289_c5d5daqh["lastNoReply"] = (_ae3289_c5d5datt and _ae3289_c5d5daqh["result"] == nil) and os["clock"]() or nil;
  _ae3289_c5d5daqh["prev"] = _ae3289_c5d5daqh["code"];
  _ae3289_c5d5datb = false;
  local _ae3289_c5d5dau1, _ae3289_c5d5dau2 = _ae3289_c5d5daqh["result"], _ae3289_c5d5daqh["reward"];
  pcall(_ae3289_c5d5datc, _ae3289_c5d5datl, _ae3289_c5d5dau1, _ae3289_c5d5datt, _ae3289_c5d5datu, _ae3289_c5d5dato, _ae3289_c5d5dau0);
  if _ae3289_c5d5dau0 and _ae3289_c5d5da18 then
    _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">  " .. _ae3289_c5d5da2e(_ae3289_c5d5datl) .. " " .. tostring(_ae3289_c5d5dau1) .. " in " .. string["format"]("%.2fs", _ae3289_c5d5dau0 / 1000) .. (_ae3289_c5d5dau2 and("</font><font color=\"" .. colors["acc"] .. "\"> -> " .. _ae3289_c5d5da2e(_ae3289_c5d5dau2) .. " spawned!") or "") .. "</font>")
  end;
  _ae3289_c5d5daqh["lastMs"] = _ae3289_c5d5dau0;
  if _ae3289_c5d5dau2 then
    _ae3289_c5d5daqh["rewardShown"] = true;
    pcall(_ae3289_c5d5dat0, _ae3289_c5d5dau2);
    pcall(_ae3289_c5d5dasg, _ae3289_c5d5datl, _ae3289_c5d5dau2, _ae3289_c5d5dau0)
  end;
  return _ae3289_c5d5dau1, _ae3289_c5d5datt, _ae3289_c5d5datu
end;
local function _ae3289_c5d5dau3(_ae3289_c5d5dau4)
  local _ae3289_c5d5dau5, _ae3289_c5d5dau6 = {}, {[_ae3289_c5d5dau4] = true};
  local function _ae3289_c5d5dau7(_ae3289_c5d5dau8)
    if _ae3289_c5d5dau8 and _ae3289_c5d5dau8 ~= "" and not _ae3289_c5d5dau6[_ae3289_c5d5dau8] then
      _ae3289_c5d5dau6[_ae3289_c5d5dau8] = true;
      _ae3289_c5d5dau5[#_ae3289_c5d5dau5 + 1] = _ae3289_c5d5dau8
    end
  end;
  if(_ae3289_c5d5dau4):sub(-1) == "S" then
    _ae3289_c5d5dau7((_ae3289_c5d5dau4):sub(1, -2));
    if(_ae3289_c5d5dau4):sub(-3) == "IES" then
      _ae3289_c5d5dau7((_ae3289_c5d5dau4):sub(1, -4) .. "Y")
    end;
    if(_ae3289_c5d5dau4):sub(-2) == "ES" then
      _ae3289_c5d5dau7((_ae3289_c5d5dau4):sub(1, -3))
    end
  else
    _ae3289_c5d5dau7(_ae3289_c5d5dau4 .. "S");
    if(_ae3289_c5d5dau4):sub(-1) == "Y" then
      _ae3289_c5d5dau7((_ae3289_c5d5dau4):sub(1, -2) .. "IES")
    end
  end;
  if(_ae3289_c5d5dau4):sub(1, 3) == "THE" and #_ae3289_c5d5dau4 > 5 then
    _ae3289_c5d5dau7((_ae3289_c5d5dau4):sub(4))
  end;
  if(_ae3289_c5d5dau4):match("^%d+X$") then
    _ae3289_c5d5dau7(_ae3289_c5d5dau4 .. "LUCK")
  end;
  if(_ae3289_c5d5dau4):match("^%d+XLUCK$") then
    _ae3289_c5d5dau7((_ae3289_c5d5dau4):sub(1, -5))
  end;
  local _ae3289_c5d5dau9, _ae3289_c5d5daua = (_ae3289_c5d5dau4):match("^(.-%a)(%d+)$");
  if _ae3289_c5d5dau9 and _ae3289_c5d5daua then
    if(_ae3289_c5d5dau9):sub(-1) == "S" then
      _ae3289_c5d5dau7((_ae3289_c5d5dau9):sub(1, -2) .. _ae3289_c5d5daua)
    else
      _ae3289_c5d5dau7(_ae3289_c5d5dau9 .. "S" .. _ae3289_c5d5daua)
    end
  end;
  return _ae3289_c5d5dau5
end;
_ae3289_c5d5da1d = function()
  state["capturedParts"], state["partTarget"], state["fragDirty"], state["halted"], state["failedTries"] = {}, nil, false, false, 0;
  if _ae3289_c5d5da20 and _ae3289_c5d5da20["capture"] then
    _ae3289_c5d5da20["capture"](state["capturedParts"], settings["submitAfter"])
  end
end;
local function _ae3289_c5d5daub()
  if state["boxTextConn"] then
    pcall(function()
      (state["boxTextConn"]):Disconnect()
    end)
  end;
  if state["boxAncestryConn"] then
    pcall(function()
      (state["boxAncestryConn"]):Disconnect()
    end)
  end;
  state["boxTextConn"], state["boxAncestryConn"], state["lastWatchedBox"] = nil, nil, nil
end;
local function _ae3289_c5d5dauc(_ae3289_c5d5daud)
  if not _ae3289_c5d5daud or state["lastWatchedBox"] == _ae3289_c5d5daud then
    return
  end;
  _ae3289_c5d5daub();
  state["lastWatchedBox"] = _ae3289_c5d5daud;
  if _ae3289_c5d5daud["Text"] ~= "" then
    state["lastNonBlankText"] = _ae3289_c5d5daud["Text"]
  end;
  state["boxTextConn"] = ((_ae3289_c5d5daud):GetPropertyChangedSignal("Text")):Connect(function()
    if _ae3289_c5d5daud["Text"] ~= "" then
      state["lastNonBlankText"] = _ae3289_c5d5daud["Text"]
    end
  end);
  state["boxAncestryConn"] = (_ae3289_c5d5daud["AncestryChanged"]):Connect(function(_ae3289_c5d5daue, _ae3289_c5d5dauf)
    if not _ae3289_c5d5dauf then
      _ae3289_c5d5daub()
    end
  end)
end;
_ae3289_c5d5da1h = function()
  state["pendingToken"] = state["pendingToken"] + 1;
  state["pendingText"], state["pendingBox"], state["pendingUntil"] = nil, nil, 0
end;
_ae3289_c5d5da1g = function(_ae3289_c5d5daug, _ae3289_c5d5dauh, _ae3289_c5d5daui)
  if not settings["retypeInvalid"] or not _ae3289_c5d5dauh or _ae3289_c5d5dauh == "" then
    return
  end;
  if not _ae3289_c5d5daui and state["pendingText"] and os["clock"]() <= state["pendingUntil"] then
    return
  end;
  state["pendingToken"] = state["pendingToken"] + 1;
  local _ae3289_c5d5dauj = state["pendingToken"];
  state["pendingText"], state["pendingBox"] = _ae3289_c5d5dauh, _ae3289_c5d5daug;
  state["pendingUntil"] = os["clock"]() + 8;
  task["delay"](8, function()
    if _ae3289_c5d5dauj == state["pendingToken"] then
      _ae3289_c5d5da1h()
    end
  end)
end;
local function _ae3289_c5d5dauk(_ae3289_c5d5daul, _ae3289_c5d5daum)
  if not settings["retypeInvalid"] or not _ae3289_c5d5daum or _ae3289_c5d5daum == "" then
    return false
  end;
  (RunService["Heartbeat"]):Wait();
  local _ae3289_c5d5daun = _ae3289_c5d5da23() or _ae3289_c5d5daul;
  if not _ae3289_c5d5daun or not _ae3289_c5d5da22(_ae3289_c5d5daun) then
    return false
  end;
  local _ae3289_c5d5dauo = pcall(function()
    _ae3289_c5d5daun["Text"] = _ae3289_c5d5daum
  end);
  if _ae3289_c5d5dauo then
    state["lastBox"] = _ae3289_c5d5daun;
    _ae3289_c5d5dauc(_ae3289_c5d5daun)
  end;
  return _ae3289_c5d5dauo
end;
_ae3289_c5d5da1i = function(_ae3289_c5d5daup, _ae3289_c5d5dauq)
  if not _ae3289_c5d5daqh["waiting"] and not(settings["retypeInvalid"] and state["pendingText"]) then
    return
  end;
  if _ae3289_c5d5dauq and ownGui and(_ae3289_c5d5dauq):IsDescendantOf(ownGui) then
    return
  end;
  _ae3289_c5d5dat2(_ae3289_c5d5daup);
  if not settings["retypeInvalid"] or not state["pendingText"] then
    return
  end;
  if os["clock"]() > state["pendingUntil"] then
    _ae3289_c5d5da1h();
    return
  end;
  if _ae3289_c5d5daqn(_ae3289_c5d5daup) ~= "bad" then
    return
  end;
  local _ae3289_c5d5daur, _ae3289_c5d5daus = state["pendingText"], state["pendingBox"];
  local _ae3289_c5d5daut = _ae3289_c5d5dauk(_ae3289_c5d5daus, _ae3289_c5d5daur);
  _ae3289_c5d5da1h();
  if _ae3289_c5d5daut then
    _ae3289_c5d5da1a("invalid, retyped: " .. _ae3289_c5d5da2e(_ae3289_c5d5daur), colors["warn"])
  end
end;
local function _ae3289_c5d5dauu(_ae3289_c5d5dauv, _ae3289_c5d5dauw)
  if not _ae3289_c5d5dauv or _ae3289_c5d5dauv == "" or not _ae3289_c5d5dauw or _ae3289_c5d5dauw == "" then
    return
  end;
  local _ae3289_c5d5daux = _ae3289_c5d5da1n(_ae3289_c5d5dauv);
  if _ae3289_c5d5da4p[_ae3289_c5d5daux] == _ae3289_c5d5dauw then
    return
  end;
  _ae3289_c5d5da4p[_ae3289_c5d5daux] = _ae3289_c5d5dauw;
  _ae3289_c5d5da4r();
  contextStore["confirmed"][#contextStore["confirmed"] + 1] = {["q"] = (_ae3289_c5d5dauv):sub(1, 120), ["code"] = _ae3289_c5d5dauw};
  while #contextStore["confirmed"] > 15
  do
    table["remove"](contextStore["confirmed"], 1)
  end;
  _ae3289_c5d5dama()
end;
local _ae3289_c5d5dauy, _ae3289_c5d5dauz = 0, false;
local function _ae3289_c5d5dav0()
  pcall(function()
    local _ae3289_c5d5dav1 = _ae3289_c5d5da23();
    if _ae3289_c5d5dav1 then
      _ae3289_c5d5dav1["Text"] = table["concat"](state["capturedParts"])
    end
  end)
end;
local function _ae3289_c5d5dav2()
  if _ae3289_c5d5dauz then
    return
  end;
  _ae3289_c5d5dauz = true;
  task["spawn"](function()
    local _ae3289_c5d5davb, _ae3289_c5d5davc = pcall(function()
      while state["fragDirty"] and state["alive"]
      do
        state["fragDirty"] = false;
        local _ae3289_c5d5dav3 = state["capturedParts"];
        local _ae3289_c5d5dav4 = table["concat"](_ae3289_c5d5dav3);
        local _ae3289_c5d5dav5 = #_ae3289_c5d5dav3;
        if _ae3289_c5d5dav4 == "" then
          break
        end;
        if _ae3289_c5d5da20 then
          _ae3289_c5d5da20["verdict"]("sent")
        end;
        state["redeemCtx"] = {["kind"] = "code"};
        _ae3289_c5d5da1g(_ae3289_c5d5da23(), _ae3289_c5d5dav4, true);
        local _ae3289_c5d5dav6, _ae3289_c5d5dav7, _ae3289_c5d5dav8 = _ae3289_c5d5datk(_ae3289_c5d5dav4, false, 1.3, _ae3289_c5d5dav5 .. (_ae3289_c5d5dav5 == 1 and " part" or " parts"),
          state["lastPartAt"]);
        if state["capturedParts"] ~= _ae3289_c5d5dav3 then
          break
        end;
        if _ae3289_c5d5dav6 == "ok" or _ae3289_c5d5dav6 == "used" then
          _ae3289_c5d5da1a((_ae3289_c5d5dav6 == "ok" and "redeemed: " or "valid (already used): ") .. _ae3289_c5d5da2e(_ae3289_c5d5dav4), colors["ok"]);
          if _ae3289_c5d5da20 then
            _ae3289_c5d5da20["verdict"](_ae3289_c5d5dav6)
          end;
          state["solvedCount"] = state["solvedCount"] + 1;
          _ae3289_c5d5da1j();
          _ae3289_c5d5da1d();
          break
        elseif(_ae3289_c5d5dav6 == "bad" or _ae3289_c5d5dav7) and(state["failedTries"] or 0) >= 1 then
          _ae3289_c5d5da1a((_ae3289_c5d5dav6 == "bad" and "invalid" or "no reply") .. " again at " .. _ae3289_c5d5dav5 .. " parts: " .. _ae3289_c5d5da2e(_ae3289_c5d5dav4) .. " -> stopped",
            colors["err"]);
          _ae3289_c5d5da1d();
          state["halted"] = true;
          if _ae3289_c5d5da20 then
            _ae3289_c5d5da20["verdict"]("bad");
            _ae3289_c5d5da20["toast"]("invalid at " .. _ae3289_c5d5dav5 .. " parts -> stopped", _ae3289_c5d5da1r["err"])
          end;
          break
        elseif _ae3289_c5d5dav6 == "bad" or _ae3289_c5d5dav7 then
          state["failedTries"] = 1;
          local _ae3289_c5d5dav9 = _ae3289_c5d5dav5 + 1;
          state["partTarget"] = math["max"](state["partTarget"] or settings["submitAfter"], _ae3289_c5d5dav9);
          _ae3289_c5d5da1a((_ae3289_c5d5dav6 == "bad" and "invalid at " or "no reply at ") .. _ae3289_c5d5dav5 .. (_ae3289_c5d5dav5 == 1 and " part" or " parts") .. ": " .. _ae3289_c5d5da2e(_ae3289_c5d5dav4) .. " -> waiting for part " .. _ae3289_c5d5dav9,
            _ae3289_c5d5dav6 == "bad" and colors["warn"] or colors["dim"]);
          if _ae3289_c5d5da20 then
            _ae3289_c5d5da20["verdict"](_ae3289_c5d5dav6 == "bad" and "bad" or "wait");
            _ae3289_c5d5da20["capture"](state["capturedParts"], state["partTarget"] or settings["submitAfter"]);
            _ae3289_c5d5da20["toast"]((_ae3289_c5d5dav6 == "bad" and "invalid" or "no reply") .. " at " .. _ae3289_c5d5dav5 .. " parts -> waiting for part " .. _ae3289_c5d5dav9, _ae3289_c5d5dav6 == "bad" and _ae3289_c5d5da1r["err"] or _ae3289_c5d5da1r["warn"])
          end;
          if #state["capturedParts"] > _ae3289_c5d5dav5 then
            state["fragDirty"] = true
          else
            _ae3289_c5d5dav0()
          end
        else
          local _ae3289_c5d5dava = _ae3289_c5d5dauk(_ae3289_c5d5da23(), _ae3289_c5d5dav4);
          _ae3289_c5d5da1h();
          _ae3289_c5d5da1a(_ae3289_c5d5dava and("retyped: " .. _ae3289_c5d5da2e(_ae3289_c5d5dav4)) or("failed: " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5dav8))), _ae3289_c5d5dava and colors["warn"] or colors["err"]);
          if _ae3289_c5d5da20 then
            _ae3289_c5d5da20["verdict"](_ae3289_c5d5dava and "wait" or "fail")
          end
        end
      end
    end);
    if not _ae3289_c5d5davb then
      _ae3289_c5d5da18("<font color=\"" .. colors["err"] .. "\">submit error: " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5davc)) .. "</font>")
    end;
    _ae3289_c5d5dauz = false;
    if state["fragDirty"] and state["alive"] then
      _ae3289_c5d5dav2()
    end
  end)
end;
_ae3289_c5d5da1c = function(_ae3289_c5d5davd)
  if not _ae3289_c5d5davd or _ae3289_c5d5davd == "" then
    return
  end;
  if state["lastWatchedBox"] and not _ae3289_c5d5da22(state["lastWatchedBox"]) then
    _ae3289_c5d5daub()
  end;
  if state["halted"] then
    if os["clock"]() - _ae3289_c5d5dauy < 10 then
      _ae3289_c5d5dauy = os["clock"]();
      _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">ignored part " .. _ae3289_c5d5da2e(_ae3289_c5d5davd) .. " (code stopped)</font>");
      return
    end;
    state["halted"] = false;
    _ae3289_c5d5da1d()
  end;
  if os["clock"]() - _ae3289_c5d5dauy > 45 then
    _ae3289_c5d5da1d()
  end;
  _ae3289_c5d5dauy = os["clock"]();
  state["lastPartAt"] = _ae3289_c5d5dauy;
  local _ae3289_c5d5dave = _ae3289_c5d5da23();
  state["capturedParts"][#state["capturedParts"] + 1] = _ae3289_c5d5davd;
  local _ae3289_c5d5davf = table["concat"](state["capturedParts"]);
  local _ae3289_c5d5davg = #state["capturedParts"];
  local _ae3289_c5d5davh = state["partTarget"] or settings["submitAfter"];
  if _ae3289_c5d5dave then
    state["lastBox"] = _ae3289_c5d5dave;
    _ae3289_c5d5dauc(_ae3289_c5d5dave);
    local _ae3289_c5d5davi = (UserInputService):GetFocusedTextBox() == _ae3289_c5d5dave;
    pcall(function()
      _ae3289_c5d5dave["Text"] = _ae3289_c5d5davf
    end);
    if _ae3289_c5d5davi then
      pcall(function()
        local _ae3289_c5d5davj = #_ae3289_c5d5davf + 1;
        _ae3289_c5d5dave["CursorPosition"] = _ae3289_c5d5davj;
        _ae3289_c5d5dave["SelectionStart"] = _ae3289_c5d5davj
      end)
    end
  end;
  _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">code part " .. _ae3289_c5d5davg .. "/" .. _ae3289_c5d5davh .. ": </font><font color=\"" .. colors["ok"] .. "\">" .. _ae3289_c5d5da2e(_ae3289_c5d5davf) .. "</font>");
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["capture"](state["capturedParts"], _ae3289_c5d5davh)
  end;
  if not settings["autoSubmit"] then
    return
  end;
  if _ae3289_c5d5davg < _ae3289_c5d5davh then
    if _ae3289_c5d5da20 then
      _ae3289_c5d5da20["verdict"]("wait")
    end;
    return
  end;
  state["fragDirty"] = true;
  _ae3289_c5d5dav2()
end;
local _ae3289_c5d5davk = {};
local function _ae3289_c5d5davl(_ae3289_c5d5davm, _ae3289_c5d5davn)
  _ae3289_c5d5da18("<font color=\"" .. _ae3289_c5d5davm .. "\">" .. _ae3289_c5d5davn .. "</font>")
end;
local _ae3289_c5d5davo = {};
local function _ae3289_c5d5davp(_ae3289_c5d5davq, _ae3289_c5d5davr)
  if settings["answerMode"] == "db" and not _ae3289_c5d5davr then
    return nil
  end;
  local _ae3289_c5d5davs = _ae3289_c5d5da1n(_ae3289_c5d5davq);
  local _ae3289_c5d5davt = _ae3289_c5d5davo[_ae3289_c5d5davs];
  if _ae3289_c5d5davt and(not _ae3289_c5d5davt["done"] or(_ae3289_c5d5davt["r"] and os["clock"]() - _ae3289_c5d5davt["at"] < 30)) then
    return _ae3289_c5d5davt
  end;
  for _ae3289_c5d5davu, _ae3289_c5d5davv in pairs(_ae3289_c5d5davo)
  do
    if os["clock"]() - _ae3289_c5d5davv["at"] > 60 then
      _ae3289_c5d5davo[_ae3289_c5d5davu] = nil
    end
  end;
  _ae3289_c5d5davt = {["at"] = os["clock"](), ["done"] = false};
  _ae3289_c5d5davo[_ae3289_c5d5davs] = _ae3289_c5d5davt;
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["verdict"]("think")
  end;
  task["spawn"](function()
    local _ae3289_c5d5davw, _ae3289_c5d5davx, _ae3289_c5d5davy = pcall(_ae3289_c5d5daof["ask"], _ae3289_c5d5davq);
    if _ae3289_c5d5davw then
      _ae3289_c5d5davt["r"], _ae3289_c5d5davt["err"] = _ae3289_c5d5davx, _ae3289_c5d5davy
    else
      _ae3289_c5d5davt["err"] = tostring(_ae3289_c5d5davx)
    end;
    _ae3289_c5d5davt["done"] = true
  end);
  return _ae3289_c5d5davt
end;
local function _ae3289_c5d5davz(_ae3289_c5d5daw0, _ae3289_c5d5daw1)
  state["askedCount"] = state["askedCount"] + 1;
  _ae3289_c5d5da1j();
  local _ae3289_c5d5daw2 = _ae3289_c5d5davp(_ae3289_c5d5daw0, _ae3289_c5d5daw1);
  local _ae3289_c5d5daw3 = _ae3289_c5d5da1n(_ae3289_c5d5daw0);
  state["redeemCtx"] = {["kind"] = "riddle", ["riddle"] = (_ae3289_c5d5daw0):sub(1, 300)};
  local _ae3289_c5d5daw4 = {["solved"] = false, ["at"] = os["clock"](), ["tried"] = {}, ["attempts"] = 0};
  _ae3289_c5d5davk[_ae3289_c5d5daw3] = _ae3289_c5d5daw4;
  if #state["capturedParts"] > 0 then
    _ae3289_c5d5da1d()
  end;
  _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">riddle: </font>" .. "<font color=\"" .. colors["white"] .. "\">" .. _ae3289_c5d5da2e((_ae3289_c5d5daw0):sub(1, 120)) .. "</font>");
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["riddle"](_ae3289_c5d5daw0, "solving...", colors["acc"])
  end;
  local _ae3289_c5d5daw5 = 10;
  local function _ae3289_c5d5daw6(_ae3289_c5d5daw7, _ae3289_c5d5daw8, _ae3289_c5d5daw9)
    _ae3289_c5d5daw7 = _ae3289_c5d5da2c(_ae3289_c5d5daw7);
    if _ae3289_c5d5daw7 == "" or(_ae3289_c5d5daw4["solved"] and not _ae3289_c5d5daw9) or _ae3289_c5d5daw4["tried"][_ae3289_c5d5daw7] or _ae3289_c5d5daw4["attempts"] >= _ae3289_c5d5daw5 then
      return nil
    end;
    _ae3289_c5d5daw4["tried"][_ae3289_c5d5daw7] = true;
    _ae3289_c5d5daw4["attempts"] = _ae3289_c5d5daw4["attempts"] + 1;
    if not settings["autoSubmit"] and not _ae3289_c5d5daw1 then
      _ae3289_c5d5davl(colors["dim"], "  " .. _ae3289_c5d5daw8 .. ": " .. _ae3289_c5d5daw7 .. " (auto submit off)");
      return nil
    end;
    if _ae3289_c5d5da20 then
      _ae3289_c5d5da20["capture"]({_ae3289_c5d5daw7}, 1)
    end;
    local _ae3289_c5d5dawa, _ae3289_c5d5dawb, _ae3289_c5d5dawc = _ae3289_c5d5datk(_ae3289_c5d5daw7, true, 1.0, _ae3289_c5d5daw8, _ae3289_c5d5daw4["at"]);
    local _ae3289_c5d5dawd = (_ae3289_c5d5dawa == "ok" or _ae3289_c5d5dawa == "used") and colors["ok"] or(_ae3289_c5d5dawa == "bad" and colors["err"]) or(_ae3289_c5d5dawb and colors["white"] or colors["err"]);
    _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">  " .. _ae3289_c5d5daw8 .. ": </font><font color=\"" .. _ae3289_c5d5dawd .. "\">" .. _ae3289_c5d5daw7 .. "</font><font color=\"" .. colors["dim"] .. "\"> " .. (_ae3289_c5d5dawa or(_ae3289_c5d5dawb and "sent" or tostring(_ae3289_c5d5dawc))) .. "</font>");
    if _ae3289_c5d5dawa == "ok" or _ae3289_c5d5dawa == "used" then
      _ae3289_c5d5daw4["solved"] = true;
      state["solvedCount"] = state["solvedCount"] + 1;
      _ae3289_c5d5da1j();
      _ae3289_c5d5dauu(_ae3289_c5d5daw0, _ae3289_c5d5daw7);
      if _ae3289_c5d5da20 then
        _ae3289_c5d5da20["verdict"](_ae3289_c5d5dawa);
        _ae3289_c5d5da20["riddle"](_ae3289_c5d5daw0, "solved: " .. _ae3289_c5d5daw7 .. " (" .. _ae3289_c5d5daw8 .. ")", colors["ok"])
      end
    elseif _ae3289_c5d5da20 then
      _ae3289_c5d5da20["verdict"](_ae3289_c5d5dawa == "bad" and "bad" or(_ae3289_c5d5dawb and "wait" or "fail"))
    end;
    return _ae3289_c5d5dawa
  end;
  local function _ae3289_c5d5dawe(_ae3289_c5d5dawf, _ae3289_c5d5dawg)
    if not settings["tryVariants"] or _ae3289_c5d5daw4["solved"] or not _ae3289_c5d5dawf or _ae3289_c5d5dawf == "" then
      return
    end;
    for _ae3289_c5d5dawh, _ae3289_c5d5dawi in ipairs(_ae3289_c5d5dau3(_ae3289_c5d5dawf))
    do
      if _ae3289_c5d5daw4["solved"] then
        break
      end;
      if _ae3289_c5d5daw6(_ae3289_c5d5dawi, _ae3289_c5d5dawg) == nil and not settings["autoSubmit"] then
        break
      end
    end
  end;
  local _ae3289_c5d5dawj = _ae3289_c5d5da1q(_ae3289_c5d5daw0);
  if _ae3289_c5d5dawj then
    _ae3289_c5d5daw6(_ae3289_c5d5dawj, "learned")
  end;
  local _ae3289_c5d5dawk, _ae3289_c5d5dawl;
  if not _ae3289_c5d5daw4["solved"] and settings["answerMode"] ~= "ai" then
    local _ae3289_c5d5dawm, _ae3289_c5d5dawn, _ae3289_c5d5dawo = _ae3289_c5d5da1o(_ae3289_c5d5daw0);
    if _ae3289_c5d5dawn then
      for _ae3289_c5d5dawp, _ae3289_c5d5dawq in ipairs(_ae3289_c5d5dawn)
      do
        _ae3289_c5d5davl((_ae3289_c5d5dawq):sub(-1) == "?" and colors["err"] or colors["dim"], "  " .. _ae3289_c5d5da2e(_ae3289_c5d5dawq))
      end
    end;
    _ae3289_c5d5dawk, _ae3289_c5d5dawl = _ae3289_c5d5dawm, _ae3289_c5d5dawo;
    if _ae3289_c5d5dawm and(_ae3289_c5d5dawo == 0 or settings["answerMode"] == "db") then
      _ae3289_c5d5daw6(_ae3289_c5d5dawm, _ae3289_c5d5dawo == 0 and "local db" or "local db (partial)")
    end
  end;
  if(not _ae3289_c5d5daw4["solved"] and settings["answerMode"] ~= "db") or _ae3289_c5d5daw1 then
    _ae3289_c5d5daw2 = _ae3289_c5d5daw2 or _ae3289_c5d5davp(_ae3289_c5d5daw0, _ae3289_c5d5daw1);
    local _ae3289_c5d5dawr = os["clock"]() + aiConfig["timeout"] + 3;
    while _ae3289_c5d5daw2 and not _ae3289_c5d5daw2["done"] and state["alive"] and(_ae3289_c5d5daw1 or not _ae3289_c5d5daw4["solved"]) and os["clock"]() < _ae3289_c5d5dawr
    do
      task["wait"]()
    end;
    local _ae3289_c5d5daws, _ae3289_c5d5dawt = _ae3289_c5d5daw2 and _ae3289_c5d5daw2["r"], _ae3289_c5d5daw2 and(_ae3289_c5d5daw2["err"] or(not _ae3289_c5d5daw2["done"] and "timeout")) or "ai off";
    if _ae3289_c5d5daw2 and not _ae3289_c5d5daws then
      _ae3289_c5d5davo[_ae3289_c5d5daw3] = nil
    end;
    if not _ae3289_c5d5daws then
      _ae3289_c5d5davl(colors["err"], "  ai: " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5dawt)));
      if _ae3289_c5d5da20 then
        _ae3289_c5d5da20["verdict"]("fail");
        _ae3289_c5d5da20["aiNote"]("model " .. aiConfig["model"] .. "  |  last error: " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5dawt)));
        if _ae3289_c5d5daw1 then
          _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["err"] .. "\">AI FAILED</font>  " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5dawt)), _ae3289_c5d5da1r["err"])
        end
      end
    elseif _ae3289_c5d5daw1 and _ae3289_c5d5daw4["solved"] then
      if _ae3289_c5d5da20 then
        _ae3289_c5d5da20["ai"](_ae3289_c5d5daws["ms"], _ae3289_c5d5daws["model"], _ae3289_c5d5daws["lane"]);
        _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["acc"] .. "\">AI</font>  " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5daws["main"])) .. "<font color=\"" .. colors["dim"] .. "\">  " .. _ae3289_c5d5daws["ms"] .. "ms</font>",
          _ae3289_c5d5da1r["accent"])
      end;
      _ae3289_c5d5davl(colors["dim"], "  ai " .. _ae3289_c5d5daws["model"] .. " " .. tostring(_ae3289_c5d5daws["ms"]) .. "ms -> " .. _ae3289_c5d5daws["mode"] .. ": " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5daws["main"])));
      local _ae3289_c5d5dawu = _ae3289_c5d5daws["mode"] == "CODE" and _ae3289_c5d5daws["main"] or _ae3289_c5d5da2c(_ae3289_c5d5daws["main"]);
      if _ae3289_c5d5daw4["tried"][_ae3289_c5d5dawu] then
        _ae3289_c5d5davl(colors["ok"], "  ai agrees with the code that already worked")
      else
        _ae3289_c5d5daw6(_ae3289_c5d5dawu, "ai (test)", true)
      end
    elseif not _ae3289_c5d5daw4["solved"] then
      if _ae3289_c5d5da20 then
        _ae3289_c5d5da20["ai"](_ae3289_c5d5daws["ms"], _ae3289_c5d5daws["model"], _ae3289_c5d5daws["lane"]);
        if _ae3289_c5d5daw1 then
          _ae3289_c5d5da20["toast"]("<font color=\"" .. colors["acc"] .. "\">AI</font>  " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5daws["main"])) .. "<font color=\"" .. colors["dim"] .. "\">  " .. _ae3289_c5d5daws["ms"] .. "ms</font>",
            _ae3289_c5d5da1r["accent"])
        end
      end;
      _ae3289_c5d5davl(colors["dim"], "  ai " .. _ae3289_c5d5daws["model"] .. " " .. tostring(_ae3289_c5d5daws["ms"]) .. "ms -> " .. _ae3289_c5d5daws["mode"] .. ": " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5daws["main"])) .. (_ae3289_c5d5daws["alt"] and(" || ALT: " .. _ae3289_c5d5da2e(_ae3289_c5d5daws["alt"])) or ""));
      local _ae3289_c5d5dawv = _ae3289_c5d5daws["mode"] == "CODE";
      local _ae3289_c5d5daww = _ae3289_c5d5dawv and _ae3289_c5d5daws["main"] or _ae3289_c5d5da2c(_ae3289_c5d5daws["main"]);
      local _ae3289_c5d5dawx = _ae3289_c5d5daws["alt"] and(_ae3289_c5d5dawv and _ae3289_c5d5daws["alt"] or _ae3289_c5d5da2c(_ae3289_c5d5daws["alt"])) or nil;
      _ae3289_c5d5daw6(_ae3289_c5d5daww, "ai");
      if settings["tryVariants"] and not _ae3289_c5d5daw4["solved"] and _ae3289_c5d5dawx then
        _ae3289_c5d5daw6(_ae3289_c5d5dawx, "ai alt")
      end;
      if not _ae3289_c5d5daw4["solved"] and _ae3289_c5d5dawk and _ae3289_c5d5dawl and _ae3289_c5d5dawl > 0 then
        _ae3289_c5d5daw6(_ae3289_c5d5dawk, "local db (partial)")
      end;
      _ae3289_c5d5dawe(_ae3289_c5d5daww, "variant");
      _ae3289_c5d5dawe(_ae3289_c5d5dawx, "alt variant")
    end
  end;
  if not _ae3289_c5d5daw4["solved"] and _ae3289_c5d5dawk then
    _ae3289_c5d5daw6(_ae3289_c5d5dawk, _ae3289_c5d5dawl == 0 and "local db" or "local db (partial)");
    _ae3289_c5d5dawe(_ae3289_c5d5da2c(_ae3289_c5d5dawk), "local variant")
  end;
  if not _ae3289_c5d5daw4["solved"] and not next(_ae3289_c5d5daw4["tried"]) then
    _ae3289_c5d5davl(colors["err"], "  no answer")
  end;
  if _ae3289_c5d5da20 and not _ae3289_c5d5daw4["solved"] then
    _ae3289_c5d5da20["riddle"](_ae3289_c5d5daw0, next(_ae3289_c5d5daw4["tried"]) and("not solved - tried " .. _ae3289_c5d5daw4["attempts"] .. " codes") or "no answer", colors["err"])
  end
end;
local function _ae3289_c5d5dawy()
  if state["riddleBusy"] then
    return
  end;
  state["riddleBusy"] = true;
  task["spawn"](function()
    while #state["riddleQueue"] > 0 and state["alive"]
    do
      local _ae3289_c5d5dawz = table["remove"](state["riddleQueue"], 1);
      local _ae3289_c5d5dax0, _ae3289_c5d5dax1 = pcall(_ae3289_c5d5davz, _ae3289_c5d5dawz["q"], _ae3289_c5d5dawz["test"]);
      if not _ae3289_c5d5dax0 then
        _ae3289_c5d5davl(colors["err"], "riddle error: " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5dax1)))
      end
    end;
    state["riddleBusy"] = false
  end)
end;
local _ae3289_c5d5dax2 = {};
local function _ae3289_c5d5dax3(_ae3289_c5d5dax4, _ae3289_c5d5dax5, _ae3289_c5d5dax6)
  local _ae3289_c5d5dax7 = _ae3289_c5d5da1n(_ae3289_c5d5dax4);
  local _ae3289_c5d5dax8 = _ae3289_c5d5dax2[_ae3289_c5d5dax7];
  if not _ae3289_c5d5dax5 and _ae3289_c5d5dax8 and os["clock"]() - _ae3289_c5d5dax8 < 20 then
    return
  end;
  _ae3289_c5d5dax2[_ae3289_c5d5dax7] = os["clock"]();
  if #state["riddleQueue"] > 6 then
    return
  end;
  _ae3289_c5d5davp(_ae3289_c5d5dax4, _ae3289_c5d5dax6);
  state["riddleQueue"][#state["riddleQueue"] + 1] = {["q"] = _ae3289_c5d5dax4, ["test"] = _ae3289_c5d5dax6};
  _ae3289_c5d5dawy()
end;
local function _ae3289_c5d5dax9()
  local _ae3289_c5d5daxa = _ae3289_c5d5da26(_ae3289_c5d5da1s["Text"]);
  if _ae3289_c5d5daxa == "" then
    _ae3289_c5d5da1a("type a riddle first", colors["warn"]);
    return
  end;
  _ae3289_c5d5da1s["Text"] = "";
  _ae3289_c5d5dax2[_ae3289_c5d5da1n(_ae3289_c5d5daxa)] = nil;
  _ae3289_c5d5davo[_ae3289_c5d5da1n(_ae3289_c5d5daxa)] = nil;
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["toast"]("testing: " .. _ae3289_c5d5da2e((_ae3289_c5d5daxa):sub(1, 40)), _ae3289_c5d5da1r["accent"])
  end;
  _ae3289_c5d5dax3(_ae3289_c5d5daxa, true, true)
end;
_ae3289_c5d5da1w(_ae3289_c5d5da1t, _ae3289_c5d5dax9);
(_ae3289_c5d5da1s["FocusLost"]):Connect(function(_ae3289_c5d5daxb)
  if _ae3289_c5d5daxb then
    _ae3289_c5d5dax9()
  end
end);
local function _ae3289_c5d5daxc(_ae3289_c5d5daxd)
  local _ae3289_c5d5daxe = {};
  for _ae3289_c5d5daxf in(_ae3289_c5d5daxd):gmatch("[%w_]+")
  do
    _ae3289_c5d5daxe[#_ae3289_c5d5daxe + 1] = _ae3289_c5d5daxf
  end;
  return _ae3289_c5d5daxe
end;
local _ae3289_c5d5daxg = {["riddle"] = {"%f[%a]use%s+the%s+riddles?%f[%A]", "%f[%a]use%s+riddles?%f[%A]", "%f[%a]riddles?%s+mode%f[%A]", "%f[%a]riddles?%s+round%f[%A]", "%f[%a]riddles?%s+time%f[%A]",
  "%f[%a]next%s+riddle%f[%A]", "%f[%a]new%s+riddle%f[%A]", "%f[%a]here%s*i?s%s+an?%s+riddle%f[%A]", "%f[%a]here%s*i?s%s+the%s+riddle%f[%A]", "%f[%a]the%s+riddle%s+is%f[%A]", "%f[%a]riddle%s+is%f[%A]",
  "%f[%a]riddles%s+are%f[%A]", "%f[%a]riddle%s*:", "%f[%a]solve%s+this%f[%A]", "%f[%a]solve%s+the%s+riddle%f[%A]", "%f[%a]riddles?%s+start", "%f[%a]riddles?%s+now%f[%A]", "%f[%a]answer%s+the%s+riddle%f[%A]",
  "%f[%a]answer%s+this%f[%A]", "%f[%a]riddles?%s+on%f[%A]", "%f[%a]switch%s+to%s+riddles?%f[%A]", "^%W*riddles?%W*$",}, ["code"] = {"%f[%a]use%s+the%s+codes?%f[%A]", "%f[%a]use%s+codes?%f[%A]",
  "%f[%a]codes?%s+mode%f[%A]", "%f[%a]codes?%s+round%f[%A]", "%f[%a]codes?%s+time%f[%A]", "%f[%a]next%s+code%f[%A]", "%f[%a]new%s+code%f[%A]", "%f[%a]the%s+code%s+is%f[%A]", "%f[%a]code%s+is%f[%A]",
  "%f[%a]codes%s+are%f[%A]", "%f[%a]code%s*:", "%f[%a]type%s+the%s+code%f[%A]", "%f[%a]code%s+parts?%f[%A]", "%f[%a]type%s+codes?%f[%A]", "%f[%a]enter%s+the%s+codes?%f[%A]", "%f[%a]enter%s+codes?%f[%A]",
  "%f[%a]redeem%s+the%s+codes?%f[%A]", "%f[%a]redeem%s+codes?%f[%A]", "%f[%a]codes?%s+drop", "%f[%a]codes?%s+start", "%f[%a]codes?%s+now%f[%A]", "%f[%a]codes?%s+on%f[%A]", "%f[%a]switch%s+to%s+codes?%f[%A]",
  "^%W*codes?%W*$",},};
local _ae3289_c5d5daxh = {["now"] = true, ["guys"] = true, ["everyone"] = true, ["yall"] = true, ["pls"] = true, ["please"] = true, ["ok"] = true, ["okay"] = true, ["time"] = true, ["mode"] = true,
  ["round"] = true, ["again"] = true, ["part"] = true, ["parts"] = true, ["is"] = true, ["are"] = true, ["for"] = true, ["next"] = true, ["here"] = true,};
local function _ae3289_c5d5daxi(_ae3289_c5d5daxj)
  local _ae3289_c5d5daxk = (_ae3289_c5d5daxj):lower();
  local _ae3289_c5d5daxl, _ae3289_c5d5daxm, _ae3289_c5d5daxn;
  for _ae3289_c5d5daxo, _ae3289_c5d5daxp in pairs(_ae3289_c5d5daxg)
  do
    for _ae3289_c5d5daxq, _ae3289_c5d5daxr in ipairs(_ae3289_c5d5daxp)
    do
      local _ae3289_c5d5daxs, _ae3289_c5d5daxt = (_ae3289_c5d5daxk):find(_ae3289_c5d5daxr);
      if _ae3289_c5d5daxs and(not _ae3289_c5d5daxn or _ae3289_c5d5daxs < _ae3289_c5d5daxn) then
        _ae3289_c5d5daxl, _ae3289_c5d5daxn, _ae3289_c5d5daxm = _ae3289_c5d5daxo, _ae3289_c5d5daxs, _ae3289_c5d5daxt
      end
    end
  end;
  if not _ae3289_c5d5daxl then
    return nil
  end;
  local _ae3289_c5d5daxu = (_ae3289_c5d5daxj):sub(_ae3289_c5d5daxm + 1);
  repeat
    local _ae3289_c5d5daxv = _ae3289_c5d5daxu;
    _ae3289_c5d5daxu = (_ae3289_c5d5daxu):gsub("^[%s:%-=>!%.,]+", "");
    local _ae3289_c5d5daxw = (_ae3289_c5d5daxu):match("^(%a+)");
    if _ae3289_c5d5daxw and _ae3289_c5d5daxh[(_ae3289_c5d5daxw):lower()] then
      _ae3289_c5d5daxu = (_ae3289_c5d5daxu):sub(#_ae3289_c5d5daxw + 1)
    end
  until _ae3289_c5d5daxu == _ae3289_c5d5daxv;
  _ae3289_c5d5daxu = _ae3289_c5d5da26(((_ae3289_c5d5daxu):gsub("[%s!%.]+$", "")));
  return _ae3289_c5d5daxl, _ae3289_c5d5daxu
end;
local function _ae3289_c5d5daxx()
  if settings["riddler"] and not settings["sniper"] then
    return "riddle"
  end;
  if settings["sniper"] and not settings["riddler"] then
    return "code"
  end;
  return nil
end;
local function _ae3289_c5d5daxy(_ae3289_c5d5daxz, _ae3289_c5d5day0)
  if not settings["autoSwitch"] then
    return
  end;
  local _ae3289_c5d5day1, _ae3289_c5d5day2 = _ae3289_c5d5daxz == "code", _ae3289_c5d5daxz == "riddle";
  if settings["sniper"] == _ae3289_c5d5day1 and settings["riddler"] == _ae3289_c5d5day2 then
    return
  end;
  settings["sniper"], settings["riddler"] = _ae3289_c5d5day1, _ae3289_c5d5day2;
  saveSettings();
  _ae3289_c5d5da1d();
  _ae3289_c5d5da18("<font color=\"" .. colors["acc"] .. "\">" .. (_ae3289_c5d5day1 and "CODE SNIPER on" or "RIDDLE SOLVER on") .. "</font><font color=\"" .. colors["dim"] .. "\"> (sammy: " .. _ae3289_c5d5da2e((tostring(_ae3289_c5d5day0)):sub(1,
    60)) .. ")</font>");
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["modes"]();
    _ae3289_c5d5da20["toast"](_ae3289_c5d5day1 and "USE CODE -> code sniper on" or "USE RIDDLE -> riddle solver on", _ae3289_c5d5da1r["accent"])
  end
end;
local function _ae3289_c5d5day3(_ae3289_c5d5day4, _ae3289_c5d5day5)
  for _ae3289_c5d5day6, _ae3289_c5d5day7 in ipairs(_ae3289_c5d5daxc(_ae3289_c5d5day4))
  do
    if _ae3289_c5d5day7 ~= "" and(_ae3289_c5d5day5 or not state["seen"][_ae3289_c5d5day7]) then
      state["seen"][_ae3289_c5d5day7] = true;
      task["delay"](1.25, function()
        state["seen"][_ae3289_c5d5day7] = nil
      end);
      _ae3289_c5d5da1c(_ae3289_c5d5day7)
    end
  end
end;
local function _ae3289_c5d5day8(_ae3289_c5d5day9, ...)
  local _ae3289_c5d5daya = {};
  for _ae3289_c5d5dayb = 1, select("#", ...)
  do
    local _ae3289_c5d5dayc = select(_ae3289_c5d5dayb, ...);
    if type(_ae3289_c5d5dayc) == "table" then
      _ae3289_c5d5dayc = _ae3289_c5d5dayc["Text"] or _ae3289_c5d5dayc["text"] or _ae3289_c5d5dayc["Message"] or _ae3289_c5d5dayc["message"]
    end;
    if type(_ae3289_c5d5dayc) == "string" then
      _ae3289_c5d5dayc = _ae3289_c5d5da26(_ae3289_c5d5da28(_ae3289_c5d5dayc));
      if _ae3289_c5d5dayc ~= "" then
        _ae3289_c5d5daya[#_ae3289_c5d5daya + 1] = _ae3289_c5d5dayc
      end
    end
  end;
  if #_ae3289_c5d5daya == 0 then
    return
  end;
  local _ae3289_c5d5dayd = _ae3289_c5d5daya[1];
  local _ae3289_c5d5daye, _ae3289_c5d5dayf;
  for _ae3289_c5d5dayg, _ae3289_c5d5dayh in ipairs(_ae3289_c5d5daya)
  do
    local _ae3289_c5d5dayi, _ae3289_c5d5dayj = _ae3289_c5d5daxi(_ae3289_c5d5dayh);
    if _ae3289_c5d5dayi then
      _ae3289_c5d5dayd, _ae3289_c5d5daye, _ae3289_c5d5dayf = _ae3289_c5d5dayh, _ae3289_c5d5dayi, _ae3289_c5d5dayj;
      break
    end
  end;
  if not _ae3289_c5d5daye and _ae3289_c5d5dat2(_ae3289_c5d5dayd) then
    return
  end;
  local _ae3289_c5d5dayk = _ae3289_c5d5dayd;
  if _ae3289_c5d5daye then
    _ae3289_c5d5dayk = _ae3289_c5d5dayf;
    if _ae3289_c5d5daye == "code" and(_ae3289_c5d5dayk):find("%s") and _ae3289_c5d5da1p(_ae3289_c5d5dayk) then
      _ae3289_c5d5daye = "riddle"
    end;
    _ae3289_c5d5daxy(_ae3289_c5d5daye, _ae3289_c5d5dayd);
    if _ae3289_c5d5dayk == "" then
      return
    end
  end;
  local _ae3289_c5d5dayl = _ae3289_c5d5daxx();
  if(_ae3289_c5d5dayk):find("%s") then
    _ae3289_c5d5damg(_ae3289_c5d5dayk, _ae3289_c5d5day9)
  end;
  if _ae3289_c5d5dayl == "riddle" or _ae3289_c5d5daye == "riddle" then
    if settings["riddler"] and(_ae3289_c5d5daye or _ae3289_c5d5day9 == "dev chat" or not(_ae3289_c5d5dayk):find("%s") or _ae3289_c5d5da1p(_ae3289_c5d5dayk)) then
      _ae3289_c5d5dax3(_ae3289_c5d5dayk)
    end;
    return
  end;
  if(_ae3289_c5d5dayk):find("%s") then
    if _ae3289_c5d5daye == "code" then
      if settings["sniper"] then
        _ae3289_c5d5day3(_ae3289_c5d5dayk)
      end
    elseif settings["riddler"] and _ae3289_c5d5da1p(_ae3289_c5d5dayk) then
      _ae3289_c5d5dax3(_ae3289_c5d5dayk)
    end;
    return
  end;
  if settings["sniper"] then
    _ae3289_c5d5day3(_ae3289_c5d5dayk)
  end
end;
local function _ae3289_c5d5daym(_ae3289_c5d5dayn)
  _ae3289_c5d5dayn = _ae3289_c5d5da2c(_ae3289_c5d5dayn);
  if _ae3289_c5d5dayn == "" then
    return
  end;
  _ae3289_c5d5da1d();
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["capture"]({_ae3289_c5d5dayn}, 1);
    _ae3289_c5d5da20["verdict"]("sent")
  end;
  state["redeemCtx"] = {["kind"] = "code"};
  local _ae3289_c5d5dayo, _ae3289_c5d5dayp, _ae3289_c5d5dayq = _ae3289_c5d5datk(_ae3289_c5d5dayn, true, 1.2, "test");
  local _ae3289_c5d5dayr = _ae3289_c5d5dayo == "ok" or _ae3289_c5d5dayo == "used";
  _ae3289_c5d5da18("<font color=\"" .. colors["dim"] .. "\">  full code: </font><font color=\"" .. (_ae3289_c5d5dayr and colors["ok"] or(_ae3289_c5d5dayo == "bad" and colors["err"] or colors["white"])) .. "\">" .. _ae3289_c5d5dayn .. "</font><font color=\"" .. colors["dim"] .. "\"> " .. (_ae3289_c5d5dayo or(_ae3289_c5d5dayp and "sent" or tostring(_ae3289_c5d5dayq))) .. "</font>");
  if _ae3289_c5d5da20 then
    _ae3289_c5d5da20["verdict"](_ae3289_c5d5dayr and _ae3289_c5d5dayo or(_ae3289_c5d5dayo == "bad" and "bad" or(_ae3289_c5d5dayp and "wait" or "fail")))
  end;
  if _ae3289_c5d5dayr then
    state["solvedCount"] = state["solvedCount"] + 1;
    _ae3289_c5d5da1j()
  end
end;
local function _ae3289_c5d5days()
  if not _ae3289_c5d5da1x then
    return
  end;
  local _ae3289_c5d5dayt = _ae3289_c5d5da26(_ae3289_c5d5da1x["Text"]);
  if _ae3289_c5d5dayt == "" then
    _ae3289_c5d5da1a("type an announcement first", colors["warn"]);
    return
  end;
  _ae3289_c5d5da1x["Text"] = "";
  local _ae3289_c5d5dayu = state["testAs"] or "auto";
  if _ae3289_c5d5da1z then
    pcall(_ae3289_c5d5da1z, "sammy", _ae3289_c5d5dayt)
  end;
  _ae3289_c5d5da18("<font color=\"" .. colors["acc"] .. "\">sammy</font><font color=\"" .. colors["dim"] .. "\"> announced" .. (_ae3289_c5d5dayu ~= "auto" and(" (test as " .. _ae3289_c5d5dayu .. ")") or "") .. ": </font><font color=\"" .. colors["white"] .. "\">" .. _ae3289_c5d5da2e(_ae3289_c5d5dayt) .. "</font>");
  task["spawn"](function()
    local _ae3289_c5d5dayv, _ae3289_c5d5dayw = pcall(function()
      if _ae3289_c5d5dayu == "part" then
        _ae3289_c5d5day3(_ae3289_c5d5dayt, true)
      elseif _ae3289_c5d5dayu == "full" then
        _ae3289_c5d5daym(_ae3289_c5d5dayt)
      elseif _ae3289_c5d5dayu == "riddle" then
        _ae3289_c5d5dax3(_ae3289_c5d5dayt, true)
      else
        if not(settings["sniper"] or settings["riddler"]) then
          _ae3289_c5d5da1a("code sniper + riddle solver are off: only keywords react", colors["warn"])
        end;
        _ae3289_c5d5day8("dev chat", _ae3289_c5d5dayt)
      end
    end);
    if not _ae3289_c5d5dayv then
      _ae3289_c5d5da18("<font color=\"" .. colors["err"] .. "\">test error: " .. _ae3289_c5d5da2e(tostring(_ae3289_c5d5dayw)) .. "</font>")
    end
  end)
end;
if _ae3289_c5d5da1y then
  _ae3289_c5d5da1w(_ae3289_c5d5da1y, _ae3289_c5d5days)
end;
if _ae3289_c5d5da1x then
  (_ae3289_c5d5da1x["FocusLost"]):Connect(function(_ae3289_c5d5dayx)
    if _ae3289_c5d5dayx then
      _ae3289_c5d5days()
    end
  end)
end;
local function _ae3289_c5d5dayy()
  if _G["PhiNotifyRemote"] then
    return _G["PhiNotifyRemote"]
  end;
  local function _ae3289_c5d5dayz(_ae3289_c5d5daz0)
    if debug and type(debug["info"]) == "function" then
      local _ae3289_c5d5daz1, _ae3289_c5d5daz2 = pcall(debug["info"], _ae3289_c5d5daz0, "s");
      if _ae3289_c5d5daz1 and type(_ae3289_c5d5daz2) == "string" and #_ae3289_c5d5daz2 > 0 then
        return _ae3289_c5d5daz2
      end
    end;
    if debug and type(debug["getinfo"]) == "function" then
      local _ae3289_c5d5daz3, _ae3289_c5d5daz4 = pcall(debug["getinfo"], _ae3289_c5d5daz0);
      if _ae3289_c5d5daz3 and type(_ae3289_c5d5daz4) == "table" then
        return tostring(_ae3289_c5d5daz4["short_src"] or _ae3289_c5d5daz4["source"] or "")
      end
    end;
    return ""
  end;
  local _ae3289_c5d5daz5 = debug and(debug["info"] or debug["getinfo"]);
  local _ae3289_c5d5daz6 = ReplicatedStorage and(ReplicatedStorage):FindFirstChild("Packages");
  local _ae3289_c5d5daz7 = _ae3289_c5d5daz6 and(_ae3289_c5d5daz6):FindFirstChild("Net");
  if _ae3289_c5d5daz7 and _ae3289_c5d5daz5 and _ae3289_c5d5dat then
    for _ae3289_c5d5daz8, _ae3289_c5d5daz9 in ipairs((_ae3289_c5d5daz7):GetDescendants())
    do
      if(_ae3289_c5d5daz9):IsA("RemoteEvent") then
        local _ae3289_c5d5daza, _ae3289_c5d5dazb = pcall(_ae3289_c5d5dat, _ae3289_c5d5daz9["OnClientEvent"]);
        if _ae3289_c5d5daza and type(_ae3289_c5d5dazb) == "table" then
          for _ae3289_c5d5dazc, _ae3289_c5d5dazd in ipairs(_ae3289_c5d5dazb)
          do
            local _ae3289_c5d5daze, _ae3289_c5d5dazf = pcall(function()
              return _ae3289_c5d5dazd["Function"]
            end);
            if _ae3289_c5d5daze and type(_ae3289_c5d5dazf) == "function" then
              if(_ae3289_c5d5dayz(_ae3289_c5d5dazf)):find("NotificationController", 1, true) then
                _G["PhiNotifyRemote"] = _ae3289_c5d5daz9;
                return _ae3289_c5d5daz9
              end
            end
          end
        end
      end
    end
  end;
  return nil
end;
task["spawn"](function()
  local _ae3289_c5d5dazg = _ae3289_c5d5dayy();
  if _ae3289_c5d5dazg and((_ae3289_c5d5dazg):IsA("RemoteEvent") or(_ae3289_c5d5dazg):IsA("UnreliableRemoteEvent")) then
    _ae3289_c5d5da24((_ae3289_c5d5dazg["OnClientEvent"]):Connect(function(...)
      pcall(_ae3289_c5d5day8, "announce", ...)
    end));
    _ae3289_c5d5davl(colors["dim"], "listener attached: " .. _ae3289_c5d5da2e(_ae3289_c5d5dazg["Name"]))
  else
    _ae3289_c5d5da1u["BackgroundColor3"] = _ae3289_c5d5da1r["err"];
    _ae3289_c5d5davl(colors["err"], "no notify remote, dev chat + test box still work")
  end
end);
local _ae3289_c5d5dazh = {["spydersammy"] = true, ["do_small"] = true};
local function _ae3289_c5d5dazi(_ae3289_c5d5dazj)
  return _ae3289_c5d5dazj and _ae3289_c5d5dazh[(tostring(_ae3289_c5d5dazj)):lower()] or false
end;
if TextChatService then
  pcall(function()
    _ae3289_c5d5da24((TextChatService["MessageReceived"]):Connect(function(_ae3289_c5d5dazk)
      local _ae3289_c5d5dazl = _ae3289_c5d5dazk and _ae3289_c5d5dazk["Text"];
      if type(_ae3289_c5d5dazl) ~= "string" or _ae3289_c5d5dazl == "" then
        return
      end;
      local _ae3289_c5d5dazm = _ae3289_c5d5dazk["TextSource"];
      if not _ae3289_c5d5dazm then
        local _ae3289_c5d5dazn = _ae3289_c5d5da28(_ae3289_c5d5dazl);
        _ae3289_c5d5damg(_ae3289_c5d5dazn, "system");
        if _ae3289_c5d5daxi(_ae3289_c5d5dazn) then
          pcall(_ae3289_c5d5day8, "system", _ae3289_c5d5dazn)
        end;
        return
      end;
      local _ae3289_c5d5dazo = (Players):GetPlayerByUserId(_ae3289_c5d5dazm["UserId"]);
      if _ae3289_c5d5dazo and _ae3289_c5d5dazi(_ae3289_c5d5dazo["Name"]) then
        pcall(_ae3289_c5d5day8, "dev chat", _ae3289_c5d5dazl)
      end
    end))
  end)
end;
local function _ae3289_c5d5dazp(_ae3289_c5d5dazq)
  if not _ae3289_c5d5dazi(_ae3289_c5d5dazq["Name"]) then
    return
  end;
  pcall(function()
    _ae3289_c5d5da24((_ae3289_c5d5dazq["Chatted"]):Connect(function(_ae3289_c5d5dazr)
      pcall(_ae3289_c5d5day8, "dev chat", _ae3289_c5d5dazr)
    end))
  end);
  _ae3289_c5d5damg(_ae3289_c5d5dazq["Name"] .. " is in this server", "system")
end;
for _ae3289_c5d5dazs, _ae3289_c5d5dazt in ipairs((Players):GetPlayers())
do
  _ae3289_c5d5dazp(_ae3289_c5d5dazt)
end;
_ae3289_c5d5da24((Players["PlayerAdded"]):Connect(_ae3289_c5d5dazp));
local function _ae3289_c5d5dazu(_ae3289_c5d5dazv)
  local _ae3289_c5d5dazw = (_ae3289_c5d5dazv):IsA("TextBox");
  if not(_ae3289_c5d5dazw or(_ae3289_c5d5dazv):IsA("TextLabel") or(_ae3289_c5d5dazv):IsA("TextButton")) then
    return
  end;
  if _ae3289_c5d5da21(_ae3289_c5d5dazv) then
    return
  end;
  local function _ae3289_c5d5dazx(_ae3289_c5d5dazy)
    _ae3289_c5d5dazy = tostring(_ae3289_c5d5dazy or "");
    if not _ae3289_c5d5dazw then
      pcall(_ae3289_c5d5damw["noteLabel"], _ae3289_c5d5dazv)
    end;
    if _ae3289_c5d5dazw and _ae3289_c5d5dazy == _ae3289_c5d5da2c(_ae3289_c5d5dazy) then
      return
    end;
    _ae3289_c5d5da1i(_ae3289_c5d5dazy, _ae3289_c5d5dazv)
  end;
  _ae3289_c5d5dazx(_ae3289_c5d5dazv["Text"]);
  _ae3289_c5d5da24(((_ae3289_c5d5dazv):GetPropertyChangedSignal("Text")):Connect(function()
    _ae3289_c5d5dazx(_ae3289_c5d5dazv["Text"])
  end));
  if _ae3289_c5d5dazw then
    _ae3289_c5d5da24(((_ae3289_c5d5dazv):GetPropertyChangedSignal("PlaceholderText")):Connect(function()
      _ae3289_c5d5dazx(_ae3289_c5d5dazv["PlaceholderText"])
    end))
  end
end;
for _ae3289_c5d5dazz, _ae3289_c5d5da100 in ipairs((PlayerGui):GetDescendants())
do
  pcall(_ae3289_c5d5dazu, _ae3289_c5d5da100)
end;
_ae3289_c5d5da24((PlayerGui["DescendantAdded"]):Connect(function(_ae3289_c5d5da101)
  pcall(_ae3289_c5d5dazu, _ae3289_c5d5da101)
end));
_ae3289_c5d5da24((UserInputService["TextBoxFocused"]):Connect(function(_ae3289_c5d5da102)
  if(_ae3289_c5d5da102):IsDescendantOf(ownGui) then
    return
  end;
  if _ae3289_c5d5da102 ~= _ae3289_c5d5da23() then
    return
  end;
  state["focused"], state["lastBox"] = _ae3289_c5d5da102, _ae3289_c5d5da102;
  _ae3289_c5d5dauc(_ae3289_c5d5da102)
end));
_ae3289_c5d5da24((UserInputService["TextBoxFocusReleased"]):Connect(function(_ae3289_c5d5da103)
  if(_ae3289_c5d5da103):IsDescendantOf(ownGui) then
    return
  end;
  local _ae3289_c5d5da104 = _ae3289_c5d5da23();
  if _ae3289_c5d5da103 ~= _ae3289_c5d5da104 and _ae3289_c5d5da103 ~= state["lastBox"] then
    return
  end;
  if settings["retypeInvalid"] then
    local _ae3289_c5d5da105 = _ae3289_c5d5da103["Text"] ~= "" and _ae3289_c5d5da103["Text"] or state["lastNonBlankText"];
    _ae3289_c5d5da1g(_ae3289_c5d5da103, _ae3289_c5d5da105, false)
  end;
  if state["focused"] == _ae3289_c5d5da103 then
    state["focused"] = nil
  end
end));
task["spawn"](function()
  _ae3289_c5d5davl(colors["dim"], "model " .. aiConfig["model"] .. " | answer mode: " .. settings["answerMode"] .. " | " .. #apiKeys["list"] .. " api keys");
  local _ae3289_c5d5da106 = _ae3289_c5d5da3o();
  _ae3289_c5d5davl(colors["dim"], "live: " .. _ae3289_c5d5da30()["clock"] .. (_ae3289_c5d5da106 and(" | " .. _ae3289_c5d5da2e(_ae3289_c5d5da106)) or "") .. " | " .. #contextStore["announcements"] .. " saved announcements")
end);
local function _ae3289_c5d5da107()
  state["alive"] = false;
  for _ae3289_c5d5da108, _ae3289_c5d5da109 in ipairs(state["connections"])
  do
    pcall(function()
      (_ae3289_c5d5da109):Disconnect()
    end)
  end;
  state["connections"] = {};
  if _ae3289_c5d5da1v then
    pcall(function()
      (_ae3289_c5d5da1v):Disconnect()
    end)
  end;
  _ae3289_c5d5daub();
  _ae3289_c5d5dam7();
  if ownGui then
    pcall(function()
      (ownGui):Destroy()
    end)
  end
end;
_ae3289_c5d5dar["Skyr0Stop"] = _ae3289_c5d5da107;
_ae3289_c5d5dar["StopAura"] = _ae3289_c5d5da107;
-- ===== Bootstrap complete =====
print("[skyr0.wtf] code redeemer v3 loaded");
loadTimer.done = true;
if game then
  pcall(function()
    print(string.format("[skyr0] loaded 100%% in %.2fs", loadTimer.c() - loadTimer.t))
  end)
end;