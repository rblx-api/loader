-- Modern Mobile-Optimized Script
if _G.KayaLoaderRunning then return end
_G.KayaLoaderRunning = true

-- Desactivar el efecto "Fry" para evitar botones anaranjados y UI oculta
_G.KayaFryUI = false

local Players         = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local RunService      = game:GetService("RunService")
local Workspace       = game:GetService("Workspace")
local Lighting        = game:GetService("Lighting")
local TweenService    = game:GetService("TweenService")
local GuiService      = game:GetService("GuiService")

pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

local T0 = os.clock()
local function log(msg)
    if _G.KayaLoaderQuiet then return end
    pcall(print, ("[KAYA MOBILE] %.2fs | %s"):format(os.clock() - T0, msg))
end

local PLAY_FPS = tonumber(_G.KayaPlayFps) or 60
if setfpscap then pcall(setfpscap, PLAY_FPS) end

local LP = Players.LocalPlayer
while not LP do
    task.wait()
    LP = Players.LocalPlayer
end

local MAX_LOAD  = tonumber(_G.KayaMaxLoad) or 20
local restore   = {}
local restored  = false
local READY_AT  = nil

local function restoreAll(reason)
    if restored then return end
    restored = true
    for i = #restore, 1, -1 do pcall(restore[i]) end
    table.clear(restore)
    if setfpscap then pcall(setfpscap, PLAY_FPS) end
    log("restored (" .. tostring(reason) .. ")")
end

task.delay(MAX_LOAD, function() restoreAll("timeout") end)

local UIC = {
    bg   = Color3.fromRGB(255, 240, 245),
    bg2  = Color3.fromRGB(255, 220, 235),
    seg  = Color3.fromRGB(255, 200, 220),
    line = Color3.fromRGB(255, 150, 190),
    acc  = Color3.fromRGB(220, 80, 140),
    acc2 = Color3.fromRGB(255, 100, 150),
    txt  = Color3.fromRGB(50, 50, 50),
    dim  = Color3.fromRGB(200, 120, 160),
}

local function mk(class, parent, props)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end

local function pickHost()
    local hosts = {}
    pcall(function() if gethui then hosts[#hosts + 1] = gethui() end end)
    pcall(function() hosts[#hosts + 1] = game:GetService("CoreGui") end)
    hosts[#hosts + 1] = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
    for _, h in ipairs(hosts) do
        if h then
            local ok = pcall(function()
                local probe = Instance.new("Folder")
                probe.Parent = h
                probe:Destroy()
            end)
            if ok then return h end
        end
    end
    return nil
end

local gui, card, status, fill, head
local inset = GuiService:GetGuiInset()

local uiOk = pcall(function()
    local host = pickHost()
    if not host then error("no gui host") end

    local old = host:FindFirstChild("KayaLoaderUI")
    if old then old:Destroy() end

    gui = mk("ScreenGui", host, {
        Name = "KayaLoaderUI", ResetOnSpawn = false,
        IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 9999,
    })

    card = mk("Frame", gui, {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, inset.Y + 10),
        Size = UDim2.new(0.85, 0, 0, 54),
        BackgroundColor3 = UIC.bg,
        BorderSizePixel = 0,
    })
    mk("UICorner", card, { CornerRadius = UDim.new(0, 12) })
    
    local title = mk("TextLabel", card, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 8),
        Size = UDim2.new(0.6, 0, 0, 20),
        Font = Enum.Font.GothamBlack, TextSize = 14,
        TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
        Text = "KAYA MOBILE",
    })

    status = mk("TextLabel", card, {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -14, 0, 8),
        Size = UDim2.new(0.3, 0, 0, 20),
        Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Right,
        Text = "0%",
    })

    local track = mk("Frame", card, {
        Position = UDim2.new(0, 14, 1, -14),
        Size = UDim2.new(1, -28, 0, 6),
        BackgroundColor3 = UIC.seg,
        BorderSizePixel = 0,
    })
    mk("UICorner", track, { CornerRadius = UDim.new(1, 0) })

    fill = mk("Frame", track, {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = UIC.acc,
        BorderSizePixel = 0,
    })
    mk("UICorner", fill, { CornerRadius = UDim.new(1, 0) })

    head = mk("Frame", track, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = UIC.acc2,
        BorderSizePixel = 0,
    })
    mk("UICorner", head, { CornerRadius = UDim.new(1, 0) })
end)

_G.KayaLoaderUIShown = uiOk

pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = tonumber(_G.KayaLoadFog) or 260
end)

local SMOOTH = Enum.Material.SmoothPlastic

local function touch3D(o)
    local c = o.ClassName
    if c == "MeshPart" then
        o.TextureID = ""
        o.Material = SMOOTH
    elseif c == "SpecialMesh" then
        o.TextureId = ""
    elseif c == "Decal" or c == "Texture" then
        o.Texture = ""
    elseif o:IsA("BasePart") then
        o.Material = SMOOTH
    end
end

task.spawn(function()
    for _, desc in ipairs(Workspace:GetDescendants()) do
        pcall(touch3D, desc)
    end
    Workspace.DescendantAdded:Connect(function(o) pcall(touch3D, o) end)
end)

-- Bucle principal sin modificar la UI del juego
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    local ch = LP.Character or LP.CharacterAdded:Wait()
    ch:WaitForChild("HumanoidRootPart", 20)
    
    READY_AT = os.clock() - T0
    log(("ready in %.2fs"):format(READY_AT))
    restoreAll("ready")
    
    if uiOk then
        local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
        TweenService:Create(fill, ti, { Size = UDim2.fromScale(1, 1) }):Play()
        TweenService:Create(head, ti, { Position = UDim2.new(1, 0, 0.5, 0) }):Play()
        status.Text = ("%.2fs"):format(READY_AT)
        status.TextColor3 = UIC.acc2
        
        task.wait(1.5)
        TweenService:Create(card, ti, { Position = UDim2.new(0.5, 0, 0, -80) }):Play()
        task.wait(0.35)
        pcall(function() gui:Destroy() end)
    end
    _G.KayaLoaderRunning = nil
end)