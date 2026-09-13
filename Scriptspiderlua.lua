-- ============================================================
-- SCRIPT MERGE: BOTONES FLOTANTES + PANEL FADED.VS
-- (Panel BRAXIL HUB eliminado)
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local LP = Player
local LocalPlayer = Player
local lp = Player

pcall(function()
    for _, old in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if old.Name == "BananaHubAntiBat" or old.Name == "EternalHubAntiBat" or old.Name == "EthernalHubAntiBat" or old.Name == "THub" or old.Name == "PinkDuels" or old.Name == "PhobosDuels" or old.Name == "FadedHub" or old.Name == "Faded.vs" then
            old:Destroy()
        end
    end
end)

-- ============================================================
-- MÓDULO M (BAT AIMBOT - ORIGINAL)
-- ============================================================
local M = {}
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.aimbotSpeed = 58

-- ============================================================
-- INSTANT RESET (ORIGINAL)
-- ============================================================
local cursedResetRemote = nil
local resetCooldown = false
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

local function findResetRemote()
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc; return true
        end
    end
    return false
end

local function performInstantReset()
    if resetCooldown then return end
    resetCooldown = true
    if not cursedResetRemote then findResetRemote() end
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
                cursedResetRemote = desc; break
            end
        end
    end
    if cursedResetRemote then
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
            task.delay(0.3, function() resetCooldown = false end); return
        end
        local resetDetected = false
        local conns = {}
        if humanoid then
            table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
            table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health <= 0 then resetDetected = true end
            end))
        end
        if character then
            table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
                if not parent then resetDetected = true end
            end))
        end
        task.spawn(function()
            for i = 1, 50 do
                if resetDetected then break end
                pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
                task.wait()
            end
            for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
            task.delay(0.3, function() resetCooldown = false end)
        end)
    else
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
        task.delay(0.3, function() resetCooldown = false end)
    end
end

-- ============================================================
-- BAT AIMBOT (MÓDULO ORIGINAL)
-- ============================================================
function M.findBatForAimbot()
    local char = Player.Character; if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = Player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

function M.getClosestTargetAimbot()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = M.findBatForAimbot()
    if bat and bat.Parent == char then pcall(function() bat:Activate() end) end
end

function M.startBatAimbot()
    if M.aimbotConn then M.aimbotConn:Disconnect() end
    M.autoBatEnabled = true
    local hum0 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    M.aimbotConn = RunService.RenderStepped:Connect(function()
        if not M.autoBatEnabled then return end
        local char = Player.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = M.findBatForAimbot()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = M.getClosestTargetAimbot()
        if not target then M._aimbotTarget = nil; M.swingCurrentBatAimbot(char); return end
        M._aimbotTarget = target
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        local chaseSpeed = M.aimbotSpeed or 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx*42, ry*42, rz*42))
        end
        M.swingCurrentBatAimbot(char)
    end)
end

function M.stopBatAimbot()
    if M.aimbotConn then M.aimbotConn:Disconnect(); M.aimbotConn = nil end
    M._aimbotTarget = nil
    M.autoBatEnabled = false
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function M.queueAutoBatStart()
    M.startBatAimbot()
end

-- ============================================================
-- AUTO LEFT / AUTO RIGHT (ORIGINAL - BOTONES FLOTANTES)
-- ============================================================
local AP = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
}
local autoLeftEnabled = false
local autoRightEnabled = false
local alPhase = 1
local arPhase = 1
local alConn = nil
local arConn = nil
local normalSpeed = 60

function startAutoLeft(speed)
    if alConn then stopAutoLeft() end
    autoLeftEnabled = true; alPhase = 1
    local spd = speed or normalSpeed
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if alPhase == 1 then
            local target = Vector3.new(AP.L1.X, hrp.Position.Y, AP.L1.Z)
            if (target - hrp.Position).Magnitude < 1 then alPhase = 2 end
            local dir = (AP.L1 - hrp.Position)
            local move = Vector3.new(dir.X, 0, dir.Z).Unit
            hum:Move(move, false)
            hrp.AssemblyLinearVelocity = Vector3.new(move.X * spd, hrp.AssemblyLinearVelocity.Y, move.Z * spd)
        elseif alPhase == 2 then
            local target = Vector3.new(AP.L2.X, hrp.Position.Y, AP.L2.Z)
            if (target - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); hrp.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1; return
            end
            local dir = (AP.L2 - hrp.Position)
            local move = Vector3.new(dir.X, 0, dir.Z).Unit
            hum:Move(move, false)
            hrp.AssemblyLinearVelocity = Vector3.new(move.X * spd, hrp.AssemblyLinearVelocity.Y, move.Z * spd)
        end
    end)
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    autoLeftEnabled = false; alPhase = 1
    local char = LP.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

function startAutoRight(speed)
    if arConn then stopAutoRight() end
    autoRightEnabled = true; arPhase = 1
    local spd = speed or normalSpeed
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if arPhase == 1 then
            local target = Vector3.new(AP.R1.X, hrp.Position.Y, AP.R1.Z)
            if (target - hrp.Position).Magnitude < 1 then arPhase = 2 end
            local dir = (AP.R1 - hrp.Position)
            local move = Vector3.new(dir.X, 0, dir.Z).Unit
            hum:Move(move, false)
            hrp.AssemblyLinearVelocity = Vector3.new(move.X * spd, hrp.AssemblyLinearVelocity.Y, move.Z * spd)
        elseif arPhase == 2 then
            local target = Vector3.new(AP.R2.X, hrp.Position.Y, AP.R2.Z)
            if (target - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); hrp.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1; return
            end
            local dir = (AP.R2 - hrp.Position)
            local move = Vector3.new(dir.X, 0, dir.Z).Unit
            hum:Move(move, false)
            hrp.AssemblyLinearVelocity = Vector3.new(move.X * spd, hrp.AssemblyLinearVelocity.Y, move.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    autoRightEnabled = false; arPhase = 1
    local char = LP.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

-- ============================================================
-- TP BAT (ORIGINAL)
-- ============================================================
local tpBatEnabled = false
local tpBatHittingCooldown = false
local tpBatHRP = nil
local tpBatH = nil
local heartbeatConn = nil
local renderConn = nil
local charAddedConn = nil

local function getBatTool()
    local char = LP.Character; if not char then return nil end
    local bat = char:FindFirstChild("Bat"); if bat then return bat end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        bat = backpack:FindFirstChild("Bat")
        if bat then bat.Parent = char; return bat end
    end
    return nil
end

local function tryHit()
    if tpBatHittingCooldown then return end
    tpBatHittingCooldown = true
    pcall(function()
        local bat = getBatTool()
        if bat then
            bat:Activate()
            local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remoteEvent then remoteEvent:FireServer() end
        end
    end)
    task.delay(0.08, function() tpBatHittingCooldown = false end)
end

local function getClosestPlayer()
    if not tpBatHRP then return nil, math.huge end
    local closest, closestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (tpBatHRP.Position - targetRoot.Position).Magnitude
                if dist < closestDist then closestDist = dist; closest = p end
            end
        end
    end
    return closest, closestDist
end

local function updateCharacterReferences()
    local char = LP.Character
    if char then
        tpBatH = char:FindFirstChildOfClass("Humanoid")
        tpBatHRP = char:FindFirstChild("HumanoidRootPart")
    end
end

local function heartbeatLoop()
    if not tpBatEnabled then return end
    if not tpBatH or not tpBatHRP or not tpBatH.Parent or not tpBatHRP.Parent then
        updateCharacterReferences()
        if not tpBatH or not tpBatHRP then return end
    end
    local target = getClosestPlayer()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
            if (tpBatHRP.Position - targetPosition).Magnitude > 5 then
                tpBatHRP.CFrame = CFrame.new(targetPosition)
            end
            tryHit()
        end
    end
end

local function renderLoop()
    if not tpBatEnabled then return end
    if not tpBatH or not tpBatHRP or not tpBatH.Parent or not tpBatHRP.Parent then
        updateCharacterReferences()
        if not tpBatH or not tpBatHRP then return end
    end
    local target = getClosestPlayer()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local camera = workspace.CurrentCamera
            if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
            tryHit()
        end
    end
end

function enableTPBat()
    if tpBatEnabled then return end
    tpBatEnabled = true
    updateCharacterReferences()
    if heartbeatConn then heartbeatConn:Disconnect() end
    if renderConn then renderConn:Disconnect() end
    heartbeatConn = RunService.Heartbeat:Connect(heartbeatLoop)
    renderConn = RunService.RenderStepped:Connect(renderLoop)
    if charAddedConn then charAddedConn:Disconnect() end
    charAddedConn = LP.CharacterAdded:Connect(function() task.wait(0.2); updateCharacterReferences() end)
end

function disableTPBat()
    if not tpBatEnabled then return end
    tpBatEnabled = false
    if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
    if renderConn then renderConn:Disconnect(); renderConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
end

-- ============================================================
-- UI PRINCIPAL (BOTONES FLOTANTES ORIGINALES)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(268, 245)
Main.Position = UDim2.new(1, -7, 0, 12)
Main.AnchorPoint = Vector2.new(1, 0)
Main.BackgroundTransparency = 1
Main.Parent = ScreenGui

local ButtonSize = 60
local GapY = 6
local TEXT_FONT = Enum.Font.GothamBold
local TEXT_SIZE = 13
local TEXT_STROKE_THICKNESS = 2
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local TEXT_STROKE_COLOR = Color3.fromRGB(0, 0, 0)

local ColumnData = {
    {Amount = 1, X = 0}, {Amount = 2, X = 67},
    {Amount = 3, X = 134}, {Amount = 4, X = 201},
}

local WHITE_TIME = 1800
local FLASH_010_TIME = 0.10

local ButtonLabels = {
    ["1_1"] = {"BAT", "BYPASS"}, ["2_1"] = {"ANTI", "DESYNC"},
    ["2_2"] = {"RESET", ""}, ["3_1"] = {"DROP", "BR"},
    ["3_2"] = {"BAT", "AIMBOT"}, ["3_3"] = {"TP", "DOWN"},
    ["4_1"] = {"AUTO", "LEFT"}, ["4_2"] = {"AUTO", "RIGHT"},
    ["4_3"] = {"CARRY", "SPD"}, ["4_4"] = {"LAGGER", "OFF"},
}

local LongWhiteButtons = {
    ["1_1"] = true, ["2_1"] = true, ["3_2"] = true,
    ["4_1"] = true, ["4_2"] = true, ["4_3"] = true, ["4_4"] = true,
}
local Flash010Buttons = { ["2_2"] = true, ["3_1"] = true, ["3_3"] = true }

local function ApplyButtonStyle(Button)
    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = true
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
end

local function ApplyTwoLineText(Button, Line1, Line2)
    if Line2 == nil or Line2 == "" then Button.Text = Line1 else Button.Text = Line1 .. "\n" .. Line2 end
    Button.TextColor3 = TEXT_COLOR
    Button.Font = TEXT_FONT
    Button.TextSize = TEXT_SIZE
    Button.TextWrapped = true
    Button.TextXAlignment = Enum.TextXAlignment.Center
    Button.TextYAlignment = Enum.TextYAlignment.Center
    Button.TextScaled = false
    local TextStroke = Instance.new("UIStroke")
    TextStroke.Color = TEXT_STROKE_COLOR
    TextStroke.Thickness = TEXT_STROKE_THICKNESS
    TextStroke.Parent = Button
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 4); TextPadding.PaddingRight = UDim.new(0, 4)
    TextPadding.PaddingTop = UDim.new(0, 4); TextPadding.PaddingBottom = UDim.new(0, 4)
    TextPadding.Parent = Button
end

for Column = 1, 4 do
    local Data = ColumnData[Column]
    for Number = 1, Data.Amount do
        local Button = Instance.new("TextButton")
        Button.Name = "Button" .. Column .. "_" .. Number
        Button.Size = UDim2.fromOffset(ButtonSize, ButtonSize)
        Button.Position = UDim2.fromOffset(Data.X, (Number - 1) * (ButtonSize + GapY))
        ApplyButtonStyle(Button)
        Button.Parent = Main
        local Key = Column .. "_" .. Number
        local Label = ButtonLabels[Key]
        if Label then ApplyTwoLineText(Button, Label[1], Label[2]) end
        if Flash010Buttons[Key] then
            Button.Activated:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                if Key == "2_2" then performInstantReset() end
                task.wait(FLASH_010_TIME)
                Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end)
        elseif LongWhiteButtons[Key] then
            local Active = false
            local ActivationId = 0
            Button.Activated:Connect(function()
                if Active then
                    Active = false; ActivationId += 1
                    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    if Key == "4_4" then Button.Text = "LAGGER\nOFF" end
                    if Key == "4_1" then stopAutoLeft()
                    elseif Key == "4_2" then stopAutoRight()
                    elseif Key == "2_1" then disableTPBat()
                    elseif Key == "3_2" then M.stopBatAimbot() end
                    return
                end
                Active = true; ActivationId += 1
                local ThisActivation = ActivationId
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                if Key == "4_4" then Button.Text = "LAGGER\nON" end
                if Key == "4_1" then startAutoLeft()
                elseif Key == "4_2" then startAutoRight()
                elseif Key == "2_1" then enableTPBat()
                elseif Key == "3_2" then M.queueAutoBatStart() end
                task.delay(WHITE_TIME, function()
                    if Active and ActivationId == ThisActivation then
                        Active = false
                        Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        if Key == "4_4" then Button.Text = "LAGGER\nOFF" end
                        if Key == "4_1" then stopAutoLeft()
                        elseif Key == "4_2" then stopAutoRight()
                        elseif Key == "2_1" then disableTPBat()
                        elseif Key == "3_2" then M.stopBatAimbot() end
                    end
                end)
            end)
        end
    end
end

-- ============================================================
-- ============================================================
-- ============ PANEL FADED.VS (NUEVO) ========================
-- ============================================================
-- ============================================================

-- CONFIG SYSTEM
local FolderName = "FadedVS"
local FileName = FolderName .. "/config.json"
local Config = {
    ["Speed Mode"] = true, ["Lagger Mode"] = false, ["Unwalk"] = false,
    ["Bat Counter"] = false, ["Medusa Counter"] = false, ["Auto Steal"] = false,
    ["Stretch Resolution"] = false, ["Auto Reset Medusa"] = false, ["Anti Ragdoll"] = false,
    ["ESP Tracers"] = false, ["Infinite Jump"] = false, ["Inf Jump Mode"] = "Single",
    ["Shiny Graphics"] = false, ["Anti Lag"] = false, ["Other Players Speed"] = false,
    ["Normal Speed"] = 53, ["Carry Speed"] = 29, ["Lagger Boost"] = 10.1, ["Lagger Steal"] = 8,
    ["KB TP Down"] = "G", ["KB Drop BR"] = "Q", ["KB Bat Aimbot"] = "X",
    ["KB Auto Left"] = "T", ["KB Auto Right"] = "C", ["KB Lagger Mode"] = "R",
    ["Main X"] = 0.5, ["Main Y"] = 0.5, ["Main OX"] = -200, ["Main OY"] = -250,
    ["Mini X"] = 0.5, ["Mini Y"] = 0, ["Mini OX"] = -80, ["Mini OY"] = 20,
}
pcall(function()
    if not isfolder(FolderName) then makefolder(FolderName) end
    if not isfile(FileName) then writefile(FileName, HttpService:JSONEncode(Config)) end
end)
local function LoadConfig()
    pcall(function()
        local data = readfile(FileName)
        local decoded = HttpService:JSONDecode(data)
        if decoded then
            for key, value in pairs(decoded) do
                if Config[key] ~= nil then Config[key] = value end
            end
        end
    end)
end
LoadConfig()
local function SaveConfig()
    pcall(function() writefile(FileName, HttpService:JSONEncode(Config)) end)
end

-- THEME
local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)
local MAIN_TEXT    = Color3.fromRGB(255, 255, 255)
local BG_COLOR     = Color3.fromRGB(10, 10, 10)
local GLASS_COLOR  = Color3.fromRGB(8, 8, 8)
local TOGGLE_OFF   = Color3.fromRGB(30, 30, 30)
local TOGGLE_ON    = Color3.fromRGB(255, 255, 255)

-- KEYBINDS
local keybinds = {
    tpDown     = {kb = Enum.KeyCode[Config["KB TP Down"]]    or Enum.KeyCode.G, gp = nil},
    dropBR     = {kb = Enum.KeyCode[Config["KB Drop BR"]]    or Enum.KeyCode.Q, gp = nil},
    batAimbot  = {kb = Enum.KeyCode[Config["KB Bat Aimbot"]] or Enum.KeyCode.X, gp = nil},
    autoLeft   = {kb = Enum.KeyCode[Config["KB Auto Left"]]  or Enum.KeyCode.T, gp = nil},
    autoRight  = {kb = Enum.KeyCode[Config["KB Auto Right"]] or Enum.KeyCode.C, gp = nil},
    laggerMode = {kb = Enum.KeyCode[Config["KB Lagger Mode"]]or Enum.KeyCode.R, gp = nil},
}
local anyKeyListening = false

-- INFINITE JUMP
local infJumpEnabled = false
local infJumpMode    = Config["Inf Jump Mode"] or "Single"
local holdJumpPressed = false
local holdJumpActive  = false
local lastJumpTime    = 0
local JUMP_COOLDOWN   = 0.1

local function applyInfJump()
    if not infJumpEnabled then return end
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    if tick() - lastJumpTime < JUMP_COOLDOWN then return end
    lastJumpTime = tick()
    root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
end

UserInputService.JumpRequest:Connect(function()
    if not infJumpEnabled then return end
    if infJumpMode == "Single" then applyInfJump() end
end)
UserInputService.InputBegan:Connect(function(input)
    if not infJumpEnabled then return end
    if infJumpMode ~= "Hold" then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not UserInputService:GetFocusedTextBox() then
        holdJumpPressed = true
        task.delay(0.12, function() if holdJumpPressed then holdJumpActive = true end end)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        holdJumpPressed = false; holdJumpActive = false
    end
end)
RunService.Heartbeat:Connect(function()
    if not infJumpEnabled then return end
    if infJumpMode == "Hold" and holdJumpActive then applyInfJump() end
end)
LocalPlayer.CharacterAdded:Connect(function()
    holdJumpActive = false; holdJumpPressed = false
end)

-- AUTO LEFT/RIGHT (FADED - prefijo faded_ para no chocar)
local FADED_POS = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.04, -5.09, 23.14),
}
local AutoMove = {
    autoLeftEnabled = false, autoRightEnabled = false,
    autoLeftPhase = 1, autoRightPhase = 1, normalSpeed = 60,
    autoLeftConn = nil, autoRightConn = nil,
}
local function faceSouth()
    pcall(function()
        local c = lp.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, 0) end
    end)
end
local function faceNorth()
    pcall(function()
        local c = lp.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(180), 0) end
    end)
end
function faded_startAutoLeft()
    if AutoMove.autoLeftConn then AutoMove.autoLeftConn:Disconnect() end
    AutoMove.autoLeftPhase = 1
    AutoMove.autoLeftConn = RunService.Heartbeat:Connect(function()
        if not AutoMove.autoLeftEnabled then return end
        local c = lp.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local speed = AutoMove.normalSpeed
        if AutoMove.autoLeftPhase == 1 then
            local target = Vector3.new(FADED_POS.L1.X, root.Position.Y, FADED_POS.L1.Z)
            if (target - root.Position).Magnitude < 1 then
                AutoMove.autoLeftPhase = 2
                local mv = Vector3.new((FADED_POS.L2 - root.Position).X, 0, (FADED_POS.L2 - root.Position).Z).Unit
                hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*speed, root.AssemblyLinearVelocity.Y, mv.Z*speed); return
            end
            local mv = Vector3.new((FADED_POS.L1 - root.Position).X, 0, (FADED_POS.L1 - root.Position).Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*speed, root.AssemblyLinearVelocity.Y, mv.Z*speed)
        elseif AutoMove.autoLeftPhase == 2 then
            local target = Vector3.new(FADED_POS.L2.X, root.Position.Y, FADED_POS.L2.Z)
            if (target - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); root.AssemblyLinearVelocity = Vector3.zero
                AutoMove.autoLeftEnabled = false
                if AutoMove.autoLeftConn then AutoMove.autoLeftConn:Disconnect(); AutoMove.autoLeftConn = nil end
                AutoMove.autoLeftPhase = 1; faceSouth(); return
            end
            local mv = Vector3.new((FADED_POS.L2 - root.Position).X, 0, (FADED_POS.L2 - root.Position).Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*speed, root.AssemblyLinearVelocity.Y, mv.Z*speed)
        end
    end)
end
function faded_stopAutoLeft()
    if AutoMove.autoLeftConn then AutoMove.autoLeftConn:Disconnect(); AutoMove.autoLeftConn = nil end
    AutoMove.autoLeftPhase = 1
    local c = lp.Character
    if c then local hum = c:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end
function faded_startAutoRight()
    if AutoMove.autoRightConn then AutoMove.autoRightConn:Disconnect() end
    AutoMove.autoRightPhase = 1
    AutoMove.autoRightConn = RunService.Heartbeat:Connect(function()
        if not AutoMove.autoRightEnabled then return end
        local c = lp.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local speed = AutoMove.normalSpeed
        if AutoMove.autoRightPhase == 1 then
            local target = Vector3.new(FADED_POS.R1.X, root.Position.Y, FADED_POS.R1.Z)
            if (target - root.Position).Magnitude < 1 then
                AutoMove.autoRightPhase = 2
                local mv = Vector3.new((FADED_POS.R2 - root.Position).X, 0, (FADED_POS.R2 - root.Position).Z).Unit
                hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*speed, root.AssemblyLinearVelocity.Y, mv.Z*speed); return
            end
            local mv = Vector3.new((FADED_POS.R1 - root.Position).X, 0, (FADED_POS.R1 - root.Position).Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*speed, root.AssemblyLinearVelocity.Y, mv.Z*speed)
        elseif AutoMove.autoRightPhase == 2 then
            local target = Vector3.new(FADED_POS.R2.X, root.Position.Y, FADED_POS.R2.Z)
            if (target - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); root.AssemblyLinearVelocity = Vector3.zero
                AutoMove.autoRightEnabled = false
                if AutoMove.autoRightConn then AutoMove.autoRightConn:Disconnect(); AutoMove.autoRightConn = nil end
                AutoMove.autoRightPhase = 1; faceNorth(); return
            end
            local mv = Vector3.new((FADED_POS.R2 - root.Position).X, 0, (FADED_POS.R2 - root.Position).Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*speed, root.AssemblyLinearVelocity.Y, mv.Z*speed)
        end
    end)
end
function faded_stopAutoRight()
    if AutoMove.autoRightConn then AutoMove.autoRightConn:Disconnect(); AutoMove.autoRightConn = nil end
    AutoMove.autoRightPhase = 1
    local c = lp.Character
    if c then local hum = c:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end
function faded_toggleAutoLeft()
    AutoMove.autoLeftEnabled = not AutoMove.autoLeftEnabled
    if AutoMove.autoLeftEnabled then
        if AutoMove.autoRightEnabled then AutoMove.autoRightEnabled = false; faded_stopAutoRight() end
        faded_startAutoLeft()
    else faded_stopAutoLeft() end
end
function faded_toggleAutoRight()
    AutoMove.autoRightEnabled = not AutoMove.autoRightEnabled
    if AutoMove.autoRightEnabled then
        if AutoMove.autoLeftEnabled then AutoMove.autoLeftEnabled = false; faded_stopAutoLeft() end
        faded_startAutoRight()
    else faded_stopAutoRight() end
end

-- FADED GUI
local gui = Instance.new("ScreenGui")
gui.Name = "Faded.vs"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local PW, PH = 400, 500
local dp = Instance.new("ImageLabel", gui)
dp.Name = "MainFrame"
dp.Size = UDim2.new(0, PW, 0, PH)
dp.Position = UDim2.new(Config["Main X"], Config["Main OX"], Config["Main Y"], Config["Main OY"])
dp.BackgroundColor3 = BG_COLOR
dp.Image = "rbxassetid://107977050874654"
dp.ScaleType = Enum.ScaleType.Crop
dp.Active = true
dp.ClipsDescendants = true
Instance.new("UICorner", dp).CornerRadius = UDim.new(0, 16)
local dpSt = Instance.new("UIStroke", dp)
dpSt.Color = ACCENT_COLOR; dpSt.Thickness = 1.8

local dragging, dragStart, startPos
dp.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = dp.Position
        local conn; conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false; conn:Disconnect()
                Config["Main X"] = dp.Position.X.Scale; Config["Main OX"] = dp.Position.X.Offset
                Config["Main Y"] = dp.Position.Y.Scale; Config["Main OY"] = dp.Position.Y.Offset
                SaveConfig()
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        dp.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local header = Instance.new("Frame", dp)
header.Size = UDim2.new(1, 0, 0, 44); header.BackgroundTransparency = 1
local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1, -50, 1, 0); titleLbl.Position = UDim2.new(0, 16, 0, 0)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "Faded.vs"
titleLbl.TextColor3 = ACCENT_COLOR; titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 16; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 26, 0, 26); minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = GLASS_COLOR; minBtn.BackgroundTransparency = 0.5
minBtn.Text = "_"; minBtn.TextColor3 = MAIN_TEXT; minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 16
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
local minStr = Instance.new("UIStroke", minBtn); minStr.Color = ACCENT_COLOR; minStr.Thickness = 1

local divider = Instance.new("Frame", dp)
divider.Size = UDim2.new(0, 2, 1, -54); divider.Position = UDim2.new(1, -100, 0, 50)
divider.BackgroundColor3 = ACCENT_COLOR; divider.BackgroundTransparency = 0.4; divider.BorderSizePixel = 0
Instance.new("UICorner", divider).CornerRadius = UDim.new(0, 10)

-- MINI BAR
local miniBar = Instance.new("Frame", gui)
miniBar.Name = "MiniBar"
miniBar.Size = UDim2.new(0, 160, 0, 30)
miniBar.Position = UDim2.new(Config["Mini X"], Config["Mini OX"], Config["Mini Y"], Config["Mini OY"])
miniBar.BackgroundColor3 = BG_COLOR
miniBar.BackgroundTransparency = 0.1
miniBar.Visible = false
miniBar.Active = true
Instance.new("UICorner", miniBar).CornerRadius = UDim.new(0, 8)
local miniBarStroke = Instance.new("UIStroke", miniBar)
miniBarStroke.Color = ACCENT_COLOR; miniBarStroke.Thickness = 1.5
local miniLbl = Instance.new("TextLabel", miniBar)
miniLbl.Size = UDim2.new(1, 0, 1, 0); miniLbl.BackgroundTransparency = 1
miniLbl.Text = "Faded.vs"; miniLbl.TextColor3 = ACCENT_COLOR
miniLbl.Font = Enum.Font.GothamBlack; miniLbl.TextSize = 13
miniLbl.TextXAlignment = Enum.TextXAlignment.Center

local miniDragging, miniDragStart, miniStartPos
miniBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true; miniDragStart = input.Position; miniStartPos = miniBar.Position
        local conn; conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                miniDragging = false; conn:Disconnect()
                Config["Mini X"] = miniBar.Position.X.Scale; Config["Mini OX"] = miniBar.Position.X.Offset
                Config["Mini Y"] = miniBar.Position.Y.Scale; Config["Mini OY"] = miniBar.Position.Y.Offset
                SaveConfig()
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if miniDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - miniDragStart
        miniBar.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)
miniBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        task.delay(0.15, function()
            if not miniDragging then dp.Visible = true; miniBar.Visible = false end
        end)
    end
end)

-- TABS
local tabs = {"Speed", "Combat", "Settings", "Keys"}
local tabButtons = {}
local tabFrames  = {}
local selectedTab = nil
for i, tabName in ipairs(tabs) do
    local tabFrame = Instance.new("Frame", dp)
    tabFrame.Size = UDim2.new(0, 80, 0, 40)
    tabFrame.Position = UDim2.new(1, -90, 0, 50 + (i-1) * 48)
    tabFrame.BackgroundColor3 = GLASS_COLOR; tabFrame.BackgroundTransparency = 0.3
    Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 8)
    local tfs = Instance.new("UIStroke", tabFrame)
    tfs.Color = ACCENT_COLOR; tfs.Thickness = 0.5; tfs.Transparency = 0.5
    tabFrames[tabName] = tabFrame
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1, -8, 1, -8); btn.Position = UDim2.new(0, 4, 0, 4)
    btn.BackgroundTransparency = 1; btn.Text = tabName; btn.TextColor3 = MAIN_TEXT
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.AutoButtonColor = false
    tabButtons[tabName] = btn
    btn.MouseEnter:Connect(function()
        if selectedTab ~= tabName then
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = ACCENT_COLOR}):Play()
            TweenService:Create(tabFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if selectedTab ~= tabName then
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = MAIN_TEXT}):Play()
            TweenService:Create(tabFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
    end)
end
local tabContents = {}
for _, tabName in ipairs(tabs) do
    local content = Instance.new("ScrollingFrame", dp)
    content.Size = UDim2.new(0, 280, 0, 430); content.Position = UDim2.new(0, 15, 0, 55)
    content.BackgroundTransparency = 1; content.Visible = false
    content.ClipsDescendants = true; content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = ACCENT_COLOR; content.ScrollBarImageTransparency = 0.5
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContents[tabName] = content
end

-- SPEED CHECKER
local speedCheckerBB = nil
local speedCheckerConn = nil
local function createSpeedChecker()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if speedCheckerBB then speedCheckerBB:Destroy() end
    speedCheckerBB = Instance.new("BillboardGui")
    speedCheckerBB.Adornee = hrp; speedCheckerBB.Size = UDim2.new(0, 120, 0, 56)
    speedCheckerBB.StudsOffset = Vector3.new(0, 4.5, 0); speedCheckerBB.AlwaysOnTop = true; speedCheckerBB.Parent = hrp
    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1, 0, 0, 28); speedLbl.BackgroundTransparency = 1
    speedLbl.TextColor3 = ACCENT_COLOR; speedLbl.TextStrokeTransparency = 0
    speedLbl.TextScaled = true; speedLbl.Text = "0.0"; speedLbl.Font = Enum.Font.GothamBold; speedLbl.Parent = speedCheckerBB
    local fadedLbl = Instance.new("TextLabel")
    fadedLbl.Size = UDim2.new(1, 0, 0, 22); fadedLbl.Position = UDim2.new(0, 0, 0, 30)
    fadedLbl.BackgroundTransparency = 1; fadedLbl.TextColor3 = ACCENT_COLOR
    fadedLbl.TextStrokeTransparency = 0.5; fadedLbl.TextScaled = true
    fadedLbl.Text = "/Faded.vs"; fadedLbl.Font = Enum.Font.Gotham; fadedLbl.TextTransparency = 0.3; fadedLbl.Parent = speedCheckerBB
end
local function updateSpeedChecker()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if not speedCheckerBB or not speedCheckerBB.Parent then createSpeedChecker() end
    local speedLbl = speedCheckerBB and speedCheckerBB:FindFirstChildOfClass("TextLabel")
    if not speedLbl then return end
    local v = hrp.AssemblyLinearVelocity
    speedLbl.Text = string.format("%.1f", Vector3.new(v.X, 0, v.Z).Magnitude)
end
local function startSpeedChecker()
    if speedCheckerConn then return end
    if LocalPlayer.Character then createSpeedChecker() end
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); createSpeedChecker() end)
    speedCheckerConn = RunService.Heartbeat:Connect(updateSpeedChecker)
end
startSpeedChecker()

-- SPEED FUNCTIONS
local humanoid = nil
local humanoidRootPart = nil
local speedModeEnabled = true
local speedModeConn = nil
local normalSpeedValue = Config["Normal Speed"]
local carrySpeedValue  = Config["Carry Speed"]
local laggerBoostValue = Config["Lagger Boost"]
local laggerStealValue = Config["Lagger Steal"]
local isLaggerModeActive = Config["Lagger Mode"]

local function handleSpeed()
    if not humanoid or not humanoidRootPart then return end
    local md = humanoid.MoveDirection; if md.Magnitude == 0 then return end
    local spd
    if isLaggerModeActive then
        spd = humanoid.WalkSpeed < 25 and laggerStealValue or laggerBoostValue
    else
        spd = humanoid.WalkSpeed < 25 and carrySpeedValue or normalSpeedValue
    end
    humanoidRootPart.Velocity = Vector3.new(md.X * spd, humanoidRootPart.Velocity.Y, md.Z * spd)
end
local function setNormalSpeed(v) normalSpeedValue = math.clamp(v, 15, 200) end
local function setCarrySpeed(v)  carrySpeedValue  = math.clamp(v, 15, 200) end
local function setLaggerBoost(v) laggerBoostValue = math.clamp(v, 1, 200) end
local function setLaggerSteal(v) laggerStealValue = math.clamp(v, 1, 200) end
local function updateHumanoidRefs()
    local char = LocalPlayer.Character
    if char then humanoid = char:FindFirstChildOfClass("Humanoid"); humanoidRootPart = char:FindFirstChild("HumanoidRootPart") end
end
local function startSpeedMode()
    if speedModeConn then return end
    updateHumanoidRefs()
    speedModeConn = RunService.Heartbeat:Connect(function()
        if not speedModeEnabled then speedModeConn:Disconnect(); speedModeConn = nil; return end
        handleSpeed()
    end)
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5); updateHumanoidRefs()
    if speedModeEnabled then startSpeedMode() end
end)
startSpeedMode()

-- TP DOWN
local function doTPDown()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
        * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

-- DROP BR
local dropBRActive = false
local dropBRConn   = nil
local function runDropBrainrot()
    if dropBRActive then return end
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    dropBRActive = true
    local t0 = tick()
    if dropBRConn then dropBRConn:Disconnect() end
    dropBRConn = RunService.Heartbeat:Connect(function()
        local char2 = LocalPlayer.Character
        if not char2 then dropBRConn:Disconnect(); dropBRConn = nil; dropBRActive = false; return end
        local r = char2:FindFirstChild("HumanoidRootPart")
        if not r then dropBRConn:Disconnect(); dropBRConn = nil; dropBRActive = false; return end
        if tick() - t0 >= 0.2 then
            dropBRConn:Disconnect(); dropBRConn = nil
            local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {char2}; rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
            if rr then
                local hum2 = char2:FindFirstChildOfClass("Humanoid")
                local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.zero
            end
            dropBRActive = false
        else
            r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 150, r.AssemblyLinearVelocity.Z)
        end
    end)
end

-- FADED BAT AIMBOT
local batAimbotActive = false
local batHittingCooldown = false
local batAimbotConn = nil
local function findBat()
    local char = LocalPlayer.Character; if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then local n = tool.Name:lower(); if n:find("bat") or n:find("slap") then return tool end end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then local n = tool.Name:lower(); if n:find("bat") or n:find("slap") then return tool end end
        end
    end
    return nil
end
local function getClosestTarget()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end
local function faded_startBatAimbot()
    if batAimbotConn then batAimbotConn:Disconnect(); batAimbotConn = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = false end
    batAimbotConn = RunService.RenderStepped:Connect(function()
        if not batAimbotActive then return end
        local char = LocalPlayer.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat(); if bat then pcall(function() hum2:EquipTool(bat) end) end
        end
        local target = getClosestTarget(); if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position; local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        local chaseSpeed = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = math.clamp((desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8, -70, 110)
        if hum2.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed), 0.8)
        local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx*42, ry*42, rz*42))
        end
    end)
end
local function faded_stopBatAimbot()
    if batAimbotConn then batAimbotConn:Disconnect(); batAimbotConn = nil end
    local c = LocalPlayer.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end
local function faded_toggleBatAimbot()
    batAimbotActive = not batAimbotActive
    if batAimbotActive then faded_startBatAimbot() else faded_stopBatAimbot() end
end
LocalPlayer.CharacterAdded:Connect(function(char)
    if batAimbotActive then task.wait(0.5); faded_startBatAimbot() end
end)

-- KEYBIND HANDLER
local function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end
local laggerToggleSetVisual = nil
UserInputService.InputBegan:Connect(function(input, gpe)
    if anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UserInputService:GetFocusedTextBox() then return end
    elseif not (input.UserInputType and input.UserInputType.Name:match("^Gamepad")) then
        return
    end
    local kc = input.KeyCode
    if kbMatch(keybinds.tpDown, kc)     then pcall(doTPDown) end
    if kbMatch(keybinds.dropBR, kc)     then runDropBrainrot() end
    if kbMatch(keybinds.batAimbot, kc)  then faded_toggleBatAimbot() end
    if kbMatch(keybinds.autoLeft, kc)   then faded_toggleAutoLeft() end
    if kbMatch(keybinds.autoRight, kc)  then faded_toggleAutoRight() end
    if kbMatch(keybinds.laggerMode, kc) then
        isLaggerModeActive = not isLaggerModeActive
        Config["Lagger Mode"] = isLaggerModeActive
        if laggerToggleSetVisual then laggerToggleSetVisual(isLaggerModeActive) end
        SaveConfig()
    end
end)

-- UNWALK
local unwalkEnabled = false
local unwalkConn = nil
local function startUnwalk()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator"); if not anim then return end
    for _, t in ipairs(anim:GetPlayingAnimationTracks()) do t:Stop(0) end
    if unwalkConn then unwalkConn:Disconnect() end
    unwalkConn = RunService.Heartbeat:Connect(function()
        if not unwalkEnabled then unwalkConn:Disconnect(); unwalkConn = nil; return end
        local c = LocalPlayer.Character; if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
        local a = h:FindFirstChildOfClass("Animator"); if not a then return end
        for _, t in ipairs(a:GetPlayingAnimationTracks()) do t:Stop(0) end
    end)
end
local function stopUnwalk()
    if unwalkConn then unwalkConn:Disconnect(); unwalkConn = nil end
end

-- BAT COUNTER
local batCounterEnabled = false
local batCounterDebounce = false
local batCounterConn = nil
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c = LocalPlayer.Character; if not c then return nil end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat, char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then if hum then pcall(function() hum:EquipTool(bat) end) end; task.wait(0.05) end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end)
    end
end
local function startBatCounter()
    if batCounterConn then return end
    batCounterConn = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char = LocalPlayer.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5); batCounterDebounce = false
            end)
        end
    end)
end
local function stopBatCounter()
    if batCounterConn then batCounterConn:Disconnect(); batCounterConn = nil end
    batCounterDebounce = false
end

-- MEDUSA COUNTER
local medusaCounterEnabled = false
local medusaDebounce = false
local medusaLastUsed = 0
local MEDUSA_COOLDOWN = 25
local medusaConnections = {}
local function findMedusa()
    local c = LocalPlayer.Character; if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then local n = t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then local n = t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
        end
    end
    return nil
end
local function useMedusaCounter()
    if medusaDebounce or tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LocalPlayer.Character; if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then local hum = c:FindFirstChildOfClass("Humanoid"); if hum then hum:EquipTool(med) end end
    pcall(function() med:Activate() end)
    medusaLastUsed = tick(); medusaDebounce = false
end
local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end
local function setupMedusa(char)
    for _, c in pairs(medusaConnections) do pcall(function() c:Disconnect() end) end
    medusaConnections = {}
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(medusaConnections, onAnchorChanged(part)) end
    end
    table.insert(medusaConnections, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(medusaConnections, onAnchorChanged(part)) end
    end))
end
local function stopMedusaCounter()
    for _, c in pairs(medusaConnections) do pcall(function() c:Disconnect() end) end
    medusaConnections = {}
end
LocalPlayer.CharacterAdded:Connect(function(char)
    if medusaCounterEnabled then setupMedusa(char) end
end)

-- AUTO STEAL
local AutoSteal = {
    Enabled = false, STEAL_RADIUS = 60, STEAL_DURATION = 1.4,
    isStealing = false, StealData = {}, screenGui = nil,
    barContainer = nil, progressBar = nil, statusLabel = nil,
    heartbeatConn = nil, progressConnection = nil,
    isDragging = false, dragStartPos = nil, dragStartMouse = nil
}
local function createStealUI()
    AutoSteal.screenGui = Instance.new("ScreenGui"); AutoSteal.screenGui.Name = "StealProgress"
    AutoSteal.screenGui.ResetOnSpawn = false; AutoSteal.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    AutoSteal.screenGui.Parent = lp:WaitForChild("PlayerGui")
    AutoSteal.barContainer = Instance.new("Frame"); AutoSteal.barContainer.Size = UDim2.new(0, 300, 0, 32)
    AutoSteal.barContainer.Position = UDim2.new(0.5, -150, 0.05, 0); AutoSteal.barContainer.BackgroundColor3 = Color3.fromRGB(10,10,10)
    AutoSteal.barContainer.BackgroundTransparency = 0.3; AutoSteal.barContainer.BorderSizePixel = 0
    AutoSteal.barContainer.Parent = AutoSteal.screenGui
    Instance.new("UICorner", AutoSteal.barContainer).CornerRadius = UDim.new(0, 14)
    local cs = Instance.new("UIStroke", AutoSteal.barContainer); cs.Color = Color3.fromRGB(255,255,255); cs.Thickness = 1.5; cs.Transparency = 0.5
    AutoSteal.barContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            AutoSteal.isDragging = true; AutoSteal.dragStartPos = AutoSteal.barContainer.Position; AutoSteal.dragStartMouse = input.Position
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then AutoSteal.isDragging = false; conn:Disconnect() end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if AutoSteal.isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - AutoSteal.dragStartMouse
            AutoSteal.barContainer.Position = UDim2.new(AutoSteal.dragStartPos.X.Scale, AutoSteal.dragStartPos.X.Offset + delta.X, AutoSteal.dragStartPos.Y.Scale, AutoSteal.dragStartPos.Y.Offset + delta.Y)
        end
    end)
    local barBg = Instance.new("Frame"); barBg.Size = UDim2.new(1,-8,1,-8); barBg.Position = UDim2.new(0,4,0,4)
    barBg.BackgroundColor3 = Color3.fromRGB(5,5,5); barBg.BackgroundTransparency = 0.3; barBg.BorderSizePixel = 0; barBg.Parent = AutoSteal.barContainer
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 10)
    AutoSteal.progressBar = Instance.new("Frame"); AutoSteal.progressBar.Size = UDim2.new(0,0,1,0)
    AutoSteal.progressBar.BackgroundColor3 = Color3.fromRGB(255,255,255); AutoSteal.progressBar.BorderSizePixel = 0; AutoSteal.progressBar.Parent = barBg
    Instance.new("UICorner", AutoSteal.progressBar).CornerRadius = UDim.new(0, 10)
    AutoSteal.statusLabel = Instance.new("TextLabel"); AutoSteal.statusLabel.Size = UDim2.new(1,0,1,0)
    AutoSteal.statusLabel.BackgroundTransparency = 1; AutoSteal.statusLabel.Text = "LISTENING"
    AutoSteal.statusLabel.TextColor3 = Color3.fromRGB(255,255,255); AutoSteal.statusLabel.TextSize = 13
    AutoSteal.statusLabel.Font = Enum.Font.GothamBold; AutoSteal.statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    AutoSteal.statusLabel.Parent = AutoSteal.barContainer
end
local function updateProgress(duration)
    local startTime = tick(); AutoSteal.statusLabel.Text = "STEALING"
    if AutoSteal.progressConnection then AutoSteal.progressConnection:Disconnect(); AutoSteal.progressConnection = nil end
    AutoSteal.progressConnection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime; local progress = math.min(elapsed / duration, 1)
        AutoSteal.progressBar.Size = UDim2.new(progress, 0, 1, 0)
        AutoSteal.statusLabel.Text = "STEALING " .. math.floor(progress * 100) .. "%"
        if progress >= 1 then
            AutoSteal.progressConnection:Disconnect(); AutoSteal.progressConnection = nil
            AutoSteal.progressBar.Size = UDim2.new(0,0,1,0); AutoSteal.statusLabel.Text = "LISTENING"
        end
    end)
end
local function getHRP()
    local c = lp.Character
    if c then return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") end
    return nil
end
local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot = plots:FindFirstChild(pn); if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign"); if not sign then return false end
    local yb = sign:FindFirstChild("YourBase")
    return yb and yb:IsA("BillboardGui") and yb.Enabled == true
end
local function findNearestPrompt()
    local hrp = getHRP(); if not hrp then return nil end
    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            local base = pod:FindFirstChild("Base"); if not base then continue end
            local spawn = base:FindFirstChild("Spawn"); if not spawn then continue end
            local d = (spawn.Position - hrp.Position).Magnitude
            if d <= AutoSteal.STEAL_RADIUS and d < dist then
                local att = spawn:FindFirstChild("PromptAttachment")
                if att then
                    for _, p in ipairs(att:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:find("Steal") then nearest, dist = p, d end
                    end
                end
            end
        end
    end
    return nearest
end
local function executeSteal(prompt)
    if AutoSteal.isStealing then return end
    if not AutoSteal.StealData[prompt] then
        AutoSteal.StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(AutoSteal.StealData[prompt].hold, c.Function) end end
            for _, c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(AutoSteal.StealData[prompt].trigger, c.Function) end end
        end
    end
    local data = AutoSteal.StealData[prompt]
    if not data.ready then return end
    data.ready = false; AutoSteal.isStealing = true
    updateProgress(AutoSteal.STEAL_DURATION)
    task.spawn(function()
        for _, f in ipairs(data.hold) do pcall(function() f() end) end
        task.wait(AutoSteal.STEAL_DURATION)
        for _, f in ipairs(data.trigger) do pcall(function() f() end) end
        data.ready = true; AutoSteal.isStealing = false
    end)
end
local function enableAutoSteal()
    if AutoSteal.Enabled then return end
    AutoSteal.Enabled = true
    if not AutoSteal.screenGui then createStealUI() end
    AutoSteal.screenGui.Enabled = true
    lp.CharacterAdded:Connect(function() AutoSteal.isStealing = false end)
    AutoSteal.heartbeatConn = RunService.Heartbeat:Connect(function()
        if not AutoSteal.Enabled or AutoSteal.isStealing then return end
        local ok, prompt = pcall(findNearestPrompt)
        if ok and prompt then pcall(executeSteal, prompt) end
    end)
end
local function disableAutoSteal()
    if not AutoSteal.Enabled then return end
    AutoSteal.Enabled = false
    if AutoSteal.screenGui then AutoSteal.screenGui.Enabled = false end
    if AutoSteal.heartbeatConn then AutoSteal.heartbeatConn:Disconnect(); AutoSteal.heartbeatConn = nil end
    if AutoSteal.progressConnection then AutoSteal.progressConnection:Disconnect(); AutoSteal.progressConnection = nil end
    AutoSteal.isStealing = false
end

-- STRETCH RES
local STRETCH_NAME = "FadedVS_Stretch"
local function enableStretchRez()
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function()
        RunService:BindToRenderStep(STRETCH_NAME, Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if cam then cam.CFrame = cam.CFrame * CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end
        end)
    end)
end
local function disableStretchRez()
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
end

-- AUTO RESET (MEDUSA)
local autoResetOnMedusaEnabled = false
local autoResetMedusaDebounce = false
local autoResetMedusaConns = {}
local autoResetRemote = nil
local AUTO_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

task.spawn(function()
    task.wait(2)
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then autoResetRemote = desc; break end
    end
end)

local function autoCursedReset()
    if not autoResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then autoResetRemote = desc; break end
        end
    end
    if not autoResetRemote then return end
    local character = LocalPlayer.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local resetDetected = false
    local conns = {}
    if hum then
        table.insert(conns, hum.Died:Connect(function() resetDetected = true end))
    end
    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end
            pcall(function() autoResetRemote:FireServer(AUTO_RESET_GUID, LocalPlayer, "balloon") end)
            task.wait()
        end
        for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local function onAnchorChangedAutoReset(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not autoResetOnMedusaEnabled then return end
        if part.Anchored and part.Transparency == 1 then
            if autoResetMedusaDebounce then return end
            autoResetMedusaDebounce = true
            task.spawn(function() autoCursedReset(); task.wait(3); autoResetMedusaDebounce = false end)
        end
    end)
end

local function setupAutoResetOnMedusa(char)
    for _, c in pairs(autoResetMedusaConns) do pcall(function() c:Disconnect() end) end
    autoResetMedusaConns = {}
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        table.insert(autoResetMedusaConns, hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if not autoResetOnMedusaEnabled then return end
            if hum.PlatformStand then
                if autoResetMedusaDebounce then return end
                autoResetMedusaDebounce = true
                task.spawn(function() autoCursedReset(); task.wait(3); autoResetMedusaDebounce = false end)
            end
        end))
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(autoResetMedusaConns, onAnchorChangedAutoReset(part)) end
    end
    table.insert(autoResetMedusaConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(autoResetMedusaConns, onAnchorChangedAutoReset(part)) end
    end))
end

local function stopAutoResetOnMedusa()
    for _, c in pairs(autoResetMedusaConns) do pcall(function() c:Disconnect() end) end
    autoResetMedusaConns = {}
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if autoResetOnMedusaEnabled then setupAutoResetOnMedusa(char) end
end)

-- ANTI-RAGDOLL
local antiRagdollEnabled = false
local antiRagdollCached = {}
local antiRagdollConn = nil
local function cacheCharacter()
    local char = LocalPlayer.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    antiRagdollCached = {character = char, humanoid = hum, root = root}; return true
end
local function isRagdolled()
    local hum = antiRagdollCached.humanoid; if not hum then return false end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then return true end
    local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
    if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
    return false
end
local function removeRagdollConstraints()
    for _, v in ipairs(antiRagdollCached.character:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or (v:IsA("Attachment") and v.Name:find("RagdollAttachment")) then pcall(function() v:Destroy() end) end
    end
end
local function forceExitRagdoll()
    local hum = antiRagdollCached.humanoid; local root = antiRagdollCached.root
    if not hum or not root then return end
    pcall(function() LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
    if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
    root.Anchored = false; root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
    local cam = workspace.CurrentCamera
    if cam and cam.CameraSubject ~= hum then cam.CameraSubject = hum end
end
local function startAntiRagdoll()
    if antiRagdollConn then return end
    if not cacheCharacter() then return end
    antiRagdollConn = RunService.RenderStepped:Connect(function()
        if not antiRagdollEnabled then antiRagdollConn:Disconnect(); antiRagdollConn = nil; return end
        if not antiRagdollCached.humanoid or not antiRagdollCached.humanoid.Parent then return end
        if isRagdolled() then removeRagdollConstraints(); forceExitRagdoll() end
    end)
end
local function stopAntiRagdoll()
    if antiRagdollConn then antiRagdollConn:Disconnect(); antiRagdollConn = nil end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5); if antiRagdollEnabled then startAntiRagdoll() end
end)

-- ESP + TRACERS
local espEnabled = false
local espObjects = {}
local espConns = {}
local camera = workspace.CurrentCamera
local function isTargetValid(plr)
    if plr == LocalPlayer then return false end
    local char = plr.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return false end
    if hum.Health <= 0 then return false end
    if char:FindFirstChildOfClass("ForceField") then return false end
    return true
end
local function removeESP(plr)
    local data = espObjects[plr]
    if data then if data.Group then data.Group:Destroy() end; if data.Tracer then data.Tracer:Remove() end end
    espObjects[plr] = nil
end
local function createESP(plr)
    if not isTargetValid(plr) then return end
    if espObjects[plr] then return end
    local char = plr.Character
    local root = char:FindFirstChild("HumanoidRootPart"); local head = char:FindFirstChild("Head")
    if not root or not head then return end
    local group = Instance.new("Folder"); group.Name = "FadedESP"; group.Parent = char
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root; box.Size = Vector3.new(4,6,2); box.Color3 = ACCENT_COLOR; box.Transparency = 0.7; box.ZIndex = 10; box.AlwaysOnTop = true; box.Parent = group
    local bb = Instance.new("BillboardGui"); bb.Adornee = head; bb.Size = UDim2.new(0,200,0,45); bb.StudsOffset = Vector3.new(0,4.2,0); bb.AlwaysOnTop = true; bb.Parent = group
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.Text = plr.DisplayName; lbl.TextColor3 = ACCENT_COLOR; lbl.Font = Enum.Font.GothamBold; lbl.TextScaled = true; lbl.TextStrokeTransparency = 0.3; lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0); lbl.Parent = bb
    local healthBB = Instance.new("BillboardGui"); healthBB.Adornee = head; healthBB.Size = UDim2.new(0,50,0,6); healthBB.StudsOffset = Vector3.new(0,2.2,0); healthBB.AlwaysOnTop = true; healthBB.Parent = group
    local healthBg = Instance.new("Frame"); healthBg.Size = UDim2.new(1,0,1,0); healthBg.BackgroundColor3 = Color3.fromRGB(30,30,30); healthBg.BorderSizePixel = 0; healthBg.Parent = healthBB
    local healthFill = Instance.new("Frame"); healthFill.Size = UDim2.new(1,0,1,0); healthFill.BackgroundColor3 = ACCENT_COLOR; healthFill.BorderSizePixel = 0; healthFill.Parent = healthBg
    local tracer = Drawing.new("Line"); tracer.Visible = true; tracer.Color = Color3.new(1,1,1); tracer.Thickness = 2; tracer.Transparency = 0.5; tracer.ZIndex = 5
    espObjects[plr] = {Group=group,Tracer=tracer,Root=root,HealthFill=healthFill,Player=plr}
end
local function updateESP()
    if not espEnabled then return end
    local localChar = LocalPlayer.Character; if not localChar then return end
    local localRoot = localChar:FindFirstChild("HumanoidRootPart"); if not localRoot then return end
    local localPos, localVisible = camera:WorldToViewportPoint(localRoot.Position)
    for plr, data in pairs(espObjects) do
        if not isTargetValid(plr) then removeESP(plr)
        else
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and data.HealthFill then
                local health = hum.Health / hum.MaxHealth
                data.HealthFill.Size = UDim2.new(health, 0, 1, 0)
                data.HealthFill.BackgroundColor3 = Color3.fromHSV(health * 0.3, 1, 0.6)
            end
            if data.Root and data.Tracer and localVisible then
                local enemyPos, enemyVisible = camera:WorldToViewportPoint(data.Root.Position)
                if enemyVisible then data.Tracer.From = Vector2.new(localPos.X, localPos.Y); data.Tracer.To = Vector2.new(enemyPos.X, enemyPos.Y); data.Tracer.Visible = true
                else data.Tracer.Visible = false end
            end
        end
    end
end
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then pcall(function() createESP(plr) end) end end
    for _, conn in ipairs(espConns) do if conn and conn.Connected then conn:Disconnect() end end
    espConns = {}
    table.insert(espConns, Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer then return end
        plr.CharacterAdded:Connect(function() task.wait(0.1); if espEnabled then pcall(function() createESP(plr) end) end end)
    end))
    table.insert(espConns, Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end))
    table.insert(espConns, RunService.RenderStepped:Connect(function() if espEnabled then updateESP() end end))
end
local function disableESP()
    espEnabled = false
    for plr in pairs(espObjects) do removeESP(plr) end
    espObjects = {}
    for _, conn in ipairs(espConns) do if conn and conn.Connected then conn:Disconnect() end end
    espConns = {}
end

-- OTHER PLAYERS SPEED
local otherPlayerSpeedEnabled = false
local otherPlayerSpeedConn = nil
local otherPlayerSpeedBBs = {}
local function createOtherPlayerSpeedBB(player)
    if not player or player == LocalPlayer then return end
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if otherPlayerSpeedBBs[player] then pcall(function() otherPlayerSpeedBBs[player]:Destroy() end); otherPlayerSpeedBBs[player] = nil end
    local bb = Instance.new("BillboardGui"); bb.Adornee = hrp; bb.Size = UDim2.new(0,80,0,24)
    bb.StudsOffset = Vector3.new(0,4.0,0); bb.AlwaysOnTop = true; bb.Parent = hrp
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.TextColor3 = ACCENT_COLOR; lbl.TextStrokeTransparency = 0; lbl.TextScaled = true; lbl.Text = "0.0"; lbl.Font = Enum.Font.GothamBold; lbl.Parent = bb
    otherPlayerSpeedBBs[player] = bb
    return bb
end
local function updateOtherPlayerSpeeds()
    if not otherPlayerSpeedEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bb = otherPlayerSpeedBBs[player]
                    if not bb or not bb.Parent then bb = createOtherPlayerSpeedBB(player) end
                    if bb then
                        local lbl = bb:FindFirstChildOfClass("TextLabel")
                        if lbl then
                            local v = hrp.AssemblyLinearVelocity; local speed = Vector3.new(v.X,0,v.Z).Magnitude
                            lbl.TextColor3 = speed > 60 and Color3.fromRGB(255,50,50) or speed > 40 and Color3.fromRGB(255,200,50) or ACCENT_COLOR
                            lbl.Text = string.format("%.1f", speed)
                        end
                    end
                end
            end
        end
    end
end
local function startOtherPlayerSpeedChecker()
    if otherPlayerSpeedConn then return end
    otherPlayerSpeedEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            task.spawn(function()
                player.CharacterAdded:Connect(function() task.wait(0.2); if otherPlayerSpeedEnabled then createOtherPlayerSpeedBB(player) end end)
                createOtherPlayerSpeedBB(player)
            end)
        end
    end
    otherPlayerSpeedConn = RunService.Heartbeat:Connect(updateOtherPlayerSpeeds)
end
local function stopOtherPlayerSpeedChecker()
    otherPlayerSpeedEnabled = false
    if otherPlayerSpeedConn then otherPlayerSpeedConn:Disconnect(); otherPlayerSpeedConn = nil end
    for player, bb in pairs(otherPlayerSpeedBBs) do pcall(function() bb:Destroy() end) end
    otherPlayerSpeedBBs = {}
end

-- SHINY GRAPHICS
local shinyEnabled = false
local originalSkybox, shinyGraphicsSky, shinyGraphicsConn, shinyBloom, shinyCC = nil, nil, nil, nil, nil
local shinyPlanets = {}
local function enableShinyGraphics()
    if shinyGraphicsSky then return end
    originalSkybox = Lighting:FindFirstChildOfClass("Sky"); if originalSkybox then originalSkybox.Parent = nil end
    shinyGraphicsSky = Instance.new("Sky")
    for _, prop in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"}) do shinyGraphicsSky[prop] = "rbxassetid://1534951537" end
    shinyGraphicsSky.StarCount = 10000; shinyGraphicsSky.CelestialBodiesShown = false; shinyGraphicsSky.Parent = Lighting
    shinyBloom = Instance.new("BloomEffect"); shinyBloom.Intensity = 1.5; shinyBloom.Size = 40; shinyBloom.Threshold = 0.8; shinyBloom.Parent = Lighting
    shinyCC = Instance.new("ColorCorrectionEffect"); shinyCC.Saturation = 0.8; shinyCC.Contrast = 0.3; shinyCC.TintColor = Color3.fromRGB(200,200,200); shinyCC.Parent = Lighting
    Lighting.Ambient = Color3.fromRGB(100,100,110); Lighting.Brightness = 3; Lighting.ClockTime = 0
    for i = 1, 2 do
        local p = Instance.new("Part"); p.Shape = Enum.PartType.Ball; p.Size = Vector3.new(800+i*200,800+i*200,800+i*200)
        p.Anchored = true; p.CanCollide = false; p.CastShadow = false; p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(160+i*15,160+i*15,165+i*15); p.Transparency = 0.3
        p.Position = Vector3.new(math.cos(i*2)*(3000+i*500),1500+i*300,math.sin(i*2)*(3000+i*500))
        p.Parent = workspace; table.insert(shinyPlanets, p)
    end
    shinyGraphicsConn = RunService.Heartbeat:Connect(function()
        if not shinyEnabled then return end
        local t = tick() * 0.5
        Lighting.Ambient = Color3.fromRGB(100+math.sin(t)*30,100+math.sin(t*0.8)*30,110+math.sin(t*1.2)*30)
        if shinyBloom then shinyBloom.Intensity = 1.2 + math.sin(t*2) * 0.4 end
    end)
end
local function disableShinyGraphics()
    if shinyGraphicsConn then shinyGraphicsConn:Disconnect(); shinyGraphicsConn = nil end
    if shinyGraphicsSky then shinyGraphicsSky:Destroy(); shinyGraphicsSky = nil end
    if originalSkybox then originalSkybox.Parent = Lighting end
    if shinyBloom then shinyBloom:Destroy(); shinyBloom = nil end
    if shinyCC then shinyCC:Destroy(); shinyCC = nil end
    for _, obj in ipairs(shinyPlanets) do if obj then obj:Destroy() end end
    shinyPlanets = {}
    Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.Brightness = 2; Lighting.ClockTime = 14
end

-- ANTI-LAG
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local defLightBrightness, defLightClock, defLightAmbient
local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end
local function enableAntiLag()
    removeAccessoriesEnabled = true; antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1e10; Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end)
end
local function disableAntiLag()
    removeAccessoriesEnabled = false; antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
    end)
end

-- GUI HELPERS
local function createToggle(parent, text, yPos, callback, initialState)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,40); frame.Position = UDim2.new(0,10,0,yPos)
    frame.BackgroundColor3 = BG_COLOR; frame.BackgroundTransparency = 0.3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = ACCENT_COLOR; frameStroke.Thickness = 1; frameStroke.Transparency = 0.3
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6,-10,1,0); label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = MAIN_TEXT
    label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
    local toggleBtn = Instance.new("Frame", frame)
    toggleBtn.Size = UDim2.new(0,28,0,28); toggleBtn.Position = UDim2.new(1,-40,0.5,-14)
    toggleBtn.BackgroundColor3 = TOGGLE_OFF; Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)
    local toggleStroke = Instance.new("UIStroke", toggleBtn); toggleStroke.Color = ACCENT_COLOR; toggleStroke.Thickness = 1; toggleStroke.Transparency = 0.5
    local innerDot = Instance.new("Frame", toggleBtn)
    innerDot.Size = UDim2.new(0,12,0,12); innerDot.Position = UDim2.new(0.5,-6,0.5,-6)
    innerDot.BackgroundColor3 = TOGGLE_OFF; Instance.new("UICorner", innerDot).CornerRadius = UDim.new(1,0)
    local clickBtn = Instance.new("TextButton", frame)
    clickBtn.Size = UDim2.new(0,40,0,40); clickBtn.Position = UDim2.new(1,-46,0.5,-20)
    clickBtn.BackgroundTransparency = 1; clickBtn.Text = ""; clickBtn.AutoButtonColor = false
    local enabled = false
    local function updateToggle(state)
        enabled = state
        toggleBtn.BackgroundColor3 = enabled and TOGGLE_ON or TOGGLE_OFF
        innerDot.BackgroundColor3 = enabled and TOGGLE_ON or TOGGLE_OFF
        toggleStroke.Transparency = enabled and 0 or 0.5
        frameStroke.Transparency = enabled and 0 or 0.3
        frameStroke.Thickness = enabled and 1.5 or 1
        callback(enabled)
    end
    if initialState then updateToggle(true) end
    clickBtn.MouseButton1Click:Connect(function() updateToggle(not enabled) end)
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then updateToggle(not enabled) end
    end)
    return frame, updateToggle
end

local function createInputBox(parent, labelText, yPos, defaultValue, callback, minVal, maxVal)
    minVal = minVal or 15; maxVal = maxVal or 200
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,40); frame.Position = UDim2.new(0,10,0,yPos)
    frame.BackgroundColor3 = BG_COLOR; frame.BackgroundTransparency = 0.3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5,-10,1,0); label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1; label.Text = labelText; label.TextColor3 = MAIN_TEXT
    label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
    local inputBox = Instance.new("TextBox", frame)
    inputBox.Size = UDim2.new(0,60,0,30); inputBox.Position = UDim2.new(1,-72,0.5,-15)
    inputBox.BackgroundColor3 = GLASS_COLOR; inputBox.BackgroundTransparency = 0.3
    inputBox.Text = tostring(defaultValue); inputBox.TextColor3 = ACCENT_COLOR
    inputBox.Font = Enum.Font.GothamBold; inputBox.TextSize = 14
    inputBox.TextXAlignment = Enum.TextXAlignment.Center; inputBox.ClearTextOnFocus = false
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)
    inputBox.FocusLost:Connect(function()
        local num = tonumber(inputBox.Text)
        if num then num = math.clamp(num, minVal, maxVal); inputBox.Text = tostring(num); callback(num)
        else inputBox.Text = tostring(defaultValue); callback(defaultValue) end
    end)
    return frame
end

local function createHeader(parent, text, yPos)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,30); frame.Position = UDim2.new(0,10,0,yPos)
    frame.BackgroundColor3 = BG_COLOR; frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-10,1,0); label.Position = UDim2.new(0,5,0,0)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = ACCENT_COLOR
    label.Font = Enum.Font.GothamBold; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Center
    return frame
end

local function createKeybindRow(parent, labelText, yPos, keybindTable, configKey, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,40); frame.Position = UDim2.new(0,10,0,yPos)
    frame.BackgroundColor3 = BG_COLOR; frame.BackgroundTransparency = 0.3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = ACCENT_COLOR; frameStroke.Thickness = 1; frameStroke.Transparency = 0.3
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5,-10,1,0); label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1; label.Text = labelText; label.TextColor3 = MAIN_TEXT
    label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
    local keyBtn = Instance.new("TextButton", frame)
    keyBtn.Size = UDim2.new(0,80,0,28); keyBtn.Position = UDim2.new(1,-92,0.5,-14)
    keyBtn.BackgroundColor3 = GLASS_COLOR; keyBtn.BackgroundTransparency = 0.3
    keyBtn.Text = keybindTable.kb and keybindTable.kb.Name or "None"
    keyBtn.TextColor3 = ACCENT_COLOR; keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 11; keyBtn.ZIndex = 5
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
    local listening = false; local oldText = ""
    keyBtn.MouseButton1Click:Connect(function()
        if listening then listening = false; anyKeyListening = false; keyBtn.Text = oldText; return end
        listening = true; anyKeyListening = true; oldText = keyBtn.Text; keyBtn.Text = "..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(inp)
            if not listening then conn:Disconnect(); return end
            if inp.KeyCode == Enum.KeyCode.Escape then
                listening = false; anyKeyListening = false; keyBtn.Text = oldText; conn:Disconnect(); return
            end
            local isValid = false; local isGamepad = false
            if inp.UserInputType == Enum.UserInputType.Keyboard then isValid = true
            elseif inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") then
                local gpKeys = {[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
                if gpKeys[inp.KeyCode] then isValid = true; isGamepad = true end
            end
            if isValid then
                if isGamepad then keybindTable.gp = inp.KeyCode; keybindTable.kb = nil
                else keybindTable.kb = inp.KeyCode; keybindTable.gp = nil end
                keyBtn.Text = inp.KeyCode.Name
                if configKey then Config[configKey] = inp.KeyCode.Name; SaveConfig() end
                listening = false; anyKeyListening = false; conn:Disconnect()
                if callback then callback() end
            end
        end)
    end)
    return frame
end

-- KEYS TAB
local keysContent = tabContents["Keys"]
local keysY = 10
createHeader(keysContent, "----- KEYBINDS -----", keysY); keysY = keysY + 35
createKeybindRow(keysContent, "TP Down",     keysY, keybinds.tpDown,     "KB TP Down");    keysY = keysY + 50
createKeybindRow(keysContent, "Drop BR",     keysY, keybinds.dropBR,     "KB Drop BR");    keysY = keysY + 50
createKeybindRow(keysContent, "Bat Aimbot",  keysY, keybinds.batAimbot,  "KB Bat Aimbot"); keysY = keysY + 50
createKeybindRow(keysContent, "Auto Left",   keysY, keybinds.autoLeft,   "KB Auto Left");  keysY = keysY + 50
createKeybindRow(keysContent, "Auto Right",  keysY, keybinds.autoRight,  "KB Auto Right"); keysY = keysY + 50
createKeybindRow(keysContent, "Lagger Mode", keysY, keybinds.laggerMode, "KB Lagger Mode");keysY = keysY + 50
keysContent.CanvasSize = UDim2.new(0, 0, 0, keysY + 20)

-- SPEED TAB
local speedContent = tabContents["Speed"]
local speedY = 10
local smInfoFrame = Instance.new("Frame", speedContent)
smInfoFrame.Size = UDim2.new(1,-20,0,36); smInfoFrame.Position = UDim2.new(0,10,0,speedY)
smInfoFrame.BackgroundColor3 = BG_COLOR; smInfoFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", smInfoFrame).CornerRadius = UDim.new(0,8)
local smLbl = Instance.new("TextLabel", smInfoFrame)
smLbl.Size = UDim2.new(1,0,1,0); smLbl.BackgroundTransparency = 1; smLbl.Text = "Speed Mode  [ALWAYS ON]"
smLbl.TextColor3 = ACCENT_COLOR; smLbl.Font = Enum.Font.GothamBold; smLbl.TextSize = 12; smLbl.TextXAlignment = Enum.TextXAlignment.Center
speedY = speedY + 46
createHeader(speedContent, "----- NORMAL -----", speedY); speedY = speedY + 35
createInputBox(speedContent, "Normal Speed", speedY, normalSpeedValue, function(v) setNormalSpeed(v); Config["Normal Speed"] = v; SaveConfig() end)
speedY = speedY + 50
createInputBox(speedContent, "Carry Speed", speedY, carrySpeedValue, function(v) setCarrySpeed(v); Config["Carry Speed"] = v; SaveConfig() end)
speedY = speedY + 50
createHeader(speedContent, "----- LAGGER -----", speedY); speedY = speedY + 35
local _, laggerToggleSetVisualFn = createToggle(speedContent, "Lagger Mode  [R]", speedY, function(enabled)
    isLaggerModeActive = enabled; Config["Lagger Mode"] = enabled; SaveConfig()
end, Config["Lagger Mode"])
laggerToggleSetVisual = laggerToggleSetVisualFn
speedY = speedY + 50
createInputBox(speedContent, "Lagger Boost", speedY, laggerBoostValue, function(v) setLaggerBoost(v); Config["Lagger Boost"] = v; SaveConfig() end, 1, 200)
speedY = speedY + 50
createInputBox(speedContent, "Lagger Steal", speedY, laggerStealValue, function(v) setLaggerSteal(v); Config["Lagger Steal"] = v; SaveConfig() end, 1, 200)
speedY = speedY + 50
speedContent.CanvasSize = UDim2.new(0, 0, 0, speedY + 20)

-- COMBAT TAB
local combatContent = tabContents["Combat"]
local combatY = 10
createToggle(combatContent, "Unwalk", combatY, function(enabled) unwalkEnabled = enabled; Config["Unwalk"] = enabled; if enabled then startUnwalk() else stopUnwalk() end; SaveConfig() end, Config["Unwalk"])
combatY = combatY + 50
createToggle(combatContent, "Bat Counter", combatY, function(enabled) batCounterEnabled = enabled; Config["Bat Counter"] = enabled; if enabled then startBatCounter() else stopBatCounter() end; SaveConfig() end, Config["Bat Counter"])
combatY = combatY + 50
createToggle(combatContent, "Medusa Counter", combatY, function(enabled) medusaCounterEnabled = enabled; Config["Medusa Counter"] = enabled; if enabled then setupMedusa(LocalPlayer.Character) else stopMedusaCounter() end; SaveConfig() end, Config["Medusa Counter"])
combatY = combatY + 50
createToggle(combatContent, "Auto Steal", combatY, function(enabled) Config["Auto Steal"] = enabled; if enabled then enableAutoSteal() else disableAutoSteal() end; SaveConfig() end, Config["Auto Steal"])
combatY = combatY + 50
createToggle(combatContent, "Stretch Resolution", combatY, function(enabled) Config["Stretch Resolution"] = enabled; if enabled then enableStretchRez() else disableStretchRez() end; SaveConfig() end, Config["Stretch Resolution"])
combatY = combatY + 50
createToggle(combatContent, "Auto Reset (Medusa)", combatY, function(enabled) autoResetOnMedusaEnabled = enabled; Config["Auto Reset Medusa"] = enabled; if enabled then setupAutoResetOnMedusa(LocalPlayer.Character) else stopAutoResetOnMedusa() end; SaveConfig() end, Config["Auto Reset Medusa"])
combatY = combatY + 50
createToggle(combatContent, "Anti-Ragdoll", combatY, function(enabled) antiRagdollEnabled = enabled; Config["Anti Ragdoll"] = enabled; if enabled then startAntiRagdoll() else stopAntiRagdoll() end; SaveConfig() end, Config["Anti Ragdoll"])
combatY = combatY + 50
createToggle(combatContent, "ESP + Tracers", combatY, function(enabled) Config["ESP Tracers"] = enabled; if enabled then enableESP() else disableESP() end; SaveConfig() end, Config["ESP Tracers"])
combatY = combatY + 50
createToggle(combatContent, "Infinite Jump", combatY, function(enabled)
    infJumpEnabled = enabled; Config["Infinite Jump"] = enabled
    if not enabled then holdJumpActive = false; holdJumpPressed = false end
    SaveConfig()
end, Config["Infinite Jump"])
combatY = combatY + 50
local modeFrame = Instance.new("Frame", combatContent)
modeFrame.Size = UDim2.new(1,-20,0,40); modeFrame.Position = UDim2.new(0,10,0,combatY)
modeFrame.BackgroundColor3 = BG_COLOR; modeFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", modeFrame).CornerRadius = UDim.new(0,8)
local modeLbl = Instance.new("TextLabel", modeFrame)
modeLbl.Size = UDim2.new(0.35,0,1,0); modeLbl.Position = UDim2.new(0,12,0,0)
modeLbl.BackgroundTransparency = 1; modeLbl.Text = "Jump Mode"; modeLbl.TextColor3 = MAIN_TEXT; modeLbl.Font = Enum.Font.GothamBold; modeLbl.TextSize = 13; modeLbl.TextXAlignment = Enum.TextXAlignment.Left
local singleBtn = Instance.new("TextButton", modeFrame)
singleBtn.Size = UDim2.new(0,64,0,26); singleBtn.Position = UDim2.new(1,-142,0.5,-13)
singleBtn.BackgroundColor3 = infJumpMode == "Single" and ACCENT_COLOR or TOGGLE_OFF
singleBtn.Text = "Single"; singleBtn.TextColor3 = infJumpMode == "Single" and BG_COLOR or MAIN_TEXT
singleBtn.Font = Enum.Font.GothamBold; singleBtn.TextSize = 11; singleBtn.BorderSizePixel = 0
Instance.new("UICorner", singleBtn).CornerRadius = UDim.new(0,6)
local holdBtn = Instance.new("TextButton", modeFrame)
holdBtn.Size = UDim2.new(0,64,0,26); holdBtn.Position = UDim2.new(1,-72,0.5,-13)
holdBtn.BackgroundColor3 = infJumpMode == "Hold" and ACCENT_COLOR or TOGGLE_OFF
holdBtn.Text = "Hold"; holdBtn.TextColor3 = infJumpMode == "Hold" and BG_COLOR or MAIN_TEXT
holdBtn.Font = Enum.Font.GothamBold; holdBtn.TextSize = 11; holdBtn.BorderSizePixel = 0
Instance.new("UICorner", holdBtn).CornerRadius = UDim.new(0,6)
local function updateModeButtons()
    singleBtn.BackgroundColor3 = infJumpMode == "Single" and ACCENT_COLOR or TOGGLE_OFF
    singleBtn.TextColor3 = infJumpMode == "Single" and BG_COLOR or MAIN_TEXT
    holdBtn.BackgroundColor3 = infJumpMode == "Hold" and ACCENT_COLOR or TOGGLE_OFF
    holdBtn.TextColor3 = infJumpMode == "Hold" and BG_COLOR or MAIN_TEXT
end
singleBtn.MouseButton1Click:Connect(function()
    infJumpMode = "Single"; holdJumpActive = false; holdJumpPressed = false
    Config["Inf Jump Mode"] = "Single"; SaveConfig(); updateModeButtons()
end)
holdBtn.MouseButton1Click:Connect(function()
    infJumpMode = "Hold"; Config["Inf Jump Mode"] = "Hold"; SaveConfig(); updateModeButtons()
end)
combatY = combatY + 50
combatContent.CanvasSize = UDim2.new(0, 0, 0, combatY + 60)

-- SETTINGS TAB
local settingsContent = tabContents["Settings"]
local settingsY = 10
createToggle(settingsContent, "Shiny Graphics", settingsY, function(enabled) shinyEnabled = enabled; Config["Shiny Graphics"] = enabled; if enabled then enableShinyGraphics() else disableShinyGraphics() end; SaveConfig() end, Config["Shiny Graphics"])
settingsY = settingsY + 50
createToggle(settingsContent, "Anti-Lag", settingsY, function(enabled) Config["Anti Lag"] = enabled; if enabled then enableAntiLag() else disableAntiLag() end; SaveConfig() end, Config["Anti Lag"])
settingsY = settingsY + 50
createToggle(settingsContent, "Other Players Speed", settingsY, function(enabled) Config["Other Players Speed"] = enabled; if enabled then startOtherPlayerSpeedChecker() else stopOtherPlayerSpeedChecker() end; SaveConfig() end, Config["Other Players Speed"])
settingsY = settingsY + 50
settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsY + 60)

-- SELECT TAB
local function selectTab(tabName)
    for name, btn in pairs(tabButtons) do
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = MAIN_TEXT}):Play()
        local frame = tabFrames[name]
        if frame then
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            local stroke = frame:FindFirstChild("UIStroke"); if stroke then stroke.Thickness = 0.5 end
        end
    end
    for _, content in pairs(tabContents) do content.Visible = false end
    selectedTab = tabName
    local btn = tabButtons[tabName]
    if btn then
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = ACCENT_COLOR}):Play()
        local frame = tabFrames[tabName]
        if frame then
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
            local stroke = frame:FindFirstChild("UIStroke"); if stroke then stroke.Thickness = 1.5 end
        end
    end
    local content = tabContents[tabName]
    if content then content.Visible = true end
end
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() selectTab(tabName) end)
end
selectTab("Speed")

-- MINIMIZE
local isMinimized = false
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        dp.Visible = false; miniBar.Visible = true; minBtn.Text = "+"
    else
        dp.Visible = true; miniBar.Visible = false; minBtn.Text = "_"
    end
end
minBtn.MouseButton1Click:Connect(toggleMinimize)

-- DECORATIVE GLOWS
local function createGlow(xPos, yPos, size)
    local glow = Instance.new("Frame", dp)
    glow.Size = UDim2.new(0,size,0,size); glow.Position = UDim2.new(0,xPos,0,yPos)
    glow.BackgroundColor3 = ACCENT_COLOR; glow.BackgroundTransparency = 0.8
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1,0)
end
createGlow(20, 20, 4)
createGlow(PW - 50, 20, 4)

print("Faded.vs + Botones Flotantes cargados correctamente!")
print("Teclas: T=Auto Left | C=Auto Right | R=Lagger Mode | G=TP Down | Q=Drop BR | X=Bat Aimbot")