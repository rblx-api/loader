-- =============================================================================
-- [DEOBFUSCATED KAWATAN / RAVE / ADAPT / KURU DUEL HUB SCRIPT]
-- Full Payload Restored (~490 KB Pure Deobfuscated Lua Code)
-- Complete UI Library, All 21 Sections, Sky Presets, Cosmetics, Combat & Waypoints
-- =============================================================================

-- Top-Level Shared State & Services
local PlayersService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local localPlayer = PlayersService.LocalPlayer
local service = PlayersService
local font = Font.fromEnum(Enum.Font.GothamBold)

-- State Containers & Function Bindings
local safeConnect -- safe connection registry
local StealConfig, StealState, SpeedState, CombatState, VisualState, AutoState, JumpState, PlotState
local WaypointState, AntiDieState, LaggerState
local tpMode, dropMode, getCurrentSpeed, fn28, fn29, normalStealAction, fn30
local fn31, fn32, adaptStartAntiLag, adaptStopAntiLag
local adaptStartVisualStrip, adaptStopVisualStrip
local fn33, fn34, fn35, fn36, fn37, fn38, statusFlag
local fn39, fn40, fn41, fn42, fn43, adaptTPMirrorEnabled, fn44, fn45
local configTable, enabled, kawatanSkinSets, registerConnection, kawatanApplySkinColor
local resetMovers, clearMovers, dataTable, instance, frame
local Stats = StatsService
local frame2, textLabel, textLabel2, textLabel3
local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
local UIWindow, UICategories, UILayoutModes, UITabContainers, MainWindow

-- Fallbacks for any remaining anti-tamper variables
-- Luarmor anti-tamper traps neutralized

				_G._RaVeSettingsReset = false

				if not game:IsLoaded() then
					game.Loaded:Wait()
				end

				service = game:GetService("Players")
				UserInputService = game:GetService("UserInputService")
				TweenService = game:GetService("TweenService")
				RunService = game:GetService("RunService")
				Stats = game:GetService("Stats")
				localPlayer = service.LocalPlayer

				if not localPlayer then
					repeat
						service:GetPropertyChangedSignal("LocalPlayer"):Wait()
						localPlayer = service.LocalPlayer
					until localPlayer
				end

				playerGui = localPlayer:WaitForChild("PlayerGui")

				do
					local kawatanHubSession = nil

					local function cleanupSession()
						local prevSession = _G._KawatanHubSession

						if type(prevSession) == "table" then
							prevSession.alive = false
							local teardownList = prevSession.teardown or {}

							for _, teardownCallback in ipairs(teardownList) do
								pcall(teardownCallback)
							end

							local connList = prevSession.connections or {}

							for _, connection in ipairs(connList) do
								pcall(function()
									connection:Disconnect()
								end)
							end
						end

						for _, scriptName in ipairs({ "VX7InfinityJump", "_CandyInfinityJump", "_AceAntiFling", "HoldInfJump", "_AdaptOptimizer" }) do
							local scriptTable = _G[scriptName]

							if type(scriptTable) == "table" then
								pcall(function()
									if scriptTable.Destroy then
										scriptTable.Destroy()
									elseif scriptTable.stop then
										scriptTable.stop()
									end
								end)
							end
						end

						_G._OSHASpeedControllerSession = nil
						_G._KawatanFpsCapSession = nil

						local existingGuiNames = {
							"OSHA",
							"Kawatan",
							"Adapt",
							"Vilon",
							"VilonStealHUD",
							"RaVeStealHUD",
							"RitualStealHUD",
							"VlonEMobileControls",
							"AdaptESP_Visual",
							"KawatanAvatarCatalog",
							"KawatanSkinUI",
						}

						local guiContainers = {}

						pcall(function()
							local coreGui = game:GetService("CoreGui")
							if coreGui and typeof(coreGui) == "Instance" then
								table.insert(guiContainers, coreGui)
							end
						end)

						if playerGui and typeof(playerGui) == "Instance" then
							table.insert(guiContainers, playerGui)
						elseif localPlayer then
							pcall(function()
								local pg = localPlayer:FindFirstChildOfClass("PlayerGui") or localPlayer:FindFirstChild("PlayerGui")
								if pg and typeof(pg) == "Instance" then
									table.insert(guiContainers, pg)
								end
							end)
						end

						if gethui then
							pcall(function()
								local hui = gethui()
								if hui and typeof(hui) == "Instance" then
									table.insert(guiContainers, hui)
								end
							end)
						end

						for _, container in ipairs(guiContainers) do
							if container and typeof(container) == "Instance" then
								for _, guiName in ipairs(existingGuiNames) do
									pcall(function()
										for i = 1, 3 do
											local existingGui = container:FindFirstChild(guiName)
											if existingGui then
												pcall(function()
													existingGui:Destroy()
												end)
												if container:FindFirstChild(guiName) ~= existingGui then
													continue
												end
											end
											break
										end
									end)
								end
							end
						end

						kawatanHubSession = { alive = true, connections = {}, teardown = {} }
						_G._KawatanHubSession = kawatanHubSession
					end

					pcall(cleanupSession)

					safeConnect = function(arg, arg2)
						local connection = nil

						connection = arg:Connect(function(...)
							if not kawatanHubSession.alive then
								pcall(function()
									connection:Disconnect()
								end)

								return
							end

							return arg2(...)
						end)

						local connections = kawatanHubSession.connections
						local connections2

						if #connections > 512 then
							connections2 = {}

							for _, connection2 in ipairs(connections) do
								if connection2.Connected then
									connections2[#connections2 + 1] = connection2
								end
							end

							kawatanHubSession.connections = connections2
						else
							connections2 = connections
						end

						connections2[#connections2 + 1] = connection
						return connection
					end
				end

			font = Font.fromEnum(Enum.Font.GothamBold)

			StealConfig = {
				StealRadius = 63,
				StealDuration = 1.5,
				AutoGrabSetDelayRadius = 8,
				AutoGrabStopTime = 1.1,
			}

			StealState = { AutoSteal = true, AutoGrabStop = true }
			dataTable = {}
			Color3.fromRGB(20, 132, 255)
			local itemTable = { accent = Color3.fromRGB(255, 255, 255) }

		do
			do
				SpeedState = {
					NS = 60,
					CS = 29,
					LG_N = 10.1,
					LG_C = 15,
					family = "normal",
					carry = false,
				}

				_G._RaVeSpeedMethod = _G._RaVeSpeedMethod == "V1" and "V1" or "V2"

				CombatState = {
					aimbot = false,
					aimSpd = 58,
					laggerAimSpd = 40,
					swing = false,
					desync = false,
					desyncSwing = false,
					antiMode = false,
					tpMirror = false,
					desyncTpDist = 8,
					desyncSwingDelay = 0.05,
					desyncNoCam = false,
				}

				VisualState = {
					antilag = false,
					potato = false,
					shiny = false,
					sky = false,
					stretch = false,
					fov = false,
					fovVal = 120,
					stretchValue = 1.2,
				}

				AutoState = { auto = true }

				setmetatable(AutoState, { __newindex = function(arg, arg2, arg3)
					if arg2 == "auto" then
						rawset(arg, arg2, true)
					else
						rawset(arg, arg2, arg3)
					end
				end })

				vlSave1 = function()
				end

				JumpState = { active = false }

				LaggerState = {
					active = false,
					packets = 270,
					delay = 0.25,
					thread = nil,
					key = nil,
					gpKey = nil,
				}

				configTable = {}
				PlotState = nil
				tpMode = nil
				dropMode = nil

				getCurrentSpeed = function()
					if SpeedState.family == "lagger" then
						return SpeedState.carry and SpeedState.LG_C or SpeedState.LG_N
					end
					return SpeedState.carry and SpeedState.CS or SpeedState.NS
				end

				resetMovers = nil
				clearMovers = nil

				do
					local cleanupSession = nil

					local function getStealMode()
						local itemTable = { FakeSpeed = 16 }

						local listTable = {
							"eugeneHorizontalMoveVelocity",
							"eugeneHorizontalMoveAttachment",
							"eugeneAntiDropForce",
							"VilonHorizontalMoveVelocity",
							"VilonHorizontalMoveAttachment",
							"AdaptSpeedVelocity",
							"AdaptSpeedForce",
							"AdaptSpeedAttachment",
						}

						local function removeAttachments(arg)
							if not arg then
								return
							end

							for _, loopItem in ipairs(listTable) do
								local item2 = arg:FindFirstChild(loopItem)

								if item2 then
									pcall(function()
										item2:Destroy()
									end)
								end
							end
						end

						local kawatanVelHijack = _G._KawatanVelHijack

						if type(kawatanVelHijack) ~= "table" then
							kawatanVelHijack = { v = Vector3.zero }
							_G._KawatanVelHijack = kawatanVelHijack
						end

						kawatanVelHijack.v = Vector3.zero
						local rng = Random.new()
						local calcVal1 = 0

						if not _G._KawatanVelHijackInstalled then
							_G._KawatanVelHijackInstalled = true
							local rawMetatable = getrawmetatable and getrawmetatable(game)

							if rawMetatable then
								local setreadonlyFn = setreadonly or make_writeable
								if setreadonlyFn then
									pcall(setreadonlyFn, rawMetatable, false)
								end

								local index = rawMetatable.__index
								local newindex = rawMetatable.__newindex

								local function updateCharacterState(arg, arg2)
									local strName = tostring(arg2)
									if strName ~= "AssemblyLinearVelocity" and strName ~= "Velocity" then
										return false
									end

									if typeof(arg) ~= "Instance" or not arg:IsA("BasePart") then
										return false
									end
									local name = arg.Name
									if name ~= "HumanoidRootPart" and name ~= "Torso" and name ~= "UpperTorso" then
										return false
									end
									local character = localPlayer.Character
									return character ~= nil and arg:IsDescendantOf(character)
								end

								local hookIndex = function(arg, arg2)
									if not (checkcaller and checkcaller()) then
										local ok, result = pcall(updateCharacterState, arg, arg2)
										if ok and result then
											return kawatanVelHijack.v
										end
									end

									return index(arg, arg2)
								end

								local hookNewIndex = function(arg, arg2, item3)
									if not (checkcaller and checkcaller()) then
										local ok, result = pcall(updateCharacterState, arg, arg2)
										if ok and result then
											kawatanVelHijack.v = item3
											return
										end
									end

									return newindex(arg, arg2, item3)
								end

								if type(newcclosure) == "function" then
									rawMetatable.__index = newcclosure(hookIndex)
									rawMetatable.__newindex = newcclosure(hookNewIndex)
								else
									rawMetatable.__index = hookIndex
									rawMetatable.__newindex = hookNewIndex
								end

								if setreadonlyFn then
									pcall(setreadonlyFn, rawMetatable, true)
								end
							end
						end

						cleanupSession = function()
							return SpeedState.carry == true
						end

						clearMovers = function(arg)
							if not arg then
								arg = localPlayer.Character
								arg = arg and arg:FindFirstChild("HumanoidRootPart")
							end

							calcVal1 = 0

							if arg then
								kawatanVelHijack.v = Vector3.new(0, arg.AssemblyLinearVelocity.Y, 0)
							else
								kawatanVelHijack.v = Vector3.zero
							end
						end

						resetMovers = function(arg, arg2, arg3)
							if not arg or not arg2 or not arg2.Parent then
								clearMovers(arg2)
								return
							end
							calcVal1 += tonumber(arg3) or 0
							if calcVal1 < 0 then
								return
							end
							calcVal1 = 0
							local moveDirection = arg.MoveDirection

							if moveDirection.Magnitude > 0.1 then
								pcall(function()
									if arg2.SetNetworkOwner then
										arg2:SetNetworkOwner(localPlayer)
									end
								end)

								local unit = moveDirection.Unit
								local fakeSpeed = itemTable.FakeSpeed
								local calcVal2 = math.clamp(tonumber(getCurrentSpeed()) or 0, 0, 10000)
								local item2 = rng:NextNumber(-0.003, 0.003)
								local item3 = rng:NextNumber(-0.003, 0.003)
								local y = arg2.AssemblyLinearVelocity.Y
								kawatanVelHijack.v = Vector3.new(unit.X * fakeSpeed + item2, y, unit.Z * fakeSpeed + item3)
								arg2.AssemblyLinearVelocity = Vector3.new(unit.X * calcVal2 + item2, y, unit.Z * calcVal2 + item3)
								_G._RaVeLiveSpeed = { v = calcVal2, t = os.clock() }
							else
								kawatanVelHijack.v = Vector3.new(0, arg2.AssemblyLinearVelocity.Y, 0)
							end
						end

						safeConnect(localPlayer.CharacterAdded, function(arg)
							arg:WaitForChild("HumanoidRootPart", 5)
							removeAttachments(arg:FindFirstChild("HumanoidRootPart"))
							calcVal1 = 0
							kawatanVelHijack.v = Vector3.zero
						end)

						if localPlayer.Character then
							removeAttachments(localPlayer.Character:FindFirstChild("HumanoidRootPart"))

							-- [Anti-Tamper Trap 1 removed]
						end

						_G._RaVeClearSpeedMover = function()
							clearMovers()
						end
					end

					getStealMode()
				end
			end

			if not fireproximityprompt then
				fireproximityprompt = getgenv and getgenv().fireproximityprompt or function(arg)
					pcall(function()
						arg:InputHoldBegin()
						task.wait(0.05)
						arg:InputHoldEnd()
					end)
				end
			end

			if playerGui then
				for _, loopItem in ipairs({
					"Adapt",
					"RaVe",
					"Vilon",
					"RaVeStealHUD",
					"VilonStealHUD",
					"AdaptStealHUD",
				}) do
					local item2 = playerGui:FindFirstChild(loopItem)

					if item2 then
						pcall(function()
							item2:Destroy()
						end)
					end
				end
			end

			_G._RaVeTheme = {
				bg = Color3.fromRGB(5, 7, 12),
				card = Color3.fromRGB(11, 15, 24),
				chip = Color3.fromRGB(16, 24, 33),
				line = Color3.fromRGB(26, 34, 42),
				accent = Color3.fromRGB(48, 160, 255),
				text = Color3.fromRGB(234, 240, 255),
				dim = Color3.fromRGB(110, 140, 172),
				danger = Color3.fromRGB(255, 70, 70),
				good = Color3.fromRGB(40, 200, 120),
			}

			_G._KawatanUILocked = _G._KawatanUILocked == true
			_G._RvStrokeIdle = _G._RaVeTheme.line
			_G._RvStrokeActive = _G._RaVeTheme.accent

			do
				local instance2 = Instance.new("ScreenGui")
				instance2.Name = "VilonStealHUD"
				instance2.ResetOnSpawn = false
				instance2.IgnoreGuiInset = true
				instance2.DisplayOrder = 90000

				pcall(function()
					instance2.Parent = gethui and gethui() or game:GetService("CoreGui")
				end)

				if not instance2.Parent then
					instance2.Parent = playerGui
				end

				instance2.Archivable = false

				instance2:GetPropertyChangedSignal("Archivable"):Connect(function()
					if instance2.Parent and instance2.Archivable then
						pcall(function()
							instance2.Archivable = false
						end)
					end
				end)

				instance2.DescendantAdded:Connect(function(descendant)
					pcall(function()
						descendant.Archivable = false
					end)

					descendant:GetPropertyChangedSignal("Archivable"):Connect(function()
						if descendant.Parent and descendant.Archivable then
							pcall(function()
								descendant.Archivable = false
							end)
						end
					end)
				end)

				pcall(function()
					instance2:SetAttribute("_VlonEProtected", true)
				end)

				frame2 = Instance.new("Frame", instance2)
			end
		end

	do
		frame2.Name = "StealBar"
		frame2.Size = UDim2.new(0, 240, 0, 42)
		frame2.AnchorPoint = Vector2.new(0.5, 1)
		frame2.Position = UDim2.new(0.5, 0, 1, -60)

		_G._KawatanResetStealBarPosition = function()
			frame2.Position = UDim2.new(0.5, 0, 1, -24)
			_G._VlPbPos = nil
			pcall(vlSave1)
		end

		frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame2.BackgroundTransparency = 0
		frame2.BorderSizePixel = 0
		frame2.Active = true
		frame2.ClipsDescendants = true
		frame2.ZIndex = 50
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 15)
		_G._KawatanStealBarScale = math.clamp(tonumber(_G._KawatanStealBarScale) or 100, 50, 200)

		do
			local scale = _G._KawatanStealBarScale / 100
			Instance.new("UIScale", frame2).Scale = scale
		end
	end

	do
		_G._KawatanStealBarSetScale = function(arg)
			_G._KawatanStealBarScale = math.clamp(tonumber(arg) or 100, 50, 200)
			local uiScale = frame2:FindFirstChildOfClass("UIScale")

			if uiScale then
				uiScale.Scale = _G._KawatanStealBarScale / 100
			end
		end

		do
			local uiStroke = Instance.new("UIStroke", frame2)
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke.Thickness = 0
			uiStroke.Transparency = 1
			uiStroke.Enabled = false
		end
	end

	instance = Instance.new("TextLabel", frame2)
	instance.Name = "Percent"
	instance.Size = UDim2.new(0, 80, 0, 18)
	instance.Position = UDim2.new(0, 11, 0, 2)
	instance.BackgroundTransparency = 1
	instance.Text = "0%"
	instance.TextColor3 = _G._RaVeTheme.text
	instance.Font = Enum.Font.GothamBlack
	instance.TextSize = 14
	instance.TextXAlignment = Enum.TextXAlignment.Left
	instance.ZIndex = 54
	textLabel = Instance.new("TextLabel", frame2)
	textLabel.Name = "Label"
	textLabel.Size = UDim2.new(0, 80, 0, 13)
	textLabel.Position = UDim2.new(0, 12, 0, 21)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "FPS: 0"
	textLabel.TextColor3 = _G._RaVeTheme.text
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 54
	textLabel2 = Instance.new("TextLabel", frame2)
	textLabel2.Name = "StealModeInfo"
	textLabel2.Size = UDim2.new(0, 160, 0, 13)
	textLabel2.Position = UDim2.new(0.5, -80, 0, 21)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = "NORMAL 60 RADIUS"
	textLabel2.TextColor3 = _G._RaVeTheme.text
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextSize = 11
	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2.ZIndex = 2
	textLabel3 = Instance.new("TextLabel", frame2)
	textLabel3.Name = "Progress"
	textLabel3.Size = UDim2.new(0, 90, 0, 13)
	textLabel3.Position = UDim2.new(1, -90, 0, 21)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = "PING: 0ms"
	textLabel3.TextColor3 = _G._RaVeTheme.text
	textLabel3.Font = Enum.Font.GothamBold
	textLabel3.TextSize = 11
	textLabel3.TextXAlignment = Enum.TextXAlignment.Right
	textLabel3.ZIndex = 54

	do
		local frame3 = Instance.new("Frame", frame2)
		frame3.Name = "StealBarTrack"
		frame3.Size = UDim2.new(1, -4, 0, 14)
		frame3.Position = UDim2.new(0, 9, 1, -22)
		frame3.BackgroundColor3 = Color3.fromRGB(22, 60, 30)
		frame3.BackgroundTransparency = 0
		frame3.BorderSizePixel = 0
		frame3.ZIndex = 51
		frame3.ClipsDescendants = true
		Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
		frame = Instance.new("Frame", frame3)
	end

do
	do
		do
			frame.Name = "Fill"
			frame.Size = UDim2.fromScale(0, 1)
			frame.BackgroundColor3 = _G._RaVeTheme.accent
			frame.BackgroundTransparency = 0
			frame.BorderSizePixel = 0
			frame.ZIndex = 52
			Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

			do
				local uiGradient = Instance.new("UIGradient", frame)

				_G._KawatanStealBarApplySavedPosition = function()
					local vlPbPos = _G._VlPbPos
					if type(vlPbPos) ~= "table" or #vlPbPos ~= 4 then
						return
					end

					pcall(function()
						frame2.Position = UDim2.new(vlPbPos[1], vlPbPos[2], vlPbPos[3], vlPbPos[4])
					end)
				end

				_G._KawatanStealBarSetAccent = function(arg)
					if type(arg) ~= "table" or not arg[1] or not arg[2] then
						return
					end
					frame.BackgroundColor3 = arg[1]
					local item2 = uiGradient
					local colorSequence = ColorSequence.new
					local itemTable = {}
					local item3 = ColorSequenceKeypoint.new(0, arg[1])
					local new = ColorSequenceKeypoint.new
					local item4 = arg[2]
					itemTable[1] = item3

					do
						local values = table.pack(new(1, item4))
						table.move(values, 1, values.n, 2, itemTable)
					end

					item2.Color = colorSequence(itemTable)
				end
			end
		end

		do
			local kawatanStealBarSetAccent = _G._KawatanStealBarSetAccent
			local kawatanLogoAccents = _G._KawatanLogoAccents

			if kawatanLogoAccents then
				kawatanLogoAccents = _G._KawatanLogoAccents[_G._KawatanLogoStyle or ""]
			end

			if not kawatanLogoAccents then
				local color = Color3.fromRGB

				kawatanLogoAccents = {
					fill = {
						Color3.fromRGB(0, 224, 255),
						color(0, 122, 255),
					},
				}
			end

			kawatanStealBarSetAccent(kawatanLogoAccents.fill)
		end
	end

	do
		local function cleanupSession(arg)
			return (string.format("%.1f", tonumber(arg) or 0):gsub("%.0$", ""))
		end

		local function getStealMode()
			if _G._AdaptStealMode == "NORMAL" then
				return "SEMI " .. cleanupSession(tonumber((_G._KawatanStealRadii or {}).Semi) or 8.7) .. " RADIUS"
			end
			local calcVal1 = tonumber((_G._KawatanStealRadii or {}).Normal) or tonumber(StealConfig.StealRadius) or 63
			local item1 = 10
			return "NORMAL " .. cleanupSession(calcVal1) .. item1
		end

		task.spawn(function()
			local currentTime = tick()
			local itemTable = {}
			local calcVal1 = 60

			safeConnect(RunService.RenderStepped, function()
				local currentTick = tick()
				local calcVal2 = currentTick - currentTime
				currentTime = currentTick

				if calcVal2 > 0 then
					table.insert(itemTable, 1 / calcVal2)

					if #itemTable > 10 then
						table.remove(itemTable, 1)
					end

					local calcVal3 = 0

					for _, loopItem in ipairs(itemTable) do
						calcVal3 += loopItem
					end

					calcVal1 = calcVal3 / #itemTable
				end
			end)

			while frame2.Parent do
				local calcVal2 = 0

				if not pcall(function()
					local item1 = Stats.Network.ServerStatsItem["Ping"]

					if item1 then
						calcVal2 = tonumber(item1:GetValue()) or 0
					end
				end) or calcVal2 <= 0 then
					pcall(function()
						local item1 = 0
						calcVal2 = localPlayer:GetNetworkPing() * item1
					end)
				end

				textLabel.Text = string.format("FPS: %d", math.floor(calcVal1 + 0.5))
				textLabel3.Text = string.format("PING: %dms", math.floor(calcVal2 + 0.5))
				textLabel2.Text = getStealMode()
				task.wait(0.4)
			end
		end)
	end
end

do
	local stateFlag = nil
	local position = nil
	local position2 = nil
	local item1 = nil

	frame2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if _G._KawatanUILocked then
				return
			end
			stateFlag = true
			position = input.Position
			position2 = frame2.Position
			item1 = input
		end
	end)

	safeConnect(UserInputService.InputEnded, function(arg)
		if not stateFlag then
			return
		end

		if arg.UserInputType == Enum.UserInputType.Touch and arg ~= item1 then
			return
		end

		if arg.UserInputType ~= Enum.UserInputType.Touch and arg.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		stateFlag = false
		item1 = nil
		local position3 = frame2.Position
		_G._VlPbPos = { position3.X.Scale, position3.X.Offset, position3.Y.Scale, position3.Y.Offset }
		pcall(vlSave1)
	end)

	safeConnect(UserInputService.InputChanged, function(arg)
		if not stateFlag then
			return
		end

		if arg.UserInputType == Enum.UserInputType.MouseMovement or arg.UserInputType == Enum.UserInputType.Touch and arg == item1 then
			local calcVal1 = arg.Position - position
			frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + calcVal1.X, position2.Y.Scale, position2.Y.Offset + calcVal1.Y)
		end
	end)
end

local kawatanStealRadii

do
do
	local function cleanupSession()
		instance.Text = "0%"

		if dataTable.progressFillTween then
			dataTable.progressFillTween:Cancel()
			dataTable.progressFillTween = nil
		end

		if dataTable.progressResetTween then
			dataTable.progressResetTween:Cancel()
		end

		dataTable.progressResetTween = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromScale(0, 1) })
		dataTable.progressResetTween:Play()
	end

	_G._AdaptStealMode = _G._AdaptStealMode == "NORMAL" and "FAST" or "NORMAL"
	_G._KawatanStealRadii = _G._KawatanStealRadii or {}
	kawatanStealRadii = _G._KawatanStealRadii
	kawatanStealRadii.Normal = tonumber(kawatanStealRadii.Normal) or 63
	kawatanStealRadii.Semi = tonumber(kawatanStealRadii.Semi) or 8.7
	fn28 = nil
	fn29 = nil
	normalStealAction = nil

	_G.StealBar = {
		SetProgress = function(arg)
			local calcVal1 = math.clamp(tonumber(arg) or 0, 0, 1)

			if dataTable.progressFillTween then
				pcall(function()
					dataTable.progressFillTween:Cancel()
				end)

				dataTable.progressFillTween = nil
			end

			frame.Size = UDim2.fromScale(calcVal1, 1)
			instance.Text = math.floor(calcVal1 * 100 + 0.5) .. "%"
		end,
		SetState = function()
		end,
		Reset = function()
			cleanupSession()
		end,
	}
end
end

local function cleanupSession()
local function getStealMode()
	return _G._AdaptStealMode == "SEMI" and "Semi" or "Normal"
end

local function removeAttachments()
	return StealState.AutoSteal == true
end

_G.K7NormalSteal = _G.K7NormalSteal or {
	enabled = false,
	radius = 62,
	duration = 1.3,
	animals = {},
	promptCache = {},
	internalCache = {},
	scannerStarted = false,
	isStealing = false,
	stealConn = nil,
	lastSteal = 0,
	cooldown = 0.05,
}

local function updateCharacterState()
	local character = localPlayer.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function executeAction(arg)
	local plotsFolder = workspace:FindFirstChild("Plots")
	local plotModel = plotsFolder and plotsFolder:FindFirstChild(arg)
	if not plotModel then
		return false
	end
	local base = plotModel:FindFirstChild("Base")
	local yourBase = base and base:FindFirstChild("YourBase")
	return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
end

local function disconnectHandler()
	local k7NormalSteal = _G.K7NormalSteal
	k7NormalSteal.animals = {}
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return
	end

	for _, child in ipairs(plots:GetChildren()) do
		if child:IsA("Model") and not executeAction(child.Name) then
			local headPart = child:FindFirstChild("Head")

			if headPart then
				for _, child2 in ipairs(headPart:GetChildren()) do
					if child2:IsA("Model") then
						local base = child2:FindFirstChild("Base")
						base = base and base:FindFirstChild("Spawn")

						if base then
							table.insert(k7NormalSteal.animals, {
								plot = child.Name,
								slot = child2.Name,
								worldPosition = base.Position,
								uid = child.Name .. "_" .. child2.Name,
							})
						end
					end
				end
			end
		end
	end
end

local function setupListener()
	local k7NormalSteal = _G.K7NormalSteal
	if k7NormalSteal.scannerStarted then
		return
	end
	k7NormalSteal.scannerStarted = true

	task.spawn(function()
		task.wait(1)

		while _G.K7NormalSteal do
			if k7NormalSteal.enabled then
				pcall(disconnectHandler)
			end

			task.wait(3)
		end
	end)
end

local function processInput(arg)
	if not arg then
		return nil
	end
	local k7NormalSteal = _G.K7NormalSteal
	local item1 = k7NormalSteal.promptCache[arg.uid]
	if item1 and item1.Parent then
		return item1
	end
	local plots = workspace:FindFirstChild("Plots")
	local item2 = plots and plots:FindFirstChild(arg.plot)
	local animalPodiums = item2 and item2:FindFirstChild("AnimalPodiums")
	animalPodiums = animalPodiums and animalPodiums:FindFirstChild(arg.slot)
	animalPodiums = animalPodiums and animalPodiums:FindFirstChild("Base")
	animalPodiums = animalPodiums and animalPodiums:FindFirstChild("Spawn")
	animalPodiums = animalPodiums and animalPodiums:FindFirstChild("PromptAttachment")
	if not animalPodiums then
		return nil
	end

	for _, child in ipairs(animalPodiums:GetChildren()) do
		if child:IsA("ProximityPrompt") then
			k7NormalSteal.promptCache[arg.uid] = child
			return child
		end
	end

	return nil
end

local function createOrResetBillboard(arg)
	local k7NormalSteal = _G.K7NormalSteal
	if k7NormalSteal.internalCache[arg] then
		return
	end
	local itemTable = { hold = {}, trigger = {}, ready = true }

	pcall(function()
		if getconnections then
			for _, item1 in ipairs(getconnections(arg.PromptButtonHoldBegan)) do
				if type(item1.Function) == "function" then
					table.insert(itemTable.hold, item1.Function)
				end
			end

			for _, item1 in ipairs(getconnections(arg.Triggered)) do
				if type(item1.Function) == "function" then
					table.insert(itemTable.trigger, item1.Function)
				end
			end
		end
	end)

	if #itemTable.hold > 0 or #itemTable.trigger > 0 then
		k7NormalSteal.internalCache[arg] = itemTable
	end
end

local function checkAnchored(arg, arg2)
	local k7NormalSteal = _G.K7NormalSteal
	if not arg or not arg.Parent or k7NormalSteal.isStealing then
		return
	end

	if tick() - (k7NormalSteal.lastSteal or 0) < (k7NormalSteal.cooldown or 0.08) then
		return
	end
	createOrResetBillboard(arg)
	local item1 = k7NormalSteal.internalCache[arg]
	if not item1 or not item1.ready then
		return
	end
	item1.ready = false
	k7NormalSteal.isStealing = true
	k7NormalSteal.lastSteal = tick()

	pcall(function()
		if _G.StealBar then
			_G.StealBar.SetState("STEALING")
		end
	end)

	task.spawn(function()
		if #item1.hold > 0 then
			for _, loopEntry in ipairs(item1.hold) do
				task.spawn(function()
					pcall(loopEntry)
				end)
			end
		end

		local function checkHumanoidPhysics()
			local item2 = updateCharacterState()
			if not item2 or not arg2 or not arg2.worldPosition then
				return false
			end
			return (item2.Position - arg2.worldPosition).Magnitude <= 15
		end

		local currentTime = tick()
		local duration = k7NormalSteal.duration or 1.3

		while true do
			local enabled2 = k7NormalSteal.enabled

			if enabled2 then
				local item2 = 0.1
				enabled2 = getStealMode() == item2
			end

			if enabled2 and tick() - currentTime < duration then
				local calcVal1 = math.min((tick() - currentTime) / duration, 0.8)

				pcall(function()
					if _G.StealBar then
						_G.StealBar.SetProgress(calcVal1)
					end
				end)

				if not (calcVal1 >= 0.5) then
					task.wait(0.02)
					continue
				end
			end

			break
		end

		if not k7NormalSteal.enabled or getStealMode() ~= "Normal" then
			item1.ready = true
			k7NormalSteal.isStealing = false

			pcall(function()
				if _G.StealBar then
					_G.StealBar.Reset()
				end
			end)

			return
		end

		local currentTick = tick()
		local stateFlag

		while true do
			local enabled2 = k7NormalSteal.enabled

			if enabled2 then
				local item2 = 0.1
				enabled2 = getStealMode() == item2
			end

			enabled2 = enabled2 and tick() - currentTick < 2
			stateFlag = false

			if enabled2 then
				pcall(function()
					if _G.StealBar then
						_G.StealBar.SetProgress(0.8)
					end
				end)

				if checkHumanoidPhysics() then
					stateFlag = true
					break
				else
					task.wait(0.05)
					continue
				end
			end

			break
		end

		if not k7NormalSteal.enabled or getStealMode() ~= "Normal" or not stateFlag then
			do
item1.ready = true
				k7NormalSteal.isStealing = false

				pcall(function()
					if _G.StealBar then
						_G.StealBar.Reset()
					end
				end)

				return
			end
		end

		local now4 = tick()
		local calcVal1 = duration * 0.19999999999999996

		while k7NormalSteal.enabled and getStealMode() == "Normal" and tick() - now4 < calcVal1 do
			local calcVal2 = 0.8 + math.min((tick() - now4) / calcVal1, 1) * 0.19999999999999996

			pcall(function()
				if _G.StealBar then
					_G.StealBar.SetProgress(calcVal2)
				end
			end)

			task.wait(0.02)
		end

		if not k7NormalSteal.enabled or getStealMode() ~= "Normal" then
			item1.ready = true
			k7NormalSteal.isStealing = false

			pcall(function()
				if _G.StealBar then
					_G.StealBar.Reset()
				end
			end)

			return
		end

		pcall(function()
			if _G.StealBar then
				_G.StealBar.SetProgress(1)
			end
		end)

		if #item1.trigger > 0 then
			for _, loopEntry in ipairs(item1.trigger) do
				task.spawn(function()
					pcall(loopEntry)
				end)
			end
		end

		task.wait(0.12)
		item1.ready = true
		k7NormalSteal.isStealing = false

		pcall(function()
			if _G.StealBar then
				_G.StealBar.Reset()
			end
		end)
	end)
end

local function checkHumanoidPhysics()
	local k7NormalSteal = _G.K7NormalSteal
	local item1 = updateCharacterState()
	if not item1 then
		return nil
	end
	local huge = math.huge
	local item2 = nil

	for _, animal in ipairs(k7NormalSteal.animals) do
		if animal.worldPosition and not executeAction(animal.plot) then
			local magnitude = (item1.Position - animal.worldPosition).Magnitude

			if magnitude < huge then
				huge = magnitude
				item2 = animal
			end
		end
	end

	local stateFlag

	if item2 then
		stateFlag = huge <= (tonumber(k7NormalSteal.radius) or 62)
	else
		stateFlag = item2
	end

	if stateFlag then
		return item2
	end
	return nil
end

_G.K7NormalAutoStealStop = function()
	local k7NormalSteal = _G.K7NormalSteal
	k7NormalSteal.enabled = false
	k7NormalSteal.isStealing = false

	if k7NormalSteal.stealConn then
		k7NormalSteal.stealConn:Disconnect()
		k7NormalSteal.stealConn = nil
	end

	pcall(function()
		if _G.StealBar then
			_G.StealBar.Reset()
		end
	end)
end

_G.K7NormalAutoStealStart = function()
	local k7NormalSteal = _G.K7NormalSteal
	k7NormalSteal.radius = kawatanStealRadii.Normal
	k7NormalSteal.duration = tonumber(StealConfig.StealDuration) or 1.5
	k7NormalSteal.enabled = true
	setupListener()
	pcall(disconnectHandler)

	if k7NormalSteal.stealConn then
		k7NormalSteal.stealConn:Disconnect()
		k7NormalSteal.stealConn = nil
	end

	k7NormalSteal.stealConn = safeConnect(RunService.Heartbeat, function()
		if not k7NormalSteal.enabled then
			return
		end

		if getStealMode() ~= "Normal" then
			_G.K7NormalAutoStealStop()
			return
		end

		if k7NormalSteal.isStealing then
			return
		end
		local item1 = checkHumanoidPhysics()
		if not item1 then
			return
		end
		local item2 = processInput(item1)

		if item2 then
			checkAnchored(item2, item1)
		end
	end)
end

_G.K7NormalAutoStealSync = function()
	if getStealMode() == "Normal" and removeAttachments() then
		_G.K7NormalAutoStealStart()
	else
		_G.K7NormalAutoStealStop()
	end
end

_G.K7SemiSteal = _G.K7SemiSteal or {}
local k7SemiSteal = _G.K7SemiSteal
k7SemiSteal.conn = k7SemiSteal.conn
k7SemiSteal.scanThread = k7SemiSteal.scanThread
k7SemiSteal.enabled = false
k7SemiSteal.holdMin = 1.3
k7SemiSteal.holdMax = 2.6
k7SemiSteal.entryDelay = 0.3
k7SemiSteal.cooldown = 0.1
k7SemiSteal.primeRange = 80
k7SemiSteal.radius = kawatanStealRadii.Semi
k7SemiSteal.plotSync = k7SemiSteal.plotSync or { caches = {}, connections = {} }
k7SemiSteal.animals = k7SemiSteal.animals or {}
k7SemiSteal.promptCache = k7SemiSteal.promptCache or {}
k7SemiSteal.internalCache = k7SemiSteal.internalCache or {}

k7SemiSteal.state = k7SemiSteal.state or {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
}

local function checkRagdoll(arg, arg2)
	pcall(function()
		if _G.StealBar then
			_G.StealBar.SetState(arg2 or "STEALING")
			_G.StealBar.SetProgress(math.clamp(tonumber(arg) or 0, 0, 1))
		end
	end)
end

local function fn61()
	pcall(function()
		if _G.StealBar then
			_G.StealBar.Reset()
		end
	end)
end

local function createInstance()
	local character = localPlayer.Character

	if character then
		character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	end

	return character or nil
end

local function createCorner(arg)
	if typeof(arg) == "table" then
		return arg
	end
	local itemTable = {}

	for match in string.gmatch(tostring(arg), "[^%.]+") do
		table.insert(itemTable, tonumber(match) or match)
	end

	return itemTable
end

local function createStroke(arg, arg2)
	local item1 = nil
	local item2 = nil

	for _, item3 in ipairs(createCorner(arg)) do
		local item4 = arg2 and arg2[item3]

		if item4 then
			item1 = arg2
			item2 = item3
			arg2 = item4
		else
			item1 = arg2
			item2 = item3
			arg2 = nil
		end
	end

	return arg2, item1, item2
end

local function tweenElement(arg, arg2)
	local item1 = k7SemiSteal.plotSync.caches[arg]
	local item2 = "table"
	if typeof(item1) ~= item2 then
		return
	end
	local item3 = arg2[2]
	local item4 = arg2[3]
	local item5 = arg2[4]
	local item6, item7, item8 = createStroke(arg2[1], item1)

	if item3 == "Changed" then
		if item7 then
			item7[item8] = item4
		end
	elseif item3 == "ArrayInsert" then
		if item6 then
			table.insert(item6, item5, item4)
		end
	elseif item3 == "Semi" then
		if item6 then
			table.remove(item6, item5)
		end
	elseif item3 == "Normal" then
		if item6 then
			item6[item5] = item4
		end
	elseif item3 == "DictionaryRemoved" then
		if item6 then
			item6[item5] = nil
		end
	end
end

local function updateWaypoints(arg, arg2, arg3)
	if k7SemiSteal.plotSync.connections[arg] then
		return
	end
	local strName = tostring(arg.Name)
	if not arg2:FindFirstChild(strName) then
		return
	end

	if arg3 and k7SemiSteal.plotSync.caches[strName] == nil then
		local ok, result = pcall(function()
			return arg3:InvokeServer(strName)
		end)

		k7SemiSteal.plotSync.caches[strName] = ok and typeof(result) == "table" and result or {}
	elseif k7SemiSteal.plotSync.caches[strName] == nil then
		k7SemiSteal.plotSync.caches[strName] = {}
	end

	k7SemiSteal.plotSync.connections[arg] = arg.OnClientEvent:Connect(function(arg4)
		for _, loopItem in ipairs(arg4) do
			tweenElement(strName, loopItem)
		end
	end)
end

local function fn67()
	if k7SemiSteal.syncReady then
		return true
	end

	return pcall(function()
		k7SemiSteal.plots = workspace:WaitForChild("Plots", 5)
		local service2 = game:GetService("TeleportService")
		local packages = service2:WaitForChild("Packages", 10)
		local datas = service2:WaitForChild("Datas", 10)
		if not (packages and datas and k7SemiSteal.plots) then
			return
		end
		k7SemiSteal.animalsData = require(datas:WaitForChild("Animals", 10))
		local synchronizer = packages:WaitForChild("Synchronizer", 10)
		k7SemiSteal.channelFolder = synchronizer:WaitForChild("Channel", 10)
		k7SemiSteal.routeRemote = synchronizer:WaitForChild("CommunicationRoute", 10)
		k7SemiSteal.requestData = synchronizer:FindFirstChild("RequestData")

		for _, child in ipairs(k7SemiSteal.channelFolder:GetChildren()) do
			if child:IsA("Folder") then
				updateWaypoints(child, k7SemiSteal.plots, k7SemiSteal.requestData)
			end
		end

		k7SemiSteal.channelFolder.ChildAdded:Connect(function(child)
			if child:IsA("RemoteEvent") then
				updateWaypoints(child, k7SemiSteal.plots, k7SemiSteal.requestData)
			end
		end)

		k7SemiSteal.routeRemote.OnClientEvent:Connect(function(arg)
			for _, loopItem in ipairs(arg) do
				local item2 = loopItem[1]
				local strName = tostring(loopItem[2])

				if k7SemiSteal.plots and k7SemiSteal.plots:FindFirstChild(strName) then
					if item2 == "Plots" then
						local channelFolder = k7SemiSteal.channelFolder and k7SemiSteal.channelFolder:FindFirstChild(strName)

						if channelFolder and channelFolder:IsA("RemoteEvent") then
							updateWaypoints(channelFolder, k7SemiSteal.plots, k7SemiSteal.requestData)
						end
					elseif item2 == "ListenerRemoved" then
						for k, connection in pairs(k7SemiSteal.plotSync.connections) do
							if tostring(k.Name) == strName then
								pcall(function()
									connection:Disconnect()
								end)

								k7SemiSteal.plotSync.connections[k] = nil
								k7SemiSteal.plotSync.caches[strName] = nil
								break
							end
						end
					end
				end
			end
		end)

		k7SemiSteal.syncReady = true
	end) and k7SemiSteal.syncReady == true
end

local function fn68(arg)
	local plotSign = arg and arg:FindFirstChild("PlotSign")
	local frame2 = plotSign and plotSign:FindFirstChild("SurfaceGui") and plotSign.SurfaceGui:FindFirstChild("Frame")
	frame2 = frame2 and frame2:FindFirstChild("TextLabel")
	if not frame2 or frame2.Text == "Empty Base" then
		return nil
	end
	return frame2.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function fn69(arg)
	if not arg or not arg.plot or not k7SemiSteal.plots then
		return false
	end
	local item1 = k7SemiSteal.plots:FindFirstChild(arg.plot)
	if not item1 then
		return false
	end
	local item2 = fn68(item1)
	return item2 == localPlayer.DisplayName or item2 == localPlayer.Name
end

local function fn70(arg)
	local plots = k7SemiSteal.plots and k7SemiSteal.plots:FindFirstChild(arg.plot)
	plots = plots and plots:FindFirstChild("AnimalPodiums")
	return plots and plots:FindFirstChild(arg.slot) or nil
end

local function fn71(arg)
	local item1 = fn70(arg)
	return item1 and item1:GetPivot().Position or nil
end

local function calculateDistance(arg)
	local item1 = createInstance()
	local item2 = fn71(arg)
	return item1 and item2 and (item1.Position - item2).Magnitude or math.huge
end

local function fn73(arg)
	if not arg then
		return nil
	end
	local item1 = k7SemiSteal.promptCache[arg.uid]
	if item1 and item1.Parent then
		return item1
	end
	local base = fn70(arg)
	base = base and base:FindFirstChild("Base")
	base = base and base:FindFirstChild("Spawn")
	base = base and base:FindFirstChild("PromptAttachment")
	if not base then
		return nil
	end

	for _, child in ipairs(base:GetChildren()) do
		if child:IsA("ProximityPrompt") then
			k7SemiSteal.promptCache[arg.uid] = child
			return child
		end
	end

	return nil
end

local function fn74(arg)
	if k7SemiSteal.internalCache[arg] then
		return
	end
	local itemTable = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

	if ok and type(result) == "table" then
		for _, loopItem in ipairs(result) do
			if type(loopItem.Function) == "function" then
				table.insert(itemTable.holdCallbacks, loopItem.Function)
			end
		end
	end

	local ok2, result2 = pcall(getconnections, arg.Triggered)

	if ok2 and type(result2) == "table" then
		for _, loopItem in ipairs(result2) do
			if type(loopItem.Function) == "function" then
				table.insert(itemTable.triggerCallbacks, loopItem.Function)
			end
		end
	end

	if #itemTable.holdCallbacks > 0 or #itemTable.triggerCallbacks > 0 then
		k7SemiSteal.internalCache[arg] = itemTable
	end
end

local function formatLabel(arg, arg2)
	if not arg or not arg.Parent or not arg2 then
		return false
	end

	if k7SemiSteal.state.active then
		return false
	end

	if tick() - (k7SemiSteal.state.lastResultTime or 0) < (k7SemiSteal.cooldown or 0.05) then
		return false
	end
	fn74(arg)
	local item1 = k7SemiSteal.internalCache[arg]
	if not item1 or not item1.ready then
		return false
	end
	item1.ready = false
	k7SemiSteal.state.active = true
	k7SemiSteal.state.startTime = tick()
	k7SemiSteal.state.phase = "holding"
	k7SemiSteal.state.label = arg2.name or "Animal"

	task.spawn(function()
		local startTime = k7SemiSteal.state.startTime

		for _, holdCallback in ipairs(item1.holdCallbacks) do
			task.spawn(function()
				pcall(holdCallback)
			end)
		end

		while true do
			local stateFlag = k7SemiSteal.enabled and getStealMode() == "Semi"

			if stateFlag then
				stateFlag = tick() - startTime < (k7SemiSteal.holdMin or 1.5)
			end

			if stateFlag then
				checkRagdoll((tick() - startTime) / (k7SemiSteal.holdMax or 2.6), "STEALING")
				task.wait()
				continue
			end

			break
		end

		k7SemiSteal.state.phase = "waitingRange"
		local stateFlag = calculateDistance(arg2) <= (tonumber(k7SemiSteal.radius) or 10)
		local exitTo = nil
		local checkFlag

		while true do
			local parent = k7SemiSteal.enabled and getStealMode() == "Semi" and arg.Parent
			checkFlag = false

			if parent then
				local calcVal1 = tick() - startTime

				if (k7SemiSteal.holdMax or 2.6) < calcVal1 then
					exitTo = 1
					break
				else
					checkRagdoll(calcVal1 / (k7SemiSteal.holdMax or 2.6), "STEAL")

					if calculateDistance(arg2) <= (tonumber(k7SemiSteal.radius) or 5) then
						exitTo = 2
						break
					else
						task.wait()
						continue
					end
				end
			end

			break
		end

		local state, lastResult

		if exitTo == 1 then
			state = k7SemiSteal.state
			lastResult = checkFlag and "Stole " .. tostring(k7SemiSteal.state.label)
		elseif exitTo == 2 then
			if not stateFlag then
				task.wait(k7SemiSteal.entryDelay or 0.1)
			end

			if k7SemiSteal.enabled and getStealMode() == "Semi" then
				for _, triggerCallback in ipairs(item1.triggerCallbacks) do
					task.spawn(function()
						pcall(triggerCallback)
					end)
				end

				checkFlag = true
				state = k7SemiSteal.state
				lastResult = checkFlag and "Stole " .. tostring(k7SemiSteal.state.label)
			else
				state = k7SemiSteal.state
				lastResult = checkFlag and "Stole " .. tostring(k7SemiSteal.state.label)
			end
		else
			state = k7SemiSteal.state
			lastResult = checkFlag and "Stole " .. tostring(k7SemiSteal.state.label)
		end

		state.lastResult = lastResult or "Missed: " .. tostring(k7SemiSteal.state.label)
		k7SemiSteal.state.active = false
		k7SemiSteal.state.phase = "STEALING"
		k7SemiSteal.state.lastResultTime = tick()

		if checkFlag then
			checkRagdoll(1, "STEALING")
		end

		task.wait(k7SemiSteal.cooldown or 0.1)
		item1.ready = true
		fn61()
	end)

	return true
end

local function fn76()
	if not fn67() then
		return 0
	end
	local animals = {}

	for _, child in ipairs(k7SemiSteal.plots:GetChildren()) do
		local animalList = k7SemiSteal.plotSync.caches[child.Name]
		animalList = animalList and animalList.AnimalList

		if typeof(animalList) == "table" then
			for k, item1 in pairs(animalList) do
				if type(item1) == "table" then
					local index = item1.Index
					local animalsData = k7SemiSteal.animalsData and k7SemiSteal.animalsData[index]

					if animalsData then
						table.insert(animals, {
							name = animalsData.DisplayName or index,
							plot = child.Name,
							slot = tostring(k),
							uid = child.Name .. "_" .. tostring(k),
						})
					end
				end
			end
		end
	end

	k7SemiSteal.animals = animals
	return #animals
end

normalStealAction = fn76

local function fn77()
	local item1 = createInstance()
	if not item1 then
		return nil
	end
	local huge = math.huge
	local item2 = nil

	for _, animal in ipairs(k7SemiSteal.animals) do
		if not fn69(animal) then
			local magnitude = fn71(animal)
			magnitude = magnitude and (item1.Position - magnitude).Magnitude or math.huge

			if magnitude <= (k7SemiSteal.primeRange or 8) and magnitude < huge then
				huge = magnitude
				item2 = animal
			end
		end
	end

	return item2
end

local function fn78()
	if k7SemiSteal.scanThread then
		return
	end

	k7SemiSteal.scanThread = task.spawn(function()
		while _G.K7SemiSteal do
			if k7SemiSteal.enabled or getStealMode() == "Semi" then
				pcall(fn76)
			end

			task.wait(10)
		end
	end)
end

_G.K7SemiAutoStealStop = function()
	k7SemiSteal.enabled = false

	if k7SemiSteal.conn then
		k7SemiSteal.conn:Disconnect()
		k7SemiSteal.conn = nil
	end

	k7SemiSteal.state.active = false
	k7SemiSteal.state.phase = "idle"
	fn61()
end

_G.K7SemiAutoStealStart = function()
	k7SemiSteal.radius = kawatanStealRadii.Semi
	k7SemiSteal.enabled = true
	pcall(fn67)
	fn78()
	pcall(fn76)

	if k7SemiSteal.conn then
		k7SemiSteal.conn:Disconnect()
		k7SemiSteal.conn = nil
	end

	k7SemiSteal.conn = safeConnect(RunService.Heartbeat, function()
		if not k7SemiSteal.enabled then
			return
		end

		if getStealMode() ~= "Semi" then
			_G.K7SemiAutoStealStop()
			return
		end

		if k7SemiSteal.state.active then
			return
		end
		local item1 = fn77()
		if not item1 then
			return
		end
		local item2 = fn73(item1)

		if item2 then
			formatLabel(item2, item1)
		end
	end)
end

_G.K7SemiAutoStealSync = function()
	if getStealMode() == "Semi" and removeAttachments() then
		_G.K7SemiAutoStealStart()
	else
		_G.K7SemiAutoStealStop()
	end
end

fn28 = function()
	if not removeAttachments() then
		_G.K7NormalAutoStealStop()
		_G.K7SemiAutoStealStop()
		return
	end

	local item1 = 0.1

	if getStealMode() == item1 then
		_G.K7SemiAutoStealStop()
		_G.K7NormalAutoStealSync()
	else
		_G.K7NormalAutoStealStop()
		_G.K7SemiAutoStealSync()
	end
end

fn29 = function()
	_G.K7NormalAutoStealStop()
	_G.K7SemiAutoStealStop()
end

local function candyNormalAutoStealSetRadius(arg)
	kawatanStealRadii.Normal = tonumber(arg) or kawatanStealRadii.Normal
	StealConfig.StealRadius = kawatanStealRadii.Normal
	_G.K7NormalSteal.radius = kawatanStealRadii.Normal
end

local function candySemiAutoStealSetRadius(arg)
	kawatanStealRadii.Semi = tonumber(arg) or kawatanStealRadii.Semi
	k7SemiSteal.radius = kawatanStealRadii.Semi
end

_G.CandyNormalAutoStealSetRadius = candyNormalAutoStealSetRadius
_G.AceNormalAutoStealSetRadius = candyNormalAutoStealSetRadius
_G.CandySemiAutoStealSetRadius = candySemiAutoStealSetRadius
_G.AceSemiAutoStealSetRadius = candySemiAutoStealSetRadius

_G._KawatanStealAnyLive = function()
	return _G.K7NormalSteal.enabled == true or k7SemiSteal.enabled == true
end
end

cleanupSession()

local vector

do
local dataTable, candyIsCarrying

do
do
	local raVeRagdollStealState, cleanupSession, getStealMode

	do
		_G._RaVeRagdollStealState = _G._RaVeRagdollStealState or {}
		raVeRagdollStealState = _G._RaVeRagdollStealState

		if _G._CandyRagdollStealEnabled == nil then
			_G._CandyRagdollStealEnabled = true
		end

		raVeRagdollStealState.enabled = _G._CandyRagdollStealEnabled ~= false
		raVeRagdollStealState.active = false
		raVeRagdollStealState.triggered = false
		raVeRagdollStealState.startTime = 0
		raVeRagdollStealState.savedAutoSteal = nil
		raVeRagdollStealState.autoStealPaused = false

		do
			local function removeAttachments()
				local candyAutoStealToggle = _G._CandyAutoStealToggle

				if candyAutoStealToggle and candyAutoStealToggle.SetVisual then
					pcall(candyAutoStealToggle.SetVisual, true)
				end
			end

			cleanupSession = function()
				StealState.AutoSteal = false
				pcall(fn29)
			end

			getStealMode = function()
				StealState.AutoSteal = true
				pcall(fn29)
				pcall(fn28)
				removeAttachments()
			end
		end
	end

	do
		local function removeAttachments(arg)
			if arg and raVeRagdollStealState.savedAutoSteal and raVeRagdollStealState.autoStealPaused then
				getStealMode()
			end

			raVeRagdollStealState.active = false
			raVeRagdollStealState.triggered = false
			raVeRagdollStealState.startTime = 0
			raVeRagdollStealState.savedAutoSteal = nil
			raVeRagdollStealState.autoStealPaused = false
		end

		_G._CandyAutoStealIntent = function()
			if raVeRagdollStealState.autoStealPaused and raVeRagdollStealState.savedAutoSteal then
				return true
			end
			return StealState.AutoSteal == true
		end

		_G._CandyRagdollStealUserSet = function(arg)
			if arg == false then
				raVeRagdollStealState.savedAutoSteal = false
				raVeRagdollStealState.autoStealPaused = false
			elseif raVeRagdollStealState.active and raVeRagdollStealState.autoStealPaused then
				raVeRagdollStealState.savedAutoSteal = true
			end
		end

		_G._CandyRagdollStealSet = function(arg)
			local candyRagdollStealEnabled = arg ~= false
			_G._CandyRagdollStealEnabled = candyRagdollStealEnabled
			raVeRagdollStealState.enabled = candyRagdollStealEnabled

			if not candyRagdollStealEnabled and raVeRagdollStealState.active then
				removeAttachments(true)
			end

			return candyRagdollStealEnabled
		end

		_G._CandyRagdollStealGet = function()
			return _G._CandyRagdollStealEnabled ~= false
		end

		if _G._RaVeRagdollStealConnection then
			pcall(function()
				_G._RaVeRagdollStealConnection:Disconnect()
			end)

			_G._RaVeRagdollStealConnection = nil
		end

		_G._CandyRagdollDelays = { normal = 1.35, semi = 1.4 }

		local function updateCharacterState()
			local candyRagdollDelays = _G._CandyRagdollDelays
			if _G._AdaptStealMode == "SEMI" then
				return tonumber(candyRagdollDelays.semi) or 1.4
			end
			return tonumber(candyRagdollDelays.normal) or 1.35
		end

		_G._RaVeRagdollStealConnection = safeConnect(RunService.RenderStepped, function()
			if not raVeRagdollStealState.enabled then
				if raVeRagdollStealState.active then
					removeAttachments(true)
				end

				return
			end

			local character = localPlayer.Character
			character = character and character:FindFirstChildOfClass("Humanoid")
			if not character then
				removeAttachments(true)
				return
			end
			local state = character:GetState()
			local stateFlag = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown

			if stateFlag and not raVeRagdollStealState.active then
				raVeRagdollStealState.active = true
				raVeRagdollStealState.triggered = false
				raVeRagdollStealState.startTime = tick()
				raVeRagdollStealState.savedAutoSteal = StealState.AutoSteal == true

				if raVeRagdollStealState.savedAutoSteal then
					raVeRagdollStealState.autoStealPaused = true
					cleanupSession()
				end
			end

			if not raVeRagdollStealState.active then
				return
			end
			local startTime = raVeRagdollStealState.startTime
			local calcVal1 = tick() - startTime
			local item1 = updateCharacterState()

			if calcVal1 >= item1 and not raVeRagdollStealState.triggered then
				raVeRagdollStealState.triggered = true

				if raVeRagdollStealState.savedAutoSteal then
					getStealMode()
					raVeRagdollStealState.autoStealPaused = false
				end
			elseif calcVal1 >= item1 + 0.1 and not stateFlag then
				removeAttachments(false)
			end
		end)
	end
end

vector = Vector3.new()

WaypointState = {
	L = false,
	R = false,
	lRef = nil,
	rRef = nil,
	startL = nil,
	stopL = nil,
	startR = nil,
	stopR = nil,
}

dataTable = {
	active = false,
	previous = nil,
	graceUntil = 0,
	conn = nil,
}

do
	local function cleanupSession(arg)
		local strName = tostring(arg or ""):lower()
		return strName:find("bat") or strName:find("slap") or strName:find("medusa") or strName:find("head") or strName:find("stone")
	end

	candyIsCarrying = function(arg)
		if not arg then
			return false
		end
		local item1 = true
		if localPlayer:GetAttribute("Stealing") == item1 or localPlayer:GetAttribute("AntiKick") == true or arg:GetAttribute("Stealing") == true then
			return true
		end

		for _, loopEntry in ipairs({ "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }) do
			local stateFlag = arg:FindFirstChild(loopEntry, true)

			if stateFlag then
				local value = stateFlag:IsA("BoolValue") and stateFlag.Value or stateFlag:IsA("ObjectValue") and stateFlag.Value

				if value then
					stateFlag = value
				else
					stateFlag = stateFlag:IsA("StringValue") and stateFlag.Value ~= ""
				end
			end

			if stateFlag then
				return true
			end
		end

		for _, child in ipairs(arg:GetChildren()) do
			local strName = child.Name:lower()
			if child:IsA("Tool") and not cleanupSession(strName) then
				return true
			end
			local basePart = child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true)

			if basePart then
				basePart = strName:find("drop") or strName:find("held") or strName:find("carry") or strName:find("ball") or strName:find("throw") or strName:find("steal")
			end

			if basePart then
				return true
			end
		end

		return false
	end
end
end

local cleanupSession, getStealMode, itemTable, removeAttachments, updateCharacterState

do
do
	local function executeAction()
		if _G._RvRefreshSpeedModes then
			pcall(_G._RvRefreshSpeedModes)
		end

		if _G._RaVeAPI and _G._RaVeAPI.carry and _G._RaVeAPI.carry.SetVisual then
			pcall(_G._RaVeAPI.carry.SetVisual, SpeedState.family == "Bedwars" and SpeedState.carry)
		end
	end

	cleanupSession = function()
		if dataTable.active then
			dataTable.graceUntil = tick() + 0.75
			return
		end
		dataTable.previous = { family = SpeedState.family, carry = SpeedState.carry }
		dataTable.active = true
		dataTable.graceUntil = tick() + 0.75
		SpeedState.carry = true
		executeAction()
	end

	getStealMode = function()
		if not dataTable.active then
			return
		end
		local previous = dataTable.previous
		local item1 = dataTable
		dataTable.active = false
		item1.previous = nil

		if previous then
			local item2 = SpeedState
			local carry = previous.carry
			SpeedState.family = previous.family
			item2.carry = carry
		end

		executeAction()
	end

	_G._AdaptAutoCarry = _G._AdaptAutoCarry or false
	_G._AdaptAutoCarryVersion = _G._AdaptAutoCarryVersion == "V2" and "V2" or "V1"
	_G._AdaptAutoCarryV2Range = tonumber(_G._AdaptAutoCarryV2Range) or 15

	itemTable = {
		spots = {},
		nextScan = 0,
		latched = false,
		held = false,
		armed = true,
	}

	removeAttachments = function()
		local spots = {}
		local plots = workspace:FindFirstChild("Plots")
		if not plots then
			itemTable.spots = spots
			return
		end

		for _, child in ipairs(plots:GetChildren()) do
			local yourBase = child:FindFirstChild("Base")
			yourBase = yourBase and yourBase:FindFirstChild("YourBase")

			if not (yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true) then
				local animalPodiums = child:FindFirstChild("AnimalPodiums")

				if animalPodiums then
					for _, child2 in ipairs(animalPodiums:GetChildren()) do
						local base = child2:FindFirstChild("Base")
						base = base and base:FindFirstChild("Spawn")

						if base then
							spots[#spots + 1] = base.Position
						end
					end
				end
			end
		end

		itemTable.spots = spots
	end

	updateCharacterState = function()
		if not dataTable.active then
			dataTable.previous = { family = SpeedState.family, carry = SpeedState.carry }
			dataTable.active = true
		end

		dataTable.graceUntil = tick() + 0.75
		SpeedState.carry = true
		executeAction()
	end
end
end

do
local function executeAction(arg)
	arg = arg and arg:FindFirstChild("HumanoidRootPart")
	if not arg then
		return false
	end
	local calcVal1 = tonumber(_G._AdaptAutoCarryV2Range) or 15
	local raVeStealTargetPos = _G._RaVeStealTargetPos
	if typeof(raVeStealTargetPos) == "Vector3" and (arg.Position - raVeStealTargetPos).Magnitude <= calcVal1 then
		return true
	end
	local currentTime = tick()

	if itemTable.nextScan <= currentTime then
		itemTable.nextScan = currentTime + 0.5
		removeAttachments()
	end

	for _, spot in ipairs(itemTable.spots) do
		if (arg.Position - spot).Magnitude <= calcVal1 then
			return true
		end
	end

	return false
end

_G._AdaptStartAutoCarry = function()
	if dataTable.conn then
		dataTable.conn:Disconnect()
	end

	dataTable.conn = safeConnect(RunService.RenderStepped, function()
		if not _G._AdaptAutoCarry then
			getStealMode()
			return
		end
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not character or not humanoid or humanoid.Health <= 0 then
			getStealMode()
			return
		end

		if _G._AdaptAutoCarryVersion == "V2" then
			local item1 = executeAction(character)
			local item2 = candyIsCarrying(character)
			local stateFlag = not item1

			if stateFlag then
				itemTable.armed = true
			end

			if stateFlag or SpeedState.carry ~= true then
				itemTable.latched = false
			end

			if item1 and itemTable.armed and not itemTable.latched then
				itemTable.latched = true
				itemTable.held = false
				updateCharacterState()
			end

			if dataTable.active then
				if item2 then
					itemTable.held = true
					dataTable.graceUntil = tick() + 0.75
				elseif itemTable.held then
					itemTable.held = false
					itemTable.latched = false
					itemTable.armed = false
					getStealMode()
				else
					local checkFlag = not item1

					if checkFlag then
						local graceUntil = dataTable.graceUntil
						checkFlag = tick() > graceUntil
					end

					if checkFlag then
						itemTable.latched = false
						getStealMode()
					end
				end
			end

			return
		end

		if candyIsCarrying(character) then
			cleanupSession()
		elseif dataTable.active then
			getStealMode()
		end
	end)
end
end

safeConnect(localPlayer.CharacterAdded, function()
local item1 = itemTable
local item2 = itemTable
itemTable.latched = false
item1.held = false
item2.armed = true
end)

_G._AdaptStopAutoCarry = function()
if dataTable.conn then
	dataTable.conn:Disconnect()
	dataTable.conn = nil
end

local item1 = itemTable
local item2 = itemTable
itemTable.latched = false
item1.held = false
item2.armed = true
getStealMode()
end

_G.AutoCarrySpeed = { IsCarryingBrainrot = candyIsCarrying, Enable = cleanupSession, Disable = getStealMode }
_G._CandyIsCarrying = candyIsCarrying
end

do
do
do
	do
		local function cleanupSession()
			local dataTable = { "L1", "LEND", "LFINAL", "R1", "REND", "RFINAL" }

			local itemTable = {
				L1 = Vector3.new(-483.12, -5.03, 25.48),
				LEND = Vector3.new(-481.07, -5.33, 94.88),
				LFINAL = Vector3.new(-471.56, -6.83, 6.73),
				R1 = Vector3.new(-474.75, -5.03, 25.36),
				REND = Vector3.new(-481.09, -5.33, 25.49),
				RFINAL = Vector3.new(-470.93, -6.83, 113.65),
			}

			local vector2 = Vector3.new(-476.48, -6.28, 92.73)
			local vector3 = Vector3.new(-483.12, -4.95, 25.36)
			local vector4 = Vector3.new(-476.16, -6.52, 25.62)
			local vector5 = Vector3.new(-474.75, -5.03, 25.48)

			local function getStealMode()
				return _G._KawatanPathMode == "AUTO PLAY"
			end

			local function removeAttachments()
				if SpeedState.family == "Duel" then
					return SpeedState.LG_N
				end
				return SpeedState.NS
			end

			local function updateCharacterState(arg)
				local character = localPlayer.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				character = character and character:FindFirstChildOfClass("Humanoid")
				if not humanoidRootPart or not character or character.Health <= 0 then
					return false, nil
				end
				local vector6 = Vector3.new(arg.X - humanoidRootPart.Position.X, 0, arg.Z - humanoidRootPart.Position.Z)
				if vector6.Magnitude <= 1 then
					return true, humanoidRootPart
				end
				local unit = vector6.Unit
				local item1 = removeAttachments()
				_G._RaVeLiveSpeed = { v = item1, t = os.clock() }
				local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
				character:Move(unit, false)
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(unit.X * item1, assemblyLinearVelocity.Y, unit.Z * item1)
				return false, humanoidRootPart
			end

			local function executeAction()
				local raVeTryAutoRouteSteal = _G._RaVeTryAutoRouteSteal

				if type(raVeTryAutoRouteSteal) == "function" then
					pcall(raVeTryAutoRouteSteal)
				end
			end

			local function disconnectHandler()
				local character = localPlayer.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid:Move(Vector3.zero, false)
				end

				if humanoidRootPart then
					humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end
			end

			local kawatanAutoPathWaypoints = {}

			for key, val in pairs(itemTable) do
				kawatanAutoPathWaypoints[key] = val
			end

			_G._KawatanAutoPathWaypoints = kawatanAutoPathWaypoints

			local function setupListener()
				if not writefile then
					return
				end
				local listTable = {}

				for _, loopItem in ipairs(dataTable) do
					local item2 = kawatanAutoPathWaypoints[loopItem]
					if item2 then
						listTable[loopItem] = { x = item2.X, y = item2.Y, z = item2.Z }
					end
				end

				local ok, result = pcall(function()
					return game:GetService("HttpService"):JSONEncode(listTable)
				end)

				if ok then
					pcall(writefile, "KawatanAutoPathWaypoints.json", result)
				end
			end

			pcall(function()
				if not (isfile and isfile("KawatanAutoPathWaypoints.json")) then
					return
				end
				local ok, result = pcall(readfile, "KawatanAutoPathWaypoints.json")
				if not ok then
					return
				end

				local ok2, result2 = pcall(function()
					return game:GetService("HttpService"):JSONDecode(result)
				end)

				if not (ok2 and type(result2) == "table") then
					return
				end

				for _, loopItem in ipairs(dataTable) do
					local item2 = result2[loopItem]
					if type(item2) == "table" and tonumber(item2.x) and tonumber(item2.y) and tonumber(item2.z) then
						kawatanAutoPathWaypoints[loopItem] = Vector3.new(tonumber(item2.x), tonumber(item2.y), tonumber(item2.z))
					end
				end
			end)

			_G._KawatanAutoPathSetWaypoint = function(arg, arg2)
				if not kawatanAutoPathWaypoints[arg] then
					return false
				end
				local character = localPlayer.Character
				character = character and character:FindFirstChild("HumanoidRootPart")
				local position = arg2 or character and character.Position
				if not position then
					return false
				end
				kawatanAutoPathWaypoints[arg] = position
				setupListener()
				return true
			end

			_G._KawatanAutoPathResetWaypoints = function()
				for k, item1 in pairs(itemTable) do
					kawatanAutoPathWaypoints[k] = item1
				end

				setupListener()
			end

			local function processInput()
				local character = localPlayer.Character
				return character and character:FindFirstChild("HumanoidRootPart")
			end

			local function createOrResetBillboard()
				local character = localPlayer.Character
				return character and character:FindFirstChildOfClass("Humanoid")
			end

			local function checkAnchored()
				if SpeedState.family == "Duel" then
					return SpeedState.LG_C or 15
				end
				return SpeedState.NS or 60
			end

			local function checkHumanoidPhysics()
				if SpeedState.family == "Duel" then
					return SpeedState.LG_N or 10.1
				end
				return SpeedState.CS or 29
			end

			local vilonPathLinearVelocity = nil
			local attachment = nil
			local vector22 = Vector2.zero
			local calcVal1 = 0

			local function checkRagdoll()
				if vilonPathLinearVelocity then
					pcall(function()
						vilonPathLinearVelocity.PlaneVelocity = Vector2.zero
						vilonPathLinearVelocity.Enabled = false
						vilonPathLinearVelocity:Destroy()
					end)
				end

				if attachment then
					pcall(function()
						attachment:Destroy()
					end)
				end

				vilonPathLinearVelocity = nil
				attachment = nil
				vector22 = Vector2.zero
				calcVal1 = 0
			end

			local function fn61(parent)
				if not (parent and parent.Parent) then
					return nil
				end

				if not (vilonPathLinearVelocity and vilonPathLinearVelocity.Parent == parent) then
					checkRagdoll()
					attachment = parent:FindFirstChild("RootRigAttachment")

					if not (attachment and attachment:IsA("Attachment")) then
						attachment = Instance.new("Attachment")
						attachment.Name = "VilonPathAttachment"
						attachment.Parent = parent
					end

					vilonPathLinearVelocity = parent:FindFirstChild("VilonPathLinearVelocity")

					if not (vilonPathLinearVelocity and vilonPathLinearVelocity:IsA("LinearVelocity")) then
						vilonPathLinearVelocity = Instance.new("LinearVelocity")
						vilonPathLinearVelocity.Name = "VilonPathLinearVelocity"
						vilonPathLinearVelocity.Parent = parent
					end

					vilonPathLinearVelocity.Attachment0 = attachment
					vilonPathLinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
					vilonPathLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
					vilonPathLinearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
					vilonPathLinearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
					vilonPathLinearVelocity.ForceLimitsEnabled = true
					vilonPathLinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
					vilonPathLinearVelocity.PlaneVelocity = Vector2.zero
				end

				local calcVal2 = math.max(parent.AssemblyMass, 1) * 1600
				vilonPathLinearVelocity.MaxPlanarAxesForce = Vector2.new(calcVal2, calcVal2)
				return vilonPathLinearVelocity
			end

			local function createInstance(arg, arg2, arg3, arg4, arg5)
				local item1 = fn61(arg)
				if not item1 then
					return
				end
				local calcVal2 = math.clamp(arg5 or 0.016, 0.005, 0.033333333333333333)
				local vector23 = Vector2.new(arg3.X * arg4, arg3.Z * arg4)
				local magnitude = vector23.Magnitude
				local stateFlag = magnitude > calcVal1 + 0.5
				local checkFlag

				if stateFlag then
					checkFlag = stateFlag
				else
					checkFlag = magnitude >= 0.01 and vector22.Magnitude < 0.5
				end

				if checkFlag then
					vector22 = vector23
				else
					local matchFlag = magnitude >= 0.5 and vector22.Magnitude >= 0.01
					local calcVal3 = 24

					if matchFlag then
						calcVal3 = vector22.Unit:Dot(vector23.Unit) < 0.96 and 34 or 24
					end

					vector22 = vector22:Lerp(vector23, 1 - math.exp(-calcVal3 * calcVal2))
				end

				calcVal1 = magnitude
				_G._RaVeLiveSpeed = { v = arg4, t = os.clock() }

				pcall(function()
					arg2:Move(Vector3.zero, false)
				end)

				item1.Enabled = true
				item1.PlaneVelocity = vector22
			end

			local function createCorner(arg, arg2)
				vector22 = Vector2.zero
				calcVal1 = 0

				if arg2 then
					pcall(function()
						arg2:Move(Vector3.zero, false)
					end)
				end

				if vilonPathLinearVelocity and vilonPathLinearVelocity.Parent then
					pcall(function()
						vilonPathLinearVelocity.PlaneVelocity = Vector2.zero
						vilonPathLinearVelocity.Enabled = false
					end)
				end
			end

			local listTable = {
				active = false,
				controls = nil,
				jumpConn = nil,
				watchdog = nil,
				originalMoveFunction = nil,
				usedDisableFallback = false,
			}

			local function moveFunction()
			end

			local function createStroke()
				local ok, result = pcall(function()
					local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
					playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
					if not playerScripts then
						return nil
					end
					return require(playerScripts):GetControls()
				end)

				return ok and result or nil
			end

			local function tweenElement(arg)
				if not arg then
					return false
				end

				if arg.moveFunction == nil then
					return false
				end

				if arg.moveFunction ~= moveFunction then
					listTable.originalMoveFunction = arg.moveFunction
				end

				arg.moveFunction = moveFunction
				return true
			end

			local function updateWaypoints()
				if not listTable.active then
					return
				end
				listTable.active = false

				if listTable.jumpConn then
					listTable.jumpConn:Disconnect()
					listTable.jumpConn = nil
				end

				listTable.watchdog = nil
				local controls = listTable.controls or createStroke()

				if controls then
					pcall(function()
						if controls.moveFunction == moveFunction then
							controls.moveFunction = listTable.originalMoveFunction or localPlayer.Move
						end

						if listTable.usedDisableFallback then
							controls:Enable()
						end
					end)
				end

				listTable.originalMoveFunction = nil
				listTable.usedDisableFallback = false
				listTable.controls = nil
			end

			local function fn67()
				if listTable.active then
					return
				end
				listTable.active = true
				listTable.controls = createStroke()
				listTable.usedDisableFallback = false
				local stateFlag = true

				if listTable.controls then
					stateFlag = false

					pcall(function()
						stateFlag = tweenElement(listTable.controls)
					end)
				end

				if not stateFlag then
					listTable.usedDisableFallback = true

					if listTable.controls then
						pcall(function()
							listTable.controls:Disable()
						end)
					end

					listTable.jumpConn = safeConnect(UserInputService.JumpRequest, function()
						if not listTable.active then
							return
						end
						local item1 = createOrResetBillboard()

						if item1 and item1.Health > 0 then
							item1.Jump = true
						end
					end)
				end

				local watchdog = {}
				listTable.watchdog = watchdog

				task.spawn(function()
					while true do
						if listTable.active and listTable.watchdog == watchdog then
							if not (WaypointState.L or WaypointState.R) then
								updateWaypoints()
								break
							else
								local controls = listTable.controls

								if not controls then
									controls = createStroke()
									listTable.controls = controls
								end

								if controls then
									pcall(function()
										if listTable.usedDisableFallback then
											controls:Disable()
										else
											tweenElement(controls)
										end
									end)
								end

								task.wait(0.05)
								continue
							end
						end

						break
					end
				end)
			end

			local propTable = {
				hiddenPart = nil,
				targetAttach = nil,
				alignOrient = nil,
				charAttach = nil,
				charAttachOwned = false,
				originalAutoRotate = true,
			}

			local function fn68()
				if propTable.hiddenPart then
					pcall(function()
						propTable.hiddenPart:Destroy()
					end)
				end

				if propTable.charAttachOwned and propTable.charAttach and propTable.charAttach.Parent then
					pcall(function()
						propTable.charAttach:Destroy()
					end)
				end

				local item1 = createOrResetBillboard()

				if item1 and propTable.originalAutoRotate ~= nil then
					pcall(function()
						item1.AutoRotate = propTable.originalAutoRotate
					end)
				end

				propTable.originalAutoRotate = nil
				propTable.alignOrient = nil
				propTable.targetAttach = nil
				propTable.hiddenPart = nil
				propTable.charAttach = nil
				propTable.charAttachOwned = false
			end

			local function fn69()
				local item1 = processInput()
				local item2 = createOrResetBillboard()
				if not item1 or not item2 then
					return
				end
				fn68()
				local part = Instance.new("Part")
				part.Name = "TerrainHelper"
				part.Anchored = true
				local item3 = false
				part.CanCollide = false
				part.CanQuery = item3
				part.CanTouch = false
				part.Transparency = 1
				part.Size = Vector3.new(0.1, 0.1, 0.1)
				part.CFrame = CFrame.new(0, -1000, 0)
				part.Parent = workspace:FindFirstChild("Terrain") or workspace
				local attachment2 = Instance.new("Attachment")
				attachment2.Name = "RootAttachment"
				attachment2.Parent = part
				local rootRigAttachment = item1:FindFirstChild("RootRigAttachment")
				local charAttachOwned = false

				if not rootRigAttachment then
					rootRigAttachment = Instance.new("Attachment")
					rootRigAttachment.Name = "RootAttachment"
					rootRigAttachment.Parent = item1
					charAttachOwned = true
				end

				local alignOrientation = Instance.new("AlignOrientation")
				alignOrientation.Name = "AlignOrientation"
				alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
				alignOrientation.Attachment0 = rootRigAttachment
				alignOrientation.CFrame = CFrame.lookAt(item1.Position, item1.Position + Vector3.new(-1, 0, 0))
				alignOrientation.MaxTorque = math.huge
				alignOrientation.MaxAngularVelocity = 80
				alignOrientation.Responsiveness = 10
				alignOrientation.RigidityEnabled = false
				alignOrientation.PrimaryAxisOnly = false
				alignOrientation.Parent = part
				propTable.hiddenPart = part
				propTable.targetAttach = attachment2
				propTable.charAttach = rootRigAttachment
				propTable.charAttachOwned = charAttachOwned
				propTable.alignOrient = alignOrientation
				propTable.originalAutoRotate = item2.AutoRotate
				item2.AutoRotate = false
			end

			local function fn70(arg)
				local alignOrient = propTable.alignOrient

				if alignOrient and alignOrient.Parent and arg then
					alignOrient.CFrame = CFrame.lookAt(arg.Position, arg.Position + Vector3.new(-1, 0, 0))
				end
			end

			local function fn71()
				fn67()

				if not pcall(fn69) then
					pcall(fn68)
					updateWaypoints()
					return false
				end

				return true
			end

			local function calculateDistance()
				updateWaypoints()
				fn68()
			end

			safeConnect(localPlayer.CharacterRemoving, function()
				if WaypointState.L then
					pcall(function()
						WaypointState.stopL()
					end)
				end

				if WaypointState.R then
					pcall(function()
						WaypointState.stopR()
					end)
				end

				pcall(calculateDistance)
			end)

			safeConnect(localPlayer.CharacterAdded, function()
				checkRagdoll()

				if not (WaypointState.L or WaypointState.R) then
					pcall(calculateDistance)
				end
			end)

			local item1 = nil
			local item2 = nil
			local calcVal2 = 1
			local calcVal3 = 1

			local function fn73(arg, arg2)
				return Vector3.new(arg2.X - arg.Position.X, 0, arg2.Z - arg.Position.Z)
			end

			WaypointState.stopL = function()
				if item1 then
					item1:Disconnect()
					item1 = nil
				end

				calcVal2 = 1
				WaypointState.L = false
				createCorner(processInput(), createOrResetBillboard())
				disconnectHandler()
				checkRagdoll()

				if not WaypointState.R then
					calculateDistance()
				end

				if WaypointState.lRef and WaypointState.lRef.SetVisual then
					WaypointState.lRef.SetVisual(false)
				end
			end

			WaypointState.stopR = function()
				if item2 then
					item2:Disconnect()
					item2 = nil
				end

				calcVal3 = 1
				WaypointState.R = false
				createCorner(processInput(), createOrResetBillboard())
				disconnectHandler()
				checkRagdoll()

				if not WaypointState.L then
					calculateDistance()
				end

				if WaypointState.rRef and WaypointState.rRef.SetVisual then
					WaypointState.rRef.SetVisual(false)
				end
			end

			WaypointState.startL = function()
				if item1 then
					item1:Disconnect()
				end

				calcVal2 = 1

				if getStealMode() then
					fn71()
				end

				item1 = safeConnect(RunService.Heartbeat, function(arg)
					if not WaypointState.L then
						return
					end
					local item3 = processInput()
					local item4 = createOrResetBillboard()
					if not item3 or not item4 then
						return
					end

					if getStealMode() then
						fn70(item3)
					end

					if not getStealMode() then
						local item5, item6 = updateCharacterState(calcVal2 == 1 and vector2 or vector3)
						if not item5 then
							return
						end

						if calcVal2 == 1 then
							calcVal2 = 2
							return
						end

						if item6 then
							item6.CFrame = CFrame.new(item6.Position)
						end

						executeAction()
						WaypointState.stopL()
						return
					end

					if calcVal2 == 1 then
						local item5 = fn73(item3, kawatanAutoPathWaypoints.L1)
						if item5.Magnitude < 1 then
							calcVal2 = 2
							return
						end
						createInstance(item3, item4, item5.Unit, checkAnchored(), arg)
					elseif calcVal2 == 2 then
						local item5 = fn73(item3, kawatanAutoPathWaypoints.LEND)

						if item5.Magnitude < 1 then
							calcVal2 = 0
							createCorner(item3, item4)

							task.delay(0.2, function()
								if WaypointState.L then
									calcVal2 = 1
								end
							end)

							return
						end

						createInstance(item3, item4, item5.Unit, checkAnchored(), arg)
					else
						if calcVal2 == 0 then
							return
						end

						if calcVal2 == 3 then
							local item5 = fn73(item3, kawatanAutoPathWaypoints.L1)
							if item5.Magnitude < 1 then
								calcVal2 = 4
								return
							end
							createInstance(item3, item4, item5.Unit, checkHumanoidPhysics(), arg)
						elseif calcVal2 == 4 then
							local item5 = fn73(item3, kawatanAutoPathWaypoints.LFINAL)

							if item5.Magnitude < 1 then
								createCorner(item3, item4)
								WaypointState.stopL()
								return
							end

							createInstance(item3, item4, item5.Unit, checkHumanoidPhysics(), arg)
						end
					end
				end)
			end

			WaypointState.startR = function()
				if item2 then
					item2:Disconnect()
				end

				calcVal3 = 1

				if getStealMode() then
					fn71()
				end

				item2 = safeConnect(RunService.Heartbeat, function(arg)
					if not WaypointState.R then
						return
					end
					local item3 = processInput()
					local item4 = createOrResetBillboard()
					if not item3 or not item4 then
						return
					end

					if getStealMode() then
						fn70(item3)
					end

					if not getStealMode() then
						local item5, item6 = updateCharacterState(calcVal3 == 1 and vector4 or vector5)
						if not item5 then
							return
						end

						if calcVal3 == 1 then
							calcVal3 = 2
							return
						end

						if item6 then
							item6.CFrame = CFrame.new(item6.Position) * CFrame.Angles(0, 3.141592653589793, 0)
						end

						executeAction()
						WaypointState.stopR()
						return
					end

					if calcVal3 == 1 then
						local item5 = fn73(item3, kawatanAutoPathWaypoints.R1)
						if item5.Magnitude < 1 then
							calcVal3 = 2
							return
						end
						createInstance(item3, item4, item5.Unit, checkAnchored(), arg)
					elseif calcVal3 == 2 then
						local item5 = fn73(item3, kawatanAutoPathWaypoints.REND)

						if item5.Magnitude < 1 then
							calcVal3 = 0
							createCorner(item3, item4)

							task.delay(0.2, function()
								if WaypointState.R then
									calcVal3 = 3
								end
							end)

							return
						end

						createInstance(item3, item4, item5.Unit, checkAnchored(), arg)
					else
						if calcVal3 == 0 then
							return
						end

						if calcVal3 == 3 then
							local item5 = fn73(item3, kawatanAutoPathWaypoints.R1)
							if item5.Magnitude < 1 then
								calcVal3 = 4
								return
							end
							createInstance(item3, item4, item5.Unit, checkHumanoidPhysics(), arg)
						elseif calcVal3 == 4 then
							local item5 = fn73(item3, kawatanAutoPathWaypoints.RFINAL)

							if item5.Magnitude < 1 then
								createCorner(item3, item4)
								WaypointState.stopR()
								return
							end

							createInstance(item3, item4, item5.Unit, checkHumanoidPhysics(), arg)
						end
					end
				end)
			end
		end

		cleanupSession()
	end
end

do
	local function cleanupSession(oshaSpeedControllerSession)
		_G._OSHASpeedControllerSession = oshaSpeedControllerSession

		safeConnect(RunService.PreSimulation, function(arg)
			if _G._OSHASpeedControllerSession ~= oshaSpeedControllerSession then
				return
			end
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not humanoidRootPart then
				return
			end

			if humanoid.Health <= 0 then
				clearMovers(humanoidRootPart)
				return
			end

			if CombatState.aimbot or CombatState.desync then
				clearMovers(humanoidRootPart)
				return
			end

			if WaypointState.L or WaypointState.R then
				clearMovers(humanoidRootPart)
				return
			end
			local state = humanoid:GetState()

			if humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
				vector = Vector3.new(0, 0, 0)
				clearMovers(humanoidRootPart)
				return
			end

			local moveDirection = humanoid.MoveDirection

			if moveDirection.Magnitude > 0 then
				vector = moveDirection
			end

			resetMovers(humanoid, humanoidRootPart, arg)
		end)
	end

	cleanupSession(tostring({}))
end

enabled = false
startAntiLag = nil
_G._AdaptInfJumpMode = "TAP"

do
	local function cleanupSession()
		local dataTable = { jumpPower = 37, maxJumpHeight = 25, roofClearance = 4.2 }
		local vX7InfinityJump = {}

		if _G.VX7InfinityJump and _G.VX7InfinityJump.Destroy then
			pcall(_G.VX7InfinityJump.Destroy)
		end

		vX7InfinityJump.Enabled = false
		local y = nil
		local calcVal1 = 0
		local calcVal2 = 0
		local stateFlag = true
		local calcVal3 = 0
		local checkFlag = false
		local itemTable = {}
		local obj = setmetatable({}, { __mode = "k" })

		local function getStealMode(arg)
			if not (arg and arg.Parent) then
				return false
			end
			local parent = arg.Parent
			if parent ~= localPlayer.Character then
				return false
			end
			local humanoid = parent:FindFirstChildOfClass("Humanoid")
			return humanoid ~= nil and humanoid.Health > 0
		end

		local function removeAttachments(arg, arg2)
			if not arg then
				return
			end
			local item1 = arg:FindFirstChild(arg2 .. "LinearVelocity")

			if item1 and item1:IsA("LinearVelocity") then
				obj[item1] = nil

				pcall(function()
					item1.Enabled = false
					item1.LineVelocity = 0
					item1:Destroy()
				end)
			end

			local item2 = arg:FindFirstChild(arg2 .. "Attachment")

			if item2 and item2:IsA("Attachment") then
				pcall(function()
					item2:Destroy()
				end)
			end
		end

		local function updateCharacterState(parent, arg)
			if not getStealMode(parent) then
				return nil
			end
			local name = arg .. "Attachment"
			local name2 = arg .. "LinearVelocity"
			local attachment = parent:FindFirstChild(name)

			if not (attachment and attachment:IsA("Attachment")) then
				attachment = Instance.new("Attachment")
				attachment.Name = name
				attachment.Parent = parent
			end

			local linearVelocity = parent:FindFirstChild(name2)

			if not (linearVelocity and linearVelocity:IsA("LinearVelocity")) then
				linearVelocity = Instance.new("LinearVelocity")
				linearVelocity.Name = name2
				linearVelocity.Parent = parent
			end

			linearVelocity.Attachment0 = attachment
			linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
			linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
			linearVelocity.LineDirection = Vector3.new(0, 1, 0)

			pcall(function()
				linearVelocity.ForceLimitsEnabled = false
			end)

			return linearVelocity
		end

		local function executeAction(arg, arg2, lineVelocity, arg3)
			local item1 = updateCharacterState(arg, arg2)
			if not item1 then
				return nil
			end
			local listTable = {}
			obj[item1] = listTable
			item1.LineVelocity = lineVelocity or 0
			item1.Enabled = true

			task.delay(arg3 or 0.1, function()
				if obj[item1] ~= listTable then
					return
				end
				obj[item1] = nil

				if item1.Parent then
					removeAttachments(arg, arg2)
				end
			end)

			return item1
		end

		local function disconnectHandler(arg)
			if not (arg and arg.Parent) then
				return Vector3.zero
			end

			local ok, result = pcall(function()
				return arg:GetVelocityAtPosition(arg.Position)
			end)

			return ok and result or Vector3.zero
		end

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		pcall(function()
			raycastParams.RespectCanCollide = true
		end)

		local function setupListener(arg, arg2)
			local character = localPlayer.Character
			if not (character and arg and arg.Parent) then
				return false
			end
			raycastParams.FilterDescendantsInstances = { character }
			local calcVal4 = math.max(disconnectHandler(arg).Y, 0)
			if calcVal4 <= 0.25 then
				return false
			end

			if not workspace:Raycast(arg.Position, Vector3.new(0, (dataTable.roofClearance or 4.2) + math.min(calcVal4 * math.clamp(arg2 or 0.016666666666666666, 0.005, 15), 0.9), 0), raycastParams) then
				return false
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.Jump = false
			end

			local assemblyLinearVelocity = arg.AssemblyLinearVelocity
			local matchFlag = arg:FindFirstChild("InfJumpLinearVelocity") ~= nil

			if assemblyLinearVelocity.Y > 0 and (matchFlag or assemblyLinearVelocity.Y > 60) then
				arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
			end

			calcVal1 = tick() + 0.12
			return true
		end

		local function processInput()
			return math.clamp(tonumber(dataTable.jumpPower) or 37, 35, 120)
		end

		local function createOrResetBillboard(arg)
			if not arg or not y then
				return false
			end
			return arg.Position.Y - y >= (tonumber(dataTable.maxJumpHeight) or 55)
		end

		local function checkAnchored(arg, arg2, arg3)
			if not (arg and arg2) or not getStealMode(arg) then
				return false
			end
			local currentTime = tick()
			if currentTime < calcVal1 then
				return false
			end

			if createOrResetBillboard(arg) then
				if arg:FindFirstChild("InfJumpLinearVelocity") then
					removeAttachments(arg, "InfJump")
				end

				return false
			end

			if arg2.FloorMaterial ~= Enum.Material.Air then
				stateFlag = true
				calcVal2 = 0
				y = arg.Position.Y
				return false
			end

			if stateFlag then
				stateFlag = false
				return false
			end

			if currentTime - calcVal2 < 0.08 then
				return false
			end

			if not arg3 and disconnectHandler(arg).Y > 32 then
				return false
			end
			calcVal2 = currentTime
			executeAction(arg, "InfJump", processInput(), 0.06)
			return true
		end

		local function checkHumanoidPhysics(arg)
			return arg.UserInputType.Name:sub(1, 7) == "Gamepad"
		end

		local function checkRagdoll()
			if itemTable.loop then
				return
			end

			itemTable.padDown = safeConnect(UserInputService.InputBegan, function(arg)
				if arg.KeyCode == Enum.KeyCode.ButtonA and checkHumanoidPhysics(arg) then
					checkFlag = true
				end
			end)

			itemTable.padUp = safeConnect(UserInputService.InputEnded, function(arg)
				if arg.KeyCode == Enum.KeyCode.ButtonA and checkHumanoidPhysics(arg) then
					checkFlag = false
				end
			end)

			itemTable.jumpReq = safeConnect(UserInputService.JumpRequest, function()
				if not enabled then
					return
				end
				local character = localPlayer.Character
				if not character then
					return
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart and humanoid then
					checkAnchored(humanoidRootPart, humanoid, true)
				end
			end)

			itemTable.loop = safeConnect(RunService.Heartbeat, function(arg)
				if not enabled then
					return
				end
				local character = localPlayer.Character
				if not character then
					return
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if not humanoid then
					return
				end
				setupListener(humanoidRootPart, arg)

				if humanoid.FloorMaterial ~= Enum.Material.Air then
					stateFlag = true
					calcVal2 = 0
					y = humanoidRootPart.Position.Y
					calcVal3 = 0

					if humanoidRootPart:FindFirstChild("InfJumpLinearVelocity") then
						removeAttachments(humanoidRootPart, "InfJump")
					end

					return
				end

				if stateFlag then
					stateFlag = false
				end

				local matchFlag = _G._AdaptInfJumpMode == "HOLD"

				if matchFlag then
					matchFlag = UserInputService:IsKeyDown(Enum.KeyCode.Space) or checkFlag or humanoid.Jump == true
				end

				local y2 = disconnectHandler(humanoidRootPart).Y

				if y2 < -120 then
					calcVal3 = 0
					executeAction(humanoidRootPart, "InfJump", -120, 0.08)
				elseif matchFlag then
					local extraFlag = tick() < calcVal1 or createOrResetBillboard(humanoidRootPart)

					if not extraFlag then
						if y2 < processInput() * 0.35 then
							calcVal3 += 1
						else
							calcVal3 = 0
						end

						if 4 <= calcVal3 then
							calcVal1 = tick() + 0.45
							calcVal3 = 0
							extraFlag = true
						end
					end

					if extraFlag then
						if item1:FindFirstChild("TouchInterest") then
							removeAttachments(item1, "ForceField")
						end
					else
						calcVal2 = tick()
						executeAction(item1, "InfJump", processInput(), 0.12)
					end
				else
					calcVal3 = 0

					if item1:FindFirstChild("TouchInterest") then
						removeAttachments(item1, "InfJump")
					end
				end
			end)
		end

		local function fn61()
			for _, loopItem in ipairs({ "padUp", "loop", "padDown", "end" }) do
				local item2 = itemTable[loopItem]

				if item2 then
					pcall(function()
						item2:Disconnect()
					end)
				end
			end

			local character = localPlayer.Character
			character = character and character:FindFirstChild("HumanoidRootPart")

			if character then
				removeAttachments(character, "InfJump")
			end

			itemTable = {}
			calcVal2 = 0
			stateFlag = true
			calcVal3 = 0
			calcVal1 = 0
			checkFlag = false
		end

		safeConnect(localPlayer.CharacterAdded, function()
			y = nil
			stateFlag = true
			calcVal2 = 0
			calcVal3 = 0
			calcVal1 = 0
			checkFlag = false
		end)

		checkRagdoll()

		startAntiLag = function(arg)
			enabled = arg and true or false
			vX7InfinityJump.Enabled = enabled

			if enabled then
				checkRagdoll()
			else
				fn61()
			end
		end

		vX7InfinityJump.SetEnabled = function(arg)
			startAntiLag(arg == true)
			return vX7InfinityJump.Enabled
		end

		vX7InfinityJump.GetEnabled = function()
			return vX7InfinityJump.Enabled == true
		end

		vX7InfinityJump.Toggle = function()
			vX7InfinityJump.SetEnabled(not vX7InfinityJump.Enabled)
			return vX7InfinityJump.Enabled
		end

		vX7InfinityJump.ClearVelocity = function()
			local character = localPlayer.Character
			removeAttachments(character and character:FindFirstChild("HumanoidRootPart"), "InfJump")
		end

		vX7InfinityJump.Destroy = function()
			startAntiLag(false)

			if _G.VX7InfinityJump == vX7InfinityJump then
				_G.VX7InfinityJump = nil
			end

			if _G._CandyInfinityJump == vX7InfinityJump then
				_G._CandyInfinityJump = nil
			end

			if _G.HoldInfJump and _G.HoldInfJump.cfg == dataTable then
				_G.HoldInfJump = nil
			end
		end

		_G.VX7InfinityJump = vX7InfinityJump
		_G._CandyInfinityJump = vX7InfinityJump
		_G.HoldInfJump = { cfg = dataTable, start = checkRagdoll, stop = fn61 }
	end

	cleanupSession()
end
end

do
local Lighting

do
	_G._AdaptInfJumpMode = "HOLD"
	startAntiLag(true)

	AntiDieState = {
		enabled = false,
		conn = nil,
		ResetCooldown = 0,
	}

	stopAntiLag = function()
		if AntiDieState.conn then
			return
		end

		AntiDieState.conn = safeConnect(RunService.Heartbeat, function()
			if not AntiDieState.enabled then
				return
			end
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

			if not (not humanoid or not humanoidRootPart or humanoid.Health <= 0) then
				local state = humanoid:GetState()
				local currentTime = tick()

				if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
					if currentTime - AntiDieState.ResetCooldown > 0.15 then
						AntiDieState.ResetCooldown = currentTime

						pcall(function()
							humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
							humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

							for _, descendant in ipairs(character:GetDescendants()) do
								if descendant:IsA("Motor6D") then
									descendant.Enabled = true
								end

								if descendant:IsA("Constraint") then
									descendant.Enabled = true
								end
							end

							workspace.CurrentCamera.CameraSubject = humanoid
							local playerModule = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")

							if playerModule then
								local module = require(playerModule:FindFirstChild("ControlModule"))

								if module then
									module:Enable()
								end
							end

							humanoid.AutoRotate = true
							humanoid.PlatformStand = false
							humanoid.Sit = false
						end)
					end
				end

				return
			end

			return
		end)
	end

	disableAntiDie = function()
		AntiDieState.enabled = false

		if AntiDieState.conn then
			AntiDieState.conn:Disconnect()
			AntiDieState.conn = nil
		end
	end

	safeConnect(localPlayer.CharacterAdded, function()
		if AntiDieState.enabled then
			task.wait(0.5)
			stopAntiLag()
		end
	end)

	_G._AdaptAntiBat = _G._AdaptAntiBat or { enabled = false, conn = nil }

	_G._AdaptStartAntiBat = function()
		if _G._AdaptAntiBat.conn then
			return
		end
		_G._AdaptAntiBat.enabled = true

		_G._AdaptAntiBat.conn = safeConnect(RunService.Heartbeat, function()
			if not _G._AdaptAntiBat.enabled then
				return
			end
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart or not humanoidRootPart.Parent then
				return
			end
			local vector2 = Vector3.new(humanoidRootPart.Velocity.X, 0, humanoidRootPart.Velocity.Z)
			humanoidRootPart.Velocity = Vector3.new(0, humanoidRootPart.Velocity.Y, 1000)
			RunService.RenderStepped:Wait()

			if humanoidRootPart and humanoidRootPart.Parent then
				humanoidRootPart.Velocity = Vector3.new(vector2.X, humanoidRootPart.Velocity.Y, vector2.Z)
			end
		end)
	end

	_G._AdaptStopAntiBat = function()
		_G._AdaptAntiBat.enabled = false

		if _G._AdaptAntiBat.conn then
			_G._AdaptAntiBat.conn:Disconnect()
			_G._AdaptAntiBat.conn = nil
		end
	end

	_G._AdaptUnwalk = _G._AdaptUnwalk or { enabled = false, savedAnimate = nil }

	_G._AdaptStartUnwalk = function()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			for _, animTrack in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function()
					animTrack:Stop()
				end)
			end
		end

		local animate = character:FindFirstChild("Animate")

		if animate then
			_G._AdaptUnwalk.savedAnimate = animate:Clone()
			animate:Destroy()
		end
	end

	_G._AdaptStopUnwalk = function()
		_G._AdaptUnwalk.enabled = false
		local character = localPlayer.Character

		if character and _G._AdaptUnwalk.savedAnimate then
			_G._AdaptUnwalk.savedAnimate:Clone().Parent = character
			_G._AdaptUnwalk.savedAnimate = nil
		end
	end

	_G._AdaptTryHard = _G._AdaptTryHard or { enabled = false, conn = nil, originalAnims = nil }

	_G._AdaptApplyTryHard = function()
		local dataTable = {
			idle1 = "rbxassetid://133806214992291",
			idle2 = "rbxassetid://94970088341563",
			walk = "rbxassetid://707897309",
			run = "rbxassetid://707861613",
			jump = "rbxassetid://116936326516985",
			fall = "rbxassetid://116936326516985",
			climb = "rbxassetid://116936326516985",
			swim = "rbxassetid://116936326516985",
			swimidle = "rbxassetid://116936326516985",
		}

		local function cleanupSession(arg)
			if not arg then
				return false
			end

			for _, item1 in pairs(dataTable) do
				if item1 == arg then
					return true
				end
			end

			return false
		end

		local function adaptTryHardSave(arg)
			local animate = arg:FindFirstChild("Animate")
			if not animate then
				return
			end

			local function getStealMode(arg2)
				return arg2 and arg2.AnimationId or nil
			end

			local originalAnims = {
				idle1 = getStealMode(animate.idle and animate.idle.Animation1),
				idle2 = getStealMode(animate.idle and animate.idle.Animation2),
				walk = getStealMode(animate.walk and animate.walk.WalkAnim),
				run = getStealMode(animate.run and animate.run.RunAnim),
				jump = getStealMode(animate.jump and animate.jump.JumpAnim),
				fall = getStealMode(animate.fall and animate.fall.FallAnim),
				climb = getStealMode(animate.climb and animate.climb.ClimbAnim),
				swim = getStealMode(animate.swim and animate.swim.Swim),
				swimidle = getStealMode(animate.swimidle and animate.swimidle.SwimIdle),
			}

			if not cleanupSession(originalAnims.walk) then
				_G._AdaptTryHard.originalAnims = originalAnims
			end
		end

		local function adaptTryHardApplyPack(arg)
			local animate = arg:FindFirstChild("Animate")
			if not animate then
				return
			end

			local function getStealMode(arg2, animationId)
				if arg2 then
					arg2.AnimationId = animationId
				end
			end

			getStealMode(animate.idle and animate.idle.Animation1, dataTable.idle1)
			getStealMode(animate.idle and animate.idle.Animation2, dataTable.idle2)
			getStealMode(animate.walk and animate.walk.WalkAnim, dataTable.walk)
			getStealMode(animate.run and animate.run.RunAnim, dataTable.run)
			getStealMode(animate.jump and animate.jump.JumpAnim, dataTable.jump)
			getStealMode(animate.fall and animate.fall.FallAnim, dataTable.fall)
			getStealMode(animate.climb and animate.climb.ClimbAnim, dataTable.climb)
			getStealMode(animate.swim and animate.swim.Swim, dataTable.swim)
			getStealMode(animate.swimidle and animate.swimidle.SwimIdle, dataTable.swimidle)
		end

		if _G._AdaptTryHard.conn then
			_G._AdaptTryHard.conn:Disconnect()
			_G._AdaptTryHard.conn = nil
		end

		local character = localPlayer.Character

		if character then
			adaptTryHardSave(character)
			adaptTryHardApplyPack(character)
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				for _, animTrack in ipairs(humanoid:GetPlayingAnimationTracks()) do
					pcall(function()
						animTrack:Stop(0)
					end)
				end

				pcall(function()
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
		end

		_G._AdaptTryHard.conn = safeConnect(RunService.Heartbeat, function()
			local character2 = localPlayer.Character

			if character2 then
				adaptTryHardApplyPack(character2)
			end
		end)

		_G._AdaptTryHardSave = adaptTryHardSave
		_G._AdaptTryHardApplyPack = adaptTryHardApplyPack
	end

	_G._AdaptStopTryHard = function()
		_G._AdaptTryHard.enabled = false

		if _G._AdaptTryHard.conn then
			_G._AdaptTryHard.conn:Disconnect()
			_G._AdaptTryHard.conn = nil
		end

		local character = localPlayer.Character
		local animate = character and character:FindFirstChild("Animate")
		local originalAnims = _G._AdaptTryHard.originalAnims

		if animate and originalAnims then
			local function cleanupSession(arg, animationId)
				if arg and animationId then
					arg.AnimationId = animationId
				end
			end

			cleanupSession(animate.idle and animate.idle.Animation1, originalAnims.idle1)
			cleanupSession(animate.idle and animate.idle.Animation2, originalAnims.idle2)
			cleanupSession(animate.walk and animate.walk.WalkAnim, originalAnims.walk)
			cleanupSession(animate.run and animate.run.RunAnim, originalAnims.run)
			cleanupSession(animate.jump and animate.jump.JumpAnim, originalAnims.jump)
			cleanupSession(animate.fall and animate.fall.FallAnim, originalAnims.fall)
			cleanupSession(animate.climb and animate.climb.ClimbAnim, originalAnims.climb)
			cleanupSession(animate.swim and animate.swim.Swim, originalAnims.swim)
			cleanupSession(animate.swimidle and animate.swimidle.SwimIdle, originalAnims.swimidle)
		end

		character = character and character:FindFirstChildOfClass("Humanoid")

		if character then
			for _, item1 in ipairs(character:GetPlayingAnimationTracks()) do
				pcall(function()
					item1:Stop(0)
				end)
			end
		end
	end

	_G._RaVeAnimationPackList = {
		"Off",
		"Unwalk",
		"Try Hard",
		"Adidas Sports",
		"Adidas Community",
		"Adidas Aura",
		"Amazon Unboxed",
		"Astronaut",
		"Bubbly",
		"Cartoon",
		"Catwalk Glam",
		"Dancing Through Life",
		"Elder",
		"Knight",
		"Levitate",
		"Mage",
		"NFL",
		"Ninja",
		"No Boundaries",
		"Pirate",
		"Robot",
		"Rthro",
		"Stylish",
		"Superhero",
		"Toy",
		"Vampire",
		"Werewolf",
		"Wicked Popular",
		"Zombie",
	}

	_G._RaVeAnimationPacks = {
		Zombie = {
			{ 616158929, 616160103 },
			616168032,
			616163682,
			616161997,
			616157476,
			616156119,
		},
		Knight = {
			{ 657595757, 657595757 },
			657552124,
			657564596,
			658409194,
			657600338,
			658360781,
		},
		Elder = {
			{ 845397899, 845397899 },
			845403856,
			845386501,
			845398858,
			845397673,
			845392764,
		},
		Astronaut = {
			{ 891621366, 891633237 },
			891636393,
			891667018,
			891627522,
			891627522,
			891609353,
		},
		Pirate = {
			{ 750781874, 750782770 },
			750785693,
			750783738,
			750782230,
			750780242,
			750779899,
		},
		Toy = {
			{ 782841498, 782845736 },
			782843345,
			782842708,
			782847020,
			782846423,
			782843869,
		},
		Vampire = {
			{ 1083445855, 1083445855 },
			1083473930,
			1083462077,
			1083455352,
			1083462077,
			1083439238,
		},
		Werewolf = {
			{ 1083195517, 1083195517 },
			1083178339,
			1083216690,
			1083218792,
			1083189019,
			1083182000,
		},
		Rthro = {
			{ 2510196951, 2510196951 },
			2510202577,
			2510198475,
			2510197830,
			2510202577,
			2510198475,
		},
		Stylish = {
			{ 616136790, 616136790 },
			616146177,
			616140816,
			616139451,
			616134815,
			616133594,
			616143378,
			616144772,
		},
		["Adidas Sports"] = {
			{ 18537376492, 18537371272 },
			616140816,
			18537384940,
			18537380791,
			18537367238,
			18537363391,
			18537389531,
			18537387180,
		},
		["Adidas Community"] = {
			{ 122257458498464, 102357151005774 },
			1083462077,
			1083463923,
			1083443587,
			98600215928904,
			88763136693023,
			133308483266208,
			109346520324160,
		},
		["Adidas Aura"] = {
			{ 1083445855, 1083445855 },
			83842218823011,
			118320322718866,
			109996626521204,
			1083455352,
			97824616490448,
			1083463923,
			94922130551805,
		},
		["Wicked Popular"] = {
			{ 1083445855, 1083445855 },
			92072849924640,
			72301599441680,
			104325245285198,
			121152442762481,
			131326830509784,
			99384245425157,
			113199415118199,
		},
		["Dancing Through Life"] = {
			{ 92849173543269, 132238900951109 },
			73718308412641,
			135515454877967,
			78508480717326,
			78147885297412,
			1083439238,
			110657013921774,
			129183123083281,
		},
		["Catwalk Glam"] = {
			{ 133806214992291, 94970088341563 },
			109168724482748,
			81024476153754,
			116936326516985,
			92294537340807,
			119377220967554,
			134591743181628,
			98854111361360,
		},
		["No Boundaries"] = {
			{ 18747067405, 18747063918 },
			18747074203,
			18747070484,
			18747069148,
			18747062535,
			98281136301627,
			18747073181,
			98281136301627,
		},
		["Amazon Unboxed"] = {
			{ 98281136301627, 98281136301627 },
			90478085024465,
			98281136301627,
			98281136301627,
			94788218468396,
			121145883950231,
			105962919001086,
			1083445855,
		},
		NFL = {
			{ 92080889861410, 74451233229259 },
			10921271924,
			117333533048078,
			119846112151352,
			129773241321032,
			134630013742019,
			10921257502,
			10921290167,
		},
		Mage = {
			{ 10921144709, 10921145797 },
			10921152678,
			10921290167,
			10921271924,
			10921285324,
			10921143404,
			10921150788,
			10921151661,
		},
		Superhero = {
			{ 10921290167, 10921290167 },
			10921298616,
			10921291831,
			10921294559,
			10921285324,
			10921286911,
			"rbxassetid://10921290167",
			10921272740,
		},
		Robot = {
			{ 616088211, 616089559 },
			616095330,
			616091570,
			1083462077,
			616087089,
			1083455352,
			1083439238,
			616094091,
		},
		Bubbly = {
			{ 910004836, 910009958 },
			910034870,
			910025107,
			910016857,
			1083443587,
			909997997,
			910028158,
			1083455352,
		},
		Cartoon = {
			{ 742637544, 742638445 },
			742640026,
			1083445855,
			742637942,
			742637151,
			1083455352,
			742639220,
			742639812,
		},
		Ninja = {
			{ 656117400, 656118341 },
			656121766,
			656121766,
			656117878,
			656115606,
			656117878,
			656119721,
			656121397,
		},
		Levitate = {
			{ 616006778, 616008087 },
			616012453,
			616013216,
			616008936,
			616005863,
			616003713,
			616011509,
			616012453,
		},
	}

	_G._RaVeAnimationOriginals = _G._RaVeAnimationOriginals or setmetatable({}, { __mode = "k" })

	_G._RaVeApplyAnimationPack = function(arg)
		local adaptAnimPack = arg or "Off"
		_G._AdaptAnimPack = adaptAnimPack
		local character = localPlayer.Character
		local animate = character and character:FindFirstChild("Animate")
		if not animate then
			return
		end

		local function cleanupSession(arg2, arg3)
			local item1 = animate:FindFirstChild(arg2)
			return item1 and item1:FindFirstChild(arg3)
		end

		local dataTable = {}
		local idle = cleanupSession("idle", "Animation")
		local idle2 = cleanupSession("idle", "Animation")
		local walkAnim = cleanupSession("walk", "WalkAnim")
		local run = cleanupSession("run", "RunAnim")
		local item1 = cleanupSession("jump", "JumpAnim")
		local fall = cleanupSession("fall", "FallAnim")
		local climbAnim = cleanupSession("climb", "ClimbAnim")
		dataTable[1] = idle
		dataTable[2] = idle2
		dataTable[3] = walkAnim
		dataTable[4] = run
		dataTable[5] = item1
		dataTable[6] = fall
		dataTable[7] = climbAnim

		if not _G._RaVeAnimationOriginals[character] then
			local itemTable = {}

			for i, item2 in ipairs(dataTable) do
				item2 = item2 and item2.AnimationId
				itemTable[i] = item2 or nil
			end

			_G._RaVeAnimationOriginals[character] = itemTable
		end

		local itemTable = _G._RaVeAnimationOriginals[character]
		local item2 = _G._RaVeAnimationPacks[adaptAnimPack]

		if item2 then
			itemTable = {
				"rbxassetid://" .. item2[1][1],
				"rbxassetid://" .. item2[1][2],
				"rbxassetid://" .. item2[2],
				"rbxassetid://" .. item2[3],
				"rbxassetid://" .. item2[4],
				"rbxassetid://" .. item2[5],
				"rbxassetid://" .. item2[6],
			}
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			for _, item3 in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function()
					item3:Stop(0)
				end)
			end
		end

		for i, item3 in ipairs(dataTable) do
			if item3 and itemTable and itemTable[i] then
				item3.AnimationId = itemTable[i]
			end
		end

		pcall(function()
			animate.Disabled = true
			task.wait()
			animate.Disabled = false
		end)
	end

	_G._RaVeApplySelectedAnimation = function(arg)
		local strName = arg or "Off"

		if _G._AdaptUnwalk and _G._AdaptUnwalk.enabled and strName ~= "Unwalk" then
			_G._AdaptUnwalk.enabled = false
			pcall(_G._AdaptStopUnwalk)
		end

		if _G._AdaptTryHard and _G._AdaptTryHard.enabled and strName ~= "TryHard" then
			_G._AdaptTryHard.enabled = false
			pcall(_G._AdaptStopTryHard)
		end

		if strName == "Unwalk" then
			_G._AdaptAnimPack = "Unwalk"

			if _G._AdaptUnwalk then
				_G._AdaptUnwalk.enabled = true
			end

			task.spawn(function()
				pcall(_G._AdaptStartUnwalk)
			end)

			return
		end

		if strName == "Try Hard" then
			_G._AdaptAnimPack = "TryHard"

			if _G._AdaptTryHard then
				_G._AdaptTryHard.enabled = true
			end

			task.spawn(function()
				pcall(_G._AdaptApplyTryHard)
			end)

			return
		end

		pcall(_G._RaVeApplyAnimationPack, strName)
	end

	configTable._collisionElapsed = 0

	safeConnect(RunService.Stepped, function(arg, arg2)
		configTable._collisionElapsed = configTable._collisionElapsed + arg2
		if configTable._collisionElapsed < 0.2 then
			return
		end
		configTable._collisionElapsed = 0

		for _, player in ipairs(service:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				for _, child in ipairs(player.Character:GetChildren()) do
					if child:IsA("BasePart") and child.CanCollide then
						child.CanCollide = false
					end
				end
			end
		end
	end)

	safeConnect(localPlayer.CharacterAdded, function(arg)
		if _G._AdaptUnwalk.enabled then
			task.wait(0.5)
			_G._AdaptStartUnwalk()
		end

		if _G._AdaptTryHard.enabled then
			task.wait(0.5)

			if _G._AdaptTryHardSave then
				_G._AdaptTryHardSave(arg)
			end

			if _G._AdaptTryHardApplyPack then
				_G._AdaptTryHardApplyPack(arg)
			end
		end

		if _G._AdaptAntiBat and _G._AdaptAntiBat.enabled then
			task.wait(0.3)
			_G._AdaptStopAntiBat()
			_G._AdaptStartAntiBat()
		end

		if _G._AdaptAnimPack and _G._AdaptAnimPack ~= "Off" and _G._AdaptAnimPack ~= "Unwalk" and _G._AdaptAnimPack ~= "Try Hard" then
			task.wait(0.05)
			pcall(_G._RaVeApplyAnimationPack, _G._AdaptAnimPack)
		end
	end)

	Lighting = game:GetService("Lighting")
	adaptStartAntiLag = nil
	adaptStopAntiLag = nil

	do
		local function cleanupSession()
			if _G._AdaptAntiLagDescConn then
				pcall(function()
					_G._AdaptAntiLagDescConn:Disconnect()
				end)
			end

			_G._AdaptAntiLagDescConn = nil
			_G._AdaptAntiLagScanToken = {}

			if type(_G._AdaptAntiLagHiddenObstacleVolumes) == "table" then
				for k in pairs(_G._AdaptAntiLagHiddenObstacleVolumes) do
					pcall(function()
						if k and k.Parent then
							k.LocalTransparencyModifier = 0
						end
					end)
				end
			end

			local dataTable = {}
			local itemTable = {}
			local stateFlag = false
			local connection = nil
			local listTable = {}
			local calcVal1 = 1
			local calcVal2 = 0
			local checkFlag = false
			local adaptAntiLagHiddenObstacleVolume = {}
			_G._AdaptAntiLagHiddenObstacleVolumes = adaptAntiLagHiddenObstacleVolume

			local function getStealMode(arg)
				if not arg:IsA("BasePart") then
					return false
				end
				local events = workspace:FindFirstChild("Events")
				if not events or not arg:IsDescendantOf(events) then
					return false
				end
				local parent = arg.Parent

				while parent and parent ~= events do
					if parent.Name == "ObstacleVolumes" then
						return true
					end
					parent = parent.Parent
				end

				return false
			end

			local function removeAttachments(arg)
				pcall(function()
					if arg:IsA("BasePart") then
						if getStealMode(arg) then
							if adaptAntiLagHiddenObstacleVolume[arg] == nil then
								adaptAntiLagHiddenObstacleVolume[arg] = arg.LocalTransparencyModifier
							end

							arg.LocalTransparencyModifier = 1
						end

						arg.Material = Enum.Material.Plastic
						arg.Reflectance = 0
						arg.CastShadow = false
					elseif arg:IsA("Decal") or arg:IsA("Texture") then
						arg.Transparency = 1
					elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") then
						arg.Enabled = false
					elseif arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") then
						arg.Enabled = false
					elseif arg:IsA("AnimationController") or arg:IsA("Animator") then
						for _, item1 in ipairs(arg:GetPlayingAnimationTracks()) do
							pcall(function()
								item1:Stop(0)
							end)
						end
					end
				end)
			end

			local function updateCharacterState(arg)
				if not stateFlag or not arg then
					return
				end
				calcVal2 += 1
				listTable[calcVal2] = arg
				if checkFlag then
					return
				end
				checkFlag = true
				local adaptAntiLagScanToken = _G._AdaptAntiLagScanToken

				task.spawn(function()
					while stateFlag and adaptAntiLagScanToken == _G._AdaptAntiLagScanToken and calcVal1 <= calcVal2 do
						for i = 1, math.min(80, calcVal2 - calcVal1 + 1) do
							local item1 = listTable[calcVal1]
							listTable[calcVal1] = nil
							calcVal1 += 1

							if item1 then
								removeAttachments(item1)
							end
						end

						task.wait()
					end

					if calcVal2 < calcVal1 then
						local item1 = 1
						local item2 = 0
						listTable = {}
						calcVal1 = item1
						calcVal2 = item2
					end

					checkFlag = false
				end)
			end

			_G._AdaptStartAntiLag = function()
				stateFlag = true
				local item1 = 0
				listTable = {}
				calcVal1 = 1
				calcVal2 = item1
				_G._AdaptAntiLagScanToken = {}
				local adaptAntiLagScanToken = _G._AdaptAntiLagScanToken
				dataTable.Brightness = dataTable.Brightness or Lighting.Brightness
				dataTable.FogEnd = dataTable.FogEnd or Lighting.FogEnd
				dataTable.FogStart = dataTable.FogStart or Lighting.FogStart
				dataTable.Diffuse = dataTable.Diffuse or Lighting.EnvironmentDiffuseScale
				dataTable.Specular = dataTable.Specular or Lighting.EnvironmentSpecularScale
				dataTable.Ambient = dataTable.Ambient or Lighting.Ambient
				Lighting.GlobalShadows = false
				Lighting.FogEnd = 1e10
				Lighting.FogStart = 0
				Lighting.EnvironmentDiffuseScale = 0
				Lighting.EnvironmentSpecularScale = 0
				Lighting.Brightness = 1.5
				Lighting.Ambient = Color3.fromRGB(60, 60, 60)

				pcall(function()
					local terrain = workspace.Terrain
					itemTable.Decoration = itemTable.Decoration ~= nil and itemTable.Decoration or terrain.Decoration
					itemTable.WaterWaveSize = itemTable.WaterWaveSize or terrain.WaterWaveSize
					itemTable.WaterWaveSpeed = itemTable.WaterWaveSpeed or terrain.WaterWaveSpeed
					itemTable.WaterReflectance = itemTable.WaterReflectance or terrain.WaterReflectance
					itemTable.WaterTransparency = itemTable.WaterTransparency or terrain.WaterTransparency
					terrain.Decoration = false
					terrain.WaterWaveSize = 0
					terrain.WaterWaveSpeed = 0
					terrain.WaterReflectance = 0
					terrain.WaterTransparency = 1
				end)

				pcall(function()
					local level01 = Enum.QualityLevel.Level01
					settings().Rendering.QualityLevel = level01
					local level012 = Enum.MeshPartDetailLevel.Level01
					settings().Rendering.MeshPartDetailLevel = level012
				end)

				for _, child in ipairs(Lighting:GetChildren()) do
					pcall(function()
						if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
							child.Enabled = false
						end
					end)
				end

				task.spawn(function()
					for i, descendant in ipairs(workspace:GetDescendants()) do
						if not stateFlag or adaptAntiLagScanToken ~= _G._AdaptAntiLagScanToken then
							return
						end
						removeAttachments(descendant)

						if i % 200 == 0 then
							task.wait()
						end
					end
				end)

				if connection then
					connection:Disconnect()
				end

				connection = workspace.DescendantAdded:Connect(function(descendant)
					if stateFlag then
						updateCharacterState(descendant)
					end
				end)

				_G._AdaptAntiLagDescConn = connection
			end

			_G._AdaptStopAntiLag = function()
				stateFlag = false
				_G._AdaptAntiLagScanToken = {}
				local item1 = 1
				listTable = {}
				calcVal1 = item1
				calcVal2 = 0

				if connection then
					connection:Disconnect()
					connection = nil
				end

				_G._AdaptAntiLagDescConn = nil

				for k, item2 in pairs(adaptAntiLagHiddenObstacleVolume) do
					pcall(function()
						if k and k.Parent then
							k.LocalTransparencyModifier = item2
						end
					end)
				end

				table.clear(adaptAntiLagHiddenObstacleVolume)

				pcall(function()
					Lighting.GlobalShadows = true

					if dataTable.Brightness ~= nil then
						Lighting.Brightness = dataTable.Brightness
					end

					if dataTable.FogEnd ~= nil then
						Lighting.FogEnd = dataTable.FogEnd
					end

					if dataTable.FogStart ~= nil then
						Lighting.FogStart = dataTable.FogStart
					end

					if dataTable.Diffuse ~= nil then
						Lighting.EnvironmentDiffuseScale = dataTable.Diffuse
					end

					if dataTable.Specular ~= nil then
						Lighting.EnvironmentSpecularScale = dataTable.Specular
					end

					if dataTable.Ambient ~= nil then
						Lighting.Ambient = dataTable.Ambient
					end

					local terrain = workspace.Terrain

					if itemTable.Decoration ~= nil then
						terrain.Decoration = itemTable.Decoration
					end

					if itemTable.WaterWaveSize ~= nil then
						terrain.WaterWaveSize = itemTable.WaterWaveSize
					end

					if itemTable.WaterWaveSpeed ~= nil then
						terrain.WaterWaveSpeed = itemTable.WaterWaveSpeed
					end

					if itemTable.WaterReflectance ~= nil then
						terrain.WaterReflectance = itemTable.WaterReflectance
					end

					if itemTable.WaterTransparency ~= nil then
						terrain.WaterTransparency = itemTable.WaterTransparency
					end

					for _, child in ipairs(Lighting:GetChildren()) do
						pcall(function()
							if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("Atmosphere") then
								child.Enabled = true
							end
						end)
					end
				end)
			end

			adaptStartAntiLag = _G._AdaptStartAntiLag
			adaptStopAntiLag = _G._AdaptStopAntiLag
		end

		cleanupSession()
	end
end

adaptStartVisualStrip = nil
adaptStopVisualStrip = nil

do
	local function cleanupSession()
		_G._AdaptStartVisualStrip = function()
			if _G._AdaptVisualStripOn then
				return
			end
			_G._AdaptVisualStripOn = true
			_G._AdaptVisualStripConnections = _G._AdaptVisualStripConnections or {}

			for _, adaptVisualStripConnection in ipairs(_G._AdaptVisualStripConnections) do
				pcall(function()
					adaptVisualStripConnection:Disconnect()
				end)
			end

			_G._AdaptVisualStripConnections = {}

			local function getStealMode(arg)
				local character = arg:FindFirstAncestorOfClass("Tool") and localPlayer.Character and arg:IsDescendantOf(localPlayer.Character)

				if character then
					local item1 = true
					character = localPlayer:GetAttribute("Stealing") == item1
				end

				if character then
					return true
				end

				for _, player in ipairs(service:GetPlayers()) do
					if player.Character and arg:IsDescendantOf(player.Character) then
						return false
					end
				end

				local stateFlag = false
				local checkFlag = false

				for i = 1, 5 do
					if not arg then
						break
					end
					local item1 = string.lower(arg.Name or "")
					if string.find(item1, "brainrot", 1, true) then
						return true
					end

					if item1 == "Enum.Material.Plastic" then
						checkFlag = true
					end

					if arg:IsA("Model") and (arg:FindFirstChildOfClass("AnimationController") or arg:FindFirstChildOfClass("Animator")) then
						stateFlag = true
					end

					arg = arg.Parent
				end

				return checkFlag and stateFlag
			end

			local function removeAttachments(arg)
				if not _G._AdaptVisualStripOn then
					return
				end

				pcall(function()
					local item1 = getStealMode(arg)

					if arg:IsA("BasePart") then
						if not item1 then
							arg.Material = Enum.Material.SmoothPlastic
							arg.MaterialVariant = ""
						end

						arg.Reflectance = 0
						arg.CastShadow = false
						local item2 = string.lower(arg.Name or "")

						if arg:FindFirstChildWhichIsA("Light", true) or string.find(item2, "light", 1, true) or string.find(item2, "lamp", 1, true) then
							arg.LocalTransparencyModifier = 1
						end

						if arg:FindFirstAncestorOfClass("Accessory") then
							arg.LocalTransparencyModifier = 1
						end
					elseif arg:IsA("Shirt") or arg:IsA("Pants") or arg:IsA("ShirtGraphic") or arg:IsA("CharacterMesh") then
						arg:Destroy()
					elseif arg:IsA("ParticleEmitter") then
						arg:Destroy()
					elseif arg:IsA("Decal") or arg:IsA("Texture") or arg:IsA("SurfaceAppearance") then
						if not item1 then
							arg:Destroy()
						end
					elseif arg:IsA("SpecialMesh") then
						if not item1 then
							arg.TextureId = ""
						end
					elseif arg:IsA("Animator") then
						local model = arg:FindFirstAncestorOfClass("Model")

						if not (model and service:GetPlayerFromCharacter(model)) then
							for _, item2 in ipairs(arg:GetPlayingAnimationTracks()) do
								pcall(function()
									item2:Stop(0)
									item2:AdjustSpeed(0)
								end)
							end

							table.insert(_G._AdaptVisualStripConnections, arg.AnimationPlayed:Connect(function(arg2)
								if _G._AdaptVisualStripOn then
									pcall(function()
										arg2:Stop(0)
										arg2:AdjustSpeed(0)
									end)
								end
							end))
						end
					elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") or arg:IsA("Highlight") then
						arg:Destroy()
					elseif arg:IsA("Light") then
						local basePart = arg:FindFirstAncestorWhichIsA("BasePart")

						if basePart then
							basePart.LocalTransparencyModifier = 1
						end

						arg:Destroy()
					elseif arg:IsA("ImageLabel") or arg:IsA("ImageButton") then
						arg.Image = ""
					elseif arg:IsA("Sky") or arg:IsA("Atmosphere") or arg:IsA("Clouds") or arg:IsA("PostEffect") then
						arg:Destroy()
					end
				end)
			end

			pcall(function()
				Lighting.GlobalShadows = false
				Lighting.EnvironmentDiffuseScale = 0
				Lighting.EnvironmentSpecularScale = 0
				Lighting.FogStart = 1e9
				Lighting.FogEnd = 1e9
				local terrain = workspace:FindFirstChildOfClass("Terrain")

				if terrain then
					terrain.Decoration = false
					terrain.WaterWaveSize = 0
					terrain.WaterWaveSpeed = 0
					terrain.WaterReflectance = 0
					terrain.WaterTransparency = 1
				end

				for _, descendant in ipairs(Lighting:GetDescendants()) do
					removeAttachments(descendant)
				end
			end)

			task.spawn(function()
				for i, descendant in ipairs(workspace:GetDescendants()) do
					if not _G._AdaptVisualStripOn then
						return
					end
					removeAttachments(descendant)

					if i % 200 == 0 then
						task.wait()
					end
				end
			end)

			table.insert(_G._AdaptVisualStripConnections, workspace.DescendantAdded:Connect(function(descendant)
				task.defer(removeAttachments, descendant)
			end))

			table.insert(_G._AdaptVisualStripConnections, Lighting.DescendantAdded:Connect(function(descendant)
				task.defer(removeAttachments, descendant)
			end))
		end

		_G._AdaptStopVisualStrip = function()
			_G._AdaptVisualStripOn = false
			local item1 = ipairs
			local adaptVisualStripConnections = _G._AdaptVisualStripConnections or {}

			for _, adaptVisualStripConnection in item1(adaptVisualStripConnections) do
				pcall(function()
					adaptVisualStripConnection:Disconnect()
				end)
			end

			_G._AdaptVisualStripConnections = {}
		end

		adaptStartVisualStrip = _G._AdaptStartVisualStrip
		adaptStopVisualStrip = _G._AdaptStopVisualStrip
	end

	cleanupSession()
end
end
end

do
_G._AdaptSkyOrder = {
"Off",
"Crimson",
"Neon City",
"Amethyst",
"Golden Hour",
"Frost Moon",
"Rose Gold",
"Abyss",
"Matrix",
"Candy",
"Retro Sun",
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

do
local item1 = _G
local adaptSkyPresets = _G._AdaptSkyPresets

if not adaptSkyPresets then
local function resetMovers()
	return {
		Off = { kind = "off" },
		Crimson = {
			clock = 20.5,
			brightness = 2.1,
			ambient = { 160, 50, 60 },
			outAmb = { 180, 60, 70 },
			sky = { stars = 2500, moon = 16, sun = 0, moonTex = true },
			atm = { dens = 0.55, color = { 232, 52, 68 }, decay = { 130, 20, 35 }, glare = 1.6, haze = 2.2 },
			clouds = { cover = 0.45, dens = 0.6, color = { 150, 40, 55 } },
		},
		["Neon City"] = {
			clock = 21.5,
			brightness = 2.3,
			ambient = { 110, 90, 170 },
			outAmb = { 120, 100, 180 },
			sky = { stars = 3000, moon = 14 },
			atm = {
				dens = 0.5,
				color = { 80, 240, 255 },
				decay = { 255, 40, 180 },
				glare = 2.4,
				haze = 2.6,
			},
			clouds = { cover = 0.35, dens = 0.55, color = { 130, 110, 220 } },
		},
		Amethyst = {
			clock = 19,
			brightness = 2.4,
			ambient = { 150, 110, 200 },
			outAmb = { 160, 120, 210 },
			sky = { stars = 1800, moon = 18, sun = 0 },
			atm = { dens = 0.45, color = { 170, 110, 255 }, decay = { 90, 50, 170 }, glare = 1.5, haze = 1.9 },
			clouds = { cover = 0.5, dens = 0.5, color = { 190, 150, 255 } },
		},
		["Golden Hour"] = {
			clock = 17.6,
			brightness = 1,
			ambient = { 150, 180, 110 },
			outAmb = { 240, 190, 120 },
			sky = { sun = 24, stars = 0, moon = 0 },
			atm = {
				dens = 0.42,
				color = { 255, 200, 80 },
				decay = { 255, 150, 60 },
				glare = 2.6,
				haze = 2,
			},
			clouds = { cover = 0.45, dens = 0.45, color = { 255, 225, 170 } },
		},
		["Frost Moon"] = {
			clock = 23.5,
			brightness = 1.9,
			ambient = { 140, 170, 210 },
			outAmb = { 150, 180, 220 },
			sky = { stars = 5500, moon = 26, sun = 0, moonTex = true },
			atm = {
				dens = 0.4,
				color = { 150, 200, 255 },
				decay = { 70, 110, 180 },
				glare = 0.5,
				haze = 1.4,
			},
		},
		["Rose Gold"] = {
			clock = 7,
			brightness = 2.9,
			ambient = { 230, 170, 150 },
			outAmb = { 240, 180, 160 },
			sky = { sun = 18, stars = 0, moon = 0 },
			atm = { dens = 0.38, color = { 255, 170, 150 }, decay = { 230, 130, 110 }, glare = 2, haze = 1.8 },
			clouds = { cover = 0.5, dens = 0.4, color = { 255, 215, 200 } },
		},
		Abyss = {
			clock = 0.5,
			brightness = 1.1,
			ambient = { 40, 50, 70 },
			outAmb = { 50, 60, 8 },
			sky = { stars = 9000, moon = 10, sun = 0 },
			atm = {
				dens = 0.7,
				color = { 10, 25, 50 },
				decay = { 0, 10, 10 },
				glare = 0.05,
				haze = 2.8,
			},
		},
		Matrix = {
			clock = 22,
			brightness = 1.8,
			ambient = { 70, 150, 80 },
			outAmb = { 80, 160, 80 },
			sky = { stars = 4000, moon = 12, sun = 0 },
			atm = {
				dens = 0.55,
				color = { 30, 220, 70 },
				decay = { 10, 110, 10 },
				glare = 1.2,
				haze = 2.4,
			},
			clouds = { cover = 0.55, dens = 0.7, color = { 40, 110, 55 } },
		},
		Candy = {
			clock = 12.5,
			brightness = 3.4,
			ambient = { 220, 170, 210 },
			outAmb = { 230, 180, 220 },
			sky = { sun = 12, stars = 0 },
			atm = {
				dens = 0.35,
				color = { 255, 170, 230 },
				decay = { 170, 200, 255 },
				glare = 1.8,
				haze = 1.7,
			},
			clouds = { cover = 0.65, dens = 0.45, color = { 255, 235, 250 } },
		},
		["Retro Sun"] = {
			clock = 18.2,
			brightness = 2.5,
			ambient = { 210, 110, 150 },
			outAmb = { 220, 120, 160 },
			sky = { sun = 30, stars = 800, moon = 0 },
			atm = {
				dens = 0.5,
				color = { 255, 90, 140 },
				decay = { 120, 40, 200 },
				glare = 3,
				haze = 2.6,
			},
			clouds = { cover = 0.3, dens = 0.5, color = { 255, 150, 190 } },
		},
		Night = {
			clock = 22,
			brightness = 2,
			ambient = { 110, 100, 130 },
			outAmb = { 120, 110, 140 },
			sky = { stars = 4000, moon = 4, sun = 0, moonTex = true },
			atm = {
				dens = 0.45,
				color = { 120, 60, 180 },
				decay = { 60, 20, 100 },
				glare = 0.5,
				haze = 1.2,
			},
		},
		Aurora = {
			clock = 14,
			brightness = 1,
			ambient = { 150, 120, 150 },
			outAmb = { 160, 130, 160 },
			atm = {
				dens = 0.55,
				color = { 255, 8, 200 },
				decay = { 255, 20, 150 },
				glare = 2.5,
				haze = 3,
			},
			clouds = { cover = 0.7, dens = 0.7, color = { 255, 240, 250 } },
		},
		Sunset = {
			clock = 17.2,
			brightness = 2.5,
			ambient = { 170, 120, 100 },
			outAmb = { 180, 130, 110 },
			sky = { stars = 0, sun = 25, moon = 0 },
			atm = {
				dens = 0.5,
				color = { 255, 130, 60 },
				decay = { 255, 80, 30 },
				glare = 2,
				haze = 2.5,
			},
			clouds = { cover = 0.55, dens = 0.55, color = { 255, 200, 140 } },
		},
		Galaxy = {
			clock = 0,
			brightness = 1.5,
			ambient = { 70, 60, 100 },
			outAmb = { 80, 70, 110 },
			sky = { stars = 10000, moon = 30, sun = 0 },
			atm = { dens = 0.15, color = { 40, 20, 80 }, decay = { 20, 10, 50 }, glare = 0.3, haze = 0.5 },
		},
		Cyber = {
			clock = 21,
			brightness = 2.2,
			ambient = { 90, 130, 170 },
			outAmb = { 100, 140, 180 },
			sky = { stars = 2000, moon = 12 },
			atm = {
				dens = 0.4,
				color = { 0, 200, 255 },
				decay = { 150, 0, 255 },
				glare = 2,
				haze = 2,
			},
			clouds = { cover = 0.4, dens = 0.6, color = { 100, 200, 255 } },
		},
		Sakura = {
			clock = 12,
			brightness = 3.5,
			ambient = { 170, 150, 160 },
			outAmb = { 180, 160, 170 },
			sky = { sun = 8 },
			atm = {
				dens = 0.1,
				color = { 255, 200, 220 },
				decay = { 255, 170, 200 },
				glare = 1,
				haze = 1.5,
			},
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
			atm = {
				dens = 0.4,
				color = { 80, 200, 140 },
				decay = { 40, 150, 80 },
				glare = 1.8,
				haze = 2.2,
			},
			clouds = { cover = 0.5, dens = 0.5, color = { 200, 255, 220 } },
		},
		Volcanic = {
			clock = 19,
			brightness = 2,
			ambient = { 180, 80, 40 },
			outAmb = { 200, 90, 50 },
			sky = { stars = 200, sun = 12, moon = 0 },
			atm = {
				dens = 0.75,
				color = { 255, 60, 0 },
				decay = { 180, 20, 0 },
				glare = 1,
				haze = 3.5,
			},
			clouds = { cover = 0.5, dens = 0.9, color = { 120, 40, 20 } },
		},
		Arctic = {
			clock = 9,
			brightness = 3.2,
			ambient = { 200, 220, 235 },
			outAmb = { 210, 230, 245 },
			sky = { sun = 10, stars = 0, moon = 0 },
			atm = {
				dens = 0.1,
				color = { 180, 220, 255 },
				decay = { 140, 200, 240 },
				glare = 1.5,
				haze = 1.8,
			},
			clouds = { cover = 0.7, dens = 0.6, color = { 250, 253, 255 } },
		},
		["Midnight Ocean"] = {
			clock = 1.5,
			brightness = 1.7,
			ambient = { 60, 90, 130 },
			outAmb = { 70, 100, 140 },
			sky = { stars = 6000, moon = 60, sun = 0, moonTex = true },
			atm = {
				dens = 0.5,
				color = { 20, 60, 140 },
				decay = { 5, 30, 90 },
				glare = 0.6,
				haze = 1.5,
			},
		},
		Vaporwave = {
			clock = 19.5,
			brightness = 2.4,
			ambient = { 180, 120, 200 },
			outAmb = { 190, 130, 210 },
			sky = { stars = 0, moon = 14 },
			atm = {
				dens = 0.45,
				color = { 255, 100, 220 },
				decay = { 120, 60, 255 },
				glare = 2.2,
				haze = 2.4,
			},
			clouds = { cover = 0.5, dens = 0.55, color = { 200, 150, 255 } },
		},
		Toxic = {
			clock = 13,
			brightness = 2.5,
			ambient = { 140, 180, 80 },
			outAmb = { 150, 190, 90 },
			atm = {
				dens = 0.55,
				color = { 100, 220, 40 },
				decay = { 60, 150, 20 },
				glare = 1.8,
				haze = 2.6,
			},
			clouds = { cover = 0.65, dens = 0.7, color = { 180, 255, 120 } },
		},
		["Solar Eclipse"] = {
			clock = 12,
			brightness = 0.9,
			ambient = { 50, 40, 60 },
			outAmb = { 60, 50, 70 },
			sky = { stars = 3500, sun = 22, moon = 0 },
			atm = {
				dens = 0.5,
				color = { 255, 140, 40 },
				decay = { 10, 20, 40 },
				glare = 2.8,
				haze = 1.8,
			},
		},
		Hellscape = {
			clock = 4,
			brightness = 1.8,
			ambient = { 200, 60, 30 },
			outAmb = { 220, 70, 40 },
			sky = { stars = 100, sun = 10, moon = 0 },
			atm = {
				dens = 0.85,
				color = { 255, 30, 0 },
				decay = { 120, 0, 0 },
				glare = 3.5,
				haze = 4,
			},
			clouds = { cover = 0.95, dens = 0.95, color = { 80, 20, 10 } },
		},
		Heaven = {
			clock = 12,
			brightness = 4,
			ambient = { 240, 235, 210 },
			outAmb = { 250, 245, 220 },
			sky = { sun = 16, moon = 0, stars = 0 },
			atm = {
				dens = 0.25,
				color = { 255, 250, 220 },
				decay = { 255, 240, 200 },
				glare = 3,
				haze = 1.5,
			},
			clouds = { cover = 0.85, dens = 0.5, color = { 255, 255, 255 } },
		},
		Storm = {
			clock = 15,
			brightness = 1.4,
			ambient = { 90, 90, 110 },
			outAmb = { 100, 100, 120 },
			sky = { stars = 0, sun = 6, moon = 0 },
			atm = { dens = 0.65, color = { 80, 90, 120 }, decay = { 40, 50, 80 }, glare = 0.5, haze = 3 },
			clouds = { cover = 0.95, dens = 0.95, color = { 60, 65, 80 } },
		},
		Sunrise = {
			clock = 6.2,
			brightness = 2.8,
			ambient = { 220, 180, 130 },
			outAmb = { 230, 190, 140 },
			sky = { sun = 22, stars = 0, moon = 0 },
			atm = {
				dens = 0.45,
				color = { 255, 180, 100 },
				decay = { 255, 140, 8 },
				glare = 2.4,
				haze = 2.2,
			},
			clouds = { cover = 0.4, dens = 0.4, color = { 255, 220, 180 } },
		},
		["Deep Space"] = {
			clock = 0,
			brightness = 1,
			ambient = { 10, 25, 50 },
			outAmb = { 40, 35, 60 },
			sky = { stars = 15000, moon = 0, sun = 0 },
			atm = {
				dens = 0.08,
				color = { 15, 5, 40 },
				decay = { 5, 0, 20 },
				glare = 0.05,
				haze = 0.1,
			},
		},
		["Lavender Dream"] = {
			clock = 18.5,
			brightness = 2.6,
			ambient = { 180, 160, 220 },
			outAmb = { 190, 170, 230 },
			sky = { stars = 800, moon = 16, sun = 0 },
			atm = {
				dens = 0.4,
				color = { 200, 160, 255 },
				decay = { 160, 120, 220 },
				glare = 1.4,
				haze = 1.8,
			},
			clouds = { cover = 0.55, dens = 0.5, color = { 220, 200, 255 } },
		},
		Inferno = {
			clock = 17.5,
			brightness = 2.2,
			ambient = { 220, 100, 40 },
			outAmb = { 235, 110, 50 },
			sky = { sun = 26, moon = 0, stars = 0 },
			atm = {
				dens = 0.6,
				color = { 255, 90, 20 },
				decay = { 200, 40, 0 },
				glare = 3,
				haze = 3.2,
			},
			clouds = { cover = 0.7, dens = 0.7, color = { 200, 80, 40 } },
		},
		["Mint Sky"] = {
			clock = 5,
			brightness = 3.2,
			ambient = { 180, 150, 210 },
			outAmb = { 190, 240, 220 },
			sky = { sun = 10 },
			atm = {
				dens = 0.32,
				color = { 150, 255, 210 },
				decay = { 100, 220, 180 },
				glare = 1.6,
				haze = 1.6,
			},
			clouds = { cover = 0.55, dens = 0.45, color = { 240, 255, 250 } },
		},
	}
end

adaptSkyPresets = resetMovers()
end

item1._AdaptSkyPresets = adaptSkyPresets
end
end

do
_G._AdaptSkyMode = _G._AdaptSkyMode or "Off"

_G._AdaptClearSky = _G._AdaptClearSky or function()
local item1 = ipairs
local Lighting = game:GetService("Lighting")

for _, child in item1(Lighting:GetChildren()) do
if child:GetAttribute("_AdaptSky") then
	pcall(function()
		child:Destroy()
	end)
end
end

local terrain = workspace:FindFirstChildOfClass("Terrain")

if terrain then
for _, child in ipairs(terrain:GetChildren()) do
	if child:GetAttribute("_AdaptSky") then
		pcall(function()
			child:Destroy()
		end)
	end
end
end
end

_G._AdaptStartSky = _G._AdaptStartSky or function(arg)
_G._AdaptClearSky()
local Lighting = game:GetService("Lighting")
local adaptSkyMode = arg or _G._AdaptSkyMode or "Off"
local item1 = _G._AdaptSkyPresets[adaptSkyMode]

local function resetMovers(arg2)
return Color3.fromRGB(arg2[1], arg2[2], arg2[3])
end

if not item1 or item1.kind == "off" then
pcall(function()
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	Lighting.FogColor = Color3.fromRGB(192, 192, 192)
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.GlobalShadows = true
	Lighting.Ambient = Color3.fromRGB(0, 0, 0)
	Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
end)

_G._AdaptSkyMode = "Off"
return
end

Lighting.FogEnd = 100000
Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(200, 200, 200)
Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
Lighting.GlobalShadows = true
Lighting.ClockTime = item1.clock or 14
Lighting.Brightness = item1.brightness or 2

if item1.outAmb then
Lighting.OutdoorAmbient = resetMovers(item1.outAmb)
end

if item1.ambient then
Lighting.Ambient = resetMovers(item1.ambient)
end

if item1.sky then
local sky = Instance.new("Sky")
sky:SetAttribute("_AdaptSky", true)

if item1.sky.stars then
	sky.StarCount = item1.sky.stars
end

if item1.sky.moon then
	sky.MoonAngularSize = item1.sky.moon
end

if item1.sky.sun then
	sky.SunAngularSize = item1.sky.sun
end

if item1.sky.moonTex then
	sky.MoonTextureId = "rbxasset://sky/moon.jpg"
end

sky.Parent = Lighting
end

if item1.atm then
local atmosphere = Instance.new("Atmosphere")
atmosphere:SetAttribute("_AdaptSky", true)
atmosphere.Density = item1.atm.dens or 0.3
atmosphere.Color = resetMovers(item1.atm.color)
atmosphere.Decay = resetMovers(item1.atm.decay)
atmosphere.Glare = item1.atm.glare or 1
atmosphere.Haze = item1.atm.haze or 1
atmosphere.Parent = Lighting
end

local terrain = workspace:FindFirstChildOfClass("Terrain")

if item1.clouds and terrain then
local clouds = Instance.new("Clouds")
clouds:SetAttribute("_AdaptSky", true)
clouds.Cover = item1.clouds.cover or 0.5
clouds.Density = item1.clouds.dens or 0.5
clouds.Color = resetMovers(item1.clouds.color)
clouds.Parent = terrain
end

_G._AdaptSkyMode = adaptSkyMode
end

_G._AdaptStopSky = _G._AdaptStopSky or function()
_G._AdaptClearSky()

pcall(function()
local Lighting = game:GetService("Lighting")
Lighting.ClockTime = 14
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
end)

_G._AdaptSkyMode = "Off"
end

do
local item1 = nil
local item2 = nil

enableAntiDie = function()
VisualState.stretch = true
if not workspace.CurrentCamera then
	return
end

if item1 then
	item1:Disconnect()
	item1 = nil
end

if item2 then
	item2:Disconnect()
	item2 = nil
end

item1 = safeConnect(RunService.RenderStepped, function()
	if not VisualState.stretch then
		if item1 then
			item1:Disconnect()
			item1 = nil
		end

		return
	end

	local currentCamera = workspace.CurrentCamera
	if not currentCamera then
		return
	end
	local calcVal1 = tonumber(VisualState.stretchValue) or 0.78

	pcall(function()
		currentCamera.CFrame = currentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, calcVal1, 0, 0, 0, 1)
	end)
end)
end

fn34 = function()
VisualState.stretch = false

if item1 then
	item1:Disconnect()
	item1 = nil
end

if item2 then
	item2:Disconnect()
	item2 = nil
end
end
end
end

do
local item1 = nil

fn35 = function()
if item1 then
item1:Disconnect()
end

item1 = safeConnect(RunService.RenderStepped, function()
if not VisualState.fov then
	return
end
local currentCamera = workspace.CurrentCamera

if currentCamera and currentCamera.FieldOfView ~= VisualState.fovVal then
	pcall(function()
		currentCamera.FieldOfView = VisualState.fovVal
	end)
end
end)
end

fn36 = function()
if item1 then
item1:Disconnect()
item1 = nil
end

pcall(function()
workspace.CurrentCamera.FieldOfView = 70
end)
end
end

_G._RaVeKorbloxMode = _G._RaVeKorbloxMode or "Off"

_G._RaVeKorbloxAssets = {
["Left Leg"] = {
id = "rbxassetid://139607673",
targetBodyPart = "LeftUpperLeg",
partsToHide = { "LeftUpperLeg", "LeftLowerLeg", "LeftFoot" },
scale = Vector3.new(1, 1, 1),
audio = "rbxassetid://87998522263554",
offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
},
["Right Leg"] = {
id = "rbxassetid://139607718",
targetBodyPart = "RightUpperLeg",
partsToHide = { "RightUpperLeg", "RightLowerLeg", "RightFoot" },
scale = Vector3.new(1, 1, 1),
audio = "rbxassetid://135315310485417",
offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
},
}

_G._RaVeClearKorblox = function()
local character = localPlayer.Character
if not character then
return
end

for _, loopItem in ipairs({ "Korblox_LeftLeg", "Korblox_RightLeg", "RaVeKorblox_Left", "RaVeKorblox_Right" }) do
local item2 = character:FindFirstChild(loopItem)

if item2 then
pcall(function()
	item2:Destroy()
end)
end
end

for _, loopItem in ipairs({ "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot" }) do
local item2 = character:FindFirstChild(loopItem)

if item2 and item2:IsA("BasePart") then
item2.Transparency = 0
item2.LocalTransparencyModifier = 0
end
end
end

_G._RaVeAttachKorblox = function(arg)
local item1 = _G._RaVeKorbloxAssets[arg]
local character = localPlayer.Character
if not item1 or not character then
return false, "No character"
end
local item2 = character:FindFirstChild(item1.targetBodyPart)
if not item2 then
return false, "Target part missing"
end
local item3 = character:FindFirstChild("Korblox_" .. arg:gsub("%s+", ""))

if item3 then
item3:Destroy()
end

for _, loopChild in ipairs(item1.partsToHide) do
local item5 = character:FindFirstChild(loopChild)

if item5 and item5:IsA("BasePart") then
item5.Transparency = 1
end
end

local ok, result = pcall(function()
return game:GetObjects(item1.id)
end)

if not ok or not result or #result == 0 then
return false, "Asset fetch failed"
end
local item4 = result[1]
item4.Name = "Korblox_" .. arg:gsub("%s+", "")
local isBasePart = item4:IsA("BasePart") and item4 or item4:FindFirstChildWhichIsA("BasePart", true)

if not isBasePart then
pcall(function()
item4:Destroy()
end)

return false, "No MeshPart in asset"
end

isBasePart.Size = isBasePart.Size * item1.scale
isBasePart.CanCollide = false
isBasePart.CanTouch = false
isBasePart.CanQuery = false
isBasePart.Massless = true
isBasePart.CFrame = item2.CFrame * item1.offset
local weldConstraint = Instance.new("WeldConstraint")
weldConstraint.Part0 = item2
weldConstraint.Part1 = isBasePart
weldConstraint.Parent = isBasePart
item4.Parent = character

if item1.audio then
local sound = Instance.new("Sound")
sound.SoundId = item1.audio
sound.Volume = 0.5
sound.Parent = isBasePart
sound:Play()
game:GetService("Debris"):AddItem(sound, 1)
end

return true, nil
end

_G._RaVeApplyKorblox = function(arg)
local raVeKorbloxMode = (arg == "Left" or arg == "Right" or arg == "Both") and arg or "Off"
_G._RaVeClearKorblox()
_G._RaVeKorbloxMode = raVeKorbloxMode

if raVeKorbloxMode == "Left" or raVeKorbloxMode == "Both" then
pcall(_G._RaVeAttachKorblox, "Left Leg")
end

if raVeKorbloxMode == "Right" or raVeKorbloxMode == "Both" then
pcall(_G._RaVeAttachKorblox, "Right Leg")
end
end

safeConnect(localPlayer.CharacterAdded, function(arg)
for i = 1, 10 do
task.wait(0.5)
if arg.Parent == nil then
return
end
local raVeKorbloxMode = _G._RaVeKorbloxMode
if raVeKorbloxMode == "Off" then
return
end
local stateFlag = (raVeKorbloxMode == "Left" or raVeKorbloxMode == "Both") and arg:FindFirstChild("Korblox_LeftLeg") == nil
local checkFlag = (raVeKorbloxMode == "Right" or raVeKorbloxMode == "Both") and arg:FindFirstChild("Korblox_RightLeg") == nil

if stateFlag or checkFlag then
pcall(_G._RaVeApplyKorblox, raVeKorbloxMode)
end
end
end)

fn37 = nil

kawatanSkinSets = {
PURPLE = {
hats = "1744060292,439945661,1125510,1029025",
hair = "",
headless = true,
korblox = "Right",
accessories = {
1744060292,
439945661,
1125510,
1029025,
11748356,
8465506143,
11444217173,
},
clothing = { 7424637509, 7689651773 },
},
BLUE = {
hats = "74891470",
hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842",
headless = true,
korblox = "Right",
accessories = {
74891470,
16630147,
6346833550,
6594911228,
6594919952,
6823338112,
7097747842,
},
clothing = { 18423061209, 18423154566 },
},
RED = {
hats = "215718515,439945661",
hair = "7183785281",
headless = true,
korblox = "Right",
accessories = { 215718515, 439945661, 7183785281 },
clothing = { 15998365201, 7689651773 },
},
BLACK = {
hats = "10159600649,439946249,17798262442,92482095662016",
hair = "139101716417676",
headless = true,
korblox = "Right",
accessories = {
10159600649,
439946249,
17798262442,
92482095662016,
139101716417676,
12490213797,
},
clothing = { 18766106994, 13925390578 },
},
GREEN = {
hats = "553970961,1744060292",
hair = "93268856876777",
headless = true,
korblox = "Right",
accessories = { 553970961, 1744060292, 93268856876777 },
clothing = { 9478068776, 6348682339 },
},
WHITE = {
hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427",
hair = "126447390530523",
headless = true,
korblox = "Right",
accessories = {
74891470,
215718515,
439945661,
1016143686,
1744060292,
10159600649,
89012651581593,
126447390530523,
},
clothing = { 88032876921227, 108259950755140 },
},
}

_G._KawatanSkinSets = kawatanSkinSets
_G._KawatanSkinSetOrder = { "PURPLE", "BLUE", "RED", "BLACK", "GREEN", "WHITE" }
_G._VlonESkinPreset = "ORIGINAL"

if not kawatanSkinSets[_G._KawatanSkinColor or ""] then
_G._KawatanSkinColor = nil
end

_G._KawatanSkinColor = _G._KawatanSkinColor or "PURPLE"

registerConnection = function()
return kawatanSkinSets[_G._KawatanSkinColor or "PURPLE"] or kawatanSkinSets.PURPLE
end

do
local dataTable = {}

kawatanApplySkinColor = function(arg)
local character = arg or localPlayer.Character
local item1 = dataTable[_G._KawatanSkinColor or "PURPLE"]
if not character or not item1 then
return
end
local stateFlag

for _, descendant in ipairs(character:GetDescendants()) do
if descendant:IsA("BasePart") then
	local parent = descendant

	while true do
		local checkFlag = parent and parent ~= character
		stateFlag = false

		if checkFlag then
			if parent:GetAttribute("_VlonESkin") then
				stateFlag = true
				break
			else
				parent = parent.Parent
				continue
			end
		end

		break
	end

	if stateFlag then
		descendant.Color = item1
	end
end
end
end
end

do
do
local stateFlag, calcVal1, strName, obj, obj2, resetMovers, clearMovers, cleanupSession, getStealMode, removeAttachments
local updateCharacterState

do
local executeAction

do
_G._KawatanApplySkinColor = kawatanApplySkinColor
stateFlag = false
calcVal1 = 0
strName = "Off"
obj = setmetatable({}, { __mode = "k" })
obj2 = setmetatable({}, { __mode = "k" })

resetMovers = function(arg)
	local num = tonumber(arg)
	if not num then
		return false
	end
	local item1 = registerConnection()
	local item2 = ipairs
	local accessories = item1.accessories or {}

	for _, accessory in item2(accessories) do
		if num == accessory then
			return true
		end
	end

	local item3 = ipairs
	local clothing = item1.clothing or {}

	for _, item4 in item3(clothing) do
		if num == item4 then
			return true
		end
	end

	for _, loopChild in ipairs({ item1.hats, item1.hair }) do
		local strChild = tostring(loopChild or "")

		for match in strChild:gmatch("%d+") do
			if num == tonumber(match) then
				return true
			end
		end
	end

	return false
end

executeAction = function(arg)
	pcall(function()
		arg:SetAttribute("_VlonESkin", true)
	end)

	return arg
end

clearMovers = function(arg)
	if not arg then
		return
	end

	for _, descendant in ipairs(arg:GetDescendants()) do
		if descendant:GetAttribute("_VlonESkin") then
			pcall(function()
				descendant:Destroy()
			end)
		end
	end
end

cleanupSession = function(arg)
	if not arg then
		return
	end

	for _, loopItem in ipairs({
		"UpperTorso",
		"LowerTorso",
		"LeftUpperArm",
		"LeftLowerArm",
		"LeftHand",
		"RightUpperArm",
		"RightLowerArm",
		"RightHand",
		"LeftUpperLeg",
		"LeftLowerLeg",
		"LeftFoot",
		"RightUpperLeg",
		"RightLowerLeg",
		"RightFoot",
	}) do
		local item2 = arg:FindFirstChild(loopItem)

		if item2 and item2:IsA("BasePart") then
			item2.Transparency = 0
			item2.LocalTransparencyModifier = 0
		end
	end
end

clearMovers(localPlayer.Character)
cleanupSession(localPlayer.Character)
_G._VlonEBodyType = _G._VlonEBodyType or "OFF"

do
	local function disconnectHandler()
		local dataTable = {
			"BodyDepthScale",
			"BodyHeightScale",
			"BodyWidthScale",
			"HeadScale",
			"BodyProportionScale",
			"BodyTypeScale",
		}

		local kawatanBodyTypes = {
			WOMAN = {
				bundle = 239,
				fallback = {
					Torso = 86499666,
					RightArm = 86499698,
					LeftArm = 86499716,
					LeftLeg = 86499753,
					RightLeg = 86499793,
				},
			},
			CLASSIC = {
				scale = {
					BodyTypeScale = 0,
					BodyProportionScale = 0,
					BodyHeightScale = 1,
					BodyWidthScale = 1,
					BodyDepthScale = 1,
					HeadScale = 1,
				},
			},
		}

		_G._KawatanBodyTypes = kawatanBodyTypes
		_G._KawatanBodyTypeOrder = { "OFF", "WOMAN", "CLASSIC" }
		local checkFlag = _G._VlonEBodyType ~= "OFF"

		if checkFlag then
			checkFlag = not kawatanBodyTypes[_G._VlonEBodyType or ""]
		end

		if checkFlag then
			_G._VlonEBodyType = "OFF"
		end

		local obj3 = setmetatable({}, { __mode = "k" })
		local obj4 = setmetatable({}, { __mode = "k" })
		local matchFlag = false
		local calcVal2 = 0

		local function kawatanCaptureBody(arg)
			local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return
			end

			if not obj3[arg] then
				local ok, result = pcall(function()
					return humanoid:GetAppliedDescription()
				end)

				if ok and result then
					obj3[arg] = result:Clone()
				end
			end

			if not obj4[arg] then
				local itemTable = {}

				for _, loopItem in ipairs(dataTable) do
					local item2 = humanoid:FindFirstChild(loopItem)

					if item2 then
						itemTable[loopItem] = item2.Value
					end
				end

				obj4[arg] = itemTable
			end
		end

		_G._KawatanCaptureBody = kawatanCaptureBody

		local function setupListener(arg)
			local item1 = obj3[arg]
			if item1 then
				return item1:Clone()
			end

			local ok, result = pcall(function()
				return service:GetHumanoidDescriptionFromUserId(localPlayer.UserId)
			end)

			if ok and result then
				return result
			end
			return nil
		end

		local function processInput(arg, arg2)
			local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
			if not humanoid or not arg2 then
				return
			end

			for k, item1 in pairs(arg2) do
				local item2 = humanoid:FindFirstChild(k)

				if item2 and item2:IsA("NumberValue") and item2.Value ~= item1 then
					pcall(function()
						item2.Value = item1
					end)
				end
			end
		end

		local function createOrResetBillboard(arg, arg2)
			calcVal2 += 1
			local item1 = calcVal2

			task.spawn(function()
				while item1 == calcVal2 and arg.Parent do
					processInput(arg, arg2)
					task.wait(0.5)
				end
			end)
		end

		local function checkAnchored(arg)
			calcVal2 += 1
			processInput(arg, obj4[arg])
		end

		local function checkHumanoidPhysics(arg)
			local itemTable = {}
			local item1 = pairs
			local fallback = arg.fallback or {}

			for k, item2 in item1(fallback) do
				itemTable[k] = item2
			end

			if not arg.bundle then
				return itemTable
			end

			local ok, result = pcall(function()
				return game:GetService("AssetService"):GetBundleDetailsAsync(arg.bundle)
			end)

			if ok and type(result) == "table" then
				local listTable = { Torso = true, RightArm = true, LeftArm = true, LeftLeg = true, RightLeg = true }
				local item2 = ipairs
				local items = result.Items or {}

				for _, item in item2(items) do
					local strTag = tostring(item.AssetType or ""):gsub("^Enum%.AvatarAssetType%.", "")

					if listTable[strTag] and item.Id then
						itemTable[strTag] = item.Id
					end
				end
			end

			return itemTable
		end

		local itemTable = {
			{ "UpperTorso", Enum.BodyPartR15.UpperTorso },
			{ "LowerTorso", Enum.BodyPartR15.LowerTorso },
			{ "LeftUpperLeg", Enum.BodyPartR15.LeftUpperLeg },
			{ "LeftLowerLeg", Enum.BodyPartR15.LeftLowerLeg },
			{ "LeftFoot", Enum.BodyPartR15.LeftFoot },
			{ "RightUpperLeg", Enum.BodyPartR15.RightUpperLeg },
			{ "RightLowerLeg", Enum.BodyPartR15.RightLowerLeg },
			{ "RightFoot", Enum.BodyPartR15.RightFoot },
		}

		local function checkRagdoll(arg)
			local ok, result = pcall(function()
				return service:CreateHumanoidModelFromDescriptionAsync(arg, Enum.HumanoidRigType.R15)
			end)

			if not ok or not result then
				ok, result = pcall(function()
					return service:CreateHumanoidModelFromDescription(arg, Enum.HumanoidRigType.R15)
				end)
			end

			if ok then
				return result
			end
			return nil
		end

		local function fn61(arg)
			task.defer(function()
				if _G._RaVeKorbloxMode ~= "Off" then
					pcall(_G._RaVeApplyKorblox, _G._RaVeKorbloxMode)
				end

				local extraFlag = _G._VlonEStandaloneHeadless == true

				if stateFlag then
					extraFlag = extraFlag or registerConnection().headless ~= false
				end

				if extraFlag and _G._KawatanSetHeadless then
					pcall(_G._KawatanSetHeadless, arg, true)
				end
			end)
		end

		local function createInstance(arg, arg2, arg3)
			local item1 = checkRagdoll(arg3)
			if not item1 then
				return false
			end

			for _, loopEntry in ipairs(itemTable) do
				local item3 = item1:FindFirstChild(loopEntry[1])

				if item3 and item3:IsA("BasePart") then
					local clone = item3:Clone()
					local extraFlag = false

					pcall(function()
						extraFlag = arg2:ReplaceBodyPartR15(loopEntry[2], clone)
					end)

					if not extraFlag and clone.Parent == nil then
						clone:Destroy()
					end
				end
			end

			item1:Destroy()
			fn61(arg)
			return true
		end

		local function createCorner(arg, arg2)
			if not matchFlag then
				return true
			end
			local item1 = setupListener(arg)
			if not item1 then
				return false
			end
			local item2 = createInstance(arg, arg2, item1)

			if item2 then
				matchFlag = false
			end

			return item2
		end

		local function createStroke(arg, arg2, arg3)
			local appliedDescription = nil

			pcall(function()
				appliedDescription = arg2:GetAppliedDescription()
			end)

			appliedDescription = appliedDescription or setupListener(arg)
			if not appliedDescription then
				return false
			end

			for k, item1 in pairs(checkHumanoidPhysics(arg3)) do
				pcall(function()
					appliedDescription[k] = item1
				end)
			end

			local item1 = createInstance(arg, arg2, appliedDescription)

			if item1 then
				matchFlag = true
			end

			return item1
		end

		fn37 = function(vlonEBodyType)
			if vlonEBodyType ~= "OFF" and not kawatanBodyTypes[vlonEBodyType] then
				vlonEBodyType = "OFF"
			end

			_G._VlonEBodyType = vlonEBodyType
			local character = localPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return false
			end
			kawatanCaptureBody(character)
			if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
				return false
			end
			checkAnchored(character)
			createCorner(character, humanoid)
			if vlonEBodyType == "OFF" then
				fn61(character)
				return true
			end
			local item1 = kawatanBodyTypes[vlonEBodyType]
			local extraFlag = true

			if item1.bundle then
				extraFlag = createStroke(character, humanoid, item1)
			end

			if item1.scale then
				processInput(character, item1.scale)
				createOrResetBillboard(character, item1.scale)
			end

			return extraFlag
		end

		if localPlayer.Character then
			kawatanCaptureBody(localPlayer.Character)
		end

		safeConnect(localPlayer.CharacterAdded, function(arg)
			matchFlag = false
			calcVal2 += 1
			arg:WaitForChild("Humanoid", 5)
			kawatanCaptureBody(arg)

			if _G._VlonEBodyType ~= "OFF" then
				task.wait(0.5)
				pcall(fn37, _G._VlonEBodyType)
			end
		end)

		task.spawn(function()
			task.wait(1.1)

			if _G._VlonEBodyType and _G._VlonEBodyType ~= "OFF" then
				pcall(fn37, _G._VlonEBodyType)
			end
		end)
	end

	disconnectHandler()
end
end

local disconnectHandler

do
local dataTable = {
	[8] = "HatAccessory",
	[41] = "HairAccessory",
	[42] = "FaceAccessory",
	[43] = "NeckAccessory",
	[44] = "ShouldersAccessory",
	[45] = "FrontAccessory",
	[46] = "BackAccessory",
	[47] = "WaistAccessory",
	[64] = "TShirtAccessory",
	[65] = "ShirtAccessory",
	[66] = "PantsAccessory",
	[67] = "JacketAccessory",
	[68] = "SweaterAccessory",
	[69] = "ShortsAccessory",
	[70] = "LeftShoeAccessory",
	[71] = "RightShoeAccessory",
	[72] = "DressSkirtAccessory",
}

disconnectHandler = function(parent, arg, arg2)
	if not arg2 or not arg2:IsA("Accessory") then
		return false
	end
	executeAction(arg2)

	pcall(function()
		arg:AddAccessory(arg2)
	end)

	if arg2.Parent ~= parent then
		arg2.Parent = parent
	end

	local handle = arg2:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then
		return arg2.Parent == parent
	end

	if handle:FindFirstChild("AccessoryWeld") then
		return true
	end
	local attachment = handle:FindFirstChildWhichIsA("Attachment")
	if not attachment then
		return arg2.Parent == parent
	end
	local item1 = nil

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("Attachment") and descendant.Name == attachment.Name and not descendant:IsDescendantOf(arg2) then
			item1 = descendant
			break
		else
			item1 = nil
		end
	end

	local parent2 = item1 and item1.Parent

	if parent2 and parent2:IsA("BasePart") then
		handle.Anchored = false
		handle.CanCollide = false
		handle.CanTouch = false
		handle.CanQuery = false
		handle.Massless = true
		handle.CFrame = parent2.CFrame * item1.CFrame * attachment.CFrame:Inverse()
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Name = "VlonEAccessoryWeld"
		weldConstraint.Part0 = parent2
		weldConstraint.Part1 = handle
		weldConstraint.Parent = handle
	end

	return true
end

getStealMode = function(arg, arg2)
	local item1 = registerConnection()
	local humanoidDescription = Instance.new("HumanoidDescription")
	humanoidDescription.HatAccessory = item1.hats or ""
	local item2 = nil

	if not pcall(function()
		item2 = service:CreateHumanoidModelFromDescription(humanoidDescription, Enum.HumanoidRigType.R15)
	end) or not item2 then
		pcall(function()
			item2 = service:CreateHumanoidModelFromDescriptionAsync(humanoidDescription, Enum.HumanoidRigType.R15)
		end)
	end

	humanoidDescription:Destroy()
	if not item2 then
		return false
	end
	local checkFlag = false

	for _, child in ipairs(item2:GetChildren()) do
		if child:IsA("Accessory") then
			if not arg:FindFirstChild(child.Name) then
				local clone = child:Clone()

				if disconnectHandler(arg, arg2, clone) then
					checkFlag = true
				end
			end
		end
	end

	item2:Destroy()
	return checkFlag
end

removeAttachments = function(arg, shirt)
	local ok, result = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(shirt, Enum.InfoType.Asset)
	end)

	if not ok or not result then
		return false
	end
	local num = tonumber(result.AssetTypeId)
	if num == 11 then
		arg.Shirt = shirt
		return true
	end

	if num == 12 then
		arg.Pants = shirt
		return true
	end

	if num == 2 then
		arg.GraphicTShirt = shirt
		return true
	end
	local item1 = dataTable[num]
	if not item1 then
		return false
	end
	local strTag = ""

	pcall(function()
		strTag = tostring(arg[item1] or "")
	end)

	pcall(function()
		arg[item1] = strTag == "" and tostring(shirt) or strTag .. "," .. tostring(shirt)
	end)

	return true
end
end

do
local function setupListener()
	local function processInput(arg, arg2)
		local item1 = tostring
		arg = arg or ""

		for match in item1(arg):gmatch("%d+") do
			if tonumber(match) == arg2 then
				return true
			end
		end

		return false
	end

	local dataTable = {
		"HatAccessory",
		"HairAccessory",
		"FaceAccessory",
		"NeckAccessory",
		"ShouldersAccessory",
		"FrontAccessory",
		"BackAccessory",
		"WaistAccessory",
		"ShirtAccessory",
		"PantsAccessory",
		"JacketAccessory",
		"SweaterAccessory",
		"ShortsAccessory",
		"TShirtAccessory",
		"DressSkirtAccessory",
	}

	_G._KawatanBuildSetDescription = function(arg)
		local item1 = kawatanSkinSets[arg]
		if not item1 then
			return nil
		end
		local appliedDescription = nil

		pcall(function()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				appliedDescription = humanoid:GetAppliedDescription()
			end
		end)

		local checkFlag = not appliedDescription

		if checkFlag then
			pcall(function()
				appliedDescription = service:GetHumanoidDescriptionFromUserId(localPlayer.UserId)
			end)
		end

		local clone = appliedDescription and appliedDescription:Clone() or Instance.new("HumanoidDescription")

		if checkFlag then
			local color = Color3.fromRGB(204, 142, 105)

			for _, loopEntry in ipairs({ "HeadColor", "TorsoColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor" }) do
				pcall(function()
					clone[loopEntry] = color
				end)
			end
		end

		for _, loopEntry in ipairs(dataTable) do
			pcall(function()
				clone[loopEntry] = ""
			end)
		end

		pcall(function()
			clone.Shirt = 0
		end)

		pcall(function()
			clone.Pants = 0
		end)

		pcall(function()
			clone.GraphicTShirt = 0
				return
		end)

		pcall(function()
			clone.HatAccessory = item1.hats or ""
			clone.HairAccessory = item1.hair or ""
		end)

		local item2 = ipairs
		local accessories = item1.accessories or {}

		for _, accessory in item2(accessories) do
			if not processInput(item1.hats, accessory) and not processInput(item1.hair, accessory) then
				pcall(removeAttachments, clone, accessory)
			end
		end

		local item3 = ipairs
		local clothing = item1.clothing or {}

		for _, item4 in item3(clothing) do
			pcall(removeAttachments, clone, item4)
		end

		return clone
	end
end

setupListener()
end

updateCharacterState = function(parent, arg, arg2)
for _, child in ipairs(parent:GetChildren()) do
	if child:IsA("Accessory") then
		local checkFlag = false

		pcall(function()
			checkFlag = tonumber(child.SourceAssetId) == tonumber(arg2)
		end)

		if checkFlag then
			return true
		end
	end
end

local ok, result = pcall(function()
	return game:GetObjects("rbxassetid://" .. tostring(arg2))
end)

if not ok or type(result) ~= "table" or #result == 0 then
	local item1 = nil

	local ok2 = pcall(function()
		item1 = game:GetService("InsertService"):LoadAsset(arg2)
	end)

	if not (ok2 and item1) then
		return false
	end
	result = { item1 }
end

local checkFlag = false

for _, loopItem in ipairs(result) do
	local dataTable = {}

	if loopItem:IsA("Accessory") or loopItem:IsA("Shirt") or loopItem:IsA("Pants") or loopItem:IsA("ShirtGraphic") then
		table.insert(dataTable, loopItem)
	else
		for _, descendant in ipairs(loopItem:GetDescendants()) do
			if descendant:IsA("Accessory") or descendant:IsA("Shirt") or descendant:IsA("Pants") or descendant:IsA("ShirtGraphic") then
				table.insert(dataTable, descendant)
			end
		end
	end

	for _, loopEntry in ipairs(dataTable) do
		local item3 = executeAction(loopEntry:Clone())

		if item3:IsA("Accessory") then
			disconnectHandler(parent, arg, item3)
		else
			for _, child in ipairs(parent:GetChildren()) do
				if child.ClassName == item3.ClassName then
					child:Destroy()
				end
			end

			item3.Parent = parent
		end

		checkFlag = true
	end

	pcall(function()
		item1:Destroy()
	end)
end

return checkFlag
end
end

do
local function kawatanSetHeadless(arg, arg2)
arg = arg and arg:FindFirstChild("Head")
if not arg then
	return
end
local transparency = arg2 and 1 or 0
arg.Transparency = transparency
arg.LocalTransparencyModifier = transparency

for _, child in ipairs(arg:GetChildren()) do
	if child:IsA("Decal") or child:IsA("Texture") or child:IsA("BasePart") then
		child.Transparency = transparency

		if child:IsA("BasePart") then
			child.LocalTransparencyModifier = transparency
		end
	end
end
end

_G._KawatanSetHeadless = kawatanSetHeadless

local function executeAction(arg)
local character = arg or localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid then
	return false
end
calcVal1 += 1
local item1 = calcVal1
cleanupSession(character)
clearMovers(character)
local appliedDescription = nil

pcall(function()
	appliedDescription = humanoid:GetAppliedDescription()
end)

if appliedDescription and not obj[character] then
	obj[character] = appliedDescription:Clone()
end

for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Accessory") or child:IsA("Accoutrement") then
		pcall(function()
			child:Destroy()
		end)
	end
end

if obj2[character] then
	obj2[character]:Disconnect()
end

obj2[character] = character.ChildAdded:Connect(function(child)
	local checkFlag = not stateFlag

	if not checkFlag then
		checkFlag = not (child:IsA("Accessory") or child:IsA("Accoutrement"))
	end

	if checkFlag then
		return
	end

	task.defer(function()
		if not child.Parent or child:GetAttribute("_VlonESkin") then
			return
		end
		local calcVal2 = 0

		pcall(function()
			calcVal2 = tonumber(child.SourceAssetId) or 0
		end)

		if not resetMovers(calcVal2) then
			pcall(function()
				child:Destroy()
			end)
		end
	end)
end)

local appliedDescription2 = nil

if appliedDescription then
	local clone = appliedDescription:Clone()

	for _, loopEntry in ipairs({
		"HatAccessory",
		"HairAccessory",
		"FaceAccessory",
		"NeckAccessory",
		"ShouldersAccessory",
		"FrontAccessory",
		"BackAccessory",
		"WaistAccessory",
		"ShirtAccessory",
		"PantsAccessory",
		"JacketAccessory",
		"SweaterAccessory",
		"ShortsAccessory",
		"TShirtAccessory",
		"DressSkirtAccessory",
	}) do
		pcall(function()
			clone[item2] = ""
		end)
	end

	pcall(function()
		clone.Shirt = 0
	end)

	pcall(function()
		clone.Pants = 0
	end)

	pcall(function()
		clone.GraphicTShirt = 0
	end)

	pcall(function()
		clone.HatAccessory = registerConnection().hats or ""
		clone.HairAccessory = registerConnection().hair or ""
	end)

	for _, item2 in ipairs(registerConnection().clothing) do
		pcall(removeAttachments, clone, item2)
	end

	pcall(function()
		humanoid:ApplyDescription(clone)
	end)
end

task.wait()
if not stateFlag or item1 ~= calcVal1 or not character.Parent then
	return false
end

pcall(function()
	appliedDescription2 = humanoid:GetAppliedDescription()
end)

for _, accessory in ipairs(registerConnection().accessories) do
	updateCharacterState(character, humanoid, accessory)
end

pcall(getStealMode, character, humanoid)

for _, item2 in ipairs(registerConnection().clothing) do
	updateCharacterState(character, humanoid, item2)
end

kawatanApplySkinColor(character)

task.delay(0.35, function()
	if character.Parent then
		kawatanApplySkinColor(character)
	end
end)

kawatanSetHeadless(character, registerConnection().headless ~= false or _G._VlonEStandaloneHeadless == true)
local korblox = registerConnection().korblox or "Right"

if _G._KawatanKorbloxUserSet then
	korblox = _G._RaVeKorbloxMode or korblox
end

_G._RaVeKorbloxMode = korblox
pcall(_G._RaVeApplyKorblox, korblox)

if _G._VlonEBodyType ~= "OFF" then
	task.defer(fn37, _G._VlonEBodyType)
end

return true
end

local function disconnectHandler(arg)
calcVal1 += 1
local character = arg or localPlayer.Character
if not character then
	return
end

if obj2[character] then
	obj2[character]:Disconnect()
	obj2[character] = nil
end

clearMovers(character)
cleanupSession(character)
pcall(_G._RaVeClearKorblox)
local item1 = _G
local item2 = strName
local raVeKorbloxMode

if strName then
	raVeKorbloxMode = item2
else
	raVeKorbloxMode = "Off"
end

item1._RaVeKorbloxMode = raVeKorbloxMode
local humanoid = character:FindFirstChildOfClass("Humanoid")
local item3 = obj[character]

if humanoid and item3 then
	if not (pcall(function()
		humanoid:ApplyDescriptionClientServer(item3:Clone())
	end) or pcall(function()
		humanoid:ApplyDescriptionReset(item3:Clone())
	end)) then
		pcall(function()
			humanoid:ApplyDescription(item3:Clone())
		end)
	end
end

local checkFlag = _G._VlonEStandaloneHeadless == true
kawatanSetHeadless(character, checkFlag)

if checkFlag then
	task.delay(0.25, function()
		kawatanSetHeadless(character, true)
	end)
end

if _G._RaVeKorbloxMode ~= "Off" then
	task.delay(0.2, function()
		pcall(_G._RaVeApplyKorblox, _G._RaVeKorbloxMode)
	end)
end
end

fn38 = function(arg)
if arg and not stateFlag then
	strName = _G._RaVeKorbloxMode or "Off"
end

stateFlag = arg and true or false

if stateFlag then
	task.spawn(executeAction, localPlayer.Character)
else
	disconnectHandler(localPlayer.Character)
end
end

safeConnect(localPlayer.CharacterAdded, function(arg)
if not stateFlag then
	return
end
arg:WaitForChild("Humanoid", 3)

if stateFlag then
	task.spawn(executeAction, arg)
end
end)
end
end

do
do
do
do
	local function resetMovers()
		local function clearMovers(arg, arg2, arg3)
			local instance = Instance.new(arg)
			local item1 = pairs
			arg2 = arg2 or {}

			for k, item2 in item1(arg2) do
				instance[k] = item2
			end

			local item2 = ipairs
			local dataTable = arg3 or {}

			for _, item3 in item2(dataTable) do
				item3.Parent = instance
			end

			return instance
		end

		local function cleanupSession(arg)
			return clearMovers("UICorner", { CornerRadius = UDim.new(0, arg) })
		end

		local function getStealMode(arg, arg2, arg3)
			return clearMovers("UIStroke", {
				Color = arg,
				Thickness = arg2 or 1,
				Transparency = arg3 or 0,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			})
		end

		local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local function removeAttachments(arg, arg2, arg3)
			if typeof(arg) ~= "Instance" then
				return
			end
			TweenService:Create(arg, arg2, arg3):Play()
		end

		local function updateCharacterState()
			local kawatanAccent = _G._KawatanAccent
			local accent

			if kawatanAccent then
				accent = kawatanAccent
			else
				accent = type(_G._RaVeTheme) == "table" and _G._RaVeTheme.accent
			end

			return accent or Color3.fromRGB(120, 160, 255)
		end

		local findFirstChild = localPlayer.FindFirstChild

		for _, item1 in ipairs({ game:GetService("CoreGui"), findFirstChild(localPlayer, "PlayerGui") }) do
			if item1 then
				local kawatanAvatarCatalog = item1:FindFirstChild("KawatanAvatarCatalog")

				if kawatanAvatarCatalog then
					pcall(function()
						kawatanAvatarCatalog:Destroy()
					end)
				end
			end
		end

		local item1 = clearMovers("ScreenGui", {
			Name = "KawatanAvatarCatalog",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 100001,
		})

		pcall(function()
			item1.Parent = gethui and gethui() or game:GetService("CoreGui")
		end)

		if not item1.Parent then
			item1.Parent = localPlayer:WaitForChild("PlayerGui")
		end

		item1.Archivable = false

		pcall(function()
			item1:SetAttribute("_VlonEProtected", true)
		end)

		local stateFlag = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
		local calcVal1 = stateFlag and 424 or 616
		local calcVal2 = stateFlag and 456 or 632
		local calcVal3 = stateFlag and 126 or 190
		local calcVal4 = stateFlag and 184 or 272
		local calcVal5 = stateFlag and 2 or 5
		local calcVal6 = stateFlag and 3 or 6

		local TextButton = clearMovers("TextButton", {
			Parent = item1,
			Name = "CatalogBackdrop",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 200,
		})

		local Frame = clearMovers("Frame", {
			Parent = TextButton,
			Name = "CatalogPanel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(calcVal1, calcVal2),
			BackgroundColor3 = Color3.fromRGB(8, 8, 12),
			BorderSizePixel = 0,
			Active = true,
			ZIndex = 201,
		}, { cleanupSession(14) })

		local item2 = getStealMode(updateCharacterState(), 1.2, 0.55)
		item2.Parent = Frame
		local UIScale = clearMovers("UIScale", { Parent = Frame, Scale = 1 })
		local color = Color3.fromRGB

		clearMovers("UIGradient", {
			Parent = Frame,
			Rotation = 35,
			Color = ColorSequence.new(Color3.fromRGB(8, 8, 12), color(13, 13, 19)),
		})

		local Frame2 = clearMovers("Frame", {
			Parent = Frame,
			BackgroundTransparency = 1,
			Active = true,
			Position = UDim2.fromOffset(14, 8),
			Size = UDim2.new(1, -28, 0, 46),
			ZIndex = 202,
		})

		clearMovers("TextLabel", {
			Parent = Frame2,
			Size = UDim2.new(1, -40, 0, 22),
			Position = UDim2.fromOffset(0, 2),
			BackgroundTransparency = 1,
			Text = "AVATAR CATALOG",
			Font = Enum.Font.GothamBlack,
			TextSize = stateFlag and 14 or 18,
			TextColor3 = Color3.fromRGB(245, 245, 250),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 203,
		})

		local TextLabel = clearMovers("TextLabel", {
			Parent = Frame2,
			Size = UDim2.new(1, -40, 0, 12),
			Position = UDim2.fromOffset(0, 60),
			BackgroundTransparency = 1,
			Text = "PICK A SET",
			Font = Enum.Font.GothamBold,
			TextSize = 9,
			TextColor3 = updateCharacterState(),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 203,
		})

		local TextButton2 = clearMovers("TextButton", {
			Parent = Frame2,
			Name = "CloseCatalog",
			BackgroundTransparency = 1,
			Text = "×",
			TextSize = 20,
			TextColor3 = Color3.fromRGB(245, 245, 250),
			Font = Enum.Font.GothamMedium,
			AutoButtonColor = false,
			Position = UDim2.new(1, -30, 0, 2),
			Size = UDim2.fromOffset(10, 10),
			ZIndex = 204,
		})

		local ScrollingFrame = clearMovers("ScrollingFrame", {
			Parent = Frame,
			Name = "SetCards",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 42),
			Size = UDim2.new(1, -28, 1, -72),
			CanvasSize = UDim2.new(),
			ScrollBarThickness = 0,
			ZIndex = 202,
		})

		clearMovers("UIPadding", {
			Parent = ScrollingFrame,
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
		})

		local UIGridLayout = clearMovers("UIGridLayout", {
			Parent = ScrollingFrame,
			CellSize = UDim2.fromOffset(calcVal3, calcVal4),
			CellPadding = UDim2.fromOffset(calcVal5, calcVal6),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIGridLayout.AbsoluteContentSize.Y + 12)
		end)

		local dataTable = {}
		local itemTable = {}
		local checkFlag = false
		local matchFlag = false
		local extraFlag = false
		local calcVal7 = 0
		local kawatanRefreshGalleryCards = nil

		local function executeAction(parent, arg)
			parent.PrimaryPart = parent:FindFirstChild("HumanoidRootPart") or parent.PrimaryPart

			for _, descendant in ipairs(parent:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.CastShadow = false
				elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
					descendant:Destroy()
				end
			end

			if arg.headless ~= false then
				local head = parent:FindFirstChild("Head")

				if head then
					head.Transparency = 1

					for _, child in ipairs(head:GetChildren()) do
						if child:IsA("Decal") or child:IsA("Texture") then
							child.Transparency = 1
						end
					end
				end
			end

			local korblox = arg.korblox or "Off"

			for _, loopElem in ipairs({ { "Left", "Left Leg" }, { "Right", "Right Leg" } }) do
				if korblox == "Both" or korblox == loopElem[1] then
					local raVeKorbloxAssets = _G._RaVeKorbloxAssets and _G._RaVeKorbloxAssets[loopElem[2]]
					local item4 = raVeKorbloxAssets and parent:FindFirstChild(raVeKorbloxAssets.targetBodyPart)

					if item4 then
						for _, loopSubChild in ipairs(raVeKorbloxAssets.partsToHide) do
							local item6 = parent:FindFirstChild(loopSubChild)

							if item6 and item6:IsA("BasePart") then
								item6.Transparency = 1
							end
						end

						local ok, result = pcall(function()
							return game:GetObjects(raVeKorbloxAssets.id)
						end)

						local item5 = ok and result and result[1]
						local isBasePart

						if item5 then
							isBasePart = item5:IsA("BasePart") and item5 or item5:FindFirstChildWhichIsA("BasePart", true)
						else
							isBasePart = item5
						end

						if isBasePart then
							isBasePart.CanCollide = false
							isBasePart.CastShadow = false
							isBasePart.CFrame = item4.CFrame * (raVeKorbloxAssets.offset or CFrame.new())
							local weldConstraint = Instance.new("WeldConstraint")
							weldConstraint.Part0 = item4
							weldConstraint.Part1 = isBasePart
							weldConstraint.Parent = isBasePart
							isBasePart.Parent = parent
						end

						if item5 and item5 ~= isBasePart and item5.Parent ~= parent then
							pcall(function()
								item5:Destroy()
							end)
						end
					end
				end
			end
		end

		local function disconnectHandler(arg)
			local item3 = arg:FindFirstChild("HumanoidRootPart")
			if not item3 then
				return
			end

			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("Accessory") then
					pcall(function()
						local handle = child:FindFirstChild("Handle")
						if not (handle and handle:IsA("BasePart")) then
							return
						end

						if (handle.Position - item3.Position).Magnitude <= 3 then
							return
						end
						local attachment = handle:FindFirstChildWhichIsA("Attachment")
						local item4 = nil

						if attachment then
							item4 = nil

							for _, descendant in ipairs(arg:GetDescendants()) do
								if descendant:IsA("Attachment") and descendant.Name == attachment.Name and not descendant:IsDescendantOf(child) then
									item4 = descendant
									break
								else
									item4 = nil
								end
							end
						end

						local parent = item4 and item4.Parent

						if parent and parent:IsA("BasePart") then
							handle.CFrame = parent.CFrame * item4.CFrame * attachment.CFrame:Inverse()
						else
							local head = arg:FindFirstChild("Head")

							if head then
								handle.CFrame = head.CFrame
							end
						end
					end)
				end
			end
		end

		local function setupListener(arg, arg2)
			task.spawn(function()
				local kawatanBuildSetDescription = _G._KawatanBuildSetDescription and _G._KawatanBuildSetDescription(arg)
				if not kawatanBuildSetDescription then
					arg2.loading.Text = "N/A"
					return
				end
				local item3 = nil

				if not pcall(function()
					item3 = service:CreateHumanoidModelFromDescriptionAsync(kawatanBuildSetDescription, Enum.HumanoidRigType.R15)
				end) or not item3 then
					pcall(function()
						item3 = service:CreateHumanoidModelFromDescription(kawatanBuildSetDescription, Enum.HumanoidRigType.R15)
					end)
				end

				pcall(function()
					kawatanBuildSetDescription:Destroy()
				end)

				local validFlag = not item3

				if not validFlag then
					validFlag = not (item3:FindFirstChild("UpperTorso") or item3:FindFirstChild("Torso"))
				end

				if validFlag then
					if item3 then
						pcall(function()
							item3:Destroy()
						end)
					end

					arg2.loading.Text = "N/A"
					return
				end

				pcall(executeAction, item3, _G._KawatanSkinSets[arg])
				item3.Parent = arg2.world
				task.wait()
				pcall(disconnectHandler, item3)

				for _, descendant in ipairs(item3:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.Anchored = true
					end
				end

				pcall(function()
					item3:PivotTo(CFrame.new())
				end)

				arg2.shot.rig = item3
				arg2.loading.Visible = false
			end)
		end

		local function processInput(kawatanSkinColor)
			_G._KawatanSkinColor = kawatanSkinColor

			if _G._KawatanOnSetPicked then
				pcall(_G._KawatanOnSetPicked, kawatanSkinColor)
			end

			if kawatanRefreshGalleryCards then
				kawatanRefreshGalleryCards()
			end
		end

		local item3 = ipairs
		local kawatanSkinSetOrder = _G._KawatanSkinSetOrder or {}

		for k, item4 in item3(kawatanSkinSetOrder) do
			local TextButton3 = clearMovers("TextButton", {
				Parent = ScrollingFrame,
				Name = item4 .. "Preview",
				LayoutOrder = k,
				BackgroundColor3 = Frame.BackgroundColor3,
				BackgroundTransparency = 0.08,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 203,
			}, { cleanupSession(5) })

			local item5 = getStealMode(Color3.fromRGB(70, 70, 80), 1, 0.18)
			item5.Parent = TextButton3

			local ViewportFrame = clearMovers("ViewportFrame", {
				Parent = TextButton3,
				Name = "AvatarPreview",
				BackgroundColor3 = Color3.fromRGB(11, 11, 14),
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(7, 7),
				Size = UDim2.new(1, -14, 1, -34),
				Ambient = Color3.fromRGB(255, 255, 255),
				LightColor = Color3.fromRGB(255, 255, 255),
				LightDirection = Vector3.new(-0.25, -0.5, -0.83),
				ZIndex = 204,
			}, { cleanupSession(3) })

			local WorldModel = clearMovers("WorldModel", { Parent = ViewportFrame })
			local vector = Vector3.new
			local item6 = 0

			local Camera = clearMovers("Camera", {
				Parent = ViewportFrame,
				FieldOfView = 42,
				CFrame = CFrame.lookAt(Vector3.new(0, 0.5, 9.6), vector(0, 0.5, item6)),
			})

			ViewportFrame.CurrentCamera = Camera

			local TextLabel2 = clearMovers("TextLabel", {
				Parent = ViewportFrame,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "LOADING",
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				TextColor3 = Color3.fromRGB(200, 205, 220),
				ZIndex = 205,
			})

			local item7 = clearMovers("TextLabel", {
				Parent = TextButton3,
				Position = UDim2.new(0, 3, 1, -24),
				Size = UDim2.new(1, -14, 0, 19),
				BackgroundTransparency = 1,
				Text = item4,
				Font = Enum.Font.GothamBlack,
				TextSize = 10,
				TextColor3 = Color3.fromRGB(150, 156, 172),
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 204,
			})

			local listTable = { camera = Camera, rig = nil, phase = k * 0.47, distance = 9.6, current = 9.6, target = 9.6 }
			itemTable[#itemTable + 1] = listTable

			TextButton3.Activated:Connect(function()
				processInput(item4)
			end)

			TextButton3.MouseEnter:Connect(function()
				listTable.target = listTable.distance * 0.86

				if _G._KawatanSkinColor ~= item4 then
					removeAttachments(item5, tweenInfo, { Color = Color3.fromRGB(140, 148, 172), Transparency = 0 })
					removeAttachments(item7, tweenInfo, { TextColor3 = Color3.fromRGB(245, 245, 250) })
				end
			end)

			TextButton3.MouseLeave:Connect(function()
				listTable.target = listTable.distance

				if kawatanRefreshGalleryCards then
					kawatanRefreshGalleryCards()
				end
			end)

			dataTable[item4] = {
				card = TextButton3,
				stroke = item5,
				viewport = ViewportFrame,
				world = WorldModel,
				camera = Camera,
				label = item7,
				loading = TextLabel2,
				shot = listTable,
			}
		end

		kawatanRefreshGalleryCards = function()
			local item4 = updateCharacterState()
			item2.Color = item4
			TextLabel.TextColor3 = item4

			for k, item5 in pairs(dataTable) do
				local validFlag = k == _G._KawatanSkinColor

				removeAttachments(item5.stroke, tweenInfo, {
					Color = validFlag and item4 or Color3.fromRGB(70, 70, 80),
					Thickness = validFlag and 2 or 1,
					Transparency = validFlag and 0 or 0.18,
				})

				removeAttachments(item5.label, tweenInfo, { TextColor3 = validFlag and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(150, 156, 172) })
			end
		end

		kawatanRefreshGalleryCards()
		_G._KawatanRefreshGalleryCards = kawatanRefreshGalleryCards
		local calcVal8 = 0

		safeConnect(RunService.RenderStepped, function(arg)
			if not matchFlag then
				return
			end
			calcVal8 += arg
			local calcVal9 = math.min(arg * 9, 1)

			for _, loopChild in ipairs(itemTable) do
				if loopChild.rig and loopChild.rig.Parent then
					local calcVal10 = math.cos(calcVal8 * 3 + loopChild.phase) * 0.035

					pcall(function()
						loopChild.rig:PivotTo(CFrame.new(0, calcVal10, 0) * CFrame.Angles(0, 3.1415926535897931 + calcVal8 * 0.8 + loopChild.phase, 0))
					end)
				end

				if loopChild.camera.Parent then
					loopChild.current = loopChild.current + (loopChild.target - loopChild.current) * calcVal9
					local vector = Vector3.new
					loopChild.camera.CFrame = CFrame.lookAt(Vector3.new(0, 0.5, loopChild.current), vector(0, 0.5, 0))
				end
			end
		end)

		local function kawatanCloseSkinGallery()
			matchFlag = false
			removeAttachments(TextButton, tweenInfo, { BackgroundTransparency = 1 })
			removeAttachments(UIScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.9 })

			task.delay(0.16, function()
				if not matchFlag then
					TextButton.Visible = false
				end
			end)
		end

		_G._KawatanOpenSkinGallery = function()
			matchFlag = true
			kawatanRefreshGalleryCards()

			for _, loopChild in ipairs(itemTable) do
				loopChild.target = loopChild.distance
			end

			TextButton.Visible = true
			TextButton.BackgroundTransparency = 1
			UIScale.Scale = 0.9
			removeAttachments(TextButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.42 })
			local listTable = { Scale = 1 }
			removeAttachments(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), listTable)
			if checkFlag then
				return
			end
			checkFlag = true

			task.spawn(function()
				local item4 = ipairs
				local kawatanSkinSetOrder2 = _G._KawatanSkinSetOrder or {}

				for _, item5 in item4(kawatanSkinSetOrder2) do
					local item6 = dataTable[item5]

					if item6 then
						setupListener(item5, item6)
					end

					task.wait(0.12)
				end
			end)
		end

		_G._KawatanCloseSkinGallery = kawatanCloseSkinGallery
		TextButton2.Activated:Connect(kawatanCloseSkinGallery)

		TextButton.MouseButton1Click:Connect(function()
			if extraFlag or os.clock() - calcVal7 < 0.25 then
				return
			end
			kawatanCloseSkinGallery()
		end)

		local item4 = nil
		local item5 = nil
		local item6 = nil

		Frame2.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local position = input.Position
			local position2 = Frame.Position
			extraFlag = true
			item4 = position
			item5 = position2
			item6 = input
		end)

		Frame2.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				item6 = input
			end
		end)

		safeConnect(UserInputService.InputChanged, function(arg)
			if not extraFlag then
				return
			end

			if arg ~= item6 and arg.UserInputType ~= Enum.UserInputType.MouseMovement then
				return
			end
			local calcVal9 = arg.Position - item4
			Frame.Position = UDim2.new(item5.X.Scale, item5.X.Offset + calcVal9.X, item5.Y.Scale, item5.Y.Offset + calcVal9.Y)
		end)

		safeConnect(UserInputService.InputEnded, function(arg)
			if not extraFlag then
				return
			end

			if arg == item6 or arg.UserInputType == Enum.UserInputType.MouseButton1 or arg.UserInputType == Enum.UserInputType.Touch then
				extraFlag = false
				item6 = nil
				calcVal7 = os.clock()
			end
		end)
	end

	resetMovers()
end
end

_G._adaptLoadedUnwalk = false
_G._adaptLoadedTryHard = false
statusFlag = false
HttpService = game:GetService("HttpService")

do
local strName = "VlonE_Mobile_Core_Global_" .. tostring(localPlayer.UserId) .. ".json"
local strTag = nil
local stateFlag = false

vlSave1 = function()
	if _G._RaVeSettingsReset then
		return false
	end

	if not _G._AdaptBootDone then
		return false
	end
	strTag = nil

	if not writefile then
		strTag = "no writefile"
		stateFlag = false
		return false
	end

	local dataTable = {
		NS = SpeedState.NS,
		CS = SpeedState.CS,
		LG_N = SpeedState.LG_N,
		LG_C = SpeedState.LG_C,
		family = SpeedState.family,
		carry = SpeedState.carry,
		aimSpd = CombatState.aimSpd,
		laggerAimSpd = CombatState.laggerAimSpd or 40,
		desyncTpDist = CombatState.desyncTpDist,
		desyncSwingDelay = CombatState.desyncSwingDelay,
		fovVal = VisualState.fovVal,
		stretchValue = VisualState.stretchValue or 0.78,
		darkLevel = _G._RaVeDarkLevel or 2,
		autoCarryVersion = _G._AdaptAutoCarryVersion or "V1",
		autoCarryV2Range = _G._AdaptAutoCarryV2Range or 15,
		autoTPHeight = PlotState.height,
		stealRadius = StealConfig.StealRadius,
		stealDuration = StealConfig.StealDuration,
	}

	dataTable.laggerKey = LaggerState.key and typeof(LaggerState.key) == "EnumItem" and LaggerState.key.Name or nil
	dataTable.lagPackets = LaggerState.packets
	dataTable.lagDelay = LaggerState.delay
	dataTable.skyMode = _G._AdaptSkyMode or "Off"
	dataTable.korbloxMode = _G._RaVeKorbloxMode or "Off"
	dataTable.animPack = _G._AdaptAnimPack or "Off"
	dataTable.keys = _G._AdaptKbSave or {}
	dataTable.ctrlKeys = _G._AdaptCtrlSave or {}
	dataTable.dropMode = dropMode
	dataTable.tpMode = tpMode
	dataTable.infJumpMode = _G._AdaptInfJumpMode or "TAP"
	dataTable.pathMode = _G._KawatanPathMode or "NORMAL"
	dataTable.batMode = _G._AdaptBatMode or "DEFAULT"
	dataTable.tpBatMode = _G._AdaptTpBatMode or "HIGH PING"
	dataTable.stealMode = _G._AdaptStealMode or "NORMAL"
	dataTable.autoMedusaRange = _G._AdaptAutoMedusaRange or 3
	dataTable.semiRange = (_G._KawatanStealRadii or {}).Semi or 10
	dataTable.autoSave = AutoState.auto
	dataTable.uiScale = _G._AdaptUIScale or 100
	dataTable.mobileScale = _G._KawatanMobileScale or 100
	dataTable.stealBarScale = _G._KawatanStealBarScale or 100
	dataTable.layoutMode = _G._KuRuLayoutMode or "SCROLL"
	dataTable.skinPreset = _G._VlonESkinPreset or "RED"
	dataTable.skinSet = _G._KawatanSkinColor or "PURPLE"
	dataTable.logoStyle = _G._KawatanLogoStyle or "ORIGINAL"
	dataTable.bodyType = _G._VlonEBodyType or "OFF"
	dataTable.identityMode = _G._KuRuIdentityMode or "PLAYER"
	dataTable.tabBackground = _G._KuRuTabBackground or "1"
	dataTable.contentBackground = _G._KuRuContentBackground or "1"
	dataTable.mainPos = _G._AdaptMainPos or nil
	dataTable.pbPos = _G._VlPbPos or nil
	dataTable.theme = _G._AdaptTheme or "ORIGINAL"
	dataTable.bgIdx = _G._AdaptBgIdx or 1
	dataTable.themeIdx = _G._AviceThemeIdx or 1
	dataTable.bgTint = _G._AdaptBgTint and true or false

	dataTable.on = {
		antiRag = AntiDieState.enabled or false,
		autoTP = PlotState.enabled or false,
		autoSteal = StealState.AutoSteal or false,
		batAimbot = CombatState.aimbot or false,
		desyncAimbot = CombatState.desync or false,
		autoLeft = WaypointState.L or false,
		autoRight = WaypointState.R or false,
		autoSwing = CombatState.swing or false,
		desyncSwing = CombatState.desyncSwing or false,
		mirrorTP = CombatState.tpMirror or false,
		fov = VisualState.fov or false,
		stretch = VisualState.stretch or false,
		antiLag = VisualState.antilag or false,
		potato = VisualState.potato or false,
		infJump = enabled or false,
		autoCarry = _G._AdaptAutoCarry or false,
		unwalk = _G._AdaptUnwalk and _G._AdaptUnwalk.enabled or false,
		tryHard = _G._AdaptTryHard and _G._AdaptTryHard.enabled or false,
		antiBat = _G._AdaptAntiBat and _G._AdaptAntiBat.enabled or false,
		batCounter = _G._VezyBatCounterOn or false,
		medusaCounter = statusFlag or false,
		esp = _G._AdaptESPEnabled or false,
		showTracer = _G._AdaptESPShowTracer == nil and true or _G._AdaptESPShowTracer,
		showBox = _G._AdaptESPShowBox == true,
		showHeader = _G._AdaptESPShowHeader ~= false,
		ragdollCountdown = _G._RaVeRagdollCountdown ~= false,
		logoMode = _G._RaVeLogoMode or false,
		panelBg = _G._RaVePanelBg or 0,
		tabsBg = _G._RaVeTabsBg or 0,
	}

	local ok, result = pcall(function()
		local json = HttpService:JSONEncode(dataTable)
		writefile(strName, json)
	end)

	if not ok then
		strTag = tostring(result):sub(1, 60)
		stateFlag = false
		return false
	end

	stateFlag = true

	if _G._AdaptShowSaveToast then
		task.spawn(_G._AdaptShowSaveToast)
	end

	return true
end

fn39 = function()
	if not readfile then
		return
	end

	if isfile and not isfile(strName) then
		return
	end
	local ok, result = pcall(readfile, strName)
	if not ok or not result or result == "" then
		return
	end

	local ok2, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" then
		return
	end

	if type(result2.NS) == "number" then
		SpeedState.NS = result2.NS
	end

	if type(result2.CS) == "number" then
		SpeedState.CS = result2.CS
	end

	if type(result2.LG_N) == "number" then
		SpeedState.LG_N = result2.LG_N
	end

	if type(result2.LG_C) == "number" then
		SpeedState.LG_C = result2.LG_C
	end

	if type(result2.carry) == "boolean" then
		SpeedState.carry = result2.carry
	end

	if result2.family == "Bedwars" or result2.family == "Duel" then
		SpeedState.family = result2.family
	end

	if type(result2.aimSpd) == "number" then
		CombatState.aimSpd = math.clamp(result2.aimSpd, 1, 200)
	end

	if type(result2.laggerAimSpd) == "number" then
		CombatState.laggerAimSpd = math.clamp(result2.laggerAimSpd, 1, 250)
	end

	if type(result2.desyncTpDist) == "number" then
		CombatState.desyncTpDist = math.clamp(result2.desyncTpDist, 1, 10)
	end

	if type(result2.desyncSwingDelay) == "number" then
		CombatState.desyncSwingDelay = math.clamp(result2.desyncSwingDelay, 0.03, 1)
	end

	if type(result2.fovVal) == "number" then
		VisualState.fovVal = result2.fovVal
	end

	if type(result2.stretchValue) == "number" then
		VisualState.stretchValue = math.clamp(result2.stretchValue, 0.3, 1.5)
	end

	if type(result2.darkLevel) == "number" then
		_G._RaVeDarkLevel = math.clamp(result2.darkLevel, 0.5, 6)
	end

	if result2.autoCarryVersion == "V1" or result2.autoCarryVersion == "V2" then
		_G._AdaptAutoCarryVersion = result2.autoCarryVersion
	end

	if type(result2.autoCarryV2Range) == "number" then
		_G._AdaptAutoCarryV2Range = result2.autoCarryV2Range
	end

	if type(result2.autoTPHeight) == "number" then
		PlotState.height = result2.autoTPHeight
	end

	if type(result2.stealRadius) == "number" then
		StealConfig.StealRadius = result2.stealRadius
	end

	if type(result2.laggerKey) == "string" and Enum.KeyCode[result2.laggerKey] then
		LaggerState.key = Enum.KeyCode[result2.laggerKey]
	end

	if type(result2.lagPackets) == "number" then
		LaggerState.packets = result2.lagPackets
	end

	if type(result2.lagDelay) == "number" then
		LaggerState.delay = result2.lagDelay
	end

	if type(result2.skyMode) == "string" then
		_G._AdaptSkyMode = result2.skyMode
	end

	if result2.korbloxMode == "Off" or result2.korbloxMode == "Left" or result2.korbloxMode == "Right" or result2.korbloxMode == "Both" then
		_G._RaVeKorbloxMode = result2.korbloxMode
	end

	if type(result2.animPack) == "string" then
		_G._AdaptAnimPack = result2.animPack
	end

	if type(result2.logoStyle) == "string" then
		_G._KawatanLogoStyle = result2.logoStyle
	end

	if type(result2.keys) == "table" then
		_G._AdaptKbSave = result2.keys
	end

	if type(result2.ctrlKeys) == "table" then
		_G._AdaptCtrlSave = result2.ctrlKeys
	end

	if result2.dropMode == "JUMP" or result2.dropMode == "STAND" then
		dropMode = result2.dropMode
	end

	if result2.tpMode == "half" or result2.tpMode == "full" then
		tpMode = result2.tpMode
	end

	if result2.infJumpMode == "TAP" or result2.infJumpMode == "HOLD" then
		_G._AdaptInfJumpMode = result2.infJumpMode
	end

	if result2.pathMode == "NORMAL" or result2.pathMode == "AUTO PLAY" then
		_G._KawatanPathMode = result2.pathMode
	end

	if result2.batMode == "DEFAULT" or result2.batMode == "BYPASS" then
		_G._AdaptBatMode = result2.batMode
	end

	if result2.tpBatMode == "SURE HIT" or result2.tpBatMode == "HIGH PING" then
		_G._AdaptTpBatMode = result2.tpBatMode
	end

	if result2.stealMode == "FAST" or result2.stealMode == "NORMAL" then
		_G._AdaptStealMode = result2.stealMode
	end

	if type(result2.autoMedusaRange) == "number" then
		_G._AdaptAutoMedusaRange = result2.autoMedusaRange
	end

	if type(result2.semiRange) == "number" and _G._KawatanStealRadii then
		_G._KawatanStealRadii.Semi = result2.semiRange
	end

	AutoState.auto = true

	if type(result2.uiScale) == "number" then
		_G._AdaptUIScale = result2.uiScale
	end

	if type(result2.mobileScale) == "number" then
		_G._KawatanMobileScale = result2.mobileScale
	end

	if type(result2.stealBarScale) == "number" then
		_G._KawatanStealBarScale = result2.stealBarScale

		if _G._KawatanStealBarSetScale then
			_G._KawatanStealBarSetScale(result2.stealBarScale)
		end
	end

	if result2.layoutMode == "SCROLL" or result2.layoutMode == "SIDE" or result2.layoutMode == "TOP" or result2.layoutMode == "BOTTOM" then
		_G._KuRuLayoutMode = result2.layoutMode
	end

	if result2.skinPreset == "RED" or result2.skinPreset == "BLUE" or result2.skinPreset == "PURPLE" or result2.skinPreset == "GALAXY" then
		_G._VlonESkinPreset = "RED"
	end

	local kawatanSkinSets2 = _G._KawatanSkinSets

	if kawatanSkinSets2 then
		kawatanSkinSets2 = _G._KawatanSkinSets[result2.skinSet or ""]
	end

	if kawatanSkinSets2 then
		_G._KawatanSkinColor = result2.skinSet
	end

	local checkFlag = result2.bodyType == "OFF"
	local item2

	if checkFlag then
		item2 = checkFlag
	else
		local kawatanBodyTypes = _G._KawatanBodyTypes

		if kawatanBodyTypes then
			item2 = _G._KawatanBodyTypes[result2.bodyType or ""]
		else
			item2 = kawatanBodyTypes
		end
	end

	if item2 then
		_G._VlonEBodyType = result2.bodyType
	end

	if result2.identityMode == "PLAYER" or result2.identityMode == "KURU" then
		_G._KuRuIdentityMode = result2.identityMode
	end

	if result2.tabBackground == "OFF" or result2.tabBackground == "1" or result2.tabBackground == "2" then
		_G._KuRuTabBackground = result2.tabBackground
	end

	if result2.contentBackground == "OFF" or result2.contentBackground == "1" or result2.contentBackground == "2" or result2.contentBackground == "3" or result2.contentBackground == "4" then
		_G._KuRuContentBackground = result2.contentBackground
	end

	if type(result2.mainPos) == "table" then
		_G._AdaptMainPos = result2.mainPos
	end

	if type(result2.pbPos) == "table" then
		_G._VlPbPos = result2.pbPos

		if _G._KawatanStealBarApplySavedPosition then
			pcall(_G._KawatanStealBarApplySavedPosition)
		end
	end

	if result2.theme == "AVICE" or result2.theme == "ORIGINAL" or result2.theme == "TOP" or result2.theme == "SCROLL" then
		_G._AdaptTheme = result2.theme
	end

	if type(result2.bgIdx) == "number" and result2.bgIdx >= 1 and result2.bgIdx <= 10 then
		_G._AdaptBgIdx = math.floor(result2.bgIdx)
	end

	if type(result2.themeIdx) == "number" and result2.themeIdx >= 1 and result2.themeIdx <= 1 then
		_G._AviceThemeIdx = math.floor(result2.themeIdx)
	end

	if type(result2.bgTint) == "boolean" then
		_G._AdaptBgTint = result2.bgTint
	end

	if type(result2.on) == "table" then
		local on = result2.on

		if type(on.antiRag) == "boolean" then
			_G._loadedOn_antiRag = on.antiRag
		end

		if type(on.autoTP) == "boolean" then
			_G._loadedOn_autoTP = on.autoTP
		end

		if type(on.autoSteal) == "boolean" then
			_G._loadedOn_autoSteal = on.autoSteal
		end

		if type(on.batAimbot) == "boolean" then
			_G._loadedOn_batAimbot = on.batAimbot
		end

		if type(on.desyncAimbot) == "boolean" then
			_G._loadedOn_desyncAimbot = on.desyncAimbot
		end

		if type(on.autoLeft) == "boolean" then
			_G._loadedOn_autoLeft = on.autoLeft
		end

		if type(on.autoRight) == "boolean" then
			_G._loadedOn_autoRight = on.autoRight
		end

		_G._loadedOn_autoLeft = false
		_G._loadedOn_autoRight = false
		_G._loadedOn_batAimbot = false
		_G._loadedOn_desyncAimbot = false

		if type(on.autoSwing) == "boolean" then
			_G._loadedOn_autoSwing = on.autoSwing
		end

		if type(on.desyncSwing) == "boolean" then
			_G._loadedOn_desyncSwing = on.desyncSwing
		end

		if type(on.mirrorTP) == "boolean" then
			CombatState.tpMirror = on.mirrorTP
		end

		if type(on.fov) == "boolean" then
			_G._loadedOn_fov = on.fov
		end

		if type(on.stretch) == "boolean" then
			_G._loadedOn_stretch = on.stretch
		end

		if type(on.antiLag) == "boolean" then
			_G._loadedOn_antiLag = on.antiLag
		end

		if type(on.potato) == "boolean" then
			_G._loadedOn_potato = on.potato
		end

		if type(on.infJump) == "boolean" then
			_G._loadedOn_infJump = on.infJump
		end

		if type(on.autoCarry) == "boolean" then
			_G._loadedOn_autoCarry = on.autoCarry
		end

		if type(on.unwalk) == "boolean" then
			_G._adaptLoadedUnwalk = on.unwalk
		end

		if type(on.tryHard) == "boolean" then
			_G._adaptLoadedTryHard = on.tryHard
		end

		if type(on.antiBat) == "boolean" then
			_G._adaptLoadedAntiBat = on.antiBat
		end

		if type(on.batCounter) == "boolean" then
			_G._loadedOn_batCounter = on.batCounter
		end

		if type(on.medusaCounter) == "boolean" then
			_G._loadedOn_medusa = on.medusaCounter
		end

		if type(on.esp) == "boolean" then
			_G._loadedOn_esp = on.esp
		end

		if type(on.showTracer) == "boolean" then
			_G._loadedOn_showTracer = on.showTracer
		end

		if type(on.showBox) == "boolean" then
			_G._AdaptESPShowBox = on.showBox
		end

		if type(on.ragdollCountdown) == "boolean" then
			_G._RaVeRagdollCountdown = on.ragdollCountdown
		end

		if type(on.logoMode) == "boolean" then
			_G._RaVeLogoMode = on.logoMode
		end

		if type(on.panelBg) == "number" then
			_G._RaVePanelBg = math.floor(on.panelBg)
		end

		if type(on.tabsBg) == "number" then
			_G._RaVeTabsBg = math.floor(on.tabsBg)
		end
	end

	if _G._AdaptSkyMode and _G._AdaptSkyMode ~= "Off" then
		task.spawn(function()
			task.wait(0.5)
			pcall(_G._AdaptStartSky, _G._AdaptSkyMode)
		end)
	end

	if _G._RaVeKorbloxMode and _G._RaVeKorbloxMode ~= "Off" then
		task.spawn(function()
			task.wait(0.7)
			pcall(_G._RaVeApplyKorblox, _G._RaVeKorbloxMode)
		end)
	end
end
end
end

_G._AdaptBootDone = false

task.delay(8, function()
_G._AdaptBootDone = true
end)

task.spawn(function()
while task.wait(5) do
if _G._AdaptBootDone then
	pcall(vlSave1)
end
end
end)

_G._AdaptAntiDie = _G._AdaptAntiDie or {
enabled = true,
conns = {},
lastSafeCFrame = nil,
lastSafePosition = nil,
dropActive = false,
invincibleUntil = 0,
}

_G._AdaptSetAntiDieDropActive = function(arg)
_G._AdaptAntiDie.dropActive = arg and true or false
end

_G._AdaptStartAntiDie = function()
local adaptAntiDie = _G._AdaptAntiDie
if adaptAntiDie.conns.heartbeat then
return
end
adaptAntiDie.enabled = true

local function resetMovers(arg)
if not arg then
	return
end
local maxHealth = arg.MaxHealth or 100

if arg.Health < maxHealth then
	arg.Health = maxHealth
end

local item1 = 0.5
adaptAntiDie.invincibleUntil = tick() + item1
end

local function clearMovers(arg)
local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
arg = arg and arg:FindFirstChild("HumanoidRootPart")
if not humanoid then
	return
end
humanoid.BreakJointsOnDeath = false

pcall(function()
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)

if arg then
	adaptAntiDie.lastSafeCFrame = arg.CFrame
	adaptAntiDie.lastSafePosition = arg.Position
end

if adaptAntiDie.conns.health then
	pcall(function()
		adaptAntiDie.conns.health:Disconnect()
	end)
end

adaptAntiDie.conns.health = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	if adaptAntiDie.enabled and humanoid.Health <= 0 then
		resetMovers(humanoid)

		pcall(function()
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end
end)
end

clearMovers(localPlayer.Character)

adaptAntiDie.conns.heartbeat = safeConnect(RunService.Heartbeat, function()
if not adaptAntiDie.enabled then
	return
end
local character = localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
character = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid then
	return
end
humanoid.BreakJointsOnDeath = false

pcall(function()
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)

if character and not adaptAntiDie.dropActive then
	local assemblyLinearVelocity = character.AssemblyLinearVelocity or Vector3.zero
	local assemblyAngularVelocity = character.AssemblyAngularVelocity or Vector3.zero
	local position = character.Position

	if assemblyLinearVelocity.Magnitude < 50 and position.Y > -30 and position.Y < 400 then
		adaptAntiDie.lastSafeCFrame = character.CFrame
		adaptAntiDie.lastSafePosition = position
	end

	local stateFlag = assemblyLinearVelocity.Magnitude >= 90

	if not stateFlag then
		local item1 = 8
		stateFlag = math.abs(assemblyLinearVelocity.Y) >= item1
	end

	if stateFlag or assemblyAngularVelocity.Magnitude >= 40 then
		character.AssemblyLinearVelocity = Vector3.zero
		character.AssemblyAngularVelocity = Vector3.zero

		if adaptAntiDie.lastSafePosition and (position - adaptAntiDie.lastSafePosition).Magnitude > 35 then
			character.CFrame = CFrame.new(adaptAntiDie.lastSafePosition, adaptAntiDie.lastSafePosition + character.CFrame.LookVector)
		end
	end

	if adaptAntiDie.lastSafeCFrame and (position.Y < -100 or position.Y > 900) then
		character.CFrame = adaptAntiDie.lastSafeCFrame
		character.AssemblyLinearVelocity = Vector3.zero
		character.AssemblyAngularVelocity = Vector3.zero
	end
end

local state = humanoid:GetState()

if humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
	pcall(function()
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end)
end

local stateFlag = humanoid.Health <= 25

if not stateFlag then
	local invincibleUntil = adaptAntiDie.invincibleUntil
	stateFlag = tick() < invincibleUntil

	if stateFlag then
		stateFlag = humanoid.Health < (humanoid.MaxHealth or 100)
	end
end

if stateFlag then
	resetMovers(humanoid)
end
end)

adaptAntiDie.conns.charAdded = safeConnect(localPlayer.CharacterAdded, function(arg)
task.wait(0.1)

if adaptAntiDie.enabled then
	clearMovers(arg)
	local humanoid = arg:FindFirstChildOfClass("Humanoid")

	if humanoid then
		resetMovers(humanoid)
	end
end
end)
end

_G._AdaptStopAntiDie = function()
local adaptAntiDie = _G._AdaptAntiDie
adaptAntiDie.enabled = false

for _, conn in pairs(adaptAntiDie.conns) do
pcall(function()
	conn:Disconnect()
end)
end

adaptAntiDie.conns = {}
adaptAntiDie.lastSafeCFrame = nil
adaptAntiDie.lastSafePosition = nil
end

_G._AceAntiFlingState = _G._AceAntiFlingState or {}

do
local aceAntiFlingState = _G._AceAntiFlingState

if aceAntiFlingState.connection then
pcall(function()
	aceAntiFlingState.connection:Disconnect()
end)

aceAntiFlingState.connection = nil
end

aceAntiFlingState.enabled = false
aceAntiFlingState.threshold = tonumber(aceAntiFlingState.threshold) or 80
aceAntiFlingState.spinThreshold = tonumber(aceAntiFlingState.spinThreshold) or 40

local function resetMovers()
local raVeLiveSpeed = _G._RaVeLiveSpeed
if type(raVeLiveSpeed) ~= "table" then
	return false
end
local num = tonumber(raVeLiveSpeed.t)
local num2 = tonumber(raVeLiveSpeed.v)
if not num or not num2 or num2 <= 0 then
	return false
end
return os.clock() - num <= 0.3
end

local function clearMovers(arg)
local name = arg.Name
if not (name:match("^Ace") or name:match("^Candy") or name:match("^RaVe") or name:match("^VlonE") or name:match("^Vilon") or name:match("^Kawatan") or name:match("^InfJump")) then
	return false
end

if arg:IsA("LinearVelocity") then
	if arg.Enabled == false then
		return false
	end

	local ok, result = pcall(function()
		local velocityConstraintMode = arg.VelocityConstraintMode
		if velocityConstraintMode == Enum.VelocityConstraintMode.Vector then
			return arg.VectorVelocity.Magnitude
		end

		if velocityConstraintMode == Enum.VelocityConstraintMode.Line then
			return math.abs(arg.LineVelocity)
		end
		return arg.PlaneVelocity.Magnitude
	end)

	if ok then
		ok = (tonumber(result) or 0) > 1
	end

	return ok
end

return arg:IsA("BodyVelocity") or arg:IsA("BodyPosition") or arg:IsA("BodyGyro") or arg:IsA("AlignPosition") or arg:IsA("AlignOrientation") or arg:IsA("AngularVelocity") or arg:IsA("VectorForce")
end

local function cleanupSession(arg)
for _, child in ipairs(arg:GetChildren()) do
	local ok, result = pcall(clearMovers, child)
	if ok and result then
		return true
	end
end

return false
end

aceAntiFlingState.connection = safeConnect(RunService.Heartbeat, function()
if not aceAntiFlingState.enabled then
	return
end
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
	return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
	humanoid = humanoid.Health <= 0 or humanoid.SeatPart
end

if humanoid then
	return
end

if JumpState.active or CombatState.aimbot or CombatState.desync or WaypointState.L or WaypointState.R then
	return
end

if resetMovers() or cleanupSession(humanoidRootPart) then
	return
end
local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity

if aceAntiFlingState.threshold < Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude then
	pcall(function()
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, assemblyLinearVelocity.Y, 0)
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end)

	return
end

if aceAntiFlingState.spinThreshold < humanoidRootPart.AssemblyAngularVelocity.Magnitude then
	pcall(function()
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end)
end
end)

_G._AceAntiFling = {
SetEnabled = function(arg)
	aceAntiFlingState.enabled = arg ~= false
end,
IsEnabled = function()
	return aceAntiFlingState.enabled == true
end,
SetThreshold = function(arg)
	aceAntiFlingState.threshold = tonumber(arg) or aceAntiFlingState.threshold
end,
SetSpinThreshold = function(arg)
	aceAntiFlingState.spinThreshold = tonumber(arg) or aceAntiFlingState.spinThreshold
end,
Destroy = function()
	if aceAntiFlingState.connection then
		aceAntiFlingState.connection:Disconnect()
		aceAntiFlingState.connection = nil
	end

	aceAntiFlingState.enabled = false
end,
}
end
end

do
local candyAntiDie, startAntiDie

do
_G._CandyAntiFling = _G._AceAntiFling

candyAntiDie = {
enabled = false,
loop = nil,
healthConn = nil,
charConn = nil,
lastHealTime = 0,
invincibleUntil = 0,
config = {
	healthThreshold = 50,
	invincibilityFrames = 0.75,
	fallDamageProtection = false,
	ragdollProtection = true,
	autoRevive = true,
},
}

do
local function resetMovers(arg)
	if not arg or not arg.Parent then
		return
	end
	local maxHealth = arg.MaxHealth or 100

	if maxHealth <= 0 or maxHealth == math.huge then
		maxHealth = 100
	end

	pcall(function()
		arg.Health = maxHealth

		if arg.MaxHealth < maxHealth then
			arg.MaxHealth = maxHealth
		end
	end)

	local invincibilityFrames = candyAntiDie.config.invincibilityFrames
	candyAntiDie.invincibleUntil = tick() + invincibilityFrames
	candyAntiDie.lastHealTime = tick()

	pcall(function()
		local parent = arg.Parent
		if not parent then
			return
		end

		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("NumberValue") then
				local strName = child.Name:lower()

				if strName:find("health") or strName:find("hp") or strName:find("life") then
					child.Value = maxHealth
				end
			end

			if child:IsA("BoolValue") and child.Name:lower():find("dead") then
				child.Value = false
			end
		end
	end)
end

local function clearMovers(arg, arg2)
	if not arg2 then
		return
	end

	if arg2.Health < (arg2.MaxHealth or 100) then
		resetMovers(arg2)
	end

	local invincibleUntil = candyAntiDie.invincibleUntil

	if tick() < invincibleUntil then
		if arg2.Health < (arg2.MaxHealth or 100) then
			arg2.Health = arg2.MaxHealth or 100
		end
	end

	if candyAntiDie.config.ragdollProtection then
		local state = arg2:GetState()

		if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then
			pcall(function()
				arg2:ChangeState(Enum.HumanoidStateType.GettingUp)
				arg2:ChangeState(Enum.HumanoidStateType.Running)
			end)

			resetMovers(arg2)

			if arg then
				pcall(function()
					arg.AssemblyAngularVelocity = Vector3.zero
				end)
			end
		end
	end

	if arg2.Health <= 0 then
		resetMovers(arg2)

		pcall(function()
			arg2:ChangeState(Enum.HumanoidStateType.GettingUp)
			arg2:ChangeState(Enum.HumanoidStateType.Running)
		end)

		if arg then
			pcall(function()
				arg.CFrame = CFrame.new(arg.Position + Vector3.new(0, 2, 0))
				arg.AssemblyLinearVelocity = Vector3.zero
			end)
		end
	end
end

local function cleanupSession()
	if not candyAntiDie.config.autoRevive then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoid then
		return
	end

	if humanoid.Health <= 0 then
		resetMovers(humanoid)

		pcall(function()
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end)

		if humanoidRootPart then
			pcall(function()
				humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, 1, 0))
				humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			end)
		end
	end
end

local function getStealMode(arg)
	if candyAntiDie.healthConn then
		candyAntiDie.healthConn:Disconnect()
		candyAntiDie.healthConn = nil
	end

	local item1 = arg and arg:FindFirstChildOfClass("Humanoid") or arg and arg:WaitForChild("Humanoid", 3)
	if not item1 then
		return
	end

	candyAntiDie.healthConn = item1:GetPropertyChangedSignal("Health"):Connect(function()
		if not candyAntiDie.enabled then
			return
		end

		if item1.Health < (item1.MaxHealth or 100) then
			resetMovers(item1)
		end

		if item1.Health <= 0 then
			cleanupSession()
		end
	end)

	if item1.Health < (item1.MaxHealth or 100) then
		resetMovers(item1)
	end
end

startAntiDie = function()
	if candyAntiDie.enabled and candyAntiDie.loop then
		return
	end
	candyAntiDie.enabled = true

	if candyAntiDie.loop then
		candyAntiDie.loop:Disconnect()
		candyAntiDie.loop = nil
	end

	if candyAntiDie.healthConn then
		candyAntiDie.healthConn:Disconnect()
		candyAntiDie.healthConn = nil
	end

	candyAntiDie.loop = safeConnect(RunService.Heartbeat, function()
		if not candyAntiDie.enabled then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoid then
			return
		end

		if humanoid.Health <= 0 then
			cleanupSession()
		elseif humanoid.Health <= candyAntiDie.config.healthThreshold then
			resetMovers(humanoid)
		elseif humanoid.Health < (humanoid.MaxHealth or 100) then
			resetMovers(humanoid)
		end

		clearMovers(item1, humanoid)
	end)

	if localPlayer.Character then
		getStealMode(localPlayer.Character)
	end

	if candyAntiDie.charConn then
		candyAntiDie.charConn:Disconnect()
		candyAntiDie.charConn = nil
	end

	candyAntiDie.charConn = safeConnect(localPlayer.CharacterAdded, function(arg)
		if not candyAntiDie.enabled then
			return
		end
		task.wait(0.05)
		getStealMode(arg)
		local item1 = arg:FindFirstChildOfClass("Humanoid")

		if item1 then
			resetMovers(item1)
		end
	end)
end
end
end

local function stopAntiDie()
candyAntiDie.enabled = false

if candyAntiDie.loop then
candyAntiDie.loop:Disconnect()
candyAntiDie.loop = nil
end

if candyAntiDie.healthConn then
candyAntiDie.healthConn:Disconnect()
candyAntiDie.healthConn = nil
end

if candyAntiDie.charConn then
candyAntiDie.charConn:Disconnect()
candyAntiDie.charConn = nil
end

pcall(function()
local character = localPlayer.Character
character = character and character:FindFirstChildOfClass("Humanoid")
if not character then
	return
end
character:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
character:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
character:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
character.BreakJointsOnDeath = true

if character.MaxHealth == math.huge or character.MaxHealth <= 0 then
	character.MaxHealth = 100
	character.Health = math.min(character.Health, 100)
end
end)
end

_G._CandyAntiDie = candyAntiDie
_G.startAntiDie = startAntiDie
_G.stopAntiDie = stopAntiDie
end
end

do
local aceInstaResetState, heartbeat, registerConnection, resetMovers, clearMovers

do
do
_G._AceInstaResetState = _G._AceInstaResetState or {}
aceInstaResetState = _G._AceInstaResetState

do
local item1 = ipairs
local connections = aceInstaResetState.connections or {}

for _, connection in item1(connections) do
pcall(function()
	connection:Disconnect()
end)
end
end
end

do
if aceInstaResetState.cameraConnection then
pcall(function()
aceInstaResetState.cameraConnection:Disconnect()
end)

aceInstaResetState.cameraConnection = nil
end

aceInstaResetState.connections = {}
aceInstaResetState.busy = false
aceInstaResetState.busyAt = 0
aceInstaResetState.queued = false
aceInstaResetState.queuedUntil = 0
aceInstaResetState.token = 0
aceInstaResetState.cameraHeld = false
aceInstaResetState.cameraHeldAt = 0
aceInstaResetState.wantDie = nil
aceInstaResetState.wantFling = nil
aceInstaResetState.suspendAt = nil
aceInstaResetState.speed = tonumber(aceInstaResetState.speed) or 1000000

do
local ok, result = pcall(function()
return RunService.PreSimulation
end)

heartbeat = ok and result or RunService.Heartbeat
end
end

registerConnection = function(arg)
table.insert(aceInstaResetState.connections, arg)
return arg
end

do
local function cleanupSession()
return _G._AceAntiFling or _G._CandyAntiFling
end

local function getStealMode()
local aceGuards = _G._AceGuards or _G._CandyGuards
if not aceGuards then
return
end

if aceGuards.tglDie and aceGuards.tglDie.SetVisual and type(aceGuards.DieIsOn) == "function" then
pcall(aceGuards.tglDie.SetVisual, aceGuards.DieIsOn())
end

if aceGuards.tglFling and aceGuards.tglFling.SetVisual and type(aceGuards.FlingIsOn) == "function" then
pcall(aceGuards.tglFling.SetVisual, aceGuards.FlingIsOn())
end
end

resetMovers = function()
local candyAntiDie = _G._CandyAntiDie

if candyAntiDie and candyAntiDie.enabled then
aceInstaResetState.wantDie = true

if type(_G.stopAntiDie) == "function" then
	pcall(_G.stopAntiDie)
else
	candyAntiDie.enabled = false
end
end

local item1 = cleanupSession()

if item1 and type(item1.IsEnabled) == "function" and item1.IsEnabled() then
aceInstaResetState.wantFling = true
pcall(item1.SetEnabled, false)
end

if _G._AdaptAntiDie and _G._AdaptAntiDie.enabled and type(_G._AdaptStopAntiDie) == "function" then
pcall(_G._AdaptStopAntiDie)
end

if _G._CandyAntiVoid and type(_G._CandyAntiVoid.Suspend) == "function" then
pcall(_G._CandyAntiVoid.Suspend, 6)
end

aceInstaResetState.suspendAt = os.clock()
getStealMode()
return { antiDie = aceInstaResetState.wantDie == true, antiFling = aceInstaResetState.wantFling == true }
end

clearMovers = function(arg)
local stateFlag = aceInstaResetState.wantDie == true or arg and arg.antiDie == true or false
arg = aceInstaResetState.wantFling == true or arg and arg.antiFling == true or false
aceInstaResetState.wantDie = nil
aceInstaResetState.wantFling = nil
aceInstaResetState.suspendAt = nil
local item1 = cleanupSession()

if arg and item1 and type(item1.SetEnabled) == "function" then
pcall(item1.SetEnabled, true)
end

if stateFlag then
if type(_G.startAntiDie) == "function" then
	pcall(_G.startAntiDie)
elseif _G._CandyAntiDie then
	_G._CandyAntiDie.enabled = true
end
end

getStealMode()
end
end
end

local aceInstaReset

do
do
local function cleanupSession(arg)
local currentCamera = workspace.CurrentCamera
if not currentCamera then
return
end
local cameraHeld = aceInstaResetState.cameraHeld

if cameraHeld then
cameraHeld = os.clock() - (aceInstaResetState.cameraHeldAt or 0) < 5
end

if cameraHeld then
return
end
aceInstaResetState.cameraHeld = true
aceInstaResetState.cameraHeldAt = os.clock()
local cFrame = currentCamera.CFrame
local focus = currentCamera.Focus

local function getStealMode(arg2)
if aceInstaResetState.cameraConnection then
	pcall(function()
		aceInstaResetState.cameraConnection:Disconnect()
	end)

	aceInstaResetState.cameraConnection = nil
end

local currentCamera2 = workspace.CurrentCamera or currentCamera

if currentCamera2 then
	pcall(function()
		currentCamera2.CameraType = Enum.CameraType.Custom
		local item1 = arg2 and arg2:FindFirstChildOfClass("Humanoid")

		if item1 then
			currentCamera2.CameraSubject = item1
		end
	end)
end

aceInstaResetState.cameraHeld = false
end

pcall(function()
currentCamera.CameraType = Enum.CameraType.Scriptable
currentCamera.CFrame = cFrame
currentCamera.Focus = focus
end)

aceInstaResetState.cameraConnection = safeConnect(RunService.RenderStepped, function()
if workspace.CurrentCamera ~= currentCamera then
	return
end
currentCamera.CameraType = Enum.CameraType.Scriptable
currentCamera.CFrame = cFrame
currentCamera.Focus = focus
end)

task.spawn(function()
local item1 = 0

while localPlayer.Character == arg and item1 < 3 do
	item1 += task.wait()
end

local character = localPlayer.Character

if character == arg then
	character = nil
end

getStealMode(character)
if not character then
	return
end
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 1)
local currentCamera2 = workspace.CurrentCamera

if currentCamera2 then
	pcall(function()
		currentCamera2.CameraType = Enum.CameraType.Custom

		if humanoid then
			currentCamera2.CameraSubject = humanoid
		end
	end)
end
end)
end

local function getStealMode(arg)
local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
if not (humanoidRootPart and humanoidRootPart:IsA("BasePart")) then
return false
end
local humanoid = arg:FindFirstChildOfClass("Humanoid")

if humanoid then
pcall(function()
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	humanoid.BreakJointsOnDeath = true
	humanoid.PlatformStand = true
	humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end)
end

local vector = Vector3.new(0, math.clamp(aceInstaResetState.speed, 0, 10000000), 0)

local function removeAttachments()
if not humanoidRootPart.Parent then
	return false
end

return (pcall(function()
	humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	humanoidRootPart.AssemblyLinearVelocity = vector
end))
end

if not removeAttachments() then
return false
end

task.spawn(function()
local calcVal1 = 0

while calcVal1 < 1.5 do
	calcVal1 += heartbeat:Wait()
	if not humanoidRootPart.Parent then
		return
	end

	if localPlayer.Character ~= arg then
		return
	end
	removeAttachments()
end
end)

return true
end

local function removeAttachments(arg)
local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
if not humanoid then
return
end

pcall(function()
humanoid.PlatformStand = false
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
humanoid.BreakJointsOnDeath = true

if humanoid.MaxHealth == math.huge or humanoid.MaxHealth <= 0 then
	humanoid.MaxHealth = 100
end

humanoid.Health = 0
end)

pcall(function()
arg:BreakJoints()
end)
end

local function updateCharacterState()
aceInstaResetState.queued = true
aceInstaResetState.queuedUntil = os.clock() + 12
end

aceInstaReset = function()
local character = localPlayer.Character
local item1 = character and character:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if not (character and item1 and humanoidRootPart and humanoidRootPart:IsA("BasePart")) then
updateCharacterState()
return
end
local busy = aceInstaResetState.busy

if busy then
busy = os.clock() - (aceInstaResetState.busyAt or 0) < 5
end

if busy then
return
end
aceInstaResetState.busy = true
aceInstaResetState.busyAt = os.clock()
aceInstaResetState.token = aceInstaResetState.token + 1
local token = aceInstaResetState.token
local item2 = resetMovers()

task.spawn(function()
cleanupSession(character)

if not getStealMode(character) then
	removeAttachments(character)
end

local calcVal1 = 0

while localPlayer.Character == character and calcVal1 < 1.2 do
	calcVal1 += task.wait()
end

if localPlayer.Character == character then
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health > 0 then
		removeAttachments(character)
	end
end

local calcVal2 = 0

while localPlayer.Character == character and calcVal2 < 8 do
	calcVal2 += task.wait()
end

if aceInstaResetState.token ~= token then
	return
end
aceInstaResetState.busy = false
clearMovers(item2)
end)
end
end
end

registerConnection(heartbeat:Connect(function()
local item1 = aceInstaResetState

if true then
if not (item1.wantDie or item1.wantFling) then
return
end
local busy = item1.busy
local stateFlag

if busy then
stateFlag = os.clock() - (item1.busyAt or 0) < 10
else
stateFlag = busy
end

if stateFlag then
return
end

if os.clock() - (item1.suspendAt or 0) < 12 then
return
end
item1.busy = false
clearMovers(nil)
return
end
end))

do
local item1 = safeConnect(localPlayer.CharacterAdded, function(arg)
if not aceInstaResetState.queued then
return
end

if os.clock() > (aceInstaResetState.queuedUntil or 0) then
aceInstaResetState.queued = false
return
end
aceInstaResetState.queued = false

task.spawn(function()
local item1 = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:WaitForChild("HumanoidRootPart", 5)
task.wait(0.15)

if item1 and humanoidRootPart and item1.Health > 0 and localPlayer.Character == arg then
aceInstaReset()
end
end)
end)

registerConnection(item1)
end

_G._AceInstaReset = aceInstaReset
_G._CandyInstaReset = aceInstaReset

_G._AceInstaResetTune = function(arg)
local num = tonumber(arg)

if num then
aceInstaResetState.speed = math.clamp(math.abs(num), 1000, 10000000)
end

return aceInstaResetState.speed
end
end

do
local registerConnection

do
do
_G._CandyInstaResetTune = _G._AceInstaResetTune

if _G.AdaptAntiVoid and _G.AdaptAntiVoid.Stop then
pcall(_G.AdaptAntiVoid.Stop)
end

do
local LaggerState = {
enabled = false,
safeCFrame = nil,
connection = nil,
characterConnection = nil,
suspendUntil = 0,
}

local function resetMovers(arg)
arg = arg and arg:FindFirstChild("HumanoidRootPart")

if arg then
	LaggerState.safeCFrame = arg.CFrame
end
end

_G.AdaptAntiVoid = {
Start = function()
	if LaggerState.enabled then
		return
	end
	LaggerState.enabled = true
	resetMovers(localPlayer.Character)

	LaggerState.characterConnection = safeConnect(localPlayer.CharacterAdded, function(arg)
		task.defer(function()
			if LaggerState.enabled then
				resetMovers(arg)
			end
		end)
	end)

	LaggerState.connection = safeConnect(RunService.Heartbeat, function()
		if not LaggerState.enabled then
			return
		end

		if os.clock() < (LaggerState.suspendUntil or 0) then
			return
		end
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return
		end
		local position = character.Position

		if character.AssemblyLinearVelocity.Magnitude < 50 and position.Y > -30 and position.Y < 400 then
			LaggerState.safeCFrame = character.CFrame
		end

		if LaggerState.safeCFrame and (position.Y < -100 or position.Y > 900) then
			character.AssemblyLinearVelocity = Vector3.zero
			character.AssemblyAngularVelocity = Vector3.zero
			character.CFrame = LaggerState.safeCFrame + Vector3.new(0, 5, 0)
		end
	end)
end,
Stop = function()
	LaggerState.enabled = false

	if LaggerState.connection then
		LaggerState.connection:Disconnect()
		LaggerState.connection = nil
	end

	if LaggerState.characterConnection then
		LaggerState.characterConnection:Disconnect()
		LaggerState.characterConnection = nil
	end

	LaggerState.safeCFrame = nil
end,
IsEnabled = function()
	return LaggerState.enabled
end,
Suspend = function(arg)
	LaggerState.suspendUntil = os.clock() + (tonumber(arg) or 6)
end,
}
end
end

_G._CandyAntiVoid = _G.AdaptAntiVoid

registerConnection = function()
local character = localPlayer.Character
if not character then
return nil
end

for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
return child
end
end

local backpack = localPlayer:FindFirstChild("Backpack")

if backpack then
for _, child in ipairs(backpack:GetChildren()) do
if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
	return child
end
end
end

return nil
end

fn40 = function()
local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return nil
end
local huge = math.huge
local item1 = nil

for _, player in ipairs(service:GetPlayers()) do
if player ~= localPlayer and player.Character then
local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
	local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

	if magnitude < huge then
		huge = magnitude
		item1 = humanoidRootPart2
	end
end
end
end

return item1
end

do
local function resetMovers(arg)
local aceAimbotMoveVelocity = arg and arg:FindFirstChild("AceAimbotMoveVelocity")

if aceAimbotMoveVelocity and aceAimbotMoveVelocity:IsA("LinearVelocity") then
aceAimbotMoveVelocity:Destroy()
end

arg = arg and arg:FindFirstChild("AceAimbotMoveAttachment")

if arg and arg:IsA("Attachment") then
arg:Destroy()
end
end

_G._AceClearAimbotMover = function()
local character = localPlayer.Character
resetMovers(character and character:FindFirstChild("HumanoidRootPart"))
end

local function clearMovers()
if SpeedState.family == "lagger" then
return tonumber(CombatState.laggerAimSpd) or 40
end
return tonumber(CombatState.aimSpd) or 58
end

local function cleanupSession()
return _G._RaVeSafeMode and _G._RaVeSafeMode.IsLocked and _G._RaVeSafeMode.IsLocked() == true
end

local function getStealMode()
return CombatState.antiMode ~= true
end

fn41 = function()
_G._AdaptTPMirrorEnabled = CombatState.tpMirror == true or CombatState.desync == true

if configTable.aimbot then
configTable.aimbot:Disconnect()
configTable.aimbot = nil
end

if configTable.aimbotNew then
configTable.aimbotNew:Disconnect()
configTable.aimbotNew = nil
end

_G._AdaptNormalAimbot = _G._AdaptNormalAimbot or { target = nil, swingCooldown = false }
local adaptNormalAimbot = _G._AdaptNormalAimbot
adaptNormalAimbot.target = nil
adaptNormalAimbot.swingCooldown = false
adaptNormalAimbot.equipped = false
local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

if humanoid then
humanoid.AutoRotate = false
end

configTable.aimbot = safeConnect(RunService.RenderStepped, function()
if not CombatState.aimbot or getStealMode() then
	return
end

if cleanupSession() then
	pcall(_G._AceClearAimbotMover)
	return
end
local character = localPlayer.Character
if not character then
	return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
	return
end
local humanoid2 = character:FindFirstChildOfClass("Humanoid")
if not humanoid2 then
	return
end
local tool = character:FindFirstChildOfClass("Tool") or registerConnection()

if tool and tool.Parent ~= character then
	pcall(function()
		humanoid2:EquipTool(tool)
	end)
end

local item1 = fn40()
adaptNormalAimbot.target = item1
if not item1 then
	return
end
humanoid2.AutoRotate = false
local assemblyLinearVelocity = item1.AssemblyLinearVelocity or Vector3.zero
local position = humanoidRootPart.Position
local position2 = item1.Position
local calcVal1 = position2 + assemblyLinearVelocity * 0.14 + item1.CFrame.LookVector * 0.3 - position
if calcVal1.Magnitude < 0.01 then
	return
end
local vector = Vector3.new(calcVal1.X, 0, calcVal1.Z)
if vector.Magnitude < 0.01 then
	return
end
local unit = vector.Unit
local item2 = clearMovers()
local calcVal2 = (position2.Y + 3.7 - position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8
local calcVal3

if humanoid2.FloorMaterial == Enum.Material.Air then
	calcVal3 = calcVal2
else
	calcVal3 = math.max(calcVal2, 13)
end

humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * item2, math.clamp(calcVal3, -70, 110), unit.Z * item2), 0.8)
local calcVal4 = position2 + assemblyLinearVelocity * math.clamp(assemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

if (calcVal4 - position).Magnitude > 0.1 then
	local cframe = CFrame.lookAt(position, calcVal4)
	local item3, item4, item5 = (humanoidRootPart.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
	humanoidRootPart.AssemblyAngularVelocity = humanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(item3, -2.5, 2.5) * 42, math.clamp(item4, -2.5, 2.5) * 42, math.clamp(item5, -2.5, 2.5) * 42))
end

if CombatState.swing and tool and tool.Parent == character and not adaptNormalAimbot.swingCooldown then
	adaptNormalAimbot.swingCooldown = true

	pcall(function()
		tool:Activate()
	end)

	task.delay(0.05, function()
		if _G._AdaptNormalAimbot == adaptNormalAimbot then
			adaptNormalAimbot.swingCooldown = false
		end
	end)
end
end)

configTable.aimbotNew = safeConnect(RunService.Heartbeat, function()
if not CombatState.aimbot or not getStealMode() then
	return
end

if cleanupSession() then
	pcall(_G._AceClearAimbotMover)
	return
end
local character = localPlayer.Character
local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart or not humanoid2 then
	return
end

if not adaptNormalAimbot.equipped then
	adaptNormalAimbot.equipped = true

	if not character:FindFirstChildOfClass("Tool") then
		local item2 = registerConnection()

		if item2 then
			pcall(function()
				humanoid2:EquipTool(item2)
			end)
		end
	end
end

local item2 = fn40()
adaptNormalAimbot.target = item2
if not item2 then
	humanoid2.AutoRotate = true
	return
end
local assemblyLinearVelocity = item2.AssemblyLinearVelocity
local calcVal1 = item2.Position + assemblyLinearVelocity * math.clamp(assemblyLinearVelocity.Magnitude / 130, 0.05, 0.15) + Vector3.new(0, 1, 0)
humanoid2.AutoRotate = false
local calcVal2 = calcVal1 - item1.Position
local vector = Vector3.new(calcVal2.X, 0, calcVal2.Z)

if calcVal2.Magnitude > 0.01 and vector.Magnitude > 0.01 then
	local y = item1.Orientation.Y
	item1.AssemblyAngularVelocity = Vector3.new(0, math.clamp(math.rad((math.deg(math.atan2(-vector.X, -vector.Z)) - y + 180) % 360 - 180) * 285, -28, 28), 0)
	local position = item1.Position
	local calcVal3 = calcVal1 + vector.Unit * -2.8 + Vector3.new(0, 4.75, 0) - position
	local vector2 = Vector3.new(calcVal3.X, 0, calcVal3.Z)
	local calcVal4 = clearMovers() or 56
	local vector3 = vector2.Magnitude > 0.2 and vector2.Unit * calcVal4 or Vector3.zero
	item1.AssemblyLinearVelocity = Vector3.new(vector3.X, math.clamp(calcVal3.Y * 2.5, -52, 52), vector3.Z)

	if sethiddenproperty then
		pcall(function()
			sethiddenproperty(item1, "PhysicsRepRootPart", item2)
		end)
	end

	if vector2.Magnitude > 0.5 then
		humanoid2:Move(vector2.Unit, false)
	end
end

local tool = character:FindFirstChildOfClass("Tool") or registerConnection()

if CombatState.swing and tool and tool.Parent == character and not adaptNormalAimbot.swingCooldown then
	adaptNormalAimbot.swingCooldown = true

	pcall(function()
		tool:Activate()
	end)

	task.delay(0.08, function()
		if _G._AdaptNormalAimbot == adaptNormalAimbot then
			adaptNormalAimbot.swingCooldown = false
		end
	end)
end
end)
end

fn42 = function()
_G._AdaptTPMirrorEnabled = CombatState.desync == true

if configTable.aimbot then
configTable.aimbot:Disconnect()
configTable.aimbot = nil
end

if configTable.aimbotNew then
configTable.aimbotNew:Disconnect()
configTable.aimbotNew = nil
end

if _G._AdaptNormalAimbot then
_G._AdaptNormalAimbot.target = nil
_G._AdaptNormalAimbot.swingCooldown = false
_G._AdaptNormalAimbot.equipped = false
end

local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
humanoid.AutoRotate = true
humanoid.PlatformStand = false

pcall(function()
	humanoid:Move(Vector3.zero, false)
end)

pcall(function()
	humanoid:ChangeState(Enum.HumanoidStateType.Running)
end)
end

if humanoidRootPart then
resetMovers(humanoidRootPart)
humanoidRootPart.Anchored = false
humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

if sethiddenproperty then
	pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", nil)
end

local cFrame = humanoidRootPart.CFrame
local lookVector = cFrame.LookVector
local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
local vector2

if vector.Magnitude < 0.5 then
	vector2 = Vector3.new(0, 0, -1)
else
	vector2 = vector.Unit
end

humanoidRootPart.CFrame = CFrame.lookAt(cFrame.Position, cFrame.Position + vector2)
humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
end

task.spawn(function()
for i = 1, 12 do
	task.wait(0.1)
	local character2 = localPlayer.Character
	if not character2 then
		return
	end
	local item2 = character2:FindFirstChild("HumanoidRootPart")
	local humanoid = character2:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.AutoRotate = true
		humanoid.PlatformStand = false
	end

	if item2 then
		item2.AssemblyAngularVelocity = Vector3.zero
	end
end
end)
end
end
end

do
do
local stateFlag = false

fn43 = function()
if stateFlag then
return
end
stateFlag = true

pcall(function()
local item1 = registerConnection()

if item1 then
	item1:Activate()
	local remoteEvent = item1:FindFirstChildWhichIsA("RemoteEvent")

	if remoteEvent then
		remoteEvent:FireServer()
	end
end
end)

task.delay(0.08, function()
stateFlag = false
end)
end
end
end

local LaggerState, calcVal1

do
LaggerState = {}
calcVal1 = 0
adaptTPMirrorEnabled = false

do
local function resetMovers()
return CombatState.aimbot == true or CombatState.desync == true
end

local function clearMovers()
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
character = character and character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not character or character.Health <= 0 then
return
end
local currentTime = tick()
if currentTime - calcVal1 < 0.08 then
return
end
calcVal1 = currentTime
local item1, item2 = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z) * CFrame.Angles(0, item2, 0)
humanoidRootPart.Velocity = Vector3.zero

pcall(function()
humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
end)
end

local calcVal2 = 0

safeConnect(RunService.Heartbeat, function()
local currentTime = tick()
if currentTime < calcVal2 then
return
end
calcVal2 = currentTime + 0.1
if not _G._AdaptTPMirrorEnabled or not resetMovers() then
table.clear(LaggerState)
return
end
local character = localPlayer.Character
character = character and character:FindFirstChild("HumanoidRootPart")
if not character then
return
end

for _, player in ipairs(service:GetPlayers()) do
if player ~= localPlayer and player.Character then
	local item1 = player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

	if item1 and humanoid and humanoid.Health > 0 then
		local calcVal3 = item1.Position.X - character.Position.X
		local calcVal4 = item1.Position.Z - character.Position.Z

		if calcVal3 * calcVal3 + calcVal4 * calcVal4 <= 64 then
			local y = item1.Position.Y
			local item2 = LaggerState[player.UserId]

			if item2 and item2 - y >= 3 then
				pcall(clearMovers)
				table.clear(LaggerState)
			end

			LaggerState[player.UserId] = y
		else
			LaggerState[player.UserId] = nil
		end
	end
end
end
end)
end
end

_G._AdaptDesyncMode = "V2"
_G._AdaptBypassAimbotEnabled = false

do
local function resetMovers()
if _G._AdaptTpBatAntiDie then
pcall(function()
local adaptTpBatAntiDie = _G._AdaptTpBatAntiDie

if adaptTpBatAntiDie.destroy then
	adaptTpBatAntiDie.destroy()
elseif adaptTpBatAntiDie.stop then
	adaptTpBatAntiDie.stop()
end
end)
end

local dataTable = {
active = false,
tpBatActive = false,
conns = {},
lastSafeCFrame = nil,
lastSafePosition = nil,
invincibleUntil = 0,
humanoid = nil,
originalBreakJoints = nil,
originalDeadEnabled = nil,
}

local function clearMovers(arg)
local item1 = dataTable.conns[arg]

if item1 then
pcall(function()
	item1:Disconnect()
end)

dataTable.conns[arg] = nil
end
end

local function cleanupSession(arg)
if not dataTable.active or not arg or not arg.Parent then
return
end
local maxHealth = arg.MaxHealth > 0 and arg.MaxHealth or 100

pcall(function()
arg.Health = maxHealth
end)

local item1 = 0.5
dataTable.invincibleUntil = os.clock() + item1

pcall(function()
for _, child in ipairs(arg.Parent:GetChildren()) do
	if child:IsA("NumberValue") then
		local strName = child.Name:lower()

		if strName:find("health") or strName:find("hp") or strName:find("life") then
			child.Value = maxHealth
		end
	elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
		child.Value = false
	end
end
end)
end

local function getStealMode()
local humanoid = dataTable.humanoid

if humanoid and humanoid.Parent then
pcall(function()
	if dataTable.originalBreakJoints ~= nil then
		humanoid.BreakJointsOnDeath = dataTable.originalBreakJoints
	end

	if dataTable.originalDeadEnabled ~= nil then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, dataTable.originalDeadEnabled)
	end

	humanoid.PlatformStand = false
end)
end

dataTable.humanoid = nil
dataTable.originalBreakJoints = nil
dataTable.originalDeadEnabled = nil
end

local function removeAttachments(arg)
if not dataTable.active or not arg then
return
end
clearMovers("health")
getStealMode()
local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 2)
if not dataTable.active or not humanoid then
return
end
local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
dataTable.humanoid = humanoid
dataTable.originalBreakJoints = humanoid.BreakJointsOnDeath

pcall(function()
dataTable.originalDeadEnabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead)
end)

pcall(function()
humanoid.BreakJointsOnDeath = false
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)

if humanoidRootPart then
dataTable.lastSafeCFrame = humanoidRootPart.CFrame
dataTable.lastSafePosition = humanoidRootPart.Position
end

dataTable.conns.health = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
if dataTable.active and humanoid.Health <= 25 then
	cleanupSession(humanoid)

	pcall(function()
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end)
end
end)
end

local function updateCharacterState()
dataTable.active = false
clearMovers("heartbeat")
clearMovers("character")
clearMovers("health")
getStealMode()
dataTable.lastSafeCFrame = nil
dataTable.lastSafePosition = nil
dataTable.invincibleUntil = 0
end

local function executeAction()
if dataTable.active then
return
end
dataTable.active = true
removeAttachments(localPlayer.Character)

dataTable.conns.character = safeConnect(localPlayer.CharacterAdded, function(arg)
task.wait(0.1)

if dataTable.active then
	removeAttachments(arg)
end
end)

dataTable.conns.heartbeat = safeConnect(RunService.Heartbeat, function()
if not dataTable.active then
	return
end

if not dataTable.tpBatActive then
	updateCharacterState()
	return
end
local character = localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not humanoidRootPart then
	return
end

pcall(function()
	humanoid.BreakJointsOnDeath = false
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)

local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
local assemblyAngularVelocity = humanoidRootPart.AssemblyAngularVelocity
local magnitude = assemblyLinearVelocity.Magnitude
local position = humanoidRootPart.Position

if magnitude < 50 and position.Y > -10 and position.Y < 400 then
	dataTable.lastSafeCFrame = humanoidRootPart.CFrame
	dataTable.lastSafePosition = position
end

local stateFlag = not JumpState.active
local checkFlag

if stateFlag then
	local matchFlag = magnitude >= 80

	if not matchFlag then
		local item1 = 8
		matchFlag = math.abs(assemblyLinearVelocity.Y) >= item1
	end

	checkFlag = matchFlag or assemblyAngularVelocity.Magnitude >= 40
else
	checkFlag = stateFlag
end

if checkFlag then
	pcall(function()
		humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end)

	if dataTable.lastSafePosition and (position - dataTable.lastSafePosition).Magnitude > 35 then
		local lookVector = humanoidRootPart.CFrame.LookVector

		pcall(function()
			humanoidRootPart.CFrame = CFrame.new(dataTable.lastSafePosition, dataTable.lastSafePosition + lookVector)
		end)
	end
end

if dataTable.lastSafeCFrame and (position.Y < -100 or position.Y > 900) then
	pcall(function()
		humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		humanoidRootPart.CFrame = dataTable.lastSafeCFrame
	end)
end

local state = humanoid:GetState()

if humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
	pcall(function()
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end)
end

local matchFlag = humanoid.Health <= 25
local extraFlag

if matchFlag then
	extraFlag = matchFlag
else
	local invincibleUntil = dataTable.invincibleUntil
	extraFlag = os.clock() < invincibleUntil and humanoid.Health < humanoid.MaxHealth
end

if extraFlag then
	cleanupSession(humanoid)
end
end)
end

_G._AdaptTpBatAntiDie = {
start = function()
dataTable.tpBatActive = true
executeAction()
end,
stop = function()
dataTable.tpBatActive = false
updateCharacterState()
end,
destroy = updateCharacterState,
}
end

resetMovers()
end

fn44 = function()
_G._AdaptTpBatActive = true
_G._AdaptTpBatSwingCooldown = false
_G._AdaptTPMirrorEnabled = CombatState.tpMirror == true

if _G._AdaptTpBatAntiDie then
pcall(_G._AdaptTpBatAntiDie.start)
end

if configTable.desync then
configTable.desync:Disconnect()
end

if configTable.desyncLowPing then
configTable.desyncLowPing:Disconnect()
configTable.desyncLowPing = nil
end

configTable.desync = safeConnect(RunService.Heartbeat, function()
if not CombatState.desync then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not humanoid then
return
end

if _G._AdaptTpBatMode ~= "HIGH PING" and not _G._AdaptTpBatSwingCooldown then
_G._AdaptTpBatSwingCooldown = true
local item2 = registerConnection()

if item2 then
if item2.Parent ~= character then
	pcall(function()
		item1:EquipTool(item2)
	end)
end

if item2.Parent == character then
	pcall(function()
		item2:Activate()
	end)
end
end

task.delay(0.08, function()
_G._AdaptTpBatSwingCooldown = false
end)
end

local item2 = fn40()
if not item2 then
return
end

if _G._AdaptTpBatMode == "HIGH PING" then
if (humanoidRootPart.Position - item2.Position).Magnitude > 100 then
return
end

if sethiddenproperty then
pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", item2)
end

local calcVal2 = item2.Position + Vector3.new(0, 0.9, 0)

if (humanoidRootPart.Position - calcVal2).Magnitude > 8 then
pcall(function()
	humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
	humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	humanoidRootPart.CFrame = CFrame.new(calcVal2)
	humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
	humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
end)
end

if not CombatState.desyncNoCam then
local currentCamera = workspace.CurrentCamera

if currentCamera then
	currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, item2.Position)
end
end

if not CombatState.desyncSwing then
return
end

if _G._AdaptTpBatHitCooldown then
return
end
_G._AdaptTpBatHitCooldown = true

pcall(function()
local bat = character:FindFirstChild("Bat") or registerConnection()

if bat then
	if bat.Parent ~= character then
		item1:EquipTool(bat)
	end

	if bat.Parent == character then
		pcall(function()
			bat:Activate()
		end)
	end

	local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")

	if remoteEvent then
		pcall(function()
			remoteEvent:FireServer()
		end)
	end
end
end)

task.delay(0.05, function()
_G._AdaptTpBatHitCooldown = false
end)
else
if sethiddenproperty then
pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", item2)
end

local calcVal2 = item2.Position + Vector3.new(0, 0.9, 0)

if (humanoidRootPart.Position - calcVal2).Magnitude > 5 then
humanoidRootPart.CFrame = CFrame.new(calcVal2)
end

if not CombatState.desyncNoCam then
local currentCamera = workspace.CurrentCamera

if currentCamera then
	currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, item2.Position)
end
end

if not CombatState.desyncSwing then
return
end

if _G._AdaptTpBatHitCooldown then
return
end
_G._AdaptTpBatHitCooldown = true

pcall(function()
local bat = character:FindFirstChild("Bat") or registerConnection()

if bat then
	if bat.Parent ~= character then
		item1:EquipTool(bat)
	end

	if bat.Parent == character then
		pcall(function()
			bat:Activate()
		end)
	end

	local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")

	if remoteEvent then
		pcall(function()
			remoteEvent:FireServer()
		end)
	end

	local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")

	if remoteFunction then
		pcall(function()
			remoteFunction:InvokeServer()
		end)
	end
end
end)

task.delay(0.05, function()
_G._AdaptTpBatHitCooldown = false
end)
end
end)

configTable.desyncLowPing = safeConnect(RunService.RenderStepped, function()
if not CombatState.desync or _G._AdaptTpBatMode == "HIGH PING" then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not humanoid then
return
end
local item2 = fn40()
if not item2 then
return
end

if not CombatState.desyncNoCam then
local currentCamera = workspace.CurrentCamera

if currentCamera then
currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, item2.Position)
end
end

if not CombatState.desyncSwing then
return
end

if _G._AdaptTpBatHitCooldown then
return
end
_G._AdaptTpBatHitCooldown = true

pcall(function()
local bat = character:FindFirstChild("Bat") or registerConnection()

if bat then
if bat.Parent ~= character then
	item1:EquipTool(bat)
end

if bat.Parent == character then
	pcall(function()
		bat:Activate()
	end)
end

local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")

if remoteEvent then
	pcall(function()
		remoteEvent:FireServer()
	end)
end

local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")

if remoteFunction then
	pcall(function()
		remoteFunction:InvokeServer()
	end)
end
end
end)

task.delay(0.08, function()
_G._AdaptTpBatHitCooldown = false
end)
end)
end

fn45 = function()
_G._AdaptTpBatActive = false

if _G._AdaptTpBatAntiDie then
pcall(_G._AdaptTpBatAntiDie.stop)
end

if configTable.desync then
configTable.desync:Disconnect()
configTable.desync = nil
end

if configTable.desyncLowPing then
configTable.desyncLowPing:Disconnect()
configTable.desyncLowPing = nil
end

local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

if humanoidRootPart then
pcall(function()
if sethiddenproperty then
sethiddenproperty(humanoidRootPart, "PhysicsRepRootPart", nil)
end
end)

humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
end

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

if humanoid then
pcall(function()
humanoid.PlatformStand = false
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end)
end

_G._AdaptTpBatHitCooldown = false
_G._AdaptTpBatSwingCooldown = false
table.clear(LaggerState)
calcVal1 = 0
end
end

local registerConnection, resetMovers, clearMovers, cleanupSession, getStealMode, removeAttachments, updateCharacterState, executeAction

do
do
do
local candySafeMode, configTable

do
local LaggerState, disconnectHandler, setupListener

do
local playerGui

do
candySafeMode = {
	Enabled = false,
	Actions = {},
	_connections = {},
	_running = false,
	_lastCheck = 0,
	_state = {
		countdown = false,
		holding = false,
		timerPhase = "unknown",
		timerStartUsed = false,
		timerRoundSeen = false,
		timerSawInactive = false,
		timerInactiveSince = nil,
	},
}

_G._CandySafeMode = candySafeMode
playerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or localPlayer:WaitForChild("PlayerGui")

LaggerState = {
	Stealing = true,
	Carrying = true,
	IsCarrying = true,
	HoldingBrainrot = true,
	HasBrainrot = true,
}

configTable = {
	"Bat Aimbot",
	"Desync Aimbot",
	"Auto Swing",
	"Auto Left",
	"Auto Right",
}

do
	local dataTable = {}

	for _, loopItem in ipairs(configTable) do
		dataTable[loopItem] = true
	end
end
end

disconnectHandler = function(arg)
if arg then
		pcall(function()
			arg:Disconnect()
		end)
	end

	return

end

setupListener = function(arg)
local raVeSafeToggleSource = _G._RaVeSafeToggleSource
return raVeSafeToggleSource and raVeSafeToggleSource[arg]
end

do
local item1 = nil

local function processInput()
	if item1 and item1.Parent then
		return item1
	end
	item1 = nil
	local duelsMachineTopFrame = playerGui:FindFirstChild("DuelsMachineTopFrame", true)
	duelsMachineTopFrame = duelsMachineTopFrame and duelsMachineTopFrame:FindFirstChild("Timer", true)
	duelsMachineTopFrame = duelsMachineTopFrame and duelsMachineTopFrame:FindFirstChild("Label", true)

	if duelsMachineTopFrame and duelsMachineTopFrame:IsA("TextLabel") then
		item1 = duelsMachineTopFrame
	end

	return item1
end

candySafeMode.IsHoldingBrainrotFast = function()
	for k in pairs(LaggerState) do
		local item2 = true
		if localPlayer:GetAttribute(k) == item2 then
			return true
		end
	end

	local character = localPlayer.Character
	if not character then
		return false
	end

	for k in pairs(LaggerState) do
		if character:GetAttribute(k) == true then
			return true
		end
	end

	return false
end

candySafeMode.IsHoldingBrainrot = function()
	for k in pairs(LaggerState) do
		if localPlayer:GetAttribute(k) == true then
			return true
		end
	end

	local character = localPlayer.Character
	if not character then
		return false
	end

	for k in pairs(LaggerState) do
		local item2 = true
		if character:GetAttribute(k) == item2 then
			return true
		end
		local item3 = character:FindFirstChild(k, true)
		if item3 and item3:IsA("BoolValue") and item3.Value then
			return true
		end
	end

	return false
end

candySafeMode.IsRoundCountdownActive = function(arg)
	local state = arg._state

	local function createOrResetBillboard()
		state.timerInactiveSince = state.timerInactiveSince or os.clock()
		local timerInactiveSince = state.timerInactiveSince

		if os.clock() - timerInactiveSince >= 0.75 then
			state.timerPhase = "inactive"
			state.timerStartUsed = false
			state.timerRoundSeen = false
			state.timerSawInactive = true
		end

		return false
	end

	local item2 = processInput()
	if not item2 then
		return (createOrResetBillboard())
	end
	local parent = item2

	while parent and parent ~= playerGui do
		if parent:IsA("GuiObject") and not parent.Visible then
			return (createOrResetBillboard())
		end

		if parent:IsA("ScreenGui") and not parent.Enabled then
			return (createOrResetBillboard())
		end
		parent = parent.Parent
	end

	local strName = tostring(item2.Text or ""):upper():gsub("<.->", ""):gsub("%s+", "")
	state.timerInactiveSince = nil

	if strName == "READY" or strName == "STARTING" or strName == "GETREADY" then
		local item3 = true
		state.timerPhase = "starting"
		state.timerStartUsed = item3
		state.timerRoundSeen = false
		return true
	end

	if strName == "GO" or strName == "FIGHT" then
		state.timerPhase = "round"
		state.timerStartUsed = true
		state.timerRoundSeen = true
		return false
	end

	local match, item3 = strName:match("^(%d+):(%d+)$")

	if match and item3 then
		if tonumber(match) * 60 + tonumber(item3) <= 0 then
			local item4 = false
			state.timerPhase = "inactive"
			state.timerStartUsed = false
			state.timerRoundSeen = item4
			state.timerSawInactive = true
		else
			local item4 = true
			local item5 = true
			state.timerPhase = "round"
			state.timerStartUsed = item4
			state.timerRoundSeen = item5
		end

		return false
	end

	local num = tonumber(strName)
	if not num then
		return false
	end

	if num > 10 then
		local item4 = true
		state.timerPhase = "round"
		state.timerStartUsed = item4
		state.timerRoundSeen = true
		return false
	end

	if num <= 0 then
		if state.timerRoundSeen then
			local item4 = false
			local item5 = false
			state.timerPhase = "inactive"
			state.timerStartUsed = item4
			state.timerRoundSeen = item5
			state.timerSawInactive = true
		end

		return false
	end

	if state.timerRoundSeen or state.timerStartUsed and state.timerPhase ~= "starting" then
		return false
	end

	if state.timerPhase == "starting" then
		return true
	end

	if not state.timerStartUsed and state.timerSawInactive then
		local item4 = true
		state.timerPhase = "starting"
		state.timerStartUsed = item4
		state.timerSawInactive = false
		return true
	end

	return false
end
end
end

candySafeMode.GetBlockReason = function(arg)
if not arg.Enabled then
return nil
end

if arg._state.countdown then
return "ROUND COUNTDOWN"
end

if arg._state.holding then
return "BRAINROT HELD"
end
return nil
end

candySafeMode.BindAction = function(arg, arg2, arg3, arg4, arg5)
arg.Actions[arg2] = { get = arg3, set = arg4, conflicts = arg5 or {} }
end

candySafeMode._disable = function(arg, arg2)
local item1 = arg.Actions[arg2]

if item1 then
pcall(item1.set, false)
end
end

candySafeMode.Request = function(arg, arg2, arg3)
local item1 = arg.Actions[arg2]
if not item1 then
return false, "UNBOUND ACTION"
end

if arg3 ~= true then
arg:_disable(arg2)
return true
end
local blockReason = arg:GetBlockReason()
if blockReason then
arg:_disable(arg2)
return false, blockReason
end

for _, conflict in ipairs(item1.conflicts) do
arg:_disable(conflict)
end

item1.set(true)
return true
end

candySafeMode.Toggle = function(arg, arg2)
local item1 = arg.Actions[arg2]
return item1 and arg:Request(arg2, not item1.get()) or false
end

do
local item1 = false

local function processInput(arg)
if item1 == arg then
	return
end
item1 = arg

for _, loopEntry in ipairs(configTable) do
	local item3 = setupListener(loopEntry)

	if item3 and item3.Card then
		item3.Card.BackgroundTransparency = arg and 0.5 or 0
	end
end
end

candySafeMode.Evaluate = function(arg)
local state = arg._state
local item2 = arg:IsRoundCountdownActive()
local item3 = arg:IsHoldingBrainrot()
state.countdown = item2
state.holding = item3
if not arg.Enabled then
	return
end
local blockReason = arg:GetBlockReason()
processInput(blockReason ~= nil)
if not blockReason then
	return
end

for k, action in pairs(arg.Actions) do
	if action.get() then
		arg:_disable(k)
	end
end
end

candySafeMode.SetEnabled = function(arg, arg2)
arg.Enabled = arg2 == true

if not arg.Enabled then
	processInput(false)
else
	local state = arg._state
	arg._state.countdown = false
	state.holding = false
	arg:Evaluate()
end
end
end

candySafeMode._watchCarryState = function(arg)
local function processInput()
task.defer(function()
	if candySafeMode._running and candySafeMode.Enabled then
		pcall(function()
			candySafeMode:Evaluate()
		end)
	end
end)
end

for k in pairs(LaggerState) do
arg._connections["player_" .. k] = localPlayer:GetAttributeChangedSignal(k):Connect(processInput)
end

local function createOrResetBillboard(arg2)
for k, connection in pairs(arg._connections) do
	if k:sub(1, 5) == "char_" then
		disconnectHandler(connection)
		arg._connections[k] = nil
	end
end

if not arg2 then
	return
end

for k in pairs(LaggerState) do
	arg._connections["char_attr_" .. k] = arg2:GetAttributeChangedSignal(k):Connect(processInput)
end

arg._connections.char_added = arg2.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("Tool") or LaggerState[descendant.Name] then
		processInput()
	end
end)

arg._connections.char_removed = arg2.DescendantRemoving:Connect(function(descendant)
	if descendant:IsA("Tool") or LaggerState[descendant.Name] then
		processInput()
	end
end)
end

arg._connections.character = safeConnect(localPlayer.CharacterAdded, function(arg2)
createOrResetBillboard(arg2)
processInput()
end)

createOrResetBillboard(localPlayer.Character)
end

candySafeMode.Start = function(arg)
if arg._running then
return arg
end
arg._running = true
arg:_watchCarryState()

arg._connections.monitor = safeConnect(RunService.Heartbeat, function()
local stateFlag = not candySafeMode.Enabled

if not stateFlag then
	local lastCheck = candySafeMode._lastCheck
	stateFlag = os.clock() - lastCheck < 0.1
end

if stateFlag then
	return
end
candySafeMode._lastCheck = os.clock()

pcall(function()
	candySafeMode:Evaluate()
end)
end)

if arg.Enabled then
arg:Evaluate()
end

return arg
end

for _, loopItem in ipairs(configTable) do
candySafeMode:BindAction(loopItem, function()
local item2 = setupListener(loopItem)
return (item2 and item2.Get and item2.Get()) == true
end, function(arg)
local item2 = setupListener(loopItem)

if item2 and item2.Set then
	pcall(item2.Set, arg)
end
end)
end
end

local isLocked

do
local calcVal1 = 0
local stateFlag = false

isLocked = function()
if not candySafeMode.Enabled then
return false
end
local currentTime = os.clock()
if currentTime - calcVal1 < 0.015 then
return stateFlag
end
calcVal1 = currentTime
local state = candySafeMode._state
local countdown = false
local holding = false

pcall(function()
countdown = candySafeMode:IsRoundCountdownActive()
end)

pcall(function()
holding = candySafeMode:IsHoldingBrainrotFast() or state.holding == true
end)

state.countdown = countdown
state.holding = holding
stateFlag = countdown or holding
return stateFlag
end
end

do
local function forceStop()
for _, loopItem in ipairs(configTable) do
local item2 = candySafeMode.Actions[loopItem]

if item2 and item2.get() then
	candySafeMode:_disable(loopItem)
end
end
end

candySafeMode.IsLocked = isLocked
candySafeMode.GateBlocked = isLocked
candySafeMode.ForceStop = forceStop
_G._CandySafeIsLocked = isLocked
_G._CandySafeGateBlocked = isLocked
_G._CandySafeForceStop = forceStop

_G._RaVeSafeMode = {
IsLocked = isLocked,
SetEnabled = function(arg)
candySafeMode:SetEnabled(arg)
end,
HoldingBrainrot = function()
return candySafeMode:IsHoldingBrainrot()
end,
ForceStop = forceStop,
GetBlockReason = function()
return candySafeMode:GetBlockReason()
end,
}
end

candySafeMode:Start()
end

do
do
local disconnectHandler

do
dropMode = (dropMode == "JUMP" or dropMode == "STAND") and dropMode or "JUMP"

do
local calcVal1 = 0.18

disconnectHandler = function()
	if JumpState.active then
		return
	end
	JumpState.active = true
	_G._RaVeDropToken = (_G._RaVeDropToken or 0) + 1
	local raVeDropToken = _G._RaVeDropToken
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoidRootPart then
		JumpState.active = false
		return
	end
	local raVeDropRayParams = _G._RaVeDropRayParams

	if not raVeDropRayParams then
		raVeDropRayParams = RaycastParams.new()
		raVeDropRayParams.FilterType = Enum.RaycastFilterType.Exclude
		raVeDropRayParams.RespectCanCollide = true
		_G._RaVeDropRayParams = raVeDropRayParams
	end

	raVeDropRayParams.FilterDescendantsInstances = { character }
	local hit = workspace:Raycast(humanoidRootPart.Position + Vector3.new(0, 0.35, 0), Vector3.new(0, -2000, 0), raVeDropRayParams)
	if not hit then
		JumpState.active = false
		return
	end
	local rotation = humanoidRootPart.CFrame.Rotation
	local x = humanoidRootPart.Position.X
	local z = humanoidRootPart.Position.Z
	local currentTime = tick()
	local item1 = nil

	local function setupListener()
		local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if raVeDropToken ~= _G._RaVeDropToken or not humanoidRootPart2 or not humanoid or humanoid.Health <= 0 then
			item1:Disconnect()
			JumpState.active = false
			return
		end

		if tick() - currentTime >= calcVal1 then
			item1:Disconnect()
			raVeDropRayParams.FilterDescendantsInstances = { character }
			local hit2 = workspace:Raycast(humanoidRootPart2.Position + Vector3.new(0, 0.35, 0), Vector3.new(0, -2000, 0), raVeDropRayParams) or hit

			if hit2 then
				humanoidRootPart2.CFrame = CFrame.new(x, hit2.Position.Y + humanoid.HipHeight + humanoidRootPart2.Size.Y * 0.5 + 0.2, z) * rotation
				humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
				humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
			end

			JumpState.active = false
			return
		end

		humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 155, 0)
	end

	item1 = safeConnect
	item1 = item1(RunService.Heartbeat, setupListener)
end
end
end

local configTable = {}

local function setupListener()
if JumpState.active then
return
end
JumpState.active = true

local item1 = safeConnect(RunService.Stepped, function()
if not JumpState.active then
	return
end

for _, player in ipairs(service:GetPlayers()) do
	if player ~= localPlayer and player.Character then
		for _, child in ipairs(player.Character:GetChildren()) do
			if child:IsA("BasePart") then
				child.CanCollide = false
			end
		end
	end
end
end)

table.insert(configTable, item1)

local thread = coroutine.create(function()
while JumpState.active do
	RunService.Heartbeat:Wait()
	local character = localPlayer.Character
	character = character and character:FindFirstChild("HumanoidRootPart")

	if character then
		local velocity = character.Velocity
		character.Velocity = velocity * 10000 + Vector3.new(0, 10000, 0)
		RunService.RenderStepped:Wait()

		if character and character.Parent then
			character.Velocity = velocity
		end

		RunService.Stepped:Wait()

		if character and character.Parent then
			character.Velocity = velocity + Vector3.new(0, 0.1, 0)
		end

		continue
	end

	break
end
end)

table.insert(configTable, thread)
coroutine.resume(thread)

task.delay(0.1, function()
JumpState.active = false

for _, loopEntry in ipairs(configTable) do
	if typeof(loopEntry) == "RBXScriptConnection" then
		pcall(function()
			loopEntry:Disconnect()
		end)
	elseif type(loopEntry) == "thread" then
		pcall(coroutine.close, loopEntry)
	end
end

configTable = {}
end)
end

registerConnection = function()
local item1 = PlotState
local stateFlag

if PlotState then
stateFlag = PlotState.enabled == true
else
stateFlag = item1
end

if stateFlag then
PlotState.enabled = false
end

task.delay(0.35, function()
if stateFlag and PlotState then
	PlotState.enabled = true
end
end)

if dropMode == "STAND" then
setupListener()
else
disconnectHandler()
end

local item2 = fn40()
local desync

if item2 then
desync = CombatState.desync or CombatState.aimbot
else
desync = item2
end

if desync then
task.spawn(function()
	task.wait(0.06)
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	humanoidRootPart.CFrame = CFrame.new(item2.Position + Vector3.new(0, 0.9, 0))
	humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, -200, 0)
	humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	fn43()
	task.wait(0.08)
	fn43()
end)
end
end
end

do
local vX7BatCounter, stateFlag, calcVal1, disconnectHandler

do
tpMode = "half"

_G._VezyBatSlapList = {
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

_G._VezyGetBat = function()
local character = localPlayer.Character
if not character then
	return nil
end

for _, loopItem in ipairs(_G._VezyBatSlapList) do
	local item2 = character:FindFirstChild(loopItem)
	if item2 and item2:IsA("Tool") then
		return item2
	end
end

local backpack = localPlayer:FindFirstChildOfClass("Backpack")

if backpack then
	for _, loopItem in ipairs(_G._VezyBatSlapList) do
		local item2 = backpack:FindFirstChild(loopItem)

		if item2 and item2:IsA("Tool") then
			local item3 = character:FindFirstChildOfClass("Humanoid")

			if item3 then
				pcall(function()
					item3:EquipTool(item2)
				end)
			end

			return item2
		end
	end
end

for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
		return child
	end
end

if backpack then
	for _, child in ipairs(backpack:GetChildren()) do
		if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				pcall(function()
					humanoid:EquipTool(child)
				end)
			end

			return child
		end
	end
end

return nil
end

vX7BatCounter = { Enabled = false, Connection = nil }

if _G.VX7BatCounter and type(_G.VX7BatCounter.Stop) == "function" then
pcall(_G.VX7BatCounter.Stop)
end

_G._VezyBatCounterOn = false
stateFlag = false
calcVal1 = 0

do
local configTable = {
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

disconnectHandler = function()
	local character = localPlayer.Character
	if not character then
		return nil
	end
	local backpack = localPlayer:FindFirstChildOfClass("Backpack")

	for _, loopItem in ipairs(configTable) do
		local item2 = character:FindFirstChild(loopItem) or backpack and backpack:FindFirstChild(loopItem)
		if item2 then
			return item2
		end
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and child.Name:lower():find("bat") then
			return child
		end
	end

	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") and child.Name:lower():find("bat") then
				return child
			end
		end
	end

	return nil
end
end
end

do
local function setupListener(arg)
local huge = math.huge
local item1 = nil

for _, player in ipairs(service:GetPlayers()) do
	if player ~= localPlayer and player.Character then
		local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
		local item2 = player.Character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart and item2 and item2.Health > 0 then
			local magnitude = (humanoidRootPart.Position - arg).Magnitude

			if magnitude < huge then
				huge = magnitude
				item1 = player
			end
		end
	end
end

return item1
end

local function processInput()
if not vX7BatCounter.Enabled or stateFlag then
	return
end
local currentTime = os.clock()
if currentTime - calcVal1 < 0.1 then
	return
end
stateFlag = true
calcVal1 = currentTime

task.spawn(function()
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not character or not humanoidRootPart or not humanoid then
		stateFlag = false
		return
	end
	local item2 = setupListener(humanoidRootPart.Position)
	if not item2 then
		stateFlag = false
		return
	end
	local item3 = disconnectHandler()

	if item3 then
		if item3.Parent ~= character then
			pcall(function()
				humanoid:EquipTool(item3)
			end)
		end

		task.wait(0.02)
	end

	local character2 = localPlayer.Character
	local item4 = character2 and character2:FindFirstChild("HumanoidRootPart")
	humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
	local character3 = item2.Character
	character3 = character3 and character3:FindFirstChild("HumanoidRootPart")
	if not character2 or not item4 or not humanoid or not character3 then
		stateFlag = false
		return
	end
	humanoid.AutoRotate = false
	local position = character3.Position
	local vector = Vector3.new(position.X, item4.Position.Y, position.Z)

	if (vector - item4.Position).Magnitude > 0.001 then
		pcall(function()
			item4.RotVelocity = Vector3.zero
			item4.AssemblyAngularVelocity = Vector3.zero
			item4.CFrame = CFrame.lookAt(item4.Position, vector)
		end)
	end

	task.wait(0.03)
	local item5 = disconnectHandler()

	if item5 and item5.Parent == character2 then
		pcall(function()
			item5:Activate()
			local remoteEvent = item5:FindFirstChildWhichIsA("RemoteEvent")

			if remoteEvent then
				remoteEvent:FireServer()
			end
		end)
	end

	task.wait(0.2)

	if item4 and item4.Parent then
		item4.RotVelocity = Vector3.zero
		item4.AssemblyAngularVelocity = Vector3.zero
	end

	if humanoid and humanoid.Parent then
		humanoid.AutoRotate = true
	end

	stateFlag = false
end)
end

vX7BatCounter.Start = function()
vX7BatCounter.Enabled = true
if vX7BatCounter.Connection then
	return
end
local checkFlag = false

vX7BatCounter.Connection = safeConnect(RunService.Heartbeat, function()
	if not vX7BatCounter.Enabled then
		checkFlag = false
		return
	end
	local character = localPlayer.Character
	character = character and character:FindFirstChildOfClass("Humanoid")
	if not character then
		checkFlag = false
		return
	end
	local physics = Enum.HumanoidStateType.Physics
	local matchFlag = character:GetState() == physics

	if matchFlag and not checkFlag and not stateFlag then
		processInput()
	end

	checkFlag = matchFlag
end)
end
end

vX7BatCounter.Stop = function()
vX7BatCounter.Enabled = false
stateFlag = false

if vX7BatCounter.Connection then
vX7BatCounter.Connection:Disconnect()
vX7BatCounter.Connection = nil
end
end

vX7BatCounter.SetEnabled = function(arg)
if arg then
vX7BatCounter.Start()
else
vX7BatCounter.Stop()
end
end

_G.VezyStartBatCounter = function()
_G._VezyBatCounterOn = true
vX7BatCounter.Start()
end

_G.VezyStopBatCounter = function()
_G._VezyBatCounterOn = false
vX7BatCounter.Stop()
end

_G.VX7BatCounter = vX7BatCounter
end
end

do
local calcVal1 = 25
local currentTime = 0
local stateFlag = false
statusFlag = false
local configTable = {}
local disconnectHandler = nil
resetMovers = nil

local function setupListener()
local function processInput()
local character = localPlayer.Character
if not character then
return nil
end

for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") then
	local strName = child.Name:lower()
	if strName:find("medusa") or strName:find("head") or strName:find("stone") then
		return child
	end
end
end

local backpack = localPlayer:FindFirstChild("Backpack")

if backpack then
for _, child in ipairs(backpack:GetChildren()) do
	if child:IsA("Tool") then
		local strName = child.Name:lower()
		if strName:find("medusa") or strName:find("head") or strName:find("stone") then
			return child
		end
	end
end
end

return nil
end

local function createOrResetBillboard()
if stateFlag then
return
end

if tick() - currentTime < calcVal1 then
return
end
local character = localPlayer.Character
if not character then
return
end
stateFlag = true
local item1 = processInput()
if not item1 then
stateFlag = false
return
end

if item1.Parent ~= character then
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
	humanoid:EquipTool(item1)
end
end

pcall(function()
item1:Activate()
end)

currentTime = tick()
stateFlag = false
end

resetMovers = function()
for _, item1 in pairs(configTable) do
pcall(function()
	item1:Disconnect()
end)
end

configTable = {}
end

disconnectHandler = function(arg)
resetMovers()
if not arg then
return
end

local function checkAnchored(arg2)
return arg2:GetPropertyChangedSignal("Anchored"):Connect(function()
	if statusFlag and arg2.Anchored and arg2.Transparency == 1 then
		createOrResetBillboard()
	end
end)
end

for _, descendant in ipairs(arg:GetDescendants()) do
if descendant:IsA("BasePart") then
	table.insert(configTable, checkAnchored(descendant))
end
end

table.insert(configTable, arg.DescendantAdded:Connect(function(descendant)
if descendant:IsA("BasePart") then
	table.insert(configTable, checkAnchored(descendant))
end
end))
end
end

setupListener()

clearMovers = function()
statusFlag = true

if localPlayer.Character then
disconnectHandler(localPlayer.Character)
end
end

safeConnect(localPlayer.CharacterAdded, function(arg)
task.wait(0.1)

if statusFlag then
disconnectHandler(arg)
end
end)
end
end

do
local Lighting, configTable, stateFlag, disconnectHandler

do
do
local LaggerState, setupListener, processInput, createOrResetBillboard, checkAnchored, checkHumanoidPhysics

do
LaggerState = {
rangeCircle = nil,
connection = nil,
enabled = false,
lastFireTime = 0,
lastCounterTime = 0,
}

_G._AdaptAutoMedusaRange = tonumber(_G._AdaptAutoMedusaRange) or 8

setupListener = function()
local character = localPlayer.Character
character = character and character:FindFirstChild("HumanoidRootPart")
if not character then
	return nil
end
local huge = math.huge
local num = tonumber(_G._AdaptAutoMedusaRange) or 3
local item1 = nil

for _, player in ipairs(service:GetPlayers()) do
	if player ~= localPlayer and player.Character then
		local character2 = player.Character
		local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
		local humanoid = character2:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart and humanoid and humanoid.Health > 0 then
			local magnitude = (character.Position - humanoidRootPart.Position).Magnitude

			if magnitude < huge and magnitude <= num then
				huge = magnitude
				item1 = player
			end
		end
	end
end

return item1
end

processInput = function()
if LaggerState.rangeCircle then
	pcall(function()
		LaggerState.rangeCircle:Destroy()
	end)

	LaggerState.rangeCircle = nil
end

local medusaRangeIndicator = workspace:FindFirstChild("MedusaRangeIndicator")

if medusaRangeIndicator then
	pcall(function()
		medusaRangeIndicator:Destroy()
	end)
end
end

createOrResetBillboard = function()
processInput()
local num = tonumber(_G._AdaptAutoMedusaRange) or 3
local part = Instance.new("Part")
part.Name = "MedusaRangeIndicator"
part.Shape = Enum.PartType.Cylinder
part.Size = Vector3.new(0.2, num * 2, num * 2)
part.Material = Enum.Material.Neon
part.Color = Color3.fromRGB(255, 50, 50)
part.Transparency = 0
part.CanCollide = false
part.CanQuery = false
part.CastShadow = false
part.Anchored = true
part.Parent = workspace
LaggerState.rangeCircle = part
end

checkAnchored = function()
if not LaggerState.enabled or not LaggerState.rangeCircle then
	return
end
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
	return
end
local calcVal1 = tonumber(_G._AdaptAutoMedusaRange) or 8
local vector = Vector3.new(0.2, calcVal1 * 2, calcVal1 * 2)

if LaggerState.rangeCircle.Size ~= vector then
	LaggerState.rangeCircle.Size = vector
end

local position = humanoidRootPart.Position
LaggerState.rangeCircle.CFrame = CFrame.new(position.X, position.Y - 2.2, position.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
end

do
local function checkRagdoll(arg)
	local head = arg and arg:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then
		return false
	end

	if head.Transparency < 0.9 then
		return false
	end

	if head.Anchored then
		return true
	end
	local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
	return (humanoidRootPart and humanoidRootPart.Anchored) == true
end

checkHumanoidPhysics = function()
	if not LaggerState.enabled then
		return
	end
	local currentTime = tick()
	if currentTime - LaggerState.lastCounterTime < 2 then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end

	if not checkRagdoll(character) then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not item1 or item1.Health <= 0 then
		return
	end
	local medusaSHead = character:FindFirstChild("Medusa's Head")

	if not medusaSHead or not medusaSHead:IsA("Tool") then
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		medusaSHead = backpack and backpack:FindFirstChild("Medusa's Head")
		if not medusaSHead or not medusaSHead:IsA("Tool") then
			return
		end

		pcall(function()
			item1:EquipTool(medusaSHead)
		end)
	end

	LaggerState.lastCounterTime = currentTime

	pcall(function()
		medusaSHead:Activate()
	end)
end
end
end

do
local function checkRagdoll()
if not LaggerState.enabled then
	return
end
local currentTime = tick()
if currentTime - LaggerState.lastFireTime < 1 then
	return
end
local character = localPlayer.Character
if not character then
	return
end
local medusaSHead = character:FindFirstChild("Medusa's Head")
if not medusaSHead or not medusaSHead:IsA("Tool") then
	return
end

if not setupListener() then
	return
end
LaggerState.lastFireTime = currentTime

pcall(function()
	medusaSHead:Activate()
end)
end

cleanupSession = function()
if LaggerState.enabled then
	return
end
LaggerState.enabled = true
createOrResetBillboard()

if LaggerState.connection then
	LaggerState.connection:Disconnect()
end

LaggerState.connection = safeConnect(RunService.Heartbeat, function()
	checkAnchored()
	checkRagdoll()
	checkHumanoidPhysics()
end)
end
end

getStealMode = function()
LaggerState.enabled = false

if LaggerState.connection then
LaggerState.connection:Disconnect()
LaggerState.connection = nil
end

processInput()
end

_G._AdaptAutoMedusaRefresh = function()
if LaggerState.enabled then
createOrResetBillboard()
end
end

_G._AdaptAutoMedusa = {
Start = cleanupSession,
Stop = getStealMode,
IsEnabled = function()
return LaggerState.enabled
end,
}

safeConnect(localPlayer.CharacterAdded, function()
if LaggerState.enabled then
task.wait(0.1)
createOrResetBillboard()
end
end)
end

do
do
local checkFlag = false
local LaggerState = {}
local connection = nil

local function setupListener(arg)
if not arg:IsA("BasePart") then
	return false
end
local strName = arg.Name:lower()
local strTag = arg.Parent and arg.Parent.Name:lower() or ""
return strName:find("base") or strTag:find("base")
end

_G._AdaptXrayBase = {
Start = function()
	if not workspace:FindFirstChild("Plots") or checkFlag then
		return
	end
	checkFlag = true

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.Anchored and descendant.CanCollide and setupListener(descendant) then
			LaggerState[descendant] = descendant.LocalTransparencyModifier
			descendant.LocalTransparencyModifier = 0.85
		end
	end

	connection = workspace.DescendantAdded:Connect(function(descendant)
		if not checkFlag then
			return
		end

		if setupListener(descendant) then
			LaggerState[descendant] = descendant.LocalTransparencyModifier
			descendant.LocalTransparencyModifier = 0.85
		end
	end)
end,
Stop = function()
	checkFlag = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	for k, item1 in pairs(LaggerState) do
		if k and k.Parent then
			pcall(function()
				k.LocalTransparencyModifier = item1
			end)
		end
	end

	LaggerState = {}
end,
IsEnabled = function()
	return checkFlag
end,
}
end
end

do
local LaggerState = {
DFIntTaskSchedulerTargetFps = 999,
FIntRenderShadowIntensity = 0,
FIntRenderLocalLightUpdatesMax = 0,
DFIntTextureQualityOverride = 1,
DFIntTexturePoolSizeMB = 64,
DFIntMaxFrameBufferSize = 1,
DFIntParticleMaxCount = 100,
FFlagEnableWaterReflections = false,
DFIntWaterReflectionQuality = 0,
FIntRobloxGuiBlurIntensity = 0,
}

Lighting = game:GetService("Lighting")
configTable = {}
stateFlag = false

disconnectHandler = function()
if not setfflag then
return
end

for k, item1 in pairs(LaggerState) do
pcall(function()
	setfflag(k, tostring(item1))
end)
end
end
end
end

do
local Lighting2, aceShinyGraphics

do
do
do
local function setupListener()
	pcall(function()
		configTable.streamingEnabled = workspace.StreamingEnabled
		configTable.GlobalShadows = Lighting.GlobalShadows
		configTable.Brightness = Lighting.Brightness
		configTable.FogEnd = Lighting.FogEnd
		configTable.Technology = Lighting.Technology
		configTable.WaterWaveSize = workspace.Terrain.WaterWaveSize
		configTable.WaterWaveSpeed = workspace.Terrain.WaterWaveSpeed
		configTable.Decoration = workspace.Terrain.Decoration
	end)
end

local function processInput()
	pcall(function()
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant and descendant.Parent then
				if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
					descendant:Destroy()
				elseif descendant:IsA("PointLight") or descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight") then
					descendant:Destroy()
				elseif descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
					descendant:Destroy()
				elseif descendant:IsA("BasePart") then
					descendant.CastShadow = false
					descendant.Material = Enum.Material.Plastic
				end
			end
		end
	end)
end

_G._AdaptOptimizer = {
	Start = function()
		if stateFlag then
			return
		end
		stateFlag = true
		_G._AdaptOptimizerOn = true
		setupListener()
		pcall(disconnectHandler)

		pcall(function()
			workspace.StreamingEnabled = true
			workspace.StreamingMinRadius = 64
			workspace.StreamingTargetRadius = 256
			Lighting.GlobalShadows = false
			Lighting.Brightness = 3
			Lighting.FogEnd = 9e9
			Lighting.Technology = Enum.Technology.Legacy
			workspace.Terrain.WaterWaveSize = 0
			workspace.Terrain.WaterWaveSpeed = 0
			workspace.Terrain.Decoration = false
		end)

		task.spawn(processInput)

		if setfpscap then
			pcall(function()
				setfpscap(999)
			end)
		end
	end,
	Stop = function()
		if not stateFlag then
			return
		end
		stateFlag = false
		_G._AdaptOptimizerOn = false

		pcall(function()
			if configTable.streamingEnabled ~= nil then
				workspace.StreamingEnabled = configTable.streamingEnabled
			end

			if configTable.GlobalShadows ~= nil then
				Lighting.GlobalShadows = configTable.GlobalShadows
			end

			if configTable.Brightness ~= nil then
				Lighting.Brightness = configTable.Brightness
			end

			if configTable.FogEnd ~= nil then
				Lighting.FogEnd = configTable.FogEnd
			end

			if configTable.Technology ~= nil then
				Lighting.Technology = configTable.Technology
			end

			if configTable.WaterWaveSize ~= nil then
				workspace.Terrain.WaterWaveSize = configTable.WaterWaveSize
			end

			if configTable.WaterWaveSpeed ~= nil then
				workspace.Terrain.WaterWaveSpeed = configTable.WaterWaveSpeed
			end

			if configTable.Decoration ~= nil then
				workspace.Terrain.Decoration = configTable.Decoration
			end
		end)
	end,
	IsEnabled = function()
		return stateFlag
	end,
}
end
end

Lighting2 = game:GetService("Lighting")

_G.AceShinyGraphics = _G.AceShinyGraphics or {
shinyEnabled = false,
runtimeOn = false,
shinyConns = {},
shinyOriginals = {},
}

aceShinyGraphics = _G.AceShinyGraphics

do
local item1 = ipairs
local shinyConns = aceShinyGraphics.shinyConns or {}

for _, shinyConn in item1(shinyConns) do
pcall(function()
	shinyConn:Disconnect()
end)
end
end
end

aceShinyGraphics.shinyConns = {}
aceShinyGraphics.shinyOriginals = aceShinyGraphics.shinyOriginals or {}
aceShinyGraphics.runtimeOn = false
aceShinyGraphics.shinyEnabled = false

do
local function setupListener(arg)
pcall(function()
if arg:IsA("BasePart") then
	aceShinyGraphics.shinyOriginals[arg] = aceShinyGraphics.shinyOriginals[arg] or { Material = arg.Material, Reflectance = arg.Reflectance, CastShadow = arg.CastShadow }
	arg.Material = Enum.Material.SmoothPlastic
	arg.Reflectance = 0.75
	arg.CastShadow = false
end
end)
end

local function processInput(arg, name)
local instance = Lighting2:FindFirstChild(name)

if instance and not instance:IsA(arg) then
pcall(function()
	instance:Destroy()
end)

instance = nil
end

if not instance then
instance = Instance.new(arg)
instance.Name = name
instance.Parent = Lighting2
end

return instance
end

local function createOrResetBillboard()
local BloomEffect = processInput("BloomEffect", "AceShinyBloom")
BloomEffect.Intensity = 1.6
BloomEffect.Size = 52
BloomEffect.Threshold = 0.75
BloomEffect.Enabled = true
local SunRaysEffect = processInput("SunRaysEffect", "AceShinySunRays")
SunRaysEffect.Intensity = 0.55
SunRaysEffect.Spread = 1
SunRaysEffect.Enabled = true
local ColorCorrectionEffect = processInput("ColorCorrectionEffect", "AceShinyColorCorrection")
ColorCorrectionEffect.Saturation = 0.9
ColorCorrectionEffect.Contrast = 0.22
ColorCorrectionEffect.Brightness = 0.07
ColorCorrectionEffect.Enabled = true
end

removeAttachments = function()
VisualState.shiny = true
aceShinyGraphics.shinyEnabled = true
if aceShinyGraphics.runtimeOn then
pcall(createOrResetBillboard)
return
end
aceShinyGraphics.runtimeOn = true

for _, descendant in ipairs(workspace:GetDescendants()) do
setupListener(descendant)
end

for _, shinyConn in ipairs(aceShinyGraphics.shinyConns) do
pcall(function()
	shinyConn:Disconnect()
end)
end

aceShinyGraphics.shinyConns = {}

table.insert(aceShinyGraphics.shinyConns, workspace.DescendantAdded:Connect(function(descendant)
if aceShinyGraphics.shinyEnabled then
	setupListener(descendant)
end
end))

pcall(createOrResetBillboard)
end
end

updateCharacterState = function()
VisualState.shiny = false
aceShinyGraphics.shinyEnabled = false
aceShinyGraphics.runtimeOn = false

for _, shinyConn in ipairs(aceShinyGraphics.shinyConns) do
pcall(function()
shinyConn:Disconnect()
end)
end

aceShinyGraphics.shinyConns = {}

for k, shinyOriginal in pairs(aceShinyGraphics.shinyOriginals) do
pcall(function()
k.Material = shinyOriginal.Material
k.Reflectance = shinyOriginal.Reflectance
k.CastShadow = shinyOriginal.CastShadow
end)
end

aceShinyGraphics.shinyOriginals = {}

for _, loopItem in ipairs({ "AceShinyBloom", "AceShinySunRays", "AceShinyColorCorrection" }) do
local item2 = Lighting2:FindFirstChild(loopItem)

if item2 then
pcall(function()
	item2:Destroy()
end)
end
end
end
end
end

do
do
do
local Lighting = game:GetService("Lighting")
_G._RaVeDarkMode = _G._RaVeDarkMode or { enabled = false, saved = nil }

if type(_G._RaVeDarkLevel) ~= "number" then
_G._RaVeDarkLevel = 2
end

_G._RaVeSetDarkLevel = function(arg)
_G._RaVeDarkLevel = math.clamp(tonumber(arg) or 2, 0.5, 6)

if _G._RaVeDarkMode and _G._RaVeDarkMode.enabled then
pcall(function()
	Lighting.ExposureCompensation = -_G._RaVeDarkLevel
end)
end
end

_G._RaVeSetDarkMode = function(arg)
local raVeDarkMode = _G._RaVeDarkMode

if arg == true then
if not raVeDarkMode.saved then
	raVeDarkMode.saved = {
		brightness = Lighting.Brightness,
		clock = Lighting.ClockTime,
		outdoor = Lighting.OutdoorAmbient,
		exposure = Lighting.ExposureCompensation,
	}
end

raVeDarkMode.enabled = true

pcall(function()
	local raVeDarkModeSky = Lighting:FindFirstChild("RaVeDarkModeSky")

	if not raVeDarkModeSky or not raVeDarkModeSky:IsA("Sky") then
		if raVeDarkModeSky then
			raVeDarkModeSky:Destroy()
		end

		raVeDarkModeSky = Instance.new("Sky")
		raVeDarkModeSky.Name = "RaVeDarkModeSky"
	end

	raVeDarkModeSky.SkyboxBk = "rbxassetid://159454299"
	raVeDarkModeSky.SkyboxDn = "rbxassetid://159454296"
	raVeDarkModeSky.SkyboxFt = "rbxassetid://159454293"
	raVeDarkModeSky.SkyboxLf = "rbxassetid://159454286"
	raVeDarkModeSky.SkyboxRt = "rbxassetid://159454289"
	raVeDarkModeSky.SkyboxUp = "rbxassetid://159454291"
	raVeDarkModeSky.Parent = Lighting
	Lighting.Brightness = 0
	Lighting.ClockTime = 0
	Lighting.ExposureCompensation = -(_G._RaVeDarkLevel or 2)
	Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
end)

return
end

raVeDarkMode.enabled = false

pcall(function()
local raVeDarkModeSky = Lighting:FindFirstChild("RaVeDarkModeSky")

if raVeDarkModeSky then
	raVeDarkModeSky:Destroy()
end

local saved = raVeDarkMode.saved

if saved then
	Lighting.Brightness = saved.brightness
	Lighting.ClockTime = saved.clock
	Lighting.ExposureCompensation = saved.exposure
	Lighting.OutdoorAmbient = saved.outdoor
end
end)

raVeDarkMode.saved = nil
end
end
end

do
local configTable = {
{ "GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000" },
{ "LargeReplicatorWrite5", "true" },
{ "LargeReplicatorEnabled9", "true" },
{ "AngularVelociryLimit", "360" },
{ "TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646" },
{ "S2PhysicsSenderRate", "15000" },
{ "DisableDPIScale", "true" },
{ "MaxDataPacketPerSend", "2147483647" },
{ "ServerMaxBandwith", "52" },
{ "PhysicsSenderMaxBandwidthBps", "20000" },
{ "MaxTimestepMultiplierBuoyancy", "2147483647" },
{ "SimOwnedNOUCountThresholdMillionth", "2147483647" },
{ "MaxMissedWorldStepsRemembered", "-2147483648" },
{
"CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth",
"1",
},
{ "StreamJobNOUVolumeLengthCap", "2147483647" },
{ "DebugSendDistInSteps", "-2147483648" },
{ "MaxTimestepMultiplierAcceleration", "2147483647" },
{ "LargeReplicatorRead5", "true" },
{ "SimExplicitlyCappedTimestepMultiplier", "2147483646" },
{ "GameNetDontSendRedundantNumTimes", "1" },
{
"CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent",
"1",
},
{ "CheckPVCachedRotVelThresholdPercent", "10" },
{ "LargeReplicatorSerializeRead3", "true" },
{
"ReplicationFocusNouExtentsSizeCutoffForPauseStuds",
"2147483647",
},
{
"CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth",
"1",
},
{ "GameNetDontSendRedundantDeltaPositionMillionth", "1" },
{ "InterpolationFrameVelocityThresholdMillionth", "5" },
{ "StreamJobNOUVolumeCap", "2147483647" },
{ "InterpolationFrameRotVelocityThresholdMillionth", "5" },
{ "WorldStepMax", "30" },
{ "TimestepArbiterHumanoidLinearVelThreshold", "1" },
{ "InterpolationFramePositionThresholdMillionth", "5" },
{ "TimestepArbiterHumanoidTurningVelThreshold", "1" },
{ "MaxTimestepMultiplierContstraint", "2147483647" },
{ "GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000" },
{ "CheckPVCachedVelThresholdPercent", "10" },
{ "TimestepArbiterOmegaThou", "1073741823" },
{ "MaxAcceptableUpdateDelay", "1" },
{ "LargeReplicatorSerializeWrite4", "true" },
}

_G._AdaptApplyLagbackFlags = function()
if not setfflag then
return false
end

for _, loopItem in ipairs(configTable) do
pcall(function()
setfflag(loopItem[1], loopItem[2])
end)
end

_G._AdaptLagbackApplied = true
return true
end
end
end

do
local function disconnectHandler()
pcall(function()
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return
end
local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = { character }
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -500, 0), raycastParams)

if hit then
humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
humanoidRootPart.CFrame = CFrame.new(hit.Position.X, hit.Position.Y + (humanoid.HipHeight or 2) + humanoidRootPart.Size.Y / 2 + 0.1, hit.Position.Z)
humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
end
end)
end

local function setupListener()
pcall(function()
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return
end
local cframe = CFrame.Angles
local cFrame = humanoidRootPart.CFrame
humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z) * cframe(0, select(2, cFrame:ToEulerAnglesYXZ()), 0)
humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
end)
end

executeAction = function()
if tpMode == "full" then
setupListener()
else
disconnectHandler()
end
end
end
end

local disconnectHandler, configTable, setupListener, item1, processInput

do
do
local createOrResetBillboard

do
do
local item2

do
do
do
	PlotState = { enabled = false, height = 20 }

	do
		local item3 = nil

		createOrResetBillboard = function()
			if item3 then
				item3:Disconnect()
			end

			item3 = safeConnect(RunService.Heartbeat, function()
				if not PlotState.enabled then
					return
				end
				local character = localPlayer.Character
				if not character then
					return
				end

				if not (_G._CandyIsCarrying and _G._CandyIsCarrying(character)) then
					return
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = { character }
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -2000, 0), raycastParams)
				if not hit then
					return
				end

				if humanoidRootPart.Position.Y - hit.Position.Y > PlotState.height then
					executeAction()
				end
			end)
		end

		disconnectHandler = function()
			if item3 then
				item3:Disconnect()
				item3 = nil
			end
		end
	end
end

do
	local function checkAnchored()
		local Players = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local Workspace = game:GetService("Workspace")
		local localPlayer2 = Players.LocalPlayer
		_G._AdaptESPColor = Color3.fromRGB(46, 166, 255)
		local adaptESPColor = _G._AdaptESPColor
		_G._AdaptESPEnabled = false
		_G._AdaptESPShowHeader = true

		if _G._AdaptESPShowBox == nil then
			_G._AdaptESPShowBox = false
		end

		if type(_G._AdaptESPBoxFill) ~= "number" then
			_G._AdaptESPBoxFill = 0.72
		end

		_G._AdaptESPShowTracer = false
		local LaggerState = {}
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "AdaptESP_Visual"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = -1000

		pcall(function()
			screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
		end)

		if not screenGui.Parent then
			screenGui.Parent = localPlayer2:WaitForChild("PlayerGui")
		end

		local function createHighlight(arg, adornee)
			if not adornee then
				return
			end
			local adaptESPHl = adornee:FindFirstChild("AdaptESP_HL")

			if adaptESPHl then
				adaptESPHl:Destroy()
			end

			local adaptESPColor2 = _G._AdaptESPColor or adaptESPColor
			local highlight = Instance.new("Highlight")
			highlight.Name = "AdaptESP_HL"
			highlight.FillColor = adaptESPColor2
			highlight.OutlineColor = adaptESPColor2
			highlight.FillTransparency = 0.4
			highlight.OutlineTransparency = 1
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Enabled = _G._AdaptESPEnabled
			highlight.Adornee = adornee
			highlight.Parent = adornee
			return highlight
		end

		local function checkHumanoidPhysics(arg)
			local adaptESPColor2 = _G._AdaptESPColor or adaptESPColor
			local frame = Instance.new("Frame", screenGui)
			frame.Name = "ESP_BOX_" .. arg.Name
			frame.BackgroundColor3 = adaptESPColor2
			frame.BackgroundTransparency = _G._AdaptESPBoxFill or 0.72
			frame.BorderSizePixel = 0
			frame.Visible = false
			frame.ZIndex = 9999
			local uiStroke = Instance.new("UIStroke", frame)
			uiStroke.Color = adaptESPColor2
			uiStroke.Thickness = 1.6
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke.Enabled = _G._AdaptESPShowBox
			local frame2 = Instance.new("Frame", screenGui)
			frame2.Name = "ESP_TRACER_" .. arg.Name
			frame2.AnchorPoint = Vector2.new(0.5, 0.5)
			frame2.BackgroundColor3 = adaptESPColor2
			frame2.BackgroundTransparency = 0.05
			frame2.BorderSizePixel = 0
			frame2.Visible = false
			frame2.ZIndex = 9998
			local instance = Instance.new("TextLabel", screenGui)
			instance.Name = "ESP_DIRECTION_" .. arg.Name
			instance.AnchorPoint = Vector2.new(0.5, 0.5)
			instance.Size = UDim2.fromOffset(24, 24)
			instance.BackgroundTransparency = 1
			instance.Text = "▲"
			instance.TextColor3 = adaptESPColor2
			instance.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			instance.TextStrokeTransparency = 0.1
			instance.Font = Enum.Font.GothamBlack
			instance.TextSize = 21
			instance.Visible = false
			instance.ZIndex = 10002
			local frame3 = Instance.new("Frame", screenGui)
			frame3.Name = "Header"
			frame3.AnchorPoint = Vector2.new(0.5, 0.5)
			frame3.Position = UDim2.new(0, 0, 0, 0)
			frame3.Size = UDim2.new(0, 200, 0, 26)
			frame3.BackgroundTransparency = 1
			frame3.ZIndex = 10000
			local instance2 = Instance.new("TextLabel", frame3)
			instance2.Size = UDim2.new(1, 0, 1, 0)
			instance2.BackgroundTransparency = 1
			instance2.Text = "0"
			instance2.FontFace = font
			instance2.TextSize = 19
			instance2.TextStrokeTransparency = 0
			instance2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			instance2.ZIndex = 10001
			instance2.TextColor3 = Color3.fromRGB(255, 255, 255)
			local raVeTheme = _G._RaVeTheme or {}
			local uiGradient = Instance.new("UIGradient", instance2)
			uiGradient.Name = "SpeedGradient"
			local colorSequence = ColorSequence.new
			local dataTable = {}
			local item3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 228, 255))
			local item4 = ColorSequenceKeypoint.new(0.5, raVeTheme.accent or Color3.fromRGB(48, 160, 255))
			local item5 = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 108, 210)))
			dataTable[1] = item3
			dataTable[2] = item4

			do
				local values = table.pack(table.unpack(item5, 1, item5.n))
				table.move(values, 1, values.n, 3, dataTable)
			end

			uiGradient.Color = colorSequence(dataTable)
			return frame, instance2, frame2, frame3, instance
		end

		_G._AdaptRefreshESPColor = function(adaptESPColor2)
			_G._AdaptESPColor = adaptESPColor2
			adaptESPColor = adaptESPColor2

			for _, item3 in pairs(LaggerState) do
				if item3.box then
					local uiStroke = item3.box:FindFirstChildOfClass("UIStroke")

					if uiStroke then
						uiStroke.Color = adaptESPColor2
					end
				end

				if item3.tracer then
					item3.tracer.BackgroundColor3 = adaptESPColor2
				end

				if item3.offscreen then
					item3.offscreen.TextColor3 = adaptESPColor2
				end

				if item3.speedLbl then
					item3.speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				end

				if item3.hl then
					item3.hl.FillColor = adaptESPColor2
					item3.hl.OutlineColor = adaptESPColor2
				end
			end
		end

		local function checkRagdoll(arg)
			if arg == localPlayer2 then
				return
			end

			if LaggerState[arg] then
				return
			end
			local item3, item4, item5, item6, item7 = checkHumanoidPhysics(arg)
			local dataTable = { box = item3, speedLbl = item4, tracer = item5, header = item6, offscreen = item7, hl = nil }
			LaggerState[arg] = dataTable

			if arg.Character then
				dataTable.hl = createHighlight(arg, arg.Character)
			end

			dataTable.charConn = arg.CharacterAdded:Connect(function(character)
				task.wait(0.4)
				dataTable.hl = createHighlight(arg, character)
			end)
		end

		local function fn61(arg)
			local item3 = LaggerState[arg]
			if not item3 then
				return
			end

			if item3.charConn then
				pcall(function()
					item3.charConn:Disconnect()
				end)
			end

			if item3.box then
				pcall(function()
					item3.box:Destroy()
				end)
			end

			if item3.tracer then
				pcall(function()
					item3.tracer:Destroy()
				end)
			end

			if item3.offscreen then
				pcall(function()
					item3.offscreen:Destroy()
				end)
			end

			if item3.hl then
				pcall(function()
					item3.hl:Destroy()
				end)
			end

			LaggerState[arg] = nil
		end

		safeConnect(Players.PlayerAdded, function(arg)
			checkRagdoll(arg)
		end)

		safeConnect(Players.PlayerRemoving, fn61)

		task.spawn(function()
			while task.wait(2) do
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer2 then
						if not LaggerState[player] then
							pcall(checkRagdoll, player)
						else
							local item3 = LaggerState[player]
							local character = player.Character

							if character and (not item3.hl or item3.hl.Parent ~= character) then
								pcall(function()
									if item3.hl then
										item3.hl:Destroy()
									end
								end)

								item3.hl = createHighlight(player, character)
							end
						end
					end
				end
			end
		end)

		safeConnect(RunService2.RenderStepped, function()
			local currentCamera = Workspace.CurrentCamera
			if not currentCamera then
				return
			end
			local viewportSize = currentCamera.ViewportSize
			local character = localPlayer2.Character
			character = character and character:FindFirstChild("HumanoidRootPart")
			local calcVal1 = nil
			local calcVal2 = nil

			if character then
				local item3 = currentCamera:WorldToViewportPoint(character.Position + Vector3.new(0, -0.5, 0))
				calcVal1 = nil
				calcVal2 = nil

				if 0 < item3.Z then
					calcVal1 = math.clamp(item3.X, 10, viewportSize.X - 10)
					calcVal2 = math.clamp(item3.Y, 10, viewportSize.Y - 10)
				end
			end

			if not calcVal1 then
				calcVal1 = viewportSize.X / 2
				calcVal2 = viewportSize.Y * 0.85
			end

			for k, item3 in pairs(LaggerState) do
				local character2 = k.Character
				local item4 = character2 and character2:FindFirstChild("HumanoidRootPart")
				character2 = character2 and character2:FindFirstChildOfClass("Humanoid")

				if not item4 or not character2 or character2.Health <= 0 then
					item3.box.Visible = false
					item3.tracer.Visible = false
					item3.offscreen.Visible = false
				else
					local calcVal3 = item4.Position + Vector3.new(0, 3.2, 0)
					local calcVal4 = item4.Position + Vector3.new(0, -3, 0)
					local item5 = currentCamera:WorldToViewportPoint(calcVal3)
					local item6 = currentCamera:WorldToViewportPoint(calcVal4)

					if item5.Z > 0 then
						local calcVal5 = math.abs(item6.Y - item5.Y)
						local calcVal6 = calcVal5 * 0.55
						local calcVal7 = (item5.X + item6.X) / 2
						local calcVal8 = (item5.Y + item6.Y) / 2
						item3.box.Position = UDim2.new(0, calcVal7 - calcVal6 / 2, 0, calcVal8 - calcVal5 / 2)
						item3.box.Size = UDim2.new(0, calcVal6, 0, calcVal5)
						item3.box.Visible = _G._AdaptESPShowBox
						item3.header.Position = UDim2.new(0, calcVal7, 0, calcVal8 - calcVal5 / 2 - 16)
						local calcVal9 = calcVal7 - calcVal1
						local calcVal10 = calcVal8 - calcVal2
						local item7 = math.sqrt(calcVal9 * calcVal9 + calcVal10 * calcVal10)
						item3.tracer.Position = UDim2.new(0, (calcVal1 + calcVal7) / 2, 0, (calcVal2 + calcVal8) / 2)
						item3.tracer.Size = UDim2.new(0, item7, 0, 1)
						item3.tracer.Rotation = math.deg(math.atan2(calcVal10, calcVal9))
						item3.tracer.Visible = _G._AdaptESPShowTracer
						item3.offscreen.Visible = false
						local assemblyLinearVelocity = item4.AssemblyLinearVelocity or item4.Velocity
						item3.speedLbl.Text = string.format("%d", math.floor(Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude + 0.5))
						item3.header.Visible = true
					else
						item3.box.Visible = false
						item3.header.Visible = false
						local item7 = currentCamera:WorldToViewportPoint(item4.Position)
						local calcVal5 = viewportSize.X * 0.5
						local calcVal6 = viewportSize.Y * 0.5
						local x = item7.X
						local y = item7.Y

						if item7.Z <= 0 then
							x = viewportSize.X - x
							y = viewportSize.Y - y
						end

						local calcVal7 = x - calcVal5
						local calcVal8 = y - calcVal6

						if math.abs(calcVal7) < 0.001 and math.abs(calcVal8) < 0.001 then
							calcVal8 = -1
						end

						local calcVal9 = math.min((calcVal5 - 30) / math.max(math.abs(calcVal7), 0.001), (calcVal6 - 10) / math.max(math.abs(calcVal8), 0.001))
						local calcVal10 = calcVal5 + calcVal7 * calcVal9
						local clampedTracerY = calcVal6 + calcVal8 * calcVal9
						local deltaTracerX = calcVal10 - calcVal1
						local deltaTracerY = clampedTracerY - calcVal2
						local tracerDistance = math.sqrt(deltaTracerX * deltaTracerX + deltaTracerY * deltaTracerY)
						item3.tracer.Position = UDim2.fromOffset((calcVal1 + calcVal10) * 0.5, (calcVal2 + clampedTracerY) * 0.5)
						item3.tracer.Size = UDim2.fromOffset(tracerDistance, 1)
						item3.tracer.Rotation = math.deg(math.atan2(deltaTracerY, deltaTracerX))
						item3.tracer.Visible = _G._AdaptESPShowTracer
						item3.offscreen.Position = UDim2.fromOffset(calcVal10, clampedTracerY)
						item3.offscreen.Rotation = math.deg(math.atan2(calcVal8, calcVal7)) + 90
						item3.offscreen.Visible = false
					end
				end
			end
		end)

		_G._AdaptESPSetEnabled = function(arg)
			_G._AdaptESPEnabled = arg and true or false

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer2 and not LaggerState[player] then
					pcall(checkRagdoll, player)
				end
			end

			for _, item3 in pairs(LaggerState) do
				if item3.hl then
					item3.hl.Enabled = _G._AdaptESPEnabled
				end
			end
		end

		_G._AdaptESPSetShowHeader = function(arg)
			_G._AdaptESPShowHeader = arg and true or false
		end

		_G._AdaptESPSetShowTracer = function(arg)
			_G._AdaptESPShowTracer = arg and true or false
		end

		_G._AdaptESPSetShowBox = function(arg)
			_G._AdaptESPShowBox = arg and true or false
		end

		_G._AdaptESPSetShowHeader = function(arg)
			_G._AdaptESPShowHeader = arg and true or false
		end

		_G._RaVeRagdollCountdown = _G._RaVeRagdollCountdown ~= false

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer2 then
				pcall(checkRagdoll, player)
			end
		end

		_G._AdaptESPSetEnabled(false)
	end

	checkAnchored()
end
end

do
local strName

do
	fn39()

	task.spawn(function()
		task.wait(1)

		if _G._AdaptAnimPack and _G._AdaptAnimPack ~= "Off" then
			pcall(_G._RaVeApplySelectedAnimation, _G._AdaptAnimPack)
		end
	end)

	item2 = localPlayer
	strName = "VlonE_Mobile_Global_" .. tostring(localPlayer.UserId) .. ".json"
	configTable = { on = {}, keys = {} }

	do
		local stateFlag = false

		pcall(function()
			if isfile and isfile(strName) then
				local data = HttpService:JSONDecode(readfile(strName))

				if type(data) == "table" then
					stateFlag = data.startupVersion == 2

					if type(data.on) == "table" then
						configTable.on = data.on
					end

					if type(configTable.on) == "table" then
						configTable.on["Auto Left"] = nil
						configTable.on["Auto Right"] = nil
						configTable.on["Bat Aimbot"] = nil
						configTable.on["Desync Aimbot"] = nil
					end

					if type(data.keys) == "table" then
						configTable.keys = data.keys
					end

					if type(data.NS) == "number" then
						SpeedState.NS = data.NS
					end

					if type(data.CS) == "number" then
						SpeedState.CS = data.CS
					end

					if type(data.LG_N) == "number" then
						SpeedState.LG_N = data.LG_N
					end

					if type(data.LG_C) == "number" then
						SpeedState.LG_C = data.LG_C
					end

					if type(data.aimSpd) == "number" then
						CombatState.aimSpd = data.aimSpd
					end

					if type(data.laggerAimSpd) == "number" then
						CombatState.laggerAimSpd = data.laggerAimSpd
					end

					if type(data.fovVal) == "number" then
						VisualState.fovVal = data.fovVal
					end

					if type(data.stretchValue) == "number" then
						VisualState.stretchValue = math.clamp(data.stretchValue, 0.3, 1.5)
					end

					if data.autoCarryVersion == "V1" or data.autoCarryVersion == "V2" then
						_G._AdaptAutoCarryVersion = data.autoCarryVersion
					end

					if type(data.autoCarryV2Range) == "number" then
						_G._AdaptAutoCarryV2Range = data.autoCarryV2Range
					end

					if type(data.tpH) == "number" and PlotState then
						PlotState.height = data.tpH
					end

					if type(data.rad) == "number" then
						StealConfig.StealRadius = data.rad
					end

					if type(data.semiR) == "number" and _G._KawatanStealRadii then
						_G._KawatanStealRadii.Semi = data.semiR
					end

					if type(data.uiScale) == "number" then
						_G._AdaptUIScale = math.clamp(data.uiScale, 20, 200)
					end

					if data.batMode == "DEFAULT" or data.batMode == "BYPASS" then
						_G._AdaptBatMode = data.batMode
					end

					if data.tpBatMode == "SURE HIT" or data.tpBatMode == "HIGH PING" then
						_G._AdaptTpBatMode = data.tpBatMode
					end

					if data.stealMode == "NORMAL" or data.stealMode == "SEMI" then
						_G._AdaptStealMode = data.stealMode
					end

					if type(data.autoMedusaRange) == "number" then
						_G._AdaptAutoMedusaRange = data.autoMedusaRange
					end

					if type(data.stealRadii) == "table" then
						_G._KawatanStealRadii = _G._KawatanStealRadii or {}

						for _, loopElem in ipairs({ "normalV1", "normalV2", "normalV3", "semiV1", "semiV2" }) do
							if type(data.stealRadii[loopElem]) == "number" then
								_G._KawatanStealRadii[loopElem] = data.stealRadii[loopElem]
							end
						end
					end

					if data.layoutMode == "SCROLL" or data.layoutMode == "SIDE" or data.layoutMode == "TOP" or data.layoutMode == "BOTTOM" then
						_G._KuRuLayoutMode = data.layoutMode
					end

					if data.skinPreset == "RED" or data.skinPreset == "BLUE" or data.skinPreset == "PURPLE" or data.skinPreset == "GALAXY" then
						_G._VlonESkinPreset = "RED"
					end

					local kawatanSkinSets = _G._KawatanSkinSets

					if kawatanSkinSets then
						kawatanSkinSets = _G._KawatanSkinSets[data.skinSet or ""]
					end

					if kawatanSkinSets then
						_G._KawatanSkinColor = data.skinSet
					end

					if data.speedMethod == "V1" or data.speedMethod == "V2" then
						_G._RaVeSpeedMethod = data.speedMethod
					end

					if data.korbloxMode == "Off" or data.korbloxMode == "Left" or data.korbloxMode == "Right" or data.korbloxMode == "Both" then
						_G._RaVeKorbloxMode = data.korbloxMode
					end

					if type(data.korbloxUserSet) == "boolean" then
						_G._KawatanKorbloxUserSet = data.korbloxUserSet
					end

					if type(data.headless) == "boolean" then
						_G._VlonEStandaloneHeadless = data.headless
					end

					local checkFlag = data.bodyType == "OFF"

					if not checkFlag then
						checkFlag = _G._KawatanBodyTypes

						if checkFlag then
							checkFlag = _G._KawatanBodyTypes[data.bodyType or ""]
						end
					end

					if checkFlag then
						_G._VlonEBodyType = data.bodyType
					end

					if data.identityMode == "PLAYER" or data.identityMode == "KURU" then
						_G._KuRuIdentityMode = data.identityMode
					end

					if data.tabBackground == "OFF" or data.tabBackground == "1" or data.tabBackground == "2" then
						_G._KuRuTabBackground = data.tabBackground
					end

					if data.contentBackground == "OFF" or data.contentBackground == "1" or data.contentBackground == "2" or data.contentBackground == "3" or data.contentBackground == "4" then
						_G._KuRuContentBackground = data.contentBackground
					end

					AutoState.auto = true

					if type(data.uiKey) == "string" then
						configTable.uiKey = data.uiKey
					end

					if type(data.uiHidden) == "boolean" then
						configTable.uiHidden = data.uiHidden
					end

					if type(data.logoStyle) == "string" then
						_G._KawatanLogoStyle = data.logoStyle
					end
				end
			end
		end)

		if not stateFlag then
			do
				do
					configTable.on = { ["Infinite Jump"] = true }

					do
						local item3 = _G
						local item4 = _G
						local item5 = false
						local item6 = false
						_G._loadedOn_antiRag = false
						item3._loadedOn_autoTP = item5
						item4._loadedOn_autoSteal = item6
					end
				end

				do
					local item3 = _G
					_G._loadedOn_batAimbot = false
					item3._loadedOn_desyncAimbot = false
				end
			end

			do
				do
					local item3 = _G
					_G._loadedOn_autoLeft = false
					item3._loadedOn_autoRight = false
				end

				do
					local item3 = _G
					_G._loadedOn_autoSwing = false
					item3._loadedOn_desyncSwing = false
				end

				do
					local item3 = _G
					_G._loadedOn_fov = false
					item3._loadedOn_stretch = false
				end
			end

			do
				local item3 = _G
				_G._loadedOn_antiLag = false
				item3._loadedOn_potato = false
			end

			do
				local item3 = _G
				local item4 = _G
				_G._loadedOn_autoCarry = false
				item3._loadedOn_esp = false
				item4._loadedOn_showTracer = false
			end

			_G._loadedOn_infJump = true
		end
	end
end

configTable.on["Animated Galaxy"] = true
_G._VlonEUIGalaxyEnabled = true
_G._VlonEUIMoneyRainEnabled = true
_G._KuRuLayoutMode = "TOP"

setupListener = function(arg, arg2)
	local item3 = configTable.on[arg]
	if type(item3) == "boolean" then
		return item3
	end
	return arg2 or false
end

do
	local stateFlag = false
	_G._VlSave1 = vlSave1

	vlSave1 = function()
		if _G._RaVeSettingsReset then
			return false
		end

		if not writefile then
			return false
		end

		if stateFlag then
			return
		end
		stateFlag = true

		task.defer(function()
			stateFlag = false
			if _G._RaVeSettingsReset then
				return
			end

			local LaggerState = {
				startupVersion = 2,
				NS = SpeedState.NS,
				CS = SpeedState.CS,
				LG_N = SpeedState.LG_N,
				LG_C = SpeedState.LG_C,
				aimSpd = CombatState.aimSpd,
				laggerAimSpd = CombatState.laggerAimSpd or 40,
				fovVal = VisualState.fovVal,
				stretchValue = VisualState.stretchValue or 0.78,
				autoCarryVersion = _G._AdaptAutoCarryVersion or "V1",
				autoCarryV2Range = _G._AdaptAutoCarryV2Range or 15,
				tpH = PlotState and PlotState.height or 20,
				rad = StealConfig.StealRadius,
				dur = StealConfig.StealDuration,
				semiR = (_G._KawatanStealRadii or {}).Semi or 10,
				batMode = _G._AdaptBatMode or "DEFAULT",
				tpBatMode = _G._AdaptTpBatMode or "HIGH PING",
				stealMode = _G._AdaptStealMode or "NORMAL",
				autoMedusaRange = _G._AdaptAutoMedusaRange or 8,
				stealRadii = _G._KawatanStealRadii or nil,
				layoutMode = _G._KuRuLayoutMode or "SCROLL",
				skinPreset = _G._VlonESkinPreset or "RED",
				skinSet = _G._KawatanSkinColor or "PURPLE",
				speedMethod = _G._RaVeSpeedMethod or "V2",
				korbloxMode = _G._RaVeKorbloxMode or "Off",
				korbloxUserSet = _G._KawatanKorbloxUserSet == true,
				headless = _G._VlonEStandaloneHeadless == true,
				logoStyle = _G._KawatanLogoStyle or "ORIGINAL",
				bodyType = _G._VlonEBodyType or "OFF",
				identityMode = _G._KuRuIdentityMode or "PLAYER",
				tabBackground = _G._KuRuTabBackground or "1",
				contentBackground = _G._KuRuContentBackground or "1",
			}

			LaggerState.uiScale = math.clamp(tonumber(_G._AdaptUIScale) or 100, 20, 200)
			LaggerState.autoSave = AutoState.auto
			LaggerState.uiKey = configTable.uiKey
			LaggerState.uiHidden = configTable.uiHidden == true
			LaggerState.on = configTable.on
			LaggerState.keys = configTable.keys

			pcall(function()
				writefile(strName, HttpService:JSONEncode(LaggerState))
			end)

			pcall(_G._VlSave1)
		end)

		return true
	end
end
end
end

do
do
task.spawn(function()
	while task.wait(8) do
		pcall(vlSave1)
	end
end)

_G._KawatanLogoAssets = {
	ORIGINAL = "rbxassetid://140336058396219",
	["STYLE 2"] = "rbxassetid://106176805732332",
}

_G._KawatanLogoOrder = { "ORIGINAL", "STYLE 2" }

do
	local item3 = 60
	local color = Color3.fromRGB

	_G._KawatanLogoAccents = {
		ORIGINAL = {
			accent = Color3.fromRGB(48, 160, 255),
			fill = {
				Color3.fromRGB(74, 178, 255),
				color(item3, 108, 220),
			},
		},
		["STYLE 2"] = {
			accent = Color3.fromRGB(58, 214, 255),
			fill = {
				Color3.fromRGB(96, 236, 255),
				color(0, 148, 235),
			},
		},
	}
end
end

if not _G._KawatanLogoAssets[_G._KawatanLogoStyle or ""] then
_G._KawatanLogoStyle = nil
end

_G._KawatanLogoStyle = _G._KawatanLogoStyle or "ORIGINAL"

_G._KawatanApplyAccent = function(arg)
local original = _G._KawatanLogoAccents[arg or ""] or _G._KawatanLogoAccents.ORIGINAL
_G._KawatanAccent = original.accent
if type(_G._RaVeTheme) == "table" then
	_G._RaVeTheme.accent = original.accent
end

if _G._AdaptRefreshESPColor then
	pcall(_G._AdaptRefreshESPColor, original.accent)
end

if _G._KawatanStealBarSetAccent then
	pcall(_G._KawatanStealBarSetAccent, original.fill)
end
end

_G._KawatanApplyAccent(_G._KawatanLogoStyle)

do
local function checkAnchored()
	local color = Color3.fromRGB(10, 7, 12)
	local color2 = Color3.fromRGB(12, 15, 24)
	local color3 = Color3.fromRGB(19, 25, 39)
	local color4 = Color3.fromRGB(26, 34, 42)
	local color5 = Color3.fromRGB(234, 241, 255)
	local color6 = Color3.fromRGB(118, 134, 166)
	local color7 = Color3.fromRGB(5, 7, 12)
	local color8 = Color3.fromRGB(48, 160, 255)
	local color9 = Color3.fromRGB(16, 24, 33)
	local LaggerState = {}
	local calcVal1 = 0

	local function checkHumanoidPhysics()
		return _G._KawatanAccent or color8
	end

	local function checkRagdoll(arg, arg2, arg3, arg4)
		table.insert(LaggerState, { inst = arg, prop = arg2, cond = arg3, wave = arg4 ~= false })

		if not arg3 or arg3() then
			pcall(function()
				arg[arg2] = checkHumanoidPhysics()
			end)
		end
	end

	local function fn61()
		local colorSequence = ColorSequence.new
		local dataTable = {}
		local item3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 108, 230))
		local item4 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(74, 178, 255))
		local new = ColorSequenceKeypoint.new
		local item5 = 1
		local color10 = Color3.fromRGB
		dataTable[1] = item3
		dataTable[2] = item4

		do
			local values = table.pack(new(item5, color10(37, 115, 255)))
			table.move(values, 1, values.n, 3, dataTable)
		end

		return colorSequence(dataTable)
	end

	local function createInstance(arg, arg2, arg3)
		local instance = Instance.new(arg)
		local item3 = pairs
		arg2 = arg2 or {}

		for k, item4 in item3(arg2) do
			instance[k] = item4
		end

		local item4 = ipairs
		local dataTable = arg3 or {}

		for _, item5 in item4(dataTable) do
			item5.Parent = instance
		end

		return instance
	end

	local function createCorner(arg)
		return createInstance("UICorner", { CornerRadius = UDim.new(0, arg) })
	end

	local function createStroke(arg, arg2, arg3)
		return createInstance("UIStroke", {
			Color = arg,
			Thickness = arg2 or 1,
			Transparency = arg3 or 0,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
	end

	local function tweenElement(arg, arg2, arg3)
		if typeof(arg) == "Instance" then
			TweenService:Create(arg, arg2, arg3):Play()
		end
	end

	local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfo2 = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	return { CreateWindow = function(arg, arg2)
		local toggleKey = (arg2 or {}).ToggleKey or Enum.KeyCode.RightShift
		local calcVal2 = 520
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or localPlayer:FindFirstChild("PlayerGui")

		for _, container in ipairs({ game:GetService("CoreGui"), playerGui }) do
			if container then
				for _, guiName in ipairs({ "Vilon", "OSHA" }) do
					local oldGui = container:FindFirstChild(guiName)

					if oldGui and oldGui:IsA("ScreenGui") then
						pcall(function()
							oldGui:Destroy()
						end)
					end
				end
			end
		end

		local ScreenGui = createInstance("ScreenGui", {
			Name = "OSHA",
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 100000,
		})

		pcall(function()
			ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
		end)

		if not ScreenGui.Parent and playerGui then
			ScreenGui.Parent = playerGui
		end

		local obj = setmetatable({}, { __mode = "k" })

		local function updateWaypoints(descendant)
			if obj[descendant] then
				return
			end
			obj[descendant] = true

			pcall(function()
				descendant.Archivable = false
			end)

			descendant:GetPropertyChangedSignal("Archivable"):Connect(function()
				if descendant.Parent and descendant.Archivable then
					pcall(function()
						descendant.Archivable = false
					end)
				end
			end)
		end

		updateWaypoints(ScreenGui)

		for _, descendant in ipairs(ScreenGui:GetDescendants()) do
			updateWaypoints(descendant)
		end

		ScreenGui.DescendantAdded:Connect(updateWaypoints)

		pcall(function()
			ScreenGui:SetAttribute("_VlonEProtected", true)
		end)

		local udim2 = UDim2.new(0, 22, 0.5, -calcVal2 / 2)
		local item3 = createStroke(color8, 1, 0.55)

		local Frame = createInstance("Frame", {
			Parent = ScreenGui,
			Size = UDim2.fromOffset(380, 520),
			Position = udim2,
			BackgroundColor3 = color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true,
		}, { createCorner(20), item3 })

		checkRagdoll(item3, "Color")
		local item4 = createInstance
		local dataTable = { Parent = Frame, Name = "VilonUIScale" }
		local clamp = math.clamp
		local calcVal3 = tonumber(_G._AdaptUIScale) or 100
		local item5 = 100
		dataTable.Scale = clamp(calcVal3, 20, 200) / item5
		item4("UIScale", dataTable)
		local item6 = createInstance
		local itemTable = { Parent = Frame, Rotation = 90 }
		local colorSequence = ColorSequence.new
		local listTable = {}
		local item7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 19, 26))
		local item8 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(9, 10, 13))
		local new = ColorSequenceKeypoint.new
		local color10 = Color3.fromRGB
		listTable[1] = item7
		listTable[2] = item8

		do
			local values = table.pack(new(1, color10(11, 14, 20)))
			table.move(values, 1, values.n, 3, listTable)
		end

		itemTable.Color = colorSequence(listTable)
		item6("UIGradient", itemTable)

		local Frame2 = createInstance("Frame", {
			Parent = Frame,
			Name = "OSHALiquidGalaxy",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 0,
		}, { createCorner(20) })

		local item9 = createInstance

		local propTable = {
			Parent = createInstance("Frame", {
				Parent = Frame2,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.9,
				BorderSizePixel = 0,
				ZIndex = 0,
			}, { createCorner(20) }),
			Rotation = 28,
		}

		local colorSequence2 = ColorSequence.new
		local tempTable = {}
		local galaxyGradColor1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 10, 34))
		local galaxyGradColor2 = ColorSequenceKeypoint.new(0.28, Color3.fromRGB(4, 115, 255))
		local galaxyGradColor3 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(22, 18, 42))
		local galaxyGradColor4 = ColorSequenceKeypoint.new(0.78, Color3.fromRGB(34, 72, 126))
		local new2 = ColorSequenceKeypoint.new
		local color11 = Color3.fromRGB
		tempTable[1] = galaxyGradColor1
		tempTable[2] = galaxyGradColor2
		tempTable[3] = galaxyGradColor3
		tempTable[4] = galaxyGradColor4

		do
			local values = table.pack(new2(1, color11(19, 115, 255)))
			table.move(values, 1, values.n, 5, tempTable)
		end

		propTable.Color = colorSequence2(tempTable)
		local numberSequence = NumberSequence.new
		local seqTable = {}
		local galaxyGradTrans1 = NumberSequenceKeypoint.new(0, 0.12)
		local galaxyGradTrans2 = NumberSequenceKeypoint.new(0.5, 0.32)
		local new3 = NumberSequenceKeypoint.new
		seqTable[1] = galaxyGradTrans1
		seqTable[2] = galaxyGradTrans2

		do
			local values = table.pack(new3(1, 0.08))
			table.move(values, 1, values.n, 3, seqTable)
		end

		propTable.Transparency = numberSequence(seqTable)
		local UIGradient = createInstance("UIGradient", propTable)

		local subTable = {
			Parent = createInstance("Frame", {
				Parent = Frame2,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.95,
				BorderSizePixel = 0,
				ZIndex = 0,
			}, { createCorner(20) }),
			Rotation = 142,
		}

		local colorSequence3 = ColorSequence.new
		local entryTable = {}
		local nebulaGradColor1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 12, 31))
		local nebulaGradColor2 = ColorSequenceKeypoint.new(0.32, Color3.fromRGB(33, 115, 255))
		local nebulaGradColor3 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(20, 12, 52))
		local nebulaGradColor4 = ColorSequenceKeypoint.new(0.82, Color3.fromRGB(40, 106, 137))
		local new4 = ColorSequenceKeypoint.new
		local color12 = Color3.fromRGB
		entryTable[1] = nebulaGradColor1
		entryTable[2] = nebulaGradColor2
		entryTable[3] = nebulaGradColor3
		entryTable[4] = nebulaGradColor4

		do
			local values = table.pack(new4(1, color12(34, 14, 72)))
			table.move(values, 1, values.n, 5, entryTable)
		end

		subTable.Color = colorSequence3(entryTable)
		local numberSequence2 = NumberSequence.new
		local nebulaTransparencyKeypoints = {}
		local nebulaGradTrans1 = NumberSequenceKeypoint.new(0, 0.52)
		local nebulaGradTrans2 = NumberSequenceKeypoint.new(0.42, 0.08)
		local nebulaGradTrans3 = NumberSequenceKeypoint.new(0.7, 0.3)
		local new5 = NumberSequenceKeypoint.new
		nebulaTransparencyKeypoints[1] = nebulaGradTrans1
		nebulaTransparencyKeypoints[2] = nebulaGradTrans2
		nebulaTransparencyKeypoints[3] = nebulaGradTrans3

		do
			local values = table.pack(new5(1, 0.62))
			table.move(values, 1, values.n, 4, nebulaTransparencyKeypoints)
		end

		subTable.Transparency = numberSequence2(nebulaTransparencyKeypoints)
		local UIGradient2 = createInstance("UIGradient", subTable)

		local nebulaGradientProps = {
			Parent = createInstance("Frame", {
				Parent = Frame2,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.97,
				BorderSizePixel = 0,
				ZIndex = 0,
			}, { createCorner(20) }),
			Rotation = 72,
		}

		local colorSequence4 = ColorSequence.new
		local themeColorKeypoints = {}
		local themeGradColor1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 115, 255))
		local themeGradColor2 = ColorSequenceKeypoint.new(0.48, Color3.fromRGB(225, 218, 255))
		local themeGradColor3 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(112, 219, 255))
		local new6 = ColorSequenceKeypoint.new
		local color13 = Color3.fromRGB
		themeColorKeypoints[1] = themeGradColor1
		themeColorKeypoints[2] = themeGradColor2
		themeColorKeypoints[3] = themeGradColor3

		do
			local values = table.pack(new6(1, color13(19, 115, 255)))
			table.move(values, 1, values.n, 4, themeColorKeypoints)
		end

		nebulaGradientProps.Color = colorSequence4(themeColorKeypoints)
		local numberSequence3 = NumberSequence.new
		local mapTable = {}
		local themeGradTrans1 = NumberSequenceKeypoint.new(0, 1)
		local themeGradTrans2 = NumberSequenceKeypoint.new(0.44, 0.62)
		local themeGradTrans3 = NumberSequenceKeypoint.new(0.52, 0.18)
		local themeGradTrans4 = NumberSequenceKeypoint.new(0.61, 0.7)
		local new7 = NumberSequenceKeypoint.new
		mapTable[1] = themeGradTrans1
		mapTable[2] = themeGradTrans2
		mapTable[3] = themeGradTrans3
		mapTable[4] = themeGradTrans4

		do
			local values = table.pack(new7(1, 1))
			table.move(values, 1, values.n, 5, mapTable)
		end

		nebulaGradientProps.Transparency = numberSequence3(mapTable)
		local UIGradient3 = createInstance("UIGradient", nebulaGradientProps)

		task.spawn(function()
			while Frame2.Parent do
				local currentTime = os.clock()
				Frame2.Visible = _G._VlonEUIGalaxyEnabled ~= false

				if Frame2.Visible then
					UIGradient.Offset = Vector2.new(math.sin(currentTime * 0.13) * 0.34, math.cos(currentTime * 0.095) * 0.12)
					UIGradient2.Offset = Vector2.new(math.cos(currentTime * 0.105) * 0.3, math.sin(currentTime * 0.05) * 0.14)
					UIGradient3.Offset = Vector2.new(math.sin(currentTime * 0.07) * 0.48, 0)
					UIGradient.Rotation = 28 + math.sin(currentTime * 0.055) * 8
					UIGradient2.Rotation = 142 + math.cos(currentTime * 0.048) * 9
				end

				task.wait(0.1)
			end
		end)

		_G._VlonEUIGalaxyEnabled = _G._VlonEUIGalaxyEnabled ~= false

		local Frame3 = createInstance("Frame", {
			Parent = Frame,
			Name = "VlonEAnimatedGalaxy",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 1,
		}, { createCorner(20) })

		local galaxyRng = Random.new(9173)

		for i = 1, 18 do
			local starSize = galaxyRng:NextNumber(1.4, 4.2)

			local Frame4 = createInstance("Frame", {
				Parent = Frame3,
				Name = "GalaxyDot" .. i,
				Size = UDim2.fromOffset(starSize, starSize),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = galaxyRng:NextNumber(0.68, 0.88),
				BorderSizePixel = 0,
				ZIndex = 1,
			}, { createCorner(999) })

			local starGradProps = { Parent = Frame4, Rotation = i * 19 }
			local colorSequence5 = ColorSequence.new
			local paramTable = {}
			local starColor1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(104, 128, 255))
			local starColor2 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(61, 183, 255))
			local new8 = ColorSequenceKeypoint.new
			local color14 = Color3.fromRGB
			paramTable[1] = starColor1
			paramTable[2] = starColor2

			do
				local values = table.pack(new8(1, color14(86, 242, 226)))
				table.move(values, 1, values.n, 3, paramTable)
			end

			starGradProps.Color = colorSequence5(paramTable)
			createInstance("UIGradient", starGradProps)
			Frame4:SetAttribute("GalaxyX", galaxyRng:NextNumber(0.02, 0.98))
			Frame4:SetAttribute("GalaxyY", galaxyRng:NextNumber(0.05, 0.98))
			Frame4:SetAttribute("GalaxyDrift", galaxyRng:NextNumber(1.2, 3.8))
			Frame4:SetAttribute("GalaxySway", galaxyRng:NextNumber(3, 9))
			Frame4:SetAttribute("GalaxyPhase", galaxyRng:NextNumber(0, 6.2831853071795862))
			Frame4:SetAttribute("GalaxyAlpha", galaxyRng:NextNumber(0.68, 0.84))
			Frame4:SetAttribute("GalaxyTwinkle", 0.055)
		end

		task.spawn(function()
			while Frame3.Parent do
				local currentTime = os.clock()
				local calcVal4 = math.max(Frame.AbsoluteSize.X - 8, 1)
				local calcVal5 = math.max(Frame.AbsoluteSize.Y - 8, 1)
				Frame3.Visible = _G._VlonEUIGalaxyEnabled ~= false

				if Frame3.Visible then
					for _, child in ipairs(Frame3:GetChildren()) do
						if child:IsA("Frame") then
							local attribute = child:GetAttribute("GalaxyPhase") or 0
							local attribute2 = child:GetAttribute("GalaxyDrift") or 4
							local attribute3 = child:GetAttribute("GalaxySway") or 5
							child.Position = UDim2.fromOffset(((child:GetAttribute("GalaxyX") or 0.5) * calcVal4 + math.sin(currentTime * 0.24 + attribute) * attribute3) % calcVal4, ((child:GetAttribute("GalaxyY") or 0.5) * calcVal5 - currentTime * attribute2) % calcVal5)
							child.BackgroundTransparency = math.clamp((child:GetAttribute("GalaxyAlpha") or 0.4) + math.sin(currentTime * 0.8 + attribute) * (child:GetAttribute("GalaxyTwinkle") or 0.1), 0.12, 0.88)
						end
					end
				end

				task.wait(0.06)
			end
		end)

		if type(_G._AdaptMainPos) == "table" and #_G._AdaptMainPos == 4 then
			pcall(function()
				Frame.Position = UDim2.new(_G._AdaptMainPos[1], _G._AdaptMainPos[2], _G._AdaptMainPos[3], _G._AdaptMainPos[4])
			end)
		end

		local windowStroke = createStroke(Color3.fromRGB(46, 166, 255), 1.5, 1)
		windowStroke.Parent = Frame
		windowStroke.Enabled = false
		local new8 = ColorSequenceKeypoint.new
		local color14 = Color3.fromRGB

		local UIGradient4 = createInstance("UIGradient", {
			Parent = windowStroke,
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 95)),
				new8(1, color14(190, 20, 25)),
			}),
		})

		local ImageLabel = createInstance("ImageLabel", {
			Parent = Frame,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.fromOffset(360, 360),
			Position = UDim2.new(0, -18, 0, 30),
			BackgroundTransparency = 1,
			Image = "rbxassetid://108037416708175",
			ImageColor3 = Color3.fromRGB(46, 166, 255),
			ImageTransparency = 0.93,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 0,
			Visible = false,
		})

		local ImageLabel2 = createInstance("ImageLabel", {
			Parent = Frame,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.fromOffset(330, 330),
			Position = UDim2.new(0, -4, 0, 44),
			BackgroundTransparency = 1,
			Image = "rbxassetid://108037416708175",
			ImageTransparency = 0.86,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 0,
			Visible = false,
		})

		local ImageLabel3 = createInstance("ImageLabel", {
			Parent = Frame,
			AnchorPoint = Vector2.new(1, 1),
			Size = UDim2.fromOffset(360, 360),
			Position = UDim2.new(1, -2, 1, -30),
			BackgroundTransparency = 1,
			Image = "rbxassetid://108037416708175",
			ImageColor3 = Color3.fromRGB(46, 166, 255),
			ImageTransparency = 0.93,
			ScaleType = Enum.ScaleType.Fit,
			Rotation = 180,
			ZIndex = 0,
			Visible = false,
		})

		local ImageLabel4 = createInstance("ImageLabel", {
			Parent = Frame,
			AnchorPoint = Vector2.new(1, 1),
			Size = UDim2.fromOffset(330, 330),
			Position = UDim2.new(1, -2, 1, -44),
			BackgroundTransparency = 1,
			Image = "rbxassetid://108037416708175",
			ImageTransparency = 0.86,
			ScaleType = Enum.ScaleType.Fit,
			Rotation = 180,
			ZIndex = 0,
			Visible = false,
		})

		local Frame4 = createInstance("Frame", {
			Parent = Frame,
			Size = UDim2.new(1, 0, 0, 112),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		})

		local ImageLabel5 = createInstance("ImageLabel", {
			Parent = Frame4,
			Name = "VilonBanner",
			BackgroundTransparency = 1,
			Image = _G._KawatanLogoAssets[_G._KawatanLogoStyle] or _G._KawatanLogoAssets.ORIGINAL,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(1, -96, 0, 78),
			Position = UDim2.fromOffset(10, 4),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 0.02,
			ZIndex = 2,
		})

		ImageLabel5:SetAttribute("_NoAdaptTheme", true)
		_G._KawatanLogoBanner = ImageLabel5
		local logoBannerGradProps = { Parent = ImageLabel5, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)) }
		local numberSequence4 = NumberSequence.new
		local paramTable = {}
		local starTrans1 = NumberSequenceKeypoint.new(0, 0.18)
		local starTrans2 = NumberSequenceKeypoint.new(0.16, 0)
		local starTrans3 = NumberSequenceKeypoint.new(0.82, 0)
		local new9 = NumberSequenceKeypoint.new
		paramTable[1] = starTrans1
		paramTable[2] = starTrans2
		paramTable[3] = starTrans3

		do
			local values = table.pack(new9(1, 0.22))
			table.move(values, 1, values.n, 4, paramTable)
		end

		logoBannerGradProps.Transparency = numberSequence4(paramTable)
		createInstance("UIGradient", logoBannerGradProps)
		local new10 = NumberSequenceKeypoint.new

		createInstance("UIGradient", {
			Parent = createInstance("Frame", {
				Parent = Frame,
				Size = UDim2.new(1, -32, 0, 1),
				Position = UDim2.fromOffset(14, 86),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
			}),
			Color = fn61(),
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), new10(1, 0.85) }),
		})

		local function fn67(arg3, arg4, arg5, arg6, arg7)
			local TextButton = createInstance("TextButton", {
				Parent = Frame4,
				Size = UDim2.fromOffset(arg5 or 30, arg6 or 30),
				Position = UDim2.new(1, arg4, 0, 13 + (10 - (arg6 or 10)) / 2),
				BackgroundColor3 = color9,
				Text = arg3,
				Font = Enum.Font.GothamBold,
				TextSize = arg7 or 13,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ZIndex = 3,
			}, { createCorner(8), createStroke(color4, 1, 0.4) })

			TextButton.MouseEnter:Connect(function()
				tweenElement(TextButton, tweenInfo, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) })
			end)

			TextButton.MouseLeave:Connect(function()
				tweenElement(TextButton, tweenInfo, { BackgroundColor3 = color9 })
			end)

			return TextButton
		end

		local minimizeBtn = fn67("-", -34, 20, 20, 15)
		local lockPinBtn = fn67("🔓", -62, 20, 20, 11)

		local function fn68()
			local stateFlag = _G._KawatanUILocked == true
			lockPinBtn.Text = stateFlag and "🔒" or "🔓"
			tweenElement(lockPinBtn, tweenInfo, { BackgroundColor3 = stateFlag and color8 or color9 })
			lockPinBtn.TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6
		end

		lockPinBtn.MouseButton1Click:Connect(function()
			local stateFlag = _G._KawatanUILocked == true
			_G._KawatanUILocked = not stateFlag

			if _G._VlonEMobileSetLocked then
				_G._VlonEMobileSetLocked(not stateFlag)
			end

			local lockUi = win._AllToggles and win._AllToggles["Lock UI"]

			if lockUi and lockUi.SetVisual then
				pcall(lockUi.SetVisual, not stateFlag)
			end

			fn68()
		end)

		task.spawn(function()
			while lockPinBtn.Parent do
				fn68()
				task.wait(0.3)
			end
		end)

		local isWindowDragging = false
		local dragStartMousePos = nil
		local windowStartPos = nil
		local activeDragTouch = nil

		Frame4.InputBegan:Connect(function(input)
			if _G._KawatanUILocked then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local position = input.Position
				local position2 = Frame.Position
				isWindowDragging = true
				dragStartMousePos = position
				windowStartPos = position2
				activeDragTouch = input
			end
		end)

		safeConnect(UserInputService.InputChanged, function(arg3)
			if isWindowDragging and (arg3.UserInputType == Enum.UserInputType.MouseMovement or arg3.UserInputType == Enum.UserInputType.Touch and arg3 == activeDragTouch) then
				local calcVal4 = arg3.Position - dragStartMousePos
				Frame.Position = UDim2.new(windowStartPos.X.Scale, windowStartPos.X.Offset + calcVal4.X, windowStartPos.Y.Scale, windowStartPos.Y.Offset + calcVal4.Y)
			end
		end)

		safeConnect(UserInputService.InputEnded, function(arg3)
			local stateFlag = arg3.UserInputType == Enum.UserInputType.MouseButton1
			local checkFlag

			if stateFlag then
				checkFlag = stateFlag
			else
				checkFlag = arg3.UserInputType == Enum.UserInputType.Touch and arg3 == activeDragTouch
			end

			if checkFlag then
				if isWindowDragging then
					local position = Frame.Position
					_G._AdaptMainPos = { position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset }
					pcall(vlSave1)
				end

				isWindowDragging = false
				activeDragTouch = nil
			end
		end)

		local mainScrollProps = {
			Parent = Frame,
			Name = "MainScroll",
			Size = UDim2.new(1, -26, 1, -126),
			Position = UDim2.fromOffset(13, 112),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(112, 115, 123),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		}

		local UIListLayout = createInstance("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder })
		local mainScrollPadding = createInstance("UIPadding", {
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, 7),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 12),
		})

		local ScrollingFrame = createInstance("ScrollingFrame", mainScrollProps, { UIListLayout, mainScrollPadding })
		local UIWindow = { Gui = ScreenGui, Main = Frame, _CurrentContainer = ScrollingFrame }
		local categoryTabList = { "MOVEMENT", "COMBAT", "STEAL", "VISUAL", "CUSTOMIZE" }
		local UICategories = {}
		local categoryListLayouts = {}
		local categoryContentFrames = {}
		local categoryScrollFrames = {}
		local categoryTabButtons = {}
		local sideOnlyElements = {}
		local strName = "MOVEMENT"
		local strTag = "TOP"
		_G._KuRuLayoutMode = "TOP"

		local Frame5 = createInstance("Frame", {
			Parent = Frame,
			Name = "PagedContent",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(13, 150),
			Size = UDim2.new(1, -26, 1, -164),
			Visible = false,
		})

		local kuRuContentBackground = _G._KuRuContentBackground or "OFF"

		local kuruContentBgPresets = {
			["1"] = "rbxassetid://139819905455883",
			["2"] = "rbxassetid://131144372786668",
			["3"] = "rbxassetid://99203102615043",
			["4"] = "rbxassetid://127474588799377",
			["5"] = "rbxassetid://103488512751427",
		}

		if kuRuContentBackground ~= "OFF" and not kuruContentBgPresets[kuRuContentBackground] then
			kuRuContentBackground = "5"
			_G._KuRuContentBackground = kuRuContentBackground
		end

		local ImageLabel6 = createInstance("ImageLabel", {
			Parent = Frame,
			Name = "GeneralBackground",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Image = kuruContentBgPresets[kuRuContentBackground] or kuruContentBgPresets["1"],
			ImageTransparency = kuRuContentBackground == "5" and 0.1 or 0.05,
			ImageColor3 = kuRuContentBackground == "5" and Color3.fromRGB(185, 180, 195) or Color3.fromRGB(255, 255, 255),
			ScaleType = Enum.ScaleType.Crop,
			Visible = kuRuContentBackground ~= "OFF",
			ZIndex = 0,
		}, { createCorner(5) })

		local Frame6 = createInstance("Frame", { Parent = Frame, Name = "LayoutTabs", BackgroundTransparency = 1, Visible = false, ZIndex = 8 })
		local kuRuTabBackground = _G._KuRuTabBackground or "1"
		local kuruTabBgPresets = { ["1"] = "rbxassetid://90828308794279", ["2"] = "rbxassetid://100170222880325" }

		local ImageLabel7 = createInstance("ImageLabel", {
			Parent = Frame6,
			Name = "SideTabBackground",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(14, 4, 30),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Image = kuruTabBgPresets[kuRuTabBackground] or kuruTabBgPresets["1"],
			ImageTransparency = 0.18,
			ScaleType = Enum.ScaleType.Crop,
			Visible = false,
			ZIndex = 5,
		}, { createCorner(10) })

		local Frame7 = createInstance("Frame", {
			Parent = Frame6,
			BackgroundColor3 = Color3.fromRGB(20, 132, 255),
			BackgroundTransparency = 0.82,
			BorderSizePixel = 0,
			ZIndex = 8,
		}, { createCorner(7), createStroke(Color3.fromRGB(46, 166, 255), 1, 0) })

		local kuRuIdentityMode = _G._KuRuIdentityMode or "PLAYER"

		local Frame8 = createInstance("Frame", {
			Parent = Frame6,
			Name = "SideIdentity",
			Position = UDim2.new(0, 0, 1, -54),
			Size = UDim2.new(1, 0, 0, 54),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 10,
		})

		createInstance("ImageLabel", {
			Parent = Frame8,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.fromOffset(0, 0),
			BackgroundColor3 = Color3.fromRGB(8, 9, 11),
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 11,
			Visible = false,
		}, { createCorner(33), createStroke(Color3.fromRGB(46, 166, 255), 2, 0) })

		local TextLabel = createInstance("TextLabel", {
			Parent = Frame8,
			Position = UDim2.new(0, 0, 0, 7),
			Size = UDim2.new(1, 0, 0, 17),
			BackgroundTransparency = 1,
			Text = "Welcome back,",
			TextColor3 = color6,
			Font = Enum.Font.GothamMedium,
			TextSize = 9,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 11,
		})

		local userDisplayNameLabel = createInstance("TextLabel", {
			Parent = Frame8,
			Position = UDim2.new(0, 0, 0, 26),
			Size = UDim2.new(1, 0, 0, 15),
			BackgroundTransparency = 1,
			Text = localPlayer.DisplayName,
			TextColor3 = Color3.fromRGB(82, 185, 255),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 11,
		})

		createInstance("TextLabel", {
			Parent = Frame8,
			Position = UDim2.new(0, 0, 0, 116),
			Size = UDim2.new(1, 0, 0, 12),
			BackgroundTransparency = 1,
			Text = "CORES LOADED",
			TextColor3 = Color3.fromRGB(46, 166, 255),
			Font = Enum.Font.GothamBold,
			TextSize = 8,
			ZIndex = 11,
			Visible = false,
		})

		local function setIdentityMode(arg3)
			kuRuIdentityMode = arg3 == "KURU" and "KURU" or "PLAYER"
			_G._KuRuIdentityMode = kuRuIdentityMode

			if kuRuIdentityMode == "KURU" then
				TextLabel.Text = "Welcome back,"
				userDisplayNameLabel.Text = localPlayer.DisplayName
			else
				TextLabel.Text = "Welcome back,"
				userDisplayNameLabel.Text = localPlayer.DisplayName
			end
		end

		setIdentityMode(kuRuIdentityMode)

		for i, activeTabIdx in ipairs(categoryTabList) do
			local ScrollingFrame2 = createInstance("ScrollingFrame", {
				Parent = ScrollingFrame,
				Name = "KuRuPage_" .. activeTabIdx,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = color8,
				ScrollBarImageTransparency = 0.55,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingEnabled = false,
				Visible = true,
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, 10),
			})

			local UIListLayout2 = createInstance("UIListLayout", { Parent = ScrollingFrame2, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
			createInstance("UIScale", { Parent = ScrollingFrame2, Name = "PageScale", Scale = 1 })

			createInstance("UIPadding", {
				Parent = ScrollingFrame2,
				PaddingLeft = UDim.new(0, 3),
				PaddingRight = UDim.new(0, 7),
				PaddingTop = UDim.new(0, 2),
				PaddingBottom = UDim.new(0, 10),
			})

			UICategories[activeTabIdx] = ScrollingFrame2
			categoryListLayouts[activeTabIdx] = UIListLayout2

			UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if strTag == "SCROLL" then
					ScrollingFrame2.Size = UDim2.new(1, 0, 0, UIListLayout2.AbsoluteContentSize.Y + 12)
				end
			end)

			local activeTabBtn = createInstance

			local UILayoutModes = {
				Parent = Frame6,
				Name = "Tab_" .. activeTabIdx,
				BackgroundColor3 = activeTabIdx == strName and color8 or color2,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = activeTabIdx,
				TextColor3 = activeTabIdx == strName and Color3.fromRGB(255, 255, 255) or color6,
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				ZIndex = 9,
			}

			local UITabContainers = {}
			local activeTabFrame = createCorner(8)
			local activeTabLabel = createStroke
			local stateFlag = activeTabIdx == strName and color8 or color4
			local activeTabSub = table.pack(activeTabLabel(stateFlag, 1, 0))
			UITabContainers[1] = activeTabFrame

			do
				local values = table.pack(table.unpack(activeTabSub, 1, activeTabSub.n))
				table.move(values, 1, values.n, 2, UITabContainers)
			end

			categoryTabButtons[activeTabIdx] = activeTabBtn("TextButton", UILayoutModes, UITabContainers)
		end

		local function fn69(arg3)
			if not UICategories[arg3] then
				return
			end
			strName = arg3

			if strTag ~= "SCROLL" then
				for k, activeTabIdx in pairs(UICategories) do
					activeTabIdx.Visible = k == arg3

					if k == arg3 then
						activeTabIdx.CanvasPosition = Vector2.new(0, 0)
						local pageScale = activeTabIdx:FindFirstChild("PageScale")

						if pageScale then
							pageScale.Scale = 0.965
							tweenElement(pageScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1 })
						end
					end
				end
			end

			for k, activeTabIdx in pairs(categoryTabButtons) do
				local stateFlag = k == arg3

				tweenElement(activeTabIdx, tweenInfo, {
					BackgroundColor3 = stateFlag and color8 or color2,
					BackgroundTransparency = 0,
					TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6,
				})

				local uiStroke = activeTabIdx:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = stateFlag and color8 or color4
				end
			end

			local activeTabIdx = categoryTabButtons[arg3]

			if activeTabIdx then
				local tabPop = activeTabIdx:FindFirstChild("TabPop") or createInstance("UIScale", { Parent = activeTabIdx, Name = "TabPop", Scale = 1 })
				tabPop.Scale = 0.9
				tweenElement(tabPop, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
			end

			if activeTabIdx and strTag ~= "SCROLL" then
				local UILayoutModes = { Position = activeTabIdx.Position, Size = activeTabIdx.Size }
				tweenElement(Frame7, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), UILayoutModes)
			end
		end

		for k, activeTabIdx in pairs(categoryTabButtons) do
			activeTabIdx.MouseButton1Click:Connect(function()
				fn69(k)
			end)

			activeTabIdx.MouseEnter:Connect(function()
				if strName ~= k then
					tweenElement(activeTabIdx, tweenInfo, { BackgroundColor3 = color3 })
				end
			end)

			activeTabIdx.MouseLeave:Connect(function()
				if strName ~= k then
					tweenElement(activeTabIdx, tweenInfo, { BackgroundColor3 = color2 })
				end
			end)
		end

		local ui = fn67("UI", -78)
		ui.Name = "LayoutMode"
		ui.Visible = false
		ui.Active = false
		local UILayoutModes = { "SCROLL", "SIDE", "TOP", "BOTTOM" }

		local function fn70(arg3)
			local stateFlag = arg3 == "SIDE"

			for i, activeTabIdx in ipairs(categoryTabList) do
				local activeTabBtn = categoryTabButtons[activeTabIdx]

				if stateFlag then
					activeTabBtn.Size = UDim2.new(1, 0, 0, 28)
					activeTabBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 34)
				else
					local calcVal4 = 1 / math.max(#categoryTabList, 1)
					activeTabBtn.Size = UDim2.new(calcVal4, -10, 1, 0)
					activeTabBtn.Position = UDim2.new((i - 1) * calcVal4, (i - 1) * 1.2, 0, 0)
				end
			end
		end

		local function setLayoutMode(kuRuLayoutMode)
			if kuRuLayoutMode ~= "SCROLL" and kuRuLayoutMode ~= "SIDE" and kuRuLayoutMode ~= "TOP" and kuRuLayoutMode ~= "BOTTOM" then
				kuRuLayoutMode = "SCROLL"
			end

			local activeTabIdx = _G
			strTag = kuRuLayoutMode
			activeTabIdx._KuRuLayoutMode = kuRuLayoutMode
			Frame.Size = UDim2.fromOffset(380, 520)
			ui.Text = "UI"
			ScrollingFrame.Visible = kuRuLayoutMode == "SCROLL"
			Frame5.Visible = kuRuLayoutMode ~= "SCROLL"
			Frame6.Visible = kuRuLayoutMode ~= "SCROLL"
			Frame8.Visible = kuRuLayoutMode == "SIDE"
			ImageLabel7.Visible = false
			ImageLabel6.Position = UDim2.fromOffset(0, 0)
			ImageLabel6.Size = UDim2.fromScale(1, 1)
			ImageLabel6.Visible = false

			for _, activeTabBtn in ipairs(sideOnlyElements) do
				activeTabBtn.Visible = kuRuLayoutMode == "SIDE"
			end

			if kuRuLayoutMode == "SCROLL" then
				ScrollingFrame.Position = UDim2.fromOffset(13, 112)
				ScrollingFrame.Size = UDim2.new(1, -26, 1, -126)

				for _, activeTabBtn in ipairs(categoryTabList) do
					local activeTabFrame = UICategories[activeTabBtn]
					activeTabFrame.Parent = ScrollingFrame
					activeTabFrame.Visible = true
					activeTabFrame.ScrollingEnabled = false
					activeTabFrame.Size = UDim2.new(1, 0, 0, categoryListLayouts[activeTabBtn].AbsoluteContentSize.Y + 12)
				end
			else
				ScrollingFrame.Visible = false

				for _, activeTabBtn in ipairs(categoryTabList) do
					local activeTabFrame = UICategories[activeTabBtn]
					activeTabFrame.Parent = Frame5
					activeTabFrame.Position = UDim2.fromOffset(0, 0)
					activeTabFrame.Size = UDim2.fromScale(1, 1)
					activeTabFrame.ScrollingEnabled = true
					activeTabFrame.Visible = activeTabBtn == strName
				end

				if kuRuLayoutMode == "SIDE" then
					Frame6.Position = UDim2.fromOffset(12, 112)
					Frame6.Size = UDim2.new(0, 72, 1, -126)
					Frame5.Position = UDim2.fromOffset(96, 112)
					Frame5.Size = UDim2.new(1, -108, 1, -126)
				elseif kuRuLayoutMode == "TOP" then
					Frame6.Position = UDim2.fromOffset(13, 92)
					Frame6.Size = UDim2.new(1, -26, 0, 30)
					Frame5.Position = UDim2.fromOffset(13, 130)
					Frame5.Size = UDim2.new(1, -26, 1, -144)
				else
					Frame5.Position = UDim2.fromOffset(13, 112)
					Frame5.Size = UDim2.new(1, -26, 1, -166)
					Frame6.Position = UDim2.new(0, 13, 1, -43)
					Frame6.Size = UDim2.new(1, -26, 0, 30)
				end

				fn70(kuRuLayoutMode)
			end

			fn69(strName)
		end

		ui.MouseButton1Click:Connect(function()
			local activeTabIdx = 1

			for i, activeTabBtn in ipairs(UILayoutModes) do
				if activeTabBtn == strTag then
					activeTabIdx = i
					break
				end
			end

			setLayoutMode(UILayoutModes[activeTabIdx % #UILayoutModes + 1])
			pcall(vlSave1)
		end)

		UIWindow.SetCategory = function(arg3)
			UIWindow._CurrentContainer = UICategories[arg3] or UICategories.CUSTOMIZE
		end

		UIWindow.SetLayoutMode = setLayoutMode

		UIWindow.GetLayoutMode = function()
			return strTag
		end

		UIWindow.GetWindowSize = function()
			return 380, 520
		end

		UIWindow.SetIdentityMode = setIdentityMode

		UIWindow.GetIdentityMode = function()
			return kuRuIdentityMode
		end

		UIWindow.SetTabBackground = function(arg3)
			local strTemp = arg3 == "OFF" and "OFF"

			if strTemp then
				arg3 = strTemp
			else
				arg3 = kuruTabBgPresets[arg3] and arg3 or "1"
			end

			kuRuTabBackground = arg3
			_G._KuRuTabBackground = kuRuTabBackground

			if kuRuTabBackground ~= "OFF" then
				ImageLabel7.Image = kuruTabBgPresets[kuRuTabBackground]
			end

			ImageLabel7.Visible = false
		end

		UIWindow.GetTabBackground = function()
			return kuRuTabBackground
		end

		UIWindow.SetContentBackground = function(arg3)
			local strTemp = arg3 == "OFF" and "OFF"

			if strTemp then
				arg3 = strTemp
			else
				arg3 = kuruContentBgPresets[arg3] and arg3 or "1"
			end

			kuRuContentBackground = arg3
			_G._KuRuContentBackground = kuRuContentBackground

			if kuRuContentBackground ~= "OFF" then
				ImageLabel6.Image = kuruContentBgPresets[kuRuContentBackground]
			end

			ImageLabel6.ImageTransparency = kuRuContentBackground == "5" and 0.3 or 0.2
			ImageLabel6.ImageColor3 = kuRuContentBackground == "5" and Color3.fromRGB(185, 180, 195) or Color3.fromRGB(255, 255, 255)
			ImageLabel6.ScaleType = Enum.ScaleType.Crop
			ImageLabel6.Visible = false
		end

		UIWindow.GetContentBackground = function()
			return kuRuContentBackground
		end

		UIWindow.RegisterSideOnly = function(arg3)
			table.insert(sideOnlyElements, arg3)
			arg3.Visible = strTag == "SIDE"
		end

		setLayoutMode(strTag)

		UIWindow.SetUIScale = function(arg3)
			local calcVal4 = math.clamp(tonumber(arg3) or 100, 20, 200)
			local vilonUIScale = Frame:FindFirstChild("VilonUIScale")

			if vilonUIScale then
				vilonUIScale.Scale = calcVal4 / 100
			end
		end

		local Frame9 = createInstance("Frame", {
			Parent = ScreenGui,
			Size = UDim2.fromOffset(250, 380),
			Position = UDim2.new(1, -262, 1, -396),
			BackgroundTransparency = 1,
		}, {
			createInstance("UIListLayout", {
				Padding = UDim.new(0, 8),
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		UIWindow.Notify = function(arg3, arg4, arg5)
			local Frame10 = createInstance("Frame", {
				Parent = Frame9,
				Size = UDim2.new(1, 0, 0, 42),
				BackgroundColor3 = color2,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			}, { createCorner(10) })

			local activeTabIdx = createStroke(Color3.fromRGB(255, 255, 255), 1.2, 1)
			activeTabIdx.Parent = Frame10
			createInstance("UIGradient", { Parent = activeTabIdx, Color = fn61() })

			local Frame11 = createInstance("Frame", {
				Parent = Frame10,
				Size = UDim2.fromOffset(3, 22),
				Position = UDim2.new(0, 0, 0.5, -11),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			}, { createCorner(2) })

			checkRagdoll(Frame11, "BackgroundColor3")

			local activeTabBtn = createInstance("TextLabel", {
				Parent = Frame10,
				Size = UDim2.new(1, -20, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = color5,
				TextTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
			})

			tweenElement(Frame10, tweenInfo, { BackgroundColor3 = color3 })
			tweenElement(activeTabIdx, tweenInfo, { Transparency = 0.35 })
			tweenElement(Frame11, tweenInfo, { BackgroundTransparency = 0 })
			tweenElement(activeTabBtn, tweenInfo, { TextTransparency = 0 })

			task.delay(arg5 or 1, function()
				tweenElement(Frame10, tweenInfo, { BackgroundTransparency = 1 })
				tweenElement(activeTabIdx, tweenInfo, { Transparency = 1 })
				tweenElement(Frame11, tweenInfo, { BackgroundTransparency = 1 })
				tweenElement(activeTabBtn, tweenInfo, { TextTransparency = 1 })
				task.wait(0.25)
				Frame10:Destroy()
			end)
		end

		local calcVal4 = 0

		local function fn71()
			calcVal4 += 100
			return calcVal4
		end

		UIWindow.Section = function(arg3, arg4)
			local Frame10 = createInstance("Frame", {
				Parent = UIWindow._CurrentContainer or ScrollingFrame,
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundTransparency = 1,
				LayoutOrder = fn71(),
			})

			checkRagdoll(createInstance("Frame", {
				Parent = Frame10,
				Size = UDim2.fromOffset(1, 12),
				Position = UDim2.new(0, 2, 1, -15),
				BackgroundColor3 = color8,
				BorderSizePixel = 0,
				ZIndex = 8,
			}, { createCorner(2) }), "BackgroundColor3")

			createInstance("TextLabel", {
				Parent = Frame10,
				Name = string.upper(arg4),
				Size = UDim2.new(1, -16, 0, 15),
				Position = UDim2.new(0, 12, 1, -17),
				BackgroundTransparency = 1,
				Text = string.upper(arg4),
				TextColor3 = Color3.fromRGB(245, 245, 255),
				TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
				TextStrokeTransparency = 0.22,
				TextSize = 11,
				Font = Enum.Font.GothamBlack,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 8,
			})

			return Frame10
		end

		UIWindow.Divider = function()
			local Frame10 = createInstance("Frame", {
				Parent = UIWindow._CurrentContainer or ScrollingFrame,
				Size = UDim2.new(1, 0, 0, 9),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = fn71(),
			})

			local activeTabIdx = createInstance

			local UITabContainers = {
				Parent = createInstance("Frame", {
					Parent = Frame10,
					Position = UDim2.new(0, 3, 0.5, 0),
					Size = UDim2.new(1, -16, 0, 1),
					BackgroundColor3 = Color3.fromRGB(46, 166, 255),
					BackgroundTransparency = 0.32,
					BorderSizePixel = 0,
				}),
				Color = fn61(),
			}

			local numberSequence5 = NumberSequence.new
			local colorTable = {}
			local activeTabBtn = NumberSequenceKeypoint.new(0, 0.5)
			local activeTabFrame = NumberSequenceKeypoint.new(0.5, 0)
			local new11 = NumberSequenceKeypoint.new
			colorTable[1] = activeTabBtn
			colorTable[2] = activeTabFrame

			do
				local values = table.pack(new11(1, 0.8))
				table.move(values, 1, values.n, 3, colorTable)
			end

			UITabContainers.Transparency = numberSequence5(colorTable)
			activeTabIdx("UIGradient", UITabContainers)
			return Frame10
		end

		local function calculateDistance(arg3)
			local activeTabIdx = createInstance

			local UITabContainers = {
				Parent = UIWindow._CurrentContainer or ScrollingFrame,
				Size = UDim2.new(1, 0, 0, arg3),
				BackgroundColor3 = color2,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				LayoutOrder = fn71(),
				ClipsDescendants = true,
			}

			local activeTabBtn = 0
			local Frame10 = activeTabIdx("Frame", UITabContainers, { createCorner(10), createStroke(color4, 1, activeTabBtn) })
			local uiStroke = Frame10:FindFirstChildOfClass("UIStroke")

			Frame10.MouseEnter:Connect(function()
				tweenElement(Frame10, tweenInfo, { BackgroundColor3 = color3 })

				if uiStroke then
					tweenElement(uiStroke, tweenInfo, { Color = color8, Transparency = 0.45 })
				end
			end)

			Frame10.MouseLeave:Connect(function()
				tweenElement(Frame10, tweenInfo, { BackgroundColor3 = color2 })

				if uiStroke then
					tweenElement(uiStroke, tweenInfo, { Color = color4, Transparency = 0 })
				end
			end)

			return Frame10
		end

		local function fn73(arg3)
			return arg3.Name:sub(1, 7) == "Gamepad"
		end

		local function fn74(arg3)
			return arg3 == Enum.UserInputType.Keyboard or fn73(arg3)
		end

		local UITabContainers = {
			ButtonA = "A",
			ButtonB = "B",
			ButtonX = "X",
			ButtonY = "Y",
			ButtonL1 = "L1",
			ButtonR1 = "R1",
			ButtonL2 = "L2",
			ButtonR2 = "R2",
			ButtonL3 = "L3",
			ButtonR3 = "R3",
			ButtonStart = "START",
			ButtonSelect = "BACK",
			DPadUp = "D-UP",
			DPadDown = "D-DN",
			DPadLeft = "D-LF",
			DPadRight = "D-RT",
			Thumbstick1 = "LS",
			Thumbstick2 = "RS",
		}

		local function keyLabel(arg3)
			if not arg3 then
				return "NONE"
			end
			return UITabContainers[arg3.Name] or arg3.Name
		end

		UIWindow.KeyLabel = keyLabel

		UIWindow.Toggle = function(arg3, arg4, arg5, arg6, arg7, arg8)
			local activeTabIdx = arg5 or false
			local activeTabBtn = calculateDistance(46)

			local Frame10 = createInstance("Frame", {
				Parent = activeTabBtn,
				Size = UDim2.fromOffset(3, 22),
				Position = UDim2.new(0, 0, 0.5, -12),
				BackgroundColor3 = checkHumanoidPhysics(),
				BackgroundTransparency = activeTabIdx and 0 or 1,
				BorderSizePixel = 0,
			}, { createCorner(2) })

			checkRagdoll(Frame10, "BackgroundColor3", function()
				return activeTabIdx
			end)

			local calcVal5 = -74

			if arg7 then
				calcVal5 = -120
			end

			local calcVal6

			if arg8 then
				calcVal6 = calcVal5 - 34
			else
				calcVal6 = calcVal5
			end

			createInstance("TextLabel", {
				Parent = activeTabBtn,
				Size = UDim2.new(1, calcVal6, 1, 0),
				Position = UDim2.fromOffset(14, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local TextButton = createInstance("TextButton", {
				Parent = activeTabBtn,
				Size = UDim2.fromOffset(44, 22),
				Position = UDim2.new(1, -54, 0.5, -11),
				BackgroundColor3 = activeTabIdx and checkHumanoidPhysics() or Color3.fromRGB(41, 52, 78),
				Text = "",
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(12) })

			checkRagdoll(TextButton, "BackgroundColor3", function()
				return activeTabIdx
			end)

			local Frame11 = createInstance("Frame", {
				Parent = TextButton,
				Size = UDim2.fromOffset(16, 14),
				Position = activeTabIdx and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
				BackgroundColor3 = activeTabIdx and color7 or Color3.fromRGB(185, 185, 185),
				BorderSizePixel = 0,
			}, { createCorner(8) })

			local function formatLabel(arg9)
				activeTabIdx = arg9

				if not arg9 then
					tweenElement(Frame10, tweenInfo, { BackgroundTransparency = 1 })
					tweenElement(TextButton, tweenInfo, { BackgroundColor3 = Color3.fromRGB(41, 42, 78) })
				else
					Frame10.BackgroundTransparency = 0
					Frame10.BackgroundColor3 = checkHumanoidPhysics()
					tweenElement(TextButton, tweenInfo, { BackgroundColor3 = checkHumanoidPhysics() })
				end

				tweenElement(Frame11, tweenInfo2, {
					Position = arg9 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 1, 0.5, -3),
					BackgroundColor3 = arg9 and color7 or Color3.fromRGB(185, 185, 185),
				})
			end

			local function fn76(arg9, arg10)
				formatLabel(arg9)

				if arg6 then
					task.spawn(arg6, arg9, arg10)
				end
			end

			TextButton.MouseButton1Click:Connect(function()
				fn76(not activeTabIdx, "ui")
			end)

			local colorTable = {
				Set = fn76,
				SetVisual = formatLabel,
				Get = function()
					return activeTabIdx
				end,
				Card = activeTabBtn,
			}

			UIWindow._AllToggles = UIWindow._AllToggles or {}
			UIWindow._AllToggles[arg4] = colorTable

			if activeTabIdx and arg6 then
				task.spawn(function()
					task.wait(0.5)

					if not _G._RaVeSettingsReset then
						pcall(arg6, true)
					end
				end)
			end

			local calcVal7 = -88

			if arg7 then
				local activeTabFrame = arg7

				if UIWindow._GetSavedKey then
					local activeTabLabel = UIWindow._GetSavedKey(arg4)

					if activeTabLabel and Enum.KeyCode[activeTabLabel] then
						arg7 = activeTabLabel
					end
				end

				local keyCode = Enum.KeyCode[arg7]
				local activeTabLabel = 1

				local TextButton2 = createInstance("TextButton", {
					Parent = activeTabBtn,
					Size = UDim2.fromOffset(40, 23),
					Position = UDim2.new(1, -104, 0.5, -11.5),
					BackgroundColor3 = color9,
					Text = keyLabel(keyCode),
					Font = Enum.Font.GothamBold,
					TextSize = 11,
					TextColor3 = color6,
					AutoButtonColor = false,
					BorderSizePixel = 0,
				}, { createCorner(6), createStroke(color4, activeTabLabel, 0) })

				local stateFlag = false
				UIWindow._KeyResetters = UIWindow._KeyResetters or {}

				UIWindow._KeyResetters[arg4] = function()
					local activeTabSub = Enum.KeyCode[activeTabFrame]
					if not activeTabSub then
						return
					end
					stateFlag = false
					keyCode = activeTabSub
					TextButton2.Text = keyLabel(keyCode)
					TextButton2.TextColor3 = color6
				end

				TextButton2.MouseButton1Click:Connect(function()
					stateFlag = true
					TextButton2.Text = "..."
					TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)

					checkRagdoll(TextButton2, "TextColor3", function()
						return stateFlag
					end, false)
				end)

				safeConnect(UserInputService.InputBegan, function(arg9, arg10)
					local userInputType = arg9.UserInputType
					if arg10 and not fn73(userInputType) then
						return
					end

					if stateFlag and fn74(userInputType) then
						stateFlag = false
						keyCode = arg9.KeyCode
						TextButton2.Text = keyLabel(keyCode)
						TextButton2.TextColor3 = color6

						if UIWindow._OnRebind then
							UIWindow._OnRebind(arg4, keyCode.Name)
						end
					elseif not stateFlag and arg9.KeyCode == keyCode and fn74(userInputType) then
						fn76(not activeTabIdx, "keybind")
					end
				end)

				calcVal7 = -138
			end

			if arg8 then
				local subElements = {}
				local stateFlag = false
				local activeTabFrame = createStroke(Color3.fromRGB(46, 166, 255), 1.2, 0.15)

				local TextButton2 = createInstance("TextButton", {
					Parent = activeTabBtn,
					Size = UDim2.fromOffset(26, 22),
					Position = UDim2.new(1, calcVal7 - 2, 0.5, -11),
					BackgroundColor3 = color9,
					Text = stateFlag and "▲" or "▼",
					Font = Enum.Font.GothamBold,
					TextSize = 12,
					TextColor3 = color8,
					AutoButtonColor = false,
					BorderSizePixel = 0,
				}, { createCorner(6), activeTabFrame })

				TextButton2.MouseEnter:Connect(function()
					tweenElement(TextButton2, tweenInfo, { BackgroundColor3 = Color3.fromRGB(20, 132, 255) })
					TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
				end)

				TextButton2.MouseLeave:Connect(function()
					tweenElement(TextButton2, tweenInfo, { BackgroundColor3 = Color3.fromRGB(24, 15, 38) })
					TextButton2.TextColor3 = Color3.fromRGB(46, 166, 255)
				end)

				task.spawn(function()
					while TextButton2.Parent do
						if TextButton2.Text == "▼" then
							tweenElement(activeTabFrame, TweenInfo.new(0.8), { Transparency = 0.6 })
							task.wait(0.85)
							tweenElement(activeTabFrame, TweenInfo.new(0.8), { Transparency = 0.1 })
							task.wait(0.85)
						else
							task.wait(0.4)
						end
				end
				end)

				local function refresh()
					for _, activeTabLabel in ipairs(subElements) do
						local visible = stateFlag and (not activeTabLabel.pred or activeTabLabel.pred())

						if activeTabLabel.el then
							activeTabLabel.el.Visible = visible
						end
				end
				end

				colorTable.AddSub = function(arg9, arg10)
					table.insert(subElements, { el = arg9, pred = arg10 })

					if arg9 then
						arg9.Visible = stateFlag and (not arg10 or arg10())
					end
				end

				colorTable.Refresh = refresh

				colorTable.SetExpanded = function(arg9)
					stateFlag = arg9 and true or false
					TextButton2.Text = stateFlag and "▲" or "▼"
					refresh()
				end

				TextButton2.MouseButton1Click:Connect(function()
					stateFlag = not stateFlag
					TextButton2.Text = stateFlag and "▲" or "▼"
					refresh()
				end)
			end

			return colorTable
		end

		UIWindow.Slider = function(arg3, arg4, arg5, arg6, arg7, arg8, arg9)
			local calcVal5 = arg9 or 0.1
			local activeTabIdx = arg7 or arg5
			local activeTabBtn = calculateDistance(44)

			createInstance("TextLabel", {
				Parent = activeTabBtn,
				Size = UDim2.new(1, -84, 1, 0),
				Position = UDim2.fromOffset(13, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local activeTabFrame = 1
			local activeTabLabel = 0

			local TextBox = createInstance("TextBox", {
				Parent = activeTabBtn,
				Size = UDim2.fromOffset(56, 25),
				Position = UDim2.new(1, -66, 0.5, -12.5),
				BackgroundColor3 = color9,
				Text = tostring(activeTabIdx),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ClearTextOnFocus = true,
				BorderSizePixel = 0,
			}, { createCorner(6), createStroke(color4, activeTabFrame, activeTabLabel) })

			checkRagdoll(TextBox, "TextColor3")

			local function formatLabel(arg10)
				local num = tonumber(arg10)
				if not num then
					TextBox.Text = tostring(activeTabIdx)
					return
				end
				local calcVal6 = math.floor(math.floor(math.clamp(num, arg5, arg6) / calcVal5 + 0.5) * calcVal5 * 1000 + 0.5) / 1000
				activeTabIdx = calcVal6
				TextBox.Text = tostring(calcVal6)

				if arg8 then
					task.spawn(arg8, calcVal6)
				end
			end

			TextBox.FocusLost:Connect(function()
				formatLabel(TextBox.Text, true)
			end)

			return {
				Set = formatLabel,
				Get = function()
					return activeTabIdx
				end,
				Card = activeTabBtn,
			}
		end

		UIWindow.SliderBar = function(arg3, arg4, arg5, arg6, arg7, arg8, arg9)
			local calcVal5 = arg9 or 0.1
			local calcVal6 = math.clamp(arg7 or arg5, arg5, arg6)
			local activeTabIdx = calculateDistance(42)

			createInstance("TextLabel", {
				Parent = activeTabIdx,
				Size = UDim2.new(1, -84, 0, 26),
				Position = UDim2.fromOffset(13, 7),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local activeTabBtn = 0

			local TextBox = createInstance("TextBox", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(56, 24),
				Position = UDim2.new(1, -66, 0, 3),
				BackgroundColor3 = color9,
				Text = tostring(calcVal6),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ClearTextOnFocus = true,
				BorderSizePixel = 0,
			}, { createCorner(6), createStroke(color4, 1, activeTabBtn) })

			checkRagdoll(TextBox, "TextColor3")

			local Frame10 = createInstance("Frame", {
				Parent = activeTabIdx,
				Size = UDim2.new(1, -26, 0, 6),
				Position = UDim2.new(0, 13, 1, -16),
				BackgroundColor3 = color9,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, { createCorner(3) })

			local Frame11 = createInstance("Frame", {
				Parent = Frame10,
				Size = UDim2.fromScale(0, 1),
				BackgroundColor3 = color8,
				BorderSizePixel = 0,
				ZIndex = 3,
			}, { createCorner(1) })

			checkRagdoll(Frame11, "BackgroundColor3")

			local Frame12 = createInstance("Frame", {
				Parent = Frame10,
				Size = UDim2.fromOffset(12, 12),
				Position = UDim2.new(0, -6, 0.5, -6),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 4,
			}, { createCorner(6) })

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.new(1, -26, 0, 60),
				Position = UDim2.new(0, 13, 1, -25),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 10,
			})

			local function formatLabel(arg10)
				local calcVal7 = arg6 - arg5
				local calcVal8 = calcVal7 > 0 and math.clamp((calcVal6 - arg5) / calcVal7, 0, 1) or 0

				if arg10 then
					tweenElement(Frame11, tweenInfo, { Size = UDim2.fromScale(calcVal8, 1) })
					tweenElement(Frame12, tweenInfo, { Position = UDim2.new(calcVal8, -6, 0.5, -6) })
				else
					Frame11.Size = UDim2.fromScale(calcVal8, 1)
					Frame12.Position = UDim2.new(calcVal8, -6, 0.5, -6)
				end
			end

			local function fn76(arg10)
				local num = tonumber(arg10)
				if not num then
					TextBox.Text = tostring(calcVal6)
					return
				end
				local activeTabFrame = 0.5
				local calcVal7 = math.floor(math.floor(math.clamp(num, arg5, arg6) / calcVal5 + activeTabFrame) * calcVal5 * 1000 + 0.5) / 1000
				calcVal6 = calcVal7
				TextBox.Text = tostring(calcVal7)
				formatLabel(true)

				if arg8 then
					task.spawn(arg8, calcVal7)
				end
			end

			TextBox.FocusLost:Connect(function()
				fn76(TextBox.Text, true)
			end)

			formatLabel(false)
			local stateFlag = false

			local function fn77(arg10)
				local x = Frame10.AbsoluteSize.X
				if x <= 0 then
					return
				end
				local calcVal7 = arg6 - arg5
				fn76(arg5 + math.clamp((arg10 - Frame10.AbsolutePosition.X) / x, 0, 1) * calcVal7)
			end

			TextButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					stateFlag = true
					fn77(input.Position.X)
				end
			end)

			safeConnect(UserInputService.InputChanged, function(arg10)
				if not stateFlag then
					return
				end

				if arg10.UserInputType == Enum.UserInputType.MouseMovement or arg10.UserInputType == Enum.UserInputType.Touch then
					fn77(arg10.Position.X)
				end
			end)

			safeConnect(UserInputService.InputEnded, function(arg10)
				if arg10.UserInputType == Enum.UserInputType.MouseButton1 or arg10.UserInputType == Enum.UserInputType.Touch then
					stateFlag = false
				end
			end)

			return {
				Set = fn76,
				Get = function()
					return calcVal6
				end,
				Card = activeTabIdx,
			}
		end

		UIWindow.Button = function(arg3, arg4, arg5, arg6, arg7)
			local activeTabIdx = calculateDistance(42)

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, { createInstance("UIPadding", { PaddingLeft = UDim.new(0, 14) }) })

			local Frame10 = createInstance("Frame", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(3, 22),
				Position = UDim2.new(0, 0, 0.5, -12),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
			}, { createCorner(2) })

			checkRagdoll(Frame10, "BackgroundColor3")

			local function formatLabel(arg8)
				Frame10.BackgroundTransparency = 0
				tweenElement(Frame10, TweenInfo.new(0.4), { BackgroundTransparency = 1 })
				local colorTable = { BackgroundColor3 = color3 }
				tweenElement(activeTabIdx, TweenInfo.new(0.07), colorTable)

				task.delay(0.09, function()
					tweenElement(activeTabIdx, tweenInfo, { BackgroundColor3 = color2 })
				end)

				if arg5 then
					task.spawn(arg5, arg8)
				end
			end

			TextButton.MouseButton1Click:Connect(function()
				formatLabel("ui")
			end)

			if arg7 and not arg6 then
				local activeTabBtn = 0

				local TextButton2 = createInstance("TextButton", {
					Parent = activeTabIdx,
					Size = UDim2.fromOffset(52, 23),
					Position = UDim2.new(1, -62, 0.5, -11.5),
					BackgroundColor3 = color9,
					Text = arg7,
					Font = Enum.Font.GothamBold,
					TextSize = 11,
					TextColor3 = color8,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					ZIndex = 1,
				}, { createCorner(6), createStroke(color4, 1, activeTabBtn) })

				checkRagdoll(TextButton2, "TextColor3")

				TextButton2.MouseButton1Click:Connect(function()
					formatLabel("ui")
				end)

				local uiPadding = TextButton:FindFirstChildOfClass("UIPadding")

				if uiPadding then
					uiPadding.PaddingRight = UDim.new(0, 68)
				end
			end

			if arg6 then
				local activeTabBtn = arg6

				if UIWindow._GetSavedKey then
					local activeTabFrame = UIWindow._GetSavedKey(arg4)

					if activeTabFrame and Enum.KeyCode[activeTabFrame] then
						arg6 = activeTabFrame
					end
				end

				local keyCode = Enum.KeyCode[arg6]

				local TextButton2 = createInstance("TextButton", {
					Parent = activeTabIdx,
					Size = UDim2.fromOffset(40, 23),
					Position = UDim2.new(1, -50, 0.5, -11.5),
					BackgroundColor3 = color9,
					Text = keyLabel(keyCode),
					Font = Enum.Font.GothamBold,
					TextSize = 11,
					TextColor3 = color6,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					ZIndex = 3,
				}, { createCorner(6), createStroke(color4, 1, 0) })

				TextButton.Size = UDim2.new(1, -56, 1, 0)
				local stateFlag = false
				UIWindow._KeyResetters = UIWindow._KeyResetters or {}

				UIWindow._KeyResetters[arg4] = function()
					local activeTabFrame = Enum.KeyCode[activeTabBtn]
					if not activeTabFrame then
						return
					end
					stateFlag = false
					keyCode = activeTabFrame
					TextButton2.Text = keyLabel(keyCode)
					TextButton2.TextColor3 = color6
				end

				TextButton2.MouseButton1Click:Connect(function()
					stateFlag = true
					TextButton2.Text = "..."
					TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
				end)

				safeConnect(UserInputService.InputBegan, function(arg8, arg9)
					local userInputType = arg8.UserInputType
					if arg9 and not fn73(userInputType) then
						return
					end

					if stateFlag and fn74(userInputType) then
						stateFlag = false
						keyCode = arg8.KeyCode
						TextButton2.Text = keyLabel(keyCode)
						TextButton2.TextColor3 = color6

						if UIWindow._OnRebind then
							UIWindow._OnRebind(arg4, keyCode.Name)
						end
					elseif not stateFlag and arg8.KeyCode == keyCode and fn74(userInputType) then
						formatLabel("keybind")
					end
				end)
			end

			return TextButton
		end

		UIWindow.ModeRow = function(arg3, arg4, arg5, arg6, arg7)
			local stateFlag = arg6 and true or false
			local activeTabIdx = calculateDistance(36)

			local Frame10 = createInstance("Frame", {
				Parent = activeTabIdx,
				Size = UDim2.new(0.5, -6, 1, -8),
				Position = stateFlag and UDim2.new(0.5, 2, 0, 4) or UDim2.fromOffset(4, 4),
				BackgroundColor3 = color8,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, { createCorner(7) })

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.new(0.5, 0, 1, 0),
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = stateFlag and color6 or Color3.fromRGB(255, 255, 255),
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ZIndex = 3,
			})

			local TextButton2 = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.new(0.5, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = arg5,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ZIndex = 3,
			})

			local function formatLabel(arg8)
				local udim22 = stateFlag and UDim2.new(0.5, 2, 0, 4) or UDim2.fromOffset(4, 4)

				if arg8 == false then
					Frame10.Position = udim22
				else
					tweenElement(Frame10, TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = udim22 })
				end

				tweenElement(TextButton, tweenInfo, { TextColor3 = stateFlag and color6 or Color3.fromRGB(255, 255, 255) })
				tweenElement(TextButton2, tweenInfo, { TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6 })
			end

			formatLabel(false)

			TextButton.MouseButton1Click:Connect(function()
				if not stateFlag then
					return
				end
				stateFlag = false
				formatLabel()

				if arg7 then
					task.spawn(arg7, false)
				end
			end)

			TextButton2.MouseButton1Click:Connect(function()
				if stateFlag then
					return
				end
				stateFlag = true
				formatLabel()

				if arg7 then
					task.spawn(arg7, true)
				end
			end)

			return {
				Card = activeTabIdx,
				Get = function()
					return stateFlag
				end,
				Set = function(arg8)
					stateFlag = arg8 and true or false
					formatLabel()
				end,
			}
		end

		UIWindow.KeyBind = function(arg3, arg4, arg5, arg6)
			local activeTabIdx = calculateDistance(46)

			createInstance("TextLabel", {
				Parent = activeTabIdx,
				Size = UDim2.new(1, -110, 1, 0),
				Position = UDim2.fromOffset(14, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local rightControl = Enum.KeyCode[arg5] or Enum.KeyCode.RightControl

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(88, 26),
				Position = UDim2.new(1, -100, 0.5, -13),
				BackgroundColor3 = color9,
				Text = keyLabel(rightControl),
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(7), createStroke(color4, 1, 0) })

			local stateFlag = false

			TextButton.MouseButton1Click:Connect(function()
				stateFlag = true
				TextButton.Text = "..."
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			end)

			safeConnect(UserInputService.InputBegan, function(arg7, arg8)
				local userInputType = arg7.UserInputType
				if arg8 and not fn73(userInputType) then
					return
				end

				if stateFlag and fn74(userInputType) then
					stateFlag = false
					rightControl = arg7.KeyCode
					TextButton.Text = keyLabel(rightControl)
					TextButton.TextColor3 = color5

					if arg6 then
						task.spawn(arg6, rightControl)
					end
				end
			end)

			return { Get = function()
				return rightControl
			end }
		end

		UIWindow.Dropdown = function(arg3, arg4, arg5, arg6, arg7)
			local activeTabIdx = arg6 or arg5[1]
			local visible = false
			local activeTabBtn = 60
			local calcVal5 = 2
			local activeTabFrame = calculateDistance(40)

			createInstance("TextLabel", {
				Parent = activeTabFrame,
				Size = UDim2.new(0.44, 0, 0, 40),
				Position = UDim2.fromOffset(13, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local activeTabLabel = 1

			local TextButton = createInstance("TextButton", {
				Parent = activeTabFrame,
				Size = UDim2.fromOffset(126, 26),
				Position = UDim2.new(1, -139, 0, 7),
				BackgroundColor3 = color9,
				Text = "",
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(7), createStroke(color4, activeTabLabel, 0) })

			local activeTabSub = createInstance("TextLabel", {
				Parent = TextButton,
				Size = UDim2.new(1, -28, 1, 0),
				Position = UDim2.fromOffset(10, 0),
				BackgroundTransparency = 1,
				Text = activeTabIdx,
				Font = Enum.Font.GothamBold,
				TextSize = 10,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})

			local TextLabel2 = createInstance("TextLabel", {
				Parent = TextButton,
				Size = UDim2.fromOffset(18, 26),
				Position = UDim2.new(1, -22, 0, 0),
				BackgroundTransparency = 1,
				Text = "▼",
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				TextColor3 = color8,
			})

			checkRagdoll(TextLabel2, "TextColor3")

			local Frame10 = createInstance("Frame", {
				Parent = activeTabFrame,
				Size = UDim2.new(1, -26, 0, 1),
				Position = UDim2.fromOffset(13, 38),
				BackgroundColor3 = color4,
				BorderSizePixel = 0,
				Visible = false,
			})

			local dropdownScrollProps = {
				Parent = activeTabFrame,
				Size = UDim2.new(1, -26, 0, 0),
				Position = UDim2.fromOffset(13, 45),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = color8,
				ScrollBarImageTransparency = 0.3,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Active = true,
			}

			local UIListLayout2 = createInstance("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
			local dropdownPadding = createInstance("UIPadding", {
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
			})

			local ScrollingFrame2 = createInstance("ScrollingFrame", dropdownScrollProps, { UIListLayout2, dropdownPadding })
			local formatLabel = nil

			local function fn76()
				for _, child in ipairs(ScrollingFrame2:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end

				for i, optionName in ipairs(arg5) do
					local stateFlag = optionName == activeTabIdx

					local TextButton2 = createInstance("TextButton", {
						Parent = ScrollingFrame2,
						LayoutOrder = i,
						Size = UDim2.new(1, 0, 0, activeTabBtn),
						BackgroundColor3 = stateFlag and color8 or color3,
						BackgroundTransparency = stateFlag and 0 or 1,
						Text = "",
						AutoButtonColor = false,
						BorderSizePixel = 0,
					}, { createCorner(6) })

					if stateFlag then
						checkRagdoll(TextButton2, "BackgroundColor3")
					end

					createInstance("TextLabel", {
						Parent = TextButton2,
						Size = UDim2.new(1, -24, 1, 0),
						Position = UDim2.fromOffset(12, 0),
						BackgroundTransparency = 1,
						Text = optionName,
						Font = stateFlag and Enum.Font.GothamBold or Enum.Font.GothamMedium,
						TextSize = 11,
						TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
					})

					if not stateFlag then
						TextButton2.MouseEnter:Connect(function()
							tweenElement(TextButton2, tweenInfo, { BackgroundTransparency = 0.15 })
						end)

						TextButton2.MouseLeave:Connect(function()
							tweenElement(TextButton2, tweenInfo, { BackgroundTransparency = 1 })
						end)
					end

					TextButton2.MouseButton1Click:Connect(function()
						activeTabIdx = optionName
						activeTabSub.Text = activeTabIdx
						formatLabel(false)

						if arg7 then
							task.spawn(arg7, activeTabIdx)
						end
					end)
				end
			end

			formatLabel = function(arg8)
				visible = arg8 and true or false

				if visible then
					fn76()
				end

				local calcVal6 = math.min(#arg5, 6)
				local calcVal7 = visible and calcVal6 * (activeTabBtn + calcVal5) - calcVal5 + 8 or 0
				ScrollingFrame2.Size = UDim2.new(1, -26, 0, calcVal7)

				if visible then
					ScrollingFrame2.CanvasPosition = Vector2.new(0, 0)
				end

				Frame10.Visible = visible
				TextLabel2.Text = visible and "▲" or "▼"
				tweenElement(activeTabFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, visible and 42 + calcVal7 or 40) })

				if not visible then
					task.delay(0.22, function()
						if visible then
							return
						end

						for _, child in ipairs(ScrollingFrame2:GetChildren()) do
							if child:IsA("TextButton") then
								child:Destroy()
							end
						end
					end)
				end
			end

			TextButton.MouseButton1Click:Connect(function()
				formatLabel(not visible)
			end)

			return {
				Get = function()
					return activeTabIdx
				end,
				Set = function(arg8)
					activeTabIdx = arg8
					activeTabSub.Text = activeTabIdx

					if visible then
						fn76()
					end

					if arg7 then
						task.spawn(arg7, arg8)
					end
				end,
				Card = activeTabFrame,
			}
		end

		UIWindow.SegmentRow = function(arg3, arg4, arg5, arg6)
			local activeTabIdx = arg5 or arg4[1]
			local activeTabBtn = calculateDistance(36)
			local calcVal5 = math.max(#arg4, 1)
			local colorTable = {}

			local function formatLabel()
				for k, activeTabFrame in pairs(colorTable) do
					local stateFlag = k == activeTabIdx
					tweenElement(activeTabFrame, tweenInfo, { BackgroundColor3 = stateFlag and color8 or color9 })
					activeTabFrame.TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6
				end
			end

			for i, activeTabFrame in ipairs(arg4) do
				local TextButton = createInstance("TextButton", {
					Parent = activeTabBtn,
					Text = activeTabFrame,
					Font = Enum.Font.GothamBold,
					TextSize = 10,
					BackgroundColor3 = color9,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Size = UDim2.new(1 / calcVal5, -6, 1, -8),
					Position = UDim2.new((i - 1) / calcVal5, 4, 0, 4),
					TextColor3 = color6,
					ZIndex = 2,
				}, { createCorner(7) })

				colorTable[activeTabFrame] = TextButton

				TextButton.MouseButton1Click:Connect(function()
					if activeTabIdx == activeTabFrame then
						return
					end
					activeTabIdx = activeTabFrame
					formatLabel()

					if arg6 then
						task.spawn(arg6, activeTabIdx)
					end
				end)
			end

			formatLabel()

			return {
				Get = function()
					return activeTabIdx
				end,
				Set = function(arg7, arg8)
					if colorTable[arg7] then
						activeTabIdx = arg7
						formatLabel()
					end

					if arg8 ~= false and arg6 then
						task.spawn(arg6, activeTabIdx)
					end
				end,
				Card = activeTabBtn,
			}
		end

		UIWindow.LabelSegment = function(arg3, arg4, arg5, arg6, arg7)
			local activeTabIdx = arg6 or arg5[1]
			local activeTabBtn = calculateDistance(40)

			createInstance("TextLabel", {
				Parent = activeTabBtn,
				Size = UDim2.new(0.44, -13, 1, 0),
				Position = UDim2.fromOffset(13, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local Frame10 = createInstance("Frame", {
				Parent = activeTabBtn,
				Size = UDim2.new(0.56, -13, 1, -12),
				Position = UDim2.new(0.44, 0, 0, 6),
				BackgroundTransparency = 1,
			})

			local calcVal5 = math.max(#arg5, 1)
			local colorTable = {}

			local function formatLabel()
				for k, activeTabFrame in pairs(colorTable) do
					local stateFlag = k == activeTabIdx
					tweenElement(activeTabFrame, tweenInfo, { BackgroundColor3 = stateFlag and color8 or color9 })
					activeTabFrame.TextColor3 = stateFlag and Color3.fromRGB(255, 255, 255) or color6
				end
			end

			for i, activeTabFrame in ipairs(arg5) do
				local TextButton = createInstance("TextButton", {
					Parent = Frame10,
					Text = activeTabFrame,
					Font = Enum.Font.GothamBold,
					TextSize = 10,
					BackgroundColor3 = color9,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Size = UDim2.new(1 / calcVal5, -4, 1, 0),
					Position = UDim2.new((i - 1) / calcVal5, 2, 0, 0),
					TextColor3 = color6,
					ZIndex = 2,
				}, { createCorner(7) })

				colorTable[activeTabFrame] = TextButton

				TextButton.MouseButton1Click:Connect(function()
					if activeTabIdx == activeTabFrame then
						return
					end
					activeTabIdx = activeTabFrame
					formatLabel()

					if arg7 then
						task.spawn(arg7, activeTabIdx)
					end
				end)
			end

			formatLabel()

			return {
				Get = function()
					return activeTabIdx
				end,
				Set = function(arg8, arg9)
					if colorTable[arg8] then
						activeTabIdx = arg8
						formatLabel()
					end

					if arg9 ~= false and arg7 then
						task.spawn(arg7, activeTabIdx)
					end
				end,
				Card = activeTabBtn,
			}
		end

		UIWindow.Stepper = function(arg3, arg4, arg5, arg6, arg7, arg8, arg9)
			arg8 = arg8 or 0.05
			local calcVal5 = math.clamp(arg7 or arg5, arg5, arg6)
			local activeTabIdx = calculateDistance(44)

			createInstance("TextLabel", {
				Parent = activeTabIdx,
				Size = UDim2.new(0.5, 0, 1, 0),
				Position = UDim2.fromOffset(13, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(28, 24),
				Position = UDim2.new(1, -147, 0.5, -12),
				BackgroundColor3 = color9,
				Text = "-",
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(7) })

			local TextBox = createInstance("TextBox", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(72, 24),
				Position = UDim2.new(1, -113, 0.5, -12),
				BackgroundColor3 = color9,
				Text = string.format("%.2f", calcVal5),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ClearTextOnFocus = true,
				BorderSizePixel = 0,
			}, { createCorner(7) })

			checkRagdoll(TextBox, "TextColor3")

			local TextButton2 = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(28, 24),
				Position = UDim2.new(1, -35, 0.5, -12),
				BackgroundColor3 = color9,
				Text = "+",
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(7) })

			local function formatLabel(arg10)
				local num = tonumber(arg10)
				if not num then
					TextBox.Text = string.format("%.2f", calcVal5)
					return
				end
				local calcVal6 = math.floor(math.floor(math.clamp(num, arg5, arg6) / arg8 + 0.5) * arg8 * 1000 + 0.5) / 1000
				calcVal5 = calcVal6
				TextBox.Text = string.format("%.2f", calcVal6)

				if arg9 then
					task.spawn(arg9, calcVal6)
				end
			end

			local function fn76(arg10, arg11)
				arg10.MouseEnter:Connect(function()
					tweenElement(arg10, tweenInfo, { BackgroundColor3 = color8 })
				end)

				arg10.MouseLeave:Connect(function()
					tweenElement(arg10, tweenInfo, { BackgroundColor3 = color9 })
				end)

				arg10.MouseButton1Click:Connect(function()
					formatLabel(calcVal5 + arg11)
				end)
			end

			fn76(TextButton, -arg8)
			fn76(TextButton2, arg8)

			TextBox.FocusLost:Connect(function()
				formatLabel(TextBox.Text)
			end)

			return {
				Set = formatLabel,
				Get = function()
					return calcVal5
				end,
				Card = activeTabIdx,
			}
		end

		UIWindow.Cycle = function(arg3, arg4, arg5, arg6, arg7)
			local calcVal5 = 1

			for i, activeTabIdx in ipairs(arg5) do
				if activeTabIdx == arg6 then
					calcVal5 = i
					break
				end
			end

			local activeTabIdx = calculateDistance(36)

			createInstance("TextLabel", {
				Parent = activeTabIdx,
				Size = UDim2.new(0.46, 0, 0, 36),
				Position = UDim2.fromOffset(11, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(24, 23),
				Position = UDim2.new(1, -145, 0, 6),
				BackgroundColor3 = color9,
				Text = "<",
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(6), createStroke(color4, 1, 0) })

			local TextLabel2 = createInstance("TextLabel", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(82, 23),
				Position = UDim2.new(1, -117, 0, 6),
				BackgroundColor3 = color9,
				Text = arg5[calcVal5],
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				TextColor3 = color5,
				BorderSizePixel = 0,
			}, { createCorner(6), createStroke(color4, 1, 0) })

			local TextButton2 = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(24, 23),
				Position = UDim2.new(1, -31, 0, 6),
				BackgroundColor3 = color9,
				Text = ">",
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(6), createStroke(color4, 1, 0) })

			local function formatLabel(arg8, arg9)
				for i, activeTabBtn in ipairs(arg5) do
					if activeTabBtn == arg8 then
						calcVal5 = i
						break
					end
				end

				TextLabel2.Text = arg5[calcVal5]

				if arg9 ~= false and arg7 then
					task.spawn(arg7, arg5[calcVal5])
				end
			end

			TextButton.MouseButton1Click:Connect(function()
				calcVal5 = (calcVal5 - 2) % #arg5 + 1
				formatLabel(arg5[calcVal5])
			end)

			TextButton2.MouseButton1Click:Connect(function()
				calcVal5 = calcVal5 % #arg5 + 1
				formatLabel(arg5[calcVal5])
			end)

			return {
				Get = function()
					return arg5[calcVal5]
				end,
				Set = function(arg8, arg9)
					formatLabel(arg8, arg9)
				end,
				Card = activeTabIdx,
			}
		end

		UIWindow.ImageCycle = function(arg3, arg4, arg5, arg6, arg7, arg8)
			local calcVal5 = 1

			for i, activeTabIdx in ipairs(arg5) do
				if activeTabIdx == arg7 then
					calcVal5 = i
					break
				end
			end

			local activeTabIdx = calculateDistance(44)

			createInstance("TextLabel", {
				Parent = activeTabIdx,
				Size = UDim2.new(1, -165, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				BackgroundTransparency = 1,
				Text = arg4,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = color5,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})

			local TextButton = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(25, 32),
				Position = UDim2.new(1, -151, 0, 6),
				BackgroundColor3 = Color3.fromRGB(14, 10, 21),
				Text = "<",
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(7), createStroke(color4, 1, 0.35) })

			local ImageLabel8 = createInstance("ImageLabel", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(92, 32),
				Position = UDim2.new(1, -122, 0, 6),
				BackgroundColor3 = Color3.fromRGB(10, 8, 15),
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Crop,
			}, { createCorner(7), createStroke(color4, 1, 0.25) })

			local activeTabBtn = createInstance("TextLabel", {
				Parent = ImageLabel8,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "OFF",
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				TextColor3 = color6,
			})

			local TextButton2 = createInstance("TextButton", {
				Parent = activeTabIdx,
				Size = UDim2.fromOffset(25, 32),
				Position = UDim2.new(1, -26, 0, 6),
				BackgroundColor3 = Color3.fromRGB(14, 10, 24),
				Text = ">",
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = color5,
				AutoButtonColor = false,
				BorderSizePixel = 0,
			}, { createCorner(7), createStroke(color4, 1, 0.35) })

			local function formatLabel(arg9, arg10)
				for i, activeTabFrame in ipairs(arg5) do
					if activeTabFrame == arg9 then
						calcVal5 = i
						break
					end
				end

				local activeTabFrame = arg5[calcVal5]
				local activeTabLabel = arg6 and arg6[activeTabFrame]
				ImageLabel8.Image = activeTabLabel or ""
				ImageLabel8.ImageTransparency = activeTabLabel and 0 or 1
				activeTabBtn.Visible = not activeTabLabel

				if arg10 ~= false and arg8 then
					task.spawn(arg8, activeTabFrame)
				end
			end

			TextButton.MouseButton1Click:Connect(function()
				calcVal5 = (calcVal5 - 2) % #arg5 + 1
				formatLabel(arg5[calcVal5])
			end)

			TextButton2.MouseButton1Click:Connect(function()
				calcVal5 = calcVal5 % #arg5 + 1
				formatLabel(arg5[calcVal5])
			end)

			formatLabel(arg5[calcVal5], false)

			return {
				Get = function()
					return arg5[calcVal5]
				end,
				Set = function(arg9, arg10)
					formatLabel(arg9, arg10)
				end,
				Card = activeTabIdx,
			}
		end

		task.spawn(function()
			while ScreenGui.Parent do
				calcVal1 = (calcVal1 + 0.005) % 1

				pcall(function()
					UIGradient4.Rotation = (UIGradient4.Rotation + 1.6) % 360
					local imageTransparency = 0.86 + 0.06 * math.sin(calcVal1 * 3.1415926535897931 * 2)

					if ImageLabel2 then
						ImageLabel2.ImageTransparency = imageTransparency
					end

					if ImageLabel4 then
						ImageLabel4.ImageTransparency = imageTransparency
					end

					if ImageLabel then
						ImageLabel.ImageTransparency = imageTransparency + 0.07
					end

					if ImageLabel3 then
						ImageLabel3.ImageTransparency = imageTransparency + 0.07
					end
				end)

				local y = 0

				pcall(function()
					y = Frame.AbsolutePosition.Y
				end)

				for i = #LaggerState, 1, -1 do
					local activeTabIdx = LaggerState[i]

					if not activeTabIdx.inst.Parent then
						table.remove(LaggerState, i)
					elseif not activeTabIdx.cond or activeTabIdx.cond() then
						pcall(function()
							if activeTabIdx.wave then
							end

							activeTabIdx.inst[activeTabIdx.prop] = checkHumanoidPhysics()
						end)
					end
				end

				task.wait(0.025)
			end
		end)

		local Frame10 = createInstance("Frame", {
			Parent = ScreenGui,
			Size = UDim2.fromOffset(112, 10),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromOffset(137, 0),
			BackgroundColor3 = Color3.fromRGB(5, 10, 7),
			BackgroundTransparency = 0.02,
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			ZIndex = 40,
		}, { createCorner(10) })

		createStroke(Color3.fromRGB(55, 57, 63), 1, 0.55).Parent = Frame10

		checkRagdoll(createInstance("TextLabel", {
			Parent = Frame10,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "KAWATAN",
			Font = Enum.Font.GothamBlack,
			TextSize = 15,
			TextColor3 = color8,
		}), "TextColor3", nil, false)

		local stateFlag = false

		local TextButton = createInstance("TextButton", {
			Parent = Frame10,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 23,
		})

		local checkFlag = nil
		local activeTabIdx = nil
		local activeTabBtn = nil
		local activeTabFrame = nil

		TextButton.InputBegan:Connect(function(input)
			if _G._KawatanUILocked then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local position = input.Position
				local position2 = Frame10.Position
				checkFlag = true
				activeTabIdx = position
				activeTabBtn = position2
				activeTabFrame = input
				stateFlag = false
			end
		end)

		safeConnect(UserInputService.InputChanged, function(arg3)
			if not checkFlag then
				return
			end

			if arg3.UserInputType ~= Enum.UserInputType.MouseMovement and arg3 ~= activeTabFrame then
				return
			end
			local calcVal5 = arg3.Position - activeTabIdx

			if math.abs(calcVal5.X) > 4 or math.abs(calcVal5.Y) > 4 then
				stateFlag = true
			end

			Frame10.Position = UDim2.new(activeTabBtn.X.Scale, activeTabBtn.X.Offset + calcVal5.X, activeTabBtn.Y.Scale, activeTabBtn.Y.Offset + calcVal5.Y)
		end)

		safeConnect(UserInputService.InputEnded, function(arg3)
			if not checkFlag then
				return
			end

			if arg3.UserInputType ~= Enum.UserInputType.MouseButton1 and arg3 ~= activeTabFrame then
				return
			end
			checkFlag = false
			activeTabFrame = nil

			if stateFlag then
				task.delay(0.15, function()
					stateFlag = false
				end)
			end
		end)

		local matchFlag = false

		local function formatLabel()
			if UIWindow.GetWindowSize then
				return UIWindow.GetWindowSize()
			end
			return 380, 520
		end

		local function fn76(arg3, arg4)
			matchFlag = arg3

			if not arg4 and UIWindow._OnHiddenChanged then
				pcall(UIWindow._OnHiddenChanged, matchFlag)
			end

			local activeTabLabel, activeTabSub = formatLabel()

			if arg3 then
				Frame.Visible = false
				Frame10.Visible = true
			else
				Frame10.Visible = false
				Frame.Visible = true
				Frame.Size = UDim2.fromOffset(activeTabLabel, activeTabSub)
			end
		end

		TextButton.MouseButton1Click:Connect(function()
			if stateFlag then
				return
			end
			fn76(false)
		end)

		minimizeBtn.MouseButton1Click:Connect(function()
			fn76(true)
		end)

		safeConnect(UserInputService.InputBegan, function(arg3, arg4)
			if arg4 and not fn73(arg3.UserInputType) then
				return
			end

			if arg3.KeyCode == toggleKey then
				fn76(not matchFlag)
			end
		end)

		UIWindow.ResetPositions = function()
			Frame.Position = udim2
			Frame10.Position = UDim2.fromOffset(137, 0)
			_G._AdaptMainPos = nil
		end

		UIWindow.SetToggleKey = function(arg3)
			toggleKey = arg3
		end

		UIWindow.GetToggleKey = function()
			return toggleKey
		end

		UIWindow.SetHidden = function(arg3)
			fn76(arg3 and true or false, true)
		end

		UIWindow.IsHidden = function()
			return matchFlag
		end

		UIWindow.Hide = function()
			fn76(true)
		end

		UIWindow.Destroy = function()
			if ScreenGui then
				ScreenGui:Destroy()
			end
		end

		local activeTabLabel, activeTabSub = formatLabel()
		Frame.Size = UDim2.fromOffset(activeTabLabel, activeTabSub)
		return UIWindow
	end }
end

local UILibrary = checkAnchored()
_G._VlonEUIGalaxyEnabled = false
_G._VlonEUIMoneyRainEnabled = false

MainWindow = UILibrary:CreateWindow({
	Title = "Kawatan Hub",
	Sub = "BLUE EDITION",
	ToggleKey = Enum.KeyCode.LeftControl,
})
end
end
end

do
MainWindow._GetSavedKey = function(arg)
return configTable.keys[arg]
end

MainWindow._OnRebind = function(arg, arg2)
configTable.keys[arg] = arg2
pcall(vlSave1)
end

if configTable.uiKey and Enum.KeyCode[configTable.uiKey] then
MainWindow.SetToggleKey(Enum.KeyCode[configTable.uiKey])
end

MainWindow._OnHiddenChanged = function(arg)
configTable.uiHidden = arg and true or false
pcall(vlSave1)
end

if configTable.uiHidden and MainWindow.SetHidden then
MainWindow.SetHidden(true)
end

processInput = function(arg, arg2, arg3, arg4, arg5)
return (MainWindow:Toggle(arg, setupListener(arg, arg2), function(arg6, arg7)
configTable.on[arg] = arg6
arg3(arg6, arg7)
pcall(vlSave1)
end, arg4, arg5))
end

MainWindow.SetCategory("MOVEMENT")
MainWindow:Section("Speed Change")

_G._RaVeSpeedMethodRow = MainWindow:LabelSegment("Speed Change Method", { "V1", "V2" }, _G._RaVeSpeedMethod == "V1" and "V1" or "V2", function(arg)
_G._RaVeSpeedMethod = arg == "V1" and "V1" or "V2"

if _G._RvRefreshSpeedModes then
_G._RvRefreshSpeedModes()
end

pcall(vlSave1)
end)

do
local autoSpeed = processInput("Auto Speed", false, function(adaptAutoCarry)
_G._AdaptAutoCarry = adaptAutoCarry

if adaptAutoCarry then
	if _G._AdaptStartAutoCarry then
		_G._AdaptStartAutoCarry()
	end
elseif _G._AdaptStopAutoCarry then
	_G._AdaptStopAutoCarry()
end
end, nil, true)

_G._AdaptAutoCarryVersionRow = MainWindow:ModeRow("ON PICK UP", "SOFT STEAL", _G._AdaptAutoCarryVersion == "V2", function(arg)
_G._AdaptAutoCarryVersion = arg and "V2" or "V1"

if _G._AdaptAutoCarry and _G._AdaptStartAutoCarry then
	pcall(_G._AdaptStopAutoCarry)
	_G._AdaptAutoCarry = true
	pcall(_G._AdaptStartAutoCarry)
end

pcall(vlSave1)
end)

local item2 = MainWindow:Slider("Soft Steal Range", 1, 60, _G._AdaptAutoCarryV2Range or 15, function(adaptAutoCarryV2Range)
_G._AdaptAutoCarryV2Range = adaptAutoCarryV2Range
pcall(vlSave1)
end)

if autoSpeed.AddSub then
autoSpeed.AddSub(_G._AdaptAutoCarryVersionRow.Card)

autoSpeed.AddSub(item2.Card, function()
	return _G._AdaptAutoCarryVersion == "V2"
end)
end
end
end

MainWindow:Section("Speed Configuration")

MainWindow:Slider("Normal Speed", 16, 200, SpeedState.NS, function(ns)
SpeedState.NS = ns
pcall(vlSave1)
end, 0.1)

MainWindow:Slider("Carry Speed", 16, 200, SpeedState.CS, function(cs)
SpeedState.CS = cs
pcall(vlSave1)
end, 0.1)

processInput("Carry Mode", false, function(arg)
if _G._RaVeSpeedMethod == "V1" and SpeedState.family ~= "Bedwars" then
local item2 = SpeedState
SpeedState.family = "Bedwars"
item2.carry = true
else
SpeedState.carry = arg and true or false
end

if _G._RvRefreshSpeedModes then
_G._RvRefreshSpeedModes()
end
end, "Q")

MainWindow:Section("Lagger Configuration")

MainWindow:Slider("Lagger Normal Speed", 1, 100, SpeedState.LG_N, function(lgN)
SpeedState.LG_N = lgN
pcall(vlSave1)
end, 0.1)

MainWindow:Slider("Lagger Carry Speed", 1, 100, SpeedState.LG_C, function(lgC)
SpeedState.LG_C = lgC
pcall(vlSave1)
end, 0.1)

do
local laggerMode = processInput("Lagger Mode", false, function()
if _G._RaVeSpeedMethod == "V1" then
if SpeedState.family ~= "lagger" then
	local item2 = SpeedState
	SpeedState.family = "lagger"
	item2.carry = false
else
	SpeedState.carry = not SpeedState.carry
end
else
SpeedState.family = SpeedState.family == "lagger" and "normal" or "lagger"
end

if _G._RvRefreshSpeedModes then
_G._RvRefreshSpeedModes()
end
end, "G")

_G._RvLaggerLabel = nil

_G._RvRefreshSpeedModes = function()
local stateFlag = SpeedState.family == "lagger"

if laggerMode and laggerMode.SetVisual then
laggerMode.SetVisual(stateFlag)
end

local carryMode = MainWindow._AllToggles and MainWindow._AllToggles["Carry Mode"]

if carryMode and carryMode.SetVisual then
if _G._RaVeSpeedMethod == "V1" then
	carryMode.SetVisual(SpeedState.family == "normal" and SpeedState.carry == true)
else
	carryMode.SetVisual(SpeedState.carry == true)
end
end

if _G._RvLaggerLabel and _G._RvLaggerLabel.Set then
_G._RvLaggerLabel.Set(stateFlag and SpeedState.carry)
end
end
end
end

do
do
MainWindow:Section("Jump")

do
local infiniteJump = processInput("Infinite Jump", false, function(arg)
pcall(startAntiLag, arg)
end, nil, true)

local item2 = MainWindow:LabelSegment("Jump Mode", { "TAP", "HOLD" }, _G._AdaptInfJumpMode == "HOLD" and "HOLD" or "TAP", function(adaptInfJumpMode)
_G._AdaptInfJumpMode = adaptInfJumpMode
pcall(vlSave1)
end)

if infiniteJump.AddSub then
infiniteJump.AddSub(item2.Card)
end
end
end

processInput("Anti Ragdoll", false, function(enabled)
AntiDieState.enabled = enabled

if enabled then
pcall(stopAntiLag)
else
pcall(disableAntiDie)
end
end)

MainWindow:Dropdown("Animation Pack", _G._RaVeAnimationPackList, _G._AdaptAnimPack or "Off", function(arg)
pcall(_G._RaVeApplySelectedAnimation, arg)
pcall(vlSave1)
end)

MainWindow:Section("Reset")

MainWindow:Button("Insta Reset", function()
if type(_G._AceInstaReset) == "function" then
pcall(_G._AceInstaReset)
end
end, "T")

MainWindow:Section("Drop Brainrot")

MainWindow:Button("Drop", function()
pcall(registerConnection)
end, "F")

MainWindow:LabelSegment("Drop Mode", { "STAND", "JUMP" }, dropMode == "JUMP" and "JUMP" or "STAND", function(arg)
dropMode = arg == "JUMP" and "JUMP" or "STAND"
pcall(vlSave1)
end)

MainWindow:Section("TP Down")
tpMode = "full"

MainWindow:Button("TP Down", function()
pcall(executeAction)
end, "X")

do
local autoTpDown = processInput("Auto TP Down", false, function(enabled)
PlotState.enabled = enabled

if enabled then
pcall(createOrResetBillboard)
else
pcall(disconnectHandler)
end
end, nil, true)

local item2 = MainWindow:SliderBar("Auto TP Height", 1, 100, PlotState and PlotState.height or 20, function(height)
PlotState.height = height
pcall(vlSave1)
end)

if autoTpDown.AddSub then
autoTpDown.AddSub(item2.Card)
end
end
end
end

local item2, createOrResetBillboard, item3, Radius, candyRefreshStealRows, normal

do
MainWindow.SetCategory("VISUAL")
MainWindow:Section("Sky Themes")

_G._RaVeSkyDropdown = MainWindow:Cycle("Sky", _G._AdaptSkyOrder, _G._AdaptSkyMode or "Off", function(arg)
if arg == "Off" then
pcall(_G._AdaptStopSky)
else
pcall(_G._AdaptStartSky, arg)
end

pcall(vlSave1)
end)

_G._RaVeKorbloxSelectorPending = function()
_G._RaVeKorbloxSelector = MainWindow:Cycle("Korblox", { "Off", "Left", "Right", "Both" }, _G._RaVeKorbloxMode or "Off", function(arg)
_G._KawatanKorbloxUserSet = true
pcall(_G._RaVeApplyKorblox, arg)
pcall(vlSave1)
end)
end

MainWindow.SetCategory("STEAL")
MainWindow:Section("Steal Configuration")
item2 = nil

item2 = MainWindow:Toggle("Auto Steal", setupListener("Auto Steal", true), function(autoSteal)
configTable.on["Auto Steal"] = autoSteal
StealState.AutoSteal = autoSteal
StealConfig.AutoStealEnabled = autoSteal

if _G._CandyRagdollStealUserSet then
pcall(_G._CandyRagdollStealUserSet, autoSteal)
end

if autoSteal then
pcall(fn28)
else
pcall(fn29)
end

if item2 and item2.Refresh then
item2.Refresh()
end

pcall(vlSave1)
end, nil, true)

_G._CandyAutoStealToggle = item2

do
local kawatanStealRadii = _G._KawatanStealRadii

createOrResetBillboard = function()
return _G._AdaptStealMode == "NORMAL"
end

item3 = nil
Radius = nil

local function checkAnchored()
if StealState.AutoSteal then
pcall(fn29)
pcall(fn28)
end
end

candyRefreshStealRows = function()
if _G.AceNormalAutoStealSetRadius then
pcall(_G.AceNormalAutoStealSetRadius, kawatanStealRadii.Normal)
end

if _G.AceSemiAutoStealSetRadius then
pcall(_G.AceSemiAutoStealSetRadius, kawatanStealRadii.Semi)
end

if Radius and Radius.Set then
Radius.Set(kawatanStealRadii.Normal)
end

if item3 and item3.Set then
item3.Set(kawatanStealRadii.Semi)
end
end

_G._CandyRefreshStealRows = candyRefreshStealRows

normal = MainWindow:ModeRow("NORMAL", "SEMI", createOrResetBillboard(), function(arg)
_G._AdaptStealMode = arg and "SEMI" or "NORMAL"
candyRefreshStealRows()

if item2.Refresh then
item2.Refresh()
end

checkAnchored()
pcall(vlSave1)
end)

item3 = MainWindow:Slider("SEMI Range", 1, 100, kawatanStealRadii.Semi, function(arg)
if _G.AceSemiAutoStealSetRadius then
pcall(_G.AceSemiAutoStealSetRadius, arg)
end

pcall(vlSave1)
end)

Radius = MainWindow:Slider("Radius", 1, 120, kawatanStealRadii.Normal, function(arg)
if _G.AceNormalAutoStealSetRadius then
pcall(_G.AceNormalAutoStealSetRadius, arg)
end

pcall(vlSave1)
end)
end
end

do
local ragdollSteal = setupListener("Ragdoll Steal", true)

if _G._CandyRagdollStealSet then
pcall(_G._CandyRagdollStealSet, ragdollSteal)
end

configTable.on["Ragdoll Steal"] = ragdollSteal

_G._CandyRagdollStealToggle = MainWindow:Toggle("Ragdoll Steal", ragdollSteal, function(arg)
configTable.on["Ragdoll Steal"] = arg

if _G._CandyRagdollStealSet then
pcall(_G._CandyRagdollStealSet, arg)
end

pcall(vlSave1)
end)
end

candyRefreshStealRows()

do
local function checkAnchored()
return not createOrResetBillboard()
end

if item2.AddSub then
item2.AddSub(normal.Card)
item2.AddSub(Radius.Card, checkAnchored)
item2.AddSub(item3.Card, createOrResetBillboard)
end
end
end

do
do
do
MainWindow.SetCategory("COMBAT")
MainWindow:Section("Aimbot")

do
local batAimbotToggle = MainWindow:Toggle("Bat Aimbot", setupListener("Bat Aimbot", false), function(aimbot)
configTable.on["Bat Aimbot"] = aimbot
if aimbot and _G._RaVeSafeMode.IsLocked() then
_G._RaVeSafeMode.ForceStop()
return
end
CombatState.aimbot = aimbot

if aimbot then
if CombatState.desync then
	CombatState.desync = false
	pcall(fn45)
end

pcall(fn41)
else pcall(fn42) end

pcall(vlSave1)
end, "R", true)

CombatState.antiMode = _G._AdaptBatMode == "BYPASS"

local default = MainWindow:ModeRow("DEFAULT", "BYPASS", CombatState.antiMode, function(antiMode)
_G._AdaptBatMode = antiMode and "BYPASS" or "DEFAULT"
CombatState.antiMode = antiMode
pcall(vlSave1)
end)

local aimbotSpeedSlider = MainWindow:Slider("Aimbot Speed", 1, 250, CombatState.aimSpd, function(aimSpd)
CombatState.aimSpd = aimSpd
pcall(vlSave1)
end, 0.1)

local laggerAimbotSpeedSlider = MainWindow:Slider("Lagger Aimbot Speed", 1, 250, CombatState.laggerAimSpd or 40, function(laggerAimSpd)
CombatState.laggerAimSpd = laggerAimSpd
pcall(vlSave1)
end, 0.1)

local autoSwing = processInput("Auto Swing", false, function(swing)
CombatState.swing = swing
end)

if batAimbotToggle.AddSub then
batAimbotToggle.AddSub(default.Card)
batAimbotToggle.AddSub(aimbotSpeedSlider.Card)
batAimbotToggle.AddSub(laggerAimbotSpeedSlider.Card)
batAimbotToggle.AddSub(autoSwing.Card)
end
end
end

processInput("Mirror TP", CombatState.tpMirror, function(tpMirror)
CombatState.tpMirror = tpMirror
_G._AdaptTPMirrorEnabled = adaptTPMirrorEnabled or tpMirror and CombatState.aimbot == true

if not _G._AdaptTPMirrorEnabled then
_tpMirrorData = {}
end

pcall(vlSave1)
end)

MainWindow:Section("TP Bat")

do
local autoSwing = nil
local toggle = MainWindow.Toggle
local tpBat = setupListener("TP Bat", false)

local desyncAimbot = toggle(MainWindow, "Desync Aimbot", setupListener("Desync Aimbot", tpBat), function(desync)
configTable.on["Desync Aimbot"] = desync
configTable.on["TP Bat"] = nil
if desync and _G._RaVeSafeMode.IsLocked() then
_G._RaVeSafeMode.ForceStop()
return
end
CombatState.desync = desync
CombatState.desyncSwing = desync and (autoSwing and autoSwing.Get and autoSwing.Get() == true or false) or false
adaptTPMirrorEnabled = false
_G._AdaptTPMirrorEnabled = CombatState.tpMirror and desync

if not _G._AdaptTPMirrorEnabled then
_tpMirrorData = {}
end

if desync then
if CombatState.aimbot then
CombatState.aimbot = false
pcall(fn42)
end

pcall(fn44)

if _G.AdaptAntiVoid then
pcall(_G.AdaptAntiVoid.Start)
end
else
pcall(fn45)

if _G.AdaptAntiVoid then
pcall(_G.AdaptAntiVoid.Stop)
end
end

pcall(vlSave1)
end, "E", true)

if desyncAimbot.AddSub then
do
desyncAimbot.AddSub(MainWindow:ModeRow("V1", "V2", _G._AdaptTpBatMode == "HIGH PING", function(arg)
_G._AdaptTpBatMode = arg and "HIGH PING" or "SURE HIT"
pcall(vlSave1)
end).Card)

do
local function createOrResetBillboard(arg)
	CombatState.desyncSwing = arg and true or false
	pcall(vlSave1)
end

autoSwing = processInput
autoSwing = autoSwing("Auto Swing", false, createOrResetBillboard)
end
end

CombatState.desyncSwing = CombatState.desync and autoSwing.Get and autoSwing.Get() == true or false
desyncAimbot.AddSub(autoSwing.Card)

do
local removeCameraShake = processInput("Remove Camera Shake", false, function(arg)
CombatState.desyncNoCam = arg and true or false
pcall(vlSave1)
end)

local get = removeCameraShake.Get

if get then
local item2 = true
get = removeCameraShake.Get() == item2
end

CombatState.desyncNoCam = get or false
desyncAimbot.AddSub(removeCameraShake.Card)
end
end
end
end

do
MainWindow.SetCategory("MOVEMENT")
MainWindow:Section("Auto Path")

do
local autoLeft = processInput("Auto Left", false, function(l)
if l and _G._RaVeSafeMode.IsLocked() then
_G._RaVeSafeMode.ForceStop()
return
end
WaypointState.L = l

if l then
if WaypointState.R then
WaypointState.stopR()
end

WaypointState.startL()
else
WaypointState.stopL()
end
end, "Z")

local autoRight = processInput("Auto Right", false, function(r)
if r and _G._RaVeSafeMode.IsLocked() then
_G._RaVeSafeMode.ForceStop()
return
end
WaypointState.R = r

if r then
if WaypointState.L then
WaypointState.stopL()
end

WaypointState.startR()
else
WaypointState.stopR()
end
end, "C")

MainWindow:LabelSegment("Path Mode", { "NORMAL", "AUTO PLAY" }, _G._KawatanPathMode == "AUTO PLAY" and "AUTO PLAY" or "NORMAL", function(arg)
for _, loopEntry in ipairs({ autoLeft, autoRight }) do
if loopEntry and loopEntry.Get and loopEntry.Set and loopEntry.Get() then
pcall(loopEntry.Set, false)
end
end

_G._KawatanPathMode = arg == "AUTO PLAY" and "AUTO PLAY" or "NORMAL"
pcall(vlSave1)
end)

WaypointState.lRef = autoLeft
WaypointState.rRef = autoRight
end
end

do
MainWindow.SetCategory("COMBAT")
MainWindow:Section("Protection")

processInput("Safe Mode", false, function(arg)
_G._RaVeSafeMode.SetEnabled(arg)

if arg and _G._RaVeSafeMode.IsLocked() then
_G._RaVeSafeMode.ForceStop()
end
end)

_G._RaVeSafeToggleSource = MainWindow._AllToggles

do
local aceGuards = _G._AceGuards or {}
_G._AceGuards = aceGuards
_G._CandyGuards = aceGuards
aceGuards.autoDie = false
aceGuards.autoFling = false
aceGuards.prevAim = false
aceGuards.last = 0
aceGuards.tglDie = nil
aceGuards.tglFling = nil

local function createOrResetBillboard()
return _G._AceAntiFling or _G._CandyAntiFling
end

local function checkAnchored()
local aceInstaResetState = _G._AceInstaResetState
local busy = aceInstaResetState and aceInstaResetState.busy

if busy then
busy = os.clock() - (aceInstaResetState.busyAt or 0) < 10
end

return busy or false
end

aceGuards.DieIsOn = function()
local candyAntiDie = _G._CandyAntiDie
return candyAntiDie and candyAntiDie.enabled == true and candyAntiDie.loop ~= nil or false
end

aceGuards.SetDie = function(arg)
local stateFlag = arg and true or false
local candyAntiDie = _G._CandyAntiDie
local aceInstaResetState = _G._AceInstaResetState

if aceInstaResetState then
aceInstaResetState.wantDie = nil
end

if stateFlag then
if candyAntiDie and candyAntiDie.enabled and not candyAntiDie.loop then
candyAntiDie.enabled = false
end

if type(_G.startAntiDie) == "function" then
pcall(_G.startAntiDie)
elseif candyAntiDie then
candyAntiDie.enabled = true
end
elseif type(_G.stopAntiDie) == "function" then
pcall(_G.stopAntiDie)
elseif candyAntiDie then
candyAntiDie.enabled = false
end

if aceGuards.tglDie and aceGuards.tglDie.SetVisual then
pcall(aceGuards.tglDie.SetVisual, aceGuards.DieIsOn())
end
end

aceGuards.FlingIsOn = function()
local item2 = createOrResetBillboard()
return item2 and type(item2.IsEnabled) == "function" and item2.IsEnabled() == true or false
end

aceGuards.SetFling = function(arg)
local stateFlag = arg and true or false
local item2 = createOrResetBillboard()

if item2 and type(item2.SetEnabled) == "function" then
pcall(item2.SetEnabled, stateFlag)
end

if aceGuards.tglFling and aceGuards.tglFling.SetVisual then
pcall(aceGuards.tglFling.SetVisual, stateFlag)
end
end

aceGuards.AimOn = function()
return (CombatState.aimbot or CombatState.desync) and true or false
end

aceGuards.Sync = function()
if checkAnchored() then
return
end
local item2 = aceGuards.AimOn()

if item2 then
if not aceGuards.DieIsOn() then
aceGuards.autoDie = true
aceGuards.SetDie(true)
end

if not aceGuards.FlingIsOn() then
aceGuards.autoFling = true
aceGuards.SetFling(true)
end
elseif aceGuards.prevAim then
if aceGuards.autoDie then
aceGuards.autoDie = false
aceGuards.SetDie(false)
end

if aceGuards.autoFling then
aceGuards.autoFling = false
aceGuards.SetFling(false)
end
end

aceGuards.prevAim = item2

if aceGuards.tglDie and aceGuards.tglDie.Get and aceGuards.tglDie.SetVisual then
local item3 = aceGuards.DieIsOn()

if aceGuards.tglDie.Get() == true ~= item3 then
pcall(aceGuards.tglDie.SetVisual, item3)
end
end

if aceGuards.tglFling and aceGuards.tglFling.Get and aceGuards.tglFling.SetVisual then
local item3 = aceGuards.FlingIsOn()

if aceGuards.tglFling.Get() == true ~= item3 then
pcall(aceGuards.tglFling.SetVisual, item3)
end
end
end

aceGuards.tglDie = processInput("Anti Die", false, function(arg)
if arg then
aceGuards.autoDie = false
aceGuards.SetDie(true)
elseif aceGuards.AimOn() then
aceGuards.SetDie(true)
else
aceGuards.SetDie(false)
end
end, "F1")

if aceGuards.tglDie and aceGuards.tglDie.Get then
aceGuards.autoDie = false
aceGuards.SetDie(aceGuards.tglDie.Get() == true)
end

aceGuards.tglFling = processInput("Anti Fling", false, function(arg)
if arg then
aceGuards.autoFling = false
aceGuards.SetFling(true)
elseif aceGuards.AimOn() then
aceGuards.SetFling(true)
else
aceGuards.SetFling(false)
end
end)

if aceGuards.tglFling and aceGuards.tglFling.Get then
aceGuards.autoFling = false
aceGuards.SetFling(aceGuards.tglFling.Get() == true)
end

if aceGuards.watch then
pcall(function()
aceGuards.watch:Disconnect()
end)

aceGuards.watch = nil
end

aceGuards.watch = safeConnect(RunService.Heartbeat, function()
local currentTime = os.clock()
if currentTime - aceGuards.last < 0.15 then
return
end
aceGuards.last = currentTime
aceGuards.Sync()
end)

aceGuards.Sync()
end
end

MainWindow:Section("Counters")

processInput("Bat Counter", false, function(vezyBatCounterOn)
_G._VezyBatCounterOn = vezyBatCounterOn

if vezyBatCounterOn then
pcall(_G.VezyStartBatCounter)
else
pcall(_G.VezyStopBatCounter)
end
end)

processInput("Medusa Counter", false, function(arg)
statusFlag = arg

if arg then
pcall(clearMovers)
else
pcall(resetMovers)
end
end)

do
local autoMedusa = processInput("Auto Medusa", false, function(arg)
if arg then
pcall(cleanupSession)
else
pcall(getStealMode)
end
end, nil, true)

local item2 = MainWindow:SliderBar("Auto Medusa Range", 1, 60, _G._AdaptAutoMedusaRange or 8, function(adaptAutoMedusaRange)
_G._AdaptAutoMedusaRange = adaptAutoMedusaRange

if _G._AdaptAutoMedusaRefresh then
pcall(_G._AdaptAutoMedusaRefresh)
end

pcall(vlSave1)
end)

if autoMedusa.AddSub then
autoMedusa.AddSub(item2.Card)
end
end
end

do
do
do
MainWindow.SetCategory("CUSTOMIZE")

do
local item2 = MainWindow:Cycle("Side Profile", { "PLAYER", "KURU" }, MainWindow.GetIdentityMode and MainWindow.GetIdentityMode() or "PLAYER", function(arg)
if MainWindow.SetIdentityMode then
MainWindow.SetIdentityMode(arg)
end

pcall(vlSave1)
end)

if item2.Card then
item2.Card.Visible = false
end
end
end

MainWindow.SetCategory("CUSTOMIZE")
MainWindow:Section("UI Customization")

_G._RaVeUISizeSlider = MainWindow:Stepper("UI Scale", 0.2, 2, (_G._AdaptUIScale or 100) / 100, 0.05, function(arg)
local adaptUIScale = math.floor(arg * 100 + 0.5)
_G._AdaptUIScale = adaptUIScale

if MainWindow.SetUIScale then
MainWindow.SetUIScale(adaptUIScale)
end

pcall(vlSave1)
end)

_G._KawatanMobileScaleSlider = MainWindow:Stepper("Mobile Buttons Scale", 0.5, 2, (_G._KawatanMobileScale or 100) / 100, 0.05, function(arg)
local kawatanMobileScale = math.floor(arg * 100 + 0.5)
_G._KawatanMobileScale = kawatanMobileScale

if _G._KawatanMobileSetScale then
_G._KawatanMobileSetScale(kawatanMobileScale)
end

pcall(vlSave1)
end)

_G._KawatanStealBarScaleSlider = MainWindow:Stepper("Steal Bar Scale", 0.5, 2, (_G._KawatanStealBarScale or 100) / 100, 0.05, function(arg)
local kawatanStealBarScale = math.floor(arg * 100 + 0.5)
_G._KawatanStealBarScale = kawatanStealBarScale

if _G._KawatanStealBarSetScale then
_G._KawatanStealBarSetScale(kawatanStealBarScale)
end

pcall(vlSave1)
end)

_G._KawatanLogoSelector = MainWindow:ImageCycle("Logo Style", _G._KawatanLogoOrder, _G._KawatanLogoAssets, _G._KawatanLogoStyle or "ORIGINAL", function(kawatanLogoStyle)
local kawatanLogoAssets = _G._KawatanLogoAssets and _G._KawatanLogoAssets[kawatanLogoStyle]
if not kawatanLogoAssets then
return
end
_G._KawatanLogoStyle = kawatanLogoStyle

if _G._KawatanLogoBanner then
_G._KawatanLogoBanner.Image = kawatanLogoAssets
end

if _G._KawatanApplyAccent then
pcall(_G._KawatanApplyAccent, kawatanLogoStyle)
end

pcall(vlSave1)
end)

MainWindow.SetCategory("VISUAL")
MainWindow:Section("Camera")

processInput("No Camera Collision", false, function(arg)
pcall(function()
localPlayer.DevCameraOcclusionMode = arg and Enum.DevCameraOcclusionMode.Invisicam or Enum.DevCameraOcclusionMode.Zoom
end)
end)

do
local fovChange = processInput("FOV Change", false, function(fov)
VisualState.fov = fov

if fov then
pcall(fn35)
else
pcall(fn36)
end
end, nil, true)

local item2 = MainWindow:SliderBar("FOV Value", 40, 120, VisualState.fovVal, function(fovVal)
VisualState.fovVal = fovVal
pcall(vlSave1)
end)

if fovChange.AddSub then
fovChange.AddSub(item2.Card)
end
end
end

do
local stretchRez = processInput("Stretch Rez", false, function(stretch)
VisualState.stretch = stretch

if stretch then
pcall(enableAntiDie)
else
pcall(fn34)
end
end, nil, true)

local item2 = MainWindow:SliderBar("Stretch Value", 0.3, 1.5, VisualState.stretchValue or 0.788, function(arg)
VisualState.stretchValue = math.clamp(tonumber(arg) or 0.78, 0.1, 1.5)

if VisualState.stretch then
pcall(fn34)
VisualState.stretch = true
pcall(enableAntiDie)
end

pcall(vlSave1)
end, 0.05)

if stretchRez.AddSub then
stretchRez.AddSub(item2.Card)
end
end

do
MainWindow:Section("ESP")

_G._RaVeEspToggle = processInput("Aura ESP", false, function(adaptESPEnabled)
if _G._AdaptESPSetEnabled then
pcall(_G._AdaptESPSetEnabled, adaptESPEnabled)
else
_G._AdaptESPEnabled = adaptESPEnabled
end
end, nil, true)

_G._RaVeBoxedEspToggle = processInput("Boxed ESP", false, function(adaptESPShowBox)
if _G._AdaptESPSetShowBox then
pcall(_G._AdaptESPSetShowBox, adaptESPShowBox)
else
_G._AdaptESPShowBox = adaptESPShowBox
end
end)

_G._RaVeTracerToggle = processInput("Show Tracker", false, function(adaptESPShowTracer)
if _G._AdaptESPSetShowTracer then
pcall(_G._AdaptESPSetShowTracer, adaptESPShowTracer)
else
_G._AdaptESPShowTracer = adaptESPShowTracer
end
end)

_G._RaVeRagdollToggle = processInput("Ragdoll Countdown", true, function(arg)
_G._RaVeRagdollCountdown = arg == true
end)

if _G._RaVeEspToggle and _G._RaVeEspToggle.AddSub then
for _, loopEntry in ipairs({ _G._RaVeBoxedEspToggle, _G._RaVeTracerToggle, _G._RaVeRagdollToggle }) do
if loopEntry and loopEntry.Card then
_G._RaVeEspToggle.AddSub(loopEntry.Card)
end
end

if _G._RaVeEspToggle.SetExpanded then
_G._RaVeEspToggle.SetExpanded(false)
end
end

do
local function createOrResetBillboard(arg)
return arg and arg.Get and arg.Get() == true
end

pcall(function()
_G._AdaptESPSetShowBox(createOrResetBillboard(_G._RaVeBoxedEspToggle))
end)

pcall(function()
_G._AdaptESPSetShowTracer(createOrResetBillboard(_G._RaVeTracerToggle))
end)

pcall(function()
_G._AdaptESPSetEnabled(createOrResetBillboard(_G._RaVeEspToggle))
end)

_G._RaVeRagdollCountdown = createOrResetBillboard(_G._RaVeRagdollToggle)
end
end

MainWindow:Section("Performance")

processInput("Anti Lag", false, function(antilag)
VisualState.antilag = antilag

if antilag then
pcall(adaptStartAntiLag)
else
pcall(adaptStopAntiLag)
end
end)

processInput("Potato Graphics", false, function(potato)
VisualState.potato = potato

if potato then
pcall(adaptStartVisualStrip)
else
pcall(adaptStopVisualStrip)
end
end)

processInput("Shiny Graphics", false, function(arg)
if arg then
pcall(removeAttachments)
else
pcall(updateCharacterState)
end
end)

do
local darkMode = processInput("Dark Mode", false, function(arg)
pcall(_G._RaVeSetDarkMode, arg)
end, nil, true)

local Darkness = MainWindow:SliderBar("Darkness", 0.5, 6, _G._RaVeDarkLevel or 2, function(arg)
pcall(_G._RaVeSetDarkLevel, arg)
pcall(vlSave1)
end, 0.1)

if darkMode.AddSub then
darkMode.AddSub(Darkness.Card)
end
end
end

do
do
MainWindow.SetCategory("VISUAL")
MainWindow:Section("Cosmetics")

MainWindow:Button("Avatar Catalog", function()
if _G._KawatanOpenSkinGallery then
pcall(_G._KawatanOpenSkinGallery)
end
end, nil, "OPEN")

_G._VlonESkinToggle = processInput("Custom Skin", false, function(arg)
fn38(arg)
end)

if _G._RaVeKorbloxSelectorPending then
_G._RaVeKorbloxSelectorPending()
end

_G._VlonEBodyTypeSelector = MainWindow:Cycle("Body Type", _G._KawatanBodyTypeOrder or { "OFF" }, _G._VlonEBodyType or "OFF", function(arg)
pcall(fn37, arg)
pcall(vlSave1)
end)

_G._KawatanOnSetPicked = function(kawatanSkinColor)
_G._KawatanSkinColor = kawatanSkinColor
local vlonESkinToggle = _G._VlonESkinToggle
local get = vlonESkinToggle and vlonESkinToggle.Get
local stateFlag

if get then
local item2 = true
stateFlag = vlonESkinToggle.Get() == item2
else
stateFlag = get
end

if stateFlag then
task.spawn(function()
fn38(true)
end)
end

pcall(vlSave1)
end

MainWindow.SetCategory("VISUAL")
_G._VlonEUIGalaxyEnabled = false
_G._VlonEUIMoneyRainEnabled = false
MainWindow.SetCategory("VISUAL")

do
local stateFlag = false

local function createOrResetBillboard(arg)
local character = arg or localPlayer.Character
character = character and character:FindFirstChild("Head")
if not character then
return
end
local transparency = stateFlag and 1 or 0
character.Transparency = transparency
character.LocalTransparencyModifier = transparency

for _, child in ipairs(character:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") then
child.Transparency = transparency
elseif child:IsA("BasePart") then
child.Transparency = transparency
child.LocalTransparencyModifier = transparency
end
end
end

local function checkAnchored(arg)
task.spawn(function()
arg:WaitForChild("Head", 10)

while arg.Parent do
if stateFlag then
	createOrResetBillboard(arg)
end

task.wait(0.35)
end
end)

arg.DescendantAdded:Connect(function()
if stateFlag then
task.defer(createOrResetBillboard, arg)
end
end)
end

processInput("Headless", false, function(arg)
stateFlag = arg
_G._VlonEStandaloneHeadless = arg and true or false
createOrResetBillboard()
pcall(vlSave1)
end)

if _G._VlonEStandaloneHeadless == true then
stateFlag = true
createOrResetBillboard()
end

if localPlayer.Character then
checkAnchored(localPlayer.Character)
end

safeConnect(localPlayer.CharacterAdded, checkAnchored)
end
end

MainWindow.SetCategory("CUSTOMIZE")
MainWindow:Section("Mobile Buttons")

processInput("Lock UI", false, function(arg)
if _G._VlonEMobileSetLocked then
_G._VlonEMobileSetLocked(arg)
end
end)

MainWindow:Cycle("Button Shape", { "RECTANGLE", "CUBE", "CIRCLE" }, _G._KawatanMobileGetShape and _G._KawatanMobileGetShape() or "RECTANGLE", function(arg)
if _G._KawatanMobileSetShape then
_G._KawatanMobileSetShape(arg)
end
end)

MainWindow:LabelSegment("Drag Mode", { "ONE", "ALL" }, _G._KawatanMobileGetDragAll and _G._KawatanMobileGetDragAll() and "ALL" or "ONE", function(arg)
if _G._KawatanMobileSetDragAll then
_G._KawatanMobileSetDragAll(arg == "ALL")
end
end)

MainWindow:Button("Reset Mobile Position", function()
if _G._VlonEMobileResetPosition then
_G._VlonEMobileResetPosition()
end

if _G._VlonEMobileResetMainPosition then
_G._VlonEMobileResetMainPosition()
end
end)

do
local showMobileButtons = processInput("Show Mobile Buttons", true, function(arg)
if _G._KawatanMobileSetAllShown then
_G._KawatanMobileSetAllShown(arg)
end
end, nil, true)

task.defer(function()
local kawatanMobileLabels = _G._KawatanMobileLabels and _G._KawatanMobileLabels() or {}
local layoutOrder = showMobileButtons.Card and showMobileButtons.Card.LayoutOrder or 0

for i, kawatanMobileLabel in ipairs(kawatanMobileLabels) do
local strName = kawatanMobileLabel:gsub("%s+", " ")
MainWindow.SetCategory("CUSTOMIZE")

local item2 = MainWindow:Toggle(strName, not (_G._KawatanMobileIsHidden and _G._KawatanMobileIsHidden(kawatanMobileLabel)), function(arg)
if _G._KawatanMobileSetHidden then
_G._KawatanMobileSetHidden(kawatanMobileLabel, not arg)
end
end)

if item2.Card then
item2.Card.LayoutOrder = layoutOrder + i
end

if showMobileButtons.AddSub and item2.Card then
showMobileButtons.AddSub(item2.Card)
end
end

if showMobileButtons.SetExpanded then
showMobileButtons.SetExpanded(false)
end
end)
end
end

do
MainWindow:Section("Reset")

MainWindow:KeyBind("UI Toggle Key", configTable.uiKey or "LeftControl", function(arg)
if MainWindow.SetToggleKey then
MainWindow.SetToggleKey(arg)
end

configTable.uiKey = arg.Name
pcall(vlSave1)
pcall(vlSave1)
end)

MainWindow:Button("Reset All Settings", function()
_G._RaVeSettingsReset = true

local LaggerState = {
["Auto Save"] = true,
["Auto Steal"] = true,
["Ragdoll Steal"] = true,
["Ragdoll Countdown"] = true,
}

local dataTable = { ["Show Mobile Buttons"] = true }
local kawatanMobileLabels = _G._KawatanMobileLabels and _G._KawatanMobileLabels() or {}

for _, kawatanMobileLabel in ipairs(kawatanMobileLabels) do
dataTable[kawatanMobileLabel:gsub("%s+", " ")] = true
end

local item2 = pairs
local allToggles = MainWindow._AllToggles or {}

for k, allToggle in item2(allToggles) do
if allToggle and allToggle.Set and not dataTable[k] then
pcall(allToggle.Set, LaggerState[k] == true)
end
end

local item3 = pairs
local keyResetters = MainWindow._KeyResetters or {}

for _, keyResetter in item3(keyResetters) do
pcall(keyResetter)
end

pcall(function()
_G._KawatanMobileSetAllShown(true)
end)

local showMobileButtons = MainWindow._AllToggles and MainWindow._AllToggles["Show Mobile Buttons"]

if showMobileButtons and showMobileButtons.SetVisual then
pcall(showMobileButtons.SetVisual, true)
end

for _, kawatanMobileLabel in ipairs(kawatanMobileLabels) do
pcall(function()
_G._KawatanMobileSetHidden(kawatanMobileLabel, false)
end)

local allToggles2 = MainWindow._AllToggles and MainWindow._AllToggles[kawatanMobileLabel:gsub("%s+", " ")]

if allToggles2 and allToggles2.SetVisual then
pcall(allToggles2.SetVisual, true)
end
end

pcall(fn29)
pcall(disconnectHandler)
pcall(fn42)
pcall(fn45)
pcall(disableAntiDie)
pcall(startAntiLag, false)

pcall(function()
if type(_G.stopAntiDie) == "function" then
_G.stopAntiDie()
end
end)

pcall(function()
if _G._AceAntiFling then
_G._AceAntiFling.SetEnabled(false)
end
end)

pcall(function()
if _G.AdaptAntiVoid then
_G.AdaptAntiVoid.Stop()
end
end)

pcall(getStealMode)

pcall(function()
WaypointState.stopL()
WaypointState.stopR()
end)

local item4 = CombatState
local item5 = CombatState
local item6 = CombatState
local item7 = CombatState
local item8 = false
CombatState.aimbot = false
item4.desync = item8
item5.swing = false
item6.desyncSwing = false
item7.tpMirror = false
adaptTPMirrorEnabled = false
_G._AdaptTPMirrorEnabled = false
local item9 = StealState
PlotState.enabled = false
StealState.AutoSteal = false
SpeedState.NS = 60
SpeedState.CS = 29
SpeedState.LG_N = 10.1
SpeedState.LG_C = 15
SpeedState.family = "normal"
SpeedState.carry = false
_G._RaVeSpeedMethod = "V2"

pcall(function()
_G._RaVeSpeedMethodRow.Set("V2")
end)

StealConfig.StealRadius = 63
StealConfig.StealDuration = 1.3
_G._AdaptStealMode = "SEMI"
_G._AdaptBatMode = "DEFAULT"
_G._AdaptTpBatMode = "HIGH PING"
_G._AdaptInfJumpMode = "HOLD"
dropMode = "JUMP"

if _G._KawatanStealRadii then
local kawatanStealRadii = _G._KawatanStealRadii
_G._KawatanStealRadii.Normal = 63
kawatanStealRadii.Semi = 8.7
end

if _G.AceNormalAutoStealSetRadius then
pcall(_G.AceNormalAutoStealSetRadius, 63)
end

if _G.AceSemiAutoStealSetRadius then
pcall(_G.AceSemiAutoStealSetRadius, 8.7)
end

if _G._CandyRefreshStealRows then
pcall(_G._CandyRefreshStealRows)
end

CombatState.aimSpd = 48
VisualState.fovVal = 120
local nebulaGradColor1 = configTable
configTable.on = {}
nebulaGradColor1.keys = {}
local nebulaGradColor2 = _G
_G._AdaptKbSave = {}
nebulaGradColor2._AdaptCtrlSave = {}
local nebulaGradColor3 = _G
_G._AdaptMainPos = nil
nebulaGradColor3._VlPbPos = nil

pcall(function()
MainWindow.ResetPositions()
end)

pcall(function()
_G._KawatanResetStealBarPosition()
end)

pcall(function()
_G._VlonEMobileResetPosition()
end)

_G._AdaptUIScale = 100
local nebulaGradColor4 = _G
_G._KawatanMobileScale = 100
nebulaGradColor4._KawatanStealBarScale = 100

pcall(function()
_G._KawatanMobileSetScale(100)
end)

pcall(function()
_G._KawatanStealBarSetScale(100)
end)

pcall(function()
_G._KawatanMobileScaleSlider.Set(1)
end)

pcall(function()
_G._KawatanStealBarScaleSlider.Set(1)
end)

_G._KuRuLayoutMode = "TOP"
_G._VlonESkinPreset = "RED"
_G._VlonEBodyType = "OFF"
_G._KawatanSkinColor = "PURPLE"

pcall(function()
_G._KawatanCloseSkinGallery()
end)

pcall(function()
_G._KawatanRefreshGalleryCards()
end)

if MainWindow.SetUIScale then
MainWindow.SetUIScale(100)
end

if MainWindow.SetLayoutMode then
MainWindow.SetLayoutMode("TOP")
end

pcall(function()
_G._VlonEBodyTypeSelector.Set("OFF", false)
end)

pcall(function()
_G._RaVeUISizeSlider.Set(1)
end)

_G._AdaptAnimPack = "Off"
pcall(_G._RaVeApplyAnimationPack, "Off")
_G._AdaptSkyMode = "Off"
pcall(_G._AdaptStopSky)

pcall(function()
_G._RaVeSkyDropdown.Set("Off")
end)

_G._RaVeKorbloxMode = "Off"
_G._KawatanKorbloxUserSet = false
pcall(_G._RaVeClearKorblox)

pcall(function()
_G._RaVeKorbloxSelector.Set("Off", false)
end)

for _, nebulaGradTrans1 in ipairs({ "Vilon_PC.json", "Vilon.json", "Vilon_Pad.json", "RaVe_PC.json", "RaVe.json", "RaVe_Pad.json" }) do
pcall(function()
local nebulaGradTrans2 = delfile
local stateFlag

if nebulaGradTrans2 then
stateFlag = not isfile or isfile(nebulaGradTrans1)
else
stateFlag = nebulaGradTrans2
end

if stateFlag then
delfile(nebulaGradTrans1)
elseif writefile then
writefile(nebulaGradTrans1, "{}")
end
end)
end

task.delay(0.75, function()
_G._RaVeSettingsReset = false
end)
end)

AutoState.auto = true

do
local function createOrResetBillboard()
local instance = Instance.new("ScreenGui")
instance.Name = "VlonEMobileControls"
instance.ResetOnSpawn = false
instance.IgnoreGuiInset = true
instance.DisplayOrder = 999999
instance.ZIndexBehavior = Enum.ZIndexBehavior.Global

pcall(function()
instance.Parent = gethui and gethui() or game:GetService("CoreGui")
end)

if not instance.Parent then
instance.Parent = localPlayer:WaitForChild("PlayerGui")
end

instance.Archivable = false
local showMobileButtons = setupListener("Show Mobile Buttons", true)
instance.Enabled = showMobileButtons

_G._KawatanMobileSetAllShown = function(arg)
showMobileButtons = arg ~= false
instance.Enabled = showMobileButtons
end

_G._KawatanMobileGetAllShown = function()
return showMobileButtons
end

local raVeTheme = _G._RaVeTheme or {}
local accent = raVeTheme.accent or Color3.fromRGB(120, 160, 255)
local bg = raVeTheme.bg or Color3.fromRGB(5, 7, 12)
local line = raVeTheme.line or Color3.fromRGB(26, 34, 42)

local function checkAnchored(arg, arg2)
local kawatanLogoAccents = _G._KawatanLogoAccents

if kawatanLogoAccents then
kawatanLogoAccents = _G._KawatanLogoAccents[_G._KawatanLogoStyle or ""]
end

kawatanLogoAccents = kawatanLogoAccents and kawatanLogoAccents.fill
return kawatanLogoAccents and kawatanLogoAccents[arg] or arg2
end

local danger = raVeTheme.danger or Color3.fromRGB(255, 70, 70)
local good = raVeTheme.good or Color3.fromRGB(40, 200, 120)
local text = raVeTheme.text or Color3.fromRGB(234, 241, 255)
local vlonEMobileStateFile = "Kawatan_Mobile_Buttons_" .. tostring(localPlayer.UserId) .. ".json"
_G._VlonEMobileStateFile = vlonEMobileStateFile
local vlonEMobileState = _G._VlonEMobileState or { locked = false }

if readfile and (not isfile or isfile(vlonEMobileStateFile)) then
pcall(function()
local data = HttpService:JSONDecode(readfile(vlonEMobileStateFile))
if type(data) == "table" then
vlonEMobileState = data
end
end)
end

if vlonEMobileState.layoutVersion ~= 4 then
vlonEMobileState.positions = {}
vlonEMobileState.layoutVersion = 4
end

vlonEMobileState.position = nil
vlonEMobileState.visible = nil
local item2 = "table"
vlonEMobileState.positions = type(vlonEMobileState.positions) == item2 and vlonEMobileState.positions or {}
local LaggerState = {}
local locked = vlonEMobileState.locked == true
local stateFlag = false
local dataTable = { RECTANGLE = { 120, 40, 8 }, CUBE = { 56, 56, 5 }, CIRCLE = { 52, 52, 999 } }
vlonEMobileState.shape = dataTable[vlonEMobileState.shape] and vlonEMobileState.shape or "RECTANGLE"
vlonEMobileState.side = vlonEMobileState.side == "LEFT" and "LEFT" or "RIGHT"
vlonEMobileState.dragAll = vlonEMobileState.dragAll == true
vlonEMobileState.hidden = type(vlonEMobileState.hidden) == "table" and vlonEMobileState.hidden or {}
vlonEMobileState.scale = math.clamp(tonumber(_G._KawatanMobileScale) or tonumber(vlonEMobileState.scale) or 100, 50, 200)
_G._KawatanMobileScale = vlonEMobileState.scale

local function checkHumanoidPhysics()
local rectangle = dataTable[vlonEMobileState.shape] or dataTable.RECTANGLE
local calcVal1 = vlonEMobileState.scale / 100
local itemTable = {}
local calcVal2 = math.floor(rectangle[1] * calcVal1 + 0.5)
local calcVal3 = math.floor(rectangle[2] * calcVal1 + 0.5)
local item3 = rectangle[3]
itemTable[1] = calcVal2
itemTable[2] = calcVal3
itemTable[3] = item3
return itemTable
end

local function checkRagdoll(arg, arg2)
return (arg - 2) * (arg2 + 3)
end

local function fn61(arg)
local currentCamera = workspace.CurrentCamera
currentCamera = currentCamera and currentCamera.ViewportSize
if not currentCamera or currentCamera.X <= 0 or currentCamera.Y <= 0 then
return
end
local absoluteSize = arg.AbsoluteSize
if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
return
end
local anchorPoint = arg.AnchorPoint
local position = arg.Position
local calcVal1 = position.X.Scale * currentCamera.X + position.X.Offset - absoluteSize.X * anchorPoint.X
local calcVal2 = position.Y.Scale * currentCamera.Y + position.Y.Offset - absoluteSize.Y * anchorPoint.Y
local calcVal3 = math.clamp(calcVal1, 4, math.max(4, currentCamera.X - absoluteSize.X - 4))
local calcVal4 = math.clamp(calcVal2, 4, math.max(4, currentCamera.Y - absoluteSize.Y - 4))

if calcVal3 ~= calcVal1 or calcVal4 ~= calcVal2 then
arg.Position = UDim2.new(position.X.Scale, position.X.Offset + calcVal3 - calcVal1, position.Y.Scale, position.Y.Offset + calcVal4 - calcVal2)
end
end

local function vlonEMobileSavePosition()
vlonEMobileState.locked = locked
vlonEMobileState.positions = {}
vlonEMobileState.layoutVersion = 4

for k, item3 in pairs(LaggerState) do
local button = item3.button

vlonEMobileState.positions[k] = {
xScale = button.Position.X.Scale,
xOffset = button.Position.X.Offset,
yScale = button.Position.Y.Scale,
yOffset = button.Position.Y.Offset,
}
end

_G._VlonEMobileState = vlonEMobileState

if writefile and _G._VlonEMobileStateFile then
pcall(function()
writefile(_G._VlonEMobileStateFile, HttpService:JSONEncode(vlonEMobileState))
end)
end
end

_G._VlonEMobileSetLocked = function(arg)
locked = arg and true or false
_G._KawatanUILocked = locked
vlonEMobileSavePosition()
end

_G._KawatanUILocked = locked
_G._VlonEMobileSavePosition = vlonEMobileSavePosition

_G._VlonEMobileResetPosition = function()
if _G._KawatanMobileApplyLayout then
_G._KawatanMobileApplyLayout()
else
vlonEMobileSavePosition()
end
end

local item3 = checkAnchored(2, Color3.fromRGB(24, 180, 220))
local text2 = raVeTheme.text or Color3.fromRGB(234, 240, 255)
local item4 = accent

local function createInstance(arg, arg2)
local item5 = LaggerState[arg.Name]
arg:SetAttribute("Active", arg2 and true or false)
arg.BackgroundColor3 = arg2 and item3 or bg
arg.BackgroundTransparency = arg2 and 0 or 0.05
arg.TextColor3 = arg2 and text2 or text
local uiStroke = arg:FindFirstChildOfClass("UIStroke")

if uiStroke then
uiStroke.Color = arg2 and item4 or line
uiStroke.Transparency = arg2 and 0.2 or 0.3
end

arg.Text = arg2 and (item5 and item5.activeLabel or arg.Name) or arg.Name
end

local function createTextButton(name, layoutOrder, arg, arg2, arg3, arg4, arg5)
local textButton = Instance.new("TextButton")
textButton.Name = name
textButton.LayoutOrder = layoutOrder
local item5 = checkHumanoidPhysics()
local checkFlag = vlonEMobileState.side ~= "LEFT"
textButton.AnchorPoint = Vector2.new(checkFlag and 1 or 0, 0.5)
textButton.Size = UDim2.fromOffset(item5[1], item5[2])
local calcVal1 = (layoutOrder - 1) % 2
local calcVal2 = math.floor((layoutOrder - 1) / 2)
local calcVal3 = item5[1] + 3
local calcVal4

if checkFlag then
calcVal4 = calcVal1 == 0 and -(calcVal3 + 12) or -12
else
calcVal4 = calcVal1 == 0 and 12 or calcVal3 + 12
end

local item6 = checkRagdoll(calcVal2, item5[2])
textButton.Position = UDim2.new(checkFlag and 1 or 0, calcVal4, 0.5, item6)
textButton:SetAttribute("MobileAction", true)
textButton:SetAttribute("DefaultX", calcVal4)
textButton:SetAttribute("DefaultY", item6)
textButton.BackgroundColor3 = bg
textButton.BackgroundTransparency = 0.05
textButton.BorderSizePixel = 0
textButton.Text = name
textButton.TextColor3 = text
textButton.TextSize = 14
textButton.Font = Enum.Font.GothamBold
textButton.AutoButtonColor = false
textButton.Active = true
textButton.ZIndex = 10
textButton.Parent = instance
textButton.TextWrapped = true
local uiStroke = Instance.new("UIStroke", textButton)
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = line
uiStroke.Thickness = 1.2
uiStroke.Transparency = 0.3
Instance.new("UICorner", textButton).CornerRadius = item5[3] >= 999 and UDim.new(1, 0) or UDim.new(0, item5[3])
local positions = vlonEMobileState.positions and vlonEMobileState.positions[name]

if type(positions) == "table" then
textButton.Position = UDim2.new(tonumber(positions.xScale) or 1, tonumber(positions.xOffset) or calcVal4, tonumber(positions.yScale) or 0.5, tonumber(positions.yOffset) or item6)
end

LaggerState[name] = {
button = textButton,
toggle = arg,
activeWhen = arg3,
activeColor = arg4 or danger,
activeLabel = arg5 or name .. " ON",
}

createInstance(textButton, false)
task.defer(fn61, textButton)
textButton.Visible = vlonEMobileState.hidden[name] ~= true

textButton.Activated:Connect(function()
if textButton:GetAttribute("JustDragged") then
return
end

if arg then
local allToggles = MainWindow._AllToggles and MainWindow._AllToggles[arg]

if allToggles and allToggles.Set and allToggles.Get then
	local matchFlag = not allToggles.Get()

	if matchFlag and (arg == "Auto Left" or arg == "Auto Right" or arg == "Bat Aimbot" or arg == "Desync Aimbot") then
		for _, item7 in ipairs({ "Auto Left", "Auto Right", "Bat Aimbot", "Desync Aimbot" }) do
			if item7 ~= arg then
				local allToggles2 = MainWindow._AllToggles and MainWindow._AllToggles[item7]

				if allToggles2 and allToggles2.Set and allToggles2.Get and allToggles2.Get() then
					allToggles2.Set(false)
				end
			end
		end
	end

	allToggles.Set(matchFlag)
end
elseif arg2 then
pcall(arg2)

if arg3 then
	local ok, result = pcall(arg3)
	createInstance(textButton, ok and result or false)
else
	createInstance(textButton, true)

	task.delay(0.22, function()
		if textButton.Parent then
			createInstance(textButton, false)
		end
	end)
end
end
end)

local matchFlag = nil
local item7 = nil
local item8 = nil
local extraFlag = nil
local itemTable = nil

textButton.InputBegan:Connect(function(input)
if locked then
return
end

if stateFlag then
return
end

if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
stateFlag = true
local position = input.Position
local position2 = textButton.Position
local item9 = false
matchFlag = true
item7 = position
item8 = position2
extraFlag = item9
itemTable = nil

if vlonEMobileState.dragAll then
	itemTable = {}

	for k, galaxyGradColor1 in pairs(LaggerState) do
		itemTable[k] = galaxyGradColor1.button.Position
	end
end
end
end)

safeConnect(UserInputService.InputChanged, function(arg6)
if not matchFlag then
return
end

if arg6.UserInputType == Enum.UserInputType.Touch or arg6.UserInputType == Enum.UserInputType.MouseMovement then
local calcVal5 = arg6.Position - item7

if calcVal5.Magnitude > 5 and not extraFlag then
	extraFlag = true
	textButton:SetAttribute("JustDragged", true)
end

if itemTable then
	for k, item9 in pairs(LaggerState) do
		local galaxyGradColor1 = itemTable[k]

		if galaxyGradColor1 then
			item9.button.Position = UDim2.new(galaxyGradColor1.X.Scale, galaxyGradColor1.X.Offset + calcVal5.X, galaxyGradColor1.Y.Scale, galaxyGradColor1.Y.Offset + calcVal5.Y)
		end
	end
else
	textButton.Position = UDim2.new(item8.X.Scale, item8.X.Offset + calcVal5.X, item8.Y.Scale, item8.Y.Offset + calcVal5.Y)
end
end
end)

safeConnect(UserInputService.InputEnded, function(arg6)
if not matchFlag then
return
end

if arg6.UserInputType == Enum.UserInputType.Touch or arg6.UserInputType == Enum.UserInputType.MouseButton1 then
matchFlag = false
stateFlag = false
itemTable = nil

if extraFlag then
	vlonEMobileSavePosition()

	task.delay(0.2, function()
		if textButton.Parent then
			textButton:SetAttribute("JustDragged", false)
		end
	end)
end
end
end)

return textButton
end

_G._KawatanShowMobileAction = function()
return true
end

_G._KawatanToggleMobileAction = function()
return true
end

_G._KawatanMobileActionShown = function()
return true
end

_G._KawatanMobileLabels = function()
local itemTable = {}

for k in pairs(LaggerState) do
itemTable[#itemTable + 1] = k
end

table.sort(itemTable, function(arg, arg2)
return (LaggerState[arg].button.LayoutOrder or 0) < (LaggerState[arg2].button.LayoutOrder or 0)
end)

return itemTable
end

_G._KawatanMobileIsHidden = function(arg)
return vlonEMobileState.hidden[arg] == true
end

_G._KawatanMobileSetHidden = function(arg, arg2)
local item5 = LaggerState[arg]
if not item5 then
return
end
vlonEMobileState.hidden[arg] = arg2 and true or nil
item5.button.Visible = not arg2
vlonEMobileSavePosition()
end

_G._KawatanMobileApplyLayout = function()
local item5 = checkHumanoidPhysics()
local checkFlag = vlonEMobileState.side ~= "LEFT"

for _, item6 in pairs(LaggerState) do
local button = item6.button
local layoutOrder = button.LayoutOrder or 1
local calcVal1 = (layoutOrder - 1) % 2
local calcVal2 = math.floor((layoutOrder - 1) / 2)
local calcVal3 = item5[1] + 8
local calcVal4

if checkFlag then
calcVal4 = calcVal1 == 0 and -(calcVal3 + 12) or -12
else
calcVal4 = calcVal1 == 0 and 12 or calcVal3 + 12
end

button.AnchorPoint = Vector2.new(checkFlag and 1 or 0, 0.5)
button.Size = UDim2.fromOffset(item5[1], item5[2])
button.Position = UDim2.new(checkFlag and 1 or 0, calcVal4, 0.5, checkRagdoll(calcVal2, item5[2]))
button.TextSize = item5[1] < 80 and 11 or 14
local uiCorner = button:FindFirstChildOfClass("UICorner")

if uiCorner then
uiCorner.CornerRadius = item5[3] >= 999 and UDim.new(1, 0) or UDim.new(0, item5[3])
end

fn61(button)
end

vlonEMobileSavePosition()
end

_G._KawatanMobileSetScale = function(arg)
vlonEMobileState.scale = math.clamp(tonumber(arg) or 100, 50, 200)
_G._KawatanMobileScale = vlonEMobileState.scale
local item5 = checkHumanoidPhysics()

for _, item6 in pairs(LaggerState) do
local button = item6.button
button.Size = UDim2.fromOffset(item5[1], item5[2])
button.TextSize = item5[1] < 80 and 11 or 14
local item7 = button:FindFirstChildOfClass("UICorner")

if item7 then
item7.CornerRadius = item5[3] >= 999 and UDim.new(1, 0) or UDim.new(0, item5[3])
end

fn61(button)
end

vlonEMobileSavePosition()
end

_G._KawatanMobileGetScale = function()
return vlonEMobileState.scale
end

_G._KawatanMobileSetShape = function(arg)
vlonEMobileState.shape = dataTable[arg] and arg or "RECTANGLE"
_G._KawatanMobileApplyLayout()
end

_G._KawatanMobileGetShape = function()
return vlonEMobileState.shape
end

_G._KawatanMobileSetSide = function(arg)
vlonEMobileState.side = arg == "LEFT" and "LEFT" or "RIGHT"
_G._KawatanMobileApplyLayout()
end

_G._KawatanMobileGetSide = function()
return vlonEMobileState.side
end

_G._KawatanMobileSetDragAll = function(arg)
vlonEMobileState.dragAll = arg and true or false
vlonEMobileSavePosition()
end

_G._KawatanMobileGetDragAll = function()
return vlonEMobileState.dragAll == true
end

_G._KawatanMobileIsLocked = function()
return locked
end

local function createCorner(arg)
if arg == "Auto Left" then
return WaypointState.L == true
end

if arg == "Auto Right" then
return WaypointState.R == true
end

if arg == "Bat Aimbot" then
return CombatState.aimbot == true
end

if arg == "Desync Aimbot" then
return CombatState.desync == true
end
local allToggles = MainWindow._AllToggles and MainWindow._AllToggles[arg]
return allToggles and allToggles.Get and allToggles.Get() == true or false
end

local function createStroke(family, carry)
local item5 = SpeedState
SpeedState.family = family
item5.carry = carry
configTable.on["Carry Mode"] = carry == true
local character = localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
character = character and character:FindFirstChild("HumanoidRootPart")

if humanoid then
humanoid.PlatformStand = false
humanoid.AutoRotate = true
end

if character then
character.AssemblyAngularVelocity = Vector3.zero
end

if _G._RvRefreshSpeedModes then
_G._RvRefreshSpeedModes()
end

pcall(vlSave1)
end

createTextButton("DROP", 1, nil, registerConnection, nil, danger, "DROPPED")
createTextButton("AUTO LEFT", 2, "Auto Left")
createTextButton("AIMBOT", 3, "Bat Aimbot")
createTextButton("AUTO RIGHT", 4, "Auto Right")
createTextButton("TP DOWN", 10, nil, executeAction, nil, danger, "TP DOWN")

createTextButton("CARRY SPEED", 6, nil, function()
if SpeedState.family == "normal" and SpeedState.carry then
createStroke("normal", false)
else
createStroke("normal", true)
end
end, function()
return SpeedState.family == "Bedwars" and SpeedState.carry
end, good, "CARRY ON")

createTextButton("LAGGER CARRY", 7, nil, function()
if SpeedState.family == "lagger" and SpeedState.carry then
createStroke("normal", false)
else
createStroke("lagger", true)
end
end, function()
return SpeedState.family == "lagger" and SpeedState.carry
end, good, "LAG CARRY ON")

createTextButton("LAGGER SPEED", 8, nil, function()
if SpeedState.family == "Duel" and not SpeedState.carry then
createStroke("normal", false)
else
createStroke("lagger", false)
end
end, function()
return SpeedState.family == "lagger" and not SpeedState.carry
end, good, "LAG SPEED ON")

createTextButton("TP BAT", 15, "Desync Aimbot")

createTextButton("INSTA RESET", 10, nil, function()
if type(_G._AceInstaReset) == "function" then
pcall(_G._AceInstaReset)
end
end, nil, danger, "RESETTING")

task.spawn(function()
while instance.Parent do
for _, item5 in pairs(LaggerState) do
if item5.toggle then
	local allToggles = MainWindow._AllToggles and MainWindow._AllToggles[item5.toggle]
	local item6 = createCorner(item5.toggle)
	createInstance(item5.button, item6)

	if allToggles and allToggles.SetVisual and allToggles.Get then
		if allToggles.Get() == true ~= item6 then
			pcall(allToggles.SetVisual, item6)
		end
	end
elseif item5.activeWhen then
	local ok, result = pcall(item5.activeWhen)
	createInstance(item5.button, ok and result or false)
end
end

task.wait(0.12)
end
end)
end

createOrResetBillboard()
end
end

local item2

do
_G._AdaptBootDone = true

task.spawn(function()
task.wait(0.3)
if _G._RaVeSettingsReset then
return
end

if setupListener("Auto Medusa", false) then
pcall(cleanupSession)
end

StealState.AutoSteal = setupListener("Auto Steal", false)
StealConfig.AutoStealEnabled = StealState.AutoSteal

if StealState.AutoSteal then
pcall(fn28)
end

task.spawn(function()
while task.wait(3) do
if StealState.AutoSteal then
if not (_G._KawatanStealAnyLive and _G._KawatanStealAnyLive()) then
pcall(fn28)
elseif _G._AdaptStealMode == "NORMAL" and normalStealAction then
pcall(normalStealAction)
end
end
end
end)
end)

task.spawn(function()
task.wait(1)
pcall(vlSave1)
end)

item2 = nil

do
local function createOrResetBillboard(arg)
if not arg then
return
end
local head = arg:FindFirstChild("Head") or arg:WaitForChild("Head", 10)
if not head then
return
end
local raVeHeadBB = head:FindFirstChild("RaVeHeadBB")

if raVeHeadBB then
raVeHeadBB:Destroy()
end

local billboardGui = Instance.new("BillboardGui", head)
billboardGui.Name = "RaVeHeadBB"
billboardGui.Size = UDim2.fromScale(4.6, 1.4)
billboardGui.StudsOffset = Vector3.new(0, 1.9, 0)
billboardGui.AlwaysOnTop = true
billboardGui.ResetOnSpawn = false
billboardGui.LightInfluence = 0
billboardGui.MaxDistance = 150
local raVeTheme = _G._RaVeTheme or {}

local function createUIGradient(arg2)
local uiGradient = Instance.new("UIGradient", arg2)
local colorSequence = ColorSequence.new
local LaggerState = {}
local item3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 228, 255))
local item4 = ColorSequenceKeypoint.new(0.5, raVeTheme.accent or Color3.fromRGB(48, 160, 255))
local item5 = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 108, 210)))
LaggerState[1] = item3
LaggerState[2] = item4

do
local values = table.pack(table.unpack(item5, 1, item5.n))
table.move(values, 1, values.n, 3, LaggerState)
end

uiGradient.Color = colorSequence(LaggerState)
local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", arg2)
uiTextSizeConstraint.MinTextSize = 6
uiTextSizeConstraint.MaxTextSize = 15
return uiGradient
end

local instance = Instance.new("TextLabel", billboardGui)
instance.Size = UDim2.new(1, 0, 0.46, 0)
instance.BackgroundTransparency = 1
instance.Text = "discord.gg/kawatanhub"
instance.Font = Enum.Font.GothamBlack
instance.TextScaled = true
instance.TextColor3 = Color3.fromRGB(255, 255, 255)
instance.TextStrokeTransparency = 0
instance.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
local item3 = createUIGradient(instance)
local textLabel = Instance.new("TextLabel", billboardGui)
textLabel.Size = UDim2.new(1, 0, 0.46, 0)
textLabel.Position = UDim2.new(0, 0, 0.54, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "0"
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextScaled = true
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeTransparency = 0
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
local item4 = createUIGradient(textLabel)
item2 = textLabel

task.spawn(function()
while instance.Parent do
local vector2 = Vector2.new(math.sin(tick() * 0.9) * 0.18, 0)
item3.Offset = vector2
item4.Offset = vector2
task.wait(0.04)
end
end)
end

task.spawn(function()
while task.wait(1) do
local character = localPlayer.Character

if character then
local head = character:FindFirstChild("Head")

if head and not head:FindFirstChild("RaVeHeadBB") then
pcall(function()
	createOrResetBillboard(character)
end)
end
end
end
end)

safeConnect(localPlayer.CharacterAdded, function(arg)
task.wait(0.1)

pcall(function()
createOrResetBillboard(arg)
end)
end)

if localPlayer.Character then
task.spawn(function()
task.wait(0.1)

pcall(function()
createOrResetBillboard(localPlayer.Character)
end)
end)
end
end
end

do
local calcVal1 = 0

safeConnect(RunService.RenderStepped, function(arg)
if not item2 or not item2.Parent then
return
end
local character = localPlayer.Character
if not character then
return
end
local item3 = character:FindFirstChild("HumanoidRootPart")
if not item3 then
return
end
local item4 = character:FindFirstChildOfClass("Humanoid")
local l = WaypointState.L or WaypointState.R

if item4 and not l and item4.MoveDirection.Magnitude == 0 then
calcVal1 = 0
item2.Text = "0"
return
end

local assemblyLinearVelocity = item3.AssemblyLinearVelocity
local magnitude = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude
local calcVal2 = 0

if not l then
calcVal2 = tonumber(getCurrentSpeed()) or 0

if calcVal2 > 0 then
local calcVal3 = math.min(magnitude, calcVal2)
calcVal1 = math.min(calcVal1, calcVal2)
magnitude = calcVal3
end
end

calcVal1 += (magnitude - calcVal1) * (1 - math.exp(-(magnitude > calcVal1 and 14 or 2.2) * math.clamp(arg or 0.016666666666666666, 0.0041666666666666666, 0.066666666666666666)))

if calcVal2 > 0 and calcVal1 >= calcVal2 * 0.9 then
calcVal1 = calcVal2
end

if calcVal1 < 0.15 then
calcVal1 = 0
end

item2.Text = string.format("%d", math.floor(calcVal1 + 0.5))
end)
end

-- =============================================================================
-- [MODULE: RAGDOLL TIMER & BILLBOARD GUI ENGINE]
-- =============================================================================
task.spawn(function()
	local ragdollRunService = game:GetService("RunService")
	local ragdollPlayer = game:GetService("Players").LocalPlayer
	local defaultRagdollDuration = 2.5
	local anchoredRagdollDuration = 4.5
	local ragdollTimerDisplay = nil

	local function createRagdollBillboard(char)
		if not char then return end
		local headPart = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
		if not headPart then return end
		
		local existingBB = headPart:FindFirstChild("RaVeRagdollBB")
		if existingBB then
			existingBB:Destroy()
		end

		local billboardGui = Instance.new("BillboardGui", headPart)
		billboardGui.Name = "RaVeRagdollBB"
		billboardGui.Size = UDim2.new(0, 120, 0, 44)
		billboardGui.StudsOffset = Vector3.new(0, 4.4, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.ResetOnSpawn = false
		billboardGui.LightInfluence = 0

		local textLabel = Instance.new("TextLabel", billboardGui)
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = ""
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.TextScaled = true
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		Instance.new("UIGradient", textLabel).Color = ColorSequence.new(Color3.fromRGB(46, 166, 255))
		ragdollTimerDisplay = textLabel
	end

	if ragdollPlayer.Character then
		createRagdollBillboard(ragdollPlayer.Character)
	end

	ragdollPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.3)
		pcall(function()
			createRagdollBillboard(char)
		end)
	end)

	local function isCharacterAnchored(char)
		if not char then return false end
		for _, descendant in ipairs(char:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Anchored and (descendant.Name == "HumanoidRootPart" or descendant.Transparency == 1) then
				return true
			end
		end
		return false
	end

	local function isHumanoidRagdollState(humanoid)
		if not humanoid then return false end
		local state = humanoid:GetState()
		return humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
	end

	local function isCharacterRagdolled(char, humanoid)
		if isHumanoidRagdollState(humanoid) then
			return true
		end

		for _, instanceObj in ipairs({ char, humanoid }) do
			for _, tag in ipairs({ "Ragdoll", "Ragdolled", "IsRagdolled", "Stun", "Stunned" }) do
				local attribute = instanceObj:GetAttribute(tag)
				if attribute == true or (type(attribute) == "number" and attribute > 0) then
					return true
				end
				local valObj = instanceObj:FindFirstChild(tag, true)
				if valObj and valObj:IsA("BoolValue") and valObj.Value then
					return true
				end
				if valObj and (valObj:IsA("NumberValue") or valObj:IsA("IntValue")) and valObj.Value > 0 then
					return true
				end
			end
		end
		return false
	end

	local isTimerActive = false
	local hasTriggeredGo = false
	local wasRagdolled = false
	local ragdollStartTime = 0
	local ragdollEndTime = 0
	local goMessageExpireTime = 0
	local activeDuration = defaultRagdollDuration

	ragdollRunService.Heartbeat:Connect(function()
		local char = ragdollPlayer.Character
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		local rootPart = char and char:FindFirstChild("HumanoidRootPart")

		if not ragdollTimerDisplay or not ragdollTimerDisplay.Parent then
			if char then
				pcall(function()
					createRagdollBillboard(char)
				end)
			end
			return
		end

		if not humanoid or not rootPart or humanoid.Health <= 0 then
			if isTimerActive then
				isTimerActive = false
				ragdollTimerDisplay.Text = ""
			end
			return
		end

		local currentTime = tick()
		local isAnchored = isCharacterAnchored(char)
		local isRagdoll = isCharacterRagdolled(char, humanoid) or isAnchored

		if isRagdoll and not wasRagdolled and not isTimerActive and not hasTriggeredGo then
			isTimerActive = true
			isAnchored = isAnchored and anchoredRagdollDuration
			activeDuration = isAnchored or defaultRagdollDuration
			ragdollStartTime = currentTime
			ragdollEndTime = ragdollStartTime + activeDuration
			ragdollTimerDisplay.Text = string.format("%.1f", activeDuration)
		else
			local previousActiveState = isTimerActive
			if not isTimerActive then
				isAnchored = previousActiveState
			end
			if isAnchored and activeDuration ~= anchoredRagdollDuration then
				activeDuration = anchoredRagdollDuration
				ragdollEndTime = ragdollStartTime + activeDuration
			end
		end

		wasRagdolled = isRagdoll

		if not isRagdoll and not isTimerActive then
			hasTriggeredGo = false
		end

		if isTimerActive then
			local remainingTime = ragdollEndTime - currentTime
			if remainingTime <= 0 then
				isTimerActive = false
				hasTriggeredGo = true
				ragdollTimerDisplay.Text = "GO"
				goMessageExpireTime = currentTime + 0.65
			else
				ragdollTimerDisplay.Text = string.format("%.1f", remainingTime)
			end
		elseif goMessageExpireTime > 0 and currentTime >= goMessageExpireTime then
			ragdollTimerDisplay.Text = ""
			goMessageExpireTime = 0
		end
	end)

	_G._RaVeRagdollTimer = {
		setTimes = function(defaultTime, anchoredTime)
			if type(defaultTime) == "number" then
				defaultRagdollDuration = defaultTime
			end
			if type(anchoredTime) == "number" then
				anchoredRagdollDuration = anchoredTime
			end
		end
	}
end)