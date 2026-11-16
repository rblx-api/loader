repeat task.wait() until game:IsLoaded()

local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS,CS = 60,30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,true
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed,dropActive = false,0,false
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatSetVisual = nil
local autoBatEquippedThisRun = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED,AUTO_BAT_VERT_SPEED,AUTO_BAT_DIST,AUTO_BAT_HEIGHT,AUTO_BAT_V_OFF,AUTO_BAT_TURN_SPEED,AUTO_BAT_MAX_TURN_RATE = 58,52,-2.8,4.75,1,285,28
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local setAutoTPVisual = nil
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local _updateMobileAutoLeft, _updateMobileAutoRight, _updateMobileAimbot, _updateMobileLagger, _updateMobileLaggerCarry, _updateMobileCarrySpeed
local _updateMobileBatV2
local uiLocked = false
local IJ_Conn = nil
local IJ_HeartbeatConn = nil

local autoSwitchSpeedEnabled = false
local _autoSwitchWasSteal = false
local setAutoSwitchVisual = nil

local batV2Enabled = false
local batV2Conn = nil
local batV2PrevAutoRotate = nil
local batV2HitCD = false
local BAT_V2_SWING_COOLDOWN = 0.35
local BAT_V2_HIT_DIST = 8
local batV2SetVisual = nil

local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local currentPercentage = 0
local currentRadius = 62

-- Drop mode
local dropMode = "stand"  -- "stand" or "jump"

-- Auto Steal mode
local stealMode = "normal"  -- "normal" or "semi"

-- BAT SLAP LIST
local BAT_SLAP_LIST = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

-- ====================== NEW ANTI-RAGDOLL (UNPATCHED OLD) ======================
local antiRagResetCooldown = 0

local function forceReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local antiRagConn = nil

local function startAntiRagdoll()
    if antiRagConn then return end
    antiRagdollEnabled = true
    antiRagConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local isRagdolled = (state == Enum.HumanoidStateType.Physics or
                             state == Enum.HumanoidStateType.Ragdoll or
                             state == Enum.HumanoidStateType.FallingDown)

        if isRagdolled then
            local now = tick()
            if now - antiRagResetCooldown > 0.15 then
                antiRagResetCooldown = now
                forceReset()
            end
        end
    end)
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagConn then
        antiRagConn:Disconnect()
        antiRagConn = nil
    end
end
-- ====================================================================

-- Global bat finder
local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _,name in ipairs(BAT_SLAP_LIST) do
        local t = char:FindFirstChild(name) or (LP:FindFirstChildOfClass("Backpack") and LP:FindFirstChildOfClass("Backpack"):FindFirstChild(name))
        if t and t:IsA("Tool") then return t end
    end
    return nil
end

-- BatV2‑specific bat finder
local function findBatV2()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

-- Infinite Jump
local function startInfiniteJump()
    if IJ_Conn then IJ_Conn:Disconnect() end
    if IJ_HeartbeatConn then IJ_HeartbeatConn:Disconnect() end
    IJ_Conn = UIS.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end
    end)
    IJ_HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
        if jumpHeld and hrp.AssemblyLinearVelocity.Y < 30 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end
        if hrp.AssemblyLinearVelocity.Y < -120 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -120, hrp.AssemblyLinearVelocity.Z)
        end
    end)
end

local function stopInfiniteJump()
    if IJ_Conn then IJ_Conn:Disconnect() end
    if IJ_HeartbeatConn then IJ_HeartbeatConn:Disconnect() end
end

startInfiniteJump()

-- Blacklist check
task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    local function httpGet(url)
        local methods={
            function() return game:HttpGet(url) end,
            function() return HS:GetAsync(url) end,
            function() return syn.request({Url=url,Method="GET"}).Body end,
            function() return http_request({Url=url,Method="GET"}).Body end,
            function() return request({Url=url,Method="GET"}).Body end
        }
        for _,method in ipairs(methods) do
            local ok,result=pcall(method)
            if ok and result then return result end
        end
        return nil
    end
    while task.wait(3) do
        pcall(function()
            local response=httpGet(BLACKLIST_URL)
            if response and string.find(response,tostring(LP.UserId),1,true) then
                LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
                task.wait(999999)
            end
        end)
    end
end)

-- Hook for cursed reset
pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)

task.spawn(function()
    task.wait(2)
    if cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
    end
end)

local function cursedInstaReset()
    if not cursedResetRemote then
        for _,desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
        end
    end
    if not cursedResetRemote then return end
    local character=LP.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
    local resetDetected=false
    local conns={}
    if humanoid then
        table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end))
        table.insert(conns,humanoid:GetPropertyChangedSignal("Health"):Connect(function() if humanoid.Health<=0 then resetDetected=true end end))
    end
    if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
    task.spawn(function()
        for _=1,50 do
            if resetDetected then break end
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end)
            task.wait()
        end
        for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

-- Keybinds
local KB = {
    DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
    AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
    AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
    AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
    BatV2       ={kb=Enum.KeyCode.V,gp=nil},
    TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
    InstaReset  ={kb=Enum.KeyCode.T,gp=nil},
    GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
    SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil},
    LaggerToggle={kb=Enum.KeyCode.R,gp=nil}
}

-- Auto Left/Right waypoints
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)

-- Steal module (unchanged for normal mode)
local Steal = {
    AutoStealEnabled=false,StealRadius=60,StealDuration=1.3,
    Data={}
}
local isStealing = false
local stealStartTime = nil
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil}
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local modeValLbl
local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Right]=true}

-- Progress bar (for normal auto steal & semi)
local function buildProgressBar()
    pcall(function() 
        local old = CoreGui:FindFirstChild("CustomHUD_Final")
        if old then old:Destroy() end
    end)
    local Player = LP
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomHUD_Final"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 52)
    MainFrame.Position = UDim2.new(0.5, -125, 0.75, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = false
    MainFrame.Parent = ScreenGui
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.2
    MainStroke.Color = Color3.fromRGB(200, 200, 200)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    local Dot = Instance.new("Frame")
    Dot.Name = "StatusDot"
    Dot.Size = UDim2.new(0, 6, 0, 6)
    Dot.Position = UDim2.new(0, 10, 0, 9)
    Dot.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    Dot.BorderSizePixel = 0
    Dot.Active = false
    Dot.Parent = MainFrame
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot
    local PercentageLabel = Instance.new("TextLabel")
    PercentageLabel.Name = "PercentageLabel"
    PercentageLabel.Size = UDim2.new(0, 80, 0, 16)
    PercentageLabel.Position = UDim2.new(0, 20, 0, 4)
    PercentageLabel.BackgroundTransparency = 1
    PercentageLabel.Active = false
    PercentageLabel.Text = "0%"
    PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PercentageLabel.TextSize = 14
    PercentageLabel.Font = Enum.Font.GothamBold
    PercentageLabel.TextXAlignment = Enum.TextXAlignment.Left
    PercentageLabel.Parent = MainFrame
    local RadiusLabel = Instance.new("TextLabel")
    RadiusLabel.Name = "RadiusLabel"
    RadiusLabel.Size = UDim2.new(0, 100, 0, 16)
    RadiusLabel.Position = UDim2.new(1, -110, 0, 4)
    RadiusLabel.BackgroundTransparency = 1
    RadiusLabel.Active = false
    RadiusLabel.Text = "Radius: " .. tostring(currentRadius)
    RadiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    RadiusLabel.TextSize = 12
    RadiusLabel.Font = Enum.Font.GothamBold
    RadiusLabel.TextXAlignment = Enum.TextXAlignment.Right
    RadiusLabel.Parent = MainFrame
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.Size = UDim2.new(1, -20, 0, 12)
    InfoLabel.Position = UDim2.new(0, 10, 0, 20)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Active = false
    InfoLabel.Text = "FPS: 0  •  PING: 0ms"
    InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    InfoLabel.TextSize = 9
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.Parent = MainFrame
    local ProgressBackground = Instance.new("Frame")
    ProgressBackground.Name = "ProgressBackground"
    ProgressBackground.Size = UDim2.new(1, -20, 0, 9)
    ProgressBackground.Position = UDim2.new(0, 10, 0, 35)
    ProgressBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ProgressBackground.BorderSizePixel = 0
    ProgressBackground.Active = false
    ProgressBackground.Parent = MainFrame
    local ProgressBgCorner = Instance.new("UICorner")
    ProgressBgCorner.CornerRadius = UDim.new(1, 0)
    ProgressBgCorner.Parent = ProgressBackground
    local ProgressFill = Instance.new("Frame")
    ProgressFill.Name = "ProgressFill"
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.BackgroundColor3 = Color3.fromRGB(200, 30, 30) -- Red fill
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Active = false
    ProgressFill.Parent = ProgressBackground
    local ProgressFillCorner = Instance.new("UICorner")
    ProgressFillCorner.CornerRadius = UDim.new(1, 0)
    ProgressFillCorner.Parent = ProgressFill
    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 30, 30)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 30))
    })
    FillGradient.Rotation = 90
    FillGradient.Parent = ProgressFill
    local progressData = {
        MainFrame = MainFrame,
        ProgressFill = ProgressFill,
        PercentageLabel = PercentageLabel,
        RadiusLabel = RadiusLabel,
        InfoLabel = InfoLabel,
        Dot = Dot
    }
    return progressData
end

local progressData = buildProgressBar()
local stealProgress = 0
local frameCount = 0
local lastUpdate = 0

local function updateStealProgress(progress)
    stealProgress = math.clamp(progress, 0, 1)
    currentPercentage = stealProgress * 100
    
    if progressData and progressData.ProgressFill then
        progressData.ProgressFill.Size = UDim2.new(stealProgress, 0, 1, 0)
    end
    
    if progressData and progressData.PercentageLabel then
        if stealMode == "semi" and stealProgress >= 0.5 then
            progressData.PercentageLabel.Text = "Ready"
            progressData.PercentageLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            progressData.PercentageLabel.Text = math.floor(currentPercentage) .. "%"
            progressData.PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end

local function resetProgressBar()
    stealProgress = 0
    currentPercentage = 0
    if progressData and progressData.ProgressFill then
        progressData.ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    end
    if progressData and progressData.PercentageLabel then
        progressData.PercentageLabel.Text = "0%"
        progressData.PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local function updateRadiusDisplay(radius)
    currentRadius = radius or Steal.StealRadius
    if progressData and progressData.RadiusLabel then
        progressData.RadiusLabel.Text = "Radius: " .. tostring(currentRadius)
    end
end

RunService.RenderStepped:Connect(function(deltaTime)
    frameCount = frameCount + 1
    lastUpdate = lastUpdate + deltaTime
    if lastUpdate >= 0.5 then
        local fps = math.round(frameCount / lastUpdate)
        local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        if progressData and progressData.InfoLabel then
            progressData.InfoLabel.Text = string.format("FPS: %d  •  PING: %dms", fps, ping)
        end
        if progressData and progressData.RadiusLabel then
            progressData.RadiusLabel.Text = "Radius: " .. tostring(currentRadius)
        end
        frameCount = 0
        lastUpdate = 0
    end
end)

local function getActiveMoveSpeed()
    return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS)
end

local function getAutoSwitchSpeed(isCarrying)
    if laggerToggled then
        return isCarrying and LAGGER_CARRY_SPEED or LAGGER_SPEED
    else
        return isCarrying and CS or NS
    end
end

local function getAutoPathSpeed()
    return laggerToggled and LAGGER_SPEED or NS
end

local function isRagdollState(hum)
    if not hum then return true end
    local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

local function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot=plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled==true
        end
    end
    return false
end

-- Normal auto steal functions
local function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base")
            local sp=base and base:FindFirstChild("Spawn")
            if sp then
                local d=(sp.Position-root.Position).Magnitude
                if d<=Steal.StealRadius and d<dist then
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _,prompt in ipairs(att:GetChildren()) do
                            if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then
                                nearest,dist=prompt,d
                            end
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
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
        end
    end
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;isStealing=true;stealStartTime=tick()
    updateStealProgress(0)
    if Conns.progress then Conns.progress:Disconnect() end
    Conns.progress=RunService.Heartbeat:Connect(function()
        if not isStealing then 
            Conns.progress:Disconnect();Conns.progress=nil
            return 
        end
        local prog=math.clamp((tick()-stealStartTime)/Steal.StealDuration,0,1)
        updateStealProgress(prog)
    end)
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        if Conns.progress then Conns.progress:Disconnect();Conns.progress=nil end
        resetProgressBar()
        data.ready=true;isStealing=false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    if Conns.progress then Conns.progress:Disconnect();Conns.progress=nil end
    isStealing=false
    resetProgressBar()
end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

local function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local char = LP.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local isCarrying = h.WalkSpeed < 25
    if isCarrying == _autoSwitchWasSteal then return end
    _autoSwitchWasSteal = isCarrying
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local spd = getAutoSwitchSpeed(isCarrying)
        local md = h.MoveDirection
        if md.Magnitude > 0 then
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(updateAutoSwitchSpeed)
    end
end)

RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    local useAutoSwitch = autoSwitchSpeedEnabled
    local spd
    if useAutoSwitch then
        local isCarrying = hum.WalkSpeed < 25
        spd = getAutoSwitchSpeed(isCarrying)
    else
        spd = getActiveMoveSpeed()
    end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled and not batV2Enabled then
        local md=hum.MoveDirection
        if md.Magnitude>0 then
            lastMoveDir=md
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            if anyHeld then hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) end
        end
    end
    if speedLabel then speedLabel.Text=string.format("Speed: %.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)

-- Auto Left/Right
local alConn,arConn=nil,nil
local alPhase,arPhase=1,1

local function stopAutoLeft()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if _updateMobileAutoLeft then _updateMobileAutoLeft(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if _updateMobileAutoRight then _updateMobileAutoRight(false) end
end

local function startAutoLeft()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                alPhase=2
                local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
                autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
                alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if _updateMobileAutoLeft then _updateMobileAutoLeft(false) end;return
            end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function startAutoRight()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                arPhase=2
                local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
                autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
                arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if _updateMobileAutoRight then _updateMobileAutoRight(false) end;return
            end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    local bb=Instance.new("BillboardGui",head)
    bb.Size=UDim2.new(0,160,0,44);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
    speedLabel=Instance.new("TextLabel",bb)
    speedLabel.Size=UDim2.new(1,0,0.55,0);speedLabel.BackgroundTransparency=1
    speedLabel.Text="Speed: 0";speedLabel.TextColor3=Color3.fromRGB(255,255,255)
    speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextScaled=true
    speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
end

local function startUnwalk()
    local c=LP.Character;if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

local function stopUnwalk()
    local c=LP.Character
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end
end

local _wfConns={}

-- Original stand drop
local function runDrop()
    if dropActive then return end
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end
    if batV2Enabled then
        batV2Enabled=false
        if batV2SetVisual then batV2SetVisual(false) end
    end
    dropActive=true
    local colConn=RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                for _,part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end
    end)
    table.insert(_wfConns,colConn)
    local flingThread=coroutine.create(function()
        while dropActive do
            RunService.Heartbeat:Wait()
            local c=LP.Character
            local root=c and c:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local vel=root.Velocity
            root.Velocity=vel*10000+Vector3.new(0,10000,0)
            RunService.RenderStepped:Wait()
            if root and root.Parent then root.Velocity=vel end
            RunService.Stepped:Wait()
            if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
        end
    end)
    table.insert(_wfConns,flingThread)
    coroutine.resume(flingThread)
    task.delay(0.1,function()
        dropActive=false
        for _,c in ipairs(_wfConns) do
            if typeof(c)=="RBXScriptConnection" then c:Disconnect()
            elseif type(c)=="thread" then pcall(coroutine.close,c) end
        end
        _wfConns={}
    end)
end

-- Jump drop
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150

local function runJumpDrop()
    if dropActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    dropActive = true
    local t0 = tick()
    local dc
    dc = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if dc then dc:Disconnect() end
            dropActive = false
            return
        end

        if tick() - t0 >= DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)

            if rr then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + offset, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.zero
            end

            dropActive = false
            return
        end

        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
    end)
end

-- Master drop function
local function doDrop()
    if dropMode == "jump" then
        runJumpDrop()
    else
        runDrop()
    end
end

-- ====================== MODIFIED TP DOWN – acts like Mirror TP ======================
local function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end

    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    pcall(function()
        hrp.Velocity = Vector3.zero
    end)
end

local function startAutoTP()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function()
        while autoTPEnabled do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
end

local function stopAutoTP()
    autoTPEnabled=false
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
end

local function runTPFloor()
    pcall(function() doAutoTPDown(true) end)
end
-- ==========================================================================

local function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then useMedusaCounter() end
    end)
end

local function setupMedusa(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
end

local function stopMedusaCounter()
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
end

local function findBatForCounter()
    return findBat()
end

local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local char=LP.Character;if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5);batCounterDebounce=false
            end)
        end
    end)
end

stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
    batCounterDebounce=false
end

local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest, minDist
end

resetAutoBatMotion = function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity * 0.3 end
    if hum then hum.AutoRotate = true end
end

local _autoTPWasEnabled = false

-- Auto Bat
local function enableAutoBat()
    if batV2Enabled then
        batV2Enabled=false; if batV2SetVisual then batV2SetVisual(false) end; stopBatV2Aimbot()
        if _updateMobileBatV2 then _updateMobileBatV2(false) end
    end
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    if autoTPEnabled then _autoTPWasEnabled=true;stopAutoTP();if setAutoTPVisual then setAutoTPVisual(false) end else _autoTPWasEnabled=false end
    autoBatEquippedThisRun=false
    autoBatEnabled = true
end

local function disableAutoBat()
    autoBatEnabled=false
    autoBatEquippedThisRun=false
    local char=LP.Character
    if char then
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2.AutoRotate=true end
    end
    if resetAutoBatMotion then resetAutoBatMotion() end
    if _autoTPWasEnabled then
        _autoTPWasEnabled=false;autoTPEnabled=true
        if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP()
    end
end

-- Bat V2
local function trySwingV2()
    if batV2HitCD then return end
    batV2HitCD = true
    pcall(function()
        local char = LP.Character
        if char then
            local bat = findBatV2()
            if bat then
                if bat.Parent ~= char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(bat) end) end
                end
                pcall(function() bat:Activate() end)
            end
        end
    end)
    task.delay(BAT_V2_SWING_COOLDOWN, function() batV2HitCD = false end)
end

local function startBatV2Aimbot()
    if batV2Conn then batV2Conn:Disconnect() end
    if autoBatEnabled then
        autoBatEnabled=false; if autoBatSetVisual then autoBatSetVisual(false) end; disableAutoBat()
        if _updateMobileAimbot then _updateMobileAimbot(false) end
    end
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        batV2PrevAutoRotate = hum.AutoRotate
        hum.AutoRotate = false
    end
    batV2Conn = RunService.RenderStepped:Connect(function()
        if not batV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatV2()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target, targetDist = getClosestTarget()
        if not target then return end
        local myPos = root.Position
        local targetPos = target.Position
        local direction = targetPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end
        local chaseSpeed = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local toTarget = targetPos - myPos
        if toTarget.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, targetPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end
        if targetDist <= BAT_V2_HIT_DIST then trySwingV2() end
    end)
end

local function stopBatV2Aimbot()
    if batV2Conn then
        batV2Conn:Disconnect()
        batV2Conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (batV2PrevAutoRotate == nil) and true or batV2PrevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    batV2HitCD = false
end

-- Auto Bat Heartbeat
RunService.Heartbeat:Connect(function()
    if not autoBatEnabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not char:FindFirstChildOfClass("Tool") then
        local bat = findBat()
        if bat then pcall(function() hum:EquipTool(bat) end) end
    end
    local target = getClosestTarget()
    if not target then
        hum.AutoRotate = true
        root.AssemblyAngularVelocity = Vector3.zero
        return
    end
    _autoBatTarget = target
    local targetVel = target.AssemblyLinearVelocity
    local myPos = root.Position
    local targetPos = target.Position
    local predictPos = targetPos + targetVel * 0.14
    predictPos = predictPos + target.CFrame.LookVector * 0.3
    local direction = predictPos - myPos
    local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
    local chaseSpeed = 58
    local desiredHeight = targetPos.Y + 3.7
    local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
    if hum.FloorMaterial ~= Enum.Material.Air then
        yVel = math.max(yVel, 13)
    end
    yVel = math.clamp(yVel, -70, 110)
    local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
    local predictedPos = targetPos + targetVel * predictTime
    local toPredict = predictedPos - myPos
    hum.AutoRotate = false
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(myPos, predictedPos)
        local diffCF = root.CFrame:Inverse() * goalCF
        local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
        rx = math.clamp(rx, -2.5, 2.5)
        ry = math.clamp(ry, -2.5, 2.5)
        rz = math.clamp(rz, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
    end
    if autoSwingEnabled then
        local bat = char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then
            bat:Activate()
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
    if autoBatEnabled then
        task.wait(0.3)
        autoBatEquippedThisRun = false
    end
    if batV2Enabled then
        task.wait(0.5)
        stopBatV2Aimbot()
        task.wait(0.2)
        startBatV2Aimbot()
    end
end)

if LP.Character then setupSpeedIndicator(LP.Character) end

-- ====================== SEMI AUTO STEAL ======================
local SemiSteal = {
    STEAL_RADIUS = 9,
    STEAL_DURATION = 0.2,
    STEAL_HOLD_MIN = 1.3,
    STEAL_HOLD_MAX = 2.6,
    STEAL_ENTRY_DELAY = 0.3,
    STEAL_COOLDOWN = 0.05,
    STEAL_PRIME_RANGE = 80,
    animalCache = {},
    promptCache = {},
    stealCache = {},
    stealConn = nil,
    isStealing = false,
    StealState = {
        active = false,
        startTime = 0,
        phase = "idle",
        label = "",
        lastResult = "",
        lastResultTime = 0,
    }
}

-- ====================== SIMPLE TEXT FILE SAVING (Delta / mobile) ======================
local function loadStealValue(filename, defaultValue)
    if isfile and isfile(filename) then
        local success, text = pcall(function() return readfile(filename) end)
        if success then
            local num = tonumber(text)
            if num then return num end
        end
    end
    return defaultValue
end

local function saveStealValue(filename, value)
    if writefile then
        pcall(function() writefile(filename, tostring(value)) end)
    end
end

Steal.StealRadius = loadStealValue("GrabRadius.txt", 60)
SemiSteal.STEAL_PRIME_RANGE = loadStealValue("PrimeStealRange.txt", 80)
SemiSteal.STEAL_RADIUS = loadStealValue("StealRange.txt", 9)
currentRadius = Steal.StealRadius

local function saveConfig()
    local function ks(e) return {kb=e.kb and e.kb.Name or nil,gp=e.gp and e.gp.Name or nil} end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,
        dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
        autoBatKey=ks(KB.AutoBat),batV2Key=ks(KB.BatV2),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),
        speedToggleKey=ks(KB.SpeedToggle),
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,
        antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,
        infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled,
        batCounter=batCounterEnabled,
        carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,
        batV2Enabled=batV2Enabled,
        unwalkEnabled=unwalkEnabled,
        autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
        uiLocked=uiLocked,
        autoSwitchSpeed=autoSwitchSpeedEnabled,
        dropMode=dropMode,
        stealMode=stealMode,
        primeStealRange=SemiSteal.STEAL_PRIME_RANGE,
        semiStealRadius=SemiSteal.STEAL_RADIUS
    }
    if writefile then pcall(function() writefile("cursedPC.json",HS:JSONEncode(cfg)) end) end
    saveStealValue("GrabRadius.txt", Steal.StealRadius)
    saveStealValue("PrimeStealRange.txt", SemiSteal.STEAL_PRIME_RANGE)
    saveStealValue("StealRange.txt", SemiSteal.STEAL_RADIUS)
end

task.spawn(function() while task.wait(5) do saveConfig() end end)

local function isMyPlot(plotName)
    local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if not sign then return false end
    local yb = sign:FindFirstChild("YourBase")
    if yb and yb:IsA("BillboardGui") and yb.Enabled == true then return true end
    local frame = sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if label and LP.DisplayName then
        local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
        if owner == LP.DisplayName then return true end
    end
    return false
end

local function scanPlot(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyPlot(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, pod in ipairs(podiums:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            local exists = false
            for _, ex in ipairs(SemiSteal.animalCache) do
                if ex.uid == uid then exists = true; break end
            end
            if not exists then
                table.insert(SemiSteal.animalCache, {
                    name = pod.Name,
                    plot = plot.Name,
                    slot = pod.Name,
                    worldPosition = pod:GetPivot().Position,
                    uid = uid,
                })
            end
        end
    end
end

local function findPromptCached(ad)
    if not ad then return nil end
    local cp = SemiSteal.promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local plot = plots:FindFirstChild(ad.plot)
    if not plot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local pod = pods:FindFirstChild(ad.slot)
    if not pod then return nil end
    local base = pod:FindFirstChild("Base")
    if not base then return nil end
    local sp = base:FindFirstChild("Spawn")
    if not sp then return nil end
    local att = sp:FindFirstChild("PromptAttachment")
    local prompt = nil
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then
        for _, ch in ipairs(sp:GetDescendants()) do
            if ch:IsA("ProximityPrompt") then prompt = ch; break end
        end
    end
    if prompt then SemiSteal.promptCache[ad.uid] = prompt end
    return prompt
end

local function buildCallbacks(prompt)
    if SemiSteal.stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, conn in ipairs(c1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, conn in ipairs(c2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        SemiSteal.stealCache[prompt] = data
    end
end

local function nearestAnimal()
    local char = LP.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(SemiSteal.animalCache) do
        if not isMyPlot(ad.plot) and ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d < bestD then bestD = d; best = ad end
        end
    end
    return best, bestD
end

local function distToAnimal(ad)
    local char = LP.Character
    if not char then return math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp or not ad.worldPosition then return math.huge end
    return (hrp.Position - ad.worldPosition).Magnitude
end

local function execStealSemi(prompt, animalData)
    local data = SemiSteal.stealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false

    local label = animalData.name or "Animal"
    SemiSteal.StealState.active = true
    SemiSteal.StealState.startTime = tick()
    SemiSteal.StealState.phase = "holding"
    SemiSteal.StealState.label = label

    SemiSteal.isStealing = true
    isStealing = true
    updateStealProgress(0)

    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(SemiSteal.STEAL_HOLD_MIN)

        SemiSteal.StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= SemiSteal.STEAL_RADIUS
        local fired = false
        while true do
            local elapsed = tick() - SemiSteal.StealState.startTime
            if elapsed > SemiSteal.STEAL_HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= SemiSteal.STEAL_RADIUS then
                if not alreadyInRange then task.wait(SemiSteal.STEAL_ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end

        SemiSteal.StealState.active = false
        SemiSteal.StealState.phase = "idle"

        if fired then
            SemiSteal.StealState.lastResult = "Stole " .. label
        else
            SemiSteal.StealState.lastResult = "Missed window: " .. label
        end
        SemiSteal.StealState.lastResultTime = tick()

        task.wait(SemiSteal.STEAL_COOLDOWN)
        data.ready = true
        SemiSteal.isStealing = false
        isStealing = false
        resetProgressBar()
    end)
    return true
end

local function startSemiSteal()
    if SemiSteal.stealConn then return end
    SemiSteal.stealConn = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or stealMode ~= "semi" then return end
        if SemiSteal.isStealing then return end
        local target, dist = nearestAnimal()
        if not target then return end
        local rangeUse = SemiSteal.STEAL_PRIME_RANGE
        if dist > rangeUse then return end
        local prompt = SemiSteal.promptCache[target.uid]
        if not prompt or not prompt.Parent then prompt = findPromptCached(target) end
        if prompt then
            buildCallbacks(prompt)
            execStealSemi(prompt, target)
        end
    end)
end

local function stopSemiSteal()
    if SemiSteal.stealConn then
        SemiSteal.stealConn:Disconnect()
        SemiSteal.stealConn = nil
    end
    SemiSteal.isStealing = false
    isStealing = false
    SemiSteal.StealState.active = false
    SemiSteal.StealState.phase = "idle"
    resetProgressBar()
end

task.spawn(function()
    task.wait(2)
    local plots = workspace:WaitForChild("Plots", 10)
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then scanPlot(plot) end
    end
    plots.ChildAdded:Connect(function(plot)
        if plot:IsA("Model") then
            task.wait(0.5)
            scanPlot(plot)
        end
    end)
    task.spawn(function()
        while task.wait(5) do
            SemiSteal.animalCache = {}
            SemiSteal.promptCache = {}
            for _, plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") then scanPlot(plot) end
            end
        end
    end)
end)

task.spawn(function()
    while true do
        if SemiSteal.StealState.active and SemiSteal.StealState.startTime > 0 then
            local elapsed = tick() - SemiSteal.StealState.startTime
            local maxHold = SemiSteal.STEAL_HOLD_MAX
            local progress = math.clamp(elapsed / maxHold, 0, 1)
            updateStealProgress(progress)
        else
            if not isStealing then
                resetProgressBar()
            end
        end
        task.wait(0.05)
    end
end)

-- ====================== GUI BUILDING ======================
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual
local setUnwalkVisual,setAutoSwingVisual
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,autoTPHeightBox
local setLockUIVisual

grabRadiusBox = nil
primeStealRangeBox = nil
semiStealRadiusBox = nil
grabRadiusRow = nil
primeStealRangeRow = nil
semiStealRadiusRow = nil
updateStealModeButtons = nil

local function refreshSpeedModeLabel()
    if modeValLbl then 
        if autoSwitchSpeedEnabled then
            modeValLbl.Text = "Auto Switch"
        else
            modeValLbl.Text = laggerToggled and (laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (speedMode and "Carry" or "Normal")
        end
    end
end

local function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerPhase = 0
        speedMode = true
    else
        speedMode = not speedMode
    end
    refreshSpeedModeLabel()
end

local function toggleLaggerMode()
    if laggerToggled then
        laggerToggled=false
        laggerPhase=0
        speedMode=false
    else
        speedMode=false
        laggerToggled=true
        laggerPhase=2
    end
    refreshSpeedModeLabel()
end

local mobileGui = nil
local mobileButtons = {}

local _isfile = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile) or function() return false end
local _readfile = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile) or function() return nil end
local _writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or function() end

local CONFIG_FILE = "NightmareDuelsButtonPositions.json"
local BTN_W = 58
local BTN_H = 58
local BTN_GAP = 8
local COLS = 2

local C_MOBILE = {
    stackBg = Color3.fromRGB(20, 0, 0),
    stackBrd = Color3.fromRGB(80, 20, 20),
    stackTxt = Color3.fromRGB(255, 100, 100),
    stackActBg = Color3.fromRGB(200, 30, 30),
    stackActBrd = Color3.fromRGB(255, 50, 50),
    stackActTxt = Color3.fromRGB(255, 255, 255),
}

local function mkCorner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 12)
    return c
end

local function mkStroke(p, col, th)
    local s = Instance.new("UIStroke", p)
    s.Color = col
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local stackDefs = {
    { key = "autoLeft", label = "AUTO\nLEFT", onToggle = function(state) autoLeftEnabled = state; if state then startAutoLeft() else stopAutoLeft() end; if autoLeftSetVisual then autoLeftSetVisual(state) end; saveConfig() end, getState = function() return autoLeftEnabled end },
    { key = "autoRight", label = "AUTO\nRIGHT", onToggle = function(state) autoRightEnabled = state; if state then startAutoRight() else stopAutoRight() end; if autoRightSetVisual then autoRightSetVisual(state) end; saveConfig() end, getState = function() return autoRightEnabled end },
    { key = "aimbot", label = "AIMBOT", onToggle = function(state)
        if state and batV2Enabled then
            batV2Enabled = false
            if batV2SetVisual then batV2SetVisual(false) end
            stopBatV2Aimbot()
            if _updateMobileBatV2 then _updateMobileBatV2(false) end
        end
        autoBatEnabled = state
        if state then enableAutoBat() else disableAutoBat() end
        if autoBatSetVisual then autoBatSetVisual(state) end
        saveConfig()
    end, getState = function() return autoBatEnabled end },
    { key = "batV2", label = "BAT\nV2", onToggle = function(state)
        if state and autoBatEnabled then
            autoBatEnabled = false
            if autoBatSetVisual then autoBatSetVisual(false) end
            disableAutoBat()
            if _updateMobileAimbot then _updateMobileAimbot(false) end
        end
        batV2Enabled = state
        if state then startBatV2Aimbot() else stopBatV2Aimbot() end
        if batV2SetVisual then batV2SetVisual(state) end
        saveConfig()
    end, getState = function() return batV2Enabled end },
    { key = "lagger", label = "LAGGER\nSPEED", onToggle = function(state) if state then speedMode=false; laggerToggled=true; laggerPhase=1 else laggerToggled=false; laggerPhase=0; speedMode=false end; refreshSpeedModeLabel(); saveConfig() end, getState = function() return laggerToggled and laggerPhase==1 end },
    { key = "laggerCarry", label = "LAGGER\nCARRY", onToggle = function(state) if state then speedMode=false; laggerToggled=true; laggerPhase=2 else laggerToggled=false; laggerPhase=0; speedMode=false end; refreshSpeedModeLabel(); saveConfig() end, getState = function() return laggerToggled and laggerPhase==2 end },
    { key = "drop", label = "DROP", onToggle = function(state) doDrop(); task.delay(0.1, function() if mobileButtons.drop and mobileButtons.drop.setOn then mobileButtons.drop.setOn(false) end end) end, getState = function() return false end, isAction = true },
    { key = "tpDown", label = "TP\nDOWN", onToggle = function(state) runTPFloor(); task.delay(0.1, function() if mobileButtons.tpDown and mobileButtons.tpDown.setOn then mobileButtons.tpDown.setOn(false) end end) end, getState = function() return false end, isAction = true },
    { key = "instaReset", label = "INSTA\nRESET", onToggle = function(state) cursedInstaReset(); task.delay(0.1, function() if mobileButtons.instaReset and mobileButtons.instaReset.setOn then mobileButtons.instaReset.setOn(false) end end) end, getState = function() return false end, isAction = true },
    { key = "carrySpeed", label = "CARRY\nSPEED", onToggle = function(state) if state then if laggerToggled then laggerToggled=false; laggerPhase=0 end; speedMode=true else speedMode=false end; refreshSpeedModeLabel(); saveConfig() end, getState = function() return speedMode end },
}

local function getDefaultStackPos(i)
    local col = (i - 1) % COLS
    local row = math.floor((i - 1) / COLS)
    return UDim2.new(
        1, -(COLS * (BTN_W + BTN_GAP) - BTN_GAP + 14) + col * (BTN_W + BTN_GAP),
        0.5, -(math.ceil(#stackDefs / COLS) * (BTN_H + BTN_GAP) - BTN_GAP) / 2 + row * (BTN_H + BTN_GAP)
    )
end

local function saveButtonPositions(buttonPositions)
    local data = { version = 1, buttonPositions = buttonPositions }
    local encoded = HS:JSONEncode(data)
    pcall(function() _writefile(CONFIG_FILE, encoded) end)
end

local function loadButtonPositions()
    if not _isfile(CONFIG_FILE) then return nil end
    local raw = _readfile(CONFIG_FILE)
    if not raw or raw == "" then return nil end
    local success, data = pcall(function() return HS:JSONDecode(raw) end)
    if success and data and data.buttonPositions then return data.buttonPositions end
    return nil
end

local function resetButtonPositions()
    if not mobileGui then return end
    for i, def in ipairs(stackDefs) do
        local btnFrame = mobileGui:FindFirstChild("StackBtn_" .. def.key)
        if btnFrame then
            btnFrame.Position = getDefaultStackPos(i)
        end
    end
    local positions = {}
    for i, def in ipairs(stackDefs) do
        local btnFrame = mobileGui:FindFirstChild("StackBtn_" .. def.key)
        if btnFrame and btnFrame.Position then
            positions[def.key] = { X = btnFrame.Position.X.Offset, Y = btnFrame.Position.Y.Offset }
        end
    end
    saveButtonPositions(positions)
end

local function createMobileButtons()
    if mobileGui then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "NightmareDuels_Buttons"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LP:WaitForChild("PlayerGui")
    mobileGui = gui
    local savedPositions = loadButtonPositions()
    local stackWrappers = {}
    for i, def in ipairs(stackDefs) do
        local btnFrame = Instance.new("TextButton", gui)
        btnFrame.Name = "StackBtn_" .. def.key
        btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        local defaultPos = getDefaultStackPos(i)
        if savedPositions and savedPositions[def.key] then
            local pos = savedPositions[def.key]
            btnFrame.Position = UDim2.new(defaultPos.X.Scale, pos.X or defaultPos.X.Offset, defaultPos.Y.Scale, pos.Y or defaultPos.Y.Offset)
        else
            btnFrame.Position = defaultPos
        end
        btnFrame.BackgroundColor3 = C_MOBILE.stackBg
        btnFrame.BorderSizePixel = 0
        btnFrame.AutoButtonColor = false
        btnFrame.Text = def.label
        btnFrame.TextColor3 = C_MOBILE.stackTxt
        btnFrame.TextScaled = false
        btnFrame.TextSize = 11
        btnFrame.Font = Enum.Font.GothamBold
        btnFrame.TextWrapped = true
        btnFrame.LineHeight = 1.2
        btnFrame.ZIndex = 15
        mkCorner(btnFrame, 12)
        local bStroke = mkStroke(btnFrame, C_MOBILE.stackBrd, 1)
        stackWrappers[def.key] = btnFrame
        local btnState = def.getState and def.getState() or false
        local function setOn(on)
            btnState = on
            TS:Create(btnFrame, TweenInfo.new(0.15), {
                BackgroundColor3 = on and C_MOBILE.stackActBg or C_MOBILE.stackBg,
                TextColor3 = on and C_MOBILE.stackActTxt or C_MOBILE.stackTxt
            }):Play()
            TS:Create(bStroke, TweenInfo.new(0.15), {
                Color = on and C_MOBILE.stackActBrd or C_MOBILE.stackBrd
            }):Play()
        end
        setOn(btnState)
        mobileButtons[def.key] = { setOn = setOn, getState = function() return btnState end }
        if def.key == "autoLeft" then _updateMobileAutoLeft = setOn
        elseif def.key == "autoRight" then _updateMobileAutoRight = setOn
        elseif def.key == "aimbot" then _updateMobileAimbot = setOn
        elseif def.key == "batV2" then _updateMobileBatV2 = setOn
        elseif def.key == "lagger" then _updateMobileLagger = setOn
        elseif def.key == "laggerCarry" then _updateMobileLaggerCarry = setOn
        elseif def.key == "carrySpeed" then _updateMobileCarrySpeed = setOn end
        local dragStartPos, startPos, isDragging, movedEnough = nil, nil, false, false
        local saveDebounce = nil
        btnFrame.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragStartPos = input.Position
            startPos = btnFrame.Position
            isDragging = true
            movedEnough = false
        end)
        btnFrame.InputChanged:Connect(function(input)
            if uiLocked then return end
            if not isDragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > 8 then movedEnough = true end
                if movedEnough then
                    btnFrame.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end
        end)
        btnFrame.InputEnded:Connect(function(input)
            if uiLocked then return end
            if isDragging and movedEnough then
                if saveDebounce then task.cancel(saveDebounce) end
                saveDebounce = task.delay(0.2, function()
                    local positions = {}
                    for key, wrapper in pairs(stackWrappers) do
                        if wrapper and wrapper.Position then
                            positions[key] = { X = wrapper.Position.X.Offset, Y = wrapper.Position.Y.Offset }
                        end
                    end
                    saveButtonPositions(positions)
                    saveDebounce = nil
                end)
            end
            isDragging = false
            movedEnough = false
        end)
        btnFrame.MouseButton1Click:Connect(function()
            if def.isAction then
                def.onToggle(true)
                task.delay(0.15, function()
                    if def.key == "drop" or def.key == "tpDown" or def.key == "instaReset" then
                        setOn(false)
                    end
                end)
            else
                local newState = not btnState
                setOn(newState)
                if def.onToggle then def.onToggle(newState) end
            end
        end)
    end
end

-- ====================== REORGANIZED GUI WITH CUSTOM BACKGROUND ======================
local function buildGui()
    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui")
    for _,name in pairs({"CursedHub","bloom.vs","CEED X LKN","Veltrex","Japan.vs","NightmareDuels"}) do
        local old = pg:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local C = {
        bg = Color3.fromRGB(10,0,0),
        row = Color3.fromRGB(30,5,5),
        input = Color3.fromRGB(20,0,0),
        text = Color3.fromRGB(255,200,200),
        textMuted = Color3.fromRGB(200,150,150),
        white = Color3.fromRGB(255,255,255),
        pink = Color3.fromRGB(255,50,50),
        pinkDim = Color3.fromRGB(200,30,30),
        sectionBg = Color3.fromRGB(0,0,0),
        titleText = Color3.fromRGB(255,80,80),
        accent = Color3.fromRGB(200,20,20),
        accentDark = Color3.fromRGB(80,10,10),
    }
    local GuiHub = Instance.new("ScreenGui")
    GuiHub.Name = "NightmareDuels"
    GuiHub.ResetOnSpawn = false
    GuiHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GuiHub.Parent = pg
    local Outer = Instance.new("ImageLabel")
    Outer.Name = "Outer"
    Outer.Size = UDim2.new(0, 280, 0, 470)
    Outer.Position = UDim2.new(0, 20, 0, -60)
    Outer.BackgroundTransparency = 1
    Outer.BorderSizePixel = 0
    Outer.ClipsDescendants = true
    Outer.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=136450335437647&width=420&height=420&format=png"
    Outer.ScaleType = Enum.ScaleType.Crop
    Outer.Parent = GuiHub
    Instance.new("UICorner", Outer).CornerRadius = UDim.new(0, 22)
    local outerStroke = Instance.new("UIStroke", Outer)
    outerStroke.Color = Color3.fromRGB(200,30,30)
    outerStroke.Thickness = 2
    local function makeDraggable(guiObject)
        local dragging = false
        local dragStartPos, startGuiPos, dragInput
        guiObject.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStartPos = input.Position
                startGuiPos = guiObject.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.InputUserState.End then dragging = false end
                end)
            end
        end)
        guiObject.InputChanged:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if uiLocked then return end
            if input == dragInput and dragging then
                local delta = input.Position - dragStartPos
                guiObject.Position = UDim2.new(
                    startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X,
                    startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y
                )
            end
        end)
    end
    makeDraggable(Outer)
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, 0)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ZIndex = 2
    contentContainer.Parent = Outer
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 38)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = contentContainer
    HeaderFrame.ZIndex = 2
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Position = UDim2.new(0, 12, 0, 5)
    TitleLbl.Size = UDim2.new(1, -80, 0, 15)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "Nightmare Duels"
    TitleLbl.TextColor3 = Color3.fromRGB(255,50,50)
    TitleLbl.TextSize = 13
    TitleLbl.Font = Enum.Font.GothamBlack
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = HeaderFrame
    TitleLbl.ZIndex = 3
    local HeaderSep = Instance.new("Frame")
    HeaderSep.Position = UDim2.new(0, 12, 0, 36)
    HeaderSep.Size = UDim2.new(1, -24, 0, 1)
    HeaderSep.BackgroundColor3 = C.pink
    HeaderSep.BackgroundTransparency = 0.7
    HeaderSep.BorderSizePixel = 0
    HeaderSep.Parent = contentContainer
    HeaderSep.ZIndex = 2
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(20,0,0)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = C.pinkDim
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = HeaderFrame
    closeBtn.ZIndex = 3
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    local miniBtn = Instance.new("Frame")
    miniBtn.Size = UDim2.new(0, 36, 0, 36)
    miniBtn.Position = UDim2.new(0, 20, 0, 20)
    miniBtn.BackgroundColor3 = Color3.fromRGB(20,0,0)
    miniBtn.BorderSizePixel = 0
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    miniBtn.Active = true
    miniBtn.Parent = GuiHub
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = Color3.fromRGB(200,30,30)
    miniStroke.Thickness = 2
    local miniIcon = Instance.new("ImageLabel")
    miniIcon.Size = UDim2.new(1, 0, 1, 0)
    miniIcon.Position = UDim2.new(0, 0, 0, 0)
    miniIcon.BackgroundTransparency = 1
    miniIcon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=136450335437647&width=420&height=420&format=png"
    miniIcon.ScaleType = Enum.ScaleType.Crop
    miniIcon.ZIndex = 21
    miniIcon.Parent = miniBtn
    Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1, 0)
    local miniClk = Instance.new("TextButton")
    miniClk.Size = UDim2.new(1, 0, 1, 0)
    miniClk.BackgroundTransparency = 1
    miniClk.Text = ""
    miniClk.ZIndex = 22
    miniClk.Parent = miniBtn
    makeDraggable(miniBtn)
    local function showGui() Outer.Visible = true; miniBtn.Visible = false end
    local function hideGui() Outer.Visible = false; miniBtn.Visible = true end
    closeBtn.MouseButton1Click:Connect(hideGui)
    miniClk.MouseButton1Click:Connect(showGui)
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Position = UDim2.new(0, 8, 0, 46)
    ContentFrame.Size = UDim2.new(1, -16, 1, -56)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = contentContainer
    
    local mainScroll = Instance.new("ScrollingFrame")
    mainScroll.Size = UDim2.new(1, 0, 1, 0)
    mainScroll.BackgroundTransparency = 1
    mainScroll.BorderSizePixel = 0
    mainScroll.ScrollBarThickness = 0
    mainScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    mainScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    mainScroll.Parent = ContentFrame
    
    local mainLayout = Instance.new("UIListLayout")
    mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mainLayout.Padding = UDim.new(0, 10)
    mainLayout.Parent = mainScroll
    
    local mainPad = Instance.new("UIPadding")
    mainPad.PaddingLeft = UDim.new(0, 4)
    mainPad.PaddingRight = UDim.new(0, 4)
    mainPad.PaddingTop = UDim.new(0, 4)
    mainPad.PaddingBottom = UDim.new(0, 4)
    mainPad.Parent = mainScroll
    
    local function createSection(parent, title, order)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 0)
        section.AutomaticSize = Enum.AutomaticSize.Y
        section.BackgroundTransparency = 1
        section.BorderSizePixel = 0
        section.LayoutOrder = order
        section.Parent = parent
        
        local innerLayout = Instance.new("UIListLayout")
        innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        innerLayout.Padding = UDim.new(0, 2)
        innerLayout.Parent = section
        
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 6)
        pad.Parent = section
        
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 22)
        header.BackgroundTransparency = 1
        header.Text = title
        header.TextColor3 = Color3.fromRGB(255,80,80)
        header.Font = Enum.Font.GothamBold
        header.TextSize = 13
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.LayoutOrder = 0
        header.Parent = section
        
        return section
    end
    
    local function makeRow(parent, height)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, height or 28)
        row.BackgroundColor3 = Color3.fromRGB(30,5,5)
        row.BackgroundTransparency = 0.7
        row.BorderSizePixel = 0
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = Color3.fromRGB(80,20,20)
        rowStroke.Thickness = 1
        return row
    end
    
    local function makeLabel(row, text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.58, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255,200,200)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 9
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        return lbl
    end
    
    local function makeToggle(parent, text, callback, initial)
        local row = makeRow(parent, 28)
        makeLabel(row, text)
        local pill = Instance.new("Frame")
        pill.Size = UDim2.new(0, 30, 0, 16)
        pill.Position = UDim2.new(1, -36, 0.5, -8)
        pill.BackgroundColor3 = Color3.fromRGB(40,5,5)
        pill.BorderSizePixel = 0
        pill.ZIndex = 3
        pill.Parent = row
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 10, 0, 10)
        dot.Position = UDim2.new(0, 3, 0.5, -5)
        dot.BackgroundColor3 = Color3.fromRGB(120,20,20)
        dot.BorderSizePixel = 0
        dot.ZIndex = 4
        dot.Parent = pill
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local on = initial or false
        local function setState(state)
            on = state
            TS:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
                BackgroundColor3 = on and Color3.fromRGB(200,30,30) or Color3.fromRGB(40,5,5)
            }):Play()
            TS:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                Position = on and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
                BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(120,20,20)
            }):Play()
        end
        setState(on)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 5
        btn.Parent = pill
        btn.MouseButton1Click:Connect(function()
            setState(not on)
            if callback then callback(on) end
        end)
        return setState
    end
    
    local function makeBox(parent, label, default, w, callback)
        local row = makeRow(parent, 28)
        makeLabel(row, label)
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(0, w or 45, 0, 18)
        tb.Position = UDim2.new(1, -(w and w + 6 or 51), 0.5, -9)
        tb.BackgroundColor3 = Color3.fromRGB(20,0,0)
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = Color3.fromRGB(255,200,200)
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 9
        tb.ClearTextOnFocus = false
        tb.ZIndex = 5
        tb.Parent = row
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
        local tbStroke = Instance.new("UIStroke", tb)
        tbStroke.Color = Color3.fromRGB(60,10,10)
        tbStroke.Thickness = 1
        tb.FocusLost:Connect(function()
            local n = tonumber(tb.Text)
            if n then
                if callback then callback(n) end
            else
                tb.Text = tostring(default)
            end
        end)
        return tb, row
    end
    
    local function makeKeybindRow(parent, label, kbEntry, callback)
        local row = makeRow(parent, 28)
        makeLabel(row, label)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 40, 0, 18)
        btn.Position = UDim2.new(1, -44, 0.5, -9)
        btn.BackgroundColor3 = Color3.fromRGB(20,0,0)
        btn.BorderSizePixel = 0
        btn.Text = (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        btn.TextColor3 = Color3.fromRGB(255,200,200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 8
        btn.ZIndex = 5
        btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local listening = false
        local listenConn = nil
        local oldText = btn.Text
        btn.MouseButton1Click:Connect(function()
            if listening then
                listening = false
                if listenConn then listenConn:Disconnect() end
                btn.Text = oldText
                return
            end
            oldText = btn.Text
            listening = true
            _anyKeyListening = true
            btn.Text = "..."
            listenConn = UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    listening = false; _anyKeyListening = false
                    if listenConn then listenConn:Disconnect() end
                    btn.Text = oldText
                    return
                end
                local isGp = inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
                btn.Text = inp.KeyCode.Name
                oldText = inp.KeyCode.Name
                listening = false; _anyKeyListening = false
                if listenConn then listenConn:Disconnect() end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
                else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                if callback then callback(inp.KeyCode, isGp) end
            end)
        end)
        return btn
    end
    
    local function makeModeRow(parent)
        local row = makeRow(parent, 28)
        makeLabel(row, "Speed Mode")
        modeValLbl = Instance.new("TextLabel")
        modeValLbl.Size = UDim2.new(0, 80, 1, 0)
        modeValLbl.Position = UDim2.new(1, -84, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = Color3.fromRGB(255,50,50)
        modeValLbl.Font = Enum.Font.GothamBlack
        modeValLbl.TextSize = 9
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.Parent = row
        local clk = Instance.new("TextButton")
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 2
        clk.Parent = row
        clk.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            toggleCarryMode()
            saveConfig()
        end)
        refreshSpeedModeLabel()
    end
    
    local orderCounter = 1
    
    local speedSection = createSection(mainScroll, "Speed", orderCounter); orderCounter = orderCounter + 1
    makeModeRow(speedSection)
    normalBox = makeBox(speedSection, "Normal Speed", NS, 45, function(v) if v>0 and v<=500 then NS=v end saveConfig() end)
    carryBox = makeBox(speedSection, "Carry Speed", CS, 45, function(v) if v>0 and v<=500 then CS=v end saveConfig() end)
    laggerBox = makeBox(speedSection, "Lagger Speed", LAGGER_SPEED, 45, function(v) if v>0 and v<=500 then LAGGER_SPEED=v end saveConfig() end)
    laggerCarryBox = makeBox(speedSection, "Lagger Carry", LAGGER_CARRY_SPEED, 45, function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end saveConfig() end)
    setAutoSwitchVisual = makeToggle(speedSection, "Auto Switch Speed", function(on)
        autoSwitchSpeedEnabled = on
        if on then
            local char = LP.Character
            if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then _autoSwitchWasSteal = hum.WalkSpeed<25 end end
        end
        refreshSpeedModeLabel()
        saveConfig()
    end, autoSwitchSpeedEnabled)
    
    local mechSection = createSection(mainScroll, "Mechanics", orderCounter); orderCounter = orderCounter + 1
    setInfJumpVisual = makeToggle(mechSection, "Infinite Jump", function(on) infJumpEnabled=on; if on then startInfiniteJump() else stopInfiniteJump() end saveConfig() end, infJumpEnabled)
    setAntiRagVisual = makeToggle(mechSection, "Anti Ragdoll", function(on) 
        antiRagdollEnabled = on
        if on then 
            startAntiRagdoll() 
        else 
            stopAntiRagdoll() 
        end 
        saveConfig()
    end, antiRagdollEnabled)
    setUnwalkVisual = makeToggle(mechSection, "Unwalk", function(on) unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
    setMedusaVisual = makeToggle(mechSection, "Medusa Counter", function(on) medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end saveConfig() end)
    setBatCounterVisual = makeToggle(mechSection, "Bat Counter", function(on) batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end saveConfig() end)

    setInstaGrab = makeToggle(mechSection, "Auto Steal", function(on)
        Steal.AutoStealEnabled = on
        if on then
            if stealMode == "normal" then
                stopSemiSteal()
                pcall(startAutoSteal)
            else
                stopAutoSteal()
                startSemiSteal()
            end
        else
            stopAutoSteal()
            stopSemiSteal()
        end
        saveConfig()
    end, Steal.AutoStealEnabled)

    local stealModeRow = makeRow(mechSection, 28)
    makeLabel(stealModeRow, "Steal Mode")
    local normalStealBtn = Instance.new("TextButton")
    normalStealBtn.Size = UDim2.new(0, 40, 0, 18)
    normalStealBtn.Position = UDim2.new(1, -90, 0.5, -9)
    normalStealBtn.BackgroundColor3 = stealMode == "normal" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
    normalStealBtn.TextColor3 = stealMode == "normal" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
    normalStealBtn.Text = "Norm"
    normalStealBtn.Font = Enum.Font.GothamBold
    normalStealBtn.TextSize = 9
    normalStealBtn.ZIndex = 5
    normalStealBtn.Parent = stealModeRow
    Instance.new("UICorner", normalStealBtn).CornerRadius = UDim.new(0, 5)

    local semiStealBtn = Instance.new("TextButton")
    semiStealBtn.Size = UDim2.new(0, 40, 0, 18)
    semiStealBtn.Position = UDim2.new(1, -46, 0.5, -9)
    semiStealBtn.BackgroundColor3 = stealMode == "semi" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
    semiStealBtn.TextColor3 = stealMode == "semi" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
    semiStealBtn.Text = "Semi"
    semiStealBtn.Font = Enum.Font.GothamBold
    semiStealBtn.TextSize = 9
    semiStealBtn.ZIndex = 5
    semiStealBtn.Parent = stealModeRow
    Instance.new("UICorner", semiStealBtn).CornerRadius = UDim.new(0, 5)

    grabRadiusBox, grabRadiusRow = makeBox(mechSection, "Grab Radius", Steal.StealRadius, 45, function(v)
        if v>0 and v<=500 then
            Steal.StealRadius = v
            currentRadius = v
            updateRadiusDisplay(v)
            saveConfig()
        end
    end)
    primeStealRangeBox, primeStealRangeRow = makeBox(mechSection, "Prime Steal Range", SemiSteal.STEAL_PRIME_RANGE, 45, function(v)
        if v>0 and v<=500 then
            SemiSteal.STEAL_PRIME_RANGE = v
            saveConfig()
        end
    end)
    semiStealRadiusBox, semiStealRadiusRow = makeBox(mechSection, "Steal Range", SemiSteal.STEAL_RADIUS, 45, function(v)
        if v>0 and v<=500 then
            SemiSteal.STEAL_RADIUS = v
            saveConfig()
        end
    end)

    updateStealModeButtons = function()
        normalStealBtn.BackgroundColor3 = stealMode == "normal" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
        normalStealBtn.TextColor3 = stealMode == "normal" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
        semiStealBtn.BackgroundColor3 = stealMode == "semi" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
        semiStealBtn.TextColor3 = stealMode == "semi" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
        if grabRadiusRow then grabRadiusRow.Visible = (stealMode == "normal") end
        if primeStealRangeRow then primeStealRangeRow.Visible = (stealMode == "semi") end
        if semiStealRadiusRow then semiStealRadiusRow.Visible = (stealMode == "semi") end
    end

    normalStealBtn.MouseButton1Click:Connect(function()
        stealMode = "normal"
        updateStealModeButtons()
        if Steal.AutoStealEnabled then
            stopSemiSteal()
            pcall(startAutoSteal)
        end
        saveConfig()
    end)

    semiStealBtn.MouseButton1Click:Connect(function()
        stealMode = "semi"
        updateStealModeButtons()
        if Steal.AutoStealEnabled then
            stopAutoSteal()
            startSemiSteal()
        end
        saveConfig()
    end)

    local dropBtnRow = makeRow(mechSection, 28)
    makeLabel(dropBtnRow, "Drop")
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0, 60, 0, 18)
    dropBtn.Position = UDim2.new(1, -66, 0.5, -9)
    dropBtn.BackgroundColor3 = Color3.fromRGB(20,0,0)
    dropBtn.Text = "DROP"
    dropBtn.TextColor3 = Color3.fromRGB(255,200,200)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.TextSize = 9
    dropBtn.ZIndex = 5
    dropBtn.Parent = dropBtnRow
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)
    dropBtn.MouseButton1Click:Connect(doDrop)

    local dropRow = makeRow(mechSection, 28)
    makeLabel(dropRow, "Drop Mode")
    local standBtn = Instance.new("TextButton")
    standBtn.Size = UDim2.new(0, 40, 0, 18)
    standBtn.Position = UDim2.new(1, -90, 0.5, -9)
    standBtn.BackgroundColor3 = dropMode == "stand" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
    standBtn.TextColor3 = dropMode == "stand" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
    standBtn.Text = "Stand"
    standBtn.Font = Enum.Font.GothamBold
    standBtn.TextSize = 9
    standBtn.ZIndex = 5
    standBtn.Parent = dropRow
    Instance.new("UICorner", standBtn).CornerRadius = UDim.new(0, 5)

    local jumpBtn = Instance.new("TextButton")
    jumpBtn.Size = UDim2.new(0, 40, 0, 18)
    jumpBtn.Position = UDim2.new(1, -46, 0.5, -9)
    jumpBtn.BackgroundColor3 = dropMode == "jump" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
    jumpBtn.TextColor3 = dropMode == "jump" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
    jumpBtn.Text = "Jump"
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 9
    jumpBtn.ZIndex = 5
    jumpBtn.Parent = dropRow
    Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0, 5)

    local function updateDropModeButtons()
        standBtn.BackgroundColor3 = dropMode == "stand" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
        standBtn.TextColor3 = dropMode == "stand" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
        jumpBtn.BackgroundColor3 = dropMode == "jump" and Color3.fromRGB(200,30,30) or Color3.fromRGB(20,0,0)
        jumpBtn.TextColor3 = dropMode == "jump" and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,200,200)
    end

    standBtn.MouseButton1Click:Connect(function()
        dropMode = "stand"
        updateDropModeButtons()
        saveConfig()
    end)
    jumpBtn.MouseButton1Click:Connect(function()
        dropMode = "jump"
        updateDropModeButtons()
        saveConfig()
    end)

    updateStealModeButtons()
    
    local moveSection = createSection(mainScroll, "Movement", orderCounter); orderCounter = orderCounter + 1
    autoLeftSetVisual = makeToggle(moveSection, "Auto Left", function(on) autoLeftEnabled=on; if on then startAutoLeft() else stopAutoLeft() end; if autoLeftSetVisual then autoLeftSetVisual(on) end; if _updateMobileAutoLeft then _updateMobileAutoLeft(on) end; saveConfig() end, autoLeftEnabled)
    autoRightSetVisual = makeToggle(moveSection, "Auto Right", function(on) autoRightEnabled=on; if on then startAutoRight() else stopAutoRight() end; if autoRightSetVisual then autoRightSetVisual(on) end; if _updateMobileAutoRight then _updateMobileAutoRight(on) end; saveConfig() end, autoRightEnabled)
    setAutoTPVisual = makeToggle(moveSection, "Auto TP", function(on) autoTPEnabled=on; if on then startAutoTP() else stopAutoTP() end saveConfig() end, autoTPEnabled)
    autoTPHeightBox = makeBox(moveSection, "TP Height", autoTPHeight, 45, function(v) if v>=0 and v<=500 then autoTPHeight=v else autoTPHeightBox.Text=tostring(autoTPHeight) end saveConfig() end)
    autoBatSetVisual = makeToggle(moveSection, "Auto Bat", function(on)
        if on and batV2Enabled then
            batV2Enabled = false
            if batV2SetVisual then batV2SetVisual(false) end
            stopBatV2Aimbot()
            if _updateMobileBatV2 then _updateMobileBatV2(false) end
        end
        autoBatEnabled = on
        if on then enableAutoBat() else disableAutoBat() end
        if autoBatSetVisual then autoBatSetVisual(on) end
        if _updateMobileAimbot then _updateMobileAimbot(on) end
        saveConfig()
    end, autoBatEnabled)
    setAutoSwingVisual = makeToggle(moveSection, "Auto Swing", function(on) autoSwingEnabled=on saveConfig() end, autoSwingEnabled)
    batV2SetVisual = makeToggle(moveSection, "Bat V2", function(on)
        if on and autoBatEnabled then
            autoBatEnabled = false
            if autoBatSetVisual then autoBatSetVisual(false) end
            disableAutoBat()
            if _updateMobileAimbot then _updateMobileAimbot(false) end
        end
        batV2Enabled = on
        if on then startBatV2Aimbot() else stopBatV2Aimbot() end
        if batV2SetVisual then batV2SetVisual(on) end
        if _updateMobileBatV2 then _updateMobileBatV2(on) end
        saveConfig()
    end, batV2Enabled)

    local keySection = createSection(mainScroll, "Keybinds", orderCounter); orderCounter = orderCounter + 1
    setLockUIVisual = makeToggle(keySection, "Lock UI", function(on) uiLocked=on saveConfig() end, uiLocked)
    local resetRow = makeRow(keySection, 28)
    local resetLabel = Instance.new("TextLabel")
    resetLabel.Size = UDim2.new(0.58, 0, 1, 0)
    resetLabel.Position = UDim2.new(0, 8, 0, 0)
    resetLabel.BackgroundTransparency = 1
    resetLabel.Text = "Reset UI Positions"
    resetLabel.TextColor3 = Color3.fromRGB(255,200,200)
    resetLabel.Font = Enum.Font.GothamBold
    resetLabel.TextSize = 9
    resetLabel.TextXAlignment = Enum.TextXAlignment.Left
    resetLabel.Parent = resetRow
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0, 60, 0, 18)
    resetBtn.Position = UDim2.new(1, -64, 0.5, -9)
    resetBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = "RESET"
    resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 9
    resetBtn.ZIndex = 5
    resetBtn.Parent = resetRow
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 5)
    resetBtn.MouseButton1Click:Connect(function() resetButtonPositions() end)
    makeKeybindRow(keySection, "Speed Toggle", KB.SpeedToggle, function(k,isGp) if isGp then KB.SpeedToggle.gp=k; KB.SpeedToggle.kb=nil else KB.SpeedToggle.kb=k; KB.SpeedToggle.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Lagger Toggle", KB.LaggerToggle, function(k,isGp) if isGp then KB.LaggerToggle.gp=k; KB.LaggerToggle.kb=nil else KB.LaggerToggle.kb=k; KB.LaggerToggle.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Auto Left", KB.AutoLeft, function(k,isGp) if isGp then KB.AutoLeft.gp=k; KB.AutoLeft.kb=nil else KB.AutoLeft.kb=k; KB.AutoLeft.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Auto Right", KB.AutoRight, function(k,isGp) if isGp then KB.AutoRight.gp=k; KB.AutoRight.kb=nil else KB.AutoRight.kb=k; KB.AutoRight.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Auto Bat", KB.AutoBat, function(k,isGp) if isGp then KB.AutoBat.gp=k; KB.AutoBat.kb=nil else KB.AutoBat.kb=k; KB.AutoBat.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Bat V2", KB.BatV2, function(k,isGp) if isGp then KB.BatV2.gp=k; KB.BatV2.kb=nil else KB.BatV2.kb=k; KB.BatV2.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Drop Brainrot", KB.DropBrainrot, function(k,isGp) if isGp then KB.DropBrainrot.gp=k; KB.DropBrainrot.kb=nil else KB.DropBrainrot.kb=k; KB.DropBrainrot.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "TP Down", KB.TPFloor, function(k,isGp) if isGp then KB.TPFloor.gp=k; KB.TPFloor.kb=nil else KB.TPFloor.kb=k; KB.TPFloor.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Instant Reset", KB.InstaReset, function(k,isGp) if isGp then KB.InstaReset.gp=k; KB.InstaReset.kb=nil else KB.InstaReset.kb=k; KB.InstaReset.gp=nil end saveConfig() end)
    makeKeybindRow(keySection, "Hide UI", KB.GuiHide, function(k,isGp) if isGp then KB.GuiHide.gp=k; KB.GuiHide.kb=nil else KB.GuiHide.kb=k; KB.GuiHide.gp=nil end saveConfig() end)
    
    local function kbMatch(entry, kc)
        return (entry.kb and entry.kb == kc) or (entry.gp and entry.gp == kc)
    end
    UIS.InputBegan:Connect(function(input, gpe)
        if _anyKeyListening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if gpe or UIS:GetFocusedTextBox() then return end
        elseif not (input.UserInputType and input.UserInputType.Name:match("^Gamepad")) then
            return
        end
        local kc = input.KeyCode
        if kbMatch(KB.LaggerToggle, kc) then
            toggleLaggerMode()
            if _updateMobileLagger then _updateMobileLagger(laggerToggled and laggerPhase==1) end
            if _updateMobileLaggerCarry then _updateMobileLaggerCarry(laggerToggled and laggerPhase==2) end
            saveConfig()
        elseif kbMatch(KB.SpeedToggle, kc) then
            toggleCarryMode()
            if _updateMobileCarrySpeed then _updateMobileCarrySpeed(speedMode) end
            saveConfig()
        elseif kbMatch(KB.DropBrainrot, kc) then
            doDrop()
        elseif kbMatch(KB.TPFloor, kc) then
            runTPFloor()
        elseif kbMatch(KB.InstaReset, kc) then
            cursedInstaReset()
        elseif kbMatch(KB.AutoLeft, kc) then
            autoLeftEnabled = not autoLeftEnabled
            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            if _updateMobileAutoLeft then _updateMobileAutoLeft(autoLeftEnabled) end
        elseif kbMatch(KB.AutoRight, kc) then
            autoRightEnabled = not autoRightEnabled
            if autoRightEnabled then startAutoRight() else stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            if _updateMobileAutoRight then _updateMobileAutoRight(autoRightEnabled) end
        elseif kbMatch(KB.AutoBat, kc) then
            if batV2Enabled then
                batV2Enabled=false; if batV2SetVisual then batV2SetVisual(false) end; stopBatV2Aimbot()
                if _updateMobileBatV2 then _updateMobileBatV2(false) end
            end
            autoBatEnabled = not autoBatEnabled
            if autoBatEnabled then enableAutoBat() else disableAutoBat() end
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
            if _updateMobileAimbot then _updateMobileAimbot(autoBatEnabled) end
        elseif kbMatch(KB.BatV2, kc) then
            if autoBatEnabled then
                autoBatEnabled=false; if autoBatSetVisual then autoBatSetVisual(false) end; disableAutoBat()
                if _updateMobileAimbot then _updateMobileAimbot(false) end
            end
            batV2Enabled = not batV2Enabled
            if batV2Enabled then startBatV2Aimbot() else stopBatV2Aimbot() end
            if batV2SetVisual then batV2SetVisual(batV2Enabled) end
            if _updateMobileBatV2 then _updateMobileBatV2(batV2Enabled) end
        elseif kbMatch(KB.GuiHide, kc) then
            if Outer.Visible then hideGui() else showGui() end
        end
    end)
end

local _savedCfg = nil
local function loadConfigKeys()
    if not(isfile and isfile("cursedPC.json")) then return end
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("cursedPC.json")) end)
    if not ok or not cfg then return end
    _savedCfg=cfg
    local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);if cfg.batV2Key then lk(KB.BatV2,cfg.batV2Key) end
    lk(KB.LaggerToggle,cfg.laggerToggleKey)
    lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
    if cfg.normalSpeed then NS=cfg.normalSpeed end
    if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=1.3 end
    if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then autoTPHeight=cfg.autoTPHeight end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.infiniteJump~=nil then infJumpEnabled=cfg.infiniteJump==true end
    if cfg.uiLocked~=nil then uiLocked=cfg.uiLocked==true end
    if cfg.autoSwitchSpeed~=nil then autoSwitchSpeedEnabled=cfg.autoSwitchSpeed==true end
    if cfg.dropMode and (cfg.dropMode=="stand" or cfg.dropMode=="jump") then dropMode=cfg.dropMode end
    if cfg.stealMode and (cfg.stealMode=="normal" or cfg.stealMode=="semi") then stealMode=cfg.stealMode end
    if cfg.batV2Enabled~=nil then batV2Enabled=cfg.batV2Enabled end
end

local function loadConfigState()
    local cfg=_savedCfg
    if cfg then
        if normalBox then normalBox.Text=tostring(NS) end
        if carryBox then carryBox.Text=tostring(CS) end
        if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
        if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
        if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    end
    if grabRadiusBox then grabRadiusBox.Text = tostring(Steal.StealRadius) end
    if primeStealRangeBox then primeStealRangeBox.Text = tostring(SemiSteal.STEAL_PRIME_RANGE) end
    if semiStealRadiusBox then semiStealRadiusBox.Text = tostring(SemiSteal.STEAL_RADIUS) end
    if updateStealModeButtons then updateStealModeButtons() end
    updateRadiusDisplay(Steal.StealRadius)
    task.spawn(function()
        task.wait(0.15)
        if cfg then
            if cfg.antiRagdoll then 
                antiRagdollEnabled=true
                if setAntiRagVisual then setAntiRagVisual(true) end
                startAntiRagdoll() 
            end
            if cfg.autoStealEnabled then
                Steal.AutoStealEnabled=true
                if setInstaGrab then setInstaGrab(true) end
                if stealMode == "normal" then
                    pcall(startAutoSteal)
                elseif stealMode == "semi" then
                    startSemiSteal()
                end
            end
            if cfg.infiniteJump then 
                infJumpEnabled=true
                if setInfJumpVisual then setInfJumpVisual(true) end
                startInfiniteJump()
            else
                infJumpEnabled=false
                if setInfJumpVisual then setInfJumpVisual(false) end
                stopInfiniteJump()
            end
            if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end
            if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
            if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
            elseif cfg.carryMode then speedMode=false;toggleCarryMode() end
            if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
            if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
            if cfg.autoBat then 
                autoBatEnabled=true
                if autoBatSetVisual then autoBatSetVisual(true) end
                if _updateMobileAimbot then _updateMobileAimbot(true) end
                enableAutoBat()
            end
            if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
            if cfg.uiLocked and setLockUIVisual then setLockUIVisual(true) end
            if cfg.autoSwitchSpeed and setAutoSwitchVisual then 
                setAutoSwitchVisual(true)
                local char = LP.Character
                if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then _autoSwitchWasSteal = hum.WalkSpeed<25 end end
            end
            if cfg.batV2Enabled then
                batV2Enabled=true
                if batV2SetVisual then batV2SetVisual(true) end
                if _updateMobileBatV2 then _updateMobileBatV2(true) end
                startBatV2Aimbot()
            end
        end
        if _updateMobileAutoLeft then _updateMobileAutoLeft(autoLeftEnabled) end
        if _updateMobileAutoRight then _updateMobileAutoRight(autoRightEnabled) end
        if _updateMobileAimbot then _updateMobileAimbot(autoBatEnabled) end
        if _updateMobileLagger then _updateMobileLagger(laggerToggled and laggerPhase==1) end
        if _updateMobileLaggerCarry then _updateMobileLaggerCarry(laggerToggled and laggerPhase==2) end
        if _updateMobileCarrySpeed then _updateMobileCarrySpeed(speedMode) end
    end)
end

loadConfigKeys()
buildGui()
loadConfigState()
createMobileButtons()