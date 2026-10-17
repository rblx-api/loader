local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local desyncActive = false
local function enableMobileDesync()
    local success, error = pcall(function()
        local backpack = LocalPlayer:WaitForChild("Backpack")
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local packages = ReplicatedStorage:WaitForChild("Packages", 5)
        if not packages then warn("Packages not found") return false end
        local netFolder = packages:WaitForChild("Net", 5)
        if not netFolder then warn("Net folder not found") return false end
        local useItemRemote = netFolder:WaitForChild("RE/UseItem", 5)
        local teleportRemote = netFolder:WaitForChild("RE/QuantumCloner/OnTeleport", 5)
        if not useItemRemote or not teleportRemote then warn("Remotes not found") return false end
        local toolNames = {"Quantum Cloner", "Brainrot", "brainrot"}
        local tool
        for _, toolName in ipairs(toolNames) do
            tool = backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
            if tool then break end
        end
        if not tool then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then tool=item break end
            end
        end
        if tool and tool.Parent==backpack then
            humanoid:EquipTool(tool)
            task.wait(0.5)
        end
        if setfflag then setfflag("WorldStepMax", "-9999999999") end
        task.wait(0.2)
        useItemRemote:FireServer()
        task.wait(1)
        teleportRemote:FireServer()
        task.wait(2)
        if setfflag then setfflag("WorldStepMax", "-1") end
        return true
    end)
    if not success then
        warn("Error activating desync: " .. tostring(error))
        return false
    end
    return success
end
local function disableMobileDesync()
    pcall(function()
        if setfflag then setfflag("WorldStepMax", "-1") end
    end)
end
local success = enableMobileDesync()
if success then
    desyncActive = true
end
LocalPlayer.CharacterAdded:Connect(function()
    desyncActive = false
    disableMobileDesync()
end)
local GoToBestEnabled = false
local GoToBestConnections = {}
local currentBestPetFTB = nil
local isStoppingFTB = false
local hasFlownUpFTB = false
local lastEquipTimeFTB = 0
local lastSpamTimeFTB = 0
local lastScanTimeFTB = 0
local baseCoordinatesFTB = {
    ["Base 1"] = Vector3.new(-479.5, 17.4, -103.1),
    ["Base 2"] = Vector3.new(-339.8, 17.4, -98.5),
    ["Base 3"] = Vector3.new(-340.3, 17.4, 6.0),
    ["Base 4"] = Vector3.new(-340.0, 17.4, 113.1),
    ["Base 5"] = Vector3.new(-339.7, 17.0, 221.8),
    ["Base 6"] = Vector3.new(-479.3, 17.4, 218.5),
    ["Base 7"] = Vector3.new(-478.5, 17.4, 116.3),
    ["Base 8"] = Vector3.new(-478.2, 17.4, 5.8)
}
local function extractValueFTB(text)
    if not text then return 0 end
    local clean = text:gsub("[%$,/s]", ""):gsub(",", "")
    local mult = 1
    if clean:match("[kK]") then
        mult = 1e3
        clean = clean:gsub("[kK]", "")
    elseif clean:match("[mM]") then
        mult = 1e6
        clean = clean:gsub("[mM]", "")
    elseif clean:match("[bB]") then
        mult = 1e9
        clean = clean:gsub("[bB]", "")
    elseif clean:match("[tT]") then
        mult = 1e12
        clean = clean:gsub("[tT]", "")
    end
    local num = tonumber(clean)
    return num and num * mult or 0
end
local function findClosestBaseFTB(petPosition)
    local closestBase = nil
    local closestDistance = math.huge
    local closestBaseCoord = nil
    for baseName, baseCoord in pairs(baseCoordinatesFTB) do
        local distance = (petPosition - baseCoord).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestBase = baseName
            closestBaseCoord = baseCoord
        end
    end
    return closestBase, closestBaseCoord
end
local function findMostExpensiveBrainrotFTB()
    if isStoppingFTB then return nil end
    local allPets = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isStoppingFTB then break end
        if obj.Name == "AnimalOverhead" then
            local petValue = 0
            local petName = "Brainrot"
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("TextLabel") then
                    local text = child.Text
                    if text and text:find("$") and text:find("/s") then
                        petValue = extractValueFTB(text)
                    end
                    if child.Name == "DisplayName" and text ~= "" then
                        petName = text
                    end
                end
            end
            local position = nil
            local current = obj.Parent
            while current and current ~= Workspace do
                if current:IsA("BasePart") then
                    position = current.Position
                    break
                end
                current = current.Parent
            end
            if position and petValue > 0 then
                local closestBaseName, closestBaseCoord = findClosestBaseFTB(position)
                table.insert(allPets, {
                    position = position,
                    name = petName,
                    value = petValue,
                    baseName = closestBaseName,
                    basePosition = closestBaseCoord
                })
            end
        end
    end
    if #allPets > 0 and not isStoppingFTB then
        table.sort(allPets, function(a, b)
            return a.value > b.value
        end)
        local bestPet = allPets[1]
        return bestPet
    end
    return nil
end
local function flyUpFirstFTB()
    if isStoppingFTB then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local startTime = tick()
    local targetHeight = 20
    while tick() - startTime < 1.5 and not isStoppingFTB do
        local currentY = hrp.Position.Y
        if currentY < targetHeight then
            local upPos = Vector3.new(hrp.Position.X, targetHeight, hrp.Position.Z)
            local direction = (upPos - hrp.Position).Unit
            hrp.AssemblyLinearVelocity = direction * 40
        else
            break
        end
        task.wait(0.1)
    end
    hasFlownUpFTB = true
end
local function equipGrappleHookFTB()
    if isStoppingFTB then return nil end
    local now = tick()
    if now - lastEquipTimeFTB < 2 then return nil end
    local char = player.Character
    if not char then return nil end
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return nil end
    local grappleHook = backpack:FindFirstChild("Grapple Hook") or char:FindFirstChild("Grapple Hook")
    if not grappleHook then return nil end
    if grappleHook.Parent == backpack then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(grappleHook)
            lastEquipTimeFTB = now
        end
    end
    return grappleHook
end
local function spamGrappleHookFTB()
    if isStoppingFTB then return end
    local now = tick()
    if now - lastSpamTimeFTB < 0.2 then return end
    local REUseItem = ReplicatedStorage:FindFirstChild("Packages")
    if REUseItem then
        REUseItem = REUseItem:FindFirstChild("Net")
        if REUseItem then
            REUseItem = REUseItem:FindFirstChild("RE/UseItem")
            if REUseItem then
                pcall(function()
                    REUseItem:FireServer(0.23450689315795897)
                    lastSpamTimeFTB = now
                end)
            end
        end
    end
end
local function flyToPositionFTB(targetPos, speed)
    if isStoppingFTB then return 0 end
    local char = player.Character
    if not char then return 0 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    local direction = (targetPos - hrp.Position).Unit
    hrp.AssemblyLinearVelocity = direction * speed
    local distance = (hrp.Position - targetPos).Magnitude
    return distance
end
local function stabilizePlayerFTB()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end
local function cleanStopFTB()
    isStoppingFTB = true
    stabilizePlayerFTB()
    for name, conn in pairs(GoToBestConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    GoToBestConnections = {}
    currentBestPetFTB = nil
    hasFlownUpFTB = false
    lastEquipTimeFTB = 0
    lastSpamTimeFTB = 0
    lastScanTimeFTB = 0
    isStoppingFTB = false
end
local function autoDisableFTB()
    if GoToBestEnabled then
        GoToBestEnabled = false
        cleanStopFTB()
        if flyButton then
            flyActive = false
            flyButton.BackgroundColor3 = ROXO_ESCURO
        end
        print("ðŸš€ Fly to Best DESATIVADO automaticamente!")
    end
end
local function startGoToBestFTB()
    isStoppingFTB = false
    hasFlownUpFTB = false
    lastEquipTimeFTB = 0
    lastSpamTimeFTB = 0
    lastScanTimeFTB = 0
    cleanStopFTB()
    task.spawn(function()
        flyUpFirstFTB()
        if not isStoppingFTB then
            currentBestPetFTB = findMostExpensiveBrainrotFTB()
            if currentBestPetFTB then
                print("ðŸ§  Brainrot encontrado! Base: " .. currentBestPetFTB.baseName)
            end
        end
    end)
    GoToBestConnections.movement = RunService.Heartbeat:Connect(function()
        if isStoppingFTB or not GoToBestEnabled then 
            return 
        end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local now = tick()
        if now - lastEquipTimeFTB >= 2 then
            equipGrappleHookFTB()
        end
        if now - lastSpamTimeFTB >= 0.2 then
            spamGrappleHookFTB()
        end
        if not hasFlownUpFTB and hrp.Position.Y < 15 then
            local upPos = Vector3.new(hrp.Position.X, 20, hrp.Position.Z)
            flyToPositionFTB(upPos, 40)
            return
        end
        local shouldScan = false
        if now - lastScanTimeFTB >= 3 then
            shouldScan = true
            lastScanTimeFTB = now
        end
        if currentBestPetFTB and currentBestPetFTB.basePosition then
            local targetPos = currentBestPetFTB.basePosition
            local distance = (hrp.Position - targetPos).Magnitude
            local speed = 120
            if distance < 15 then speed = 60 end
            if distance < 8 then speed = 30 end
            flyToPositionFTB(targetPos, speed)
            if distance < 3 then
                stabilizePlayerFTB()
                print("âœ… Chegou na base: " .. currentBestPetFTB.baseName)
                autoDisableFTB()
                return
            end
            if distance < 8 or shouldScan then
                task.spawn(function()
                    if not isStoppingFTB then
                        currentBestPetFTB = findMostExpensiveBrainrotFTB()
                    end
                end)
            end
        else
            if shouldScan and not isStoppingFTB then
                currentBestPetFTB = findMostExpensiveBrainrotFTB()
            end
            if not currentBestPetFTB then
                stabilizePlayerFTB()
            end
        end
    end)
end
local function activateFlyToBest()
    if not GoToBestEnabled then
        GoToBestEnabled = true
        startGoToBestFTB()
        print("ðŸš€ Fly to Best ATIVADO!")
    end
end
local function activateFlyTpBest()
    if not hasFlyingCarpet() then
        print("âŒ SLEYTR HUB: VocÃª nÃ£o tem o Flying Carpet no backpack!")
        print("ðŸ’¡ Use o modo Fly To Best (nÃ£o requer Flying Carpet)")
        local originalText = flyButton.Text
        flyButton.Text = "NO CARPET!"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(2)
        if flyButton then
            flyButton.Text = originalText
            flyButton.BackgroundColor3 = ROXO_ESCURO
        end
        flyActive = false
        return
    end
    if not GoToBestHub.Enabled then
        GoToBestHub:Toggle()
        print("ðŸš€ Fly TP Best ATIVADO! (Flying Carpet detectado)")
    end
end
local function deactivateFly()
    if flyMode == 2 and GoToBestHub.Enabled then
        GoToBestHub:Toggle()
    elseif flyMode == 1 and GoToBestEnabled then
        GoToBestEnabled = false
        cleanStopFTB()
        print("ðŸš€ Fly to Best DESATIVADO!")
    end
end
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local LocalPlayer = Players.LocalPlayer
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local teleportLoop = nil
	local mataPlayerAtivo = false
	local currentTarget = nil
	local function getEnemyPlayer()
		if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			return nil
		end
		local closest, distance = nil, math.huge
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local part = player.Character.HumanoidRootPart
				local mag = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				if mag < distance then
					distance = mag
					closest = player
				end
			end
		end
		return closest
	end
	local function equipWebSlinger()
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		local webSlinger = nil
		if backpack then
			webSlinger = backpack:FindFirstChild("Web Slinger")
		end
		if not webSlinger and LocalPlayer.Character then
			webSlinger = LocalPlayer.Character:FindFirstChild("Web Slinger")
		end
		if webSlinger and webSlinger.Parent == backpack then
			LocalPlayer.Character.Humanoid:EquipTool(webSlinger)
			return true
		elseif webSlinger and webSlinger.Parent == LocalPlayer.Character then
			return true
		end
		return false
	end
	local function executeAimbot()
		if not equipWebSlinger() then
			return false, nil
		end
		task.wait(0.1)
		local enemy = getEnemyPlayer()
		if not enemy then
			return false, nil
		end
		local targetPosition = enemy.Character.HumanoidRootPart.Position
		local args = {
			[1] = targetPosition,
			[2] = enemy.Character.HumanoidRootPart
		}
		local success = pcall(function()
			ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
		end)
		if success then
			return true, enemy
		else
			return false, nil
		end
	end
	local function startTeleportLoop(target)
		if not target or not target.Character then 
			return 
		end
		local hrp = target.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		if teleportLoop then 
			teleportLoop:Disconnect() 
		end
		local above = true
		teleportLoop = RunService.Heartbeat:Connect(function()
			if target and target.Character and hrp and hrp.Parent and target ~= LocalPlayer then
				-- Teleporta o inimigo alternando entre +20 e -20 de altura
				if above then
					hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 20, 0))
				else
					hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, -20, 0))
				end
				above = not above
			else
				if teleportLoop then
					teleportLoop:Disconnect()
					teleportLoop = nil
				end
			end
			task.wait(0.5)
		end)
	end
	local function stopTeleportLoop()
		if teleportLoop then
			teleportLoop:Disconnect()
			teleportLoop = nil
			currentTarget = nil
		end
	end
	local function startMataPlayer()
		mataPlayerAtivo = true
		local enemy = getEnemyPlayer()
		if enemy then
			-- Primeiro executa o aimbot
			local aimbotSuccess, target = executeAimbot()
			-- Se o aimbot funcionou, inicia o teleporte
			if aimbotSuccess then
				task.wait(0.5)
				startTeleportLoop(target)
				mataPlayerBtn.ImageColor3 = Color3.fromRGB(0, 255, 110)
				mataPlayerBtn:FindFirstChild("TextLabel").Text = "MATA PLAYER ON"
			else
				mataPlayerAtivo = false
				mataPlayerBtn.ImageColor3 = IMAGE_ROXO
				mataPlayerBtn:FindFirstChild("TextLabel").Text = "MATA PLAYER"
			end
		else
			mataPlayerAtivo = false
			mataPlayerBtn.ImageColor3 = IMAGE_ROXO
			mataPlayerBtn:FindFirstChild("TextLabel").Text = "MATA PLAYER"
		end
	end
	local function stopMataPlayer()
		mataPlayerAtivo = false
		stopTeleportLoop()
		mataPlayerBtn.ImageColor3 = IMAGE_ROXO
		mataPlayerBtn:FindFirstChild("TextLabel").Text = "MATA PLAYER"
	end
	-- Conectar ao botÃ£o MATA PLAYER
	mataPlayerBtn.MouseButton1Click:Connect(function()
		if mataPlayerAtivo then
			stopMataPlayer()
		else
			startMataPlayer()
		end
	end)
	-- ProteÃ§Ã£o extra
	LocalPlayer.CharacterAdded:Connect(function()
		stopMataPlayer()
	end)
end
local ESPBest = {}
ESPBest.currentESP = nil
ESPBest.connection = nil
ESPBest.active = false
function ESPBest:extractValue(text)
	if not text then return 0 end
	local clean = text:gsub("[%$,/s]", ""):gsub(",", ".")
	local mult = 1
	if clean:match("[kK]") then
		mult = 1e3
		clean = clean:gsub("[kK]", "")
	elseif clean:match("[mM]") then
		mult = 1e6
		clean = clean:gsub("[mM]", "")
	elseif clean:match("[bB]") then
		mult = 1e9
		clean = clean:gsub("[bB]", "")
	elseif clean:match("[tT]") then
		mult = 1e12
		clean = clean:gsub("[tT]", "")
	end
	local num = tonumber(clean)
	return num and num * mult or 0
end
function ESPBest:shorten(num)
	if num >= 1e12 then
		local value = num / 1e12
		if value % 1 == 0 then
			return string.format("%.0fT", value)
		else
			return string.format("%.1fT", value):gsub("%.", ",")
		end
	elseif num >= 1e9 then
		local value = num / 1e9
		if value % 1 == 0 then
			return string.format("%.0fB", value)
		else
			return string.format("%.1fB", value):gsub("%.", ",")
		end
	elseif num >= 1e6 then
		local value = num / 1e6
		if value % 1 == 0 then
			return string.format("%.0fM", value)
		else
			return string.format("%.1fM", value):gsub("%.", ",")
		end
	elseif num >= 1e3 then
		local value = num / 1e3
		if value % 1 == 0 then
			return string.format("%.0fK", value)
		else
			return string.format("%.1fK", value):gsub("%.", ",")
		end
	else
		return tostring(math.floor(num))
	end
end
function ESPBest:createESP(part, name, value)
	if self.currentESP then 
		self.currentESP:Destroy()
		self.currentESP = nil
	end
	local billboard = Instance.new("BillboardGui")
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 450, 0, 80)
	billboard.StudsOffset = Vector3.new(0, 4, 0)
	billboard.Adornee = part
	billboard.Parent = part
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 45)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
	nameLa