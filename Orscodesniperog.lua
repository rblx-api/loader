--[[
  OR'S SNIPER
  Compact B/W UI · Type Sniper includes full Riddle engine
  Config always centered · Menu button B/W · Background image
  Settings persist across rejoin / re-execute
]]

local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Lighting = cloneref(game:GetService("Lighting"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
local getupvalues_ = (debug and debug.getupvalues) or getupvalues
local getconns = getconnections or (debug and debug.getconnections)

do
	local env = getgenv and getgenv() or _G
	if env.StopOrsSniper then pcall(env.StopOrsSniper) end
	if env.StopKyronSniper then pcall(env.StopKyronSniper) end
end

--==============================================================
-- Colors (Black / White / Gray)
--==============================================================
local C = {
	bg = Color3.fromRGB(6, 6, 8),
	panel = Color3.fromRGB(14, 14, 18),
	card = Color3.fromRGB(24, 24, 30),
	hover = Color3.fromRGB(38, 38, 46),
	border = Color3.fromRGB(72, 72, 82),
	accent = Color3.fromRGB(235, 235, 240),
	text = Color3.fromRGB(248, 248, 252),
	muted = Color3.fromRGB(145, 145, 155),
	green = Color3.fromRGB(90, 210, 130),
	red = Color3.fromRGB(230, 80, 90),
	amber = Color3.fromRGB(230, 190, 80),
	off = Color3.fromRGB(42, 42, 50),
}

local FAST = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SMOOTH = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local POP = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local PULSE = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local BG_IMAGE = "rbxassetid://105543452376246"

--==============================================================
-- Config (persists)
--==============================================================
local CONFIG_FOLDER = "OrsSniper"
local CONFIG_PATH = "OrsSniper/settings.json"

local DEFAULT_CONFIG = {
	spamRedeem = true,
	spamCount = 20,
	twoWordCheck = false,
	waitInvalid = false,
	typeInstead = false,
	typingMode = "MAX",
	optimize = false,
	blockEvents = false,
	animations = true,
	menuKey = "RightShift",
	autoStartScan = false,
	holdOnWait = false,
	submitAfter = 3,
	riddlerAI = false,
	riddlerListen = false,
	riddlerAutoRedeem = false,
	panelLocked = true, -- true = cannot move panel
	menuSX = nil,
	menuSY = nil,
	menuOX = nil,
	menuOY = nil,
	panelSX = nil,
	panelSY = nil,
	panelOX = nil,
	panelOY = nil,
}

local MAX_RETRIES = 10
local TYPING_SPEEDS = { MAX = 0, Mid = 0.5, Slow = 1 }
local TYPING_OPTIONS = { "MAX", "Mid", "Slow" }

local config = table.clone(DEFAULT_CONFIG)

local function loadConfig()
	if not (isfile and readfile) then return end
	local ok, saved = pcall(function()
		if isfile(CONFIG_PATH) then
			return HttpService:JSONDecode(readfile(CONFIG_PATH))
		end
	end)
	if not ok or type(saved) ~= "table" then return end
	for key, default in pairs(DEFAULT_CONFIG) do
		local v = saved[key]
		if v ~= nil then
			-- accept matching types, and numbers for position fields even if default was nil
			if type(v) == type(default) or (default == nil and type(v) == "number") or (type(default) == "boolean" and type(v) == "boolean") then
				config[key] = v
			elseif type(default) == "number" and type(v) == "number" then
				config[key] = v
			elseif type(default) == "boolean" and (v == true or v == false) then
				config[key] = v == true
			end
		end
	end
	-- positions (always accept numbers if present)
	for _, k in ipairs({ "menuSX", "menuSY", "menuOX", "menuOY", "panelSX", "panelSY", "panelOX", "panelOY", "menuX", "menuY" }) do
		if type(saved[k]) == "number" then
			config[k] = saved[k]
		end
	end
	-- migrate old absolute menuX/menuY if new keys missing
	if config.menuOX == nil and type(saved.menuX) == "number" then
		config.menuSX, config.menuSY = 0, 0
		config.menuOX, config.menuOY = saved.menuX, saved.menuY
	end
end

local _lastSaveLog = 0
local function writeConfig()
	if not writefile then
		if ui and ui.log then ui.log("No writefile (executor)", "err") end
		return false
	end
	local ok = pcall(function()
		if makefolder then
			if not isfolder or not isfolder(CONFIG_FOLDER) then
				pcall(makefolder, CONFIG_FOLDER)
			end
		end
		writefile(CONFIG_PATH, HttpService:JSONEncode(config))
	end)
	if ui and ui.log then
		if ok then
			local now = os.clock()
			if now - _lastSaveLog > 1.5 then
				_lastSaveLog = now
				ui.log("Config saved", "ok")
			end
		else
			ui.log("Config save failed", "err")
		end
	end
	return ok
end

local saveToken = 0
local function saveConfig(immediate)
	if immediate then
		writeConfig()
		return
	end
	saveToken += 1
	local token = saveToken
	task.delay(0.35, function()
		if token == saveToken then writeConfig() end
	end)
end

loadConfig()
config.spamCount = math.clamp(math.floor(tonumber(config.spamCount) or 20), 1, 100)
config.submitAfter = math.clamp(math.floor(tonumber(config.submitAfter) or 3), 1, 50)
if TYPING_SPEEDS[config.typingMode] == nil then config.typingMode = "MAX" end
config.panelLocked = config.panelLocked == true

local function setConfig(key, value)
	config[key] = value
	saveConfig(true) -- save immediately so options survive rejoin/re-execute
end

--==============================================================
-- UI bridge
--==============================================================
local ui = {}
local function log(message, kind)
	if ui.log then ui.log(message, kind) end
end

--==============================================================
-- SNIPER LOGIC
--==============================================================
local runtime = {
	scanning = false,
	notifyRemote = nil,
	notifConn = nil,
	seen = {},
	parts = {},
	lastCode = nil,
	waitInvalid = false,
	pending = "",
	retries = 0,
	typingQueue = {},
	typingBusy = false,
	typingCancel = false,
	boxCleared = false,
	lastBrainrot = "Unknown",
	watchUntil = 0,
	spawnSeen = {},
	hooked = setmetatable({}, { __mode = "k" }),
	hooksReady = false,
	isOwn = function() return false end,
}

local function stripRich(text)
	if type(text) ~= "string" then return tostring(text) end
	return (text:gsub("<[^>]->", ""))
end

local function tokenize(text)
	local words = {}
	for word in text:gmatch("[%w_]+") do words[#words + 1] = word end
	return words
end

local INVALID_PATTERNS = {
	"invalid code", "invalid", "expired", "already redeemed", "already used",
	"not found", "rejected", "does not exist", "code redeemed", "you have already",
}

local function isInvalidMessage(text)
	local lowered = tostring(text or ""):lower()
	for _, pattern in ipairs(INVALID_PATTERNS) do
		if lowered:find(pattern, 1, true) then return true end
	end
	return false
end

function runtime.extractSpawn(text)
	text = stripRich(tostring(text or "")):match("^%s*(.-)%s*$") or ""
	if text == "" or #text > 80 then return nil end
	local lowered = text:lower()
	local s = lowered:find("%s+has%s+spawned") or lowered:find("%s+spawned")
	if not s or s <= 1 then return nil end
	local name = text:sub(1, s - 1):match("^%s*(.-)%s*$")
	if not name or name == "" or name:lower():find("code", 1, true) then return nil end
	return name
end

function runtime.matchPhrase(text)
	local lowered = text:lower()
	for _, phrase in ipairs({ "the code is", "code is", "use code", "redeem code" }) do
		local _, e = lowered:find(phrase, 1, true)
		if e then
			return phrase, text:sub(e + 1):gsub("^[%s:;%-%.,!]+", "")
		end
	end
	return nil
end

function runtime.checkSpawn(text)
	if os.clock() > runtime.watchUntil then return end
	local name = runtime.extractSpawn(text)
	if not name then return end
	local key = name:lower()
	if runtime.spawnSeen[key] then return end
	runtime.spawnSeen[key] = true
	task.delay(3, function() runtime.spawnSeen[key] = nil end)
	runtime.watchUntil = 0
	runtime.lastBrainrot = name
	log("Spawned: " .. name, "ok")
end

function runtime.hookObject(object, fresh)
	if runtime.hooked[object] or not (object:IsA("TextLabel") or object:IsA("TextButton")) then return end
	runtime.hooked[object] = true
	local function check()
		if os.clock() <= runtime.watchUntil and not runtime.isOwn(object) then
			runtime.checkSpawn(object.Text)
		end
	end
	object:GetPropertyChangedSignal("Text"):Connect(check)
	if fresh then check() end
end

function runtime.armWatch()
	runtime.watchUntil = os.clock() + 12
	if runtime.hooksReady then return end
	runtime.hooksReady = true
	for _, d in ipairs(PlayerGui:GetDescendants()) do runtime.hookObject(d, false) end
	PlayerGui.DescendantAdded:Connect(function(d) runtime.hookObject(d, true) end)
end

local function getCodeControls()
	local ok, result = pcall(function()
		local codes = PlayerGui:WaitForChild("Codes", 3).Codes
		return { box = codes.CodeRedeem.TextBox, confirm = codes.Confirm }
	end)
	return ok and result or nil
end

local function clickConfirm(controls)
	local button = controls.confirm:FindFirstChildWhichIsA("TextButton") or controls.confirm
	if button then
		pcall(function() firesignal(button.MouseButton1Click) end)
		pcall(function() firesignal(button.Activated) end)
	end
end

local function submitCode(controls, code)
	controls.box.Text = code
	pcall(function() firesignal(controls.box.FocusLost, true) end)
	clickConfirm(controls)
end

local function redeemClassic(code, forceNoSpam)
	if not code or code == "" then return false, "no code" end
	if type(firesignal) ~= "function" then return false, "no firesignal" end
	local controls = getCodeControls()
	if not controls then return false, "no code box" end
	runtime.armWatch()
	if config.spamRedeem and not forceNoSpam then
		local count = math.clamp(tonumber(config.spamCount) or 20, 1, 100)
		for i = 1, count do
			task.spawn(function()
				if i > 1 then task.wait((i - 1) * 0.04) end
				pcall(submitCode, controls, code)
			end)
		end
		return true, "spammed"
	end
	pcall(submitCode, controls, code)
	return true, "submitted"
end

local function typeString(controls, str)
	local speed = TYPING_SPEEDS[config.typingMode] or 0
	for i = 1, #str do
		if runtime.typingCancel then return false end
		pcall(function() controls.box.Text = controls.box.Text .. str:sub(i, i) end)
		if speed > 0 then task.wait(speed) end
	end
	return true
end

local function typingWorker()
	if runtime.typingBusy then return end
	runtime.typingBusy = true
	while #runtime.typingQueue > 0 do
		if runtime.typingCancel or not config.typeInstead then break end
		local controls = getCodeControls()
		if not controls then break end
		if not runtime.boxCleared then
			pcall(function() controls.box:CaptureFocus() end)
			pcall(function() controls.box.Text = "" end)
			runtime.boxCleared = true
		end
		typeString(controls, table.remove(runtime.typingQueue, 1))
	end
	runtime.typingBusy = false
end

local function queueTyping(str)
	if not str or str == "" then return end
	table.insert(runtime.typingQueue, str)
	if not runtime.typingBusy then task.spawn(typingWorker) end
end

local function resetTyping()
	runtime.typingQueue = {}
	runtime.typingCancel = true
	task.wait(0.03)
	runtime.typingCancel = false
	runtime.typingBusy = false
	runtime.boxCleared = false
end

local function waitForTypingComplete(timeout)
	timeout = timeout or 30
	local start = os.clock()
	while (runtime.typingBusy or #runtime.typingQueue > 0) and os.clock() - start < timeout do
		task.wait(0.05)
	end
	task.wait(0.1)
end

local function finalizeTyping()
	waitForTypingComplete(30)
	local controls = getCodeControls()
	if not controls then return false end
	runtime.armWatch()
	pcall(function() firesignal(controls.box.FocusLost, true) end)
	pcall(function() controls.box:ReleaseFocus(true) end)
	clickConfirm(controls)
	runtime.boxCleared = false
	return true
end

local function redeemFinal(code)
	if not code or code == "" then return false, "no code" end
	if config.typeInstead then
		task.spawn(finalizeTyping)
		return true, "typed"
	end
	return redeemClassic(code)
end

local function notifyRoblox()
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "OR'S SNIPER",
			Text = "Code redeemed - " .. runtime.lastBrainrot,
			Duration = 5,
		})
	end)
end

local function submitJoined(joined, trigger, isRetry)
	runtime.lastCode = joined
	task.spawn(function()
		local ok
		if isRetry and config.typeInstead then
			resetTyping()
			queueTyping(joined)
			ok = finalizeTyping()
		else
			ok = redeemFinal(joined)
		end
		if ok then
			log("Redeemed: " .. joined, "ok")
			notifyRoblox()
			if config.twoWordCheck or config.waitInvalid then
				runtime.waitInvalid = true
				runtime.pending = joined
				if not isRetry then runtime.retries = 0 end
			end
		else
			log("Redeem failed: " .. joined, "err")
		end
	end)
end

local function resetScanState()
	runtime.held = false
	runtime.parts = {}
	runtime.waitInvalid = false
	runtime.pending = ""
	runtime.retries = 0
	task.spawn(resetTyping)
end

local function onAnnouncement(...)
	local text = stripRich(tostring((...) or "")):match("^%s*(.-)%s*$") or ""
	if text == "" then return end
	if runtime.seen[text] then return end
	runtime.seen[text] = true
	task.delay(2, function() runtime.seen[text] = nil end)

	runtime.checkSpawn(text)

	local phrase, rest = runtime.matchPhrase(text)

	if not runtime.scanning then
		if not (config.autoStartScan and phrase) then return end
		log("Auto Start: \"" .. phrase .. "\" detected", "ok")
		runtime.startScan()
		if not runtime.scanning then return end
	end

	log("Notification: " .. text)

	if phrase then
		local restWords = tokenize(rest)
		if #restWords >= 2 then return end
		local resumed = runtime.held
		runtime.held = false
		if resumed then
			log("Resume scanning (kept: " .. table.concat(runtime.parts) .. ")", "ok")
		else
			runtime.parts = {}
			runtime.waitInvalid = false
			runtime.pending = ""
			task.spawn(resetTyping)
		end
		if #restWords == 1 then
			local code = table.concat(runtime.parts) .. restWords[1]
			runtime.parts = {}
			runtime.retries = 0
			if ui.word then ui.word(restWords[1]) end
			submitJoined(code, text, true)
		end
		return
	end

	if runtime.held then return end
	if config.holdOnWait and #runtime.parts > 0 and not runtime.waitInvalid then
		local lowered = text:lower()
		if lowered:find("wait", 1, true) or lowered:find("guys", 1, true) or lowered:find("hold", 1, true) then
			runtime.held = true
			log("Hold: waiting (kept: " .. table.concat(runtime.parts) .. ")", "wait")
			return
		end
	end

	local words = tokenize(text)

	if runtime.waitInvalid and (config.waitInvalid or config.twoWordCheck) then
		if isInvalidMessage(text) then
			runtime.retries += 1
			log("Invalid - retry " .. runtime.retries, "wait")
			if runtime.retries > MAX_RETRIES then
				log("Max retries, reset", "err")
				resetScanState()
				return
			end
			runtime.parts = {}
			return
		end
		for _, word in ipairs(words) do
			if ui.word then ui.word(word) end
		end
		local joined = runtime.pending .. table.concat(words)
		runtime.parts = {}
		runtime.waitInvalid = false
		submitJoined(joined, text, true)
		return
	end

	for _, word in ipairs(words) do
		table.insert(runtime.parts, word)
		if ui.word then ui.word(word) end
		if config.typeInstead then queueTyping(word) end
	end

	local target = config.twoWordCheck and 2 or config.submitAfter
	local count = #runtime.parts
	log(("Captured %d/%d [%s]"):format(count, target, table.concat(runtime.parts)))

	if count >= target then
		local joined = table.concat(runtime.parts)
		runtime.parts = {}
		submitJoined(joined, text, false)
	end
end

local function resolveNotifyRemote()
	if runtime.notifyRemote and runtime.notifyRemote.Parent then
		return runtime.notifyRemote
	end
	local ok, controller = pcall(function()
		return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true))
	end)
	if ok and type(controller) == "table" and type(controller.Start) == "function" and getupvalues_ then
		local ok2, upvalues = pcall(getupvalues_, controller.Start)
		if ok2 and type(upvalues) == "table" then
			for _, value in pairs(upvalues) do
				if typeof(value) == "Instance" and (value:IsA("RemoteEvent") or value:IsA("UnreliableRemoteEvent")) then
					runtime.notifyRemote = value
					return value
				end
			end
		end
	end
	return nil
end

local function startListener()
	if runtime.notifConn then return true end
	local remote = resolveNotifyRemote()
	if remote then
		runtime.notifConn = remote.OnClientEvent:Connect(function(...)
			pcall(onAnnouncement, ...)
		end)
		log("Notification listener attached", "ok")
		return true
	end
	log("Notification remote not found", "err")
	return false
end

local function startScan()
	if runtime.scanning then return end
	if not startListener() then return end
	runtime.scanning = true
	if ui.setScanning then ui.setScanning(true) end
	log("Scan started", "ok")
end
runtime.startScan = startScan

local function stopScan()
	if not runtime.scanning then return end
	runtime.scanning = false
	resetScanState()
	if ui.setScanning then ui.setScanning(false) end
	log("Scan stopped", "wait")
end

local optimizeStore = { objects = {} }
local function setOptimize(on)
	if on then
		pcall(function() optimizeStore.quality = settings().Rendering.QualityLevel end)
		optimizeStore.shadows = Lighting.GlobalShadows
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		Lighting.GlobalShadows = false
		for _, child in ipairs(Lighting:GetChildren()) do
			if child:IsA("PostEffect") then
				table.insert(optimizeStore.objects, { child, child.Enabled })
				child.Enabled = false
			end
		end
		for _, d in ipairs(workspace:GetDescendants()) do
			if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam")
				or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
				table.insert(optimizeStore.objects, { d, d.Enabled })
				d.Enabled = false
			end
		end
		return
	end
	for _, pair in ipairs(optimizeStore.objects) do
		pcall(function() if pair[1].Parent then pair[1].Enabled = pair[2] end end)
	end
	optimizeStore.objects = {}
	if optimizeStore.shadows ~= nil then Lighting.GlobalShadows = optimizeStore.shadows end
	if optimizeStore.quality then pcall(function() settings().Rendering.QualityLevel = optimizeStore.quality end) end
end

local blockedConnections = {}
local function setBlockEvents(on)
	if on then
		if not getconns then return false, "getconnections not supported" end
		local packages = ReplicatedStorage:FindFirstChild("Packages")
		local net = packages and packages:FindFirstChild("Net")
		if not net then return false, "Net folder not found" end
		local notify = resolveNotifyRemote()
		local count = 0
		for _, remote in ipairs(net:GetChildren()) do
			if (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) and remote ~= notify then
				local ok, connections = pcall(getconns, remote.OnClientEvent)
				if ok and type(connections) == "table" then
					for _, connection in ipairs(connections) do
						if pcall(function() connection:Disable() end) then
							table.insert(blockedConnections, connection)
							count += 1
						end
					end
				end
			end
		end
		log(("Blocked %d handlers"):format(count), "wait")
		return true
	end
	for _, connection in ipairs(blockedConnections) do
		pcall(function() connection:Enable() end)
	end
	blockedConnections = {}
	log("Events unblocked", "ok")
	return true
end

--==============================================================
-- RIDDLE ENGINE
--==============================================================
local GROQ_API_KEY = (getgenv().GROQ_API_KEY and #tostring(getgenv().GROQ_API_KEY) > 0 and tostring(getgenv().GROQ_API_KEY)) or ""

local currentQuestion, currentAnswer = "", ""
local riddleRefs = {}
local riddleListenConn = nil
local _cachedCtx, _cachedCtxAt = nil, 0

local function requireData(mod)
	if not mod then return nil end
	local ok, res = pcall(require, mod)
	return ok and res or nil
end

local function formatCode(c)
	return tostring(c or ""):gsub("%s+", ""):upper()
end

local function buildSabGameContext()
	local lines = {}
	local function add(t) lines[#lines + 1] = t end
	local RS = game:GetService("ReplicatedStorage")
	local datas = RS:FindFirstChild("Datas") or RS:FindFirstChild("Data")

	add("=== LIVE SAB SCAN ===")
	add("PlaceId=" .. tostring(game.PlaceId))

	local animals = datas and (requireData(datas:FindFirstChild("Animals"))
		or requireData(datas:FindFirstChild("Brainrots"))
		or requireData(datas:FindFirstChild("Pets")))
	if type(animals) == "table" then
		local list = {}
		for k, v in pairs(animals) do
			local name = type(v) == "table" and tostring(v.DisplayName or v.Name or k) or tostring(k)
			local price = type(v) == "table" and (v.Price or v.Generation or v.Income or v.CashPerSecond or v.CPS) or nil
			local rar = type(v) == "table" and (v.Rarity or v.Tier) or nil
			local src = type(v) == "table" and (v.ObtainedFrom or v.Source or v.Event or v.From) or nil
			local row = name
			if price then row = row .. " $" .. tostring(price) .. "/s" end
			if rar then row = row .. " [" .. tostring(rar) .. "]" end
			if src then row = row .. " @" .. tostring(src) end
			list[#list + 1] = { name = name, price = tonumber(price) or 0, row = row, src = tostring(src or ""), rar = tostring(rar or "") }
		end
		table.sort(list, function(a, b) return a.price > b.price end)
		add("BRAINROTS ranked by income (top 40):")
		for i = 1, math.min(40, #list) do add("  " .. i .. ". " .. list[i].row) end
		local hall = {}
		for _, it in ipairs(list) do
			local blob = (it.name .. " " .. it.src .. " " .. it.rar):lower()
			if blob:find("halloween", 1, true) or blob:find("witch", 1, true) or blob:find("spook", 1, true)
				or blob:find("pumpkin", 1, true) or blob:find("skeleton", 1, true) then
				hall[#hall + 1] = it.row
			end
		end
		if #hall > 0 then
			add("HALLOWEEN-TAGGED (" .. #hall .. "): " .. table.concat(hall, " | ", 1, math.min(#hall, 25)))
		end
	else
		add("BRAINROTS: module not found")
	end

	pcall(function()
		local tr = datas and (requireData(datas:FindFirstChild("Traits")) or requireData(datas:FindFirstChild("Trait")))
		if type(tr) ~= "table" then return end
		local rows = {}
		for k, v in pairs(tr) do
			if type(v) == "table" then
				local n = tostring(v.DisplayText or v.Name or v.DisplayName or k)
				local bits = { n }
				local mult = v.Multiplier or v.Mult or v.IncomeMultiplier
				if mult then bits[#bits + 1] = "x" .. tostring(mult) end
				for _, fk in ipairs({ "Event", "EventName", "Source", "From", "ObtainedFrom", "HowToGet", "Category", "Type" }) do
					if v[fk] ~= nil and tostring(v[fk]) ~= "" then
						bits[#bits + 1] = fk .. "=" .. tostring(v[fk])
					end
				end
				rows[#rows + 1] = table.concat(bits, " | ")
			else
				rows[#rows + 1] = tostring(k)
			end
		end
		table.sort(rows)
		add("TRAITS DETAILED (" .. #rows .. "):")
		for i = 1, math.min(#rows, 80) do add("  " .. rows[i]) end
	end)

	pcall(function()
		for _, modName in ipairs({ "Rebirths", "Rebirth", "Gears", "Gear", "Tools", "Items", "Shop" }) do
			local mod = datas and datas:FindFirstChild(modName)
			local data = requireData(mod)
			if type(data) == "table" then
				local rows = {}
				for k, v in pairs(data) do
					if type(v) == "table" then
						local n = tostring(v.Name or v.DisplayName or v.DisplayText or k)
						local bits = { n }
						for _, fk in ipairs({ "Rebirth", "RebirthLevel", "RequiredRebirth", "UnlockRebirth", "Price", "Cost" }) do
							if v[fk] ~= nil and tostring(v[fk]) ~= "" then
								bits[#bits + 1] = fk .. "=" .. tostring(v[fk])
							end
						end
						rows[#rows + 1] = table.concat(bits, " | ")
					end
				end
				table.sort(rows)
				add(modName .. " DETAILED (" .. #rows .. "):")
				for i = 1, math.min(#rows, 50) do add("  " .. rows[i]) end
			end
		end
	end)

	add("=== STATIC LORE ===")
	add("Sammy: name SAMMY age 24 color BLUE food PIZZA cat NOVA country BRAZIL game STEALABRAINROT")
	add("Witch hat trait event: WITCHINGHOUR | Best DLC often GRIFFIN")
	add("Halloween best-a-reskin-of often SPAGHETTITUALETTI; dug dug halloween day-of-october often PUMPUMPUM31")

	return table.concat(lines, "\n")
end

local function getSabContext()
	if _cachedCtx and (os.clock() - _cachedCtxAt) < 45 then return _cachedCtx end
	local ok, ctx = pcall(buildSabGameContext)
	_cachedCtx = (ok and ctx) or "GAME DATA UNAVAILABLE"
	_cachedCtxAt = os.clock()
	return _cachedCtx
end

local AI_SYSTEM = table.concat({
	"You are the Steal a Brainrot (SAB) live riddle engine for redeem codes.",
	"Reply with ONE token only: ALL CAPS, no spaces, no punctuation, no explanation.",
	"Brainrot names must strip spaces (Spaghetti Tualetti -> SPAGHETTITUALETTI).",
	"If asked twice/2 times, concatenate the answer.",
	"Prefer LIVE GAME DATA when provided.",
	"For best prefer highest Generation among matching candidates.",
	"When asked trait event: return Event/Source as ONE token.",
	"When asked gear rebirth: use RequiredRebirth (sentry -> 7, medusa head -> 5).",
	"Reskin of dug dug -> PUMPUMPUM; + day of october/31 -> PUMPUMPUM31.",
	"Medusa head has SNAKES; current year 2026.",
	"Known: halloween reskin-of -> SPAGHETTITUALETTI; + day of october -> SPAGHETTITUALETTI31;",
	"dug dug halloween/october -> PUMPUMPUM31; best DLC -> GRIFFIN; witch hat trait event -> WITCHINGHOUR.",
	"Sammy facts: SAMMY, age 24, BLUE, PIZZA, NOVA, BRAZIL, STEALABRAINROT.",
}, "\n")

local LOCAL_DB = {
	["how old am i"] = "24", ["my age"] = "24", ["what is my age"] = "24",
	["what is my name"] = "SAMMY", ["whats my name"] = "SAMMY", ["what's my name"] = "SAMMY",
	["what is my favorite color"] = "BLUE", ["my favorite color"] = "BLUE",
	["what is my favorite food"] = "PIZZA", ["my favorite food"] = "PIZZA",
	["what is my cats name"] = "NOVA", ["what is my cat's name"] = "NOVA", ["my cats name"] = "NOVA",
	["who made steal a brainrot"] = "SAMMY", ["who made the game"] = "SAMMY",
	["what is the name of the game"] = "STEALABRAINROT",
	["where do i live"] = "BRAZIL", ["my country"] = "BRAZIL",
	["what is my name twice"] = "SAMMYSAMMY", ["my name twice"] = "SAMMYSAMMY",
	["my age twice"] = "2424", ["what is my age twice"] = "2424",
	["what is the best brainrot in the new halloween update a reskin of"] = "SPAGHETTITUALETTI",
	["best brainrot in the new halloween update a reskin of"] = "SPAGHETTITUALETTI",
	["best halloween brainrot a reskin of"] = "SPAGHETTITUALETTI",
	["what is the best brainrot in the halloween update a reskin of"] = "SPAGHETTITUALETTI",
	["halloween best brainrot reskin of"] = "SPAGHETTITUALETTI",
	["what is the new best brainrot in the halloween update"] = "SPAGHETTITUALETTI",
	["best brainrot in the new halloween update"] = "SPAGHETTITUALETTI",
	["what is a reskin of dug dug in halloween update"] = "PUMPUMPUM31",
	["reskin of dug dug in halloween"] = "PUMPUMPUM31",
	["halloween reskin of dug dug"] = "PUMPUMPUM31",
	["dug dug halloween"] = "PUMPUMPUM31",
	["what is the best dlc brainrot you can unbox right now"] = "GRIFFIN",
	["best dlc brainrot you can unbox right now"] = "GRIFFIN",
	["best dlc brainrot"] = "GRIFFIN", ["best dlc"] = "GRIFFIN",
	["what is the best dlc"] = "GRIFFIN",
	["whats the event that gave you witch hat trait"] = "WITCHINGHOUR",
	["what's the event that gave you witch hat trait"] = "WITCHINGHOUR",
	["what is the event that gave you witch hat trait"] = "WITCHINGHOUR",
	["event that gave witch hat trait"] = "WITCHINGHOUR",
	["witch hat trait event"] = "WITCHINGHOUR",
	["witch hat trait"] = "WITCHINGHOUR",
	["wizard hat trait"] = "WITCHINGHOUR",
	["witch hat"] = "WITCHINGHOUR",
	["what event is witch hat from"] = "WITCHINGHOUR",
	["what is the best brainrot of the halloween update a reskin of and the day of october"] = "SPAGHETTITUALETTI31",
	["best brainrot of the halloween update a reskin of and the day of october"] = "SPAGHETTITUALETTI31",
	["best halloween brainrot a reskin of and the day of october"] = "SPAGHETTITUALETTI31",
	["halloween update a reskin of and the day of october"] = "SPAGHETTITUALETTI31",
	["witching hour"] = "WITCHINGHOUR",
}

local WIKI_TRAIT_EVENT = {
	["witch hat"] = "WITCHINGHOUR", ["wizard hat"] = "WITCHINGHOUR", ["witching hour"] = "WITCHINGHOUR",
	["pumpkin"] = "HALLOWEEN", ["pumpkin trait"] = "HALLOWEEN", ["jack o lantern"] = "HALLOWEEN",
	["jack o'lantern"] = "HALLOWEEN", ["jackolantern"] = "HALLOWEEN",
	["frightrot"] = "FRIGHTROT", ["nightmare"] = "WITCHINGHOUR",
	["rip gravestone"] = "GRAVEDIGGER", ["rip tombstone"] = "GRAVEDIGGER", ["rip"] = "GRAVEDIGGER",
	["santa hat"] = "WINTERHOUR", ["reindeer pet"] = "CHRISTMAS", ["reindeer"] = "CHRISTMAS",
	["bunny ears"] = "EASTERHOUR",
	["pink egg"] = "EGGCITY", ["blue egg"] = "EGGCITY", ["green egg"] = "EGGCITY", ["orange egg"] = "EGGCITY",
	["strawberry"] = "STRAWBERRYELEPHANT", ["meowl"] = "MEOWL", ["john pork"] = "JOHNPORK", ["skibidi"] = "SKIBIDITOILET",
	["matteo hat"] = "MATTEO", ["tie"] = "DULDULDUL", ["spider"] = "SAMMYNISPYDERINI",
	["galactic"] = "LAVACCASATURNOSATURNITA", ["taco"] = "RAININGTACOS", ["ufo"] = "UFO",
	["snowy"] = "SNOW", ["comet struck"] = "COMET", ["cometstruck"] = "COMET",
	["extinct"] = "EXTINCT", ["skeleton"] = "EXTINCT", ["10b"] = "10B",
	["fire"] = "FIRE", ["lightning"] = "LIGHTNING", ["nyan"] = "NYAN", ["fireworks"] = "FIREWORKS",
	["paint"] = "CHICLETEIRABICICLETEIRA", ["indonesia"] = "INDONESIA", ["indonesian"] = "INDONESIA",
	["sombrero"] = "MEXICO", ["glitched"] = "GLITCH", ["crab"] = "CRABRAVE", ["claws"] = "CRABRAVE",
	["bubblegum"] = "BUBBLEGUM", ["explosive"] = "BOMBARDIRO", ["halo"] = "DIVINE",
	["lucky"] = "LUCKYPOT", ["chocolate"] = "VALENTINES", ["1 year"] = "1YEAR", ["26"] = "NEWYEAR2026",
	["rainbow balloon"] = "EID", ["pink balloon"] = "EID", ["sun"] = "SUMMERHOUR",
}

local GEAR_REBIRTH = {
	["sentry"] = "7", ["all seeing sentry"] = "7", ["all-seeing sentry"] = "7", ["allseeing sentry"] = "7",
	["medusa"] = "5", ["medusa head"] = "5", ["medusas head"] = "5", ["medusa's head"] = "5",
	["invisibility"] = "4", ["invisibility cloak"] = "4",
	["web slinger"] = "6", ["grapple"] = "3", ["grapple hook"] = "3", ["quantum cloner"] = "7",
}

local RESKIN_MAP = {
	["dug dug dug"] = "PUMPUMPUM", ["dug dug"] = "PUMPUMPUM", ["dugdugdug"] = "PUMPUMPUM",
	["spaghetti tualetti"] = "SPAGHETTITUALETTI", ["sammyni fattini"] = "SAMMYNISPOOKYNI",
}

local FACT_DB = {
	["what does medusa have on her head"] = "SNAKES",
	["what does medusa have on her head plural"] = "SNAKES",
	["medusa have on her head"] = "SNAKES", ["medusa on her head"] = "SNAKES",
	["what year are we on"] = "2026", ["what year is it"] = "2026",
	["what year are we in"] = "2026", ["current year"] = "2026",
	["what event was the pumpkin trait in"] = "HALLOWEEN",
	["what event is the pumpkin trait"] = "HALLOWEEN",
	["pumpkin trait event"] = "HALLOWEEN", ["pumpkin trait"] = "HALLOWEEN",
	["what event was the jack o lantern trait in"] = "HALLOWEEN",
	["what rebirth do you get sentry"] = "7", ["what rebirth do you get the sentry"] = "7",
	["what rebirth is sentry"] = "7", ["rebirth sentry"] = "7",
	["what rebirth do you get medusa"] = "5", ["what rebirth medusa head"] = "5",
	["reskin of dug dug dug"] = "PUMPUMPUM", ["what is the reskin of dug dug dug"] = "PUMPUMPUM",
	["reskin of dug dug"] = "PUMPUMPUM", ["what is the reskin of dug dug"] = "PUMPUMPUM",
}

local function trim(str)
	return tostring(str or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeQuestion(text)
	local l = trim(text):lower()
	l = l:gsub("<[^>]+>", "")
	l = l:gsub("[%?%.%,!;:]", " ")
	l = l:gsub("^riddle%s+is%s+", "")
	l = l:gsub("^the%s+riddle%s+is%s+", "")
	l = l:gsub("^riddle%s*", "")
	l = l:gsub("^question%s*", "")
	l = l:gsub("%s+", " ")
	return trim(l)
end

local function semanticAnswer(q)
	q = normalizeQuestion(q)
	if q == "" then return nil end
	local function has(s) return q:find(s, 1, true) ~= nil end
	if has("halloween") and has("reskin") and (has("october") or has("day of")) then return "SPAGHETTITUALETTI31" end
	if has("halloween") and has("reskin") then return "SPAGHETTITUALETTI" end
	if has("halloween") and has("best") and (has("brainrot") or has("reskin")) then return "SPAGHETTITUALETTI" end
	if (has("dug dug") or has("dugdug")) and (has("halloween") or has("october") or has("reskin")) then return "PUMPUMPUM31" end
	if has("dlc") and (has("best") or has("unbox") or has("right now") or has("currently")) then return "GRIFFIN" end
	if (has("witch hat") or has("wizard hat")) and (has("event") or has("trait") or has("gave") or has("from")) then return "WITCHINGHOUR" end
	if has("witch hat") or has("wizard hat") then return "WITCHINGHOUR" end
	if has("twice") or has("2 times") then
		if has("name") then return "SAMMYSAMMY" end
		if has("age") then return "2424" end
		if has("color") then return "BLUEBLUE" end
		if has("food") then return "PIZZAPIZZA" end
	end
	return nil
end

local function answerReskin(q)
	q = normalizeQuestion(q)
	local wantsDay = q:find("october", 1, true) or q:find("day of", 1, true) or q:find("31", 1, true)
	for base, tok in pairs(RESKIN_MAP) do
		if q:find(base, 1, true) and (q:find("reskin", 1, true) or q:find("halloween", 1, true)) then
			return wantsDay and (tok .. "31") or tok
		end
	end
	if q:find("dug", 1, true) and (q:find("reskin", 1, true) or q:find("halloween", 1, true)) then
		return wantsDay and "PUMPUMPUM31" or "PUMPUMPUM"
	end
	return nil
end

local function answerGearRebirth(q)
	q = normalizeQuestion(q)
	if not (q:find("rebirth", 1, true) or q:find("unlock", 1, true) or q:find("get", 1, true)) then return nil end
	for gear, rb in pairs(GEAR_REBIRTH) do
		if q:find(gear, 1, true) then return rb end
	end
	return nil
end

local function answerFact(q)
	q = normalizeQuestion(q)
	if FACT_DB[q] then return FACT_DB[q] end
	if q:find("medusa", 1, true) and q:find("head", 1, true) then return "SNAKES" end
	if q:find("year", 1, true) and (q:find("we", 1, true) or q:find("current", 1, true) or q:find("what", 1, true)) then return "2026" end
	if q:find("pumpkin", 1, true) and (q:find("trait", 1, true) or q:find("event", 1, true)) then return "HALLOWEEN" end
	return nil
end

local function wikiTraitAnswer(q)
	q = normalizeQuestion(q)
	for trait, event in pairs(WIKI_TRAIT_EVENT) do
		if q:find(trait, 1, true) then
			if q:find("event", 1, true) or q:find("gave", 1, true) or q:find("from", 1, true)
				or q:find("trait", 1, true) or q:find("how", 1, true) or q:find("which", 1, true)
				or q:find("what", 1, true) then
				return event
			end
		end
	end
	for trait, event in pairs(WIKI_TRAIT_EVENT) do
		if q == trait or q == (trait .. " trait") then return event end
	end
	return nil
end

local function localExactAnswer(text)
	local l = normalizeQuestion(text)
	if LOCAL_DB[l] then return LOCAL_DB[l] end
	local f = answerFact(text)
	if f then return f end
	local r = answerReskin(text)
	if r then return r end
	local g = answerGearRebirth(text)
	if g then return g end
	local w = wikiTraitAnswer(text)
	if w then return w end
	return semanticAnswer(text)
end

local function applyMultiplier(answer, text)
	if not answer or answer == "" then return answer end
	local l = normalizeQuestion(text)
	local n = nil
	if l:find("twice", 1, true) or l:find("2 times", 1, true) then n = 2 end
	if l:find("thrice", 1, true) or l:find("3 times", 1, true) then n = 3 end
	local m = l:match("(%d+)%s*times")
	if m then m = tonumber(m); if m and m >= 2 and m <= 10 then n = m end end
	if n and n > 1 then
		local out = ""
		for _ = 1, n do out = out .. answer end
		return out
	end
	return answer
end

local function liveScanAnswer(text)
	local q = normalizeQuestion(text)
	local RS = game:GetService("ReplicatedStorage")
	local datas = RS:FindFirstChild("Datas")
	local animals = datas and requireData(datas:FindFirstChild("Animals"))
	if type(animals) ~= "table" then return nil end

	local wantHalloween = q:find("halloween", 1, true) or q:find("spook", 1, true)
	local wantBest = q:find("best", 1, true) or q:find("strongest", 1, true) or q:find("highest", 1, true)
	local wantDlc = q:find("dlc", 1, true)

	local candidates = {}
	for _, a in pairs(animals) do
		if type(a) == "table" and a.DisplayName then
			local name = tostring(a.DisplayName)
			local price = tonumber(a.Price or a.Generation or a.Income or a.CashPerSecond or a.CPS) or 0
			local blob = (name .. " " .. tostring(a.Rarity or "") .. " " .. tostring(a.ObtainedFrom or a.Source or a.Event or "")):lower()
			local ok = true
			if wantHalloween and not (blob:find("halloween", 1, true) or blob:find("spook", 1, true) or blob:find("witch", 1, true) or blob:find("pumpkin", 1, true)) then
				ok = false
			end
			if wantDlc and not (blob:find("dlc", 1, true) or blob:find("unbox", 1, true)) then
				ok = false
			end
			if ok then
				candidates[#candidates + 1] = { name = name, price = price }
			end
		end
	end
	if #candidates == 0 then return nil end
	table.sort(candidates, function(a, b) return a.price > b.price end)
	if wantBest or wantHalloween or wantDlc then
		return formatCode(candidates[1].name)
	end
	return nil
end

local function askGroq(question)
	if not GROQ_API_KEY or GROQ_API_KEY == "" then return nil, "no key" end
	if not httpRequest then return nil, "no http" end
	local ctx = getSabContext()
	local body = HttpService:JSONEncode({
		model = "llama-3.3-70b-versatile",
		temperature = 0.1,
		max_tokens = 32,
		messages = {
			{ role = "system", content = AI_SYSTEM },
			{ role = "user", content = "LIVE DATA:\n" .. tostring(ctx):sub(1, 12000) .. "\n\nRIDDLE:\n" .. tostring(question) },
		},
	})
	local ok, res = pcall(function()
		return httpRequest({
			Url = "https://api.groq.com/openai/v1/chat/completions",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = "Bearer " .. GROQ_API_KEY,
			},
			Body = body,
		})
	end)
	if not ok or not res or type(res.Body) ~= "string" then return nil, "request fail" end
	local decoded = nil
	pcall(function() decoded = HttpService:JSONDecode(res.Body) end)
	if type(decoded) ~= "table" then return nil, "bad json" end
	local content = decoded.choices and decoded.choices[1] and decoded.choices[1].message and decoded.choices[1].message.content
	if type(content) ~= "string" then return nil, "empty" end
	local token = formatCode(content:match("[%w]+") or content)
	if token == "" then return nil, "empty token" end
	return token
end

local function setQuestion(q)
	currentQuestion = tostring(q or "")
	if riddleRefs.qLabel then
		riddleRefs.qLabel.Text = currentQuestion ~= "" and currentQuestion or "Waiting for riddle..."
	end
	if riddleRefs.status then
		riddleRefs.status.Text = (currentAnswer ~= "" and "Answer ready")
			or (currentQuestion ~= "" and "Riddle detected")
			or "Waiting for riddle"
	end
end

local function setAnswer(a)
	currentAnswer = formatCode(a)
	if riddleRefs.aLabel then
		riddleRefs.aLabel.Text = currentAnswer ~= "" and currentAnswer or "—"
	end
	if riddleRefs.status then
		riddleRefs.status.Text = (currentAnswer ~= "" and "Answer ready")
			or (currentQuestion ~= "" and "Riddle detected")
			or "Waiting for riddle"
	end
	if currentAnswer ~= "" and config.riddlerAutoRedeem then
		task.defer(function()
			pcall(function() redeemClassic(currentAnswer, false) end)
			log("Riddle auto-redeem: " .. currentAnswer, "ok")
		end)
	end
end

local function clearRiddle()
	setQuestion("")
	setAnswer("")
	log("Riddle cleared", "wait")
end

local function copyRiddleAnswer()
	if currentAnswer == "" then
		log("Nothing to copy", "err")
		return
	end
	local ok = false
	pcall(function() if setclipboard then setclipboard(currentAnswer); ok = true end end)
	pcall(function() if not ok and toclipboard then toclipboard(currentAnswer); ok = true end end)
	log(ok and ("Copied " .. currentAnswer) or "Clipboard unavailable", ok and "ok" or "err")
end

local function redeemRiddleAnswer()
	if currentAnswer == "" then
		log("No answer", "err")
		return
	end
	local ok = redeemClassic(currentAnswer, false)
	log(ok and ("Redeemed " .. currentAnswer) or "Redeem failed", ok and "ok" or "err")
end

local function handleRiddleText(text)
	text = stripRich(tostring(text or ""))
	if text == "" then return end

	setQuestion(text)

	local ans = localExactAnswer(text)
	if ans then
		ans = applyMultiplier(ans, text)
		setAnswer(ans)
		log("Riddle local: " .. ans, "ok")
		return
	end

	local live = liveScanAnswer(text)
	if live then
		live = applyMultiplier(live, text)
		setAnswer(live)
		log("Riddle live: " .. live, "ok")
		return
	end

	if not config.riddlerAI then
		log("No local answer · enable AI for Groq", "wait")
		return
	end

	log("Asking AI...", "busy")
	task.spawn(function()
		local token, err = askGroq(text)
		if token then
			token = applyMultiplier(token, text)
			setAnswer(token)
			log("Riddle AI: " .. token, "ok")
		else
			log("AI fail: " .. tostring(err), "err")
		end
	end)
end

local function stopRiddleListen()
	if riddleListenConn then
		pcall(function() riddleListenConn:Disconnect() end)
		riddleListenConn = nil
	end
end

local function startRiddleListen()
	stopRiddleListen()
	local remote = resolveNotifyRemote()
	if not remote then
		log("Riddle listen: remote missing", "err")
		return false
	end
	riddleListenConn = remote.OnClientEvent:Connect(function(...)
		if not config.riddlerListen then return end
		local args = table.pack(...)
		if args.n < 1 or type(args[1]) ~= "string" then return end
		local text = tostring(args[1])
		local lower = text:lower()
		if lower:find("riddle", 1, true) and not config.riddlerAI then
			setConfig("riddlerAI", true)
			if riddleRefs.refreshToggles then riddleRefs.refreshToggles() end
		end
		handleRiddleText(text)
	end)
	log("Riddle listening", "ok")
	return true
end

--==============================================================
-- FLAG CHECK
--==============================================================
local FLAG = { code = "SAMMY", limit = 2.5, minWait = 0.35, timeout = 12, poll = 0.03 }
local flagCheck = { running = false }
local screenGui

local function isOwnGui(object)
	return screenGui ~= nil and object:IsDescendantOf(screenGui)
end
runtime.isOwn = isOwnGui

local function flagSnapshot()
	local snap = {}
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if (d:IsA("TextLabel") or d:IsA("TextButton")) and type(d.Text) == "string" and d.Text ~= "" then
			snap[d] = d.Text
		end
	end
	return snap
end

local function flagIsReply(text)
	local lowered = string.lower(text)
	return lowered:find("sold out", 1, true) or lowered:find("soldout", 1, true) or lowered:find("expired", 1, true)
end

local function flagFindNew(before)
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") then
			local text = d.Text
			if type(text) == "string" and flagIsReply(text) and not isOwnGui(d) then
				local previous = before[d]
				if previous == nil or previous ~= text then return text end
			end
		end
	end
	return nil
end

--==============================================================
-- UI HELPERS
--==============================================================
local function make(className, props, parent)
	local o = Instance.new(className)
	for k, v in pairs(props or {}) do o[k] = v end
	o.Parent = parent
	return o
end

local function corner(o, r)
	return make("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o)
end

local function stroke(o, col, th, tr)
	return make("UIStroke", {
		Color = col or C.border,
		Thickness = th or 1,
		Transparency = tr or 0.4,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, o)
end

local function tw(obj, props, info)
	if not obj or not obj.Parent then return end
	if not config.animations then
		for k, v in pairs(props) do obj[k] = v end
		return
	end
	TweenService:Create(obj, info or FAST, props):Play()
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

--==============================================================
-- BUILD UI
--==============================================================
local MENU_NAME = "OrsSniperGui"
local VERSION = "2.1"
local destroyed = false
local globalConnections = {}
local panelOpen = false
local OrsSniper = {}

local PANEL_W, PANEL_H = 268, 380
local BTN_W, BTN_H = 112, 36

local function initialize()
	local parentGui = (gethui and gethui()) or PlayerGui
	local old = parentGui:FindFirstChild(MENU_NAME)
	if old then old:Destroy() end

	screenGui = make("ScreenGui", {
		DisplayOrder = 260,
		IgnoreGuiInset = true,
		Name = MENU_NAME,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, parentGui)

	-- ========== MENU BUTTON (black / white / gray + image + effects) ==========
	local menuBtn = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(8, 8, 10),
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBlack,
		Text = "",
		TextSize = 13,
		TextColor3 = C.text,
		Size = UDim2.fromOffset(BTN_W, BTN_H),
		Position = (type(config.menuOX) == "number")
			and UDim2.new(config.menuSX or 0, config.menuOX, config.menuSY or 0, config.menuOY or 0)
			or UDim2.new(0, 18, 0.55, 0),
		ClipsDescendants = true,
		ZIndex = 60,
	}, screenGui)
	corner(menuBtn, 11)
	local menuStroke = stroke(menuBtn, Color3.fromRGB(200, 200, 210), 1.5, 0.3)

	-- background image on button
	local btnBg = make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = BG_IMAGE,
		ImageTransparency = 0.35,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 60,
	}, menuBtn)
	corner(btnBg, 11)

	local btnShade = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 61,
	}, menuBtn)
	corner(btnShade, 11)

	local btnLabel = make("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack,
		Text = "OR'S",
		TextSize = 13,
		TextColor3 = C.text,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 62,
	}, menuBtn)

	make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 210, 220)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 150)),
		}),
		Rotation = 100,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.9),
			NumberSequenceKeypoint.new(0.5, 0.95),
			NumberSequenceKeypoint.new(1, 0.88),
		}),
	}, btnShade)

	-- outer glow
	local btnGlow = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(230, 230, 240),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(BTN_W + 16, BTN_H + 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		ZIndex = 59,
	}, menuBtn)
	corner(btnGlow, 15)

	task.spawn(function()
		while menuBtn.Parent and not destroyed do
			if config.animations then
				tw(btnGlow, { BackgroundTransparency = 0.75, Size = UDim2.fromOffset(BTN_W + 20, BTN_H + 20) }, PULSE)
				tw(menuStroke, { Transparency = 0.18 }, PULSE)
				task.wait(1.35)
				tw(btnGlow, { BackgroundTransparency = 0.92, Size = UDim2.fromOffset(BTN_W + 14, BTN_H + 14) }, PULSE)
				tw(menuStroke, { Transparency = 0.4 }, PULSE)
				task.wait(1.35)
			else
				task.wait(2)
			end
		end
	end)

	menuBtn.MouseEnter:Connect(function()
		tw(btnShade, { BackgroundTransparency = 0.22 }, FAST)
		tw(menuStroke, { Transparency = 0.08, Thickness = 1.9 }, FAST)
		tw(btnGlow, { BackgroundTransparency = 0.65 }, FAST)
		tw(btnBg, { ImageTransparency = 0.22 }, FAST)
	end)
	menuBtn.MouseLeave:Connect(function()
		tw(btnShade, { BackgroundTransparency = 0.35 }, FAST)
		tw(menuStroke, { Transparency = 0.3, Thickness = 1.5 }, FAST)
		tw(btnBg, { ImageTransparency = 0.35 }, FAST)
	end)

	-- ========== CONFIG PANEL (centered, smaller) ==========
	local panel = make("Frame", {
		BackgroundColor3 = C.bg,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(PANEL_W, PANEL_H),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 50,
		Active = true,
	}, screenGui)
	corner(panel, 14)
	local panelStroke = stroke(panel, C.border, 1.2, 0.28)

	-- Background image (more visible)
	local bgImg = make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = BG_IMAGE,
		ImageTransparency = 0.28,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 50,
	}, panel)
	corner(bgImg, 14)

	-- lighter shade so image shows more
	local shade = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 51,
	}, panel)
	corner(shade, 14)

	local panelScale = make("UIScale", { Scale = 0.9 }, panel)

	-- Header
	local header = make("Frame", {
		BackgroundColor3 = C.panel,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 42),
		ZIndex = 52,
	}, panel)
	corner(header, 14)
	make("Frame", {
		BackgroundColor3 = C.panel,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 1, -14),
		ZIndex = 52,
	}, header)

	-- Avatar thumbnail + username next to title
	local avatar = make("ImageLabel", {
		BackgroundColor3 = C.card,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Image = "",
		Size = UDim2.fromOffset(28, 28),
		Position = UDim2.fromOffset(10, 7),
		ZIndex = 53,
	}, header)
	corner(avatar, 8)
	stroke(avatar, C.border, 1, 0.45)

	task.spawn(function()
		local uid = LocalPlayer.UserId
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok and type(url) == "string" then
			avatar.Image = url
		else
			-- fallback rbxthumb
			avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=48&h=48"
		end
	end)

	make("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack,
		Text = "OR'S SNIPER",
		TextSize = 12,
		TextColor3 = C.text,
		Position = UDim2.fromOffset(44, 4),
		Size = UDim2.new(1, -120, 0, 16),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 53,
	}, header)

	make("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "@" .. tostring(LocalPlayer.Name),
		TextSize = 10,
		TextColor3 = C.muted,
		Position = UDim2.fromOffset(44, 20),
		Size = UDim2.new(1, -120, 0, 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 53,
	}, header)

	local accentLine = make("Frame", {
		BackgroundColor3 = C.accent,
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(40, 2),
		Position = UDim2.fromOffset(44, 36),
		ZIndex = 53,
	}, header)
	corner(accentLine, 1)

	-- Lock button (left of X): 🔒 locked = no move, 🔓 unlocked = can drag
	local lockBtn = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = C.card,
		BackgroundTransparency = 0.25,
		Text = config.panelLocked and "🔒" or "🔓",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = C.text,
		Size = UDim2.fromOffset(26, 26),
		Position = UDim2.new(1, -66, 0.5, -13),
		ZIndex = 53,
	}, header)
	corner(lockBtn, 7)
	stroke(lockBtn, C.border, 1, 0.5)

	local function refreshLock()
		lockBtn.Text = config.panelLocked and "🔒" or "🔓"
	end
	refreshLock()

	lockBtn.MouseButton1Click:Connect(function()
		setConfig("panelLocked", not config.panelLocked)
		refreshLock()
		log(config.panelLocked and "Locked (no move)" or "Unlocked (can drag)", "ok")
		local sc = lockBtn:FindFirstChildOfClass("UIScale") or make("UIScale", { Scale = 1 }, lockBtn)
		sc.Scale = 0.85
		tw(sc, { Scale = 1 }, POP)
	end)
	lockBtn.MouseEnter:Connect(function()
		tw(lockBtn, { BackgroundColor3 = C.hover }, FAST)
	end)
	lockBtn.MouseLeave:Connect(function()
		tw(lockBtn, { BackgroundColor3 = C.card }, FAST)
	end)

	local closeX = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = C.card,
		BackgroundTransparency = 0.25,
		Text = "×",
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextColor3 = C.muted,
		Size = UDim2.fromOffset(26, 26),
		Position = UDim2.new(1, -34, 0.5, -13),
		ZIndex = 53,
	}, header)
	corner(closeX, 7)
	stroke(closeX, C.border, 1, 0.5)
	closeX.MouseEnter:Connect(function()
		tw(closeX, { BackgroundColor3 = C.hover, TextColor3 = C.text }, FAST)
	end)
	closeX.MouseLeave:Connect(function()
		tw(closeX, { BackgroundColor3 = C.card, TextColor3 = C.muted }, FAST)
	end)

	-- Tabs
	local tabBar = make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 46),
		Size = UDim2.new(1, -16, 0, 26),
		ZIndex = 52,
	}, panel)

	local TAB_NAMES = { "Main", "Type", "Logs", "More" }
	local tabButtons = {}
	local pages = {}
	local currentTab = nil
	local tabIndicator = make("Frame", {
		BackgroundColor3 = C.accent,
		BorderSizePixel = 0,
		Size = UDim2.new(1 / #TAB_NAMES, -4, 0, 2),
		Position = UDim2.new(0, 2, 1, -2),
		ZIndex = 53,
	}, tabBar)
	corner(tabIndicator, 1)

	local content = make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 74),
		Size = UDim2.new(1, 0, 1, -80),
		ClipsDescendants = true,
		ZIndex = 52,
	}, panel)

	local function makePage(name)
		local scroller = make("ScrollingFrame", {
			Name = name,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = C.muted,
			Visible = false,
			ZIndex = 52,
		}, content)
		make("UIListLayout", {
			Padding = UDim.new(0, 7),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}, scroller)
		make("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}, scroller)
		pages[name] = scroller
		return scroller
	end

	local function showTab(name)
		if currentTab == name then return end
		currentTab = name
		for n, p in pairs(pages) do
			p.Visible = (n == name)
		end
		local idx = table.find(TAB_NAMES, name) or 1
		tw(tabIndicator, { Position = UDim2.new((idx - 1) / #TAB_NAMES, 2, 1, -2) }, FAST)
		for n, b in pairs(tabButtons) do
			b.TextColor3 = (n == name) and C.text or C.muted
		end
	end

	for i, name in ipairs(TAB_NAMES) do
		local b = make("TextButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = name,
			TextSize = 11,
			TextColor3 = C.muted,
			Size = UDim2.new(1 / #TAB_NAMES, -2, 1, 0),
			Position = UDim2.new((i - 1) / #TAB_NAMES, 1, 0, 0),
			ZIndex = 53,
		}, tabBar)
		tabButtons[name] = b
		b.MouseButton1Click:Connect(function() showTab(name) end)
	end

	local orderCounter = 0
	local function nextOrder()
		orderCounter += 1
		return orderCounter
	end

	local function addCard(parent, height)
		local card = make("Frame", {
			BackgroundColor3 = C.card,
			BackgroundTransparency = 0.22,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = nextOrder(),
			ZIndex = 53,
		}, parent)
		corner(card, 10)
		stroke(card, C.border, 1, 0.55)
		return card
	end

	local function addSection(parent, text)
		local l = make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = text,
			TextSize = 10,
			TextColor3 = C.muted,
			Size = UDim2.new(1, 0, 0, 14),
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = nextOrder(),
			ZIndex = 53,
		}, parent)
		return l
	end

	local function addLabel(parent, text, y, size, color)
		return make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = text,
			TextSize = size or 12,
			TextColor3 = color or C.text,
			Position = UDim2.fromOffset(12, y),
			Size = UDim2.new(1, -24, 0, size + 4),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 54,
		}, parent)
	end

	local function addToggle(parent, title, desc, getter, setter)
		local card = addCard(parent, desc and 56 or 42)
		addLabel(card, title, 6, 12, C.text)
		if desc then
			make("TextLabel", {
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				Text = desc,
				TextSize = 10,
				TextColor3 = C.muted,
				Position = UDim2.fromOffset(12, 24),
				Size = UDim2.new(1, -68, 0, 26),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				ZIndex = 54,
			}, card)
		end

		local track = make("Frame", {
			BackgroundColor3 = C.off,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(38, 20),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			ZIndex = 54,
		}, card)
		corner(track, 10)

		local knob = make("Frame", {
			BackgroundColor3 = C.muted,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromOffset(2, 2),
			ZIndex = 55,
		}, track)
		corner(knob, 8)

		local function paint()
			local on = getter() == true
			tw(track, { BackgroundColor3 = on and C.accent or C.off })
			tw(knob, {
				Position = on and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
				BackgroundColor3 = on and C.bg or C.muted,
			})
		end
		paint()

		local hit = make("TextButton", {
			BackgroundTransparency = 1,
			Text = "",
			Size = UDim2.fromScale(1, 1),
			ZIndex = 56,
		}, card)
		hit.MouseButton1Click:Connect(function()
			setter(not (getter() == true))
			paint()
			saveConfig()
			-- micro feedback
			local sc = card:FindFirstChildOfClass("UIScale") or make("UIScale", { Scale = 1 }, card)
			sc.Scale = 0.97
			tw(sc, { Scale = 1 }, POP)
		end)
		return paint
	end

	local function addNumberRow(parent, title, desc, getter, setter, minV, maxV)
		local card = addCard(parent, 50)
		addLabel(card, title, 5, 12, C.text)
		make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			Text = desc,
			TextSize = 10,
			TextColor3 = C.muted,
			Position = UDim2.fromOffset(12, 24),
			Size = UDim2.new(1, -100, 0, 18),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 54,
		}, card)

		local val = make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = tostring(getter()),
			TextSize = 13,
			TextColor3 = C.accent,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -48, 0.5, 0),
			Size = UDim2.fromOffset(36, 22),
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 54,
		}, card)

		local function step(d)
			local v = math.clamp((tonumber(getter()) or minV) + d, minV, maxV)
			setter(v)
			val.Text = tostring(getter())
			saveConfig()
		end

		local minus = make("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = C.off,
			Text = "-",
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = C.text,
			Size = UDim2.fromOffset(24, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -86, 0.5, 0),
			ZIndex = 54,
		}, card)
		corner(minus, 6)
		minus.MouseButton1Click:Connect(function() step(-1) end)

		local plus = make("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = C.off,
			Text = "+",
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = C.text,
			Size = UDim2.fromOffset(24, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			ZIndex = 54,
		}, card)
		corner(plus, 6)
		plus.MouseButton1Click:Connect(function() step(1) end)
	end

	local function addBtn(parent, text, fn)
		local b = make("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = C.card,
			BackgroundTransparency = 0.15,
			Font = Enum.Font.GothamBold,
			Text = text,
			TextSize = 12,
			TextColor3 = C.text,
			Size = UDim2.new(1, 0, 0, 34),
			LayoutOrder = nextOrder(),
			ZIndex = 53,
		}, parent)
		corner(b, 9)
		stroke(b, C.border, 1, 0.5)
		b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = C.hover }) end)
		b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = C.card }) end)
		b.MouseButton1Click:Connect(fn)
		return b
	end

	local function addConsole(parent, title, height)
		local card = addCard(parent, height)
		addLabel(card, title, 5, 11, C.text)
		local sc = make("ScrollingFrame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(8, 24),
			Size = UDim2.new(1, -16, 1, -32),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = C.muted,
			ZIndex = 54,
		}, card)
		corner(sc, 6)
		make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, sc)
		make("UIPadding", {
			PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
		}, sc)
		local lines, counter = {}, 0
		return function(text, color)
			if destroyed then return end
			counter += 1
			local line = make("TextLabel", {
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				Text = text,
				TextSize = 11,
				TextColor3 = color or C.muted,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = counter,
				ZIndex = 55,
			}, sc)
			table.insert(lines, line)
			if #lines > 60 then table.remove(lines, 1):Destroy() end
			task.defer(function()
				if sc.Parent then
					sc.CanvasPosition = Vector2.new(0, math.max(0, sc.AbsoluteCanvasSize.Y - sc.AbsoluteSize.Y))
				end
			end)
		end
	end

	-- ===== MAIN (most important first) =====
	orderCounter = 0
	local mainPage = makePage("Main")

	-- 1. Start Scan (most important)
	local scanCard = addCard(mainPage, 46)
	local scanLabel = make("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack,
		Text = "START SCAN",
		TextSize = 14,
		TextColor3 = C.text,
		Size = UDim2.fromScale(1, 1),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 54,
	}, scanCard)
	local scanHit = make("TextButton", {
		BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 55,
	}, scanCard)
	local scanToken = 0
	ui.setScanning = function(on)
		scanToken += 1
		local token = scanToken
		if not on then
			scanLabel.Text = "START SCAN"
			return
		end
		task.spawn(function()
			local frames = { "SCANNING.", "SCANNING..", "SCANNING..." }
			local i = 1
			while scanToken == token and not destroyed do
				scanLabel.Text = frames[i]
				i = i % #frames + 1
				task.wait(0.32)
			end
		end)
	end
	scanHit.MouseButton1Click:Connect(function()
		if runtime.scanning then stopScan() else startScan() end
	end)
	scanCard.MouseEnter:Connect(function()
		tw(scanCard, { BackgroundTransparency = 0.08 }, FAST)
	end)
	scanCard.MouseLeave:Connect(function()
		tw(scanCard, { BackgroundTransparency = 0.22 }, FAST)
	end)

	-- 2. Spam Redeem
	addToggle(mainPage, "Spam Redeem", "Submit the code several times", function()
		return config.spamRedeem
	end, function(v) setConfig("spamRedeem", v) end)

	-- 3. Spam Count
	addNumberRow(mainPage, "Spam Count", "Number of submits (1–100)", function()
		return config.spamCount
	end, function(v) setConfig("spamCount", v) end, 1, 100)

	-- 4. Submit After
	addNumberRow(mainPage, "Submit After", "Messages before redeeming", function()
		return config.submitAfter
	end, function(v) setConfig("submitAfter", v) end, 1, 50)

	-- 5. Auto Start
	addToggle(mainPage, "Auto Start Scan", "Starts on CODE IS / USE CODE", function()
		return config.autoStartScan
	end, function(v)
		setConfig("autoStartScan", v)
		if v then startListener() end
	end)

	-- 6. Detected words
	ui.word = addConsole(mainPage, "Detected Words", 100)

	-- ===== TYPE (riddle + typing, importance ordered) =====
	orderCounter = 0
	local typePage = makePage("Type")

	addSection(typePage, "RIDDLE ENGINE")

	-- most important riddle options first
	local riddlePaintListen = addToggle(typePage, "Riddle Listen", "Watch announcements for riddles", function()
		return config.riddlerListen
	end, function(v)
		setConfig("riddlerListen", v)
		if v then startRiddleListen() else stopRiddleListen() end
	end)

	local riddlePaintAI = addToggle(typePage, "Riddle AI", "Groq solves unknown riddles (GROQ_API_KEY)", function()
		return config.riddlerAI
	end, function(v) setConfig("riddlerAI", v) end)

	local riddlePaintAuto = addToggle(typePage, "Riddle Auto Redeem", "Redeem answer automatically", function()
		return config.riddlerAutoRedeem
	end, function(v) setConfig("riddlerAutoRedeem", v) end)

	riddleRefs.refreshToggles = function()
		if riddlePaintAI then riddlePaintAI() end
		if riddlePaintListen then riddlePaintListen() end
		if riddlePaintAuto then riddlePaintAuto() end
	end

	local statusCard = addCard(typePage, 34)
	riddleRefs.status = make("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "Waiting for riddle",
		TextSize = 11,
		TextColor3 = C.muted,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 54,
	}, statusCard)

	local qCard = addCard(typePage, 50)
	make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "QUESTION",
		TextSize = 9, TextColor3 = C.muted, Position = UDim2.fromOffset(12, 4),
		Size = UDim2.new(1, -24, 0, 12), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 54,
	}, qCard)
	riddleRefs.qLabel = make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "Waiting for riddle...",
		TextSize = 11, TextColor3 = C.text, Position = UDim2.fromOffset(12, 18),
		Size = UDim2.new(1, -24, 0, 28), TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, ZIndex = 54,
	}, qCard)

	local aCard = addCard(typePage, 38)
	make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "ANSWER",
		TextSize = 9, TextColor3 = C.muted, Position = UDim2.fromOffset(12, 3),
		Size = UDim2.new(1, -24, 0, 12), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 54,
	}, aCard)
	riddleRefs.aLabel = make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, Text = "—",
		TextSize = 13, TextColor3 = C.accent, Position = UDim2.fromOffset(12, 16),
		Size = UDim2.new(1, -24, 0, 18), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 54,
	}, aCard)

	local btnRow = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		LayoutOrder = nextOrder(),
		ZIndex = 53,
	}, typePage)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	}, btnRow)

	local function smallAct(text, fn)
		local b = make("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = C.card,
			Font = Enum.Font.GothamBold,
			Text = text,
			TextSize = 11,
			TextColor3 = C.muted,
			Size = UDim2.new(1 / 3, -4, 1, 0),
			ZIndex = 54,
		}, btnRow)
		corner(b, 8)
		stroke(b, C.border, 1, 0.5)
		b.MouseEnter:Connect(function()
			tw(b, { TextColor3 = C.text, BackgroundColor3 = C.hover })
		end)
		b.MouseLeave:Connect(function()
			tw(b, { TextColor3 = C.muted, BackgroundColor3 = C.card })
		end)
		b.MouseButton1Click:Connect(fn)
	end
	smallAct("COPY", copyRiddleAnswer)
	smallAct("CLEAR", clearRiddle)
	smallAct("REDEEM", redeemRiddleAnswer)

	addBtn(typePage, "Test Riddle (sample)", function()
		local samples = {
			"what is my real name",
			"how old am i",
			"what is the best brainrot in the new halloween update a reskin of",
			"what is a reskin of dug dug in halloween update",
			"what is the best dlc brainrot you can unbox right now",
			"whats the event that gave you witch hat trait",
			"what is my name twice",
		}
		handleRiddleText(samples[math.random(1, #samples)])
	end)

	addSection(typePage, "TYPING / WORD LOGIC")

	addToggle(typePage, "Type Instead", "Type letter by letter", function()
		return config.typeInstead
	end, function(v)
		setConfig("typeInstead", v)
		if not v then task.spawn(resetTyping) end
	end)

	do
		local card = addCard(typePage, 50)
		addLabel(card, "Typing Speed", 5, 12, C.text)
		local holder = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(12, 24),
			Size = UDim2.new(1, -24, 0, 22),
			ZIndex = 54,
		}, card)
		make("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6),
		}, holder)
		for _, opt in ipairs(TYPING_OPTIONS) do
			local b = make("TextButton", {
				AutoButtonColor = false,
				BackgroundColor3 = C.off,
				Font = Enum.Font.GothamBold,
				Text = opt,
				TextSize = 11,
				TextColor3 = C.muted,
				Size = UDim2.new(1 / 3, -4, 1, 0),
				ZIndex = 55,
			}, holder)
			corner(b, 6)
			local function paint()
				local sel = config.typingMode == opt
				b.BackgroundColor3 = sel and C.accent or C.off
				b.TextColor3 = sel and C.bg or C.muted
			end
			paint()
			b.MouseButton1Click:Connect(function()
				setConfig("typingMode", opt)
				for _, ch in ipairs(holder:GetChildren()) do
					if ch:IsA("TextButton") then
						local sel = ch.Text == config.typingMode
						ch.BackgroundColor3 = sel and C.accent or C.off
						ch.TextColor3 = sel and C.bg or C.muted
					end
				end
			end)
		end
	end

	addToggle(typePage, "2 Word Check", "Redeem at 2nd msg, retry if invalid", function()
		return config.twoWordCheck
	end, function(v) setConfig("twoWordCheck", v) end)

	addToggle(typePage, "Wait If Invalid", "Keep code + next message", function()
		return config.waitInvalid
	end, function(v) setConfig("waitInvalid", v) end)

	addToggle(typePage, "Hold On Wait", "Pause on WAIT/GUYS, resume on CODE IS", function()
		return config.holdOnWait
	end, function(v)
		setConfig("holdOnWait", v)
		runtime.held = false
	end)

	-- ===== LOGS =====
	orderCounter = 0
	local logsPage = makePage("Logs")
	local logPush = addConsole(logsPage, "Activity", 280)
	ui.log = function(message, kind)
		if destroyed or not logPush then return end
		local col = C.muted
		if kind == "ok" then col = C.green
		elseif kind == "err" then col = C.red
		elseif kind == "wait" then col = C.amber
		elseif kind == "busy" then col = Color3.fromRGB(140, 180, 230)
		end
		logPush(string.format("[%s] %s", os.date("%H:%M:%S"), tostring(message)), col)
	end

	-- ===== MORE =====
	orderCounter = 0
	local morePage = makePage("More")

	addToggle(morePage, "Optimize FPS", "Lower graphics / effects", function()
		return config.optimize
	end, function(v)
		setOptimize(v)
		setConfig("optimize", v)
	end)

	addToggle(morePage, "Block Events", "Disable game event handlers", function()
		return config.blockEvents
	end, function(v)
		local ok, reason = setBlockEvents(v)
		if not ok then
			log("Block failed: " .. tostring(reason), "err")
			return
		end
		setConfig("blockEvents", v)
	end)

	addToggle(morePage, "Animations", "Smooth UI transitions", function()
		return config.animations
	end, function(v) setConfig("animations", v) end)

	local flagCard = addCard(morePage, 108)
	addLabel(flagCard, "Flag Check", 6, 12, C.text)
	make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.muted,
		Text = "Not flagged if: 5+ rebirths, account 1mo+, no warnings",
		Position = UDim2.fromOffset(12, 24), Size = UDim2.new(1, -24, 0, 26),
		TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 54,
	}, flagCard)
	local flagBtn = make("TextButton", {
		AutoButtonColor = false, BackgroundColor3 = C.off, Font = Enum.Font.GothamBold,
		Text = "Run Flag Check", TextSize = 11, TextColor3 = C.text,
		Size = UDim2.new(1, -24, 0, 28), Position = UDim2.fromOffset(12, 54), ZIndex = 54,
	}, flagCard)
	corner(flagBtn, 7)
	local flagResult = make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "Result: -",
		TextSize = 12, TextColor3 = C.muted, Position = UDim2.fromOffset(12, 86),
		Size = UDim2.new(1, -24, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 54,
	}, flagCard)

	flagBtn.MouseButton1Click:Connect(function()
		if flagCheck.running or destroyed then return end
		flagCheck.running = true
		flagBtn.Text = "Checking..."
		flagResult.Text = "Waiting..."
		flagResult.TextColor3 = C.amber
		task.spawn(function()
			local before = flagSnapshot()
			local startedAt = os.clock()
			task.spawn(function() pcall(redeemClassic, FLAG.code, true) end)
			local feedback, elapsed = nil, 0
			local deadline = startedAt + FLAG.timeout
			while os.clock() < deadline and not destroyed do
				elapsed = os.clock() - startedAt
				if elapsed >= FLAG.minWait then
					feedback = flagFindNew(before)
					if feedback then
						elapsed = os.clock() - startedAt
						break
					end
				end
				task.wait(FLAG.poll)
			end
			flagCheck.running = false
			flagBtn.Text = "Run Flag Check"
			if not feedback then
				flagResult.Text = "No reply"
				flagResult.TextColor3 = C.amber
				log("Flag: no reply", "err")
				return
			end
			if elapsed < FLAG.limit then
				flagResult.Text = string.format("Not Flagged (%.2fs)", elapsed)
				flagResult.TextColor3 = C.green
				log(string.format("Flag: Not Flagged (%.2fs)", elapsed), "ok")
			else
				flagResult.Text = string.format("Flagged (%.2fs)", elapsed)
				flagResult.TextColor3 = C.red
				log(string.format("Flag: Flagged (%.2fs)", elapsed), "err")
			end
		end)
	end)

	make("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.muted,
		Text = "Options & positions auto-save\ngetgenv().GROQ_API_KEY for AI",
		Size = UDim2.new(1, 0, 0, 34), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = nextOrder(), ZIndex = 53,
	}, morePage)

	-- Panel open/close — opens centered; can be dragged only if unlocked
	local function saveMenuPos()
		-- save exact UDim2 (scale+offset) so restore matches 1:1
		local pos = menuBtn.Position
		config.menuSX = pos.X.Scale
		config.menuSY = pos.Y.Scale
		config.menuOX = pos.X.Offset
		config.menuOY = pos.Y.Offset
		saveConfig(true)
	end

	local function savePanelPos()
		local pos = panel.Position
		config.panelSX = pos.X.Scale
		config.panelSY = pos.Y.Scale
		config.panelOX = pos.X.Offset
		config.panelOY = pos.Y.Offset
		saveConfig(true)
	end

	local function applySavedPanelPos()
		if type(config.panelSX) == "number" and type(config.panelOX) == "number" then
			panel.Position = UDim2.new(
				config.panelSX, config.panelOX,
				config.panelSY or 0.5, config.panelOY or 0
			)
		else
			panel.Position = UDim2.fromScale(0.5, 0.5)
		end
	end

	function setPanel(open)
		panelOpen = open
		if open then
			-- always restore last position (even after X close)
			applySavedPanelPos()
			panel.Visible = true
			panelScale.Scale = 0.88
			panel.BackgroundTransparency = 1
			bgImg.ImageTransparency = 1
			shade.BackgroundTransparency = 1
			tw(panelScale, { Scale = 1 }, POP)
			tw(panel, { BackgroundTransparency = 0.12 }, SMOOTH)
			tw(bgImg, { ImageTransparency = 0.28 }, SMOOTH)
			tw(shade, { BackgroundTransparency = 0.55 }, SMOOTH)
			tw(panelStroke, { Transparency = 0.18 }, FAST)
			tw(menuStroke, { Transparency = 0.1, Color = C.accent }, FAST)
			btnLabel.Text = "CLOSE"
			local sc = menuBtn:FindFirstChild("BtnScale") or make("UIScale", { Name = "BtnScale", Scale = 1 }, menuBtn)
			sc.Scale = 0.94
			tw(sc, { Scale = 1 }, POP)
		else
			-- save current position before hiding
			savePanelPos()
			saveMenuPos()
			tw(panelScale, { Scale = 0.9 }, FAST)
			tw(panel, { BackgroundTransparency = 1 }, FAST)
			tw(bgImg, { ImageTransparency = 1 }, FAST)
			tw(shade, { BackgroundTransparency = 1 }, FAST)
			tw(menuStroke, { Transparency = 0.3, Color = Color3.fromRGB(200, 200, 210) }, FAST)
			btnLabel.Text = "OR'S"
			task.delay(0.2, function()
				if not panelOpen then panel.Visible = false end
			end)
		end
	end

	menuBtn.MouseButton1Click:Connect(function()
		setPanel(not panelOpen)
	end)
	closeX.MouseButton1Click:Connect(function() setPanel(false) end)

	-- Drag menu button only when UNLOCKED + save position
	do
		local dragging, dragStart, startPos, moved
		menuBtn.InputBegan:Connect(function(input)
			if not isPress(input) then return end
			if config.panelLocked then return end -- locked: cannot move menu button
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = menuBtn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					if dragging and moved then
						saveMenuPos()
					end
					dragging = false
				end
			end)
		end)
		table.insert(globalConnections, UserInputService.InputChanged:Connect(function(input)
			if not dragging or config.panelLocked then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local d = input.Position - dragStart
				if math.abs(d.X) > 2 or math.abs(d.Y) > 2 then moved = true end
				menuBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end))
	end

	-- Drag panel only when UNLOCKED + save position
	do
		local dragging, dragStart, startPos, moved
		header.InputBegan:Connect(function(input)
			if not isPress(input) then return end
			if config.panelLocked then return end
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = panel.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					if dragging and moved then
						savePanelPos()
					end
					dragging = false
				end
			end)
		end)
		table.insert(globalConnections, UserInputService.InputChanged:Connect(function(input)
			if not dragging or config.panelLocked then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local d = input.Position - dragStart
				if math.abs(d.X) > 2 or math.abs(d.Y) > 2 then moved = true end
				panel.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + d.X,
					startPos.Y.Scale, startPos.Y.Offset + d.Y
				)
			end
		end))
	end

	-- Keybind
	table.insert(globalConnections, UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == config.menuKey then
			setPanel(not panelOpen)
		end
	end))

	showTab("Main")

	task.spawn(function() pcall(startListener) end)
	if config.riddlerListen then
		task.defer(startRiddleListen)
	end
	if config.optimize then task.defer(function() pcall(setOptimize, true) end) end
	if config.blockEvents then
		task.defer(function()
			task.wait(1.5)
			local ok, reason = setBlockEvents(true)
			if not ok then
				config.blockEvents = false
				log("Block Events failed: " .. tostring(reason), "err")
			end
		end)
	end

	task.spawn(function() pcall(getSabContext) end)

	log("OR'S SNIPER v" .. VERSION .. " loaded", "ok")
	local env = getgenv and getgenv() or _G
	env.StopOrsSniper = OrsSniper.destroy
	env.OrsSolveRiddle = handleRiddleText
end

function OrsSniper.destroy()
	if destroyed then return end
	destroyed = true
	writeConfig()
	runtime.scanning = false
	stopRiddleListen()
	if runtime.notifConn then pcall(function() runtime.notifConn:Disconnect() end) end
	pcall(setBlockEvents, false)
	pcall(setOptimize, false)
	for _, c in ipairs(globalConnections) do pcall(function() c:Disconnect() end) end
	if screenGui then screenGui:Destroy() end
	local env = getgenv and getgenv() or _G
	if env.StopOrsSniper == OrsSniper.destroy then env.StopOrsSniper = nil end
end

local ok, err = xpcall(initialize, function(e)
	return debug.traceback(tostring(e))
end)
if not ok then
	warn("[OR'S SNIPER] init failed: " .. tostring(err))
	pcall(OrsSniper.destroy)
end