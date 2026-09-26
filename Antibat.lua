local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local State = {
    antiBatActive = false,
    infJumpActive = false,
    antiBatThread = nil,
    infJumpThread = nil,
    guiVisible = true,
    mobileMode = false
}
local C = {
    bg = Color3.fromRGB(25, 18, 22),
    card = Color3.fromRGB(20, 14, 17),
    cardActive1 = Color3.fromRGB(45, 20, 32),
    cardActive2 = Color3.fromRGB(45, 20, 32),
    border = Color3.fromRGB(40, 28, 33),
    text = Color3.fromRGB(255, 255, 255),
    textSub = Color3.fromRGB(160, 150, 155),
    accent1 = Color3.fromRGB(255, 45, 130),
    accent2 = Color3.fromRGB(255, 105, 180),
    pillOff = Color3.fromRGB(30, 22, 26),
    dotOff = Color3.fromRGB(85, 80, 82),
    watermark = Color3.fromRGB(255, 105, 180)
}
local antiBatBind = { type = "keyboard", value = Enum.KeyCode.O }
local infJumpBind = { type = "keyboard", value = Enum.KeyCode.I }
local guiToggleBind = { type = "keyboard", value = Enum.KeyCode.LeftControl }
local CONFIG_FILE = "GreenDuels_config.json"
local shortToFullGamepad = {
    A = "ButtonA", B = "ButtonB", X = "ButtonX", Y = "ButtonY",
    LB = "ButtonL1", RB = "ButtonR1", LT = "ButtonL2", RT = "ButtonR2",
    START = "ButtonStart", SELECT = "ButtonSelect",
    L3 = "LeftThumbstick", R3 = "RightThumbstick",
    ["DPAD UP"] = "DirectionalPadUp",
    ["DPAD DOWN"] = "DirectionalPadDown",
    ["DPAD LEFT"] = "DirectionalPadLeft",
    ["DPAD RIGHT"] = "DirectionalPadRight"
}
local function getKeyName(keyCode)
    local name = tostring(keyCode):gsub("Enum.KeyCode.", "")
    if name == "LeftControl" then return "LCTRL"
    elseif name == "RightControl" then return "RCTRL"
    elseif name == "LeftShift" then return "LSHIFT"
    elseif name == "RightShift" then return "RSHIFT"
    elseif name == "LeftAlt" then return "LALT"
    elseif name == "RightAlt" then return "RALT"
    elseif name == "ButtonA" then return "A"
    elseif name == "ButtonB" then return "B"
    elseif name == "ButtonX" then return "X"
    elseif name == "ButtonY" then return "Y"
    elseif name == "ButtonL1" then return "LB"
    elseif name == "ButtonR1" then return "RB"
    elseif name == "ButtonL2" then return "LT"
    elseif name == "ButtonR2" then return "RT"
    elseif name == "ButtonStart" then return "START"
    elseif name == "ButtonSelect" then return "SELECT"
    elseif name == "LeftThumbstick" then return "L3"
    elseif name == "RightThumbstick" then return "R3"
    elseif name == "DirectionalPadUp" then return "DPAD UP"
    elseif name == "DirectionalPadDown" then return "DPAD DOWN"
    elseif name == "DirectionalPadLeft" then return "DPAD LEFT"
    elseif name == "DirectionalPadRight" then return "DPAD RIGHT"
    end
    if #name > 6 then name = name:sub(1,6) end
    return name:upper()
end
local function saveConfig()
    local data = {
        antiBatType = antiBatBind.type,
        antiBatValue = tostring(antiBatBind.value):gsub("Enum.KeyCode.", ""),
        infJumpType = infJumpBind.type,
        infJumpValue = tostring(infJumpBind.value):gsub("Enum.KeyCode.", ""),
        guiToggleType = guiToggleBind.type,
        guiToggleValue = tostring(guiToggleBind.value):gsub("Enum.KeyCode.", ""),
        mobileMode = State.mobileMode
    }
    for attempt = 1, 3 do
        local ok = pcall(function()
            if writefile then
                writefile(CONFIG_FILE, HttpService:JSONEncode(data))
                task.wait(0.1)
                local verify = readfile(CONFIG_FILE)
                if verify and verify ~= "" then
                    return true
                end
            end
            return false
        end)
        if ok then break end
        task.wait(0.2)
    end
end
local function loadConfig()
    local raw, err = pcall(function() return readfile and readfile(CONFIG_FILE) end)
    if not raw or not err or err == "" then return end
    local ok, cfg = pcall(HttpService.JSONDecode, HttpService, err)
    if not ok or not cfg then
        pcall(function() if deletefile then deletefile(CONFIG_FILE) end end)
        return
    end
    local function getEnum(valueStr, typ)
        if typ == "controller" then
            local full = Enum.KeyCode[valueStr]
            if full and full ~= Enum.KeyCode.Unknown then
                return full
            end
            local mapped = shortToFullGamepad[valueStr]
            if mapped then
                return Enum.KeyCode[mapped]
            end
        else
            return Enum.KeyCode[valueStr]
        end
        return nil
    end
    local ab = getEnum(cfg.antiBatValue, cfg.antiBatType)
    if ab then
        antiBatBind.type = cfg.antiBatType
        antiBatBind.value = ab
    end
    local ij = getEnum(cfg.infJumpValue, cfg.infJumpType)
    if ij then
        infJumpBind.type = cfg.infJumpType
        infJumpBind.value = ij
    end
    local gt = getEnum(cfg.guiToggleValue, cfg.guiToggleType)
    if gt then
        guiToggleBind.type = cfg.guiToggleType
        guiToggleBind.value = gt
    end
    if cfg.mobileMode ~= nil then
        State.mobileMode = cfg.mobileMode
    end
end
pcall(loadConfig)
local antiBatStatus, antiBatSwitchBall, antiBatRow, antiBatRowStroke
local antiBatKeyBtn, antiBatKeyBtnStroke
local function toggleAntiBat()
    State.antiBatActive = not State.antiBatActive
    if antiBatStatus then
        antiBatStatus.Text = State.antiBatActive and "STATUS: ACTIVE" or "STATUS: DISABLED"
        antiBatStatus.TextColor3 = State.antiBatActive and C.accent1 or C.textSub
    end
    if antiBatRow and antiBatRowStroke then
        TweenService:Create(antiBatRow, TweenInfo.new(0.2), {
            BackgroundColor3 = State.antiBatActive and C.cardActive1 or C.card
        }):Play()
        TweenService:Create(antiBatRowStroke, TweenInfo.new(0.2), {
            Color = State.antiBatActive and C.accent1 or C.border
        }):Play()
    end
    if antiBatSwitchBall then
        TweenService:Create(antiBatSwitchBall, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = State.antiBatActive and UDim2.new(1, -15, 0.5, -5) or UDim2.new(0, 5, 0.5, -5),
            BackgroundColor3 = State.antiBatActive and C.text or C.dotOff,
        }):Play()
    end
    if State.antiBatActive then
        if State.antiBatThread then State.antiBatThread:Disconnect() end
        State.antiBatThread = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            if hum.MoveDirection.Magnitude <= 0 then return end
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(vel.X * 50, 50, vel.Z * 50)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, 0.05, 0)
        end)
    else
        if State.antiBatThread then
            State.antiBatThread:Disconnect()
            State.antiBatThread = nil
        end
    end
end
local infJumpStatus, infJumpSwitchBall, infJumpRow, infJumpRowStroke
local infJumpKeyBtn, infJumpKeyBtnStroke
local jumpHeld = false
local lastJumpBoostTime = 0
local JUMP_BOOST_INTERVAL = 0.05
task.spawn(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
    if pg then
        local function hookJumpButton(btn)
            if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("InfJumpHooked") then
                btn:SetAttribute("InfJumpHooked", true)
                btn.MouseButton1Down:Connect(function()
                    if State.infJumpActive then jumpHeld = true end
                end)
                btn.MouseButton1Up:Connect(function() jumpHeld = false end)
                btn.MouseLeave:Connect(function() jumpHeld = false end)
            end
        end
        for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
        pg.DescendantAdded:Connect(hookJumpButton)
    end
end)
UserInputService.JumpRequest:Connect(function()
    if State.infJumpActive then
        jumpHeld = true
        task.wait(0.05)
        jumpHeld = false
    end
end)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if State.infJumpActive and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        jumpHeld = true
    end
end)
UserInputService.InputEnded:Connect(function(inp, gpe)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        jumpHeld = false
    end
end)
local function startInfJumpLoop()
    if State.infJumpThread then State.infJumpThread:Disconnect() end
    State.infJumpThread = RunService.Stepped:Connect(function()
        if not State.infJumpActive then return end
        if not jumpHeld then return end
        local now = tick()
        if now - lastJumpBoostTime < JUMP_BOOST_INTERVAL then return end
        lastJumpBoostTime = now
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then return end
        local vel = hrp.AssemblyLinearVelocity
        if vel.Y < 55 then
            hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 65, vel.Z)
        end
    end)
end
local function stopInfJumpLoop()
    if State.infJumpThread then
        State.infJumpThread:Disconnect()
        State.infJumpThread = nil
    end
    jumpHeld = false
    lastJumpBoostTime = 0
end
local function toggleInfJump()
    State.infJumpActive = not State.infJumpActive
    if infJumpStatus then
        infJumpStatus.Text = State.infJumpActive and "STATUS: ACTIVE" or "STATUS: DISABLED"
        infJumpStatus.TextColor3 = State.infJumpActive and C.accent2 or C.textSub
    end
    if infJumpRow and infJumpRowStroke then
        TweenService:Create(infJumpRow, TweenInfo.new(0.2), {
            BackgroundColor3 = State.infJumpActive and C.cardActive2 or C.card
        }):Play()
        TweenService:Create(infJumpRowStroke, TweenInfo.new(0.2), {
            Color = State.infJumpActive and C.accent2 or C.border
        }):Play()
    end
    if infJumpSwitchBall then
        TweenService:Create(infJumpSwitchBall, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = State.infJumpActive and UDim2.new(1, -15, 0.5, -5) or UDim2.new(0, 5, 0.5, -5),
            BackgroundColor3 = State.infJumpActive and C.text or C.dotOff,
        }):Play()
    end
    if State.infJumpActive then
        startInfJumpLoop()
    else
        stopInfJumpLoop()
    end
end
local gui = Instance.new("ScreenGui")
gui.Name = "ArvexAntiBat"
gui.ResetOnSpawn = false
pcall(function()
    gui.Parent = game:GetService("CoreGui")
    if syn and syn.protect_gui then syn.protect_gui(gui) end
end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local NORMAL_SIZE = UDim2.new(0, 180, 0, 300)
local MOBILE_SIZE = UDim2.new(0, 200, 0, 155)  -- come Irish (240x175 appross)
local mainOuter = Instance.new("Frame", gui)
mainOuter.Name = "MainFrame"
mainOuter.Size = NORMAL_SIZE
mainOuter.Position = UDim2.new(0.05, 0, 0.35, 0)
mainOuter.BackgroundColor3 = C.bg
mainOuter.BackgroundTransparency = 1
mainOuter.BorderSizePixel = 0
mainOuter.ClipsDescendants = true
local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end
corner(mainOuter, 10)
local stroke = Instance.new("UIStroke", mainOuter)
stroke.Thickness = 1.2
local grad = Instance.new("UIGradient", stroke)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.accent1),
    ColorSequenceKeypoint.new(0.5, C.accent2),
    ColorSequenceKeypoint.new(1, C.accent1)
})
grad.Rotation = 45
stroke.Transparency = 0.2
local watermarkContainer = Instance.new("Frame", mainOuter)
watermarkContainer.Name = "BgImage"
watermarkContainer.Size = UDim2.new(1, 0, 1, 0)
watermarkContainer.BackgroundTransparency = 1
watermarkContainer.ZIndex = 0
local bgImage = Instance.new("ImageLabel", watermarkContainer)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://74442697488931"
bgImage.ImageTransparency = 0
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
local minBtn = Instance.new("TextButton", mainOuter)
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 20, 0, 20)
minBtn.Position = UDim2.new(1, -24, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
minBtn.BackgroundTransparency = 0.3
minBtn.BorderSizePixel = 0
minBtn.Text = "-"
minBtn.TextColor3 = C.accent1
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 14
minBtn.ZIndex = 10
corner(minBtn, 4)
local minBtnStroke = Instance.new("UIStroke", minBtn)
minBtnStroke.Color = C.border
minBtnStroke.Thickness = 1
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 45, 50)}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 30, 35)}):Play()
end)
local mobileBtn = Instance.new("TextButton", mainOuter)
mobileBtn.Name = "MobileBtn"
mobileBtn.Size = UDim2.new(0, 44, 0, 18)
mobileBtn.Position = UDim2.new(1, -72, 0, 5)
mobileBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mobileBtn.BackgroundTransparency = 0.3
mobileBtn.BorderSizePixel = 0
mobileBtn.Text = "Mobile"
mobileBtn.TextColor3 = C.textSub
mobileBtn.Font = Enum.Font.GothamBold
mobileBtn.TextSize = 7
mobileBtn.ZIndex = 10
corner(mobileBtn, 3)
local mobileBtnStroke = Instance.new("UIStroke", mobileBtn)
mobileBtnStroke.Color = C.border
mobileBtnStroke.Thickness = 1
mobileBtn.MouseEnter:Connect(function()
    TweenService:Create(mobileBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
end)
mobileBtn.MouseLeave:Connect(function()
    TweenService:Create(mobileBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
end)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0.02, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = C.bg
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "A"
toggleBtn.TextColor3 = C.accent1
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 14
toggleBtn.ZIndex = 10
toggleBtn.Visible = false
corner(toggleBtn, 8)
local toggleBtnStroke = Instance.new("UIStroke", toggleBtn)
toggleBtnStroke.Color = C.accent1
toggleBtnStroke.Thickness = 1.5
local toggleBtnGlow = Instance.new("Frame", toggleBtn)
toggleBtnGlow.Size = UDim2.new(1, 0, 1, 0)
toggleBtnGlow.BackgroundTransparency = 1
toggleBtnGlow.ZIndex = 9
local toggleBtnGlowCorner = Instance.new("UICorner", toggleBtnGlow)
toggleBtnGlowCorner.CornerRadius = UDim.new(0, 8)
local toggleBtnGlowStroke = Instance.new("UIStroke", toggleBtnGlow)
toggleBtnGlowStroke.Color = C.accent2
toggleBtnGlowStroke.Thickness = 3
toggleBtnGlowStroke.Transparency = 0.7
local mobileContent = Instance.new("Frame", mainOuter)
mobileContent.Name = "MobileContent"
mobileContent.Size = UDim2.new(1, 0, 1, 0)
mobileContent.BackgroundTransparency = 1
mobileContent.ZIndex = 2
mobileContent.Visible = false
local mobileTitle = Instance.new("TextLabel", mobileContent)
mobileTitle.Name = "MobileTitle"
mobileTitle.Size = UDim2.new(1, -50, 0, 18)
mobileTitle.Position = UDim2.new(0, 8, 0, 2)
mobileTitle.BackgroundTransparency = 1
mobileTitle.Text = "Arvex"
mobileTitle.TextColor3 = C.text
mobileTitle.Font = Enum.Font.GothamBlack
mobileTitle.TextSize = 10
mobileTitle.TextXAlignment = Enum.TextXAlignment.Left
mobileTitle.ZIndex = 3
local mobileGlow = Instance.new("Frame", mobileContent)
mobileGlow.Size = UDim2.new(0, 4, 0, 4)
mobileGlow.Position = UDim2.new(1, -14, 0, 9)
mobileGlow.BackgroundColor3 = C.accent1
mobileGlow.BorderSizePixel = 0
corner(mobileGlow, 2)
mobileGlow.ZIndex = 3
local mobAbRow = Instance.new("Frame", mobileContent)
mobAbRow.Name = "MobAbRow"
mobAbRow.Size = UDim2.new(1, -16, 0, 38)
mobAbRow.Position = UDim2.new(0, 8, 0, 24)
mobAbRow.BackgroundColor3 = C.card
mobAbRow.BackgroundTransparency = 0.5
corner(mobAbRow, 5)
local mobAbStroke = Instance.new("UIStroke", mobAbRow)
mobAbStroke.Color = C.border
mobAbStroke.Thickness = 1
mobAbRow.ZIndex = 3
local mobAbLabel = Instance.new("TextLabel", mobAbRow)
mobAbLabel.Size = UDim2.new(0.5, 0, 0, 14)
mobAbLabel.Position = UDim2.new(0, 8, 0, 4)
mobAbLabel.BackgroundTransparency = 1
mobAbLabel.Text = "Anti Bat"
mobAbLabel.TextColor3 = C.text
mobAbLabel.Font = Enum.Font.GothamBold
mobAbLabel.TextSize = 9
mobAbLabel.TextXAlignment = Enum.TextXAlignment.Left
mobAbLabel.ZIndex = 4
local mobAbStatus = Instance.new("TextLabel", mobAbRow)
mobAbStatus.Size = UDim2.new(0.5, 0, 0, 10)
mobAbStatus.Position = UDim2.new(0, 8, 0, 18)
mobAbStatus.BackgroundTransparency = 1
mobAbStatus.Text = "OFF"
mobAbStatus.TextColor3 = C.textSub
mobAbStatus.Font = Enum.Font.GothamSemibold
mobAbStatus.TextSize = 7
mobAbStatus.TextXAlignment = Enum.TextXAlignment.Left
mobAbStatus.ZIndex = 4
local mobAbPill = Instance.new("Frame", mobAbRow)
mobAbPill.Size = UDim2.new(0, 28, 0, 16)
mobAbPill.Position = UDim2.new(1, -34, 0.5, -8)
mobAbPill.BackgroundColor3 = C.pillOff
corner(mobAbPill, 8)
local mobAbPillStroke = Instance.new("UIStroke", mobAbPill)
mobAbPillStroke.Color = C.border
mobAbPill.ZIndex = 4
local mobAbBall = Instance.new("Frame", mobAbPill)
mobAbBall.Size = UDim2.new(0, 8, 0, 8)
mobAbBall.Position = UDim2.new(0, 3, 0.5, -4)
mobAbBall.BackgroundColor3 = C.dotOff
corner(mobAbBall, 4)
mobAbBall.ZIndex = 5
local mobAbBtn = Instance.new("TextButton", mobAbRow)
mobAbBtn.Size = UDim2.new(1, 0, 1, 0)
mobAbBtn.BackgroundTransparency = 1
mobAbBtn.Text = ""
mobAbBtn.ZIndex = 6
mobAbBtn.MouseButton1Click:Connect(function()
    toggleAntiBat()
    updateMobileVisuals()
end)
local mobIjRow = Instance.new("Frame", mobileContent)
mobIjRow.Name = "MobIjRow"
mobIjRow.Size = UDim2.new(1, -16, 0, 38)
mobIjRow.Position = UDim2.new(0, 8, 0, 66)
mobIjRow.BackgroundColor3 = C.card
mobIjRow.BackgroundTransparency = 0.5
corner(mobIjRow, 5)
local mobIjStroke = Instance.new("UIStroke", mobIjRow)
mobIjStroke.Color = C.border
mobIjStroke.Thickness = 1
mobIjRow.ZIndex = 3
local mobIjLabel = Instance.new("TextLabel", mobIjRow)
mobIjLabel.Size = UDim2.new(0.5, 0, 0, 14)
mobIjLabel.Position = UDim2.new(0, 8, 0, 4)
mobIjLabel.BackgroundTransparency = 1
mobIjLabel.Text = "Inf Jump"
mobIjLabel.TextColor3 = C.text
mobIjLabel.Font = Enum.Font.GothamBold
mobIjLabel.TextSize = 9
mobIjLabel.TextXAlignment = Enum.TextXAlignment.Left
mobIjLabel.ZIndex = 4
local mobIjStatus = Instance.new("TextLabel", mobIjRow)
mobIjStatus.Size = UDim2.new(0.5, 0, 0, 10)
mobIjStatus.Position = UDim2.new(0, 8, 0, 18)
mobIjStatus.BackgroundTransparency = 1
mobIjStatus.Text = "OFF"
mobIjStatus.TextColor3 = C.textSub
mobIjStatus.Font = Enum.Font.GothamSemibold
mobIjStatus.TextSize = 7
mobIjStatus.TextXAlignment = Enum.TextXAlignment.Left
mobIjStatus.ZIndex = 4
local mobIjPill = Instance.new("Frame", mobIjRow)
mobIjPill.Size = UDim2.new(0, 28, 0, 16)
mobIjPill.Position = UDim2.new(1, -34, 0.5, -8)
mobIjPill.BackgroundColor3 = C.pillOff
corner(mobIjPill, 8)
local mobIjPillStroke = Instance.new("UIStroke", mobIjPill)
mobIjPillStroke.Color = C.border
mobIjPill.ZIndex = 4
local mobIjBall = Instance.new("Frame", mobIjPill)
mobIjBall.Size = UDim2.new(0, 8, 0, 8)
mobIjBall.Position = UDim2.new(0, 3, 0.5, -4)
mobIjBall.BackgroundColor3 = C.dotOff
corner(mobIjBall, 4)
mobIjBall.ZIndex = 5
local mobIjBtn = Instance.new("TextButton", mobIjRow)
mobIjBtn.Size = UDim2.new(1, 0, 1, 0)
mobIjBtn.BackgroundTransparency = 1
mobIjBtn.Text = ""
mobIjBtn.ZIndex = 6
mobIjBtn.MouseButton1Click:Connect(function()
    toggleInfJump()
    updateMobileVisuals()
end)
local mobSaveBtn = Instance.new("TextButton", mobileContent)
mobSaveBtn.Size = UDim2.new(1, -16, 0, 22)
mobSaveBtn.Position = UDim2.new(0, 8, 0, 108)
mobSaveBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
mobSaveBtn.BorderSizePixel = 0
mobSaveBtn.Text = "Save"
mobSaveBtn.TextColor3 = C.accent1
mobSaveBtn.Font = Enum.Font.GothamBold
mobSaveBtn.TextSize = 8
corner(mobSaveBtn, 4)
local mobSaveStroke = Instance.new("UIStroke", mobSaveBtn)
mobSaveStroke.Color = C.accent1
mobSaveStroke.Thickness = 1
mobSaveBtn.ZIndex = 4
mobSaveBtn.MouseButton1Click:Connect(function()
    local ok = pcall(saveConfig)
    if ok then
        mobSaveBtn.Text = "Saved!"
        mobSaveBtn.TextColor3 = C.accent1
        task.delay(1.2, function()
            if mobSaveBtn and mobSaveBtn.Parent then
                mobSaveBtn.Text = "Save"
                mobSaveBtn.TextColor3 = C.accent1
            end
        end)
    else
        mobSaveBtn.Text = "Fail!"
        task.delay(1.2, function()
            if mobSaveBtn and mobSaveBtn.Parent then
                mobSaveBtn.Text = "Save"
            end
        end)
    end
end)
local function updateMobileVisuals()
    -- Anti Bat mobile
    if State.antiBatActive then
        mobAbStatus.Text = "ON"
        mobAbStatus.TextColor3 = C.accent1
        TweenService:Create(mobAbRow, TweenInfo.new(0.2), {BackgroundColor3 = C.cardActive1}):Play()
        TweenService:Create(mobAbStroke, TweenInfo.new(0.2), {Color = C.accent1}):Play()
        TweenService:Create(mobAbBall, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -11, 0.5, -4),
            BackgroundColor3 = C.text
        }):Play()
    else
        mobAbStatus.Text = "OFF"
        mobAbStatus.TextColor3 = C.textSub
        TweenService:Create(mobAbRow, TweenInfo.new(0.2), {BackgroundColor3 = C.card}):Play()
        TweenService:Create(mobAbStroke, TweenInfo.new(0.2), {Color = C.border}):Play()
        TweenService:Create(mobAbBall, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 3, 0.5, -4),
            BackgroundColor3 = C.dotOff
        }):Play()
    end
    -- Inf Jump mobile
    if State.infJumpActive then
        mobIjStatus.Text = "ON"
        mobIjStatus.TextColor3 = C.accent2
        TweenService:Create(mobIjRow, TweenInfo.new(0.2), {BackgroundColor3 = C.cardActive2}):Play()
        TweenService:Create(mobIjStroke, TweenInfo.new(0.2), {Color = C.accent2}):Play()
        TweenService:Create(mobIjBall, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -11, 0.5, -4),
            BackgroundColor3 = C.text
        }):Play()
    else
        mobIjStatus.Text = "OFF"
        mobIjStatus.TextColor3 = C.textSub
        TweenService:Create(mobIjRow, TweenInfo.new(0.2), {BackgroundColor3 = C.card}):Play()
        TweenService:Create(mobIjStroke, TweenInfo.new(0.2), {Color = C.border}):Play()
        TweenService:Create(mobIjBall, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 3, 0.5, -4),
            BackgroundColor3 = C.dotOff
        }):Play()
    end
end
local function setMobileMode(enabled)
    State.mobileMode = enabled
    if enabled then
        TweenService:Create(mainOuter, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = MOBILE_SIZE
        }):Play()
        watermarkContainer.Visible = true
        title.Visible = false
        glow.Visible = false
        antiBatRow.Visible = false
        infJumpRow.Visible = false
        toggleRow.Visible = false
        saveRow.Visible = false
        mobileContent.Visible = true
        mobileBtn.TextColor3 = C.accent1
        mobileBtnStroke.Color = C.accent1
        updateMobileVisuals()
    else
        TweenService:Create(mainOuter, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = NORMAL_SIZE
        }):Play()
        watermarkContainer.Visible = true
        title.Visible = true
        glow.Visible = true
        antiBatRow.Visible = true
        infJumpRow.Visible = true
        toggleRow.Visible = true
        saveRow.Visible = true
        mobileContent.Visible = false
        mobileBtn.TextColor3 = C.textSub
        mobileBtnStroke.Color = C.border
    end
    saveConfig()
end
local function minimizeGUI()
    mainOuter.Visible = false
    toggleBtn.Visible = true
    toggleBtn.Position = mainOuter.Position
    State.guiVisible = false
end
local function restoreGUI()
    mainOuter.Visible = true
    toggleBtn.Visible = false
    State.guiVisible = true
end
minBtn.MouseButton1Click:Connect(minimizeGUI)
toggleBtn.MouseButton1Click:Connect(restoreGUI)
mobileBtn.MouseButton1Click:Connect(function()
    setMobileMode(not State.mobileMode)
end)
local dragToggle = {}
toggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragToggle.active = true
        dragToggle.start = inp.Position
        dragToggle.startPos = toggleBtn.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragToggle.active = false end
        end)
    end
end)
toggleBtn.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        dragToggle.input = inp
    end
end)
UIS.InputChanged:Connect(function(inp)
    if inp == dragToggle.input and dragToggle.active then
        local delta = inp.Position - dragToggle.start
        toggleBtn.Position = UDim2.new(dragToggle.startPos.X.Scale, dragToggle.startPos.X.Offset + delta.X, dragToggle.startPos.Y.Scale, dragToggle.startPos.Y.Offset + delta.Y)
    end
end)
local drag = {}
mainOuter.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        drag.active = true
        drag.start = inp.Position
        drag.startPos = mainOuter.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then drag.active = false end
        end)
    end
end)
mainOuter.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        drag.input = inp
    end
end)
UIS.InputChanged:Connect(function(inp)
    if inp == drag.input and drag.active then
        local delta = inp.Position - drag.start
        mainOuter.Position = UDim2.new(drag.startPos.X.Scale, drag.startPos.X.Offset + delta.X, drag.startPos.Y.Scale, drag.startPos.Y.Offset + delta.Y)
    end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/OpBrairnotV2/Ui_Library/refs/heads/main/Ui.lua"))()
local title = Instance.new("TextLabel", mainOuter)
title.Size = UDim2.new(1, -50, 0, 26)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Arvex Anti Bat"
title.TextColor3 = C.text
title.Font = Enum.Font.GothamBlack
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2
local glow = Instance.new("Frame", mainOuter)
glow.Size = UDim2.new(0, 4, 0, 4)
glow.Position = UDim2.new(1, -12, 0, 11)
glow.BackgroundColor3 = C.accent1
glow.BorderSizePixel = 0
corner(glow, 2)
glow.ZIndex = 2
antiBatRow = Instance.new("Frame", mainOuter)
antiBatRow.Size = UDim2.new(1, -16, 0, 62)
antiBatRow.Position = UDim2.new(0, 8, 0, 30)
antiBatRow.BackgroundColor3 = C.card
antiBatRow.BackgroundTransparency = 0.6
corner(antiBatRow, 6)
antiBatRowStroke = Instance.new("UIStroke", antiBatRow)
antiBatRowStroke.Color = C.border
antiBatRow.ZIndex = 2
local abRowBtn = Instance.new("TextButton", antiBatRow)
abRowBtn.Size = UDim2.new(1, 0, 1, 0)
abRowBtn.BackgroundTransparency = 1
abRowBtn.Text = ""
abRowBtn.ZIndex = 2
abRowBtn.MouseButton1Click:Connect(toggleAntiBat)
local abLabel = Instance.new("TextLabel", antiBatRow)
abLabel.Size = UDim2.new(1, -70, 0, 14)
abLabel.Position = UDim2.new(0, 8, 0, 5)
abLabel.BackgroundTransparency = 1
abLabel.Text = "Anti Bat"
abLabel.TextColor3 = C.text
abLabel.Font = Enum.Font.GothamBold
abLabel.TextSize = 10
abLabel.TextXAlignment = Enum.TextXAlignment.Left
abLabel.ZIndex = 2
antiBatStatus = Instance.new("TextLabel", antiBatRow)
antiBatStatus.Size = UDim2.new(1, -70, 0, 11)
antiBatStatus.Position = UDim2.new(0, 8, 0, 20)
antiBatStatus.BackgroundTransparency = 1
antiBatStatus.Text = "STATUS: DISABLED"
antiBatStatus.TextColor3 = C.textSub
antiBatStatus.Font = Enum.Font.GothamSemibold
antiBatStatus.TextSize = 8
antiBatStatus.TextXAlignment = Enum.TextXAlignment.Left
antiBatStatus.ZIndex = 2
local pill = Instance.new("Frame", antiBatRow)
pill.Size = UDim2.new(0, 32, 0, 18)
pill.Position = UDim2.new(1, -38, 0.5, -9)
pill.BackgroundColor3 = C.pillOff
corner(pill, 9)
local pillStroke = Instance.new("UIStroke", pill)
pillStroke.Color = C.border
pill.ZIndex = 2
antiBatSwitchBall = Instance.new("Frame", pill)
antiBatSwitchBall.Size = UDim2.new(0, 9, 0, 9)
antiBatSwitchBall.Position = UDim2.new(0, 4, 0.5, -4.5)
antiBatSwitchBall.BackgroundColor3 = C.dotOff
corner(antiBatSwitchBall, 4.5)
antiBatSwitchBall.ZIndex = 2
local keyChip = Instance.new("Frame", antiBatRow)
keyChip.Size = UDim2.new(1, -16, 0, 16)
keyChip.Position = UDim2.new(0, 8, 0, 40)
keyChip.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
keyChip.BackgroundTransparency = 0.5
keyChip.BorderSizePixel = 0
keyChip.ZIndex = 2
corner(keyChip, 3)
local chipStroke = Instance.new("UIStroke", keyChip)
chipStroke.Color = C.border
local keyLabel = Instance.new("TextLabel", keyChip)
keyLabel.Size = UDim2.new(0, 28, 1, 0)
keyLabel.Position = UDim2.new(0, 4, 0, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "KEY:"
keyLabel.TextColor3 = C.textSub
keyLabel.Font = Enum.Font.GothamSemibold
keyLabel.TextSize = 7
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.ZIndex = 2
antiBatKeyBtn = Instance.new("TextButton", keyChip)
antiBatKeyBtn.Size = UDim2.new(0, 40, 1, -2)
antiBatKeyBtn.Position = UDim2.new(0, 32, 0, 1)
antiBatKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
antiBatKeyBtn.BorderSizePixel = 0
antiBatKeyBtn.Text = getKeyName(antiBatBind.value)
antiBatKeyBtn.TextColor3 = C.accent1
antiBatKeyBtn.Font = Enum.Font.GothamBold
antiBatKeyBtn.TextSize = 7
antiBatKeyBtn.ZIndex = 3
corner(antiBatKeyBtn, 2)
antiBatKeyBtnStroke = Instance.new("UIStroke", antiBatKeyBtn)
antiBatKeyBtnStroke.Color = C.accent1
infJumpRow = Instance.new("Frame", mainOuter)
infJumpRow.Size = UDim2.new(1, -16, 0, 62)
infJumpRow.Position = UDim2.new(0, 8, 0, 98)
infJumpRow.BackgroundColor3 = C.card
infJumpRow.BackgroundTransparency = 0.6
corner(infJumpRow, 6)
infJumpRowStroke = Instance.new("UIStroke", infJumpRow)
infJumpRowStroke.Color = C.border
infJumpRow.ZIndex = 2
local ijRowBtn = Instance.new("TextButton", infJumpRow)
ijRowBtn.Size = UDim2.new(1, 0, 1, 0)
ijRowBtn.BackgroundTransparency = 1
ijRowBtn.Text = ""
ijRowBtn.ZIndex = 2
ijRowBtn.MouseButton1Click:Connect(toggleInfJump)
local ijLabel = Instance.new("TextLabel", infJumpRow)
ijLabel.Size = UDim2.new(1, -70, 0, 14)
ijLabel.Position = UDim2.new(0, 8, 0, 5)
ijLabel.BackgroundTransparency = 1
ijLabel.Text = "Inf Jump"
ijLabel.TextColor3 = C.text
ijLabel.Font = Enum.Font.GothamBold
ijLabel.TextSize = 10
ijLabel.TextXAlignment = Enum.TextXAlignment.Left
ijLabel.ZIndex = 2
infJumpStatus = Instance.new("TextLabel", infJumpRow)
infJumpStatus.Size = UDim2.new(1, -70, 0, 11)
infJumpStatus.Position = UDim2.new(0, 8, 0, 20)
infJumpStatus.BackgroundTransparency = 1
infJumpStatus.Text = "STATUS: DISABLED"
infJumpStatus.TextColor3 = C.textSub
infJumpStatus.Font = Enum.Font.GothamSemibold
infJumpStatus.TextSize = 8
infJumpStatus.TextXAlignment = Enum.TextXAlignment.Left
infJumpStatus.ZIndex = 2
local pill2 = Instance.new("Frame", infJumpRow)
pill2.Size = UDim2.new(0, 32, 0, 18)
pill2.Position = UDim2.new(1, -38, 0.5, -9)
pill2.BackgroundColor3 = C.pillOff
corner(pill2, 9)
local pillStroke2 = Instance.new("UIStroke", pill2)
pillStroke2.Color = C.border
pill2.ZIndex = 2
infJumpSwitchBall = Instance.new("Frame", pill2)
infJumpSwitchBall.Size = UDim2.new(0, 9, 0, 9)
infJumpSwitchBall.Position = UDim2.new(0, 4, 0.5, -4.5)
infJumpSwitchBall.BackgroundColor3 = C.dotOff
corner(infJumpSwitchBall, 4.5)
infJumpSwitchBall.ZIndex = 2
local keyChip2 = Instance.new("Frame", infJumpRow)
keyChip2.Size = UDim2.new(1, -16, 0, 16)
keyChip2.Position = UDim2.new(0, 8, 0, 40)
keyChip2.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
keyChip2.BackgroundTransparency = 0.5
keyChip2.BorderSizePixel = 0
keyChip2.ZIndex = 2
corner(keyChip2, 3)
local chipStroke2 = Instance.new("UIStroke", keyChip2)
chipStroke2.Color = C.border
local keyLabel2 = Instance.new("TextLabel", keyChip2)
keyLabel2.Size = UDim2.new(0, 28, 1, 0)
keyLabel2.Position = UDim2.new(0, 4, 0, 0)
keyLabel2.BackgroundTransparency = 1
keyLabel2.Text = "KEY:"
keyLabel2.TextColor3 = C.textSub
keyLabel2.Font = Enum.Font.GothamSemibold
keyLabel2.TextSize = 7
keyLabel2.TextXAlignment = Enum.TextXAlignment.Left
keyLabel2.ZIndex = 2
infJumpKeyBtn = Instance.new("TextButton", keyChip2)
infJumpKeyBtn.Size = UDim2.new(0, 40, 1, -2)
infJumpKeyBtn.Position = UDim2.new(0, 32, 0, 1)
infJumpKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
infJumpKeyBtn.BorderSizePixel = 0
infJumpKeyBtn.Text = getKeyName(infJumpBind.value)
infJumpKeyBtn.TextColor3 = C.accent2
infJumpKeyBtn.Font = Enum.Font.GothamBold
infJumpKeyBtn.TextSize = 7
infJumpKeyBtn.ZIndex = 3
corner(infJumpKeyBtn, 2)
infJumpKeyBtnStroke = Instance.new("UIStroke", infJumpKeyBtn)
infJumpKeyBtnStroke.Color = C.accent2
local toggleRow = Instance.new("Frame", mainOuter)
toggleRow.Size = UDim2.new(1, -16, 0, 44)
toggleRow.Position = UDim2.new(0, 8, 0, 166)
toggleRow.BackgroundColor3 = C.card
toggleRow.BackgroundTransparency = 0.6
corner(toggleRow, 6)
local toggleRowStroke = Instance.new("UIStroke", toggleRow)
toggleRowStroke.Color = C.border
toggleRow.ZIndex = 2
local toggleLabel = Instance.new("TextLabel", toggleRow)
toggleLabel.Size = UDim2.new(1, -80, 0, 14)
toggleLabel.Position = UDim2.new(0, 8, 0, 5)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "GUI Toggle"
toggleLabel.TextColor3 = C.text
toggleLabel.Font = Enum.Font.GothamBold
toggleLabel.TextSize = 10
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.ZIndex = 2
local toggleSub = Instance.new("TextLabel", toggleRow)
toggleSub.Size = UDim2.new(1, -80, 0, 11)
toggleSub.Position = UDim2.new(0, 8, 0, 19)
toggleSub.BackgroundTransparency = 1
toggleSub.Text = "Click to rebind"
toggleSub.TextColor3 = C.textSub
toggleSub.Font = Enum.Font.GothamSemibold
toggleSub.TextSize = 7
toggleSub.TextXAlignment = Enum.TextXAlignment.Left
toggleSub.ZIndex = 2
local toggleKeyBtn = Instance.new("TextButton", toggleRow)
toggleKeyBtn.Size = UDim2.new(0, 54, 0, 18)
toggleKeyBtn.Position = UDim2.new(1, -62, 0.5, -9)
toggleKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
toggleKeyBtn.BorderSizePixel = 0
toggleKeyBtn.Text = getKeyName(guiToggleBind.value)
toggleKeyBtn.TextColor3 = C.accent1
toggleKeyBtn.Font = Enum.Font.GothamBold
toggleKeyBtn.TextSize = 7
toggleKeyBtn.ZIndex = 2
corner(toggleKeyBtn, 3)
local toggleKeyBtnStroke = Instance.new("UIStroke", toggleKeyBtn)
toggleKeyBtnStroke.Color = C.accent1
local saveRow = Instance.new("Frame", mainOuter)
saveRow.Size = UDim2.new(1, -16, 0, 38)
saveRow.Position = UDim2.new(0, 8, 0, 216)
saveRow.BackgroundColor3 = C.card
saveRow.BackgroundTransparency = 0.6
corner(saveRow, 6)
local saveRowStroke = Instance.new("UIStroke", saveRow)
saveRowStroke.Color = C.border
saveRow.ZIndex = 2
local saveBtn = Instance.new("TextButton", saveRow)
saveBtn.Size = UDim2.new(1, -16, 0, 24)
saveBtn.Position = UDim2.new(0, 8, 0.5, -12)
saveBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
saveBtn.BorderSizePixel = 0
saveBtn.Text = "Save"
saveBtn.TextColor3 = C.accent1
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 9
corner(saveBtn, 4)
local saveBtnStroke = Instance.new("UIStroke", saveBtn)
saveBtnStroke.Color = C.accent1
saveBtn.ZIndex = 2
local function flashSaveButton(success)
    local originalText = saveBtn.Text
    if success then
        saveBtn.Text = "Saved!"
        saveBtn.TextColor3 = C.accent1
        saveBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
        saveBtnStroke.Color = C.accent1
    else
        saveBtn.Text = "Fail!"
        saveBtn.TextColor3 = C.accent2
        saveBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
        saveBtnStroke.Color = C.accent2
    end
    task.delay(1.5, function()
        if saveBtn and saveBtn.Parent then
            saveBtn.Text = originalText
            saveBtn.TextColor3 = C.accent1
            saveBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            saveBtnStroke.Color = C.accent1
        end
    end)
end
saveBtn.MouseButton1Click:Connect(function()
    local ok = pcall(saveConfig)
    flashSaveButton(ok)
end)
saveBtn.MouseEnter:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(38, 38, 46)}):Play()
end)
saveBtn.MouseLeave:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()
end)
local listeningAB = false
local listeningIJ = false
local listeningGT = false
local function updateAllButtons()
    antiBatKeyBtn.Text = getKeyName(antiBatBind.value)
    infJumpKeyBtn.Text = getKeyName(infJumpBind.value)
    toggleKeyBtn.Text = getKeyName(guiToggleBind.value)
end
antiBatKeyBtn.MouseButton1Click:Connect(function()
    if listeningAB then return end
    listeningAB = true
    antiBatKeyBtn.Text = "..."
    antiBatKeyBtn.TextColor3 = C.accent2
    antiBatKeyBtnStroke.Color = C.accent2
    local conn
    conn = UIS.InputBegan:Connect(function(inp, gpe)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            antiBatBind = { type = "keyboard", value = inp.KeyCode }
            updateAllButtons()
            antiBatKeyBtn.TextColor3 = C.accent1
            antiBatKeyBtnStroke.Color = C.accent1
            listeningAB = false
            saveConfig()
        elseif inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2 then
            if inp.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            antiBatBind = { type = "controller", value = inp.KeyCode }
            updateAllButtons()
            antiBatKeyBtn.TextColor3 = C.accent1
            antiBatKeyBtnStroke.Color = C.accent1
            listeningAB = false
            saveConfig()
        end
    end)
end)
infJumpKeyBtn.MouseButton1Click:Connect(function()
    if listeningIJ then return end
    listeningIJ = true
    infJumpKeyBtn.Text = "..."
    infJumpKeyBtn.TextColor3 = C.accent2
    infJumpKeyBtnStroke.Color = C.accent2
    local conn
    conn = UIS.InputBegan:Connect(function(inp, gpe)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            infJumpBind = { type = "keyboard", value = inp.KeyCode }
            updateAllButtons()
            infJumpKeyBtn.TextColor3 = C.accent2
            infJumpKeyBtnStroke.Color = C.accent2
            listeningIJ = false
            saveConfig()
        elseif inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2 then
            if inp.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            infJumpBind = { type = "controller", value = inp.KeyCode }
            updateAllButtons()
            infJumpKeyBtn.TextColor3 = C.accent2
            infJumpKeyBtnStroke.Color = C.accent2
            listeningIJ = false
            saveConfig()
        end
    end)
end)
toggleKeyBtn.MouseButton1Click:Connect(function()
    if listeningGT then return end
    listeningGT = true
    toggleKeyBtn.Text = "..."
    toggleKeyBtn.TextColor3 = C.accent2
    toggleKeyBtnStroke.Color = C.accent2
    toggleSub.Text = "Press any..."
    local conn
    conn = UIS.InputBegan:Connect(function(inp, gpe)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            guiToggleBind = { type = "keyboard", value = inp.KeyCode }
            updateAllButtons()
            toggleKeyBtn.TextColor3 = C.accent1
            toggleKeyBtnStroke.Color = C.accent1
            toggleSub.Text = "Click to rebind"
            listeningGT = false
            saveConfig()
        elseif inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2 then
            if inp.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            guiToggleBind = { type = "controller", value = inp.KeyCode }
            updateAllButtons()
            toggleKeyBtn.TextColor3 = C.accent1
            toggleKeyBtnStroke.Color = C.accent1
            toggleSub.Text = "Click to rebind"
            listeningGT = false
            saveConfig()
        end
    end)
end)
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if listeningAB or listeningIJ or listeningGT then return end
    if antiBatBind.type == "keyboard" and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == antiBatBind.value then
        toggleAntiBat()
    elseif antiBatBind.type == "controller" and (inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2) and inp.KeyCode == antiBatBind.value then
        toggleAntiBat()
    end
    if infJumpBind.type == "keyboard" and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == infJumpBind.value then
        toggleInfJump()
    elseif infJumpBind.type == "controller" and (inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2) and inp.KeyCode == infJumpBind.value then
        toggleInfJump()
    end
    if guiToggleBind.type == "keyboard" and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == guiToggleBind.value then
        if State.guiVisible then
            minimizeGUI()
        else
            restoreGUI()
        end
    elseif guiToggleBind.type == "controller" and (inp.UserInputType == Enum.UserInputType.Gamepad1 or inp.UserInputType == Enum.UserInputType.Gamepad2) and inp.KeyCode == guiToggleBind.value then
        if State.guiVisible then
            minimizeGUI()
        else
            restoreGUI()
        end
    end
end)
if State.mobileMode then
    task.delay(0.5, function()
        setMobileMode(true)
    end)
end
print("GreenDuels loaded -- Minimize (-), Mobile toggle, and Restore button ready!")