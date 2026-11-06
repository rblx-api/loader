local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ExploitGui = (gethui and gethui()) or game:GetService("CoreGui")

local Theme = {
    Accent           = Color3.fromRGB(255, 255, 255),
    Accent1          = Color3.fromRGB(220, 60, 60),
    Accent2          = Color3.fromRGB(170, 30, 30),
    Error            = Color3.fromRGB(255, 60, 80),
    SurfaceHighlight = Color3.fromRGB(48, 16, 16),
    TextSecondary    = Color3.fromRGB(200, 170, 170),
}

local SharedState = { BalloonedPlayers = {}, AdminButtonCache = {} }
local ProximityAPActive = false
local SpamAllActive = false
local lastActionUse = {}
local ACTION_COOLDOWNS = {
    ragdoll = 30,
    jail = 60,
    rocket = 120,
    balloon = 30,
}

local Config = {
    ProximityRange = 15,
    Positions = { AdminPanel = { X = 0.02, Y = 0.72, OffsetX = 0, OffsetY = 0 } },
    ClickToAP = false,
    ClickToAPSingleCommand = false,
    TpSettings = { Tool = "Flying Carpet" },
    HideAdminPanel = false,
    DisableProximitySpamOnMoby = false,
    DisableProximitySpamOnKawaifu = false,
    DisableClickToAPOnMoby = false,
    DisableClickToAPOnKawaifu = false,
    CancelAPPanelOnMoby = false,
    CancelAPPanelOnKawaifu = false,
}

local function isMobyUser(player)
    if not player or not player.Character then return false end
    return player.Character:FindFirstChild("_moby_highlight") ~= nil
end

local function isKawaifuUser(player)
    if not player or not player.Character then return false end
    return player.Character:FindFirstChild("KaWaifu_NeonHighlight") ~= nil
end

local function fireClick(button)
    if not button then return false end
    local ok = pcall(function()
        if typeof(firesignal) == "function" then
            if button.MouseButton1Click then firesignal(button.MouseButton1Click) end
            if button.MouseButton1Down then firesignal(button.MouseButton1Down) end
            if button.Activated then firesignal(button.Activated) end
        else
            local x = button.AbsolutePosition.X + (button.AbsoluteSize.X / 2)
            local y = button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2) + 58
            local _vim = Instance.new("VirtualInputManager")
            _vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
            _vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end
    end)
    return ok
end

local function runAdminCommand(targetPlayer, commandName)
    if not targetPlayer or not commandName or commandName == "" then return false end
    
    local realAdminGui = nil
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui.Name == "AdminPanel" or gui.Name == "XiAdminPanel" or gui:FindFirstChild("AdminPanel", true) then
            realAdminGui = gui:FindFirstChild("AdminPanel", true) or gui
            break
        end
    end
    
    if not realAdminGui then
        for _, gui in ipairs(ExploitGui:GetChildren()) do
            if gui:FindFirstChild("AdminPanel", true) then
                realAdminGui = gui:FindFirstChild("AdminPanel", true)
                break
            end
        end
    end

    if not realAdminGui then return false end

    local cmdBtn = realAdminGui:FindFirstChild(commandName, true)
    if not cmdBtn then return false end
    if not fireClick(cmdBtn) then return false end

    task.wait(0.05)

    local playerBtn = nil
    for _, desc in ipairs(realAdminGui:GetDescendants()) do
        if desc:IsA("TextButton") and (desc.Name == targetPlayer.Name or desc.Text:find(targetPlayer.Name)) then
            playerBtn = desc
            break
        end
    end

    if not playerBtn then return false end
    if not fireClick(playerBtn) then return false end

    return true
end
_G.runAdminCommand = runAdminCommand

local AP_ALL_COMMANDS = {
    "balloon", "inverse", "jail", "jumpscare", "morph",
    "nightvision", "ragdoll", "rocket", "tiny"
}

local function apIsOnCooldown(cmd)
    local adminGui = PlayerGui:FindFirstChild("AdminPanel", true)
    if adminGui then
        local ok, visible = pcall(function()
            local cmdButton = adminGui:FindFirstChild(cmd, true)
            local timerLabel = cmdButton and cmdButton:FindFirstChild("Timer")
            return timerLabel and timerLabel.Visible
        end)
        if ok and visible then
            return true
        end
    end

    local last = lastActionUse[cmd]
    local cd = ACTION_COOLDOWNS[cmd] or 0
    if last and cd > 0 and (tick() - last) < cd then
        return true
    end

    return false
end

local function apGetNextAvailableCommand()
    local priorityCommands = {"ragdoll", "balloon", "rocket", "jail"}
    local seen = {}

    for _, cmd in ipairs(priorityCommands) do
        seen[cmd] = true
        if not apIsOnCooldown(cmd) then
            return cmd
        end
    end

    for _, cmd in ipairs(AP_ALL_COMMANDS) do
        if not seen[cmd] and not apIsOnCooldown(cmd) then
            return cmd
        end
    end

    return nil
end

local proximityRoundRobinIndex = 0

local function getEligibleProximityPlayers()
    local result = {}
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return result end

    local range = tonumber(Config.ProximityRange) or 15

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = p.Character.HumanoidRootPart
            local dist = (targetHrp.Position - myHrp.Position).Magnitude
            if dist <= range then
                if not ((Config.DisableProximitySpamOnMoby and isMobyUser(p)) or (Config.DisableProximitySpamOnKawaifu and isKawaifuUser(p))) then
                    table.insert(result, p)
                end
            end
        end
    end

    table.sort(result, function(a, b)
        return a.UserId < b.UserId
    end)

    return result
end

local function apTriggerNextProximityStep()
    if SpamAllActive then
        local playersInRange = getEligibleProximityPlayers()
        if #playersInRange <= 0 then return end
        proximityRoundRobinIndex = (proximityRoundRobinIndex % #playersInRange) + 1
        local targetPlayer = playersInRange[proximityRoundRobinIndex]
        if targetPlayer then
            for _, cmd in ipairs(AP_ALL_COMMANDS) do
                pcall(runAdminCommand, targetPlayer, cmd)
                task.wait(0.02)
            end
        end
    else
        local playersInRange = getEligibleProximityPlayers()
        if #playersInRange <= 0 then return end

        local nextCmd = apGetNextAvailableCommand()
        if not nextCmd then return end

        proximityRoundRobinIndex = (proximityRoundRobinIndex % #playersInRange) + 1
        local targetPlayer = playersInRange[proximityRoundRobinIndex]
        if not targetPlayer then return end

        local ok, res = pcall(runAdminCommand, targetPlayer, nextCmd)
        if ok and res then
            lastActionUse[nextCmd] = tick()
            if nextCmd == "balloon" then
                SharedState.BalloonedPlayers[targetPlayer.UserId] = true
            end
        end
    end
end

-- Make UI draggable
local function MakeDraggable(handle, target)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local d = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Initialize GUI Panel with Player List, Action Buttons, and Spam All Toggle
local function initAdminPanel()
    local RP_COLORS = {
        Text = Color3.fromRGB(245, 247, 250),
        SubText = Color3.fromRGB(180, 100, 100),
        AccentBright = Color3.fromRGB(215, 220, 230),
        PanelTop = Color3.fromRGB(14, 8, 8),
        PanelInner = Color3.fromRGB(12, 6, 6),
        RowA = Color3.fromRGB(22, 10, 10),
        RowB = Color3.fromRGB(18, 8, 8),
        RowHover = Color3.fromRGB(38, 14, 14),
        RowLine = Color3.fromRGB(60, 20, 20),
        ButtonBg = Color3.fromRGB(18, 8, 8),
        ButtonStroke = Color3.fromRGB(80, 28, 28),
        White = Color3.fromRGB(255, 255, 255),
        PanelCorner = 3,
        RowCorner = 3,
        ButtonCorner = 3,
    }

    RP_COLORS.RowHeight = 54
    RP_COLORS.ButtonSize = 38
    RP_COLORS.BoxSize = 32
    RP_COLORS.IconSize = 17
    RP_COLORS.ActionsWidth = 5 * RP_COLORS.ButtonSize
    RP_COLORS.SafeGap = 12
    RP_COLORS.NameSize = 16
    RP_COLORS.UserSize = 12
    RP_COLORS.StatusSize = 11

    local RP_BUTTONS = {
        { label = "🏃", action = "ragdoll" },
        { label = "🔒", action = "jail" },
        { label = "🚀", action = "rocket" },
        { label = "🎈", action = "balloon" },
        { label = "TP", action = "tp" },
    }

    local function rpMake(instType, props)
        local obj = Instance.new(instType)
        for k, v in pairs(props or {}) do obj[k] = v end
        return obj
    end

    local function rpCorner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 10)
        c.Parent = parent
        return c
    end

    local function rpStroke(parent, color, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Color = color
        s.Thickness = thickness or 1
        s.Transparency = transparency or 0
        s.Parent = parent
        return s
    end

    local adminGui = rpMake("ScreenGui", {
        Name = "XiAdminPanel",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = ExploitGui
    })

    local outer = rpMake("Frame", {
        Name = "Frame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(530, 44),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(Config.Positions.AdminPanel.X, 0, Config.Positions.AdminPanel.Y, 0),
        ZIndex = 10,
        Parent = adminGui
    })

    local topCard = rpMake("Frame", {
        Name = "TopCard",
        BackgroundColor3 = RP_COLORS.PanelTop,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        Parent = outer
    })
    rpCorner(topCard, RP_COLORS.PanelCorner)
    MakeDraggable(topCard, outer)

    local controlsBar = rpMake("Frame", {
        Name = "ControlsBar",
        BackgroundColor3 = Color3.fromRGB(8, 9, 12),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.new(1, -12, 0, 40),
        Parent = topCard
    })
    rpCorner(controlsBar, 8)

    local controls = rpMake("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 4),
        Size = UDim2.new(1, -16, 1, -8),
        Parent = controlsBar
    })

    local proxBtn = rpMake("TextButton", {
        Name = "ProximityAPButton",
        Size = UDim2.fromOffset(52, 24),
        Position = UDim2.fromOffset(2, 7),
        BackgroundColor3 = Color3.fromRGB(18, 8, 8),
        AutoButtonColor = false,
        Text = "Prox",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = RP_COLORS.Text,
        Parent = controls
    })
    rpCorner(proxBtn, 3)
    local proxBtnStroke = rpStroke(proxBtn, RP_COLORS.ButtonStroke, 1, 0.28)

    proxBtn.MouseButton1Click:Connect(function()
        ProximityAPActive = not ProximityAPActive
        proxBtn.BackgroundColor3 = ProximityAPActive and Color3.fromRGB(80, 24, 24) or Color3.fromRGB(18, 8, 8)
        proxBtnStroke.Color = ProximityAPActive and Color3.fromRGB(220, 80, 80) or RP_COLORS.ButtonStroke
    end)

    -- New Spam All Button
    local spamAllBtn = rpMake("TextButton", {
        Name = "SpamAllButton",
        Size = UDim2.fromOffset(64, 24),
        Position = UDim2.fromOffset(60, 7),
        BackgroundColor3 = Color3.fromRGB(18, 8, 8),
        AutoButtonColor = false,
        Text = "Spam All",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = RP_COLORS.Text,
        Parent = controls
    })
    rpCorner(spamAllBtn, 3)
    local spamAllBtnStroke = rpStroke(spamAllBtn, RP_COLORS.ButtonStroke, 1, 0.28)

    spamAllBtn.MouseButton1Click:Connect(function()
        SpamAllActive = not SpamAllActive
        spamAllBtn.BackgroundColor3 = SpamAllActive and Color3.fromRGB(80, 24, 24) or Color3.fromRGB(18, 8, 8)
        spamAllBtnStroke.Color = SpamAllActive and Color3.fromRGB(220, 80, 80) or RP_COLORS.ButtonStroke
    end)

    local listHolder = rpMake("Frame", {
        Name = "ListHolder",
        BackgroundColor3 = RP_COLORS.PanelInner,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = outer
    })
    rpCorner(listHolder, RP_COLORS.PanelCorner)

    local listLayout = rpMake("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = listHolder
    })

    local rows = {}

    local function createPlayerRow(plr)
        if not plr or plr == LocalPlayer then return end
        if rows[plr.UserId] and rows[plr.UserId].Parent then return end

        local row = rpMake("Frame", {
            Name = ("Row_%d"):format(plr.UserId),
            BackgroundColor3 = RP_COLORS.RowA,
            BackgroundTransparency = 0.40,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, RP_COLORS.RowHeight),
            ZIndex = 5,
            Parent = listHolder
        })
        rpCorner(row, RP_COLORS.RowCorner)
        rpStroke(row, RP_COLORS.ButtonStroke, 1, 0.98)
        rows[plr.UserId] = row

        local avatarHolder = rpMake("Frame", {
            BackgroundColor3 = Color3.fromRGB(9, 10, 14),
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(34, 34),
            Position = UDim2.fromOffset(8, 10),
            Parent = row
        })
        rpCorner(avatarHolder, 8)

        rpMake("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150",
            ZIndex = 10,
            Parent = avatarHolder
        })

        rpMake("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(50, 6),
            Size = UDim2.new(1, -220, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = plr.DisplayName,
            Font = Enum.Font.GothamBold,
            TextSize = RP_COLORS.NameSize,
            TextColor3 = RP_COLORS.Text,
            ZIndex = 10,
            Parent = row
        })

        rpMake("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(50, 23),
            Size = UDim2.new(1, -220, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = "@" .. plr.Name,
            Font = Enum.Font.GothamMedium,
            TextSize = RP_COLORS.UserSize,
            TextColor3 = RP_COLORS.SubText,
            ZIndex = 10,
            Parent = row
        })

        local actions = rpMake("Frame", {
            Name = "Actions",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.fromOffset(RP_COLORS.ActionsWidth, RP_COLORS.ButtonSize),
            ZIndex = 12,
            Parent = row
        })

        local actionList = Instance.new("UIListLayout")
        actionList.FillDirection = Enum.FillDirection.Horizontal
        actionList.SortOrder = Enum.SortOrder.LayoutOrder
        actionList.Parent = actions

        for i, b in ipairs(RP_BUTTONS) do
            local btn = rpMake("TextButton", {
                Size = UDim2.fromOffset(RP_COLORS.ButtonSize, RP_COLORS.ButtonSize),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "",
                LayoutOrder = i,
                Parent = actions
            })

            local box = rpMake("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.fromOffset(RP_COLORS.BoxSize, RP_COLORS.BoxSize),
                BackgroundColor3 = RP_COLORS.ButtonBg,
                BorderSizePixel = 0,
                Parent = btn
            })
            rpCorner(box, 6)
            rpStroke(box, RP_COLORS.ButtonStroke, 1.1, 0.5)

            rpMake("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = b.label,
                Font = Enum.Font.GothamBold,
                TextSize = RP_COLORS.IconSize,
                TextColor3 = RP_COLORS.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = box
            })

            btn.MouseButton1Click:Connect(function()
                if b.action == "tp" then
                    print("[TP] Teleporting to " .. plr.Name)
                else
                    runAdminCommand(plr, b.action)
                end
            end)
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        createPlayerRow(p)
    end

    Players.PlayerAdded:Connect(function(p)
        createPlayerRow(p)
    end)

    Players.PlayerRemoving:Connect(function(p)
        if rows[p.UserId] then
            rows[p.UserId]:Destroy()
            rows[p.UserId] = nil
        end
    end)
end

task.spawn(initAdminPanel)

-- Proximity & Spam All Loop
task.spawn(function()
    while true do
        if ProximityAPActive or SpamAllActive then
            apTriggerNextProximityStep()
        end
        task.wait(0.1)
    end
end)