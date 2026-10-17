-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1792262195070
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"creadordescrip"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

-- script hecho por STRIKE TOP X SPECTROS
-- script hecho por STRIKE TOP X SPECTROS
--STRIKETOP discord.gg/XaDYCb3BdM X SPECTROS discord.gg/4ZC6PzAy7Y
--STRIKETOP discord.gg/XaDYCb3BdM X SPECTROS discord.gg/4ZC6PzAy7Y
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GUI_NAME = "CleanBypassGui"
local PURPLE = Color3.fromRGB(180, 70, 255)
local DARK = Color3.fromRGB(10, 8, 15)
local WHITE = Color3.fromRGB(245, 245, 250)
local MUTED = Color3.fromRGB(185, 180, 195)
local running = false
local settingsOpen = false
local activeTab = "MAIN"
local powerMode = "PC"
local powerValues = { PC = 97000, Mobile = 72000 }
local keyboardKey = Enum.KeyCode.RightShift
local gamepadKey = Enum.KeyCode.ButtonY
local listeningFor = nil
local dragging, dragStart, startPos = false, nil, nil

local function getGuiParent()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    local ok, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if ok and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function new(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius)
    return new("UICorner", {CornerRadius = UDim.new(0, radius)}, obj)
end
local function stroke(obj, color, thickness, transparency)
    return new("UIStroke", {Color = color, Thickness = thickness or 1, Transparency = transparency or 0}, obj)
end
local function makeLabel(parent, text, size, pos, textSize, color, font)
    return new("TextLabel", {
        Size = size, Position = pos, BackgroundTransparency = 1, Text = text,
        TextColor3 = color or WHITE, Font = font or Enum.Font.GothamBold,
        TextSize = textSize or 12, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 7,
    }, parent)
end
local function makeButton(parent, text, size, pos, textSize)
    local b = new("TextButton", {
        Size = size, Position = pos, BackgroundColor3 = DARK,
        BackgroundTransparency = 0.12, BorderSizePixel = 0, AutoButtonColor = false,
        Text = text, TextColor3 = PURPLE, Font = Enum.Font.GothamBlack,
        TextSize = textSize or 12, ZIndex = 8,
    }, parent)
    corner(b, 8); stroke(b, Color3.fromRGB(20, 18, 25), 1.2)
    return b
end

local parent = getGuiParent()
local old = parent:FindFirstChild(GUI_NAME)
if old then old:Destroy() end
local gui = new("ScreenGui", {
    Name = GUI_NAME, ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)
if type(syn) == "table" and type(syn.protect_gui) == "function" then
    pcall(syn.protect_gui, gui)
elseif typeof(protectgui) == "function" then
    pcall(protectgui, gui)
end
pcall(function() gui.Parent = parent end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local main = new("Frame", {
    Name = "MainFrame", Size = UDim2.fromOffset(360, 160),
    Position = UDim2.new(0.5, -180, 0.5, -80), BackgroundColor3 = Color3.fromRGB(0,0,0),
    BorderSizePixel = 0, ClipsDescendants = true, Active = true, ZIndex = 1,
}, gui)
corner(main, 24); stroke(main, Color3.fromRGB(15,15,15), 1.5)
local bgImage = new("ImageLabel", {
    Name = "BackgroundImage", Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
    Image = "rbxassetid://103527217312966", ScaleType = Enum.ScaleType.Crop, ZIndex = 1,
}, main)
corner(bgImage, 24)
local tint = new("Frame", {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2}, main)
corner(tint,24)
local imgLabel = makeLabel(main, "IMG", UDim2.fromOffset(70,30), UDim2.fromOffset(20,13), 14, PURPLE, Enum.Font.GothamBlack)
imgLabel.ZIndex = 6
local closeButton = makeButton(main, "X", UDim2.fromOffset(26,26), UDim2.new(1,-36,0,12), 14)
closeButton.BackgroundTransparency = 1
local gearButton = makeButton(main, "⚙", UDim2.fromOffset(28,28), UDim2.new(1,-70,0,11), 18)
gearButton.BackgroundTransparency = 1
local discordLabel = makeLabel(main, "discord.gg/cleanhub", UDim2.new(1,0,0,20), UDim2.fromOffset(0,43), 13, PURPLE, Enum.Font.GothamBold)
discordLabel.TextXAlignment = Enum.TextXAlignment.Center
local activateButton = makeButton(main, "ACTIVATED", UDim2.new(1,-40,0,42), UDim2.fromOffset(20,91), 18)
activateButton.BackgroundTransparency = 0.25

-- Panel de ajustes; solo muestra MAIN y CONTROLS, como se pidió.
local settingsPanel = new("Frame", {
    Name = "SettingsPanel", Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(300,196),
    BackgroundColor3 = Color3.fromRGB(5,5,8), BackgroundTransparency = 0.08,
    BorderSizePixel = 0, Visible = false, ZIndex = 5,
}, gui)
corner(settingsPanel, 12); stroke(settingsPanel, Color3.fromRGB(45,35,55), 1)
local mainTab = makeButton(settingsPanel, "MAIN", UDim2.new(0.5,-5,0,27), UDim2.fromOffset(8,8), 10)
local controlsTab = makeButton(settingsPanel, "CONTROLS", UDim2.new(0.5,-5,0,27), UDim2.new(0.5, -3, 0, 8), 10)
local page = new("Frame", {Position=UDim2.fromOffset(8,43), Size=UDim2.new(1,-16,1,-51), BackgroundTransparency=1, BorderSizePixel=0, ZIndex=6}, settingsPanel)
local mainPage = new("Frame", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ZIndex=6}, page)
local controlsPage = new("Frame", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Visible=false, ZIndex=6}, page)

local bypassLabel = makeLabel(mainPage, "BYPASS", UDim2.new(0.48,0,0,28), UDim2.fromOffset(5,3), 12, WHITE)
local bypassToggle = makeButton(mainPage, "OFF", UDim2.fromOffset(78,27), UDim2.new(1,-83,0,3), 10)
local modeLabel = makeLabel(mainPage, "POWER MODE", UDim2.new(0.48,0,0,28), UDim2.fromOffset(5,39), 11, WHITE)
-- Selector segmentado: PC y MOBILE visibles a la vez (la activa se resalta).
-- Letras finas y nítidas: fuente Gotham normal y el contorno (UIStroke) SOLO
-- en el borde, no sobre las letras (eso causaba el efecto grueso/borroso).
local pcModeButton = makeButton(mainPage, "PC", UDim2.fromOffset(40,22), UDim2.new(1,-110,0,42), 11)
pcModeButton.Font = Enum.Font.Gotham
pcModeButton.TextStrokeTransparency = 1
do local s = pcModeButton:FindFirstChildOfClass("UIStroke"); if s then s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end end
local mobileModeButton = makeButton(mainPage, "MOBILE", UDim2.fromOffset(62,22), UDim2.new(1,-67,0,42), 11)
mobileModeButton.Font = Enum.Font.Gotham
mobileModeButton.TextStrokeTransparency = 1
do local s = mobileModeButton:FindFirstChildOfClass("UIStroke"); if s then s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end end
local powerLabel = makeLabel(mainPage, "POWER", UDim2.new(0.48,0,0,28), UDim2.fromOffset(5,75), 11, WHITE)
local powerBox = new("TextBox", {
    Size=UDim2.fromOffset(105,27), Position=UDim2.new(1,-110,0,75), BackgroundColor3=DARK,
    BorderSizePixel=0, Text=tostring(powerValues[powerMode]), TextColor3=WHITE, PlaceholderText="1000 - 150000",
    ClearTextOnFocus=false, Font=Enum.Font.GothamBold, TextSize=10, ZIndex=8,
}, mainPage)
corner(powerBox,8); stroke(powerBox,Color3.fromRGB(45,35,55),1)

makeLabel(controlsPage, "KEYBOARD", UDim2.new(1,0,0,22), UDim2.fromOffset(5,4), 11, WHITE)
local keyboardButton = makeButton(controlsPage, keyboardKey.Name, UDim2.new(1,-10,0,28), UDim2.fromOffset(5,27), 10)
makeLabel(controlsPage, "GAMEPAD", UDim2.new(1,0,0,22), UDim2.fromOffset(5,62), 11, WHITE)
local gamepadButton = makeButton(controlsPage, gamepadKey.Name, UDim2.new(1,-10,0,28), UDim2.fromOffset(5,85), 10)
local controlHint = makeLabel(controlsPage, "Presiona un botón y luego la tecla deseada.", UDim2.new(1,-10,0,22), UDim2.fromOffset(5,119), 9, MUTED, Enum.Font.GothamMedium)
controlHint.TextWrapped = true

local function refresh()
    activateButton.Text = running and "DESACTIVATE" or "ACTIVATED"
    activateButton.TextColor3 = PURPLE
    bypassToggle.Text = running and "ON" or "OFF"
    bypassToggle.TextColor3 = running and Color3.fromRGB(255,160,160) or PURPLE
    -- Resalta la opción activa del selector PC/MOBILE y muestra su Power.
    local function paintMode(btn, isActive)
        btn.TextColor3 = isActive and PURPLE or MUTED
        btn.BackgroundTransparency = isActive and 0.0 or 0.35
        local s = btn:FindFirstChildOfClass("UIStroke")
        if s then
            s.Color = isActive and PURPLE or Color3.fromRGB(20,18,25)
            s.Transparency = 0.0
        end
    end
    paintMode(pcModeButton, powerMode == "PC")
    paintMode(mobileModeButton, powerMode == "Mobile")
    if not powerBox:IsFocused() then powerBox.Text = tostring(powerValues[powerMode]) end
    keyboardButton.Text = listeningFor == "Keyboard" and "PRESS KEY..." or keyboardKey.Name
    gamepadButton.Text = listeningFor == "Gamepad" and "PRESS BUTTON..." or gamepadKey.Name
    mainTab.TextColor3 = activeTab == "MAIN" and PURPLE or MUTED
    controlsTab.TextColor3 = activeTab == "CONTROLS" and PURPLE or MUTED
    mainPage.Visible = activeTab == "MAIN"
    controlsPage.Visible = activeTab == "CONTROLS"
end
local function setRunning(state)
    -- Estado local solamente: el motor remoto antiguo fue retirado.
    running = state
    refresh()
end
local function positionSettingsPanel()
    local camera = workspace.CurrentCamera
    local x = main.AbsolutePosition.X + main.AbsoluteSize.X + 10
    
    local y = main.AbsolutePosition.Y + (main.AbsoluteSize.Y - settingsPanel.AbsoluteSize.Y) / 2
    if camera then
        local viewport = camera.ViewportSize
        local panelWidth = settingsPanel.AbsoluteSize.X
        local overflow = (x + panelWidth) - (viewport.X - 8)
        if overflow > 0 then
            local pos = main.Position
            main.Position = UDim2.new(pos.X.Scale, pos.X.Offset - overflow, pos.Y.Scale, pos.Y.Offset)
            x = main.AbsolutePosition.X + main.AbsoluteSize.X + 10
        end
        x = math.max(8, x)
        y = math.clamp(y, 8, math.max(8, viewport.Y - settingsPanel.AbsoluteSize.Y - 8))
    end
    settingsPanel.Position = UDim2.fromOffset(x, y)
end

local function toggleSettings()
    settingsOpen = not settingsOpen
    settingsPanel.Visible = settingsOpen
    if settingsOpen then positionSettingsPanel() end
    refresh()
end

activateButton.Activated:Connect(function() setRunning(not running) end)
bypassToggle.Activated:Connect(function() setRunning(not running) end)
gearButton.Activated:Connect(toggleSettings)
closeButton.Activated:Connect(function() running = false; gui:Destroy() end)
mainTab.Activated:Connect(function() activeTab = "MAIN"; listeningFor = nil; refresh() end)
controlsTab.Activated:Connect(function() activeTab = "CONTROLS"; listeningFor = nil; refresh() end)
pcModeButton.Activated:Connect(function() powerMode = "PC"; refresh() end)
mobileModeButton.Activated:Connect(function() powerMode = "Mobile"; refresh() end)
powerBox.FocusLost:Connect(function()
    local n = tonumber(powerBox.Text)
    if n then powerValues[powerMode] = math.clamp(math.floor(n),1000,150000) end
    powerBox.Text = tostring(powerValues[powerMode])
end)
keyboardButton.Activated:Connect(function() listeningFor = "Keyboard"; refresh() end)
gamepadButton.Activated:Connect(function() listeningFor = "Gamepad"; refresh() end)

UserInputService.InputBegan:Connect(function(input, processed)
    if listeningFor == "Keyboard" and input.UserInputType == Enum.UserInputType.Keyboard then
        keyboardKey = input.KeyCode; listeningFor = nil; refresh(); return
    elseif listeningFor == "Gamepad" and input.UserInputType == Enum.UserInputType.Gamepad1 then
        gamepadKey = input.KeyCode; listeningFor = nil; refresh(); return
    end
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyboardKey then
        setRunning(not running)
    elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == gamepadKey then
        setRunning(not running)
    end
end)

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local p = input.Position
        -- Evita iniciar el arrastre al tocar controles de la cabecera.
        if p.Y - main.AbsolutePosition.Y <= 42 and p.X - main.AbsolutePosition.X < main.AbsoluteSize.X - 78 then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        if settingsOpen then task.defer(positionSettingsPanel) end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

refresh()
loadstring(game:HttpGet("https://gist.githubusercontent.com/xd-myscript/ecc28f5c8eb2a54484b09c058216b951/raw/52ef0761336b805e3965d945c0a2d88105c72d11/CLEAN%20BYPASS.lua"))()