-- ts file was generated at discord.gg/xf56dUZJze

local fenv = getfenv()

_G.MynxxInvisAuto = false
_G.MynxxAutoKickOnSteal = false
_G.MynxxAutoBuy = false

local _ = _G.MynxxStealMode

_G.MynxxStealMode = 'priority'

local _ = _G.MynxxAutoTP

_G.MynxxAutoTP = true

game:IsLoaded()

local _ = _G.MynxxPriVersion

_G.MynxxPriVersion = 0

local _ = _G.MynxxPriorityDefault

_G.MynxxPriorityDefault = {}

local _ = _G.SHARED_PRIORITY_ITEMS

_G.SHARED_PRIORITY_ITEMS = {}

local _ = _G.MynxxMutVersion

_G.MynxxMutVersion = 0

local _ = _G.MynxxMutationDefault

_G.MynxxMutationDefault = {
    [1] = 'Crystal',
    [2] = 'Phantom',
    [3] = 'Cyber',
    [4] = 'Rainbow',
    [5] = 'Divine',
    [6] = 'Cursed',
    [7] = 'Radioactive',
    [8] = 'Yinyang',
    [9] = 'Galaxy',
    [10] = 'Lava',
    [11] = 'Candy',
    [12] = 'Bloodrot',
    [13] = 'Diamond',
    [14] = 'Gold',
    [15] = 'Normal',
}

local _ = _G.SHARED_MUTATION_ITEMS

_G.SHARED_MUTATION_ITEMS = {}

local _ = fenv.LPH_OBFUSCATED

fenv.LPH_NO_VIRTUALIZE = function(...)
    return ...
end
fenv.LPH_JIT_MAX = function(...)
    return ...
end

local cyp8 = game:GetService('HttpService')
local cyp10 = game:GetService('TeleportService')
local cyp13 = cyp10:GetLocalPlayerTeleportData()
local _ = cyp13.SideTP
local _cyp13SideTP15 = cyp13.SideTP

type(_cyp13SideTP15)

for _16, _16_2 in pairs(_cyp13SideTP15) do end

_G._stealUserOff = false

local cyp18 = cyp8:JSONEncode({autoTp = true})

pcall(function()
    writefile('SideTP.json', cyp18)
end)

local cyp20 = game:GetService('Players')
local cyp22 = game:GetService('RunService')
local cyp24 = game:GetService('UserInputService')

game:GetService('ReplicatedStorage')

local _cyp20LocalPlayer27 = cyp20.LocalPlayer
local _ = cyp24.TouchEnabled

_G.MynxxIsMobile = true

local cyp30 = Color3.fromRGB(8, 12, 20)
local cyp32 = Color3.fromRGB(14, 20, 32)
local cyp34 = Color3.fromRGB(24, 32, 48)
local cyp36 = Color3.fromRGB(45, 130, 255)
local cyp38 = Color3.fromRGB(32, 40, 55)
local cyp40 = Color3.fromRGB(90, 170, 255)
local cyp42 = Color3.fromRGB(60, 80, 110)
local cyp44 = Color3.fromRGB(245, 248, 255)
local cyp46 = Color3.fromRGB(160, 175, 200)
local cyp48 = Color3.fromRGB(70, 150, 255)
local cyp50 = Color3.fromRGB(120, 190, 255)

_G.XyntrixUI = {
    bgBtnOff = cyp38,
    stroke = cyp40,
    bgBtnOn = cyp36,
    header = cyp50,
    strokeDim = cyp42,
    bgSoft = cyp32,
    bgBtn = cyp34,
    muted = cyp46,
    text = cyp44,
    bg = cyp30,
    accent = cyp48,
}
_G.XyntrixStylePanel = function(_51)
    _51:IsA('GuiObject')

    _51.BackgroundColor3 = cyp30
    _51.BackgroundTransparency = 0
    _51.BorderSizePixel = 0

    local cyp55 = _51:FindFirstChildOfClass('UICorner')
    local cyp57 = UDim.new(0, 14)

    cyp55.CornerRadius = cyp57

    local cyp59 = _51:FindFirstChildOfClass('UIStroke')

    cyp59.Color = cyp40
    cyp59.Thickness = 1.4
    cyp59.Transparency = 0.4
    cyp59.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    _51:FindFirstChild('_XynAccent')
    _51:FindFirstChild('_XynShadow')
end
_G.XyntrixStyleTitle = function(_66)
    _66.Font = Enum.Font.GothamBlack

    local _70, _70_2, _70_3 = math.max(_66.TextSize, 13)

    _66.TextSize = _70
    _66.TextColor3 = cyp44
    _66.TextStrokeTransparency = 0.7

    local cyp72 = Color3.fromRGB(0, 0, 0)

    _66.TextStrokeColor3 = cyp72

    _66:IsA('TextButton')

    _66.AutoButtonColor = false
    _66.BackgroundTransparency = 1
end
_G.XyntrixStyleBtn = function(_75, _75_2)
    _75:IsA('GuiButton')

    _75.BorderSizePixel = 0
    _75.Font = Enum.Font.GothamBold
    _75.TextColor3 = cyp44

    local _81, _81_2, _81_3 = math.clamp(_75.TextSize, 10, 13)

    _75.TextSize = _81

    local cyp83 = _75:FindFirstChildOfClass('UICorner')
    local cyp85 = UDim.new(0, 8)

    cyp83.CornerRadius = cyp85

    local _ = _75.BackgroundTransparency
end
_G.XyntrixPolish = function(_87)
    _87:GetAttribute('_XynPolished')
    _87:IsA('Frame')
    _87:IsA('GuiObject')

    _87.BackgroundColor3 = cyp30
    _87.BackgroundTransparency = 0
    _87.BorderSizePixel = 0

    local cyp95 = _87:FindFirstChildOfClass('UICorner')
    local cyp97 = UDim.new(0, 14)

    cyp95.CornerRadius = cyp97

    local cyp99 = _87:FindFirstChildOfClass('UIStroke')

    cyp99.Color = cyp40
    cyp99.Thickness = 1.4
    cyp99.Transparency = 0.4
    cyp99.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    _87:FindFirstChild('_XynAccent')
    _87:FindFirstChild('_XynShadow')
end
_G.MynxxCenterPanel = function(_106, _106_2, _106_3)
    _106:IsA('GuiObject')

    _106.BackgroundColor3 = cyp30
    _106.BackgroundTransparency = 0
    _106.BorderSizePixel = 0

    local cyp110 = _106:FindFirstChildOfClass('UICorner')
    local cyp112 = UDim.new(0, 14)

    cyp110.CornerRadius = cyp112

    local cyp114 = _106:FindFirstChildOfClass('UIStroke')

    cyp114.Color = cyp40
    cyp114.Thickness = 1.4
    cyp114.Transparency = 0.4
    cyp114.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    _106:FindFirstChild('_XynAccent')
    _106:FindFirstChild('_XynShadow')

    local _workspaceCurrentCamera121 = workspace.CurrentCamera
    local _ = _workspaceCurrentCamera121.ViewportSize.X
    local _ = _workspaceCurrentCamera121.ViewportSize.Y
    local cyp127 = Vector2.new(0.5, 0.5)

    _106.AnchorPoint = cyp127

    local cyp129 = UDim2.new(0.5, 0, 0.5, 0)

    _106.Position = cyp129

    _106:SetAttribute('_XynCentered', true)
end
_G.XyntrixDragStart = function(_132)
    return _132.Position.X.Offset, _132.Position.Y.Offset
end
_G.XyntrixDragTo = function(_139, _139_2, _139_3, _139_4, _139_5)
    _139:GetAttribute('_XynCentered')

    local cyp145 = Vector2.new(0.5, 0.5)

    _139.AnchorPoint = cyp145

    local cyp147 = UDim2.new(0.5, (_139_2 + _139_4), 0.5, (_139_3 + _139_5))

    _139.Position = cyp147
end

task.spawn(function()
    local cyp151 = gethui()
    local cyp153 = game:GetService('CoreGui')
    local cyp155 = game:GetService('Players')
    local cyp158 = cyp155.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp160 = cyp151:GetChildren()

    for _161, _161_2 in ipairs(cyp160)do
        _161_2:IsA('ScreenGui')

        local _ = _161_2.Name
    end

    local cyp166 = cyp153:GetChildren()

    for _167, _167_2 in ipairs(cyp166)do
        _167_2:IsA('ScreenGui')

        local _ = _167_2.Name
    end

    local cyp172 = cyp158:GetChildren()

    for _173, _173_2 in ipairs(cyp172)do
        _173_2:IsA('ScreenGui')

        local _ = _173_2.Name
    end

    task.wait(0.35)
end)

_G.XyntrixLogSteal = function() end
_G.XyntrixArmStealLog = function() end
_G.MynxxLog = function() end
_G.LogSteal = function() end

local cyp623 = game:GetService('ReplicatedStorage'):WaitForChild('Packages'):WaitForChild('Net')

type(require(cyp623))

local _ = game.JobId

_G.XenNet = {
    UnreliableRemoteEvent = function(_626, _626_2)
        type(_626_2)

        return nil
    end,
    RemoteEvent = function(_627, _627_2)
        type(_627_2)

        return nil
    end,
    RemoteFunction = function(_628, _628_2)
        type(_628_2)

        return nil
    end,
}
_G.XenGetRemote = function(_629, _629_2)
    type(_629)

    return nil
end
_G.Resolve = function(_630, _630_2)
    type(_630)

    return nil
end
_G.HashOf = function(_631)
    return nil
end
_G.NetSecret = function()
    return nil
end
_G.__secureGetRemote = function(_633, _633_2)
    type(_633_2)

    return nil
end

local cyp635 = Instance.new('RemoteEvent')

clonefunction(cyp635.FireServer)

_G.RawFire = function(_638, ...)
    type(_638)

    return false
end

local cyp652 = workspace:FindFirstChild('Plots')
if cyp652 then
    cyp652.ChildAdded:Connect(function() end)
    cyp652.ChildRemoved:Connect(function() end)
end

_G.__secureChans = function()
    _G.MynxxSyncDiag = 'Channel class not found'

    return nil
end
_G.MynxxSyncAll = function() end
_G.MynxxSyncGet = function(_664) end
_G.sProp = function(_665, _665_2) end
_G._mynxxRawCT = function(_666) end
_G._mynxxGen = function(_667, _667_2, _667_3) end

local _t668 = setmetatable({
    GetGeneration = function(_669, _669_2, _669_3, _669_4) end,
}, {
    __index = function(_670, _670_2) end,
})

_G._mynxxAnimShim = _t668
_G.Mynxx_GetPlotChannel = function(_671) end
_G.Mynxx_GetAllPlots = function() end
_G.Mynxx_GetPlotAnimalList = function(_673) end
_G.MynxxRawCT = function(_674) end
_G.MynxxGen = function(_675, _675_2, _675_3) end
_G.MynxxAnimShim = _t668
_G.stealthGet = function(_676) end
_G.SyncInt = {_cache = {}}

local cyp786 = cyp20:GetPlayers()

for _787, _787_2 in ipairs(cyp786)do
    local _ = _787_2 == _cyp20LocalPlayer27
    local _Character790 = _787_2.Character
    if _Character790 then
        local cyp792 = _Character790:GetDescendants()

        for _793, _793_2 in ipairs(cyp792)do
            if _793_2:IsA('BasePart') then
                _793_2.CanCollide = false
            end
        end
    end
end

cyp20.PlayerAdded:Connect(function(_808) end)

local cyp872 = game:GetService('Players')
local cyp874 = game:GetService('RunService')
local _cyp872LocalPlayer875 = cyp872.LocalPlayer
local cyp877 = _cyp872LocalPlayer875:WaitForChild('PlayerGui')
local cyp879 = game:HttpGet([[https://raw.githubusercontent.com/OpBrairnotV2/Ui_Library/refs/heads/main/Ui.lua]])

loadstring(cyp879)()

local cyp931 = game:GetService('UserInputService')
local _ = _G.TPVelocity

_G.TPVelocity = 400

local _ = _G.MynxxClimb

_G.MynxxClimb = 160

local _ = _G.MynxxCFrameSpeed

_G.MynxxCFrameSpeed = 450

local _ = _G.MynxxWalkSpeed

_G.MynxxWalkSpeed = 20

local _ = _G.LandingDelay

_G.LandingDelay = 0.1

local _ = _G.MynxxCloseSpeed

_G.MynxxCloseSpeed = 80

local cyp932 = gethui()

if cyp932:FindFirstChild('TPStealTestUI') then cyp932:FindFirstChild('TPStealTestUI'):Destroy() end
if cyp877:FindFirstChild('TPStealTestUI') then cyp877:FindFirstChild('TPStealTestUI'):Destroy() end

local cyp942 = Instance.new('ScreenGui')

cyp942.Name = 'TPStealTestUI'
cyp942.ResetOnSpawn = false
cyp942.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
cyp942.DisplayOrder = 999999
cyp942.IgnoreGuiInset = true
cyp942.Parent = cyp932

_G._stp_pos = {}

local cyp947 = Instance.new('Frame', cyp942)

cyp947.Name = 'Main'
cyp947.Active = true

local cyp949 = UDim2.fromOffset(250, 210)

cyp947.Size = cyp949

local cyp951 = Color3.fromRGB(12, 12, 12)

cyp947.BackgroundColor3 = cyp951
cyp947.BorderSizePixel = 0

local cyp953 = Instance.new('UICorner', cyp947)
local cyp955 = UDim.new(0, 10)

cyp953.CornerRadius = cyp955

cyp947.BackgroundColor3 = cyp30
cyp947.BackgroundTransparency = 0
cyp947.BorderSizePixel = 0

local cyp967 = Vector2.new(0.5, 0.5)

cyp947.AnchorPoint = cyp967

local cyp969 = UDim2.new(0.5, 0, 0.5, 0)

cyp947.Position = cyp969

cyp947:SetAttribute('_XynCentered', true)

local cyp973 = Instance.new('TextButton', cyp947)
local cyp975 = UDim2.new(1, 0, 0, 30)

cyp973.Size = cyp975
cyp973.BackgroundTransparency = 1
cyp973.Text = 'Xyntrix · Teleport'
cyp973.Font = Enum.Font.GothamBlack
cyp973.TextSize = 14

local cyp979 = Color3.new(1, 1, 1)

cyp973.TextColor3 = cyp979
cyp973.AutoButtonColor = false
cyp973.Active = true

local cyp1038 = Instance.new('TextButton', cyp947)
local cyp1040 = UDim2.new(1, -60, 0, 28)

cyp1038.Size = cyp1040

local cyp1042 = UDim2.new(0, 10, 0, 38)

cyp1038.Position = cyp1042

local cyp1044 = Color3.fromRGB(40, 40, 40)

cyp1038.BackgroundColor3 = cyp1044
cyp1038.Text = 'MANUAL TP'

local cyp1046 = Color3.new(1, 1, 1)

cyp1038.TextColor3 = cyp1046
cyp1038.Font = Enum.Font.GothamBold
cyp1038.TextSize = 12
cyp1038.Active = true
cyp1038.AutoButtonColor = true

local cyp1050 = Instance.new('UICorner', cyp1038)
cyp1050.CornerRadius = UDim.new(0, 6)

local cyp1080 = Instance.new('TextButton', cyp947)
cyp1080.Size = UDim2.new(1, -60, 0, 28)
cyp1080.Position = UDim2.new(0, 10, 0, 72)
cyp1080.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cyp1080.Text = 'PRIORITY: OFF'
cyp1080.TextColor3 = Color3.new(1, 1, 1)
cyp1080.Font = Enum.Font.GothamBold
cyp1080.TextSize = 12
cyp1080.Active = true
cyp1080.AutoButtonColor = true

local cyp1092 = Instance.new('UICorner', cyp1080)
cyp1092.CornerRadius = UDim.new(0, 6)

local cyp1122 = Instance.new('TextButton', cyp947)
cyp1122.Size = UDim2.new(1, -60, 0, 28)
cyp1122.Position = UDim2.new(0, 10, 0, 106)
cyp1122.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cyp1122.Text = 'NEAREST: OFF'
cyp1122.TextColor3 = Color3.new(1, 1, 1)
cyp1122.Font = Enum.Font.GothamBold
cyp1122.TextSize = 12
cyp1122.Active = true
cyp1122.AutoButtonColor = true

local cyp1134 = Instance.new('UICorner', cyp1122)
cyp1134.CornerRadius = UDim.new(0, 6)

if cyp932:FindFirstChild('MynxxStealTargetUI') then cyp932:FindFirstChild('MynxxStealTargetUI'):Destroy() end

local cyp1177 = Instance.new('ScreenGui')

cyp1177.Name = 'MynxxStealTargetUI'
cyp1177.ResetOnSpawn = false
cyp1177.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
cyp1177.Parent = cyp932

local cyp1181 = Instance.new('Frame', cyp1177)

cyp1181.Name = 'StealTarget'
cyp1181.Active = true
cyp1181.Size = UDim2.fromOffset(262, 360)
cyp1181.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
cyp1181.BorderSizePixel = 0

local cyp1187 = Instance.new('UICorner', cyp1181)
cyp1187.CornerRadius = UDim.new(0, 10)

-- ==========================================
-- SISTEMA DE GUARDADO SEGURO PARA DELTA
-- ==========================================
local SaveFileName = 'XyntrixUI_Positions.json'

_G.XyntrixSavePositions = function()
    pcall(function()
        if not writefile then return end
        local positions = {}
        local playerGui = game.Players.LocalPlayer:FindFirstChild('PlayerGui') or gethui()
        
        local tpUI = playerGui:FindFirstChild('TPStealTestUI')
        if tpUI and tpUI:FindFirstChild('Main') then
            local mainFrame = tpUI.Main
            positions.TPStealTestUI = {X = mainFrame.Position.X.Offset, Y = mainFrame.Position.Y.Offset}
        end
        
        local targetUI = playerGui:FindFirstChild('MynxxStealTargetUI')
        if targetUI and targetUI:FindFirstChild('StealTarget') then
            local targetFrame = targetUI.StealTarget
            positions.MynxxStealTargetUI = {X = targetFrame.Position.X.Offset, Y = targetFrame.Position.Y.Offset}
        end
        
        local encoded = cyp8:JSONEncode(positions)
        writefile(SaveFileName, encoded)
    end)
end

_G.XyntrixLoadPositions = function()
    pcall(function()
        if not isfile or not readfile or not isfile(SaveFileName) then return end
        local decoded = cyp8:JSONDecode(readfile(SaveFileName))
        
        if type(decoded) == 'table' then
            local playerGui = game.Players.LocalPlayer:FindFirstChild('PlayerGui') or gethui()
            
            if decoded.TPStealTestUI then
                local tpUI = playerGui:FindFirstChild('TPStealTestUI')
                if tpUI and tpUI:FindFirstChild('Main') then
                    local mainFrame = tpUI.Main
                    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                    mainFrame.Position = UDim2.new(0.5, decoded.TPStealTestUI.X, 0.5, decoded.TPStealTestUI.Y)
                end
            end
            
            if decoded.MynxxStealTargetUI then
                local targetUI = playerGui:FindFirstChild('MynxxStealTargetUI')
                if targetUI and targetUI:FindFirstChild('StealTarget') then
                    local targetFrame = targetUI.StealTarget
                    targetFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                    targetFrame.Position = UDim2.new(0.5, decoded.MynxxStealTargetUI.X, 0.5, decoded.MynxxStealTargetUI.Y)
                end
            end
        end
    end)
end

-- Botón dentro de la interfaz para guardar
local savePosBtn = Instance.new('TextButton', cyp947)
savePosBtn.Size = UDim2.new(1, -20, 0, 28)
savePosBtn.Position = UDim2.new(0, 10, 0, 140)
savePosBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
savePosBtn.Text = 'SAVE UI POSITIONS'
savePosBtn.TextColor3 = Color3.new(1, 1, 1)
savePosBtn.Font = Enum.Font.GothamBold
savePosBtn.TextSize = 12
savePosBtn.AutoButtonColor = true

local cornerSave = Instance.new('UICorner', savePosBtn)
cornerSave.CornerRadius = UDim.new(0, 6)

savePosBtn.MouseButton1Click:Connect(function()
    _G.XyntrixSavePositions()
    savePosBtn.Text = 'SAVED!'
    task.wait(1)
    savePosBtn.Text = 'SAVE UI POSITIONS'
end)

-- Cargar posiciones automáticamente
task.spawn(function()
    task.wait(1)
    _G.XyntrixLoadPositions()
end)
-- ==========================================