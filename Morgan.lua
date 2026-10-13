-- ============================================================================
--   M0RGAN HUB | FULL OPTIMIZED & REPAIRED (KEY SYSTEM + ANTI KILL MORTY)
-- ============================================================================
-- ts file was generated at discord.gg/25ms

do
-- ==========================================
-- M0RGAN | Key System - KeyDash
-- ==========================================
local M0RGAN_KEY_URL = "https://keydash-robux-magic.lovable.app/api/public/validate-key"
local M0RGAN_KEY_FILE = "morgan_hub_key.txt"
local M0RGAN_HttpService = game:GetService("HttpService")
local M0RGAN_Players = game:GetService("Players")
local M0RGAN_LocalPlayer = M0RGAN_Players.LocalPlayer or M0RGAN_Players.PlayerAdded:Wait()
local M0RGAN_CoreGui = game:GetService("CoreGui")

local M0RGAN_HWID = "unknown"
pcall(function()
    M0RGAN_HWID = game:GetService("RbxAnalyticsService"):GetClientId()
end)

local function M0RGAN_ValidateKey(key)
    if not key or key == "" then
        return false, "Escribe tu key"
    end
    local ok, response = pcall(function()
        return game:HttpGet(M0RGAN_KEY_URL .. "?key=" .. M0RGAN_HttpService:UrlEncode(key) .. "&hwid=" .. M0RGAN_HttpService:UrlEncode(M0RGAN_HWID))
    end)
    if not ok then
        return false, "Error de conexion"
    end
    local decoded
    ok, decoded = pcall(function()
        return M0RGAN_HttpService:JSONDecode(response)
    end)
    if not ok or type(decoded) ~= "table" then
        return false, "Respuesta invalida del servidor"
    end
    return decoded.success == true, decoded.message or (decoded.success and "Key valida" or "Key invalida")
end

local function M0RGAN_ReadSavedKey()
    local saved
    pcall(function()
        if isfile and readfile and isfile(M0RGAN_KEY_FILE) then
            saved = readfile(M0RGAN_KEY_FILE)
        end
    end)
    if saved then saved = saved:gsub("%s+", "") end
    return saved
end

local M0RGAN_SavedKey = M0RGAN_ReadSavedKey()
local M0RGAN_KeyOK = false
if M0RGAN_SavedKey and M0RGAN_SavedKey ~= "" then
    M0RGAN_KeyOK = select(1, M0RGAN_ValidateKey(M0RGAN_SavedKey))
end

if not M0RGAN_KeyOK then
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "M0rgan_KeySystem"
    KeyGui.ResetOnSpawn = false
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() KeyGui.Parent = (gethui and gethui()) or M0RGAN_LocalPlayer:WaitForChild("PlayerGui") end)
    if not KeyGui.Parent then pcall(function() KeyGui.Parent = M0RGAN_CoreGui end) end
    if not KeyGui.Parent then KeyGui.Parent = M0RGAN_LocalPlayer:WaitForChild("PlayerGui") end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(390, 230)
    Frame.Position = UDim2.new(0.5, -195, 0.5, -115)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = KeyGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(55, 55, 65)
    Stroke.Thickness = 1.5

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -30, 0, 35)
    Title.Position = UDim2.fromOffset(15, 12)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "M0rgan"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Sub = Instance.new("TextLabel")
    Sub.BackgroundTransparency = 1
    Sub.Size = UDim2.new(1, -30, 0, 25)
    Sub.Position = UDim2.fromOffset(15, 47)
    Sub.Font = Enum.Font.Gotham
    Sub.Text = "Ingresa tu Key para continuar"
    Sub.TextColor3 = Color3.fromRGB(165,165,175)
    Sub.TextSize = 13
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -30, 0, 42)
    Box.Position = UDim2.fromOffset(15, 82)
    Box.BackgroundColor3 = Color3.fromRGB(20,20,26)
    Box.BorderSizePixel = 0
    Box.ClearTextOnFocus = false
    Box.PlaceholderText = "Pega tu key aquí..."
    Box.Text = M0RGAN_SavedKey or ""
    Box.TextColor3 = Color3.fromRGB(235,235,240)
    Box.PlaceholderColor3 = Color3.fromRGB(100,100,110)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 14
    Box.Parent = Frame
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0,8)

    local Status = Instance.new("TextLabel")
    Status.BackgroundTransparency = 1
    Status.Size = UDim2.new(1, -30, 0, 22)
    Status.Position = UDim2.fromOffset(15, 127)
    Status.Font = Enum.Font.Gotham
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(190,190,200)
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -30, 0, 40)
    Button.Position = UDim2.fromOffset(15, 165)
    Button.BackgroundColor3 = Color3.fromRGB(35,35,43)
    Button.BorderSizePixel = 0
    Button.Text = "VALIDAR KEY"
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,8)

    local validated = false
    Button.MouseButton1Click:Connect(function()
        if validated then return end
        Button.Text = "VALIDANDO..."
        local key = Box.Text:gsub("%s+", "")
        local ok, msg = M0RGAN_ValidateKey(key)
        if ok then
            pcall(function()
                if writefile then writefile(M0RGAN_KEY_FILE, key) end
            end)
            validated = true
            Status.Text = msg ~= "" and msg or "Key valida"
            Status.TextColor3 = Color3.fromRGB(80,220,120)
            Button.Text = "ACCESO CONCEDIDO"
            task.wait(0.45)
            KeyGui:Destroy()
        else
            Status.Text = msg ~= "" and msg or "Key invalida"
            Status.TextColor3 = Color3.fromRGB(255,90,90)
            Button.Text = "VALIDAR KEY"
        end
    end)

    repeat task.wait() until validated
end
-- ==========================================
-- FIN KEY SYSTEM | M0RGAN
-- ==========================================
end


local CarGuardEnabled = false
if not game:IsLoaded() then
    repeat
        task.wait()
    until game:IsLoaded()
end
-- Safe place check (allows running on test/sub-places without aborting)
if not (game.PlaceId == 104715542330896 or game.PlaceId == 97556409405464) then
    warn("[M0rgan] Running outside default PlaceId (" .. tostring(game.PlaceId) .. "). Initializing normally...")
end

game:GetService('ReplicatedStorage')

local v_u_1 = {}
local v2 = game.ReplicatedStorage:WaitForChild('Remotes')
local v_u_3 = {
    send = v2:WaitForChild('Send'),
    get = v2:WaitForChild('Get'),
}
local v_u_4 = {
    event = 0,
    func = 0,
}
local v_u_5 = {}
local v_u_6 = false
local v_u_7 = {}

function v_u_1.on_connect(p8)
    if v_u_6 then
        p8()
    else
        v_u_7[#v_u_7 + 1] = p8
    end
end
function v_u_1.hook(p_u_9, p_u_10)
    if not p_u_10 then
        error('Function nil for hook ' .. p_u_9)
    end
    if v_u_6 then
        if v_u_5[p_u_9] then
            warn("Overwriting hook '" .. p_u_9 .. "'.")
        else
            v_u_5[p_u_9] = p_u_10
        end
    else
        v_u_1.on_connect(function()
            v_u_1.hook(p_u_9, p_u_10)
        end)

        return
    end
end
function v_u_1.is_connected(p11)
    return p11:GetAttribute('IsConnected') and true or false
end

local function v_u_19(p12, p13, p14, p15, ...)
    return p12(p13, p14, p15, ...)
end

task.wait(0.1)

local v_u_20 = v_u_3.send
local v_u_21 = v_u_3.send.FireServer

function v_u_1.send(p22, ...)
    if CarGuardEnabled and p22 == 'crashed_car' then
        return nil
    end

    v_u_4.event = v_u_4.event + 1

    v_u_21(v_u_20, v_u_4.event, p22, ...)
end

local v_u_23 = v_u_3.get
local v_u_24 = v_u_3.get.InvokeServer

function v_u_1.get(p25, ...)
    v_u_4.func = v_u_4.func + 1

    return v_u_24(v_u_23, v_u_4.func, p25, ...)
end

task.wait(0.1)

local function v_u_29()
    v_u_3.send.OnClientEvent:connect(function(p26, ...)
        if v_u_5[p26] then
            v_u_5[p26](...)
        else
            error("Invalid hook '" .. p26 .. "' fired!", 0)
        end
    end)

    function v_u_3.get.OnClientInvoke(p27, ...)
        if v_u_5[p27] then
            return v_u_5[p27](...)
        end

        error("Invalid hook '" .. p27 .. "' invoked!", 0)
    end

    if not pcall(function()
        for v28 = 1, #v_u_7 do
            v_u_7[v28]()
        end
    end) then
        pcall(function()
            print('On connect failed for client')
            v_u_1.send('issue', 'On connect failed for client')
        end)
    end
end

function v_u_1.initiate() end
function v_u_1.loaded()
    function v_u_3.get.OnClientInvoke(p30)
        if p30 == 'connect' then
            v_u_6 = true

            v_u_29()

            return true
        end
    end

    v_u_1.hook('ping', function()
        return true
    end)
end

print('bypassed')

local TweenService = game:GetService('TweenService')
local Players = game:GetService('Players')
local player = Players.LocalPlayer

task.spawn(function()
    local splashGui = player.PlayerGui:WaitForChild('SplashScreenGui', 5)

    if splashGui then
        local frame = splashGui:FindFirstChild('Frame')

        if frame then
            frame.Visible = false
        end

        local redBackdrop = splashGui:FindFirstChild('RedBackdrop')

        if redBackdrop and redBackdrop:FindFirstChild('UIGradient') then
            local gradient = redBackdrop.UIGradient

            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0.421, 0.411, 0.498)),
            })
        end
    end
end)

local modeSelected = false

local function RunNormalMode()
    if getgenv then
        getgenv().identifyexecutor = nil
    end
    if getfenv then
        getfenv().identifyexecutor = nil
    end

    local ReplicatedStorage = game:GetService('ReplicatedStorage')
    local Net = require(ReplicatedStorage.Modules.Core.Net)
    local UI = require(ReplicatedStorage.Modules.Core.UI)

    task.spawn(function()
        local TransitionUI = nil

        while not TransitionUI do
            for _, v in pairs(getgc(true))do
                if type(v) == 'table' and rawget(v, 'conditional_transition') then
                    TransitionUI = v

                    break
                end
            end

            task.wait(0.1)
        end

        TransitionUI.transition = function()
            return
        end
        TransitionUI.conditional_transition = function()
            return
        end

        if TransitionUI.enabled then
            TransitionUI.enabled.set(false)
        end
        if TransitionUI.conditional_enabled then
            TransitionUI.conditional_enabled.set(false)
        end
    end)
    task.spawn(function()
        workspace:SetAttribute('SkipCreator', true)

        local CC = nil

        while not CC do
            for _, v in pairs(getgc(true))do
                if type(v) == 'table' and rawget(v, 'is_in_creator') and rawget(v, 'finish') then
                    CC = v

                    break
                end
            end

            task.wait(0.1)
        end

        CC.is_in_creator.hook(function(isIn)
            if isIn then
                CC.finish(false)
            end
        end)

        if CC.leaving_creator then
            CC.leaving_creator.set(true)
        end
    end)
    task.spawn(function()
        local PlayButton = UI.get('PlayButton')

        if PlayButton then
            for _, connection in pairs(getconnections(PlayButton.MouseButton1Click))do
                connection:Fire()
            end
        end
    end)

    modeSelected = true
end
if player:GetAttribute('InSplashScreen') == true then
    if player.PlayerGui:FindFirstChild('FreemiumHub') then
        player.PlayerGui.PremiumHub:Destroy()
    end

    local ScreenGui = Instance.new('ScreenGui')

    ScreenGui.Name = 'PremiumHub'
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new('Frame')

    MainFrame.Name = 'MainFrame'
    MainFrame.Size = UDim2.new(0, 450, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 35)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local BackgroundImg = Instance.new('ImageLabel')

    BackgroundImg.Name = 'BackgroundImage'
    BackgroundImg.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImg.BackgroundTransparency = 1
    BackgroundImg.Image = ''
    BackgroundImg.ImageTransparency = 0.7
    BackgroundImg.ScaleType = Enum.ScaleType.Crop
    BackgroundImg.ZIndex = 0
    BackgroundImg.Parent = MainFrame

    local BGCorners = Instance.new('UICorner')

    BGCorners.CornerRadius = UDim.new(0, 20)
    BGCorners.Parent = BackgroundImg

    local UICorner = Instance.new('UICorner')

    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new('UIStroke')

    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0, 170, 255)
    UIStroke.Transparency = 0.4
    UIStroke.Parent = MainFrame

    local Logo = Instance.new('ImageLabel')

    Logo.Name = 'Logo'
    Logo.Size = UDim2.new(0, 60, 0, 60)
    Logo.Position = UDim2.new(0.5, -30, 0, 20)
    Logo.BackgroundTransparency = 1
    Logo.Image = ''
    Logo.Visible = false
    Logo.ZIndex = 2
    Logo.Parent = MainFrame

    local Title = Instance.new('TextLabel')

    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 85)
    Title.BackgroundTransparency = 1
    Title.Text = 'M0rgan'
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 2
    Title.Parent = MainFrame

    local Subtitle = Instance.new('TextLabel')

    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0, 120)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = 'Select mode to play'
    Subtitle.TextColor3 = Color3.fromRGB(150, 210, 255)
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.ZIndex = 2
    Subtitle.Parent = MainFrame

    local function createModeButton(name, text, pos, isSpecial)
        local btn = Instance.new('TextButton')

        btn.Name = name
        btn.Size = UDim2.new(0, 380, 0, 45)
        btn.Position = pos
        btn.BackgroundColor3 = isSpecial and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = isSpecial and 0.2 or 0.9
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 16
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        btn.Parent = MainFrame

        local bCorner = Instance.new('UICorner')

        bCorner.CornerRadius = UDim.new(0, 10)
        bCorner.Parent = btn

        local bStroke = Instance.new('UIStroke')

        bStroke.Thickness = 1.5
        bStroke.Color = Color3.fromRGB(0, 170, 255)
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        bStroke.Transparency = 0.5
        bStroke.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = isSpecial and 0 or 0.7,
                Size = UDim2.new(0, 390, 0, 48),
                Position = pos + UDim2.new(0, -5, 0, -1.5),
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = isSpecial and 0.2 or 0.9,
                Size = UDim2.new(0, 380, 0, 45),
                Position = pos,
            }):Play()
        end)

        return btn
    end

    local NormalBtn = createModeButton('NormalMode', 'Normal Mode', UDim2.new(0.5, -190, 0, 155), false)
    NormalBtn.MouseButton1Click:Connect(function()
        RunNormalMode()
        if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
    end)

    -- Auto-fallback after 2.5s so it never freezes if player misses the button
    task.delay(2.5, function()
        if not modeSelected then
            RunNormalMode()
            if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
        end
    end)

    repeat
        task.wait(0.1)
    until modeSelected
else
    modeSelected = true
end

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local UserInputService = game:GetService('UserInputService')
local Debris = game:GetService('Debris')
local CurrentCamera = workspace.CurrentCamera
local Client = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Character = Client.Character or Client.CharacterAdded:Wait()
local PlayerGui = Client:WaitForChild('PlayerGui', 5) or Client:FindFirstChild('PlayerGui')
local Humanoid = Character and (Character:WaitForChild('Humanoid', 5) or Character:FindFirstChildOfClass('Humanoid'))
local RootPart = Character and (Character:WaitForChild('HumanoidRootPart', 5) or Character:FindFirstChild('HumanoidRootPart'))
local Backpack = Client:WaitForChild('Backpack', 5) or Client:FindFirstChild('Backpack')

local Net, RagdollModule, Vechine, CharModule, SprintModule, CrateController
pcall(function() Net = require(ReplicatedStorage.Modules.Core.Net) end)
pcall(function() RagdollModule = require(ReplicatedStorage.Modules.Game.Ragdoll) end)
pcall(function() Vechine = require(ReplicatedStorage.Modules.Game.VehicleSystem.Vehicle) end)
pcall(function() CharModule = require(ReplicatedStorage.Modules.Core.Char) end)
pcall(function() SprintModule = require(ReplicatedStorage.Modules.Game.Sprint) end)
pcall(function() CrateController = require(ReplicatedStorage.Modules.Game.CrateSystem.Crate) end)
local Settings = {}

function c()
    return Settings
end

local function GetDistanceFromRootPart(target)
    if not target then
        return math.huge
    end
    if not RootPart or not RootPart.Parent then
        RootPart = Client.Character and Client.Character:FindFirstChild('HumanoidRootPart')
    end
    if not RootPart then
        return math.huge
    end

    return (RootPart.Position - target.Position).Magnitude
end

Client.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild('Humanoid')
    RootPart = Character:WaitForChild('HumanoidRootPart')
    Backpack = Client:WaitForChild('Backpack')
end)

local Sf = {}
local SprintBar = nil
pcall(function()
    local sp = SprintModule or require(ReplicatedStorage.Modules.Game.Sprint)
    local cs = sp and sp.consume_stamina
    if cs and debug and type(debug.getupvalue) == "function" then
        local up = debug.getupvalue(cs, 2)
        if type(up) == "table" then
            SprintBar = up.sprint_bar
        end
    end
end)
local holdingJump = false
local WindUI

do
    local windUrls = {
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua",
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
        "https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"
    }

    local getFn = (syn and syn.request) or (http and http.request) or http_request or request
    local function fetchText(url)
        if getFn then
            local ok, resp = pcall(function() return getFn({ Url = url, Method = "GET" }) end)
            if ok and resp and (resp.StatusCode == 200 or resp.Status == 200) and resp.Body and #resp.Body > 1000 then
                return resp.Body
            end
        end
        if game.HttpGet then
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if ok and body and #body > 1000 then return body end
        end
        return nil
    end

    for _, url in ipairs(windUrls) do
        local body = fetchText(url)
        if body then
            local fn = loadstring(body)
            if fn then
                local execOk, lib = pcall(fn)
                if execOk and lib and type(lib.CreateWindow) == "function" then
                    WindUI = lib
                    break
                end
            end
        end
    end

    if not WindUI then
        pcall(function()
            WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua'))()
        end)
    end
end

local Icons = nil
pcall(function()
    local fn = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua'))
    if fn then Icons = fn() end
end)
if Icons and type(Icons.SetIconsType) == "function" then
    pcall(function() Icons.SetIconsType('lucide') end)
end

local Window = WindUI:CreateWindow({
    Title = "M0rgan",
    Author = 'by #TBSkyen | discord.gg/NNY22NZ9rx',
    Folder = "M0rgan's",
    Size = UDim2.fromOffset(700, 650),
    MinSize = Vector2.new(620, 540),
    MaxSize = Vector2.new(1100, 850),
    Transparent = true,
    Theme = 'Dark',
    Resizable = true,
    SideBarWidth = 235,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    OpenButton = {
        Enabled = false,
    },
})

-- M0rgan custom floating button + keybinds (M abre / Z cierra)
do
    local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local KeybindConfig = {
        OpenMenu = Enum.KeyCode.M,
        CloseMenu = Enum.KeyCode.Z,
    }

    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "WindUIToggleGUI"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        ToggleGui.Parent = CoreGui
    end)
    if not ToggleGui.Parent then
        ToggleGui.Parent = PlayerGui
    end

    local OpenButton = Instance.new("ImageButton")
    OpenButton.Name = "FloatingOpenButton"
    OpenButton.Size = UDim2.fromOffset(52, 52)
    OpenButton.Position = UDim2.new(0.04, 0, 0.45, -26)
    OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenButton.BackgroundTransparency = 0
    OpenButton.BorderSizePixel = 0
    OpenButton.Image = "rbxassetid://15908930959"
    OpenButton.ScaleType = Enum.ScaleType.Crop
    OpenButton.AutoButtonColor = false
    OpenButton.Active = true
    OpenButton.Parent = ToggleGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = OpenButton

    local menuVisible = true
    local lastInteract = 0
    local normalSize = UDim2.fromOffset(52, 52)
    local pressedSize = UDim2.fromOffset(47, 47)

    local function SetMenuVisible(visible)
        if menuVisible == visible then return end
        menuVisible = visible
        local handled = false
        pcall(function()
            if Window and type(Window.SetVisible) == "function" then
                Window:SetVisible(visible)
                handled = true
            end
        end)
        if not handled then
            pcall(function()
                if Window and type(Window.Toggle) == "function" then
                    Window:Toggle()
                end
            end)
        end
    end

    local function ToggleWindUI()
        if tick() - lastInteract < 0.2 then return end
        lastInteract = tick()
        SetMenuVisible(not menuVisible)
    end

    OpenButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            pcall(function()
                TweenService:Create(OpenButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = pressedSize,
                }):Play()
            end)
        end
    end)
    OpenButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            pcall(function()
                TweenService:Create(OpenButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = normalSize,
                }):Play()
            end)
        end
    end)

    -- Activated funciona tanto con clic como con toque; evita alternar dos veces.
    OpenButton.Activated:Connect(ToggleWindUI)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == KeybindConfig.OpenMenu then
            SetMenuVisible(true)
        elseif input.KeyCode == KeybindConfig.CloseMenu then
            SetMenuVisible(false)
        end
    end)
end

Window:Tag({
    Title = 'v1.0.4',
    Color = Color3.fromHex('#30ff6a'),
    Radius = 13,
})

do
local MovementTab = Window:Tab({
    Title = 'MOVEMENT',
    Icon = 'accessibility',
})
local BankBalance = MovementTab:Button({
    Title = '\u{1f3e6} Bank Balance',
    Desc = 'N/A',
})
local HandBalance = MovementTab:Button({
    Title = '\u{1f4b8} Hand Balance',
    Desc = 'N/A',
})

local function HandMoney()
    return tonumber(PlayerGui.TopRightHud.Holder.Frame.MoneyTextLabel.Text:match('%$(%d+)'))
end
local function ATMMoney()
    for _, v in ipairs(PlayerGui:GetDescendants())do
        if v:IsA('TextLabel') and string.find(v.Text, 'Bank Balance') then
            return tonumber(v.Text:match('%$(%d+)'))
        end
    end

    return 0
end

task.spawn(function()
    while task.wait(0.2) do
        BankBalance:SetDesc('<b><font color="#00FF00">$' .. (ATMMoney() or 0) .. '</font></b>')
        HandBalance:SetDesc('<b><font color="#00f2ff">$' .. (HandMoney() or 0) .. '</font></b>')
    end
end)
MovementTab:Section({
    Title = 'MOVEMENT CONTROLS',
})

local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local RootPart = Character:WaitForChild('HumanoidRootPart')

-- Walk Speed (integrado del bloque proporcionado)
local SpeedHackEnabled = false
local SpeedValue = 4

RunService.RenderStepped:Connect(function(dt)
    if SpeedHackEnabled and Player.Character then
        local hum = Player.Character:FindFirstChild('Humanoid')
        local root = Player.Character:FindFirstChild('HumanoidRootPart')
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            local move = hum.MoveDirection.Unit * ((SpeedValue / 20) * 26 * dt)
            root.CFrame = root.CFrame + Vector3.new(move.X, 0, move.Z)
        end
    end
end)

MovementTab:Toggle({
    Title = 'CFrame Speed',
    Flag = 'Walk Speed',
    Icon = 'move',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        SpeedHackEnabled = Value == true
    end,
})
MovementTab:Slider({
    Title = 'CFrame Speed Value',
    Flag = 'speed_value',
    Step = 1,
    Value = {
        Min = 1,
        Max = 20,
        Default = SpeedValue,
    },
    Callback = function(Value)
        SpeedValue = tonumber(Value) or SpeedValue
    end,
})

-- Jump Power (integrado del bloque proporcionado)
local JumpHackEnabled = false
local JumpForce = 100

UserInputService.JumpRequest:Connect(function()
    if JumpHackEnabled and Player.Character then
        local hum = Player.Character:FindFirstChild('Humanoid')
        local root = Player.Character:FindFirstChild('HumanoidRootPart')
        if hum and root and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                JumpForce,
                root.AssemblyLinearVelocity.Z
            )
        end
    end
end)

MovementTab:Toggle({
    Title = 'High Jump',
    Flag = 'jump_power',
    Icon = 'arrow-up-from-line',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        JumpHackEnabled = Value == true
    end,
})
MovementTab:Slider({
    Title = 'High Jump Power',
    Flag = 'jump_power_value',
    Step = 1,
    Value = {
        Min = 50,
        Max = 150,
        Default = JumpForce,
    },
    Callback = function(Value)
        JumpForce = tonumber(Value) or JumpForce
    end,
})

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild('Humanoid')
    RootPart = char:WaitForChild('HumanoidRootPart')
end)

local EnabledInfiniteStamina = false

MovementTab:Toggle({
    Title = 'Infinite Stamina',
    Flag = 'Inf',
    Icon = 'zap',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        EnabledInfiniteStamina = Value
    end,
})

local OldUpdate = SprintBar.update

SprintBar.update = function(...)
    if EnabledInfiniteStamina then
        return 0.9
    else
        return OldUpdate(...)
    end
end

MovementTab:Section({
    Title = 'KEYBOARD BYPASS (SHIFT / SPACE)',
})

-- ============================================================================
--   BYPASS REY: WALKSPEED & JUMPPOWER POR TECLADO (SIN INTERFAZ - TOTAL AFK)
-- ============================================================================

local Bypass_Players = game:GetService("Players")
local Bypass_RunService = game:GetService("RunService")
local Bypass_UserInputService = game:GetService("UserInputService")
local Bypass_LocalPlayer = Bypass_Players.LocalPlayer

-- CONFIGURACIÓN INDEPENDIENTE (Modifica estos números a tu gusto)
local ConfigModificadores = {
    BypassActivo = false,
    
    -- Ajuste de Caminata Rápida (Se activa al dejar presionado Shift Izquierdo)
    TeclaVelocidad = Enum.KeyCode.LeftShift,
    VelocidadMultiplicador = 35, -- Cuánto quieres correr (Recomendado: 25 a 50)
    
    -- Ajuste de Súper Salto (Se aplica al presionar Espacio)
    PotenciaSaltoBypass = 95,   -- Altura del salto (Recomendado: 70 a 110)
}

-- Variables físicas de almacenamiento de Roblox
local WSBase = 16
local ConexionBypassNativa = nil

-- Bucle de física constante (Heartbeat corre después de cada frame físico del servidor)
local function ejecutarBypassTotal(deltaTime)
    if not ConfigModificadores.BypassActivo then return end

    local character = Bypass_LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid or humanoid.Health <= 0 then return end

    -- Si estás manejando un carro en BlockSpin, apagar para no congelar el chasis
    if humanoid.SeatPart then 
        if WSBase and WSBase > 0 then humanoid.WalkSpeed = WSBase end
        return 
    end

    local dt = math.clamp(deltaTime or 0, 0, 0.05)

    -- [1] BYPASS DE WALKSPEED (POR COORDENADAS DE CFRAME)
    if humanoid.WalkSpeed > 0 then
        WSBase = humanoid.WalkSpeed
        humanoid.WalkSpeed = 0 -- Forzamos el motor oficial a 0 para congelar el rastreo de red
    end

    -- Detectar si el jugador está presionando la tecla para correr rápido
    local estaCorriendo = Bypass_UserInputService:IsKeyDown(ConfigModificadores.TeclaVelocidad)
    local direccionCaminata = humanoid.MoveDirection
    
    -- Si presiona Shift usa el multiplicador, si no, se mueve a la velocidad normal (16)
    local velocidadFinal = estaCorriendo and (WSBase + (ConfigModificadores.VelocidadMultiplicador * 2.5)) or WSBase

    if direccionCaminata.Magnitude > 0.08 then
        -- Mueve el CFrame cuadro por cuadro de forma milimétrica simulando teletransportación
        character:TranslateBy(direccionCaminata.Unit * dt * velocidadFinal)
    end

    -- [2] BYPASS DE JUMPPOWER (POR IMPULSO LINEAL EN EJE Y)
    -- Si presiona saltar y el personaje no está ya subiendo en una parábola, inyectar el salto
    if humanoid.Jump and rootPart.AssemblyLinearVelocity.Y < 1 then
        local impulsoVertical = ConfigModificadores.PotenciaSaltoBypass
        
        -- Sobreescribimos la velocidad angular del motor de Roblox directamente en la raíz física
        rootPart.AssemblyLinearVelocity = Vector3.new(
            rootPart.AssemblyLinearVelocity.X, 
            impulsoVertical, 
            rootPart.AssemblyLinearVelocity.Z
        )
    end

    -- Engañar de forma diferida al servidor diciendo que tu input de caminata oficial es cero
    humanoid:Move(Vector3.zero, false)
end

-- Activar e inyectar el bucle matemático en el motor de Roblox
if ConexionBypassNativa then ConexionBypassNativa:Disconnect() end
ConexionBypassNativa = Bypass_RunService.Heartbeat:Connect(ejecutarBypassTotal)

print("[+] Módulo Bypass WalkSpeed & JumpPower cargado.")
print("[>] Deja presionado Shift Izquierdo para correr a velocidad: " .. tostring(ConfigModificadores.VelocidadMultiplicador))
print("[>] Presiona Espacio para súper salto de potencia: " .. tostring(ConfigModificadores.PotenciaSaltoBypass))

MovementTab:Toggle({
    Title = 'Keyboard Bypass (Shift / Space)',
    Desc = 'Hold LeftShift to sprint, Space for super jump',
    Flag = 'BypassMovement',
    Icon = 'zap',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        ConfigModificadores.BypassActivo = Value == true
        if not ConfigModificadores.BypassActivo then
            local char = Bypass_LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            if hum and WSBase and WSBase > 0 then
                hum.WalkSpeed = WSBase
            end
        end
    end,
})

MovementTab:Slider({
    Title = 'Bypass Sprint Multiplier',
    Desc = 'Speed multiplier when holding Shift',
    Flag = 'BypassSpeedMultiplier',
    Step = 1,
    Value = {
        Min = 10,
        Max = 80,
        Default = ConfigModificadores.VelocidadMultiplicador,
    },
    Callback = function(Value)
        ConfigModificadores.VelocidadMultiplicador = tonumber(Value) or 35
    end,
})

MovementTab:Slider({
    Title = 'Bypass Jump Power',
    Desc = 'Impulse power when jumping',
    Flag = 'BypassJumpPower',
    Step = 1,
    Value = {
        Min = 50,
        Max = 150,
        Default = ConfigModificadores.PotenciaSaltoBypass,
    },
    Callback = function(Value)
        ConfigModificadores.PotenciaSaltoBypass = tonumber(Value) or 95
    end,
})

MovementTab:Section({
    Title = 'ITEMS & UTILITIES',
})
local Players = game:GetService('Players')
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Net = require(ReplicatedStorage.Modules.Core.Net)
local dropfolder = workspace:FindFirstChild('DroppedItems') or workspace:WaitForChild('DroppedItems', 15)

_G.AutoPickItems = false
local AUTO_PICK_DISTANCE = 20
local AUTO_PICK_COOLDOWN = 0.75
local autoPickLastAttempt = setmetatable({}, { __mode = 'k' })

local function GetRootPart()
    local character = player.Character
    return character and character:FindFirstChild('HumanoidRootPart')
end

local function GetItemPosition(item)
    if not item or not item.Parent then return nil end

    local zone = item:FindFirstChild('PickUpZone')
    if zone and zone:IsA('BasePart') then
        return zone.Position
    end

    local ok, pivot = pcall(function()
        return item:GetPivot()
    end)
    if ok and pivot then
        return pivot.Position
    end
    return nil
end

task.spawn(function()
    while task.wait(0.2) do
        if not _G.AutoPickItems then
            continue
        end

        if not dropfolder or not dropfolder.Parent then
            dropfolder = workspace:FindFirstChild('DroppedItems')
            continue
        end

        local root = GetRootPart()
        if not root then
            continue
        end

        local now = os.clock()
        for _, item in ipairs(dropfolder:GetChildren()) do
            if not _G.AutoPickItems then break end
            if item:IsA('Model') and not item:GetAttribute('Locked') then
                local position = GetItemPosition(item)
                local lastAttempt = autoPickLastAttempt[item] or 0
                if position
                    and (position - root.Position).Magnitude <= AUTO_PICK_DISTANCE
                    and now - lastAttempt >= AUTO_PICK_COOLDOWN then
                    autoPickLastAttempt[item] = now
                    -- Llamada protegida para evitar que un error detenga el bucle.
                    pcall(function()
                        Net.get('pickup_dropped_item', item)
                    end)
                end
            end
        end
    end
end)

MovementTab:Toggle({
    Title = 'Auto Pick Item',
    Flag = 'Pickitem',
    Desc = 'Normal pickup of nearby items (20 studs)',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(value)
        _G.AutoPickItems = value == true
    end,
})

-- Auto Drop Feature
local AutoDropEnabled = false
local SelectedRarity = { 'Common' }

MovementTab:Toggle({
    Title = 'Auto Drop',
    Desc = 'Automatically drop items by rarity',
    Flag = 'AutoDrop',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        AutoDropEnabled = Value
    end,
})

MovementTab:Dropdown({
    Title = 'Select Rarity',
    Desc = 'Choose rarity to auto drop',
    Flag = 'DropRarity',
    Icon = 'list',
    Values = {
        'Common',
        'Uncommon',
        'Rare',
        'Epic',
        'Legendary',
        'Omega'
    },
    Value = { '' },
    Multi = true,
    Callback = function(Value)
        SelectedRarity = Value or { 'Common' }
    end,
})

-- Auto Drop Loop
local function findRarityByItemName(itemName)
    if not itemName or itemName == "" then return "Unknown" end
    
    local itemsDataFolder = ReplicatedStorage:WaitForChild("Items")
    
    for _, itemData in pairs(itemsDataFolder:GetDescendants()) do
        if itemData.Name == itemName then
            local rarity = itemData:GetAttribute("RarityName") or "Common"
            return rarity
        end
    end
    return "Unknown"
end

task.spawn(function()
    while task.wait(0.1) do
        if AutoDropEnabled then
            local pGui = Player:WaitForChild("PlayerGui")
            local scrollingFrame = pGui:WaitForChild("Items").ItemsHolder.ItemsScrollingFrame
            
            for _, obj in pairs(scrollingFrame:GetChildren()) do
                local guid = obj:GetAttribute("GUID")
                
                if guid then
                    local nameText = ""
                    local itemNameObj = obj:FindFirstChild("ItemName", true)
                    if itemNameObj and (itemNameObj:IsA("TextLabel") or itemNameObj:IsA("TextBox")) then
                        nameText = itemNameObj.Text
                    end
                    
                    local rarityName = findRarityByItemName(nameText)
                    
                    -- Check if rarity is in selected rarities (multi-selection support)
                    local shouldDrop = false
                    for _, selected in pairs(SelectedRarity) do
                        if rarityName == selected then
                            shouldDrop = true
                            break
                        end
                    end
                    
                    if shouldDrop then
                        local itemCount = 1
                        local itemCountObj = obj:FindFirstChild("ItemCount", true)
                        if itemCountObj and (itemCountObj:IsA("TextLabel") or itemCountObj:IsA("TextBox")) then
                            local countText = itemCountObj.Text:gsub("[^%d]", "") -- Extract only numbers
                            itemCount = tonumber(countText) or 1
                        end
                        
                        pcall(function()
                            Net.send("drop_item", guid, itemCount)
                        end)
                        task.wait() -- Small delay between drops
                    end
                end
            end
        end
    end
end)

_G.AntiLock = false

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LocalPlayer = Players.LocalPlayer
local MaxDistance = 1
local ANIM_ID = 'rbxassetid://10147821284'
local AntiAimAnimTrack = nil
local RealCFrame = CFrame.new()
local RealVelocity = Vector3.zero

local function playDanceAntiAim()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild('Humanoid')

    if AntiAimAnimTrack then
        AntiAimAnimTrack:Stop()
        AntiAimAnimTrack:Destroy()
    end

    local anim = Instance.new('Animation')

    anim.AnimationId = ANIM_ID
    AntiAimAnimTrack = humanoid:LoadAnimation(anim)
    AntiAimAnimTrack.Looped = true

    AntiAimAnimTrack:Play()
    AntiAimAnimTrack:AdjustSpeed(9999)
end
local function stopDanceAntiAim()
    if AntiAimAnimTrack then
        AntiAimAnimTrack:Stop()
        AntiAimAnimTrack:Destroy()

        AntiAimAnimTrack = nil
    end
end

function RandomNumberRange(a)
    return math.random(-a, a)
end

local oldIndex

oldIndex = hookmetamethod(game, '__index', newcclosure(function(self, key)
    if _G.AntiLock and not checkcaller() then
        if self:IsA('BasePart') and key == 'CFrame' then
            if LocalPlayer.Character and self == LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                return RealCFrame
            end
        end
    end

    return oldIndex(self, key)
end))

RunService.Heartbeat:Connect(function()
    if _G.AntiLock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        local Root = LocalPlayer.Character.HumanoidRootPart

        RealCFrame = Root.CFrame
        RealVelocity = Root.AssemblyLinearVelocity

        local randomAngle = math.random(0, 360)
        local Offset = Vector3.new(RandomNumberRange(MaxDistance), RandomNumberRange(MaxDistance), RandomNumberRange(MaxDistance))

        Root.CFrame = RealCFrame * CFrame.Angles(0, math.rad(randomAngle), 0) * CFrame.new(Offset)
        Root.AssemblyLinearVelocity = Vector3.new(RandomNumberRange(500), RandomNumberRange(500), RandomNumberRange(500))

        RunService.RenderStepped:Wait()

        Root.CFrame = RealCFrame
        Root.AssemblyLinearVelocity = RealVelocity
    end
end)
MovementTab:Section({
    Title = 'DEFENSE',
})
MovementTab:Toggle({
    Title = 'Anti Lock',
    Flag = 'antilock',
    Desc = 'No one can shoot u',
    Icon = 'shield',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.AntiLock = Value

        if Value then
            playDanceAntiAim()
            game:GetService('StarterGui'):SetCore('SendNotification', {
                Title = 'Anti-Lock',
                Text = 'Enabled',
                Duration = 2,
            })
        else
            stopDanceAntiAim()
        end
    end,
})
MovementTab:Toggle({
    Title = 'Hide Name',
    Flag = 'HideName',
    Desc = 'Disable your name only client',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.HideName = Value

        local function toggleName()
            local char = LocalPlayer.Character

            if char then
                local hrp = char:FindFirstChild('HumanoidRootPart')

                if hrp then
                    local bbGui = hrp:FindFirstChild('CharacterBillboardGui')

                    if bbGui then
                        bbGui.Enabled = not _G.HideName
                    end
                end
            end
        end

        toggleName()

        if _G.HideName then
            if not _G.HideNameConn then
                _G.HideNameConn = LocalPlayer.CharacterAdded:Connect(function(char)
                    if _G.HideName then
                        task.wait(1)
                        toggleName()
                    end
                end)
            end
        end
    end,
})

local function AntiRagdollLoop()
    while _G.AntiRagdoll do
        task.wait(0.1)
        pcall(function()
            local isRagdolled = RagdollModule.is_ragdolling.get()

            if isRagdolled then
                RagdollModule.is_ragdolling.set(false)
                pcall(function()
                    Net.send('end_ragdoll_early')
                end)
                pcall(function()
                    Net.send('clear_ragdoll')
                end)
                pcall(function()
                    Net.get('end_ragdoll_early')
                end)
                pcall(function()
                    Net.get('clear_ragdoll')
                end)
            end
        end)
    end
end

MovementTab:Toggle({
    Title = 'Anti Ragdoll',
    Desc = 'No ragdoll lol',
    Flag = 'AntiRagdoll',
    Icon = 'shield-check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.AntiRagdoll = Value

        if Value then
            task.spawn(AntiRagdollLoop)
        end
    end,
})

local func = {}
local EverDown = false
local WasAntiLockEnabled = false

func.AntiDied = function()
    while task.wait(0.24) do
        if Settings.AntiDied then
            if not Character or not Humanoid or not RootPart then
                Character = Client.Character or Client.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild('Humanoid')
                RootPart = Character:WaitForChild('HumanoidRootPart')
            end

            local hum = CharModule.get_hum()

            if hum then
                if hum:GetAttribute('HasBeenDowned') then
                    if not hum:GetAttribute('IsDead') then
                        if Humanoid.Health > 0 then
                            if _G.AntiLock then
                                WasAntiLockEnabled = true
                                _G.AntiLock = false

                                stopDanceAntiAim()
                                WindUI:Notify({
                                    Title = 'Anti System',
                                    Content = 'Anti Lock disabled (Anti Kill active)',
                                    Duration = 2,
                                })
                            end

                            local deathScreenExists = PlayerGui:FindFirstChild('DeathScreen')

                            if deathScreenExists then
                                local deathscreen = PlayerGui.DeathScreen.DeathScreenHolder

                                if not deathscreen.Visible then
                                    local Radius = 15
                                    local targetY = RootPart.Position.Y - Radius
                                    local currentY = RootPart.Position.Y
                                    local deltaY = targetY - currentY
                                    local Gan = math.random(-5, 15)

                                    RootPart.Anchored = false
                                    RootPart.CanCollide = false
                                    RootPart.CFrame = RootPart.CFrame * CFrame.new(Gan, deltaY, Gan)
                                    RootPart.Velocity = Vector3.new(RootPart.Velocity.X, -11, RootPart.Velocity.Z)

                                    for i, v in pairs(Character:GetChildren())do
                                        if v:IsA('BasePart') then
                                            v.CanCollide = false
                                            v.Anchored = false
                                            v.CFrame = v.CFrame * CFrame.new(0, deltaY, 0)
                                            v.Velocity = Vector3.new(v.Velocity.X, -11, v.Velocity.Z)
                                        end
                                    end

                                    EverDown = true
                                end
                            end
                        else
                            EverDown = false
                        end
                    else
                        EverDown = false
                    end
                else
                    if EverDown then
                        local ganys = 15
                        local targetY = RootPart.Position.Y - ganys
                        local currentY = RootPart.Position.Y
                        local deltaY = targetY - currentY

                        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)

                        if not Client:GetAttribute('IsInCombat') then
                            EverDown = false

                            Net.send('request_respawn')

                            if WasAntiLockEnabled then
                                _G.AntiLock = true

                                playDanceAntiAim()

                                WasAntiLockEnabled = false

                                WindUI:Notify({
                                    Title = 'Anti System',
                                    Content = 'Anti Lock re-enabled',
                                    Duration = 2,
                                })
                            end
                        end
                    end
                end
            end
        else
            EverDown = false

            if WasAntiLockEnabled then
                WasAntiLockEnabled = false
            end
        end
    end
end

MovementTab:Toggle({
    Title = 'Anti Kill',
    Desc = 'Normal Player cant Finish',
    Flag = 'antikill',
    Icon = 'heart-pulse',
    Type = 'Checkbox',
    Value = false,
    Callback = function(state)
        Settings.AntiDied = state

        if state then
            task.spawn(func.AntiDied)
        end
    end,
})
MovementTab:Section({
    Title = 'SURVIVAL',
})
MovementTab:Toggle({
    Title = 'Auto Mask',
    Flag = 'automask',
    Desc = 'Equip Shiesty',
    Icon = 'check',
    Type = 'Checkbox',
    Callback = function(Value)
        if not Value then
            return
        end

        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Player = game.Players.LocalPlayer
        local PlayerGui = Player:WaitForChild('PlayerGui')
        local Net = require(ReplicatedStorage.Modules.Core.Net)

        function GetAllInfos(itemName)
            local infos = {}
            local Items = PlayerGui.Items
            local Holding = Items:FindFirstChild('ItemsHolder').ItemsScrollingFrame

            for _, v in ipairs(Holding:GetChildren())do
                if v.Name ~= 'Folder' and v.Name ~= 'UIGridLayout' and v.Name ~= 'ItemTemplate' then
                    if v.ItemName.Text == itemName then
                        table.insert(infos, {
                            Uid = v.Name,
                            Using = v:FindFirstChild('ItemEquipped').Visible,
                            Drowning = v:FindFirstChild('DestroyedItemIcon').Visible,
                        })
                    end
                end
            end

            return infos
        end
        function EquipAccessory(itemName)
            local infos = GetAllInfos(itemName)

            for _, info in ipairs(infos)do
                if not info.Using and not info.Drowning then
                    Net.get('toggle_equip_item', info.Uid)

                    repeat
                        task.wait()
                    until GetAllInfos(itemName)[1].Using
                end
            end
        end

        EquipAccessory('Shiesty')
    end,
})
MovementTab:Toggle({
    Title = 'Auto Health',
    Flag = 'autohealth',
    Desc = 'Auto use Bloodbag',
    Icon = 'check',
    Type = 'Checkbox',
    Callback = function(state)
        c().AutoBlood = state

        if not state then
            return
        end

        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild('Humanoid')
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Net = require(ReplicatedStorage.Modules.Core.Net)
        local ItemsUI = Player.PlayerGui.Items.ItemsHolder.ItemsScrollingFrame
        local Busy = false

        local function GetBloodBagUID()
            for _, v in ipairs(ItemsUI:GetChildren())do
                if v:IsA('Frame') or v:IsA('ImageButton') then
                    local itemType = v:GetAttribute('ItemType')

                    if itemType and itemType:lower() == 'consumable' then
                        return v.Name
                    end
                end
            end

            return nil
        end
        local function UseBloodBag(uid)
            if Busy then
                return
            end

            Busy = true

            local tool = Character:FindFirstChild('Blood Bag')
            local didEquip = false

            if not tool then
                Net.get('toggle_equip_item', uid)

                didEquip = true

                task.wait(0.1)

                tool = Character:FindFirstChild('Blood Bag') or Player.Backpack:FindFirstChild('Blood Bag')
            end
            if tool then
                while Humanoid.Health < 90 do
                    Net.get('consume_power_up', tool)
                    task.wait(0.1)
                end

                if didEquip then
                    Net.get('toggle_equip_item', uid)
                end
            else
                warn(' Blood Bag tool not found.')
            end

            Busy = false
        end

        task.spawn(function()
            while c().AutoBlood do
                task.wait(0.2)

                if Humanoid.Health <= 50 then
                    local uid = GetBloodBagUID()

                    if uid then
                        UseBloodBag(uid)
                    else
                        warn('\u{26a0} No bloodbag found.')
                    end
                end
            end
        end)
    end,
})
MovementTab:Divider()

MovementTab:Section({
    Title = 'POSITION / UNDERGROUND',
})

local EnabledSnapRunning = false
local SnapThread = nil
local YoffsetValue = 70

func.EnabledSnap = function()
    local basePosition = RootPart.Position

    while EnabledSnapRunning do
        task.wait()

        if not EnabledSnapRunning then
            break
        end

        local currentY = RootPart.Position.Y
        local targetY = basePosition.Y - YoffsetValue
        local deltaY = targetY - currentY

        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)
    end
end

local function SetSnapState(value)
    if EnabledSnapRunning == value then
        return
    end

    EnabledSnapRunning = value

    if value then
        if not SnapThread then
            SnapThread = task.spawn(func.EnabledSnap)
        end
    else
        SnapThread = nil
    end

    MovementTab:Get('UndergroundToggle'):SetValue(value)
end

MovementTab:Toggle({
    Title = 'Underground',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Flag = 'UndergroundToggle',
    Callback = function(value)
        SetSnapState(value)
    end,
})
MovementTab:Keybind({
    Title = 'Keybind',
    Flag = 'keybind',
    Value = 'G',
    Callback = function()
        SetSnapState(not EnabledSnapRunning)
    end,
})
MovementTab:Slider({
    Title = 'Snap Height',
    Flag = 'snap_height',
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 10,
    },
    Callback = function(value)
        YoffsetValue = value
    end,
})



end

do
local CombatTab = Window:Tab({
    Title = 'COMBAT',
    Icon = 'crosshair',
})
-- ============================================================================
--   MÓDULO ANTI KILL (INTEGRADO DE MORTY HUB)
-- ============================================================================
local antiKillEnabled = false
local underMapPos = nil
local isFlickering = false

local function antiKillIsDowned()
    local hum = (CharModule and CharModule.get_hum and CharModule.get_hum())
    if not hum then
        local c = Client.Character or (Players.LocalPlayer and Players.LocalPlayer.Character)
        hum = c and c:FindFirstChildOfClass("Humanoid")
    end
    if not hum or hum.Health <= 0 then return false end
    return hum:GetAttribute("HasBeenDowned") or hum:GetAttribute("IsDead")
end

local function antiKillGetHRP()
    local char = CharModule and CharModule.current_char and CharModule.current_char.get and CharModule.current_char.get()
    if not char then
        char = Client.Character or (Players.LocalPlayer and Players.LocalPlayer.Character)
    end
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function antiKillTeleportUnderground()
    local root = antiKillGetHRP()
    if not root then return end
    underMapPos = root.CFrame + Vector3.new(0, -55, 0)
    root.CFrame = underMapPos
end

local function antiKillFlickerAndMove()
    if isFlickering then return end
    isFlickering = true
    task.spawn(function()
        while isFlickering and antiKillEnabled and antiKillIsDowned() do
            local hum = (CharModule and CharModule.get_hum and CharModule.get_hum()) or (Client.Character and Client.Character:FindFirstChildOfClass("Humanoid"))
            if hum and hum.Health <= 0 then break end
            local root = antiKillGetHRP()
            if root and underMapPos then
                local angle = math.random() * math.pi * 2
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * 30
                root.CFrame = CFrame.new(underMapPos.Position + offset)
                task.wait(0.05)
                root.CFrame = underMapPos
            end
            task.wait(0.1)
        end
        isFlickering = false
    end)
end

RunService.Heartbeat:Connect(function()
    if antiKillEnabled then
        if antiKillIsDowned() then
            local root = antiKillGetHRP()
            if root and not underMapPos then
                antiKillTeleportUnderground()
            end
            antiKillFlickerAndMove()
        else
            if underMapPos then
                local root = antiKillGetHRP()
                if root then
                    root.CFrame = underMapPos + Vector3.new(0, 55, 0)
                end
                underMapPos = nil
            end
            isFlickering = false
        end
    end
end)


-- Visual-only FOV and Zen-style line. No aim, target selection, or firing automation.
local FOVRadius = 120
local ShowFOVEnabled = false
local CombatGui = Instance.new('ScreenGui')
CombatGui.Name = 'M0rganVisuals'
CombatGui.IgnoreGuiInset = true
CombatGui.ResetOnSpawn = false
CombatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CombatGui.Parent = game:GetService('CoreGui')

local FOVFrame = Instance.new('Frame')
FOVFrame.Name = 'FOV'
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = CombatGui
local FOVCorner = Instance.new('UICorner')
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame
local FOVStroke = Instance.new('UIStroke')
FOVStroke.Thickness = 2
FOVStroke.Parent = FOVFrame

CombatTab:Section({
    Title = "ANTI KILL (MORTY HUB)",
})

CombatTab:Toggle({
    Title = "Anti Kill",
    Flag = "anti_kill_morty",
    Desc = "Teleports underground when downed & flickers to prevent execution",
    Icon = "shield-alert",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        antiKillEnabled = state
        if not state and underMapPos then
            local root = antiKillGetHRP()
            if root then
                root.CFrame = underMapPos + Vector3.new(0, 55, 0)
            end
            underMapPos = nil
            isFlickering = false
        end
    end,
})

CombatTab:Divider()

CombatTab:Toggle({
    Title = 'Show FOV',
    Flag = 'show_fov',
    Desc = 'Visual FOV circle only',
    Icon = 'circle',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        ShowFOVEnabled = state
        FOVFrame.Visible = state
    end,
})
CombatTab:Slider({
    Title = 'FOV Size',
    Flag = 'fov_size',
    Step = 1,
    Value = {
        Min = 20,
        Max = 1000,
        Default = FOVRadius,
    },
    Callback = function(value)
        FOVRadius = tonumber(value) or 120
        FOVFrame.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
    end,
})


-- Line Lock visual: línea roja + rombo blanco; no modifica la cámara ni apunta automáticamente.
-- Conserva la opción y los controles existentes en el mismo lugar.
local LineLockEnabled = false
local IgnoreLineLockPlayer = false
local SelectedLineLockPlayer = 'None'
local LineLockLine
local LineLockConnection
local LineLockDiamond = {}
local smoothedTargetPos = nil
local LerpSmoothness = 0.75

local LineLockDrawingAvailable = pcall(function()
    LineLockLine = Drawing.new('Line')
    LineLockLine.Thickness = 1.3
    LineLockLine.Color = Color3.fromRGB(255, 50, 50)
    LineLockLine.Transparency = 1
    LineLockLine.Visible = false
    for i = 1, 4 do
        local line = Drawing.new('Line')
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 1.2
        line.Visible = false
        table.insert(LineLockDiamond, line)
    end
end)

if not LineLockDrawingAvailable then
    if LineLockLine then pcall(function() LineLockLine:Remove() end) end
    LineLockLine = nil
    for _, line in ipairs(LineLockDiamond) do
        pcall(function() line:Remove() end)
    end
    table.clear(LineLockDiamond)
end

local function hideLineLockDrawings()
    if LineLockLine then LineLockLine.Visible = false end
    for _, line in ipairs(LineLockDiamond) do line.Visible = false end
end

local function getLineLockTarget()
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closest, closestDistance = nil, FOVRadius
    for _, player in ipairs(Players:GetPlayers()) do
        local isIgnored = IgnoreLineLockPlayer and player.Name == SelectedLineLockPlayer
        if player ~= LocalPlayer and not isIgnored then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass('Humanoid')
            local head = character and character:FindFirstChild('Head')
            if humanoid and humanoid.Health > 0 and head then
                local point, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and point.Z > 0 then
                    local distance = (Vector2.new(point.X, point.Y) - center).Magnitude
                    if distance <= FOVRadius and distance < closestDistance then
                        closest, closestDistance = player, distance
                    end
                end
            end
        end
    end
    return closest
end

local function setLineLockEnabled(state)
    LineLockEnabled = state == true
    if not LineLockEnabled then
        hideLineLockDrawings()
        smoothedTargetPos = nil
    end
end

CombatTab:Toggle({
    Title = 'Line Lock',
    Flag = 'line_lock',
    Desc = 'Visual line and diamond on closest player within FOV',
    Icon = 'scan-line',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        setLineLockEnabled(state)
    end,
})

-- Selección de jugador que Line Lock debe ignorar; no afecta otros ESP.
CombatTab:Section({ Title = 'Team / Ignore Player' })
local IgnorePlayerOptions = { 'None' }
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then table.insert(IgnorePlayerOptions, player.Name) end
end

CombatTab:Dropdown({
    Title = 'Select Player',
    Desc = 'Select player to ignore for Line Lock',
    Flag = 'line_lock_ignored_player',
    Values = IgnorePlayerOptions,
    Default = 'None',
    Callback = function(value)
        if type(value) == 'table' then value = value[1] end
        SelectedLineLockPlayer = (type(value) == 'string' and value ~= '') and value or 'None'
    end,
})

CombatTab:Toggle({
    Title = 'Enable Ignore Player',
    Desc = 'Only affects Line Lock; other ESPs still function',
    Flag = 'line_lock_ignore_player_enabled',
    Icon = 'user-round-x',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        IgnoreLineLockPlayer = state == true
    end,
})

if LineLockDrawingAvailable and LineLockLine then
    LineLockConnection = RunService.RenderStepped:Connect(function()
        if not LineLockEnabled then
            hideLineLockDrawings()
            return
        end
        local camera = workspace.CurrentCamera
        local target = getLineLockTarget()
        local character = target and target.Character
        local head = character and character:FindFirstChild('Head')
        if not camera or not head then
            hideLineLockDrawings()
            smoothedTargetPos = nil
            return
        end

        if not smoothedTargetPos then
            smoothedTargetPos = head.Position
        else
            smoothedTargetPos = smoothedTargetPos:Lerp(head.Position, LerpSmoothness)
        end
        local point, onScreen = camera:WorldToViewportPoint(smoothedTargetPos)
        if not onScreen or point.Z <= 0 then
            hideLineLockDrawings()
            return
        end

        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local target2D = Vector2.new(point.X, point.Y)
        LineLockLine.From = center
        LineLockLine.To = target2D
        LineLockLine.Color = Color3.fromRGB(255, 50, 50)
        LineLockLine.Thickness = 1.3
        LineLockLine.Visible = true

        local top3D = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local bottom3D = camera:WorldToViewportPoint(head.Position - Vector3.new(0, 0.5, 0))
        local size = math.clamp((Vector2.new(top3D.X, top3D.Y) - Vector2.new(bottom3D.X, bottom3D.Y)).Magnitude / 2, 8, 25)
        local top = Vector2.new(point.X, point.Y - size)
        local right = Vector2.new(point.X + size, point.Y)
        local bottom = Vector2.new(point.X, point.Y + size)
        local left = Vector2.new(point.X - size, point.Y)
        local fromPoints = {top, right, bottom, left}
        local toPoints = {right, bottom, left, top}
        for i, line in ipairs(LineLockDiamond) do
            line.From = fromPoints[i]
            line.To = toPoints[i]
            line.Visible = true
        end
    end)
end

end

do
local VehicleTab = Window:Tab({
    Title = 'CAR',
    Icon = 'van',
})

VehicleTab:Section({
    Title = 'VEHICLE MOVEMENT',
})

local function BumpAuraLoop()
    while _G.BumpAura do
        task.wait(0.1)

        local car = Vechine.get_car_player_is_in()

        if not car then
            task.wait()
        else
            for _, target in CharModule.get_all()do
                if target ~= Character then
                    local hrp = target:FindFirstChild('HumanoidRootPart')

                    if hrp and GetDistanceFromRootPart(hrp) < 100 then
                        local Assembly = car.DriverSeat.AssemblyLinearVelocity + Vector3.new(65, 65, 65)

                        Net.send('run_over', car, target, Assembly)
                    end
                end
            end
        end
    end
end

VehicleTab:Toggle({
    Title = 'Car Guard',
    Flag = 'CarGuard',
    Icon = 'shield',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        CarGuardEnabled = Value
    end,
})
VehicleTab:Toggle({
    Title = 'Bump Aura',
    Flag = 'BumpAura',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.BumpAura = Value

        if Value then
            task.spawn(BumpAuraLoop)
        end
    end,
})
VehicleTab:Divider()

-- Exact Vehicle System from sasware.lua
local Storage = {
	Vehicle_Attributes = {
		{ Name = "acceleration", Type = "number", Min = 5, Max = 100, DisplayName = "Acceleration" },
		{ Name = "slipThreshold", Type = "number", Min = 10, Max = 100, DisplayName = "Slip Threshold" },
		{ Name = "staticFriction", Type = "number", Min = 1, Max = 10, DisplayName = "Static Friction" },
	},
}

local function G_Toggle(ToggleName)
    local window = getgenv().Window
    if not window then
        print("G_Toggle: Window not found")
        return false
    end
    if not window.Toggles then
        print("G_Toggle: Window.Toggles not found")
        return false
    end
    if not window.Toggles[ToggleName] then
        print("G_Toggle: Toggle", ToggleName, "not found")
        return false
    end
    local value = window.Toggles[ToggleName].Value == true
    print("G_Toggle:", ToggleName, "=", value)
    return value
end

local function G_Option(OptionName)
    local window = getgenv().Window
    if not window then
        print("G_Option: Window not found")
        return nil
    end
    if not window.Options then
        print("G_Option: Window.Options not found")
        return nil
    end
    if not window.Options[OptionName] then
        print("G_Option: Option", OptionName, "not found")
        return nil
    end
    local value = window.Options[OptionName].Value
    print("G_Option:", OptionName, "=", value)
    return value
end

-- Exact vehicle functions from sasware.lua
local function Sit(VehicleSeat, NYield)
    local Vehicle = VehicleSeat.Parent 
    local Prompt = Vehicle.Chassis.DrivePromptAttachment.DrivePrompt
    local Character = LocalPlayer.Character

    local Origin = Character:GetPivot()

    -- Try sitting in the car first
    fireproximityprompt(Prompt, 0.5)
    if not NYield then
        task.wait(0.5)
        if not Character.Humanoid.SeatPart then
            -- Attempting to gain network ownership of vehicle seat...
            
            local AttemptNetworkOwnershipStart = os.clock()
            while os.clock() - AttemptNetworkOwnershipStart < 0.3 and Character.Humanoid.SeatPart == nil do
                RunService.Heartbeat:Wait()
                Character:PivotTo(VehicleSeat:GetPivot())
                VehicleSeat.AssemblyLinearVelocity = Vector3.yAxis * math.random() * 10
            end

            Character:PivotTo(Origin)
            Vehicle:PivotTo(Origin)
            VehicleSeat.AssemblyLinearVelocity = Vector3.zero
            for _, BasePart in next, Character:GetDescendants() do
                if BasePart:IsA("BasePart") then
                    BasePart.AssemblyLinearVelocity = Vector3.zero
                    BasePart.AssemblyAngularVelocity = Vector3.zero
                end
            end

            if Character.Humanoid.SeatPart == nil then
                -- Failed to sit in vehicle seat.
                return
            else
                -- Successfully sat in vehicle seat.
            end
        else
            Character:PivotTo(Vehicle:GetPivot())
        end
    end
end

local GetVehicle = function()
    local Character = LocalPlayer.Character
    if not Character then
        return nil
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid") 
    local VehicleSeat = Humanoid.SeatPart

    if VehicleSeat and VehicleSeat.ClassName == "VehicleSeat" then
        local Vehicle = VehicleSeat.Parent 
        local VehicleName = Vehicle.Name

        return {
            Vehicle = Vehicle,
            Name = VehicleName,
        }
    end

    return nil
end

local FindVehicle = function()
    local Vehicles = workspace:WaitForChild("Vehicles")
    local LocalUserId = LocalPlayer.UserId
    
    print("FindVehicle: Looking for vehicles, LocalUserId:", LocalUserId)
    print("FindVehicle: Vehicles folder has", #Vehicles:GetChildren(), "children")
    
    -- First try to find owned vehicle
    for _, Vehicle in next, Vehicles:GetChildren() do
        local ownerId = Vehicle:GetAttribute("OwnerUserId")
        print("FindVehicle: Found vehicle", Vehicle.Name, "with OwnerUserId:", ownerId)
        if ownerId == LocalUserId then
            print("FindVehicle: Found matching vehicle:", Vehicle.Name)
            return {
                Vehicle = Vehicle,
                Name = Vehicle.Name,
            }
        end
    end
    
    -- Alternative: Check if player is sitting in any vehicle
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Humanoid.SeatPart then
            local Vehicle = Humanoid.SeatPart.Parent
            print("FindVehicle: Found vehicle by seat part:", Vehicle.Name)
            return {
                Vehicle = Vehicle,
                Name = Vehicle.Name,
            }
        end
    end
    
    print("FindVehicle: No matching vehicle found")
    return nil
end

-- Exact VehicleModSystem from sasware.lua
local VehicleModSystem
VehicleModSystem = {
	AttributeInfos = Storage.Vehicle_Attributes,
	TorqueAttributes = { "maxSpeedTorque", "minSpeedTorque" },
	AttributeCache = setmetatable({}, { __mode = "k" }),
	ChassisCache = setmetatable({}, { __mode = "k" }),
	LastVehicle = nil,
}

local function getDefaultPhysicalSnapshot(part)
	return {
		hadCustom = false,
		density = nil,
		densityFallback = 1,
		friction = 0.3,
		elasticity = 0,
		frictionWeight = 1,
		elasticityWeight = 1,
	}
end

function VehicleModSystem:CaptureChassisState(chassis)
	local current = chassis.CustomPhysicalProperties
	if current then
		return {
			hadCustom = true,
			density = current.Density,
			friction = current.Friction,
			elasticity = current.Elasticity,
			frictionWeight = current.FrictionWeight,
			elasticityWeight = current.ElasticityWeight,
			densityFallback = current.Density,
		}
	end
	return getDefaultPhysicalSnapshot(chassis)
end

function VehicleModSystem:RestoreChassisState(chassis, cache)
	if not cache then
		return
	end
	if cache.hadCustom and cache.density then
		chassis.CustomPhysicalProperties = PhysicalProperties.new(
			cache.density,
			cache.friction,
			cache.elasticity,
			cache.frictionWeight,
			cache.elasticityWeight
		)
	else
		local ok = pcall(function()
			chassis.CustomPhysicalProperties = nil
		end)
		if not ok then
			local density = cache.density or cache.densityFallback or 1
			chassis.CustomPhysicalProperties = PhysicalProperties.new(
				density,
				cache.friction,
				cache.elasticity,
				cache.frictionWeight,
				cache.elasticityWeight
			)
		end
	end
end

local function isInstance(value)
	return typeof(value) == "Instance"
end

function VehicleModSystem:IsInstanceValid(instance)
	if instance == nil then
		return false
	end
	return isInstance(instance) and instance.Parent ~= nil
end

function VehicleModSystem:StoreOriginal(instance, attrName, value)
	if not self:IsInstanceValid(instance) then
		return
	end
	local cache = self.AttributeCache[instance]
	if not cache then
		cache = {}
		self.AttributeCache[instance] = cache
	end
	if cache[attrName] == nil then
		cache[attrName] = value
	end
end

function VehicleModSystem:ApplyAttributeFolder(folder)
	if not self:IsInstanceValid(folder) then
		return
	end

	for _, info in ipairs(self.AttributeInfos) do
		local attrName = info.Name
		local currentValue = folder:GetAttribute(attrName)
		if currentValue ~= nil then
			self:StoreOriginal(folder, attrName, currentValue)
			local newValue = G_Option("VehicleMods_" .. attrName)
			if newValue ~= nil then
				folder:SetAttribute(attrName, newValue)
			end
		end
	end

	local torqueMultiplier = G_Option("VehicleMods_TorqueMultiplier")
	if torqueMultiplier == nil then
		torqueMultiplier = 1
	end
	for _, attrName in ipairs(self.TorqueAttributes) do
		local currentValue = folder:GetAttribute(attrName)
		if currentValue ~= nil then
			self:StoreOriginal(folder, attrName, currentValue)
			local original = self.AttributeCache[folder] and self.AttributeCache[folder][attrName]
			if type(original) == "number" and type(torqueMultiplier) == "number" then
				folder:SetAttribute(attrName, original * torqueMultiplier)
			end
		end
	end
end

function VehicleModSystem:ApplyAttributeModifiers(vehicle)
	for _, child in ipairs(vehicle:GetChildren()) do
		if child:IsA("Folder") then
			self:ApplyAttributeFolder(child)
		end
	end
end

function VehicleModSystem:ApplySlamModifier(vehicle)
	local chassis = vehicle:FindFirstChild("Chassis")
	if not (chassis and chassis:IsA("BasePart")) then
		return
	end
	if G_Toggle("VehicleSlam") then
		if not self.ChassisCache[chassis] then
			self.ChassisCache[chassis] = self:CaptureChassisState(chassis)
		end
		local cache = self.ChassisCache[chassis] or getDefaultPhysicalSnapshot(chassis)
		local friction = cache.friction or 0.3
		local elasticity = cache.elasticity or 0
		local frictionWeight = cache.frictionWeight or 1
		local elasticityWeight = cache.elasticityWeight or 1
		chassis.CustomPhysicalProperties = PhysicalProperties.new(50, friction, elasticity, frictionWeight, elasticityWeight)
	else
		local cache = self.ChassisCache[chassis]
		if cache then
			self:RestoreChassisState(chassis, cache)
			self.ChassisCache[chassis] = nil
		end
	end
end

function VehicleModSystem:PruneCache()
	for instance in pairs(self.AttributeCache) do
		if not self:IsInstanceValid(instance) then
			self.AttributeCache[instance] = nil
		end
	end
	for instance in pairs(self.ChassisCache) do
		if not self:IsInstanceValid(instance) then
			self.ChassisCache[instance] = nil
		end
	end
end

function VehicleModSystem:RestoreSlam()
	for chassis, cache in pairs(self.ChassisCache) do
		if self:IsInstanceValid(chassis) then
			self:RestoreChassisState(chassis, cache)
		end
		self.ChassisCache[chassis] = nil
	end
end

function VehicleModSystem:RevertVehicle(vehicle)
	for instance, attrMap in pairs(self.AttributeCache) do
		local shouldRevert = (not vehicle)
			or (self:IsInstanceValid(instance) and instance:IsDescendantOf(vehicle))
		if shouldRevert then
			if self:IsInstanceValid(instance) then
				for attrName, originalValue in pairs(attrMap) do
					pcall(instance.SetAttribute, instance, attrName, originalValue)
				end
			end
			self.AttributeCache[instance] = nil
		end
	end
	for chassis, cache in pairs(self.ChassisCache) do
		local shouldRevert = (not vehicle)
			or (self:IsInstanceValid(chassis) and chassis:IsDescendantOf(vehicle))
		if shouldRevert then
			if self:IsInstanceValid(chassis) then
				self:RestoreChassisState(chassis, cache)
			end
			self.ChassisCache[chassis] = nil
		end
	end
end

function VehicleModSystem:Reset()
	self:RevertVehicle(nil)
	self.LastVehicle = nil
end

function VehicleModSystem:Step()
	self:PruneCache()
	if not G_Toggle("VehicleModificationEnabled") then
		if self.LastVehicle then
			self:RevertVehicle(self.LastVehicle)
			self.LastVehicle = nil
		end
		self:RevertVehicle(nil)
		return
	end

	local VehicleData = FindVehicle()
	local vehicle = VehicleData and VehicleData.Vehicle
	if not (vehicle and vehicle.Parent) then
		if self.LastVehicle then
			self:RevertVehicle(self.LastVehicle)
			self.LastVehicle = nil
		end
		return
	end

	if self.LastVehicle and self.LastVehicle ~= vehicle then
		self:RevertVehicle(self.LastVehicle)
	end

	self.LastVehicle = vehicle
	self:ApplyAttributeModifiers(vehicle)
	self:ApplySlamModifier(vehicle)
end

-- Vehicle UI
VehicleTab:Section({
    Title = 'VEHICLE FUNCTIONS',
})

VehicleTab:Button({
    Title = 'Bring Car',
    Icon = 'car',
    Callback = function()
        local Vehicles = workspace:WaitForChild("Vehicles")
        local LocalUserId = LocalPlayer.UserId
        
        for _, Vehicle in next, Vehicles:GetChildren() do
            if Vehicle:GetAttribute("OwnerUserId") == LocalUserId then
                local Character = LocalPlayer.Character
                if Character then
                    Vehicle:PivotTo(Character:GetPivot() + Vector3.yAxis * 12)
                    for _, Descendant in next, Vehicle:GetDescendants() do
                        if Descendant:IsA("BasePart") then
                            Descendant.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end
            end
        end
    end,
})

VehicleTab:Divider()

VehicleTab:Section({
    Title = 'VEHICLE MODIFICATIONS',
})

VehicleTab:Toggle({
    Title = 'Vehicle Mods Enabled',
    Flag = 'VehicleModificationEnabled',
    Icon = 'settings',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        if not Value then
            VehicleModSystem:Reset()
            -- Turn off VehicleSlam when VehicleModificationEnabled is turned off
            local window = getgenv().Window
            if window and window.Toggles and window.Toggles.VehicleSlam then
                window.Toggles.VehicleSlam:SetValue(false)
            end
        else
            VehicleModSystem:Step()
        end
    end,
})

VehicleTab:Toggle({
    Title = 'Slammed Vehicle',
    Flag = 'VehicleSlam',
    Icon = 'arrow-down',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        if not Value then
            VehicleModSystem:RestoreSlam()
        else
            VehicleModSystem:Step()
        end
    end,
})

-- Create sliders for each vehicle attribute (exact from sasware.lua - no callbacks)
for _, Attribute in next, Storage.Vehicle_Attributes do
    if Attribute.Type == "number" then
        VehicleTab:Slider({
            Title = Attribute.DisplayName,
            Flag = 'VehicleMods_' .. Attribute.Name,
            Step = 0.01,
            Value = {
                Min = Attribute.Min,
                Max = Attribute.Max,
                Default = Attribute.Min,
            },
        })
    end
end

VehicleTab:Slider({
    Title = 'Torque Multiplier',
    Flag = 'VehicleMods_TorqueMultiplier',
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 5,
        Default = 1,
    },
})

VehicleTab:Slider({
    Title = 'Max Speed Multiplier',
    Flag = 'VehicleMods_MaxSpeedMultiplier',
    Step = 0.01,
    Value = {
        Min = 1,
        Max = 1.3,
        Default = 1,
    },
})

-- Vehicle Mod System Update Loop (Exact from sasware.lua)
task.spawn(function()
    while task.wait(0.25) do
        VehicleModSystem:Step()
    end
end)

-- Additional UI Update Loop from sasware.lua
task.spawn(function()
    while task.wait(0.5) do
        if G_Toggle("VehicleModificationEnabled") then
            local VehicleData = FindVehicle()
            if VehicleData then
                local Vehicle = VehicleData.Vehicle
                
                task.spawn(function()
                    for _, Child in next, Vehicle:GetChildren() do
                        if Child:IsA("Folder") then
                            for Attribute, _ in next, Child:GetAttributes() do
                                -- Check if this is one of the targetted attributes
                                for _, VehicleAttribute in next, Storage.Vehicle_Attributes do
                                    if Attribute == VehicleAttribute.Name then
                                        Child:SetAttribute(
                                            Attribute,
                                            G_Option("VehicleMods_" .. VehicleAttribute.Name)
                                        )
                                    end
                                end

                                if Attribute == "maxSpeedTorque" then
                                    if not Child:GetAttribute("OldmaxSpeedTorque") then
                                        Child:SetAttribute("OldmaxSpeedTorque", Child:GetAttribute("maxSpeedTorque"))
                                    end

                                    Child:SetAttribute(
                                        "maxSpeedTorque",
                                        Child:GetAttribute("OldmaxSpeedTorque")
                                            * G_Option("VehicleMods_TorqueMultiplier")
                                    )
                                elseif Attribute == "minSpeedTorque" then
                                    if not Child:GetAttribute("OldminSpeedTorque") then
                                        Child:SetAttribute("OldminSpeedTorque", Child:GetAttribute("minSpeedTorque"))
                                    end

                                    Child:SetAttribute(
                                        "minSpeedTorque",
                                        Child:GetAttribute("OldminSpeedTorque")
                                            * G_Option("VehicleMods_TorqueMultiplier")
                                    )
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end)

VehicleTab:Divider()

VehicleTab:Section({
    Title = 'VEHICLE ZNAP',
})

-- ==========================================
-- ZNAP CARRO
-- ==========================================
local Znap_Depth = 60
local Znap_PlatformSize = 800
local Znap_PlatformThickness = 5
local Znap_PlatformYOffset = 3

local Znap_Enabled = false
local Znap_NoDamage = true
local Znap_Platform = nil
local Znap_Vehicle = nil
local Znap_SavedCFrame = nil
local Znap_SavedParts = {}

local function Znap_GetVehicle()
    local char = LocalPlayer.Character
    if not char then return nil end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end

    local seat = hum.SeatPart
    if not seat then return nil end

    return seat:FindFirstAncestorOfClass("Model")
end

local function Znap_GetPrimary(model)
    if not model then return nil end
    if model.PrimaryPart then return model.PrimaryPart end

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart")
            and not (LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character)) then
            return obj
        end
    end

    return nil
end

local function Znap_CreatePlatform(pos)
    if Znap_Platform and Znap_Platform.Parent then
        Znap_Platform:Destroy()
    end

    local p = Instance.new("Part")
    p.Name = "ZnapCar_Platform"
    p.Size = Vector3.new(
        Znap_PlatformSize,
        Znap_PlatformThickness,
        Znap_PlatformSize
    )
    p.Position = pos
    p.Anchored = true
    p.CanCollide = true
    p.CanTouch = false
    p.CanQuery = false
    p.Transparency = 1
    p.Material = Enum.Material.SmoothPlastic
    p.Parent = workspace

    Znap_Platform = p
end

local function Znap_RemovePlatform()
    if Znap_Platform and Znap_Platform.Parent then
        Znap_Platform:Destroy()
    end
    Znap_Platform = nil
end

local function Znap_ProtectVehicle(model)
    if not model then return end

    Znap_SavedParts = {}

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            Znap_SavedParts[obj] = {
                CanCollide = obj.CanCollide,
                CanTouch = obj.CanTouch,
                CanQuery = obj.CanQuery,
                Anchored = obj.Anchored,
            }

            pcall(function()
                obj.CanTouch = false
                obj:SetAttribute("DamageEnabled", false)
                obj:SetAttribute("NoDamage", true)
                obj:SetAttribute("Invincible", true)
                obj:SetAttribute("GodMode", true)
            end)
        end

        if obj:IsA("SelectionBox") or obj:IsA("Highlight") then
            Znap_SavedParts[obj] = true
            pcall(function()
                obj.Enabled = false
                obj.Visible = false
            end)
        end
    end
end

local function Znap_UnprotectVehicle(model)
    if not model then return end

    for obj, data in pairs(Znap_SavedParts) do
        if obj and obj.Parent then
            if type(data) == "table" then
                pcall(function()
                    if data.CanCollide ~= nil then obj.CanCollide = data.CanCollide end
                    if data.CanTouch ~= nil then obj.CanTouch = data.CanTouch end
                    if data.CanQuery ~= nil then obj.CanQuery = data.CanQuery end
                    if data.Anchored ~= nil then obj.Anchored = data.Anchored end

                    obj:SetAttribute("DamageEnabled", nil)
                    obj:SetAttribute("NoDamage", nil)
                    obj:SetAttribute("Invincible", nil)
                    obj:SetAttribute("GodMode", nil)
                end)
            end
        end
    end

    Znap_SavedParts = {}
end

local function Znap_Down()
    local model = Znap_GetVehicle()
    if not model then return false end

    local primary = Znap_GetPrimary(model)
    if not primary then return false end

    Znap_Vehicle = model
    Znap_SavedCFrame = primary.CFrame

    if Znap_NoDamage then
        Znap_ProtectVehicle(model)
    end

    local newPos = primary.Position - Vector3.new(0, Znap_Depth, 0)

    Znap_CreatePlatform(Vector3.new(
        newPos.X,
        newPos.Y - Znap_PlatformYOffset,
        newPos.Z
    ))

    return pcall(function()
        if model.PrimaryPart then
            model:SetPrimaryPartCFrame(CFrame.new(newPos))
        else
            local offset = newPos - primary.Position
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored then
                    obj.CFrame = obj.CFrame + offset
                end
            end
        end
    end)
end

local function Znap_Up()
    if not Znap_Vehicle then
        Znap_RemovePlatform()
        return
    end

    local model = Znap_Vehicle
    local primary = Znap_GetPrimary(model)

    if primary and Znap_SavedCFrame then
        local targetPos = Vector3.new(
            primary.Position.X,
            Znap_SavedCFrame.Position.Y,
            primary.Position.Z
        )

        pcall(function()
            if model.PrimaryPart then
                model:SetPrimaryPartCFrame(CFrame.new(targetPos))
            else
                local offset = targetPos - primary.Position
                for _, obj in ipairs(model:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj.Anchored then
                        obj.CFrame = obj.CFrame + offset
                    end
                end
            end
        end)
    end

    if Znap_NoDamage then
        Znap_UnprotectVehicle(model)
    end

    Znap_RemovePlatform()
    Znap_Vehicle = nil
    Znap_SavedCFrame = nil
end

VehicleTab:Toggle({
    Title = 'Znap',
    Flag = 'ZnapCar',
    Icon = 'car',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        Znap_Enabled = Value

        if Value then
            if Znap_GetVehicle() then
                Znap_Down()
            end
        else
            if Znap_Vehicle then
                Znap_Up()
            end
        end
    end,
})

VehicleTab:Slider({
    Title = 'Znap Depth',
    Flag = 'ZnapDepth',
    Step = 1,
    Value = {
        Min = 5,
        Max = 100,
        Default = 60,
    },
    Callback = function(Value)
        local depth = tonumber(Value)
        if depth then
            Znap_Depth = math.clamp(depth, 5, 100)

            -- Si Znap ya está activo, aplica inmediatamente la nueva profundidad.
            if Znap_Enabled and Znap_Vehicle then
                local model = Znap_Vehicle
                local primary = Znap_GetPrimary(model)

                if primary then
                    local newPos = primary.Position - Vector3.new(0, Znap_Depth, 0)

                    pcall(function()
                        if model.PrimaryPart then
                            model:SetPrimaryPartCFrame(CFrame.new(newPos))
                        else
                            local offset = newPos - primary.Position
                            for _, obj in ipairs(model:GetDescendants()) do
                                if obj:IsA('BasePart') and not obj.Anchored then
                                    obj.CFrame = obj.CFrame + offset
                                end
                            end
                        end
                    end)

                    Znap_CreatePlatform(Vector3.new(
                        newPos.X,
                        newPos.Y - Znap_PlatformYOffset,
                        newPos.Z
                    ))
                end
            end
        end
    end,
})

task.spawn(function()
    while task.wait(0.15) do
        if Znap_Enabled then
            local vehicle = Znap_GetVehicle()

            if vehicle then
                if Znap_Vehicle ~= vehicle then
                    if Znap_Vehicle then
                        Znap_Up()
                    end
                    Znap_Down()
                end
            elseif Znap_Vehicle then
                Znap_Up()
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if Znap_Vehicle then
        Znap_Up()
    end
end)

-- ==========================================
-- FIN ZNAP CARRO
-- ==========================================

-- ==========================================
-- VISUAL TAB | Names, Studs y Health Bar
-- Basado en message (9) (2).txt
-- ==========================================
end

do
local VisualTab = Window:Tab({
    Title = 'VISUAL',
    Icon = 'eye',
})

local VisualPlayers = game:GetService('Players')
local VisualRunService = game:GetService('RunService')
local VisualLocalPlayer = VisualPlayers.LocalPlayer
local VisualCamera = workspace.CurrentCamera

local VisualConfig = {
    MaxDistance = 500,
    BarWidth = 4,
    BarOffset = 8,
    ShowName = true,
    ShowDistance = true,
    ShowHealthBar = true,
    TeamCheck = false,
    UseTeamColor = false,
}

local COLOR_GREEN = Color3.fromRGB(0, 255, 0)
local COLOR_YELLOW = Color3.fromRGB(255, 255, 0)
local COLOR_RED = Color3.fromRGB(255, 0, 0)
local COLOR_BG = Color3.fromRGB(0, 0, 0)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)

local VisualScreenGui = Instance.new('ScreenGui')
VisualScreenGui.Name = 'HealthESP'
VisualScreenGui.ResetOnSpawn = false
VisualScreenGui.IgnoreGuiInset = true
VisualScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    VisualScreenGui.Parent = (gethui and gethui()) or VisualLocalPlayer:WaitForChild('PlayerGui')
end)
if not VisualScreenGui.Parent then
    VisualScreenGui.Parent = VisualLocalPlayer:WaitForChild('PlayerGui')
end

local visualEspCache = {}

local function VisualLerpColor(c1, c2, t)
    return Color3.new(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end

local function VisualGetHealthColor(hp)
    hp = math.clamp(hp, 0, 1)
    if hp >= 0.5 then
        return VisualLerpColor(COLOR_YELLOW, COLOR_GREEN, (hp - 0.5) * 2)
    end
    return VisualLerpColor(COLOR_RED, COLOR_YELLOW, hp * 2)
end

local function VisualCreateESP(plr)
    if plr == VisualLocalPlayer or visualEspCache[plr] then return end

    local container = Instance.new('Frame')
    container.Name = 'ESP_' .. plr.Name
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Size = UDim2.fromOffset(0, 0)
    container.Visible = false
    container.Parent = VisualScreenGui

    local nameLabel = Instance.new('TextLabel')
    nameLabel.Name = 'NameLabel'
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.fromOffset(140, 16)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = COLOR_TEXT
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Text = plr.Name
    nameLabel.Parent = container

    local distLabel = Instance.new('TextLabel')
    distLabel.Name = 'DistLabel'
    distLabel.BackgroundTransparency = 1
    distLabel.Size = UDim2.fromOffset(140, 14)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 11
    distLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distLabel.Text = '[0 studs]'
    distLabel.Parent = container

    local barBg = Instance.new('Frame')
    barBg.Name = 'BarBg'
    barBg.BackgroundColor3 = COLOR_BG
    barBg.BorderSizePixel = 0
    barBg.Parent = container

    local stroke = Instance.new('UIStroke')
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 1
    stroke.Parent = barBg

    local barFill = Instance.new('Frame')
    barFill.Name = 'BarFill'
    barFill.BackgroundColor3 = COLOR_GREEN
    barFill.BorderSizePixel = 0
    barFill.Size = UDim2.new(1, 0, 1, 0)
    barFill.AnchorPoint = Vector2.new(0, 1)
    barFill.Position = UDim2.new(0, 0, 1, 0)
    barFill.Parent = barBg

    visualEspCache[plr] = {
        container = container,
        nameLabel = nameLabel,
        distLabel = distLabel,
        barBg = barBg,
        barFill = barFill,
    }
end

local function VisualRemoveESP(plr)
    local data = visualEspCache[plr]
    if data and data.container then
        data.container:Destroy()
    end
    visualEspCache[plr] = nil
end

local function VisualIsTeammate(plr)
    if not VisualConfig.TeamCheck then return false end
    if not plr.Team or not VisualLocalPlayer.Team then return false end
    return plr.Team == VisualLocalPlayer.Team
end

local function VisualUpdateESP()
    VisualCamera = workspace.CurrentCamera or VisualCamera
    if not VisualCamera then return end

    for plr, data in pairs(visualEspCache) do
        local char = plr.Character
        local root = char and char:FindFirstChild('HumanoidRootPart')
        local humanoid = char and char:FindFirstChildOfClass('Humanoid')

        if not root or not humanoid or humanoid.Health <= 0 or VisualIsTeammate(plr) then
            data.container.Visible = false
            continue
        end

        local distance = (VisualCamera.CFrame.Position - root.Position).Magnitude
        if distance > VisualConfig.MaxDistance then
            data.container.Visible = false
            continue
        end

        local screenPos, onScreen = VisualCamera:WorldToViewportPoint(root.Position)
        if not onScreen or screenPos.Z <= 0 then
            data.container.Visible = false
            continue
        end

        local head = char:FindFirstChild('Head')
        local charHeight = 40
        if head then
            local topPos = VisualCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
            local botPos = VisualCamera:WorldToViewportPoint(root.Position - Vector3.new(0, 2.5, 0))
            charHeight = math.clamp(math.abs(botPos.Y - topPos.Y), 20, 400)
        end

        local barHeight = charHeight
        local barWidth = VisualConfig.BarWidth
        data.container.Visible = true
        data.container.Position = UDim2.fromOffset(screenPos.X, screenPos.Y)

        data.barBg.Visible = VisualConfig.ShowHealthBar
        data.barBg.Size = UDim2.new(0, barWidth, 0, barHeight)
        data.barBg.Position = UDim2.new(0, -barWidth - VisualConfig.BarOffset, 0.5, -barHeight / 2)

        local hpPercent = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        data.barFill.Size = UDim2.new(1, 0, hpPercent, 0)
        data.barFill.BackgroundColor3 = VisualGetHealthColor(hpPercent)

        data.nameLabel.Visible = VisualConfig.ShowName
        if VisualConfig.ShowName then
            data.nameLabel.Text = plr.Name
            if IgnoreLineLockPlayer and plr.Name == SelectedLineLockPlayer then
                data.nameLabel.TextColor3 = Color3.fromRGB(50, 255, 90)
            else
                data.nameLabel.TextColor3 = (VisualConfig.UseTeamColor and plr.Team)
                    and plr.Team.TeamColor.Color or COLOR_TEXT
            end
            data.nameLabel.Position = UDim2.new(0.5, -70, 0, -barHeight / 2 - 30)
        end

        data.distLabel.Visible = VisualConfig.ShowDistance
        if VisualConfig.ShowDistance then
            data.distLabel.Text = string.format('[%d studs]', math.floor(distance))
            data.distLabel.Position = UDim2.new(0.5, -70, 0, -barHeight / 2 - (VisualConfig.ShowName and 15 or 28))
        end
    end
end

for _, plr in ipairs(VisualPlayers:GetPlayers()) do
    VisualCreateESP(plr)
end
VisualPlayers.PlayerAdded:Connect(function(plr)
    VisualCreateESP(plr)
end)
VisualPlayers.PlayerRemoving:Connect(VisualRemoveESP)
VisualRunService.RenderStepped:Connect(VisualUpdateESP)

VisualTab:Section({Title = 'PLAYER ESP'})
VisualTab:Toggle({
    Title = 'Names',
    Flag = 'visual_names',
    Icon = 'user-round',
    Type = 'Checkbox',
    Value = true,
    Callback = function(value)
        VisualConfig.ShowName = value == true
    end,
})
VisualTab:Toggle({
    Title = 'Studs',
    Flag = 'visual_studs',
    Icon = 'ruler',
    Type = 'Checkbox',
    Value = true,
    Callback = function(value)
        VisualConfig.ShowDistance = value == true
    end,
})
VisualTab:Toggle({
    Title = 'Health Bar',
    Flag = 'visual_health_bar',
    Icon = 'heart-pulse',
    Type = 'Checkbox',
    Value = true,
    Callback = function(value)
        VisualConfig.ShowHealthBar = value == true
    end,
})


-- ==========================================
-- DROP ITEM ESP | En pestaña Visual
-- ==========================================
local VisualDroppedItemsEnabled = false
local VisualDroppedItemsDrawings = {}
local VisualDroppedItemsFolder = workspace:FindFirstChild("DroppedItems")

local function VisualDroppedItemColor(model)
    -- Algunos objetos guardan la rareza como Rarity y otros como RarityName.
    local rarity = model:GetAttribute("RarityName") or model:GetAttribute("Rarity")

    -- Si el modelo del objeto no trae el atributo, buscarlo en los datos del juego.
    if not rarity then
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local itemsFolder = replicatedStorage:FindFirstChild("Items")
        if itemsFolder then
            for _, itemData in ipairs(itemsFolder:GetDescendants()) do
                if itemData.Name == model.Name then
                    rarity = itemData:GetAttribute("RarityName") or itemData:GetAttribute("Rarity")
                    if rarity then break end
                end
            end
        end
    end

    rarity = string.lower(tostring(rarity or "common")):gsub("%s+", " ")
    local colors = {
        ["basic"] = Color3.fromRGB(165, 165, 165),
        ["grey"] = Color3.fromRGB(165, 165, 165),
        ["gray"] = Color3.fromRGB(165, 165, 165),
        ["common"] = Color3.fromRGB(165, 165, 165),
        ["común"] = Color3.fromRGB(165, 165, 165),
        ["comun"] = Color3.fromRGB(165, 165, 165),
        ["uncommon"] = Color3.fromRGB(50, 230, 80),
        ["poco común"] = Color3.fromRGB(50, 230, 80),
        ["poco comun"] = Color3.fromRGB(50, 230, 80),
        ["green"] = Color3.fromRGB(50, 230, 80),
        ["rare"] = Color3.fromRGB(45, 145, 255),
        ["raro"] = Color3.fromRGB(45, 145, 255),
        ["blue"] = Color3.fromRGB(45, 145, 255),
        ["epic"] = Color3.fromRGB(190, 75, 255),
        ["épico"] = Color3.fromRGB(190, 75, 255),
        ["epico"] = Color3.fromRGB(190, 75, 255),
        ["purple"] = Color3.fromRGB(190, 75, 255),
        ["legendary"] = Color3.fromRGB(255, 195, 35),
        ["legendario"] = Color3.fromRGB(255, 195, 35),
        ["gold"] = Color3.fromRGB(255, 195, 35),
        ["yellow"] = Color3.fromRGB(255, 195, 35),
        ["mythic"] = Color3.fromRGB(255, 45, 55),
        ["mítico"] = Color3.fromRGB(255, 45, 55),
        ["mitico"] = Color3.fromRGB(255, 45, 55),
        ["red"] = Color3.fromRGB(255, 45, 55),
        -- Alias de versiones anteriores del juego
        ["omega"] = Color3.fromRGB(255, 45, 55),
    }
    return colors[rarity] or Color3.fromRGB(165, 165, 165)
end

local function VisualRemoveDroppedItem(model)
    local drawings = VisualDroppedItemsDrawings[model]
    if drawings then
        for _, drawing in pairs(drawings) do
            pcall(function()
                drawing.Visible = false
                drawing:Remove()
            end)
        end
        VisualDroppedItemsDrawings[model] = nil
    end
end

local function VisualHideDroppedItems()
    for model, drawings in pairs(VisualDroppedItemsDrawings) do
        for _, drawing in pairs(drawings) do
            pcall(function() drawing.Visible = false end)
        end
        if not model.Parent then
            VisualRemoveDroppedItem(model)
        end
    end
end

local function VisualCreateDroppedItemDrawings(model)
    if VisualDroppedItemsDrawings[model] then
        return VisualDroppedItemsDrawings[model]
    end
    if not Drawing or not Drawing.new then return nil end

    local ok, drawings = pcall(function()
        local result = {
            Circle = Drawing.new("Circle"),
            Inner = Drawing.new("Circle"),
            Name = Drawing.new("Text"),
            Amount = Drawing.new("Text"),
        }
        result.Circle.Thickness = 2
        result.Circle.Transparency = 0.7
        result.Circle.Filled = false
        result.Inner.Thickness = 2
        result.Inner.Transparency = 1
        result.Inner.Filled = true
        result.Name.Outline = true
        result.Name.OutlineColor = Color3.new(0, 0, 0)
        result.Name.Center = true
        result.Name.Size = 16
        result.Name.Font = 4
        result.Amount.Outline = true
        result.Amount.OutlineColor = Color3.new(0, 0, 0)
        result.Amount.Center = true
        result.Amount.Size = 13
        result.Amount.Font = 4
        return result
    end)

    if ok then
        VisualDroppedItemsDrawings[model] = drawings
        return drawings
    end
    return nil
end

-- ==========================================
-- VISUAL TAB | INVENTORY VIEWER (ESP DE ÍTEMS DE JUGADORES)
-- Reemplaza la implementación anterior y conserva la opción en su posición.
-- ==========================================
local InventoryViewerEnabled = false
local InventoryViewerBillboards = {}
local InventoryViewerRarityColors = {
    Common = Color3.fromRGB(255, 255, 255),
    Uncommon = Color3.fromRGB(99, 255, 52),
    Rare = Color3.fromRGB(51, 170, 255),
    Epic = Color3.fromRGB(237, 44, 255),
    Legendary = Color3.fromRGB(255, 150, 0),
    Omega = Color3.fromRGB(255, 20, 51),
}
local InventoryViewerItemDB = {}
local InventoryViewerItemsFolder = ReplicatedStorage:FindFirstChild("Items")
local InventoryViewerDefaultImage = "rbxassetid://7072725737"

local function InventoryViewerBuildKey(tool)
    local handle = tool:FindFirstChild("Handle")
    local displayName = tool:GetAttribute("DisplayName") or tool.Name
    local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
    local rarity = tool:GetAttribute("RarityName") or "Common"
    if handle then
        local mesh = handle:FindFirstChildOfClass("SpecialMesh")
        if mesh and mesh.MeshId ~= "" then
            return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
        elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
            return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
        end
    end
    if itemId and itemId ~= "" and itemId ~= tool.Name then
        return "ITEMID_" .. itemId .. "_RARITY_" .. rarity
    end
    return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
end

local function InventoryViewerRegisterItems(folder)
    if not folder then return end
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") then
            local key = InventoryViewerBuildKey(item)
            InventoryViewerItemDB[key] = {
                Name = item:GetAttribute("DisplayName") or item.Name,
                Rarity = item:GetAttribute("RarityName") or "Common",
                ImageId = tostring(item:GetAttribute("ImageId") or InventoryViewerDefaultImage),
                ToolName = item.Name,
            }
        end
    end
end

if InventoryViewerItemsFolder then
    for _, category in ipairs({"gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish"}) do
        InventoryViewerRegisterItems(InventoryViewerItemsFolder:FindFirstChild(category))
    end
end

local function InventoryViewerGetInfo(tool)
    return InventoryViewerItemDB[InventoryViewerBuildKey(tool)]
end

local function InventoryViewerGetTools(player)
    local result, seen = {}, {}
    local function add(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Fists" and not seen[tool] then
                seen[tool] = true
                table.insert(result, tool)
            end
        end
    end
    add(player:FindFirstChild("Backpack"))
    add(player:FindFirstChild("StarterGear"))
    add(player.Character)
    return result
end

local function InventoryViewerRemove(player)
    local data = InventoryViewerBillboards[player]
    if data then
        if data.Gui then pcall(function() data.Gui:Destroy() end) end
        InventoryViewerBillboards[player] = nil
    end
end

local function InventoryViewerCreate(player)
    if not InventoryViewerEnabled or player == VisualLocalPlayer then
        InventoryViewerRemove(player)
        return
    end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        InventoryViewerRemove(player)
        return
    end

    local tools = InventoryViewerGetTools(player)
    local displayTools = {}
    for _, tool in ipairs(tools) do
        local info = InventoryViewerGetInfo(tool)
        if info then table.insert(displayTools, {Tool = tool, Info = info}) end
    end
    local shownCount = math.min(#displayTools, 6)
    if shownCount == 0 then
        InventoryViewerRemove(player)
        return
    end

    local signatureParts = {}
    for i = 1, shownCount do
        local entry = displayTools[i]
        table.insert(signatureParts, entry.Tool.Name .. "|" .. tostring(entry.Info.ImageId) .. "|" .. tostring(entry.Info.Rarity))
    end
    local signature = table.concat(signatureParts, ";") .. "|total:" .. tostring(#displayTools)
    local existing = InventoryViewerBillboards[player]
    if existing and existing.Gui and existing.Gui.Parent and existing.Root == root and existing.Signature == signature then
        return
    end
    InventoryViewerRemove(player)

    local gui = Instance.new("BillboardGui")
    gui.Name = "InventoryESP_" .. player.Name
    gui.Adornee = root
    gui.Size = UDim2.fromOffset(shownCount * 20 + 4 + (#displayTools > shownCount and 20 or 0), 20)
    -- Ubicarlo debajo del personaje para no tapar Names, Studs ni la barra de vida.
    gui.StudsOffsetWorldSpace = Vector3.new(0, -3.5, 0)
    gui.AlwaysOnTop = true
    gui.MaxDistance = 250
    gui.LightInfluence = 0
    gui.Parent = root

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = gui

    for i = 1, shownCount do
        local info = displayTools[i].Info
        local icon = Instance.new("ImageLabel")
        icon.Name = "ItemIcon" .. i
        icon.LayoutOrder = i
        icon.Size = UDim2.fromOffset(18, 18)
        icon.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
        icon.BackgroundTransparency = 0.1
        icon.BorderSizePixel = 0
        icon.Image = info.ImageId or InventoryViewerDefaultImage
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = gui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = icon
        local stroke = Instance.new("UIStroke")
        stroke.Color = InventoryViewerRarityColors[info.Rarity] or Color3.new(1, 1, 1)
        stroke.Thickness = 2
        stroke.Parent = icon
    end

    if #displayTools > shownCount then
        local more = Instance.new("TextLabel")
        more.Name = "MoreItems"
        more.LayoutOrder = shownCount + 1
        more.Size = UDim2.fromOffset(18, 18)
        more.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        more.BackgroundTransparency = 0.08
        more.BorderSizePixel = 0
        more.Text = "+" .. tostring(#displayTools - shownCount)
        more.TextColor3 = Color3.new(1, 1, 1)
        more.TextSize = 10
        more.Font = Enum.Font.GothamBold
        more.Parent = gui
    end
    InventoryViewerBillboards[player] = {Gui = gui, Root = root, Signature = signature}
end

local function InventoryViewerRefreshAll()
    for _, player in ipairs(VisualPlayers:GetPlayers()) do
        if player ~= VisualLocalPlayer then InventoryViewerCreate(player) end
    end
end

VisualTab:Section({Title = "ESP"})
VisualTab:Toggle({
    Title = "Inventory Viewer",
    Flag = "visual_inventory_viewer_players",
    Icon = "backpack",
    Type = "Checkbox",
    Value = false,
    Callback = function(value)
        InventoryViewerEnabled = value == true
        if not InventoryViewerEnabled then
            for player in pairs(InventoryViewerBillboards) do
                InventoryViewerRemove(player)
            end
        else
            InventoryViewerRefreshAll()
        end
    end,
})

VisualPlayers.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.6)
        if InventoryViewerEnabled then InventoryViewerCreate(player) end
    end)
end)
VisualPlayers.PlayerRemoving:Connect(InventoryViewerRemove)

-- Actualiza periódicamente sin reconstruir los iconos si el inventario no cambió.
task.spawn(function()
    while task.wait(1.25) do
        if InventoryViewerEnabled then InventoryViewerRefreshAll() end
    end
end)

VisualTab:Section({Title = "DROP ITEM ESP"})
VisualTab:Toggle({
    Title = "Drop Item",
    Flag = "visual_drop_item",
    Icon = "package",
    Type = "Checkbox",
    Value = false,
    Callback = function(value)
        VisualDroppedItemsEnabled = value == true
        if not VisualDroppedItemsEnabled then
            VisualHideDroppedItems()
        end
    end,
})

VisualRunService.RenderStepped:Connect(function()
    if not VisualDroppedItemsEnabled then
        VisualHideDroppedItems()
        return
    end

    if not VisualDroppedItemsFolder or not VisualDroppedItemsFolder.Parent then
        VisualDroppedItemsFolder = workspace:FindFirstChild("DroppedItems")
    end
    if not VisualDroppedItemsFolder then
        VisualHideDroppedItems()
        return
    end

    for model, drawings in pairs(VisualDroppedItemsDrawings) do
        if not model.Parent then
            VisualRemoveDroppedItem(model)
        else
            for _, drawing in pairs(drawings) do
                pcall(function() drawing.Visible = false end)
            end
        end
    end

    local camera = workspace.CurrentCamera or VisualCamera
    if not camera then return end

    for _, model in ipairs(VisualDroppedItemsFolder:GetChildren()) do
        local pickupZone = model:IsA("Model") and model:FindFirstChild("PickUpZone")
        if pickupZone and pickupZone:IsA("BasePart") and not model:GetAttribute("Locked") then
            local screenPos, onScreen = camera:WorldToViewportPoint(pickupZone.Position)
            if onScreen and screenPos.Z > 0 then
                local drawings = VisualCreateDroppedItemDrawings(model)
                if drawings then
                    local color = VisualDroppedItemColor(model)
                    local radius = math.clamp(140 / math.max(screenPos.Z, 0.1), 5, 9)

                    drawings.Circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                    drawings.Circle.Radius = radius + 7
                    drawings.Circle.Color = color
                    drawings.Circle.Visible = true

                    drawings.Inner.Position = Vector2.new(screenPos.X, screenPos.Y)
                    drawings.Inner.Radius = radius + 2
                    drawings.Inner.Color = color
                    drawings.Inner.Visible = true

                    drawings.Name.Position = Vector2.new(screenPos.X, screenPos.Y - radius - 22)
                    drawings.Name.Text = model.Name
                    drawings.Name.Color = color
                    drawings.Name.Visible = true

                    local amount = tonumber(model:GetAttribute("Amount")) or 1
                    drawings.Amount.Position = Vector2.new(screenPos.X, screenPos.Y + radius + 17)
                    drawings.Amount.Text = amount > 1 and ("[" .. tostring(amount) .. "]") or ""
                    drawings.Amount.Color = Color3.fromRGB(220, 220, 220)
                    drawings.Amount.Visible = amount > 1
                end
            end
        end
    end
end)


-- ============================================================================
--   MÓDULO DE AUTO MINIGAME / AUTO-REFLEJOS PARA TRABAJOS DE BLOCKSPIN
-- ============================================================================

local AutoMinigame_Players = game:GetService("Players")
local AutoMinigame_LocalPlayer = AutoMinigame_Players.LocalPlayer or AutoMinigame_Players.PlayerAdded:Wait()

-- Configuración independiente del script
local AutoMinigameConfig = {
    Activo = false,         -- Inicia desactivado; se activa con la palomita
    IntervaloEscaneo = 0.1, -- Cada cuántos segundos revisa la pantalla
    BypassDelay = 0.02,    -- Pequeño retraso para que el servidor no sospeche de clicks instantáneos de 0ms
}

-- Lista de interfaces comunes de minijuegos en BlockSpin (Pesca, Hamburguesas, ATMs)
local NombresMinijuegos = {
    "MinigameGui", 
    "FishingMinigame", 
    "JobMinigame", 
    "BarMinigame", 
    "ClickCircle"
}

-- Función auxiliar que busca si la ventana del minijuego está abierta en la pantalla
local function buscarMinigameActivo(playerGui)
    for _, nombre in ipairs(NombresMinijuegos) do
        local gui = playerGui:FindFirstChild(nombre)
        -- Si la interfaz existe y está visible para el jugador, la procesamos
        if gui and (gui:IsA("ScreenGui") or gui:IsA("BillboardGui")) and gui.Enabled then
            return gui
        end
    end
    return nil
end

-- Función auxiliar para simular clicks de manera segura y compatible con todos los ejecutores
local function fireButtonClick(button)
    if not button then return end
    pcall(function()
        if firesignal then
            firesignal(button.MouseButton1Click)
        end
    end)
    pcall(function()
        if getconnections then
            for _, conexion in ipairs(getconnections(button.MouseButton1Click)) do
                if conexion.Fire then
                    conexion:Fire()
                elseif conexion.Function then
                    conexion.Function()
                end
            end
        end
    end)
end

-- Función principal que simula la resolución del juego de reflejos
local function resolverMinigame(gui)
    pcall(function()
        -- 1. DETECCIÓN DE PESCA O REFLEJOS EN CÍRCULO (Presionar cuando la barra entra al área verde)
        local bar = gui:FindFirstChild("Bar", true) or gui:FindFirstChild("Indicator", true)
        local targetArea = gui:FindFirstChild("GreenZone", true) or gui:FindFirstChild("Target", true)
        
        if bar and targetArea then
            -- Forzamos matemáticamente la posición de la barra indicadora directo al centro de la zona verde
            bar.Position = targetArea.Position
            task.wait(AutoMinigameConfig.BypassDelay)
            
            -- Buscamos el botón de interacción (Click/Space) y activamos su evento de click remoto
            local botonLector = gui:FindFirstChild("ClickButton", true) or gui:FindFirstChild("Interact", true)
            if botonLector and botonLector:IsA("GuiButton") then
                fireButtonClick(botonLector)
            end
            return
        end

        -- 2. DETECCIÓN DE QUICK TIME EVENTS (Presionar botones o letras rápido)
        local botonRapido = gui:FindFirstChild("TapButton", true) or gui:FindFirstChild("HitBox", true)
        local isQuickValid = false
        if botonRapido then
            pcall(function()
                if botonRapido:IsA("GuiButton") then
                    isQuickValid = true
                elseif botonRapido:IsA("GuiObject") and botonRapido.Visible then
                    isQuickValid = true
                end
            end)
        end
        if botonRapido and isQuickValid then
            task.wait(AutoMinigameConfig.BypassDelay)
            fireButtonClick(botonRapido)
            return
        end
    end)
end

-- Bucle asíncrono permanente para el Auto-Farm automatizado
task.spawn(function()
    while true do
        task.wait(AutoMinigameConfig.IntervaloEscaneo)
        
        -- Si el módulo está apagado desde el menú, saltar ciclo
        if not AutoMinigameConfig.Activo then continue end
        
        local character = AutoMinigame_LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local playerGui = AutoMinigame_LocalPlayer:FindFirstChildOfClass("PlayerGui")
        
        -- Asegurar que el jugador está vivo y la interfaz cargada
        if humanoid and humanoid.Health > 0 and playerGui then
            local minigameAbierto = buscarMinigameActivo(playerGui)
            
            if minigameAbierto then
                -- Resolver el trabajo de forma inmediata y perfecta
                resolverMinigame(minigameAbierto)
            end
        end
    end
end)

print("[+] Módulo Auto Minigame cargado. Borde perfecto configurado en " .. tostring(AutoMinigameConfig.BypassDelay) .. "s de delay.")

end

do
local MinigameTab = Window:Tab({
    Title = 'MINIGAME',
    Icon = 'sprout',
})

MinigameTab:Section({
    Title = 'AUTO MINIGAME',
})

MinigameTab:Toggle({
    Title = 'Auto Minigame',
    Desc = 'Auto solves fishing, job & ATM minigames (BlockSpin)',
    Flag = 'AutoMinigame',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        AutoMinigameConfig.Activo = Value == true
    end,
})

MinigameTab:Slider({
    Title = 'Bypass Delay',
    Desc = 'Anti-detection delay before clicking',
    Flag = 'MinigameBypassDelay',
    Step = 0.01,
    Value = {
        Min = 0.01,
        Max = 0.2,
        Default = 0.02,
    },
    Callback = function(Value)
        AutoMinigameConfig.BypassDelay = tonumber(Value) or 0.02
    end,
})

MinigameTab:Slider({
    Title = 'Scan Interval',
    Desc = 'Screen check frequency (seconds)',
    Flag = 'MinigameScanInterval',
    Step = 0.05,
    Value = {
        Min = 0.05,
        Max = 1.0,
        Default = 0.1,
    },
    Callback = function(Value)
        AutoMinigameConfig.IntervaloEscaneo = tonumber(Value) or 0.1
    end,
})


end

do
local MiscTab = Window:Tab({
    Title = 'MISC',
    Icon = 'package-search',
})

MiscTab:Toggle({
    Title = 'Skip Animation',
    Flag = 'skip_anim',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        Window.EnabledSkip = Value

        if Window.EnabledSkip then
            task.spawn(function()
                while Window.EnabledSkip do
                    for _, crate in pairs(CrateController.class.objects)do
                        crate.states.open.set(true)
                        CrateController.skipping.set(true)
                    end

                    task.wait(0.05)
                end
            end)
        end
    end,
})
MiscTab:Toggle({
    Title = 'Infinite Hotbar',
    Flag = 'infhotbar',
    Icon = 'check',
    Type = 'Checkbox',
    Callback = function(Value)
        if not Value then
            return
        end

        for _, v in pairs(getgc(true))do
            if type(v) == 'function' then
                local info = debug.getinfo(v)

                if info.name == 'get_max_items' then
                    hookfunction(v, function(...)
                        return 999
                    end)
                end
            end
        end
    end,
})
MiscTab:Button({
    Title = 'Claim All Quest',
    Callback = function()
        local Net = require(game.ReplicatedStorage.Modules.Core.Net)
        local QuestsData = require(game.ReplicatedStorage.Modules.Game.Quests.QuestsData)
        local Data = require(game.ReplicatedStorage.Modules.Core.Data)

        for questID, _ in pairs(QuestsData.list)do
            local playerQuestData = Data.active_quests[questID]

            if playerQuestData and playerQuestData.completed and not playerQuestData.claimed then
                Net.get('claim_quest', questID)
            end
        end
    end,
})
MiscTab:Section({
    Title = 'Crate:',
})

Window.selectedAmmoCrate = 'Pistol'

MiscTab:Dropdown({
    Title = 'Select Ammo Crate',
    Values = {
        'Pistol',
        'Rifle',
        'Shotgun',
        'Special',
    },
    Default = 'Pistol',
    Callback = function(Value)
        Window.selectedAmmoCrate = Value
    end,
})
MiscTab:Button({
    Title = 'Open Selected Ammo Crate',
    Callback = function()
        local crate = workspace:WaitForChild('Map'):WaitForChild('Tiles'):WaitForChild('GunShopTile'):WaitForChild('PatriotWeapons'):WaitForChild('Interior'):WaitForChild('Crates'):WaitForChild('Ammo Crate'):WaitForChild('CrateOptions'):WaitForChild(Window.selectedAmmoCrate)

        Net.get('open_crate', crate, 'money')
    end,
})
MiscTab:Divider()

Window.selectedWeaponCrate = 'Basic'

MiscTab:Dropdown({
    Title = 'Select Weapon Crate',
    Values = {
        'Basic',
        'Advanced',
        'Superior',
        'Elite',
        'Legendary',
    },
    Default = 'Basic',
    Callback = function(Value)
        Window.selectedWeaponCrate = Value
    end,
})
MiscTab:Button({
    Title = 'Open Selected Weapon Crate',
    Callback = function()
        local crate = workspace:WaitForChild('Map'):WaitForChild('Tiles'):WaitForChild('GunShopTile'):WaitForChild('PatriotWeapons'):WaitForChild('Interior'):WaitForChild('Crates'):WaitForChild('Weapon Crate'):WaitForChild('CrateOptions'):WaitForChild(Window.selectedWeaponCrate)

        Net.get('open_crate', crate, 'money')
    end,
})
MiscTab:Divider()

Window.selectedCarCrate = 'Basic'

MiscTab:Dropdown({
    Title = 'Select Car Crate',
    Values = {
        'Basic',
        'Rare',
        'Elite',
        'Omega',
    },
    Default = 'Basic',
    Callback = function(Value)
        Window.selectedCarCrate = Value
    end,
})
MiscTab:Button({
    Title = 'Open Selected Car Crate',
    Callback = function()
        local crate = workspace:WaitForChild('Map'):WaitForChild('Tiles'):WaitForChild('PrestigeDealerAndHousing'):WaitForChild('PrestigeCarDealer'):WaitForChild('Interior'):WaitForChild('Crates'):WaitForChild('Car Crate'):WaitForChild('CrateOptions'):WaitForChild(Window.selectedCarCrate)

        Net.get('open_crate', crate, 'money')
    end,
})

end

do
local GraphicsTab = Window:Tab({
    Title = 'GRAPHICS',
    Icon = 'monitor-cog',
})

GraphicsTab:Button({
    Title = 'BoostFps',
    Desc = 'SuperVeryUltraLowPotato Graphic',
    Icon = 'rocket',
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://pastefy.app/Pmu7jqMe/raw'))()
    end,
})

local WhiteScreenEnabled = false

GraphicsTab:Toggle({
    Title = 'White Screen',
    Flag = 'white_screen',
    Desc = '<<<3',
    Locked = false,
    Callback = function(Value)
        WhiteScreenEnabled = Value

        local RunService = game:GetService('RunService')

        RunService:Set3dRenderingEnabled(not WhiteScreenEnabled)
    end,
})

end

do
local ServerTab = Window:Tab({
    Title = 'SERVER',
    Icon = 'server',
})

ServerTab:Section({
    Title = 'SERVER INFORMATION',
})
ServerTab:Code({
    Title = 'Current Server',
    Code = ' ' .. (game.JobId or 'Unknown'),
})
ServerTab:Divider()
ServerTab:Section({
    Title = 'SERVER UTILITIES',
})
ServerTab:Input({
    Title = 'Enter Server Code',
    Placeholder = 'Paste server JobId here...',
    Callback = function(Value)
        Window.ServerCode = Value
    end,
})
ServerTab:Button({
    Title = 'Join by Code',
    Icon = 'log-in',
    Callback = function()
        if not Window.ServerCode or Window.ServerCode == '' then
            warn('\u{e43}\u{e2a}\u{e48}code\u{e14}\u{e34}\u{e19}\u{e49}\u{e2d}\u{e07}')

            return
        end

        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, Window.ServerCode, game.Players.LocalPlayer)
    end,
})
ServerTab:Button({
    Title = 'Rejoin Current Server',
    Icon = 'refresh-ccw',
    Callback = function()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end,
})
ServerTab:Button({
    Title = 'Hop Server (Lowest Player)',
    Icon = 'shuffle',
    Callback = function()
        local data = game:GetService('HttpService'):JSONDecode(game:HttpGet(string.format('https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100', game.PlaceId)))

        if data and data.data then
            local servers = {}

            for _, v in pairs(data.data)do
                if v.playing < v.maxPlayers then
                    table.insert(servers, v.id)
                end
            end

            if #servers > 0 then
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
            end
        end
    end,
})

end

do
local ConfigTab = Window:Tab({
    Title = 'CONFIG',
    Icon = 'file-text',
})

ConfigTab:Section({
    Title = 'CONFIGURATION MANAGER',
})
ConfigTab:Input({
    Title = 'Config Name',
    Placeholder = 'Enter config name...',
    Callback = function(value)
        Window.ConfigName = value
    end,
})
ConfigTab:Button({
    Title = 'Save Configuration',
    Icon = 'file-text',
    Callback = function()
        if Window.ConfigName and Window.ConfigName ~= '' then
            Window.ConfigManager:CreateConfig(Window.ConfigName):Save()
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Saved: ' .. Window.ConfigName,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Please enter config name!',
                Duration = 2,
            })
        end
    end,
})
ConfigTab:Button({
    Title = 'Load Config',
    Icon = 'folder-open',
    Callback = function()
        if Window.ConfigName and Window.ConfigName ~= '' then
            Window.ConfigManager:CreateConfig(Window.ConfigName):Load()
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Loaded: ' .. Window.ConfigName,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Please enter config name!',
                Duration = 2,
            })
        end
    end,
})
ConfigTab:Button({
    Title = 'Delete Config',
    Icon = 'trash-2',
    Callback = function()
        if Window.ConfigName and Window.ConfigName ~= '' then
            Window.ConfigManager:CreateConfig(Window.ConfigName):Delete()
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Deleted: ' .. Window.ConfigName,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Please enter config name!',
                Duration = 2,
            })
        end
    end,
})
end

task.wait(0.1)

local RS = game:GetService('ReplicatedStorage')

pcall(function()
    local Util = require(RS.Modules.Core.Util)

    if Util.tween then
        local old_tween = Util.tween

        Util.tween = function(instance, tweenInfo, properties, ...)
            if instance:IsA('NumberValue') and properties.Value == 1 and tweenInfo.Time > 0.1 then
                tweenInfo = TweenInfo.new(0.1, tweenInfo.EasingStyle, tweenInfo.EasingDirection, tweenInfo.RepeatCount, tweenInfo.Reverses, tweenInfo.DelayTime)
            end

            return old_tween(instance, tweenInfo, properties, ...)
        end
    end

    local BuyPromptUI = require(RS.Modules.Game.UI.BuyPromptUI)

    if BuyPromptUI.loaded then
        local old_loaded = BuyPromptUI.loaded

        BuyPromptUI.loaded = function(...)
            local result = old_loaded(...)

            task.spawn(function()
                task.wait(0.5)

                local UI = require(RS.Modules.Core.UI)
                local sellButton = UI.get('SellPromptSellButton')

                if sellButton and Util.tween then
                    Util.tween = function(instance, tweenInfo, properties, ...)
                        if instance:IsA('NumberValue') and properties.Value == 1 and tweenInfo.Time > 0 then
                            tweenInfo = TweenInfo.new(0, tweenInfo.EasingStyle, tweenInfo.EasingDirection, tweenInfo.RepeatCount, tweenInfo.Reverses, tweenInfo.DelayTime)
                        end

                        return old_tween(instance, tweenInfo, properties, ...)
                    end
                end
            end)

            return result
        end
    end
end)