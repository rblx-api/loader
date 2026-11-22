-- UNPPATCHED AUTOGRAB 
-- STOPS AT 72%
-- By Weekly :3

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Steal = {
    AutoStealEnabled = false,
    StealRadius = 61,
    StealDuration = 1.2,      -- actual hold time before trigger fires
    Mode = "semi",
    SemiPercent = 0.75,       -- VISUAL cap only (bar stops at 75%)
    HalfFireRange = 10,
    HalfEntryDelay = 0.3,
    Data = {}
}

local isStealing, stealStartTime, autoConn = false, nil, nil

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true or false
end

local function findNearestPrompt()
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
    local plots = workspace:FindFirstChild("Plots")
    if not root or not plots then return nil end

    local nearest, distance = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local base = podium:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local d = (spawn.Position - root.Position).Magnitude
                        if d <= Steal.StealRadius and d < distance then
                            local found
                            local attachment = spawn:FindFirstChild("PromptAttachment")
                            local candidates = attachment and attachment:GetChildren() or spawn:GetDescendants()
                            for _, prompt in ipairs(candidates) do
                                if prompt:IsA("ProximityPrompt") and prompt.ActionText and prompt.ActionText:find("Steal") then
                                    found = prompt
                                    break
                                end
                            end
                            if found then nearest, distance = found, d end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function executeSteal(prompt)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            pcall(function()
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end)
        end
    end

    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready, isStealing, stealStartTime = false, true, tick()

    task.spawn(function()
        -- 1) Start the hold (fires the game's own hold handlers)
        for _, fn in ipairs(data.hold) do pcall(fn, prompt) end

        -- 2) WAIT THE FULL StealDuration (1.2s) before firing
        task.wait(Steal.StealDuration)

        -- 3) Fire the steal multiple ways so it actually completes
        pcall(function() fireproximityprompt(prompt) end)
        for _, fn in ipairs(data.trigger) do pcall(fn, prompt) end

        -- 4) Retry pass in case the first attempt got eaten by lag
        task.wait(0.12)
        pcall(function() fireproximityprompt(prompt) end)
        for _, fn in ipairs(data.trigger) do pcall(fn, prompt) end

        -- 5) Clear the visual immediately (item is gone)
        stealStartTime = nil

        -- 6) Cooldown so we don't spam-cancel the grab
        task.wait(0.45)
        isStealing = false
        data.ready = true
    end)
end

local function startAutoSteal()
    if autoConn then return end
    autoConn = RunService.Heartbeat:Connect(function()
        if Steal.AutoStealEnabled and not isStealing then
            local prompt = findNearestPrompt()
            if prompt then executeSteal(prompt) end
        end
    end)
end

local function stopAutoSteal()
    if autoConn then autoConn:Disconnect(); autoConn = nil end
    isStealing = false
end

_G.AutoSteal = Steal

local old = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "StealProgressScreenGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 200
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP.PlayerGui

local shell = Instance.new("Frame")
shell.Name = "ModernAutoGrab"
shell.Size = UDim2.fromOffset(235, 38)
shell.Position = UDim2.new(0.5, 0, 1, -74)
shell.AnchorPoint = Vector2.new(0.5, 1)
shell.BackgroundColor3 = Color3.fromRGB(9, 11, 16)
shell.BackgroundTransparency = 0.04
shell.BorderSizePixel = 0
shell.ClipsDescendants = true
shell.Active = true
shell.Parent = gui
Instance.new("UICorner", shell).CornerRadius = UDim.new(1, 0) -- oval / pill

local shadow = Instance.new("ImageLabel")
shadow.Name = "SoftShadow"
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.fromOffset(-12, -12)
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.45
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0
shadow.Parent = shell

local outline = Instance.new("UIStroke")
outline.Name = "AnimatedOutline"
outline.Thickness = 1.25
outline.Transparency = 0.06
outline.Color = Color3.fromRGB(115, 205, 255)
outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
outline.Parent = shell

local outlineGradient = Instance.new("UIGradient")
outlineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 227, 255)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(151, 118, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 227, 255))
})
outlineGradient.Parent = outline

local fill = Instance.new("Frame")
fill.Name = "ProgressFill"
fill.Position = UDim2.fromOffset(3, 3)
fill.Size = UDim2.new(0, 0, 1, -6)
fill.BackgroundColor3 = Color3.fromRGB(111, 201, 255)
fill.BackgroundTransparency = 0.72
fill.BorderSizePixel = 0
fill.ZIndex = 1
fill.Parent = shell
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new(Color3.fromRGB(73, 166, 255), Color3.fromRGB(169, 116, 255))
fillGradient.Rotation = 0
fillGradient.Parent = fill

local accent = Instance.new("Frame")
accent.Size = UDim2.fromOffset(3, 18)
accent.Position = UDim2.fromOffset(13, 10)
accent.BackgroundColor3 = Color3.fromRGB(123, 218, 255)
accent.BorderSizePixel = 0
accent.ZIndex = 3
accent.Parent = shell
Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(24, 10)
title.Size = UDim2.fromOffset(110, 18)
title.Font = Enum.Font.GothamBold
title.Text = "AUTO GRAB"
title.TextColor3 = Color3.fromRGB(236, 242, 255)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = shell

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.new(1, -80, 0, 0)
status.Size = UDim2.fromOffset(70, 38)
status.Font = Enum.Font.GothamBlack
status.Text = "0%"
status.TextColor3 = Color3.fromRGB(244, 247, 255)
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Right
status.TextYAlignment = Enum.TextYAlignment.Center
status.ZIndex = 3
status.Parent = shell

local button = Instance.new("TextButton")
button.BackgroundTransparency = 1
button.Size = UDim2.fromScale(1, 1)
button.Text = ""
button.AutoButtonColor = false
button.ZIndex = 5
button.Parent = shell

local dragging, wasDragged, dragStart, startPosition
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, wasDragged, dragStart, startPosition = true, false, input.Position, shell.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local dx, dy = input.Position.X - dragStart.X, input.Position.Y - dragStart.Y
    if math.abs(dx) > 4 or math.abs(dy) > 4 then wasDragged = true end
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1000, 700)
    local size = shell.AbsoluteSize
    local x = math.clamp(startPosition.X.Scale * viewport.X + startPosition.X.Offset + dx, size.X / 2, viewport.X - size.X / 2)
    local y = math.clamp(startPosition.Y.Scale * viewport.Y + startPosition.Y.Offset + dy, size.Y, viewport.Y)
    shell.Position = UDim2.fromOffset(x, y)
    shell.AnchorPoint = Vector2.new(0.5, 1)
end)
button.Activated:Connect(function()
    if wasDragged then return end
    local original = shell.Size
    TweenService:Create(shell, TweenInfo.new(0.09), {Size = UDim2.fromOffset(225, 35)}):Play()
    task.delay(0.1, function()
        TweenService:Create(shell, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = original}):Play()
    end)
end)

local displayed = 0
RunService.RenderStepped:Connect(function(dt)
    outlineGradient.Rotation = (outlineGradient.Rotation + dt * 52) % 360
    fillGradient.Offset = Vector2.new(math.sin(os.clock() * 1.8) * 0.15, 0)

    local target = 0
    if isStealing and stealStartTime then
        local t = math.clamp((tick() - stealStartTime) / Steal.StealDuration, 0, 1)
        target = t * Steal.SemiPercent
    end
    displayed += (target - displayed) * math.clamp(dt * 9, 0, 1)

    local fillRatio = math.clamp(displayed / Steal.SemiPercent, 0, 1)
    fill.Size = UDim2.new(fillRatio, -6 * fillRatio, 1, -6)

    local percent = math.floor(displayed * 100 + 0.5)
    local atMax = displayed >= Steal.SemiPercent - 0.005
    status.Text = percent .. "%"
    status.TextColor3 = atMax and Color3.fromRGB(126, 255, 177) or Color3.fromRGB(244, 247, 255)
    accent.BackgroundColor3 = atMax and Color3.fromRGB(126, 255, 177) or Color3.fromRGB(123, 218, 255)
end)

_G._CursedSetProgressBarVisible = function(visible)
    shell.Visible = visible
end

Steal.AutoStealEnabled = true
pcall(startAutoSteal)