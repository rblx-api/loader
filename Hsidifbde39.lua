-- Starborn font made by certz pussy
if not isfile("starborn.ttf") then
    local ok, data = pcall(game.HttpGet, game, "https://files.catbox.moe/pwgdui.ttf")
    if not ok or not data or #data < 1000 then return end
    writefile("starborn.ttf", data)
end

if not isfile("starborn.json") then
    writefile("starborn.json", game:GetService("HttpService"):JSONEncode({
        name = "Starborn",
        faces = {{
            name    = "Regular",
            weight  = 400,
            style   = "normal",
            assetId = getcustomasset("starborn.ttf"),
        }}
    }))
end

local starbornFont = Font.new(getcustomasset("starborn.json"))
local builderIconsFont = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json")
local builderIconsStr = tostring(builderIconsFont)

local function shouldReplace(v)
    if not (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) then
        return false
    end
    if v.TextStrokeTransparency ~= 1 then
        return false
    end
    local fstr = tostring(v.FontFace)
    if fstr == builderIconsStr or fstr:find("BuilderIcons", 1, true) then
        return false
    end
    return true
end

local pending = {}
local scheduled = false

local function flush()
    scheduled = false
    for _, v in ipairs(pending) do
        if v.Parent and shouldReplace(v) then
            v.FontFace = starbornFont
        end
    end
    table.clear(pending)
end

local function queue(v)
    pending[#pending + 1] = v
    if not scheduled then
        scheduled = true
        task.defer(flush)
    end
end

for _, v in ipairs(game:GetDescendants()) do
    if shouldReplace(v) then
        v.FontFace = starbornFont
    end
end

game.DescendantAdded:Connect(function(obj)
    if shouldReplace(obj) then
        queue(obj)
    end
end)