local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local wasCarrying = false
local currentUI = nil

-- 1. Check if player is carrying an item
local function isCarrying()
    local char = LocalPlayer.Character
    if not char then return false end
    
    for _, child in pairs(char:GetChildren()) do
        local name = child.Name:lower()
        if name:find("brainrot") or name:find("brain") or name:find("animal") or 
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end
    
    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = attrName:lower()
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or 
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end
    
    return false
end

-- 2. UI Creation with Millisecond Timer
local function startE01HeadCountdown()
    -- Delete old UI
    if currentUI then
        currentUI:Destroy()
        currentUI = nil
    end
    
    -- Wait for PlayerGui
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- ====== SCREENGUI ======
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "E01_WarningUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    currentUI = screenGui
    
    -- ====== MAIN FRAME ======
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 80)
    frame.Position = UDim2.new(0.5, -250, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    -- Border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    stroke.Parent = frame
    
    -- ====== MAIN TEXT ======
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 40)
    textLabel.Position = UDim2.new(0, 10, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.Text = "Dont go in their base now while stealing or you will get kicked by E01"
    textLabel.Parent = frame
    
    -- ====== SUBTEXT (MILLISECOND TIMER) ======
    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, -20, 0, 20)
    subText.Position = UDim2.new(0, 10, 0, 48)
    subText.BackgroundTransparency = 1
    subText.TextColor3 = Color3.fromRGB(255, 200, 0)
    subText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    subText.TextStrokeTransparency = 0
    subText.Font = Enum.Font.SourceSans
    subText.TextSize = 14
    subText.TextXAlignment = Enum.TextXAlignment.Center
    subText.Text = "⏳ 3.00 SECONDS REMAINING"
    subText.Parent = frame
    
    -- ====== PROGRESS BAR ======
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = frame
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = progressBar
    
    -- ====== COUNTDOWN WITH MILLISECONDS ======
    local duration = 3.0
    local startTime = tick()
    local finished = false
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        if finished or not frame.Parent then 
            if connection then connection:Disconnect() end
            return 
        end
        
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        local progress = 1 - (remaining / duration)
        
        -- Update progress bar
        progressBar.Size = UDim2.new(progress, 0, 0, 3)
        
        -- Update colors
        if progress < 0.33 then
            progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            stroke.Color = Color3.fromRGB(255, 0, 0)
        elseif progress < 0.66 then
            progressBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            stroke.Color = Color3.fromRGB(255, 200, 0)
        else
            progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            stroke.Color = Color3.fromRGB(0, 255, 100)
        end
        
        if remaining > 0 then
            -- Still in warning - SHOW MILLISECONDS
            textLabel.Text = "🚫 Dont go in their base now while stealing or you will get kicked by E01"
            textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            
            -- MILLISECOND TIMER: Shows 2 decimal places (e.g., "2.45 SECONDS REMAINING")
            subText.Text = string.format("⏳ %.2f SECONDS REMAINING", remaining)
            subText.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            -- SAFE STATE - CHANGE TEXT
            finished = true
            if connection then connection:Disconnect() end
            
            textLabel.Text = "✅ You can now steal the brainrot without getting kicked"
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            subText.Text = "⚡ STEAL NOW! ⚡"
            subText.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            stroke.Color = Color3.fromRGB(0, 255, 100)
            progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            progressBar.Size = UDim2.new(1, 0, 0, 3)
            
            -- Bounce effect
            local bounce = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 520, 0, 85)
            })
            bounce:Play()
            
            task.wait(0.3)
            local bounceBack = TweenService:Create(frame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 500, 0, 80)
            })
            bounceBack:Play()
            
            -- Destroy after 3 seconds
            task.wait(3)
            if screenGui then
                screenGui:Destroy()
                currentUI = nil
            end
        end
    end)
end

-- 3. Automatic Detection
task.spawn(function()
    while task.wait(0.1) do
        local currentlyCarrying = isCarrying()
        
        if not wasCarrying and currentlyCarrying then
            startE01HeadCountdown()
        end
        
        wasCarrying = currentlyCarrying
    end
end)