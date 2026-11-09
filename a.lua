-- discord.gg/vonhub

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local platform
local platformEnabled = false
local rising = false
local riseSpeed = 10
local platformHeight = 5

local function createPlatform()
	if platform then
		platform:Destroy()
	end

	platform = Instance.new("Part")
	platform.Name = "FollowPlatform"
	platform.Size = Vector3.new(12, 1, 12)
	platform.Anchored = true
	platform.CanCollide = true
	platform.Material = Enum.Material.SmoothPlastic
	platform.Color = Color3.fromRGB(0, 170, 255)

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if root then
		platform.Position = root.Position - Vector3.new(0, platformHeight, 0)
	end

	platform.Parent = workspace
end

local function togglePlatform()
	platformEnabled = not platformEnabled

	if platformEnabled then
		createPlatform()
	else
		rising = false
		if platform then
			platform:Destroy()
			platform = nil
		end
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.P then
		togglePlatform()
	elseif input.KeyCode == Enum.KeyCode.R then
		if platformEnabled then
			rising = not rising
		end
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not platformEnabled or not platform or not platform.Parent then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	local pos = platform.Position

	local newY = pos.Y
	if rising then
		newY = newY + riseSpeed * dt
	end

	platform.Position = Vector3.new(root.Position.X, newY, root.Position.Z)
end)

player.CharacterAdded:Connect(function()
	if platformEnabled then
		task.wait(1)
		createPlatform()
	end
end)