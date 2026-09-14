repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PlayerGui = Player:WaitForChild("PlayerGui")

local GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local CFGFILE = "instantresetcfg.json"

local defCfg = { resetOn = true, resetKey = "B", tiny = false, jail = false, rocket = false, ragdoll = false, autoBalloon = false, flashingButton = true }
local cfg = {}
local function loadCfg()
    if isfile and isfile(CFGFILE) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CFGFILE)) end)
        if ok and type(data) == "table" then
            for k, v in pairs(defCfg) do cfg[k] = (data[k] ~= nil) and data[k] or v end
            return
        end
    end
    for k, v in pairs(defCfg) do cfg[k] = v end
end
loadCfg()
local saveQueued = false
local function qSave()
    if saveQueued then return end
    saveQueued = true
    task.delay(1, function()
        saveQueued = false
        if writefile then pcall(function() writefile(CFGFILE, HttpService:JSONEncode(cfg)) end) end
    end)
end

local CAM_BIND = "FunnyHubInstaResetCam"
local FLING_TIME = 0.4
local FLING_POWER = 50000
local USE_VOID = true
local VOID_TIME = 0.6
local TIMEOUT = 6
local resetting = false

local antiDieConfig = {
    enabled = false,
    healthThreshold = 25,
    invincibilityFrames = 0.5,
    fallDamageProtection = true,
    autoRevive = true,
    maxLinearVelocity = 80,
    maxAngularVelocity = 15,
    invincibleUntil = 0
}

local antiFlingConfig = {
    enabled = false,
    maxLinearVelocity = 80,
    maxAngularVelocity = 15
}

local antiDieConnections = {
    steppedConn = nil,
    heartbeatConn = nil,
    healthConn = nil,
    charConn = nil
}

local antiRagdollEnabled = false
local antiRagdollConn = nil

local function healHumanoid(humanoid)
    if not humanoid or not antiDieConfig.enabled then return end

    local maxHealth = humanoid.MaxHealth or 100
    if humanoid.Health >= maxHealth and humanoid.Health > 0 then
        return
    end

    humanoid.Health = maxHealth
    antiDieConfig.invincibleUntil = os.clock() + antiDieConfig.invincibilityFrames

    local parent = humanoid.Parent
    if parent then
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("NumberValue") then
                local nameLower = child.Name:lower()
                if nameLower:find("health") or nameLower:find("hp") then
                    child.Value = maxHealth
                end
            elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end
end

local function antiFlingHandler()
    if not antiFlingConfig.enabled then return end

    local character = Player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local linVel = rootPart.AssemblyLinearVelocity
    if linVel.Magnitude > antiFlingConfig.maxLinearVelocity then
        rootPart.AssemblyLinearVelocity = Vector3.new(
            math.clamp(linVel.X, -antiFlingConfig.maxLinearVelocity, antiFlingConfig.maxLinearVelocity),
            math.clamp(linVel.Y, -antiFlingConfig.maxLinearVelocity, antiFlingConfig.maxLinearVelocity),
            math.clamp(linVel.Z, -antiFlingConfig.maxLinearVelocity, antiFlingConfig.maxLinearVelocity)
        )
    end

    if rootPart.AssemblyAngularVelocity.Magnitude > antiFlingConfig.maxAngularVelocity then
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= Player then
            local otherChar = otherPlayer.Character
            if otherChar then
                for _, part in ipairs(otherChar:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.CanTouch = false
                        part.CanQuery = false
                    end
                end
            end
        end
    end
end

local function onAntiDieHeartbeat(rootPart, humanoid)
    if not humanoid or not rootPart or not antiDieConfig.enabled then return end

    if os.clock() < antiDieConfig.invincibleUntil and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth or 100
    end

    if antiDieConfig.fallDamageProtection and rootPart.AssemblyLinearVelocity.Y < -80 then
        rootPart.AssemblyLinearVelocity = Vector3.new(
            rootPart.AssemblyLinearVelocity.X,
            -30,
            rootPart.AssemblyLinearVelocity.Z
        )
        if humanoid.Health < humanoid.MaxHealth then
            healHumanoid(humanoid)
        end
    end

    if humanoid.Health <= 0 and antiDieConfig.autoRevive then
        healHumanoid(humanoid)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 2, 0)
        rootPart.AssemblyLinearVelocity = Vector3.zero
    end
end

local function setupAntiDieHealthConnection(character)
    if antiDieConnections.healthConn then
        antiDieConnections.healthConn:Disconnect()
        antiDieConnections.healthConn = nil
    end
    if not character then return end

    local humanoid = character:WaitForChild("Humanoid", 3)
    if not humanoid then return end

    antiDieConnections.healthConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not antiDieConfig.enabled then return end

        if humanoid.Health <= antiDieConfig.healthThreshold then
            healHumanoid(humanoid)
        end

        if humanoid.Health <= 0 and antiDieConfig.autoRevive then
            healHumanoid(humanoid)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            task.wait(0.05)
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 3, 0)
                rootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

local function startAntiDieProtection()
    if antiDieConnections.steppedConn then return end

    antiDieConnections.steppedConn = RunService.Stepped:Connect(antiFlingHandler)

    antiDieConnections.heartbeatConn = RunService.Heartbeat:Connect(function()
        if not antiDieConfig.enabled then return end

        local character = Player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        if humanoid.Health <= antiDieConfig.healthThreshold then
            healHumanoid(humanoid)
        end

        onAntiDieHeartbeat(rootPart, humanoid)
    end)

    antiDieConnections.charConn = Player.CharacterAdded:Connect(setupAntiDieHealthConnection)

    if Player.Character then
        task.spawn(setupAntiDieHealthConnection, Player.Character)
    end
end

local function stopAntiDieProtection()
    if antiDieConnections.healthConn then
        antiDieConnections.healthConn:Disconnect()
        antiDieConnections.healthConn = nil
    end
    if antiDieConnections.steppedConn then
        antiDieConnections.steppedConn:Disconnect()
        antiDieConnections.steppedConn = nil
    end
    if antiDieConnections.heartbeatConn then
        antiDieConnections.heartbeatConn:Disconnect()
        antiDieConnections.heartbeatConn = nil
    end
    if antiDieConnections.charConn then
        antiDieConnections.charConn:Disconnect()
        antiDieConnections.charConn = nil
    end
end

local function resetCharacter(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        
        workspace.CurrentCamera.CameraSubject = hum
        
        local PM = Player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = PM:FindFirstChild("ControlModule")
            if CM then
                local success, module = pcall(require, CM)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        
        local char = Player.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local state = hum:GetState()
        
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead or
           hum.PlatformStand == true or
           hum.Sit == true then
            
            resetCharacter(char)
        end
    end)
end

local function stopAntiRagdoll()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local function hide_locally(obj)
    if obj:IsA("BasePart") or obj:IsA("Decal") then
        obj.LocalTransparencyModifier = 1
    end
end

local function insta_reset()
    if resetting then return end
    local char = Player.Character
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
    resetting = true
    task.spawn(function()
        antiDieConfig.enabled = true
        antiFlingConfig.enabled = true
        antiRagdollEnabled = true
        
        startAntiDieProtection()
        startAntiRagdoll()
        
        local cam = workspace.CurrentCamera
        local frozen = cam.CFrame
        local old_type = cam.CameraType
        pcall(function()
            cam.CameraType = Enum.CameraType.Scriptable
            RunService:BindToRenderStep(CAM_BIND, Enum.RenderPriority.Camera.Value + 1, function()
                cam.CFrame = frozen
            end)
        end)
        
        local added
        pcall(function()
            for _, obj in ipairs(char:GetDescendants()) do pcall(hide_locally, obj) end
            added = char.DescendantAdded:Connect(function(obj) pcall(hide_locally, obj) end)
        end)
        
        local new_char
        local respawned = Player.CharacterAdded:Connect(function(c) new_char = c end)
        
        local function unlock()
            pcall(function() hum.PlatformStand = false end)
            pcall(function() hum.Sit = false end)
            pcall(function() hum.AutoRotate = true end)
        end
        unlock()
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function() obj.Anchored = false end)
                pcall(function() obj.CanCollide = false end)
            elseif obj.Name == "SeatWeld" then
                pcall(function() obj:Destroy() end)
            end
        end
        
        local started = os.clock()
        local function alive_hrp()
            if hrp and hrp.Parent then return hrp end
            hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then return hrp end
            return nil
        end
        
        local fling_until = os.clock() + FLING_TIME
        while not new_char and os.clock() < fling_until and hum.Parent do
            unlock()
            pcall(function() hum.HipHeight = 1e30 end)
            local root = alive_hrp()
            if root then
                pcall(function() root.Anchored = false end)
                pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, FLING_POWER, 0) end)
                pcall(function() root.Velocity = Vector3.new(0, FLING_POWER, 0) end)
            end
            RunService.Heartbeat:Wait()
        end
        
        if USE_VOID and not new_char then
            local floor = -500
            pcall(function() floor = workspace.FallenPartsDestroyHeight end)
            local void_until = os.clock() + VOID_TIME
            while not new_char and os.clock() < void_until do
                local root = alive_hrp()
                if not root then break end
                pcall(function() root.CFrame = CFrame.new(0, floor - 500, 0) end)
                pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, -FLING_POWER, 0) end)
                RunService.Heartbeat:Wait()
            end
        end
        
        while not new_char and os.clock() - started < TIMEOUT do
            if hum.Parent then
                pcall(function() hum.Health = 0 end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
            end
            if char.Parent then pcall(function() char:BreakJoints() end) end
            task.wait(0.1)
        end
        
        pcall(function() respawned:Disconnect() end)
        if added then pcall(function() added:Disconnect() end) end
        pcall(function() RunService:UnbindFromRenderStep(CAM_BIND) end)
        pcall(function()
            cam.CameraType = old_type == Enum.CameraType.Scriptable and Enum.CameraType.Custom or old_type
            if new_char then
                local new_hum = new_char:FindFirstChildOfClass("Humanoid")
                    or new_char:WaitForChild("Humanoid", 5)
                if new_hum then cam.CameraSubject = new_hum end
            end
        end)
        
        antiDieConfig.enabled = false
        antiFlingConfig.enabled = false
        antiRagdollEnabled = false
        
        stopAntiDieProtection()
        stopAntiRagdoll()
        
        resetting = false
    end)
end

local M = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local ACCENT = Color3.fromRGB(114, 60, 255)
local COLOR_BLUE = Color3.fromRGB(0, 110, 255)
local COLOR_PURPLE = Color3.fromRGB(138, 43, 226)
local BG2 = Color3.fromRGB(22,22,30)
local BG3 = Color3.fromRGB(25,25,35)
local ROW = Color3.fromRGB(25,30,42)

local grads = {}
RunService.Heartbeat:Connect(function()
    local ang = (tick()*120)%360
    for i = #grads, 1, -1 do
        local g = grads[i]
        if g and g.Parent then g.Rotation = ang else table.remove(grads, i) end
    end
end)

local function rStr()
    local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local r = ""
    for _ = 1, math.random(10, 20) do r = r .. c:sub(math.random(1, #c), math.random(1, #c)) end
    return r
end

local function mkLabel(parent, props)
    local l = Instance.new("TextLabel")
    l.Name = rStr(); l.BackgroundTransparency = 1; l.Selectable = false
    for k, v in pairs(props) do l[k] = v end
    l.Parent = parent
    return l
end

local function mkCorner(parent, radius)
    local c = Instance.new("UICorner"); c.Name = rStr(); c.CornerRadius = UDim.new(0, radius); c.Parent = parent; return c
end

local function mkStroke(parent, thick, color)
    local s = Instance.new("UIStroke"); s.Name = rStr()
    s.Color = color or Color3.fromRGB(255,255,255); s.Thickness = thick or 2; s.Transparency = 0.3
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent
    
    local g = Instance.new("UIGradient"); g.Name = rStr(); g.Parent = s
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_BLUE), 
        ColorSequenceKeypoint.new(1, COLOR_PURPLE)
    })
    g.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,.2), NumberSequenceKeypoint.new(.5,.7), NumberSequenceKeypoint.new(1,.2)})
    table.insert(grads, g)
    return s
end

local balloonActive = {}
local balloonAlarmActive = false
local blinkConnection = nil
local alarmLabel = nil
local balloonCount = 0

local MultiZones = {
	{Shape = 'Line', Center = Vector3.new(-345.35, -6.55, 39.19), Size = 5, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-350.53, -6.55, 38.67), Size = 20, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-364.01, -6.55, 38.94), Size = 20, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-337.34, -6.55, 39.18), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-365.29, -6.95, -10.40), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-354.68, -6.95, 6.22), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-343.15, -6.53, -13.20), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-344.93, -6.95, 25.73), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-343.76, -6.95, -10.27), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-354.42, -6.95, 6.51), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-340.48, -5.32, 28.10), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-361.10, -6.95, 29.42), Size = 20, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-354.83, 27.19, 31.22), Size = 20, Rotation = 0},
}

for _, zone in ipairs(MultiZones) do
	zone.HalfSize = zone.Size / 2
end

local function isInAnyZone(position)
	for _, zone in ipairs(MultiZones) do
		local dx = math.abs(position.X - zone.Center.X)
		local dz = math.abs(position.Z - zone.Center.Z)
		if zone.Shape == 'Line' then
			if dx <= zone.HalfSize and dz <= 1.5 then return true end
		elseif zone.Shape == 'Square' then
			if dx <= zone.HalfSize and dz <= zone.HalfSize then return true end
		end
	end
	return false
end

local function hasStealingMessage()
	local playerGui = Player:WaitForChild("PlayerGui")
	for _, desc in pairs(playerGui:GetDescendants()) do
		if desc:IsA("TextLabel") or desc:IsA("TextButton") then
			local text = desc.Text
			if text and string.find(text, "Someone is stealing your") then
				return true
			end
		end
	end
	return false
end

local function hasBrainrot(targetPlayer)
	if not targetPlayer.Character then return false end
	local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	local playerNames = {}
	for _, p in pairs(Players:GetPlayers()) do
		playerNames[p.Name] = true
	end
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and not playerNames[v.Name] and not v:IsDescendantOf(targetPlayer.Character) then
			local rp = v:FindFirstChild("RootPart") or v:FindFirstChild("FakeRootPart")
			if rp then
				if (rp.Position - root.Position).Magnitude < 8 then
					return true
				end
			end
		end
	end
	return false
end

local function findAdminPanel()
	return Player:WaitForChild("PlayerGui"):FindFirstChild("AdminPanel")
end

local function findPlayerButton(targetPlayer)
	local adminPanel = findAdminPanel()
	if not adminPanel then return nil end
	for _, desc in pairs(adminPanel:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local t = ""
			if desc:IsA("TextButton") then
				t = desc.Text
			else
				local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
				if lbl then t = lbl.Text end
			end
			if t == targetPlayer.DisplayName or t:find(targetPlayer.DisplayName)
				or t == targetPlayer.Name or t:find(targetPlayer.Name) then
				return desc
			end
		end
	end
	return nil
end

local function getCommandButtons()
	local btns = {}
	local adminPanel = findAdminPanel()
	if not adminPanel then return btns end
	for _, desc in pairs(adminPanel:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local t = ""
			if desc:IsA("TextButton") then
				t = desc.Text
			else
				local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
				if lbl then t = lbl.Text end
			end
			if t and t ~= "" and (t:match("^:") or t:match("^;")) then
				table.insert(btns, {button = desc, name = t})
			end
		end
	end
	return btns
end

local function clickButton(button)
	pcall(function()
		button.MouseButton1Click:Fire()
	end)
	pcall(function()
		button.Activated:Fire()
	end)
	pcall(function()
		if getconnections then
			for _, cx in pairs(getconnections(button.MouseButton1Click)) do cx:Fire() end
			for _, cx in pairs(getconnections(button.Activated)) do cx:Fire() end
		end
	end)
end

local function isExactCommand(buttonName, expectedCmdName)
	local bName = string.lower(string.match(buttonName, "^%s*(.-)%s*$") or buttonName)
	local cmdName = string.lower(expectedCmdName)
	if bName == cmdName or bName == ":"..cmdName or bName == ";"..cmdName then return true end
	if string.match(bName, "^[:;]?"..cmdName.."$") or string.match(bName, "^[:;]?"..cmdName.."%s") then return true end
	return false
end

local function triggerBalloonOnTarget(targetPlayer)
	if not targetPlayer or not targetPlayer.Parent then return end
	if not findAdminPanel() then return end
	
	for i = 1, 3 do
		for _, cBtn in ipairs(getCommandButtons()) do
			if isExactCommand(cBtn.name, "balloon") then
				clickButton(cBtn.button)
				task.wait(0.01)
				local pBtn = findPlayerButton(targetPlayer)
				if pBtn then clickButton(pBtn) end
				break
			end
		end
		task.wait(0.01)
	end
	
	if showAlarm then
		showAlarm()
	end
end

local showAlarm = nil

local function ensureAlarmLabel()
    if alarmLabel and alarmLabel.Parent then return end
    local pg = Player:WaitForChild("PlayerGui")
    
    alarmLabel = Instance.new("TextLabel")
    alarmLabel.Name = "BalloonAlarm"
    alarmLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    alarmLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
    alarmLabel.Size = UDim2.new(0, 500, 0, 60)
    alarmLabel.BackgroundTransparency = 1
    alarmLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    alarmLabel.TextSize = 28
    alarmLabel.Font = Enum.Font.GothamBlack
    alarmLabel.TextWrapped = true
    alarmLabel.TextStrokeTransparency = 0.4
    alarmLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    alarmLabel.Text = ""
    alarmLabel.Visible = false
    alarmLabel.ZIndex = 100
    alarmLabel.RichText = true
    alarmLabel.Parent = pg
end

local ebGradient = nil
local textGradient = nil
local ebStroke = nil

showAlarm = function()
    ensureAlarmLabel()
    balloonCount = balloonCount + 1
    
    if alarmLabel then
        alarmLabel.Text = "⚠️ Be careful you can't balloon! (" .. balloonCount .. ") ⚠️"
        alarmLabel.Visible = true
    end
    
    if not cfg.flashingButton then
        task.delay(29, function()
            if alarmLabel and alarmLabel.Parent then
                alarmLabel.Visible = false
            end
        end)
        return
    end
    
    if not balloonAlarmActive then
        balloonAlarmActive = true
        
        if blinkConnection then
            blinkConnection:Disconnect()
            blinkConnection = nil
        end
        
        local blinkStart = tick()
        local blinkDuration = 29
        
        blinkConnection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - blinkStart
            
            if elapsed >= blinkDuration then
                blinkConnection:Disconnect()
                blinkConnection = nil
                balloonAlarmActive = false
                
                if ebGradient then
                    ebGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)), 
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 25, 48))
                    })
                    ebGradient.Rotation = 135
                end
                
                if textGradient then
                    textGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), 
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 75, 220))
                    })
                    textGradient.Rotation = 90
                end
                
                if ebStroke then
                    ebStroke.Color = Color3.fromRGB(0, 110, 255)
                    ebStroke.Thickness = M and 1.2 or 1.5
                end
                
                return
            end
            
            local blinkSpeed = 0.4
            local phase = (elapsed % blinkSpeed) / blinkSpeed
            
            if phase < 0.5 then
                if ebGradient then
                    ebGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 10, 10)), 
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 20))
                    })
                end
                
                if textGradient then
                    textGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), 
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
                    })
                end
                
                if ebStroke then
                    ebStroke.Color = Color3.fromRGB(255, 50, 50)
                    ebStroke.Thickness = (M and 1.2 or 1.5) + 1
                end
            else
                if ebGradient then
                    ebGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)), 
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 25, 48))
                    })
                    ebGradient.Rotation = 135
                end
                
                if textGradient then
                    textGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), 
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 75, 220))
                    })
                    textGradient.Rotation = 90
                end
                
                if ebStroke then
                    ebStroke.Color = Color3.fromRGB(0, 110, 255)
                    ebStroke.Thickness = M and 1.2 or 1.5
                end
            end
        end)
    end
    
    task.delay(29, function()
        if alarmLabel and alarmLabel.Parent then
            alarmLabel.Visible = false
        end
    end)
end

local CW = M and 210 or 260
local HDR_H = M and 30 or 40
local ROW_H = M and 28 or 34
local ROW_GAP = M and 5 or 7
local TS = ROW_H + ROW_GAP
local T0 = HDR_H + (M and 6 or 10)

local EXEC_Y = T0 + TS*2 + (M and 6 or 10)
local EXEC_H = M and 36 or 46
local cardH = EXEC_Y + EXEC_H + (M and 10 or 14)
local minCardH = T0 + EXEC_H + (M and 14 or 20)

local sg = Instance.new("ScreenGui")
sg.Name = rStr()
sg.ResetOnSpawn = false
sg.DisplayOrder = 2147483647
sg.Parent = PlayerGui

local outer = Instance.new("Frame"); outer.Name = rStr()
outer.Size = UDim2.new(0, CW, 0, cardH); outer.AnchorPoint = Vector2.new(0.5, 0)
outer.Position = UDim2.new(0.5, 0, 0, M and 74 or 104)
outer.BackgroundTransparency = 1; outer.Parent = sg; mkCorner(outer, M and 8 or 12)

local card = Instance.new("Frame"); card.Name = rStr()
card.Size = UDim2.new(1,0,1,0); card.BackgroundColor3 = BG2
card.BackgroundTransparency = 0.15; card.BorderSizePixel = 0; card.ClipsDescendants = false; card.Parent = outer
mkCorner(card, M and 8 or 12)
do
    local g = Instance.new("UIGradient"); g.Name = rStr()
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,BG3), ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,25))})
    g.Rotation = 135; g.Parent = card
    mkStroke(card, M and 1.5 or 2)
end

local header = Instance.new("Frame"); header.Name = rStr()
header.Size = UDim2.new(1,0,0,HDR_H); header.BackgroundColor3 = Color3.fromRGB(30,30,40)
header.BackgroundTransparency = 0.3; header.BorderSizePixel = 0; header.Parent = card
mkCorner(header, M and 8 or 12); mkStroke(header, M and 1 or 1.5)

local titleLbl = mkLabel(header, {
    Position = UDim2.new(0,0,0,0), Size = UDim2.new(1,0,1,0),
    Text = "Instant Reset",
    Font = Enum.Font.GothamBold, TextSize = M and 12 or 15,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Left,
})
titleLbl.Position = UDim2.new(0, M and 10 or 14, 0, 0)
do
    local tg = Instance.new("UIGradient"); tg.Name = rStr()
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_BLUE), 
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)), 
        ColorSequenceKeypoint.new(1, COLOR_PURPLE)
    })
    tg.Parent = titleLbl
    RunService.Heartbeat:Connect(function() tg.Rotation = (tick()*100)%360 end)
end

local settingsFrame = Instance.new("Frame")
settingsFrame.Name = rStr(); settingsFrame.Size = UDim2.new(1, 0, 0, TS * 6 + (M and 10 or 16))
settingsFrame.Position = UDim2.new(0, 0, 1, 10); settingsFrame.BackgroundColor3 = BG2
settingsFrame.BackgroundTransparency = 0.15; settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false; settingsFrame.Parent = outer
mkCorner(settingsFrame, M and 8 or 12); mkStroke(settingsFrame, M and 1.5 or 2)

local isUILocked = false
local BTN_SIZE = M and 18 or 22
local BTN_GAP = 6

local function mkHeaderBtn(parent, text, textSize, positionOffset)
    local btn = Instance.new("TextButton")
    btn.Name = rStr(); btn.Parent = parent
    btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
    btn.Position = UDim2.new(1, positionOffset, 0.5, 0)
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    btn.Text = text; btn.TextSize = textSize
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 10
    mkCorner(btn, 4)
    local s = Instance.new("UIStroke")
    s.Name = rStr()
    s.Color = Color3.fromRGB(70, 70, 90)
    s.Thickness = 1
    s.Transparency = 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = btn
    return btn, s
end

local lockBtn, lockStroke = mkHeaderBtn(header, "🔓", M and 11 or 13, -5)
local settingsBtn, settingsStroke = mkHeaderBtn(header, "⚙", M and 11 or 13, -5 - BTN_SIZE - BTN_GAP)
local minBtn, minStroke = mkHeaderBtn(header, "-", M and 13 or 16, -5 - (BTN_SIZE * 2) - (BTN_GAP * 2))

lockBtn.MouseButton1Click:Connect(function()
    isUILocked = not isUILocked
    lockBtn.Text = isUILocked and "🔒" or "🔓"
    if lockStroke then
        TweenService:Create(lockStroke, TweenInfo.new(0.2), {
            Color = isUILocked and ACCENT or Color3.fromRGB(70, 70, 90)
        }):Play()
    end
end)

settingsBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

local function mkTglRow(parent, labelText, posY)
    local tf = Instance.new("Frame"); tf.Name = rStr()
    tf.Size = UDim2.new(1, M and -12 or -20, 0, ROW_H); tf.Position = UDim2.new(0, M and 6 or 10, 0, posY)
    tf.BackgroundColor3 = ROW; tf.BackgroundTransparency = 0.3; tf.BorderSizePixel = 0; tf.Parent = parent
    mkCorner(tf, M and 5 or 7)
    local ts = Instance.new("UIStroke"); ts.Name = rStr(); ts.Color = Color3.fromRGB(60,70,95)
    ts.Transparency = 0.5; ts.Thickness = M and 1 or 1.5; ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; ts.Parent = tf

    local PILL_W = M and 36 or 42
    local PILL_OFF = M and -9 or -12
    mkLabel(tf, {
        Position = UDim2.new(0, M and 8 or 12, 0, 0), Size = UDim2.new(1, M and -56 or -68, 1, 0),
        Text = labelText, Font = Enum.Font.GothamBold, TextSize = M and 9 or 11,
        TextColor3 = Color3.fromRGB(230,235,250), TextXAlignment = Enum.TextXAlignment.Left,
    })

    local btn = Instance.new("TextButton"); btn.Name = rStr(); btn.Parent = tf
    btn.Size = UDim2.new(0, PILL_W, 0, M and 18 or 22); btn.Position = UDim2.new(1, PILL_OFF, 0.5, 0); btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(45,52,70); btn.Text = ""; btn.BorderSizePixel = 0
    btn.AutoButtonColor = false; btn.ClipsDescendants = true; btn.Selectable = false; mkCorner(btn, 100)

    local ind = Instance.new("Frame"); ind.Name = rStr(); ind.Parent = btn
    ind.Size = UDim2.new(0, M and 13 or 16, 0, M and 13 or 16); ind.Position = UDim2.new(0, 3, 0.5, 0); ind.AnchorPoint = Vector2.new(0, 0.5)
    ind.BackgroundColor3 = Color3.fromRGB(160,170,190); ind.BorderSizePixel = 0; mkCorner(ind, 100)

    return { frame = tf, button = btn, indicator = ind, stroke = ts }
end

local function tweenTgl(t, on)
    local tP = on and UDim2.new(1, M and -16 or -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    TweenService:Create(t.indicator, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = tP}):Play()
    TweenService:Create(t.button, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = on and ACCENT or Color3.fromRGB(45,52,70)}):Play()
    TweenService:Create(t.indicator, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,170,190)}):Play()
    TweenService:Create(t.stroke, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Color = on and ACCENT or Color3.fromRGB(60,70,95), Transparency = on and 0.3 or 0.5}):Play()
end

local SETTINGS_TEXT_SIZE = M and 8 or 10

local autoBalloonTgl = mkTglRow(card, "AUTO BALLOON", T0 + TS*0)
tweenTgl(autoBalloonTgl, cfg.autoBalloon)
autoBalloonTgl.button.MouseButton1Click:Connect(function()
    cfg.autoBalloon = not cfg.autoBalloon
    tweenTgl(autoBalloonTgl, cfg.autoBalloon)
    if not cfg.autoBalloon then
        balloonActive = {}
    end
    qSave()
end)

local flashingTgl = mkTglRow(card, "FLASHING BUTTON", T0 + TS*1)
tweenTgl(flashingTgl, cfg.flashingButton)
flashingTgl.button.MouseButton1Click:Connect(function()
    cfg.flashingButton = not cfg.flashingButton
    tweenTgl(flashingTgl, cfg.flashingButton)
    qSave()
end)

local sT0 = M and 6 or 10

local resetOnTgl = mkTglRow(settingsFrame, "RESET ON BALLOON", sT0 + TS*0)
resetOnTgl.frame:FindFirstChildWhichIsA("TextLabel").TextSize = SETTINGS_TEXT_SIZE
tweenTgl(resetOnTgl, cfg.resetOn)
resetOnTgl.button.MouseButton1Click:Connect(function()
    cfg.resetOn = not cfg.resetOn
    tweenTgl(resetOnTgl, cfg.resetOn); qSave()
end)

local ragdollTgl = mkTglRow(settingsFrame, "RESET ON RAGDOLL", sT0 + TS*1)
ragdollTgl.frame:FindFirstChildWhichIsA("TextLabel").TextSize = SETTINGS_TEXT_SIZE
tweenTgl(ragdollTgl, cfg.ragdoll)
ragdollTgl.button.MouseButton1Click:Connect(function() cfg.ragdoll = not cfg.ragdoll; tweenTgl(ragdollTgl, cfg.ragdoll); qSave() end)

local jailTgl = mkTglRow(settingsFrame, "RESET ON JAIL", sT0 + TS*2)
jailTgl.frame:FindFirstChildWhichIsA("TextLabel").TextSize = SETTINGS_TEXT_SIZE
tweenTgl(jailTgl, cfg.jail)
jailTgl.button.MouseButton1Click:Connect(function() cfg.jail = not cfg.jail; tweenTgl(jailTgl, cfg.jail); qSave() end)

local rocketTgl = mkTglRow(settingsFrame, "RESET ON ROCKET", sT0 + TS*3)
rocketTgl.frame:FindFirstChildWhichIsA("TextLabel").TextSize = SETTINGS_TEXT_SIZE
tweenTgl(rocketTgl, cfg.rocket)
rocketTgl.button.MouseButton1Click:Connect(function() cfg.rocket = not cfg.rocket; tweenTgl(rocketTgl, cfg.rocket); qSave() end)

local tinyTgl = mkTglRow(settingsFrame, "RESET ON TINY", sT0 + TS*4)
tinyTgl.frame:FindFirstChildWhichIsA("TextLabel").TextSize = SETTINGS_TEXT_SIZE
tweenTgl(tinyTgl, cfg.tiny)
tinyTgl.button.MouseButton1Click:Connect(function() cfg.tiny = not cfg.tiny; tweenTgl(tinyTgl, cfg.tiny); qSave() end)

local keyRow = Instance.new("Frame"); keyRow.Name = rStr()
keyRow.Size = UDim2.new(1, M and -12 or -20, 0, ROW_H); keyRow.Position = UDim2.new(0, M and 6 or 10, 0, sT0 + TS*5)
keyRow.BackgroundColor3 = ROW; keyRow.BackgroundTransparency = 0.3; keyRow.BorderSizePixel = 0; keyRow.Parent = settingsFrame
mkCorner(keyRow, M and 5 or 7)
do
    local s = Instance.new("UIStroke"); s.Name = rStr(); s.Color = Color3.fromRGB(60,70,95)
    s.Transparency = 0.5; s.Thickness = M and 1 or 1.5; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = keyRow
end
mkLabel(keyRow, {
    Position = UDim2.new(0, M and 8 or 12, 0, 0), Size = UDim2.new(1, M and -60 or -76, 1, 0),
    Text = "KEYBIND", Font = Enum.Font.GothamBold, TextSize = SETTINGS_TEXT_SIZE,
    TextColor3 = Color3.fromRGB(230,235,250), TextXAlignment = Enum.TextXAlignment.Left,
})
local keyBtn = Instance.new("TextButton"); keyBtn.Name = rStr(); keyBtn.Parent = keyRow
keyBtn.Size = UDim2.new(0, M and 48 or 60, 0, M and 18 or 22)
keyBtn.Position = UDim2.new(1, M and -9 or -12, 0.5, 0); keyBtn.AnchorPoint = Vector2.new(1, 0.5)
keyBtn.BackgroundColor3 = Color3.fromRGB(40,46,65); keyBtn.BorderSizePixel = 0
keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = SETTINGS_TEXT_SIZE
keyBtn.TextColor3 = Color3.fromRGB(230,235,250); keyBtn.AutoButtonColor = false; keyBtn.Selectable = false
keyBtn.Text = cfg.resetKey
mkCorner(keyBtn, 4)
mkStroke(keyBtn, 1, Color3.fromRGB(80,90,120))

local listeningForKey = false
keyBtn.MouseButton1Click:Connect(function()
    listeningForKey = true
    keyBtn.Text = "..."
    keyBtn.BackgroundColor3 = ACCENT
end)

local eb = Instance.new("TextButton"); eb.Name = rStr(); eb.Parent = card
eb.Size = UDim2.new(1, M and -12 or -20, 0, EXEC_H); eb.Position = UDim2.new(0, M and 6 or 10, 0, EXEC_Y)
eb.BackgroundColor3 = Color3.fromRGB(255,255,255); eb.Text = ""
eb.BorderSizePixel = 0; eb.AutoButtonColor = false; eb.Selectable = false; mkCorner(eb, M and 5 or 7)
mkStroke(eb, M and 1.2 or 1.5, Color3.fromRGB(0, 110, 255))

local resetTextLabel = Instance.new("TextLabel")
resetTextLabel.Name = rStr(); resetTextLabel.Size = UDim2.new(1, 0, 1, 0)
resetTextLabel.BackgroundTransparency = 1; resetTextLabel.Text = "Reset"
resetTextLabel.Font = Enum.Font.FredokaOne
resetTextLabel.TextSize = M and 16 or 22
resetTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255); resetTextLabel.ZIndex = 3; resetTextLabel.Parent = eb

local textGlow = Instance.new("UIStroke")
textGlow.Name = rStr(); textGlow.Color = Color3.fromRGB(0, 0, 0); textGlow.Thickness = 2.2
textGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual; textGlow.Parent = resetTextLabel

do
    local g = Instance.new("UIGradient"); g.Name = rStr()
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 25, 48))
    })
    g.Rotation = 135; g.Parent = eb
end

do
    local tg = Instance.new("UIGradient"); tg.Name = rStr()
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 75, 220))
    })
    tg.Rotation = 90; tg.Parent = resetTextLabel
end

ebGradient = eb:FindFirstChildOfClass("UIGradient")
textGradient = resetTextLabel:FindFirstChildOfClass("UIGradient")
ebStroke = eb:FindFirstChildOfClass("UIStroke")

if not M then
    eb.MouseEnter:Connect(function() TweenService:Create(eb, TweenInfo.new(0.12), {BackgroundTransparency = 0.15}):Play() end)
    eb.MouseLeave:Connect(function() TweenService:Create(eb, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play() end)
end

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    minBtn.Text = isMinimized and "+" or "-"
    minBtn.TextSize = M and 13 or 16
    
    if isMinimized then
        autoBalloonTgl.frame.Visible = false
        flashingTgl.frame.Visible = false
        settingsFrame.Visible = false
        TweenService:Create(outer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, CW, 0, minCardH + (M and 6 or 10))}):Play()
        TweenService:Create(eb, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, M and 4 or 6, 0, T0),
            Size = UDim2.new(1, M and -8 or -12, 0, EXEC_H + (M and 8 or 14))
        }):Play()
        TweenService:Create(resetTextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextSize = M and 18 or 24}):Play()
    else
        autoBalloonTgl.frame.Visible = true
        flashingTgl.frame.Visible = true
        TweenService:Create(outer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, CW, 0, cardH)}):Play()
        TweenService:Create(eb, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, M and 6 or 10, 0, EXEC_Y),
            Size = UDim2.new(1, M and -12 or -20, 0, EXEC_H)
        }):Play()
        TweenService:Create(resetTextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextSize = M and 16 or 22}):Play()
    end
end)

eb.MouseButton1Click:Connect(function()
    insta_reset()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if listeningForKey then
        listeningForKey = false
        cfg.resetKey = input.KeyCode.Name
        keyBtn.Text = cfg.resetKey
        keyBtn.BackgroundColor3 = Color3.fromRGB(40,46,65)
        qSave()
        return
    end
    if gpe then return end
    if input.KeyCode.Name == cfg.resetKey then
        insta_reset()
    end
end)

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        obj.OnClientEvent:Connect(function(...)
            for _, arg in ipairs({...}) do
                if type(arg) == "string" then
                    local str = arg:lower()
                    
                    if cfg.resetOn and str:find("jump higher") then
                        insta_reset()
                        break
                    elseif cfg.tiny and str:find("tiny") then
                        insta_reset()
                        break
                    elseif cfg.jail and str:find("jail") then
                        insta_reset()
                        break
                    elseif cfg.rocket and str:find("rocket") then
                        insta_reset()
                        break
                    elseif cfg.ragdoll and str:find("ragdoll") then
                        insta_reset()
                        break
                    end
                end
            end
        end)
    end
end

local lastCheck = 0
RunService.Heartbeat:Connect(function()
    if not cfg.autoBalloon then return end
    local now = tick()
    if now - lastCheck < 0.1 then return end
    lastCheck = now

    local hasMessage = hasStealingMessage()
    
    for _, p in pairs(Players:GetPlayers()) do
        if p == Player then continue end
        local character = p.Character
        if not character then continue end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("Torso")
        if not rootPart then continue end

        local targetKey = p.UserId
        local inZone = isInAnyZone(rootPart.Position)
        local hasBrainrotWeapon = hasBrainrot(p)

        if inZone and hasMessage and hasBrainrotWeapon and not balloonActive[targetKey] then
            balloonActive[targetKey] = true
            triggerBalloonOnTarget(p)
        elseif (not inZone or not hasMessage) and balloonActive[targetKey] then
            balloonActive[targetKey] = nil
        end
    end
end)

local dragging = false
local dragStartPos = nil
local startPos = nil

header.InputBegan:Connect(function(input)
    if isUILocked then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = input.Position
        startPos = outer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStartPos
        outer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    balloonActive[p.UserId] = nil
end)