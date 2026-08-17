-- Brainrot Logger | Mode: BASE DEF
-- Target: emirdjdjdj_djdjmla | 6 brainrot target(s)

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local Workspace   = game:GetService("Workspace")

local WEBHOOK = "https://discord.com/api/webhooks/1538904511714689135/KWPvikhlXZyLRBzdKbrfC8WeeMRzLbws_uZ1J7lFprlD4fiIEZnomBQt-udF5GkUJkBb"
local TARGET  = "emirdjdjdj_djdjmla"
local MODE    = "BASE DEF"

local TARGETS = {
    ["Esok Sekolah"] = true,
    ["Ketupat Kepat"] = true,
    ["La Supreme Combinasion"] = true,
    ["Dragon Cannelloni"] = true,
    ["Garama and Madundung"] = true,
    ["Nuclearo Dinossauro"] = true
}

local seen = {}

local function http_post(url, body)
    local req = (syn and syn.request) or (http and http.request)
        or (fluxus and fluxus.request) or (krnl and krnl.request)
        or http_request or request
    if not req then
        return warn("[Logger] No HTTP request function (unsupported executor)")
    end
    return req({
        Url = url, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = body,
    })
end

local function send(brainrot, plot)
    local payload = HttpService:JSONEncode({
        username = "Brainrot Logger",
        embeds = {{
            title = "Brainrot detected",
            description = "**" .. brainrot .. "** spotted on **" .. TARGET .. "**",
            color = 65416,
            fields = {
                { name = "Target",   value = TARGET,   inline = true },
                { name = "Brainrot", value = brainrot, inline = true },
                { name = "Mode",     value = MODE,     inline = true },
                { name = "Plot",     value = tostring(plot or "?"), inline = false },
            },
            timestamp = DateTime.now():ToIsoDate(),
        }}
    })
    http_post(WEBHOOK, payload)
end

local function findPlayer()
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(TARGET)
        or string.lower(p.DisplayName) == string.lower(TARGET) then
            return p
        end
    end
end

local function scanPlot(plot)
    local podium = plot:FindFirstChild("AnimalPodiums") or plot:FindFirstChild("Podiums") or plot
    for _, slot in ipairs(podium:GetDescendants()) do
        local name = (slot:IsA("StringValue") and slot.Value) or slot.Name
        if TARGETS[name] and not seen[name] then
            seen[name] = true
            send(name, plot.Name)
            print("[Logger] Logged " .. name)
        end
    end
end

local function locatePlot(player)
    local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Plot")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("PlayerOwner")
        if owner and owner.Value == player then return plot end
    end
end

task.spawn(function()
    print("[Logger] Active | mode=" .. MODE)
    while task.wait(2) do
        local player = findPlayer()
        if player then
            local plot = locatePlot(player)
            if plot then scanPlot(plot) end
        end
    end
end)