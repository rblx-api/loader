-- AMP Hub + Clean Bat Bypass (default bind: N; configurable in Keybinds)
print("[AMP] Loading...")
-- AMP Hub: red, white and black GUI; AMP floating-letter intro; no Discord reporting.
-- Use only in experiences you own or have permission to test.
-- The GUI no longer waits for a game-specific Plots folder.
-- Original game-specific features still require their original objects/tools.
-- Background uses the supplied IMG_1068 Discord image through a cached custom asset.
-- Steal bar uses the same image background as the GUI; categories remain in the left sidebar.
-- Intro visibility gate affects only the AMP menu, never game interfaces.
local ampIntroPresentation = {active = true, menus = {}}
function ampIntroPresentation.hide(menu)
    if not ampIntroPresentation.active then return end
    local entry = {menu = menu, enabled = menu.Enabled}
    ampIntroPresentation.menus[#ampIntroPresentation.menus + 1] = entry
    menu.Enabled = false
    entry.connection = menu:GetPropertyChangedSignal("Enabled"):Connect(function()
        if ampIntroPresentation.active and menu.Enabled then menu.Enabled = false end
    end)
end
function ampIntroPresentation.finish()
    if not ampIntroPresentation.active then return end
    ampIntroPresentation.active = false
    for _, entry in ipairs(ampIntroPresentation.menus) do
        if entry.connection then entry.connection:Disconnect() end
        pcall(function() entry.menu.Enabled = entry.enabled end)
    end
    ampIntroPresentation.menus = {}
end
task.delay(12, ampIntroPresentation.finish)
-- Clean-style silver balloon letters, rebranded for AMP; presentation only.
do
    task.spawn(function()
        local players = game:GetService("Players")
        local tweens = game:GetService("TweenService")
        local run = game:GetService("RunService")
        local input = game:GetService("UserInputService")
        local player = players.LocalPlayer
        if not player then ampIntroPresentation.finish(); return end
        local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 5)
        if not playerGui then ampIntroPresentation.finish(); return end
        local coreGui
        pcall(function() coreGui = game:GetService("CoreGui") end)
        for _, parent in ipairs(coreGui and {coreGui, playerGui} or {playerGui}) do
            local old = parent:FindFirstChild("AmpLettersIntro")
            if old then old:Destroy() end
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("ScreenGui") and child.Name == "AMP DUELS" then
                    ampIntroPresentation.hide(child)
                end
            end
        end
        local gui = Instance.new("ScreenGui")
        gui.Name = "AmpLettersIntro"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 100000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(gui) end
        end)
        if not pcall(function() gui.Parent = coreGui or playerGui end) then
            gui.Parent = playerGui
        end
        task.delay(12, function()
            if gui.Parent then gui:Destroy() end
            ampIntroPresentation.finish()
        end)
        local shade = Instance.new("Frame", gui)
        shade.Size = UDim2.fromScale(1, 1)
        shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shade.BackgroundTransparency = 0.12
        shade.BorderSizePixel = 0
        shade.Active = true
        shade.ZIndex = 1
        local letters, connections = {}, {}
        local closed, sound, heldInput, holdStart = false, nil, nil, nil
        local start = os.clock()
        local word = "AMP HUB"
        local crops = {{21, 88, 104, 134}, {125, 88, 103, 134}, {232, 88, 88, 134},
            {343, 88, 93, 134}, {436, 88, 89, 134}, {527, 88, 93, 134}}
        local camera = workspace.CurrentCamera
        local width = camera and camera.ViewportSize.X or 640
        local spacing = math.min(58, math.max(27, (width - 70) / 7))
        local function close()
            if closed then return end
            closed = true
            for _, connection in ipairs(connections) do connection:Disconnect() end
            if sound then sound:Destroy(); sound = nil end
            if not gui.Parent then ampIntroPresentation.finish(); return end
            tweens:Create(shade, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            for _, entry in ipairs(letters) do
                tweens:Create(entry.label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                tweens:Create(entry.image, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
            end
            task.delay(0.34, function()
                gui:Destroy()
                ampIntroPresentation.finish()
            end)
        end
        for i = 1, #word do
            local character = word:sub(i, i)
            if character ~= " " then
                local label = Instance.new("TextLabel", gui)
                label.Name = "AmpIntroLetter_" .. i
                label.AnchorPoint = Vector2.new(0.5, 0.5)
                label.Size = UDim2.fromOffset(spacing * 1.45, spacing * 1.85)
                label.Position = UDim2.new(0.5, (i - 4) * spacing, 0.5, -18)
                label.BackgroundTransparency = 1
                label.Text = character
                label.Font = Enum.Font.GothamBlack
                label.TextSize = math.min(52, spacing)
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeColor3 = Color3.fromRGB(180, 25, 35)
                label.TextStrokeTransparency = 0.45
                label.TextTransparency = 1
                label.ZIndex = 3
                local image = Instance.new("ImageLabel", gui)
                image.Name = "AmpBalloon_" .. character
                image.AnchorPoint = label.AnchorPoint
                image.Size = label.Size
                image.Position = label.Position
                image.BackgroundTransparency = 1
                image.ScaleType = Enum.ScaleType.Fit
                image.ImageTransparency = 1
                image.ZIndex = 3
                local crop = crops[#letters + 1]
                image.ImageRectOffset = Vector2.new(crop[1], crop[2])
                image.ImageRectSize = Vector2.new(crop[3], crop[4])
                letters[#letters + 1] = {label = label, image = image, base = label.Position, index = i}
                task.delay((i - 1) * 0.07, function()
                    if closed or not label.Parent then return end
                    tweens:Create(label, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                end)
            end
        end
        local hint = Instance.new("TextLabel", gui)
        hint.Size = UDim2.new(1, -48, 0, 26)
        hint.Position = UDim2.fromOffset(24, 58)
        hint.BackgroundTransparency = 1
        hint.Text = "Hold anywhere for 1 second to skip"
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.Font = Enum.Font.Gotham
        hint.TextSize = 13
        hint.TextColor3 = Color3.fromRGB(220, 220, 220)
        hint.ZIndex = 4
        local fill = Instance.new("Frame", gui)
        fill.AnchorPoint = Vector2.new(0, 0)
        fill.Position = UDim2.fromOffset(24, 87)
        fill.Size = UDim2.fromOffset(0, 2)
        fill.BackgroundColor3 = Color3.fromRGB(220, 40, 50)
        fill.BorderSizePixel = 0
        fill.ZIndex = 4
        connections[#connections + 1] = input.InputBegan:Connect(function(event)
            if closed or heldInput then return end
            if event.UserInputType == Enum.UserInputType.Touch or event.UserInputType == Enum.UserInputType.MouseButton1 then
                heldInput, holdStart = event, os.clock()
            end
        end)
        connections[#connections + 1] = input.InputEnded:Connect(function(event)
            if event == heldInput then
                heldInput, holdStart = nil, nil
                fill.Size = UDim2.fromOffset(0, 2)
            end
        end)
        connections[#connections + 1] = input.WindowFocusReleased:Connect(function()
            heldInput, holdStart = nil, nil
            fill.Size = UDim2.fromOffset(0, 2)
        end)
        connections[#connections + 1] = gui.Destroying:Connect(close)
        connections[#connections + 1] = run.RenderStepped:Connect(function()
            if closed then return end
            local elapsed = os.clock() - start
            for _, entry in ipairs(letters) do
                local phase = elapsed * 2.5 + entry.index * 1.37
                entry.label.Position = entry.base + UDim2.fromOffset(math.sin(phase) * 18, math.cos(phase * 1.5) * 22)
                entry.label.Rotation = math.sin(phase * 0.72) * 7
                entry.image.Position = entry.label.Position
                entry.image.Rotation = entry.label.Rotation
            end
            if holdStart then
                local progress = math.clamp((os.clock() - holdStart) / 1.0, 0, 1)
                fill.Size = UDim2.fromOffset(120 * progress, 2)
                if progress >= 1 then close() end
            end
        end)
        -- Embedded compact artwork; no network request is needed for balloons.
        task.spawn(function()
            local assetLoader = getcustomasset or getsynasset or getasset
            if type(assetLoader) ~= "function" or type(writefile) ~= "function" then return end
            local ok, asset = pcall(function()
                local file = "amp_balloon_letters_v4.png"
                if not (type(isfile) == "function" and isfile(file)) then
                    local encoded = [=[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EolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIJBKJRCKRSCQSiUQikUgkEolEIpFIfhz5/wO1FYUpHuzCDAAAAABJRU5ErkJggg==]=]
                    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                    local lookup = {}
                    for i = 1, #alphabet do lookup[alphabet:byte(i)] = i - 1 end
                    local chunks = {}
                    for offset = 1, #encoded, 4096 do
                        if closed then return nil end
                        local bytes = {}
                        for i = offset, math.min(offset + 4095, #encoded), 4 do
                            local a, b = lookup[encoded:byte(i)] or 0, lookup[encoded:byte(i + 1)] or 0
                            local c, d = lookup[encoded:byte(i + 2)] or 0, lookup[encoded:byte(i + 3)] or 0
                            local value = a * 262144 + b * 4096 + c * 64 + d
                            bytes[#bytes + 1] = string.char(math.floor(value / 65536) % 256)
                            if encoded:sub(i + 2, i + 2) ~= "=" then bytes[#bytes + 1] = string.char(math.floor(value / 256) % 256) end
                            if encoded:sub(i + 3, i + 3) ~= "=" then bytes[#bytes + 1] = string.char(value % 256) end
                        end
                        chunks[#chunks + 1] = table.concat(bytes)
                        task.wait()
                    end
                    if closed then return nil end
                    writefile(file, table.concat(chunks))
                end
                return assetLoader(file)
            end)
            if closed or not ok or type(asset) ~= "string" or asset == "" then return end
            for _, entry in ipairs(letters) do entry.image.Image = asset end
            -- Keep the readable fallback until the local image is actually ready.
            local deadline = os.clock() + 4
            while not closed and os.clock() < deadline do
                if letters[1] and letters[1].image.IsLoaded then
                    for _, entry in ipairs(letters) do
                        entry.label.TextTransparency = 1
                        entry.image.ImageTransparency = 0
                    end
                    return
                end
                task.wait(0.05)
            end
        end)
        -- Audio loads independently so downloads never delay the letters or AMP.
        task.spawn(function()
            local assetLoader = getcustomasset or getsynasset or getasset
            if type(assetLoader) ~= "function" or type(writefile) ~= "function" then return end
            local ok, asset = pcall(function()
                -- Uploaded Tesla mix, pre-trimmed to original timestamps 18–26 seconds.
                local file = "amphub_tesla_intro_18_26_v5.mp3"
                if not (type(isfile) == "function" and isfile(file)) then
                    local encoded = [=[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]=]
                    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                    local lookup, chunks = {}, {}
                    for i = 1, #alphabet do lookup[alphabet:byte(i)] = i - 1 end
                    for offset = 1, #encoded, 4096 do
                        local bytes = {}
                        for i = offset, math.min(offset + 4095, #encoded), 4 do
                            local a, b = lookup[encoded:byte(i)] or 0, lookup[encoded:byte(i + 1)] or 0
                            local c, d = lookup[encoded:byte(i + 2)] or 0, lookup[encoded:byte(i + 3)] or 0
                            local value = a * 262144 + b * 4096 + c * 64 + d
                            bytes[#bytes + 1] = string.char(math.floor(value / 65536) % 256)
                            if encoded:sub(i + 2, i + 2) ~= "=" then bytes[#bytes + 1] = string.char(math.floor(value / 256) % 256) end
                            if encoded:sub(i + 3, i + 3) ~= "=" then bytes[#bytes + 1] = string.char(value % 256) end
                        end
                        chunks[#chunks + 1] = table.concat(bytes)
                    end
                    if closed then return nil end
                    writefile(file, table.concat(chunks))
                end
                return assetLoader(file)
            end)
            if closed or not ok or type(asset) ~= "string" or asset == "" then return end
            sound = Instance.new("Sound")
            sound.Name = "AmpIntroSong"
            sound.SoundId = asset
            sound.Volume = 1
            sound.Looped = false
            sound.Parent = game:GetService("SoundService")
            connections[#connections + 1] = sound.Ended:Connect(close)
            -- Wait for decoding before playback so the eight-second excerpt is not shortened.
            local audioDeadline = os.clock() + 3
            while not closed and sound and not sound.IsLoaded and os.clock() < audioDeadline do
                task.wait(0.05)
            end
            if closed or not sound then return end
            pcall(function()
                sound.TimePosition = 0
                sound:Play()
            end)
            task.delay(8, function()
                if not closed then close() end
            end)
        end)
        task.delay(10, close)
    end)
end

local AMP_BACKGROUND_ASSET_ID = ""
local AMP_BACKGROUND_URL =
	"https://cdn.discordapp.com/attachments/1528223526685904926/1560160346445193277/IMG_1068.jpg?ex=6ad1b40c&is=6ad0628c&hm=a9d4f96a2d7bffd8bfa690aaa38532ac314b0575cde349875de4b0a72f03240c&"

local ampBackgroundCache
local function resolveAmpBackground()
	if ampBackgroundCache then
		return ampBackgroundCache
	end
	if AMP_BACKGROUND_ASSET_ID ~= "" then
		ampBackgroundCache = AMP_BACKGROUND_ASSET_ID
		return ampBackgroundCache
	end
	local registerAsset = getcustomasset or getsynasset
	if type(registerAsset) == "function" and type(writefile) == "function" then
		local ok, asset = pcall(function()
			local path = "AmpDuels_background_IMG_1068_v1.jpg"
			if not (isfile and isfile(path)) then
				writefile(path, game:HttpGet(AMP_BACKGROUND_URL))
			end
			return registerAsset(path)
		end)
		if ok and type(asset) == "string" and asset ~= "" then
			ampBackgroundCache = asset
			return asset
		end
	end
	warn("[AMP Duels] Background unavailable: set AMP_BACKGROUND_ASSET_ID to an uploaded Roblox image.")
	ampBackgroundCache = ""
	return ""
end

pcall(function()
	print("[AMP Duels] Booting...")
end)
if _G.AmpDuelsRunning then
	pcall(function()
		print("[AMP Duels] Already running — forcing reload")
	end)
	_G.AmpDuelsRunning = false
	task.wait(0.05)
end
_G.AmpDuelsRunning = true
repeat
	task.wait()
until game:IsLoaded()
pcall(function()
	print("[AMP Duels] Game loaded, building...")
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera
local function _safeJSONEncode(tbl)
	local ok, str = pcall(function()
		return HS:JSONEncode(tbl)
	end)
	if ok then
		return str
	end
	return "{}"
end
local function _safeJSONDecode(str)
	local ok, data = pcall(function()
		return HS:JSONDecode(str)
	end)
	if ok and type(data) == "table" then
		return data
	end
	return {}
end
safeJSONEncode = _safeJSONEncode
safeJSONDecode = _safeJSONDecode
local _tick = tick
local _clamp = math.clamp
local _floor = math.floor
local _abs = math.abs
local _huge = math.huge
local _sqrt = math.sqrt
local _V3new = Vector3.new
local _V3zero = Vector3.zero
local _CFnew = CFrame.new
local _CFlookAt = CFrame.lookAt
local _RayParams_new = RaycastParams.new
local _GetPlayersCached
do
	local cache, cacheTime = nil, 0
	_GetPlayersCached = function()
		local now = _tick()
		if cache and now - cacheTime < 0.03 then
			return cache
		end
		cache = Players:GetPlayers()
		cacheTime = now
		return cache
	end
end
local function waitForCharReady(char, timeout)
	timeout = timeout or 5
	local deadline = _tick() + timeout
	while
		not char
		or not char.Parent
		or (not char:FindFirstChild("HumanoidRootPart"))
		or (not char:FindFirstChildOfClass("Humanoid"))
	do
		if _tick() > deadline then
			return false
		end
		task.wait(0.05)
	end
	return true
end
NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 60
BYPASS_AIMBOT_SPEED = 60
-- Clean Bat Bypass replaces AMP's old aimbot engines.
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
CONFIG_FILE = "AmpDuels.json"
BAT_V2_HIT_DIST = 5.5
_isDraggingButton = false
backgroundIndex = 1
backgroundImages = { resolveAmpBackground() }
backgroundImageTransparency = 0
floatingButtonScale = 1
stealBarScale = 1
_floatingUIScales = {}
local CarrySystem = {
	normalSpeed = NS,
	carrySpeed = CS,
	laggerSpeed = LAGGER_SPEED,
	laggerCarrySpeed = LAGGER_CARRY_SPEED,
	speedToggled = false,
	laggerMode = 0,
	softStealEnabled = false,
	softStealRadius = 10,
	softStealSpeed = 30,
	softStealLatched = false,
	_isCarrying = false,
	_lastCarryCheck = 0,
	_lvBoost = nil,
	_lvAtt = nil,
	_blockedTime = 0,
	_maxForce = 2200,
	_freeForce = 500,
	_heartbeatConn = nil,
	_softStealScanner = nil,
	_softStealAnimals = {},
	_softStealScanning = false,
	_state = nil,
	_dropInProgress = false,
	_batAimbotToggled = false,
	_rayParams = nil,
	_rayFilter = nil,
	_rayFilterTime = 0,
}
function CarrySystem:isCarrying()
	local now = _tick()
	if now - (self._lastCarryCheck or 0) < 0.1 then
		return self._isCarrying
	end
	self._lastCarryCheck = now
	local char = LP.Character
	if not char then
		self._isCarrying = false
		return false
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local ws = hum and hum.WalkSpeed or 16
	local bySpeed = (ws < 25 and ws > 0)
	local byAttr = false
	local ok, v = pcall(function()
		return LP:GetAttribute("Stealing")
	end)
	if ok and v == true then
		byAttr = true
	end
	local ok2, v2 = pcall(function()
		return char:GetAttribute("Stealing")
	end)
	if ok2 and v2 == true then
		byAttr = true
	end
	if not byAttr then
		for _, name in ipairs({ "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }) do
			local obj = char:FindFirstChild(name)
			if obj then
				if
					(obj:IsA("BoolValue") and obj.Value)
					or (obj:IsA("ObjectValue") and obj.Value)
					or (obj:IsA("StringValue") and obj.Value ~= "")
				then
					byAttr = true
					break
				end
			end
		end
	end
	self._isCarrying = bySpeed or byAttr
	return self._isCarrying
end
function CarrySystem:getActiveSpeed()
	if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
		return self.normalSpeed
	end
	if self.softStealEnabled then
		local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
		local inRange = dist and dist <= self.softStealRadius
		if inRange then
			self.softStealLatched = true
			return self.softStealSpeed
		end
		if self.softStealLatched and self:isCarrying() then
			return self.softStealSpeed
		else
			self.softStealLatched = false
		end
	end
	if self.laggerMode == 1 then
		return self.laggerSpeed
	end
	if self.laggerMode == 2 then
		return self.laggerCarrySpeed
	end
	if self.speedToggled then
		return self.carrySpeed
	end
	return self.normalSpeed
end
function CarrySystem:getStatus()
	if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
		return "NORMAL", self.normalSpeed
	end
	if self.softStealEnabled then
		local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
		local inRange = dist and dist <= self.softStealRadius
		if inRange or (self.softStealLatched and self:isCarrying()) then
			return "AUTO CARRY", self.softStealSpeed
		end
	end
	if self.laggerMode == 1 then
		return "LAGGER", self.laggerSpeed
	end
	if self.laggerMode == 2 then
		return "LAGGER CARRY", self.laggerCarrySpeed
	end
	if self.speedToggled then
		return "CARRY", self.carrySpeed
	end
	return "NORMAL", self.normalSpeed
end
local function destroyLV()
	if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent then
		pcall(function()
			CarrySystem._lvBoost:Destroy()
		end)
	end
	if CarrySystem._lvAtt and CarrySystem._lvAtt.Parent then
		pcall(function()
			CarrySystem._lvAtt:Destroy()
		end)
	end
	CarrySystem._lvBoost = nil
	CarrySystem._lvAtt = nil
end
local function setupLV(hrp)
	if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent == hrp then
		return
	end
	destroyLV()
	local att = Instance.new("Attachment")
	att.Parent = hrp
	local lv = Instance.new("LinearVelocity")
	lv.Name = "CarryBoostLV"
	lv.Attachment0 = att
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
	lv.PrimaryTangentAxis = _V3new(1, 0, 0)
	lv.SecondaryTangentAxis = _V3new(0, 0, 1)
	lv.MaxForce = CarrySystem._maxForce
	lv.PlaneVelocity = Vector2.zero
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.Parent = hrp
	CarrySystem._lvAtt = att
	CarrySystem._lvBoost = lv
	pcall(function()
		hrp:SetNetworkOwner(LP)
	end)
end
function CarrySystem:scanSoftStealAnimals()
	self._softStealAnimals = {}
	local plots = Workspace:FindFirstChild("Plots")
	if not plots then
		return
	end
	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") then
			local podiums = plot:FindFirstChild("AnimalPodiums")
			if podiums then
				for _, podium in ipairs(podiums:GetChildren()) do
					if podium:IsA("Model") then
						local base = podium:FindFirstChild("Base")
						local spawn = base and base:FindFirstChild("Spawn")
						if spawn then
							table.insert(
								self._softStealAnimals,
								{
									plot = plot.Name,
									slot = podium.Name,
									worldPosition = spawn.Position,
									uid = plot.Name .. "_" .. podium.Name,
								}
							)
						end
					end
				end
			end
		end
	end
end
function CarrySystem:startSoftStealScanner()
	if self._softStealScanner then
		return
	end
	self._softStealScanning = true
	self:scanSoftStealAnimals()
	self._softStealScanner = RunService.Heartbeat:Connect(function()
		if not self._softStealScanning then
			return
		end
		self:scanSoftStealAnimals()
	end)
end
function CarrySystem:stopSoftStealScanner()
	self._softStealScanning = false
	if self._softStealScanner then
		self._softStealScanner:Disconnect()
		self._softStealScanner = nil
	end
end
function CarrySystem:getNearestSoftStealAnimal(radius)
	local char = LP.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
	if not root then
		return nil, _huge
	end
	local best, bestDist = nil, _huge
	local animals = self._softStealAnimals
	local rpos = root.Position
	for i = 1, #animals do
		local data = animals[i]
		if data.worldPosition then
			local dx = rpos.X - data.worldPosition.X
			local dy = rpos.Y - data.worldPosition.Y
			local dz = rpos.Z - data.worldPosition.Z
			local dist = _sqrt(dx * dx + dy * dy + dz * dz)
			if dist < bestDist then
				best = data
				bestDist = dist
			end
		end
	end
	if radius and bestDist > radius then
		return nil, bestDist
	end
	return best, bestDist
end
function CarrySystem:updateMovement(dt)
	local char = LP.Character
	if not char then
		return
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then
		return
	end
	local speed = self:getActiveSpeed()
	local moveDir = hum.MoveDirection
	local moving = moveDir.Magnitude > 0.1
	local wallNormalFlat = nil
	if moving then
		if not self._rayParams then
			self._rayParams = _RayParams_new()
			self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
			self._rayFilter = {}
			self._rayFilterTime = 0
		end
		local now = _tick()
		if now - self._rayFilterTime > 1 then
			self._rayFilterTime = now
			local filter = self._rayFilter
			while #filter > 0 do
				filter[#filter] = nil
			end
			filter[1] = char
			local plist = _GetPlayersCached()
			for i = 1, #plist do
				local p = plist[i]
				if p.Character then
					filter[#filter + 1] = p.Character
				end
			end
			self._rayParams.FilterDescendantsInstances = filter
		else
			local filter = self._rayFilter
			local found = false
			for i = 1, #filter do
				if filter[i] == char then
					found = true
					break
				end
			end
			if not found then
				filter[1] = char
				self._rayParams.FilterDescendantsInstances = filter
			end
		end
		local flatDir = _V3new(moveDir.X, 0, moveDir.Z).Unit
		local hit = Workspace:Raycast(hrp.Position + _V3new(0, 1, 0), flatDir * 2.5, self._rayParams)
		if hit and hit.Instance and hit.Instance.CanCollide then
			local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
			if nf.Magnitude > 0.7 then
				wallNormalFlat = nf.Unit
			end
		end
	end
	local hVel = _V3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
	local blocked = wallNormalFlat ~= nil or (moving and hVel.Magnitude < 2)
	if blocked then
		for _, model in ipairs(char:GetChildren()) do
			if model:IsA("Model") then
				for _, part in ipairs(model:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end
		for _, name in ipairs({ "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }) do
			local v = char:FindFirstChild(name)
			if v and v:IsA("ObjectValue") and v.Value and v.Value:IsA("Model") then
				for _, part in ipairs(v.Value:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end
	end
	local state = hum:GetState()
	local ragdolled = state == Enum.HumanoidStateType.Physics
		or state == Enum.HumanoidStateType.Ragdoll
		or state == Enum.HumanoidStateType.FallingDown
	local moverBlocked = ragdolled or self._dropInProgress or self._batAimbotToggled
	if not moverBlocked then
		if not CarrySystem._lvBoost or CarrySystem._lvBoost.Parent ~= hrp then
			setupLV(hrp)
		end
		local lv = CarrySystem._lvBoost
		if lv then
			if not lv.Enabled then
				lv.Enabled = true
			end
			if moveDir.Magnitude > 0.1 then
				local flat = _V3new(moveDir.X, 0, moveDir.Z).Unit
				if wallNormalFlat then
					local wanted = flat * speed
					local along = wanted - wallNormalFlat * wanted:Dot(wallNormalFlat)
					if along.Magnitude < 0.5 then
						lv.PlaneVelocity = Vector2.zero
					else
						lv.PlaneVelocity = Vector2.new(along.X, along.Z)
					end
				else
					lv.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
				end
			else
				lv.PlaneVelocity = Vector2.zero
			end
			if blocked then
				self._blockedTime = self._blockedTime + (dt or 0.016)
			else
				self._blockedTime = 0
			end
			if self._blockedTime > 0.35 then
				if lv.MaxForce ~= self._freeForce then
					lv.MaxForce = self._freeForce
				end
			elseif lv.MaxForce ~= self._maxForce then
				lv.MaxForce = self._maxForce
			end
		end
	elseif CarrySystem._lvBoost then
		CarrySystem._lvBoost.PlaneVelocity = Vector2.zero
		if CarrySystem._lvBoost.Enabled then
			CarrySystem._lvBoost.Enabled = false
		end
	end
end
function CarrySystem:start()
	if self._heartbeatConn then
		return
	end
	self._heartbeatConn = RunService.Heartbeat:Connect(function(dt)
		self:updateMovement(dt)
	end)
	if self.softStealEnabled then
		self:startSoftStealScanner()
	end
	print("[CarrySystem] Activado")
end
function CarrySystem:stop()
	if self._heartbeatConn then
		self._heartbeatConn:Disconnect()
		self._heartbeatConn = nil
	end
	self:stopSoftStealScanner()
	destroyLV()
	self.softStealLatched = false
	print("[CarrySystem] Desactivado")
end
function CarrySystem:setNormalSpeed(v)
	self.normalSpeed = _clamp(v, 1, 500)
end
function CarrySystem:setCarrySpeed(v)
	self.carrySpeed = _clamp(v, 1, 500)
end
function CarrySystem:setLaggerSpeed(v)
	self.laggerSpeed = _clamp(v, 0.1, 500)
end
function CarrySystem:setLaggerCarrySpeed(v)
	self.laggerCarrySpeed = _clamp(v, 0.1, 500)
end
function CarrySystem:setSoftStealSpeed(v)
	self.softStealSpeed = _clamp(v, 1, 500)
end
function CarrySystem:setSoftStealRadius(v)
	self.softStealRadius = _clamp(v, 1, 200)
end
function CarrySystem:toggleCarryMode()
	self.speedToggled = not self.speedToggled
end
function CarrySystem:setLaggerMode(mode)
	if mode == 0 then
		self.laggerMode = 0
	elseif mode == 1 then
		self.laggerMode = 1
	elseif mode == 2 then
		self.laggerMode = 2
	end
end
function CarrySystem:toggleLaggerMode()
	if self.laggerMode == 0 then
		self.laggerMode = 1
	elseif self.laggerMode == 1 then
		self.laggerMode = 2
	else
		self.laggerMode = 0
	end
end
function CarrySystem:setSoftStealEnabled(enabled)
	self.softStealEnabled = enabled
	if enabled then
		self:startSoftStealScanner()
	else
		self:stopSoftStealScanner()
		self.softStealLatched = false
	end
end
function CarrySystem:toggleSoftSteal()
	self:setSoftStealEnabled(not self.softStealEnabled)
end
function CarrySystem:isRunning()
	return self._heartbeatConn ~= nil
end
function CarrySystem:getCurrentSpeed()
	return self:getActiveSpeed()
end
local COLOR_THEMES = { ["Black & White"] = Color3.fromRGB(255, 255, 255) }
currentColorTheme = "Black & White"
selectedColor = COLOR_THEMES["Black & White"]
function getThemeColor()
	return selectedColor
end
local _lastThemeUpdate = 0
local _lastThemeColor = nil
function applyColorTheme(themeName)
	local color = COLOR_THEMES["Black & White"]
	currentColorTheme = "Black & White"
	selectedColor = color
	updateAllUIThemeColors(color)
	saveAllSettings()
end
function updateAllUIThemeColors(color)
	local now = _tick()
	if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then
		return
	end
	_lastThemeUpdate = now
	_lastThemeColor = color
	if progressFill then
		progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		local grad = progressFill:FindFirstChildOfClass("UIGradient")
		if grad then
			grad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		end
	end
	if pbFrame then
		local border = pbFrame:FindFirstChildOfClass("UIStroke")
		if border then
			border.Color = Color3.fromRGB(255, 255, 255)
		end
		local fpsNeon = pbFrame:FindFirstChild("FPSNeon")
		if fpsNeon then
			fpsNeon.TextColor3 = color
		end
	end
	local function searchAndUpdateText(parent)
		for _, child in ipairs(parent:GetDescendants()) do
			if child:IsA("TextLabel") and not (pbFrame and child:IsDescendantOf(pbFrame)) then
				if
					child.Text:find("discord.gg")
					or child.Text:find("Spd:")
					or child.Name == "DiscordText"
					or child.Name == "AmpDuelsSpeedIndicator"
					or child.Text:find("FPS")
				then
					child.TextColor3 = color
				end
			end
			if child:IsA("UIStroke") then
				if child.Color == Color3.fromRGB(181, 181, 181) then
					child.Color = color
				end
			end
		end
	end
	if gui then
		searchAndUpdateText(gui)
	end
	if tpBatFloatingButton then
		paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
	end
	if batV2FloatingButton then
		paintFloatingBtn(batV2FloatingButton:FindFirstChild("Frame"), autoBatV2Enabled)
	end
	for _, tab in ipairs(tabButtons or {}) do
		if tab.TextColor3 == Color3.fromRGB(181, 181, 181) then
			tab.TextColor3 = color
		end
	end
	for _, hl in pairs(espHighlightCache) do
		if hl then
			hl.FillColor = color
			hl.OutlineColor = color
		end
	end
	for _, lines in pairs(espTracerCache) do
		if lines then
			for _, ln in ipairs(lines) do
				if ln then
					ln.Color = color
				end
			end
		end
	end
	for _, bb in pairs(espBillboardCache) do
		if bb then
			local img = bb:FindFirstChildOfClass("ImageLabel")
			if img then
				local stroke = img:FindFirstChildOfClass("UIStroke")
				if stroke then
					stroke.Color = color
				end
			end
		end
	end
	if main then
		local headerDiv = main:FindFirstChild("HeaderDivider")
		if headerDiv then
			headerDiv.BackgroundColor3 = color
		end
		local vertDiv = main:FindFirstChild("VerticalDivider")
		if vertDiv then
			vertDiv.BackgroundColor3 = color
		end
		local titleIcon = main:FindFirstChild("TitleIcon", true)
		if titleIcon then
			titleIcon.BackgroundColor3 = color
		end
		local titleFrame = main:FindFirstChild("Frame")
		if titleFrame then
			for _, child in ipairs(titleFrame:GetDescendants()) do
				if child:IsA("UIStroke") and child.Color == Color3.fromRGB(181, 181, 181) then
					child.Color = color
				end
			end
		end
	end
	if colorSelectorLabel then
		colorSelectorLabel.Text = currentColorTheme
		colorSelectorLabel.TextColor3 = color
	end
	if miniBtn then
		miniBtn.TextColor3 = color
		local grad = miniBtn:FindFirstChildOfClass("UIGradient")
		if grad then
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, color),
				ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, color),
			})
		end
	end
	local pGui = LP:FindFirstChild("PlayerGui")
	if pGui then
		local bb = pGui:FindFirstChild("RagCountdownBillboard")
		if bb then
			local lbl = bb:FindFirstChildOfClass("TextLabel")
			if lbl then
				lbl.TextColor3 = color
				local grad = lbl:FindFirstChildOfClass("UIGradient")
				if grad then
					grad.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color),
						ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(1, color),
					})
				end
			end
		end
	end
	if MobilePanel then
		local container = MobilePanel:FindFirstChild("FloatingPanel")
		if container then
			local btnContainer = container:FindFirstChild("ButtonsContainer")
			if btnContainer then
				for _, btn in ipairs(btnContainer:GetChildren()) do
					if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
						paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
					end
				end
			end
		end
	end
end
local HOMERO_CFG = {
	body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
	aplicarCuerpo = true,
	items = {
		{ id = 103227869700418, offset = _CFnew(0, 0, 0) },
		{ id = 84952305140948, offset = _CFnew(0, 0, 0) },
		{ id = 122465238537030, offset = _CFnew(0, 0, 0) },
	},
	shirt = nil,
	pants = "rbxassetid://78591690208112",
	skinColor = Color3.fromRGB(234, 184, 146),
	headColor = Color3.fromRGB(0, 0, 0),
}
local TAG = "LocalOutfit_"
local function loadObjects(id)
	local ok, res = pcall(function()
		return game:GetObjects("rbxassetid://" .. tostring(id))
	end)
	if ok and typeof(res) == "table" and #res > 0 then
		return res
	end
	ok, res = pcall(function()
		return game:GetService("InsertService"):LoadAsset(id)
	end)
	if ok and res then
		return { res }
	end
	return nil
end
local function collectParts(objs)
	local out = {}
	for _, o in ipairs(objs) do
		if o:IsA("BasePart") then
			out[#out + 1] = o
		end
		for _, d in ipairs(o:GetDescendants()) do
			if d:IsA("BasePart") then
				out[#out + 1] = d
			end
		end
	end
	return out
end
local function findAtt(char, name)
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
			return p
		end
	end
end
local function applyBody(char)
	local total = 0
	for _, id in ipairs(HOMERO_CFG.body) do
		local objs = loadObjects(id)
		if objs then
			for _, mp in ipairs(collectParts(objs)) do
				local orig = char:FindFirstChild(mp.Name)
				if orig and orig:IsA("BasePart") then
					local c = mp:Clone()
					c.Name = TAG .. "body_" .. mp.Name
					c.CanCollide = false
					c.Anchored = false
					c.Massless = true
					c.Size = orig.Size
					c.CFrame = orig.CFrame
					c.Parent = char
					local w = Instance.new("WeldConstraint")
					w.Part0 = orig
					w.Part1 = c
					w.Parent = c
					orig.Transparency = 1
					total = total + 1
				end
			end
			for _, o in ipairs(objs) do
				pcall(function()
					o:Destroy()
				end)
			end
		end
	end
	return total
end
local function attachItem(char, entry)
	local objs = loadObjects(entry.id)
	if not objs then
		return false
	end
	local handle
	for _, p in ipairs(collectParts(objs)) do
		if p.Name == "Handle" then
			handle = p
			break
		end
		if not handle then
			handle = p
		end
	end
	if not handle then
		for _, o in ipairs(objs) do
			pcall(function()
				o:Destroy()
			end)
		end
		return false
	end
	local H = handle:Clone()
	for _, o in ipairs(objs) do
		pcall(function()
			o:Destroy()
		end)
	end
	H.Name = TAG .. "item_" .. tostring(entry.id)
	H.CanCollide = false
	H.Anchored = false
	H.Massless = true
	local wrap = H:FindFirstChildWhichIsA("WrapLayer")
	local target, c0, c1
	if wrap then
		target = char:FindFirstChild("UpperTorso")
			or char:FindFirstChild("Torso")
			or char:FindFirstChild("HumanoidRootPart")
		c0 = entry.offset or _CFnew()
		c1 = _CFnew()
	else
		local hAtt = H:FindFirstChildOfClass("Attachment")
		local bAtt = hAtt and findAtt(char, hAtt.Name)
		if bAtt then
			target = bAtt.Parent
			c0 = bAtt.CFrame * (entry.offset or _CFnew())
			c1 = hAtt.CFrame
		else
			target = char:FindFirstChild("Head")
			c0 = entry.offset or _CFnew(0, 1.4, 0)
			c1 = _CFnew()
		end
	end
	if not target then
		H:Destroy()
		return false
	end
	H.CFrame = target.CFrame * c0 * c1:Inverse()
	H.Parent = char
	local w = Instance.new("Weld")
	w.Part0 = target
	w.Part1 = H
	w.C0 = c0
	w.C1 = c1
	w.Parent = H
	return true
end
function applyHomeroOutfit(char)
	if not char then
		char = LP.Character
	end
	if not char then
		return
	end
	char:WaitForChild("Humanoid", 10)
	char:WaitForChild("Head", 10)
	task.wait(0.4)
	for _, d in ipairs(char:GetChildren()) do
		if d.Name:sub(1, #TAG) == TAG then
			pcall(function()
				d:Destroy()
			end)
		end
	end
	if HOMERO_CFG.skinColor then
		local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
		bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
		bc.TorsoColor3 = HOMERO_CFG.skinColor
		bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
		bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
		bc.Parent = char
	end
	for _, a in ipairs(char:GetChildren()) do
		if a:IsA("Accessory") then
			local h = a:FindFirstChild("Handle")
			if h then
				h.Transparency = 1
			end
		end
	end
	if HOMERO_CFG.shirt then
		local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
		s.Name = "Shirt"
		s.ShirtTemplate = HOMERO_CFG.shirt
		s.Parent = char
	end
	if HOMERO_CFG.pants then
		local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
		p.Name = "Pants"
		p.PantsTemplate = HOMERO_CFG.pants
		p.Parent = char
	end
	if HOMERO_CFG.aplicarCuerpo then
		applyBody(char)
	end
	for _, e in ipairs(HOMERO_CFG.items) do
		attachItem(char, e)
	end
end
local function applyNoOutfit(char)
	if not char then
		char = LP.Character
	end
	if not char then
		return
	end
	for _, d in ipairs(char:GetChildren()) do
		if d.Name:sub(1, #TAG) == TAG then
			pcall(function()
				d:Destroy()
			end)
		end
	end
	local oldAcc = char:FindFirstChild("AuFfitAccessory")
	if oldAcc then
		pcall(function()
			oldAcc:Destroy()
		end)
	end
	local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
	if oldKorblox then
		pcall(function()
			oldKorblox:Destroy()
		end)
	end
	for _, d in ipairs(char:GetChildren()) do
		if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
			pcall(function()
				d:Destroy()
			end)
		end
	end
	local head = char:FindFirstChild("Head")
	if head then
		head.Transparency = 0
		head.CanCollide = true
		head.LocalTransparencyModifier = 0
		local face = head:FindFirstChild("face")
		if face then
			face.Transparency = 0
		end
		local sm = head:FindFirstChildWhichIsA("SpecialMesh")
		if sm then
			pcall(function()
				sm:Destroy()
			end)
		end
	end
	pcall(function()
		local neck = char:FindFirstChild("Neck")
		if neck then
			neck.Enabled = true
		end
	end)
	for _, partName in ipairs({ "RightUpperLeg", "RightLowerLeg", "RightFoot" }) do
		local limb = char:FindFirstChild(partName)
		if limb then
			limb.Transparency = 0
		end
	end
	local shirt = char:FindFirstChildWhichIsA("Shirt")
	if shirt then
		pcall(function()
			shirt:Destroy()
		end)
	end
	local pants = char:FindFirstChildWhichIsA("Pants")
	if pants then
		pcall(function()
			pants:Destroy()
		end)
	end
	for _, a in ipairs(char:GetChildren()) do
		if a:IsA("Accessory") then
			local h = a:FindFirstChild("Handle")
			if h then
				h.Transparency = 0
			end
		end
	end
end
speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = true
editModeEnabled = false
hideButtonsEnabled = false
savedFloatingVisibility = {}
uiScaleValue = 78
espEnabled = false
bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batV2FloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil
neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil
currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil
autoBatV2Enabled = false
autoBatV2SwingEnabled = true
autoBatV2HitCooldown = false
AUTO_BAT_V2_SPEED = 68
AUTO_BAT_V2_DIST = 0.55
AUTO_BAT_V2_HEIGHT = 2.35
AUTO_BAT_V2_V_OFF = 0.15
AUTO_BAT_V2_HIT_DIST = 5.5
AUTO_BAT_V2_SWING_CD = 0.045
_batV2Conn = nil
useCarrySystem = false
lastMoveDir = _V3zero
local CoreGui = game:GetService("CoreGui")
local InfiniteJump = {
	enabled = false,
	jumpPower = 55,
	minVelocity = 30,
	holdEnabled = false,
	isHolding = false,
	jumpConn = nil,
	heartbeatConn = nil,
	holdBeganConn = nil,
	holdEndedConn = nil,	focusReleasedConn = nil,	heldInputs = {},
}
local function applyJump(root)
	if not root then
		return
	end
	pcall(function()
		root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
	end)
end
local function onJumpRequest()
	if not InfiniteJump.enabled or not InfiniteJump.holdEnabled then
		return
	end
	local char = LP.Character
	if not char then
		return
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		applyJump(root)
	end
end
local function onHeartbeat()
	if not InfiniteJump.enabled or not InfiniteJump.holdEnabled or not InfiniteJump.isHolding then
		return
	end
	local char = LP.Character
	if not char then
		return
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		applyJump(root)
	end
end
-- Only Roblox's jump button counts as a mobile jump hold, not other screen touches.
local function isJumpButtonTouch(input)
	local playerGui = LP:FindFirstChildOfClass("PlayerGui")
	if not playerGui then return false end
	for _, object in ipairs(playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)) do
		local current = object
		while current and current ~= playerGui do
			if current.Name == "JumpButton" and current:IsA("GuiButton") then
				local ancestor = current.Parent
				while ancestor and ancestor ~= playerGui do
					if ancestor.Name == "TouchGui" then return true end
					ancestor = ancestor.Parent
				end
			end
			current = current.Parent
		end
	end
	return false
end
local function connectEvents()
	for _, name in ipairs({"jumpConn", "heartbeatConn", "holdBeganConn", "holdEndedConn", "focusReleasedConn"}) do
		if InfiniteJump[name] then
			InfiniteJump[name]:Disconnect()
			InfiniteJump[name] = nil
		end
	end
	InfiniteJump.heldInputs = {}
	InfiniteJump.isHolding = false
	InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
	InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
	InfiniteJump.holdBeganConn = UIS.InputBegan:Connect(function(input, gpe)
		local isJumpInput = false
		if input.UserInputType == Enum.UserInputType.Touch then
			-- Jump-button touches are normally marked as processed by Roblox.
			isJumpInput = isJumpButtonTouch(input)
		elseif not gpe then
			isJumpInput = input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA
		end
		if isJumpInput then
			InfiniteJump.heldInputs[input] = true
			InfiniteJump.isHolding = true
		end
	end)
	InfiniteJump.holdEndedConn = UIS.InputEnded:Connect(function(input)
		InfiniteJump.heldInputs[input] = nil
		InfiniteJump.isHolding = next(InfiniteJump.heldInputs) ~= nil
	end)
	InfiniteJump.focusReleasedConn = UIS.WindowFocusReleased:Connect(function()
		InfiniteJump.heldInputs = {}
		InfiniteJump.isHolding = false
	end)
end
function InfiniteJump.start()
	if InfiniteJump.enabled then
		return
	end
	InfiniteJump.enabled = true
	connectEvents()
	print("[InfiniteJump] Activado (hold enabled)")
end
function InfiniteJump.stop()
	InfiniteJump.enabled = false
	if InfiniteJump.jumpConn then
		InfiniteJump.jumpConn:Disconnect()
		InfiniteJump.jumpConn = nil
	end
	if InfiniteJump.heartbeatConn then
		InfiniteJump.heartbeatConn:Disconnect()
		InfiniteJump.heartbeatConn = nil
	end
	if InfiniteJump.holdBeganConn then
		InfiniteJump.holdBeganConn:Disconnect()
		InfiniteJump.holdBeganConn = nil
	end
	if InfiniteJump.holdEndedConn then
		InfiniteJump.holdEndedConn:Disconnect()
		InfiniteJump.holdEndedConn = nil
	end
	if InfiniteJump.focusReleasedConn then
		InfiniteJump.focusReleasedConn:Disconnect()
		InfiniteJump.focusReleasedConn = nil
	end
	InfiniteJump.heldInputs = {}
	InfiniteJump.isHolding = false
	print("[InfiniteJump] Desactivado")
end
function InfiniteJump.setJumpPower(power)
	power = tonumber(power) or 55
	InfiniteJump.jumpPower = _clamp(power, 10, 200)
end
function InfiniteJump.isRunning()
	return InfiniteJump.enabled == true
end
InfiniteJump.start()
local function getCharParts()
	local char = LP.Character
	if not char then
		return nil, nil
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then
		return nil, nil
	end
	return hum, root
end
local function claimOwnership(root)
	pcall(function()
		root:SetNetworkOwner(LP)
	end)
end
function getActiveMoveSpeed()
	if laggerCarryToggled then
		return LAGGER_CARRY_SPEED
	elseif laggerToggled then
		return LAGGER_SPEED
	elseif speedMode then
		return CS
	else
		return NS
	end
end
local _velChecked = {}
local _hookedVelParts = {}
local function _setupVelChecked(char)
	_velChecked = {}
	if not char then
		return
	end
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if hrp then
		_velChecked[hrp] = true
	end
	return hrp
end
local _hookVelSupported = nil
local function _hookVelHRP(hrp)
	if not hrp or _hookedVelParts[hrp] then
		return
	end
	if _hookVelSupported == false then
		return
	end
	if _hookVelSupported == nil then
		_hookVelSupported = (type(getrawmetatable) == "function")
			and (type(setreadonly) == "function")
			and (type(newcclosure) == "function")
			and (type(checkcaller) == "function")
	end
	if not _hookVelSupported then
		return
	end
	_hookedVelParts[hrp] = true
	local ok = pcall(function()
		local mt = getrawmetatable(hrp)
		if not mt then
			return
		end
		setreadonly(mt, false)
		local originalVelIndex = rawget(mt, "__index")
		mt.__index = newcclosure(function(self, key)
			if not checkcaller() and _velChecked[self] and (key == "AssemblyLinearVelocity" or key == "Velocity") then
				local real
				if type(originalVelIndex) == "function" then
					real = originalVelIndex(self, key)
				elseif type(originalVelIndex) == "table" then
					real = originalVelIndex[key]
				end
				if real and real.Magnitude > 20 then
					return real.Unit * 20
				end
				return real
			end
			if type(originalVelIndex) == "function" then
				return originalVelIndex(self, key)
			elseif type(originalVelIndex) == "table" then
				return originalVelIndex[key]
			end
		end)
		setreadonly(mt, true)
	end)
	if not ok then
		_hookVelSupported = false
	end
end
if LP.Character then
	local _hrp0 = _setupVelChecked(LP.Character)
	_hookVelHRP(_hrp0)
end
local function _isRagdollState(hum)
	if not hum then
		return true
	end
	local st = hum:GetState()
	return hum.PlatformStand
		or st == Enum.HumanoidStateType.Physics
		or st == Enum.HumanoidStateType.Ragdoll
		or st == Enum.HumanoidStateType.FallingDown
end
local function _applyVelocitySpeed(dir, speed, hrp)
	if not hrp or not hrp.Parent then
		return
	end
	if autoBatV2Enabled or batDesyncTpEnabled or autoBatEnabled then
		return
	end
	if dir and dir.Magnitude > 0.05 then
		pcall(function()
			if hrp.SetNetworkOwner then
				hrp:SetNetworkOwner(LP)
			end
		end)
		local unit = dir.Unit
		local vy = hrp.AssemblyLinearVelocity.Y
		hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, vy, unit.Z * speed)
	else
		local vy = hrp.AssemblyLinearVelocity.Y
		hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
	end
end
function getAutoPathSpeed()
	if laggerCarryToggled or laggerToggled then
		return LAGGER_SPEED
	end
	return NS
end
ANIM_PACKS = {
	["Zombie"] = {
		idle1 = "rbxassetid://616158929",
		idle2 = "rbxassetid://616160636",
		walk = "rbxassetid://616168032",
		run = "rbxassetid://616163682",
		jump = "rbxassetid://616161997",
		fall = "rbxassetid://616157476",
		climb = "rbxassetid://616156119",
		swim = "rbxassetid://616165109",
		swimidle = "rbxassetid://616166655",
	},
	["Ninja"] = {
		idle1 = "rbxassetid://656117400",
		idle2 = "rbxassetid://656117400",
		walk = "rbxassetid://656121766",
		run = "rbxassetid://656118852",
		jump = "rbxassetid://656117878",
		fall = "rbxassetid://656115606",
		climb = "rbxassetid://656114359",
		swim = "rbxassetid://656117400",
		swimidle = "rbxassetid://656117400",
	},
	["Knight"] = {
		idle1 = "rbxassetid://657595757",
		idle2 = "rbxassetid://657595757",
		walk = "rbxassetid://657552124",
		run = "rbxassetid://657564596",
		jump = "rbxassetid://658409194",
		fall = "rbxassetid://657600338",
		climb = "rbxassetid://658360781",
		swim = "rbxassetid://657595757",
		swimidle = "rbxassetid://657595757",
	},
	["Elder"] = {
		idle1 = "rbxassetid://845397899",
		idle2 = "rbxassetid://845397899",
		walk = "rbxassetid://845403856",
		run = "rbxassetid://845386501",
		jump = "rbxassetid://845398858",
		fall = "rbxassetid://845397673",
		climb = "rbxassetid://845392038",
		swim = "rbxassetid://845397899",
		swimidle = "rbxassetid://845397899",
	},
	["Levitate"] = {
		idle1 = "rbxassetid://616006778",
		idle2 = "rbxassetid://616006778",
		walk = "rbxassetid://616013216",
		run = "rbxassetid://616013216",
		jump = "rbxassetid://616008936",
		fall = "rbxassetid://616005863",
		climb = "rbxassetid://616003713",
		swim = "rbxassetid://616006778",
		swimidle = "rbxassetid://616006778",
	},
	["Astronaut"] = {
		idle1 = "rbxassetid://891621366",
		idle2 = "rbxassetid://891621366",
		walk = "rbxassetid://891636393",
		run = "rbxassetid://891636393",
		jump = "rbxassetid://891627522",
		fall = "rbxassetid://891617961",
		climb = "rbxassetid://891609353",
		swim = "rbxassetid://891621366",
		swimidle = "rbxassetid://891621366",
	},
	["Pirate"] = {
		idle1 = "rbxassetid://750781874",
		idle2 = "rbxassetid://750781874",
		walk = "rbxassetid://750785693",
		run = "rbxassetid://750783738",
		jump = "rbxassetid://750782230",
		fall = "rbxassetid://750780242",
		climb = "rbxassetid://750779899",
		swim = "rbxassetid://750781874",
		swimidle = "rbxassetid://750781874",
	},
	["Toy"] = {
		idle1 = "rbxassetid://782841498",
		idle2 = "rbxassetid://782841498",
		walk = "rbxassetid://782843345",
		run = "rbxassetid://782842708",
		jump = "rbxassetid://782847020",
		fall = "rbxassetid://782846423",
		climb = "rbxassetid://782843869",
		swim = "rbxassetid://782841498",
		swimidle = "rbxassetid://782841498",
	},
	["Vampire"] = {
		idle1 = "rbxassetid://1083445855",
		idle2 = "rbxassetid://1083445855",
		walk = "rbxassetid://1083473930",
		run = "rbxassetid://1083462077",
		jump = "rbxassetid://1083455352",
		fall = "rbxassetid://1083443587",
		climb = "rbxassetid://1083439238",
		swim = "rbxassetid://1083445855",
		swimidle = "rbxassetid://1083445855",
	},
	["Werewolf"] = {
		idle1 = "rbxassetid://1083195517",
		idle2 = "rbxassetid://1083195517",
		walk = "rbxassetid://1083178339",
		run = "rbxassetid://1083216690",
		jump = "rbxassetid://1083218792",
		fall = "rbxassetid://1083189019",
		climb = "rbxassetid://1083182000",
		swim = "rbxassetid://1083195517",
		swimidle = "rbxassetid://1083195517",
	},
	["Rthro"] = {
		idle1 = "rbxassetid://2510196951",
		idle2 = "rbxassetid://2510196951",
		walk = "rbxassetid://2510202577",
		run = "rbxassetid://2510198475",
		jump = "rbxassetid://2510197830",
		fall = "rbxassetid://2510195892",
		climb = "rbxassetid://2510192778",
		swim = "rbxassetid://2510196951",
		swimidle = "rbxassetid://2510196951",
	},
	["Stylish"] = {
		idle1 = "rbxassetid://616136790",
		idle2 = "rbxassetid://616136790",
		walk = "rbxassetid://616146177",
		run = "rbxassetid://616140816",
		jump = "rbxassetid://616139451",
		fall = "rbxassetid://616134815",
		climb = "rbxassetid://616133594",
		swim = "rbxassetid://616136790",
		swimidle = "rbxassetid://616136790",
	},
}
ANIM_PACK_ORDER = {
	{ "Off", "Off" },
	{ "Zombie", "Zombie" },
	{ "Ninja", "Ninja" },
	{ "Knight", "Knight" },
	{ "Elder", "Elder" },
	{ "Levitate", "Levitate" },
	{ "Astronaut", "Astronaut" },
	{ "Pirate", "Pirate" },
	{ "Toy", "Toy" },
	{ "Vampire", "Vampire" },
	{ "Werewolf", "Werewolf" },
	{ "Rthro", "Rthro" },
	{ "Stylish", "Stylish" },
}
local function isPackAnim(id)
	for _, pack in pairs(ANIM_PACKS) do
		for _, v in pairs(pack) do
			if v == id then
				return true
			end
		end
	end
	return false
end
local function saveOriginalAnims(char)
	local animate = char:FindFirstChild("Animate")
	if not animate then
		return
	end
	local function g(obj)
		return obj and obj.AnimationId or nil
	end
	local ids = {
		idle1 = g(animate.idle and animate.idle.Animation1),
		idle2 = g(animate.idle and animate.idle.Animation2),
		walk = g(animate.walk and animate.walk.WalkAnim),
		run = g(animate.run and animate.run.RunAnim),
		jump = g(animate.jump and animate.jump.JumpAnim),
		fall = g(animate.fall and animate.fall.FallAnim),
		climb = g(animate.climb and animate.climb.ClimbAnim),
		swim = g(animate.swim and animate.swim.Swim),
		swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
	}
	if not isPackAnim(ids.walk) then
		originalTryardAnims = ids
	end
end
local function applyAnimPack(packName)
	currentAnimPack = packName
	if animSelectorLabel then
		animSelectorLabel.Text = packName
	end
	if packName == "Off" then
		if originalTryardAnims and LP.Character then
			local animate = LP.Character:FindFirstChild("Animate")
			if animate then
				local function s(obj, id)
					if obj then
						obj.AnimationId = id
					end
				end
				s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
				s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
				s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
				s(animate.run and animate.run.RunAnim, originalTryardAnims.run)
				s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
				s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
				s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
				s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
				s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
			end
		end
		if tryardHeartbeatConn then
			tryardHeartbeatConn:Disconnect()
			tryardHeartbeatConn = nil
		end
		return
	end
	local pack = ANIM_PACKS[packName]
	if not pack then
		return
	end
	if tryardHeartbeatConn then
		tryardHeartbeatConn:Disconnect()
	end
	tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
		local c = LP.Character
		if not c then
			return
		end
		local animate = c:FindFirstChild("Animate")
		if not animate then
			return
		end
		local function s(obj, id)
			if obj then
				obj.AnimationId = id
			end
		end
		s(animate.idle and animate.idle.Animation1, pack.idle1)
		s(animate.idle and animate.idle.Animation2, pack.idle2)
		s(animate.walk and animate.walk.WalkAnim, pack.walk)
		s(animate.run and animate.run.RunAnim, pack.run)
		s(animate.jump and animate.jump.JumpAnim, pack.jump)
		s(animate.fall and animate.fall.FallAnim, pack.fall)
		s(animate.climb and animate.climb.ClimbAnim, pack.climb)
		s(animate.swim and animate.swim.Swim, pack.swim)
		s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
	end)
end
local function restartAnimate(char)
	local animate = char and char:FindFirstChild("Animate")
	if not animate then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
			track:Stop(0)
		end
	end
	animate.Disabled = true
	task.wait()
	animate.Disabled = false
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end
end
local function startAnimPack(packName)
	local char = LP.Character
	if char then
		saveOriginalAnims(char)
		applyAnimPack(packName)
		restartAnimate(char)
	else
		applyAnimPack(packName)
	end
	currentAnimPack = packName
end
local function stopAnimPack()
	currentAnimPack = "Off"
	if animSelectorLabel then
		animSelectorLabel.Text = "Off"
	end
	applyAnimPack("Off")
	restartAnimate(LP.Character)
end
DEFAULT_KB = {
	DropBrainrot = { kb = Enum.KeyCode.X, gp = nil },
	AutoLeft = { kb = Enum.KeyCode.Z, gp = nil },
	AutoRight = { kb = Enum.KeyCode.C, gp = nil },
	AutoBat = { kb = Enum.KeyCode.E, gp = nil },
	TPFloor = { kb = Enum.KeyCode.F, gp = nil },
	GuiHide = { kb = Enum.KeyCode.LeftControl, gp = nil },
	CarryToggle = { kb = Enum.KeyCode.Q, gp = nil },
	LaggerMode = { kb = Enum.KeyCode.R, gp = nil },
	TPBat = { kb = Enum.KeyCode.V, gp = nil },
	BatV2 = { kb = Enum.KeyCode.N, gp = nil },
	InstaReset = { kb = Enum.KeyCode.H, gp = nil },
}
KB = {
	DropBrainrot = { kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp },
	AutoLeft = { kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp },
	AutoRight = { kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp },
	AutoBat = { kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp },
	TPFloor = { kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp },
	GuiHide = { kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp },
	CarryToggle = { kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp },
	LaggerMode = { kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp },
	TPBat = { kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp },
	BatV2 = { kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp },
	InstaReset = { kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp },
}
_isResetting = false
_lastSavedJSON = nil
_isLoading = false
CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }
local plots = workspace:FindFirstChild("Plots")
local stealConnection = nil
local Steal =
	{ AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, StealDelay = 0.25, Data = {} }
local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true
local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
	local now = _tick()
	if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
		return _plotsCache
	end
	_plotsCache = workspace:FindFirstChild("Plots")
	_plotsCacheTime = now
	return _plotsCache
end
local function isMyPlotByName(plotName)
	local plotsRoot = getPlotsRoot()
	if not plotsRoot then
		return false
	end
	local plot = plotsRoot:FindFirstChild(plotName)
	if not plot then
		return false
	end
	local sign = plot:FindFirstChild("PlotSign")
	if sign then
		local yb = sign:FindFirstChild("YourBase")
		if yb and yb:IsA("BillboardGui") then
			return yb.Enabled == true
		end
	end
	return false
end
local function findNearestPrompt()
	local char = LP.Character
	if not char then
		return nil, nil
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil, nil
	end
	local plotsRoot = getPlotsRoot()
	if not plotsRoot then
		return nil, nil
	end
	local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
	local rpos = root.Position
	for _, plot in ipairs(plotsRoot:GetChildren()) do
		if isMyPlotByName(plot.Name) then
			continue
		end
		local pods = plot:FindFirstChild("AnimalPodiums")
		if not pods then
			continue
		end
		for _, pod in ipairs(pods:GetChildren()) do
			pcall(function()
				local base = pod:FindFirstChild("Base")
				local spawn = base and base:FindFirstChild("Spawn")
				if spawn then
					local sp = spawn.Position
					local dx = sp.X - rpos.X
					local dy = sp.Y - rpos.Y
					local dz = sp.Z - rpos.Z
					local dist = _sqrt(dx * dx + dy * dy + dz * dz)
					if dist < nearestDist and dist <= Steal.StealRadius then
						local att = spawn:FindFirstChild("PromptAttachment")
						if att then
							for _, child in ipairs(att:GetChildren()) do
								if
									child:IsA("ProximityPrompt")
									and child.ActionText
									and child.ActionText:find("Steal")
								then
									nearestPrompt = child
									nearestDist = dist
									nearestName = pod.Name
									break
								end
							end
						end
					end
				end
			end)
		end
	end
	return nearestPrompt, nearestName
end
local function executeSteal(prompt, podName)
	if isStealing then
		return
	end
	if math.random(30) == 1 then
		for p in pairs(Steal.Data) do
			if not p.Parent then
				Steal.Data[p] = nil
			end
		end
	end
	if not Steal.Data[prompt] then
		Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
		pcall(function()
			if getconnections then
				for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
					if c.Function then
						table.insert(Steal.Data[prompt].hold, c.Function)
					end
				end
				for _, c in ipairs(getconnections(prompt.Triggered)) do
					if c.Function then
						table.insert(Steal.Data[prompt].trigger, c.Function)
					end
				end
			end
		end)
	end
	local data = Steal.Data[prompt]
	if not data.ready then
		return
	end
	data.ready = false
	isStealing = true
	if progressFill then
		progressFill.Size = UDim2.new(0, 0, 1, 0)
	end
	if progressPct then
		progressPct.Text = "0%"
	end
	task.spawn(function()
		for _, f in ipairs(data.hold) do
			task.spawn(f)
		end
		local startTime = _tick()
		local duration = Steal.StealDuration
		local promptFired = false
		if autoGrabStopEnabled then
			while isStealing and Steal.AutoStealEnabled do
				local elapsed = _tick() - startTime
				if elapsed >= autoGrabStopTime then
					break
				end
				local progress = _clamp(elapsed / duration, 0, 1)
				if progressFill then
					progressFill.Size = UDim2.new(progress, 0, 1, 0)
				end
				if progressPct then
					progressPct.Text = _floor(progress * 100) .. "%"
				end
				if not prompt.Parent or not prompt.Parent.Parent then
					break
				end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
					break
				end
				task.wait()
			end
			local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
			if progressFill then
				progressFill.Size = UDim2.new(stopProgress, 0, 1, 0)
			end
			if progressPct then
				progressPct.Text = _floor(stopProgress * 100) .. "%"
			end
			local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
			local phase2Start = _tick()
			while isStealing and Steal.AutoStealEnabled do
				if _tick() - phase2Start >= phase2Timeout then
					if progressFill then
						progressFill.Size = UDim2.new(0, 0, 1, 0)
					end
					if progressPct then
						progressPct.Text = "0%"
					end
					data.ready = true
					isStealing = false
					task.wait()
					local newPrompt, newName = findNearestPrompt()
					if newPrompt then
						executeSteal(newPrompt, newName)
					end
					return
				end
				if not prompt.Parent or not prompt.Parent.Parent then
					isStealing = false
					if progressFill then
						progressFill.Size = UDim2.new(0, 0, 1, 0)
					end
					if progressPct then
						progressPct.Text = "0%"
					end
					data.ready = true
					return
				end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
					if dist <= autoGrabSetDelayRadius then
						break
					elseif dist > Steal.StealRadius then
						isStealing = false
						if progressFill then
							progressFill.Size = UDim2.new(0, 0, 1, 0)
						end
						if progressPct then
							progressPct.Text = "0%"
						end
						data.ready = true
						return
					end
				end
				task.wait()
			end
			if isStealing and Steal.AutoStealEnabled then
				local fillStart = _tick()
				local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
				while true do
					local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
					local totalProgress = stopProgress + fp * (1 - stopProgress)
					if progressFill then
						progressFill.Size = UDim2.new(totalProgress, 0, 1, 0)
					end
					if progressPct then
						progressPct.Text = _floor(totalProgress * 100) .. "%"
					end
					if fp >= 1 and not promptFired then
						promptFired = true
						pcall(function()
							for _, f in ipairs(data.trigger) do
								task.spawn(f)
							end
							local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
							if remote and podName then
								remote:FireServer(podName)
							end
							if prompt then
								prompt:Fire()
							end
						end)
						break
					end
					task.wait()
				end
			end
		else
			while isStealing and Steal.AutoStealEnabled do
				local elapsed = _tick() - startTime
				local progress = _clamp(elapsed / duration, 0, 1)
				if progressFill then
					progressFill.Size = UDim2.new(progress, 0, 1, 0)
				end
				if progressPct then
					progressPct.Text = _floor(progress * 100) .. "%"
				end
				if not prompt.Parent or not prompt.Parent.Parent then
					break
				end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
					break
				end
				if elapsed >= duration and not promptFired then
					promptFired = true
					pcall(function()
						for _, f in ipairs(data.trigger) do
							task.spawn(f)
						end
						local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
						if remote and podName then
							remote:FireServer(podName)
						end
						if prompt then
							prompt:Fire()
						end
					end)
					break
				end
				task.wait()
			end
		end
		if progressFill then
			progressFill.Size = UDim2.new(0, 0, 1, 0)
		end
		if progressPct then
			progressPct.Text = "0%"
		end
		data.ready = true
		isStealing = false
	end)
end
function startAutoSteal()
	if stealConnection then
		local connected = false
		pcall(function()
			connected = stealConnection.Connected == true
		end)
		if connected then
			Steal.StealRadius = CONFIG.STEAL_RANGE
			Steal.AutoStealEnabled = true
			CONFIG.AUTO_STEAL_ENABLED = true
			return true
		end
		pcall(function()
			stealConnection:Disconnect()
		end)
		stealConnection = nil
	end
	Steal.StealRadius = CONFIG.STEAL_RANGE
	Steal.AutoStealEnabled = true
	CONFIG.AUTO_STEAL_ENABLED = true
	stealConnection = RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then
			return
		end
		local p, n = findNearestPrompt()
		if p then
			executeSteal(p, n)
		end
	end)
	return true
end
function stopAutoSteal()
	if stealConnection then
		stealConnection:Disconnect()
		stealConnection = nil
	end
	isStealing = false
	Steal.AutoStealEnabled = false
	CONFIG.AUTO_STEAL_ENABLED = false
	if progressFill then
		TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
	end
	if progressPct then
		progressPct.Text = "0%"
	end
end
medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0, 0, 0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil
_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08
tpBatFloatingButton = nil
batV2FloatingButton = nil
enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = { autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil }
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressRadLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox, jumpPowerBox =
	nil, nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
setJumpToggleState = nil
jumpHoldSetVisual = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab =
	nil, nil, nil, nil, nil, nil
setAntiDieVisual = nil
setEditModeVisual = nil
setESPVIsual = nil
batSkinSetVisual = nil
minecraftBatSkinSetVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 =
	nil, nil, nil, nil, nil, nil, nil, nil
autoBatV2SetVisual = nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil
carrySystemToggleSetter = nil
carrySysNormalBox = nil
carrySysCarryBox = nil
carrySysLaggerBox = nil
carrySysLaggerCarryBox = nil
carrySysSoftStealSpeedBox = nil
carrySysSoftStealRadiusBox = nil
GAMEPAD_KEYS = {
	[Enum.KeyCode.ButtonA] = true,
	[Enum.KeyCode.ButtonB] = true,
	[Enum.KeyCode.ButtonX] = true,
	[Enum.KeyCode.ButtonY] = true,
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonR1] = true,
	[Enum.KeyCode.ButtonL2] = true,
	[Enum.KeyCode.ButtonR2] = true,
	[Enum.KeyCode.ButtonL3] = true,
	[Enum.KeyCode.ButtonR3] = true,
	[Enum.KeyCode.ButtonStart] = true,
	[Enum.KeyCode.ButtonSelect] = true,
	[Enum.KeyCode.DPadUp] = true,
	[Enum.KeyCode.DPadDown] = true,
	[Enum.KeyCode.DPadLeft] = true,
	[Enum.KeyCode.DPadRight] = true,
}
MOVE_KEYS = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Down] = true,
	[Enum.KeyCode.Right] = true,
}
BAT_COUNTER_SLAP_LIST = {
	"Bat",
	"Slap",
	"Iron Slap",
	"Gold Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Ruby Slap",
	"Dark Matter Slap",
	"Flame Slap",
	"Nuclear Slap",
	"Galaxy Slap",
	"Glitched Slap",
}
AP = {
	L1 = _V3new(-476.48, -6.28, 92.73),
	L2 = _V3new(-483.12, -4.95, 94.80),
	L_FACE = _V3new(-482.25, -4.96, 92.09),
	R1 = _V3new(-476.16, -6.52, 25.62),
	R2 = _V3new(-483.06, -5.03, 25.48),
	R_FACE = _V3new(-482.06, -6.93, 35.47),
}
function isGamepadInput(inp)
	return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end
function isBindableInput(inp)
	if not inp or inp.KeyCode == Enum.KeyCode.Unknown then
		return false
	end
	if inp.UserInputType == Enum.UserInputType.Keyboard then
		return true
	end
	return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end
function kbMatch(entry, kc)
	return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end
function resetProgressBar()
	if progressPct then
		progressPct.Text = "0%"
	end
	if progressFill then
		progressFill.Size = UDim2.new(0, 0, 1, 0)
	end
end
local function doTpDown()
	pcall(function()
		local char = LP.Character
		if not char then
			return
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then
			return
		end
		root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z)
			* CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
		root.Velocity = _V3zero
	end)
end
local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1
local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16
local stateV1 = { active = false, isBoosting = false, cachedChar = nil, ragdollConnections = {} }
local function disconnectAllV1()
	for _, conn in ipairs(stateV1.ragdollConnections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	stateV1.ragdollConnections = {}
end
local function cacheCharacterV1()
	local char = LP.Character
	if not char then
		return false
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then
		return false
	end
	stateV1.cachedChar = { character = char, humanoid = hum, root = root }
	return true
end
local function isRagdolledV1()
	if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then
		return false
	end
	local hum = stateV1.cachedChar.humanoid
	local st = hum:GetState()
	local ragdollStates = {
		[Enum.HumanoidStateType.Physics] = true,
		[Enum.HumanoidStateType.Ragdoll] = true,
		[Enum.HumanoidStateType.FallingDown] = true,
	}
	return ragdollStates[st] or false
end
local function forceExitRagdollV1()
	if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then
		return
	end
	local hum = stateV1.cachedChar.humanoid
	local root = stateV1.cachedChar.root
	pcall(function()
		LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
	end)
	for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
		if
			descendant:IsA("BallSocketConstraint")
			or (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment"))
		then
			descendant:Destroy()
		end
	end
	if not stateV1.isBoosting then
		stateV1.isBoosting = true
		hum.WalkSpeed = BOOST_SPEED
	end
	if hum.Health > 0 then
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end
	root.Anchored = false
end
local function heartbeatLoopV1()
	while stateV1.active do
		task.wait()
		if isRagdolledV1() then
			forceExitRagdollV1()
		elseif stateV1.isBoosting and not isRagdolledV1() then
			stateV1.isBoosting = false
			if stateV1.cachedChar and stateV1.cachedChar.humanoid then
				stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
			end
		end
	end
end
function AntiRagdollV1.start()
	if stateV1.active then
		return
	end
	AntiRagdollV1.stop()
	if not cacheCharacterV1() then
		warn("[AntiRagdollV1] No se pudo cachear el personaje")
		return
	end
	stateV1.active = true
	stateV1.isBoosting = false
	local camConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
			cam.CameraSubject = stateV1.cachedChar.humanoid
		end
	end)
	table.insert(stateV1.ragdollConnections, camConn)
	local respawnConn = LP.CharacterAdded:Connect(function()
		stateV1.isBoosting = false
		task.wait(0.5)
		cacheCharacterV1()
	end)
	table.insert(stateV1.ragdollConnections, respawnConn)
	task.spawn(heartbeatLoopV1)
	print("[AntiRagdollV1] Activado")
end
function AntiRagdollV1.stop()
	stateV1.active = false
	if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
		stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
	end
	stateV1.isBoosting = false
	disconnectAllV1()
	stateV1.cachedChar = nil
	print("[AntiRagdollV1] Desactivado")
end
function AntiRagdollV1.isRunning()
	return stateV1.active
end
local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }
local function startAntiRagdollV2()
	if AntiRagdollV2.Connection then
		return
	end
	AntiRagdollV2.Enabled = true
	AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
		if not AntiRagdollV2.Enabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or not root then
			return
		end
		if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
			return
		end
		local state = hum:GetState()
		local now = _tick()
		if
			state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown
		then
			if now - AntiRagdollV2.ResetCooldown > 0.15 then
				AntiRagdollV2.ResetCooldown = now
				pcall(function()
					if hum:GetState() == Enum.HumanoidStateType.GettingUp then
						return
					end
					if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
						return
					end
					hum:ChangeState(Enum.HumanoidStateType.GettingUp)
					root.Velocity = _V3zero
					root.RotVelocity = _V3zero
					root.AssemblyLinearVelocity = _V3zero
					root.AssemblyAngularVelocity = _V3zero
					for _, obj in ipairs(char:GetDescendants()) do
						if obj:IsA("Motor6D") then
							obj.Enabled = true
						end
						if obj:IsA("Constraint") then
							obj.Enabled = true
						end
					end
					workspace.CurrentCamera.CameraSubject = hum
					local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
					if PM then
						local CM = require(PM:FindFirstChild("ControlModule"))
						if CM then
							CM:Enable()
						end
					end
					hum.AutoRotate = true
					hum.PlatformStand = false
					hum.Sit = false
				end)
			end
		end
	end)
end
local function stopAntiRagdollV2()
	AntiRagdollV2.Enabled = false
	if AntiRagdollV2.Connection then
		AntiRagdollV2.Connection:Disconnect()
		AntiRagdollV2.Connection = nil
	end
	AntiRagdollV2.ResetCooldown = 0
end
function setAntiRagdollMode(mode)
	if AntiRagdollV1.isRunning() then
		AntiRagdollV1.stop()
	end
	if AntiRagdollV2.Enabled then
		stopAntiRagdollV2()
	end
	antiRagdollMode = mode
	if mode == "v1" then
		AntiRagdollV1.start()
	elseif mode == "v2" then
		startAntiRagdollV2()
	end
	if _G.updateAntiRagdollUI then
		_G.updateAntiRagdollUI(mode)
	end
	saveAllSettings()
end
local AntiDieModule =
	{ enabled = false, healthConn = nil, diedConn = nil, charConn = nil, humanoid = nil, _reviving = false }
local function disconnectHumanoid()
	if AntiDieModule.healthConn then
		AntiDieModule.healthConn:Disconnect()
		AntiDieModule.healthConn = nil
	end
	if AntiDieModule.diedConn then
		AntiDieModule.diedConn:Disconnect()
		AntiDieModule.diedConn = nil
	end
	AntiDieModule.humanoid = nil
end
local function activateOnCharacter(char)
	if not AntiDieModule.enabled then
		return
	end
	char = char or LP.Character or LP.CharacterAdded:Wait()
	local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
	if not hum or not AntiDieModule.enabled then
		return
	end
	disconnectHumanoid()
	AntiDieModule.humanoid = hum
	pcall(function()
		hum.BreakJointsOnDeath = false
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
	end)
	AntiDieModule.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
		if not AntiDieModule.enabled or not hum.Parent then
			return
		end
		if hum.Health <= 0 and not AntiDieModule._reviving then
			AntiDieModule._reviving = true
			pcall(function()
				hum.Health = hum.MaxHealth
				hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				if hum.Health > 0 then
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
			task.delay(0.2, function()
				AntiDieModule._reviving = false
			end)
		end
	end)
	AntiDieModule.diedConn = hum.Died:Connect(function()
		if not AntiDieModule.enabled or not char.Parent then
			return
		end
		if AntiDieModule._reviving then
			return
		end
		AntiDieModule._reviving = true
		task.defer(function()
			if not AntiDieModule.enabled or not char.Parent or not hum.Parent then
				AntiDieModule._reviving = false
				return
			end
			pcall(function()
				hum.Health = hum.MaxHealth
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end)
			AntiDieModule._reviving = false
		end)
	end)
end
function AntiDieModule.start()
	AntiDieModule.enabled = true
	if AntiDieModule.charConn then
		AntiDieModule.charConn:Disconnect()
	end
	AntiDieModule.charConn = LP.CharacterAdded:Connect(function(char)
		if AntiDieModule.enabled then
			task.defer(function()
				activateOnCharacter(char)
			end)
		end
	end)
	task.defer(function()
		activateOnCharacter(LP.Character)
	end)
	print("[AntiDie] Activado (interno)")
end
function AntiDieModule.stop()
	AntiDieModule.enabled = false
	if AntiDieModule.charConn then
		AntiDieModule.charConn:Disconnect()
		AntiDieModule.charConn = nil
	end
	local hum = AntiDieModule.humanoid
	disconnectHumanoid()
	if hum and hum.Parent then
		pcall(function()
			hum.BreakJointsOnDeath = true
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end)
	end
	print("[AntiDie] Desactivado (interno)")
end
_G.AntiDie = AntiDieModule
local AntiFlingShieldModule = { enabled = false, loop = nil, velocityThreshold = 80 }
local function stabilizeRoot(root)
	if not root or not root.Parent then
		return
	end
	if batDesyncTpEnabled then
		return
	end
	local velocity
	local ok = pcall(function()
		velocity = root.AssemblyLinearVelocity
	end)
	if not ok or typeof(velocity) ~= "Vector3" then
		local legacyOk
		legacyOk, velocity = pcall(function()
			return root.Velocity
		end)
		if not legacyOk or typeof(velocity) ~= "Vector3" then
			return
		end
	end
	if velocity.Magnitude <= AntiFlingShieldModule.velocityThreshold then
		return
	end
	local stabilized = _V3new(0, velocity.Y, 0)
	pcall(function()
		root.AssemblyLinearVelocity = stabilized
	end)
	pcall(function()
		root.AssemblyAngularVelocity = _V3zero
	end)
	pcall(function()
		root.Velocity = stabilized
	end)
	pcall(function()
		root.RotVelocity = _V3zero
	end)
end
function AntiFlingShieldModule.start()
	AntiFlingShieldModule.enabled = true
	if AntiFlingShieldModule.loop then
		AntiFlingShieldModule.loop:Disconnect()
	end
	AntiFlingShieldModule.loop = RunService.Heartbeat:Connect(function()
		if not AntiFlingShieldModule.enabled then
			return
		end
		local char = LP.Character
		stabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
	end)
	print("[AntiFlingShield] Activado (interno)")
end
function AntiFlingShieldModule.stop()
	AntiFlingShieldModule.enabled = false
	if AntiFlingShieldModule.loop then
		AntiFlingShieldModule.loop:Disconnect()
		AntiFlingShieldModule.loop = nil
	end
	print("[AntiFlingShield] Desactivado (interno)")
end
_G.AntiFlingShield = AntiFlingShieldModule
do
	local _ragCountdownRunning = false
	local function _getRagBillboard()
		local char = LP.Character
		if not char then
			return nil, nil
		end
		local head = char:FindFirstChild("Head")
		if not head then
			return nil, nil
		end
		local pGui = LP.PlayerGui
		local existing = pGui:FindFirstChild("RagCountdownBillboard")
		if existing then
			existing:Destroy()
		end
		local bb = Instance.new("BillboardGui")
		bb.Name = "RagCountdownBillboard"
		bb.Size = UDim2.new(0, 84, 0, 42)
		bb.StudsOffset = _V3new(0, 4.5, 0)
		bb.AlwaysOnTop = true
		bb.Adornee = head
		bb.Parent = pGui
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, 0, 1, 0)
		lbl.AnchorPoint = Vector2.new(0.5, 0.5)
		lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
		lbl.BackgroundTransparency = 1
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextScaled = true
		lbl.TextColor3 = selectedColor
		lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		lbl.TextStrokeTransparency = 0
		lbl.Text = ""
		lbl.Parent = bb
		local grad = Instance.new("UIGradient", lbl)
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, selectedColor),
			ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, selectedColor),
		})
		grad.Rotation = 45
		grad.Offset = Vector2.new(0, 0)
		return bb, lbl
	end
	local function _ragPunch(lbl, text)
		if not (lbl and lbl.Parent) then
			return
		end
		lbl.Text = text
	end
	local function _startRagCountdown()
		if _ragCountdownRunning then
			return
		end
		_ragCountdownRunning = true
		task.spawn(function()
			local bb, lbl = _getRagBillboard()
			if not bb then
				_ragCountdownRunning = false
				return
			end
			local timeLeft = 2.5
			local step = 0.1
			while timeLeft > 0 and bb.Parent do
				_ragPunch(lbl, string.format("%.1f", timeLeft))
				task.wait(step)
				timeLeft = timeLeft - step
			end
			if bb and bb.Parent then
				_ragPunch(lbl, "READY!")
				task.wait(0.5)
				if bb and bb.Parent then
					bb:Destroy()
				end
			end
			_ragCountdownRunning = false
		end)
	end
	local _wasRagdolled = false
	RunService.Heartbeat:Connect(function()
		local char = LP.Character
		if not char then
			_wasRagdolled = false
			return
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			_wasRagdolled = false
			return
		end
		local st = hum:GetState()
		local inRag = st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll
			or st == Enum.HumanoidStateType.FallingDown
		if inRag and not _wasRagdolled then
			_wasRagdolled = true
			_startRagCountdown()
		elseif not inRag then
			_wasRagdolled = false
		end
	end)
end
local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espConn = nil
local _espLastRun = 0
profileImageCache = {}
local function clearESP()
	for plr in pairs(espHighlightCache) do
		pcall(function()
			espHighlightCache[plr]:Destroy()
		end)
	end
	for plr in pairs(espBillboardCache) do
		pcall(function()
			espBillboardCache[plr]:Destroy()
		end)
	end
	for plr in pairs(espTracerCache) do
		for _, ln in ipairs(espTracerCache[plr]) do
			pcall(function()
				ln.Visible = false
				ln:Remove()
			end)
		end
	end
	espHighlightCache = {}
	espBillboardCache = {}
	espTracerCache = {}
end
local function makeESPTracers()
	if not (Drawing and type(Drawing.new) == "function") then
		return nil
	end
	local color = getThemeColor()
	local outer = Drawing.new("Line")
	outer.Color = color
	outer.Thickness = 2.2
	outer.Transparency = 0.90
	outer.Visible = false
	local mid = Drawing.new("Line")
	mid.Color = color
	mid.Thickness = 1.2
	mid.Transparency = 0.74
	mid.Visible = false
	local core = Drawing.new("Line")
	core.Color = color
	core.Thickness = 0.6
	core.Transparency = 0.10
	core.Visible = false
	return { outer, mid, core }
end
local function updateESP()
	local now = _tick()
	if now - _espLastRun < 0.05 then
		return
	end
	_espLastRun = now
	if not espEnabled then
		clearESP()
		return
	end
	local myChar = LP.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then
		return
	end
	local myPos = myRoot.Position
	local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos)
	local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
	local currentPlayers = _GetPlayersCached()
	local plrSet = {}
	for _, p in ipairs(currentPlayers) do
		plrSet[p] = true
	end
	for plr in pairs(espHighlightCache) do
		if not plrSet[plr] then
			pcall(function()
				espHighlightCache[plr]:Destroy()
			end)
			espHighlightCache[plr] = nil
		end
	end
	for plr in pairs(espBillboardCache) do
		if not plrSet[plr] then
			pcall(function()
				espBillboardCache[plr]:Destroy()
			end)
			espBillboardCache[plr] = nil
		end
	end
	for plr in pairs(espTracerCache) do
		if not plrSet[plr] then
			for _, ln in ipairs(espTracerCache[plr]) do
				pcall(function()
					ln.Visible = false
					ln:Remove()
				end)
			end
			espTracerCache[plr] = nil
		end
	end
	local color = getThemeColor()
	for _, plr in ipairs(currentPlayers) do
		if plr == LP then
			continue
		end
		local char = plr.Character
		if not char then
			if espHighlightCache[plr] then
				pcall(function()
					espHighlightCache[plr]:Destroy()
				end)
				espHighlightCache[plr] = nil
			end
			if espBillboardCache[plr] then
				pcall(function()
					espBillboardCache[plr]:Destroy()
				end)
				espBillboardCache[plr] = nil
			end
			if espTracerCache[plr] then
				for _, ln in ipairs(espTracerCache[plr]) do
					pcall(function()
						ln.Visible = false
					end)
				end
			end
			continue
		end
		local tRoot = char:FindFirstChild("HumanoidRootPart")
		local tHead = char:FindFirstChild("Head")
		local tHum = char:FindFirstChildOfClass("Humanoid")
		local alive = tRoot and tHead and tHum and tHum.Health > 0
		if alive then
			local hl = espHighlightCache[plr]
			if not hl or not hl.Parent or hl.Parent ~= char then
				if hl then
					pcall(function()
						hl:Destroy()
					end)
				end
				hl = Instance.new("Highlight")
				hl.Name = "AmpDuelsESP"
				hl.FillColor = color
				hl.FillTransparency = 0.72
				hl.OutlineColor = color
				hl.OutlineTransparency = 0.05
				hl.Adornee = char
				hl.Parent = char
				espHighlightCache[plr] = hl
			end
			local bb = espBillboardCache[plr]
			if not bb or not bb.Parent then
				if bb then
					pcall(function()
						bb:Destroy()
					end)
				end
				bb = Instance.new("BillboardGui")
				bb.Name = "ProfilePic"
				bb.Size = UDim2.new(0, 56, 0, 56)
				bb.StudsOffset = _V3new(0, 3.8, 0)
				bb.Adornee = tHead
				bb.AlwaysOnTop = true
				bb.Parent = tHead
				local img = Instance.new("ImageLabel", bb)
				img.Size = UDim2.new(1, -6, 1, -6)
				img.Position = UDim2.new(0, 3, 0, 3)
				img.BackgroundTransparency = 1
				img.Image = "rbxassetid://0"
				img.ScaleType = Enum.ScaleType.Fit
				local circle = Instance.new("UICorner", img)
				circle.CornerRadius = UDim.new(1, 0)
				local stroke = Instance.new("UIStroke", img)
				stroke.Color = color
				stroke.Thickness = 1.5
				espBillboardCache[plr] = bb
				task.spawn(function()
					local userId = plr.UserId
					local url = profileImageCache[userId]
					if not url then
						local success, u = pcall(function()
							return Players:GetUserThumbnailAsync(
								userId,
								Enum.ThumbnailType.HeadShot,
								Enum.ThumbnailSize.Size420x420
							)
						end)
						if success and u and u ~= "" then
							url = u
							profileImageCache[userId] = url
						else
							url = "rbxassetid://0"
						end
					end
					if img then
						img.Image = url
					end
				end)
			else
				if bb.Adornee ~= tHead then
					bb.Adornee = tHead
				end
				bb.Enabled = true
			end
			local lines = espTracerCache[plr]
			if not lines then
				lines = makeESPTracers()
				espTracerCache[plr] = lines or {}
			end
			if lines and #lines > 0 then
				local destPos = tRoot.Position
				local pos, onScreen = camera:WorldToViewportPoint(destPos)
				if onScreen and pos.Z > 0 and myOnScreen then
					local tVec = Vector2.new(pos.X, pos.Y)
					for _, ln in ipairs(lines) do
						ln.From = myVec
						ln.To = tVec
						ln.Visible = true
					end
				else
					for _, ln in ipairs(lines) do
						ln.Visible = false
					end
				end
			end
		else
			if espHighlightCache[plr] then
				pcall(function()
					espHighlightCache[plr]:Destroy()
				end)
				espHighlightCache[plr] = nil
			end
			if espBillboardCache[plr] then
				pcall(function()
					espBillboardCache[plr]:Destroy()
				end)
				espBillboardCache[plr] = nil
			end
			if espTracerCache[plr] then
				for _, ln in ipairs(espTracerCache[plr]) do
					pcall(function()
						ln.Visible = false
					end)
				end
			end
		end
	end
end
local function startESPLoop()
	if espConn then
		espConn:Disconnect()
	end
	espConn = RunService.RenderStepped:Connect(updateESP)
end
local function stopESPLoop()
	if espConn then
		espConn:Disconnect()
		espConn = nil
	end
	clearESP()
end
function toggleESP(on)
	espEnabled = on
	if on then
		startESPLoop()
	else
		stopESPLoop()
	end
	if setESPVIsual then
		setESPVIsual(on)
	end
end
local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
	_enemySpeedAcc = _enemySpeedAcc + 1
	if _enemySpeedAcc < 6 then
		return
	end
	_enemySpeedAcc = 0
	local color = getThemeColor()
	local players = _GetPlayersCached()
	for i = 1, #players do
		local player = players[i]
		if player ~= LP then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hrp and hum and hum.Health > 0 then
				local v = hrp.AssemblyLinearVelocity
				local speed = _sqrt(v.X * v.X + v.Z * v.Z)
				local label = enemySpeedLabels[player]
				if not label then
					local head = char:FindFirstChild("Head")
					if head then
						local bb = Instance.new("BillboardGui")
						bb.Size = UDim2.new(0, 100, 0, 25)
						bb.StudsOffset = _V3new(0, 5.5, 0)
						bb.AlwaysOnTop = true
						bb.Name = "EnemySpeedGui"
						bb.Parent = head
						local tl = Instance.new("TextLabel", bb)
						tl.Size = UDim2.new(1, 0, 1, 0)
						tl.BackgroundTransparency = 1
						tl.TextColor3 = color
						tl.Font = Enum.Font.GothamBold
						tl.TextScaled = true
						tl.TextStrokeTransparency = 0
						tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						enemySpeedLabels[player] = tl
						label = tl
					end
				elseif label.Parent and label.Parent.Parent ~= char then
					local head = char:FindFirstChild("Head")
					if head then
						label.Parent.Parent = head
					end
				end
				if label then
					label.Text = string.format("%.1f", speed)
					if label.TextColor3 ~= color then
						label.TextColor3 = color
					end
				end
			else
				local label = enemySpeedLabels[player]
				if label and label.Parent and label.Parent.Parent then
					label.Parent.Parent = nil
				end
				enemySpeedLabels[player] = nil
			end
		end
	end
end
function startEnemySpeed()
	if enemySpeedConn then
		enemySpeedConn:Disconnect()
	end
	enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end
function stopEnemySpeed()
	if enemySpeedConn then
		enemySpeedConn:Disconnect()
		enemySpeedConn = nil
	end
end
local function getClosestTargetBody()
	local char = LP.Character
	if not char then
		return nil
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	local rpos = root.Position
	local closest, minDist = nil, _huge
	local plist = _GetPlayersCached()
	for i = 1, #plist do
		local plr = plist[i]
		if plr ~= LP then
			local c = plr.Character
			if c then
				local tRoot = c:FindFirstChild("HumanoidRootPart")
				if tRoot then
					local hum = c:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						local dx = tRoot.Position.X - rpos.X
						local dy = tRoot.Position.Y - rpos.Y
						local dz = tRoot.Position.Z - rpos.Z
						local d = dx * dx + dy * dy + dz * dz
						if d < minDist then
							minDist = d
							closest = tRoot
						end
					end
				end
			end
		end
	end
	return closest
end
local function _bodyLockTick()
	local char = LP.Character
	if not char then
		return
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	local target = getClosestTargetBody()
	if not target then
		if not hum.AutoRotate then
			hum.AutoRotate = true
		end
		return
	end
	local dist = (target.Position - root.Position).Magnitude
	if dist > bodyLockRange then
		if not hum.AutoRotate then
			hum.AutoRotate = true
		end
		return
	end
	if hum.AutoRotate then
		hum.AutoRotate = false
	end
	local targetVel = target.AssemblyLinearVelocity
	local speed3 = targetVel.Magnitude
	local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
	local predictedPos = target.Position + targetVel * predictTime
	local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
	local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
	local myHeight = root.Position.Y + (hum.HipHeight or 0)
	local heightDiff = targetHeight - myHeight
	local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
	local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
	local toPredict = flatTarget - root.Position
	if toPredict.Magnitude > 0.1 then
		local goalCF = _CFlookAt(root.Position, flatTarget)
		local diffCF = root.CFrame:Inverse() * goalCF
		local _, ry, _ = diffCF:ToEulerAnglesXYZ()
		ry = _clamp(ry, -2.5, 2.5)
		root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
	end
end
function startBodyLock()
	if _bodyLockConn then
		_bodyLockConn:Disconnect()
	end
	local acc = 0
	_bodyLockConn = RunService.Heartbeat:Connect(function(dt)
		if not bodyLockEnabled then
			return
		end
		if _blSuppressCount > 0 then
			return
		end
		acc = acc + dt
		if acc < 0.033 then
			return
		end
		acc = 0
		_bodyLockTick()
	end)
end
function stopBodyLock()
	if _bodyLockConn then
		_bodyLockConn:Disconnect()
		_bodyLockConn = nil
	end
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyAngularVelocity = _V3zero
		root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
	end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then
		hum2.AutoRotate = true
	end
end
function _suppressBodyLock()
	_blSuppressCount = _blSuppressCount + 1
	if _blSuppressCount == 1 and bodyLockEnabled then
		_blWasEnabled = true
		stopBodyLock()
		if bodyLockSetVisual then
			bodyLockSetVisual(false)
		end
		if _blRestoreTimer then
			task.cancel(_blRestoreTimer)
			_blRestoreTimer = nil
		end
		_blSmoothRestore = false
	end
end
function _unsuppressBodyLock(delayed)
	if _blSuppressCount > 0 then
		_blSuppressCount = _blSuppressCount - 1
	end
	if _blSuppressCount == 0 and _blWasEnabled then
		_blWasEnabled = false
		if _blRestoreTimer then
			pcall(task.cancel, _blRestoreTimer)
			_blRestoreTimer = nil
		end
		local function restore()
			_blRestoreTimer = nil
			if bodyLockEnabled then
				_blSmoothRestore = true
				startBodyLock()
				if bodyLockSetVisual then
					bodyLockSetVisual(true)
				end
				task.delay(0.5, function()
					_blSmoothRestore = false
				end)
			end
		end
		if delayed then
			_blRestoreTimer = task.delay(1, restore)
		else
			restore()
		end
	end
end
function setupSpeedIndicator(char)
	local head = char:WaitForChild("Head", 5)
	if not head then
		return
	end
	local oldBB = head:FindFirstChild("AmpDuelsSpeedIndicator")
	if oldBB then
		oldBB:Destroy()
	end
	local bb = Instance.new("BillboardGui", head)
	bb.Name = "AmpDuelsSpeedIndicator"
	bb.Size = UDim2.new(0, 120, 0, 32)
	bb.StudsOffset = _V3new(0, 3.2, 0)
	bb.AlwaysOnTop = true
	speedLabel = Instance.new("TextLabel", bb)
	speedLabel.Size = UDim2.new(1, 0, 1, 0)
	speedLabel.Position = UDim2.new(0, 0, 0, 0)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "Spd: 0.0"
	speedLabel.TextColor3 = getThemeColor()
	speedLabel.Font = Enum.Font.GothamBold
	speedLabel.TextScaled = true
	speedLabel.TextStrokeTransparency = 0
	speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	applyShimmerToText(speedLabel, 0.9)
	local discordBB = head:FindFirstChild("DiscordText")
	if discordBB then
		discordBB:Destroy()
	end
	discordBB = Instance.new("BillboardGui", head)
	discordBB.Name = "DiscordText"
	discordBB.Size = UDim2.new(0, 200, 0, 28)
	discordBB.StudsOffset = _V3new(0, 5.2, 0)
	discordBB.AlwaysOnTop = true
	local discordLabel = Instance.new("TextLabel", discordBB)
	discordLabel.Size = UDim2.new(1, 0, 1, 0)
	discordLabel.BackgroundTransparency = 1
	discordLabel.Text = "https://discord.gg/5PPAkssV9"
	discordLabel.TextColor3 = getThemeColor()
	discordLabel.Font = Enum.Font.GothamBold
	discordLabel.TextScaled = true
	discordLabel.TextStrokeTransparency = 0
	discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	applyShimmerToText(discordLabel, 0.9)
end
local unwalkSavedAnimate = nil
function startUnwalk()
	local c = LP.Character
	if not c then
		return
	end
	local hum = c:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
			pcall(function()
				t:Stop()
			end)
		end
	end
	local anim = c:FindFirstChild("Animate")
	if anim then
		unwalkSavedAnimate = anim:Clone()
		anim:Destroy()
	end
end
function stopUnwalk()
	local c = LP.Character
	if c then
		local existing = c:FindFirstChild("Animate")
		if not existing then
			local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
			local starterAnim = src and src:FindFirstChild("Animate")
			if starterAnim then
				starterAnim:Clone().Parent = c
			elseif unwalkSavedAnimate then
				unwalkSavedAnimate:Clone().Parent = c
			end
		end
	end
	unwalkSavedAnimate = nil
end
function refreshSpeedModeLabel()
	if modeValLbl then
		if laggerCarryToggled then
			modeValLbl.Text = "Lagger Carry"
		elseif laggerToggled then
			modeValLbl.Text = "Lagger"
		elseif speedMode then
			modeValLbl.Text = "Carry"
		else
			modeValLbl.Text = "Normal"
		end
	end
	if setCarryModeVisual then
		setCarryModeVisual(speedMode)
	end
	if setLaggerModeVisual then
		setLaggerModeVisual(laggerToggled)
	end
	if setLaggerCarryVisual then
		setLaggerCarryVisual(laggerCarryToggled)
	end
end
function resetMovementState()
	refreshSpeedModeLabel()
	if mobSetCarry then
		mobSetCarry(speedMode)
	end
	if setLaggerModeVisual then
		setLaggerModeVisual(laggerToggled)
	end
	if setLaggerCarryVisual then
		setLaggerCarryVisual(laggerCarryToggled)
	end
end
function toggleCarryMode()
	if laggerToggled or laggerCarryToggled then
		laggerToggled = false
		laggerCarryToggled = false
		speedMode = true
	else
		speedMode = not speedMode
	end
	resetMovementState()
end
function toggleLaggerMode()
	if laggerCarryToggled then
		laggerCarryToggled = false
	end
	speedMode = false
	laggerToggled = not laggerToggled
	resetMovementState()
end
function toggleLaggerCarryMode()
	if laggerToggled then
		laggerToggled = false
	end
	speedMode = false
	laggerCarryToggled = not laggerCarryToggled
	resetMovementState()
end
function toggleLaggerCycle()
	if speedMode then
		speedMode = false
		laggerToggled = true
		laggerCarryToggled = false
	elseif laggerToggled then
		speedMode = false
		laggerToggled = false
		laggerCarryToggled = true
	else
		speedMode = true
		laggerToggled = false
		laggerCarryToggled = false
	end
	resetMovementState()
end
function stopAutoLeft()
	if alConn then
		alConn:Disconnect()
		alConn = nil
	end
	alPhase = 1
	local char = LP.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:Move(_V3zero, false)
		end
	end
	if autoLeftSetVisual then
		autoLeftSetVisual(false)
	end
	if mobSetAutoLeft then
		mobSetAutoLeft(false)
	end
	_unsuppressBodyLock(true)
end
function startAutoLeft()
	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
		if autoRightSetVisual then
			autoRightSetVisual(false)
		end
		if mobSetAutoRight then
			mobSetAutoRight(false)
		end
	end
	disableAllAimbots()
	_suppressBodyLock()
	if alConn then
		alConn:Disconnect()
	end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then
			return
		end
		local spd = NS
		if alPhase == 1 then
			local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
			if (tgt - root.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - root.Position
				local mv = _V3new(d.X, 0, d.Z).Unit
				hum:Move(mv, false)
				root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
				return
			end
			local d = AP.L1 - root.Position
			local mv = _V3new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
		elseif alPhase == 2 then
			local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
			if (tgt - root.Position).Magnitude < 1 then
				hum:Move(_V3zero, false)
				root.AssemblyLinearVelocity = _V3zero
				autoLeftEnabled = false
				if alConn then
					alConn:Disconnect()
					alConn = nil
				end
				alPhase = 1
				if autoLeftSetVisual then
					autoLeftSetVisual(false)
				end
				if mobSetAutoLeft then
					mobSetAutoLeft(false)
				end
				_unsuppressBodyLock(true)
				local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
				if (facePos - root.Position).Magnitude > 0.01 then
					root.CFrame = _CFnew(root.Position, facePos)
				end
				return
			end
			local d = AP.L2 - root.Position
			local mv = _V3new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
		end
	end)
end
function stopAutoRight()
	if arConn then
		arConn:Disconnect()
		arConn = nil
	end
	arPhase = 1
	local char = LP.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:Move(_V3zero, false)
		end
	end
	if autoRightSetVisual then
		autoRightSetVisual(false)
	end
	if mobSetAutoRight then
		mobSetAutoRight(false)
	end
	_unsuppressBodyLock(true)
end
function startAutoRight()
	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
		if autoLeftSetVisual then
			autoLeftSetVisual(false)
		end
		if mobSetAutoLeft then
			mobSetAutoLeft(false)
		end
	end
	disableAllAimbots()
	_suppressBodyLock()
	if arConn then
		arConn:Disconnect()
	end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then
			return
		end
		local spd = NS
		if arPhase == 1 then
			local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
			if (tgt - root.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - root.Position
				local mv = _V3new(d.X, 0, d.Z).Unit
				hum:Move(mv, false)
				root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
				return
			end
			local d = AP.R1 - root.Position
			local mv = _V3new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
		elseif arPhase == 2 then
			local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
			if (tgt - root.Position).Magnitude < 1 then
				hum:Move(_V3zero, false)
				root.AssemblyLinearVelocity = _V3zero
				autoRightEnabled = false
				if arConn then
					arConn:Disconnect()
					arConn = nil
				end
				arPhase = 1
				if autoRightSetVisual then
					autoRightSetVisual(false)
				end
				if mobSetAutoRight then
					mobSetAutoRight(false)
				end
				_unsuppressBodyLock(true)
				local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
				if (facePos - root.Position).Magnitude > 0.01 then
					root.CFrame = _CFnew(root.Position, facePos)
				end
				return
			end
			local d = AP.R2 - root.Position
			local mv = _V3new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
		end
	end)
end
function getClosestTarget()
	local char = LP.Character
	if not char then
		return nil
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	local rpos = root.Position
	local closest, minDist = nil, _huge
	local plist = _GetPlayersCached()
	for i = 1, #plist do
		local plr = plist[i]
		if plr ~= LP then
			local c = plr.Character
			if c then
				local tRoot = c:FindFirstChild("HumanoidRootPart")
				if tRoot then
					local hum = c:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						local dx = tRoot.Position.X - rpos.X
						local dy = tRoot.Position.Y - rpos.Y
						local dz = tRoot.Position.Z - rpos.Z
						local d = dx * dx + dy * dy + dz * dz
						if d < minDist then
							minDist = d
							closest = tRoot
						end
					end
				end
			end
		end
	end
	return closest
end
function trySwing()
	pcall(function()
		local char = LP.Character
		if not char then
			return
		end
		local currentTool = char:FindFirstChildOfClass("Tool")
		if currentTool and not isBatTool(currentTool) then
			return
		end
		local bat = findBat()
		if bat then
			if bat.Parent ~= char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function()
						hum:EquipTool(bat)
					end)
				end
			end
			pcall(function()
				bat:Activate()
			end)
		end
	end)
end
-- Clean bat bypass integrated with AMP lifecycle and controls.
do
	-- ============================================================
	-- Anti Bat bypass (from Rival Hub / Clean Anti Bat)
	-- Spoofs velocity each Heartbeat so bat hits desync; restores after
	-- ============================================================
	local AntiBat = { Connection = nil, aimbotOwned = false }
	local ANTIBAT_RANGE = 4000
	local antiBatEnabled = false

	function stopAntiBat()
		antiBatEnabled = false
		AntiBat.aimbotOwned = false
		if AntiBat.Connection then
			pcall(function()
				AntiBat.Connection:Disconnect()
			end)
			AntiBat.Connection = nil
		end
	end

	function startAntiBat(fromAimbot)
		if antiBatEnabled and AntiBat.Connection then
			if fromAimbot then
				AntiBat.aimbotOwned = true
			end
			return
		end
		stopAntiBat()
		antiBatEnabled = true
		if fromAimbot then
			AntiBat.aimbotOwned = true
		end

		AntiBat.Connection = RunService.Heartbeat:Connect(function()
			if not antiBatEnabled then
				return
			end
			local character = LP.Character
			if not character then
				return
			end
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if not hrp then
				return
			end
			local hum = character:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health <= 0 then
				return
			end

			-- Save real velocity, spoof huge horizontal pulse, restore next frame
			local ok, v = pcall(function()
				return hrp.AssemblyLinearVelocity
			end)
			if not ok or not v then
				ok, v = pcall(function()
					return hrp.Velocity
				end)
			end
			if not ok or not v then
				return
			end

			local spoof =
				Vector3.new(math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE), v.Y, math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE))
			pcall(function()
				hrp.AssemblyLinearVelocity = spoof
			end)
			pcall(function()
				hrp.Velocity = spoof
			end)

			RunService.RenderStepped:Wait()
			if hrp and hrp.Parent then
				pcall(function()
					local y = hrp.AssemblyLinearVelocity.Y
					hrp.AssemblyLinearVelocity = Vector3.new(v.X, y, v.Z)
				end)
				pcall(function()
					hrp.Velocity = Vector3.new(v.X, hrp.Velocity.Y, v.Z)
				end)
			end
		end)
	end

	-- Restart on respawn if still enabled
	pcall(function()
		LP.CharacterAdded:Connect(function()
			task.wait(0.3)
			if antiBatEnabled then
				local owned = AntiBat.aimbotOwned
				startAntiBat(owned)
			end
		end)
	end)

	local batBypass = {}
	local previousHumanoid, previousAutoRotate
	local pingElapsed = 0
	local bodyLockOwned = false
	local function releaseRotation()
	    if previousHumanoid and previousHumanoid.Parent then
	        previousHumanoid.AutoRotate = previousAutoRotate
	    end
	    previousHumanoid, previousAutoRotate = nil, nil
	end
	local function ownRotation(humanoid)
	    if previousHumanoid ~= humanoid then
	        releaseRotation()
	        previousHumanoid, previousAutoRotate = humanoid, humanoid.AutoRotate
	    end
	    humanoid.AutoRotate = false
	end
	batBypass.Enabled = batBypass.Enabled or false
	batBypass.Connection = batBypass.Connection or nil
	batBypass.Z = batBypass.Z
	    or {
	        targetPlayer = nil,
	        lastTargetPos = nil,
	        targetVelocity = Vector3.zero,
	        smoothedVelocity = Vector3.zero,
	        velocityHistory = {},
	        accelerationHistory = {},
	        aerialVelocityHistory = {},
	        previousDirection = nil,
	        lastDirectionChangeTime = 0,
	        airborneTime = 0,
	        lastActivationTime = 0,
	        currentPing = 0.1,
	        realPingMs = 0,
	    }
	batBypass.ZCFG = batBypass.ZCFG
	    or {
	        FOLLOW_SPEED = BYPASS_AIMBOT_SPEED,
	        ACTIVATE_DISTANCE = 13,
	        MIN_FOLLOW_DISTANCE = 1,
	        PREDICTION_TIME = 0.22,
	        PREDICT_AHEAD = 3,
	        MAX_VELOCITY_CHANGE = 150,
	        VELOCITY_SMOOTHING = 0.2,
	        MAX_HORIZONTAL_VELOCITY = 80,
	        SERVER_TICKRATE = 0.016666666666666666,
	        MIN_PING_COMPENSATION = 0.03,
	        MAX_PING_COMPENSATION = 0.25,
	        ACCELERATION_PREDICTION_WEIGHT = 0.3,
	        DIRECTION_CHANGE_DETECTION_TIME = 0.12,
	        QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
	        GRAVITY = 196.2,
	        AIR_CONTROL_FACTOR = 0.8,
	        MIN_AIRBORNE_TIME = 0.08,
	    }
	local function averageVectors(vectors)
	    if #vectors == 0 then
	        return Vector3.zero
	    end
	    local sum = Vector3.zero
	    for _, entry in ipairs(vectors) do
	        sum += entry
	    end
	    return sum / #vectors
	end
	local function pushBounded(history, entry, maxEntries)
	    table.insert(history, entry)
	    if #history > maxEntries then
	        table.remove(history, 1)
	    end
	end
	batBypass.FindBat = function()
	    local character = LP.Character
	    if not character then
	        return nil
	    end
	    local tool = character:FindFirstChildOfClass("Tool")
	    if tool then
	        local lowercaseText = tool.Name:lower()
	        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
	            return tool
	        end
	    end
	    local backpack = LP:FindFirstChildOfClass("Backpack")
	    if backpack then
	        for _, child in ipairs(backpack:GetChildren()) do
	            if child:IsA("Tool") then
	                local lowercaseText = child.Name:lower()
	                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
	                    return child
	                end
	            end
	        end
	    end
	    return nil
	end
	local function resetPredictionState()
	    local z = batBypass.Z
	    z.targetPlayer = nil
	    z.lastTargetPos = nil
	    z.targetVelocity = Vector3.zero
	    z.smoothedVelocity = Vector3.zero
	    z.velocityHistory = {}
	    z.accelerationHistory = {}
	    z.aerialVelocityHistory = {}
	    z.previousDirection = nil
	    z.airborneTime = 0
	end
	local function findClosestPlayer(rootPart)
	    local closestDistance = math.huge
	    local closestPlayer = nil
	    for _, player in ipairs(Players:GetPlayers()) do
	        if player ~= LP and player.Character then
	            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
	            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	            if humanoidRootPart and humanoid and humanoid.Health > 0 then
	                local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
	                if magnitude < closestDistance then
	                    closestDistance = magnitude
	                    closestPlayer = player
	                end
	            end
	        end
	    end
	    return closestPlayer
	end
	local function applyAngularAim(rootPart, direction)
	    if direction.Magnitude < 0.01 then
	        return
	    end
	    local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
	    local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
	    rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
	        or Vector3.zero
	end
	local function updatePing()
	    local ok, result = pcall(function()
	        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	    end)
	    local z = batBypass.Z
	    if ok and type(result) == "number" then
	        z.realPingMs = math.floor(result)
	    end
	    z.currentPing = math.clamp(
	        z.realPingMs / 1000,
	        batBypass.ZCFG.MIN_PING_COMPENSATION,
	        batBypass.ZCFG.MAX_PING_COMPENSATION
	    )
	end
	batBypass.StartBodyLock = function() end
	batBypass.StopBodyLock = function() end
	batBypass.Stop = function()
	    local z = batBypass.Z
	    batBypass.Enabled = false
	    if batBypass.Connection then
	        batBypass.Connection:Disconnect()
	        batBypass.Connection = nil
	    end
	    local character = LP.Character
	    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	    character = character and character:FindFirstChild("HumanoidRootPart")
	    releaseRotation()
	    CarrySystem._batAimbotToggled = false
	    if bodyLockOwned then
	        bodyLockOwned = false
	        _unsuppressBodyLock(true)
	    end
	    if character then
	        character.AssemblyAngularVelocity = Vector3.zero
	    end
	    resetPredictionState()
	    z.lastActivationTime = 0
	end
	batBypass.Start = function()
	    if batBypass.Connection then
	        return
	    end
	    local character = LP.Character
	    local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
	    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	    if not humanoid1387 or not rootPart or humanoid1387.Health <= 0 then
	        return false
	    end
	    batBypass.Enabled = true
	    CarrySystem._batAimbotToggled = true
	    if CarrySystem._lvBoost then
	        CarrySystem._lvBoost.Enabled = false
	    end
	    _suppressBodyLock()
	    bodyLockOwned = true
	    ownRotation(humanoid1387)
	    pcall(updatePing)
	    pingElapsed = 0
	    local tool = batBypass.FindBat()
	    if tool and tool.Parent ~= character then
	        pcall(function()
	            humanoid1387:EquipTool(tool)
	        end)
	    end
	    batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
	        if not batBypass.Enabled or not autoBatV2Enabled then
	            batBypass.Stop()
	            return
	        end
	        local z = batBypass.Z
	        local zcfg = batBypass.ZCFG
	        zcfg.FOLLOW_SPEED = (laggerToggled or laggerCarryToggled) and 40 or BAT_AIMBOT_SPEED
	        pingElapsed += deltaTime
	        if pingElapsed >= 0.5 then
	            pingElapsed = 0
	            pcall(updatePing)
	        end
	        local character2 = LP.Character
	        local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
	        local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
	        if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
	            return
	        end
	        ownRotation(humanoid)
	        rootPart = rootPart1394
	        humanoid1387 = humanoid
	        tool = batBypass.FindBat()
	        if tool and tool.Parent ~= character2 then
	            pcall(humanoid.EquipTool, humanoid, tool)
	        end
	        local nextTarget = findClosestPlayer(rootPart)
	        if nextTarget ~= z.targetPlayer then
	            resetPredictionState()
	        end
	        z.targetPlayer = nextTarget
	        local character3 = z.targetPlayer and z.targetPlayer.Character
	        local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
	        character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
	        if not rootPart1442 or not character3 or character3.Health <= 0 then
	            resetPredictionState()
	            return
	        end
	        local position = rootPart1442.Position
	        local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
	        if z.lastTargetPos then
	            local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
	            local vector = targetVelocity - z.targetVelocity
	            if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
	                targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
	            end
	            local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
	            if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
	                local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
	                targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
	            end
	            pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
	            pushBounded(z.velocityHistory, targetVelocity, 8)
	            z.targetVelocity = targetVelocity
	            z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
	        end
	        z.lastTargetPos = position
	        local isAirborne = character3.FloorMaterial == Enum.Material.Air
	        z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
	        if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
	            pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
	        elseif not isAirborne then
	            z.aerialVelocityHistory = {}
	        end
	        local smoothedVelocity = z.smoothedVelocity
	        if isAirborne and #z.aerialVelocityHistory > 0 then
	            local vector = averageVectors(z.aerialVelocityHistory)
	            smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
	        end
	        local changedDirectionQuickly = false
	        local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
	        if vector3.Magnitude > 5 then
	            local unit = vector3.Unit
	            if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
	                local lastDirectionChangeTime = z.lastDirectionChangeTime
	                changedDirectionQuickly = tick() - lastDirectionChangeTime
	                    < zcfg.DIRECTION_CHANGE_DETECTION_TIME
	                z.lastDirectionChangeTime = tick()
	            end
	            z.previousDirection = unit
	        end
	        local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
	        if changedDirectionQuickly then
	            predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
	        end
	        local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
	        local predictedPosition = position
	            + smoothedVelocity * predictionTime
	            + averageVectors(z.accelerationHistory)
	                * accelerationPredictionWeight
	                * predictionTime
	                * predictionTime
	                * 0.5
	        local leadTime = zcfg.PREDICTION_TIME * 1.1
	        local leadPosition
	        if isAirborne then
	            leadPosition = predictedPosition
	                + smoothedVelocity * leadTime
	                + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
	        else
	            leadPosition = predictedPosition + smoothedVelocity * leadTime
	        end
	        local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
	        if vector4.Magnitude > 1 then
	            leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
	        end
	        local targetDirection = leadPosition - rootPart.Position
	        applyAngularAim(rootPart, targetDirection)
	        local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
	        if withinActivationRange then
	            local lastActivationTime = z.lastActivationTime
	            withinActivationRange = tick() - lastActivationTime >= 0.3
	        end
	        if withinActivationRange and autoBatV2SwingEnabled then
	            if tool then
	                pcall(tool.Activate, tool)
	            end
	            z.lastActivationTime = tick()
	        end
	        if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
	            rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
	        else
	            rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
	        end
	    end)
	    return true
	end
	batBypass.Toggle = function()
	    if batBypass.Enabled then
	        batBypass.Stop()
	    else
	        batBypass.Start()
	    end
	end
	function stopAimbotAdapt()
	    batBypass.Stop()
	end
	function startAimbotAdapt()
	    return batBypass.Start()
	end
	end

function disableAutoBat()
	autoBatEnabled = false
	if autoBatSetVisual then
		autoBatSetVisual(false)
	end
	if mobSetAutoBat then
		mobSetAutoBat(false)
	end
	stopAimbotAdapt()
end
function enableAutoBat()
	-- Legacy Auto Bat is disabled; use Clean Bat Bypass instead.
	autoBatEnabled = false
	if autoBatSetVisual then
		autoBatSetVisual(false)
	end
	if mobSetAutoBat then
		pcall(mobSetAutoBat, false)
	end
end
local function startBatV2Aimbot()
	return startAimbotAdapt()
end
local function stopBatV2Aimbot()
	stopAimbotAdapt()
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
	end
	autoBatV2HitCooldown = false
end
function enableBatV2()
	if autoBatV2Enabled then
		return
	end
	if autoBatEnabled then
		disableAutoBat()
	end
	if batDesyncTpEnabled then
		toggleBatDesyncTp()
	end
	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
		if autoLeftSetVisual then
			autoLeftSetVisual(false)
		end
		if mobSetAutoLeft then
			mobSetAutoLeft(false)
		end
	end
	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
		if autoRightSetVisual then
			autoRightSetVisual(false)
		end
		if mobSetAutoRight then
			mobSetAutoRight(false)
		end
	end
	autoBatV2Enabled = true
    if startBatV2Aimbot() == false then
        autoBatV2Enabled = false
        if autoBatV2SetVisual then
            autoBatV2SetVisual(false)
        end
        return
    end
	if autoBatV2SetVisual then
		autoBatV2SetVisual(true)
	end
	if batV2FloatingButton then
		local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
		if btnFrame then
			paintFloatingBtn(btnFrame, true)
		end
	end
end
function disableBatV2()
	if not autoBatV2Enabled then
		return
	end
	autoBatV2Enabled = false
	stopBatV2Aimbot()
	if autoBatV2SetVisual then
		autoBatV2SetVisual(false)
	end
	if batV2FloatingButton then
		local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
		if btnFrame then
			paintFloatingBtn(btnFrame, false)
		end
	end
end
function toggleBatV2()
	if autoBatV2Enabled then
		disableBatV2()
	else
		enableBatV2()
	end
    if type(saveAllSettings) == "function" then
        saveAllSettings()
    end
end
local function updateTpBatButtonWithAntiDie(state)
	if tpBatFloatingButton then
		local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
		if btnFrame then
			local label = btnFrame:FindFirstChild("TextLabel")
			local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
			if state then
				btnFrame.BackgroundColor3 = getThemeColor()
				if label then
					label.Text = "TP\nBAT"
					label.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
				if stroke then
					stroke.Color = Color3.fromRGB(255, 255, 255)
					stroke.Thickness = 2.5
				end
			else
				if label then
					label.Text = "TP\nBAT"
				end
				paintFloatingBtn(btnFrame, batDesyncTpEnabled)
			end
		end
	end
end
local batDesyncTpEnabled = false
local batDesyncTpConn = nil
local batDesyncTpSetVisual = nil
local hittingCooldownDesync = false
local _tpBatUnwalkForced = false
local function getBatDesync()
	local char = LP.Character
	if not char then
		return nil
	end
	local tool = char:FindFirstChild("Bat")
	if tool then
		return tool
	end
	local bp2 = LP:FindFirstChild("Backpack")
	if bp2 then
		tool = bp2:FindFirstChild("Bat")
		if tool then
			tool.Parent = char
			return tool
		end
	end
	return nil
end
local function tryHitBatDesync()
	if hittingCooldownDesync then
		return
	end
	hittingCooldownDesync = true
	pcall(function()
		local bat = getBatDesync()
		if bat then
			bat:Activate()
			local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
			if ev then
				ev:FireServer()
			end
		end
	end)
	task.delay(0.08, function()
		hittingCooldownDesync = false
	end)
end
local function getClosestPlayerDesync()
	local char = LP.Character
	if not char then
		return nil, _huge
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return nil, _huge
	end
	local hpos = hrp.Position
	local cp, cd = nil, _huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local tr = p.Character:FindFirstChild("HumanoidRootPart")
			if tr then
				local d = (hpos - tr.Position).Magnitude
				if d < cd then
					cd = d
					cp = p
				end
			end
		end
	end
	return cp, cd
end
local function batDesyncTpUpdate()
	if not batDesyncTpEnabled then
		stopBatDesyncTp()
		return
	end
	local char = LP.Character
	if not char then
		return
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end
	local target = getClosestPlayerDesync()
	if target and target.Character then
		local tr = target.Character:FindFirstChild("HumanoidRootPart")
		if tr then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
				end)
			end
			local targetPos = tr.Position + _V3new(0, 0.9, 0)
			if (hrp.Position - targetPos).Magnitude > 8 then
				hrp.CFrame = _CFnew(targetPos)
			end
			local cam = workspace.CurrentCamera
			if cam then
				cam.CFrame = _CFnew(cam.CFrame.Position, tr.Position)
			end
			tryHitBatDesync()
		end
	end
end
function startBatDesyncTp()
	if batDesyncTpConn then
		return
	end
	if not unwalkEnabled then
		startUnwalk()
		unwalkEnabled = true
		_tpBatUnwalkForced = true
		if setUnwalkVisual then
			setUnwalkVisual(true)
		end
	end
	batDesyncTpEnabled = true
	batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
	if batDesyncTpSetVisual then
		batDesyncTpSetVisual(true)
	end
	updateTpBatButtonWithAntiDie(true)
end
function stopBatDesyncTp()
	if batDesyncTpConn then
		batDesyncTpConn:Disconnect()
		batDesyncTpConn = nil
	end
	batDesyncTpEnabled = false
	if _tpBatUnwalkForced then
		stopUnwalk()
		unwalkEnabled = false
		_tpBatUnwalkForced = false
		if setUnwalkVisual then
			setUnwalkVisual(false)
		end
	end
	if batDesyncTpSetVisual then
		batDesyncTpSetVisual(false)
	end
	updateTpBatButtonWithAntiDie(false)
end
function toggleBatDesyncTp()
	if batDesyncTpEnabled then
		stopBatDesyncTp()
		updateTpBatButtonWithAntiDie(false)
	else
		disableAllAimbots()
		if autoLeftEnabled then
			autoLeftEnabled = false
			stopAutoLeft()
			if autoLeftSetVisual then
				autoLeftSetVisual(false)
			end
			if mobSetAutoLeft then
				mobSetAutoLeft(false)
			end
		end
		if autoRightEnabled then
			autoRightEnabled = false
			stopAutoRight()
			if autoRightSetVisual then
				autoRightSetVisual(false)
			end
			if mobSetAutoRight then
				mobSetAutoRight(false)
			end
		end
		startBatDesyncTp()
		updateTpBatButtonWithAntiDie(true)
	end
	if batDesyncTpSetVisual then
		batDesyncTpSetVisual(batDesyncTpEnabled)
	end
	saveAllSettings()
end
function findBat()
	local char = LP.Character
	if not char then
		return nil
	end
	for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
		local t = char:FindFirstChild(name)
		if t and t:IsA("Tool") then
			return t
		end
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
			local t = bp:FindFirstChild(name)
			if t and t:IsA("Tool") then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function()
						hum:EquipTool(t)
					end)
				end
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
function isBatTool(tool)
	if not tool then
		return false
	end
	for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
		if tool.Name == name then
			return true
		end
	end
	return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end
function findBatForCounter()
	local char = LP.Character
	if not char then
		return nil
	end
	local backpack = LP:FindFirstChildOfClass("Backpack")
	for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
		local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
		if tool then
			return tool
		end
	end
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
			return child
		end
	end
	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
				return child
			end
		end
	end
	return nil
end
function swingBatForCounter(bat, character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if bat.Parent ~= character and humanoid then
		pcall(function()
			humanoid:EquipTool(bat)
		end)
		task.wait(0.05)
	end
	local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
	if remote and remote:IsA("RemoteEvent") then
		pcall(function()
			remote:FireServer()
		end)
		task.wait(0.1)
		pcall(function()
			remote:FireServer()
		end)
	else
		pcall(function()
			bat:Activate()
		end)
		task.wait(0.1)
		pcall(function()
			bat:Activate()
		end)
	end
end
batCounterDebounce = false
function stopBatCounter()
	if Conns.batCounter then
		Conns.batCounter:Disconnect()
		Conns.batCounter = nil
	end
	batCounterDebounce = false
end
function startBatCounter()
	if Conns.batCounter then
		return
	end
	Conns.batCounter = RunService.Heartbeat:Connect(function()
		if not batCounterEnabled then
			return
		end
		if batCounterDebounce then
			return
		end
		local character = LP.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local state = humanoid:GetState()
		if
			state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown
		then
			batCounterDebounce = true
			_suppressBodyLock()
			task.spawn(function()
				task.wait(0.15)
				local bat = findBatForCounter()
				if bat then
					swingBatForCounter(bat, character)
				end
				task.wait(0.3)
				batCounterDebounce = false
				_unsuppressBodyLock(true)
			end)
		end
	end)
end
function findMedusa()
	local c = LP.Character
	if not c then
		return nil
	end
	for _, t in ipairs(c:GetChildren()) do
		if t:IsA("Tool") then
			local n = t.Name:lower()
			if n:find("medusa") or n:find("head") or n:find("stone") then
				return t
			end
		end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") then
				local n = t.Name:lower()
				if n:find("medusa") or n:find("head") or n:find("stone") then
					return t
				end
			end
		end
	end
	return nil
end
function useMedusaCounter()
	if medusaDebounce then
		return
	end
	if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then
		return
	end
	local c = LP.Character
	if not c then
		return
	end
	medusaDebounce = true
	local med = findMedusa()
	if not med then
		medusaDebounce = false
		return
	end
	if med.Parent ~= c then
		local hum2 = c:FindFirstChildOfClass("Humanoid")
		if hum2 then
			hum2:EquipTool(med)
		end
	end
	pcall(function()
		med:Activate()
	end)
	medusaLastUsed = _tick()
	medusaDebounce = false
end
function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
		if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
			useMedusaCounter()
		end
	end)
end
function setupMedusaCounter(char)
	for _, c in pairs(Conns.anchor) do
		pcall(function()
			c:Disconnect()
		end)
	end
	Conns.anchor = {}
	if not char or not medusaCounterEnabled then
		return
	end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			table.insert(Conns.anchor, onAnchorChanged(part))
		end
	end
	table.insert(
		Conns.anchor,
		char.DescendantAdded:Connect(function(part)
			if part:IsA("BasePart") then
				table.insert(Conns.anchor, onAnchorChanged(part))
			end
		end)
	)
end
function stopMedusaCounter()
	for _, c in pairs(Conns.anchor) do
		pcall(function()
			c:Disconnect()
		end)
	end
	Conns.anchor = {}
end
local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil
function stopDropBrainrot()
	dropActive = false
	if _dropConn then
		_dropConn:Disconnect()
		_dropConn = nil
	end
	for _, t in ipairs(dropConnections) do
		if type(t) == "thread" then
			pcall(task.cancel, t)
		elseif type(t) == "RBXScriptConnection" then
			pcall(t.Disconnect, t)
		end
	end
	dropConnections = {}
	local c = LP.Character
	if c then
		local root = c:FindFirstChild("HumanoidRootPart")
		if root then
			root.AssemblyLinearVelocity = _V3zero
		end
	end
	if dropBrainrotSetVisual then
		dropBrainrotSetVisual(false)
	end
	if mobSetDropBR then
		mobSetDropBR(false)
	end
end
function runDropBrainrot()
	if dropActive then
		return
	end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then
		return
	end
	if dropMode == 1 then
		local speedH = 0
		if root then
			local vel = root.AssemblyLinearVelocity
			speedH = _V3new(vel.X, 0, vel.Z).Magnitude
		end
		local cooldown = (speedH > 5) and 0.6 or 0.25
		if _tick() - lastDropTime < cooldown then
			return
		end
		lastDropTime = _tick()
		dropActive = true
		if dropBrainrotSetVisual then
			dropBrainrotSetVisual(true)
		end
		if mobSetDropBR then
			mobSetDropBR(true)
		end
		local wasAutoBat = false
		if autoBatEnabled then
			wasAutoBat = true
			disableAutoBat()
			if autoBatSetVisual then
				autoBatSetVisual(false)
			end
			if mobSetAutoBat then
				mobSetAutoBat(false)
			end
		end
		local function finishDrop(threadRef)
			if threadRef and dropConnections then
				for i = #dropConnections, 1, -1 do
					if dropConnections[i] == threadRef then
						table.remove(dropConnections, i)
						break
					end
				end
			end
			dropActive = false
			local c = LP.Character
			if c then
				local r = c:FindFirstChild("HumanoidRootPart")
				local h = c:FindFirstChildOfClass("Humanoid")
				if r then
					r.AssemblyLinearVelocity = _V3zero
					r.AssemblyAngularVelocity = _V3zero
					if r.Position.Y < -100 then
						r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
					end
					local rp = RaycastParams.new()
					rp.FilterDescendantsInstances = { c }
					rp.FilterType = Enum.RaycastFilterType.Exclude
					local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
					if rr then
						local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
						r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
					end
					if h and h.Health > 0 then
						h:ChangeState(Enum.HumanoidStateType.Running)
					end
				end
			end
			if wasAutoBat then
				enableAutoBat()
				if autoBatSetVisual then
					autoBatSetVisual(true)
				end
				if mobSetAutoBat then
					mobSetAutoBat(true)
				end
			end
			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(false)
			end
			if mobSetDropBR then
				mobSetDropBR(false)
			end
		end
		local flingThread = nil
		flingThread = task.spawn(function()
			local startTime = _tick()
			while dropActive and (_tick() - startTime) < 0.25 do
				RunService.Heartbeat:Wait()
				local c = LP.Character
				local r = c and c:FindFirstChild("HumanoidRootPart")
				if not r then
					break
				end
				local vel = r.AssemblyLinearVelocity
				vel = _V3new(0, vel.Y, 0)
				r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				if r and r.Parent then
					r.AssemblyLinearVelocity = vel
				end
				RunService.Stepped:Wait()
				if r and r.Parent then
					r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0)
				end
			end
			finishDrop(flingThread)
		end)
		table.insert(dropConnections, flingThread)
		task.delay(0.35, function()
			if dropActive then
				finishDrop(flingThread)
			end
		end)
		return
	end
	dropActive = true
	if dropBrainrotSetVisual then
		dropBrainrotSetVisual(true)
	end
	if mobSetDropBR then
		mobSetDropBR(true)
	end
	local t0 = _tick()
	if _dropConn then
		_dropConn:Disconnect()
	end
	_dropConn = RunService.Heartbeat:Connect(function()
		local c = LP.Character
		local r = c and c:FindFirstChild("HumanoidRootPart")
		if not r then
			if _dropConn then
				_dropConn:Disconnect()
				_dropConn = nil
			end
			dropActive = false
			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(false)
			end
			if mobSetDropBR then
				mobSetDropBR(false)
			end
			return
		end
		if not dropActive then
			if _dropConn then
				_dropConn:Disconnect()
				_dropConn = nil
			end
			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(false)
			end
			if mobSetDropBR then
				mobSetDropBR(false)
			end
			return
		end
		if _tick() - t0 >= DROP_ASCEND_DURATION then
			if _dropConn then
				_dropConn:Disconnect()
				_dropConn = nil
			end
			pcall(function()
				local rp = RaycastParams.new()
				rp.FilterDescendantsInstances = { c }
				rp.FilterType = Enum.RaycastFilterType.Exclude
				local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
				if rr then
					local hum2 = c:FindFirstChildOfClass("Humanoid")
					local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
					r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
					r.AssemblyLinearVelocity = _V3zero
					r.AssemblyAngularVelocity = _V3zero
				end
				if hum2 and hum2.Health > 0 then
					hum2:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
			dropActive = false
			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(false)
			end
			if mobSetDropBR then
				mobSetDropBR(false)
			end
			return
		end
		local lv = r.AssemblyLinearVelocity
		r.AssemblyLinearVelocity = _V3new(lv.X, DROP_ASCEND_SPEED, lv.Z)
	end)
end
function executeDropWithToggle(setVisual)
	if dropActive then
		return
	end
	task.spawn(function()
		if setVisual then
			setVisual(true)
		end
		runDropBrainrot()
		while dropActive do
			task.wait()
		end
		task.wait(0.1)
		if setVisual then
			setVisual(false)
		end
	end)
end
function applyAntiLagDerender(obj)
	pcall(function()
		if obj:IsA("BasePart") then
			obj.Material = Enum.Material.Plastic
			obj.Reflectance = 0
			obj.CastShadow = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 1
		elseif
			obj:IsA("ParticleEmitter")
			or obj:IsA("Trail")
			or obj:IsA("Beam")
			or obj:IsA("Fire")
			or obj:IsA("Smoke")
			or obj:IsA("Sparkles")
		then
			obj.Enabled = false
		elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
			for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
				pcall(function()
					t:Stop(0)
				end)
			end
		end
	end)
end
function enableAntiLag()
	antiLagEnabled = true
	task.spawn(function()
		local descs = workspace:GetDescendants()
		local i = 0
		local total = #descs
		while i < total and antiLagEnabled do
			for _ = 1, 200 do
				i = i + 1
				if i > total then
					break
				end
				applyAntiLagDerender(descs[i])
			end
			task.wait()
		end
	end)
	if antiLagDescConn then
		antiLagDescConn:Disconnect()
	end
	antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
		if antiLagEnabled then
			applyAntiLagDerender(obj)
		end
	end)
end
function disableAntiLag()
	antiLagEnabled = false
	if antiLagDescConn then
		antiLagDescConn:Disconnect()
		antiLagDescConn = nil
	end
end
CUSTOM_FOV_BIND = "soundduelsCustomFOV"
function enableCustomFov()
	local cam = workspace.CurrentCamera
	if cam and origFOV == nil then
		origFOV = cam.FieldOfView
	end
	fovEnabled = true
	if cam then
		pcall(function()
			cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal
		end)
		pcall(function()
			cam.FieldOfView = fovValue
		end)
	end
	if customFovConn then
		customFovConn:Disconnect()
		customFovConn = nil
	end
	pcall(function()
		RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND)
	end)
	local prio = 200
	pcall(function()
		prio = Enum.RenderPriority.Camera.Value + 10
	end)
	local ok = pcall(function()
		RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
			if not fovEnabled then
				return
			end
			local c = workspace.CurrentCamera
			if c and c.FieldOfView ~= fovValue then
				c.FieldOfView = fovValue
			end
		end)
	end)
	if not ok then
		customFovConn = RunService.RenderStepped:Connect(function()
			if not fovEnabled then
				if customFovConn then
					customFovConn:Disconnect()
					customFovConn = nil
				end
				return
			end
			local c = workspace.CurrentCamera
			if c then
				c.FieldOfView = fovValue
			end
		end)
	end
end
function disableCustomFov()
	fovEnabled = false
	pcall(function()
		RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND)
	end)
	if customFovConn then
		customFovConn:Disconnect()
		customFovConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then
		pcall(function()
			cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
		end)
		pcall(function()
			cam.FieldOfView = origFOV or 70
		end)
	end
end
function applyStretchFOV(val)
	local cam = workspace.CurrentCamera
	if cam then
		pcall(function()
			cam.FieldOfView = val
		end)
	end
end
function enableStretch()
	if stretchConn then
		return
	end
	stretchEnabled = true
	local cam = workspace.CurrentCamera
	if not cam then
		return
	end
	origFOV = cam.FieldOfView or 70
	applyStretchFOV(stretchFOV)
	stretchConn = RunService.RenderStepped:Connect(function()
		if not stretchEnabled then
			stretchConn:Disconnect()
			stretchConn = nil
			return
		end
		local c = workspace.CurrentCamera
		if c then
			c.CFrame = c.CFrame * _CFnew(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
		end
	end)
	if stretchFovConn then
		stretchFovConn:Disconnect()
	end
	stretchFovConn = RunService.RenderStepped:Connect(function()
		if stretchEnabled then
			applyStretchFOV(stretchFOV)
		else
			stretchFovConn:Disconnect()
			stretchFovConn = nil
		end
	end)
end
function disableStretch()
	stretchEnabled = false
	if stretchConn then
		stretchConn:Disconnect()
		stretchConn = nil
	end
	if stretchFovConn then
		stretchFovConn:Disconnect()
		stretchFovConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then
		pcall(function()
			cam.FieldOfView = origFOV or 70
		end)
	end
end
local function saveLightingState()
	if _originalLighting then
		return
	end
	_originalLighting = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		GlobalShadows = Lighting.GlobalShadows,
		FogEnd = Lighting.FogEnd,
		FogStart = Lighting.FogStart,
		FogColor = Lighting.FogColor,
		Ambient = Lighting.Ambient,
		ColorCorrection = nil,
		Bloom = nil,
	}
	for _, e in ipairs(Lighting:GetChildren()) do
		if e:IsA("ColorCorrectionEffect") then
			_originalLighting.ColorCorrection = {
				Enabled = e.Enabled,
				Brightness = e.Brightness,
				Contrast = e.Contrast,
				Saturation = e.Saturation,
				TintColor = e.TintColor,
			}
		elseif e:IsA("BloomEffect") then
			_originalLighting.Bloom =
				{ Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold }
		end
	end
end
local function restoreLightingState()
	if not _originalLighting then
		return
	end
	local old = _originalLighting
	Lighting.Brightness = old.Brightness
	Lighting.ClockTime = old.ClockTime
	Lighting.OutdoorAmbient = old.OutdoorAmbient
	Lighting.GlobalShadows = old.GlobalShadows
	Lighting.FogEnd = old.FogEnd
	Lighting.FogStart = old.FogStart
	Lighting.FogColor = old.FogColor
	Lighting.Ambient = old.Ambient
	if old.ColorCorrection then
		local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		if cc then
			cc.Enabled = old.ColorCorrection.Enabled
			cc.Brightness = old.ColorCorrection.Brightness
			cc.Contrast = old.ColorCorrection.Contrast
			cc.Saturation = old.ColorCorrection.Saturation
			cc.TintColor = old.ColorCorrection.TintColor
		end
	end
	if old.Bloom then
		local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
		if bloom then
			bloom.Enabled = old.Bloom.Enabled
			bloom.Intensity = old.Bloom.Intensity
			bloom.Size = old.Bloom.Size
			bloom.Threshold = old.Bloom.Threshold
		end
	end
end
SKY_PRESETS_LIST = {
	"Off",
	"Night",
	"Aurora",
	"Sunset",
	"Galaxy",
	"Cyber",
	"Sakura",
	"Pink Night",
	"Blood Moon",
	"Emerald Dawn",
	"Volcanic",
	"Arctic",
	"Midnight Ocean",
	"Vaporwave",
	"Toxic",
	"Solar Eclipse",
	"Hellscape",
	"Heaven",
	"Storm",
	"Sunrise",
	"Deep Space",
	"Lavender Dream",
	"Inferno",
	"Mint Sky",
}
SKY_PRESETS = {
	["Off"] = { kind = "off" },
	["Night"] = {
		clock = 22,
		brightness = 2,
		ambient = { 110, 100, 130 },
		outAmb = { 120, 110, 140 },
		sky = { stars = 4000, moon = 18, sun = 0, moonTex = true },
		atm = { dens = 0.45, color = { 120, 60, 180 }, decay = { 60, 20, 100 }, glare = 0.5, haze = 1.2 },
	},
	["Aurora"] = {
		clock = 14,
		brightness = 3,
		ambient = { 150, 120, 150 },
		outAmb = { 160, 130, 150 },
		atm = { dens = 0.55, color = { 255, 80, 200 }, decay = { 255, 20, 150 }, glare = 2.5, haze = 3 },
		clouds = { cover = 0.7, dens = 0.7, color = { 255, 240, 250 } },
	},
	["Sunset"] = {
		clock = 17.2,
		brightness = 2.5,
		ambient = { 170, 120, 100 },
		outAmb = { 180, 130, 110 },
		sky = { stars = 0, sun = 25, moon = 0 },
		atm = { dens = 0.5, color = { 255, 130, 60 }, decay = { 255, 80, 30 }, glare = 2, haze = 2.5 },
		clouds = { cover = 0.55, dens = 0.55, color = { 255, 200, 140 } },
	},
	["Galaxy"] = {
		clock = 0,
		brightness = 1.5,
		ambient = { 70, 60, 100 },
		outAmb = { 80, 70, 110 },
		sky = { stars = 10000, moon = 30, sun = 0 },
		atm = { dens = 0.15, color = { 40, 20, 80 }, decay = { 20, 10, 50 }, glare = 0.3, haze = 0.5 },
	},
	["Cyber"] = {
		clock = 21,
		brightness = 2.2,
		ambient = { 90, 130, 170 },
		outAmb = { 100, 140, 180 },
		sky = { stars = 2000, moon = 12 },
		atm = { dens = 0.4, color = { 0, 200, 255 }, decay = { 150, 0, 255 }, glare = 2, haze = 2 },
		clouds = { cover = 0.4, dens = 0.6, color = { 100, 200, 255 } },
	},
	["Sakura"] = {
		clock = 11,
		brightness = 3.5,
		ambient = { 170, 150, 160 },
		outAmb = { 180, 160, 170 },
		sky = { sun = 8 },
		atm = { dens = 0.3, color = { 255, 200, 220 }, decay = { 255, 170, 200 }, glare = 1, haze = 1.5 },
		clouds = { cover = 0.6, dens = 0.4, color = { 255, 250, 252 } },
	},
	["Pink Night"] = {
		clock = 23,
		brightness = 2.2,
		ambient = { 120, 60, 110 },
		outAmb = { 140, 70, 120 },
		sky = { stars = 5000, moon = 22, sun = 0, moonTex = true },
		atm = { dens = 0.5, color = { 255, 80, 180 }, decay = { 140, 30, 100 }, glare = 0.7, haze = 1.4 },
		clouds = { cover = 0.3, dens = 0.5, color = { 180, 90, 150 } },
	},
	["Blood Moon"] = {
		clock = 22.5,
		brightness = 1.6,
		ambient = { 130, 40, 40 },
		outAmb = { 150, 50, 50 },
		sky = { stars = 1500, moon = 28, sun = 0, moonTex = true },
		atm = { dens = 0.6, color = { 220, 30, 30 }, decay = { 120, 10, 10 }, glare = 1.4, haze = 2 },
		clouds = { cover = 0.5, dens = 0.7, color = { 120, 30, 30 } },
	},
	["Emerald Dawn"] = {
		clock = 6.5,
		brightness = 2.8,
		ambient = { 130, 170, 140 },
		outAmb = { 140, 180, 150 },
		sky = { sun = 18, moon = 0, stars = 0 },
		atm = { dens = 0.4, color = { 80, 200, 140 }, decay = { 40, 150, 90 }, glare = 1.8, haze = 2.2 },
		clouds = { cover = 0.5, dens = 0.5, color = { 200, 255, 220 } },
	},
	["Volcanic"] = {
		clock = 19,
		brightness = 2,
		ambient = { 180, 80, 40 },
		outAmb = { 200, 90, 50 },
		sky = { stars = 200, sun = 12, moon = 0 },
		atm = { dens = 0.75, color = { 255, 60, 0 }, decay = { 180, 20, 0 }, glare = 3, haze = 3.5 },
		clouds = { cover = 0.8, dens = 0.9, color = { 120, 40, 20 } },
	},
	["Arctic"] = {
		clock = 9,
		brightness = 3.2,
		ambient = { 200, 220, 235 },
		outAmb = { 210, 230, 245 },
		sky = { sun = 10, stars = 0, moon = 0 },
		atm = { dens = 0.3, color = { 180, 220, 255 }, decay = { 140, 200, 240 }, glare = 1.5, haze = 1.8 },
		clouds = { cover = 0.7, dens = 0.6, color = { 250, 253, 255 } },
	},
	["Midnight Ocean"] = {
		clock = 1.5,
		brightness = 1.7,
		ambient = { 60, 90, 130 },
		outAmb = { 70, 100, 140 },
		sky = { stars = 6000, moon = 24, sun = 0, moonTex = true },
		atm = { dens = 0.5, color = { 20, 60, 140 }, decay = { 10, 30, 90 }, glare = 0.6, haze = 1.5 },
	},
	["Vaporwave"] = {
		clock = 19.5,
		brightness = 2.4,
		ambient = { 180, 120, 200 },
		outAmb = { 190, 130, 210 },
		sky = { stars = 1000, moon = 14 },
		atm = { dens = 0.45, color = { 255, 100, 220 }, decay = { 120, 60, 255 }, glare = 2.2, haze = 2.4 },
		clouds = { cover = 0.55, dens = 0.55, color = { 200, 150, 255 } },
	},
	["Toxic"] = {
		clock = 13,
		brightness = 2.5,
		ambient = { 140, 180, 80 },
		outAmb = { 150, 190, 90 },
		atm = { dens = 0.55, color = { 100, 220, 40 }, decay = { 60, 150, 20 }, glare = 1.8, haze = 2.6 },
		clouds = { cover = 0.65, dens = 0.7, color = { 180, 255, 120 } },
	},
	["Solar Eclipse"] = {
		clock = 12,
		brightness = 0.9,
		ambient = { 50, 40, 60 },
		outAmb = { 60, 50, 70 },
		sky = { stars = 3500, sun = 22, moon = 0 },
		atm = { dens = 0.5, color = { 255, 140, 40 }, decay = { 30, 20, 40 }, glare = 2.8, haze = 1.8 },
	},
	["Hellscape"] = {
		clock = 18,
		brightness = 1.8,
		ambient = { 200, 60, 30 },
		outAmb = { 220, 70, 40 },
		sky = { stars = 100, sun = 30, moon = 0 },
		atm = { dens = 0.85, color = { 255, 30, 0 }, decay = { 120, 0, 0 }, glare = 3.5, haze = 4 },
		clouds = { cover = 0.95, dens = 0.95, color = { 80, 20, 10 } },
	},
	["Heaven"] = {
		clock = 12,
		brightness = 4,
		ambient = { 240, 235, 210 },
		outAmb = { 250, 245, 220 },
		sky = { sun = 16, moon = 0, stars = 0 },
		atm = { dens = 0.25, color = { 255, 250, 220 }, decay = { 255, 240, 200 }, glare = 3, haze = 1.5 },
		clouds = { cover = 0.85, dens = 0.5, color = { 255, 255, 255 } },
	},
	["Storm"] = {
		clock = 15,
		brightness = 1.4,
		ambient = { 90, 90, 110 },
		outAmb = { 100, 100, 120 },
		sky = { stars = 0, sun = 6, moon = 0 },
		atm = { dens = 0.65, color = { 80, 90, 120 }, decay = { 40, 50, 80 }, glare = 0.5, haze = 3 },
		clouds = { cover = 0.95, dens = 0.95, color = { 60, 65, 80 } },
	},
	["Sunrise"] = {
		clock = 6.2,
		brightness = 2.8,
		ambient = { 220, 180, 130 },
		outAmb = { 230, 190, 140 },
		sky = { sun = 22, stars = 0, moon = 0 },
		atm = { dens = 0.45, color = { 255, 180, 100 }, decay = { 255, 140, 80 }, glare = 2.4, haze = 2.2 },
		clouds = { cover = 0.4, dens = 0.4, color = { 255, 220, 180 } },
	},
	["Deep Space"] = {
		clock = 0,
		brightness = 1,
		ambient = { 30, 25, 50 },
		outAmb = { 40, 35, 60 },
		sky = { stars = 15000, moon = 0, sun = 0 },
		atm = { dens = 0.08, color = { 15, 5, 40 }, decay = { 5, 0, 20 }, glare = 0.2, haze = 0.3 },
	},
	["Lavender Dream"] = {
		clock = 18.5,
		brightness = 2.6,
		ambient = { 180, 160, 220 },
		outAmb = { 190, 170, 230 },
		sky = { stars = 800, moon = 16, sun = 0 },
		atm = { dens = 0.4, color = { 200, 160, 255 }, decay = { 160, 120, 220 }, glare = 1.4, haze = 1.8 },
		clouds = { cover = 0.55, dens = 0.5, color = { 220, 200, 255 } },
	},
	["Inferno"] = {
		clock = 17.5,
		brightness = 2.2,
		ambient = { 220, 100, 40 },
		outAmb = { 235, 110, 50 },
		sky = { sun = 26, moon = 0, stars = 0 },
		atm = { dens = 0.6, color = { 255, 90, 20 }, decay = { 200, 40, 0 }, glare = 3, haze = 3.2 },
		clouds = { cover = 0.7, dens = 0.7, color = { 200, 80, 40 } },
	},
	["Mint Sky"] = {
		clock = 10,
		brightness = 3.2,
		ambient = { 180, 230, 210 },
		outAmb = { 190, 240, 220 },
		sky = { sun = 10 },
		atm = { dens = 0.32, color = { 150, 255, 210 }, decay = { 100, 220, 180 }, glare = 1.6, haze = 1.6 },
		clouds = { cover = 0.55, dens = 0.45, color = { 240, 255, 250 } },
	},
}
local function _vC3(t)
	return Color3.fromRGB(t[1], t[2], t[3])
end
function _v4mpClearSky()
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute("_AdaptDuelsSky") then
			pcall(function()
				child:Destroy()
			end)
		end
	end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _, child in ipairs(terrain:GetChildren()) do
			if child:GetAttribute("_AdaptDuelsSky") then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end
end
function applyCustomSky(mode)
	_v4mpClearSky()
	local preset = SKY_PRESETS[mode]
	if not preset or preset.kind == "off" then
		Lighting.ClockTime = 14
		Lighting.Brightness = 2
		Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		Lighting.Ambient = Color3.fromRGB(127, 127, 127)
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = true
		skyTheme = "Off"
		return
	end
	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
	Lighting.FogColor = Color3.fromRGB(200, 200, 200)
	Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	Lighting.GlobalShadows = true
	Lighting.ClockTime = preset.clock or 14
	Lighting.Brightness = preset.brightness or 2
	if preset.outAmb then
		Lighting.OutdoorAmbient = _vC3(preset.outAmb)
	end
	if preset.ambient then
		Lighting.Ambient = _vC3(preset.ambient)
	end
	if preset.sky then
		local skyInst = Instance.new("Sky")
		skyInst:SetAttribute("_AdaptDuelsSky", true)
		if preset.sky.stars then
			skyInst.StarCount = preset.sky.stars
		end
		if preset.sky.moon then
			skyInst.MoonAngularSize = preset.sky.moon
		end
		if preset.sky.sun then
			skyInst.SunAngularSize = preset.sky.sun
		end
		if preset.sky.moonTex then
			skyInst.MoonTextureId = "rbxasset://sky/moon.jpg"
		end
		skyInst.Parent = Lighting
	end
	if preset.atm then
		local atm = Instance.new("Atmosphere")
		atm:SetAttribute("_AdaptDuelsSky", true)
		atm.Density = preset.atm.dens or 0.3
		atm.Color = _vC3(preset.atm.color)
		atm.Decay = _vC3(preset.atm.decay)
		atm.Glare = preset.atm.glare or 1
		atm.Haze = preset.atm.haze or 1
		atm.Parent = Lighting
	end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if preset.clouds and terrain then
		local clouds = Instance.new("Clouds")
		clouds:SetAttribute("_AdaptDuelsSky", true)
		clouds.Cover = preset.clouds.cover or 0.5
		clouds.Density = preset.clouds.dens or 0.5
		clouds.Color = _vC3(preset.clouds.color)
		clouds.Parent = terrain
	end
	skyTheme = mode
end
local function applyNeonWeather()
	if not neonWeatherEnabled then
		restoreLightingState()
		return
	end
	if not _originalLighting then
		saveLightingState()
	end
	Lighting.Brightness = 3.5
	Lighting.ClockTime = 20
	Lighting.OutdoorAmbient = Color3.fromRGB(20, 40, 80)
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 300
	Lighting.FogStart = 0
	Lighting.FogColor = Color3.fromRGB(0, 80, 200)
	Lighting.Ambient = Color3.fromRGB(30, 60, 120)
	local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
	if not cc then
		cc = Instance.new("ColorCorrectionEffect")
		cc.Parent = Lighting
	end
	cc.Enabled = true
	cc.Brightness = 0.2
	cc.Contrast = 0.15
	cc.Saturation = 0.15
	cc.TintColor = Color3.fromRGB(181, 181, 181)
	local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
	if not bloom then
		bloom = Instance.new("BloomEffect")
		bloom.Parent = Lighting
	end
	bloom.Enabled = true
	bloom.Intensity = 0.6
	bloom.Size = 25
	bloom.Threshold = 0.8
end
function toggleNeonWeather(state)
	if state == nil then
		neonWeatherEnabled = not neonWeatherEnabled
	else
		neonWeatherEnabled = state
	end
	applyNeonWeather()
	if setNeonWeatherVisual then
		setNeonWeatherVisual(neonWeatherEnabled)
	end
end
local FLOATING_IMAGE_ID = resolveAmpBackground()
local FLOATING_PURPLE = Color3.fromRGB(255, 255, 255)
local function addFloatingImage(btnFrame)
	if not btnFrame or btnFrame:FindFirstChild("FloatingImage") then
		return
	end
	local image = Instance.new("ImageLabel")
	image.Name = "FloatingImage"
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.BackgroundTransparency = 1
	image.Image = FLOATING_IMAGE_ID
	image.ScaleType = Enum.ScaleType.Crop
	image.ZIndex = (btnFrame.ZIndex or 1) + 1
	image.Parent = btnFrame
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = image
end
function paintFloatingBtn(btnFrame, active)
	if not btnFrame then
		return
	end
	addFloatingImage(btnFrame)
	local bg = btnFrame:FindFirstChild("BtnGrad")
	local label = btnFrame:FindFirstChild("TextLabel")
	local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
	local image = btnFrame:FindFirstChild("FloatingImage")
	local PURPLE = Color3.fromRGB(255, 255, 255)
	btnFrame.BackgroundTransparency = 0
	btnFrame.BackgroundColor3 = active and PURPLE or Color3.fromRGB(0, 0, 0)
	if image then
		image.Visible = not active
		image.BackgroundTransparency = 1
		if active then
			image.ImageTransparency = 1
		else
			image.ImageTransparency = 0
		end
	end
	if bg then
		bg.Transparency = active and NumberSequence.new(1) or NumberSequence.new(0)
		if active then
			bg.Enabled = false
		else
			bg.Enabled = true
		end
	end
	if label then
		label.TextColor3 = active and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	end
	if stroke then
		stroke.Color = PURPLE
		stroke.Thickness = active and 2.5 or 2
		stroke.Transparency = 0
	end
end
function applyFloatingButtonScale()
	for _, uiScale in ipairs(_floatingUIScales) do
		if uiScale and uiScale.Parent then
			uiScale.Scale = floatingButtonScale
		end
	end
end
local function drag(f)
	local dn, ds, sp, di = false, nil, nil, nil
	local endConn = nil
	local function stopDrag()
		dn = false
		di = nil
		if endConn then
			endConn:Disconnect()
			endConn = nil
		end
	end
	f.InputBegan:Connect(function(i)
		if uiLocked then
			return
		end
		if _isDraggingButton then
			return
		end
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dn = true
			ds = i.Position
			sp = f.Position
			if endConn then
				endConn:Disconnect()
			end
			endConn = i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					stopDrag()
				end
			end)
		end
	end)
	f.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			stopDrag()
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			stopDrag()
		end
	end)
	f.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			di = i
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if i == di and dn then
			if uiLocked then
				stopDrag()
				return
			end
			if _isDraggingButton then
				return
			end
			if not ds or not sp then
				return
			end
			local nX = sp.X.Offset + (i.Position.X - ds.X)
			local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
			f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
		end
	end)
end
function setupMovementAndIndicators(char)
	if steppedConn then
		steppedConn:Disconnect()
		steppedConn = nil
	end
	if movementLoop then
		movementLoop:Disconnect()
		movementLoop = nil
	end
	local ccAcc = 0
	steppedConn = RunService.Heartbeat:Connect(function(dt)
		ccAcc = ccAcc + dt
		if ccAcc < 0.05 then
			return
		end
		ccAcc = 0
		local plist = _GetPlayersCached()
		for i = 1, #plist do
			local p = plist[i]
			if p ~= LP then
				local ch = p.Character
				if ch then
					local parts = ch:GetChildren()
					for j = 1, #parts do
						local part = parts[j]
						if part:IsA("BasePart") and part.CanCollide then
							part.CanCollide = false
						end
					end
				end
			end
		end
	end)
	movementLoop = RunService.RenderStepped:Connect(function()
		local char2 = LP.Character
		if not char2 then
			return
		end
		local hum = char2:FindFirstChildOfClass("Humanoid")
		local hrp = char2:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then
			return
		end
		if
			not autoBatEnabled
			and not autoLeftEnabled
			and not autoRightEnabled
			and not autoBatV2Enabled
			and not batDesyncTpEnabled
		then
			if _isRagdollState(hum) then
				lastMoveDir = _V3zero
			else
				local md = hum.MoveDirection
				local spd = getActiveMoveSpeed()
				local dir = nil
				if md.Magnitude > 0 then
					lastMoveDir = md
					dir = md
				elseif lastMoveDir.Magnitude > 0 then
					for key in pairs(MOVE_KEYS) do
						if UIS:IsKeyDown(key) then
							dir = lastMoveDir
							break
						end
					end
				end
				_applyVelocitySpeed(dir, spd, hrp)
			end
		end
		if speedLabel then
			local v = hrp.AssemblyLinearVelocity
			local s = _sqrt(v.X * v.X + v.Z * v.Z)
			if s < 0.05 then
				s = 0
			end
			speedLabel.Text = "Speed: " .. string.format("%.1f", s)
		end
	end)
	setupSpeedIndicator(char)
	startEnemySpeed()
end
function toggleLockUI(state)
	if state == nil then
		uiLocked = not uiLocked
	else
		uiLocked = state
	end
	editModeEnabled = not uiLocked
	task.defer(function()
		if setLockUIVisual then
			setLockUIVisual(uiLocked)
		end
	end)
end
function setFloatingButtonsHidden(hidden)
	hideButtonsEnabled = hidden == true
	local targets = {}
	if MobilePanel then
		table.insert(targets, MobilePanel)
	end
	if tpBatFloatingButton then
		table.insert(targets, tpBatFloatingButton)
	end
	if batV2FloatingButton then
		table.insert(targets, batV2FloatingButton)
	end
	if instaResetFloatingButton then
		table.insert(targets, instaResetFloatingButton)
	end
	if hideButtonsEnabled then
		if not savedFloatingVisibility then
			savedFloatingVisibility = {}
		end
		for _, obj in ipairs(targets) do
			if obj and obj.Parent then
				if savedFloatingVisibility[obj] == nil then
					savedFloatingVisibility[obj] = obj.Enabled
				end
				pcall(function()
					obj.Enabled = false
				end)
			end
		end
	else
		for _, obj in ipairs(targets) do
			if obj and obj.Parent then
				local oldState = true
				if savedFloatingVisibility and savedFloatingVisibility[obj] ~= nil then
					oldState = savedFloatingVisibility[obj]
				end
				pcall(function()
					obj.Enabled = oldState
				end)
			end
		end
		savedFloatingVisibility = {}
	end
end

function toggleEditMode(state)
	editModeEnabled = not uiLocked
end
function disableAllAimbots()
	if autoBatEnabled then
		disableAutoBat()
		if autoBatSetVisual then
			autoBatSetVisual(false)
		end
		if mobSetAutoBat then
			mobSetAutoBat(false)
		end
	end
	if batDesyncTpEnabled then
		stopBatDesyncTp()
	end
	if autoBatV2Enabled then
		disableBatV2()
		if autoBatV2SetVisual then
			autoBatV2SetVisual(false)
		end
		if batV2FloatingButton then
			local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
			if btnFrame then
				paintFloatingBtn(btnFrame, false)
			end
		end
	end
end
function stopAllBackgroundTasks()
	if movementLoop then
		movementLoop:Disconnect()
		movementLoop = nil
	end
	if steppedConn then
		steppedConn:Disconnect()
		steppedConn = nil
	end
	stopEnemySpeed()
	if stretchEnabled then
		disableStretch()
	end
	if stretchConn then
		stretchConn:Disconnect()
		stretchConn = nil
	end
	if stretchFovConn then
		stretchFovConn:Disconnect()
		stretchFovConn = nil
	end
	if AntiRagdollV1.isRunning() then
		AntiRagdollV1.stop()
	end
	if AntiRagdollV2.Enabled then
		stopAntiRagdollV2()
	end
	if antiDieEnabled then
		AntiDieModule.stop()
	end
	if antiFlingEnabled then
		AntiFlingShieldModule.stop()
	end
	stopBatCounter()
	stopBatCounterV2()
	stopMedusaCounter()
	stopAutoSteal()
	disableAutoBat()
	if batDesyncTpEnabled then
		stopBatDesyncTp()
	end
	if autoBatV2Enabled then
		disableBatV2()
	end
	stopAutoLeft()
	stopAutoRight()
	if unwalkEnabled and not _tpBatUnwalkForced then
		stopUnwalk()
	end
	if antiLagEnabled then
		disableAntiLag()
	end
	if espEnabled then
		toggleESP(false)
	end
	if dropActive then
		stopDropBrainrot()
	end
	if bodyLockEnabled then
		stopBodyLock()
	end
	_blSuppressCount = 0
	_blWasEnabled = false
	if _blRestoreTimer then
		pcall(task.cancel, _blRestoreTimer)
		_blRestoreTimer = nil
	end
	if _bodyLockConn then
		_bodyLockConn:Disconnect()
		_bodyLockConn = nil
	end
	for _, t in ipairs(dropConnections) do
		if type(t) == "thread" then
			pcall(task.cancel, t)
		elseif type(t) == "RBXScriptConnection" then
			pcall(t.Disconnect, t)
		end
	end
	dropConnections = {}
	dropActive = false
	alPhase = 1
	arPhase = 1
	lastDropTime = 0
	medusaDebounce = false
	medusaLastUsed = 0
end
function buildConfigTable()
	local config = {
		ampStealBarLayoutVersion = 6,
		ampMobileLayoutVersion = 5,
		normalSpeed = NS,
		carrySpeed = CS,
		laggerSpeed1 = LAGGER_SPEED,
		laggerSpeed2 = LAGGER_CARRY_SPEED,
		stealRadius = CONFIG.STEAL_RANGE,
		jumpPower = InfiniteJump.jumpPower,
		jumpHold = InfiniteJump.holdEnabled,
		antiRagdollMode = antiRagdollMode,
		antiDieEnabled = antiDieEnabled,
		autoSteal = CONFIG.AUTO_STEAL_ENABLED,
		medusaCounter = medusaCounterEnabled,
		batCounter = batCounterEnabled,
		batCounterV2 = batCounterV2Enabled,
		laggerToggled = laggerToggled,
		laggerCarryToggled = laggerCarryToggled,
		carryMode = speedMode,
		batAimbotSpeed = BAT_AIMBOT_SPEED,
		dropMode = dropMode,
		stretchEnabled = stretchEnabled,
		stretchFOV = stretchFOV,
		fovEnabled = fovEnabled,
		fovValue = fovValue,
		uiScale = uiScaleValue,
		animPack = currentAnimPack,
		espEnabled = espEnabled,
		antiLag = antiLagEnabled,
		tpBatEnabled = batDesyncTpEnabled,
		neonWeather = neonWeatherEnabled,
		skyTheme = skyTheme,
		autoBatV2Enabled = autoBatV2Enabled,
		autoLeft = autoLeftEnabled,
		autoRight = autoRightEnabled,
		unwalk = unwalkEnabled,
		antiFling = antiFlingEnabled,
		batCounterV3 = batCounterV3Enabled,
		batCounterV3Mode = batCounterV3Mode,
		hideButtons = hideButtonsEnabled,
		mobileButtonPositions = savedButtonPositions,
		dropBrainrotKey = {
			kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name,
			gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name,
		},
		autoLeftKey = { kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name },
		autoRightKey = { kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name },
		autoBatKey = { kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name },
		tpFloorKey = { kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name },
		carryToggleKey = {
			kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name,
			gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name,
		},
		laggerModeKey = { kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp
			and KB.LaggerMode.gp.Name },
		tpBatKey = { kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name },
		batV2Key = { kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name },
		instaResetKey = { kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp
			and KB.InstaReset.gp.Name },
		tpBatFloatingPos = tpBatFloatingPos,
		batV2FloatingPos = batV2FloatingPos,
		instaResetFloatingPos = instaResetFloatingPos,
		bodyLockEnabled = bodyLockEnabled,
		bodyLockRange = bodyLockRange,
		progressBarPos = savedProgressBarPos,
		lockUI = uiLocked,
		editMode = editModeEnabled,
		backgroundIndex = backgroundIndex,
		backgroundImageTransparency = backgroundImageTransparency,
		floatingButtonScale = floatingButtonScale,
		buttonSize = math.floor(floatingButtonScale * 100 + 0.5),
		batSkinEnabled = (_G.KatanaSkinEnabled == true),
		minecraftBatSkinEnabled = (_G.MinecraftBatSkinEnabled == true),
		stealBarScale = stealBarScale,
		themeColor = currentColorTheme,
		useCarrySystem = useCarrySystem,
		carrySysNormal = CarrySystem.normalSpeed,
		carrySysCarry = CarrySystem.carrySpeed,
		carrySysLagger = CarrySystem.laggerSpeed,
		carrySysLaggerCarry = CarrySystem.laggerCarrySpeed,
		carrySysSoftStealSpeed = CarrySystem.softStealSpeed,
		carrySysSoftStealRadius = CarrySystem.softStealRadius,
	}
	if pbFrame then
		config.progressBarPos = {
			XScale = pbFrame.Position.X.Scale,
			XOffset = pbFrame.Position.X.Offset,
			YScale = pbFrame.Position.Y.Scale,
			YOffset = pbFrame.Position.Y.Offset,
		}
	end
	if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
		local container = MobilePanel:FindFirstChild("FloatingPanel")
		config.mobilePanelPos = {
			XScale = container.Position.X.Scale,
			XOffset = container.Position.X.Offset,
			YScale = container.Position.Y.Scale,
			YOffset = container.Position.Y.Offset,
		}
	end
	return config
end
function saveAllSettings()
	if _isResetting then
		return true
	end
	local config = buildConfigTable()
	local json = HS:JSONEncode(config)
	if json == _lastSavedJSON then
		return true
	end
	local success, err = pcall(function()
		writefile(CONFIG_FILE, json)
	end)
	if success then
		_lastSavedJSON = json
	end
	return success
end
function loadAllSettings()
	if not isfile or not isfile(CONFIG_FILE) then
		return false
	end
	local success, data = pcall(function()
		return HS:JSONDecode(readfile(CONFIG_FILE))
	end)
	if not success or not data then
		return false
	end
	_isLoading = true
	NS = data.normalSpeed or NS
	CS = data.carrySpeed or CS
	LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
	LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
	if data.jumpPower then
		InfiniteJump.setJumpPower(data.jumpPower)
		if jumpPowerBox then
			jumpPowerBox.Text = tostring(InfiniteJump.jumpPower)
		end
	end
	if data.jumpHold ~= nil then
		InfiniteJump.holdEnabled = data.jumpHold == true
		if jumpHoldSetVisual then
			jumpHoldSetVisual(InfiniteJump.holdEnabled)
		end
	end
	CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
	if radInput then
		radInput.Text = tostring(CONFIG.STEAL_RANGE)
	end
	uiLocked = data.lockUI or true
	editModeEnabled = not uiLocked
	if data.antiRagdollMode then
		antiRagdollMode = data.antiRagdollMode
	else
		antiRagdollMode = data.antiRagdoll and "v2" or "off"
	end
	antiDieEnabled = data.antiDieEnabled or false
	antiFlingEnabled = data.antiFlingEnabled or false
	CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
	medusaCounterEnabled = data.medusaCounter or false
	batCounterEnabled = data.batCounter or false
	batCounterV2Enabled = data.batCounterV2 or false
	unwalkEnabled = data.unwalk or false
	antiLagEnabled = data.antiLag or false
	laggerToggled = data.laggerToggled or false
	speedMode = data.carryMode or false
	laggerCarryToggled = data.laggerCarryToggled or false
	uiScaleValue = 78
	if mainUIScale then
		mainUIScale.Scale = uiScaleValue / 100
	end
	if pbScale then
		pbScale.Scale = uiScaleValue / 100
	end
	espEnabled = data.espEnabled or false
	if espEnabled then
		toggleESP(true)
	else
		toggleESP(false)
	end
	if COLOR_THEMES["Black & White"] then
		currentColorTheme = "Black & White"
		selectedColor = COLOR_THEMES["Black & White"]
		task.defer(function()
			updateAllUIThemeColors(selectedColor)
			if colorSelectorLabel then
				colorSelectorLabel.Text = currentColorTheme
				colorSelectorLabel.TextColor3 = selectedColor
			end
		end)
	end
	autoBatV2Enabled = data.autoBatV2Enabled or false
	if autoBatV2Enabled then
		task.defer(function()
			enableBatV2()
			if autoBatV2SetVisual then
				autoBatV2SetVisual(true)
			end
		end)
	else
		if autoBatV2SetVisual then
			autoBatV2SetVisual(false)
		end
	end
	local tpBatStateLoaded = data.tpBatEnabled or false
	if tpBatStateLoaded then
		task.defer(function()
			startBatDesyncTp()
			if batDesyncTpSetVisual then
				batDesyncTpSetVisual(true)
			end
			updateTpBatButtonWithAntiDie(true)
		end)
	else
		if batDesyncTpSetVisual then
			batDesyncTpSetVisual(false)
		end
		updateTpBatButtonWithAntiDie(false)
	end
	skyTheme = data.skyTheme or "Off"
	if skyTheme ~= "Off" then
		pcall(applyCustomSky, skyTheme)
	end
	if skySelectorLabel then
		skySelectorLabel.Text = skyTheme
	end
	neonWeatherEnabled = data.neonWeather or false
	if neonWeatherEnabled then
		task.defer(function()
			toggleNeonWeather(true)
		end)
	else
		toggleNeonWeather(false)
		skyTheme = "Off"
		pcall(applyCustomSky, "Off")
		if skySelectorLabel then
			skySelectorLabel.Text = "Off"
		end
	end
	if data.animPack and ANIM_PACKS[data.animPack] then
		startAnimPack(data.animPack)
	else
		currentAnimPack = "Off"
		stopAnimPack()
	end
	local function lk(e, d)
		if not d then
			return
		end
		if d.kb and Enum.KeyCode[d.kb] then
			e.kb = Enum.KeyCode[d.kb]
		end
		if d.gp and Enum.KeyCode[d.gp] then
			e.gp = Enum.KeyCode[d.gp]
		end
	end
	lk(KB.DropBrainrot, data.dropBrainrotKey)
	lk(KB.AutoLeft, data.autoLeftKey)
	lk(KB.AutoRight, data.autoRightKey)
	lk(KB.AutoBat, data.autoBatKey)
	lk(KB.TPFloor, data.tpFloorKey)
	lk(KB.CarryToggle, data.carryToggleKey)
	lk(KB.LaggerMode, data.laggerModeKey)
	lk(KB.TPBat, data.tpBatKey)
	lk(KB.BatV2, data.batV2Key)
	lk(KB.InstaReset, data.instaResetKey)
	if data.ampMobileLayoutVersion == 5 then
		if data.mobileButtonPositions then
			savedButtonPositions = data.mobileButtonPositions
		end
		if data.mobilePanelPos then
			savedMobilePanelPos = data.mobilePanelPos
		end
		if data.tpBatFloatingPos then
			tpBatFloatingPos = data.tpBatFloatingPos
		end
		if data.batV2FloatingPos then
			batV2FloatingPos = data.batV2FloatingPos
		end
		if data.instaResetFloatingPos then
			instaResetFloatingPos = data.instaResetFloatingPos
		end
	end
	if data.ampStealBarLayoutVersion == 6 and data.progressBarPos then
		savedProgressBarPos = data.progressBarPos
	end
	if data.bodyLockEnabled ~= nil then
		bodyLockEnabled = data.bodyLockEnabled
		if bodyLockEnabled then
			task.defer(function()
				if bodyLockSetVisual then
					bodyLockSetVisual(true)
				end
				startBodyLock()
			end)
		end
	end
	if data.bodyLockRange then
		bodyLockRange = data.bodyLockRange
		if bodyLockRangeBox then
			bodyLockRangeBox.Text = tostring(bodyLockRange)
		end
	end
	dropMode = data.dropMode or 1
	stretchEnabled = data.stretchEnabled or false
	fovValue = data.fovValue or 70
	fovEnabled = data.fovEnabled or false
	if fovSliderSet then
		fovSliderSet(fovValue)
	end
	if fovEnabled then
		enableCustomFov()
	end
	if setFovVisual then
		setFovVisual(fovEnabled)
	end
	stretchFOV = data.stretchFOV or 120
	BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
	_G.KatanaSkinEnabled = data.batSkinEnabled == true
	_G.MinecraftBatSkinEnabled = false
	backgroundIndex = 1
	backgroundImageTransparency = 0
	local savedButtonSize = tonumber(data.buttonSize or data.floatingButtonScale and (data.floatingButtonScale * 100))
	if savedButtonSize then
		floatingButtonScale = _clamp(savedButtonSize, 50, 200) / 100
	else
		floatingButtonScale = 1
	end
	stealBarScale = data.stealBarScale or 1
	useCarrySystem = data.useCarrySystem or false
	CarrySystem.normalSpeed = data.carrySysNormal or NS
	CarrySystem.carrySpeed = data.carrySysCarry or CS
	CarrySystem.laggerSpeed = data.carrySysLagger or LAGGER_SPEED
	CarrySystem.laggerCarrySpeed = data.carrySysLaggerCarry or LAGGER_CARRY_SPEED
	CarrySystem.softStealSpeed = data.carrySysSoftStealSpeed or 30
	CarrySystem.softStealRadius = data.carrySysSoftStealRadius or 10
	if useCarrySystem then
		CarrySystem:start()
		CarrySystem.speedToggled = speedMode
		if laggerToggled then
		else
			CarrySystem:setLaggerMode(0)
		end
	else
		CarrySystem:stop()
	end
	autoBatEnabled = false
	autoLeftEnabled = data.autoLeft or false
	autoRightEnabled = data.autoRight or false
	if autoLeftEnabled then
		task.defer(function()
			startAutoLeft()
			if autoLeftSetVisual then
				autoLeftSetVisual(true)
			end
			if mobSetAutoLeft then
				mobSetAutoLeft(true)
			end
		end)
	end
	if autoRightEnabled then
		task.defer(function()
			startAutoRight()
			if autoRightSetVisual then
				autoRightSetVisual(true)
			end
			if mobSetAutoRight then
				mobSetAutoRight(true)
			end
		end)
	end
	if unwalkEnabled then
		task.defer(function()
			startUnwalk()
			if unwalkSetVisual then
				unwalkSetVisual(true)
			end
		end)
	end
	if medusaCounterEnabled then
		task.defer(function()
			if LP.Character then
				setupMedusaCounter(LP.Character)
			end
			if setMedusaVisual then
				setMedusaVisual(true)
			end
		end)
	end
	if data.batCounterV3 then
		task.defer(function()
			setBatCounterV3(true)
			if batCounterV3SetVisual then
				batCounterV3SetVisual(true)
			end
		end)
	end
	if data.batCounterV3Mode then
		batCounterV3SetMode(data.batCounterV3Mode)
		if conterModBtnRef then
			conterModBtnRef.Text = data.batCounterV3Mode
		end
	end
	if CONFIG.AUTO_STEAL_ENABLED then
		task.defer(function()
			pcall(startAutoSteal)
			if autoStealSetVisual then
				autoStealSetVisual(true)
			end
			updateProgressBarVisibility()
		end)
	end
	if antiLagEnabled then
		task.defer(function()
			enableAntiLag()
			if setAntiLagVisual then
				setAntiLagVisual(true)
			end
		end)
	end
	if stretchEnabled then
		task.defer(function()
			if _G.stretchToggleSetter then
				_G.stretchToggleSetter(true)
			else
				enableStretch()
			end
		end)
	end
	task.defer(function()
		if setLockUIVisual then
			setLockUIVisual(uiLocked)
		end
	end)
	if data.hideButtons then
		task.defer(function()
			setFloatingButtonsHidden(true)
			if hideButtonSetVisual then
				hideButtonSetVisual(true)
			end
		end)
	end
	if dropModeBtnRef then
		dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
	end
	refreshSpeedModeLabel()
	_lastSavedJSON = HS:JSONEncode(buildConfigTable())
	_isLoading = false
	return true
end
function forceResetUI()
	if normalBox then
		normalBox.Text = tostring(NS)
	end
	if carryBox then
		carryBox.Text = tostring(CS)
	end
	if radInput then
		radInput.Text = tostring(CONFIG.STEAL_RANGE)
	end
	if laggerBox then
		laggerBox.Text = tostring(LAGGER_SPEED)
	end
	if lagger2Box then
		lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
	end
	if batSpeedBox then
		batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
	end
	if uiScaleBox then
		uiScaleBox.Text = tostring(uiScaleValue)
	end
	applyStealBarScale()
	if dropModeBtnRef then
		dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
	end
	if bodyLockRangeBox then
		bodyLockRangeBox.Text = tostring(bodyLockRange)
	end
	if carrySysNormalBox then
		carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed)
	end
	if carrySysCarryBox then
		carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed)
	end
	if carrySysLaggerBox then
		carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed)
	end
	if carrySysLaggerCarryBox then
		carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed)
	end
	if carrySysSoftStealSpeedBox then
		carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed)
	end
	if carrySysSoftStealRadiusBox then
		carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius)
	end
	if carrySystemToggleSetter then
		carrySystemToggleSetter(useCarrySystem)
	end
	local function safeSet(fn, val)
		if fn then
			fn(val)
		end
	end
	safeSet(autoBatSetVisual, false)
	safeSet(autoLeftSetVisual, false)
	safeSet(autoRightSetVisual, false)
	safeSet(setBatCounterVisual, false)
	safeSet(setBatCounterV2Visual, false)
	safeSet(setMedusaVisual, false)
	safeSet(setUnwalkVisual, false)
	safeSet(setAntiLagVisual, false)
	safeSet(setLockUIVisual, true)
	safeSet(setEditModeVisual, false)
	safeSet(setInstaGrab, false)
	safeSet(batDesyncTpSetVisual, false)
	safeSet(setESPVIsual, false)
	safeSet(bodyLockSetVisual, false)
	safeSet(setNeonWeatherVisual, false)
	safeSet(autoBatV2SetVisual, false)
	safeSet(setAntiDieVisual, false)
	if _G.stretchToggleSetter then
		_G.stretchToggleSetter(false)
	end
	safeSet(mobSetAutoBat, false)
	safeSet(mobSetAutoLeft, false)
	safeSet(mobSetAutoRight, false)
	safeSet(mobSetDropBR, false)
	safeSet(mobSetTpDown, false)
	safeSet(mobSetCarry, false)
	safeSet(mobSetLagger1, false)
	safeSet(mobSetLagger2, false)
	refreshSpeedModeLabel()
	updateProgressBarVisibility()
	disableAntiLag()
	toggleNeonWeather(false)
	skyTheme = "Off"
	pcall(applyCustomSky, "Off")
	if skySelectorLabel then
		skySelectorLabel.Text = "Off"
	end
	disableBatV2()
	if antiDieEnabled then
		AntiDieModule.stop()
		antiDieEnabled = false
	end
	if antiFlingEnabled then
		AntiFlingShieldModule.stop()
		antiFlingEnabled = false
	end
	updateTpBatButtonWithAntiDie(false)
	for _, ref in ipairs(keyButtonRefs) do
		local entry = ref.entry
		local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
		ref.btn.Text = label
	end
	currentColorTheme = "Black & White"
	selectedColor = COLOR_THEMES["Black & White"]
	if colorSelectorLabel then
		colorSelectorLabel.Text = "Black & White"
		colorSelectorLabel.TextColor3 = selectedColor
	end
	updateAllUIThemeColors(selectedColor)
	if miniBtn then
		miniBtn.TextColor3 = selectedColor
	end
	local pGui = LP:FindFirstChild("PlayerGui")
	if pGui then
		local bb = pGui:FindFirstChild("RagCountdownBillboard")
		if bb then
			local lbl = bb:FindFirstChildOfClass("TextLabel")
			if lbl then
				lbl.TextColor3 = selectedColor
			end
		end
	end
	if MobilePanel then
		local container = MobilePanel:FindFirstChild("FloatingPanel")
		if container then
			local btnContainer = container:FindFirstChild("ButtonsContainer")
			if btnContainer then
				for _, btn in ipairs(btnContainer:GetChildren()) do
					if btn:IsA("TextButton") then
						local label = btn:FindFirstChildOfClass("TextLabel")
						if label then
							local isActive = btn.BackgroundColor3 == selectedColor
							if not isActive then
								label.TextColor3 = selectedColor
							end
						end
					end
				end
			end
		end
	end
	saveAllSettings()
end
function resetFloatingPositions()
	local _BTN_W, _GAP, _COLUMNS = 60, 8, 2
	local _PANEL_W = _BTN_W * _COLUMNS + _GAP * (_COLUMNS - 1)
	if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
		local container = MobilePanel:FindFirstChild("FloatingPanel")
		container.AnchorPoint = Vector2.new(1, 0)
		container.Position = UDim2.new(1, -10, 0, 10 + 70 * floatingButtonScale)
		savedButtonPositions = {}
		if container:FindFirstChild("ButtonsContainer") then
			for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do
				if btn:IsA("TextButton") and btn.Name then
					local defX, defY = getDefaultButtonPosition(btn.Name)
					btn.Position = UDim2.new(0, defX, 0, defY)
				end
			end
		end
	end
	if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
		local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
		btnFrame.AnchorPoint = Vector2.new(1, 0)
		btnFrame.Position = UDim2.new(1, -10, 0, 10)
		tpBatFloatingPos = nil
	end
	if batV2FloatingButton and batV2FloatingButton:FindFirstChild("Frame") then
		local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
		btnFrame.AnchorPoint = Vector2.new(1, 0)
		btnFrame.Position = UDim2.new(1, -10 - 70 * floatingButtonScale, 0, 10)
		batV2FloatingPos = nil
	end
	if instaResetFloatingButton then
		local f = instaResetFloatingButton:FindFirstChild("Frame")
		if f then
			f.AnchorPoint = Vector2.new(1, 0)
			f.Position = UDim2.new(1, -10 - 140 * floatingButtonScale, 0, 10)
			instaResetFloatingPos = nil
		end
	end
	if pbFrame then
		pbFrame.AnchorPoint = Vector2.new(0.5, 1)
		pbFrame.Position = UDim2.new(0.5, 0, 1, -24)
		savedProgressBarPos = nil
	end
	savedMobilePanelPos = nil
	tpBatFloatingPos = nil
	batV2FloatingPos = nil
end
function resetToFactoryDefaults()
	_isResetting = true
	local ok, err = pcall(function()
		stopAllBackgroundTasks()
		stopAutoSteal()
		stopBatCounter()
		stopBatCounterV2()
		stopMedusaCounter()
		if AntiRagdollV1.isRunning() then
			AntiRagdollV1.stop()
		end
		if AntiRagdollV2.Enabled then
			stopAntiRagdollV2()
		end
		if antiDieEnabled then
			AntiDieModule.stop()
		end
		if antiFlingEnabled then
			AntiFlingShieldModule.stop()
		end
		stopUnwalk()
		disableAutoBat()
		if batDesyncTpEnabled then
			stopBatDesyncTp()
		end
		disableBatV2()
		stopBodyLock()
		if espEnabled then
			toggleESP(false)
		end
		if stretchEnabled then
			disableStretch()
		end
		if antiLagEnabled then
			disableAntiLag()
		end
		if dropActive then
			stopDropBrainrot()
		end
		toggleNeonWeather(false)
		skyTheme = "Off"
		pcall(applyCustomSky, "Off")
		if skySelectorLabel then
			skySelectorLabel.Text = "Off"
		end
		if antiDieEnabled then
			AntiDieModule.stop()
			antiDieEnabled = false
		end
		if antiFlingEnabled then
			AntiFlingShieldModule.stop()
			antiFlingEnabled = false
		end
		NS = 60
		CS = 29
		LAGGER_SPEED = 15
		LAGGER_CARRY_SPEED = 24.5
		CONFIG.STEAL_RANGE = 61
		speedMode = false
		laggerToggled = false
		laggerCarryToggled = false
		antiRagdollMode = "off"
		antiDieEnabled = false
		antiFlingEnabled = false
		medusaCounterEnabled = false
		batCounterEnabled = false
		batCounterV2Enabled = false
		autoBatEnabled = false
		autoLeftEnabled = false
		autoRightEnabled = false
		unwalkEnabled = false
		antiLagEnabled = false
		uiLocked = true
		editModeEnabled = false
		CONFIG.AUTO_STEAL_ENABLED = false
		BAT_AIMBOT_SPEED = 58
		dropMode = 1
		stretchEnabled = false
		stretchFOV = 120
		fovValue = 70
		disableCustomFov()
		if fovSliderSet then
			fovSliderSet(70)
		end
		if setFovVisual then
			setFovVisual(false)
		end
		uiScaleValue = 78
		if mainUIScale then
			mainUIScale.Scale = 1
		end
		if pbScale then
			pbScale.Scale = 1
		end
		espEnabled = false
		bodyLockEnabled = false
		bodyLockRange = 20
		autoBatV2Enabled = false
		backgroundIndex = 1
		backgroundImageTransparency = 0
		floatingButtonScale = 1
		stealBarScale = 1
		if batDesyncTpEnabled then
			stopBatDesyncTp()
		end
		currentAnimPack = "Off"
		stopAnimPack()
		currentColorTheme = "Black & White"
		selectedColor = COLOR_THEMES["Black & White"]
		for key, val in pairs(DEFAULT_KB) do
			if KB[key] then
				KB[key].kb = val.kb
				KB[key].gp = val.gp
			end
		end
		useCarrySystem = false
		CarrySystem:stop()
		CarrySystem.normalSpeed = NS
		CarrySystem.carrySpeed = CS
		CarrySystem.laggerSpeed = LAGGER_SPEED
		CarrySystem.laggerCarrySpeed = LAGGER_CARRY_SPEED
		CarrySystem.softStealSpeed = 30
		CarrySystem.softStealRadius = 10
		CarrySystem.speedToggled = false
		CarrySystem.laggerMode = 0
		CarrySystem.softStealEnabled = false
		if isfile and isfile(CONFIG_FILE) then
			pcall(delfile, CONFIG_FILE)
		end
		resetFloatingPositions()
		forceResetUI()
		updateProgressBarVisibility()
		refreshSpeedModeLabel()
		_lastSavedJSON = nil
		saveAllSettings()
	end)
	_isResetting = false
	if not ok then
		warn("[resetToFactoryDefaults]", err)
	end
	return ok
end
function updateProgressBarVisibility()
	if pbFrame then
		pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
	end
end
function applyShimmerToText(obj, speed)
	speed = speed or 0.8
	local color = getThemeColor()
	local grad = Instance.new("UIGradient", obj)
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(1, color),
	})
	grad.Rotation = 45
	grad.Offset = Vector2.new(0, 0)
	task.spawn(function()
		local t = 0
		while grad and grad.Parent do
			t = t + 0.02
			grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
			task.wait(0.04)
		end
	end)
	return grad
end
function getDefaultButtonPosition(btnName)
	local BTN_W, BTN_H = 60, 60
	local GAP = 8
	local COLUMNS = 2
	local orderMap =
		{ DropBR = 0, AutoLeft = 1, AutoRight = 2, TpDown = 3, Carry = 4, Lagger1 = 5, Lagger2 = 6 }
	local order = orderMap[btnName] or 0
	local row = _floor(order / 2)
	local col = order % 2
	local colFromRight = (COLUMNS - 1) - col
	return colFromRight * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end
do
	print("[IR] 1. start")
	if _G.InstaResetLoaded then
		print("[IR] already loaded")
	else
		_G.InstaResetLoaded = true
		local resetCooldown = false
		local resetThread = nil
		local currentResetChar = nil
		local resetSuccessful = false
		local stopResetSequence = false
		local cameraLocked = false
		local lockedCameraCFrame = nil
		local _lastInstaResetRequest = 0
		print("[IR] 2. services OK, LP =", LP and LP.Name)
		local function instaResetFast()
			if resetCooldown then
				return
			end
			resetCooldown = true
			resetSuccessful = false
			stopResetSequence = false
			cameraLocked = false
			local character = LP.Character
			if not character then
				resetCooldown = false
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				resetCooldown = false
				return
			end
			local cam = workspace.CurrentCamera
			if cam then
				lockedCameraCFrame = cam.CFrame
				cameraLocked = true
				cam.CFrame = lockedCameraCFrame
			end
			currentResetChar = character
			local isRespawning = false
			resetThread = task.spawn(function()
				local attempts = 0
				local maxAttempts = 40
				local originalHipHeight = humanoid.HipHeight
				while
					character
					and character.Parent
					and humanoid
					and humanoid.Health > 0
					and not isRespawning
					and not stopResetSequence
				do
					if LP.Character ~= character then
						isRespawning = true
						break
					end
					pcall(function()
						humanoid.HipHeight = 1e30
						humanoid.AutoRotate = true
						local rootPart = character:FindFirstChild("HumanoidRootPart")
						if rootPart then
							rootPart.CanCollide = false
						end
						for _, part in ipairs(character:GetChildren()) do
							if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
								part.CanCollide = false
							end
						end
					end)
					if
						not character
						or not character.Parent
						or not humanoid
						or humanoid.Health <= 0
						or LP.Character ~= character
					then
						resetSuccessful = true
						break
					end
					attempts = attempts + 1
					if attempts >= maxAttempts then
						break
					end
					task.wait(0.05)
				end
				if not resetSuccessful then
					if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
						pcall(function()
							humanoid.Health = 0
						end)
						task.wait(0.1)
						if not character.Parent or humanoid.Health <= 0 then
							resetSuccessful = true
						end
					end
				end
				if not resetSuccessful and character and character.Parent and humanoid then
					pcall(function()
						humanoid.HipHeight = originalHipHeight
						local rootPart = character:FindFirstChild("HumanoidRootPart")
						if rootPart then
							rootPart.CanCollide = true
						end
						for _, part in ipairs(character:GetChildren()) do
							if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
								part.CanCollide = true
							end
						end
					end)
				end
				cameraLocked = false
				resetCooldown = false
				resetThread = nil
				currentResetChar = nil
				stopResetSequence = false
			end)
		end
		local function instaReset()
			local now = os.clock()
			if now - _lastInstaResetRequest < 0.75 then
				return
			end
			_lastInstaResetRequest = now
			instaResetFast()
		end
		print("[IR] 3. function ready")
		LP.CharacterAdded:Connect(function()
			stopResetSequence = true
			if resetThread then
				pcall(task.cancel, resetThread)
				resetThread = nil
			end
			resetCooldown = false
			currentResetChar = nil
			cameraLocked = false
		end)
		task.spawn(function()
			while true do
				task.wait(0.016)
				local cam = workspace.CurrentCamera
				if cameraLocked and lockedCameraCFrame and cam then
					cam.CFrame = lockedCameraCFrame
				end
			end
		end)
		print("[IR] 4. camera loop started")
		_G.InstaReset = { Trigger = instaReset }
	end
end
batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterVisual = nil
setBatCounterV2Visual = nil
local batCounterV3Enabled = false
local batCounterV3Mode = "TP BAT"
local batCounterV3ActiveMode = nil
local batCounterV3WasRagdoll = false
local batCounterV3Conn = nil
local batCounterV3TimerId = 0

local function batCounterV3StartMode(mode)
	if mode == "TP BAT" then
		if not batDesyncTpEnabled then
			toggleBatDesyncTp()
		end
	elseif mode == "Bat Bypass" then
		if not autoBatEnabled then
			enableAutoBat()
		end
	elseif mode == "Bat Bypass" then
		if not autoBatV2Enabled then
			enableBatV2()
		end
	end
	batCounterV3ActiveMode = mode
end

local function batCounterV3StopMode(mode)
	if mode == "TP BAT" then
		if batDesyncTpEnabled then
			toggleBatDesyncTp()
		end
	elseif mode == "Bat Bypass" then
		if autoBatEnabled then
			disableAutoBat()
		end
	elseif mode == "Bat Bypass" then
		if autoBatV2Enabled then
			disableBatV2()
		end
	end
	if batCounterV3ActiveMode == mode then
		batCounterV3ActiveMode = nil
	end
end

local function batCounterV3GetDuration(mode)
	if mode == "TP BAT" then
		return 1.4
	elseif mode == "Bat Bypass" then
		return 320
	elseif mode == "Bat Bypass" then
		return 300
	end
	return 0
end

local function batCounterV3ApplyMode()
	if not batCounterV3Enabled or not batCounterV3WasRagdoll then
		return
	end
	local mode = batCounterV3Mode
	if batCounterV3ActiveMode and batCounterV3ActiveMode ~= mode then
		batCounterV3StopMode(batCounterV3ActiveMode)
	end
	if batCounterV3ActiveMode then
		return
	end

	batCounterV3TimerId = batCounterV3TimerId + 1
	local timerId = batCounterV3TimerId
	batCounterV3StartMode(mode)
	local duration = batCounterV3GetDuration(mode)

	task.delay(duration, function()
		if timerId ~= batCounterV3TimerId then
			return
		end
		if batCounterV3ActiveMode == mode then
			batCounterV3StopMode(mode)
		end
	end)
end

local function batCounterV3SetMode(mode)
	if mode ~= "TP BAT" and mode ~= "Bat Bypass" and mode ~= "Bat Bypass" then
		return
	end
	if batCounterV3ActiveMode and batCounterV3ActiveMode ~= mode then
		batCounterV3StopMode(batCounterV3ActiveMode)
	end
	batCounterV3Mode = mode
	if batCounterV3WasRagdoll and batCounterV3Enabled and not batCounterV3ActiveMode then
		batCounterV3ApplyMode()
	end
end

local function stopBatCounterV3()
	batCounterV3TimerId = batCounterV3TimerId + 1
	if batCounterV3Conn then
		batCounterV3Conn:Disconnect()
		batCounterV3Conn = nil
	end
	if batCounterV3ActiveMode then
		batCounterV3StopMode(batCounterV3ActiveMode)
	end
	batCounterV3WasRagdoll = false
end

local function startBatCounterV3()
	if batCounterV3Conn then
		return
	end
	batCounterV3WasRagdoll = false
	batCounterV3Conn = RunService.Heartbeat:Connect(function()
		if not batCounterV3Enabled then
			return
		end
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local state = hum and hum:GetState()
		local ragdoll = state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown

		if ragdoll and not batCounterV3WasRagdoll then
			batCounterV3WasRagdoll = true
			batCounterV3ApplyMode()
		elseif not ragdoll and batCounterV3WasRagdoll then
			batCounterV3WasRagdoll = false
		end
	end)
end

local function setBatCounterV3(on)
	batCounterV3Enabled = on and true or false
	if batCounterV3Enabled then
		startBatCounterV3()
	else
		stopBatCounterV3()
	end
end
function buildGui()
	local SILVER = Color3.fromRGB(235, 235, 235)
	local SILVER_DARK = Color3.fromRGB(38, 38, 38)
	local SILVER_LIGHT = Color3.fromRGB(255, 255, 255)
	local BG = Color3.fromRGB(10, 10, 10)
	local BG2 = Color3.fromRGB(14, 14, 14)
	local ROW_BG = Color3.fromRGB(24, 24, 24)
	local ROW_BORDER = Color3.fromRGB(235, 235, 235)
	local WHITE = Color3.fromRGB(255, 255, 255)
	local GRAY = Color3.fromRGB(200, 200, 200)
	local INP = Color3.fromRGB(18, 18, 18)
	local OFF = Color3.fromRGB(30, 30, 30)
	local TAB_ACTIVE = Color3.fromRGB(30, 30, 30)
	local TAB_INACT = Color3.fromRGB(200, 200, 200)
	local SECT_LBL = SILVER
	local HOV = Color3.fromRGB(50, 50, 50)
	local DOT_ON = SILVER
	local ON_COLOR = Color3.fromRGB(255, 255, 255)
	local STROKE_COLOR = Color3.fromRGB(235, 235, 235)
	local GUI_W, GUI_H = 400, 500
	local BOX_BG_IMAGE = ""
	local TAB_BG_IMAGE = ""
	local GUI_POS_SAVE = "AmpDuels_GUIPos.json"
	local function loadGuiPos()
		if not isfile or not isfile(GUI_POS_SAVE) then
			return nil
		end
		local ok, data = pcall(function()
			return HS:JSONDecode(readfile(GUI_POS_SAVE))
		end)
		if ok and data and data.XOffset then
			return data
		end
		return nil
	end
	local function saveGuiPos()
		if not main then
			return
		end
		local pos = {
			XScale = main.Position.X.Scale,
			XOffset = main.Position.X.Offset,
			YScale = main.Position.Y.Scale,
			YOffset = main.Position.Y.Offset,
		}
		pcall(function()
			writefile(GUI_POS_SAVE, HS:JSONEncode(pos))
		end)
	end
	local old = game:GetService("CoreGui"):FindFirstChild("AmpDuels")
	if old then
		old:Destroy()
	end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		local o = pg:FindFirstChild("AmpDuels")
		if o then
			o:Destroy()
		end
	end
	gui = Instance.new("ScreenGui")
	gui.Name = "AMP DUELS"
	ampIntroPresentation.hide(gui)
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 10
	gui.IgnoreGuiInset = true
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
	local guiOk = pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end)
	if not guiOk then
		gui.Parent = LP:WaitForChild("PlayerGui")
	end
	main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
	local savedPos = loadGuiPos()
	local MAIN_POS = UDim2.new(0.5, -GUI_W / 2 + 70, 0.5, -GUI_H / 2 + 80)
	main.Position = MAIN_POS
	main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	main.BackgroundTransparency = 0.15
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
	local mainOutline = Instance.new("UIStroke", main)
	mainOutline.Name = "AmpMainOutline"
	mainOutline.Color = Color3.fromRGB(255, 255, 255)
	mainOutline.Thickness = 1.5
	mainOutline.Transparency = 0.12
	mainOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local bgImage = Instance.new("ImageLabel", main)
	bgImage.Name = "BackgroundImage"
	bgImage.Size = UDim2.new(1, 0, 1, 0)
	bgImage.Position = UDim2.new(0, 0, 0, 0)
	bgImage.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	bgImage.BackgroundTransparency = 1
	bgImage.Image = backgroundImages[backgroundIndex]
	bgImage.ImageTransparency = 0
	bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
	bgImage.ScaleType = Enum.ScaleType.Crop
	bgImage.ZIndex = 1
	bgImage.ClipsDescendants = true
	Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)
	local bgOverlay = Instance.new("Frame", bgImage)
	bgOverlay.Name = "Overlay"
	bgOverlay.Size = UDim2.new(1, 0, 1, 0)
	bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bgOverlay.BackgroundTransparency = 1
	bgOverlay.BorderSizePixel = 0
	bgOverlay.ZIndex = 2
	Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 18)
	mainUIScale = Instance.new("UIScale", main)
	mainUIScale.Scale = uiScaleValue / 100
	local titleFrame = Instance.new("Frame", main)
	titleFrame.Size = UDim2.new(1, -80, 0, 50)
	titleFrame.Position = UDim2.new(0, 16, 0, 10)
	titleFrame.BackgroundTransparency = 1
	titleFrame.ZIndex = 20
	local titleIcon = Instance.new("ImageLabel", titleFrame)
	titleIcon.Name = "TitleIcon"
	titleIcon.Size = UDim2.new(0, 40, 0, 40)
	titleIcon.Position = UDim2.new(0, 0, 0.5, -20)
	titleIcon.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	titleIcon.BorderSizePixel = 0
	titleIcon.BackgroundTransparency = 0.3
	titleIcon.ZIndex = 21
	titleIcon.Image = resolveAmpBackground()
	titleIcon.ScaleType = Enum.ScaleType.Fit
	Instance.new("UICorner", titleIcon).CornerRadius = UDim.new(0, 16)
	local iconStroke = Instance.new("UIStroke", titleIcon)
	iconStroke.Color = Color3.fromRGB(255, 255, 255)
	iconStroke.Thickness = 1.6
	iconStroke.Transparency = 0.15
	local titleText = Instance.new("TextLabel", titleFrame)
	titleText.Size = UDim2.new(1, -50, 1, 0)
	titleText.Position = UDim2.new(0, 50, 0, 0)
	titleText.BackgroundTransparency = 1
	titleText.Text = "AMP HUB"
	titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleText.Font = Enum.Font.GothamBlack
	titleText.TextSize = 16
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.TextStrokeColor3 = Color3.fromRGB(16, 16, 16)
	titleText.TextStrokeTransparency = 0.4
	titleText.ZIndex = 21
	local headerDivider = Instance.new("Frame", main)
	headerDivider.Name = "HeaderDivider"
	headerDivider.Size = UDim2.new(1, -32, 0, 2)
	headerDivider.Position = UDim2.new(0, 16, 0, 50)
	headerDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	headerDivider.BackgroundTransparency = 0.88
	headerDivider.BorderSizePixel = 0
	headerDivider.ZIndex = 20
	headerDivider.ClipsDescendants = true
	local movingLine = Instance.new("Frame", headerDivider)
	movingLine.Name = "MovingLine"
	movingLine.Size = UDim2.new(0, 90, 1, 0)
	movingLine.Position = UDim2.new(0, -90, 0, 0)
	movingLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	movingLine.BorderSizePixel = 0
	Instance.new("UICorner", movingLine).CornerRadius = UDim.new(0, 1)
	local lineGrad = Instance.new("UIGradient", movingLine)
	lineGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.3),
		NumberSequenceKeypoint.new(1, 0),
	})
	task.spawn(function()
		local speed = 150
		local x = -90
		RunService.RenderStepped:Connect(function(dt)
			if not movingLine or not movingLine.Parent then
				return
			end
			x = x + speed * dt
			local tw = headerDivider.AbsoluteSize.X
			if x > tw then
				x = -90
			end
			movingLine.Position = UDim2.new(0, x, 0, 0)
		end)
	end)
	local closeBtn = Instance.new("TextButton", main)
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.Position = UDim2.new(1, -42, 0, 8)
	closeBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	closeBtn.BackgroundTransparency = 0.2
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "−"
	closeBtn.TextColor3 = WHITE
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 26
	closeBtn.AutoButtonColor = false
	closeBtn.ZIndex = 200
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
	closeBtn.MouseEnter:Connect(function()
		TS:Create(closeBtn, TweenInfo.new(0.12), { TextColor3 = WHITE, BackgroundColor3 = getThemeColor() }):Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		TS:Create(closeBtn, TweenInfo.new(0.12), { TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(0, 0, 0) })
			:Play()
	end)
	miniBtn = Instance.new("TextButton", gui)
	miniBtn.Size = UDim2.new(0, 106, 0, 28)
	miniBtn.Position = UDim2.new(0, 16, 0, 58)
	miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	miniBtn.BackgroundTransparency = 0
	miniBtn.BorderSizePixel = 0
	miniBtn.Text = "AMP HUB"
	miniBtn.TextColor3 = selectedColor
	miniBtn.Font = Enum.Font.GothamBold
	miniBtn.TextSize = 12
	miniBtn.ZIndex = 20
	miniBtn.Visible = false
	miniBtn.AutoButtonColor = false
	local miniBtnCorner = Instance.new("UICorner", miniBtn)
	miniBtnCorner.CornerRadius = UDim.new(0, 8)
	local miniBtnStroke = Instance.new("UIStroke", miniBtn)
	miniBtnStroke.Name = "PurpleBorder"
	miniBtnStroke.Color = Color3.fromRGB(105, 105, 105)
	miniBtnStroke.Thickness = 1.5
	miniBtnStroke.Transparency = 0
	miniBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local miniBtnImage = Instance.new("ImageLabel", miniBtn)
	miniBtnImage.Name = "HideShowImage"
	miniBtnImage.Size = UDim2.new(1, 0, 1, 0)
	miniBtnImage.Position = UDim2.new(0, 0, 0, 0)
	miniBtnImage.BackgroundTransparency = 1
	miniBtnImage.BorderSizePixel = 0
	miniBtnImage.Image = ""
	miniBtnImage.Visible = false
	miniBtnImage.ScaleType = Enum.ScaleType.Fit
	miniBtnImage.ZIndex = 21
	miniBtnImage.Active = false
	miniBtnImage.ClipsDescendants = true
	local miniBtnImageCorner = Instance.new("UICorner", miniBtnImage)
	miniBtnImageCorner.CornerRadius = UDim.new(0, 8)
	local scaleTween = nil
	local fadeTween = nil
	local fragmentTweens = {}
	local fragmentOriginals = {}
	local fragmentReady = false
	local function isLayoutManaged(obj)
		local p = obj.Parent
		if not p then
			return false
		end
		for _, c in ipairs(p:GetChildren()) do
			if c:IsA("UIListLayout") or c:IsA("UIGridLayout") or c:IsA("UITableLayout") or c:IsA("UIPageLayout") then
				return true
			end
		end
		return false
	end
	local function collectGuiFragments()
		if fragmentReady or not main then
			return
		end
		fragmentReady = true
		for _, obj in ipairs(main:GetDescendants()) do
			if obj:IsA("GuiObject") and obj.Visible and not obj:IsA("ScrollingFrame") and not isLayoutManaged(obj) then
				fragmentOriginals[obj] = { Position = obj.Position, Rotation = obj.Rotation, Size = obj.Size }
			end
		end
	end
	local function cancelFragmentTweens()
		for _, tw in ipairs(fragmentTweens) do
			pcall(function()
				tw:Cancel()
			end)
		end
		table.clear(fragmentTweens)
	end
	local function tweenFragment(obj, goal, duration, style, direction)
		local tw = TS:Create(
			obj,
			TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.InOut),
			goal
		)
		table.insert(fragmentTweens, tw)
		tw:Play()
		return tw
	end
	showGui = function()
		if scaleTween then
			scaleTween:Cancel()
		end
		if fadeTween then
			fadeTween:Cancel()
		end
		if not main then
			return
		end
		collectGuiFragments()
		cancelFragmentTweens()
		main.Visible = true
		miniBtn.Visible = false
		main.Position = MAIN_POS
		animScale.Scale = 1
		animGroup.GroupTransparency = 0
		for obj, orig in pairs(fragmentOriginals) do
			if obj and obj.Parent then
				obj.Visible = true
				obj.Position = orig.Position
				obj.Rotation = orig.Rotation
			end
		end
		for obj, orig in pairs(fragmentOriginals) do
			if obj and obj.Parent then
				local dx = math.random(-170, 170)
				local dy = math.random(-150, 150)
				if math.abs(dx) < 45 then
					dx = (dx < 0 and -45 or 45)
				end
				if math.abs(dy) < 35 then
					dy = (dy < 0 and -35 or 35)
				end
				obj.Position = UDim2.new(
					orig.Position.X.Scale,
					orig.Position.X.Offset + dx,
					orig.Position.Y.Scale,
					orig.Position.Y.Offset + dy
				)
				obj.Rotation = orig.Rotation + math.random(-10, 10)
				tweenFragment(
					obj,
					{ Position = orig.Position, Rotation = orig.Rotation },
					0.48,
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				)
			end
		end
	end
	hideGui = function()
		if scaleTween then
			scaleTween:Cancel()
		end
		if fadeTween then
			fadeTween:Cancel()
		end
		if not main or not main.Visible then
			return
		end
		collectGuiFragments()
		cancelFragmentTweens()
		main.Visible = true
		miniBtn.Visible = false
		for obj, orig in pairs(fragmentOriginals) do
			if obj and obj.Parent then
				local dx = math.random(-230, 230)
				local dy = math.random(-190, 190)
				if math.random(1, 3) == 1 then
					dy = dy - math.random(80, 170)
				elseif math.random(1, 2) == 1 then
					dy = dy + math.random(70, 150)
				end
				if math.abs(dx) < 55 then
					dx = (dx < 0 and -55 or 55)
				end
				obj.Position = orig.Position
				obj.Rotation = orig.Rotation
				local target = UDim2.new(
					orig.Position.X.Scale,
					orig.Position.X.Offset + dx,
					orig.Position.Y.Scale,
					orig.Position.Y.Offset + dy
				)
				tweenFragment(
					obj,
					{ Position = target, Rotation = orig.Rotation + math.random(-22, 22) },
					0.5,
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.In
				)
			end
		end
		task.wait(0.53)
		if main then
			main.Visible = false
			for obj, orig in pairs(fragmentOriginals) do
				if obj and obj.Parent then
					obj.Position = orig.Position
					obj.Rotation = orig.Rotation
				end
			end
			miniBtn.Visible = true
		end
		table.clear(fragmentTweens)
	end
	closeBtn.MouseButton1Click:Connect(hideGui)
	miniBtn.MouseButton1Click:Connect(showGui)
	local tabBar = Instance.new("Frame", main)
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(1, -32, 0, 34)
	tabBar.Position = UDim2.new(0, 16, 0, 76)
	tabBar.BackgroundTransparency = 1
	tabBar.BorderSizePixel = 0
	tabBar.ClipsDescendants = false
	tabBar.ZIndex = 10
	local tabLayout = Instance.new("UIListLayout", tabBar)
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 4)
	local verticalDivider = Instance.new("Frame", main)
	verticalDivider.Name = "VerticalDivider"
	verticalDivider.Size = UDim2.new(1, -32, 0, 1)
	verticalDivider.Position = UDim2.new(0, 16, 0, 112)
	verticalDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	verticalDivider.BackgroundTransparency = 0.9
	verticalDivider.BorderSizePixel = 0
	verticalDivider.ZIndex = 20
	local tabContent = Instance.new("Frame", main)
	tabContent.Name = "TabContent"
	tabContent.Size = UDim2.new(1, -16, 1, -170)
	tabContent.Position = UDim2.new(0, 8, 0, 118)
	tabContent.BackgroundTransparency = 1
	tabContent.ClipsDescendants = true
	tabContent.ZIndex = 5
	-- Disable strokes only inside the options area; keep the main window border.
	local function removeOptionOutline(obj)
		if obj:IsA("UIStroke") then
			obj.Enabled = false
		end
	end
	tabContent.DescendantAdded:Connect(removeOptionOutline)
	for _, obj in ipairs(tabContent:GetDescendants()) do
		removeOptionOutline(obj)
	end
	local tabs = { "Speed", "Combat", "Visual", "Config", "Keybinds" }
	local tabDisplayNames =
		{ Speed = "SPEED", Combat = "COMBAT", Visual = "VISUAL", Config = "CONFIG", Keybinds = "BINDS" }
	tabButtons = {}
	local contentPages = {}
	for i, name in ipairs(tabs) do
		local btn = Instance.new("TextButton", tabBar)
		btn.Size = UDim2.new(0.19, 0, 1, -6)
		btn.LayoutOrder = i
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.BackgroundTransparency = 1
		btn.BorderSizePixel = 0
		btn.Text = tabDisplayNames[name] or name:upper()
		btn.TextColor3 = TAB_INACT
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.TextWrapped = false
		btn.TextXAlignment = Enum.TextXAlignment.Center
		btn.TextYAlignment = Enum.TextYAlignment.Center
		btn.AutoButtonColor = false
		btn.ZIndex = 12
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
		local tabImage = Instance.new("ImageLabel", btn)
		tabImage.Name = "TabImage"
		tabImage.Size = UDim2.new(1, 0, 1, 0)
		tabImage.Position = UDim2.new(0, 0, 0, 0)
		tabImage.BackgroundTransparency = 1
		tabImage.BorderSizePixel = 0
		tabImage.Image = TAB_BG_IMAGE
		tabImage.ImageTransparency = 0
		tabImage.ScaleType = Enum.ScaleType.Crop
		tabImage.ZIndex = 11
		tabImage.Active = false
		tabImage.Selectable = false
		local tabImageCorner = Instance.new("UICorner", tabImage)
		tabImageCorner.CornerRadius = UDim.new(0, 8)
		local activeOverlay = Instance.new("Frame", btn)
		activeOverlay.Name = "ActiveOverlay"
		activeOverlay.Size = UDim2.new(1, 0, 1, 0)
		activeOverlay.Position = UDim2.new(0, 0, 0, 0)
		activeOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		activeOverlay.BackgroundTransparency = 1
		activeOverlay.BorderSizePixel = 0
		activeOverlay.ZIndex = 12
		Instance.new("UICorner", activeOverlay).CornerRadius = UDim.new(0, 8)
		local activeBar = Instance.new("Frame", btn)
		activeBar.Name = "ActiveBar"
		activeBar.Size = UDim2.new(0, 3, 1, -12)
		activeBar.Position = UDim2.new(0, 0, 0, 6)
		activeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		activeBar.BackgroundTransparency = 1
		activeBar.BorderSizePixel = 0
		activeBar.ZIndex = 14
		Instance.new("UICorner", activeBar).CornerRadius = UDim.new(0, 2)
		btn.ZIndex = 15
		local labelPad = Instance.new("UIPadding", btn)
		labelPad.PaddingLeft = UDim.new(0, 0)
		labelPad.PaddingRight = UDim.new(0, 0)
		local page = Instance.new("ScrollingFrame", tabContent)
		page.Size = UDim2.new(1, 0, 1, 0)
		page.Position = UDim2.new(0, 0, 0, 0)
		page.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ClipsDescendants = true
		page.ScrollBarThickness = 2
		page.ScrollBarImageColor3 = Color3.fromRGB(178, 178, 178)
		page.ScrollBarImageTransparency = 0.3
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.ScrollingDirection = Enum.ScrollingDirection.Y
		page.ZIndex = 6
		Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
		page.Visible = (i == 1)
		local layout = Instance.new("UIListLayout", page)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 6)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		local padding = Instance.new("UIPadding", page)
		padding.PaddingLeft = UDim.new(0, 8)
		padding.PaddingRight = UDim.new(0, 8)
		padding.PaddingTop = UDim.new(0, 6)
		padding.PaddingBottom = UDim.new(0, 20)
		contentPages[name] = page
		btn.MouseButton1Click:Connect(function()
			for _, pg in pairs(contentPages) do
				pg.Visible = false
			end
			page.Visible = true
			for _, b in ipairs(tabButtons) do
				b.TextColor3 = TAB_INACT
				b.BackgroundTransparency = 1
				local ao = b:FindFirstChild("ActiveOverlay")
				if ao then
					ao.BackgroundTransparency = 1
				end
				local ab = b:FindFirstChild("ActiveBar")
				if ab then
					ab.BackgroundTransparency = 1
				end
			end
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			btn.BackgroundTransparency = 1
			local ao = btn:FindFirstChild("ActiveOverlay")
			if ao then
				ao.BackgroundTransparency = 0.18
			end
			local ab = btn:FindFirstChild("ActiveBar")
			if ab then
				ab.BackgroundTransparency = 0
			end
		end)
		table.insert(tabButtons, btn)
	end
	if tabButtons[1] then
		tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		tabButtons[1].BackgroundTransparency = 1
		local ao = tabButtons[1]:FindFirstChild("ActiveOverlay")
		if ao then
			ao.BackgroundTransparency = 0.18
		end
		local ab = tabButtons[1]:FindFirstChild("ActiveBar")
		if ab then
			ab.BackgroundTransparency = 0
		end
	end
	local pageCounters = {}
	local function getNextOrder(page)
		if not pageCounters[page] then
			pageCounters[page] = 0
		end
		pageCounters[page] = pageCounters[page] + 1
		return pageCounters[page]
	end
	local function mkSect(page, txt)
		local f = Instance.new("Frame", page)
		f.Size = UDim2.new(1, 0, 0, 26)
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.LayoutOrder = getNextOrder(page)
		f.ZIndex = 7
		local l = Instance.new("TextLabel", f)
		l.Size = UDim2.new(1, -16, 1, 0)
		l.Position = UDim2.new(0, 8, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt:upper()
		l.TextColor3 = Color3.fromRGB(255, 255, 255)
		l.Font = Enum.Font.GothamBlack
		l.TextSize = 14
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		l.TextStrokeTransparency = 0.15
		l.ZIndex = 8
		local line = Instance.new("Frame", f)
		line.Size = UDim2.new(1, -24, 0, 1.5)
		line.Position = UDim2.new(0, 12, 1, -4)
		line.BackgroundColor3 = Color3.fromRGB(178, 178, 178)
		line.BackgroundTransparency = 0.4
		line.BorderSizePixel = 0
		line.ZIndex = 8
		return f
	end
	local function mkRow(page, h)
		local f = Instance.new("Frame", page)
		f.Size = UDim2.new(1, -4, 0, h or 42)
		f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		f.BackgroundTransparency = 0.45
		f.BorderSizePixel = 0
		f.LayoutOrder = getNextOrder(page)
		f.ZIndex = 7
		f.ClipsDescendants = true
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
		local rowBgImage = Instance.new("ImageLabel", f)
		rowBgImage.Name = "RowBgImage"
		rowBgImage.Size = UDim2.new(1, 0, 1, 0)
		rowBgImage.Position = UDim2.new(0, 0, 0, 0)
		rowBgImage.BackgroundTransparency = 1
		rowBgImage.Image = BOX_BG_IMAGE
		rowBgImage.ImageTransparency = 0.12
		rowBgImage.ScaleType = Enum.ScaleType.Crop
		rowBgImage.ZIndex = 7
		Instance.new("UICorner", rowBgImage).CornerRadius = UDim.new(0, 12)
		local rowStroke = Instance.new("UIStroke", f)
		rowStroke.Color = Color3.fromRGB(255, 255, 255)
		rowStroke.Thickness = 1.8
		rowStroke.Transparency = 0.28
		rowStroke.ZIndex = 9
		f.MouseEnter:Connect(function()
			TS:Create(rowBgImage, TweenInfo.new(0.1), { ImageTransparency = 0.0 }):Play()
		end)
		f.MouseLeave:Connect(function()
			TS:Create(rowBgImage, TweenInfo.new(0.1), { ImageTransparency = 0.15 }):Play()
		end)
		return f
	end
	local function mkDivider(page)
		local d = Instance.new("Frame", page)
		d.Name = "RowDivider"
		d.Size = UDim2.new(1, -20, 0, 1)
		d.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		d.BackgroundTransparency = 0.6
		d.BorderSizePixel = 0
		d.LayoutOrder = getNextOrder(page)
		d.ZIndex = 7
		return d
	end
	local function mkLabel(row, txt)
		local l = Instance.new("TextLabel", row)
		l.Size = UDim2.new(0.4, 0, 1, 0)
		l.Position = UDim2.new(0, 10, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt
		l.TextColor3 = WHITE
		l.Font = Enum.Font.GothamBold
		l.TextSize = 11
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		l.TextStrokeTransparency = 0.5
		l.ZIndex = 8
		return l
	end
	local function mkPill(row, offset)
		local pill = Instance.new("Frame", row)
		pill.Name = "Track"
		pill.Size = UDim2.new(0, 34, 0, 18)
		pill.AnchorPoint = Vector2.new(0.5, 0.5)
		pill.Position = UDim2.new(1, -(offset or 48), 0.5, 0)
		pill.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		pill.BackgroundTransparency = 0.05
		pill.BorderSizePixel = 0
		pill.ZIndex = 8
		Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 10)
		local stroke = Instance.new("UIStroke", pill)
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 1.6
		stroke.Transparency = 0.2
		stroke.Name = "PillStroke"
		local dot = Instance.new("Frame", pill)
		dot.Name = "Knob"
		dot.Size = UDim2.new(0, 13, 0, 13)
		dot.AnchorPoint = Vector2.new(0, 0)
		dot.Position = UDim2.new(0, 3, 0.5, -6)
		dot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		dot.BorderSizePixel = 0
		dot.ZIndex = 9
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		local shine = Instance.new("Frame", dot)
		shine.Name = "Shine"
		shine.Size = UDim2.new(1, -4, 0, 4)
		shine.Position = UDim2.new(0, 2, 0, 2)
		shine.BackgroundColor3 = WHITE
		shine.BackgroundTransparency = 0.72
		shine.BorderSizePixel = 0
		shine.ZIndex = 10
		Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)
		return pill, dot
	end
	local function animPill(pill, dot, on)
		local stroke = pill:FindFirstChildOfClass("UIStroke")
		local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TS:Create(dot, info, { Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6) }):Play()
		TS:Create(
			pill,
			info,
			{
				BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = on and 0 or 0.2,
			}
		):Play()
		if stroke then
			TS:Create(
				stroke,
				info,
				{ Color = on and getThemeColor() or ROW_BORDER, Transparency = on and 0.2 or 0.45, Thickness = 1 }
			):Play()
		end
	end
	local function mkSlider(row, minV, maxV, default, cb)
		local W = 80
		local track = Instance.new("Frame", row)
		track.Size = UDim2.new(0, W, 0, 4)
		track.Position = UDim2.new(1, -(W + 44), 0.5, -2)
		track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		track.BackgroundTransparency = 0
		track.BorderSizePixel = 0
		track.ZIndex = 8
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		local trackStroke = Instance.new("UIStroke", track)
		trackStroke.Color = Color3.fromRGB(103, 103, 103)
		trackStroke.Thickness = 1.5
		trackStroke.Transparency = 0.1
		local fill = Instance.new("Frame", track)
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(103, 103, 103)
		fill.BorderSizePixel = 0
		fill.ZIndex = 9
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
		local knob = Instance.new("Frame", track)
		knob.Size = UDim2.new(0, 13, 0, 13)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(0, 0, 0.5, 0)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		knob.ZIndex = 11
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
		local kStroke = Instance.new("UIStroke", knob)
		kStroke.Color = Color3.fromRGB(103, 103, 103)
		kStroke.Thickness = 2
		local valLabel = Instance.new("TextLabel", row)
		valLabel.Size = UDim2.new(0, 34, 0, 20)
		valLabel.Position = UDim2.new(1, -38, 0.5, -10)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(default)
		valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		valLabel.Font = Enum.Font.GothamBold
		valLabel.TextSize = 11
		valLabel.TextXAlignment = Enum.TextXAlignment.Right
		valLabel.ZIndex = 9
		local hit = Instance.new("TextButton", row)
		hit.Size = UDim2.new(0, W + 16, 0, 26)
		hit.Position = UDim2.new(1, -(W + 52), 0.5, -13)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.AutoButtonColor = false
		hit.ZIndex = 12
		local current = default
		local function render(a)
			a = _clamp(a, 0, 1)
			fill.Size = UDim2.new(a, 0, 1, 0)
			knob.Position = UDim2.new(a, 0, 0.5, 0)
			fill.BackgroundColor3 = Color3.fromRGB(103, 103, 103)
			kStroke.Color = Color3.fromRGB(103, 103, 103)
		end
		local function applyFromX(px)
			local left = track.AbsolutePosition.X
			local width = track.AbsoluteSize.X
			if width <= 0 then
				width = W
			end
			if left <= 0 then
				return
			end
			local a = (px - left) / width
			a = _clamp(a, 0, 1)
			local v = _floor(minV + (maxV - minV) * a + 0.5)
			current = v
			valLabel.Text = tostring(v)
			render(a)
			if cb then
				pcall(cb, v)
			end
		end
		local dragging = false
		hit.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				_isDraggingButton = true
				applyFromX(i.Position.X)
			end
		end)
		hit.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
				_isDraggingButton = false
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if not dragging then
				return
			end
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
				applyFromX(i.Position.X)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if not dragging then
				return
			end
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
				_isDraggingButton = false
			end
		end)
		local function setValue(v)
			v = _clamp(tonumber(v) or minV, minV, maxV)
			current = v
			valLabel.Text = tostring(v)
			render((v - minV) / (maxV - minV))
		end
		setValue(default)
		return setValue
	end
	local function mkToggle(page, txt, cb)
		local row = mkRow(page, 38)
		mkLabel(row, txt)
		local pill, dot = mkPill(row, 48)
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.AutoButtonColor = false
		clk.ZIndex = 10
		clk.MouseButton1Click:Connect(function()
			if editModeEnabled and not uiLocked then
				pcall(cb, not on)
			else
				on = not on
				sv(on)
				pcall(cb, on)
			end
		end)
		local sep = Instance.new("Frame", page)
		sep.Name = "ToggleDivider"
		sep.Size = UDim2.new(1, -20, 0, 1)
		sep.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		sep.BackgroundTransparency = 0.55
		sep.BorderSizePixel = 0
		sep.LayoutOrder = getNextOrder(page)
		sep.ZIndex = 7
		return sv
	end
	local function mkSelector(parent, default, options, cb)
		local container = Instance.new("Frame", parent)
		container.Size = UDim2.new(0, 160, 1, 0)
		container.Position = UDim2.new(1, -168, 0, 0)
		container.BackgroundTransparency = 1
		container.ZIndex = 8
		local leftBtn = Instance.new("TextButton", container)
		leftBtn.Size = UDim2.new(0, 28, 0, 26)
		leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
		leftBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		leftBtn.BackgroundTransparency = 0
		leftBtn.BorderSizePixel = 0
		leftBtn.Text = "<"
		leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		leftBtn.Font = Enum.Font.GothamBold
		leftBtn.TextSize = 13
		leftBtn.AutoButtonColor = false
		leftBtn.ZIndex = 9
		Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
		local leftStroke = Instance.new("UIStroke", leftBtn)
		leftStroke.Color = Color3.fromRGB(103, 103, 103)
		leftStroke.Thickness = 1.5
		leftStroke.Transparency = 0.1
		local label = Instance.new("TextLabel", container)
		label.Size = UDim2.new(0, 80, 0, 26)
		label.Position = UDim2.new(0.5, -40, 0.5, -13)
		label.BackgroundTransparency = 1
		label.Text = default
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.ZIndex = 9
		local rightBtn = Instance.new("TextButton", container)
		rightBtn.Size = UDim2.new(0, 28, 0, 26)
		rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
		rightBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		rightBtn.BackgroundTransparency = 0
		rightBtn.BorderSizePixel = 0
		rightBtn.Text = ">"
		rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		rightBtn.Font = Enum.Font.GothamBold
		rightBtn.TextSize = 13
		rightBtn.AutoButtonColor = false
		rightBtn.ZIndex = 9
		Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
		local rightStroke = Instance.new("UIStroke", rightBtn)
		rightStroke.Color = Color3.fromRGB(103, 103, 103)
		rightStroke.Thickness = 1.5
		rightStroke.Transparency = 0.1
		leftBtn.MouseEnter:Connect(function()
			TS:Create(leftBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(103, 103, 103) }):Play()
		end)
		leftBtn.MouseLeave:Connect(function()
			TS:Create(leftBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
		end)
		rightBtn.MouseEnter:Connect(function()
			TS:Create(rightBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(103, 103, 103) }):Play()
		end)
		rightBtn.MouseLeave:Connect(function()
			TS:Create(rightBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
		end)
		local function updateLabel(newText)
			label.Text = newText
		end
		leftBtn.MouseButton1Click:Connect(function()
			if cb then
				cb(-1, updateLabel)
			end
		end)
		rightBtn.MouseButton1Click:Connect(function()
			if cb then
				cb(1, updateLabel)
			end
		end)
		return label
	end
	local function mkBox(parent, default, w, xOff, cb)
		local tb = Instance.new("TextBox", parent)
		local bw = w or 50
		local xo = math.max(xOff or 56, bw + 12)
		tb.Size = UDim2.new(0, bw, 0, 24)
		tb.Position = UDim2.new(1, -xo, 0.5, -12)
		tb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		tb.BackgroundTransparency = 0
		tb.BorderSizePixel = 0
		tb.Text = tostring(default)
		tb.TextColor3 = Color3.fromRGB(255, 255, 255)
		tb.Font = Enum.Font.GothamBold
		tb.TextSize = 11
		tb.ClearTextOnFocus = false
		tb.ZIndex = 8
		Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
		local bs = Instance.new("UIStroke", tb)
		bs.Color = Color3.fromRGB(103, 103, 103)
		bs.Thickness = 1.5
		bs.Transparency = 0.1
		tb.Focused:Connect(function()
			TS:Create(tb, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(103, 103, 103) }):Play()
			TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0 }):Play()
			tb.TextColor3 = Color3.fromRGB(255, 255, 255)
		end)
		tb.FocusLost:Connect(function()
			TS:Create(tb, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
			TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(103, 103, 103), Transparency = 0.1 }):Play()
			if cb then
				local n = tonumber(tb.Text)
				if n then
					cb(n)
				else
					tb.Text = tostring(default)
				end
			end
		end)
		return tb
	end
	local function mkKeyButton(parent, kbEntry)
		local btn = Instance.new("TextButton", parent)
		btn.Size = UDim2.new(0, 80, 0, 24)
		btn.Position = UDim2.new(1, -88, 0.5, -12)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.BackgroundTransparency = 0
		btn.BorderSizePixel = 0
		local function getLabel()
			return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
		end
		btn.Text = getLabel()
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 9
		btn.ZIndex = 8
		btn.AutoButtonColor = false
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		local bs = Instance.new("UIStroke", btn)
		bs.Color = Color3.fromRGB(103, 103, 103)
		bs.Thickness = 1.5
		bs.Transparency = 0.1
		local li = false
		local lc
		local pv = btn.Text
		local listenStart = 0
		btn.Activated:Connect(function()
			if li then
				li = false
				_anyKeyListening = false
				if lc then
					lc:Disconnect()
					lc = nil
				end
				btn.Text = pv
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				TS:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
				TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(103, 103, 103) }):Play()
				return
			end
			pv = btn.Text
			li = true
			_anyKeyListening = true
			listenStart = _tick()
			btn.Text = "..."
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			TS:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(103, 103, 103) }):Play()
			TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(255, 255, 255) }):Play()
			lc = UIS.InputBegan:Connect(function(inp)
				if not li then
					return
				end
				if inp.KeyCode == Enum.KeyCode.Escape then
					li = false
					_anyKeyListening = false
					if lc then
						lc:Disconnect()
						lc = nil
					end
					btn.Text = pv
					btn.TextColor3 = Color3.fromRGB(255, 255, 255)
					TS:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
					TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(103, 103, 103) }):Play()
					return
				end
				local isGp = isGamepadInput(inp)
				if isGp and _tick() - listenStart < 0.15 then
					return
				end
				if not isBindableInput(inp) then
					return
				end
				btn.Text = inp.KeyCode.Name
				pv = inp.KeyCode.Name
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				li = false
				_anyKeyListening = false
				if lc then
					lc:Disconnect()
					lc = nil
				end
				TS:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
				TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(103, 103, 103) }):Play()
				if isGp then
					kbEntry.gp = inp.KeyCode
					kbEntry.kb = nil
				else
					kbEntry.kb = inp.KeyCode
					kbEntry.gp = nil
				end
			end)
		end)
		table.insert(keyButtonRefs, { btn = btn, entry = kbEntry })
		return btn
	end
	local function addKeybindRow(page, labelText, kbEntry)
		local row = mkRow(page, 36)
		mkLabel(row, labelText)
		mkKeyButton(row, kbEntry)
	end
	local speedPage = contentPages["Speed"]
	mkSect(speedPage, "Speed Settings")
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Normal Speed")
		normalBox = mkBox(row, NS, 50, 56, function(v)
			if v > 0 and v <= 500 then
				NS = v
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Carry Speed")
		carryBox = mkBox(row, CS, 50, 56, function(v)
			if v > 0 and v <= 500 then
				CS = v
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Lagger 1 Speed")
		laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v)
			if v > 0 and v <= 500 then
				LAGGER_SPEED = v
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Lagger 2 Speed")
		lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v)
			if v > 0 and v <= 500 then
				LAGGER_CARRY_SPEED = v
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Jump Power")
		jumpPowerBox = mkBox(row, InfiniteJump.jumpPower, 50, 56, function(v)
			if v then
				InfiniteJump.setJumpPower(v)
				jumpPowerBox.Text = tostring(InfiniteJump.jumpPower)
				saveAllSettings()
			end
		end)
	end
	jumpHoldSetVisual = mkToggle(speedPage, "Hold Jump", function(on)
		InfiniteJump.holdEnabled = on
		saveAllSettings()
	end)
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Current Mode")
		modeValLbl = Instance.new("TextLabel", row)
		modeValLbl.Size = UDim2.new(0, 110, 1, 0)
		modeValLbl.Position = UDim2.new(1, -118, 0, 0)
		modeValLbl.BackgroundTransparency = 1
		modeValLbl.Text = "Normal"
		modeValLbl.TextColor3 = WHITE
		modeValLbl.Font = Enum.Font.GothamBlack
		modeValLbl.TextSize = 11
		modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
		modeValLbl.ZIndex = 8
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.AutoButtonColor = false
		clk.ZIndex = 8
		clk.MouseButton1Click:Connect(function()
			toggleCarryMode()
		end)
	end
	mkSect(speedPage, "Auto Movement")
	autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
		autoLeftEnabled = on
		if on then
			startAutoLeft()
		else
			stopAutoLeft()
		end
		if mobSetAutoLeft then
			mobSetAutoLeft(on)
		end
		saveAllSettings()
	end)
	autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
		autoRightEnabled = on
		if on then
			startAutoRight()
		else
			stopAutoRight()
		end
		if mobSetAutoRight then
			mobSetAutoRight(on)
		end
		saveAllSettings()
	end)
	mkSect(speedPage, "TP & Reset")
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "TP Down")
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(0.58, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.AutoButtonColor = false
		clk.ZIndex = 8
		clk.MouseButton1Click:Connect(function()
			doTpDown()
		end)
		local actLbl = Instance.new("TextLabel", row)
		actLbl.Size = UDim2.new(0, 70, 1, 0)
		actLbl.Position = UDim2.new(1, -78, 0, 0)
		actLbl.BackgroundTransparency = 1
		actLbl.Text = "ACTIVATE"
		actLbl.TextColor3 = getThemeColor()
		actLbl.Font = Enum.Font.GothamBold
		actLbl.TextSize = 9
		actLbl.TextXAlignment = Enum.TextXAlignment.Right
		actLbl.ZIndex = 8
	end
	mkSect(speedPage, "Auto Carry System (Nuevo)")
	carrySystemToggleSetter = mkToggle(speedPage, "Enable Auto Carry", function(on)
		useCarrySystem = on
		if on then
			CarrySystem:start()
			CarrySystem.speedToggled = speedMode
			if laggerToggled then
			else
				CarrySystem:setLaggerMode(0)
			end
			CarrySystem:setSoftStealEnabled(true)
		else
			CarrySystem:stop()
			CarrySystem:setSoftStealEnabled(false)
		end
		saveAllSettings()
	end)
	mkSect(speedPage, "Auto Carry Speeds")
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Normal Speed")
		carrySysNormalBox = mkBox(row, CarrySystem.normalSpeed, 50, 56, function(v)
			if v > 0 and v <= 500 then
				CarrySystem:setNormalSpeed(v)
				saveAllSettings()
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Carry Speed")
		carrySysCarryBox = mkBox(row, CarrySystem.carrySpeed, 50, 56, function(v)
			if v > 0 and v <= 500 then
				CarrySystem:setCarrySpeed(v)
				saveAllSettings()
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Lagger Speed")
		carrySysLaggerBox = mkBox(row, CarrySystem.laggerSpeed, 50, 56, function(v)
			if v > 0 and v <= 500 then
				CarrySystem:setLaggerSpeed(v)
				saveAllSettings()
			end
		end)
	end
	do
		local row = mkRow(speedPage, 38)
		mkLabel(row, "Lagger Carry Spd")
		carrySysLaggerCarryBox = mkBox(row, CarrySystem.laggerCarrySpeed, 50, 56, function(v)
			if v > 0 and v <= 500 then
				CarrySystem:setLaggerCarrySpeed(v)
				saveAllSettings()
			end
		end)
	end
	local combatPage = contentPages["Combat"]
	mkSect(combatPage, "Anti Ragdoll")
	do
		local row = mkRow(combatPage, 38)
		mkLabel(row, "Anti Ragdoll")
		local selectorBtn = Instance.new("TextButton", row)
		selectorBtn.Size = UDim2.new(0, 100, 1, 0)
		selectorBtn.Position = UDim2.new(1, -108, 0, 0)
		selectorBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		selectorBtn.BackgroundTransparency = 0.7
		selectorBtn.BorderSizePixel = 0
		selectorBtn.Text = "Off ▼"
		selectorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		selectorBtn.Font = Enum.Font.GothamBold
		selectorBtn.TextSize = 12
		selectorBtn.AutoButtonColor = false
		selectorBtn.ZIndex = 8
		Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 6)
		local selStroke = Instance.new("UIStroke", selectorBtn)
		selStroke.Color = Color3.fromRGB(50, 50, 50)
		selStroke.Thickness = 1
		local dropdown = Instance.new("Frame", combatPage)
		dropdown.Size = UDim2.new(0, 100, 0, 90)
		dropdown.Position = UDim2.new(0, 0, 0, 0)
		dropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		dropdown.BackgroundTransparency = 0.9
		dropdown.BorderSizePixel = 0
		dropdown.Visible = false
		dropdown.ZIndex = 20
		Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)
		local dropStroke = Instance.new("UIStroke", dropdown)
		dropStroke.Color = Color3.fromRGB(50, 50, 50)
		dropStroke.Thickness = 1
		local options = { "Off", "V1", "V2" }
		local optionButtons = {}
		for i, opt in ipairs(options) do
			local btn = Instance.new("TextButton", dropdown)
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
			btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			btn.BackgroundTransparency = 0.5
			btn.BorderSizePixel = 0
			btn.Text = opt
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 12
			btn.ZIndex = 21
			btn.AutoButtonColor = false
			btn.MouseButton1Click:Connect(function()
				local mode = opt:lower()
				setAntiRagdollMode(mode)
				dropdown.Visible = false
			end)
			optionButtons[opt] = btn
		end
		selectorBtn.MouseButton1Click:Connect(function()
			if dropdown.Visible then
				dropdown.Visible = false
				return
			end
			local absPos = selectorBtn.AbsolutePosition
			local size = selectorBtn.AbsoluteSize
			dropdown.Position = UDim2.new(0, absPos.X, 0, absPos.Y + size.Y)
			dropdown.Visible = true
		end)
		UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if dropdown.Visible then
					local mousePos = input.Position
					local absPos = dropdown.AbsolutePosition
					local size = dropdown.AbsoluteSize
					if
						not (
							mousePos.X >= absPos.X
							and mousePos.X <= absPos.X + size.X
							and mousePos.Y >= absPos.Y
							and mousePos.Y <= absPos.Y + size.Y
						)
					then
						dropdown.Visible = false
					end
				end
			end
		end)
		local function updateAntiRagdollUI(mode)
			local label = mode:gsub("^%l", string.upper)
			if mode == "off" then
				label = "Off"
			end
			selectorBtn.Text = label .. " ▼"
			for opt, btn in pairs(optionButtons) do
				if opt:lower() == mode then
					btn.BackgroundColor3 = getThemeColor()
					btn.TextColor3 = Color3.fromRGB(0, 0, 0)
				else
					btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
		end
		_G.updateAntiRagdollUI = updateAntiRagdollUI
		updateAntiRagdollUI(antiRagdollMode)
	end
	unwalkSetVisual = mkToggle(combatPage, "Unwalk", function(on)
		unwalkEnabled = on
		if on then
			startUnwalk()
		else
			stopUnwalk()
		end
		saveAllSettings()
	end)
	setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
		antiDieEnabled = on
		if on then
			AntiDieModule.start()
		else
			AntiDieModule.stop()
		end
		saveAllSettings()
	end)
	if setAntiDieVisual then
		setAntiDieVisual(antiDieEnabled)
	end
	mkSect(combatPage, "Drop")
	dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
		if on then
			executeDropWithToggle(function(v)
				dropBrainrotSetVisual(v)
				if mobSetDropBR then
					mobSetDropBR(v)
				end
			end)
		end
	end)
	setDropVisual = dropBrainrotSetVisual
	do
		local row = mkRow(combatPage, 38)
		mkLabel(row, "Drop Mode")
		dropModeBtnRef = mkSelector(
			row,
			dropMode == 1 and "Fling" or "Jump Drop",
			{ "Fling", "Jump Drop" },
			function(dir, update)
				if dropActive then
					stopDropBrainrot()
				end
				dropMode = dropMode == 1 and 2 or 1
				update(dropMode == 1 and "Fling" or "Jump Drop")
			end
		)
	end
	mkSect(combatPage, "Counters")
	do
		local row = mkRow(combatPage, 38)
		mkLabel(row, "Conter Mod")
		local opts = { "TP BAT", "Bat Bypass", "Bat Bypass" }
		local idx = 1
		for i, v in ipairs(opts) do
			if v == batCounterV3Mode then
				idx = i
				break
			end
		end
		conterModBtnRef = mkSelector(row, opts[idx], opts, function(dir, update)
			local n = #opts
			idx = ((idx - 1 + dir) % n) + 1
			batCounterV3SetMode(opts[idx])
			update(opts[idx])
		end)
	end
	batCounterV3SetVisual = mkToggle(combatPage, "Bat Counter V3", function(on)
		setBatCounterV3(on)
		saveAllSettings()
	end)
	if batCounterV3SetVisual then
		batCounterV3SetVisual(batCounterV3Enabled)
	end
	setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
		medusaCounterEnabled = on
		if on then
			if LP.Character then
				setupMedusaCounter(LP.Character)
			else
				stopMedusaCounter()
			end
		else
			stopMedusaCounter()
		end
		if setMedusaVisual then
			setMedusaVisual(on)
		end
		saveAllSettings()
	end)
	mkSect(combatPage, "Defense")
	bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
		bodyLockEnabled = on
		if on then
			if _blSuppressCount == 0 then
				startBodyLock()
			end
		else
			stopBodyLock()
		end
		saveAllSettings()
	end)
	do
		local row = mkRow(combatPage, 38)
		mkLabel(row, "Body Lock Range")
		bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
			if v and v > 0 then
				bodyLockRange = _clamp(_floor(v), 5, 200)
				if bodyLockRangeBox then
					bodyLockRangeBox.Text = tostring(bodyLockRange)
				end
			end
		end)
	end
	mkSect(combatPage, "Aimbots")
	autoBatV2SetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
		if on then
			enableBatV2()
		else
			disableBatV2()
		end
		saveAllSettings()
	end)
	if autoBatV2SetVisual then
        autoBatV2SetVisual(autoBatV2Enabled)
    end
    addKeybindRow(combatPage, "Bat Bypass Bind", KB.BatV2)
    do
        local row = mkRow(combatPage, 38)
		mkLabel(row, "Bypass Speed")
		batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v)
			if v > 0 and v <= 200 then
				BAT_AIMBOT_SPEED = v
				saveAllSettings()
			end
		end)
	end
	local visualPage = contentPages["Visual"]
	mkSect(visualPage, "Bat Information")
	batSkinSetVisual = mkToggle(visualPage, "Bat Skin", function(on)
		_G.KatanaSkinEnabled = on == true
		if on and minecraftBatSkinSetVisual then
			minecraftBatSkinSetVisual(false)
		end
		if _G.KatanaSkin then
			if on then
				task.spawn(function()
					pcall(function()
						_G.KatanaSkin.ApplySkin("KATANA")
					end)
				end)
			else
				pcall(function()
					_G.KatanaSkin.ApplySkin("NONE")
				end)
			end
		end
		saveAllSettings()
	end)
	do
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -24, 0, 20)
		lbl.Position = UDim2.new(0, 12, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = "MORE FEATURES SOON"
		lbl.TextColor3 = WHITE
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 10
		lbl.TextTransparency = 0.15
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.ZIndex = 6
		lbl.LayoutOrder = getNextOrder(visualPage)
		lbl.Parent = visualPage
	end
	mkSect(visualPage, "Personalización")
	do
		local row = mkRow(visualPage, 38)
		mkLabel(row, "Anim Pack")
		local currentIndex = 1
		for i, entry in ipairs(ANIM_PACK_ORDER) do
			if entry[2] == currentAnimPack then
				currentIndex = i
				break
			end
		end
		local container = Instance.new("Frame", row)
		container.Size = UDim2.new(0, 160, 1, 0)
		container.Position = UDim2.new(1, -168, 0, 0)
		container.BackgroundTransparency = 1
		container.ZIndex = 8
		local leftBtn = Instance.new("TextButton", container)
		leftBtn.Size = UDim2.new(0, 28, 0, 26)
		leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
		leftBtn.BackgroundColor3 = INP
		leftBtn.BackgroundTransparency = 0.7
		leftBtn.BorderSizePixel = 0
		leftBtn.Text = "<"
		leftBtn.TextColor3 = WHITE
		leftBtn.Font = Enum.Font.GothamBold
		leftBtn.TextSize = 13
		leftBtn.AutoButtonColor = false
		leftBtn.ZIndex = 9
		Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
		local leftStroke = Instance.new("UIStroke", leftBtn)
		leftStroke.Color = ROW_BORDER
		leftStroke.Thickness = 1
		animSelectorLabel = Instance.new("TextLabel", container)
		animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
		animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
		animSelectorLabel.BackgroundTransparency = 1
		animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
		animSelectorLabel.TextColor3 = WHITE
		animSelectorLabel.Font = Enum.Font.GothamBold
		animSelectorLabel.TextSize = 12
		animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
		animSelectorLabel.ZIndex = 9
		local rightBtn = Instance.new("TextButton", container)
		rightBtn.Size = UDim2.new(0, 28, 0, 26)
		rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
		rightBtn.BackgroundColor3 = INP
		rightBtn.BackgroundTransparency = 0.7
		rightBtn.BorderSizePixel = 0
		rightBtn.Text = ">"
		rightBtn.TextColor3 = WHITE
		rightBtn.Font = Enum.Font.GothamBold
		rightBtn.TextSize = 13
		rightBtn.AutoButtonColor = false
		rightBtn.ZIndex = 9
		Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
		local rightStroke = Instance.new("UIStroke", rightBtn)
		rightStroke.Color = ROW_BORDER
		rightStroke.Thickness = 1
		local function updateAnimSelector(direction)
			local idx = 1
			for i, entry in ipairs(ANIM_PACK_ORDER) do
				if entry[2] == currentAnimPack then
					idx = i
					break
				end
			end
			local newIdx = idx + direction
			if newIdx < 1 then
				newIdx = #ANIM_PACK_ORDER
			end
			if newIdx > #ANIM_PACK_ORDER then
				newIdx = 1
			end
			local packName = ANIM_PACK_ORDER[newIdx][2]
			if packName == "Off" then
				stopAnimPack()
			else
				startAnimPack(packName)
			end
		end
		leftBtn.MouseButton1Click:Connect(function()
			updateAnimSelector(-1)
		end)
		rightBtn.MouseButton1Click:Connect(function()
			updateAnimSelector(1)
		end)
	end
	setESPVIsual = mkToggle(visualPage, "Player ESP", function(on)
		toggleESP(on)
		saveAllSettings()
	end)
	do
		local row = mkRow(visualPage, 38)
		mkLabel(row, "Stretch Rez")
		local stretchPill, stretchDot = mkPill(row, 48)
		local stretchOn = false
		local function setStretch(s)
			stretchOn = s
			animPill(stretchPill, stretchDot, s)
			if s then
				enableStretch()
			else
				disableStretch()
			end
			stretchEnabled = s
			saveAllSettings()
		end
		local stretchClk = Instance.new("TextButton", stretchPill)
		stretchClk.Size = UDim2.new(1, 0, 1, 0)
		stretchClk.BackgroundTransparency = 1
		stretchClk.Text = ""
		stretchClk.AutoButtonColor = false
		stretchClk.ZIndex = 10
		stretchClk.MouseButton1Click:Connect(function()
			setStretch(not stretchOn)
		end)
		_G.stretchToggleSetter = setStretch
	end
	setFovVisual = mkToggle(visualPage, "FOV", function(on)
		if on then
			enableCustomFov()
		else
			disableCustomFov()
		end
		saveAllSettings()
	end)
	if setFovVisual then
		setFovVisual(fovEnabled)
	end
	do
		local row = mkRow(visualPage, 38)
		mkLabel(row, "FOV Value")
		fovSliderSet = mkSlider(row, 20, 120, fovValue, function(v)
			fovValue = v
			if not fovEnabled then
				enableCustomFov()
				if setFovVisual then
					setFovVisual(true)
				end
			end
			local cam = workspace.CurrentCamera
			if cam then
				pcall(function()
					cam.FieldOfView = fovValue
				end)
			end
		end)
	end
	setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
		if on then
			enableAntiLag()
		else
			disableAntiLag()
		end
		saveAllSettings()
	end)
	do
		local row = mkRow(visualPage, 38)
		mkLabel(row, "Sky Theme")
		local container = Instance.new("Frame", row)
		container.Size = UDim2.new(0, 160, 1, 0)
		container.Position = UDim2.new(1, -168, 0, 0)
		container.BackgroundTransparency = 1
		container.ZIndex = 8
		local leftBtn = Instance.new("TextButton", container)
		leftBtn.Size = UDim2.new(0, 28, 0, 26)
		leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
		leftBtn.BackgroundColor3 = INP
		leftBtn.BackgroundTransparency = 0.7
		leftBtn.BorderSizePixel = 0
		leftBtn.Text = "<"
		leftBtn.TextColor3 = WHITE
		leftBtn.Font = Enum.Font.GothamBold
		leftBtn.TextSize = 13
		leftBtn.AutoButtonColor = false
		leftBtn.ZIndex = 9
		Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
		local leftStroke = Instance.new("UIStroke", leftBtn)
		leftStroke.Color = ROW_BORDER
		leftStroke.Thickness = 1
		skySelectorLabel = Instance.new("TextLabel", container)
		skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
		skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
		skySelectorLabel.BackgroundTransparency = 1
		skySelectorLabel.Text = skyTheme
		skySelectorLabel.TextColor3 = WHITE
		skySelectorLabel.Font = Enum.Font.GothamBold
		skySelectorLabel.TextSize = 11
		skySelectorLabel.TextScaled = false
		skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
		skySelectorLabel.ZIndex = 9
		local rightBtn = Instance.new("TextButton", container)
		rightBtn.Size = UDim2.new(0, 28, 0, 26)
		rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
		rightBtn.BackgroundColor3 = INP
		rightBtn.BackgroundTransparency = 0.7
		rightBtn.BorderSizePixel = 0
		rightBtn.Text = ">"
		rightBtn.TextColor3 = WHITE
		rightBtn.Font = Enum.Font.GothamBold
		rightBtn.TextSize = 13
		rightBtn.AutoButtonColor = false
		rightBtn.ZIndex = 9
		Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
		local rightStroke = Instance.new("UIStroke", rightBtn)
		rightStroke.Color = ROW_BORDER
		rightStroke.Thickness = 1
		local function updateSkySelector(direction)
			local idx = 1
			for i, name in ipairs(SKY_PRESETS_LIST) do
				if name == skyTheme then
					idx = i
					break
				end
			end
			local newIdx = idx + direction
			if newIdx < 1 then
				newIdx = #SKY_PRESETS_LIST
			end
			if newIdx > #SKY_PRESETS_LIST then
				newIdx = 1
			end
			local name = SKY_PRESETS_LIST[newIdx]
			skyTheme = name
			pcall(applyCustomSky, name)
			if skySelectorLabel then
				skySelectorLabel.Text = name
			end
			pcall(saveAllSettings)
		end
		leftBtn.MouseButton1Click:Connect(function()
			updateSkySelector(-1)
		end)
		rightBtn.MouseButton1Click:Connect(function()
			updateSkySelector(1)
		end)
	end
	local configPage = contentPages["Config"]
	mkSect(configPage, "Auto Steal")
	autoStealSetVisual = mkToggle(configPage, "Auto Steal", function(on)
		CONFIG.AUTO_STEAL_ENABLED = on
		if on then
			pcall(startAutoSteal)
		else
			stopAutoSteal()
		end
		updateProgressBarVisibility()
		saveAllSettings()
	end)
	do
		local row = mkRow(configPage, 38)
		mkLabel(row, "Steal Radius")
		radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
			if v and v >= 5 and v <= 300 then
				CONFIG.STEAL_RANGE = _floor(v + 0.5)
				Steal.StealRadius = CONFIG.STEAL_RANGE
				radInput.Text = tostring(CONFIG.STEAL_RANGE)
				saveAllSettings()
			end
		end)
	end
	mkSect(configPage, "SIZA")
	do
		local row = mkRow(configPage, 38)
		mkLabel(row, "Button Size")
		local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
			local val = _clamp(v, 50, 200)
			floatingButtonScale = val / 100
			applyFloatingButtonScale()
			saveAllSettings()
		end)
	end
	do
		local row = mkRow(configPage, 38)
		mkLabel(row, "Steal Bar Scale")
		local box = mkBox(row, _floor(stealBarScale * 100), 50, 56, function(v)
			local val = _clamp(v, 50, 200)
			stealBarScale = val / 100
			applyStealBarScale()
			saveAllSettings()
		end)
	end
	mkSect(configPage, "Interface")
	setLockUIVisual = mkToggle(configPage, "Lock UI", function(on)
		toggleLockUI(on)
		saveAllSettings()
	end)
	local hideButtonSetVisual = mkToggle(configPage, "Hide Button", function(on)
		setFloatingButtonsHidden(on)
		saveAllSettings()
	end)
	if hideButtonSetVisual then
		hideButtonSetVisual(hideButtonsEnabled)
	end
	mkSect(configPage, "Config Management")
	do
		local row = mkRow(configPage, 44)
		row.Size = UDim2.new(1, 0, 0, 44)
		local saveBtn = Instance.new("TextButton", row)
		saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
		saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
		saveBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		saveBtn.BackgroundTransparency = 0.5
		saveBtn.BorderSizePixel = 0
		saveBtn.Text = "SAVE CONFIG"
		saveBtn.TextColor3 = WHITE
		saveBtn.Font = Enum.Font.GothamBold
		saveBtn.TextSize = 13
		saveBtn.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
		saveBtn.TextStrokeTransparency = 0
		saveBtn.AutoButtonColor = false
		saveBtn.ZIndex = 8
		Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
		local saveStroke = Instance.new("UIStroke", saveBtn)
		saveStroke.Color = ROW_BORDER
		saveStroke.Thickness = 1.2
		saveStroke.Transparency = 0.5
		saveBtn.MouseButton1Click:Connect(function()
			local ok = saveAllSettings()
			saveBtn.Text = ok and "SAVED ✓" or "ERROR"
			task.delay(1.2, function()
				if saveBtn and saveBtn.Parent then
					saveBtn.Text = "SAVE CONFIG"
				end
			end)
		end)
	end
	do
		local row = mkRow(configPage, 44)
		row.Size = UDim2.new(1, 0, 0, 44)
		local resetPosBtn = Instance.new("TextButton", row)
		resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
		resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
		resetPosBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		resetPosBtn.BackgroundTransparency = 0.5
		resetPosBtn.BorderSizePixel = 0
		resetPosBtn.Text = "RESET POSITIONS"
		resetPosBtn.TextColor3 = WHITE
		resetPosBtn.Font = Enum.Font.GothamBold
		resetPosBtn.TextSize = 13
		resetPosBtn.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
		resetPosBtn.TextStrokeTransparency = 0
		resetPosBtn.AutoButtonColor = false
		resetPosBtn.ZIndex = 8
		Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 8)
		local resetStroke = Instance.new("UIStroke", resetPosBtn)
		resetStroke.Color = ROW_BORDER
		resetStroke.Thickness = 1.2
		resetStroke.Transparency = 0.5
		local resetDebounce = false
		resetPosBtn.MouseButton1Click:Connect(function()
			if resetDebounce then
				return
			end
			resetDebounce = true
			resetFloatingPositions()
			resetPosBtn.Text = "RESET ✓"
			task.delay(1.2, function()
				if resetPosBtn and resetPosBtn.Parent then
					resetPosBtn.Text = "RESET POSITIONS"
					resetDebounce = false
				end
			end)
		end)
	end
	do
		local row = mkRow(configPage, 44)
		row.Size = UDim2.new(1, 0, 0, 44)
		local delBtn = Instance.new("TextButton", row)
		delBtn.Size = UDim2.new(1, -12, 0.8, 0)
		delBtn.Position = UDim2.new(0, 6, 0.1, 0)
		delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		delBtn.BackgroundTransparency = 0.5
		delBtn.BorderSizePixel = 0
		delBtn.Text = "DELETE SETTINGS"
		delBtn.TextColor3 = WHITE
		delBtn.Font = Enum.Font.GothamBold
		delBtn.TextSize = 13
		delBtn.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
		delBtn.TextStrokeTransparency = 0
		delBtn.AutoButtonColor = false
		delBtn.ZIndex = 8
		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
		local delStroke = Instance.new("UIStroke", delBtn)
		delStroke.Color = ROW_BORDER
		delStroke.Thickness = 1.2
		delStroke.Transparency = 0.5
		local deleteState = 0
		local originalDeleteText = "DELETE SETTINGS"
		local delDebounce = false
		delBtn.MouseButton1Click:Connect(function()
			if delDebounce then
				return
			end
			if deleteState == 0 then
				deleteState = 1
				delBtn.Text = "CONFIRM?"
				delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				task.delay(2, function()
					if delBtn and delBtn.Parent and deleteState == 1 then
						deleteState = 0
						delBtn.Text = originalDeleteText
						delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					end
				end)
			elseif deleteState == 1 then
				delDebounce = true
				local success = pcall(resetToFactoryDefaults)
				delBtn.Text = success and "DELETED ✓" or "ERROR"
				delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				deleteState = 0
				task.delay(1.5, function()
					if delBtn and delBtn.Parent then
						delBtn.Text = originalDeleteText
						delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						delDebounce = false
					end
				end)
			end
		end)
	end
	local keyPage = contentPages["Keybinds"]
	mkSect(keyPage, "Keybinds")
	addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
	addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
	addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
	addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
		addKeybindRow(keyPage, "TP BAT", KB.TPBat)
	addKeybindRow(keyPage, "Bat Bypass", KB.BatV2)
	addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
	addKeybindRow(keyPage, "TP Down", KB.TPFloor)
	addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
	addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)
	local spacer = Instance.new("Frame", keyPage)
	spacer.Size = UDim2.new(1, 0, 0, 16)
	spacer.BackgroundTransparency = 1
	spacer.LayoutOrder = getNextOrder(keyPage)
	spacer.ZIndex = 7
	-- Clean-style HUD; only presentation changes, with a 20px progress line.
	local ampStealWidth = 320
	local ampStealHeight = 70
	local function applyStealBarScale()
		if not pbFrame or not pbScale then
			return
		end
		local camera = workspace.CurrentCamera
		local viewportWidth = camera and camera.ViewportSize.X or 393
		local requested = (uiScaleValue / 100) * _clamp(stealBarScale, 0.5, 2)
		pbScale.Scale = math.min(requested, math.max(0.1, (viewportWidth - 24) / ampStealWidth))
		pbFrame.Size = UDim2.fromOffset(ampStealWidth, ampStealHeight)
		if not savedProgressBarPos then
			pbFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
		end
	end
	pbFrame = Instance.new("Frame", gui)
	pbFrame.Name = "AmpStealBar"
	pbFrame.Size = UDim2.fromOffset(ampStealWidth, ampStealHeight)
	pbFrame.AnchorPoint = Vector2.new(0.5, 0)
	pbFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
	pbFrame.BackgroundColor3 = main.BackgroundColor3
	pbFrame.BackgroundTransparency = main.BackgroundTransparency
	pbFrame.BorderSizePixel = 0
	pbFrame.Active = true
	pbFrame.ClipsDescendants = true
	pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
	pbFrame.ZIndex = 50
	pbScale = Instance.new("UIScale", pbFrame)
	applyStealBarScale()
	if savedProgressBarPos then
		pbFrame.Position = UDim2.new(
			savedProgressBarPos.XScale or 0.5,
			savedProgressBarPos.XOffset or 0,
			savedProgressBarPos.YScale or 0.8,
			savedProgressBarPos.YOffset or 0
		)
	end
	Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 14)
	-- Reuse the GUI image itself instead of guessing a flat matching color.
	local stealBackground = Instance.new("ImageLabel", pbFrame)
	stealBackground.Name = "BackgroundImage"
	stealBackground.Size = UDim2.fromScale(1, 1)
	stealBackground.BackgroundTransparency = 1
	stealBackground.BorderSizePixel = 0
	stealBackground.Image = bgImage.Image
	stealBackground.ImageColor3 = bgImage.ImageColor3
	stealBackground.ImageTransparency = bgImage.ImageTransparency
	stealBackground.ScaleType = bgImage.ScaleType
	stealBackground.ZIndex = 50
	Instance.new("UICorner", stealBackground).CornerRadius = UDim.new(0, 14)
	local barBorder = Instance.new("UIStroke", pbFrame)
	barBorder.Color = Color3.fromRGB(255, 255, 255)
	barBorder.Thickness = 1
	barBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local avatarImage = Instance.new("ImageLabel", pbFrame)
	avatarImage.Name = "PlayerCharacter"
	avatarImage.Size = UDim2.fromOffset(52, 52)
	avatarImage.Position = UDim2.fromOffset(10, 9)
	avatarImage.BackgroundTransparency = 1
	avatarImage.BorderSizePixel = 0
	avatarImage.ScaleType = Enum.ScaleType.Fit
	avatarImage.Image = "rbxthumb://type=Avatar&id=" .. tostring(LP.UserId) .. "&w=420&h=420"
	avatarImage.ZIndex = 54
	task.spawn(function()
		for attempt = 1, 5 do
			if not avatarImage.Parent then
				return
			end
			local ok, image, ready = pcall(function()
				return Players:GetUserThumbnailAsync(
					LP.UserId,
					Enum.ThumbnailType.AvatarThumbnail,
					Enum.ThumbnailSize.Size420x420
				)
			end)
			if ok and ready and type(image) == "string" and image ~= "" then
				if avatarImage.Parent then
					avatarImage.Image = image
				end
				return
			end
			task.wait(1)
		end
	end)
	local fpsLabel = Instance.new("TextLabel", pbFrame)
	fpsLabel.Name = "FPSNeon"
	fpsLabel.Size = UDim2.new(1, -84, 0, 14)
	fpsLabel.Position = UDim2.fromOffset(72, 6)
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.Text = "--FPS · --ms"
	fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	fpsLabel.Font = Enum.Font.SciFi
	fpsLabel.TextSize = 11
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
	fpsLabel.TextStrokeTransparency = 1
	fpsLabel.ZIndex = 54
	local progressRow = Instance.new("Frame", pbFrame)
	progressRow.Name = "ProgressRow"
	progressRow.Size = UDim2.new(1, -84, 0, 20)
	progressRow.Position = UDim2.fromOffset(72, 28)
	progressRow.BackgroundTransparency = 1
	progressRow.ZIndex = 51
	local fillRegion = Instance.new("Frame", progressRow)
	fillRegion.Name = "FillRegion"
	fillRegion.Size = UDim2.fromScale(1, 1)
	fillRegion.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	fillRegion.BackgroundTransparency = 0.3
	fillRegion.BorderSizePixel = 0
	fillRegion.ClipsDescendants = true
	fillRegion.ZIndex = 52
	Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 7)
	local trackBorder = Instance.new("UIStroke", fillRegion)
	trackBorder.Color = Color3.fromRGB(255, 255, 255)
	trackBorder.Thickness = 1
	trackBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	progressFill = Instance.new("Frame", fillRegion)
	progressFill.Size = UDim2.fromScale(0, 1)
	progressFill.Position = UDim2.fromOffset(0, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	progressFill.BorderSizePixel = 0
	progressFill.ZIndex = 53
	Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 7)
	local fillGrad = Instance.new("UIGradient", progressFill)
	fillGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	fillGrad.Rotation = 0
	progressPct = Instance.new("TextLabel", fillRegion)
	progressPct.Name = "ProgressPercentage"
	progressPct.Size = UDim2.fromScale(1, 1)
	progressPct.Position = UDim2.fromOffset(0, 0)
	progressPct.BackgroundTransparency = 1
	progressPct.Text = "0%"
	progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
	progressPct.Font = Enum.Font.SciFi
	progressPct.TextSize = 11
	progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	progressPct.TextStrokeTransparency = 0.3
	progressPct.ZIndex = 56
	drag(pbFrame)
	local frameCount = 0
	local frameConn = RunService.RenderStepped:Connect(function()
		frameCount += 1
	end)
	local lastStats = _tick()
	task.spawn(function()
		while pbFrame and pbFrame.Parent do
			local now = _tick()
			if not isStealing then
				progressFill.Size = UDim2.fromScale(0, 1)
				progressPct.Text = "0%"
			end
			if now - lastStats >= 0.35 then
				local ping = 0
				pcall(function()
					ping = LP:GetNetworkPing() * 1000
				end)
				fpsLabel.Text = string.format("%dFPS · %dms", _floor(frameCount / (now - lastStats)), _floor(ping))
				frameCount = 0
				lastStats = now
				applyStealBarScale()
			end
			task.wait(0.05)
		end
		frameConn:Disconnect()
	end)
	drag(main)
	local _lastSavePos = 0
	main:GetPropertyChangedSignal("Position"):Connect(function()
		local now = _tick()
		if now - _lastSavePos < 0.5 then
			return
		end
		_lastSavePos = now
		saveGuiPos()
	end)
end
function createMobilePanel()
	local panel = Instance.new("ScreenGui")
	panel.Name = "AmpDuelsMobilePanel"
	panel.ResetOnSpawn = false
	panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(panel)
		end
	end)
	local okPanel = pcall(function()
		panel.Parent = game:GetService("CoreGui")
	end)
	if not okPanel then
		panel.Parent = LP:WaitForChild("PlayerGui")
	end
	local BTN_W, BTN_H = 60, 60
	local GAP = 8
	local COLUMNS = 2
	local ROWS = 4
	local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
	local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)
	local container = Instance.new("Frame", panel)
	container.Name = "FloatingPanel"
	container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
	container.AnchorPoint = Vector2.new(1, 0)
	container.Position = UDim2.new(1, -10, 0, 10 + 70 * floatingButtonScale)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Active = true
	container.Selectable = true
	container.ClipsDescendants = false
	local containerScale = Instance.new("UIScale", container)
	containerScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, containerScale)
	local btnContainer = Instance.new("Frame", container)
	btnContainer.Name = "ButtonsContainer"
	btnContainer.Size = UDim2.new(1, 0, 1, 0)
	btnContainer.BackgroundTransparency = 1
	btnContainer.ClipsDescendants = false
	local SILVER = Color3.fromRGB(181, 181, 181)
	local WHITE = Color3.fromRGB(255, 255, 255)
	local INACTIVE_BG = Color3.fromRGB(10, 10, 10)
	local INACTIVE_TEXT = Color3.fromRGB(225, 225, 225)
	local STROKE_COLOR = Color3.fromRGB(70, 70, 70)
	local ACTIVE_BG = getThemeColor()
	local ACTIVE_TEXT = WHITE
	local buttons = {}
	local buttonNames = { "DropBR", "AutoLeft", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2" }
	local buttonTexts =
		{ "DROP\nBR", "AUTO\nLEFT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\n1", "LAGGER\n2" }
	local function createButton(name, text, order, isToggle, callback)
		local btn = Instance.new("TextButton", btnContainer)
		btn.Name = name
		btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
		btn.BackgroundColor3 = INACTIVE_BG
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.ZIndex = 10
		local savedPos = savedButtonPositions[name]
		if savedPos then
			btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
		else
			local defX, defY = getDefaultButtonPosition(name)
			btn.Position = UDim2.new(0, defX, 0, defY)
		end
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
		local bgGrad = Instance.new("UIGradient", btn)
		bgGrad.Name = "BtnGrad"
		bgGrad.Rotation = 90
		bgGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252, 252, 252)),
			ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 233)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(169, 169, 169)),
		})
		local stroke = Instance.new("UIStroke", btn)
		stroke.Color = Color3.fromRGB(121, 121, 121)
		stroke.Thickness = 1
		stroke.Transparency = 0.55
		stroke.Name = "NormalStroke"
		local label = Instance.new("TextLabel", btn)
		label.Name = "TextLabel"
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.GothamBlack
		label.TextSize = 11
		label.TextWrapped = true
		label.ZIndex = 12
		local active = false
		local function setActive(state)
			active = state
			btn:SetAttribute("MobActive", state and true or false)
			paintFloatingBtn(btn, state)
		end
		setActive(false)
		local dragging = false
		local hasMoved = false
		local dragStart = nil
		local startPos = nil
		local movedDistance = 0
		local function onInputBegan(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = true
				hasMoved = false
				movedDistance = 0
				dragStart = input.Position
				startPos = btn.Position
				_isDraggingButton = true
			end
		end
		local function onInputChanged(input)
			if not dragging then
				return
			end
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				local delta = input.Position - dragStart
				movedDistance = delta.Magnitude
				if editModeEnabled and not uiLocked then
					hasMoved = true
					btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
				end
			end
		end
		local function onInputEnded(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				if dragging then
					if movedDistance < 3 then
						if isToggle then
							if editModeEnabled and not uiLocked then
								if callback then
									callback(function() end)
								end
							else
								if callback then
									callback(setActive)
								end
							end
						else
							if callback then
								callback(setActive, active)
							end
						end
					elseif editModeEnabled and not uiLocked and hasMoved then
						savedButtonPositions[name] = { X = btn.Position.X.Offset, Y = btn.Position.Y.Offset }
					end
					dragging = false
					hasMoved = false
					dragStart = nil
					startPos = nil
					movedDistance = 0
					_isDraggingButton = false
				end
			end
		end
		btn.InputBegan:Connect(onInputBegan)
		btn.InputChanged:Connect(onInputChanged)
		btn.InputEnded:Connect(onInputEnded)
		buttons[name] = { btn = btn, setActive = setActive, label = label }
		return setActive
	end
	for i, name in ipairs(buttonNames) do
		local text = buttonTexts[i]
		local callback
		if name == "DropBR" then
			callback = function(setActive)
				if autoBatEnabled then
					return
				end
				setActive(true)
				executeDropWithToggle(function(v)
					if dropBrainrotSetVisual then
						dropBrainrotSetVisual(v)
					end
				end)
				task.delay(0.3, function()
					setActive(false)
				end)
			end
		elseif name == "AutoLeft" then
			callback = function(setActive)
				autoLeftEnabled = not autoLeftEnabled
				setActive(autoLeftEnabled)
				if autoLeftEnabled then
					startAutoLeft()
				else
					stopAutoLeft()
				end
				if autoLeftSetVisual then
					autoLeftSetVisual(autoLeftEnabled)
				end
			end
		elseif name == "AutoBat" then
			callback = function(setActive)
				if not autoBatEnabled then
					enableAutoBat()
				else
					disableAutoBat()
				end
				setActive(autoBatEnabled)
			end
		elseif name == "AutoRight" then
			callback = function(setActive)
				autoRightEnabled = not autoRightEnabled
				setActive(autoRightEnabled)
				if autoRightEnabled then
					startAutoRight()
				else
					stopAutoRight()
				end
				if autoRightSetVisual then
					autoRightSetVisual(autoRightEnabled)
				end
			end
		elseif name == "TpDown" then
			callback = function(setActive)
				doTpDown()
				setActive(true)
				task.delay(0.2, function()
					setActive(false)
				end)
			end
		elseif name == "Carry" then
			callback = function(setActive)
				if not speedMode then
					speedMode = true
					laggerToggled = false
					laggerCarryToggled = false
					setActive(true)
					if buttons.Lagger1 and buttons.Lagger1.setActive then
						buttons.Lagger1.setActive(false)
					end
					if buttons.Lagger2 and buttons.Lagger2.setActive then
						buttons.Lagger2.setActive(false)
					end
				else
					speedMode = false
					setActive(false)
				end
				refreshSpeedModeLabel()
			end
		elseif name == "Lagger1" then
			callback = function(setActive)
				if speedMode then
					speedMode = false
					if mobSetCarry then
						mobSetCarry(false)
					end
				end
				if not laggerToggled then
					laggerToggled = true
					laggerCarryToggled = false
					setActive(true)
					if buttons.Lagger2 and buttons.Lagger2.setActive then
						buttons.Lagger2.setActive(false)
					end
				else
					laggerToggled = false
					setActive(false)
				end
				refreshSpeedModeLabel()
			end
		elseif name == "Lagger2" then
			callback = function(setActive)
				if speedMode then
					speedMode = false
					if mobSetCarry then
						mobSetCarry(false)
					end
				end
				if not laggerCarryToggled then
					laggerCarryToggled = true
					laggerToggled = false
					setActive(true)
					if buttons.Lagger1 and buttons.Lagger1.setActive then
						buttons.Lagger1.setActive(false)
					end
				else
					laggerToggled = false
					setActive(false)
				end
				refreshSpeedModeLabel()
			end
		end
		mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
		mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
		mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
		mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
		mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
		mobSetCarry = buttons.Carry and buttons.Carry.setActive
		mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
		mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive
		local setActive = createButton(name, text, i - 1, true, callback)
		if name == "AutoBat" then
			mobSetAutoBat = setActive
		end
		if name == "AutoLeft" then
			mobSetAutoLeft = setActive
		end
		if name == "AutoRight" then
			mobSetAutoRight = setActive
		end
		if name == "DropBR" then
			mobSetDropBR = setActive
		end
		if name == "TpDown" then
			mobSetTpDown = setActive
		end
		if name == "Carry" then
			mobSetCarry = setActive
		end
		if name == "Lagger1" then
			mobSetLagger1 = setActive
		end
		if name == "Lagger2" then
			mobSetLagger2 = setActive
		end
	end
	-- Auto Bat mobile button removed
	if buttons.AutoLeft and buttons.AutoLeft.setActive then
		buttons.AutoLeft.setActive(autoLeftEnabled)
	end
	if buttons.AutoRight and buttons.AutoRight.setActive then
		buttons.AutoRight.setActive(autoRightEnabled)
	end
	if buttons.Carry and buttons.Carry.setActive then
		buttons.Carry.setActive(speedMode)
	end
	if buttons.Lagger1 and buttons.Lagger1.setActive then
		buttons.Lagger1.setActive(laggerToggled)
	end
	if buttons.Lagger2 and buttons.Lagger2.setActive then
		buttons.Lagger2.setActive(laggerCarryToggled)
	end
	if savedMobilePanelPos then
		container.Position = UDim2.new(
			savedMobilePanelPos.XScale or 1,
			savedMobilePanelPos.XOffset or -10,
			savedMobilePanelPos.YScale or 0,
			savedMobilePanelPos.YOffset or 0
		)
	end
	local draggingPanel = false
	local dragStartPos = nil
	local dragStartMousePos = nil
	local function startDragPanel(input)
		if uiLocked or _isDraggingButton or editModeEnabled then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			draggingPanel = true
			dragStartPos = container.Position
			dragStartMousePos = input.Position
		end
	end
	local function onDragPanel(input)
		if not draggingPanel or uiLocked then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if dragStartPos and dragStartMousePos then
				local delta = input.Position - dragStartMousePos
				local newX = dragStartPos.X.Offset + delta.X
				local newY = dragStartPos.Y.Offset + delta.Y
				container.Position = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
			end
		end
	end
	local function endDragPanel()
		if draggingPanel then
			draggingPanel = false
			savedMobilePanelPos = {
				XScale = container.Position.X.Scale,
				XOffset = container.Position.X.Offset,
				YScale = container.Position.Y.Scale,
				YOffset = container.Position.Y.Offset,
			}
		end
		dragStartPos = nil
		dragStartMousePos = nil
	end
	container.InputBegan:Connect(startDragPanel)
	container.InputEnded:Connect(endDragPanel)
	UIS.InputChanged:Connect(onDragPanel)
	UIS.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			endDragPanel()
		end
	end)
	return panel
end
function createTpBatFloatingButton()
	local SILVER = Color3.fromRGB(181, 181, 181)
	local panel = Instance.new("ScreenGui")
	panel.Name = "TpBatButton"
	panel.ResetOnSpawn = false
	panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	panel.DisplayOrder = 21
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(panel)
		end
	end)
	local okPanel = pcall(function()
		panel.Parent = game:GetService("CoreGui")
	end)
	if not okPanel then
		panel.Parent = LP:WaitForChild("PlayerGui")
	end
	local btnFrame = Instance.new("Frame", panel)
	btnFrame.Size = UDim2.new(0, 60, 0, 60)
	btnFrame.Name = "Frame"
	btnFrame.AnchorPoint = Vector2.new(1, 0)
	if tpBatFloatingPos then
		btnFrame.Position = UDim2.new(
			tpBatFloatingPos.XScale or 1,
			tpBatFloatingPos.XOffset or -10,
			tpBatFloatingPos.YScale or 0,
			tpBatFloatingPos.YOffset or 10
		)
	else
		btnFrame.Position = UDim2.new(1, -10, 0, 10)
	end
	btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btnFrame.BackgroundTransparency = 0
	btnFrame.BorderSizePixel = 0
	btnFrame.ZIndex = 20
	Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
	local bgGrad = Instance.new("UIGradient", btnFrame)
	bgGrad.Name = "BtnGrad"
	bgGrad.Rotation = 90
	bgGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252, 252, 252)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 233)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(169, 169, 169)),
	})
	local stroke = Instance.new("UIStroke", btnFrame)
	stroke.Color = FLOATING_PURPLE
	stroke.Thickness = 2
	stroke.Transparency = 0.3
	stroke.Name = "TpBatStroke"
	local label = Instance.new("TextLabel", btnFrame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "TP\nBAT"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 11
	label.TextWrapped = true
	label.ZIndex = 22
	local uiScale = Instance.new("UIScale", btnFrame)
	uiScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, uiScale)
	local function setActive(state)
		label.Text = "TP\nBAT"
		paintFloatingBtn(btnFrame, state)
	end
	local dragging = false
	local hasMoved = false
	local dragStart, startPos
	btnFrame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			hasMoved = false
			dragStart = inp.Position
			startPos = btnFrame.Position
		end
	end)
	btnFrame.InputChanged:Connect(function(inp)
		if not dragging then
			return
		end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			local delta = inp.Position - dragStart
			if delta.Magnitude > 5 then
				hasMoved = true
			end
			if hasMoved and not uiLocked then
				btnFrame.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end)
	btnFrame.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				if not hasMoved then
					toggleBatDesyncTp()
					setActive(batDesyncTpEnabled)
				elseif not uiLocked and hasMoved then
					tpBatFloatingPos = {
						XScale = btnFrame.Position.X.Scale,
						XOffset = btnFrame.Position.X.Offset,
						YScale = btnFrame.Position.Y.Scale,
						YOffset = btnFrame.Position.Y.Offset,
					}
				end
				dragging = false
				hasMoved = false
			end
		end
	end)
	tpBatFloatingButton = panel
	return panel
end
function createBatV2FloatingButton()
	local SILVER = Color3.fromRGB(181, 181, 181)
	local panel = Instance.new("ScreenGui")
	panel.Name = "BatV2Button"
	panel.ResetOnSpawn = false
	panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	panel.DisplayOrder = 22
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(panel)
		end
	end)
	local okPanel = pcall(function()
		panel.Parent = game:GetService("CoreGui")
	end)
	if not okPanel then
		panel.Parent = LP:WaitForChild("PlayerGui")
	end
	local btnFrame = Instance.new("Frame", panel)
	btnFrame.Size = UDim2.new(0, 60, 0, 60)
	btnFrame.Name = "Frame"
	btnFrame.AnchorPoint = Vector2.new(1, 0)
	if batV2FloatingPos then
		btnFrame.Position = UDim2.new(
			batV2FloatingPos.XScale or 1,
			batV2FloatingPos.XOffset or (-10 - 70 * floatingButtonScale),
			batV2FloatingPos.YScale or 0,
			batV2FloatingPos.YOffset or 10
		)
	else
		btnFrame.Position = UDim2.new(1, -10 - 70 * floatingButtonScale, 0, 10)
	end
	btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btnFrame.BackgroundTransparency = 0
	btnFrame.BorderSizePixel = 0
	btnFrame.ZIndex = 20
	Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
	local bgGrad = Instance.new("UIGradient", btnFrame)
	bgGrad.Name = "BtnGrad"
	bgGrad.Rotation = 90
	bgGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252, 252, 252)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 233)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(169, 169, 169)),
	})
	local stroke = Instance.new("UIStroke", btnFrame)
	stroke.Color = FLOATING_PURPLE
	stroke.Thickness = 2
	stroke.Transparency = 0
	local label = Instance.new("TextLabel", btnFrame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "BAT\nV2"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 11
	label.TextWrapped = true
	label.ZIndex = 22
	local uiScale = Instance.new("UIScale", btnFrame)
	uiScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, uiScale)
	local function setActive(state)
		paintFloatingBtn(btnFrame, state)
	end
	local dragging = false
	local hasMoved = false
	local dragStart, startPos
	btnFrame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			hasMoved = false
			dragStart = inp.Position
			startPos = btnFrame.Position
		end
	end)
	btnFrame.InputChanged:Connect(function(inp)
		if not dragging then
			return
		end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			local delta = inp.Position - dragStart
			if delta.Magnitude > 5 then
				hasMoved = true
			end
			if hasMoved and not uiLocked then
				btnFrame.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end)
	btnFrame.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				if not hasMoved then
					setActive(not autoBatV2Enabled)
					toggleBatV2()
				elseif not uiLocked and hasMoved then
					batV2FloatingPos = {
						XScale = btnFrame.Position.X.Scale,
						XOffset = btnFrame.Position.X.Offset,
						YScale = btnFrame.Position.Y.Scale,
						YOffset = btnFrame.Position.Y.Offset,
					}
				end
				dragging = false
				hasMoved = false
			end
		end
	end)
	batV2FloatingButton = panel
	return panel
end
function createInstaResetFloatingButton()
	local panel = Instance.new("ScreenGui")
	panel.Name = "InstaResetButton"
	panel.ResetOnSpawn = false
	panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	panel.DisplayOrder = 23
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(panel)
		end
	end)
	local okPanel = pcall(function()
		panel.Parent = game:GetService("CoreGui")
	end)
	if not okPanel then
		panel.Parent = LP:WaitForChild("PlayerGui")
	end
	local btnFrame = Instance.new("Frame", panel)
	btnFrame.Size = UDim2.new(0, 60, 0, 60)
	btnFrame.Name = "Frame"
	btnFrame.AnchorPoint = Vector2.new(1, 0)
	if instaResetFloatingPos then
		btnFrame.Position = UDim2.new(
			instaResetFloatingPos.XScale or 1,
			instaResetFloatingPos.XOffset or (-10 - 140 * floatingButtonScale),
			instaResetFloatingPos.YScale or 0,
			instaResetFloatingPos.YOffset or 10
		)
	else
		btnFrame.Position = UDim2.new(1, -10 - 140 * floatingButtonScale, 0, 10)
	end
	btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btnFrame.BorderSizePixel = 0
	btnFrame.ZIndex = 20
	Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
	local bgGrad = Instance.new("UIGradient", btnFrame)
	bgGrad.Name = "BtnGrad"
	bgGrad.Rotation = 90
	bgGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252, 252, 252)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 233)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(169, 169, 169)),
	})
	local stroke = Instance.new("UIStroke", btnFrame)
	stroke.Color = FLOATING_PURPLE
	stroke.Thickness = 2
	stroke.Transparency = 0
	local label = Instance.new("TextLabel", btnFrame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "INSTA\nRESET"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 11
	label.TextWrapped = true
	label.ZIndex = 22
	local uiScale = Instance.new("UIScale", btnFrame)
	uiScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, uiScale)
	local dragging, hasMoved, dragStart, startPos, activeInput
	local RESET_TAP_THRESHOLD = 12
	local function pointInside(pos)
		local ap = btnFrame.AbsolutePosition
		local as = btnFrame.AbsoluteSize
		return pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
	end
	local function setActive(state)
		if state then
			TS:Create(btnFrame, TweenInfo.new(0.05), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
			TS:Create(label, TweenInfo.new(0.05), { TextColor3 = Color3.fromRGB(0, 0, 0) }):Play()
		else
			paintFloatingBtn(btnFrame, false)
		end
	end
	btnFrame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if activeInput then
				return
			end
			activeInput = inp
			dragging = true
			hasMoved = false
			dragStart = inp.Position
			startPos = btnFrame.Position
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if not dragging or not activeInput then
			return
		end
		local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
		local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1
			and inp.UserInputType == Enum.UserInputType.MouseMovement
		if not isTouchMove and not isMouseMove then
			return
		end
		local delta = inp.Position - dragStart
		if delta.Magnitude > RESET_TAP_THRESHOLD then
			hasMoved = true
		end
		if hasMoved and not uiLocked then
			btnFrame.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp ~= activeInput then
			return
		end
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if dragging then
			local delta = inp.Position - dragStart
			local validTap = not hasMoved and delta.Magnitude <= RESET_TAP_THRESHOLD and pointInside(inp.Position)
			if validTap then
				print("[IR] tap → instaReset()")
				setActive(true)
				if _G.InstaReset and _G.InstaReset.Trigger then
					_G.InstaReset.Trigger()
				end
				task.delay(0.2, function()
					setActive(false)
				end)
			elseif not uiLocked and hasMoved then
				instaResetFloatingPos = {
					XScale = btnFrame.Position.X.Scale,
					XOffset = btnFrame.Position.X.Offset,
					YScale = btnFrame.Position.Y.Scale,
					YOffset = btnFrame.Position.Y.Offset,
				}
				pcall(saveAllSettings)
			end
			dragging = false
			hasMoved = false
			activeInput = nil
		end
	end)
	instaResetFloatingButton = panel
	return panel
end
batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil
local _batCounterV2OriginalTpState = false
local _batCounterV2SuppressCount = 0
local _lastBatCounterV2Time = 0
local _batCounterV2Cooldown = 0.01
local function isPlayerRagdolled(player)
	if not player or not player.Character then
		return false
	end
	local hum = player.Character:FindFirstChildOfClass("Humanoid")
	if not hum then
		return false
	end
	local state = hum:GetState()
	return state == Enum.HumanoidStateType.Physics
		or state == Enum.HumanoidStateType.Ragdoll
		or state == Enum.HumanoidStateType.FallingDown
end
local function hasAnimalEquipped(player)
	if not player or not player.Character then
		return false
	end
	for _, child in ipairs(player.Character:GetChildren()) do
		if child:IsA("Tool") then
			if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then
				return true
			end
		end
	end
	return false
end
local function getAttackingPlayerWithAnimal()
	local myChar = LP.Character
	if not myChar then
		return nil
	end
	local myRoot = myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then
		return nil
	end
	local closest, minDist = nil, _huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			if not hasAnimalEquipped(plr) then
				continue
			end
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - myRoot.Position).Magnitude
				if dist < 12 and dist < minDist then
					minDist = dist
					closest = plr
				end
			end
		end
	end
	return closest
end
local function getBatV2Counter()
	local char = LP.Character
	if not char then
		return nil
	end
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") then
			local name = child.Name:lower()
			if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
				return child
			end
		end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, child in ipairs(bp:GetChildren()) do
			if child:IsA("Tool") then
				local name = child.Name:lower()
				if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
					child.Parent = char
					return child
				end
			end
		end
	end
	if bp then
		for _, child in ipairs(bp:GetChildren()) do
			if child:IsA("Tool") then
				child.Parent = char
				return child
			end
		end
	end
	return nil
end
local function tryHitBatCounterV2()
	if batCounterV2HitCooldown then
		return
	end
	batCounterV2HitCooldown = true
	pcall(function()
		local bat = getBatV2Counter()
		if bat then
			bat:Activate()
			local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
			if ev then
				ev:FireServer()
			end
		end
	end)
	task.delay(BAT_COUNTER_V2_SWING_CD, function()
		batCounterV2HitCooldown = false
	end)
end
local function executeBatCounterV2()
	local now = _tick()
	if now - _lastBatCounterV2Time < _batCounterV2Cooldown then
		return
	end
	if batCounterV2Debounce then
		return
	end
	batCounterV2Debounce = true
	_lastBatCounterV2Time = now
	local attacker = getAttackingPlayerWithAnimal()
	if not attacker then
		batCounterV2Debounce = false
		return
	end
	if isPlayerRagdolled(attacker) then
		batCounterV2Debounce = false
		return
	end
	if not hasAnimalEquipped(attacker) then
		batCounterV2Debounce = false
		return
	end
	_batCounterV2OriginalTpState = batDesyncTpEnabled
	local tpWasEnabled = batDesyncTpEnabled
	if not tpWasEnabled then
		startBatDesyncTp()
		if batDesyncTpSetVisual then
			batDesyncTpSetVisual(true)
		end
		if tpBatFloatingButton then
			local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
			if btnFrame then
				btnFrame.BackgroundColor3 = getThemeColor()
				local label = btnFrame:FindFirstChild("TextLabel")
				if label then
					label.TextColor3 = Color3.fromRGB(0, 0, 0)
				end
			end
		end
	end
	local function doCounterHit()
		local char = LP.Character
		if not char then
			return
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		local attChar = attacker.Character
		if not attChar then
			return
		end
		local attRoot = attChar:FindFirstChild("HumanoidRootPart")
		if not attRoot then
			return
		end
		if not hasAnimalEquipped(attacker) then
			batCounterV2Debounce = false
			return
		end
		if sethiddenproperty then
			sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot)
		end
		local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
		if (hrp.Position - targetPos).Magnitude > 8 then
			hrp.CFrame = _CFnew(targetPos)
		end
		tryHitBatCounterV2()
		task.delay(0.05, function()
			tryHitBatCounterV2()
		end)
		task.delay(0.1, function()
			tryHitBatCounterV2()
		end)
	end
	doCounterHit()
	task.delay(0.2, function()
		if not _batCounterV2OriginalTpState and batDesyncTpEnabled then
			stopBatDesyncTp()
			if batDesyncTpSetVisual then
				batDesyncTpSetVisual(false)
			end
			if tpBatFloatingButton then
				local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
				if btnFrame then
					paintFloatingBtn(btnFrame, false)
				end
			end
		end
		batCounterV2Debounce = false
	end)
end
function stopBatCounterV2()
	if batCounterV2Conn then
		batCounterV2Conn:Disconnect()
		batCounterV2Conn = nil
	end
	batCounterV2Debounce = false
	batCounterV2HitCooldown = false
end
function startBatCounterV2()
	if batCounterV2Conn then
		return
	end
	batCounterV2Conn = RunService.Heartbeat:Connect(function()
		if not batCounterV2Enabled then
			return
		end
		if batCounterV2Debounce then
			return
		end
		local character = LP.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return
		end
		local state = humanoid:GetState()
		local isBeingAttacked = state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown
			or state == Enum.HumanoidStateType.GettingUp
			or state == Enum.HumanoidStateType.Stunned
		if isBeingAttacked then
			local attacker = getAttackingPlayerWithAnimal()
			if attacker then
				if not isPlayerRagdolled(attacker) then
					if hasAnimalEquipped(attacker) then
						executeBatCounterV2()
					end
				end
			end
		end
	end)
end
function toggleBatCounterV2()
	batCounterV2Enabled = not batCounterV2Enabled
	if batCounterV2Enabled then
		startBatCounterV2()
	else
		stopBatCounterV2()
	end
	return batCounterV2Enabled
end
function updateUIFromLoaded()
	task.wait()
	if normalBox then
		normalBox.Text = tostring(NS)
	end
	if carryBox then
		carryBox.Text = tostring(CS)
	end
	if radInput then
		radInput.Text = tostring(CONFIG.STEAL_RANGE)
	end
	if laggerBox then
		laggerBox.Text = tostring(LAGGER_SPEED)
	end
	if lagger2Box then
		lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
	end
	if batSpeedBox then
		batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
	end
	if uiScaleBox then
		uiScaleBox.Text = tostring(uiScaleValue)
	end
	if dropModeBtnRef then
		dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
	end
	if bodyLockRangeBox then
		bodyLockRangeBox.Text = tostring(bodyLockRange)
	end
	if carrySysNormalBox then
		carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed)
	end
	if carrySysCarryBox then
		carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed)
	end
	if carrySysLaggerBox then
		carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed)
	end
	if carrySysLaggerCarryBox then
		carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed)
	end
	if carrySysSoftStealSpeedBox then
		carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed)
	end
	if carrySysSoftStealRadiusBox then
		carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius)
	end
	if carrySystemToggleSetter then
		carrySystemToggleSetter(useCarrySystem)
	end
	refreshSpeedModeLabel()
	for _, ref in ipairs(keyButtonRefs) do
		local entry = ref.entry
		local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
		ref.btn.Text = label
	end
	if savedProgressBarPos and pbFrame then
		pbFrame.Position = UDim2.new(
			savedProgressBarPos.XScale or 0.5,
			savedProgressBarPos.XOffset or -200,
			savedProgressBarPos.YScale or 1,
			savedProgressBarPos.YOffset or -60
		)
	end
	local bgImg = main and main:FindFirstChild("BackgroundImage")
	if bgImg then
		bgImg.Image = backgroundImages[backgroundIndex]
		bgImg.ImageTransparency = backgroundImageTransparency
	end
	applyFloatingButtonScale()
	if uiLocked and setLockUIVisual then
		setLockUIVisual(true)
	end
	if editModeEnabled and setEditModeVisual then
		setEditModeVisual(true)
	end
	if _G.updateAntiRagdollUI then
		_G.updateAntiRagdollUI(antiRagdollMode)
	end
	if antiRagdollMode == "v1" then
		AntiRagdollV1.start()
	elseif antiRagdollMode == "v2" then
		startAntiRagdollV2()
	end
	if antiDieEnabled then
		if setAntiDieVisual then
			setAntiDieVisual(true)
		end
		AntiDieModule.start()
	else
		if setAntiDieVisual then
			setAntiDieVisual(false)
		end
	end
	if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then
		setInstaGrab(true)
		pcall(startAutoSteal)
	end
	if medusaCounterEnabled then
		if setMedusaVisual then
			setMedusaVisual(true)
		end
		if LP.Character then
			setupMedusaCounter(LP.Character)
		end
	else
		if setMedusaVisual then
			setMedusaVisual(false)
		end
		stopMedusaCounter()
	end
	if batCounterEnabled and setBatCounterVisual then
		setBatCounterVisual(true)
		startBatCounter()
	end
	if batCounterV2Enabled and setBatCounterV2Visual then
		setBatCounterV2Visual(true)
		startBatCounterV2()
	end
	if unwalkEnabled and setUnwalkVisual then
		setUnwalkVisual(true)
		task.spawn(function()
			task.wait(0.5)
			startUnwalk()
		end)
	end
	if antiLagEnabled then
		if setAntiLagVisual then
			setAntiLagVisual(true)
		end
		enableAntiLag()
	else
		if setAntiLagVisual then
			setAntiLagVisual(false)
		end
		disableAntiLag()
	end
	if espEnabled then
		toggleESP(true)
		if setESPVIsual then
			setESPVIsual(true)
		end
	else
		toggleESP(false)
		if setESPVIsual then
			setESPVIsual(false)
		end
	end
	if batDesyncTpEnabled then
		if batDesyncTpSetVisual then
			batDesyncTpSetVisual(true)
		end
		if not batDesyncTpConn then
			startBatDesyncTp()
		end
		updateTpBatButtonWithAntiDie(true)
	else
		if batDesyncTpSetVisual then
			batDesyncTpSetVisual(false)
		end
		updateTpBatButtonWithAntiDie(false)
	end
	if autoBatV2Enabled then
		if autoBatV2SetVisual then
			autoBatV2SetVisual(true)
		end
		startBatV2Aimbot()
		if batV2FloatingButton then
			local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
			if btnFrame then
				btnFrame.BackgroundColor3 = getThemeColor()
				local label = btnFrame:FindFirstChild("TextLabel")
				if label then
					label.TextColor3 = Color3.fromRGB(0, 0, 0)
				end
			end
		end
	else
		if autoBatV2SetVisual then
			autoBatV2SetVisual(false)
		end
		if batV2FloatingButton then
			local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
			if btnFrame then
				paintFloatingBtn(btnFrame, false)
			end
		end
	end
	if neonWeatherEnabled then
		applyNeonWeather()
		if setNeonWeatherVisual then
			setNeonWeatherVisual(true)
		end
	else
		restoreLightingState()
		if setNeonWeatherVisual then
			setNeonWeatherVisual(false)
		end
	end
	if stretchEnabled then
		enableStretch()
		if _G.stretchToggleSetter then
			_G.stretchToggleSetter(true)
		end
	else
		if _G.stretchToggleSetter then
			_G.stretchToggleSetter(false)
		end
	end
	if setFovVisual then
		setFovVisual(fovEnabled)
	end
	if fovSliderSet then
		fovSliderSet(fovValue)
	end
	if mobSetAutoBat then
		mobSetAutoBat(autoBatEnabled)
	end
	if mobSetAutoLeft then
		mobSetAutoLeft(autoLeftEnabled)
	end
	if mobSetAutoRight then
		mobSetAutoRight(autoRightEnabled)
	end
	if mobSetCarry then
		mobSetCarry(speedMode)
	end
	if mobSetLagger1 then
		mobSetLagger1(laggerToggled)
	end
	if mobSetLagger2 then
		mobSetLagger2(laggerCarryToggled)
	end
	if bodyLockEnabled and bodyLockSetVisual then
		if _blSuppressCount == 0 then
			bodyLockSetVisual(true)
			startBodyLock()
		else
			bodyLockSetVisual(false)
		end
	end
	updateProgressBarVisibility()
	startEnemySpeed()
	toggleLockUI(uiLocked)
	if colorSelectorLabel then
		colorSelectorLabel.Text = currentColorTheme
		colorSelectorLabel.TextColor3 = selectedColor
	end
end
buildGui()
if loadAllSettings() then
	updateUIFromLoaded()
end
MobilePanel = createMobilePanel()
tpBatFloatingButton = createTpBatFloatingButton()
batV2FloatingButton = createBatV2FloatingButton()
instaResetFloatingButton = createInstaResetFloatingButton()
setFloatingButtonsHidden(hideButtonsEnabled)
if useCarrySystem then
	CarrySystem:start()
	CarrySystem.speedToggled = speedMode
	if laggerToggled then
	else
		CarrySystem:setLaggerMode(0)
	end
	CarrySystem:setSoftStealEnabled(true)
end
if LP.Character then
	task.wait(0.1)
	if waitForCharReady(LP.Character, 5) then
		setupMovementAndIndicators(LP.Character)
		if currentAnimPack ~= "Off" then
			startAnimPack(currentAnimPack)
		end
	end
end
local _respawnQueue = 0
LP.CharacterAdded:Connect(function(char)
	_respawnQueue = _respawnQueue + 1
	local myId = _respawnQueue
	if stealConnection then
		stealConnection:Disconnect()
		stealConnection = nil
	end
	isStealing = false
	stopAutoLeft()
	stopAutoRight()
	stopBatCounter()
	stopBatCounterV2()
	stopMedusaCounter()
	if not _tpBatUnwalkForced then
		stopUnwalk()
	end
	stopDropBrainrot()
	if autoBatEnabled then
		disableAutoBat()
	end
	if batDesyncTpEnabled then
		stopBatDesyncTp()
	end
	if autoBatV2Enabled then
		disableBatV2()
	end
	if bodyLockEnabled then
		stopBodyLock()
	end
	local deadline = _tick() + 5
	while
		not char.Parent
		or (not char:FindFirstChild("HumanoidRootPart"))
		or (not char:FindFirstChildOfClass("Humanoid"))
	do
		if _tick() > deadline then
			return
		end
		if myId ~= _respawnQueue then
			return
		end
		task.wait(0.05)
	end
	_hookedVelParts = {}
	local _hrpRespawn = _setupVelChecked(char)
	_hookVelHRP(_hrpRespawn)
	setupMovementAndIndicators(char)
	if antiRagdollMode == "v1" then
		AntiRagdollV1.start()
	elseif antiRagdollMode == "v2" then
		startAntiRagdollV2()
	end
	if AntiDieModule.enabled then
		task.defer(function()
			activateOnCharacter(char)
		end)
	end
	if CONFIG.AUTO_STEAL_ENABLED then
		pcall(startAutoSteal)
	end
	if batDesyncTpEnabled then
		task.defer(startBatDesyncTp)
	end
	if autoBatV2Enabled then
		task.defer(startBatV2Aimbot)
	end
	if bodyLockEnabled and _blSuppressCount == 0 then
		startBodyLock()
	end
	if medusaCounterEnabled then
		setupMedusaCounter(char)
		if setMedusaVisual then
			setMedusaVisual(true)
		end
	else
		stopMedusaCounter()
		if setMedusaVisual then
			setMedusaVisual(false)
		end
	end
	if batCounterEnabled then
		startBatCounter()
	end
	if batCounterV2Enabled then
		startBatCounterV2()
	end
	if unwalkEnabled and not _tpBatUnwalkForced then
		startUnwalk()
	end
	if currentAnimPack ~= "Off" then
		task.wait(0.3)
		startAnimPack(currentAnimPack)
	end
	updateProgressBarVisibility()
	refreshSpeedModeLabel()
end)
local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3
UIS.InputBegan:Connect(function(input, gpe)
	if _anyKeyListening then
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if gpe or UIS:GetFocusedTextBox() then
			return
		end
	elseif not isGamepadInput(input) then
		return
	end
	if not isBindableInput(input) then
		return
	end
	local kc = input.KeyCode
	if not kc then
		return
	end
	if kbMatch(KB.LaggerMode, kc) then
		if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
			lastLaggerToggle = _tick()
			toggleLaggerCycle()
		end
		return
	end
	if kbMatch(KB.CarryToggle, kc) then
		toggleCarryMode()
		return
	end
	if kbMatch(KB.DropBrainrot, kc) then
		if not dropActive then
			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(true)
			end
			executeDropWithToggle(dropBrainrotSetVisual)
		end
		return
	end
	if kbMatch(KB.TPFloor, kc) then
		doTpDown()
		return
	end
	if kbMatch(KB.InstaReset, kc) then
		if _G.InstaReset and _G.InstaReset.Trigger then
			_G.InstaReset.Trigger()
		end
		return
	end
	if kbMatch(KB.AutoLeft, kc) then
		autoLeftEnabled = not autoLeftEnabled
		if autoLeftEnabled then
			startAutoLeft()
		else
			stopAutoLeft()
		end
		if autoLeftSetVisual then
			autoLeftSetVisual(autoLeftEnabled)
		end
		if mobSetAutoLeft then
			mobSetAutoLeft(autoLeftEnabled)
		end
		return
	end
	if kbMatch(KB.AutoRight, kc) then
		autoRightEnabled = not autoRightEnabled
		if autoRightEnabled then
			startAutoRight()
		else
			stopAutoRight()
		end
		if autoRightSetVisual then
			autoRightSetVisual(autoRightEnabled)
		end
		if mobSetAutoRight then
			mobSetAutoRight(autoRightEnabled)
		end
		return
	end
		if kbMatch(KB.TPBat, kc) then
		toggleBatDesyncTp()
		if batDesyncTpSetVisual then
			batDesyncTpSetVisual(batDesyncTpEnabled)
		end
		if tpBatFloatingButton then
			local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
			if btnFrame then
				paintFloatingBtn(btnFrame, batDesyncTpEnabled)
			end
		end
		return
	end
	if kbMatch(KB.BatV2, kc) then
		toggleBatV2()
		if autoBatV2SetVisual then
			autoBatV2SetVisual(autoBatV2Enabled)
		end
		if batV2FloatingButton then
			local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
			if btnFrame then
				paintFloatingBtn(btnFrame, autoBatV2Enabled)
			end
		end
		return
	end
	if kbMatch(KB.GuiHide, kc) then
		if main then
			if main.Visible then
				hideGui()
			else
				showGui()
			end
		end
		return
	end
end)
task.delay(8, function()
	local ok, err = pcall(function()
		local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
		if not pg then
			return
		end
		local old = pg:FindFirstChild("AmpDuelsPingNotice")
		if old then
			old:Destroy()
		end
		local ping = 0
		pcall(function()
			ping = LP:GetNetworkPing() * 1000
		end)
		ping = math.floor(ping + 0.5)
		local msg, bg
		if ping < 90 then
			msg = "your ping is " .. ping .. "  go to duel is good"
			bg = Color3.fromRGB(143, 143, 143)
		elseif ping <= 165 then
			msg = "your ping is " .. ping .. "  The choice is yours"
			bg = Color3.fromRGB(174, 174, 174)
		else
			msg = "ur ping is " .. ping .. " not duel u los"
			bg = Color3.fromRGB(81, 81, 81)
		end
		local purple = bg:Lerp(Color3.new(0, 0, 0), 0.24)
		local purple2 = bg:Lerp(Color3.new(0, 0, 0), 0.38)
		local g = Instance.new("ScreenGui")
		g.Name = "AmpDuelsPingNotice"
		g.ResetOnSpawn = false
		g.IgnoreGuiInset = true
		g.DisplayOrder = 10000
		pcall(function()
			if syn and syn.protect_gui then
				syn.protect_gui(g)
			end
		end)
		local parentOk = pcall(function()
			g.Parent = game:GetService("CoreGui")
		end)
		if not parentOk then
			g.Parent = pg
		end

		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0)
		frame.Position = UDim2.new(0.5, 0, 0, -90)
		frame.Size = UDim2.new(0, 320, 0, 44)
		frame.BackgroundColor3 = bg
		frame.BackgroundTransparency = 0.02
		frame.BorderSizePixel = 0
		frame.ClipsDescendants = true
		frame.Parent = g
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

		local outer = Instance.new("UIStroke", frame)
		outer.Color = purple
		outer.Thickness = 2.5
		outer.Transparency = 0

		local inner = Instance.new("UIStroke", frame)
		inner.Color = purple2
		inner.Thickness = 1
		inner.Transparency = 0.15

		local grad = Instance.new("UIGradient", frame)
		grad.Rotation = 90
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, bg:Lerp(Color3.new(1, 1, 1), 0.13)),
			ColorSequenceKeypoint.new(0.48, bg),
			ColorSequenceKeypoint.new(1, bg:Lerp(Color3.new(0, 0, 0), 0.16)),
		})

		local shine = Instance.new("Frame", frame)
		shine.Size = UDim2.new(0, 70, 1, 0)
		shine.Position = UDim2.new(0, -80, 0, 0)
		shine.BackgroundColor3 = Color3.new(1, 1, 1)
		shine.BackgroundTransparency = 0.82
		shine.BorderSizePixel = 0
		shine.Rotation = 12
		shine.ZIndex = 3
		task.spawn(function()
			task.wait(0.7)
			if shine and shine.Parent then
				TweenService:Create(
					shine,
					TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(1, 20, 0, 0) }
				):Play()
			end
		end)

		local topLine = Instance.new("Frame", frame)
		topLine.Size = UDim2.new(0.62, 0, 0, 2)
		topLine.Position = UDim2.new(0.19, 0, 0, 3)
		topLine.BackgroundColor3 = purple
		topLine.BorderSizePixel = 0
		topLine.ZIndex = 4
		Instance.new("UICorner", topLine).CornerRadius = UDim.new(1, 0)

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -22, 1, -8)
		label.Position = UDim2.new(0, 11, 0, 4)
		label.BackgroundTransparency = 1
		label.Text = msg
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 13
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.TextStrokeColor3 = Color3.fromRGB(23, 23, 23)
		label.TextStrokeTransparency = 0.55
		label.TextTransparency = 1
		label.ZIndex = 5

		TweenService:Create(
			frame,
			TweenInfo.new(1.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0.5, 0, 0, 18) }
		):Play()
		TweenService
			:Create(
				label,
				TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ TextTransparency = 0 }
			)
			:Play()
		task.wait(5)
		TweenService:Create(
			frame,
			TweenInfo.new(1.05, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
			{ Position = UDim2.new(0.5, 0, 0, -90), BackgroundTransparency = 1 }
		):Play()
		TweenService
			:Create(label, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
			:Play()
		TweenService:Create(outer, TweenInfo.new(0.7), { Transparency = 1 }):Play()
		TweenService:Create(inner, TweenInfo.new(0.7), { Transparency = 1 }):Play()
		task.wait(1.1)
		if g then
			g:Destroy()
		end
	end)
	if not ok then
		warn("Ping notice error:", err)
	end
end)
--==================================================
-- DONT ENTER / ENTER WARNING
-- Added to AMP Duels
--==================================================

do
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")

	local LocalPlayer = Players.LocalPlayer

	local WARNING_DURATION = 2.3
	local ENTER_DURATION = 2.5
	local ENTER_TWEEN_TIME = 0.4
	local SHOW_TWEEN_TIME = 0.28

	local PURPLE = Color3.fromRGB(55, 55, 55)
	local BLACK = Color3.fromRGB(0, 0, 0)
	local WHITE = Color3.fromRGB(255, 255, 255)

	local NORMAL_WIDTH_MIN = 180
	local NORMAL_WIDTH_MAX = 220
	local NORMAL_HEIGHT = 40
	local NORMAL_Y = 14

	local SAFE_WIDTH_MIN = 130
	local SAFE_WIDTH_MAX = 180
	local SAFE_HEIGHT = 24
	local SAFE_Y = 42

	local DOT_SIZE = 4
	local DOT_STEP = 2

	local gui = Instance.new("ScreenGui")
	gui.Name = "AdaptKickWarning"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local banner = Instance.new("Frame")
	banner.Name = "KickTimerBanner"
	banner.AnchorPoint = Vector2.new(0.5, 0)
	banner.BackgroundColor3 = BLACK
	banner.BorderSizePixel = 0
	banner.ClipsDescendants = false
	banner.Visible = false
	banner.ZIndex = 100
	banner.Parent = gui

	local bannerCorner = Instance.new("UICorner")
	bannerCorner.CornerRadius = UDim.new(1, 0)
	bannerCorner.Parent = banner

	local purpleFill = Instance.new("Frame")
	purpleFill.Name = "PurpleFill"
	purpleFill.BackgroundColor3 = PURPLE
	purpleFill.BorderSizePixel = 0
	purpleFill.Size = UDim2.new(1, 0, 1, 0)
	purpleFill.BackgroundTransparency = 1
	purpleFill.ZIndex = 101
	purpleFill.Parent = banner

	local purpleCorner = Instance.new("UICorner")
	purpleCorner.CornerRadius = UDim.new(1, 0)
	purpleCorner.Parent = purpleFill

	local borderContainer = Instance.new("Frame")
	borderContainer.Name = "ProgressBorderPath"
	borderContainer.BackgroundTransparency = 1
	borderContainer.BorderSizePixel = 0
	borderContainer.Size = UDim2.new(1, 0, 1, 0)
	borderContainer.ClipsDescendants = false
	borderContainer.ZIndex = 102
	borderContainer.Parent = banner

	local text = Instance.new("TextLabel")
	text.Name = "WarningText"
	text.BackgroundTransparency = 1
	text.Size = UDim2.new(1, 0, 1, 0)
	text.Font = Enum.Font.GothamBlack
	text.Text = "DONT ENTER"
	text.TextColor3 = WHITE
	text.TextSize = 11
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.TextYAlignment = Enum.TextYAlignment.Center
	text.ZIndex = 110
	text.Parent = banner

	local segments = {}

	local function ClearSegments()
		for _, seg in ipairs(segments) do
			seg:Destroy()
		end
		table.clear(segments)
	end

	local function CreateDot(x, y)
		local dot = Instance.new("Frame")
		dot.BackgroundColor3 = PURPLE
		dot.BorderSizePixel = 0
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.new(0, x, 0, y)
		dot.Size = UDim2.new(0, DOT_SIZE, 0, DOT_SIZE)
		dot.Visible = false
		dot.ZIndex = 103
		dot.Parent = borderContainer

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(1, 0)
		c.Parent = dot

		segments[#segments + 1] = dot
	end

	local function GetPerimeter(width, height)
		local r = height / 2
		local straightH = width - 2 * r
		local straightV = height - 2 * r
		local arc = (math.pi * r) / 2

		return {
			r = r,
			straightH = straightH,
			straightV = straightV,
			arc = arc,
			total = 2 * straightH + 2 * straightV + 4 * arc,
		}
	end

	local function GetPointOnPath(t, width, height, P)
		local d = t * P.total
		local r = P.r

		if d <= P.arc then
			local a = -math.pi / 2 + (d / P.arc) * (math.pi / 2)
			return (width - r) + math.cos(a) * r, r + math.sin(a) * r
		end
		d = d - P.arc

		if d <= P.straightV then
			return width, r + d
		end
		d = d - P.straightV

		if d <= P.arc then
			local a = (d / P.arc) * (math.pi / 2)
			return (width - r) + math.cos(a) * r, (height - r) + math.sin(a) * r
		end
		d = d - P.arc

		if d <= P.straightH then
			return (width - r) - d, height
		end
		d = d - P.straightH

		if d <= P.arc then
			local a = math.pi / 2 + (d / P.arc) * (math.pi / 2)
			return r + math.cos(a) * r, (height - r) + math.sin(a) * r
		end
		d = d - P.arc

		if d <= P.straightV then
			return 0, (height - r) - d
		end
		d = d - P.straightV

		if d <= P.arc then
			local a = math.pi + (d / P.arc) * (math.pi / 2)
			return r + math.cos(a) * r, r + math.sin(a) * r
		end
		d = d - P.arc

		if d <= P.straightH then
			return r + d, 0
		end

		return r, 0
	end

	local function BuildProgress()
		ClearSegments()

		local width = banner.AbsoluteSize.X
		local height = banner.AbsoluteSize.Y
		if width <= 0 or height <= 0 then
			return
		end

		local P = GetPerimeter(width, height)
		local count = math.max(60, math.floor(P.total / DOT_STEP))

		for i = 0, count - 1 do
			local t = i / count
			local x, y = GetPointOnPath(t, width, height, P)
			CreateDot(x, y)
		end
	end

	local function IsHolding()
		if _G._AdaptSafeModeHoldingBrainrot then
			local ok, res = pcall(_G._AdaptSafeModeHoldingBrainrot)
			if ok and res then
				return true
			end
		end

		if LocalPlayer:GetAttribute("Stealing") == true then
			return true
		end

		local char = LocalPlayer.Character
		if not char then
			return false
		end

		for _, child in ipairs(char:GetChildren()) do
			local n = string.lower(child.Name)
			if
				string.find(n, "brainrot")
				or string.find(n, "brain")
				or string.find(n, "animal")
				or string.find(n, "carry")
				or string.find(n, "stolen")
				or string.find(n, "held")
				or string.find(n, "steal")
			then
				return true
			end
		end

		for name, val in pairs(char:GetAttributes()) do
			if val == true then
				local n = string.lower(name)
				if
					string.find(n, "carrying")
					or string.find(n, "carry")
					or string.find(n, "stealing")
					or string.find(n, "isstealing")
					or string.find(n, "hasbrainrot")
				then
					return true
				end
			end
		end

		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and hum.WalkSpeed > 0 and hum.WalkSpeed <= 25 and hum.WalkSpeed ~= 16 then
			return true
		end

		return false
	end

	local active = false
	local enabled = true
	local hasShown = false
	local lastSpeed = nil

	local function GetSize()
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)

		if _G._AdaptSafeModeHoldingBrainrot then
			local w = math.clamp(math.floor(vp.X * 0.56), SAFE_WIDTH_MIN, SAFE_WIDTH_MAX)
			return w, SAFE_HEIGHT, SAFE_Y
		end

		local w = math.clamp(math.floor(vp.X * 0.25), NORMAL_WIDTH_MIN, NORMAL_WIDTH_MAX)
		return w, NORMAL_HEIGHT, NORMAL_Y
	end

	local function Hide()
		active = false

		if not banner.Visible then
			return
		end

		banner.Visible = false
		purpleFill.BackgroundTransparency = 1
		text.Text = "DONT ENTER"
		text.TextColor3 = WHITE

		for _, seg in ipairs(segments) do
			seg.Visible = false
		end
	end

	local function Show()
		if active or not enabled then
			return
		end

		if hasShown then
			return
		end

		active = true
		hasShown = true

		local w, h, y = GetSize()

		banner.Size = UDim2.new(0, w, 0, h)
		banner.Position = UDim2.new(0.5, 0, 0, -h - 10)
		banner.BackgroundColor3 = BLACK

		purpleFill.BackgroundTransparency = 1
		text.Text = "DONT ENTER"
		text.TextColor3 = WHITE
		banner.Visible = true

		task.wait()
		BuildProgress()

		TweenService:Create(banner, TweenInfo.new(SHOW_TWEEN_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0, y),
		}):Play()

		local startTime = tick()
		local conn

		conn = RunService.RenderStepped:Connect(function()
			if not active then
				conn:Disconnect()
				return
			end

			local p = math.clamp((tick() - startTime) / WARNING_DURATION, 0, 1)

			local amount = math.floor(#segments * p)

			for i, seg in ipairs(segments) do
				seg.Visible = i <= amount
			end

			if p >= 1 then
				conn:Disconnect()

				for _, seg in ipairs(segments) do
					seg.Visible = false
				end

				purpleFill.BackgroundTransparency = 0
				text.Text = "ENTER"
				text.TextColor3 = BLACK

				task.delay(ENTER_DURATION, function()
					if not active then
						return
					end

					TweenService
						:Create(
							banner,
							TweenInfo.new(ENTER_TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
							{
								Position = UDim2.new(0.5, 0, 0, -banner.AbsoluteSize.Y - 10),
							}
						)
						:Play()

					task.wait(0.45)

					if active then
						Hide()
					end
				end)
			end
		end)
	end

	task.spawn(function()
		while gui.Parent do
			task.wait(0.1)

			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if hum then
				local speed = hum.WalkSpeed

				if lastSpeed == nil then
					lastSpeed = speed
				elseif speed ~= lastSpeed then
					lastSpeed = speed
					hasShown = false
				end
			end
		end
	end)

	_G.DontEnterWarning = {
		Show = Show,
		Hide = Hide,

		SetEnabled = function(v)
			enabled = v == true

			if not enabled then
				Hide()
			end
		end,

		IsEnabled = function()
			return enabled
		end,

		Reset = function()
			hasShown = false
		end,

		Destroy = function()
			active = false
			enabled = false

			if gui then
				gui:Destroy()
			end
		end,
	}

	task.spawn(function()
		while gui.Parent do
			task.wait(0.1)

			if enabled then
				if IsHolding() then
					if not active then
						Show()
					end
				else
					if active then
						Hide()
					end
				end
			end
		end
	end)
end

--==================================================
-- END DONT ENTER / ENTER WARNING
--==================================================

--=============================================================
-- BAT SKIN SYSTEM — KATANA SKIN
-- Connected to the Visual > Bat Information > Bat Skin toggle
--=============================================================
task.spawn(function()
	if _G.KatanaSkinLoaded then
		return
	end
	_G.KatanaSkinLoaded = true

	local Players = game:GetService("Players")
	local InsertService = game:GetService("InsertService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Lighting = game:GetService("Lighting")
	local LP = Players.LocalPlayer

	local C = {
		red = Color3.fromRGB(43, 43, 43),
		red2 = Color3.fromRGB(61, 61, 61),
		gold = Color3.fromRGB(208, 208, 208),
	}

	local State = {
		LastBat = nil,
		LastAppliedSkin = nil,
		Original = {},
		ExactTemplates = {},
		ExactSearched = {},
		ExactAssetIds = { KATANA = "" },
		OriginalKatanaTemplate = nil,
	}

	local function findBat()
		local c = LP.Character
		local b = c and c:FindFirstChild("Bat")
		if b and b:IsA("Tool") then
			return b
		end
		local bp = LP:FindFirstChildOfClass("Backpack")
		b = bp and bp:FindFirstChild("Bat")
		return b and b:IsA("Tool") and b or nil
	end

	local function configPart(p)
		if not p or not p:IsA("BasePart") then
			return
		end
		p.Anchored = false
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
		p.Massless = true
	end

	local function weld(p, h)
		if not p or not h or not p:IsA("BasePart") or not h:IsA("BasePart") then
			return
		end
		configPart(p)
		local w = Instance.new("WeldConstraint")
		w.Name = "FlowerSkin_AssetWeld"
		w.Part0 = h
		w.Part1 = p
		w.Parent = p
	end

	local function cache(b)
		if not b then
			return
		end
		State.Original[b] = State.Original[b] or {}
		local o = State.Original[b]
		local h = b:FindFirstChild("Handle")
		local sl = b:FindFirstChild("Slash")
		if h and h:IsA("BasePart") and not o.Handle then
			o.Handle = {
				Transparency = h.Transparency,
				LocalTransparencyModifier = h.LocalTransparencyModifier,
				CastShadow = h.CastShadow,
			}
		end
		if sl and sl:IsA("Sound") and not o.SoundId then
			o.SoundId = sl.SoundId
		end
	end

	local function hideHandle(b, hide)
		local h = b and b:FindFirstChild("Handle")
		if not h or not h:IsA("BasePart") then
			return
		end
		cache(b)
		local o = State.Original[b]
		if hide then
			h.Transparency = 1
			h.LocalTransparencyModifier = 1
			h.CastShadow = false
		else
			local x = o and o.Handle
			h.Transparency = x and x.Transparency or 0
			h.LocalTransparencyModifier = x and x.LocalTransparencyModifier or 0
			h.CastShadow = x and x.CastShadow
			if h.CastShadow == nil then
				h.CastShadow = true
			end
		end
	end

	local function setSound(b, id)
		cache(b)
		local s = b and b:FindFirstChild("Slash")
		if s and s:IsA("Sound") then
			s.SoundId = id or (State.Original[b] and State.Original[b].SoundId) or s.SoundId
		end
	end

	local function removeGenerated(b)
		if not b then
			return
		end
		local f = b:FindFirstChild("FlowerSkin_KatanaRealistic")
		if f then
			f:Destroy()
		end
		local a = b:FindFirstChild("FlowerSkin_AssetKatana")
		if a then
			a:Destroy()
		end
		hideHandle(b, false)
		setSound(b, nil)
	end

	local function effects(p)
		if not p or not p:IsA("BasePart") then
			return
		end
		for _, n in ipairs({ "FlowerSkin_ExtraRedVFX", "FlowerSkin_ExtraRedVFX_End" }) do
			local x = p:FindFirstChild(n)
			if x then
				x:Destroy()
			end
		end
		local a0 = Instance.new("Attachment")
		a0.Name = "FlowerSkin_ExtraRedVFX"
		a0.Position = Vector3.new(0, p.Size.Y * 0.5, 0)
		a0.Parent = p
		local a1 = Instance.new("Attachment")
		a1.Name = "FlowerSkin_ExtraRedVFX_End"
		a1.Position = Vector3.new(0, -p.Size.Y * 0.5, 0)
		a1.Parent = p
		local tr = Instance.new("Trail")
		tr.Name = "FlowerSkin_ExtraRedVFX"
		tr.Attachment0 = a0
		tr.Attachment1 = a1
		tr.Color = ColorSequence.new(C.red2, C.red)
		tr.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
		tr.Lifetime = 0.18
		tr.LightEmission = 0.55
		tr.Parent = p
		local pe = Instance.new("ParticleEmitter")
		pe.Name = "FlowerSkin_ExtraRedVFX"
		pe.Color = ColorSequence.new(C.red, C.red2)
		pe.LightEmission = 0.55
		pe.Rate = 14
		pe.Lifetime = NumberRange.new(0.3, 0.45)
		pe.Speed = NumberRange.new(0.2, 0.7)
		pe.SpreadAngle = Vector2.new(12, 12)
		pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0) })
		pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		pe.Parent = p
	end

	local function noScripts(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
				d:Destroy()
			end
		end
	end

	local function createPart(model, name, size, cf, color, mat)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.CFrame = cf
		p.Color = color
		p.Material = mat or Enum.Material.Neon
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		configPart(p)
		p.Parent = model
		return p
	end

	local function procedural(b)
		local h = b and b:FindFirstChild("Handle")
		if not h or not h:IsA("BasePart") then
			return false
		end
		local f = Instance.new("Folder")
		f.Name = "FlowerSkin_KatanaRealistic"
		f.Parent = b
		local m = Instance.new("Model")
		m.Name = "FlowerSkin_AssetKatana"
		m:SetAttribute("CursedBatSkinsGenerated", true)
		m.Parent = f

		local grip = createPart(
			m,
			"Handle2",
			Vector3.new(0.22, 1, 0.22),
			h.CFrame * CFrame.new(0, -0.48, 0),
			Color3.fromRGB(43, 43, 43),
			Enum.Material.Metal
		)
		local sharp = createPart(
			m,
			"SharpParts",
			Vector3.new(0.18, 2.4, 0.12),
			h.CFrame * CFrame.new(0, 1.05, 0),
			C.red2,
			Enum.Material.Neon
		)
		createPart(
			m,
			"WeaponPart",
			Vector3.new(0.3, 2.7, 0.08),
			h.CFrame * CFrame.new(0.08, 1.15, 0),
			C.red,
			Enum.Material.Neon
		)
		createPart(
			m,
			"GoldAccent",
			Vector3.new(0.5, 0.12, 0.08),
			h.CFrame * CFrame.new(0, -0.28, 0),
			C.gold,
			Enum.Material.Neon
		)
		for _, p in ipairs(m:GetChildren()) do
			if p:IsA("BasePart") then
				weld(p, h)
			end
		end
		m.PrimaryPart = grip
		effects(sharp)
		return true
	end

	local function validate(x)
		if not x then
			return nil
		end
		if x:IsA("Model") or x:IsA("Tool") or x:IsA("Accessory") or x:IsA("BasePart") then
			if x:IsA("BasePart") or x:FindFirstChildWhichIsA("BasePart", true) then
				return x
			end
		end
	end

	local function named(root)
		if not root then
			return nil
		end
		for _, n in ipairs({ "FlowerSkin_AssetKatana", "Katana", "FlowerSkin_KatanaRealistic" }) do
			local x = root.Name == n and root or root:FindFirstChild(n, true)
			x = validate(x)
			if x then
				return x
			end
		end
	end

	local function loadTemplate()
		if State.ExactTemplates.KATANA then
			return State.ExactTemplates.KATANA
		end
		if State.ExactSearched.KATANA then
			return nil
		end
		State.ExactSearched.KATANA = true
		local id = tostring(State.ExactAssetIds.KATANA or ""):gsub("%s+", "")
		if id ~= "" then
			local uri = id:match("^rbxasset") and id or ("rbxassetid://" .. id)
			local ok, objs = pcall(function()
				return game:GetObjects(uri)
			end)
			if ok and objs then
				for _, o in ipairs(objs) do
					local x = named(o) or validate(o)
					if x then
						State.ExactTemplates.KATANA = x:Clone()
						noScripts(State.ExactTemplates.KATANA)
						return State.ExactTemplates.KATANA
					end
				end
			end
			local num = tonumber(id:match("%d+"))
			if num then
				local ok, o = pcall(function()
					return InsertService:LoadAsset(num)
				end)
				if ok and o then
					local x = named(o) or validate(o)
					if x then
						State.ExactTemplates.KATANA = x:Clone()
						noScripts(State.ExactTemplates.KATANA)
						o:Destroy()
						return State.ExactTemplates.KATANA
					end
					o:Destroy()
				end
			end
		end
		for _, r in ipairs({ LP.Character, LP:FindFirstChildOfClass("Backpack"), ReplicatedStorage, Lighting, workspace }) do
			local x = named(r)
			if x then
				State.ExactTemplates.KATANA = x:Clone()
				noScripts(State.ExactTemplates.KATANA)
				return State.ExactTemplates.KATANA
			end
		end
	end

	local function applyTemplate(b)
		local h = b and b:FindFirstChild("Handle")
		local t = loadTemplate()
		if not h or not t then
			return false
		end
		local f = Instance.new("Folder")
		f.Name = "FlowerSkin_KatanaRealistic"
		f.Parent = b
		local m = t:Clone()
		m.Name = "FlowerSkin_AssetKatana"
		m.Parent = f
		noScripts(m)
		local first
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then
				first = first or d
				configPart(d)
			end
		end
		if not first then
			f:Destroy()
			return false
		end
		if m:IsA("Model") then
			m.PrimaryPart = m.PrimaryPart or first
			pcall(function()
				m:PivotTo(h.CFrame)
			end)
		end
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then
				weld(d, h)
			end
		end
		local weapon = m:FindFirstChild("SharpParts", true) or m:FindFirstChild("WeaponPart", true) or first
		effects(weapon)
		return true
	end

	local controller = {}
	controller.State = State
	function controller.ApplySkin(name)
		local b = findBat()
		if not b then
			State.LastBat = nil
			State.LastAppliedSkin = nil
			return false
		end
		cache(b)
		removeGenerated(b)
		if name == "NONE" then
			State.LastBat = b
			State.LastAppliedSkin = "NONE"
			return true
		end
		hideHandle(b, true)
		setSound(b, "rbxassetid://111808555599832")
		if not applyTemplate(b) then
			procedural(b)
		end
		local h = b:FindFirstChild("Handle")
		local fire = h and (h:FindFirstChildOfClass("Fire") or h:FindFirstChild("Fire"))
		if fire and fire:IsA("Fire") then
			fire.Enabled = true
			fire.Color = C.red
			fire.SecondaryColor = C.red2
		end
		State.LastBat = b
		State.LastAppliedSkin = "KATANA"
		return true
	end
	function controller.SetExactAssetId(id)
		State.ExactAssetIds.KATANA = tostring(id or "")
		State.ExactSearched.KATANA = nil
		State.ExactTemplates.KATANA = nil
	end

	_G.KatanaSkin = controller
	if _G.KatanaSkinEnabled == nil then
		_G.KatanaSkinEnabled = false
	end

	if _G.KatanaSkinRespawnConn then
		pcall(function()
			_G.KatanaSkinRespawnConn:Disconnect()
		end)
	end
	_G.KatanaSkinRespawnConn = LP.CharacterAdded:Connect(function()
		if _G.KatanaSkinEnabled then
			task.wait(1)
			pcall(function()
				controller.ApplySkin("KATANA")
			end)
		end
	end)

	task.spawn(function()
		task.wait(1)
		if _G.KatanaSkinEnabled then
			pcall(function()
				controller.ApplySkin("KATANA")
			end)
		end
		while true do
			task.wait(0.5)
			if _G.KatanaSkinEnabled then
				local b = findBat()
				if b and (b ~= State.LastBat or State.LastAppliedSkin ~= "KATANA") then
					pcall(function()
						controller.ApplySkin("KATANA")
					end)
				end
			end
		end
	end)
end)

--=============================================================
-- MINECRAFT BAT SKIN SYSTEM
-- Connected to Visual > Bat Information > Minecraft Bat Skin
--=============================================================
task.spawn(function()
	if _G.MinecraftBatSkinLoaded then
		return
	end
	_G.MinecraftBatSkinLoaded = true
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LP = Players.LocalPlayer
	local colors = {
		Default = nil,
		["Abyss Blue"] = Color3.fromRGB(39, 39, 39),
		["Venom Green"] = Color3.fromRGB(69, 69, 69),
		["Royal Gold"] = Color3.fromRGB(197, 197, 197),
		["Velvet Rose"] = Color3.fromRGB(68, 68, 68),
		["Crimson Night"] = Color3.fromRGB(21, 21, 21),
	}
	local state =
		{ enabled = _G.MinecraftBatSkinEnabled == true, colorMode = "Default", cachedVisualPart = nil, rgbConnection = nil }
	local function findBat()
		local c = LP.Character
		local b = c and c:FindFirstChild("Bat")
		if b and b:IsA("Tool") then
			return b
		end
		local bp = LP:FindFirstChildOfClass("Backpack")
		b = bp and bp:FindFirstChild("Bat")
		if b and b:IsA("Tool") then
			return b
		end
	end
	local function setColor(p, color)
		if not p or not color then
			return
		end
		pcall(function()
			p.Color = color
		end)
		if p:IsA("UnionOperation") then
			pcall(function()
				p.UsePartColor = true
			end)
		end
		local m = p:FindFirstChildWhichIsA("SpecialMesh")
		if m then
			pcall(function()
				m.VertexColor = Vector3.new(color.R, color.G, color.B)
			end)
		end
	end
	local function loadAsset()
		if state.cachedVisualPart then
			return
		end
		local ok, r = pcall(function()
			return game:GetObjects("rbxassetid://18566246244")
		end)
		if ok and r and #r > 0 then
			local root = r[1]
			state.cachedVisualPart = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart", true)
		end
		if not state.cachedVisualPart then
			pcall(function()
				local m = game:GetService("InsertService"):LoadAsset(18566246244)
				state.cachedVisualPart = m and m:FindFirstChildWhichIsA("BasePart", true)
			end)
		end
	end
	local function restore(b)
		if not b then
			return
		end
		local v = b:FindFirstChild("CustomUnionVisual")
		if v then
			pcall(function()
				v:Destroy()
			end)
		end
		local h = b:FindFirstChild("Handle")
		if h then
			h.Transparency = 0
			for _, c in ipairs(h:GetChildren()) do
				if c:IsA("SpecialMesh") or c:IsA("Mesh") or c:IsA("Decal") then
					pcall(function()
						c.Transparency = 0
					end)
				end
			end
		end
	end
	local function apply(b)
		if not b then
			return
		end
		loadAsset()
		if not state.cachedVisualPart then
			return
		end
		local h = b:FindFirstChild("Handle")
		if not h then
			return
		end
		local old = b:FindFirstChild("CustomUnionVisual")
		if old then
			old:Destroy()
		end
		h.Transparency = 1
		for _, c in ipairs(h:GetChildren()) do
			if c:IsA("SpecialMesh") or c:IsA("Mesh") or c:IsA("Decal") then
				pcall(function()
					c.Transparency = 1
				end)
			end
		end
		local v = state.cachedVisualPart:Clone()
		v.Name = "CustomUnionVisual"
		v.CanCollide = false
		v.CanTouch = false
		v.CanQuery = false
		v.Massless = true
		v.Anchored = false
		local m = Instance.new("Model")
		v.Parent = m
		m.PrimaryPart = v
		pcall(function()
			m:ScaleTo(2)
		end)
		v.Parent = nil
		m:Destroy()
		if state.colorMode == "RGB" then
			setColor(v, Color3.fromHSV((os.clock() % 3) / 3, 1, 1))
		elseif colors[state.colorMode] then
			setColor(v, colors[state.colorMode])
		end
		for _, c in ipairs(v:GetChildren()) do
			if c:IsA("Weld") or c:IsA("WeldConstraint") then
				c:Destroy()
			end
		end
		v.CFrame = h.CFrame * CFrame.new(-0.18, -0.52, -0.2) * CFrame.Angles(0.7853981633974483, 0, 0.08726646259971647)
		v.Parent = b
		local w = Instance.new("WeldConstraint")
		w.Part0 = h
		w.Part1 = v
		w.Parent = v
	end
	local function stopRGB()
		if state.rgbConnection then
			state.rgbConnection:Disconnect()
			state.rgbConnection = nil
		end
	end
	local function startRGB()
		if state.rgbConnection then
			return
		end
		state.rgbConnection = RunService.RenderStepped:Connect(function()
			if state.enabled and state.colorMode == "RGB" then
				local b = findBat()
				local v = b and b:FindFirstChild("CustomUnionVisual")
				if v then
					setColor(v, Color3.fromHSV((os.clock() % 3) / 3, 1, 1))
				end
			end
		end)
	end
	local controller = { State = state, Colors = colors, FindBat = findBat }
	function controller.Apply()
		if not state.enabled then
			return
		end
		local b = findBat()
		if b then
			apply(b)
		end
		if state.colorMode == "RGB" then
			startRGB()
		end
	end
	function controller.Remove()
		stopRGB()
		local c = LP.Character
		local bp = LP:FindFirstChildOfClass("Backpack")
		if c then
			restore(c:FindFirstChild("Bat"))
		end
		if bp then
			restore(bp:FindFirstChild("Bat"))
		end
	end
	function controller.SetColorMode(mode)
		state.colorMode = mode
		if not state.enabled then
			return
		end
		if mode == "RGB" then
			startRGB()
		else
			stopRGB()
		end
		controller.Apply()
	end
	_G.MinecraftBatSkin = controller
	if _G.MinecraftBatSkinRespawnConn then
		pcall(function()
			_G.MinecraftBatSkinRespawnConn:Disconnect()
		end)
	end
	_G.MinecraftBatSkinRespawnConn = LP.CharacterAdded:Connect(function()
		if _G.MinecraftBatSkinEnabled then
			task.wait(0.6)
			pcall(controller.Apply)
		end
	end)
	task.spawn(function()
		task.wait(1)
		while true do
			if _G.MinecraftBatSkinEnabled then
				state.enabled = true
				local b = findBat()
				if b and not b:FindFirstChild("CustomUnionVisual") then
					pcall(controller.Apply)
				end
			elseif state.enabled then
				state.enabled = false
				pcall(controller.Remove)
			end
			task.wait(0.5)
		end
	end)
	if _G.MinecraftBatSkinEnabled then
		task.defer(controller.Apply)
	end
end)

-- ============================================================
-- Rival / shel.Vs: BAT SWORD VISUAL (rainbow katana on bat)
-- ============================================================
do
	local KATANA_MESH = "rbxassetid://13528902482"
	local function isBatTool(tool)
		if not tool or not tool:IsA("Tool") then
			return false
		end
		local name = tool.Name:lower()
		return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
	end
	local function applySwordVisual(tool)
		if not isBatTool(tool) then
			return
		end
		local handle = tool:FindFirstChild("Handle")
		if not handle then
			return
		end
		local oldReplica = handle:FindFirstChild("AmpSwordReplica")
		if oldReplica then
			oldReplica:Destroy()
		end
		local model = Instance.new("Model")
		model.Name = "AmpSwordReplica"
		local part = Instance.new("Part")
		part.Name = "SwordPart"
		part.Size = Vector3.new(1, 1, 1)
		part.Transparency = 0
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.Massless = true
		part.Anchored = false
		part.Parent = model
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.FileMesh
		mesh.MeshId = KATANA_MESH
		mesh.TextureId = ""
		mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
		mesh.Parent = part
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromHSV(0, 1, 1)
		part.Reflectance = 0.1
		mesh.VertexColor = Vector3.new(1, 1, 1)
		local glow = Instance.new("PointLight")
		glow.Name = "AmpSwordGlow"
		glow.Brightness = 3
		glow.Range = 12
		glow.Color = part.Color
		glow.Parent = part
		_G.AmpSwordRainbowParts = _G.AmpSwordRainbowParts or {}
		table.insert(_G.AmpSwordRainbowParts, { part = part, mesh = mesh, light = glow })
		model.PrimaryPart = part
		model.Parent = handle
		part.CFrame = handle.CFrame
			* (CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)))
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = handle
		weld.Part1 = part
		weld.Parent = part
		pcall(function()
			handle.Transparency = 1
		end)
	end
	local function watchContainer(container)
		if not container then
			return
		end
		for _, child in ipairs(container:GetChildren()) do
			if isBatTool(child) then
				task.defer(applySwordVisual, child)
			end
		end
		if not container:GetAttribute("AmpSwordVisualWatch") then
			container:SetAttribute("AmpSwordVisualWatch", true)
			container.ChildAdded:Connect(function(child)
				if not isBatTool(child) then
					return
				end
				task.wait()
				applySwordVisual(child)
			end)
		end
	end
	local function scanSwordTools()
		watchContainer(LP:FindFirstChildOfClass("Backpack"))
		watchContainer(LP.Character)
	end
	scanSwordTools()
	LP.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			watchContainer(child)
		end
	end)
	LP.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		watchContainer(character)
		scanSwordTools()
	end)
	task.spawn(function()
		while task.wait(1) do
			scanSwordTools()
		end
	end)
	if not _G.AmpSwordRainbowLoop then
		_G.AmpSwordRainbowLoop = true
		_G.AmpSwordRainbowSpeed = _G.AmpSwordRainbowSpeed or 0.35
		task.spawn(function()
			while task.wait(0.03) do
				local list = _G.AmpSwordRainbowParts
				if list then
					local hue = (tick() * (_G.AmpSwordRainbowSpeed or 0.35)) % 1
					local color = Color3.fromHSV(hue, 1, 1)
					for i = #list, 1, -1 do
						local entry = list[i]
						if entry and entry.part and entry.part.Parent then
							entry.part.Color = color
							if entry.mesh then
								entry.mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
							end
							if entry.light then
								entry.light.Color = color
							end
						else
							table.remove(list, i)
						end
					end
				end
			end
		end)
	end
	_G.AmpSwordVisual = { apply = scanSwordTools, mesh = KATANA_MESH, rainbow = true }
end

-- ============================================================
-- Rival / shel.Vs: BAT SWORD SOUND
-- ============================================================
do
	local SWORD_SOUND = "rbxassetid://5713085119"
	local hookedTools = setmetatable({}, { __mode = "k" })
	local customSounds = setmetatable({}, { __mode = "k" })
	local function isSwordTool(tool)
		if not tool or not tool:IsA("Tool") then
			return false
		end
		local name = tool.Name:lower()
		return name:find("bat", 1, true) ~= nil
			or name:find("slap", 1, true) ~= nil
			or name:find("sword", 1, true) ~= nil
			or name:find("knife", 1, true) ~= nil
	end
	local function makeCustomSound(parent)
		local old = customSounds[parent]
		if old and old.Parent then
			old.SoundId = SWORD_SOUND
			return old
		end
		local sound = Instance.new("Sound")
		sound.Name = "AmpCustomToolSound"
		sound.SoundId = SWORD_SOUND
		sound.Volume = 1
		sound.Looped = false
		sound.Parent = parent
		customSounds[parent] = sound
		return sound
	end
	local function playCustomSound(parent)
		if not parent or not parent.Parent then
			return
		end
		local sound = makeCustomSound(parent)
		pcall(function()
			sound:Stop()
			sound.TimePosition = 0.2
			sound.Volume = 1
			sound:Play()
		end)
	end
	local function hookTool(tool)
		if not isSwordTool(tool) or hookedTools[tool] then
			return
		end
		hookedTools[tool] = true
		local hookedSounds = setmetatable({}, { __mode = "k" })
		local function hookSound(sound)
			if not sound:IsA("Sound") or sound.Name == "AmpCustomToolSound" or hookedSounds[sound] then
				return
			end
			hookedSounds[sound] = true
			local triggering = false
			local function trigger()
				if triggering or not sound.Parent then
					return
				end
				if sound.Playing or sound.TimePosition > 0 then
					triggering = true
					pcall(function()
						sound.Volume = 0
						sound:Stop()
					end)
					playCustomSound(sound.Parent)
					triggering = false
				end
			end
			sound:GetPropertyChangedSignal("Playing"):Connect(trigger)
			sound:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
		end
		for _, descendant in ipairs(tool:GetDescendants()) do
			hookSound(descendant)
		end
		tool.DescendantAdded:Connect(hookSound)
	end
	local function watchContainer(container)
		if not container then
			return
		end
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") then
				task.defer(hookTool, child)
			end
		end
		if not container:GetAttribute("AmpToolSoundWatch") then
			container:SetAttribute("AmpToolSoundWatch", true)
			container.ChildAdded:Connect(function(child)
				if not child:IsA("Tool") then
					return
				end
				task.wait()
				hookTool(child)
			end)
		end
	end
	local function scanSoundTools()
		watchContainer(LP:FindFirstChildOfClass("Backpack"))
		watchContainer(LP.Character)
	end
	scanSoundTools()
	LP.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			watchContainer(child)
		end
	end)
	LP.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		watchContainer(character)
		scanSoundTools()
	end)
	task.spawn(function()
		while task.wait(1) do
			scanSoundTools()
		end
	end)
	_G.AmpSwordSound = { apply = scanSoundTools, SwordSound = SWORD_SOUND }
end

-- ============================================================
-- Rival / shel.Vs: MEDUSA BOMB SKIN + BOMB SOUND
-- ============================================================
do
	local BOMB_SOUND = "rbxassetid://138186576"
	local bombHooked = setmetatable({}, { __mode = "k" })
	local function isBombTool(obj)
		if not obj or not obj:IsA("Tool") then
			return false
		end
		local n = obj.Name:lower()
		return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil or n:find("stone", 1, true) ~= nil
	end
	local function hookBombTool(tool)
		if not isBombTool(tool) or bombHooked[tool] then
			return
		end
		bombHooked[tool] = true
		local function muteOriginal(obj)
			if not obj:IsA("Sound") or obj.Name == "AmpBombSound" then
				return
			end
			pcall(function()
				obj.Volume = 0
				obj:Stop()
			end)
			obj:GetPropertyChangedSignal("Volume"):Connect(function()
				if obj.Parent and obj.Volume ~= 0 then
					obj.Volume = 0
				end
			end)
		end
		for _, obj in ipairs(tool:GetDescendants()) do
			muteOriginal(obj)
		end
		tool.DescendantAdded:Connect(muteOriginal)
		local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
		local bombSound = Instance.new("Sound")
		bombSound.Name = "AmpBombSound"
		bombSound.SoundId = BOMB_SOUND
		bombSound.Volume = 1.0
		bombSound.PlaybackSpeed = 0.95
		bombSound.Looped = false
		bombSound.Parent = handle or tool
		tool.Activated:Connect(function()
			pcall(function()
				if bombSound.IsPlaying then
					bombSound:Stop()
				end
				bombSound.TimePosition = 0
				bombSound:Play()
			end)
		end)
	end
	local function applyMedusaSkin(tool)
		if not isBombTool(tool) then
			return
		end
		if tool:GetAttribute("AmpMedusaBombSkin") then
			return
		end
		local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
		if not handle or not handle:IsA("BasePart") then
			return
		end
		tool:SetAttribute("AmpMedusaBombSkin", true)
		for _, obj in ipairs(tool:GetDescendants()) do
			if obj:IsA("BasePart") then
				obj.LocalTransparencyModifier = 1
			elseif obj:IsA("Sound") and obj.Name ~= "AmpBombSound" then
				obj.Volume = 0
				obj:Stop()
			end
		end
		local bomb = Instance.new("Folder")
		bomb.Name = "AmpMedusaBombSkin"
		bomb.Parent = tool
		local function block(name, size, color, offset, shape, material)
			local part = Instance.new("Part")
			part.Name = name
			part.Size = size
			part.Shape = shape or Enum.PartType.Block
			part.Color = color
			part.Material = material or Enum.Material.SmoothPlastic
			part.CFrame = handle.CFrame * offset
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.CastShadow = false
			part.Massless = true
			part.Anchored = false
			part.Parent = bomb
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = handle
			weld.Part1 = part
			weld.Parent = part
			return part
		end
		local black = Color3.fromRGB(12, 12, 15)
		local darkRed = Color3.fromRGB(95, 8, 12)
		local red = Color3.fromRGB(225, 25, 32)
		local fuse = Color3.fromRGB(255, 150, 35)
		block("BombBody", Vector3.new(1.25, 1.25, 1.25), black, CFrame.new(0, 0, 0), Enum.PartType.Ball)
		block("BombBand", Vector3.new(1.32, 0.18, 1.32), darkRed, CFrame.new(0, 0.02, 0))
		block(
			"BombCore",
			Vector3.new(0.72, 0.72, 0.72),
			red,
			CFrame.new(0, 0, -0.57),
			Enum.PartType.Ball,
			Enum.Material.Neon
		)
		block("BombCap", Vector3.new(0.42, 0.22, 0.42), darkRed, CFrame.new(0, 0.73, 0))
		block(
			"BombFuse",
			Vector3.new(0.14, 0.48, 0.14),
			fuse,
			CFrame.new(0, 1.03, 0),
			Enum.PartType.Cylinder,
			Enum.Material.Neon
		)
		block(
			"BombSpark",
			Vector3.new(0.24, 0.24, 0.24),
			Color3.fromRGB(255, 235, 100),
			CFrame.new(0, 1.34, 0),
			Enum.PartType.Ball,
			Enum.Material.Neon
		)
		tool.DescendantAdded:Connect(function(obj)
			if obj:IsDescendantOf(bomb) then
				return
			end
			if obj:IsA("BasePart") then
				obj.LocalTransparencyModifier = 1
			end
		end)
	end
	local function watchContainer(container)
		if not container then
			return
		end
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") then
				task.defer(hookBombTool, child)
				task.defer(applyMedusaSkin, child)
			end
		end
		if not container:GetAttribute("AmpMedusaWatch") then
			container:SetAttribute("AmpMedusaWatch", true)
			container.ChildAdded:Connect(function(child)
				if not child:IsA("Tool") then
					return
				end
				task.wait()
				hookBombTool(child)
				applyMedusaSkin(child)
			end)
		end
	end
	local function scan()
		watchContainer(LP:FindFirstChildOfClass("Backpack"))
		watchContainer(LP.Character)
	end
	scan()
	LP.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			watchContainer(child)
		end
	end)
	LP.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		watchContainer(character)
		scan()
	end)
	task.spawn(function()
		while task.wait(1) do
			scan()
		end
	end)
	_G.AmpMedusaSkin = { apply = scan }
	_G.AmpBombSound = { apply = scan, BombSound = BOMB_SOUND }
end

pcall(function()
	print("[AMP Duels] READY — script executed successfully")
end)