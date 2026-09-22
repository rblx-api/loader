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

writefile('SideTP.json', cyp18)

local cyp20 = game:GetService('Players')
local cyp22 = game:GetService('RunService')
local cyp24 = game:GetService('UserInputService')

game:GetService('ReplicatedStorage')

local _cyp20LocalPlayer27 = cyp20.LocalPlayer
local _ = cyp24.TouchEnabled

_G.MynxxIsMobile = false

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

    local cyp177 = gethui()
    local cyp179 = game:GetService('CoreGui')
    local cyp181 = game:GetService('Players')
    local cyp184 = cyp181.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp186 = cyp177:GetChildren()

    for _187, _187_2 in ipairs(cyp186)do
        _187_2:IsA('ScreenGui')

        local _ = _187_2.Name
    end

    local cyp192 = cyp179:GetChildren()

    for _193, _193_2 in ipairs(cyp192)do
        _193_2:IsA('ScreenGui')

        local _ = _193_2.Name
    end

    local cyp198 = cyp184:GetChildren()

    for _199, _199_2 in ipairs(cyp198)do
        _199_2:IsA('ScreenGui')

        local _ = _199_2.Name
    end

    task.wait(0.35)

    local cyp203 = gethui()
    local cyp205 = game:GetService('CoreGui')
    local cyp207 = game:GetService('Players')
    local cyp210 = cyp207.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp212 = cyp203:GetChildren()

    for _213, _213_2 in ipairs(cyp212)do
        _213_2:IsA('ScreenGui')

        local _ = _213_2.Name
    end

    local cyp218 = cyp205:GetChildren()

    for _219, _219_2 in ipairs(cyp218)do
        _219_2:IsA('ScreenGui')

        local _ = _219_2.Name
    end

    local cyp224 = cyp210:GetChildren()

    for _225, _225_2 in ipairs(cyp224)do
        _225_2:IsA('ScreenGui')

        local _ = _225_2.Name
    end

    task.wait(0.35)

    local cyp229 = gethui()
    local cyp231 = game:GetService('CoreGui')
    local cyp233 = game:GetService('Players')
    local cyp236 = cyp233.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp238 = cyp229:GetChildren()

    for _239, _239_2 in ipairs(cyp238)do
        _239_2:IsA('ScreenGui')

        local _ = _239_2.Name
    end

    local cyp244 = cyp231:GetChildren()

    for _245, _245_2 in ipairs(cyp244)do
        _245_2:IsA('ScreenGui')

        local _ = _245_2.Name
    end

    local cyp250 = cyp236:GetChildren()

    for _251, _251_2 in ipairs(cyp250)do
        _251_2:IsA('ScreenGui')

        local _ = _251_2.Name
    end

    task.wait(0.35)

    local cyp255 = gethui()
    local cyp257 = game:GetService('CoreGui')
    local cyp259 = game:GetService('Players')
    local cyp262 = cyp259.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp264 = cyp255:GetChildren()

    for _265, _265_2 in ipairs(cyp264)do
        _265_2:IsA('ScreenGui')

        local _ = _265_2.Name
    end

    local cyp270 = cyp257:GetChildren()

    for _271, _271_2 in ipairs(cyp270)do
        _271_2:IsA('ScreenGui')

        local _ = _271_2.Name
    end

    local cyp276 = cyp262:GetChildren()

    for _277, _277_2 in ipairs(cyp276)do
        _277_2:IsA('ScreenGui')

        local _ = _277_2.Name
    end

    task.wait(0.35)

    local cyp281 = gethui()
    local cyp283 = game:GetService('CoreGui')
    local cyp285 = game:GetService('Players')
    local cyp288 = cyp285.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp290 = cyp281:GetChildren()

    for _291, _291_2 in ipairs(cyp290)do
        _291_2:IsA('ScreenGui')

        local _ = _291_2.Name
    end

    local cyp296 = cyp283:GetChildren()

    for _297, _297_2 in ipairs(cyp296)do
        _297_2:IsA('ScreenGui')

        local _ = _297_2.Name
    end

    local cyp302 = cyp288:GetChildren()

    for _303, _303_2 in ipairs(cyp302)do
        _303_2:IsA('ScreenGui')

        local _ = _303_2.Name
    end

    task.wait(0.35)

    local cyp307 = gethui()
    local cyp309 = game:GetService('CoreGui')
    local cyp311 = game:GetService('Players')
    local cyp314 = cyp311.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp316 = cyp307:GetChildren()

    for _317, _317_2 in ipairs(cyp316)do
        _317_2:IsA('ScreenGui')

        local _ = _317_2.Name
    end

    local cyp322 = cyp309:GetChildren()

    for _323, _323_2 in ipairs(cyp322)do
        _323_2:IsA('ScreenGui')

        local _ = _323_2.Name
    end

    local cyp328 = cyp314:GetChildren()

    for _329, _329_2 in ipairs(cyp328)do
        _329_2:IsA('ScreenGui')

        local _ = _329_2.Name
    end

    task.wait(0.35)

    local cyp333 = gethui()
    local cyp335 = game:GetService('CoreGui')
    local cyp337 = game:GetService('Players')
    local cyp340 = cyp337.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp342 = cyp333:GetChildren()

    for _343, _343_2 in ipairs(cyp342)do
        _343_2:IsA('ScreenGui')

        local _ = _343_2.Name
    end

    local cyp348 = cyp335:GetChildren()

    for _349, _349_2 in ipairs(cyp348)do
        _349_2:IsA('ScreenGui')

        local _ = _349_2.Name
    end

    local cyp354 = cyp340:GetChildren()

    for _355, _355_2 in ipairs(cyp354)do
        _355_2:IsA('ScreenGui')

        local _ = _355_2.Name
    end

    task.wait(0.35)

    local cyp359 = gethui()
    local cyp361 = game:GetService('CoreGui')
    local cyp363 = game:GetService('Players')
    local cyp366 = cyp363.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp368 = cyp359:GetChildren()

    for _369, _369_2 in ipairs(cyp368)do
        _369_2:IsA('ScreenGui')

        local _ = _369_2.Name
    end

    local cyp374 = cyp361:GetChildren()

    for _375, _375_2 in ipairs(cyp374)do
        _375_2:IsA('ScreenGui')

        local _ = _375_2.Name
    end

    local cyp380 = cyp366:GetChildren()

    for _381, _381_2 in ipairs(cyp380)do
        _381_2:IsA('ScreenGui')

        local _ = _381_2.Name
    end

    task.wait(0.35)

    local cyp385 = gethui()
    local cyp387 = game:GetService('CoreGui')
    local cyp389 = game:GetService('Players')
    local cyp392 = cyp389.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp394 = cyp385:GetChildren()

    for _395, _395_2 in ipairs(cyp394)do
        _395_2:IsA('ScreenGui')

        local _ = _395_2.Name
    end

    local cyp400 = cyp387:GetChildren()

    for _401, _401_2 in ipairs(cyp400)do
        _401_2:IsA('ScreenGui')

        local _ = _401_2.Name
    end

    local cyp406 = cyp392:GetChildren()

    for _407, _407_2 in ipairs(cyp406)do
        _407_2:IsA('ScreenGui')

        local _ = _407_2.Name
    end

    task.wait(0.35)

    local cyp411 = gethui()
    local cyp413 = game:GetService('CoreGui')
    local cyp415 = game:GetService('Players')
    local cyp418 = cyp415.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp420 = cyp411:GetChildren()

    for _421, _421_2 in ipairs(cyp420)do
        _421_2:IsA('ScreenGui')

        local _ = _421_2.Name
    end

    local cyp426 = cyp413:GetChildren()

    for _427, _427_2 in ipairs(cyp426)do
        _427_2:IsA('ScreenGui')

        local _ = _427_2.Name
    end

    local cyp432 = cyp418:GetChildren()

    for _433, _433_2 in ipairs(cyp432)do
        _433_2:IsA('ScreenGui')

        local _ = _433_2.Name
    end

    task.wait(0.35)

    local cyp437 = gethui()
    local cyp439 = game:GetService('CoreGui')
    local cyp441 = game:GetService('Players')
    local cyp444 = cyp441.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp446 = cyp437:GetChildren()

    for _447, _447_2 in ipairs(cyp446)do
        _447_2:IsA('ScreenGui')

        local _ = _447_2.Name
    end

    local cyp452 = cyp439:GetChildren()

    for _453, _453_2 in ipairs(cyp452)do
        _453_2:IsA('ScreenGui')

        local _ = _453_2.Name
    end

    local cyp458 = cyp444:GetChildren()

    for _459, _459_2 in ipairs(cyp458)do
        _459_2:IsA('ScreenGui')

        local _ = _459_2.Name
    end

    task.wait(0.35)

    local cyp463 = gethui()
    local cyp465 = game:GetService('CoreGui')
    local cyp467 = game:GetService('Players')
    local cyp470 = cyp467.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp472 = cyp463:GetChildren()

    for _473, _473_2 in ipairs(cyp472)do
        _473_2:IsA('ScreenGui')

        local _ = _473_2.Name
    end

    local cyp478 = cyp465:GetChildren()

    for _479, _479_2 in ipairs(cyp478)do
        _479_2:IsA('ScreenGui')

        local _ = _479_2.Name
    end

    local cyp484 = cyp470:GetChildren()

    for _485, _485_2 in ipairs(cyp484)do
        _485_2:IsA('ScreenGui')

        local _ = _485_2.Name
    end

    task.wait(0.35)

    local cyp489 = gethui()
    local cyp491 = game:GetService('CoreGui')
    local cyp493 = game:GetService('Players')
    local cyp496 = cyp493.LocalPlayer:FindFirstChild('PlayerGui')
    local cyp498 = cyp489:GetChildren()

    for _499, _499_2 in ipairs(cyp498)do
        _499_2:IsA('ScreenGui')

        local _ = _499_2.Name
    end

    local cyp504 = cyp491:GetChildren()

    for _505, _505_2 in ipairs(cyp504)do
        _505_2:IsA('ScreenGui')

        local _ = _505_2.Name
    end

    local cyp510 = cyp496:GetChildren()

    for _511, _511_2 in ipairs(cyp510)do
        _511_2:IsA('ScreenGui')

        local _ = _511_2.Name
    end

    task.wait(0.35)

    local cyp515 = gethui()
    local cyp517 = game:GetService('CoreGui')
    local cyp519 = game:GetService('Players')
    local _ = cyp519.LocalPlayer
    local cyp523 = cyp515:GetChildren()

    for _524, _524_2 in ipairs(cyp523)do
        _524_2:IsA('ScreenGui')

        local _ = _524_2.Name
    end

    local cyp529 = cyp517:GetChildren()

    for _530, _530_2 in ipairs(cyp529)do
        _530_2:IsA('ScreenGui')

        local _ = _530_2.Name
    end

    task.wait(0.35)
    task.wait(0.35)

    local cyp537 = gethui()
    local cyp540 = game:GetService('Players')
    local _ = cyp540.LocalPlayer
    local cyp544 = cyp537:GetChildren()

    for _545, _545_2 in ipairs(cyp544)do
        _545_2:IsA('ScreenGui')

        local _ = _545_2.Name
    end

    task.wait(0.35)

    local cyp552 = game:GetService('Players')
    local _ = cyp552.LocalPlayer

    task.wait(0.35)

    local cyp555 = gethui()
    local cyp558 = game:GetService('Players')
    local _ = cyp558.LocalPlayer
    local cyp562 = cyp555:GetChildren()

    for _563, _563_2 in ipairs(cyp562)do
        _563_2:IsA('ScreenGui')

        local _ = _563_2.Name
    end

    task.wait(0.35)

    local cyp570 = game:GetService('Players')
    local cyp575 = cyp570.LocalPlayer:FindFirstChild('PlayerGui'):GetChildren()

    for _576, _576_2 in ipairs(cyp575)do
        _576_2:IsA('ScreenGui')

        local _ = _576_2.Name
    end

    task.wait(0.35)

    local _ = game.GetService

    task.wait(0.35)

    local cyp584 = gethui()
    local cyp587 = game:GetService('Players')
    local _ = cyp587.LocalPlayer
    local cyp591 = cyp584:GetChildren()

    for _592, _592_2 in ipairs(cyp591)do
        _592_2:IsA('ScreenGui')

        local _ = _592_2.Name
    end

    task.wait(0.35)

    local cyp599 = game:GetService('Players')
    local _ = cyp599.LocalPlayer

    task.wait(0.35)

    local cyp602 = gethui()
    local cyp605 = game:GetService('Players')
    local _ = cyp605.LocalPlayer
    local cyp609 = cyp602:GetChildren()

    for _610, _610_2 in ipairs(cyp609)do
        _610_2:IsA('ScreenGui')

        local _ = _610_2.Name
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

task.spawn(function()
    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)

    local _ = game.JobId

    task.wait(10)
    error('/app/./httplog2:625: <ChocoEnvLogger: infinitelooperror>')
end)

local cyp652 = workspace:FindFirstChild('Plots')

cyp652.ChildAdded:Connect(function() end)
cyp652.ChildRemoved:Connect(function() end)

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

task.spawn(function() end)

local _ = _G.MynxxGetSyncData

_G.MynxxGetSyncData = function(_680) end

task.spawn(function() end)

_G.MynxxScanResetRemotes = function() end
_G.MynxxGetRemote = function(_685, _685_2) end
_G.XenFireGrapple2 = function() end
_G.MynxxFireGrapple = function() end

local _ = _G.MynxxTPDebug

_G.MynxxTPDebug = false

local _ = _G.MynxxWallHug

_G.MynxxWallHug = false
_G.MynxxSetCarpetTool = function(_688) end

local _ = _G.MynxxCarpetTool

_G.MynxxPriLookup = function() end
_G.MynxxMutLookup = function() end
_G.MynxxMutRank = function(_691) end
_G.XyntrixListMyAnimals = function() end
_G.MynxxClearTPSync = function() end

Vector3.new(-487.921448, 16.850713, -75.768013)
Vector3.new(-332.37973, 16.850722, -75.7621)
Vector3.new(-487.134918, 16.850713, -18.094154)
Vector3.new(-316.300171, 16.850713, -17.845898)
Vector3.new(-330.765381, 16.850713, 31.424425)
Vector3.new(-502.989349, 16.850713, 31.17243)
Vector3.new(-489.077087, 16.850713, 89.010147)
Vector3.new(-330.908936, 16.850713, 88.930145)
Vector3.new(-331.264893, 16.850713, 138.209167)
Vector3.new(-487.935181, 16.850713, 138.026321)
Vector3.new(-487.774933, 16.850713, 195.882538)
Vector3.new(-330.799133, 16.850575, 196.022354)
Vector3.new(-335.725586, -3.048217, -74.984589)
Vector3.new(-503.214233, -3.048217, -75.043137)
Vector3.new(-483.619385, -3.71843, -18.844337)
Vector3.new(-316.147095, -3.048218, -18.818844)
Vector3.new(-335.985413, -3.048218, 32.051426)
Vector3.new(-503.277008, -3.048217, 31.956175)
Vector3.new(-483.74939, -3.048218, 88.147003)
Vector3.new(-315.793823, -3.048217, 88.163979)
Vector3.new(-335.476654, -3.048218, 139.001083)
Vector3.new(-503.710083, -3.048218, 138.989883)
Vector3.new(-315.654938, -3.048218, 195.302444)
Vector3.new(-483.859253, -3.048218, 195.269043)
Vector3.new(-476.52, -2, 220.94090270996094)
Vector3.new(-476.52, -2, 113.77315521240234)
Vector3.new(-476.52, -2, 6.178487777709961)
Vector3.new(-476.52, -2, -101.07275390625)
Vector3.new(-342.66, -2, 221.44737243652344)
Vector3.new(-342.66, -2, 113.41409301757813)
Vector3.new(-342.66, -2, 6.249461650848389)
Vector3.new(-342.66, -2, -99.73458862304688)
Vector3.new(-479.51, 18, 220.94090270996094)
Vector3.new(-479.51, 18, 113.77315521240234)
Vector3.new(-479.51, 18, 6.178487777709961)
Vector3.new(-479.51, 18, -101.07275390625)
Vector3.new(-339.48, 18, 221.44737243652344)
Vector3.new(-339.48, 18, 113.41409301757813)
Vector3.new(-339.48, 18, 6.249461650848389)
Vector3.new(-339.48, 18, -99.73458862304688)

local _ = tostring(_cyp20LocalPlayer27.UserId) .. '_Clone'
local cyp778 = workspace:GetChildren()

for _779, _779_2 in ipairs(cyp778)do
    type(_779_2.Name)
end

workspace.ChildAdded:Connect(function(_784) end)

local cyp786 = cyp20:GetPlayers()

for _787, _787_2 in ipairs(cyp786)do
    local _ = _787_2 == _cyp20LocalPlayer27
    local _ = _787_2.Character
    local _Character790 = _787_2.Character
    local cyp792 = _Character790:GetDescendants()

    for _793, _793_2 in ipairs(cyp792)do
        _793_2:IsA('BasePart')

        local _ = _793_2.CanCollide

        _793_2.CanCollide = false
    end

    _Character790.DescendantAdded:Connect(function(_800) end)
    _787_2.CharacterAdded:Connect(function(_804) end)
end

cyp20.PlayerAdded:Connect(function(_808) end)
task.spawn(function() end)
Vector3.new(1, 0, 0)
Vector3.new(-1, 0, 0)
Vector3.new(0, 0, 1)
Vector3.new(0, 0, -1)
game:GetService('PathfindingService')

local cyp823 = OverlapParams.new()

cyp823.FilterType = Enum.RaycastFilterType.Exclude
cyp823.RespectCanCollide = true

local cyp827 = RaycastParams.new()

cyp827.FilterType = Enum.RaycastFilterType.Exclude
cyp827.RespectCanCollide = true
cyp827.IgnoreWater = true
_G.MynxxVoxelRoute = function(_830, _830_2) end
_G.MynxxSegmentCrossesCenter = function(_831, _831_2) end
_G.MynxxFindCenterDetour = function(_832, _832_2, _832_3) end
_G.MynxxFindRowDetour = function(_833, _833_2, _833_3) end

game:GetService('TweenService')

local _ = _G.MynxxApproachF2From1

_G.MynxxApproachF2From1 = true

game:GetService('Stats')

_G.MynxxPingMs = function() end

cyp22.Heartbeat:Connect(function() end)

_G.MynxxStartSideTP = function() end
_G._stpNormBind = function(_844) end
_G._stpBindPretty = function(_845) end
_G._stpIsMouseBtn = function(_846) end
_G._stpInputMatches = function(_847, _847_2) end
_G._stpSideDown = function(_848) end
_G._stpBindIsSide = function(_849, _849_2) end

cyp22.Heartbeat:Connect(function() end)

_G._stpListenBind = function(_854, _854_2) end

cyp24.InputBegan:Connect(function(_858, _858_2) end)
task.spawn(function() end)

_G.MynxxChannelsReady = false

task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)

local cyp872 = game:GetService('Players')
local cyp874 = game:GetService('RunService')
local _cyp872LocalPlayer875 = cyp872.LocalPlayer
local cyp877 = _cyp872LocalPlayer875:WaitForChild('PlayerGui')
local cyp879 = game:HttpGet([[https://raw.githubusercontent.com/OpBrairnotV2/Ui_Library/refs/heads/main/Ui.lua]])

loadstring(cyp879)()
task.defer(function() end)

local _ = Enum.HumanoidStateType.Physics
local _ = Enum.HumanoidStateType.Ragdoll
local _ = Enum.HumanoidStateType.FallingDown
local _ = Enum.HumanoidStateType.GettingUp

Color3.fromRGB(255, 60, 60)
Color3.fromRGB(255, 160, 60)
Color3.fromRGB(50, 150, 255)
Color3.fromRGB(180, 220, 255)
cyp874.RenderStepped:Connect(function() end)
cyp874.Heartbeat:Connect(function() end)
Color3.fromRGB(210, 150, 255)
cyp874.Heartbeat:Connect(function() end)

local _ = _cyp872LocalPlayer875.Character
local _ = _cyp872LocalPlayer875.Character

task.spawn(function() end)
_cyp872LocalPlayer875.CharacterAdded:Connect(function(_923) end)
cyp874.Heartbeat:Connect(function() end)
game:GetService('HttpService')

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

cyp932:FindFirstChild('TPStealTestUI'):Destroy()
cyp877:FindFirstChild('TPStealTestUI'):Destroy()

local cyp942 = Instance.new('ScreenGui')

cyp942.Name = 'TPStealTestUI'
cyp942.ResetOnSpawn = false
cyp942.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
cyp942.DisplayOrder = 999999
cyp942.IgnoreGuiInset = true
cyp942.Parent = cyp932

local _ = cyp942.Parent
local _ = _G._stp_pos

_G._stp_pos = {}

local cyp947 = Instance.new('Frame', cyp942)

cyp947.Name = 'Main'
cyp947.Active = true

local cyp949 = UDim2.fromOffset(250, 180)

cyp947.Size = cyp949

local cyp951 = Color3.fromRGB(12, 12, 12)

cyp947.BackgroundColor3 = cyp951
cyp947.BorderSizePixel = 0

local cyp953 = Instance.new('UICorner', cyp947)
local cyp955 = UDim.new(0, 10)

cyp953.CornerRadius = cyp955

cyp947:IsA('GuiObject')

cyp947.BackgroundColor3 = cyp30
cyp947.BackgroundTransparency = 0
cyp947.BorderSizePixel = 0

cyp947:FindFirstChildOfClass('UICorner')

local _workspaceCurrentCamera961 = workspace.CurrentCamera
local _ = _workspaceCurrentCamera961.ViewportSize.X
local _ = _workspaceCurrentCamera961.ViewportSize.Y
local cyp967 = Vector2.new(0.5, 0.5)

cyp947.AnchorPoint = cyp967

local cyp969 = UDim2.new(0.5, 0, 0.5, 0)

cyp947.Position = cyp969

cyp947:SetAttribute('_XynCentered', true)

local cyp973 = Instance.new('TextButton', cyp947)
local cyp975 = UDim2.new(1, 0, 0, 30)

cyp973.Size = cyp975
cyp973.BackgroundTransparency = 1
cyp973.Text = 'Xyntrix \194\183 Teleport'
cyp973.Font = Enum.Font.GothamBlack
cyp973.TextSize = 14

local cyp979 = Color3.new(1, 1, 1)

cyp973.TextColor3 = cyp979
cyp973.AutoButtonColor = false
cyp973.Active = true

cyp947:IsA('GuiObject')

cyp947.BackgroundColor3 = cyp30
cyp947.BackgroundTransparency = 0
cyp947.BorderSizePixel = 0

local cyp983 = cyp947:FindFirstChildOfClass('UICorner')
local cyp985 = UDim.new(0, 14)

cyp983.CornerRadius = cyp985

local cyp987 = cyp947:FindFirstChildOfClass('UIStroke')

cyp987.Color = cyp40
cyp987.Thickness = 1.4
cyp987.Transparency = 0.4
cyp987.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

cyp947:FindFirstChild('_XynAccent')
cyp947:FindFirstChild('_XynShadow')

cyp973.Font = Enum.Font.GothamBlack

local _997, _997_2, _997_3 = math.max(cyp973.TextSize, 13)

cyp973.TextSize = _997
cyp973.TextColor3 = cyp44
cyp973.TextStrokeTransparency = 0.7

local cyp999 = Color3.fromRGB(0, 0, 0)

cyp973.TextStrokeColor3 = cyp999

cyp973:IsA('TextButton')

cyp973.AutoButtonColor = false
cyp973.BackgroundTransparency = 1

task.defer(function(_1004) end, cyp947)

cyp973.Active = true

cyp973.InputBegan:Connect(function(_1008) end)
cyp973.InputEnded:Connect(function(_1012) end)
cyp931.InputChanged:Connect(function(_1016) end)
cyp931.InputEnded:Connect(function(_1020) end)

cyp947.Active = true

cyp947.InputBegan:Connect(function(_1024) end)
cyp947.InputEnded:Connect(function(_1028) end)
cyp931.InputChanged:Connect(function(_1032) end)
cyp931.InputEnded:Connect(function(_1036) end)

local cyp1038 = Instance.new('TextButton', cyp947)
local cyp1040 = UDim2.new(1, -20, 0, 28)

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
local cyp1052 = UDim.new(0, 6)

cyp1050.CornerRadius = cyp1052

cyp1038.MouseButton1Click:Connect(function() end)

local _ = _G._stp_tpKeyName

_G._stp_tpKeyName = 'Key:T'

local cyp1058 = UDim2.new(1, -60, 0, 28)

cyp1038.Size = cyp1058

local cyp1060 = Instance.new('TextButton', cyp947)
local cyp1062 = UDim2.new(0, 34, 0, 28)

cyp1060.Size = cyp1062

local cyp1064 = UDim2.new(1, -44, 0, 38)

cyp1060.Position = cyp1064

local cyp1066 = Color3.fromRGB(55, 55, 55)

cyp1060.BackgroundColor3 = cyp1066

local cyp1068 = Color3.new(1, 1, 1)

cyp1060.TextColor3 = cyp1068
cyp1060.Font = Enum.Font.GothamBold
cyp1060.TextSize = 10
cyp1060.Text = 'T'
cyp1060.AutoButtonColor = true

local cyp1072 = Instance.new('UICorner', cyp1060)
local cyp1074 = UDim.new(0, 6)

cyp1072.CornerRadius = cyp1074

cyp1060.MouseButton1Click:Connect(function() end)

local cyp1080 = Instance.new('TextButton', cyp947)
local cyp1082 = UDim2.new(1, -20, 0, 28)

cyp1080.Size = cyp1082

local cyp1084 = UDim2.new(0, 10, 0, 72)

cyp1080.Position = cyp1084

local cyp1086 = Color3.fromRGB(40, 40, 40)

cyp1080.BackgroundColor3 = cyp1086
cyp1080.Text = 'PRIORITY: OFF'

local cyp1088 = Color3.new(1, 1, 1)

cyp1080.TextColor3 = cyp1088
cyp1080.Font = Enum.Font.GothamBold
cyp1080.TextSize = 12
cyp1080.Active = true
cyp1080.AutoButtonColor = true

local cyp1092 = Instance.new('UICorner', cyp1080)
local cyp1094 = UDim.new(0, 6)

cyp1092.CornerRadius = cyp1094

cyp1080.MouseButton1Click:Connect(function() end)

local cyp1100 = UDim2.new(1, -60, 0, 28)

cyp1080.Size = cyp1100

local cyp1102 = Instance.new('TextButton', cyp947)
local cyp1104 = UDim2.fromOffset(34, 28)

cyp1102.Size = cyp1104

local cyp1106 = UDim2.new(1, -44, 0, 72)

cyp1102.Position = cyp1106

local cyp1108 = Color3.fromRGB(9, 9, 13)

cyp1102.BackgroundColor3 = cyp1108
cyp1102.Text = '\226\154\153'

local cyp1110 = Color3.new(1, 1, 1)

cyp1102.TextColor3 = cyp1110
cyp1102.Font = Enum.Font.GothamBold
cyp1102.TextSize = 16
cyp1102.AutoButtonColor = true

local cyp1114 = Instance.new('UICorner', cyp1102)
local cyp1116 = UDim.new(0, 6)

cyp1114.CornerRadius = cyp1116

cyp1102.MouseButton1Click:Connect(function() end)

local cyp1122 = Instance.new('TextButton', cyp947)
local cyp1124 = UDim2.new(1, -20, 0, 28)

cyp1122.Size = cyp1124

local cyp1126 = UDim2.new(0, 10, 0, 106)

cyp1122.Position = cyp1126

local cyp1128 = Color3.fromRGB(40, 40, 40)

cyp1122.BackgroundColor3 = cyp1128
cyp1122.Text = 'NEAREST: OFF'

local cyp1130 = Color3.new(1, 1, 1)

cyp1122.TextColor3 = cyp1130
cyp1122.Font = Enum.Font.GothamBold
cyp1122.TextSize = 12
cyp1122.Active = true
cyp1122.AutoButtonColor = true

local cyp1134 = Instance.new('UICorner', cyp1122)
local cyp1136 = UDim.new(0, 6)

cyp1134.CornerRadius = cyp1136

cyp1122.MouseButton1Click:Connect(function() end)

_G._stpFireNearKey = function() end

local _ = _G.MynxxNearestKey

_G.MynxxNearestKey = 'Key:N'

local cyp1143 = UDim2.new(1, -60, 0, 28)

cyp1122.Size = cyp1143

local cyp1145 = Instance.new('TextButton', cyp947)
local cyp1147 = UDim2.new(0, 34, 0, 28)

cyp1145.Size = cyp1147

local cyp1149 = UDim2.new(1, -44, 0, 106)

cyp1145.Position = cyp1149

local cyp1151 = Color3.fromRGB(55, 55, 55)

cyp1145.BackgroundColor3 = cyp1151

local cyp1153 = Color3.new(1, 1, 1)

cyp1145.TextColor3 = cyp1153
cyp1145.Font = Enum.Font.GothamBold
cyp1145.TextSize = 10
cyp1145.Text = 'N'
cyp1145.AutoButtonColor = true

local cyp1157 = Instance.new('UICorner', cyp1145)
local cyp1159 = UDim.new(0, 6)

cyp1157.CornerRadius = cyp1159

cyp1145.MouseButton1Click:Connect(function() end)
cyp931.InputBegan:Connect(function(_1167, _1167_2) end)

cyp1080.Text = 'PRIORITY: ON'

local cyp1169 = Color3.fromRGB(45, 130, 255)

cyp1080.BackgroundColor3 = cyp1169
cyp1122.Text = 'NEAREST: OFF'

local cyp1171 = Color3.fromRGB(40, 40, 40)

cyp1122.BackgroundColor3 = cyp1171

cyp932:FindFirstChild('MynxxStealTargetUI'):Destroy()

local cyp1177 = Instance.new('ScreenGui')

cyp1177.Name = 'MynxxStealTargetUI'
cyp1177.ResetOnSpawn = false
cyp1177.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
cyp1177.Parent = cyp932

local cyp1181 = Instance.new('Frame', cyp1177)

cyp1181.Name = 'StealTarget'
cyp1181.Active = true

local cyp1183 = UDim2.fromOffset(262, 360)

cyp1181.Size = cyp1183

local cyp1185 = Color3.fromRGB(12, 12, 12)

cyp1181.BackgroundColor3 = cyp1185
cyp1181.BorderSizePixel = 0

local cyp1187 = Instance.new('UICorner', cyp1181)
local cyp1189 = UDim.new(0, 10)

cyp1187.CornerRadius = cyp1189

cyp1181:IsA('GuiObject')

cyp1181.BackgroundColor3 = cyp30
cyp1181.BackgroundTransparency = 0
cyp1181.BorderSizePixel = 0

cyp1181:FindFirstChildOfClass('UICorner')

local _ = workspace.CurrentCamera.ViewportSize.X

cyp1181:IsA('GuiObject')

cyp1181.BackgroundColor3 = cyp30
cyp1181.BackgroundTransparency = 0
cyp1181.BorderSizePixel = 0

local cyp1203 = Instance.new('TextButton', cyp1181)
local cyp1205 = UDim2.new(1, 0, 0, 30)

cyp1203.Size = cyp1205
cyp1203.BackgroundTransparency = 1
cyp1203.Text = 'Xyntrix \194\183 Steal Target'

task.defer(function(_1209) end, cyp1181)

cyp1203.Font = Enum.Font.GothamBlack
cyp1203.TextSize = 13

local cyp1213 = Color3.new(1, 1, 1)

cyp1203.TextColor3 = cyp1213
cyp1203.AutoButtonColor = false
cyp1203.Active = true
cyp1203.Active = true

cyp1203.InputBegan:Connect(function(_1217) end)
cyp1203.InputEnded:Connect(function(_1221) end)
cyp931.InputChanged:Connect(function(_1225) end)
cyp931.InputEnded:Connect(function(_1229) end)

cyp1181.Active = true

cyp1181.InputBegan:Connect(function(_1233) end)
cyp1181.InputEnded:Connect(function(_1237) end)
cyp931.InputChanged:Connect(function(_1241) end)
cyp931.InputEnded:Connect(function(_1245) end)

local cyp1247 = Instance.new('ScrollingFrame', cyp1181)
local cyp1249 = UDim2.new(1, -12, 1, -42)

cyp1247.Size = cyp1249

local cyp1251 = UDim2.new(0, 6, 0, 36)

cyp1247.Position = cyp1251

local cyp1253 = Color3.fromRGB(16, 16, 16)

cyp1247.BackgroundColor3 = cyp1253
cyp1247.BorderSizePixel = 0
cyp1247.ScrollBarThickness = 5

local cyp1255 = Color3.fromRGB(90, 90, 90)

cyp1247.ScrollBarImageColor3 = cyp1255

local cyp1257 = UDim2.new()

cyp1247.CanvasSize = cyp1257

local cyp1259 = Instance.new('UICorner', cyp1247)
local cyp1261 = UDim.new(0, 6)

cyp1259.CornerRadius = cyp1261

local cyp1263 = Instance.new('UIListLayout', cyp1247)

cyp1263.SortOrder = Enum.SortOrder.LayoutOrder

local cyp1267 = UDim.new(0, 3)

cyp1263.Padding = cyp1267

local cyp1269 = Instance.new('UIPadding', cyp1247)
local cyp1271 = UDim.new(0, 4)

cyp1269.PaddingTop = cyp1271

local cyp1273 = UDim.new(0, 4)

cyp1269.PaddingBottom = cyp1273

local cyp1275 = UDim.new(0, 4)

cyp1269.PaddingLeft = cyp1275

local cyp1277 = UDim.new(0, 4)

cyp1269.PaddingRight = cyp1277

cyp1263:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() end)
task.spawn(function() end)

local cyp1287 = Instance.new('TextButton', cyp947)
local cyp1289 = UDim2.new(1, -20, 0, 28)

cyp1287.Size = cyp1289

local cyp1291 = UDim2.new(0, 10, 0, 140)

cyp1287.Position = cyp1291

local cyp1293 = Color3.fromRGB(40, 40, 40)

cyp1287.BackgroundColor3 = cyp1293
cyp1287.Text = 'TP SETTINGS'

local cyp1295 = Color3.new(1, 1, 1)

cyp1287.TextColor3 = cyp1295
cyp1287.Font = Enum.Font.GothamBold
cyp1287.TextSize = 12
cyp1287.Active = true
cyp1287.AutoButtonColor = true

local cyp1299 = Instance.new('UICorner', cyp1287)
local cyp1301 = UDim.new(0, 6)

cyp1299.CornerRadius = cyp1301

cyp1287.MouseButton1Click:Connect(function() end)

-- ==========================================
-- MÓDULO DE GUARDADO Y CARGA DE POSICIONES UI
-- ==========================================
local SaveFileName = 'XyntrixUI_Positions.json'

_G.XyntrixSavePositions = function()
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
    
    local success, encoded = pcall(function()
        return cyp8:JSONEncode(positions)
    end)
    
    if success then
        writefile(SaveFileName, encoded)
    end
end

_G.XyntrixLoadPositions = function()
    if not isfile or not isfile(SaveFileName) then return end
    
    local success, decoded = pcall(function()
        return cyp8:JSONDecode(readfile(SaveFileName))
    end)
    
    if success and type(decoded) == 'table' then
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
end

-- Botón en la interfaz para guardar posiciones de forma manual
local savePosBtn = Instance.new('TextButton', cyp947)
savePosBtn.Size = UDim2.new(1, -20, 0, 28)
savePosBtn.Position = UDim2.new(0, 10, 0, 174)
savePosBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
savePosBtn.Text = 'SAVE UI POSITIONS'
savePosBtn.TextColor3 = Color3.new(1, 1, 1)
savePosBtn.Font = Enum.Font.GothamBold
savePosBtn.TextSize = 12
savePosBtn.AutoButtonColor = true

local cornerSave = Instance.new('UICorner', savePosBtn)
cornerSave.CornerRadius = UDim.new(0, 6)

savePosBtn.MouseButton1Click:Connect(function()
    pcall(_G.XyntrixSavePositions)
    savePosBtn.Text = 'SAVED!'
    task.wait(1)
    savePosBtn.Text = 'SAVE UI POSITIONS'
end)

-- Cargar posiciones automáticamente al iniciar
task.spawn(function()
    task.wait(1)
    pcall(_G.XyntrixLoadPositions)
end)
-- ==========================================

task.delay(1.5, function() end)
game:GetService('HttpService')

_G.HubCfg = {
    save = function() end,
    get = function(_1312) end,
}
_G.XyntrixSaveConfig = function() end

local _ = _G.XyntrixGuiHidden

_G.XyntrixGuiHidden = {}
_G.XyntrixApplyGuiVisibility = function() end
_G.XyntrixReopenGui = function(_1315) end
_G.XyntrixToggleGui = function(_1316) end
_G.XyntrixSetGuiHidden = function(_1317, _1317_2) end
_G.XyntrixShowGui = function(_1318) end
_G.XyntrixOpenMainMenu = function(_1319) end
_G.XyntrixOpenHideGuiPanel = function() end
_G.XyntrixToggleHideGuis = function() end
_G.XyntrixGuiMap = {
    invis = 'InvisStealUI',
    keybinds = 'CarpetCloneUI',
    autokick = 'AutoKickUI',
    teleport = 'TPStealTestUI',
    faceaway = 'FlasherUI',
    watermark = 'MynxxWatermark',
    stealtarget = 'MynxxStealTargetUI',
    stealbar = 'LeanStealBar',
}
_G.XyntrixGuiLabels = {
    invis = 'Invis',
    keybinds = 'Keybinds',
    autokick = 'Auto Kick',
    teleport = 'Teleport',
    faceaway = 'Face Away',
    watermark = 'Watermark',
    stealtarget = 'Steal Target',
    stealbar = 'Steal Bar',
}

task.defer(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)

local _ = _G.XyntrixInfJump

_G.XyntrixInfJump = false

game:GetService('UserInputService')
game:GetService('RunService')

_G.XyntrixSetInfJump = function(_1362) end

task.defer(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)

local _ = _G.AntiDieDisabled

_G.AntiDieDisabled = false

task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)
task.spawn(function() end)