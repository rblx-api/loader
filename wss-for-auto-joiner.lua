-- wss url catcher

local caught = {}

local function onCatch(source, url)
    if caught[url] then return end
    caught[url] = true
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("[WSS CATCHER] Source : " .. source)
    print("[WSS CATCHER] URL    : " .. tostring(url))
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    pcall(setclipboard, tostring(url))
end

-- Generic hook helper: tries hookfunction first, falls back to raw assignment,
-- and swallows "readonly table" errors so one failure doesn't stop the rest.
local function hook(tbl, name, source)
    if type(tbl) ~= "table" then return end
    local orig = tbl[name]
    if type(orig) ~= "function" then return end

    local replacement = function(url, ...)
        onCatch(source, url)
        return orig(url, ...)
    end

    -- Preferred: hookfunction works even on readonly tables.
    if hookfunction then
        local ok = pcall(function()
            orig = hookfunction(orig, replacement)
        end)
        if ok then
            print("[WSS CATCHER] hooked " .. source .. " (hookfunction)")
            return
        end
    end

    -- Fallback: plain assignment (guarded against readonly tables).
    local ok, err = pcall(function()
        tbl[name] = replacement
    end)
    if ok then
        print("[WSS CATCHER] hooked " .. source .. " (assign)")
    else
        print("[WSS CATCHER] could not hook " .. source .. " -> " .. tostring(err))
    end
end

-- syn
if syn and syn.websocket then
    hook(syn.websocket, "connect", "syn.websocket.connect")
end

-- WebSocket global (this was line 28 — the readonly one)
if WebSocket then
    hook(WebSocket, "connect", "WebSocket.connect")
end

-- krnl
if krnl and krnl.websocket then
    hook(krnl.websocket, "connect", "krnl.websocket.connect")
end

-- fluxus
if fluxus and fluxus.websocket then
    hook(fluxus.websocket, "connect", "fluxus.websocket.connect")
end