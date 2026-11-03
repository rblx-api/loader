-- Antilag / Optimizer (extraido de sxe_full_deobf_by_32e4.txt)
repeat task.wait() until game:IsLoaded()
local n1, n2, n4 = 104592110, 557240548, 616969873
local t8 -- referencia muerta del ofuscador
	local function v343()
		local n34 = 429390507
		local n35 = 1061454987

		if rawget(_G, "__SXE_KillQ") ~= nil then
			return
		end

		_G.__SXE_OptiOn = true
		_G.__SXE_KillQ = {}

		local n36
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local t20 = {
			CustomProximityPromptController = true,
			InteractController = true,
			PlotController = true,
			AnimalController = true,
			PetController = true,
			WorldBrainrotController = true,
			EquipBrainrotsController = true,
			EquipBrainrotsRenderController = true,
			SelectBrainrotsController = true,
			BrainrotPreloadingController = true,
			AssetStreamController = true,
			AdminPanelController = true,
			NotificationController = true,
		}
		local t21 = {}
		local Controllers

		local function v354(child)
			if t21 ~= nil then
				if typeof(child) == "Instance" then
					if not t20[child.Name] and child.Parent == Controllers then
						t21[#t21 + 1] = child

						if not pcall(function()
							child.Parent = nil
						end) then
							task.defer(function()
								local n37 = 342819689

								if t21 ~= nil then
									if child.Parent == Controllers then
										pcall(function()
											child.Parent = nil

											if n2 == n37 then
												n34 += 1695
												n1 = 455508504
												n2 -= 2007
												n35 = 908520807
												n37 -= 1937
											end
										end)
									end
								end
							end)
						end

						return
					end
				end
			end
		end

		local connection

		if n1 == n2 then
			n34 += 921
			n4 -= 1091
			n35 -= 331
			n1 += 809
			n2 = 548336725
			bit32.bxor(nil, nil)

			return nil
		end

		task.spawn(function(...)
			Controllers = ReplicatedStorage:WaitForChild("Controllers", 30)

			if not Controllers or t21 == nil then
				return
			end

			connection = Controllers.ChildAdded:Connect(v354)

			local children = Controllers:GetChildren()
			local n38 = 1051418735

			for i = 1, #children do
				v354(children[i])
			end

			if not (n1 < n38) then
				n1 += 208
				n34 -= 1217
				n35 = 988851267
				n4 += 1488
				n2 -= 1301
				(403 + (select("#", ...) - 0 - 1))[(select("#", ...) - 0 - 1)[select("#", ...) + 0 + 0]]()
			end
		end)
		task.delay(6, function()
			local v360

			n36 = 756316387

			local v361 = t21
			local n39 = 92106050

			t21 = nil

			local u363

			if connection then
				u363 = connection
				connection.Disconnect(u363)
			end

			local u364, v365

			if n36 == 756316387 then
				if not Controllers then
					return
				end

				u364 = nil
				u363 = nil
			else
				n34 = 211927793
				n4 -= 1353
				u364 = n1 + 297
				n1 = u364
				n2 = 988293264
				n36 = 95977660
				n39 -= 1731
				n35 = 243695131
				v360[2] = 42
				v365 = v361[t8]
				pcall(function()
					u364 = 801644196
					u363 = 564969499

					if v365.Parent == nil then
						v365.Parent = Controllers
					end
				end)
			end

			for i = 1, #v361 do
				v365 = v361[i]
				pcall(function()
					u364 = 801644196
					u363 = 564969499

					if v365.Parent == nil then
						v365.Parent = Controllers
					end
				end)
			end
		end)

		local n40

		task.spawn(function()
			local n41 = 742151336

			n40 = 455574234

			local n42 = 413312565
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local n43 = 533320541
			local t22 = {
				RNGMachineVFX = true,
				LuckIcons = true,
				GlossaryBackground = true,
				AnimationGraphEditor = true,
				ML = true,
				PlayWaveEvents = true,
			}

			local function v373(p56)
				local n44 = 101342915

				if not p56 then
					return
				end

				if n1 == 104592110 then
					pcall(function()
						p56:Destroy()

						if n42 == 413314601 then
							n42 -= 515
							n41 -= 647
							n44 -= 1941
							n2 += 1359
							bit32.band(nil, nil)
							bit32.rshift(nil, nil)
						end
					end)
				else
					n1 += 566
					n40 += 272
					n42 -= 267
					n2 -= 501
					n41 -= 582
					n43 = 584719346
				end
			end
			local function v375(child)
				if child then
					if t22[child.Name] then
						v373(child)
					end
				end

				if n43 == n4 then
					n2 -= 1994
					n35 -= 1563
					n4 = 185400159
					n41 += 1875
					n43 = 331913889
					n42 = 852196101

					local v376 = (nil)(nil);
					(nil)(table.unpack({
						v376,
					}, 1, 376))
					n41[nil] = nil
				end
			end

			local children = ReplicatedStorage2:GetChildren()

			for i = 1, #children do
				v375(children[i])
			end

			ReplicatedStorage2.ChildAdded:Connect(v375)
		end)

		local n45

		local function v380()
			n45 = 680654124

			if n34 ~= 429390888 then
				return _G.__SXE_VelFlying == true
			end

			n45 += 1751
			n35 = 870809312
			n34 -= 1160
			n4 = 616776357
			n2 -= 921
			n1 = 217251583
		end

		_G.SXE_Kill = function(p57)
			if not p57 then
				return
			end

			if not v380() then
				pcall(function()
					p57:Destroy()
				end)

				return
			end

			_G.__SXE_KillQ[#_G.__SXE_KillQ + 1] = p57
		end
		_G.SXE_FlushKills = function()
			_G.__SXE_KillQ = {}

			for i = 1, #_G.__SXE_KillQ do
				local v382 = _G.__SXE_KillQ[i]

				if v382 and v382.Parent then
					pcall(function()
						v382:Destroy()
					end)
				end
			end
		end

		local function v383()
			local n46 = 207698086
			local Players2 = game:GetService("Players")
			local n47 = 797251569
			local Lighting = game:GetService("Lighting")
			local LocalPlayer2 = Players2.LocalPlayer
			local n48 = 1006355248

			local function v390(p58)
				_G.SXE_Kill(p58)
			end

			pcall(function()
				workspace.Terrain.Decoration = false
			end)

			local t23 = {
				FriendPanel = true,
				Cash = true,
				Unlock = true,
				Purchases = true,
				PlotSign = true,
				CashPad = true,
				InvisibleWalls = true,
				Multiplier = true,
				Slope = true,
				IncubatorMachine = true,
				FuseMachine = true,
				RobuxShop = true,
				AdminBoard = true,
				SoccerScoreBoard = true,
				CrystalSpinWheel = true,
				Beehive = true,
				CraftingMachine = true,
				Shop = true,
				Road = true,
				EventBoard = true,
				TradePlazaPortal = true,
				LosTraders = true,
				RNGMachine = true,
				Present = true,
				StPatricksPot = true,
				ShopNPCRobuxIdle = true,
				RoadPanel = true,
				Honey = true,
				Trap = true,
				Events = true,
				Sounds = true,
				rods = true,
				Dev = true,
				ToolsAdds = true,
				__PROJECTILES = true,
				CrystalMap = true,
				SpawnLocation = true,
				UFO = true,
				Interacts = true,
			}
			local t24 = {
				Skin = true,
				Laser = true,
				AnimalPodiums = true,
				DeliveryHitbox = true,
				StealHitbox = true,
				AnimalTarget = true,
				MainRoot = true,
				Floor = true,
				Spawn = true,
				Door = true,
				Hitbox = true,
				Base = true,
				Wall = true,
				Roof = true,
				SecondFloor = true,
				ThirdFloor = true,
				["structure base home"] = true,
				Unlock = true,
			}
			local t25 = {
				FriendPanel = true,
				Cash = true,
				Purchases = true,
				PlotSign = true,
				CashPad = true,
				InvisibleWalls = true,
				Multiplier = true,
				Events = true,
				Sounds = true,
				Slope = true,
			}
			local t26 = {
				HumanoidRootPart = true,
				Head = true,
				Torso = true,
				UpperTorso = true,
				LowerTorso = true,
				LeftUpperArm = true,
				LeftLowerArm = true,
				LeftHand = true,
				RightUpperArm = true,
				RightLowerArm = true,
				RightHand = true,
				LeftUpperLeg = true,
				LeftLowerLeg = true,
				LeftFoot = true,
				RightUpperLeg = true,
				RightLowerLeg = true,
				RightFoot = true,
				["Left Arm"] = true,
				["Right Arm"] = true,
				["Left Leg"] = true,
				["Right Leg"] = true,
			}
			local t27 = {
				Humanoid = true,
				Animator = true,
				Attachment = true,
				Motor6D = true,
				AnimationConstraint = true,
				BallSocketConstraint = true,
				Weld = true,
				WeldConstraint = true,
			}
			local t28 = {
				Ground = true,
				Ground_Left = true,
				Ground_Right = true,
			}
			local t29 = {
				Part = true,
				MeshPart = true,
				UnionOperation = true,
				WedgePart = true,
				CornerWedgePart = true,
				TrussPart = true,
				SpawnLocation = true,
				Seat = true,
				VehicleSeat = true,
			}
			local n49

			local function v399(p59)
				n49 = 210177387

				local Parent = p59

				for i = 1, 12 do
					if not Parent then
						return false
					end

					if Parent.Name == "Unlock" then
						return true
					end

					if Parent == workspace then
						return false
					end

					Parent = Parent.Parent
				end

				if n46 < n49 then
					return false
				end

				n1 += 1635
				n2 -= 1344
				n49 = 553028802
				n46 += 775
				n47 += 923
				n48 -= 903
				n4 = 174343896
			end
			local function v402(p60)
				if not LocalPlayer2 or not p60 then
					return false
				end

				local n50 = 126025026

				if p60 == LocalPlayer2.Character or p60.Name == LocalPlayer2.Name then
					if n1 ~= n50 then
						return true
					end

					n47 -= 1794
					n2 = 981123920
					n4 = 750894591
					n48 = 203609753
					n1 -= 1550
					n46 += 875
				end

				return false
			end
			local function v404(p61)
				local ClassName = p61.ClassName
				local v406 = ClassName == "Beam"
					or ClassName == "Trail"
					or ClassName == "ParticleEmitter"
					or ClassName == "PointLight"
					or ClassName == "SpotLight"
					or ClassName == "SurfaceLight"
					or ClassName == "Fire"
					or ClassName == "Smoke"

				v406 = v406 or ClassName == "Sparkles" or ClassName == "BillboardGui"

				return v406
					or ClassName == "SurfaceGui"
					or ClassName == "Highlight"
					or ClassName == "Decal"
					or ClassName == "Texture"
			end
			local function v407(p62)
				if not p62 then
					return false
				end

				if v404(p62) then
					return true
				end

				return t29[p62.ClassName] == true and not p62.CanCollide
			end
			local function v408(p63)
				if p63 and p63.ClassName == "Model" then
					return p63:FindFirstChild("FakeRootPart") ~= nil or p63:FindFirstChild("RootPart") ~= nil
				end

				return false
			end
			local function v409(p64)
				if not p64 or not p64.Parent then
					return
				end

				local descendants = p64:GetDescendants()
				local t30 = {}

				for i = 1, #descendants do
					if v407(descendants[i]) then
						t30[#t30 + 1] = descendants[i]
					end
				end

				for i = 1, #t30 do
					v390(t30[i])
				end
			end
			local function v414(p65)
				if _G.__SXE_KeepPlot then
					return p65 and tostring(p65.Name) == tostring(_G.__SXE_KeepPlot)
				end

				return true
			end
			local function v415(p66)
				return v414(p66)
			end
			local function v416(p67)
				local v417 = p67

				for i = 1, 16 do
					if not v417 then
						return nil
					end

					local Parent = v417.Parent

					if Parent and Parent.Name == "Plots" then
						return v417
					end

					v417 = Parent
				end

				return nil
			end
			local function v420(p68)
				if not p68 then
					return false
				end

				local n51 = 56496018
				local Parent = p68
				local n52 = 664851020
				local v424

				for i = 1, 16 do
					if not Parent then
						break
					end

					if n47 == n51 then
						n4 -= 658
						n35 += 1013
						n52 += 1656
						n47 = 438559205
						n51 += 1232
						n2 = 216569688
						n46 -= 1549
						n48 = 777979390
						(nil)()
						v424 = v424()
					elseif Parent.Name == "RemainingTime" then
						return true
					end

					Parent = Parent.Parent
				end

				local ClassName = p68.ClassName

				if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
					local RemainingTime

					pcall(function()
						RemainingTime = p68:FindFirstChild("RemainingTime", true)
					end)

					if RemainingTime then
						return true
					end
				end

				return false
			end
			local function v428(p69)
				if not p69 or not p69.Parent then
					return
				end

				local children = p69:GetChildren()
				local v430 = #children
				local n53, exitTo4, v433, descendants, v435, n54, v437, v438, exitTo3, v440, ClassName, exitTo2, exitTo, v444, ClassName2, v446

				if true then
					if v430 >= 1 then
						n53 = 1
						exitTo4 = nil

						while true do
							v433 = children[n53]

							if v433.Name == "PlotBlock" then
								descendants = v433:GetDescendants()
								v435 = #descendants
								n54 = 1
								v437 = v435 + 0
								v438 = 1 - n54
								exitTo3 = nil

								for i = 1, v435 do
									v440 = descendants[i]
									ClassName = v440.ClassName

									if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
										exitTo2 = nil

										while not v420(v440) do
											v390(v440)
											exitTo = nil

											while true do
												v438 += n54

												if not (n54 <= 0) then
													if v438 <= v437 then
														v444 = v438
														v440 = descendants[v444]
														ClassName2 = v440.ClassName

														if
															ClassName2 ~= "BillboardGui"
															and ClassName2 ~= "SurfaceGui"
														then
															continue
														end
													else
														exitTo = 1

														break
													end

													break
												elseif v438 >= v437 then
													v444 = v438
													v440 = descendants[v444]
													ClassName2 = v440.ClassName

													if ClassName2 == "BillboardGui" or ClassName2 == "SurfaceGui" then
														break
													end
												else
													exitTo = 1

													break
												end
											end

											if exitTo == 1 then
												exitTo2 = 1

												break
											end
										end

										if exitTo2 == 1 then
											exitTo3 = 1

											break
										end
									end
								end

								if exitTo3 == 1 then
									v446 += nil

									if not (nil <= 0) then
										if v446 <= nil then
											n53 = v446

											continue
										end

										exitTo4 = 1

										break
									end

									if v446 >= nil then
										n53 = v446

										continue
									end

									exitTo4 = 1

									break
								end

								v446 += nil

								if not (nil <= 0) then
									if v446 <= nil then
										n53 = v446

										continue
									end
								elseif v446 >= nil then
									n53 = v446

									continue
								end

								break
							end

							v390(v433)
							v446 += nil

							if not (nil <= 0) then
								if v446 <= nil then
									n53 = v446

									continue
								end
							elseif v446 >= nil then
								n53 = v446

								continue
							end

							break
						end

						if exitTo4 == 1 then
							if n4 == n48 then
								n2 = 623234293
								n48 = 526439547
								n4 = 51793766
								n47 = 1018447204
								n34 += 240
								n46 = 679818334

								if true then
								end
							end
						elseif n4 == n48 then
							n2 = 623234293
							n48 = 526439547
							n4 = 51793766
							n47 = 1018447204
							n34 += 240
							n46 = 679818334

							if true then
							end
						end
					elseif n4 == n48 then
						n2 = 623234293
						n48 = 526439547
						n4 = 51793766
						n47 = 1018447204
						n34 += 240
						n46 = 679818334

						if true then
						end
					end
				elseif v430 <= 1 then
					n53 = 1
					exitTo4 = nil

					while true do
						v433 = children[n53]

						if v433.Name == "PlotBlock" then
							descendants = v433:GetDescendants()
							v435 = #descendants
							n54 = 1
							v437 = v435 + 0
							v438 = 1 - n54
							exitTo3 = nil

							for i = 1, v435 do
								v440 = descendants[i]
								ClassName = v440.ClassName

								if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
									exitTo2 = nil

									while not v420(v440) do
										v390(v440)
										exitTo = nil

										while true do
											v438 += n54

											if not (n54 <= 0) then
												if v438 <= v437 then
													v444 = v438
													v440 = descendants[v444]
													ClassName2 = v440.ClassName

													if ClassName2 ~= "BillboardGui" and ClassName2 ~= "SurfaceGui" then
														continue
													end
												else
													exitTo = 1

													break
												end

												break
											elseif v438 >= v437 then
												v444 = v438
												v440 = descendants[v444]
												ClassName2 = v440.ClassName

												if ClassName2 == "BillboardGui" or ClassName2 == "SurfaceGui" then
													break
												end
											else
												exitTo = 1

												break
											end
										end

										if exitTo == 1 then
											exitTo2 = 1

											break
										end
									end

									if exitTo2 == 1 then
										exitTo3 = 1

										break
									end
								end
							end

							if exitTo3 == 1 then
								v446 += nil

								if not (nil <= 0) then
									if v446 <= nil then
										n53 = v446

										continue
									end

									exitTo4 = 1

									break
								end

								if v446 >= nil then
									n53 = v446

									continue
								end

								exitTo4 = 1

								break
							end

							v446 += nil

							if not (nil <= 0) then
								if v446 <= nil then
									n53 = v446

									continue
								end
							elseif v446 >= nil then
								n53 = v446

								continue
							end

							break
						end

						v390(v433)
						v446 += nil

						if not (nil <= 0) then
							if v446 <= nil then
								n53 = v446

								continue
							end
						elseif v446 >= nil then
							n53 = v446

							continue
						end

						break
					end

					if exitTo4 == 1 then
						if n4 == n48 then
							n2 = 623234293
							n48 = 526439547
							n4 = 51793766
							n47 = 1018447204
							n34 += 240
							n46 = 679818334

							if true then
							end
						end
					elseif n4 == n48 then
						n2 = 623234293
						n48 = 526439547
						n4 = 51793766
						n47 = 1018447204
						n34 += 240
						n46 = 679818334

						if true then
						end
					end
				elseif n4 == n48 then
					n2 = 623234293
					n48 = 526439547
					n4 = 51793766
					n47 = 1018447204
					n34 += 240
					n46 = 679818334

					if true then
					end
				end
			end
			local function sxeStripPetVfx(p70)
				if not p70 then
					return
				end

				local n55 = 49119229
				local descendants = p70:GetDescendants()
				local t31 = {}
				local n56 = 855151177

				for i = 1, #descendants do
					local v455 = descendants[i]
					local Name = v455.Name
					local ClassName = v455.ClassName

					if
						Name == "VfxInstance"
						or Name == "_VfxInstance"
						or Name == "AnimationController"
						or ClassName == "ParticleEmitter"
						or ClassName == "Beam"
						or ClassName == "Trail"
						or ClassName == "Fire"
						or ClassName == "Smoke"
						or ClassName == "Sparkles"
						or ClassName == "Animator"
						or ClassName == "AnimationController"
						or ClassName == "Bone"
						or ClassName == "BillboardGui"
						or ClassName == "SurfaceGui"
					then
						t31[#t31 + 1] = v455
					end
				end

				local n57 = 955849591

				for i = 1, #t31 do
					if n46 == 207698086 then
						v390(t31[i])
					else
						n1 = 18702860
						n48 += 198
						n55 += 911
						n47 = 819804516
						n56 -= 1646
						n35 += 367
						n2 -= 1771
						n46 -= 1624
						n57 -= 3
						(nil)()
					end
				end
			end

			_G.SXE_StripPetVfx = sxeStripPetVfx

			local function v460(p71)
				if not p71 then
					return false
				end

				local v461
				local ClassName = p71.ClassName

				if ClassName == "PathfindingModifier" then
					return false
				end

				if ClassName == "WrapTarget" or ClassName == "WrapLayer" then
					return true
				end

				if ClassName == "Shirt" or ClassName == "ShirtGraphic" then
					return true
				end

				if ClassName == "NoCollisionConstraint" then
					return true
				end

				local n58 = 217881160
				local Name = p71.Name

				if Name == "__HITBOX" or Name == "OriginalPosition" or Name == "OriginalSize" then
					return true
				end

				if t27[ClassName] then
					return false
				end

				if t26[Name] then
					return false
				end

				local n59 = 243178214

				if n34 == 429390507 then
					return true
				end

				n34 -= 780
				n2 = 169222864
				n47 += 1273

				local v466 = n58 + 1280

				n35 -= 1087
				n46 -= 84
				n48 += 1403

				local v467 = n59 - 1527

				while true do
					v461[55] = 108
					n34 -= 780
					n2 = 169222864
					n47 += 1273
					v466 += 1280
					n35 -= 1087
					n46 -= 84
					n48 += 1403
					v467 -= 1527
				end
			end
			local function v468(p72)
				return type(p72) == "string"
					and #p72 == 36
					and string.match(
							p72,
							"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
						)
						~= nil
			end
			local function v469(p73)
				if not p73 or p73.ClassName ~= "Model" then
					return false
				end

				if v402(p73) then
					return false
				end

				if v408(p73) then
					return false
				end

				local Name = p73.Name

				if type(Name) == "string" then
					if string.sub(Name, -6) == "_Clone" then
						return false
					end
				end

				if Players2:GetPlayerFromCharacter(p73) then
					return true
				end

				if Players2:FindFirstChild(Name) then
					return true
				end

				return p73:FindFirstChildOfClass("Humanoid") ~= nil
			end

			local t32 = {}

			local function v472(character)
				local n60 = 523054471

				if _G.__SXE_VelFlying then
					return
				end

				if character and character.Parent and not v402(character) then
					if v469(character) then
						local n61 = 339859976
						local n62 = 138153012

						local function v476()
							local descendants = character:GetDescendants()
							local t33 = {}
							local n63 = 1
							local v480 = #descendants
							local v481, exitTo, v483, v484, v485, n64, v487, v488, n65, v490, v491, exitTo2, exitTo5

							if true then
								if n63 <= v480 then
									repeat
										v483 = n63
										exitTo = nil

										while true do
											if v460(descendants[v483]) then
												v484 = #t33 + 1
												t33[v484] = descendants[v483]
											end

											v481 += nil

											if not (nil <= 0) then
												exitTo = 1

												break
											elseif v481 >= nil then
												v483 = n63

												continue
											end

											break
										end
									until exitTo ~= 1 or not (v481 <= nil)

									v485 = #t33
									n64 = 1

									for i = 1, v485 do
										if n60 == 523054471 then
											v390(t33[i])
										else
											n60 -= 590
											n47 -= 912
											n61 += 1945
											n62 += 1256
											n34 -= 1974
											n2 += 1451
											upv420[nil] = nil
											upv420[upv420[1]]()
										end
									end
								else
									v488 = #t33
									n65 = 1
									v490 = v488 + 0
									v491 = 1 - v488
									exitTo2 = nil

									local exitTo4

									while true do
										v491 += n65

										if not (n65 <= 0) then
											exitTo4 = 1

											break
										end

										if not (v491 >= v490) then
											break
										end

										v487 = v491

										if n60 == 523054471 then
											exitTo4 = 2

											break
										end

										n60 -= 590
										n47 -= 912
										n61 += 1945
										n62 += 1256
										n34 -= 1974
										n2 += 1451
										upv420[nil] = nil
										upv420[upv420[1]]()
									end

									if exitTo4 == 1 then
										if v491 <= v490 then
											v487 = v491

											local exitTo7

											while true do
												if n60 == 523054471 then
													exitTo7 = 1

													break
												end

												n60 -= 590
												n47 -= 912
												n61 += 1945
												n62 += 1256
												n34 -= 1974
												n2 += 1451
												upv420[nil] = nil
												upv420[upv420[1]]()
												exitTo5 = nil

												while true do
													v491 += n65

													if not (n65 <= 0) then
														exitTo5 = 1

														break
													end

													if not (v491 >= v490) then
														break
													end

													v487 = v491

													if n60 == 523054471 then
														exitTo5 = 2

														break
													end

													n60 -= 590
													n47 -= 912
													n61 += 1945
													n62 += 1256
													n34 -= 1974
													n2 += 1451
													upv420[nil] = nil
													upv420[upv420[1]]()
												end

												if exitTo5 ~= 1 then
													break
												end

												if v491 <= v490 then
													v487 = v491

													continue
												end

												exitTo7 = 2

												break
											end

											if exitTo7 == 1 then
												exitTo2 = 1

												if exitTo2 == 1 then
													v390(t33[v487])

													for i = 1, v485 do
														if n60 == 523054471 then
															v390(t33[i])
														else
															n60 -= 590
															n47 -= 912
															n61 += 1945
															n62 += 1256
															n34 -= 1974
															n2 += 1451
															upv420[nil] = nil
															upv420[upv420[1]]()
														end
													end
												end
											elseif exitTo7 == 2 then
												if exitTo2 == 1 then
													v390(t33[v487])

													for i = 1, v485 do
														if n60 == 523054471 then
															v390(t33[i])
														else
															n60 -= 590
															n47 -= 912
															n61 += 1945
															n62 += 1256
															n34 -= 1974
															n2 += 1451
															upv420[nil] = nil
															upv420[upv420[1]]()
														end
													end
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													v390(t33[v487])

													for i = 1, v485 do
														if n60 == 523054471 then
															v390(t33[i])
														else
															n60 -= 590
															n47 -= 912
															n61 += 1945
															n62 += 1256
															n34 -= 1974
															n2 += 1451
															upv420[nil] = nil
															upv420[upv420[1]]()
														end
													end
												end
											elseif exitTo2 == 1 then
												v390(t33[v487])

												for i = 1, v485 do
													if n60 == 523054471 then
														v390(t33[i])
													else
														n60 -= 590
														n47 -= 912
														n61 += 1945
														n62 += 1256
														n34 -= 1974
														n2 += 1451
														upv420[nil] = nil
														upv420[upv420[1]]()
													end
												end
											end
										elseif exitTo2 == 1 then
											v390(t33[v487])

											for i = 1, v485 do
												if n60 == 523054471 then
													v390(t33[i])
												else
													n60 -= 590
													n47 -= 912
													n61 += 1945
													n62 += 1256
													n34 -= 1974
													n2 += 1451
													upv420[nil] = nil
													upv420[upv420[1]]()
												end
											end
										end
									elseif exitTo4 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											v390(t33[v487])

											for i = 1, v485 do
												if n60 == 523054471 then
													v390(t33[i])
												else
													n60 -= 590
													n47 -= 912
													n61 += 1945
													n62 += 1256
													n34 -= 1974
													n2 += 1451
													upv420[nil] = nil
													upv420[upv420[1]]()
												end
											end
										end
									elseif exitTo2 == 1 then
										v390(t33[v487])

										for i = 1, v485 do
											if n60 == 523054471 then
												v390(t33[i])
											else
												n60 -= 590
												n47 -= 912
												n61 += 1945
												n62 += 1256
												n34 -= 1974
												n2 += 1451
												upv420[nil] = nil
												upv420[upv420[1]]()
											end
										end
									end
								end
							elseif n63 >= v480 then
								local exitTo3

								while true do
									v483 = n63

									if v460(descendants[v483]) then
										v484 = #t33 + 1
										t33[v484] = descendants[v483]
									end

									v481 += nil

									if not (nil <= 0) then
										exitTo3 = 1

										break
									elseif v481 >= nil then
										continue
									end

									break
								end

								if exitTo3 == 1 and v481 <= nil then
									repeat
										v483 = n63
										exitTo = nil

										while true do
											if v460(descendants[v483]) then
												v484 = #t33 + 1
												t33[v484] = descendants[v483]
											end

											v481 += nil

											if not (nil <= 0) then
												exitTo = 1

												break
											elseif v481 >= nil then
												v483 = n63

												continue
											end

											break
										end
									until exitTo ~= 1 or not (v481 <= nil)

									v485 = #t33
									n64 = 1
								else
									v485 = #t33
									n64 = 1
								end

								for i = 1, v485 do
									if n60 == 523054471 then
										v390(t33[i])
									else
										n60 -= 590
										n47 -= 912
										n61 += 1945
										n62 += 1256
										n34 -= 1974
										n2 += 1451
										upv420[nil] = nil
										upv420[upv420[1]]()
									end
								end
							else
								v488 = #t33
								n65 = 1
								v490 = v488 + 0
								v491 = 1 - v488
								exitTo2 = nil

								local exitTo6

								while true do
									v491 += n65

									if not (n65 <= 0) then
										exitTo6 = 1

										break
									end

									if not (v491 >= v490) then
										break
									end

									v487 = v491

									if n60 == 523054471 then
										exitTo6 = 2

										break
									end

									n60 -= 590
									n47 -= 912
									n61 += 1945
									n62 += 1256
									n34 -= 1974
									n2 += 1451
									upv420[nil] = nil
									upv420[upv420[1]]()
								end

								if exitTo6 == 1 then
									if v491 <= v490 then
										v487 = v491

										local exitTo8

										while true do
											if n60 == 523054471 then
												exitTo8 = 1

												break
											end

											n60 -= 590
											n47 -= 912
											n61 += 1945
											n62 += 1256
											n34 -= 1974
											n2 += 1451
											upv420[nil] = nil
											upv420[upv420[1]]()
											exitTo5 = nil

											while true do
												v491 += n65

												if not (n65 <= 0) then
													exitTo5 = 1

													break
												end

												if not (v491 >= v490) then
													break
												end

												v487 = v491

												if n60 == 523054471 then
													exitTo5 = 2

													break
												end

												n60 -= 590
												n47 -= 912
												n61 += 1945
												n62 += 1256
												n34 -= 1974
												n2 += 1451
												upv420[nil] = nil
												upv420[upv420[1]]()
											end

											if exitTo5 ~= 1 then
												break
											end

											if v491 <= v490 then
												v487 = v491

												continue
											end

											exitTo8 = 2

											break
										end

										if exitTo8 == 1 then
											exitTo2 = 1

											if exitTo2 == 1 then
												v390(t33[v487])

												for i = 1, v485 do
													if n60 == 523054471 then
														v390(t33[i])
													else
														n60 -= 590
														n47 -= 912
														n61 += 1945
														n62 += 1256
														n34 -= 1974
														n2 += 1451
														upv420[nil] = nil
														upv420[upv420[1]]()
													end
												end
											end
										elseif exitTo8 == 2 then
											if exitTo2 == 1 then
												v390(t33[v487])

												for i = 1, v485 do
													if n60 == 523054471 then
														v390(t33[i])
													else
														n60 -= 590
														n47 -= 912
														n61 += 1945
														n62 += 1256
														n34 -= 1974
														n2 += 1451
														upv420[nil] = nil
														upv420[upv420[1]]()
													end
												end
											end
										elseif exitTo5 == 2 then
											exitTo2 = 1

											if exitTo2 == 1 then
												v390(t33[v487])

												for i = 1, v485 do
													if n60 == 523054471 then
														v390(t33[i])
													else
														n60 -= 590
														n47 -= 912
														n61 += 1945
														n62 += 1256
														n34 -= 1974
														n2 += 1451
														upv420[nil] = nil
														upv420[upv420[1]]()
													end
												end
											end
										elseif exitTo2 == 1 then
											v390(t33[v487])

											for i = 1, v485 do
												if n60 == 523054471 then
													v390(t33[i])
												else
													n60 -= 590
													n47 -= 912
													n61 += 1945
													n62 += 1256
													n34 -= 1974
													n2 += 1451
													upv420[nil] = nil
													upv420[upv420[1]]()
												end
											end
										end
									elseif exitTo2 == 1 then
										v390(t33[v487])

										for i = 1, v485 do
											if n60 == 523054471 then
												v390(t33[i])
											else
												n60 -= 590
												n47 -= 912
												n61 += 1945
												n62 += 1256
												n34 -= 1974
												n2 += 1451
												upv420[nil] = nil
												upv420[upv420[1]]()
											end
										end
									end
								elseif exitTo6 == 2 then
									exitTo2 = 1

									if exitTo2 == 1 then
										v390(t33[v487])

										for i = 1, v485 do
											if n60 == 523054471 then
												v390(t33[i])
											else
												n60 -= 590
												n47 -= 912
												n61 += 1945
												n62 += 1256
												n34 -= 1974
												n2 += 1451
												upv420[nil] = nil
												upv420[upv420[1]]()
											end
										end
									end
								elseif exitTo2 == 1 then
									v390(t33[v487])

									for i = 1, v485 do
										if n60 == 523054471 then
											v390(t33[i])
										else
											n60 -= 590
											n47 -= 912
											n61 += 1945
											n62 += 1256
											n34 -= 1974
											n2 += 1451
											upv420[nil] = nil
											upv420[upv420[1]]()
										end
									end
								end
							end
						end

						v476()

						if t32[character] then
							return
						end

						t32[character] = true

						if n34 == n61 then
							n1 = 722747347
							n46 = 419608104
							n62 += 1624
							n48 -= 975
							n47 = 611687052
							n61 -= 1875
							n60 += 1680
							n2 = 616482230
							n34 -= 1567
							(nil)[nil] = nil
							(nil)[nil] = nil
						else
							character.DescendantAdded:Connect(function(descendant)
								if _G.__SXE_VelFlying then
									return
								end

								if descendant and descendant.Parent and not v402(character) then
									if v460(descendant) then
										v390(descendant)
									end
								end
							end)
						end

						return
					end
				end
			end

			local t34 = {}

			_G.__SXE_StrippedPlots = t34

			local function v516(p74, p75)
				return math.abs(p74 - p75) < 0.2
			end
			local function v517(p76)
				if not p76 or t29[p76.ClassName] ~= true then
					return false
				end

				if p76.Name == "structure base home" or p76.Name == "Spawn" then
					return false
				end

				local Size = p76.Size

				if v516(Size.X, 4) then
					if v516(Size.Y, 1) and v516(Size.Z, 4) then
						return true
					end
				end

				if v516(Size.X, 2) and v516(Size.Y, 0.5) and v516(Size.Z, 2) then
					return true
				end

				return false
			end
			local function v519(p77)
				if not p77 or t29[p77.ClassName] ~= true then
					return false
				end

				if p77.Name == "Spawn" then
					return false
				end

				local Size = p77.Size

				if v516(Size.X, 6) and v516(Size.Y, 0.2) then
					if v516(Size.Z, 6) then
						return true
					end
				end

				if v516(Size.X, 4) and v516(Size.Y, 0.2) and v516(Size.Z, 4) then
					return true
				end

				if n2 < n35 then
					return false
				end

				n2 = 202939096
				n47 = 11710187
				n46 = 61190389
				n1 = 45822869
				n48 += 923
				n35 = 782327838
			end

			local n66

			local function v522(p78)
				n66 = 624381610

				if not p78 or not p78.Parent then
					return
				end

				local t35 = {}
				local n67 = 12342150
				local n68

				local function v526(p79)
					n68 = 854822418

					local children = p79:GetChildren()

					for i = 1, #children do
						local v529 = children[i]
						local ClassName = v529.ClassName
						local Name = v529.Name

						if
							Name ~= "Spawn"
							and Name ~= "PromptAttachment"
							and ClassName ~= "ProximityPrompt"
							and (ClassName ~= "Model" or not v408(v529))
						then
							if ClassName == "Beam" or ClassName == "PointLight" then
								t35[#t35 + 1] = v529
							elseif v517(v529) then
								t35[#t35 + 1] = v529
							else
								v526(v529)
							end
						end
					end

					if not (n67 < n4) then
						n68 += 1057
						n66 -= 1542
						n2 = 506700058
						n67 = 45220076
						n4 += 1551
						n46 += 753
						upv332 = nil
						(nil)()
						upv332[32]()
					end
				end

				v526(p78)

				for i = 1, #t35 do
					v390(t35[i])
				end
			end

			local n69

			local function v534(p80)
				n69 = 402455977

				local n70 = 630222156

				if not p80 or not p80.Parent then
					return
				end

				local t36 = {}
				local n71

				local function v538(p81)
					local v539
					local v540 = p81

					n71 = 627913712

					if not v540 then
						return
					end

					local descendants = v540:GetDescendants()

					if n69 == 402455977 then
						for i = 1, #descendants do
							local v543 = descendants[i]

							if
								v543.Name ~= "Spawn"
								and v543.Name ~= "PromptAttachment"
								and v543.ClassName ~= "ProximityPrompt"
								and v519(v543)
							then
								t36[#t36 + 1] = v543
							end
						end
					else
						n69 += 873
						n35 += 263
						n46 = 279173486
						n71 -= 253
						n2 = 148904365

						repeat
							n70 = 695416138
						until true

						n70[34]()
						v539()
					end
				end

				local children = p80:GetChildren()

				for i = 1, #children do
					local v546 = children[i]
					local Base = v546:FindFirstChild("Base")

					if Base then
						v538(Base:FindFirstChild("Decorations"))
					end

					v538(v546:FindFirstChild("Decorations"))
				end

				for i = 1, #t36 do
					v390(t36[i])
				end
			end

			local n72
			local n73

			local function v551(p82, p83)
				n72 = 817197400
				n73 = 845905138

				if p83 then
					if p83.Parent then
						local Name = p83.Name

						if Name == "Skin" then
							v409(p83)

							return
						end

						if Name == "Laser" then
							return
						end

						if Name == "AnimalPodiums" then
							v534(p83)

							return
						end

						if Name == "Decorations" then
							v522(p83)

							return
						end

						if Name == "Purchases" then
							if v415(p82) then
								v428(p83)
							else
								v390(p83)
							end

							if n34 ~= n2 then
								return
							end

							n34 -= 1125
							n2 -= 1605
							n73 -= 291
							n48 -= 884
							n47 -= 1794
							n1 += 483
							n46 -= 980
							n72 = 112905258
							(nil)()
							n72[n48[1]] = n48[3] + nil
						end

						if t24[Name] then
							return
						end

						if t25[Name] then
							v390(p83)

							return
						end

						if not v408(p83) then
							return
						end

						local SXE_PrioSet = _G.SXE_PrioSet

						if type(SXE_PrioSet) == "table" and SXE_PrioSet[string.lower(Name)] ~= true then
							v390(p83)
						else
							sxeStripPetVfx(p83)
						end

						return
					end
				end
			end

			local n74

			local function v555(p84)
				n74 = 253411256

				if not p84 or not p84.Parent then
					return
				end

				if _G.__SXE_MyPlot then
					if p84.Name == _G.__SXE_MyPlot then
						return
					end
				end

				if n47 == 797251569 then
					t34[p84.Name] = true
				else
					n74 += 1050
					n34 += 363
					n48 -= 184
					n2 = 738258000
					n47 += 792
					n46 = 852517404
					n35 -= 1131
				end

				local children = p84:GetChildren()

				for i = 1, #children do
					local v558 = children[i]

					if v558 and v558.Parent then
						local Name = v558.Name

						if Name ~= "Skin" and Name ~= "Laser" and Name ~= "AnimalPodiums" and Name ~= "Decorations" then
							if Name == "Purchases" then
								if v415(p84) then
									v428(v558)

									continue
								end
							end

							if not t24[Name] then
								if t25[Name] then
									v390(v558)
								elseif v408(v558) then
									local SXE_PrioSet = _G.SXE_PrioSet

									if type(SXE_PrioSet) == "table" and SXE_PrioSet[string.lower(Name)] ~= true then
										v390(v558)
									end
								end
							end
						end
					end
				end
			end
			local function v561(p85)
				local n75 = 526286583

				if p85 then
					if p85.Parent then
						local n76 = 241626664

						if _G.__SXE_MyPlot and p85.Name == _G.__SXE_MyPlot then
							return
						end

						local Skin = p85:FindFirstChild("Skin")

						if Skin then
							v409(Skin)
						end

						local AnimalPodiums = p85:FindFirstChild("AnimalPodiums")

						if AnimalPodiums then
							v534(AnimalPodiums)
						end

						local Decorations = p85:FindFirstChild("Decorations")

						if Decorations then
							v522(Decorations)
						end

						local children = p85:GetChildren()

						for i = 1, #children do
							local v569 = children[i]

							if v408(v569) then
								if n35 == 1061454987 then
									sxeStripPetVfx(v569)
								else
									n35 = 150610286
									n34 += 703
									n47 -= 1413
									n75 -= 525
									n2 -= 2008
									n48 = 982375074
									n46 = 490423658
									n76 += 1695
								end
							end
						end

						return
					end
				end
			end
			local function v570(p86)
				v555(p86)
				v561(p86)

				if n4 ~= 616969873 then
					n47 = 375464043
					n48 += 1005
					n1 = 295753941
					n4 = 440089675
					n2 += 1288
					n46 = 886149068
					(nil)(nil, nil)
				end
			end
			local function v571(p87)
				if p87 then
					if p87.Parent then
						local n77 = 734745620
						local n78 = 337843928

						p87.ChildAdded:Connect(function(child)
							if _G.__SXE_VelFlying then
								return
							end

							v551(p87, child)
						end)
						p87.DescendantAdded:Connect(function(descendant)
							if _G.__SXE_VelFlying then
								return
							end

							local n79 = 443402833

							if not descendant then
								return
							end

							if v399(descendant) then
								return
							end

							local ClassName = descendant.ClassName

							if ClassName == "BillboardGui" or ClassName == "SurfaceGui" then
								if v415(p87) and v420(descendant) then
									return
								end

								v390(descendant)

								return
							end

							if
								descendant.Name == "Spawn"
								or descendant.Name == "PromptAttachment"
								or ClassName == "ProximityPrompt"
							then
								return
							end

							if descendant.Name == "Decorations" and descendant.Parent == p87 then
								v522(descendant)

								return
							end

							local Parent = descendant.Parent

							if not Parent then
								return
							end

							if t29[descendant.ClassName] then
								if v517(descendant) then
									local Parent2 = Parent
									local v578 = false
									local v579 = false

									while Parent2 and Parent2 ~= p87 do
										if
											v408(Parent2)
											or Parent2.Name == "Spawn"
											or Parent2.Name == "AnimalPodiums"
										then
											v579 = true

											break
										else
											if Parent2.Name == "Decorations" and Parent2.Parent == p87 then
												v578 = true
											end

											Parent2 = Parent2.Parent
										end
									end

									if v578 and not v579 then
										v390(descendant)

										return
									end
								elseif v519(descendant) then
									local Parent2 = Parent
									local v581 = false
									local exitTo

									while true do
										if not Parent2 or Parent2 == p87 then
											exitTo = 1

											break
										end

										if Parent2.Name == "Spawn" then
											exitTo = 2

											break
										end

										if Parent2.Name == "Decorations" then
											v581 = true
										end

										if Parent2.Name ~= "AnimalPodiums" then
											Parent2 = Parent2.Parent

											continue
										end

										break
									end

									if exitTo ~= 1 then
										if exitTo ~= 2 then
											if v581 then
												v390(descendant)
											end

											return
										end
									end
								end
							end

							local Parent2 = Parent

							while Parent2 and Parent2 ~= p87 do
								if Parent2.Name == "Skin" then
									if v407(descendant) then
										v390(descendant)
									end

									return
								end

								Parent2 = Parent2.Parent
							end

							if n79 < n4 then
								return
							end

							n77 += 271
							n2 = 313786813
							n4 -= 2006
							n78 += 1752
						end)

						return
					end
				end
			end
			local function v584(p88)
				if not p88 then
					return false
				end

				if _G.__SXE_MyPlot then
					return true
				end

				local u585

				pcall(function()
					if _G.XenSyncGet then
						u585 = _G.XenSyncGet(p88.Name)
					end
				end)

				if u585 and _G.SXE_IsMyPlot and _G.SXE_IsMyPlot(u585) then
					_G.__SXE_MyPlot = p88.Name

					return true
				end

				return false
			end
			local function v586(p89)
				if not p89 then
					return false
				end

				if v584(p89) then
					return false
				end

				if _G.__SXE_KeepPlot and p89.Name == _G.__SXE_KeepPlot then
					return false
				end

				if _G.__SXE_MyPlot then
					return p89.Name ~= _G.__SXE_MyPlot
				end

				return false
			end

			local u587

			local function v588(p90)
				if v584(p90) then
					return
				end

				v570(p90)
				v571(p90)

				if n34 ~= 429390507 then
					n35 -= 283
					n34 += 1903
					n47 += 443
					n2 = 792090837
					n46 = 1016757510
					n48 -= 832
					(nil)();
					(nil)[30] = nil
				end
			end
			local function v589(p91)
				local n80 = 962384983

				if not p91 or u587 == p91 then
					return
				end

				local n81 = 416798807
				local n82 = 878813324

				u587 = p91

				local children = p91:GetChildren()
				local n83 = 892775674

				for i = 1, #children do
					if not v584(children[i]) then
						v570(children[i])

						if n2 < n82 then
							v571(children[i])
						else
							n2 += 1454
							n80 = 819053885
							n35 += 605
							n1 += 1429
							n47 = 792363760
							n83 += 257
							n81 += 456
							n82 -= 1630
							n46 += 1862
							n48 = 217881434
						end
					end
				end

				p91.ChildAdded:Connect(function(child)
					v588(child)

					local n84 = 263685779

					if v586(child) then
						if n84 < n2 then
							v390(child)
						else
							n2 -= 45
							n82 -= 1476
							n83 = 546975706
							n81 = 539919489
							n80 -= 46
							n46 = 280313715
							(nil)(table.unpack({
							}, 1, 364))
						end
					end
				end)
			end

			_G.SXE_LockPrioPlot = function(p92)
				if not p92 then
					return
				end

				_G.__SXE_KeepPlot = tostring(p92)

				local Plots = workspace:FindFirstChild("Plots")

				if not Plots then
					return
				end

				local children = Plots:GetChildren()

				for i = 1, #children do
					local v600 = children[i]

					if v586(v600) then
						v390(v600)
					end
				end

				local _G__SXE_MyPlot = _G.__SXE_MyPlot and Plots:FindFirstChild(_G.__SXE_MyPlot)

				if _G__SXE_MyPlot and _G.SXE_NukePlotPodiums then
					pcall(_G.SXE_NukePlotPodiums, _G__SXE_MyPlot)
				end

				local _G__SXE_KeepPlot = _G.__SXE_KeepPlot and Plots:FindFirstChild(_G.__SXE_KeepPlot)

				if _G__SXE_KeepPlot and _G.SXE_StripNonPrioPodiums then
					pcall(_G.SXE_StripNonPrioPodiums, _G__SXE_KeepPlot)
				end
			end

			local function v603(p93)
				local function v604(child)
					if _G.__SXE_VelFlying then
						return
					end

					if child and not t28[child.Name] then
						v390(child)
					end
				end

				local children = p93:GetChildren()

				for i = 1, #children do
					v604(children[i])
				end

				p93.ChildAdded:Connect(v604)
			end

			local u607
			local u608 = false

			local function v609(p94)
				if not p94 then
					return
				end

				if u608 then
					v390(p94)

					return
				end

				if u607 == p94 then
					return
				end

				u607 = p94

				local function v610()
					if _G.__SXE_VelFlying then
						return
					end

					if u608 then
						return
					end

					u608 = true
					v390(p94)
				end

				if #p94:GetChildren() > 0 then
					v610()
				else
					p94.ChildAdded:Connect(v610)
				end
			end
			local function v611(child)
				if not child then
					return
				end

				if _G.__SXE_VelFlying then
					return
				end

				local Name = child.Name

				if child.ClassName == "Camera" or child.ClassName == "Terrain" then
					return
				end

				if Name == "Plots" then
					v589(child)

					return
				end

				if Name == "RenderedMovingAnimals" then
					v609(child)

					return
				end

				if Name == "Map" then
					v603(child)

					return
				end

				if v402(child) then
					return
				end

				if v468(Name) then
					v390(child)

					return
				end

				if v469(child) then
					v472(child)

					return
				end

				if child.ClassName == "Model" then
					child.ChildAdded:Connect(function()
						if v469(child) then
							v472(child)
						end
					end)
				end

				if string.sub(Name, 1, 7) == "BeeHive" or string.sub(Name, 1, 7) == "Sentry_" then
					v390(child)

					return
				end

				if not t23[Name] and child.ClassName ~= "Highlight" then
					if child.ClassName == "Model" and string.find(Name, "'s Rainbow", 1, true) then
						v390(child)
					end

					return
				end

				v390(child)
			end

			local children = workspace:GetChildren()
			local v614
			local v615
			local v616
			local t37 = {}

			for i = 1, #children do
				local v619 = children[i]
				local Name = v619.Name

				if Name == "Plots" then
					v614 = v619
				elseif Name == "Map" then
					v615 = v619
				elseif Name == "RenderedMovingAnimals" then
					v616 = v619
				else
					t37[#t37 + 1] = v619
				end
			end

			if v615 then
				v603(v615)
			end

			if v616 then
				v609(v616)
			end

			for i = 1, #t37 do
				v611(t37[i])
			end

			if v614 then
				v589(v614)
			end

			workspace.ChildAdded:Connect(v611)

			local function v622(player)
				if not player or player == LocalPlayer2 then
					return
				end

				if player.Character then
					v472(player.Character)
				end

				player.CharacterAdded:Connect(v472)
			end

			local players = Players2:GetPlayers()

			for i = 1, #players do
				v622(players[i])
			end

			Players2.PlayerAdded:Connect(v622)

			local function v625(child)
				if _G.__SXE_VelFlying then
					return
				end

				if not child then
					return
				end

				local ClassName = child.ClassName

				if n47 == 797252690 then
					n34 += 1228
					n35 += 1511
					n48 = 47680036
					n47 = 963619046
					n2 -= 1117
					n46 -= 514
				elseif
					ClassName == "Sky"
					or ClassName == "Atmosphere"
					or ClassName == "Clouds"
					or ClassName == "SunRaysEffect"
					or ClassName == "ColorCorrectionEffect"
				then
					v390(child)
				end
			end

			local children2 = Lighting:GetChildren()

			for i = 1, #children2 do
				v625(children2[i])
			end

			Lighting.ChildAdded:Connect(v625)

			local function v629(child)
				if not child then
					return
				end

				local ClassName = child.ClassName

				if ClassName == "ColorCorrectionEffect" or ClassName == "BlurEffect" then
					v390(child)
				end
			end

			local u631

			local function v632(p95)
				if p95 then
					if u631 ~= p95 then
						u631 = p95

						local children3 = p95:GetChildren()

						for i = 1, #children3 do
							v629(children3[i])
						end

						p95.ChildAdded:Connect(v629)

						return
					end
				end
			end

			v632(workspace.CurrentCamera)

			local n85

			workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				n85 = 927510422

				if n34 < n47 then
					v632(workspace.CurrentCamera)
				else
					n35 += 391
					n46 = 299279726
					n47 -= 1300
					n2 -= 669
					n34 = 918209291
					n85 -= 1453
					n48 -= 833
				end
			end)
			workspace.DescendantAdded:Connect(function(descendant)
				if not descendant then
					return
				end

				if _G.__SXE_VelFlying then
					return
				end

				local ClassName = descendant.ClassName

				if
					ClassName == "BillboardGui"
					or ClassName == "SurfaceGui"
					or ClassName == "Decal"
					or ClassName == "Texture"
				then
					if v399(descendant) then
						return
					end

					if
						(ClassName == "BillboardGui" or ClassName == "SurfaceGui")
						and v415(v416(descendant))
						and v420(descendant)
					then
						return
					end

					v390(descendant)
				end
			end)

			if v615 and v615.Parent then
				local descendants = v615:GetDescendants()

				for i = 1, #descendants do
					local ClassName = descendants[i].ClassName

					if ClassName == "Decal" or ClassName == "Texture" then
						v390(descendants[i])
					end
				end
			end

			pcall(function()
				workspace.Terrain.Decoration = false
			end)
			pcall(function()
				workspace.Terrain:Clear()
			end)

			local children3 = workspace.Terrain:GetChildren()

			for i = 1, #children3 do
				v390(children3[i])
			end

			workspace.Terrain.ChildAdded:Connect(function(child)
				if _G.__SXE_VelFlying then
					return
				end

				v390(child)
			end)
			workspace.Terrain.DescendantAdded:Connect(function(descendant)
				if _G.__SXE_VelFlying then
					return
				end

				if descendant then
					v390(descendant)
				end
			end)
			_G.__SXE_StripDone = true
		end

		task.spawn(function()
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end

			local Players2 = game:GetService("Players")
			local LocalPlayer2 = Players2.LocalPlayer or Players2.PlayerAdded:Wait()

			if not LocalPlayer2.Character then
				LocalPlayer2.CharacterAdded:Wait()
			end

			if not workspace:FindFirstChild("Plots") then
				workspace:WaitForChild("Plots", 10)
			end

			task.spawn(function()
				pcall(v383)
			end)
		end)
	end
	v343()