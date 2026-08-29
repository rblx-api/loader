-- 🔐 SCRIPT PROTEGIDO POR USUARIOS AUTORIZADOS
local authorizedUsers = {"Anas_neje", "22suhail2"}

-- Verificar usuario autorizado
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end

local currentUser = localPlayer.Name
local isAuthorized = false
for _, user in ipairs(authorizedUsers) do
    if user == currentUser then
        isAuthorized = true
        break
    end
end

if not isAuthorized then
    local sg = Instance.new("ScreenGui")
    sg.Name = "KeyError"
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not sg.Parent then
        pcall(function() sg.Parent = localPlayer:WaitForChild("PlayerGui") end)
    end
    if sg.Parent then
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(0.8, 0, 0, 120)
        lbl.Position = UDim2.new(0.1, 0, 0.4, 0)
        lbl.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
        lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 18
        lbl.Text = "❌ RESET HWID\n\nUsuario actual: " .. currentUser .. "\nUsuarios autorizados: " .. table.concat(authorizedUsers, ", ")
        lbl.TextWrapped = true
        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 12)
        Instance.new("UIStroke", lbl).Color = Color3.fromRGB(255, 140, 0)
        task.wait(3)
    end
    pcall(function() localPlayer:Kick("RESET HWID - Usuario no autorizado") end)
    return
end

--[[  
    ABYSS ANTI ANTI DESYNC – Freeze other players  
    Single‑button toggle, no spam, no extra fluff.  
]]  
  
-- Services  
local Players = game:GetService("Players")  
local UserInputService = game:GetService("UserInputService")  
local RunService = game:GetService("RunService")  
local TweenService = game:GetService("TweenService")  
local LocalPlayer = Players.LocalPlayer  
  
-- ============================================================  
--  CONFIG SYSTEM - SAVES TO PLAYER  
-- ============================================================  
local function saveConfig(key, value)  
    if not LocalPlayer then return end  
    local playerData = LocalPlayer:FindFirstChild("AbyssConfig")  
    if not playerData then  
        playerData = Instance.new("Folder")  
        playerData.Name = "AbyssConfig"  
        playerData.Parent = LocalPlayer  
    end  
    local entry = playerData:FindFirstChild(key)  
    if not entry then  
        entry = Instance.new("StringValue")  
        entry.Name = key  
        entry.Parent = playerData  
    end  
    entry.Value = tostring(value)  
end  
  
local function loadConfig(key, defaultValue)  
    if not LocalPlayer then return defaultValue end  
    local playerData = LocalPlayer:FindFirstChild("AbyssConfig")  
    if not playerData then return defaultValue end  
    local entry = playerData:FindFirstChild(key)  
    if not entry then return defaultValue end  
    return entry.Value  
end  
  
-- ============================================================  
--  COLOR PRESETS  
-- ============================================================  
local colorPresets = {  
    { name = "White", color = Color3.fromRGB(255, 255, 255), stroke = Color3.fromRGB(200, 200, 200), text = Color3.fromRGB(0, 0, 0) },  
    { name = "Red", color = Color3.fromRGB(200, 30, 30), stroke = Color3.fromRGB(150, 20, 20), text = Color3.fromRGB(255, 255, 255) },  
    { name = "Blue", color = Color3.fromRGB(30, 100, 255), stroke = Color3.fromRGB(20, 70, 200), text = Color3.fromRGB(255, 255, 255) },  
    { name = "Green", color = Color3.fromRGB(30, 200, 30), stroke = Color3.fromRGB(20, 150, 20), text = Color3.fromRGB(255, 255, 255) },  
    { name = "Purple", color = Color3.fromRGB(150, 30, 200), stroke = Color3.fromRGB(100, 20, 150), text = Color3.fromRGB(255, 255, 255) },  
    { name = "Orange", color = Color3.fromRGB(255, 150, 30), stroke = Color3.fromRGB(200, 100, 20), text = Color3.fromRGB(0, 0, 0) },  
}  
  
local currentColorIndex = 1  
  
-- Load saved color  
local savedColor = loadConfig("ColorIndex", nil)  
if savedColor then  
    currentColorIndex = tonumber(savedColor) or 1  
    if currentColorIndex < 1 or currentColorIndex > #colorPresets then  
        currentColorIndex = 1  
    end  
end  
  
-- ============================================================  
--  BACKGROUND PRESETS  
-- ============================================================  
local backgroundPresets = {  
    { id = "96422107830225", name = "Abyss Dark" },  
    { id = "135618230288489", name = "Abyss Light" },  
    { id = "94378105881944", name = "Void Walker" },  
    { id = "123462051776188", name = "Cyber Dream" },  
    { id = "86927365433440", name = "Abyss Default" },  
}  
  
local currentBgIndex = 1  
  
-- Load saved background  
local savedBg = loadConfig("BgIndex", nil)  
if savedBg then  
    currentBgIndex = tonumber(savedBg) or 1  
    if currentBgIndex < 1 or currentBgIndex > #backgroundPresets then  
        currentBgIndex = 1  
    end  
end  
  
-- ============================================================  
--  KEYBIND CONFIG  
-- ============================================================  
local keybinds = {  
    toggle = {  
        keyboard = loadConfig("KeybindKeyboard", "K"),  
        controller = loadConfig("KeybindController", "LB+RB")  
    }  
}  
  
-- ============================================================  
--  FEATURE LOGIC – Freeze other players  
-- ============================================================  
connections = connections or {}  
connections.FreezePlayer = connections.FreezePlayer or {}  
featureStates = featureStates or {}  
featureStates.FreezePlayer = false  
  
local function toggleFreeze(enabled)  
    if enabled then  
        featureStates.FreezePlayer = true  
  
        local conn = RunService.Stepped:Connect(function()  
            if not featureStates.FreezePlayer then  
                conn:Disconnect()  
                return  
            end  
  
            local myChar = LocalPlayer.Character  
            if not myChar then return end  
  
            for _, plr in ipairs(Players:GetPlayers()) do  
                if plr ~= LocalPlayer then  
                    local char = plr.Character  
                    if char then  
                        local hum = char:FindFirstChildWhichIsA("Humanoid")  
                        if hum then  
                            hum.WalkSpeed = 0  
                            hum.JumpPower = 0  
                            hum.AutoRotate = false  
                        end  
  
                        for _, part in ipairs(char:GetDescendants()) do  
                            if part:IsA("BasePart") then  
                                part.CanCollide = false  
                            end  
                        end  
                    end  
                end  
            end  
        end)  
  
        table.insert(connections.FreezePlayer, conn)  
  
    else  
        featureStates.FreezePlayer = false  
  
        for _, conn in ipairs(connections.FreezePlayer) do  
            if conn then  
                if typeof(conn) == "RBXScriptConnection" then  
                    conn:Disconnect()  
                elseif typeof(conn) == "thread" then  
                    task.cancel(conn)  
                end  
            end  
        end  
        connections.FreezePlayer = {}  
  
        local DEFAULT_WALK = 16  
        local DEFAULT_JUMP = 50  
        for _, plr in ipairs(Players:GetPlayers()) do  
            if plr ~= LocalPlayer then  
                local char = plr.Character  
                if char then  
                    local hum = char:FindFirstChildWhichIsA("Humanoid")  
                    if hum then  
                        hum.WalkSpeed = DEFAULT_WALK  
                        hum.JumpPower = DEFAULT_JUMP  
                        hum.AutoRotate = true  
                    end  
                end  
            end  
        end  
    end  
end  
  
-- ============================================================  
--  KEYBIND SYSTEM  
-- ============================================================  
local keybindActive = false  
local keybindToggle = false  
  
-- Controller support  
local controllerButtons = {  
    lb = false,  
    rb = false,  
    a = false,  
    b = false,  
    x = false,  
    y = false,  
    start = false,  
    select = false,  
    dpadUp = false,  
    dpadDown = false,  
    dpadLeft = false,  
    dpadRight = false,  
}  
  
-- Parse controller keybind string  
local function parseControllerKeybind(keybindStr)  
    local keys = {}  
    for key in string.gmatch(keybindStr, "[^+]+") do  
        table.insert(keys, string.lower(key))  
    end  
    return keys  
end  
  
-- Check if controller keybind is pressed  
local function checkControllerKeybind(keybindStr)  
    if not keybindStr or keybindStr == "" then return false end  
    local keys = parseControllerKeybind(keybindStr)  
    if #keys == 0 then return false end  
      
    for _, key in ipairs(keys) do  
        local keyMap = {  
            ["lb"] = "lb",  
            ["rb"] = "rb",  
            ["a"] = "a",  
            ["b"] = "b",  
            ["x"] = "x",  
            ["y"] = "y",  
            ["start"] = "start",  
            ["select"] = "select",  
            ["dpadup"] = "dpadUp",  
            ["dpaddown"] = "dpadDown",  
            ["dpadleft"] = "dpadLeft",  
            ["dpadright"] = "dpadRight",  
        }  
        local mappedKey = keyMap[key]  
        if not mappedKey or not controllerButtons[mappedKey] then  
            return false  
        end  
    end  
      
    for _, key in ipairs(keys) do  
        local keyMap = {  
            ["lb"] = "lb",  
            ["rb"] = "rb",  
            ["a"] = "a",  
            ["b"] = "b",  
            ["x"] = "x",  
            ["y"] = "y",  
            ["start"] = "start",  
            ["select"] = "select",  
            ["dpadup"] = "dpadUp",  
            ["dpaddown"] = "dpadDown",  
            ["dpadleft"] = "dpadLeft",  
            ["dpadright"] = "dpadRight",  
        }  
        local mappedKey = keyMap[key]  
        if not controllerButtons[mappedKey] then  
            return false  
        end  
    end  
    return true  
end  
  
-- Keyboard input handler  
UserInputService.InputBegan:Connect(function(input)  
    -- Check keyboard keybind  
    local keyboardKey = keybinds.toggle.keyboard  
    if keyboardKey and keyboardKey ~= "" then  
        if input.KeyCode == Enum.KeyCode[keyboardKey] then  
            keybindToggle = not keybindToggle  
            if keybindToggle then  
                setActive(not active)  
            end  
            task.wait(0.3)  
            keybindToggle = false  
        end  
    end  
      
    -- Controller buttons  
    if input.KeyCode == Enum.KeyCode.ButtonL1 then controllerButtons.lb = true end  
    if input.KeyCode == Enum.KeyCode.ButtonR1 then controllerButtons.rb = true end  
    if input.KeyCode == Enum.KeyCode.ButtonA then controllerButtons.a = true end  
    if input.KeyCode == Enum.KeyCode.ButtonB then controllerButtons.b = true end  
    if input.KeyCode == Enum.KeyCode.ButtonX then controllerButtons.x = true end  
    if input.KeyCode == Enum.KeyCode.ButtonY then controllerButtons.y = true end  
    if input.KeyCode == Enum.KeyCode.ButtonStart then controllerButtons.start = true end  
    if input.KeyCode == Enum.KeyCode.ButtonSelect then controllerButtons.select = true end  
    if input.KeyCode == Enum.KeyCode.DPadUp then controllerButtons.dpadUp = true end  
    if input.KeyCode == Enum.KeyCode.DPadDown then controllerButtons.dpadDown = true end  
    if input.KeyCode == Enum.KeyCode.DPadLeft then controllerButtons.dpadLeft = true end  
    if input.KeyCode == Enum.KeyCode.DPadRight then controllerButtons.dpadRight = true end  
      
    -- Check controller keybind  
    local controllerKey = keybinds.toggle.controller  
    if controllerKey and controllerKey ~= "" and not keybindActive then  
        if checkControllerKeybind(controllerKey) then  
            keybindActive = true  
            setActive(not active)  
            task.wait(0.3)  
            keybindActive = false  
        end  
    end  
end)  
  
UserInputService.InputEnded:Connect(function(input)  
    if input.KeyCode == Enum.KeyCode.ButtonL1 then controllerButtons.lb = false end  
    if input.KeyCode == Enum.KeyCode.ButtonR1 then controllerButtons.rb = false end  
    if input.KeyCode == Enum.KeyCode.ButtonA then controllerButtons.a = false end  
    if input.KeyCode == Enum.KeyCode.ButtonB then controllerButtons.b = false end  
    if input.KeyCode == Enum.KeyCode.ButtonX then controllerButtons.x = false end  
    if input.KeyCode == Enum.KeyCode.ButtonY then controllerButtons.y = false end  
    if input.KeyCode == Enum.KeyCode.ButtonStart then controllerButtons.start = false end  
    if input.KeyCode == Enum.KeyCode.ButtonSelect then controllerButtons.select = false end  
    if input.KeyCode == Enum.KeyCode.DPadUp then controllerButtons.dpadUp = false end  
    if input.KeyCode == Enum.KeyCode.DPadDown then controllerButtons.dpadDown = false end  
    if input.KeyCode == Enum.KeyCode.DPadLeft then controllerButtons.dpadLeft = false end  
    if input.KeyCode == Enum.KeyCode.DPadRight then controllerButtons.dpadRight = false end  
end)  
  
-- ============================================================  
--  GUI BUILDERS  
-- ============================================================  
local function getGuiParent()  
    if typeof(gethui) == "function" then  
        local ok, result = pcall(gethui)  
        if ok and result then return result end  
    end  
    local ok, core = pcall(function() return game:GetService("CoreGui") end)  
    if ok and core then return core end  
    return LocalPlayer:WaitForChild("PlayerGui")  
end  
  
local function newInstance(className, props, parent)  
    local obj = Instance.new(className)  
    for k, v in pairs(props or {}) do obj[k] = v end  
    obj.Parent = parent  
    return obj  
end  
  
local function addCorner(obj, radius)  
    return newInstance("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)  
end  
  
local function addStroke(obj, color, thickness, transparency)  
    return newInstance("UIStroke", {  
        Color = color,  
        Thickness = thickness or 1,  
        Transparency = transparency or 0,  
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,  
    }, obj)  
end  
  
-- ============================================================  
--  KEYBIND SETUP UI  
-- ============================================================  
local function openKeybindSetup(mode)  
    local keybindFrame = Instance.new("Frame")  
    keybindFrame.Size = UDim2.fromOffset(320, 180)  
    keybindFrame.Position = UDim2.new(0.5, -160, 0.5, -90)  
    keybindFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
    keybindFrame.BackgroundTransparency = 0.95  
    keybindFrame.BorderSizePixel = 0  
    keybindFrame.Active = true  
    keybindFrame.ClipsDescendants = true  
    keybindFrame.Parent = gui  
    keybindFrame.ZIndex = 100  
    addCorner(keybindFrame, 16)  
    addStroke(keybindFrame, Color3.fromRGB(100, 100, 100), 1.5)  
      
    local title = newInstance("TextLabel", {  
        Size = UDim2.new(1, -20, 0, 30),  
        Position = UDim2.fromOffset(10, 10),  
        BackgroundTransparency = 1,  
        Text = "Press a key/button combination...",  
        TextColor3 = Color3.fromRGB(255, 255, 255),  
        Font = Enum.Font.GothamBold,  
        TextSize = 14,  
        ZIndex = 101,  
    }, keybindFrame)  
      
    local waitingText = newInstance("TextLabel", {  
        Size = UDim2.new(1, -20, 0, 20),  
        Position = UDim2.fromOffset(10, 45),  
        BackgroundTransparency = 1,  
        Text = "Waiting for input...",  
        TextColor3 = Color3.fromRGB(200, 200, 200),  
        Font = Enum.Font.Gotham,  
        TextSize = 11,  
        TextXAlignment = Enum.TextXAlignment.Center,  
        ZIndex = 101,  
    }, keybindFrame)  
      
    local detectedLabel = newInstance("TextLabel", {  
        Size = UDim2.new(1, -20, 0, 30),  
        Position = UDim2.new(0, 10, 0.5, -10),  
        BackgroundTransparency = 1,  
        Text = "",  
        TextColor3 = Color3.fromRGB(255, 255, 255),  
        Font = Enum.Font.GothamBold,  
        TextSize = 16,  
        TextXAlignment = Enum.TextXAlignment.Center,  
        ZIndex = 101,  
    }, keybindFrame)  
      
    local pressedKeys = {}  
    local listening = true  
    local detectedKeys = {}  
    local inputConn  
    local inputEndConn  
      
    -- Listen for keyboard/controller input  
    inputConn = UserInputService.InputBegan:Connect(function(input)  
        if not listening then return end  
          
        if input.UserInputType == Enum.UserInputType.Keyboard then  
            local keyName = input.KeyCode.Name  
            if keyName ~= "Unknown" and not table.find(detectedKeys, keyName) then  
                table.insert(detectedKeys, keyName)  
                table.insert(pressedKeys, keyName)  
                detectedLabel.Text = table.concat(pressedKeys, " + ")  
                waitingText.Text = "Press another key or confirm below"  
            end  
        end  
          
        -- Controller buttons  
        local btnMap = {  
            [Enum.KeyCode.ButtonL1] = "LB",  
            [Enum.KeyCode.ButtonR1] = "RB",  
            [Enum.KeyCode.ButtonA] = "A",  
            [Enum.KeyCode.ButtonB] = "B",  
            [Enum.KeyCode.ButtonX] = "X",  
            [Enum.KeyCode.ButtonY] = "Y",  
            [Enum.KeyCode.ButtonStart] = "Start",  
            [Enum.KeyCode.ButtonSelect] = "Select",  
            [Enum.KeyCode.DPadUp] = "DPadUp",  
            [Enum.KeyCode.DPadDown] = "DPadDown",  
            [Enum.KeyCode.DPadLeft] = "DPadLeft",  
            [Enum.KeyCode.DPadRight] = "DPadRight",  
        }  
        local btnName = btnMap[input.KeyCode]  
        if btnName and not table.find(detectedKeys, btnName) then  
            table.insert(detectedKeys, btnName)  
            table.insert(pressedKeys, btnName)  
            detectedLabel.Text = table.concat(pressedKeys, " + ")  
            waitingText.Text = "Press another button or confirm below"  
        end  
    end)  
      
    inputEndConn = UserInputService.InputEnded:Connect(function(input)  
        if not listening then return end  
    end)  
      
    -- Confirm button  
    local confirmBtn = newInstance("TextButton", {  
        Size = UDim2.fromOffset(100, 35),  
        Position = UDim2.new(0.5, -110, 0.8, 0),  
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),  
        BorderSizePixel = 0,  
        Text = "Confirm",  
        TextColor3 = Color3.fromRGB(255, 255, 255),  
        Font = Enum.Font.GothamBold,  
        TextSize = 12,  
        ZIndex = 101,  
    }, keybindFrame)  
    addCorner(confirmBtn, 8)  
      
    confirmBtn.MouseButton1Click:Connect(function()  
        listening = false  
        inputConn:Disconnect()  
        inputEndConn:Disconnect()  
          
        if #pressedKeys > 0 then  
            local keybindStr = table.concat(pressedKeys, "+")  
            if mode == "keyboard" then  
                keybinds.toggle.keyboard = keybindStr  
                saveConfig("KeybindKeyboard", keybindStr)  
                changeKbBtn.Text = keybindStr  
            else  
                keybinds.toggle.controller = keybindStr  
                saveConfig("KeybindController", keybindStr)  
                changeCtrlBtn.Text = keybindStr  
            end  
        end  
          
        keybindFrame:Destroy()  
    end)  
      
    confirmBtn.MouseEnter:Connect(function()  
        TweenService:Create(confirmBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 80, 80) }):Play()  
    end)  
    confirmBtn.MouseLeave:Connect(function()  
        TweenService:Create(confirmBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()  
    end)  
      
    -- Cancel button  
    local cancelBtn = newInstance("TextButton", {  
        Size = UDim2.fromOffset(100, 35),  
        Position = UDim2.new(0.5, 10, 0.8, 0),  
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
        BorderSizePixel = 0,  
        Text = "Cancel",  
        TextColor3 = Color3.fromRGB(200, 200, 200),  
        Font = Enum.Font.GothamBold,  
        TextSize = 12,  
        ZIndex = 101,  
    }, keybindFrame)  
    addCorner(cancelBtn, 8)  
      
    cancelBtn.MouseButton1Click:Connect(function()  
        listening = false  
        inputConn:Disconnect()  
        inputEndConn:Disconnect()  
        if mode == "keyboard" then  
            changeKbBtn.Text = keybinds.toggle.keyboard  
        else  
            changeCtrlBtn.Text = keybinds.toggle.controller  
        end  
        keybindFrame:Destroy()  
    end)  
      
    cancelBtn.MouseEnter:Connect(function()  
        TweenService:Create(cancelBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()  
    end)  
    cancelBtn.MouseLeave:Connect(function()  
        TweenService:Create(cancelBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()  
    end)  
end  
  
-- ============================================================  
--  BUILD THE GUI - SQUIRCLE SHAPE  
-- ============================================================  
local parent = getGuiParent()  
local existing = parent:FindFirstChild("AbyssAntiAntiDesyncGui")  
if existing then existing:Destroy() end  
  
local gui = newInstance("ScreenGui", {  
    Name = "AbyssAntiAntiDesyncGui",  
    ResetOnSpawn = false,  
    IgnoreGuiInset = true,  
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,  
})  
  
if type(syn) == "table" and type(syn.protect_gui) == "function" then  
    pcall(syn.protect_gui, gui)  
elseif typeof(protectgui) == "function" then  
    pcall(protectgui, gui)  
end  
  
pcall(function() gui.Parent = parent end)  
if not gui.Parent then  
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")  
end  
  
-- Get current color  
local currentColor = colorPresets[currentColorIndex]  
  
-- Main container - SQUIRCLE  
local frame = newInstance("Frame", {  
    Size = UDim2.fromOffset(280, 295),  
    Position = UDim2.new(0.5, -140, 0.5, -147),  
    BackgroundColor3 = currentColor.color,  
    BorderSizePixel = 0,  
    ClipsDescendants = true,  
    Active = true,  
    ZIndex = 40,  
}, gui)  
local frameCorner = addCorner(frame, 28)  
local frameStroke = addStroke(frame, currentColor.stroke, 1.5)  
  
-- Inner holder  
local holder = newInstance("Frame", {  
    Size = UDim2.new(1, -6, 1, -6),  
    Position = UDim2.fromOffset(3, 3),  
    BackgroundTransparency = 1,  
    BorderSizePixel = 0,  
    ClipsDescendants = true,  
    ZIndex = 40,  
}, frame)  
addCorner(holder, 24)  
  
-- Background image  
local bgImage = newInstance("ImageLabel", {  
    Size = UDim2.fromScale(1, 1),  
    BackgroundTransparency = 1,  
    Image = "rbxassetid://" .. backgroundPresets[currentBgIndex].id,  
    ScaleType = Enum.ScaleType.Crop,  
    ImageTransparency = 0.15,  
    ImageColor3 = Color3.fromRGB(255, 255, 255),  
    ZIndex = 40,  
}, holder)  
addCorner(bgImage, 24)  
  
-- Dark overlay  
local overlay = newInstance("Frame", {  
    Size = UDim2.fromScale(1, 1),  
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),  
    BackgroundTransparency = 0.65,  
    BorderSizePixel = 0,  
    ZIndex = 41,  
}, holder)  
addCorner(overlay, 24)  
  
-- Header  
local header = newInstance("Frame", {  
    Size = UDim2.new(1, 0, 0, 42),  
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),  
    BorderSizePixel = 0,  
    ClipsDescendants = true,  
    ZIndex = 42,  
}, holder)  
local headerCorner = Instance.new("UICorner")  
headerCorner.Parent = header  
headerCorner.CornerRadius = UDim.new(0, 12)  
  
-- Header bottom line  
newInstance("Frame", {  
    Size = UDim2.new(1, 0, 0, 1),  
    Position = UDim2.new(0, 0, 1, -1),  
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),  
    BorderSizePixel = 0,  
    ZIndex = 43,  
}, header)  
  
-- Header title  
local titleFrame = newInstance("Frame", {  
    Size = UDim2.new(1, 0, 1, 0),  
    BackgroundTransparency = 1,  
    ZIndex = 43,  
}, header)  
  
newInstance("TextLabel", {  
    Size = UDim2.new(1, -100, 1, 0),  
    Position = UDim2.fromOffset(16, 0),  
    BackgroundTransparency = 1,  
    Text = "ABYSS ANTI ANTI DESYNC",  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    TextScaled = false,  
    ZIndex = 44,  
}, titleFrame)  
  
-- Close button  
local closeBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(28, 28),  
    Position = UDim2.new(1, -34, 0.5, -14),  
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),  
    BorderSizePixel = 0,  
    Text = "−",  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamMedium,  
    TextSize = 18,  
    ZIndex = 44,  
}, header)  
addCorner(closeBtn, 7)  
  
-- Toggle button (changes color with GUI)  
local toggleBtn = newInstance("TextButton", {  
    Size = UDim2.new(1, -20, 0, 44),  
    Position = UDim2.fromOffset(10, 52),  
    BackgroundColor3 = currentColor.color,  
    BorderSizePixel = 0,  
    AutoButtonColor = false,  
    Text = "ACTIVATE",  
    TextColor3 = currentColor.text,  
    Font = Enum.Font.GothamBold,  
    TextSize = 14,  
    TextScaled = false,  
    ZIndex = 42,  
}, holder)  
local toggleCorner = addCorner(toggleBtn, 12)  
local toggleStroke = addStroke(toggleBtn, currentColor.stroke, 0.5)  
  
-- Status text  
local statusText = newInstance("TextLabel", {  
    Size = UDim2.new(1, -20, 0, 16),  
    Position = UDim2.fromOffset(10, 102),  
    BackgroundTransparency = 1,  
    Text = "STATUS: OFF",  
    TextColor3 = Color3.fromRGB(200, 200, 200),  
    Font = Enum.Font.GothamMedium,  
    TextSize = 10,  
    TextScaled = false,  
    TextXAlignment = Enum.TextXAlignment.Center,  
    ZIndex = 42,  
}, holder)  
  
-- Divider line  
newInstance("Frame", {  
    Size = UDim2.new(0.85, 0, 0, 1),  
    Position = UDim2.new(0.075, 0, 0, 126),  
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),  
    BorderSizePixel = 0,  
    ZIndex = 42,  
}, holder)  
  
-- Keybind Labels  
newInstance("TextLabel", {  
    Size = UDim2.new(0.5, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 136),  
    BackgroundTransparency = 1,  
    Text = "KEYBINDS:",  
    TextColor3 = Color3.fromRGB(200, 200, 200),  
    Font = Enum.Font.GothamBold,  
    TextSize = 10,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
newInstance("TextLabel", {  
    Size = UDim2.new(0.4, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 152),  
    BackgroundTransparency = 1,  
    Text = "Keyboard:",  
    TextColor3 = Color3.fromRGB(180, 180, 180),  
    Font = Enum.Font.Gotham,  
    TextSize = 9,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
newInstance("TextLabel", {  
    Size = UDim2.new(0.4, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 168),  
    BackgroundTransparency = 1,  
    Text = "Controller:",  
    TextColor3 = Color3.fromRGB(180, 180, 180),  
    Font = Enum.Font.Gotham,  
    TextSize = 9,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
-- Change keyboard keybind button  
local changeKbBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(50, 18),  
    Position = UDim2.new(0.55, 0, 0, 150),  
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
    BorderSizePixel = 0,  
    Text = keybinds.toggle.keyboard,  
    TextColor3 = Color3.fromRGB(200, 200, 200),  
    Font = Enum.Font.Gotham,  
    TextSize = 9,  
    ZIndex = 42,  
}, holder)  
addCorner(changeKbBtn, 6)  
  
-- Change controller keybind button  
local changeCtrlBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(50, 18),  
    Position = UDim2.new(0.55, 0, 0, 166),  
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
    BorderSizePixel = 0,  
    Text = keybinds.toggle.controller,  
    TextColor3 = Color3.fromRGB(200, 200, 200),  
    Font = Enum.Font.Gotham,  
    TextSize = 9,  
    ZIndex = 42,  
}, holder)  
addCorner(changeCtrlBtn, 6)  
  
-- Keyboard change button  
changeKbBtn.MouseButton1Click:Connect(function()  
    changeKbBtn.Text = "..."  
    openKeybindSetup("keyboard")  
end)  
  
changeKbBtn.MouseEnter:Connect(function()  
    TweenService:Create(changeKbBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()  
end)  
changeKbBtn.MouseLeave:Connect(function()  
    TweenService:Create(changeKbBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()  
end)  
  
-- Controller change button  
changeCtrlBtn.MouseButton1Click:Connect(function()  
    changeCtrlBtn.Text = "..."  
    openKeybindSetup("controller")  
end)  
  
changeCtrlBtn.MouseEnter:Connect(function()  
    TweenService:Create(changeCtrlBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()  
end)  
changeCtrlBtn.MouseLeave:Connect(function()  
    TweenService:Create(changeCtrlBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()  
end)  
  
-- Divider line 2  
newInstance("Frame", {  
    Size = UDim2.new(0.85, 0, 0, 1),  
    Position = UDim2.new(0.075, 0, 0, 190),  
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),  
    BorderSizePixel = 0,  
    ZIndex = 42,  
}, holder)  
  
-- Background section  
newInstance("TextLabel", {  
    Size = UDim2.new(0.4, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 200),  
    BackgroundTransparency = 1,  
    Text = "Background:",  
    TextColor3 = Color3.fromRGB(200, 200, 200),  
    Font = Enum.Font.Gotham,  
    TextSize = 9,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
-- Background name display  
local bgNameLabel = newInstance("TextLabel", {  
    Size = UDim2.new(0.4, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 215),  
    BackgroundTransparency = 1,  
    Text = backgroundPresets[currentBgIndex].name,  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 9,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
-- Previous arrow button  
local prevContainer = newInstance("Frame", {  
    Size = UDim2.fromOffset(40, 26),  
    Position = UDim2.new(0.5, -46, 0, 207),  
    BackgroundTransparency = 1,  
    ZIndex = 42,  
}, holder)  
  
local prevBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(40, 26),  
    Position = UDim2.fromOffset(0, 0),  
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
    BorderSizePixel = 0,  
    Text = "◀",  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 14,  
    ZIndex = 42,  
}, prevContainer)  
addCorner(prevBtn, 8)  
  
-- Next arrow button  
local nextContainer = newInstance("Frame", {  
    Size = UDim2.fromOffset(40, 26),  
    Position = UDim2.new(0.5, 6, 0, 207),  
    BackgroundTransparency = 1,  
    ZIndex = 42,  
}, holder)  
  
local nextBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(40, 26),  
    Position = UDim2.fromOffset(0, 0),  
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
    BorderSizePixel = 0,  
    Text = "▶",  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 14,  
    ZIndex = 42,  
}, nextContainer)  
addCorner(nextBtn, 8)  
  
-- Divider line 3  
newInstance("Frame", {  
    Size = UDim2.new(0.85, 0, 0, 1),  
    Position = UDim2.new(0.075, 0, 0, 237),  
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),  
    BorderSizePixel = 0,  
    ZIndex = 42,  
}, holder)  
  
-- Color section  
newInstance("TextLabel", {  
    Size = UDim2.new(0.4, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 247),  
    BackgroundTransparency = 1,  
    Text = "Color:",  
    TextColor3 = Color3.fromRGB(200, 200, 200),  
    Font = Enum.Font.Gotham,  
    TextSize = 9,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
-- Color name display  
local colorNameLabel = newInstance("TextLabel", {  
    Size = UDim2.new(0.3, 0, 0, 14),  
    Position = UDim2.fromOffset(12, 262),  
    BackgroundTransparency = 1,  
    Text = colorPresets[currentColorIndex].name,  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 9,  
    TextXAlignment = Enum.TextXAlignment.Left,  
    ZIndex = 42,  
}, holder)  
  
-- Color preview dot  
local colorDot = newInstance("Frame", {  
    Size = UDim2.fromOffset(14, 14),  
    Position = UDim2.new(0.3, 5, 0, 248),  
    BackgroundColor3 = currentColor.color,  
    BorderSizePixel = 0,  
    ZIndex = 42,  
}, holder)  
addCorner(colorDot, 7)  
addStroke(colorDot, Color3.fromRGB(80, 80, 80), 0.5)  
  
-- Previous color arrow  
local prevColorBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(40, 26),  
    Position = UDim2.new(0.5, -46, 0, 249),  
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
    BorderSizePixel = 0,  
    Text = "◀",  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 14,  
    ZIndex = 42,  
}, holder)  
addCorner(prevColorBtn, 8)  
  
-- Next color arrow  
local nextColorBtn = newInstance("TextButton", {  
    Size = UDim2.fromOffset(40, 26),  
    Position = UDim2.new(0.5, 6, 0, 249),  
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),  
    BorderSizePixel = 0,  
    Text = "▶",  
    TextColor3 = Color3.fromRGB(255, 255, 255),  
    Font = Enum.Font.GothamBold,  
    TextSize = 14,  
    ZIndex = 42,  
}, holder)  
addCorner(nextColorBtn, 8)  
  
-- ============================================================  
--  COLOR CHANGE FUNCTION (UPDATES TOGGLE BUTTON TOO)  
-- ============================================================  
local function changeColor(index)  
    if index < 1 then  
        index = #colorPresets  
    elseif index > #colorPresets then  
        index = 1  
    end  
    currentColorIndex = index  
    saveConfig("ColorIndex", currentColorIndex)  
      
    local preset = colorPresets[currentColorIndex]  
    colorDot.BackgroundColor3 = preset.color  
    colorNameLabel.Text = preset.name  
      
    -- Animate the color change on main frame  
    TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundColor3 = preset.color }):Play()  
    TweenService:Create(frameStroke, TweenInfo.new(0.3), { Color = preset.stroke }):Play()  
      
    -- Update toggle button colors  
    TweenService:Create(toggleBtn, TweenInfo.new(0.3), { BackgroundColor3 = preset.color }):Play()  
    TweenService:Create(toggleBtn, TweenInfo.new(0.3), { TextColor3 = preset.text }):Play()  
    TweenService:Create(toggleStroke, TweenInfo.new(0.3), { Color = preset.stroke }):Play()  
end  
  
-- ============================================================  
--  BACKGROUND CHANGE FUNCTION  
-- ============================================================  
local function changeBackground(index)  
    if index < 1 then  
        index = #backgroundPresets  
    elseif index > #backgroundPresets then  
        index = 1  
    end  
    currentBgIndex = index  
    saveConfig("BgIndex", currentBgIndex)  
      
    local preset = backgroundPresets[currentBgIndex]  
      
    TweenService:Create(bgImage, TweenInfo.new(0.2), { ImageTransparency = 0.8 }):Play()  
    TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 0.8 }):Play()  
      
    task.wait(0.2)  
      
    bgImage.Image = "rbxassetid://" .. preset.id  
    bgNameLabel.Text = preset.name  
      
    TweenService:Create(bgImage, TweenInfo.new(0.3), { ImageTransparency = 0.15 }):Play()  
    TweenService:Create(overlay, TweenInfo.new(0.3), { BackgroundTransparency = 0.65 }):Play()  
end  
  
-- ============================================================  
--  BUTTON EVENTS  
-- ============================================================  
  
-- Background arrows  
prevBtn.MouseButton1Click:Connect(function()  
    TweenService:Create(prevBtn, TweenInfo.new(0.08), { Size = UDim2.fromOffset(36, 22) }):Play()  
    task.wait(0.08)  
    TweenService:Create(prevBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(40, 26) }):Play()  
    task.wait(0.1)  
    changeBackground(currentBgIndex - 1)  
end)  
  
nextBtn.MouseButton1Click:Connect(function()  
    TweenService:Create(nextBtn, TweenInfo.new(0.08), { Size = UDim2.fromOffset(36, 22) }):Play()  
    task.wait(0.08)  
    TweenService:Create(nextBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(40, 26) }):Play()  
    task.wait(0.1)  
    changeBackground(currentBgIndex + 1)  
end)  
  
-- Color arrows  
prevColorBtn.MouseButton1Click:Connect(function()  
    TweenService:Create(prevColorBtn, TweenInfo.new(0.08), { Size = UDim2.fromOffset(36, 22) }):Play()  
    task.wait(0.08)  
    TweenService:Create(prevColorBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(40, 26) }):Play()  
    task.wait(0.1)  
    changeColor(currentColorIndex - 1)  
end)  
  
nextColorBtn.MouseButton1Click:Connect(function()  
    TweenService:Create(nextColorBtn, TweenInfo.new(0.08), { Size = UDim2.fromOffset(36, 22) }):Play()  
    task.wait(0.08)  
    TweenService:Create(nextColorBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(40, 26) }):Play()  
    task.wait(0.1)  
    changeColor(currentColorIndex + 1)  
end)  
  
-- Hover effects for all arrow buttons  
local function setupHover(btn)  
    btn.MouseEnter:Connect(function()  
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(60, 60, 60) }):Play()  
        TweenService:Create(btn, TweenInfo.new(0.15), { Size = UDim2.fromOffset(42, 28) }):Play()  
    end)  
    btn.MouseLeave:Connect(function()  
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()  
        TweenService:Create(btn, TweenInfo.new(0.15), { Size = UDim2.fromOffset(40, 26) }):Play()  
    end)  
end  
  
setupHover(prevBtn)  
setupHover(nextBtn)  
setupHover(prevColorBtn)  
setupHover(nextColorBtn)  
  
-- ============================================================  
--  MINIMIZE / RESTORE FUNCTIONALITY  
-- ============================================================  
local isMinimized = false  
local fullSize = UDim2.fromOffset(280, 295)  
local minimizedSize = UDim2.fromOffset(280, 42)  
  
local function minimizeGUI()  
    if isMinimized then return end  
    isMinimized = true  
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {  
        Size = minimizedSize,  
        Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset,   
                            frame.Position.Y.Scale, frame.Position.Y.Offset + 126)  
    }):Play()  
    closeBtn.Text = "+"  
    statusText.Visible = false  
    toggleBtn.Visible = false  
    prevBtn.Visible = false  
    nextBtn.Visible = false  
    prevColorBtn.Visible = false  
    nextColorBtn.Visible = false  
    changeKbBtn.Visible = false  
    changeCtrlBtn.Visible = false  
    bgNameLabel.Visible = false  
    colorNameLabel.Visible = false  
    colorDot.Visible = false  
end  
  
local function restoreGUI()  
    if not isMinimized then return end  
    isMinimized = false  
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {  
        Size = fullSize,  
        Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset,  
                            frame.Position.Y.Scale, frame.Position.Y.Offset - 126)  
    }):Play()  
    closeBtn.Text = "−"  
    statusText.Visible = true  
    toggleBtn.Visible = true  
    prevBtn.Visible = true  
    nextBtn.Visible = true  
    prevColorBtn.Visible = true  
    nextColorBtn.Visible = true  
    changeKbBtn.Visible = true  
    changeCtrlBtn.Visible = true  
    bgNameLabel.Visible = true  
    colorNameLabel.Visible = true  
    colorDot.Visible = true  
end  
  
closeBtn.MouseButton1Click:Connect(function()  
    TweenService:Create(closeBtn, TweenInfo.new(0.08), { Size = UDim2.fromOffset(24, 24) }):Play()  
    task.wait(0.08)  
    TweenService:Create(closeBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(28, 28) }):Play()  
    task.wait(0.1)  
    if isMinimized then  
        restoreGUI()  
    else  
        minimizeGUI()  
    end  
end)  
  
closeBtn.MouseEnter:Connect(function()  
    TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 80, 80) }):Play()  
end)  
closeBtn.MouseLeave:Connect(function()  
    TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()  
end)  
  
-- ============================================================  
--  STATE & BUTTON BEHAVIOUR  
-- ============================================================  
local active = false  
  
function setActive(state)  
    active = state  
    if state then  
        toggleBtn.Text = "DEACTIVATE"  
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
        toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)  
        statusText.Text = "STATUS: ACTIVE"  
        statusText.TextColor3 = Color3.fromRGB(255, 255, 255)  
        TweenService:Create(overlay, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()  
        task.wait(0.15)  
        TweenService:Create(overlay, TweenInfo.new(0.3), { BackgroundTransparency = 0.65 }):Play()  
        toggleFreeze(true)  
    else  
        toggleBtn.Text = "ACTIVATE"  
        -- Reset toggle button to current color when deactivated  
        local preset = colorPresets[currentColorIndex]  
        toggleBtn.BackgroundColor3 = preset.color  
        toggleBtn.TextColor3 = preset.text  
        statusText.Text = "STATUS: OFF"  
        statusText.TextColor3 = Color3.fromRGB(200, 200, 200)  
        toggleFreeze(false)  
    end  
end  
  
toggleBtn.MouseButton1Click:Connect(function()  
    TweenService:Create(toggleBtn, TweenInfo.new(0.08), { Size = UDim2.new(1, -24, 0, 40) }):Play()  
    task.wait(0.08)  
    TweenService:Create(toggleBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(1, -20, 0, 44) }):Play()  
    task.wait(0.1)  
    setActive(not active)  
end)  
  
toggleBtn.MouseEnter:Connect(function()  
    local preset = colorPresets[currentColorIndex]  
    local target = active and Color3.fromRGB(230, 230, 230) or preset.color  
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), { BackgroundColor3 = target }):Play()  
end)  
toggleBtn.MouseLeave:Connect(function()  
    local preset = colorPresets[currentColorIndex]  
    local target = active and Color3.fromRGB(255, 255, 255) or preset.color  
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), { BackgroundColor3 = target }):Play()  
end)  
  
-- ============================================================  
--  DRAGGING  
-- ============================================================  
local dragging = false  
local dragStart, startPos  
  
local function onInputBegan(input)  
    if input.UserInputType == Enum.UserInputType.MouseButton1 or  
       input.UserInputType == Enum.UserInputType.Touch then  
        dragging = true  
        dragStart = input.Position  
        startPos = frame.Position  
    end  
end  
  
frame.InputBegan:Connect(onInputBegan)  
  
UserInputService.InputChanged:Connect(function(input)  
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or  
                     input.UserInputType == Enum.UserInputType.Touch) then  
        local delta = input.Position - dragStart  
        frame.Position = UDim2.new(  
            startPos.X.Scale, startPos.X.Offset + delta.X,  
            startPos.Y.Scale, startPos.Y.Offset + delta.Y  
        )  
    end  
end)  
  
UserInputService.InputEnded:Connect(function(input)  
    if input.UserInputType == Enum.UserInputType.MouseButton1 or  
       input.UserInputType == Enum.UserInputType.Touch then  
        dragging = false  
    end  
end)  
  
-- Start with the feature off  
setActive(false)  
  
print("ABYSS ANTI ANTI DESYNC loaded – click the button to freeze other players.")