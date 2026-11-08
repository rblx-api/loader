do
    local PlayersSvc = game:GetService("Players")
    local RunSvc     = game:GetService("RunService")
    local TweenSvc   = game:GetService("TweenService")
    local UISSvc     = game:GetService("UserInputService")
    local CoreGuiSvc = game:GetService("CoreGui")

    local LP = PlayersSvc.LocalPlayer
    local PlayerGuiSvc = LP:WaitForChild("PlayerGui")

    local parent
    pcall(function()
        if type(gethui) == "function" then parent = gethui() end
    end)
    if not parent then parent = CoreGuiSvc end
    if not parent then parent = PlayerGuiSvc end

    for _, p in ipairs({parent, CoreGuiSvc, PlayerGuiSvc}) do
        if p then
            local old = p:FindFirstChild("KlausPreInstantReset")
            if old then old:Destroy() end
        end
    end

    local K = {
        bg       = Color3.fromRGB(8, 12, 9),
        panel    = Color3.fromRGB(15, 22, 16),
        panel2   = Color3.fromRGB(23, 34, 24),
        fill     = Color3.fromRGB(29, 43, 30),
        line     = Color3.fromRGB(52, 92, 48),
        accent   = Color3.fromRGB(88, 166, 62),
        glow     = Color3.fromRGB(155, 220, 92),
        text     = Color3.fromRGB(245, 255, 242),
        textDim  = Color3.fromRGB(155, 184, 148),
        success  = Color3.fromRGB(48, 209, 88),
    }

    local RESET_MAX_DURATION = 0.05
    local resetCooldown = false
    local resetThread = nil
    local resetSuccessful = false
    local stopResetSequence = false
    local cameraLocked = false
    local lockedCameraCFrame = nil
    local resetLockId = 0

    local function forceUnlock()
        cameraLocked = false
        lockedCameraCFrame = nil
        stopResetSequence = true
        resetCooldown = false
        if resetThread then pcall(task.cancel, resetThread) end
        resetThread = nil
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CameraType = Enum.CameraType.Custom
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then cam.CameraSubject = hum end
            end
        end)
        local char = LP.Character
        if char then
            pcall(function()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if hum.HipHeight > 10 or hum.HipHeight < 0 then hum.HipHeight = 2 end
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum.AutoRotate = true
                end
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.CanCollide = true
                    end
                end
            end)
        end
    end

    local function equipResetCarpet()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if not char or not hum then return false end

        local carpet
        local function match(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = tool.Name:lower():gsub("%s+", " ")
            return n:find("carpet", 1, true) ~= nil
                or n:find("flying carpet", 1, true) ~= nil
                or n:find("carpet flying", 1, true) ~= nil
                or n:find("magic carpet", 1, true) ~= nil
        end
        for _, tool in ipairs(char:GetChildren()) do
            if match(tool) then carpet = tool break end
        end
        if not carpet and backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if match(tool) then carpet = tool break end
            end
        end
        if not carpet then return false end
        pcall(function()
            if carpet.Parent ~= char then hum:EquipTool(carpet) end
        end)
        local deadline = tick() + 0.5
        while carpet.Parent ~= char and tick() < deadline do task.wait() end
        return carpet.Parent == char
    end

    local function ResetPlayer()
        if resetCooldown then return end
        resetCooldown = true
        resetSuccessful = false
        stopResetSequence = false

        local character = LP.Character
        if not character then resetCooldown = false return end

        pcall(equipResetCarpet)

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then resetCooldown = false return end

        resetLockId = resetLockId + 1
        local myLockId = resetLockId

        local camera = workspace.CurrentCamera
        if camera then
            lockedCameraCFrame = camera.CFrame
            cameraLocked = true
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = lockedCameraCFrame
        end

        local originalHipHeight = humanoid.HipHeight
        if type(originalHipHeight) ~= "number" or originalHipHeight > 10 or originalHipHeight < 0 then
            originalHipHeight = 2
        end
        local isRespawning = false

        resetThread = task.spawn(function()
            local attempts = 0
            local maxAttempts = 25
            while character and character.Parent and humanoid and humanoid.Health > 0
                and not isRespawning and not stopResetSequence and myLockId == resetLockId do
                if LP.Character ~= character then isRespawning = true break end
                pcall(function()
                    humanoid.HipHeight = 1e30
                    humanoid.AutoRotate = true
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then root.CanCollide = false end
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)
                if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then
                    resetSuccessful = true break
                end
                attempts = attempts + 1
                if attempts >= maxAttempts then break end
                task.wait(RESET_MAX_DURATION)
            end
            if character and character.Parent and humanoid then
                pcall(function() humanoid.HipHeight = originalHipHeight end)
            end
            if not resetSuccessful and not isRespawning and myLockId == resetLockId and not stopResetSequence then
                if character and character.Parent and humanoid and humanoid.Health > 0 then
                    pcall(function() humanoid.Health = 0 end)
                    task.wait(0.1)
                    if not character.Parent or humanoid.Health <= 0 then resetSuccessful = true end
                end
            end
            if not resetSuccessful and character and character.Parent and myLockId == resetLockId then
                pcall(function()
                    humanoid.HipHeight = originalHipHeight
                    humanoid.PlatformStand = false
                    humanoid.AutoRotate = true
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then root.CanCollide = true end
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end)
            end
            if myLockId == resetLockId then
                cameraLocked = false
                lockedCameraCFrame = nil
                resetCooldown = false
                resetThread = nil
                stopResetSequence = false
                pcall(function()
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CameraType = Enum.CameraType.Custom
                        local newChar = LP.Character
                        local newHum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                        if newHum then cam.CameraSubject = newHum end
                    end
                end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function(newChar)
        resetLockId = resetLockId + 1
        forceUnlock()
        resetSuccessful = false
        task.defer(function()
            task.wait(0.2)
            forceUnlock()
            if newChar and newChar.Parent then
                pcall(function()
                    local hum = newChar:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.HipHeight = 2
                        hum.PlatformStand = false
                        hum.AutoRotate = true
                    end
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CameraType = Enum.CameraType.Custom
                        cam.CameraSubject = hum
                    end
                end)
            end
        end)
    end)

    RunSvc.Heartbeat:Connect(function()
        if cameraLocked and lockedCameraCFrame then
            local camera = workspace.CurrentCamera
            if camera then
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = lockedCameraCFrame
            end
        end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "KlausPreInstantReset"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 1000
    gui.IgnoreGuiInset = false
    pcall(function()
        if type(protect_gui) == "function" then protect_gui(gui) end
        if syn and type(syn.protect_gui) == "function" then syn.protect_gui(gui) end
    end)
    local okParent = pcall(function() gui.Parent = parent end)
    if not okParent or not gui.Parent then
        gui.Parent = PlayerGuiSvc
    end

    local W, H = 260, 110
    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.fromOffset(W, H)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.BackgroundColor3 = K.bg
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Thickness = 1.5
    panelStroke.Color = Color3.new(1, 1, 1)
    panelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    panelStroke.LineJoinMode = Enum.LineJoinMode.Round
    local strokeGrad = Instance.new("UIGradient", panelStroke)
    strokeGrad.Color = ColorSequence.new(K.accent, K.glow)
    strokeGrad.Rotation = 35
    RunSvc.Heartbeat:Connect(function()
        if strokeGrad and strokeGrad.Parent then
            strokeGrad.Rotation = (tick() * 35) % 360
        end
    end)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.Active = true
    header.Parent = panel

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = K.accent
    dot.BorderSizePixel = 0
    dot.Parent = header
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 28, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Pre Instant Reset"
    title.TextColor3 = K.text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    local titleGrad = Instance.new("UIGradient", title)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, K.text),
        ColorSequenceKeypoint.new(0.5, K.glow),
        ColorSequenceKeypoint.new(1, K.text),
    })
    RunSvc.Heartbeat:Connect(function()
        if titleGrad and titleGrad.Parent then
            titleGrad.Rotation = (tick() * 100) % 360
        end
    end)

    local execBtn = Instance.new("TextButton")
    execBtn.Name = "Execute"
    execBtn.Size = UDim2.new(1, -24, 0, 40)
    execBtn.Position = UDim2.new(0, 12, 0, 44)
    execBtn.BackgroundColor3 = K.panel2
    execBtn.BackgroundTransparency = 0.1
    execBtn.BorderSizePixel = 0
    execBtn.AutoButtonColor = false
    execBtn.Text = "EXECUTE"
    execBtn.TextColor3 = K.text
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 15
    execBtn.Parent = panel
    Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 10)

    local execStroke = Instance.new("UIStroke", execBtn)
    execStroke.Color = K.accent
    execStroke.Thickness = 1.5
    execStroke.Transparency = 0.2

    local execLabelGrad = Instance.new("UIGradient", execBtn)
    execLabelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, K.text),
        ColorSequenceKeypoint.new(0.5, K.glow),
        ColorSequenceKeypoint.new(1, K.text),
    })

    execBtn.MouseEnter:Connect(function()
        TweenSvc:Create(execBtn, TweenInfo.new(0.12), {
            BackgroundColor3 = K.fill,
            BackgroundTransparency = 0,
        }):Play()
        TweenSvc:Create(execStroke, TweenInfo.new(0.12), {
            Color = K.glow,
            Transparency = 0,
        }):Play()
    end)
    execBtn.MouseLeave:Connect(function()
        TweenSvc:Create(execBtn, TweenInfo.new(0.12), {
            BackgroundColor3 = K.panel2,
            BackgroundTransparency = 0.1,
        }):Play()
        TweenSvc:Create(execStroke, TweenInfo.new(0.12), {
            Color = K.accent,
            Transparency = 0.2,
        }):Play()
    end)

    execBtn.MouseButton1Click:Connect(function()
        TweenSvc:Create(execBtn, TweenInfo.new(0.08), {
            BackgroundColor3 = K.success,
            BackgroundTransparency = 0,
        }):Play()
        task.delay(0.2, function()
            if execBtn and execBtn.Parent then
                TweenSvc:Create(execBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = K.panel2,
                    BackgroundTransparency = 0.1,
                }):Play()
            end
        end)
        pcall(ResetPlayer)
    end)

    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = panel.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UISSvc.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = inp.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end)
end