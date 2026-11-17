-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 2078943144805
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"Alezz_0909"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Animate = Character:FindFirstChild("Animate")
if Animate then
    -- Idle animations
    local idle = Animate:FindFirstChild("idle")
    if idle then
        local anim1 = idle:FindFirstChild("Animation1")
        if anim1 then anim1.AnimationId = "http://www.roblox.com/asset/?id=122257458498464" end
        local anim2 = idle:FindFirstChild("Animation2")
        if anim2 then anim2.AnimationId = "http://www.roblox.com/asset/?id=102357151005774" end
    end
    -- Walk animation
    local walk = Animate:FindFirstChild("walk")
    if walk then
        local walkAnim = walk:FindFirstChild("WalkAnim")
        if walkAnim then walkAnim.AnimationId = "http://www.roblox.com/asset/?id=122150855457006" end
    end
    -- Run animation
    local run = Animate:FindFirstChild("run")
    if run then
        local runAnim = run:FindFirstChild("RunAnim")
        if runAnim then runAnim.AnimationId = "http://www.roblox.com/asset/?id=82598234841035" end
    end
    -- Jump animation
    local jump = Animate:FindFirstChild("jump")
    if jump then
        local jumpAnim = jump:FindFirstChild("JumpAnim")
        if jumpAnim then jumpAnim.AnimationId = "http://www.roblox.com/asset/?id=75290611992385" end
    end
    -- Fall animation
    local fall = Animate:FindFirstChild("fall")
    if fall then
        local fallAnim = fall:FindFirstChild("FallAnim")
        if fallAnim then fallAnim.AnimationId = "http://www.roblox.com/asset/?id=98600215928904" end
    end
    -- Climb animation
    local climb = Animate:FindFirstChild("climb")
    if climb then
        local climbAnim = climb:FindFirstChild("ClimbAnim")
        if climbAnim then climbAnim.AnimationId = "http://www.roblox.com/asset/?id=109346520324160" end
    end
    -- Swim animation (laissée vide ou par défaut)
    local swim = Animate:FindFirstChild("swim")
    -- Pas d'ID spécifique dans les logs
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TigyVelocityToggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 130, 0, 50)
TextButton.Position = UDim2.new(0.05, 0, 0.8, 0)
TextButton.BackgroundColor3 = Color3.new(0.27451, 0.470588, 1)
TextButton.Text = "Enable Move"
TextButton.Font = Enum.Font.GothamBold
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextScaled = true
TextButton.AutoButtonColor = false
TextButton.Parent = ScreenGui
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 10)
UICornerBtn.Parent = TextButton
local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Thickness = 2
UIStrokeBtn.Color = Color3.new(0.392157, 0.588235, 1)
UIStrokeBtn.Parent = TextButton
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 60, 0, 50)
TextBox.Position = UDim2.new(0.05, 140, 0.8, 0)
TextBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.PlaceholderText = "25"
TextBox.Text = ""
TextBox.Font = Enum.Font.GothamBold
TextBox.TextScaled = true
TextBox.ClearTextOnFocus = false
TextBox.Parent = ScreenGui
local UICornerTxt = Instance.new("UICorner")
UICornerTxt.CornerRadius = UDim.new(0, 10)
UICornerTxt.Parent = TextBox
local UIStrokeTxt = Instance.new("UIStroke")
UIStrokeTxt.Thickness = 2
UIStrokeTxt.Color = Color3.new(0.27451, 0.27451, 0.27451)
UIStrokeTxt.Parent = TextBox
local enabled = false
local speedValue = 25  -- valeur par défaut
local heartbeatConnection = nil
local function applyVelocity()
    if not enabled or not Character or not Humanoid or not HumanoidRootPart then return end
    local moveDirection = Humanoid.MoveDirection
    if moveDirection.Magnitude > 0 then
        local newVelocity = moveDirection * speedValue
        -- Conserver la vélocité verticale actuelle (gravité)
        newVelocity = Vector3.new(newVelocity.X, HumanoidRootPart.Velocity.Y, newVelocity.Z)
        HumanoidRootPart.Velocity = newVelocity
    end
end
local function setEnabled(state)
    enabled = state
    if enabled then
        TextButton.Text = "Disable Move"
        TextButton.BackgroundColor3 = Color3.new(1, 0.27451, 0.27451)
        UIStrokeBtn.Color = Color3.new(1, 0.392157, 0.392157)
        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(applyVelocity)
        end
    else
        TextButton.Text = "Enable Move"
        TextButton.BackgroundColor3 = Color3.new(0.27451, 0.470588, 1)
        UIStrokeBtn.Color = Color3.new(0.392157, 0.588235, 1)
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
    end
end
TextButton.MouseButton1Click:Connect(function()
    setEnabled(not enabled)
end)
TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(TextBox.Text)
        if num and num > 0 then
            speedValue = num
        else
            TextBox.Text = tostring(speedValue)
        end
    end
end)
TextBox.Text = tostring(speedValue)
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    -- Réappliquer les animations si nécessaire (optionnel)
    local newAnimate = Character:FindFirstChild("Animate")
    if newAnimate then
        -- On pourrait re-modifier les animations, mais c'est déjà fait globalement ?
        -- Par simplicité, on laisse le script original modifier les animations une seule fois.
    end
    if enabled then
        -- Recréer la connexion si elle existait
        if heartbeatConnection then heartbeatConnection:Disconnect() end
        heartbeatConnection = RunService.Heartbeat:Connect(applyVelocity)
    end
end)
print("[TigySpeedBoost] Script chargé avec succès.")