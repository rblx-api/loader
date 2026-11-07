local cframe = CFrame.new(0, -4, 0)
local vector, vector2, tbl, Players, localPlayer, v, bjkHubGen, fn, mainConfig, tbl2, tbl3
vector = Vector3.new(40, 1, 40)
vector2 = Vector3.new(0, 3.35, 0)
tbl = {}
Players = game:GetService("Players")
localPlayer = Players.LocalPlayer
v = nil
local humanoidRootPart = nil
local humanoid = nil

_G.BJK_IsA = function(arg, arg2)
	local className = arg.ClassName
	local tbl4 = tbl[arg2]

	if not tbl4 then
		tbl4 = {}
		tbl[arg2] = tbl4
	end

	local isA = tbl4[className]

	if isA == nil then
		isA = arg:IsA(arg2)
		tbl4[className] = isA
	end

	return isA
end

_G.BJK_GetHRP = function()
	local localPlayer2 = localPlayer

	if not localPlayer2 then
		localPlayer2 = Players.LocalPlayer
		localPlayer = localPlayer2
	end

	local character = localPlayer2 and localPlayer2.Character

	if character ~= v then
		v = character

		if character then
			humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			humanoid = character:FindFirstChildOfClass("Humanoid")
		else
			humanoidRootPart = nil
			humanoid = nil
		end
	else
		if humanoidRootPart and humanoidRootPart.Parent ~= character then
			if character then
				humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				humanoid = character:FindFirstChildOfClass("Humanoid")
			else
				humanoidRootPart = nil
				humanoid = nil
			end
		end
	end

	return humanoidRootPart
end

_G.BJK_GetHum = function()
	_G.BJK_GetHRP()
	return humanoid
end

local tbl4 = {
	writefile = 1,
	readfile = 1,
	appendfile = 1,
	isfile = 1,
	delfile = 1,
	listfiles = 1,
	makefolder = 1,
	isfolder = 1,
	delfolder = 1,
	loadstring = 1,
	hookfunction = 1,
	hookmetamethod = 1,
	newcclosure = 1,
	getgenv = 1,
	getrenv = 1,
	getreg = 1,
	getgc = 1,
	getrawmetatable = 1,
	setrawmetatable = 1,
	setreadonly = 1,
	getconnections = 1,
	firesignal = 1,
	gethui = 1,
	get_hidden_gui = 1,
	getcustomasset = 1,
	setclipboard = 1,
	queue_on_teleport = 1,
	getscriptclosure = 1,
	getscriptbytecode = 1,
	decompile = 1,
	identifyexecutor = 1,
	getexecutorname = 1,
	request = 1,
	http_request = 1,
	syn = 1,
	protect_gui = 1,
	checkcaller = 1,
	islclosure = 1,
	iscclosure = 1,
	clonefunction = 1,
	getcallingscript = 1,
	getnilinstances = 1,
	setthreadidentity = 1,
	getthreadidentity = 1,
	set_thread_identity = 1,
	get_thread_identity = 1,
}

local env = getfenv(0)

local obj = setmetatable({}, {
	__index = function(arg, arg2)
	if tbl4[arg2] then
		return nil
	end
	return env[arg2]
end,
	__newindex = function(arg, arg2, arg3)
	env[arg2] = arg3
end,
})

_G.BJK_SafeCall = function(arg, ...)
	if type(setfenv) ~= "function" then
		return pcall(arg, ...)
	end
	local v2 = table.pack(...)
	local fn2, thread, v3, v4

	fn2 = function()
		setfenv(0, obj)
		return table.pack(pcall(arg, table.unpack(v2, 1, v2.n)))
	end

	setfenv(fn2, obj)
	thread = coroutine.create(fn2)
	v3, v4 = coroutine.resume(thread)
	if not v3 then
		return false, v4
	end

	if type(v4) ~= "table" then
		return false, v4
	end
	return table.unpack(v4, 1, v4.n)
end

_G._tpFiring = nil

do
	local tpOnLoad = _G.MainConfig and _G.MainConfig.TpSettings and _G.MainConfig.TpSettings.TpOnLoad

	if tpOnLoad and not _G._bjkGuardActive then
		_G._bjkGuardActive = true
		local localPlayer2 = game:GetService("Players").LocalPlayer
		local RunService_ = game:GetService("RunService")
		local Workspace_ = game:GetService("Workspace")
		local part = nil
		local bjkAnchorCleanup

		bjkAnchorCleanup = function()
			pcall(function()
				local character = localPlayer2 and localPlayer2.Character
				local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 then
					humanoidRootPart2.Anchored = false
				end
			end)

			pcall(function()
				if part then
					part:Destroy()
				end
			end)

			part = nil
		end

		_G._bjkAnchorCleanup = bjkAnchorCleanup

		task.spawn(function()
			while not _G._tpFiring do
				if not _G.TpOnLoadRunning and _G.BJK_Ready then
					break
				end
				local character = localPlayer2 and localPlayer2.Character
				local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 and humanoidRootPart2.Parent then
					pcall(function()
						humanoidRootPart2.Anchored = true
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero

						if not part or not part.Parent then
							part = Instance.new("Part")
							part.Name = "BJKAnchorFloor"
							part.Size = Vector3.new(40, 1, 40)
							part.Transparency = 1
							part.CanCollide = true
							part.Anchored = true

							pcall(function()
								part.CanQuery = false
							end)

							part.Parent = Workspace_
						end

						part.CFrame = humanoidRootPart2.CFrame * CFrame.new(0, -4, 0)
					end)
				end

				RunService_.Heartbeat:Wait()
			end

			bjkAnchorCleanup()
			_G._bjkGuardActive = nil
		end)
	end
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

_G.TpOnLoadRunning = false

if _G.MainConfig and _G.MainConfig.TpSettings and _G.MainConfig.TpSettings.TpOnLoad then
	_G.TpOnLoadRunning = true
end

local Players2 = game:GetService("Players")
local localPlayer2 = Players2.LocalPlayer
_G.BJK_Ready = false
_G.BJK_HubGen = (_G.BJK_HubGen or 0) + 1
bjkHubGen = _G.BJK_HubGen

task.spawn(function()
	task.wait(0.5)

	pcall(function()
		for i, descendant in ipairs(game:GetDescendants()) do
			local name = descendant.Name

			if descendant:IsA("BillboardGui") and (name:find("PlayerESP_", 1, true) or name:find("BrainrotESP_", 1, true) or name == "TimerESP") then
				pcall(function()
					descendant:Destroy()
				end)
			elseif descendant:IsA("Highlight") and name == "PlayerESP_Highlight" then
				pcall(function()
					descendant:Destroy()
				end)
			end
		end
	end)
end)

Players2.PlayerAdded:Connect(function(player_)
	if _G.BJK_HubGen ~= bjkHubGen then
		return
	end

	player_.CharacterAdded:Connect(function()
		if _G.BJK_HubGen ~= bjkHubGen then
			return
		end

		task.spawn(function()
			if createOrRefreshPlayerESP then
				pcall(createOrRefreshPlayerESP, player_)
			end

			if refreshBrainrotESP then
				pcall(refreshBrainrotESP)
			end
		end)
	end)

	if player_.Character then
		task.spawn(function()
			if createOrRefreshPlayerESP then
				pcall(createOrRefreshPlayerESP, player_)
			end

			if refreshBrainrotESP then
				pcall(refreshBrainrotESP)
			end
		end)
	end
end)

UIS = game:GetService("UserInputService")
_G.BJK_IS_MOBILE = UIS.TouchEnabled or UIS.KeyboardEnabled == false
RunService = game:GetService("RunService")
Stats = game:GetService("Stats")
TweenService = game:GetService("TweenService")
HttpService = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
Lighting = game:GetService("Lighting")
TeleportService = game:GetService("TeleportService")
CoreGui = game:GetService("CoreGui")

task.spawn(function()
	_G.PlotsFolder = Workspace:WaitForChild("Plots", 3)
end)

_G.performSwapBack = _G.performSwapBack or function()
	return false
end

if not _G.tpToPosition then
	_G.tpToPosition = function(arg)
		if typeof(arg) ~= "Vector3" then
			return false
		end
		local character = localPlayer2.Character
		local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return false
		end
		local cframe2 = CFrame.new(arg + Vector3.new(0, 3, 0))

		pcall(function()
			humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end)

		pcall(function()
			humanoidRootPart2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end)

		local ok = pcall(function()
			humanoidRootPart2.CFrame = cframe2
		end)

		if ok then
			task.wait(0.05)

			pcall(function()
				humanoidRootPart2.CFrame = cframe2
			end)

			pcall(function()
				humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end)
		end

		return ok
	end
end

do
	local bjkDebug = { checkpoints = {}, freezes = {}, slow = {} }

	function bjkDebug.log(arg, arg2)
		table.insert(arg.checkpoints, { t = os.clock(), tag = arg2 })

		if #arg.checkpoints > 60 then
			table.remove(arg.checkpoints, 1)
		end
	end

	local now

	bjkDebug.timed = function(arg, arg2, arg3, arg4)
		local now2 = os.clock()
		local ok, result = pcall(arg3)
		local n = os.clock() - now2

		if n >= (arg4 or 60) / 1000 then
			table.insert(arg.slow, { t = os.clock(), tag = arg2, ms = math.floor(n * 1000) })

			if #arg.slow > 30 then
				table.remove(arg.slow, 1)
			end
		end

		arg:log(arg2)
		if ok then
			return result
		end
		return nil
	end

	bjkDebug.freeze = function(arg, arg2)
		local v2 = arg.checkpoints[#arg.checkpoints]
		table.insert(arg.freezes, { t = os.clock(), ms = math.floor(arg2 * 1000), last = v2 and v2.tag })

		if #arg.freezes > 25 then
			table.remove(arg.freezes, 1)
		end
	end

	_G.__BJKDebug = bjkDebug

	_G.__BJKDumpDebug = function()
		for i = #bjkDebug.checkpoints, math.max(1, #bjkDebug.checkpoints - 30), -1 do
			local v2 = bjkDebug.checkpoints[i]
		end

		for i, freeze in ipairs(bjkDebug.freezes) do
		end

		for i, v2 in ipairs(bjkDebug.slow) do
		end
	end

	now = os.clock()

	RunService.Heartbeat:Connect(function()
		local now2 = os.clock()
		local n = now2 - now
		now = now2

		if n > 0.3 then
			bjkDebug:freeze(n)
		end
	end)
end

local tbl5 = { TradePlazaPortal = true, CrystalSpinWheel = true }

local function fn2(arg)
	if not arg then
		return
	end

	for i, descendant in ipairs(arg:GetDescendants()) do
		local className = descendant.ClassName

		if className == "ProximityPrompt" or className == "ClickDetector" or className == "BillboardGui" or className == "SurfaceGui" or className == "TextButton" or className == "ImageButton" then
			pcall(function()
				descendant:Destroy()
			end)
		elseif className == "Part" or className == "MeshPart" or className == "UnionOperation" then
			descendant.CanCollide = true
			descendant.CanQuery = true
			descendant.CanTouch = true
		end
	end
end

for k, v2 in pairs(tbl5) do
	local v3 = Workspace:FindFirstChild(k)

	if v3 then
		fn2(v3)
	end
end

Workspace.ChildAdded:Connect(function(child)
	if tbl5[child.Name] then
		task.wait(0.1)
		fn2(child)
	end
end)

fn = function()
	if type(_G.SAB_LIVE) == "function" then
		local ok, result = pcall(_G.SAB_LIVE)
		if ok then
			return result ~= false
		end
	end

	return true
end

task.spawn(function()
	local str = tostring(localPlayer2.UserId) .. "_Clone"

	local function fn3(arg)
		if not arg:IsA("Model") then
			return false
		end
		local name = arg.Name
		if type(name) ~= "string" or not string.find(name, "_Clone", 1, true) then
			return false
		end
		return name ~= str
	end

	local function fn4(arg)
		if not arg or not arg.Parent then
			return
		end

		for i, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.CanCollide then
				pcall(function()
					descendant.CanCollide = false
				end)
			end
		end
	end

	while true do
		for i, player_ in ipairs(Players2:GetPlayers()) do
			if player_ ~= localPlayer2 and player_.Character then
				fn4(player_.Character)
				RunService.Heartbeat:Wait()
			end
		end

		for i, child in ipairs(Workspace:GetChildren()) do
			if fn3(child) then
				fn4(child)
				RunService.Heartbeat:Wait()
			end
		end

		task.wait(_G.BJK_NoclipInterval or 0.4)
	end
end)

if _G.BJK_NoclipMachines == nil then
	_G.BJK_NoclipMachines = true
end

task.spawn(function()
	local bjkNoclipKW = _G.BJK_NoclipKW or { "truck", "fuse", "craft", "incubator", "cupid", "soccerball" }

	local bjkNoclipAvoidKW = _G.BJK_NoclipAvoidKW or {
		"trade",
		"portal",
		"wheel",
		"cyber",
		"spin",
		"roulette",
		"summer",
		"admin",
		"plot",
		"shop",
		"board",
		"sentry",
		"laser",
		"base",
	}

	local bjkNoclipForceKW, tbl6, n, fn3, tbl7, n2, fn4, tbl8, flag
	bjkNoclipForceKW = _G.BJK_NoclipForceKW or { "summer base", "summerfuse" }
	tbl6, n = {}, 0

	fn3 = function(arg)
		local str = arg or ""
		local v2 = tbl6[str]

		if v2 ~= nil then
			if v2 == false then
				return nil
			end
			return v2
		end

		local str2 = str:lower()
		local str3 = nil

		for i, v3 in ipairs(bjkNoclipForceKW) do
			if str2:find(v3, 1, true) then
				str3 = "noclip"
				break
			end
		end

		if str3 == nil then
			for i, v3 in ipairs(bjkNoclipAvoidKW) do
				if str2:find(v3, 1, true) then
					str3 = "avoid"
					break
				end
			end
		end

		if str3 == nil then
			for i, v3 in ipairs(bjkNoclipKW) do
				if str2:find(v3, 1, true) then
					str3 = "noclip"
					break
				end
			end
		end

		if n >= (_G.BJK_ClsMemoMax or 8000) then
			tbl6, n = {}, 0
		end

		tbl6[str] = str3 == nil and false or str3
		n = n + 1
		return str3
	end

	tbl7, n2 = {}, 0

	fn4 = function(arg)
		local tbl9, parent = {}, arg

		while parent and parent ~= Workspace do
			table.insert(tbl9, 1, parent)
			parent = parent.Parent
		end

		if not parent then
			return nil
		end

		for i, v2 in ipairs(tbl9) do
			if v2:FindFirstChildOfClass("Humanoid") then
				return nil
			end
			local v3 = fn3(v2.Name)
			if v3 then
				return v3
			end
		end

		return nil
	end

	tbl8, flag = {}, false

	local function fn5()
		local v2, n3
		flag = false
		v2 = tbl8
		tbl8 = {}
		n3 = 0

		for k in pairs(v2) do
			if _G.BJK_NoclipMachines and fn() and k.Parent and k.Anchored and fn4(k) == "noclip" then
				pcall(function()
					k.CanCollide = false
					k.CanQuery = false
				end)
			end

			n3 = n3 + 1

			if n3 % (_G.BJK_NoclipDrainBatch or 150) == 0 then
				RunService.Heartbeat:Wait()
			end
		end
	end

	Workspace.DescendantAdded:Connect(function(descendant)
		if not descendant:IsA("BasePart") then
			return
		end
		tbl8[descendant] = true

		if not flag then
			flag = true
			task.delay(0.15, fn5)
		end
	end)

	local function fn6()
		local tbl9 = {}
		local n3 = 0

		local function fn7(arg, arg2)
			for i, child in ipairs(arg:GetChildren()) do
				if child:IsA("Model") or child:IsA("Folder") or child:IsA("BasePart") then
					if child:FindFirstChildOfClass("Humanoid") then
					else
						local v2 = fn3(child.Name)

						if v2 == "avoid" then
						elseif v2 == "noclip" then
							tbl9[#tbl9 + 1] = child
						elseif arg2 < (_G.BJK_NoclipDepth or 5) then
							fn7(child, arg2 + 1)
						end
					end
				end

				n3 = n3 + 1

				if n3 % (_G.BJK_NoclipWalkBatch or 200) == 0 then
					RunService.Heartbeat:Wait()
				end
			end
		end

		pcall(fn7, Workspace, 0)
		tbl7 = tbl9
	end

	local now = tick()

	while true do
		if _G.BJK_NoclipMachines and fn() then
			local bjkNoclipDiscoverEvery = tick() - now < 12 and 1 or (_G.BJK_NoclipDiscoverEvery or 3)

			if tick() - n2 > bjkNoclipDiscoverEvery then
				n2 = tick()
				fn6()
			end

			for i, v2 in ipairs(tbl7) do
				if v2.Parent then
					if v2:IsA("BasePart") then
						if v2.CanCollide then
							pcall(function()
								v2.CanCollide = false
							end)
						end

						if v2.CanQuery then
							pcall(function()
								v2.CanQuery = false
							end)
						end
					else
						for i2, descendant in ipairs(v2:GetDescendants()) do
							if descendant:IsA("BasePart") then
								if descendant.CanCollide then
									pcall(function()
										descendant.CanCollide = false
									end)
								end

								if descendant.CanQuery then
									pcall(function()
										descendant.CanQuery = false
									end)
								end
							end
						end
					end
				end
			end
		end

		task.wait(_G.BJK_NoclipApplyEvery or 0.3)
	end
end)

_chargeSoundPart = nil

function ensureCraftingMachineParts()
	local craftingMachine = Workspace:FindFirstChild("CraftingMachine")
	if not craftingMachine then
		return false
	end
	local chargeSoundPart = craftingMachine:FindFirstChild("ChargeSoundPart")

	if not chargeSoundPart then
		chargeSoundPart = _chargeSoundPart

		if not chargeSoundPart or chargeSoundPart.Parent ~= craftingMachine then
			local tbl6 = {}
			chargeSoundPart = Instance.new("Part")
			chargeSoundPart.Name = "ChargeSoundPart"
			chargeSoundPart.Anchored = true
			chargeSoundPart.CanCollide = false
			chargeSoundPart.CanQuery = false
			chargeSoundPart.CanTouch = false
			chargeSoundPart.Transparency = 1
			chargeSoundPart.Size = Vector3.new(0.2, 0.2, 0.2)
			chargeSoundPart.Archivable = false

			pcall(function()
				chargeSoundPart.CFrame = craftingMachine:GetPivot()
			end)

			_chargeSoundPart = chargeSoundPart
		end

		chargeSoundPart.Parent = craftingMachine
	end

	return true
end

ensureCraftingMachineParts()

Workspace.ChildAdded:Connect(function(child)
	if child.Name == "CraftingMachine" then
		task.defer(ensureCraftingMachineParts)
	end
end)

task.spawn(function()
	for i = 1, 30 do
		if ensureCraftingMachineParts() then
			break
		end
		task.wait(0.25)
	end
end)

task.spawn(function()
	pcall(function()
		local controllers = ReplicatedStorage:WaitForChild("Controllers", 5)
		local craftingMachineController = controllers:WaitForChild("CraftingMachineController", 5)
		local ok, result = pcall(require, craftingMachineController)

		if ok and type(result) == "table" then
			for k, v2 in pairs(result) do
				if type(v2) == "function" and (k == "updateVFX" or tostring(k):lower():find("vfx")) then
					local v3 = v2

					result[k] = function(...)
						ensureCraftingMachineParts()
						return pcall(v3, ...)
					end
				end
			end
		end
	end)
end)

_phantomMainPart = nil

ensurePhantomSpinWheelMain = function()
	local phantomSpinWheel = Workspace:FindFirstChild("PhantomSpinWheel")
	if not phantomSpinWheel then
		return false
	end

	if phantomSpinWheel:FindFirstChild("Main") then
		return true
	end
	local part = _phantomMainPart

	if not part or part.Parent ~= phantomSpinWheel then
		local tbl6 = {}
		part = Instance.new("Part")
		part.Name = "Main"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Transparency = 1
		part.Size = Vector3.new(0.2, 0.2, 0.2)
		part.Archivable = false

		pcall(function()
			part.CFrame = phantomSpinWheel:GetPivot()
		end)

		_phantomMainPart = part
	end

	part.Parent = phantomSpinWheel
	return true
end

ensurePhantomSpinWheelMain()

Workspace.ChildAdded:Connect(function(child)
	if child.Name == "PhantomSpinWheel" then
		task.defer(ensurePhantomSpinWheelMain)
	end
end)

task.spawn(function()
	for i = 1, 40 do
		if ensurePhantomSpinWheelMain() then
			break
		end
		task.wait(0.25)
	end
end)

do
	local position, v2, tbl6, fn3, fn4, fn5, fn6
	position, v2 = nil, nil
	tbl6 = {}

	fn3 = function()
		local character = localPlayer2.Character

		if character then
			local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
			if humanoidRootPart2 and humanoidRootPart2.Parent then
				return humanoidRootPart2
			end
		end

		if _G._invisOldRoot and _G._invisOldRoot.Parent then
			return _G._invisOldRoot
		end
		return nil
	end

	fn4 = function()
		local v3 = fn3()
		return v3 and v3.Position
	end

	fn5 = function(arg)
		arg = arg or 35
		local v3 = fn4()
		if not v3 then
			return nil
		end
		local v4, v5 = nil, arg

		for i, player_ in ipairs(Players2:GetPlayers()) do
			if player_ ~= localPlayer2 and player_.Character then
				local humanoidRootPart2 = player_.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 then
					local magnitude = (humanoidRootPart2.Position - v3).Magnitude

					if magnitude < v5 then
						v5, v4 = magnitude, player_
					end
				end
			end
		end

		return v4
	end

	fn6 = function(arg, arg2)
		arg2 = arg2 or 6

		for i, player_ in ipairs(Players2:GetPlayers()) do
			if player_ ~= localPlayer2 and player_.Character then
				local humanoidRootPart2 = player_.Character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart2 and (humanoidRootPart2.Position - arg).Magnitude <= arg2 then
					return player_
				end
			end
		end

		return nil
	end

	local n = 0

	RunService.Heartbeat:Connect(function()
		if _G.TpOnLoadRunning then
			position, v2 = nil, nil
			return
		end

		if not _G.antiSwapEnabled then
			position, v2 = nil, nil
			return
		end

		if not _G.BJK_Ready then
			return
		end
		n = n + 1
		if n % 8 ~= 0 then
			return
		end
		local v3 = fn5(35)
		local v4 = fn4()
		if not v4 then
			return
		end

		if not v3 then
			if v2 and (v4 - v2).Magnitude > 4 then
				local v5 = fn6(v2, 6)

				if v5 then
					local v6 = tbl6[v5.Name]

					if not (v6 and os.clock() - v6 < 8) then
						tbl6[v5.Name] = os.clock()
						local v7 = v5

						task.spawn(function()
							task.wait(0.15)
							local performSwapBack_ = _G.performSwapBack or performSwapBack

							if not performSwapBack_ then
								task.wait(1)
								performSwapBack_ = _G.performSwapBack or performSwapBack
							end

							if performSwapBack_ then
								pcall(performSwapBack_, v7)
							end
						end)
					end
				end
			end

			position, v2 = nil, v4
			return
		end

		local v5 = tbl6[v3.Name]
		if v5 and os.clock() - v5 < 8 then
			position, v2 = v3.Character and v3.Character:FindFirstChild("HumanoidRootPart") and v3.Character.HumanoidRootPart.Position or position, v4
			return
		end
		local humanoidRootPart2 = v3.Character and v3.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			position, v2 = nil, v4
			return
		end
		local position2 = humanoidRootPart2.Position

		if position and v2 then
			local magnitude = (position2 - position).Magnitude
			local flag = (position2 - v2).Magnitude < 6
			local flag2 = (v4 - v2).Magnitude > 2.5

			if magnitude > 2.5 and flag and flag2 then
				tbl6[v3.Name] = os.clock()
				local v6 = v2

				task.spawn(function()
					task.wait(0.15)

					if _G.invisibleStealEnabled and _G.toggleInvisibleSteal then
						pcall(_G.toggleInvisibleSteal)
						task.wait(0.08)
					end

					local performSwapBack_ = _G.performSwapBack or performSwapBack

					if not performSwapBack_ then
						task.wait(1)
						performSwapBack_ = _G.performSwapBack or performSwapBack
					end

					if performSwapBack_ then
						pcall(performSwapBack_, v3)
					end
				end)
			end
		end

		position, v2 = position2, v4
	end)
end

function makeOneWay(arg)
	if not arg then
		return
	end
	local connection_
	local v2 = nil

	connection_ = RunService.Stepped:Connect(function()
		if not arg or not arg.Parent then
			if connection_ then
				connection_:Disconnect()
			end

			return
		end

		local character = game.Players.LocalPlayer.Character
		local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart2 then
			local y = humanoidRootPart2.Position.Y

			if not v2 then
				v2 = y
			end

			local n = y - v2
			local flag = humanoidRootPart2.AssemblyLinearVelocity.Y > 1 or n > 0.01 and n < 5

			if flag then
				arg.CanCollide = false
			else
				if y > arg.Position.Y + 0.1 then
					arg.CanCollide = true
				else
					arg.CanCollide = false
				end
			end

			v2 = y
		end
	end)
end

if not LPH_NO_VIRTUALIZE then
	LPH_NO_VIRTUALIZE = function(arg)
		return arg
	end
end

_G.__BJKLazyQ = _G.__BJKLazyQ or {}

LazyInit = function(arg, arg2)
	table.insert(_G.__BJKLazyQ, { name = arg, fn = LPH_NO_VIRTUALIZE(arg2) })
end

task.defer(LPH_NO_VIRTUALIZE(function()
	while true do
		if _G.BJK_HubGen ~= bjkHubGen then
			break
		end

		if #_G.__BJKLazyQ > 0 then
			local n = _G.BJK_IS_MOBILE and 2 or 1

			for i = 1, n do
				local v2 = table.remove(_G.__BJKLazyQ, 1)
				if not v2 then
					break
				end
				local ok, result = pcall(v2.fn)
				task.wait()
			end

			task.wait(0.05)
		else
			task.wait(0.5)
		end
	end
end))

_G._BJKPanelVis = _G._BJKPanelVis or {}
_G.lazyUIs = {}

_G.addLazyUI = function(arg, arg2, arg3, arg4)
	if arg then
		if arg3 then
			arg.Enabled = false
		else
			arg.Visible = false
		end

		table.insert(_G.lazyUIs, {
			element = arg,
			targetVis = arg2,
			isScreenGui = arg3,
			cancelled = false,
			panelName = arg4,
		})
	end
end

_G.cancelLazyUI = function(arg)
	for i, lazyUI in ipairs(_G.lazyUIs) do
		if lazyUI.element == arg then
			lazyUI.cancelled = true
			break
		end
	end
end

task.delay(1.2, function()
	for i, lazyUI in ipairs(_G.lazyUIs) do
		if lazyUI.element and not lazyUI.cancelled then
			local enabled

			if lazyUI.panelName then
				local v2 = _G._BJKPanelVis[lazyUI.panelName]

				if v2 ~= nil then
					enabled = v2
				elseif Config and Config.Visibilities then
					local v3 = Config.Visibilities[lazyUI.panelName]

					if v3 ~= nil then
						enabled = v3
					else
						enabled = true
					end
				else
					enabled = lazyUI.targetVis
				end
			else
				enabled = lazyUI.targetVis
			end

			if lazyUI.isScreenGui then
				pcall(function()
					lazyUI.element.Enabled = enabled
				end)
			elseif lazyUI.element.Parent then
				pcall(function()
					lazyUI.element.Visible = enabled
				end)
			end
		end
	end
end)

player = Players2.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")

_G.BJKBuscaGui = function(arg)
	local hui = gethui and gethui() or game:GetService("CoreGui")
	local v2

	pcall(function()
		v2 = hui and hui:FindFirstChild(arg)
	end)

	if v2 then
		return v2
	end

	pcall(function()
		local playerGui_ = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
		v2 = playerGui_ and playerGui_:FindFirstChild(arg)
	end)

	return v2
end

pcall(function()
	Players2.RespawnTime = 0
end)

local vector3 = Vector3.new(-1458.1, 71.7, -84.4)

_G.bjkESPBlocked = function()
	if _G.bjkInstaResetting then
		return true
	end
	local character = player.Character and player.Character.FindFirstChild(player.Character, "HumanoidRootPart")
	if not character then
		return false
	end
	return (character.Position - vector3).Magnitude < 40
end

GlobalUIScaleVal = 1
scaledGuis = setmetatable({}, { __mode = "k" })

function getGlobalScale()
	return GlobalUIScaleVal
end

function updateAllGuisScale(scale)
	GlobalUIScaleVal = scale

	for k, v2 in pairs(scaledGuis) do
		pcall(function()
			if k and k.Parent and v2 and v2.Parent then
				local bjkGlobalScale = v2:FindFirstChild("BJK_GlobalScale")

				if bjkGlobalScale then
					bjkGlobalScale.Scale = scale
				end

				v2.Size = UDim2.new(1 / scale, 0, 1 / scale, 0)
			end
		end)
	end

	pcall(function()
		if _G.bjkRefreshAllCanvases then
			_G.bjkRefreshAllCanvases()
		end
	end)

	pcall(function()
		if _G.updateBottomStackLayout then
			_G.updateBottomStackLayout()
		end
	end)
end

_G.__BJKScrollBodies = _G.__BJKScrollBodies or {}

local function fn3()
	local n = 1

	pcall(function()
		local bjkGlobalScale = gui and gui:FindFirstChild("BJK_GlobalScale")
		n = bjkGlobalScale and bjkGlobalScale.Scale or 1
	end)

	if not n or n <= 0 then
		n = 1
	end

	return n
end

function _G.bjkBindCanvas(arg, arg2, arg3)
	_G.__BJKScrollBodies[arg] = { body = arg, lay = arg2, padY = arg3 or 16 }

	local function fn4()
		local absoluteContentSize = arg2.AbsoluteContentSize

		if absoluteContentSize then
			arg.CanvasSize = UDim2.new(0, 0, 0, (absoluteContentSize.Y + (arg3 or 16)) / fn3())
		end
	end

	arg2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn4)
	task.defer(fn4)
	return fn4
end

function _G.bjkRefreshAllCanvases()
	for k, bjkScrollBody in pairs(_G.__BJKScrollBodies) do
		pcall(function()
			local absoluteContentSize = bjkScrollBody.lay.AbsoluteContentSize

			if absoluteContentSize then
				bjkScrollBody.body.CanvasSize = UDim2.new(0, 0, 0, (absoluteContentSize.Y + bjkScrollBody.padY) / fn3())
			end
		end)
	end
end

function registerScreenGui(parent)
	local bjkMasterFrame = parent:FindFirstChild("BJK_MasterFrame")

	if not bjkMasterFrame then
		bjkMasterFrame = Instance.new("Frame")
		bjkMasterFrame.Name = "BJK_MasterFrame"
		bjkMasterFrame.BackgroundTransparency = 1
		bjkMasterFrame.BorderSizePixel = 0
		local uiScale
		bjkMasterFrame.Parent = parent
		uiScale = Instance.new("UIScale")
		uiScale.Name = "BJK_GlobalScale"
		uiScale.Parent = bjkMasterFrame
	end

	scaledGuis[parent] = bjkMasterFrame

	pcall(function()
		local bjkGlobalScale = bjkMasterFrame:FindFirstChild("BJK_GlobalScale")

		if bjkGlobalScale then
			bjkGlobalScale.Scale = GlobalUIScaleVal
		end

		bjkMasterFrame.Size = UDim2.new(1 / GlobalUIScaleVal, 0, 1 / GlobalUIScaleVal, 0)
	end)

	return bjkMasterFrame
end

function recalculateScale()
	if _G._recalcLast and os.clock() - _G._recalcLast < 0.2 then
		return
	end
	_G._recalcLast = os.clock()
	if not Workspace.CurrentCamera then
		return
	end
	local viewportSize = Workspace.CurrentCamera.ViewportSize
	local y = viewportSize.Y
	local n = 1

	if UIS.TouchEnabled then
		n = math.clamp(y / 1000, 0.4, 0.58)
	else
		n = math.clamp(y / 800, 0.65, 1)
	end

	updateAllGuisScale(n)
end

function setupCameraListener()
	if cameraConn then
		pcall(function()
			cameraConn:Disconnect()
		end)
	end

	if Workspace.CurrentCamera then
		cameraConn = Workspace.CurrentCamera.GetPropertyChangedSignal(Workspace.CurrentCamera, "ViewportSize"):Connect(recalculateScale)
		recalculateScale()
	end
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(setupCameraListener)
task.spawn(setupCameraListener)
local BJKHub_V3 = _G.BJKBuscaGui("BJKHub_V3")

if BJKHub_V3 then
	BJKHub_V3:Destroy()
end

gui_sg = Instance.new("ScreenGui")
gui_sg.Name = "BJKHub_V3"
gui_sg.ResetOnSpawn = false
gui_sg.IgnoreGuiInset = true
gui_sg.DisplayOrder = 9999999
gui_sg.Parent = gethui and gethui() or game:GetService("CoreGui")
gui = registerScreenGui(gui_sg)
ToggleState = {}

regToggle = function(arg, arg2)
	if not ToggleState[arg] then
		ToggleState[arg] = { value = arg2 or false, listeners = {} }
	end
end

getToggle = function(arg)
	return ToggleState[arg] and ToggleState[arg].value or false
end

setToggle = function(arg, value, arg2)
	regToggle(arg)
	ToggleState[arg].value = value

	if not arg2 then
		for i, listener in ipairs(ToggleState[arg].listeners) do
			pcall(listener, value)
		end
	end
end

onToggleChanged = function(arg, arg2)
	regToggle(arg)
	table.insert(ToggleState[arg].listeners, arg2)
end

Themes = {
	Light = {
	Background = Color3.fromRGB(28, 28, 30),
	MainBackground = Color3.fromRGB(22, 22, 24),
	SidebarBg = Color3.fromRGB(16, 16, 18),
	ContentBg = Color3.fromRGB(30, 30, 33),
	SidebarActive = Color3.fromRGB(55, 55, 60),
	SidebarActiveText = Color3.fromRGB(255, 255, 255),
	SidebarInactiveText = Color3.fromRGB(185, 185, 192),
	Panel = Color3.fromRGB(36, 36, 40),
	Row = Color3.fromRGB(44, 44, 48),
	RowHover = Color3.fromRGB(56, 56, 62),
	Accent = Color3.fromRGB(175, 175, 185),
	AccentLight = Color3.fromRGB(95, 95, 105),
	Green = Color3.fromRGB(175, 175, 185),
	Red = Color3.fromRGB(210, 80, 90),
	Red2 = Color3.fromRGB(185, 60, 72),
	Text = Color3.fromRGB(255, 255, 255),
	Dim = Color3.fromRGB(155, 155, 163),
	Stroke = Color3.fromRGB(0, 0, 0),
	SoftButton = Color3.fromRGB(52, 52, 58),
	SoftButtonHover = Color3.fromRGB(66, 66, 73),
	SoftAccent = Color3.fromRGB(44, 44, 50),
	SoftAccentHover = Color3.fromRGB(56, 56, 63),
	ToggleOn = Color3.fromRGB(195, 195, 205),
	ToggleOff = Color3.fromRGB(42, 42, 47),
	ToggleOff2 = Color3.fromRGB(42, 42, 47),
	ToggleKnobOn = Color3.fromRGB(22, 22, 24),
	ToggleKnobOff = Color3.fromRGB(105, 105, 113),
	InputBg = Color3.fromRGB(33, 33, 37),
	SliderBg = Color3.fromRGB(48, 48, 53),
	SliderFill = Color3.fromRGB(195, 195, 205),
	BlacklistHover = Color3.fromRGB(65, 38, 44),
	BlacklistLeave = Color3.fromRGB(40, 30, 34),
},
	Dark = {
	Background = Color3.fromRGB(28, 28, 30),
	MainBackground = Color3.fromRGB(22, 22, 24),
	SidebarBg = Color3.fromRGB(16, 16, 18),
	ContentBg = Color3.fromRGB(30, 30, 33),
	SidebarActive = Color3.fromRGB(55, 55, 60),
	SidebarActiveText = Color3.fromRGB(255, 255, 255),
	SidebarInactiveText = Color3.fromRGB(185, 185, 192),
	Panel = Color3.fromRGB(36, 36, 40),
	Row = Color3.fromRGB(44, 44, 48),
	RowHover = Color3.fromRGB(56, 56, 62),
	Accent = Color3.fromRGB(175, 175, 185),
	AccentLight = Color3.fromRGB(95, 95, 105),
	Green = Color3.fromRGB(175, 175, 185),
	Red = Color3.fromRGB(210, 80, 90),
	Red2 = Color3.fromRGB(185, 60, 72),
	Text = Color3.fromRGB(255, 255, 255),
	Dim = Color3.fromRGB(155, 155, 163),
	Stroke = Color3.fromRGB(0, 0, 0),
	SoftButton = Color3.fromRGB(52, 52, 58),
	SoftButtonHover = Color3.fromRGB(66, 66, 73),
	SoftAccent = Color3.fromRGB(44, 44, 50),
	SoftAccentHover = Color3.fromRGB(56, 56, 63),
	ToggleOn = Color3.fromRGB(195, 195, 205),
	ToggleOff = Color3.fromRGB(42, 42, 47),
	ToggleOff2 = Color3.fromRGB(42, 42, 47),
	ToggleKnobOn = Color3.fromRGB(22, 22, 24),
	ToggleKnobOff = Color3.fromRGB(105, 105, 113),
	InputBg = Color3.fromRGB(33, 33, 37),
	SliderBg = Color3.fromRGB(48, 48, 53),
	SliderFill = Color3.fromRGB(195, 195, 205),
	BlacklistHover = Color3.fromRGB(65, 38, 44),
	BlacklistLeave = Color3.fromRGB(40, 30, 34),
},
	Nexus = {
	Background = Color3.fromRGB(28, 28, 30),
	MainBackground = Color3.fromRGB(22, 22, 24),
	SidebarBg = Color3.fromRGB(16, 16, 18),
	ContentBg = Color3.fromRGB(30, 30, 33),
	SidebarActive = Color3.fromRGB(55, 55, 60),
	SidebarActiveText = Color3.fromRGB(255, 255, 255),
	SidebarInactiveText = Color3.fromRGB(185, 185, 192),
	Panel = Color3.fromRGB(36, 36, 40),
	Row = Color3.fromRGB(44, 44, 48),
	RowHover = Color3.fromRGB(56, 56, 62),
	Accent = Color3.fromRGB(175, 175, 185),
	AccentLight = Color3.fromRGB(95, 95, 105),
	Green = Color3.fromRGB(175, 175, 185),
	Red = Color3.fromRGB(210, 80, 90),
	Red2 = Color3.fromRGB(185, 60, 72),
	Text = Color3.fromRGB(255, 255, 255),
	Dim = Color3.fromRGB(155, 155, 163),
	Stroke = Color3.fromRGB(0, 0, 0),
	SoftButton = Color3.fromRGB(52, 52, 58),
	SoftButtonHover = Color3.fromRGB(66, 66, 73),
	SoftAccent = Color3.fromRGB(44, 44, 50),
	SoftAccentHover = Color3.fromRGB(56, 56, 63),
	ToggleOn = Color3.fromRGB(195, 195, 205),
	ToggleOff = Color3.fromRGB(42, 42, 47),
	ToggleOff2 = Color3.fromRGB(42, 42, 47),
	ToggleKnobOn = Color3.fromRGB(22, 22, 24),
	ToggleKnobOff = Color3.fromRGB(105, 105, 113),
	InputBg = Color3.fromRGB(33, 33, 37),
	SliderBg = Color3.fromRGB(48, 48, 53),
	SliderFill = Color3.fromRGB(195, 195, 205),
	BlacklistHover = Color3.fromRGB(65, 38, 44),
	BlacklistLeave = Color3.fromRGB(40, 30, 34),
},
}

Theme = {}

for k, nexu in pairs(Themes.Nexus) do
	Theme[k] = nexu
end

UIFont = {
	Brand = Enum.Font.GothamBold,
	Title = Enum.Font.GothamBlack,
	Body = Enum.Font.GothamMedium,
	Label = Enum.Font.GothamSemibold,
	Button = Enum.Font.GothamBold,
	Small = Enum.Font.Gotham,
}

UITransparency = {
	MainPanel = 0.06,
	Sidebar = 0.06,
	Content = 0.03,
	Panel = 0.06,
	BottomBar = 0.02,
	Button = 0,
	MainButton = 0.04,
	Row = 0.04,
	RowAlt = 0.1,
	SoftRow = 0.05,
	Input = 0.05,
	Toggle = 0,
	Hud = 0.1,
	Alert = 0.12,
	Progress = 0.1,
	ConfigPanel = 0.02,
	SidebarTab = 0.05,
	TargetRow = 0.06,
	TargetRowAlt = 0.12,
	Dropdown = 0.02,
	Outline = 0.72,
	Avatar = 0.1,
}

applyTheme = function(currentTheme)
	if _G._currentTheme == currentTheme then
		return
	end
	_G._currentTheme = currentTheme
	local tbl6 = {}

	for k, v2 in pairs(Theme) do
		tbl6[k] = v2
	end

	local light = Themes[currentTheme] or Themes.Light

	for k, v2 in pairs(light) do
		Theme[k] = v2
	end

	local function fn4(arg, arg2)
		if not arg then
			return
		end
		arg.BackgroundColor3 = arg2 and light.MainBackground or light.Background

		for i, child in ipairs(arg:GetChildren()) do
			if child:IsA("UIStroke") then
				if child.Name ~= "WhiteOutline" then
					child.Color = light.Stroke
				end
			elseif child:IsA("Frame") then
				if child.Size == UDim2.new(1, -24, 0, 1) then
					child.BackgroundColor3 = light.AccentLight
				elseif child.BackgroundTransparency == 1 and child.Size == UDim2.new(1, 0, 0, 42) then
					for i2, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("TextLabel") then
							if child2.TextSize == 16 or child2.TextSize == 12 then
								child2.TextColor3 = light.Text
							elseif child2.TextSize == 10 then
								child2.TextColor3 = light.Dim
							end
						end
					end
				elseif child.Size == UDim2.new(1, 0, 0, 38) then
					child.BackgroundColor3 = light.SidebarBg or Color3.fromRGB(0, 0, 0)

					for i2, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("TextLabel") then
							if child2.TextSize == 16 or child2.TextSize == 13 or child2.TextSize == 12 then
								child2.TextColor3 = light.Text
							elseif child2.TextSize == 8 then
								child2.TextColor3 = light.Dim
							end
						elseif child2:IsA("Frame") then
							if child2.Size == UDim2.new(1, 0, 0, 10) then
								child2.BackgroundColor3 = light.Background
							elseif child2.Size == UDim2.new(0, 26, 0, 2) then
								child2.BackgroundColor3 = light.Accent
							end
						end
					end
				end
			end
		end
	end

	local function fn5()
		if not bottomBar then
			return
		end
		bottomBar.BackgroundColor3 = light.Panel

		for i, child in ipairs(bottomBar:GetChildren()) do
			if child:IsA("UIStroke") then
				if child.Name ~= "BBStroke" then
					child.Color = light.Stroke
				end
			elseif child:IsA("TextLabel") then
				if child.Name == "BrandTitle" then
					child.TextColor3 = light.Text
				elseif child.Name == "BrandSep" or child.Name == "BrandDiscord" then
					child.TextColor3 = light.Dim
				end
			elseif child:IsA("Frame") then
				if child.Name == "BottomBarDiv" or child.Size == UDim2.new(0, 1, 0, 36) or child.Size == UDim2.new(0, 1, 0, 28) then
					child.BackgroundColor3 = light.Stroke
				end
			end
		end

		local topInfo_ = bottomBar:FindFirstChild("TopInfo")

		if topInfo_ then
			for i, child in ipairs(topInfo_:GetChildren()) do
				if child:IsA("TextLabel") then
					if child.Name == "BrandTitle" then
						child.TextColor3 = light.Text
					elseif child.Name == "BrandSep" or child.Name == "BrandDiscord" then
						child.TextColor3 = light.Dim
					end
				end
			end
		end

		if fpsText then
			fpsText.TextColor3 = light.Dim
		end

		if main then
			local sidebar = main:FindFirstChild("Sidebar")

			if sidebar then
				sidebar.BackgroundColor3 = light.SidebarBg or Color3.fromRGB(0, 0, 0)
			end

			local contentBg = main:FindFirstChild("ContentBg")

			if contentBg then
				contentBg.BackgroundColor3 = light.ContentBg or light.MainBackground
			end
		end

		if sidebarProfile then
			for i, child in ipairs(sidebarProfile:GetChildren()) do
				if child:IsA("TextLabel") then
					if child.Name == "ProfileName" then
						child.TextColor3 = light.Text
					elseif child.Name == "ProfileHandle" then
						child.TextColor3 = light.Dim
					end
				end
			end
		end

		if _G.styleSidebarTabs and UI and UI.CurrentTab then
			pcall(_G.styleSidebarTabs, UI.CurrentTab)
		end
	end

	local function fn6()
		if not apBG then
			return
		end
		apBG.BackgroundTransparency = 1

		for k, v2 in pairs(apRows) do
			if v2 and v2.Parent then
				v2.BackgroundTransparency = 1

				for i, child in ipairs(v2:GetChildren()) do
					if child:IsA("Frame") then
						if child.Size == UDim2.fromOffset(34, 34) then
							child.BackgroundTransparency = 1
							local uiStroke = child:FindFirstChildOfClass("UIStroke")

							if uiStroke then
								uiStroke.Transparency = 1
							end
						elseif child.ZIndex == 12 then
							for i2, child2 in ipairs(child:GetChildren()) do
								if child2:IsA("TextButton") then
									child2.BackgroundTransparency = 1
								end
							end
						end
					elseif child:IsA("TextLabel") then
						if child.TextSize == 14 then
							child.TextColor3 = light.Text
						elseif child.TextSize == 10 then
							child.TextColor3 = light.Dim
						elseif child.TextSize == 11 then
							child.TextColor3 = light.AccentLight
						end
					end
				end
			end
		end
	end

	pcall(function()
		fn4(main, true)
		fn5()
		fn6()

		for i, v2 in ipairs({
			"Invisible Steal Panel",
			"Admin Command Panel",
			"Command Cooldowns",
			"Actions",
			"Steal Panel",
			"Steal Target",
		}) do
			fn4(panels[v2], false)
		end

		fn4(actionSettingsPanel, false)
		fn4(tpSpeedSettingsPanel, false)
	end)

	local function fn7(arg)
		local flag = true

		if arg:IsA("GuiObject") or arg:IsA("UIStroke") then
			if mainBody and arg:IsDescendantOf(mainBody) then
				return
			end

			if arg == main or arg == bottomBar or arg == apBG then
				flag = false
			end

			for i, v2 in ipairs({
				"Invisible Steal Panel",
				"Admin Command Panel",
				"Command Cooldowns",
				"Actions",
				"Steal Panel",
				"Steal Target",
			}) do
				if arg == panels[v2] then
					flag = false
				end
			end

			if arg == actionSettingsPanel or arg == tpSpeedSettingsPanel then
				flag = false
			end

			if flag then
				local tbl7 = {
					Background = true,
					MainBackground = true,
					SidebarBg = true,
					ContentBg = true,
					SidebarActive = true,
					Panel = true,
					Row = true,
					RowHover = true,
					SoftButton = true,
					SoftButtonHover = true,
					SoftAccent = true,
					SoftAccentHover = true,
					ToggleOn = true,
					ToggleOff = true,
					ToggleOff2 = true,
					InputBg = true,
					SliderBg = true,
					BlacklistHover = true,
					BlacklistLeave = true,
				}

				local tbl8 = {
					Text = true,
					Dim = true,
					Accent = true,
					AccentLight = true,
					SidebarActiveText = true,
					SidebarInactiveText = true,
					Green = true,
					Red = true,
					Red2 = true,
					Stroke = true,
					ToggleKnobOn = true,
					ToggleKnobOff = true,
				}

				local tbl9 = {
					BackgroundColor3 = tbl7,
					TextColor3 = tbl8,
					PlaceholderColor3 = tbl8,
					Color = tbl8,
				}

				for k, v2 in pairs(tbl9) do
					pcall(function()
						local v3 = arg[k]

						if typeof(v3) == "Color3" then
							if k == "TextColor3" and arg.Name == "WhiteTextBtn" then
								return
							end

							if k == "BackgroundColor3" and arg.Name == "WhiteSliderKnob" then
								return
							end

							if k == "Color" and arg:IsA("UIStroke") and (arg.Name == "WhiteOutline" or arg.Name == "BBStroke") then
								return
							end

							for k2, v4 in pairs(tbl6) do
								if v2[k2] then
									if (v3.R - v4.R) ^ 2 + (v3.G - v4.G) ^ 2 + (v3.B - v4.B) ^ 2 < 0.0001 then
										local color = light[k2]

										if k == "TextColor3" then
											local n = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B

											if n < 0.5 then
												color = Color3.new(1, 1, 1)
											end
										end

										arg[k] = color
										break
									end
								end
							end
						end
					end)
				end
			end
		end

		for i, child in ipairs(arg:GetChildren()) do
			fn7(child)
		end
	end

	pcall(function()
		local BJKHub_V32 = _G.BJKBuscaGui("BJKHub_V3")

		if BJKHub_V32 then
			fn7(BJKHub_V32)
		end

		if _G.updateLogoImage then
			_G.updateLogoImage(currentTheme ~= "Light")
		end
	end)

	pcall(function()
		local hui = gethui and gethui() or game:GetService("CoreGui")
		local bjkPriorityAlert = hui:FindFirstChild("BJK_PriorityAlert")

		if bjkPriorityAlert then
			fn7(bjkPriorityAlert)
		end
	end)

	for i, v2 in ipairs({ "BJK_RemoteSell", "BJK_StealProgressBar", "BJK_AdminPanel" }) do
		pcall(function()
			local v3 = _G.BJKBuscaGui(v2)

			if v3 then
				fn7(v3)
			end
		end)
	end

	local function fn8(arg)
		if arg:IsA("TextButton") then
			local text = arg.Text

			if text == "ON" or text == "OFF" or text == "ADD" or text == "X" or text == "?" or text == "?" then
				if arg.Name == "SyncStateBtn" then
					arg.TextColor3 = Color3.new(1, 1, 1)
				else
					arg.TextColor3 = Color3.new(1, 1, 1)
				end
			elseif arg.Size == UDim2.new(0, 50, 0, 20) then
				arg.TextColor3 = Color3.new(1, 1, 1)
			end
		elseif arg:IsA("Frame") and arg.Name == "WhiteSliderKnob" then
			arg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		end

		for i, child in ipairs(arg:GetChildren()) do
			fn8(child)
		end
	end

	pcall(function()
		local BJKHub_V32 = _G.BJKBuscaGui("BJKHub_V3")

		if BJKHub_V32 then
			fn8(BJKHub_V32)
		end
	end)

	if mainConfig then
		mainConfig.DarkMode = currentTheme == "Dark"

		if saveConfig then
			saveConfig()
		end
	end

	pcall(function()
		if rebuildActions then
			rebuildActions()
		end
	end)

	pcall(function()
		if rebuildActionSettings then
			rebuildActionSettings()
		end
	end)

	pcall(function()
		if rebuildTpSpeedSettings then
			rebuildTpSpeedSettings()
		end
	end)

	pcall(function()
		if loadTab then
			loadTab(UI.CurrentTab)
		end
	end)
end

_G.applyTheme = applyTheme

UI = {
	Locked = false,
	OpenMenuKey = Enum.KeyCode.LeftControl,
	CurrentTab = "Auto TP",
}

Keybinds = {
	Kick = "NONE",
	Clone = "NONE",
	["Manual TP"] = "NONE",
	["Invisible Steal"] = "NONE",
	Proximity = "NONE",
	["Carpet Boost"] = "NONE",
	["Open Menu"] = "LeftControl",
	["Ragdoll Self"] = "NONE",
	["Drop Brainrot"] = "NONE",
	Float = "NONE",
	Reset = "NONE",
	["Auto Buy"] = "NONE",
	["Click to AP"] = "NONE",
}

priorityList = {
	"Headless Horseman",
	"Polaroidini",
	"Signore Carapace",
	"Strawberry Elephant",
	"John Pork",
	"Meowl",
	"Arcadragon",
	"Elefanto Frigo",
	"Skibidi Toilet",
	"Love Love Bear",
	"Antonio",
	"Griffin",
	"Dragon Gingerini",
	"Dragon Aquanini",
	"Digi Narwhal",
	"Kraken",
	"La Supreme Combinasion",
	"Hydra Bunny",
	"Moby Bros",
	"Jelly Moby",
	"Tirilikalika Tirilikalako",
	"Kalika Bros",
	"Fishino Clownino",
	"Ginger Gerat",
	"Orchidox",
	"Pancake and Syrup",
	"Bunny and Eggy",
	"Grabatron",
	"Hydra Dragon Cannelloni",
	"Sammyni Cakini",
	"Dragon Cannelloni",
	"Duggy Bros",
	"Bumbatron",
	"Ketupat Bros",
	"Venuspino",
	"La Casa Boo",
	"Rosey and Teddy",
	"Los Hackers",
	"Noo my examine",
	"Sammyni Truckini",
	"Rico Dinero",
	"Los Sekolahs",
	"Foxini Lanternini",
	"Dug dug dug",
	"La Breakfast Combinasion",
	"Reinito Sleighito",
	"Examen Bros",
	"Jolly Jolly Sahur",
	"La Food Combinasion",
	"Los Admins",
	"Los Secret Combinasionas",
	"Fragrama and Chocrama",
	"Fortunu and Cashuru",
	"Guest 666",
	"Rubrikiko",
	"Rubiko and Kubiko",
	"Sammyni Fattini",
	"Quackini Snackini",
	"Spooky and Pumpky",
	"Cooki and Milki",
	"Los Chillis",
	"Los Amigos",
	"Pop Pop Petalini",
	"S'more Serat",
	"La Fuse Machine",
	"Bearito Cabinito",
	"Cerberus",
	"Festive 67",
	"Nachorilla",
	"Yetimatic",
	"Popcuru and Fizzuru",
	"Capitano Moby",
	"Gym Bros",
	"Fragola La La La",
	"Celestial Pegasus",
	"Pizza and Ranch",
	"La Secret Combinasion",
	"Burguro And Fryuro",
	"Cloverat Clapat",
	"Hopilikalika Hopilikalako",
	"Boppin Bunny",
	"Garama and Madundung",
	"Cash or Card",
	"Los Tacoritas",
	"Los Spaghettis",
	"La Lucky Grande",
	"La Easter Grande",
	"La Anniversary Grande",
	"La Romantic Grande",
	"La Summer Grande",
	"Coco and Mango",
	"Capitano Americano",
	"Caylusaurus",
	"Nacho Spyder",
	"Steakini Fattini",
	"Money Money Bros",
	"Swaggy Bros",
	"Gold Gold Gold",
	"La Taco Combinasion",
	"Lovin Rose",
	"Los Tictacs",
	"Ventoliero Pavonero",
	"Ketchuru and Musturu",
	"Los Tangcitos",
	"La Ginger Sekolah",
	"Abyssaloco",
	"Rosetti Tualetti",
	"Tictac Sahur",
	"Lavadorito Spinito",
	"Orcaledon",
	"Ketupat Kepat",
	"Tang Tang Keletang",
	"Cangurato Gelato",
	"Noo my Resume",
	"Queen Bee",
	"Candini Fluffini",
	"Honey Honey Bear",
	"Spaghetti Tualetti",
	"Scorpino Coasterino",
	"Esok Goala",
}

actionConfig = {
	["Ragdoll Self"] = true,
	Rejoin = true,
	["Self Kick"] = true,
	Kick = true,
	["Kick To Private"] = true,
	Reset = true,
	["Anti Ragdoll"] = false,
	["Infinite Jump"] = false,
	["Carpet Speed"] = false,
	Menu = true,
	Teleport = true,
	["Instant Clone"] = true,
	["Drop Brainrot"] = true,
}

CONFIG_FILE = "BJKConfigs.json"
PS_CODE_FILE = "BJKHubPS.txt"
PrivateServerCode = ""

resolveShareLink = function(arg)
	local v2

	pcall(function()
		local request_ = (syn or {}).request or (http or {}).request
		if not request_ then
			return
		end

		local v3 = request_({
			Url = arg,
			Method = "GET",
			FollowRedirects = false,
			Headers = {
			["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
		},
		})

		local location = v3 and (v3.Location or type(v3.Headers) == "table" and (v3.Headers.location or v3.Headers.Location))

		if location then
			local pos, v4, v5 = location:find("[?&]privateServerLinkCode=([^&]+)")

			if v5 then
				v2 = v5
			end
		end
	end)

	return v2
end

loadPSCode = function()
	pcall(function()
		if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(PS_CODE_FILE) then
			local v2 = readfile(PS_CODE_FILE)
			local pos, v3, v4 = v2:find("[?&]privateServerLinkCode=([^&]+)")
			if v4 then
				PrivateServerCode = v4
				return
			end
			PrivateServerCode = v2
		end
	end)
end

function savePSCode()
	pcall(function()
		local str = PrivateServerCode or ""
		local pos, v2, v3 = str:find("[?&]privateServerLinkCode=([^&]+)")

		if typeof(writefile) == "function" then
			writefile(PS_CODE_FILE, v3 or str)
		end
	end)
end

loadPSCode()

mainConfig = {
	positions = {},
	keybinds = {},
	actions = {},
	locked = false,
	DarkMode = false,
	AntiRagdoll = false,
	InfiniteJump = false,
	Float = false,
	DarkTheme = false,
	DarkThemeIntensity = 50,
	AutoResetBalloon = false,
	AutoKickOnSteal = false,
	KickToPrivateServer = false,
	CleanErrorGUIs = false,
	Steal3DViewer = false,
	LineToBase = false,
	LineToBrainrot = false,
	InvisStealAngle = 180,
	SinkSliderValue = 8,
	AutoRecoverLagback = false,
	AutoTPPriority = false,
	AutoTPHighestGen = false,
	AutoTPHighestValue = false,
	FFlagsEnabled = false,
	XRay = false,
	FpsOptimizer = false,
	RemoveAnimations = false,
	OptimizeFloorSmooth = false,
	OptimizeStripMeshTextures = false,
	FOV = 70,
	LEDBar = false,
	BrainrotESP = false,
	TimerESP = false,
	PlayerESP = false,
	BaseOwnerESP = false,
	MinBrainrotESPGen = "",
	MinCarpetESPGen = "",
	CarpetESP = false,
	BrainrotAlert = false,
	PrioritySoundID = "100173184074904",
	PrioritySoundVolume = 1,
	AutoBuyEnabled = false,
	AutoBuyRange = 17,
	AutoGrabSpeed = 17,
	AutoBuyKey = "K",
	AutoDestroyTurrets = false,
	AutoUnlockOnSteal = false,
	AutoInvisDuringSteal = false,
	InvisDelayEnabled = false,
	InvisDelayMs = 0,
	FaceAway = false,
	FaceAwayModo = "baseowner",
	FaceAwayAlvo = nil,
	FaceAwayNearest = false,
	ClickToAP = false,
	ClickToAPSingleCommand = false,
	ClickToAPRadius = 8,
	SpamBaseOwnerCommands = {
	balloon = true,
	inverse = true,
	jail = true,
	jumpscare = true,
	morph = true,
	ragdoll = true,
	rocket = true,
	tiny = true,
},
	SpamBaseOwnerOrder = {
	"balloon",
	"inverse",
	"jail",
	"jumpscare",
	"morph",
	"ragdoll",
	"rocket",
	"tiny",
},
	SpamBaseOwnerSingleCommand = false,
	ProximityAP = false,
	ShowJobJoiner = false,
	AntiBeeDisco = false,
	RemoteSellEnabled = false,
	AdminPanelUI = false,
	AdminPanelAllButton = false,
	StealHighest = false,
	StealPriority = false,
	StealNearest = false,
	AutoStealEnabled = false,
	AutoGoToBrainrotOnFailedSteal = false,
	Unwalk = false,
	AntiFlasher = false,
	AntiBodySwap = false,
	Visibilities = {
	["Invisible Steal Panel"] = false,
	["Admin Command Panel"] = false,
	["Command Cooldowns"] = false,
	Actions = true,
	["Steal Panel"] = false,
	["Steal Target"] = false,
	["Grief Detector"] = false,
},
	UnlockBaseUI = false,
	StealBarUI = false,
	BaseTimerUI = false,
	TpSettings = {
	Tool = "Flying Carpet",
	TpKey = "T",
	CloneKey = "V",
	CarpetSpeedKey = "Q",
	InfiniteJump = false,
	DelayVal = 0.4,
	CloneDelayVal = 0.1,
	CloneToBrainrotDelay = 0,
	RagdollTP = false,
	FPSWait = false,
	FlyTPSpeed = 160,
	FlyTPCloseSpeed = 75,
	GrabbleTP = false,
	GrabbleTPSpeed = 230,
	TpOnLoad = false,
	TpOnLoadDelay = 0.5,
	MinGenForTp = "",
	MinGenForGrab = "",
	StableFPSBeforeTP = false,
	StableFPSValue = 0,
	SkipStolenBest = false,
	SkipConveyorBrainrot = false,
	AutoBuyOnConveyor = false,
	AutoBuyOnConveyorMinGen = "",
	GoToBrainrotNonInstant = false,
	GoToBrainrotInstant = true,
},
	PriorityList = priorityList,
	RemovedFromPriority = {},
}

_G.MainConfig = mainConfig
brainrotESPEnabled = mainConfig.BrainrotESP
tbl2 = {}

tbl3 = {
	Radioactive = "68F500",
	Galaxy = "AA3CFF",
	Yinyang = "DCDCDC",
	YinYang = "DCDCDC",
	Cyber = "7BDBFF",
	Bloodrot = "91001B",
	Candy = "C0C0C0",
	Cursed = "F53838",
	Diamond = "25C4FE",
	Divine = "FFD13B",
	Gold = "FFDE59",
	Normal = "A0A0A0",
	Lava = "FF9500",
	Rainbow = "FF00FB",
	Phantom = "B4B4B4",
	Crystal = "DA70D6",
	Shiny = "FFD700",
	Golden = "FFD700",
	DarkMatter = "9932CC",
	Neon = "FF00FF",
	Luminous = "FFFACD",
	Glossy = "87CEEB",
	Glow = "00FF7F",
	Radiant = "FF4500",
	Titanium = "C0C0C0",
	Holographic = "FF69B4",
	Corrupted = "8B0000",
	Magma = "FF6347",
	Frost = "E0FFFF",
	Shadow = "2F2F2F",
	Zombie = "556B2F",
	Skeleton = "F5F5DC",
	Ghost = "DDA0DD",
	Toxic = "7FFF00",
	Thunder = "FFFF00",
	Cosmo = "7B68EE",
	Mosaic = "FF8C00",
	Icy = "ADD8E6",
	Fiery = "FF4500",
	Stormy = "4682B4",
	Angel = "FFE4E1",
	Demon = "DC143C",
	Metallic = "B8860B",
}

function createBrainrotBillboard(arg)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "BrainrotESP_" .. arg.uid
	local frame, textLabel, textLabel2
	billboardGui.Size = UDim2.new(0, 150, 0, 42)
	billboardGui.StudsOffset = Vector3.new(0, 2.4, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.LightInfluence = 0
	billboardGui.MaxDistance = 3000
	frame = Instance.new("Frame", billboardGui)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 0.6
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	local uiStroke = Instance.new("UIStroke", frame)
	uiStroke.Color = Color3.new(1, 1, 1)
	uiStroke.Thickness = 1
	uiStroke.Transparency = 0.6
	textLabel = Instance.new("TextLabel", frame)
	textLabel.Size = UDim2.new(1, 0, 0.55, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	textLabel.RichText = true
	textLabel.Text = arg.name and arg.name .. (arg.fusing and " <font color=\"#00BFFF\">[FUSE]</font>" or "") or "???"
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2 = Instance.new("TextLabel", frame)
	textLabel2.Size = UDim2.new(1, 0, 0.45, 0)
	textLabel2.Position = UDim2.new(0, 0, 0.55, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextScaled = true
	textLabel2.TextWrapped = true
	textLabel2.TextColor3 = Color3.fromRGB(255, 220, 50)
	textLabel2.TextStrokeTransparency = 0
	textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
	textLabel2.RichText = true
	local genText = arg.genText or ""
	local mutation = arg.mutation and arg.mutation ~= "None" and arg.mutation or nil

	if mutation then
		local str = tbl3[mutation] or "FFFFFF"
		textLabel2.Text = genText .. " <font color='#" .. str .. "'>" .. mutation .. "</font>"
	else
		textLabel2.Text = genText
	end

	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	return billboardGui
end

function refreshBrainrotESP()
	if _G.bjkESPBlocked and _G.bjkESPBlocked() then
		pcall(clearBrainrotESP)
		return
	end

	if not brainrotESPEnabled then
		return
	end

	if not SharedState.AllAnimalsCache then
		return
	end
	local n
	local minBrainrotESPGen = mainConfig.MinBrainrotESPGen or ""
	local v2 = parseGenInput(minBrainrotESPGen)

	if minBrainrotESPGen == "" or minBrainrotESPGen == "0" then
		n = -1
	elseif v2 and v2 > 0 then
		n = v2
	else
		local n2 = 0
		local flag = false

		for i, v3 in ipairs(SharedState.AllAnimalsCache) do
			if v3.genValue > n2 then
				n2 = v3.genValue
			end

			if not flag and v3.genValue >= 10000000 then
				flag = true
			end
		end

		n = flag and 10000000 or n2 * 0.5
	end

	local tbl6 = {}

	for i, v3 in ipairs(SharedState.AllAnimalsCache) do
		if v3.genValue >= n then
			local plot = v3.plot

			if plot then
				local plotsFolder = (_G.PlotsFolder or Workspace:FindFirstChild("Plots")) and (_G.PlotsFolder or Workspace:FindFirstChild("Plots")):FindFirstChild(plot)
				if plotsFolder and getPlotOwner(plotsFolder) == localPlayer2 then
					continue
				end
			end

			tbl6[v3.uid] = true

			if not tbl2[v3.uid] then
				local v4 = findAdorneeGlobal(v3)

				if v4 then
					local v5 = createBrainrotBillboard(v3)
					v5.Adornee = v4
					v5.Parent = v4
					tbl2[v3.uid] = { bb = v5 }
				end
			end
		end
	end

	for k, v3 in pairs(tbl2) do
		if not tbl6[k] then
			if v3.bb then
				v3.bb:Destroy()
			end

			tbl2[k] = nil
		end
	end
end

function clearBrainrotESP()
	for k, v2 in pairs(tbl2) do
		if v2.bb then
			pcall(function()
				v2.bb:Destroy()
			end)
		end
	end

	tbl2 = {}
end

task.spawn(function()
	local touchEnabled = game:GetService("UserInputService").TouchEnabled
	local flag = false

	while true do
		if _G.BJK_HubGen ~= bjkHubGen then
			break
		end
		task.wait(touchEnabled and 2 or 1.2)
		if _G.BJK_HubGen ~= bjkHubGen then
			break
		end

		if _G.TpOnLoadRunning then
			task.wait(1)
			continue
		end

		if brainrotESPEnabled then
			flag = true
			pcall(refreshBrainrotESP)
		else
			if flag then
				flag = false
				pcall(clearBrainrotESP)
			end
		end
	end
end)

task.spawn(function()
	local n = 0
	local n2 = _G.BJK_IS_MOBILE and 60 or 30

	while true do
		if _G.BJK_HubGen ~= bjkHubGen then
			break
		end
		task.wait()
		if _G.BJK_HubGen ~= bjkHubGen then
			break
		end

		if _G.TpOnLoadRunning then
			task.wait(1)
			continue
		end

		if not brainrotESPEnabled then
			continue
		end
		n = n + 1
		if n % n2 ~= 0 then
			continue
		end

		if next(tbl2) == nil then
			continue
		end

		if not workspace.CurrentCamera then
			continue
		end
		local position = workspace.CurrentCamera.CFrame.Position

		for k, v2 in pairs(tbl2) do
			local bb = v2 and v2.bb
			local adornee = bb and bb.Adornee
			local position2 = adornee and (adornee:IsA("BasePart") and adornee.Position or adornee:IsA("Attachment") and adornee.WorldPosition)
			if not position2 then
				continue
			end
			local magnitude = (position - position2).Magnitude
			local n3 = math.clamp(magnitude / 80, 0.95, 1.3)
			local n4 = math.floor(110 * n3)
			local n5 = math.floor(30 * n3)
			local offset, offset2 = bb.Size.X.Offset, bb.Size.Y.Offset
			local n6 = math.floor(offset + (n4 - offset) * 0.15)
			local n7 = math.floor(offset2 + (n5 - offset2) * 0.15)

			if n6 ~= offset or n7 ~= offset2 then
				bb.Size = UDim2.new(0, n6, 0, n7)
			end
		end
	end
end)

suffixes = {
	k = 1000,
	m = 1000000,
	b = 1000000000,
	t = 1000000000000,
	q = 1000000000000000,
	qi = 1e+18,
	qd = 1e+18,
	qn = 1e+18,
	sx = 1e+21,
	sp = 1e+24,
	oc = 1e+27,
	no = 1e+30,
	dc = 1e+33,
	ud = 1e+36,
	dd = 1e+39,
	td = 1e+42,
	qad = 1e+45,
	qid = 1e+48,
	sxd = 1e+51,
	spd = 1e+54,
	ocd = 1e+57,
	nod = 1e+60,
	vg = 1e+63,
}

function parseMinGen(arg)
	if not arg or type(arg) ~= "string" then
		return 0
	end
	arg = arg:gsub("%s", ""):lower():gsub("/s$", "")
	if arg == "" then
		return 0
	end
	local match, v2 = arg:match("^([%d%.]+)(%a*)$")
	if not match then
		return 0
	end
	local num = tonumber(match)
	if not num or num < 0 then
		return 0
	end

	if v2 ~= "" then
		local v3 = suffixes[v2]
		if v3 then
			return num * v3
		end
	end

	return num
end

function parseGenInput(arg)
	if not arg or arg == "" then
		return nil
	end
	arg = arg:gsub("%s", ""):upper()
	local match, v2 = arg:match("^([%d%.]+)([MB])$")

	if not match then
		local num = tonumber(arg)
		if num and num > 0 then
			return num
		end
		return nil
	end

	local num = tonumber(match)
	if not num then
		return nil
	end

	if v2 == "M" then
		return num * 1000000
	end

	if v2 == "B" then
		return num * 1000000000
	end
	return nil
end

function canUseFiles()
	return typeof(readfile) == "function" and typeof(writefile) == "function" and typeof(isfile) == "function"
end

loadConfig = function()
	if not canUseFiles() then
		return
	end

	local ok, result = pcall(function()
		if isfile(CONFIG_FILE) then
			return HttpService:JSONDecode(readfile(CONFIG_FILE))
		end
	end)

	if ok and type(result) == "table" then
		for k, v2 in pairs(result) do
			if k == "PriorityList" or k == "RemovedFromPriority" then
				mainConfig[k] = v2
			elseif type(v2) == "table" and type(mainConfig[k]) == "table" then
				for k2, v3 in pairs(v2) do
					mainConfig[k][k2] = v3
				end
			else
				mainConfig[k] = v2
			end
		end

		if type(mainConfig.positions) ~= "table" then
			mainConfig.positions = {}
		end

		if type(mainConfig.keybinds) ~= "table" then
			mainConfig.keybinds = {}
		end

		if type(mainConfig.actions) ~= "table" then
			mainConfig.actions = {}
		end

		if type(mainConfig.RemovedFromPriority) ~= "table" then
			mainConfig.RemovedFromPriority = {}
		end

		if type(mainConfig.sizes) ~= "table" then
			mainConfig.sizes = {}
		end

		if mainConfig.PrioritySoundID == nil or mainConfig.PrioritySoundID == "" then
			mainConfig.PrioritySoundID = "100173184074904"
		end

		local tbl6 = {}

		for i, v2 in ipairs(mainConfig.RemovedFromPriority) do
			tbl6[v2] = true
		end

		if type(mainConfig.PriorityList) == "table" then
			if #mainConfig.PriorityList == 0 then
				mainConfig.PriorityList = priorityList
			else
				local tbl7 = {}

				for i, v2 in ipairs(mainConfig.PriorityList) do
					tbl7[v2] = true
				end

				for i, v2 in ipairs(priorityList) do
					if not tbl7[v2] and not tbl6[v2] then
						table.insert(mainConfig.PriorityList, v2)
					end
				end

				priorityList = mainConfig.PriorityList
			end
		else
			mainConfig.PriorityList = priorityList
		end

		if type(mainConfig.PriorityList) == "table" then
			local tbl7 = {}
			local priorityList_ = {}

			for i, v2 in ipairs(mainConfig.PriorityList) do
				if not tbl7[v2] then
					tbl7[v2] = true
					table.insert(priorityList_, v2)
				end
			end

			mainConfig.PriorityList = priorityList_
			priorityList = priorityList_
		end
	end
end

saveConfig = function()
	if not canUseFiles() then
		return
	end

	task.spawn(function()
		pcall(function()
			writefile(CONFIG_FILE, HttpService:JSONEncode(mainConfig))
		end)
	end)
end

do
	local str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	local function fn4(arg)
		local n = #arg
		local tbl6 = {}

		for i = 1, n, 3 do
			local v2 = arg:byte(i)
			local n2 = arg:byte(i + 1) or 0
			local n3 = arg:byte(i + 2) or 0
			local n4 = v2 * 65536 + n2 * 256 + n3
			tbl6[#tbl6 + 1] = str:sub(math.floor(n4 / 262144) + 1, math.floor(n4 / 262144) + 1)
			tbl6[#tbl6 + 1] = str:sub(math.floor(n4 / 4096) % 64 + 1, math.floor(n4 / 4096) % 64 + 1)
			tbl6[#tbl6 + 1] = i + 1 <= n and str:sub(math.floor(n4 / 64) % 64 + 1, math.floor(n4 / 64) % 64 + 1) or "="
			tbl6[#tbl6 + 1] = i + 2 <= n and str:sub(n4 % 64 + 1, n4 % 64 + 1) or "="
		end

		return table.concat(tbl6)
	end

	local function fn5(arg)
		arg = arg:gsub("[^" .. str .. "=]", "")
		local n = #arg
		local tbl6 = {}
		local tbl7 = {}

		for i = 1, 64 do
			tbl7[str:sub(i, i)] = i - 1
		end

		local n2 = 1

		while n2 <= n do
			local v2 = tbl7[arg:sub(n2, n2)]
			local v3 = tbl7[arg:sub(n2 + 1, n2 + 1)]
			local str2 = arg:sub(n2 + 2, n2 + 2)
			local str3 = arg:sub(n2 + 3, n2 + 3)
			local v4 = tbl7[str2]
			local v5 = tbl7[str3]
			if not v2 or not v3 then
				break
			end
			local n3 = v2 * 262144 + v3 * 4096 + (v4 or 0) * 64 + (v5 or 0)
			tbl6[#tbl6 + 1] = string.char(math.floor(n3 / 65536))

			if str2 ~= "=" then
				tbl6[#tbl6 + 1] = string.char(math.floor(n3 / 256) % 256)
			end

			if str3 ~= "=" then
				tbl6[#tbl6 + 1] = string.char(n3 % 256)
			end

			n2 = n2 + 4
		end

		return table.concat(tbl6)
	end

	_G.importConfig = function(arg)
		if not arg or arg == "" then
			ShowNotification("IMPORT ERROR", "Config string is empty")
			return false
		end

		local ok, result = pcall(function()
			return HttpService:JSONDecode(arg)
		end)

		if not ok or type(result) ~= "table" then
			local v2

			pcall(function()
				v2 = fn5(arg:gsub("%s", ""))
			end)

			if v2 then
				ok, result = pcall(function()
					return HttpService:JSONDecode(v2)
				end)
			end
		end

		if not ok or type(result) ~= "table" then
			ShowNotification("IMPORT ERROR", "Invalid config data")
			return false
		end

		for k, v2 in pairs(result) do
			mainConfig[k] = v2
		end

		if type(mainConfig.PriorityList) == "table" then
			priorityList = mainConfig.PriorityList
		end

		saveConfig()

		for k, v2 in pairs(mainConfig.keybinds or {}) do
			if Keybinds[k] ~= nil and type(v2) == "string" then
				Keybinds[k] = v2

				if k == "Open Menu" and Enum.KeyCode[v2] then
					UI.OpenMenuKey = Enum.KeyCode[v2]
				end
			end
		end

		for k, v2 in pairs(mainConfig.actions or {}) do
			if actionConfig[k] ~= nil then
				actionConfig[k] = v2 and true or false
			end
		end

		if type(mainConfig.locked) == "boolean" then
			UI.Locked = mainConfig.locked

			if _G.updateResizeGrips then
				pcall(_G.updateResizeGrips)
			end
		end

		initToggles()

		if setFPSBoost then
			pcall(setFPSBoost, false)
		end

		if setFPSBoostUltra then
			pcall(setFPSBoostUltra, false)
		end

		if setFFlags then
			pcall(setFFlags, mainConfig.FFlagsEnabled == true)
		end

		if setXRay then
			pcall(setXRay, mainConfig.XRay)
		end

		if setInfiniteJump then
			pcall(setInfiniteJump, mainConfig.InfiniteJump)
		end

		if setCarpetSpeed then
			pcall(setCarpetSpeed, mainConfig["Carpet Speed"] or mainConfig.CarpetSpeed or false)
		end

		mainConfig.ProximityAP = false
		mainConfig.AutoBuyEnabled = false

		if setStealMode then
			if mainConfig.StealHighest then
				pcall(setStealMode, "Highest")
			elseif mainConfig.StealPriority then
				pcall(setStealMode, "Priority")
			elseif mainConfig.StealNearest then
				pcall(setStealMode, "Nearest")
			end
		end

		if updateMovementPanelLabels then
			pcall(updateMovementPanelLabels)
		end

		local tbl6 = {}
		rebuildActions()
		rebuildActionSettings()
		loadTab(UI.CurrentTab)
		ShowNotification("CONFIG SYSTEM", "Config imported successfully!")
		return true
	end

	_G.exportConfig = function()
		local ok, result = pcall(function()
			return HttpService:JSONEncode(mainConfig)
		end)

		if not ok or not result then
			ShowNotification("EXPORT ERROR", "Failed to encode config")
			return nil
		end
		local flag = false

		if typeof(setclipboard) == "function" then
			pcall(function()
				setclipboard(result)
				flag = true
			end)
		elseif typeof(toclipboard) == "function" then
			pcall(function()
				toclipboard(result)
				flag = true
			end)
		end

		if flag then
			ShowNotification("CONFIG SYSTEM", "Config copied to clipboard!")
		else
			ShowNotification("CONFIG SYSTEM", "Config generated! Copy from share box.")
		end

		return result
	end
end

serializePos = function(arg)
	return {
		xs = arg.X.Scale,
		xo = arg.X.Offset,
		ys = arg.Y.Scale,
		yo = arg.Y.Offset,
	}
end

rememberPosition = function(arg, arg2)
	if not arg or not arg2 then
		return
	end
	mainConfig.positions[arg] = serializePos(arg2.Position)
	saveConfig()
end

applySavedPosition = function(arg, arg2)
	if not arg or not arg2 then
		return
	end
	local positions = mainConfig.positions and mainConfig.positions[arg]

	if positions then
		arg2.Position = UDim2.new(positions.xs or 0, positions.xo or 0, positions.ys or 0, positions.yo or 0)
	end
end

serializeSize = function(arg)
	return {
		xs = arg.X.Scale,
		xo = arg.X.Offset,
		ys = arg.Y.Scale,
		yo = arg.Y.Offset,
	}
end

rememberSize = function(arg, arg2)
	if not arg or not arg2 then
		return
	end
	mainConfig.sizes = mainConfig.sizes or {}
	mainConfig.sizes[arg] = serializeSize(arg2.Size)
	saveConfig()
end

applySavedSize = function(arg, arg2)
	if not arg or not arg2 then
		return
	end
	local sizes = mainConfig.sizes and mainConfig.sizes[arg]

	if sizes then
		arg2.Size = UDim2.new(sizes.xs or 0, sizes.xo or 0, sizes.ys or 0, sizes.yo or 0)
	end
end

function initToggles()
	setToggle("Anti Ragdoll", mainConfig.AntiRagdoll, true)
	setToggle("Auto Reset Balloon", mainConfig.AutoResetBalloon, true)
	setToggle("Infinite Jump", mainConfig.InfiniteJump, true)
	setToggle("Auto Kick", mainConfig.AutoKickOnSteal, true)
	setToggle("Auto Buy", false, true)
	setToggle("Auto Steal", mainConfig.AutoStealEnabled, true)
	setToggle("Steal Highest", mainConfig.StealHighest, true)
	setToggle("Steal Priority", mainConfig.StealPriority, true)
	setToggle("Steal Nearest", mainConfig.StealNearest, true)
	mainConfig.ClickToAP = false
	setToggle("Click to AP", mainConfig.ClickToAP, true)
	local tbl6 = {}
	setToggle("ClickToAP", mainConfig.ClickToAP, true)
	setToggle("Click AP Single Cmd", mainConfig.ClickToAPSingleCommand, true)
	setToggle("ClickToAPSingle", mainConfig.ClickToAPSingleCommand, true)
	setToggle("XRay", mainConfig.XRay, true)
	setToggle("X-Ray", mainConfig.XRay, true)
	setToggle("Xray", mainConfig.XRay, true)
	setToggle("FFlags", mainConfig.FFlagsEnabled == true, true)
	setToggle("FPS Optimizer", mainConfig.FpsOptimizer ~= false, true)
	setToggle("Proximity", mainConfig.ProximityAP, true)
	setToggle("Player ESP", mainConfig.PlayerESP, true)
	setToggle("Brainrot ESP", mainConfig.BrainrotESP, true)
	setToggle("Timer ESP", mainConfig.TimerESP, true)
	setToggle("Carpet ESP", mainConfig.CarpetESP, true)
	setToggle("Base Owner ESP", mainConfig.BaseOwnerESP, true)
	setToggle("Base Timer", mainConfig.BaseTimerUI ~= false, true)
	setToggle("Auto Destroy Turrets", mainConfig.AutoDestroyTurrets, true)
	setToggle("Anti-Bee & Anti-Disco", mainConfig.AntiBeeDisco, true)
	setToggle("AntiBeeDisco", mainConfig.AntiBeeDisco, true)
	setToggle("Admin Panel UI", mainConfig.AdminPanelUI, true)
	setToggle("Auto Invis During Steal", mainConfig.AutoInvisDuringSteal, true)
	setToggle("Invis Delay", mainConfig.InvisDelayEnabled == true, true)
	setToggle("Unwalk", mainConfig.Unwalk, true)
	setToggle("Stealing ESP", mainConfig.StealingESP, true)
	setToggle("Dark Mode", mainConfig.DarkMode, true)
	setToggle("DarkMode", mainConfig.DarkMode, true)
	setToggle("LED Bar", mainConfig.LEDBar, true)
	setToggle("Go To Brainrot Fly", mainConfig.TpSettings.GoToBrainrotNonInstant or false, true)
	setToggle("Go To Brainrot Instant", mainConfig.TpSettings.GoToBrainrotInstant or false, true)
end

loadConfig()

if mainConfig.StealMode ~= "Highest" and mainConfig.StealMode ~= "Priority" and mainConfig.StealMode ~= "Nearest" then
	if mainConfig.StealPriority then
		mainConfig.StealMode = "Priority"
	elseif mainConfig.StealNearest then
		mainConfig.StealMode = "Nearest"
	else
		mainConfig.StealMode = "Highest"
	end
end

if mainConfig.TpSettings.GoToBrainrotInstant == nil and mainConfig.TpSettings.GoToBrainrotNonInstant == nil then
	mainConfig.TpSettings.GoToBrainrotInstant = true
	mainConfig.TpSettings.GoToBrainrotNonInstant = false
end

brainrotESPEnabled = mainConfig.BrainrotESP
_G.antiSwapEnabled = mainConfig.AntiBodySwap == true

for k, v2 in pairs(mainConfig.keybinds or {}) do
	if Keybinds[k] ~= nil and type(v2) == "string" then
		Keybinds[k] = v2

		if k == "Open Menu" and Enum.KeyCode[v2] then
			UI.OpenMenuKey = Enum.KeyCode[v2]
		end
	end
end

for k, v2 in pairs(mainConfig.actions or {}) do
	if actionConfig[k] ~= nil then
		actionConfig[k] = v2 and true or false
	end
end

if type(mainConfig.locked) == "boolean" then
	UI.Locked = mainConfig.locked
end

initToggles()

UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end

	if _G._bindsRecording then
		return
	end
	local name = input.KeyCode.Name

	if Keybinds.Reset and Keybinds.Reset ~= "NONE" and name == Keybinds.Reset then
		pcall(executeReset)
	end
end)

if mainConfig.FFlagsEnabled then
	pcall(_G.BJK_ApplyFFlags)
end

if mainConfig.Unwalk then
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid2 = character:WaitForChild("Humanoid", 5)

		if humanoid2 then
			local animator = humanoid2:FindFirstChildOfClass("Animator")
			local animate = character:FindFirstChild("Animate")

			if animate then
				animate.Disabled = true
			end

			if animator then
				local ok, result = pcall(function()
					return animator:GetPlayingAnimationTracks()
				end)

				if ok and result then
					for i, v2 in ipairs(result) do
						pcall(function()
							v2:Stop(0)
						end)
					end
				end
			end
		end
	end)
end

ClothingClasses = ClothingClasses or {
	"Shirt",
	"Pants",
	"ShirtGraphic",
	"Accessory",
	"Hat",
	"HairAccessory",
	"FaceAccessory",
	"NeckAccessory",
	"ShoulderAccessory",
	"FrontAccessory",
	"BackAccessory",
	"WaistAccessory",
}

function IsClothing(arg)
	if not arg then
		return false
	end

	if arg:IsA("Clothing") or arg:IsA("ShirtGraphic") or arg:IsA("Accessory") then
		return true
	end

	for i, v2 in ipairs(ClothingClasses) do
		if arg:IsA(v2) then
			return true
		end
	end

	return false
end

local obj2 = setmetatable({}, { __mode = "k" })

local function fn4(arg)
	if not _G.AntiFlasherEnabled then
		return
	end

	if obj2[arg] then
		return
	end
	obj2[arg] = true

	for i, v2 in ipairs(arg:GetPlayingAnimationTracks()) do
		pcall(v2.Stop, v2, 0)
	end

	arg.AnimationPlayed:Connect(function(arg2)
		if _G.AntiFlasherEnabled then
			pcall(arg2.Stop, arg2, 0)
		end
	end)
end

function AntiFlasherHookCharacter(parent)
	if not parent then
		return
	end

	if not _G.AntiFlasherEnabled then
		return
	end
	local localPlayer3 = Players2.LocalPlayer
	if localPlayer3 and (parent == localPlayer3.Character or Players2:GetPlayerFromCharacter(parent) == localPlayer3) then
		return
	end
	local humanoid2 = parent:FindFirstChildOfClass("Humanoid")
	local animator = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

	if animator then
		fn4(animator)
	end

	if not parent:FindFirstChild("_BJK_AFHook") then
		local boolValue
		boolValue = Instance.new("BoolValue")
		boolValue.Name = "_BJK_AFHook"
		boolValue.Parent = parent

		parent.DescendantAdded:Connect(function(descendant)
			if _G.AntiFlasherEnabled and descendant:IsA("Animator") then
				fn4(descendant)
			end
		end)
	end
end

function AntiFlasherOnCharacter(arg)
	if not _G.AntiFlasherEnabled then
		return
	end

	if not arg then
		return
	end
	AntiFlasherHookCharacter(arg)
end

function AntiFlasherStrip(arg)
	AntiFlasherHookCharacter(arg)
end

function AntiFlasherStripAll()
	if not _G.AntiFlasherEnabled then
		return
	end
	local localPlayer3 = Players2.LocalPlayer

	for i, player_ in ipairs(Players2:GetPlayers()) do
		if player_ ~= localPlayer3 and player_.Character then
			pcall(AntiFlasherHookCharacter, player_.Character)
		end
	end

	for i, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("Model") and child ~= (localPlayer3 and localPlayer3.Character) and child:FindFirstChildOfClass("Humanoid") then
			pcall(AntiFlasherHookCharacter, child)
		end
	end
end

if not _G._AntiFlasherLoopStarted then
	_G._AntiFlasherLoopStarted = true

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end

			if _G.AntiFlasherEnabled then
				pcall(AntiFlasherStripAll)
			end

			task.wait(1.5)
		end
	end)
end

do
	local tbl6 = {}
	local v2
	local v3

	local function fn5()
		if v2 then
			return v2
		end

		local ok, result = pcall(function()
			return require(game:GetService("ReplicatedStorage"):WaitForChild("Packages", 4):WaitForChild("Synchronizer", 4))
		end)

		if ok then
			v2 = result
		end

		return v2
	end

	local function fn6(arg)
		return setmetatable({ _xenCT = arg }, {
			__index = function(arg2, arg3)
			if arg3 == "Get" then
				return function(arg4, arg5)
					local value = rawget(arg2, "_xenCT")
					return value and value[arg5]
				end
			end

			if arg3 == "GetTable" then
				return function()
					return rawget(arg2, "_xenCT")
				end
			end
			local value = rawget(arg2, "_xenCT")
			return value and value[arg3]
		end,
		})
	end

	local function fn7()
		local v4 = fn5()
		if not v4 or type(v4.GetAllChannels) ~= "function" then
			return
		end
		local getAllChannels = v4.GetAllChannels

		v4.GetAllChannels = function(...)
			local v5 = getAllChannels(...)

			if not v3 and type(v5) == "table" then
				v3 = v5
			end

			return v5
		end
	end

	fn7()

	_G.XenSyncAll = function()
		return v3 or tbl6
	end

	_G.XenSyncGet = function(arg)
		if arg == nil then
			return nil
		end

		if v3 then
			local value = rawget(v3, arg)
			if value and type(value) == "table" and type(value.Get) == "function" then
				return value
			end

			for k, v4 in pairs(v3) do
				if tostring(k) == arg and type(v4) == "table" and type(v4.Get) == "function" then
					return v4
				end
			end
		end

		if tbl6[arg] then
			return tbl6[arg]
		end
		local v4 = fn5()
		if not v4 or type(v4.GetTableFromChannel) ~= "function" then
			return nil
		end
		local ok, result = pcall(v4.GetTableFromChannel, v4, arg)

		if ok and type(result) == "table" then
			local v5 = fn6(result)
			tbl6[arg] = v5
			return v5
		end

		return nil
	end

	_G._xenRefresh = function(arg)
		local v4 = fn5()
		if not v4 or type(v4.GetTableFromChannel) ~= "function" then
			return tbl6[arg]
		end
		local ok, result = pcall(v4.GetTableFromChannel, v4, arg)

		if ok and type(result) == "table" then
			local v5 = tbl6[arg]
			if v5 then
				rawset(v5, "_xenCT", result)
				return v5
			end
			v5 = fn6(result)
			tbl6[arg] = v5
			return v5
		end

		tbl6[arg] = nil
		return nil
	end

	_G._xenDropCache = function(arg)
		tbl6[arg] = nil
	end

	_G._xenRawCT = function(arg)
		local v4 = _G.XenSyncGet(arg)
		if not v4 then
			return nil
		end

		if type(v4.GetTable) == "function" then
			local ok, result = pcall(v4.GetTable, v4)
			if ok then
				return result
			end
		end

		return nil
	end

	local Animals, Mutations, Traits
	local fn8

	fn8 = function()
		if Animals then
			return true
		end

		local ok = pcall(function()
			local datas = game:GetService("ReplicatedStorage"):WaitForChild("Datas", 10)
			Animals = require(datas:WaitForChild("Animals"))
			Mutations = require(datas:WaitForChild("Mutations"))
			Traits = require(datas:WaitForChild("Traits"))
		end)

		return ok and Animals ~= nil
	end

	_G._xenGen = function(arg, arg2, arg3)
		if not fn8() then
			return 0
		end
		local v4 = Animals[arg]
		if not v4 or not v4.Generation then
			return 0
		end
		local n = 1

		if arg2 and arg2 ~= "None" and arg2 ~= "" then
			local v5 = Mutations[arg2]

			if v5 and v5.Modifier then
				n = n + v5.Modifier
			end
		end

		if arg3 then
			if type(arg3) == "string" and arg3 ~= "None" then
				for match in arg3:gmatch("[^, ]+") do
					local v5 = Traits[match]

					if v5 and v5.MultiplierModifier then
						n = n + v5.MultiplierModifier
					end
				end
			elseif type(arg3) == "table" then
				for i, v5 in ipairs(arg3) do
					local v6 = Traits[v5]

					if v6 and v6.MultiplierModifier then
						n = n + v6.MultiplierModifier
					end
				end
			end
		end

		return v4.Generation * n
	end

	_G._xenAnimShim = setmetatable({
		GetGeneration = function(arg, arg2, arg3, arg4)
		return _G._xenGen(arg2, arg3, arg4)
	end,
	}, {
		__index = function(arg, arg2)
		local ok, result = pcall(function()
			return require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))
		end)

		if ok and type(result) == "table" then
			return rawget(result, arg2)
		end
		return nil
	end,
	})
end

_G.stealthGet = function(arg)
	return _G.XenSyncGet(arg)
end

_G.SyncInt = { _cache = {}, _data = nil }

do
	local ReplicatedStorage_ = game:GetService("ReplicatedStorage")
	local net = ReplicatedStorage_:WaitForChild("Packages"):WaitForChild("Net")
	local getupvalues_ = debug.getupvalues or getupvalues
	local getinfo_ = debug.getinfo or getinfo
	local v2, v3, v4

	local function fn5(arg)
		return type(arg) == "string" and #arg == 36 and arg:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
	end

	local fn6, fn7

	fn6 = function()
		if v2 and v4 then
			return true
		end
		local v5, v6
		local tbl6, tbl7 = {}, {}

		for k, v7 in getgc(true) do
			if typeof(v7) == "function" then
				local ok, result = pcall(getinfo_, v7)

				if ok and result and result.source == "=ReplicatedStorage.Packages.Net.Net" then
					local ok2, result2 = pcall(getupvalues_, v7)

					if ok2 and result2 then
						for k2, v8 in pairs(result2) do
							if type(v8) == "table" then
								local value, value2, value3 = rawget(v8, 1), rawget(v8, 2), rawget(v8, 3)

								if not v5 and type(value) == "function" and type(value2) == "function" and type(value3) == "string" then
									v5, v6 = clonefunction(value), clonefunction(value2)
								end

								for k3, v9 in pairs(v8) do
									if fn5(v9) and v9 ~= game.JobId and not tbl7[v9] then
										tbl7[v9] = true
										tbl6[#tbl6 + 1] = v9
									end
								end
							elseif fn5(v8) and v8 ~= game.JobId and not tbl7[v8] then
								tbl7[v8] = true
								tbl6[#tbl6 + 1] = v8
							end
						end
					end
				end
			end
		end

		if not v5 then
			return false
		end
		v2, v3 = v5, v6
		local UseItem = v3("UseItem", game.JobId)
		if #tbl6 == 1 then
			v4 = tbl6[1]
			return true
		end

		for i, v7 in ipairs(tbl6) do
			local ok, result = pcall(function()
				return v2(buffer.fromstring(UseItem), buffer.fromstring(v7 .. game.JobId))
			end)

			if ok and type(result) == "string" and net:FindFirstChild("RE/" .. result) then
				v4 = v7
				return true
			end
		end

		return false
	end

	fn7 = function(arg, arg2)
		if not (v2 and v4) and not fn6() then
			return nil
		end

		local ok, result = pcall(function()
			local v5 = v3(arg2, game.JobId)
			return v2(buffer.fromstring(v5), buffer.fromstring(v4 .. game.JobId))
		end)

		if not ok or type(result) ~= "string" then
			return nil
		end
		return net:FindFirstChild(arg .. "/" .. result)
	end

	_G.Net = {
		RemoteEvent = function(arg, arg2)
		return fn7("RE", arg2)
	end,
		RemoteFunction = function(arg, arg2)
		return fn7("RF", arg2)
	end,
		UnreliableRemoteEvent = function(arg, arg2)
		return fn7("URE", arg2)
	end,
	}

	_G.XenNet = _G.Net
end

Decrypted = setmetatable({}, {
	__index = function(arg, arg2)
	if type(arg2) ~= "string" or not _G.Net then
		return nil
	end
	local match, v2 = arg2:match("^(R[EF])/(.+)$")
	if not match then
		return nil
	end

	local ok, result = pcall(function()
		if match == "RF" then
			return _G.Net:RemoteFunction(v2)
		end
		return _G.Net:RemoteEvent(v2)
	end)

	if ok and result then
		rawset(Decrypted, arg2, result)
	end

	return ok and result or nil
end,
})

ACTION_COOLDOWNS = {
	ragdoll = 30,
	jail = 60,
	rocket = 120,
	balloon = 30,
	inverse = 30,
	jumpscare = 30,
	tiny = 30,
	morph = 30,
}

lastActionUse = {}

_readRealAdminTimer = function(arg)
	local adminPanel = playerGui:FindFirstChild("AdminPanel")
	if not adminPanel then
		return nil
	end

	local ok, result = pcall(function()
		return adminPanel.AdminPanel.Content.ScrollingFrame
	end)

	if not ok or not result then
		return nil
	end
	local v2 = result:FindFirstChild(arg)
	if not v2 then
		return nil
	end
	local timer = v2:FindFirstChild("Timer")
	if not timer or not timer.Visible then
		return 0
	end
	local num = tonumber(timer.Text:match("%d+"))
	return num or 0
end

apIsOnCooldown = function(arg)
	local v2 = _readRealAdminTimer(arg)
	if v2 ~= nil then
		return v2 > 0
	end
	local v3 = lastActionUse[arg]
	local n = ACTION_COOLDOWNS[arg] or 0
	return v3 and n > 0 and os.clock() - v3 < n
end

apGetRemaining = function(arg)
	local v2 = _readRealAdminTimer(arg)
	if v2 ~= nil then
		return v2
	end
	local v3 = lastActionUse[arg]
	local n = ACTION_COOLDOWNS[arg] or 0
	if not v3 then
		return 0
	end
	return math.max(0, n - (os.clock() - v3))
end

function apStartCooldown(arg)
	lastActionUse[arg] = os.clock()
end

AP_ALL_COMMANDS = {
	"balloon",
	"inverse",
	"jail",
	"jumpscare",
	"morph",
	"ragdoll",
	"rocket",
	"tiny",
}

AP_COMMAND_EMOJIS = {
	balloon = "🎈",
	inverse = "🔄",
	jail = "🔒",
	jumpscare = "👻",
	morph = "🎭",
	ragdoll = "🤸",
	rocket = "🚀",
	tiny = "🐜",
}

if not mainConfig.ClickToAPCommands then
	mainConfig.ClickToAPCommands = {}

	for i, v2 in ipairs(AP_ALL_COMMANDS) do
		mainConfig.ClickToAPCommands[v2] = true
	end
end

if not mainConfig.AdminPanelButtons then
	mainConfig.AdminPanelButtons = { ragdoll = true, jail = true, rocket = true, balloon = true }
end

if not mainConfig.ClickToAPRadius then
	mainConfig.ClickToAPRadius = 8
end

if not mainConfig.SpamBaseOwnerCommands then
	mainConfig.SpamBaseOwnerCommands = {}

	for i, v2 in ipairs(AP_ALL_COMMANDS) do
		mainConfig.SpamBaseOwnerCommands[v2] = true
	end
end

if not mainConfig.SpamBaseOwnerOrder then
	mainConfig.SpamBaseOwnerOrder = {}

	for i, v2 in ipairs(AP_ALL_COMMANDS) do
		mainConfig.SpamBaseOwnerOrder[i] = v2
	end
end

do
	local tbl6 = {}

	for i, v2 in ipairs(AP_ALL_COMMANDS) do
		tbl6[v2] = true
	end

	for i, v2 in ipairs({ "SpamBaseOwnerCommands", "ClickToAPCommands", "AdminPanelButtons" }) do
		local v3 = mainConfig[v2]

		if type(v3) == "table" then
			for k in pairs(v3) do
				if not tbl6[k] then
					v3[k] = nil
				end
			end
		end
	end

	for i, v2 in ipairs({ "SpamBaseOwnerOrder", "ClickToAPOrder", "AdminPanelOrder" }) do
		local v3 = mainConfig[v2]

		if type(v3) == "table" then
			local tbl7 = {}

			for i2, v4 in ipairs(v3) do
				if tbl6[v4] then
					tbl7[#tbl7 + 1] = v4
				end
			end

			mainConfig[v2] = tbl7
		end
	end
end

if mainConfig.SpamBaseOwnerSingleCommand == nil then
	mainConfig.SpamBaseOwnerSingleCommand = false
end

setToggle("SpamBaseOwnerSingleCommand", mainConfig.SpamBaseOwnerSingleCommand or false)
_G.apBlacklist = mainConfig.apBlacklist or {}

function isPlayerBlacklisted(arg)
	if not arg then
		return false
	end
	local userId = arg.UserId
	return _G.apBlacklist[userId] == true or _G.apBlacklist[tostring(userId)] == true
end

do
	local v2

	function _G.__getSync()
		if v2 then
			return v2
		end

		local ok, result = pcall(function()
			local packages = ReplicatedStorage:FindFirstChild("Packages")
			return packages and require(packages:WaitForChild("Synchronizer", 2))
		end)

		if ok then
			v2 = result
		end

		return v2
	end
end

getPlotOwner = function(arg)
	if not arg then
		return nil
	end
	local v2 = _G.__getSync()

	if v2 then
		local v3 = _G.XenSyncGet(arg.Name)

		if v3 then
			local Owner = v3:Get("Owner")

			if Owner then
				if typeof(Owner) == "Instance" and Owner:IsA("Player") then
					return Owner
				elseif type(Owner) == "table" and Owner.Name then
					return Players2:FindFirstChild(Owner.Name)
				elseif type(Owner) == "number" then
					return Players2:GetPlayerByUserId(Owner)
				end
			end
		end
	end

	local plotSign = arg:FindFirstChild("PlotSign")
	local textLabel = plotSign and plotSign:FindFirstChild("SurfaceGui") and plotSign.SurfaceGui:FindFirstChild("Frame") and plotSign.SurfaceGui.Frame:FindFirstChild("TextLabel")

	if textLabel then
		local text = textLabel.Text
		local match = text and text:match("^(.-)'") or text

		if match then
			for i, player_ in ipairs(Players2:GetPlayers()) do
				if player_.DisplayName == match or player_.Name == match then
					return player_
				end
			end
		end
	end

	return nil
end

getPlotAtPosition = function(arg)
	local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
	if not plotsFolder then
		return nil
	end
	local v2 = nil
	local huge = math.huge

	for i, child in ipairs(plotsFolder:GetChildren()) do
		local position

		if child:IsA("Model") then
			position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
		else
			position = child.Position
		end

		if position then
			local v3 = math.sqrt((arg.X - position.X) ^ 2 + (arg.Z - position.Z) ^ 2)

			if v3 < huge then
				huge = v3
				v2 = child
			end
		end
	end

	if v2 and huge < 40 then
		return v2
	end
	return nil
end

getPlayerBaseInfo = function(arg)
	if not arg or not arg.Character then
		return nil, nil
	end
	local humanoidRootPart2 = arg.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart2 then
		return nil, nil
	end
	local v2 = getPlotAtPosition(humanoidRootPart2.Position)
	if v2 then
		return v2, getPlotOwner(v2)
	end
	return nil, nil
end

do
	local userId, n = nil, 0

	function _G.__getCurrentBaseOwnerId()
		local now = os.clock()
		if now - n < 0.4 then
			return userId
		end
		n = now
		userId = nil
		local v2, v3 = getPlayerBaseInfo(localPlayer2)

		if v3 then
			userId = v3.UserId
		end

		return userId
	end
end

_BJKMorphCache = _BJKMorphCache or {}
_BJKStealSession = _BJKStealSession or {}

Players2.PlayerRemoving:Connect(function(player_)
	_BJKMorphCache[player_.UserId] = nil
	_BJKStealSession[player_.UserId] = nil
end)

function getStealingInfo(arg)
	if not arg or not arg.Character then
		return nil, nil
	end
	local humanoidRootPart2 = arg.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart2 then
		return nil, nil
	end

	pcall(function()
		if not _BJKAnimalsData then
			local datas = ReplicatedStorage:FindFirstChild("Datas")
			_BJKAnimalsData = datas and require(datas:FindFirstChild("Animals"))
		end

		if _BJKAnimalsData and not _BJKAnimalNames then
			_BJKAnimalNames = {}

			for k, v2 in pairs(_BJKAnimalsData) do
				local displayName = type(v2) == "table" and v2.DisplayName or tostring(k)
				_BJKAnimalNames[tostring(k):lower()] = displayName
				_BJKAnimalNames[tostring(displayName):lower()] = displayName
			end
		end
	end)

	if arg:GetAttribute("Stealing") ~= true then
		_BJKStealSession[arg.UserId] = nil
		local v2 = _BJKMorphCache[arg.UserId]

		if _BJKAnimalNames and (not v2 or os.clock() - v2.t > 1) then
			local tbl6
			tbl6 = {}

			pcall(function()
				for i, descendant in ipairs(arg.Character:GetDescendants()) do
					if (descendant:IsA("Model") or descendant:IsA("MeshPart")) and _BJKAnimalNames[descendant.Name:lower()] then
						tbl6[descendant.Name:lower()] = true
					end
				end
			end)

			_BJKMorphCache[arg.UserId] = { t = os.clock(), names = tbl6 }
		end

		return nil, nil
	end

	local tbl6 = _BJKStealSession[arg.UserId]

	if type(tbl6) == "string" then
		tbl6 = { name = tbl6, locked = true }
		_BJKStealSession[arg.UserId] = tbl6
	end

	if tbl6 and tbl6.locked then
		return tbl6.owner, tbl6.name
	end
	local attribute = arg:GetAttribute("StealingIndex")

	if attribute ~= nil and tostring(attribute) ~= "" then
		local str = tostring(attribute)

		if _BJKAnimalNames then
			str = _BJKAnimalNames[str:lower()] or str
		end

		local owner = tbl6 and tbl6.owner or nil
		_BJKStealSession[arg.UserId] = { name = str, owner = owner, locked = true }
		return owner, str
	end

	local names = _BJKMorphCache[arg.UserId] and _BJKMorphCache[arg.UserId].names
	local v2

	pcall(function()
		if _BJKAnimalNames then
			for i, descendant in ipairs(arg.Character:GetDescendants()) do
				if descendant:IsA("Model") or descendant:IsA("MeshPart") then
					local str = descendant.Name:lower()
					local v3 = _BJKAnimalNames[str]
					if v3 and not (names and names[str]) then
						v2 = v3
						return
					end
				end
			end
		end
	end)

	if v2 then
		local owner = tbl6 and tbl6.owner or nil
		_BJKStealSession[arg.UserId] = { name = v2, owner = owner, locked = true }
		return owner, v2
	end

	if tbl6 and tbl6.t and os.clock() - tbl6.t < 0.4 then
		return tbl6.owner, tbl6.name
	end
	local flag = false
	local humanoid2 = arg.Character:FindFirstChildOfClass("Humanoid")
	local animator = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

	if animator then
		pcall(function()
			for i, v3 in ipairs(animator:GetPlayingAnimationTracks()) do
				local animationId = v3.Animation and v3.Animation.AnimationId
				if animationId and (animationId:find("18537363391") or animationId:find("steal") or animationId:find("grab")) then
					flag = true
					break
				end
			end
		end)
	end

	local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")

	if plotsFolder then
		local n = flag and 12 or 4.5
		local v3

		pcall(function()
			v3 = _G.__getSync()
		end)

		local v4, v5, v6 = nil, nil, n
		local v7, v8 = nil, n

		for i, child in ipairs(plotsFolder:GetChildren()) do
			local v9 = getPlotOwner(child)
			if v9 == arg then
				continue
			end
			local animalPodiums = child:FindFirstChild("AnimalPodiums")

			if animalPodiums then
				local AnimalList

				pcall(function()
					local v10 = v3 and _G.XenSyncGet(child.Name)
					AnimalList = v10 and v10:Get("AnimalList")
				end)

				for i2, child2 in ipairs(animalPodiums:GetChildren()) do
					local base = child2:FindFirstChild("Base")
					local spawn = base and base:FindFirstChild("Spawn")

					if spawn then
						local magnitude = (humanoidRootPart2.Position - spawn.Position).Magnitude
						local v10 = AnimalList and (AnimalList[child2.Name] or AnimalList[tonumber(child2.Name)])

						if v10 and type(v10) == "table" and v10.Index then
							if magnitude < v6 then
								local str = tostring(v10.Index)

								pcall(function()
									if _BJKAnimalNames then
										str = _BJKAnimalNames[str:lower()] or str
									end
								end)

								v6 = magnitude
								v4 = v9
								v5 = str
							end
						elseif magnitude < v8 then
							v8 = magnitude
							v7 = v9
						end
					end
				end
			end
		end

		if v4 and (not v7 or v6 <= v8) then
			_BJKStealSession[arg.UserId] = { name = v5, owner = v4, locked = false, t = os.clock() }
			return v4, v5
		end

		if v7 then
			local name = tbl6 and tbl6.name or "Brainrot"
			_BJKStealSession[arg.UserId] = { name = name, owner = v7, locked = false, t = os.clock() }
			return v7, name
		end
	end

	if tbl6 and tbl6.name then
		return tbl6.owner, tbl6.name
	end
	return nil, "Brainrot"
end

function _G.getStolenOwnerKeys(arg)
	local tbl6 = {}

	if typeof(arg) == "Instance" then
		if arg.Name then
			tbl6[tostring(arg.Name):lower()] = true
		end

		if arg.DisplayName then
			tbl6[tostring(arg.DisplayName):lower()] = true
		end
	elseif type(arg) == "table" then
		if arg.Name then
			tbl6[tostring(arg.Name):lower()] = true
		end
	elseif type(arg) == "string" then
		tbl6[tostring(arg):lower()] = true
	end

	return tbl6
end

_G.__BJKBootClock = _G.__BJKBootClock or os.clock()

task.spawn(function()
	while true do
		if _G.BJK_HubGen ~= bjkHubGen then
			break
		end
		task.wait(1)
		if _G.TpOnLoadRunning then
			continue
		end

		if _G._isTpMoving or os.clock() - _G.__BJKBootClock < 2 then
			continue
		end

		for i, player_ in ipairs(Players2:GetPlayers()) do
			if player_ ~= localPlayer2 and player_:GetAttribute("Stealing") ~= true then
				pcall(getStealingInfo, player_)
			end
		end
	end
end)

isOurOverheadBillboard = function(arg)
	if not arg or not arg.Name then
		return true
	end
	local name = arg.Name
	if name:find("^PlayerESP_") or name:find("^BrainrotESP_") or name:find("PlotBeam") then
		return true
	end

	if name == "Overhead" or name == "StealProgressBar" or name == "BJK_AdminPanel" then
		return true
	end
	return false
end

_BJKJTCache = _BJKJTCache or {}

getPlayerJoinerTag = function(arg)
	if not arg or not arg.Character then
		return nil
	end
	local v2 = _BJKJTCache[arg.UserId]
	if v2 and os.clock() - v2.t < 3 then
		return v2.tag or nil
	end
	local tbl6, tbl7, fn5, fn6, fn7, str
	tbl6, tbl7 = {}, {}

	fn5 = function(arg2)
		if not arg2 or type(arg2) ~= "string" then
			return
		end
		arg2 = arg2:gsub("^%s+", ""):gsub("%s+$", "")
		if arg2 == "" or #arg2 > 64 then
			return
		end

		if arg2 == arg.Name or arg2 == arg.DisplayName then
			return
		end
		local str2 = arg2:lower()
		if tbl7[str2] then
			return
		end
		tbl7[str2] = true
		table.insert(tbl6, arg2)
	end

	fn6 = function(arg2)
		if not arg2:IsA("BillboardGui") or not arg2.Enabled then
			return
		end

		if isOurOverheadBillboard(arg2) then
			return
		end

		for i, descendant in ipairs(arg2:GetDescendants()) do
			if (descendant:IsA("TextLabel") or descendant:IsA("TextBox")) and descendant.Visible ~= false then
				fn5(descendant.Text)
			end
		end
	end

	for i, descendant in ipairs(arg.Character:GetDescendants()) do
		if descendant:IsA("BillboardGui") then
			fn6(descendant)
		end
	end

	fn7 = function(arg2)
		if not arg2 then
			return
		end

		for i, descendant in ipairs(arg2:GetDescendants()) do
			if descendant:IsA("BillboardGui") and descendant.Adornee and arg.Character and descendant.Adornee:IsDescendantOf(arg.Character) then
				fn6(descendant)
			end
		end
	end

	pcall(function()
		fn7(playerGui)
	end)

	pcall(function()
		fn7(typeof(gethui) == "function" and gethui() or game:GetService("CoreGui"))
	end)

	pcall(function()
		for k, v3 in pairs(arg:GetAttributes()) do
			if typeof(v3) == "string" and #v3 > 0 and #v3 <= 40 then
				local str2 = k:lower()

				if str2:find("hub") or str2:find("script") or str2:find("joiner") or str2:find("executor") or str2:find("tag") then
					fn5(v3)
				end
			end
		end
	end)

	str = #tbl6 > 0 and table.concat(tbl6, " \194\183 ") or nil
	_BJKJTCache[arg.UserId] = { t = os.clock(), tag = str or false }
	return str
end

_G.getPlayerJoinerTag = getPlayerJoinerTag

HUB_BADGES = {
	{
	pats = { "bad boy" },
	badge = "[ BAD BOY ]",
	color = Color3.fromRGB(255, 60, 60),
	allowAP = true,
},
	{
	pats = { "good boy", "fmly" },
	namePat = "fmly",
	badge = "[ FMLY User ]",
	color = Color3.fromRGB(255, 220, 60),
},
	{
	pats = { "bt user", "bt hub", "bt " },
	badge = "[ BT User ]",
	color = Color3.fromRGB(170, 80, 255),
},
	{
	pats = { "w user", "wuser", "w hub", "notifier", "wblox", "w /" },
	badge = "[ W User ]",
	color = Color3.fromRGB(255, 220, 60),
},
}

_BJKHubCache = _BJKHubCache or {}

getHubUserBadge = function(arg)
	local v2 = getPlayerJoinerTag(arg)
	local str = (v2 or ""):lower()
	local str2 = ((arg.Name or "") .. " " .. (arg.DisplayName or "")):lower()
	local tbl6 = _BJKHubCache[arg.UserId]

	if not tbl6 then
		tbl6 = {}
		_BJKHubCache[arg.UserId] = tbl6
	end

	for i, v3 in ipairs(HUB_BADGES) do
		if not tbl6[i] then
			for i2, pat in ipairs(v3.pats) do
				if str:find(pat, 1, true) then
					tbl6[i] = true
					break
				end
			end

			if not tbl6[i] and v3.namePat and str2:find(v3.namePat, 1, true) then
				tbl6[i] = true
			end
		end
	end

	local tbl7 = {}
	local v3 = tbl6[1]

	for i, v4 in ipairs(HUB_BADGES) do
		if tbl6[i] then
			if not (v3 and v4.badge == "[ FMLY User ]") then
				tbl7[#tbl7 + 1] = v4
			end
		end
	end

	if #tbl7 == 0 then
		return nil, nil, v2, nil
	end
	return tbl7[1].badge, tbl7[1].color, v2, tbl7
end

_G.getHubUserBadge = getHubUserBadge

Players2.PlayerRemoving:Connect(function(player_)
	_BJKHubCache[player_.UserId] = nil
end)

fireClick = function(arg)
	if not arg then
		return false
	end

	local ok = pcall(function()
		if typeof(firesignal) == "function" then
			pcall(firesignal, arg.MouseButton1Click)
			pcall(firesignal, arg.MouseButton1Down)
			pcall(firesignal, arg.MouseButton1Up)
			pcall(firesignal, arg.Activated)
		end
	end)

	return ok
end

_G.fireClick = fireClick

function runAdminCommand(arg, arg2)
	pcall(function()
		if arg == localPlayer2 then
			_G.__BJKSelfCmdT = os.clock()
		end
	end)

	if not arg or not arg2 or arg2 == "" then
		return false
	end
	local adminPanel = playerGui:FindFirstChild("AdminPanel")

	if not adminPanel then
		adminPanel = playerGui:WaitForChild("AdminPanel", 3)
	end

	if not adminPanel then
		return false
	end
	local enabled = adminPanel.Enabled
	adminPanel.Enabled = true

	local ok, result = pcall(function()
		return adminPanel.AdminPanel.Content.ScrollingFrame
	end)

	if not ok or not result then
		adminPanel.Enabled = enabled
		return false
	end
	local v2 = result:FindFirstChild(arg2)
	if not v2 then
		adminPanel.Enabled = enabled
		return false
	end
	fireClick(v2)
	task.wait(0.01)

	local ok2, result2 = pcall(function()
		return adminPanel.AdminPanel.Profiles.ScrollingFrame
	end)

	if not ok2 or not result2 then
		adminPanel.Enabled = enabled
		return false
	end
	local v3 = result2:FindFirstChild(arg.Name)

	if not v3 then
		task.wait(0.01)
		v3 = result2:FindFirstChild(arg.Name)
	end

	if not v3 then
		for i, child in ipairs(result2:GetChildren()) do
			if child:IsA("GuiButton") then
				local textLabel = child:FindFirstChildWhichIsA("TextLabel")
				if textLabel and (textLabel.Text == arg.Name or textLabel.Text == arg.DisplayName) then
					v3 = child
					break
				end
			end
		end
	end

	if not v3 then
		adminPanel.Enabled = enabled
		return false
	end
	fireClick(v3)
	apStartCooldown(arg2)

	task.delay(0.05, function()
		if adminPanel and adminPanel.Parent then
			adminPanel.Enabled = enabled
		end
	end)

	return true
end

_G.runAdminCommand = runAdminCommand

runAutoBaseActions = function()
	task.spawn(function()
		task.wait(1.5)
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart2 = character:WaitForChild("HumanoidRootPart", 10)
		if not humanoidRootPart2 then
			return
		end
		local v2 = nil
		local huge = math.huge
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")

		if plotsFolder then
			for i, child in ipairs(plotsFolder:GetChildren()) do
				local v3 = getPlotOwner(child)

				if v3 and v3 ~= player then
					local plotSign = child:FindFirstChild("PlotSign")

					if plotSign then
						local position = plotSign:IsA("BasePart") and plotSign.Position or plotSign.PrimaryPart and plotSign.PrimaryPart.Position

						if position then
							local magnitude = (humanoidRootPart2.Position - position).Magnitude

							if magnitude < huge then
								huge = magnitude
								v2 = v3
							end
						end
					end
				end
			end
		end

		if v2 then
		end
	end)
end

_G.runAutoBaseActions = runAutoBaseActions

isMobyUser = function(arg)
	return arg and arg.Character and arg.Character:FindFirstChild("_moby_highlight") ~= nil
end

isKawaifuUser = function(arg)
	return arg and arg.Character and arg.Character:FindFirstChild("KaWaifu_NeonHighlight") ~= nil
end

getNextAvailableCommand = function()
	local tbl6 = { "ragdoll", "balloon", "rocket", "jail" }

	for i, v2 in ipairs(tbl6) do
		if not apIsOnCooldown(v2) then
			return v2
		end
	end

	for i, v2 in ipairs(AP_ALL_COMMANDS) do
		if not apIsOnCooldown(v2) then
			return v2
		end
	end

	return nil
end

kickPlayer = function(arg)
	local flag = false

	if arg and type(arg) == "string" then
		flag = true
	end

	if flag then
		local now = os.clock()
		if now - (_G.BJK_LastKickAt or 0) < 5 then
			return
		end
		_G.BJK_LastKickAt = now

	end

	if mainConfig.KickToPrivateServer and PrivateServerCode and PrivateServerCode ~= "" and flag then
		pcall(function()
			local ExperienceService = game:GetService("ExperienceService")
			ExperienceService:LaunchExperience({ placeId = game.PlaceId, linkCode = PrivateServerCode })
		end)

		return
	end

	pcall(function()
		game:Shutdown()
	end)

	pcall(function()
		localPlayer2:Kick("\nBJK")
	end)
end

SharedState = {
	SelectedPetData = nil,
	AllAnimalsCache = {},
	ListNeedsRedraw = true,
	InitialScanComplete = false,
	seenUIDs = {},
	BrainrotNames = {},
}

ShowNotification = function(arg, arg2)
	return
end

do
	local Players3 = game:GetService("Players")
	local RunService_ = game:GetService("RunService")
	local localPlayer3, flag
	ReplicatedStorage = game:GetService("ReplicatedStorage")
	Workspace = game:GetService("Workspace")
	StarterGui = game:GetService("StarterGui")
	UserInputService = game:GetService("UserInputService")
	localPlayer3 = Players3.LocalPlayer
	flag = false

	_G.NotifyLocalTeleport = function(arg)
		local n
		n = arg or 0.5
		flag = true

		task.delay(n, function()
			flag = false
		end)
	end

	shared.NotifyLocalTeleport = _G.NotifyLocalTeleport

	task.spawn(function()
		local function fn5(parent)
			local attachment = parent:FindFirstChildOfClass("Attachment")

			if not attachment then
				attachment = Instance.new("Attachment")
				attachment.Name = "Attachment"
				attachment.Parent = parent
			end

			if not parent:FindFirstChild("Beam") then
				local beam = Instance.new("Beam")
				beam.Name = "Beam"
				beam.Enabled = false
				beam.Attachment0 = attachment
				beam.Attachment1 = attachment
				beam.Parent = parent
			end
		end

		local function fn6(parent)
			if not parent or not parent.Parent or not parent:IsA("Model") then
				return
			end

			for i, v2 in ipairs({ "Start", "End" }) do
				local part = parent:FindFirstChild(v2)

				if not part then
					part = Instance.new("Part")
					part.Name = v2
					part.Size = Vector3.new(0.1, 0.1, 0.1)
					part.Transparency = 1
					part.Anchored = true
					part.CanCollide = false

					pcall(function()
						part.CanQuery = false
						part.CanTouch = false
					end)

					pcall(function()
						part.CFrame = parent:GetPivot()
					end)

					part.Parent = parent
				end

				if part:IsA("BasePart") then
					pcall(fn5, part)
				end
			end
		end

		local function fn7(child)
			if child.Name ~= "TutorialArrow" or not child:IsA("Model") then
				return
			end
			fn6(child)

			child.ChildRemoved:Connect(function()
				task.defer(fn6, child)
			end)

			child.DescendantRemoving:Connect(function()
				task.defer(fn6, child)
			end)
		end

		local tutorialArrow = Workspace:FindFirstChild("TutorialArrow")

		if tutorialArrow then
			fn7(tutorialArrow)
		end

		Workspace.ChildAdded:Connect(fn7)
		local flag2 = false

		local function fn8()
			if flag2 then
				return
			end

			if not (getconnections and getinfo) then
				return
			end
			flag2 = true
			local RunService_2 = game:GetService("RunService")

			for i, v2 in ipairs({ RunService_2.RenderStepped, RunService_2.Heartbeat, RunService_2.Stepped }) do
				pcall(function()
					for i2, v3 in ipairs(getconnections(v2)) do
						local function_ = v3.Function

						if function_ and v3.Enabled then
							local ok, result = pcall(getinfo, function_)

							if ok and result and tostring(result.source):find("FTUEController") then
								pcall(function()
									v3:Disable()
								end)
							end
						end
					end
				end)
			end
		end

		pcall(function()
			game:GetService("LogService").MessageOut:Connect(function(arg, arg2)
				if arg2 == Enum.MessageType.MessageError and tostring(arg):find("TutorialArrow", 1, true) then
					task.defer(fn8)
				end
			end)
		end)
	end)

	SAB_LIVE = SAB_LIVE or function()
		return true
	end

	BJKInstantReset = (function()
		if _G.BJKResetCleanup then
			pcall(_G.BJKResetCleanup)
		end

		local n = 0
		local flag2 = false
		local flag3, fn5, fn6
		flag3 = true

		fn5 = function()
			flag2 = false
			_G.bjkInstaResetting = false
		end

		fn6 = function()
			if not flag3 then
				return false
			end

			if not SAB_LIVE() then
				return false
			end

			pcall(function()
				if mainConfig and mainConfig.AutoBuyEnabled then
					mainConfig.AutoBuyEnabled = false
				end

				if _G.BJK_SaveConfig then
					_G.BJK_SaveConfig()
				end

				if _G.BJK_ToggleAutoBuy then
					_G.BJK_ToggleAutoBuy(false, true)
				end

				pcall(saveConfig)

				if toggleAutoBuy then
					pcall(toggleAutoBuy, false)
				elseif _G.toggleAutoBuy then
					pcall(_G.toggleAutoBuy, false)
				end

				local tbl6 = {}
				pcall(setToggle, "Auto Buy", false)

				pcall(function()
					if autoBuyActive ~= nil then
						autoBuyActive = false
					end
				end)

				pcall(function()
					if destroyAutoBuyRing then
						destroyAutoBuyRing()
					end
				end)

				pcall(function()
					local bjkAutoBuyRing = Workspace:FindFirstChild("BJK_AutoBuyRing")

					if bjkAutoBuyRing then
						bjkAutoBuyRing:Destroy()
					end
				end)
			end)

			_G._bjkCancelTP = true
			_G.BJK_CancelTp = true
			_G.RecoveryInProgress = false
			_G._bjkLagbackRecoveryGen = (_G._bjkLagbackRecoveryGen or 0) + 1
			_G.BJK_DropFlingActive = true
			_G.__resetAntiLaunch = _G.BJK_AntiLaunch
			_G.BJK_AntiLaunch = false
			_G.__resetHpShield = _G.BJK_HpShield
			_G.BJK_HpShield = false
			local v2 = localPlayer3
			_G.__resetAutoInvis = _G.AutoInvisDuringSteal
			_G.AutoInvisDuringSteal = false
			local flag4, resetDono, fn7
			_G.invisAutoActive = false
			flag4 = _G.invisibleStealEnabled == true or _G.TacoInvisActive == true

			pcall(function()
				if _G.TacoInvisStop then
					_G.TacoInvisStop()
				end
			end)

			pcall(function()
				if (_G.invisibleStealEnabled == true or _G.TacoInvisActive == true) and _G.toggleInvisibleSteal then
					_G.toggleInvisibleSteal()
				end
			end)

			if flag4 then
				local now = os.clock()

				while os.clock() - now < 2 do
					if _G.TacoInvisActive ~= true and _G.invisibleStealEnabled ~= true then
						break
					end
					task.wait(0.05)
				end

				task.wait(0.3)
			end

			local character = v2 and v2.Character

			pcall(function()
				if character then
					local humanoid2 = character:FindFirstChildOfClass("Humanoid")

					if humanoid2 then
						for i, child in ipairs(character:GetChildren()) do
							if child:IsA("Tool") and child.Parent == character then
								humanoid2:UnequipTools()
								break
							end
						end
					end
				end
			end)

			if flag2 then
				return true
			end

			if tick() - n < 1.5 then
				return true
			end
			local character2 = v2 and v2.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")

			if flag4 then
				pcall(function()
					if humanoid2 then
						humanoid2:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
						local tbl6 = {}
						humanoid2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
						humanoid2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
						humanoid2:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
						humanoid2:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
					end
				end)
			end

			if flag4 and humanoid2 and humanoid2.Parent then
				pcall(function()
					if humanoid2.Health and humanoid2.Health > 1 then
						humanoid2.Health = humanoid2.Health - 1
					end
				end)

				task.wait(0.25)

				pcall(function()
					if humanoid2 and humanoid2.Parent and humanoid2.MaxHealth and humanoid2.MaxHealth > 1 and humanoid2.Health >= humanoid2.MaxHealth then
						if _G.TacoInvisStop then
							_G.TacoInvisStop()
						end
					end
				end)

				task.wait(0.3)
			end

			if not humanoidRootPart2 or not humanoid2 then
				_G.BJK_DropFlingActive = false
				_G.BJK_CancelTp = false
				_G._bjkCancelTP = false

				if _G.__resetAutoInvis ~= nil then
					_G.AutoInvisDuringSteal = _G.__resetAutoInvis
					_G.__resetAutoInvis = nil
				end

				if _G.__resetAntiLaunch ~= nil then
					_G.BJK_AntiLaunch = _G.__resetAntiLaunch
					_G.__resetAntiLaunch = nil
				end

				if _G.__resetHpShield ~= nil then
					_G.BJK_HpShield = _G.__resetHpShield
					_G.__resetHpShield = nil
				end

				return false
			end

			_G.bjkInstaResetting = true
			_G._instaResetTime = os.clock()
			n = tick()
			flag2 = true
			resetDono = {}
			_G.__resetDono = resetDono

			fn7 = function()
				if _G.__resetDono ~= resetDono then
					return
				end
				flag2 = false
				_G.bjkInstaResetting = false
				_G.BJK_DropFlingActive = false
				_G.BJK_CancelTp = false
				_G._bjkCancelTP = false

				if _G.__resetAutoInvis ~= nil then
					_G.AutoInvisDuringSteal = _G.__resetAutoInvis
					_G.__resetAutoInvis = nil
				end

				if _G.__resetAntiLaunch ~= nil then
					_G.BJK_AntiLaunch = _G.__resetAntiLaunch
					_G.__resetAntiLaunch = nil
				else
					_G.BJK_AntiLaunch = nil
				end

				if _G.__resetHpShield ~= nil then
					_G.BJK_HpShield = _G.__resetHpShield
					_G.__resetHpShield = nil
				end
			end

			fn5 = fn7
			pcall(clearPlayerESP)
			pcall(clearTimerESP)
			pcall(clearBrainrotESP)

			pcall(function()
				local bjkBrainrotESP = Workspace:FindFirstChild("BJKBrainrotESP")

				if bjkBrainrotESP then
					for i, child in ipairs(bjkBrainrotESP:GetChildren()) do
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end)

			task.spawn(function()
				pcall(function()
					if _G.tpAntiDieDisable then
						_G.tpAntiDieDisable()
					end
				end)

				local currentCamera, cFrame, cameraType, fn8, tbl6, v3, connection_, now, flag5
				currentCamera = Workspace.CurrentCamera
				cFrame = currentCamera and currentCamera.CFrame
				cameraType = currentCamera and currentCamera.CameraType

				pcall(function()
					currentCamera.CameraType = Enum.CameraType.Scriptable

					RunService_:BindToRenderStep("BJKInstaResetCam", Enum.RenderPriority.Camera.Value + 1, function()
						currentCamera.CFrame = cFrame
					end)
				end)

				pcall(function()
					for i, descendant in ipairs(character2:GetDescendants()) do
						if descendant:IsA("BasePart") or descendant:IsA("Decal") then
							descendant.LocalTransparencyModifier = 1
						end
					end
				end)

				fn8 = function()
					if v2.Character ~= character2 then
						return true
					end

					if not character2.Parent then
						return true
					end

					if not humanoid2.Parent then
						return true
					end

					if humanoid2.Health <= 0 then
						return true
					end
					return false
				end

				tbl6 = {
					{
					nome = "Health = 0",
					fn = function()
					humanoid2.Health = 0
				end,
				},
					{
					nome = "ChangeState(Dead)",
					fn = function()
					humanoid2:ChangeState(Enum.HumanoidStateType.Dead)
				end,
				},
					{
					nome = "BreakJoints",
					fn = function()
					character2:BreakJoints()
				end,
				},
					{
					nome = "remove Humanoid",
					fn = function()
					humanoid2:Destroy()
				end,
				},
					{
					nome = "queda no vazio",
					fn = function()
					humanoidRootPart2.CFrame = CFrame.new(humanoidRootPart2.Position.X, -500, humanoidRootPart2.Position.Z)
					humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, -300, 0)
				end,
				},
				}

				v3 = nil

				connection_ = v2.CharacterAdded:Connect(function(character3)
					v3 = character3
				end)

				now = tick()
				flag5 = true

				task.spawn(function()
					while flag5 and tick() - now < 6 do
						if v2.Character ~= character2 then
							break
						end

						if not humanoidRootPart2.Parent then
							break
						end

						pcall(function()
							humanoidRootPart2.CFrame = humanoidRootPart2.CFrame + Vector3.new(0, 10000, 0)
						end)

						RunService_.Heartbeat:Wait()
					end
				end)

				local flag6 = false

				while not v3 and tick() - now < 10 do
					if not flag6 and tick() - now > 1.5 and not fn8() then
						flag6 = true

						for i = 1, 5 do
							pcall(tbl6[i].fn)
						end
					end

					RunService_.Heartbeat:Wait()
				end

				flag5 = false

				if connection_ then
					pcall(function()
						connection_.Disconnect(connection_)
					end)
				end

				pcall(function()
					RunService_:UnbindFromRenderStep("BJKInstaResetCam")
				end)

				pcall(function()
					currentCamera.CameraType = cameraType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or cameraType

					if v3 then
						local v4 = v3.FindFirstChildOfClass(v3, "Humanoid") or v3.WaitForChild(v3, "Humanoid", 5)

						if v4 then
							currentCamera.CameraSubject = v4
						end
					end
				end)

				pcall(function()
					if _G.tpAntiDieEnable then
						_G.tpAntiDieEnable()
					end
				end)

				fn7()
			end)

			task.delay(12, fn7)
			return true
		end

		_G.BJKResetCleanup = function()
			flag3 = false
		end

		task.spawn(function()
			local ok = pcall(function()
				local bindableEvent = Instance.new("BindableEvent")

				bindableEvent.Event:Connect(function()
					pcall(fn6)
				end)

				for i = 1, 200 do
					local ok = pcall(function()
						game:GetService("StarterGui"):SetCore("ResetButtonCallback", bindableEvent)
					end)

					if ok then
						break
					end
					task.wait(0.05)
				end
			end)
		end)

		return fn6
	end)()

	executeReset = function(arg)
		if not SAB_LIVE() then
			return
		end

		if arg then
			if not _msgLastBalloonReset then
				_msgLastBalloonReset = 0
			end

			if os.clock() - _msgLastBalloonReset < 20 then
				return
			end
			_msgLastBalloonReset = os.clock()
		end

		_G._bjkCancelTP = true
		_G.BJK_CancelTp = true
		isGrabbleTeleporting = false
		return BJKInstantReset()
	end

	_G.BJK_ExecuteReset = executeReset

	_G.BJK_DoReset = function()
		executeReset()
	end

	instantReset = BJKInstantReset
	_G.InstantReset = BJKInstantReset
	_G.executeReset = executeReset
end

function instantClone(arg)
	if not player.Character then
		return false
	end
	local v2 = player.Character.FindFirstChildOfClass(player.Character, "Humanoid")
	if not v2 then
		return false
	end
	local quantumCloner = player.Backpack:FindFirstChild("Quantum Cloner") or player.Character.FindFirstChild(player.Character, "Quantum Cloner")
	if not quantumCloner then
		return false
	end

	pcall(function()
		v2:UnequipTools()
	end)

	task.wait()

	if quantumCloner.Parent ~= player.Character then
		v2:EquipTool(quantumCloner)
		task.wait()
	end

	local toolsFrames = playerGui:FindFirstChild("ToolsFrames")
	local quantumCloner2 = toolsFrames and toolsFrames:FindFirstChild("QuantumCloner")
	local teleportToClone = quantumCloner2 and quantumCloner2:FindFirstChild("TeleportToClone")
	if not teleportToClone then
		return false
	end
	_G.isCloning = true
	quantumCloner:Activate()
	task.wait(0.02)
	teleportToClone.Visible = true

	if arg then
		local humanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart2 and humanoidRootPart2.Parent then
			pcall(function()
				local vector4 = Vector3.new(arg.X, 0, arg.Z)

				if vector4.Magnitude < 0.001 then
					vector4 = Vector3.new(0, 0, -1)
				end

				vector4 = vector4.Unit
				humanoidRootPart2.CFrame = CFrame.lookAt(humanoidRootPart2.Position, humanoidRootPart2.Position + vector4)
				humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
				humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	end

	pcall(function()
		firesignal(teleportToClone.MouseButton1Click)
	end)

	pcall(function()
		firesignal(teleportToClone.MouseButton1Up)
	end)

	pcall(function()
		firesignal(teleportToClone.Activated)
	end)

	task.delay(0.55, function()
		_G.isCloning = false
	end)

	return true
end

local tbl6, flag = {}, false

local function fn5()
	flag = false

	for i, v2 in ipairs(tbl6) do
		if typeof(v2) == "RBXScriptConnection" then
			v2:Disconnect()
		end
	end

	tbl6 = {}
end

local function fn6()
	flag = true
	if not player.Character then
		return
	end
	local v2 = player.Character.FindFirstChild(player.Character, "HumanoidRootPart")

	for k, child in pairs(Workspace.CurrentCamera:GetChildren()) do
		if child.Name == "HumanoidRootPart" then
			v2 = child
			break
		end
	end

	if not v2 then
		return
	end
	local thread

	table.insert(tbl6, RunService.Stepped:Connect(function()
		if not flag then
			return
		end

		for i, player_ in ipairs(Players2:GetPlayers()) do
			if player_ ~= player and player_.Character then
				for i2, child in ipairs(player_.Character:GetChildren()) do
					if child:IsA("BasePart") then
						child.CanCollide = false
					end
				end
			end
		end
	end))

	thread = coroutine.create(function()
		if _G.invisibleStealEnabled then
			v2.CFrame = v2.CFrame * CFrame.new(0, 3, 0)
		end

		while flag do
			RunService.Heartbeat:Wait()
			if not v2 or not v2.Parent then
				break
			end
			local velocity = v2.Velocity
			v2.Velocity = velocity * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()

			if v2 then
				v2.Velocity = velocity
			end

			RunService.Stepped:Wait()

			if v2 then
				v2.Velocity = velocity + Vector3.new(0, 0.1, 0)
			end
		end
	end)

	coroutine.resume(thread)
	table.insert(tbl6, thread)
end

local function fn7()
	if flag then
		return
	end
	fn6()
	task.delay(0.4, fn5)
end

do
	animPlaying = false
	tracks = {}
	folderConnections = {}
	serverGhosts = {}
	ghostEnabled = true
	local fn8, character, n, tbl7, fn9, fn10, v2, model, n2, v3, v4, v5, n3, v6, v7, v8
	lagbackCallCount = 0
	lagbackWindowStart = 0
	lastLagbackTime = 0
	errorOrbActive = false
	errorOrb = nil
	errorOrbConnection = nil
	_G.invisibleStealEnabled = false
	_G.InvisStealAngle = mainConfig.InvisStealAngle or 225
	_G.SinkSliderValue = mainConfig.SinkSliderValue or 7
	_G.AutoRecoverLagback = mainConfig.AutoRecoverLagback ~= nil and mainConfig.AutoRecoverLagback or true
	_G.AutoInvisDuringSteal = mainConfig.AutoInvisDuringSteal or false
	_G.BJK_InvisDelayEnabled = mainConfig.InvisDelayEnabled == true
	_G.BJK_InvisDelayMs = tonumber(mainConfig.InvisDelayMs) or 0
	_G.BJK_InvisDelaySeq = _G.BJK_InvisDelaySeq or 0

	_G.BJK_GetInvisDelayMs = function()
		if _G.BJK_InvisDelayEnabled then
			return tonumber(_G.BJK_InvisDelayMs) or 0
		end
		return 0
	end

	_G.BJK_InvisSync = _G.BJK_InvisSync or { main = {}, mini = {} }
	_G.BJK_InvisSync.busy = false

	_G.BJK_ApplyInvis = function(arg, invisDelayEnabled, arg2)
		if arg == "DelayEnabled" then
			mainConfig.InvisDelayEnabled = invisDelayEnabled
			_G.BJK_InvisDelayEnabled = invisDelayEnabled
		elseif arg == "DelaySec" then
			mainConfig.InvisDelayMs = invisDelayEnabled * 1000
			_G.BJK_InvisDelayMs = invisDelayEnabled * 1000
		else
			return
		end

		saveConfig()
		if _G.BJK_InvisSync.busy then
			return
		end
		local tbl8 = {}
		_G.BJK_InvisSync.busy = true

		pcall(function()
			for k, v9 in pairs({ main = _G.BJK_InvisSync.main, mini = _G.BJK_InvisSync.mini }) do
				if k ~= arg2 then
					local v10 = v9[arg]

					if type(v10) == "function" then
						pcall(v10, invisDelayEnabled)
					end
				end
			end
		end)

		_G.BJK_InvisSync.busy = false
	end

	_G._invisOldRoot = nil
	_G._invisClone = nil

	function clearErrorOrb()
		if errorOrb and errorOrb.Parent then
			errorOrb:Destroy()
		end

		errorOrb = nil
		errorOrbActive = false

		if errorOrbConnection then
			errorOrbConnection:Disconnect()
			errorOrbConnection = nil
		end
	end

	function createErrorOrb()
		if errorOrbActive then
			return
		end
		errorOrbActive = true

		for k, v9 in pairs(serverGhosts) do
			if v9 and v9.Parent then
				v9:Destroy()
			end
		end

		serverGhosts = {}
	end

	function createServerGhost(arg)
		if not ghostEnabled or errorOrbActive then
			return
		end
		local now = os.clock()
		if now - lastLagbackTime < 0.05 then
			return
		end
		lastLagbackTime = now

		if now - lagbackWindowStart > 1 then
			lagbackCallCount = 0
			lagbackWindowStart = now
		end

		lagbackCallCount = lagbackCallCount + 1
		if lagbackCallCount >= 7 then
			createErrorOrb()
			return
		end

		for k, v9 in pairs(serverGhosts) do
			if v9 and v9.Parent then
				v9:Destroy()
			end
		end

		serverGhosts = {}
		local part = Instance.new("Part")
		part.Name = "LagbackGhost"
		part.Shape = Enum.PartType.Ball
		part.Size = Vector3.new(3, 3, 3)
		local tbl8 = {}
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Material = Enum.Material.Glass
		part.Transparency = 0.3
		part.CanCollide = false
		part.Anchored = true
		part.CastShadow = false
		part.Position = arg + Vector3.new(0, 5, 0)
		part.Parent = Workspace.CurrentCamera
		table.insert(serverGhosts, part)
	end

	function clearAllGhosts()
		for k, v9 in pairs(serverGhosts) do
			pcall(function()
				if v9 and v9.Parent then
					v9:Destroy()
				end
			end)
		end

		serverGhosts = {}
		clearErrorOrb()
		local tbl8 = {}
		lagbackCallCount = 0
		lastLagbackTime = 0

		pcall(function()
			local playerGui_ = player:FindFirstChild("PlayerGui")

			if playerGui_ then
				for k, child in pairs(playerGui_:GetChildren()) do
					if child.Name == "BJK_LagbackNotice" then
						child:Destroy()
					end
				end
			end
		end)

		pcall(function()
			if Workspace.CurrentCamera then
				for k, child in pairs(Workspace.CurrentCamera:GetChildren()) do
					if child.Name == "LagbackGhost" then
						child:Destroy()
					end
				end
			end
		end)

		pcall(function()
			for k, descendant in pairs(Workspace:GetDescendants()) do
				if descendant.Name == "LagbackGhost" then
					descendant:Destroy()
				end
			end
		end)
	end

	function removeFolders()
		local v9 = Workspace:FindFirstChild(player.Name)
		if not v9 then
			return
		end
		local doubleRig = v9:FindFirstChild("DoubleRig")

		if doubleRig then
			local humanoidRootPart2 = doubleRig:FindFirstChild("HumanoidRootPart") or doubleRig:FindFirstChildWhichIsA("BasePart")

			if humanoidRootPart2 and ghostEnabled then
				createServerGhost(humanoidRootPart2.Position)
			end

			doubleRig:Destroy()
		end

		local constraints = v9:FindFirstChild("Constraints")

		if constraints then
			constraints:Destroy()
		end

		local connection_ = v9.ChildAdded:Connect(function(child)
			if child.Name == "DoubleRig" then
				task.defer(function()
					local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")

					if humanoidRootPart2 and ghostEnabled then
						createServerGhost(humanoidRootPart2.Position)
					end

					child:Destroy()
				end)
			elseif child.Name == "Constraints" then
				child:Destroy()
			end
		end)

		table.insert(folderConnections, connection_)
	end

	doClone = function()
		if player.Character and player.Character.FindFirstChild(player.Character, "Humanoid") and player.Character.Humanoid.Health > 0 then
			hip = player.Character.Humanoid.HipHeight
			oldRoot = player.Character.FindFirstChild(player.Character, "HumanoidRootPart")
			if not oldRoot or not oldRoot.Parent then
				return false
			end

			for k, child in pairs(oldRoot:GetChildren()) do
				if child:IsA("Beam") then
					child:Destroy()
				elseif child:IsA("Attachment") and (child.Name:find("Beam") or child.Name:find("Attach")) then
					child:Destroy()
				end
			end

			local model2
			model2 = Instance.new("Model")
			model2.Parent = game
			player.Character.Parent = model2
			clone = oldRoot:Clone()
			clone.Parent = player.Character
			clone.CanCollide = true
			oldRoot.Parent = Workspace.CurrentCamera
			clone.CFrame = oldRoot.CFrame
			player.Character.PrimaryPart = clone
			player.Character.Parent = Workspace

			for k, descendant in pairs(player.Character.GetDescendants(player.Character)) do
				if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
					if descendant.Part0 == oldRoot then
						descendant.Part0 = clone
					end

					if descendant.Part1 == oldRoot then
						descendant.Part1 = clone
					end
				end
			end

			_G._invisOldRoot = oldRoot
			_G._invisClone = clone
			model2.Destroy(model2)
			return true
		end

		return false
	end

	revertClone = function()
		if not oldRoot or not oldRoot:IsDescendantOf(Workspace) then
			return
		end

		if not player.Character or player.Character.Humanoid.Health <= 0 then
			return
		end
		local v9 = player.Character.FindFirstChildOfClass(player.Character, "Humanoid")
		local platformStand = v9 and v9.PlatformStand or false

		if v9 then
			pcall(function()
				v9.PlatformStand = true
			end)
		end

		local cFrame = clone and clone.Parent and clone.CFrame or oldRoot.CFrame

		pcall(function()
			oldRoot.CFrame = cFrame
			oldRoot.Velocity = Vector3.zero
		end)

		local model2 = Instance.new("Model")
		model2.Parent = game
		player.Character.Parent = model2
		local tbl8 = {}
		oldRoot.Parent = player.Character
		player.Character.PrimaryPart = oldRoot
		player.Character.Parent = Workspace
		oldRoot.CanCollide = true

		for k, descendant in pairs(player.Character.GetDescendants(player.Character)) do
			if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
				if descendant.Part0 == clone then
					descendant.Part0 = oldRoot
				end

				if descendant.Part1 == clone then
					descendant.Part1 = oldRoot
				end
			end
		end

		if clone then
			clone:Destroy()
			clone = nil
		end

		pcall(function()
			oldRoot.CFrame = cFrame
			oldRoot.Velocity = Vector3.zero
		end)

		oldRoot = nil
		_G._invisOldRoot = nil
		_G._invisClone = nil

		if player.Character and player.Character.Humanoid then
			player.Character.Humanoid.HipHeight = hip
		end

		clearAllGhosts()

		if v9 then
			task.spawn(function()
				RunService.Heartbeat:Wait()
				RunService.Heartbeat:Wait()

				if v9 and v9.Parent then
					pcall(function()
						v9.PlatformStand = platformStand
					end)
				end
			end)
		end
	end

	animationTrickery = function()
		if player.Character and player.Character.FindFirstChild(player.Character, "Humanoid") and player.Character.Humanoid.Health > 0 then
			local animation = Instance.new("Animation")
			animation.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
			local humanoid2 = player.Character.Humanoid
			local animator = humanoid2:FindFirstChild("Animator") or Instance.new("Animator", humanoid2)
			local v9
			v9 = animator:LoadAnimation(animation)
			v9.Priority = Enum.AnimationPriority.Action4
			v9.Play(v9, 0, 1, 0)
			animation:Destroy()
			table.insert(tracks, v9)

			v9.Stopped:Connect(function()
				if animPlaying then
					animationTrickery()
				end
			end)

			task.delay(0, function()
				v9.TimePosition = 0.7

				task.delay(0.3, function()
					if v9 then
						v9.AdjustSpeed(v9, math.huge)
					end
				end)
			end)
		end
	end

	_invisToggleCooldown = 0
	_G.InvisStealAngle = mainConfig.InvisStealAngle or 180
	_G.SinkSliderValue = mainConfig.SinkSliderValue or 8
	local tbl8 = {}
	local n4 = 0
	local n5 = 0
	local n6 = 0
	local flag2 = false

	local function fn11()
		if flag2 then
			return
		end
		flag2 = true
		local part = Instance.new("Part")
		part.Name = "InvisErrorOrb"
		part.Shape = Enum.PartType.Ball
		part.Size = Vector3.new(4, 4, 4)
		local textLabel
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Material = Enum.Material.Neon
		part.Transparency = 0.2
		part.CanCollide = false
		part.Anchored = true
		part.CastShadow = false
		part.Position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position + Vector3.new(0, 8, 0) or Vector3.new(0, 100, 0)
		part.Parent = Workspace.CurrentCamera
		local billboardGui = Instance.new("BillboardGui", part)
		billboardGui.Size = UDim2.new(0, 200, 0, 50)
		billboardGui.StudsOffset = Vector3.new(0, 4, 0)
		billboardGui.AlwaysOnTop = true
		textLabel = Instance.new("TextLabel", billboardGui)
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "LAGBACK DETECTED\nDISABLE INVIS STEAL"
		textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextScaled = true

		task.delay(2, function()
			if part then
				part:Destroy()
			end

			flag2 = false
		end)
	end

	local function fn12()
		flag2 = false

		if Workspace.CurrentCamera then
			for k, child in pairs(Workspace.CurrentCamera.GetChildren(Workspace.CurrentCamera)) do
				if child.Name == "InvisErrorOrb" then
					child:Destroy()
				end
			end
		end
	end

	local function fn13(arg)
		if not ghostEnabled or flag2 then
			return
		end
		local now = os.clock()
		if now - n6 < 0.05 then
			return
		end
		n6 = now

		if now - n5 > 1 then
			n4 = 0
			n5 = now
		end

		n4 = n4 + 1
		if n4 >= 7 then
			fn11()
			return
		end

		for k, v9 in pairs(tbl8) do
			if v9 and v9.Parent then
				v9:Destroy()
			end
		end

		tbl8 = {}
		local part = Instance.new("Part")
		part.Name = "LagbackGhost"
		part.Shape = Enum.PartType.Ball
		part.Size = Vector3.new(3, 3, 3)
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Material = Enum.Material.Glass
		part.Transparency = 0.3
		local billboardGui
		part.CanCollide = false
		part.Anchored = true
		part.CastShadow = false
		part.Position = arg + Vector3.new(0, 5, 0)
		part.Parent = Workspace.CurrentCamera
		billboardGui = Instance.new("BillboardGui", part)
		billboardGui.Size = UDim2.new(0, 400, 0, 60)
		billboardGui.StudsOffset = Vector3.new(0, 4, 0)
		billboardGui.AlwaysOnTop = true
		local textLabel = Instance.new("TextLabel", billboardGui)
		textLabel.Size = UDim2.new(1, 0, 0, 25)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "LAGBACK DETECTED"
		textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextScaled = true
		table.insert(tbl8, part)
	end

	local function fn14()
		for k, v9 in pairs(tbl8) do
			pcall(function()
				if v9 and v9.Parent then
					v9:Destroy()
				end
			end)
		end

		local tbl9 = {}
		tbl8 = {}
		n4 = 0
		n6 = 0
		n5 = 0
		fn12()

		pcall(function()
			local playerGui_ = player:FindFirstChild("PlayerGui")

			if playerGui_ then
				for k, child in pairs(playerGui_:GetChildren()) do
					if child.Name == "BJK_LagbackNotice" then
						child:Destroy()
					end
				end
			end
		end)

		pcall(function()
			if Workspace.CurrentCamera then
				for k, child in pairs(Workspace.CurrentCamera.GetChildren(Workspace.CurrentCamera)) do
					if child.Name == "LagbackGhost" then
						child:Destroy()
					end
				end
			end
		end)

		pcall(function()
			for k, descendant in pairs(Workspace:GetDescendants()) do
				if descendant.Name == "LagbackGhost" then
					descendant:Destroy()
				end
			end
		end)
	end

	local function fn15()
		if not _G.AutoRotateInvis then
			return _G.InvisStealAngle or 180
		end

		if not player.Character then
			return 180
		end
		local huge, n7 = math.huge, -math.huge
		local n8 = 0

		for k, descendant in pairs(player.Character.GetDescendants(player.Character)) do
			if descendant:IsA("BasePart") and descendant ~= clone then
				local size = descendant.Size
				local position = descendant.Position
				huge = math.min(huge, position.Y - size.Y / 2)
				n7 = math.max(n7, position.Y + size.Y / 2)
				n8 = math.max(n8, size.X, size.Z)
			end
		end

		local n9 = n7 - huge
		if n9 <= 0 then
			return 180
		end
		local n10 = (_G.SinkSliderValue or 5) * 0.5
		local n11

		if n10 >= n9 then
			n11 = 180
		else
			local n12 = math.min(1, n10 / n9)
			n11 = 180 + math.deg(math.asin(1 - n12)) + 15
			n11 = math.clamp(n11, 180, 270)
		end

		return n11
	end

	function invisTurnOff()
		fn14()
		if not animPlaying then
			return
		end
		local character2 = player.Character and player.Character.FindFirstChildOfClass(player.Character, "Humanoid")
		animPlaying = false
		_G.invisibleStealEnabled = false
		setToggle("Invisible Steal", false)

		for k, v9 in pairs(tracks) do
			pcall(function()
				v9:Stop(0)
			end)
		end

		tracks = {}

		if connection then
			connection:Disconnect()
			connection = nil
		end

		for i, v9 in ipairs(folderConnections) do
			if v9 then
				v9:Disconnect()
			end
		end

		folderConnections = {}

		if oldRoot and oldRoot.Parent and clone and clone.Parent then
			pcall(function()
				local tbl9 = {}
				oldRoot.CFrame = clone.CFrame
				oldRoot.Velocity = Vector3.zero
				clone.Velocity = Vector3.zero
			end)

			RunService.Heartbeat:Wait()
			RunService.Heartbeat:Wait()
		end

		revertClone()
		fn14()
		local character3 = player.Character and player.Character.FindFirstChild(player.Character, "HumanoidRootPart")

		if character3 then
			pcall(function()
				character3.Velocity = Vector3.zero
			end)
		end

		if character2 then
			pcall(function()
				local animator = character2:FindFirstChildOfClass("Animator")

				if animator then
					for i, v9 in ipairs(animator:GetPlayingAnimationTracks()) do
						if v9.Priority == Enum.AnimationPriority.Action4 or v9.Priority == Enum.AnimationPriority.Action3 then
							v9:Stop(0)
						end
					end
				end

				character2:ChangeState(Enum.HumanoidStateType.GettingUp)

				task.defer(function()
					if character2 and character2.Parent then
						character2:ChangeState(Enum.HumanoidStateType.Running)
					end
				end)
			end)
		end

		if _G.updateMovementPanelInvisVisual then
			pcall(_G.updateMovementPanelInvisVisual, false)
		end

		_invisToggleCooldown = os.clock()
	end

	invisTurnOn = function()
		if animPlaying then
			return
		end

		if _G.bjkInstaResetting or _G._instaResetTime and os.clock() - _G._instaResetTime < 2 then
			return
		end

		if not player.Character then
			return
		end
		local v9 = player.Character.FindFirstChildOfClass(player.Character, "Humanoid")
		if not v9 then
			return
		end
		animPlaying = true
		_G.invisibleStealEnabled = true
		setToggle("Invisible Steal", true)

		if _G.updateMovementPanelInvisVisual then
			pcall(_G.updateMovementPanelInvisVisual, true)
		end

		tracks = {}
		removeFolders()
		local v10 = doClone()

		if v10 then
			task.wait(0.05)
			animationTrickery()

			task.defer(function()
				if _G.resetBrainrotBeam then
					pcall(_G.resetBrainrotBeam)
				end

				if _G.resetPlotBeam then
					pcall(_G.resetPlotBeam)
				end

				task.wait(0.1)

				if _G.updateBrainrotBeam then
					pcall(_G.updateBrainrotBeam)
				end

				if _G.createPlotBeam then
					pcall(_G.createPlotBeam)
				end
			end)

			local position = nil
			local n7 = 5

			connection = RunService.PreSimulation:Connect(function()
				if player.Character and player.Character.FindFirstChild(player.Character, "Humanoid") and player.Character.Humanoid.Health > 0 and oldRoot then
					local primaryPart = player.Character.PrimaryPart or player.Character.FindFirstChild(player.Character, "HumanoidRootPart")

					if primaryPart then
						local state = player.Character.Humanoid:GetState()

						if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll then
							pcall(function()
								primaryPart.AssemblyLinearVelocity = Vector3.zero
								primaryPart.AssemblyAngularVelocity = Vector3.zero
								oldRoot.Velocity = Vector3.zero
							end)
						end

						if n7 > 0 then
							n7 = n7 - 1
							position = nil
						elseif position and ghostEnabled then
							local magnitude = (oldRoot.Position - position).Magnitude

							if magnitude > 3 and not _G.RecoveryInProgress then
								position = nil
								fn13(oldRoot.Position)

								if _G.AutoRecoverLagback and _G._forceInvisToggle and not _G.bjkInstaResetting and not (_G._instaResetTime and os.clock() - _G._instaResetTime < 2) then
									_G.RecoveryInProgress = true
									local bjkLagbackRecoveryGen
									_G._bjkLagbackRecoveryGen = (_G._bjkLagbackRecoveryGen or 0) + 1
									bjkLagbackRecoveryGen = _G._bjkLagbackRecoveryGen

									task.spawn(function()
										pcall(_G._forceInvisToggle)
										task.wait(0.5)
										if bjkLagbackRecoveryGen ~= _G._bjkLagbackRecoveryGen then
											return
										end

										if not _G.bjkInstaResetting and not (_G._instaResetTime and os.clock() - _G._instaResetTime < 2) and player.Character == player.Character and player.Character.Parent then
											pcall(_G._forceInvisToggle)
										end

										_G.RecoveryInProgress = false
									end)
								end
							end
						end

						if clone then
							clone.CanCollide = true
						end

						for k, child in pairs(oldRoot:GetChildren()) do
							if child:IsA("Attachment") or child:IsA("Beam") then
								child:Destroy()
							end
						end

						local autoRotateInvis, n8, n9
						autoRotateInvis = _G.AutoRotateInvis and fn15() or (_G.InvisStealAngle or 180)
						n8 = (_G.SinkSliderValue or 5) * 0.5
						n9 = primaryPart.CFrame - Vector3.new(0, n8, 0)
						oldRoot.CFrame = n9 * CFrame.Angles(math.rad(autoRotateInvis), 0, 0)
						oldRoot.Velocity = primaryPart.Velocity
						oldRoot.CanCollide = false
						position = oldRoot.Position
					end
				else
					if animPlaying then
						invisTurnOff()
					end
				end
			end)
		else
			local tbl9 = {}
			animPlaying = false
			_G.invisibleStealEnabled = false
			_G.RecoveryInProgress = false
			setToggle("Invisible Steal", false)

			if _G.updateMovementPanelInvisVisual then
				pcall(_G.updateMovementPanelInvisVisual, false)
			end
		end
	end

	_G.toggleInvisibleSteal = function()
		if os.clock() - _invisToggleCooldown < 0.3 then
			return
		end

		if animPlaying then
			invisTurnOff()
		else
			invisTurnOn()
		end
	end

	_G._forceInvisToggle = function()
		if animPlaying then
			invisTurnOff()
		else
			invisTurnOn()
		end
	end

	hardResetInvisState = function()
		animPlaying = false
		_G.invisibleStealEnabled = false

		for k, v9 in pairs(tracks) do
			pcall(function()
				v9:Stop()
			end)
		end

		tracks = {}

		if connection then
			pcall(function()
				connection:Disconnect()
			end)

			connection = nil
		end

		for i, v9 in ipairs(folderConnections) do
			if v9 then
				pcall(function()
					v9:Disconnect()
				end)
			end
		end

		folderConnections = {}

		if clone then
			pcall(function()
				clone:Destroy()
			end)

			clone = nil
		end

		if oldRoot then
			pcall(function()
				oldRoot:Destroy()
			end)

			oldRoot = nil
		end

		_G._invisOldRoot = nil
		local tbl9 = {}
		_G._invisClone = nil
		hip = nil
		fn14()

		pcall(function()
			local v9 = Workspace:FindFirstChild(player.Name)

			if v9 then
				local doubleRig = v9:FindFirstChild("DoubleRig")

				if doubleRig then
					doubleRig:Destroy()
				end

				local constraints = v9:FindFirstChild("Constraints")

				if constraints then
					constraints:Destroy()
				end
			end
		end)

		if _G.updateMovementPanelInvisVisual then
			pcall(_G.updateMovementPanelInvisVisual, false)
		end
	end

	player.CharacterAdded:Connect(function(character2)
		task.wait(0.1)
		hardResetInvisState()

		if mainConfig then
			mainConfig.ClickToAP = false
		end

		local currentCamera

		pcall(function()
			for k, child in pairs(Workspace.CurrentCamera:GetChildren()) do
				if child:IsA("BasePart") and child.Name == "HumanoidRootPart" then
					child:Destroy()
				end
			end
		end)

		task.wait(0.2)
		currentCamera = Workspace.CurrentCamera

		if currentCamera and character2 then
			local humanoid2 = character2:FindFirstChildOfClass("Humanoid")

			if humanoid2 then
				currentCamera.CameraSubject = humanoid2
				currentCamera.CameraType = Enum.CameraType.Custom
			end
		end
	end)

	setupDeathListener = function()
		if player.Character then
			local v9 = player.Character.FindFirstChildOfClass(player.Character, "Humanoid")

			if v9 then
				v9.Died:Connect(function()
					fn12()
					fn14()
					n4 = 0
				end)
			end
		end
	end

	setupDeathListener()

	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		setupDeathListener()
	end)

	task.spawn(function()
		_G.AntiDieDisabled = false

		local function setupAntiDie()
			if _G.AntiDieDisabled then
				return
			end

			if not player.Character then
				return
			end
			local v9 = player.Character.FindFirstChildOfClass(player.Character, "Humanoid")
			if not v9 then
				return
			end

			if _G.AntiDieConnection then
				pcall(function()
					_G.AntiDieConnection:Disconnect()
				end)
			end

			_G.AntiDieConnection = v9:GetPropertyChangedSignal("Health"):Connect(function()
				if _G.AntiDieDisabled then
					return
				end

				if v9.Health <= 0 then
					v9.Health = v9.MaxHealth
				end
			end)
		end

		_G.setupAntiDie = setupAntiDie
		setupAntiDie()

		player.CharacterAdded:Connect(function()
			task.wait(0.5)

			if not _G.AntiDieDisabled then
				setupAntiDie()
			end
		end)
	end)

	fn8 = function()
		if player:GetAttribute("Stealing") == true then
			return true
		end

		if player:GetAttribute("StealingIndex") ~= nil and tostring(player:GetAttribute("StealingIndex")) ~= "" then
			return true
		end

		if player.Character then
			for i, child in ipairs(player.Character.GetChildren(player.Character)) do
				if child:IsA("Tool") and child.Name:lower():find("steal") then
					return true
				end
			end
		end

		return false
	end

	task.spawn(function()
		local flag3 = false
		local flag4 = false
		task.wait(1)

		while task.wait(0.15) do
			if mainConfig.AutoInvisDuringSteal == false then
				flag3 = false
				flag4 = false
				_G.BJK_InvisDelaySeq = (_G.BJK_InvisDelaySeq or 0) + 1
			else
				local v9 = fn8()

				if v9 and not flag3 then
					if not _G.invisibleStealEnabled and _G._forceInvisToggle then
						local n7 = 0

						pcall(function()
							n7 = _G.BJK_GetInvisDelayMs and _G.BJK_GetInvisDelayMs() or (_G.BJK_InvisDelayEnabled and tonumber(_G.BJK_InvisDelayMs) or 0)
						end)

						if n7 and n7 > 0 then
							_G.BJK_InvisDelaySeq = (_G.BJK_InvisDelaySeq or 0) + 1

							task.delay(n7 / 1000, function()
								if _G.BJK_InvisDelaySeq ~= _G.BJK_InvisDelaySeq then
									return
								end

								if mainConfig.AutoInvisDuringSteal == false then
									return
								end

								if not fn8() then
									return
								end

								if _G.invisibleStealEnabled then
									return
								end

								if _G.bjkInstaResetting or _G._instaResetTime and os.clock() - _G._instaResetTime < 2 then
									return
								end
								pcall(_G._forceInvisToggle)
								flag4 = true
							end)
						else
							task.defer(function()
								task.wait(0.2)

								if fn8() and not _G.invisibleStealEnabled and not _G.bjkInstaResetting and not (_G._instaResetTime and os.clock() - _G._instaResetTime < 2) then
									pcall(_G._forceInvisToggle)
									flag4 = true
								end
							end)
						end
					end
				end

				if not v9 and flag4 and _G.invisibleStealEnabled and _G._forceInvisToggle then
					_G.BJK_InvisDelaySeq = (_G.BJK_InvisDelaySeq or 0) + 1
					task.wait(0.3)

					if not fn8() then
						pcall(_G._forceInvisToggle)
						flag4 = false
					end
				end

				if not v9 and flag3 then
					_G.BJK_InvisDelaySeq = (_G.BJK_InvisDelaySeq or 0) + 1
				end

				flag3 = v9
			end
		end
	end)

	FloatState = { active = false, platform = nil, followConn = nil }

	function removeFloatPlatform()
		if FloatState.followConn then
			FloatState.followConn:Disconnect()
			FloatState.followConn = nil
		end

		if FloatState.platform then
			FloatState.platform:Destroy()
			FloatState.platform = nil
		end
	end

	createFloatPlatform = function()
		removeFloatPlatform()
		local character2 = player.Character and player.Character.FindFirstChild(player.Character, "HumanoidRootPart")
		if not character2 then
			return
		end
		local part = Instance.new("Part")
		part.Size = Vector3.new(7, 1, 7)
		part.Anchored = true
		part.CanCollide = true
		local tbl9 = {}
		part.CanTouch = false
		part.CanQuery = false
		part.Transparency = 1
		part.CastShadow = false
		part.CFrame = CFrame.new(character2.Position - Vector3.new(0, 3.35, 0))
		part.Parent = Workspace
		FloatState.platform = part
		local n7 = 0

		FloatState.followConn = RunService.Heartbeat:Connect(function()
			if not FloatState.active then
				return
			end
			n7 = n7 + 1
			if n7 % 2 ~= 0 then
				return
			end
			local character3 = player.Character and player.Character.FindFirstChild(player.Character, "HumanoidRootPart")

			if character3 and FloatState.platform then
				FloatState.platform.CFrame = CFrame.new(character3.Position - Vector3.new(0, 3.35, 0))
			end
		end)
	end

	setFloat = function(active)
		if active and player:GetAttribute("Stealing") then
			if ShowNotification then
				pcall(ShowNotification, "FLOAT", "Blocked while carrying a brainrot")
			end

			if setToggle then
				pcall(setToggle, "Float", false)
			end

			return
		end

		FloatState.active = active
		mainConfig.Float = active
		saveConfig()

		if active then
			createFloatPlatform()
		else
			removeFloatPlatform()
		end
	end

	_G.toggleFloat = function()
		setFloat(not FloatState.active)
	end

	CarpetState = { enabled = false, conn = nil }

	SPEED_BOOST_TOOL_NAMES = {
		["Flying Carpet"] = true,
		Carpet = true,
		Cloud = true,
		["Witch's Broom"] = true,
		["Cupid's Wings"] = true,
		["Santa's Sleigh"] = true,
		["Magic Carpet"] = true,
		Waverider = true,
	}

	isSpeedBoostTool = function(arg)
		if not arg or not arg:IsA("Tool") then
			return false
		end

		if SPEED_BOOST_TOOL_NAMES[arg.Name] then
			return true
		end
		local tool = mainConfig.TpSettings and mainConfig.TpSettings.Tool
		return tool ~= nil and arg.Name == tool
	end

	function getEquippedTool(arg)
		if not arg then
			return nil
		end
		return arg:FindFirstChildWhichIsA("Tool")
	end

	function equipSpeedBoostToolOnce(arg, arg2)
		if not arg or not arg2 then
			return nil
		end
		local tool = mainConfig.TpSettings.Tool or "Flying Carpet"
		if arg:FindFirstChild(tool) then
			return tool
		end
		local v9 = player.Backpack:FindFirstChild(tool)

		if v9 then
			pcall(function()
				arg2:EquipTool(v9)
			end)

			return tool
		end

		for k in pairs(SPEED_BOOST_TOOL_NAMES) do
			if arg:FindFirstChild(k) then
				return k
			end
			local v10 = player.Backpack:FindFirstChild(k)

			if v10 then
				pcall(function()
					arg2:EquipTool(v10)
				end)

				return k
			end
		end

		return nil
	end

	function isCarpetSpeedBlocked()
		if _G._isTpMoving then
			return true
		end

		if player:GetAttribute("Stealing") then
			return true
		end
		return false
	end

	_G.isCarpetSpeedBlocked = isCarpetSpeedBlocked

	setCarpetSpeed = function(enabled)
		if enabled and isCarpetSpeedBlocked() then
			return
		end
		CarpetState.enabled = enabled
		mainConfig["Carpet Speed"] = enabled
		setToggle("Carpet Speed", enabled)
		saveConfig()

		if CarpetState.conn then
			CarpetState.conn:Disconnect()
			CarpetState.conn = nil
		end

		if not enabled then
			return
		end
		local character2 = player.Character and player.Character.FindFirstChild(player.Character, "Humanoid")

		if player.Character and character2 then
			equipSpeedBoostToolOnce(player.Character, character2)
		end

		CarpetState.conn = RunService.Heartbeat:Connect(function()
			if not player.Character then
				return
			end

			if isCarpetSpeedBlocked() then
				local v9 = player.Character.FindFirstChild(player.Character, "HumanoidRootPart")

				if v9 then
					v9.AssemblyLinearVelocity = Vector3.new(0, v9.AssemblyLinearVelocity.Y, 0)
				end

				return
			end

			local v9 = player.Character.FindFirstChild(player.Character, "Humanoid")
			local v10 = player.Character.FindFirstChild(player.Character, "HumanoidRootPart")
			if not v9 or not v10 then
				return
			end
			local v11 = getEquippedTool(player.Character)

			if v11 and not isSpeedBoostTool(v11) then
				v10.AssemblyLinearVelocity = Vector3.new(0, v10.AssemblyLinearVelocity.Y, 0)
				setCarpetSpeed(false)
				return
			end

			if v11 and isSpeedBoostTool(v11) then
				local moveDirection = v9.MoveDirection

				if moveDirection.Magnitude > 0 then
					v10.AssemblyLinearVelocity = Vector3.new(moveDirection.X * 130, v10.AssemblyLinearVelocity.Y, moveDirection.Z * 130)
				else
					v10.AssemblyLinearVelocity = Vector3.new(0, v10.AssemblyLinearVelocity.Y, 0)
				end
			end
		end)
	end

	_G.setCarpetSpeed = setCarpetSpeed
	CarpetSpeedToolConn = nil

	stopCarpetSpeedFromToolSwitch = function(arg)
		if not CarpetState.enabled or not arg then
			return
		end
		local v9 = getEquippedTool(arg)

		if v9 and not isSpeedBoostTool(v9) then
			local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 then
				humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart2.AssemblyLinearVelocity.Y, 0)
			end

			setCarpetSpeed(false)
		end
	end

	bindCarpetSpeedToolWatch = function(arg)
		if CarpetSpeedToolConn then
			pcall(function()
				CarpetSpeedToolConn:Disconnect()
			end)

			CarpetSpeedToolConn = nil
		end

		if not arg then
			return
		end

		CarpetSpeedToolConn = arg.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				task.defer(function()
					stopCarpetSpeedFromToolSwitch(arg)
				end)
			end
		end)
	end

	player.CharacterAdded:Connect(function(character2)
		bindCarpetSpeedToolWatch(character2)

		if CarpetState.enabled then
			task.defer(function()
				local humanoid2 = character2:WaitForChild("Humanoid", 10)

				if humanoid2 and CarpetState.enabled then
					equipSpeedBoostToolOnce(character2, humanoid2)
				end
			end)
		end
	end)

	if player.Character then
		bindCarpetSpeedToolWatch(player.Character)
	end

	InfJumpState = { enabled = false, conn = nil }

	function setInfiniteJump(enabled)
		local tbl9 = {}
		InfJumpState.enabled = enabled
		mainConfig.InfiniteJump = enabled
		mainConfig.TpSettings.InfiniteJump = enabled
		setToggle("Infinite Jump", enabled)
		saveConfig()

		if InfJumpState.conn then
			InfJumpState.conn:Disconnect()
			InfJumpState.conn = nil
		end

		if not enabled then
			return
		end
		local tbl10 = { lastJumpTime = 0 }

		InfJumpState.conn = RunService.Heartbeat:Connect(function()
			if not player.Character then
				return
			end
			local v9 = player.Character.FindFirstChild(player.Character, "HumanoidRootPart")
			local v10 = player.Character.FindFirstChild(player.Character, "Humanoid")
			if not v9 or not v10 or v10.Health <= 0 then
				return
			end

			if v10.Jump then
				local now = tick()
				if now - tbl10.lastJumpTime < 0.1 then
					return
				end
				tbl10.lastJumpTime = now
				v9.AssemblyLinearVelocity = Vector3.new(v9.AssemblyLinearVelocity.X, 55, v9.AssemblyLinearVelocity.Z)
			end
		end)
	end

	do
		local connection_

		local function fn16(arg)
			if connection_ then
				pcall(function()
					connection_:Disconnect()
				end)

				connection_ = nil
			end

			local humanoid2 = arg:WaitForChild("Humanoid", 10)
			if not humanoid2 then
				return
			end

			connection_ = RunService.Heartbeat:Connect(function()
				if not arg.Parent or not humanoid2.Parent then
					if connection_ then
						pcall(function()
							connection_:Disconnect()
						end)

						connection_ = nil
					end

					return
				end

				if _G.invisibleStealEnabled then
					return
				end
				local state = humanoid2:GetState()
				if state ~= Enum.HumanoidStateType.Physics and state ~= Enum.HumanoidStateType.Ragdoll then
					return
				end

				for i, child in ipairs(arg:GetChildren()) do
					if child:IsA("BasePart") and not child.CanCollide then
						pcall(function()
							child.CanCollide = true
						end)
					end
				end

				for i, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("NoCollisionConstraint") then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end)
		end

		if player.Character then
			task.spawn(fn16, player.Character)
		end

		player.CharacterAdded:Connect(function(character2)
			task.spawn(fn16, character2)
		end)
	end

	do
		local tbl9 = {}
		local v9, humanoid2, humanoidRootPart2, animator
		local position, n7, fn16, fn17, fn18, fn19, fn20, fn21
		position = nil
		n7 = 0

		fn16 = function()
			if not v9 then
				return false
			end
			local tool = v9:FindFirstChildWhichIsA("Tool")
			if not tool then
				return false
			end
			local humanoidRootPart3 = v9:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart3 then
				for i, child in ipairs(humanoidRootPart3:GetChildren()) do
					if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
						return true
					end
				end
			end

			return false
		end

		fn17 = function()
			if not humanoid2 then
				return false
			end
			local state = humanoid2:GetState()
			return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.GettingUp
		end

		fn18 = function()
			pcall(function()
				local playerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
				require(playerModule):GetControls():Enable()
			end)
		end

		fn19 = function()
			if not v9 then
				return
			end
			local v10 = fn16()

			local function fn22(arg)
				for i, child in ipairs(arg:GetChildren()) do
					if child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") or child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
						child:Destroy()
					elseif child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
						if not v10 then
							child:Destroy()
						end
					elseif child:IsA("Motor6D") then
						child.Enabled = true
					elseif child:IsA("BasePart") then
						for i2, child2 in ipairs(child:GetChildren()) do
							if child2:IsA("BallSocketConstraint") or child2:IsA("NoCollisionConstraint") or child2:IsA("HingeConstraint") or child2:IsA("Motor6D") then
								if child2:IsA("Motor6D") then
									child2.Enabled = true
								else
									child2:Destroy()
								end
							elseif child2:IsA("Attachment") and (child2.Name == "A" or child2.Name == "B") then
								child2:Destroy()
							end
						end
					end
				end
			end

			pcall(function()
				fn22(v9)
			end)

			if animator then
				for k, v11 in pairs(animator:GetPlayingAnimationTracks()) do
					local str = v11.Animation and v11.Animation.Name:lower() or ""

					if str:find("rag") or str:find("fall") or str:find("hurt") or str:find("down") then
						v11:Stop(0)
					end
				end
			end
		end

		local function fn22(arg)
			v9 = arg
			humanoid2 = arg:WaitForChild("Humanoid", 10)
			humanoidRootPart2 = arg:WaitForChild("HumanoidRootPart", 10)
			animator = humanoid2 and humanoid2:WaitForChild("Animator", 10)
			position = nil
		end

		fn20 = function()
			for k, v10 in pairs(tbl9) do
				pcall(function()
					v10:Disconnect()
				end)
			end

			tbl9 = {}
		end

		fn21 = function()
			fn20()
			if not humanoid2 or not humanoidRootPart2 then
				return
			end

			table.insert(tbl9, humanoid2.StateChanged:Connect(function()
				if _G.invisibleStealEnabled then
					local state = humanoid2:GetState()

					if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll then
						fn19()

						pcall(function()
							humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
							humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
						end)

						if os.clock() - n7 > 0.25 then
							n7 = os.clock()

							pcall(function()
								humanoid2:ChangeState(Enum.HumanoidStateType.Running)
							end)
						end

						fn18()
					end

					return
				end

				if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and fn17() then
					if position == nil then
						position = humanoidRootPart2.Position
					end

					pcall(function()
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
					end)

					if not fn16() then
						humanoid2:ChangeState(Enum.HumanoidStateType.Running)
					end

					fn19()
					Workspace.CurrentCamera.CameraSubject = humanoid2
					fn18()
				end
			end))

			pcall(function()
				local ApplyImpulse = _G.Net and _G.Net:RemoteEvent("CombatService/ApplyImpulse")

				if ApplyImpulse then
					table.insert(tbl9, ApplyImpulse.OnClientEvent:Connect(function()
						if _G.invisibleStealEnabled then
							return
						end

						if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and humanoidRootPart2 then
							pcall(function()
								humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
								humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
							end)
						end
					end))
				end
			end)

			table.insert(tbl9, v9.DescendantAdded:Connect(function()
				if _G.invisibleStealEnabled then
					return
				end

				if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and fn17() then
					fn19()
				end
			end))

			table.insert(tbl9, RunService.Heartbeat:Connect(function()
				if not (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) then
					return
				end

				if _G.invisibleStealEnabled then
					local state = humanoid2 and humanoid2:GetState()

					if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll then
						fn19()

						pcall(function()
							humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
							humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
						end)
					end

					return
				end

				if fn17() then
					fn19()

					pcall(function()
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
					end)

					if position then
						local magnitude = (humanoidRootPart2.Position - position).Magnitude

						if magnitude > 25 then
							pcall(function()
								humanoidRootPart2.CFrame = CFrame.new(position)
							end)
						end
					end
				elseif humanoidRootPart2 then
					position = humanoidRootPart2.Position
				end
			end))

			fn18()
			fn19()
		end

		startAntiRagdoll = function()
			_G.AntiRagdollEnabled = true
			local tbl10 = {}
			_G.antiKnockbackEnabled = true
			mainConfig.AntiRagdoll = true
			setToggle("Anti Ragdoll", true)
			saveConfig()

			if player.Character then
				fn22(player.Character)
				fn21()
			end
		end

		stopAntiRagdoll = function()
			_G.AntiRagdollEnabled = false
			_G.antiKnockbackEnabled = false
			local tbl10 = {}
			mainConfig.AntiRagdoll = false
			setToggle("Anti Ragdoll", false)
			saveConfig()
			fn20()
		end

		_G.toggleAntiRagdoll = function(arg)
			if arg then
				startAntiRagdoll()
			else
				stopAntiRagdoll()
			end
		end

		_G.enableAntiKnockback = function()
			startAntiRagdoll()
		end

		_G.disableAntiKnockback = function()
			stopAntiRagdoll()
		end

		player.CharacterAdded:Connect(function(character2)
			fn20()
			v9 = nil
			humanoid2 = nil
			humanoidRootPart2 = nil
			animator = nil
			local humanoid3 = character2:WaitForChild("Humanoid", 10)
			local humanoidRootPart3 = character2:WaitForChild("HumanoidRootPart", 10)
			if not humanoid3 or not humanoidRootPart3 then
				return
			end
			task.wait(0.2)
			fn22(character2)

			if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
				fn21()
			end
		end)

		if player.Character then
			fn22(player.Character)

			if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
				fn21()
			end
		end
	end

	do
		local colorCorrectionEffect = nil

		local function fn16()
			if not mainConfig.DarkTheme then
				if colorCorrectionEffect then
					pcall(function()
						colorCorrectionEffect:Destroy()
					end)

					colorCorrectionEffect = nil
				end

				return
			end

			if not colorCorrectionEffect or not colorCorrectionEffect.Parent then
				colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
				colorCorrectionEffect.Name = "BJKDarkTheme"
				colorCorrectionEffect.Parent = Lighting
			end

			local n7 = math.clamp((mainConfig.DarkThemeIntensity or 50) / 100, 0, 1)
			colorCorrectionEffect.Enabled = true
			colorCorrectionEffect.Brightness = (-0.45) * n7
			colorCorrectionEffect.Contrast = 0.08 * n7
			colorCorrectionEffect.Saturation = (-0.12) * n7
		end

		function setDarkTheme(arg)
			mainConfig.DarkTheme = arg and true or false
			local tbl9 = {}
			saveConfig()
			setToggle("Dark Theme", mainConfig.DarkTheme)
			fn16()
		end

		function setDarkThemeIntensity(arg)
			mainConfig.DarkThemeIntensity = math.clamp(math.floor(arg), 0, 100)
			saveConfig()
			fn16()
		end
	end

	function applyUnwalk(arg, arg2)
		if not arg then
			return
		end
		local humanoid2, v9, animate
		humanoid2 = arg:FindFirstChildOfClass("Humanoid")
		v9 = humanoid2 and humanoid2.FindFirstChildOfClass(humanoid2, "Animator")
		animate = arg:FindFirstChild("Animate")

		if arg2 then
			if animate then
				animate.Disabled = true
			end

			if v9 then
				local ok, result = pcall(function()
					return v9.GetPlayingAnimationTracks(v9)
				end)

				if ok and result then
					for i, v10 in ipairs(result) do
						pcall(function()
							v10:Stop(0)
						end)
					end
				end
			end
		else
			if animate then
				animate.Disabled = false
			end
		end
	end

	function setUnwalk(unwalk)
		mainConfig.Unwalk = unwalk
		saveConfig()
		setToggle("Unwalk", unwalk)

		if unwalk then
			task.spawn(function()
				for i = 1, 6 do
					if not mainConfig.Unwalk or player.Character ~= player.Character then
						break
					end
					applyUnwalk(player.Character, true)
					task.wait(0.3)
				end
			end)
		else
			applyUnwalk(player.Character, false)
		end
	end

	_G.setUnwalk = setUnwalk

	player.CharacterAdded:Connect(function(character2)
		task.spawn(function()
			character2:WaitForChild("Humanoid", 10)
			task.wait(0.1)

			if mainConfig.Unwalk then
				for i = 1, 6 do
					if not mainConfig.Unwalk or player.Character ~= character2 then
						break
					end
					applyUnwalk(character2, true)
					task.wait(0.3)
				end
			end
		end)
	end)

	isMyPlot_Instant = function(arg)
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
		if not plotsFolder then
			return false
		end
		local v9 = plotsFolder:FindFirstChild(arg)
		if not v9 then
			return false
		end
		local flag3 = false
		local flag4 = false

		pcall(function()
			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local Synchronizer = packages and require(packages:FindFirstChild("Synchronizer"))

			if Synchronizer then
				local v10 = _G.XenSyncGet(arg)

				if v10 then
					local v11 = _G.sProp(v10, "Owner")

					if v11 then
						flag3 = true

						if typeof(v11) == "Instance" and v11 == player or typeof(v11) == "table" and v11.UserId == player.UserId or typeof(v11) == "number" and v11 == player.UserId or typeof(v11) == "string" and (v11:lower() == player.Name:lower() or v11:lower() == player.DisplayName:lower()) then
							flag4 = true
						end
					end
				end
			end
		end)

		if flag3 then
			return flag4
		end
		local plotSign = v9:FindFirstChild("PlotSign")

		if plotSign then
			local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)

			if surfaceGui then
				local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)

				if textLabel then
					local str = textLabel.Text:lower()
					if str:find(player.DisplayName:lower(), 1, true) or str:find(player.Name:lower(), 1, true) then
						return true
					end
				end
			end
		end

		if plotSign then
			local yourBase = plotSign:FindFirstChild("YourBase")
			if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true then
				return true
			end
		end

		return false
	end

	_G.isMyPlot_Instant = isMyPlot_Instant

	getUnlockHRP = function()
		local character2 = localPlayer2.Character or player.Character
		if not character2 then
			return
		end
		return character2:FindFirstChild("HumanoidRootPart") or character2:FindFirstChild("UpperTorso")
	end

	smartInteract = function(arg)
		local character2 = localPlayer2.Character or player.Character
		local v9 = getUnlockHRP()
		if not character2 or not v9 then
			return
		end
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
		if not plotsFolder then
			return
		end
		local v10, n7 = nil, 40

		for k, child in pairs(plotsFolder:GetChildren()) do
			local position

			if child:IsA("Model") then
				position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
			else
				position = child.Position
			end

			local magnitude = (v9.Position - position).Magnitude

			if magnitude < n7 then
				v10 = child
				n7 = magnitude
			end
		end

		if v10 and v10:FindFirstChild("Unlock") then
			local tbl9 = {}

			for k, child in pairs(v10.Unlock:GetChildren()) do
				local position = child:IsA("Model") and child:GetPivot().Position or child.Position
				table.insert(tbl9, { Obj = child, Y = position.Y })
			end

			table.sort(tbl9, function(arg2, arg3)
				return arg2.Y < arg3.Y
			end)

			if tbl9[arg] then
				for k, descendant in pairs(tbl9[arg].Obj:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") then
						pcall(function()
							fireproximityprompt(descendant)
						end)
					end
				end
			end
		end
	end

	getCurrentUnlockFloor = function()
		local v9 = getUnlockHRP()
		if not v9 then
			return 1
		end
		local y = v9.Position.Y

		if y < 12 then
			return 1
		else
			return 2
		end
	end

	ProximityAPActive = false
	proxAPRing = nil

	function createProxAPRing()
		local bjkProxAPRing = Workspace:FindFirstChild("BJK_ProxAPRing")

		if bjkProxAPRing then
			bjkProxAPRing:Destroy()
		end

		local part = Instance.new("Part")
		part.Name = "BJK_ProxAPRing"
		local tbl9 = {}
		part.Shape = Enum.PartType.Cylinder
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Transparency = 0.7
		part.Color = Color3.fromRGB(255, 40, 40)
		local proximityRange = mainConfig.ProximityRange or 15
		part.Size = Vector3.new(0.2, proximityRange * 2, proximityRange * 2)
		part.Parent = Workspace
		proxAPRing = part
	end

	function destroyProxAPRing()
		if proxAPRing then
			proxAPRing:Destroy()
			proxAPRing = nil
		end

		local bjkProxAPRing = Workspace:FindFirstChild("BJK_ProxAPRing")

		if bjkProxAPRing then
			bjkProxAPRing:Destroy()
		end
	end

	_proxAPRingFrame = 0

	RunService.Heartbeat:Connect(function()
		if not ProximityAPActive then
			return
		end
		_proxAPRingFrame = _proxAPRingFrame + 1
		if _proxAPRingFrame < 2 then
			return
		end
		_proxAPRingFrame = 0
		local character2 = player.Character and player.Character.FindFirstChild(player.Character, "HumanoidRootPart")
		if not character2 or not proxAPRing then
			return
		end
		local proximityRange = mainConfig.ProximityRange or 15
		proxAPRing.Size = Vector3.new(0.2, proximityRange * 2, proximityRange * 2)
		proxAPRing.CFrame = character2.CFrame * CFrame.Angles(0, 0, math.rad(90)) - Vector3.new(0, 2.8, 0)

		if proxAPRing.Material ~= Enum.Material.Neon then
			proxAPRing.Material = Enum.Material.Neon
		end

		if proxAPRing.Transparency > 0.75 then
			proxAPRing.Transparency = 0.7
		end

		proxAPRing.Color = Color3.fromRGB(255, 40, 40)
	end)

	setProximityAP = function(arg)
		ProximityAPActive = arg
		mainConfig.ProximityAP = false
		setToggle("Proximity", arg)

		if arg then
			createProxAPRing()
		else
			destroyProxAPRing()
		end
	end

	onToggleChanged("Proximity", function(arg)
		ProximityAPActive = arg
		mainConfig.ProximityAP = false

		if arg then
			createProxAPRing()
		else
			destroyProxAPRing()
		end
	end)

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			task.wait(0.2)

			if ProximityAPActive then
				local character2 = player.Character and player.Character.FindFirstChild(player.Character, "HumanoidRootPart")

				if character2 then
					for i, player_ in ipairs(Players2:GetPlayers()) do
						if player_ ~= player and player_.Character and player_.Character:FindFirstChild("HumanoidRootPart") then
							if (player_.Character.HumanoidRootPart.Position - character2.Position).Magnitude <= (mainConfig.ProximityRange or 15) then
								local tbl9 = {}

								for i2, v9 in ipairs(AP_ALL_COMMANDS) do
									if mainConfig.AdminPanelButtons and mainConfig.AdminPanelButtons[v9] and not apIsOnCooldown(v9) then
										table.insert(tbl9, v9)
									end
								end

								for i2, v9 in ipairs(tbl9) do
									if not ProximityAPActive then
										break
									end
									runAdminCommand(player_, v9)
									task.wait()
								end
							end
						end
					end
				end
			end
		end
	end)

	task.spawn(function()
		local obj3 = setmetatable({}, { __mode = "k" })

		local function fn16(arg)
			if not mainConfig.AutoResetBalloon or not arg or not arg.Parent then
				return false
			end
			local text = arg.Text
			if text and string.find(text, "ran \"balloon\" on you", 1, true) then
				executeReset(true)
				return true
			end
			return false
		end

		local function fn17(arg)
			if not (arg:IsA("TextLabel") or arg:IsA("TextButton")) then
				return
			end

			if obj3[arg] then
				return
			end
			obj3[arg] = true
			if fn16(arg) then
				return
			end

			arg:GetPropertyChangedSignal("Text"):Connect(function()
				fn16(arg)
			end)
		end

		local function fn18(arg)
			for i, descendant in ipairs(arg:GetDescendants()) do
				fn17(descendant)
			end

			arg.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					fn17(descendant)
				end
			end)
		end

		for i, child in ipairs(playerGui:GetChildren()) do
			fn18(child)
		end

		playerGui.ChildAdded:Connect(function(child)
			fn18(child)
		end)

		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			task.wait(1)
			if not mainConfig.AutoResetBalloon then
				continue
			end

			for k in pairs(obj3) do
				if fn16(k) then
					break
				end
			end
		end
	end)

	task.spawn(function()
		local obj3 = setmetatable({}, { __mode = "k" })

		local function fn16(arg)
			if obj3[arg] then
				return
			end
			obj3[arg] = true
			if mainConfig.AutoKickOnSteal and string.find(string.lower(tostring(arg.Text or "")), "you stole", 1, true) then
				kickPlayer(tostring(arg.Text or ""))
				return
			end

			arg:GetPropertyChangedSignal("Text"):Connect(function()
				if mainConfig.AutoKickOnSteal and string.find(string.lower(tostring(arg.Text or "")), "you stole", 1, true) then
					kickPlayer(tostring(arg.Text or ""))
				end
			end)
		end

		local function fn17(arg)
			for i, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					fn16(descendant)
				end
			end

			arg.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					fn16(descendant)
				end
			end)
		end

		for i, child in ipairs(playerGui:GetChildren()) do
			fn17(child)
		end

		playerGui.ChildAdded:Connect(function(child)
			fn17(child)
		end)
	end)

	task.spawn(function()
		local function fn16(arg)
			local text = (arg:IsA("TextLabel") or arg:IsA("TextButton")) and arg.Text
			if not (text and string.find(text, "You stole")) then
				return
			end

		end

		playerGui.DescendantAdded:Connect(function(descendant)
			fn16(descendant)

			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
				descendant:GetPropertyChangedSignal("Text"):Connect(function()
					fn16(descendant)
				end)
			end
		end)

		for i, descendant in ipairs(playerGui:GetDescendants()) do
			fn16(descendant)
		end
	end)

	task.spawn(function()
		local ok = pcall(function()
			return cloneref(game:GetService("GuiService"))
		end) and cloneref(game:GetService("GuiService")) or game:GetService("GuiService")

		local n7 = 0

		RunService.RenderStepped:Connect(function()
			if not mainConfig.CleanErrorGUIs then
				return
			end
			local now = os.clock()
			if now - n7 < 0.1 then
				return
			end
			n7 = now

			pcall(function()
				ok:ClearError()
			end)
		end)
	end)

	do
		Packages = ReplicatedStorage:WaitForChild("Packages", 10)
		local ok, result, ok2, result2, flag3, flag4, tbl9, uiCorner, uiCorner2, uiCorner3, uiCorner4, uiStroke, uiListLayout
		Datas = Packages and ReplicatedStorage:WaitForChild("Datas", 10) or nil

		ok, result = pcall(function()
			local synchronizer = Packages and Packages:WaitForChild("Synchronizer", 10)
			return synchronizer and require(synchronizer) or nil
		end)

		ok2, result2 = pcall(function()
			local animals = Datas and Datas:WaitForChild("Animals", 10)
			return animals and require(animals) or nil
		end)

		flag3 = ok and type(result) == "table" and result or nil
		flag4 = ok2 and type(result2) == "table" and result2 or nil

		task.spawn(function()
			if not Packages then
				Packages = ReplicatedStorage:WaitForChild("Packages", 30)
			end

			if Packages and not Datas then
				Datas = ReplicatedStorage:WaitForChild("Datas", 30)
			end
		end)

		autoStealEnabled = mainConfig.AutoStealEnabled

		if autoStealEnabled == nil then
			autoStealEnabled = true
		end

		stealHighestEnabled = mainConfig.StealHighest

		if stealHighestEnabled == nil then
			stealHighestEnabled = true
		end

		stealPriorityEnabled = mainConfig.StealPriority
		stealNearestEnabled = mainConfig.StealNearest
		selectedTargetIndex = 1
		selectedTargetUID = nil
		manuallySelectedUID = nil
		currentStealTargetUID = nil
		activeProgressTween = nil
		PromptMemoryCache = {}

		getHRP = function()
			local character2 = localPlayer2.Character
			return character2 and character2:FindFirstChild("HumanoidRootPart")
		end

		tbl9 = { ver = -1, key = nil, out = nil }

		get_all_pets = function(arg)
			local cacheVersion = SharedState.CacheVersion or 0
			local minGenForGrab = mainConfig.StealNearest and mainConfig.TpSettings.MinGenForGrab or mainConfig.TpSettings.MinGenForTp
			local str = arg and "S" or minGenForGrab
			if tbl9.ver == cacheVersion and tbl9.key == str then
				return tbl9.out
			end
			local tbl10 = {}
			local n7 = arg and 0 or parseMinGen(minGenForGrab)
			local name = localPlayer2.Name
			local displayName = localPlayer2.DisplayName
			local tbl11 = {}

			for i, v9 in ipairs(priorityList) do
				tbl11[v9:lower()] = true
			end

			if SharedState.AllAnimalsCache and type(SharedState.AllAnimalsCache) == "table" then
				for i, v9 in ipairs(SharedState.AllAnimalsCache) do
					if v9 and (v9.genValue or 0) >= 1 and v9.owner ~= name and v9.owner ~= displayName then
						local flag5 = (tonumber(v9.genValue) or 0) >= 10000000
						local name2 = v9.name and tbl11[v9.name:lower()] or v9.index and tbl11[v9.index:lower()]

						if flag5 and v9.name then
							SharedState.BrainrotNames[v9.name:lower()] = true
						end

						if n7 > 0 and (tonumber(v9.genValue) or 0) < n7 then
							continue
						end

						table.insert(tbl10, {
							name = v9.name,
							petName = v9.name,
							mpsText = v9.genText,
							mpsValue = tonumber(v9.genValue) or 0,
							petValue = v9.petValue or 0,
							owner = v9.owner,
							plot = v9.plot,
							slot = v9.slot,
							uid = v9.uid,
							mutation = v9.mutation,
							fusing = v9.fusing,
							animalData = v9,
						})
					end
				end
			end

			table.sort(tbl10, function(arg2, arg3)
				return (arg2.mpsValue or 0) > (arg3.mpsValue or 0)
			end)

			tbl9 = { ver = cacheVersion, key = str, out = tbl10 }
			return tbl10
		end

		get_all_pets_by_value = function()
			local tbl10, allAnimalsCache, minGenForGrab, v9, name, displayName
			tbl10 = {}
			allAnimalsCache = SharedState.AllAnimalsCache
			minGenForGrab = mainConfig.StealNearest and mainConfig.TpSettings.MinGenForGrab or mainConfig.TpSettings.MinGenForTp
			v9 = parseMinGen(minGenForGrab)
			name = localPlayer2.Name
			displayName = localPlayer2.DisplayName

			if allAnimalsCache and type(allAnimalsCache) == "table" then
				for i, v10 in ipairs(allAnimalsCache) do
					if v10 and (v10.genValue or 0) >= 1 and v10.owner ~= name and v10.owner ~= displayName then
						if v9 > 0 and (tonumber(v10.genValue) or 0) < v9 then
							continue
						end

						table.insert(tbl10, {
							name = v10.name,
							petName = v10.name,
							mpsText = v10.genText,
							mpsValue = v10.genValue,
							petValue = v10.petValue or 0,
							owner = v10.owner,
							plot = v10.plot,
							slot = v10.slot,
							uid = v10.uid,
							mutation = v10.mutation,
							animalData = v10,
						})
					end
				end
			end

			table.sort(tbl10, function(arg, arg2)
				return (arg.petValue or 0) > (arg2.petValue or 0)
			end)

			return tbl10
		end

		function findProximityPromptForAnimal(arg)
			if not arg then
				return nil
			end
			local v9 = PromptMemoryCache[arg.uid]
			if v9 and v9.Parent then
				return v9
			end
			local v10 = (_G.PlotsFolder or Workspace:FindFirstChild("Plots")):FindFirstChild(arg.plot)
			if not v10 then
				return nil
			end
			local animalPodiums = v10:FindFirstChild("AnimalPodiums")
			if not animalPodiums then
				return nil
			end
			local v11 = _G.XenSyncGet(v10.Name)

			if not v11 then
				local v12 = animalPodiums:FindFirstChild(arg.slot)

				if v12 then
					local base = v12:FindFirstChild("Base")
					local spawn = base and base:FindFirstChild("Spawn")

					if spawn then
						local promptAttachment = spawn:FindFirstChild("PromptAttachment")

						if promptAttachment then
							for i, child in ipairs(promptAttachment:GetChildren()) do
								if child:IsA("ProximityPrompt") then
									PromptMemoryCache[arg.uid] = child
									return child
								end
							end
						end
					end
				end

				return nil
			end

			local AnimalList = v11:Get("AnimalList")
			if not AnimalList then
				return nil
			end
			local str = arg.name and arg.name:lower() or ""
			local slot = arg.slot
			local v12 = nil

			for k, v13 in pairs(AnimalList) do
				if type(v13) == "table" and tostring(k) == slot then
					local index, v14 = v13.Index, flag4[v13.Index]
					if v14 and (v14.DisplayName or index):lower() == str then
						v12 = animalPodiums:FindFirstChild(tostring(k))
						break
					end
				end
			end

			if not v12 then
				v12 = animalPodiums:FindFirstChild(arg.slot)
			end

			if v12 then
				local base = v12:FindFirstChild("Base")
				local spawn = base and base:FindFirstChild("Spawn")

				if spawn then
					local promptAttachment = spawn:FindFirstChild("PromptAttachment")

					if promptAttachment then
						for i, child in ipairs(promptAttachment:GetChildren()) do
							if child:IsA("ProximityPrompt") and child.Enabled and (child.ActionText:lower():find("steal") or child.ActionText == "") then
								PromptMemoryCache[arg.uid] = child
								return child
							end
						end
					end

					local position = spawn.Position
					local x, z = position.X, position.Z
					local v13 = nil
					local huge = math.huge

					for k, descendant in pairs(v10:GetDescendants()) do
						if descendant:IsA("ProximityPrompt") and descendant.Enabled and (descendant.ActionText:lower():find("steal") or descendant.ActionText == "") then
							local parent = descendant.Parent
							local position2 = nil

							if parent and parent:IsA("BasePart") then
								position2 = parent.Position
							elseif parent and parent:IsA("Attachment") and parent.Parent and parent.Parent:IsA("BasePart") then
								position2 = parent.Parent.Position
							end

							if position2 then
								local y = position.Y

								if str:find("la secret combinasion") then
									y = position.Y - 5
								end

								local v14 = math.sqrt((position2.X - x) ^ 2 + (position2.Z - z) ^ 2)

								if v14 < 5 and position2.Y > y then
									local n7 = position2.Y - y

									if n7 < huge then
										huge = n7
										v13 = descendant
									end
								end
							end
						end
					end

					if v13 then
						PromptMemoryCache[arg.uid] = v13
						return v13
					end
				end
			end

			return nil
		end

		function setStealMode(stealMode)
			manuallySelectedUID = nil
			local tbl10 = {}
			stealHighestEnabled = stealMode == "Highest"
			stealPriorityEnabled = stealMode == "Priority"
			stealNearestEnabled = stealMode == "Nearest"
			mainConfig.StealHighest = stealHighestEnabled
			mainConfig.StealPriority = stealPriorityEnabled
			mainConfig.StealNearest = stealNearestEnabled
			mainConfig.StealMode = stealMode
			mainConfig.UsePriority = stealMode ~= "Nearest"
			saveConfig()
			setToggle("Steal Highest", stealHighestEnabled)
			setToggle("Steal Priority", stealPriorityEnabled)
			setToggle("Steal Nearest", stealNearestEnabled)

			if not autoStealEnabled then
				autoStealEnabled = true
				mainConfig.AutoStealEnabled = true
				setToggle("Auto Steal", true)
				saveConfig()

				if _G.BJKAutoSteal then
					pcall(_G.BJKAutoSteal, true)
				end
			end

			if _G.BJKStealMode then
				pcall(_G.BJKStealMode, stealMode)
			end
		end

		hudGui = _G.BJKBuscaGui("BJK_TargetHUD")

		if hudGui then
			hudGui:Destroy()
		end

		hudGui = Instance.new("ScreenGui")
		hudGui.Name = "BJK_TargetHUD"
		hudGui.ResetOnSpawn = false
		hudGui.IgnoreGuiInset = true
		hudGui.DisplayOrder = 998
		hudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		hudGui.Parent = gethui and gethui() or game:GetService("CoreGui")

		STEALBAR = {
			PANEL = Color3.fromRGB(12, 12, 14),
			TEXT = Color3.fromRGB(255, 255, 255),
			STROKE = Color3.fromRGB(52, 52, 58),
			GLOW = Color3.fromRGB(80, 80, 88),
			TRACK = Color3.fromRGB(38, 38, 42),
			TRACK2 = Color3.fromRGB(26, 26, 30),
			FILL1 = Color3.fromRGB(255, 255, 255),
			FILL2 = Color3.fromRGB(200, 200, 208),
		}

		mobileScale = UIS.TouchEnabled and 0.6 or 1
		targetHud = Instance.new("Frame", hudGui)
		targetHud.Name = "BJK_TargetHudFrame"
		targetHud.AnchorPoint = Vector2.new(0.5, 1)
		targetHud.Size = UDim2.new(0, math.floor(260 * mobileScale), 0, math.floor(52 * mobileScale))
		targetHud.Position = UDim2.new(0.5, 0, 1, -270)
		targetHud.BackgroundColor3 = Theme.Panel
		targetHud.BackgroundTransparency = 0.06
		targetHud.BorderSizePixel = 0
		targetHud.ZIndex = 70
		targetHud.Visible = (mainConfig.StealBarUI or false) and (_G.BJK_Ready or not _G.MainConfig.TpSettings.TpOnLoad)
		uiCorner = Instance.new("UICorner", targetHud)
		uiCorner.CornerRadius = UDim.new(0, math.floor(18 * mobileScale))
		hudStroke = Instance.new("UIStroke", targetHud)
		hudStroke.Name = "WhiteOutline"
		hudStroke.Color = Theme.Stroke
		hudStroke.Thickness = 1
		hudStroke.Transparency = 0.9
		hudStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		hudGlow = Instance.new("UIStroke", targetHud)
		hudGlow.Color = Theme.AccentLight
		hudGlow.Thickness = 3
		hudGlow.Transparency = 0.9
		hudGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		hudShadow = Instance.new("ImageLabel", targetHud)
		hudShadow.Name = "Shadow"
		hudShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		hudShadow.Position = UDim2.new(0.5, 0, 0.5, 1)
		hudShadow.Size = UDim2.new(1, 20, 1, 20)
		hudShadow.BackgroundTransparency = 1
		hudShadow.Image = "rbxassetid://6014261993"
		hudShadow.ImageColor3 = Color3.new(0, 0, 0)
		hudShadow.ImageTransparency = 0.72
		hudShadow.ScaleType = Enum.ScaleType.Slice
		hudShadow.SliceCenter = Rect.new(49, 49, 450, 450)
		hudShadow.ZIndex = 69
		hudName = Instance.new("TextLabel", targetHud)
		hudName.Name = "TargetName"
		hudName.Size = UDim2.new(1, -12, 0, 14 * mobileScale)
		hudName.Position = UDim2.fromOffset(6 * mobileScale, 4 * mobileScale)
		hudName.BackgroundTransparency = 1
		hudName.Font = Enum.Font.GothamBold
		hudName.TextSize = 12 * mobileScale
		hudName.TextColor3 = STEALBAR.TEXT
		hudName.TextXAlignment = Enum.TextXAlignment.Center
		hudName.TextTruncate = Enum.TextTruncate.AtEnd
		hudName.ZIndex = 72
		hudName.Text = "No target"
		hudProgressBg = Instance.new("Frame", targetHud)
		hudProgressBg.Name = "ProgressBg"
		hudProgressBg.Size = UDim2.new(1, (-12) * mobileScale, 0, 20 * mobileScale)
		hudProgressBg.Position = UDim2.fromOffset(6 * mobileScale, 23 * mobileScale)
		hudProgressBg.BackgroundColor3 = Theme.SliderBg or Color3.fromRGB(0, 0, 0)
		hudProgressBg.BorderSizePixel = 0
		hudProgressBg.ZIndex = 72
		uiCorner2 = Instance.new("UICorner", hudProgressBg)
		uiCorner2.CornerRadius = UDim.new(0, math.floor(12 * mobileScale))
		hudProgressBgStroke = Instance.new("UIStroke", hudProgressBg)
		hudProgressBgStroke.Color = Theme.Stroke
		hudProgressBgStroke.Thickness = 1
		hudProgressBgStroke.Transparency = 0.9
		hudProgressBgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		hudInnerTrack = Instance.new("Frame", hudProgressBg)
		hudInnerTrack.Name = "InnerTrack"
		hudInnerTrack.Size = UDim2.new(1, -2, 1, -2)
		hudInnerTrack.Position = UDim2.fromOffset(1, 1)
		hudInnerTrack.BackgroundColor3 = Theme.SliderBg or Color3.fromRGB(0, 0, 0)
		hudInnerTrack.BackgroundTransparency = 0
		hudInnerTrack.BorderSizePixel = 0
		hudInnerTrack.ZIndex = 72
		uiCorner3 = Instance.new("UICorner", hudInnerTrack)
		uiCorner3.CornerRadius = UDim.new(0, math.floor(10 * mobileScale))
		hudProgressFill = Instance.new("Frame", hudProgressBg)
		hudProgressFill.Name = "ProgressFill"
		hudProgressFill.Size = UDim2.new(0, 0, 1, 0)
		hudProgressFill.BackgroundColor3 = STEALBAR.FILL1
		hudProgressFill.BorderSizePixel = 0
		hudProgressFill.ZIndex = 73
		local uiCorner5 = Instance.new("UICorner", hudProgressFill)
		uiCorner5.CornerRadius = UDim.new(0, math.floor(12 * mobileScale))
		hudProgressFillGradient = Instance.new("UIGradient", hudProgressFill)

		hudProgressFillGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, STEALBAR.FILL1),
			ColorSequenceKeypoint.new(1, STEALBAR.FILL2),
		})

		hudProgressFillStroke = Instance.new("UIStroke", hudProgressFill)
		hudProgressFillStroke.Color = Color3.fromRGB(0, 0, 0)
		hudProgressFillStroke.Thickness = 1
		hudProgressFillStroke.Transparency = 1
		hudPercent = Instance.new("TextLabel", hudProgressBg)
		hudPercent.Name = "Percent"
		hudPercent.Size = UDim2.new(1, 0, 1, 0)
		hudPercent.BackgroundTransparency = 1
		hudPercent.Font = Enum.Font.GothamBold
		hudPercent.TextSize = 12 * mobileScale
		hudPercent.TextColor3 = Color3.fromRGB(214, 214, 224)
		hudPercent.TextStrokeTransparency = 0.7
		hudPercent.TextXAlignment = Enum.TextXAlignment.Center
		hudPercent.ZIndex = 74
		hudPercent.Text = "0%"
		unlockRow = Instance.new("Frame", hudGui)
		unlockRow.Name = "UnlockFloorButtons"
		unlockRow.AnchorPoint = Vector2.new(0.5, 0)
		unlockRow.Size = UDim2.new(0, math.floor(252 * mobileScale), 0, math.floor(40 * mobileScale))
		unlockRow.Position = UDim2.new(0.5, 0, 1, (-232) + 46 * mobileScale + 14 * mobileScale)
		unlockRow.BackgroundColor3 = Theme.Panel
		unlockRow.BackgroundTransparency = 0.06
		unlockRow.BorderSizePixel = 0
		unlockRow.ZIndex = 70
		unlockRow.Visible = false
		uiCorner4 = Instance.new("UICorner", unlockRow)
		uiCorner4.CornerRadius = UDim.new(0, math.floor(18 * mobileScale))
		uiStroke = Instance.new("UIStroke", unlockRow)
		uiStroke.Color = Theme.Stroke
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.9
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local uiPadding = Instance.new("UIPadding", unlockRow)
		uiPadding.PaddingLeft = UDim.new(0, math.floor(4 * mobileScale))
		uiPadding.PaddingRight = UDim.new(0, math.floor(4 * mobileScale))
		uiPadding.PaddingTop = UDim.new(0, math.floor(4 * mobileScale))
		uiPadding.PaddingBottom = UDim.new(0, math.floor(4 * mobileScale))
		uiListLayout = Instance.new("UIListLayout", unlockRow)
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.Padding = UDim.new(0, math.floor(5 * mobileScale))

		for i = 1, 3 do
			local textButton = Instance.new("TextButton", unlockRow)
			textButton.Name = "UnlockFloor" .. i
			textButton.Size = UDim2.new(0, math.floor(74 * mobileScale), 1, 0)
			textButton.BackgroundColor3 = Theme.Row
			textButton.BackgroundTransparency = 0.1
			textButton.Text = tostring(i)
			textButton.Font = Enum.Font.GothamBold
			textButton.TextSize = math.floor(16 * mobileScale)
			textButton.TextColor3 = Theme.Text
			textButton.AutoButtonColor = false
			textButton.BorderSizePixel = 0
			textButton.ZIndex = 71
			local uiCorner6 = Instance.new("UICorner", textButton)
			uiCorner6.CornerRadius = UDim.new(0, math.floor(12 * mobileScale))
			local uiStroke2 = Instance.new("UIStroke", textButton)
			uiStroke2.Color = Theme.Stroke
			uiStroke2.Thickness = 1
			uiStroke2.Transparency = 0.9

			textButton.MouseButton1Click:Connect(function()
				pcall(smartInteract, i)
			end)

			textButton.MouseEnter:Connect(function()
				tw(textButton, { BackgroundColor3 = Theme.RowHover, BackgroundTransparency = 0.15 })
				tw(uiStroke2, { Color = Theme.Accent, Transparency = 0.2 })
				textButton.TextColor3 = Theme.Text
			end)

			textButton.MouseLeave:Connect(function()
				tw(textButton, { BackgroundColor3 = Theme.Row, BackgroundTransparency = 0.1 })
				tw(uiStroke2, { Color = Theme.Stroke, Transparency = 0.55 })
				textButton.TextColor3 = Theme.Text
			end)
		end

		_G.smartInteract = smartInteract

		_G._earlyStealTargetSpawn = task.spawn(function()
			local n7 = os.clock() + 60

			while type(_G._buildBottomBarEarly) ~= "function" do
				if os.clock() > n7 then
					return
				end
				task.wait(0.05)
			end

			local ok3, result3 = pcall(_G._buildBottomBarEarly)
		end)

		task.spawn(function()
			local n7 = os.clock() + 120

			while not _G.BJK_Ready do
				if os.clock() > n7 then
					return
				end
				task.wait(0.2)
			end

			if unlockRow then
				unlockRow.Visible = mainConfig.UnlockBaseUI or false
			end

			if _G.updateBottomStackLayout then
				pcall(_G.updateBottomStackLayout)
			end
		end)

		local function fn16()
			if not workspace.CurrentCamera then
				return 1
			end
			local y = workspace.CurrentCamera.ViewportSize.Y
			if UIS.TouchEnabled then
				return math.clamp(y / 1000, 0.4, 0.58)
			end
			return math.clamp(y / 800, 0.65, 1)
		end

		local function fn17()
			if not workspace.CurrentCamera then
				return nil
			end
			local viewportSize = workspace.CurrentCamera.ViewportSize
			if viewportSize.Y <= 0 then
				return nil
			end
			local y = nil

			local function fn18(arg)
				if not arg:IsA("GuiObject") or not arg.Visible then
					return
				end

				local ok3, result3, result4 = pcall(function()
					return arg.AbsolutePosition, arg.AbsoluteSize
				end)

				if not ok3 or not result4 or result4.Y < 25 or result4.Y > 115 or result4.X < 20 then
					return
				end
				local n7 = result3.Y + result4.Y

				if n7 >= viewportSize.Y - 35 and n7 <= viewportSize.Y + 20 then
					local n8 = viewportSize.Y - result3.Y

					if n8 >= 35 and n8 <= 115 then
						if not y or result3.Y < y then
							y = result3.Y
						end
					end
				end
			end

			pcall(function()
				local toolsFrames = playerGui:FindFirstChild("ToolsFrames")

				if toolsFrames then
					for i, descendant in ipairs(toolsFrames:GetDescendants()) do
						fn18(descendant)
					end
				end
			end)

			if not y then
				pcall(function()
					for i, child in ipairs(playerGui:GetChildren()) do
						if not child:IsA("ScreenGui") or not child.Enabled then
							continue
						end
						local name = child.Name
						if name == "BJKHub_V3" or name == "BJK_TargetHUD" or name == "BrainrotESP" or name == "BJK_AdminPanel" then
							continue
						end

						for i2, descendant in ipairs(child:GetDescendants()) do
							fn18(descendant)
						end
					end
				end)
			end

			if y and viewportSize.Y - y >= 35 and viewportSize.Y - y <= 115 then
				return y
			end
			return viewportSize.Y - (UIS.TouchEnabled and 68 or 72)
		end

		function _G.updateBottomStackLayout()
			if not workspace.CurrentCamera then
				return
			end
			local viewportSize = workspace.CurrentCamera.ViewportSize
			if viewportSize.Y <= 0 then
				return
			end
			local n7 = type(getGlobalScale) == "function" and getGlobalScale() or GlobalUIScaleVal or 1

			if not n7 or n7 <= 0 then
				n7 = 1
			end

			local n8 = mobileScale or (UIS.TouchEnabled and 0.6 or 1)
			local n9 = UIS.TouchEnabled and 68 or 54
			local n10 = math.floor(52 * n8)
			local v9, n11, n12
			v9 = fn17()
			n11 = viewportSize.Y - (v9 or viewportSize.Y - 72)
			n12 = n11 + 3

			if bottomBar then
				bottomBar.AnchorPoint = Vector2.new(0.5, 1)
				bottomBar.Position = UDim2.new(0.5, 0, 1, -math.floor(n12 / n7))
			end

			local n13 = n9 * n7
			local n14 = n12 + n13

			if targetHud then
				targetHud.AnchorPoint = Vector2.new(0.5, 1)

				if targetHud.Visible then
					local n15 = n14 + 8
					targetHud.Position = UDim2.new(0.5, 0, 1, -math.floor(n15))

					if unlockRow then
						unlockRow.AnchorPoint = Vector2.new(0.5, 1)
						unlockRow.Position = UDim2.new(0.5, 0, 1, -math.floor(n15 + n10 + 8))
					end
				else
					if unlockRow then
						unlockRow.AnchorPoint = Vector2.new(0.5, 1)
						unlockRow.Position = UDim2.new(0.5, 0, 1, -math.floor(n14 + 8))
					end
				end
			elseif unlockRow then
				unlockRow.AnchorPoint = Vector2.new(0.5, 1)
				unlockRow.Position = UDim2.new(0.5, 0, 1, -math.floor(n14 + 8))
			end

			if v9 and _G.__bjkLastInvTop ~= v9 then
				_G.__bjkLastInvTop = v9
			end
		end

		_G.updateBottomStackLayout()

		do
			baseTimerUIEnabled = mainConfig.BaseTimerUI ~= false
			local n7 = mobileScale or 1

			BASETIMER = {
				PANEL = Color3.fromRGB(36, 36, 40),
				STROKE = Color3.fromRGB(52, 52, 58),
				GLOW = Color3.fromRGB(80, 80, 88),
				TEXT = Color3.fromRGB(255, 255, 255),
				DIM = Color3.fromRGB(155, 155, 163),
				BAR = Color3.fromRGB(175, 175, 185),
				TRACK = Color3.fromRGB(38, 38, 42),
				RED = Color3.fromRGB(255, 70, 70),
				GREEN = Color3.fromRGB(110, 220, 130),
			}

			baseTimerHud = Instance.new("Frame", hudGui)
			baseTimerHud.Name = "BaseTimerHUD"
			baseTimerHud.AnchorPoint = Vector2.new(0.5, 0)
			baseTimerHud.Size = UDim2.new(0, math.floor(180 * n7), 0, math.floor(44 * n7))
			baseTimerHud.Position = UDim2.new(0.5, 0, 0, math.floor(12 * n7))
			baseTimerHud.BackgroundColor3 = Theme.Panel
			baseTimerHud.BackgroundTransparency = 0.06
			baseTimerHud.BorderSizePixel = 0
			baseTimerHud.ZIndex = 70
			baseTimerHud.Visible = baseTimerUIEnabled
			Instance.new("UICorner", baseTimerHud).CornerRadius = UDim.new(0, math.floor(18 * n7))
			local uiStroke2 = Instance.new("UIStroke", baseTimerHud)
			uiStroke2.Name = "WhiteOutline"
			uiStroke2.Color = Theme.Stroke
			uiStroke2.Thickness = 1
			uiStroke2.Transparency = 0.9
			uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			local uiStroke3 = Instance.new("UIStroke", baseTimerHud)
			local imageLabel, textLabel, textLabel2, tbl10, fn18
			uiStroke3.Color = Theme.AccentLight
			uiStroke3.Thickness = 3
			uiStroke3.Transparency = 0.9
			uiStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			imageLabel = Instance.new("ImageLabel", baseTimerHud)
			imageLabel.Name = "Shadow"
			imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			imageLabel.Position = UDim2.new(0.5, 0, 0.5, 1)
			imageLabel.Size = UDim2.new(1, 20, 1, 20)
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = "rbxassetid://6014261993"
			imageLabel.ImageColor3 = Color3.new(0, 0, 0)
			imageLabel.ImageTransparency = 0.72
			imageLabel.ScaleType = Enum.ScaleType.Slice
			imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
			imageLabel.ZIndex = 69
			textLabel = Instance.new("TextLabel", baseTimerHud)
			textLabel.Size = UDim2.new(1, (-24) * n7, 0, math.floor(13 * n7))
			textLabel.Position = UDim2.new(0, 12 * n7, 0, math.floor(5 * n7))
			textLabel.BackgroundTransparency = 1
			textLabel.Font = UIFont.Brand
			textLabel.TextSize = math.floor(9 * n7)
			textLabel.TextColor3 = Theme.Text
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			textLabel.Text = "BASE OPEN IN"
			textLabel2 = Instance.new("TextLabel", baseTimerHud)
			textLabel2.Name = "TimeLabel"
			textLabel2.Size = UDim2.new(1, 0, 0, math.floor(20 * n7))
			textLabel2.Position = UDim2.new(0, 0, 0, math.floor(17 * n7))
			textLabel2.BackgroundTransparency = 1
			textLabel2.Font = UIFont.Title
			textLabel2.TextSize = math.floor(19 * n7)
			textLabel2.TextColor3 = BASETIMER.TEXT
			textLabel2.TextXAlignment = Enum.TextXAlignment.Center
			textLabel2.Text = "--:--"
			local frame = Instance.new("Frame", baseTimerHud)
			frame.Name = "AccentBar"
			frame.Size = UDim2.new(1, -math.floor(36 * n7), 0, math.floor(6 * n7))
			frame.Position = UDim2.new(0, math.floor(18 * n7), 1, -math.floor(6 * n7))
			frame.BackgroundColor3 = Theme.Accent
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.ZIndex = 71
			tbl10 = { 0, 0.2, 0.4, 0.6, 0.78, 0.92 }

			for i, v9 in ipairs(tbl10) do
				local frame2 = Instance.new("Frame", frame)
				frame2.Size = UDim2.new(1, 0, 0, math.floor(1 * n7))
				frame2.Position = UDim2.new(0, 0, 0, math.floor((i - 1) * n7))
				frame2.BackgroundColor3 = Theme.Accent
				frame2.BackgroundTransparency = v9
				frame2.BorderSizePixel = 0
			end

			applySavedPosition("BaseTimerUI", baseTimerHud)

			task.spawn(function()
				repeat
					task.wait()
				until makeDraggable

				pcall(function()
					makeDraggable(baseTimerHud, baseTimerHud, "BaseTimerUI", true)
				end)
			end)

			local n8, n9 = 0, 0
			local v9 = nil

			local function fn19(arg)
				if not arg then
					return nil
				end
				local n10 = 0
				local flag5 = false

				for match in tostring(arg):gmatch("%d+") do
					flag5 = true
					n10 = n10 * 60 + tonumber(match)
				end

				if flag5 then
					return n10
				end
				return nil
			end

			local function fn20(arg)
				arg = math.max(0, math.floor(arg))
				return string.format("%d:%02d", math.floor(arg / 60), arg % 60)
			end

			local function fn21(arg)
				textLabel2.TextColor3 = arg and Color3.fromRGB(140, 255, 175) or BASETIMER.TEXT
				local color = arg and Color3.fromRGB(140, 255, 175) or Color3.fromRGB(255, 105, 105)
				frame.BackgroundColor3 = color

				for i, child in ipairs(frame:GetChildren()) do
					if child:IsA("Frame") then
						child.BackgroundColor3 = color
					end
				end
			end

			local function fn22(arg)
				local flag5 = false
				local ok3, result3 = pcall(readPlotChannel, arg.Name)

				if ok3 and result3 then
					pcall(function()
						local function fn23(arg2)
							if arg2 == nil or arg2 == false then
								return false
							end

							if type(arg2) == "number" then
								if arg2 > 100000000 then
									return arg2 > os.time()
								end
								return arg2 > 0
							end

							if type(arg2) == "table" then
								local value = rawget(arg2, "EndTime") or rawget(arg2, "endTime") or rawget(arg2, "Time")
								if type(value) == "number" then
									return value > os.time()
								end
							end

							return true
						end

						flag5 = fn23(readChannelProp(result3, "BlockEndTimeFirstFloor")) or fn23(readChannelProp(result3, "BlockEndTimeSecondFloor")) or fn23(readChannelProp(result3, "BlockEndTime"))
					end)

					if flag5 then
						return false
					end
				end

				local flag6 = false

				pcall(function()
					flag6 = _laserOnFloor(arg, false) or _laserOnFloor(arg, true)
				end)

				return not flag6
			end

			fn18 = function()
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					baseTimerHud.Visible = false
					return
				end
				local v10 = getPlotAtPosition(humanoidRootPart2.Position)
				if not v10 then
					baseTimerHud.Visible = false
					return
				end
				local v11 = nil

				pcall(function()
					v11 = getPlotOwner(v10)
				end)

				if v11 == localPlayer2 then
					baseTimerHud.Visible = false
					return
				end
				local flag5 = false

				pcall(function()
					flag5 = fn22(v10)
				end)

				if flag5 then
					fn21(true)
					textLabel2.Text = "UNLOCKED"
					baseTimerHud.Visible = true
					return
				end

				local v12

				if v9 and v9.Parent and v9:FindFirstChild("RemainingTime") then
					v12 = v9
				else
					v9 = nil
					local huge = math.huge

					for i, descendant in ipairs(v10:GetDescendants()) do
						if descendant:IsA("BillboardGui") and descendant:FindFirstChild("RemainingTime") then
							local adornee = descendant.Adornee or descendant.Parent

							if adornee and adornee:IsA("BasePart") and adornee.Position.Y < huge then
								huge = adornee.Position.Y
								v12 = descendant
							end
						end
					end

					v9 = v12
				end

				if not v12 then
					baseTimerHud.Visible = false
					return
				end
				local remainingTime = v12:FindFirstChild("RemainingTime")
				local v13 = fn19(remainingTime and remainingTime.Text)

				if not v13 or v13 <= 0 then
					fn21(true)
					textLabel2.Text = "UNLOCKED"
					baseTimerHud.Visible = true
					return
				end

				local now = os.clock()

				if v13 ~= n8 then
					n8 = v13
					n9 = now
				end

				fn21(false)
				textLabel2.Text = fn20(n8 - (now - n9))
				baseTimerHud.Visible = true
			end

			_G.setBaseTimerUI = function(baseTimerUI)
				baseTimerUIEnabled = baseTimerUI
				mainConfig.BaseTimerUI = baseTimerUI
				saveConfig()
				setToggle("Base Timer", baseTimerUI)

				if baseTimerHud then
					baseTimerHud.Visible = baseTimerUI
				end
			end

			task.spawn(function()
				while true do
					if _G.BJK_HubGen ~= bjkHubGen then
						break
					end
					task.wait(0.5)

					if not _G.BJK_Ready then
						baseTimerHud.Visible = false
					elseif baseTimerUIEnabled then
						pcall(fn18)
					else
						baseTimerHud.Visible = false
					end
				end
			end)
		end

		task.spawn(function()
			repeat
				task.wait()
			until workspace.CurrentCamera

			local n7 = 0
			local fn18

			fn18 = function()
				local now = os.clock()
				if now - n7 < 0.15 then
					return
				end
				n7 = now
				task.defer(_G.updateBottomStackLayout)
			end

			workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn18)
			playerGui.ChildAdded:Connect(fn18)

			while true do
				task.wait(0.35)

				if _G.updateBottomStackLayout then
					pcall(_G.updateBottomStackLayout)
				end
			end
		end)

		function applySelection(arg, arg2)
			if stealHighestEnabled and arg2 and #arg2 > 0 then
				local n7 = 1
				local mpsValue = arg2[1] and arg2[1].mpsValue or 0

				for i = 2, #arg2 do
					local mpsValue2 = arg2[i].mpsValue or 0

					if mpsValue2 > mpsValue then
						mpsValue = mpsValue2
						n7 = i
					end
				end

				arg = n7
			end

			if arg and arg >= 1 and arg <= #arg2 then
				local uid = arg2[arg].uid

				if selectedTargetIndex ~= arg or selectedTargetUID ~= uid or SharedState.SelectedPetData == nil then
					selectedTargetIndex = arg
					selectedTargetUID = uid
					SharedState.SelectedPetData = arg2[arg]

					if SharedState.SelectedPetData then
						SharedState.LastTargetedPetMpsValue = SharedState.SelectedPetData.mpsValue or 0
					end
				end
			end
		end

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end

				if _G._isTpMoving then
					task.wait(0.25)
				else
					task.wait(0.1)
				end

				if not _G.BJKScannerReady then
					continue
				end

				if autoStealEnabled and (not _G._isTpMoving or not SharedState.SelectedPetData) then
					local v9 = get_all_pets(true)

					if #v9 > 0 then
						if manuallySelectedUID then
							for i, v10 in ipairs(v9) do
								if v10.uid == manuallySelectedUID then
									SharedState.SelectedPetData = v10
									break
								end
							end
						elseif stealHighestEnabled then
							applySelection(1, v9)
						elseif stealPriorityEnabled then
							local v10 = nil

							for i, v11 in ipairs(priorityList) do
								local str = v11:lower()

								for i2, v12 in ipairs(v9) do
									if v12.petName and v12.petName:lower() == str or v12.animalData and v12.animalData.index and v12.animalData.index:lower() == str then
										v10 = i2
										break
									end
								end

								if v10 then
									break
								end
							end

							if v10 then
								applySelection(v10, v9)
							else
								applySelection(1, v9)
							end
						elseif stealNearestEnabled then
							local humanoidRootPart2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

							if humanoidRootPart2 then
								local v10, huge = nil, math.huge

								for i, v11 in ipairs(v9) do
									local animalData = v11.animalData and findAdorneeGlobal(v11.animalData)

									if animalData and animalData:IsA("BasePart") then
										local magnitude = (humanoidRootPart2.Position - animalData.Position).Magnitude

										if magnitude < huge then
											huge = magnitude
											v10 = i
										end
									end
								end

								if v10 then
									applySelection(v10, v9)
								else
									SharedState.SelectedPetData = nil
								end
							else
								applySelection(1, v9)
							end
						else
							applySelection(1, v9)
						end
					elseif not manuallySelectedUID then
						SharedState.SelectedPetData = nil
					end
				elseif not manuallySelectedUID then
					SharedState.SelectedPetData = nil
				end
			end
		end)

		function _pbFmtVal(arg)
			if not arg or arg == 0 then
				return "0"
			end

			if arg >= 1000000000 then
				return string.format("%.2fb", arg / 1000000000)
			end

			if arg >= 1000000 then
				return string.format("%.2fm", arg / 1000000)
			end

			if arg >= 1000 then
				return string.format("%.1fk", arg / 1000)
			end
			return tostring(math.floor(arg))
		end

		RAGBAR_STATES = {
			[Enum.HumanoidStateType.Physics] = true,
			[Enum.HumanoidStateType.Ragdoll] = true,
			[Enum.HumanoidStateType.FallingDown] = true,
			[Enum.HumanoidStateType.GettingUp] = true,
		}

		local n7 = 0
		local flag5, v9 = false, nil

		function checkRagdollBar()
			local now = os.clock()
			if now - n7 < 0.05 then
				return flag5, v9
			end
			local character2, v10
			n7 = now
			character2 = localPlayer2.Character
			v10 = character2 and character2.FindFirstChildOfClass(character2, "Humanoid")
			if not v10 then
				flag5, v9 = false, nil
				return false, nil
			end
			local attribute = localPlayer2:GetAttribute("RagdollEndTime")
			local n8 = attribute and attribute - workspace:GetServerTimeNow() or nil
			if RAGBAR_STATES[v10.GetState(v10)] then
				flag5, v9 = true, n8
				return true, n8
			end

			if n8 and n8 > 0 then
				flag5, v9 = true, n8
				return true, n8
			end
			flag5, v9 = false, nil
			return false, nil
		end

		RAG_RED = Color3.fromRGB(255, 60, 60)
		RAG_ORANGE = Color3.fromRGB(255, 160, 60)
		ragTotalDuration, ragLastEndTime = nil, nil

		task.spawn(function()
			while not _G.BJK_Ready do
				task.wait(0.2)
			end

			pcall(function()
				if targetHud then
					targetHud.Visible = mainConfig.StealBarUI or false
				end
			end)
		end)
	end

	_prioritySoundCooldown = 0

	playPrioritySound = function(arg)
		if not (mainConfig and mainConfig.PrioritySoundID and mainConfig.PrioritySoundID ~= "") then
			return
		end

		if not arg and tick() - _prioritySoundCooldown < 2 then
			return
		end

		if not arg and not (mainConfig and mainConfig.PrioritySoundAlert) then
			return
		end
		local flag3 = false

		if arg then
			flag3 = true
		else
			pcall(function()
				local allAnimalsCache = SharedState and SharedState.AllAnimalsCache

				if allAnimalsCache then
					local tbl9 = {}

					for i, v9 in ipairs(priorityList) do
						tbl9[v9:lower()] = true
					end

					for i, v9 in ipairs(allAnimalsCache) do
						if tbl9[(v9.name or ""):lower()] then
							local plot = v9.plot

							if plot then
								local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
								local v10 = plotsFolder and plotsFolder:FindFirstChild(plot)
								if v10 and getPlotOwner(v10) == localPlayer2 then
									continue
								end
							end

							flag3 = true
							break
						end
					end
				end
			end)
		end

		if not flag3 then
			return
		end
		_prioritySoundCooldown = tick()

		pcall(function()
			local match = mainConfig.PrioritySoundID:match("%d+")

			if match then
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://" .. match
				sound.Volume = mainConfig.PrioritySoundVolume or 1
				sound.Parent = game:GetService("SoundService")
				sound:Play()
				game:GetService("Debris"):AddItem(sound, 5)
			end
		end)
	end

	task.spawn(function()
		local tbl9 = {}
		local flag3 = false

		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			task.wait(0.4)

			if not flag3 then
				if SharedState and SharedState.AllAnimalsCache and #SharedState.AllAnimalsCache > 0 then
					flag3 = true
				else
					continue
				end
			end

			pcall(function()
				local allAnimalsCache = SharedState and SharedState.AllAnimalsCache
				local tbl10 = {}

				for i, v9 in ipairs(priorityList) do
					tbl10[v9:lower()] = true
				end

				local flag4 = false

				if allAnimalsCache then
					for i, v9 in ipairs(allAnimalsCache) do
						if tbl10[(v9.name or ""):lower()] then
							local plot = v9.plot

							if plot then
								local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
								local v10 = plotsFolder and plotsFolder:FindFirstChild(plot)
								if v10 and getPlotOwner(v10) == localPlayer2 then
									continue
								end
							end

							local uid = v9.uid

							if uid and not tbl9[uid .. "|" .. (v9.name or "")] then
								tbl9[uid .. "|" .. (v9.name or "")] = true
								flag4 = true
							end
						end
					end
				end

				pcall(function()
					local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")

					if renderedMovingAnimals then
						local datas = ReplicatedStorage:FindFirstChild("Datas")
						local Animals = datas and require(datas:WaitForChild("Animals", 2))

						for i, child in ipairs(renderedMovingAnimals:GetChildren()) do
							pcall(function()
								if not child:IsA("Model") then
									return
								end
								local v9 = Animals and Animals[child.Name]
								if not v9 then
									return
								end
								local displayName = v9.DisplayName or child.Name

								if tbl10[displayName:lower()] or tbl10[child.Name:lower()] then
									local str = "conveyor_" .. child.Name .. "_" .. tostring(child:GetAttribute("Mutation") or "None")

									if not tbl9[str] then
										tbl9[str] = true
										flag4 = true
									end
								end
							end)
						end
					end
				end)

				if flag4 then
					playPrioritySound()
				end
			end)
		end
	end)

	Players2.PlayerAdded:Connect(function(player_)
		if player_ == localPlayer2 then
			return
		end

		task.spawn(function()
			for i = 1, 20 do
				local ok, result = pcall(function()
					local tbl9 = {}

					for i2, v9 in ipairs(priorityList) do
						tbl9[v9:lower()] = true
					end

					local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
					if not plotsFolder then
						return false
					end

					for i2, child in ipairs(plotsFolder:GetChildren()) do
						if getPlotOwner(child) == player_ then
							local xenSyncGet = _G.XenSyncGet and _G.XenSyncGet(child.Name)

							if xenSyncGet then
								local xenRefresh = _G._xenRefresh and _G._xenRefresh(child.Name)

								if xenRefresh then
									xenSyncGet = xenRefresh
								end

								local AnimalList = xenSyncGet:Get("AnimalList")

								if AnimalList then
									local datas = ReplicatedStorage:FindFirstChild("Datas")
									local Animals = datas and require(datas:WaitForChild("Animals", 2))

									for k, v9 in pairs(AnimalList) do
										if type(v9) == "table" and v9.Index then
											local v10 = Animals and Animals[v9.Index]
											local displayName = v10 and v10.DisplayName or tostring(v9.Index)
											if tbl9[displayName:lower()] or tbl9[tostring(v9.Index):lower()] then
												playPrioritySound()
												return true
											end
										end
									end
								end
							end
						end
					end

					return false
				end)

				if ok and result then
					break
				end
				task.wait(0.5)
			end
		end)
	end)

	ShowPriorityAlertImpl = function(text, text2, arg, arg2, text3)
		if mainConfig and mainConfig.BrainrotAlert == false then
			return
		end
		local str = arg and arg:gsub("%s+", ""):lower() or ""

		local tbl9 = {
			gold = Color3.fromRGB(255, 222, 89),
			diamond = Color3.fromRGB(37, 196, 254),
			bloodrot = Color3.fromRGB(145, 0, 27),
			rainbow = Color3.fromRGB(255, 0, 251),
			candy = Color3.fromRGB(255, 70, 246),
			lava = Color3.fromRGB(255, 149, 0),
			galaxy = Color3.fromRGB(170, 60, 255),
			yinyang = Color3.fromRGB(255, 255, 255),
			radioactive = Color3.fromRGB(104, 245, 0),
			cursed = Color3.fromRGB(245, 56, 56),
			divine = Color3.fromRGB(255, 209, 59),
			cyber = Color3.fromRGB(121, 219, 255),
			normal = Color3.fromRGB(160, 160, 160),
			none = Color3.fromRGB(160, 160, 160),
		}

		local hui = gethui and gethui() or game:GetService("CoreGui")
		local color = tbl9[str] or Color3.fromRGB(120, 205, 255)
		local text4 = ""

		if str ~= "" and str ~= "none" then
			text4 = arg:upper()
		else
			text4 = "NORMAL"
		end

		local bjkPriorityAlert = hui:FindFirstChild("BJK_PriorityAlert")

		if bjkPriorityAlert then
			bjkPriorityAlert:Destroy()
		end

		local screenGui, uiScale, uiGradient, uiCorner, uiStroke, frame, uiGradient2, textLabel, textLabel2, textLabel3, textLabel4, uiStroke2, frame2, uiCorner2, uiGradient3
		screenGui = Instance.new("ScreenGui")
		screenGui.Enabled = true
		screenGui.Name = "BJK_PriorityAlert"
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = 999
		screenGui.Parent = hui
		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(0, 280, 0, 76)
		frame3.Position = UDim2.new(0.5, 0, 0, -110)
		frame3.AnchorPoint = Vector2.new(0.5, 0)
		frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame3.BackgroundTransparency = 0.04
		frame3.BorderSizePixel = 0
		frame3.ClipsDescendants = true
		frame3.Parent = registerScreenGui(screenGui)
		uiScale = Instance.new("UIScale", frame3)
		uiScale.Scale = 0.85
		uiGradient = Instance.new("UIGradient", frame3)

		uiGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 34)),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(15, 15, 20)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14)),
		})

		uiGradient.Rotation = 90
		uiCorner = Instance.new("UICorner", frame3)
		uiCorner.CornerRadius = UDim.new(0, 16)
		uiStroke = Instance.new("UIStroke", frame3)
		uiStroke.Color = Color3.new(1, 1, 1)
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.55
		frame = Instance.new("Frame", frame3)
		frame.Size = UDim2.new(1, 0, 0, 46)
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.BackgroundColor3 = color
		frame.BackgroundTransparency = 0.92
		frame.BorderSizePixel = 0
		frame.ZIndex = 0
		uiGradient2 = Instance.new("UIGradient", frame)
		uiGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
		uiGradient2.Rotation = 90
		textLabel = Instance.new("TextLabel", frame3)
		textLabel.Size = UDim2.new(1, -120, 0, 12)
		textLabel.Position = UDim2.new(0, 18, 0, 12)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text3 or "PRIORITY BRAINROT"
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 9
		textLabel.TextColor3 = color
		textLabel.TextTransparency = 0.15
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		local textLabel5 = Instance.new("TextLabel", frame3)
		textLabel5.Size = UDim2.new(1, -120, 0, 20)
		textLabel5.Position = UDim2.new(0, 18, 0, 25)
		textLabel5.BackgroundTransparency = 1
		textLabel5.Text = text
		textLabel5.Font = Enum.Font.GothamBlack
		textLabel5.TextSize = 16
		textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel5.TextXAlignment = Enum.TextXAlignment.Left
		textLabel5.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel2 = Instance.new("TextLabel", frame3)
		textLabel2.Size = UDim2.new(1, -120, 0, 16)
		textLabel2.Position = UDim2.new(0, 18, 0, 47)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = text2 or ""
		textLabel2.Font = Enum.Font.GothamBlack
		textLabel2.TextSize = 14
		textLabel2.TextColor3 = color
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel3 = Instance.new("TextLabel", frame3)
		textLabel3.Size = UDim2.new(1, -120, 0, 12)
		textLabel3.Position = UDim2.new(0, 18, 0, 66)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Text = "Owner: " .. tostring(arg2)
		textLabel3.Font = Enum.Font.GothamMedium
		textLabel3.TextSize = 10
		textLabel3.TextColor3 = Color3.fromRGB(165, 165, 175)
		textLabel3.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4 = Instance.new("TextLabel", frame3)
		textLabel4.AutomaticSize = Enum.AutomaticSize.X
		textLabel4.Size = UDim2.new(0, 0, 0, 18)
		textLabel4.Position = UDim2.new(1, -12, 0, 12)
		textLabel4.AnchorPoint = Vector2.new(1, 0)
		textLabel4.BackgroundColor3 = color
		textLabel4.BackgroundTransparency = 0.85
		textLabel4.BorderSizePixel = 0
		textLabel4.Text = text4
		textLabel4.Font = Enum.Font.GothamBold
		textLabel4.TextSize = 9
		textLabel4.TextColor3 = color
		local uiPadding = Instance.new("UIPadding", textLabel4)
		uiPadding.PaddingLeft = UDim.new(0, 9)
		uiPadding.PaddingRight = UDim.new(0, 9)
		local uiCorner3 = Instance.new("UICorner", textLabel4)
		uiCorner3.CornerRadius = UDim.new(1, 0)
		uiStroke2 = Instance.new("UIStroke", textLabel4)
		uiStroke2.Color = color
		uiStroke2.Thickness = 1
		uiStroke2.Transparency = 0.75
		frame2 = Instance.new("Frame", frame3)
		frame2.Size = UDim2.new(1, -24, 0, 3)
		frame2.Position = UDim2.new(0.5, 0, 1, -5)
		frame2.AnchorPoint = Vector2.new(0.5, 1)
		frame2.BackgroundColor3 = color
		frame2.BorderSizePixel = 0
		uiCorner2 = Instance.new("UICorner", frame2)
		uiCorner2.CornerRadius = UDim.new(1, 0)
		local frame4 = Instance.new("Frame", frame3)
		frame4.Size = UDim2.new(0, 80, 1, 0)
		frame4.Position = UDim2.new(-0.35, 0, 0, 0)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame4.BackgroundTransparency = 0
		frame4.BorderSizePixel = 0
		frame4.ZIndex = 5
		uiGradient3 = Instance.new("UIGradient", frame4)
		uiGradient3.Rotation = 15

		uiGradient3.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.82),
			NumberSequenceKeypoint.new(1, 1),
		})

		TweenService:Create(frame3, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 22) }):Play()
		TweenService:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

		task.delay(0.35, function()
			if frame4 and frame4.Parent then
				TweenService:Create(frame4, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(1.3, 0, 0, 0) }):Play()

				task.delay(0.85, function()
					if frame4 and frame4.Parent then
						frame4:Destroy()
					end
				end)
			end
		end)

		TweenService:Create(frame2, TweenInfo.new(5.5, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 3) }):Play()

		task.delay(5.5, function()
			if frame3 and frame3.Parent then
				local tbl10 = {}
				TweenService:Create(frame3, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -130) }):Play()
				TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 }):Play()
				task.wait(0.45)

				if screenGui and screenGui.Parent then
					screenGui.Destroy(screenGui)
				end
			end
		end)
	end

	highestAlertedPriorityIndex = 99999

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			task.wait(0.75)
			if not _G.BJK_Ready then
				continue
			end

			pcall(function()
				if not SharedState.AllAnimalsCache or #SharedState.AllAnimalsCache == 0 then
					return
				end
				local v9 = nil
				local n7 = 99999
				local tbl9 = {}

				for i, v10 in ipairs(priorityList) do
					local str = v10:lower()

					if not tbl9[str] then
						tbl9[str] = i
					end
				end

				for i, v10 in ipairs(SharedState.AllAnimalsCache) do
					local v11 = tbl9[v10.name:lower()]

					if v11 and v11 < n7 then
						n7 = v11
						v9 = v10
					end
				end

				if v9 and n7 < highestAlertedPriorityIndex then
					local name = localPlayer2.Name
					local displayName = localPlayer2.DisplayName

					if v9.owner ~= name and v9.owner ~= displayName then
						if not _G._isTpMoving then
							highestAlertedPriorityIndex = n7
							ShowPriorityAlertImpl(v9.name, v9.genText, v9.mutation, v9.owner, "PRIORITY BRAINROT")
						end
					end
				end
			end)
		end
	end)

	task.spawn(function()
		local n7 = os.clock() + 15

		while os.clock() < n7 do
			if SharedState.AllAnimalsCache and #SharedState.AllAnimalsCache > 0 then
				break
			end
			task.wait(0.5)
		end

		local function fn16()
			local name, displayName = localPlayer2.Name, localPlayer2.DisplayName
			local tbl9 = nil

			if SharedState.AllAnimalsCache then
				for i, v9 in ipairs(SharedState.AllAnimalsCache) do
					if v9.owner ~= name and v9.owner ~= displayName then
						if not tbl9 or (v9.genValue or 0) > (tbl9.genValue or 0) then
							tbl9 = v9
						end
					end
				end
			end

			pcall(function()
				local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")
				if not renderedMovingAnimals then
					return
				end
				local datas = ReplicatedStorage:FindFirstChild("Datas")
				local shared_ = ReplicatedStorage:FindFirstChild("Shared")
				local utils = ReplicatedStorage:FindFirstChild("Utils")
				if not (datas and shared_ and utils) then
					return
				end
				local Animals = require(datas:WaitForChild("Animals", 2))
				local NumberUtils_ = require(utils:WaitForChild("NumberUtils", 2))

				for i, child in ipairs(renderedMovingAnimals:GetChildren()) do
					pcall(function()
						if not child:IsA("Model") then
							return
						end
						local v9 = Animals and Animals[child.Name]
						if not v9 then
							return
						end
						local attribute = child:GetAttribute("Mutation") or "None"

						if attribute == "Yin Yang" then
							attribute = "YinYang"
						end

						local n8 = _G._xenAnimShim.GetGeneration(_G._xenAnimShim, child.Name, child:GetAttribute("Mutation"), nil, nil) or 0
						if n8 <= 0 then
							return
						end

						if not tbl9 or n8 > (tbl9.genValue or 0) then
							tbl9 = {
								name = v9.DisplayName or child.Name,
								genText = "$" .. NumberUtils_:ToString(n8) .. "/s",
								genValue = n8,
								mutation = attribute,
								owner = "Conveyor",
							}
						end
					end)
				end
			end)

			return tbl9
		end

		local n8 = -1

		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			local v9 = fn16()

			if v9 and (v9.genValue or 0) > n8 then
				n8 = v9.genValue
				ShowPriorityAlertImpl(v9.name, v9.genText, v9.mutation, v9.owner, "SERVER BEST BRAINROT")
			end

			task.wait(0.75)
		end
	end)

	PRIORITY_LIST = priorityList

	task.spawn(function()
		local ok, result = pcall(function()
			return ReplicatedStorage:WaitForChild("Packages", 2)
		end)

		if not ok or not result then
			return
		end

		local ok2, result2 = pcall(function()
			return ReplicatedStorage:WaitForChild("Datas", 2)
		end)

		if not ok2 or not result2 then
			return
		end

		local ok3, result3 = pcall(function()
			return ReplicatedStorage:WaitForChild("Shared", 2)
		end)

		if not ok3 or not result3 then
			return
		end

		local ok4, result4 = pcall(function()
			return ReplicatedStorage:WaitForChild("Utils", 2)
		end)

		if not ok4 or not result4 then
			return
		end

		local ok5, result5 = pcall(function()
			return require(result:WaitForChild("Synchronizer"))
		end)

		if not ok5 then
			return
		end

		local ok6, result6 = pcall(function()
			return require(result2:WaitForChild("Animals"))
		end)

		if not ok6 then
			return
		end

		local ok7, result7 = pcall(function()
			return require(result4:WaitForChild("NumberUtils"))
		end)

		if not ok7 then
			return
		end
		local allAnimalsCache = {}
		local tbl9 = {}
		local tbl10 = {}
		local n7 = 0

		local function fn16(arg, arg2, arg3)
			local str = arg .. "|" .. tostring(arg2) .. "|" .. (type(arg3) == "table" and #arg3 > 0 and table.concat(arg3, ",") or "")
			local n8 = tbl10[str]
			if n8 ~= nil then
				return n8
			end
			n8 = _G._xenAnimShim.GetGeneration(_G._xenAnimShim, arg, arg2 ~= "None" and arg2 or nil, arg3)

			if not n8 or n8 == 0 then
				n8 = _G._xenAnimShim.GetGeneration(_G._xenAnimShim, arg, "None", nil) or 0
			end

			if n7 < 3000 then
				n7 = n7 + 1
				tbl10[str] = n8
			end

			return n8
		end

		local function fn17(arg)
			if arg == "None" or arg == "" or arg == nil then
				return "NORMAL"
			end
			return arg
		end

		local function fn18(arg)
			if not arg then
				return ""
			end
			local str = ""

			if #arg > 0 then
				for i = 1, #arg do
					local v9 = arg[i]

					if type(v9) == "table" then
						str = str .. tostring(i) .. tostring(v9.Index) .. tostring(v9.UUID or "") .. tostring(v9.Mutation or "") .. tostring(v9.Traits and table.concat(v9.Traits, ",") or "")
					end
				end
			else
				for k, v9 in pairs(arg) do
					if type(v9) == "table" then
						str = str .. tostring(k) .. tostring(v9.Index) .. tostring(v9.Mutation or "") .. tostring(v9.Traits and table.concat(v9.Traits, ",") or "")
					end
				end
			end

			return str
		end

		local tbl11 = {}

		local function fn19(arg)
			pcall(function()
				local n8 = (tbl11[arg.Name] or 0) + 1
				tbl11[arg.Name] = n8
				local v9 = _G.XenSyncGet(arg.Name)

				if not v9 then
					tbl9[arg.Name] = nil

					for i = #allAnimalsCache, 1, -1 do
						if allAnimalsCache[i].plot == arg.Name then
							table.remove(allAnimalsCache, i)
						end
					end

					SharedState.CacheVersion = (SharedState.CacheVersion or 0) + 1
					SharedState.ListNeedsRedraw = true
					return
				end

				if n8 % 10 == 0 then
					local v10 = _G._xenRefresh(arg.Name)

					if v10 then
						v9 = v10
					else
						tbl9[arg.Name] = nil

						for i = #allAnimalsCache, 1, -1 do
							if allAnimalsCache[i].plot == arg.Name then
								table.remove(allAnimalsCache, i)
							end
						end

						SharedState.CacheVersion = (SharedState.CacheVersion or 0) + 1
						SharedState.ListNeedsRedraw = true
						return
					end
				end

				local AnimalList = v9:Get("AnimalList")
				local Owner = v9:Get("Owner")

				if not Owner or not Owner.Name or not Players2:FindFirstChild(Owner.Name) then
					if _G._xenDropCache then
						pcall(_G._xenDropCache, arg.Name)
					end

					tbl9[arg.Name] = nil

					for i = #allAnimalsCache, 1, -1 do
						if allAnimalsCache[i].plot == arg.Name then
							table.remove(allAnimalsCache, i)
						end
					end

					SharedState.CacheVersion = (SharedState.CacheVersion or 0) + 1
					SharedState.ListNeedsRedraw = true
					return
				end

				if not AnimalList then
					tbl9[arg.Name] = nil

					for i = #allAnimalsCache, 1, -1 do
						if allAnimalsCache[i].plot == arg.Name then
							table.remove(allAnimalsCache, i)
						end
					end

					SharedState.CacheVersion = (SharedState.CacheVersion or 0) + 1
					SharedState.ListNeedsRedraw = true
					return
				end

				local name = Owner.Name
				local v10 = fn18(AnimalList)
				if tbl9[arg.Name] == v10 then
					return
				end

				for i = #allAnimalsCache, 1, -1 do
					if allAnimalsCache[i].plot == arg.Name then
						table.remove(allAnimalsCache, i)
					end
				end

				if #AnimalList > 0 then
					for i = 1, #AnimalList do
						local v11 = AnimalList[i]

						if type(v11) == "table" and v11.Index ~= "Empty" and v11.Index ~= nil then
							local index, v12 = v11.Index, result6[v11.Index]
							local displayName = v12 and v12.DisplayName or index
							local mutation = v11.Mutation or "None"

							if mutation == "Yin Yang" then
								mutation = "YinYang"
							end

							local traits = v11.Traits
							local n9 = v12 and fn16(index, mutation, traits) or 0
							local str = "$" .. result7:ToString(n9) .. "/s"
							local flag3 = type(v11.Machine) == "table" and v11.Machine.Type == "Fuse" and v11.Machine.Active == true or false

							table.insert(allAnimalsCache, {
								name = displayName,
								index = index,
								genText = str,
								genValue = n9,
								petValue = 0,
								mutation = fn17(mutation),
								traits = traits and #traits > 0 and table.concat(traits, ", ") or "None",
								owner = name,
								plot = arg.Name,
								slot = tostring(i),
								uid = arg.Name .. "_" .. tostring(i),
								fusing = flag3,
							})
						end
					end
				else
					for k, v11 in pairs(AnimalList) do
						if type(v11) == "table" then
							local index, v12 = v11.Index, result6[v11.Index]

							if v12 then
								local displayName = v12.DisplayName or index
								local mutation = v11.Mutation or "None"

								if mutation == "Yin Yang" then
									mutation = "YinYang"
								end

								local traits = v11.Traits
								local v13 = fn16(index, mutation, traits)
								local str = "$" .. result7:ToString(v13) .. "/s"
								local flag3 = type(v11.Machine) == "table" and v11.Machine.Type == "Fuse" and v11.Machine.Active == true or false

								table.insert(allAnimalsCache, {
									name = displayName,
									index = index,
									genText = str,
									genValue = v13,
									petValue = 0,
									mutation = fn17(mutation),
									traits = traits and #traits > 0 and table.concat(traits, ", ") or "None",
									owner = name,
									plot = arg.Name,
									slot = tostring(k),
									uid = arg.Name .. "_" .. tostring(k),
									fusing = flag3,
								})
							end
						end
					end
				end

				tbl9[arg.Name] = v10

				table.sort(allAnimalsCache, function(arg2, arg3)
					return arg2.genValue > arg3.genValue
				end)

				SharedState.CacheVersion = (SharedState.CacheVersion or 0) + 1
				SharedState.AllAnimalsCache = allAnimalsCache
				SharedState.ListNeedsRedraw = true
			end)
		end

		local function fn20(arg)
			local v9
			local n8 = 0

			while not v9 do
				local ok8, result8 = pcall(function()
					return _G.XenSyncGet(arg.Name)
				end)

				if ok8 and result8 then
					v9 = result8
					break
				end
				n8 = n8 + 1

				if n8 < 40 then
					task.wait(#allAnimalsCache == 0 and 0.03 or 0.12)
				else
					task.wait(1)
				end
			end

			fn19(arg)

			task.spawn(function()
				while arg.Parent do
					local n9 = (_G._bjkCancelTP or _G._isTpMoving) and 1 or 0.9
					task.wait(#allAnimalsCache == 0 and 0.15 or n9)
					fn19(arg)
				end
			end)
		end

		local plots = Workspace:WaitForChild("Plots", 3)

		if plots then
			for i, child in ipairs(plots:GetChildren()) do
				task.spawn(fn20, child)
			end

			SharedState.InitialScanComplete = true

			plots.ChildAdded:Connect(function(child)
				task.spawn(fn20, child)
			end)

			plots.ChildRemoved:Connect(function(child)
				tbl9[child.Name] = nil

				for i = #allAnimalsCache, 1, -1 do
					if allAnimalsCache[i].plot == child.Name then
						table.remove(allAnimalsCache, i)
					end
				end

				SharedState.CacheVersion = (SharedState.CacheVersion or 0) + 1
				SharedState.ListNeedsRedraw = true
			end)
		end

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end
				SharedState.AllAnimalsCache = allAnimalsCache
				local n8 = (_G._bjkCancelTP or _G._isTpMoving) and 1 or 0.9
				task.wait(#allAnimalsCache == 0 and 0.15 or n8)
			end
		end)
	end)

	player:GetAttributeChangedSignal("Stealing"):Connect(function()
		local flag3 = player:GetAttribute("Stealing") == true

		if FloatState.active and flag3 then
			setFloat(false)
		end

		if _G.AutoInvisDuringSteal then
			if flag3 and not _G.invisibleStealEnabled and not _G.bjkInstaResetting and not (os.clock() - (_G._instaResetTime or 0) < 2) and _G._forceInvisToggle then
				local n7 = 0

				pcall(function()
					n7 = _G.BJK_GetInvisDelayMs and _G.BJK_GetInvisDelayMs() or (_G.BJK_InvisDelayEnabled and tonumber(_G.BJK_InvisDelayMs) or 0)
				end)

				if n7 and n7 > 0 then
					_G.BJK_InvisDelaySeq = (_G.BJK_InvisDelaySeq or 0) + 1

					task.delay(n7 / 1000, function()
						if _G.BJK_InvisDelaySeq ~= _G.BJK_InvisDelaySeq then
							return
						end

						if not _G.AutoInvisDuringSteal then
							return
						end

						if not player:GetAttribute("Stealing") then
							return
						end

						if _G.invisibleStealEnabled then
							return
						end

						if _G.bjkInstaResetting or os.clock() - (_G._instaResetTime or 0) < 2 then
							return
						end
						pcall(_G._forceInvisToggle)
					end)
				else
					task.defer(function()
						task.wait(0.2)

						if player:GetAttribute("Stealing") and not _G.invisibleStealEnabled and not _G.bjkInstaResetting and not (os.clock() - (_G._instaResetTime or 0) < 2) then
							pcall(_G._forceInvisToggle)
						end
					end)
				end
			elseif not flag3 and _G.invisibleStealEnabled and _G._forceInvisToggle then
				_G.BJK_InvisDelaySeq = (_G.BJK_InvisDelaySeq or 0) + 1
				task.wait(0.3)

				if not player:GetAttribute("Stealing") then
					pcall(_G._forceInvisToggle)
				end
			end
		end

		if flag3 and mainConfig.AutoUnlockOnSteal then
			local humanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 then
				local v9 = getCurrentUnlockFloor()

				task.spawn(function()
					task.wait(0.1)
					pcall(smartInteract, v9)
				end)
			end
		end
	end)

	player.CharacterAdded:Connect(function()
		task.wait(0.5)

		if FloatState.active then
			removeFloatPlatform()
			createFloatPlatform()
		end
	end)

	findAdorneeGlobal = function(arg)
		if not arg then
			return nil
		end
		local plotsFolder = (_G.PlotsFolder or Workspace:FindFirstChild("Plots")) and (_G.PlotsFolder or Workspace:FindFirstChild("Plots")):FindFirstChild(arg.plot)

		if plotsFolder then
			local animalPodiums = plotsFolder:FindFirstChild("AnimalPodiums")

			if animalPodiums then
				local v9 = animalPodiums:FindFirstChild(arg.slot)

				if v9 then
					local base = v9:FindFirstChild("Base")

					if base then
						local spawn = base:FindFirstChild("Spawn")
						if spawn then
							return spawn
						end
						return base:FindFirstChildWhichIsA("BasePart") or base
					end
				end
			end
		end

		return nil
	end

	SAB_LIVE = SAB_LIVE or function()
		return true
	end

	if not _G.BJK_M2 then
		_G.BJK_M2 = function(arg, arg2, arg3, arg4)
			local n7, n8 = arg - arg3, arg2 - arg4
			return math.sqrt(n7 * n7 + n8 * n8)
		end
	end

	if not _G.BJK_Ping then
		_G.BJK_Ping = function()
			if _G.BJK_PingAdapt ~= true then
				return 0
			end
			local n7 = 0

			pcall(function()
				n7 = localPlayer2:GetNetworkPing() or 0
			end)

			return n7
		end
	end

	if not getChar then
		getChar = function()
			local character2 = localPlayer2.Character
			return character2, character2 and character2:FindFirstChild("HumanoidRootPart"), character2 and character2:FindFirstChildOfClass("Humanoid")
		end
	end

	if not _G.BJK_PrioScore then
		_G.BJK_PrioScore = function(arg, arg2)
			local nameLower

			if type(arg) == "table" then
				nameLower = arg.nameLower or arg.name and tostring(arg.name):lower()
			else
				nameLower = arg and tostring(arg):lower()
			end

			if nameLower and priorityList then
				for i, v9 in ipairs(priorityList) do
					if type(v9) == "string" and v9:lower() == nameLower then
						return (i - 1) * 1000
					end
				end
			end

			return 1000000
		end
	end

	manualTarget = nil
	stealNearest = false
	_msgManSynced = nil
	_G.BJK_StealCommitRange = 10
	isAutoStealing = false
	StealData = setmetatable({}, { __mode = "k" })
	PromptCache = {}
	PromptIdx = setmetatable({}, { __mode = "k" })
	PromptIdxDirty = setmetatable({}, { __mode = "k" })
	PromptIdxConn = setmetatable({}, { __mode = "k" })
	_stealStart = 0
	_stealProgress = 0
	_holdEpoch = 0
	_ragUntil = nil

	_ragUntil = function()
		return math.max(tonumber(localPlayer2:GetAttribute("RagdollEndTime")) or 0, tonumber(_G.BJK_RagdollUntil) or 0)
	end

	_ragBlockedNow = nil

	_ragBlockedNow = function()
		return _ragUntil() - workspace:GetServerTimeNow() + (tonumber(_G.BJK_RagdollLatePad) or 0.1) > 0 or tick() - (tonumber(_G.BJK_RagdollPhysLastT) or 0) < (tonumber(_G.BJK_RagdollPhysWindow) or 0.4)
	end

	_podOf = nil

	_podOf = function(arg)
		if not arg then
			return nil
		end
		local match, v9 = tostring(arg):match("^(.*)_([^_]+)$")
		if not (match and v9) then
			return nil
		end
		local plots = Workspace:FindFirstChild("Plots")
		plots = plots and plots:FindFirstChild(match)
		plots = plots and plots:FindFirstChild("AnimalPodiums")
		return plots and plots:FindFirstChild(v9)
	end

	_grabCB = nil

	_grabCB = function(arg)
		local tbl9 = { hold = {}, trigger = {} }
		local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

		if ok and type(result) == "table" then
			for i, v9 in ipairs(result) do
				if type(v9.Function) == "function" then
					tbl9.hold[#tbl9.hold + 1] = v9.Function
				end
			end
		end

		ok, result = pcall(getconnections, arg.Triggered)

		if ok and type(result) == "table" then
			for i, v9 in ipairs(result) do
				if type(v9.Function) == "function" then
					tbl9.trigger[#tbl9.trigger + 1] = v9.Function
				end
			end
		end

		return tbl9
	end

	_fireTrigger = nil

	_fireTrigger = function(arg, arg2)
		if fireproximityprompt and _G.BJK_StealUseFPP ~= false then
			pcall(fireproximityprompt, arg)
			return
		end

		if arg2 then
			for i, v9 in ipairs(arg2.trigger) do
				task.spawn(v9)
			end

			if #arg2.trigger == 0 and fireproximityprompt then
				pcall(fireproximityprompt, arg)
			end
		end
	end

	_apCache = setmetatable({}, { __mode = "k" })
	_apFromHold = nil

	_apFromHold = function(arg, arg2)
		local v9 = _apCache[arg]
		if v9 ~= nil then
			return v9 or nil
		end

		if debug and debug.getupvalues and arg2 then
			for i, v10 in ipairs(arg2.hold) do
				local ok, result = pcall(debug.getupvalues, v10)

				if ok then
					for k, v11 in pairs(result) do
						if type(v11) == "table" and rawget(v11, "State") ~= nil and rawget(v11, "ProximityPrompt") ~= nil then
							_apCache[arg] = v11
							return v11
						end
					end
				end
			end
		end

		_apCache[arg] = false
		return nil
	end

	_fireHoldForced = nil

	_fireHoldForced = function(arg, arg2)
		if not arg2 or #arg2.hold == 0 then
			return false
		end
		local v9 = _apFromHold(arg, arg2)

		if v9 and v9.State ~= "Steal" then
			local state = v9.State
			v9.State = "Steal"

			for i, v10 in ipairs(arg2.hold) do
				pcall(v10)
			end

			v9.State = state
			return true
		end

		if not v9 and arg and arg.Enabled == false then
			return false
		end

		for i, v10 in ipairs(arg2.hold) do
			task.spawn(v10)
		end

		return true
	end

	_G.BJK_ForceSteal = function(arg)
		if not (arg and arg.Parent and arg.Enabled) then
			return false
		end
		local v9 = _grabCB(arg)
		_fireHoldForced(arg, v9)
		_fireTrigger(arg, v9)
		return true
	end

	isMyPlotMsg = nil

	isMyPlotMsg = function(arg)
		local plots, v9, v10, v11
		plots = Workspace:FindFirstChild("Plots")
		v9 = plots and plots.FindFirstChild(plots, arg)
		v10 = v9 and v9.FindFirstChild(v9, "PlotSign")
		v11 = v10 and v10.FindFirstChild(v10, "YourBase")
		return v11 and v11.IsA(v11, "BillboardGui") and v11.Enabled == true or false
	end

	function findPrompt(arg)
		if not arg then
			return nil
		end

		if arg.isWalking then
			if arg.prompt and arg.prompt.Parent and arg.prompt.Enabled then
				return arg.prompt
			end
			return nil
		end

		local v9 = PromptCache[arg.uid]
		if v9 and v9.Parent and v9.Enabled and v9.ActionText == "Steal" then
			return v9
		end
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			return nil
		end
		local v10 = plots:FindFirstChild(arg.plot)
		if not v10 then
			return nil
		end
		local animalPodiums = v10:FindFirstChild("AnimalPodiums")
		if not animalPodiums then
			return nil
		end
		local v11 = animalPodiums:FindFirstChild(arg.slot)
		if not v11 then
			return nil
		end
		local base = v11:FindFirstChild("Base")
		if not base then
			return nil
		end
		local spawn = base:FindFirstChild("Spawn")
		if not spawn then
			return nil
		end
		local promptAttachment = spawn:FindFirstChild("PromptAttachment")

		if promptAttachment then
			for i, child in ipairs(promptAttachment:GetChildren()) do
				if child:IsA("ProximityPrompt") and child.Enabled and child.ActionText == "Steal" then
					PromptCache[arg.uid] = child
					return child
				end
			end
		end

		local position, v12, huge, tbl9
		position = spawn.Position
		v12, huge = nil, math.huge
		tbl9 = PromptIdx[v10]

		if not tbl9 or PromptIdxDirty[v10] then
			tbl9 = {}

			for i, descendant in ipairs(v10:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					tbl9[#tbl9 + 1] = descendant
				end
			end

			PromptIdx[v10], PromptIdxDirty[v10] = tbl9, nil

			if not PromptIdxConn[v10] then
				local function fn16(descendant)
					if descendant:IsA("ProximityPrompt") then
						PromptIdxDirty[v10] = true
					end
				end

				PromptIdxConn[v10] = {
					v10.DescendantAdded:Connect(fn16),
					v10.DescendantRemoving:Connect(fn16),
				}
			end
		end

		for i, v13 in ipairs(tbl9) do
			if v13.Parent and v13.Enabled and v13.ActionText == "Steal" then
				local parent = v13.Parent
				local position2

				if parent:IsA("BasePart") then
					position2 = parent.Position
				elseif parent:IsA("Attachment") and parent.Parent:IsA("BasePart") then
					position2 = parent.Parent.Position
				end

				if position2 then
					local n7, n8 = position2.X - position.X, position2.Z - position.Z

					if n7 * n7 + n8 * n8 < 25 and position2.Y > position.Y then
						local n9 = position2.Y - position.Y

						if n9 < huge then
							huge = n9
							v12 = v13
						end
					end
				end
			end
		end

		if v12 then
			PromptCache[arg.uid] = v12
		end

		return v12
	end

	_ownerPresent = {}

	for i, player_ in ipairs(Players2:GetPlayers()) do
		_ownerPresent[player_.Name] = true
	end

	Players2.PlayerAdded:Connect(function(player_)
		_ownerPresent[player_.Name] = true
	end)

	Players2.PlayerRemoving:Connect(function(player_)
		_ownerPresent[player_.Name] = nil
	end)

	_stealable = nil

	_stealable = function(arg, arg2)
		if not arg or arg.owner == arg2 then
			return false
		end

		if _G.BJK_SkipLeftOwners == false then
			return true
		end
		return arg.owner ~= nil and _ownerPresent[arg.owner] == true
	end

	resolvePriorityTarget = nil

	resolvePriorityTarget = function()
		stealNearest = mainConfig.StealNearest == true

		if manuallySelectedUID ~= _msgManSynced then
			_msgManSynced = manuallySelectedUID
			manualTarget = nil

			if manuallySelectedUID then
				for i, v9 in ipairs(SharedState and SharedState.AllAnimalsCache or {}) do
					if v9.uid == manuallySelectedUID then
						manualTarget = v9
						break
					end
				end

				if not manualTarget then
					manualTarget = { uid = manuallySelectedUID }
				end
			end
		end

		local name = localPlayer2.Name
		if not SharedState.AllAnimalsCache or type(SharedState.AllAnimalsCache) ~= "table" then
			return nil
		end

		if stealNearest then
			local v9, v10 = getChar()
			local v11 = nil

			if v10 then
				local huge = math.huge
				local position = v10.Position

				for i, v12 in ipairs(SharedState.AllAnimalsCache or {}) do
					if _stealable(v12, name) then
						local v13 = findAdorneeGlobal(v12)

						if v13 then
							local magnitude = (position - v13.Position).Magnitude

							if magnitude < huge then
								huge = magnitude
								v11 = v12
							end
						end
					end
				end
			end

			return v11
		end

		if manualTarget and manualTarget.uid then
			if manualTarget.name == "Camp" then
				return manualTarget
			end

			for i, v9 in ipairs(SharedState.AllAnimalsCache) do
				if v9.uid == manualTarget.uid then
					return v9
				end
			end

			for i, v9 in ipairs(SharedState.WalkingCache or {}) do
				if v9.uid == manualTarget.uid then
					return v9
				end
			end

			return nil
		end

		if manualTarget then
			return manualTarget
		end
		local stealMode = mainConfig.StealMode

		if type(stealMode) == "string" then
			stealMode = stealMode:lower()
		end

		if stealMode == "highest" then
			local bjkParseGen = _G.BJK_ParseGen and _G.BJK_ParseGen(mainConfig.TpSettings and mainConfig.TpSettings.MinGenForTp or "") or 10000000
			local v9, n7 = nil, -math.huge

			for i, v10 in ipairs(SharedState.AllAnimalsCache or {}) do
				if _stealable(v10, name) then
					local n8 = tonumber(v10.genValue) or 0

					if n8 >= bjkParseGen and n8 > n7 then
						n7 = n8
						v9 = v10
					end
				end
			end

			if v9 then
				return v9
			end
			local v10 = nil

			for i, v11 in ipairs(SharedState.AllAnimalsCache or {}) do
				if _stealable(v11, name) then
					if not v10 or (v11.genValue or 0) > (v10.genValue or 0) then
						v10 = v11
					end
				end
			end

			return v10
		end

		if mainConfig.UsePriority ~= false or stealMode == "priority" then
			local v9, huge = nil, math.huge

			for i, v10 in ipairs(SharedState.AllAnimalsCache or {}) do
				if v10 and v10.name and _stealable(v10, name) then
					local v11 = _G.BJK_PrioScore(v10)

					if v11 < huge then
						huge, v9 = v11, v10
					end
				end
			end

			if v9 and huge < 999999 then
				return v9
			end

			if stealMode == "priority" then
				return nil
			end
		end

		local minGenForTp = mainConfig.TpSettings and mainConfig.TpSettings.MinGenForTp or ""
		local bjkParseGen = _G.BJK_ParseGen and _G.BJK_ParseGen(minGenForTp) or 10000000
		local v9 = nil
		local n7 = -math.huge

		for i, v10 in ipairs(SharedState.AllAnimalsCache or {}) do
			if _stealable(v10, name) then
				local n8 = tonumber(v10.genValue) or 0

				if n8 >= bjkParseGen and n8 > n7 then
					n7 = n8
					v9 = v10
				end
			end
		end

		if v9 then
			return v9
		end
		local v10 = nil

		for i, v11 in ipairs(SharedState.AllAnimalsCache or {}) do
			if _stealable(v11, name) then
				if not v10 or (v11.genValue or 0) > (v10.genValue or 0) then
					v10 = v11
				end
			end
		end

		return v10
	end

	_G.BJK_ResolveBest = resolvePriorityTarget
	findNearestPrompt = nil

	findNearestPrompt = function(arg)
		local v9, v10 = getChar()
		if not v10 then
			return
		end
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			return
		end
		arg = arg or resolvePriorityTarget()
		if not arg then
			return
		end
		local position = v10.Position
		local stealRadius = mainConfig.StealRadius or 95

		if arg.isWalking then
			local prompt = arg.prompt

			if prompt and prompt.Parent and prompt.Enabled then
				local model2 = arg.model
				local basePart = model2 and model2.Parent and model2:FindFirstChildWhichIsA("BasePart")

				if basePart then
					local position2 = basePart.Position
					if _G.BJK_M2(position2.X, position2.Z, position.X, position.Z) <= stealRadius then
						return prompt
					end
				end
			end

			return nil
		end

		local v11 = plots:FindFirstChild(arg.plot)
		if not v11 or isMyPlotMsg(v11.Name) then
			return nil
		end
		local animalPodiums, v12, v13, v14
		animalPodiums = v11:FindFirstChild("AnimalPodiums")
		v12 = animalPodiums and animalPodiums.FindFirstChild(animalPodiums, arg.slot)
		v13 = v12 and v12.FindFirstChild(v12, "Base")
		v14 = v13 and v13.FindFirstChild(v13, "Spawn")
		if not v14 then
			return nil
		end
		local position2 = v14.Position
		if _G.BJK_M2(position2.X, position2.Z, position.X, position.Z) > stealRadius then
			return nil
		end
		local v15 = v14.FindFirstChild(v14, "PromptAttachment")
		if not v15 then
			return nil
		end
		local v16

		for i, child in ipairs(v15:GetChildren()) do
			if child:IsA("ProximityPrompt") and child.Enabled and child.ActionText:find("Steal") then
				v16 = child
			end
		end

		return v16
	end

	StealCache = setmetatable({}, { __mode = "k" })
	promptDistXZ = nil

	promptDistXZ = function(arg)
		local character2 = localPlayer2.Character
		local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return nil
		end
		local parent = arg and arg.Parent
		local worldPosition

		if parent then
			if parent:IsA("Attachment") then
				worldPosition = parent.WorldPosition
			elseif parent:IsA("BasePart") then
				worldPosition = parent.Position
			else
				local basePart = parent:FindFirstAncestorWhichIsA("BasePart")

				if basePart then
					worldPosition = basePart.Position
				end
			end
		end

		if not worldPosition then
			return nil
		end
		local position = humanoidRootPart2.Position
		return _G.BJK_M2(worldPosition.X, worldPosition.Z, position.X, position.Z), (worldPosition - position).Magnitude
	end

	_pivotPos = function(arg)
		return arg:GetPivot().Position
	end

	function executeSteal(arg, arg2, arg3)
		if not SAB_LIVE() then
			return
		end

		if isAutoStealing then
			return
		end

		local function fn16()
			return arg3 == true and _G.BJK_StealPreHold ~= false and _G.BJK_TpActive == true and arg2 ~= nil and SharedState._currentTpTarget ~= nil and SharedState._currentTpTarget.uid == arg2
		end

		local v9 = promptDistXZ(arg)
		if v9 and v9 > (mainConfig.StealRadius or 95) and not fn16() then
			return
		end
		local v10 = StealData[arg]

		if not v10 then
			v10 = _grabCB(arg)
			v10.ready = true

			if #v10.hold > 0 and (#v10.trigger > 0 or _G.BJK_StealUseFPP ~= false) then
				StealData[arg] = v10
			end
		end

		if not v10.ready then
			return
		end
		v10.ready = false
		isAutoStealing = true
		_stealStart = tick()

		task.spawn(function()
			local holdDuration = arg.HoldDuration
			arg.HoldDuration = 0
			local n7, flag3 = 0, false
			local huge = _holdEpoch > 0 and tick() - _holdEpoch or math.huge

			if _G.BJK_StealHoldCarry ~= false and arg.Enabled and huge <= (tonumber(_G.BJK_StealCarryMax) or 1.25) then
				n7, flag3 = _holdEpoch, true
			else
				for i, v11 in ipairs(v10.hold) do
					task.spawn(v11)
				end

				n7 = arg.Enabled and tick() or 0

				if n7 > 0 and #v10.hold > 0 then
					_holdEpoch = n7
				end
			end

			local flag4, n8, flag5 = flag3 or #v10.hold > 0, 0, false
			local stealDuration = mainConfig.StealDuration

			if not stealDuration then
				local num = _G.BJK_StealUsePromptHold == true and tonumber(holdDuration) or nil
				stealDuration = (num and num > 0.1 and num or 1.3) + (tonumber(_G.BJK_StealHoldPad) or 0)
			end

			_G.BJK_StealDurNow = stealDuration
			local bjkStealCycleLeft = tonumber(_G.BJK_StealMaxHold) or stealDuration + (tonumber(_G.BJK_StealExtendWindow) or 1.3)
			_G.BJK_StealCycleDur = stealDuration

			pcall(function()
				local tbl9 = {}
				_G.BJK_StealStatus = _G.BJK_StealStatus or {}
				_G.BJK_StealStatus.active = true
				_G.BJK_StealStatus.start = os.clock()
				_G.BJK_StealStatus.duration = stealDuration
			end)

			local now = flag3 and n7 or tick()
			local now2 = tick()

			if flag3 then
				_stealStart = n7
			end

			local v11 = _ragUntil()
			local n9 = (tonumber(_G.BJK_StealPostGrace) or 0) + (v11 > 0 and (tonumber(_G.BJK_RagdollPostGrace) or 0) or 0)
			local flag6, flag7, flag8, flag9 = false, false, false, false
			local n10, n11, n12 = 0, 0, 0
			local n13, n14, flag10 = 0, 0, false
			local flag11, flag12, now3 = false, false, nil
			local n15, flag13, n16, bjkStealCarryT0, n17 = 0, false, 0, 0, 0
			local flag14, now4, connection_ = false, nil, nil
			local v12, v13 = arg, v10
			local v14 = _podOf(arg2)

			local function fn17()
				local v15, v16 = getChar()
				if not v16 then
					return nil
				end

				if v14 and v14.Parent then
					local ok, result = pcall(_pivotPos, v14)
					if ok and result then
						return (result - v16.Position).Magnitude
					end
				end

				local v17, v18 = promptDistXZ(v12)
				return v18
			end

			if _G.BJK_StealReacquire ~= false and arg2 and v14 then
				connection_ = v14.DescendantAdded:Connect(function(descendant)
					if flag14 and descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText or ""):find("Steal") then
						v12, v13 = descendant, _grabCB(descendant)

						pcall(function()
							descendant.HoldDuration = 0
						end)

						for i, v15 in ipairs(v13.hold) do
							task.spawn(v15)
						end

						n7 = descendant.Enabled and tick() or 0

						if n7 > 0 and #v13.hold > 0 then
							_holdEpoch = n7
						end

						local tbl9 = {}
						flag4 = #v13.hold > 0
						flag12, now3, bjkStealCarryT0 = false, nil, 0
						_G.BJK_StealCarryWait = nil
						flag14, now4 = false, nil
						_stealStart = tick()
						now, n12, n11, flag8 = tick(), 0, 0, false
					end
				end)
			end

			repeat
				if manualTarget ~= nil and arg2 ~= nil and manualTarget.uid ~= arg2 then
					flag6 = true
					break
				end

				if localPlayer2:GetAttribute("Stealing") then
					flag7 = true
					break
				end

				if connection_ and not v12.Parent and not flag14 then
					flag14 = true
					now4 = tick()
				end

				local bjkResolveBest = manualTarget == nil and arg2 ~= nil and _G.BJK_StealBestSwitch ~= false and _G.BJK_ResolveBest

				if flag14 then
					_G.BJK_StealInCommitRange = false

					if bjkStealCarryT0 == 0 or tick() - bjkStealCarryT0 > (tonumber(_G.BJK_StealBankRefresh) or 2.5) then
						if _fireHoldForced(v12, v13) then
							bjkStealCarryT0 = tick()
							_holdEpoch = bjkStealCarryT0
						end
					end

					_G.BJK_StealCarryWait = tick() - now4
					_G.BJK_StealCarryT0 = bjkStealCarryT0
					if tick() - now4 > (tonumber(_G.BJK_StealPromptGoneWait) or 6.5) then
						break
					end

					if bjkResolveBest then
						local v15 = _G.BJK_ResolveBest()
						if v15 and v15.uid and v15.uid ~= arg2 then
							flag6 = true
							break
						end
					end

					now = now + (_G.BJK_StealFireInterval or 0.12)
					task.wait(_G.BJK_StealFireInterval or 0.12)
					continue
				end

				if v12.Parent and not v12.Enabled then
					if not now3 then
						now3 = tick()
					end

					_G.BJK_StealInCommitRange = false

					if tick() - n15 > 0.25 then
						n15 = tick()

						if #v13.hold == 0 then
							v13 = _grabCB(v12)
						end

						local flag15 = false

						if _G.BJK_IsBeingStolen then
							for i, v15 in ipairs(SharedState.AllAnimalsCache) do
								if v15 and v15.uid == arg2 then
									local ok, result = pcall(_G.BJK_IsBeingStolen, v15)
									flag15 = ok and result == true
									break
								end
							end
						end

						if flag15 then
							n16 = tick()
						end

						flag13 = flag15 or tick() - n16 < 1
					end

					if bjkStealCarryT0 > 0 and tick() - bjkStealCarryT0 > (tonumber(_G.BJK_StealBankRefresh) or 2.5) then
						bjkStealCarryT0 = 0
					end

					if bjkStealCarryT0 == 0 and _G.BJK_StealPreBank ~= false then
						if _fireHoldForced(v12, v13) then
							bjkStealCarryT0 = tick()
							_holdEpoch = bjkStealCarryT0
						end
					end

					if tick() - n17 > 0.25 then
						n17 = tick()

						if bjkStealCarryT0 == 0 and _G.BJK_StealPreBank ~= false then
							for i, v15 in ipairs(SharedState.AllAnimalsCache) do
								if v15 and v15.uid ~= arg2 and _stealable(v15, localPlayer2.Name) then
									local v16 = findPrompt(v15)

									if v16 and v16.Enabled and v16:GetAttribute("State") == "Steal" then
										local v17 = _grabCB(v16)

										if #v17.hold > 0 then
											for i2, v18 in ipairs(v17.hold) do
												task.spawn(v18)
											end

											bjkStealCarryT0 = tick()
											_holdEpoch = bjkStealCarryT0
											break
										end
									end
								end
							end
						end

						if bjkResolveBest then
							local v15 = _G.BJK_ResolveBest()

							if v15 and v15.uid and v15.uid ~= arg2 then
								local flag15 = false

								for i, v16 in ipairs(SharedState.AllAnimalsCache) do
									if v16 and v16.uid == arg2 then
										flag15 = _stealable(v16, localPlayer2.Name) ~= false
										break
									end
								end

								if not flag15 then
									flag6 = true
								end
							end
						end

						if flag6 then
							break
						end
					end

					if not flag13 and tick() - math.max(now3, n16) > (tonumber(_G.BJK_StealDisabledGrace) or 3) then
						break
					end
					flag12 = true
					_G.BJK_StealCarryWait = tick() - now3
					_G.BJK_StealCarryT0 = bjkStealCarryT0
					local n18 = tonumber(_G.BJK_StealPoll) or 0.03
					_stealStart = bjkStealCarryT0 > 0 and bjkStealCarryT0 or tick()
					now, n12, n11, flag8 = tick(), 0, 0, false
					_G.BJK_StealExtending = false
					_G.BJK_StealCycleLeft = bjkStealCycleLeft
					now2 = now2 + (task.wait(n18) or n18)
					continue
				end

				if flag12 then
					flag12, now3 = false, nil
					_G.BJK_StealCarryWait = nil
					v13 = _grabCB(v12)
					local huge2 = bjkStealCarryT0 > 0 and tick() - bjkStealCarryT0 or math.huge

					if huge2 <= (tonumber(_G.BJK_StealBankUseMax) or 2.3) then
						n7 = bjkStealCarryT0
						now = bjkStealCarryT0
						_stealStart = bjkStealCarryT0
						flag4 = true
					else
						for i, v15 in ipairs(v13.hold) do
							task.spawn(v15)
						end

						n7 = tick()
						flag4 = #v13.hold > 0

						if flag4 then
							_holdEpoch = n7
						end

						now = tick()
						_stealStart = tick()
					end

					bjkStealCarryT0 = 0
					n12, n11, flag8 = 0, 0, false
					n13 = tick() - (tonumber(_G.BJK_StealEntryDelay) or 0.3)
					n10 = math.max(n10, tick() + (tonumber(_G.BJK_StealDropSettle) or 0.5))
				end

				if not flag4 then
					_stealStart = tick()
				end

				local flag15 = _G.BJK_StealUseFPP == false

				if (#v13.hold == 0 or flag15 and #v13.trigger == 0) and n8 < (tonumber(_G.BJK_StealRecapMax) or 40) then
					n8 = n8 + 1
					local v15 = _grabCB(v12)

					if #v15.hold > 0 and (not flag15 or #v15.trigger > 0) then
						v13 = v15

						if not flag4 then
							for i, v16 in ipairs(v15.hold) do
								task.spawn(v16)
							end

							if v12.Enabled then
								n7 = tick()
								_holdEpoch = n7
							end

							flag4 = true
							_stealStart = tick()
							now, n12, n11, flag8 = tick(), 0, 0, false
						end
					end
				end

				local v15, v16 = promptDistXZ(v12)
				local v17 = fn16()
				if v15 and v15 > (mainConfig.StealRadius or 95) and not v17 then
					flag6 = true
					break
				end

				if bjkResolveBest then
					local v18 = _G.BJK_ResolveBest()

					if v18 and v18.uid and v18.uid ~= arg2 then
						local v19 = fn17()
						if n7 == 0 or tick() - n7 < (tonumber(_G.BJK_StealSrvHold) or stealDuration) or v19 and v19 > (tonumber(_G.BJK_StealSwitchNear) or 25) then
							flag6 = true
							break
						end
						local flag16 = false

						for i, v20 in ipairs(SharedState.AllAnimalsCache) do
							if v20 and v20.uid == arg2 then
								flag16 = _stealable(v20, localPlayer2.Name) ~= false
								break
							end
						end

						if not flag16 then
							flag6 = true
							break
						end
					end
				end

				local flag16 = _G.BJK_RagdollStealSync ~= false
				local now5 = tick()

				if flag16 then
					local v18 = _ragUntil()
					local n18 = v18 - workspace:GetServerTimeNow()

					if v18 > v11 + 0.3 and n18 > 0.1 then
						v11 = v18
						now = math.max(now, now5 + n18 - stealDuration + (tonumber(_G.BJK_RagdollLatePad) or 0.1))
						_stealStart = math.max(_stealStart, now)
						n9 = (tonumber(_G.BJK_StealPostGrace) or 0) + (tonumber(_G.BJK_RagdollPostGrace) or 0)
					end
				end

				local flag17 = now5 - now >= stealDuration + n9
				local v18 = flag16 and _ragBlockedNow()

				if flag16 and _G.BJK_RagdollHoldUntilClear ~= false and flag17 and v18 then
					n10 = now5 + (tonumber(_G.BJK_RagdollClearWindow) or 0.35)
				end

				if flag17 and not flag7 and _G.BJK_StealRangeHold ~= false then
					_G.BJK_StealExtending = true
				end

				if n12 == 0 and not v18 and (n7 == 0 or now5 - n7 > (tonumber(_G.BJK_StealSrvHoldMax) or 2.5)) and v12.Parent and v12.Enabled then
					local v19 = _fireHoldForced(v12, v13)
					n7 = tick()
					_holdEpoch = v19 and n7 or 0
					flag4 = #v13.hold > 0
					_stealStart = tick()
					now = math.max(now, tick())
				end

				local v19 = fn17()
				local flag18 = v19 and v19 <= (tonumber(_G.BJK_StealCommitRange) or 10)
				local flag19 = _G.BJK_StealTpGate ~= false and _G.BJK_TpActive == true and SharedState._currentTpTarget ~= nil and SharedState._currentTpTarget.uid == arg2

				if flag11 and not flag19 and _G.BJK_StealTpRearm ~= false then
					local n18 = tonumber(_G.BJK_StealTpRelBar) or 0

					if n18 > 0 then
						now = math.max(now, now5 - (stealDuration + n9) + n18)
						_stealStart = math.max(_stealStart, now)
					end

					n10 = math.max(n10, now5 + (tonumber(_G.BJK_StealTpRelGrace) or 0.75))
				end

				flag11 = flag19

				if flag18 and not flag19 then
					if n13 == 0 then
						n13 = now5
					end
				else
					n13 = 0
				end

				local n18 = tonumber(_G.BJK_BrainrotSnapT) or 0
				local flag20 = n18 > 0 and now5 - n18 < (tonumber(_G.BJK_StealInstaWindow) or 5)
				local v20 = n13

				if flag20 and n18 > v20 then
					v20 = n18
				end

				local bjkInstaSettle = tonumber(_G.BJK_StealEntryDelayInsta)

				if not bjkInstaSettle then
					bjkInstaSettle = tonumber(_G.BJK_InstaSettle) or (tonumber(_G.BJK_InstaSettleStart) or 0.35)
					_G.BJK_InstaSettle = bjkInstaSettle
				end

				local n19 = flag20 and bjkInstaSettle or (tonumber(_G.BJK_StealEntryDelay) or 0.3)
				local flag21 = n13 > 0 and now5 - v20 >= n19
				local bjkStealInCommitRange = flag17 and not flag7 and not v18 and flag18 and not flag19 and flag21 and n7 > 0 and now5 - n7 >= (tonumber(_G.BJK_StealSrvHold) or stealDuration) and now5 - n7 <= (tonumber(_G.BJK_StealSrvHoldMax) or 2.5)
				flag10 = _G.BJK_StealTpHold ~= false and flag19 and not flag7 and n12 == 0 and flag17 and now5 - now2 < (tonumber(_G.BJK_StealTpHoldMax) or 8)

				if bjkStealInCommitRange and n12 == 0 then
					n11, n12 = now5, 1

					if flag20 then
						flag5 = true
					end

					_fireTrigger(v12, v13)
				end

				if bjkStealInCommitRange and not flag9 then
					flag9 = true

					if _G.BJK_StealCommitSettle == true and (not v17 or v16 and v16 <= (tonumber(_G.BJK_StealSettleNear) or 6)) then
						local v21, v22 = getChar()
						local assemblyLinearVelocity = v22 and v22.AssemblyLinearVelocity
						local n20 = tonumber(_G.BJK_StealCommitSettleSpeed) or 30

						if assemblyLinearVelocity and assemblyLinearVelocity.X * assemblyLinearVelocity.X + assemblyLinearVelocity.Z * assemblyLinearVelocity.Z > n20 * n20 then
							pcall(function()
								v22.AssemblyLinearVelocity = Vector3.new(0, assemblyLinearVelocity.Y, 0)
							end)
						end
					end
				end

				if n12 > 0 and not flag7 and now5 - n11 >= (tonumber(_G.BJK_StealCommitWait) or 0.4) then
					flag8 = true
				end

				n14 = 0

				if _G.BJK_StealHoldForSettle ~= false and not flag7 and (n13 > 0 or v18) then
					local n20 = tonumber(_G.BJK_StealCommitFireMargin) or 0.06
					local n21 = 0

					if n12 == 0 then
						if n13 > 0 and not flag21 then
							n21 = v20 + n19 + n20
						end

						if n7 > 0 then
							local n22 = n7 + (tonumber(_G.BJK_StealSrvHold) or stealDuration) + n20

							if n22 > n21 then
								n21 = n22
							end
						end

						local n22 = now + stealDuration + n9 + n20

						if n22 > n21 then
							n21 = n22
						end
					else
						n21 = n11 + (tonumber(_G.BJK_StealCommitWait) or 0.4)
					end

					if n21 > 0 then
						n14 = n21
					end
				end

				_G.BJK_StealInCommitRange = bjkStealInCommitRange
				task.wait(tonumber(_G.BJK_StealPoll) or 0.03)

				if not flag7 and tick() - now >= stealDuration + n9 then
					_G.BJK_StealExtending = true
				end

				local bjkStealCycleLeft2 = bjkStealCycleLeft - (tick() - now)

				if bjkStealCycleLeft2 > 0 then
					_G.BJK_StealCycleLeft = bjkStealCycleLeft2
				else
					local n20 = n14 - tick()

					if flag10 then
						n20 = math.max(n20, now2 + (tonumber(_G.BJK_StealTpHoldMax) or 8) - tick())
					end

					_G.BJK_StealCycleLeft = math.max(n20, 0)
				end
			until not flag14 and not flag10 and not now3 and (tick() - now >= bjkStealCycleLeft or flag8) and tick() >= n10 and tick() >= n14 or not connection_ and not v12.Parent or tick() - now2 > (tonumber(_G.BJK_StealHoldMaxTotal) or 20)

			_G.BJK_StealExtending = false
			_G.BJK_StealInCommitRange = false

			if n12 > 0 or not flag6 then
				_holdEpoch = 0
			end

			do
				local str, v15, bjkStealWhy
				_G.BJK_StealCarryWait = nil
				str = flag7 and "grab" or flag6 and "abort" or tick() - now2 > (tonumber(_G.BJK_StealHoldMaxTotal) or 20) and "cap" or now3 and "carry" or flag14 and "gone" or n12 > 0 and "fired" or "expire"
				v15 = fn17()
				bjkStealWhy = _G.BJK_StealWhy

				if type(bjkStealWhy) ~= "table" then
					bjkStealWhy = {}
					_G.BJK_StealWhy = bjkStealWhy
				end

				bjkStealWhy[#bjkStealWhy + 1] = string.format("%s c=%d pet=%.1f tp=%s en=%s dur=%.2f age=%.2f", str, n12, v15 or -1, tostring(_G.BJK_TpActive), tostring(v12.Parent ~= nil and v12.Enabled), stealDuration, tick() - now2)

				if #bjkStealWhy > 10 then
					table.remove(bjkStealWhy, 1)
				end
			end

			if flag5 and tonumber(_G.BJK_StealEntryDelayInsta) == nil then
				local n18 = tonumber(_G.BJK_InstaSettle) or 0.35

				if flag7 then
					_G.BJK_InstaSettle = math.max(n18 - (tonumber(_G.BJK_InstaSettleDecay) or 0.02), tonumber(_G.BJK_InstaSettleStart) or 0.35)
				else
					_G.BJK_InstaSettle = math.min(n18 + (tonumber(_G.BJK_InstaSettleStep) or 0.1), tonumber(_G.BJK_InstaSettleMax) or 0.45)
				end
			end

			if connection_ then
				pcall(function()
					connection_:Disconnect()
				end)
			end

			if v12.Parent and not flag6 and not flag7 and n12 == 0 then
				local v15 = fn17()

				if v15 and v15 <= (tonumber(_G.BJK_StealCommitRange) or 10) and v12.Enabled and n7 > 0 and tick() - n7 >= (tonumber(_G.BJK_StealSrvHold) or stealDuration) and tick() - n7 <= (tonumber(_G.BJK_StealSrvHoldMax) or 2.5) then
					_fireTrigger(v12, v13)
				end
			end

			if v12.Parent then
				v12.HoldDuration = holdDuration
			end

			v10.ready = true

			pcall(function()
				if _G.BJK_StealStatus then
					_G.BJK_StealStatus.active = false
				end
			end)

			isAutoStealing = false
		end)
	end

	_asAcc, _asResolveDt = 1, 0.03
	_asP, _asFp, _asUid = nil, nil, nil
	_asPre = false
	_pgKey, _pgEntryT = nil, 0
	_pgPingEma, _pgPingJit, _pgPingT = nil, 0, 0
	stealPingSample = nil

	stealPingSample = function()
		local now = tick()
		if now - _pgPingT < (tonumber(_G.BJK_StealPingSampleDt) or 0.25) then
			return
		end
		_pgPingT = now
		local v9 = _G.BJK_Ping()
		if type(v9) ~= "number" or v9 <= 0 then
			return
		end

		if not _pgPingEma then
			_pgPingEma, _pgPingJit = v9, 0
		else
			local n7
			n7 = tonumber(_G.BJK_StealPingEmaAlpha) or 0.25
			_pgPingJit = _pgPingJit + (math.abs(v9 - _pgPingEma) - _pgPingJit) * n7
			_pgPingEma = _pgPingEma + (v9 - _pgPingEma) * n7
		end
	end

	stealPingWindow = nil

	stealPingWindow = function()
		local v9 = _pgPingEma

		if not v9 then
			v9 = _G.BJK_Ping()
		end

		local n7 = (v9 + (tonumber(_G.BJK_StealPingJitterMult) or 1) * (_pgPingJit or 0)) * 1000
		n7 = math.min(n7, tonumber(_G.BJK_StealPingDelayCapMs) or 1000)

		if n7 < (tonumber(_G.BJK_StealPingDelayMinMs) or 0) then
			n7 = 0
		end

		return n7 / 1000
	end

	stealPingGateReady = nil

	stealPingGateReady = function(arg, arg2)
		if _G.BJK_StealPingDelay ~= true then
			return true
		end

		if not arg then
			_pgKey = nil
			return false
		end
		stealPingSample()
		local v9 = promptDistXZ(arg)
		if v9 == nil then
			return true
		end

		if v9 > (mainConfig.StealRadius or 95) then
			_pgKey = nil
			return false
		end
		local v10 = arg2 or arg

		if _pgKey ~= v10 then
			_pgKey = v10
			_pgEntryT = tick()
		end

		return tick() >= _pgEntryT + stealPingWindow()
	end

	_G.BJK_StealPingGateRearm = function()
		if _pgKey ~= nil then
			_pgEntryT = tick()
		end
	end

	_asEdgePrompt, _asEdgeConn = nil, nil

	enableEdgeBurst = function(arg)
		if _G.BJK_K7_OWNS_STEAL == true then
			return
		end

		if _G.BJK_EnableEdgeBurst ~= true then
			return
		end

		if not SAB_LIVE() then
			return
		end

		if not arg or not arg.Parent or not arg.Enabled then
			return
		end

		if not autoStealEnabled and not (_G.BJKCamp and _G.BJKCamp.active) then
			return
		end

		if _G.BJK_StealCarryGate ~= false and localPlayer2:GetAttribute("Stealing") then
			return
		end

		if isAutoStealing then
			return
		end
		local v9 = promptDistXZ(arg)
		if v9 and v9 > (mainConfig.StealRadius or 95) then
			return
		end

		if not stealPingGateReady(arg, _asUid) then
			return
		end
		local v10 = StealCache[arg]

		if not v10 then
			v10 = _grabCB(arg)
			if #v10.hold == 0 and #v10.trigger == 0 then
				return
			end
			StealCache[arg] = v10
		end

		local holdDuration = arg.HoldDuration
		arg.HoldDuration = 0

		for i, v11 in ipairs(v10.hold) do
			pcall(v11)
		end

		for i = 1, tonumber(_G.BJK_EnableEdgeBurstCount) or 8 do
			for i2, v11 in ipairs(v10.trigger) do
				pcall(v11)
			end

			if fireproximityprompt and #v10.trigger == 0 then
				pcall(fireproximityprompt, arg)
			end
		end

		if arg.Parent then
			arg.HoldDuration = holdDuration
		end
	end

	_G.BJK_EdgeBurst = enableEdgeBurst
	armEnableEdge = nil

	armEnableEdge = function(arg)
		if _G.BJK_EnableEdgeBurst ~= true then
			arg = nil
		end

		if arg == _asEdgePrompt then
			return
		end

		if _asEdgeConn then
			pcall(function()
				_asEdgeConn:Disconnect()
			end)

			_asEdgeConn = nil
		end

		_asEdgePrompt = arg
		if not arg then
			return
		end

		_asEdgeConn = arg:GetPropertyChangedSignal("Enabled"):Connect(function()
			if arg == _asEdgePrompt and arg.Enabled then
				enableEdgeBurst(arg)
			end
		end)
	end

	RunService.Heartbeat:Connect(function(deltaTime)
		if _G.BJK_K7_OWNS_STEAL == true then
			return
		end

		if _G.BJKCamp and _G.BJKCamp.active then
			if _G.BJKCamp._mt == nil then
				return
			end
		elseif not autoStealEnabled then
			return
		end

		if isAutoStealing then
			return
		end

		if _G.BJK_StealCarryGate ~= false and localPlayer2:GetAttribute("Stealing") then
			return
		end

		if _G.BJK_StealPingDelay ~= false then
			stealPingSample()
		end

		_asAcc = _asAcc + deltaTime

		if _asAcc >= _asResolveDt or _asP and not _asP.Parent or _asFp and not _asFp.Parent then
			local v9
			_asAcc = 0
			v9 = resolvePriorityTarget()
			_asP = v9 and findNearestPrompt(v9) or nil
			_asPre = false

			if not _asP and _G.BJK_StealPreHold ~= false and _G.BJK_TpActive == true and v9 and v9.uid then
				if SharedState._currentTpTarget and SharedState._currentTpTarget.uid == v9.uid then
					local v10 = findPrompt(v9)

					if v10 then
						local v11, v12 = promptDistXZ(v10)

						if not v12 or v12 <= (tonumber(_G.BJK_StealPreHoldDist) or 95) then
							_asP, _asPre = v10, true
						end
					end
				end
			end

			if not _asP and v9 and v9.uid and _G.BJK_CampCarried ~= false and _G.BJK_IsBeingStolen then
				local ok, result = pcall(_G.BJK_IsBeingStolen, v9)

				if ok and result == true then
					local v10, v11, v12
					v10 = _podOf(v9.uid)
					v11 = v10 and v10.FindFirstChild(v10, "Base")
					v11 = v11 and v11.FindFirstChild(v11, "Spawn")
					v12 = v11 and v11.FindFirstChild(v11, "PromptAttachment")

					if v12 then
						for i, child in ipairs(v12.GetChildren(v12)) do
							if child:IsA("ProximityPrompt") and tostring(child.ActionText or ""):find("Steal") then
								local v13 = promptDistXZ(child)

								if v13 and v13 <= (mainConfig.StealRadius or 95) then
									_asP = child
								end

								break
							end
						end
					end
				end
			end

			armEnableEdge(_asP)
			_asUid = v9 and v9.uid or nil
			_asFp = nil

			if _asP and v9 then
				_asFp = findPrompt(v9)
			end

			_G.BJK_StealTgt = v9 and {
				name = v9.name,
				gen = v9.genValue,
				genText = v9.genText,
				mut = v9.mutation,
				uid = v9.uid,
				traits = v9.traits or v9.Traits,
			} or nil
		end

		if _asP then
			if not _asPre and not stealPingGateReady(_asP, _asUid) then
				return
			end

			if _G.BJK_RagdollStealSync ~= false and not _asPre then
				local v9 = _ragUntil()

				if v9 > 0 then
					local n7 = tonumber(_G.BJK_RagdollPreArm) or (mainConfig.StealDuration or 1.3) - (tonumber(_G.BJK_RagdollLatePad) or 0.1)
					if v9 - workspace:GetServerTimeNow() > n7 then
						return
					end
				end
			end

			executeSteal(_asP, _asUid, _asPre)
		elseif _asUid and _G.BJK_StealPingDelay ~= false then
			local v9 = _podOf(_asUid)
			local base = v9 and v9:FindFirstChild("Base")
			local spawn = base and base:FindFirstChild("Spawn")
			local character2 = localPlayer2.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

			if not (spawn and humanoidRootPart2) then
				_pgKey = nil
			else
				local position, position2 = spawn.Position, humanoidRootPart2.Position

				if _G.BJK_M2(position.X, position.Z, position2.X, position2.Z) > (mainConfig.StealRadius or 95) then
					_pgKey = nil
				end
			end
		else
			_pgKey = nil
		end
	end)

	_G.BJK_FFlagList = {
		{ "DFFlagBrowserTrackerIdTelemetryEnabled", "False" },
		{ "DFFlagPreloadAsyncSupportTexturePack", "True" },
		{ "DFFlagTextureQualityOverrideEnabled", "True" },
		{ "DFFlagVideoCaptureServiceEnabled", "False" },
		{ "DFFlagSampleAndRefreshRakPing", "True" },
		{ "DFFlagRakNetUseSlidingWindow4", "True" },
		{ "DFFlagCoreScriptTelemetry2", "False" },
		{ "DFFlagEnableSoundPreloading", "True" },
		{ "DFFlagOptimizePartsInPart", "True" },
		{ "DFFlagDisableDPIScale", "True" },
		{ "DFFlagDebugPerfMode", "True" },
		{ "DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000" },
		{ "DFIntRakNetClockDriftAdjustmentPerPingMillisecond", "100" },
		{ "DFIntPerformanceControlTextureQualityBestUtility", "-1" },
		{ "DFIntSignalRHubConnectionHeartbeatTimerRateMs", "1000" },
		{ "DFIntMaxReceiveToDeserializeLatencyMilliseconds", "15" },
		{ "DFIntMegaReplicatorNetworkQualityProcessorUnit", "10" },
		{ "DFIntNetworkInDeserializeLimitGameplayMsClient", "6" },
		{ "DFIntSignalRHubConnectionBaseRetryTimeMs", "100" },
		{ "DFIntClientPacketHealthyAllocationPercent", "20" },
		{ "DFIntTelemetryProfilerHundredthsPercentage", "0" },
		{ "DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1" },
		{ "DFIntNetworkInProcessLimitGameplayMsClient", "6" },
		{ "DFIntAnimationLodFacsVisibilityDenominator", "0" },
		{ "DFIntRaknetBandwidthPingSendEveryXSeconds", "1" },
		{ "DFIntSignalRCoreKeepAlivePingPeriodMs", "250" },
		{ "DFIntClientPacketMaxFrameMicroseconds", "200" },
		{ "DFIntSoundServiceCacheCleanupMaxAgeDays", "2" },
		{ "DFIntMaxProcessPacketsStepsPerCyclic", "5000" },
		{ "DFIntClientPacketExcessMicroseconds", "1000" },
		{ "DFIntMaxProcessPacketsStepsAccumulated", "0" },
		{ "DFIntWaitOnUpdateNetworkLoopEndedMS", "100" },
		{ "DFIntLargePacketQueueSizeCutoffMB", "1000" },
		{ "DFIntMaxProcessPacketsJobScaling", "10000" },
		{ "DFIntRakNetNakResendDelayRttPercent", "50" },
		{ "DFIntSignalRCoreServerTimeoutMs", "11100" },
		{ "DFIntDebugFRMQualityLevelOverride", "1" },
		{ "DFIntClientPacketMinMicroseconds", "1" },
		{ "DFIntAnimationLodFacsDistanceMin", "0" },
		{ "DFIntAnimationLodFacsDistanceMax", "0" },
		{ "DFIntWaitOnRecvFromLoopEndedMS", "100" },
		{ "DFIntRakNetNakResendDelayMsMax", "100" },
		{ "DFIntCodecMaxOutgoingFrames", "10000" },
		{ "DFIntSignalRCoreRpcQueueSize", "256" },
		{ "DFIntRakNetMinAckGrowthPercent", "0" },
		{ "DFIntCodecMaxIncomingPackets", "100" },
		{ "DFIntRakNetMtuValue3InBytes", "1200" },
		{ "DFIntRakNetMtuValue1InBytes", "1280" },
		{ "DFIntRakNetMtuValue2InBytes", "1240" },
		{ "DFIntRakNetNakResendDelayMs", "10" },
		{ "DFIntRakNetResendRttMultiple", "1" },
		{ "DFIntMemCacheMaxCapacityMB", "48" },
		{ "DFIntClientPacketMaxDelayMs", "11" },
		{ "DFIntTextureQualityOverride", "0" },
		{ "DFIntRakNetSelectTimeoutMs", "1" },
		{ "DFIntSignalRCoreTimerMs", "750" },
		{ "DFIntConnectionMTUSize", "1260" },
		{ "DFIntMaxFrameBufferSize", "4" },
		{ "DFIntRakNetLoopMs", "1" },
		{ "FIntTaskSchedulerAsyncTasksMinimumThreadCount", "2" },
		{ "FIntRenderMaxShadowAtlasUsageBeforeDownscale", "80" },
		{ "FIntPerformanceTelemetryQueueProcessLimit", "0" },
		{ "FIntRenderShadowMapDepthCacheMemLimit", "192" },
		{ "FIntUITextureMaxRenderTextureSize", "1024" },
		{ "FIntRakNetResendBufferArrayLength", "128" },
		{ "FIntTaskSchedulerAutoThreadLimit", "6" },
		{ "FIntTerrainOTAMaxTextureSize", "1024" },
		{ "FIntOcclusionWorkerThreadCount", "5" },
		{ "FIntTaskSchedulerMaxNumOfJobs", "86" },
		{ "FIntTelemetryProfilerFrequency", "0" },
		{ "FIntRenderLocalLightFadeInMs", "0" },
		{ "FIntDefaultMeshCacheSizeMB", "256" },
		{ "FIntReportDeviceInfoRollout", "0" },
		{ "FIntTaskSchedulerThreadMin", "1" },
		{ "FIntRobloxGuiBlurIntensity", "0" },
		{ "FIntTerrainArraySliceSize", "0" },
		{ "FIntDebugForceMSAASamples", "1" },
		{ "FIntRenderShadowmapBias", "0" },
		{ "FIntFRMMaxGrassDistance", "0" },
		{ "FIntFRMMinGrassDistance", "0" },
		{ "FIntGrassMovementReducedMotionFactor", "0" },
		{ "FIntDebugTextureManagerSkipMips", "7" },
		{ "RenderUseTextureManager224", "False" },
		{ "TextureQualityOverride", "1" },
		{ "TextureQualityOverrideEnabled", "True" },
		{ "PerformanceControlTextureQualityBestUtility", "1" },
		{ "FFlagRenderAllocateShadowMapResourcesOnDemand", "True" },
		{ "FFlagSpecifyNetworkReplicatorScopeForItems", "True" },
		{ "FFlagTaskSchedulerLimitTargetFpsTo2402", "False" },
		{ "DFIntTaskSchedulerTargetFps", "9999" },
		{ "FFlagHandleAltEnterFullscreenManually", "False" },
		{ "FFlagGameBasicSettingsFramerateCap5", "False" },
		{ "FFlagSpecifyNetworkReplicatorScope", "True" },
		{ "FFlagSendRenderFidelityTelemetry2", "False" },
		{ "FFlagRenderGpuTextureCompressor", "True" },
		{ "FFlagBaseThreadPoolUseRuntime2", "True" },
		{ "FFlagCacheTextBoundsInGuiText", "True" },
		{ "FFlagEnableTelemetryService1", "False" },
		{ "FFlagDebugGraphicsPreferD3D11", "True" },
		{ "FFlagPerfDataOnTelemetryV2", "False" },
		{ "FFlagOpenTelemetryEnabled2", "False" },
		{ "FFlagRbxStorageUseMemCache", "True" },
		{ "FFlagDebugForceGenerateHSR", "True" },
		{ "FFlagRenderInitShadowmaps", "True" },
		{ "FFlagFastGPULightCulling3", "True" },
		{ "FFlagDebugSkyGray", "True" },
		{ "FFlagDebugRenderingSetDeterministic", "True" },
		{ "FLogNetwork", "7" },
	}

	_G.BJK_ApplyFFlags = function()
		local value = rawget(getfenv and getfenv(0) or _G, "setfflag") or rawget(_G, "setfflag") or setfflag
		if type(value) ~= "function" then
			return false
		end
		local n7 = 0

		for i, v9 in ipairs(_G.BJK_FFlagList) do
			if pcall(value, v9[1], v9[2]) then
				n7 = n7 + 1
			end
		end

		return n7 > 0
	end

	function setFFlags(arg)
		mainConfig.FFlagsEnabled = arg and true or false
		setToggle("FFlags", mainConfig.FFlagsEnabled)
		saveConfig()

		if mainConfig.FFlagsEnabled and _G.BJK_ApplyFFlags then
			pcall(_G.BJK_ApplyFFlags)
		end
	end

	_G.setFFlags = setFFlags

	function getClosestBaseSign(arg)
		if not arg or not arg:IsA("BasePart") then
			return nil
		end
		local v9 = nil
		local huge = math.huge

		for i, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				local str = tostring(descendant.Text or "")

				if str ~= "" and str:lower():find("base", 1, true) then
					local surfaceGui = descendant:FindFirstAncestorWhichIsA("SurfaceGui")

					if surfaceGui then
						local adornee = surfaceGui.Adornee or surfaceGui.Parent

						if adornee and adornee:IsA("BasePart") then
							local magnitude = (adornee.Position - arg.Position).Magnitude

							if magnitude < huge then
								huge = magnitude
								v9 = adornee
							end
						end
					end
				end
			end
		end

		return v9
	end

	function riseToY(arg, arg2)
		if not arg then
			return
		end
		local now = os.clock()

		while arg.Parent and arg.Position.Y < arg2 do
			local n7 = arg2 - arg.Position.Y
			local n8 = math.clamp(n7 * 20, 280, 310)
			arg.AssemblyLinearVelocity = Vector3.new(arg.AssemblyLinearVelocity.X, n8, arg.AssemblyLinearVelocity.Z)
			if os.clock() - now > 3 then
				break
			end
			RunService.Heartbeat:Wait()
		end

		arg.AssemblyLinearVelocity = Vector3.new(arg.AssemblyLinearVelocity.X, 0, arg.AssemblyLinearVelocity.Z)
	end

	function equipTpToolAndWait(arg)
		if not arg then
			return nil
		end
		local parent, tool, v9
		parent = arg.Parent
		tool = mainConfig.TpSettings.Tool or "Flying Carpet"
		v9 = localPlayer2.Backpack:FindFirstChild(tool) or parent and parent.FindFirstChild(parent, tool)

		if v9 then
			arg:EquipTool(v9)
			task.wait(0.02)
		end

		return v9
	end

	function walkForward(arg)
		local character2 = localPlayer2.Character
		if not character2 then
			return
		end
		local humanoid2 = character2:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
		if not humanoid2 or not humanoidRootPart2 then
			return
		end
		local playerScripts = localPlayer2:WaitForChild("PlayerScripts")

		local ok, result = pcall(function()
			return require(playerScripts:WaitForChild("PlayerModule")):GetControls()
		end)

		if not ok or not result then
			return
		end
		local lookVector = humanoidRootPart2.CFrame.LookVector

		pcall(function()
			result:Disable()
		end)

		local now, connection_
		now = os.clock()

		connection_ = RunService.RenderStepped:Connect(function()
			if not humanoid2 or not humanoid2.Parent or humanoid2.Health <= 0 or not character2.Parent then
				pcall(function()
					connection_.Disconnect(connection_)
				end)

				pcall(function()
					result:Enable()
				end)

				return
			end

			if os.clock() - now >= arg then
				pcall(function()
					connection_.Disconnect(connection_)
				end)

				pcall(function()
					humanoid2:Move(Vector3.zero, false)
				end)

				pcall(function()
					result:Enable()
				end)

				return
			end

			pcall(function()
				humanoid2:Move(lookVector, false)
			end)
		end)
	end

	function waitSecondsHeartbeat(arg)
		local n7 = 0

		while n7 < arg do
			n7 = n7 + RunService.Heartbeat:Wait()
		end
	end

	function waitUntilHeartbeat(arg, arg2)
		local n7 = 0

		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end

			if arg() then
				return true
			end
			local result = RunService.Heartbeat:Wait()
			n7 = n7 + result
			if arg2 and n7 >= arg2 then
				return false
			end
		end
	end

	TP_V2_MED_POINTS = {
		{ name = "MED1", pos = Vector3.new(-410.65, -5.68, -46.1) },
		{ name = "MED2", pos = Vector3.new(-410.91, -5.68, 168.89) },
	}

	TP_V2_SECOND_FLOOR_POINTS = {
		{ name = "TP1", pos = Vector3.new(-488.88, 15, 196.38), facing = "back" },
		{ name = "TP2", pos = Vector3.new(-487.79, 15, 138.13), facing = "front" },
		{ name = "TP3", pos = Vector3.new(-489.38, 15, 89.23), facing = "back" },
		{ name = "TP4", pos = Vector3.new(-489.69, 15, 30.98), facing = "front" },
		{ name = "TP5", pos = Vector3.new(-488.75, 15, -17.95), facing = "back" },
		{ name = "TP6", pos = Vector3.new(-490, 15, -75.9), facing = "front" },
		{ name = "TP7", pos = Vector3.new(-331.75, 15, -75.8), facing = "back" },
		{ name = "TP8", pos = Vector3.new(-329.98, 15, -18.16), facing = "front" },
		{ name = "TP9", pos = Vector3.new(-330.04, 15, 31.14), facing = "back" },
		{ name = "TP10", pos = Vector3.new(-331.28, 15, 88.92), facing = "front" },
		{ name = "TP11", pos = Vector3.new(-330.57, 15, 138.1), facing = "back" },
		{ name = "TP12", pos = Vector3.new(-330.01, 15, 195.96), facing = "front" },
	}

	TP_V2_ALLOWED_BY_MED = {
		MED1 = {
		TP6 = true,
		TP7 = true,
		TP8 = true,
		TP10 = true,
		TP12 = true,
		TP5 = true,
		TP3 = true,
		TP1 = true,
	},
		MED2 = {
		TP1 = true,
		TP2 = true,
		TP4 = true,
		TP6 = true,
		TP7 = true,
		TP9 = true,
		TP11 = true,
		TP12 = true,
	},
	}

	flatDistance = function(arg, arg2)
		return (Vector3.new(arg.X, 0, arg.Z) - Vector3.new(arg2.X, 0, arg2.Z)).Magnitude
	end

	_G._isTargetPlotUnlocked = function(arg)
		local ok, result = pcall(function()
			local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
			if not plotsFolder then
				return false
			end
			local v9 = plotsFolder:FindFirstChild(arg)
			if not v9 then
				return false
			end
			local unlock = v9:FindFirstChild("Unlock")
			if not unlock then
				return true
			end
			local tbl9 = {}

			for k, child in pairs(unlock:GetChildren()) do
				local position = nil

				if child:IsA("Model") then
					pcall(function()
						position = child:GetPivot().Position
					end)
				elseif child:IsA("BasePart") then
					position = child.Position
				end

				if position then
					table.insert(tbl9, { Object = child, Height = position.Y })
				end
			end

			table.sort(tbl9, function(arg2, arg3)
				return arg2.Height < arg3.Height
			end)

			if #tbl9 == 0 then
				return true
			end
			local object = tbl9[1].Object

			for i, descendant in ipairs(object:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") and descendant.Enabled then
					return false
				end
			end

			for i, child in ipairs(object:GetChildren()) do
				if child:IsA("ProximityPrompt") and child.Enabled then
					return false
				end
			end

			return true
		end)

		return ok and result or false
	end

	getClosestBaseSignToPosition = function(arg)
		local v9 = nil
		local huge = math.huge

		for i, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				local str = tostring(descendant.Text or "")

				if str ~= "" and str:lower():find("base", 1, true) then
					local surfaceGui = descendant:FindFirstAncestorWhichIsA("SurfaceGui")

					if surfaceGui then
						local adornee = surfaceGui.Adornee or surfaceGui.Parent

						if adornee and adornee:IsA("BasePart") then
							local magnitude = (adornee.Position - arg).Magnitude

							if magnitude < huge then
								huge = magnitude
								v9 = adornee
							end
						end
					end
				end
			end
		end

		return v9
	end

	getNearestTeleportV2MedPoint = function(arg)
		local v9 = nil
		local huge = math.huge

		for i, v10 in ipairs(TP_V2_MED_POINTS) do
			local v11 = flatDistance(arg, v10.pos)

			if v11 < huge then
				huge = v11
				v9 = v10
			end
		end

		return v9, huge
	end

	getBestTeleportV2SecondFloorPoint = function(arg, arg2)
		local pos = arg and arg.pos
		local name = arg and arg.name
		if not pos or not name then
			return nil
		end
		local v9 = TP_V2_ALLOWED_BY_MED[name]
		if not v9 then
			return nil
		end
		local v10 = nil
		local huge = math.huge
		local huge2 = math.huge

		for i, v11 in ipairs(TP_V2_SECOND_FLOOR_POINTS) do
			if v9[v11.name] then
				local v12 = flatDistance(pos, v11.pos)
				local v13 = flatDistance(arg2, v11.pos)

				if v13 < huge2 or math.abs(v13 - huge2) <= 0.001 and v12 < huge then
					v10 = v11
					huge = v12
					huge2 = v13
				end
			end
		end

		return v10, huge, huge2
	end

	FLY_SPEED = 160
	FLY_RISE_SPEED = 200
	FLY_RAY_DIST = 20
	FLY_TIMEOUT = 15
	FLY_ARRIVE_DIST = 4
	local n7 = 0
	local n8 = 0

	local function fn16()
		local now = os.clock()

		if now - n8 > 0.25 then
			n8 = now

			pcall(function()
				n7 = Players2.LocalPlayer:GetNetworkPing() or 0
			end)
		end

		return math.clamp(3 + n7 * 15, 3, 8)
	end

	flyRayParams = RaycastParams.new()
	flyRayParams.FilterType = Enum.RaycastFilterType.Exclude

	flyForwardTo = function(arg, arg2, arg3, arg4, arg5)
		if not arg or not arg.Parent then
			return false
		end
		local parent = arg.Parent
		local humanoid2 = parent:FindFirstChildOfClass("Humanoid")
		local connection_

		if humanoid2 then
			local animator = humanoid2:FindFirstChildOfClass("Animator")

			if animator then
				connection_ = RunService.Heartbeat:Connect(function()
					pcall(function()
						for i, v9 in ipairs(animator:GetPlayingAnimationTracks()) do
							v9:Stop()
						end
					end)
				end)
			end
		end

		flyRayParams.FilterDescendantsInstances = { parent }
		local flyTPSpeed = arg5 or mainConfig.TpSettings.FlyTPSpeed or FLY_SPEED
		local assemblyLinearVelocity = arg.AssemblyLinearVelocity or Vector3.zero
		local n9 = 0
		local now = os.clock()
		local v9 = now

		local function fn17(arg6, arg7, arg8, arg9)
			return arg6 + (arg7 - arg6) * (1 - math.exp(-arg8 * arg9))
		end

		while arg.Parent do
			local now2 = os.clock()
			if now2 - now > FLY_TIMEOUT then
				break
			end

			if localPlayer2:GetAttribute("Stealing") then
				break
			end
			local n10 = math.clamp(now2 - v9, 0.001, 0.1)
			v9 = now2
			local position = arg.Position
			local vector4 = Vector3.new(arg2.X - position.X, 0, arg2.Z - position.Z)
			local magnitude = vector4.Magnitude
			if magnitude < fn16() then
				break
			end
			local unit = vector4.Unit
			local n11 = math.clamp(flyTPSpeed * 0.18, 12, 34)
			local n12

			if arg2.Y <= 10 then
				n12 = arg2.Y + 3.5

				if arg4 and magnitude <= 60 then
					local n13 = math.clamp((60 - magnitude) / 40, 0, 1)
					n12 = arg2.Y + 3.5 + (arg4 - arg2.Y) * n13
				end

				local n13

				for i, v10 in ipairs({ -3, 0, 3 }) do
					local hit = Workspace:Raycast(position + Vector3.new(0, v10, 0), unit * n11, flyRayParams)

					if hit and hit.Instance and hit.Instance.CanCollide then
						local n14 = hit.Instance.Position.Y + hit.Instance.Size.Y / 2

						if n14 - arg2.Y > 5 then
							n13 = n13 and math.max(n13, n14) or n14
						end
					end
				end

				if n13 then
					n12 = math.max(n12, n13 + 1.5)
				end

				local hit = Workspace:Raycast(position, Vector3.new(0, -15, 0), flyRayParams)

				if hit then
					n12 = math.max(n12, hit.Position.Y + 0.6)
				end

				local hit2 = Workspace:Raycast(position + unit * 5 + Vector3.new(0, 2, 0), Vector3.new(0, -14, 0), flyRayParams)

				if hit2 and hit2.Position.Y > arg2.Y + 2 then
					n12 = math.max(n12, hit2.Position.Y + 0.6)
				end
			else
				n12 = position.Y
				local hit = Workspace:Raycast(position, unit * n11, flyRayParams)
				local hit2 = Workspace:Raycast(position, Vector3.new(0, -12, 0), flyRayParams)

				if hit and hit.Instance and hit.Instance.CanCollide then
					n12 = math.max(n12, hit.Instance.Position.Y + hit.Instance.Size.Y / 2 + 2)
				end

				if hit2 then
					if position.Y - hit2.Position.Y < 5 then
						n12 = math.max(n12, position.Y + 5)
					end

					n12 = math.max(n12, hit2.Position.Y + 2.5)
				end

				if not hit and arg2.Y < position.Y - 3 then
					n12 = math.max(arg2.Y, hit2 and hit2.Position.Y + 2.5 or arg2.Y)
				end
			end

			local n13 = math.clamp((n12 - position.Y) * 2.5, -140, FLY_RISE_SPEED)
			n9 = fn17(n9, n13, 5, n10)
			local n14 = 1

			if magnitude < 38 then
				local n15 = math.clamp(magnitude / 38, 0, 1)
				n15 = n15 * n15 * (3 - 2 * n15)
				n14 = math.max(0.15, n15)
			end

			local n15 = unit * (flyTPSpeed * n14) + Vector3.new(0, n9, 0)
			assemblyLinearVelocity = assemblyLinearVelocity:Lerp(n15, 1 - math.exp(-7 * n10))
			arg.AssemblyLinearVelocity = assemblyLinearVelocity
			arg.AssemblyAngularVelocity = Vector3.zero
			RunService.Heartbeat:Wait()
		end

		if connection_ then
			connection_:Disconnect()
			connection_ = nil
		end

		if not arg.Parent then
			return false
		end
		arg.AssemblyLinearVelocity = Vector3.zero
		arg.AssemblyAngularVelocity = Vector3.zero
		local y = arg4 or arg2.Y
		local vector4 = Vector3.new(arg2.X, y, arg2.Z)
		arg.CFrame = CFrame.lookAt(vector4, vector4 + (arg3 or arg.CFrame.LookVector))
		arg.AssemblyLinearVelocity = Vector3.zero
		return true
	end

	prepMiniTpTool = function(arg, arg2)
		if not arg or not arg2 then
			return
		end
	end

	getTargetPetData = function()
		if not SharedState.AllAnimalsCache or #SharedState.AllAnimalsCache == 0 then
			return nil
		end
		local v9 = get_all_pets()
		local stealMode = mainConfig.StealMode or "Highest"

		if manuallySelectedUID then
			for i, v10 in ipairs(SharedState.AllAnimalsCache) do
				if v10.uid == manuallySelectedUID and v10.owner ~= localPlayer2.Name then
					return v10
				end
			end
		end

		if stealMode == "Priority" then
			for i, v10 in ipairs(priorityList) do
				local str = v10:lower()
				local v11 = nil
				local huge = math.huge

				for i2, v12 in ipairs(SharedState.AllAnimalsCache) do
					if v12 and v12.name and (v12.name:lower() == str or v12.index and v12.index:lower() == str) and v12.owner ~= localPlayer2.Name then
						local huge2 = math.huge
						local character2 = localPlayer2.Character
						local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart2 then
							local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
							local v13 = plotsFolder and plotsFolder:FindFirstChild(v12.plot)

							if v13 then
								local position = nil

								pcall(function()
									position = v13:GetPivot().Position
								end)

								if position then
									huge2 = (humanoidRootPart2.Position - position).Magnitude
								end
							end
						end

						if not v11 then
							v11 = v12
							huge = huge2
						else
							local genValue = v12.genValue or 0
							local genValue2 = v11.genValue or 0

							if genValue > genValue2 then
								v11 = v12
								huge = huge2
							elseif genValue == genValue2 then
								if huge2 < huge then
									v11 = v12
									huge = huge2
								end
							end
						end
					end
				end

				if v11 then
					return v11
				end
			end

			local minGenForGrab = mainConfig.StealNearest and mainConfig.TpSettings.MinGenForGrab or mainConfig.TpSettings.MinGenForTp
			local n9 = parseMinGen(minGenForGrab) or 10000000
			local v10 = nil
			local n10 = -math.huge

			for i, v11 in ipairs(SharedState.AllAnimalsCache) do
				if v11 and v11.owner ~= localPlayer2.Name and v11.genValue and v11.genValue >= n9 then
					local n11 = tonumber(v11.genValue) or 0

					if n11 > n10 then
						n10 = n11
						v10 = v11
					end
				end
			end

			if v10 then
				return v10
			end
		end

		if stealMode == "Highest" then
			if v9 and #v9 > 0 then
				return v9[1].animalData
			end
		end

		if stealMode == "Priority" then
			if v9 and #v9 > 0 then
				return v9[1].animalData
			end
			return nil
		end

		if SharedState.SelectedPetData then
			return SharedState.SelectedPetData.animalData
		end
		return nil
	end

	do
		UPPER = {
			B = {
			{ coord = Vector3.new(-487.921448, 16.850713, -75.768013), facing = "NORTH" },
			{ coord = Vector3.new(-332.37973, 16.850722, -75.7621), facing = "NORTH" },
			{ coord = Vector3.new(-487.134918, 16.850713, -18.094154), facing = "SOUTH" },
			{ coord = Vector3.new(-316.300171, 16.850713, -17.845898), facing = "SOUTH" },
		},
			C = {
			{ coord = Vector3.new(-330.765381, 16.850713, 31.424425), facing = "NORTH" },
			{ coord = Vector3.new(-502.989349, 16.850713, 31.17243), facing = "NORTH" },
			{ coord = Vector3.new(-489.077087, 16.850713, 89.010147), facing = "SOUTH" },
			{ coord = Vector3.new(-330.908936, 16.850713, 88.930145), facing = "SOUTH" },
		},
			D = {
			{ coord = Vector3.new(-331.264893, 16.850713, 138.209167), facing = "NORTH" },
			{ coord = Vector3.new(-487.935181, 16.850713, 138.026321), facing = "NORTH" },
			{ coord = Vector3.new(-487.774933, 16.850713, 195.882538), facing = "SOUTH" },
			{ coord = Vector3.new(-330.799133, 16.850575, 196.022354), facing = "SOUTH" },
		},
		}

		LOWER = {
			B = {
			{ coord = Vector3.new(-335.725586, -3.048217, -74.984589), facing = "NORTH" },
			{ coord = Vector3.new(-503.214233, -3.048217, -75.043137), facing = "NORTH" },
			{ coord = Vector3.new(-483.619385, -3.71843, -18.844337), facing = "SOUTH" },
			{ coord = Vector3.new(-316.147095, -3.048218, -18.818844), facing = "SOUTH" },
		},
			C = {
			{ coord = Vector3.new(-335.985413, -3.048218, 32.051426), facing = "NORTH" },
			{ coord = Vector3.new(-503.277008, -3.048217, 31.956175), facing = "NORTH" },
			{ coord = Vector3.new(-483.74939, -3.048218, 88.147003), facing = "SOUTH" },
			{ coord = Vector3.new(-315.793823, -3.048217, 88.163979), facing = "SOUTH" },
		},
			D = {
			{ coord = Vector3.new(-335.476654, -3.048218, 139.001083), facing = "NORTH" },
			{ coord = Vector3.new(-503.710083, -3.048218, 138.989883), facing = "NORTH" },
			{ coord = Vector3.new(-315.654938, -3.048218, 195.302444), facing = "SOUTH" },
			{ coord = Vector3.new(-483.859253, -3.048218, 195.269043), facing = "SOUTH" },
		},
		}

		UPPER_Y_THRESHOLD = 7
		TALL_PETS = { ["La Secret Combinasion"] = true, ["La Jolly Grande"] = true }
		TALL_OFFSET = 3
		CARPET_SPEED = 180
		INBASE_SPEED = 230

		function getCarpetSpeed()
			return mainConfig.TpSettings.FlyTPSpeed or 230
		end

		function getInBaseSpeed()
			return mainConfig.TpSettings.FlyTPCloseSpeed or 230
		end

		SKY_CLONE_WAIT = 0.2

		CARPET_NAMES = {
			"Flying Carpet",
			"Carpet",
			"Cloud",
			"Witch's Broom",
			"Cupid's Wings",
			"Santa's Sleigh",
			"Magic Carpet",
			"Waverider",
		}

		local Players3, RunService_, playerMouse, module, tbl9, tbl10, tbl11, flag3

		GRAPPLE_NAMES = {
			"Grapple Hook",
			"Grappling Hook",
			"Grapple",
			"Hook",
			"Web Slinger",
			"Grapple Gun",
			"GrappleHook",
		}

		Players3 = game:GetService("Players")
		RunService_ = game:GetService("RunService")
		UIS = game:GetService("UserInputService")
		RS = game:GetService("ReplicatedStorage")
		LP = Players3.LocalPlayer
		_G.AntiDieDisabled = false

		do
			local connection_, connection_2, connection_3

			local function fn17(arg)
				pcall(function()
					arg.BreakJointsOnDeath = false
				end)

				pcall(function()
					arg.RequiresNeck = false
				end)

				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				end)

				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				end)

				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				end)

				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				end)
			end

			local function fn18(arg)
				pcall(function()
					arg.Health = arg.MaxHealth
				end)

				pcall(function()
					arg:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end

			local fn19

			fn19 = function()
				local character2 = LP.Character and LP.Character.FindFirstChildOfClass(LP.Character, "Humanoid")
				if not character2 then
					return
				end
				fn17(character2)

				if connection_ then
					pcall(function()
						connection_:Disconnect()
					end)
				end

				if connection_2 then
					pcall(function()
						connection_2:Disconnect()
					end)
				end

				if connection_3 then
					pcall(function()
						connection_3:Disconnect()
					end)
				end

				connection_ = character2:GetPropertyChangedSignal("Health"):Connect(function()
					if _G.AntiDieDisabled then
						return
					end

					if character2.Health <= 0 then
						fn18(character2)
					end
				end)

				connection_2 = character2.Died:Connect(function()
					if _G.AntiDieDisabled then
						return
					end
					fn18(character2)
				end)

				local n9 = 0

				connection_3 = RunService_.Heartbeat:Connect(function()
					if _G.AntiDieDisabled or not character2 or not character2.Parent then
						return
					end
					local now = os.clock()

					if now - n9 >= 0.5 then
						n9 = now
						fn17(character2)
					end

					if character2.Health <= 0 then
						fn18(character2)
					end

					local state = character2:GetState()

					if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
						pcall(function()
							character2:ChangeState(Enum.HumanoidStateType.Running)
						end)
					end
				end)
			end

			fn19()

			LP.CharacterAdded:Connect(function(character2)
				local humanoid2 = character2:WaitForChild("Humanoid", 5)

				if humanoid2 then
					fn17(humanoid2)
				end

				task.wait(0.1)
				fn19()
			end)
		end

		local module2, module3, xenAnimShim, module4

		function loadModules()
			if module2 then
				return true
			end

			local ok = pcall(function()
				local packages, datas, shared_, utils
				packages = RS:WaitForChild("Packages", 2)
				datas = RS:WaitForChild("Datas", 2)
				shared_ = RS:WaitForChild("Shared", 2)
				utils = RS:WaitForChild("Utils", 2)
				module2 = require(packages.WaitForChild(packages, "Synchronizer"))
				module3 = require(datas.WaitForChild(datas, "Animals"))
				xenAnimShim = _G._xenAnimShim
				module4 = require(utils.WaitForChild(utils, "NumberUtils"))
			end)

			return ok and module2 ~= nil
		end

		loadNet = function()
			if NetModule then
				return true
			end

			local ok, result = pcall(function()
				return _G.Net
			end)

			if not ok or type(result) ~= "table" then
				return false
			end
			NetModule = result
			return true
		end

		findTool = function(arg)
			local backpack = LP:FindFirstChild("Backpack")
			return LP.Character and LP.Character.FindFirstChild(LP.Character, arg) or backpack and backpack:FindFirstChild(arg)
		end

		findGrapple = function()
			for i, v9 in ipairs(GRAPPLE_NAMES) do
				local v10 = findTool(v9)
				if v10 and v10:IsA("Tool") then
					return v10, v9
				end
			end

			return nil
		end

		playerMouse = ReplicatedStorage:WaitForChild("Packages", 2) and ReplicatedStorage.Packages:WaitForChild("PlayerMouse", 2)
		module = playerMouse and require(playerMouse) or nil

		fireGrappleBypass = function()
			local character2 = LP.Character and LP.Character.FindFirstChildOfClass(LP.Character, "Humanoid")
			local character3 = LP.Character and LP.Character.FindFirstChild(LP.Character, "HumanoidRootPart")
			if not LP.Character or not character2 or not character3 then
				return false
			end
			local v9 = findGrapple()

			if not v9 then
				local now = os.clock()

				while not v9 and os.clock() - now < 1.5 do
					RunService_.Heartbeat:Wait()
					v9 = findGrapple()
				end
			end

			if not v9 then
				return false
			end

			if v9.Parent ~= LP.Character then
				pcall(function()
					character2:EquipTool(v9)
				end)

				task.wait(0.1)
			end

			pcall(function()
				local beam = v9:FindFirstChild("Beam", true)

				if beam and beam:IsA("Beam") then
					beam.Width0 = 0
					beam.Width1 = 0
					local connection_

					connection_ = beam:GetPropertyChangedSignal("Width0"):Connect(function()
						beam.Width0 = 0
						beam.Width1 = 0
					end)

					task.delay(2, function()
						if connection_ then
							connection_.Disconnect(connection_)
						end
					end)
				end

				for i, descendant in ipairs(v9:GetDescendants()) do
					if descendant:IsA("Sound") then
						descendant.Volume = 0
					end
				end
			end)

			local flag4 = false
			local connection_, part

			connection_ = character3.ChildAdded:Connect(function(child)
				if child:IsA("BodyVelocity") and child.Name == "FlightPower" then
					flag4 = true

					pcall(function()
						child.MaxForce = Vector3.zero
					end)
				end
			end)

			part = Instance.new("Part")
			part.Size = Vector3.new(2, 2, 2)
			part.Anchored = true
			part.CanCollide = false
			part.Transparency = 1
			part.CFrame = character3.CFrame * CFrame.new(0, 0, -11)
			part.Parent = workspace

			task.spawn(function()
				if module then
					local hit, target, now
					hit = module.Hit
					target = module.Target
					module.Hit = part.CFrame
					module.Target = part
					now = os.clock()

					while not flag4 and os.clock() - now < 4 do
						if v9 then
							pcall(function()
								v9:Activate()
							end)
						end

						task.wait(0.05)
						local now2 = os.clock()

						while not flag4 and os.clock() - now2 < 0.1 do
							RunService_.Heartbeat:Wait()
						end
					end

					module.Hit = hit
					module.Target = target
				else
					local now = os.clock()

					while not flag4 and os.clock() - now < 4 do
						if v9 then
							pcall(function()
								v9:Activate()
							end)
						end

						task.wait(0.05)
						local now2 = os.clock()

						while not flag4 and os.clock() - now2 < 0.1 do
							RunService_.Heartbeat:Wait()
						end
					end
				end

				pcall(function()
					if part then
						part.Destroy(part)
					end
				end)
			end)

			local now = os.clock()

			while not flag4 and os.clock() - now < 4.5 do
				RunService_.Heartbeat:Wait()
			end

			if connection_ then
				connection_.Disconnect(connection_)
			end

			pcall(function()
				if part then
					part.Destroy(part)
				end
			end)

			return flag4
		end

		function equipCarpet()
			local character2 = LP.Character and LP.Character.FindFirstChildOfClass(LP.Character, "Humanoid")
			if not character2 then
				return nil
			end
			local tool = mainConfig and mainConfig.TpSettings and mainConfig.TpSettings.Tool

			if tool then
				local v9 = findTool(tool)

				if v9 and v9:IsA("Tool") then
					if v9.Parent ~= LP.Character then
						pcall(function()
							character2:EquipTool(v9)
						end)
					end

					return tool
				end
			end

			for i, v9 in ipairs(CARPET_NAMES) do
				local v10 = findTool(v9)

				if v10 and v10:IsA("Tool") then
					if v10.Parent ~= LP.Character then
						pcall(function()
							character2:EquipTool(v10)
						end)
					end

					return v9
				end
			end

			return nil
		end

		do
			local bjkRemoteCache = getgenv().__BJK_RemoteCache or {}
			getgenv().__BJK_RemoteCache = bjkRemoteCache
			local learnedUseItemHash = bjkRemoteCache.__learnedUseItemHash

			local function fn17(arg)
				return typeof(arg) == "Instance" and (arg:IsA("RemoteEvent") or arg:IsA("RemoteFunction") or arg:IsA("UnreliableRemoteEvent"))
			end

			local fn18, tbl12, flag4, fn19, fn20, n9

			fn18 = function(arg, tpUseItemRemote)
				if not fn17(tpUseItemRemote) then
					return
				end

				if type(arg) ~= "string" then
					return
				end

				if arg:match("^RE/") or arg:match("^RF/") then
					return
				end
				bjkRemoteCache[arg] = tpUseItemRemote

				if arg == "UseItem" then
					_G.__tpUseItemRemote = tpUseItemRemote
					learnedUseItemHash = tpUseItemRemote.Name
					bjkRemoteCache.__learnedUseItemHash = learnedUseItemHash
				end
			end

			tbl12 = {}
			flag4 = false

			fn19 = function(descendant)
				if not fn17(descendant) then
					return
				end
				tbl12[descendant.Name] = tbl12[descendant.Name] or descendant

				if descendant.Name == "UseItem" or learnedUseItemHash and descendant.Name == learnedUseItemHash then
					pcall(fn18, "UseItem", descendant)
				end
			end

			fn20 = function()
				if flag4 then
					return
				end
				flag4 = true
				local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
				if not net then
					return
				end

				for i, descendant in ipairs(net:GetDescendants()) do
					fn19(descendant)
				end

				net.DescendantAdded:Connect(fn19)
			end

			_G.getRemote = function(arg, arg2)
				arg2 = tostring(arg2)
				local v9 = bjkRemoteCache[arg2]
				if v9 and v9.Parent then
					return v9
				end

				if arg2 == "UseItem" and _G.__tpUseItemRemote and _G.__tpUseItemRemote.Parent then
					return _G.__tpUseItemRemote
				end
				pcall(fn20)
				local v10 = tbl12[arg2]
				if v10 and v10.Parent then
					fn18(arg2, v10)
					return v10
				end
				return nil
			end

			function _G.waitRemote(arg, arg2)
				local v9 = _G.getRemote(nil, arg)
				if v9 then
					return v9
				end
				local n10 = tonumber(arg2) or 0
				if n10 <= 0 then
					return nil
				end
				local now = os.clock()

				while os.clock() - now < n10 do
					v9 = _G.getRemote(nil, arg)
					if v9 then
						return v9
					end
					RunService_.Heartbeat:Wait()
				end

				return _G.getRemote(nil, arg)
			end

			n9 = 0

			_G.useItemRemote = function()
				local v9 = _G.getRemote(nil, "UseItem")
				if v9 then
					return v9
				end
				local now = os.clock()
				if now - n9 < 10 then
					return nil
				end
				n9 = now
				local tbl13 = {}

				if type(NetModule) == "table" then
					tbl13[#tbl13 + 1] = NetModule
				end

				if type(_G.Net) == "table" then
					tbl13[#tbl13 + 1] = _G.Net
				end

				for i, v10 in ipairs(tbl13) do
					local value = rawget(v10, "RemoteEvent")

					if type(value) == "function" then
						local ok, result = pcall(value, v10, "UseItem")
						if ok and fn17(result) then
							pcall(fn18, "UseItem", result)
							return result
						end
						local ok2, result2 = pcall(value, "UseItem")
						if ok2 and fn17(result2) then
							pcall(fn18, "UseItem", result2)
							return result2
						end
					end
				end

				return nil
			end

			task.spawn(function()
				while true do
					if _G.BJK_HubGen ~= bjkHubGen then
						break
					end

					if _G.__tpUseItemRemote and _G.__tpUseItemRemote.Parent then
						task.wait(5)
					else
						_G.getRemote(nil, "UseItem")
						task.wait(1)
					end
				end
			end)
		end

		_G.resolveUseItem = function()
			return _G.getRemote and _G.getRemote(nil, "UseItem")
		end

		_G.waitUseItem = function(arg)
			return _G.waitRemote and _G.waitRemote("UseItem", arg or 0.5)
		end

		fireGrapple = function()
			fireGrappleBypass()
		end

		carpetEngage = function()
			return fireGrappleBypass()
		end

		PET_PRIORITY_TIERS = {
			[1] = { pets = { "Headless Horseman" }, threshold = 0 },
			[2] = { pets = { "Signore Carapace" }, threshold = 0 },
			[3] = { pets = { "John Pork" }, threshold = 0 },
			[4] = { pets = { "Strawberry Elephant" }, threshold = 0 },
			[5] = { pets = { "Arcadragon" }, threshold = 5000000000 },
			[6] = { pets = { "Elefanto Frigo" }, threshold = 10000000000 },
			[7] = { pets = { "Meowl" }, threshold = 5000000000 },
			[8] = { pets = { "Skibidi Toilet" }, threshold = 5000000000 },
			[9] = { pets = { "Love Love Bear" }, threshold = 0 },
			[10] = { pets = { "Antonio" }, threshold = 0 },
			[11] = { pets = { "Pancake and Syrup" }, threshold = 0 },
			[12] = { pets = { "Griffin" }, threshold = 0 },
			[13] = {
			pets = {
			"Globa Steppa",
			"La Supreme Combinasion",
			"Fishino Clownino",
			"Dragon Gingerini",
			"Tirilikalika Tirilikalako",
		},
			threshold = 5000000000,
		},
			[14] = { pets = { "Ginger Gerat", "Pet" }, threshold = 10000000000 },
			[15] = {
			pets = { "Hydra Bunny", "Digi Narwhal", "Kalika Bros" },
			threshold = 3000000000,
		},
			[16] = {
			pets = { "Hydra Dragon Cannelloni", "Dragon Cannelloni", "Bunny and Eggy" },
			threshold = 3000000000,
		},
			[17] = {
			pets = { "Ketupat Bros", "Rosey and Teddy", "La Casa Boo", "Fragola la la" },
			threshold = 3000000000,
		},
			[18] = {
			pets = { "Fragola La La La", "Cerberus", "Guest 666", "Los Hackers" },
			threshold = 1000000000,
		},
			[19] = {
			pets = {
			"Garama and Madundung",
			"Spooky and Pumpky",
			"Reinito Sleighito",
			"Burguro And Fryuro",
			"Cooki and Milki",
			"Fragrama and Chocrama",
			"La Food Combinasion",
			"Los Amigos",
			"Foxini Lanternini",
			"Capitano Moby",
			"Fortunu and Cashuru",
			"Los Sekolahs",
			"Celestial Pegasus",
		},
			threshold = 750000000,
		},
			[20] = {
			pets = {
			"La Secret Combinasion",
			"Sammyni Fattini",
			"Cloverat Clapat",
			"Popcuru and Fizzuru",
		},
			threshold = 1000000000,
		},
		}

		TIER_LOOKUP = {}

		for k, v9 in pairs(PET_PRIORITY_TIERS) do
			for i, pet in ipairs(v9.pets) do
				TIER_LOOKUP[pet] = k
			end
		end

		LOCKED_TIERS = { [1] = true, [2] = true, [3] = true, [4] = true }

		DIRECT_THRESHOLDS = {
			[3] = { [4] = 10000000000 },
			[4] = {},
			[5] = { [6] = math.huge },
			[6] = { [9] = math.huge, [10] = math.huge, [12] = 15000000000 },
			[10] = { [12] = 20000000000 },
			[11] = { [12] = 10000000000 },
		}

		MUTATION_PRIORITY = {
			Galaxy = 1,
			Candy = 1,
			["Yin Yang"] = 1,
			YinYang = 1,
			Divine = 1,
			Cursed = 1,
			Lava = 1,
			Radioactive = 1,
			Cyber = 1,
			Rainbow = 1,
			Bloodrot = 2,
		}

		MUTATED_BEATS_GRIFFIN = {
			["Fishino Clownino"] = true,
			["Globa Steppa"] = true,
			["La Supreme Combinasion"] = true,
			["Tirilikalika Tirilikalako"] = true,
		}

		tbl9 = {}

		getMutPrio = function(arg)
			if not arg or arg == "" or arg == "None" then
				return 0
			end

			if MUTATION_PRIORITY[arg] then
				return MUTATION_PRIORITY[arg]
			end
			local str = tostring(arg)
			local v9 = tbl9[str]
			if v9 ~= nil then
				return v9
			end
			local str2 = str:lower():gsub("[%s%-_]", "")
			local n9 = 0

			if str2 == "bloodrot" then
				n9 = 2
			elseif str2 == "yinyang" or str2 == "galaxy" or str2 == "candy" or str2 == "divine" or str2 == "cursed" or str2 == "lava" or str2 == "radioactive" or str2 == "cyber" or str2 == "rainbow" then
				n9 = 1
			end

			tbl9[str] = n9
			return n9
		end

		tbl10 = {}

		getCumThreshold = function(arg, arg2)
			local n9 = arg * 64 + arg2
			local v9 = tbl10[n9]
			if v9 ~= nil then
				return v9
			end
			local huge

			if DIRECT_THRESHOLDS[arg] and DIRECT_THRESHOLDS[arg][arg2] then
				huge = DIRECT_THRESHOLDS[arg][arg2]
			elseif LOCKED_TIERS[arg] then
				huge = math.huge
			else
				local n10 = 0

				for i = arg + 1, arg2 do
					local v10 = PET_PRIORITY_TIERS[i]

					if v10 and v10.threshold > 0 then
						n10 = n10 + v10.threshold
					end
				end

				huge = n10
			end

			tbl10[n9] = huge
			return huge
		end

		petOutranks = function(arg, arg2, arg3, arg4, arg5, arg6)
			if arg == "Strawberry Elephant" and arg2 == "John Pork" then
				return true
			end

			if arg == "John Pork" and arg2 == "Strawberry Elephant" then
				return false
			end

			if MUTATED_BEATS_GRIFFIN[arg] and arg2 == "Griffin" and getMutPrio(arg3) >= 1 then
				return true
			end

			if arg == "Griffin" and MUTATED_BEATS_GRIFFIN[arg2] and getMutPrio(arg4) >= 1 then
				return false
			end

			if arg == "Antonio" and arg2 == "Elefanto Frigo" and getMutPrio(arg3) >= 1 then
				return true
			end

			if arg == "Elefanto Frigo" and arg2 == "Antonio" and getMutPrio(arg4) >= 1 then
				return false
			end
			local n9 = TIER_LOOKUP[arg] or 99
			local n10 = TIER_LOOKUP[arg2] or 99

			if not (TIER_LOOKUP[arg] and TIER_LOOKUP[arg2]) then
				if n9 == n10 then
					return (arg5 or 0) > (arg6 or 0)
				end
				return n9 < n10
			end

			if n9 == n10 then
				local v9, v10 = getMutPrio(arg3), getMutPrio(arg4)
				if v9 ~= v10 then
					return v9 > v10
				end
				return (arg5 or 0) > (arg6 or 0)
			end

			if n9 == 4 and n10 == 3 then
				return true
			end

			if n9 == 3 and n10 == 4 then
				return false
			end
			local n11, n12, flag4, flag5, v9
			n11 = math.min(n9, n10)
			n12 = math.max(n9, n10)
			flag4 = n9 < n10 and arg5 or arg6
			flag5 = n9 < n10 and arg6 or arg5
			v9 = getCumThreshold(n11, n12)

			if v9 > 0 and v9 ~= math.huge then
				if (flag5 or 0) - (flag4 or 0) > v9 then
					return n9 > n10
				end
			end

			return n9 < n10
		end

		tbl11 = {}

		function getPlotChannel(arg)
			local now = os.clock()
			local v9 = tbl11[arg]

			if v9 then
				local n9 = v9.ch == nil and 0.5 or 0.5
				if now - v9.t < n9 then
					return v9.ch
				end
			end

			if not module2 then
				return nil
			end
			local v10

			pcall(function()
				v10 = _G.XenSyncGet(arg)
			end)

			tbl11[arg] = { ch = v10, t = now }
			return v10
		end

		function channelGet(arg, arg2)
			return _G.sProp(arg, arg2)
		end

		function isMyPlot(arg)
			if not arg then
				return false
			end
			local v9 = channelGet(arg, "Owner")
			if not v9 then
				return false
			end
			local flag4 = false

			pcall(function()
				if typeof(v9) == "Instance" and v9:IsA("Player") then
					flag4 = v9.UserId == LP.UserId
				elseif type(v9) == "table" and v9.UserId then
					flag4 = v9.UserId == LP.UserId
				elseif typeof(v9) == "Instance" then
					flag4 = v9 == LP
				elseif type(v9) == "string" then
					flag4 = v9:lower() == LP.Name:lower() or v9:lower() == LP.DisplayName:lower()
				elseif type(v9) == "number" then
					flag4 = v9 == LP.UserId
				end
			end)

			return flag4
		end

		function ownerInGame(arg)
			if not arg then
				return false
			end
			local v9 = channelGet(arg, "Owner")
			if not v9 then
				return false
			end
			local flag4 = false

			pcall(function()
				if typeof(v9) == "Instance" and v9:IsA("Player") then
					flag4 = Players3.FindFirstChild(Players3, v9.Name) ~= nil
				elseif type(v9) == "number" then
					flag4 = Players3.GetPlayerByUserId(Players3, v9) ~= nil
				elseif type(v9) == "table" and v9.Name then
					flag4 = Players3.FindFirstChild(Players3, tostring(v9.Name)) ~= nil
				elseif type(v9) == "string" then
					flag4 = Players3.FindFirstChild(Players3, v9) ~= nil
				elseif typeof(v9) == "Instance" and v9.Name then
					flag4 = Players3.FindFirstChild(Players3, v9.Name) ~= nil
				end
			end)

			return flag4
		end

		function getStealPromptForSlot(arg, arg2)
			local animalPodiums = arg and arg:FindFirstChild("AnimalPodiums")
			local v9, v10, v11, v12, v13
			v9 = animalPodiums and animalPodiums:FindFirstChild(tostring(arg2))
			v10 = v9 and v9.FindFirstChild(v9, "Base")
			v11 = v10 and v10.FindFirstChild(v10, "Spawn")
			v12 = v11 and v11.FindFirstChild(v11, "PromptAttachment")
			v13 = v12 and v12.FindFirstChildWhichIsA(v12, "ProximityPrompt")
			if v13 and (v13.ActionText:lower():find("steal") or v13.ActionText == "") then
				return v13
			end
			return nil
		end

		_BLOCKING_MACHINE_TYPES = { Fuse = true, Duel = true, Trade = true, Crafting = true }

		function _CartisIsFusing(arg)
			if type(arg) ~= "table" then
				return false
			end
			local machine = arg.Machine
			if type(machine) ~= "table" then
				return false
			end
			return _BLOCKING_MACHINE_TYPES[machine.Type] == true
		end

		local tbl12 = {}
		local n9 = 0

		local function fn17(arg, arg2, arg3)
			local str = arg .. "|" .. tostring(arg2) .. "|" .. (type(arg3) == "table" and #arg3 > 0 and table.concat(arg3, ",") or "")
			local n10 = tbl12[str]
			if n10 ~= nil then
				return n10
			end
			n10 = 0

			pcall(function()
				n10 = xenAnimShim:GetGeneration(arg, arg2 ~= "None" and arg2 or nil, arg3, nil) or 0
			end)

			if n10 == 0 then
				pcall(function()
					n10 = xenAnimShim:GetGeneration(arg, "None", nil, nil) or 0
				end)
			end

			if n9 < 3000 then
				n9 = n9 + 1
				tbl12[str] = n10
			end

			return n10
		end

		function scanAllPets()
			local tbl13 = {}
			if not loadModules() then
				return tbl13
			end
			local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
			if not plotsFolder then
				return tbl13
			end

			for i, child in ipairs(plotsFolder:GetChildren()) do
				local v9 = getPlotChannel(child.Name)
				if not v9 then
					continue
				end

				if isMyPlot(v9) then
					continue
				end
				local v10 = channelGet(v9, "AnimalList")
				if not v10 then
					continue
				end

				for k, v11 in pairs(v10) do
					if type(v11) ~= "table" then
						continue
					end
					local index = v11.Index
					if not index then
						continue
					end
					local v12 = module3 and module3[index]
					if not v12 then
						continue
					end

					if _CartisIsFusing(v11) then
						continue
					end
					local mutation = v11.Mutation or "None"
					local v13 = fn17(index, mutation, v11.Traits)
					local displayName = v12 and v12.DisplayName or index
					local v14 = getPetPosition(child, k)

					if v14 then
						table.insert(tbl13, {
							name = displayName,
							mps = v13,
							mutation = mutation,
							position = v14,
							plot = child.Name,
							slot = tostring(k),
							prompt = getStealPromptForSlot(child, k),
						})
					end
				end
			end

			table.sort(tbl13, function(arg, arg2)
				return petOutranks(arg.name, arg2.name, arg.mutation, arg2.mutation, arg.mps, arg2.mps)
			end)

			return tbl13
		end

		function findClosest(arg, arg2, arg3)
			local tbl13 = {}

			for k, v9 in pairs(arg2) do
				for i, v10 in ipairs(v9) do
					local coord = v10.coord
					local n10 = (arg.X - coord.X) ^ 2 + (arg.Z - coord.Z) ^ 2
					tbl13[#tbl13 + 1] = { data = v10, key = k, petD = n10 }
				end
			end

			table.sort(tbl13, function(arg4, arg5)
				return arg4.petD < arg5.petD
			end)

			if #tbl13 == 0 then
				return nil, nil
			end

			if not arg3 then
				return tbl13[1].data, tbl13[1].key
			end
			local tbl14 = { tbl13[1] }

			if tbl13[2] and math.abs(tbl13[2].data.coord.X - tbl13[1].data.coord.X) < 40 then
				tbl14[#tbl14 + 1] = tbl13[2]
			end

			local data, key, huge = tbl13[1].data, tbl13[1].key, math.huge

			for i, v9 in ipairs(tbl14) do
				local coord = v9.data.coord
				local n10 = (arg3.X - coord.X) ^ 2 + (arg3.Z - coord.Z) ^ 2

				if n10 < huge then
					huge = n10
					data = v9.data
					key = v9.key
				end
			end

			return data, key
		end

		_vizParts = {}
		_vizGen = 0

		function clearViz()
			_vizGen = _vizGen + 1
			local tbl13 = {}

			for i, v9 in ipairs(_vizParts) do
				tbl13[i] = v9
			end

			table.clear(_vizParts)

			for i, v9 in ipairs(tbl13) do
				if v9 and v9.Parent then
					pcall(function()
						v9:Destroy()
					end)
				end
			end
		end

		_vizFadeIn = function(arg, transparency)
			arg.Transparency = transparency or 0
		end

		vizLine = function(arg, arg2, color)
			local n10 = arg2 - arg
			if n10.Magnitude < 0.05 then
				return
			end
			local part = Instance.new("Part")
			part.Name = "BJKVizPath"
			part.Anchored = true
			local tbl13 = {}
			part.CanCollide = false
			part.CanQuery = false
			part.CastShadow = false
			part.Shape = Enum.PartType.Cylinder
			part.Material = Enum.Material.Neon
			part.Color = color
			part.Size = Vector3.new(n10.Magnitude, 0.45, 0.45)
			part.CFrame = CFrame.new((arg + arg2) / 2, arg2) * CFrame.Angles(0, math.rad(90), 0)
			part.Transparency = 0.05
			part.Parent = Workspace
			_vizParts[#_vizParts + 1] = part
		end

		vizDot = function(position, color, arg)
			local part = Instance.new("Part")
			part.Name = "BJKVizPath"
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CastShadow = false
			part.Shape = Enum.PartType.Ball
			part.Material = Enum.Material.Neon
			part.Color = color
			part.Size = Vector3.new(arg, arg, arg)
			part.Position = position
			_vizFadeIn(part, 0)
			part.Parent = Workspace
			_vizParts[#_vizParts + 1] = part
		end

		vizPath = function(arg, arg2) end
		isGrabbleTeleporting = false
		flag3 = false

		function getPlotKey(arg)
			if not arg then
				return nil
			end
			local match, v9 = arg:match("^Plot_([B-D])([1-4])$")
			if match and v9 then
				return match
			end
			local match2, v10 = arg:match("^Plot([B-D])([1-4])$")
			if match2 and v10 then
				return match2
			end
			local match3 = arg:match("^([B-D])[1-4]$")
			if match3 then
				return match3
			end
			return nil
		end

		SPEED = 200

		local function fn18()
			return math.clamp(2.5 + (LP:GetNetworkPing() or 0) * 20, 2.5, 6)
		end

		ARRIVE = fn18()

		vZero = function(arg)
			if arg then
				arg.AssemblyLinearVelocity = Vector3.zero
				arg.AssemblyAngularVelocity = Vector3.zero
			end
		end

		MAX_CLIMB = 60

		velMoveThrough = function(arg, arg2, arg3, arg4, arg5)
			if not arg or not arg.Parent or #arg2 == 0 then
				return
			end
			local grabbleTPSpeed = arg3 or mainConfig.TpSettings.GrabbleTPSpeed or (_G.BJKCarpetSpeed or CARPET_SPEED or 230)
			vizPath(arg.Position, arg2)
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.IgnoreWater = true

			do
				local filterDescendantsInstances = {}

				for i, player_ in ipairs(Players3.GetPlayers(Players3)) do
					if player_.Character then
						filterDescendantsInstances[#filterDescendantsInstances + 1] = player_.Character
					end
				end

				raycastParams.FilterDescendantsInstances = filterDescendantsInstances
			end

			local n10 = 0
			local n11, flag4, connection_, fn19, huge, n12, n13
			n11 = 1
			flag4 = false

			fn19 = function()
				if flag4 then
					return
				end
				flag4 = true

				if arg and arg.Parent then
					arg.AssemblyLinearVelocity = Vector3.zero
					arg.AssemblyAngularVelocity = Vector3.zero
					local v9, v10 = arg.CFrame:ToEulerAnglesYXZ()
					arg.CFrame = CFrame.new(arg2[#arg2]) * CFrame.Angles(0, v10, 0)
				end

				if connection_ then
					connection_.Disconnect(connection_)
				end

				task.delay(4, clearViz)
			end

			huge, n12 = math.huge, 0
			n13 = 0
			local now = os.clock()
			local now2 = os.clock()
			local v9 = nil
			local v10, v11 = nil, nil

			if arg5 then
				local raycastParams2 = RaycastParams.new()
				local filterDescendantsInstances
				raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams2.IgnoreWater = true
				filterDescendantsInstances = {}

				for i, player_ in ipairs(Players3.GetPlayers(Players3)) do
					if player_.Character then
						filterDescendantsInstances[#filterDescendantsInstances + 1] = player_.Character
					end
				end

				raycastParams2.FilterDescendantsInstances = filterDescendantsInstances

				for i = 1, 3 do
					local v12 = arg2[n11]
					if not v12 then
						break
					end
					local vector4 = Vector3.new(v12.X - arg.Position.X, 0, v12.Z - arg.Position.Z)
					local magnitude = vector4.Magnitude
					if magnitude < 1 then
						break
					end
					local n14 = arg.Position + vector4.Unit * math.min(20, magnitude)
					local hit = Workspace:Raycast(arg.Position, n14 - arg.Position, raycastParams2)
					if hit and hit.Instance and hit.Instance.CanCollide then
						break
					end
					arg.CFrame = arg.CFrame - arg.CFrame.Position + n14
					arg.AssemblyLinearVelocity = Vector3.zero
					arg.AssemblyAngularVelocity = Vector3.zero
					RunService_.Heartbeat:Wait()
					if not arg or not arg.Parent then
						return
					end
				end
			end

			pcall(function()
				if sethiddenproperty and arg and arg.Parent then
					sethiddenproperty(arg, "NetworkOwnershipRule", 0)
				end
			end)

			local now3 = os.clock()

			connection_ = RunService_.Heartbeat:Connect(function()
				if not arg or not arg.Parent or flag4 then
					if connection_ then
						connection_.Disconnect(connection_)
					end

					return
				end

				pcall(function()
					if sethiddenproperty and arg and arg.Parent then
						sethiddenproperty(arg, "NetworkOwnershipRule", 0)
					end
				end)

				equipCarpet()
				local v12 = arg2[n11]
				local n14 = v12 - arg.Position
				local magnitude = n14.Magnitude
				local n15 = fn18()

				if n11 >= #arg2 then
					n15 = math.max(1.2, fn18() * 0.5)
				end

				local now4 = os.clock()
				local n16 = math.min(0.25, now4 - now2)
				now2 = now4

				if n11 < #arg2 then
					n15 = math.max(n15, n13 * n16 * 1.1)
				end

				if magnitude >= n15 and v9 then
					local v13 = n14.Unit:Dot(v9)

					if v13 < -0.3 then
						n11 = n11 + 1
						if n11 > #arg2 then
							fn19()
							return
						end
						huge, n12 = math.huge, 0
						local tbl13 = {}
						v12 = arg2[n11]
						n14 = v12 - arg.Position
						magnitude = n14.Magnitude
					end
				end

				if magnitude < n15 then
					n11 = n11 + 1
					if n11 > #arg2 then
						fn19()
						return
					end
					huge, n12 = math.huge, 0
					v12 = arg2[n11]
					n14 = v12 - arg.Position
					magnitude = n14.Magnitude
				end

				if n11 < #arg2 then
					local v13 = arg2[n11 + 1]

					if v13 and (arg.Position - v13).Magnitude < magnitude then
						n11 = n11 + 1
						local tbl13 = {}
						huge, n12 = math.huge, 0
						v12 = arg2[n11]
						n14 = v12 - arg.Position
						magnitude = n14.Magnitude
					end
				end

				if n10 > 0 then
					n10 = n10 - 1
					n12 = 0
				elseif magnitude > huge - 0.05 then
					if magnitude > huge + 15 then
						n12 = 0
					else
						n12 = n12 + 1
					end
				else
					n12 = 0
				end

				huge = magnitude
				if n12 >= 30 then
					fn19()
					return
				end

				if magnitude >= 0.1 then
					local unit = n14.Unit
					local vector4 = Vector3.new(unit.X, 0, unit.Z)

					if vector4.Magnitude > 0.001 then
						vector4 = vector4.Unit
						v9 = vector4

						pcall(function()
							if arg and arg.Parent then
								arg.CFrame = CFrame.lookAt(arg.Position, arg.Position + vector4)
							end
						end)
					end

					if arg4 and n14.Y > 5 and n11 < #arg2 then
						local humanoid2 = arg.Parent and arg.Parent:FindFirstChildOfClass("Humanoid")

						if humanoid2 then
							local state = humanoid2:GetState()

							if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
								pcall(function()
									humanoid2:ChangeState(Enum.HumanoidStateType.Jumping)
								end)

								pcall(function()
									humanoid2.Jump = true
								end)
							end
						end
					end

					local now5 = os.clock()
					local n17 = math.min(0.1, now5 - now)
					now = now5
					local n18, n19, n20, x, z
					n18 = math.clamp((now5 - now3) / 0.08, 0, 1)
					n18 = n18 * n18 * (3 - 2 * n18)
					n19 = grabbleTPSpeed * (0.7 + 0.3 * n18)
					n20 = math.abs(n19 - n13) > n19 * 0.6 and 14 or 22
					n13 = n13 + (n19 - n13) * math.min(1, n17 * n20)
					x, z = unit.X, unit.Z

					do
						local vector5 = Vector3.new(unit.X, 0, unit.Z)

						if vector5.Magnitude > 0.001 then
							local n21, n22, vector6, fn20, distance, position
							vector5 = vector5.Unit
							n21 = arg.Position + Vector3.new(0, 1.5, 0)
							n22 = math.clamp(n13 * 0.45, 18, 70)
							vector6 = Vector3.new(-vector5.Z, 0, vector5.X)

							fn20 = function(arg6, arg7)
								local v13 = math.rad(arg6)
								local v14, v15 = math.cos(v13), math.sin(v13)
								local vector7 = Vector3.new(vector5.X * v14 - vector5.Z * v15, 0, vector5.X * v15 + vector5.Z * v14)
								return Workspace:Raycast(n21, vector7 * arg7, raycastParams)
							end

							for i, v13 in ipairs({ 0, -25, 25 }) do
								local v14 = fn20(v13, n22)

								if v14 and v14.Instance and v14.Instance.CanCollide then
									if not distance or v14.Distance < distance then
										distance = v14.Distance
										position = v14.Position
									end
								end
							end

							if distance and position then
								n10 = 30
								local n23 = math.max(n22 * 0.8, 20)
								local v13 = fn20(60, n23)
								local v14, distance2, distance3, n24, n25
								v14 = fn20(-60, n23)
								distance2 = v13 and v13.Distance or n23
								distance3 = v14 and v14.Distance or n23
								n24 = distance2 >= distance3 and vector6 or -vector6
								n25 = math.clamp(1 - (distance - 10) / math.max(n22 - 10, 1), 0, 1)
								n25 = n25 * n25
								local vector7 = Vector3.new(arg.Position.X - position.X, 0, arg.Position.Z - position.Z)
								vector7 = vector7.Magnitude > 0.01 and vector7.Unit or n24
								local n26 = math.clamp(1 - (distance - 2) / 18, 0, 1)
								local n27 = vector5 + n24 * (0.4 + n25 * 1.4) + vector7 * (n26 * 1.2)

								if n27.Magnitude > 0.001 then
									n27 = n27.Unit
									x, z = n27.X, n27.Z
								end
							end
						end
					end

					do
						local v13 = math.sqrt(x * x + z * z)

						if v13 > 0.001 and n17 > 0 then
							x, z = x / v13, z / v13

							if v10 then
								local n21 = math.min(1, n17 * 12)
								local n22 = v10 + (x - v10) * n21
								local n23 = v11 + (z - v11) * n21
								local v14 = math.sqrt(n22 * n22 + n23 * n23)

								if v14 > 0.001 then
									x, z = n22 / v14, n23 / v14
								end
							end

							v10, v11 = x, z
						end
					end

					local n21 = 1

					if n11 >= #arg2 and magnitude < 60 then
						local n22 = math.clamp(magnitude / 60, 0, 1)
						n21 = 0.35 + 0.65 * (n22 * n22 * (3 - 2 * n22))
					end

					local n22 = v12.Y - arg.Position.Y
					local y = arg.AssemblyLinearVelocity.Y
					local n23 = math.clamp(n22 * 3 - y * 0.35, -140, MAX_CLIMB) * math.max(0.5, n21)
					arg.AssemblyLinearVelocity = Vector3.new(x * n13 * n21, n23, z * n13 * n21)
				end
			end)

			local n14 = 0
			local position = arg.Position

			for i, v12 in ipairs(arg2) do
				n14 = n14 + (position - v12).Magnitude
				position = v12
			end

			local n15 = n14 / math.min(SPEED, grabbleTPSpeed) + 8
			local n16 = 0

			while not flag4 and n16 < n15 do
				task.wait(0.05)
				n16 = n16 + 0.05
			end

			fn19()
			vZero(arg)
		end

		_DIRS = {
			Vector3.new(1, 0, 0),
			Vector3.new(-1, 0, 0),
			Vector3.new(0, 0, 1),
			Vector3.new(0, 0, -1),
		}

		_STRUCT = { ["structure base home"] = true, Wall = true, Floor = true, Roof = true }

		_SKIP_NAME = {
			DeliveryHitbox = true,
			StealHitbox = true,
			LaserHitbox = true,
			AnimalTarget = true,
			Multiplier = true,
			Laser = true,
			Hitbox = true,
			Spawn = true,
			MainRoot = true,
			SecondFloor = true,
			ThirdFloor = true,
			Slope = true,
		}

		_MAP_CENTER = { minX = -458, maxX = -362, minZ = -40, maxZ = 185 }
		_BYPASS_Z_NORTH, _BYPASS_Z_SOUTH = 205, -95
		_BYPASS_X_WEST, _BYPASS_X_EAST = -525, -295

		_CENTER_OBSTACLE_KEYWORDS = {
			"craftingmachine",
			"crafting",
			"forge",
			"fuse",
			"duel",
			"trade",
			"machine",
			"spin",
			"wheel",
			"event",
			"portal",
			"npc",
			"vendor",
			"futbol",
			"livematches",
			"live matches",
		}

		_isMapObstacle = function(arg)
			if not arg then
				return false
			end
			local parent = arg

			while parent and parent ~= Workspace do
				local str = parent.Name:lower()

				for i, v9 in ipairs(_CENTER_OBSTACLE_KEYWORDS) do
					if str:find(v9, 1, true) then
						return true
					end
				end

				parent = parent.Parent
			end

			return false
		end

		_blocks = function(arg)
			if not arg then
				return false
			end

			if _SKIP_NAME[arg.Name] then
				return false
			end

			if _isMapObstacle(arg) then
				return true
			end

			if arg.CanCollide then
				return true
			end

			if _STRUCT[arg.Name] then
				return true
			end
			local size = arg.Size
			if size and math.max(size.X * size.Y, size.X * size.Z, size.Y * size.Z) > 150 then
				return true
			end
			return false
		end

		function _block(arg, arg2)
			local raycastParams, filterDescendantsInstances
			raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.IgnoreWater = true
			filterDescendantsInstances = {}

			for i, player_ in ipairs(Players3.GetPlayers(Players3)) do
				if player_.Character then
					filterDescendantsInstances[#filterDescendantsInstances + 1] = player_.Character
				end
			end

			local n10 = arg

			for i = 1, 16 do
				raycastParams.FilterDescendantsInstances = filterDescendantsInstances
				local n11 = arg2 - n10
				if n11.Magnitude < 0.05 then
					return nil
				end
				local hit = Workspace:Raycast(n10, n11, raycastParams)
				if not hit then
					return nil
				end

				if _blocks(hit.Instance) then
					return hit
				end
				filterDescendantsInstances[#filterDescendantsInstances + 1] = hit.Instance
				n10 = hit.Position + n11.Unit * 0.3
			end

			return nil
		end

		function _clear(arg, arg2)
			return _block(arg, arg2) == nil
		end

		_clearDist = function(arg, arg2, arg3)
			local v9 = _block(arg, arg + arg2.Unit * arg3)
			if not v9 then
				return arg3
			end
			return (v9.Position - arg).Magnitude
		end

		_len = function(arg)
			local n10, v9 = 0, arg[1]

			for i = 2, #arg do
				n10 = n10 + (arg[i] - v9).Magnitude
				v9 = arg[i]
			end

			return n10
		end

		_pull = function(arg)
			if #arg <= 2 then
				return arg
			end
			local tbl13 = { arg[1] }
			local n10 = 1

			while n10 < #arg do
				local n11 = #arg

				while n11 > n10 + 1 and not _clear(tbl13[#tbl13], arg[n11]) do
					n11 = n11 - 1
				end

				tbl13[#tbl13 + 1] = arg[n11]
				n10 = n11
			end

			return tbl13
		end

		_stages = function(arg)
			local tbl13 = {}

			for i, v9 in ipairs(_DIRS) do
				local v10 = _clearDist(arg, v9, 46)

				if v10 >= 12 then
					tbl13[#tbl13 + 1] = arg + v9 * math.min(v10 - 5, 38)
				end
			end

			return tbl13
		end

		_routeClear = function(arg)
			for i = 1, #arg - 1 do
				if not _clear(arg[i], arg[i + 1]) then
					return false
				end
			end

			return true
		end

		_peakY = function(arg)
			local n10 = -math.huge

			for i, v9 in ipairs(arg) do
				if v9.Y > n10 then
					n10 = v9.Y
				end
			end

			return n10
		end

		function _starts(arg)
			local tbl13 = { arg }

			if _block(arg, arg + Vector3.new(0, 40, 0)) then
				for i, v9 in ipairs(_DIRS) do
					local v10 = _clearDist(arg, v9, 40)

					if v10 >= 12 then
						tbl13[#tbl13 + 1] = arg + v9 * math.min(v10 - 5, 34)
					end
				end
			end

			return tbl13
		end

		function _candidates(arg, arg2, arg3)
			local tbl13 = {}

			local function fn19(arg4)
				if arg4 then
					tbl13[#tbl13 + 1] = { arg, arg4, arg2, arg3 }
				else
					tbl13[#tbl13 + 1] = { arg, arg2, arg3 }
				end
			end

			fn19(nil)
			local vector4
			fn19(Vector3.new(arg2.X, arg.Y, arg2.Z))
			fn19(Vector3.new(arg.X, arg2.Y, arg.Z))
			vector4 = Vector3.new(arg2.X - arg.X, 0, arg2.Z - arg.Z)

			if vector4.Magnitude > 0.1 then
				vector4 = vector4.Unit
				local vector5 = Vector3.new(-vector4.Z, 0, vector4.X)

				for i, v9 in ipairs({ 20, -20, 40, -40 }) do
					fn19(arg + vector5 * v9)
				end
			end

			return tbl13
		end

		PathfindingService = game:GetService("PathfindingService")
		_CLEARANCE = 6

		function _clearWide(arg, arg2)
			if not _clear(arg, arg2) then
				return false
			end
			local vector4 = Vector3.new(arg2.X - arg.X, 0, arg2.Z - arg.Z)
			if vector4.Magnitude < 0.1 then
				return true
			end
			local n10 = Vector3.new(-vector4.Z, 0, vector4.X).Unit * _CLEARANCE
			return _clear(arg + n10, arg2 + n10) and _clear(arg - n10, arg2 - n10)
		end

		function _pullWide(arg)
			if #arg <= 2 then
				return arg
			end
			local tbl13 = { arg[1] }
			local n10 = 1

			while n10 < #arg do
				local n11 = #arg

				while n11 > n10 + 1 and not _clearWide(tbl13[#tbl13], arg[n11]) do
					n11 = n11 - 1
				end

				tbl13[#tbl13 + 1] = arg[n11]
				n10 = n11
			end

			return tbl13
		end

		function _inCenterZone(arg, arg2)
			return arg >= _MAP_CENTER.minX and arg <= _MAP_CENTER.maxX and arg2 >= _MAP_CENTER.minZ and arg2 <= _MAP_CENTER.maxZ
		end

		function _segmentCrossesCenter(arg, arg2)
			if _inCenterZone(arg.X, arg.Z) or _inCenterZone(arg2.X, arg2.Z) then
				return true
			end

			for i = 1, 10 do
				local n10 = i / 11
				if _inCenterZone(arg.X + (arg2.X - arg.X) * n10, arg.Z + (arg2.Z - arg.Z) * n10) then
					return true
				end
			end

			return false
		end

		function _findBestCenterDetour(arg, arg2, arg3)
			local tbl13 = {
				{
				Vector3.new(arg.X, arg3, _BYPASS_Z_NORTH),
				Vector3.new(arg2.X, arg3, _BYPASS_Z_NORTH),
			},
				{
				Vector3.new(arg.X, arg3, _BYPASS_Z_SOUTH),
				Vector3.new(arg2.X, arg3, _BYPASS_Z_SOUTH),
			},
				{
				Vector3.new(_BYPASS_X_WEST, arg3, arg.Z),
				Vector3.new(_BYPASS_X_WEST, arg3, arg2.Z),
			},
				{
				Vector3.new(_BYPASS_X_EAST, arg3, arg.Z),
				Vector3.new(_BYPASS_X_EAST, arg3, arg2.Z),
			},
			}

			local tbl14, huge = nil, math.huge

			for i, v9 in ipairs(tbl13) do
				local v10, v11 = v9[1], v9[2]

				if _clearWide(arg, v10) and _clearWide(v10, v11) and _clearWide(v11, arg2) then
					local n10 = (arg - v10).Magnitude + (v10 - v11).Magnitude + (v11 - arg2).Magnitude

					if n10 < huge then
						huge = n10
						tbl14 = { v10, v11 }
					end
				end
			end

			return tbl14
		end

		function computeRoute(arg, arg2, arg3)
			local v9 = nil

			if _segmentCrossesCenter(arg, arg2) and not _clearWide(arg, arg2) then
				v9 = _findBestCenterDetour(arg, arg2, arg.Y)

				if v9 and #v9 > 0 then
					arg = v9[#v9]
				end
			end

			if _clearWide(arg, arg2) then
				if v9 then
					local tbl13 = { v9[1] }

					for i = 2, #v9 do
						tbl13[#tbl13 + 1] = v9[i]
					end

					tbl13[#tbl13 + 1] = arg2
					return tbl13
				end

				return { arg2 }
			end

			for i, v10 in ipairs({ 12, 20, 32, 45 }) do
				local n10 = arg + Vector3.new(0, v10, 0)
				local vector4 = Vector3.new(arg2.X, math.max(arg2.Y + 4, n10.Y), arg2.Z)

				if _clearWide(arg, n10) and _clearWide(n10, vector4) and _clearWide(vector4, arg2) then
					if v9 then
						local tbl13 = { v9[1] }

						for i2 = 2, #v9 do
							tbl13[#tbl13 + 1] = v9[i2]
						end

						tbl13[#tbl13 + 1] = n10
						tbl13[#tbl13 + 1] = vector4
						tbl13[#tbl13 + 1] = arg2
						return tbl13
					end

					return { n10, vector4, arg2 }
				end
			end

			local n10 = arg3 and arg2 - arg3 * 14 or arg2
			local vector4 = Vector3.new(n10.X, arg.Y, n10.Z)

			local v10 = PathfindingService:CreatePath({
				AgentRadius = 8,
				AgentHeight = 5,
				AgentCanJump = true,
				AgentJumpHeight = 10,
				AgentMaxSlope = 89,
			})

			local n11, tbl13, ok
			n11 = 3
			tbl13 = { arg }

			ok = pcall(function()
				v10:ComputeAsync(Vector3.new(arg.X, arg.Y, arg.Z), vector4)
			end)

			if ok and v10.Status == Enum.PathStatus.Success then
				local position = arg

				for i, v11 in ipairs(v10:GetWaypoints()) do
					if (v11.Position - position).Magnitude >= 8 then
						tbl13[#tbl13 + 1] = v11.Position + Vector3.new(0, n11, 0)
						position = v11.Position
					end
				end
			end

			tbl13[#tbl13 + 1] = n10 + Vector3.new(0, n11, 0)
			local v11 = _pullWide(tbl13)
			v11[#v11 + 1] = arg2

			if v9 and #v9 > 0 then
				local tbl14 = { v9[1] }

				for i = 2, #v9 do
					tbl14[#tbl14 + 1] = v9[i]
				end

				for i, v12 in ipairs(v11) do
					tbl14[#tbl14 + 1] = v12
				end

				return _pullWide(tbl14)
			end

			return v11
		end

		_G._gPetPosCache = _G._gPetPosCache or {}

		function getPetPosition(arg, arg2)
			local str = arg.Name .. "|" .. tostring(arg2)
			local v9 = _G._gPetPosCache[str]
			local now = os.clock()
			if v9 and now - v9.t < 15 then
				return v9.pos
			end
			local animalPodiums = arg:FindFirstChild("AnimalPodiums")
			if not animalPodiums then
				return nil
			end
			local v10 = animalPodiums:FindFirstChild(tostring(arg2))
			if not v10 then
				return nil
			end
			local position

			for i, descendant in ipairs(v10:GetDescendants()) do
				if descendant:IsA("Model") and descendant.Name ~= "Claim" and descendant.Name ~= "Base" and descendant.Name ~= "Decorations" then
					local flag4 = false

					for i2, descendant2 in ipairs(descendant:GetDescendants()) do
						if descendant2:IsA("MeshPart") then
							flag4 = true
							break
						end
					end

					if flag4 then
						local ok, result = pcall(function()
							return descendant:GetBoundingBox()
						end)

						if ok then
							position = result.Position
							break
						end
					end
				end
			end

			if not position then
				local ok, result = pcall(function()
					return v10:GetPivot()
				end)

				if ok then
					position = result.Position
				end
			end

			if position then
				_G._gPetPosCache[str] = { pos = position, t = now }
			end

			return position
		end
	end

	cloneref = cloneref or function(arg)
		return arg
	end

	getinfo = debug.getinfo or getinfo
	lp = cloneref(game:GetService("Players")).LocalPlayer
	character = nil
	n = 0

	Strip = function()
		local character2 = lp.Character and lp.Character.FindFirstChild(lp.Character, "HumanoidRootPart")
		if not character2 then
			return
		end

		if not getconnections or not getinfo then
			return
		end

		if lp.Character == character and os.clock() - n < 10 then
			return
		end
		character = lp.Character
		n = os.clock()

		for i, v9 in ipairs({ "CFrame", "Position" }) do
			local signal = character2:GetPropertyChangedSignal(v9)

			if signal then
				for i2, v10 in ipairs(getconnections(signal)) do
					local function_ = v10.Function

					if function_ and v10.Enabled and getinfo(function_) and getinfo(function_).source == "=ReplicatedFirst.test" then
						pcall(function()
							v10:Disable()
						end)
					end
				end
			end
		end
	end

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			pcall(Strip)
			task.wait(0.5)
		end
	end)

	runAutoSnipe = function()
		pcall(Strip)

		if CarpetState and CarpetState.enabled then
			local tbl9 = {}
			setCarpetSpeed(false)
			mainConfig["Carpet Speed"] = false
			saveConfig()
		end

		if _G._isTpMoving then
			return
		end
		local tbl9 = {}

		do
			local ReplicatedStorage_ = game:GetService("ReplicatedStorage")
			local packages, datas, shared_, utils, module, module2, module3, module4, plotsFolder
			packages = ReplicatedStorage_:FindFirstChild("Packages")
			datas = ReplicatedStorage_:FindFirstChild("Datas")
			shared_ = ReplicatedStorage_:FindFirstChild("Shared")
			utils = ReplicatedStorage_:FindFirstChild("Utils")

			pcall(function()
				module = packages and require(packages.FindFirstChild(packages, "Synchronizer"))
			end)

			pcall(function()
				module2 = datas and require(datas.FindFirstChild(datas, "Animals"))
			end)

			pcall(function()
				module3 = shared_ and require(shared_.FindFirstChild(shared_, "Animals"))
			end)

			pcall(function()
				module4 = utils and require(utils.FindFirstChild(utils, "NumberUtils"))
			end)

			plotsFolder = _G.PlotsFolder or workspace:FindFirstChild("Plots")

			if plotsFolder and module and module2 and module3 then
				for i, child in ipairs(plotsFolder.GetChildren(plotsFolder)) do
					pcall(function()
						local vanishGetSyncData = _G.VanishGetSyncData and _G.VanishGetSyncData(child.Name)
						if not vanishGetSyncData then
							return
						end
						local owner = vanishGetSyncData.Owner
						local name

						if typeof(owner) == "Instance" and owner:IsA("Player") then
							name = owner.Name
						elseif type(owner) == "table" and owner.Name then
							name = owner.Name
						elseif type(owner) == "string" then
							name = owner
						end

						if not name or name == localPlayer2.Name or not Players2:FindFirstChild(name) then
							return
						end

						if _G.VanishIsDuelBlocking and _G.VanishIsDuelBlocking(name) then
							return
						end
						local animalList = vanishGetSyncData.AnimalList
						if type(animalList) ~= "table" then
							return
						end

						for k, v9 in pairs(animalList) do
							if type(v9) == "table" and v9.Index then
								if _G.VanishIsFusing and _G.VanishIsFusing(v9) then
									continue
								end
								local v10 = module2[v9.Index]

								if v10 then
									local n9 = 0

									pcall(function()
										n9 = module3.GetGeneration(module3, v9.Index, v9.Mutation, v9.Traits, nil) or 0
									end)

									if type(n9) == "number" and n9 >= 1 then
										local str

										if module4 then
											pcall(function()
												str = "$" .. module4.ToString(module4, n9) .. "/s"
											end)
										end

										table.insert(tbl9, {
											name = v10.DisplayName or v9.Index,
											Index = v9.Index,
											genText = str or "$" .. tostring(math.floor(n9)) .. "/s",
											genValue = n9,
											mutation = v9.Mutation or "None",
											owner = name,
											plot = child.Name,
											slot = tostring(k),
											uid = child.Name .. "_" .. tostring(k),
										})
									end
								end
							end
						end
					end)
				end
			end

			table.sort(tbl9, function(arg, arg2)
				return arg.genValue > arg2.genValue
			end)
		end

		local animalData = nil
		local skipStolenBest = mainConfig.TpSettings and mainConfig.TpSettings.SkipStolenBest or false
		local tbl10 = {}

		if skipStolenBest then
			for i, player_ in ipairs(Players2:GetPlayers()) do
				if player_ ~= localPlayer2 and player_:GetAttribute("Stealing") == true then
					local ok, result, result2 = pcall(getStealingInfo, player_)

					if ok and result2 then
						local str = tostring(result2):lower()
						local getStolenOwnerKeys = result and _G.getStolenOwnerKeys and _G.getStolenOwnerKeys(result) or nil

						if getStolenOwnerKeys and next(getStolenOwnerKeys) then
							for k in pairs(getStolenOwnerKeys) do
								tbl10[str .. "|" .. k] = true
							end
						else
							tbl10[str] = true
						end
					end
				end
			end
		end

		local function fn17(arg)
			if not skipStolenBest or not arg or not arg.name then
				return false
			end
			local str = tostring(arg.name):lower()
			if arg.owner then
				return tbl10[str .. "|" .. tostring(arg.owner):lower()] == true
			end
			return tbl10[str] == true
		end

		local function fn18()
			if tbl9 and type(tbl9) == "table" then
				for i, v9 in ipairs(tbl9) do
					if not fn17(v9) then
						return v9
					end
				end
			end

			return nil
		end

		local stealMode = mainConfig.StealMode or "Highest"

		if manuallySelectedUID and SharedState.SelectedPetData and SharedState.SelectedPetData.animalData and not fn17(SharedState.SelectedPetData.animalData) then
			animalData = SharedState.SelectedPetData.animalData
		elseif stealMode == "Highest" then
			local v9, n9 = nil, -math.huge

			if tbl9 and type(tbl9) == "table" then
				for i, v10 in ipairs(tbl9) do
					if v10 and not fn17(v10) and v10.owner ~= localPlayer2.Name and type(v10.genValue) == "number" and v10.genValue > n9 then
						n9 = v10.genValue
						v9 = v10
					end
				end
			end

			if v9 then
				animalData = v9
			else
				if not SharedState.SelectedPetData then
					return
				end
				local animalData2 = SharedState.SelectedPetData.animalData

				if not fn17(animalData2) then
					animalData = animalData2
				end
			end
		elseif stealMode == "Priority" then
			local v9 = nil

			if tbl9 and type(tbl9) == "table" then
				for i, v10 in ipairs(PRIORITY_LIST or {}) do
					local str = v10:lower()
					local v11, n9 = nil, -math.huge

					for i2, v12 in ipairs(tbl9) do
						if v12 and v12.name and v12.name:lower() == str and v12.owner ~= localPlayer2.Name and not fn17(v12) and type(v12.genValue) == "number" and v12.genValue > n9 then
							v11 = v12
							n9 = v12.genValue
						end
					end

					if v11 then
						v9 = v11
						break
					end
				end

				if not v9 then
					v9 = fn18()
				end
			end

			if v9 then
				animalData = v9
			else
				if not SharedState.SelectedPetData then
					return
				end
				local animalData2 = SharedState.SelectedPetData.animalData

				if not fn17(animalData2) then
					animalData = animalData2
				end
			end
		else
			animalData = fn18()

			if not animalData then
				if not SharedState.SelectedPetData then
					return
				end
				local animalData2 = SharedState.SelectedPetData.animalData

				if not fn17(animalData2) then
					animalData = animalData2
				end
			end
		end

		if not animalData then
			return
		end
		manuallySelectedUID = animalData.uid
		local bjkStartSideTP, ok, result
		_G._isTpMoving = true
		bjkStartSideTP = _G.BJKStartSideTP or doGrabbleVelocityTP
		ok, result = pcall(bjkStartSideTP)
		_G._isTpMoving = false

		if not ok then
		end
	end

	function tpToBrainrot()
		local v9 = getTargetPetData()
		if not v9 then
			return
		end
		local character2 = localPlayer2.Character
		local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
		local humanoid2 = character2 and character2:FindFirstChild("Humanoid")
		if not humanoidRootPart2 or not humanoid2 or humanoid2.Health <= 0 then
			return
		end
		local v10 = nil

		for i = 1, 10 do
			v10 = findAdorneeGlobal(v9)
			if v10 then
				break
			end
			task.wait(0.05)
		end

		if not v10 then
			return
		end

		local ok, result = pcall(function()
			local tool = mainConfig.TpSettings.Tool
			local v11 = localPlayer2.Backpack:FindFirstChild(tool) or character2:FindFirstChild(tool)

			if v11 then
				humanoid2:EquipTool(v11)
			end

			local position = v10.Position
			local n9 = getGoToBrainrotTargetY(position.Y) - 1.5
			local part = nil

			if position.Y >= 11 then
				part = Instance.new("Part")
				part.Name = "BJK_TempPlatform"
				part.Size = Vector3.new(6, 1.5, 6)
				part.Position = Vector3.new(position.X, n9, position.Z)
				part.Color = Color3.fromRGB(232, 111, 177)
				part.Material = Enum.Material.Neon
				local tbl9 = {}
				part.Anchored = true
				part.CanCollide = false
				pcall(makeOneWay, part)
				part.Transparency = 0.3
				part.Parent = Workspace
			end

			local cframe2 = CFrame.new(position.X, humanoidRootPart2.Position.Y, position.Z)
			humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
			humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
			local connection_
			humanoidRootPart2.CFrame = cframe2
			task.wait(0.05)
			humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero

			connection_ = localPlayer2:GetAttributeChangedSignal("Stealing"):Connect(function()
				if localPlayer2:GetAttribute("Stealing") then
					connection_.Disconnect(connection_)

					if part and part.Parent then
						part:Destroy()
					end
				end
			end)

			task.delay(20, function()
				if connection_ then
					connection_.Disconnect(connection_)
				end

				if part and part.Parent then
					part:Destroy()
				end
			end)
		end)

		if not ok then
		end
	end

	_G.runAutoSnipe = runAutoSnipe
	_G.tpToBrainrot = tpToBrainrot
	ctapHighlight = Instance.new("Highlight", CoreGui)
	ctapHighlight.FillColor = Color3.fromRGB(255, 150, 200)
	ctapHighlight.FillTransparency = 0.3
	ctapHighlight.OutlineColor = Color3.fromRGB(255, 150, 200)
	ctapHighlight.OutlineTransparency = 0
	ctapHighlight.Adornee = nil
	ctapHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	function rayToCubeIntersect(arg, arg2, arg3, arg4)
		local n9 = arg4 / 2
		local n10 = arg3 - Vector3.new(n9, n9, n9)
		local n11 = arg3 + Vector3.new(n9, n9, n9)
		local vector4 = Vector3.new(arg2.X == 0 and 0.0001 or arg2.X, arg2.Y == 0 and 0.0001 or arg2.Y, arg2.Z == 0 and 0.0001 or arg2.Z)
		local n12, n13 = (n10.X - arg.X) / vector4.X, (n11.X - arg.X) / vector4.X

		if n12 > n13 then
			n12, n13 = n13, n12
		end

		local n14, n15 = (n10.Y - arg.Y) / vector4.Y, (n11.Y - arg.Y) / vector4.Y

		if n14 > n15 then
			n14, n15 = n15, n14
		end

		if n12 > n15 or n14 > n13 then
			return false
		end

		if n14 > n12 then
			n12 = n14
		end

		if n15 < n13 then
			n13 = n15
		end

		local n16, n17 = (n10.Z - arg.Z) / vector4.Z, (n11.Z - arg.Z) / vector4.Z

		if n16 > n17 then
			n16, n17 = n17, n16
		end

		return not (n12 > n17 or n16 > n13)
	end

	local n9 = 0

	RunService.RenderStepped:Connect(function()
		n9 = n9 + 1
		if n9 % 3 ~= 0 then
			return
		end

		if mainConfig.ClickToAP then
			local mouseLocation = UIS:GetMouseLocation()
			local v9 = Workspace.CurrentCamera.ViewportPointToRay(Workspace.CurrentCamera, mouseLocation.X, mouseLocation.Y)
			local v10, huge = nil, math.huge

			for i, player_ in ipairs(Players2:GetPlayers()) do
				if player_ ~= localPlayer2 and player_.Character and player_.Character:FindFirstChild("HumanoidRootPart") then
					if rayToCubeIntersect(v9.Origin, v9.Direction, player_.Character.HumanoidRootPart.Position, mainConfig.ClickToAPRadius or 8) then
						local magnitude = (v9.Origin - player_.Character.HumanoidRootPart.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v10 = player_
						end
					end
				end
			end

			ctapHighlight.Adornee = v10 and v10.Character or nil
		elseif ctapHighlight.Adornee then
			ctapHighlight.Adornee = nil
		end
	end)

	UIS.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and mainConfig.ClickToAP then
			local mouseLocation = UIS:GetMouseLocation()
			local v9 = Workspace.CurrentCamera.ViewportPointToRay(Workspace.CurrentCamera, mouseLocation.X, mouseLocation.Y)
			local v10, huge = nil, math.huge

			for i, player_ in ipairs(Players2:GetPlayers()) do
				if player_ ~= localPlayer2 and player_.Character and player_.Character:FindFirstChild("HumanoidRootPart") then
					if rayToCubeIntersect(v9.Origin, v9.Direction, player_.Character.HumanoidRootPart.Position, mainConfig.ClickToAPRadius or 8) then
						local magnitude = (v9.Origin - player_.Character.HumanoidRootPart.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v10 = player_
						end
					end
				end
			end

			if v10 then
				local clickToAPOrder = mainConfig.ClickToAPOrder or AP_ALL_COMMANDS
				local clickToAPIndex = _G.ClickToAPIndex or 1

				if clickToAPIndex > #clickToAPOrder then
					clickToAPIndex = 1
				end

				local v11 = nil
				local n10 = 0

				while n10 < #clickToAPOrder do
					local n11 = (clickToAPIndex - 1 + n10) % #clickToAPOrder + 1
					local v12 = clickToAPOrder[n11]

					if mainConfig.ClickToAPCommands and mainConfig.ClickToAPCommands[v12] and not apIsOnCooldown(v12) then
						v11 = v12
						_G.ClickToAPIndex = n11 + 1
						break
					end

					n10 = n10 + 1
				end

				if not v11 then
					ShowNotification("CLICK AP", "No commands enabled or all on cooldown")
					return
				end

				if runAdminCommand(v10, v11) then
					local str = AP_COMMAND_EMOJIS[v11] or "\226\154\161"
					ShowNotification("CLICK AP", str .. " " .. v11 .. " \226\134\146 " .. v10.DisplayName)
				end
			end
		end
	end)

	playerESPEnabled = mainConfig.PlayerESP
	tbl7 = {}

	DANGER_TOOLS = {
		["Boogie Bomb"] = true,
		["Medusa's Head"] = true,
		["Body Swap Potion"] = true,
		["Laser Cape"] = true,
		["Rainbowrath Sword"] = true,
		["Gummy Bear"] = true,
	}

	getHeldTool = function(arg)
		local character2 = arg.Character
		if not character2 then
			return nil
		end

		for i, child in ipairs(character2:GetChildren()) do
			if child:IsA("Tool") then
				return child.Name
			end
		end

		return nil
	end

	local tbl9 = {
		Color3.fromRGB(255, 220, 0),
		Color3.fromRGB(0, 200, 255),
		Color3.fromRGB(0, 220, 80),
		Color3.fromRGB(180, 80, 255),
		Color3.fromRGB(255, 140, 0),
		Color3.fromRGB(255, 80, 180),
		Color3.fromRGB(80, 255, 220),
	}

	local tbl10 = {}

	local function fn17(arg)
		local v9 = tbl10[arg]

		if not v9 then
			local v10
			v10 = Random.new(arg.UserId + os.clock() * 1000)
			v9 = tbl9[v10.NextInteger(v10, 1, #tbl9)]
			tbl10[arg] = v9
		end

		return v9
	end

	function makePlayerBillboard(arg)
		local billboardGui = Instance.new("BillboardGui")
		local tbl11 = {}
		billboardGui.Name = "PlayerESP_" .. tostring(arg.UserId)
		billboardGui.Size = UDim2.new(0, 170, 0, 40)
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.LightInfluence = 0
		billboardGui.ResetOnSpawn = false
		local textLabel = Instance.new("TextLabel", billboardGui)
		textLabel.Name = "DisplayLabel"
		textLabel.Size = UDim2.new(1, 0, 0, 14)
		textLabel.Position = UDim2.new(0, 0, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 13
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel.Text = arg.DisplayName
		local textLabel2 = Instance.new("TextLabel", billboardGui)
		textLabel2.Name = "ToolLabel"
		textLabel2.Size = UDim2.new(1, 0, 0, 11)
		textLabel2.Position = UDim2.new(0, 0, 0, 15)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.GothamMedium
		textLabel2.TextSize = 11
		textLabel2.TextColor3 = Color3.fromRGB(100, 220, 255)
		textLabel2.TextStrokeTransparency = 0.4
		textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel2.Text = getHeldTool(arg) or ""
		local textLabel3 = Instance.new("TextLabel", billboardGui)
		textLabel3.Name = "StealLabel"
		textLabel3.Size = UDim2.new(1, 0, 0, 11)
		textLabel3.Position = UDim2.new(0, 0, 0, 26)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Font = Enum.Font.GothamBold
		textLabel3.TextSize = 11
		textLabel3.TextColor3 = Color3.fromRGB(255, 60, 60)
		textLabel3.TextStrokeTransparency = 0.4
		textLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel3.Text = ""
		return billboardGui
	end

	function createOrRefreshPlayerESP(arg)
		if not playerESPEnabled then
			return
		end

		if arg == localPlayer2 then
			return
		end
		local character2 = arg.Character
		if not character2 then
			return
		end
		local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end
		local humanoid2 = character2:FindFirstChild("Humanoid")

		if humanoid2 then
			humanoid2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end

		local userId = arg.UserId
		local v9 = tbl7[userId]

		if not v9 or not v9.bb or not v9.bb.Parent then
			if v9 and v9.bb then
				pcall(function()
					v9.bb:Destroy()
				end)
			end

			local v10, highlight
			v10 = makePlayerBillboard(arg)
			v10.Adornee = humanoidRootPart2
			v10.Parent = humanoidRootPart2

			if not _G.BJK_IS_MOBILE then
				highlight = Instance.new("Highlight")
				highlight.Name = "PlayerESP_Highlight"
				local tbl11 = {}
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.FillTransparency = 0.4
				highlight.OutlineTransparency = 0
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Adornee = character2
				highlight.Parent = character2
			end

			tbl7[userId] = { bb = v10, player = arg, highlight = highlight }
		elseif v9.bb.Adornee ~= humanoidRootPart2 then
			v9.bb.Adornee = humanoidRootPart2
			v9.bb.Parent = humanoidRootPart2
		end

		if v9.highlight and (v9.highlight.Adornee ~= character2 or not v9.highlight.Parent) then
			v9.highlight.Adornee = character2
			v9.highlight.Parent = character2
		end
	end

	function clearPlayerESP()
		for k, v9 in pairs(tbl7) do
			if v9.bb then
				pcall(v9.bb.Destroy, v9.bb)
			end

			if v9.highlight then
				pcall(v9.highlight.Destroy, v9.highlight)
			end

			tbl7[k] = nil
		end

		for k in pairs(tbl10) do
			tbl10[k] = nil
		end
	end

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			task.wait(_G.BJK_IS_MOBILE and 2.5 or 0.8)
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end

			if _G.TpOnLoadRunning then
				task.wait(1)
				continue
			end

			if playerESPEnabled then
				for i, player_ in ipairs(Players2:GetPlayers()) do
					if player_ ~= localPlayer2 then
						pcall(createOrRefreshPlayerESP, player_)
					end
				end

				if not _G._isTpMoving then
					for k, v9 in pairs(tbl7) do
						if v9.bb and v9.bb.Parent then
							pcall(function()
								local toolLabel = v9.bb:FindFirstChild("ToolLabel")

								if toolLabel then
									local v10 = getHeldTool(v9.player)
									toolLabel.Text = v10 or ""
								end
							end)

							pcall(function()
								local stealLabel = v9.bb:FindFirstChild("StealLabel")

								if stealLabel then
									if v9.player:GetAttribute("Stealing") then
										local v10, v11 = getStealingInfo(v9.player)

										if v11 then
											v9.stealName = v11
										end

										stealLabel.Text = "Stealing : " .. tostring(v9.stealName or "Brainrot")
									else
										v9.stealName = nil
										stealLabel.Text = ""
									end
								end
							end)
						end
					end
				end
			else
				clearPlayerESP()
			end
		end
	end)

	do
		local tbl11 = {}

		local function fn18(arg)
			local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
			if not plotsFolder then
				return nil
			end

			for i, child in ipairs(plotsFolder:GetChildren()) do
				if getPlotOwner(child) == arg then
					return child
				end
			end

			return nil
		end

		local function fn19(arg)
			local plotSign = arg:FindFirstChild("PlotSign")

			if plotSign then
				if plotSign:IsA("BasePart") then
					return plotSign
				end
				local basePart = plotSign:FindFirstChildWhichIsA("BasePart", true)
				if basePart then
					return basePart
				end
			end

			return arg:FindFirstChildWhichIsA("BasePart", true)
		end

		local function fn20(arg)
			local v9 = tbl11[arg]

			if v9 then
				pcall(function()
					v9.bb:Destroy()
				end)

				tbl11[arg] = nil
			end
		end

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end
				task.wait(0.5)
				if _G._isTpMoving or os.clock() - (_G.__BJKBootClock or 0) < 2 then
					continue
				end

				for i, player_ in ipairs(Players2:GetPlayers()) do
					if player_ ~= player then
						local userId = player_.UserId

						if player_:GetAttribute("Stealing") then
							local v9 = tbl11[userId]

							if not v9 or not v9.bb or not v9.bb.Parent then
								fn20(userId)

								pcall(function()
									local v10 = fn18(player_)
									local v11 = v10 and fn19(v10)
									if not v11 then
										return
									end
									local v12, v13 = getStealingInfo(player_)
									local billboardGui = Instance.new("BillboardGui")
									billboardGui.Name = "BJKBaseStealTag_" .. userId
									billboardGui.Size = UDim2.new(0, 340, 0, 46)
									billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 14, 0)
									billboardGui.AlwaysOnTop = true
									billboardGui.MaxDistance = 2000
									billboardGui.LightInfluence = 0
									local textLabel = Instance.new("TextLabel", billboardGui)
									textLabel.Size = UDim2.new(1, 0, 1, 0)
									textLabel.BackgroundTransparency = 1
									textLabel.Font = Enum.Font.GothamBlack
									textLabel.TextSize = 24
									textLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
									textLabel.TextStrokeTransparency = 0.15
									textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
									textLabel.Text = "Stealing : " .. tostring(v13 or "Brainrot")
									billboardGui.Adornee = v11
									billboardGui.Parent = v11
									tbl11[userId] = { bb = billboardGui, lbl = textLabel }
								end)
							elseif v9.lbl then
								pcall(function()
									local v10, v11 = getStealingInfo(player_)

									if v11 then
										v9.lbl.Text = "Stealing : " .. tostring(v11)
									end
								end)
							end
						else
							fn20(userId)
						end
					end
				end

				for k in pairs(tbl11) do
					if not Players2:GetPlayerByUserId(k) then
						fn20(k)
					end
				end
			end
		end)
	end

	do
		local color = Color3.fromRGB(64, 64, 64)
		local beam = nil
		local plotBeamAttachPlayer = nil
		local plotBeamAttachPlot = nil
		local v9, fn18, resetPlotBeam, fn19, fn20, fn21
		v9 = nil

		fn18 = function(arg)
			if not arg then
				return
			end
			arg.FaceCamera = true
			arg.LightEmission = 0
			arg.Color = ColorSequence.new(color)
			arg.Transparency = NumberSequence.new(0.3)
			arg.Width0 = 0.45
			local tbl11 = {}
			arg.Width1 = 0.45
			arg.TextureMode = Enum.TextureMode.Wrap
			arg.TextureSpeed = 0
			arg.Enabled = true
		end

		resetPlotBeam = function()
			if beam then
				pcall(function()
					beam:Destroy()
				end)
			end

			local humanoidRootPart2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 then
				local plotBeamGlow = humanoidRootPart2:FindFirstChild("PlotBeamGlow")

				if plotBeamGlow then
					pcall(function()
						plotBeamGlow:Destroy()
					end)
				end
			end

			if plotBeamAttachPlayer then
				pcall(function()
					plotBeamAttachPlayer:Destroy()
				end)
			end

			if plotBeamAttachPlot then
				pcall(function()
					plotBeamAttachPlot:Destroy()
				end)
			end

			beam, plotBeamAttachPlayer, plotBeamAttachPlot = nil, nil, nil
			v9 = nil
		end

		fn19 = function()
			local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
			if not plotsFolder then
				return nil
			end

			for i, child in ipairs(plotsFolder:GetChildren()) do
				if _G.isMyPlot_Instant and _G.isMyPlot_Instant(child.Name) then
					return child
				end
			end

			for i, child in ipairs(plotsFolder:GetChildren()) do
				local plotSign = child:FindFirstChild("PlotSign")

				if plotSign then
					local yourBase = plotSign:FindFirstChild("YourBase")
					if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
						return child
					end
					local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)

					if surfaceGui then
						local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)

						if textLabel then
							local str = textLabel.Text:lower()
							if str:find(localPlayer2.DisplayName:lower(), 1, true) or str:find(localPlayer2.Name:lower(), 1, true) then
								return child
							end
						end
					end
				end
			end

			return nil
		end

		fn20 = function(arg)
			if not arg then
				return nil
			end
			local plotSign = arg:FindFirstChild("PlotSign")

			if plotSign then
				if plotSign:IsA("BasePart") then
					return plotSign
				end
				local basePart = plotSign:FindFirstChildWhichIsA("BasePart", true)
				if basePart then
					return basePart
				end
			end

			local mainRootPart = arg:FindFirstChild("MainRootPart")
			if mainRootPart and mainRootPart:IsA("BasePart") then
				return mainRootPart
			end
			return arg:FindFirstChildWhichIsA("BasePart")
		end

		fn21 = function(parent, parent2)
			if not parent or not parent.Parent or not parent2 or not parent2.Parent then
				return
			end

			if not plotBeamAttachPlayer or not plotBeamAttachPlayer.Parent or plotBeamAttachPlayer.Parent ~= parent then
				if plotBeamAttachPlayer then
					pcall(function()
						plotBeamAttachPlayer:Destroy()
					end)
				end

				plotBeamAttachPlayer = parent:FindFirstChild("PlotBeamAttach_Player") or Instance.new("Attachment")
				plotBeamAttachPlayer.Name = "PlotBeamAttach_Player"
				plotBeamAttachPlayer.Position = Vector3.new(0, 0, 0)
				plotBeamAttachPlayer.Parent = parent
			end

			if v9 ~= parent2 or not plotBeamAttachPlot or not plotBeamAttachPlot.Parent then
				if plotBeamAttachPlot then
					pcall(function()
						plotBeamAttachPlot:Destroy()
					end)
				end

				local tbl11 = {}
				plotBeamAttachPlot = parent2:FindFirstChild("PlotBeamAttach_Plot") or Instance.new("Attachment")
				plotBeamAttachPlot.Name = "PlotBeamAttach_Plot"
				plotBeamAttachPlot.Position = Vector3.new(0, 4, 0)
				plotBeamAttachPlot.Parent = parent2
				v9 = parent2

				if beam then
					beam.Attachment1 = plotBeamAttachPlot
				end
			end

			if not beam or not beam.Parent then
				if beam then
					pcall(function()
						beam:Destroy()
					end)
				end

				local plotBeamGlow = parent:FindFirstChild("PlotBeamGlow")

				if plotBeamGlow then
					pcall(function()
						plotBeamGlow:Destroy()
					end)
				end

				local tbl11 = {}
				beam = Instance.new("Beam")
				beam.Name = "PlotBeam"
				beam.Attachment0 = plotBeamAttachPlayer
				beam.Attachment1 = plotBeamAttachPlot
				fn18(beam)
				beam.Parent = parent
			else
				beam.Attachment0 = plotBeamAttachPlayer
				beam.Attachment1 = plotBeamAttachPlot
				fn18(beam)
			end
		end

		local function createPlotBeam()
			if not mainConfig.LineToBase then
				return
			end
			local character2 = localPlayer2.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart2 then
				return
			end
			local v10 = fn19()
			if not v10 then
				return
			end
			local v11 = fn20(v10)
			if not v11 then
				return
			end
			pcall(fn21, humanoidRootPart2, v11)
		end

		task.spawn(function()
			local n10 = 0

			RunService.Heartbeat:Connect(function()
				if not mainConfig.LineToBase then
					if beam or plotBeamAttachPlayer or plotBeamAttachPlot then
						resetPlotBeam()
					end

					return
				end

				n10 = n10 + 1
				if n10 < 10 then
					return
				end
				n10 = 0
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

				if not humanoidRootPart2 then
					if beam or plotBeamAttachPlayer or plotBeamAttachPlot then
						resetPlotBeam()
					end

					return
				end

				local v10 = fn19()

				if not v10 then
					if beam or plotBeamAttachPlot then
						if beam then
							pcall(function()
								beam:Destroy()
							end)

							beam = nil
						end

						if plotBeamAttachPlot then
							pcall(function()
								plotBeamAttachPlot:Destroy()
							end)

							plotBeamAttachPlot = nil
						end

						v9 = nil
					end

					return
				end

				local v11 = fn20(v10)
				if not v11 or not v11.Parent then
					return
				end
				pcall(fn21, humanoidRootPart2, v11)
			end)
		end)

		localPlayer2.CharacterAdded:Connect(function()
			task.wait(0.5)
			v9 = nil
			plotBeamAttachPlayer = nil

			if beam then
				pcall(function()
					beam:Destroy()
				end)

				beam = nil
			end

			if mainConfig.LineToBase then
				pcall(createPlotBeam)
			end
		end)

		if localPlayer2.Character and mainConfig.LineToBase then
			task.defer(createPlotBeam)
		end

		_G.createPlotBeam = createPlotBeam
		_G.resetPlotBeam = resetPlotBeam
	end

	do
		local color = Color3.fromRGB(255, 45, 190)
		local beam = nil
		local bestPetBeamAttachPlayer = nil
		local bestPetBeamAttachTarget = nil
		local v9 = nil

		local function resetBrainrotBeam()
			if beam then
				pcall(function()
					beam:Destroy()
				end)
			end

			if bestPetBeamAttachPlayer then
				pcall(function()
					bestPetBeamAttachPlayer:Destroy()
				end)
			end

			if bestPetBeamAttachTarget then
				pcall(function()
					bestPetBeamAttachTarget:Destroy()
				end)
			end

			beam, bestPetBeamAttachPlayer, bestPetBeamAttachTarget = nil, nil, nil
			v9 = nil
		end

		local function fn18()
			if not SharedState.AllAnimalsCache or #SharedState.AllAnimalsCache == 0 then
				return nil
			end
			local minGenForGrab, v10, v11
			minGenForGrab = mainConfig.StealNearest and mainConfig.TpSettings.MinGenForGrab or mainConfig.TpSettings.MinGenForTp
			v10 = parseMinGen(minGenForGrab)
			v11 = nil

			if manuallySelectedUID then
				for i, v12 in ipairs(SharedState.AllAnimalsCache) do
					if v12.uid == manuallySelectedUID and v12.owner ~= localPlayer2.Name then
						if v10 > 0 and (tonumber(v12.genValue) or 0) < v10 then
							break
						end
						v11 = v12
						break
					end
				end
			end

			if not v11 then
				if _G.BJK_StealStatus and _G.BJK_StealStatus.target and _G.BJK_StealStatus.target.plot and _G.BJK_StealStatus.target.slot then
					local str = _G.BJK_StealStatus.target.plot .. "_" .. tostring(_G.BJK_StealStatus.target.slot)

					for i, v12 in ipairs(SharedState.AllAnimalsCache) do
						if v12.uid == str and v12.owner ~= localPlayer2.Name then
							if v10 > 0 and (tonumber(v12.genValue) or 0) < v10 then
								break
							end
							v11 = v12
							break
						end
					end
				end
			end

			if not v11 then
				if mainConfig.StealMode == "Priority" then
					local n10 = 0

					for i, v12 in ipairs(priorityList) do
						local str = v12:lower()

						for i2, v13 in ipairs(SharedState.AllAnimalsCache) do
							if v13 and v13.name and v13.name:lower() == str and v13.owner ~= localPlayer2.Name then
								if v10 > 0 and (tonumber(v13.genValue) or 0) < v10 then
									continue
								end
								local n11 = (v13.genValue or 0) + 1000000000000000

								if n11 > n10 then
									n10 = n11
									v11 = v13
								end
							end
						end

						if v11 then
							break
						end
					end
				end
			end

			if mainConfig.StealMode ~= "Priority" then
				if not v11 then
					local n10 = 0

					for i, v12 in ipairs(SharedState.AllAnimalsCache) do
						if v12 and v12.owner ~= localPlayer2.Name and v12.genValue and v12.genValue >= 10000000 then
							if v10 > 0 and (tonumber(v12.genValue) or 0) < v10 then
								continue
							end

							if v12.genValue > n10 then
								n10 = v12.genValue
								v11 = v12
							end
						end
					end
				end

				if not v11 then
					local n10 = 0

					for i, v12 in ipairs(SharedState.AllAnimalsCache) do
						if v12 and v12.owner ~= localPlayer2.Name and (v12.genValue or 0) >= 1 then
							if v10 > 0 and (tonumber(v12.genValue) or 0) < v10 then
								continue
							end

							if (v12.genValue or 0) > n10 then
								n10 = v12.genValue or 0
								v11 = v12
							end
						end
					end
				end
			end

			if not v11 then
				return nil
			end
			local v12 = findAdorneeGlobal(v11)
			if v12 and v12:IsA("BasePart") then
				return v12
			end
			return nil
		end

		local function fn19(parent, parent2)
			if not parent or not parent.Parent or not parent2 or not parent2.Parent then
				return
			end

			if not bestPetBeamAttachPlayer or not bestPetBeamAttachPlayer.Parent or bestPetBeamAttachPlayer.Parent ~= parent then
				if bestPetBeamAttachPlayer then
					pcall(function()
						bestPetBeamAttachPlayer:Destroy()
					end)
				end

				bestPetBeamAttachPlayer = parent:FindFirstChild("BestPetBeamAttach_Player") or Instance.new("Attachment")
				bestPetBeamAttachPlayer.Name = "BestPetBeamAttach_Player"
				bestPetBeamAttachPlayer.Position = Vector3.new(0, 0, 0)
				bestPetBeamAttachPlayer.Parent = parent
			end

			if v9 ~= parent2 or not bestPetBeamAttachTarget or not bestPetBeamAttachTarget.Parent then
				if bestPetBeamAttachTarget then
					pcall(function()
						bestPetBeamAttachTarget:Destroy()
					end)
				end

				bestPetBeamAttachTarget = parent2:FindFirstChild("BestPetBeamAttach_Target") or Instance.new("Attachment")
				bestPetBeamAttachTarget.Name = "BestPetBeamAttach_Target"
				bestPetBeamAttachTarget.Position = Vector3.new(0, 3, 0)
				bestPetBeamAttachTarget.Parent = parent2
				v9 = parent2

				if beam then
					beam.Attachment1 = bestPetBeamAttachTarget
				end
			end

			if not beam or not beam.Parent then
				if beam then
					pcall(function()
						beam:Destroy()
					end)
				end

				beam = Instance.new("Beam")
				beam.Name = "BestPetBeam"
				local tbl11 = {}
				beam.Attachment0 = bestPetBeamAttachPlayer
				beam.Attachment1 = bestPetBeamAttachTarget
				beam.FaceCamera = true
				beam.LightEmission = 1
				beam.Color = ColorSequence.new(color)
				beam.Transparency = NumberSequence.new(0.35)
				beam.Width0 = 0.45
				beam.Width1 = 0.45
				beam.TextureMode = Enum.TextureMode.Wrap
				beam.TextureSpeed = 0
				beam.Parent = parent
			end
		end

		local tbl11 = {}

		task.spawn(function()
			local n10 = 0

			RunService.Heartbeat:Connect(function()
				if not mainConfig.LineToBrainrot then
					if beam or bestPetBeamAttachPlayer or bestPetBeamAttachTarget then
						resetBrainrotBeam()
					end

					return
				end

				n10 = n10 + 1
				if n10 < 10 then
					return
				end
				n10 = 0
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

				if not humanoidRootPart2 then
					if beam or bestPetBeamAttachPlayer or bestPetBeamAttachTarget then
						resetBrainrotBeam()
					end

					return
				end

				local v10 = fn18()

				if not v10 or not v10.Parent then
					if beam or bestPetBeamAttachTarget then
						if beam then
							pcall(function()
								beam:Destroy()
							end)

							beam = nil
						end

						if bestPetBeamAttachTarget then
							pcall(function()
								bestPetBeamAttachTarget:Destroy()
							end)

							bestPetBeamAttachTarget = nil
						end

						v9 = nil
					end

					return
				end

				pcall(fn19, humanoidRootPart2, v10)

				if beam then
					local color2 = color

					if localPlayer2:GetAttribute("Stealing") then
						color2 = Color3.fromRGB(80, 255, 120)
					else
						local magnitude = humanoidRootPart2 and v10 and (humanoidRootPart2.Position - v10.Position).Magnitude or math.huge

						if magnitude < 30 then
							color2 = Color3.fromRGB(255, 196, 72)
						end
					end

					beam.Color = ColorSequence.new(color2)
				end
			end)
		end)

		localPlayer2.CharacterAdded:Connect(function()
			task.wait(0.5)
			v9 = nil
			bestPetBeamAttachPlayer = nil

			if beam then
				pcall(function()
					beam:Destroy()
				end)

				beam = nil
			end
		end)

		_G.updateBrainrotBeam = function() end
		_G.resetBrainrotBeam = resetBrainrotBeam
		_G.resetBestPetBeam = resetBrainrotBeam
	end

	carpetESPEnabled = mainConfig.CarpetESP
	local BrainrotESP = _G.BJKBuscaGui("BrainrotESP")

	if not BrainrotESP then
		BrainrotESP = Instance.new("ScreenGui")
		BrainrotESP.Name = "BrainrotESP"
		BrainrotESP.ResetOnSpawn = false
		BrainrotESP.Parent = gethui and gethui() or game:GetService("CoreGui")
	end

	local tbl11 = {
		Cursed = Color3.fromRGB(255, 50, 50),
		Gold = Color3.fromRGB(255, 215, 0),
		Diamond = Color3.fromRGB(0, 255, 255),
		YinYang = Color3.fromRGB(220, 220, 220),
		Rainbow = Color3.fromRGB(255, 100, 200),
		Lava = Color3.fromRGB(255, 100, 20),
		Candy = Color3.fromRGB(255, 105, 180),
		Bloodrot = Color3.fromRGB(139, 0, 0),
		Radioactive = Color3.fromRGB(0, 255, 0),
		Divine = Color3.fromRGB(255, 255, 255),
		Cyber = Color3.fromRGB(0, 219, 255),
	}

	local color = Color3.fromRGB(0, 255, 150)

	local tbl12 = {
		Radioactive = "68F500",
		Galaxy = "AA3CFF",
		Yinyang = "DCDCDC",
		YinYang = "DCDCDC",
		Cyber = "7BDBFF",
		Bloodrot = "91001B",
		Candy = "C0C0C0",
		Cursed = "F53838",
		Diamond = "25C4FE",
		Divine = "FFD13B",
		Gold = "FFDE59",
		Normal = "A0A0A0",
		Lava = "FF9500",
		Rainbow = "FF00FB",
		Phantom = "B4B4B4",
		Crystal = "DA70D6",
		Shiny = "FFD700",
		Golden = "FFD700",
		DarkMatter = "9932CC",
		Neon = "FF00FF",
		Luminous = "FFFACD",
		Glossy = "87CEEB",
		Glow = "00FF7F",
		Radiant = "FF4500",
		Titanium = "C0C0C0",
		Holographic = "FF69B4",
		Corrupted = "8B0000",
		Magma = "FF6347",
		Frost = "E0FFFF",
		Shadow = "2F2F2F",
		Zombie = "556B2F",
		Skeleton = "F5F5DC",
		Ghost = "DDA0DD",
		Toxic = "7FFF00",
		Thunder = "FFFF00",
		Cosmo = "7B68EE",
		Mosaic = "FF8C00",
		Icy = "ADD8E6",
		Fiery = "FF4500",
		Stormy = "4682B4",
		Angel = "FFE4E1",
		Demon = "DC143C",
		Metallic = "B8860B",
	}

	local function fn18(arg)
		if not arg or arg <= 0 then
			return "$0/s"
		end

		local function fn19(arg2)
			local str = string.format("%.2f", arg2)
			str = str:gsub("0+$", ""):gsub("%.$", "")
			return str
		end

		if arg >= 1000000000000 then
			return "$" .. fn19(arg / 1000000000000) .. "T/s"
		elseif arg >= 1000000000 then
			return "$" .. fn19(arg / 1000000000) .. "B/s"
		elseif arg >= 1000000 then
			return "$" .. fn19(arg / 1000000) .. "M/s"
		elseif arg >= 1000 then
			return "$" .. fn19(arg / 1000) .. "K/s"
		else
			return "$" .. tostring(math.floor(arg)) .. "/s"
		end
	end

	local function fn19(arg, arg2)
		if not arg or arg == "" then
			return "Brainrot", "$0/s", 0, "None"
		end
		local flag3 = arg2 and arg2 ~= "" and arg2 ~= "None" and arg2 or nil
		local n10 = 0
		local ok, result = pcall(_G._xenGen, arg, flag3, nil)

		if ok and type(result) == "number" and result > 0 then
			n10 = result
		end

		return arg, fn18(n10), n10, flag3 or "None"
	end

	local function fn20()
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
		if not plotsFolder then
			return nil
		end

		for i, child in ipairs(plotsFolder:GetChildren()) do
			local ok, result = pcall(_G.XenSyncGet, child.Name)

			if ok and result then
				local ok2, result2 = pcall(function()
					return result:Get("Owner")
				end)

				if ok2 and result2 then
					local flag3 = false

					if typeof(result2) == "Instance" and result2:IsA("Player") then
						flag3 = result2.UserId == localPlayer2.UserId
					elseif typeof(result2) == "table" and result2.UserId then
						flag3 = result2.UserId == localPlayer2.UserId
					elseif typeof(result2) == "Instance" then
						flag3 = result2 == localPlayer2
					end

					if flag3 then
						return child
					end
				end
			end
		end

		for i, child in ipairs(plotsFolder:GetChildren()) do
			local plotSign = child:FindFirstChild("PlotSign")

			if plotSign then
				local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)

				if surfaceGui then
					local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)

					if textLabel then
						local str = textLabel.Text:lower()
						if str:find(localPlayer2.DisplayName:lower(), 1, true) or str:find(localPlayer2.Name:lower(), 1, true) then
							return child
						end
					end
				end
			end
		end

		return nil
	end

	local function fn21(arg, arg2)
		if not arg then
			return false
		end
		local v9 = fn20()
		if not v9 then
			return false
		end
		local ok, result = pcall(_G.XenSyncGet, v9.Name)
		if not ok or not result then
			return false
		end

		local ok2, result2 = pcall(function()
			return result:Get("AnimalList")
		end)

		if not ok2 or not result2 then
			return false
		end
		local flag3 = arg2 and arg2 ~= "None" and arg2 or nil

		for k, v10 in pairs(result2) do
			if type(v10) == "table" then
				local mutation = v10.Mutation and v10.Mutation ~= "" and v10.Mutation ~= "None" and v10.Mutation or nil

				if v10.Index == arg then
					if flag3 == nil or mutation == flag3 then
						return true
					end
				end
			end
		end

		return false
	end

	local tbl13 = {}

	pcall(function()
		for i, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Purchase" then
				tbl13[descendant] = true
			end
		end

		Workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Purchase" then
				tbl13[descendant] = true
			end
		end)

		Workspace.DescendantRemoving:Connect(function(descendant)
			tbl13[descendant] = nil
		end)
	end)

	local function fn22()
		local tbl14 = {}

		for k in pairs(tbl13) do
			if k and k.Parent and k:IsA("ProximityPrompt") and k.Enabled and k.ActionText == "Purchase" then
				local parent = k.Parent
				local parent2 = parent:IsA("Attachment") and parent.Parent or parent

				if parent2 and parent2:IsA("BasePart") then
					local v9, parent3 = nil, parent2

					for i = 1, 10 do
						if parent3 and parent3:IsA("Model") then
							v9 = parent3
							break
						end
						parent3 = parent3 and parent3.Parent
					end

					if v9 then
						table.insert(tbl14, {
							prompt = k,
							part = parent2,
							model = v9,
							index = v9:GetAttribute("Index") or v9:GetAttribute("AnimalIndex") or v9.Name,
							mutation = v9:GetAttribute("Mutation") or v9:GetAttribute("AnimalMutation") or "None",
						})
					end
				end
			end
		end

		return tbl14
	end

	fn9 = function(adornee, adornee2, arg, text, arg2)
		local flag3 = arg2 and arg2 ~= "None"
		local color2 = flag3 and (tbl11[arg2] or Color3.fromRGB(200, 100, 255)) or color
		local tbl14 = {}
		local highlight

		if not _G.BJK_IS_MOBILE then
			highlight = Instance.new("Highlight")
			highlight.Adornee = adornee2 or adornee
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.FillTransparency = 0.6
			highlight.FillColor = color2
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = color2
			highlight.Parent = BrainrotESP
		end

		tbl14.highlight = highlight
		local billboardGui, textLabel
		billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "CarpetESP"
		billboardGui.Adornee = adornee
		billboardGui.Size = UDim2.new(0, 160, 0, 44)
		billboardGui.StudsOffset = Vector3.new(0, 1.8, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.LightInfluence = 0
		billboardGui.MaxDistance = 3000
		billboardGui.Parent = BrainrotESP
		tbl14.billboard = billboardGui
		local frame = Instance.new("Frame", billboardGui)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 0.6
		frame.BorderSizePixel = 0
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Color = Color3.new(1, 1, 1)
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.6
		local textLabel2 = Instance.new("TextLabel", frame)
		textLabel2.Size = UDim2.new(1, -6, 0.55, 0)
		textLabel2.Position = UDim2.new(0, 3, 0, 1)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.GothamBold
		textLabel2.TextSize = 13
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel2.TextStrokeTransparency = 0
		textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel2.RichText = true
		textLabel2.Text = arg .. " <font color=\"#FF2828\">[CARPET]</font>"
		textLabel2.TextXAlignment = Enum.TextXAlignment.Center
		textLabel = Instance.new("TextLabel", frame)
		textLabel.Size = UDim2.new(1, -6, 0.45, 0)
		textLabel.Position = UDim2.new(0, 3, 0.55, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 11
		textLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.RichText = true

		if flag3 then
			local str = tbl12[arg2] or "FFFFFF"
			textLabel.Text = text .. " <font color='#" .. str .. "'>" .. arg2 .. "</font>"
		else
			textLabel.Text = text
		end

		textLabel.TextXAlignment = Enum.TextXAlignment.Center
		tbl14.nameLabel = textLabel2
		tbl14.valueLabel = textLabel
		return tbl14
	end

	fn10 = function(arg)
		if not arg then
			return
		end

		if arg.highlight then
			pcall(function()
				arg.highlight:Destroy()
			end)
		end

		if arg.billboard then
			pcall(function()
				arg.billboard:Destroy()
			end)
		end
	end

	v2 = nil
	model = nil
	n2 = -1
	v3 = nil
	local v9 = nil
	local flag3 = false
	v4 = nil
	v5 = nil
	n3 = -1
	v6 = nil
	v7 = nil
	v8 = nil
	local v10 = nil

	local function fn23()
		local tbl14 = {}
		fn10(v2)
		v2 = nil
		model = nil
		n2 = -1
		v3 = nil
		v9 = nil
	end

	local function fn24()
		flag3 = false
		v4 = nil
		v5 = nil
		n3 = -1
		v6 = nil
		v7 = nil
		v8 = nil

		if v10 and v10.Parent then
			pcall(function()
				v10:Destroy()
			end)
		end

		v10 = nil
	end

	local function createPart()
		if v10 and v10.Parent then
			return v10
		end
		local character2 = localPlayer2.Character
		local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
		local part = Instance.new("Part")
		part.Name = "CarpetESPAnchor"
		part.Size = Vector3.new(0.1, 0.1, 0.1)
		part.Transparency = 1
		part.CanCollide = false
		local tbl14 = {}
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false

		if humanoidRootPart2 then
			part.Anchored = false
			part.CFrame = humanoidRootPart2.CFrame + Vector3.new(0, 3, 0)
			part.Parent = humanoidRootPart2
			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = humanoidRootPart2
			weldConstraint.Part1 = part
			weldConstraint.Parent = part
		else
			part.Anchored = true
			part.Position = Vector3.new(0, 5, 0)
			part.Parent = Workspace
		end

		v10 = part
		return part
	end

	local function fn25()
		local v11 = createPart()
		fn10(v2)
		v2 = fn9(v11, v11, v4, v5, v6)
		model = nil
		n2 = n3
	end

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end
			task.wait(0.5)
			if not carpetESPEnabled then
				continue
			end

			pcall(function()
				local flag4 = false
				local n10 = -1
				local minCarpetESPGen = mainConfig.MinCarpetESPGen or ""
				local v11 = parseGenInput(minCarpetESPGen)

				if minCarpetESPGen ~= "" and minCarpetESPGen ~= "0" and v11 and v11 > 0 then
					n10 = v11
				end

				if flag3 then
					if n3 >= 0 and n10 > 0 and n3 < n10 then
						fn23()
						fn24()
						flag4 = true
					elseif fn21(v7, v8) then
						fn23()
						fn24()
						return
					end

					local v12 = fn22()

					for i, v13 in ipairs(v12) do
						if v13.model and v13.model.Parent and v13.part and v13.part.Parent then
							local v14, v15, v16, v17 = fn19(v13.index, v13.mutation)

							if v16 >= n10 and v16 > n3 then
								fn23()
								fn24()
								flag4 = true
								break
							end
						end
					end

					if not flag4 then
						if not v2 or not v2.billboard or not v2.billboard.Parent then
							fn25()
						end

						return
					end
				end

				local v12 = fn22()

				if #v12 == 0 then
					if model and not model.Parent and n2 > 0 and n2 >= n10 then
						if fn21(v3, v9) then
							flag3 = true
							n3 = n2
							v7 = v3
							v8 = v9
							fn25()
							return
						end
					end

					fn23()
					return
				end

				local v13, str, str2, n11, str3, index, mutation = nil, "", "$0/s", -1, "None", nil, nil

				for i, v14 in ipairs(v12) do
					if v14.model and v14.model.Parent and v14.part and v14.part.Parent then
						local v15, v16, v17, v18 = fn19(v14.index, v14.mutation)

						if v17 >= n10 and v17 > n11 then
							n11 = v17
							v13 = v14
							str = v15
							str2 = v16
							str3 = v18
							index = v14.index
							mutation = v14.mutation
						end
					end
				end

				if not v13 then
					fn23()
					return
				end

				if model and model.Parent then
					local flag5 = false

					for i, descendant in ipairs(model.GetDescendants(model)) do
						if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Purchase" then
							flag5 = true
							break
						end
					end

					if not flag5 then
						if fn21(v3, v9) then
							if n11 <= n2 then
								flag3 = true
								n3 = n2
								v7 = v3
								v8 = v9
								fn25()
								return
							end
						end

						model = nil
					end
				end

				local flag5 = v2 and v2.billboard and v2.billboard.Parent and model and model.Parent and model == v13.model
				if flag5 then
					return
				end
				fn23()
				v2 = fn9(v13.part, v13.model, str, str2, str3)
				model = v13.model
				n2 = n11
				v3 = index
				v9 = mutation
				v4 = str
				v5 = str2
				v6 = str3
			end)
		end
	end)

	localPlayer2.CharacterAdded:Connect(function()
		if v10 and v10.Parent then
			pcall(function()
				v10:Destroy()
			end)

			v10 = nil
		end

		if flag3 then
			task.wait(0.3)
			fn25()
		end
	end)

	_G.setCarpetESP = function(arg)
		carpetESPEnabled = arg and true or false
		mainConfig.CarpetESP = carpetESPEnabled

		if not carpetESPEnabled then
			fn23()
			fn24()
		end
	end

	_G.ToggleCarpetESP = function()
		_G.setCarpetESP(not carpetESPEnabled)
	end

	timerESPEnabled = mainConfig.TimerESP

	clearTimerESP = function()
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")

		if plotsFolder then
			for i, child in ipairs(plotsFolder:GetChildren()) do
				for i2, descendant in ipairs(child:GetDescendants()) do
					if descendant.Name == "TimerESP" and descendant:IsA("BillboardGui") then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end
		end
	end

	_G.clearTimerESP = clearTimerESP

	function refreshTimerESP()
		if not timerESPEnabled then
			clearTimerESP()
			return
		end
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
		if not plotsFolder then
			return
		end

		for i, child in ipairs(plotsFolder:GetChildren()) do
			local tbl14 = {}
			local huge = math.huge

			for i2, descendant in ipairs(child:GetDescendants()) do
				if descendant:IsA("BillboardGui") and descendant:FindFirstChild("RemainingTime") then
					local adornee = descendant.Adornee or descendant.Parent

					if adornee and adornee:IsA("BasePart") then
						tbl14[#tbl14 + 1] = { g = descendant, base = adornee, y = adornee.Position.Y }

						if adornee.Position.Y < huge then
							huge = adornee.Position.Y
						end
					end
				end
			end

			for i2, v11 in ipairs(tbl14) do
				local base, g = v11.base, v11.g
				local timerESP = base:FindFirstChild("TimerESP")

				if v11.y <= huge + 4 then
					local remainingTime = g:FindFirstChild("RemainingTime")

					if remainingTime then
						if not timerESP then
							local billboardGui = Instance.new("BillboardGui")
							billboardGui.Name = "TimerESP"
							billboardGui.Adornee = base
							billboardGui.Size = UDim2.new(0, 98, 0, 26)
							billboardGui.AlwaysOnTop = true
							billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
							local textLabel = Instance.new("TextLabel", billboardGui)
							textLabel.Size = UDim2.new(1, 0, 1, 0)
							textLabel.BackgroundTransparency = 1
							textLabel.Text = remainingTime.Text
							textLabel.Font = Enum.Font.GothamBold
							textLabel.TextSize = 15
							textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
							textLabel.TextStrokeTransparency = 0.35
							textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
							billboardGui.Parent = base
						else
							timerESP.TextLabel.Text = remainingTime.Text
						end
					end
				elseif timerESP then
					pcall(function()
						timerESP:Destroy()
					end)
				end
			end
		end
	end

	task.spawn(function()
		while true do
			if _G.BJK_HubGen ~= bjkHubGen then
				break
			end

			if not _G.BJK_Ready then
				task.wait(_G.BJK_IS_MOBILE and 2.5 or 0.8)
				continue
			end

			if timerESPEnabled then
				pcall(refreshTimerESP)
			else
				clearTimerESP()
			end

			task.wait(_G.BJK_IS_MOBILE and 2.5 or 0.8)
		end
	end)

	do
		local baseOwnerESP = mainConfig.BaseOwnerESP
		local tbl14 = {}

		local function fn26(arg)
			if not arg then
				return
			end

			if arg.hl then
				pcall(function()
					arg.hl:Destroy()
				end)
			end

			if arg.bb then
				pcall(function()
					arg.bb:Destroy()
				end)
			end
		end

		local function clearBaseOwnerESP()
			for k, v11 in pairs(tbl14) do
				fn26(v11)
				tbl14[k] = nil
			end
		end

		local function createBillboardGui()
			local billboardGui = Instance.new("BillboardGui")
			local textLabel
			billboardGui.Name = "BaseOwnerTag"
			billboardGui.Size = UDim2.new(0, 160, 0, 34)
			billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0)
			billboardGui.AlwaysOnTop = true
			billboardGui.LightInfluence = 0
			textLabel = Instance.new("TextLabel", billboardGui)
			textLabel.Size = UDim2.fromScale(1, 1)
			textLabel.BackgroundTransparency = 1
			textLabel.Font = Enum.Font.GothamBlack
			textLabel.TextSize = 18
			textLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
			textLabel.TextStrokeTransparency = 0
			textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			textLabel.Text = "BASE OWNER"
			return billboardGui
		end

		local fn27, fn28

		fn27 = function(arg)
			for k, v11 in pairs(tbl14) do
				if not arg or k ~= arg.UserId then
					fn26(v11)
					tbl14[k] = nil
				end
			end

			if not arg or not arg.Character then
				return
			end
			local userId = arg.UserId
			local tbl15 = tbl14[userId]

			if not tbl15 then
				tbl15 = {}
				tbl14[userId] = tbl15
			end

			if not tbl15.hl or not tbl15.hl.Parent then
				if tbl15.hl then
					pcall(function()
						tbl15.hl:Destroy()
					end)
				end

				if _G.BJK_IS_MOBILE then
					tbl15.hl = nil
				else
					local highlight = Instance.new("Highlight")
					highlight.Name = "BaseOwnerESP"
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.FillTransparency = 0.6
					highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
					local tbl16 = {}
					highlight.OutlineTransparency = 0
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.Parent = CoreGui
					tbl15.hl = highlight
				end
			end

			if tbl15.hl and tbl15.hl.Adornee ~= arg.Character then
				tbl15.hl.Adornee = arg.Character
			end

			if not tbl15.bb or not tbl15.bb.Parent then
				if tbl15.bb then
					pcall(function()
						tbl15.bb:Destroy()
					end)
				end

				tbl15.bb = createBillboardGui()
				tbl15.bb.Parent = CoreGui
			end

			local head = arg.Character:FindFirstChild("Head") or arg.Character:FindFirstChild("HumanoidRootPart")

			if head and tbl15.bb.Adornee ~= head then
				tbl15.bb.Adornee = head
			end
		end

		fn28 = function()
			local character2 = localPlayer2.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart2 then
				fn27(nil)
				return
			end
			local v11 = getPlotAtPosition(humanoidRootPart2.Position)
			local v12 = v11 and getPlotOwner(v11)

			if v12 == localPlayer2 then
				v12 = nil
			end

			fn27(v12)
		end

		_G.setBaseOwnerESP = function(baseOwnerESP2)
			baseOwnerESP = baseOwnerESP2
			mainConfig.BaseOwnerESP = baseOwnerESP2
			saveConfig()
			setToggle("Base Owner ESP", baseOwnerESP2)

			if baseOwnerESP2 then
				pcall(fn28)
			else
				clearBaseOwnerESP()
			end
		end

		_G.clearBaseOwnerESP = clearBaseOwnerESP

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end
				task.wait(_G.BJK_IS_MOBILE and 2 or 0.5)

				if baseOwnerESP then
					pcall(fn28)
				end
			end
		end)
	end

	(function()
		local n10, tbl14
		laserOriginalState = setmetatable({}, { __mode = "k" })
		_plotLaserOpenState = {}
		_plotMonitorSetup = {}
		_plotsFolderHooked = false
		_BLOCK_TIME_KEYS = { "BlockEndTimeFirstFloor", "BlockEndTimeSecondFloor", "BlockEndTime" }

		IsLaserObject = function(arg)
			if not arg then
				return false
			end

			if arg.Name == "Laser" or arg.Name == "LaserHitbox" then
				return true
			end
			local str = arg.Name:lower()
			if str:find("laser") then
				return true
			end
			local parent = arg.Parent

			while parent and parent ~= Workspace do
				if parent.Name == "Laser" then
					return true
				end

				if parent.Name:lower():find("laser") then
					return true
				end
				parent = parent.Parent
			end

			return false
		end

		function GetPlotFromObject(arg)
			local parent = arg and arg.Parent

			while parent and parent ~= Workspace do
				if parent.Parent and parent.Parent.Name == "Plots" then
					return parent
				end
				parent = parent.Parent
			end

			return nil
		end

		local tbl15 = {}
		n10 = 0.6
		tbl14 = {}

		readPlotChannel = function(arg)
			local now = os.clock()
			local v11 = tbl15[arg]
			if v11 and now - v11.t < n10 then
				return v11.ch
			end
			local getSync = _G.__getSync and _G.__getSync()

			if getSync then
				local v12 = nil

				pcall(function()
					v12 = _G.XenSyncGet(arg)
				end)

				if not v12 then
					if not tbl14[arg] or now - tbl14[arg] > 0.3 then
						tbl14[arg] = now
						local now2 = os.clock()

						repeat
							v12 = _G.XenSyncGet(arg)
							if v12 then
								break
							end
							task.wait(0.02)
						until os.clock() - now2 > 0.2
					end
				end

				if v12 then
					tbl14[arg] = nil
					tbl15[arg] = { ch = v12, t = now }
					return v12
				end
			end

			if _G.stealthGet then
				return _G.stealthGet(arg)
			end
			return nil
		end

		readChannelProp = function(arg, arg2)
			if not arg then
				return nil
			end
			local sProp = _G.sProp and _G.sProp(arg, arg2)
			if sProp ~= nil then
				return sProp
			end

			pcall(function()
				if type(arg.Get) == "function" then
					sProp = arg:Get(arg2)
				end
			end)

			if sProp ~= nil then
				return sProp
			end

			pcall(function()
				if arg.CacheTable then
					sProp = arg.CacheTable[arg2]
				end
			end)

			return sProp
		end

		isBlockTimeActive = function(arg)
			if arg == nil or arg == false then
				return false
			end

			if type(arg) == "number" then
				return arg > os.time()
			end

			if type(arg) == "table" then
				local value = rawget(arg, "EndTime") or rawget(arg, "endTime") or rawget(arg, "Time")
				if type(value) == "number" then
					return value > os.time()
				end
			end

			return true
		end

		_laserIsUpper = function(arg)
			if not arg then
				return false
			end
			local parent = arg

			while parent and not parent:IsA("BasePart") do
				parent = parent.Parent
			end

			if parent and parent:IsA("BasePart") then
				return parent.Position.Y > 10
			end

			if arg:IsA("Model") then
				local ok, result = pcall(function()
					return arg:GetPivot()
				end)

				if ok and result then
					return result.Position.Y > 10
				end
			end

			for i, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("BasePart") then
					return descendant.Position.Y > 10
				end
			end

			return false
		end

		function _laserActive(arg)
			if not arg then
				return false
			end

			local ok, result = pcall(function()
				if arg.Name == "LaserHitbox" then
					return false
				end

				if arg:IsA("BasePart") then
					return arg.Transparency < 1 and arg.LocalTransparencyModifier < 1
				elseif arg:IsA("Beam") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
					return arg.Enabled ~= false
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					return arg.Transparency < 1
				elseif arg:IsA("GuiObject") then
					return arg.Visible ~= false
				end

				return false
			end)

			return ok and result == true
		end

		function _laserOnFloor(arg, arg2)
			local laser = arg:FindFirstChild("Laser")
			if not laser then
				return false
			end

			if laser:IsA("BasePart") and _laserIsUpper(laser) == arg2 and _laserActive(laser) then
				return true
			end

			for i, descendant in ipairs(laser:GetDescendants()) do
				if _laserIsUpper(descendant) == arg2 and _laserActive(descendant) then
					return true
				end
			end

			return false
		end

		function IsPlotFloorOpen(arg, arg2)
			if not arg then
				return false
			end

			local ok, result = pcall(function()
				local v11 = readPlotChannel(arg.Name)

				if v11 then
					local str = arg2 and "BlockEndTimeSecondFloor" or "BlockEndTimeFirstFloor"
					if isBlockTimeActive(readChannelProp(v11, str)) then
						return false
					end

					if isBlockTimeActive(readChannelProp(v11, "BlockEndTime")) then
						return false
					end

					if _laserOnFloor(arg, arg2) then
						return false
					end
					return true
				end

				return not _laserOnFloor(arg, arg2)
			end)

			return ok and result == true
		end

		function IsPlotBaseOpen(arg)
			return IsPlotFloorOpen(arg, false) and IsPlotFloorOpen(arg, true)
		end

		function SaveLaserOriginal(arg)
			if laserOriginalState[arg] then
				return
			end

			pcall(function()
				if arg:IsA("BasePart") then
					local transparency = arg.Transparency
					local localTransparencyModifier = arg.LocalTransparencyModifier

					if transparency >= 1 and localTransparencyModifier >= 1 then
						transparency, localTransparencyModifier = 0, 0
					end

					laserOriginalState[arg] = { trans = transparency, localTrans = localTransparencyModifier, shadow = arg.CastShadow }
				elseif arg:IsA("Beam") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
					laserOriginalState[arg] = { enabled = arg.Enabled ~= false }
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					local transparency = arg.Transparency

					if transparency >= 1 then
						transparency = 0
					end

					laserOriginalState[arg] = { trans = transparency }
				elseif arg:IsA("GuiObject") then
					laserOriginalState[arg] = { visible = arg.Visible ~= false }
				end
			end)
		end

		function HideLaserObject(arg)
			if not arg then
				return
			end

			pcall(function()
				if arg:IsA("BasePart") then
					arg.Transparency = 1
					arg.LocalTransparencyModifier = 1
					arg.CastShadow = false
				elseif arg:IsA("Beam") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
					arg.Enabled = false
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					arg.Transparency = 1
				elseif arg:IsA("GuiObject") then
					arg.Visible = false
				end
			end)
		end

		function RestoreLaserObject(arg)
			local v11 = laserOriginalState[arg]

			pcall(function()
				if arg:IsA("BasePart") then
					local trans = v11 and v11.trans or 0
					local localTrans = v11 and v11.localTrans or 0

					if trans >= 1 then
						trans = 0
					end

					if localTrans >= 1 then
						localTrans = 0
					end

					arg.Transparency = trans
					arg.LocalTransparencyModifier = localTrans
					arg.CastShadow = v11 and v11.shadow or true
				elseif arg:IsA("Beam") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
					arg.Enabled = v11 and v11.enabled or true
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					local trans = v11 and v11.trans or 0

					if trans >= 1 then
						trans = 0
					end

					arg.Transparency = trans
				elseif arg:IsA("GuiObject") then
					arg.Visible = v11 and v11.visible or true
				end
			end)
		end

		ForceLaserObject = function(arg)
			if not arg then
				return
			end

			if arg.Name == "LaserHitbox" then
				return
			end

			pcall(function()
				if arg:IsA("BasePart") then
					local tbl16 = {}
					arg.Transparency = 0
					arg.LocalTransparencyModifier = 0
					arg.CastShadow = true
				elseif arg:IsA("Beam") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
					arg.Enabled = true
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					arg.Transparency = 0
				elseif arg:IsA("GuiObject") then
					arg.Visible = true
				end
			end)
		end

		UpdateLaserObject = function(arg)
			if not IsLaserObject(arg) then
				return
			end
			local v11 = GetPlotFromObject(arg)

			if v11 and IsPlotFloorOpen(v11, _laserIsUpper(arg)) then
				SaveLaserOriginal(arg)
				HideLaserObject(arg)
			else
				ForceLaserObject(arg)
			end
		end

		RefreshPlotLasers = function(arg)
			if not arg then
				return
			end
			local laser = arg:FindFirstChild("Laser")
			if not laser then
				return
			end
			UpdateLaserObject(laser)

			for i, descendant in ipairs(laser:GetDescendants()) do
				UpdateLaserObject(descendant)
			end
		end

		BindLaserState = function(arg, arg2, arg3)
			UpdateLaserObject(arg)

			if arg:IsA("BasePart") then
				arg3[#arg3 + 1] = arg:GetPropertyChangedSignal("Transparency"):Connect(function()
					if not arg2 then
						return
					end

					if IsPlotFloorOpen(arg2, _laserIsUpper(arg)) and arg.Transparency < 1 then
						SaveLaserOriginal(arg)
						HideLaserObject(arg)
					elseif not IsPlotFloorOpen(arg2, _laserIsUpper(arg)) then
						ForceLaserObject(arg)
					end
				end)
			elseif arg:IsA("Beam") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
				arg3[#arg3 + 1] = arg:GetPropertyChangedSignal("Enabled"):Connect(function()
					if not arg2 then
						return
					end

					if IsPlotFloorOpen(arg2, _laserIsUpper(arg)) and arg.Enabled then
						SaveLaserOriginal(arg)
						HideLaserObject(arg)
					elseif not IsPlotFloorOpen(arg2, _laserIsUpper(arg)) and not arg.Enabled then
						ForceLaserObject(arg)
					end
				end)
			end
		end

		SetupPlotLaserMonitor = function(arg, arg2)
			if not arg then
				return
			end
			local laser = arg:FindFirstChild("Laser")
			if not laser then
				return
			end

			if _plotMonitorSetup[arg] then
				return
			end
			local tbl16 = {}
			_plotMonitorSetup[arg] = true
			_plotLaserOpenState[arg] = tostring(IsPlotFloorOpen(arg, false)) .. tostring(IsPlotFloorOpen(arg, true))
			RefreshPlotLasers(arg)
			BindLaserState(laser, arg, arg2)

			for i, descendant in ipairs(laser:GetDescendants()) do
				BindLaserState(descendant, arg, arg2)
			end

			arg2[#arg2 + 1] = laser.DescendantAdded:Connect(function(descendant)
				task.defer(function()
					BindLaserState(descendant, arg, arg2)
				end)
			end)

			arg2[#arg2 + 1] = arg.ChildRemoved:Connect(function(child)
				if child == laser then
					_plotMonitorSetup[arg] = nil
					_plotLaserOpenState[arg] = nil
				end
			end)

			local n11 = 0
			local connection_

			connection_ = RunService.Heartbeat:Connect(function()
				n11 = n11 + 1
				if n11 % 12 ~= 0 then
					return
				end

				if _plotMonitorSetup[arg] ~= true then
					if arg:FindFirstChild("Laser") then
						pcall(function()
							connection_:Disconnect()
						end)

						SetupPlotLaserMonitor(arg, arg2)
						return
					end

					return
				end

				local str = tostring(IsPlotFloorOpen(arg, false)) .. tostring(IsPlotFloorOpen(arg, true))

				if str ~= _plotLaserOpenState[arg] then
					_plotLaserOpenState[arg] = str
					RefreshPlotLasers(arg)
				end
			end)

			arg2[#arg2 + 1] = connection_
		end

		RefreshAllPlotLasers = function()
			local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
			if not plotsFolder then
				return
			end

			for i, child in ipairs(plotsFolder:GetChildren()) do
				RefreshPlotLasers(child)
			end
		end

		SetupPlotLaserWatch = function(arg, arg2)
			if not arg or _plotMonitorSetup[arg] then
				return
			end

			if arg:FindFirstChild("Laser") then
				SetupPlotLaserMonitor(arg, arg2)
				return
			end

			arg2[#arg2 + 1] = arg.ChildAdded:Connect(function(child)
				if child.Name == "Laser" then
					SetupPlotLaserMonitor(arg, arg2)
				end
			end)
		end

		SetupAllPlotLaserMonitor = function(arg)
			local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
			if not plotsFolder then
				return
			end

			for i, child in ipairs(plotsFolder:GetChildren()) do
				SetupPlotLaserWatch(child, arg)
			end

			if not _plotsFolderHooked then
				_plotsFolderHooked = true

				arg[#arg + 1] = plotsFolder.ChildAdded:Connect(function(child)
					task.wait(0.2)
					SetupPlotLaserWatch(child, arg)
				end)
			end
		end

		_globalLaserConnections = {}

		task.defer(function()
			local plots = Workspace:WaitForChild("Plots", 8)

			if plots then
				SetupAllPlotLaserMonitor(_globalLaserConnections)
			end
		end)

		_G.__laser = {
			IsLaserObject = IsLaserObject,
			UpdateLaserObject = UpdateLaserObject,
			SetupPlotLaserMonitor = SetupPlotLaserMonitor,
			SetupAllPlotLaserMonitor = SetupAllPlotLaserMonitor,
			RefreshPlotLasers = RefreshPlotLasers,
			RefreshAllPlotLasers = RefreshAllPlotLasers,
			GetPlotFromObject = GetPlotFromObject,
			IsPlotBaseOpen = IsPlotBaseOpen,
			IsPlotFloorOpen = IsPlotFloorOpen,
			LaserIsUpper = _laserIsUpper,
			LaserActive = _laserActive,
			LaserOnFloor = _laserOnFloor,
			SaveLaserOriginal = SaveLaserOriginal,
			HideLaserObject = HideLaserObject,
			RestoreLaserObject = RestoreLaserObject,
			ForceLaserObject = ForceLaserObject,
			ForcePlotLaserState = RefreshPlotLasers,
		}
	end)()

	function IsProtected(arg)
		if not arg then
			return false
		end
		local name = arg.Name
		if name:find("DO_NOT_REMOVE") or name:find("ForgeTextureCache") or name == "ChargeSoundPart" or name == "BJK_ProxAPRing" or name == "BJKVizPath" then
			return true
		end
		name = name:lower()
		if name:find("door") or name:find("gate") or name:find("shield") or name:find("barrier") or name:find("fence") or name:find("forcefield") or name:find("wall") or name:find("protect") or name:find("tutorial") then
			return true
		end
		local parent = arg.Parent

		while parent and parent ~= Workspace do
			local name2 = parent.Name
			if name2 == "CraftingMachine" or name2:find("Forge") or name2:find("Crafting") then
				return true
			end
			name2 = name2:lower()
			if name2:find("door") or name2:find("gate") or name2:find("shield") or name2:find("barrier") or name2:find("fence") or name2:find("forcefield") or name2:find("wall") or name2:find("protect") or name2:find("tutorial") then
				return true
			end
			parent = parent.Parent
		end

		return false
	end

	fpsBoostConnection = nil

	function _BJK_IsTracerBeam(arg)
		if not arg then
			return false
		end
		local name = arg.Name
		return name == "BestPetBeam" or name == "PlotBeam"
	end

	function setFPSBoost(arg)
		mainConfig.FPSBoost = false
		saveConfig()
		pcall(setToggle, "FPS Boost (normal)", false)

		do
			return
		end

		setToggle("FPS Boost (normal)", arg)

		if fpsBoostConnection then
			pcall(function()
				fpsBoostConnection:Disconnect()
			end)

			fpsBoostConnection = nil
		end

		if arg then
			Lighting.GlobalShadows = false
			local tbl14 = {}
			Lighting.Brightness = 2
			Lighting.FogEnd = 9000000000
			Lighting.FogStart = 0
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0

			for k, child in pairs(Lighting:GetChildren()) do
				if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect") or child:IsA("DepthOfFieldEffect") then
					pcall(function()
						child.Enabled = false
					end)
				elseif child:IsA("Atmosphere") then
					pcall(function()
						child:Destroy()
					end)
				end
			end

			for i, descendant in ipairs(Workspace:GetDescendants()) do
				if not IsProtected(descendant) then
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
						if not _BJK_IsTracerBeam(descendant) then
							pcall(function()
								descendant.Enabled = false
							end)
						end
					end

					if descendant:IsA("BasePart") then
						pcall(function()
							descendant.Material = Enum.Material.Plastic
							descendant.CastShadow = false
						end)
					end

					if descendant:IsA("SurfaceAppearance") or descendant:IsA("Texture") or descendant:IsA("Decal") then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end

			task.spawn(function()
				pcall(function()
					if StopConveyorAndBaseAnimations then
						StopConveyorAndBaseAnimations()
					end
				end)

				local tbl15 = {}
				local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")
				local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")

				if renderedMovingAnimals then
					tbl15[#tbl15 + 1] = renderedMovingAnimals
				end

				if plotsFolder then
					tbl15[#tbl15 + 1] = plotsFolder
				end

				for i, v11 in ipairs(tbl15) do
					for i2, descendant in ipairs(v11:GetDescendants()) do
						if IsLaserObject and IsLaserObject(descendant) then
							continue
						end

						pcall(function()
							if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") or descendant:IsA("Explosion") then
								descendant:Destroy()
							end
						end)
					end
				end
			end)

			fpsBoostConnection = Workspace.DescendantAdded:Connect(function(descendant)
				if not mainConfig.FPSBoost then
					return
				end

				if not IsProtected(descendant) then
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") then
						if not _BJK_IsTracerBeam(descendant) then
							pcall(function()
								descendant.Enabled = false
							end)
						end
					end

					if descendant:IsA("BasePart") then
						pcall(function()
							descendant.Material = Enum.Material.Plastic
							descendant.CastShadow = false
						end)
					end
				end

				task.defer(function()
					if not mainConfig.FPSBoost then
						return
					end

					pcall(function()
						if StopAnimationsOnAdded then
							StopAnimationsOnAdded(descendant)
						end
					end)

					if IsLaserObject and IsLaserObject(descendant) then
						return
					end

					if _isInsidePlayerChar and _isInsidePlayerChar(descendant) then
						return
					end
					local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")
					local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
					local v11 = renderedMovingAnimals and descendant:IsDescendantOf(renderedMovingAnimals) or plotsFolder and descendant:IsDescendantOf(plotsFolder)
					if not v11 then
						return
					end

					pcall(function()
						if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") or descendant:IsA("Explosion") then
							descendant:Destroy()
						end
					end)
				end)
			end)
		end
	end

	OriginalTransparency = setmetatable({}, { __mode = "k" })
	_ultraDescendantConn = nil
	_ultraLightingConn = nil
	_ultraMaterialConn = nil
	_ultraThreads = {}
	_ultraConnections = {}

	function AddUltraThread(arg)
		table.insert(_ultraThreads, task.spawn(arg))
	end

	function AddUltraConnection(arg)
		table.insert(_ultraConnections, arg)
	end

	SafeDestroyUltra = function(arg)
		if not arg then
			return
		end

		if IsLaserObject(arg) then
			return
		end

		if _BJK_IsTracerBeam(arg) then
			return
		end

		if arg.Name == "Overhead" then
			return
		end

		if arg.Name:find("DO_NOT_REMOVE") or arg.Name:find("ForgeTextureCache") then
			return
		end

		if IsProtected(arg) then
			return
		end

		pcall(function()
			arg:Destroy()
		end)
	end

	ClothingClasses = {
		"Shirt",
		"Pants",
		"ShirtGraphic",
		"Accessory",
		"Hat",
		"HairAccessory",
		"FaceAccessory",
		"NeckAccessory",
		"ShoulderAccessory",
		"FrontAccessory",
		"BackAccessory",
		"WaistAccessory",
	}

	IsClothing = function(arg)
		for i, v11 in ipairs(ClothingClasses) do
			if arg:IsA(v11) then
				return true
			end
		end
	end

	if mainConfig.AntiFlasher then
		_G.AntiFlasherEnabled = true
		_G._AntiFlasherConns = _G._AntiFlasherConns or {}
		pcall(AntiFlasherStripAll)

		for i, player_ in ipairs(Players2:GetPlayers()) do
			if not _G._AntiFlasherConns[player_.Name] then
				_G._AntiFlasherConns[player_.Name] = player_.CharacterAdded:Connect(function(character2)
					task.spawn(function()
						AntiFlasherOnCharacter(character2)
						task.wait(0.5)
						AntiFlasherStrip(character2)
					end)
				end)
			end

			task.spawn(function()
				if player_.Character then
					AntiFlasherOnCharacter(player_.Character)
					task.wait(0.5)
					AntiFlasherStrip(player_.Character)
				end
			end)
		end

		if not _G._AntiFlasherPlayerAdded then
			_G._AntiFlasherPlayerAdded = Players2.PlayerAdded:Connect(function(player_)
				if _G.AntiFlasherEnabled then
					if not _G._AntiFlasherConns[player_.Name] then
						_G._AntiFlasherConns[player_.Name] = player_.CharacterAdded:Connect(function(character2)
							task.spawn(function()
								local tbl14 = {}
								AntiFlasherOnCharacter(character2)
								task.wait(0.5)
								AntiFlasherStrip(character2)
							end)
						end)
					end

					if player_.Character then
						task.spawn(function()
							AntiFlasherOnCharacter(player_.Character)
							task.wait(0.5)
							AntiFlasherStrip(player_.Character)
						end)
					end
				end
			end)
		end
	end

	function IsCharacterPart(arg)
		local parent = arg.Parent

		while parent and parent ~= Workspace do
			if parent:IsA("Model") and Players2:GetPlayerFromCharacter(parent) then
				return true
			end
			parent = parent.Parent
		end

		return false
	end

	IsOutOfRange = function(arg)
		if arg:IsA("BasePart") then
			local x = arg.Position.X
			return x < -560 or x > -240
		end
	end

	BASE_NAMES = {
		baseplate = true,
		spawnlocation = true,
		["spawn location"] = true,
		spawn = true,
	}

	IsBase = function(arg)
		if not arg:IsA("BasePart") then
			return false
		end
		local str = arg.Name:lower()
		if BASE_NAMES[str] then
			return true
		end

		for k in pairs(BASE_NAMES) do
			if str:find(k, 1, true) then
				return true
			end
		end

		return false
	end

	IsInBase = function(arg)
		local parent = arg.Parent

		while parent and parent ~= workspace do
			if IsBase(parent) then
				return true
			end
			parent = parent.Parent
		end

		return false
	end

	MakeTransparentUltra = function(arg)
		pcall(function()
			if IsProtected(arg) then
				return
			end

			if IsBase(arg) and not IsCharacterPart(arg) then
				if OriginalTransparency[arg] == nil then
					OriginalTransparency[arg] = { trans = arg.Transparency, shadow = arg.CastShadow }
				end

				arg.Transparency = 1
				arg.CastShadow = false

				for i, descendant in ipairs(arg:GetDescendants()) do
					if IsProtected(descendant) then
						continue
					end

					if IsLaserObject(descendant) then
						continue
					end

					if _BJK_IsTracerBeam(descendant) then
						continue
					end

					if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") or descendant:IsA("Explosion") then
						pcall(function()
							descendant.Enabled = false
						end)

						SafeDestroyUltra(descendant)
					elseif descendant:IsA("SurfaceAppearance") or descendant:IsA("Decal") or descendant:IsA("Texture") then
						SafeDestroyUltra(descendant)
					elseif descendant:IsA("PointLight") or descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight") then
						SafeDestroyUltra(descendant)
					elseif descendant:IsA("SpecialMesh") then
						descendant.TextureId = ""
					elseif descendant:IsA("Animation") or descendant:IsA("AnimationController") then
						SafeDestroyUltra(descendant)
					elseif descendant:IsA("BasePart") and not IsCharacterPart(descendant) then
						descendant.CastShadow = false
						descendant.Material = Enum.Material.Plastic
						descendant.MaterialVariant = ""
						descendant.Reflectance = 0
					end
				end
			end
		end)
	end

	StripObjectUltra = function(arg)
		pcall(function()
			if IsLaserObject(arg) then
				return
			end

			if _BJK_IsTracerBeam(arg) then
				return
			end

			if IsProtected(arg) then
				return
			end

			if arg:IsA("Texture") or arg:IsA("Decal") or arg:IsA("SpecialMesh") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
				pcall(function()
					arg.Enabled = false
				end)

				SafeDestroyUltra(arg)
			elseif arg:IsA("SurfaceAppearance") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("BasePart") then
				arg.CastShadow = false
				arg.Material = Enum.Material.Plastic
				arg.MaterialVariant = ""
				arg.Reflectance = 0
			end
		end)
	end

	function CleanObjectUltra(arg)
		pcall(function()
			if IsLaserObject(arg) then
				return
			end

			if _BJK_IsTracerBeam(arg) then
				return
			end

			if IsProtected(arg) then
				return
			end

			if arg:IsA("SurfaceAppearance") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("Decal") or arg:IsA("Texture") then
				if not (arg.Name == "face" and arg.Parent and arg.Parent.Name == "Head") then
					SafeDestroyUltra(arg)
				end
			elseif arg:IsA("SpecialMesh") then
				arg.TextureId = ""
			elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") or arg:IsA("Explosion") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("Animation") or arg:IsA("AnimationController") then
				SafeDestroyUltra(arg)
			elseif arg:IsA("BasePart") then
				arg.CastShadow = false
				arg.Material = Enum.Material.Plastic
				arg.MaterialVariant = ""
				arg.Reflectance = 0
			end
		end)
	end

	function StopAnimationsUltra(arg)
		pcall(function()
			for i, v11 in ipairs(arg:GetPlayingAnimationTracks()) do
				local flag4 = false

				for i2, player_ in ipairs(Players2:GetPlayers()) do
					if player_.Character and arg:IsDescendantOf(player_.Character) then
						flag4 = true
						break
					end
				end

				if not flag4 then
					v11:Stop()
				end
			end
		end)
	end

	_BJK_UltraAnimHooked = setmetatable({}, { __mode = "k" })

	function _BJK_ResetUltraAnimHooks()
		_BJK_UltraAnimHooked = setmetatable({}, { __mode = "k" })
	end

	function _BJK_UltraNoAnim(arg)
		if not arg then
			return
		end

		pcall(function()
			if IsProtected(arg) then
				return
			end

			if arg:IsA("Animator") then
				if _isInsidePlayerChar and _isInsidePlayerChar(arg) then
					return
				end

				for i, v11 in ipairs(arg:GetPlayingAnimationTracks()) do
					v11:Stop(0)
				end

				if not _BJK_UltraAnimHooked[arg] then
					_BJK_UltraAnimHooked[arg] = true

					AddUltraConnection(arg.AnimationPlayed:Connect(function(arg2)
						pcall(function()
							arg2:Stop(0)
						end)
					end))
				end
			elseif arg:IsA("AnimationController") or arg:IsA("Animation") then
				SafeDestroyUltra(arg)
			else
				for i, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("Animator") or descendant:IsA("AnimationController") or descendant:IsA("Animation") then
						_BJK_UltraNoAnim(descendant)
					end
				end
			end
		end)
	end

	StopAnimationsOnInstance = function(arg)
		for i, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("Animation") or descendant:IsA("AnimationController") then
				descendant:Destroy()
			elseif descendant:IsA("Animator") then
				local playingAnimationTracks = descendant:GetPlayingAnimationTracks()

				for i2, playingAnimationTrack in ipairs(playingAnimationTracks) do
					playingAnimationTrack:Stop()
				end
			end
		end
	end

	_isInsidePlayerChar = function(arg)
		local parent = arg.Parent

		while parent and parent ~= Workspace do
			if Players2:GetPlayerFromCharacter(parent) then
				return true
			end
			parent = parent.Parent
		end

		return false
	end

	StopConveyorAndBaseAnimations = function()
		pcall(function()
			local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")

			if renderedMovingAnimals then
				for i, child in ipairs(renderedMovingAnimals:GetChildren()) do
					StopAnimationsOnInstance(child)
				end
			end

			local descendants = Workspace:GetDescendants()

			for i = 1, #descendants do
				local v11 = descendants[i]

				if v11:IsA("Animation") or v11:IsA("AnimationController") then
					if not _isInsidePlayerChar(v11) then
						v11:Destroy()
					end
				elseif v11:IsA("Animator") then
					if not _isInsidePlayerChar(v11) then
						local playingAnimationTracks = v11:GetPlayingAnimationTracks()

						for i2, playingAnimationTrack in ipairs(playingAnimationTracks) do
							playingAnimationTrack:Stop()
						end
					end
				end
			end
		end)
	end

	StopAnimationsOnAdded = function(arg)
		task.defer(function()
			pcall(function()
				if arg:IsA("Animation") or arg:IsA("AnimationController") then
					if not _isInsidePlayerChar(arg) then
						arg:Destroy()
					end
				elseif arg:IsA("Animator") then
					if not _isInsidePlayerChar(arg) then
						local playingAnimationTracks = arg:GetPlayingAnimationTracks()

						for i, playingAnimationTrack in ipairs(playingAnimationTracks) do
							playingAnimationTrack:Stop()
						end
					end
				elseif arg:IsA("Model") then
					local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
					local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")

					if plotsFolder and arg:IsDescendantOf(plotsFolder) or renderedMovingAnimals and arg:IsDescendantOf(renderedMovingAnimals) then
						StopAnimationsOnInstance(arg)
					end
				end
			end)
		end)
	end

	OptimizeCharacterUltra = function(arg)
		if not arg then
			return
		end

		task.spawn(function()
			task.wait(1)

			for i, descendant in ipairs(arg:GetDescendants()) do
				if IsClothing(descendant) then
					SafeDestroyUltra(descendant)
				else
					CleanObjectUltra(descendant)
				end
			end
		end)
	end

	ApplyGreySkyUltra = function()
		pcall(function()
			for i, child in ipairs(Lighting:GetChildren()) do
				if child:IsA("Sky") then
					child:Destroy()
				end
			end

			local sky = Instance.new("Sky")
			sky.SkyboxBk = ""
			local tbl14 = {}
			sky.SkyboxDn = ""
			sky.SkyboxFt = ""
			sky.SkyboxLf = ""
			sky.SkyboxRt = ""
			sky.SkyboxUp = ""
			sky.CelestialBodiesShown = false
			sky.StarCount = 0
			sky.Parent = Lighting
			Lighting.OutdoorAmbient = Color3.fromRGB(125, 125, 125)
			Lighting.ColorShift_Top = Color3.fromRGB(115, 115, 115)
			Lighting.ColorShift_Bottom = Color3.fromRGB(115, 115, 115)
			Lighting.FogColor = Color3.fromRGB(135, 135, 135)
			Lighting.ClockTime = 12
		end)
	end

	function OptimizeLightingUltra()
		local tbl14 = {}
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9000000000
		Lighting.FogStart = 9000000000
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.Brightness = 1.8
		Lighting.Ambient = Color3.fromRGB(105, 105, 105)

		for i, child in ipairs(Lighting:GetChildren()) do
			if child:IsA("PostEffect") and child.Name ~= "BJKDarkTheme" then
				pcall(function()
					child.Enabled = false
				end)
			elseif child:IsA("Atmosphere") or child:IsA("Clouds") then
				child:Destroy()
			end
		end

		ApplyGreySkyUltra()
	end

	function ApplyTerrainUltra()
		pcall(function()
			local terrain
			terrain = Workspace.Terrain
			terrain.Decoration = false
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 1
		end)
	end

	setFPSBoostUltra = function(arg)
		mainConfig.FPSBoostUltra = false
		saveConfig()
		pcall(setToggle, "FPS Boost Ultra", false)

		do
			return
		end

		setToggle("FPS Boost Ultra", arg)

		if arg then
			pcall(function()
				local tbl14 = {}
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
				settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
				settings().Physics.AllowSleep = true
				settings().Physics.PhysicsEnvironmentalThrottle = Enum.PhysicsEnvironmentalThrottle or Enum.EnviromentalPhysicsThrottle.Skip
			end)

			pcall(setfpscap, 999)
			OptimizeLightingUltra()
			ApplyTerrainUltra()
			local descendants = Workspace:GetDescendants()

			for i = 1, #descendants, 200 do
				local n10 = math.min(i + 200 - 1, #descendants)

				for i2 = i, n10 do
					local v11 = descendants[i2]

					if v11 and v11.Parent then
						if IsBase(v11) then
							MakeTransparentUltra(v11)
						elseif IsClothing(v11) then
							SafeDestroyUltra(v11)
						elseif IsInBase(v11) then
						elseif IsCharacterPart(v11) then
						elseif IsOutOfRange(v11) then
							SafeDestroyUltra(v11)
						else
							CleanObjectUltra(v11)
							StripObjectUltra(v11)
							_BJK_UltraNoAnim(v11)
						end
					end
				end

				if i + 200 <= #descendants then
					task.wait()
				end
			end

			AddUltraConnection(Workspace.DescendantAdded:Connect(function(descendant)
				task.defer(function()
					if not mainConfig.FPSBoostUltra then
						return
					end

					if IsLaserObject(descendant) then
						return
					end

					if IsBase(descendant) then
						MakeTransparentUltra(descendant)
						return
					end

					if IsClothing(descendant) then
						SafeDestroyUltra(descendant)
					elseif IsInBase(descendant) then
					elseif IsCharacterPart(descendant) then
					elseif IsOutOfRange(descendant) then
						SafeDestroyUltra(descendant)
					else
						CleanObjectUltra(descendant)
						StripObjectUltra(descendant)
						_BJK_UltraNoAnim(descendant)
					end
				end)
			end))

			AddUltraConnection(Lighting.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("PostEffect") then
					pcall(function()
						descendant.Enabled = false
					end)
				elseif descendant:IsA("Atmosphere") or descendant:IsA("Clouds") then
					SafeDestroyUltra(descendant)
				end
			end))

			local MaterialService = game:GetService("MaterialService")

			AddUltraConnection(MaterialService.DescendantAdded:Connect(function(descendant)
				SafeDestroyUltra(descendant)
			end))

			for i, player_ in ipairs(Players2:GetPlayers()) do
				OptimizeCharacterUltra(player_.Character)
				AddUltraConnection(player_.CharacterAdded:Connect(OptimizeCharacterUltra))
			end

			AddUltraConnection(Players2.PlayerAdded:Connect(function(player_)
				AddUltraConnection(player_.CharacterAdded:Connect(OptimizeCharacterUltra))
			end))

			AddUltraThread(function()
				while mainConfig.FPSBoostUltra do
					pcall(function()
						local tbl14 = {}
						local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")
						local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")

						if renderedMovingAnimals then
							tbl14[#tbl14 + 1] = renderedMovingAnimals
						end

						if plotsFolder then
							tbl14[#tbl14 + 1] = plotsFolder
						end

						for i, v11 in ipairs(tbl14) do
							for i2, descendant in ipairs(v11:GetDescendants()) do
								if descendant:IsA("Animator") or descendant:IsA("AnimationController") or descendant:IsA("Animation") then
									_BJK_UltraNoAnim(descendant)
								end
							end
						end
					end)

					task.wait(0.4)
				end
			end)

			task.defer(function()
				pcall(function()
					if RefreshAllPlotLasers then
						RefreshAllPlotLasers()
					end
				end)
			end)
		else
			for i, v11 in ipairs(_ultraConnections) do
				if typeof(v11) == "RBXScriptConnection" then
					v11:Disconnect()
				end
			end

			_ultraConnections = {}

			for i, v11 in ipairs(_ultraThreads) do
				pcall(function()
					task.cancel(v11)
				end)
			end

			_ultraThreads = {}

			pcall(function()
				if _BJK_ResetUltraAnimHooks then
					_BJK_ResetUltraAnimHooks()
				end
			end)

			pcall(function()
				for k, v11 in pairs(OriginalTransparency) do
					if k and k.Parent then
						k.Transparency = v11.trans
						k.CastShadow = v11.shadow
					end
				end
			end)

			OriginalTransparency = {}

			pcall(function()
				settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
				settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Automatic
				local tbl14 = {}
				Lighting.GlobalShadows = true
				Lighting.Brightness = 2
				Lighting.FogEnd = 100000
				Workspace.Terrain.WaterWaveSize = 0.15
				Workspace.Terrain.WaterWaveSpeed = 1
				Workspace.Terrain.WaterReflectance = 0.5
				Workspace.Terrain.WaterTransparency = 0.3
				Workspace.Terrain.Decoration = true
			end)
		end
	end

	_G.BJK_FpsOptimizer = mainConfig.FpsOptimizer ~= false
	_G.BJK_RemoveAnims = mainConfig.RemoveAnimations ~= false
	_G.BJK_OptimizeFloorSmooth = _G.BJK_FpsOptimizer and mainConfig.OptimizeFloorSmooth ~= false
	_G.BJK_OptimizeStripMeshTextures = _G.BJK_FpsOptimizer and mainConfig.OptimizeStripMeshTextures == true

	do
		local tbl14 = {
			"Shirt",
			"Pants",
			"ShirtGraphic",
			"Accessory",
			"Hat",
			"HairAccessory",
			"FaceAccessory",
			"NeckAccessory",
			"ShoulderAccessory",
			"FrontAccessory",
			"BackAccessory",
			"WaistAccessory",
		}

		local function fn26(arg)
			local localPlayer3 = Players2.LocalPlayer
			if not localPlayer3 or not arg then
				return false
			end

			local ok, result = pcall(function()
				return Players2:GetPlayerFromCharacter(arg)
			end)

			return ok and result ~= nil and result ~= localPlayer3
		end

		local function fn27(arg, arg2)
			if _G.BJK_FpsOptimizer == false then
				return
			end

			pcall(function()
				if arg.Name == "Overhead" then
					return
				end

				for i, v11 in ipairs(tbl14) do
					if arg:IsA(v11) then
						arg:Destroy()
						return
					end
				end

				if arg2 and arg:IsA("BasePart") and arg.Name ~= "HumanoidRootPart" then
					local size = arg.Size

					if size.X > 10 or size.Y > 10 or size.Z > 10 then
						arg.Transparency = 1
						arg.CanCollide = false

						pcall(function()
							arg.CanQuery = false
						end)

						pcall(function()
							arg.CanTouch = false
						end)

						arg.CastShadow = false
					end
				end
			end)
		end

		local function fn28()
			if _G.BJK_FpsOptimizer == false then
				return
			end

			pcall(function()
				local tbl15 = {}
				Lighting.GlobalShadows = false
				Lighting.FogEnd = 9000000000
				Lighting.FogStart = 9000000000
				Lighting.EnvironmentDiffuseScale = 0
				Lighting.EnvironmentSpecularScale = 0
				Lighting.Brightness = 1.5
				Lighting.Ambient = Color3.fromRGB(60, 60, 60)

				for i, child in ipairs(Lighting:GetChildren()) do
					if child:IsA("Sky") then
						pcall(function()
							child:Destroy()
						end)
					end
				end

				pcall(function()
					local sky = Instance.new("Sky")
					sky.SkyboxBk = ""
					sky.SkyboxDn = ""
					sky.SkyboxFt = ""
					local tbl16 = {}
					sky.SkyboxLf = ""
					sky.SkyboxRt = ""
					sky.SkyboxUp = ""
					sky.CelestialBodiesShown = false
					sky.Parent = Lighting
				end)

				for i, child in ipairs(Lighting:GetChildren()) do
					if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect") or child:IsA("DepthOfFieldEffect") then
						pcall(function()
							child.Enabled = false
						end)
					elseif child:IsA("Atmosphere") or child:IsA("Clouds") then
						pcall(function()
							child:Destroy()
						end)
					elseif child:IsA("Sky") then
						pcall(function()
							child.SkyboxBk = ""
							child.SkyboxDn = ""
							child.SkyboxFt = ""
							child.SkyboxLf = ""
							child.SkyboxRt = ""
							child.SkyboxUp = ""
							child.CelestialBodiesShown = false
						end)
					end
				end
			end)
		end

		local function fn29()
			if _G.BJK_FpsOptimizer == false then
				return
			end

			pcall(function()
				Workspace.Terrain.Decoration = false
				Workspace.Terrain.WaterWaveSize = 0
				Workspace.Terrain.WaterWaveSpeed = 0
				Workspace.Terrain.WaterReflectance = 0
				Workspace.Terrain.WaterTransparency = 1
			end)

			if _G.BJK_OptimizeFloorSmooth == false then
				return
			end

			pcall(function()
				local MaterialService = game:GetService("MaterialService")

				for i, v11 in ipairs(Enum.Material:GetEnumItems()) do
					pcall(function()
						if MaterialService:GetBaseMaterialOverride(v11) ~= "" then
							MaterialService:SetBaseMaterialOverride(v11, "")
						end
					end)
				end

				for i, descendant in ipairs(MaterialService:GetDescendants()) do
					if descendant:IsA("MaterialVariant") then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end)
		end

		local function fn30(arg)
			local parent = arg

			while parent and parent ~= Workspace do
				if parent:IsA("Model") then
					local ok, result = pcall(function()
						return Players2:GetPlayerFromCharacter(parent)
					end)

					if ok and result then
						return true
					end
				end

				parent = parent.Parent
			end

			return false
		end

		local function fn31(arg)
			if _G.BJK_FpsOptimizer == false then
				return
			end

			if fn30(arg) then
				return
			end
			local flag4 = false

			pcall(function()
				if IsProtected then
					flag4 = IsProtected(arg)
				end
			end)

			if flag4 then
				return
			end

			pcall(function()
				if _BJK_IsTracerBeam and _BJK_IsTracerBeam(arg) then
					flag4 = true
				end
			end)

			if flag4 then
				return
			end

			if arg.Name == "Overhead" then
				return
			end

			pcall(function()
				if arg:IsA("SurfaceAppearance") then
					arg:Destroy()
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					if not (arg.Name == "face" and arg.Parent and arg.Parent.Name == "Head") then
						arg:Destroy()
					end
				elseif arg:IsA("SpecialMesh") then
					arg.TextureId = ""
				elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") or arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") or arg:IsA("Explosion") then
					arg:Destroy()
				elseif arg:IsA("BasePart") then
					arg.CastShadow = false
					local tbl15 = {}
					arg.Material = Enum.Material.Plastic

					pcall(function()
						arg.MaterialVariant = ""
					end)

					arg.Reflectance = 0

					if _G.BJK_OptimizeStripMeshTextures and arg:IsA("MeshPart") then
						arg.TextureID = ""
					end
				end
			end)
		end

		local obj3 = setmetatable({}, { __mode = "k" })

		local function fn32(arg)
			local parent = arg and arg.Parent

			while parent and parent ~= Workspace do
				local ok, result = pcall(function()
					return Players2:GetPlayerFromCharacter(parent)
				end)

				if ok and result then
					return true
				end
				parent = parent.Parent
			end

			return false
		end

		local function fn33(arg)
			if not arg then
				return
			end

			if _G.BJK_FpsOptimizer == false or _G.BJK_RemoveAnims == false then
				return
			end

			pcall(function()
				local flag4 = false

				pcall(function()
					if IsProtected then
						flag4 = IsProtected(arg)
					end
				end)

				if flag4 then
					return
				end

				if arg:IsA("Animator") then
					if fn32(arg) then
						return
					end

					for i, v11 in ipairs(arg:GetPlayingAnimationTracks()) do
						pcall(function()
							v11:Stop(0)
						end)
					end

					if not obj3[arg] then
						obj3[arg] = true

						arg.AnimationPlayed:Connect(function(arg2)
							pcall(function()
								arg2:Stop(0)
							end)
						end)
					end
				elseif arg:IsA("AnimationController") or arg:IsA("Animation") then
					if fn32(arg) then
						return
					end
					arg:Destroy()
				else
					for i, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("Animator") or descendant:IsA("AnimationController") or descendant:IsA("Animation") then
							fn33(descendant)
						end
					end
				end
			end)
		end

		local function fn34()
			if _G.BJK_FpsOptimizer == false or _G.BJK_RemoveAnims == false then
				return
			end

			pcall(function()
				local tbl15 = {}
				local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")
				local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")

				if renderedMovingAnimals then
					tbl15[#tbl15 + 1] = renderedMovingAnimals
				end

				if plotsFolder then
					tbl15[#tbl15 + 1] = plotsFolder
				end

				for i, v11 in ipairs(tbl15) do
					for i2, child in ipairs(v11:GetChildren()) do
						fn33(child)
					end
				end
			end)
		end

		_G.BJK_SetFpsOptimizer = function(fpsOptimizer)
			mainConfig.FpsOptimizer = fpsOptimizer
			_G.BJK_FpsOptimizer = fpsOptimizer
			_G.BJK_OptimizeFloorSmooth = fpsOptimizer and mainConfig.OptimizeFloorSmooth ~= false
			_G.BJK_OptimizeStripMeshTextures = fpsOptimizer and mainConfig.OptimizeStripMeshTextures == true
			saveConfig()

			if fpsOptimizer then
				task.spawn(function()
					pcall(function()
						settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
						settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
						settings().Physics.AllowSleep = true
					end)

					pcall(fn28)
					pcall(fn29)

					pcall(function()
						for i, descendant in ipairs(Workspace:GetDescendants()) do
							fn31(descendant)
						end
					end)

					pcall(fn34)
				end)
			end
		end

		_G.BJK_SetRemoveAnims = function(removeAnimations)
			mainConfig.RemoveAnimations = removeAnimations
			_G.BJK_RemoveAnims = removeAnimations
			saveConfig()

			if removeAnimations then
				task.spawn(function()
					pcall(function()
						local localPlayer3 = Players2.LocalPlayer

						for i, player_ in ipairs(Players2:GetPlayers()) do
							if player_.Character and player_ ~= localPlayer3 then
								pcall(function()
									for i2, descendant in ipairs(player_.Character:GetDescendants()) do
										if descendant:IsA("Animator") then
											for i3, v11 in ipairs(descendant:GetPlayingAnimationTracks()) do
												pcall(function()
													v11:Stop()
												end)
											end
										end
									end
								end)
							end
						end
					end)

					pcall(fn34)
				end)
			end
		end

		local function fn35(character2)
			if not character2 then
				return
			end
			local v11 = fn26(character2)

			task.spawn(function()
				pcall(function()
					for i, descendant in ipairs(character2:GetDescendants()) do
						fn27(descendant, v11)
					end
				end)
			end)

			character2.DescendantAdded:Connect(function(descendant)
				task.defer(function()
					fn27(descendant, v11)
				end)
			end)
		end

		local function fn36(player_)
			if player_.Character then
				fn35(player_.Character)
			end

			player_.CharacterAdded:Connect(fn35)
		end

		for i, player_ in ipairs(Players2:GetPlayers()) do
			pcall(fn36, player_)
		end

		Players2.PlayerAdded:Connect(fn36)

		task.spawn(function()
			pcall(function()
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
				settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
				settings().Physics.AllowSleep = true
			end)

			pcall(fn28)
			pcall(fn29)

			pcall(function()
				for i, descendant in ipairs(Workspace:GetDescendants()) do
					fn31(descendant)
				end
			end)

			pcall(fn34)
		end)

		Workspace.DescendantAdded:Connect(function(descendant)
			task.defer(function()
				fn31(descendant)
			end)
		end)

		Workspace.DescendantAdded:Connect(function(descendant)
			task.defer(function()
				if descendant:IsA("Animator") or descendant:IsA("AnimationController") or descendant:IsA("Animation") then
					fn33(descendant)
				elseif descendant:IsA("Model") then
					local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
					local renderedMovingAnimals = Workspace:FindFirstChild("RenderedMovingAnimals")

					if plotsFolder and descendant:IsDescendantOf(plotsFolder) or renderedMovingAnimals and descendant:IsDescendantOf(renderedMovingAnimals) then
						fn33(descendant)
					end
				end
			end)
		end)

		task.spawn(function()
			while true do
				task.wait(10)
				pcall(fn34)
			end
		end)

		pcall(function()
			Lighting.DescendantAdded:Connect(function(descendant)
				if _G.BJK_FpsOptimizer == false then
					return
				end

				if descendant:IsA("PostEffect") then
					pcall(function()
						descendant.Enabled = false
					end)
				elseif descendant:IsA("Atmosphere") or descendant:IsA("Clouds") then
					pcall(function()
						descendant:Destroy()
					end)
				end
			end)
		end)

		pcall(function()
			game:GetService("MaterialService").DescendantAdded:Connect(function(descendant)
				if _G.BJK_FpsOptimizer == false then
					return
				end

				pcall(function()
					descendant:Destroy()
				end)
			end)
		end)

		task.spawn(function()
			while true do
				task.wait(15)

				pcall(function()
					local count = collectgarbage("count")

					if count and count > (_G.BJK_GcFullThresholdKb or 600000) then
						collectgarbage("collect")
					else
						for i = 1, 6 do
							collectgarbage("step", 0)
						end
					end
				end)
			end
		end)
	end

	xrayOriginalTransparencies = setmetatable({}, { __mode = "k" })
	xrayConnections = {}
	xrayLoopId = 0

	function setXRayTargetTransparency(arg, arg2, arg3)
		if not arg then
			return
		end

		if arg3 and arg3 ~= xrayLoopId then
			return
		end

		local function fn26(arg4)
			if _G.__laser.IsLaserObject(arg4) then
				local v11 = _G.__laser.GetPlotFromObject(arg4)

				if v11 and _G.__laser.IsPlotFloorOpen(v11, _G.__laser.LaserIsUpper(arg4)) then
					_G.__laser.SaveLaserOriginal(arg4)
					_G.__laser.HideLaserObject(arg4)
				else
					_G.__laser.ForceLaserObject(arg4)
				end

				return
			end

			if arg4:IsA("BasePart") then
				if xrayOriginalTransparencies[arg4] == nil then
					if arg4.Transparency == arg2 then
						xrayOriginalTransparencies[arg4] = 0
					else
						xrayOriginalTransparencies[arg4] = arg4.Transparency
					end
				end

				local v11 = xrayOriginalTransparencies[arg4]

				if v11 < 1 then
					local transparency = v11 + (1 - v11) * arg2

					if math.abs(arg4.Transparency - transparency) > 0.01 then
						arg4.Transparency = transparency
					end
				end
			elseif arg4:IsA("TextLabel") or arg4:IsA("TextButton") then
				local tbl14 = xrayOriginalTransparencies[arg4]

				if type(tbl14) ~= "table" then
					local textTransparency, backgroundTransparency = arg4.TextTransparency, arg4.BackgroundTransparency

					if textTransparency == arg2 then
						textTransparency = 0
					end

					if backgroundTransparency == arg2 then
						backgroundTransparency = 0
					end

					tbl14 = { text = textTransparency, bg = backgroundTransparency }
					xrayOriginalTransparencies[arg4] = tbl14
				end

				if tbl14.text < 1 then
					local textTransparency = tbl14.text + (1 - tbl14.text) * arg2

					if math.abs(arg4.TextTransparency - textTransparency) > 0.01 then
						arg4.TextTransparency = textTransparency
					end
				end

				if tbl14.bg < 1 then
					local backgroundTransparency = tbl14.bg + (1 - tbl14.bg) * arg2

					if math.abs(arg4.BackgroundTransparency - backgroundTransparency) > 0.01 then
						arg4.BackgroundTransparency = backgroundTransparency
					end
				end
			elseif arg4:IsA("Frame") or arg4:IsA("ScrollingFrame") then
				if xrayOriginalTransparencies[arg4] == nil then
					if arg4.BackgroundTransparency == arg2 then
						xrayOriginalTransparencies[arg4] = 0
					else
						xrayOriginalTransparencies[arg4] = arg4.BackgroundTransparency
					end
				end

				local n10 = xrayOriginalTransparencies[arg4]

				if type(n10) ~= "number" then
					n10 = 0
				end

				if n10 < 1 then
					local backgroundTransparency = n10 + (1 - n10) * arg2

					if math.abs(arg4.BackgroundTransparency - backgroundTransparency) > 0.01 then
						arg4.BackgroundTransparency = backgroundTransparency
					end
				end
			elseif arg4:IsA("ImageLabel") or arg4:IsA("ImageButton") then
				local tbl14 = xrayOriginalTransparencies[arg4]

				if type(tbl14) ~= "table" then
					local imageTransparency, backgroundTransparency = arg4.ImageTransparency, arg4.BackgroundTransparency

					if imageTransparency == arg2 then
						imageTransparency = 0
					end

					if backgroundTransparency == arg2 then
						backgroundTransparency = 0
					end

					tbl14 = { img = imageTransparency, bg = backgroundTransparency }
					xrayOriginalTransparencies[arg4] = tbl14
				end

				if tbl14.img < 1 then
					local imageTransparency = tbl14.img + (1 - tbl14.img) * arg2

					if math.abs(arg4.ImageTransparency - imageTransparency) > 0.01 then
						arg4.ImageTransparency = imageTransparency
					end
				end

				if tbl14.bg < 1 then
					local backgroundTransparency = tbl14.bg + (1 - tbl14.bg) * arg2

					if math.abs(arg4.BackgroundTransparency - backgroundTransparency) > 0.01 then
						arg4.BackgroundTransparency = backgroundTransparency
					end
				end
			end
		end

		fn26(arg)
		local descendants = arg:GetDescendants()

		for i, descendant in ipairs(descendants) do
			fn26(descendant)

			if i % 300 == 0 then
				task.wait()
				if arg3 and arg3 ~= xrayLoopId then
					return
				end
			end
		end
	end

	XRAY_FOLDERS = {
		"Base",
		"PlotSign",
		"FriendPanel",
		"Cash",
		"Decorations",
		"Skin",
		"Unlock",
		"Purchases",
	}

	function trackXRaySubtree(arg, arg2, arg3)
		if not arg then
			return
		end

		if arg3 ~= xrayLoopId then
			return
		end
		setXRayTargetTransparency(arg, arg2, arg3)
		if arg3 ~= xrayLoopId then
			return
		end

		xrayConnections[#xrayConnections + 1] = arg.DescendantAdded:Connect(function(descendant)
			if arg3 ~= xrayLoopId then
				return
			end
			setXRayTargetTransparency(descendant, arg2, arg3)
		end)
	end

	function processPlotXRay(arg, arg2, arg3)
		if not arg then
			return
		end

		if arg3 ~= xrayLoopId then
			return
		end

		for i, v11 in ipairs(XRAY_FOLDERS) do
			if arg3 ~= xrayLoopId then
				return
			end
			trackXRaySubtree(arg:FindFirstChild(v11), arg2, arg3)
		end

		if arg3 ~= xrayLoopId then
			return
		end

		if arg3 ~= xrayLoopId then
			return
		end

		xrayConnections[#xrayConnections + 1] = arg.ChildAdded:Connect(function(child)
			if arg3 ~= xrayLoopId then
				return
			end

			for i, v11 in ipairs(XRAY_FOLDERS) do
				if child.Name == v11 then
					trackXRaySubtree(child, arg2, arg3)
					break
				end
			end
		end)

		local animalPodiums = arg:FindFirstChild("AnimalPodiums")

		if animalPodiums then
			local function fn26(arg4)
				for i, child in ipairs(arg4:GetChildren()) do
					if child.Name == "Claim" then
						trackXRaySubtree(child, arg2, arg3)
					elseif child.Name == "Base" then
						trackXRaySubtree(child:FindFirstChild("Decorations"), arg2, arg3)
					elseif child:IsA("Model") and child.Name ~= "Decorations" then
						trackXRaySubtree(child, arg2, arg3)
					end
				end
			end

			for i, child in ipairs(animalPodiums:GetChildren()) do
				fn26(child)
			end

			xrayConnections[#xrayConnections + 1] = animalPodiums.ChildAdded:Connect(function(child)
				if arg3 ~= xrayLoopId then
					return
				end
				task.wait(0.1)
				if arg3 ~= xrayLoopId then
					return
				end
				fn26(child)
			end)
		end
	end

	function applyTransparencyToAllPlotsXRay(arg, arg2)
		local plotsFolder = _G.PlotsFolder or Workspace:FindFirstChild("Plots")
		if not plotsFolder then
			return
		end

		for i, child in ipairs(plotsFolder:GetChildren()) do
			if arg2 ~= xrayLoopId then
				return
			end
			processPlotXRay(child, arg, arg2)
			task.wait()
		end

		xrayConnections[#xrayConnections + 1] = plotsFolder.ChildAdded:Connect(function(child)
			if arg2 ~= xrayLoopId then
				return
			end
			task.wait(0.2)
			processPlotXRay(child, arg, arg2)
		end)
	end

	function setXRay(xRay)
		mainConfig.XRay = xRay
		saveConfig()
		setToggle("XRay", xRay)
		setToggle("X-Ray", xRay)
		setToggle("Xray", xRay)

		for i, v11 in ipairs(xrayConnections) do
			if typeof(v11) == "RBXScriptConnection" then
				v11:Disconnect()
			end
		end

		xrayConnections = {}
		xrayLoopId = xrayLoopId + 1

		if xRay then
			task.spawn(function()
				while xrayLoopId == xrayLoopId and not (_G.PlotsFolder or Workspace:FindFirstChild("Plots")) do
					task.wait(0.5)
				end

				if xrayLoopId ~= xrayLoopId then
					return
				end

				if xrayLoopId ~= xrayLoopId then
					return
				end
				pcall(applyTransparencyToAllPlotsXRay, 0.5, xrayLoopId)
			end)
		else
			xrayOriginalTransparencies = setmetatable({}, { __mode = "k" })

			for k, v11 in pairs(xrayOriginalTransparencies) do
				pcall(function()
					if k:IsA("BasePart") then
						if type(v11) == "number" then
							k.Transparency = v11
						end
					elseif k:IsA("TextLabel") or k:IsA("TextButton") then
						if type(v11) == "table" then
							k.TextTransparency = v11.text or 0
							k.BackgroundTransparency = v11.bg or 0
						end
					elseif k:IsA("Frame") or k:IsA("ScrollingFrame") then
						if type(v11) == "number" then
							k.BackgroundTransparency = v11
						end
					elseif k:IsA("ImageLabel") or k:IsA("ImageButton") then
						if type(v11) == "table" then
							k.ImageTransparency = v11.img or 0
							k.BackgroundTransparency = v11.bg or 0
						end
					end
				end)
			end

			for k, v11 in pairs(OriginalTransparency) do
				if k and k.Parent and typeof(v11) == "table" then
					pcall(function()
						k.Transparency = v11.trans
					end)
				end
			end

			if _G.__laser and _G.__laser.RefreshAllPlotLasers then
				pcall(_G.__laser.RefreshAllPlotLasers)
			end
		end
	end

	_G.setXRay = setXRay

	SharedState.ANTI_BEE_DISCO = {
		running = false,
		connections = {},
		originalMoveFunction = nil,
		controlsProtected = false,
		badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true },
		originalFOV = nil,
		cameraLockConn = nil,
	}

	SharedState.ANTI_BEE_DISCO.nuke = function(arg)
		if not arg or not arg.Parent then
			return
		end

		if SharedState.ANTI_BEE_DISCO.badLightingNames[arg.Name] then
			pcall(function()
				arg:Destroy()
			end)
		end
	end

	SharedState.ANTI_BEE_DISCO.disconnectAll = function()
		for i, connection_ in ipairs(SharedState.ANTI_BEE_DISCO.connections) do
			if typeof(connection_) == "RBXScriptConnection" then
				connection_:Disconnect()
			end
		end

		SharedState.ANTI_BEE_DISCO.connections = {}

		if SharedState.ANTI_BEE_DISCO.cameraLockConn then
			SharedState.ANTI_BEE_DISCO.cameraLockConn:Disconnect()
			SharedState.ANTI_BEE_DISCO.cameraLockConn = nil
		end
	end

	SharedState.ANTI_BEE_DISCO.protectControls = function()
		if SharedState.ANTI_BEE_DISCO.controlsProtected then
			return
		end

		pcall(function()
			local playerScripts = localPlayer2.PlayerScripts
			local playerModule = playerScripts:FindFirstChild("PlayerModule")
			if not playerModule then
				return
			end
			local controls = require(playerModule):GetControls()
			if not controls then
				return
			end

			if not SharedState.ANTI_BEE_DISCO.originalMoveFunction then
				SharedState.ANTI_BEE_DISCO.originalMoveFunction = controls.moveFunction
			end

			local function moveFunction(arg, arg2, arg3)
				if UIS.TouchEnabled then
					if SharedState.ANTI_BEE_DISCO.originalMoveFunction then
						SharedState.ANTI_BEE_DISCO.originalMoveFunction(arg, arg2, arg3)
					end

					return
				end

				local v11 = UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.Up) or UIS:IsKeyDown(Enum.KeyCode.Down) or UIS:IsKeyDown(Enum.KeyCode.Left) or UIS:IsKeyDown(Enum.KeyCode.Right)
				local vector4 = v11 and arg2 or Vector3.zero

				if SharedState.ANTI_BEE_DISCO.originalMoveFunction then
					SharedState.ANTI_BEE_DISCO.originalMoveFunction(arg, vector4, arg3)
				end
			end

			table.insert(SharedState.ANTI_BEE_DISCO.connections, RunService.Heartbeat:Connect(function()
				if not SharedState.ANTI_BEE_DISCO.running or not mainConfig.AntiBeeDisco then
					return
				end

				if _G._isTpMoving then
					return
				end

				if controls.moveFunction ~= moveFunction then
					controls.moveFunction = moveFunction
				end
			end))

			controls.moveFunction = moveFunction
			SharedState.ANTI_BEE_DISCO.controlsProtected = true
		end)
	end

	SharedState.ANTI_BEE_DISCO.restoreControls = function()
		if not SharedState.ANTI_BEE_DISCO.controlsProtected then
			return
		end

		pcall(function()
			local playerModule = localPlayer2.PlayerScripts:FindFirstChild("PlayerModule")
			if not playerModule then
				return
			end
			local controls = require(playerModule):GetControls()

			if controls and SharedState.ANTI_BEE_DISCO.originalMoveFunction then
				controls.moveFunction = SharedState.ANTI_BEE_DISCO.originalMoveFunction
				SharedState.ANTI_BEE_DISCO.controlsProtected = false
			end
		end)
	end

	SharedState.ANTI_BEE_DISCO.lockCamera = function()
		if SharedState.ANTI_BEE_DISCO.cameraLockConn then
			return
		end

		if not workspace.CurrentCamera then
			return
		end

		SharedState.ANTI_BEE_DISCO.cameraLockConn = RunService.RenderStepped:Connect(function()
			if not SharedState.ANTI_BEE_DISCO.running or not mainConfig.AntiBeeDisco then
				return
			end

			pcall(function()
				local fov = mainConfig.FOV or 70

				if workspace.CurrentCamera.FieldOfView ~= fov then
					workspace.CurrentCamera.FieldOfView = fov
				end
			end)
		end)

		table.insert(SharedState.ANTI_BEE_DISCO.connections, SharedState.ANTI_BEE_DISCO.cameraLockConn)
	end

	SharedState.ANTI_BEE_DISCO.restoreCamera = function()
		if SharedState.ANTI_BEE_DISCO.cameraLockConn then
			SharedState.ANTI_BEE_DISCO.cameraLockConn:Disconnect()
			SharedState.ANTI_BEE_DISCO.cameraLockConn = nil
		end

		if workspace.CurrentCamera then
			workspace.CurrentCamera.FieldOfView = mainConfig.FOV or 70
		end
	end

	SharedState.ANTI_BEE_DISCO.blockBuzzingSound = function()
		pcall(function()
			local bee = localPlayer2.PlayerScripts:FindFirstChild("Bee", true)

			if bee then
				local buzzing = bee:FindFirstChild("Buzzing")

				if buzzing and buzzing:IsA("Sound") then
					buzzing:Stop()
					buzzing.Volume = 0
				end
			end
		end)
	end

	SharedState.ANTI_BEE_DISCO.Enable = function()
		if SharedState.ANTI_BEE_DISCO.running then
			return
		end
		SharedState.ANTI_BEE_DISCO.running = true

		for i, descendant in ipairs(Lighting:GetDescendants()) do
			SharedState.ANTI_BEE_DISCO.nuke(descendant)
		end

		table.insert(SharedState.ANTI_BEE_DISCO.connections, Lighting.DescendantAdded:Connect(function(descendant)
			if not SharedState.ANTI_BEE_DISCO.running or not mainConfig.AntiBeeDisco then
				return
			end
			SharedState.ANTI_BEE_DISCO.nuke(descendant)
		end))

		SharedState.ANTI_BEE_DISCO.protectControls()
		SharedState.ANTI_BEE_DISCO.lockCamera()

		table.insert(SharedState.ANTI_BEE_DISCO.connections, RunService.Heartbeat:Connect(function()
			if not SharedState.ANTI_BEE_DISCO.running or not mainConfig.AntiBeeDisco then
				return
			end
			SharedState.ANTI_BEE_DISCO.blockBuzzingSound()
		end))

		ShowNotification("ANTIBEE & DISCO", "Enabled")
	end

	SharedState.ANTI_BEE_DISCO.Disable = function()
		if not SharedState.ANTI_BEE_DISCO.running then
			return
		end
		SharedState.ANTI_BEE_DISCO.running = false
		SharedState.ANTI_BEE_DISCO.restoreControls()
		SharedState.ANTI_BEE_DISCO.restoreCamera()
		SharedState.ANTI_BEE_DISCO.disconnectAll()
		ShowNotification("ANTI-BEE & DISCO", "Disabled")
	end

	_G.ANTI_BEE_DISCO = SharedState.ANTI_BEE_DISCO

	if mainConfig.AntiBeeDisco then
		task.delay(1, function()
			if SharedState.ANTI_BEE_DISCO.Enable then
				SharedState.ANTI_BEE_DISCO.Enable()
			end
		end)
	end

	do
		autoBuyActive = false
		autoBuyRing = nil
		local tbl14 = {}

		createAutoBuyRing = function()
			local bjkAutoBuyRing = Workspace:FindFirstChild("BJK_AutoBuyRing")

			if bjkAutoBuyRing then
				bjkAutoBuyRing:Destroy()
			end

			local part = Instance.new("Part")
			part.Name = "BJK_AutoBuyRing"
			local tbl15 = {}
			part.Shape = Enum.PartType.Cylinder
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.CastShadow = false
			part.Material = Enum.Material.Neon
			part.Transparency = 0.5
			part.Color = Color3.fromRGB(255, 255, 255)
			local autoBuyRange = mainConfig.AutoBuyRange or 17
			part.Size = Vector3.new(0.5, autoBuyRange * 2, autoBuyRange * 2)
			part.Parent = Workspace
			autoBuyRing = part
		end

		destroyAutoBuyRing = function()
			if autoBuyRing then
				autoBuyRing:Destroy()
				autoBuyRing = nil
			end

			local bjkAutoBuyRing = Workspace:FindFirstChild("BJK_AutoBuyRing")

			if bjkAutoBuyRing then
				bjkAutoBuyRing:Destroy()
			end
		end

		_abRingFrame = 0

		RunService.Heartbeat:Connect(function()
			if not autoBuyActive then
				return
			end
			_abRingFrame = _abRingFrame + 1
			if _abRingFrame < 3 then
				return
			end
			_abRingFrame = 0
			local character2 = localPlayer2.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart2 or not autoBuyRing then
				return
			end
			local autoBuyRange = mainConfig.AutoBuyRange or 17
			autoBuyRing.Size = Vector3.new(0.5, autoBuyRange * 2, autoBuyRange * 2)
			autoBuyRing.CFrame = humanoidRootPart2.CFrame * CFrame.Angles(0, 0, math.rad(90)) + Vector3.new(0, -2.5, 0)
		end)

		toggleAutoBuy = function(arg)
			if arg ~= nil then
				autoBuyActive = arg
			else
				autoBuyActive = not autoBuyActive
			end

			mainConfig.AutoBuyEnabled = autoBuyActive
			pcall(saveConfig)
			pcall(setToggle, "Auto Buy", autoBuyActive)

			if autoBuyActive then
				createAutoBuyRing()
			else
				destroyAutoBuyRing()
			end

			if _G.AutoBuyOnToggle then
				pcall(_G.AutoBuyOnToggle, autoBuyActive)
			end
		end

		RARITY_WORDS = {
			common = true,
			uncommon = true,
			rare = true,
			epic = true,
			legendary = true,
			secret = true,
			divine = true,
			rainbow = true,
			cursed = true,
			gold = true,
			diamond = true,
		}

		function getBrainrotName(arg)
			if not arg then
				return "Brainrot", ""
			end
			local str, str2 = "", ""

			for i, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("BillboardGui") then
					for i2, descendant2 in ipairs(descendant:GetDescendants()) do
						if descendant2:IsA("TextLabel") and descendant2.Text and descendant2.Text ~= "" then
							local match = descendant2.Text:match("^%s*(.-)%s*$")
							local str3 = match:lower()
							if RARITY_WORDS[str3] then
								continue
							end

							if match:match("^%$[%d%.]+[KkMmBb]?/s$") then
								if str2 == "" then
									str2 = match
								end

								continue
							end

							if match:match("^%$[%d%.]+[KkMmBb]?$") then
								continue
							end

							if match:match("^[%d%.]+[KkMmBb]?$") then
								continue
							end

							if str == "" and #match > 1 then
								str = match
							end
						end
					end
				end
			end

			if str == "" then
				pcall(function()
					local v11 = AnimalsData[arg.Name]

					if v11 and v11.DisplayName then
						str = v11.DisplayName
						local generation = AnimalsShared:GetGeneration(arg.Name, nil, nil, nil)
						local str3 = "$" .. NumberUtils:ToString(generation) .. "/s"
						str2 = str3
					end
				end)
			end

			if str == "" then
				str = arg.Name ~= "" and arg.Name or "Brainrot"
			end

			return str, str2
		end

		function scanConveyor()
			local tbl15 = {}

			for i, descendant in ipairs(Workspace:GetDescendants()) do
				if not (descendant:IsA("ProximityPrompt") and descendant.Enabled) then
					continue
				end
				local actionText = descendant.ActionText or ""
				if not (actionText == "Purchase" or actionText:lower():find("purchase") or actionText:lower():find("comprar")) then
					continue
				end
				local parent = descendant.Parent
				if not parent then
					continue
				end
				local parent2 = parent:IsA("Attachment") and parent.Parent or parent
				if not (parent2 and parent2:IsA("BasePart")) then
					continue
				end
				local v11, parent3 = nil, parent2

				for i2 = 1, 8 do
					if parent3 and parent3:IsA("Model") then
						v11 = parent3
						break
					end
					parent3 = parent3 and parent3.Parent
				end

				local v12, v13 = getBrainrotName(v11)

				table.insert(tbl15, {
					name = v12,
					gen = v13,
					prompt = descendant,
					part = parent2,
					model = v11,
					source = "ESTEIRA",
					uid = "esteira_" .. tostring(descendant),
				})
			end

			return tbl15
		end

		SharedState.ConveyorAnimals = {}

		function refreshConveyor()
			local ok, conveyorAnimals = pcall(scanConveyor)

			if ok and conveyorAnimals then
				SharedState.ConveyorAnimals = conveyorAnimals
			end
		end

		task.spawn(function()
			task.wait(3)
			refreshConveyor()
		end)

		_G.refreshConveyor = refreshConveyor
		purchaseRemote = nil

		function resolvePurchaseRemote()
			if purchaseRemote and purchaseRemote.Parent then
				return purchaseRemote
			end

			pcall(function()
				local tbl15 = {
					"RF/ShopService/BuyAnimal",
					"RF/AnimalShop/Purchase",
					"RE/Shop/Buy",
					"RF/Shop/Buy",
				}

				for i, v11 in ipairs(tbl15) do
					local ok, result = pcall(function()
						return Decrypted[v11]
					end)

					if ok and result and result.Parent then
						purchaseRemote = result
						return
					end
				end
			end)

			return purchaseRemote
		end

		firePurchaseSafe = function(arg)
			if not arg or not arg.Parent or not arg.Enabled then
				return false
			end

			if fireproximityprompt then
				local ok = pcall(function()
					fireproximityprompt(arg)
				end)

				if ok then
					return true
				end
			end

			local v11 = resolvePurchaseRemote()

			if v11 then
				pcall(function()
					if v11:IsA("RemoteFunction") then
						v11:InvokeServer(arg.Parent)
					elseif v11:IsA("RemoteEvent") then
						v11:FireServer(arg.Parent)
					end
				end)

				return true
			end

			return false
		end

		carpetLockConn = nil

		startCarpetLock = function()
			if carpetLockConn then
				carpetLockConn:Disconnect()
				carpetLockConn = nil
			end
		end

		stopCarpetLock = function()
			if carpetLockConn then
				carpetLockConn:Disconnect()
				carpetLockConn = nil
			end
		end

		HOVER_HEIGHT = 5
		BUY_INTERVAL = 0.08
		DETECT_RADIUS = 17
		lockedTarget = nil
		lockedPart = nil
		lockedModel = nil

		function partAlive()
			return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent
		end

		function promptAlive()
			return lockedTarget and lockedTarget.prompt and lockedTarget.prompt.Parent and lockedTarget.prompt.Enabled
		end

		bodyPos = nil

		function ensureBodyPos(arg)
			if bodyPos and bodyPos.Parent == arg then
				local n10 = math.clamp(mainConfig.AutoGrabSpeed or 17, 5, 100)
				bodyPos.P = n10 * 1000
				return bodyPos
			end

			if bodyPos then
				bodyPos:Destroy()
			end

			local n10, bodyPosition
			n10 = math.clamp(mainConfig.AutoGrabSpeed or 17, 5, 100)
			bodyPosition = Instance.new("BodyPosition", arg)
			bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyPosition.P = n10 * 1000
			bodyPosition.D = 1000
			bodyPosition.Position = arg.Position
			bodyPos = bodyPosition
			return bodyPosition
		end

		function destroyBodyPos()
			if bodyPos then
				bodyPos:Destroy()
				bodyPos = nil
			end
		end

		RunService.Heartbeat:Connect(function()
			if not autoBuyActive or not partAlive() then
				destroyBodyPos()
				return
			end
			local character2 = localPlayer2.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart2 then
				destroyBodyPos()
				return
			end
			local position = lockedPart.Position + Vector3.new(0, HOVER_HEIGHT, 0)
			local v11 = ensureBodyPos(humanoidRootPart2)
			v11.Position = position
		end)

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end
				task.wait()
				if not autoBuyActive then
					continue
				end

				if not partAlive() or not promptAlive() then
					continue
				end

				pcall(function()
					firePurchaseSafe(lockedTarget.prompt)
				end)
			end
		end)

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end
				task.wait(0.25)

				if not autoBuyActive then
					lockedTarget = nil
					lockedPart = nil
					lockedModel = nil
					stopCarpetLock()
					destroyBodyPos()
					continue
				end

				if lockedPart or lockedModel then
					if not partAlive() then
						pcall(refreshConveyor)
						lockedTarget = nil
						lockedPart = nil
						lockedModel = nil
					end

					continue
				end

				pcall(refreshConveyor)
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					continue
				end
				local autoBuyRange = mainConfig.AutoBuyRange or DETECT_RADIUS
				local v11, huge = nil, math.huge

				for i, conveyorAnimal in ipairs(SharedState.ConveyorAnimals) do
					if conveyorAnimal.prompt and conveyorAnimal.prompt.Parent and conveyorAnimal.prompt.Enabled and conveyorAnimal.part and conveyorAnimal.part.Parent then
						local magnitude = (humanoidRootPart2.Position - conveyorAnimal.part.Position).Magnitude

						if magnitude <= autoBuyRange and magnitude < huge then
							huge = magnitude
							v11 = conveyorAnimal
						end
					end
				end

				if v11 then
					lockedTarget = v11
					lockedPart = v11.part
					lockedModel = v11.model or v11.part.Parent
					startCarpetLock()
				end
			end
		end)

		_G.AutoBuyOnToggle = function(arg)
			if arg then
				if _G.refreshConveyor then
					pcall(_G.refreshConveyor)
				end

				pcall(function()
					local character2 = localPlayer2.Character
					local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")

					if humanoid2 then
						humanoid2:UnequipTools()
					end
				end)
			else
				stopCarpetLock()
				destroyBodyPos()
			end
		end

		do
			local fn26 = cloneref or function(arg)
				return arg
			end

			local v11 = fn26(game:GetService("Players"))
			local v12 = fn26(game:GetService("Workspace"))
			local v13 = localPlayer2
			local autoDestroyTurrets, tbl15, flag4, obj3, obj4, obj5, fn27
			autoDestroyTurrets = false
			tbl15 = {}
			flag4 = false
			obj3 = setmetatable({}, { __mode = "k" })
			obj4 = setmetatable({}, { __mode = "k" })
			obj5 = setmetatable({}, { __mode = "k" })
			local flag5 = false

			local function fn28(arg)
				if not arg or not arg:IsA("BasePart") then
					return false
				end
				local match = arg.Name:match("^Sentry_(%d+)$")
				return match ~= nil and match ~= tostring(v13.UserId)
			end

			local function fn29(arg)
				if not fn28(arg) then
					return
				end

				pcall(function()
					arg.CanCollide = false
				end)
			end

			local function fn30(arg)
				if not arg or not arg.Parent then
					return nil
				end
				local setupFrame = arg:FindFirstChild("SetupFrame")
				local mainFrame = setupFrame and setupFrame:FindFirstChild("MainFrame")
				local time = mainFrame and mainFrame:FindFirstChild("Time")
				if time and time:IsA("TextLabel") then
					return time
				end
				return nil
			end

			local function fn31(arg)
				if not v13 then
					return false
				end

				if v13:GetAttribute("Stealing") ~= nil then
					return false
				end

				if _G.invisibleStealEnabled or getToggle and getToggle("Invisible Steal") then
					return false
				end

				if not fn28(arg) then
					return false
				end
				fn29(arg)
				local v14 = fn30(arg)
				if not v14 then
					return false
				end
				local text = v14.Text
				text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
				return text ~= "" and string.find(text, "^%d+s!$") ~= nil
			end

			local function fn32(arg, arg2)
				if not arg or not arg2 then
					return
				end
				local lookVector = arg2.CFrame.LookVector
				local n10 = arg2.Position + lookVector * 4 + Vector3.new(0, 1.2, 0)
				local cframe2 = CFrame.lookAt(n10, n10 + lookVector)
				arg2.Velocity = Vector3.zero
				arg.RotVelocity = Vector3.zero

				pcall(function()
					arg.CFrame = cframe2
				end)
			end

			local function fn33(arg)
				local now = os.clock()
				if obj3[arg] or obj4[arg] or flag5 or not fn31(arg) then
					return
				end

				if (obj5[arg] or 0) > now then
					return
				end
				obj4[arg] = true
				obj5[arg] = now + 0.3

				task.spawn(function()
					obj4[arg] = nil
					if flag5 or obj3[arg] or not fn31(arg) then
						return
					end

					if _G._isTpMoving or _G._bjkCancelTP or _G.TpOnLoadRunning then
						local now2 = os.clock()

						while (_G._isTpMoving or _G._bjkCancelTP or _G.TpOnLoadRunning) and os.clock() - now2 < 15 do
							task.wait(0.2)
						end

						if not fn31(arg) then
							return
						end
					end

					flag5 = true
					obj3[arg] = true
					local flag6 = false

					pcall(function()
						flag6 = getToggle and getToggle("Carpet Speed") == true or mainConfig and (mainConfig["Carpet Speed"] == true or mainConfig.CarpetSpeed == true)
					end)

					if flag6 and setCarpetSpeed then
						pcall(setCarpetSpeed, false)
						pcall(setToggle, "Carpet Speed", false)
						task.wait(0.12)
					end

					local n10 = 0

					while n10 < 12 and autoDestroyTurrets do
						if not arg or not arg.Parent or not fn31(arg) then
							break
						end
						local character2 = v13.Character
						local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
						local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
						if not humanoidRootPart2 or not humanoid2 or humanoid2.Health <= 0 then
							break
						end

						local ok, result = pcall(function()
							return (arg.Position - humanoidRootPart2.Position).Magnitude
						end)

						if ok and result > 220 then
							break
						end
						fn29(arg)
						fn32(arg, humanoidRootPart2)
						if not arg or not arg.Parent or not fn31(arg) then
							break
						end
						local backpack = v13:FindFirstChild("Backpack")
						local bat = character2:FindFirstChild("Bat") or backpack and backpack:FindFirstChild("Bat")

						if bat and bat.Parent ~= character2 then
							pcall(function()
								humanoid2:EquipTool(bat)
							end)
						end

						bat = character2:FindFirstChild("Bat") or bat

						if bat then
							bat:Activate()
						end

						task.wait(0.03)

						if arg and arg.Parent and fn31(arg) then
							fn29(arg)
							fn32(arg, humanoidRootPart2)
						end

						n10 = n10 + 1
						task.wait(0.09)
					end

					if flag6 then
						task.wait(0.25)
						pcall(setCarpetSpeed, true)
						pcall(setToggle, "Carpet Speed", true)

						if mainConfig then
							mainConfig["Carpet Speed"] = true
							pcall(saveConfig)
						end
					end

					obj3[arg] = nil
					flag5 = false
				end)
			end

			local function fn34()
				for i, v14 in ipairs(tbl15) do
					v14:Disconnect()
				end

				tbl15 = {}
			end

			fn27 = function()
				fn34()

				table.insert(tbl15, v12.DescendantAdded:Connect(function(descendant)
					if fn28(descendant) then
						fn29(descendant)
					end

					if autoDestroyTurrets and fn31(descendant) then
						task.defer(fn33, descendant)
					end
				end))

				if not flag4 then
					flag4 = true

					task.spawn(function()
						while autoDestroyTurrets do
							task.wait(0.4)

							for i, child in ipairs(v12:GetChildren()) do
								if fn28(child) then
									fn29(child)
								end

								if autoDestroyTurrets and fn31(child) then
									fn33(child)
								end
							end
						end

						flag4 = false
					end)
				end
			end

			_G.SabcomSetAutoTurret = function(arg)
				autoDestroyTurrets = arg == true
				mainConfig.AutoDestroyTurrets = autoDestroyTurrets
				pcall(saveConfig)
				pcall(setToggle, "Auto Destroy Turrets", autoDestroyTurrets)

				if autoDestroyTurrets then
					fn27()
				else
					fn34()
				end
			end

			_G.BJK_SetAutoTurret = _G.SabcomSetAutoTurret

			if _G.SabcomAutoTurret == true or mainConfig.AutoDestroyTurrets == true then
				if _G.SabcomAfterTpLoad then
					_G.SabcomAfterTpLoad(function()
						if _G.SabcomAutoTurret == true or mainConfig.AutoDestroyTurrets == true then
							pcall(_G.SabcomSetAutoTurret, true)
						end
					end)
				else
					task.defer(function()
						pcall(_G.SabcomSetAutoTurret, true)
					end)
				end
			end
		end
	end

	function hasExclamation(arg)
		for i, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("BillboardGui") then
				for i2, descendant2 in ipairs(descendant:GetDescendants()) do
					if (descendant2:IsA("TextLabel") or descendant2:IsA("TextBox")) and tostring(descendant2.Text):find("!") then
						return true
					end
				end
			end
		end

		return false
	end

	do
		local tbl14, n10 = {}, 0
		local flag4 = false

		local function fn26(arg)
			local function fn27(arg2)
				if not arg2 then
					return nil
				end

				for i, child in ipairs(arg2:GetChildren()) do
					if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
						return child
					end
				end
			end

			return fn27(arg) or fn27(player:FindFirstChild("Backpack"))
		end

		local tbl15 = {}
		local autoDestroyTurrets = false

		task.spawn(function()
			while true do
				if _G.BJK_HubGen ~= bjkHubGen then
					break
				end
				task.wait(0.25)
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
				if not (humanoidRootPart2 and humanoid2 and humanoid2.Health > 0) then
					continue
				end
				local now = os.clock()

				if _G.invisibleStealEnabled then
					if not autoDestroyTurrets then
						autoDestroyTurrets = mainConfig.AutoDestroyTurrets
						mainConfig.AutoDestroyTurrets = false
					end
				elseif autoDestroyTurrets then
					mainConfig.AutoDestroyTurrets = autoDestroyTurrets
					autoDestroyTurrets = false
				end

				if now - n10 > 1 then
					n10 = now
					local tbl16 = {}

					for i, descendant in ipairs(Workspace:GetDescendants()) do
						if descendant.Name:match("^Sentry_") then
							tbl16[#tbl16 + 1] = descendant

							if not tbl15[descendant] then
								tbl15[descendant] = now
							end

							if mainConfig.AutoDestroyTurrets and not _G.invisibleStealEnabled then
								for i2, descendant2 in ipairs(descendant:GetDescendants()) do
									if descendant2:IsA("BasePart") then
										descendant2.CanCollide = false
									end
								end
							end
						end
					end

					for k in pairs(tbl15) do
						if not k.Parent then
							tbl15[k] = nil
						end
					end

					tbl14 = tbl16
				end

				if not mainConfig.AutoDestroyTurrets then
					continue
				end

				if _G.invisibleStealEnabled then
					continue
				end

				if not _G._isTpMoving and localPlayer2:GetAttribute("Stealing") ~= true then
					local v11, huge = nil, math.huge
					local v12, huge2 = nil, math.huge

					for i, v13 in ipairs(tbl14) do
						if v13.Parent then
							local v14 = tbl15[v13]
							if v14 and now - v14 < 4 then
								continue
							end
							local isBasePart = v13:IsA("BasePart") and v13 or v13:FindFirstChildWhichIsA("BasePart", true)

							if isBasePart then
								local magnitude = (humanoidRootPart2.Position - isBasePart.Position).Magnitude

								if hasExclamation(v13) then
									if magnitude < huge then
										huge = magnitude
										v11 = v13
									end
								else
									if magnitude < huge2 then
										huge2 = magnitude
										v12 = v13
									end
								end
							end
						end
					end

					if not v11 then
						v11 = v12
					end

					if v11 and not flag4 then
						flag4 = true

						task.spawn(function()
							pcall(function()
								for i, descendant in ipairs(v11:GetDescendants()) do
									if descendant:IsA("BasePart") then
										descendant.Transparency = 0.5
									end
								end

								local v13 = getEquippedTool(character2)
								local v14 = fn26(character2)

								if v14 then
									local now2 = os.clock()

									while v14.Parent ~= character2 and os.clock() - now2 < 1.5 and mainConfig.AutoDestroyTurrets and not _G.invisibleStealEnabled do
										pcall(function()
											humanoid2:EquipTool(v14)
										end)

										task.wait(0.08)
									end

									for i = 1, 20 do
										if not mainConfig.AutoDestroyTurrets or _G.invisibleStealEnabled then
											break
										end

										if not (v11 and v11.Parent) then
											break
										end
										local cFrame = humanoidRootPart2.CFrame * CFrame.new(0, 1.5, -4)

										if v11:IsA("Model") then
											v11:PivotTo(cFrame)
										elseif v11:IsA("BasePart") then
											v11.CFrame = cFrame
										end

										if v14.Parent ~= character2 then
											pcall(function()
												humanoid2:EquipTool(v14)
											end)
										end

										pcall(function()
											v14:Activate()
										end)

										task.wait(0.05)
									end

									if v13 and v13 ~= v14 and v13.Parent then
										pcall(function()
											humanoid2:EquipTool(v13)
										end)
									end
								end
							end)

							flag4 = false
						end)
					end
				end
			end
		end)
	end

	pcall(function()
		local BJK_RemoteSell = _G.BJKBuscaGui("BJK_RemoteSell")

		if BJK_RemoteSell then
			BJK_RemoteSell:Destroy()
		end
	end)

	_G.toggleRemoteSell = function() end
	main, mainBody, tabBar, sidebarNav, sidebarProfile, bottomBar, fpsText = nil, nil, nil, nil, nil, nil, nil
	panels, panelSetters, tabButtons = {}, {}, {}
	actionSettingsPanel, actionSettingsBody, tpSpeedSettingsPanel, tpSpeedSettingsBody = nil, nil, nil, nil
	BoundToggles = {}
	openToolDropdowns = {}
	stealProgressBarGui = nil

	_G.ShowStealProgressBar = function(arg, arg2)
		local hui = gethui and gethui() or game:GetService("CoreGui")

		if stealProgressBarGui then
			pcall(function()
				stealProgressBarGui:Destroy()
			end)
		end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "BJK_StealProgressBar"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = hui
		local n10, n11, frame, textLabel, frame2
		stealProgressBarGui = screenGui
		n10 = 270
		n11 = 50
		frame = Instance.new("Frame")
		frame.Size = UDim2.fromOffset(n10, n11)
		frame.Position = UDim2.new(0.5, -n10 / 2, 1, -190)
		frame.BackgroundColor3 = Theme.Background
		frame.BackgroundTransparency = UITransparency.Progress
		frame.BorderSizePixel = 0
		frame.Parent = registerScreenGui(screenGui)
		corner(frame, 12)
		addOutline(frame)
		textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(0.6, -14, 0, 16)
		textLabel.Position = UDim2.new(0, 14, 0, 8)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "\226\154\161 STEALING: " .. (arg or "Brainrot"):upper()
		textLabel.TextColor3 = Theme.Text
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 9.5
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Parent = frame
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Size = UDim2.new(0.4, -14, 0, 16)
		textLabel2.Position = UDim2.new(0.6, 0, 0, 8)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = "0%"
		textLabel2.TextColor3 = Theme.Text
		textLabel2.Font = Enum.Font.GothamBold
		textLabel2.TextSize = 10
		textLabel2.TextXAlignment = Enum.TextXAlignment.Right
		textLabel2.Parent = frame
		frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, -28, 0, 6)
		frame2.Position = UDim2.new(0, 14, 0, 30)
		frame2.BackgroundColor3 = Theme.SliderBg
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		corner(frame2, 3)
		stroke(frame2, Theme.Stroke, 1, 0.1)
		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(0, 0, 1, 0)
		frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame3.BorderSizePixel = 0
		frame3.Parent = frame2
		corner(frame3, 3)
		local uiGradient = Instance.new("UIGradient", frame3)

		uiGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 208)),
		})

		local n12 = tonumber(arg2) or 5

		if n12 <= 0.01 then
			n12 = 5
		end

		local now = os.clock()

		task.spawn(function()
			while screenGui and screenGui.Parent do
				local n13 = os.clock() - now
				local n14 = math.clamp(n13 / n12, 0, 1)
				local n15 = 1 - (1 - n14) ^ 3

				pcall(function()
					textLabel2.Text = math.floor(n15 * 100) .. "%"
					frame3.Size = UDim2.new(n15, 0, 1, 0)
				end)

				if n14 >= 1 then
					break
				end
				task.wait()
			end
		end)
	end

	_G.HideStealProgressBar = function()
		if stealProgressBarGui then
			stealProgressBarGui = nil

			pcall(function()
				local frame = stealProgressBarGui:FindFirstChildWhichIsA("Frame")

				if frame then
					tw(frame, { BackgroundTransparency = 1 }, 0.15)

					for i, descendant in ipairs(frame:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							tw(descendant, { TextTransparency = 1 }, 0.15)
						elseif descendant:IsA("Frame") then
							tw(descendant, { BackgroundTransparency = 1 }, 0.15)
						elseif descendant:IsA("UIStroke") then
							tw(descendant, { Transparency = 1 }, 0.15)
						end
					end

					task.wait(0.16)
				end

				stealProgressBarGui:Destroy()
			end)
		end
	end

	corner = function(parent, arg)
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, math.min(22, (arg or 0) * 2))
		uiCorner.Parent = parent
		return uiCorner
	end

	stroke = function(parent, color2, arg, arg2)
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = color2 or Theme.Stroke
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.9
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Parent = parent
		return uiStroke
	end

	tw = function(arg, arg2, arg3)
		TweenService:Create(arg, TweenInfo.new(arg3 or 0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), arg2):Play()
	end

	addOutline = function(parent)
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Name = "WhiteOutline"
		uiStroke.Color = Color3.new(1, 1, 1)
		uiStroke.Thickness = 1
		local tbl14 = {}
		uiStroke.Transparency = 0.72
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Parent = parent
		return uiStroke
	end

	clearBody = function(arg)
		for i, child in ipairs(arg:GetChildren()) do
			if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
				child:Destroy()
			end
		end
	end

	openAnim = function(parent)
		if not parent then
			return
		end
		local bjkScale = parent:FindFirstChild("BJKScale") or Instance.new("UIScale")
		bjkScale.Name = "BJKScale"
		bjkScale.Parent = parent
		local position = parent.Position
		local tbl14 = {}
		parent.Visible = true
		bjkScale.Scale = 0.92
		parent.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 18)
		tw(bjkScale, { Scale = 1 }, 0.2)
		tw(parent, { Position = position }, 0.2)
	end

	closeAnim = function(arg)
		if not arg then
			return
		end
		arg.Visible = false
	end

	function closeAllSecondaryPanels()
		if actionSettingsPanel and actionSettingsPanel.Visible then
			closeAnim(actionSettingsPanel)
		end

		if tpSpeedSettingsPanel and tpSpeedSettingsPanel.Visible then
			closeAnim(tpSpeedSettingsPanel)
		end

		for i, v11 in ipairs({ "AdminPanelCmds", "ClickToAPCmds", "SpamBaseOwnerCmds" }) do
			local v12 = gui_sg and gui_sg:FindFirstChild(v11)

			if v12 and v12.Visible then
				v12.Visible = false
			end
		end

		for i, v11 in ipairs(openToolDropdowns) do
			pcall(function()
				if v11 and v11.Parent then
					v11:Destroy()
				end
			end)
		end

		openToolDropdowns = {}
	end

	makeDraggable = function(arg, arg2, arg3, arg4)
		local flag4, v11, position, position2 = false, nil, nil, nil

		arg2.InputBegan:Connect(function(input)
			if not arg4 and UI.Locked then
				return
			end

			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not flag4 then
				flag4 = true
				v11 = input
				position = input.Position
				position2 = arg.Position
			end
		end)

		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				if flag4 and input == v11 then
					if arg3 then
						rememberPosition(arg3, arg)
					end

					flag4 = false
					v11 = nil
				end
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				if flag4 then
					if arg3 then
						rememberPosition(arg3, arg)
					end

					flag4 = false
					v11 = nil
				end
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if flag4 and (arg4 or not UI.Locked) and (input.UserInputType == Enum.UserInputType.MouseMovement or input == v11) then
				local n10 = input.Position - position
				local v12 = getGlobalScale()
				arg.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n10.X / v12, position2.Y.Scale, position2.Y.Offset + n10.Y / v12)
			end
		end)
	end

	makeResizable = function(parent, arg, arg2)
		local textButton, n10, flag4, v11, position, size
		textButton = Instance.new("TextButton")
		textButton.Name = "ResizeGrip"
		n10 = UIS.TouchEnabled and 28 or 16
		textButton.Size = UDim2.new(0, n10, 0, n10)
		textButton.Position = UDim2.new(1, -n10, 1, -n10)
		textButton.BackgroundTransparency = 1
		textButton.Text = "\226\151\162"
		textButton.TextColor3 = Theme.Dim or Color3.new(1, 1, 1)
		textButton.TextSize = 12
		textButton.ZIndex = 100
		textButton.Visible = not UI.Locked
		textButton.Parent = parent
		_G.__BJKGrips = _G.__BJKGrips or {}
		table.insert(_G.__BJKGrips, textButton)
		flag4, v11, position, size = false, nil, nil, nil

		textButton.InputBegan:Connect(function(input)
			if UI.Locked then
				return
			end

			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not flag4 then
				flag4 = true
				v11 = input
				position = input.Position
				size = parent.Size
			end
		end)

		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				if flag4 and input == v11 then
					flag4 = false
					v11 = nil

					if arg2 then
						if not mainConfig.sizes then
							mainConfig.sizes = {}
						end

						mainConfig.sizes[arg2] = { x = parent.Size.X.Offset, y = parent.Size.Y.Offset }
						saveConfig()
					end
				end
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				if flag4 then
					flag4 = false
					v11 = nil

					if arg2 then
						if not mainConfig.sizes then
							mainConfig.sizes = {}
						end

						mainConfig.sizes[arg2] = { x = parent.Size.X.Offset, y = parent.Size.Y.Offset }
						saveConfig()
					end
				end
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if flag4 and not UI.Locked and (input.UserInputType == Enum.UserInputType.MouseMovement or input == v11) then
				local n11, v12, n12, n13
				n11 = input.Position - position
				v12 = getGlobalScale()
				n12 = math.max(arg.X.Offset, size.X.Offset + n11.X / v12)
				n13 = math.max(arg.Y.Offset, size.Y.Offset + n11.Y / v12)
				parent.Size = UDim2.new(0, n12, 0, n13)
			end
		end)
	end

	function makeHeader(parent, arg, arg2)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 38)
		frame.BackgroundColor3 = Theme.SidebarBg or Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 0.25
		local frame2
		frame.BorderSizePixel = 0
		frame.Parent = parent
		corner(frame, 8)
		frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, 0, 0, 10)
		frame2.Position = UDim2.new(0, 0, 1, -10)
		frame2.BackgroundColor3 = parent.BackgroundColor3
		frame2.BackgroundTransparency = parent.BackgroundTransparency
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		local tbl14 = {}

		for match in string.gmatch(arg, "([^\n]+)") do
			table.insert(tbl14, match)
		end

		if arg2 then
			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, -50, 0, 24)
			textLabel.Position = UDim2.new(0, 13, 0, 7)
			textLabel.BackgroundTransparency = 1
			local tbl15 = {}
			textLabel.Text = tbl14[1] or "leaked at discord.gg/Z7vPrxecnJ"
			textLabel.TextColor3 = Theme.Text
			textLabel.Font = UIFont.Title
			textLabel.TextSize = 16
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.Parent = frame
		elseif tbl14[2] == "Invisible Steal" then
			local textLabel = Instance.new("TextLabel")
			local tbl15 = {}
			textLabel.Size = UDim2.new(1, -24, 0, 12)
			textLabel.Position = UDim2.new(0, 12, 0, 5)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = tbl14[1] or "leaked at discord.gg/Z7vPrxecnJ"
			textLabel.TextColor3 = Theme.Dim
			textLabel.Font = UIFont.Brand
			textLabel.TextSize = 8
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.Parent = frame
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.Size = UDim2.new(1, -24, 0, 16)
			textLabel2.Position = UDim2.new(0, 12, 0, 17)
			textLabel2.BackgroundTransparency = 1
			textLabel2.Text = tbl14[2]
			textLabel2.TextColor3 = Theme.Text
			textLabel2.Font = UIFont.Title
			textLabel2.TextSize = 12
			textLabel2.TextXAlignment = Enum.TextXAlignment.Left
			textLabel2.Parent = frame
		else
			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, -58, 0, 12)
			textLabel.Position = UDim2.new(0, 12, 0, 5)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = tbl14[1] or "leaked at discord.gg/Z7vPrxecnJ"
			textLabel.TextColor3 = Theme.Dim
			textLabel.Font = UIFont.Brand
			textLabel.TextSize = 8
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.Parent = frame
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.Size = UDim2.new(1, -58, 0, 16)
			textLabel2.Position = UDim2.new(0, 12, 0, 17)
			textLabel2.BackgroundTransparency = 1
			textLabel2.Text = tbl14[2] or ""
			textLabel2.TextColor3 = Theme.Text
			textLabel2.Font = UIFont.Title
			textLabel2.TextSize = 13
			textLabel2.TextXAlignment = Enum.TextXAlignment.Left
			textLabel2.Parent = frame
		end

		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(0, 26, 0, 2)
		frame3.Position = UDim2.new(0, 12, 1, -3)
		frame3.BackgroundColor3 = Theme.Accent or Color3.fromRGB(245, 245, 247)
		frame3.BackgroundTransparency = 0.35
		frame3.BorderSizePixel = 0
		frame3.Parent = frame
		makeDraggable(parent, frame, arg)
		return frame
	end

	makeMainPanel = function(arg, size, position)
		local frame = Instance.new("Frame")
		local tbl14, frame2, frame3, frame4, frame5, scrollingFrame, uiPadding, uiListLayout
		frame.Size = size
		frame.Position = position
		frame.BackgroundColor3 = Theme.MainBackground
		frame.BackgroundTransparency = UITransparency.MainPanel
		frame.BorderSizePixel = 0
		frame.ClipsDescendants = true
		frame.Parent = gui
		corner(frame, 14)
		addOutline(frame)
		local frame6 = Instance.new("Frame")
		frame6.Name = "DragHandle"
		frame6.Size = UDim2.new(1, 0, 0, 44)
		frame6.BackgroundColor3 = Theme.SidebarBg or Color3.fromRGB(0, 0, 0)
		frame6.BackgroundT