-- standalone: selected carpet -> base-owner TP -> follow -> verify behind + carpet -> Body Swap Potion -> swap

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local STOP_KEY = "_SKYRO_BANG_SWAP_STOP"
if type(_G[STOP_KEY]) == "function" then
    pcall(_G[STOP_KEY])
end

local CARPETS = {
    "Flying Carpet", "Waverider", "Skeleton Dragon",
    "Witch's Broom", "Santa's Sleigh", "Cupid's Wings",
}
local BODY_TOOL = "Body Swap Potion"
-- from BodySwapScript: its client code stops targeting while this attribute is truthy (cooldown marker).
-- the decompile does not show what upvalue4 is; assumed to be the tool itself.
local COOLDOWN_ATTR = "CooldownTime"

local dead = false
local busy = false
local cancelled = false
local targets = {}
local followConn = nil
local uiConns = {}
local refreshConn = nil
local state = {
    toolIndex = 1,
    auto = true,
    antiDie = true,
    phase = "idle",
    targetUserId = nil,
    followOffset = 1.1,   -- studs behind the target's torso (+Z in the torso's object space)
    tpOffset = 2.6,
    behindTol = 2,        -- studs of slack per axis for the "still behind them" check
    verifyTimeout = 3,    -- seconds to get carpet + position right before the potion comes out
    equipSettle = 0.45,   -- seconds the carpet must stay in the character before any teleport
    potionSettle = 0.15,  -- seconds the potion must stay held before it is activated
    swapTimeout = 4,      -- seconds to keep activating the potion before giving up
    activateInterval = 0.1, -- seconds between potion:Activate() calls
    postTpDelay = 0.15,   -- seconds to sit behind the target after the teleport before the verify gate and potion
    msg = "ready",
    msgAt = os.clock(),
}

local function note(fmt, ...)
    state.msg = string.format(fmt, ...)
    state.msgAt = os.clock()
end

local DEBUG_FILE = "skyr0_bang_debug.txt"
local debugBuf = {}
local function dlog(fmt, ...)
    local line = string.format("[%.3f] " .. fmt, os.clock(), ...)
    debugBuf[#debugBuf + 1] = line
    if type(writefile) ~= "function" then return end
    if #debugBuf >= 24 then
        local ok = pcall(writefile, DEBUG_FILE, table.concat(debugBuf, "\n") .. "\n")
        if ok then table.clear(debugBuf) end
    end
end
local function dflush()
    if type(writefile) ~= "function" or #debugBuf == 0 then return end
    local text = table.concat(debugBuf, "\n") .. "\n"
    if pcall(writefile, DEBUG_FILE, text) then table.clear(debugBuf) end
end

----------------------------------------------------------------
-- anti die: dead state off, health snaps back, jump-kill connection muted.
-- mirrors skyrohub's hook, scoped to this script's characters only.
----------------------------------------------------------------
local antiConns = {}
local antiMuted = setmetatable({}, { __mode = "k" })
local antiHardened = setmetatable({}, { __mode = "k" })

local function hardenHumanoid(hum, on)
    if not hum then return end
    pcall(function()
        hum.BreakJointsOnDeath = not on
        if on then hum.RequiresNeck = false end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, not on)
    end)
    if on then antiHardened[hum] = true else antiHardened[hum] = nil end
end

local function muteJumpKill(char)
    if type(getconnections) ~= "function" or type(debug) ~= "table" then return end
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end
    for _, waitFor in ipairs({ 0.5, 2, 5 }) do
        task.wait(waitFor)
        if not hum.Parent or antiMuted[hum] then return end
        local ok, list = pcall(getconnections, hum.StateChanged)
        if ok and type(list) == "table" then
            for _, cn in ipairs(list) do
                local okF, fn = pcall(function() return cn.Function end)
                if okF and type(fn) == "function"
                    and not (type(iscclosure) == "function" and iscclosure(fn)) then
                    local okS, src = pcall(debug.info, fn, "s")
                    if okS and type(src) == "string" and src:find("CharacterController", 1, true) then
                        if pcall(function() cn:Disable() end) then antiMuted[hum] = cn end
                    end
                end
            end
        end
    end
end

local function hookAntiDie(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end
    if state.antiDie then hardenHumanoid(hum, true) end
    antiConns[#antiConns + 1] = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if dead or not state.antiDie then return end
        if hum.Health <= 0 then
            hum.Health = hum.MaxHealth
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end)
    task.spawn(muteJumpKill, char)
end

if LP.Character then task.spawn(hookAntiDie, LP.Character) end
antiConns[#antiConns + 1] = LP.CharacterAdded:Connect(hookAntiDie)

local function setAntiDie(on)
    state.antiDie = on
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    hardenHumanoid(hum, on)
    note("anti die " .. (on and "on" or "off"))
    dlog("anti die %s", on and "on" or "off")
end

local function teardownAntiDie()
    for _, cn in ipairs(antiConns) do pcall(function() cn:Disconnect() end) end
    antiConns = {}
    for hum, cn in pairs(antiMuted) do
        pcall(function() cn:Enable() end)
        antiMuted[hum] = nil
    end
    for hum in pairs(antiHardened) do
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
        antiHardened[hum] = nil
    end
end

----------------------------------------------------------------
-- plot channel owner lookup, same shape as the hub
----------------------------------------------------------------
local chans, chanGet
do
    local cached, mod
    local function isLite()
        local ok, g = pcall(function() return type(getgenv) == "function" and getgenv() end)
        return ok and type(g) == "table" and g.FastLoad == true
    end
    local function requireModule(inst)
        local req = (type(getrenv) == "function" and getrenv().require) or require
        local ok, m = pcall(req, inst)
        return ok and m or nil
    end

    chans = function()
        if isLite() then
            local ok, g = pcall(function() return getgenv and getgenv() end)
            return ok and type(g) == "table" and g.Lobby or nil
        end
        if cached then return cached end
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local syn = pk and pk:FindFirstChild("Synchronizer")
        if not syn then return nil end
        if type(mod) ~= "table" then
            local m = requireModule(syn)
            if type(m) == "table" then mod = m end
        end
        if type(mod) ~= "table" then return nil end
        local get = rawget(mod, "Get") or mod.Get
        if type(get) == "function" then
            local gf = getfenv or (type(debug) == "table" and debug.getfenv)
            if type(gf) == "function" then
                local ok, env = pcall(gf, get)
                if ok and type(env) == "table" then
                    local ch = rawget(env, "Channels") or env.Channels
                    if type(ch) == "table" then cached = ch end
                end
            end
            if not cached and type(debug) == "table" and type(debug.getupvalues) == "function" then
                local ok, ups = pcall(debug.getupvalues, get)
                if ok and type(ups) == "table" then
                    for _, v in pairs(ups) do
                        if type(v) == "table" then
                            for _, c in pairs(v) do
                                if type(c) == "table" and rawget(c, "CacheTable") ~= nil then
                                    cached = v
                                    break
                                end
                            end
                        end
                        if cached then break end
                    end
                end
            end
        end
        return cached
    end

    chanGet = function(ch, key)
        if type(ch) ~= "table" then return nil end
        local ct = rawget(ch, "CacheTable")
        if type(ct) ~= "table" then
            local ok, c2 = pcall(function() return ch.CacheTable end)
            ct = ok and c2 or nil
        end
        if type(ct) ~= "table" then return rawget(ch, key) end
        local v = rawget(ct, key)
        if v ~= nil then return v end
        local ok, v2 = pcall(function() return ct[key] end)
        return ok and v2 or nil
    end
end

local function ownerOfPlot(plot)
    if not plot then return nil end
    local reg = chans()
    local ch = type(reg) == "table" and rawget(reg, plot.Name) or nil
    local o = ch and chanGet(ch, "Owner")
    if typeof(o) == "Instance" and o:IsA("Player") then return o end
    if type(o) == "table" and o.UserId then return Players:GetPlayerByUserId(o.UserId) end
    if type(o) == "table" and o.Name then return Players:FindFirstChild(tostring(o.Name)) end
    if type(o) == "number" then return Players:GetPlayerByUserId(o) end

    local sign = plot:FindFirstChild("PlotSign")
    local gui = sign and sign:FindFirstChildWhichIsA("SurfaceGui", true)
    local lbl = gui and gui:FindFirstChildWhichIsA("TextLabel", true)
    local nick = lbl and lbl.Text and (lbl.Text:match("^(.-)'") or lbl.Text)
    if not nick or nick == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == nick or p.DisplayName == nick then return p end
    end
    return nil
end

----------------------------------------------------------------
-- game helpers
----------------------------------------------------------------
local function rootOf(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.RootPart then return hum.RootPart end
    return char:FindFirstChild("HumanoidRootPart")
end

local function torsoOf(char)
    if not char then return nil end
    return char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("LowerTorso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function findTool(name)
    if type(name) ~= "string" or name == "" then return nil end
    local char, bp = LP.Character, LP:FindFirstChildOfClass("Backpack")
    local t = (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
    return (typeof(t) == "Instance" and t:IsA("Tool")) and t or nil
end

-- the selector's carpet first; if you don't own it, any carpet from CARPETS
local function flightToolForRoute()
    local selectedName = CARPETS[state.toolIndex]
    local primary = findTool(selectedName)
    if primary then return primary, primary.Name, true end
    for _, name in ipairs(CARPETS) do
        local t = findTool(name)
        if t then return t, t.Name, false end
    end
    return nil, nil, false
end

local function equipTool(tool)
    if not tool then return false end
    if tool.Parent == LP.Character then return true end
    local char, hum = LP.Character, LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return false end
    pcall(function() hum:EquipTool(tool) end)
    for _ = 1, 30 do
        if tool.Parent == char then return true end
        RunService.Heartbeat:Wait()
    end
    -- EquipTool did not take: parent the tool into the character directly
    pcall(function() tool.Parent = char end)
    RunService.Heartbeat:Wait()
    return tool.Parent == char
end

-- equip, then require the tool to stay in the character for `settle` seconds.
-- re-equips if the game or the engine pulls it back out. false on timeout or cancel.
local function holdTool(tool, settle)
    local deadline = os.clock() + 3
    local heldSince = nil
    while not dead and not cancelled and os.clock() < deadline do
        local char = LP.Character
        if char and tool.Parent == char then
            heldSince = heldSince or os.clock()
            if os.clock() - heldSince >= settle then return true end
        else
            heldSince = nil
            equipTool(tool)
        end
        RunService.Heartbeat:Wait()
    end
    return false
end

-- pure: is myPos behind the target? "behind" = +Z in the target torso's object space,
-- matching CFrame.new(0, 0, followOffset) in the follow loop.
local function behindTarget(myPos, targetCF, offset, tol)
    local rel = targetCF:PointToObjectSpace(myPos)
    return rel.Z > 0
        and math.abs(rel.Z - offset) <= tol
        and math.abs(rel.X) <= tol
        and math.abs(rel.Y) <= tol
end

local function stagedBehindWithCarpet(entry, carpet)
    local char = LP.Character
    if not char or carpet.Parent ~= char then return false, "carpet not held" end
    local myRoot = rootOf(char)
    local targetTorso = torsoOf(entry.player.Character)
    if not myRoot or not targetTorso then return false, "character missing" end
    if not behindTarget(myRoot.Position, targetTorso.CFrame, state.followOffset, state.behindTol) then
        return false, "not behind target"
    end
    return true
end

local function waitStaged(entry, carpet)
    local deadline = os.clock() + state.verifyTimeout
    local reason = "timeout"
    while not dead and not cancelled do
        local ok, why = stagedBehindWithCarpet(entry, carpet)
        if ok then return true end
        reason = why
        if why == "carpet not held" then equipTool(carpet) end
        if os.clock() >= deadline then break end
        RunService.Heartbeat:Wait()
    end
    return false, reason
end

local function refreshTargets()
    local out = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then targets = out return out end
    local myRoot = rootOf(LP.Character)
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = ownerOfPlot(plot)
        if owner and owner ~= LP then
            local targetRoot = rootOf(owner.Character)
            if targetRoot then
                out[#out + 1] = {
                    player = owner,
                    plot = plot,
                    dist = myRoot and (myRoot.Position - targetRoot.Position).Magnitude or math.huge,
                }
            end
        end
    end
    table.sort(out, function(a, b) return a.dist < b.dist end)
    targets = out
    return out
end

local function currentTarget()
    if state.auto then return targets[1] end
    for _, entry in ipairs(targets) do
        if entry.player.UserId == state.targetUserId then return entry end
    end
    return targets[1]
end

local function stopFollow()
    if followConn then
        pcall(function() followConn:Disconnect() end)
        followConn = nil
    end
end

local function startFollow(entry)
    stopFollow()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local targetPlayer = entry.player
    followConn = RunService.Stepped:Connect(function()
        if dead or not targetPlayer.Character then return end
        local myRoot, otherRoot = rootOf(LP.Character), torsoOf(targetPlayer.Character)
        if not myRoot or not otherRoot then return end
        if hum.Health <= 0 and not state.antiDie then stopFollow() return end
        pcall(function()
            myRoot.CFrame = otherRoot.CFrame * CFrame.new(0, 0, state.followOffset)
        end)
    end)
    return true
end

local function dumpAttrs(tool, tag)
    local ok, attrs = pcall(function() return tool:GetAttributes() end)
    if not ok or type(attrs) ~= "table" then
        dlog("execute: attrs %s unreadable", tag)
        return
    end
    local n = 0
    for k, v in pairs(attrs) do
        n = n + 1
        dlog("execute: attr %s %s=%s", tag, tostring(k), tostring(v))
    end
    if n == 0 then dlog("execute: attr %s none", tag) end
end

local function finishSequence(message)
    stopFollow()
    state.phase = "idle"
    busy = false
    note("%s", message)
    dflush()
end

local function execute()
    if busy then return end
    busy = true
    cancelled = false
    state.phase = "target"
    refreshTargets()
    local entry = currentTarget()
    if not entry then
        finishSequence("no base owner found")
        dlog("execute: no target")
        return
    end
    state.targetUserId = entry.player.UserId

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = rootOf(char)
    local dest = torsoOf(entry.player.Character)
    if not char or not hum or not root or not dest then
        finishSequence("character missing")
        dlog("execute: missing character/root/dest")
        return
    end

    -- the potion's own script blocks targeting while CooldownTime is set, so don't start the route
    local potionNow = findTool(BODY_TOOL)
    if potionNow and potionNow:GetAttribute(COOLDOWN_ATTR) then
        finishSequence(BODY_TOOL .. " is on cooldown - not started")
        dlog("execute: potion on cooldown %s=%s", COOLDOWN_ATTR, tostring(potionNow:GetAttribute(COOLDOWN_ATTR)))
        return
    end

    -- 1. selected carpet out of the backpack first
    state.phase = "carpet"
    local carpet, carpetName, isSelected = flightToolForRoute()
    if not carpet then
        finishSequence("no carpet in backpack")
        dlog("execute: no carpet owned")
        return
    end
    note("%s", "pulling out " .. carpetName)
    local t0 = os.clock()
    if not holdTool(carpet, state.equipSettle) then
        if cancelled or dead then finishSequence("stopped") return end
        finishSequence(carpetName .. " would not stay out - not moving")
        dlog("execute: carpet hold failed tool=%s parent=%s", carpetName, tostring(carpet.Parent))
        return
    end
    note("%s", carpetName .. (isSelected and " out" or " out (selected one not owned)"))
    dlog("execute: carpet=%s selected=%s heldAfter=%.2fs parent=%s",
        carpetName, tostring(isSelected), os.clock() - t0, tostring(carpet.Parent))
    if cancelled then finishSequence("stopped") return end

    -- 2. move to the target
    state.phase = "move"
    pcall(function()
        root.CFrame = dest.CFrame * CFrame.new(0, 0, state.tpOffset)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)
    RunService.Heartbeat:Wait()
    if cancelled then finishSequence("stopped") return end

    -- 3. hold position behind them
    state.phase = "follow"
    if not startFollow(entry) then
        finishSequence("follow failed")
        dlog("execute: follow failed")
        return
    end
    note("%s", "on " .. entry.player.Name .. " - checking position")

    task.spawn(function()
        local oldChar = LP.Character
        local oldTargetChar = entry.player.Character

        -- 4a. sit behind them for postTpDelay seconds after the teleport
        state.phase = "settle"
        local settleEnd = os.clock() + state.postTpDelay
        while os.clock() < settleEnd and not dead and not cancelled do
            RunService.Heartbeat:Wait()
        end
        if cancelled or dead then finishSequence("stopped") return end
        dlog("execute: waited %.2fs behind %s", state.postTpDelay, entry.player.Name)

        -- 4b. gate: still behind them AND still holding the carpet, before the potion comes out
        state.phase = "verify"
        local staged, why = waitStaged(entry, carpet)
        if cancelled or dead then finishSequence("stopped") return end
        if not staged then
            finishSequence("not ready (" .. tostring(why) .. ") - potion not pulled")
            dlog("execute: verify failed reason=%s", tostring(why))
            return
        end
        dlog("execute: verified behind %s with %s", entry.player.Name, carpetName)

        -- 5. potion out
        state.phase = "potion"
        local potion = findTool(BODY_TOOL)
        if not potion then
            finishSequence("no " .. BODY_TOOL .. " - follow stopped")
            dlog("execute: no potion")
            return
        end
        if not holdTool(potion, state.potionSettle) then
            if cancelled or dead then finishSequence("stopped") return end
            finishSequence(BODY_TOOL .. " would not stay out - not used")
            dlog("execute: potion hold failed parent=%s", tostring(potion.Parent))
            return
        end

        -- 6. swap: spam potion:Activate() until a success signal, Stop, or swapTimeout runs out
        state.phase = "swap"
        -- the cooldown marker means the server accepted the use; the character checks are backups
        local function swapSignal()
            if potion:GetAttribute(COOLDOWN_ATTR) then return "potion cooldown started" end
            if LP.Character and LP.Character ~= oldChar then return "your character replaced" end
            local theirs = entry.player.Character
            if theirs ~= nil and theirs ~= oldTargetChar then return "target character replaced" end
            return nil
        end

        dumpAttrs(potion, "before spam")
        local completed, signal = false, nil
        local attempts, fired = 0, 0
        local lastErr = nil
        local deadline = os.clock() + state.swapTimeout
        while os.clock() < deadline and not dead and not cancelled do
            signal = swapSignal()
            if signal then completed = true break end
            if potion.Parent ~= LP.Character then equipTool(potion) end
            local ok, err = pcall(function() potion:Activate() end)
            attempts = attempts + 1
            if ok then fired = fired + 1 else lastErr = err end
            if attempts == 1 or attempts % 10 == 0 then
                dlog("execute: potion:Activate #%d ok=%s target=%s parent=%s",
                    attempts, tostring(ok), entry.player.Name, tostring(potion.Parent))
            end
            note("activating potion x%d", attempts)
            local nextAt = os.clock() + state.activateInterval
            while os.clock() < nextAt and not dead and not cancelled do
                RunService.Heartbeat:Wait()
            end
        end
        if not completed and not dead and not cancelled then
            signal = swapSignal()
            completed = signal ~= nil
        end
        dflush()

        if completed then
            dlog("execute: swap complete signal=%s after %d activations oldChar=%s newChar=%s",
                tostring(signal), attempts, tostring(oldChar), tostring(LP.Character))
            dumpAttrs(potion, "on success")
            finishSequence(string.format("done (%s) after %d activations - stopped", signal, attempts))
        elseif cancelled or dead then
            finishSequence("stopped")
        elseif fired == 0 then
            dlog("execute: potion:Activate never succeeded err=%s", tostring(lastErr))
            finishSequence("potion activate failed")
        else
            dlog("execute: swap timeout after %d activations", attempts)
            finishSequence(string.format("swap timeout after %d activations - follow stopped", attempts))
        end
    end)
end

----------------------------------------------------------------
-- GUI: translucent panel, hairline rim light, one accent.
-- Roblox cannot blur behind a frame, so the glass is transparency + sheen + rim.
----------------------------------------------------------------
local parent
pcall(function() parent = type(gethui) == "function" and gethui() end)
if not parent then
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    parent = ok and core or LP:WaitForChild("PlayerGui")
end

local function pickFont(...)
    for _, name in ipairs({ ... }) do
        local ok, f = pcall(function() return Enum.Font[name] end)
        if ok and f then return f end
    end
    return Enum.Font.SourceSans
end
local FONT_REG = pickFont("BuilderSansMedium", "BuilderSans", "GothamMedium", "Gotham")
local FONT_BOLD = pickFont("BuilderSansBold", "GothamBold", "Gotham")

local ACCENT = Color3.fromRGB(150, 130, 255)
local INK = Color3.fromRGB(236, 239, 250)
local MUTED = Color3.fromRGB(157, 165, 190)
local IDLE_DOT = Color3.fromRGB(110, 118, 140)
local WHITE = Color3.fromRGB(255, 255, 255)

local gui = Instance.new("ScreenGui")
gui.Name = "SkyroBangSwap"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

local function mk(class, props, host)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if host then o.Parent = host end
    return o
end

local function corner(host, radius)
    mk("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, host)
end

local function stroke(host, color, transparency)
    return mk("UIStroke", {
        Color = color,
        Thickness = 1,
        Transparency = transparency,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, host)
end

local function fade(host, to, time)
    pcall(function()
        TweenService:Create(host, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = to,
        }):Play()
    end)
end

local main = mk("Frame", {
    Name = "Panel",
    Size = UDim2.new(0, 320, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    Position = UDim2.new(0.5, -160, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(22, 24, 34),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
}, gui)
corner(main, 18)
mk("UIPadding", {
    PaddingTop = UDim.new(0, 14),
    PaddingBottom = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 14),
    PaddingRight = UDim.new(0, 14),
}, main)
mk("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
}, main)
mk("UIGradient", {
    Color = ColorSequence.new(WHITE, Color3.fromRGB(165, 172, 210)),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.12),
    }),
    Rotation = 120,
}, main)
local rim = stroke(main, WHITE, 0)
mk("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 0.9),
        NumberSequenceKeypoint.new(1, 0.72),
    }),
    Rotation = 45,
}, rim)

local header = mk("Frame", {
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundTransparency = 1,
    Active = true,
    LayoutOrder = 1,
}, main)
mk("TextLabel", {
    Size = UDim2.new(1, -20, 0, 22),
    BackgroundTransparency = 1,
    Text = "Bang Swap",
    TextColor3 = INK,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = FONT_BOLD,
    TextSize = 18,
}, header)
mk("TextLabel", {
    Size = UDim2.new(1, -20, 0, 14),
    Position = UDim2.new(0, 0, 0, 23),
    BackgroundTransparency = 1,
    Text = "leaked at discord.gg/Z7vPrxecnJ",
    TextColor3 = MUTED,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = FONT_REG,
    TextSize = 11,
}, header)
local dot = mk("Frame", {
    Size = UDim2.new(0, 8, 0, 8),
    Position = UDim2.new(1, -8, 0, 7),
    BackgroundColor3 = IDLE_DOT,
    BorderSizePixel = 0,
}, header)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)

local statusCard = mk("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = 0.94,
    BorderSizePixel = 0,
    LayoutOrder = 2,
}, main)
corner(statusCard, 12)
stroke(statusCard, WHITE, 0.9)
local statusMsg = mk("TextLabel", {
    Size = UDim2.new(1, -24, 0, 20),
    Position = UDim2.new(0, 12, 0, 9),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = INK,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Font = FONT_BOLD,
    TextSize = 14,
}, statusCard)
local statusMeta = mk("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.new(0, 12, 0, 31),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = MUTED,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Font = FONT_REG,
    TextSize = 12,
}, statusCard)

local function button(host, text, callback, opts)
    opts = opts or {}
    local primary = opts.primary == true
    local base = primary and 0.2 or 0.93
    local hover = primary and 0.1 or 0.86
    local press = primary and 0.04 or 0.8
    local b = mk("TextButton", {
        Size = opts.size or UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = primary and ACCENT or WHITE,
        BackgroundTransparency = base,
        AutoButtonColor = false,
        Text = text,
        TextColor3 = primary and WHITE or INK,
        Font = primary and FONT_BOLD or FONT_REG,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        LayoutOrder = opts.order or 1,
    }, host)
    corner(b, 10)
    mk("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, b)
    stroke(b, primary and Color3.fromRGB(205, 195, 255) or WHITE, primary and 0.55 or 0.9)
    b.MouseEnter:Connect(function() fade(b, hover) end)
    b.MouseLeave:Connect(function() fade(b, base) end)
    b.MouseButton1Down:Connect(function() fade(b, press, 0.08) end)
    b.MouseButton1Up:Connect(function() fade(b, hover, 0.08) end)
    b.MouseButton1Click:Connect(function()
        task.spawn(function() pcall(callback) end)
    end)
    return b
end

local function stopSequence()
    cancelled = true
    stopFollow()
    state.phase = "idle"
    note("stopped")
end

local toolBtn
toolBtn = button(main, "Carpet: " .. CARPETS[state.toolIndex], function()
    state.toolIndex = state.toolIndex % #CARPETS + 1
    toolBtn.Text = "Carpet: " .. CARPETS[state.toolIndex]
    note("carpet set: " .. CARPETS[state.toolIndex])
end, { order = 3 })

local targetBtn = button(main, "Target: AUTO", function()
    refreshTargets()
    if state.auto then
        state.auto = false
        local entry = currentTarget()
        state.targetUserId = entry and entry.player.UserId or nil
    else
        local idx = 0
        for i, entry in ipairs(targets) do
            if entry.player.UserId == state.targetUserId then idx = i break end
        end
        local nextEntry = targets[idx % #targets + 1]
        state.targetUserId = nextEntry and nextEntry.player.UserId or nil
        if not nextEntry then state.auto = true end
    end
end, { order = 4 })

local antiBtn
antiBtn = button(main, "Anti Die: ON", function()
    setAntiDie(not state.antiDie)
    antiBtn.Text = "Anti Die: " .. (state.antiDie and "ON" or "OFF")
end, { order = 5 })

local row = mk("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundTransparency = 1,
    LayoutOrder = 6,
}, main)
mk("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
}, row)
button(row, "Execute  [X]", execute, { order = 1, primary = true, size = UDim2.new(0.62, -4, 1, 0) })
button(row, "Stop  [Z]", stopSequence, { order = 2, size = UDim2.new(0.38, -4, 1, 0) })

mk("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    BackgroundTransparency = 1,
    Text = "carpet -> move -> follow -> verify -> potion -> swap",
    TextColor3 = MUTED,
    Font = FONT_REG,
    TextSize = 11,
    LayoutOrder = 7,
}, main)

local dragging, dragStart, guiStart = false, nil, nil
local function isPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end
uiConns[#uiConns + 1] = header.InputBegan:Connect(function(input)
    if isPointer(input) then
        dragging = true
        dragStart = input.Position
        guiStart = main.Position
    end
end)
uiConns[#uiConns + 1] = UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    main.Position = UDim2.new(guiStart.X.Scale, guiStart.X.Offset + delta.X,
        guiStart.Y.Scale, guiStart.Y.Offset + delta.Y)
end)
uiConns[#uiConns + 1] = UserInputService.InputEnded:Connect(function(input)
    if isPointer(input) then dragging = false end
end)

uiConns[#uiConns + 1] = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.X then execute() end
    if input.KeyCode == Enum.KeyCode.Z then stopSequence() end
end)

refreshConn = task.spawn(function()
    while not dead do
        refreshTargets()
        local entry = currentTarget()
        if state.auto then
            targetBtn.Text = "Target: AUTO" .. (entry and (" [" .. entry.player.Name .. "]") or "")
            state.targetUserId = entry and entry.player.UserId or nil
        else
            targetBtn.Text = "Target: " .. (entry and entry.player.Name or "none")
        end
        antiBtn.Text = "Anti Die: " .. (state.antiDie and "ON" or "OFF")
        statusMsg.Text = state.msg
        statusMeta.Text = string.format("%s  |  %s  |  anti die %s",
            string.upper(state.phase),
            entry and entry.player.Name or "no owner",
            state.antiDie and "ON" or "OFF")
        dot.BackgroundColor3 = busy and ACCENT or IDLE_DOT
        task.wait(0.45)
    end
end)

do
    -- start the selector on the first carpet you actually own
    for i, name in ipairs(CARPETS) do
        if findTool(name) then state.toolIndex = i break end
    end
    toolBtn.Text = "Carpet: " .. CARPETS[state.toolIndex]
end

_G[STOP_KEY] = function()
    dead = true
    cancelled = true
    stopFollow()
    teardownAntiDie()
    for _, cn in ipairs(uiConns) do pcall(function() cn:Disconnect() end) end
    uiConns = {}
    if refreshConn then pcall(task.cancel, refreshConn) end
    pcall(function() gui:Destroy() end)
    _G[STOP_KEY] = nil
end

dlog("loaded carpet=%s antiDie=%s targetMode=%s",
    CARPETS[state.toolIndex], tostring(state.antiDie), state.auto and "auto" or "manual")
dflush()
note("ready: press X or Execute")