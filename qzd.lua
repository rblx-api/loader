local print, warn = function() end, function() end
if not game:IsLoaded() then game.Loaded:Wait() end

-- Block duplicates only inside the current DataModel. Executor globals may
-- survive a server rejoin, but connections from the previous game do not.
local __tekMainSameGame = (_G.TekMainLoadedGame == game)
    and (_G.TekMainLoadedWorkspace == workspace)
if _G.TekMainInstanceLoaded and __tekMainSameGame then return end
_G.TekMainInstanceLoaded = true
_G.TekMainLoadedGame = game
_G.TekMainLoadedWorkspace = workspace

local _gameLoadAt = os.clock()

_G.TekInvisAuto = _G.TekInvisAuto == true
_G.TekAutoKickOnSteal, _G.TekAutoBuy = false, false
_G.TekStealMode = _G.TekStealMode or "priority"
_G.TekAutoTP = (_G.TekAutoTP == nil) and true or _G.TekAutoTP

local _profOut = { "TekPanelScanGap", "TekRepickGap", "TekInRangeGap", "TekWatchdogTick", "TekSyncScanGap", "TekAutoTPPoll" }
local _profSfx = { "PanelGap", "RepickGap", "InRangeGap", "WatchdogTick", "SyncGap", "TPPoll" }
_G.TekScanProfile = function(mode)
    local boost = (mode == "fast")
    local tag = boost and "TekFast" or "TekNorm"
    local fb = boost and { 0.3, 0.3, 0.3, 0.3, 0.3, 0.3 } or { 0.3, 0.3, 0.3, 0.3, 0.3, 0.3 }
    _G.TekScanMode = boost and "fast" or "normal"
    for i = 1, 6 do
        _G[_profOut[i]] = tonumber(_G[tag .. _profSfx[i]]) or fb[i]
    end
end
_G.TekScanProfile("fast")
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(tonumber(_G.TekFastWindow) or 60)
    if _G.TekScanMode == "fast" then _G.TekScanProfile("normal") end
end)
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(tonumber(_G.TekFpsCapDelay) or 1.5)
    pcall(function() if setfpscap then setfpscap(9999) end end)
end)


task.spawn(function()
    local ws = game:GetService("Workspace")
    if not ws.StreamingEnabled then return end
    local hb = game:GetService("RunService")
    local me = game:GetService("Players").LocalPlayer
    local area, limit = nil, os.clock() + 15
    repeat
        area = ws:FindFirstChild("Plots")
        if not area then hb.Heartbeat:Wait() end
    until area or os.clock() > limit
    if not area then return end
    local function pivotOf(plot)
        local ok, pv = pcall(function() return plot:GetPivot().Position end)
        if ok and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    local left = 0
    for _, plot in ipairs(area:GetChildren()) do
        local where = pivotOf(plot)
        if where then
            left = left + 1
            task.spawn(function()
                pcall(function() me:RequestStreamAroundAsync(where) end)
                left = left - 1
            end)
        end
    end
    local stopAt = os.clock() + 3
    while left > 0 and os.clock() < stopAt do task.wait(0.03) end
end)

_G.TekBootDelay = tonumber(_G.TekBootDelay) or 0.3
if _G.TekWaitForTools == nil then _G.TekWaitForTools = true end
_G.TekToolWait = tonumber(_G.TekToolWait) or 6
do
    local _since = os.clock()
    local _gear = {
        "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings",
        "Grapple Hook",
    }
    local _has = {}
    for _, n in ipairs(_gear) do _has[n] = true end
    local function _inBox(box, want)
        if not box then return false end
        for _, t in ipairs(box:GetChildren()) do
            if t:IsA("Tool") and (t.Name == want or _has[t.Name]) then return true end
        end
        return false
    end
    local function _gearReady()
        local plr = game:GetService("Players").LocalPlayer
        if not plr then return false end
        local want = (type(_G.TekCarpetTool) == "string" and _G.TekCarpetTool ~= "")
            and _G.TekCarpetTool or nil
        return _inBox(plr.Character, want) or _inBox(plr:FindFirstChild("Backpack"), want)
    end
    _G.TekToolsReady = _gearReady
    _G.TekBootWait = function()
        local d = tonumber(_G.TekBootDelay) or 0.3
        local cap = tonumber(_G.TekToolWait) or 6
        local want = (_G.TekWaitForTools ~= false)
        local t0 = os.clock()
        while true do
            local ready = true
            if want then
                local ok, r = pcall(_gearReady)
                ready = (ok and r) and true or false
            end
            if ready and (os.clock() - _since) >= d then return end
            if os.clock() - t0 >= cap then return end
            task.wait(tonumber(_G.TekBootPoll) or 0.03)
        end
    end
end

_G.TekPriVersion = _G.TekPriVersion or 0
if type(_G.TekPriorityDefault) ~= "table" then _G.TekPriorityDefault = {} end
if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
if type(_G.SHARED_MUTATION_PRIORITY) ~= "table" then _G.SHARED_MUTATION_PRIORITY = {} end
if type(_G.SHARED_TRAIT_PRIORITY) ~= "table" then _G.SHARED_TRAIT_PRIORITY = {} end
if type(_G.SHARED_MUTATION_DISABLED) ~= "table" then _G.SHARED_MUTATION_DISABLED = {} end

if LPH_OBFUSCATED == nil then
    local env = getfenv()
    env["LPH_NO_" .. "VIRTUALIZE"] = function(...) return ... end
    env["LPH_JIT_" .. "MAX"]       = function(...) return ... end
end

do
    local _HS = game:GetService("HttpService")
    local _TS = game:GetService("TeleportService")
    _G.TEK_DEFAULT_CONFIG_JSON = [==[{"mutationList":["Bloodrot","Candy","Crystal","Cursed","Cyber","Diamond","Divine","Galaxy","Gold","Lava","Phantom","Radioactive","Rainbow","YinYang"],"traitList":["1 Year","10B","26",":3","Algeria","Argentina","Aura Shades","Australia","Austria","Ball","Bee","Belgium","Blue Balloon","Blue Egg","Bosnia and Herzegovina","Brazil","Bubblegum","Bull","Bunny Ears","Burger","Canada","Cape Verde","Chocolate","Claws","Colombia","Cometstruck","Croatia","Curacao","Czechia","DR Congo","Disco","Ecuador","Egypt","England","Explosive","Fire","Fire Bee","Fireworks","France","Galactic","Germany","Ghana","Glitched","Granny","Green Balloon","Green Egg","Haiti","Halo","Ice Bee","Indonesia","Iran","Iraq","Ivory Coast","Jackolantern Pet","Japan","Job Application","John Pork","Jordan","Lightning","Lucky","Matteo Hat","Meowl","Mexico","Morocco","Netherlands","New Zealand","Norway","Nyan","Orange Balloon","Orange Egg","Paint","Panama","Paraguay","Pink Balloon","Pink Egg","Portugal","Qatar","Queen Bee","RIP Gravestone","Rainbow Balloon","Red Balloon","Reindeer Pet","Rose","Santa Hat","Saudi Arabia","Scotland","Senegal","Shark Fin","Skeleton","Skibidi","Sleepy","Snowy","Sombrero","South Africa","South Korea","Spain","Spider","Strawberry","Sun","Sweden","Switzerland","Taco","Tie","Tunisia","Turkey","UFO","United States","Uruguay","Uzbekistan","Wet","Witch Hat","Zombie"],"alertSound":"111786441593851","stealLead":0.07,"exX":1977,"landingDelay":0.15000000000000003,"infJump":true,"invisAngle":216,"xray":true,"goSpeed":220,"faceAway":false,"antiBee":true,"cframeSpeed":450,"stealFireKey":"LeftAlt","autoKickOnSteal":false,"invisDepth":10,"cloneKey":"V","autoBuyRange":17,"antiFlash":true,"autoBuyHover":9,"resetKey":"X","closeSpeed":300,"walkSpeedOn":false,"stealMode":"priority","dropKey":"G","priAlert":false,"nearestKey":"F","faceAwayNearest":false,"exY":355,"autoSteal":true,"priorityList":["Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl","Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio","Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros","Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal","Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino","Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros","Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero","Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers","Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro","Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch","Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon","Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah","Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos","Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso","Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas","Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros","Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion","Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande","Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta","Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti","Los Bros","Gobblino Uniciciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis","Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande","Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67","Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito","Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy","Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni","Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda","Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion","Esok Sekolah"],"walkSpeed":29,"grabBeforeKick":true,"carpetStrict":true,"autoBuy":false,"psLink":"","antiDie":true,"carpetSpeedValue":140,"alertMinGen":80000000,"tpVelocity":550,"panelY":457,"invisAuto":true,"autoTp":true,"kickToPS":false,"faceAwayDelay":2,"climbSpeed":100,"carpetTool":"Waverider","carpetSpeedKey":"Q","stealQuickKey":"C","panelX":1068}]==]
    local DEFAULT_CONFIG
    pcall(function() DEFAULT_CONFIG = _HS:JSONDecode(_G.TEK_DEFAULT_CONFIG_JSON) end)
    local fileData, tpData
    if readfile then
        pcall(function()
            local raw = readfile("SideTP.json")
            if type(raw) == "string" and #raw > 0 then fileData = _HS:JSONDecode(raw) end
        end)
    end
    pcall(function()
        local td = _TS:GetLocalPlayerTeleportData()
        if td and td.SideTP then tpData = td.SideTP end
    end)
    local merged = {}
    if type(DEFAULT_CONFIG) == "table" then for k, v in pairs(DEFAULT_CONFIG) do merged[k] = v end end
    if type(tpData) == "table" then for k, v in pairs(tpData) do merged[k] = v end end
    if type(fileData) == "table" then for k, v in pairs(fileData) do merged[k] = v end end

    if type(merged.tpDelay) == "number" then _G._stp_tpDelay = merged.tpDelay end
    _G._stp_tpDelay = 0  -- AI patch: force TP delay to 0
    if type(merged.tpVelocity) == "number" then _G.TPVelocity = math.clamp(merged.tpVelocity, 200, 750) end
    if type(merged.climbSpeed) == "number" then _G.TekClimb = math.clamp(merged.climbSpeed, 100, 250) end
    if type(merged.cframeSpeed) == "number" then _G.TekCFrameSpeed = math.clamp(merged.cframeSpeed, 100, 900) end
    if type(merged.cframeTP) == "boolean" then _G.TekCFrameTP = merged.cframeTP end
    if type(merged.tweenTP) == "boolean" then _G.TekTweenTP = merged.tweenTP end
    if type(merged.flingTp) == "boolean" then _G.TekFlingTP = merged.flingTp end
    if type(merged.tweenNear) == "number" then _G.TekTweenNear = math.clamp(merged.tweenNear, 20, 60) end
    if type(merged.tweenStage) == "number" then _G.TekTweenStage = math.clamp(merged.tweenStage, 3, 40) end
    if type(merged.flashTP) == "boolean" then _G.TekFlashTP = merged.flashTP end
    if type(merged.flashFire) == "number" then _G.TekFlashGroundWait = math.clamp(merged.flashFire, 0, 0.25) end
    if type(merged.flashEquip) == "number" then _G.TekFlashPreEquip = math.clamp(merged.flashEquip, 0, 60) end
    if type(merged.cframeStart) == "number" then _G.TekCFrameStart = merged.cframeStart end
    if type(merged.cframeEnd) == "number" then _G.TekCFrameEnd = merged.cframeEnd end
    if type(merged.walkSpeed) == "number" then _G.TekWalkSpeed = math.clamp(merged.walkSpeed, 16, 29) end
    if type(merged.carpetTool) == "string" then _G.TekCarpetTool = merged.carpetTool end
    if type(merged.landingDelay) == "number" then _G.LandingDelay = math.clamp(merged.landingDelay, 0.01, 1.0) end
    if type(merged.closeSpeed) == "number" then _G.TekCloseSpeed = math.clamp(merged.closeSpeed, 20, 400) end
    if type(merged.preCloneSpeed) == "number" then _G.TekPreCloneSpeed = math.clamp(merged.preCloneSpeed, 40, 250) end
    if type(merged.problemBaseSpeed) == "number" then _G.TekProblemBaseSpeed = math.clamp(merged.problemBaseSpeed, 20, 400) end
    if type(merged.slowCrossRow) == "boolean" then _G.TekSlowCrossRow = merged.slowCrossRow end
    if type(merged.stealLead) == "number" then _G.TekStealLead = math.clamp(merged.stealLead, 0, 2) end
    if type(merged.autoGrabRadius) == "number" then _G.TekAutoGrabRadius = math.clamp(merged.autoGrabRadius, 10, 150) end
    _G.TekStealQuick = false
    if type(merged.stealQuickKey) == "string" then _G.TekStealQuickKey = merged.stealQuickKey end
    if type(merged.stealFireKey) == "string" then _G.TekStealFireKey = merged.stealFireKey end
    if type(merged.tpKey) == "string" then _G._stp_tpKeyName = merged.tpKey end
    if type(merged.nearestKey) == "string" then _G.TekNearestKey = merged.nearestKey end
    if type(merged.prioritySoundID) == "string" then _G.TekPrioritySoundID = merged.prioritySoundID end
    _G.TekStealMode = "priority"
    _G._stealUserOff = false
    if type(merged.priorityList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.priorityList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_PRIORITY_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.TekPriVersion = _G.TekPriVersion + 1
        end
    end
    -- Add Gorillo Subwoofero to Priority without forcing its position.
    -- A position already saved in SideTP.json is preserved.
    do
        local wanted = "Gorillo Subwoofero"
        local wantedKey = wanted:lower():gsub("[%s%-_'%.]", "")
        local L = _G.SHARED_PRIORITY_ITEMS
        local found = false
        for i = 1, #L do
            if tostring(L[i]):lower():gsub("[%s%-_'%.]", "") == wantedKey then
                found = true
                break
            end
        end
        if not found then
            table.insert(L, wanted)
            _G.TekPriVersion = _G.TekPriVersion + 1
        end
    end
    if type(merged.priorityDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.priorityDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.TekPriorityDefault = d end
    end
    if type(merged.mutationList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.mutationList) do
            if type(v) == "string" and v ~= "" then
                local canonical = v:lower():gsub("[%s%-_]", "") == "yinyang" and "Yin Yang" or v
                clean[#clean + 1] = canonical
            end
        end
        if #clean > 0 then
            local L = _G.SHARED_MUTATION_PRIORITY
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
        end
    end
    if type(merged.mutationDisabled) == "table" then
        local D = _G.SHARED_MUTATION_DISABLED
        table.clear(D)
        for _, v in ipairs(merged.mutationDisabled) do
            if type(v) == "string" and v ~= "" then
                local canonical = v:lower():gsub("[%s%-_]", "") == "yinyang" and "Yin Yang" or v
                D[canonical] = true
            end
        end
    end
    if type(merged.traitList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.traitList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_TRAIT_PRIORITY
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
        end
    end
    if type(merged.invisAuto) == "boolean" then _G.TekInvisAuto = merged.invisAuto end
    if type(merged.invisDepth) == "number" then _G.TekInvisDepth = math.clamp(merged.invisDepth, 0.5, 10) end
    if type(merged.invisAngle) == "number" then _G.TekInvisAngle = math.clamp(merged.invisAngle, 0, 360) end
    if _G.SinkSliderValue == nil then _G.SinkSliderValue = _G.TekInvisDepth end
    if _G.InvisStealAngle == nil then _G.InvisStealAngle = _G.TekInvisAngle end
    if type(merged.autoTp) == "boolean" then _G.TekAutoTP = merged.autoTp end
    if type(merged.autoBuy) == "boolean" then _G.TekAutoBuy = merged.autoBuy end
    if type(merged.autoBuyRange) == "number" then _G.TekAutoBuyRange = math.clamp(merged.autoBuyRange, 5, 40) end
    if type(merged.autoBuyHover) == "number" then _G.TekAutoBuyHover = math.clamp(merged.autoBuyHover, 0, 20) end
    if type(merged.panelX) == "number" then _G._stp_panelX = merged.panelX end
    if type(merged.panelY) == "number" then _G._stp_panelY = merged.panelY end
    if type(merged.panelPos) == "table" then _G._stp_pos = merged.panelPos end
    if type(merged.autoKickOnSteal) == "boolean" then _G.TekAutoKickOnSteal     = merged.autoKickOnSteal end
    if type(merged.resetKey)        == "string"  then _G.TekResetKeyName        = merged.resetKey end
    if type(merged.cloneKey)        == "string"  then _G.TekCloneKeyName        = merged.cloneKey end
    if type(merged.carpetSpeedKey)  == "string"  then _G.TekCarpetSpeedKeyName  = merged.carpetSpeedKey end
    if type(merged.kickKey)         == "string"  then _G.TekKickKeyName         = merged.kickKey end
    if type(merged.stopTpKey)       == "string"  then _G.TekStopTPKeyName       = merged.stopTpKey end
    if type(merged.dropKey)         == "string"  then _G.TekDropKeyName         = merged.dropKey end
    if type(merged.goSpeed)      == "number"  then _G.TekGoSpeed            = math.clamp(merged.goSpeed, 80, 600) end
    if type(merged.kickToPS)     == "boolean" then _G.TekKickToPS           = merged.kickToPS end
    if type(merged.psLink)       == "string"  then _G.TekPrivateServerLink  = merged.psLink end
    if type(merged.priAlert)     == "boolean" then _G.TekPriAlert           = merged.priAlert end
    if type(merged.alertSound)   == "string"  then _G.TekAlertSound         = merged.alertSound end
    if type(merged.alertMinGen)  == "number"  then _G.TekAlertMinGen        = merged.alertMinGen end
    if type(merged.walkSpeedOn)  == "boolean" then _G.TekWalkSpeedOn        = merged.walkSpeedOn end
    if type(merged.xray)         == "boolean" then _G.TekXray               = merged.xray end
    if type(merged.antiFlash)    == "boolean" then _G.TekAntiFlash          = merged.antiFlash end
    if type(merged.faceAway)        == "boolean" then _G.TekFaceAway        = merged.faceAway end
    if type(merged.faceAwayNearest) == "boolean" then _G.TekFaceAwayNearest = merged.faceAwayNearest end
    if type(merged.faceAwayDelay)   == "number"  then _G.TekFaceAwayDelay   = merged.faceAwayDelay end
    if type(merged.antiBee)      == "boolean" then _G.TekAntiBee            = merged.antiBee end
    if type(merged.infJump)      == "boolean" then _G.TekInfJump            = merged.infJump end
    _G.AntiDieDisabled = false -- Tek Anti-Die is always on (saved antiDie setting ignored)
    if type(merged.carpetSpeedValue) == "number" then _G.TekCarpetSpeedValue = merged.carpetSpeedValue end
    if type(merged.exX) == "number" then _G._tek_exX = merged.exX end
    if type(merged.exY) == "number" then _G._tek_exY = merged.exY end
    if type(merged.fX)  == "number" then _G._tek_fX  = merged.fX  end
    if type(merged.fY)  == "number" then _G._tek_fY  = merged.fY  end
    if type(merged.kX)  == "number" then _G._tek_kX  = merged.kX  end
    if type(merged.kY)  == "number" then _G._tek_kY  = merged.kY  end
    if type(merged.tgtX) == "number" then _G._tek_tgtX = merged.tgtX end
    if type(merged.tgtY) == "number" then _G._tek_tgtY = merged.tgtY end
    if type(merged.modeX) == "number" then _G._tek_modeX = merged.modeX end
    if type(merged.modeY) == "number" then _G._tek_modeY = merged.modeY end
    if type(merged.tgtW) == "number" then _G._tek_tgtW = merged.tgtW end
    if type(merged.tgtH) == "number" then _G._tek_tgtH = merged.tgtH end
    if type(merged.modeW) == "number" then _G._tek_modeW = merged.modeW end
    if type(merged.modeH) == "number" then _G._tek_modeH = merged.modeH end

    _G.TekAutoTP = true
    if writefile then
        pcall(function()
            local t = type(fileData) == "table" and fileData or {}
            t.autoTp = true
            writefile("SideTP.json", _HS:JSONEncode(t))
        end)
    end
end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")
local VIM        = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer


if _G.TekNoZeroVel == nil then _G.TekNoZeroVel = false end
function _vzOK()
    if _G.TekNoZeroVel == true then return false end
    if _G.TekZeroWhileStealing ~= true and LP:GetAttribute("Stealing") == true then return false end
    return true
end
function _vzL(p)
    if p and _vzOK() then
        p.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end
function _vzA(p)
    if p and _vzOK() then
        p.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

_BLOCKING_MACHINE_TYPES = {
    Fuse     = true,
    Duel     = true,
    Trade    = true,
    Crafting = true,
}
function _TekIsFusing(animalData)
    if type(animalData) ~= "table" then return false end
    local m = animalData.Machine
    if type(m) ~= "table" then return false end
    return _BLOCKING_MACHINE_TYPES[m.Type] == true
end

do


local RS  = game:GetService("ReplicatedStorage")
local RUN = game:GetService("RunService")


local _netFolder
local function _netDir()
    if _netFolder then return _netFolder end
    local pk = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
    if not pk then return nil end
    _netFolder = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
    return _netFolder
end
local _net
local function _getNet()
    if _net then return _net end
    local dir = _netDir()
    if not dir then return nil end
    local ok, m = pcall(require, dir)
    if ok and type(m) == "table" then _net = m end
    return _net
end
local _queue, _hooked, _original = {}, false, nil
local function _host()
    for _, sig in ipairs({ RUN.Heartbeat, RUN.RenderStepped, RUN.PostSimulation }) do
        local ok, conns = pcall(getconnections, sig)
        if ok then
            for _, c in ipairs(conns) do
                local f = c.Function
                if f and f ~= _G.__mkSyncHost and islclosure(f) and not isexecutorclosure(f) then
                    local s = select(2, pcall(debug.info, f, "s"))
                    if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                        return f
                    end
                end
            end
        end
    end
end
local function _install()
    if _hooked then return true end
    if not _getNet() then return false end
    local h = _host()
    if not h then return false end
    _G.__mkNetHost = h
    local w = function(...)
        local job = table.remove(_queue, 1)
        if job then
            local ok, r = pcall(_net[job.kind], _net, job.name)
            job.result = (ok and typeof(r) == "Instance") and r or nil
            job.done = true
        end
        return _original(...)
    end
    local ok, env = pcall(getfenv, h)
    if ok and type(env) == "table" then pcall(setfenv, w, env) end
    _original = hookfunction(h, w)
    _hooked = true
    return true
end
local _cache = {}
local function _get(name, kind)
    kind = (kind == "RemoteFunction" and "RemoteFunction")
        or (kind == "UnreliableRemoteEvent" and "UnreliableRemoteEvent")
        or "RemoteEvent"
    if type(name) ~= "string" or name == "" then return nil end
    local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
    local ck = kind .. "|" .. logical
    local hit = _cache[ck]
    if hit and hit.Parent then return hit end
    _cache[ck] = nil
    if not _getNet() then return nil end
    if not _install() then return nil end
    local job = { kind = kind, name = logical }
    table.insert(_queue, job)
    local t = os.clock() + (tonumber(_G.TekNetTimeout) or 5)
    while not job.done and os.clock() < t do RUN.Heartbeat:Wait() end
    if job.result and job.result.Parent then
        _cache[ck] = job.result
        return job.result
    end
    return nil
end
_G.TekNet = {
    RemoteEvent = function(_, name) return _get(name, "RemoteEvent") end,
    RemoteFunction = function(_, name) return _get(name, "RemoteFunction") end,
    UnreliableRemoteEvent = function(_, name) return _get(name, "UnreliableRemoteEvent") end,
}
_G.TekGetRemote = _get
_G.Resolve = _get
_G.__secureGetRemote = function(method, name) return _get(name, method) end
_G.TekNetHooked = function() return _hooked end
do
    local _dummy = Instance.new("RemoteEvent")
    local _rawFire = (clonefunction and clonefunction(_dummy.FireServer)) or _dummy.FireServer
    _G.RawFire = function(name, ...)
        local r = _get(name)
        if not r then return false end
        _rawFire(r, ...)
        return true
    end
end
end

do
local _xchan
local _lastTry, _attempts = 0, 0
local _deepScans, _lastDeep = 0, 0
local _mod

local MAX_ATTEMPTS, RETRY_GAP = 40, 0.5
local BOOT_T0, BOOT_BURST, BOOT_GAP = os.clock(), 3.0, 0.10
local MAX_DEEP, DEEP_GAP = 3, 1.5
local _bootDone = false
local _bootGrace = 4.0

local RS_SYNC = game:GetService("ReplicatedStorage")
local _mask_sc
local function _getMask()
    if _mask_sc and _mask_sc.Parent then return _mask_sc end
    local c = RS_SYNC:FindFirstChild("Controllers")
    _mask_sc = c and c:FindFirstChild("PlotController")
    return _mask_sc
end
local secure_call = _G.secure_call
if type(secure_call) ~= "function" then


    local RUN = game:GetService("RunService")
    local state = { ready = false, inside = false }
    local conn, original
    local function host()
        for _, sig in ipairs({ RUN.Heartbeat, RUN.RenderStepped, RUN.PostSimulation }) do
            local ok, conns = pcall(getconnections, sig)
            if ok then
                for _, c in ipairs(conns) do
                    local f = c.Function
                    if f and f ~= _G.__mkNetHost and islclosure(f) and not isexecutorclosure(f) then
                        local s = select(2, pcall(debug.info, f, "s"))
                        if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                            return f, c, s
                        end
                    end
                end
            end
        end
    end
    local function install()
        if state.ready then return true end
        local h, c, src = host()
        if not h then return false end
        local chunk = loadstring([[
            local state, pack, unpack = ...
            return function(...)
                local job = state.job
                if job and not job.done then
                    job.done = true
                    state.inside = true
                    job.result = pack(pcall(job.fn, unpack(job.args, 1, job.args.n)))
                    state.inside = false
                end
                return state.original(...)
            end
        ]], "=" .. src)
        if not chunk then return false end
        local ok, env = pcall(getfenv, h)
        if ok and type(env) == "table" then pcall(setfenv, chunk, env) end
        local wrapper = chunk(state, table.pack, table.unpack)
        _G.__mkSyncHost = h
        original = hookfunction(h, wrapper)
        state.original = original
        conn = c
        state.ready = true
        return true
    end
    secure_call = function(fn, ...)
        if type(fn) ~= "function" then return nil end
        if state.inside then return fn(...) end
        if not install() then return nil end
        state.job = { fn = fn, args = table.pack(...), done = false }
        pcall(function() conn:Fire(0) end)
        local job = state.job
        state.job = nil
        if not job or not job.done or not job.result then return nil end
        if not job.result[1] then error(job.result[2], 2) end
        return table.unpack(job.result, 2, job.result.n)
    end
    _G.secure_call = secure_call
    _G.TekSyncHooked = function() return state.ready end
end
task.spawn(function()
    pcall(function()
        local sync = _getSyncMod()
        if sync and type(sync.GetAllChannels) == "function" then
            local mask = _getMask()
            if mask then pcall(secure_call, sync.GetAllChannels, mask) end
        end
    end)
end)
local _syncMod_sc, _nextTry_sc = nil, 0
local function _getSyncMod()
    if _syncMod_sc then return _syncMod_sc end
    local p = RS_SYNC:FindFirstChild("Packages")
    local m = p and p:FindFirstChild("Synchronizer")
    if not m then return nil end
    local ok, mod = pcall(require, m)
    if ok and type(mod) == "table" then _syncMod_sc = mod end
    return _syncMod_sc
end
_G.__secureChans = function()
    if os.clock() < _nextTry_sc then return _xchan end
    local sync = _getSyncMod()
    if not sync then _nextTry_sc = os.clock() + 0.1; return _xchan end
    if type(sync.GetAllChannels) ~= "function" then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local mask = _getMask()
    if not mask then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local ok, reg = pcall(secure_call, sync.GetAllChannels, mask)
    if ok and type(reg) == "table" then
        _xchan = reg; _nextTry_sc = os.clock() + 1.5
        _G.TekSyncDiag = "GetAllChannels (secure_call) - undetect/instant"
    else
        _nextTry_sc = os.clock() + 0.1
    end
    return _xchan
end

local function _retryGap()
    if (os.clock() - BOOT_T0) < BOOT_BURST then return BOOT_GAP end
    return RETRY_GAP
end

local function _channelCount(t)
    if type(t) ~= "table" then return 0 end
    local ok, hits = pcall(function()
        local h, n = 0, 0
        for _, v in next, t do
            n = n + 1
            if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                h = h + 1
            end
            
            if n >= 50 then break end
        end
        return h
    end)
    return (ok and hits) or 0
end

local function _module()
    if _mod then return _mod end
    local ok, m = pcall(function()
        return require(game:GetService("ReplicatedStorage").Packages.Synchronizer)
    end)
    if ok and type(m) == "table" then _mod = m; return _mod end
    local ok2, m2 = pcall(function()
        local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local sync = pkgs and pkgs:FindFirstChild("Synchronizer")
        if not sync then return nil end
        return require(sync)
    end)
    if ok2 and type(m2) == "table" then _mod = m2 end
    return _mod
end

local function _probe(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local cands = {
        { mod.Get, 10, 4, "Get/10/4" },
        { mod.GetAllChannels, 10, 1, "GetAll/10/1" },
        { mod.Wait, 10, 1, "Wait/10/1" },
    }
    for _, c in ipairs(cands) do
        if type(c[1]) == "function" then
            local o, u = pcall(gu, c[1], c[2])
            if o and type(u) == "table" then
                consider(rawget(u, c[3]), c[4])
                if bestN > 0 then return best, bestN, where end
            end
        end
    end
    for _, fn in ipairs({ mod.Get, mod.GetAllChannels, mod.Wait, mod.WaitAndCall, mod.GetTableFromChannel }) do
        if type(fn) == "function" then
            for i = 8, 12 do
                local o, u = pcall(gu, fn, i)
                if o and type(u) == "table" then
                    consider(u, "up" .. i)
                    for j = 1, 4 do consider(rawget(u, j), "up" .. i .. "/" .. j) end
                    if bestN > 0 then return best, bestN, where end
                end
            end
        end
    end
    local ok, up = pcall(gu, mod.Get, 9)
    if ok and type(up) == "table" then
        consider(rawget(up, 3), "Get/9/3")
        if bestN > 0 then return best, bestN, where end
        consider(up, "Get/9")
        if bestN > 0 then return best, bestN, where end
    end
    return best, bestN, where
end

local function _deepScan(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local _fnCount = 0
    for fname, fn in next, mod do
        if type(fn) == "function" then
            _fnCount = _fnCount + 1
            if _fnCount > 30 then break end
            for i = 1, 16 do
                local o, u = pcall(gu, fn, i)
                if not o then break end
                if type(u) == "table" then
                    consider(u, tostring(fname) .. "/" .. i)
                    for j = 1, 4 do
                        consider(rawget(u, j), tostring(fname) .. "/" .. i .. "/" .. j)
                    end
                end
            end
        end
    end
    return best, bestN, where
end

local _gcFound, _gcFoundN, _gcState = nil, 0, "idle"

local function _gcScanOnce()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    local live, names, nLive = {}, {}, 0
    for _, p in ipairs(plots:GetChildren()) do live[p.Name] = true; nLive = nLive + 1; names[nLive] = p.Name end
    if nLive == 0 then return end


    local function score(t)
        local hits, seen = 0, 0
        for k, v in next, t do
            seen = seen + 1
            if type(k) == "string" and live[k]
                and type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                hits = hits + 1
            end
            if seen >= 64 then break end
        end
        return hits
    end

    local best, bestN = nil, 0
    local hasFilter = type(filtergc) == "function"

    if hasFilter then
        local tries = {}
        if nLive >= 2 then tries[1] = { names[1], names[2], "CacheTable" } end
        tries[#tries + 1] = { names[1], "CacheTable" }
        if nLive >= 3 then tries[#tries + 1] = { names[2], names[3], "CacheTable" } end
        for _, keys in ipairs(tries) do
            local ok, res = pcall(filtergc, "table", { Keys = keys }, false)
            if ok and type(res) == "table" then
                for _, t in ipairs(res) do
                    if type(t) == "table" then
                        local n = score(t)
                        if n > bestN and n >= 2 then best, bestN = t, n end
                    end
                end
            end
            if bestN >= nLive then break end
        end
    end

    if bestN == 0 and type(getgc) == "function"
        and (not hasFilter or _G.TekAllowFullGc == true)
        and not (_G.TekIsTeleporting and _G.TekIsTeleporting())
        and (os.clock() - (_G.__gcFullAt or 0)) >= (tonumber(_G.TekFullGcGap) or 3.0)
        and (workspace.StreamingEnabled == false or os.clock() - _gameLoadAt >= 4.0) then
        _G.__gcFullAt = os.clock()
        pcall(function()
            local gc = getgc(true)
            local _gcLimit = math.min(#gc, 4000)
            for i = 1, _gcLimit do
                local t = gc[i]
                if type(t) == "table" then
                    local pk = 0
                    for k in next, t do
                        if type(k) == "string" and live[k] then pk = pk + 1; if pk >= 2 then break end end
                    end
                    if pk >= 2 then
                        local n = score(t)
                        if n > bestN and n >= 2 then best, bestN = t, n end
                    end
                    if bestN >= nLive then break end
                end
            end
        end)
    end
    if best and bestN > _gcFoundN then _gcFound, _gcFoundN = best, bestN end
end

local _gcLastScan = 0
local _gcRescans = 0
local _gcMiss, _gcLastPlots = 0, -1
local function _gcChans()
    if _gcFound then
        local _pl = workspace:FindFirstChild("Plots")
        local _nLive = _pl and #_pl:GetChildren() or 0
        if _G.TekSyncRescan == true and _gcFoundN < _nLive
            and _gcRescans < (tonumber(_G.TekSyncMaxRescan) or 20)
            and (os.clock() - _gcLastScan) >= (tonumber(_G.TekSyncRescanGap) or 3) then
            _gcLastScan = os.clock()
            _gcRescans = _gcRescans + 1
            _gcScanOnce()
        end
        return _gcFound, _gcFoundN, "gc/plot-key+CacheTable"
    end



    local _pl = workspace:FindFirstChild("Plots")
    local _n = _pl and #_pl:GetChildren() or 0
    if _n ~= _gcLastPlots then
        _gcLastPlots = _n


        _gcMiss = (_gcMiss > 2) and 2 or _gcMiss
        _gcLastScan = _gcLastScan - 0.05
    end

    local gap = tonumber(_G.TekSyncScanGap) or 0.2
    local back = math.min(_gcMiss * (tonumber(_G.TekSyncMissStep) or 0.15),
                          tonumber(_G.TekSyncMissMax) or 1)
    if os.clock() - _gcLastScan < (gap + back) then return nil, 0, nil end
    _gcLastScan = os.clock()
    _gcScanOnce()
    if _gcFound then
        _gcMiss = 0
        return _gcFound, _gcFoundN, "gc/plot-key+CacheTable"
    end


    if _n > 0 then _gcMiss = _gcMiss + 1 end
    return nil, 0, nil
end

local function _apiChans(mod)
    if type(mod) ~= "table" then return nil, 0, nil end
    local fn = rawget(mod, "GetAllChannels")
    if type(fn) ~= "function" then return nil, 0, nil end
    local function _accept(reg, tag)
        if type(reg) ~= "table" then return nil, 0, nil end
        local n = _channelCount(reg)
        if n > 0 then return reg, n, tag end
        return nil, 0, nil
    end


    if _G.TekAllowSecureSyncCall ~= false and type(secure_call) == "function" then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return secure_call(fn, mod) end
                return secure_call(fn)
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/secure_call(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    if _G.TekAllowRawSyncCall then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return fn(mod) end
                return fn()
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/RAW(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    return nil, 0, nil
end

local _xchan2, _nextTry2, _attempts2 = nil, 0, 0
local _xchan2Until = 0
local _nextApi = 0
local _chansLastScan = 0
local function _chans()
    if _xchan2 then
        local now = os.clock()
        if now < _xchan2Until then return _xchan2 end
        if _channelCount(_xchan2) > 0 then _xchan2Until = now + 2 return _xchan2 end
    end
    local now = os.clock()
    if now - _chansLastScan < 0.02 then return _xchan2 end
    if now < _nextTry2 then return _xchan2 end
    _chansLastScan = now
    _attempts2 = _attempts2 + 1

    local best, n, where
    if _G.TekAllowSecureSyncCall ~= false and os.clock() >= _nextApi then
        local mod = _getSyncMod()
        if mod then best, n, where = _apiChans(mod) end
        if not best or n == 0 then _nextApi = os.clock() + (tonumber(_G.TekSyncApiGap) or 0.5) end
    end

    if not best or n == 0 then best, n, where = _gcChans() end

    if (not best or n == 0) and _attempts2 <= 400 and _G.TekAllowUpvalueProbe then
        local mod = _getSyncMod()
        if mod then
            best, n, where = _probe(mod)
            local inBoot = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
            if (not best or n == 0) and (not inBoot) and os.clock() - _lastDeep > 2 then
                _lastDeep = os.clock()
                _deepScans = _deepScans + 1
                best, n, where = _deepScan(mod)
            end
        end
    end
    if best and n > 0 then
        _xchan2 = best
        _G.TekSyncDiag = string.format("%s - %d channels", tostring(where), n)
        return _xchan2
    end

    local inBoot2 = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
    _nextTry2 = os.clock() + (inBoot2 and 0.1 or ((_G.TekScanMode == "fast") and 0.03 or 0.1))
    return _xchan2
end
_G.__secureChans = _chans

_G.TekSyncAll=function()return _chans()end
_G.TekSyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
return nil
end
_G.sProp=function(ch,key)
if type(ch)~="table" or key==nil then return nil end
local ct=rawget(ch,"CacheTable")
if type(ct)~="table" then
local okC,c2=pcall(function() return ch.CacheTable end)
if okC and type(c2)=="table" then ct=c2 end
end
if type(ct)~="table" then return nil end
local v=rawget(ct,key)
if v~=nil then return v end
local okV,v2=pcall(function() return ct[key] end)
if okV then return v2 end
return nil
end
_G._tekRawCT=function(plotName)
local c=_G.TekSyncGet(plotName)
if not c then return nil end
return rawget(c,"CacheTable")
end
local _AD,_MD,_TD
local function _data()
if _AD then return true end
local ok=pcall(function()

local R=game:GetService("ReplicatedStorage")
local d=R:FindFirstChild("Datas") or R:WaitForChild("Datas",2)
if not d then return end
local a=d:FindFirstChild("Animals") or d:WaitForChild("Animals",2)
if a then _AD=require(a) end
local m=d:FindFirstChild("Mutations") or d:WaitForChild("Mutations",2)
if m then _MD=require(m) end
local t=d:FindFirstChild("Traits") or d:WaitForChild("Traits",2)
if t then _TD=require(t) end
end)
return ok and _AD~=nil
end
_G._tekGen=function(index,mutation,traits)
if not _data() then return 0 end
local info=_AD[index]
if not info or not info.Generation then return 0 end
local mult=1
if mutation and mutation~="None" and mutation~="" then
local m=_MD[mutation]
if m and m.Modifier then mult=mult+m.Modifier end
end
if type(traits)=="table" then
for _,tr in ipairs(traits)do
local t=_TD[tr]
if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
end
end
return info.Generation*mult
end
local _sharedAnimals
_G._tekAnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._tekGen(index,mutation,traits)end},{
__index=function(_,k)

if not _sharedAnimals then
local ok,real=pcall(function()
local R=game:GetService("ReplicatedStorage")
local sh=R:FindFirstChild("Shared") or R:WaitForChild("Shared",3)
local an=sh and (sh:FindFirstChild("Animals") or sh:WaitForChild("Animals",3))
return an and require(an) or nil
end)
if ok and type(real)=="table" then _sharedAnimals=real end
end
if not _sharedAnimals then return nil end
return rawget(_sharedAnimals,k)
end})
_G.Tek_GetPlotChannel=function(plotName)return _G.TekSyncGet(plotName)end
_G.Tek_GetAllPlots=function()return _G.TekSyncAll() or {} end
_G.Tek_GetPlotAnimalList=function(plotName)
local ct=_G._tekRawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end

_G.TekSyncAll  = _G.TekSyncAll
_G.TekSyncGet  = _G.TekSyncGet
_G.TekRawCT    = _G._tekRawCT
_G.TekGen      = _G._tekGen
_G.TekAnimShim = _G._tekAnimShim
_G.stealthGet    = function(n) return _G.TekSyncGet(n) end
_G.SyncInt       = {_cache={},_data=nil}



task.spawn(function()
    for i = 1, 260 do
        local t = _G.TekSyncAll()
        local pl = workspace:FindFirstChild("Plots")
        local kids = pl and pl:GetChildren()
        local want = kids and #kids or 0
        if want > 0 and type(t) == "table" then
            local have = 0
            for k = 1, want do
                if rawget(t, kids[k].Name) ~= nil then have = have + 1 end
            end
            if have >= want then _G.TekChannelsReady = true return end
        end
        task.wait(i <= 100 and 0.04 or 0.1)
    end
end)

_G.TekGetSyncData = _G.TekGetSyncData or function(plot)
    local plotName = type(plot) == "string" and plot or (plot and plot.Name)
    if not plotName then return nil end
    local Pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Sync = Pkgs and Pkgs:FindFirstChild("Synchronizer")
    if not Sync then return nil end
    local okMod, mod = pcall(require, Sync)
    if not okMod or type(mod) ~= "table" then return nil end

    local okT, data = pcall(function() return _G.TekRawCT(plotName) end)
    if okT and type(data) == "table" then return data end

    local okC, ch = pcall(function() return _G.TekSyncGet(plotName) end)
    if okC and ch then
        local synth = { __channel = ch }
        pcall(function() local ct = rawget(ch, "CacheTable"); if type(ct)=="table" then synth.AnimalList = ct.AnimalList; synth.Owner = ct.Owner end end)
        return synth
    end
    return nil
end


_mkNextModTry = 0

function _TekBuildDefaultBrainrotPriority()
    if not AnimalsData then return end
    table.clear(_brainrotDefaultPri)
    table.clear(_brainrotDefaultRarity)
    local rarities = { OG = 1, Secret = 2, ["Brainrot God"] = 3, ["Brainrot Titan"] = 4, ["Brainrot Legendary"] = 5, Legendary = 6, Mythic = 7, Epic = 8, Rare = 9, Uncommon = 10, Common = 11 }
    local list = {}
    for name, info in pairs(AnimalsData) do
        if type(info) == "table" then
            local r = tostring(info.Rarity or "Common")
            local rIdx = rarities[r] or 12
            table.insert(list, { name = info.DisplayName or name, index = name, r = r, rIdx = rIdx })
        end
    end
    table.sort(list, function(a, b)
        if a.rIdx ~= b.rIdx then return a.rIdx < b.rIdx end
        return (a.name or a.index) < (b.name or b.index)
    end)
    for i, v in ipairs(list) do
        local nn = _normName(v.name)
        local ni = _normName(v.index)
        _brainrotDefaultPri[nn] = i
        _brainrotDefaultRarity[nn] = v.r
        if _brainrotDefaultPri[ni] == nil then
            _brainrotDefaultPri[ni] = i
            _brainrotDefaultRarity[ni] = v.r
        end
    end
    if #_G.SHARED_PRIORITY_ITEMS == 0 then
        local cap = tonumber(_G.TekDefaultPrioCap) or 60
        for i, v in ipairs(list) do
            if i > cap then break end
            _G.SHARED_PRIORITY_ITEMS[i] = v.name
        end
    end
    _G.TekPriVersion = (_G.TekPriVersion or 0) + 1
end

function loadModules()
    if AnimalsData then
        if not AnimalsShared and _G.TekAnimShim then AnimalsShared = _G.TekAnimShim end
        return true
    end
    if os.clock() < _mkNextModTry then return false end
    _mkNextModTry = os.clock() + (tonumber(_G.TekModRetry) or 0.5)
    pcall(function()
        local Datas = RS:FindFirstChild("Datas") or RS:WaitForChild("Datas", 1.5)
        if Datas then
            local a = Datas:FindFirstChild("Animals") or Datas:WaitForChild("Animals", 1.5)
            if a then AnimalsData = require(a) end
        end
    end)
    pcall(_TekBuildDefaultBrainrotPriority)
    AnimalsShared = _G.TekAnimShim
    if not NumberUtils then
        pcall(function()
            local Utils = RS:FindFirstChild("Utils")
            local n = Utils and Utils:FindFirstChild("NumberUtils")
            if n then NumberUtils = require(n) end
        end)
    end
    return AnimalsData ~= nil
end

function loadNet() return false end

function getRemote(method, name)
    return _G.__secureGetRemote(method, name)
end
_G.TekGetRemote = getRemote

GRAPPLE_ARG = 0.8



-- Grapple preparation ported from newelysiumteleport.lua.
-- Uses the donor resolver, cooldown checks and raycast anchor selection.
do
local _WSg = game:GetService("Workspace")

-- Grapple remote resolver: uses rymogs' Net-hook approach (hookfunction on the
-- game's own Heartbeat listener) to resolve remotes through the Net module
-- without any getfenv/setreadonly detection surface.
local getGrappleRemote
do
    local netFolder, netModule, queue, hooked, original = nil, nil, {}, false, nil
    local function netDirectory()
        if netFolder then return netFolder end
        local packages = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
        if not packages then return nil end
        netFolder = packages:FindFirstChild("Net") or packages:WaitForChild("Net", 10)
        return netFolder
    end
    local function getNet()
        if netModule then return netModule end
        local directory = netDirectory()
        if not directory then return nil end
        local ok, module = pcall(require, directory)
        if ok and type(module) == "table" then netModule = module end
        return netModule
    end
    local function host()
        for _, signal in ipairs({ RunService.Heartbeat, RunService.RenderStepped, RunService.PostSimulation }) do
            local ok, connections = pcall(getconnections, signal)
            if ok then
                for _, connection in ipairs(connections) do
                    local fn = connection.Function
                    if fn and islclosure(fn) and not isexecutorclosure(fn) then
                        local source = select(2, pcall(debug.info, fn, "s"))
                        if type(source) == "string" and source:find("^ReplicatedStorage%.")
                            and not source:find("ReplicatedFirst") then
                            return fn
                        end
                    end
                end
            end
        end
    end
    local function install()
        if hooked then return true end
        if not getNet() then return false end
        local fn = host()
        if not fn then return false end
        local wrapper = function(...)
            local job = table.remove(queue, 1)
            if job then
                local ok, remote = pcall(netModule[job.kind], netModule, job.name)
                job.result = (ok and typeof(remote) == "Instance") and remote or nil
                job.done = true
            end
            return original(...)
        end
        local ok, env = pcall(getfenv, fn)
        if ok and type(env) == "table" then pcall(setfenv, wrapper, env) end
        original = hookfunction(fn, wrapper)
        hooked = true
        return true
    end
    local cache = {}
    getGrappleRemote = function(method, name)
        local kind = method == "RemoteFunction" and "RemoteFunction"
            or method == "UnreliableRemoteEvent" and "UnreliableRemoteEvent" or "RemoteEvent"
        if type(name) ~= "string" or name == "" then return nil end
        local cacheKey = kind .. "|" .. name
        local cached = cache[cacheKey]
        if cached and cached.Parent then return cached end
        cache[cacheKey] = nil
        if not getNet() or not install() then return nil end
        local job = { kind = kind, name = name }
        table.insert(queue, job)
        local expires = os.clock() + 5
        while not job.done and os.clock() < expires do RunService.Heartbeat:Wait() end
        if job.result and job.result.Parent then cache[cacheKey] = job.result; return job.result end
        return nil
    end
end

function _grappleInvalidate()
    _G.__TekUseItem, _G.__TekUseItemJob = nil, nil
end
_G.TekGrappleInvalidate = _grappleInvalidate

task.spawn(function() _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem") end)
task.spawn(function() _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42") end)
function _grappleRemoteGet()
    if not (_grappleUseItem and _grappleUseItem.Parent) then
        _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem")
    end
    if not (_grappleItemUse and _grappleItemUse.Parent) then
        _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
    end
    return (_grappleUseItem and _grappleUseItem.Parent and _grappleUseItem)
        or (_grappleItemUse and _grappleItemUse.Parent and _grappleItemUse)
end
_G.TekGrappleRemote = _grappleRemoteGet

local _gMuteCache = setmetatable({}, { __mode = "k" })
local function _gCollectMutes(tool)
    local e = _gMuteCache[tool]
    if e and (os.clock() - e.t) < 8 and tool.Parent then return e end
    local snd, bm = {}, {}
    pcall(function()
        local scanned = 0
        for _, s in ipairs(tool:GetDescendants()) do
            scanned = scanned + 1
            if scanned > 500 then break end
            if s:IsA("Sound") then snd[#snd + 1] = s
            elseif s:IsA("Beam") then bm[#bm + 1] = s end
        end
    end)
    e = { t = os.clock(), snd = snd, bm = bm }
    _gMuteCache[tool] = e
    return e
end

local function _gMuteAndStopPull(tool, hrp)
    if tool and tool.Parent then
        local e = _gCollectMutes(tool)
        for _, s in ipairs(e.snd) do
            if s.Parent then pcall(function() s.Volume = 0; s:Stop() end) end
        end
        for _, b in ipairs(e.bm) do
            if b.Parent then pcall(function() b.Enabled = false; b.Attachment0 = nil end) end
        end
    end
    if hrp and hrp.Parent then
        local fp = hrp:FindFirstChild("FlightPower")
        if fp then pcall(function() fp:Destroy() end) end
        -- never fight velMoveThrough / cframeStepThrough while a TP is running
        if not isTeleporting and not _G.TekTPBusy then
            _vzL(hrp)
            _vzA(hrp)
        end
    end
end

-- one hold loop at a time; re-firing the hook just extends the existing one so
-- the 0.3s in-TP fire cadence cannot stack Heartbeat connections
local _gHoldUntil, _gHoldConn = 0, nil
local function _gHoldNoPull(tool, hrp, seconds)
    _gHoldUntil = os.clock() + seconds
    if _gHoldConn then return end
    local last = 0
    _gHoldConn = RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - last >= 0.03 then
            last = now
            _gMuteAndStopPull(tool, hrp)
        end
        if now > _gHoldUntil then
            if _gHoldConn then _gHoldConn:Disconnect(); _gHoldConn = nil end
            _gMuteAndStopPull(tool, hrp)
        end
    end)
end

function _grappleToolReady(tool, waitS)
    if not tool or not tool.Parent then return false end
    local t0 = os.clock()
    while true do
        local ok, en = pcall(function() return tool.Enabled end)
        if not ok or en ~= false then return true end
        if os.clock() - t0 > (tonumber(waitS) or 0) then return false end
        RunService.Heartbeat:Wait()
        if not tool.Parent then return false end
    end
end
_G.TekToolReady = _grappleToolReady

function _grappleDo(tool, pos, target, char)
    if not tool or not pos then return false end
    if typeof(pos) == "Instance" then pos = pos.Position end
    if typeof(pos) == "CFrame"   then pos = pos.Position end
    if typeof(pos) ~= "Vector3" then
        _G.TekGrappleWhy = "bad target position"
        return false
    end
    char = char or LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        _G.TekGrappleWhy = "no hrp"
        return false
    end
    if not _grappleToolReady(tool, tonumber(_G.TekGrappleCooldownWait) or 0.35) then
        _G.TekGrappleWhy = "hook on cooldown (Enabled=false)"
        return false
    end
    if not (_grappleUseItem and _grappleUseItem.Parent) then
        _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem")
    end
    if not (_grappleItemUse and _grappleItemUse.Parent) then
        _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
    end
    if not (_grappleUseItem and _grappleUseItem.Parent)
        and not (_grappleItemUse and _grappleItemUse.Parent) then
        _G.TekGrappleWhy = "unresolved"
        return false
    end
    local mag = (pos - hrp.Position).Magnitude
    local amt = math.clamp(mag / 120, 0, 2)
    local quiet = (_G.TekGrappleQuiet ~= false)
    if quiet then _gMuteAndStopPull(tool, hrp) end
    local fired = false
    if _grappleUseItem and _grappleUseItem.Parent then
        pcall(function() _grappleUseItem:FireServer(amt, pos) end); fired = true
    end
    if _grappleItemUse and _grappleItemUse.Parent then
        pcall(function() _grappleItemUse:FireServer(amt, pos) end); fired = true
    end
    if quiet then
        _gMuteAndStopPull(tool, hrp)
        _gHoldNoPull(tool, hrp, tonumber(_G.TekGrappleQuietFor) or 0.6)
    end
    _G.TekGrappleWhy = fired and "ok" or "no remote fired"
    return fired
end
_G.TekGrappleDo = _grappleDo

local function _grappleLegacyFire()
    local fired = false
    if not (_grappleUseItem and _grappleUseItem.Parent) then
        _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem")
    end
    if not (_grappleItemUse and _grappleItemUse.Parent) then
        _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
    end
    if _grappleUseItem and _grappleUseItem.Parent then
        pcall(function() _grappleUseItem:FireServer(GRAPPLE_ARG) end); fired = true
    end
    if _grappleItemUse and _grappleItemUse.Parent then
        pcall(function() _grappleItemUse:FireServer(GRAPPLE_ARG) end); fired = true
    end
    _G.TekGrappleWhy = fired and "ok (legacy)" or "legacy: no remote"
    return fired
end

local _GFAN  = { 9, 10, 11, 12, 13, 14, 16, 18, 21, 24, 28, 32, 36, 40, 45 }
local _GFAN2 = { 11, 14, 18, 24, 32, 42, 48 }
local _GCOMPASS = {
    Vector3.new( 1, 0,  0), Vector3.new(-1, 0,  0),
    Vector3.new( 0, 0,  1), Vector3.new( 0, 0, -1),
    Vector3.new( 0.7, 0,  0.7), Vector3.new( 0.7, 0, -0.7),
    Vector3.new(-0.7, 0,  0.7), Vector3.new(-0.7, 0, -0.7),
}

-- _fireGrapple()            -> pick a target in front / around and hook it
-- _fireGrapple(vec3)        -> aim toward that point, still snapped to real geometry
-- _fireGrapple(vec3, true)  -> hook exactly that point (must be 10-50 studs out)
function _fireGrapple(value, exact)
    if _G.TekGrappleLegacy == true then return _grappleLegacyFire() end

    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if LP:GetAttribute("Stealing") and _G.TekNoGrappleWhileCarrying == true then
        _G.TekGrappleWhy = "refused: carrying a brainrot"
        return false
    end

    local tool = char:FindFirstChild("Grapple Hook") or (findGrapple())
    if tool and tool.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        pcall(function() hum:EquipTool(tool) end)
        local t0 = os.clock()
        repeat
            RunService.Heartbeat:Wait()
            char = LP.Character
            tool = char and (char:FindFirstChild("Grapple Hook") or (findGrapple()))
        until (tool and tool.Parent == char) or os.clock() - t0 > 0.5
        hrp = char and char:FindFirstChild("HumanoidRootPart")
    end
    if not tool or not hrp then return false end

    local par = RaycastParams.new()
    par.FilterType = Enum.RaycastFilterType.Exclude
    par.FilterDescendantsInstances = { char }

    if exact and typeof(value) == "Vector3" then
        local m = (value - hrp.Position).Magnitude
        if m < 10 or m > 50 then return false end
        local target
        local hit = _WSg:Raycast(hrp.Position, value - hrp.Position, par)
        if hit then target = hit.Instance end
        if not target then
            local okb, parts = pcall(function() return _WSg:GetPartBoundsInRadius(value, 6) end)
            if okb and parts then
                for _, p in ipairs(parts) do
                    if p:IsA("BasePart") and not p:IsDescendantOf(char) then target = p; break end
                end
            end
        end
        if not target then return false end
        return _grappleDo(tool, value, target, char)
    end

    local dest
    if typeof(value) == "Vector3" then dest = value
    elseif typeof(value) == "Instance" and value:IsA("BasePart") then dest = value.Position end

    local dir
    if dest then
        local d = dest - hrp.Position
        dir = Vector3.new(d.X, 0, d.Z)
    end
    if not dir or dir.Magnitude < 1 then
        local lv = hrp.CFrame.LookVector
        dir = Vector3.new(lv.X, 0, lv.Z)
    end
    if dir.Magnitude < 0.01 then return false end
    dir = dir.Unit

    local pos, target, bestM
    for _, d in ipairs(_GFAN) do
        local origin = hrp.Position + dir * d + Vector3.new(0, 3, 0)
        local hit = _WSg:Raycast(origin, Vector3.new(0, -60, 0), par)
        if hit then
            local m = (hit.Position - hrp.Position).Magnitude
            if m >= 10 and m <= 50 and (not bestM or m < bestM) then
                pos, target, bestM = hit.Position, hit.Instance, m
            end
        end
    end
    if not pos then
        for _, d in ipairs(_GFAN2) do
            local hit = _WSg:Raycast(hrp.Position, dir * d, par)
            if hit then
                local m = (hit.Position - hrp.Position).Magnitude
                if m >= 10 and m <= 50 and (not bestM or m < bestM) then
                    pos, target, bestM = hit.Position, hit.Instance, m
                end
            end
        end
    end
    if not pos then
        for _, cd in ipairs(_GCOMPASS) do
            for _, d in ipairs(_GFAN) do
                local origin = hrp.Position + cd * d + Vector3.new(0, 3, 0)
                local hit = _WSg:Raycast(origin, Vector3.new(0, -70, 0), par)
                if hit then
                    local m = (hit.Position - hrp.Position).Magnitude
                    if m >= 10 and m <= 50 and (not bestM or m < bestM) then
                        pos, target, bestM = hit.Position, hit.Instance, m
                    end
                end
            end
        end
    end
    if not pos or not target then
        _G.TekGrappleWhy = "no anchor within 10-50 studs"
        return false
    end
    return _grappleDo(tool, pos, target, char)
end
_G.TekFireGrappleBoth = _fireGrapple

function fireGrapple(value, exact)
    local char = LP.Character
    if not char then return false end
    return _fireGrapple(value, exact)
end
_G.TekFireGrapple = fireGrapple
_G.TekGrappleReady = function()
    return findGrapple() ~= nil and _grappleRemoteGet() ~= nil
end
end
-- === end Elite-method grapple ==============================================

CARPET_SPEED = 280
INBASE_SPEED = 450
SKY_CLONE_WAIT = 0.35
CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }



FLY_TOOLS = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
function findTool(name)
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end
GRAPPLE_NAMES = { "Grapple Hook" }
function findGrapple()
    for _, n in ipairs(GRAPPLE_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then return t, n end
    end
    return nil
end
function listTools()
    local out, char, bp = {}, LP.Character, LP:FindFirstChild("Backpack")
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    return table.concat(out, ", ")
end
_lastCarpetName = nil
function equipCarpet()
    if _G.TekFlashTeleportActive or _G.TekFlashTeleportRun then return nil end
    local char = LP.Character
    if not char then return nil end
    if _lastCarpetName then
        local t = char:FindFirstChild(_lastCarpetName)
        if t and t.Parent == char then return _lastCarpetName end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
            _lastCarpetName = n
            return n
        end
    end
    return nil
end
function setCarpetTool(name)
    if type(name) ~= "string" or name == "" then return end
    _G.TekCarpetTool = name

    _lastCarpetName = nil
    for i = #CARPET_NAMES, 1, -1 do
        if CARPET_NAMES[i] == name then table.remove(CARPET_NAMES, i) end
    end
    table.insert(CARPET_NAMES, 1, name)
end
_G.TekSetCarpetTool = setCarpetTool
if type(_G.TekCarpetTool) == "string" and _G.TekCarpetTool ~= "" then
    setCarpetTool(_G.TekCarpetTool)
end
_carpetEngaging = false
function carpetEngage(force)
    if _G.TekFlashTeleportActive or _G.TekFlashTeleportRun then return nil end
    if not force then
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then
                    _G.TPEngage = "carpet=" .. tostring(n)
                    return n
                end
            end
        end
    end
    if _carpetEngaging then
        local _tw = os.clock()
        repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return n end
            end
        end
    end
    _carpetEngaging = true
    local _t0 = os.clock()
    while not findTool("Grapple Hook") and os.clock() - _t0 < 5 do
        RunService.Heartbeat:Wait()
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then _carpetEngaging = false; return nil end

    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    local _te = os.clock()
    while not (LP.Character and LP.Character:FindFirstChild("Grapple Hook")) and os.clock() - _te < 1.5 do
        local c = LP.Character
        local h2 = c and c:FindFirstChildOfClass("Humanoid")
        local g = findTool("Grapple Hook")
        if g and h2 then pcall(function() h2:EquipTool(g) end) end
        RunService.Heartbeat:Wait()
    end
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        _fireGrapple()
    end
    task.wait(0.05)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:UnequipTools() end) end
    task.wait(0.05)
    local cn
    local _tc = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _tc > 0.5
    _G.TPEngage = "carpet=" .. tostring(cn)
    _carpetEngaging = false
    return cn
end

_G.TekEquipCarpet = equipCarpet
_G.TekCarpetEngaging = function() return _carpetEngaging end

if _G.TekKeepCarpet == nil then _G.TekKeepCarpet = true end
LP.CharacterAdded:Connect(function(c)
    if _G.TekKeepCarpet == false then return end
    task.spawn(function()
        c:WaitForChild("Humanoid", 10)
        task.wait(tonumber(_G.TekCarpetRespawnDelay) or 0.6)
        if _G.TekKeepCarpet == false then return end
        if _carpetEngaging or LP.Character ~= c then return end
        if LP:GetAttribute("Stealing") == true then return end
        for _, n in ipairs(CARPET_NAMES) do
            if c:FindFirstChild(n) then return end
        end
        pcall(equipCarpet)
    end)
end)

PET_PRIORITY_TIERS = {
    [1] = { pets = {"Headless Horseman"}, threshold = 0 },
    [2] = { pets = {"Signore Carapace"}, threshold = 0 },
    [3] = { pets = {"John Pork"}, threshold = 0 },
    [4] = { pets = {"Strawberry Elephant"}, threshold = 0 },
    [5] = { pets = {"Arcadragon"}, threshold = 5e9 },
    [6] = { pets = {"Elefanto Frigo"}, threshold = 10e9 },
    [7] = { pets = {"Meowl"}, threshold = 5e9 },
    [8] = { pets = {"Skibidi Toilet"}, threshold = 5e9 },
    [9] = { pets = {"Love Love Bear"}, threshold = 0 },
    [10] = { pets = {"Antonio"}, threshold = 0 },
    [11] = { pets = {"Pancake and Syrup"}, threshold = 0 },
    [12] = { pets = {"Griffin"}, threshold = 0 },
    [13] = { pets = {"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako"}, threshold = 5e9 },
    [14] = { pets = {"Ginger Gerat","Pet"}, threshold = 10e9 },
    [15] = { pets = {"Hydra Bunny","Digi Narwhal","Kalika Bros"}, threshold = 3e9 },
    [16] = { pets = {"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"}, threshold = 3e9 },
    [17] = { pets = {"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"}, threshold = 3e9 },
    [18] = { pets = {"Fragola La La La","Cerberus","Guest 666","Los Hackers"}, threshold = 1e9 },
    [19] = { pets = {"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus"}, threshold = 750e6 },
    [20] = { pets = {"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"}, threshold = 1e9 },
}

TIER_LOOKUP = {}
for tier, data in pairs(PET_PRIORITY_TIERS) do
    for _, name in ipairs(data.pets) do TIER_LOOKUP[name] = tier end
end

LOCKED_TIERS = { [1]=true, [2]=true, [3]=true, [4]=true }

DIRECT_THRESHOLDS = {
    [3] = { [4] = 10e9 },
    [4] = {},
    [5] = { [6] = math.huge },
    [6] = { [9] = math.huge, [10] = math.huge, [12] = 15e9 },
    [10] = { [12] = 20e9 },
    [11] = { [12] = 10e9 },
}

MUTATION_PRIORITY = {
    ["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,
    ["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,
}

TRAIT_PRIORITY = {}

MUTATION_ICONS, TRAIT_ICONS = {}, {}

local function _mutationDisplayName(name)
    local text = tostring(name or "")
    return text:lower():gsub("[%s%-_]", "") == "yinyang" and "Yin Yang" or text
end

local function _iconForName(icons, name)
    if type(icons) ~= "table" then return nil end
    local exact = icons[name]
    if exact then return exact end
    local wanted = tostring(name or ""):lower():gsub("[%s%-_]", "")
    for key, icon in pairs(icons) do
        if tostring(key):lower():gsub("[%s%-_]", "") == wanted then return icon end
    end
    return nil
end

function _TekLoadGameData()
    local ok1, mData = pcall(function() return require(game.ReplicatedStorage.Datas.Mutations) end)
    if ok1 and type(mData) == "table" then
        local mList = {}
        for name, data in pairs(mData) do
            if type(data) == "table" then
                MUTATION_ICONS[name] = data.Icon
                mList[#mList + 1] = name
            end
        end
        table.sort(mList)
        if #_G.SHARED_MUTATION_PRIORITY == 0 then
            for i = 1, #mList do _G.SHARED_MUTATION_PRIORITY[i] = mList[i] end
        end
    end
    local ok2, tData = pcall(function() return require(game.ReplicatedStorage.Datas.Traits) end)
    if ok2 and type(tData) == "table" then
        local tList = {}
        for name, data in pairs(tData) do
            if type(data) == "table" then
                TRAIT_ICONS[name] = data.Icon
                tList[#tList + 1] = name
            end
        end
        table.sort(tList)
        if #_G.SHARED_TRAIT_PRIORITY == 0 then
            for i = 1, #tList do _G.SHARED_TRAIT_PRIORITY[i] = tList[i] end
        end
    end
end

task.spawn(function()
    pcall(function()
        local Datas = game:GetService("ReplicatedStorage"):FindFirstChild("Datas")
        local a = Datas and Datas:FindFirstChild("Animals")
        if a and not AnimalsData then AnimalsData = require(a) end
        if AnimalsData then _TekBuildDefaultBrainrotPriority() end
    end)
    pcall(_TekLoadGameData)
end)

function getMutPrio(m)
    if not m or m == "" or m == "None" then return 0 end
    local n = tostring(m)
    local dis = _G.SHARED_MUTATION_DISABLED
    if type(dis) == "table" and (dis[n] or dis[_normName(n)]) then return 0 end
    local idx = _priIndexOfMut(n)
    if not idx then
        n = n:lower():gsub("[%s%-_]","")
        idx = _priIndexOfMut(n)
    end
    if idx then return 999 - idx end
    if MUTATION_PRIORITY[m] then return MUTATION_PRIORITY[m] end
    if MUTATION_PRIORITY[n] then return MUTATION_PRIORITY[n] end
    return 0
end

function getTraitPrio(t)
    if not t or t == "" then return 0 end
    local name = type(t) == "table" and t.name or tostring(t)
    local n = name
    local idx = _priIndexOfTrait(n)
    if not idx then
        n = n:lower():gsub("[%s%-_]","")
        idx = _priIndexOfTrait(n)
    end
    if idx then return 999 - idx end
    if TRAIT_PRIORITY[name] then return TRAIT_PRIORITY[name] end
    if TRAIT_PRIORITY[n] then return TRAIT_PRIORITY[n] end
    return 0
end

function getCumThreshold(hi, lo)
    if DIRECT_THRESHOLDS[hi] and DIRECT_THRESHOLDS[hi][lo] then return DIRECT_THRESHOLDS[hi][lo] end
    if LOCKED_TIERS[hi] then return math.huge end
    local total = 0
    for t = hi + 1, lo do
        local td = PET_PRIORITY_TIERS[t]
        if td and td.threshold > 0 then total = total + td.threshold end
    end
    return total
end

function _normName(s)
    return tostring(s):lower():gsub("[%s%-_'%.]", "")
end
_priCacheVer, _priCache = -1, {}
_brainrotDefaultPri = {}
_brainrotDefaultRarity = {}
_mutPriCacheVer, _mutPriCache = -1, {}
_traitPriCacheVer, _traitPriCache = -1, {}

function _priLookup(listName)
    local ver = _G.TekPriVersion or 0
    if listName == "mutation" then
        if _mutPriCacheVer ~= ver then
            table.clear(_mutPriCache)
            local plist = _G.SHARED_MUTATION_PRIORITY
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _mutPriCache[_normName(plist[i])] = i end
            end
            _mutPriCacheVer = ver
        end
        return _mutPriCache
    elseif listName == "trait" then
        if _traitPriCacheVer ~= ver then
            table.clear(_traitPriCache)
            local plist = _G.SHARED_TRAIT_PRIORITY
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _traitPriCache[_normName(plist[i])] = i end
            end
            _traitPriCacheVer = ver
        end
        return _traitPriCache
    else
        if _priCacheVer ~= ver then
            table.clear(_priCache)
            local plist = _G.SHARED_PRIORITY_ITEMS
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _priCache[_normName(plist[i])] = i end
            end
            _priCacheVer = ver
        end
        return _priCache
    end
end
_G.TekPriLookup = function() return _priLookup() end
function _priIndexOf(name)
    if not name then return nil end
    local n = _normName(name)
    local idx = _priLookup()[n]
    if idx then return idx end
    local def = _brainrotDefaultPri[n]
    if def and _brainrotDefaultRarity[n] == "OG" then
        return def * 0.001
    end
    return nil
end
function _priIndexOfMut(name)
    if not name then return nil end
    return _priLookup("mutation")[_normName(name)]
end
function _priIndexOfTrait(name)
    if not name then return nil end
    return _priLookup("trait")[_normName(name)]
end

function petOutranks(aName, bName, aMut, bMut, aMPS, bMPS, aTraits, bTraits)
    local iA = _priIndexOf(aName)
    local iB = _priIndexOf(bName)
    if iA ~= nil and iB ~= nil then
        if iA ~= iB then return iA < iB end
    end
    if (iA ~= nil) ~= (iB ~= nil) then return iA ~= nil end
    if iA == nil and iB == nil then
        if (aMPS or 0) ~= (bMPS or 0) then return (aMPS or 0) > (bMPS or 0) end
    end
    local ma, mb = getMutPrio(aMut), getMutPrio(bMut)
    if ma ~= mb then return ma > mb end
    if type(aTraits) == "table" and type(bTraits) == "table" then
        local pa, pb = 0, 0
        for _, t in ipairs(aTraits) do pa = math.max(pa, getTraitPrio(t)) end
        for _, t in ipairs(bTraits) do pb = math.max(pb, getTraitPrio(t)) end
        if pa ~= pb then return pa > pb end
    end
    return (aMPS or 0) > (bMPS or 0)
end

function getPlotChannel(plotName)
    local channel
    pcall(function() channel = _G.TekSyncGet(plotName) end)
    return channel
end

function channelGet(channel, key)
    if not channel then return nil end
    local ok, v = pcall(function()
        local ct = rawget(channel, "CacheTable")
        if type(ct) == "table" then
            local r = rawget(ct, key)
            if r ~= nil then return r end
        end
        local d = rawget(channel, "Data")
        if type(d) == "table" then
            local r = rawget(d, key)
            if r ~= nil then return r end
        end
        return rawget(channel, key)
    end)
    if ok then return v end
    return nil
end

function _ownerIsMe(owner)
    if not owner then return false end
    local result = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            result = owner.UserId == LP.UserId
        elseif type(owner) == "table" and owner.UserId then
            result = owner.UserId == LP.UserId
        elseif typeof(owner) == "Instance" then
            result = owner == LP
        elseif type(owner) == "string" then
            result = owner:lower() == LP.Name:lower()
                or owner:lower() == (LP.DisplayName or LP.Name):lower()
        end
    end)
    return result
end

function isMyPlot(channel)
    if not channel then return false end
    return _ownerIsMe(channelGet(channel, "Owner"))
end

_ownerInGameCache, _ownerInGameAt = {}, {}
function _ownerInGame(owner)
    if not owner then return false end
    local cacheKey
    if typeof(owner) == "Instance" then cacheKey = "i:" .. tostring(owner)
    elseif type(owner) == "number" then cacheKey = "n:" .. owner
    elseif type(owner) == "string" then cacheKey = "s:" .. owner:lower()
    else cacheKey = "o:" .. tostring(owner) end
    local now = os.clock()
    local cached = _ownerInGameAt[cacheKey]
    if cached and (now - cached.t) < 2 then return cached.v end
    local inGame = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            inGame = owner.Parent == Players
        elseif type(owner) == "number" then
            inGame = Players:GetPlayerByUserId(owner) ~= nil
        elseif type(owner) == "table" and owner.Name then
            inGame = Players:FindFirstChild(tostring(owner.Name)) ~= nil
        elseif typeof(owner) == "Instance" and owner.Name then
            inGame = Players:FindFirstChild(owner.Name) ~= nil
        elseif type(owner) == "string" then
            if Players:FindFirstChild(owner) then
                inGame = true
            else
                local lo = owner:lower()
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Name:lower() == lo or (pl.DisplayName or ""):lower() == lo then inGame = true break end
                end
            end
        end
    end)
    _ownerInGameCache[cacheKey] = { v = inGame, t = now }
    _ownerInGameAt[cacheKey] = { v = inGame, t = now }
    return inGame
end

function ownerInGame(channel)
    if not channel then return false end
    return _ownerInGame(channelGet(channel, "Owner"))
end

_petModelCache = setmetatable({}, { __mode = "v" })
_genCache = {}

local _MPS_SUFFIX = { K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15 }
_wmpsCache, _wmpsAt = {}, {}
function _worldMPS(plot, slot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end


    local _ck = plot.Name .. "\0" .. tostring(slot)
    local _now = os.clock()
    if _wmpsAt[_ck] and (_now - _wmpsAt[_ck]) < (tonumber(_G.TekWorldMPSTTL) or 1) then
        return _wmpsCache[_ck]
    end
    local best = nil
    local function _scanLabels(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local txt = child.Text
                if type(txt) == "string" and txt ~= "" then
                    local num, suf = txt:match("%$%s*([%d%.]+)%s*([KMBTQ]?)%s*/s")
                    if num then
                        local v = tonumber(num)
                        if v then
                            v = v * (_MPS_SUFFIX[suf] or 1)
                            if not best or v > best then best = v end
                        end
                    end
                end
            end
            _scanLabels(child)
        end
    end
    _scanLabels(podium)
    _wmpsCache[_ck], _wmpsAt[_ck] = best, _now
    return best
end
function getPetPosition(plot, slot, strict)
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end

    local key = plot.Name .. "\0" .. tostring(slot)
    local cached = _petModelCache[key]
    if cached and cached.Parent and cached:IsDescendantOf(podium) then
        local ok, cf = pcall(function() return cached:GetBoundingBox() end)
        if ok then return cf.Position end
    end
    _petModelCache[key] = nil

    local _skipNames = { Claim = true, Base = true, Decorations = true }
    local function _findModel(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and not _skipNames[child.Name] then
                if child:FindFirstChildWhichIsA("MeshPart", true) then
                    return child
                end
            end
            local found = _findModel(child)
            if found then return found end
        end
        return nil
    end

    local model = _findModel(podium)
    if model then
        local ok, cf = pcall(function() return model:GetBoundingBox() end)
        if ok then
            _petModelCache[key] = model
            return cf.Position
        end
    end

    if strict then return nil end
    local ok, cf = pcall(function() return podium:GetPivot() end)
    if ok then return cf.Position end
    return podium.Position
end

-- Match the source script's 18M/s minimum for all scanned targets.
_G.TekMinMPS = 18000000
function scanAllPets()
    local pets = {}
    if not loadModules() then
        _G.TekScanTotal, _G.TekScanUsed, _G.TekScanNoChan = 0, 0, 8
        return pets
    end

    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then
        _G.TekScanTotal, _G.TekScanUsed, _G.TekScanNoChan = 0, 0, 8
        return pets
    end

    local _mkSeen, _mkUse, _mkTotal = 0, 0, 0
    local _mkNoChan = 0
    local _mkTags = {}
    for _, plot in ipairs(Plots:GetChildren()) do
        _mkTotal = _mkTotal + 1
        local channel = getPlotChannel(plot.Name)
        if not channel then _mkTags[#_mkTags + 1] = "nochan" _mkNoChan = _mkNoChan + 1 continue end
        _mkSeen = _mkSeen + 1
        local owner = channelGet(channel, "Owner")
        if _ownerIsMe(owner) then _G.TekMyPlot = plot.Name _mkTags[#_mkTags + 1] = "MINE" continue end
        if _G.TekMyPlot == plot.Name then _mkTags[#_mkTags + 1] = "MINE" continue end
        if not _G.TekMyPlot and owner == nil then _mkTags[#_mkTags + 1] = "noowner?" continue end
        if _G.TekRequireOwner ~= false and not _ownerInGame(owner) then _mkTags[#_mkTags + 1] = "left" continue end
        _mkUse = _mkUse + 1

        local animalList = channelGet(channel, "AnimalList")
        if not animalList then _mkTags[#_mkTags + 1] = "nolist" continue end
        local _mkPlotN = 0

        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            if not animalName then continue end
            local animalInfo = AnimalsData and AnimalsData[animalName]
            if not animalInfo and _G.TekRequireKnown == true then continue end
            if _TekIsFusing(animalData) then continue end

            local mutation = animalData.Mutation or "None"
            local traits = animalData.Traits
            if type(traits) ~= "table" then traits = {} end

            local genValue
            local _gk = plot.Name .. "\0" .. tostring(slot)
            local _gc = _genCache[_gk]
            if _gc and _gc.n == animalName and _gc.m == animalData.Mutation and _gc.t == animalData.Traits then
                genValue = _gc.g
            else
                genValue = 0
                pcall(function()
                    local shim = AnimalsShared or _G.TekAnimShim
                    if shim then genValue = shim:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil) end
                end)
                if genValue and genValue > 0 then
                    _genCache[_gk] = { n = animalName, m = animalData.Mutation, t = animalData.Traits, g = genValue }
                end
            end
            if (not genValue or genValue <= 0) and _G.TekWorldMPS ~= false then
                local wm = _worldMPS(plot, slot)
                if wm and wm > 0 then genValue = wm end
            end

            local displayName = (animalInfo and animalInfo.DisplayName) or animalName

            local pos = getPetPosition(plot, slot, (_G.TekRequireOwner == false) or (_G.TekRequireModel == true))

            if pos then
                local minScanMps = math.max(18000000, tonumber(_G.TekMinMPS) or 0)
                local resolvedMps = tonumber(genValue) or 0
                if resolvedMps >= minScanMps then
                    table.insert(pets, {
                        name = displayName,
                        index = animalName,
                        mps = resolvedMps,
                        mutation = mutation,
                        traits = traits,
                        position = pos,
                        plot = plot.Name,
                        slot = tostring(slot),
                    })
                    _mkPlotN = _mkPlotN + 1
                end
            end
        end
        _mkTags[#_mkTags + 1] = tostring(_mkPlotN)
    end

    _G.TekScanTotal, _G.TekScanUsed, _G.TekScanNoChan = _mkTotal, _mkUse, _mkNoChan
    _G.TekScanInfo = string.format("plots %d scanned of %d  pets %d  [%s]  %s", _mkUse, _mkTotal, #pets, table.concat(_mkTags, " "), tostring(_G.TekScanMode))
    local function _bestTraitPrio(traits)
        if type(traits) ~= "table" then return 0 end
        local best = 0
        for _, t in ipairs(traits) do
            local p = getTraitPrio(t)
            if p > best then best = p end
        end
        return best
    end

    for _, p in ipairs(pets) do
        p._pri = _priIndexOf(p.name) or (p.index and _priIndexOf(p.index)) or nil
        p._mp = tonumber(p.mps) or 0
        p._mut = getMutPrio(p.mutation)
        p._trait = _bestTraitPrio(p.traits)
    end

    local function _petOrder(a, b)
        local ia, ib = a._pri, b._pri
        if (ia ~= nil) ~= (ib ~= nil) then return ia ~= nil end
        if ia and ib and ia ~= ib then return ia < ib end
        if ia == nil then
            if a._mp ~= b._mp then return a._mp > b._mp end
        end
        if a._mut ~= b._mut then return a._mut > b._mut end
        if a._trait ~= b._trait then return a._trait > b._trait end
        if a._mp ~= b._mp then return a._mp > b._mp end
        local pa, pb = tostring(a.plot), tostring(b.plot)
        if pa ~= pb then return pa < pb end
        return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
    end

    local mode = _G.TekStealMode
    if mode == "highest" then
        table.sort(pets, function(a, b)
            local ma, mb = tonumber(a.mps) or 0, tonumber(b.mps) or 0
            if ma ~= mb then return ma > mb end
            local pa, pb = tostring(a.plot), tostring(b.plot)
            if pa ~= pb then return pa < pb end
            return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
        end)
        return pets
    end

    table.sort(pets, _petOrder)

    return pets
end
_G.TekScanAllPets = scanAllPets


_scanShared, _scanSharedAt = nil, 0
function scanAllPetsCached(maxAge)
    local now = os.clock()
    if _scanShared and (now - _scanSharedAt) <= (tonumber(maxAge) or 0.15) then
        return _scanShared
    end
    local ok, p = pcall(scanAllPets)
    if ok and type(p) == "table" then
        _scanShared, _scanSharedAt = p, now
        return p
    end
    return nil
end
_G.TekScanCached = scanAllPetsCached

function scanForTP()

    local inBoot = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
    local full = scanAllPetsCached(tonumber(_G.TekScanCacheAge) or (inBoot and 0.1 or 0.2))
    if type(full) ~= "table" then full = {} end
    if _G.TekScanTiered and _G.TekUseTiered ~= false then
        local ok, tiered = pcall(_G.TekScanTiered)
        if ok and type(tiered) == "table" and #tiered > 0 then
            local seen = {}
            for _, p in ipairs(full) do
                if p and p.plot and p.slot ~= nil then
                    seen[tostring(p.plot) .. "_" .. tostring(p.slot)] = true
                end
            end
            for _, p in ipairs(tiered) do
                if p and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    if not seen[uid] and (tonumber(p.mps) or 0) >= math.max(18000000, tonumber(_G.TekMinMPS) or 0) then
                        seen[uid] = true
                        full[#full + 1] = p
                    end
                end
            end
        end
    end
    return full
end

function _petUid(p)
    if not p then return nil end
    return tostring(p.plot) .. "_" .. tostring(p.slot)
end
function _pickPetOnFoot(pets, myPos)
    if not pets or #pets == 0 then return nil end
    local best
    if _G.TekStealMode == "nearest" and myPos then
        local bestD = math.huge
        for _, p in ipairs(pets) do
            if not p.conveyor and p.position then
                local d = (p.position - myPos).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
    else
        for _, p in ipairs(pets) do
            if not p.conveyor then best = p; break end
        end
    end
    return best or pets[1]
end
function _findTPSyncedPet(pets)
    local uid = _G.TekStealTargetUID
    if type(uid) ~= "string" or uid == "" then return nil end
    for _, p in ipairs(pets) do
        if _petUid(p) == uid then return p end
    end
    return nil
end
function _clearTPSync()
    _G.TekTPSyncActive = false
    _G.TekStealTargetUID = nil
    _G.TekStealTarget = nil
end
function _armTPSync(pet)
    if not pet then return end
    _G.TekStealTargetUID = _petUid(pet)
    _G.TekStealTarget = pet
    _G.TekTPSyncActive = true
    local gen = (_G._TekTPSyncGen or 0) + 1
    _G._TekTPSyncGen = gen
    task.delay(12, function()
        if _G._TekTPSyncGen == gen then _clearTPSync() end
    end)
end
_G.TekClearTPSync = _clearTPSync
function _findStealTarget(pets)
    -- Steal Target selections are valid even without the temporary TP sync flag.
    return _findTPSyncedPet(pets)
end
function _publishStealTarget(pet)
    if not pet then return end
    _G.TekStealTargetUID = _petUid(pet)
    _G.TekStealTarget = pet
end

MK_UPPER = {
    B = {{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},{coord=Vector3.new(-332.379730,16.850722,-75.762100),facing="NORTH"},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"}},
    C = {{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},{coord=Vector3.new(-502.989349,16.850713,31.172430),facing="NORTH"},{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"}},
    D = {{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"}},
}
MK_LOWER = {
    B = {{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},{coord=Vector3.new(-483.619385,-3.718430,-18.844337),facing="SOUTH"},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"}},
    C = {{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},{coord=Vector3.new(-483.749390,-3.048218,88.147003),facing="SOUTH"},{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"}},
    D = {{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"}},
}
UPPER_Y_THRESHOLD = 7
TALL_PETS = { ["La Secret Combinasion"]=true, ["La Jolly Grande"]=true }
TALL_OFFSET = 3

BASES_LOW = {
    [1] = Vector3.new(-476.52, -2, 220.94090270996094),
    [2] = Vector3.new(-476.52, -2, 113.77315521240234),
    [3] = Vector3.new(-476.52, -2, 6.178487777709961),
    [4] = Vector3.new(-476.52, -2, -101.07275390625),
    [5] = Vector3.new(-342.66, -2, 221.44737243652344),
    [6] = Vector3.new(-342.66, -2, 113.41409301757812),
    [7] = Vector3.new(-342.66, -2, 6.249461650848389),
    [8] = Vector3.new(-342.66, -2, -99.73458862304688),
}
BASES_HIGH = {
    [1] = Vector3.new(-479.51, 18, 220.94090270996094),
    [2] = Vector3.new(-479.51, 18, 113.77315521240234),
    [3] = Vector3.new(-479.51, 18, 6.178487777709961),
    [4] = Vector3.new(-479.51, 18, -101.07275390625),
    [5] = Vector3.new(-339.48, 18, 221.44737243652344),
    [6] = Vector3.new(-339.48, 18, 113.41409301757812),
    [7] = Vector3.new(-339.48, 18, 6.249461650848389),
    [8] = Vector3.new(-339.48, 18, -99.73458862304688),
}
FRONT_Y_LOW   = -3.048217
FRONT_Y_HIGH  = 16.850713
COLUMN_SPLIT_X = -410
FRONT_Z_CLAMP  = 18
SIDE_NEAR_Z    = 45

function getClosestBaseIdx(pos)
    local closest, dist = 1, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (pos.X - b.X)^2 + (pos.Z - b.Z)^2
        if d < dist then dist = d; closest = i end
    end
    return closest
end

function buildFrontCandidate(idx, isUpper, playerZ)
    local base = isUpper and BASES_HIGH[idx] or BASES_LOW[idx]
    local frontY = isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
    local frontZ = math.clamp(playerZ - base.Z, -FRONT_Z_CLAMP, FRONT_Z_CLAMP) + base.Z
    local coord = Vector3.new(base.X, frontY, frontZ)
    local faceDir = (idx <= 4) and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
    return coord, faceDir
end

function plotSides(coordTable, idx)
    local base = BASES_LOW[idx]
    local isWest = idx <= 4
    local out = {}
    for _, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            if ((data.coord.X < COLUMN_SPLIT_X) == isWest)
               and math.abs(data.coord.Z - base.Z) < SIDE_NEAR_Z then
                out[#out + 1] = data
            end
        end
    end
    return out
end

function _floor1LaserSolid(plotName)
    local solid = false
    pcall(function()
        local Plots = workspace:FindFirstChild("Plots")
        local plot = Plots and Plots:FindFirstChild(plotName)
        if not plot then return end
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name == "LaserHitbox" or d.Name == "Laser")
                and d.CanCollide and d.Position.Y <= 9 then
                solid = true
                break
            end
        end
    end)
    return solid
end

function isPlotUnlocked(plotName)
    local ok, res = pcall(function()
        local channel = getPlotChannel(plotName)
        if not channel then return false end
        if channelGet(channel, "BlockEndTimeFirstFloor") ~= nil then return false end
        return not _floor1LaserSolid(plotName)
    end)
    return ok and (res == true)
end

function findClosest(petPos, coordTable)
    local best, bestKey, bestDist = nil, nil, math.huge
    for skyKey, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            local c = data.coord
            local d = math.sqrt((petPos.X - c.X)^2 + (petPos.Z - c.Z)^2)
            if d < bestDist then bestDist = d; best = data; bestKey = skyKey end
        end
    end
    return best, bestKey
end

do
_vizParts = {}
_vizGen = 0

function _vizEnsure()
    if _vizFolder and _vizFolder.Parent then return end
    _vizFolder = Instance.new("Folder")
    _vizFolder.Name = "TekPathViz"
    _vizFolder.Parent = workspace
    _vizAnchor = Instance.new("Part")
    _vizAnchor.Name = "Anchor"
    _vizAnchor.Anchored = true; _vizAnchor.CanCollide = false; _vizAnchor.CanQuery = false
    _vizAnchor.CanTouch = false; _vizAnchor.Transparency = 1; _vizAnchor.Size = Vector3.one
    _vizAnchor.CFrame = CFrame.new()
    _vizAnchor.Parent = _vizFolder
end
clearViz = function()
    if _vizFolder then pcall(function() _vizFolder:Destroy() end) end
    _vizFolder, _vizAnchor = nil, nil
    table.clear(_vizParts)
end
local function _ghost(cf, size, color, op)
    _vizEnsure()
    local a = Instance.new("BoxHandleAdornment")
    a.Adornee = _vizAnchor
    a.AlwaysOnTop = true
    a.ZIndex = 0
    pcall(function() a.Shading = Enum.AdornShading.XRayShaded end)
    a.Color3 = color
    a.Transparency = 1 - op
    a.Size = size
    a.CFrame = cf
    a.Parent = _vizAnchor
end
local function _neon(cf, size, color, ball, transp)
    _vizEnsure()
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
    p.Material = Enum.Material.Neon; p.Color = color
    p.Transparency = transp or 0
    if ball then p.Shape = Enum.PartType.Ball end
    p.Size = size; p.CFrame = cf; p.Parent = _vizFolder
end
function vizLine(a, b, color)
    local d = b - a
    if d.Magnitude < 0.05 then return end
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.25, 0.25, d.Magnitude), color, false, 0)
end
function vizDot(pos, color, sz)
    _neon(CFrame.new(pos), Vector3.new(sz, sz, sz), color, true, 0)
end
vizPath = function(fromPos, waypoints)
    if _G.TekShowPath ~= true then return end
    if #waypoints == 0 then return end
    local COL = Color3.fromRGB(0, 200, 140)
    local prev = fromPos
    for _, wp in ipairs(waypoints) do
        vizLine(prev, wp, COL)
        prev = wp
    end
    vizDot(waypoints[#waypoints], COL, 1.6)
end
end

MK_SPEED = 125
MK_ARRIVE = 3
_STRIP_OK = (type(getconnections) == "function")
function _climbCap()
    local v = math.clamp(tonumber(_G.TekClimb) or 200, 100, 250)
    if not _STRIP_OK then v = 55 end
    return v
end

function vZero(hrp)
    if hrp then _vzL(hrp); _vzA(hrp) end
end


function _setFlightVel(hrp, vel)
    local char = hrp and hrp.Parent
    local part = (char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))) or hrp
    if part then part.AssemblyLinearVelocity = vel end
    if _G.TekFlingTP == true and not _G.__TekFlingCalm and hrp
        and typeof(vel) == "Vector3" and vel.Magnitude > 5 then
        pcall(function()
            local t = os.clock()
            local amp = math.clamp(tonumber(_G.TekFlingAmp) or 1, 0, 3)
            hrp.CFrame = CFrame.new(hrp.Position)
                * CFrame.Angles(0, (t * 18) % (math.pi * 2), 0)
                * CFrame.Angles(math.sin(t * 20) * math.rad(45) * amp, 0, (t * 16) % (math.pi * 2))
        end)
    end
end

-- Movement core ported from elite_hub_2.lua. Elysium settings and stop flags are used.
function TekTweenOn()
return _G.TekTweenTP==true
end
function tweenPinAt(hrp,dest,faceDir)
if not hrp or not hrp.Parent then
return
end
local face=faceDir
if typeof(face)~="Vector3"or face.Magnitude<0.1 then
face=Vector3.new(dest.X-hrp.Position.X,0,dest.Z-hrp.Position.Z)
if face.Magnitude<0.1 then
face=Vector3.new(0,0,1)
end
end
face=Vector3.new(face.X,0,face.Z)
if face.Magnitude<0.1 then
face=Vector3.new(0,0,1)
end
face=face.Unit
local hum=hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
local hadAuto=hum and hum.AutoRotate
if hum then
pcall(function()
hum.AutoRotate=false
end)
end
local function restore()
if hum and hadAuto~=nil then
pcall(function()
hum.AutoRotate=hadAuto
end)
end
end
local pingMs=80
pcall(function()
pingMs=math.clamp((LP:GetNetworkPing()or 0.08)*1000,20,400)
end)
local STAGE=math.clamp(tonumber(_G.TekTweenStage)or(40-math.max(0,pingMs-120)*0.08),14,100)
local flySpd=math.max(tonumber(_G.__TekTweenSpd)or 300,120)
if dest.Y>7 then
STAGE=math.min(STAGE,tonumber(_G.TekTweenStageF2)or 12)
flySpd=0
end
local gap=(dest-hrp.Position).Magnitude
local n=math.max(1,math.ceil(gap/STAGE))
local from=hrp.Position
local dir=Vector3.new(dest.X-from.X,0,dest.Z-from.Z)
dir=dir.Magnitude>0.1 and dir.Unit or face
for k=1,n do
local p=(k==n)and dest or from:Lerp(dest,k/n)
hrp.CFrame=CFrame.lookAt(p,p+face)
hrp.AssemblyAngularVelocity=Vector3.zero
if k<n then
hrp.AssemblyLinearVelocity=(flySpd>0)and(dir*flySpd)or Vector3.zero
RunService.Heartbeat:Wait()
if not(hrp and hrp.Parent)or _G.TekTPStop then
restore()
return
end
else
hrp.AssemblyLinearVelocity=Vector3.zero
end
end
task.spawn(function()
for _=1,6 do
RunService.Heartbeat:Wait()
if not(hrp and hrp.Parent)then
break
end
hrp.AssemblyAngularVelocity=Vector3.zero
end
restore()
end)
_G.TekTPWhy=("snap %d studs in %d stage(s)"):format(math.floor(gap),n)
end
function tweenFlyThenTp(hrp,route,dest,spd,near,faceDir)
if not hrp or not hrp.Parent or not route or#route==0 then
return false
end
if not TekTweenOn()then
velMoveThrough(hrp,route,spd,true,true)
return false
end
local NEAR=math.clamp(tonumber(near)or 40,20,60)
local path={hrp.Position}
for _,p in ipairs(route)do
path[#path+1]=p
end
if(path[#path]-dest).Magnitude>0.5 then
path[#path+1]=dest
end
local split,splitIdx=path[1],2
do
local left=NEAR
local i=#path
while i>1 do
local seg=(path[i]-path[i-1]).Magnitude
if seg>=left then
split=path[i]+(path[i-1]-path[i]).Unit*left
splitIdx=i
break
end
left=left-seg
i=i-1
end
end
local far={}
for j=2,splitIdx-1 do
far[#far+1]=path[j]
end
far[#far+1]=split
_G.__TekTweenSpd=spd
if(split-hrp.Position).Magnitude>2 then
velMoveThrough(hrp,far,math.max(tonumber(spd)or 0,120),false,true,true)
end
if _G.TekTPStop or not hrp.Parent then
return false
end
if(hrp.Position-split).Magnitude>12 then
pcall(warn,string.format("[TWEEN] reached the tween start %.0f studs off - flew the rest instead",(hrp.Position-split).Magnitude))
local rest={}
for j=splitIdx,#path do
rest[#rest+1]=path[j]
end
velMoveThrough(hrp,rest,math.max(tonumber(spd)or 0,120),true,true)
return false
end
local near_={hrp.Position}
for j=splitIdx,#path do
near_[#near_+1]=path[j]
end
local pingMs=80
pcall(function()
pingMs=math.clamp((LP:GetNetworkPing()or 0.08)*1000,20,400)
end)
local flySpd=math.max(tonumber(spd)or 300,120)
local STAGE=math.clamp(tonumber(_G.TekTweenStage)or 14,3,40)
local face=faceDir
if typeof(face)~="Vector3"or face.Magnitude<0.1 then
face=dest-near_[1]
end
face=Vector3.new(face.X,0,face.Z)
if face.Magnitude<0.1 then
face=Vector3.new(0,0,1)
end
face=face.Unit
local hum=hrp.Parent:FindFirstChildOfClass("Humanoid")
local hadAuto=hum and hum.AutoRotate
if hum then
pcall(function()
hum.AutoRotate=false
end)
end
for k=2,#near_ do
local a,b2=near_[k-1],near_[k]
local seg=b2-a
local n=math.max(1,math.ceil(seg.Magnitude/STAGE))
local dir=Vector3.new(seg.X,0,seg.Z)
dir=dir.Magnitude>0.1 and dir.Unit or face
for step=1,n do
if _G.TekTPStop or not hrp.Parent then
break
end
local p=a:Lerp(b2,step/n)
hrp.CFrame=CFrame.lookAt(p,p+face)
hrp.AssemblyAngularVelocity=Vector3.zero
local isLast=(k==#near_ and step==n)
hrp.AssemblyLinearVelocity=(not isLast and flySpd>0)and(dir*flySpd)or Vector3.zero
if not isLast then
RunService.Heartbeat:Wait()
end
end
end
task.spawn(function()
for _=1,6 do
RunService.Heartbeat:Wait()
if not(hrp and hrp.Parent)then
break
end
hrp.AssemblyAngularVelocity=Vector3.zero
end
if hum and hadAuto~=nil then
pcall(function()
hum.AutoRotate=hadAuto
end)
end
end)
_G.TekTPWhy="tween: hopped the last "..math.floor(NEAR).." studs of the route"
return true
end
_G.TekTweenFlyThenTp,_G.TekTweenPinAt=tweenFlyThenTp,tweenPinAt
function tekStartHopThenFly(hrp,route,spd,allowJump,quickStart)
velMoveThrough(hrp,route,math.max(tonumber(spd)or 400,120),allowJump,quickStart)
return false
end
_G.TekStartHopThenFly=tekStartHopThenFly
function tekEnsureArrive(hrp,dest,spd)
if not(hrp and typeof(dest)=="Vector3")then
return false
end
local flySpd=math.max(tonumber(spd)or 400,120)
for _=1,2 do
for _=1,3 do
RunService.Heartbeat:Wait()
end
if not hrp.Parent or _G.TekTPStop then
return false
end
if(hrp.Position-dest).Magnitude<=(tonumber(_G.TekArriveTolerance)or 6)then
return true
end
-- correcting the last few studs
local gap=(hrp.Position-dest).Magnitude
local r={dest}
if gap>25 then
local ok,rr=pcall(computeRoute,hrp.Position,dest,nil)
if ok and type(rr)=="table"and#rr>0 then
r=rr
end
end
velMoveThrough(hrp,r,flySpd,true,true)
end
return hrp.Parent~=nil and(hrp.Position-dest).Magnitude<=6
end
_G.TekEnsureArrive=tekEnsureArrive

function velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart, noEase)
    if not hrp or not hrp.Parent or #waypoints == 0 then return false end
    local ease = (_G.TekEaseIn ~= false) and not noEase
    local runSpeed = speedOverride or math.clamp(tonumber(_G.TPVelocity) or CARPET_SPEED, 200, 750)
    vizPath(hrp.Position, waypoints)
    local wpIdx, done, arrived = 1, false, false
    local conn
    local hum0 = hrp.Parent:FindFirstChildOfClass("Humanoid")
    local oldAutoRotate = hum0 and hum0.AutoRotate
    local function finish(ok)
        if done then return end
        done, arrived = true, ok == true
        if conn then conn:Disconnect(); conn = nil end
        if hum0 and hum0.Parent then pcall(function() hum0.AutoRotate = oldAutoRotate end) end
        if hrp and hrp.Parent then
            vZero(hrp)
            if arrived and not _G.TekTPStop then
                local _, y = hrp.CFrame:ToEulerAnglesYXZ()
                hrp.CFrame = CFrame.new(waypoints[#waypoints]) * CFrame.Angles(0, y, 0)
            end
        end
    end
    local lastDist, stall = math.huge, 0
    local lastJump = 0
    local routeLength, p0 = 0, hrp.Position
    for _, wp in ipairs(waypoints) do routeLength = routeLength + (wp - p0).Magnitude; p0 = wp end
    local mayJump = routeLength >= (tonumber(_G.TekJumpMinDist) or 100)
    local _ = quickStart
    conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if done or not hrp or not hrp.Parent then finish(false); return end
        if _G.TekTPStop then finish(false); return end
        local flashHolding = false
        if _G.TekFlashTP == true and wpIdx == #waypoints
            and (waypoints[wpIdx] - hrp.Position).Magnitude <= (tonumber(_G.TekFlashPreEquip) or 50) then
            local character = LP.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local flash = character and character:FindFirstChild("Flash Teleport")
            if not flash then
                local backpack = LP:FindFirstChild("Backpack")
                flash = backpack and backpack:FindFirstChild("Flash Teleport")
            end
            if humanoid and flash then
                if flash.Parent ~= character then pcall(function() humanoid:EquipTool(flash) end) end
                flashHolding = flash.Parent == character
            end
        end
        if not flashHolding then equipCarpet() end
        if mayJump and _G.TekJumpEachStep ~= false and os.clock() - lastJump >= (tonumber(_G.TekJumpGap) or 0.2) then
            lastJump = os.clock()
            local h = hrp.Parent:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping); h.Jump = true end) end
        end
        local target = waypoints[wpIdx]
        local diff, mag = target - hrp.Position, (target - hrp.Position).Magnitude
        local speed = runSpeed
        if wpIdx < #waypoints and mag < 26 then
            local nextSegment = waypoints[wpIdx + 1] - target
            if mag > 0.1 and nextSegment.Magnitude > 0.1 and diff.Unit:Dot(nextSegment.Unit) < 0.9 then
                speed = math.min(speed, 240)
            end
        end
        local last = wpIdx == #waypoints
        if last and ease then
            speed = math.min(speed, math.max(tonumber(_G.TekArriveMin) or 150, mag * (tonumber(_G.TekArriveGain) or 30)))
        end
        local arriveRadius = last and ease and math.max(1.5, speed / 60 * 1.1)
            or math.max(MK_ARRIVE, speed / 60 * 1.25)
        if mag < arriveRadius then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish(true); return end
            lastDist, stall = math.huge, 0
            if _G.TekZeroEachStep ~= false and _vzOK() then
                pcall(function()
                    local v = hrp.AssemblyLinearVelocity
                    hrp.AssemblyLinearVelocity = Vector3.new(0, _G.TekZeroStepKeepY == false and 0 or math.max(v.Y, 0), 0)
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            target = waypoints[wpIdx]
            diff, mag = target - hrp.Position, (target - hrp.Position).Magnitude
        end
        stall = mag > lastDist - 0.05 and stall + 1 or 0
        lastDist = mag
        -- Elite ends a stalled leg by snapping to its final waypoint.
        if stall >= (tonumber(_G.TekStallFrames) or 18) then finish(true); return end
        if mag >= 0.1 then
            local dir = diff.Unit
            if (allowJump or diff.Y > 10) and diff.Y > 5 and wpIdx < #waypoints then
                local h = hrp.Parent:FindFirstChildOfClass("Humanoid")
                if h then
                    local state = h:GetState()
                    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping); h.Jump = true end)
                    end
                end
            end
            local climb = _climbCap()
            local actual = speed
            if dir.Y > 0 and dir.Y * actual > climb then actual = climb / dir.Y end
            local velocity = dir * actual
            local calmDistance = tonumber(_G.TekFlingCalm) or (TekTweenOn() and 70 or 45)
            _G.__TekFlingCalm = wpIdx == #waypoints and mag < calmDistance
            if _G.TekFlingTP == true and not _G.__TekFlingCalm then
                local flat = Vector3.new(dir.X, 0, dir.Z)
                if flat.Magnitude > 0.1 then
                    local perp = Vector3.new(-flat.Unit.Z, 0, flat.Unit.X)
                    local t = os.clock()
                    local amp = math.clamp(tonumber(_G.TekFlingAmp) or 1, 0, 3)
                    local slide = (math.sin(t * 16) * 0.8 + math.cos(t * 8) * 0.55)
                        * math.min(125, actual * 0.28) * amp
                    local waveY = (math.sin(t * 20) * 0.75 + math.cos(t * 10) * 0.5)
                        * math.min(75, actual * 0.18) * amp
                    velocity = Vector3.new(velocity.X + perp.X * slide,
                        math.clamp(velocity.Y + waveY, math.min(velocity.Y, -climb), climb),
                        velocity.Z + perp.Z * slide)
                    if velocity.Magnitude > actual then velocity = velocity.Unit * actual end
                end
            end
            _setFlightVel(hrp, velocity)
        end
    end))
    local timeout = routeLength / math.min(MK_SPEED, runSpeed) + (tonumber(_G.TekFlightGrace) or 2)
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.05)
        elapsed = elapsed + 0.05
        if not hrp or not hrp.Parent then break end
    end
    if not done and hrp and hrp.Parent and not _G.TekTPStop then finish(true) end
    if not done then finish(false) end
    return arrived
end

local function cframeStartFlyThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local gen = _G._cframeTPGen or 0
    local N = #waypoints
    if _G._cframeStartDone == gen then
        return velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    end
    _G._cframeStartDone = gen
    local startStuds = math.clamp(tonumber(_G.TekCFrameStart) or 30, 0, 30)
    local endStuds = math.clamp(tonumber(_G.TekCFrameEnd) or 30, 0, 30)
    local total, p0 = 0, hrp.Position
    for _, wp in ipairs(waypoints) do total = total + (wp - p0).Magnitude; p0 = wp end
    -- 1) START burst: exactly the first startStuds
    local si = 0
    if startStuds > 0 and total > 0 then
        if total <= startStuds then
            cframeStepThrough(hrp, waypoints, math.max(startStuds, 2))
            return
        end
        local acc, q = 0, hrp.Position
        for i, wp in ipairs(waypoints) do
            local seg = (wp - q).Magnitude
            if acc + seg >= startStuds then
                local t = (startStuds - acc) / math.max(seg, 1e-6)
                cframeStepThrough(hrp, { q:Lerp(wp, math.clamp(t, 0, 1)) }, math.max(startStuds, 2))
                si = i
                break
            end
            acc = acc + seg; q = wp
        end
        if _G.TekTPStop or not (hrp and hrp.Parent) then return end
    end
    -- 2) velocity middle, stopping exactly endStuds before dest
    local stopIdx, stopBack = 0, 0
    if endStuds > 0 and (total - math.min(startStuds, total)) > endStuds then
        local back = 0
        for i = N, 1, -1 do
            if back >= endStuds then stopIdx, stopBack = i, back; break end
            if i > 1 then back = back + (waypoints[i] - waypoints[i - 1]).Magnitude end
        end
    end
    local midFrom = (si >= 1) and si or 1
    if stopIdx >= 1 and stopIdx >= midFrom and stopIdx < N then
        local seg = (waypoints[stopIdx + 1] - waypoints[stopIdx]).Magnitude
        local t = (stopBack - endStuds) / math.max(seg, 1e-6)
        local S = waypoints[stopIdx]:Lerp(waypoints[stopIdx + 1], math.clamp(t, 0, 1))
        local mid = {}
        for i = midFrom, stopIdx do mid[#mid + 1] = waypoints[i] end
        mid[#mid + 1] = S
        velMoveThrough(hrp, mid, speedOverride, allowJump, quickStart)
        if _G.TekTPStop or not (hrp and hrp.Parent) then return end
        -- 3) END burst: exactly the last endStuds onto dest
        cframeStepThrough(hrp, { waypoints[N] }, math.max(endStuds, 2))
        return
    end
    if midFrom <= N then
        local mid = {}
        for i = midFrom, N do mid[#mid + 1] = waypoints[i] end
        velMoveThrough(hrp, mid, speedOverride, allowJump, quickStart)
    end
end

local function tpFlyThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if _G.TekCFrameTP then
        return cframeStartFlyThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    end
    return velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
end

_OTHER_CLONES = {}
do
    local _MY_CLONE = tostring(LP.UserId) .. "_Clone"
    local _seen = {}
    local function _isOtherClone(inst)
        if not inst then return false end
        local n = inst.Name
        if n == _MY_CLONE then return false end
        if n:match("^%d+_Clone$") then return true end
        if not n:find("lone", 1, true) then return false end
        if not inst:IsA("Model") then return false end
        if inst == LP.Character then return false end
        if not inst:FindFirstChild("HumanoidRootPart") then return false end
        if not inst:FindFirstChildOfClass("Humanoid") then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character == inst then return false end
        end
        return true
    end
    local function _neutralize(inst)
        if not inst or _seen[inst] then return end
        _seen[inst] = true
        _OTHER_CLONES[#_OTHER_CLONES + 1] = inst
        local function declaw(d)
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
        for _, d in ipairs(inst:GetDescendants()) do declaw(d) end
        inst.DescendantAdded:Connect(declaw)
        inst.Destroying:Connect(function()
            _seen[inst] = nil
            for i = #_OTHER_CLONES, 1, -1 do
                if _OTHER_CLONES[i] == inst then table.remove(_OTHER_CLONES, i); break end
            end
        end)
    end
    local function _scan(inst)
        if _isOtherClone(inst) then _neutralize(inst) end
    end
    for _, c in ipairs(workspace:GetChildren()) do _scan(c) end
    workspace.ChildAdded:Connect(function(c)
        _scan(c)
        task.defer(function() if c and c.Parent == workspace then _scan(c) end end)
    end)
end

do


    local _pSeen = setmetatable({}, { __mode = "k" })
    local _ncBag = setmetatable({}, { __mode = "k" })
    local function _declaw(d)
        if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
    end
    local function _declawChar(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do _declaw(d) end
        if not _pSeen[char] then
            _pSeen[char] = true
            char.DescendantAdded:Connect(_declaw)
        end
    end

    local _THEIRS = { "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso", "Head" }
    local function _noCollide(char)
        if _G.TekNoCollideConstraints == false or not char then return end
        local c = LP.Character
        local mine = c and c:FindFirstChild("HumanoidRootPart")
        if not mine then return end
        local bag = _ncBag[char]
        if not bag or bag.root ~= mine then bag = { root = mine }; _ncBag[char] = bag end
        for _, n in ipairs(_THEIRS) do
            local part = char:FindFirstChild(n)
            if part and part:IsA("BasePart") then
                local nc = bag[n]
                if not (nc and nc.Parent) then
                    pcall(function()
                        local k = Instance.new("NoCollisionConstraint")
                        k.Part0, k.Part1 = mine, part
                        k.Parent = mine
                        bag[n] = k
                    end)
                end
            end
        end
    end
    local _watched = setmetatable({}, { __mode = "k" })
    local _pinHooked = setmetatable({}, { __mode = "k" })
    local function _pin(p)
        if not p:IsA("BasePart") then return end
        if p.CanCollide then p.CanCollide = false end
        if _watched[p] then return end
        _watched[p] = true
        pcall(function()
            p:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if p.CanCollide then p.CanCollide = false end
            end)
        end)
    end
    local function _pinChar(ch)
        if not ch then return end
        for _, d in ipairs(ch:GetDescendants()) do _pin(d) end
        if not _pinHooked[ch] then
            _pinHooked[ch] = true
            ch.DescendantAdded:Connect(function(d) task.defer(_pin, d) end)
        end
    end
    local function _hookPlayer(pl)
        if pl == LP then return end
        if pl.Character then _declawChar(pl.Character); _noCollide(pl.Character); _pinChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c)
            task.wait(0.05)
            _declawChar(c)
            _noCollide(c)
            _pinChar(c)
        end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _hookPlayer(pl) end
    Players.PlayerAdded:Connect(_hookPlayer)

    LP.CharacterAdded:Connect(function()
        task.wait(0.3)
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then _noCollide(pl.Character) end
        end
    end)

    local function _pinPlayer(pl)
        if pl == LP then return end
        if pl.Character then _pinChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c) task.wait(0.15) _pinChar(c) end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _pinPlayer(pl) end
    Players.PlayerAdded:Connect(_pinPlayer)



    local _MY_CLONE_N = tostring(LP.UserId) .. "_Clone"
    local function _clones()
        local t = _OTHER_CLONES
        return (type(t) == "table") and t or {}
    end

    local _ncAcc = 0
    RunService.Stepped:Connect(function(_, dt)
        if _G.TekNoCollide == false or _G.isCloning == true then return end
        _ncAcc = _ncAcc + (dt or 0.016)
        if _ncAcc < 0.25 then return end
        _ncAcc = 0
        local c = LP.Character
        local myHrp = c and c:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local mp = myHrp.Position
        local rng = tonumber(_G.TekNoCollideRange) or 28
        for _, pl in ipairs(Players:GetPlayers()) do
            local ch = (pl ~= LP) and pl.Character
            local h = ch and ch:FindFirstChild("HumanoidRootPart")
            if h and (h.Position - mp).Magnitude <= rng then
                for _, d in ipairs(ch:GetDescendants()) do
                    if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                end
            end
        end
        for _, cl in ipairs(_clones()) do
            if cl and cl.Parent and cl.Name ~= _MY_CLONE_N then
                local h = cl:FindFirstChild("HumanoidRootPart")
                if h and (h.Position - mp).Magnitude <= rng then
                    for _, d in ipairs(cl:GetDescendants()) do
                        if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            if _G.TekNoCollide ~= false and _G.isCloning ~= true then
                for _, pl in ipairs(Players:GetPlayers()) do
                    local ch = (pl ~= LP) and pl.Character
                    if ch then _pinChar(ch) end
                end
                for _, cl in ipairs(_clones()) do
                    if cl and cl.Parent and cl.Name ~= _MY_CLONE_N then _pinChar(cl) end
                end
            end
        end
    end)
end
local _len
do
local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _STRUCT = { ["structure base home"] = true, ["Wall"] = true, ["Floor"] = true, ["Roof"] = true }
local _SKIP_NAME = { ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true }
local function _blocks(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
    return false
end
local function _blocksWide(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 30 then return true end
    return false
end
local function _block(origin, target, blockFn)
    blockFn = blockFn or _blocks
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if not res then return nil end
        if blockFn(res.Instance) then return res end
        skip[#skip + 1] = res.Instance
        o = res.Position + d.Unit * 0.3
    end
    return nil
end
local function _clear(a, b) return _block(a, b) == nil end
local function _clearDist(origin, dir, maxD)
    local res = _block(origin, origin + dir.Unit * maxD)
    if not res then return maxD end
    return (res.Position - origin).Magnitude
end
function _len(pts)
    local s, prev = 0, pts[1]
    for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
    return s
end
local function _pull(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clear(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end
local function _stages(toPos)
    local st = {}
    for _, dr in ipairs(_DIRS) do
        local cd = _clearDist(toPos, dr, 46)
        if cd >= 12 then st[#st + 1] = toPos + dr * math.min(cd - 5, 38) end
    end
    return st
end
local function _routeClear(pts)
    for i = 1, #pts - 1 do
        if not _clear(pts[i], pts[i + 1]) then return false end
    end
    return true
end
local function _peakY(pts)
    local m = -math.huge
    for _, p in ipairs(pts) do if p.Y > m then m = p.Y end end
    return m
end
local function _starts(fromPos)
    local pts = { fromPos }
    if _block(fromPos, fromPos + Vector3.new(0, 40, 0)) then
        for _, dr in ipairs(_DIRS) do
            local cd = _clearDist(fromPos, dr, 40)
            if cd >= 12 then pts[#pts + 1] = fromPos + dr * math.min(cd - 5, 34) end
        end
    end
    return pts
end

local function _candidates(sp, stage, toPos)
    local list = {}
    local function add(mid)
        if mid then list[#list + 1] = { sp, mid, stage, toPos }
        else list[#list + 1] = { sp, stage, toPos } end
    end
    add(nil)
    add(Vector3.new(stage.X, sp.Y, stage.Z))
    add(Vector3.new(sp.X, stage.Y, sp.Z))
    local dir = Vector3.new(stage.X - sp.X, 0, stage.Z - sp.Z)
    if dir.Magnitude > 0.1 then
        dir = dir.Unit
        local perp = Vector3.new(-dir.Z, 0, dir.X)
        for _, off in ipairs({ 20, -20, 40, -40 }) do
            add(sp + perp * off)
        end
    end
    return list
end

local PathfindingService = game:GetService("PathfindingService")
local _CLEARANCE = 16
local function _clearWideRay(a, b)
    return _block(a, b, _blocksWide) == nil
end

local _SWEEP_R = 4
local _ENDPOINT_SLACK = 6
local _canSphere = nil
local function _sweepBlockFn(inst)
    if _G.TekStrictSweep == false then return _blocks(inst) end
    return _blocksWide(inst)
end
local function _sweepDir(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = a
    for _ = 1, 24 do
        rp.FilterDescendantsInstances = skip
        local d = b - o
        if d.Magnitude < 0.05 then return false end
        local res
        local ok = pcall(function() res = workspace:Spherecast(o, _SWEEP_R, d, rp) end)
        if not ok then _canSphere = false; return nil end
        if not res then return false end
        if _sweepBlockFn(res.Instance) then return true end
        skip[#skip + 1] = res.Instance
        local adv = (res.Distance or 0) - 0.05
        if adv > 0 then o = o + d.Unit * math.min(adv, d.Magnitude) end
    end
    return true
end
local function _sweepBlocked(a, b, slackA, slackB)
    if _canSphere == nil then
        _canSphere = pcall(function()
            workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
        end)
    end
    if not _canSphere then return nil end
    local d = b - a
    local len = d.Magnitude
    if len < 0.1 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or _ENDPOINT_SLACK, len * 0.4)
    local b2 = b - u * math.min(slackB or _ENDPOINT_SLACK, len * 0.4)
    local fwd = _sweepDir(a2, b2)
    if fwd == nil then return nil end
    if fwd then return true end
    local rev = _sweepDir(b2, a2)
    if rev == nil then return nil end
    return rev
end

local function _clearWide(a, b, slackA, slackB)
    if not _clear(a, b) then return false end
    local sw = _sweepBlocked(a, b, slackA, slackB)
    if sw ~= nil then return not sw end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        local ox = Vector3.new(_CLEARANCE, 0, 0)
        local oz = Vector3.new(0, 0, _CLEARANCE)
        return _clearWideRay(a + ox, b + ox) and _clearWideRay(a - ox, b - ox)
            and _clearWideRay(a + oz, b + oz) and _clearWideRay(a - oz, b - oz)
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * _CLEARANCE
    local up = Vector3.new(0, _CLEARANCE, 0)
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + up, b + up)
        and _clearWideRay(a - up, b - up)
end

local function _crestClear(a, b)
    if not _clear(a, b) then return false end
    local cl = tonumber(_G.TekCrestClearance) or 6
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        return true
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * cl
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + Vector3.new(0, cl, 0), b + Vector3.new(0, cl, 0))
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    local n = #pts
    while i < n do
        local j = n
        while j > i + 1 do
            local a, b = out[#out], pts[j]
            local sA = (i == 1) and _ENDPOINT_SLACK or 0
            local sB = (j == n) and _ENDPOINT_SLACK or 0
            if _clearWide(a, b, sA, sB) then break end
            j = j - 1
        end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end

local function _pushOffWalls(pts)
    if #pts <= 2 then return pts end
    local MARGIN = 8
    local MAX_PUSH = 12
    local out = { pts[1] }
    for i = 2, #pts - 1 do
        local p = pts[i]
        local shift = Vector3.zero
        for _, dr in ipairs(_DIRS) do
            local res = _block(p, p + dr * MARGIN, _blocks)
            if res then
                local dist = (res.Position - p).Magnitude
                if dist < MARGIN then
                    shift = shift - dr * (MARGIN - dist)
                end
            end
        end
        do
            local resUp = _block(p, p + Vector3.new(0, MARGIN, 0), _blocks)
            if resUp then
                local dist = (resUp.Position - p).Magnitude
                if dist < 4 then shift = shift + Vector3.new(0, -(4 - dist), 0) end
            end
        end
        if shift.Magnitude > 0.1 then
            if shift.Magnitude > MAX_PUSH then shift = shift.Unit * MAX_PUSH end
            local moved = p + shift
            if _clear(out[#out], moved) then
                out[#out + 1] = moved
            else
                out[#out + 1] = p
            end
        else
            out[#out + 1] = p
        end
    end
    out[#out + 1] = pts[#pts]
    return out
end


do
local _vxFloor, _vxSqrt = math.floor, math.sqrt
local _vxMin, _vxMax = math.min, math.max
local function _vxAbs(n) return n < 0 and -n or n end

local _vxOverlap = OverlapParams.new()
_vxOverlap.FilterType = Enum.RaycastFilterType.Exclude
_vxOverlap.RespectCanCollide = true

local _vxCast = RaycastParams.new()
_vxCast.FilterType = Enum.RaycastFilterType.Exclude
_vxCast.RespectCanCollide = true
_vxCast.IgnoreWater = true

local _vxOrigin
local _vxDimX, _vxDimY, _vxDimZ = 0, 0, 0
local _vxSz, _vxInflate = 4, 2.5
local _vxSolid = {}
local _vxHeight = 5

local function _vxWorld(sz, x, y, z)
    local h = sz * 0.5
    return Vector3.new(_vxOrigin.X + x * sz + h, _vxOrigin.Y + y * sz + h, _vxOrigin.Z + z * sz + h)
end
local function _vxKey(x, y, z) return x + y * 1024 + z * 1048576 end

local function _vxIsSolid(x, y, z)
    if x < 0 or y < 0 or z < 0 or x >= _vxDimX or y >= _vxDimY or z >= _vxDimZ then return true end
    local k = _vxKey(x, y, z)
    local c = _vxSolid[k]
    if c ~= nil then return c end
    local h = _vxSz * 0.5
    local cx = _vxOrigin.X + x * _vxSz + h
    local cy = _vxOrigin.Y + y * _vxSz + h
    local cz = _vxOrigin.Z + z * _vxSz + h
    local sxz = _vxSz + _vxInflate
    local vy = _vxHeight > _vxSz and _vxHeight or _vxSz
    local vcy = cy - h + vy * 0.5
    local parts = workspace:GetPartBoundsInBox(CFrame.new(cx, vcy, cz), Vector3.new(sxz, vy, sxz), _vxOverlap)
    local solid = #parts > 0
    _vxSolid[k] = solid
    return solid
end

local function _vxSegClear(from, to, radius, height, sample)
    local dir = to - from
    local mag = dir.Magnitude
    if mag < 0.05 then return true end
    if workspace:Raycast(from, dir, _vxCast) then return false end
    local r = radius > 1 and radius or 1
    if workspace:Blockcast(CFrame.new(from), Vector3.new(r * 2, height, r * 2), dir, _vxCast) ~= nil then return false end
    local n = _vxFloor(mag)
    if sample ~= false and n >= 2 then
        local step = dir / n
        local torso = Vector3.new(r * 2, 3, r * 2)
        for i = 1, n - 1 do
            local pt = from + step * i
            if #workspace:GetPartBoundsInBox(CFrame.new(pt), torso, _vxOverlap) > 0 then return false end
        end
    end
    return true
end

local _vxNeigh = {}
do
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                if dx ~= 0 or dy ~= 0 or dz ~= 0 then
                    local nz = (dx ~= 0 and 1 or 0) + (dy ~= 0 and 1 or 0) + (dz ~= 0 and 1 or 0)
                    local kd = dx + dy * 1024 + dz * 1048576
                    _vxNeigh[#_vxNeigh + 1] = { dx, dy, dz, _vxSqrt(dx * dx + dy * dy + dz * dz), nz, kd }
                end
            end
        end
    end
end

local function _vxNoCorner(cx, cy, cz, off)
    if off[5] < 2 then return true end
    if off[1] ~= 0 and _vxIsSolid(cx + off[1], cy, cz) then return false end
    if off[2] ~= 0 and _vxIsSolid(cx, cy + off[2], cz) then return false end
    if off[3] ~= 0 and _vxIsSolid(cx, cy, cz + off[3]) then return false end
    return true
end

local function _vxSnapGoal(goalPos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and (_vxWorld(_vxSz, nx, ny, nz) - goalPos).Magnitude <= 8 then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end
local function _vxSnapStart(pos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and not workspace:Raycast(pos, _vxWorld(_vxSz, nx, ny, nz) - pos, _vxCast) then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end

local function _vxPush(h, f, key)
    local i = #h + 1
    h[i] = { f, key }
    while i > 1 do
        local p = _vxFloor(i * 0.5)
        if h[p][1] <= h[i][1] then break end
        h[p], h[i] = h[i], h[p]
        i = p
    end
end
local function _vxPop(h)
    local n = #h
    if n == 0 then return nil end
    local top = h[1]
    h[1] = h[n]
    h[n] = nil
    n -= 1
    local i = 1
    while true do
        local l, r, s = i + i, i + i + 1, i
        if l <= n and h[l][1] < h[s][1] then s = l end
        if r <= n and h[r][1] < h[s][1] then s = r end
        if s == i then break end
        h[i], h[s] = h[s], h[i]
        i = s
    end
    return top[2]
end

local _vxHeurW = 2
local function _vxAStar(sz, startCell, goalCell, startPos, goalPos)
    local sx, sy, sz2 = _vxSnapStart(startPos, startCell.x, startCell.y, startCell.z)
    local gx, gy, gz = _vxSnapGoal(goalPos, goalCell.x, goalCell.y, goalCell.z)
    local goalKey = _vxKey(gx, gy, gz)
    local startKey = _vxKey(sx, sy, sz2)

    local nodes = { [startKey] = { x = sx, y = sy, z = sz2, g = 0, parent = nil } }
    local closed = {}
    local heap = {}
    _vxPush(heap, 0, startKey)

    local function Heur(x, y, z)
        local ax, ay, az = x - gx, y - gy, z - gz
        return _vxSqrt(ax * ax + ay * ay + az * az)
    end

    local pops = 0
    while #heap > 0 do
        local curKey = _vxPop(heap)
        if closed[curKey] then continue end
        closed[curKey] = true
        pops += 1
        if pops > 300000 then break end

        local cur = nodes[curKey]
        if curKey == goalKey then
            local path = {}
            local n = cur
            while n do
                path[#path + 1] = _vxWorld(sz, n.x, n.y, n.z)
                n = n.parent and nodes[n.parent]
            end
            local rev = {}
            for i = #path, 1, -1 do rev[#rev + 1] = path[i] end
            return rev
        end

        local cx, cy, cz = cur.x, cur.y, cur.z
        local cg = cur.g
        for _, off in _vxNeigh do
            local nk = curKey + off[6]
            if closed[nk] then continue end
            local nx, ny, nz = cx + off[1], cy + off[2], cz + off[3]
            if _vxIsSolid(nx, ny, nz) then continue end
            if not _vxNoCorner(cx, cy, cz, off) then continue end
            local tg = cg + off[4]
            local ex = nodes[nk]
            if not ex or tg < ex.g then
                if ex then
                    ex.g, ex.parent, ex.x, ex.y, ex.z = tg, curKey, nx, ny, nz
                else
                    nodes[nk] = { x = nx, y = ny, z = nz, g = tg, parent = curKey }
                end
                _vxPush(heap, tg + _vxHeurW * Heur(nx, ny, nz), nk)
            end
        end
    end
    return nil
end

local function _vxSimplify(path, radius, height)
    if not path or #path < 3 then return path end
    local out = { path[1] }
    local anchor = 1
    local i = 2
    while i <= #path do
        if not _vxSegClear(path[anchor], path[i + 1] or path[i], radius, height, false) then
            out[#out + 1] = path[i]
            anchor = i
        end
        i += 1
    end
    out[#out + 1] = path[#path]
    return out
end

voxelRoute = function(fromPos, toPos)
    local char = LP.Character
    local _flt = char and { char } or {}
    for _, cl in ipairs(_OTHER_CLONES) do _flt[#_flt + 1] = cl end
    _vxOverlap.FilterDescendantsInstances = _flt
    _vxCast.FilterDescendantsInstances = _flt

    local sz      = tonumber(_G.TekPathCell)   or 4
    local inflate = tonumber(_G.TekPathRadius) or 2.5
    local height  = tonumber(_G.TekPathHeight) or 5
    local pad     = tonumber(_G.TekPathPad)    or 40

    _vxSz, _vxInflate, _vxHeight = sz, inflate, height
    table.clear(_vxSolid)

    local mn = Vector3.new(_vxMin(fromPos.X, toPos.X), _vxMin(fromPos.Y, toPos.Y), _vxMin(fromPos.Z, toPos.Z)) - Vector3.new(pad, pad, pad)
    local mx = Vector3.new(_vxMax(fromPos.X, toPos.X), _vxMax(fromPos.Y, toPos.Y), _vxMax(fromPos.Z, toPos.Z)) + Vector3.new(pad, pad, pad)
    _vxOrigin = mn
    local size = mx - mn
    _vxDimX = _vxFloor(size.X / sz) + 1
    _vxDimY = _vxFloor(size.Y / sz) + 1
    _vxDimZ = _vxFloor(size.Z / sz) + 1
    if _vxDimX * _vxDimY * _vxDimZ > 200000 then return nil end

    local startCell = {
        x = _vxFloor((fromPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((fromPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((fromPos.Z - _vxOrigin.Z) / sz),
    }
    local goalCell = {
        x = _vxFloor((toPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((toPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((toPos.Z - _vxOrigin.Z) / sz),
    }

    local path = _vxAStar(sz, startCell, goalCell, fromPos, toPos)
    if not path then return nil end
    path = _vxSimplify(path, inflate, height)
    if not path or #path == 0 then return nil end

    local route = {}
    for idx = 2, #path do route[#route + 1] = path[idx] end
    if #route == 0 or (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return route
end

end

_G.TekVoxelRoute = voxelRoute

local _MAP_CENTER = { minX = -458, maxX = -362, minZ = -40, maxZ = 185 }
local _BYPASS_Z_NORTH, _BYPASS_Z_SOUTH = 205, -95
local _BYPASS_X_WEST,  _BYPASS_X_EAST  = -525, -295

local function _inCenterZone(x, z)
    return x >= _MAP_CENTER.minX and x <= _MAP_CENTER.maxX
       and z >= _MAP_CENTER.minZ and z <= _MAP_CENTER.maxZ
end

local function _segmentCrossesCenter(a, b)
    if _inCenterZone(a.X, a.Z) or _inCenterZone(b.X, b.Z) then return true end
    for i = 1, 10 do
        local t = i / 11
        if _inCenterZone(a.X + (b.X - a.X) * t, a.Z + (b.Z - a.Z) * t) then return true end
    end
    return false
end

local function _findBestCenterDetour(fromPos, toPos, y)
    local candidates = {
        { Vector3.new(fromPos.X, y, _BYPASS_Z_NORTH), Vector3.new(toPos.X, y, _BYPASS_Z_NORTH) },
        { Vector3.new(fromPos.X, y, _BYPASS_Z_SOUTH), Vector3.new(toPos.X, y, _BYPASS_Z_SOUTH) },
        { Vector3.new(_BYPASS_X_WEST, y, fromPos.Z), Vector3.new(_BYPASS_X_WEST, y, toPos.Z) },
        { Vector3.new(_BYPASS_X_EAST, y, fromPos.Z), Vector3.new(_BYPASS_X_EAST, y, toPos.Z) },
    }
    local best, bestLen = nil, math.huge
    for _, pair in ipairs(candidates) do
        local w1, w2 = pair[1], pair[2]
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.TekSegmentCrossesCenter = _segmentCrossesCenter
_G.TekFindCenterDetour     = _findBestCenterDetour

local function _rowBoxX() return tonumber(_G.TekRowBoxX) or 26 end
local function _rowBoxZ() return tonumber(_G.TekRowBoxZ) or 30 end
local function _rowLane() return tonumber(_G.TekRowLane) or 30 end

local function _nearestBase(p)
    local bi, bd = nil, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (p.X - b.X) ^ 2 + (p.Z - b.Z) ^ 2
        if d < bd then bd = d; bi = i end
    end
    if bd > 70 * 70 then return nil end
    return bi
end

local function _segmentHitsOtherBase(a, b, ignA, ignB)
    local hx, hz = _rowBoxX(), _rowBoxZ()
    for i = 0, 24 do
        local t = i / 24
        local px = a.X + (b.X - a.X) * t
        local pz = a.Z + (b.Z - a.Z) * t
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB then
                local bs = BASES_LOW[k]
                if math.abs(px - bs.X) <= hx and math.abs(pz - bs.Z) <= hz then
                    return true
                end
            end
        end
    end
    return false
end

local function _findRowDetour(fromPos, toPos, y)
    local iFrom, iTo = _nearestBase(fromPos), _nearestBase(toPos)
    if not _segmentHitsOtherBase(fromPos, toPos, iFrom, iTo) then return nil end

    local colX = BASES_LOW[iTo or 1].X
    local off  = _rowLane()
    local lanes = {}
    local outer = (colX < COLUMN_SPLIT_X) and (colX - off) or (colX + off)
    lanes[#lanes + 1] = outer
    local inner = (colX < COLUMN_SPLIT_X) and (colX + off) or (colX - off)
    if not _inCenterZone(inner, (fromPos.Z + toPos.Z) * 0.5) then
        lanes[#lanes + 1] = inner
    end

    local best, bestLen = nil, math.huge
    for _, laneX in ipairs(lanes) do
        local w1 = Vector3.new(laneX, y, fromPos.Z)
        local w2 = Vector3.new(laneX, y, toPos.Z)
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos)
           and not _segmentHitsOtherBase(w1, w2, iFrom, iTo) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.TekFindRowDetour = _findRowDetour

local _hopRP = RaycastParams.new()
_hopRP.FilterType = Enum.RaycastFilterType.Exclude

local function _partTopY(inst)
    local ok, t = pcall(function()
        local cf, sz = inst.CFrame, inst.Size
        local half = (math.abs(cf.RightVector.Y) * sz.X
            + math.abs(cf.UpVector.Y) * sz.Y
            + math.abs(cf.LookVector.Y) * sz.Z) / 2
        return cf.Position.Y + half
    end)
    if ok and t then return t end
    return inst.Position.Y + (inst.Size.Y / 2)
end

local function _hopBlockerTop(a, b)
    local ignore = { LP.Character }
    for _, cl in ipairs(_OTHER_CLONES) do ignore[#ignore + 1] = cl end
    local top = nil
    for _ = 1, 10 do
        _hopRP.FilterDescendantsInstances = ignore
        local r = workspace:Raycast(a, b - a, _hopRP)
        if not r then break end
        if _blocks(r.Instance) then
            local t = _partTopY(r.Instance)
            if not top or t > top then top = t end
        end
        ignore[#ignore + 1] = r.Instance
    end
    return top
end

local function _hopRoute(fromPos, toPos)
    local flat = Vector3.new(toPos.X - fromPos.X, 0, toPos.Z - fromPos.Z)
    local dist = flat.Magnitude
    if dist < 8 then return nil end
    local dir = flat.Unit
    local step = tonumber(_G.TekHopStep) or 8
    local clear = tonumber(_G.TekHopClear) or 4
    local maxUp = tonumber(_G.TekHopMaxUp) or 22
    local groundY = fromPos.Y
    local route = {}
    local inHop, hopY, hopStart = false, nil, nil
    local i = step
    while i <= dist do
        local a = fromPos + dir * (i - step)
        local b = fromPos + dir * math.min(i, dist)
        local ga = Vector3.new(a.X, groundY, a.Z)
        local gb = Vector3.new(b.X, groundY, b.Z)
        if not _clear(ga, gb) then
            local top = _hopBlockerTop(ga, gb) or (groundY + 6)
            local want = top + clear
            if want - groundY > maxUp then return nil end
            if not inHop then
                inHop, hopY, hopStart = true, want, ga
                route[#route + 1] = Vector3.new(a.X, want, a.Z)
            elseif want > hopY then
                hopY = want
                route[#route + 1] = Vector3.new(a.X, want, a.Z)
            end
        elseif inHop then
            inHop = false
            route[#route + 1] = Vector3.new(b.X, hopY, b.Z)
            route[#route + 1] = gb
        end
        i = i + step
    end
    if inHop then
        route[#route + 1] = Vector3.new(toPos.X, hopY, toPos.Z)
    end
    route[#route + 1] = toPos
    return route
end
_G.TekHopRoute = _hopRoute

function computeRoute(fromPos, toPos, facingDir, maxLift, preferCrest)
    local _ = maxLift

    if _G.TekHopFirst == true and not _clearWide(fromPos, toPos) then
        local hop = _hopRoute(fromPos, toPos)
        if hop and #hop > 0 then return hop end
    end

    if _G.TekCrestFirst == true and not _clearWide(fromPos, toPos) then
        local baseY = math.max(fromPos.Y, toPos.Y, 26)
        local lifts = { tonumber(_G.TekCrestLift) or 12, 20, 30, 44, 60 }
        for _, lift in ipairs(lifts) do
            local cruiseY = baseY + lift
            local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
            local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
            local crest = { fromPos, up, over, toPos }
            local ok = true
            for i = 1, #crest - 1 do
                local a, b = crest[i], crest[i + 1]
                if (a - b).Magnitude > 0.5 then
                    if not _crestClear(a, b) then ok = false; break end
                end
            end
            if ok then return crest end
        end
    end

    local centerPatch = nil
    if _segmentCrossesCenter(fromPos, toPos) and not _clearWide(fromPos, toPos) then
        centerPatch = _findBestCenterDetour(fromPos, toPos, fromPos.Y)
        if centerPatch and #centerPatch > 0 then
            fromPos = centerPatch[#centerPatch]
        end
    end
    local rowPatch = _findRowDetour(fromPos, toPos, fromPos.Y)
    if rowPatch and #rowPatch > 0 then
        fromPos = rowPatch[#rowPatch]
    end

    local function _withPatch(route)
        if (not centerPatch or #centerPatch == 0)
           and (not rowPatch or #rowPatch == 0) then return route end
        local merged = {}
        if centerPatch then for _, p in ipairs(centerPatch) do merged[#merged + 1] = p end end
        if rowPatch    then for _, p in ipairs(rowPatch)    do merged[#merged + 1] = p end end
        for _, p in ipairs(route) do merged[#merged + 1] = p end
        return merged
    end

    if _clearWide(fromPos, toPos) then return _withPatch({ toPos }) end

    if preferCrest then
        local cruiseY = math.max(fromPos.Y, toPos.Y, 26) + 12
        local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
        local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
        local crest = { fromPos, up, over, toPos }
        local ok = true
        for i = 1, #crest - 1 do
            local a, b = crest[i], crest[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == #crest - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then ok = false; break end
            end
        end
        if ok then return _withPatch(crest) end
    end

    do
        local vr = voxelRoute(fromPos, toPos)
        if vr and #vr > 0 then return _withPatch(vr) end
    end

    local entry = facingDir and (toPos - facingDir * 14) or toPos

    local best, bestLen = nil, math.huge
    local function consider(pts)
        if not pts or #pts < 2 then return end
        local n = #pts
        for i = 1, n - 1 do
            local a, b = pts[i], pts[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == n - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then return end
            end
        end
        local pulled = _pullWide(pts)
        local L = _len(pulled)
        if L < bestLen then best, bestLen = pulled, L end
    end

    do
        local dirF = Vector3.new(entry.X - fromPos.X, 0, entry.Z - fromPos.Z)
        if dirF.Magnitude > 0.1 then
            dirF = dirF.Unit
            local perp = Vector3.new(-dirF.Z, 0, dirF.X)
            local midBase = (fromPos + entry) * 0.5
            for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
                consider({ fromPos, midBase + perp * off, entry })
                consider({ fromPos, fromPos + perp * off, entry + perp * off, entry })
            end
        end
    end

    local navRaw
    if not best then
        local groundTo = Vector3.new(entry.X, fromPos.Y, entry.Z)
        local path = PathfindingService:CreatePath({
            AgentRadius = 16, AgentHeight = 5, AgentCanJump = true, AgentJumpHeight = 10, AgentMaxSlope = 89,
        })
        local FLOAT = 5
        local nav = { fromPos }
        local ok = pcall(function()
            path:ComputeAsync(Vector3.new(fromPos.X, fromPos.Y, fromPos.Z), groundTo)
        end)
        if ok and path.Status == Enum.PathStatus.Success then
            local last = fromPos
            for _, wp in ipairs(path:GetWaypoints()) do
                if (wp.Position - last).Magnitude >= 8 then
                    nav[#nav + 1] = wp.Position + Vector3.new(0, FLOAT, 0)
                    last = wp.Position
                end
            end
        end
        nav[#nav + 1] = entry + Vector3.new(0, FLOAT, 0)
        nav = _pushOffWalls(nav)
        navRaw = nav
        consider(nav)
    end

    local route = best
    if not route and _clear(fromPos, toPos) then route = { toPos } end
    if not route and navRaw then route = _pullWide(navRaw) end
    if not route then route = { toPos } end
    if (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return _withPatch(route)
end
end

function equipTool(name)
    local char = LP.Character
    if not char or char:FindFirstChild(name) then return char ~= nil end
    local bp = LP:FindFirstChild("Backpack")
    if not bp then return false end
    local tool = bp:FindFirstChild(name)
    if tool and tool:IsA("Tool") then tool.Parent = char; return true end
    return false
end

function unequipAll()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then t.Parent = bp end
    end
end

-- Reset must temporarily release Anti-Die.  Keeping the recovery hook active
-- while Roblox is killing the old Humanoid can cancel the reset completely.
local _tekInstantResetBusy = false
function _G.TekInstantReset()
    if _tekInstantResetBusy then return false end
    local oldCharacter = LP.Character
    local hum = oldCharacter and oldCharacter:FindFirstChildOfClass("Humanoid")
    if not oldCharacter or not hum then return false end

    _tekInstantResetBusy = true
    local antiDieWasDisabled = _G.AntiDieDisabled == true
    _G.Tek_IsResetting = true
    if type(_G.TekReleaseAutoBuyFollow)=="function" then pcall(_G.TekReleaseAutoBuyFollow) end
    _G.AntiDieDisabled = true
    _G.TekTPStop = true
    isTeleporting = false

    task.spawn(function()
        RunService.Heartbeat:Wait()
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        pcall(function() hum.Health = 0 end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
        pcall(function() oldCharacter:BreakJoints() end)

        local deadline = os.clock() + 10
        repeat task.wait(0.05)
        until LP.Character ~= oldCharacter or os.clock() >= deadline

        if LP.Character ~= oldCharacter then
            local newHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if not newHum and LP.Character then
                pcall(function() newHum = LP.Character:WaitForChild("Humanoid", 5) end)
            end
            task.wait(0.1)
        end
        _G.AntiDieDisabled = antiDieWasDisabled
        _G.Tek_IsResetting = false
        _G.TekTPStop = false
        _tekInstantResetBusy = false
    end)
    return true
end

function doClone()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return false end

    local cloner = (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Quantum Cloner"))
                or char:FindFirstChild("Quantum Cloner")
    if not cloner then return false end

    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait(0.06)
    end

    local useItem = getRemote("RemoteEvent", "UseItem")
    local onTel   = getRemote("RemoteEvent", "QuantumCloner/OnTeleport")
    if not useItem or not onTel then return false end

    _G.isCloning = true
    local useOk = pcall(function() useItem:FireServer() end)
    task.wait(0.03)
    local telOk = pcall(function() onTel:FireServer() end)
    task.wait(0.18)
    pcall(function() hum:UnequipTools() end)
    task.delay(0.4, function() _G.isCloning = false end)

    return useOk and telOk
end

-- Equip FlashTeleport, aim its real Mouse.Hit at the requested world point and
-- perform the same physical click as the player. With no targetPos it uses the
-- player's current cursor, which also makes this function useful from a keybind.
local function flashTeleportLog(message)
    pcall(function()
        if appendfile then
            appendfile("tek_flash_tp_debug.txt", string.format("[%s] %s | job=%s\n",
                os.date("%H:%M:%S"), message, tostring(game.JobId)))
        end
    end)
end
local flashControllerReady = setmetatable({}, {__mode = "k"})
local function performFlashTeleport(targetPos, cleanup, cameraOrigin)
    if _G.Tek_IsResetting then return false end
    if type(_G.TekPrepareFlashTeleport) == "function" then
        if _G.TekPrepareFlashTeleport() ~= true then
            flashTeleportLog("PREPARATION NOT READY")
            return false
        end
    end
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local bp = LP:FindFirstChild("Backpack")
    if not char or not hum or not hrp then
        flashTeleportLog("NO CHARACTER")
        return false
    end

    local function findFlash(container)
        if not container then return nil end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool")
                and string.lower(item.Name):gsub("[^%w]", "") == "flashteleport" then
                return item
            end
        end
        return nil
    end
    local tool = findFlash(char) or findFlash(bp)
    if not (tool and tool:IsA("Tool")) then
        flashTeleportLog("NO FLASH TOOL")
        return false
    end

    _G.TekFlashTeleportActive = true
    _G.TekFlashTeleportSafeUntil = os.clock() + 5
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)

    local function restartToolController()
        local scripts = {}
        for _, item in ipairs(tool:GetDescendants()) do
            if item:IsA("LocalScript") then scripts[#scripts + 1] = item end
        end
        for _, scriptObject in ipairs(scripts) do
            pcall(function() scriptObject.Disabled = true end)
        end
        RunService.Heartbeat:Wait()
        for _, scriptObject in ipairs(scripts) do
            if scriptObject.Parent then pcall(function() scriptObject.Disabled = false end) end
        end
        -- Give restarted listeners time to bind Equipped/Activated/Mouse.
        local readyAt = os.clock() + 0.18
        repeat RunService.Heartbeat:Wait() until os.clock() >= readyAt
        flashTeleportLog("CONTROLLER REFRESH scripts=" .. tostring(#scripts))
    end
    local function cycleEquip(refreshController)
        if tool.Parent == char then
            pcall(function() tool:Deactivate() end)
            pcall(function() hum:UnequipTools() end)
            local deadline = os.clock() + 0.75
            repeat RunService.Heartbeat:Wait()
            until tool.Parent ~= char or LP.Character ~= char or os.clock() >= deadline
        end
        if LP.Character ~= char or not tool.Parent then return false end
        if refreshController then restartToolController() end
        pcall(function() hum:EquipTool(tool) end)
        local untilAt = os.clock() + 1
        repeat RunService.Heartbeat:Wait()
        until tool.Parent == char or LP.Character ~= char or os.clock() >= untilAt
        if tool.Parent ~= char then
            pcall(function() tool.Parent = char end)
            RunService.Heartbeat:Wait()
        end
        return tool.Parent == char and LP.Character == char
    end

    -- The first spawned character can inherit a tool whose LocalScript started
    -- before the mouse/controller was ready. A respawn fixes it by creating a
    -- fresh controller; restart that controller here instead.
    if not flashControllerReady[char] then
        if not cycleEquip(true) then
            flashTeleportLog("INITIAL CONTROLLER REFRESH FAILED")
            return false
        end
        flashControllerReady[char] = true
    elseif tool.Parent ~= char then
        if not cycleEquip(false) then return false end
    end
    -- On initial spawn the tool's client listeners may connect after parenting.
    RunService.Heartbeat:Wait()
    RunService.Heartbeat:Wait()
    if _G.Tek_IsResetting or LP.Character ~= char then return false end
    -- Equipping and the item's cooldown can finish on different frames.
    local readyUntil = os.clock() + 1.5
    while tool.Parent == char and not tool.Enabled and LP.Character == char
        and os.clock() < readyUntil do
        RunService.Heartbeat:Wait()
    end
    if tool.Parent ~= char or not tool.Enabled or LP.Character ~= char then
        flashTeleportLog("EQUIP FAILED parent=" .. tostring(tool.Parent) .. " enabled=" .. tostring(tool.Enabled))
        _G.TekFlashTeleportActive = false
        _G.TekFlashTeleportSafeUntil = os.clock() + 1
        return false
    end

    local camera = workspace.CurrentCamera
    local oldCameraCF = camera and camera.CFrame
    cleanup.camera = camera
    cleanup.cameraCF = targetPos and oldCameraCF or nil
    local clickX, clickY
    if targetPos and camera then
        local aim = targetPos + Vector3.new(0, 1.5, 0)
        local camPos = cameraOrigin or camera.CFrame.Position
        if (aim - camPos).Magnitude > 0.01 then
            camera.CFrame = CFrame.lookAt(camPos, aim)
        end
        RunService.RenderStepped:Wait()
        RunService.RenderStepped:Wait()
        local screen = camera:WorldToViewportPoint(aim)
        local inset = GuiService:GetGuiInset()
        clickX = math.floor(screen.X + inset.X + 0.5)
        clickY = math.floor(screen.Y + inset.Y + 0.5)
        pcall(function() VIM:SendMouseMoveEvent(clickX, clickY, game) end)
        task.wait(0.03)
    else
        -- The V key uses the player's current aim. Tool:Activate() alone does
        -- not deliver the mouse click consumed by Flash Teleport's client code.
        local cursor = UIS:GetMouseLocation()
        clickX = math.floor(cursor.X + 0.5)
        clickY = math.floor(cursor.Y + 0.5)
    end

    -- Elite waits briefly for a grounded Flash Teleport before firing.
    local groundWait = math.clamp(tonumber(_G.TekFlashGroundWait) or 0.12, 0, 0.25)
    local groundStarted = os.clock()
    if hum.FloorMaterial == Enum.Material.Air then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed) end)
    end
    while hum.Parent and hum.FloorMaterial == Enum.Material.Air
        and os.clock() - groundStarted < groundWait do
        RunService.Heartbeat:Wait()
    end
    local activated = false
    local activationConn = tool.Activated:Connect(function() activated = true end)
    cleanup.activationConn = activationConn
    local moved = false
    local clickDownOk, clickUpOk = false, false
    local attempts = 0
    for attempt = 1, 2 do
        if _G.Tek_IsResetting or LP.Character ~= char or not tool.Parent then break end
        if attempt > 1 then
            -- A click can reach the tool while its teleport is still on cooldown.
            -- Give it a short recovery window and refresh the in-game aim.
            task.wait(0.18)
            local readyAt = os.clock() + 0.9
            repeat RunService.Heartbeat:Wait()
            until tool.Enabled or not tool.Parent or os.clock() >= readyAt
            -- Re-run Equipped before retrying; some tool controllers consume
            -- the first click without rebuilding their mouse reference.
            if not cycleEquip(false) then break end
            if tool.Parent ~= char or not tool.Enabled then break end
            if targetPos and camera and camera.Parent then
                -- The first ray can land on a ledge or another nearby surface.
                -- Raise the second aim slightly instead of repeating that ray.
                local aim = targetPos + Vector3.new(0, 3, 0)
                local camPos = camera.CFrame.Position
                if (aim - camPos).Magnitude > 0.01 then
                    camera.CFrame = CFrame.lookAt(camPos, aim)
                end
                RunService.RenderStepped:Wait()
                local screen = camera:WorldToViewportPoint(aim)
                local inset = GuiService:GetGuiInset()
                clickX = math.floor(screen.X + inset.X + 0.5)
                clickY = math.floor(screen.Y + inset.Y + 0.5)
                pcall(function() VIM:SendMouseMoveEvent(clickX, clickY, game) end)
            end
        end
        if _G.Tek_IsResetting or tool.Parent ~= char or not tool.Enabled or LP.Character ~= char then
            flashTeleportLog("NOT READY BEFORE CLICK parent=" .. tostring(tool.Parent))
            break
        end

        attempts = attempt
        activated = false
        local before = hrp.Position
        cleanup.clickX, cleanup.clickY = clickX, clickY
        cleanup.mouseDown = true
        clickDownOk = pcall(function()
            VIM:SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
        end)
        task.wait(0.05)
        clickUpOk = pcall(function()
            VIM:SendMouseButtonEvent(clickX, clickY, 0, false, game, 1)
        end)
        cleanup.mouseDown = not clickUpOk

        local settleAt = os.clock() + (attempt == 1 and 0.65 or 1.0)
        repeat
            local current = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if current and (current.Position - before).Magnitude >= 3 then
                moved = true
                break
            end
            RunService.Heartbeat:Wait()
        until os.clock() >= settleAt
        if moved then
            local stableUntil = os.clock() + 0.12
            repeat RunService.Heartbeat:Wait() until os.clock() >= stableUntil
            local current = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            moved = current ~= nil and (current.Position - before).Magnitude >= 3
        end
        flashTeleportLog(string.format("ATTEMPT %d down=%s up=%s activated=%s moved=%s tool=%s",
            attempt, tostring(clickDownOk), tostring(clickUpOk), tostring(activated),
            tostring(moved), tostring(tool.Parent)))
        if moved then break end
    end

    if activationConn then activationConn:Disconnect() end
    if targetPos and oldCameraCF and camera and camera.Parent then
        pcall(function() camera.CFrame = oldCameraCF end)
    end
    _G.TekFlashTeleportActive = false
    _G.TekFlashTeleportSafeUntil = os.clock() + 4
    -- Activated only confirms input delivery; the teleport is successful once
    -- the character actually changes position.
    flashTeleportLog(string.format("CLICK attempts=%d down=%s up=%s activated=%s moved=%s aimed=%s",
        attempts,
        tostring(clickDownOk), tostring(clickUpOk), tostring(activated),
        tostring(moved), tostring(targetPos ~= nil)))
    return clickDownOk and clickUpOk and moved
end

function doFlashTeleport(targetPos, cameraOrigin)
    -- Shared across repeated file executions and both hotkey/route callers.
    -- Do not queue a second click with an outdated aim point.
    if _G.TekFlashTeleportRun then
        flashTeleportLog("BUSY: overlapping request skipped")
        return false
    end
    local run = {}
    _G.TekFlashTeleportRun = run
    local cleanup = {}
    local ok, result = xpcall(function()
        return performFlashTeleport(targetPos, cleanup, cameraOrigin)
    end, function(err) return tostring(err) end)
    if cleanup.mouseDown then
        pcall(function()
            VIM:SendMouseButtonEvent(cleanup.clickX, cleanup.clickY, 0, false, game, 1)
        end)
    end
    if cleanup.activationConn then pcall(function() cleanup.activationConn:Disconnect() end) end
    if cleanup.cameraCF and cleanup.camera and cleanup.camera.Parent then
        pcall(function() cleanup.camera.CFrame = cleanup.cameraCF end)
    end
    if _G.TekFlashTeleportRun == run then
        _G.TekFlashTeleportActive = false
        _G.TekFlashTeleportSafeUntil = os.clock() + 4
        _G.TekFlashTeleportRun = nil
    end
    if not ok then
        if cleanup.character then flashControllerReady[cleanup.character] = nil end
        flashTeleportLog("ERROR: " .. tostring(result)); return false
    end
    if result ~= true and cleanup.character then
        -- A failed activation is evidence that this controller is still stale;
        -- refresh it again on the next request.
        flashControllerReady[cleanup.character] = nil
    end
    return result == true
end

_G.TekDoFlashTeleport = doFlashTeleport

_TweenTS = game:GetService("TweenService")
function tekTween(rootPart, hum, targetPos, lookDir)
    if not rootPart or not rootPart.Parent then return end
    local STEP = 20
    local speed = (_G.TPTravelSpeed or 100)
    local hasLook = lookDir ~= nil and lookDir.Magnitude > 0.001
    local prevAnchored = rootPart.Anchored
    _vzL(rootPart)
    _vzA(rootPart)
    pcall(function() rootPart.Anchored = true end)
    local deadline = os.clock() + 12
    while rootPart and rootPart.Parent and os.clock() < deadline do
        local pos = rootPart.Position
        local toTarget = targetPos - pos
        local d = toTarget.Magnitude
        if d < 0.5 then break end
        local stepDist = math.min(STEP, d)
        local stepGoal = pos + toTarget.Unit * stepDist
        local stepCF
        if hasLook then
            stepCF = CFrame.lookAt(stepGoal, stepGoal + lookDir)
        else
            stepCF = (rootPart.CFrame - rootPart.CFrame.Position) + stepGoal
        end
        local dur = math.clamp(stepDist / speed, 0.02, 1)
        local tw = _TweenTS:Create(rootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = stepCF })
        tw:Play()
        tw.Completed:Wait()
    end
    pcall(function() rootPart.Anchored = prevAnchored end)
    if rootPart and rootPart.Parent then _vzL(rootPart) end
end

function _makeOneWay(plat)
    if not plat then return end
    local rsConn
    local lastY = nil
    rsConn = RunService.Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
            if isMovingUp then
                plat.CanCollide = false
            else
                plat.CanCollide = (currentY > plat.Position.Y + 0.1)
            end
            lastY = currentY
        end
    end)
end



function carpetEngageFast()
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return nil end

    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    local _t = os.clock()
    while not (LP.Character and LP.Character:FindFirstChild("Grapple Hook"))
        and os.clock() - _t < (tonumber(_G.TekGoGrappleWait) or 0.35) do
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        local g = findTool("Grapple Hook")
        if g and h then pcall(function() h:EquipTool(g) end) end
        RunService.Heartbeat:Wait()
    end
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        _fireGrapple()
    end

    local h2 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h2 then pcall(function() h2:UnequipTools() end) end
    RunService.Heartbeat:Wait()

    local cn
    local _t2 = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _t2 > (tonumber(_G.TekGoCarpetWait) or 2)
    return cn
end
_G.TekCarpetEngageFast = carpetEngageFast

function goToBrainrot(petPos,slot)
if not petPos then
return
end
local char,hrp,hum
local _t0=os.clock()
repeat
char=LP.Character
hrp=char and char:FindFirstChild("HumanoidRootPart")
hum=char and char:FindFirstChildOfClass("Humanoid")
if hrp and hum then
break
end
RunService.Heartbeat:Wait()
until os.clock()-_t0>3
if not hrp or not hum then
return
end
pcall(function()
hrp.Anchored=false
end)
local _equipped=false
do
for _,_cn in ipairs(CARPET_NAMES)do
if char and char:FindFirstChild(_cn)then
_equipped=true
break
end
end
local _gd=(petPos and hrp and hrp.Parent)and(petPos-hrp.Position).Magnitude or math.huge
local _gmin=tonumber(_G.TekGoGrappleMin)or 100
if not _equipped and _G.TekGoGrapple~=false and _gd>_gmin then
pcall(carpetEngageFast)
char=LP.Character
for _,_cn in ipairs(CARPET_NAMES)do
if char and char:FindFirstChild(_cn)then
_equipped=true
break
end
end
end
local _e0=os.clock()
while not _equipped and os.clock()-_e0<=(tonumber(_G.TekGoCarpetWait)or 3)do
char=LP.Character
for _,_cn in ipairs(CARPET_NAMES)do
if char and char:FindFirstChild(_cn)then
_equipped=true
break
end
end
if _equipped then
break
end
equipCarpet()
RunService.Heartbeat:Wait()
end
if _equipped then
task.wait(tonumber(_G.TekGoCarpetSettle)or 0.02)
end
end
char=LP.Character
hrp=char and char:FindFirstChild("HumanoidRootPart")
hum=char and char:FindFirstChildOfClass("Humanoid")
if not hrp then
return
end
pcall(function()
hrp.Anchored=false
end)
local _plotRad=(petPos.Y<=8.9)and 26 or 25
do
local _t0b=os.clock()
repeat
local p=hrp.Position
local inRad=false
local plotsFolder=workspace:FindFirstChild("Plots")
if plotsFolder then
for _,plot in ipairs(plotsFolder:GetChildren())do
pcall(function()
local pp=plot:GetPivot().Position
if math.abs(p.X-pp.X)<_plotRad and math.abs(p.Z-pp.Z)<_plotRad then
inRad=true
end
end)
if inRad then
break
end
end
end
if inRad then
break
end
RunService.Heartbeat:Wait()
until os.clock()-_t0b>(tonumber(_G.TekGoPlotWait)or 0.15)
end
local h=petPos.Y
pcall(function()
hrp.AssemblyLinearVelocity=Vector3.new(0,0,0)
hrp.AssemblyAngularVelocity=Vector3.new(0,0,0)
end)
local _wentUnder=false
local _slot=tonumber(slot)
local _under=tonumber(_G.TekUnderOffset)or 6
local targetY=hrp.Position.Y
if(_slot and _slot>=19)or(not _slot and h>23.15)then
targetY=h-(tonumber(_G.TekUnderOffset3)or 4)
_wentUnder=true
elseif(_slot and _slot>=11)or(not _slot and h>=11 and h<=23.15)then
targetY=h-(tonumber(_G.TekUnderOffset2)or 3.5)
_wentUnder=true
elseif(_slot and _slot>=1)or(not _slot and h>=-6.9 and h<=8.9)then
targetY=tonumber(_G.TekFloor1Y)or-4
if _G.TekFloor1Platform~=false then
_wentUnder=true
end
else
targetY=h-_under
_wentUnder=true
end
local _to=Vector3.new(petPos.X,targetY,petPos.Z)
if hrp and hrp.Parent then
do
local _goSpeed=tonumber(_G.TekGoSpeed)or 400
local _s1=tonumber(_G.TekGoGlideSpeed1)or(_goSpeed*0.375)
local _t1=tonumber(_G.TekGoGlideTime1)or 0.03
local _s2=tonumber(_G.TekGoGlideSpeed2)or _goSpeed
local _cap=math.max(tonumber(_G.TekGoGlideMax)or 2.5, (_to-hrp.Position).Magnitude/math.max(_s2,1)+0.5)
local _g0=os.clock()
local _lastJump=0
local _bestD,_bestAt=math.huge,os.clock()
local _flatFirst=_wentUnder
and _G.TekGoFlatFirst~=false
and hrp
and hrp.Parent
and(_to.Y-hrp.Position.Y)>6
while os.clock()-_g0<_cap do
if not(hrp and hrp.Parent)then
break
end
if LP:GetAttribute("Stealing")or _G.TekTPStop then
break
end
local d=_to-hrp.Position
if _flatFirst then
d=Vector3.new(d.X,0,d.Z)
if d.Magnitude<=2 then
break
end
elseif d.Magnitude<=3 then
break
end
if d.Magnitude<_bestD-0.5 then
_bestD,_bestAt=d.Magnitude,os.clock()
elseif os.clock()-_bestAt>(tonumber(_G.TekGoStallTime)or 0.2)then
break
end
equipCarpet()
if _G.TekGoJump==true and d.Magnitude>15 and(os.clock()-_lastJump)>0.5 then
local _gh=hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
if _gh then
pcall(function()
_gh:ChangeState(Enum.HumanoidStateType.Jumping)
end)
pcall(function()
_gh.Jump=true
end)
_lastJump=os.clock()
end
end
if _G.TekGoZeroEachFrame~=false then
pcall(function()
hrp.AssemblyLinearVelocity=Vector3.new(0,0,0)
hrp.AssemblyAngularVelocity=Vector3.new(0,0,0)
end)
end
local _gs=((os.clock()-_g0)<_t1)and _s1 or _s2
if _G.TekEaseIn~=false then
_gs=math.min(
_gs,
math.max(
tonumber(_G.TekGoArriveMin)or 150,
d.Magnitude*(tonumber(_G.TekGoArriveGain)or 30)
)
)
end
local _v=d.Unit*_gs
if _G.TekGoNoRise~=false and hrp.Position.Y>=_to.Y-0.5 and _v.Y>0 then
_v=Vector3.new(_v.X,0,_v.Z)
end
_setFlightVel(hrp,_v)
RunService.Heartbeat:Wait()
end
end
if _G.TekTPStop or not (hrp and hrp.Parent) then return end
local _snapCF=CFrame.new(_to)*(hrp.CFrame-hrp.CFrame.Position)
pcall(function()
hrp.AssemblyLinearVelocity=Vector3.new(0,0,0)
hrp.AssemblyAngularVelocity=Vector3.new(0,0,0)
hrp.CFrame=_snapCF
end)
for _=1,(tonumber(_G.TekSnapHoldFrames)or 8)do
RunService.Heartbeat:Wait()
if not(hrp and hrp.Parent)then
break
end
if(hrp.Position-_to).Magnitude>4 then
pcall(function()
hrp.CFrame=_snapCF
end)
end
end
end
    if _wentUnder and _G.TekPlatform ~= false then
        local _platPos = (hrp and hrp.Parent and hrp.Position) or _to
        local _feetY = _platPos.Y - 3
        local _sz = tonumber(_G.TekPlatSize) or 10
        -- was named "ANGVELSTempPlatform" and found again by that name; both the
        -- name and the name-lookup are visible to the game. Track it by reference.
        local _old = _G.__TekPlat
        if _old and _old.Parent then pcall(function() _old:Destroy() end) end
        local _plat = Instance.new("Part")
        _G.__TekPlat = _plat
        _plat.Size = Vector3.new(_sz, 1, _sz)
        _plat.Position = Vector3.new(petPos.X, _feetY - (tonumber(_G.TekPlatDrop) or 1.5), petPos.Z)
        _plat.Anchored = true; _plat.CanCollide = false; pcall(_makeOneWay, _plat); _plat.Transparency = 1
        _plat.Material = Enum.Material.SmoothPlastic; _plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < (tonumber(_G.TekPlatLife) or 20) do
                if LP:GetAttribute("Stealing") then break end
                task.wait(0.1)
            end
            if _plat and _plat.Parent then _plat:Destroy() end
        end)
    end
end

_Stats = game:GetService("Stats")
function _pingMs()
    local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
    if ok and type(p) == "number" and p > 0 then return p end
    local ok2, p2 = pcall(function()
        return _Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok2 and type(p2) == "number" and p2 > 0 then return p2 end
    return 0
end
_G.TekPingMs = _pingMs
function _pingAdjustSpeed(spd)
    local thresh = tonumber(_G.TekPingThresh) or 170
    local capped = tonumber(_G.TekHighPingSpeed) or 400
    if _pingMs() >= thresh and spd > capped then return capped end
    return spd
end

function _inVoid(hrp)
    if not hrp or not hrp.Parent then return true end
    local voidY = tonumber(_G.TekVoidY) or -50
    return hrp.Position.Y < voidY
end
function _waitOutOfVoid(timeout)
    local t0 = os.clock()
    local good = 0
    while os.clock() - t0 < (timeout or 12) do
        if _G.TekTPStop then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent and not _inVoid(hrp) and math.abs(hrp.AssemblyLinearVelocity.Y) < 12 then
            good += 1
            if good >= 4 then return true end
        else
            good = 0
        end
        RunService.Heartbeat:Wait()
    end
    return false
end

do
    local lastSafe = nil
    local recovering = false
    local _voidAcc = 0
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        _voidAcc = _voidAcc + (dt or 0.016)
        if _voidAcc < 0.1 then return end
        _voidAcc = 0
        if _G.TekVoidRecover == false then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local voidY = tonumber(_G.TekVoidY) or -50
        if hrp.Position.Y >= voidY then
            if math.abs(hrp.AssemblyLinearVelocity.Y) < 40 then
                lastSafe = hrp.Position
            end
            return
        end
        if recovering or not lastSafe then return end
        recovering = true

        pcall(function()
            _vzL(hrp)
            _vzA(hrp)
            hrp.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
        end)
        task.spawn(function()
            local delay = tonumber(_G.TekVoidRecoverDelay) or 0
            if delay > 0 then task.wait(delay) end
            local vy = tonumber(_G.TekVoidY) or -50
            local tries = 0
            while tries < 80 do
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if not h or not h.Parent then break end
                if h.Position.Y >= vy and math.abs(h.AssemblyLinearVelocity.Y) < 18 then
                    break
                end
                if lastSafe then
                    pcall(function()
                        _vzL(h)
                        _vzA(h)
                        h.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
                    end)
                end
                tries = tries + 1
                RunService.Heartbeat:Wait()
            end
            recovering = false
        end)
    end))
end

isTeleporting = false

task.spawn(function()
    local _since = nil
    while true do
        task.wait(1)
        if isTeleporting then
            _since = _since or os.clock()
            if os.clock() - _since > (tonumber(_G.TekTPWatchdog) or 25) then
                isTeleporting = false
                _G.TekStealHold = false
                _since = nil
                if _G.TekTPDebug == true then
                    
                end
            end
        else
            _since = nil
        end
    end
end)

_G.TekDoClone = doClone
_G.TekIsTeleporting = function() return isTeleporting end

function cframeStepThrough(hrp, waypoints, stepSize)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    stepSize = stepSize or 24
    local lockY = hrp.Position.Y
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local deadline = os.clock() + 10
    local _lastFire = 0
    while hrp and hrp.Parent and os.clock() < deadline do
        if _G.TekTPStop then break end
        do
            local char = hrp.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and char and not char:FindFirstChild("Grapple Hook") then
                local g = findGrapple()
                if g then pcall(function() hum:EquipTool(g) end) end
            end
            if os.clock() - _lastFire > 0.3 then
                _lastFire = os.clock()
                if char and char:FindFirstChild("Grapple Hook") then
                    -- Elite-method fire can yield (cooldown gate / equip wait);
                    -- spawn it so the 24-stud step cadence stays on Heartbeat
                    task.spawn(_fireGrapple)
                end
            end
        end
        local target = waypoints[wpIdx]
        local flat = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
        local mag = flat.Magnitude
        if mag < 2 then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then break end
            RunService.Heartbeat:Wait()
        else
            local hop = math.min(stepSize, mag)
            local nextPos = hrp.Position + flat.Unit * hop
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(Vector3.new(nextPos.X, lockY, nextPos.Z)) * CFrame.Angles(0, y, 0)
            _vzL(hrp)
            _vzA(hrp)
            task.wait(hop / math.clamp(tonumber(_G.TekCFrameSpeed) or 450, 60, 900))
        end
    end
    do
        local hum = hrp and hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:UnequipTools() end) end
        task.wait(0.05)
        equipCarpet()
    end
    if hrp and hrp.Parent then
        _vzL(hrp)
        _vzA(hrp)
    end
end

function _isStraightRoute(fromPos, route)
    if not route or #route <= 1 then return true end
    local turns, lastDir, prev = 0, nil, fromPos
    for _, wp in ipairs(route) do
        local seg = wp - prev
        if seg.Magnitude > 1 then
            local dir = seg.Unit
            if lastDir and dir:Dot(lastDir) < 0.94 then turns = turns + 1 end
            lastDir = dir
        end
        prev = wp
    end
    return turns <= (tonumber(_G.TekStraightMaxTurns) or 1)
end

local _tekAnimRestoreAt = 0
local function restoreAnimations()
    _tekAnimRestoreAt = os.clock() + 3
    task.spawn(function()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animate = char:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = false end) end
        if hum then
            pcall(function() hum.AutoRotate = true end)
            local animator = hum:FindFirstChildOfClass("Animator")
            if animator then
                pcall(function()
                    local tracks = animator:GetPlayingAnimationTracks()
                    if tracks then
                        for _, t in ipairs(tracks) do
                            if t.Priority == Enum.AnimationPriority.Core
                               or t.Priority == Enum.AnimationPriority.Idle then
                                pcall(function() t:Play(0.1) end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end

function doVelocityTP(forceGrapple, forcedPet)
    if isTeleporting or _G.TekFlashTeleportRun or _G.TekFlashTeleportActive then return end
    if LP:GetAttribute("Stealing") == true then return end
    isTeleporting = true
    _G._cframeTPGen = (_G._cframeTPGen or 0) + 1
    _G._cframeStartDone = false
    if _G.TekDisarmSteal then _G.TekDisarmSteal() end
    _G.TekTPStop = false
    clearViz()
    if not NetModule then pcall(loadNet) end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then isTeleporting = false; return end

    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)

    if _inVoid(hrp) or hrp.AssemblyLinearVelocity.Y < -40 then
        _waitOutOfVoid(12)
        if _G.TekTPStop then isTeleporting = false; return end
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then isTeleporting = false; return end
    end

    local allPets = forcedPet and { forcedPet } or scanForTP()
    if not forcedPet and #allPets == 0 then
        local _t0 = os.clock()
        while #allPets == 0 and os.clock() - _t0 < (tonumber(_G.TekTPScanWait) or 3) do
            task.wait(0.03)
            allPets = scanForTP()
        end
    end
    if #allPets == 0 then isTeleporting = false; return end



    if not forcedPet and _G.TekFullScanFirst ~= false then
        local _fs0 = os.clock()
        local _fcap = tonumber(_G.TekFullScanWait) or 0.8
        local _stale = tonumber(_G.TekScanStaleGap) or 0.2
        local _prev = tonumber(_G.TekScanNoChan) or 0
        local _lastProg = os.clock()
        while (tonumber(_G.TekScanNoChan) or 0) > 0
            and os.clock() - _fs0 < _fcap do
            if _G.TekTPStop then break end
            task.wait(0.03)
            allPets = scanForTP()
            local _now = tonumber(_G.TekScanNoChan) or 0
            if _now < _prev then
                _prev, _lastProg = _now, os.clock()
            elseif os.clock() - _lastProg >= _stale then
                break
            end
        end
        if (tonumber(_G.TekScanNoChan) or 0) > 0 then

        end
    end

    if not forcedPet and not (type(_G.TekStealTargetUID) == "string" and _G.TekStealTargetUID ~= "") then
        local pool, seen = {}, {}
        local function _absorb(list)
            if type(list) ~= "table" then return end
            for _, p in ipairs(list) do
                if not p.conveyor and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    local ex = seen[uid]
                    if not ex then
                        seen[uid] = p
                        pool[#pool + 1] = p
                    elseif (p.mps or 0) > (ex.mps or 0) then
                        for i = 1, #pool do
                            if pool[i] == ex then pool[i] = p break end
                        end
                        seen[uid] = p
                    end
                end
            end
        end
        _absorb(allPets)
        for _ = 1, (tonumber(_G.TekTPScans) or 1) do
            task.wait(tonumber(_G.TekTPScanGap) or 0.03)
            local _ok, _more = pcall(scanForTP)
            if _ok then _absorb(_more) end
        end
        if #pool > 0 then allPets = pool end
    end

    local pet
    if forcedPet then
        pet = forcedPet
    elseif type(_G.TekStealTargetUID) == "string" and _G.TekStealTargetUID ~= "" then
        pet = _findStealTarget(allPets)
        if not pet then isTeleporting = false; return end
    else
        local prio, best
        for _, p in ipairs(allPets) do
            if not p.conveyor then
                if p._pri and (not prio or p._pri < prio._pri) then prio = p end
                if not best or (p.mps or 0) > (best.mps or 0) then best = p end
            end
        end
        pet = prio or best or allPets[1]
    end
    local petPos = pet.position
    local petName = pet.name
    if _G.TekArmSteal then pcall(_G.TekArmSteal, pet) end
    if type(_G.TekStealSay) == "function" then
        pcall(_G.TekStealSay, string.format("TP start -> %s [%s/%s] mps=%s pri=%s of %d", tostring(pet and pet.name), tostring(pet and pet.plot), tostring(pet and pet.slot), tostring(pet and pet.mps), tostring(pet and pet._pri), #allPets))
    end

    _G.TekStealHold = true

    local hasCarpet = false
    for _, name in ipairs(CARPET_NAMES) do
        if char:FindFirstChild(name) then hasCarpet = true; break end
    end
    if not hasCarpet then pcall(fireGrapple) end

    local adjY = petPos.Y
    if TALL_PETS[petName] then adjY = petPos.Y - TALL_OFFSET end
    local coordTable = adjY > 23.15 and MK_UPPER or MK_LOWER

    if petPos.Y <= 8.9 and isPlotUnlocked(pet.plot) then
        if not hasCarpet then carpetEngage(forceGrapple) end
        vZero(hrp)
        local _to = Vector3.new(petPos.X, -4, petPos.Z)
        local route = computeRoute(hrp.Position, _to, nil)
        if not route or #route == 0 then route = { _to } end
        local speed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
        if _isStraightRoute(hrp.Position, route) and tonumber(_G.TekStraightSpeed) then
            speed = math.clamp(tonumber(_G.TekStraightSpeed), 100, 500)
        end
        local length, previous = 0, hrp.Position
        for _, wp in ipairs(route) do length = length + (wp - previous).Magnitude; previous = wp end
        if length < 100 then speed = math.clamp(tonumber(_G.TekCloseSpeed) or 80, 20, 400) end
        speed = _pingAdjustSpeed(speed)
        local arrived
        if TekTweenOn() then
            local ok, tweened = pcall(tweenFlyThenTp, hrp, route, _to, speed, tonumber(_G.TekTweenNear) or 40, nil)
            if ok then
                arrived = tweened and tekEnsureArrive(hrp, _to, speed)
                    or (hrp.Position - _to).Magnitude <= (tonumber(_G.TekArriveTolerance) or 6)
            else
                arrived = velMoveThrough(hrp, route, speed, true, true)
            end
        else
            arrived = velMoveThrough(hrp, route, speed, true, true)
        end
        if hrp and hrp.Parent then
            _vzL(hrp)
            _vzA(hrp)
        end
        _G.TekStealHold = false
        isTeleporting = false
        if not arrived or _G.TekTPStop then return end
        return
    end

    local closestData, skyKey = findClosest(petPos, coordTable)
    if not closestData or not skyKey then _G.TekStealHold = false; isTeleporting = false; return end

    local destPos = closestData.coord

    -- Elite waits for the flying tool before starting the main route.
    -- This avoids beginning movement while only the grapple is equipped.
    if not hasCarpet then
        local flightTool = carpetEngage(forceGrapple)
        if not flightTool or _G.TekTPStop or LP.Character ~= char or hrp.Parent ~= char then
            _G.TekStealHold = false
            isTeleporting = false
            return
        end
    end

    vZero(hrp)

    local facingDir = closestData.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)

    local _frontApproach = false
    do
        local isUpper = (coordTable == MK_UPPER)
        local idx = getClosestBaseIdx(petPos)
        local frontCoord, frontFace = buildFrontCandidate(idx, isUpper, hrp.Position.Z)
        local bestCoord, bestFace = frontCoord, frontFace
        local bestDist = (hrp.Position - frontCoord).Magnitude
        local pickedFront = true

        -- Compare front and side points on the first floor by distance.
        -- TekFirstFloorSideOnly=true explicitly forces the older side preference.
        local _sideOnly = (not isUpper) and (_G.TekFirstFloorSideOnly == true)

        local _tb = BASES_LOW[idx]
        local _isWest = idx <= 4
        local _rowBlocked = false
        local _dx, _dz = hrp.Position.X - _tb.X, hrp.Position.Z - _tb.Z
        local _distToBase = math.sqrt(_dx * _dx + _dz * _dz)
        local _sideRange = tonumber(_G.TekSideTPRange) or 100
        -- _rowBlocked forces the front approach, so it must not run in side-only mode
        if not _sideOnly and _G.TekPreferFrontOnRow ~= false and _distToBase > _sideRange then
            for i = 1, 8 do
                if i ~= idx and (i <= 4) == _isWest then
                    local bz = BASES_LOW[i].Z
                    if (bz - hrp.Position.Z) * (bz - _tb.Z) < 0 then _rowBlocked = true; break end
                end
            end
        end

        -- With explicit side-only preference, use the front only as fallback.
        if _sideOnly then bestDist = math.huge end

        if not _rowBlocked then
            for _, d in ipairs(plotSides(coordTable, idx)) do
                local dd = (hrp.Position - d.coord).Magnitude
                if dd < bestDist then
                    bestDist = dd
                    bestCoord = d.coord
                    bestFace = d.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
                    pickedFront = false
                end
            end
        end
        destPos = bestCoord
        facingDir = bestFace
        _frontApproach = pickedFront
        if _G.TekTPDebug ~= false then
            local _mode = pickedFront and "FRONT" or "SIDE"
            if _sideOnly then
                -- pickedFront still true here means no side coord existed
                _mode = pickedFront and "FRONT(sideonly-fallback)" or "SIDE(sideonly)"
            end
            warn(string.format(
                "[TekTP] PICK baseIdx=%d %s floor=%s | pet=(%.0f,%.0f,%.0f) plot=%s | dest=(%.0f,%.0f,%.0f) | me=(%.0f,%.0f,%.0f) | sides=%d",
                idx, _mode, isUpper and "2nd" or "1st",
                petPos.X, petPos.Y, petPos.Z, tostring(pet.plot),
                destPos.X, destPos.Y, destPos.Z,
                hrp.Position.X, hrp.Position.Y, hrp.Position.Z,
                #plotSides(coordTable, idx)))
        end
    end

    if facingDir and facingDir.Magnitude > 0.1 then
        local axis = facingDir.Unit
        local toPlayer = hrp.Position - destPos
        local sign = axis:Dot(toPlayer) >= 0 and 1 or -1
        destPos = destPos + axis * sign * (tonumber(_G.TekCloneBackoff) or 0.5)
    end

    local route = computeRoute(hrp.Position, destPos, facingDir, nil, _G.TekCrestRoute == true)
    if not route or #route == 0 then route = { destPos } end
    local stepped, previous = {}, hrp.Position
    for _, wp in ipairs(route) do
        local dy = wp.Y - previous.Y
        if dy > 15 then
            local count = math.ceil(dy / 10)
            for step = 1, count - 1 do
                local t = step / count
                stepped[#stepped + 1] = Vector3.new(
                    previous.X + (wp.X - previous.X) * t,
                    previous.Y + dy * t,
                    previous.Z + (wp.Z - previous.Z) * t)
            end
        end
        stepped[#stepped + 1] = wp
        previous = wp
    end

    local mainSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
    local routeLength = 0
    previous = hrp.Position
    for _, wp in ipairs(route) do routeLength = routeLength + (wp - previous).Magnitude; previous = wp end
    if routeLength < 100 then
        mainSpeed = math.clamp(tonumber(_G.TekCloseSpeed) or 80, 20, 400)
    end
    mainSpeed = _pingAdjustSpeed(mainSpeed)
    local arrived
    if TekTweenOn() and _frontApproach then
        local ok, tweened = pcall(tweenFlyThenTp, hrp, stepped, destPos, mainSpeed,
            tonumber(_G.TekTweenNear) or 40, facingDir)
        if ok then
            arrived = tweened and tekEnsureArrive(hrp, destPos, mainSpeed)
                or (hrp.Position - destPos).Magnitude <= (tonumber(_G.TekArriveTolerance) or 6)
        else
            arrived = velMoveThrough(hrp, stepped, mainSpeed, true, true)
        end
    else
        arrived = velMoveThrough(hrp, stepped, mainSpeed, true, true)
    end
    if not arrived or _G.TekTPStop then
        if hrp and hrp.Parent then vZero(hrp) end
        _G.TekStealHold = false
        isTeleporting = false
        restoreAnimations()
        return
    end

    -- Elite landing: rise over the destination, then run in and retry the route if needed.
    local above = destPos + Vector3.new(0, 16, 0)
    local climbStarted, lastJump = os.clock(), 0
    while os.clock() - climbStarted < 1.5 and hrp and hrp.Parent and not _G.TekTPStop do
        if LP:GetAttribute("Stealing") then break end
        equipCarpet()
        local delta = above - hrp.Position
        local flat = Vector3.new(delta.X, 0, delta.Z).Magnitude
        if flat <= 3 and hrp.Position.Y >= destPos.Y then break end
        if delta.Y > 3 and os.clock() - lastJump > 0.5 then
            local h = hrp.Parent:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping); h.Jump = true end) end
            lastJump = os.clock()
        end
        _setFlightVel(hrp, delta.Unit * math.min(math.max(delta.Magnitude * 8, 55), 320))
        _vzA(hrp)
        RunService.Heartbeat:Wait()
    end

    -- The final run-in used to keep up to 400 studs/s and could kill the
    -- Humanoid immediately before Quantum Cloner fired.  Always brake here.
    local preCloneCap = math.clamp(tonumber(_G.TekPreCloneSpeed) or 120, 40, 250)
    local runCap = math.min(_frontApproach and (tonumber(_G.TekFrontRunIn) or 130) or 400, preCloneCap)
    local runStarted, bestDistance, bestAt = os.clock(), math.huge, os.clock()
    while os.clock() - runStarted < 4 and hrp and hrp.Parent and not _G.TekTPStop do
        if LP:GetAttribute("Stealing") then break end
        equipCarpet()
        local delta = destPos - hrp.Position
        local distance = delta.Magnitude
        if distance <= 3 then break end
        if distance < bestDistance - 0.5 then bestDistance, bestAt = distance, os.clock()
        elseif os.clock() - bestAt > 0.6 then break end
        _setFlightVel(hrp, delta.Unit * math.min(math.max(distance * 8, 55), runCap))
        _vzA(hrp)
        RunService.Heartbeat:Wait()
    end

    if hrp and hrp.Parent and not _G.TekTPStop then
        local flatOffset = Vector3.new(destPos.X - hrp.Position.X, 0, destPos.Z - hrp.Position.Z).Magnitude
        if flatOffset > 10 then
            local retry = computeRoute(hrp.Position, destPos, facingDir, nil, false)
            if not retry or #retry == 0 then retry = { destPos } end
            velMoveThrough(hrp, retry, mainSpeed, true, true)
        end
    end
    if _G.TekTPStop or not hrp or not hrp.Parent then
        _G.TekStealHold = false
        isTeleporting = false
        restoreAnimations()
        return
    end

    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + facingDir)
    vZero(hrp)
    local syncFrames = 3
    local syncConn
    syncConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent or _G.TekTPStop then syncConn:Disconnect(); return end
        syncFrames = syncFrames - 1
        hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
        _vzL(hrp); _vzA(hrp)
        if syncFrames <= 0 then syncConn:Disconnect() end
    end))
    for _ = 1, (tonumber(_G.TekMaxLandTries) or 3) do
        task.wait(tonumber(_G.TekLandCheckGap) or 0.03)
        if hum.FloorMaterial ~= Enum.Material.Air then break end
    end
    local stable, stableStarted = 0, os.clock()
    while os.clock() - stableStarted < (tonumber(_G.TekStableWait) or 0.3) and not _G.TekTPStop do
        local live = char and char:FindFirstChild("HumanoidRootPart")
        if not live or not live.Parent then break end
        local flat = Vector3.new(live.Position.X - destPos.X, 0, live.Position.Z - destPos.Z).Magnitude
        if flat <= 3.5 and math.abs(live.Position.Y - destPos.Y) <= 4 then
            stable = stable + 1
            if stable >= 2 then break end
        else
            stable = 0
            live.CFrame = CFrame.new(destPos, destPos + facingDir)
            _vzL(live); _vzA(live)
        end
        RunService.Heartbeat:Wait()
    end

    local liveRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local clonePos = liveRoot and liveRoot.Position or destPos
    local platform = Instance.new("Part")
    platform.Name = "Part"
    platform.Size = Vector3.new(4, 1, 4)
    platform.Position = Vector3.new(clonePos.X, clonePos.Y - 3, clonePos.Z)
    platform.Anchored, platform.CanCollide, platform.Transparency = true, true, 1
    platform.Material = Enum.Material.SmoothPlastic
    platform.Parent = workspace
    local beforeCharacter = LP.Character
    local beforePosition = liveRoot and liveRoot.Position or destPos
    local characterAdded = false
    local addedConn = LP.CharacterAdded:Connect(function() characterAdded = true end)
    _G.TekStealHold = false
    task.wait(tonumber(_G.LandingDelay) or tonumber(_G.TPCloneDelay) or 0.12)
    if facingDir.Magnitude > 0.1 then
        for _ = 1, 2 do
            local live = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not live then break end
            live.CFrame = CFrame.new(live.Position, live.Position + facingDir)
            _vzL(live); _vzA(live)
            RunService.Heartbeat:Wait()
        end
    end
    local cloneOK = false
    if not _G.TekTPStop then
        if _G.TekFlashTP == true then
            cloneOK = doFlashTeleport(petPos) == true
            if not cloneOK then
                warn("[Elysium] Flash TP failed")
            end
        else
            cloneOK = doClone()
        end
    end
    if platform then platform:Destroy() end
    local settleStarted = os.clock()
    repeat
        if characterAdded or LP.Character ~= beforeCharacter then break end
        local live = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if live then
            local delta = live.Position - beforePosition
            if Vector3.new(delta.X, 0, delta.Z).Magnitude > 2 or math.abs(delta.Y) > 1 then break end
        end
        RunService.Heartbeat:Wait()
    until os.clock() - settleStarted > (tonumber(_G.TekCloneSettle) or 0.6)
    if addedConn then addedConn:Disconnect() end
    pcall(function()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.AutoRotate = true end
    end)
    if not cloneOK or _G.TekTPStop then
        isTeleporting = false
        restoreAnimations()
        return
    end
    goToBrainrot(petPos, pet and pet.slot)
    isTeleporting = false
    if _G.TekArmSteal then pcall(_G.TekArmSteal, pet) end
    restoreAnimations()
end

_manualTPBusy = false
function manualFullTP()
    if _manualTPBusy or isTeleporting then return end
    if LP:GetAttribute("Stealing") == true then return end
    _manualTPBusy = true
    -- Freeze the selection at the button press. A delayed sync cleanup must not
    -- silently turn a selected-target TP into a best-brainrot TP.
    local selectedUid = _G.TekStealTargetUID
    if type(selectedUid) ~= "string" or selectedUid == "" then selectedUid = nil end
    if _G.TekScanProfile and _G.TekScanMode == "fast" then _G.TekScanProfile("normal") end
    local okAll, result = pcall(function()
        local _t0 = os.clock()
        local _lastN, _lastTop = -1, nil
        local selectedPet
        repeat
            local ok, pets = pcall(scanForTP)
            if ok and pets and #pets > 0 then
                if selectedUid then
                    for _, candidate in ipairs(pets) do
                        if not candidate.conveyor and candidate.position
                            and _petUid(candidate) == selectedUid then
                            selectedPet = candidate
                            break
                        end
                    end
                    if selectedPet then break end
                else
                    local top = _petUid(pets[1])
                    if #pets == _lastN and top == _lastTop then break end
                    _lastN, _lastTop = #pets, top
                end
                task.wait(tonumber(_G.TekScanSettle) or 0.06)
            else
                task.wait(0.05)
            end
        until os.clock() - _t0 > (tonumber(_G.TekTPMaxWait) or 4)
        if selectedUid and not selectedPet then
            warn("[Elysium] Manual TP: selected brainrot is no longer available")
            return false
        end
        doVelocityTP(true, selectedPet)
        return true
    end)
    _manualTPBusy = false
    if not okAll then warn("[Elysium] Manual TP: " .. tostring(result)) end
    return okAll and result == true
end
_G.TekStartSideTP = manualFullTP

-- One key press selects the current best candidate and uses the normal Flash route.
_G.TekManualBestTP = function()
    if _manualTPBusy or isTeleporting or _G.TekFlashTeleportRun then return false end
    if LP:GetAttribute("Stealing") == true then return false end
    _manualTPBusy = true
    local ok, result = pcall(function()
        local pets = scanForTP()
        local best
        for _, pet in ipairs(pets or {}) do
            if not pet.conveyor and pet.position and pet.plot and pet.slot ~= nil then
                local priority = tonumber(pet._pri) or math.huge
                local bestPriority = best and (tonumber(best._pri) or math.huge) or math.huge
                if not best or priority < bestPriority
                    or (priority == bestPriority and (tonumber(pet.mps) or 0) > (tonumber(best.mps) or 0)) then
                    best = pet
                end
            end
        end
        if not best then
            warn("[Elysium] Manual TP: no available brainrots")
            return false
        end
        _G.TekStealTargetUID = _petUid(best)
        _G.TekStealTarget = best
        doVelocityTP(true, best)
        return true
    end)
    _manualTPBusy = false
    if not ok then
        _G.TekStealHold = false
        isTeleporting = false
        warn("[Elysium] Manual TP: " .. tostring(result))
        return false
    end
    return result
end

-- CAMP removed. Clear an inherited instance and leave the legacy implementation
-- unreachable; normal manual/automatic teleport remains outside this block.
if _G.TekCamp and type(_G.TekCamp.stop) == "function" then
    pcall(_G.TekCamp.stop)
end
_G.TekCamp = nil
if false then
do
    if _G.TekCamp and type(_G.TekCamp.stop) == "function" then
        pcall(_G.TekCamp.stop)
    end

    local TC = { active = false, target = nil, plotName = nil, status = "idle", arrived = false }
    _G.TekCamp = TC

    local function notify(text)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Base CAMP", Text = tostring(text), Duration = 4,
            })
        end)
    end

    local function plotOwnerName(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local gui = sign and sign:FindFirstChildWhichIsA("SurfaceGui", true)
        local label = gui and gui:FindFirstChildWhichIsA("TextLabel", true)
        local text = label and label.Text
        if type(text) ~= "string" then return nil end
        local owner = text:match("^(.-)'") or text
        owner = owner:gsub("%s+$", "")
        return owner ~= "" and owner or nil
    end

    local function resolvePlayer(query)
        query = tostring(query or ""):lower():gsub("%s+", "")
        if query == "" then return nil end
        local partial
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local name = plr.Name:lower()
                local display = (plr.DisplayName or ""):lower()
                if name == query or display == query then return plr end
                if not partial and (name:find(query, 1, true) or display:find(query, 1, true)) then
                    partial = plr
                end
            end
        end
        return partial
    end

    local function findPlotFor(plr)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local name = plr.Name:lower()
        local display = (plr.DisplayName or ""):lower()
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plotOwnerName(plot)
            owner = owner and owner:lower()
            if owner == name or owner == display then return plot end
        end
        return nil
    end

    local function slotOccupied(slot)
        for _, obj in ipairs(slot:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled and obj.ActionText == "Steal" then
                return true
            end
        end
        return false
    end

    local function campSlot(plot)
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil, nil, false end
        local slots = {}
        for _, slot in ipairs(podiums:GetChildren()) do
            local base = slot:FindFirstChild("Base")
            local spawn = base and base:FindFirstChild("Spawn")
            if spawn and spawn:IsA("BasePart") then slots[#slots + 1] = slot end
        end
        table.sort(slots, function(a, b)
            local an = tonumber(tostring(a.Name):match("%d+"))
            local bn = tonumber(tostring(b.Name):match("%d+"))
            if an and bn then return an < bn end
            return tostring(a.Name) < tostring(b.Name)
        end)
        local firstName, firstPos
        for _, slot in ipairs(slots) do
            local spawn = slot.Base.Spawn
            firstName = firstName or slot.Name
            firstPos = firstPos or spawn.Position
            if not slotOccupied(slot) then return slot.Name, spawn.Position, false end
        end
        return firstName, firstPos, #slots > 0
    end

    local function campTarget()
        local ok, pets = pcall(scanAllPetsCached, 0.05)
        if not ok or type(pets) ~= "table" then
            ok, pets = pcall(scanAllPets)
        end
        if not ok or type(pets) ~= "table" then return nil end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local best, bestDist
        for _, pet in ipairs(pets) do
            if pet and pet.plot == TC.plotName and pet.position then
                local dist = hrp and (pet.position - hrp.Position).Magnitude or 0
                if not best or dist < bestDist then best, bestDist = pet, dist end
            end
        end
        return best
    end

    local function steer()
        if not (TC.active and TC.arrived) then return end
        local pet = campTarget()
        if pet then
            local uid = tostring(pet.plot) .. "_" .. tostring(pet.slot)
            if TC._armedUid ~= uid then
                TC._armedUid = uid
                TC._armedPet = pet
                if _G.TekArmSteal then pcall(_G.TekArmSteal, pet) end
            end
        elseif TC._armedUid then
            TC._armedUid, TC._armedPet = nil, nil
            if _G.TekDisarmSteal then pcall(_G.TekDisarmSteal) end
        end
    end

    TC.stop = function()
        TC.active = false
        TC.target = nil
        TC.plotName = nil
        TC.status = "stopped"
        TC.arrived = false
        TC.entry = nil
        TC._armedUid, TC._armedPet = nil, nil
        if _G.TekDisarmSteal then pcall(_G.TekDisarmSteal) end
    end

    TC.start = function(query)
        local plr = resolvePlayer(query)
        if not plr then TC.status = "player not found"; return false, TC.status end
        local plot = findPlotFor(plr)
        if not plot then TC.status = "base not found"; return false, TC.status end
        if TC.active then TC.stop() end

        local slotName, pos, full = campSlot(plot)
        if not (slotName and pos) then TC.status = "podium not found"; return false, TC.status end

        TC.active = true
        TC.target = plr.Name
        TC.plotName = plot.Name
        TC.arrived = false
        TC.status = full and (plr.Name .. "'s base is FULL") or ("camping " .. plr.Name)
        local entry = {
            plot = plot.Name, slot = tostring(slotName), position = pos,
            uid = plot.Name .. "_" .. tostring(slotName), name = "Camp", index = "Camp", mps = 0,
        }
        TC.entry = entry
        if full then notify(plr.Name .. "'s base is full; using the first podium") end

        task.spawn(function()
            pcall(doVelocityTP, true, entry)
            if not TC.active or TC.entry ~= entry then return end
            TC.entry = nil
            TC.arrived = true
            TC._armedUid, TC._armedPet = nil, nil
            if _G.TekDisarmSteal then pcall(_G.TekDisarmSteal) end
            pcall(steer)
        end)
        return true, TC.status
    end

    Players.PlayerRemoving:Connect(function(plr)
        if TC.active and TC.target == plr.Name then
            notify(plr.Name .. " left; CAMP disabled")
            TC.stop()
        end
    end)

    task.spawn(function()
        while _G.TekCamp == TC do
            task.wait(0.1)
            if TC.active then
                if TC.target and not Players:FindFirstChild(TC.target) then
                    TC.stop()
                else
                    pcall(steer)
                end
            end
        end
    end)
end
end

if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" or #_G.SHARED_PRIORITY_ITEMS == 0 then
_G.SHARED_PRIORITY_ITEMS = {
    "Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl",
    "Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio",
    "Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros",
    "Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal",
    "Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino",
    "Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros",
    "Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero",
    "Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers",
    "Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro",
    "Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch",
    "Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon",
    "Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah",
    "Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos",
    "Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso",
    "Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas",
    "Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros",
    "Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion",
    "Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande",
    "Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta",
    "Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti",
    "Los Bros","Gobblino Uniciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis",
    "Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande",
    "Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67",
    "Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito",
    "Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy",
    "Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni",
    "Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda",
    "Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion",
    "Esok Sekolah",
}
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if gameProcessed then return end
    local keyName = input.KeyCode.Name
    local resetKey = type(_G.TekResetKeyName) == "string" and _G.TekResetKeyName or "X"
    if keyName == resetKey then
        task.spawn(function() pcall(_G.TekInstantReset) end)
        return
    end
    local cloneKey = type(_G.TekCloneKeyName) == "string" and _G.TekCloneKeyName or "V"
    if keyName == cloneKey and not _G.TekManualTPBridgeActive then
        task.spawn(function() pcall(doClone) end)
    end
    local want = _G._stp_tpKeyName
    if type(want) ~= "string" or want == "" then want = "T" end
    -- When Extras is loaded it owns this keybind and calls TekStartSideTP.
    -- Keep this fallback only for standalone tp.txt usage.
    if _G.ElysiumBindListening then return end
    local extrasKeys = _G.ElysiumTPControl and _G.ElysiumTPControl.extrasOwnsKeys
    if extrasKeys and (input.KeyCode.Name == _G.ElysiumAutoTPKeyName
        or input.KeyCode.Name == _G.ElysiumStopTPKeyName) then return end
    if not _G.TekManualTPBridgeActive and input.KeyCode.Name == want then
        task.spawn(function() pcall(manualFullTP) end)
    end
end)

task.spawn(function() pcall(loadModules) pcall(loadNet) end)
task.spawn(function()
    pcall(function()
        local R = game:GetService("ReplicatedStorage")
        local d = R:FindFirstChild("Datas") or R:WaitForChild("Datas", 3)
        if d then
            local a = d:FindFirstChild("Animals") or d:WaitForChild("Animals", 3)
            if a then _AD = require(a) end
            local m = d:FindFirstChild("Mutations") or d:WaitForChild("Mutations", 3)
            if m then _MD = require(m) end
            local t = d:FindFirstChild("Traits") or d:WaitForChild("Traits", 3)
            if t then _TD = require(t) end
        end
    end)
end)
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(0.2)
    for _ = 1, 8 do
        pcall(scanAllPetsCached, 0)
        task.wait(0.08)
    end
    while true do
        pcall(scanAllPetsCached, 0.3)
        task.wait(0.2)
    end
end)

_G.TekChannelsReady = false

local autoTPGeneration = 0
local autoTPEnabled = _G.TekAutoTP ~= false
local function runAutoTP(generation)
    local function cancelled()
        return _G.TekAutoTP == false or generation ~= autoTPGeneration
    end
    local char = LP.Character or LP.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart", 10)
    char:WaitForChild("Humanoid", 10)
    pcall(loadModules)
    if cancelled() then return end

    local _carpetDone = false
    task.spawn(function()
        local _tw = os.clock()
        while os.clock() - _tw < 12 do
            if cancelled() then return end
            for _, n in ipairs(CARPET_NAMES) do
                if findTool(n) then pcall(carpetEngage, _G.TekJoinGrapple ~= false) _carpetDone = true return end
            end
            task.wait(0.05)
        end
        _carpetDone = true
    end)

    local _toolsReady = false
    task.spawn(function()
        if _G.TekWaitForTools ~= false and type(_G.TekToolsReady) == "function" then
            local _tt0 = os.clock()
            local _tcap = tonumber(_G.TekToolWait) or 6
            while os.clock() - _tt0 < _tcap do
                local ok, ready = pcall(_G.TekToolsReady)
                if ok and ready then break end
                if cancelled() then return end
                task.wait(tonumber(_G.TekToolPoll) or 0.02)
            end
        end
        _toolsReady = true
    end)

    local function _channelsProgress()
        local Plots = workspace:FindFirstChild("Plots")
        if not Plots then return 0, 0 end
        local kids = Plots:GetChildren()
        if #kids == 0 then return 0, 0 end
        local ready = 0
        for _, plot in ipairs(kids) do
            if getPlotChannel(plot.Name) then ready = ready + 1 end
        end
        return ready, #kids
    end

    local _bootT0 = os.clock()
    local _wMax = tonumber(_G.TekAutoTPWait) or 15
    local _chanGrace = tonumber(_G.TekChanGrace) or 2
    local _petsFound = nil
    local _lastTop = nil

    while os.clock() - _bootT0 < _wMax do
        if cancelled() then return end
        if LP:GetAttribute("Stealing") == true then return end

        local ready, total = _channelsProgress()
        local chanOk = (total > 0 and ready >= total)
            or (total > 0 and ready >= (total - _chanGrace) and (os.clock() - _bootT0) > _chanGrace)

        local ok, pets = pcall(scanForTP)
        if ok and pets and #pets > 0 then
            _petsFound = pets
            local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
            if chanOk and top == _lastTop then break end
            _lastTop = top
        end

        RunService.Heartbeat:Wait()
    end

    do
        local _d = tonumber(_G._stp_tpDelay) or tonumber(_G.TPDelay) or 0
        if _d > 0 then task.wait(_d) end
    end

    if cancelled() then return end

    local _wt0 = os.clock()
    while (not _carpetDone or not _toolsReady) and os.clock() - _wt0 < 3 do
        if cancelled() then return end
        task.wait(0.03)
    end

    while isTeleporting do
        if cancelled() then return end
        task.wait(0.05)
    end
    if cancelled() then return end
    local tpOk, tpError = pcall(doVelocityTP, true)
    if not tpOk then
        isTeleporting = false
        _manualTPBusy = false
        _G.TekStealHold = false
        _G.ElysiumLastTPError = tostring(tpError)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Elysium TP", Text = "TP error: " .. tostring(tpError), Duration = 8,
            })
        end)
    end
    if _G.TekScanProfile then _G.TekScanProfile("normal") end
end
_G.TekSetAutoTP = function(enabled)
    enabled = enabled == true
    local changed = autoTPEnabled ~= enabled
    autoTPEnabled = enabled
    _G.TekAutoTP, _G.ElysiumAutoTP = enabled, enabled
    if _G.ElysiumTPControl then _G.ElysiumTPControl.autoEnabled = enabled end
    if not enabled then
        autoTPGeneration = autoTPGeneration + 1
    elseif changed then
        autoTPGeneration = autoTPGeneration + 1
        task.spawn(runAutoTP, autoTPGeneration)
    end
    if _G.TekRepaintAutoTP then pcall(_G.TekRepaintAutoTP) end
    if _G.TekSaveSettings then pcall(_G.TekSaveSettings) end
end
_G.TekStopTeleport = function()
    _G.TekTPStop, _G.ElysiumTPStop = true, true
    _G.TekClickTPPending = nil
    _G.TekStealHold = false
    _G.TekSetAutoTP(false)
end
if _G.ElysiumTPControl and type(_G.ElysiumTPControl.autoEnabled) == "boolean" then
    _G.TekAutoTP = _G.ElysiumTPControl.autoEnabled
end
autoTPEnabled = _G.TekAutoTP ~= false
task.spawn(runAutoTP, autoTPGeneration)

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer

    local PG = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 20)


    local GUIHOST = (gethui and gethui()) or game:GetService("CoreGui")

    local function diag()
        pcall(loadModules)
        local Plots = workspace:FindFirstChild("Plots")
        local nPlots = Plots and #Plots:GetChildren() or 0
        local nCh, nOwn, nAl = 0,0,0
        if Plots then
            for _, plot in ipairs(Plots:GetChildren()) do
                local ch = getPlotChannel(plot.Name)
                if ch then
                    nCh = nCh + 1
                    if ownerInGame(ch) then nOwn = nOwn + 1 end
                    if channelGet(ch, "AnimalList") then nAl = nAl + 1 end
                end
            end
        end
        local pets = scanAllPetsCached(0.12)
        local ok = pets ~= nil
        local nPets = (ok and pets and #pets) or 0
        local msg = string.format("plots=%d ch=%d owner=%d animals=%d PETS=%d", nPlots, nCh, nOwn, nAl, nPets)
        
        if nPets > 0 and pets[1] then
            
        end
        return nPets
    end

    local _fspOverlap = OverlapParams.new()
    _fspOverlap.FilterType = Enum.RaycastFilterType.Exclude
    local function _promptWorldPos(p)
        local pp = p and p.Parent
        if not pp then return nil end
        if pp:IsA("Attachment") then return pp.WorldPosition end
        if pp:IsA("BasePart") then return pp.Position end
        return nil
    end
    local function findStealPrompt(pet, includeDisabled)
        if not pet then return nil end
        local podPrompt
        if pet.plot and pet.slot then
            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(pet.plot)
            local podiums = plot and plot:FindFirstChild("AnimalPodiums")
            local podium = podiums and podiums:FindFirstChild(tostring(pet.slot))
            if podium then
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attach = spawn and spawn:FindFirstChild("PromptAttachment")
                if attach then
                    for _, p in ipairs(attach:GetChildren()) do
                        if p:IsA("ProximityPrompt") and (p.Enabled or includeDisabled)
                            and tostring(p.ActionText or ""):find("Steal") then podPrompt = p break end
                    end
                end
                if not podPrompt then
                    for _, candidate in ipairs(podium:GetDescendants()) do
                        if candidate:IsA("ProximityPrompt") and (candidate.Enabled or includeDisabled)
                            and tostring(candidate.ActionText or ""):find("Steal") then
                            podPrompt = candidate
                            break
                        end
                    end
                end
            end
        end
        -- A scanned pet already has an exact plot/slot identity. If its prompt is
        -- gone or disabled, the pet was taken/changed; never substitute a prompt
        -- from the neighbouring podium.
        if pet.plot and pet.slot then return podPrompt end
        if pet.position then
            local pp = podPrompt and _promptWorldPos(podPrompt)
            if (not podPrompt) or (pp and (pp - pet.position).Magnitude > 15) then
                _fspOverlap.FilterDescendantsInstances = LP.Character and { LP.Character } or {}
                local okB, parts = pcall(workspace.GetPartBoundsInRadius, workspace, pet.position, 14, _fspOverlap)
                if okB and parts then
                    local best, bestD
                    for _, part in ipairs(parts) do
                        local pr = part:FindFirstChildOfClass("ProximityPrompt")
                        if not pr then
                            for _, ch in ipairs(part:GetChildren()) do
                                if ch:IsA("Attachment") then
                                    pr = ch:FindFirstChildOfClass("ProximityPrompt")
                                    if pr then break end
                                end
                            end
                        end
                        if pr and pr.Enabled and tostring(pr.ActionText or ""):find("Steal") then
                            local pos = _promptWorldPos(pr)
                            local d = pos and (pos - pet.position).Magnitude or math.huge
                            if not best or d < bestD then best, bestD = pr, d end
                        end
                    end
                    if best then return best end
                end
            end
        end
        return podPrompt
    end

    local InternalStealCache = {}
    local STEAL_HOLD_DURATION = 1.3
    local STEAL_PROXIMITY = tonumber(_G.TekStealProximity) or 31
    local _stealHoldStart, _stealHoldActive = 0, false
    local _stealHoldGeneration, _stealHoldPetUid = 0, nil
    local _stealHoldCarry, _stealHoldCarryUid = 0, nil
    local _stealHoldCarryInherited = false
    local _stealHoldCarryPrecharged = false
    local _prechargeUid, _prechargeAt, _prechargeTouchedAt, _prechargeHeldSeenAt = nil, 0, 0, 0
    local _prechargePulseAt = 0
    local _clearPrecharge
    local showStealBar

    local _stealTarget, _stealArmedAt = nil, 0
    local _lastTargetPick, _lastPickUid, _currentTargetName = 0, nil, nil
    local _stealLastScan, _autoLastScan = 0, 0
    local _inRangeLast = 0
    local _armCheckAt = 0
    local _petsCache, _petsCacheAt = nil, 0


    local function _scanCached(now, maxAge)
        if _petsCache and (now - _petsCacheAt) <= (maxAge or 0.1) then return _petsCache end
        local pets = scanAllPetsCached(0.08)
        local ok = pets ~= nil
        if ok and type(pets) == "table" then
            _petsCache, _petsCacheAt = pets, now
            return pets
        end
        return nil
    end


    local function _petListed(plot, slot)
        local ch = getPlotChannel(plot)
        local al = ch and channelGet(ch, "AnimalList")
        if type(al) ~= "table" then return true, false end
        local e = al[slot]
        if e == nil then e = al[tonumber(slot) or -1] end
        if e == nil then e = al[tostring(slot)] end
        return e ~= nil, true
    end

    local function _prox()
        return tonumber(_G.TekAutoGrabRadius) or tonumber(_G.TekStealProximity) or 95
    end
    local STEAL_HOLD_MAX = 2.6
    local function _holdDur()


        if _G.TekStealHoldFull == true then return STEAL_HOLD_MAX end
        local h = tonumber(_G.TekStealHoldDuration) or STEAL_HOLD_DURATION
        if h < STEAL_HOLD_DURATION then h = STEAL_HOLD_DURATION elseif h > STEAL_HOLD_MAX then h = STEAL_HOLD_MAX end
        return h
    end



    local _cooldownUntil = 0
    local function _verifyFire(pet, path, judge)
        task.delay(tonumber(_G.TekVerifyDelay) or 0.35, function()
            if not (pet and pet.plot and pet.slot ~= nil) then return end
            local listed, known = true, false
            pcall(function() listed, known = _petListed(pet.plot, pet.slot) end)
            if not known then return end
            if not listed then
                _G.TekStealFails = 0
                _cooldownUntil = 0
                
                return
            end
            if not judge then _cooldownUntil = 0 return end

        end)
    end
    local function _holdBusy()
        return _stealHoldActive
    end

    local _armedPet, _armLostSince = nil, 0
    local function _armLivePos(p)
        if not (p and p.plot and p.slot ~= nil) then return nil end
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(p.plot)
        if not plot then return nil end
        local ok, pos = pcall(getPetPosition, plot, p.slot)
        if ok then return pos end
        return nil
    end
    _G.TekArmSteal = function(pet)
        if _G.TekSourceStealActive then return end
        if type(pet) ~= "table" or type(pet.plot) ~= "string" or pet.slot == nil then return end
        local newUid = _petUid(pet)
        local previousUid = _armedPet and _petUid(_armedPet) or _stealHoldPetUid
        if _stealHoldActive and _stealHoldPetUid and newUid ~= _stealHoldPetUid then
            -- Hand the elapsed hold to the new prompt instead of starting at zero.
            local elapsed = math.max(0, tick() - _stealHoldStart)
            _stealHoldCarry = math.max(_stealHoldCarry, math.min(elapsed, STEAL_HOLD_MAX))
            _stealHoldCarryUid = newUid
            _stealHoldCarryInherited = true
            _stealHoldGeneration += 1
        elseif LP:GetAttribute("Stealing") == true
            and (not previousUid or newUid ~= previousUid) then
            -- The previous steal already completed and is in our hands. After Drop
            -- Brainrot the selected replacement should be ready to fire immediately.
            _stealHoldCarry = STEAL_HOLD_MAX
            _stealHoldCarryUid = newUid
            _stealHoldCarryInherited = false
        elseif _stealHoldCarry > 0 and _stealHoldCarryUid ~= newUid then
            _stealHoldCarryUid = newUid
        end
        _armedPet = {
            name = pet.name, index = pet.index, mps = pet.mps, _pri = pet._pri,
            plot = pet.plot, slot = tostring(pet.slot), position = pet.position,
        }
        _armLostSince = 0
        _stealTarget = _armedPet
        _stealArmedAt = os.clock()
        if type(pet.name) == "string" and pet.name ~= "" then _currentTargetName = pet.name end
        if _stealHoldCarryUid == newUid and _stealHoldCarry > 0 and showStealBar then
            showStealBar(pet.name, math.min(_stealHoldCarry / STEAL_HOLD_DURATION, 1))
        end
    end
    _G.TekDisarmSteal = function()
        if _stealHoldActive then _stealHoldGeneration += 1 end
        _armedPet, _armLostSince = nil, 0
        _stealTarget = nil
        _lastPickUid = nil
        _stealHoldCarry, _stealHoldCarryUid = 0, nil
        _stealHoldCarryInherited = false
        _stealHoldCarryPrecharged = false
        if _clearPrecharge then _clearPrecharge(false) end
    end
    _G.TekArmedName = function() return _armedPet and _armedPet.name or nil end

    local UIC = {
        bg   = Color3.fromRGB(18, 18, 18),
        bg2  = Color3.fromRGB(28, 28, 28),
        card = Color3.fromRGB(35, 35, 35),
        track = Color3.fromRGB(45, 45, 45),
        line = Color3.fromRGB(60, 60, 60),
        acc  = Color3.fromRGB(255, 255, 255),
        acc2 = Color3.fromRGB(220, 220, 220),
        txt  = Color3.fromRGB(240, 240, 240),
        dim  = Color3.fromRGB(140, 140, 140),
    }
    local UIF, UIFB = Enum.Font.SourceSans, Enum.Font.SourceSansBold

    local function mk(class, parent, props)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function corner(o, r) r = r or 8; if r >= 8 then r = 4 elseif r >= 6 then r = 6 end; mk("UICorner", o, { CornerRadius = UDim.new(0, r) }) return o end
    local function stroke(o, col) mk("UIStroke", o, { Color = col or UIC.line, Thickness = 1 }) return o end

    pcall(function()
        local _oldDbg = LP:FindFirstChild("PlayerGui")
        _oldDbg = _oldDbg and _oldDbg:FindFirstChild("TekStealDbg")
        if _oldDbg then _oldDbg:Destroy() end
    end)

    local stealBarSg, stealBarFill, stealBarTitle, stealBarGen, stealBarStatus, stealBarSeconds
    local _lastFillX = -1
    local _ragdollShown = false
    local _ragdollStartedAt = 0
    local _ragdollInitialRemaining = 0
    local _ragdollEndSeen = 0
    local STEAL_ACCENT = Color3.fromRGB(245, 245, 245)
    local STEAL_DONE = Color3.fromRGB(30, 185, 100)
    local STEAL_HOLD = Color3.fromRGB(255, 190, 60)
    local STEAL_RAG = Color3.fromRGB(235, 110, 60)

    local function shortMoney(value)
        value = tonumber(value) or 0
        local abs = math.abs(value)
        local suffix, div = "", 1
        if abs >= 1e12 then suffix, div = "T", 1e12
        elseif abs >= 1e9 then suffix, div = "B", 1e9
        elseif abs >= 1e6 then suffix, div = "M", 1e6
        elseif abs >= 1e3 then suffix, div = "K", 1e3 end
        local scaled = value / div
        local text = (math.abs(scaled) >= 100 or div == 1)
            and string.format("%.0f", scaled) or string.format("%.1f", scaled)
        return text:gsub("%.0$", "") .. suffix
    end

    local function refreshStealTargetLabels(fallbackName)
        local pet = _armedPet or _stealTarget
        local name = fallbackName or (pet and pet.name) or _currentTargetName or "No Target"
        stealBarTitle.Text = tostring(name)
        local mps = pet and tonumber(pet.mps)
        stealBarGen.Text = mps and mps > 0 and ("$" .. shortMoney(mps) .. "/s") or ""
    end

    local function ensureStealBar()
        if stealBarSg and stealBarSg.Parent then return end

        for _, par in ipairs({ GUIHOST, PG }) do
            pcall(function()
                local old = par and par:FindFirstChild("TekStealBar")
                if old then old:Destroy() end
                local legacyBar = par and par:FindFirstChild("MeerkoStealBar")
                if legacyBar then legacyBar:Destroy() end
            end)
        end
        stealBarSg = mk("ScreenGui", GUIHOST, {
            Name = "TekStealBar", ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 120,
        })
        do
            local us = stealBarSg:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
            us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = stealBarSg
        end
        local wrap = mk("Frame", stealBarSg, {
            Name = "Wrap", AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -100), Size = UDim2.fromOffset(310, 82),
            BackgroundColor3 = Color3.fromRGB(16, 16, 18), BackgroundTransparency = 0.08,
            BorderSizePixel = 0, ClipsDescendants = true,
        })
        mk("UICorner", wrap, { CornerRadius = UDim.new(0, 10) })
        mk("UIGradient", wrap, {
            Rotation = 135,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 34, 37)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 18)),
            }),
        })
        mk("UIStroke", wrap, { Color = Color3.fromRGB(65, 65, 70), Thickness = 1, Transparency = 0.25 })
        _G.TekRepaintStealMode = function() end
        stealBarTitle = mk("TextLabel", wrap, {
            Size = UDim2.new(1, -96, 0, 18), Position = UDim2.fromOffset(12, 9),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 12,
            TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "No Target",
        })
        stealBarGen = mk("TextLabel", wrap, {
            Size = UDim2.fromOffset(78, 18), Position = UDim2.new(1, -90, 0, 9),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 11,
            TextColor3 = Color3.fromRGB(245, 245, 245), TextXAlignment = Enum.TextXAlignment.Right,
            Text = "",
        })
        stealBarStatus = mk("TextLabel", wrap, {
            Size = UDim2.new(1, -112, 0, 15), Position = UDim2.fromOffset(12, 31),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 10,
            TextColor3 = Color3.fromRGB(225, 225, 228), TextXAlignment = Enum.TextXAlignment.Left,
            Text = "",
        })
        stealBarSeconds = mk("TextLabel", wrap, {
            Size = UDim2.fromOffset(92, 15), Position = UDim2.new(1, -104, 0, 31),
            BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 10,
            TextColor3 = Color3.fromRGB(155, 155, 160), TextXAlignment = Enum.TextXAlignment.Right,
            Text = "",
        })
        local track = mk("Frame", wrap, {
            Position = UDim2.new(0, 12, 1, -24), Size = UDim2.new(1, -24, 0, 14),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35), BackgroundTransparency = 0,
            BorderSizePixel = 0,
        })
        mk("UICorner", track, { CornerRadius = UDim.new(0, 5) })
        stealBarFill = mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = STEAL_ACCENT, BorderSizePixel = 0,
        })
        mk("UICorner", stealBarFill, { CornerRadius = UDim.new(0, 5) })

        _lastFillX = -1
        stealBarSg.Enabled = true
    end


    local function _setFill(x)
        if math.abs(x - _lastFillX) < 0.002 then return end
        _lastFillX = x
        stealBarFill.Size = UDim2.new(x, 0, 1, 0)
    end
    local function setStealBarPhase(phase, pct, seconds)
        if not stealBarSg or not stealBarSg.Enabled or _ragdollShown then return end
        pct = math.clamp(tonumber(pct) or 0, 0, 1)
        local color, status, timeText = STEAL_ACCENT, "READY", ""
        if phase == "stealing" then
            status = "STEALING  " .. math.floor(pct * 100) .. "%"
            timeText = string.format("%.1fs left", math.max(tonumber(seconds) or 0, 0))
        elseif phase == "grabbing" then
            color, status, pct = STEAL_DONE, "IN RANGE  -  GRABBING", 1
        elseif phase == "hold" then
            color, status, pct = STEAL_HOLD, "HOLD", 1
            timeText = string.format("restart %.1fs", math.max(tonumber(seconds) or 0, 0))
        elseif phase == "stolen" then
            color, status, pct = STEAL_DONE, "STOLEN", 1
        else
            status, pct = "READY", 0
            timeText = string.format("%.1fs", math.max(tonumber(seconds) or STEAL_HOLD_DURATION, 0))
        end
        stealBarFill.BackgroundColor3 = color
        stealBarStatus.TextColor3 = color
        stealBarStatus.Text = status
        stealBarSeconds.Text = timeText
        _setFill(pct)
    end
    _G.TekSetStealBarPhase = setStealBarPhase
    showStealBar = function(name, pct)
        pcall(function()
            ensureStealBar()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarSg.Enabled = true
            refreshStealTargetLabels(name)
            if _ragdollShown then return end
            setStealBarPhase(pct > 0 and "stealing" or "ready", pct, STEAL_HOLD_DURATION * (1 - pct))
        end)
    end
    local function setStealBarPct(pct)
        if not stealBarSg or not stealBarSg.Enabled or _ragdollShown then return end
        pct = math.clamp(tonumber(pct) or 0, 0, 1)
        setStealBarPhase("stealing", pct, STEAL_HOLD_DURATION * (1 - pct))
    end

    local function setStealBarSeconds(secLeft, frac)
        if not stealBarSg or not stealBarSg.Enabled or _ragdollShown then return end
        frac = math.clamp(tonumber(frac) or 0, 0, 1)
        stealBarSeconds.Text = string.format("%.1fs", math.max(tonumber(secLeft) or 0, 0))
        _setFill(frac)
    end
    local function hideStealBar()
        pcall(function()
            ensureStealBar()
            if _ragdollShown then return end
            stealBarSg.Enabled = true
            refreshStealTargetLabels()
            setStealBarPhase("ready", 0, STEAL_HOLD_DURATION)
        end)
    end
    _clearPrecharge = function(resetCarry)
        local oldUid = _prechargeUid
        _prechargeUid, _prechargeAt, _prechargeTouchedAt, _prechargeHeldSeenAt = nil, 0, 0, 0
        _prechargePulseAt = 0
        if resetCarry and _stealHoldCarryPrecharged
            and (not oldUid or _stealHoldCarryUid == oldUid) then
            _stealHoldCarry, _stealHoldCarryUid = 0, nil
            _stealHoldCarryPrecharged = false
        end
        if resetCarry and not _holdBusy() then hideStealBar() end
    end
    task.defer(hideStealBar)

    local _ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.PlatformStanding] = true,
    }

    local function ragdollRemainingNow()
        local now = workspace:GetServerTimeNow()
        local attrEnd = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
        local observedEnd = tonumber(_G.TekRagdollObservedUntil) or 0
        return math.max(0, math.max(attrEnd, observedEnd) - now)
    end

    local function ragdollActiveNow()
        if ragdollRemainingNow() > 0.02 then return true end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return hum ~= nil and _ragdollStates[hum:GetState()] == true
    end

    local function captureRagdollEnd()
        local serverNow = workspace:GetServerTimeNow()
        local attrEnd = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
        if attrEnd > serverNow then
            _G.TekRagdollObservedUntil = math.max(tonumber(_G.TekRagdollObservedUntil) or 0, attrEnd)
        end
    end
    if _G.TekRagdollAttrConn then
        pcall(function() _G.TekRagdollAttrConn:Disconnect() end)
    end
    _G.TekRagdollAttrConn = LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(captureRagdollEnd)
    captureRagdollEnd()

    if _G.TekRagdollBarConn then
        pcall(function() _G.TekRagdollBarConn:Disconnect() end)
    end
    _G.TekRagdollBarConn = RunService.RenderStepped:Connect(function()
        local serverNow = workspace:GetServerTimeNow()
        local attrEnd = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
        local observedEnd = tonumber(_G.TekRagdollObservedUntil) or 0
        local ragdollEnd = math.max(attrEnd, observedEnd)
        local remaining = math.max(0, ragdollEnd - serverNow)
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local stateRagdoll = hum and _ragdollStates[hum:GetState()] == true
        if stateRagdoll and remaining <= 0 then
            ragdollEnd = serverNow + (tonumber(_G.TekRagdollFallbackSeconds) or 0.75)
            _G.TekRagdollObservedUntil = ragdollEnd
            remaining = ragdollEnd - serverNow
        end
        local active = remaining > 0 or stateRagdoll

        if active then
            local enteredRagdoll = not _ragdollShown
            if enteredRagdoll or ragdollEnd > _ragdollEndSeen + 0.05 then
                _ragdollShown = true
                _ragdollStartedAt = os.clock()
                _ragdollInitialRemaining = math.max(remaining, 0.1)
                _ragdollEndSeen = ragdollEnd
            end
            if enteredRagdoll then
                _G.TekInvisBlockedUntil = math.max(tonumber(_G.TekInvisBlockedUntil) or 0, ragdollEnd)
                task.defer(function()
                    if _G.TekDisableInvisibleSteal then
                        pcall(_G.TekDisableInvisibleSteal, "ragdoll")
                    elseif (_G.TekInvisActive == true or _G.invisibleStealEnabled == true)
                        and _G.toggleInvisibleSteal then
                        pcall(_G.toggleInvisibleSteal)
                    end
                end)
            end
            ensureStealBar()
            refreshStealTargetLabels()
            stealBarFill.BackgroundColor3 = STEAL_RAG
            stealBarStatus.Text = "RAGDOLLED"
            stealBarStatus.TextColor3 = STEAL_RAG
            if remaining > 0 then
                stealBarSeconds.Text = string.format("%.1fs", remaining)
                -- A ragdoll is useful pre-hold time: keep the steal visibly primed
                -- without committing until the character can act again.
                _setFill((_stealHoldActive or _stealTarget) and 0.90 or 0)
            else
                local elapsed = math.max(0, os.clock() - _ragdollStartedAt)
                stealBarSeconds.Text = string.format("%.1fs", elapsed)
                _setFill((_stealHoldActive or _stealTarget) and 0.90 or 0)
            end
        elseif _ragdollShown then
            _ragdollShown = false
            _ragdollStartedAt = 0
            _ragdollInitialRemaining = 0
            _ragdollEndSeen = 0
            if observedEnd <= serverNow then _G.TekRagdollObservedUntil = 0 end
            stealBarFill.BackgroundColor3 = STEAL_ACCENT
            if _stealHoldActive then
                refreshStealTargetLabels()
                stealBarStatus.Text = "STEALING"
                stealBarStatus.TextColor3 = STEAL_ACCENT
                stealBarSeconds.Text = ""
            else
                hideStealBar()
            end
        end
    end)

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        if not prompt or not prompt.Parent then return end
        local data = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local function grab(sig, into)
            local ok, conns = pcall(getconnections, sig)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    if type(c.Function) == "function" then table.insert(into, c.Function) end
                end
            end
        end
        grab(prompt.PromptButtonHoldBegan, data.holdCallbacks)
        grab(prompt.Triggered, data.triggerCallbacks)
        grab(prompt.PromptButtonHoldEnded, data.holdEndCallbacks)
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 or #data.holdEndCallbacks > 0 then
            InternalStealCache[prompt] = data
        end
    end

    local _stealBegin

    -- Rose Auto Grab sequence: arm the game's steal state before firing the
    -- captured hold callbacks.  The direct begin remote is a fallback for
    -- builds where the prompt callback no longer sets State itself.
    local function _armRoseSteal(prompt)
        if not prompt or not prompt.Parent then return false end
        pcall(function()
            if prompt:GetAttribute("State") ~= nil then prompt:SetAttribute("State", "Steal") end
        end)
        pcall(_stealBegin)
        return true
    end

    local function _triggerRoseSteal(prompt, data)
        if not prompt or not prompt.Parent then return false end
        local fired = false
        for _, fn in ipairs(data and data.triggerCallbacks or {}) do
            task.spawn(fn)
            fired = true
        end
        if not fired and fireproximityprompt then
            pcall(fireproximityprompt, prompt)
            fired = true
        end
        return fired
    end

    local _rawFireServer = Instance.new("RemoteEvent").FireServer
    local _reBegin, _reCommit = nil, nil
    local _reState, _reRetryAt = {}, {}
    local function _re(cache, hash)
        if cache and cache.Parent then return cache end
        local st = _reState[hash]
        if typeof(st) == "Instance" then
            if st.Parent then return st end
            _reState[hash] = nil
            st = nil
        end
        if st == "pending" then return nil end
        if st == "failed" and os.clock() < (_reRetryAt[hash] or 0) then return nil end
        _reState[hash] = "pending"
        task.spawn(function()
            local got
            pcall(function()
                if _G.TekGetRemote then got = _G.TekGetRemote("RemoteEvent", hash) end
            end)
            if typeof(got) == "Instance" then
                _reState[hash] = got
                
            else
                _reState[hash] = "failed"
                _reRetryAt[hash] = os.clock() + (tonumber(_G.TekRemoteRetry) or 5)
                
            end
        end)
        task.delay(tonumber(_G.TekRemoteResolveWait) or 3, function()
            if _reState[hash] == "pending" then
                _reState[hash] = "failed"
                _reRetryAt[hash] = os.clock() + (tonumber(_G.TekRemoteRetry) or 5)
                
            end
        end)
        return nil
    end

    _stealBegin = function()
        _reBegin = _re(_reBegin, "f40f7d9e-2f0d-4167-b250-899273f46874")
        if not _reBegin then return false end
        local t = workspace:GetServerTimeNow() + 124
        pcall(_rawFireServer, _reBegin, t, "68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0")
        pcall(function() _rawFireServer(_reBegin, t, "07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd") end)
        return true
    end

    local function _stealCommit(plot, slot)
        _reCommit = _re(_reCommit, "3ba148c9-7ed6-4675-93f8-9f7c356a2c54")
        if not _reCommit then return false end
        if type(plot) ~= "string" or slot == nil then return false end
        local sl = tonumber(slot) or slot
        local t = workspace:GetServerTimeNow() + 31
        pcall(_rawFireServer, _reCommit, t, "cda5c764-d4e3-45c4-94e4-53a538347590", plot, sl)
        pcall(function()
            _rawFireServer(_reCommit, t, "8c852fbf-d542-4ef4-aa28-612e24db8d4a", plot, sl)
        end)
        return true
    end
    _G.TekStealBegin, _G.TekStealCommit = _stealBegin, _stealCommit

    local function executeStealAsyncLegacy(prompt, petName, restoreMax, pet)
        if _holdBusy() then
            return false
        end
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        local petUid = _petUid(pet)
        local carried = 0
        if _stealHoldCarryUid == petUid then
            carried = math.clamp(tonumber(_stealHoldCarry) or 0, 0, STEAL_HOLD_MAX)
        end
        local inheritedHold = carried > 0 and _stealHoldCarryInherited == true
        local prechargedHold = carried > 0 and _stealHoldCarryPrecharged == true
        _stealHoldCarry, _stealHoldCarryUid = 0, nil
        _stealHoldCarryInherited = false
        _stealHoldCarryPrecharged = false
        _stealHoldStart = tick() - carried
        _stealHoldActive = true
        _stealHoldGeneration += 1
        local holdGeneration = _stealHoldGeneration
        _stealHoldPetUid = petUid
        local initialPrompt = prompt
        local restoreHoldDuration
        pcall(function()
            prompt.MaxActivationDistance = math.huge
            if carried > 0 then
                restoreHoldDuration = prompt.HoldDuration
                prompt.HoldDuration = 0
            end
        end)
        if not inheritedHold and not prechargedHold then _armRoseSteal(prompt) end
        showStealBar(petName, math.min(carried / STEAL_HOLD_DURATION, 1))
        if _G.TekStealQuick == true then
            task.spawn(function()
                if not inheritedHold then
                    for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                    if not prechargedHold then _armRoseSteal(prompt) end
                end
                _G.TekStealSrvEnd = workspace:GetServerTimeNow()
                    + math.max(0, STEAL_HOLD_DURATION - carried)
                local _barConn
                pcall(function()
                    _barConn = RunService.RenderStepped:Connect(function()
                        if holdGeneration ~= _stealHoldGeneration then return end
                        local rem = _G.TekStealSrvEnd and (_G.TekStealSrvEnd - workspace:GetServerTimeNow()) or 0
                        if rem <= 0 then
                            setStealBarPct(1)
                        else
                            setStealBarPct(1 - rem / STEAL_HOLD_DURATION)
                        end
                    end)
                end)
                while holdGeneration == _stealHoldGeneration
                    and (_G.TekStealSrvEnd - workspace:GetServerTimeNow()) > 0 do
                    RunService.Heartbeat:Wait()
                end
                while holdGeneration == _stealHoldGeneration
                    and ragdollActiveNow() and prompt and prompt.Parent do
                    RunService.Heartbeat:Wait()
                end
                local cancelled = holdGeneration ~= _stealHoldGeneration
                if _barConn then pcall(function() _barConn:Disconnect() end) end
                if not cancelled and prompt and prompt.Parent then
                    _triggerRoseSteal(prompt, data)
                elseif not cancelled then
                    local replacement = findStealPrompt(pet)
                    if replacement then
                        buildStealCallbacks(replacement)
                        local replacementData = InternalStealCache[replacement]
                        if replacementData then
                            _armRoseSteal(replacement)
                            for _, fn in ipairs(replacementData.holdCallbacks) do task.spawn(fn) end
                            _triggerRoseSteal(replacement, replacementData)
                            for _, fn in ipairs(replacementData.holdEndCallbacks) do task.spawn(fn) end
                        end
                    else
                        _armedPet, _armLostSince = nil, 0
                    end
                end
                local handingOff = cancelled and _stealHoldCarryUid ~= nil
                    and _stealHoldCarryInherited == true
                if not handingOff then
                    for _, fn in ipairs(data.holdEndCallbacks) do task.spawn(fn) end
                end
                if not cancelled then task.wait(0.05) end
                _stealHoldActive = false
                _stealHoldPetUid = nil
                _G.TekStealSrvEnd = nil
                if restoreMax ~= nil then
                    pcall(function()
                        if prompt and prompt.Parent then prompt.MaxActivationDistance = restoreMax end
                    end)
                end
                if restoreHoldDuration ~= nil then
                    pcall(function()
                        if initialPrompt and initialPrompt.Parent then
                            initialPrompt.HoldDuration = restoreHoldDuration
                        end
                    end)
                end
                data.ready = true
                if not (cancelled and _stealHoldCarryUid) then hideStealBar() end
            end)
            return true
        end
        task.spawn(function()
            if not inheritedHold then
                for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                if not prechargedHold then _armRoseSteal(prompt) end
            end
            local GRAB_MIN = STEAL_HOLD_DURATION
            local GRAB_MAX = tonumber(_G.TekStealHoldMax) or STEAL_HOLD_MAX
            pcall(function()
                local hd = prompt.HoldDuration
                if type(hd) == "number" and hd > 0 and hd + 0.05 > GRAB_MIN then
                    GRAB_MIN = hd + 0.05
                end
            end)
            if GRAB_MAX < GRAB_MIN then GRAB_MAX = GRAB_MIN end
            local _ppSeen, _ppKind, _charSeen, _hrpSeen = nil, 0, nil, nil
            local function _grabRange()
                local char = LP.Character
                if not char then return true end
                if char ~= _charSeen then
                    _charSeen = char
                    _hrpSeen = char:FindFirstChild("HumanoidRootPart")
                end
                local hrp = _hrpSeen
                if not hrp or hrp.Parent ~= char then
                    hrp = char:FindFirstChild("HumanoidRootPart")
                    _hrpSeen = hrp
                    if not hrp then return true end
                end
                local pp = prompt.Parent
                if not pp then return true end
                if pp ~= _ppSeen then
                    _ppSeen = pp
                    _ppKind = (pp:IsA("Attachment") and 1) or (pp:IsA("BasePart") and 2) or 0
                end
                local pos
                if _ppKind == 1 then pos = pp.WorldPosition
                elseif _ppKind == 2 then pos = pp.Position
                else return true end
                return (hrp.Position - pos).Magnitude <= (tonumber(_G.TekStealGrabDist) or 12)
            end
            local DWELL = tonumber(_G.TekStealDwell) or 0.22
            local readyAt = carried >= GRAB_MIN and (tick() - DWELL) or nil
            local _gone = false
            local _barConn
            pcall(function()
                _barConn = RunService.RenderStepped:Connect(function()
                    if holdGeneration ~= _stealHoldGeneration then return end
                    local el = tick() - _stealHoldStart
                    if not (prompt and prompt.Parent and prompt:IsDescendantOf(workspace)) then return end
                    if el < GRAB_MIN then
                        setStealBarPct(el / GRAB_MIN)
                    else
                        local span = GRAB_MAX - GRAB_MIN
                        local left = GRAB_MAX - el
                        setStealBarPct(span > 0 and (1 - left / span) or 1)
                    end
                end)
            end)
            local _cancelled, _grabbed = false, false
            while true do
                if holdGeneration ~= _stealHoldGeneration then
                    _cancelled = true
                    break
                end
                if LP:GetAttribute("Stealing") == true then
                    _grabbed = true
                    break
                end
                local el = tick() - _stealHoldStart
                if not (prompt and prompt.Parent and prompt:IsDescendantOf(workspace) and prompt.Enabled) then
                    local replacement = findStealPrompt(pet)
                    if replacement and replacement.Enabled then
                        buildStealCallbacks(replacement)
                        local replacementData = InternalStealCache[replacement]
                        if replacementData then
                            data.ready = true
                            prompt, data = replacement, replacementData
                            data.ready = false
                            _ppSeen, _ppKind = nil, 0
                            pcall(function() prompt.MaxActivationDistance = math.huge end)
                            _armRoseSteal(prompt)
                            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                        else
                            RunService.Heartbeat:Wait()
                            continue
                        end
                    else
                        -- A carried brainrot temporarily loses/disables its prompt.
                        -- Keep this hold alive so a grief/drop resumes immediately
                        -- instead of restarting the whole grab from zero.
                        local currentUid = _stealTarget and _petUid(_stealTarget)
                        if currentUid and currentUid ~= petUid then
                            _gone = true
                            break
                        end
                        if tick() - _prechargePulseAt >= (tonumber(_G.TekPrechargePulse) or 0.18) then
                            _prechargePulseAt = tick()
                            pcall(_stealBegin)
                            _armRoseSteal(prompt)
                            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                        end
                        if el >= GRAB_MAX then
                            -- The prompt can stay disabled for the entire time that
                            -- another player carries the pet. Start a fresh full
                            -- cycle anyway instead of leaving the first one saturated.
                            _stealHoldStart = tick()
                            readyAt = nil
                            setStealBarPct(0)
                            pcall(_stealBegin)
                            _armRoseSteal(prompt)
                            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                        end
                        RunService.Heartbeat:Wait()
                        continue
                    end
                end
                local ragActive = ragdollActiveNow()
                if el >= GRAB_MAX and not ragActive then
                    -- Keep cycling the same steal while somebody else carries it:
                    -- commit once, immediately begin another full hold, and only
                    -- stop after we actually receive the brainrot or change target.
                    if prompt and prompt.Parent and prompt.Enabled then
                        _triggerRoseSteal(prompt, data)
                    end
                    RunService.Heartbeat:Wait()
                    if LP:GetAttribute("Stealing") == true then
                        _grabbed = true
                        break
                    end
                    local currentUid = _stealTarget and _petUid(_stealTarget)
                    if currentUid and currentUid ~= petUid then
                        _gone = true
                        break
                    end
                    _stealHoldStart = tick()
                    readyAt = nil
                    _armRoseSteal(prompt)
                    for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                    setStealBarPct(0)
                    continue
                end
                if not ragActive and _grabRange() then
                    if not readyAt then readyAt = tick() end
                    if el >= GRAB_MIN and (tick() - readyAt) >= DWELL then break end
                else
                    readyAt = nil
                end
                RunService.Heartbeat:Wait()
            end
            if _barConn then pcall(function() _barConn:Disconnect() end) end
            if not _cancelled then setStealBarPct(0) end
            if not _cancelled and not _grabbed and not _gone and prompt and prompt.Parent then
                _triggerRoseSteal(prompt, data)
            elseif not _cancelled and _gone then
                _armedPet, _armLostSince = nil, 0
            end
            local handingOff = _cancelled and _stealHoldCarryUid ~= nil
                and _stealHoldCarryInherited == true
            if not handingOff then
                for _, fn in ipairs(data.holdEndCallbacks) do task.spawn(fn) end
            end
            if not _cancelled then task.wait(0.05) end
            _stealHoldActive = false
            _stealHoldPetUid = nil
            if restoreMax ~= nil then
                pcall(function()
                    if prompt and prompt.Parent then prompt.MaxActivationDistance = restoreMax end
                end)
            end
            if restoreHoldDuration ~= nil then
                pcall(function()
                    if initialPrompt and initialPrompt.Parent then
                        initialPrompt.HoldDuration = restoreHoldDuration
                    end
                end)
            end
            data.ready = true
            if not (_cancelled and _stealHoldCarryUid) then hideStealBar() end
        end)
        return true
    end

    -- Rose vNext Auto Grab port.  This intentionally shadows the legacy
    -- implementation above so the surrounding Tek target picker/teleporter can
    -- stay unchanged while the prompt/hold/commit state machine is replaced.
    local _roseActionPromptCache = setmetatable({}, { __mode = "k" })
    local _roseHoldEpoch = 0

    local function _rosePromptDistance(prompt)
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, nil end
        local parent = prompt and prompt.Parent
        local pos
        if parent then
            if parent:IsA("Attachment") then
                pos = parent.WorldPosition
            elseif parent:IsA("BasePart") then
                pos = parent.Position
            else
                local part = parent:FindFirstAncestorWhichIsA("BasePart")
                if part then pos = part.Position end
            end
        end
        if not pos then return nil, nil end
        local hp = hrp.Position
        local dx, dz = pos.X - hp.X, pos.Z - hp.Z
        return math.sqrt(dx * dx + dz * dz), (pos - hp).Magnitude
    end

    local function _roseActionPrompt(prompt, data)
        local cached = _roseActionPromptCache[prompt]
        if cached ~= nil then return cached or nil end
        if debug and debug.getupvalues and data then
            for _, fn in ipairs(data.holdCallbacks or {}) do
                local ok, upvalues = pcall(debug.getupvalues, fn)
                if ok and type(upvalues) == "table" then
                    for _, value in pairs(upvalues) do
                        if type(value) == "table"
                            and rawget(value, "State") ~= nil
                            and rawget(value, "ProximityPrompt") ~= nil then
                            _roseActionPromptCache[prompt] = value
                            return value
                        end
                    end
                end
            end
        end
        _roseActionPromptCache[prompt] = false
        return nil
    end

    local function _roseFireHold(prompt, data)
        if not data or #(data.holdCallbacks or {}) == 0 then return false end
        local actionPrompt = _roseActionPrompt(prompt, data)
        if actionPrompt and actionPrompt.State ~= "Steal" then
            local oldState = actionPrompt.State
            actionPrompt.State = "Steal"
            for _, fn in ipairs(data.holdCallbacks) do pcall(fn) end
            actionPrompt.State = oldState
            return true
        end
        if not actionPrompt and prompt and prompt.Enabled == false then return false end
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        return true
    end

    local function _roseFireTrigger(prompt, data)
        if not prompt then return false end
        if fireproximityprompt and _G.TekStealUseFPP ~= false then
            pcall(fireproximityprompt, prompt)
            return true
        end
        local fired = false
        for _, fn in ipairs(data and data.triggerCallbacks or {}) do
            task.spawn(fn)
            fired = true
        end
        if not fired and fireproximityprompt then
            pcall(fireproximityprompt, prompt)
            fired = true
        end
        return fired
    end

    local function _roseRefreshCallbacks(prompt)
        if not prompt then return nil end
        _roseActionPromptCache[prompt] = nil
        InternalStealCache[prompt] = nil
        buildStealCallbacks(prompt)
        return InternalStealCache[prompt]
    end

    local function _roseHeldByOtherPlayer(pet)
        if not pet then return false end
        local wantedIndex = tostring(pet.index or ""):lower():gsub("%s+", "")
        local wantedName = tostring(pet.name or ""):lower():gsub("%s+", "")
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                local index = player:GetAttribute("StealingIndex")
                if index == nil and player.Character then
                    index = player.Character:GetAttribute("StealingIndex")
                end
                local held = tostring(index or ""):lower():gsub("%s+", "")
                if held ~= "" and (held == wantedIndex or held == wantedName) then return true end
            end
        end
        return false
    end

    local function _roseLivePetDistance(pet, prompt)
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local pos = _armLivePos(pet)
        if pos then
            pet.position = pos
            return (pos - hrp.Position).Magnitude
        end
        local _, distance3d = _rosePromptDistance(prompt)
        return distance3d
    end

    local function _roseTpBlocking(petUid)
        local moving = _G.TekStealHold == true
        if not moving and type(_G.TekIsTeleporting) == "function" then
            local ok, value = pcall(_G.TekIsTeleporting)
            moving = ok and value == true
        end
        if not moving then return false end
        local currentUid = _stealTarget and _petUid(_stealTarget)
        return currentUid == nil or currentUid == petUid
    end

    local function executeStealAsync(prompt, petName, restoreMax, pet)
        if _holdBusy() or not (prompt and prompt.Parent) then return false end
        local data = InternalStealCache[prompt] or _roseRefreshCallbacks(prompt)
        if not data or not data.ready then return false end

        data.ready = false
        local petUid = _petUid(pet)
        local carried = 0
        if _stealHoldCarryUid == petUid then
            carried = math.clamp(tonumber(_stealHoldCarry) or 0, 0, STEAL_HOLD_MAX)
        end
        _stealHoldCarry, _stealHoldCarryUid = 0, nil
        _stealHoldCarryInherited = false
        _stealHoldCarryPrecharged = false
        _stealHoldGeneration += 1
        local generation = _stealHoldGeneration
        _stealHoldPetUid = petUid
        _stealHoldActive = true
        _stealHoldStart = tick() - carried

        local initialPrompt = prompt
        local oldDuration
        pcall(function()
            oldDuration = prompt.HoldDuration
            prompt.HoldDuration = 0
            prompt.MaxActivationDistance = math.huge
        end)
        showStealBar(petName, math.clamp(carried / STEAL_HOLD_DURATION, 0, 1))

        task.spawn(function()
            local activePrompt, activeData = prompt, data
            local touchedData = { [data] = true }
            local touchedMax = setmetatable({ [prompt] = restoreMax == nil and false or restoreMax }, { __mode = "k" })
            local function preparePrompt(nextPrompt)
                if touchedMax[nextPrompt] == nil then
                    local previous
                    pcall(function() previous = nextPrompt.MaxActivationDistance end)
                    touchedMax[nextPrompt] = previous == nil and false or previous
                end
                pcall(function()
                    nextPrompt.HoldDuration = 0
                    nextPrompt.MaxActivationDistance = math.huge
                end)
            end
            local duration = tonumber(_G.TekStealDuration)
            if not duration then
                local serverDuration = (_G.TekStealUsePromptHold == true) and tonumber(oldDuration) or nil
                duration = ((serverDuration and serverDuration > 0.1 and serverDuration) or STEAL_HOLD_DURATION)
                    + (tonumber(_G.TekStealHoldPad) or 0)
            end
            local maxCycle = tonumber(_G.TekStealMaxHold)
                or (duration + (tonumber(_G.TekStealExtendWindow) or 1.3))
            local absoluteStart = tick()
            local beginAt = 0
            local carryAge = _roseHoldEpoch > 0 and (tick() - _roseHoldEpoch) or math.huge
            if carried > 0 and carryAge <= (tonumber(_G.TekStealCarryMax) or 1.25) then
                beginAt = _roseHoldEpoch
            elseif _roseFireHold(activePrompt, activeData) then
                beginAt = activePrompt.Enabled and tick() or 0
                if beginAt > 0 then _roseHoldEpoch = beginAt end
            end
            local cycleAt = carried > 0 and (tick() - math.min(carried, duration)) or tick()
            _stealHoldStart = cycleAt

            local abort, grabbed, recycle = false, false, false
            local promptGoneAt, disabledAt = nil, nil
            local bankAt, eligibilityAt = 0, 0
            local commitCount, lastCommitAt = 0, 0
            local clearFireUntil, commitGraceUntil = 0, 0
            local wasTpBlocking = false

            local ok, runtimeError = pcall(function()
                while true do
                    local now = tick()
                    if generation ~= _stealHoldGeneration then abort = true break end
                    if LP:GetAttribute("Stealing") == true then
                        grabbed = true
                        setStealBarPhase("stolen", 1, 0)
                        break
                    end
                    local currentUid = _stealTarget and _petUid(_stealTarget)
                    if currentUid and petUid and currentUid ~= petUid then abort = true break end

                    if not (activePrompt and activePrompt.Parent and activePrompt:IsDescendantOf(workspace)) then
                        promptGoneAt = promptGoneAt or now
                        local replacement = findStealPrompt(pet)
                        if replacement and replacement.Parent then
                            local replacementData = _roseRefreshCallbacks(replacement)
                            if replacementData then
                                activePrompt, activeData = replacement, replacementData
                                touchedData[activeData] = true
                                activeData.ready = false
                                preparePrompt(activePrompt)
                                if _roseFireHold(activePrompt, activeData) then
                                    bankAt, beginAt, _roseHoldEpoch = now, now, now
                                end
                                promptGoneAt, disabledAt = nil, nil
                                cycleAt, commitCount, lastCommitAt, recycle = now, 0, 0, false
                            else
                                task.wait(tonumber(_G.TekStealPoll) or 0.03)
                                continue
                            end
                        else
                            if bankAt == 0 or now - bankAt > (tonumber(_G.TekStealBankRefresh) or 2.5) then
                                if _roseFireHold(activePrompt, activeData) then
                                    bankAt, _roseHoldEpoch = now, now
                                end
                            end
                            if now - promptGoneAt > (tonumber(_G.TekStealPromptGoneWait) or 6.5) then break end
                            setStealBarPhase("hold", 1, math.max(
                                (tonumber(_G.TekStealPromptGoneWait) or 6.5) - (now - promptGoneAt), 0
                            ))
                            task.wait(tonumber(_G.TekStealPoll) or 0.03)
                            continue
                        end
                    end

                    if activePrompt.Parent and not activePrompt.Enabled then
                        disabledAt = disabledAt or now
                        if bankAt == 0 or now - bankAt > (tonumber(_G.TekStealBankRefresh) or 2.5) then
                            if _roseFireHold(activePrompt, activeData) then
                                bankAt, _roseHoldEpoch = now, now
                            end
                        end
                        if now - disabledAt > (tonumber(_G.TekStealDisabledGrace) or 3)
                            and not _roseHeldByOtherPlayer(pet) then break end
                        cycleAt, commitCount, lastCommitAt, recycle = now, 0, 0, false
                        _stealHoldStart = bankAt > 0 and bankAt or now
                        setStealBarPhase("hold", 1, math.max(
                            (tonumber(_G.TekStealDisabledGrace) or 3) - (now - disabledAt), 0
                        ))
                        task.wait(tonumber(_G.TekStealPoll) or 0.03)
                        continue
                    elseif disabledAt then
                        disabledAt = nil
                        activeData = _roseRefreshCallbacks(activePrompt) or activeData
                        touchedData[activeData] = true
                        if bankAt > 0 and now - bankAt <= (tonumber(_G.TekStealBankUseMax) or 2.3) then
                            beginAt, cycleAt, _stealHoldStart = bankAt, bankAt, bankAt
                        elseif _roseFireHold(activePrompt, activeData) then
                            beginAt, cycleAt, _stealHoldStart = now, now, now
                            _roseHoldEpoch = now
                        end
                        bankAt, commitCount, lastCommitAt, recycle = 0, 0, 0, false
                        eligibilityAt = now - (tonumber(_G.TekStealEntryDelay) or 0.3)
                        clearFireUntil = math.max(clearFireUntil, now + (tonumber(_G.TekStealDropSettle) or 0.5))
                    end

                    if #(activeData.holdCallbacks or {}) == 0 then
                        activeData = _roseRefreshCallbacks(activePrompt) or activeData
                        touchedData[activeData] = true
                        if beginAt == 0 and _roseFireHold(activePrompt, activeData) then
                            beginAt, cycleAt, _stealHoldStart = now, now, now
                            _roseHoldEpoch = now
                        end
                    end

                    local ragBlocked = ragdollActiveNow()
                    if commitCount == 0 and not ragBlocked and beginAt > 0
                        and now - beginAt > (tonumber(_G.TekStealSrvHoldMax) or 2.5) then
                        if _roseFireHold(activePrompt, activeData) then
                            beginAt, cycleAt, _stealHoldStart = now, now, now
                            _roseHoldEpoch = now
                        end
                    end

                    local petDistance = _roseLivePetDistance(pet, activePrompt)
                    local inRange = petDistance ~= nil
                        and petDistance <= (tonumber(_G.TekStealCommitRange) or tonumber(_G.TekStealGrabDist) or 10)
                    local tpBlocking = _G.TekStealTpGate ~= false and _roseTpBlocking(petUid)
                    if wasTpBlocking and not tpBlocking then
                        clearFireUntil = math.max(clearFireUntil, now + (tonumber(_G.TekStealTpRelGrace) or 0.75))
                    end
                    wasTpBlocking = tpBlocking
                    if inRange and not tpBlocking then
                        eligibilityAt = eligibilityAt > 0 and eligibilityAt or now
                    else
                        eligibilityAt = 0
                    end

                    local entryDelay = tonumber(_G.TekStealEntryDelay) or 0.3
                    local settled = eligibilityAt > 0 and now - eligibilityAt >= entryDelay
                    local holdDone = now - cycleAt >= duration
                    local serverHold = tonumber(_G.TekStealSrvHold) or duration
                    local serverHoldMax = tonumber(_G.TekStealSrvHoldMax) or 2.5
                    local beginAge = beginAt > 0 and (now - beginAt) or -1
                    local canCommit = holdDone and not ragBlocked and inRange and not tpBlocking and settled
                        and beginAge >= serverHold and beginAge <= serverHoldMax

                    if canCommit and commitCount == 0 then
                        lastCommitAt, commitCount = now, 1
                        _roseFireTrigger(activePrompt, activeData)
                    end
                    if commitCount > 0 and now - lastCommitAt >= (tonumber(_G.TekStealCommitWait) or 0.4) then
                        recycle = true
                    end

                    commitGraceUntil = 0
                    if _G.TekStealHoldForSettle ~= false and not grabbed
                        and (eligibilityAt > 0 or ragBlocked) then
                        local margin = tonumber(_G.TekStealCommitFireMargin) or 0.06
                        if commitCount == 0 then
                            local due = cycleAt + duration + margin
                            if eligibilityAt > 0 and not settled then
                                due = math.max(due, eligibilityAt + entryDelay + margin)
                            end
                            if beginAt > 0 then due = math.max(due, beginAt + serverHold + margin) end
                            commitGraceUntil = due
                        else
                            commitGraceUntil = lastCommitAt + (tonumber(_G.TekStealCommitWait) or 0.4)
                        end
                    end

                    local elapsed = now - cycleAt
                    if canCommit or commitCount > 0 then
                        setStealBarPhase("grabbing", 1, 0)
                    elseif holdDone then
                        local restartIn = math.max(commitGraceUntil - now, maxCycle - elapsed, 0)
                        setStealBarPhase("hold", 1, restartIn)
                    else
                        local pct = math.clamp(elapsed / math.max(duration, 0.01), 0, 1)
                        setStealBarPhase("stealing", pct, math.max(duration - elapsed, 0))
                    end

                    if ((elapsed >= maxCycle or recycle)
                        and now >= clearFireUntil and now >= commitGraceUntil and not tpBlocking) then break end
                    if now - absoluteStart > (tonumber(_G.TekStealHoldMaxTotal) or 20) then break end
                    task.wait(tonumber(_G.TekStealPoll) or 0.03)
                end
            end)

            if activePrompt and activePrompt.Parent and not abort and not grabbed and commitCount == 0 then
                local distance = _roseLivePetDistance(pet, activePrompt)
                local serverHold = tonumber(_G.TekStealSrvHold) or duration
                local age = beginAt > 0 and (tick() - beginAt) or -1
                if distance and distance <= (tonumber(_G.TekStealCommitRange) or 10)
                    and activePrompt.Enabled and age >= serverHold
                    and age <= (tonumber(_G.TekStealSrvHoldMax) or 2.5) then
                    _roseFireTrigger(activePrompt, activeData)
                end
            end

            if activeData and activeData.holdEndCallbacks then
                for _, fn in ipairs(activeData.holdEndCallbacks) do task.spawn(fn) end
            end
            pcall(function()
                if initialPrompt and initialPrompt.Parent then
                    initialPrompt.HoldDuration = oldDuration
                end
            end)
            if activePrompt ~= initialPrompt then
                pcall(function()
                    if activePrompt and activePrompt.Parent then activePrompt.HoldDuration = oldDuration end
                end)
            end
            for touchedPrompt, previousMax in pairs(touchedMax) do
                if touchedPrompt and touchedPrompt.Parent and previousMax ~= false then
                    pcall(function() touchedPrompt.MaxActivationDistance = previousMax end)
                end
            end
            for touched in pairs(touchedData) do touched.ready = true end
            -- A target handoff deliberately increments the generation to cancel
            -- this coroutine. Release the old target's busy flag by UID; checking
            -- the generation here leaves _stealHoldActive stuck forever and the
            -- replacement target can never start its inherited hold.
            if _stealHoldPetUid == petUid then
                _stealHoldActive = false
                _stealHoldPetUid = nil
            end
            if grabbed then
                setStealBarPhase("stolen", 1, 0)
            elseif not (_stealHoldCarryUid and _stealHoldCarryInherited) then
                hideStealBar()
            end
            if not ok then _G.TekAutoGrabLastError = tostring(runtimeError) end
        end)
        return true
    end

    local function timeUntilCanSteal()
        if LP:GetAttribute("Stealing") or LP:GetAttribute("IsTrading")
            or LP:GetAttribute("IsDuelSelecting") or LP:GetAttribute("Web") then
            return -1
        end
        local ragdoll = LP:GetAttribute("RagdollEndTime")
        if ragdoll then
            local r = ragdoll - workspace:GetServerTimeNow()
            if r > 0 then return r end
        end
        return 0
    end

    local stealOn = (_G.TekStealMode ~= nil)
    local _emptyScans = 0
    local function _animalSlotEntry(pet, memo)
        if type(pet) ~= "table" or type(pet.plot) ~= "string" or pet.slot == nil then return nil, "noKey" end
        local animalList = memo and memo[pet.plot]
        if animalList == nil then
            local channel = getPlotChannel(pet.plot)
            local list = channel and channelGet(channel, "AnimalList") or nil
            animalList = type(list) == "table" and list or false
            if memo then memo[pet.plot] = animalList end
        end
        if animalList == false then return nil, "noChannel" end
        local entry = animalList[pet.slot]
        if entry == nil then
            local numericSlot = tonumber(pet.slot)
            if numericSlot ~= nil then entry = animalList[numericSlot] end
        end
        return entry
    end

    local function _heldByOtherPlayer(pet)
        if not pet then return false end
        local function norm(v)
            return tostring(v or ""):lower():gsub("%s+", "")
        end
        local wantedIndex, wantedName = norm(pet.index), norm(pet.name)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local idx = plr:GetAttribute("StealingIndex")
                if idx == nil and plr.Character then idx = plr.Character:GetAttribute("StealingIndex") end
                local held = norm(idx)
                local stealing = plr:GetAttribute("Stealing") == true
                    or (plr.Character and plr.Character:GetAttribute("Stealing") == true)
                if stealing and held ~= "" and (held == wantedIndex or held == wantedName) then return true end
            end
        end
        return false
    end

    local function _isBeingStolen(pet, memo)
        if _G.TekSkipStolenTarget == false then return false end
        if type(pet) ~= "table" or pet.conveyor or type(pet.plot) ~= "string" or pet.slot == nil then return false end
        local entry, why = _animalSlotEntry(pet, memo)
        if type(entry) == "table" then
            local stealerId = entry.Steal
            if type(stealerId) ~= "number" or stealerId == LP.UserId then return false end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.UserId == stealerId then
                    return plr:GetAttribute("Stealing") == true
                        or (plr.Character and plr.Character:GetAttribute("Stealing") == true)
                end
            end
            return false
        end
        -- If the synchronized slot has just disappeared, use the active
        -- stealer's species as a short handoff fallback. With no channel data
        -- at all, do not guess.
        if why then return false end
        return _heldByOtherPlayer(pet)
    end
    _G.TekIsBeingStolen = _isBeingStolen

    local function _swapStolenTarget(current, currentY)
        if _G.TekSkipStolenTarget == false then return nil end
        -- A UID lock is an explicit click/manual choice; match Rose and do not
        -- silently override it.
        local manualUid = _G.TekStealTargetUID
        if type(manualUid) == "string" and manualUid ~= "" then return nil end
        if type(current) ~= "table" or type(current.plot) ~= "string" or current.conveyor then return nil end

        local memo = {}
        if not _isBeingStolen(current, memo) then return nil end
        local pets = _scanCached(os.clock(), 0.05) or scanAllPetsCached(0.05) or {}
        local currentUid = _petUid(current)
        local floorBand = tonumber(_G.TekStolenSwapFloorBand) or 10
        local replacement
        for _, candidate in ipairs(pets) do
            if candidate and not candidate.conveyor and candidate.plot == current.plot
                and _petUid(candidate) ~= currentUid and candidate.position
                and (not currentY or math.abs(candidate.position.Y - currentY) <= floorBand)
                and not _isBeingStolen(candidate, memo) then
                local prompt = findStealPrompt(candidate)
                if prompt and prompt.Parent and prompt.Enabled then
                    replacement = candidate
                    break
                end
            end
        end
        if not replacement then return nil end

        _stealTarget = replacement
        _currentTargetName = tostring(replacement.name or replacement.index or "Unknown")
        _lastTargetPick = os.clock()
        _G.TekStealTarget = replacement
        _G.TekLastStolenSwap = {
            from = currentUid,
            to = _petUid(replacement),
            at = tick(),
        }
        if _G.TekArmSteal then pcall(_G.TekArmSteal, replacement) end
        showStealBar(_currentTargetName, math.clamp(
            (tonumber(_stealHoldCarry) or 0) / math.max(STEAL_HOLD_DURATION, 0.01), 0, 1
        ))
        return replacement
    end

    local function _primeUnavailableTarget(pet)
        local uid = _petUid(pet)
        local now = tick()
        local held = _heldByOtherPlayer(pet)
        if held then _prechargeHeldSeenAt = now end
        if _prechargeUid ~= uid then
            local carried = (_stealHoldCarryUid == uid) and (tonumber(_stealHoldCarry) or 0) or 0
            _prechargeUid = uid
            _prechargeAt = now - math.clamp(carried, 0, STEAL_HOLD_DURATION)
            _prechargeHeldSeenAt = held and now or 0
            pcall(_stealBegin)
        end
        if now - _prechargePulseAt >= (tonumber(_G.TekPrechargePulse) or 0.18) then
            _prechargePulseAt = now
            pcall(_stealBegin)
        end
        _prechargeTouchedAt = now
        local elapsed = math.clamp(now - _prechargeAt, 0, STEAL_HOLD_DURATION)
        _stealHoldCarry = elapsed
        _stealHoldCarryUid = uid
        _stealHoldCarryInherited = false
        _stealHoldCarryPrecharged = true
        showStealBar(pet.name, elapsed / STEAL_HOLD_DURATION)
        return true
    end

    local function _fireSteal(pet)
        if _G.TekSourceStealActive then return false end
        if not pet then return false end
        if _holdBusy() then  return false end
        local _fhrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local _fd = (_fhrp and pet.position) and (pet.position - _fhrp.Position).Magnitude or nil
        local _judge = (_fd ~= nil) and (_fd <= _prox() + 2) or false
        local _cd = _holdDur() + (tonumber(_G.TekStealCycleGap) or 0)
        


        local prompt = findStealPrompt(pet)
        if not prompt or not prompt.Parent then
            _primeUnavailableTarget(pet)
            return false
        end
        local oldMax
        pcall(function() oldMax = prompt.MaxActivationDistance end)
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then
            if executeStealAsync(prompt, pet.name, oldMax, pet) then
                _prechargeUid, _prechargeAt, _prechargeTouchedAt, _prechargeHeldSeenAt = nil, 0, 0, 0
                _G.TekLastFire = os.clock()
                _verifyFire(pet, "prompt", _judge)
                return true
            end

            if oldMax ~= nil then pcall(function() prompt.MaxActivationDistance = oldMax end) end
            return false
        elseif fireproximityprompt then
            _clearPrecharge(false)
            _stealHoldCarryPrecharged = false
            pcall(function() prompt.MaxActivationDistance = math.huge end)
            showStealBar(pet.name, 1)
            pcall(function() fireproximityprompt(prompt) end)
            _G.TekLastFire = os.clock()
            _verifyFire(pet, "prompt", _judge)

            task.delay(0.4, hideStealBar)
            pcall(function() if oldMax ~= nil then prompt.MaxActivationDistance = oldMax end end)
            return true
        end
        
        return false
    end
    _G.TekFireSteal = _fireSteal
    -- Keep one real prompt hold across a laser shot; a UI precharge is not readiness.
    _G.TekLaserGrab = {}
    local function laserEndHold(session)
        if session.enabledConn then session.enabledConn:Disconnect(); session.enabledConn=nil end
        if session.holdAt and session.data then
            for _, fn in ipairs(session.data.holdEndCallbacks or {}) do pcall(fn) end
        end
        session.holdAt=nil
    end
    function _G.TekLaserGrab.Begin(holder)
        if _G.TekLaserGrabSession or _holdBusy() then return nil,"another pickup is active" end
        if _G.TekIsTeleporting and _G.TekIsTeleporting() then return nil,"finish TP first" end
        if timeUntilCanSteal() ~= 0 then return nil,"cannot pick up now" end
        local found, memo=nil,{}
        for _, pet in ipairs(scanAllPetsCached(0.2) or {}) do
            local entry=_animalSlotEntry(pet,memo)
            if type(entry)=="table" and entry.Steal==holder.UserId then
                if found then return nil,"ambiguous carried brainrot" end
                found=pet
            end
        end
        if not found then return nil,"carried brainrot not in scanner" end
        local session={holder=holder,pet=found,uid=_petUid(found),character=LP.Character,
            oldUid=_G.TekStealTargetUID,oldPet=_G.TekStealTarget,started=os.clock(),commits=0}
        _G.TekLaserGrabSession=session
        _G.TekStealTargetUID,_G.TekStealTarget=session.uid,found
        _G.TekArmSteal(found)
        return session
    end
    function _G.TekLaserGrab.Poll(session, afterShot)
        local function result(ready,status,done)
            session.status=status
            _G.TekLaserGrabDiag={status=status,uid=session.uid,commits=session.commits,
                shot=session.shotAt~=nil,holdAge=session.holdAt and tick()-session.holdAt or 0,
                enabled=session.prompt and session.prompt.Parent and session.prompt.Enabled or false}
            return ready,status,done
        end
        if _G.TekLaserGrabSession~=session then return result(false,"cancelled",true) end
        if LP.Character~=session.character or _G.TekTPStop
            or (_G.TekIsTeleporting and _G.TekIsTeleporting()) then
            return result(false,"character/TP changed",true)
        end
        if _G.TekStealTargetUID~=session.uid then return result(false,"target changed",true) end
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then return result(false,"character unavailable",true) end
        local entry=_animalSlotEntry(session.pet)
        if type(entry)=="table" and entry.Steal==LP.UserId and LP:GetAttribute("Stealing") then
            session.success=true
            return result(true,"picked up",true)
        end
        if type(entry)~="table" then
            -- Replication may briefly remove the slot during the drop.
            return result(false,"waiting for slot replication",false)
        end
        if entry.Index~=session.pet.index then return result(false,"slot changed",true) end
        if not afterShot and entry.Steal~=session.holder.UserId then
            return result(false,"player no longer holds this brainrot",true)
        end
        if afterShot and type(entry.Steal)=="number" and entry.Steal>0
            and entry.Steal~=session.holder.UserId and entry.Steal~=LP.UserId then
            return result(false,"another player picked it up",true)
        end
        if timeUntilCanSteal()~=0 or _G.RecoveryInProgress then
            return result(false,"waiting for pickup eligibility",false)
        end
        -- A carried pet may have no client prompt when joining mid-carry.
        -- Allow one unprimed shot only at this pet's exact pickup location.
        local function unavailablePrompt(status)
            if afterShot or session.shotAt then return result(false,status,false) end
            local plots=workspace:FindFirstChild("Plots")
            local plot=plots and plots:FindFirstChild(session.pet.plot)
            local podiums=plot and plot:FindFirstChild("AnimalPodiums")
            local podium=podiums and podiums:FindFirstChild(tostring(session.pet.slot))
            local base=podium and podium:FindFirstChild("Base")
            local spawn=base and base:FindFirstChild("Spawn")
            local attach=spawn and spawn:FindFirstChild("PromptAttachment")
            local position=attach and attach:IsA("Attachment") and attach.WorldPosition
                or spawn and spawn:IsA("BasePart") and spawn.Position
            local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local range=tonumber(_G.TekStealCommitRange) or tonumber(_G.TekStealGrabDist) or 10
            if not position or not root then return result(false,"waiting for exact pickup location",false) end
            if (root.Position-position).Magnitude>range then
                return result(false,"move within pickup range ("..tostring(range)..")",false)
            end
            if os.clock()-session.started<0.35 then return result(false,status,false) end
            session.unprimedShot=true
            return result(true,"prompt unavailable: shoot then prepare pickup",false)
        end
        local prompt=session.prompt
        if not prompt or not prompt.Parent then
            if session.nextFind and os.clock()<session.nextFind then return unavailablePrompt("waiting for pickup prompt") end
            session.nextFind=os.clock()+0.1
            prompt=findStealPrompt(session.pet,true)
            if not prompt then return unavailablePrompt("waiting for pickup prompt") end
            laserEndHold(session)
            session.prompt=prompt
            session.data=_roseRefreshCallbacks(prompt)
            session.enabledConn=prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
                if prompt.Enabled and session.shotAt and _G.TekLaserGrabSession==session then
                    local ok,err=pcall(_G.TekLaserGrab.Poll,session,true)
                    if not ok then session.status=tostring(err) end
                end
            end)
        end
        local _,distance=_rosePromptDistance(prompt)
        local range=tonumber(_G.TekStealCommitRange) or tonumber(_G.TekStealGrabDist) or 10
        if not distance or distance>range then
            if session.holdAt then
                for _,fn in ipairs(session.data and session.data.holdEndCallbacks or {}) do pcall(fn) end
                session.holdAt=nil
            end
            return result(false,"move within pickup range ("..tostring(range)..")",false)
        end
        local duration=math.max(_holdDur(),tonumber(_G.TekStealDuration) or 0,
            tonumber(_G.TekStealSrvHold) or 0)
        local maxAge=tonumber(_G.TekStealSrvHoldMax) or 2.5
        if duration+0.15>=maxAge then return result(false,"hold duration exceeds pickup window",true) end
        if not session.holdAt or tick()-session.holdAt>maxAge-0.1 then
            if session.nextHoldTry and os.clock()<session.nextHoldTry then
                return unavailablePrompt("waiting for prompt callbacks")
            end
            session.nextHoldTry=os.clock()+0.15
            if session.holdAt then
                for _,fn in ipairs(session.data and session.data.holdEndCallbacks or {}) do pcall(fn) end
                session.holdAt=nil
            end
            session.data=_roseRefreshCallbacks(prompt)
            if not _roseFireHold(prompt,session.data) then
                return unavailablePrompt("cannot prepare this pickup prompt")
            end
            session.holdAt=tick()
            session.commits=0
        end
        local ready=tick()-session.holdAt>=duration
        if afterShot and session.shotAt and ready and prompt.Enabled
            and entry.Steal~=session.holder.UserId and session.commits<3
            and (not session.lastCommit or tick()-session.lastCommit>=0.15) then
            session.lastCommit=tick()
            session.commits=session.commits+1
            _roseFireTrigger(prompt,session.data)
        end
        return result(ready,afterShot and (session.commits>0 and "pickup sent; awaiting server" or "waiting for drop")
            or (ready and "ready" or "preparing actual prompt hold"),false)
    end
    function _G.TekLaserGrab.Shot(session)
        if _G.TekLaserGrabSession~=session then return end
        session.shotAt=os.clock()
        _G.TekLaserGrab.Poll(session,true)
    end
    function _G.TekLaserGrab.Finish(session)
        if _G.TekLaserGrabSession~=session then return end
        _G.TekLaserGrabSession=nil
        laserEndHold(session)
        if _G.TekStealTargetUID==session.uid then
            _G.TekDisarmSteal()
            _G.TekStealTargetUID,_G.TekStealTarget=session.oldUid,session.oldPet
            if session.oldPet then _G.TekArmSteal(session.oldPet) end
        end
    end

    local function _stealTick()
        if _G.TekSourceStealActive then return end
        if _G.TekLaserGrabSession then return end
        _G.TekTickN = (_G.TekTickN or 0) + 1
        stealOn = (_G.TekStealMode ~= nil)
        if not stealOn then  return end
        local now = os.clock()
        if _prechargeUid and not _holdBusy()
            and (tick() - _prechargeTouchedAt) > 0.75 then
            _clearPrecharge(true)
        end
        local _lockUid = _G.TekStealTargetUID
        local _lockChanged = (type(_lockUid) == "string" and _lockUid ~= "" and _lockUid ~= _lastPickUid)
        -- Pick once, then keep that exact brainrot until the user changes or
        -- clears it. A temporarily missing/stolen prompt must never advance
        -- Auto Grab to the next entry in the priority list.
        local _needPick = (not _stealTarget) or _lockChanged
        if _armedPet then
            local _lp = _armLivePos(_armedPet)
            if _lp then
                _armedPet.position = _lp
                _armLostSince = 0
            elseif _armLostSince == 0 then
                _armLostSince = now
            end
            if _armedPet and (now - _armCheckAt) >= (tonumber(_G.TekArmCheckGap) or 0.3) then
                _armCheckAt = now
                local okL, listed = pcall(_petListed, _armedPet.plot, _armedPet.slot)
                if okL and not listed then
                    -- Keep the locked descriptor and its last known position.
                    -- The slot commonly disappears while another player carries
                    -- this brainrot; _primeUnavailableTarget keeps it precharged.
                    _armLostSince = _armLostSince == 0 and now or _armLostSince
                end
            end
            if _armedPet then
                _stealTarget = _armedPet
                if type(_armedPet.name) == "string" then _currentTargetName = _armedPet.name end
                _needPick = false
            end
        end
        local _scanGap = (_emptyScans >= 3) and (tonumber(_G.TekStealIdleGap) or 0.2) or 0.01
        if not LP:GetAttribute("Stealing") and _needPick and (now - _autoLastScan) >= _scanGap then
            _autoLastScan = now
            _lastTargetPick = now
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pets = _scanCached(now, 0.05)
                local ok = pets ~= nil
                if ok and pets and #pets > 0 then _emptyScans = 0 else _emptyScans = _emptyScans + 1 end
                if ok and pets and #pets > 0 then
                    local best
                    local hasUidLock = type(_lockUid) == "string" and _lockUid ~= ""
                    if hasUidLock then
                        for _, p in ipairs(pets) do
                            if not p.conveyor and _petUid(p) == _lockUid then best = p break end
                        end
                    end
                    if not best and not hasUidLock and _G.TekStealMode == "nearest" then
                        local myPos = hrp.Position
                        local bestD = math.huge
                        for _, p in ipairs(pets) do
                            if not p.conveyor and p.position then
                                local d = (p.position - myPos).Magnitude
                                if d < bestD then bestD = d; best = p end
                            end
                        end
                    elseif not best and not hasUidLock then
                        for _, p in ipairs(pets) do if not p.conveyor then best = p; break end end
                    end
                    -- With an explicit/manual UID lock, absence from the scan is
                    -- a wait state, never permission to select pets[1].
                    if not hasUidLock then best = best or pets[1] end
                    if best then
                        _stealTarget = best
                        _stealArmedAt = now
                        _lastPickUid = _lockUid
                        if type(best.name) == "string" and best.name ~= "" then
                            _currentTargetName = best.name
                        end
                    end
                end
            end
        end
        if not _stealTarget and _G.TekStealMode == "nearest"
            and not (type(_lockUid) == "string" and _lockUid ~= "") then
            local _c2 = LP.Character
            local _h2 = _c2 and _c2:FindFirstChild("HumanoidRootPart")
            if _h2 and (now - _inRangeLast) >= (tonumber(_G.TekInRangeGap) or 0.15) then
                _inRangeLast = now
                local _pets2 = _scanCached(now, 0.15)
                if _pets2 ~= nil and type(_pets2) == "table" then
                    local _near, _nd = nil, math.huge
                    local _mp = _h2.Position
                    for _, p in ipairs(_pets2) do
                        if not p.conveyor and p.position then
                            local d = (p.position - _mp).Magnitude
                            if d < _nd then _nd, _near = d, p end
                        end
                    end
                    if _near then
                        local _nu = _petUid(_near)
                        if _nu ~= _G.TekLastNearUid then
                            _G.TekLastNearUid = _nu
                            
                        end
                        _stealTarget = _near
                        _armedPet, _armLostSince = nil, 0
                        _lastTargetPick = now
                        if type(_near.name) == "string" then _currentTargetName = _near.name end
                    end
                end
            end
        end
        local pet = _stealTarget
        if not pet then  return end

        -- Do not call _swapStolenTarget here. A stolen/carried target stays
        -- locked so Auto Grab can catch that same brainrot when it is dropped.

        if now - _stealLastScan < 0.02 then _G.TekThrN = (_G.TekThrN or 0) + 1 return end
        _stealLastScan = now
        local t = timeUntilCanSteal()
        if t == -1 then
            if LP:GetAttribute("Stealing") then _stealTarget = nil; _armedPet, _armLostSince = nil, 0 end
            
            return
        end
        -- Start the hold even during a long ragdoll. executeStealAsync keeps it
        -- primed and delays the trigger until ragdoll has actually ended.
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then  return end

        if pet.position then
            local toPet = pet.position - hrp.Position
            local dist = toPet.Magnitude
            if (now - (_G.__tekTgtAt or 0)) >= 0.15 then
                _G.__tekTgtAt = now
                _G.TekStealTgt = tostring(pet.name) .. " [" .. tostring(pet.plot) .. "/" .. tostring(pet.slot) .. "] d=" .. math.floor(dist)
            end
            local hold = _holdDur()

            local lead = tonumber(_G.TekStealLead) or 0.6

            local closing = dist > 0.001 and (hrp.AssemblyLinearVelocity:Dot(toPet) / dist) or 0

            local _nearBase = false
            do
                local _bi = getClosestBaseIdx(pet.position)
                local _b = _bi and BASES_LOW[_bi]
                if _b then
                    local _bx, _bz = hrp.Position.X - _b.X, hrp.Position.Z - _b.Z
                    if math.sqrt(_bx * _bx + _bz * _bz) <= (tonumber(_G.TekCloseBaseRange) or 100) then
                        _nearBase = true
                    end
                end
            end

            local _armed = _G.TekStealQuick ~= true
            local _mul = _armed and 1.5 or 1
            if _nearBase then
                if dist > (tonumber(_G.TekNearBaseStealStart) or 80) * _mul then  return end
            elseif closing > (tonumber(_G.TekFastApproach) or 150) then

                if dist > (tonumber(_G.TekStealLeadMax) or 420) * _mul then  return end
                if (dist / closing) > hold * lead + (tonumber(_G.TekStealEarly) or 0.35) * _mul then  return end
            elseif closing > 5 then

                if dist > (tonumber(_G.TekCloseProximity) or 40) * _mul then  return end
            else

                if dist > _prox() * _mul then  return end
            end
        end
        _fireSteal(pet)
    end
    local _stealThrottle = 0
    RunService.Heartbeat:Connect(function()
        _stealThrottle = _stealThrottle + 1
        if _stealThrottle < 2 then return end
        _stealThrottle = 0
        pcall(_stealTick)
    end)

    task.spawn(function()
        while true do
            task.wait(tonumber(_G.TekWatchdogTick) or 0.15)
            if not _G.TekSourceStealActive and not _G.TekLaserGrabSession and _G.TekStealMode ~= nil and _G.TekStealWatchdog ~= false
                and not LP:GetAttribute("Stealing")
                and not _holdBusy()
                and (os.clock() - (_G.TekLastFire or 0)) > (tonumber(_G.TekWatchdogGap) or 1.0) then
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if h then
                    local pets = _scanCached(os.clock(), 0.15)
                    local ok = pets ~= nil
                    if ok and type(pets) == "table" then
                        local near, nd = nil, math.huge
                        local mp = h.Position
                        local want = _armedPet or _stealTarget
                        local wuid = want and _petUid(want)
                        if wuid then
                            for _, p in ipairs(pets) do
                                if not p.conveyor and p.position and _petUid(p) == wuid then
                                    near, nd = p, (p.position - mp).Magnitude
                                    break
                                end
                            end
                        end
                        if near and nd <= _prox() then
                            
                            pcall(_fireSteal, near)
                        end
                    end
                end
            end
        end
    end)

    do
        local function applyUnwalkAlways(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end
            if animator then
                local ok, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
                if ok and tracks then for _, t in ipairs(tracks) do pcall(function() t:Stop(0) end) end end
            end
        end
        local function hook(char)
            task.spawn(function()
                char:WaitForChild("Humanoid", 10); task.wait(0.05)
                for i = 1, 8 do
                    if LP.Character ~= char then break end
                    applyUnwalkAlways(char); task.wait(0.25)
                end
            end)
        end
        if LP.Character then hook(LP.Character) end
        LP.CharacterAdded:Connect(hook)
        local _unwalkLast = 0
        RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now - _unwalkLast < 1.5 then return end
            if _tekAnimRestoreAt and now < _tekAnimRestoreAt then return end
            _unwalkLast = now
            if LP.Character then applyUnwalkAlways(LP.Character) end
        end)
    end

    local HS = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local CFG_FILE = "SideTP.json"

    local function loadCfgTable()
        local t = {}
        if readfile then
            pcall(function()
                local raw = readfile(CFG_FILE)
                if type(raw) == "string" and #raw > 0 then
                    local ok, d = pcall(HS.JSONDecode, HS, raw)
                    if ok and type(d) == "table" then t = d end
                end
            end)
        end
        return t
    end

    local function saveTpSettings()
        if not writefile then return end
        local t = loadCfgTable()
        t.dragHead = nil
        t.wiggle = nil
        t.tpVelocity = tonumber(_G.TPVelocity) or 400
        t.climbSpeed = tonumber(_G.TekClimb) or 160
        t.goSpeed = tonumber(_G.TekGoSpeed) or 200
        t.cframeSpeed = tonumber(_G.TekCFrameSpeed) or 450
        t.cframeTP = _G.TekCFrameTP == true
        t.tweenTP = _G.TekTweenTP == true
        t.flingTp = _G.TekFlingTP == true
        t.tweenNear = tonumber(_G.TekTweenNear) or 40
        t.tweenStage = tonumber(_G.TekTweenStage) or 14
        t.flashTP = _G.TekFlashTP == true
        t.flashFire = tonumber(_G.TekFlashGroundWait) or 0.12
        t.flashEquip = tonumber(_G.TekFlashPreEquip) or 50
        t.cframeStart = tonumber(_G.TekCFrameStart) or 30
        t.cframeEnd = tonumber(_G.TekCFrameEnd) or 30
        t.walkSpeed = tonumber(_G.TekWalkSpeed) or 27
        t.landingDelay = tonumber(_G.LandingDelay) or 0.35
        t.closeSpeed = tonumber(_G.TekCloseSpeed) or 80
        t.preCloneSpeed = tonumber(_G.TekPreCloneSpeed) or 120
        t.problemBaseSpeed = tonumber(_G.TekProblemBaseSpeed) or 60
        t.slowCrossRow = _G.TekSlowCrossRow == true
        t.autoTp = _G.TekAutoTP ~= false
        t.autoKickOnSteal = _G.TekAutoKickOnSteal == true
        t.kickToPS = _G.TekKickToPS == true
        t.psLink = tostring(_G.TekPrivateServerLink or "")
        t.priAlert = _G.TekPriAlert == true
        t.alertSound = tostring(_G.TekAlertSound or "111786441593851")
        t.alertMinGen = tonumber(_G.TekAlertMinGen) or 80e6
        t.walkSpeedOn = _G.TekWalkSpeedOn ~= false
        t.xray = _G.TekXray ~= false
        t.invisAuto = _G.TekInvisAuto == true
        t.invisDepth = math.clamp(tonumber(_G.SinkSliderValue) or tonumber(_G.TekInvisDepth) or 2.5, 0.5, 10)
        t.invisAngle = tonumber(_G.InvisStealAngle) or tonumber(_G.TekInvisAngle) or 233
        t.autoSteal = stealOn
        t.stealMode = _G.TekStealMode
        t.stealLead = tonumber(_G.TekStealLead) or 0.6
        t.autoGrabRadius = tonumber(_G.TekAutoGrabRadius) or 95
        t.stealFireKey = type(_G.TekStealFireKey) == "string" and _G.TekStealFireKey or nil
        t.priorityList = _G.SHARED_PRIORITY_ITEMS
        t.mutationList = _G.SHARED_MUTATION_PRIORITY
        do
            local d = {}
            for name, on in pairs(_G.SHARED_MUTATION_DISABLED) do
                if on then d[#d + 1] = name end
            end
            t.mutationDisabled = d
        end
        t.traitList = _G.SHARED_TRAIT_PRIORITY
        t.panelX = tonumber(_G._stp_panelX)
        t.panelY = tonumber(_G._stp_panelY)
        t.panelPos = _G._stp_pos
        
        if type(_G.TekCloneKeyName)  == "string" then t.cloneKey  = _G.TekCloneKeyName  else t.cloneKey  = nil end
        if type(_G.TekKickKeyName)   == "string" then t.kickKey   = _G.TekKickKeyName   else t.kickKey   = nil end
        if type(_G.TekStopTPKeyName) == "string" then t.stopTpKey = _G.TekStopTPKeyName else t.stopTpKey = nil end
        if type(_G.TekNearestKey)    == "string" then t.nearestKey= _G.TekNearestKey    else t.nearestKey= nil end
        if type(_G.TekDropKeyName)   == "string" then t.dropKey   = _G.TekDropKeyName   else t.dropKey   = nil end
        if type(_G.TekResetKeyName)  == "string" then t.resetKey  = _G.TekResetKeyName  else t.resetKey  = nil end
        if type(_G.TekCarpetSpeedKeyName) == "string" then t.carpetSpeedKey = _G.TekCarpetSpeedKeyName else t.carpetSpeedKey = nil end
        if type(_G.TekStealQuickKey) == "string" then t.stealQuickKey = _G.TekStealQuickKey else t.stealQuickKey = nil end
        t.antiFlash = _G.TekAntiFlash ~= false
        t.faceAway = _G.TekFaceAway == true
        t.faceAwayNearest = _G.TekFaceAwayNearest == true
        t.faceAwayDelay = tonumber(_G.TekFaceAwayDelay) or 2
        t.antiBee   = _G.TekAntiBee ~= false
        t.infJump   = _G.TekInfJump ~= false
        t.antiDie   = _G.AntiDieDisabled ~= true
        t.carpetSpeedValue = tonumber(_G.TekCarpetSpeedValue) or 140

        if type(_G.TekCarpetTool) == "string" then t.carpetTool = _G.TekCarpetTool else t.carpetTool = nil end
        t.autoBuy = _G.TekAutoBuy == true
        t.autoBuyRange = tonumber(_G.TekAutoBuyRange) or 17
        t.autoBuyHover = tonumber(_G.TekAutoBuyHover) or 9
        t.exX = tonumber(_G._tek_exX); t.exY = tonumber(_G._tek_exY)
        t.fX  = tonumber(_G._tek_fX);  t.fY  = tonumber(_G._tek_fY)
        t.kX  = tonumber(_G._tek_kX);  t.kY  = tonumber(_G._tek_kY)
        t.tgtX = tonumber(_G._tek_tgtX); t.tgtY = tonumber(_G._tek_tgtY)
        t.modeX = tonumber(_G._tek_modeX); t.modeY = tonumber(_G._tek_modeY)
        t.tgtW = tonumber(_G._tek_tgtW); t.tgtH = tonumber(_G._tek_tgtH)
        t.modeW = tonumber(_G._tek_modeW); t.modeH = tonumber(_G._tek_modeH)
        pcall(function() writefile(CFG_FILE, HS:JSONEncode(t)) end)
    end
    _G.TekSaveSettings = saveTpSettings  

    if _G.TPVelocity == nil then _G.TPVelocity = 400 end
    if _G.TekClimb == nil then _G.TekClimb = 160 end
    if _G.TekGoSpeed == nil then _G.TekGoSpeed = 200 end
    if _G.TekCFrameSpeed == nil then _G.TekCFrameSpeed = 450 end
    if _G.TekWalkSpeed == nil then _G.TekWalkSpeed = 24 end
    if _G.LandingDelay == nil then _G.LandingDelay = 0.35 end
    if _G.TekCloseSpeed == nil then _G.TekCloseSpeed = 80 end
    if _G.TekPreCloneSpeed == nil then _G.TekPreCloneSpeed = 120 end
    if _G.TekCFrameTP == nil then _G.TekCFrameTP = false end
    if _G.TekCFrameStart == nil then _G.TekCFrameStart = 30 end
    if _G.TekCFrameEnd == nil then _G.TekCFrameEnd = 30 end
    if _G.TekProblemBaseSpeed == nil then _G.TekProblemBaseSpeed = 60 end
    if _G.TekSlowCrossRow == nil then _G.TekSlowCrossRow = false end
    if _G.TekInvisDepth == nil then _G.TekInvisDepth = tonumber(_G.SinkSliderValue) or 2.5 end
    if _G.TekInvisAngle == nil then _G.TekInvisAngle = tonumber(_G.InvisStealAngle) or 233 end
    if _G.TekAutoGrabRadius == nil then _G.TekAutoGrabRadius = 95 end

    do
        local _gp = (gethui and gethui()) or game:GetService("CoreGui")
        for _, par in ipairs({ _gp, PG }) do
            pcall(function()
                local old = par and par:FindFirstChild("TekTP")
                if old then old:Destroy() end
                local legacyPanel = par and par:FindFirstChild("ElysiumTP")
                if legacyPanel then legacyPanel:Destroy() end
                local oldBar = par and par:FindFirstChild("TekTopBar")
                if oldBar then oldBar:Destroy() end
                local legacyBar = par and par:FindFirstChild("ElysiumTopBar")
                if legacyBar then legacyBar:Destroy() end
            end)
        end
    end

    if false then -- TekTP panel removed (settings now live in Mode GUI)

    local TS = game:GetService("TweenService")
    local EASE = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tween(o, props) TS:Create(o, EASE, props):Play() end

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
    for _, par in ipairs({ guiParent, PG }) do
        pcall(function()
            local old = par:FindFirstChild("TekTP")
            if old then old:Destroy() end
            local oldBar = par:FindFirstChild("TekTopBar")
            if oldBar then oldBar:Destroy() end
        end)
    end

    local sg = mk("ScreenGui", nil, {
        Name = "TekTP", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then pcall(function() sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) end
    if type(registerScreenGui) == "function" then pcall(registerScreenGui, sg) end
    do
        local us = sg:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
        us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = sg
    end

    sg.Enabled = false

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            sg.Enabled = not sg.Enabled
        end
    end)

    do
        pcall(function()
            local oldBar = guiParent:FindFirstChild("TekTopBar")
            if oldBar then oldBar:Destroy() end
        end)
        pcall(function()
            local oldBar2 = PG:FindFirstChild("TekTopBar")
            if oldBar2 then oldBar2:Destroy() end
        end)
    end

    local W, H, RAIL, PAD = 460, 320, 130, 16

    local root = mk("Frame", sg, {
        Name = "Root", Active = true, BackgroundTransparency = 1,
        Size = UDim2.fromOffset(W, H),
        Position = UDim2.fromOffset(tonumber(_G._stp_panelX) or 40, tonumber(_G._stp_panelY) or 160),
    })

    local card = corner(mk("Frame", root, {
        BackgroundColor3 = UIC.bg, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1,
    }), 10)
    mk("UIGradient", card, {
        Rotation = 135,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, UIC.bg2), ColorSequenceKeypoint.new(1, UIC.bg)}),
    })
    mk("UIStroke", card, { Thickness = 1, Transparency = 0.4, Color = UIC.line })

    local rail = mk("Frame", card, {
        Size = UDim2.new(0, RAIL, 1, 0), BackgroundTransparency = 1, ZIndex = 2,
    })
    mk("TextLabel", rail, {
        Size = UDim2.new(1, -PAD * 2, 0, 20), Position = UDim2.fromOffset(PAD, 28),
        BackgroundTransparency = 1, Text = "TEK TP", Font = UIFB, TextSize = 15,
        TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })

    local body = mk("Frame", card, {
        Position = UDim2.fromOffset(RAIL, 0), Size = UDim2.new(1, -RAIL, 1, 0),
        BackgroundTransparency = 1, ZIndex = 2,
    })

    local pages, tabs = {}, {}
    local tabOpenHook = {}
    local function selectTab(name)
        local _h = tabOpenHook[name]
        if _h then tabOpenHook[name] = nil; pcall(_h) end
        for n, p in pairs(pages) do p.Visible = (n == name) end
        for n, t in pairs(tabs) do
            local on = (n == name)
            tween(t.bg, { BackgroundTransparency = on and 0 or 1 })
            tween(t.lbl, { TextColor3 = on and UIC.txt or UIC.dim })
            tween(t.btn, { BackgroundTransparency = on and 0.2 or 0.5 })
        end
    end

    local function tab(name, order)
        local b = corner(mk("TextButton", rail, {
            Size = UDim2.new(1, -PAD * 2, 0, 32), Position = UDim2.fromOffset(PAD, 72 + (order - 1) * 38),
            BackgroundColor3 = UIC.card, BackgroundTransparency = 0.5, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 2,
        }), 6)
        local bg = mk("Frame", b, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(bg, 6)
        local lbl = mk("TextLabel", b, {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1, Text = name, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        mk("UIPadding", lbl, { PaddingLeft = UDim.new(0, 12) })
        local page = mk("ScrollingFrame", body, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            Visible = false, ScrollBarThickness = 0, ScrollBarImageColor3 = UIC.line,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2,
        })
        mk("UIPadding", page, {
            PaddingLeft = UDim.new(0, PAD), PaddingRight = UDim.new(0, PAD + 4),
            PaddingTop = UDim.new(0, PAD + 4), PaddingBottom = UDim.new(0, PAD),
        })
        mk("UIListLayout", page, { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        tabs[name], pages[name] = { btn = b, bg = bg, lbl = lbl }, page
        b.MouseButton1Click:Connect(function() selectTab(name) end)
        b.MouseEnter:Connect(function()
            if not pages[name].Visible then
                tween(b, { BackgroundTransparency = 0.3 })
            end
        end)
        b.MouseLeave:Connect(function()
            if not pages[name].Visible then
                tween(b, { BackgroundTransparency = 0.5 })
            end
        end)
        return page
    end

    local function label(parent, txt, first)
        local l = mk("TextLabel", parent, {
            Size = UDim2.new(1, 0, 0, first and 14 or 26), BackgroundTransparency = 1,
            Text = string.upper(txt), Font = UIFB, TextSize = 10, TextColor3 = UIC.dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom, ZIndex = 2,
        })
        return l
    end

    local function shell(parent, h)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = UIC.card,
            BorderSizePixel = 0, Active = true, ZIndex = 2,
        }), 6)
        local bg = mk("Frame", card, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(bg, 6)
        return card
    end

    local function action(parent, txt, fn)
        local card2 = shell(parent, 36)
        local b = mk("TextButton", card2, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = txt,
            Font = UIFB, TextSize = 12, TextColor3 = UIC.txt,
            Active = true, AutoButtonColor = false, ZIndex = 3,
        })
        b.MouseEnter:Connect(function() 
            tween(card2:FindFirstChildOfClass("Frame"), { BackgroundTransparency = 0.3 })
        end)
        b.MouseLeave:Connect(function() 
            tween(card2:FindFirstChildOfClass("Frame"), { BackgroundTransparency = 1 })
        end)
        b.MouseButton1Click:Connect(fn)
    end

    local function toggle(parent, txt, get, fn)
        local card2 = shell(parent, 36)
        local hit = mk("TextButton", card2, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            Active = true, AutoButtonColor = false, ZIndex = 4,
        })
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(14, 0),
            BackgroundTransparency = 1, Text = txt, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local pill = corner(mk("Frame", card2, {
            Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0, ZIndex = 3,
        }), 10)
        local knob = corner(mk("Frame", pill, {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = UIC.dim, BorderSizePixel = 0, ZIndex = 4,
        }), 8)
        local function paint(instant)
            local v = get()
            local pc = v and UIC.acc or UIC.track
            local kc = v and UIC.txt or UIC.dim
            local kp = UDim2.fromOffset(v and 22 or 2, 2)
            if instant then
                pill.BackgroundColor3, knob.BackgroundColor3, knob.Position = pc, kc, kp
            else
                tween(pill, { BackgroundColor3 = pc })
                tween(knob, { BackgroundColor3 = kc, Position = kp })
            end
        end
        hit.MouseButton1Click:Connect(function() fn(); paint() end)
        paint(true)
        return paint
    end

    local function input(parent, txt, hint, get, set)
        local card2 = shell(parent, 52)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local box = mk("TextBox", card2, {
            Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(14, 24),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = hint, PlaceholderColor3 = UIC.line,
            ClearTextOnFocus = false, Text = tostring(get() or ""),
            TextTruncate = Enum.TextTruncate.AtEnd, Active = true, ZIndex = 4,
        })
        box.FocusLost:Connect(function() set(box.Text) end)
        return box
    end



    local function dropdown(parent, txt, options, get, set)
        local HEAD, ROW = 40, 26
        local card2 = shell(parent, HEAD)
        card2.ClipsDescendants = true
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(14, 6),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local cur = mk("TextLabel", card2, {
            Size = UDim2.new(1, -44, 0, 14), Position = UDim2.fromOffset(14, 20),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 3,
        })
        local arrow = mk("TextLabel", card2, {
            Size = UDim2.fromOffset(20, 14), Position = UDim2.new(1, -32, 0, 20),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.acc, TextXAlignment = Enum.TextXAlignment.Right,
            Text = "v", ZIndex = 3,
        })
        local hit = mk("TextButton", card2, {
            Size = UDim2.new(1, 0, 0, HEAD), BackgroundTransparency = 1, Text = "",
            Active = true, AutoButtonColor = false, ZIndex = 4,
        })
        local list = mk("Frame", card2, {
            Position = UDim2.fromOffset(0, HEAD), Size = UDim2.new(1, 0, 0, #options * ROW),
            BackgroundTransparency = 1, Visible = false, ZIndex = 3,
        })
        mk("UIListLayout", list, { SortOrder = Enum.SortOrder.LayoutOrder })
        local open, rows = false, {}
        local function paint()
            local v = get()
            cur.Text = (type(v) == "string" and v ~= "") and v or tostring(options[1])
            for _, r in ipairs(rows) do
                local on = (r.name == cur.Text)
                r.lbl.TextColor3 = on and UIC.acc or UIC.dim
                r.bg.BackgroundTransparency = on and 0.85 or 1
            end
        end
        local function setOpen(v)
            open = v
            list.Visible = v
            arrow.Text = v and "^" or "v"
            tween(card2, {
                Size = UDim2.new(1, 0, 0, v and (HEAD + #options * ROW + 6) or HEAD),
            })
        end
        for i, name in ipairs(options) do
            local rb = mk("TextButton", list, {
                Size = UDim2.new(1, 0, 0, ROW), BackgroundColor3 = UIC.acc,
                BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
                AutoButtonColor = false, Active = true, LayoutOrder = i, ZIndex = 4,
            })
            local rl = mk("TextLabel", rb, {
                Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(22, 0),
                BackgroundTransparency = 1, Text = name, Font = UIFB, TextSize = 11,
                TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
            })
            rows[#rows + 1] = { name = name, lbl = rl, bg = rb }
            rb.MouseButton1Click:Connect(function()
                set(name)
                paint()
                setOpen(false)
            end)
        end
        hit.MouseButton1Click:Connect(function() setOpen(not open) end)
        paint()
        return paint
    end

    local function slider(parent, txt, min, max, get, set, step)
        step = step or 1
        local card2 = shell(parent, 50)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -76, 0, 14), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local val = mk("TextLabel", card2, {
            Size = UDim2.fromOffset(52, 14), Position = UDim2.new(1, -64, 0, 8),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3,
        })
        local track = corner(mk("TextButton", card2, {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(14, 32),
            BackgroundColor3 = UIC.track, Text = "", AutoButtonColor = false,
            Active = true, BorderSizePixel = 0, ZIndex = 3,
        }), 3)
        local fill = corner(mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = UIC.acc,
            BorderSizePixel = 0, ZIndex = 4,
        }), 3)
        local knob = corner(mk("Frame", track, {
            Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = UIC.txt,
            BorderSizePixel = 0, ZIndex = 5,
        }), 7)

        local function refresh()
            local v = math.clamp(tonumber(get()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            val.Text = step < 1 and string.format("%.2f", v) or tostring(math.floor(v + 0.5))
        end
        local function applyAt(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            set(math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max))
            refresh()
        end

        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                sliding = true; tween(knob, { Size = UDim2.fromOffset(14, 14) }); applyAt(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then applyAt(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch) then
                sliding = false; tween(knob, { Size = UDim2.fromOffset(10, 10) }); saveTpSettings()
            end
        end)
        refresh()
    end

    do
        local dragging, dragStart, startPos, dragInput
        card.Active = true
        rail.Active, body.Active = true, true

        local function begin(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, dragStart, startPos = true, i.Position, root.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    _G._stp_panelX = root.Position.X.Offset
                    _G._stp_panelY = root.Position.Y.Offset
                    saveTpSettings()
                end
            end)
        end
        local function track(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
        end
        for _, o in ipairs({ card, rail, body }) do
            o.InputBegan:Connect(begin)
            o.InputChanged:Connect(track)
        end
        UIS.InputChanged:Connect(function(i)
            if not dragging or i ~= dragInput then return end
            local d = i.Position - dragStart
            root.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end)
    end

    local home = tab("Home", 1)
    local tune = tab("Tuning", 2)

    label(home, "actions", true)
    action(home, "MANUAL TP", function()
        task.spawn(function()
            if diag() == 0 then return end
            if _G.TekStartSideTP then pcall(_G.TekStartSideTP)
            else pcall(doVelocityTP, true) end
        end)
    end)

    label(home, "general")
    _G.TekRepaintAutoTP = toggle(home, "AUTO TP",
        function() return _G.TekAutoTP ~= false end,
        function() _G.TekAutoTP = not (_G.TekAutoTP ~= false); saveTpSettings() end)


    label(home, "flying tool")
    dropdown(home, "TOOL USED FOR FLYING", FLY_TOOLS,
        function() return _G.TekCarpetTool end,
        function(n) setCarpetTool(n); saveTpSettings() end)

    label(tune, "movement", true)
    for _, s in ipairs({
        { "TP Velocity",          200,  750, "TPVelocity",        5    },
        { "Rise Speed",           100,  250, "TekClimb",       5    },
        { "Go To Brainrot Speed",  80,  600, "TekGoSpeed",     5    },
        { "Landing Delay",       0.01, 1.0,  "LandingDelay",      0.01 },
        { "100 Studs Base Speed",  20,  400, "TekCloseSpeed",  5    },
        { "Cross-Row Front Speed", 20,  400, "TekProblemBaseSpeed", 5 },
    }) do
        slider(tune, s[1], s[2], s[3],
            function() return _G[s[4]] end, function(v) _G[s[4]] = v end, s[5])
    end

    label(tune, "cross-row front approach")
    toggle(tune, "SLOW BEHIND CROSS-ROW (FIRST FLOOR)",
        function() return _G.TekSlowCrossRow == true end,
        function() _G.TekSlowCrossRow = not (_G.TekSlowCrossRow == true); saveTpSettings() end)

    local pri = tab("Priority", 3)
    local refreshPri, currentPriTab = nil, "brainrot"

    local function mkSubTabs(parent)
        local tabsFrame = mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1,
        })
        local names = {"Brainrots", "Mutations", "Traits"}
        local w = 1 / #names
        for i, n in ipairs(names) do
            local b = corner(mk("TextButton", tabsFrame, {
                Size = UDim2.new(w, -4, 1, 0), Position = UDim2.new(w * (i - 1), 2, 0, 0),
                BackgroundColor3 = UIC.acc, Text = n, Font = UIFB, TextSize = 11,
                TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 3,
            }), 6)
            b.MouseButton1Click:Connect(function()
                currentPriTab = n:lower():gsub("s$", "")
                for _, c in ipairs(tabsFrame:GetChildren()) do
                    if c:IsA("TextButton") then
                        c.BackgroundColor3 = (c == b) and UIC.acc or UIC.track
                        c.TextColor3 = (c == b) and UIC.bg or UIC.txt
                    end
                end
                if refreshPri then refreshPri() end
            end)
            if i == 1 then
                b.BackgroundColor3, b.TextColor3 = UIC.acc, UIC.bg
            else
                b.BackgroundColor3, b.TextColor3 = UIC.track, UIC.txt
            end
        end
    end
    mkSubTabs(pri)

    local addBox
    do
        local card2 = shell(pri, 36)
        stroke(card2)
        addBox = mk("TextBox", card2, {
            Size = UDim2.new(1, -74, 0, 24), Position = UDim2.fromOffset(10, 6),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0,
            Font = UIF, TextSize = 12, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "type a name, then Enter", PlaceholderColor3 = UIC.dim,
            ClearTextOnFocus = false, Text = "", Active = true, ZIndex = 4,
        })
        corner(addBox, 6)
        mk("UIPadding", addBox, { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
        local addBtn = corner(mk("TextButton", card2, {
            Size = UDim2.fromOffset(52, 24), Position = UDim2.new(1, -60, 0, 6),
            BackgroundColor3 = UIC.acc, Text = "ADD", Font = UIFB, TextSize = 11,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 4,
        }), 6)
        local function doAdd()
            local name = (addBox.Text or ""):match("^%s*(.-)%s*$")
            if name and name ~= "" then
                if currentPriTab == "brainrot" then
                    table.insert(_G.SHARED_PRIORITY_ITEMS, name)
                elseif currentPriTab == "mutation" then
                    table.insert(_G.SHARED_MUTATION_PRIORITY, name)
                else
                    table.insert(_G.SHARED_TRAIT_PRIORITY, name)
                end
                _G.TekPriVersion = (_G.TekPriVersion or 0) + 1
                pcall(saveTpSettings)
                addBox.Text = ""
                if refreshPri then refreshPri() end
            end
        end
        addBtn.MouseButton1Click:Connect(doAdd)
        addBtn.MouseEnter:Connect(function() tween(addBtn, { BackgroundColor3 = UIC.txt }) end)
        addBtn.MouseLeave:Connect(function() tween(addBtn, { BackgroundColor3 = UIC.acc }) end)
        addBox.FocusLost:Connect(function(enter) if enter then doAdd() end end)
    end

    label(pri, "priority  -  top = highest")
    local rowsHost = mk("Frame", pri, {
        Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2,
    })
    mk("UIListLayout", rowsHost, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

    local function getListAndIcon()
        if currentPriTab == "brainrot" then
            return _G.SHARED_PRIORITY_ITEMS, nil
        elseif currentPriTab == "mutation" then
            return _G.SHARED_MUTATION_PRIORITY, MUTATION_ICONS
        else
            return _G.SHARED_TRAIT_PRIORITY, TRAIT_ICONS
        end
    end

    refreshPri = function()
        for _, c in ipairs(rowsHost:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        local L, icons = getListAndIcon()
        for i = 1, #L do
            local nm = tostring(L[i])
            local row = corner(mk("Frame", rowsHost, {
                Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = UIC.card,
                BorderSizePixel = 0, LayoutOrder = i, ZIndex = 2,
            }), 6)
            stroke(row)
            local iconId = _iconForName(icons, nm)
            local textOff = 12
            if iconId and type(iconId) == "string" then
                local icon = mk("ImageLabel", row, {
                    Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(10, 4),
                    BackgroundTransparency = 1, Image = tostring(iconId),
                    ZIndex = 3,
                })
                textOff = 40
            end
            mk("TextLabel", row, {
                Size = UDim2.new(1, (currentPriTab == "mutation") and -148 or -104, 1, 0),
                Position = UDim2.fromOffset(textOff, 0),
                BackgroundTransparency = 1, Text = i .. ".  " .. ((currentPriTab == "mutation") and _mutationDisplayName(nm) or nm),
                Font = UIF, TextSize = 12, TextColor3 = UIC.txt,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
            })
            local function commit()
                _G.TekPriVersion = (_G.TekPriVersion or 0) + 1
                pcall(saveTpSettings)
                refreshPri()
            end
            local function mini(xoff, sym, act)
                local b = corner(mk("TextButton", row, {
                    Size = UDim2.fromOffset(26, 22), Position = UDim2.new(1, xoff, 0.5, -11),
                    BackgroundColor3 = UIC.track, Text = sym, Font = UIFB, TextSize = 12,
                    TextColor3 = UIC.txt, AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 6)
                b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = UIC.line }) end)
                b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = UIC.track }) end)
                b.MouseButton1Click:Connect(act)
                return b
            end
            mini(-98, "\u{25B2}", function() if i > 1 then L[i], L[i - 1] = L[i - 1], L[i]; commit() end end)
            mini(-68, "\u{25BC}", function() if i < #L then L[i], L[i + 1] = L[i + 1], L[i]; commit() end end)
            mini(-36, "X", function() table.remove(L, i); commit() end)
            if currentPriTab == "mutation" then
                local D = _G.SHARED_MUTATION_DISABLED
                local off = D[nm] == true
                local tg = corner(mk("TextButton", row, {
                    Size = UDim2.fromOffset(34, 22), Position = UDim2.new(1, -136, 0.5, -11),
                    BackgroundColor3 = off and UIC.track or UIC.acc,
                    Text = off and "OFF" or "ON", Font = UIFB, TextSize = 10,
                    TextColor3 = off and UIC.dim or UIC.bg,
                    AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 6)
                tg.MouseButton1Click:Connect(function()
                    if D[nm] then D[nm] = nil else D[nm] = true end
                    commit()
                end)
                if off then
                    for _, c in ipairs(row:GetChildren()) do
                        if c:IsA("TextLabel") then c.TextColor3 = UIC.dim end
                        if c:IsA("ImageLabel") then c.ImageTransparency = 0.6 end
                    end
                end
            end
        end
    end
    tabOpenHook["Priority"] = function() if refreshPri then refreshPri() end end

    local cfg = tab("Config", 4)
    label(cfg, "config", true)
    do
        local exportBtn = corner(mk("TextButton", cfg, {
            Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = UIC.acc,
            Text = "EXPORT TO CLIPBOARD", Font = UIFB, TextSize = 12,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 3,
        }), 8)
        exportBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local raw = readfile and readfile("SideTP.json")
                if type(raw) == "string" and #raw > 0 then
                    if type(setclipboard) == "function" then setclipboard(raw) end
                    
                else
                    
                end
            end)
        end)
        exportBtn.MouseEnter:Connect(function() tween(exportBtn, { BackgroundColor3 = UIC.txt }) end)
        exportBtn.MouseLeave:Connect(function() tween(exportBtn, { BackgroundColor3 = UIC.acc }) end)
    end
    do
        local card = shell(cfg, 104)
        stroke(card)
        local importBox = mk("TextBox", card, {
            Size = UDim2.new(1, -10, 0, 56), Position = UDim2.fromOffset(5, 5),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0,
            Font = UIF, TextSize = 10, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            PlaceholderText = "paste exported JSON here", PlaceholderColor3 = UIC.dim,
            ClearTextOnFocus = false, Text = "", MultiLine = true, Active = true, ZIndex = 4,
        })
        corner(importBox, 6)
        mk("UIPadding", importBox, { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) })
        local importBtn = corner(mk("TextButton", card, {
            Size = UDim2.new(1, -10, 0, 30), Position = UDim2.fromOffset(5, 68),
            BackgroundColor3 = UIC.acc, Text = "IMPORT AND SAVE", Font = UIFB, TextSize = 12,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 4,
        }), 6)
        importBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local HS = game:GetService("HttpService")
                local raw = importBox.Text or ""
                local ok, t = pcall(HS.JSONDecode, HS, raw)
                if not (ok and type(t) == "table" and type(t.priorityList) == "table") then
                    
                    return
                end
                if writefile then writefile("SideTP.json", raw) end
                
                importBox.Text = ""
            end)
        end)
        importBtn.MouseEnter:Connect(function() tween(importBtn, { BackgroundColor3 = UIC.txt }) end)
        importBtn.MouseLeave:Connect(function() tween(importBtn, { BackgroundColor3 = UIC.acc }) end)
    end
    do
        local resetBtn = corner(mk("TextButton", cfg, {
            Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = UIC.line,
            Text = "RESET TO DEFAULT", Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, AutoButtonColor = false, Active = true, ZIndex = 3,
        }), 8)
        resetBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if writefile then writefile("SideTP.json", _G.TEK_DEFAULT_CONFIG_JSON) end
                
            end)
        end)
        resetBtn.MouseEnter:Connect(function() tween(resetBtn, { BackgroundColor3 = UIC.acc }) end)
        resetBtn.MouseLeave:Connect(function() tween(resetBtn, { BackgroundColor3 = UIC.line }) end)
    end

    selectTab("Home")
    _G.TekToggleTPSettings = function() sg.Enabled = not sg.Enabled end
    _G.TekTPGui = sg
    _G.TekShowTPSettings = function(tab)
        sg.Enabled = true
        if type(tab) == "string" and pages[tab] then selectTab(tab) end
    end
    task.delay(1.5, diag)
    end -- /TekTP panel removed (dead code above never runs)
end

do
    local RunService = game:GetService("RunService")
    local Lighting   = game:GetService("Lighting")
    local RS         = game:GetService("ReplicatedStorage")
    local LP         = game:GetService("Players").LocalPlayer

    local RAG_STATES = {
        [Enum.HumanoidStateType.Physics]     = true,
        [Enum.HumanoidStateType.Ragdoll]     = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.GettingUp]   = true,
    }

    local conns, char, hum, hrp, anim = {}, nil, nil, nil, nil

    local function invisActive()
        return _G.TekInvisActive == true or _G.invisibleStealEnabled == true
    end

    local function ragdolled()
        return hum ~= nil and RAG_STATES[hum:GetState()] == true
    end

    local function cleanup()
        if not char then return end
        pcall(function()
            for _, o in ipairs(char:GetDescendants()) do
                if o:IsA("AnimationConstraint") and not o.Enabled then
                    o.Enabled = true
                end
            end
        end)
        if anim then
            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                local n = t.Animation and t.Animation.Name:lower() or ""
                if n:find("rag") or n:find("fall") or n:find("hurt") or n:find("down") then t:Stop(0) end
            end
        end
    end

    local function recover()
        if _G.AntiDieDisabled == true or _G.Tek_IsResetting == true then return end
        if hum:GetState() == Enum.HumanoidStateType.Physics then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
        if hrp and hrp.Parent and not invisActive() then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        cleanup()
        if not invisActive() then
            pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
        end
        pcall(function()
            local _ps = LP:FindFirstChild("PlayerScripts") or LP:WaitForChild("PlayerScripts", 10)
            require(_ps:WaitForChild("PlayerModule", 10)):GetControls():Enable()
        end)
    end

    local function bind(c)
        for _, v in pairs(conns) do pcall(function() v:Disconnect() end) end
        conns = {}
        char = c
        hum  = c:WaitForChild("Humanoid", 10)
        hrp  = c:WaitForChild("HumanoidRootPart", 10)
        anim = hum and hum:WaitForChild("Animator", 10)
        if not hum then return end

        conns[#conns + 1] = hum.StateChanged:Connect(function()
            if ragdolled() and not invisActive() and _G.AntiDieDisabled ~= true
                and _G.Tek_IsResetting ~= true then recover() end
        end)
        conns[#conns + 1] = c.DescendantAdded:Connect(function()
            if ragdolled() and not invisActive() and _G.AntiDieDisabled ~= true
                and _G.Tek_IsResetting ~= true then cleanup() end
        end)
        local safetyAcc = 0
        conns[#conns + 1] = RunService.Heartbeat:Connect(function(dt)
            safetyAcc = safetyAcc + (dt or 0.016)
            if safetyAcc < 0.1 then return end
            safetyAcc = 0
            if not ragdolled() then return end
            if invisActive() then return end
            if _G.AntiDieDisabled == true or _G.Tek_IsResetting == true then return end
            recover()
        end)
    end

    LP.CharacterAdded:Connect(function(c) pcall(bind, c) end)
    if LP.Character then pcall(bind, LP.Character) end

    local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true }
    local function nuke(o) if o and o.Parent and BAD[o.Name] then pcall(function() o:Destroy() end) end end

    local buzz
    local function muteBuzz()
        pcall(function()
            if not (buzz and buzz.Parent) then
                local ctl = RS:FindFirstChild("Controllers")
                local item = ctl and ctl:FindFirstChild("ItemController")
                local bee = item and item:FindFirstChild("BeeLauncherController")
                local s = bee and bee:FindFirstChild("Buzzing")
                if s and s:IsA("Sound") then buzz = s end
            end
            if buzz then
                buzz.Volume = 0
                if buzz.IsPlaying then buzz:Stop() end
            end
        end)
    end

    task.spawn(function()
        LP:WaitForChild("PlayerScripts", 8)
        _G.TekBootWait()
        Lighting.DescendantAdded:Connect(nuke)
        do local n = 0
            for _, o in ipairs(Lighting:GetDescendants()) do
                n = n + 1; if n % 150 == 0 then task.wait() end
                nuke(o)
            end
        end
        muteBuzz()
        local acc = 0
        RunService.Heartbeat:Connect(function(dt)
            local cam = workspace.CurrentCamera
            if cam and math.abs(cam.FieldOfView - 20) < 0.01 then
                cam.FieldOfView = tonumber(_G.TekFOV) or 70
            end
            acc = acc + dt
            if acc >= 1.0 then acc = 0; muteBuzz() end
        end)
    end)
end

;(function()
    local C = {
        bg   = Color3.fromRGB(5, 7, 6),
        bg2  = Color3.fromRGB(12, 15, 13),
        row  = Color3.fromRGB(20, 22, 21),
        rowH = Color3.fromRGB(31, 35, 32),
        line = Color3.fromRGB(38, 44, 40),
        track = Color3.fromRGB(38, 40, 39),
        acc  = Color3.fromRGB(105, 235, 145),
        acc2 = Color3.fromRGB(165, 245, 190),
        txt  = Color3.fromRGB(248, 248, 248),
        dim  = Color3.fromRGB(155, 160, 157),
    }
    local FB, FR = Enum.Font.GothamBold, Enum.Font.GothamMedium
    local TS = game:GetService("TweenService")
    local EASE = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local function tw(o, p) TS:Create(o, EASE, p):Play() end

    local function mk(cls, parent, props)
        local o = Instance.new(cls)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function round(o, r) r = r or 8; mk("UICorner", o, { CornerRadius = UDim.new(0, r) }) return o end

    local host = (gethui and gethui()) or game:GetService("CoreGui")
    pcall(function()
        local old = host:FindFirstChild("TekTargets")
        if old then old:Destroy() end
    end)
    pcall(function()
        local legacy = host:FindFirstChild("ElysiumTargets")
        if legacy then legacy:Destroy() end
    end)

    local sg = mk("ScreenGui", nil, {
        Name = "TekTargets", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 999998,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = host end)
    if not sg.Parent then pcall(function() sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) end
    do
        local us = sg:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
        us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = sg
    end

    local root = round(mk("Frame", sg, {
        Name = "Root", Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
        BackgroundTransparency = 0.04,
        Size = UDim2.fromOffset(260, 320),
        Position = UDim2.fromOffset(tonumber(_G._tek_tgtX) or 24,
            tonumber(_G._tek_tgtY) or 250),
    }), 10)
    mk("UIGradient", root, {
        Rotation = 135,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.bg2), ColorSequenceKeypoint.new(1, C.bg)}),
    })
    mk("UIStroke", root, { Thickness = 1, Transparency = 0.4, Color = C.line })
    mk("TextLabel", root, {
        Position = UDim2.fromOffset(12, 8), Size = UDim2.new(1, -48, 0, 18),
        BackgroundTransparency = 1, Text = "STEAL TARGET", Font = FB, TextSize = 12,
        TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
    })
    local tgtHeadBtn = mk("TextButton", root, {
        Size = UDim2.new(1, 0, 0, 40), Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1, Text = "-", Font = FB, TextSize = 14,
        TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Right,
        AutoButtonColor = false, Active = true, ZIndex = 5,
    })
    mk("UIPadding", tgtHeadBtn, { PaddingRight = UDim.new(0, 14) })
    if _G._tek_tgtExpanded == nil then _G._tek_tgtExpanded = true end
    local list = mk("ScrollingFrame", root, {
        Position = UDim2.fromOffset(12, 44), Size = UDim2.new(1, -24, 1, -56),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    mk("UIListLayout", list, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    if type(_G._tek_tgtW) ~= "number" then _G._tek_tgtW = 260 end
    if type(_G._tek_tgtH) ~= "number" then _G._tek_tgtH = 320 end
    local tgtGrip = mk("TextButton", root, {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2),
        Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, Active = true, ZIndex = 10,
    })
    for _, o in ipairs({ -2, 3 }) do
        local ln = mk("Frame", tgtGrip, {
            Size = UDim2.new(0, 20, 0, 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, o),
            BackgroundColor3 = C.dim, BorderSizePixel = 0, ZIndex = 11,
        })
        ln.Rotation = 45
    end
    do
        local resizing, rStart, rW, rH = false, nil, 0, 0
        tgtGrip.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            resizing, rStart = true, i.Position
            rW, rH = root.Size.X.Offset, root.Size.Y.Offset
        end)
        UIS.InputChanged:Connect(function(i)
            if not resizing then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = i.Position - rStart
            _G._tek_tgtW = math.clamp(rW + d.X, 180, 600)
            _G._tek_tgtH = math.clamp(rH + d.Y, 120, 800)
            root.Size = UDim2.fromOffset(_G._tek_tgtW, _G._tek_tgtH)
        end)
        UIS.InputEnded:Connect(function(i)
            if resizing and (i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch) then
                resizing = false
                pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
            end
        end)
    end
    local headerWasDragged = false
    local function applyTgtExpanded()
        local open = _G._tek_tgtExpanded
        list.Visible = open
        local w = tonumber(_G._tek_tgtW) or 260
        local h = tonumber(_G._tek_tgtH) or 320
        root.Size = open and UDim2.fromOffset(w, h) or UDim2.fromOffset(w, 40)
        tgtHeadBtn.Text = open and "-" or "+"
        tw(tgtHeadBtn, { TextColor3 = open and C.dim or C.txt })
        tgtGrip.Visible = open
    end
    tgtHeadBtn.MouseButton1Click:Connect(function()
        if headerWasDragged then
            headerWasDragged = false
            return
        end
        _G._tek_tgtExpanded = not _G._tek_tgtExpanded
        applyTgtExpanded()
    end)
    applyTgtExpanded()

    do
        local on, from, base
        tgtHeadBtn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            on, from, base = true, i.Position, root.Position
            headerWasDragged = false
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    on = false
                    _G._tek_tgtX = root.Position.X.Offset
                    _G._tek_tgtY = root.Position.Y.Offset
                    pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
                end
            end)
        end)
        UIS.InputChanged:Connect(function(i)
            if not on or _G._TekPanelDragging then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = i.Position - from
            if d.Magnitude >= 4 then headerWasDragged = true end
            root.Position = UDim2.fromOffset(base.X.Offset + d.X, base.Y.Offset + d.Y)
        end)
    end

    local function short(n)
        n = tonumber(n) or 0
        if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
        if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
        if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
        return string.format("%d", n)
    end
    local MUTATION_COLORS = {
        bloodrot = Color3.fromRGB(170, 0, 0),
        candy = Color3.fromRGB(255, 110, 190),
        crystal = Color3.fromRGB(140, 225, 255),
        cursed = Color3.fromRGB(120, 40, 180),
        cyber = Color3.fromRGB(0, 230, 255),
        diamond = Color3.fromRGB(130, 215, 255),
        divine = Color3.fromRGB(255, 240, 170),
        galaxy = Color3.fromRGB(155, 90, 255),
        gold = Color3.fromRGB(255, 210, 0),
        lava = Color3.fromRGB(255, 95, 0),
        phantom = Color3.fromRGB(205, 205, 225),
        radioactive = Color3.fromRGB(90, 255, 90),
        rainbow = Color3.fromRGB(255, 255, 255),
        yinyang = Color3.fromRGB(170, 170, 170),
    }
    local function mutationColor(mut)
        if type(mut) ~= "string" or mut == "" or mut == "None" then return C.txt end
        local key = mut:lower():gsub("[%s%-_]", "")
        return MUTATION_COLORS[key] or C.txt
    end

    local _CTP_TOL_X, _CTP_TOL_Z = 62, 58
    local function _ctpFloorFromY(y)
        if y >= -6.9 and y <= 8.9 then return 1 end
        if y >= 11 and y <= 23.15 then return 2 end
        if y > 23.15 then return 3 end
        return nil
    end
    local function _ctpFloorFromSlot(slot, py)
        local s = tonumber(slot)
        if s then
            if s >= 19 then return 3 end
            if s >= 11 then return 2 end
            if s >= 1 then return 1 end
        end
        if py then return _ctpFloorFromY(py) end
        return nil
    end
    local function _ctpSameBase(petPos, myPos)
        local pIdx = getClosestBaseIdx(petPos)
        local mIdx = getClosestBaseIdx(myPos)
        if pIdx ~= mIdx then return false end
        local b = BASES_LOW[mIdx]
        if not b then return false end
        return math.abs(myPos.X - b.X) <= _CTP_TOL_X
           and math.abs(myPos.Z - b.Z) <= _CTP_TOL_Z
    end
    local function _ctpAllowed(pet)
        if not pet or not pet.position then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local myPos = hrp.Position
        if not _ctpSameBase(pet.position, myPos) then return false end
        local myFloor = _ctpFloorFromY(myPos.Y)
        if not myFloor then return false end
        local tgtFloor = _ctpFloorFromSlot(pet.slot, pet.position.Y)
        if not tgtFloor then return false end
        local diff = tgtFloor - myFloor
        local up = tonumber(_G.TekClickTPMaxUp) or 3
        local down = tonumber(_G.TekClickTPMaxDown) or 3
        return diff <= up and diff >= -down
    end

    local rows = {}
    local function rowFor(uid)
        local r = rows[uid]
        if r and r.card.Parent then return r end
        local card = round(mk("Frame", list, {
            Size = UDim2.new(1, -4, 0, 44), BackgroundColor3 = C.row,
            BorderSizePixel = 0, Active = true,
        }), 6)
        local bg = mk("Frame", card, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        round(bg, 6)
        local rank = mk("TextLabel", card, {
            Position = UDim2.fromOffset(6, 0), Size = UDim2.fromOffset(20, 44),
            BackgroundTransparency = 1, Font = FB, TextSize = 11, TextColor3 = C.dim,
            TextXAlignment = Enum.TextXAlignment.Center, Text = "", ZIndex = 2, Visible = false,
        })
        local mutationIcon = mk("ImageLabel", card, {
            Position = UDim2.fromOffset(12, 6), Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1, Image = "", Visible = false, ZIndex = 2,
            ScaleType = Enum.ScaleType.Fit,
        })
        local nm = mk("TextLabel", card, {
            Position = UDim2.fromOffset(12, 7), Size = UDim2.new(1, -86, 0, 15),
            BackgroundTransparency = 1, Font = FB, TextSize = 12, TextColor3 = C.txt,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 2,
        })
        local icons = {}
        for k = 1, 4 do
            icons[k] = mk("ImageLabel", card, {
                Position = UDim2.fromOffset(30 + (k - 1) * 16, 24), Size = UDim2.fromOffset(13, 13),
                BackgroundTransparency = 1, Image = "", Visible = false, ZIndex = 2,
            })
        end
        local sub = mk("TextLabel", card, {
            Position = UDim2.fromOffset(30, 24), Size = UDim2.new(1, -104, 0, 12),
            BackgroundTransparency = 1, Font = FR, TextSize = 9, TextColor3 = C.dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 2,
        })
        local mps = mk("TextLabel", card, {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0),
            Size = UDim2.fromOffset(66, 44), BackgroundTransparency = 1,
            Font = FB, TextSize = 11, TextColor3 = C.acc,
            TextXAlignment = Enum.TextXAlignment.Right, Text = "", ZIndex = 2,
        })
        local hit = mk("TextButton", card, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 3,
        })
        r = { card = card, bg = bg, rank = rank, mutationIcon = mutationIcon, name = nm, sub = sub, mps = mps, icons = icons, hit = hit, lastLocked = false }
        rows[uid] = r
        return r
    end

    local function selectStealTarget(myUid, pet)
        if type(myUid) ~= "string" or myUid == "" then return false end
        _G.TekStealTargetUID = myUid
        do
            local okS, fresh = pcall(scanAllPets)
            if okS and type(fresh) == "table" then
                for _, fp in ipairs(fresh) do
                    if not fp.conveyor and _petUid(fp) == myUid then pet = fp break end
                end
            end
        end
        if not pet then return false end
        _G.TekStealTarget = pet
        if _G.TekArmSteal then pcall(_G.TekArmSteal, pet) end
        if LP:GetAttribute("Stealing") == true and _G.Tek_DropBrainrot then
            pcall(_G.Tek_DropBrainrot)
            local dropWaitUntil = os.clock() + 1
            while LP:GetAttribute("Stealing") == true and os.clock() < dropWaitUntil do
                RunService.Heartbeat:Wait()
            end
            if _G.TekStealTargetUID ~= myUid then return false end
        end
        if pet.position and _G.TekClickTPBusy and _ctpAllowed(pet) then
            _G.TekClickTPPending = pet
            _G.TekTPStop = true
        elseif pet.position and not isTeleporting and _ctpAllowed(pet) then
            _G.TekClickTPBusy = true
            isTeleporting = true
            task.spawn(function()
                local target = pet
                while target do
                    _G.TekTPStop = false
                    pcall(function() goToBrainrot(target.position, target.slot) end)
                    local pending = _G.TekClickTPPending
                    _G.TekClickTPPending = nil
                    if pending and _G.TekStealTargetUID == _petUid(pending) then
                        target = pending
                    else
                        target = nil
                    end
                end
                isTeleporting = false
                _G.TekClickTPBusy = false
            end)
        end
        return true
    end

    _G.TekCycleStealTarget = function()
        local ok, pets = pcall(scanAllPets)
        if not ok or type(pets) ~= "table" then return false end
        local available = {}
        for _, pet in ipairs(pets) do
            if not pet.conveyor then available[#available + 1] = pet end
        end
        if #available == 0 then return false end
        local currentUid = _G.TekStealTargetUID
        local currentIndex = 0
        for i, pet in ipairs(available) do
            if _petUid(pet) == currentUid then currentIndex = i break end
        end
        local nextPet = available[(currentIndex % #available) + 1]
        return selectStealTarget(_petUid(nextPet), nextPet)
    end

    task.spawn(function()
        local _pd = tonumber(_G.TekPanelStartDelay) or 0

        if not game:IsLoaded() then game.Loaded:Wait() end
        if _pd > 0 then task.wait(_pd) end
        local _filled = false
        local _panelT0 = os.clock()
        while sg.Parent do
            local _pw = os.clock()
            while _filled
                and (_G.TekStealHold or (_G.TekIsTeleporting and _G.TekIsTeleporting()))
                and os.clock() - _pw < (tonumber(_G.TekPanelPauseMax) or 3) do
                task.wait(0.2)
            end
            local bootActive = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
            local pets = scanAllPetsCached(bootActive and 0.1 or 0.15)
        local ok = pets ~= nil
            if ok and type(pets) == "table" then
                local seen = {}
                for i, p in ipairs(pets) do
                    if not p.conveyor then
                        local uid = _petUid(p)
                        seen[uid] = true
                        local r = rowFor(uid)
                        r.pet = p
                        if r.lastOrder ~= i then
                            r.lastOrder = i
                            r.card.LayoutOrder = i
                        end
                        local nmTxt = tostring(p.name or "?")
                        if r.lastName ~= nmTxt then r.lastName = nmTxt; r.name.Text = nmTxt end
                        local mpsTxt = "$" .. short(p.mps or 0) .. "/s"
                        if r.lastMps ~= mpsTxt then r.lastMps = mpsTxt; r.mps.Text = mpsTxt end
                        local mutKey = tostring(p.mutation or "") .. "\0"
                            .. tostring(p.traits and #p.traits or 0) .. "\0"
                            .. tostring(_iconForName(MUTATION_ICONS, p.mutation) or "")
                        if r.lastMut ~= mutKey then
                            r.lastMut = mutKey
                            for _, ic in ipairs(r.icons) do ic.Visible = false end
                            r.sub.Position = UDim2.fromOffset(12, 24)
                            r.sub.Size = UDim2.new(1, -86, 0, 12)
                            if type(p.mutation) == "string" and p.mutation ~= "" and p.mutation ~= "None" then
                                r.sub.Text = _mutationDisplayName(p.mutation)
                                local mutationImage = _iconForName(MUTATION_ICONS, p.mutation)
                                r.mutationIcon.Image = mutationImage and tostring(mutationImage) or ""
                                r.mutationIcon.Visible = mutationImage ~= nil and tostring(mutationImage) ~= ""
                                r.name.Position = r.mutationIcon.Visible and UDim2.fromOffset(36, 7) or UDim2.fromOffset(12, 7)
                                r.name.Size = r.mutationIcon.Visible and UDim2.new(1, -110, 0, 15) or UDim2.new(1, -86, 0, 15)
                            else
                                r.sub.Text = ""
                                r.mutationIcon.Image = ""
                                r.mutationIcon.Visible = false
                                r.name.Position = UDim2.fromOffset(12, 7)
                                r.name.Size = UDim2.new(1, -86, 0, 15)
                            end
                            r.name.TextColor3 = mutationColor(p.mutation)
                        end
                        local locked = (_G.TekStealTargetUID == uid)
                        if locked ~= r.lastLocked then
                            r.lastLocked = locked
                            tw(r.bg, { BackgroundTransparency = locked and 0 or 1 })
                            tw(r.card, { BackgroundColor3 = locked and C.rowH or C.row })
                        end
                        if not r.wired then
                            r.wired = true
                            local myUid = uid
                            local _crow = r
                            r.hit.MouseButton1Click:Connect(function()
                                if _G.TekStealTargetUID == myUid then
                                    _G.TekStealTargetUID = nil
                                    _G.TekStealTarget = nil
                                    _G.TekClickTPPending = nil
                                    if _G.TekDisarmSteal then pcall(_G.TekDisarmSteal) end
                                else
                                    selectStealTarget(myUid, _crow.pet)
                                end
                            end)
                            r.hit.MouseEnter:Connect(function()
                                if _G.TekStealTargetUID ~= myUid then
                                    tw(r.card, { BackgroundColor3 = C.rowH })
                                end
                            end)
                            r.hit.MouseLeave:Connect(function()
                                if _G.TekStealTargetUID ~= myUid then
                                    tw(r.card, { BackgroundColor3 = C.row })
                                end
                            end)
                        end
                    end
                end
                local n = 0
                for uid, r in pairs(rows) do
                    if seen[uid] then n = n + 1
                    else r.card:Destroy() rows[uid] = nil end
                end
                if n > 0 then _filled = true end
            end
            if not _filled and (os.clock() - _panelT0) < (tonumber(_G.TekPanelRush) or 10) then
                task.wait(bootActive and 0.15 or (tonumber(_G.TekPanelRushGap) or 0.15))
            else
                task.wait(tonumber(_G.TekPanelScanGap) or 0.6)
            end
        end
    end)

    pcall(function()
        local oldMode = host:FindFirstChild("TekMode")
        if oldMode then oldMode:Destroy() end
    end)
    pcall(function()
        local legacyMode = host:FindFirstChild("ElysiumMode")
        if legacyMode then legacyMode:Destroy() end
    end)

    local modeSg = mk("ScreenGui", nil, {
        Name = "TekMode", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 999998,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() modeSg.Parent = host end)
    if not modeSg.Parent then pcall(function() modeSg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) end
    do
        local us = modeSg:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
        us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = modeSg
    end

    local modeRoot = round(mk("Frame", modeSg, {
        Name = "Root", Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
        BackgroundTransparency = 0.04,
        Size = UDim2.fromOffset(260, 440),
        Position = UDim2.fromOffset(tonumber(_G._tek_modeX) or 24,
            tonumber(_G._tek_modeY) or 190),
    }), 10)
    mk("UIGradient", modeRoot, {
        Rotation = 135,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.bg2), ColorSequenceKeypoint.new(1, C.bg)}),
    })
    mk("UIStroke", modeRoot, { Thickness = 1, Transparency = 0.4, Color = C.line })
    local modeTitle = mk("TextLabel", modeRoot, {
        Position = UDim2.fromOffset(12, 7), Size = UDim2.new(1, -24, 0, 18),
        BackgroundTransparency = 1, Text = "AUTO STEAL", Font = FB, TextSize = 13,
        TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local modeContainer = mk("Frame", modeRoot, {
        Position = UDim2.fromOffset(12, 31), Size = UDim2.new(1, -24, 0, 64),
        BackgroundTransparency = 1,
    })
    mk("UIListLayout", modeContainer, {
        Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local modeButtons = {}
    local lastModeState = nil
    local function updateAllModes()
        local currentState = _G.TekStealMode
        if currentState == lastModeState then return end
        lastModeState = currentState
        for _, btnData in ipairs(modeButtons) do
            local on = currentState == btnData.mode
            tw(btnData.bg, { BackgroundTransparency = on and 0.82 or 1 })
            tw(btnData.btn, { TextColor3 = on and Color3.fromRGB(105, 235, 145) or C.dim })
        end
    end

    local function modeBtn(txt, mode)
        local btnBg = round(mk("Frame", modeContainer, {
            Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = C.row,
            BorderSizePixel = 0, ZIndex = 1,
        }), 8)
        local bg = mk("Frame", btnBg, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(105, 235, 145),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
        })
        round(bg, 8)
        local btn = mk("TextButton", btnBg, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = txt, Font = FB, TextSize = 11, TextColor3 = C.dim,
            AutoButtonColor = false, Active = true, ZIndex = 3,
        })
        btn.MouseButton1Click:Connect(function()
            if _G._TekModeDragMoved or _G._TekPanelDragging then return end
            if _G.TekSourceStealActive and _G.TekOpenSourceStealPanel then
                _G.TekOpenSourceStealPanel()
                return
            end
            if mode == "nearest" and _G.TekOpenSourceStealPanel then
                _G.TekOpenSourceStealPanel()
                return
            end
            if _G.TekStealMode == mode then
                _G.TekStealMode = nil
            else
                _G.TekStealMode = mode
            end
            pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
            updateAllModes()
        end)
        btn.MouseEnter:Connect(function()
            if _G.TekStealMode ~= mode then
                tw(btnBg, { BackgroundColor3 = C.rowH })
            end
        end)
        btn.MouseLeave:Connect(function()
            if _G.TekStealMode ~= mode then
                tw(btnBg, { BackgroundColor3 = C.row })
            end
        end)
        table.insert(modeButtons, { btn = btn, bg = bg, mode = mode })
        return btn
    end
    modeBtn("PRIORITY", "priority")
    modeBtn("NEAREST", "nearest")

    -- ===== QUICK ACTIONS: big tappable TP / RESET / CLONE (same actions as the keybinds) =====
    local actRow = mk("Frame", modeRoot, {
        Name = "QuickActions", BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, -24, 0, 40), Position = UDim2.fromOffset(12, 103),
    })
    mk("UIListLayout", actRow, {
        Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    local function quickAction(order, label, busyLabel, color, getAction, onFail)
        local bg = round(mk("Frame", actRow, {
            Name = label .. "Btn", BackgroundColor3 = C.row, BorderSizePixel = 0,
            ZIndex = 1, LayoutOrder = order, Size = UDim2.new(1 / 3, -4, 1, 0),
        }), 8)
        local hl = mk("Frame", bg, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = color,
            BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 2,
        })
        round(hl, 8)
        local btn = mk("TextButton", bg, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = label, Font = FB, TextSize = 12, TextColor3 = color,
            AutoButtonColor = false, Active = true, ZIndex = 3,
        })
        -- tap guard: if the finger slid (you were dragging the panel) it's not a tap
        local pressAt, slid = nil, false
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                pressAt, slid = i.Position, false
            end
        end)
        btn.InputChanged:Connect(function(i)
            if pressAt and (i.UserInputType == Enum.UserInputType.Touch
                or i.UserInputType == Enum.UserInputType.MouseMovement) then
                local d = i.Position - pressAt
                if Vector2.new(d.X, d.Y).Magnitude > 12 then slid = true end
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then pressAt = nil end
        end)
        local last = 0
        btn.MouseButton1Click:Connect(function()
            if slid or _G._TekModeDragMoved or _G._TekPanelDragging then slid = false; return end
            if os.clock() - last < 0.35 then return end
            last = os.clock()
            local action = getAction()
            if type(action) ~= "function" then
                btn.Text = "NOT READY"
                task.delay(0.8, function() btn.Text = label end)
                return
            end
            btn.Text = busyLabel
            tw(hl, { BackgroundTransparency = 0.5 })
            task.spawn(function()
                local ok = pcall(action)
                if not ok and onFail then pcall(onFail) end
            end)
            task.delay(0.6, function()
                btn.Text = label
                tw(hl, { BackgroundTransparency = 0.82 })
            end)
        end)
        btn.MouseEnter:Connect(function() tw(bg, { BackgroundColor3 = C.rowH }) end)
        btn.MouseLeave:Connect(function() tw(bg, { BackgroundColor3 = C.row }) end)
    end
    quickAction(1, "TP", "TP...", Color3.fromRGB(105, 235, 145), function()
        return _G.TekStartSideTP or _G.Tek_ExecuteManualTP or _G.MynxxStartSideTP
    end)
    quickAction(2, "RESET", "RESET...", Color3.fromRGB(235, 110, 110), function()
        return _G.Tek_InstantReset or _G.TekInstantReset
    end)
    quickAction(3, "CLONE", "CLONE...", Color3.fromRGB(110, 180, 245), function()
        return _G.TekInstantClone or _G.TekDoClone
    end, function() _G.isCloning = false end)

    local tpBtnBg = round(mk("Frame", modeRoot, {
        Name = "TPSettingsBtn", BackgroundColor3 = C.row,
        BorderSizePixel = 0, ZIndex = 1,
        Size = UDim2.new(1, -24, 0, 30),
        Position = UDim2.fromOffset(12, 151),
    }), 8)
    local tpBtnHl = mk("Frame", tpBtnBg, {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(105, 235, 145),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
    })
    round(tpBtnHl, 8)
    local tpBtn = mk("TextButton", tpBtnBg, {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "TP SETTINGS", Font = FB, TextSize = 10, TextColor3 = C.dim,
        AutoButtonColor = false, Active = true, ZIndex = 3,
    })
    if _G._tek_modeExpanded == nil then _G._tek_modeExpanded = false end
    local settingsScroll = mk("ScrollingFrame", modeRoot, {
        Position = UDim2.fromOffset(12, 189), Size = UDim2.new(1, -24, 1, -201),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 1,
    })
    mk("UIListLayout", settingsScroll, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    if type(_G._tek_modeW) ~= "number" then _G._tek_modeW = 260 end
    if type(_G._tek_modeH) ~= "number" then _G._tek_modeH = 440 end
    local modeGrip = mk("TextButton", modeRoot, {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2),
        Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, Active = true, ZIndex = 10,
    })
    for _, o in ipairs({ -2, 3 }) do
        local ln2 = mk("Frame", modeGrip, {
            Size = UDim2.new(0, 20, 0, 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, o),
            BackgroundColor3 = C.dim, BorderSizePixel = 0, ZIndex = 11,
        })
        ln2.Rotation = 45
    end
    do
        local resizing, rStart, rW, rH = false, nil, 0, 0
        modeGrip.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            resizing, rStart = true, i.Position
            rW, rH = modeRoot.Size.X.Offset, modeRoot.Size.Y.Offset
        end)
        UIS.InputChanged:Connect(function(i)
            if not resizing then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = i.Position - rStart
            _G._tek_modeW = math.clamp(rW + d.X, 220, 600)
            _G._tek_modeH = math.clamp(rH + d.Y, 200, 800)
            modeRoot.Size = UDim2.fromOffset(_G._tek_modeW, _G._tek_modeH)
        end)
        UIS.InputEnded:Connect(function(i)
            if resizing and (i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch) then
                resizing = false
                pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
            end
        end)
    end
    local function applyExpanded()
        settingsScroll.Visible = _G._tek_modeExpanded
        local mw = tonumber(_G._tek_modeW) or 260
        local mh = tonumber(_G._tek_modeH) or 440
        modeRoot.Size = _G._tek_modeExpanded and UDim2.fromOffset(mw, mh) or UDim2.fromOffset(mw, 189)
        modeGrip.Visible = _G._tek_modeExpanded
        tw(tpBtnHl, { BackgroundTransparency = _G._tek_modeExpanded and 0.82 or 1 })
        tw(tpBtn, { TextColor3 = _G._tek_modeExpanded and Color3.fromRGB(105, 235, 145) or C.dim })
    end
    tpBtn.MouseButton1Click:Connect(function()
        if _G._TekModeDragMoved or _G._TekPanelDragging then return end
        _G._tek_modeExpanded = not _G._tek_modeExpanded
        applyExpanded()
    end)
    tpBtn.MouseEnter:Connect(function() tw(tpBtnBg, { BackgroundColor3 = C.rowH }) end)
    tpBtn.MouseLeave:Connect(function() tw(tpBtnBg, { BackgroundColor3 = C.row }) end)

    local mOrder = 0
    local function mNext() mOrder = mOrder + 1 return mOrder end
    local mRefreshers = {}
    local function mSlider(txt, min, max, get, set, step)
        step = step or 1
        local card = round(mk("Frame", settingsScroll, {
            Size = UDim2.new(1, -4, 0, 50), BackgroundColor3 = C.row,
            BorderSizePixel = 0, Active = true, ZIndex = 2, LayoutOrder = mNext(),
        }), 6)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -76, 0, 14), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = FR, TextSize = 11,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local val = mk("TextLabel", card, {
            Size = UDim2.fromOffset(52, 14), Position = UDim2.new(1, -64, 0, 8),
            BackgroundTransparency = 1, Font = FB, TextSize = 12, TextColor3 = C.txt,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3,
        })
        local track = mk("TextButton", card, {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(14, 32),
            BackgroundColor3 = C.track, Text = "", AutoButtonColor = false,
            Active = true, BorderSizePixel = 0, ZIndex = 3,
        })
        local fill = mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.acc,
            BorderSizePixel = 0, ZIndex = 4,
        })
        local knob = mk("Frame", track, {
            Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = C.txt,
            BorderSizePixel = 0, ZIndex = 5,
        })
        local lastV = nil
        local function refresh()
            local v = math.clamp(tonumber(get()) or min, min, max)
            if v == lastV then return end
            lastV = v
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            val.Text = step < 1 and string.format("%.2f", v) or tostring(math.floor(v + 0.5))
        end
        local function applyAt(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            set(math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max))
            refresh()
        end
        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                applyAt(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then applyAt(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch) then
                sliding = false
                pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
            end
        end)
        refresh()
        mRefreshers[#mRefreshers + 1] = refresh
    end
    local function mToggle(txt, get, set)
        local card = round(mk("Frame", settingsScroll, {
            Size = UDim2.new(1, -4, 0, 36), BackgroundColor3 = C.row,
            BorderSizePixel = 0, Active = true, ZIndex = 2, LayoutOrder = mNext(),
        }), 6)
        local hit = mk("TextButton", card, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            Active = true, AutoButtonColor = false, ZIndex = 4,
        })
        mk("TextLabel", card, {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(14, 0),
            BackgroundTransparency = 1, Text = txt, Font = FB, TextSize = 12,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local pill = round(mk("Frame", card, {
            Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = C.track, BorderSizePixel = 0, ZIndex = 3,
        }), 10)
        local knob = round(mk("Frame", pill, {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = C.dim, BorderSizePixel = 0, ZIndex = 4,
        }), 8)
        local function paint()
            local v = get()
            pill.BackgroundColor3 = v and C.acc or C.track
            knob.BackgroundColor3 = v and C.bg or C.dim
            knob.Position = v and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
        end
        hit.MouseButton1Click:Connect(function()
            set(not get())
            paint()
            pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
        end)
        paint()
    end

    mSlider("TP VELOCITY", 200, 750,
        function() return tonumber(_G.TPVelocity) or 400 end, function(v) _G.TPVelocity = v end, 5)
    mSlider("RISE SPEED", 100, 250,
        function() return tonumber(_G.TekClimb) or 160 end, function(v) _G.TekClimb = v end, 5)
    mSlider("GO TO BRAINROT SPEED", 80, 600,
        function() return tonumber(_G.TekGoSpeed) or 200 end, function(v) _G.TekGoSpeed = v end, 5)
    mSlider("LANDING DELAY", 0.01, 1,
        function() return tonumber(_G.LandingDelay) or 0.35 end, function(v) _G.LandingDelay = v end, 0.01)
    mSlider("100 STUDS BASE SPEED", 20, 400,
        function() return tonumber(_G.TekCloseSpeed) or 80 end, function(v) _G.TekCloseSpeed = v end, 5)
    mSlider("PRE-CLONE SPEED", 40, 250,
        function() return tonumber(_G.TekPreCloneSpeed) or 120 end, function(v) _G.TekPreCloneSpeed = v end, 5)
    mToggle("TWEEN TP",
        function() return _G.TekTweenTP == true end,
        function(v) _G.TekTweenTP = v end)
    mToggle("FLING TP",
        function() return _G.TekFlingTP == true end,
        function(v) _G.TekFlingTP = v end)
    mSlider("TWEEN SNAP (STUDS)", 20, 60,
        function() return tonumber(_G.TekTweenNear) or 40 end,
        function(v) _G.TekTweenNear = v end, 1)
    mSlider("TWEEN HOP (STUDS/FRAME)", 3, 40,
        function() return tonumber(_G.TekTweenStage) or 14 end,
        function(v) _G.TekTweenStage = v end, 1)
    mToggle("FLASH TP",
        function() return _G.TekFlashTP == true end,
        function(v) _G.TekFlashTP = v end)
    mSlider("FLASH FIRE WAIT", 0, 0.25,
        function() return tonumber(_G.TekFlashGroundWait) or 0.12 end,
        function(v) _G.TekFlashGroundWait = v end, 0.01)
    mSlider("FLASH EQUIP DISTANCE", 0, 60,
        function() return tonumber(_G.TekFlashPreEquip) or 50 end,
        function(v) _G.TekFlashPreEquip = v end, 1)
    mToggle("CFRAME TP",
        function() return _G.TekCFrameTP == true end,
        function(v) _G.TekCFrameTP = v end)
    mSlider("CFRAME START STUDS", 0, 30,
        function() return tonumber(_G.TekCFrameStart) or 30 end, function(v) _G.TekCFrameStart = v end, 1)
    mSlider("CFRAME END STUDS", 0, 30,
        function() return tonumber(_G.TekCFrameEnd) or 30 end, function(v) _G.TekCFrameEnd = v end, 1)

    local priBtnBg = round(mk("Frame", settingsScroll, {
        Name = "PriHeader", BackgroundColor3 = C.row,
        BorderSizePixel = 0, ZIndex = 2, LayoutOrder = mNext(),
        Size = UDim2.new(1, -4, 0, 30),
    }), 6)
    local priBtnHl = mk("Frame", priBtnBg, {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.acc,
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
    })
    round(priBtnHl, 6)
    local priBtn = mk("TextButton", priBtnBg, {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "PRIORITY", Font = FB, TextSize = 10, TextColor3 = C.dim,
        AutoButtonColor = false, Active = true, ZIndex = 3,
    })
    priBtn.MouseEnter:Connect(function() tw(priBtnBg, { BackgroundColor3 = C.rowH }) end)
    priBtn.MouseLeave:Connect(function() tw(priBtnBg, { BackgroundColor3 = C.row }) end)
    if _G._tek_modePriExpanded == nil then _G._tek_modePriExpanded = false end
    local priHint = mk("TextLabel", settingsScroll, {
        Size = UDim2.new(1, -4, 0, 14), BackgroundTransparency = 1,
        Text = "TOP = HIGHEST", Font = FB, TextSize = 9, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, LayoutOrder = mNext(),
    })

    local modePriTab = "brainrot"
    local refreshModePri
    local subTabs = mk("Frame", settingsScroll, {
        Size = UDim2.new(1, -4, 0, 26), BackgroundTransparency = 1, ZIndex = 2, LayoutOrder = mNext(),
    })
    mk("UIListLayout", subTabs, {
        Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
    })
    local subTabBtns = {}
    local function paintSubTabs()
        for _, e in ipairs(subTabBtns) do
            local on = (e.key == modePriTab)
            e.btn.BackgroundColor3 = on and C.acc or C.track
            e.btn.TextColor3 = on and C.bg or C.txt
        end
    end
    for _, info in ipairs({ { "Brainrots", "brainrot" }, { "Mutations", "mutation" } }) do
        local key = info[2]
        local b = round(mk("TextButton", subTabs, {
            Size = UDim2.fromOffset(100, 26), BackgroundColor3 = C.track,
            Text = info[1], Font = FB, TextSize = 11, TextColor3 = C.txt,
            AutoButtonColor = false, Active = true, ZIndex = 3,
        }), 6)
        b.MouseButton1Click:Connect(function()
            modePriTab = key
            paintSubTabs()
            if refreshModePri then refreshModePri() end
        end)
        subTabBtns[#subTabBtns + 1] = { btn = b, key = key }
    end

    local modeAddRow = round(mk("Frame", settingsScroll, {
        Size = UDim2.new(1, -4, 0, 36), BackgroundColor3 = C.row,
        BorderSizePixel = 0, ZIndex = 2, LayoutOrder = mNext(),
    }), 6)
    local modeAddBox = mk("TextBox", modeAddRow, {
        Size = UDim2.new(1, -74, 0, 24), Position = UDim2.fromOffset(10, 6),
        BackgroundColor3 = C.track, BorderSizePixel = 0,
        Font = FR, TextSize = 12, TextColor3 = C.txt,
        TextXAlignment = Enum.TextXAlignment.Left,
        PlaceholderText = "type a name, then Enter", PlaceholderColor3 = C.dim,
        ClearTextOnFocus = false, Text = "", Active = true, ZIndex = 4,
    })
    mk("UIPadding", modeAddBox, { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    local modeAddBtn = round(mk("TextButton", modeAddRow, {
        Size = UDim2.fromOffset(52, 24), Position = UDim2.new(1, -60, 0, 6),
        BackgroundColor3 = C.acc, Text = "ADD", Font = FB, TextSize = 11,
        TextColor3 = C.bg, AutoButtonColor = false, Active = true, ZIndex = 4,
    }), 6)
    local function modeDoAdd()
        local name = (modeAddBox.Text or ""):match("^%s*(.-)%s*$")
        if name and name ~= "" then
            if modePriTab == "mutation" then
                if type(_G.SHARED_MUTATION_PRIORITY) ~= "table" then _G.SHARED_MUTATION_PRIORITY = {} end
                table.insert(_G.SHARED_MUTATION_PRIORITY, name)
            else
                if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
                table.insert(_G.SHARED_PRIORITY_ITEMS, name)
            end
            _G.TekPriVersion = (_G.TekPriVersion or 0) + 1
            pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
            modeAddBox.Text = ""
            if refreshModePri then refreshModePri() end
        end
    end
    modeAddBtn.MouseButton1Click:Connect(modeDoAdd)
    modeAddBox.FocusLost:Connect(function(enter) if enter then modeDoAdd() end end)

    local modeRowsHost = mk("Frame", settingsScroll, {
        Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2, LayoutOrder = mNext(),
    })
    mk("UIListLayout", modeRowsHost, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    local function modeGetListAndIcon()
        if modePriTab == "mutation" then
            return _G.SHARED_MUTATION_PRIORITY, MUTATION_ICONS
        end
        return _G.SHARED_PRIORITY_ITEMS, nil
    end
    refreshModePri = function()
        for _, c in ipairs(modeRowsHost:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        if type(_G.SHARED_MUTATION_DISABLED) ~= "table" then _G.SHARED_MUTATION_DISABLED = {} end
        local L, icons = modeGetListAndIcon()
        if type(L) ~= "table" then return end
        for i = 1, #L do
            local nm = tostring(L[i])
            local row = round(mk("Frame", modeRowsHost, {
                Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = C.row,
                BorderSizePixel = 0, LayoutOrder = i, ZIndex = 2,
            }), 6)
            local iconId = _iconForName(icons, nm)
            local textOff = 12
            if iconId and type(iconId) == "string" then
                mk("ImageLabel", row, {
                    Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(10, 4),
                    BackgroundTransparency = 1, Image = tostring(iconId), ZIndex = 3,
                })
                textOff = 40
            end
            mk("TextLabel", row, {
                Size = UDim2.new(1, (modePriTab == "mutation") and -148 or -104, 1, 0),
                Position = UDim2.fromOffset(textOff, 0),
                BackgroundTransparency = 1, Text = (modePriTab == "mutation") and _mutationDisplayName(nm) or nm,
                Font = FR, TextSize = 12, TextColor3 = C.txt,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
            })
            local function commit()
                _G.TekPriVersion = (_G.TekPriVersion or 0) + 1
                pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
                refreshModePri()
            end
            local function mini(xoff, sym, act)
                local b = round(mk("TextButton", row, {
                    Size = UDim2.fromOffset(26, 22), Position = UDim2.new(1, xoff, 0.5, -11),
                    BackgroundColor3 = C.track, Text = sym, Font = FB, TextSize = 12,
                    TextColor3 = C.txt, AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 6)
                b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = C.rowH }) end)
                b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = C.track }) end)
                b.MouseButton1Click:Connect(act)
                return b
            end
            mini(-98, "\u{25B2}", function() if i > 1 then L[i], L[i - 1] = L[i - 1], L[i]; commit() end end)
            mini(-68, "\u{25BC}", function() if i < #L then L[i], L[i + 1] = L[i + 1], L[i]; commit() end end)
            mini(-36, "X", function() table.remove(L, i) commit() end)
            if modePriTab == "mutation" then
                local D = _G.SHARED_MUTATION_DISABLED
                local off = D[nm] == true
                local tg = round(mk("TextButton", row, {
                    Size = UDim2.fromOffset(34, 22), Position = UDim2.new(1, -136, 0.5, -11),
                    BackgroundColor3 = off and C.track or C.acc,
                    Text = off and "OFF" or "ON", Font = FB, TextSize = 10,
                    TextColor3 = off and C.dim or C.bg,
                    AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 6)
                tg.MouseButton1Click:Connect(function()
                    if D[nm] then D[nm] = nil else D[nm] = true end
                    commit()
                end)
            end
        end
    end

    local function applyPriExpanded()
        local open = _G._tek_modePriExpanded
        priHint.Visible = open
        subTabs.Visible = open
        modeAddRow.Visible = open
        modeRowsHost.Visible = open
        tw(priBtnHl, { BackgroundTransparency = open and 0 or 1 })
        tw(priBtn, { TextColor3 = open and C.bg or C.dim })
    end
    priBtn.MouseButton1Click:Connect(function()
        _G._tek_modePriExpanded = not _G._tek_modePriExpanded
        applyPriExpanded()
    end)

    paintSubTabs()
    refreshModePri()
    applyExpanded()
    applyPriExpanded()

    local lastModePriVer = -1
    task.spawn(function()
        while modeSg.Parent do
            updateAllModes()
            local pv = _G.TekPriVersion or 0
            if pv ~= lastModePriVer then
                lastModePriVer = pv
                pcall(refreshModePri)
            end
            for _, r in ipairs(mRefreshers) do pcall(r) end
            task.wait(0.5)
        end
    end)

    do
        local on, from, base, tracked, moved
        modeRoot.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            -- everything above the settings list drags (title, modes, TP/RESET/CLONE,
            -- TP SETTINGS). Measured in panel units + top inset so it's right at any UI Size.
            local ok, relY = pcall(function()
                local inset = modeSg.IgnoreGuiInset and game:GetService("GuiService"):GetGuiInset().Y or 0
                local k = modeRoot.AbsoluteSize.Y / math.max(1, modeRoot.Size.Y.Offset)
                return (i.Position.Y + inset - modeRoot.AbsolutePosition.Y) / math.max(k, 0.01)
            end)
            if ok and relY > 185 then return end
            on, from, base, moved = true, i.Position, modeRoot.Position, false
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End and on then
                    on = false
                    if moved then
                        task.delay(0.15, function() _G._TekModeDragMoved = false end)
                        _G._tek_modeX = modeRoot.Position.X.Offset
                        _G._tek_modeY = modeRoot.Position.Y.Offset
                        pcall(function() if _G.TekSaveSettings then _G.TekSaveSettings() end end)
                    end
                end
            end)
        end)
        modeRoot.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then tracked = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if not on or i ~= tracked or _G._TekPanelDragging then return end
            local d = i.Position - from
            if not moved then
                -- small dead-zone so tapping a button never nudges the panel
                if Vector2.new(d.X, d.Y).Magnitude < 6 then return end
                moved = true
                _G._TekModeDragMoved = true
            end
            modeRoot.Position = UDim2.fromOffset(base.X.Offset + d.X, base.Y.Offset + d.Y)
        end)
    end

    _G.TekToggleTargets = function() sg.Enabled = not sg.Enabled end
    _G.TekToggleMode = function() modeSg.Enabled = not modeSg.Enabled end

    pcall(function()
        local oldWm = host:FindFirstChild("TekWatermark")
        if oldWm then oldWm:Destroy() end
    end)
    local wmSg = mk("ScreenGui", nil, {
        Name = "TekWatermark", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 999997,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() wmSg.Parent = host end)
    if not wmSg.Parent then pcall(function() wmSg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) end
    do
        local us = wmSg:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
        us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = wmSg
    end
    mk("TextLabel", wmSg, {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(500, 50), BackgroundTransparency = 1,
        Text = "mogger", Font = FB, TextSize = 4,
        TextColor3 = C.txt, TextTransparency = 0.2,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    _G.TekToggleWatermark = function() wmSg.Enabled = not wmSg.Enabled end
end)()

-- BEGIN TekSourceStealPanel: extracted from the user-supplied hub.
task.defer(function()
    local enabled, nearest, instant, refreshing = false, true, false, false
    local instantWanted, generation = true, 0
    local publishedUid, saved, sourceError
    local synchronizer, animalDefinitions
    local channelCache, channelAt = {}, 0
    local function loadDependencies()
        if synchronizer then return true end
        local replicated = game:GetService("ReplicatedStorage")
        local packages = replicated:FindFirstChild("Packages")
        local datas = replicated:FindFirstChild("Datas")
        local module = packages and packages:FindFirstChild("Synchronizer")
        local animals = datas and datas:FindFirstChild("Animals")
        if not module or not animals then return false end
        synchronizer = require(module)
        animalDefinitions = require(animals)
        return true
    end
    local function channel(plot)
        if os.clock()-channelAt > 0.25 then channelCache={}; channelAt=os.clock() end
        if channelCache[plot] ~= nil then return channelCache[plot] or nil end
        local ok, data = pcall(function()
            local identity = getthreadidentity and getthreadidentity()
            if setthreadidentity then setthreadidentity(8) end
            local success, result = pcall(synchronizer.GetTableFromChannel, synchronizer, plot)
            if identity and setthreadidentity then pcall(setthreadidentity, identity) end
            if not success then error(result) end
            return result
        end)
        channelCache[plot] = ok and type(data)=="table" and data or false
        return channelCache[plot] or nil
    end
    local P = { SelectedPetData = nil }
    local player = game:GetService("Players").LocalPlayer
    local f = game:GetService("TweenService")
    pcall(function() if setthreadidentity then setthreadidentity(8) end end)
do
    local C = { AUTO_STEAL = false, RADIUS = 12 }
    local r = {
        {
            min = Vector3.new(-337.448303, -3.898971, -122.397758),
            max = Vector3.new(-328.004578, -3.898971, 242.625626),
        },
        {
            min = Vector3.new(-327.25766, -3.899109, -122.228622),
            max = Vector3.new(-320.600891, -3.899109, 242.612259),
        },
        {
            min = Vector3.new(-319.783386, -3.89897, -122.227089),
            max = Vector3.new(-312.908325, -3.89897, 242.585617),
        },
        {
            min = Vector3.new(-312.445648, -3.899108, -122.389832),
            max = Vector3.new(-305.489899, -3.899108, 242.456818),
        },
        {
            min = Vector3.new(-305.037048, -3.89897, -122.230743),
            max = Vector3.new(-293.957489, -3.89897, 242.606873),
        },
        {
            min = Vector3.new(-491.448608, -3.898972, -122.253258),
            max = Vector3.new(-481.811737, -3.898972, 242.615005),
        },
        {
            min = Vector3.new(-498.971069, -3.89897, -122.382767),
            max = Vector3.new(-491.74884, -3.89897, 242.612061),
        },
        {
            min = Vector3.new(-506.436737, -3.898972, -122.411476),
            max = Vector3.new(-499.318542, -3.898972, 242.615982),
        },
        {
            min = Vector3.new(-513.783569, -3.898972, -122.223297),
            max = Vector3.new(-506.801849, -3.898972, 242.62709),
        },
        {
            min = Vector3.new(-525.236938, -3.898972, -122.409813),
            max = Vector3.new(-514.265015, -3.898972, 242.608932),
        },
    }
    local R = game:GetService("Players")
    local d = game:GetService("RunService")
    local n = R.LocalPlayer
    do
        local R
        local function f()
            n.DevEnableMouseLock = true
            n.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            if R then
                R:Disconnect()
            end
            R = d.RenderStepped:Connect(function()
                local R = workspace.CurrentCamera
                if R and R.CameraSubject and R.CameraType == Enum.CameraType.Custom then
                    R.CFrame = R.CFrame
                end
            end)
        end
        f()
        n.CharacterAdded:Connect(function()
            task.wait(0.5)
            f()
        end)
    end
    local R = {}
    local d = {}
    local f = 0
    function _G.getSafePollRate()
        if os.clock() < f then
            return 0.27
        end
        return 0.1
    end
    function _G.triggerSafePollBoost()
        f = os.clock() + 3
    end
    local f = {}
    local function J()
        local a = n.Character
        return a and a:FindFirstChild("HumanoidRootPart")
    end
    local function n(a)
        for e, x in ipairs(r) do
            if
                a.X >= math.min(x.min.X, x.max.X)
                and a.X <= math.max(x.min.X, x.max.X)
                and a.Z >= math.min(x.min.Z, x.max.Z)
                and a.Z <= math.max(x.min.Z, x.max.Z)
            then
                return e
            end
        end
    end
    local function r(a)
        local e = a.Parent
        if not e then
            return
        end
        if e:IsA("Attachment") and e.Parent then
            e = e.Parent
        end
        if e:IsA("BasePart") then
            return e.Position
        elseif e:IsA("Model") then
            return e:GetPivot().Position
        end
    end
    local function a(e)
        if not P then
            return false
        end
        local x = P.SelectedPetData
        if not x then
            return false
        end
        local Q = e:FindFirstAncestorOfClass("Model")
        if not Q then
            return false
        end
        if x.plot then
            local V = e:FindFirstAncestor(x.plot)
            if not V then
                return false
            end
        end
        if x.slot then
            local V = e:FindFirstAncestor(x.slot)
            if V then
                return true
            end
            if Q.Name == x.slot then
                return true
            end
            if Q.Parent and Q.Parent.Name == x.slot then
                return true
            end
        end
        if x.name then
            local e = string.lower(x.name)
            local x = Q
            while x do
                if x.Name and string.lower(x.Name) == e then
                    return true
                end
                x = x.Parent
            end
        end
        return false
    end
    local function e(x, Q)
        if not enabled then return false end
        if not x or not x.Parent then
            return false
        end
        if not x.Enabled then
            return false
        end
        local V = r(x)
        if not V then
            return false
        end
        local r = x:FindFirstAncestorOfClass("Model")
        if r then
            local r = workspace:FindFirstChild("Plots")
            if r then
                local i = x:FindFirstAncestorWhichIsA("Model")
                while i and i.Parent ~= r do
                    i = i.Parent
                end
                if i then
                    local r = i:FindFirstChild("PlotSign")
                    if r then
                        local i = r:FindFirstChildWhichIsA("SurfaceGui", true)
                        local r = i and i:FindFirstChildWhichIsA("TextLabel", true)
                        if r then
                            local i = r.Text:lower()
                            if
                                i:find(game.Players.LocalPlayer.Name:lower(), 1, true)
                                or i:find(game.Players.LocalPlayer.DisplayName:lower(), 1, true)
                            then
                                return false
                            end
                        end
                    end
                end
            end
        end
        if _G.NEAREST_INSTANT_MODE == true then
            local r = n(Q)
            local i = n(V)
            if not r or r ~= i then
                return false
            end
        end
        if _G.NEAREST_INSTANT_MODE ~= true then
            if not a(x) then
                return false
            end
        end
        local r = typeof(x.MaxActivationDistance) == "number"
                and x.MaxActivationDistance > 0
                and x.MaxActivationDistance
            or C.RADIUS
        local n = math.min(C.RADIUS, r)
        return (V - Q).Magnitude <= n
    end
    local function r(n, a)
        local x = os.clock()
        local Q = d[n]
        if Q and x - Q < a then
            return false
        end
        d[n] = x
        return true
    end
    local function n(a, x, Q)
        if not a or not a.Parent then
            return
        end
        if not a.Enabled then
            return
        end
        if not r(a, Q) then
            return
        end
        for r = 1, x do
            pcall(function()
                fireproximityprompt(a, 0)
            end)
        end
    end
    local function r(a)
        if R[a] then
            return
        end
        R[a] = true
        local function x()
            local Q = J()
            if not Q then
                return
            end
            local V = Q.Position
            if e(a, V) then
                C.AUTO_STEAL = true
                local Q = os.clock()
                local V = f[a]
                if not V or Q - V >= 0.08 then
                    f[a] = Q
                    n(a, 25, 0)
                end
            end
        end
        task.defer(function()
            x()
        end)
        pcall(function()
            a:GetPropertyChangedSignal("Enabled"):Connect(function()
                if a.Enabled then
                    x()
                end
            end)
        end)
        a.AncestryChanged:Connect(function()
            if not a:IsDescendantOf(workspace) then
                R[a] = nil
                d[a] = nil
                f[a] = nil
            end
        end)
    end
    local function d()
        local f = workspace:FindFirstChild("Plots")
        if not f then
            return
        end
        for a, a in ipairs(f:GetChildren()) do
            local f = a:FindFirstChild("AnimalPodiums")
            if f then
                for a, a in ipairs(f:GetDescendants()) do
                    if a:IsA("ProximityPrompt") then
                        r(a)
                    end
                end
            end
        end
    end
    d()
    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("ProximityPrompt") and d:FindFirstAncestor("AnimalPodiums") then
            r(d)
        end
    end)
    task.spawn(function()
        while task.wait(_G.getSafePollRate()) do
            local r = J()
            if not r then
                C.AUTO_STEAL = false
                continue
            end
            local d = r.Position
            local r = false
            for f in pairs(R) do
                if e(f, d) then
                    r = true
                    if C.AUTO_STEAL then
                        n(f, 3, 0.12)
                    end
                end
            end
            C.AUTO_STEAL = r
        end
    end)
end
    local b = {
        BG = Color3.fromRGB(22, 10, 10),
        SURF = Color3.fromRGB(26, 10, 10),
        SURF2 = Color3.fromRGB(44, 16, 16),
        TEXT = Color3.fromRGB(255, 235, 235),
        DIM = Color3.fromRGB(180, 80, 80),
        AQUA = Color3.fromRGB(220, 60, 60),
        AQUA2 = Color3.fromRGB(170, 30, 30),
        AQUA_STROKE = Color3.fromRGB(200, 50, 50),
        GREEN1 = Color3.fromRGB(18, 88, 58),
        GREEN2 = Color3.fromRGB(21, 120, 76),
        GREEN_STROKE = Color3.fromRGB(60, 185, 120),
        OFF_BG = Color3.fromRGB(52, 18, 18),
        OFF_TEXT = Color3.fromRGB(160, 70, 70),
    }
    local function tG(DG, EG)
        local mG = Instance.new("UICorner")
        mG.CornerRadius = UDim.new(0, EG)
        mG.Parent = DG
        return mG
    end
    local function DG(EG, mG, AG, HG)
        local ZG = Instance.new("UIStroke")
        ZG.Color = mG
        ZG.Thickness = AG or 1
        ZG.Transparency = HG or 0
        ZG.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ZG.Parent = EG
        return ZG
    end
    local function EG(mG, AG, HG, ZG, kG)
        f:Create(
            mG,
            TweenInfo.new(AG or 0.2, ZG or Enum.EasingStyle.Quint, kG or Enum.EasingDirection.Out),
            HG
        ):Play()
    end
    local function mG(AG, HG, ZG, kG)
        local uG = Instance.new("UIGradient")
        uG.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, HG), ColorSequenceKeypoint.new(1, ZG) })
        uG.Rotation = kG or 0
        uG.Parent = AG
        return uG
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TekSourceStealPanel"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    do
        local us = gui:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
        us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = gui
    end
    local panel = Instance.new("Frame", gui)
    panel.Size = UDim2.fromOffset(300, 235)
    panel.Position = UDim2.new(1, -320, 0.5, -95)
    panel.BackgroundColor3 = b.BG
    panel.BorderSizePixel = 0
    tG(panel, 16); DG(panel, b.AQUA_STROKE, 1.2, 0.4)
    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "AUTO STEAL"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 18
    title.TextColor3 = b.TEXT
    title.Active = true
    local body = Instance.new("Frame", panel)
    body.Position = UDim2.fromOffset(8, 44)
    body.Size = UDim2.new(1, -16, 0, 126)
    body.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", body)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local AG = 1
    local function HG(ZG, kG, uG)
        local gG = Instance.new("Frame", ZG)
        gG.Name = kG:gsub("%s+", "") .. "Row"
        gG.Size = UDim2.new(1, 0, 0, math.floor(38 * AG))
        gG.BackgroundColor3 = b.SURF2
        gG.BackgroundTransparency = 0.02
        gG.BorderSizePixel = 0
        gG.LayoutOrder = math.floor((uG or 0) / math.max(1, 42 * AG)) + 1
        gG.ZIndex = 103
        tG(gG, 10)
        local ZG = DG(gG, b.AQUA_STROKE, 1, 0.52)
        local uG = Instance.new("TextLabel", gG)
        uG.BackgroundTransparency = 1
        uG.Position = UDim2.fromOffset(10, 0)
        uG.Size = UDim2.new(1, -90.0, 1, 0)
        uG.Font = Enum.Font.GothamBold
        uG.Text = kG
        uG.TextColor3 = b.TEXT
        uG.TextSize = 13 * AG
        uG.TextXAlignment = Enum.TextXAlignment.Left
        uG.ZIndex = 104
        local hG = Instance.new("TextButton", gG)
        hG.Name = kG:gsub("%s+", "") .. "Toggle"
        hG.AutoButtonColor = false
        hG.Size = UDim2.fromOffset(math.floor(72 * AG), math.floor(26 * AG))
        hG.Position = UDim2.new(1, -math.floor(80 * AG), 0.5, -math.floor(13 * AG))
        hG.BackgroundColor3 = b.OFF_BG
        hG.BorderSizePixel = 0
        hG.Text = ""
        hG.ZIndex = 104
        tG(hG, 6)
        local kG = DG(hG, b.AQUA_STROKE, 1, 0.55)
        local LG = Instance.new("Frame", hG)
        LG.Size = UDim2.new(1, 0, 1, 0)
        LG.BackgroundTransparency = 1
        LG.BorderSizePixel = 0
        LG.ZIndex = 104
        tG(LG, 6)
        mG(LG, b.GREEN1, b.GREEN2, 0)
        local sG = Instance.new("TextLabel", hG)
        sG.BackgroundTransparency = 1
        sG.Size = UDim2.fromScale(1, 1)
        sG.Font = Enum.Font.GothamBold
        sG.TextSize = 11 * AG
        sG.Text = "OFF"
        sG.TextColor3 = b.OFF_TEXT
        sG.ZIndex = 105
        gG.MouseEnter:Connect(function()
            EG(gG, 0.14, { BackgroundColor3 = Color3.fromRGB(58, 20, 20) })
            EG(ZG, 0.14, { Transparency = 0.38 })
        end)
        gG.MouseLeave:Connect(function()
            EG(gG, 0.14, { BackgroundColor3 = b.SURF2 })
            EG(ZG, 0.14, { Transparency = 0.52 })
        end)
        return { row = gG, label = uG, button = hG, knob = LG, stateLabel = sG, stroke = kG, rowStroke = ZG }
    end

    local enabledRow = HG(body, "Enable panel", 0)
    local nearestRow = HG(body, "Nearest Steal", 42)
    local instantRow = HG(body, "Instant Steal", 84)
    local status = Instance.new("TextLabel", panel)
    status.Position = UDim2.fromOffset(10, 177)
    status.Size = UDim2.new(1, -20, 0, 24)
    status.BackgroundTransparency = 1
    status.TextColor3 = b.TEXT
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextTruncate = Enum.TextTruncate.AtEnd
    local track = Instance.new("Frame", panel)
    track.Position = UDim2.fromOffset(10, 210)
    track.Size = UDim2.new(1, -20, 0, 8)
    track.BackgroundColor3 = b.SURF2
    track.BorderSizePixel = 0
    tG(track, 4)
    local wG = Instance.new("Frame", track)
    wG.Size = UDim2.fromScale(0, 1)
    wG.BackgroundColor3 = b.AQUA
    wG.BorderSizePixel = 0
    tG(wG, 4)
    local qG, BG, zG = {}, nil, nil
    local function KG(oG)
        if qG[oG] then
            return
        end
        local IG = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local pG, jG = pcall(getconnections, oG.PromptButtonHoldBegan)
        if pG and type(jG) == "table" then
            for pG, pG in ipairs(jG) do
                if type(pG.Function) == "function" then
                    table.insert(IG.holdCallbacks, pG.Function)
                end
            end
        end
        local pG, jG = pcall(getconnections, oG.Triggered)
        if pG and type(jG) == "table" then
            for pG, pG in ipairs(jG) do
                if type(pG.Function) == "function" then
                    table.insert(IG.triggerCallbacks, pG.Function)
                end
            end
        end
        local pG, jG = pcall(getconnections, oG.PromptButtonHoldEnded)
        if pG and type(jG) == "table" then
            for pG, pG in ipairs(jG) do
                if type(pG.Function) == "function" then
                    table.insert(IG.holdEndCallbacks, pG.Function)
                end
            end
        end
        if #IG.holdCallbacks > 0 or #IG.triggerCallbacks > 0 or #IG.holdEndCallbacks > 0 then
            qG[oG] = IG
        end
    end
    local function oG(IG)
        for pG, pG in ipairs(IG) do
            task.spawn(pG)
        end
    end
    local function IG(jG, lG)
        local WG = qG[jG]
        if not WG or not WG.ready then
            return false
        end
        WG.ready = false
        task.spawn(function()
            if BG ~= lG then
                if zG then
                    zG:Cancel()
                end
                wG.Size = UDim2.new(0, 0, 1, 0)
                BG = lG
            end
            if #WG.holdCallbacks > 0 then
                oG(WG.holdCallbacks)
            end
            wG.Size = UDim2.new(0, 0, 1, 0)
            wG.BackgroundTransparency = 0
            zG = f:Create(wG, TweenInfo.new(1.2, Enum.EasingStyle.Linear), { Size = UDim2.new(1, 0, 1, 0) })
            zG:Play()
            zG.Completed:Wait()
            if enabled and jG.Parent and jG.Enabled and BG == lG and #WG.triggerCallbacks > 0 then
                oG(WG.triggerCallbacks)
            end
            WG.ready = true
        end)
        return true
    end
    local function oG(jG, lG)
        if not jG or not jG.Parent then
            return false
        end
        KG(jG)
        if not qG[jG] then
            return false
        end
        if BG ~= lG then
            if zG then
                zG:Cancel()
                zG = nil
            end
            wG.Size = UDim2.new(0, 0, 1, 0)
        end
        return IG(jG, lG)
    end

    local function paint(row, enabled)
        row.button.BackgroundColor3 = enabled and b.GREEN1 or b.OFF_BG
        row.knob.BackgroundTransparency = enabled and 0 or 1
        row.stateLabel.Text = enabled and "ON" or "OFF"
        row.stateLabel.TextColor3 = enabled and Color3.fromRGB(232,255,240) or b.OFF_TEXT
        row.stroke.Color = enabled and b.GREEN_STROKE or b.AQUA_STROKE
    end
    local function cancelHold()
        BG = nil
        if zG then zG:Cancel(); zG = nil end
        wG.Size = UDim2.fromScale(0,1)
    end
    local function paintAll()
        paint(enabledRow, enabled)
        paint(nearestRow, nearest)
        paint(instantRow, instantWanted)
    end
    local function configure()
        generation = generation + 1
        refreshing = false
        instant = enabled and instantWanted
        _G.NEAREST_INSTANT_MODE = enabled and nearest and instant
        cancelHold()
        paintAll()
    end
    local function setEnabled(value)
        if enabled == value then return end
        if value then
            local ok, ready = pcall(loadDependencies)
            if not ok or not ready then
                status.Text = "Scanner unavailable: " .. tostring(ready)
                return
            end
            saved = {
                mode=_G.TekStealMode, uid=_G.TekStealTargetUID,
                pet=_G.TekStealTarget, nearestMode=_G.NEAREST_INSTANT_MODE,
            }
            _G.TekSourceStealActive = true
            if _G.TekDisarmSteal then pcall(_G.TekDisarmSteal) end
            _G.TekStealMode = nil
            _G.TekStealTargetUID, _G.TekStealTarget = nil, nil
            enabled = true
        else
            enabled = false
            P.SelectedPetData = nil
            publishedUid = nil
            _G.TekSourceStealActive = false
            if saved then
                _G.TekStealMode = saved.mode
                _G.TekStealTargetUID, _G.TekStealTarget = saved.uid, saved.pet
            end
        end
        configure()
        if not value and saved then _G.NEAREST_INSTANT_MODE = saved.nearestMode end
        if not value then status.Text = "Disabled — Elysium restored" end
    end
    enabledRow.button.MouseButton1Click:Connect(function() setEnabled(not enabled) end)
    nearestRow.button.MouseButton1Click:Connect(function() nearest=not nearest; configure() end)
    instantRow.button.MouseButton1Click:Connect(function() instantWanted=not instantWanted; configure() end)
    _G.TekOpenSourceStealPanel = function() panel.Visible=true end
    _G.TekDisableSourceStealPanel = function() setEnabled(false) end
    local function own(plot)
        local data=channel(plot.Name)
        local owner=data and data.Owner
        if not owner then return true end
        if typeof(owner)=="Instance" then return owner==player or not owner.Parent end
        if type(owner)=="string" then
            return owner==player.Name or not game:GetService("Players"):FindFirstChild(owner)
        end
        return false
    end
    local function pick()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local plots = workspace:FindFirstChild("Plots")
        if not root or not plots then return end
        local best, distance, data = nil, math.huge, nil
        for _, plot in ipairs(plots:GetChildren()) do
            if not own(plot) then
                local podiums = plot:FindFirstChild("AnimalPodiums")
                if podiums then
                    for _, podium in ipairs(podiums:GetChildren()) do
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        local attachment = spawn and spawn:FindFirstChild("PromptAttachment")
                        local prompt = attachment and attachment:FindFirstChildOfClass("ProximityPrompt")
                        local dist = spawn and (spawn.Position-root.Position).Magnitude or math.huge
                        if prompt and prompt.Enabled and dist < distance then
                            best, distance = prompt, dist
                            local plotData = channel(plot.Name)
                            local animals = plotData and plotData.AnimalList
                            local animal = animals and (animals[tonumber(podium.Name)] or animals[podium.Name])
                            local definition = animal and animalDefinitions[animal.Index]
                            data = {
                                plot=plot.Name, slot=podium.Name, position=spawn.Position,
                                name=definition and definition.DisplayName or prompt.ObjectText,
                                index=animal and animal.Index, mutation=animal and animal.Mutation,
                            }
                        end
                    end
                end
            end
        end
        return best, data
    end
    task.spawn(function()
        while gui.Parent do
            game:GetService("RunService").Heartbeat:Wait()
            local ok, err = pcall(function()
                if not enabled then return end
                if not nearest and not instant then status.Text = "Choose a mode"; return end
                local prompt, data
                if nearest then prompt, data = pick() end
                P.SelectedPetData = nearest and data or _G.TekStealTarget
                if nearest and not player:GetAttribute("Stealing") then
                    local uid = data and (data.plot .. "_" .. data.slot)
                    if uid ~= publishedUid then cancelHold() end
                    publishedUid = uid
                    _G.TekStealTargetUID, _G.TekStealTarget = uid, data
                end
                if instant then
                    -- Source hub cancels the ordinary tween when Instant resumes.
                    if zG then zG:Cancel(); zG=nil end
                    status.Text = nearest and (data and ("Nearest: " .. tostring(data.name)) or "No nearby target") or "Instant: select a target in Elysium"
                    return
                end
                if prompt and data then
                    status.Text = "Nearest: " .. tostring(prompt.ObjectText)
                    oG(prompt, data.plot .. "_" .. data.slot)
                else
                    BG = nil
                    if zG then zG:Cancel(); zG=nil end
                    wG.Size = UDim2.fromScale(0,1)
                    status.Text = "No nearby target"
                end
            end)
            if not ok then status.Text = "Error: " .. tostring(err) end
        end
    end)
    -- Preserve the source hub's Instant toggle refresh cadence.
    task.spawn(function()
        while gui.Parent do
            task.wait(1.5)
            if enabled and instantWanted then
                local token = generation
                instant = false
                refreshing = true
                _G.NEAREST_INSTANT_MODE = false
                -- The ordinary Nearest handler runs during this interval,
                -- exactly as it does when the source Instant toggle goes off.
                task.wait(0.05)
                if enabled and instantWanted and token == generation then
                    instant = true
                    refreshing = false
                    _G.NEAREST_INSTANT_MODE = nearest
                end
            end
        end
    end)
    local dragStart, panelStart, dragging
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; panelStart=panel.Position
        end
    end)
    local inputService = game:GetService("UserInputService")
    inputService.InputChanged:Connect(function(input)
        if dragging and not _G._TekPanelDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart
            panel.Position=UDim2.new(panelStart.X.Scale,panelStart.X.Offset+delta.X,panelStart.Y.Scale,panelStart.Y.Offset+delta.Y)
        end
    end)
    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging=false end
    end)
    paintAll()
    status.Text = "Enable panel to start Nearest + Instant"
    gui.Destroying:Connect(function() setEnabled(false) end)
end)
-- END TekSourceStealPanel

-- =====================================================================
-- RoyalFinder-Extras (combined, iPhone-scaled)
-- =====================================================================

-- TEST BUILD v2: Elysium Extras with runway auto-buy and brainrot follow. Starts OFF.
-- Keep one Extras instance per Roblox session.  A second instance duplicates
-- keybinds/follow loops and can start another teleport while the first is busy.

task.wait(0)
-- LocalPlayer MUST exist before anything below touches it.
-- Without this, every early LocalPlayer.Character / LocalPlayer:... errors
-- ("index nil 'Character'" / "call nil") since the file captures/uses it at load.
do
    local _p = game:GetService("Players")
    local _w = os.clock()
    while not _p.LocalPlayer and os.clock() - _w < 30 do task.wait() end
    if _p.LocalPlayer and LocalPlayer == nil then
        LocalPlayer = _p.LocalPlayer -- global fallback for legacy bare references
    end
end
_G.TekBootT0 = _G.TekBootT0 or (typeof(tick) == "function" and tick() or os.clock())
task.wait()
task.spawn(function()
    local speedFrame, speedLabel
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if speedFrame then pcall(function() speedFrame.Visible = false end) end
            continue
        end
        if not speedFrame then
            local sg = Instance.new("ScreenGui")
            sg.Name = "TekSpeedDisplay"
            sg.ResetOnSpawn = false
            sg.IgnoreGuiInset = true
            sg.DisplayOrder = 9999
            sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
            do
                local us = sg:FindFirstChild("Tek_GlobalScale") or Instance.new("UIScale")
                us.Name = "Tek_GlobalScale"; us.Scale = (type(GlobalUIScaleVal)=="number" and GlobalUIScaleVal) or 0.48; us.Parent = sg
            end
            speedFrame = Instance.new("Frame", sg)
            speedFrame.Size = UDim2.new(0, 88, 0, 15)
            speedFrame.Position = UDim2.new(1, -98, 1, -21)
            speedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            speedFrame.BackgroundTransparency = 0.4
            speedFrame.BorderSizePixel = 0
            speedLabel = Instance.new("TextLabel", speedFrame)
            speedLabel.Size = UDim2.new(1, -8, 1, 0)
            speedLabel.Position = UDim2.new(0, 4, 0, 0)
            speedLabel.BackgroundTransparency = 1
            speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedLabel.Font = Enum.Font.GothamMedium
            speedLabel.TextSize = 8
            speedLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
        speedFrame.Visible = true
        local spd = (hrp.Velocity.Magnitude)
        speedLabel.Text = string.format("%.0f studs/s", spd)
    end
end)

-- =====================================================================
-- EARLY BOOT -- runs DURING the loading screen, before game.Loaded.
-- ---------------------------------------------------------------------
-- The hub proper gates on game.Loaded below, but this thread overlaps the
-- loading screen with the expensive prep the TP needs: the first require() of
-- Synchronizer/Animals/etc. is the slowest part of the first pet scan, and
-- those replicate WHILE loading, so warm them now (WaitForChild yields until
-- each streams in). TP-on-load then fires without paying that cost.
--
-- NOTE: do NOT add a void-fall guard that anchors the HRP until game.Loaded.
-- game.Loaded fires ONCE, so if loading finished during the character wait its
-- :Wait() hangs forever and leaves the character permanently anchored -- the
-- grapple fires but you never move. The second thread here is the cleanup for
-- exactly that state, so re-executing always frees the character.
-- =====================================================================
do
    task.spawn(function()
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local Packages = RS:WaitForChild("Packages", 120)
            require(Packages:WaitForChild("Synchronizer", 120))
            Packages:WaitForChild("Net", 60)
            local Datas = RS:WaitForChild("Datas", 60)
            require(Datas:WaitForChild("Animals", 60))
            local Shared = RS:WaitForChild("Shared", 60)
            require(Shared:WaitForChild("Animals", 60))
            local Utils = RS:WaitForChild("Utils", 30)
            require(Utils:WaitForChild("NumberUtils", 30))
        end)
    end)
end

if not game:IsLoaded() then game.Loaded:Wait() end
_G.TekLoadedSecs = (typeof(tick) == "function" and tick() or os.clock()) - (_G.TekBootT0 or (typeof(tick) == "function" and tick() or os.clock()))

local __RS = game:GetService("RunService")
function _adaptWait(state, costMs)
    local target = (costMs * 10) / 1000
    if target > 0.05 then target = 0.05 end
    state.d = (state.d or 0) * 0.7 + target * 0.3
    if state.d < 0.004 then __RS.Heartbeat:Wait() else task.wait(state.d) end
end
_G._TekReady = false
_G._TekScanFrozenUntil = 0
function _scansFrozen() return os.clock() < (_G._TekScanFrozenUntil or 0) end



local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService= game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local Workspace       = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService      = game:GetService("GuiService")
local LocalPlayer     = Players.LocalPlayer
do local _wL = os.clock() while not LocalPlayer and os.clock() - _wL < 5 do task.wait() LocalPlayer = Players.LocalPlayer end end

do
    local _GuiService = cloneref and cloneref(game:GetService("GuiService")) or game:GetService("GuiService")
    task.spawn(function()
        while true do
            pcall(function() _GuiService:ClearError() end)
            task.wait(0.1)
        end
    end)
end

local PlayerGui       = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)

do
    _G.__wsClearBoost = function() end
    _G.__wsApplyBoost = function() end
end



do
local RESET_MAX_DURATION = 0.05
local resetCooldown = false
local resetThread = nil
local currentCharacter = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil
local function StopResetSequence()
    stopResetSequence = true
    if resetThread then task.cancel(resetThread); resetThread = nil end
    resetCooldown = false
    currentCharacter = nil
    cameraLocked = false
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                end
            end)
        end
    end
end
local function instantReset()
    if resetCooldown then return end
    if _G.ElysiumSetInvisManual then pcall(_G.ElysiumSetInvisManual, false) end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false
    _G.AntiDieDisabled = true
    _G.Tek_IsResetting = true
    if _G.TekPrepareMovementReset then pcall(_G.TekPrepareMovementReset) end
    _G.TekTPStop = true
    _G.tekTPStop = true
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:UnequipTools() end
        if char then
            local bp = LocalPlayer:FindFirstChild("Backpack")
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then if bp then t.Parent = bp else t:Destroy() end end
            end
        end
    end)
    local character = LocalPlayer.Character
    if not character then _G.AntiDieDisabled=false; _G.Tek_IsResetting=false; resetCooldown=false; return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then _G.AntiDieDisabled=false; _G.Tek_IsResetting=false; resetCooldown=false; return end
    pcall(function()
        humanoid.BreakJointsOnDeath = true
        humanoid.RequiresNeck = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    end)
    local camera = workspace.CurrentCamera
    if camera then lockedCameraCFrame = camera.CFrame; cameraLocked=true; camera.CFrame=lockedCameraCFrame end
    currentCharacter = character
    resetThread = task.spawn(function()
        local attempts=0; local maxAttempts=40; local originalHipHeight=humanoid.HipHeight
        while character and character.Parent and humanoid and humanoid.Health>0 and not stopResetSequence do
            if LocalPlayer.Character~=character then break end
            pcall(function()
                humanoid.HipHeight=1e30; humanoid.AutoRotate=true
                local rootPart=character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide=false end
                for _,part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then part.CanCollide=false end end
            end)
            if not character or not character.Parent or not humanoid or humanoid.Health<=0 or LocalPlayer.Character~=character then resetSuccessful=true; break end
            attempts+=1; if attempts>=maxAttempts then break end
            task.wait(RESET_MAX_DURATION)
        end
        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health>0 then
                pcall(function() humanoid.Health=0 end); task.wait(0.1)
                if not character.Parent or humanoid.Health<=0 then resetSuccessful=true end
            end
        end
        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight=originalHipHeight
                local rootPart=character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide=true end
                for _,part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then part.CanCollide=true end end
            end)
        end
        cameraLocked=false; resetCooldown=false; resetThread=nil; currentCharacter=nil; stopResetSequence=false
        _G.Tek_IsResetting=false
        task.delay(2,function() if LocalPlayer.Character~=character then _G.AntiDieDisabled=false end end)
    end)
end
_G.Tek_InstantReset = function()
    if type(_G.TekInstantReset) == "function" then return _G.TekInstantReset() end
    return instantReset()
end
_G.FrameResetLite = { Reset = instantReset, Stop = StopResetSequence }
LocalPlayer.CharacterAdded:Connect(function() StopResetSequence(); _G.AntiDieDisabled=false; _G.Tek_IsResetting=false end)
task.spawn(function()
    local camera = workspace.CurrentCamera
    while true do task.wait(0.016); if cameraLocked and lockedCameraCFrame and camera then pcall(function() camera.CFrame=lockedCameraCFrame end) end end
end)
end

local FileName = "tek_extras.runway-autobuy-test.json"
local DefaultConfig = {
    UILocked = false, MenuKey = "RightControl", ConfigKey = "LeftControl", TeleportKey = "T", CarpetSpeedKey = "Q", CarpetTool = "Flying Carpet", CarpetSpeed = 180, InstantResetKey = "R", InstantCloneKey = "V",
    InfiniteJump = false, AntiRagdoll = true, XrayEnabled = false, ESPPlayerEnabled = false, ESPBaseOwnerEnabled = false,     CarpetSpeedEnabled = false,
    AutoKickEnabled = false,
    AutoKickGuiX = false, AutoKickGuiY = false,
    AutoBuyEnabled = false, AutoBuyKey = "K", AutoBuyRange = 17,
    AntiFlashEnabled = false, AntiFlashKey = "NONE",
    KickKey = "NONE",
    InvisStealKey = "NONE",
    FlashTeleportKey = "NONE", BestTeleportKey = "NONE", StopTeleportKey = "NONE",
    FloatKey = "B", FloatSpeed = 40,
    NextTargetKey = "Y",
    DropBrainrotKey = "NONE",
    PlaceboScreenEnabled = true,
    PlaceboScreenSeconds = 2.5,
    FOV = 120,
    PrivateServerLink = "",
    StealMode = "Priority", StealHighest = false, StealPriority = true, StealNearest = false,
    AutoStealEnabled = true, AutoTPPriority = true, AutoTPFloor2FromFloor1 = false, AutoTPOnSteal = true,
    SkipStolenTarget = true,
    InstantStealEnabled = true, AutoGrabRadius = 95,
    AutoGrabCommitRange = 10, AutoGrabEntryDelay = 0.30,
    AutoGrabHoldMaxTotal = 20, AutoGrabUseFPP = true,
    InvisStealAngle = 180, SinkSliderValue = 7, AutoRecoverLagback = true, AutoInvisDuringSteal = true,
    InvisDelayEnabled = true, InvisDelayMs = 500,
    AvoidPlayersInvis = false, AvoidPlayersInvisRange = 20, AvoidPlayersInvisSpeed = 20,
    PriorityList = nil, StealTargetUID = nil,
    PriorityAlertEnabled = true, AlertSoundID = "",
    TekPositions = {},
    Visibilities = {["TP Settings"]=false,["Priority List"]=false},
    TpSettings = {GrabbleTPSpeed=450,WalkTPSpeed=280,CloneDelayVal=0.01,TpOnLoad=true,Tool="Flying Carpet",BrainrotCarpet=false,NearbyTPSpeed=350,NearbyTPRange=100,NearbyCloneDelay=0.01,NearbyCloneRange=100,PostCloneWait=0.1,PlatformF2Y=13.5,PlatformF3Y=15.5,TpDelay=0,SideEntryN=25,ShowTPPath=true,LightRoute=true,RiseSpeed=95,PathHeight=20,PathMinDist=100},
    Positions = {Main = {X=0.72, Y=0.3}},
}
local function deepMerge(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" and type(dst[k]) == "table" then deepMerge(dst[k], v) else dst[k] = v end
    end
end
local Config = {}
deepMerge(Config, DefaultConfig)
local readConfigFile = FileName
if isfile and not isfile(FileName) and isfile("tek_extras.json") then readConfigFile="tek_extras.json" end
if isfile and isfile(readConfigFile) then
    pcall(function()
        local ok, d = pcall(function() return HttpService:JSONDecode(readfile(readConfigFile)) end)
        if ok and type(d) == "table" then deepMerge(Config, d) end
    end)
end

-- Migrate the old, overly fast Carpet Speed value.
if tonumber(Config.CarpetSpeed) == nil or tonumber(Config.CarpetSpeed) > 140 then
    Config.CarpetSpeed = 140
end

_G.GoonUseV2TP = Config.GoonUseV2TP == true
Config.AutoInvisDuringSteal=true
Config.InvisDelayEnabled=true;Config.InvisDelayMs=600
Config.RunwayBuyMode="nearest"
Config.AntiRagdoll=false;Config.AntiFlashEnabled=false;Config.GoonUnwalkEnabled=false
Config.XrayEnabled=false;Config.CarpetSpeedEnabled=false
Config.MenuKey="NONE";Config.FloatKey="NONE"
Config.FlashTeleportKey="NONE";Config.BestTeleportKey="NONE";Config.StopTeleportKey="NONE"
_G.GoonUnwalkEnabled=false
_G.AutoInvisDuringSteal=true;_G.JAF_InvisDelayEnabled=true;_G.JAF_InvisDelayMs=600

if not Config.__cfgKeySplit then
    Config.__cfgKeySplit = true
    if Config.MenuKey == "LeftControl" or not Config.MenuKey then Config.MenuKey = "RightControl" end
    if not Config.ConfigKey or Config.ConfigKey == "NONE" then Config.ConfigKey = "LeftControl" end
end

local function SaveConfig()
    Config.iPadMode, Config.iPadScale = nil, nil
    Config.WalkSpeedKey, Config.WalkSpeedValue = nil, nil
    Config.WalkSpeedOnSteal, Config.WalkSpeedEnabled = nil, nil
    if writefile then
        pcall(function() writefile(FileName, HttpService:JSONEncode(Config)) end)
    end
end
-- Remove keys left by the retired laser griefer/range-ring implementation.
Config.LineToStealerEnabled = nil
Config.LaserMaxDistance = nil
task.defer(SaveConfig)
local player = LocalPlayer
local UIS = UserInputService
local panels = {}
local Theme = {
    Background=Color3.fromRGB(18, 18, 18), MainBackground=Color3.fromRGB(12, 12, 12), Panel=Color3.fromRGB(28, 28, 28),
    Row=Color3.fromRGB(35, 35, 35), RowHover=Color3.fromRGB(50, 50, 50), Accent=Color3.fromRGB(255, 255, 255),
    AccentLight=Color3.fromRGB(240, 240, 240), Green=Color3.fromRGB(211, 211, 211), Red=Color3.fromRGB(117, 117, 117),
    Text=Color3.fromRGB(240, 240, 240), Dim=Color3.fromRGB(140, 140, 140), Stroke=Color3.fromRGB(60, 60, 60),
    SoftButton=Color3.fromRGB(30, 30, 30), SoftButtonHover=Color3.fromRGB(50, 50, 50),
    SoftAccent=Color3.fromRGB(25, 25, 25), SoftAccentHover=Color3.fromRGB(40, 40, 40),
    ToggleOff=Color3.fromRGB(40, 40, 40), ToggleOff2=Color3.fromRGB(40, 40, 40),
    InputBg=Color3.fromRGB(15, 15, 15), SliderBg=Color3.fromRGB(45, 45, 45),
    Surface=Color3.fromRGB(22, 22, 22), SurfaceHighlight=Color3.fromRGB(38, 38, 38),
    Accent1=Color3.fromRGB(255, 255, 255), Accent2=Color3.fromRGB(220, 220, 220),
    TextPrimary=Color3.fromRGB(240, 240, 240), TextSecondary=Color3.fromRGB(140, 140, 140),
    Success=Color3.fromRGB(211, 211, 211), Error=Color3.fromRGB(117, 117, 117),
}

_G._TekSliderDragging = false

local function MakeDraggable(handle, target, saveKey)

    -- same delta-drag as the main guis: no GetMouseLocation snap, no RenderStepped jitter
    local dragging, dStart, pStart = false, nil, nil

    local function stopDrag()
        if not dragging then return end
        dragging = false
        if saveKey then
            -- Use Position offsets (not AbsolutePosition) to avoid upward creep.
            local xo = target.Position.X.Offset
            local yo = target.Position.Y.Offset
            if not Config.TekPositions then Config.TekPositions = {} end
            Config.TekPositions[saveKey] = {xs = 0, xo = xo, ys = 0, yo = yo}
            local ps = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
            if ps then
                if not Config.Positions then Config.Positions = {} end
                Config.Positions[saveKey] = {X = xo / math.max(1, ps.X), Y = yo / math.max(1, ps.Y)}
            end
            SaveConfig()
        end
    end

    handle.InputBegan:Connect(function(input)
        if Config.UILocked then return end
        if _G._TekSliderDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart = input.Position
            pStart = target.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging or Config.UILocked or _G._TekSliderDragging or _G._TekPanelDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dStart
            target.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
        end
    end)
end
local function MakeBottomDragHandle(target, saveKey)
    local handle = Instance.new("TextButton")
    handle.Name = "BottomDragHandle"
    handle.Size = UDim2.new(1, -24, 0, 11)
    handle.Position = UDim2.new(0, 12, 1, -13)
    handle.BackgroundTransparency = 0.35
    handle.BackgroundColor3 = Theme.SurfaceHighlight
    handle.BorderSizePixel = 0
    handle.Text = "•••"
    handle.TextColor3 = Theme.Dim
    handle.TextSize = 8
    handle.Font = Enum.Font.GothamBold
    handle.AutoButtonColor = false
    handle.Active = true
    handle.ZIndex = 50
    handle.Parent = target
    corner(handle, 6)
    MakeDraggable(handle, target, saveKey)
    return handle
end
local function rememberPosition(name, frame)
    if not name or not frame then return end
    if not Config.TekPositions then Config.TekPositions = {} end
    -- Save logical Position offsets (not AbsolutePosition) so panels don't creep
    -- upward on mobile / IgnoreGuiInset screens after each drag or reload.
    local xo = frame.Position.X.Offset
    local yo = frame.Position.Y.Offset
    Config.TekPositions[name] = {xs = 0, xo = xo, ys = 0, yo = yo}
    local ps = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if ps then
        if not Config.Positions then Config.Positions = {} end
        Config.Positions[name] = {X = xo / math.max(1, ps.X), Y = yo / math.max(1, ps.Y)}
    end
    SaveConfig()
end
local function applySavedPosition(name, frame)
    if not name or not frame then return end
    local d = Config.TekPositions and Config.TekPositions[name]
    if d then
        frame.Position = UDim2.fromOffset(d.xo or 0, d.yo or 0)
        return
    end
    local p = Config.Positions and Config.Positions[name]
    if p then
        local vp = workspace.CurrentCamera.ViewportSize
        frame.Position = UDim2.fromOffset(
            math.floor((p.X or 0) * vp.X),
            math.floor((p.Y or 0) * vp.Y)
        )
    end
end
Config.StealMode = "Priority"
Config.StealHighest = false
Config.StealPriority = true
Config.StealNearest = false

if Config.AutoStealEnabled == nil then Config.AutoStealEnabled = true end
if Config.SkipStolenTarget == nil then Config.SkipStolenTarget = true end
_G.TekSkipStolenTarget = Config.SkipStolenTarget ~= false
-- Migrate the old Extras-only radius to Rose's Auto Grab radius.
if Config.AutoGrabRadius == nil or Config.AutoGrabRadius == 60 then Config.AutoGrabRadius = 95 end
if Config.AntiRagdoll == nil then Config.AntiRagdoll = true end
if Config.AutoTPOnSteal == nil then Config.AutoTPOnSteal = true end
Config.TpSettings = Config.TpSettings or {}
Config.TpSettings.TpOnLoad = true
if not Config.Positions then Config.Positions = DefaultConfig.Positions end
if not Config.Visibilities then Config.Visibilities = DefaultConfig.Visibilities end
for _, n in ipairs({"TP Settings","Priority List"}) do
    if Config.Visibilities[n] == nil then Config.Visibilities[n] = DefaultConfig.Visibilities[n] end
end

do
    local setclip = (typeof(setclipboard) == "function" and setclipboard)
        or (typeof(toclipboard) == "function" and toclipboard)
        or (typeof(set_clipboard) == "function" and set_clipboard)
    local log = getgenv().__Tek_KickLog or {}
    getgenv().__Tek_KickLog = log
    local MAX = 40
    local function push(line)
        log[#log + 1] = string.format("[%.2f] %s", os.clock(), tostring(line))
        while #log > MAX do table.remove(log, 1) end
        _G.__Tek_LastAction = line
    end
    _G.Tek_Trace = push
    local function dump(reason)
        local body = "KICK/REMOOVE reason=" .. tostring(reason) .. "\nLAST=" .. tostring(_G.__Tek_LastAction) .. "\n----\n" .. table.concat(log, "\n")
        print("[Tek_KICKTRACE]\n" .. body)
        if setclip then pcall(setclip, body) end
    end
    _G.Tek_DumpKickTrace = dump
    pcall(function()
        LocalPlayer.AncestryChanged:Connect(function(_, parent)
            if parent == nil then dump("AncestryChanged(nil)") end
        end)
    end)
end


local _xchan
local _class
local _lastSweep = 0
local _dirty = true
local SWEEP_GAP = 0.5

local function _classTable()
    if _class then return _class end
    local ok, c = pcall(function()
        return require(game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Synchronizer")
            :WaitForChild("Channel"))
    end)
    if ok and type(c) == "table" then _class = c end
    return _class
end

local function _sweep()
    local cls = _classTable()
    if not cls or type(getgc) ~= "function" then
        _G.TekSyncDiag = cls and "getgc unavailable" or "Channel class not found"
        return
    end
    _lastSweep = os.clock()
    _dirty = false
    local reg, n = {}, 0
    local gc = getgc(true)
    for i = 1, #gc do
        local v = gc[i]
        if type(v) == "table" and getmetatable(v) == cls then
            local idx = rawget(v, "Index")
            if idx ~= nil then reg[idx] = v; n = n + 1 end
        end
    end
    _xchan = reg
    _G.TekSyncDiag = string.format("heap identity - %d channels", n)
end

local function _needsSweep()
    if not _xchan then return true end
    if _dirty then return true end
    local pl = workspace:FindFirstChild("Plots")
    if pl then
        for _, p in ipairs(pl:GetChildren()) do
            if _xchan[p.Name] == nil then return true end
        end
    end
    return false
end

do
    local pl = workspace:FindFirstChild("Plots")
    if pl then
        pl.ChildAdded:Connect(function() _dirty = true end)
        pl.ChildRemoved:Connect(function() _dirty = true end)
    end
end

local function _chans()
    if _needsSweep() and (os.clock() - _lastSweep) > SWEEP_GAP then _sweep() end
    return _xchan
end

_G.TekSyncAll = function() return _chans() end
_G.TekSyncGet = function(idx)
    local t = _chans()
    if not t or idx == nil then return nil end
    local ok, cd = pcall(rawget, t, idx)
    if ok and type(cd) == "table" then return cd end
    local ok2, cd2 = pcall(function() return t[idx] end)
    if ok2 and type(cd2) == "table" then return cd2 end
    return nil
end
_G._tekRawCT = function(plotName)
    local c = _G.TekSyncGet(plotName)
    if not c then return nil end
    return rawget(c, "CacheTable")
end
_G.sProp = function(ch, key)
    if type(ch) ~= "table" or key == nil then return nil end
    local ct = rawget(ch, "CacheTable")
    if type(ct) ~= "table" then
        local okC, c2 = pcall(function() return ch.CacheTable end)
        if okC and type(c2) == "table" then ct = c2 end
    end
    if type(ct) ~= "table" then return nil end
    local v = rawget(ct, key)
    if v ~= nil then return v end
    local okV, v2 = pcall(function() return ct[key] end)
    if okV then return v2 end
    return nil
end
local _AD, _MD, _TD
local function _data()
    if _AD then return true end
    local ok = pcall(function()
        local d = game:GetService("ReplicatedStorage"):WaitForChild("Datas")
        _AD = require(d:WaitForChild("Animals"))
        _MD = require(d:WaitForChild("Mutations"))
        _TD = require(d:WaitForChild("Traits"))
    end)
    return ok and _AD ~= nil
end
_G._tekGen = function(index, mutation, traits)
    if not _data() then return 0 end
    local info = _AD[index]
    if not info or not info.Generation then return 0 end
    local mult = 1
    if mutation and mutation ~= "None" and mutation ~= "" then
        local m = _MD[mutation]
        if m and m.Modifier then mult = mult + m.Modifier end
    end
    if type(traits) == "table" then
        for _, tr in ipairs(traits) do
            local t = _TD[tr]
            if t and t.MultiplierModifier then mult = mult + t.MultiplierModifier end
        end
    end
    return info.Generation * mult
end
_G._tekAnimShim = setmetatable({
    GetGeneration = function(_, index, mutation, traits)
        return _G._tekGen(index, mutation, traits)
    end
}, {
    __index = function(_, k)
        local ok, real = pcall(function()
            return require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))
        end)
        if ok and type(real) == "table" then return rawget(real, k) end
        return nil
    end
})
_G.stealthGet = function(n) return _G.TekSyncGet(n) end
_G.SyncInt = {_cache = {}, _data = nil}

_G.Tek_ChannelGet = _G.sProp
_G.Tek_GetPlotChannel = function(name) return _G.TekSyncGet(tostring(name)) end
_G.Tek_AllCachedChannels = function() return _G.TekSyncAll() or {} end
_G.Tek_SynStatus = function()
    local t = _G.TekSyncAll(); local n = 0
    if type(t) == "table" then for _ in pairs(t) do n = n + 1 end end
    return {hookedReq = true, hookedGet = (_xchan ~= nil), channels = n}
end

task.spawn(function()
    local plots
    local t0 = os.clock()
    repeat
        plots = Workspace:FindFirstChild("Plots")
        if not plots then task.wait(0.05) end
    until plots or (os.clock() - t0) > 25
    if not plots then return end
    local done, warmT0 = {}, os.clock()
    while (os.clock() - warmT0) < 15 do
        local kids = plots:GetChildren()
        local pending = false
        for _, plot in ipairs(kids) do
            if not done[plot.Name] then
                local ch = _G.TekSyncGet and _G.TekSyncGet(plot.Name)
                if ch then
                    pcall(function() if ch.Get then ch:Get("AnimalList"); ch:Get("Owner") end end)
                    local al = _G.sProp and _G.sProp(ch, "AnimalList")
                    if al ~= nil then done[plot.Name] = true else pending = true end
                else
                    pending = true
                end
            end
        end
        if not pending and #kids > 0 then break end
        task.wait(0.05)
    end
end)

task.spawn(function()
    if not Workspace.StreamingEnabled then return end
    local plots
    local t0 = os.clock()
    repeat plots = Workspace:FindFirstChild("Plots"); if not plots then task.wait(0.1) end
    until plots or (os.clock() - t0) > 25
    if not plots then return end
    local function plotPos(plot)
        local ok, pv = pcall(function() return plot:GetPivot().Position end)
        if ok and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    local pending = 0
    for _, plot in ipairs(plots:GetChildren()) do
        local pos = plotPos(plot)
        if pos then
            pending = pending + 1
            task.spawn(function()
                pcall(function() LocalPlayer:RequestStreamAroundAsync(pos) end)
                pending = pending - 1
            end)
        end
    end
    local sw = os.clock()
    while pending > 0 and os.clock() - sw < 10 do task.wait(0.05) end
end)

local oldTek = PlayerGui:FindFirstChild("TekPanels") or PlayerGui:FindFirstChild("TekPanels")
if oldTek then oldTek:Destroy() end
local gui_sg = Instance.new("ScreenGui")
gui_sg.Name = "TekPanels"; gui_sg.ResetOnSpawn = false; gui_sg.IgnoreGuiInset = true
gui_sg.DisplayOrder = 100000000; gui_sg.Parent = PlayerGui
local gui = Instance.new("Frame"); gui.Name = "DetachedPanelsRoot"; gui.BackgroundTransparency = 1
gui.Size = UDim2.new(1,0,1,0); gui.Parent = gui_sg

local GlobalUIScaleVal = 0.48
_G.GlobalUIScaleVal = GlobalUIScaleVal
local function registerScreenGui(sg)
    if not sg then return nil end
    local scaleObj = sg:FindFirstChild("Tek_GlobalScale")
    if not scaleObj then
        scaleObj = Instance.new("UIScale")
        scaleObj.Name = "Tek_GlobalScale"
        scaleObj.Parent = sg
    end
    scaleObj.Scale = GlobalUIScaleVal
    -- Keep legacy master frame for compatibility with older call sites
    local master = sg:FindFirstChild("Tek_MasterFrame")
    if not master then
        master = Instance.new("Frame")
        master.Name = "Tek_MasterFrame"
        master.BackgroundTransparency = 1
        master.BorderSizePixel = 0
        master.Size = UDim2.new(1, 0, 1, 0)
        master.Parent = sg
    end
    return master
end
registerScreenGui(gui_sg)

-- ================= UI SIZE ENGINE (driven by the Config panel slider) =================
-- Puts one UIScale on every top-level panel of every Tek* ScreenGui (PlayerGui,
-- gethui and CoreGui), so each panel grows/shrinks around its own anchor point.
-- Full-screen transparent holders (DetachedPanelsRoot etc.) are skipped and
-- their child panels are scaled instead, so panels don't fly off-screen.
do
    local MIN_MULT, MAX_MULT = 0.5, 2.5
    local uiMult = math.clamp(tonumber(Config.UISizeMult) or 1, MIN_MULT, MAX_MULT)
    local scales = {}
    local attachDrag

    local function scaleOf(us)
        return (tonumber(us:GetAttribute("TekUSBase")) or 1) * uiMult
    end

    -- ---------- easy mobile drag for every panel ----------
    -- Drag a panel from ANY non-control spot (title, labels, background, margins).
    -- Buttons, text boxes, scroll lists and sliders keep working normally.
    -- Only the finger that started the drag moves the panel (the joystick or a
    -- 2nd finger can't hijack it), a 6px dead-zone keeps taps from nudging it,
    -- it respects Lock All GUI, and the spot is saved for next time.
    if type(Config.TekPanelPos) ~= "table" then Config.TekPanelPos = {} end
    local DRAG_THRESHOLD = 6
    local ctrlTouch = setmetatable({}, { __mode = "k" })
    local function markCtrl(i) ctrlTouch[i] = os.clock() end
    local function hookCtrl(o)
        if o:IsA("GuiButton") or o:IsA("TextBox") or o:IsA("ScrollingFrame") then
            o.InputBegan:Connect(markCtrl)
        end
    end
    local drag = nil
    local keyCount = {}

    local function savePanelPos(panel, key)
        local p, a = panel.Position, panel.AnchorPoint
        Config.TekPanelPos[key] = {
            xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, ax = a.X, ay = a.Y,
        }
        pcall(SaveConfig)
    end

    local function restorePanelPos(panel, key)
        local function apply()
            local s = Config.TekPanelPos[key]
            if type(s) ~= "table" or not panel.Parent then return end
            if drag and drag.panel == panel then return end
            local oldA, oldP = panel.AnchorPoint, panel.Position
            pcall(function()
                panel.AnchorPoint = Vector2.new(tonumber(s.ax) or oldA.X, tonumber(s.ay) or oldA.Y)
                panel.Position = UDim2.new(tonumber(s.xs) or 0, tonumber(s.xo) or 0, tonumber(s.ys) or 0, tonumber(s.yo) or 0)
            end)
            task.delay(0.05, function()
                -- never park a panel somewhere you can't reach it (e.g. tablet -> phone)
                local cam = workspace.CurrentCamera
                local vp = cam and cam.ViewportSize
                if not vp or not panel.Parent then return end
                local ap, as = panel.AbsolutePosition, panel.AbsoluteSize
                if as.X <= 1 or as.Y <= 1 then return end
                local m = 30
                if ap.X > vp.X - m or ap.Y > vp.Y - m or ap.X + as.X < m or ap.Y + as.Y < m then
                    pcall(function() panel.AnchorPoint = oldA; panel.Position = oldP end)
                end
            end)
        end
        apply()
        task.delay(0.6, apply)   -- after the panel's own restore code has run
        task.delay(2, apply)
    end

    attachDrag = function(panel)
        if panel:IsA("GuiButton") or panel.BackgroundTransparency >= 0.95 then return end
        if panel:GetAttribute("TekDragDone") then return end
        panel:SetAttribute("TekDragDone", true)
        local sg = panel:FindFirstAncestorOfClass("ScreenGui")
        local base = (sg and sg.Name or "?") .. "/" .. panel.Name
        keyCount[base] = (keyCount[base] or 0) + 1
        local key = base .. "#" .. keyCount[base]
        pcall(function() panel.Active = true end) -- touches on a panel don't spin the camera
        for _, o in ipairs(panel:GetDescendants()) do hookCtrl(o) end
        panel.DescendantAdded:Connect(hookCtrl)
        panel.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            if drag and drag.active then return end
            drag = {
                panel = panel, key = key, input = i, start = i.Position, base = panel.Position,
                mouse = i.UserInputType == Enum.UserInputType.MouseButton1,
                t0 = os.clock(), active = false, blocked = false,
            }
        end)
        restorePanelPos(panel, key)
    end

    UIS.InputChanged:Connect(function(i)
        local d = drag
        if not d or d.blocked then return end
        if i ~= d.input and not (d.mouse and i.UserInputType == Enum.UserInputType.MouseMovement) then return end
        local delta = i.Position - d.start
        if not d.active then
            if Vector2.new(delta.X, delta.Y).Magnitude < DRAG_THRESHOLD then return end
            local ct = ctrlTouch[d.input]
            if Config.UILocked or _G._TekSliderDragging or (ct and ct >= d.t0 - 0.1) or not d.panel.Parent then
                d.blocked = true -- started on a button/slider/list: let that control handle it
                return
            end
            d.active = true
            _G._TekPanelDragging = true
        end
        d.panel.Position = UDim2.new(d.base.X.Scale, d.base.X.Offset + delta.X, d.base.Y.Scale, d.base.Y.Offset + delta.Y)
    end)

    UIS.InputEnded:Connect(function(i)
        local d = drag
        if not d then return end
        if i ~= d.input and not (d.mouse and i.UserInputType == Enum.UserInputType.MouseButton1) then return end
        drag = nil
        if d.active then
            task.delay(0.15, function() _G._TekPanelDragging = false end)
        end
        -- save whenever this touch moved the panel (our drag or the panel's own header drag)
        task.delay(0.1, function()
            if d.panel.Parent and d.panel.Position ~= d.base then savePanelPos(d.panel, d.key) end
        end)
    end)

    local adoptChild
    adoptChild = function(c)
        if not c or not c.Parent or not c:IsA("GuiObject") then return end
        if c:GetAttribute("TekUSDone") then return end
        c:SetAttribute("TekUSDone", true)
        local sz = c.Size
        if sz.X.Scale >= 0.99 and sz.Y.Scale >= 0.99 and c.BackgroundTransparency >= 0.99 then
            for _, k in ipairs(c:GetChildren()) do adoptChild(k) end
            c.ChildAdded:Connect(function(k) task.defer(adoptChild, k) end)
            return
        end
        -- reuse an existing UIScale (e.g. Tek_CompactScale) so they don't fight
        local us = c:FindFirstChildOfClass("UIScale")
        if not us then
            us = Instance.new("UIScale")
            us.Name = "Tek_UserScale"
            us:SetAttribute("TekUSBase", 1)
            us.Parent = c
        elseif us:GetAttribute("TekUSBase") == nil then
            us:SetAttribute("TekUSBase", us.Scale)
        end
        scales[us] = true
        us.Scale = scaleOf(us)
        if attachDrag then pcall(attachDrag, c) end
    end

    local function adoptGui(sg)
        if not sg or not sg:IsA("ScreenGui") then return end
        if string.sub(sg.Name, 1, 3) ~= "Tek" then return end
        if sg:GetAttribute("TekUSDone") then return end
        sg:SetAttribute("TekUSDone", true)
        for _, c in ipairs(sg:GetChildren()) do adoptChild(c) end
        sg.ChildAdded:Connect(function(c) task.defer(adoptChild, c) end)
    end

    local hosts, seenHost = {}, {}
    local function addHost(h)
        if h and not seenHost[h] then seenHost[h] = true; hosts[#hosts + 1] = h end
    end
    addHost(PlayerGui)
    pcall(function() if gethui then addHost(gethui()) end end)
    pcall(function() addHost(game:GetService("CoreGui")) end)
    for _, h in ipairs(hosts) do
        pcall(function()
            for _, sg in ipairs(h:GetChildren()) do pcall(adoptGui, sg) end
            h.ChildAdded:Connect(function(sg)
                task.defer(function() pcall(adoptGui, sg) end)
            end)
        end)
    end

    local function setMult(m)
        uiMult = math.clamp(tonumber(m) or 1, MIN_MULT, MAX_MULT)
        uiMult = math.floor(uiMult * 100 + 0.5) / 100
        for us in pairs(scales) do
            if us.Parent then us.Scale = scaleOf(us) else scales[us] = nil end
        end
        Config.UISizeMult = uiMult
        return uiMult
    end

    _G.Tek_UISizeRange = { MIN_MULT, MAX_MULT }
    _G.Tek_GetUISize = function() return uiMult end
    _G.Tek_SetUISize = function(m, save)
        local v = setMult(m)
        if save then pcall(SaveConfig) end
        return v
    end
end

local function makeOneWay(plat)
    if not plat then return end
    local rsConn
    local lastY = nil
    rsConn = game:GetService("RunService").Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
            if isMovingUp then
                plat.CanCollide = false
            else
                if currentY > plat.Position.Y + 0.1 then
                    plat.CanCollide = true
                else
                    plat.CanCollide = false
                end
            end
            lastY = currentY
        end
    end)
end
corner = function(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=o; return c end
tw = function(o,p,t) TweenService:Create(o,TweenInfo.new(t or 0.14,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p):Play() end
addOutline = function(f) local o=Instance.new("UIStroke"); o.Color=Color3.fromRGB(60, 60, 60); o.Thickness=1; o.Transparency=0.3; o.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; o.Parent=f; return o end
makeDraggable = function(frame, handle, saveName)
    -- same delta-drag as the main guis: no GetMouseLocation snap, no RenderStepped jitter
    local dragging, dStart, pStart = false, nil, nil
    local function stopDrag()
        if not dragging then return end
        dragging = false
        task.defer(function()
            local abs = frame.AbsolutePosition
            frame.Position = UDim2.fromOffset(math.floor(abs.X), math.floor(abs.Y))
            if saveName then rememberPosition(saveName, frame) end
        end)
    end
    handle.InputBegan:Connect(function(input)
        if Config.UILocked then return end
        if _G._TekSliderDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart = input.Position
            pStart = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging or Config.UILocked or _G._TekSliderDragging or _G._TekPanelDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dStart
            frame.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
        end
    end)
end
makeResizable = function(frame, minSize, panelName)
    local h = Instance.new("TextButton")
    h.Size = UDim2.new(0, 16, 0, 16)
    h.Position = UDim2.new(1, -16, 1, -16)
    h.BackgroundTransparency = 1
    h.Text = "+"
    h.TextColor3 = Theme.AccentLight or Color3.new(1, 1, 1)
    h.TextSize = 8
    h.ZIndex = 100
    h.Parent = frame
    local dragging, dragInput, dragStart, startSize = false, nil, nil, nil
    local function stopResize()
        if not dragging then return end
        dragging = false
        dragInput = nil
        if panelName then
            if not Config.sizes then Config.sizes = {} end
            Config.sizes[panelName] = {x = frame.Size.X.Offset, y = frame.Size.Y.Offset}
            SaveConfig()
        end
    end
    h.InputBegan:Connect(function(input)
        if Config.UILocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = frame.AbsoluteSize
            dragInput = input
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if conn then conn:Disconnect() end
                    stopResize()
                end
            end)
        end
    end)
    h.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopResize()
        end
    end)
    h.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopResize()
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and not Config.UILocked and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - dragStart
            local nx = math.max(minSize.X.Offset, startSize.X + d.X)
            local ny = math.max(minSize.Y.Offset, startSize.Y + d.Y)
            frame.Size = UDim2.new(0, nx, 0, ny)
        end
    end)
end
function makeHeader(f,t,isMain) local h=Instance.new("TextButton"); h.Size=UDim2.new(1,0,0,26); h.BackgroundTransparency=1; h.Text=""; h.AutoButtonColor=false; h.Parent=f
    local parts={}; for s in string.gmatch(t,"([^\n]+)") do table.insert(parts,s) end
    if isMain then local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-50,0,15); l.Position=UDim2.new(0,13,0,5); l.BackgroundTransparency=1; l.Text=parts[1] or "the isle"; l.TextColor3=Theme.Text; l.Font=Enum.Font.GothamBlack; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.Active=false; l.Parent=h
    else local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-58,0,10); l.Position=UDim2.new(0,12,0,4); l.BackgroundTransparency=1; l.Text=parts[1] or "the isle"; l.TextColor3=Theme.Text; l.Font=Enum.Font.GothamBlack; l.TextSize=9; l.TextXAlignment=Enum.TextXAlignment.Center; l.Active=false; l.Parent=h
        local s=Instance.new("TextLabel"); s.Size=UDim2.new(1,-58,0,8); s.Position=UDim2.new(0,12,0,14); s.BackgroundTransparency=1; s.Text=parts[2] or ""; s.TextColor3=Theme.Dim; s.Font=Enum.Font.GothamMedium; s.TextSize=7; s.TextXAlignment=Enum.TextXAlignment.Center; s.Active=false; s.Parent=h end
    local d=Instance.new("Frame"); d.Size=UDim2.new(1,-24,0,1); d.Position=UDim2.new(0,12,0,25); d.BackgroundColor3=Color3.fromRGB(60, 60, 60); d.BackgroundTransparency=isMain and 0.5 or 0.3; d.BorderSizePixel=0; d.Parent=f

    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Size = UDim2.new(0, 24, 0, 24)
    collapseBtn.Position = UDim2.new(1, -28, 0, 9)
    collapseBtn.BackgroundColor3 = Theme.SoftButton
    collapseBtn.BackgroundTransparency = 0.3
    collapseBtn.Text = "▼"
    collapseBtn.TextColor3 = Theme.AccentLight
    collapseBtn.Font = Enum.Font.GothamBold
    collapseBtn.TextSize = 7
    collapseBtn.AutoButtonColor = false
    collapseBtn.ZIndex = 60
    collapseBtn.Parent = h
    corner(collapseBtn, 5)
    local _panelCollapsed = false
    local _panelFullSize = f.Size
    collapseBtn.MouseButton1Click:Connect(function()
        _panelCollapsed = not _panelCollapsed
        if _panelCollapsed then
            _panelFullSize = f.Size
            for _, child in ipairs(f:GetChildren()) do
                pcall(function() if child ~= h then child.Visible = false end end)
            end
            f.Size = UDim2.new(_panelFullSize.X.Scale, _panelFullSize.X.Offset, 0, 26)
            collapseBtn.Text = "▶"
        else
            f.Size = _panelFullSize
            for _, child in ipairs(f:GetChildren()) do
                pcall(function() child.Visible = true end)
            end
            collapseBtn.Text = "▼"
        end
    end)
    makeDraggable(f,h,t); return h end
function makeQuickPanel(t,size,pos,saveKey) local f=Instance.new("Frame"); f.Size=size; f.Position=pos; f.BackgroundColor3=Theme.Background; f.BackgroundTransparency=0.04; f.BorderSizePixel=0; f.ClipsDescendants=true; f.Parent=gui; f.Active=true; corner(f,12); addOutline(f); makeHeader(f,t,false); MakeBottomDragHandle(f,saveKey or t)
    local body=Instance.new("ScrollingFrame"); body.Size=UDim2.new(1,-12,1,-32); body.Position=UDim2.new(0,6,0,30); body.BackgroundTransparency=1; body.BorderSizePixel=0; body.ScrollBarThickness=3; body.ScrollBarImageColor3=Theme.Accent; body.CanvasSize=UDim2.new(0,0,0,0); body.Active=true; body.Parent=f
    local lay=Instance.new("UIListLayout"); lay.Padding=UDim.new(0,6); lay.Parent=body
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() body.CanvasSize=UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+10) end);
    if Config.sizes and Config.sizes[t] then f.Size = UDim2.new(0, Config.sizes[t].x, 0, Config.sizes[t].y) end
    makeResizable(f, UDim2.new(0, 150, 0, 150), t); return f,body end
function makeQuickButton(parent,text,callback,bg) local b=Instance.new("TextButton"); b.Size=UDim2.new(1,-4,0,22); b.BackgroundColor3=bg or Theme.SoftButton; b.BackgroundTransparency=0.02; b.Text=text; b.TextColor3=Theme.Text; b.Font=Enum.Font.GothamBold; b.TextSize=9; b.AutoButtonColor=false; b.Parent=parent; corner(b,6)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=bg or Theme.SoftButtonHover},0.12) end); b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=bg or Theme.SoftButton},0.12) end)
    b.MouseButton1Click:Connect(function() if callback then callback() end end); return b end
function makeQuickSlider(parent,text,min,max,default,callback,suffix,step) local holder=Instance.new("Frame"); holder.Size=UDim2.new(1,-4,0,31); holder.BackgroundTransparency=1; holder.Parent=parent
    step = step or 0.1
    local stepMult = math.max(1, math.floor((1 / step) + 0.001))
    local function roundVal(v) return math.floor(v * stepMult + 0.5) / stepMult end
    local label=Instance.new("TextLabel"); label.Size=UDim2.new(1,0,0,16); label.Position=UDim2.new(0,4,0,0); label.BackgroundTransparency=1; label.Text=text..": "..tostring(roundVal(default))..(suffix or ""); label.TextColor3=Theme.Text; label.Font=Enum.Font.GothamMedium; label.TextSize=7; label.TextXAlignment=Enum.TextXAlignment.Left; label.Parent=holder
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(1,-10,0,6); bar.Position=UDim2.new(0,4,0,16); bar.BackgroundColor3=Theme.SliderBg; bar.BorderSizePixel=0; bar.Parent=holder; corner(bar,10)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new(math.clamp((default-min)/(max-min),0,1),0,1,0); fill.BackgroundColor3=Theme.Accent; fill.BorderSizePixel=0; fill.Parent=bar; corner(fill,10)
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,14,0,14); knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new(math.clamp((default-min)/(max-min),0,1),0,0.5,0); knob.Name = "AccentSliderKnob"; knob.BackgroundColor3=Theme.Accent1; knob.BorderSizePixel=0; knob.Parent=bar; corner(knob,20)
    local dragging=false
    local function update(x) local rel=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1); local v=roundVal(min+(max-min)*rel); fill.Size=UDim2.new(rel,0,1,0); knob.Position=UDim2.new(rel,0,0.5,0); label.Text=text..": "..tostring(v)..(suffix or ""); if callback then callback(v) end end
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; _G._TekSliderDragging=true; update(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false; _G._TekSliderDragging=false end end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end end)
    local function setVal(v, silent)
        v = roundVal(math.clamp(v, min, max))
        local rel = (v - min) / (max - min)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        label.Text = text..": "..tostring(v)..(suffix or "")
        if callback and not silent then callback(v) end
    end
    return {Set = setVal}
end

-- CAMP removed: keep the legacy block unreachable so it cannot create its panel
-- or register player-list connections in this hub version.
if false then
task.spawn(function()
    local waitUntil = os.clock() + 15
    while type(_G.TekCamp) ~= "table" and os.clock() < waitUntil do task.wait(0.1) end

    local panel, body = makeQuickPanel(
        "CAMP\nBASE TARGET",
        UDim2.fromOffset(235, 310),
        UDim2.new(0, 20, 0.5, -155),
        "CAMP"
    )
    panel.Name = "TekCampPanel"
    panels["CAMP"] = panel
    panel.Visible = Config.Visibilities["CAMP"] ~= false

    local statusBtn = makeQuickButton(body, "CAMP: idle", function()
        local camp = _G.TekCamp
        if camp and camp.active and type(camp.stop) == "function" then camp.stop() end
    end, Theme.Panel)
    statusBtn.Name = "TekCampStatus"
    statusBtn.TextSize = 11

    local rows = {}
    local function clearRows()
        for _, row in ipairs(rows) do pcall(function() row:Destroy() end) end
        table.clear(rows)
    end

    local function rebuild()
        clearRows()
        local list = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then list[#list + 1] = plr end
        end
        table.sort(list, function(a, b)
            return (a.DisplayName or a.Name):lower() < (b.DisplayName or b.Name):lower()
        end)
        for _, plr in ipairs(list) do
            local label = plr.DisplayName == plr.Name
                and plr.Name or (plr.DisplayName .. "  @" .. plr.Name)
            local row = makeQuickButton(body, label, function()
                local camp = _G.TekCamp
                if not camp then return end
                if camp.active and camp.target == plr.Name then
                    if type(camp.stop) == "function" then camp.stop() end
                elseif type(camp.start) == "function" then
                    local ok, why = camp.start(plr.Name)
                    if not ok then
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Base CAMP", Text = tostring(why or "failed"), Duration = 4,
                            })
                        end)
                    end
                end
            end)
            row.Name = "TekCampPlayer_" .. plr.Name
            row.TextSize = 11
            row.TextTruncate = Enum.TextTruncate.AtEnd
            row:SetAttribute("CampPlayer", plr.Name)
            rows[#rows + 1] = row
        end
    end

    Players.PlayerAdded:Connect(function() task.defer(rebuild) end)
    Players.PlayerRemoving:Connect(function() task.defer(rebuild) end)
    rebuild()

    while panel.Parent do
        local camp = _G.TekCamp
        local active = camp and camp.active
        statusBtn.Text = active
            and ("STOP CAMP  •  " .. tostring(camp.status or camp.target or "active"))
            or "CAMP: select a player"
        statusBtn.BackgroundColor3 = active and Theme.Accent or Theme.Panel
        statusBtn.TextColor3 = active and Color3.new(0, 0, 0) or Theme.Text
        for _, row in ipairs(rows) do
            local selected = active and row:GetAttribute("CampPlayer") == camp.target
            row.BackgroundColor3 = selected and Theme.Accent or Theme.SoftButton
            row.TextColor3 = selected and Color3.new(0, 0, 0) or Theme.Text
        end
        task.wait(0.2)
    end
end)
end




-- Runway Auto Buy TEST: embedded supplied module, loaded on first enable.
local function createRunwayAutoBuy()
--!nocheck
-- Standalone runway auto-buy, extracted from Odyssey Auto Steal Spam.
-- Load this file once. It returns the auto-buy API; buying starts only
-- after set_enabled(true). See README.txt in this folder for integration.
-- Every @src/@libs dependency below is embedded. require(Instance) calls load
-- data/Observers/NumberUtils from the game, never the game Net or Synchronizer.

local function identity(callback)
    return callback
end
local LPH_JIT_MAX = identity
local LPH_NO_VIRTUALIZE = identity
local LPH_OBFUSCATED = false
local module_factories = {}
local module_cache = {}
local module_loading = {}

local function bundle_require(module_id)
    module_id = module_id:gsub("^@libs/", "@src/libs/")
    if module_cache[module_id] ~= nil then
        return module_cache[module_id]
    end
    assert(not module_loading[module_id], "Circular standalone dependency: " .. module_id)
    local factory = assert(module_factories[module_id], "Missing standalone dependency: " .. module_id)
    module_loading[module_id] = true
    local ok, result = pcall(factory)
    module_loading[module_id] = nil
    if not ok then
        error(result, 0)
    end
    module_cache[module_id] = result
    return result
end

-- Source: @src/standalone/auto_buy_runway_spam
module_factories["@src/standalone/auto_buy_runway_spam"] = function()
-- Runtime for the test Extras; uses the supplied tracker and purchase module.
local runway_tracker = bundle_require("@src/modules/shared/runway_tracker")
local runway_util = bundle_require("@src/utils/runway")
local debug_mode = bundle_require("@src/libs/debug_mode")
local local_player = game:GetService("Players").LocalPlayer
local run_service = game:GetService("RunService")
local auto_buy = {}
local config = {enabled=false,purchase_distance=20,spam_attempts=1,target_mode="highest_value",target_names={},follow=true,hover=9}
local connection, current_target, manual_target_uid, target_provider
local follow_lock, follow_character, body_position
local followProgress
local resumeFollowAt, generation, stepBusy = 0, 0, false
local watchedHumanoid, stateConnection, removingConnection, ragdollConnection
local recoveringStates = {
    [Enum.HumanoidStateType.Physics]=true,
    [Enum.HumanoidStateType.Ragdoll]=true,
    [Enum.HumanoidStateType.FallingDown]=true,
    [Enum.HumanoidStateType.GettingUp]=true,
    [Enum.HumanoidStateType.PlatformStanding]=true,
}
local function isRagdolled(humanoid)
    local untilTime=tonumber(local_player:GetAttribute("RagdollEndTime")) or 0
    return untilTime>workspace:GetServerTimeNow()
        or (humanoid and (humanoid.PlatformStand or recoveringStates[humanoid:GetState()])) == true
end
local diagnostics = {phase="off",tracked=0,attempts=0,sent=0}
local function releaseFollow()
    followProgress=nil
    if body_position then body_position:Destroy();body_position=nil end
    diagnostics.following=false
end
local function unlockFollow()
    follow_lock=nil
    follow_character=nil
    releaseFollow()
end
function auto_buy.suspend_follow(seconds)
    generation+=1
    resumeFollowAt=math.max(resumeFollowAt,os.clock()+(seconds or 0.75))
    current_target=nil
    unlockFollow()
end
local function watchHumanoid(humanoid)
    if watchedHumanoid==humanoid then return end
    if stateConnection then stateConnection:Disconnect();stateConnection=nil end
    watchedHumanoid=humanoid
    if humanoid then
        stateConnection=humanoid.StateChanged:Connect(function()
            if config.enabled and isRagdolled(humanoid) then auto_buy.suspend_follow() end
        end)
    end
end
local function pausedForRecovery(character,humanoid)
    if _G.Tek_IsResetting or _G.__elysiumResetBusy then
        auto_buy.suspend_follow();diagnostics.phase="paused_reset";return true
    end
    if local_player.Character~=character or not humanoid or humanoid.Health<=0 then
        auto_buy.suspend_follow();diagnostics.phase="no_character";return true
    end
    if isRagdolled(humanoid) then
        auto_buy.suspend_follow();diagnostics.phase="paused_ragdoll";return true
    end
    if os.clock()<resumeFollowAt then
        unlockFollow();diagnostics.phase="recovering_ragdoll";return true
    end
    return false
end
local function alreadyBought(animal)
    return runway_tracker.is_animal_following_us(animal.uuid or animal.uid)
end
local function followPosition(position,hrp)
    if not config.follow then releaseFollow();followProgress=nil;return true end
    local character=local_player.Character
    local goal=position+Vector3.new(0,config.hover,0)
    local delta=goal-hrp.Position
    local function blocked(reason)
        followProgress=nil
        auto_buy.suspend_follow(1.5)
        _G.TekMovementFault=reason
        if type(_G.TekRecoverMovement)=="function" then task.defer(_G.TekRecoverMovement,reason) end
        diagnostics.phase=reason
        return false
    end
    local physical=_G.TekGetPhysicalRoot and _G.TekGetPhysicalRoot()
    if physical and physical~=hrp then return blocked("paused_clone_root") end
    if hrp.Anchored then return blocked("paused_root_locked") end
    if delta.Magnitude>60 then return blocked("paused_target_far") end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={character}
    params.RespectCanCollide=true
    params.CollisionGroup=hrp.CollisionGroup
    local overlap=OverlapParams.new()
    overlap.FilterType=Enum.RaycastFilterType.Exclude
    overlap.FilterDescendantsInstances={character}
    overlap.RespectCanCollide=true
    overlap.CollisionGroup=hrp.CollisionGroup
    local boxSize=Vector3.new(math.max(0.5,hrp.Size.X-0.2),math.max(0.5,hrp.Size.Y-0.2),math.max(0.5,hrp.Size.Z-0.2))
    -- Blockcast does not detect an overlap at its start: check that separately.
    for _,part in ipairs(workspace:GetPartBoundsInBox(hrp.CFrame,boxSize,overlap)) do
        if part.CanCollide then return blocked("paused_obstacle") end
    end
    if delta.Magnitude>0.1 and workspace:Blockcast(hrp.CFrame,boxSize,delta,params) then
        return blocked("paused_obstacle")
    end
    if not followProgress or followProgress.root~=hrp then
        followProgress={root=hrp,position=hrp.Position,at=os.clock()}
    elseif os.clock()-followProgress.at>=1 then
        local moved=(hrp.Position-followProgress.position).Magnitude
        followProgress={root=hrp,position=hrp.Position,at=os.clock()}
        if delta.Magnitude>3 and moved<0.2 then return blocked("paused_stuck") end
    end
    if body_position and body_position.Parent~=hrp then releaseFollow() end
    if not body_position then
        body_position=Instance.new("BodyPosition")
        body_position.Name="TekRunwayFollow"
        local force=math.clamp(hrp.AssemblyMass*1500,10000,200000)
        body_position.MaxForce=Vector3.new(force,force,force)
        body_position.P=5000
        body_position.D=800
        body_position.Position=hrp.Position
        body_position.Parent=hrp
    end
    -- No distant PivotTo, torso writes, or unlimited force through obstacles.
    body_position.Position=delta.Magnitude>6 and hrp.Position+delta.Unit*6 or goal
    diagnostics.following=true
    return true
end

local function root()
    local character=local_player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end
function auto_buy.get_animal_position(animal)
    if not animal then return nil end
    local rendered=animal.rendered_instance
    if not rendered or not rendered.Parent then
        runway_tracker.refresh_rendered_instance(animal)
        rendered=animal.rendered_instance
    end
    local model=rendered and rendered.Parent and rendered or animal.instance
    if not model or not model.Parent then return nil end
    if model.PrimaryPart then return model.PrimaryPart.Position end
    local ok,position=pcall(function() return model:GetPivot().Position end)
    return ok and position or nil
end
local function choose(hrp)
    local animals=runway_tracker.get_animals()
    diagnostics.tracked,diagnostics.nearest_distance=0,nil
    for _,animal in pairs(animals) do
        diagnostics.tracked+=1
        local position=auto_buy.get_animal_position(animal)
        if position then
            local distance=(hrp.Position-position).Magnitude
            if not diagnostics.nearest_distance or distance<diagnostics.nearest_distance then
                diagnostics.nearest_distance=distance
            end
        end
    end
    if target_provider then
        local target=target_provider(animals)
        if type(target)=="string" then return animals[target] end
        return target and animals[target.uuid or target.uid] or nil
    end
    if manual_target_uid then return animals[manual_target_uid] end
    if config.follow and follow_lock then
        local animal=animals[follow_lock]
        if animal and auto_buy.get_animal_position(animal) then return animal end
        unlockFollow()
    end
    local best,score=nil,nil
    for _,animal in pairs(animals) do
        if alreadyBought(animal) then continue end
        if #config.target_names>0 and not table.find(config.target_names,animal.display_name) then continue end
        local position=auto_buy.get_animal_position(animal)
        if not position then continue end
        local distance=(hrp.Position-position).Magnitude
        -- A distant expensive animal must not block an available nearby one.
        if distance>config.purchase_distance then continue end
        local value=config.target_mode=="nearest" and -distance or (tonumber(animal.gen_value) or 0)
        if not best or value>score or (value==score and tostring(animal.uid)<tostring(best.uid)) then
            best,score=animal,value
        end
    end
    return best
end
local function stopAfterError(err)
    diagnostics.phase="error"
    diagnostics.last_error=tostring(err)
    config.enabled=false
    unlockFollow()
    if connection then connection:Disconnect();connection=nil end
end
function auto_buy.step()
    if not config.enabled then return end
    local stepGeneration=generation
    if _G.Tek_IsResetting or _G.__elysiumResetBusy then unlockFollow();diagnostics.phase="paused_reset";return end
    if _G.TekLaserGrabSession or _G.TekSourceStealActive then unlockFollow();diagnostics.phase="paused_pickup";return end
    if local_player:GetAttribute("Stealing")==true then unlockFollow();diagnostics.phase="paused_carry";return end
    if _G.TekIsTeleporting and _G.TekIsTeleporting() then unlockFollow();diagnostics.phase="paused_tp";return end
    local hrp=root()
    local humanoid=local_player.Character and local_player.Character:FindFirstChildOfClass("Humanoid")
    local character=local_player.Character
    watchHumanoid(humanoid)
    if not hrp then auto_buy.suspend_follow();diagnostics.phase="no_character";return end
    if pausedForRecovery(character,humanoid) then return end
    if follow_character and follow_character~=local_player.Character then unlockFollow() end
    current_target=choose(hrp)
    diagnostics.target,diagnostics.distance=nil,nil
    if not current_target then
        unlockFollow()
        diagnostics.phase=diagnostics.tracked==0 and "no_animals" or "no_nearby_target"
        return
    end
    diagnostics.target=current_target.display_name or current_target.name or current_target.uid
    local position=auto_buy.get_animal_position(current_target)
    if not position then unlockFollow();diagnostics.phase="no_position";return end
    local distance=(hrp.Position-position).Magnitude
    diagnostics.distance=distance
    if not follow_lock and distance>config.purchase_distance then unlockFollow();diagnostics.phase="out_of_range";return end
    if config.follow then follow_lock=current_target.uuid or current_target.uid;follow_character=local_player.Character end
    if not followPosition(position,hrp) then return end
    if alreadyBought(current_target) then diagnostics.phase="following";return end
    if distance>config.purchase_distance then diagnostics.phase="following";return end
    diagnostics.phase="sending"
    for _=1,config.spam_attempts do
        if not config.enabled or generation~=stepGeneration or pausedForRecovery(character,humanoid) then return end
        diagnostics.attempts+=1
        local sent,reason=runway_util.purchase_animal(current_target)
        if generation~=stepGeneration or not config.enabled or local_player.Character~=character then return end
        if sent==false then stopAfterError(reason or "Purchase request failed");return end
        diagnostics.sent+=1
    end
end
function auto_buy.set_enabled(value)
    generation+=1
    if removingConnection then removingConnection:Disconnect();removingConnection=nil end
    if ragdollConnection then ragdollConnection:Disconnect();ragdollConnection=nil end
    watchHumanoid(nil)
    config.enabled=value==true
    if connection then connection:Disconnect();connection=nil end
    unlockFollow()
    if not config.enabled then current_target=nil;diagnostics.phase="off";return end
    diagnostics.last_error=nil
    diagnostics.phase="starting"
    runway_tracker.init()
    removingConnection=local_player.CharacterRemoving:Connect(function()
        auto_buy.suspend_follow();watchHumanoid(nil)
    end)
    ragdollConnection=local_player:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
        if isRagdolled(watchedHumanoid) then auto_buy.suspend_follow() end
    end)
    connection=run_service.RenderStepped:Connect(function()
        -- Purchase calls may yield: never stack follow/purchase steps across frames.
        if stepBusy then return end
        stepBusy=true
        local stepGeneration=generation
        local ok,err=pcall(auto_buy.step)
        stepBusy=false
        if not ok and config.enabled and generation==stepGeneration then stopAfterError(err) end
    end)
end
function auto_buy.is_enabled() return config.enabled end
function auto_buy.is_ready() return runway_util.is_ready() end
function auto_buy.get_diagnostics()
    local result=table.clone(diagnostics)
    result.purchase_distance=config.purchase_distance
    return result
end
function auto_buy.set_runway_purchase_distance(value)
    config.purchase_distance=math.clamp(tonumber(value) or config.purchase_distance,0,100)
    unlockFollow()
end
function auto_buy.get_runway_purchase_distance() return config.purchase_distance end
function auto_buy.set_runway_spam_attempts(value)
    config.spam_attempts=math.clamp(math.floor(tonumber(value) or config.spam_attempts),1,50)
end
function auto_buy.get_runway_spam_attempts() return config.spam_attempts end
function auto_buy.set_target_mode(value)
    assert(value=="highest_value" or value=="nearest","Expected highest_value or nearest")
    config.target_mode=value
    unlockFollow()
end
function auto_buy.set_follow_enabled(value) config.follow=value==true;unlockFollow() end
function auto_buy.set_follow_height(value) config.hover=math.clamp(tonumber(value) or 9,0,20) end
function auto_buy.set_targets(names) config.target_names=table.clone(names);unlockFollow() end
function auto_buy.set_target(uid) manual_target_uid=uid;unlockFollow() end
function auto_buy.set_target_provider(callback) target_provider=callback;unlockFollow() end
function auto_buy.get_current_target() return current_target end
function auto_buy.get_animals() runway_tracker.init();return runway_tracker.get_animals() end
function auto_buy.set_debug(value) runway_tracker.set_debug(value==true);debug_mode.enabled=value==true end
return auto_buy

end

-- Source: @src/modules/shared/runway_tracker
module_factories["@src/modules/shared/runway_tracker"] = function()
--!nonstrict
local game_utils = bundle_require("@src/utils/game")
local game_deps = bundle_require("@src/utils/game_deps")
local Profiler = bundle_require("@libs/profiler")

local Players = game_utils.get_service("Players")
local HttpService = game_utils.get_service("HttpService")
local Workspace = game_utils.get_service("Workspace")

local Observers = game_deps.Observers
local AnimalsData = game_deps.AnimalsData
local RaritiesData = game_deps.RaritiesData
local MutationsData = game_deps.MutationsData
local generation = bundle_require("@src/utils/generation")
local NumberUtils = game_deps.NumberUtils

local local_player = Players.LocalPlayer

local runway_tracker = {}
local runway_animals = {}
local animals_following_us = {}

local on_list_changed = Instance.new("BindableEvent")
runway_tracker.on_list_changed = on_list_changed.Event

local initialized = false
local debug_mode = false
local rendered_models_container = nil
local rendered_models_by_data_primary = {}
local rendered_models_dirty = true
local rendered_container_added_connection = nil
local rendered_container_removed_connection = nil
local workspace_child_added_connection = nil
local workspace_child_removed_connection = nil

local rebuild_rendered_index_profiler = Profiler.new("RunwayTracker.rebuild_rendered_index")
local find_rendered_model_profiler = Profiler.new("RunwayTracker.find_rendered_model")
local last_profile_log_time = 0

local function debug_log(...)
    if not debug_mode then return end
    print("[RunwayTracker Debug]", ...)
end

local function maybe_log_profiler_stats()
    if not debug_mode then return end

    local current_time = os.clock()
    if current_time - last_profile_log_time < 5 then
        return
    end

    last_profile_log_time = current_time
    rebuild_rendered_index_profiler:log_results()
    find_rendered_model_profiler:log_results()
end

local function finish_profile(profiler)
    profiler:finish(false)
    maybe_log_profiler_stats()
end

local function mark_rendered_models_dirty()
    rendered_models_dirty = true
end

local function disconnect_rendered_container_connections()
    if rendered_container_added_connection then
        rendered_container_added_connection:Disconnect()
        rendered_container_added_connection = nil
    end

    if rendered_container_removed_connection then
        rendered_container_removed_connection:Disconnect()
        rendered_container_removed_connection = nil
    end
end

local function attach_rendered_container(container)
    if rendered_models_container == container then
        return
    end

    disconnect_rendered_container_connections()

    rendered_models_container = container
    rendered_models_by_data_primary = {}
    rendered_models_dirty = true

    if not container then
        return
    end

    rendered_container_added_connection = container.ChildAdded:Connect(mark_rendered_models_dirty)
    rendered_container_removed_connection = container.ChildRemoved:Connect(function(removed_child)
        mark_rendered_models_dirty()

        for data_primary, rendered_model in pairs(rendered_models_by_data_primary) do
            if rendered_model == removed_child then
                rendered_models_by_data_primary[data_primary] = nil
            end
        end
    end)
end

local function setup_rendered_container_tracking()
    attach_rendered_container(Workspace:FindFirstChild("RenderedMovingAnimals"))

    if not workspace_child_added_connection then
        workspace_child_added_connection = Workspace.ChildAdded:Connect(function(child)
            if child.Name == "RenderedMovingAnimals" then
                attach_rendered_container(child)
            end
        end)
    end

    if not workspace_child_removed_connection then
        workspace_child_removed_connection = Workspace.ChildRemoved:Connect(function(child)
            if child == rendered_models_container then
                attach_rendered_container(nil)
            end
        end)
    end
end

local function get_data_primary(animal_instance)
    local data_primary = nil

    pcall(function()
        data_primary = animal_instance.PrimaryPart
    end)

    return data_primary
end

local function get_connected_data_primary(rendered_primary)
    for _, child in rendered_primary:GetChildren() do
        if child:IsA("WeldConstraint") or child:IsA("Weld") then
            if child.Part0 == rendered_primary then
                return child.Part1
            end

            if child.Part1 == rendered_primary then
                return child.Part0
            end
        end
    end

    return nil
end

local function rebuild_rendered_index()
    if not rendered_models_dirty then
        return
    end

    if not rendered_models_container or not rendered_models_container.Parent then
        attach_rendered_container(Workspace:FindFirstChild("RenderedMovingAnimals"))
    end

    if not rendered_models_container then
        rendered_models_by_data_primary = {}
        rendered_models_dirty = false
        return
    end

    rebuild_rendered_index_profiler:start()

    local indexed_models = {}

    for _, rendered_model in rendered_models_container:GetChildren() do
        if not rendered_model:IsA("Model") then continue end

        local rendered_primary = nil
        pcall(function()
            rendered_primary = rendered_model.PrimaryPart
        end)

        if not rendered_primary then
            continue
        end

        local data_primary = get_connected_data_primary(rendered_primary)
        if data_primary then
            indexed_models[data_primary] = rendered_model
        end
    end

    rendered_models_by_data_primary = indexed_models
    rendered_models_dirty = false

    finish_profile(rebuild_rendered_index_profiler)
end

-- Find the rendered (visual) model for a runway animal.
-- The "Animal" tagged instance is an invisible data model underground.
-- The game (AnimalClient.lua) links the rendered model to the data model with either
-- a Weld or a WeldConstraint on the rendered model's PrimaryPart.
local function find_rendered_model(animal_instance)
    find_rendered_model_profiler:start()

    local data_primary = get_data_primary(animal_instance)
    if not data_primary then
        finish_profile(find_rendered_model_profiler)
        return nil
    end

    local cached_model = rendered_models_by_data_primary[data_primary]
    if cached_model and cached_model.Parent then
        finish_profile(find_rendered_model_profiler)
        return cached_model
    end

    rendered_models_by_data_primary[data_primary] = nil
    rendered_models_dirty = true
    rebuild_rendered_index()

    local rendered_model = rendered_models_by_data_primary[data_primary]

    finish_profile(find_rendered_model_profiler)
    return rendered_model
end

local function parse_animal_data(animal_instance)
    local uuid = animal_instance.Name
    local index = animal_instance:GetAttribute("Index")
    
    if not index then
        return nil
    end
    
    local animal_info = AnimalsData[index]
    if not animal_info then
        return nil
    end
    
    local mutation = animal_instance:GetAttribute("Mutation")
    local traits_raw = animal_instance:GetAttribute("Traits")
    local traits = nil
    
    if traits_raw and traits_raw ~= "" then
        pcall(function()
            traits = HttpService:JSONDecode(traits_raw)
        end)
    end
    
    local display_name = animal_info.DisplayName or index
    local rarity = animal_info.Rarity
    local rarity_data = RaritiesData[rarity]
    local rarity_color = rarity_data and rarity_data.Color or Color3.fromRGB(255, 255, 255)
    local rarity_gradient = rarity_data and rarity_data.GradientPreset or nil
    local mutation_data = mutation and MutationsData[mutation] or nil
    local gen_value = generation.get(index, mutation, traits)
    local gen_text = NumberUtils:ToString(gen_value) .. "/s"
    
    -- Find the rendered visual model
    local rendered = find_rendered_model(animal_instance)
    
    return {
        uuid = uuid,
        uid = uuid, -- Ensure compatibility with auto_steal uid
        index = index,
        display_name = display_name,
        name = display_name, -- Alias for auto_steal
        rarity = rarity,
        rarity_color = rarity_color,
        rarity_gradient = rarity_gradient,
        mutation = mutation,
        mutation_data = mutation_data,
        traits = traits,
        traits_array = traits or {}, -- Compatibility alias
        gen_value = gen_value,
        gen_text = gen_text,
        price = animal_info.Price or 0,
        instance = animal_instance,
        rendered_instance = rendered, -- visual model for ESP/highlights
        is_runway = true,
        plot = nil,
        slot = nil,
        state = nil,
        state_color = nil,
        owner = "Runway",
    }
end

function runway_tracker.init()
    if initialized then return end
    initialized = true

    setup_rendered_container_tracking()
    
    Observers.observeTag("Animal", function(animal_instance)
        local animal_data = parse_animal_data(animal_instance)
        
        if not animal_data then
            return function() end
        end
        
        local uuid = animal_data.uuid
        runway_animals[uuid] = animal_data
        
        debug_log("Animal tracked:", animal_data.name, "UUID:", uuid)
        
        -- Emit event
        on_list_changed:Fire()
        
        return function()
            debug_log("Animal untracked:", animal_data.name, "UUID:", uuid)
            runway_animals[uuid] = nil
            animals_following_us[uuid] = nil
            on_list_changed:Fire()
        end
    end)
    
    Observers.observeTag("AnimalPurchasePrompt", function(prompt)
        return Observers.observeAttribute(prompt, "TargetPlayer", function(target_player_id)
            if not target_player_id then return end
            
            local animal_model = prompt:FindFirstAncestorOfClass("Model")
            if not animal_model then return end
            
            local uuid = animal_model.Name
            
            if target_player_id == local_player.UserId then
                local index_name = animal_model:GetAttribute("Index")
                animals_following_us[uuid] = index_name
                debug_log("Animal is now following us:", index_name, "UUID:", uuid)
            else
                if animals_following_us[uuid] then
                    debug_log("Animal no longer following us:", uuid)
                end
                animals_following_us[uuid] = nil
            end
            
            on_list_changed:Fire()
        end)
    end)
end

function runway_tracker.get_animals()
    return runway_animals
end

function runway_tracker.get_animals_following_us()
    return animals_following_us
end

function runway_tracker.is_animal_following_us(uuid)
    return animals_following_us[uuid] ~= nil
end

function runway_tracker.refresh_rendered_instance(animal_data)
    if not animal_data or not animal_data.instance then return end

    if animal_data.rendered_instance and animal_data.rendered_instance.Parent then
        return animal_data.rendered_instance
    end

    animal_data.rendered_instance = find_rendered_model(animal_data.instance)
    return animal_data.rendered_instance
end

function runway_tracker.set_debug(value)
    debug_mode = value
end

function runway_tracker.is_debug()
    return debug_mode
end

return runway_tracker

end

-- Source: @src/utils/game
module_factories["@src/utils/game"] = function()
--!nonstrict
local cloneref = cloneref or function(o)
    return o
end

local game_ref = cloneref(game)

local game_utils = {}

-- run_as_game (identity 2 + временно убранные глобалы экзекутора) удалён
-- 2026-09-29. Колбэк шёл на нашем же потоке, так что наши кадры оставались на
-- стеке, а cloneref/writefile/getnamecallmethod, которые ищут сканы Net и
-- RelateChannels, из getgenv не убирались. От этих сканов он не защищал, а
-- вокруг FireServer/InvokeServer был просто лишним: сервер стек клиента не видит.

local GUI_READY_TIMEOUT = 5

function game_utils.get_service(service_name)
    return game_ref:GetService(service_name)
end

local function usable(container)
    if not container then
        return false
    end
    return (pcall(function()
        return container:FindFirstChild("__ods_probe__")
    end))
end

-- Контейнер для нашего GUI: gethui(), иначе CoreGui. PlayerGui — никогда:
-- античит сверяет имена детей PlayerGui со списком от сервера (X-23/X-24,
-- brainrot_finder_panel-1/dumps/nil_obfuscated/ANALYSIS.md).
--
-- gethui() на старте сразу отдаёт объект CoreGui, но короткое время после
-- инжекта его нельзя индексировать ("lacking capability Plugin"). Поэтому ждём,
-- пока контейнер реально станет доступен, а не просто пока gethui вернёт не nil.
function game_utils.get_gui()
    if type(gethui) == "function" then
        local deadline = os.clock() + GUI_READY_TIMEOUT
        repeat
            local ok, gui = pcall(gethui)
            if ok and usable(gui) then
                return gui
            end
            task.wait()
        until os.clock() >= deadline
    end

    local core_ok, core_gui = pcall(function()
        return game_ref:GetService("CoreGui")
    end)
    return core_ok and core_gui or nil
end

return game_utils

end

-- Source: @src/utils/game_deps
module_factories["@src/utils/game_deps"] = function()
local replicated_storage = game:GetService("ReplicatedStorage")
local datas = assert(replicated_storage:WaitForChild("Datas", 30), "Datas missing")
local packages = assert(replicated_storage:WaitForChild("Packages", 30), "Packages missing")
return {
    NetSafe = bundle_require("@src/utils/net_safe"),
    Observers = require(packages:WaitForChild("Observers")),
    AnimalsData = require(datas:WaitForChild("Animals")),
    RaritiesData = require(datas:WaitForChild("Rarities")),
    MutationsData = require(datas:WaitForChild("Mutations")),
    TraitsData = require(datas:WaitForChild("Traits")),
    GameData = require(datas:WaitForChild("Game")),
    NumberUtils = require(replicated_storage:WaitForChild("Utils"):WaitForChild("NumberUtils")),
}

end

-- Source: @src/utils/net_safe
module_factories["@src/utils/net_safe"] = function()
--!nonstrict
--[[
    Резолв игровых ремоутов расчётом имени. Без Net, без getgc, без хуков.

    ── Как игра называет ремоуты ───────────────────────────────────────────────
    Тело ReplicatedStorage.Packages.Net деобфусцировано, читаемая реконструкция
    лежит в соседнем проекте: brainrot_finder_panel-1/dumps/obfuscated/Net.clean.luau.
    Имя инстанса собирается так:

        Name = ("RE/" | "RF/" | "URE/") .. sha256hex(scramble(logical) .. SALT .. JobId)

    scramble — печатный Виженер по байтам JobId, shift(b, k) = (b - 32 + k) % 95 + 32,
    причём "/" копируется как есть и НЕ сдвигает позицию ключа. SHA-256 у игры
    стоковый и побайтово совпадает с нашим src/libs/sha256.luau.

    Проверено на живом клиенте 2026-07-29 (JobId c8e9538c-…): из каждой приманки
    взято логическое имя, посчитан хеш, найден хешированный близнец — 317/317,
    промахов 0, расхождений класса 0. Методика повтора — §6 в конце Net.clean.luau.

    Замеры этого модуля там же, живьём: первый резолв 0.88 мс (включая сверку
    схемы), холодный расчёт хеша 0.26 мс, кеш-хит 0.60 мкс. Для сравнения, старый
    GC-гарвест стоил ~110 мс на старте.

    На случай, если игра сменит схему, ниже стоит одноразовая сверка
    verify_scheme: поломка вылезет одной внятной строкой в логе, а не молчаливым
    "ремоут не найден" по каждому имени.

    ── Почему не Net ───────────────────────────────────────────────────────────
    Net:RemoteEvent / :RemoteFunction из нашего окружения возвращает константную
    канарейку "RF/068a6294…", ребёнка с таким именем не существует: вызов висит
    10 с на WaitForChild и кикает. 2026-07-27 это дважды подтвердилось живьём
    (BAC-27410, BAC-7746, через 6-9 с после вызова).

    Причина теперь известна точно: расчёт хеша внутри Net безусловно сканирует
    getfenv(1..10) на маркеры экзекутора (cloneref, getrenv, getupvalues,
    getnamecallmethod, superflow_bytecode, поддельное окружение), при детекте
    стучит на сервер и подменяет хеш канарейкой. Мы этот код просто не зовём.

    ── Почему не плоское имя ───────────────────────────────────────────────────
    В Packages.Net на каждое имя по два ребёнка: плоский и хешированный. Плоские
    это ПРИМАНКИ — на них висит Security.OnDetected:RemoveFromGame(player,
    "X-39", name, 120, 360). Слушать их бесполезно (никогда не стреляют),
    отправлять — бан. Игра пользуется только хешированными.

    ── Что было здесь раньше ───────────────────────────────────────────────────
    До 2026-08-08 модуль ставил hookfunction на getfenv и Instance.WaitForChild,
    поднимал флаг allow_spoof и звал настоящий Net:Remote* с подсунутым игровым
    окружением. Это работало, но требовало install() до первого резолва, зависело
    от hookfunction/restorefunction экзекутора и оставляло два глобальных хука на
    всю сессию. Расчёт свободен от всего этого — ему нужен только JobId и сам
    инстанс в дереве.
]]

local logging = bundle_require("@src/libs/logging")
local sha256 = bundle_require("@src/libs/sha256")

local RunService = game:GetService("RunService")

-- Соль игра ротирует с апдейтами, схема при этом не меняется. История:
--   до 2026-08-16  bd93afff-8aba-409d-9946-a875f6c33087
--   с  2026-08-16  36bc48de-ccc6-4666-af4b-7d3bd46d6aa7  (PlaceVersion 2501)
-- Когда verify_scheme снова заорёт, новую соль не надо выковыривать из свежего
-- блоба: Luraph держит расшифрованные константы модуля живыми таблицами в куче,
-- сама соль — обычная Lua-строка, а любая приманка работает оракулом. Готовый
-- пробник: brainrot_finder_panel-1/scripts/probe/net_salt_sweep.lua
local SALT = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
-- Сам Net в Studio подставляет нулевой GUID вместо пустого game.JobId.
local STUDIO_JOB_ID = "00000000-0000-0000-0000-000000000000"

local PREFIX: { [string]: string } = {
	RemoteEvent = "RE/",
	RemoteFunction = "RF/",
	UnreliableRemoteEvent = "URE/",
}

local SEPARATOR = string.byte("/")
local HASH_LEN = 64

local M = {}

local state = {
	folder = nil :: Instance?,
	job_id = nil :: string?,
	-- байты JobId, они же ключ Виженера
	key = nil :: any,
	-- logical -> посчитанный хеш (без префикса)
	hashes = {} :: { [string]: string },
	-- logical .. class -> найденный инстанс
	cache = {} :: { [string]: Instance },
	-- nil = ещё не сверяли (приманок не видно), true/false = результат сверки
	verified = nil :: boolean?,
}

-- Диагностику печатаем один раз на логическое имя: резолв ретраится, а
-- дублировать одну и ту же строку каждые 30 с смысла нет.
local diag_done = {}

local function net_folder(): Instance?
	local cached = state.folder
	if cached and cached.Parent then
		return cached
	end
	local packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
	state.folder = packages and packages:FindFirstChild("Net") or nil
	return state.folder
end

-- Ключ Виженера. Смена JobId (телепорт на другой сервер) обнуляет всё
-- посчитанное: имена завязаны на JobId и на новом сервере другие.
local function job_key()
	local job_id = if RunService:IsStudio() then STUDIO_JOB_ID else game.JobId
	if job_id == nil or job_id == "" then
		job_id = STUDIO_JOB_ID
	end

	if state.job_id ~= job_id then
		state.job_id = job_id
		state.key = table.pack(string.byte(job_id, 1, -1))
		table.clear(state.hashes)
		table.clear(state.cache)
		state.verified = nil
	end

	return job_id, state.key
end

local function hash_of(logical: string): string
	local cached = state.hashes[logical]
	if cached then
		return cached
	end

	local job_id, key = job_key()
	local key_count = key.n
	local out = table.create(#logical)
	local key_index = 1

	for i = 1, #logical do
		local byte = string.byte(logical, i)
		if byte == SEPARATOR then
			out[i] = "/" -- разделитель проходит как есть, ключ не сдвигается
		else
			out[i] = string.char((byte - 32 + key[key_index]) % 95 + 32)
			key_index = key_index % key_count + 1
		end
	end

	local digest = sha256(buffer.fromstring(table.concat(out) .. SALT .. job_id))
	state.hashes[logical] = digest
	return digest
end

local function is_hashed_body(body: string?): boolean
	return body ~= nil and #body == HASH_LEN and string.match(body, "^%x+$") ~= nil
end

-- Одноразовая сверка схемы. Берём первую попавшуюся приманку (плоское имя),
-- считаем по формуле её хешированного близнеца и проверяем, что он есть.
-- Приманку при этом не трогаем — только читаем её имя.
local function verify_scheme(folder: Instance)
	if state.verified ~= nil then
		return
	end

	for _, child in folder:GetChildren() do
		local prefix, body = string.match(child.Name, "^(%a+/)(.+)$")
		if prefix and not is_hashed_body(body) then
			state.verified = folder:FindFirstChild(prefix .. hash_of(body)) ~= nil
			if state.verified then
				logging.debug("NetSafe", "схема имён сходится на " .. child.Name)
			else
				logging.warn(
					"NetSafe",
					"схема имён НЕ сходится на "
						.. child.Name
						.. " — игра сменила соль, порядок склейки или сдвиг; "
						.. "перепроверь формулу по dumps/obfuscated/Net.clean.luau"
				)
			end
			return
		end
	end
	-- Ни одной приманки не видно: Packages.Net ещё не долил детей. Оставляем
	-- verified = nil, сверимся на следующем резолве.
end

local function resolve(logical: string, class: string): (Instance?, string?)
	if type(logical) ~= "string" or logical == "" then
		return nil, "пустое имя"
	end

	local prefix = PREFIX[class]
	if not prefix then
		return nil, "неизвестный класс " .. tostring(class)
	end

	local cache_key = logical .. "\0" .. class
	local hit = state.cache[cache_key]
	if hit and hit.Parent then
		return hit, "cache"
	end
	state.cache[cache_key] = nil

	local folder = net_folder()
	if not folder then
		return nil, "ReplicatedStorage.Packages.Net не найден"
	end

	verify_scheme(folder)

	-- FindFirstChild, а не WaitForChild: резолв обязан быть неблокирующим, а
	-- ремоут может ещё не дореплицироваться. Промах не кешируется — вызывающий
	-- ретраит.
	local name = prefix .. hash_of(logical)
	local inst = folder:FindFirstChild(name)
	if not inst then
		return nil, "нет ребёнка " .. name
	end
	if inst.ClassName ~= class then
		return nil, string.format("%s оказался %s, ожидался %s", name, inst.ClassName, class)
	end

	state.cache[cache_key] = inst
	return inst, "hash"
end

-- Как читать при промахе:
--   children=0            -> Packages.Net пуст, дерево ещё не доехало
--   hashed=0 children>0   -> доехали только приманки, рабочих ещё нет
--   verified=false        -> формула протухла, чинить net_safe, а не вызов
--   verified=nil          -> сверяться было не на чем (приманок не видно)
local function diag_text(folder: Instance?): string
	local total, hashed = 0, 0
	if folder then
		for _, child in folder:GetChildren() do
			total += 1
			if is_hashed_body(string.match(child.Name, "^%a+/(.+)$")) then
				hashed += 1
			end
		end
	end
	return string.format(
		"job=%s children=%d hashed=%d verified=%s",
		tostring(state.job_id),
		total,
		hashed,
		tostring(state.verified)
	)
end

local function public(logical: string, class: string): Instance?
	local inst, why = resolve(logical, class)
	if inst then
		logging.debug("NetSafe", string.format("%s -> %s (%s)", logical, inst.Name, tostring(why)))
	elseif not diag_done[logical] then
		-- Один раз на логическое имя. В проде логгер молчит; чтобы увидеть эту
		-- строку в обфусцированной сборке, поставь getgenv()._ODY_FORCE_LOGS = true
		-- до загрузки.
		diag_done[logical] = true
		logging.warn(
			"NetSafe",
			string.format("%s не разрешён: %s | %s", logical, tostring(why), diag_text(net_folder()))
		)
	end
	return inst
end

function M.RemoteEvent(logical: string): RemoteEvent?
	return public(logical, "RemoteEvent") :: any
end

function M.RemoteFunction(logical: string): RemoteFunction?
	return public(logical, "RemoteFunction") :: any
end

function M.UnreliableRemoteEvent(logical: string): UnreliableRemoteEvent?
	return public(logical, "UnreliableRemoteEvent") :: any
end

function M.clear_cache()
	table.clear(state.cache)
	table.clear(state.hashes)
	state.folder = nil
	state.verified = nil
end

function M.is_available(): boolean
	return net_folder() ~= nil
end

-- Совместимость со старым API: install/uninstall/backend больше не нужны,
-- резолв работает без хуков. Заглушки оставлены, чтобы вызывающий код,
-- написанный под хуковую версию, не падал.
function M.install(): boolean
	return true
end

function M.uninstall()
	M.clear_cache()
end

function M.is_installed(): boolean
	return true
end

function M.backend(): string
	return "hash"
end

-- Colon-style aliases for drop-in feel
M.get_remote_event = M.RemoteEvent
M.get_remote_function = M.RemoteFunction

return M

end

-- Source: @src/libs/logging
module_factories["@src/libs/logging"] = function()
--!nonstrict
--[[
    Logging Module
    Provides unified logging with timestamps and log levels
    Tracks script startup time via os.clock()
]]

local logging = {}

-- Log levels
logging.levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    NONE = 5
}

-- Private state
local start_time = os.clock()
local current_level = logging.levels.INFO
local level_names = {
    [1] = "DEBUG",
    [2] = "INFO",
    [3] = "WARN",
    [4] = "ERROR"
}

-- Get elapsed time since script start
function logging.get_elapsed()
    return os.clock() - start_time
end

-- Format elapsed time
local function format_time(elapsed)
    return string.format("[%.3fs]", elapsed)
end

-- Set log level
function logging.set_level(level: string | number)
    if type(level) == "string" then
        level = logging.levels[level:upper()] or logging.levels.INFO
    end
    current_level = level
end

-- Get current log level
function logging.get_level()
    return current_level
end

-- Get log level name
function logging.get_level_name()
    return level_names[current_level] or "UNKNOWN"
end

-- Core logging function
local function log(level, prefix, ...)
    if level < current_level then
        return
    end

    local elapsed = logging.get_elapsed()
    local time_str = format_time(elapsed)
    local level_name = level_names[level] or "LOG"
    
    local args = {...}
    local message_parts = {}
    
    for i, v in ipairs(args) do
        if type(v) == "table" then
            table.insert(message_parts, tostring(v))
        else
            table.insert(message_parts, tostring(v))
        end
    end
    
    local message = table.concat(message_parts, " ")
    local full_prefix = prefix and string.format("[%s]", prefix) or ""
    local output = string.format("%s [%s]%s %s", time_str, level_name, full_prefix, message)
    
    if level >= logging.levels.WARN then
        warn(output)
    else
        print(output)
    end
end

-- Log methods with optional prefix
function logging.debug(prefix_or_msg, ...)
    if select("#", ...) == 0 then
        log(logging.levels.DEBUG, nil, prefix_or_msg)
    else
        log(logging.levels.DEBUG, prefix_or_msg, ...)
    end
end

function logging.info(prefix_or_msg, ...)
    if select("#", ...) == 0 then
        log(logging.levels.INFO, nil, prefix_or_msg)
    else
        log(logging.levels.INFO, prefix_or_msg, ...)
    end
end

function logging.warn(prefix_or_msg, ...)
    if select("#", ...) == 0 then
        log(logging.levels.WARN, nil, prefix_or_msg)
    else
        log(logging.levels.WARN, prefix_or_msg, ...)
    end
end

function logging.error(prefix_or_msg, ...)
    if select("#", ...) == 0 then
        log(logging.levels.ERROR, nil, prefix_or_msg)
    else
        log(logging.levels.ERROR, prefix_or_msg, ...)
    end
end

-- Timer utility for tracking operation durations
function logging.start_timer(operation_name)
    return {
        name = operation_name,
        start = os.clock()
    }
end

function logging.end_timer(timer, level: number?)
    level = level or logging.levels.INFO
    local elapsed = os.clock() - timer.start
    local total_elapsed = logging.get_elapsed()
    
    if level >= current_level then
        local output = string.format(
            "[%.3fs] [%s] %s completed in %.3fs",
            total_elapsed,
            level_names[level] or "INFO",
            timer.name,
            elapsed
        )
        
        if level >= logging.levels.WARN then
            warn(output)
        else
            print(output)
        end
    end
    
    return elapsed
end

-- Scoped timer that logs on completion
function logging.timed(operation_name, func, level: number?)
    level = level or logging.levels.INFO
    local timer = logging.start_timer(operation_name)
    local success, result = pcall(func)
    local elapsed = logging.end_timer(timer, level)
    
    if not success then
        logging.error("Timer", operation_name .. " failed: " .. tostring(result))
        error(result)
    end
    
    return result, elapsed
end

-- Reset start time (useful for testing)
function logging.reset_start_time()
    start_time = os.clock()
end

-- Get start time
function logging.get_start_time()
    return start_time
end

return logging

end

-- Source: @src/libs/sha256
module_factories["@src/libs/sha256"] = function()
--[=[
	Cryptography library: SHA256

	Sizes:
		Digest: 32 bytes
	
        Return type: string
        Example usage:
            local Message = buffer.fromstring("Hello World")
            local hash, digest = SHA256(Message)
--]=]

--!strict
--!optimize 2
--!native
-- Macro wrappers are private to this export.

local CONSTANTS = buffer.create(256) do -- CONSTANTS = k
    local RoundConstants = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }

    for Index, Constant in ipairs(RoundConstants) do
        local BufferOffset = (Index - 1) * 4
        buffer.writeu32(CONSTANTS, BufferOffset, Constant)
    end
end

local PreProcess = LPH_JIT_MAX(function(Contents: buffer)
    local ContentLength = buffer.len(Contents)
    local Padding = -(ContentLength + 9) % 64

    local NewContentLength = ContentLength + 1 + Padding + 8
    local NewContent = buffer.create(NewContentLength)
    buffer.copy(NewContent, 0, Contents)
    buffer.writeu8(NewContent, ContentLength, 128)
    local Length8 = ContentLength * 8
    for Index = 7, 0, -1 do
        local Remainder = Length8 % 256
        buffer.writeu8(NewContent, Index + ContentLength + 1 + Padding, Remainder)
        Length8 = (Length8 - Remainder) / 256
    end

    return NewContent, NewContentLength
end)

local OFFSETS = buffer.create(256)
local DigestBlocks = LPH_JIT_MAX(function(Blocks: buffer, Length: number)
    local A, B, C, D = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
    local E, F, G, H = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19

    local Offsets = OFFSETS
    local Constants = CONSTANTS

    for Offset = 0, Length - 1, 64 do
        for BlockIndex = 0, 60, 4 do
            buffer.writeu32(Offsets, BlockIndex, bit32.byteswap(buffer.readu32(Blocks, Offset + BlockIndex)))
        end

        for Index = 64, 252, 4 do
            local Sub15 = buffer.readu32(Offsets, Index - 60)
            local S0 = bit32.bxor(bit32.rrotate(Sub15, 7), bit32.rrotate(Sub15, 18), bit32.rshift(Sub15, 3))

            local Sub2 = buffer.readu32(Offsets, Index - 8)
            local S1 = bit32.bxor(bit32.rrotate(Sub2, 17), bit32.rrotate(Sub2, 19), bit32.rshift(Sub2, 10))

            local Sub7, Sub16 = buffer.readu32(Offsets, Index - 28), buffer.readu32(Offsets, Index - 64)
            buffer.writeu32(Offsets, Index, (Sub16 + S0 + Sub7 + S1))
        end

        local OldA, OldB, OldC, OldD, OldE, OldF, OldG, OldH = A, B, C, D, E, F, G, H

        for BufferIndex = 0, 252, 4 do
            local S1 = bit32.bxor(bit32.rrotate(E, 6), bit32.rrotate(E, 11), bit32.rrotate(E, 25))
            local Ch = bit32.bxor(bit32.band(E, F), bit32.band(bit32.bnot(E), G))
            local Temp1 = H + S1 + Ch + buffer.readu32(Constants, BufferIndex) + buffer.readu32(Offsets, BufferIndex)
            H, G, F, E, D = G, F, E, D + Temp1, C

            local S0 = bit32.bxor(bit32.rrotate(A, 2), bit32.rrotate(A, 13), bit32.rrotate(A, 22))
            local Maj = bit32.bxor(bit32.band(A, B), bit32.band(A, C), bit32.band(B, C))
            C, B, A = B, A, Temp1 + S0 + Maj
        end

        A, B, C, D, E, F, G, H =
            bit32.bor(A + OldA, 0),
            bit32.bor(B + OldB, 0),
            bit32.bor(C + OldC, 0),
            bit32.bor(D + OldD, 0),
            bit32.bor(E + OldE, 0),
            bit32.bor(F + OldF, 0),
            bit32.bor(G + OldG, 0),
            bit32.bor(H + OldH, 0) :: number
    end

    return A, B, C, D, E, F, G, H
end)

local SHA256 = LPH_JIT_MAX(function(Message: buffer)
    local ProcessedMessage, Length = PreProcess(Message)
    local A, B, C, D, E, F, G, H = DigestBlocks(ProcessedMessage, Length)

    local Digest = buffer.create(32)

    buffer.writeu32(Digest, 0, A)
    buffer.writeu32(Digest, 4, B)
    buffer.writeu32(Digest, 8, C)
    buffer.writeu32(Digest, 12, D)
    buffer.writeu32(Digest, 16, E)
    buffer.writeu32(Digest, 20, F)
    buffer.writeu32(Digest, 24, G)
    buffer.writeu32(Digest, 28, H)

    return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", A, B, C, D, E, F, G, H), Digest
end)

return SHA256

end

-- Source: @src/libs/profiler
module_factories["@src/libs/profiler"] = function()
--!nonstrict
local Profiler = {}
Profiler.__index = Profiler


function Profiler.new(name)
    local self = setmetatable({}, Profiler)

    self.name = name or "Unknown"
    self.start_time = 0

    self.execution_time = {
        last = 0,
        average = 0,
        minimum = math.huge,
        maximum = 0,
    }

    self.next_average_update_time = 0
    self.absolute_time = 0
    self.sample_count = 0

    return self
end


function Profiler:start()
    self.start_time = os.clock()
end


function Profiler:finish(log_results)
    local current_time = os.clock()

    -- Вычисляем время выполнения в миллисекундах
    self.execution_time.last = (current_time - self.start_time) * 1000

    -- Обновляем среднее значение каждые 5 секунд
    if self.next_average_update_time <= current_time then
        self.next_average_update_time = current_time + 5

        if self.sample_count > 0 then
            self.execution_time.average = self.absolute_time / self.sample_count
        end

        self.absolute_time = 0
        self.sample_count = 0
    end

    self.absolute_time = self.absolute_time + self.execution_time.last
    self.sample_count = self.sample_count + 1

    -- Обновляем минимум и максимум
    if self.execution_time.last < self.execution_time.minimum then
        self.execution_time.minimum = self.execution_time.last
    end

    if self.execution_time.last > self.execution_time.maximum then
        self.execution_time.maximum = self.execution_time.last
    end

    if log_results then
        self:log_results()
    end
end


function Profiler:log_results()
    local avg = self.execution_time.average
    local min = self.execution_time.minimum
    local max = self.execution_time.maximum
    local cur = self.execution_time.last

    -- Форматируем минимум (может быть math.huge если ещё не было измерений)
    local min_str = (min == math.huge) and "N/A" or string.format("%.4f", min)

    print(string.format(
        "[Profiler] %s execution time | Avg: %.4f ms | Min: %s ms | Max: %.4f ms | Current: %.4f ms",
        self.name,
        avg,
        min_str,
        max,
        cur
    ))
end


function Profiler:reset()
    self.execution_time = {
        last = 0,
        average = 0,
        minimum = math.huge,
        maximum = 0,
    }

    self.next_average_update_time = 0
    self.absolute_time = 0
    self.sample_count = 0
end


function Profiler:get_stats()
    return {
        name = self.name,
        last = self.execution_time.last,
        average = self.execution_time.average,
        minimum = self.execution_time.minimum,
        maximum = self.execution_time.maximum,
        samples = self.sample_count,
    }
end


return Profiler

end

-- Source: @src/utils/generation
module_factories["@src/utils/generation"] = function()
--!nonstrict
--[[
    Доход брейнрота в секунду без вызова кода игры.

    Формула — копия Shared.Animals:GetGeneration
    (game/ReplicatedStorage/Shared/Animals.luau). Саму функцию не зовём:
      * её RelateChannels обходит getfenv по стеку в поисках writefile и шлёт
        "LTO" + ZWNBSP в InventoryService/Sort;
      * с игроком в 4-м аргументе она зовёт Shared.Game:GetPlayerCashMultiplayer,
        а тот — игровой Synchronizer:Get со своей RelateChannels.

    generation.get(index, mutation, traits, multiplier?) -> number
        multiplier — множитель игрока (get_cash_multiplier), по умолчанию 1.

    generation.get_cash_multiplier(player?) -> number
        Нижняя граница Shared.Game:GetPlayerCashMultiplayer: ребирт, VIP,
        2x Money, бусты 2xMoney, друзья онлайн. Бонус за собранный индекс
        (Shared.Index:GetMultipliers, +0.5 за каждый) не считается — его логика
        завязана на FFlags и лимитированные индексы, переносить её хрупко.
        Поэтому реальный доход может быть выше, но не ниже.
]]

local Players = game:GetService("Players")

local game_deps = bundle_require("@src/utils/game_deps")

local generation = {}

local SLEEPY_TRAIT = "Sleepy"
local VIP_BONUS = 0.5
local DOUBLE_MONEY_BONUS = 2
local BOOST_BONUS = 2

function generation.get(index, mutation, traits, multiplier)
    local info = game_deps.AnimalsData[index]
    if type(info) ~= "table" then
        return 0
    end

    local base = info.Generation
    if type(base) ~= "number" then
        base = (tonumber(info.Price) or 0) * game_deps.GameData.Game.AnimalGanerationModifier
    end

    local modifier = 1
    if mutation then
        local mutation_info = game_deps.MutationsData[mutation]
        modifier += mutation_info and mutation_info.Modifier or 0
    end

    local sleepy = false
    if type(traits) == "table" then
        for _, trait in traits do
            local trait_info = game_deps.TraitsData[trait]
            if not trait_info then
                continue
            end
            if trait == SLEEPY_TRAIT then
                sleepy = true
            else
                modifier += trait_info.MultiplierModifier
            end
        end
    end

    local value = base * modifier
    if sleepy then
        value *= 0.5
    end
    if multiplier then
        value *= multiplier
    end

    return math.round(value)
end

local function is_active_boost(expiration, now)
    return typeof(expiration) == "number" and expiration > 0 and now < expiration
end

function generation.get_cash_multiplier(player)
    player = player or Players.LocalPlayer

    local data = game_deps.Synchronizer:Get(player)
    if not data then
        return 1
    end

    local multiplier = 1

    local rebirth = data:Get("Rebirth")
    if type(rebirth) == "number" and rebirth > 0 then
        local rebirth_info = game_deps.RebirthData[rebirth]
        if rebirth_info then
            multiplier += rebirth_info.Rewards.Multiplier
        end
    end

    if data:Get("Gamepass.VIP") == true then
        multiplier += VIP_BONUS
    end

    if data:Get("Gamepass.2x Money") == true then
        multiplier += DOUBLE_MONEY_BONUS
    end

    local now = DateTime.now().UnixTimestamp
    if is_active_boost(data:Get("BoostExpiration.2xMoney"), now)
        or is_active_boost(data:Get("BoostExpiration.2xMoneyBoost"), now)
    then
        multiplier += BOOST_BONUS
    end

    -- Shared.Friends — чистый поиск по таблице, без Synchronizer и сканов стека.
    local ok, friends_bonus = pcall(game_deps.Friends.GetFriendBoostModifier, game_deps.Friends, player)
    if ok and type(friends_bonus) == "number" then
        multiplier += friends_bonus
    end

    return multiplier
end

return generation

end

-- Source: @src/utils/runway
module_factories["@src/utils/runway"] = function()
--!nonstrict
local game_utils = bundle_require("@src/utils/game")
local OffsetFetcher = bundle_require("@src/utils/offset_fetcher")

local Workspace = game_utils.get_service("Workspace")

local AnimalPurchaseData = OffsetFetcher.GetAnimalData()

if not AnimalPurchaseData or not AnimalPurchaseData.remote or not AnimalPurchaseData.keys then
    warn("Failed to resolve purchase offsets! Module might not work.")
end

local runway = {}

local function get_animal_uid(animal_data)
    if not animal_data or not animal_data.instance then
        return nil
    end
    
    local prompt = animal_data.instance:FindFirstChild("ProximityPrompt", true)
    
    if prompt then
        local uid = prompt:GetAttribute("UID")
        if uid then
            return uid
        end
    end
    
    return animal_data.uuid
end

function runway.is_ready()
    local data = AnimalPurchaseData or OffsetFetcher.GetAnimalData()
    return data ~= nil and data.remote ~= nil and data.keys ~= nil and data.offset ~= nil
end

function runway.purchase_animal(animal_data)
    -- Ensure we have dynamic purchase data (remote/keys/offset)
    local data = AnimalPurchaseData or OffsetFetcher.GetAnimalData()
    if not data or not data.remote or not data.keys or not data.offset then
        warn("[RunwayUtils] Cannot purchase: remote/keys not found")
        return false, "no_remote"
    end

    local uid = get_animal_uid(animal_data)
    if not uid then
        warn("[RunwayUtils] Cannot purchase: could not get animal UID")
        return false, "no_uid"
    end

    local server_time = Workspace:GetServerTimeNow() + data.offset

    task.spawn(function()
        data.remote:FireServer(server_time, data.keys[1], uid)
        data.remote:FireServer(server_time, data.keys[2], uid)
    end)

    return true, "sent"
end

return runway

end

-- Source: @src/utils/offset_fetcher
module_factories["@src/utils/offset_fetcher"] = function()
--!nocheck
--[[
    OffsetFetcher Module
    Dynamically resolves Remotes, Offsets, and Keys from game scripts.

    Settings:
        getgenv().ODS_DEBUG_MODE = true -- Enable verbose diagnostic logging
                                            (capability check, proto stats,
                                            decompile dumps, success/fail
                                            traces). Default: silent.
]]
local game_utils = bundle_require("@src/utils/game")
local game_deps = bundle_require("@src/utils/game_deps")
local debug_mode = bundle_require("@src/libs/debug_mode")

local ReplicatedStorage = game_utils.get_service("ReplicatedStorage")
local NetSafe = game_deps.NetSafe

-- Cache paths
local Controllers = ReplicatedStorage:WaitForChild("Controllers")

-- Target Scripts
local AnimalController = Controllers:FindFirstChild("AnimalController")

local OffsetFetcher = {}
local Cache = {}

-- // Logging //
-- All diagnostic output is gated on debug_mode.enabled so the module
-- runs silently and without string-building overhead in production. Set
-- getgenv().ODS_DEBUG_MODE = true before requiring this module to re-enable
-- verbose tracing.
local function log(...)
    if debug_mode.enabled then
        print("[OffsetFetcher]", ...)
    end
end

local function diag(...)
    if debug_mode.enabled then
        warn("[OffsetFetcher][diag]", ...)
    end
end

local function safe_typeof(v)
    local ok, t = pcall(typeof, v)
    if ok then return t end
    return type(v)
end

-- Executor capability check — only emits diagnostics when debug mode is on,
-- since the runtime cost is non-zero (multiple type() calls + table build).
local function check_capabilities()
    if not debug_mode.enabled then return end

    local caps = {
        getscriptclosure = type(getscriptclosure) == "function",
        ["debug.getprotos"] = type(debug) == "table" and type(debug.getprotos) == "function",
        ["debug.getproto"] = type(debug) == "table" and type(debug.getproto) == "function",
        ["debug.getconstants"] = type(debug) == "table" and type(debug.getconstants) == "function",
        ["debug.getupvalues"] = type(debug) == "table" and type(debug.getupvalues) == "function",
        ["debug.getupvalue"] = type(debug) == "table" and type(debug.getupvalue) == "function",
        ["debug.info"] = type(debug) == "table" and type(debug.info) == "function",
        getgenv = type(getgenv) == "function",
    }

    local missing = {}
    for name, present in pairs(caps) do
        if not present then
            table.insert(missing, name)
        end
    end

    if #missing > 0 then
        diag("Executor missing required functions:", table.concat(missing, ", "))
    else
        diag("Executor capability check: OK")
    end

    diag("Script instances:",
        "PlotClient=", PlotClient and PlotClient:GetFullName() or "nil",
        "| AnimalPrompt=", AnimalPrompt and AnimalPrompt:GetFullName() or "nil",
        "| AnimalController=", AnimalController and AnimalController:GetFullName() or "nil")
end

check_capabilities()

-- // Utils //
local function is_uuid(str)
    return type(str) == "string" and str:len() == 36 and str:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$")
end

local function get_all_protos_flat(func)
    local results = {}
    local MAX_DEPTH = 10

    local function collect(f, depth)
        if depth > MAX_DEPTH then return end
        table.insert(results, f)

        local ok, protos = pcall(debug.getprotos, f)
        if not ok or not protos then return end

        for i = 1, #protos do
            local ok2, proto = pcall(debug.getproto, f, i)
            if ok2 and proto then
                collect(proto, depth + 1)
            end
        end
    end

    collect(func, 0)
    log("Proto traversal found", #results, "protos")
    return results
end

-- // Game Net Interaction //
local function GetRemoteObject(uuid)
    local success, remote = pcall(function()
        if NetSafe and NetSafe.RemoteEvent then
            return NetSafe.RemoteEvent(uuid)
        end
        error("NetSafe not available")
    end)

    if not success then
        diag("GetRemoteObject: pcall errored for", uuid, "->", tostring(remote))
        return nil
    end

    if not remote then
        diag("GetRemoteObject: returned nil for", uuid)
        return nil
    end

    return remote
end

-- // Bytecode Scan Logic //
-- Looks for the "all-in-one-proto" pattern: GetServerTimeNow + 2 UUID keys +
-- a positive integer offset in the same proto, plus the remote UUID in
-- the main closure constants. Works on most executors. On hardened ones (e.g.
-- delta) numeric/UUID constants are stripped from bytecode and this scanner
-- returns nil — ScanFromSource is then used as the fallback path.
local function ScanForStandardPattern(scriptInstance, label)
    label = label or (scriptInstance and scriptInstance.Name) or "<unknown>"

    if not scriptInstance then
        diag("[", label, "] Script instance not found for scan.")
        return nil
    end

    if type(getscriptclosure) ~= "function"
        or type(debug) ~= "table"
        or type(debug.getconstants) ~= "function"
        or type(debug.getprotos) ~= "function"
        or type(debug.getproto) ~= "function" then
        diag("[", label, "] getscriptclosure unavailable on this executor")
        return nil
    end

    local ok_closure, mainClosure = pcall(getscriptclosure, scriptInstance)
    if not ok_closure then
        diag("[", label, "] getscriptclosure errored:", tostring(mainClosure))
        return nil
    end
    if type(mainClosure) ~= "function" then
        diag("[", label, "] getscriptclosure returned nil for", scriptInstance:GetFullName())
        return nil
    end

    local logicData = nil
    local allProtos = get_all_protos_flat(mainClosure)
    diag("[", label, "] proto traversal returned", #allProtos, "protos")

    -- Detailed accumulators are only built when debug mode is on. The hot path
    -- (find time + 2 UUID keys + positive integer) stays intact regardless.
    local DBG = debug_mode.enabled
    local proto_stats = DBG and { with_time = 0, with_keys = 0, with_nums = 0 } or nil
    local total_const_count, total_number_count = 0, 0
    local sample_numbers = DBG and {} or nil
    local sample_strings = DBG and {} or nil
    local sample_other_types = DBG and {} or nil

    if DBG and type(debug.getupvalues) == "function" then
        local ok_uv, upvalues = pcall(debug.getupvalues, mainClosure)
        if ok_uv and type(upvalues) == "table" then
            local uv_count, uv_numbers, uv_strings, uv_other = 0, {}, {}, {}
            for _, v in pairs(upvalues) do
                uv_count = uv_count + 1
                local vt = type(v)
                if vt == "number" then
                    if #uv_numbers < 24 then table.insert(uv_numbers, v) end
                elseif vt == "string" then
                    if #uv_strings < 16 and #v <= 60 then table.insert(uv_strings, v) end
                else
                    if #uv_other < 8 then table.insert(uv_other, vt) end
                end
            end
            local nums_str = {}
            for _, n in ipairs(uv_numbers) do table.insert(nums_str, tostring(n)) end
            diag("[", label, "] main upvalues count=", uv_count,
                "| numbers=", table.concat(nums_str, ","),
                "| strings=", table.concat(uv_strings, " | "),
                "| other_types=", table.concat(uv_other, ","))
        end
    end

    for proto_idx, func in ipairs(allProtos) do
        local ok_consts, consts = pcall(debug.getconstants, func)
        if not ok_consts or not consts then continue end

        local time, keys, nums = false, {}, {}
        local proto_const_count = 0
        local proto_all_const_dump = DBG and {} or nil

        for _, c in pairs(consts) do
            proto_const_count = proto_const_count + 1
            total_const_count = total_const_count + 1
            local ct = type(c)

            if ct == "number" then
                total_number_count = total_number_count + 1
                if DBG and #sample_numbers < 20 then table.insert(sample_numbers, c) end
            elseif ct == "string" then
                if DBG and #sample_strings < 12 and #c <= 40 then
                    table.insert(sample_strings, c)
                end
            else
                if DBG and #sample_other_types < 6 then
                    table.insert(sample_other_types, ct)
                end
            end

            if DBG and #proto_all_const_dump < 60 then
                local repr
                if ct == "string" then
                    repr = "\"" .. (#c > 50 and (c:sub(1, 50) .. "...") or c) .. "\""
                elseif ct == "number" then
                    repr = tostring(c)
                else
                    repr = "<" .. ct .. ">"
                end
                table.insert(proto_all_const_dump, repr)
            end

            if c == "GetServerTimeNow" then time = true end
            if is_uuid(c) then table.insert(keys, c) end
            -- Any positive integer: the proto is already narrowed down to
            -- GetServerTimeNow + two UUID keys. The offset is not guaranteed to
            -- be large -- PlotClient's FinishSteal has used +16 since 2026-08-30,
            -- which the old >20 cut-off silently dropped.
            if ct == "number" and c >= 1 and c % 1 == 0 then table.insert(nums, c) end
        end

        if DBG then
            if time then proto_stats.with_time = proto_stats.with_time + 1 end
            if #keys >= 2 then proto_stats.with_keys = proto_stats.with_keys + 1 end
            if #nums > 0 then proto_stats.with_nums = proto_stats.with_nums + 1 end

            if time or #keys >= 2 then
                diag("[", label, "] proto#", proto_idx,
                    "consts=", proto_const_count,
                    "time=", tostring(time),
                    "uuid_keys=", #keys,
                    "nums(int>=1)=", #nums)
                diag("[", label, "] proto#", proto_idx, "ALL CONSTS:",
                    table.concat(proto_all_const_dump, " "))
            end
        end

        if time and #keys >= 2 and #nums > 0 then
            table.sort(nums, function(a,b) return a > b end)
            logicData = { offset = nums[1], keys = {keys[1], keys[2]} }
            log("Found Logic Pattern in", scriptInstance.Name, "| Offset:", nums[1])
            break
        end
    end

    if not logicData then
        if DBG then
            diag("[", label, "] Failed to find logic pattern. Stats:",
                "protos=", #allProtos,
                "total_consts=", total_const_count,
                "total_numbers=", total_number_count,
                "with_time=", proto_stats.with_time,
                "with_>=2_uuid_keys=", proto_stats.with_keys,
                "with_nums=", proto_stats.with_nums)

            if #sample_numbers > 0 then
                local s = {}
                for _, n in ipairs(sample_numbers) do table.insert(s, tostring(n)) end
                diag("[", label, "] sample numbers:", table.concat(s, ","))
            end
            if #sample_strings > 0 then
                diag("[", label, "] sample strings:", table.concat(sample_strings, " | "))
            end
            if #sample_other_types > 0 then
                diag("[", label, "] sample non-num/non-str types:", table.concat(sample_other_types, ","))
            end
        end
        return nil
    end

    local remoteUUID = nil
    local ok_main_consts, mainConsts = pcall(debug.getconstants, mainClosure)
    if not ok_main_consts or not mainConsts then
        diag("[", label, "] debug.getconstants failed for main closure:", tostring(mainConsts))
        return nil
    end

    for _, c in pairs(mainConsts) do
        if is_uuid(c) then
            local is_key = false
            for _, k in pairs(logicData.keys) do if c == k then is_key = true break end end

            if not is_key then
                remoteUUID = c
                break
            end
        end
    end

    if not remoteUUID then
        diag("[", label, "] Failed to find Remote UUID")
        return nil
    end

    local remoteObj = GetRemoteObject(remoteUUID)
    if not remoteObj then
        diag("[", label, "] Failed to resolve Remote Object for UUID", remoteUUID)
        return nil
    end

    diag("[", label, "] OK | offset=", logicData.offset, "| remoteUUID=", remoteUUID)

    return {
        remote = remoteObj,
        offset = logicData.offset,
        keys = logicData.keys
    }
end

-- // Source-based scan //
-- Fallback for executors that strip integer constants and UUID strings from
-- bytecode (notably delta). They expose decompile() as a runtime call that
-- returns the live source of the script. We parse that source via Lua patterns
-- to recover the same offset/keys/remote-uuid trio. Still fully dynamic —
-- picks up game updates as long as the script's structure stays roughly the
-- same.

local UUID_PAT = "[%x][%x][%x][%x][%x][%x][%x][%x]%-[%x][%x][%x][%x]%-[%x][%x][%x][%x]%-[%x][%x][%x][%x]%-[%x][%x][%x][%x][%x][%x][%x][%x][%x][%x][%x][%x]"

local function get_decompiled_source(scriptInstance, label)
    local fn = rawget(_G, "decompile") or decompile
    if type(fn) ~= "function" then
        diag("[", label, "] decompile unavailable on this executor")
        return nil
    end

    local ok, source = pcall(fn, scriptInstance)
    if not ok then
        diag("[", label, "] decompile errored:", tostring(source))
        return nil
    end
    if type(source) ~= "string" or #source < 32 then
        diag("[", label, "] decompile returned empty/short source")
        return nil
    end

    return source
end

local function collect_remote_vars(source)
    local vars = {}
    for var, uuid in string.gmatch(
        source,
        'local%s+([%w_]+)%s*=%s*[%w_]+:RemoteEvent%s*%(%s*"(' .. UUID_PAT .. ')"%s*%)'
    ) do
        vars[var] = uuid
    end
    for var, uuid in string.gmatch(
        source,
        "local%s+([%w_]+)%s*=%s*[%w_]+:RemoteEvent%s*%(%s*'(" .. UUID_PAT .. ")'%s*%)"
    ) do
        vars[var] = uuid
    end
    return vars
end

-- The game scripts hoist FireServer through one of two aliases:
--   local <alias> = Instance.new("RemoteEvent").FireServer  (AnimalController, AnimalPrompt)
--   local <alias> = <existing_remote_var>.FireServer        (PlotClient — decompiler binds to first remote)
-- and then call:
--   <alias>(<remoteVar>, workspace:GetServerTimeNow() + N, "<uuid_a>", ...)
--   <remoteVar>:FireServer(workspace:GetServerTimeNow() + N, "<uuid_b>", ...)
-- We collect both shapes and group by (remoteVar, offset).
local function find_fire_pair(source)
    local fs_aliases = {}
    for var in string.gmatch(
        source,
        'local%s+([%w_]+)%s*=%s*Instance%.new%s*%(%s*"RemoteEvent"%s*%)%s*%.%s*FireServer'
    ) do
        fs_aliases[var] = true
    end
    for var in string.gmatch(
        source,
        'local%s+([%w_]+)%s*=%s*[%w_]+%s*%.%s*FireServer[^%w_]'
    ) do
        fs_aliases[var] = true
    end

    local matches = {}

    -- Method-style. Use .- (lazy any) instead of [^)]- because GetServerTimeNow()'s
    -- own ')' breaks the not-closing-paren class.
    for var, offset, key in string.gmatch(
        source,
        '([%w_]+):FireServer%s*%(.-GetServerTimeNow%s*%(%s*%)%s*%+%s*(%-?%d+)%s*,%s*"(' .. UUID_PAT .. ')"'
    ) do
        table.insert(matches, { var = var, offset = tonumber(offset), key = key, kind = "method" })
    end

    -- Hoisted-style via FireServer alias.
    for alias in pairs(fs_aliases) do
        local alias_pat = alias:gsub("(%W)", "%%%1")
        for var, offset, key in string.gmatch(
            source,
            alias_pat .. '%s*%(%s*([%w_]+)%s*,.-GetServerTimeNow%s*%(%s*%)%s*%+%s*(%-?%d+)%s*,%s*"(' .. UUID_PAT .. ')"'
        ) do
            table.insert(matches, { var = var, offset = tonumber(offset), key = key, kind = "hoisted" })
        end
    end

    -- Generic literal-FireServer hoisted form.
    for var, offset, key in string.gmatch(
        source,
        '[^%w_]FireServer%s*%(%s*([%w_]+)%s*,.-GetServerTimeNow%s*%(%s*%)%s*%+%s*(%-?%d+)%s*,%s*"(' .. UUID_PAT .. ')"'
    ) do
        table.insert(matches, { var = var, offset = tonumber(offset), key = key, kind = "hoisted_literal" })
    end

    local groups = {}
    for _, m in ipairs(matches) do
        local k = m.var .. "|" .. tostring(m.offset)
        groups[k] = groups[k] or { var = m.var, offset = m.offset, keys = {} }
        local g = groups[k]
        if m.kind == "method" then
            g.keys[2] = m.key
        else
            g.keys[1] = m.key
        end
    end

    for _, g in pairs(groups) do
        if g.keys[1] and g.keys[2] and g.keys[1] ~= g.keys[2] then
            return g
        end
    end

    return nil
end

local function ScanFromSource(scriptInstance, label)
    label = label or (scriptInstance and scriptInstance.Name) or "<unknown>"

    if not scriptInstance then
        diag("[", label, "] source-scan: script instance missing")
        return nil
    end

    local source = get_decompiled_source(scriptInstance, label)
    if not source then return nil end

    diag("[", label, "] source-scan: decompiled source length=", #source)

    local pair = find_fire_pair(source)
    if not pair then
        diag("[", label, "] source-scan: no FireServer pair matching the steal pattern")

        if debug_mode.enabled then
            local dumped = 0
            for start_idx in string.gmatch(source, "()FireServer") do
                if dumped >= 6 then break end
                local from = math.max(1, start_idx - 60)
                local to = math.min(#source, start_idx + 240)
                local snippet = source:sub(from, to):gsub("[\r\n]+", " | "):gsub("%s+", " ")
                diag("[", label, "] FireServer ctx#", dumped + 1, ":", snippet)
                dumped = dumped + 1
            end

            if dumped == 0 then
                diag("[", label, "] no FireServer substring at all in decompiled source")
                local head = source:sub(1, 400):gsub("[\r\n]+", " | ")
                diag("[", label, "] source head:", head)
            end
        end

        return nil
    end

    local vars = collect_remote_vars(source)
    local remoteUUID = vars[pair.var]
    if not remoteUUID then
        diag("[", label, "] source-scan: remote var", pair.var, "has no Net:RemoteEvent declaration")
        return nil
    end

    local remoteObj = GetRemoteObject(remoteUUID)
    if not remoteObj then
        diag("[", label, "] source-scan: failed to resolve Remote", remoteUUID)
        return nil
    end

    diag("[", label, "] source-scan OK | offset=", pair.offset,
        "| remoteUUID=", remoteUUID, "| var=", pair.var)

    return {
        remote = remoteObj,
        offset = pair.offset,
        keys = { pair.keys[1], pair.keys[2] },
    }
end

-- // Public Methods //

function OffsetFetcher.GetAnimalData()
    if Cache.AnimalData then return Cache.AnimalData end

    diag("GetAnimalData: starting scan")

    local data = ScanForStandardPattern(AnimalController, "AnimalData/AnimalController")

    if not data then
        diag("GetAnimalData: bytecode scan failed, trying source-scan")
        data = ScanFromSource(AnimalController, "AnimalData/AnimalController")
    end

    if data then
        log("AnimalData: OK")
    else
        diag("GetAnimalData: FAILED (both scanners)")
    end

    Cache.AnimalData = data
    return data
end

function OffsetFetcher.ClearCache()
    Cache = {}
    log("Cache cleared")
end

return OffsetFetcher

end

-- Source: @src/libs/debug_mode
module_factories["@src/libs/debug_mode"] = function()
return { enabled = false }

end

local auto_buy_runway = bundle_require("@src/standalone/auto_buy_runway_spam")

-- Optional diagnostic helper. No executor brand is required or assumed.
function auto_buy_runway.get_executor_info()
    if type(identifyexecutor) ~= "function" then
        return "unknown", nil
    end
    local ok, name, version = pcall(identifyexecutor)
    if not ok then
        return "unknown", nil
    end
    return name, version
end

return auto_buy_runway

end

-- BEGIN RUNWAY AUTO BUY TEST CONTROLLER
do
    local api, loading, wanted, lastError = nil, false, false, nil
    local listeners = {}
    local previousRoadHidden = nil
    local previousAutoTP = nil
    _G.TekAutoBuyTPBlocked = false
    Config.AutoBuyEnabled = false
    _G.TekAutoBuy = false
    Config.RunwayBuyDistance = math.clamp(tonumber(Config.RunwayBuyDistance) or 20,0,100)
    Config.RunwayBuyAttempts = math.clamp(math.floor(tonumber(Config.RunwayBuyAttempts) or 1),1,50)
    Config.RunwayBuyFollow = Config.RunwayBuyFollow ~= false
    Config.RunwayBuyHover = math.clamp(tonumber(Config.RunwayBuyHover) or 9,0,20)
    Config.RunwayBuyMode="nearest"

    local function running()
        return api ~= nil and api.is_enabled() == true
    end
    local function emit()
        Config.AutoBuyEnabled = running()
        _G.TekAutoBuy = Config.AutoBuyEnabled
        for listener in pairs(listeners) do pcall(listener) end
    end
    local function applySettings()
        if not api then return end
        api.set_runway_purchase_distance(Config.RunwayBuyDistance)
        api.set_runway_spam_attempts(Config.RunwayBuyAttempts)
        api.set_target_mode(Config.RunwayBuyMode)
        api.set_follow_enabled(Config.RunwayBuyFollow)
        api.set_follow_height(Config.RunwayBuyHover)
    end
    local function showRoad()
        if type(_G.TekApplyRoadVisibility) ~= "function" then return end
        if previousRoadHidden == nil then previousRoadHidden = _G.TekHideRoadBrainrots == true end
        _G.TekHideRoadBrainrots = false
        _G.TekApplyRoadVisibility()
    end
    local function restoreRoad()
        if previousRoadHidden == nil then return end
        _G.TekHideRoadBrainrots = previousRoadHidden
        previousRoadHidden = nil
        if _G.TekApplyRoadVisibility then pcall(_G.TekApplyRoadVisibility) end
    end
    local function blockTP()
        _G.TekAutoBuyTPBlocked = true
        _G.TekClickTPPending = nil
        if previousAutoTP == nil then previousAutoTP = _G.TekAutoTP ~= false end
        _G.TekTPStop = true
        _G.ElysiumTPStop = true
        if type(_G.TekStopTeleport) == "function" then pcall(_G.TekStopTeleport) end
        if type(_G.TekSetAutoTP) == "function" then _G.TekSetAutoTP(false) end
    end
    local function restoreTP()
        _G.TekAutoBuyTPBlocked = false
        if previousAutoTP == nil then return end
        local value = previousAutoTP
        previousAutoTP = nil
        if _G.TekSetAutoTP then pcall(_G.TekSetAutoTP,value) end
    end
    local function fail(err)
        lastError = tostring(err):gsub("[\r\n]+"," ")
        wanted = false
        if api then pcall(api.set_enabled,false) end
        restoreRoad()
        restoreTP()
        warn("[Runway AutoBuy TEST] " .. lastError)
        emit()
    end
    local function setEnabled(value)
        wanted = value == nil and not wanted or value == true
        lastError = nil
        if not wanted then
            if api then pcall(api.set_enabled,false) end
            restoreRoad()
            restoreTP()
            emit()
            return
        end
        if running() then emit(); return end
        if _G.TekPrepareMovementReset then pcall(_G.TekPrepareMovementReset) end
        _G.TekMovementFault=nil
        blockTP()
        if loading then emit(); return end
        loading = true
        emit()
        task.spawn(function()
            local ok, err = pcall(function()
                if not api then api = createRunwayAutoBuy() end
                if not wanted then return end
                applySettings()
                if not api.is_ready() then error("Purchase module is not ready; try again later.",0) end
                if not wanted then return end
                showRoad()
                api.set_enabled(true)
            end)
            loading = false
            if not ok then fail(err); return end
            emit()
        end)
    end
    local controls = {}
    function controls.GetDiagnostics()
        if api and api.get_diagnostics then return api.get_diagnostics() end
        return {phase="off",purchase_distance=Config.RunwayBuyDistance,sent=0}
    end
    function controls.GetState()
        if lastError then return "ERROR" end
        if wanted and loading then return "LOADING" end
        if wanted and controls.GetDiagnostics().last_error then return "ERROR" end
        return running() and "ON" or "OFF"
    end
    function controls.GetStatusText()
        if lastError then return "Error: " .. lastError end
        if wanted and loading then return "Loading purchase module..." end
        if not running() then return "v2 | Ready, range " .. tostring(Config.RunwayBuyDistance) end
        local diag=controls.GetDiagnostics()
        if diag.phase=="sending" then
            return tostring(diag.target or "Target") .. " | Requests: " .. tostring(diag.sent or 0)
        end
        if diag.phase=="following" then return "Following: " .. tostring(diag.target or "brainrot") end
        local messages={paused_obstacle="Obstacle: follow released",paused_stuck="Stuck: follow released",
            paused_root_locked="Root locked: follow released",paused_target_far="Target moved too far",
            paused_ragdoll="Paused during ragdoll",recovering_ragdoll="Waiting for character recovery",
            paused_tp="Finishing current teleport",paused_reset="Waiting for reset",
            paused_carry="Paused while carrying",paused_pickup="Waiting for pickup to finish",
            no_character="Waiting for character",no_animals="No runway brainrots found",
            no_position="Target position unavailable",starting="Waiting for runway scan"}
        if diag.phase=="no_nearby_target" or diag.phase=="out_of_range" then
            local distance=tonumber(diag.distance) or tonumber(diag.nearest_distance)
            if distance then return string.format("Nearest: %.0f / %.0f studs",distance,Config.RunwayBuyDistance) end
            return "No target in purchase range"
        end
        return messages[diag.phase] or "Waiting for runway target"
    end
    function controls.GetLastError() return lastError end
    function controls.IsEnabled() return running() end
    function controls.SetEnabled(value) setEnabled(value) end
    function controls.SetDistance(value)
        Config.RunwayBuyDistance = math.clamp(tonumber(value) or 20,0,100)
        applySettings(); pcall(SaveConfig); emit()
        return Config.RunwayBuyDistance
    end
    function controls.SetAttempts(value)
        Config.RunwayBuyAttempts = math.clamp(math.floor(tonumber(value) or 1),1,50)
        applySettings(); pcall(SaveConfig); emit()
        return Config.RunwayBuyAttempts
    end
    function controls.SetMode(value)
        Config.RunwayBuyMode = "nearest"
        applySettings(); pcall(SaveConfig); emit()
    end
    function controls.SetFollow(value)
        Config.RunwayBuyFollow=value==true
        if api then api.set_follow_enabled(Config.RunwayBuyFollow) end
        pcall(SaveConfig);emit()
    end
    function controls.SetHover(value)
        Config.RunwayBuyHover=math.clamp(tonumber(value) or 9,0,20)
        if api then api.set_follow_height(Config.RunwayBuyHover) end
        pcall(SaveConfig);emit()
        return Config.RunwayBuyHover
    end
    local monitoring=false
    function controls.Subscribe(callback)
        listeners[callback] = true
        pcall(callback)
        if not monitoring then
            monitoring=true
            task.spawn(function()
                while _G.TekRunwayAutoBuyTest==controls and next(listeners)~=nil do
                    task.wait(0.3)
                    local diag=controls.GetDiagnostics()
                    if wanted and not loading and diag.last_error then fail(diag.last_error)
                    else emit() end
                end
                monitoring=false
            end)
        end
        return function() listeners[callback] = nil end
    end
    _G.TekRunwayAutoBuyTest = controls
    _G.TekReleaseAutoBuyFollow = function()
        if api and api.suspend_follow then api.suspend_follow(0.75) end
    end
    _G.TekSetAutoBuy = setEnabled
    _G.TekToggleAutoBuy = function() setEnabled() end
    UserInputService.InputBegan:Connect(function(input,processed)
        if processed or UserInputService:GetFocusedTextBox() or _G.Tek_KeybindListening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode.Name == tostring(Config.AutoBuyKey or "K") then setEnabled() end
    end)
end
-- END RUNWAY AUTO BUY TEST CONTROLLER


_G.MiniHubSetPanelVis = function(name, on)
    Config.Visibilities[name] = on; SaveConfig()
    if panels[name] then panels[name].Visible = on end
end

local CARPET_TICK, ANTI_RAG_TICK = 0.066, 0.066
local antiRagdollConn
local _antiRagDescConns = {}
local function isRagdolled()
    local c = LocalPlayer.Character; if not c then return false end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return false end
    local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
    if endTime and (endTime - Workspace:GetServerTimeNow()) > 0 then
        _G.TekRagdollObservedUntil = math.max(tonumber(_G.TekRagdollObservedUntil) or 0, endTime)
    end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then return true end
    return endTime and (endTime - Workspace:GetServerTimeNow()) > 0
end
_G.isCloning = false
local function instantClone()
    if _G.isCloning then return end
    _G.isCloning = true
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local cloner = LocalPlayer.Backpack:FindFirstChild("Quantum Cloner") or character:FindFirstChild("Quantum Cloner")
        if cloner then
            if cloner.Parent ~= character then humanoid:EquipTool(cloner); task.wait() end
            cloner:Activate()
            task.wait(0.05)
            local tpButton = PlayerGui:FindFirstChild("ToolsFrames") and PlayerGui.ToolsFrames:FindFirstChild("QuantumCloner") and PlayerGui.ToolsFrames.QuantumCloner:FindFirstChild("TeleportToClone")
            if tpButton then
                tpButton.Visible = true
                if typeof(firesignal) == "function" then
                    firesignal(tpButton.MouseButton1Up)
                else
                    local inset = GuiService:GetGuiInset(); local pos = tpButton.AbsolutePosition + tpButton.AbsoluteSize / 2 + inset
                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1); task.wait()
                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                end
            end
        end
    end
    _G.isCloning = false
end
_G.TekInstantClone = instantClone
local PS_PLACE_ID, PS_LINK_CODE, KICK_MSG = 109983668079237, "85781667033108162011177105658744", "\nBIR PRO"
local autoKickFired, autoKickConns = false, {}
local function extractPrivateServerCode(link)
    link = tostring(link or ""):match("^%s*(.-)%s*$")
    if link == "" then return nil end
    if not string.find(link, "://", 1, true) then return link end
    return link:match("[?&]privateServerLinkCode=([^&]+)")
        or link:match("[?&]linkCode=([^&]+)")
        or link:match("[?&]code=([^&]+)")
end
local function doAutoKick()
    if autoKickFired then return end; autoKickFired = true
    local configuredLink = tostring(Config.PrivateServerLink or ""):match("^%s*(.-)%s*$")
    local configuredCode = extractPrivateServerCode(configuredLink)
    if configuredLink ~= "" and not configuredCode then
        -- -- ShowNotification("AUTO KICK", "Lien de serveur privé invalide")
        pcall(function() LocalPlayer:Kick(KICK_MSG) end)
        return
    end
    local targetCode = configuredCode or PS_LINK_CODE
    if not pcall(function() game:GetService("ExperienceService"):LaunchExperience({placeId=PS_PLACE_ID,linkCode=targetCode}) end) then
        pcall(function() LocalPlayer:Kick(KICK_MSG) end)
    end
end
local function startAutoKick()
    for _, c in ipairs(autoKickConns) do pcall(function() c:Disconnect() end) end; autoKickConns = {}
    table.insert(autoKickConns, PlayerGui.DescendantAdded:Connect(function(gui)
        if not Config.AutoKickEnabled or autoKickFired then return end
        local txt = (gui:IsA("TextLabel") or gui:IsA("TextButton")) and gui.Text
        if txt and string.find(txt, "You stole") then doAutoKick() end
    end))
end
local function stopAutoKick() for _, c in ipairs(autoKickConns) do pcall(function() c:Disconnect() end) end; autoKickConns = {} end
_G.Tek_StartAutoKick = function() autoKickFired = false; startAutoKick() end
_G.Tek_StopAutoKick  = stopAutoKick
if Config.AutoKickEnabled then task.spawn(function() pcall(_G.Tek_StartAutoKick) end) end

_G.Tek_DoKick = function()

    task.spawn(function()
        pcall(function() game:Shutdown() end)
        pcall(function() LocalPlayer:Kick("") end)
    end)
end
_G.Tek_ModerationKick = function()
    task.spawn(function()
        pcall(function() LocalPlayer:Kick(KICK_MSG) end)
    end)
end

local function _posInsidePartsXZ(pos, parts, margin)
    margin = margin or 2
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local cf = part.CFrame
            local size = part.Size

            local local3 = cf:PointToObjectSpace(pos)
            local hx = size.X / 2 + margin
            local hz = size.Z / 2 + margin
            if math.abs(local3.X) <= hx and math.abs(local3.Z) <= hz then
                return true
            end
        end
    end
    return false
end


do
    local lastJump = 0
    RunService.Heartbeat:Connect(function()
        if Config.InfiniteJump ~= true then return end
        if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
        local now = tick(); if now - lastJump < 0.033 then return end
        local c = LocalPlayer.Character; if not c then return end
        local hrp, hum = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChild("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        lastJump = now
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
    end)
end

do
    local FACE_SPEED = 8
    local _ownerPlayer, _ownerPlot = nil, nil
    local _autoRotateSaved = nil

    local function _resolveOwner(o)
        if o == nil then return nil end
        if typeof(o) == "Instance" then
            if o:IsA("Player") then return o end
            return Players:FindFirstChild(tostring(o.Name or ""))
        end
        if type(o) == "table" then
            local n = rawget(o, "Name")
            if n then return Players:FindFirstChild(tostring(n)) end
            local uid = rawget(o, "UserId")
            if uid then return Players:GetPlayerByUserId(uid) end
            return nil
        end
        if type(o) == "number" then return Players:GetPlayerByUserId(o) end
        if type(o) == "string" then return Players:FindFirstChild(o) end
        return nil
    end

    local function _ownerOfPlot(plotName)
        if not plotName then return nil end
        local ch = _G.Tek_GetPlotChannel and _G.Tek_GetPlotChannel(plotName)
        if not ch or not _G.Tek_ChannelGet then return nil end
        return _resolveOwner(_G.Tek_ChannelGet(ch, "Owner"))
    end

    local function _carrying()
        local st = _G.Tek_StealStatus
        if st and (st.carrying or st.hasPet) then return true end
        return LocalPlayer:GetAttribute("HasBrainrot") == true
            or LocalPlayer:GetAttribute("Stealing") == true
    end

    local function _restoreAutoRotate(hum)
        if _autoRotateSaved == nil then return end
        if hum then pcall(function() hum.AutoRotate = _autoRotateSaved end) end
        _autoRotateSaved = nil
    end

    RunService.Heartbeat:Connect(function(dt)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local st = _G.Tek_StealStatus
        local tgt = st and (st.visualTarget or st.target)
        if tgt and tgt.plot then _ownerPlot = tgt.plot end

        if _G.Tek_FollowOwner ~= true or not _carrying() or _G.TekIsTeleporting
            or not hrp or not hum or hum.Health <= 0 then
            if not _carrying() then _ownerPlayer, _ownerPlot = nil, nil end
            _restoreAutoRotate(hum)
            return
        end

        if not _ownerPlayer or not _ownerPlayer.Parent then
            _ownerPlayer = _ownerOfPlot(_ownerPlot)
        end
        local oc = _ownerPlayer and _ownerPlayer.Character
        local ohrp = oc and oc:FindFirstChild("HumanoidRootPart")
        if not ohrp then _restoreAutoRotate(hum); return end

        if _autoRotateSaved == nil then
            _autoRotateSaved = hum.AutoRotate
            pcall(function() hum.AutoRotate = false end)
        end

        local flat = Vector3.new(ohrp.Position.X - hrp.Position.X, 0, ohrp.Position.Z - hrp.Position.Z)
        if flat.Magnitude < 0.5 then return end

        local wanted = math.atan2(-flat.X, -flat.Z) + math.pi
        local _, cur = hrp.CFrame:ToEulerAnglesYXZ()
        local diff = (wanted - cur + math.pi) % (2 * math.pi) - math.pi
        local step = math.clamp(diff, -FACE_SPEED * dt, FACE_SPEED * dt)
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, cur + step, 0)
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
end

do
    _G.TekAutoGrabRadius = tonumber(Config.AutoGrabRadius) or 95
    _G.TekStealCommitRange = tonumber(Config.AutoGrabCommitRange) or 10
    _G.TekStealEntryDelay = tonumber(Config.AutoGrabEntryDelay) or 0.30
    _G.TekStealHoldMaxTotal = tonumber(Config.AutoGrabHoldMaxTotal) or 20
    _G.TekStealUseFPP = Config.AutoGrabUseFPP ~= false

    local _adc, _addc, _adhbc
    local function _adHarden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    end
    local function _adRevive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    local function _adBind()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        _adHarden(hum)
        if _adc   then pcall(function() _adc:Disconnect() end) end
        if _addc  then pcall(function() _addc:Disconnect() end) end
        if _adhbc then pcall(function() _adhbc:Disconnect() end) end
        _adc  = hum:GetPropertyChangedSignal("Health"):Connect(function() if not _G.Tek_IsResetting and hum.Health <= 0 then _adRevive(hum) end end)
        _addc = hum.Died:Connect(function() if not _G.Tek_IsResetting then _adRevive(hum) end end)
        local _lh = 0
        _adhbc = RunService.Heartbeat:Connect(function()
            if not hum or not hum.Parent then return end
            if _G.Tek_IsResetting then return end
            local now = os.clock(); if now - _lh >= 0.5 then _lh = now; _adHarden(hum) end
            if hum.Health <= 0 then _adRevive(hum) end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end)
    end

    _G.Tek_AntiDieOff = function()
        if _adc   then pcall(function() _adc:Disconnect() end)   _adc   = nil end
        if _addc  then pcall(function() _addc:Disconnect() end)  _addc  = nil end
        if _adhbc then pcall(function() _adhbc:Disconnect() end) _adhbc = nil end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
        pcall(function() hum.BreakJointsOnDeath = true end)
    end
    _G.Tek_AntiDieOn = _adBind

-- BEGIN ELYSIUM INVIS STEAL PORT
    -- One controller owns both the Elysium and the updated hub's public APIs.
    function _G.ElysiumInvisDepthSync()
        _G.ElysiumInvisDepth = math.clamp(tonumber(Config.SinkSliderValue) or 7, 0, 10)
        _G.ElysiumInvisAngle = math.clamp(tonumber(Config.InvisStealAngle) or 180, 0, 360)
        _G.ElysiumInvisAuto = Config.AutoInvisDuringSteal == true
        _G.ElysiumInvisAutoDelay = Config.InvisDelayEnabled == true
            and math.max(0, tonumber(Config.InvisDelayMs) or 500) / 1000 or 0
        _G.TekInvisDepth, _G.SinkSliderValue = _G.ElysiumInvisDepth, _G.ElysiumInvisDepth
        _G.TekInvisAngle, _G.InvisStealAngle = _G.ElysiumInvisAngle, _G.ElysiumInvisAngle
        _G.AutoInvisDuringSteal = _G.ElysiumInvisAuto
    end
    _G.ElysiumInvisDepthSync()
;(function()
    local RS = RunService
    local LP = LocalPlayer
    local active, start, stop, armed = false, nil, nil, false
    local userOff = false
    local realHRP, cloneHRP, track, hip, origT, invisChar
    local savedStates, savedRootCollision, stateHumanoid
    _G.TekGetPhysicalRoot=function()
        return realHRP or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    end
    local ragdollResumeAt = 0
    local function recovering(hum)
        if not hum or hum.Health <= 0 or _G.Tek_IsResetting == true then return true end
        local ragdollEnd = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
        if ragdollEnd > Workspace:GetServerTimeNow() then return true end
        local state = hum:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end

    local function boot()
        if start then return end
        local conns = {}
        local stuck, restarting = false, false
        local function add(c) conns[#conns + 1] = c end

        local function rewire(char, from, to)
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("Weld") or v:IsA("Motor6D") then
                    if v.Part0 == from then v.Part0 = to end
                    if v.Part1 == from then v.Part1 = to end
                end
            end
        end

        local function animTrick(char, hum)
            if not (char and hum and hum.Health > 0) then return end
            local anim = Instance.new("Animation")
            anim.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
            local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
            track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = true
            track:Play(0, 1, 0)
            anim:Destroy()
            add(track.Stopped:Connect(function()
                if active then animTrick(char, hum) end
            end))
            task.defer(function()
                if not track then return end
                track.TimePosition = 0.7
                task.delay(0.1, function()
                    if track then track:AdjustSpeed(math.huge) end
                end)
            end)
        end

        stop = function()
            active, stuck = false, false
            _G.ElysiumInvisActive = false
            _G.TekInvisActive, _G.invisibleStealEnabled = false, false
            if _G.Tek_InvisButtonSync then pcall(_G.Tek_InvisButtonSync, false) end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            conns = {}
            if origT then
                for part, value in pairs(origT) do
                    if part and part.Parent then
                        pcall(function() part.LocalTransparencyModifier = value end)
                    end
                end
                origT = nil
            end
            if track then
                pcall(function()
                    track:AdjustSpeed(1)
                    track:Stop(0)
                    track:Destroy()
                end)
                track = nil
            end
            local char = invisChar
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if realHRP and realHRP:IsDescendantOf(game) and hum and LP.Character == char then
                local tmp = Instance.new("Model")
                tmp.Parent = game
                char.Parent = tmp
                realHRP.Parent = char
                char.PrimaryPart = realHRP
                char.Parent = workspace
                realHRP.CanCollide = savedRootCollision == true
                rewire(char, cloneHRP, realHRP)
                if cloneHRP then
                    local at = cloneHRP.CFrame
                    cloneHRP:Destroy()
                    cloneHRP = nil
                    -- The visible clone can have drifted into an unrelated position.
                    -- Restore the actual root at its current position, upright.
                    realHRP.CFrame = CFrame.new(realHRP.Position) * at.Rotation
                end
                hum.HipHeight = hip or 0
                tmp:Destroy()
            end
            if stateHumanoid and stateHumanoid.Parent and savedStates then
                for state,enabled in pairs(savedStates) do
                    pcall(function() stateHumanoid:SetStateEnabled(state,enabled) end)
                end
            end
            savedStates,savedRootCollision,stateHumanoid=nil,nil,nil
            realHRP, cloneHRP, invisChar = nil, nil, nil
        end

        start = function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or active or recovering(hum) or os.clock() < ragdollResumeAt then return false end
            local stealing = LP:GetAttribute("Stealing") == true
                or (char and char:GetAttribute("Stealing") == true)
                or (LP:GetAttribute("StealingIndex") ~= nil and tostring(LP:GetAttribute("StealingIndex")) ~= "")
            if not stealing then
                _G.TekInvisWhy = "not stealing"
                return false
            end

            local folder = workspace:FindFirstChild(LP.Name)
            if folder then
                for _, name in ipairs({ "DoubleRig", "Constraints" }) do
                    local item = folder:FindFirstChild(name)
                    if item then item:Destroy() end
                end
            end
            hip = hum.HipHeight
            realHRP = char:FindFirstChild("HumanoidRootPart")
            if not (realHRP and realHRP.Parent) then return false end
            savedRootCollision=realHRP.CanCollide
            savedStates={};stateHumanoid=hum
            for _,stateName in ipairs({"FallingDown","Ragdoll"}) do
                local state=Enum.HumanoidStateType[stateName]
                savedStates[state]=hum:GetStateEnabled(state)
                hum:SetStateEnabled(state,false)
            end

            local tmp = Instance.new("Model")
            tmp.Parent = game
            char.Parent = tmp
            cloneHRP = realHRP:Clone()
            cloneHRP.Parent = char
            realHRP.Parent = workspace.CurrentCamera
            cloneHRP.CFrame = realHRP.CFrame
            char.PrimaryPart = cloneHRP
            char.Parent = workspace
            rewire(char, realHRP, cloneHRP)
            tmp:Destroy()

            invisChar = char
            active = true
            _G.ElysiumInvisActive = true
            _G.TekInvisActive, _G.invisibleStealEnabled = true, true
            if _G.Tek_InvisButtonSync then pcall(_G.Tek_InvisButtonSync, true) end
            add(hum.StateChanged:Connect(function(_, state)
                if state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown
                    or state == Enum.HumanoidStateType.GettingUp then
                    ragdollResumeAt = os.clock() + 1
                    task.defer(function() if active and stop then pcall(stop) end end)
                end
            end))
            animTrick(char, hum)
            origT = {}
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    origT[part] = part.LocalTransparencyModifier
                    part.LocalTransparencyModifier = 1
                end
            end
            add(char.DescendantAdded:Connect(function(desc)
                if not (active and desc:IsA("BasePart")) then return end
                if origT and origT[desc] == nil then origT[desc] = desc.LocalTransparencyModifier end
                pcall(function() desc.LocalTransparencyModifier = 1 end)
            end))

            local lastTarget, grace, protectTick = nil, 60, 0
            add(RS.PreSimulation:Connect(function()
                if not active then return end
                if _G.Tek_IsResetting or _G.__elysiumResetBusy or recovering(hum) then
                    ragdollResumeAt=os.clock()+1
                    stop()
                    return
                end
                protectTick += 1
                if _G.AntiDieDisabled ~= true and hum.Parent and protectTick % 3 == 0 then
                    if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
                if not (realHRP and realHRP.Parent) then return end
                local base = cloneHRP
                if not (base and base.Parent) then return end

                if grace > 0 then
                    grace -= 1
                elseif not stuck and lastTarget and (realHRP.Position - lastTarget).Magnitude > 3.5 then
                    stuck = true
                    if not restarting then
                        task.spawn(function()
                            restarting = true
                            -- Temporary pause only. Do NOT set userOff — that permanently
                            -- disabled auto invis after one lag/stuck event.
                            ragdollResumeAt = os.clock() + 1.25
                            if type(_G.TekReleaseAutoBuyFollow) == "function" then pcall(_G.TekReleaseAutoBuyFollow) end
                            stop()
                            restarting = false
                        end)
                    end
                end
                if not (active and realHRP and realHRP.Parent and base.Parent) then return end

                -- Elysium Drop needs temporary ownership of the server root.
                if _G.ElysiumDropFlingActive == true then
                    realHRP.CanCollide = false
                    if realHRP.Parent ~= workspace.CurrentCamera then realHRP.Parent = workspace.CurrentCamera end
                    return
                end

                local depth = tonumber(_G.ElysiumInvisDepth) or 7
                local rotation = tonumber(_G.ElysiumInvisAngle) or 180
                local sink = 0.01 + (math.clamp(depth, 0, 10) / 10) * 0.19
                local cf = base.CFrame - Vector3.new(0, hum.HipHeight + (base.Size.Y / 2) - 1 + sink, 0)
                realHRP.CFrame = cf * CFrame.Angles(math.rad(rotation), 0, 0)
                realHRP.AssemblyLinearVelocity = base.AssemblyLinearVelocity
                realHRP.CanCollide = false
                if realHRP.Parent ~= workspace.CurrentCamera then realHRP.Parent = workspace.CurrentCamera end
                lastTarget = cf.Position
            end))
            add(LP.CharacterAdded:Connect(function()
                if active then stop() end
            end))
            return true
        end
    end

    local function isStealingNow()
        local char = LP.Character
        if LP:GetAttribute("Stealing") == true then return true end
        if char and char:GetAttribute("Stealing") == true then return true end
        local idx = LP:GetAttribute("StealingIndex")
        if idx == nil and char then idx = char:GetAttribute("StealingIndex") end
        return idx ~= nil and tostring(idx) ~= ""
    end

    local function tryStart()
        if _G.ElysiumInvisAuto ~= true or userOff then return end
        if active or armed or _G.ElysiumDropPending == true or os.clock() < ragdollResumeAt then return end
        if not isStealingNow() then return end
        local char = LP.Character
        if recovering(char and char:FindFirstChildOfClass("Humanoid")) then return end
        armed = true
        task.delay(tonumber(_G.ElysiumInvisAutoDelay) or 0.5, function()
            armed = false
            if _G.ElysiumInvisAuto ~= true or userOff or _G.ElysiumDropPending == true then return end
            if active or not isStealingNow() or os.clock() < ragdollResumeAt then return end
            local current = LP.Character
            if recovering(current and current:FindFirstChildOfClass("Humanoid")) then return end
            boot()
            local ok, res = pcall(start)
            if not ok then
                _G.TekInvisWhy = "start error: " .. tostring(res)
            elseif res == false then
                _G.TekInvisWhy = _G.TekInvisWhy or "start returned false"
            else
                _G.TekInvisWhy = "ok"
            end
        end)
    end

    _G.ElysiumInvisStart = function()
        boot()
        if active then return true end
        -- brief retry: Stealing attribute can lag 1-2 frames behind the grab
        for _ = 1, 8 do
            if isStealingNow() then break end
            task.wait(0.05)
        end
        local ok, result = pcall(start)
        if not ok then
            _G.TekInvisWhy = "start error: " .. tostring(result)
            return false
        end
        if result then _G.TekInvisWhy = "ok" end
        return result and true or false
    end
    _G.ElysiumInvisStop = function()
        armed = false
        if active and stop then pcall(stop) end
    end
    _G.TekPrepareMovementReset = function()
        armed=false
        ragdollResumeAt=os.clock()+2
        if type(_G.TekReleaseAutoBuyFollow)=="function" then pcall(_G.TekReleaseAutoBuyFollow) end
        if active and stop then stop() end
    end
    _G.ElysiumInvisClearUserOff = function()
        userOff = false
    end
    _G.ElysiumInvisToggle = function()
        if active then
            userOff = true
            _G.ElysiumInvisStop()
        else
            userOff = false
            _G.ElysiumInvisStart()
        end
    end
    _G.ElysiumSetInvisManual = function(wantEnabled)
        if wantEnabled == true then
            userOff = false
            return _G.ElysiumInvisStart()
        end
        userOff = true
        _G.ElysiumInvisStop()
        return true
    end
    _G.ElysiumGetInvisRealRoot = function()
        if active and realHRP and realHRP.Parent then return realHRP end
        return nil
    end
    _G.ElysiumGetInvisVisibleRoot = function()
        if active and cloneHRP and cloneHRP.Parent then return cloneHRP end
        return nil
    end
    _G.ElysiumInvisSync = function()
        if _G.ElysiumDropPending == true or not isStealingNow() then
            armed = false
            if active and stop then pcall(stop) end
            return
        end
        tryStart()
    end

    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not isStealingNow() then
            armed = false
            -- clear userOff when steal ends so next steal can auto-invis again
            userOff = false
            if active and stop then pcall(stop) end
            return
        end
        tryStart()
    end)
    pcall(function()
        LP:GetAttributeChangedSignal("StealingIndex"):Connect(function()
            if isStealingNow() then tryStart()
            else
                armed = false
                userOff = false
                if active and stop then pcall(stop) end
            end
        end)
    end)
    task.defer(_G.ElysiumInvisSync)
end)()
    _G.toggleInvisibleSteal = _G.ElysiumInvisToggle
    _G.TekDisableInvisibleSteal = _G.ElysiumInvisStop
    _G.TekGetInvisPhysicalRoot = function(expectedChar)
        if expectedChar and LocalPlayer.Character ~= expectedChar then return nil end
        return _G.ElysiumGetInvisRealRoot()
    end
    _G.Tek_SetInvisBtnSync = function(fn)
        if type(fn) ~= "function" then return end
        _G.Tek_InvisButtonSync = fn
        pcall(fn, _G.ElysiumInvisActive == true)
    end
    _G._invIsEnabled = function() return _G.ElysiumInvisActive == true end
    LocalPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
        local untilTime = tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0
        if untilTime > Workspace:GetServerTimeNow() then _G.ElysiumInvisStop() end
    end)
    task.spawn(function()
        while _G.TekExtrasLoadedGame == game and _G.TekExtrasLoadedWorkspace == workspace do
            task.wait(0.1)
            _G.ElysiumInvisDepthSync()
            _G.ElysiumDropFlingActive = _G.TekDropFlingActive == true
            _G.ElysiumInvisSync()
        end
    end)
-- END ELYSIUM INVIS STEAL PORT

    -- old Tek anti-die no longer auto-binds: the always-on Tek Anti-Die (rymogs port)
    -- right below replaces it. _G.Tek_AntiDieOn / _G.Tek_AntiDieOff still exist.

end

-- =====================================================================
-- TEK ANTI-DIE (always on)
-- Ported from rymogs and rebranded to Tek. Revives at 0 HP, keeps the Dead
-- state off, stops joints breaking, tops HP during a steal hold, and cleans
-- up ragdoll / knockback. It only pauses while an Instant Reset is running
-- so the reset can still kill the character.
-- =====================================================================
_G.AntiDieDisabled = false
_G.TekAntiDieAlwaysOn = true
task.spawn(function()
local __P = game:GetService("Players")
while not __P.LocalPlayer do task.wait() end
local okAD, errAD = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace  = game:GetService("Workspace")
    local RS         = game:GetService("ReplicatedStorage")
    local LP         = Players.LocalPlayer

    local antiRagdollConnections = {}
    local antiRagdollCharacter, antiRagdollHumanoid, antiRagdollRootPart, antiRagdollAnimator
    local lastVelocity = Vector3.new(0, 0, 0)
    local velocityChangeThreshold = 40
    local velocityMagnitudeThreshold = 25
    local maxVelocity = 15

    -- always on: only an Instant Reset in progress pauses it
    local function antiDiePaused()
        return _G.Tek_IsResetting == true or _G.__elysiumResetBusy == true
    end
    -- don't fight the invis steal clone (it handles its own ragdoll recovery)
    local function invisActive()
        return _G.TekInvisActive == true or _G.invisibleStealEnabled == true
    end
    local function antiRagdollOn()
        return (_G.TekAntiRagdollEnabled or _G.TekAntiKnockbackEnabled) and not invisActive() and not antiDiePaused()
    end

    local function isFlyingCarpetActive()
        if not antiRagdollCharacter then return false end
        local tool = antiRagdollCharacter:FindFirstChildWhichIsA("Tool")
        if not tool then return false end
        local hrp = antiRagdollCharacter:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    return true
                end
            end
        end
        return false
    end

    local function isRagdolled()
        if not antiRagdollHumanoid then return false end
        local state = antiRagdollHumanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end

    local function enableAntiRagdollControls()
        pcall(function()
            local PlayerModule = LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
            require(PlayerModule):GetControls():Enable()
        end)
    end

    local function cleanupRagdoll()
        if not antiRagdollCharacter then return end
        local carpetEquipped = isFlyingCarpetActive()
        local function processChildren(parent)
            for _, obj in ipairs(parent:GetChildren()) do
                if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                    or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                    obj:Destroy()
                elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    if not carpetEquipped then obj:Destroy() end
                elseif obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") then
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("Motor6D") then
                            child.Enabled = true
                        elseif child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") then
                            child:Destroy()
                        elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
        pcall(function() processChildren(antiRagdollCharacter) end)
        if antiRagdollAnimator then
            for _, track in pairs(antiRagdollAnimator:GetPlayingAnimationTracks()) do
                local animName = track.Animation and track.Animation.Name:lower() or ""
                if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                    track:Stop(0)
                end
            end
        end
    end

    local function _harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    end

    local function _revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end

    local function setupAntiRagdollCharacter(char)
        antiRagdollCharacter = char
        antiRagdollHumanoid = char:WaitForChild("Humanoid", 10)
        antiRagdollRootPart = char:WaitForChild("HumanoidRootPart", 10)
        antiRagdollAnimator = antiRagdollHumanoid and antiRagdollHumanoid:WaitForChild("Animator", 10)
        lastVelocity = Vector3.new(0, 0, 0)
        if antiRagdollHumanoid and not antiDiePaused() then _harden(antiRagdollHumanoid) end
    end

    local function clearAntiRagdollConnections()
        for _, c in pairs(antiRagdollConnections) do
            pcall(function() c:Disconnect() end)
        end
        antiRagdollConnections = {}
    end

    local function setupAntiRagdollConnections()
        clearAntiRagdollConnections()
        if not antiRagdollHumanoid or not antiRagdollRootPart then return end

        if not antiDiePaused() then _harden(antiRagdollHumanoid) end

        table.insert(antiRagdollConnections, antiRagdollHumanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if antiDiePaused() then return end
            if antiRagdollHumanoid and antiRagdollHumanoid.Parent and antiRagdollHumanoid.Health <= 0 then
                _revive(antiRagdollHumanoid)
            end
        end))

        table.insert(antiRagdollConnections, antiRagdollHumanoid.Died:Connect(function()
            if antiDiePaused() then return end
            if antiRagdollHumanoid and antiRagdollHumanoid.Parent then
                _revive(antiRagdollHumanoid)
            end
        end))

        local _lastHarden = 0
        table.insert(antiRagdollConnections, RunService.Heartbeat:Connect(function()
            if not antiRagdollHumanoid or not antiRagdollHumanoid.Parent then return end
            if not antiDiePaused() then
                local now = os.clock()
                if now - _lastHarden >= 1.0 then _lastHarden = now; _harden(antiRagdollHumanoid) end
                if antiRagdollHumanoid.Health <= 0 then _revive(antiRagdollHumanoid) end
                if _G.TekStealHold and antiRagdollHumanoid.Health < antiRagdollHumanoid.MaxHealth then
                    pcall(function() antiRagdollHumanoid.Health = antiRagdollHumanoid.MaxHealth end)
                end
            end
            if antiRagdollOn() and isRagdolled() then
                if _G.TekStealHold then return end
                if antiRagdollRootPart.AssemblyLinearVelocity.Magnitude > 60 then
                    lastVelocity = antiRagdollRootPart.AssemblyLinearVelocity
                    return
                end
                cleanupRagdoll()
                local velocity = antiRagdollRootPart.AssemblyLinearVelocity
                if (velocity - lastVelocity).Magnitude > velocityChangeThreshold
                    and velocity.Magnitude > velocityMagnitudeThreshold then
                    antiRagdollRootPart.AssemblyLinearVelocity = velocity.Unit * math.min(velocity.Magnitude, maxVelocity)
                end
                lastVelocity = velocity
            end
        end))

        table.insert(antiRagdollConnections, antiRagdollHumanoid.StateChanged:Connect(function()
            if antiRagdollOn() and isRagdolled() then
                if not isFlyingCarpetActive() then
                    antiRagdollHumanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                cleanupRagdoll()
                pcall(function() Workspace.CurrentCamera.CameraSubject = antiRagdollHumanoid end)
                enableAntiRagdollControls()
            end
        end))

        pcall(function()
            local impulse
            if _G.TekGetRemote then
                impulse = _G.TekGetRemote("RemoteEvent", "CombatService/ApplyImpulse")
            end
            if not impulse then
                local pkgs = RS:FindFirstChild("Packages")
                local net  = pkgs and pkgs:FindFirstChild("Net")
                impulse = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")
            end
            if impulse then
                table.insert(antiRagdollConnections, impulse.OnClientEvent:Connect(function()
                    if antiRagdollOn() and isRagdolled() then
                        antiRagdollRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end))
            end
        end)

        table.insert(antiRagdollConnections, antiRagdollCharacter.DescendantAdded:Connect(function()
            if antiRagdollOn() and isRagdolled() then
                cleanupRagdoll()
            end
        end))

        enableAntiRagdollControls()
        cleanupRagdoll()
    end

    local function startAntiRagdoll()
        _G.TekAntiRagdollEnabled = true
        _G.TekAntiKnockbackEnabled = true
        if LP.Character then
            setupAntiRagdollCharacter(LP.Character)
            setupAntiRagdollConnections()
        end
    end

    -- turning anti-ragdoll off only stops the ragdoll part; anti-die stays on
    local function stopAntiRagdoll()
        _G.TekAntiRagdollEnabled = false
        _G.TekAntiKnockbackEnabled = false
    end

    _G.TekToggleAntiRagdoll = function(enabled)
        if enabled then startAntiRagdoll() else stopAntiRagdoll() end
    end
    _G.TekEnableAntiKnockback = function() startAntiRagdoll() end
    _G.TekDisableAntiKnockback = function() stopAntiRagdoll() end

    LP.CharacterAdded:Connect(function(char)
        clearAntiRagdollConnections()
        antiRagdollCharacter = nil; antiRagdollHumanoid = nil; antiRagdollRootPart = nil; antiRagdollAnimator = nil
        local humanoid = char:WaitForChild("Humanoid", 10)
        local rootPart = char:WaitForChild("HumanoidRootPart", 10)
        if not humanoid or not rootPart then return end
        task.wait(0.2)
        setupAntiRagdollCharacter(char)
        setupAntiRagdollConnections()
    end)

    startAntiRagdoll()
end)
if not okAD then _G.TekAntiDieError = tostring(errAD) end
end)
-- END TEK ANTI-DIE


do
    if getgenv and getgenv().__FTP_InputConn then
        pcall(function() getgenv().__FTP_InputConn:Disconnect() end)
    end
    if getgenv and getgenv().__FTP_ClickConn then
        pcall(function() getgenv().__FTP_ClickConn:Disconnect() end)
    end

    local function _key(name)
        local k = Config[name]
        if not k or k == "NONE" then return nil end
        local ok, code = pcall(function() return Enum.KeyCode[k] end)
        if ok then return code end
        return nil
    end

    -- Carpet Speed is initialized before both the keybind and the settings UI.
    -- This keeps both controls alive even if a later optional hub section errors.
    do
        local fixedItems = {
            "Flying Carpet", "Waverider", "Santa's Sleigh",
            "Witch's Broom", "Cupid's Wings"
        }
        local preferredItems = {}
        local carpetEnabled = false
        local carpetConnection = nil

        local function rebuildItemOrder(selected)
            table.clear(preferredItems)
            if type(selected) == "string" and selected ~= "" then
                table.insert(preferredItems, selected)
            end
            for _, name in ipairs(fixedItems) do
                if name ~= selected then table.insert(preferredItems, name) end
            end
        end

        local function setSelectedItem(name)
            if type(name) ~= "string" or name == "" then return end
            Config.CarpetTool = name
            rebuildItemOrder(name)
            pcall(SaveConfig)
            if _G.Tek_SyncCarpetToolBtn then pcall(_G.Tek_SyncCarpetToolBtn) end
        end

        local function cycleSelectedItem()
            local current = Config.CarpetTool or fixedItems[1]
            local index = 1
            for i, name in ipairs(fixedItems) do
                if name == current then index = i; break end
            end
            local selected = fixedItems[(index % #fixedItems) + 1]
            setSelectedItem(selected)
            return selected
        end

        local function findAndEquipItem(character, humanoid)
            local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:FindFirstChildOfClass("Backpack")
            local starterGear = LocalPlayer:FindFirstChild("StarterGear")
            for _, name in ipairs(preferredItems) do
                local tool = character:FindFirstChild(name)
                    or (backpack and backpack:FindFirstChild(name))
                    or (starterGear and starterGear:FindFirstChild(name))
                if tool and tool:IsA("Tool") then
                    if tool.Parent ~= character then
                        pcall(function() humanoid:EquipTool(tool) end)
                    end
                    -- EquipTool can finish on the following frame. Returning the
                    -- instance lets the next Heartbeat confirm it without losing state.
                    return tool
                end
            end
            return nil
        end

        local function setCarpetEnabled(value)
            carpetEnabled = value == true
            Config.CarpetSpeedEnabled = carpetEnabled
            if carpetConnection then
                carpetConnection:Disconnect()
                carpetConnection = nil
            end
            if _G.Tek_SyncCarpetBtn then
                pcall(_G.Tek_SyncCarpetBtn, carpetEnabled)
            end
            pcall(SaveConfig)
            if not carpetEnabled then return false end

            carpetConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not character or not humanoid or not root or humanoid.Health <= 0 then return end
                if LocalPlayer:GetAttribute("Stealing") then return end

                local tool = findAndEquipItem(character, humanoid)
                if not tool then return end
                local direction = humanoid.MoveDirection
                local speed = tonumber(Config.CarpetSpeed) or 140
                local velocity = root.AssemblyLinearVelocity
                if direction.Magnitude > 0 then
                    root.AssemblyLinearVelocity = Vector3.new(direction.X * speed, velocity.Y, direction.Z * speed)
                else
                    root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                end
            end)
            return true
        end

        rebuildItemOrder(Config.CarpetTool or "Flying Carpet")
        Config.CarpetSpeedEnabled = false
        _G.Tek_SetCarpetTool = setSelectedItem
        _G.Tek_CurrentCarpetTool = function() return Config.CarpetTool or "Flying Carpet" end
        _G.Tek_CycleCarpetTool = cycleSelectedItem
        _G.Tek_SetCarpetSpeed = setCarpetEnabled
        _G.Tek_ToggleCarpetSpeed = function()
            return setCarpetEnabled(not carpetEnabled)
        end
        _G.__TekCarpetV2Ready = true
    end

    do
        local _dropBusy = false
        local _flinging = false

        local function _dropRoot(char)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            return hum and hum.RootPart
        end

        local function _flingBurst(duration)
            if _flinging then return end
            _flinging = true
            _G.TekDropFlingActive = true
            local t0 = os.clock()
            while _flinging and (os.clock() - t0) < duration do
                RunService.Heartbeat:Wait()
                local char = player.Character
                local root = _dropRoot(char)
                if not (char and char.Parent and root and root.Parent) then break end
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if char and char.Parent and root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if char and char.Parent and root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
            _flinging = false
            _G.TekDropFlingActive = false
            local root = _dropRoot(player.Character)
            if root and root.Parent then root.Velocity = Vector3.new(0, 0, 0) end
        end

        _G.Tek_DropBrainrot = function()
            if _dropBusy then return end
            _dropBusy = true
            _G.ElysiumDropPending = true
            local wasInvis = _G.invisibleStealEnabled == true
            if wasInvis and _G.toggleInvisibleSteal then
                pcall(_G.toggleInvisibleSteal)
                task.wait(0.2)
            end
            pcall(_flingBurst, 0.3)
            -- -- ShowNotification("DROP", wasInvis and "Brainrot dropped (invis OFF)" or "Brainrot dropped")
            task.wait(0.2)
            _dropBusy = false
            _G.ElysiumDropPending = false
        end

        player.CharacterAdded:Connect(function()
            _flinging = false
            _dropBusy = false
            _G.ElysiumDropPending = false
            _G.TekDropFlingActive = false
        end)
    end

    _G.Tek_KeybindListening = nil
    -- Extras owns the shared manual-TP key. tp.txt only provides the action.
    _G.TekManualTPBridgeActive = true
    local conn1 = UIS.InputBegan:Connect(function(input, processed)
        if _G.Tek_KeybindListening ~= nil then return end
        do local _fb = nil pcall(function() _fb = UIS:GetFocusedTextBox() end) if _fb then return end end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local kc = input.KeyCode
        -- Q и другие клавиши инструмента могут быть уже помечены игрой
        -- как processed. Назначенный Carpet Speed keybind всё равно должен
        -- доходить до нашего обработчика.
        if processed and kc ~= _key("CarpetSpeedKey") and kc ~= _key("TeleportKey") then return end
        if kc == _key("KickKey") then
            if _G.Tek_DoKick then task.spawn(function() pcall(_G.Tek_DoKick) end) end
        elseif kc == _key("InvisStealKey") then
            if _G.toggleInvisibleSteal then
                task.spawn(function() pcall(_G.toggleInvisibleSteal) end)
                -- -- ShowNotification("INVIS STEAL", (not _G.invisibleStealEnabled) and "ON" or "OFF")
            end
        elseif kc == _key("TeleportKey") then
            task.spawn(function()
                -- Current tp.txt API first; legacy names remain as fallbacks.
                local action = _G.TekStartSideTP
                    or _G.Tek_ExecuteManualTP
                    or _G.MynxxStartSideTP
                if type(action) == "function" then pcall(action) end
            end)
        elseif kc == _key("ConfigKey") then
            if _G.Tek_ToggleConfigMenu then pcall(_G.Tek_ToggleConfigMenu) end
        elseif kc == _key("InstantResetKey") then
            if _G.Tek_InstantReset then
                task.spawn(function() pcall(_G.Tek_InstantReset) end)
                -- -- ShowNotification("INSTANT RESET", "Burst...")
            end
        elseif kc == _key("InstantCloneKey") then
            task.spawn(function() pcall(instantClone) end)
        elseif kc == _key("CarpetSpeedKey") then
            if _G.Tek_ToggleCarpetSpeed then
                task.spawn(function() pcall(_G.Tek_ToggleCarpetSpeed) end)
            end
        elseif kc == _key("NextTargetKey") then
            if _G.TekCycleStealTarget then
                task.spawn(function() pcall(_G.TekCycleStealTarget) end)
            end
        elseif kc == _key("DropBrainrotKey") then
            task.spawn(function()

                if _G.invisibleStealEnabled == true then
                    if _G.toggleInvisibleSteal then
                        pcall(_G.toggleInvisibleSteal)
                    end
                    task.wait(0.2)
                end
                if _G.Tek_DropBrainrot then pcall(_G.Tek_DropBrainrot) end
            end)
        end
    end)

end

task.spawn(function()
    task.wait(0.5)
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        local old = pg:FindFirstChild("TekUtilPanel"); if old then old:Destroy() end

        local C_BG    = Color3.fromRGB(7, 7, 7)
        local C_OFF   = Color3.fromRGB(22, 22, 22)
        local C_ON    = Color3.fromRGB(201, 201, 201)
        local C_ACTIVE= Color3.fromRGB(59, 59, 59)
        local C_RED   = Color3.fromRGB(105, 105, 105)
        local C_TEXT  = Color3.fromRGB(238, 238, 238)
        local C_DIM   = Color3.fromRGB(140, 140, 140)
        local C_DIV   = Color3.fromRGB(42, 42, 42)
        local FONT_BK = Enum.Font.GothamBlack
        local FONT_B  = Enum.Font.GothamBold

        local sg = Instance.new("ScreenGui")
        sg.Name = "TekUtilPanel"; sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true; sg.DisplayOrder = 9991
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.Parent = pg
        registerScreenGui(sg)

        local W, PAD = 320, 8
        local main = Instance.new("Frame", sg)
        main.Size = UDim2.fromOffset(W, 10)
        main.AutomaticSize = Enum.AutomaticSize.Y
        main.Position = UDim2.fromOffset(30, 240)
        main.BackgroundColor3 = C_BG; main.BorderSizePixel = 0
        main.BackgroundTransparency = 0.04
        main.ClipsDescendants = true
        corner(main, 5)
        do
            local g = Instance.new("UIGradient", main)
            g.Rotation = 135
            g.Color = ColorSequence.new(Color3.fromRGB(14, 14, 14), Color3.fromRGB(7, 7, 7))
        end
        do local _us = Instance.new("UIScale", main); _us.Name = "Tek_CompactScale"; _us.Scale = 1 end
        local ms = Instance.new("UIStroke", main)
        ms.Color = Color3.fromRGB(53, 53, 53); ms.Thickness = 1; ms.Transparency = 0.38

        local titleBar = Instance.new("Frame", main)
        titleBar.Size = UDim2.new(1, 0, 0, 28)
        titleBar.BackgroundColor3 = C_OFF; titleBar.BorderSizePixel = 0
        titleBar.BackgroundTransparency = 1
        titleBar.LayoutOrder = -999
        corner(titleBar, 10)
        local titleLbl = Instance.new("TextLabel", titleBar)
        titleLbl.Size = UDim2.new(1, -8, 1, 0); titleLbl.Position = UDim2.new(0, 8, 0, 0)
        titleLbl.BackgroundTransparency = 1; titleLbl.Text = "QUICK SETTINGS"
        titleLbl.Font = FONT_BK; titleLbl.TextSize = 12
        titleLbl.TextColor3 = C_TEXT; titleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local mainPad = Instance.new("UIPadding", main)
        mainPad.PaddingLeft=UDim.new(0,PAD); mainPad.PaddingRight=UDim.new(0,PAD)
        mainPad.PaddingTop=UDim.new(0,PAD); mainPad.PaddingBottom=UDim.new(0,PAD)
        local mainList = Instance.new("UIListLayout", main)
        mainList.SortOrder = Enum.SortOrder.LayoutOrder
        mainList.Padding = UDim.new(0, 0)

        task.defer(function() applySavedPosition("Utils Panel", main) end)

        do
            -- Drag only from the title bar. Use Position (not AbsolutePosition) so
            -- the panel never snaps upward on mobile / IgnoreGuiInset screens.
            local dragging, dragStart, startPos = false, nil, nil
            titleBar.Active = true
            titleBar.InputBegan:Connect(function(i)
                if Config.UILocked or _G._TekSliderDragging then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = i.Position
                    startPos = main.Position
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if not dragging or Config.UILocked or _G._TekSliderDragging or _G._TekPanelDragging then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local d = i.Position - dragStart
                    local nx = startPos.X.Offset + d.X
                    local ny = startPos.Y.Offset + d.Y
                    -- Soft clamp so the panel stays mostly on-screen
                    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                    if vp then
                        local w = main.AbsoluteSize.X
                        local h = math.min(main.AbsoluteSize.Y, 80)
                        nx = math.clamp(nx, -math.max(0, w - 40), vp.X - 40)
                        ny = math.clamp(ny, 0, vp.Y - h)
                    end
                    main.Position = UDim2.fromOffset(nx, ny)
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if not dragging then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    pcall(rememberPosition, "Utils Panel", main)
                end
            end)
        end

        local lo = 0
        local function div()
            lo=lo+1
            local d=Instance.new("Frame",main)
            d.LayoutOrder=lo; d.Size=UDim2.new(1,0,0,1)
            d.BackgroundTransparency=1; d.BorderSizePixel=0
            return d
        end
        local function rowFrame(h)
            lo=lo+1
            local r=Instance.new("Frame",main)
            r.LayoutOrder=lo; r.Size=UDim2.new(1,0,0,h)
            r.BackgroundTransparency=1; r.BorderSizePixel=0
            return r
        end
        local function paint(b,on)
            b.BackgroundColor3=on and C_ACTIVE or C_OFF
            b.TextColor3=on and C_ON or C_TEXT
        end
        local function mkBtn(parent,text,bg,fg,ts)
            local b=Instance.new("TextButton",parent)
            b.BackgroundColor3=bg or C_OFF; b.AutoButtonColor=false
            b.BorderSizePixel=0; b.Text=text
            b.Font=FONT_BK; b.TextSize=ts or 8
            b.TextColor3=fg or C_TEXT; corner(b,4)
            return b
        end

        local f1=rowFrame(38)
        local f1pad=Instance.new("UIPadding",f1)
        f1pad.PaddingLeft=UDim.new(0,0); f1pad.PaddingRight=UDim.new(0,0)
        f1pad.PaddingTop=UDim.new(0,6); f1pad.PaddingBottom=UDim.new(0,6)
        local f1l=Instance.new("UIListLayout",f1)
        f1l.FillDirection=Enum.FillDirection.Horizontal
        f1l.SortOrder=Enum.SortOrder.LayoutOrder; f1l.Padding=UDim.new(0,6)

        local rjJob=mkBtn(f1,"RJ Job",C_OFF,C_TEXT,11)
        rjJob.Size=UDim2.new(0.5,-3,0,26); rjJob.LayoutOrder=1
        local rjPs=mkBtn(f1,"RJ PS",C_OFF,C_TEXT,11)
        rjPs.Size=UDim2.new(0.5,-3,0,26); rjPs.LayoutOrder=2

        div()

        local runwayBuyRow=rowFrame(30)
        local runwayBuyButton=mkBtn(runwayBuyRow,"AUTO BUY: OFF",C_OFF,C_TEXT,12)
        runwayBuyButton.Size=UDim2.new(1,0,0,30)
        runwayBuyButton.Position=UDim2.fromOffset(0,0)
        local function syncRunwayBuyButton()
            if not runwayBuyButton.Parent then return end
            local state=_G.TekRunwayAutoBuyTest.GetState()
            runwayBuyButton.Text="AUTO BUY: "..state
            paint(runwayBuyButton,state=="ON")
        end
        local unsubscribeRunwayBuy=_G.TekRunwayAutoBuyTest.Subscribe(syncRunwayBuyButton)
        runwayBuyRow.Destroying:Connect(unsubscribeRunwayBuy)
        runwayBuyButton.MouseButton1Click:Connect(function() _G.TekToggleAutoBuy() end)
        div()

        local f3=rowFrame(38)
        local f3pad=Instance.new("UIPadding",f3)
        f3pad.PaddingTop=UDim.new(0,6); f3pad.PaddingBottom=UDim.new(0,6)
        local f3l=Instance.new("UIListLayout",f3)
        f3l.FillDirection=Enum.FillDirection.Horizontal
        f3l.SortOrder=Enum.SortOrder.LayoutOrder; f3l.Padding=UDim.new(0,6)
        f3l.VerticalAlignment=Enum.VerticalAlignment.Center

local akBtn=mkBtn(f3,"Auto Kick",C_OFF,C_TEXT,12)
        akBtn.Size=UDim2.new(1/3,-4,0,26); akBtn.LayoutOrder=1
        local kickBtn=mkBtn(f3,"KICK",C_RED,C_TEXT,13)
        kickBtn.Size=UDim2.new(1/3,-4,0,26); kickBtn.LayoutOrder=2
        local modKickBtn=mkBtn(f3,"MOD KICK",C_RED,C_TEXT,11)
        modKickBtn.Size=UDim2.new(1/3,-4,0,26); modKickBtn.LayoutOrder=3
        div()

        local f4=rowFrame(38)
        local f4pad=Instance.new("UIPadding",f4)
        f4pad.PaddingTop=UDim.new(0,6); f4pad.PaddingBottom=UDim.new(0,6)
        local f4l=Instance.new("UIListLayout",f4)
        f4l.FillDirection=Enum.FillDirection.Horizontal
        f4l.SortOrder=Enum.SortOrder.LayoutOrder; f4l.Padding=UDim.new(0,6)

        local arBtn=mkBtn(f4,"Auto Recover",C_OFF,C_TEXT,12)
        arBtn.Size=UDim2.new(1,-86,0,26); arBtn.LayoutOrder=1
        local freeBtn=mkBtn(f4,"FREE",C_OFF,C_ON,13)
        freeBtn.Size=UDim2.fromOffset(80,26); freeBtn.LayoutOrder=2

        div()

        local function newSlider(label, minV, maxV, getV, setV, fmt, warnAt)
            local sRow=rowFrame(34)
            sRow.BackgroundColor3=C_OFF; sRow.BackgroundTransparency=0.12
            corner(sRow,10)
            local sp=Instance.new("UIPadding",sRow)
            sp.PaddingLeft=UDim.new(0,8); sp.PaddingRight=UDim.new(0,8)
            sp.PaddingTop=UDim.new(0,6); sp.PaddingBottom=UDim.new(0,2)

            local topL=Instance.new("Frame",sRow)
            topL.Size=UDim2.new(1,0,0,14); topL.BackgroundTransparency=1; topL.BorderSizePixel=0

            local lbl=Instance.new("TextLabel",topL)
            lbl.Size=UDim2.new(0.5,0,1,0); lbl.BackgroundTransparency=1
            lbl.Text=label; lbl.Font=FONT_B; lbl.TextSize=11
            lbl.TextColor3=C_DIM; lbl.TextXAlignment=Enum.TextXAlignment.Left

            local valLbl=Instance.new("TextLabel",topL)
            valLbl.Size=UDim2.new(0.5,0,1,0); valLbl.Position=UDim2.new(0.5,0,0,0)
            valLbl.BackgroundTransparency=1; valLbl.Font=FONT_BK
            valLbl.TextSize=8; valLbl.TextColor3=C_ON
            valLbl.TextXAlignment=Enum.TextXAlignment.Right

            local bar=Instance.new("Frame",sRow)
            bar.Position=UDim2.new(0,0,0,11); bar.Size=UDim2.new(1,0,0,3)
            bar.BackgroundColor3=Color3.fromRGB(35, 35, 35); bar.BorderSizePixel=0; corner(bar,5)
            local fill=Instance.new("Frame",bar)
            fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=C_ON
            fill.BorderSizePixel=0; corner(fill,5)
            local knob=Instance.new("Frame",bar)
            knob.Size=UDim2.fromOffset(13,13); knob.AnchorPoint=Vector2.new(0.5,0.5)
            knob.Position=UDim2.new(0,0,0.5,0)
            knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; corner(knob,7)

            local function render(v)
                local a=math.clamp((v-minV)/(maxV-minV),0,1)
                fill.Size=UDim2.new(a,0,1,0); knob.Position=UDim2.new(a,0,0.5,0)
                if warnAt and v > warnAt then
                    valLbl.Text=string.format(fmt,v).."  CAN DETECT"
                    valLbl.TextColor3=Color3.fromRGB(101, 101, 101)
                    fill.BackgroundColor3=Color3.fromRGB(101, 101, 101)
                else
                    valLbl.Text=string.format(fmt,v)
                    valLbl.TextColor3=C_ON
                    fill.BackgroundColor3=C_ON
                end
            end
            render(getV())

            local dragging=false
            local function apply(x)
                local a=math.clamp((x-bar.AbsolutePosition.X)/math.max(1,bar.AbsoluteSize.X),0,1)
                local v=minV+a*(maxV-minV); setV(v); render(v)
            end
            bar.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    dragging=true; _G._TekSliderDragging=true; apply(i.Position.X)
                end
            end)
            knob.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    dragging=true; _G._TekSliderDragging=true
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if not dragging then return end
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then apply(i.Position.X) end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    if dragging then dragging=false; _G._TekSliderDragging=false; SaveConfig() end
                end
            end)
            return sRow
        end

        newSlider("Rot",0,360,
            function() return tonumber(Config.InvisStealAngle) or 180 end,
            function(v)
                v=math.floor(v+0.5)
                Config.InvisStealAngle=v; _G.InvisStealAngle=v; _G.TekInvisAngle=v; _G.ElysiumInvisDepthSync()
            end,"%d")
        div()
        newSlider("Depth",0,10,
            function() return math.clamp(tonumber(Config.SinkSliderValue) or 7,0,10) end,
            function(v)
                v=math.floor(v*10+0.5)/10
                Config.SinkSliderValue=v; _G.SinkSliderValue=v; _G.TekInvisDepth=v; _G.ElysiumInvisDepthSync()
            end,"%.1f")

        rjJob.MouseButton1Click:Connect(function()
            -- -- ShowNotification("REJOIN","Job...")
            local job=tostring(game.JobId or "")
            if job=="" then rjJob.Text="SERVER ID UNAVAILABLE";return end
            local ok=pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,job,LocalPlayer,nil,
                    {peakJoin={jobId=job},royalRejoin=true})
            end)
            rjJob.Text=ok and "REJOINING..." or "REJOIN FAILED"
        end)
        rjPs.MouseButton1Click:Connect(function()
            -- -- ShowNotification("REJOIN","Private server...")
            local link=tostring(Config.PrivateServerLink or ""):match("^%s*(.-)%s*$")
            local code=link
            if link~="" and string.find(link,"://",1,true) then
                code=link:match("[?&]privateServerLinkCode=([^&]+)")
                    or link:match("[?&]linkCode=([^&]+)")
                    or link:match("[?&]code=([^&]+)")
            end
            if not code or code=="" then code=PS_LINK_CODE end
            local ok=pcall(function()
                game:GetService("ExperienceService"):LaunchExperience({placeId=PS_PLACE_ID,linkCode=code})
            end)
            if not ok then local job=tostring(game.JobId or "")
            if job=="" then rjJob.Text="SERVER ID UNAVAILABLE";return end
            local ok=pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,job,LocalPlayer,nil,
                    {peakJoin={jobId=job},royalRejoin=true})
            end)
            rjJob.Text=ok and "REJOINING..." or "REJOIN FAILED" end
        end)


        paint(akBtn,Config.AutoKickEnabled==true)
        akBtn.MouseButton1Click:Connect(function()
            Config.AutoKickEnabled=not Config.AutoKickEnabled
            if Config.AutoKickEnabled then if _G.Tek_StartAutoKick then pcall(_G.Tek_StartAutoKick) end
            else if _G.Tek_StopAutoKick then pcall(_G.Tek_StopAutoKick) end end
            SaveConfig(); paint(akBtn,Config.AutoKickEnabled)
        end)
        div()

        modKickBtn.MouseButton1Click:Connect(function()
            if _G.Tek_ModerationKick then task.spawn(function() pcall(_G.Tek_ModerationKick) end) end
        end)
        paint(arBtn,Config.AutoRecoverLagback~=false)
        arBtn.MouseButton1Click:Connect(function()
            Config.AutoRecoverLagback=not(Config.AutoRecoverLagback~=false)
            _G.AutoRecoverLagback=Config.AutoRecoverLagback
            SaveConfig(); paint(arBtn,Config.AutoRecoverLagback)
        end)

        local function refreshFree()
            local on=_G.Tek_FollowOwner==true
            freeBtn.Text=on and "LOCK" or "FREE"
            freeBtn.BackgroundColor3=on and C_ON or C_OFF
            freeBtn.TextColor3=on and C_TEXT or C_ON
        end
        freeBtn.MouseButton1Click:Connect(function()
            _G.Tek_FollowOwner=not(_G.Tek_FollowOwner==true); refreshFree()
        end)
        refreshFree()

        div()

        local f5=rowFrame(38)
        local f5pad=Instance.new("UIPadding",f5)
        f5pad.PaddingTop=UDim.new(0,6); f5pad.PaddingBottom=UDim.new(0,6)
        local f5l=Instance.new("UIListLayout",f5)
        f5l.FillDirection=Enum.FillDirection.Horizontal
        f5l.SortOrder=Enum.SortOrder.LayoutOrder; f5l.Padding=UDim.new(0,6)

        local invBtn=mkBtn(f5,"Invis Steal",C_OFF,C_TEXT,12)
        invBtn.Size=UDim2.new(0.55,-3,0,26); invBtn.LayoutOrder=1
        local autoInvBtn=mkBtn(f5,"Auto Invis",C_OFF,C_TEXT,11)
        autoInvBtn.Size=UDim2.new(0.45,-3,0,26); autoInvBtn.LayoutOrder=2
        local function syncAutoInvBtn()
            if not autoInvBtn.Parent then return end
            local on = Config.AutoInvisDuringSteal == true
            paint(autoInvBtn, on)
            autoInvBtn.Text = on and "Auto Invis: ON" or "Auto Invis: OFF"
        end
        syncAutoInvBtn()
        autoInvBtn.MouseButton1Click:Connect(function()
            Config.AutoInvisDuringSteal = not (Config.AutoInvisDuringSteal == true)
            _G.ElysiumInvisDepthSync()
            if Config.AutoInvisDuringSteal and type(_G.ElysiumInvisClearUserOff) == "function" then
                pcall(_G.ElysiumInvisClearUserOff)
            end
            pcall(SaveConfig)
            syncAutoInvBtn()
            if Config.AutoInvisDuringSteal and type(_G.ElysiumInvisSync) == "function" then
                pcall(_G.ElysiumInvisSync)
            end
        end)
        local invisClickBusy = false
        local function syncInvisButton()
            if not invBtn.Parent then return end
            local on = _G.ElysiumInvisActive == true
            paint(invBtn,on)
            invBtn.Text = on and "Invis Steal: ON" or "Invis Steal: OFF"
        end
        syncInvisButton()
        if _G.Tek_SetInvisBtnSync then _G.Tek_SetInvisBtnSync(syncInvisButton) end
        invBtn.MouseButton1Click:Connect(function()
            if invisClickBusy then return end
            invisClickBusy = true
            task.spawn(function()
                local wantEnabled = _G.ElysiumInvisActive ~= true
                if type(_G.ElysiumSetInvisManual) == "function" then
                    pcall(_G.ElysiumSetInvisManual,wantEnabled)
                end
                syncInvisButton()
                invisClickBusy = false
                if wantEnabled and _G.ElysiumInvisActive ~= true
                    and LocalPlayer:GetAttribute("Stealing") ~= true then
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification",{
                            Title="Invis Steal",Text="Start stealing a brainrot first.",Duration=3,
                        })
                    end)
                end
            end)
        end)
        _G.Tek_SyncCarpetBtn=function() end

    end)
end)

_G.Tek_SetFOV = function(v)
    v = math.clamp(tonumber(v) or 120, 40, 120)
    Config.FOV = v
    _G.TekFOV = v
    pcall(function() Workspace.CurrentCamera.FieldOfView = v end)
    return v
end

do
    _G.TekFOV = math.clamp(tonumber(Config.FOV) or 120, 40, 120)
    local fovConn = nil
    local restoringFOV = false

    local function restoreFOV(cam)
        if not cam or restoringFOV then return end
        local wanted = math.clamp(tonumber(Config.FOV) or tonumber(_G.TekFOV) or 120, 40, 120)
        _G.TekFOV = wanted
        if math.abs((cam.FieldOfView or wanted) - wanted) <= 0.01 then return end
        restoringFOV = true
        pcall(function() cam.FieldOfView = wanted end)
        restoringFOV = false
    end

    local function bindFOVCamera(cam)
        if fovConn then fovConn:Disconnect(); fovConn = nil end
        if not cam then return end
        restoreFOV(cam)
        fovConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            -- Flying gears commonly force 70 when equipped. Restore the user's
            -- configured value in the same frame instead of waiting for a timer.
            restoreFOV(cam)
        end)
    end

    bindFOVCamera(Workspace.CurrentCamera)
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        bindFOVCamera(Workspace.CurrentCamera)
    end)
end

task.spawn(function()
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        local old = pg:FindFirstChild("TekConfigPanel"); if old then old:Destroy() end

        local C_BG    = Color3.fromRGB(7, 7, 7)
        local C_OFF   = Color3.fromRGB(22, 22, 22)
        local C_ON    = Color3.fromRGB(201, 201, 201)
        local C_ACTIVE= Color3.fromRGB(59, 59, 59)
        local C_TEXT  = Color3.fromRGB(238, 238, 238)
        local C_DIM   = Color3.fromRGB(140, 140, 140)
        local FONT_B  = Enum.Font.GothamBold

        local sg = Instance.new("ScreenGui")
        sg.Name = "TekConfigPanel"; sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true; sg.DisplayOrder = 9995
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.Parent = pg
        registerScreenGui(sg)

        local main = Instance.new("Frame", sg)
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        main.Size = UDim2.fromOffset(360, 10)
        main.AutomaticSize = Enum.AutomaticSize.Y
        main.BackgroundColor3 = C_BG; main.BorderSizePixel = 0
        main.BackgroundTransparency = 0.04
        main.ClipsDescendants = true
        main.Visible = false
        corner(main, 5)
        do
            local g = Instance.new("UIGradient", main)
            g.Rotation = 135
            g.Color = ColorSequence.new(Color3.fromRGB(14, 14, 14), Color3.fromRGB(7, 7, 7))
            local s = Instance.new("UIStroke", main)
            s.Color = Color3.fromRGB(53, 53, 53); s.Thickness = 1; s.Transparency = 0.38
        end
        do local _us = Instance.new("UIScale", main); _us.Name = "Tek_CompactScale"; _us.Scale = 1 end
        local pad = Instance.new("UIPadding", main)
        pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingTop = UDim.new(0, 8); pad.PaddingBottom = UDim.new(0, 8)
        local list = Instance.new("UIListLayout", main)
        list.SortOrder = Enum.SortOrder.LayoutOrder; list.Padding = UDim.new(0, 6)

        local header = Instance.new("Frame", main)
        header.LayoutOrder = 0; header.Size = UDim2.new(1, 0, 0, 26)
        header.BackgroundColor3 = C_OFF; header.BorderSizePixel = 0
        header.BackgroundTransparency = 1
        corner(header, 10)
        local htitle = Instance.new("TextLabel", header)
        htitle.BackgroundTransparency = 1; htitle.Size = UDim2.new(1, -30, 1, 0)
        htitle.Position = UDim2.fromOffset(8, 0)
        htitle.Text = "CONFIG"; htitle.Font = FONT_B; htitle.TextSize = 13
        htitle.TextColor3 = C_TEXT; htitle.TextXAlignment = Enum.TextXAlignment.Left
        local closeBtn = Instance.new("TextButton", header)
        closeBtn.Size = UDim2.fromOffset(22, 22); closeBtn.Position = UDim2.new(1, -24, 0.5, -11)
        closeBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90); closeBtn.AutoButtonColor = false
        closeBtn.Text = "X"; closeBtn.Font = FONT_B; closeBtn.TextSize = 13; closeBtn.TextColor3 = C_TEXT
        closeBtn.BorderSizePixel = 0; corner(closeBtn, 7)
        closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)
        do
            local dragging, dragStart, startPos = false, nil, nil
            header.InputBegan:Connect(function(i)
                if Config.UILocked or _G._TekSliderDragging then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; dragStart = i.Position; startPos = main.Position
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if not dragging or Config.UILocked or _G._TekSliderDragging or _G._TekPanelDragging then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local d = i.Position - dragStart
                    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        -- Save Position offsets (not AbsolutePosition) to stop upward creep.
                        local xo = main.Position.X.Offset
                        local yo = main.Position.Y.Offset
                        if not Config.TekPositions then Config.TekPositions = {} end
                        Config.TekPositions["ConfigMenu"] = {xs = 0, xo = xo, ys = 0, yo = yo}
                        local ps = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                        if ps then
                            if not Config.Positions then Config.Positions = {} end
                            Config.Positions["ConfigMenu"] = {X = xo / math.max(1, ps.X), Y = yo / math.max(1, ps.Y)}
                        end
                        pcall(SaveConfig)
                    end
                end
            end)
        end

        task.defer(function()
            local d = Config.TekPositions and Config.TekPositions["ConfigMenu"]
            if d and d.xo and d.yo then
                main.AnchorPoint = Vector2.new(0, 0)
                main.Position = UDim2.fromOffset(d.xo, d.yo)
            end

        end)

        local order = 0
        local function newRow(h)
            order = order + 1
            local r = Instance.new("Frame", main)
            r.LayoutOrder = order; r.Size = UDim2.new(1, 0, 0, h or 28)
            r.BackgroundTransparency = 1; r.BorderSizePixel = 0
            local hl = Instance.new("UIListLayout", r)
            hl.FillDirection = Enum.FillDirection.Horizontal
            hl.SortOrder = Enum.SortOrder.LayoutOrder; hl.Padding = UDim.new(0, 6)
            return r
        end
        local function newBtn(row, text, widthScale, o)
            local b = Instance.new("TextButton", row)
            b.LayoutOrder = o; b.Size = UDim2.new(widthScale, widthScale==1 and 0 or -3, 1, 0)
            b.BackgroundColor3 = C_OFF; b.AutoButtonColor = false
            b.BackgroundTransparency = 0.3
            b.Text = text; b.Font = FONT_B; b.TextSize = 12
            b.TextColor3 = C_TEXT; b.BorderSizePixel = 0
            corner(b, 9)
            return b
        end
        local function paint(b, on)
            b.BackgroundColor3 = on and C_ACTIVE or C_OFF
            b.TextColor3 = on and C_ON or C_TEXT
        end


        local function newToggleRow(lbl1, getState1, toggle1, lbl2, getState2, toggle2)
            local r = newRow(28)
            local b1 = newBtn(r, lbl1, lbl2 and 0.5 or 1, 1)
            paint(b1, getState1())
            b1.MouseButton1Click:Connect(function()
                toggle1()
                paint(b1, getState1())
            end)
            if lbl2 then
                local b2 = newBtn(r, lbl2, 0.5, 2)
                paint(b2, getState2())
                b2.MouseButton1Click:Connect(function()
                    toggle2()
                    paint(b2, getState2())
                end)
                return b1, b2
            end
            return b1
        end

        -- Lock All GUI: freezes every MakeDraggable / panel drag while enabled.
        local lockGuiBtn = newToggleRow(
            "Lock All GUI",
            function() return Config.UILocked == true end,
            function()
                Config.UILocked = not (Config.UILocked == true)
                pcall(SaveConfig)
            end
        )
        lockGuiBtn.Size = UDim2.new(1, 0, 1, 0)

        local skipStolenBtn = newToggleRow(
            "Skip Brainrots Being Stolen",
            function() return Config.SkipStolenTarget ~= false end,
            function()
                Config.SkipStolenTarget = not (Config.SkipStolenTarget ~= false)
                _G.TekSkipStolenTarget = Config.SkipStolenTarget
                pcall(SaveConfig)
            end
        )
        skipStolenBtn.Size = UDim2.new(1, 0, 1, 0)

        local espPBtn, espBBtn = newToggleRow(
            "ESP Player",
            function() return Config.ESPPlayerEnabled == true end,
            function() if _G.Tek_ToggleESPPlayer then pcall(_G.Tek_ToggleESPPlayer) end end,
            "ESP Base Owner",
            function() return Config.ESPBaseOwnerEnabled == true end,
            function() if _G.Tek_ToggleESPBaseOwner then pcall(_G.Tek_ToggleESPBaseOwner) end end
        )

        newToggleRow("Inf Jump", function() return Config.InfiniteJump end,
            function() Config.InfiniteJump=not Config.InfiniteJump;pcall(SaveConfig) end)

        local function newSlider(label, minV, maxV, getV, setV, fmt)
            order = order + 1
            local box = Instance.new("Frame", main)
            box.LayoutOrder = order; box.Size = UDim2.new(1, 0, 0, 40)
            box.BackgroundColor3 = C_OFF; box.BorderSizePixel = 0
            box.BackgroundTransparency = 0.3
            corner(box, 10)
            local lbl = Instance.new("TextLabel", box)
            lbl.BackgroundTransparency = 1; lbl.Position = UDim2.fromOffset(8, 3); lbl.Size = UDim2.new(0.6, 0, 0, 16)
            lbl.Text = label; lbl.Font = FONT_B; lbl.TextSize = 12; lbl.TextColor3 = C_DIM
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local val = Instance.new("TextLabel", box)
            val.BackgroundTransparency = 1; val.Position = UDim2.new(1, -64, 0, 3); val.Size = UDim2.fromOffset(56, 16)
            val.Font = FONT_B; val.TextSize = 12; val.TextColor3 = C_ON; val.TextXAlignment = Enum.TextXAlignment.Right
            local bar = Instance.new("Frame", box)
            bar.Position = UDim2.fromOffset(8, 26); bar.Size = UDim2.new(1, -16, 0, 6)
            bar.BackgroundColor3 = Color3.fromRGB(61, 61, 61); bar.BorderSizePixel = 0; corner(bar, 5)
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = C_ON; fill.BorderSizePixel = 0; corner(fill, 5)
            local knob = Instance.new("Frame", bar)
            knob.Size = UDim2.fromOffset(12, 12); knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(0, 0, 0.5, 0); knob.BackgroundColor3 = C_TEXT; knob.BorderSizePixel = 0; corner(knob, 6)
            local function render(v)
                local a = math.clamp((v - minV) / (maxV - minV), 0, 1)
                fill.Size = UDim2.new(a, 0, 1, 0); knob.Position = UDim2.new(a, 0, 0.5, 0)
                val.Text = string.format(fmt, v)
            end
            render(getV())
            local dragging = false
            local function apply(x)
                local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
                local v = setV(minV + a * (maxV - minV))
                render(tonumber(v) or (minV + a * (maxV - minV)))
            end
            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; _G._TekSliderDragging = true; apply(i.Position.X) end
            end)
            knob.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; _G._TekSliderDragging = true end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(i.Position.X) end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if dragging then dragging = false; _G._TekSliderDragging = false; pcall(SaveConfig) end
                end
            end)
        end

        newSlider("Auto Buy Distance",0,100,
            function() return Config.RunwayBuyDistance end,
            function(value) return _G.TekRunwayAutoBuyTest.SetDistance(value) end,"%d")
        newSlider("Buy Attempts / Frame",1,50,
            function() return Config.RunwayBuyAttempts end,
            function(value) return _G.TekRunwayAutoBuyTest.SetAttempts(value) end,"%d")
        newSlider("Auto Buy Float",0,20,
            function() return Config.RunwayBuyHover end,
            function(value) return _G.TekRunwayAutoBuyTest.SetHover(value) end,"%d")

        newSlider("FOV", 40, 120,
            function() return math.clamp(tonumber(Config.FOV) or 70, 40, 120) end,
            function(v) v = math.floor(v + 0.5); return _G.Tek_SetFOV and _G.Tek_SetFOV(v) or v end,
            "%d")

        -- ================= UI SIZE (scales every panel) =================
        do
            local range = _G.Tek_UISizeRange or { 0.5, 2.5 }
            local minV, maxV, stepV = range[1], range[2], 0.05
            order = order + 1
            local box = Instance.new("Frame", main)
            box.LayoutOrder = order; box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = C_OFF; box.BorderSizePixel = 0
            box.BackgroundTransparency = 0.3
            corner(box, 10)
            local lbl = Instance.new("TextLabel", box)
            lbl.BackgroundTransparency = 1; lbl.Position = UDim2.fromOffset(8, 3); lbl.Size = UDim2.new(0.7, 0, 0, 16)
            lbl.Text = "UI Size (all panels)"; lbl.Font = FONT_B; lbl.TextSize = 12; lbl.TextColor3 = C_DIM
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local val = Instance.new("TextLabel", box)
            val.BackgroundTransparency = 1; val.Position = UDim2.new(1, -64, 0, 3); val.Size = UDim2.fromOffset(56, 16)
            val.Font = FONT_B; val.TextSize = 12; val.TextColor3 = C_ON; val.TextXAlignment = Enum.TextXAlignment.Right

            local function sizeBtn(text, pos, w)
                local b = Instance.new("TextButton", box)
                b.Size = UDim2.fromOffset(w, 26); b.Position = pos
                b.BackgroundColor3 = Color3.fromRGB(12, 12, 12); b.AutoButtonColor = false
                b.BorderSizePixel = 0; b.Text = text; b.Font = FONT_B; b.TextSize = 14; b.TextColor3 = C_TEXT
                b.Active = true
                corner(b, 8)
                local s = Instance.new("UIStroke", b)
                s.Color = Color3.fromRGB(61, 61, 61); s.Thickness = 1
                return b
            end
            local minusBtn = sizeBtn("-", UDim2.fromOffset(6, 24), 30)
            local plusBtn  = sizeBtn("+", UDim2.new(1, -90, 0, 24), 30)
            local resetBtn = sizeBtn("RESET", UDim2.new(1, -54, 0, 24), 48)
            resetBtn.TextSize = 10

            -- tall invisible touch area around the thin bar so it's easy to grab on mobile
            local hit = Instance.new("TextButton", box)
            hit.BackgroundTransparency = 1; hit.Text = ""; hit.AutoButtonColor = false; hit.Active = true
            hit.Position = UDim2.fromOffset(42, 22); hit.Size = UDim2.new(1, -138, 0, 30)
            local bar = Instance.new("Frame", hit)
            bar.AnchorPoint = Vector2.new(0, 0.5); bar.Position = UDim2.new(0, 0, 0.5, 0)
            bar.Size = UDim2.new(1, 0, 0, 6)
            bar.BackgroundColor3 = Color3.fromRGB(61, 61, 61); bar.BorderSizePixel = 0; corner(bar, 5)
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = C_ON; fill.BorderSizePixel = 0; corner(fill, 5)
            local knob = Instance.new("Frame", bar)
            knob.Size = UDim2.fromOffset(14, 14); knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(0, 0, 0.5, 0); knob.BackgroundColor3 = C_TEXT; knob.BorderSizePixel = 0; corner(knob, 7)

            local function render(v)
                local a = math.clamp((v - minV) / (maxV - minV), 0, 1)
                fill.Size = UDim2.new(a, 0, 1, 0); knob.Position = UDim2.new(a, 0, 0.5, 0)
                val.Text = string.format("%d%%", math.floor(v * 100 + 0.5))
            end
            local function snap(v)
                return math.clamp(math.floor(v / stepV + 0.5) * stepV, minV, maxV)
            end
            local function current()
                return (_G.Tek_GetUISize and _G.Tek_GetUISize()) or 1
            end
            local function commit(v)
                v = snap(v)
                if _G.Tek_SetUISize then v = _G.Tek_SetUISize(v, true) end
                render(v)
            end
            render(current())

            local sizing, pending = false, nil
            local function valueAt(x)
                local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
                return snap(minV + a * (maxV - minV))
            end
            hit.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sizing = true; _G._TekSliderDragging = true
                    pending = valueAt(i.Position.X); render(pending)
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if sizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    pending = valueAt(i.Position.X); render(pending)
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if sizing then
                        sizing = false; _G._TekSliderDragging = false
                        -- applied on release so the panel doesn't resize under your finger mid-drag
                        if pending then commit(pending) end
                        pending = nil
                    end
                end
            end)
            minusBtn.MouseButton1Click:Connect(function() commit(current() - stepV) end)
            plusBtn.MouseButton1Click:Connect(function() commit(current() + stepV) end)
            resetBtn.MouseButton1Click:Connect(function() commit(1) end)
        end


        do
            order = order + 1
            local psBox = Instance.new("Frame", main)
            psBox.LayoutOrder = order; psBox.Size = UDim2.new(1, 0, 0, 44)
            psBox.BackgroundColor3 = C_OFF; psBox.BorderSizePixel = 0
            psBox.BackgroundTransparency = 0.3
            corner(psBox, 10)

            local psLbl = Instance.new("TextLabel", psBox)
            psLbl.BackgroundTransparency = 1
            psLbl.Position = UDim2.fromOffset(8, 3); psLbl.Size = UDim2.new(1, -16, 0, 14)
            psLbl.Text = "PS Code (Auto Kick)"
            psLbl.Font = FONT_B; psLbl.TextSize = 11
            psLbl.TextColor3 = C_DIM; psLbl.TextXAlignment = Enum.TextXAlignment.Left

            local psInput = Instance.new("TextBox", psBox)
            psInput.Size = UDim2.new(1, -12, 0, 22)
            psInput.Position = UDim2.fromOffset(6, 19)
            psInput.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
            psInput.BorderSizePixel = 0
            psInput.Text = tostring(Config.PrivateServerLink or "")
            psInput.PlaceholderText = "Link o codigo de PS..."
            psInput.PlaceholderColor3 = C_DIM
            psInput.Font = FONT_B; psInput.TextSize = 11
            psInput.TextColor3 = C_TEXT
            psInput.TextXAlignment = Enum.TextXAlignment.Left
            psInput.ClearTextOnFocus = false
            corner(psInput, 8)
            local psStroke = Instance.new("UIStroke", psInput)
            psStroke.Color = Color3.fromRGB(61, 61, 61); psStroke.Thickness = 1
            local psPad = Instance.new("UIPadding", psInput)
            psPad.PaddingLeft = UDim.new(0, 5); psPad.PaddingRight = UDim.new(0, 5)

            psInput.FocusLost:Connect(function()
                local v = psInput.Text:match("^%s*(.-)%s*$")
                Config.PrivateServerLink = v
                pcall(SaveConfig)
                psStroke.Color = C_ON
                task.delay(0.8, function() psStroke.Color = Color3.fromRGB(61, 61, 61) end)
            end)
            psInput.Focused:Connect(function() _G._TekSliderDragging = true end)
            psInput.FocusLost:Connect(function() _G._TekSliderDragging = false end)
        end

        -- ================= KEYBINDS aufklappbar =================
        do
            local kbExpanded = (Config.KeybindsExpanded == true)
            order = order + 1
            local kbHeader = Instance.new("TextButton", main)
            kbHeader.LayoutOrder = order; kbHeader.Size = UDim2.new(1, 0, 0, 28)
            kbHeader.BackgroundColor3 = C_OFF; kbHeader.AutoButtonColor = false
            kbHeader.BackgroundTransparency = 0.3; kbHeader.BorderSizePixel = 0
            kbHeader.Font = FONT_B; kbHeader.TextSize = 12; kbHeader.TextColor3 = C_TEXT
            corner(kbHeader, 10)

            order = order + 1
            local kbContainer = Instance.new("Frame", main)
            kbContainer.LayoutOrder = order; kbContainer.Size = UDim2.new(1, 0, 0, 10)
            kbContainer.AutomaticSize = Enum.AutomaticSize.Y
            kbContainer.BackgroundTransparency = 1; kbContainer.BorderSizePixel = 0
            local kbList = Instance.new("UIListLayout", kbContainer)
            kbList.SortOrder = Enum.SortOrder.LayoutOrder; kbList.Padding = UDim.new(0, 4)

            local kbRows = {}
            local keybindBtns = {}
            local function refreshKeybindBtn(cfgKey)
                local b = keybindBtns[cfgKey]
                if b then b.Text = tostring(Config[cfgKey] or "NONE") end
            end
            _G.Tek_RefreshKeybinds = function()
                for k, _ in pairs(keybindBtns) do refreshKeybindBtn(k) end
            end

            local kbOrder = 0
            local function newKeybindRow(labelText, cfgKey)
                kbOrder = kbOrder + 1
                local box = Instance.new("Frame", kbContainer)
                box.LayoutOrder = kbOrder; box.Size = UDim2.new(1, 0, 0, 28)
                box.BackgroundColor3 = C_OFF; box.BorderSizePixel = 0
                box.BackgroundTransparency = 0.3
                corner(box, 9)
                table.insert(kbRows, box)
                box.Visible = kbExpanded
                local lbl = Instance.new("TextLabel", box)
                lbl.BackgroundTransparency = 1
                lbl.Position = UDim2.fromOffset(8, 0); lbl.Size = UDim2.new(0.5, 0, 1, 0)
                lbl.Text = labelText; lbl.Font = FONT_B; lbl.TextSize = 11
                lbl.TextColor3 = C_DIM; lbl.TextXAlignment = Enum.TextXAlignment.Left
                local btn = Instance.new("TextButton", box)
                btn.Size = UDim2.new(0.45, -8, 0, 20); btn.Position = UDim2.new(0.55, 0, 0.5, -10)
                btn.BackgroundColor3 = Color3.fromRGB(12, 12, 12); btn.AutoButtonColor = false
                btn.BorderSizePixel = 0
                btn.Text = tostring(Config[cfgKey] or "NONE")
                btn.Font = FONT_B; btn.TextSize = 11; btn.TextColor3 = C_TEXT
                corner(btn, 8)
                local bStroke = Instance.new("UIStroke", btn)
                bStroke.Color = Color3.fromRGB(61, 61, 61); bStroke.Thickness = 1
                keybindBtns[cfgKey] = btn
                btn.MouseButton1Click:Connect(function()
                    if _G.Tek_KeybindListening ~= nil then
                        local prev = _G.Tek_KeybindListening
                        _G.Tek_KeybindListening = nil
                        if keybindBtns[prev] then keybindBtns[prev].Text = tostring(Config[prev] or "NONE") end
                        if prev == cfgKey then return end
                    end
                    _G.Tek_KeybindListening = cfgKey
                    btn.Text = "..."
                end)
                pcall(function()
                    btn.MouseButton2Click:Connect(function()
                        Config[cfgKey] = "NONE"
                        pcall(SaveConfig)
                        btn.Text = "NONE"
                        if _G.Tek_KeybindListening == cfgKey then _G.Tek_KeybindListening = nil end
                    end)
                end)
            end

            newKeybindRow("Config Menu", "ConfigKey")
            newKeybindRow("Teleport", "TeleportKey")
            newKeybindRow("Invis Steal", "InvisStealKey")
            newKeybindRow("Instant Reset", "InstantResetKey")
            newKeybindRow("Instant Clone", "InstantCloneKey")
            newKeybindRow("Carpet Speed", "CarpetSpeedKey")
            newKeybindRow("Next Target", "NextTargetKey")
            newKeybindRow("Drop Brainrot", "DropBrainrotKey")
            newKeybindRow("Kick", "KickKey")
            newKeybindRow("Auto Buy", "AutoBuyKey")

            local function setKbExpanded(on)
                kbExpanded = on
                Config.KeybindsExpanded = on
                pcall(SaveConfig)
                kbHeader.Text = on and "KEYBINDS  [v]" or "KEYBINDS  [>]"
                kbContainer.Visible = on
                for _, r in ipairs(kbRows) do r.Visible = on end
            end
            kbHeader.MouseButton1Click:Connect(function() setKbExpanded(not kbExpanded) end)
            setKbExpanded(kbExpanded)

            UIS.InputBegan:Connect(function(input, processed)
                local listening = _G.Tek_KeybindListening
                if not listening then return end
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local focused = nil
                pcall(function() focused = UIS:GetFocusedTextBox() end)
                if focused then return end
                if input.KeyCode == Enum.KeyCode.Escape then
                    _G.Tek_KeybindListening = nil
                    refreshKeybindBtn(listening)
                    return
                end
                local keyName
                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Unknown then
                    keyName = "NONE"
                else
                    keyName = input.KeyCode.Name
                end
                Config[listening] = keyName
                pcall(SaveConfig)
                _G.Tek_KeybindListening = nil
                refreshKeybindBtn(listening)
            end)
        end
        -- =============== END KEYBINDS ===============

        _G.Tek_ToggleConfigMenu = function() main.Visible = not main.Visible end
        _G.Tek_ShowConfigMenu   = function() main.Visible = true end

        -- lil draggable C button to open config
        do
            local oldB = pg:FindFirstChild("TekConfigOpenBtn"); if oldB then oldB:Destroy() end
            local bsg = Instance.new("ScreenGui")
            bsg.Name = "TekConfigOpenBtn"; bsg.ResetOnSpawn = false
            bsg.IgnoreGuiInset = true; bsg.DisplayOrder = 9996
            bsg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; bsg.Parent = pg
            registerScreenGui(bsg)
            local cbtn = Instance.new("TextButton", bsg)
            cbtn.Name = "OpenBtn"
            cbtn.Size = UDim2.fromOffset(32, 32)
            cbtn.Position = UDim2.fromOffset(10, 300)
            cbtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            cbtn.BackgroundTransparency = 0.3
            cbtn.BorderSizePixel = 0
            cbtn.Text = "C"; cbtn.Font = FONT_B; cbtn.TextSize = 14
            cbtn.TextColor3 = C_TEXT; cbtn.AutoButtonColor = false
            cbtn.Active = true
            corner(cbtn, 8)
            pcall(function()
                local d = Config.TekPositions and Config.TekPositions["ConfigOpenBtn"]
                if d and d.xo and d.yo then cbtn.Position = UDim2.fromOffset(d.xo, d.yo) end
            end)
            cbtn.MouseButton1Click:Connect(function()
                if _G.Tek_ToggleConfigMenu then pcall(_G.Tek_ToggleConfigMenu) end
            end)
            MakeDraggable(cbtn, cbtn, "ConfigOpenBtn")
        end
    end)
end)

do
    local xrayOriginal = setmetatable({}, {__mode = "k"})
    local xrayConns = {}
    local xrayLoopId = 0
    local XRAY_ALPHA = 0.75
    local XRAY_FOLDERS = {"Base","PlotSign","FriendPanel","Cash","Laser","Decorations","Skin","Unlock","Purchases","Walls","Wall","Floor","Roof","Ceiling"}

    local function setTransparency(instance, alpha, loopId)
        if not instance then return end
        if loopId ~= xrayLoopId then return end
        local function apply(obj)
            if obj:IsA("BasePart") then
                if xrayOriginal[obj] == nil then
                    if obj.Transparency == alpha then xrayOriginal[obj] = 0
                    else xrayOriginal[obj] = obj.Transparency end
                end
                local orig = xrayOriginal[obj]
                if orig < 1 then
                    local target = orig + (1 - orig) * alpha
                    if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
                end
            end
        end
        apply(instance)
        for i, child in ipairs(instance:GetDescendants()) do
            apply(child)
            if i % 300 == 0 then
                task.wait()
                if loopId ~= xrayLoopId then return end
            end
        end
    end
    local function trackSubtree(root, alpha, loopId)
        if not root or loopId ~= xrayLoopId then return end
        setTransparency(root, alpha, loopId)
        if loopId ~= xrayLoopId then return end
        xrayConns[#xrayConns + 1] = root.DescendantAdded:Connect(function(obj)
            if loopId ~= xrayLoopId then return end
            setTransparency(obj, alpha, loopId)
        end)
    end
    local function processPlot(plot, alpha, loopId)
        if not plot or loopId ~= xrayLoopId then return end
        for _, fname in ipairs(XRAY_FOLDERS) do
            if loopId ~= xrayLoopId then return end
            trackSubtree(plot:FindFirstChild(fname), alpha, loopId)
        end
        if loopId ~= xrayLoopId then return end
        xrayConns[#xrayConns + 1] = plot.ChildAdded:Connect(function(child)
            if loopId ~= xrayLoopId then return end
            for _, fname in ipairs(XRAY_FOLDERS) do
                if child.Name == fname then trackSubtree(child, alpha, loopId); break end
            end
        end)
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            local function processPodium(podium)
                for _, child in ipairs(podium:GetChildren()) do
                    if child.Name == "Claim" then
                        trackSubtree(child, alpha, loopId)
                    elseif child.Name == "Base" then
                        trackSubtree(child:FindFirstChild("Decorations"), alpha, loopId)
                    end
                    -- animal models deliberately NOT tracked: xraying the pet
                    -- pushes it to 75% transparency and it stays ghosted
                    -- while carried, so stolen brainrots look invisible.
                end
            end
            for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
            xrayConns[#xrayConns + 1] = podiums.ChildAdded:Connect(function(podium)
                if loopId ~= xrayLoopId then return end
                task.wait(0.1)
                if loopId ~= xrayLoopId then return end
                processPodium(podium)
            end)
        end
    end
    local function applyAllPlots(alpha, loopId)
        local plotsFolder = Workspace:FindFirstChild("Plots")
        if not plotsFolder then return end
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if loopId ~= xrayLoopId then return end
            processPlot(plot, alpha, loopId)
            task.wait()
        end
        xrayConns[#xrayConns + 1] = plotsFolder.ChildAdded:Connect(function(plot)
            if loopId ~= xrayLoopId then return end
            task.wait(0.2)
            processPlot(plot, alpha, loopId)
        end)
    end

    local function enableXray()
        for _, c in ipairs(xrayConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        xrayConns = {}
        xrayLoopId = xrayLoopId + 1
        local id = xrayLoopId
        Config.XrayEnabled = true
        task.spawn(function()
            pcall(applyAllPlots, XRAY_ALPHA, id)
        end)
    end
    local function disableXray()
        for _, c in ipairs(xrayConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        xrayConns = {}
        xrayLoopId = xrayLoopId + 1
        Config.XrayEnabled = false
        local snapshot = xrayOriginal
        xrayOriginal = setmetatable({}, {__mode = "k"})
        for obj, orig in pairs(snapshot) do
            pcall(function() if obj:IsA("BasePart") then obj.Transparency = orig end end)
        end
    end
    _G.Tek_EnableXray  = enableXray
    _G.Tek_DisableXray = disableXray
    _G.Tek_ToggleXray  = function()
        if Config.XrayEnabled then disableXray() else enableXray() end
        return Config.XrayEnabled
    end

    task.spawn(function() enableXray() end)
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.XrayEnabled then enableXray() end
    end)
end

do

    local espPlayerEnabled = false
    local espPlayerConnections = {}
    local espPlayerHighlights = {}
    local _espMakeBillboard
    local _espGetPlotOwnerName
    local _espRefreshPlayer

    _espMakeBillboard = function(plr)
        if not plr.Character then return end
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if espPlayerHighlights[plr] then
            pcall(function() espPlayerHighlights[plr].billboard:Destroy() end)
            espPlayerHighlights[plr] = nil
        end

        local holder = Instance.new("ScreenGui")
        holder.Name = "TekEspHL_" .. plr.Name
        holder.ResetOnSpawn = false
        holder.Parent = PlayerGui

        local hl = Instance.new("Highlight", holder)
        hl.Adornee = plr.Character
        hl.FillColor = Color3.fromRGB(117, 117, 117)
        hl.FillTransparency = 0.6
        hl.OutlineColor = Color3.fromRGB(196, 196, 196)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local bb = Instance.new("BillboardGui", holder)
        bb.Name = "TekEspBB_" .. plr.Name
        bb.Adornee = hrp; bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 190, 0, 48)
        bb.StudsOffset = Vector3.new(0, 3.2, 0)
        bb.ResetOnSpawn = false

        local nameLbl = Instance.new("TextLabel", bb)
        nameLbl.Size = UDim2.new(1, 0, 1, 0); nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.Name; nameLbl.Font = Enum.Font.GothamBlack; nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255); nameLbl.TextStrokeTransparency = 0.3

        espPlayerHighlights[plr] = { billboard = holder, highlight = hl, nameLabel = nameLbl }

        local _last = 0
        local conn = RunService.Heartbeat:Connect(function()
            if not espPlayerEnabled or not plr.Parent then return end
            local now = os.clock(); if now - _last < 0.5 then return end; _last = now
            if plr.Character then
                local newHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if newHrp and bb.Adornee ~= newHrp then
                    bb.Adornee = newHrp; hl.Adornee = plr.Character
                end
            end
            if _espRefreshPlayer then pcall(_espRefreshPlayer, plr) end
        end)
        table.insert(espPlayerConnections, conn)

        local caConn = plr.CharacterAdded:Connect(function(newChar)
            if not espPlayerEnabled then return end
            if espPlayerHighlights[plr] then
                pcall(function() espPlayerHighlights[plr].billboard:Destroy() end)
                espPlayerHighlights[plr] = nil
            end
            newChar:WaitForChild("HumanoidRootPart", 5)
            if espPlayerEnabled then pcall(_espMakeBillboard, plr) end
        end)
        table.insert(espPlayerConnections, caConn)
    end

    local function enableESPPlayer()
        if espPlayerEnabled then return end
        espPlayerEnabled = true
        Config.ESPPlayerEnabled = true
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then pcall(_espMakeBillboard, plr) end
        end
        table.insert(espPlayerConnections, Players.PlayerAdded:Connect(function(plr)
            if not espPlayerEnabled then return end
            task.wait(1)
            pcall(_espMakeBillboard, plr)
        end))
        table.insert(espPlayerConnections, Players.PlayerRemoving:Connect(function(plr)
            if espPlayerHighlights[plr] then
                pcall(function() espPlayerHighlights[plr].billboard:Destroy() end)
                espPlayerHighlights[plr] = nil
            end
        end))
    end
    local function disableESPPlayer()
        espPlayerEnabled = false
        Config.ESPPlayerEnabled = false
        for _, conn in ipairs(espPlayerConnections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        espPlayerConnections = {}
        for _, data in pairs(espPlayerHighlights) do
            pcall(function() data.billboard:Destroy() end)
        end
        espPlayerHighlights = {}
    end

    local espBaseOwnerEnabled = false
    local espBaseOwnerConn, espBaseOwnerHolder = nil, nil

    local function _espGetPlotUnderPlayer()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local nearest, nearestDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local okBox, boxCf, boxSize = pcall(function() return plot:GetBoundingBox() end)
            if okBox and boxCf and boxSize then
                local rel = boxCf:PointToObjectSpace(hrp.Position)
                if math.abs(rel.X) <= (boxSize.X * 0.5 + 3)
                    and math.abs(rel.Z) <= (boxSize.Z * 0.5 + 3) then
                    local flatDist = Vector3.new(rel.X, 0, rel.Z).Magnitude
                    if flatDist < nearestDist then nearestDist = flatDist; nearest = plot end
                end
            end
            local ok, cf = pcall(function() return plot:GetPivot() end)
            local px, pz
            if ok and cf then
                px, pz = cf.Position.X, cf.Position.Z
            else
                local sign = plot:FindFirstChild("PlotSign")
                local sp = sign and (sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart", true))
                if sp then px, pz = sp.Position.X, sp.Position.Z end
            end
            if px then
                local d = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(px, 0, pz)).Magnitude
                -- Fallback for plots whose model bounds are incomplete. The cap
                -- prevents a remote/nearest base from being treated as occupied.
                if not nearest and d <= (tonumber(_G.TekBaseOwnerRange) or 65) and d < nearestDist then
                    nearestDist = d; nearest = plot
                end
            end
        end
        return nearest
    end

    _espGetPlotOwnerName = function(plot)
        if not plot then return nil end
        local ch = _G.Tek_GetPlotChannel and _G.Tek_GetPlotChannel(plot.Name)
        if ch then
            local o = _G.Tek_ChannelGet and _G.Tek_ChannelGet(ch, "Owner")
            if typeof(o) == "Instance" and o:IsA("Player") then return o.Name end
            if type(o) == "table" and o.Name then return tostring(o.Name) end
            if type(o) == "string" and o ~= "" then return o end
            if type(o) == "number" then
                local p = Players:GetPlayerByUserId(o); if p then return p.Name end
            end
        end
        local sign = plot:FindFirstChild("PlotSign")
        local lbl = sign and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
        if lbl then
            local nick = lbl.Text:match("^(.-)'") or lbl.Text
            if nick and nick ~= "" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.DisplayName == nick or p.Name == nick then return p.Name end
                end
            end
        end
        return nil
    end

    _espRefreshPlayer = function(plr)
        local data = espPlayerHighlights[plr]
        if not data then return end
        local char = plr.Character
        local stealingIndex = plr:GetAttribute("StealingIndex")
        if stealingIndex == nil and char then stealingIndex = char:GetAttribute("StealingIndex") end
        local stealing = plr:GetAttribute("Stealing") == true
            or (char and char:GetAttribute("Stealing") == true)
            or (stealingIndex ~= nil and tostring(stealingIndex) ~= "")
        local currentPlot = _espGetPlotUnderPlayer()
        local currentOwner = currentPlot and _espGetPlotOwnerName(currentPlot) or nil
        local isOwner = currentOwner == plr.Name

        local fill, outline, textColor, text
        if stealing then
            fill = Color3.fromRGB(90, 90, 90)
            outline = Color3.fromRGB(188, 188, 188)
            textColor = Color3.fromRGB(105, 105, 105)
            local stolenName = stealingIndex ~= nil and tostring(stealingIndex) or "Brainrot"
            text = "@" .. plr.Name .. "\nSTEALING: " .. stolenName
        elseif isOwner then
            fill = Color3.fromRGB(173, 173, 173)
            outline = Color3.fromRGB(228, 228, 228)
            textColor = Color3.fromRGB(208, 208, 208)
            text = "@" .. plr.Name .. "\nBASE OWNER"
        else
            fill = Color3.fromRGB(163, 163, 163)
            outline = Color3.fromRGB(223, 223, 223)
            textColor = Color3.fromRGB(245, 245, 245)
            text = "@" .. plr.Name
        end
        data.highlight.FillColor = fill
        data.highlight.OutlineColor = outline
        data.nameLabel.TextColor3 = textColor
        data.nameLabel.Text = text
    end

    local function _espBaseOwnerClear()
        if espBaseOwnerHolder then
            pcall(function() espBaseOwnerHolder:Destroy() end)
            espBaseOwnerHolder = nil
        end
        for _, sg in ipairs(PlayerGui:GetChildren()) do
            if sg.Name == "TekEspBaseOwner" then pcall(function() sg:Destroy() end) end
        end
    end

    local function _espApplyBaseOwner(ownerName, plot)
        if not ownerName or not plot then return end
        if ownerName == LocalPlayer.Name then return end

        local sign = plot:FindFirstChild("PlotSign")
        local signPart = sign and (sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart", true))
        if not signPart then return end

        local holder = espBaseOwnerHolder
        if not holder or not holder.Parent then
            holder = Instance.new("ScreenGui")
            holder.Name = "TekEspBaseOwner"; holder.ResetOnSpawn = false; holder.Parent = PlayerGui
            espBaseOwnerHolder = holder
        end

        local existing = holder:FindFirstChild("Owner_" .. plot.Name)
        if existing then existing:Destroy() end

        local bb = Instance.new("BillboardGui", holder)
        bb.Name = "Owner_" .. plot.Name
        bb.Adornee = signPart; bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 200, 0, 28); bb.StudsOffset = Vector3.new(0, 4, 0)

        local nameLbl = Instance.new("TextLabel", bb)
        nameLbl.Size = UDim2.new(1, 0, 1, 0); nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "BASE OWNER: @" .. ownerName; nameLbl.Font = Enum.Font.GothamBlack; nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(208, 208, 208); nameLbl.TextStrokeTransparency = 0.3
    end

    local function enableESPBaseOwner()
        if espBaseOwnerEnabled then return end
        espBaseOwnerEnabled = true
        Config.ESPBaseOwnerEnabled = true
        _espBaseOwnerClear()
        local tickCount = 0
        local lastOwnerName, lastOwnerPlotName = nil, nil
        local function _hookBoCA(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espBaseOwnerEnabled then
                    lastOwnerName, lastOwnerPlotName = nil, nil
                    _espBaseOwnerClear()
                end
            end)
        end
        for _, plr in ipairs(Players:GetPlayers()) do _hookBoCA(plr) end
        Players.PlayerAdded:Connect(_hookBoCA)

        espBaseOwnerConn = RunService.Heartbeat:Connect(function()
            if not espBaseOwnerEnabled then return end
            tickCount = tickCount + 1
            if tickCount < 60 then return end
            tickCount = 0
            local plot = _espGetPlotUnderPlayer()
            local ownerName = plot and _espGetPlotOwnerName(plot) or nil
            local plotName = plot and plot.Name or nil
            if ownerName ~= lastOwnerName or plotName ~= lastOwnerPlotName then
                _espBaseOwnerClear()
                lastOwnerName, lastOwnerPlotName = ownerName, plotName
                if ownerName and plot then pcall(_espApplyBaseOwner, ownerName, plot) end
            end
        end)
    end
    local function disableESPBaseOwner()
        espBaseOwnerEnabled = false
        Config.ESPBaseOwnerEnabled = false
        if espBaseOwnerConn then espBaseOwnerConn:Disconnect(); espBaseOwnerConn = nil end
        _espBaseOwnerClear()
    end

    _G.Tek_EnableESPPlayer     = enableESPPlayer
    _G.Tek_DisableESPPlayer    = disableESPPlayer
    _G.Tek_EnableESPBaseOwner  = enableESPBaseOwner
    _G.Tek_DisableESPBaseOwner = disableESPBaseOwner
    _G.Tek_ToggleESPPlayer = function()
        if Config.ESPPlayerEnabled then disableESPPlayer() else enableESPPlayer() end
        return Config.ESPPlayerEnabled
    end
    _G.Tek_ToggleESPBaseOwner = function()
        if Config.ESPBaseOwnerEnabled then disableESPBaseOwner() else enableESPBaseOwner() end
        return Config.ESPBaseOwnerEnabled
    end

    task.spawn(function()
        task.wait(6)
        pcall(enableESPPlayer)
        pcall(enableESPBaseOwner)
    end)
end

do
    local subspaceMineESPData = {}
    local function refreshSubspaceMineESP()
        local tools = Workspace:FindFirstChild("ToolsAdds")
        if not tools then return end
        local currentMines = {}
        for _, obj in ipairs(tools:GetChildren()) do
            if obj.Name:match("SubspaceTripmine") and obj:IsA("BasePart") then
                currentMines[obj] = true
                if not subspaceMineESPData[obj] then
                    local ownerName = obj.Name:match("SubspaceTripmine(.+)") or "Unknown"
                    local sel = Instance.new("SelectionBox", obj)
                    sel.Color3 = Color3.fromRGB(200, 200, 200)
                    sel.LineThickness = 0.05
                    local bb = Instance.new("BillboardGui", obj)
                    bb.Size = UDim2.new(0, 250, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = false
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = ownerName .. "'s Subspace Mine"
                    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 16
                    subspaceMineESPData[obj] = {sel = sel, bb = bb}
                end
            end
        end
        for mineObj, data in pairs(subspaceMineESPData) do
            if not currentMines[mineObj] or not mineObj.Parent then
                pcall(function() data.sel:Destroy() end)
                pcall(function() data.bb:Destroy() end)
                subspaceMineESPData[mineObj] = nil
            end
        end
    end
    task.spawn(function()
        while true do
            pcall(refreshSubspaceMineESP)
            task.wait(0.5)
        end
    end)
end

do
    if not _G.__TekCarpetV2Ready then
    -- Ported from OnixHub: selected item is preferred, then supported fallbacks.
    local CARPET_ITEMS = {
        "Flying Carpet", "Waverider", "Santa's Sleigh",
        "Witch's Broom", "Cupid's Wings"
    }
    local carpetOn, carpetConn = false, nil

    local function findCarpetTool(name)
        local c = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:FindFirstChildOfClass("Backpack")
        local sg = LocalPlayer:FindFirstChild("StarterGear")
        return (c and c:FindFirstChild(name))
            or (bp and bp:FindFirstChild(name))
            or (sg and sg:FindFirstChild(name))
    end

    local function setCarpetTool(name)
        if type(name) ~= "string" or name == "" then return end
        Config.CarpetTool = name
        for i = #CARPET_ITEMS, 1, -1 do
            if CARPET_ITEMS[i] == name then table.remove(CARPET_ITEMS, i) end
        end
        table.insert(CARPET_ITEMS, 1, name)
        pcall(SaveConfig)
        if _G.Tek_SyncCarpetToolBtn then pcall(_G.Tek_SyncCarpetToolBtn) end
    end

    local function currentCarpetTool()
        return (type(Config.CarpetTool) == "string" and Config.CarpetTool ~= "" and Config.CarpetTool)
            or CARPET_ITEMS[1]
            or "Flying Carpet"
    end

    local function cycleCarpetTool()
        local fixedOrder = {"Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings"}
        local cur, idx = currentCarpetTool(), 1
        for i, name in ipairs(fixedOrder) do
            if name == cur then idx = i; break end
        end
        local nextName = fixedOrder[(idx % #fixedOrder) + 1]
        setCarpetTool(nextName)
        return nextName
    end

    local function equipCarpet()
        local c = LocalPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum then return nil end
        for _, name in ipairs(CARPET_ITEMS) do
            local tool = findCarpetTool(name)
            if tool and tool:IsA("Tool") then
                if tool.Parent ~= c then pcall(function() hum:EquipTool(tool) end) end
                if tool.Parent == c then return name end
            end
        end
        return nil
    end

    local function setCarpetSpeed(enabled)
        carpetOn = enabled and true or false
        Config.CarpetSpeedEnabled = carpetOn
        if carpetConn then carpetConn:Disconnect(); carpetConn = nil end
        if _G.Tek_SyncCarpetBtn then pcall(_G.Tek_SyncCarpetBtn, carpetOn) end
        if not carpetOn then return end

        carpetConn = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            if LocalPlayer:GetAttribute("Stealing") then
                setCarpetSpeed(false)
                return
            end
            if _G.TekIsTeleporting then return end
            if _G.TekPostTPCooldown and os.clock() < _G.TekPostTPCooldown then return end

            local equippedName = equipCarpet()
            if equippedName and c:FindFirstChild(equippedName) then
                local md = hum.MoveDirection
                local speed = tonumber(Config.CarpetSpeed) or 140
                if md.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        md.X * speed,
                        hrp.AssemblyLinearVelocity.Y,
                        md.Z * speed
                    )
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end
        end)
    end

    _G.Tek_SetCarpetTool = setCarpetTool
    _G.Tek_CurrentCarpetTool = currentCarpetTool
    _G.Tek_CycleCarpetTool = cycleCarpetTool
    _G.Tek_SetCarpetSpeed = setCarpetSpeed
    _G.Tek_ToggleCarpetSpeed = function()
        setCarpetSpeed(not carpetOn)
        pcall(SaveConfig)
        return carpetOn
    end

    setCarpetTool(currentCarpetTool())
    setCarpetSpeed(false)
    pcall(function()
        LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
            if LocalPlayer:GetAttribute("Stealing") and carpetOn then
                setCarpetSpeed(false)
                pcall(SaveConfig)
            end
        end)
    end)
    end
end

task.spawn(function()
    if _G._AntiBeeDiscoInstant then return end
    _G._AntiBeeDiscoInstant = true

    local Lighting = game:GetService("Lighting")

    local badLightingNames = {
        Blue            = true,
        DiscoEffect     = true,
        BeeBlur         = true,
        ColorCorrection = true,
    }

    local function nukeObj(obj)
        if not obj or not obj.Parent then return end
        if badLightingNames[obj.Name] then
            pcall(function() obj:Destroy() end)
        end
    end

    for _, inst in ipairs(Lighting:GetDescendants()) do
        nukeObj(inst)
    end
    Lighting.DescendantAdded:Connect(nukeObj)

    RunService.Heartbeat:Connect(function()
        pcall(function()
            local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            if not playerScripts then return end
            local beeScript = playerScripts:FindFirstChild("Bee", true)
            if beeScript then
                local buzzing = beeScript:FindFirstChild("Buzzing")
                if buzzing and buzzing:IsA("Sound") then
                    buzzing:Stop(); buzzing.Volume = 0
                end
            end
        end)
    end)
end)

task.spawn(function()
    if _G._AntiEffectsAlwaysOn then return end
    _G._AntiEffectsAlwaysOn = true

    pcall(function()
        local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts", 10)
            and LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
        if not PlayerModule then return end
        local Controls = require(PlayerModule):GetControls()
        if not Controls then return end
        local originalMoveFunction = Controls.moveFunction
        local protectedMove = function(self, moveVector, relativeToCamera)
            if originalMoveFunction then
                originalMoveFunction(self, moveVector, relativeToCamera)
            end
        end
        Controls.moveFunction = protectedMove
        RunService.Heartbeat:Connect(function()
            if Controls.moveFunction ~= protectedMove then
                Controls.moveFunction = protectedMove
            end
        end)
    end)
end)

task.spawn(function()
    if _G._LineToBaseAlwaysOn then return end
    _G._LineToBaseAlwaysOn = true

    local function getMyPlotCenter()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local yourBase = sign:FindFirstChild("YourBase")
                if yourBase and yourBase.Enabled then
                    local basePart = plot:FindFirstChild("Base")
                        or plot:FindFirstChildWhichIsA("BasePart", true)
                    if basePart then return basePart.Position end
                    local ok, cf = pcall(function() return plot:GetPivot() end)
                    if ok then return cf.Position end
                end
            end
        end
        return nil
    end

    local linePart = Instance.new("Part")
    linePart.Name = "LineToBase"
    linePart.Anchored = true
    linePart.CanCollide = false
    linePart.CanQuery = false
    linePart.CanTouch = false
    linePart.CastShadow = false
    linePart.Shape = Enum.PartType.Cylinder
    linePart.Color = Color3.fromRGB(255, 255, 255)
    linePart.Transparency = 0.1
    linePart.Material = Enum.Material.Neon
    linePart.Size = Vector3.new(0.01, 0.01, 0.01)
    linePart.Parent = Workspace

    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then linePart.Size = Vector3.new(0.01, 0.01, 0.01); return end

        local basePos = getMyPlotCenter()
        if not basePos then linePart.Size = Vector3.new(0.01, 0.01, 0.01); return end

        local from = hrp.Position
        local to   = basePos
        local dist = (to - from).Magnitude
        if dist < 1 then linePart.Size = Vector3.new(0.01, 0.01, 0.01); return end

        linePart.Size   = Vector3.new(0.35, dist, 0.35)
        linePart.CFrame = CFrame.new(from:Lerp(to, 0.5), to) * CFrame.Angles(0, math.rad(90), 0)
    end)

    _G.Tek_GetLineToBasePart = function() return linePart end
end)



-- PERF HUD: FPS | PING | LOADTIME (replaces old DATA/NET + plot timer)
task.spawn(function()
    pcall(function()
        local pg0 = LocalPlayer:FindFirstChildOfClass("PlayerGui") or PlayerGui
        local old = pg0 and pg0:FindFirstChild("TekPerfHud")
        if old then old:Destroy() end
    end)

    local bootT0 = _G.TekBootT0 or (typeof(tick) == "function" and tick() or os.clock())
    local loadSecs = tonumber(_G.TekLoadedSecs)
    if not loadSecs then
        loadSecs = (typeof(tick) == "function" and tick() or os.clock()) - bootT0
        _G.TekLoadedSecs = loadSecs
    end
    local loadStr = string.format("%.1fs", math.max(0, loadSecs))

    local perfSg = Instance.new("ScreenGui")
    perfSg.Name = "TekPerfHud"
    perfSg.ResetOnSpawn = false
    perfSg.IgnoreGuiInset = true
    perfSg.DisplayOrder = 999
    perfSg.Parent = PlayerGui
    if registerScreenGui then pcall(registerScreenGui, perfSg) end

    local perfHud = Instance.new("Frame", perfSg)
    perfHud.Name = "PerfHud"
    perfHud.AnchorPoint = Vector2.new(0.5, 0)
    perfHud.Position = UDim2.new(0.5, 0, 0, 8)
    perfHud.Size = UDim2.fromOffset(230, 32)
    perfHud.AutomaticSize = Enum.AutomaticSize.X
    perfHud.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
    perfHud.BackgroundTransparency = 0.04
    perfHud.BorderSizePixel = 0
    perfHud.ZIndex = 50
    do
        local st = Instance.new("UIStroke", perfHud)
        st.Color = Color3.fromRGB(44, 44, 44)
        st.Thickness = 1
        st.Transparency = 0.2
    end
    do
        local c = Instance.new("UICorner", perfHud)
        c.CornerRadius = UDim.new(0, 10)
    end
    do
        local gradient = Instance.new("UIGradient", perfHud)
        gradient.Rotation = 135
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 6))
        })
    end
    local pad = Instance.new("UIPadding", perfHud)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)

    local lbl = Instance.new("TextLabel", perfHud)
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.ZIndex = 51
    lbl.Text = string.format("FPS: -- | PING: --ms | LOAD: %s", loadStr)

    local _frames = 0
    game:GetService("RunService").RenderStepped:Connect(function() _frames = _frames + 1 end)

    local last = os.clock()
    while perfHud.Parent do
        task.wait(0.5)
        local now = os.clock()
        local dt = now - last
        local fps = (dt > 0) and math.floor(_frames / dt + 0.5) or 0
        _frames, last = 0, now

        local ping = 0
        pcall(function() ping = math.floor((LocalPlayer:GetNetworkPing() * 1000) + 0.5) end)

        lbl.Text = string.format("FPS: %d | PING: %dms | LOAD: %s", fps, ping, loadStr)
    end
end)

-- =====================================================================
-- LASER CAPE SHOT
-- Direct UseItem shot at the nearest living player inside the server-side
-- 60-stud cape range. No cursor spoofing, clone teleport or legacy range ring.
-- =====================================================================
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TOOL_NAME = "Laser Cape"
    local RANGE = 60
    local EQUIP_TIMEOUT = 0.5
    local HOLD_AFTER_SHOT = 0.2
    local NET_SALT = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
    local SEPARATOR = string.byte("/")
    local HASH_LEN = 64
    local SCHEME_SAMPLES = 5
    local cryptLib = crypt or (syn and syn.crypt)

    local function hashName(logical)
        local jobId = game.JobId
        if jobId == "" then return nil end
        local key = table.pack(string.byte(jobId, 1, -1))
        if key.n == 0 then return nil end
        local out = table.create(#logical)
        local keyIndex = 1
        for i = 1, #logical do
            local byte = string.byte(logical, i)
            if byte == SEPARATOR then
                out[i] = "/"
            else
                out[i] = string.char((byte - 32 + key[keyIndex]) % 95 + 32)
                keyIndex = keyIndex % key.n + 1
            end
        end
        return string.lower(cryptLib.hash(table.concat(out) .. NET_SALT .. jobId, "SHA256"))
    end

    local function isHashed(body)
        return #body == HASH_LEN and string.match(body, "^%x+$") ~= nil
    end

    local function schemeMatches(folder)
        local checked, matched = 0, 0
        for _, child in ipairs(folder:GetChildren()) do
            if checked >= SCHEME_SAMPLES then break end
            local prefix, body = string.match(child.Name, "^(%a+/)(.+)$")
            if not prefix or isHashed(body) then continue end
            checked += 1
            local hashed = hashName(body)
            if hashed and folder:FindFirstChild(prefix .. hashed) then matched += 1 end
        end
        return checked > 0 and matched == checked
    end

    local function resolveUseItem()
        if type(cryptLib) ~= "table" or type(cryptLib.hash) ~= "function" then
            return nil, "crypt.hash unavailable"
        end
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        local folder = packages and packages:FindFirstChild("Net")
        if not folder then return nil, "Packages.Net unavailable" end
        local ok, matches = pcall(schemeMatches, folder)
        if not ok or not matches then return nil, "remote hash scheme mismatch" end
        local hash = hashName("UseItem")
        local remote = hash and folder:FindFirstChild("RE/" .. hash)
        if not remote or not remote:IsA("RemoteEvent") then
            return nil, "UseItem remote unavailable"
        end
        return remote
    end

    local function aliveRoot(character)
        if not character then return nil end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return nil end
        return character:FindFirstChild("HumanoidRootPart")
    end

    local function targetSnapshot(plr, myRoot)
        if not plr or plr == LocalPlayer or not plr.Parent then return nil end
        local root = aliveRoot(plr.Character)
        if not root then return nil end
        return root, myRoot and (root.Position - myRoot.Position).Magnitude or nil
    end

    local function findCape(character)
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        return character and character:FindFirstChild(TOOL_NAME)
            or (backpack and backpack:FindFirstChild(TOOL_NAME))
    end

    local function equipCape(humanoid, character, tool)
        if tool.Parent == character then return true end
        humanoid:EquipTool(tool)
        local deadline = os.clock() + EQUIP_TIMEOUT
        while tool.Parent ~= character and os.clock() < deadline do task.wait() end
        return tool.Parent == character
    end

    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
    if not pg then return end
    local old = pg:FindFirstChild("TekLaserCape")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "TekLaserCape"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 9999998
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg
    pcall(registerScreenGui, sg)

    local panel = Instance.new("Frame")
    panel.Name = "LaserCapePanel"
    panel.Size = UDim2.fromOffset(310, 264)
    panel.Position = UDim2.new(1, -328, 0.5, -115)
    panel.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Parent = sg
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Color3.fromRGB(72, 72, 72)
    panelStroke.Thickness = 1
    panelStroke.Transparency = 0.25

    local gradient = Instance.new("UIGradient", panel)
    gradient.Rotation = 135
    gradient.Color = ColorSequence.new(
        Color3.fromRGB(32, 32, 32),
        Color3.fromRGB(14, 14, 14)
    )

    local titleBar = Instance.new("Frame", panel)
    titleBar.Size = UDim2.new(1, 0, 0, 34)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BackgroundTransparency = 0.08
    titleBar.BorderSizePixel = 0
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", titleBar)
    title.Position = UDim2.fromOffset(12, 0)
    title.Size = UDim2.new(1, -54, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "LASER CAPE"

    local close = Instance.new("TextButton", titleBar)
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -7, 0.5, 0)
    close.Size = UDim2.fromOffset(24, 24)
    close.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    close.BorderSizePixel = 0
    close.AutoButtonColor = false
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    close.TextColor3 = Color3.fromRGB(182, 182, 182)
    close.Text = "X"
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

    local statusLabel = Instance.new("TextLabel", panel)
    statusLabel.Position = UDim2.fromOffset(10, 238)
    statusLabel.Size = UDim2.new(1, -20, 0, 16)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 9
    statusLabel.TextColor3 = Color3.fromRGB(152, 152, 152)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    statusLabel.Text = "CLICK A PLAYER TO FIRE"

    local playerList = Instance.new("ScrollingFrame", panel)
    playerList.Position = UDim2.fromOffset(8, 40)
    playerList.Size = UDim2.new(1, -16, 0, 156)
    playerList.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
    playerList.BackgroundTransparency = 0.12
    playerList.BorderSizePixel = 0
    playerList.ScrollBarThickness = 3
    playerList.ScrollBarImageColor3 = Color3.fromRGB(118, 118, 118)
    playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerList.CanvasSize = UDim2.fromOffset(0, 0)
    Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 9)
    local listPadding = Instance.new("UIPadding", playerList)
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    local listLayout = Instance.new("UIListLayout", playerList)
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local opener = Instance.new("TextButton", sg)
    opener.Name = "LaserCapeOpen"
    opener.AnchorPoint = Vector2.new(1, 1)
    opener.Position = UDim2.new(1, -18, 1, -150)
    opener.Size = UDim2.fromOffset(42, 42)
    opener.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
    opener.BorderSizePixel = 0
    opener.AutoButtonColor = false
    opener.Font = Enum.Font.GothamBlack
    opener.TextSize = 18
    opener.TextColor3 = Color3.fromRGB(255, 255, 255)
    opener.Text = "L"
    opener.Visible = false
    Instance.new("UICorner", opener).CornerRadius = UDim.new(1, 0)

    task.defer(function() applySavedPosition("LaserCapePanel", panel) end)

    local statusUntil = 0
    local busy = false
    local selectedPlayer = nil
    local playerButtons = {}
    local shootSelected, shootAndGrab
    local function setStatus(text, color, hold)
        statusLabel.Text = tostring(text)
        statusLabel.TextColor3 = color or Color3.fromRGB(152, 152, 152)
        statusUntil = os.clock() + (tonumber(hold) or 0)
    end

    local function restoreTool(humanoid, previousTool, cape)
        task.wait(HOLD_AFTER_SHOT)
        if previousTool and previousTool ~= cape and previousTool.Parent then
            pcall(function() humanoid:EquipTool(previousTool) end)
        else
            pcall(function() humanoid:UnequipTools() end)
        end
    end

    local function stealingText(plr)
        if not plr then return "—", false end
        local character = plr.Character
        local index = plr:GetAttribute("StealingIndex")
        if index == nil and character then index = character:GetAttribute("StealingIndex") end
        local stealing = plr:GetAttribute("Stealing") == true
            or (character and character:GetAttribute("Stealing") == true)
            or (index ~= nil and tostring(index) ~= "")
        if not stealing then return "—", false end
        local name = index ~= nil and tostring(index) or "Brainrot"
        local info = _AD and _AD[name]
        if type(info) == "table" then name = tostring(info.DisplayName or info.Name or name) end
        return name, true
    end

    local function paintPlayerButtons()
        for plr, row in pairs(playerButtons) do
            local selected = plr == selectedPlayer
            row.card.BackgroundColor3 = selected and Color3.fromRGB(97, 97, 97) or Color3.fromRGB(39, 39, 39)
            row.left.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(207, 207, 207)
            if selected then row.right.TextColor3 = Color3.fromRGB(255, 255, 255) end
        end
    end

    local function selectPlayer(plr)
        selectedPlayer = (plr and plr ~= LocalPlayer and plr.Parent) and plr or nil
        paintPlayerButtons()
        if selectedPlayer then
            setStatus("SELECTED  " .. selectedPlayer.Name, Color3.fromRGB(188, 188, 188), 1)
        else
            setStatus("SELECT A PLAYER", Color3.fromRGB(152, 152, 152), 0)
        end
        return selectedPlayer ~= nil
    end
    _G.TekLaserCapeSelect = function(value)
        if typeof(value) == "Instance" and value:IsA("Player") then return selectPlayer(value) end
        if type(value) == "string" then
            local wanted = value:lower()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and (plr.Name:lower() == wanted or plr.DisplayName:lower() == wanted) then
                    return selectPlayer(plr)
                end
            end
        end
        return false
    end

    local grabMode, grabRunning, grabCancelled = false, false, false
    local grabButton = Instance.new("TextButton", panel)
    grabButton.Position = UDim2.fromOffset(10, 201)
    grabButton.Size = UDim2.new(1, -20, 0, 27)
    grabButton.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
    grabButton.TextColor3 = Color3.fromRGB(245, 245, 245)
    grabButton.Font = Enum.Font.GothamBold
    grabButton.TextSize = 11
    grabButton.Text = "SHOT + GRAB: OFF"
    Instance.new("UICorner", grabButton).CornerRadius = UDim.new(0, 7)
    grabButton.MouseButton1Click:Connect(function()
        if grabRunning then
            grabCancelled = true
            grabButton.Text = "CANCELLING..."
            return
        end
        grabMode = not grabMode
        grabButton.Text = grabMode and "SHOT + GRAB: ON" or "SHOT + GRAB: OFF"
        setStatus(grabMode and "CLICK THE PLAYER CARRYING A BRAINROT" or "CLICK A PLAYER TO FIRE", nil, 3)
    end)
    shootAndGrab = function(target)
        if grabRunning or busy then return end
        local bridge = _G.TekLaserGrab
        if not bridge then setStatus("UPDATE/LOAD TP FIRST", nil, 3); return end
        grabRunning, grabCancelled = true, false
        grabButton.Text = "CANCEL SHOT + GRAB"
        local session
        local ok, message = pcall(function()
            local why
            session, why = bridge.Begin(target)
            if not session then return why end
            local deadline = os.clock()+8
            local fired = false
            while sg.Parent and not grabCancelled and selectedPlayer == target and os.clock()<deadline do
                local myRoot=aliveRoot(LocalPlayer.Character)
                local targetRoot, distance=targetSnapshot(target,myRoot)
                if not myRoot or not targetRoot then return "player unavailable" end
                local ready, status, done=bridge.Poll(session,false)
                if done then return status end
                setStatus(status, Color3.fromRGB(188, 188, 188), 1)
                if ready and distance <= RANGE then
                    -- Recheck after equip, immediately before the single shot.
                    fired = shootSelected(target, function()
                        if grabCancelled or selectedPlayer ~= target or not sg.Parent then return false end
                        local can, _, ended=bridge.Poll(session,false)
                        return can and not ended
                    end, function() bridge.Shot(session) end)
                    if not fired then return "shot cancelled: readiness changed" end
                    break
                end
                if distance > RANGE then setStatus("MOVE INSIDE LASER RANGE", nil, 1) end
                task.wait(0.03)
            end
            if not fired then return grabCancelled and "cancelled" or "preparation timed out" end
            deadline = os.clock() + (session.unprimedShot and 5 or 3)
            while sg.Parent and not grabCancelled and selectedPlayer == target and os.clock()<deadline do
                local _, status, done=bridge.Poll(session,true)
                if done then return status end
                setStatus(status, nil, 1)
                task.wait(0.03)
            end
            return grabCancelled and "cancelled" or ("timeout: " .. tostring(session.status or "pickup not confirmed"))
        end)
        if session then pcall(bridge.Finish,session) end
        grabRunning=false
        grabButton.Text=grabMode and "SHOT + GRAB: ON" or "SHOT + GRAB: OFF"
        if sg.Parent then setStatus(tostring(message), ok and Color3.fromRGB(204, 204, 204) or Color3.fromRGB(137, 137, 137), 4) end
    end

    local function rebuildPlayerList()
        for _, row in pairs(playerButtons) do if row.card then row.card:Destroy() end end
        playerButtons = {}
        local list = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then list[#list + 1] = plr end
        end
        table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
        for order, plr in ipairs(list) do
            local card = Instance.new("TextButton", playerList)
            card.Name = "Player_" .. plr.UserId
            card.LayoutOrder = order
            card.Size = UDim2.new(1, -2, 0, 30)
            card.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
            card.BackgroundTransparency = 0.04
            card.BorderSizePixel = 0
            card.AutoButtonColor = false
            card.Text = ""
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)

            local left = Instance.new("TextLabel", card)
            left.Position = UDim2.fromOffset(9, 0)
            left.Size = UDim2.new(0.55, -9, 1, 0)
            left.BackgroundTransparency = 1
            left.Font = Enum.Font.GothamBold
            left.TextSize = 10
            left.TextColor3 = Color3.fromRGB(207, 207, 207)
            left.TextXAlignment = Enum.TextXAlignment.Left
            left.TextTruncate = Enum.TextTruncate.AtEnd
            left.Text = plr.Name

            local right = Instance.new("TextLabel", card)
            right.Position = UDim2.new(0.55, 0, 0, 0)
            right.Size = UDim2.new(0.45, -9, 1, 0)
            right.BackgroundTransparency = 1
            right.Font = Enum.Font.GothamBold
            right.TextSize = 9
            right.TextColor3 = Color3.fromRGB(128, 128, 128)
            right.TextXAlignment = Enum.TextXAlignment.Right
            right.TextTruncate = Enum.TextTruncate.AtEnd
            right.Text = "—"

            card.MouseButton1Click:Connect(function()
                if grabRunning then
                    setStatus("CANCEL CURRENT SHOT + GRAB FIRST", nil, 2)
                    return
                end
                selectPlayer(plr)
                if grabMode then task.spawn(shootAndGrab, plr)
                else task.spawn(shootSelected) end
            end)
            playerButtons[plr] = { card = card, left = left, right = right }
        end
        paintPlayerButtons()
    end

    Players.PlayerAdded:Connect(function() task.defer(rebuildPlayerList) end)
    Players.PlayerRemoving:Connect(function(plr)
        if selectedPlayer == plr then selectedPlayer = nil end
        task.defer(rebuildPlayerList)
    end)
    rebuildPlayerList()

    shootSelected = function(targetOverride, beforeShot, afterShot)
        if grabRunning and not beforeShot then return false, "pickup preparation active" end
        if busy then return false, "shot already in progress" end
        busy = true
        setStatus("FIRING  " .. (selectedPlayer and selectedPlayer.Name or ""), Color3.fromRGB(188, 188, 188), 2)

        local ok, fired, message = pcall(function()
            local character = LocalPlayer.Character
            local myRoot = aliveRoot(character)
            if not myRoot then return false, "character unavailable" end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local cape = findCape(character)
            if not cape or not cape:IsA("Tool") then return false, "Laser Cape not in inventory" end

            local target = targetOverride or selectedPlayer
            if not target or not target.Parent then return false, "select a player" end
            local targetRoot, distance = targetSnapshot(target, myRoot)
            if not targetRoot then return false, "selected player is not alive" end
            if distance > RANGE then return false, "selected player is outside 60 studs" end
            local remote, why = resolveUseItem()
            if not remote then return false, why end

            local previousTool = character:FindFirstChildOfClass("Tool")
            if not equipCape(humanoid, character, cape) then
                if previousTool and previousTool.Parent then pcall(function() humanoid:EquipTool(previousTool) end) end
                return false, "failed to equip Laser Cape"
            end

            targetRoot = aliveRoot(target.Character)
            if not targetRoot then
                restoreTool(humanoid, previousTool, cape)
                return false, "target disappeared"
            end
            distance = (targetRoot.Position - myRoot.Position).Magnitude
            if distance > RANGE then
                restoreTool(humanoid, previousTool, cape)
                return false, "target left 60-stud range"
            end

            if beforeShot and not beforeShot() then
                restoreTool(humanoid, previousTool, cape)
                return false, "pickup not ready"
            end
            remote:FireServer(targetRoot.Position, targetRoot)
            if afterShot then
                local called, err = pcall(afterShot)
                if not called then _G.TekLaserGrabShotError = tostring(err) end
                -- Pickup polling continues immediately; tool restoration need not block it.
                task.spawn(restoreTool, humanoid, previousTool, cape)
            else
                restoreTool(humanoid, previousTool, cape)
            end
            return true, target.Name .. " • " .. string.format("%.1f studs", distance)
        end)

        busy = false
        if not ok then
            setStatus("ERROR  " .. tostring(fired), Color3.fromRGB(137, 137, 137), 3)
            return false
        end
        if fired then
            setStatus("FIRED  " .. tostring(message), Color3.fromRGB(188, 188, 188), 2)
            return true
        end
        setStatus(string.upper(tostring(message)), Color3.fromRGB(145, 145, 145), 2.5)
        return false
    end
    _G.TekLaserCapeShoot = shootSelected

    local function setVisible(on)
        panel.Visible = on == true
        opener.Visible = not panel.Visible
    end
    close.MouseButton1Click:Connect(function() setVisible(false) end)
    opener.MouseButton1Click:Connect(function() setVisible(true) end)
    _G.TekToggleLaserPanel = function()
        setVisible(not panel.Visible)
        return panel.Visible
    end

    do
        local dragging, dragStart, panelStart = false, nil, nil
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, panelStart = true, input.Position, panel.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and not _G._TekPanelDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                panel.Position = UDim2.new(
                    panelStart.X.Scale, panelStart.X.Offset + delta.X,
                    panelStart.Y.Scale, panelStart.Y.Offset + delta.Y
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                pcall(function() rememberPosition("LaserCapePanel", panel) end)
            end
        end)
    end

    task.spawn(function()
        while sg.Parent do
            local character = LocalPlayer.Character
            local myRoot = aliveRoot(character)
            local target = selectedPlayer
            local targetRoot, distance = targetSnapshot(target, myRoot)
            for plr, row in pairs(playerButtons) do
                if plr.Parent and row.card.Parent then
                    local root, playerDistance = targetSnapshot(plr, myRoot)
                    row.left.Text = plr.Name .. (playerDistance and string.format("  •  %.0f", playerDistance) or "  •  —")
                    row.left.TextTransparency = root and 0 or 0.45
                    local stolen, isStealing = stealingText(plr)
                    row.right.Text = stolen
                    row.right.TextColor3 = plr == selectedPlayer and Color3.fromRGB(255, 255, 255)
                        or (isStealing and Color3.fromRGB(129, 129, 129) or Color3.fromRGB(128, 128, 128))
                    row.right.TextTransparency = root and 0 or 0.45
                end
            end
            if not busy and os.clock() >= statusUntil then
                if not character or not findCape(character) then
                    setStatus("LASER CAPE NOT IN INVENTORY", Color3.fromRGB(188, 188, 188), 0)
                elseif not myRoot then
                    setStatus("CHARACTER UNAVAILABLE", Color3.fromRGB(145, 145, 145), 0)
                elseif not target then
                    setStatus("CLICK A PLAYER TO FIRE", Color3.fromRGB(152, 152, 152), 0)
                elseif not targetRoot then
                    setStatus("SELECTED PLAYER IS NOT ALIVE", Color3.fromRGB(145, 145, 145), 0)
                elseif distance > RANGE then
                    setStatus("OUT OF RANGE", Color3.fromRGB(188, 188, 188), 0)
                else
                    setStatus("READY", Color3.fromRGB(188, 188, 188), 0)
                end
            end
            task.wait(0.12)
        end
    end)
end)

-- ============================================================
--  AI PATH AVOIDER  (8-stud vertical / 6-stud horizontal)
--  Rewires computeRoute so every TP first tries an obstacle-
--  aware path.  Set _G.TekAIAvoid = false to disable.
-- ============================================================
do

-- ── tuneable knobs ───────────────────────────────────────────
local AI_VCLR  = 8    -- vertical clearance (studs above obstacle)
local AI_HCLR  = 6    -- horizontal clearance (studs wide each side)
local AI_STEP  = 6    -- horizontal probe step along path
local AI_SCAN_H = 8   -- sensor box full height while probing
local AI_MAX_LIFT = 60 -- give up if obstacle top + clearance > this above start

-- Push the voxel A* to the same spec so its inner grid agrees
if (tonumber(_G.TekPathCell)   or 0) < 4 then _G.TekPathCell   = 4   end
if (tonumber(_G.TekPathRadius) or 0) < 3 then _G.TekPathRadius = 3   end  -- 3 inflate → 6-stud corridor
if (tonumber(_G.TekPathHeight) or 0) < 8 then _G.TekPathHeight = 8   end  -- 8-stud tall voxels
if (tonumber(_G.TekHopMaxUp)   or 0) < AI_VCLR + AI_MAX_LIFT then
    _G.TekHopMaxUp = AI_VCLR + AI_MAX_LIFT
end

-- ── raycast params shared by this module ────────────────────
local _aiRP = RaycastParams.new()
_aiRP.FilterType    = Enum.RaycastFilterType.Exclude
_aiRP.IgnoreWater   = true

local function _aiSetFilter()
    local skip = {}
    local ch = LP.Character
    if ch then skip[#skip+1] = ch end
    for _, cl in ipairs(_OTHER_CLONES or {}) do skip[#skip+1] = cl end
    _aiRP.FilterDescendantsInstances = skip
end

-- ── obstacle detection helpers ───────────────────────────────
local function _aiIsBlocker(inst)
    if not inst then return false end
    local n = inst.Name
    local _SKIP = { DeliveryHitbox=true, StealHitbox=true, LaserHitbox=true,
                    AnimalTarget=true, Multiplier=true, Laser=true, Hitbox=true,
                    Spawn=true, MainRoot=true }
    if _SKIP[n] then return false end
    if inst.CanCollide then return true end
    local s = inst.Size
    if s and math.max(s.X*s.Y, s.X*s.Z, s.Y*s.Z) > 30 then return true end
    return false
end

-- Returns the world-Y top of a part, accounting for rotation.
local function _aiPartTop(inst)
    local ok, top = pcall(function()
        local cf, sz = inst.CFrame, inst.Size
        local half = (math.abs(cf.RightVector.Y)*sz.X
                    + math.abs(cf.UpVector.Y)   *sz.Y
                    + math.abs(cf.LookVector.Y)  *sz.Z) / 2
        return cf.Position.Y + half
    end)
    return ok and top or (inst.Position.Y + inst.Size.Y/2)
end

-- Sweep a horizontal corridor from `a` to `b` using a blockcast with
-- the specified half-width and half-height.  Returns highest obstacle
-- top-Y seen, or nil if clear.
local function _aiSweeepTop(a, b, hw, hh)
    local dir = b - a
    if dir.Magnitude < 0.05 then return nil end
    _aiSetFilter()
    -- centre of the sensor box sits at mid-height of the agent
    local cA = Vector3.new(a.X, a.Y, a.Z)
    local res = workspace:Blockcast(
        CFrame.new(cA),
        Vector3.new(hw*2, hh*2, hw*2),
        dir,
        _aiRP
    )
    if not res then return nil end
    if not _aiIsBlocker(res.Instance) then
        -- keep scanning through non-blockers (up to 8 iterations)
        local skip = { res.Instance }
        for _ = 1, 8 do
            local rp2 = RaycastParams.new()
            rp2.FilterType = Enum.RaycastFilterType.Exclude
            rp2.IgnoreWater = true
            local base = {}
            if LP.Character then base[#base+1] = LP.Character end
            for _, cl in ipairs(_OTHER_CLONES or {}) do base[#base+1] = cl end
            for _, s in ipairs(skip) do base[#base+1] = s end
            rp2.FilterDescendantsInstances = base
            local r2 = workspace:Blockcast(CFrame.new(cA), Vector3.new(hw*2,hh*2,hw*2), dir, rp2)
            if not r2 then return nil end
            if _aiIsBlocker(r2.Instance) then return _aiPartTop(r2.Instance) end
            skip[#skip+1] = r2.Instance
        end
        return nil
    end
    return _aiPartTop(res.Instance)
end

-- ── core AI avoider ──────────────────────────────────────────
-- Walk from `fromPos` to `toPos` in horizontal steps.
-- When an obstacle is detected, insert a vertical lift waypoint
-- (obstacleTop + AI_VCLR) and a horizontal offset waypoint
-- (AI_HCLR studs perpendicular) if still blocked at cruise height.
-- Returns a waypoint table or nil when no clean path was found.
local function _aiAvoidRoute(fromPos, toPos)
    if _G.TekAIAvoid == false then return nil end

    local flat  = Vector3.new(toPos.X - fromPos.X, 0, toPos.Z - fromPos.Z)
    local dist  = flat.Magnitude
    if dist < AI_STEP then return nil end   -- too close, nothing to do

    local dir     = flat.Unit
    local perpXZ  = Vector3.new(-dir.Z, 0, dir.X)
    local groundY = fromPos.Y
    local hw      = AI_HCLR / 2        -- half-width for blockcast
    local hh      = AI_SCAN_H / 2      -- half-height for blockcast

    local route        = {}
    local cruiseY      = groundY       -- current Y the agent is flying at
    local inLift       = false         -- are we currently over an obstacle?
    local descentStart = nil           -- X,Z position where we started descending

    local i = AI_STEP
    while i <= dist + AI_STEP do
        local tClamp = math.min(i, dist)
        local a = fromPos + dir * (i - AI_STEP)
        local b = fromPos + dir * tClamp
        -- Probe at current cruise height
        local probeA = Vector3.new(a.X, cruiseY, a.Z)
        local probeB = Vector3.new(b.X, cruiseY, b.Z)

        local blockerTop = _aiSweeepTop(probeA, probeB, hw, hh)

        if blockerTop then
            local wantY = blockerTop + AI_VCLR
            if wantY - groundY > AI_MAX_LIFT then
                return nil  -- obstacle too tall; fall back to voxel A*
            end

            -- Try straight vertical lift first
            if not inLift then
                -- Lift up to wantY at current X,Z
                route[#route+1] = Vector3.new(a.X, wantY, a.Z)
                cruiseY = wantY
                inLift  = true
            elseif wantY > cruiseY then
                -- Obstacle grew; lift higher
                route[#route+1] = Vector3.new(a.X, wantY, a.Z)
                cruiseY = wantY
            end

            -- Also check if a horizontal sidestep at cruise height helps
            -- (handles wall-like obstacles that protrude to both sides)
            local sideA_L = probeA + perpXZ * AI_HCLR
            local sideB_L = probeB + perpXZ * AI_HCLR
            local sideA_R = probeA - perpXZ * AI_HCLR
            local sideB_R = probeB - perpXZ * AI_HCLR
            local blockL  = _aiSweeepTop(sideA_L, sideB_L, hw, hh)
            local blockR  = _aiSweeepTop(sideA_R, sideB_R, hw, hh)

            -- If the vertical lift alone didn't clear it at a horizontal
            -- offset, record the best side offset waypoint
            local lifted_A = Vector3.new(a.X, cruiseY, a.Z)
            local lifted_B = Vector3.new(b.X, cruiseY, b.Z)
            local stillBlocked = _aiSweeepTop(lifted_A, lifted_B, hw, hh)
            if stillBlocked then
                local topL = blockL and (blockL + AI_VCLR) or cruiseY
                local topR = blockR and (blockR + AI_VCLR) or cruiseY
                if topL <= topR then
                    -- go left
                    route[#route+1] = Vector3.new(a.X + perpXZ.X*AI_HCLR, cruiseY, a.Z + perpXZ.Z*AI_HCLR)
                else
                    -- go right
                    route[#route+1] = Vector3.new(a.X - perpXZ.X*AI_HCLR, cruiseY, a.Z - perpXZ.Z*AI_HCLR)
                end
            end
        else
            -- Clear segment — if we were lifted, start descending back toward ground
            if inLift then
                descentStart = b
                inLift = false
            elseif descentStart then
                -- Gradually return to ground over 2 steps
                local blend = math.min((b - descentStart).Magnitude / (AI_STEP * 2), 1)
                local newY  = cruiseY + (groundY - cruiseY) * blend
                if math.abs(newY - groundY) < 1 then
                    cruiseY       = groundY
                    descentStart  = nil
                else
                    cruiseY = newY
                end
                route[#route+1] = Vector3.new(b.X, cruiseY, b.Z)
            end
        end
        i = i + AI_STEP
    end

    -- Always end exactly at toPos
    route[#route+1] = toPos
    -- Prune trivial duplicates
    if #route < 2 then return nil end   -- nothing interesting was added
    return route
end

_G.TekAIAvoidRoute = _aiAvoidRoute  -- expose for external callers

-- ── monkey-patch computeRoute ────────────────────────────────
-- Keep the original function in _G so it can still be called.
local _origComputeRoute = computeRoute  -- upvalue captured here
_G.TekOrigComputeRoute = _origComputeRoute

computeRoute = function(fromPos, toPos, facingDir, maxLift, preferCrest)
    -- 1. Try AI avoider first (fast, purpose-built for this obstacle spec)
    if _G.TekAIAvoid ~= false then
        local ai = _aiAvoidRoute(fromPos, toPos)
        if ai and #ai > 1 then
            if _G.TekTPDebug then
                print("[AIAvoid] path with", #ai, "waypoints")
            end
            return ai
        end
    end

    -- 2. Fall through to the original routing pipeline (hop → crest → voxel A* → nav mesh)
    return _origComputeRoute(fromPos, toPos, facingDir, maxLift, preferCrest)
end

_G.TekComputeRoute = computeRoute  -- keep _G ref fresh

-- Default to enabled
if _G.TekAIAvoid == nil then _G.TekAIAvoid = true end

end  -- AI PATH AVOIDER block